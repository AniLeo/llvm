//===-- MSP430ISelDAGToDAG.cpp - A dag to dag inst selector for MSP430 ----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the MSP430 target.
//
//===----------------------------------------------------------------------===//

#include "MSP430.h"
#include "MSP430TargetMachine.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "msp430-isel"

namespace {
  struct MSP430ISelAddressMode {
    enum {
      RegBase,
      FrameIndexBase
    } BaseType = RegBase;

    struct {            // This is really a union, discriminated by BaseType!
      SDValue Reg;
      int FrameIndex = 0;
    } Base;

    int16_t Disp = 0;
    const GlobalValue *GV = nullptr;
    const Constant *CP = nullptr;
    const BlockAddress *BlockAddr = nullptr;
    const char *ES = nullptr;
    int JT = -1;
    unsigned Align = 0;  // CP alignment.

    MSP430ISelAddressMode() = default;

    bool hasSymbolicDisplacement() const {
      return GV != nullptr || CP != nullptr || ES != nullptr || JT != -1;
    }

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
    LLVM_DUMP_METHOD void dump() {
      errs() << "MSP430ISelAddressMode " << this << '\n';
      if (BaseType == RegBase && Base.Reg.getNode() != nullptr) {
        errs() << "Base.Reg ";
        Base.Reg.getNode()->dump();
      } else if (BaseType == FrameIndexBase) {
        errs() << " Base.FrameIndex " << Base.FrameIndex << '\n';
      }
      errs() << " Disp " << Disp << '\n';
      if (GV) {
        errs() << "GV ";
        GV->dump();
      } else if (CP) {
        errs() << " CP ";
        CP->dump();
        errs() << " Align" << Align << '\n';
      } else if (ES) {
        errs() << "ES ";
        errs() << ES << '\n';
      } else if (JT != -1)
        errs() << " JT" << JT << " Align" << Align << '\n';
    }
#endif
  };
}

/// MSP430DAGToDAGISel - MSP430 specific code to select MSP430 machine
/// instructions for SelectionDAG operations.
///
namespace {
  class MSP430DAGToDAGISel : public SelectionDAGISel {
  public:
    MSP430DAGToDAGISel(MSP430TargetMachine &TM, CodeGenOpt::Level OptLevel)
        : SelectionDAGISel(TM, OptLevel) {}

  private:
    StringRef getPassName() const override {
      return "MSP430 DAG->DAG Pattern Instruction Selection";
    }

    bool MatchAddress(SDValue N, MSP430ISelAddressMode &AM);
    bool MatchWrapper(SDValue N, MSP430ISelAddressMode &AM);
    bool MatchAddressBase(SDValue N, MSP430ISelAddressMode &AM);

    bool SelectInlineAsmMemoryOperand(const SDValue &Op, unsigned ConstraintID,
                                      std::vector<SDValue> &OutOps) override;

    // Include the pieces autogenerated from the target description.
  #include "MSP430GenDAGISel.inc"

    // Main method to transform nodes into machine nodes.
    void Select(SDNode *N) override;

    bool tryIndexedLoad(SDNode *Op);
    bool tryIndexedBinOp(SDNode *Op, SDValue N1, SDValue N2, unsigned Opc8,
                         unsigned Opc16);

    bool SelectAddr(SDValue Addr, SDValue &Base, SDValue &Disp);
  };
}  // end anonymous namespace

/// createMSP430ISelDag - This pass converts a legalized DAG into a
/// MSP430-specific DAG, ready for instruction scheduling.
///
FunctionPass *llvm::createMSP430ISelDag(MSP430TargetMachine &TM,
                                        CodeGenOpt::Level OptLevel) {
  return new MSP430DAGToDAGISel(TM, OptLevel);
}


