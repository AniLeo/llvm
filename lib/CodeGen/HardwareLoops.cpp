//===-- HardwareLoops.cpp - Target Independent Hardware Loops --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// Insert hardware loop intrinsics into loops which are deemed profitable by
/// the target, by querying TargetTransformInfo. A hardware loop comprises of
/// two intrinsics: one, outside the loop, to set the loop iteration count and
/// another, in the exit block, to decrement the counter. The decremented value
/// can either be carried through the loop via a phi or handled in some opaque
/// way by the target.
///
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/AssumptionCache.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Value.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/PassRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"

#define DEBUG_TYPE "hardware-loops"

#define HW_LOOPS_NAME "Hardware Loop Insertion"

using namespace llvm;

static cl::opt<bool>
ForceHardwareLoops("force-hardware-loops", cl::Hidden, cl::init(false),
                   cl::desc("Force hardware loops intrinsics to be inserted"));

static cl::opt<bool>
ForceHardwareLoopPHI(
  "force-hardware-loop-phi", cl::Hidden, cl::init(false),
  cl::desc("Force hardware loop counter to be updated through a phi"));

static cl::opt<bool>
ForceNestedLoop("force-nested-hardware-loop", cl::Hidden, cl::init(false),
                cl::desc("Force allowance of nested hardware loops"));

static cl::opt<unsigned>
LoopDecrement("hardware-loop-decrement", cl::Hidden, cl::init(1),
            cl::desc("Set the loop decrement value"));

static cl::opt<unsigned>
CounterBitWidth("hardware-loop-counter-bitwidth", cl::Hidden, cl::init(32),
                cl::desc("Set the loop counter bitwidth"));

static cl::opt<bool>
ForceGuardLoopEntry(
  "force-hardware-loop-guard", cl::Hidden, cl::init(false),
  cl::desc("Force generation of loop guard intrinsic"));

STATISTIC(NumHWLoops, "Number of loops converted to hardware loops");

#ifndef NDEBUG
static void debugHWLoopFailure(const StringRef DebugMsg,
    Instruction *I) {
  dbgs() << "HWLoops: " << DebugMsg;
  if (I)
    dbgs() << ' ' << *I;
  else
    dbgs() << '.';
  dbgs() << '\n';
}
#endif

static OptimizationRemarkAnalysis
createHWLoopAnalysis(StringRef RemarkName, Loop *L, Instruction *I) {
  Value *CodeRegion = L->getHeader();
  DebugLoc DL = L->getStartLoc();

  if (I) {
    CodeRegion = I->getParent();
    // If there is no debug location attached to the instruction, revert back to
    // using the loop's.
    if (I->getDebugLoc())
      DL = I->getDebugLoc();
  }

  OptimizationRemarkAnalysis R(DEBUG_TYPE, RemarkName, DL, CodeRegion);
  R << "hardware-loop not created: ";
  return R;
}

namespace {

  void reportHWLoopFailure(const StringRef Msg, const StringRef ORETag,
      OptimizationRemarkEmitter *ORE, Loop *TheLoop, Instruction *I = nullptr) {
    LLVM_DEBUG(debugHWLoopFailure(Msg, I));
    ORE->emit(createHWLoopAnalysis(ORETag, TheLoop, I) << Msg);
  }

  using TTI = TargetTransformInfo;

  class HardwareLoops : public FunctionPass {
  public:
    static char ID;

    HardwareLoops() : FunctionPass(ID) {
      initializeHardwareLoopsPass(*PassRegistry::getPassRegistry());
    }

    bool runOnFunction(Function &F) override;

    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.addRequired<LoopInfoWrapperPass>();
      AU.addPreserved<LoopInfoWrapperPass>();
      AU.addRequired<DominatorTreeWrapperPass>();
      AU.addPreserved<DominatorTreeWrapperPass>();
      AU.addRequired<ScalarEvolutionWrapperPass>();
      AU.addRequired<AssumptionCacheTracker>();
      AU.addRequired<TargetTransformInfoWrapperPass>();
      AU.addRequired<OptimizationRemarkEmitterWrapperPass>();
    }

    // Try to convert the given Loop into a hardware loop.
    bool TryConvertLoop(Loop *L);

    // Given that the target believes the loop to be profitable, try to
    // convert it.
    bool TryConvertLoop(HardwareLoopInfo &HWLoopInfo);

