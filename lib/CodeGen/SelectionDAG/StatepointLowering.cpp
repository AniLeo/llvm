//===- StatepointLowering.cpp - SDAGBuilder's statepoint code -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file includes support code use by SelectionDAGBuilder when lowering a
// statepoint sequence in SelectionDAG IR.
//
//===----------------------------------------------------------------------===//

#include "StatepointLowering.h"
#include "SelectionDAGBuilder.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/None.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/FunctionLoweringInfo.h"
#include "llvm/CodeGen/GCMetadata.h"
#include "llvm/CodeGen/GCStrategy.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/RuntimeLibcalls.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"
#include "llvm/CodeGen/StackMaps.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Statepoint.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MachineValueType.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <iterator>
#include <tuple>
#include <utility>

using namespace llvm;

#define DEBUG_TYPE "statepoint-lowering"

STATISTIC(NumSlotsAllocatedForStatepoints,
          "Number of stack slots allocated for statepoints");
STATISTIC(NumOfStatepoints, "Number of statepoint nodes encountered");
STATISTIC(StatepointMaxSlotsRequired,
          "Maximum number of stack slots required for a singe statepoint");

cl::opt<bool> UseRegistersForDeoptValues(
    "use-registers-for-deopt-values", cl::Hidden, cl::init(false),
    cl::desc("Allow using registers for non pointer deopt args"));

cl::opt<unsigned> MaxRegistersForGCPointers(
    "max-registers-for-gc-values", cl::Hidden, cl::init(0),
    cl::desc("Max number of VRegs allowed to pass GC pointer meta args in"));

typedef FunctionLoweringInfo::StatepointRelocationRecord RecordType;

static void pushStackMapConstant(SmallVectorImpl<SDValue>& Ops,
                                 SelectionDAGBuilder &Builder, uint64_t Value) {
  SDLoc L = Builder.getCurSDLoc();
  Ops.push_back(Builder.DAG.getTargetConstant(StackMaps::ConstantOp, L,
                                              MVT::i64));
  Ops.push_back(Builder.DAG.getTargetConstant(Value, L, MVT::i64));
}

void StatepointLoweringState::startNewStatepoint(SelectionDAGBuilder &Builder) {
  // Consistency check
  assert(PendingGCRelocateCalls.empty() &&
         "Trying to visit statepoint before finished processing previous one");
  Locations.clear();
  NextSlotToAllocate = 0;
  // Need to resize this on each safepoint - we need the two to stay in sync and
  // the clear patterns of a SelectionDAGBuilder have no relation to
  // FunctionLoweringInfo.  Also need to ensure used bits get cleared.
  AllocatedStackSlots.clear();
  AllocatedStackSlots.resize(Builder.FuncInfo.StatepointStackSlots.size());
}

void StatepointLoweringState::clear() {
  Locations.clear();
  AllocatedStackSlots.clear();
  assert(PendingGCRelocateCalls.empty() &&
         "cleared before statepoint sequence completed");
}

SDValue
StatepointLoweringState::allocateStackSlot(EVT ValueType,
                                           SelectionDAGBuilder &Builder) {
  NumSlotsAllocatedForStatepoints++;
  MachineFrameInfo &MFI = Builder.DAG.getMachineFunction().getFrameInfo();

  unsigned SpillSize = ValueType.getStoreSize();
  assert((SpillSize * 8) == ValueType.getSizeInBits() && "Size not in bytes?");

  // First look for a previously created stack slot which is not in
  // use (accounting for the fact arbitrary slots may already be
  // reserved), or to create a new stack slot and use it.

  const size_t NumSlots = AllocatedStackSlots.size();
  assert(NextSlotToAllocate <= NumSlots && "Broken invariant");

  assert(AllocatedStackSlots.size() ==
         Builder.FuncInfo.StatepointStackSlots.size() &&
         "Broken invariant");

  for (; NextSlotToAllocate < NumSlots; NextSlotToAllocate++) {
    if (!AllocatedStackSlots.test(NextSlotToAllocate)) {
      const int FI = Builder.FuncInfo.StatepointStackSlots[NextSlotToAllocate];
      if (MFI.getObjectSize(FI) == SpillSize) {
        AllocatedStackSlots.set(NextSlotToAllocate);
        // TODO: Is ValueType the right thing to use here?
        return Builder.DAG.getFrameIndex(FI, ValueType);
      }
    }
  }

  // Couldn't find a free slot, so create a new one:

  SDValue SpillSlot = Builder.DAG.CreateStackTemporary(ValueType);
  const unsigned FI = cast<FrameIndexSDNode>(SpillSlot)->getIndex();
  MFI.markAsStatepointSpillSlotObjectIndex(FI);

  Builder.FuncInfo.StatepointStackSlots.push_back(FI);
  AllocatedStackSlots.resize(AllocatedStackSlots.size()+1, true);
  assert(AllocatedStackSlots.size() ==
         Builder.FuncInfo.StatepointStackSlots.size() &&
         "Broken invariant");

  StatepointMaxSlotsRequired.updateMax(
      Builder.FuncInfo.StatepointStackSlots.size());

  return SpillSlot;
}

