//===- Loads.cpp - Local load analysis ------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines simple local analyses for load instructions.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/Loads.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/GlobalAlias.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/Statepoint.h"

using namespace llvm;

static bool isAligned(const Value *Base, const APInt &Offset, Align Alignment,
                      const DataLayout &DL) {
  Align BA = Base->getPointerAlignment(DL);
  const APInt APAlign(Offset.getBitWidth(), Alignment.value());
  assert(APAlign.isPowerOf2() && "must be a power of 2!");
  return BA >= Alignment && !(Offset & (APAlign - 1));
}

/// Test if V is always a pointer to allocated and suitably aligned memory for
/// a simple load or store.
static bool isDereferenceableAndAlignedPointer(
    const Value *V, Align Alignment, const APInt &Size, const DataLayout &DL,
    const Instruction *CtxI, const DominatorTree *DT,
    SmallPtrSetImpl<const Value *> &Visited, unsigned MaxDepth) {
  assert(V->getType()->isPointerTy() && "Base must be pointer");

  // Recursion limit.
  if (MaxDepth-- == 0)
    return false;

  // Already visited?  Bail out, we've likely hit unreachable code.
  if (!Visited.insert(V).second)
    return false;

  // Note that it is not safe to speculate into a malloc'd region because
  // malloc may return null.

  // bitcast instructions are no-ops as far as dereferenceability is concerned.
  if (const BitCastOperator *BC = dyn_cast<BitCastOperator>(V)) {
    if (BC->getSrcTy()->isPointerTy())
      return isDereferenceableAndAlignedPointer(
          BC->getOperand(0), Alignment, Size, DL, CtxI, DT, Visited, MaxDepth);
  }

  bool CheckForNonNull = false;
  APInt KnownDerefBytes(Size.getBitWidth(),
                        V->getPointerDereferenceableBytes(DL, CheckForNonNull));
  if (KnownDerefBytes.getBoolValue() && KnownDerefBytes.uge(Size))
    if (!CheckForNonNull || isKnownNonZero(V, DL, 0, nullptr, CtxI, DT)) {
      // As we recursed through GEPs to get here, we've incrementally checked
      // that each step advanced by a multiple of the alignment. If our base is
      // properly aligned, then the original offset accessed must also be.
      Type *Ty = V->getType();
      assert(Ty->isSized() && "must be sized");
      APInt Offset(DL.getTypeStoreSizeInBits(Ty), 0);
      return isAligned(V, Offset, Alignment, DL);
    }

  // For GEPs, determine if the indexing lands within the allocated object.
  if (const GEPOperator *GEP = dyn_cast<GEPOperator>(V)) {
    const Value *Base = GEP->getPointerOperand();

    APInt Offset(DL.getIndexTypeSizeInBits(GEP->getType()), 0);
    if (!GEP->accumulateConstantOffset(DL, Offset) || Offset.isNegative() ||
        !Offset.urem(APInt(Offset.getBitWidth(), Alignment.value()))
             .isMinValue())
      return false;

    // If the base pointer is dereferenceable for Offset+Size bytes, then the
    // GEP (== Base + Offset) is dereferenceable for Size bytes.  If the base
    // pointer is aligned to Align bytes, and the Offset is divisible by Align
    // then the GEP (== Base + Offset == k_0 * Align + k_1 * Align) is also
    // aligned to Align bytes.

    // Offset and Size may have different bit widths if we have visited an
    // addrspacecast, so we can't do arithmetic directly on the APInt values.
    return isDereferenceableAndAlignedPointer(
        Base, Alignment, Offset + Size.sextOrTrunc(Offset.getBitWidth()), DL,
        CtxI, DT, Visited, MaxDepth);
  }

  // For gc.relocate, look through relocations
  if (const GCRelocateInst *RelocateInst = dyn_cast<GCRelocateInst>(V))
    return isDereferenceableAndAlignedPointer(
      RelocateInst->getDerivedPtr(), Alignment, Size, DL, CtxI, DT, Visited, MaxDepth);

  if (const AddrSpaceCastInst *ASC = dyn_cast<AddrSpaceCastInst>(V))
    return isDereferenceableAndAlignedPointer(ASC->getOperand(0), Alignment,
                                              Size, DL, CtxI, DT, Visited, MaxDepth);

  if (const auto *Call = dyn_cast<CallBase>(V))
    if (auto *RP = getArgumentAliasingToReturnedPointer(Call, true))
      return isDereferenceableAndAlignedPointer(RP, Alignment, Size, DL, CtxI,
                                                DT, Visited, MaxDepth);

  // If we don't know, assume the worst.
  return false;
}