  private:
    ScalarEvolution *SE = nullptr;
    LoopInfo *LI = nullptr;
    const DataLayout *DL = nullptr;
    OptimizationRemarkEmitter *ORE = nullptr;
    const TargetTransformInfo *TTI = nullptr;
    DominatorTree *DT = nullptr;
    bool PreserveLCSSA = false;
    AssumptionCache *AC = nullptr;
    TargetLibraryInfo *LibInfo = nullptr;
    Module *M = nullptr;
    bool MadeChange = false;
  };

  class HardwareLoop {
    // Expand the trip count scev into a value that we can use.
    Value *InitLoopCount();

    // Insert the set_loop_iteration intrinsic.
    Value *InsertIterationSetup(Value *LoopCountInit);

    // Insert the loop_decrement intrinsic.
    void InsertLoopDec();

    // Insert the loop_decrement_reg intrinsic.
    Instruction *InsertLoopRegDec(Value *EltsRem);

    // If the target requires the counter value to be updated in the loop,
    // insert a phi to hold the value. The intended purpose is for use by
    // loop_decrement_reg.
    PHINode *InsertPHICounter(Value *NumElts, Value *EltsRem);

    // Create a new cmp, that checks the returned value of loop_decrement*,
    // and update the exit branch to use it.
    void UpdateBranch(Value *EltsRem);

  public:
    HardwareLoop(HardwareLoopInfo &Info, ScalarEvolution &SE,
                 const DataLayout &DL,
                 OptimizationRemarkEmitter *ORE) :
      SE(SE), DL(DL), ORE(ORE), L(Info.L), M(L->getHeader()->getModule()),
      ExitCount(Info.ExitCount),
      CountType(Info.CountType),
      ExitBranch(Info.ExitBranch),
      LoopDecrement(Info.LoopDecrement),
      UsePHICounter(Info.CounterInReg),
      UseLoopGuard(Info.PerformEntryTest) { }

    void Create();

  private:
    ScalarEvolution &SE;
    const DataLayout &DL;
    OptimizationRemarkEmitter *ORE = nullptr;
    Loop *L                 = nullptr;
    Module *M               = nullptr;
    const SCEV *ExitCount   = nullptr;
    Type *CountType         = nullptr;
    BranchInst *ExitBranch  = nullptr;
    Value *LoopDecrement    = nullptr;
    bool UsePHICounter      = false;
    bool UseLoopGuard       = false;
    BasicBlock *BeginBB     = nullptr;
  };
}

char HardwareLoops::ID = 0;

bool HardwareLoops::runOnFunction(Function &F) {
  if (skipFunction(F))
    return false;

  LLVM_DEBUG(dbgs() << "HWLoops: Running on " << F.getName() << "\n");

  LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
  SE = &getAnalysis<ScalarEvolutionWrapperPass>().getSE();
  DT = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  TTI = &getAnalysis<TargetTransformInfoWrapperPass>().getTTI(F);
  DL = &F.getParent()->getDataLayout();
  ORE = &getAnalysis<OptimizationRemarkEmitterWrapperPass>().getORE();
  auto *TLIP = getAnalysisIfAvailable<TargetLibraryInfoWrapperPass>();
  LibInfo = TLIP ? &TLIP->getTLI(F) : nullptr;
  PreserveLCSSA = mustPreserveAnalysisID(LCSSAID);
  AC = &getAnalysis<AssumptionCacheTracker>().getAssumptionCache(F);
  M = F.getParent();

  for (Loop *L : *LI)
    if (L->isOutermost())
      TryConvertLoop(L);

  return MadeChange;
}