/// Utility function for reservePreviousStackSlotForValue. Tries to find
/// stack slot index to which we have spilled value for previous statepoints.
/// LookUpDepth specifies maximum DFS depth this function is allowed to look.
static Optional<int> findPreviousSpillSlot(const Value *Val,
                                           SelectionDAGBuilder &Builder,
                                           int LookUpDepth) {
  // Can not look any further - give up now
  if (LookUpDepth <= 0)
    return None;

  // Spill location is known for gc relocates
  if (const auto *Relocate = dyn_cast<GCRelocateInst>(Val)) {
    const auto &RelocationMap =
        Builder.FuncInfo.StatepointRelocationMaps[Relocate->getStatepoint()];

    auto It = RelocationMap.find(Relocate->getDerivedPtr());
    if (It == RelocationMap.end())
      return None;

    auto &Record = It->second;
    if (Record.type != RecordType::Spill)
      return None;

    return Record.payload.FI;
  }

  // Look through bitcast instructions.
  if (const BitCastInst *Cast = dyn_cast<BitCastInst>(Val))
    return findPreviousSpillSlot(Cast->getOperand(0), Builder, LookUpDepth - 1);

  // Look through phi nodes
  // All incoming values should have same known stack slot, otherwise result
  // is unknown.
  if (const PHINode *Phi = dyn_cast<PHINode>(Val)) {
    Optional<int> MergedResult = None;

    for (auto &IncomingValue : Phi->incoming_values()) {
      Optional<int> SpillSlot =
          findPreviousSpillSlot(IncomingValue, Builder, LookUpDepth - 1);
      if (!SpillSlot.hasValue())
        return None;

      if (MergedResult.hasValue() && *MergedResult != *SpillSlot)
        return None;

      MergedResult = SpillSlot;
    }
    return MergedResult;
  }

  // TODO: We can do better for PHI nodes. In cases like this:
  //   ptr = phi(relocated_pointer, not_relocated_pointer)
  //   statepoint(ptr)
  // We will return that stack slot for ptr is unknown. And later we might
  // assign different stack slots for ptr and relocated_pointer. This limits
  // llvm's ability to remove redundant stores.
  // Unfortunately it's hard to accomplish in current infrastructure.
  // We use this function to eliminate spill store completely, while
  // in example we still need to emit store, but instead of any location
  // we need to use special "preferred" location.

  // TODO: handle simple updates.  If a value is modified and the original
  // value is no longer live, it would be nice to put the modified value in the
  // same slot.  This allows folding of the memory accesses for some
  // instructions types (like an increment).
  //   statepoint (i)
  //   i1 = i+1
  //   statepoint (i1)
  // However we need to be careful for cases like this:
  //   statepoint(i)
  //   i1 = i+1
  //   statepoint(i, i1)
  // Here we want to reserve spill slot for 'i', but not for 'i+1'. If we just
  // put handling of simple modifications in this function like it's done
  // for bitcasts we might end up reserving i's slot for 'i+1' because order in
  // which we visit values is unspecified.

  // Don't know any information about this instruction
  return None;
}

/// Return true if-and-only-if the given SDValue can be lowered as either a
/// constant argument or a stack reference.  The key point is that the value
/// doesn't need to be spilled or tracked as a vreg use.
static bool willLowerDirectly(SDValue Incoming) {
  // We are making an unchecked assumption that the frame size <= 2^16 as that
  // is the largest offset which can be encoded in the stackmap format.
  if (isa<FrameIndexSDNode>(Incoming))
    return true;

  // The largest constant describeable in the StackMap format is 64 bits.
  // Potential Optimization:  Constants values are sign extended by consumer,
  // and thus there are many constants of static type > 64 bits whose value
  // happens to be sext(Con64) and could thus be lowered directly.
  if (Incoming.getValueType().getSizeInBits() > 64)
    return false;

  return (isa<ConstantSDNode>(Incoming) || isa<ConstantFPSDNode>(Incoming) ||
          Incoming.isUndef());
}

/// Try to find existing copies of the incoming values in stack slots used for
/// statepoint spilling.  If we can find a spill slot for the incoming value,
/// mark that slot as allocated, and reuse the same slot for this safepoint.
/// This helps to avoid series of loads and stores that only serve to reshuffle
/// values on the stack between calls.
static void reservePreviousStackSlotForValue(const Value *IncomingValue,
                                             SelectionDAGBuilder &Builder) {
  SDValue Incoming = Builder.getValue(IncomingValue);

  // If we won't spill this, we don't need to check for previously allocated
  // stack slots.
  if (willLowerDirectly(Incoming))
    return;

  SDValue OldLocation = Builder.StatepointLowering.getLocation(Incoming);
  if (OldLocation.getNode())
    // Duplicates in input
    return;

  const int LookUpDepth = 6;
  Optional<int> Index =
      findPreviousSpillSlot(IncomingValue, Builder, LookUpDepth);
  if (!Index.hasValue())
    return;

  const auto &StatepointSlots = Builder.FuncInfo.StatepointStackSlots;

  auto SlotIt = find(StatepointSlots, *Index);
  assert(SlotIt != StatepointSlots.end() &&
         "Value spilled to the unknown stack slot");

  // This is one of our dedicated lowering slots
  const int Offset = std::distance(StatepointSlots.begin(), SlotIt);
  if (Builder.StatepointLowering.isStackSlotAllocated(Offset)) {
    // stack slot already assigned to someone else, can't use it!
    // TODO: currently we reserve space for gc arguments after doing
    // normal allocation for deopt arguments.  We should reserve for
    // _all_ deopt and gc arguments, then start allocating.  This
    // will prevent some moves being inserted when vm state changes,
    // but gc state doesn't between two calls.
    return;
  }
  // Reserve this stack slot
  Builder.StatepointLowering.reserveStackSlot(Offset);

  // Cache this slot so we find it when going through the normal
  // assignment loop.
  SDValue Loc =
      Builder.DAG.getTargetFrameIndex(*Index, Builder.getFrameIndexTy());
  Builder.StatepointLowering.setLocation(Incoming, Loc);
}

/// Extract call from statepoint, lower it and return pointer to the
/// call node. Also update NodeMap so that getValue(statepoint) will
/// reference lowered call result
static std::pair<SDValue, SDNode *> lowerCallFromStatepointLoweringInfo(
    SelectionDAGBuilder::StatepointLoweringInfo &SI,
    SelectionDAGBuilder &Builder, SmallVectorImpl<SDValue> &PendingExports) {
  SDValue ReturnValue, CallEndVal;
  std::tie(ReturnValue, CallEndVal) =
      Builder.lowerInvokable(SI.CLI, SI.EHPadBB);
  SDNode *CallEnd = CallEndVal.getNode();

  // Get a call instruction from the call sequence chain.  Tail calls are not
  // allowed.  The following code is essentially reverse engineering X86's
  // LowerCallTo.
  //
  // We are expecting DAG to have the following form:
  //
  // ch = eh_label (only in case of invoke statepoint)
  //   ch, glue = callseq_start ch
  //   ch, glue = X86::Call ch, glue
  //   ch, glue = callseq_end ch, glue
  //   get_return_value ch, glue
  //
  // get_return_value can either be a sequence of CopyFromReg instructions
  // to grab the return value from the return register(s), or it can be a LOAD
  // to load a value returned by reference via a stack slot.

  bool HasDef = !SI.CLI.RetTy->isVoidTy();
  if (HasDef) {
    if (CallEnd->getOpcode() == ISD::LOAD)
      CallEnd = CallEnd->getOperand(0).getNode();
    else
      while (CallEnd->getOpcode() == ISD::CopyFromReg)
        CallEnd = CallEnd->getOperand(0).getNode();
  }

  assert(CallEnd->getOpcode() == ISD::CALLSEQ_END && "expected!");
  return std::make_pair(ReturnValue, CallEnd->getOperand(0).getNode());
}

