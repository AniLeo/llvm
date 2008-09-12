//===---- IA64ISelDAGToDAG.cpp - IA64 pattern matching inst selector ------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines a pattern matching instruction selector for IA64,
// converting a legalized dag to an IA64 dag.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "ia64-codegen"
#include "IA64.h"
#include "IA64TargetMachine.h"
#include "IA64ISelLowering.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/Constants.h"
#include "llvm/GlobalValue.h"
#include "llvm/Intrinsics.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include <queue>
#include <set>
using namespace llvm;

namespace {
  //===--------------------------------------------------------------------===//
  /// IA64DAGToDAGISel - IA64 specific code to select IA64 machine
  /// instructions for SelectionDAG operations.
  ///
  class IA64DAGToDAGISel : public SelectionDAGISel {
    IA64TargetLowering IA64Lowering;
    unsigned GlobalBaseReg;
  public:
    explicit IA64DAGToDAGISel(IA64TargetMachine &TM)
      : SelectionDAGISel(IA64Lowering), IA64Lowering(*TM.getTargetLowering()) {}
    
    virtual bool runOnFunction(Function &Fn) {
      // Make sure we re-emit a set of the global base reg if necessary
      GlobalBaseReg = 0;
      return SelectionDAGISel::runOnFunction(Fn);
    }
 
    /// getI64Imm - Return a target constant with the specified value, of type
    /// i64.
    inline SDValue getI64Imm(uint64_t Imm) {
      return CurDAG->getTargetConstant(Imm, MVT::i64);
    }

    /// getGlobalBaseReg - insert code into the entry mbb to materialize the PIC
    /// base register.  Return the virtual register that holds this value.
    // SDValue getGlobalBaseReg(); TODO: hmm
    
    // Select - Convert the specified operand from a target-independent to a
    // target-specific node if it hasn't already been changed.
    SDNode *Select(SDValue N);
    
    SDNode *SelectIntImmediateExpr(SDValue LHS, SDValue RHS,
                                   unsigned OCHi, unsigned OCLo,
                                   bool IsArithmetic = false,
                                   bool Negate = false);
    SDNode *SelectBitfieldInsert(SDNode *N);

    /// SelectCC - Select a comparison of the specified values with the
    /// specified condition code, returning the CR# of the expression.
    SDValue SelectCC(SDValue LHS, SDValue RHS, ISD::CondCode CC);

    /// SelectAddr - Given the specified address, return the two operands for a
    /// load/store instruction, and return true if it should be an indexed [r+r]
    /// operation.
    bool SelectAddr(SDValue Addr, SDValue &Op1, SDValue &Op2);

    /// InstructionSelect - This callback is invoked by
    /// SelectionDAGISel when it has created a SelectionDAG for us to codegen.
    virtual void InstructionSelect();
    
    virtual const char *getPassName() const {
      return "IA64 (Itanium) DAG->DAG Instruction Selector";
    } 

// Include the pieces autogenerated from the target description.
#include "IA64GenDAGISel.inc"
    
private:
    SDNode *SelectDIV(SDValue Op);
  };
}

/// InstructionSelect - This callback is invoked by
/// SelectionDAGISel when it has created a SelectionDAG for us to codegen.
void IA64DAGToDAGISel::InstructionSelect() {
  DEBUG(BB->dump());

  // Select target instructions for the DAG.
  SelectRoot();
  CurDAG->RemoveDeadNodes();
}