bool llvm::isDereferenceableAndAlignedPointer(const Value *V, Align Alignment,
                                              const APInt &Size,
                                              const DataLayout &DL,
                                              const Instruction *CtxI,
                                              const DominatorTree *DT) {
  // Note: At the moment, Size can be zero.  This ends up being interpreted as
  // a query of whether [Base, V] is dereferenceable and V is aligned (since
  // that's what the implementation happened to do).  It's unclear if this is
  // the desired semantic, but at least SelectionDAG does exercise this case.

  SmallPtrSet<const Value *, 32> Visited;
  return ::isDereferenceableAndAlignedPointer(V, Alignment, Size, DL, CtxI, DT,
                                              Visited, 16);
}

bool llvm::isDereferenceableAndAlignedPointer(const Value *V, Type *Ty,
                                              MaybeAlign MA,
                                              const DataLayout &DL,
                                              const Instruction *CtxI,
                                              const DominatorTree *DT) {
  // For unsized types or scalable vectors we don't know exactly how many bytes
  // are dereferenced, so bail out.
  if (!Ty->isSized() || isa<ScalableVectorType>(Ty))
    return false;

  // When dereferenceability information is provided by a dereferenceable
  // attribute, we know exactly how many bytes are dereferenceable. If we can
  // determine the exact offset to the attributed variable, we can use that
  // information here.

  // Require ABI alignment for loads without alignment specification
  const Align Alignment = DL.getValueOrABITypeAlignment(MA, Ty);
  APInt AccessSize(DL.getPointerTypeSizeInBits(V->getType()),
                   DL.getTypeStoreSize(Ty));
  return isDereferenceableAndAlignedPointer(V, Alignment, AccessSize, DL, CtxI,
                                            DT);
}

bool llvm::isDereferenceablePointer(const Value *V, Type *Ty,
                                    const DataLayout &DL,
                                    const Instruction *CtxI,
                                    const DominatorTree *DT) {
  return isDereferenceableAndAlignedPointer(V, Ty, Align(1), DL, CtxI, DT);
}

/// Test if A and B will obviously have the same value.
///
/// This includes recognizing that %t0 and %t1 will have the same
/// value in code like this:
/// \code
///   %t0 = getelementptr \@a, 0, 3
///   store i32 0, i32* %t0
///   %t1 = getelementptr \@a, 0, 3
///   %t2 = load i32* %t1
/// \endcode
///
static bool AreEquivalentAddressValues(const Value *A, const Value *B) {
  // Test if the values are trivially equivalent.
  if (A == B)
    return true;

  // Test if the values come from identical arithmetic instructions.
  // Use isIdenticalToWhenDefined instead of isIdenticalTo because
  // this function is only used when one address use dominates the
  // other, which means that they'll always either have the same
  // value or one of them will have an undefined value.
  if (isa<BinaryOperator>(A) || isa<CastInst>(A) || isa<PHINode>(A) ||
      isa<GetElementPtrInst>(A))
    if (const Instruction *BI = dyn_cast<Instruction>(B))
      if (cast<Instruction>(A)->isIdenticalToWhenDefined(BI))
        return true;

  // Otherwise they may not be equivalent.
  return false;
}