static MachineMemOperand* getMachineMemOperand(MachineFunction &MF,
                                               FrameIndexSDNode &FI) {
  auto PtrInfo = MachinePointerInfo::getFixedStack(MF, FI.getIndex());
  auto MMOFlags = MachineMemOperand::MOStore |
    MachineMemOperand::MOLoad | MachineMemOperand::MOVolatile;
  auto &MFI = MF.getFrameInfo();
  return MF.getMachineMemOperand(PtrInfo, MMOFlags,
                                 MFI.getObjectSize(FI.getIndex()),
                                 MFI.getObjectAlign(FI.getIndex()));
}

/// Spill a value incoming to the statepoint. It might be either part of
/// vmstate
/// or gcstate. In both cases unconditionally spill it on the stack unless it
/// is a null constant. Return pair with first element being frame index
/// containing saved value and second element with outgoing chain from the
/// emitted store
static std::tuple<SDValue, SDValue, MachineMemOperand*>
spillIncomingStatepointValue(SDValue Incoming, SDValue Chain,
                             SelectionDAGBuilder &Builder) {
  SDValue Loc = Builder.StatepointLowering.getLocation(Incoming);
  MachineMemOperand* MMO = nullptr;

  // Emit new store if we didn't do it for this ptr before
  if (!Loc.getNode()) {
    Loc = Builder.StatepointLowering.allocateStackSlot(Incoming.getValueType(),
                                                       Builder);
    int Index = cast<FrameIndexSDNode>(Loc)->getIndex();
    // We use TargetFrameIndex so that isel will not select it into LEA
    Loc = Builder.DAG.getTargetFrameIndex(Index, Builder.getFrameIndexTy());

    // Right now we always allocate spill slots that are of the same
    // size as the value we're about to spill (the size of spillee can
    // vary since we spill vectors of pointers too).  At some point we
    // can consider allowing spills of smaller values to larger slots
    // (i.e. change the '==' in the assert below to a '>=').
    MachineFrameInfo &MFI = Builder.DAG.getMachineFunction().getFrameInfo();
    assert((MFI.getObjectSize(Index) * 8) ==
           (int64_t)Incoming.getValueSizeInBits() &&
           "Bad spill:  stack slot does not match!");

    // Note: Using the alignment of the spill slot (rather than the abi or
    // preferred alignment) is required for correctness when dealing with spill
    // slots with preferred alignments larger than frame alignment..
    auto &MF = Builder.DAG.getMachineFunction();
    auto PtrInfo = MachinePointerInfo::getFixedStack(MF, Index);
    auto *StoreMMO = MF.getMachineMemOperand(
        PtrInfo, MachineMemOperand::MOStore, MFI.getObjectSize(Index),
        MFI.getObjectAlign(Index));
    Chain = Builder.DAG.getStore(Chain, Builder.getCurSDLoc(), Incoming, Loc,
                                 StoreMMO);

    MMO = getMachineMemOperand(MF, *cast<FrameIndexSDNode>(Loc));

    Builder.StatepointLowering.setLocation(Incoming, Loc);
  }

  assert(Loc.getNode());
  return std::make_tuple(Loc, Chain, MMO);
}

/// Lower a single value incoming to a statepoint node.  This value can be
/// either a deopt value or a gc value, the handling is the same.  We special
/// case constants and allocas, then fall back to spilling if required.
static void
lowerIncomingStatepointValue(SDValue Incoming, bool RequireSpillSlot,
                             SmallVectorImpl<SDValue> &Ops,
                             SmallVectorImpl<MachineMemOperand *> &MemRefs,
                             SelectionDAGBuilder &Builder) {
  
  if (willLowerDirectly(Incoming)) {
    if (FrameIndexSDNode *FI = dyn_cast<FrameIndexSDNode>(Incoming)) {
      // This handles allocas as arguments to the statepoint (this is only
      // really meaningful for a deopt value.  For GC, we'd be trying to
      // relocate the address of the alloca itself?)
      assert(Incoming.getValueType() == Builder.getFrameIndexTy() &&
             "Incoming value is a frame index!");
      Ops.push_back(Builder.DAG.getTargetFrameIndex(FI->getIndex(),
                                                    Builder.getFrameIndexTy()));

      auto &MF = Builder.DAG.getMachineFunction();
      auto *MMO = getMachineMemOperand(MF, *FI);
      MemRefs.push_back(MMO);
      return;
    }

    assert(Incoming.getValueType().getSizeInBits() <= 64);
    
    if (Incoming.isUndef()) {
      // Put an easily recognized constant that's unlikely to be a valid
      // value so that uses of undef by the consumer of the stackmap is
      // easily recognized. This is legal since the compiler is always
      // allowed to chose an arbitrary value for undef.
      pushStackMapConstant(Ops, Builder, 0xFEFEFEFE);
      return;
    }

    // If the original value was a constant, make sure it gets recorded as
    // such in the stackmap.  This is required so that the consumer can
    // parse any internal format to the deopt state.  It also handles null
    // pointers and other constant pointers in GC states.
    if (ConstantSDNode *C = dyn_cast<ConstantSDNode>(Incoming)) {
      pushStackMapConstant(Ops, Builder, C->getSExtValue());
      return;
    } else if (ConstantFPSDNode *C = dyn_cast<ConstantFPSDNode>(Incoming)) {
      pushStackMapConstant(Ops, Builder,
                           C->getValueAPF().bitcastToAPInt().getZExtValue());
      return;
    }

    llvm_unreachable("unhandled direct lowering case");
  }



  if (!RequireSpillSlot) {
    // If this value is live in (not live-on-return, or live-through), we can
    // treat it the same way patchpoint treats it's "live in" values.  We'll
    // end up folding some of these into stack references, but they'll be
    // handled by the register allocator.  Note that we do not have the notion
    // of a late use so these values might be placed in registers which are
    // clobbered by the call.  This is fine for live-in. For live-through
    // fix-up pass should be executed to force spilling of such registers.
    Ops.push_back(Incoming);
  } else {
    // Otherwise, locate a spill slot and explicitly spill it so it can be
    // found by the runtime later.  Note: We know all of these spills are
    // independent, but don't bother to exploit that chain wise.  DAGCombine
    // will happily do so as needed, so doing it here would be a small compile
    // time win at most. 
    SDValue Chain = Builder.getRoot();
    auto Res = spillIncomingStatepointValue(Incoming, Chain, Builder);
    Ops.push_back(std::get<0>(Res));
    if (auto *MMO = std::get<2>(Res))
      MemRefs.push_back(MMO);
    Chain = std::get<1>(Res);;
    Builder.DAG.setRoot(Chain);
  }

}

