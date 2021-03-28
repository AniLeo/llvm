//===- MVELaneInterleaving.cpp - Inverleave for MVE instructions ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass interleaves around sext/zext/trunc instructions. MVE does not have
// a single sext/zext or trunc instruction that takes the bottom half of a
// vector and extends to a full width, like NEON has with MOVL. Instead it is
// expected that this happens through top/bottom instructions. So the MVE
// equivalent VMOVLT/B instructions take either the even or odd elements of the
// input and extend them to the larger type, producing a vector with half the
// number of elements each of double the bitwidth. As there is no simple
// instruction, we often have to turn sext/zext/trunc into a series of lane
// moves (or stack loads/stores, which we do not do yet).
//
// This pass takes vector code that starts at truncs, looks for interconnected
// blobs of operations that end with sext/zext (or constants/splats) of the
// form:
//   %sa = sext v8i16 %a to v8i32
//   %sb = sext v8i16 %b to v8i32
//   %add = add v8i32 %sa, %sb
//   %r = trunc %add to v8i16
// And adds shuffles to allow the use of VMOVL/VMOVN instrctions:
//   %sha = shuffle v8i16 %a, undef, <0, 2, 4, 6, 1, 3, 5, 7>
//   %sa = sext v8i16 %sha to v8i32
//   %shb = shuffle v8i16 %b, undef, <0, 2, 4, 6, 1, 3, 5, 7>
//   %sb = sext v8i16 %shb to v8i32
//   %add = add v8i32 %sa, %sb
//   %r = trunc %add to v8i16
//   %shr = shuffle v8i16 %r, undef, <0, 4, 1, 5, 2, 6, 3, 7>
// Which can then be split and lowered to MVE instructions efficiently:
//   %sa_b = VMOVLB.s16 %a
//   %sa_t = VMOVLT.s16 %a
//   %sb_b = VMOVLB.s16 %b
//   %sb_t = VMOVLT.s16 %b
//   %add_b = VADD.i32 %sa_b, %sb_b
//   %add_t = VADD.i32 %sa_t, %sb_t
//   %r = VMOVNT.i16 %add_b, %add_t
//
//===----------------------------------------------------------------------===//

#include "ARM.h"
#include "ARMBaseInstrInfo.h"
#include "ARMSubtarget.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsARM.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/Casting.h"
#include <algorithm>
#include <cassert>

using namespace llvm;

#define DEBUG_TYPE "mve-laneinterleave"

cl::opt<bool> EnableInterleave(
    "enable-mve-interleave", cl::Hidden, cl::init(true),
    cl::desc("Enable interleave MVE vector operation lowering"));

namespace {

class MVELaneInterleaving : public FunctionPass {
public:
  static char ID; // Pass identification, replacement for typeid

  explicit MVELaneInterleaving() : FunctionPass(ID) {
    initializeMVELaneInterleavingPass(*PassRegistry::getPassRegistry());
  }

  bool runOnFunction(Function &F) override;

  StringRef getPassName() const override { return "MVE lane interleaving"; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesCFG();
    AU.addRequired<TargetPassConfig>();
    FunctionPass::getAnalysisUsage(AU);
  }
};

} // end anonymous namespace

char MVELaneInterleaving::ID = 0;

INITIALIZE_PASS(MVELaneInterleaving, DEBUG_TYPE, "MVE lane interleaving", false,
                false)

Pass *llvm::createMVELaneInterleavingPass() {
  return new MVELaneInterleaving();
}