bool llvm::isDereferenceableAndAlignedInLoop(LoadInst *LI, Loop *L,
                                             ScalarEvolution &SE,
                                             DominatorTree &DT) {
  auto &DL = LI->getModule()->getDataLayout();
  Value *Ptr = LI->getPointerOperand();

  APInt EltSize(DL.getIndexTypeSizeInBits(Ptr->getType()),
                DL.getTypeStoreSize(LI->getType()));
  const Align Alignment = LI->getAlign();

  Instruction *HeaderFirstNonPHI = L->getHeader()->getFirstNonPHI();

  // If given a uniform (i.e. non-varying) address, see if we can prove the
  // access is safe within the loop w/o needing predication.
  if (L->isLoopInvariant(Ptr))
    return isDereferenceableAndAlignedPointer(Ptr, Alignment, EltSize, DL,
                                              HeaderFirstNonPHI, &DT);

  // Otherwise, check to see if we have a repeating access pattern where we can
  // prove that all accesses are well aligned and dereferenceable.
  auto *AddRec = dyn_cast<SCEVAddRecExpr>(SE.getSCEV(Ptr));
  if (!AddRec || AddRec->getLoop() != L || !AddRec->isAffine())
    return false;
  auto* Step = dyn_cast<SCEVConstant>(AddRec->getStepRecurrence(SE));
  if (!Step)
    return false;
  // TODO: generalize to access patterns which have gaps
  if (Step->getAPInt() != EltSize)
    return false;

  // TODO: If the symbolic trip count has a small bound (max count), we might
  // be able to prove safety.
  auto TC = SE.getSmallConstantTripCount(L);
  if (!TC)
    return false;

  const APInt AccessSize = TC * EltSize;

  auto *StartS = dyn_cast<SCEVUnknown>(AddRec->getStart());
  if (!StartS)
    return false;
  assert(SE.isLoopInvariant(StartS, L) && "implied by addrec definition");
  Value *Base = StartS->getValue();

  // For the moment, restrict ourselves to the case where the access size is a
  // multiple of the requested alignment and the base is aligned.
  // TODO: generalize if a case found which warrants
  if (EltSize.urem(Alignment.value()) != 0)
    return false;
  return isDereferenceableAndAlignedPointer(Base, Alignment, AccessSize, DL,
                                            HeaderFirstNonPHI, &DT);
}

/// Check if executing a load of this pointer value cannot trap.
///
/// If DT and ScanFrom are specified this method performs context-sensitive
/// analysis and returns true if it is safe to load immediately before ScanFrom.
///
/// If it is not obviously safe to load from the specified pointer, we do
/// a quick local scan of the basic block containing \c ScanFrom, to determine
/// if the address is already accessed.
///
/// This uses the pointee type to determine how many bytes need to be safe to
/// load from the pointer.
bool llvm::isSafeToLoadUnconditionally(Value *V, Align Alignment, APInt &Size,
                                       const DataLayout &DL,
                                       Instruction *ScanFrom,
                                       const DominatorTree *DT) {
  // If DT is not specified we can't make context-sensitive query
  const Instruction* CtxI = DT ? ScanFrom : nullptr;
  if (isDereferenceableAndAlignedPointer(V, Alignment, Size, DL, CtxI, DT))
    return true;

  if (!ScanFrom)
    return false;

  if (Size.getBitWidth() > 64)
    return false;
  const uint64_t LoadSize = Size.getZExtValue();

  // Otherwise, be a little bit aggressive by scanning the local block where we
  // want to check to see if the pointer is already being loaded or stored
  // from/to.  If so, the previous load or store would have already trapped,
  // so there is no harm doing an extra load (also, CSE will later eliminate
  // the load entirely).
  BasicBlock::iterator BBI = ScanFrom->getIterator(),
                       E = ScanFrom->getParent()->begin();

  // We can at least always strip pointer casts even though we can't use the
  // base here.
  V = V->stripPointerCasts();

  while (BBI != E) {
    --BBI;

    // If we see a free or a call which may write to memory (i.e. which might do
    // a free) the pointer could be marked invalid.
    if (isa<CallInst>(BBI) && BBI->mayWriteToMemory() &&
        !isa<DbgInfoIntrinsic>(BBI))
      return false;

    Value *AccessedPtr;
    Type *AccessedTy;
    Align AccessedAlign;
    if (LoadInst *LI = dyn_cast<LoadInst>(BBI)) {
      // Ignore volatile loads. The execution of a volatile load cannot
      // be used to prove an address is backed by regular memory; it can,
      // for example, point to an MMIO register.
      if (LI->isVolatile())
        continue;
      AccessedPtr = LI->getPointerOperand();
      AccessedTy = LI->getType();
      AccessedAlign = LI->getAlign();
    } else if (StoreInst *SI = dyn_cast<StoreInst>(BBI)) {
      // Ignore volatile stores (see comment for loads).
      if (SI->isVolatile())
        continue;
      AccessedPtr = SI->getPointerOperand();
      AccessedTy = SI->getValueOperand()->getType();
      AccessedAlign = SI->getAlign();
    } else
      continue;

    if (AccessedAlign < Alignment)
      continue;

    // Handle trivial cases.
    if (AccessedPtr == V &&
        LoadSize <= DL.getTypeStoreSize(AccessedTy))
      return true;

    if (AreEquivalentAddressValues(AccessedPtr->stripPointerCasts(), V) &&
        LoadSize <= DL.getTypeStoreSize(AccessedTy))
      return true;
  }
  return false;
}