/// Lower deopt state and gc pointer arguments of the statepoint.  The actual
/// lowering is described in lowerIncomingStatepointValue.  This function is
/// responsible for lowering everything in the right position and playing some
/// tricks to avoid redundant stack manipulation where possible.  On
/// completion, 'Ops' will contain ready to use operands for machine code
/// statepoint. The chain nodes will have already been created and the DAG root
/// will be set to the last value spilled (if any were).
static void
lowerStatepointMetaArgs(SmallVectorImpl<SDValue> &Ops,
                        SmallVectorImpl<MachineMemOperand *> &MemRefs,
                        DenseMap<SDValue, int> &LowerAsVReg,
                        SelectionDAGBuilder::StatepointLoweringInfo &SI,
                        SelectionDAGBuilder &Builder) {
  // Lower the deopt and gc arguments for this statepoint.  Layout will be:
  // deopt argument length, deopt arguments.., gc arguments...
#ifndef NDEBUG
  if (auto *GFI = Builder.GFI) {
    // Check that each of the gc pointer and bases we've gotten out of the
    // safepoint is something the strategy thinks might be a pointer (or vector
    // of pointers) into the GC heap.  This is basically just here to help catch
    // errors during statepoint insertion. TODO: This should actually be in the
    // Verifier, but we can't get to the GCStrategy from there (yet).
    GCStrategy &S = GFI->getStrategy();
    for (const Value *V : SI.Bases) {
      auto Opt = S.isGCManagedPointer(V->getType()->getScalarType());
      if (Opt.hasValue()) {
        assert(Opt.getValue() &&
               "non gc managed base pointer found in statepoint");
      }
    }
    for (const Value *V : SI.Ptrs) {
      auto Opt = S.isGCManagedPointer(V->getType()->getScalarType());
      if (Opt.hasValue()) {
        assert(Opt.getValue() &&
               "non gc managed derived pointer found in statepoint");
      }
    }
    assert(SI.Bases.size() == SI.Ptrs.size() && "Pointer without base!");
  } else {
    assert(SI.Bases.empty() && "No gc specified, so cannot relocate pointers!");
    assert(SI.Ptrs.empty() && "No gc specified, so cannot relocate pointers!");
  }
#endif

  // Figure out what lowering strategy we're going to use for each part
  // Note: Is is conservatively correct to lower both "live-in" and "live-out"
  // as "live-through". A "live-through" variable is one which is "live-in",
  // "live-out", and live throughout the lifetime of the call (i.e. we can find
  // it from any PC within the transitive callee of the statepoint).  In
  // particular, if the callee spills callee preserved registers we may not
  // be able to find a value placed in that register during the call.  This is
  // fine for live-out, but not for live-through.  If we were willing to make
  // assumptions about the code generator producing the callee, we could
  // potentially allow live-through values in callee saved registers.
  const bool LiveInDeopt =
    SI.StatepointFlags & (uint64_t)StatepointFlags::DeoptLiveIn;

  // Decide which deriver pointers will go on VRegs
  const unsigned MaxTiedRegs = 15; // Max  number of tied regs MI can have.
  unsigned MaxVRegPtrs =
      std::min(MaxTiedRegs, MaxRegistersForGCPointers.getValue());

  LLVM_DEBUG(dbgs() << "Desiding how to lower GC Pointers:\n");
  unsigned CurNumVRegs = 0;
  for (const Value *P : SI.Ptrs) {
    if (LowerAsVReg.size() == MaxVRegPtrs)
      break;
    SDValue PtrSD = Builder.getValue(P);
    if (willLowerDirectly(PtrSD) || P->getType()->isVectorTy()) {
      LLVM_DEBUG(dbgs() << "direct/spill "; PtrSD.dump(&Builder.DAG));
      continue;
    }
    LLVM_DEBUG(dbgs() << "vreg "; PtrSD.dump(&Builder.DAG));
    LowerAsVReg[PtrSD] = CurNumVRegs++;
  }
  LLVM_DEBUG(dbgs() << LowerAsVReg.size()
                    << " derived pointers will go in vregs\n");

  auto isGCValue = [&](const Value *V) {
    auto *Ty = V->getType();
    if (!Ty->isPtrOrPtrVectorTy())
      return false;
    if (auto *GFI = Builder.GFI)
      if (auto IsManaged = GFI->getStrategy().isGCManagedPointer(Ty))
        return *IsManaged;
    return true; // conservative
  };

  auto requireSpillSlot = [&](const Value *V) {
    if (isGCValue(V))
      return !LowerAsVReg.count(Builder.getValue(V));
    return !(LiveInDeopt || UseRegistersForDeoptValues);
  };

  // Before we actually start lowering (and allocating spill slots for values),
  // reserve any stack slots which we judge to be profitable to reuse for a
  // particular value.  This is purely an optimization over the code below and
  // doesn't change semantics at all.  It is important for performance that we
  // reserve slots for both deopt and gc values before lowering either.
  for (const Value *V : SI.DeoptState) {
    if (requireSpillSlot(V))
      reservePreviousStackSlotForValue(V, Builder);
  }

  for (unsigned i = 0; i < SI.Bases.size(); ++i) {
    SDValue SDV = Builder.getValue(SI.Bases[i]);
    if (!LowerAsVReg.count(SDV))
      reservePreviousStackSlotForValue(SI.Bases[i], Builder);
    SDV = Builder.getValue(SI.Ptrs[i]);
    if (!LowerAsVReg.count(SDV))
      reservePreviousStackSlotForValue(SI.Ptrs[i], Builder);
  }

  // First, prefix the list with the number of unique values to be
  // lowered.  Note that this is the number of *Values* not the
  // number of SDValues required to lower them.
  const int NumVMSArgs = SI.DeoptState.size();
  pushStackMapConstant(Ops, Builder, NumVMSArgs);

  // The vm state arguments are lowered in an opaque manner.  We do not know
  // what type of values are contained within.
  LLVM_DEBUG(dbgs() << "Lowering deopt state\n");
  for (const Value *V : SI.DeoptState) {
    SDValue Incoming;
    // If this is a function argument at a static frame index, generate it as
    // the frame index.
    if (const Argument *Arg = dyn_cast<Argument>(V)) {
      int FI = Builder.FuncInfo.getArgumentFrameIndex(Arg);
      if (FI != INT_MAX)
        Incoming = Builder.DAG.getFrameIndex(FI, Builder.getFrameIndexTy());
    }
    if (!Incoming.getNode())
      Incoming = Builder.getValue(V);
    LLVM_DEBUG(dbgs() << "Value " << *V
                      << " requireSpillSlot = " << requireSpillSlot(V) << "\n");
    lowerIncomingStatepointValue(Incoming, requireSpillSlot(V), Ops, MemRefs,
                                 Builder);
  }

  // Finally, go ahead and lower all the gc arguments.  There's no prefixed
  // length for this one.  After lowering, we'll have the base and pointer
  // arrays interwoven with each (lowered) base pointer immediately followed by
  // it's (lowered) derived pointer.  i.e
  // (base[0], ptr[0], base[1], ptr[1], ...)
  for (unsigned i = 0; i < SI.Bases.size(); ++i) {
    bool RequireSpillSlot;
    SDValue Base = Builder.getValue(SI.Bases[i]);
    RequireSpillSlot = !LowerAsVReg.count(Base);
    lowerIncomingStatepointValue(Base, RequireSpillSlot, Ops, MemRefs,
                                 Builder);

    SDValue Derived = Builder.getValue(SI.Ptrs[i]);
    RequireSpillSlot = !LowerAsVReg.count(Derived);
    lowerIncomingStatepointValue(Derived, RequireSpillSlot, Ops, MemRefs,
                                 Builder);
  }

  // If there are any explicit spill slots passed to the statepoint, record
  // them, but otherwise do not do anything special.  These are user provided
  // allocas and give control over placement to the consumer.  In this case,
  // it is the contents of the slot which may get updated, not the pointer to
  // the alloca
  for (Value *V : SI.GCArgs) {
    SDValue Incoming = Builder.getValue(V);
    if (FrameIndexSDNode *FI = dyn_cast<FrameIndexSDNode>(Incoming)) {
      // This handles allocas as arguments to the statepoint
      assert(Incoming.getValueType() == Builder.getFrameIndexTy() &&
             "Incoming value is a frame index!");
      Ops.push_back(Builder.DAG.getTargetFrameIndex(FI->getIndex(),
                                                    Builder.getFrameIndexTy()));

      auto &MF = Builder.DAG.getMachineFunction();
      auto *MMO = getMachineMemOperand(MF, *FI);
      MemRefs.push_back(MMO);
    }
  }
}

