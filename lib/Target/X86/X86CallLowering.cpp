//===- llvm/lib/Target/X86/X86CallLowering.cpp - Call lowering ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
/// \file
/// This file implements the lowering of LLVM calls to machine code calls for
/// GlobalISel.
//
//===----------------------------------------------------------------------===//

#include "X86CallLowering.h"
#include "X86CallingConv.h"
#include "X86ISelLowering.h"
#include "X86InstrInfo.h"
#include "X86RegisterInfo.h"
#include "X86Subtarget.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/Analysis.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/GlobalISel/MachineIRBuilder.h"
#include "llvm/CodeGen/GlobalISel/Utils.h"
#include "llvm/CodeGen/LowLevelType.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Value.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/LowLevelTypeImpl.h"
#include "llvm/Support/MachineValueType.h"
#include <cassert>
#include <cstdint>

using namespace llvm;

X86CallLowering::X86CallLowering(const X86TargetLowering &TLI)
    : CallLowering(&TLI) {}

namespace {

struct X86OutgoingValueHandler : public CallLowering::OutgoingValueHandler {
  X86OutgoingValueHandler(MachineIRBuilder &MIRBuilder,
                          MachineRegisterInfo &MRI, MachineInstrBuilder &MIB,
                          CCAssignFn *AssignFn)
      : OutgoingValueHandler(MIRBuilder, MRI, AssignFn), MIB(MIB),
        DL(MIRBuilder.getMF().getDataLayout()),
        STI(MIRBuilder.getMF().getSubtarget<X86Subtarget>()) {}

  Register getStackAddress(uint64_t Size, int64_t Offset,
                           MachinePointerInfo &MPO,
                           ISD::ArgFlagsTy Flags) override {
    LLT p0 = LLT::pointer(0, DL.getPointerSizeInBits(0));
    LLT SType = LLT::scalar(DL.getPointerSizeInBits(0));
    auto SPReg =
        MIRBuilder.buildCopy(p0, STI.getRegisterInfo()->getStackRegister());

    auto OffsetReg = MIRBuilder.buildConstant(SType, Offset);

    auto AddrReg = MIRBuilder.buildPtrAdd(p0, SPReg, OffsetReg);

    MPO = MachinePointerInfo::getStack(MIRBuilder.getMF(), Offset);
    return AddrReg.getReg(0);
  }

  void assignValueToReg(Register ValVReg, Register PhysReg,
                        CCValAssign &VA) override {
    MIB.addUse(PhysReg, RegState::Implicit);
    Register ExtReg = extendRegister(ValVReg, VA);
    MIRBuilder.buildCopy(PhysReg, ExtReg);
  }

  void assignValueToAddress(Register ValVReg, Register Addr, uint64_t Size,
                            MachinePointerInfo &MPO, CCValAssign &VA) override {
    MachineFunction &MF = MIRBuilder.getMF();
    Register ExtReg = extendRegister(ValVReg, VA);

    auto *MMO = MF.getMachineMemOperand(MPO, MachineMemOperand::MOStore,
                                        VA.getLocVT().getStoreSize(),
                                        inferAlignFromPtrInfo(MF, MPO));
    MIRBuilder.buildStore(ExtReg, Addr, *MMO);
  }

  bool assignArg(unsigned ValNo, EVT OrigVT, MVT ValVT, MVT LocVT,
                 CCValAssign::LocInfo LocInfo,
                 const CallLowering::ArgInfo &Info, ISD::ArgFlagsTy Flags,
                 CCState &State) override {
    bool Res = AssignFn(ValNo, ValVT, LocVT, LocInfo, Flags, State);
    StackSize = State.getNextStackOffset();

    static const MCPhysReg XMMArgRegs[] = {X86::XMM0, X86::XMM1, X86::XMM2,
                                           X86::XMM3, X86::XMM4, X86::XMM5,
                                           X86::XMM6, X86::XMM7};
    if (!Info.IsFixed)
      NumXMMRegs = State.getFirstUnallocated(XMMArgRegs);

    return Res;
  }

