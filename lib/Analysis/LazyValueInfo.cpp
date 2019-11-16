//===- LazyValueInfo.cpp - Value constraint analysis ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the interface for lazy computation of value constraint
// information.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/LazyValueInfo.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Analysis/AssumptionCache.h"
#include "llvm/Analysis/ConstantFolding.h"
#include "llvm/Analysis/InstructionSimplify.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueLattice.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/AssemblyAnnotationWriter.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/ConstantRange.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/ValueHandle.h"
#include "llvm/InitializePasses.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/raw_ostream.h"
#include <map>
using namespace llvm;
using namespace PatternMatch;

#define DEBUG_TYPE "lazy-value-info"

// This is the number of worklist items we will process to try to discover an
// answer for a given value.
static const unsigned MaxProcessedPerValue = 500;

char LazyValueInfoWrapperPass::ID = 0;
LazyValueInfoWrapperPass::LazyValueInfoWrapperPass() : FunctionPass(ID) {
  initializeLazyValueInfoWrapperPassPass(*PassRegistry::getPassRegistry());
}
INITIALIZE_PASS_BEGIN(LazyValueInfoWrapperPass, "lazy-value-info",
                "Lazy Value Information Analysis", false, true)
INITIALIZE_PASS_DEPENDENCY(AssumptionCacheTracker)
INITIALIZE_PASS_DEPENDENCY(TargetLibraryInfoWrapperPass)
INITIALIZE_PASS_END(LazyValueInfoWrapperPass, "lazy-value-info",
                "Lazy Value Information Analysis", false, true)

namespace llvm {
  FunctionPass *createLazyValueInfoPass() { return new LazyValueInfoWrapperPass(); }
}

AnalysisKey LazyValueAnalysis::Key;

/// Returns true if this lattice value represents at most one possible value.
/// This is as precise as any lattice value can get while still representing
/// reachable code.
static bool hasSingleValue(const ValueLatticeElement &Val) {
  if (Val.isConstantRange() &&
      Val.getConstantRange().isSingleElement())
    // Integer constants are single element ranges
    return true;
  if (Val.isConstant())
    // Non integer constants
    return true;
  return false;
}

/// Combine two sets of facts about the same value into a single set of
/// facts.  Note that this method is not suitable for merging facts along
/// different paths in a CFG; that's what the mergeIn function is for.  This
/// is for merging facts gathered about the same value at the same location
/// through two independent means.
/// Notes:
/// * This method does not promise to return the most precise possible lattice
///   value implied by A and B.  It is allowed to return any lattice element
///   which is at least as strong as *either* A or B (unless our facts
///   conflict, see below).
/// * Due to unreachable code, the intersection of two lattice values could be
///   contradictory.  If this happens, we return some valid lattice value so as
///   not confuse the rest of LVI.  Ideally, we'd always return Undefined, but
///   we do not make this guarantee.  TODO: This would be a useful enhancement.
static ValueLatticeElement intersect(const ValueLatticeElement &A,
                                     const ValueLatticeElement &B) {
  // Undefined is the strongest state.  It means the value is known to be along
  // an unreachable path.
  if (A.isUnknown())
    return A;
  if (B.isUnknown())
    return B;

  // If we gave up for one, but got a useable fact from the other, use it.
  if (A.isOverdefined())
    return B;
  if (B.isOverdefined())
    return A;

  // Can't get any more precise than constants.
  if (hasSingleValue(A))
    return A;
  if (hasSingleValue(B))
    return B;

  // Could be either constant range or not constant here.
  if (!A.isConstantRange() || !B.isConstantRange()) {
    // TODO: Arbitrary choice, could be improved
    return A;
  }

  // Intersect two constant ranges
  ConstantRange Range =
      A.getConstantRange().intersectWith(B.getConstantRange());
  // Note: An empty range is implicitly converted to unknown or undef depending
  // on MayIncludeUndef internally.
  return ValueLatticeElement::getRange(
      std::move(Range), /*MayIncludeUndef=*/A.isConstantRangeIncludingUndef() |
                            B.isConstantRangeIncludingUndef());
}

//===----------------------------------------------------------------------===//
//                          LazyValueInfoCache Decl
//===----------------------------------------------------------------------===//

namespace {
  /// A callback value handle updates the cache when values are erased.
  class LazyValueInfoCache;
  struct LVIValueHandle final : public CallbackVH {
    LazyValueInfoCache *Parent;

    LVIValueHandle(Value *V, LazyValueInfoCache *P = nullptr)
      : CallbackVH(V), Parent(P) { }

    void deleted() override;
    void allUsesReplacedWith(Value *V) override {
      deleted();
    }
  };
} // end anonymous namespace

namespace {
  /// This is the cache kept by LazyValueInfo which
  /// maintains information about queries across the clients' queries.
  class LazyValueInfoCache {
    /// This is all of the cached information for one basic block. It contains
    /// the per-value lattice elements, as well as a separate set for
    /// overdefined values to reduce memory usage.
    struct BlockCacheEntry {
      SmallDenseMap<AssertingVH<Value>, ValueLatticeElement, 4> LatticeElements;
      SmallDenseSet<AssertingVH<Value>, 4> OverDefined;
    };

    /// Cached information per basic block.
    DenseMap<PoisoningVH<BasicBlock>, std::unique_ptr<BlockCacheEntry>>
        BlockCache;
    /// Set of value handles used to erase values from the cache on deletion.
    DenseSet<LVIValueHandle, DenseMapInfo<Value *>> ValueHandles;

    const BlockCacheEntry *getBlockEntry(BasicBlock *BB) const {
      auto It = BlockCache.find(BB);
      if (It == BlockCache.end())
        return nullptr;
      return It->second.get();
    }

    BlockCacheEntry *getOrCreateBlockEntry(BasicBlock *BB) {
      auto It = BlockCache.find(BB);
      if (It == BlockCache.end())
        It = BlockCache.insert({ BB, std::make_unique<BlockCacheEntry>() })
                       .first;

      return It->second.get();
    }

  public:
    void insertResult(Value *Val, BasicBlock *BB,
                      const ValueLatticeElement &Result) {
      BlockCacheEntry *Entry = getOrCreateBlockEntry(BB);

      // Insert over-defined values into their own cache to reduce memory
      // overhead.
      if (Result.isOverdefined())
        Entry->OverDefined.insert(Val);
      else
        Entry->LatticeElements.insert({ Val, Result });

      auto HandleIt = ValueHandles.find_as(Val);
      if (HandleIt == ValueHandles.end())
        ValueHandles.insert({ Val, this });
    }

    Optional<ValueLatticeElement> getCachedValueInfo(Value *V,
                                                     BasicBlock *BB) const {
      const BlockCacheEntry *Entry = getBlockEntry(BB);
      if (!Entry)
        return None;

      if (Entry->OverDefined.count(V))
        return ValueLatticeElement::getOverdefined();

      auto LatticeIt = Entry->LatticeElements.find(V);
      if (LatticeIt == Entry->LatticeElements.end())
        return None;

      return LatticeIt->second;
    }

    /// clear - Empty the cache.
    void clear() {
      BlockCache.clear();
      ValueHandles.clear();
    }

    /// Inform the cache that a given value has been deleted.
    void eraseValue(Value *V);

    /// This is part of the update interface to inform the cache
    /// that a block has been deleted.
    void eraseBlock(BasicBlock *BB);

    /// Updates the cache to remove any influence an overdefined value in
    /// OldSucc might have (unless also overdefined in NewSucc).  This just
    /// flushes elements from the cache and does not add any.
    void threadEdgeImpl(BasicBlock *OldSucc,BasicBlock *NewSucc);
  };
}

void LazyValueInfoCache::eraseValue(Value *V) {
  for (auto &Pair : BlockCache) {
    Pair.second->LatticeElements.erase(V);
    Pair.second->OverDefined.erase(V);
  }

  auto HandleIt = ValueHandles.find_as(V);
  if (HandleIt != ValueHandles.end())
    ValueHandles.erase(HandleIt);
}

void LVIValueHandle::deleted() {
  // This erasure deallocates *this, so it MUST happen after we're done
  // using any and all members of *this.
  Parent->eraseValue(*this);
}

void LazyValueInfoCache::eraseBlock(BasicBlock *BB) {
  BlockCache.erase(BB);
}

void LazyValueInfoCache::threadEdgeImpl(BasicBlock *OldSucc,
                                        BasicBlock *NewSucc) {
  // When an edge in the graph has been threaded, values that we could not
  // determine a value for before (i.e. were marked overdefined) may be
  // possible to solve now. We do NOT try to proactively update these values.
  // Instead, we clear their entries from the cache, and allow lazy updating to
  // recompute them when needed.

  // The updating process is fairly simple: we need to drop cached info
  // for all values that were marked overdefined in OldSucc, and for those same
  // values in any successor of OldSucc (except NewSucc) in which they were
  // also marked overdefined.
  std::vector<BasicBlock*> worklist;
  worklist.push_back(OldSucc);

  const BlockCacheEntry *Entry = getBlockEntry(OldSucc);
  if (!Entry || Entry->OverDefined.empty())
    return; // Nothing to process here.
  SmallVector<Value *, 4> ValsToClear(Entry->OverDefined.begin(),
                                      Entry->OverDefined.end());

  // Use a worklist to perform a depth-first search of OldSucc's successors.
  // NOTE: We do not need a visited list since any blocks we have already
  // visited will have had their overdefined markers cleared already, and we
  // thus won't loop to their successors.
  while (!worklist.empty()) {
    BasicBlock *ToUpdate = worklist.back();
    worklist.pop_back();

    // Skip blocks only accessible through NewSucc.
    if (ToUpdate == NewSucc) continue;

    // If a value was marked overdefined in OldSucc, and is here too...
    auto OI = BlockCache.find(ToUpdate);
    if (OI == BlockCache.end() || OI->second->OverDefined.empty())
      continue;
    auto &ValueSet = OI->second->OverDefined;

    bool changed = false;
    for (Value *V : ValsToClear) {
      if (!ValueSet.erase(V))
        continue;

      // If we removed anything, then we potentially need to update
      // blocks successors too.
      changed = true;
    }

    if (!changed) continue;

    worklist.insert(worklist.end(), succ_begin(ToUpdate), succ_end(ToUpdate));
  }
}