// Return true if the search should stop, which will be when an inner loop is
// converted and the parent loop doesn't support containing a hardware loop.
bool HardwareLoops::TryConvertLoop(Loop *L) {
  // Process nested loops first.
  bool AnyChanged = false;
  for (Loop *SL : *L)
    AnyChanged |= TryConvertLoop(SL);
  if (AnyChanged) {
    reportHWLoopFailure("nested hardware-loops not supported", "HWLoopNested",
                        ORE, L);
    return true; // Stop search.
  }

  LLVM_DEBUG(dbgs() << "HWLoops: Loop " << L->getHeader()->getName() << "\n");

  HardwareLoopInfo HWLoopInfo(L);
  if (!HWLoopInfo.canAnalyze(*LI)) {
    reportHWLoopFailure("cannot analyze loop, irreducible control flow",
                        "HWLoopCannotAnalyze", ORE, L);
    return false;
  }

  if (!ForceHardwareLoops &&
      !TTI->isHardwareLoopProfitable(L, *SE, *AC, LibInfo, HWLoopInfo)) {
    reportHWLoopFailure("it's not profitable to create a hardware-loop",
                        "HWLoopNotProfitable", ORE, L);
    return false;
  }

  // Allow overriding of the counter width and loop decrement value.
  if (CounterBitWidth.getNumOccurrences())
    HWLoopInfo.CountType =
      IntegerType::get(M->getContext(), CounterBitWidth);

  if (LoopDecrement.getNumOccurrences())
    HWLoopInfo.LoopDecrement =
      ConstantInt::get(HWLoopInfo.CountType, LoopDecrement);

  MadeChange |= TryConvertLoop(HWLoopInfo);
  return MadeChange && (!HWLoopInfo.IsNestingLegal && !ForceNestedLoop);
}

bool HardwareLoops::TryConvertLoop(HardwareLoopInfo &HWLoopInfo) {

  Loop *L = HWLoopInfo.L;
  LLVM_DEBUG(dbgs() << "HWLoops: Try to convert profitable loop: " << *L);

  if (!HWLoopInfo.isHardwareLoopCandidate(*SE, *LI, *DT, ForceNestedLoop,
                                          ForceHardwareLoopPHI)) {
    // TODO: there can be many reasons a loop is not considered a
    // candidate, so we should let isHardwareLoopCandidate fill in the
    // reason and then report a better message here.
    reportHWLoopFailure("loop is not a candidate", "HWLoopNoCandidate", ORE, L);
    return false;
  }

  assert(
      (HWLoopInfo.ExitBlock && HWLoopInfo.ExitBranch && HWLoopInfo.ExitCount) &&
      "Hardware Loop must have set exit info.");

  BasicBlock *Preheader = L->getLoopPreheader();

  // If we don't have a preheader, then insert one.
  if (!Preheader)
    Preheader = InsertPreheaderForLoop(L, DT, LI, nullptr, PreserveLCSSA);
  if (!Preheader)
    return false;

  HardwareLoop HWLoop(HWLoopInfo, *SE, *DL, ORE);
  HWLoop.Create();
  ++NumHWLoops;
  return true;
}

void HardwareLoop::Create() {
  LLVM_DEBUG(dbgs() << "HWLoops: Converting loop..\n");

  Value *LoopCountInit = InitLoopCount();
  if (!LoopCountInit) {
    reportHWLoopFailure("could not safely create a loop count expression",
                        "HWLoopNotSafe", ORE, L);
    return;
  }

  Value *Setup = InsertIterationSetup(LoopCountInit);

  if (UsePHICounter || ForceHardwareLoopPHI) {
    Instruction *LoopDec = InsertLoopRegDec(LoopCountInit);
    Value *EltsRem = InsertPHICounter(Setup, LoopDec);
    LoopDec->setOperand(0, EltsRem);
    UpdateBranch(LoopDec);
  } else
    InsertLoopDec();

  // Run through the basic blocks of the loop and see if any of them have dead
  // PHIs that can be removed.
  for (auto I : L->blocks())
    DeleteDeadPHIs(I);
}

static bool CanGenerateTest(Loop *L, Value *Count) {
  BasicBlock *Preheader = L->getLoopPreheader();
  if (!Preheader->getSinglePredecessor())
    return false;

  BasicBlock *Pred = Preheader->getSinglePredecessor();
  if (!isa<BranchInst>(Pred->getTerminator()))
    return false;

  auto *BI = cast<BranchInst>(Pred->getTerminator());
  if (BI->isUnconditional() || !isa<ICmpInst>(BI->getCondition()))
    return false;

  // Check that the icmp is checking for equality of Count and zero and that
  // a non-zero value results in entering the loop.
  auto ICmp = cast<ICmpInst>(BI->getCondition());
  LLVM_DEBUG(dbgs() << " - Found condition: " << *ICmp << "\n");
  if (!ICmp->isEquality())
    return false;

  auto IsCompareZero = [](ICmpInst *ICmp, Value *Count, unsigned OpIdx) {
    if (auto *Const = dyn_cast<ConstantInt>(ICmp->getOperand(OpIdx)))
      return Const->isZero() && ICmp->getOperand(OpIdx ^ 1) == Count;
    return false;
  };

  if (!IsCompareZero(ICmp, Count, 0) && !IsCompareZero(ICmp, Count, 1))
    return false;

  unsigned SuccIdx = ICmp->getPredicate() == ICmpInst::ICMP_NE ? 0 : 1;
  if (BI->getSuccessor(SuccIdx) != Preheader)
    return false;

  return true;
}