SDValue SelectionDAGBuilder::LowerAsSTATEPOINT(
    SelectionDAGBuilder::StatepointLoweringInfo &SI) {
  // The basic scheme here is that information about both the original call and
  // the safepoint is encoded in the CallInst.  We create a temporary call and
  // lower it, then reverse engineer the calling sequence.

  NumOfStatepoints++;
  // Clear state
  StatepointLowering.startNewStatepoint(*this);
  assert(SI.Bases.size() == SI.Ptrs.size() &&
         SI.Ptrs.size() <= SI.GCRelocates.size());

  LLVM_DEBUG(dbgs() << "Lowering statepoint " << *SI.StatepointInstr << "\n");
#ifndef NDEBUG
  for (auto *Reloc : SI.GCRelocates)
    if (Reloc->getParent() == SI.StatepointInstr->getParent())
      StatepointLowering.scheduleRelocCall(*Reloc);
#endif

  // Lower statepoint vmstate and gcstate arguments
  SmallVector<SDValue, 10> LoweredMetaArgs;
  SmallVector<MachineMemOperand*, 16> MemRefs;
  // Maps derived pointer SDValue to statepoint result of relocated pointer.
  DenseMap<SDValue, int> LowerAsVReg;
  lowerStatepointMetaArgs(LoweredMetaArgs, MemRefs, LowerAsVReg, SI, *this);

  // Now that we've emitted the spills, we need to update the root so that the
  // call sequence is ordered correctly.
  SI.CLI.setChain(getRoot());

  // Get call node, we will replace it later with statepoint
  SDValue ReturnVal;
  SDNode *CallNode;
  std::tie(ReturnVal, CallNode) =
      lowerCallFromStatepointLoweringInfo(SI, *this, PendingExports);

  // Construct the actual GC_TRANSITION_START, STATEPOINT, and GC_TRANSITION_END
  // nodes with all the appropriate arguments and return values.

  // Call Node: Chain, Target, {Args}, RegMask, [Glue]
  SDValue Chain = CallNode->getOperand(0);

  SDValue Glue;
  bool CallHasIncomingGlue = CallNode->getGluedNode();
  if (CallHasIncomingGlue) {
    // Glue is always last operand
    Glue = CallNode->getOperand(CallNode->getNumOperands() - 1);
  }

  // Build the GC_TRANSITION_START node if necessary.
  //
  // The operands to the GC_TRANSITION_{START,END} nodes are laid out in the
  // order in which they appear in the call to the statepoint intrinsic. If
  // any of the operands is a pointer-typed, that operand is immediately
  // followed by a SRCVALUE for the pointer that may be used during lowering
  // (e.g. to form MachinePointerInfo values for loads/stores).
  const bool IsGCTransition =
      (SI.StatepointFlags & (uint64_t)StatepointFlags::GCTransition) ==
      (uint64_t)StatepointFlags::GCTransition;
  if (IsGCTransition) {
    SmallVector<SDValue, 8> TSOps;

    // Add chain
    TSOps.push_back(Chain);

    // Add GC transition arguments
    for (const Value *V : SI.GCTransitionArgs) {
      TSOps.push_back(getValue(V));
      if (V->getType()->isPointerTy())
        TSOps.push_back(DAG.getSrcValue(V));
    }

    // Add glue if necessary
    if (CallHasIncomingGlue)
      TSOps.push_back(Glue);

    SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);

    SDValue GCTransitionStart =
        DAG.getNode(ISD::GC_TRANSITION_START, getCurSDLoc(), NodeTys, TSOps);

    Chain = GCTransitionStart.getValue(0);
    Glue = GCTransitionStart.getValue(1);
  }

  // TODO: Currently, all of these operands are being marked as read/write in
  // PrologEpilougeInserter.cpp, we should special case the VMState arguments
  // and flags to be read-only.
  SmallVector<SDValue, 40> Ops;

  // Add the <id> and <numBytes> constants.
  Ops.push_back(DAG.getTargetConstant(SI.ID, getCurSDLoc(), MVT::i64));
  Ops.push_back(
      DAG.getTargetConstant(SI.NumPatchBytes, getCurSDLoc(), MVT::i32));

  // Calculate and push starting position of vmstate arguments
  // Get number of arguments incoming directly into call node
  unsigned NumCallRegArgs =
      CallNode->getNumOperands() - (CallHasIncomingGlue ? 4 : 3);
  Ops.push_back(DAG.getTargetConstant(NumCallRegArgs, getCurSDLoc(), MVT::i32));

  // Add call target
  SDValue CallTarget = SDValue(CallNode->getOperand(1).getNode(), 0);
  Ops.push_back(CallTarget);

  // Add call arguments
  // Get position of register mask in the call
  SDNode::op_iterator RegMaskIt;
  if (CallHasIncomingGlue)
    RegMaskIt = CallNode->op_end() - 2;
  else
    RegMaskIt = CallNode->op_end() - 1;
  Ops.insert(Ops.end(), CallNode->op_begin() + 2, RegMaskIt);

  // Add a constant argument for the calling convention
  pushStackMapConstant(Ops, *this, SI.CLI.CallConv);

  // Add a constant argument for the flags
  uint64_t Flags = SI.StatepointFlags;
  assert(((Flags & ~(uint64_t)StatepointFlags::MaskAll) == 0) &&
         "Unknown flag used");
  pushStackMapConstant(Ops, *this, Flags);

  // Insert all vmstate and gcstate arguments
  Ops.insert(Ops.end(), LoweredMetaArgs.begin(), LoweredMetaArgs.end());

  // Add register mask from call node
  Ops.push_back(*RegMaskIt);

  // Add chain
  Ops.push_back(Chain);

  // Same for the glue, but we add it only if original call had it
  if (Glue.getNode())
    Ops.push_back(Glue);

  // Compute return values.  Provide a glue output since we consume one as
  // input.  This allows someone else to chain off us as needed.
  SmallVector<EVT, 8> NodeTys;
  for (auto &Ptr : SI.Ptrs) {
    SDValue SD = getValue(Ptr);
    if (!LowerAsVReg.count(SD))
      continue;
    NodeTys.push_back(SD.getValueType());
  }
  LLVM_DEBUG(dbgs() << "Statepoint has " << NodeTys.size() << " results\n");
  assert(NodeTys.size() == LowerAsVReg.size() && "Inconsistent GC Ptr lowering");
  NodeTys.push_back(MVT::Other);
  NodeTys.push_back(MVT::Glue);

  unsigned NumResults = NodeTys.size();
  MachineSDNode *StatepointMCNode =
    DAG.getMachineNode(TargetOpcode::STATEPOINT, getCurSDLoc(), NodeTys, Ops);
  DAG.setNodeMemRefs(StatepointMCNode, MemRefs);


  // For values lowered to tied-defs, create the virtual registers.  Note that
  // for simplicity, we *always* create a vreg even within a single block. 
  DenseMap<const Value *, Register> VirtRegs;
  for (const auto *Relocate : SI.GCRelocates) {
    Value *Derived = Relocate->getDerivedPtr();
    SDValue SD = getValue(Derived);
    if (!LowerAsVReg.count(SD))
      continue;

    // Handle multiple gc.relocates of the same input efficiently.
    if (VirtRegs.count(Derived))
      continue;

    SDValue Relocated = SDValue(StatepointMCNode, LowerAsVReg[SD]);

    auto *RetTy = Relocate->getType();
    Register Reg = FuncInfo.CreateRegs(RetTy);
    RegsForValue RFV(*DAG.getContext(), DAG.getTargetLoweringInfo(),
                     DAG.getDataLayout(), Reg, RetTy, None);
    SDValue Chain = DAG.getEntryNode();
    RFV.getCopyToRegs(Relocated, DAG, getCurSDLoc(), Chain, nullptr);
    PendingExports.push_back(Chain);
    
    VirtRegs[Derived] = Reg; 
  }

  // Record for later use how each relocation was lowered.  This is needed to
  // allow later gc.relocates to mirror the lowering chosen.
  const Instruction *StatepointInstr = SI.StatepointInstr;
  auto &RelocationMap = FuncInfo.StatepointRelocationMaps[StatepointInstr];
  for (const GCRelocateInst *Relocate : SI.GCRelocates) {
    const Value *V = Relocate->getDerivedPtr();
    SDValue SDV = getValue(V);
    SDValue Loc = StatepointLowering.getLocation(SDV);

    RecordType Record;
    if (Loc.getNode()) {
      Record.type = RecordType::Spill;
      Record.payload.FI = cast<FrameIndexSDNode>(Loc)->getIndex();
    } else if (LowerAsVReg.count(SDV)) {
      Record.type = RecordType::VReg;
      assert(VirtRegs.count(V));
      Record.payload.Reg = VirtRegs[V];
    } else {
      Record.type = RecordType::NoRelocate;
      // If we didn't relocate a value, we'll essentialy end up inserting an
      // additional use of the original value when lowering the gc.relocate.
      // We need to make sure the value is available at the new use, which
      // might be in another block.
      if (Relocate->getParent() != StatepointInstr->getParent())
        ExportFromCurrentBlock(V);
    }
    RelocationMap[V] = Record;
  }

  

  SDNode *SinkNode = StatepointMCNode;

  // Build the GC_TRANSITION_END node if necessary.
  //
  // See the comment above regarding GC_TRANSITION_START for the layout of
  // the operands to the GC_TRANSITION_END node.
  if (IsGCTransition) {
    SmallVector<SDValue, 8> TEOps;

    // Add chain
    TEOps.push_back(SDValue(StatepointMCNode, NumResults - 2));

    // Add GC transition arguments
    for (const Value *V : SI.GCTransitionArgs) {
      TEOps.push_back(getValue(V));
      if (V->getType()->isPointerTy())
        TEOps.push_back(DAG.getSrcValue(V));
    }

    // Add glue
    TEOps.push_back(SDValue(StatepointMCNode, NumResults - 1));

    SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);

    SDValue GCTransitionStart =
        DAG.getNode(ISD::GC_TRANSITION_END, getCurSDLoc(), NodeTys, TEOps);

    SinkNode = GCTransitionStart.getNode();
  }

  // Replace original call
  // Call: ch,glue = CALL ...
  // Statepoint: [gc relocates],ch,glue = STATEPOINT ...
  unsigned NumSinkValues = SinkNode->getNumValues();
  SDValue StatepointValues[2] = {SDValue(SinkNode, NumSinkValues - 2),
                                 SDValue(SinkNode, NumSinkValues - 1)};
  DAG.ReplaceAllUsesWith(CallNode, StatepointValues);
  // Remove original call node
  DAG.DeleteNode(CallNode);

  // DON'T set the root - under the assumption that it's already set past the
  // inserted node we created.

  // TODO: A better future implementation would be to emit a single variable
  // argument, variable return value STATEPOINT node here and then hookup the
  // return value of each gc.relocate to the respective output of the
  // previously emitted STATEPOINT value.  Unfortunately, this doesn't appear
  // to actually be possible today.

  return ReturnVal;
}