namespace {
/// An assembly annotator class to print LazyValueCache information in
/// comments.
class LazyValueInfoImpl;
class LazyValueInfoAnnotatedWriter : public AssemblyAnnotationWriter {
  LazyValueInfoImpl *LVIImpl;
  // While analyzing which blocks we can solve values for, we need the dominator
  // information.
  DominatorTree &DT;

public:
  LazyValueInfoAnnotatedWriter(LazyValueInfoImpl *L, DominatorTree &DTree)
      : LVIImpl(L), DT(DTree) {}

  virtual void emitBasicBlockStartAnnot(const BasicBlock *BB,
                                        formatted_raw_ostream &OS);

  virtual void emitInstructionAnnot(const Instruction *I,
                                    formatted_raw_ostream &OS);
};
}
namespace {
  // The actual implementation of the lazy analysis and update.  Note that the
  // inheritance from LazyValueInfoCache is intended to be temporary while
  // splitting the code and then transitioning to a has-a relationship.
  class LazyValueInfoImpl {

    /// Cached results from previous queries
    LazyValueInfoCache TheCache;

    /// This stack holds the state of the value solver during a query.
    /// It basically emulates the callstack of the naive
    /// recursive value lookup process.
    SmallVector<std::pair<BasicBlock*, Value*>, 8> BlockValueStack;

    /// Keeps track of which block-value pairs are in BlockValueStack.
    DenseSet<std::pair<BasicBlock*, Value*> > BlockValueSet;

    /// Push BV onto BlockValueStack unless it's already in there.
    /// Returns true on success.
    bool pushBlockValue(const std::pair<BasicBlock *, Value *> &BV) {
      if (!BlockValueSet.insert(BV).second)
        return false;  // It's already in the stack.

      LLVM_DEBUG(dbgs() << "PUSH: " << *BV.second << " in "
                        << BV.first->getName() << "\n");
      BlockValueStack.push_back(BV);
      return true;
    }

    AssumptionCache *AC;  ///< A pointer to the cache of @llvm.assume calls.
    const DataLayout &DL; ///< A mandatory DataLayout

  Optional<ValueLatticeElement> getBlockValue(Value *Val, BasicBlock *BB);
  Optional<ValueLatticeElement> getEdgeValue(Value *V, BasicBlock *F,
                                BasicBlock *T, Instruction *CxtI = nullptr);

