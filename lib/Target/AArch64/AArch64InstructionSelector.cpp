//===- AArch64InstructionSelector.cpp ----------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for
/// AArch64.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "AArch64InstructionSelector.h"
#include "AArch64InstrInfo.h"
#include "AArch64RegisterBankInfo.h"
#include "AArch64RegisterInfo.h"
#include "AArch64Subtarget.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

#define DEBUG_TYPE "aarch64-isel"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

AArch64InstructionSelector::AArch64InstructionSelector(
    const AArch64Subtarget &STI, const AArch64RegisterBankInfo &RBI)
    : InstructionSelector(), TII(*STI.getInstrInfo()),
      TRI(*STI.getRegisterInfo()), RBI(RBI) {}

/// Check whether \p I is a currently unsupported binary operation:
/// - it has an unsized type
/// - an operand is not a vreg
/// - all operands are not in the same bank
/// These are checks that should someday live in the verifier, but right now,
/// these are mostly limitations of the aarch64 selector.
static bool unsupportedBinOp(const MachineInstr &I,
                             const AArch64RegisterBankInfo &RBI,
                             const MachineRegisterInfo &MRI,
                             const AArch64RegisterInfo &TRI) {
  LLT Ty = MRI.getType(I.getOperand(0).getReg());
  if (!Ty.isValid()) {
    DEBUG(dbgs() << "Generic binop register should be typed\n");
    return true;
  }

  const RegisterBank *PrevOpBank = nullptr;
  for (auto &MO : I.operands()) {
    // FIXME: Support non-register operands.
    if (!MO.isReg()) {
      DEBUG(dbgs() << "Generic inst non-reg operands are unsupported\n");
      return true;
    }

    // FIXME: Can generic operations have physical registers operands? If
    // so, this will need to be taught about that, and we'll need to get the
    // bank out of the minimal class for the register.
    // Either way, this needs to be documented (and possibly verified).
    if (!TargetRegisterInfo::isVirtualRegister(MO.getReg())) {
      DEBUG(dbgs() << "Generic inst has physical register operand\n");
      return true;
    }

    const RegisterBank *OpBank = RBI.getRegBank(MO.getReg(), MRI, TRI);
    if (!OpBank) {
      DEBUG(dbgs() << "Generic register has no bank or class\n");
      return true;
    }

    if (PrevOpBank && OpBank != PrevOpBank) {
      DEBUG(dbgs() << "Generic inst operands have different banks\n");
      return true;
    }
    PrevOpBank = OpBank;
  }
  return false;
}