/// MatchWrapper - Try to match MSP430ISD::Wrapper node into an addressing mode.
/// These wrap things that will resolve down into a symbol reference.  If no
/// match is possible, this returns true, otherwise it returns false.
bool MSP430DAGToDAGISel::MatchWrapper(SDValue N, MSP430ISelAddressMode &AM) {
  // If the addressing mode already has a symbol as the displacement, we can
  // never match another symbol.
  if (AM.hasSymbolicDisplacement())
    return true;

  SDValue N0 = N.getOperand(0);

  if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(N0)) {
    AM.GV = G->getGlobal();
    AM.Disp += G->getOffset();
    //AM.SymbolFlags = G->getTargetFlags();
  } else if (ConstantPoolSDNode *CP = dyn_cast<ConstantPoolSDNode>(N0)) {
    AM.CP = CP->getConstVal();
    AM.Align = CP->getAlign().value();
    AM.Disp += CP->getOffset();
    //AM.SymbolFlags = CP->getTargetFlags();
  } else if (ExternalSymbolSDNode *S = dyn_cast<ExternalSymbolSDNode>(N0)) {
    AM.ES = S->getSymbol();
    //AM.SymbolFlags = S->getTargetFlags();
  } else if (JumpTableSDNode *J = dyn_cast<JumpTableSDNode>(N0)) {
    AM.JT = J->getIndex();
    //AM.SymbolFlags = J->getTargetFlags();
  } else {
    AM.BlockAddr = cast<BlockAddressSDNode>(N0)->getBlockAddress();
    //AM.SymbolFlags = cast<BlockAddressSDNode>(N0)->getTargetFlags();
  }
  return false;
}

/// MatchAddressBase - Helper for MatchAddress. Add the specified node to the
/// specified addressing mode without any further recursion.
bool MSP430DAGToDAGISel::MatchAddressBase(SDValue N, MSP430ISelAddressMode &AM) {
  // Is the base register already occupied?
  if (AM.BaseType != MSP430ISelAddressMode::RegBase || AM.Base.Reg.getNode()) {
    // If so, we cannot select it.
    return true;
  }

  // Default, generate it as a register.
  AM.BaseType = MSP430ISelAddressMode::RegBase;
  AM.Base.Reg = N;
  return false;
}

bool MSP430DAGToDAGISel::MatchAddress(SDValue N, MSP430ISelAddressMode &AM) {
  LLVM_DEBUG(errs() << "MatchAddress: "; AM.dump());

  switch (N.getOpcode()) {
  default: break;
  case ISD::Constant: {
    uint64_t Val = cast<ConstantSDNode>(N)->getSExtValue();
    AM.Disp += Val;
    return false;
  }

  case MSP430ISD::Wrapper:
    if (!MatchWrapper(N, AM))
      return false;
    break;

  case ISD::FrameIndex:
    if (AM.BaseType == MSP430ISelAddressMode::RegBase
        && AM.Base.Reg.getNode() == nullptr) {
      AM.BaseType = MSP430ISelAddressMode::FrameIndexBase;
      AM.Base.FrameIndex = cast<FrameIndexSDNode>(N)->getIndex();
      return false;
    }
    break;

  case ISD::ADD: {
    MSP430ISelAddressMode Backup = AM;
    if (!MatchAddress(N.getNode()->getOperand(0), AM) &&
        !MatchAddress(N.getNode()->getOperand(1), AM))
      return false;
    AM = Backup;
    if (!MatchAddress(N.getNode()->getOperand(1), AM) &&
        !MatchAddress(N.getNode()->getOperand(0), AM))
      return false;
    AM = Backup;

    break;
  }

  case ISD::OR:
    // Handle "X | C" as "X + C" iff X is known to have C bits clear.
    if (ConstantSDNode *CN = dyn_cast<ConstantSDNode>(N.getOperand(1))) {
      MSP430ISelAddressMode Backup = AM;
      uint64_t Offset = CN->getSExtValue();
      // Start with the LHS as an addr mode.
      if (!MatchAddress(N.getOperand(0), AM) &&
          // Address could not have picked a GV address for the displacement.
          AM.GV == nullptr &&
          // Check to see if the LHS & C is zero.
          CurDAG->MaskedValueIsZero(N.getOperand(0), CN->getAPIntValue())) {
        AM.Disp += Offset;
        return false;
      }
      AM = Backup;
    }
    break;
  }

  return MatchAddressBase(N, AM);
}

