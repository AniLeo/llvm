//===-- VEISelDAGToDAG.cpp - A dag to dag inst selector for VE ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the VE target.
//
//===----------------------------------------------------------------------===//

#include "VETargetMachine.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

//===----------------------------------------------------------------------===//
// Instruction Selector Implementation
//===----------------------------------------------------------------------===//

//===--------------------------------------------------------------------===//
/// VEDAGToDAGISel - VE specific code to select VE machine
/// instructions for SelectionDAG operations.
///
namespace {
class VEDAGToDAGISel : public SelectionDAGISel {
  /// Subtarget - Keep a pointer to the VE Subtarget around so that we can
  /// make the right decision when generating code for different targets.
  const VESubtarget *Subtarget;

public:
  explicit VEDAGToDAGISel(VETargetMachine &tm) : SelectionDAGISel(tm) {}

  bool runOnMachineFunction(MachineFunction &MF) override {
    Subtarget = &MF.getSubtarget<VESubtarget>();
    return SelectionDAGISel::runOnMachineFunction(MF);
  }

  void Select(SDNode *N) override;

  // Complex Pattern Selectors.
  bool SelectADDRri(SDValue N, SDValue &Base, SDValue &Offset);

  StringRef getPassName() const override {
    return "VE DAG->DAG Pattern Instruction Selection";
  }

  // Include the pieces autogenerated from the target description.
#include "VEGenDAGISel.inc"
};
} // end anonymous namespace

bool VEDAGToDAGISel::SelectADDRri(SDValue Addr, SDValue &Base,
                                  SDValue &Offset) {
  auto AddrTy = Addr->getValueType(0);
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), AddrTy);
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false; // direct calls.

  if (CurDAG->isBaseWithConstantOffset(Addr)) {
    ConstantSDNode *CN = cast<ConstantSDNode>(Addr.getOperand(1));
    if (isInt<13>(CN->getSExtValue())) {
      if (FrameIndexSDNode *FIN =
              dyn_cast<FrameIndexSDNode>(Addr.getOperand(0))) {
        // Constant offset from frame ref.
        Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), AddrTy);
      } else {
        Base = Addr.getOperand(0);
      }
      Offset =
          CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(Addr), MVT::i32);
      return true;
    }
  }
  Base = Addr;
  Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
  return true;
}

void VEDAGToDAGISel::Select(SDNode *N) {
  SDLoc dl(N);
  if (N->isMachineOpcode()) {
    N->setNodeId(-1);
    return; // Already selected.
  }

  SelectCode(N);
}

/// createVEISelDag - This pass converts a legalized DAG into a
/// VE-specific DAG, ready for instruction scheduling.
///
FunctionPass *llvm::createVEISelDag(VETargetMachine &TM) {
  return new VEDAGToDAGISel(TM);
}