  uint64_t getStackSize() { return StackSize; }
  uint64_t getNumXmmRegs() { return NumXMMRegs; }

protected:
  MachineInstrBuilder &MIB;
  uint64_t StackSize = 0;
  const DataLayout &DL;
  const X86Subtarget &STI;
  unsigned NumXMMRegs = 0;
};

} // end anonymous namespace

bool X86CallLowering::lowerReturn(MachineIRBuilder &MIRBuilder,
                                  const Value *Val, ArrayRef<Register> VRegs,
                                  FunctionLoweringInfo &FLI) const {
  assert(((Val && !VRegs.empty()) || (!Val && VRegs.empty())) &&
         "Return value without a vreg");
  auto MIB = MIRBuilder.buildInstrNoInsert(X86::RET).addImm(0);

  if (!VRegs.empty()) {
    MachineFunction &MF = MIRBuilder.getMF();
    const Function &F = MF.getFunction();
    MachineRegisterInfo &MRI = MF.getRegInfo();
    const DataLayout &DL = MF.getDataLayout();

    ArgInfo OrigRetInfo(VRegs, Val->getType());
    setArgFlags(OrigRetInfo, AttributeList::ReturnIndex, DL, F);

    SmallVector<ArgInfo, 4> SplitRetInfos;
    splitToValueTypes(OrigRetInfo, SplitRetInfos, DL, F.getCallingConv());

    X86OutgoingValueHandler Handler(MIRBuilder, MRI, MIB, RetCC_X86);
    if (!handleAssignments(MIRBuilder, SplitRetInfos, Handler, F.getCallingConv(),
                           F.isVarArg()))
      return false;
  }

  MIRBuilder.insertInstr(MIB);
  return true;
}

namespace {

struct X86IncomingValueHandler : public CallLowering::IncomingValueHandler {
  X86IncomingValueHandler(MachineIRBuilder &MIRBuilder,
                          MachineRegisterInfo &MRI, CCAssignFn *AssignFn)
      : IncomingValueHandler(MIRBuilder, MRI, AssignFn),
        DL(MIRBuilder.getMF().getDataLayout()) {}

  Register getStackAddress(uint64_t Size, int64_t Offset,
                           MachinePointerInfo &MPO,
                           ISD::ArgFlagsTy Flags) override {
    auto &MFI = MIRBuilder.getMF().getFrameInfo();

    // Byval is assumed to be writable memory, but other stack passed arguments
    // are not.
    const bool IsImmutable = !Flags.isByVal();

    int FI = MFI.CreateFixedObject(Size, Offset, IsImmutable);
    MPO = MachinePointerInfo::getFixedStack(MIRBuilder.getMF(), FI);

    return MIRBuilder
        .buildFrameIndex(LLT::pointer(0, DL.getPointerSizeInBits(0)), FI)
        .getReg(0);
  }

  void assignValueToAddress(Register ValVReg, Register Addr, uint64_t Size,
                            MachinePointerInfo &MPO, CCValAssign &VA) override {
    MachineFunction &MF = MIRBuilder.getMF();
    auto *MMO = MF.getMachineMemOperand(
        MPO, MachineMemOperand::MOLoad | MachineMemOperand::MOInvariant, Size,
        inferAlignFromPtrInfo(MF, MPO));
    MIRBuilder.buildLoad(ValVReg, Addr, *MMO);
  }

  void assignValueToReg(Register ValVReg, Register PhysReg,
                        CCValAssign &VA) override {
    markPhysRegUsed(PhysReg);
    IncomingValueHandler::assignValueToReg(ValVReg, PhysReg, VA);
  }

  /// How the physical register gets marked varies between formal
  /// parameters (it's a basic-block live-in), and a call instruction
  /// (it's an implicit-def of the BL).
  virtual void markPhysRegUsed(unsigned PhysReg) = 0;

protected:
  const DataLayout &DL;
};

struct FormalArgHandler : public X86IncomingValueHandler {
  FormalArgHandler(MachineIRBuilder &MIRBuilder, MachineRegisterInfo &MRI,
                   CCAssignFn *AssignFn)
      : X86IncomingValueHandler(MIRBuilder, MRI, AssignFn) {}