static bool isProfitableToInterleave(SmallSetVector<Instruction *, 4> &Exts,
                                     SmallSetVector<Instruction *, 4> &Truncs) {
  // This is not always beneficial to transform. Exts can be incorporated into
  // loads, Truncs can be folded into stores.
  // Truncs are usually the same number of instructions,
  //  VSTRH.32(A);VSTRH.32(B) vs VSTRH.16(VMOVNT A, B) with interleaving
  // Exts are unfortunately more instructions in the general case:
  //  A=VLDRH.32; B=VLDRH.32;
  // vs with interleaving:
  //  T=VLDRH.16; A=VMOVNB T; B=VMOVNT T
  // But those VMOVL may be folded into a VMULL.

  // But expensive extends/truncs are always good to remove.
  for (auto *E : Exts)
    if (!isa<LoadInst>(E->getOperand(0))) {
      LLVM_DEBUG(dbgs() << "Beneficial due to " << *E << "\n");
      return true;
    }
  for (auto *T : Truncs)
    if (T->hasOneUse() && !isa<StoreInst>(*T->user_begin())) {
      LLVM_DEBUG(dbgs() << "Beneficial due to " << *T << "\n");
      return true;
    }

  // Otherwise, we know we have a load(ext), see if any of the Extends are a
  // vmull. This is a simple heuristic and certainly not perfect.
  for (auto *E : Exts) {
    if (!E->hasOneUse() ||
        cast<Instruction>(*E->user_begin())->getOpcode() != Instruction::Mul) {
      LLVM_DEBUG(dbgs() << "Not beneficial due to " << *E << "\n");
      return false;
    }
  }
  return true;
}