Value *HardwareLoop::InitLoopCount() {
  LLVM_DEBUG(dbgs() << "HWLoops: Initialising loop counter value:\n");
  // Can we replace a conditional branch with an intrinsic that sets the
  // loop counter and tests that is not zero?

  SCEVExpander SCEVE(SE, DL, "loopcnt");
  if (!ExitCount->getType()->isPointerTy() &&
      ExitCount->getType() != CountType)
    ExitCount = SE.getZeroExtendExpr(ExitCount, CountType);

  ExitCount = SE.getAddExpr(ExitCount, SE.getOne(CountType));

  // If we're trying to use the 'test and set' form of the intrinsic, we need
  // to replace a conditional branch that is controlling entry to the loop. It
  // is likely (guaranteed?) that the preheader has an unconditional branch to
  // the loop header, so also check if it has a single predecessor.
  if (SE.isLoopEntryGuardedByCond(L, ICmpInst::ICMP_NE, ExitCount,
                                  SE.getZero(ExitCount->getType()))) {
    LLVM_DEBUG(dbgs() << " - Attempting to use test.set counter.\n");
    UseLoopGuard |= ForceGuardLoopEntry;
  } else
    UseLoopGuard = false;

  BasicBlock *BB = L->getLoopPreheader();
  if (UseLoopGuard && BB->getSinglePredecessor() &&
      cast<BranchInst>(BB->getTerminator())->isUnconditional()) {
    BasicBlock *Predecessor = BB->getSinglePredecessor();
    // If it's not safe to create a while loop then don't force it and create a
    // do-while loop instead
    if (!isSafeToExpandAt(ExitCount, Predecessor->getTerminator(), SE))
        UseLoopGuard = false;
    else
        BB = Predecessor;
  }

  if (!isSafeToExpandAt(ExitCount, BB->getTerminator(), SE)) {
    LLVM_DEBUG(dbgs() << "- Bailing, unsafe to expand ExitCount "
               << *ExitCount << "\n");
    return nullptr;
  }

  Value *Count = SCEVE.expandCodeFor(ExitCount, CountType,
                                     BB->getTerminator());

  // FIXME: We've expanded Count where we hope to insert the counter setting
  // intrinsic. But, in the case of the 'test and set' form, we may fallback to
  // the just 'set' form and in which case the insertion block is most likely
  // different. It means there will be instruction(s) in a block that possibly
  // aren't needed. The isLoopEntryGuardedByCond is trying to avoid this issue,
  // but it's doesn't appear to work in all cases.

  UseLoopGuard = UseLoopGuard && CanGenerateTest(L, Count);
  BeginBB = UseLoopGuard ? BB : L->getLoopPreheader();
  LLVM_DEBUG(dbgs() << " - Loop Count: " << *Count << "\n"
                    << " - Expanded Count in " << BB->getName() << "\n"
                    << " - Will insert set counter intrinsic into: "
                    << BeginBB->getName() << "\n");
  return Count;
}

Value* HardwareLoop::InsertIterationSetup(Value *LoopCountInit) {
  IRBuilder<> Builder(BeginBB->getTerminator());
  Type *Ty = LoopCountInit->getType();
  bool UsePhi = UsePHICounter || ForceHardwareLoopPHI;
  Intrinsic::ID ID = UseLoopGuard
                         ? (UsePhi ? Intrinsic::test_start_loop_iterations
                                   : Intrinsic::test_set_loop_iterations)
                         : (UsePhi ? Intrinsic::start_loop_iterations
                                   : Intrinsic::set_loop_iterations);
  Function *LoopIter = Intrinsic::getDeclaration(M, ID, Ty);
  Value *LoopSetup = Builder.CreateCall(LoopIter, LoopCountInit);

  // Use the return value of the intrinsic to control the entry of the loop.
  if (UseLoopGuard) {
    assert((isa<BranchInst>(BeginBB->getTerminator()) &&
            cast<BranchInst>(BeginBB->getTerminator())->isConditional()) &&
           "Expected conditional branch");

    Value *SetCount =
        UsePhi ? Builder.CreateExtractValue(LoopSetup, 1) : LoopSetup;
    auto *LoopGuard = cast<BranchInst>(BeginBB->getTerminator());
    LoopGuard->setCondition(SetCount);
    if (LoopGuard->getSuccessor(0) != L->getLoopPreheader())
      LoopGuard->swapSuccessors();
  }
  LLVM_DEBUG(dbgs() << "HWLoops: Inserted loop counter: " << *LoopSetup
                    << "\n");
  if (UsePhi && UseLoopGuard)
    LoopSetup = Builder.CreateExtractValue(LoopSetup, 0);
  return !UsePhi ? LoopCountInit : LoopSetup;
}