  void markPhysRegUsed(unsigned PhysReg) override {
    MIRBuilder.getMRI()->addLiveIn(PhysReg);
    MIRBuilder.getMBB().addLiveIn(PhysReg);
  }
};

struct CallReturnHandler : public X86IncomingValueHandler {
  CallReturnHandler(MachineIRBuilder &MIRBuilder, MachineRegisterInfo &MRI,
                    CCAssignFn *AssignFn, MachineInstrBuilder &MIB)
      : X86IncomingValueHandler(MIRBuilder, MRI, AssignFn), MIB(MIB) {}

  void markPhysRegUsed(unsigned PhysReg) override {
    MIB.addDef(PhysReg, RegState::Implicit);
  }

protected:
  MachineInstrBuilder &MIB;
};

} // end anonymous namespace

bool X86CallLowering::lowerFormalArguments(MachineIRBuilder &MIRBuilder,
                                           const Function &F,
                                           ArrayRef<ArrayRef<Register>> VRegs,
                                           FunctionLoweringInfo &FLI) const {
  if (F.arg_empty())
    return true;

  // TODO: handle variadic function
  if (F.isVarArg())
    return false;

  MachineFunction &MF = MIRBuilder.getMF();
  MachineRegisterInfo &MRI = MF.getRegInfo();
  auto DL = MF.getDataLayout();

  SmallVector<ArgInfo, 8> SplitArgs;
  unsigned Idx = 0;
  for (const auto &Arg : F.args()) {
    // TODO: handle not simple cases.
    if (Arg.hasAttribute(Attribute::ByVal) ||
        Arg.hasAttribute(Attribute::InReg) ||
        Arg.hasAttribute(Attribute::StructRet) ||
        Arg.hasAttribute(Attribute::SwiftSelf) ||
        Arg.hasAttribute(Attribute::SwiftError) ||
        Arg.hasAttribute(Attribute::Nest) || VRegs[Idx].size() > 1)
      return false;

    ArgInfo OrigArg(VRegs[Idx], Arg.getType());
    setArgFlags(OrigArg, Idx + AttributeList::FirstArgIndex, DL, F);
    splitToValueTypes(OrigArg, SplitArgs, DL, F.getCallingConv());
    Idx++;
  }

  MachineBasicBlock &MBB = MIRBuilder.getMBB();
  if (!MBB.empty())
    MIRBuilder.setInstr(*MBB.begin());

  FormalArgHandler Handler(MIRBuilder, MRI, CC_X86);
  if (!handleAssignments(MIRBuilder, SplitArgs, Handler, F.getCallingConv(),
                         F.isVarArg()))
    return false;

  // Move back to the end of the basic block.
  MIRBuilder.setMBB(MBB);

  return true;
}