SDNode *IA64DAGToDAGISel::SelectDIV(SDValue Op) {
  SDNode *N = Op.getNode();
  SDValue Chain = N->getOperand(0);
  SDValue Tmp1 = N->getOperand(0);
  SDValue Tmp2 = N->getOperand(1);
  AddToISelQueue(Chain);

  AddToISelQueue(Tmp1);
  AddToISelQueue(Tmp2);

  bool isFP=false;

  if(Tmp1.getValueType().isFloatingPoint())
    isFP=true;
    
  bool isModulus=false; // is it a division or a modulus?
  bool isSigned=false;

  switch(N->getOpcode()) {
    case ISD::FDIV:
    case ISD::SDIV:  isModulus=false; isSigned=true;  break;
    case ISD::UDIV:  isModulus=false; isSigned=false; break;
    case ISD::FREM:
    case ISD::SREM:  isModulus=true;  isSigned=true;  break;
    case ISD::UREM:  isModulus=true;  isSigned=false; break;
  }

  // TODO: check for integer divides by powers of 2 (or other simple patterns?)

    SDValue TmpPR, TmpPR2;
    SDValue TmpF1, TmpF2, TmpF3, TmpF4, TmpF5, TmpF6, TmpF7, TmpF8;
    SDValue TmpF9, TmpF10,TmpF11,TmpF12,TmpF13,TmpF14,TmpF15;
    SDNode *Result;

    // we'll need copies of F0 and F1
    SDValue F0 = CurDAG->getRegister(IA64::F0, MVT::f64);
    SDValue F1 = CurDAG->getRegister(IA64::F1, MVT::f64);
    
    // OK, emit some code:

    if(!isFP) {
      // first, load the inputs into FP regs.
      TmpF1 =
        SDValue(CurDAG->getTargetNode(IA64::SETFSIG, MVT::f64, Tmp1), 0);
      Chain = TmpF1.getValue(1);
      TmpF2 =
        SDValue(CurDAG->getTargetNode(IA64::SETFSIG, MVT::f64, Tmp2), 0);
      Chain = TmpF2.getValue(1);
      
      // next, convert the inputs to FP
      if(isSigned) {
        TmpF3 =
          SDValue(CurDAG->getTargetNode(IA64::FCVTXF, MVT::f64, TmpF1), 0);
        Chain = TmpF3.getValue(1);
        TmpF4 =
          SDValue(CurDAG->getTargetNode(IA64::FCVTXF, MVT::f64, TmpF2), 0);
        Chain = TmpF4.getValue(1);
      } else { // is unsigned
        TmpF3 =
          SDValue(CurDAG->getTargetNode(IA64::FCVTXUFS1, MVT::f64, TmpF1), 0);
        Chain = TmpF3.getValue(1);
        TmpF4 =
          SDValue(CurDAG->getTargetNode(IA64::FCVTXUFS1, MVT::f64, TmpF2), 0);
        Chain = TmpF4.getValue(1);
      }

    } else { // this is an FP divide/remainder, so we 'leak' some temp
             // regs and assign TmpF3=Tmp1, TmpF4=Tmp2
      TmpF3=Tmp1;
      TmpF4=Tmp2;
    }

    // we start by computing an approximate reciprocal (good to 9 bits?)
    // note, this instruction writes _both_ TmpF5 (answer) and TmpPR (predicate)
    if(isFP)
      TmpF5 = SDValue(CurDAG->getTargetNode(IA64::FRCPAS0, MVT::f64, MVT::i1,
                                              TmpF3, TmpF4), 0);
    else
      TmpF5 = SDValue(CurDAG->getTargetNode(IA64::FRCPAS1, MVT::f64, MVT::i1,
                                              TmpF3, TmpF4), 0);
                                  
    TmpPR = TmpF5.getValue(1);
    Chain = TmpF5.getValue(2);

    SDValue minusB;
    if(isModulus) { // for remainders, it'll be handy to have
                             // copies of -input_b
      minusB = SDValue(CurDAG->getTargetNode(IA64::SUB, MVT::i64,
                  CurDAG->getRegister(IA64::r0, MVT::i64), Tmp2), 0);
      Chain = minusB.getValue(1);
    }
    
    SDValue TmpE0, TmpY1, TmpE1, TmpY2;

    SDValue OpsE0[] = { TmpF4, TmpF5, F1, TmpPR };
    TmpE0 = SDValue(CurDAG->getTargetNode(IA64::CFNMAS1, MVT::f64,
                                            OpsE0, 4), 0);
    Chain = TmpE0.getValue(1);
    SDValue OpsY1[] = { TmpF5, TmpE0, TmpF5, TmpPR };
    TmpY1 = SDValue(CurDAG->getTargetNode(IA64::CFMAS1, MVT::f64,
                                            OpsY1, 4), 0);
    Chain = TmpY1.getValue(1);
    SDValue OpsE1[] = { TmpE0, TmpE0, F0, TmpPR };
    TmpE1 = SDValue(CurDAG->getTargetNode(IA64::CFMAS1, MVT::f64,
                                            OpsE1, 4), 0);
    Chain = TmpE1.getValue(1);
    SDValue OpsY2[] = { TmpY1, TmpE1, TmpY1, TmpPR };
    TmpY2 = SDValue(CurDAG->getTargetNode(IA64::CFMAS1, MVT::f64,
                                            OpsY2, 4), 0);
    Chain = TmpY2.getValue(1);
    
    if(isFP) { // if this is an FP divide, we finish up here and exit early
      if(isModulus)
        assert(0 && "Sorry, try another FORTRAN compiler.");
 
      SDValue TmpE2, TmpY3, TmpQ0, TmpR0;

      SDValue OpsE2[] = { TmpE1, TmpE1, F0, TmpPR };
      TmpE2 = SDValue(CurDAG->getTargetNode(IA64::CFMAS1, MVT::f64,
                                              OpsE2, 4), 0);
      Chain = TmpE2.getValue(1);
      SDValue OpsY3[] = { TmpY2, TmpE2, TmpY2, TmpPR };
      TmpY3 = SDValue(CurDAG->getTargetNode(IA64::CFMAS1, MVT::f64,
                                              OpsY3, 4), 0);
      Chain = TmpY3.getValue(1);
      SDValue OpsQ0[] = { Tmp1, TmpY3, F0, TmpPR };
      TmpQ0 =
        SDValue(CurDAG->getTargetNode(IA64::CFMADS1, MVT::f64, // double prec!
                                        OpsQ0, 4), 0);
      Chain = TmpQ0.getValue(1);
      SDValue OpsR0[] = { Tmp2, TmpQ0, Tmp1, TmpPR };
      TmpR0 =
        SDValue(CurDAG->getTargetNode(IA64::CFNMADS1, MVT::f64, // double prec!
                                        OpsR0, 4), 0);
      Chain = TmpR0.getValue(1);

// we want Result to have the same target register as the frcpa, so
// we two-address hack it. See the comment "for this to work..." on
// page 48 of Intel application note #245415
      SDValue Ops[] = { TmpF5, TmpY3, TmpR0, TmpQ0, TmpPR };
      Result = CurDAG->getTargetNode(IA64::TCFMADS0, MVT::f64, // d.p. s0 rndg!
                                     Ops, 5);
      Chain = SDValue(Result, 1);
      return Result; // XXX: early exit!
    } else { // this is *not* an FP divide, so there's a bit left to do:
    
      SDValue TmpQ2, TmpR2, TmpQ3, TmpQ;

      SDValue OpsQ2[] = { TmpF3, TmpY2, F0, TmpPR };
      TmpQ2 = SDValue(CurDAG->getTargetNode(IA64::CFMAS1, MVT::f64,
                                              OpsQ2, 4), 0);
      Chain = TmpQ2.getValue(1);
      SDValue OpsR2[] = { TmpF4, TmpQ2, TmpF3, TmpPR };
      TmpR2 = SDValue(CurDAG->getTargetNode(IA64::CFNMAS1, MVT::f64,
                                              OpsR2, 4), 0);
      Chain = TmpR2.getValue(1);
      
// we want TmpQ3 to have the same target register as the frcpa? maybe we
// should two-address hack it. See the comment "for this to work..." on page
// 48 of Intel application note #245415
      SDValue OpsQ3[] = { TmpF5, TmpR2, TmpY2, TmpQ2, TmpPR };
      TmpQ3 = SDValue(CurDAG->getTargetNode(IA64::TCFMAS1, MVT::f64,
                                         OpsQ3, 5), 0);
      Chain = TmpQ3.getValue(1);

      // STORY: without these two-address instructions (TCFMAS1 and TCFMADS0)
      // the FPSWA won't be able to help out in the case of large/tiny
      // arguments. Other fun bugs may also appear, e.g. 0/x = x, not 0.
      
      if(isSigned)
        TmpQ = SDValue(CurDAG->getTargetNode(IA64::FCVTFXTRUNCS1,
                                               MVT::f64, TmpQ3), 0);
      else
        TmpQ = SDValue(CurDAG->getTargetNode(IA64::FCVTFXUTRUNCS1,
                                               MVT::f64, TmpQ3), 0);
      
      Chain = TmpQ.getValue(1);

      if(isModulus) {
        SDValue FPminusB =
          SDValue(CurDAG->getTargetNode(IA64::SETFSIG, MVT::f64, minusB), 0);
        Chain = FPminusB.getValue(1);
        SDValue Remainder =
          SDValue(CurDAG->getTargetNode(IA64::XMAL, MVT::f64,
                                          TmpQ, FPminusB, TmpF1), 0);
        Chain = Remainder.getValue(1);
        Result = CurDAG->getTargetNode(IA64::GETFSIG, MVT::i64, Remainder);
        Chain = SDValue(Result, 1);
      } else { // just an integer divide
        Result = CurDAG->getTargetNode(IA64::GETFSIG, MVT::i64, TmpQ);
        Chain = SDValue(Result, 1);
      }

      return Result;
    } // wasn't an FP divide
}