void
SelectionDAGBuilder::LowerStatepoint(const GCStatepointInst &I,
                                     const BasicBlock *EHPadBB /*= nullptr*/) {
  assert(I.getCallingConv() != CallingConv::AnyReg &&
         "anyregcc is not supported on statepoints!");

#ifndef NDEBUG
  // Check that the associated GCStrategy expects to encounter statepoints.
  assert(GFI->getStrategy().useStatepoints() &&
         "GCStrategy does not expect to encounter statepoints");
#endif

  SDValue ActualCallee;
  SDValue Callee = getValue(I.getActualCalledOperand());

  if (I.getNumPatchBytes() > 0) {
    // If we've been asked to emit a nop sequence instead of a call instruction
    // for this statepoint then don't lower the call target, but use a constant
    // `undef` instead.  Not lowering the call target lets statepoint clients
    // get away without providing a physical address for the symbolic call
    // target at link time.
    ActualCallee = DAG.getUNDEF(Callee.getValueType());
  } else {
    ActualCallee = Callee;
  }

  StatepointLoweringInfo SI(DAG);
  populateCallLoweringInfo(SI.CLI, &I, GCStatepointInst::CallArgsBeginPos,
                           I.getNumCallArgs(), ActualCallee,
                           I.getActualReturnType(), false /* IsPatchPoint */);

  // There may be duplication in the gc.relocate list; such as two copies of
  // each relocation on normal and exceptional path for an invoke.  We only
  // need to spill once and record one copy in the stackmap, but we need to
  // reload once per gc.relocate.  (Dedupping gc.relocates is trickier and best
  // handled as a CSE problem elsewhere.)
  // TODO: There a couple of major stackmap size optimizations we could do
  // here if we wished.
  // 1) If we've encountered a derived pair {B, D}, we don't need to actually
  // record {B,B} if it's seen later.
  // 2) Due to rematerialization, actual derived pointers are somewhat rare;
  // given that, we could change the format to record base pointer relocations
  // separately with half the space. This would require a format rev and a
  // fairly major rework of the STATEPOINT node though.
  SmallSet<SDValue, 8> Seen;
  for (const GCRelocateInst *Relocate : I.getGCRelocates()) {
    SI.GCRelocates.push_back(Relocate);

    SDValue DerivedSD = getValue(Relocate->getDerivedPtr());
    if (Seen.insert(DerivedSD).second) {
      SI.Bases.push_back(Relocate->getBasePtr());
      SI.Ptrs.push_back(Relocate->getDerivedPtr());
    }
  }

  SI.GCArgs = ArrayRef<const Use>(I.gc_args_begin(), I.gc_args_end());
  SI.StatepointInstr = &I;
  SI.ID = I.getID();

  SI.DeoptState = ArrayRef<const Use>(I.deopt_begin(), I.deopt_end());
  SI.GCTransitionArgs = ArrayRef<const Use>(I.gc_transition_args_begin(),
                                            I.gc_transition_args_end());

  SI.StatepointFlags = I.getFlags();
  SI.NumPatchBytes = I.getNumPatchBytes();
  SI.EHPadBB = EHPadBB;

  SDValue ReturnValue = LowerAsSTATEPOINT(SI);

  // Export the result value if needed
  const GCResultInst *GCResult = I.getGCResult();
  Type *RetTy = I.getActualReturnType();

  if (RetTy->isVoidTy() || !GCResult) {
    // The return value is not needed, just generate a poison value. 
    setValue(&I, DAG.getIntPtrConstant(-1, getCurSDLoc()));
    return;
  }

  if (GCResult->getParent() == I.getParent()) {
    // Result value will be used in a same basic block. Don't export it or
    // perform any explicit register copies. The gc_result will simply grab
    // this value. 
    setValue(&I, ReturnValue);
    return;
  }

  // Result value will be used in a different basic block so we need to export
  // it now.  Default exporting mechanism will not work here because statepoint
  // call has a different type than the actual call. It means that by default
  // llvm will create export register of the wrong type (always i32 in our
  // case). So instead we need to create export register with correct type
  // manually.
  // TODO: To eliminate this problem we can remove gc.result intrinsics
  //       completely and make statepoint call to return a tuple.
  unsigned Reg = FuncInfo.CreateRegs(RetTy);
  RegsForValue RFV(*DAG.getContext(), DAG.getTargetLoweringInfo(),
                   DAG.getDataLayout(), Reg, RetTy,
                   I.getCallingConv());
  SDValue Chain = DAG.getEntryNode();
  
  RFV.getCopyToRegs(ReturnValue, DAG, getCurSDLoc(), Chain, nullptr);
  PendingExports.push_back(Chain);
  FuncInfo.ValueMap[&I] = Reg;
}