/// Select the AArch64 opcode for the basic binary operation \p GenericOpc
/// (such as G_OR or G_ADD), appropriate for the register bank \p RegBankID
/// and of size \p OpSize.
/// \returns \p GenericOpc if the combination is unsupported.
static unsigned selectBinaryOp(unsigned GenericOpc, unsigned RegBankID,
                               unsigned OpSize) {
  switch (RegBankID) {
  case AArch64::GPRRegBankID:
    switch (OpSize) {
    case 32:
      switch (GenericOpc) {
      case TargetOpcode::G_OR:
        return AArch64::ORRWrr;
      case TargetOpcode::G_XOR:
        return AArch64::EORWrr;
      case TargetOpcode::G_AND:
        return AArch64::ANDWrr;
      case TargetOpcode::G_ADD:
        return AArch64::ADDWrr;
      case TargetOpcode::G_SUB:
        return AArch64::SUBWrr;
      case TargetOpcode::G_SHL:
        return AArch64::LSLVWr;
      case TargetOpcode::G_LSHR:
        return AArch64::LSRVWr;
      case TargetOpcode::G_ASHR:
        return AArch64::ASRVWr;
      case TargetOpcode::G_SDIV:
        return AArch64::SDIVWr;
      case TargetOpcode::G_UDIV:
        return AArch64::UDIVWr;
      default:
        return GenericOpc;
      }
    case 64:
      switch (GenericOpc) {
      case TargetOpcode::G_OR:
        return AArch64::ORRXrr;
      case TargetOpcode::G_XOR:
        return AArch64::EORXrr;
      case TargetOpcode::G_AND:
        return AArch64::ANDXrr;
      case TargetOpcode::G_ADD:
        return AArch64::ADDXrr;
      case TargetOpcode::G_SUB:
        return AArch64::SUBXrr;
      case TargetOpcode::G_SHL:
        return AArch64::LSLVXr;
      case TargetOpcode::G_LSHR:
        return AArch64::LSRVXr;
      case TargetOpcode::G_ASHR:
        return AArch64::ASRVXr;
      case TargetOpcode::G_SDIV:
        return AArch64::SDIVXr;
      case TargetOpcode::G_UDIV:
        return AArch64::UDIVXr;
      default:
        return GenericOpc;
      }
    }
  case AArch64::FPRRegBankID:
    switch (OpSize) {
    case 32:
      switch (GenericOpc) {
      case TargetOpcode::G_FADD:
        return AArch64::FADDSrr;
      case TargetOpcode::G_FSUB:
        return AArch64::FSUBSrr;
      case TargetOpcode::G_FMUL:
        return AArch64::FMULSrr;
      case TargetOpcode::G_FDIV:
        return AArch64::FDIVSrr;
      default:
        return GenericOpc;
      }
    case 64:
      switch (GenericOpc) {
      case TargetOpcode::G_FADD:
        return AArch64::FADDDrr;
      case TargetOpcode::G_FSUB:
        return AArch64::FSUBDrr;
      case TargetOpcode::G_FMUL:
        return AArch64::FMULDrr;
      case TargetOpcode::G_FDIV:
        return AArch64::FDIVDrr;
      default:
        return GenericOpc;
      }
    }
  };
  return GenericOpc;
}

/// Select the AArch64 opcode for the G_LOAD or G_STORE operation \p GenericOpc,
/// appropriate for the (value) register bank \p RegBankID and of memory access
/// size \p OpSize.  This returns the variant with the base+unsigned-immediate
/// addressing mode (e.g., LDRXui).
/// \returns \p GenericOpc if the combination is unsupported.
static unsigned selectLoadStoreUIOp(unsigned GenericOpc, unsigned RegBankID,
                                    unsigned OpSize) {
  const bool isStore = GenericOpc == TargetOpcode::G_STORE;
  switch (RegBankID) {
  case AArch64::GPRRegBankID:
    switch (OpSize) {
    case 32:
      return isStore ? AArch64::STRWui : AArch64::LDRWui;
    case 64:
      return isStore ? AArch64::STRXui : AArch64::LDRXui;
    }
  };
  return GenericOpc;
}