/// SelectAddr - returns true if it is able pattern match an addressing mode.
/// It returns the operands which make up the maximal addressing mode it can
/// match by reference.
bool MSP430DAGToDAGISel::SelectAddr(SDValue N,
                                    SDValue &Base, SDValue &Disp) {
  MSP430ISelAddressMode AM;

  if (MatchAddress(N, AM))
    return false;

  if (AM.BaseType == MSP430ISelAddressMode::RegBase)
    if (!AM.Base.Reg.getNode())
      AM.Base.Reg = CurDAG->getRegister(MSP430::SR, MVT::i16);

  Base = (AM.BaseType == MSP430ISelAddressMode::FrameIndexBase)
             ? CurDAG->getTargetFrameIndex(
                   AM.Base.FrameIndex,
                   getTargetLowering()->getPointerTy(CurDAG->getDataLayout()))
             : AM.Base.Reg;

  if (AM.GV)
    Disp = CurDAG->getTargetGlobalAddress(AM.GV, SDLoc(N),
                                          MVT::i16, AM.Disp,
                                          0/*AM.SymbolFlags*/);
  else if (AM.CP)
    Disp = CurDAG->getTargetConstantPool(AM.CP, MVT::i16, Align(AM.Align),
                                         AM.Disp, 0 /*AM.SymbolFlags*/);
  else if (AM.ES)
    Disp = CurDAG->getTargetExternalSymbol(AM.ES, MVT::i16, 0/*AM.SymbolFlags*/);
  else if (AM.JT != -1)
    Disp = CurDAG->getTargetJumpTable(AM.JT, MVT::i16, 0/*AM.SymbolFlags*/);
  else if (AM.BlockAddr)
    Disp = CurDAG->getTargetBlockAddress(AM.BlockAddr, MVT::i32, 0,
                                         0/*AM.SymbolFlags*/);
  else
    Disp = CurDAG->getTargetConstant(AM.Disp, SDLoc(N), MVT::i16);

  return true;
}

bool MSP430DAGToDAGISel::
SelectInlineAsmMemoryOperand(const SDValue &Op, unsigned ConstraintID,
                             std::vector<SDValue> &OutOps) {
  SDValue Op0, Op1;
  switch (ConstraintID) {
  default: return true;
  case InlineAsm::Constraint_m: // memory
    if (!SelectAddr(Op, Op0, Op1))
      return true;
    break;
  }

  OutOps.push_back(Op0);
  OutOps.push_back(Op1);
  return false;
}

static bool isValidIndexedLoad(const LoadSDNode *LD) {
  ISD::MemIndexedMode AM = LD->getAddressingMode();
  if (AM != ISD::POST_INC || LD->getExtensionType() != ISD::NON_EXTLOAD)
    return false;

  EVT VT = LD->getMemoryVT();

  switch (VT.getSimpleVT().SimpleTy) {
  case MVT::i8:
    // Sanity check
    if (cast<ConstantSDNode>(LD->getOffset())->getZExtValue() != 1)
      return false;

    break;
  case MVT::i16:
    // Sanity check
    if (cast<ConstantSDNode>(LD->getOffset())->getZExtValue() != 2)
      return false;

    break;
  default:
    return false;
  }

  return true;
}

bool MSP430DAGToDAGISel::tryIndexedLoad(SDNode *N) {
  LoadSDNode *LD = cast<LoadSDNode>(N);
  if (!isValidIndexedLoad(LD))
    return false;

  MVT VT = LD->getMemoryVT().getSimpleVT();

  unsigned Opcode = 0;
  switch (VT.SimpleTy) {
  case MVT::i8:
    Opcode = MSP430::MOV8rp;
    break;
  case MVT::i16:
    Opcode = MSP430::MOV16rp;
    break;
  default:
    return false;
  }

  ReplaceNode(N,
              CurDAG->getMachineNode(Opcode, SDLoc(N), VT, MVT::i16, MVT::Other,
                                     LD->getBasePtr(), LD->getChain()));
  return true;
}