bool llvm::isSafeToLoadUnconditionally(Value *V, Type *Ty, Align Alignment,
                                       const DataLayout &DL,
                                       Instruction *ScanFrom,
                                       const DominatorTree *DT) {
  APInt Size(DL.getIndexTypeSizeInBits(V->getType()), DL.getTypeStoreSize(Ty));
  return isSafeToLoadUnconditionally(V, Alignment, Size, DL, ScanFrom, DT);
}

  /// DefMaxInstsToScan - the default number of maximum instructions
/// to scan in the block, used by FindAvailableLoadedValue().
/// FindAvailableLoadedValue() was introduced in r60148, to improve jump
/// threading in part by eliminating partially redundant loads.
/// At that point, the value of MaxInstsToScan was already set to '6'
/// without documented explanation.
cl::opt<unsigned>
llvm::DefMaxInstsToScan("available-load-scan-limit", cl::init(6), cl::Hidden,
  cl::desc("Use this to specify the default maximum number of instructions "
           "to scan backward from a given instruction, when searching for "
           "available loaded value"));

Value *llvm::FindAvailableLoadedValue(LoadInst *Load,
                                      BasicBlock *ScanBB,
                                      BasicBlock::iterator &ScanFrom,
                                      unsigned MaxInstsToScan,
                                      AAResults *AA, bool *IsLoad,
                                      unsigned *NumScanedInst) {
  // Don't CSE load that is volatile or anything stronger than unordered.
  if (!Load->isUnordered())
    return nullptr;

  return FindAvailablePtrLoadStore(
      Load->getPointerOperand(), Load->getType(), Load->isAtomic(), ScanBB,
      ScanFrom, MaxInstsToScan, AA, IsLoad, NumScanedInst);
}

// Check if the load and the store have the same base, constant offsets and
// non-overlapping access ranges.
static bool AreNonOverlapSameBaseLoadAndStore(
    Value *LoadPtr, Type *LoadTy, Value *StorePtr, Type *StoreTy,
    const DataLayout &DL) {
  APInt LoadOffset(DL.getTypeSizeInBits(LoadPtr->getType()), 0);
  APInt StoreOffset(DL.getTypeSizeInBits(StorePtr->getType()), 0);
  Value *LoadBase = LoadPtr->stripAndAccumulateConstantOffsets(
      DL, LoadOffset, /* AllowNonInbounds */ false);
  Value *StoreBase = StorePtr->stripAndAccumulateConstantOffsets(
      DL, StoreOffset, /* AllowNonInbounds */ false);
  if (LoadBase != StoreBase)
    return false;
  auto LoadAccessSize = LocationSize::precise(DL.getTypeStoreSize(LoadTy));
  auto StoreAccessSize = LocationSize::precise(DL.getTypeStoreSize(StoreTy));
  ConstantRange LoadRange(LoadOffset,
                          LoadOffset + LoadAccessSize.toRaw());
  ConstantRange StoreRange(StoreOffset,
                           StoreOffset + StoreAccessSize.toRaw());
  return LoadRange.intersectWith(StoreRange).isEmptySet();
}