bool X86CallLowering::lowerCall(MachineIRBuilder &MIRBuilder,
                                CallLoweringInfo &Info) const {
  MachineFunction &MF = MIRBuilder.getMF();
  const Function &F = MF.getFunction();
  MachineRegisterInfo &MRI = MF.getRegInfo();
  const DataLayout &DL = F.getParent()->getDataLayout();
  const X86Subtarget &STI = MF.getSubtarget<X86Subtarget>();
  const TargetInstrInfo &TII = *STI.getInstrInfo();
  const X86RegisterInfo *TRI = STI.getRegisterInfo();

  // Handle only Linux C, X86_64_SysV calling conventions for now.
  if (!STI.isTargetLinux() || !(Info.CallConv == CallingConv::C ||
                                Info.CallConv == CallingConv::X86_64_SysV))
    return false;

  unsigned AdjStackDown = TII.getCallFrameSetupOpcode();
  auto CallSeqStart = MIRBuilder.buildInstr(AdjStackDown);

  // Create a temporarily-floating call instruction so we can add the implicit
  // uses of arg registers.
  bool Is64Bit = STI.is64Bit();
  unsigned CallOpc = Info.Callee.isReg()
                         ? (Is64Bit ? X86::CALL64r : X86::CALL32r)
                         : (Is64Bit ? X86::CALL64pcrel32 : X86::CALLpcrel32);

  auto MIB = MIRBuilder.buildInstrNoInsert(CallOpc)
                 .add(Info.Callee)
                 .addRegMask(TRI->getCallPreservedMask(MF, Info.CallConv));

  SmallVector<ArgInfo, 8> SplitArgs;
  for (const auto &OrigArg : Info.OrigArgs) {

    // TODO: handle not simple cases.
    if (OrigArg.Flags[0].isByVal())
      return false;

    if (OrigArg.Regs.size() > 1)
      return false;

    splitToValueTypes(OrigArg, SplitArgs, DL, Info.CallConv);
  }
  // Do the actual argument marshalling.
  X86OutgoingValueHandler Handler(MIRBuilder, MRI, MIB, CC_X86);
  if (!handleAssignments(MIRBuilder, SplitArgs, Handler, Info.CallConv,
                         Info.IsVarArg))
    return false;

  bool IsFixed = Info.OrigArgs.empty() ? true : Info.OrigArgs.back().IsFixed;
  if (STI.is64Bit() && !IsFixed && !STI.isCallingConvWin64(Info.CallConv)) {
    // From AMD64 ABI document:
    // For calls that may call functions that use varargs or stdargs
    // (prototype-less calls or calls to functions containing ellipsis (...) in
    // the declaration) %al is used as hidden argument to specify the number
    // of SSE registers used. The contents of %al do not need to match exactly
    // the number of registers, but must be an ubound on the number of SSE
    // registers used and is in the range 0 - 8 inclusive.

    MIRBuilder.buildInstr(X86::MOV8ri)
        .addDef(X86::AL)
        .addImm(Handler.getNumXmmRegs());
    MIB.addUse(X86::AL, RegState::Implicit);
  }

  // Now we can add the actual call instruction to the correct basic block.
  MIRBuilder.insertInstr(MIB);

  // If Callee is a reg, since it is used by a target specific
  // instruction, it must have a register class matching the
  // constraint of that instruction.
  if (Info.Callee.isReg())
    MIB->getOperand(0).setReg(constrainOperandRegClass(
        MF, *TRI, MRI, *MF.getSubtarget().getInstrInfo(),
        *MF.getSubtarget().getRegBankInfo(), *MIB, MIB->getDesc(), Info.Callee,
        0));

  // Finally we can copy the returned value back into its virtual-register. In
  // symmetry with the arguments, the physical register must be an
  // implicit-define of the call instruction.

  if (!Info.OrigRet.Ty->isVoidTy()) {
    if (Info.OrigRet.Regs.size() > 1)
      return false;

    SplitArgs.clear();
    SmallVector<Register, 8> NewRegs;

    splitToValueTypes(Info.OrigRet, SplitArgs, DL, Info.CallConv);

    CallReturnHandler Handler(MIRBuilder, MRI, RetCC_X86, MIB);
    if (!handleAssignments(MIRBuilder, SplitArgs, Handler, Info.CallConv,
                           Info.IsVarArg))
      return false;

    if (!NewRegs.empty())
      MIRBuilder.buildMerge(Info.OrigRet.Regs[0], NewRegs);
  }

  CallSeqStart.addImm(Handler.getStackSize())
      .addImm(0 /* see getFrameTotalSize */)
      .addImm(0 /* see getFrameAdjustment */);

  unsigned AdjStackUp = TII.getCallFrameDestroyOpcode();
  MIRBuilder.buildInstr(AdjStackUp)
      .addImm(Handler.getStackSize())
      .addImm(0 /* NumBytesForCalleeToPop */);

  return true;
}