void SelectionDAGBuilder::LowerCallSiteWithDeoptBundleImpl(
    const CallBase *Call, SDValue Callee, const BasicBlock *EHPadBB,
    bool VarArgDisallowed, bool ForceVoidReturnTy) {
  StatepointLoweringInfo SI(DAG);
  unsigned ArgBeginIndex = Call->arg_begin() - Call->op_begin();
  populateCallLoweringInfo(
      SI.CLI, Call, ArgBeginIndex, Call->getNumArgOperands(), Callee,
      ForceVoidReturnTy ? Type::getVoidTy(*DAG.getContext()) : Call->getType(),
      false);
  if (!VarArgDisallowed)
    SI.CLI.IsVarArg = Call->getFunctionType()->isVarArg();

  auto DeoptBundle = *Call->getOperandBundle(LLVMContext::OB_deopt);

  unsigned DefaultID = StatepointDirectives::DeoptBundleStatepointID;

  auto SD = parseStatepointDirectivesFromAttrs(Call->getAttributes());
  SI.ID = SD.StatepointID.getValueOr(DefaultID);
  SI.NumPatchBytes = SD.NumPatchBytes.getValueOr(0);

  SI.DeoptState =
      ArrayRef<const Use>(DeoptBundle.Inputs.begin(), DeoptBundle.Inputs.end());
  SI.StatepointFlags = static_cast<uint64_t>(StatepointFlags::None);
  SI.EHPadBB = EHPadBB;

  // NB! The GC arguments are deliberately left empty.

  if (SDValue ReturnVal = LowerAsSTATEPOINT(SI)) {
    ReturnVal = lowerRangeToAssertZExt(DAG, *Call, ReturnVal);
    setValue(Call, ReturnVal);
  }
}