  // These methods process one work item and may add more. A false value
  // returned means that the work item was not completely processed and must
  // be revisited after going through the new items.
  bool solveBlockValue(Value *Val, BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueImpl(Value *Val, BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueNonLocal(Value *Val,
                                                        BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValuePHINode(PHINode *PN,
                                                       BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueSelect(SelectInst *S,
                                                      BasicBlock *BB);
  Optional<ConstantRange> getRangeForOperand(unsigned Op, Instruction *I,
                                             BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueBinaryOpImpl(
      Instruction *I, BasicBlock *BB,
      std::function<ConstantRange(const ConstantRange &,
                                  const ConstantRange &)> OpFn);
  Optional<ValueLatticeElement> solveBlockValueBinaryOp(BinaryOperator *BBI,
                                                        BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueCast(CastInst *CI,
                                                    BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueOverflowIntrinsic(
      WithOverflowInst *WO, BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueSaturatingIntrinsic(
      SaturatingInst *SI, BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueIntrinsic(IntrinsicInst *II,
                                                         BasicBlock *BB);
  Optional<ValueLatticeElement> solveBlockValueExtractValue(
      ExtractValueInst *EVI, BasicBlock *BB);
  void intersectAssumeOrGuardBlockValueConstantRange(Value *Val,
                                                     ValueLatticeElement &BBLV,
                                                     Instruction *BBI);

  void solve();

  public:
    /// This is the query interface to determine the lattice
    /// value for the specified Value* at the end of the specified block.
    ValueLatticeElement getValueInBlock(Value *V, BasicBlock *BB,
                                        Instruction *CxtI = nullptr);

    /// This is the query interface to determine the lattice
    /// value for the specified Value* at the specified instruction (generally
    /// from an assume intrinsic).
    ValueLatticeElement getValueAt(Value *V, Instruction *CxtI);

    /// This is the query interface to determine the lattice
    /// value for the specified Value* that is true on the specified edge.
    ValueLatticeElement getValueOnEdge(Value *V, BasicBlock *FromBB,
                                       BasicBlock *ToBB,
                                   Instruction *CxtI = nullptr);

    /// Complete flush all previously computed values
    void clear() {
      TheCache.clear();
    }

    /// Printing the LazyValueInfo Analysis.
    void printLVI(Function &F, DominatorTree &DTree, raw_ostream &OS) {
        LazyValueInfoAnnotatedWriter Writer(this, DTree);
        F.print(OS, &Writer);
    }

    /// This is part of the update interface to inform the cache
    /// that a block has been deleted.
    void eraseBlock(BasicBlock *BB) {
      TheCache.eraseBlock(BB);
    }

    /// This is the update interface to inform the cache that an edge from
    /// PredBB to OldSucc has been threaded to be from PredBB to NewSucc.
    void threadEdge(BasicBlock *PredBB,BasicBlock *OldSucc,BasicBlock *NewSucc);

    LazyValueInfoImpl(AssumptionCache *AC, const DataLayout &DL)
        : AC(AC), DL(DL) {}
  };
} // end anonymous namespace


void LazyValueInfoImpl::solve() {
  SmallVector<std::pair<BasicBlock *, Value *>, 8> StartingStack(
      BlockValueStack.begin(), BlockValueStack.end());

  unsigned processedCount = 0;
  while (!BlockValueStack.empty()) {
    processedCount++;
    // Abort if we have to process too many values to get a result for this one.
    // Because of the design of the overdefined cache currently being per-block
    // to avoid naming-related issues (IE it wants to try to give different
    // results for the same name in different blocks), overdefined results don't
    // get cached globally, which in turn means we will often try to rediscover
    // the same overdefined result again and again.  Once something like
    // PredicateInfo is used in LVI or CVP, we should be able to make the
    // overdefined cache global, and remove this throttle.
    if (processedCount > MaxProcessedPerValue) {
      LLVM_DEBUG(
          dbgs() << "Giving up on stack because we are getting too deep\n");
      // Fill in the original values
      while (!StartingStack.empty()) {
        std::pair<BasicBlock *, Value *> &e = StartingStack.back();
        TheCache.insertResult(e.second, e.first,
                              ValueLatticeElement::getOverdefined());
        StartingStack.pop_back();
      }
      BlockValueSet.clear();
      BlockValueStack.clear();
      return;
    }
    std::pair<BasicBlock *, Value *> e = BlockValueStack.back();
    assert(BlockValueSet.count(e) && "Stack value should be in BlockValueSet!");

    if (solveBlockValue(e.second, e.first)) {
      // The work item was completely processed.
      assert(BlockValueStack.back() == e && "Nothing should have been pushed!");
#ifndef NDEBUG
      Optional<ValueLatticeElement> BBLV =
          TheCache.getCachedValueInfo(e.second, e.first);
      assert(BBLV && "Result should be in cache!");
      LLVM_DEBUG(
          dbgs() << "POP " << *e.second << " in " << e.first->getName() << " = "
                 << *BBLV << "\n");
#endif

      BlockValueStack.pop_back();
      BlockValueSet.erase(e);
    } else {
      // More work needs to be done before revisiting.
      assert(BlockValueStack.back() != e && "Stack should have been pushed!");
    }
  }
}

Optional<ValueLatticeElement> LazyValueInfoImpl::getBlockValue(Value *Val,
                                                               BasicBlock *BB) {
  // If already a constant, there is nothing to compute.
  if (Constant *VC = dyn_cast<Constant>(Val))
    return ValueLatticeElement::get(VC);

  if (Optional<ValueLatticeElement> OptLatticeVal =
          TheCache.getCachedValueInfo(Val, BB))
    return OptLatticeVal;

  // We have hit a cycle, assume overdefined.
  if (!pushBlockValue({ BB, Val }))
    return ValueLatticeElement::getOverdefined();

  // Yet to be resolved.
  return None;
}

static ValueLatticeElement getFromRangeMetadata(Instruction *BBI) {
  switch (BBI->getOpcode()) {
  default: break;
  case Instruction::Load:
  case Instruction::Call:
  case Instruction::Invoke:
    if (MDNode *Ranges = BBI->getMetadata(LLVMContext::MD_range))
      if (isa<IntegerType>(BBI->getType())) {
        return ValueLatticeElement::getRange(
            getConstantRangeFromMetadata(*Ranges));
      }
    break;
  };
  // Nothing known - will be intersected with other facts
  return ValueLatticeElement::getOverdefined();
}

bool LazyValueInfoImpl::solveBlockValue(Value *Val, BasicBlock *BB) {
  assert(!isa<Constant>(Val) && "Value should not be constant");
  assert(!TheCache.getCachedValueInfo(Val, BB) &&
         "Value should not be in cache");

  // Hold off inserting this value into the Cache in case we have to return
  // false and come back later.
  Optional<ValueLatticeElement> Res = solveBlockValueImpl(Val, BB);
  if (!Res)
    // Work pushed, will revisit
    return false;

  TheCache.insertResult(Val, BB, *Res);
  return true;
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueImpl(
    Value *Val, BasicBlock *BB) {
  Instruction *BBI = dyn_cast<Instruction>(Val);
  if (!BBI || BBI->getParent() != BB)
    return solveBlockValueNonLocal(Val, BB);

  if (PHINode *PN = dyn_cast<PHINode>(BBI))
    return solveBlockValuePHINode(PN, BB);

  if (auto *SI = dyn_cast<SelectInst>(BBI))
    return solveBlockValueSelect(SI, BB);

  // If this value is a nonnull pointer, record it's range and bailout.  Note
  // that for all other pointer typed values, we terminate the search at the
  // definition.  We could easily extend this to look through geps, bitcasts,
  // and the like to prove non-nullness, but it's not clear that's worth it
  // compile time wise.  The context-insensitive value walk done inside
  // isKnownNonZero gets most of the profitable cases at much less expense.
  // This does mean that we have a sensitivity to where the defining
  // instruction is placed, even if it could legally be hoisted much higher.
  // That is unfortunate.
  PointerType *PT = dyn_cast<PointerType>(BBI->getType());
  if (PT && isKnownNonZero(BBI, DL))
    return ValueLatticeElement::getNot(ConstantPointerNull::get(PT));

  if (BBI->getType()->isIntegerTy()) {
    if (auto *CI = dyn_cast<CastInst>(BBI))
      return solveBlockValueCast(CI, BB);

    if (BinaryOperator *BO = dyn_cast<BinaryOperator>(BBI))
      return solveBlockValueBinaryOp(BO, BB);

    if (auto *EVI = dyn_cast<ExtractValueInst>(BBI))
      return solveBlockValueExtractValue(EVI, BB);

    if (auto *II = dyn_cast<IntrinsicInst>(BBI))
      return solveBlockValueIntrinsic(II, BB);
  }

  LLVM_DEBUG(dbgs() << " compute BB '" << BB->getName()
                    << "' - unknown inst def found.\n");
  return getFromRangeMetadata(BBI);
}

static bool InstructionDereferencesPointer(Instruction *I, Value *Ptr) {
  if (LoadInst *L = dyn_cast<LoadInst>(I)) {
    return L->getPointerAddressSpace() == 0 &&
           GetUnderlyingObject(L->getPointerOperand(),
                               L->getModule()->getDataLayout()) == Ptr;
  }
  if (StoreInst *S = dyn_cast<StoreInst>(I)) {
    return S->getPointerAddressSpace() == 0 &&
           GetUnderlyingObject(S->getPointerOperand(),
                               S->getModule()->getDataLayout()) == Ptr;
  }
  if (MemIntrinsic *MI = dyn_cast<MemIntrinsic>(I)) {
    if (MI->isVolatile()) return false;

    // FIXME: check whether it has a valuerange that excludes zero?
    ConstantInt *Len = dyn_cast<ConstantInt>(MI->getLength());
    if (!Len || Len->isZero()) return false;

    if (MI->getDestAddressSpace() == 0)
      if (GetUnderlyingObject(MI->getRawDest(),
                              MI->getModule()->getDataLayout()) == Ptr)
        return true;
    if (MemTransferInst *MTI = dyn_cast<MemTransferInst>(MI))
      if (MTI->getSourceAddressSpace() == 0)
        if (GetUnderlyingObject(MTI->getRawSource(),
                                MTI->getModule()->getDataLayout()) == Ptr)
          return true;
  }
  return false;
}

/// Return true if the allocation associated with Val is ever dereferenced
/// within the given basic block.  This establishes the fact Val is not null,
/// but does not imply that the memory at Val is dereferenceable.  (Val may
/// point off the end of the dereferenceable part of the object.)
static bool isObjectDereferencedInBlock(Value *Val, BasicBlock *BB) {
  assert(Val->getType()->isPointerTy());

  const DataLayout &DL = BB->getModule()->getDataLayout();
  Value *UnderlyingVal = GetUnderlyingObject(Val, DL);
  // If 'GetUnderlyingObject' didn't converge, skip it. It won't converge
  // inside InstructionDereferencesPointer either.
  if (UnderlyingVal == GetUnderlyingObject(UnderlyingVal, DL, 1))
    for (Instruction &I : *BB)
      if (InstructionDereferencesPointer(&I, UnderlyingVal))
        return true;
  return false;
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueNonLocal(
    Value *Val, BasicBlock *BB) {
  ValueLatticeElement Result;  // Start Undefined.

  // If this is the entry block, we must be asking about an argument.  The
  // value is overdefined.
  if (BB == &BB->getParent()->getEntryBlock()) {
    assert(isa<Argument>(Val) && "Unknown live-in to the entry block");
    // Before giving up, see if we can prove the pointer non-null local to
    // this particular block.
    PointerType *PTy = dyn_cast<PointerType>(Val->getType());
    if (PTy &&
        (isKnownNonZero(Val, DL) ||
          (isObjectDereferencedInBlock(Val, BB) &&
           !NullPointerIsDefined(BB->getParent(), PTy->getAddressSpace()))))
      return ValueLatticeElement::getNot(ConstantPointerNull::get(PTy));
    else
      return ValueLatticeElement::getOverdefined();
  }

  // Loop over all of our predecessors, merging what we know from them into
  // result.  If we encounter an unexplored predecessor, we eagerly explore it
  // in a depth first manner.  In practice, this has the effect of discovering
  // paths we can't analyze eagerly without spending compile times analyzing
  // other paths.  This heuristic benefits from the fact that predecessors are
  // frequently arranged such that dominating ones come first and we quickly
  // find a path to function entry.  TODO: We should consider explicitly
  // canonicalizing to make this true rather than relying on this happy
  // accident.
  for (pred_iterator PI = pred_begin(BB), E = pred_end(BB); PI != E; ++PI) {
    Optional<ValueLatticeElement> EdgeResult = getEdgeValue(Val, *PI, BB);
    if (!EdgeResult)
      // Explore that input, then return here
      return None;

    Result.mergeIn(*EdgeResult);

    // If we hit overdefined, exit early.  The BlockVals entry is already set
    // to overdefined.
    if (Result.isOverdefined()) {
      LLVM_DEBUG(dbgs() << " compute BB '" << BB->getName()
                        << "' - overdefined because of pred (non local).\n");
      // Before giving up, see if we can prove the pointer non-null local to
      // this particular block.
      PointerType *PTy = dyn_cast<PointerType>(Val->getType());
      if (PTy && isObjectDereferencedInBlock(Val, BB) &&
          !NullPointerIsDefined(BB->getParent(), PTy->getAddressSpace())) {
        Result = ValueLatticeElement::getNot(ConstantPointerNull::get(PTy));
      }

      return Result;
    }
  }

  // Return the merged value, which is more precise than 'overdefined'.
  assert(!Result.isOverdefined());
  return Result;
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValuePHINode(
    PHINode *PN, BasicBlock *BB) {
  ValueLatticeElement Result;  // Start Undefined.

  // Loop over all of our predecessors, merging what we know from them into
  // result.  See the comment about the chosen traversal order in
  // solveBlockValueNonLocal; the same reasoning applies here.
  for (unsigned i = 0, e = PN->getNumIncomingValues(); i != e; ++i) {
    BasicBlock *PhiBB = PN->getIncomingBlock(i);
    Value *PhiVal = PN->getIncomingValue(i);
    // Note that we can provide PN as the context value to getEdgeValue, even
    // though the results will be cached, because PN is the value being used as
    // the cache key in the caller.
    Optional<ValueLatticeElement> EdgeResult =
        getEdgeValue(PhiVal, PhiBB, BB, PN);
    if (!EdgeResult)
      // Explore that input, then return here
      return None;

    Result.mergeIn(*EdgeResult);

    // If we hit overdefined, exit early.  The BlockVals entry is already set
    // to overdefined.
    if (Result.isOverdefined()) {
      LLVM_DEBUG(dbgs() << " compute BB '" << BB->getName()
                        << "' - overdefined because of pred (local).\n");

      return Result;
    }
  }

  // Return the merged value, which is more precise than 'overdefined'.
  assert(!Result.isOverdefined() && "Possible PHI in entry block?");
  return Result;
}

static ValueLatticeElement getValueFromCondition(Value *Val, Value *Cond,
                                                 bool isTrueDest = true);

// If we can determine a constraint on the value given conditions assumed by
// the program, intersect those constraints with BBLV
void LazyValueInfoImpl::intersectAssumeOrGuardBlockValueConstantRange(
        Value *Val, ValueLatticeElement &BBLV, Instruction *BBI) {
  BBI = BBI ? BBI : dyn_cast<Instruction>(Val);
  if (!BBI)
    return;

  BasicBlock *BB = BBI->getParent();
  for (auto &AssumeVH : AC->assumptionsFor(Val)) {
    if (!AssumeVH)
      continue;

    // Only check assumes in the block of the context instruction. Other
    // assumes will have already been taken into account when the value was
    // propagated from predecessor blocks.
    auto *I = cast<CallInst>(AssumeVH);
    if (I->getParent() != BB || !isValidAssumeForContext(I, BBI))
      continue;

    BBLV = intersect(BBLV, getValueFromCondition(Val, I->getArgOperand(0)));
  }

  // If guards are not used in the module, don't spend time looking for them
  auto *GuardDecl = BBI->getModule()->getFunction(
          Intrinsic::getName(Intrinsic::experimental_guard));
  if (!GuardDecl || GuardDecl->use_empty())
    return;

  if (BBI->getIterator() == BB->begin())
    return;
  for (Instruction &I : make_range(std::next(BBI->getIterator().getReverse()),
                                   BB->rend())) {
    Value *Cond = nullptr;
    if (match(&I, m_Intrinsic<Intrinsic::experimental_guard>(m_Value(Cond))))
      BBLV = intersect(BBLV, getValueFromCondition(Val, Cond));
  }
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueSelect(
    SelectInst *SI, BasicBlock *BB) {
  // Recurse on our inputs if needed
  Optional<ValueLatticeElement> OptTrueVal =
      getBlockValue(SI->getTrueValue(), BB);
  if (!OptTrueVal)
    return None;
  ValueLatticeElement &TrueVal = *OptTrueVal;

  // If we hit overdefined, don't ask more queries.  We want to avoid poisoning
  // extra slots in the table if we can.
  if (TrueVal.isOverdefined())
    return ValueLatticeElement::getOverdefined();

  Optional<ValueLatticeElement> OptFalseVal =
      getBlockValue(SI->getFalseValue(), BB);
  if (!OptFalseVal)
    return None;
  ValueLatticeElement &FalseVal = *OptFalseVal;

  // If we hit overdefined, don't ask more queries.  We want to avoid poisoning
  // extra slots in the table if we can.
  if (FalseVal.isOverdefined())
    return ValueLatticeElement::getOverdefined();

  if (TrueVal.isConstantRange() && FalseVal.isConstantRange()) {
    const ConstantRange &TrueCR = TrueVal.getConstantRange();
    const ConstantRange &FalseCR = FalseVal.getConstantRange();
    Value *LHS = nullptr;
    Value *RHS = nullptr;
    SelectPatternResult SPR = matchSelectPattern(SI, LHS, RHS);
    // Is this a min specifically of our two inputs?  (Avoid the risk of
    // ValueTracking getting smarter looking back past our immediate inputs.)
    if (SelectPatternResult::isMinOrMax(SPR.Flavor) &&
        LHS == SI->getTrueValue() && RHS == SI->getFalseValue()) {
      ConstantRange ResultCR = [&]() {
        switch (SPR.Flavor) {
        default:
          llvm_unreachable("unexpected minmax type!");
        case SPF_SMIN:                   /// Signed minimum
          return TrueCR.smin(FalseCR);
        case SPF_UMIN:                   /// Unsigned minimum
          return TrueCR.umin(FalseCR);
        case SPF_SMAX:                   /// Signed maximum
          return TrueCR.smax(FalseCR);
        case SPF_UMAX:                   /// Unsigned maximum
          return TrueCR.umax(FalseCR);
        };
      }();
      return ValueLatticeElement::getRange(
          ResultCR, TrueVal.isConstantRangeIncludingUndef() |
                        FalseVal.isConstantRangeIncludingUndef());
    }

    if (SPR.Flavor == SPF_ABS) {
      if (LHS == SI->getTrueValue())
        return ValueLatticeElement::getRange(
            TrueCR.abs(), TrueVal.isConstantRangeIncludingUndef());
      if (LHS == SI->getFalseValue())
        return ValueLatticeElement::getRange(
            FalseCR.abs(), FalseVal.isConstantRangeIncludingUndef());
    }

    if (SPR.Flavor == SPF_NABS) {
      ConstantRange Zero(APInt::getNullValue(TrueCR.getBitWidth()));
      if (LHS == SI->getTrueValue())
        return ValueLatticeElement::getRange(
            Zero.sub(TrueCR.abs()), FalseVal.isConstantRangeIncludingUndef());
      if (LHS == SI->getFalseValue())
        return ValueLatticeElement::getRange(
            Zero.sub(FalseCR.abs()), FalseVal.isConstantRangeIncludingUndef());
    }
  }

  // Can we constrain the facts about the true and false values by using the
  // condition itself?  This shows up with idioms like e.g. select(a > 5, a, 5).
  // TODO: We could potentially refine an overdefined true value above.
  Value *Cond = SI->getCondition();
  TrueVal = intersect(TrueVal,
                      getValueFromCondition(SI->getTrueValue(), Cond, true));
  FalseVal = intersect(FalseVal,
                       getValueFromCondition(SI->getFalseValue(), Cond, false));

  // Handle clamp idioms such as:
  //   %24 = constantrange<0, 17>
  //   %39 = icmp eq i32 %24, 0
  //   %40 = add i32 %24, -1
  //   %siv.next = select i1 %39, i32 16, i32 %40
  //   %siv.next = constantrange<0, 17> not <-1, 17>
  // In general, this can handle any clamp idiom which tests the edge
  // condition via an equality or inequality.
  if (auto *ICI = dyn_cast<ICmpInst>(Cond)) {
    ICmpInst::Predicate Pred = ICI->getPredicate();
    Value *A = ICI->getOperand(0);
    if (ConstantInt *CIBase = dyn_cast<ConstantInt>(ICI->getOperand(1))) {
      auto addConstants = [](ConstantInt *A, ConstantInt *B) {
        assert(A->getType() == B->getType());
        return ConstantInt::get(A->getType(), A->getValue() + B->getValue());
      };
      // See if either input is A + C2, subject to the constraint from the
      // condition that A != C when that input is used.  We can assume that
      // that input doesn't include C + C2.
      ConstantInt *CIAdded;
      switch (Pred) {
      default: break;
      case ICmpInst::ICMP_EQ:
        if (match(SI->getFalseValue(), m_Add(m_Specific(A),
                                             m_ConstantInt(CIAdded)))) {
          auto ResNot = addConstants(CIBase, CIAdded);
          FalseVal = intersect(FalseVal,
                               ValueLatticeElement::getNot(ResNot));
        }
        break;
      case ICmpInst::ICMP_NE:
        if (match(SI->getTrueValue(), m_Add(m_Specific(A),
                                            m_ConstantInt(CIAdded)))) {
          auto ResNot = addConstants(CIBase, CIAdded);
          TrueVal = intersect(TrueVal,
                              ValueLatticeElement::getNot(ResNot));
        }
        break;
      };
    }
  }

  ValueLatticeElement Result = TrueVal;
  Result.mergeIn(FalseVal);
  return Result;
}

Optional<ConstantRange> LazyValueInfoImpl::getRangeForOperand(unsigned Op,
                                                              Instruction *I,
                                                              BasicBlock *BB) {
  Optional<ValueLatticeElement> OptVal = getBlockValue(I->getOperand(Op), BB);
  if (!OptVal)
    return None;

  ValueLatticeElement &Val = *OptVal;
  intersectAssumeOrGuardBlockValueConstantRange(I->getOperand(Op), Val, I);
  if (Val.isConstantRange())
    return Val.getConstantRange();

  const unsigned OperandBitWidth =
    DL.getTypeSizeInBits(I->getOperand(Op)->getType());
  return ConstantRange::getFull(OperandBitWidth);
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueCast(
    CastInst *CI, BasicBlock *BB) {
  // Without knowing how wide the input is, we can't analyze it in any useful
  // way.
  if (!CI->getOperand(0)->getType()->isSized())
    return ValueLatticeElement::getOverdefined();

  // Filter out casts we don't know how to reason about before attempting to
  // recurse on our operand.  This can cut a long search short if we know we're
  // not going to be able to get any useful information anways.
  switch (CI->getOpcode()) {
  case Instruction::Trunc:
  case Instruction::SExt:
  case Instruction::ZExt:
  case Instruction::BitCast:
    break;
  default:
    // Unhandled instructions are overdefined.
    LLVM_DEBUG(dbgs() << " compute BB '" << BB->getName()
                      << "' - overdefined (unknown cast).\n");
    return ValueLatticeElement::getOverdefined();
  }

  // Figure out the range of the LHS.  If that fails, we still apply the
  // transfer rule on the full set since we may be able to locally infer
  // interesting facts.
  Optional<ConstantRange> LHSRes = getRangeForOperand(0, CI, BB);
  if (!LHSRes.hasValue())
    // More work to do before applying this transfer rule.
    return None;
  const ConstantRange &LHSRange = LHSRes.getValue();

  const unsigned ResultBitWidth = CI->getType()->getIntegerBitWidth();

  // NOTE: We're currently limited by the set of operations that ConstantRange
  // can evaluate symbolically.  Enhancing that set will allows us to analyze
  // more definitions.
  return ValueLatticeElement::getRange(LHSRange.castOp(CI->getOpcode(),
                                                       ResultBitWidth));
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueBinaryOpImpl(
    Instruction *I, BasicBlock *BB,
    std::function<ConstantRange(const ConstantRange &,
                                const ConstantRange &)> OpFn) {
  // Figure out the ranges of the operands.  If that fails, use a
  // conservative range, but apply the transfer rule anyways.  This
  // lets us pick up facts from expressions like "and i32 (call i32
  // @foo()), 32"
  Optional<ConstantRange> LHSRes = getRangeForOperand(0, I, BB);
  Optional<ConstantRange> RHSRes = getRangeForOperand(1, I, BB);
  if (!LHSRes.hasValue() || !RHSRes.hasValue())
    // More work to do before applying this transfer rule.
    return None;

  const ConstantRange &LHSRange = LHSRes.getValue();
  const ConstantRange &RHSRange = RHSRes.getValue();
  return ValueLatticeElement::getRange(OpFn(LHSRange, RHSRange));
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueBinaryOp(
    BinaryOperator *BO, BasicBlock *BB) {
  assert(BO->getOperand(0)->getType()->isSized() &&
         "all operands to binary operators are sized");
  if (BO->getOpcode() == Instruction::Xor) {
    // Xor is the only operation not supported by ConstantRange::binaryOp().
    LLVM_DEBUG(dbgs() << " compute BB '" << BB->getName()
                      << "' - overdefined (unknown binary operator).\n");
    return ValueLatticeElement::getOverdefined();
  }

  if (auto *OBO = dyn_cast<OverflowingBinaryOperator>(BO)) {
    unsigned NoWrapKind = 0;
    if (OBO->hasNoUnsignedWrap())
      NoWrapKind |= OverflowingBinaryOperator::NoUnsignedWrap;
    if (OBO->hasNoSignedWrap())
      NoWrapKind |= OverflowingBinaryOperator::NoSignedWrap;

    return solveBlockValueBinaryOpImpl(
        BO, BB,
        [BO, NoWrapKind](const ConstantRange &CR1, const ConstantRange &CR2) {
          return CR1.overflowingBinaryOp(BO->getOpcode(), CR2, NoWrapKind);
        });
  }

  return solveBlockValueBinaryOpImpl(
      BO, BB, [BO](const ConstantRange &CR1, const ConstantRange &CR2) {
        return CR1.binaryOp(BO->getOpcode(), CR2);
      });
}

Optional<ValueLatticeElement>
LazyValueInfoImpl::solveBlockValueOverflowIntrinsic(WithOverflowInst *WO,
                                                    BasicBlock *BB) {
  return solveBlockValueBinaryOpImpl(
      WO, BB, [WO](const ConstantRange &CR1, const ConstantRange &CR2) {
        return CR1.binaryOp(WO->getBinaryOp(), CR2);
      });
}

Optional<ValueLatticeElement>
LazyValueInfoImpl::solveBlockValueSaturatingIntrinsic(SaturatingInst *SI,
                                                      BasicBlock *BB) {
  switch (SI->getIntrinsicID()) {
  case Intrinsic::uadd_sat:
    return solveBlockValueBinaryOpImpl(
        SI, BB, [](const ConstantRange &CR1, const ConstantRange &CR2) {
          return CR1.uadd_sat(CR2);
        });
  case Intrinsic::usub_sat:
    return solveBlockValueBinaryOpImpl(
        SI, BB, [](const ConstantRange &CR1, const ConstantRange &CR2) {
          return CR1.usub_sat(CR2);
        });
  case Intrinsic::sadd_sat:
    return solveBlockValueBinaryOpImpl(
        SI, BB, [](const ConstantRange &CR1, const ConstantRange &CR2) {
          return CR1.sadd_sat(CR2);
        });
  case Intrinsic::ssub_sat:
    return solveBlockValueBinaryOpImpl(
        SI, BB, [](const ConstantRange &CR1, const ConstantRange &CR2) {
          return CR1.ssub_sat(CR2);
        });
  default:
    llvm_unreachable("All llvm.sat intrinsic are handled.");
  }
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueIntrinsic(
    IntrinsicInst *II, BasicBlock *BB) {
  if (auto *SI = dyn_cast<SaturatingInst>(II))
    return solveBlockValueSaturatingIntrinsic(SI, BB);

  LLVM_DEBUG(dbgs() << " compute BB '" << BB->getName()
                    << "' - overdefined (unknown intrinsic).\n");
  return ValueLatticeElement::getOverdefined();
}

Optional<ValueLatticeElement> LazyValueInfoImpl::solveBlockValueExtractValue(
    ExtractValueInst *EVI, BasicBlock *BB) {
  if (auto *WO = dyn_cast<WithOverflowInst>(EVI->getAggregateOperand()))
    if (EVI->getNumIndices() == 1 && *EVI->idx_begin() == 0)
      return solveBlockValueOverflowIntrinsic(WO, BB);

  // Handle extractvalue of insertvalue to allow further simplification
  // based on replaced with.overflow intrinsics.
  if (Value *V = SimplifyExtractValueInst(
          EVI->getAggregateOperand(), EVI->getIndices(),
          EVI->getModule()->getDataLayout()))
    return getBlockValue(V, BB);

  LLVM_DEBUG(dbgs() << " compute BB '" << BB->getName()
                    << "' - overdefined (unknown extractvalue).\n");
  return ValueLatticeElement::getOverdefined();
}

static ValueLatticeElement getValueFromICmpCondition(Value *Val, ICmpInst *ICI,
                                                     bool isTrueDest) {
  Value *LHS = ICI->getOperand(0);
  Value *RHS = ICI->getOperand(1);
  CmpInst::Predicate Predicate = ICI->getPredicate();

  if (isa<Constant>(RHS)) {
    if (ICI->isEquality() && LHS == Val) {
      // We know that V has the RHS constant if this is a true SETEQ or
      // false SETNE.
      if (isTrueDest == (Predicate == ICmpInst::ICMP_EQ))
        return ValueLatticeElement::get(cast<Constant>(RHS));
      else if (!isa<UndefValue>(RHS))
        return ValueLatticeElement::getNot(cast<Constant>(RHS));
    }
  }

  if (!Val->getType()->isIntegerTy())
    return ValueLatticeElement::getOverdefined();

  // Use ConstantRange::makeAllowedICmpRegion in order to determine the possible
  // range of Val guaranteed by the condition. Recognize comparisons in the from
  // of:
  //  icmp <pred> Val, ...
  //  icmp <pred> (add Val, Offset), ...
  // The latter is the range checking idiom that InstCombine produces. Subtract
  // the offset from the allowed range for RHS in this case.

  // Val or (add Val, Offset) can be on either hand of the comparison
  if (LHS != Val && !match(LHS, m_Add(m_Specific(Val), m_ConstantInt()))) {
    std::swap(LHS, RHS);
    Predicate = CmpInst::getSwappedPredicate(Predicate);
  }

  ConstantInt *Offset = nullptr;
  if (LHS != Val)
    match(LHS, m_Add(m_Specific(Val), m_ConstantInt(Offset)));

  if (LHS == Val || Offset) {
    // Calculate the range of values that are allowed by the comparison
    ConstantRange RHSRange(RHS->getType()->getIntegerBitWidth(),
                           /*isFullSet=*/true);
    if (ConstantInt *CI = dyn_cast<ConstantInt>(RHS))
      RHSRange = ConstantRange(CI->getValue());
    else if (Instruction *I = dyn_cast<Instruction>(RHS))
      if (auto *Ranges = I->getMetadata(LLVMContext::MD_range))
        RHSRange = getConstantRangeFromMetadata(*Ranges);

    // If we're interested in the false dest, invert the condition
    CmpInst::Predicate Pred =
            isTrueDest ? Predicate : CmpInst::getInversePredicate(Predicate);
    ConstantRange TrueValues =
            ConstantRange::makeAllowedICmpRegion(Pred, RHSRange);

    if (Offset) // Apply the offset from above.
      TrueValues = TrueValues.subtract(Offset->getValue());

    return ValueLatticeElement::getRange(std::move(TrueValues));
  }

  return ValueLatticeElement::getOverdefined();
}

// Handle conditions of the form
// extractvalue(op.with.overflow(%x, C), 1).
static ValueLatticeElement getValueFromOverflowCondition(
    Value *Val, WithOverflowInst *WO, bool IsTrueDest) {
  // TODO: This only works with a constant RHS for now. We could also compute
  // the range of the RHS, but this doesn't fit into the current structure of
  // the edge value calculation.
  const APInt *C;
  if (WO->getLHS() != Val || !match(WO->getRHS(), m_APInt(C)))
    return ValueLatticeElement::getOverdefined();

  // Calculate the possible values of %x for which no overflow occurs.
  ConstantRange NWR = ConstantRange::makeExactNoWrapRegion(
      WO->getBinaryOp(), *C, WO->getNoWrapKind());

  // If overflow is false, %x is constrained to NWR. If overflow is true, %x is
  // constrained to it's inverse (all values that might cause overflow).
  if (IsTrueDest)
    NWR = NWR.inverse();
  return ValueLatticeElement::getRange(NWR);
}

static ValueLatticeElement
getValueFromCondition(Value *Val, Value *Cond, bool isTrueDest,
                      SmallDenseMap<Value*, ValueLatticeElement> &Visited);

static ValueLatticeElement
getValueFromConditionImpl(Value *Val, Value *Cond, bool isTrueDest,
                          SmallDenseMap<Value*, ValueLatticeElement> &Visited) {
  if (ICmpInst *ICI = dyn_cast<ICmpInst>(Cond))
    return getValueFromICmpCondition(Val, ICI, isTrueDest);

  if (auto *EVI = dyn_cast<ExtractValueInst>(Cond))
    if (auto *WO = dyn_cast<WithOverflowInst>(EVI->getAggregateOperand()))
      if (EVI->getNumIndices() == 1 && *EVI->idx_begin() == 1)
        return getValueFromOverflowCondition(Val, WO, isTrueDest);

  // Handle conditions in the form of (cond1 && cond2), we know that on the
  // true dest path both of the conditions hold. Similarly for conditions of
  // the form (cond1 || cond2), we know that on the false dest path neither
  // condition holds.
  BinaryOperator *BO = dyn_cast<BinaryOperator>(Cond);
  if (!BO || (isTrueDest && BO->getOpcode() != BinaryOperator::And) ||
             (!isTrueDest && BO->getOpcode() != BinaryOperator::Or))
    return ValueLatticeElement::getOverdefined();

  // Prevent infinite recursion if Cond references itself as in this example:
  //  Cond: "%tmp4 = and i1 %tmp4, undef"
  //    BL: "%tmp4 = and i1 %tmp4, undef"
  //    BR: "i1 undef"
  Value *BL = BO->getOperand(0);
  Value *BR = BO->getOperand(1);
  if (BL == Cond || BR == Cond)
    return ValueLatticeElement::getOverdefined();

  return intersect(getValueFromCondition(Val, BL, isTrueDest, Visited),
                   getValueFromCondition(Val, BR, isTrueDest, Visited));
}

static ValueLatticeElement
getValueFromCondition(Value *Val, Value *Cond, bool isTrueDest,
                      SmallDenseMap<Value*, ValueLatticeElement> &Visited) {
  auto I = Visited.find(Cond);
  if (I != Visited.end())
    return I->second;

  auto Result = getValueFromConditionImpl(Val, Cond, isTrueDest, Visited);
  Visited[Cond] = Result;
  return Result;
}

ValueLatticeElement getValueFromCondition(Value *Val, Value *Cond,
                                          bool isTrueDest) {
  assert(Cond && "precondition");
  SmallDenseMap<Value*, ValueLatticeElement> Visited;
  return getValueFromCondition(Val, Cond, isTrueDest, Visited);
}

// Return true if Usr has Op as an operand, otherwise false.
static bool usesOperand(User *Usr, Value *Op) {
  return find(Usr->operands(), Op) != Usr->op_end();
}

// Return true if the instruction type of Val is supported by
// constantFoldUser(). Currently CastInst and BinaryOperator only.  Call this
// before calling constantFoldUser() to find out if it's even worth attempting
// to call it.
static bool isOperationFoldable(User *Usr) {
  return isa<CastInst>(Usr) || isa<BinaryOperator>(Usr);
}

// Check if Usr can be simplified to an integer constant when the value of one
// of its operands Op is an integer constant OpConstVal. If so, return it as an
// lattice value range with a single element or otherwise return an overdefined
// lattice value.
static ValueLatticeElement constantFoldUser(User *Usr, Value *Op,
                                            const APInt &OpConstVal,
                                            const DataLayout &DL) {
  assert(isOperationFoldable(Usr) && "Precondition");
  Constant* OpConst = Constant::getIntegerValue(Op->getType(), OpConstVal);
  // Check if Usr can be simplified to a constant.
  if (auto *CI = dyn_cast<CastInst>(Usr)) {
    assert(CI->getOperand(0) == Op && "Operand 0 isn't Op");
    if (auto *C = dyn_cast_or_null<ConstantInt>(
            SimplifyCastInst(CI->getOpcode(), OpConst,
                             CI->getDestTy(), DL))) {
      return ValueLatticeElement::getRange(ConstantRange(C->getValue()));
    }
  } else if (auto *BO = dyn_cast<BinaryOperator>(Usr)) {
    bool Op0Match = BO->getOperand(0) == Op;
    bool Op1Match = BO->getOperand(1) == Op;
    assert((Op0Match || Op1Match) &&
           "Operand 0 nor Operand 1 isn't a match");
    Value *LHS = Op0Match ? OpConst : BO->getOperand(0);
    Value *RHS = Op1Match ? OpConst : BO->getOperand(1);
    if (auto *C = dyn_cast_or_null<ConstantInt>(
            SimplifyBinOp(BO->getOpcode(), LHS, RHS, DL))) {
      return ValueLatticeElement::getRange(ConstantRange(C->getValue()));
    }
  }
  return ValueLatticeElement::getOverdefined();
}

/// Compute the value of Val on the edge BBFrom -> BBTo. Returns false if
/// Val is not constrained on the edge.  Result is unspecified if return value
/// is false.
static Optional<ValueLatticeElement> getEdgeValueLocal(Value *Val,
                                                       BasicBlock *BBFrom,
                                                       BasicBlock *BBTo) {
  // TODO: Handle more complex conditionals. If (v == 0 || v2 < 1) is false, we
  // know that v != 0.
  if (BranchInst *BI = dyn_cast<BranchInst>(BBFrom->getTerminator())) {
    // If this is a conditional branch and only one successor goes to BBTo, then
    // we may be able to infer something from the condition.
    if (BI->isConditional() &&
        BI->getSuccessor(0) != BI->getSuccessor(1)) {
      bool isTrueDest = BI->getSuccessor(0) == BBTo;
      assert(BI->getSuccessor(!isTrueDest) == BBTo &&
             "BBTo isn't a successor of BBFrom");
      Value *Condition = BI->getCondition();

      // If V is the condition of the branch itself, then we know exactly what
      // it is.
      if (Condition == Val)
        return ValueLatticeElement::get(ConstantInt::get(
                              Type::getInt1Ty(Val->getContext()), isTrueDest));

      // If the condition of the branch is an equality comparison, we may be
      // able to infer the value.
      ValueLatticeElement Result = getValueFromCondition(Val, Condition,
                                                         isTrueDest);
      if (!Result.isOverdefined())
        return Result;

      if (User *Usr = dyn_cast<User>(Val)) {
        assert(Result.isOverdefined() && "Result isn't overdefined");
        // Check with isOperationFoldable() first to avoid linearly iterating
        // over the operands unnecessarily which can be expensive for
        // instructions with many operands.
        if (isa<IntegerType>(Usr->getType()) && isOperationFoldable(Usr)) {
          const DataLayout &DL = BBTo->getModule()->getDataLayout();
          if (usesOperand(Usr, Condition)) {
            // If Val has Condition as an operand and Val can be folded into a
            // constant with either Condition == true or Condition == false,
            // propagate the constant.
            // eg.
            //   ; %Val is true on the edge to %then.
            //   %Val = and i1 %Condition, true.
            //   br %Condition, label %then, label %else
            APInt ConditionVal(1, isTrueDest ? 1 : 0);
            Result = constantFoldUser(Usr, Condition, ConditionVal, DL);
          } else {
            // If one of Val's operand has an inferred value, we may be able to
            // infer the value of Val.
            // eg.
            //    ; %Val is 94 on the edge to %then.
            //    %Val = add i8 %Op, 1
            //    %Condition = icmp eq i8 %Op, 93
            //    br i1 %Condition, label %then, label %else
            for (unsigned i = 0; i < Usr->getNumOperands(); ++i) {
              Value *Op = Usr->getOperand(i);
              ValueLatticeElement OpLatticeVal =
                  getValueFromCondition(Op, Condition, isTrueDest);
              if (Optional<APInt> OpConst = OpLatticeVal.asConstantInteger()) {
                Result = constantFoldUser(Usr, Op, OpConst.getValue(), DL);
                break;
              }
            }
          }
        }
      }
      if (!Result.isOverdefined())
        return Result;
    }
  }

  // If the edge was formed by a switch on the value, then we may know exactly
  // what it is.
  if (SwitchInst *SI = dyn_cast<SwitchInst>(BBFrom->getTerminator())) {
    Value *Condition = SI->getCondition();
    if (!isa<IntegerType>(Val->getType()))
      return None;
    bool ValUsesConditionAndMayBeFoldable = false;
    if (Condition != Val) {
      // Check if Val has Condition as an operand.
      if (User *Usr = dyn_cast<User>(Val))
        ValUsesConditionAndMayBeFoldable = isOperationFoldable(Usr) &&
            usesOperand(Usr, Condition);
      if (!ValUsesConditionAndMayBeFoldable)
        return None;
    }
    assert((Condition == Val || ValUsesConditionAndMayBeFoldable) &&
           "Condition != Val nor Val doesn't use Condition");

    bool DefaultCase = SI->getDefaultDest() == BBTo;
    unsigned BitWidth = Val->getType()->getIntegerBitWidth();
    ConstantRange EdgesVals(BitWidth, DefaultCase/*isFullSet*/);

    for (auto Case : SI->cases()) {
      APInt CaseValue = Case.getCaseValue()->getValue();
      ConstantRange EdgeVal(CaseValue);
      if (ValUsesConditionAndMayBeFoldable) {
        User *Usr = cast<User>(Val);
        const DataLayout &DL = BBTo->getModule()->getDataLayout();
        ValueLatticeElement EdgeLatticeVal =
            constantFoldUser(Usr, Condition, CaseValue, DL);
        if (EdgeLatticeVal.isOverdefined())
          return None;
        EdgeVal = EdgeLatticeVal.getConstantRange();
      }
      if (DefaultCase) {
        // It is possible that the default destination is the destination of
        // some cases. We cannot perform difference for those cases.
        // We know Condition != CaseValue in BBTo.  In some cases we can use
        // this to infer Val == f(Condition) is != f(CaseValue).  For now, we
        // only do this when f is identity (i.e. Val == Condition), but we
        // should be able to do this for any injective f.
        if (Case.getCaseSuccessor() != BBTo && Condition == Val)
          EdgesVals = EdgesVals.difference(EdgeVal);
      } else if (Case.getCaseSuccessor() == BBTo)
        EdgesVals = EdgesVals.unionWith(EdgeVal);
    }
    return ValueLatticeElement::getRange(std::move(EdgesVals));
  }
  return None;
}

/// Compute the value of Val on the edge BBFrom -> BBTo or the value at
/// the basic block if the edge does not constrain Val.
Optional<ValueLatticeElement> LazyValueInfoImpl::getEdgeValue(
    Value *Val, BasicBlock *BBFrom, BasicBlock *BBTo, Instruction *CxtI) {
  // If already a constant, there is nothing to compute.
  if (Constant *VC = dyn_cast<Constant>(Val))
    return ValueLatticeElement::get(VC);

  ValueLatticeElement LocalResult = getEdgeValueLocal(Val, BBFrom, BBTo)
      .getValueOr(ValueLatticeElement::getOverdefined());
  if (hasSingleValue(LocalResult))
    // Can't get any more precise here
    return LocalResult;

  Optional<ValueLatticeElement> OptInBlock = getBlockValue(Val, BBFrom);
  if (!OptInBlock)
    return None;
  ValueLatticeElement &InBlock = *OptInBlock;

  // Try to intersect ranges of the BB and the constraint on the edge.
  intersectAssumeOrGuardBlockValueConstantRange(Val, InBlock,
                                                BBFrom->getTerminator());
  // We can use the context instruction (generically the ultimate instruction
  // the calling pass is trying to simplify) here, even though the result of
  // this function is generally cached when called from the solve* functions
  // (and that cached result might be used with queries using a different
  // context instruction), because when this function is called from the solve*
  // functions, the context instruction is not provided. When called from
  // LazyValueInfoImpl::getValueOnEdge, the context instruction is provided,
  // but then the result is not cached.
  intersectAssumeOrGuardBlockValueConstantRange(Val, InBlock, CxtI);

  return intersect(LocalResult, InBlock);
}

ValueLatticeElement LazyValueInfoImpl::getValueInBlock(Value *V, BasicBlock *BB,
                                                       Instruction *CxtI) {
  LLVM_DEBUG(dbgs() << "LVI Getting block end value " << *V << " at '"
                    << BB->getName() << "'\n");

  assert(BlockValueStack.empty() && BlockValueSet.empty());
  Optional<ValueLatticeElement> OptResult = getBlockValue(V, BB);
  if (!OptResult) {
    solve();
    OptResult = getBlockValue(V, BB);
    assert(OptResult && "Value not available after solving");
  }
  ValueLatticeElement Result = *OptResult;
  intersectAssumeOrGuardBlockValueConstantRange(V, Result, CxtI);

  LLVM_DEBUG(dbgs() << "  Result = " << Result << "\n");
  return Result;
}

ValueLatticeElement LazyValueInfoImpl::getValueAt(Value *V, Instruction *CxtI) {
  LLVM_DEBUG(dbgs() << "LVI Getting value " << *V << " at '" << CxtI->getName()
                    << "'\n");

  if (auto *C = dyn_cast<Constant>(V))
    return ValueLatticeElement::get(C);

  ValueLatticeElement Result = ValueLatticeElement::getOverdefined();
  if (auto *I = dyn_cast<Instruction>(V))
    Result = getFromRangeMetadata(I);
  intersectAssumeOrGuardBlockValueConstantRange(V, Result, CxtI);

  LLVM_DEBUG(dbgs() << "  Result = " << Result << "\n");
  return Result;
}

ValueLatticeElement LazyValueInfoImpl::
getValueOnEdge(Value *V, BasicBlock *FromBB, BasicBlock *ToBB,
               Instruction *CxtI) {
  LLVM_DEBUG(dbgs() << "LVI Getting edge value " << *V << " from '"
                    << FromBB->getName() << "' to '" << ToBB->getName()
                    << "'\n");

  Optional<ValueLatticeElement> Result = getEdgeValue(V, FromBB, ToBB, CxtI);
  if (!Result) {
    solve();
    Result = getEdgeValue(V, FromBB, ToBB, CxtI);
    assert(Result && "More work to do after problem solved?");
  }

  LLVM_DEBUG(dbgs() << "  Result = " << *Result << "\n");
  return *Result;
}

void LazyValueInfoImpl::threadEdge(BasicBlock *PredBB, BasicBlock *OldSucc,
                                   BasicBlock *NewSucc) {
  TheCache.threadEdgeImpl(OldSucc, NewSucc);
}

//===----------------------------------------------------------------------===//
//                            LazyValueInfo Impl
//===----------------------------------------------------------------------===//

/// This lazily constructs the LazyValueInfoImpl.
static LazyValueInfoImpl &getImpl(void *&PImpl, AssumptionCache *AC,
                                  const DataLayout *DL) {
  if (!PImpl) {
    assert(DL && "getCache() called with a null DataLayout");
    PImpl = new LazyValueInfoImpl(AC, *DL);
  }
  return *static_cast<LazyValueInfoImpl*>(PImpl);
}

bool LazyValueInfoWrapperPass::runOnFunction(Function &F) {
  Info.AC = &getAnalysis<AssumptionCacheTracker>().getAssumptionCache(F);
  const DataLayout &DL = F.getParent()->getDataLayout();
  Info.TLI = &getAnalysis<TargetLibraryInfoWrapperPass>().getTLI(F);

  if (Info.PImpl)
    getImpl(Info.PImpl, Info.AC, &DL).clear();

  // Fully lazy.
  return false;
}

void LazyValueInfoWrapperPass::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
  AU.addRequired<AssumptionCacheTracker>();
  AU.addRequired<TargetLibraryInfoWrapperPass>();
}

LazyValueInfo &LazyValueInfoWrapperPass::getLVI() { return Info; }

LazyValueInfo::~LazyValueInfo() { releaseMemory(); }

void LazyValueInfo::releaseMemory() {
  // If the cache was allocated, free it.
  if (PImpl) {
    delete &getImpl(PImpl, AC, nullptr);
    PImpl = nullptr;
  }
}

bool LazyValueInfo::invalidate(Function &F, const PreservedAnalyses &PA,
                               FunctionAnalysisManager::Invalidator &Inv) {
  // We need to invalidate if we have either failed to preserve this analyses
  // result directly or if any of its dependencies have been invalidated.
  auto PAC = PA.getChecker<LazyValueAnalysis>();
  if (!(PAC.preserved() || PAC.preservedSet<AllAnalysesOn<Function>>()))
    return true;

  return false;
}

void LazyValueInfoWrapperPass::releaseMemory() { Info.releaseMemory(); }

LazyValueInfo LazyValueAnalysis::run(Function &F,
                                     FunctionAnalysisManager &FAM) {
  auto &AC = FAM.getResult<AssumptionAnalysis>(F);
  auto &TLI = FAM.getResult<TargetLibraryAnalysis>(F);

  return LazyValueInfo(&AC, &F.getParent()->getDataLayout(), &TLI);
}

/// Returns true if we can statically tell that this value will never be a
/// "useful" constant.  In practice, this means we've got something like an
/// alloca or a malloc call for which a comparison against a constant can
/// only be guarding dead code.  Note that we are potentially giving up some
/// precision in dead code (a constant result) in favour of avoiding a
/// expensive search for a easily answered common query.
static bool isKnownNonConstant(Value *V) {
  V = V->stripPointerCasts();
  // The return val of alloc cannot be a Constant.
  if (isa<AllocaInst>(V))
    return true;
  return false;
}

Constant *LazyValueInfo::getConstant(Value *V, BasicBlock *BB,
                                     Instruction *CxtI) {
  // Bail out early if V is known not to be a Constant.
  if (isKnownNonConstant(V))
    return nullptr;

  const DataLayout &DL = BB->getModule()->getDataLayout();
  ValueLatticeElement Result =
      getImpl(PImpl, AC, &DL).getValueInBlock(V, BB, CxtI);

  if (Result.isConstant())
    return Result.getConstant();
  if (Result.isConstantRange()) {
    const ConstantRange &CR = Result.getConstantRange();
    if (const APInt *SingleVal = CR.getSingleElement())
      return ConstantInt::get(V->getContext(), *SingleVal);
  }
  return nullptr;
}

ConstantRange LazyValueInfo::getConstantRange(Value *V, BasicBlock *BB,
                                              Instruction *CxtI,
                                              bool UndefAllowed) {
  assert(V->getType()->isIntegerTy());
  unsigned Width = V->getType()->getIntegerBitWidth();
  const DataLayout &DL = BB->getModule()->getDataLayout();
  ValueLatticeElement Result =
      getImpl(PImpl, AC, &DL).getValueInBlock(V, BB, CxtI);
  if (Result.isUnknown())
    return ConstantRange::getEmpty(Width);
  if (Result.isConstantRange(UndefAllowed))
    return Result.getConstantRange(UndefAllowed);
  // We represent ConstantInt constants as constant ranges but other kinds
  // of integer constants, i.e. ConstantExpr will be tagged as constants
  assert(!(Result.isConstant() && isa<ConstantInt>(Result.getConstant())) &&
         "ConstantInt value must be represented as constantrange");
  return ConstantRange::getFull(Width);
}

/// Determine whether the specified value is known to be a
/// constant on the specified edge. Return null if not.
Constant *LazyValueInfo::getConstantOnEdge(Value *V, BasicBlock *FromBB,
                                           BasicBlock *ToBB,
                                           Instruction *CxtI) {
  const DataLayout &DL = FromBB->getModule()->getDataLayout();
  ValueLatticeElement Result =
      getImpl(PImpl, AC, &DL).getValueOnEdge(V, FromBB, ToBB, CxtI);

  if (Result.isConstant())
    return Result.getConstant();
  if (Result.isConstantRange()) {
    const ConstantRange &CR = Result.getConstantRange();
    if (const APInt *SingleVal = CR.getSingleElement())
      return ConstantInt::get(V->getContext(), *SingleVal);
  }
  return nullptr;
}

ConstantRange LazyValueInfo::getConstantRangeOnEdge(Value *V,
                                                    BasicBlock *FromBB,
                                                    BasicBlock *ToBB,
                                                    Instruction *CxtI) {
  unsigned Width = V->getType()->getIntegerBitWidth();
  const DataLayout &DL = FromBB->getModule()->getDataLayout();
  ValueLatticeElement Result =
      getImpl(PImpl, AC, &DL).getValueOnEdge(V, FromBB, ToBB, CxtI);

  if (Result.isUnknown())
    return ConstantRange::getEmpty(Width);
  if (Result.isConstantRange())
    return Result.getConstantRange();
  // We represent ConstantInt constants as constant ranges but other kinds
  // of integer constants, i.e. ConstantExpr will be tagged as constants
  assert(!(Result.isConstant() && isa<ConstantInt>(Result.getConstant())) &&
         "ConstantInt value must be represented as constantrange");
  return ConstantRange::getFull(Width);
}

static LazyValueInfo::Tristate
getPredicateResult(unsigned Pred, Constant *C, const ValueLatticeElement &Val,
                   const DataLayout &DL, TargetLibraryInfo *TLI) {
  // If we know the value is a constant, evaluate the conditional.
  Constant *Res = nullptr;
  if (Val.isConstant()) {
    Res = ConstantFoldCompareInstOperands(Pred, Val.getConstant(), C, DL, TLI);
    if (ConstantInt *ResCI = dyn_cast<ConstantInt>(Res))
      return ResCI->isZero() ? LazyValueInfo::False : LazyValueInfo::True;
    return LazyValueInfo::Unknown;
  }

  if (Val.isConstantRange()) {
    ConstantInt *CI = dyn_cast<ConstantInt>(C);
    if (!CI) return LazyValueInfo::Unknown;

    const ConstantRange &CR = Val.getConstantRange();
    if (Pred == ICmpInst::ICMP_EQ) {
      if (!CR.contains(CI->getValue()))
        return LazyValueInfo::False;

      if (CR.isSingleElement())
        return LazyValueInfo::True;
    } else if (Pred == ICmpInst::ICMP_NE) {
      if (!CR.contains(CI->getValue()))
        return LazyValueInfo::True;

      if (CR.isSingleElement())
        return LazyValueInfo::False;
    } else {
      // Handle more complex predicates.
      ConstantRange TrueValues = ConstantRange::makeExactICmpRegion(
          (ICmpInst::Predicate)Pred, CI->getValue());
      if (TrueValues.contains(CR))
        return LazyValueInfo::True;
      if (TrueValues.inverse().contains(CR))
        return LazyValueInfo::False;
    }
    return LazyValueInfo::Unknown;
  }

  if (Val.isNotConstant()) {
    // If this is an equality comparison, we can try to fold it knowing that
    // "V != C1".
    if (Pred == ICmpInst::ICMP_EQ) {
      // !C1 == C -> false iff C1 == C.
      Res = ConstantFoldCompareInstOperands(ICmpInst::ICMP_NE,
                                            Val.getNotConstant(), C, DL,
                                            TLI);
      if (Res->isNullValue())
        return LazyValueInfo::False;
    } else if (Pred == ICmpInst::ICMP_NE) {
      // !C1 != C -> true iff C1 == C.
      Res = ConstantFoldCompareInstOperands(ICmpInst::ICMP_NE,
                                            Val.getNotConstant(), C, DL,
                                            TLI);
      if (Res->isNullValue())
        return LazyValueInfo::True;
    }
    return LazyValueInfo::Unknown;
  }

  return LazyValueInfo::Unknown;
}

/// Determine whether the specified value comparison with a constant is known to
/// be true or false on the specified CFG edge. Pred is a CmpInst predicate.
LazyValueInfo::Tristate
LazyValueInfo::getPredicateOnEdge(unsigned Pred, Value *V, Constant *C,
                                  BasicBlock *FromBB, BasicBlock *ToBB,
                                  Instruction *CxtI) {
  const DataLayout &DL = FromBB->getModule()->getDataLayout();
  ValueLatticeElement Result =
      getImpl(PImpl, AC, &DL).getValueOnEdge(V, FromBB, ToBB, CxtI);

  return getPredicateResult(Pred, C, Result, DL, TLI);
}

LazyValueInfo::Tristate
LazyValueInfo::getPredicateAt(unsigned Pred, Value *V, Constant *C,
                              Instruction *CxtI) {
  // Is or is not NonNull are common predicates being queried. If
  // isKnownNonZero can tell us the result of the predicate, we can
  // return it quickly. But this is only a fastpath, and falling
  // through would still be correct.
  const DataLayout &DL = CxtI->getModule()->getDataLayout();
  if (V->getType()->isPointerTy() && C->isNullValue() &&
      isKnownNonZero(V->stripPointerCastsSameRepresentation(), DL)) {
    if (Pred == ICmpInst::ICMP_EQ)
      return LazyValueInfo::False;
    else if (Pred == ICmpInst::ICMP_NE)
      return LazyValueInfo::True;
  }
  ValueLatticeElement Result = getImpl(PImpl, AC, &DL).getValueAt(V, CxtI);
  Tristate Ret = getPredicateResult(Pred, C, Result, DL, TLI);
  if (Ret != Unknown)
    return Ret;

  // Note: The following bit of code is somewhat distinct from the rest of LVI;
  // LVI as a whole tries to compute a lattice value which is conservatively
  // correct at a given location.  In this case, we have a predicate which we
  // weren't able to prove about the merged result, and we're pushing that
  // predicate back along each incoming edge to see if we can prove it
  // separately for each input.  As a motivating example, consider:
  // bb1:
  //   %v1 = ... ; constantrange<1, 5>
  //   br label %merge
  // bb2:
  //   %v2 = ... ; constantrange<10, 20>
  //   br label %merge
  // merge:
  //   %phi = phi [%v1, %v2] ; constantrange<1,20>
  //   %pred = icmp eq i32 %phi, 8
  // We can't tell from the lattice value for '%phi' that '%pred' is false
  // along each path, but by checking the predicate over each input separately,
  // we can.
  // We limit the search to one step backwards from the current BB and value.
  // We could consider extending this to search further backwards through the
  // CFG and/or value graph, but there are non-obvious compile time vs quality
  // tradeoffs.
  if (CxtI) {
    BasicBlock *BB = CxtI->getParent();

    // Function entry or an unreachable block.  Bail to avoid confusing
    // analysis below.
    pred_iterator PI = pred_begin(BB), PE = pred_end(BB);
    if (PI == PE)
      return Unknown;

    // If V is a PHI node in the same block as the context, we need to ask
    // questions about the predicate as applied to the incoming value along
    // each edge. This is useful for eliminating cases where the predicate is
    // known along all incoming edges.
    if (auto *PHI = dyn_cast<PHINode>(V))
      if (PHI->getParent() == BB) {
        Tristate Baseline = Unknown;
        for (unsigned i = 0, e = PHI->getNumIncomingValues(); i < e; i++) {
          Value *Incoming = PHI->getIncomingValue(i);
          BasicBlock *PredBB = PHI->getIncomingBlock(i);
          // Note that PredBB may be BB itself.
          Tristate Result = getPredicateOnEdge(Pred, Incoming, C, PredBB, BB,
                                               CxtI);

          // Keep going as long as we've seen a consistent known result for
          // all inputs.
          Baseline = (i == 0) ? Result /* First iteration */
            : (Baseline == Result ? Baseline : Unknown); /* All others */
          if (Baseline == Unknown)
            break;
        }
        if (Baseline != Unknown)
          return Baseline;
      }

    // For a comparison where the V is outside this block, it's possible
    // that we've branched on it before. Look to see if the value is known
    // on all incoming edges.
    if (!isa<Instruction>(V) ||
        cast<Instruction>(V)->getParent() != BB) {
      // For predecessor edge, determine if the comparison is true or false
      // on that edge. If they're all true or all false, we can conclude
      // the value of the comparison in this block.
      Tristate Baseline = getPredicateOnEdge(Pred, V, C, *PI, BB, CxtI);
      if (Baseline != Unknown) {
        // Check that all remaining incoming values match the first one.
        while (++PI != PE) {
          Tristate Ret = getPredicateOnEdge(Pred, V, C, *PI, BB, CxtI);
          if (Ret != Baseline) break;
        }
        // If we terminated early, then one of the values didn't match.
        if (PI == PE) {
          return Baseline;
        }
      }
    }
  }
  return Unknown;
}

void LazyValueInfo::threadEdge(BasicBlock *PredBB, BasicBlock *OldSucc,
                               BasicBlock *NewSucc) {
  if (PImpl) {
    const DataLayout &DL = PredBB->getModule()->getDataLayout();
    getImpl(PImpl, AC, &DL).threadEdge(PredBB, OldSucc, NewSucc);
  }
}

void LazyValueInfo::eraseBlock(BasicBlock *BB) {
  if (PImpl) {
    const DataLayout &DL = BB->getModule()->getDataLayout();
    getImpl(PImpl, AC, &DL).eraseBlock(BB);
  }
}


void LazyValueInfo::printLVI(Function &F, DominatorTree &DTree, raw_ostream &OS) {
  if (PImpl) {
    getImpl(PImpl, AC, DL).printLVI(F, DTree, OS);
  }
}

// Print the LVI for the function arguments at the start of each basic block.
void LazyValueInfoAnnotatedWriter::emitBasicBlockStartAnnot(
    const BasicBlock *BB, formatted_raw_ostream &OS) {
  // Find if there are latticevalues defined for arguments of the function.
  auto *F = BB->getParent();
  for (auto &Arg : F->args()) {
    ValueLatticeElement Result = LVIImpl->getValueInBlock(
        const_cast<Argument *>(&Arg), const_cast<BasicBlock *>(BB));
    if (Result.isUnknown())
      continue;
    OS << "; LatticeVal for: '" << Arg << "' is: " << Result << "\n";
  }
}

// This function prints the LVI analysis for the instruction I at the beginning
// of various basic blocks. It relies on calculated values that are stored in
// the LazyValueInfoCache, and in the absence of cached values, recalculate the
// LazyValueInfo for `I`, and print that info.
void LazyValueInfoAnnotatedWriter::emitInstructionAnnot(
    const Instruction *I, formatted_raw_ostream &OS) {

  auto *ParentBB = I->getParent();
  SmallPtrSet<const BasicBlock*, 16> BlocksContainingLVI;
  // We can generate (solve) LVI values only for blocks that are dominated by
  // the I's parent. However, to avoid generating LVI for all dominating blocks,
  // that contain redundant/uninteresting information, we print LVI for
  // blocks that may use this LVI information (such as immediate successor
  // blocks, and blocks that contain uses of `I`).
  auto printResult = [&](const BasicBlock *BB) {
    if (!BlocksContainingLVI.insert(BB).second)
      return;
    ValueLatticeElement Result = LVIImpl->getValueInBlock(
        const_cast<Instruction *>(I), const_cast<BasicBlock *>(BB));
      OS << "; LatticeVal for: '" << *I << "' in BB: '";
      BB->printAsOperand(OS, false);
      OS << "' is: " << Result << "\n";
  };

  printResult(ParentBB);
  // Print the LVI analysis results for the immediate successor blocks, that
  // are dominated by `ParentBB`.
  for (auto *BBSucc : successors(ParentBB))
    if (DT.dominates(ParentBB, BBSucc))
      printResult(BBSucc);

  // Print LVI in blocks where `I` is used.
  for (auto *U : I->users())
    if (auto *UseI = dyn_cast<Instruction>(U))
      if (!isa<PHINode>(UseI) || DT.dominates(ParentBB, UseI->getParent()))
        printResult(UseI->getParent());

}

namespace {
// Printer class for LazyValueInfo results.
class LazyValueInfoPrinter : public FunctionPass {
public:
  static char ID; // Pass identification, replacement for typeid
  LazyValueInfoPrinter() : FunctionPass(ID) {
    initializeLazyValueInfoPrinterPass(*PassRegistry::getPassRegistry());
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesAll();
    AU.addRequired<LazyValueInfoWrapperPass>();
    AU.addRequired<DominatorTreeWrapperPass>();
  }

  // Get the mandatory dominator tree analysis and pass this in to the
  // LVIPrinter. We cannot rely on the LVI's DT, since it's optional.
  bool runOnFunction(Function &F) override {
    dbgs() << "LVI for function '" << F.getName() << "':\n";
    auto &LVI = getAnalysis<LazyValueInfoWrapperPass>().getLVI();
    auto &DTree = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    LVI.printLVI(F, DTree, dbgs());
    return false;
  }
};
}

char LazyValueInfoPrinter::ID = 0;
INITIALIZE_PASS_BEGIN(LazyValueInfoPrinter, "print-lazy-value-info",
                "Lazy Value Info Printer Pass", false, false)
INITIALIZE_PASS_DEPENDENCY(LazyValueInfoWrapperPass)
INITIALIZE_PASS_END(LazyValueInfoPrinter, "print-lazy-value-info",
                "Lazy Value Info Printer Pass", false, false)