// Select - Convert the specified operand from a target-independent to a
// target-specific node if it hasn't already been changed.
SDNode *IA64DAGToDAGISel::Select(SDValue Op) {
  SDNode *N = Op.getNode();
  if (N->isMachineOpcode())
    return NULL;   // Already selected.

  switch (N->getOpcode()) {
  default: break;

  case IA64ISD::BRCALL: { // XXX: this is also a hack!
    SDValue Chain = N->getOperand(0);
    SDValue InFlag;  // Null incoming flag value.

    AddToISelQueue(Chain);
    if(N->getNumOperands()==3) { // we have an incoming chain, callee and flag
      InFlag = N->getOperand(2);
      AddToISelQueue(InFlag);
    }

    unsigned CallOpcode;
    SDValue CallOperand;
    
    // if we can call directly, do so
    if (GlobalAddressSDNode *GASD =
      dyn_cast<GlobalAddressSDNode>(N->getOperand(1))) {
      CallOpcode = IA64::BRCALL_IPREL_GA;
      CallOperand = CurDAG->getTargetGlobalAddress(GASD->getGlobal(), MVT::i64);
    } else if (isa<ExternalSymbolSDNode>(N->getOperand(1))) {
      // FIXME: we currently NEED this case for correctness, to avoid
      // "non-pic code with imm reloc.n against dynamic symbol" errors
    CallOpcode = IA64::BRCALL_IPREL_ES;
    CallOperand = N->getOperand(1);
  } else {
    // otherwise we need to load the function descriptor,
    // load the branch target (function)'s entry point and GP,
    // branch (call) then restore the GP
    SDValue FnDescriptor = N->getOperand(1);
    AddToISelQueue(FnDescriptor);
   
    // load the branch target's entry point [mem] and 
    // GP value [mem+8]
    SDValue targetEntryPoint=
      SDValue(CurDAG->getTargetNode(IA64::LD8, MVT::i64, MVT::Other,
                                      FnDescriptor, CurDAG->getEntryNode()), 0);
    Chain = targetEntryPoint.getValue(1);
    SDValue targetGPAddr=
      SDValue(CurDAG->getTargetNode(IA64::ADDS, MVT::i64, 
                                      FnDescriptor,
                                      CurDAG->getConstant(8, MVT::i64)), 0);
    Chain = targetGPAddr.getValue(1);
    SDValue targetGP =
      SDValue(CurDAG->getTargetNode(IA64::LD8, MVT::i64,MVT::Other,
                                      targetGPAddr, CurDAG->getEntryNode()), 0);
    Chain = targetGP.getValue(1);

    Chain = CurDAG->getCopyToReg(Chain, IA64::r1, targetGP, InFlag);
    InFlag = Chain.getValue(1);
    Chain = CurDAG->getCopyToReg(Chain, IA64::B6,
                                 targetEntryPoint, InFlag); // FLAG these?
    InFlag = Chain.getValue(1);
    
    CallOperand = CurDAG->getRegister(IA64::B6, MVT::i64);
    CallOpcode = IA64::BRCALL_INDIRECT;
  }
 
   // Finally, once everything is setup, emit the call itself
   if (InFlag.getNode())
     Chain = SDValue(CurDAG->getTargetNode(CallOpcode, MVT::Other, MVT::Flag,
                                             CallOperand, InFlag), 0);
   else // there might be no arguments
     Chain = SDValue(CurDAG->getTargetNode(CallOpcode, MVT::Other, MVT::Flag,
                                             CallOperand, Chain), 0);
   InFlag = Chain.getValue(1);

   std::vector<SDValue> CallResults;

   CallResults.push_back(Chain);
   CallResults.push_back(InFlag);

   for (unsigned i = 0, e = CallResults.size(); i != e; ++i)
     ReplaceUses(Op.getValue(i), CallResults[i]);
   return NULL;
  }
  
  case IA64ISD::GETFD: {
    SDValue Input = N->getOperand(0);
    AddToISelQueue(Input);
    return CurDAG->getTargetNode(IA64::GETFD, MVT::i64, Input);
  } 
  
  case ISD::FDIV:
  case ISD::SDIV:
  case ISD::UDIV:
  case ISD::SREM:
  case ISD::UREM:
    return SelectDIV(Op);
 
  case ISD::TargetConstantFP: {
    SDValue Chain = CurDAG->getEntryNode(); // this is a constant, so..

    SDValue V;
    ConstantFPSDNode* N2 = cast<ConstantFPSDNode>(N);
    if (N2->getValueAPF().isPosZero()) {
      V = CurDAG->getCopyFromReg(Chain, IA64::F0, MVT::f64);
    } else if (N2->isExactlyValue(N2->getValueType(0) == MVT::f32 ? 
                                  APFloat(+1.0f) : APFloat(+1.0))) {
      V = CurDAG->getCopyFromReg(Chain, IA64::F1, MVT::f64);
    } else
      assert(0 && "Unexpected FP constant!");
    
    ReplaceUses(SDValue(N, 0), V);
    return 0;
  }

  case ISD::FrameIndex: { // TODO: reduce creepyness
    int FI = cast<FrameIndexSDNode>(N)->getIndex();
    if (N->hasOneUse())
      return CurDAG->SelectNodeTo(N, IA64::MOV, MVT::i64,
                                  CurDAG->getTargetFrameIndex(FI, MVT::i64));
    else
      return CurDAG->getTargetNode(IA64::MOV, MVT::i64,
                                   CurDAG->getTargetFrameIndex(FI, MVT::i64));
  }

  case ISD::ConstantPool: { // TODO: nuke the constant pool
    // (ia64 doesn't need one)
    ConstantPoolSDNode *CP = cast<ConstantPoolSDNode>(N);
    Constant *C = CP->getConstVal();
    SDValue CPI = CurDAG->getTargetConstantPool(C, MVT::i64,
                                                  CP->getAlignment());
    return CurDAG->getTargetNode(IA64::ADDL_GA, MVT::i64, // ?
                                 CurDAG->getRegister(IA64::r1, MVT::i64), CPI);
  }

  case ISD::GlobalAddress: {
    GlobalValue *GV = cast<GlobalAddressSDNode>(N)->getGlobal();
    SDValue GA = CurDAG->getTargetGlobalAddress(GV, MVT::i64);
    SDValue Tmp =
      SDValue(CurDAG->getTargetNode(IA64::ADDL_GA, MVT::i64, 
                                      CurDAG->getRegister(IA64::r1,
                                                          MVT::i64), GA), 0);
    return CurDAG->getTargetNode(IA64::LD8, MVT::i64, MVT::Other, Tmp,
                                 CurDAG->getEntryNode());
  }
  
/* XXX
   case ISD::ExternalSymbol: {
     SDValue EA = CurDAG->getTargetExternalSymbol(
       cast<ExternalSymbolSDNode>(N)->getSymbol(),
       MVT::i64);
     SDValue Tmp = CurDAG->getTargetNode(IA64::ADDL_EA, MVT::i64, 
                                           CurDAG->getRegister(IA64::r1,
                                                               MVT::i64),
                                           EA);
     return CurDAG->getTargetNode(IA64::LD8, MVT::i64, Tmp);
   }
*/

  case ISD::LOAD: { // FIXME: load -1, not 1, for bools?
    LoadSDNode *LD = cast<LoadSDNode>(N);
    SDValue Chain = LD->getChain();
    SDValue Address = LD->getBasePtr();
    AddToISelQueue(Chain);
    AddToISelQueue(Address);

    MVT TypeBeingLoaded = LD->getMemoryVT();
    unsigned Opc;
    switch (TypeBeingLoaded.getSimpleVT()) {
    default:
#ifndef NDEBUG
      N->dump(CurDAG);
#endif
      assert(0 && "Cannot load this type!");
    case MVT::i1: { // this is a bool
      Opc = IA64::LD1; // first we load a byte, then compare for != 0
      if(N->getValueType(0) == MVT::i1) { // XXX: early exit!
        return CurDAG->SelectNodeTo(N, IA64::CMPNE, MVT::i1, MVT::Other, 
                    SDValue(CurDAG->getTargetNode(Opc, MVT::i64, Address), 0),
                                    CurDAG->getRegister(IA64::r0, MVT::i64), 
                                    Chain);
      }
      /* otherwise, we want to load a bool into something bigger: LD1
         will do that for us, so we just fall through */
    }
    case MVT::i8:  Opc = IA64::LD1; break;
    case MVT::i16: Opc = IA64::LD2; break;
    case MVT::i32: Opc = IA64::LD4; break;
    case MVT::i64: Opc = IA64::LD8; break;
    
    case MVT::f32: Opc = IA64::LDF4; break;
    case MVT::f64: Opc = IA64::LDF8; break;
    }

    // TODO: comment this
    return CurDAG->SelectNodeTo(N, Opc, N->getValueType(0), MVT::Other,
                                Address, Chain);
  }
  
  case ISD::STORE: {
    StoreSDNode *ST = cast<StoreSDNode>(N);
    SDValue Address = ST->getBasePtr();
    SDValue Chain = ST->getChain();
    AddToISelQueue(Address);
    AddToISelQueue(Chain);
   
    unsigned Opc;
    if (ISD::isNON_TRUNCStore(N)) {
      switch (N->getOperand(1).getValueType().getSimpleVT()) {
      default: assert(0 && "unknown type in store");
      case MVT::i1: { // this is a bool
        Opc = IA64::ST1; // we store either 0 or 1 as a byte 
        // first load zero!
        SDValue Initial = CurDAG->getCopyFromReg(Chain, IA64::r0, MVT::i64);
        Chain = Initial.getValue(1);
        // then load 1 into the same reg iff the predicate to store is 1
        SDValue Tmp = ST->getValue();
        AddToISelQueue(Tmp);
        Tmp =
          SDValue(CurDAG->getTargetNode(IA64::TPCADDS, MVT::i64, Initial,
                                          CurDAG->getTargetConstant(1,
                                                                    MVT::i64),
                                          Tmp), 0);
        return CurDAG->SelectNodeTo(N, Opc, MVT::Other, Address, Tmp, Chain);
      }
      case MVT::i64: Opc = IA64::ST8;  break;
      case MVT::f64: Opc = IA64::STF8; break;
      }
    } else { // Truncating store
      switch(ST->getMemoryVT().getSimpleVT()) {
      default: assert(0 && "unknown type in truncstore");
      case MVT::i8:  Opc = IA64::ST1;  break;
      case MVT::i16: Opc = IA64::ST2;  break;
      case MVT::i32: Opc = IA64::ST4;  break;
      case MVT::f32: Opc = IA64::STF4; break;
      }
    }
    
    SDValue N1 = N->getOperand(1);
    SDValue N2 = N->getOperand(2);
    AddToISelQueue(N1);
    AddToISelQueue(N2);
    return CurDAG->SelectNodeTo(N, Opc, MVT::Other, N2, N1, Chain);
  }

  case ISD::BRCOND: {
    SDValue Chain = N->getOperand(0);
    SDValue CC = N->getOperand(1);
    AddToISelQueue(Chain);
    AddToISelQueue(CC);
    MachineBasicBlock *Dest =
      cast<BasicBlockSDNode>(N->getOperand(2))->getBasicBlock();
    //FIXME - we do NOT need long branches all the time
    return CurDAG->SelectNodeTo(N, IA64::BRLCOND_NOTCALL, MVT::Other, CC, 
                                CurDAG->getBasicBlock(Dest), Chain);
  }

  case ISD::CALLSEQ_START:
  case ISD::CALLSEQ_END: {
    int64_t Amt = cast<ConstantSDNode>(N->getOperand(1))->getZExtValue();
    unsigned Opc = N->getOpcode() == ISD::CALLSEQ_START ?
      IA64::ADJUSTCALLSTACKDOWN : IA64::ADJUSTCALLSTACKUP;
    SDValue N0 = N->getOperand(0);
    AddToISelQueue(N0);
    return CurDAG->SelectNodeTo(N, Opc, MVT::Other, getI64Imm(Amt), N0);
  }

  case ISD::BR:
    // FIXME: we don't need long branches all the time!
    SDValue N0 = N->getOperand(0);
    AddToISelQueue(N0);
    return CurDAG->SelectNodeTo(N, IA64::BRL_NOTCALL, MVT::Other, 
                                N->getOperand(1), N0);
  }
  
  return SelectCode(Op);
}


/// createIA64DAGToDAGInstructionSelector - This pass converts a legalized DAG
/// into an IA64-specific DAG, ready for instruction scheduling.
///
FunctionPass
*llvm::createIA64DAGToDAGInstructionSelector(IA64TargetMachine &TM) {
  return new IA64DAGToDAGISel(TM);
}