bool MSP430DAGToDAGISel::tryIndexedBinOp(SDNode *Op, SDValue N1, SDValue N2,
                                         unsigned Opc8, unsigned Opc16) {
  if (N1.getOpcode() == ISD::LOAD &&
      N1.hasOneUse() &&
      IsLegalToFold(N1, Op, Op, OptLevel)) {
    LoadSDNode *LD = cast<LoadSDNode>(N1);
    if (!isValidIndexedLoad(LD))
      return false;

    MVT VT = LD->getMemoryVT().getSimpleVT();
    unsigned Opc = (VT == MVT::i16 ? Opc16 : Opc8);
    MachineMemOperand *MemRef = cast<MemSDNode>(N1)->getMemOperand();
    SDValue Ops0[] = { N2, LD->getBasePtr(), LD->getChain() };
    SDNode *ResNode =
      CurDAG->SelectNodeTo(Op, Opc, VT, MVT::i16, MVT::Other, Ops0);
    CurDAG->setNodeMemRefs(cast<MachineSDNode>(ResNode), {MemRef});
    // Transfer chain.
    ReplaceUses(SDValue(N1.getNode(), 2), SDValue(ResNode, 2));
    // Transfer writeback.
    ReplaceUses(SDValue(N1.getNode(), 1), SDValue(ResNode, 1));
    return true;
  }

  return false;
}


void MSP430DAGToDAGISel::Select(SDNode *Node) {
  SDLoc dl(Node);

  // If we have a custom node, we already have selected!
  if (Node->isMachineOpcode()) {
    LLVM_DEBUG(errs() << "== "; Node->dump(CurDAG); errs() << "\n");
    Node->setNodeId(-1);
    return;
  }

  // Few custom selection stuff.
  switch (Node->getOpcode()) {
  default: break;
  case ISD::FrameIndex: {
    assert(Node->getValueType(0) == MVT::i16);
    int FI = cast<FrameIndexSDNode>(Node)->getIndex();
    SDValue TFI = CurDAG->getTargetFrameIndex(FI, MVT::i16);
    if (Node->hasOneUse()) {
      CurDAG->SelectNodeTo(Node, MSP430::ADDframe, MVT::i16, TFI,
                           CurDAG->getTargetConstant(0, dl, MVT::i16));
      return;
    }
    ReplaceNode(Node, CurDAG->getMachineNode(
                          MSP430::ADDframe, dl, MVT::i16, TFI,
                          CurDAG->getTargetConstant(0, dl, MVT::i16)));
    return;
  }
  case ISD::LOAD:
    if (tryIndexedLoad(Node))
      return;
    // Other cases are autogenerated.
    break;
  case ISD::ADD:
    if (tryIndexedBinOp(Node, Node->getOperand(0), Node->getOperand(1),
                        MSP430::ADD8rp, MSP430::ADD16rp))
      return;
    else if (tryIndexedBinOp(Node, Node->getOperand(1), Node->getOperand(0),
                             MSP430::ADD8rp, MSP430::ADD16rp))
      return;

    // Other cases are autogenerated.
    break;
  case ISD::SUB:
    if (tryIndexedBinOp(Node, Node->getOperand(0), Node->getOperand(1),
                        MSP430::SUB8rp, MSP430::SUB16rp))
      return;

    // Other cases are autogenerated.
    break;
  case ISD::AND:
    if (tryIndexedBinOp(Node, Node->getOperand(0), Node->getOperand(1),
                        MSP430::AND8rp, MSP430::AND16rp))
      return;
    else if (tryIndexedBinOp(Node, Node->getOperand(1), Node->getOperand(0),
                             MSP430::AND8rp, MSP430::AND16rp))
      return;

    // Other cases are autogenerated.
    break;
  case ISD::OR:
    if (tryIndexedBinOp(Node, Node->getOperand(0), Node->getOperand(1),
                        MSP430::BIS8rp, MSP430::BIS16rp))
      return;
    else if (tryIndexedBinOp(Node, Node->getOperand(1), Node->getOperand(0),
                             MSP430::BIS8rp, MSP430::BIS16rp))
      return;

    // Other cases are autogenerated.
    break;
  case ISD::XOR:
    if (tryIndexedBinOp(Node, Node->getOperand(0), Node->getOperand(1),
                        MSP430::XOR8rp, MSP430::XOR16rp))
      return;
    else if (tryIndexedBinOp(Node, Node->getOperand(1), Node->getOperand(0),
                             MSP430::XOR8rp, MSP430::XOR16rp))
      return;

    // Other cases are autogenerated.
    break;
  }

  // Select the default instruction
  SelectCode(Node);
}