Value *llvm::FindAvailablePtrLoadStore(Value *Ptr, Type *AccessTy,
                                       bool AtLeastAtomic, BasicBlock *ScanBB,
                                       BasicBlock::iterator &ScanFrom,
                                       unsigned MaxInstsToScan,
                                       AAResults *AA, bool *IsLoadCSE,
                                       unsigned *NumScanedInst) {
  if (MaxInstsToScan == 0)
    MaxInstsToScan = ~0U;

  const DataLayout &DL = ScanBB->getModule()->getDataLayout();
  Value *StrippedPtr = Ptr->stripPointerCasts();

  while (ScanFrom != ScanBB->begin()) {
    // We must ignore debug info directives when counting (otherwise they
    // would affect codegen).
    Instruction *Inst = &*--ScanFrom;
    if (isa<DbgInfoIntrinsic>(Inst))
      continue;

    // Restore ScanFrom to expected value in case next test succeeds
    ScanFrom++;

    if (NumScanedInst)
      ++(*NumScanedInst);

    // Don't scan huge blocks.
    if (MaxInstsToScan-- == 0)
      return nullptr;

    --ScanFrom;
    // If this is a load of Ptr, the loaded value is available.
    // (This is true even if the load is volatile or atomic, although
    // those cases are unlikely.)
    if (LoadInst *LI = dyn_cast<LoadInst>(Inst))
      if (AreEquivalentAddressValues(
              LI->getPointerOperand()->stripPointerCasts(), StrippedPtr) &&
          CastInst::isBitOrNoopPointerCastable(LI->getType(), AccessTy, DL)) {

        // We can value forward from an atomic to a non-atomic, but not the
        // other way around.
        if (LI->isAtomic() < AtLeastAtomic)
          return nullptr;

        if (IsLoadCSE)
            *IsLoadCSE = true;
        return LI;
      }

    // Try to get the store size for the type.
    auto AccessSize = LocationSize::precise(DL.getTypeStoreSize(AccessTy));

    if (StoreInst *SI = dyn_cast<StoreInst>(Inst)) {
      Value *StorePtr = SI->getPointerOperand()->stripPointerCasts();
      // If this is a store through Ptr, the value is available!
      // (This is true even if the store is volatile or atomic, although
      // those cases are unlikely.)
      if (AreEquivalentAddressValues(StorePtr, StrippedPtr) &&
          CastInst::isBitOrNoopPointerCastable(SI->getValueOperand()->getType(),
                                               AccessTy, DL)) {

        // We can value forward from an atomic to a non-atomic, but not the
        // other way around.
        if (SI->isAtomic() < AtLeastAtomic)
          return nullptr;

        if (IsLoadCSE)
          *IsLoadCSE = false;
        return SI->getOperand(0);
      }

      // If both StrippedPtr and StorePtr reach all the way to an alloca or
      // global and they are different, ignore the store. This is a trivial form
      // of alias analysis that is important for reg2mem'd code.
      if ((isa<AllocaInst>(StrippedPtr) || isa<GlobalVariable>(StrippedPtr)) &&
          (isa<AllocaInst>(StorePtr) || isa<GlobalVariable>(StorePtr)) &&
          StrippedPtr != StorePtr)
        continue;

      if (!AA) {
        // When AA isn't available, but if the load and the store have the same
        // base, constant offsets and non-overlapping access ranges, ignore the
        // store. This is a simple form of alias analysis that is used by the
        // inliner. FIXME: use BasicAA if possible.
        if (AreNonOverlapSameBaseLoadAndStore(
                Ptr, AccessTy, SI->getPointerOperand(),
                SI->getValueOperand()->getType(), DL))
          continue;
      } else {
        // If we have alias analysis and it says the store won't modify the
        // loaded value, ignore the store.
        if (!isModSet(AA->getModRefInfo(SI, StrippedPtr, AccessSize)))
          continue;
      }

      // Otherwise the store that may or may not alias the pointer, bail out.
      ++ScanFrom;
      return nullptr;
    }

    // If this is some other instruction that may clobber Ptr, bail out.
    if (Inst->mayWriteToMemory()) {
      // If alias analysis claims that it really won't modify the load,
      // ignore it.
      if (AA && !isModSet(AA->getModRefInfo(Inst, StrippedPtr, AccessSize)))
        continue;

      // May modify the pointer, bail out.
      ++ScanFrom;
      return nullptr;
    }
  }

  // Got to the start of the block, we didn't find it, but are done for this
  // block.
  return nullptr;
}