static bool tryInterleave(Instruction *Start,
                          SmallPtrSetImpl<Instruction *> &Visited) {
  LLVM_DEBUG(dbgs() << "tryInterleave from " << *Start << "\n");
  auto *VT = cast<FixedVectorType>(Start->getType());

  if (!isa<Instruction>(Start->getOperand(0)))
    return false;

  // Look for connected operations starting from Ext's, terminating at Truncs.
  std::vector<Instruction *> Worklist;
  Worklist.push_back(Start);
  Worklist.push_back(cast<Instruction>(Start->getOperand(0)));

  SmallSetVector<Instruction *, 4> Truncs;
  SmallSetVector<Instruction *, 4> Exts;
  SmallSetVector<Instruction *, 4> Ops;

  while (!Worklist.empty()) {
    Instruction *I = Worklist.back();
    Worklist.pop_back();

    switch (I->getOpcode()) {
    // Truncs
    case Instruction::Trunc:
      if (Truncs.count(I))
        continue;
      Truncs.insert(I);
      Visited.insert(I);
      break;

    // Extend leafs
    case Instruction::SExt:
    case Instruction::ZExt:
      if (Exts.count(I))
        continue;
      for (auto *Use : I->users())
        Worklist.push_back(cast<Instruction>(Use));
      Exts.insert(I);
      break;

    // Binary/tertiary ops
    case Instruction::Add:
    case Instruction::Sub:
    case Instruction::Mul:
    case Instruction::AShr:
    case Instruction::LShr:
    case Instruction::Shl:
    case Instruction::ICmp:
    case Instruction::Select:
      if (Ops.count(I))
        continue;
      Ops.insert(I);

      for (Use &Op : I->operands()) {
        if (isa<Instruction>(Op))
          Worklist.push_back(cast<Instruction>(&Op));
        else
          return false;
      }

      for (auto *Use : I->users())
        Worklist.push_back(cast<Instruction>(Use));
      break;

    default:
      LLVM_DEBUG(dbgs() << "  Unhandled instruction: " << *I << "\n");
      return false;
    }
  }

  LLVM_DEBUG({
    dbgs() << "Found group:\n  Exts:";
    for (auto *I : Exts)
      dbgs() << "  " << *I << "\n";
    dbgs() << "  Ops:";
    for (auto *I : Ops)
      dbgs() << "  " << *I << "\n";
    dbgs() << "Truncs:";
    for (auto *I : Truncs)
      dbgs() << "  " << *I << "\n";
  });

  assert(!Truncs.empty() && "Expected some truncs");
  assert(!Exts.empty() && "Expected some leaves");

  // Check types
  unsigned NumElts = VT->getNumElements();
  unsigned BaseElts = VT->getScalarSizeInBits() == 16
                          ? 8
                          : (VT->getScalarSizeInBits() == 8 ? 16 : 0);
  if (BaseElts == 0 || NumElts % BaseElts != 0) {
    LLVM_DEBUG(dbgs() << "  Type is unsupported\n");
    return false;
  }
  if (Start->getOperand(0)->getType()->getScalarSizeInBits() !=
      VT->getScalarSizeInBits() * 2) {
    LLVM_DEBUG(dbgs() << "  Type not double sized\n");
    return false;
  }
  for (Instruction *I : Exts)
    if (I->getOperand(0)->getType() != VT) {
      LLVM_DEBUG(dbgs() << "  Wrong type on " << *I << "\n");
      return false;
    }
  for (Instruction *I : Truncs)
    if (I->getType() != VT) {
      LLVM_DEBUG(dbgs() << "  Wrong type on " << *I << "\n");
      return false;
    }

  // Check that it looks beneficial
  if (!isProfitableToInterleave(Exts, Truncs))
    return false;

  // Create new shuffles around the extends / truncs / other leaves.
  IRBuilder<> Builder(Start);

  SmallVector<int, 16> LeafMask;
  SmallVector<int, 16> TruncMask;
  // LeafMask : 0, 2, 4, 6, 1, 3, 5, 7   8, 10, 12, 14,  9, 11, 13, 15
  // TruncMask: 0, 4, 1, 5, 2, 6, 3, 7   8, 12,  9, 13, 10, 14, 11, 15
  for (unsigned Base = 0; Base < NumElts; Base += BaseElts) {
    for (unsigned i = 0; i < BaseElts / 2; i++)
      LeafMask.push_back(Base + i * 2);
    for (unsigned i = 0; i < BaseElts / 2; i++)
      LeafMask.push_back(Base + i * 2 + 1);
  }
  for (unsigned Base = 0; Base < NumElts; Base += BaseElts) {
    for (unsigned i = 0; i < BaseElts / 2; i++) {
      TruncMask.push_back(Base + i);
      TruncMask.push_back(Base + i + BaseElts / 2);
    }
  }

  for (Instruction *I : Exts) {
    LLVM_DEBUG(dbgs() << "Replacing ext " << *I << "\n");
    Builder.SetInsertPoint(I);
    Value *Shuffle = Builder.CreateShuffleVector(I->getOperand(0), LeafMask);
    bool Sext = isa<SExtInst>(I);
    Value *Ext = Sext ? Builder.CreateSExt(Shuffle, I->getType())
                      : Builder.CreateZExt(Shuffle, I->getType());
    I->replaceAllUsesWith(Ext);
    LLVM_DEBUG(dbgs() << "  with " << *Shuffle << "\n");
  }

  for (Instruction *I : Truncs) {
    LLVM_DEBUG(dbgs() << "Replacing trunc " << *I << "\n");

    Builder.SetInsertPoint(I->getParent(), ++I->getIterator());
    Value *Shuf = Builder.CreateShuffleVector(I, TruncMask);
    I->replaceAllUsesWith(Shuf);
    cast<Instruction>(Shuf)->setOperand(0, I);

    LLVM_DEBUG(dbgs() << "  with " << *Shuf << "\n");
  }

  return false;
}

bool MVELaneInterleaving::runOnFunction(Function &F) {
  if (!EnableInterleave)
    return false;
  auto &TPC = getAnalysis<TargetPassConfig>();
  auto &TM = TPC.getTM<TargetMachine>();
  auto *ST = &TM.getSubtarget<ARMSubtarget>(F);
  if (!ST->hasMVEIntegerOps())
    return false;

  bool Changed = false;

  SmallPtrSet<Instruction *, 16> Visited;
  for (Instruction &I : reverse(instructions(F))) {
    if (I.getType()->isVectorTy() &&
        (isa<TruncInst>(I) || isa<FPTruncInst>(I)) && !Visited.count(&I))
      Changed |= tryInterleave(&I, Visited);
  }

  return Changed;
}