void SelectionDAGBuilder::LowerCallSiteWithDeoptBundle(
    const CallBase *Call, SDValue Callee, const BasicBlock *EHPadBB) {
  LowerCallSiteWithDeoptBundleImpl(Call, Callee, EHPadBB,
                                   /* VarArgDisallowed = */ false,
                                   /* ForceVoidReturnTy  = */ false);
}

void SelectionDAGBuilder::visitGCResult(const GCResultInst &CI) {
  // The result value of the gc_result is simply the result of the actual
  // call.  We've already emitted this, so just grab the value.
  const GCStatepointInst *SI = CI.getStatepoint();

  if (SI->getParent() == CI.getParent()) {
    setValue(&CI, getValue(SI));
    return;
  }
  // Statepoint is in different basic block so we should have stored call
  // result in a virtual register.
  // We can not use default getValue() functionality to copy value from this
  // register because statepoint and actual call return types can be
  // different, and getValue() will use CopyFromReg of the wrong type,
  // which is always i32 in our case.
  Type *RetTy = SI->getActualReturnType();
  SDValue CopyFromReg = getCopyFromRegs(SI, RetTy);
  
  assert(CopyFromReg.getNode());
  setValue(&CI, CopyFromReg);
}

void SelectionDAGBuilder::visitGCRelocate(const GCRelocateInst &Relocate) {
#ifndef NDEBUG
  // Consistency check
  // We skip this check for relocates not in the same basic block as their
  // statepoint. It would be too expensive to preserve validation info through
  // different basic blocks.
  if (Relocate.getStatepoint()->getParent() == Relocate.getParent())
    StatepointLowering.relocCallVisited(Relocate);

  auto *Ty = Relocate.getType()->getScalarType();
  if (auto IsManaged = GFI->getStrategy().isGCManagedPointer(Ty))
    assert(*IsManaged && "Non gc managed pointer relocated!");
#endif

  const Value *DerivedPtr = Relocate.getDerivedPtr();
  auto &RelocationMap =
    FuncInfo.StatepointRelocationMaps[Relocate.getStatepoint()];
  auto SlotIt = RelocationMap.find(DerivedPtr);
  assert(SlotIt != RelocationMap.end() && "Relocating not lowered gc value");
  const RecordType &Record = SlotIt->second;

  // If relocation was done via virtual register..
  if (Record.type == RecordType::VReg) {
    Register InReg = Record.payload.Reg;
    RegsForValue RFV(*DAG.getContext(), DAG.getTargetLoweringInfo(),
                     DAG.getDataLayout(), InReg, Relocate.getType(),
                     None); // This is not an ABI copy.
    SDValue Chain = DAG.getEntryNode();
    SDValue Relocation = RFV.getCopyFromRegs(DAG, FuncInfo, getCurSDLoc(),
                                             Chain, nullptr, nullptr);
    setValue(&Relocate, Relocation);
    return;
  }
  
  SDValue SD = getValue(DerivedPtr);

  if (SD.isUndef() && SD.getValueType().getSizeInBits() <= 64) {
    // Lowering relocate(undef) as arbitrary constant. Current constant value
    // is chosen such that it's unlikely to be a valid pointer.
    setValue(&Relocate, DAG.getTargetConstant(0xFEFEFEFE, SDLoc(SD), MVT::i64));
    return;
  }


  // We didn't need to spill these special cases (constants and allocas).
  // See the handling in spillIncomingValueForStatepoint for detail.
  if (Record.type == RecordType::NoRelocate) {
    setValue(&Relocate, SD);
    return;
  }

  assert(Record.type == RecordType::Spill);

  unsigned Index = Record.payload.FI;;
  SDValue SpillSlot = DAG.getTargetFrameIndex(Index, getFrameIndexTy());

  // All the reloads are independent and are reading memory only modified by
  // statepoints (i.e. no other aliasing stores); informing SelectionDAG of
  // this this let's CSE kick in for free and allows reordering of instructions
  // if possible.  The lowering for statepoint sets the root, so this is
  // ordering all reloads with the either a) the statepoint node itself, or b)
  // the entry of the current block for an invoke statepoint.
  const SDValue Chain = DAG.getRoot(); // != Builder.getRoot()

  auto &MF = DAG.getMachineFunction();
  auto &MFI = MF.getFrameInfo();
  auto PtrInfo = MachinePointerInfo::getFixedStack(MF, Index);
  auto *LoadMMO = MF.getMachineMemOperand(PtrInfo, MachineMemOperand::MOLoad,
                                          MFI.getObjectSize(Index),
                                          MFI.getObjectAlign(Index));

  auto LoadVT = DAG.getTargetLoweringInfo().getValueType(DAG.getDataLayout(),
                                                         Relocate.getType());

  SDValue SpillLoad = DAG.getLoad(LoadVT, getCurSDLoc(), Chain,
                                  SpillSlot, LoadMMO);
  PendingLoads.push_back(SpillLoad.getValue(1));

  assert(SpillLoad.getNode());
  setValue(&Relocate, SpillLoad);
}

void SelectionDAGBuilder::LowerDeoptimizeCall(const CallInst *CI) {
  const auto &TLI = DAG.getTargetLoweringInfo();
  SDValue Callee = DAG.getExternalSymbol(TLI.getLibcallName(RTLIB::DEOPTIMIZE),
                                         TLI.getPointerTy(DAG.getDataLayout()));

  // We don't lower calls to __llvm_deoptimize as varargs, but as a regular
  // call.  We also do not lower the return value to any virtual register, and
  // change the immediately following return to a trap instruction.
  LowerCallSiteWithDeoptBundleImpl(CI, Callee, /* EHPadBB = */ nullptr,
                                   /* VarArgDisallowed = */ true,
                                   /* ForceVoidReturnTy = */ true);
}

void SelectionDAGBuilder::LowerDeoptimizingReturn() {
  // We do not lower the return value from llvm.deoptimize to any virtual
  // register, and change the immediately following return to a trap
  // instruction.
  if (DAG.getTarget().Options.TrapUnreachable)
    DAG.setRoot(
        DAG.getNode(ISD::TRAP, getCurSDLoc(), MVT::Other, DAG.getRoot()));
}