void HardwareLoop::InsertLoopDec() {
  IRBuilder<> CondBuilder(ExitBranch);

  Function *DecFunc =
    Intrinsic::getDeclaration(M, Intrinsic::loop_decrement,
                              LoopDecrement->getType());
  Value *Ops[] = { LoopDecrement };
  Value *NewCond = CondBuilder.CreateCall(DecFunc, Ops);
  Value *OldCond = ExitBranch->getCondition();
  ExitBranch->setCondition(NewCond);

  // The false branch must exit the loop.
  if (!L->contains(ExitBranch->getSuccessor(0)))
    ExitBranch->swapSuccessors();

  // The old condition may be dead now, and may have even created a dead PHI
  // (the original induction variable).
  RecursivelyDeleteTriviallyDeadInstructions(OldCond);

  LLVM_DEBUG(dbgs() << "HWLoops: Inserted loop dec: " << *NewCond << "\n");
}

Instruction* HardwareLoop::InsertLoopRegDec(Value *EltsRem) {
  IRBuilder<> CondBuilder(ExitBranch);

  Function *DecFunc =
      Intrinsic::getDeclaration(M, Intrinsic::loop_decrement_reg,
                                { EltsRem->getType() });
  Value *Ops[] = { EltsRem, LoopDecrement };
  Value *Call = CondBuilder.CreateCall(DecFunc, Ops);

  LLVM_DEBUG(dbgs() << "HWLoops: Inserted loop dec: " << *Call << "\n");
  return cast<Instruction>(Call);
}

PHINode* HardwareLoop::InsertPHICounter(Value *NumElts, Value *EltsRem) {
  BasicBlock *Preheader = L->getLoopPreheader();
  BasicBlock *Header = L->getHeader();
  BasicBlock *Latch = ExitBranch->getParent();
  IRBuilder<> Builder(Header->getFirstNonPHI());
  PHINode *Index = Builder.CreatePHI(NumElts->getType(), 2);
  Index->addIncoming(NumElts, Preheader);
  Index->addIncoming(EltsRem, Latch);
  LLVM_DEBUG(dbgs() << "HWLoops: PHI Counter: " << *Index << "\n");
  return Index;
}

void HardwareLoop::UpdateBranch(Value *EltsRem) {
  IRBuilder<> CondBuilder(ExitBranch);
  Value *NewCond =
    CondBuilder.CreateICmpNE(EltsRem, ConstantInt::get(EltsRem->getType(), 0));
  Value *OldCond = ExitBranch->getCondition();
  ExitBranch->setCondition(NewCond);

  // The false branch must exit the loop.
  if (!L->contains(ExitBranch->getSuccessor(0)))
    ExitBranch->swapSuccessors();

  // The old condition may be dead now, and may have even created a dead PHI
  // (the original induction variable).
  RecursivelyDeleteTriviallyDeadInstructions(OldCond);
}

INITIALIZE_PASS_BEGIN(HardwareLoops, DEBUG_TYPE, HW_LOOPS_NAME, false, false)
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
INITIALIZE_PASS_DEPENDENCY(LoopInfoWrapperPass)
INITIALIZE_PASS_DEPENDENCY(ScalarEvolutionWrapperPass)
INITIALIZE_PASS_DEPENDENCY(OptimizationRemarkEmitterWrapperPass)
INITIALIZE_PASS_END(HardwareLoops, DEBUG_TYPE, HW_LOOPS_NAME, false, false)

FunctionPass *llvm::createHardwareLoopsPass() { return new HardwareLoops(); }