bool AArch64InstructionSelector::select(MachineInstr &I) const {
  assert(I.getParent() && "Instruction should be in a basic block!");
  assert(I.getParent()->getParent() && "Instruction should be in a function!");

  MachineBasicBlock &MBB = *I.getParent();
  MachineFunction &MF = *MBB.getParent();
  MachineRegisterInfo &MRI = MF.getRegInfo();

  // FIXME: Is there *really* nothing to be done here?  This assumes that
  // no upstream pass introduces things like generic vreg on copies or
  // target-specific instructions.
  // We should document (and verify) that assumption.
  if (!isPreISelGenericOpcode(I.getOpcode()))
    return true;

  if (I.getNumOperands() != I.getNumExplicitOperands()) {
    DEBUG(dbgs() << "Generic instruction has unexpected implicit operands\n");
    return false;
  }

  LLT Ty =
      I.getOperand(0).isReg() ? MRI.getType(I.getOperand(0).getReg()) : LLT{};

  switch (I.getOpcode()) {
  case TargetOpcode::G_BR: {
    I.setDesc(TII.get(AArch64::B));
    return true;
  }

  case TargetOpcode::G_FRAME_INDEX: {
    // allocas and G_FRAME_INDEX are only supported in addrspace(0).
    if (Ty != LLT::pointer(0, 64)) {
      DEBUG(dbgs() << "G_FRAME_INDEX pointer has type: " << Ty
            << ", expected: " << LLT::pointer(0, 64) << '\n');
      return false;
    }

    I.setDesc(TII.get(AArch64::ADDXri));

    // MOs for a #0 shifted immediate.
    I.addOperand(MachineOperand::CreateImm(0));
    I.addOperand(MachineOperand::CreateImm(0));

    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }
  case TargetOpcode::G_LOAD:
  case TargetOpcode::G_STORE: {
    LLT MemTy = Ty;
    LLT PtrTy = MRI.getType(I.getOperand(1).getReg());

    if (PtrTy != LLT::pointer(0, 64)) {
      DEBUG(dbgs() << "Load/Store pointer has type: " << PtrTy
                   << ", expected: " << LLT::pointer(0, 64) << '\n');
      return false;
    }

#ifndef NDEBUG
    // Sanity-check the pointer register.
    const unsigned PtrReg = I.getOperand(1).getReg();
    const RegisterBank &PtrRB = *RBI.getRegBank(PtrReg, MRI, TRI);
    assert(PtrRB.getID() == AArch64::GPRRegBankID &&
           "Load/Store pointer operand isn't a GPR");
    assert(MRI.getType(PtrReg).isPointer() &&
           "Load/Store pointer operand isn't a pointer");
#endif

    const unsigned ValReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(ValReg, MRI, TRI);

    const unsigned NewOpc =
        selectLoadStoreUIOp(I.getOpcode(), RB.getID(), MemTy.getSizeInBits());
    if (NewOpc == I.getOpcode())
      return false;

    I.setDesc(TII.get(NewOpc));

    I.addOperand(MachineOperand::CreateImm(0));
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  case TargetOpcode::G_MUL: {
    // Reject the various things we don't support yet.
    if (unsupportedBinOp(I, RBI, MRI, TRI))
      return false;

    const unsigned DefReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    if (RB.getID() != AArch64::GPRRegBankID) {
      DEBUG(dbgs() << "G_MUL on bank: " << RB << ", expected: GPR\n");
      return false;
    }

    unsigned ZeroReg;
    unsigned NewOpc;
    if (Ty == LLT::scalar(32)) {
      NewOpc = AArch64::MADDWrrr;
      ZeroReg = AArch64::WZR;
    } else if (Ty == LLT::scalar(64)) {
      NewOpc = AArch64::MADDXrrr;
      ZeroReg = AArch64::XZR;
    } else {
      DEBUG(dbgs() << "G_MUL has type: " << Ty << ", expected: "
                   << LLT::scalar(32) << " or " << LLT::scalar(64) << '\n');
      return false;
    }

    I.setDesc(TII.get(NewOpc));

    I.addOperand(MachineOperand::CreateReg(ZeroReg, /*isDef=*/false));

    // Now that we selected an opcode, we need to constrain the register
    // operands to use appropriate classes.
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  case TargetOpcode::G_FADD:
  case TargetOpcode::G_FSUB:
  case TargetOpcode::G_FMUL:
  case TargetOpcode::G_FDIV:

  case TargetOpcode::G_OR:
  case TargetOpcode::G_XOR:
  case TargetOpcode::G_AND:
  case TargetOpcode::G_SHL:
  case TargetOpcode::G_LSHR:
  case TargetOpcode::G_ASHR:
  case TargetOpcode::G_SDIV:
  case TargetOpcode::G_UDIV:
  case TargetOpcode::G_ADD:
  case TargetOpcode::G_SUB: {
    // Reject the various things we don't support yet.
    if (unsupportedBinOp(I, RBI, MRI, TRI))
      return false;

    const unsigned OpSize = Ty.getSizeInBits();

    const unsigned DefReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    const unsigned NewOpc = selectBinaryOp(I.getOpcode(), RB.getID(), OpSize);
    if (NewOpc == I.getOpcode())
      return false;

    I.setDesc(TII.get(NewOpc));
    // FIXME: Should the type be always reset in setDesc?

    // Now that we selected an opcode, we need to constrain the register
    // operands to use appropriate classes.
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }
  }

  return false;
}
