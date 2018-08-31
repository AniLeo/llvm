//===- X86RegisterBankInfo.cpp -----------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for X86.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "X86RegisterBankInfo.h"
#include "X86InstrInfo.h"
#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"

#define GET_TARGET_REGBANK_IMPL
#include "X86GenRegisterBank.inc"

using namespace llvm;
// This file will be TableGen'ed at some point.
#define GET_TARGET_REGBANK_INFO_IMPL
#include "X86GenRegisterBankInfo.def"

X86RegisterBankInfo::X86RegisterBankInfo(const TargetRegisterInfo &TRI)
    : X86GenRegisterBankInfo() {

  // validate RegBank initialization.
  const RegisterBank &RBGPR = getRegBank(X86::GPRRegBankID);
  (void)RBGPR;
  assert(&X86::GPRRegBank == &RBGPR && "Incorrect RegBanks inizalization.");

  // The GPR register bank is fully defined by all the registers in
  // GR64 + its subclasses.
  assert(RBGPR.covers(*TRI.getRegClass(X86::GR64RegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.getSize() == 64 && "GPRs should hold up to 64-bit");
}

const RegisterBank &X86RegisterBankInfo::getRegBankFromRegClass(
    const TargetRegisterClass &RC) const {

  if (X86::GR8RegClass.hasSubClassEq(&RC) ||
      X86::GR16RegClass.hasSubClassEq(&RC) ||
      X86::GR32RegClass.hasSubClassEq(&RC) ||
      X86::GR64RegClass.hasSubClassEq(&RC))
    return getRegBank(X86::GPRRegBankID);

  if (X86::FR32XRegClass.hasSubClassEq(&RC) ||
      X86::FR64XRegClass.hasSubClassEq(&RC) ||
      X86::VR128XRegClass.hasSubClassEq(&RC) ||
      X86::VR256XRegClass.hasSubClassEq(&RC) ||
      X86::VR512RegClass.hasSubClassEq(&RC))
    return getRegBank(X86::VECRRegBankID);

  llvm_unreachable("Unsupported register kind yet.");
}

X86GenRegisterBankInfo::PartialMappingIdx
X86GenRegisterBankInfo::getPartialMappingIdx(const LLT &Ty, bool isFP) {
  if ((Ty.isScalar() && !isFP) || Ty.isPointer()) {
    switch (Ty.getSizeInBits()) {
    case 1:
    case 8:
      return PMI_GPR8;
    case 16:
      return PMI_GPR16;
    case 32:
      return PMI_GPR32;
    case 64:
      return PMI_GPR64;
    case 128:
      return PMI_VEC128;
      break;
    default:
      llvm_unreachable("Unsupported register size.");
    }
  } else if (Ty.isScalar()) {
    switch (Ty.getSizeInBits()) {
    case 32:
      return PMI_FP32;
    case 64:
      return PMI_FP64;
    case 128:
      return PMI_VEC128;
    default:
      llvm_unreachable("Unsupported register size.");
    }
  } else {
    switch (Ty.getSizeInBits()) {
    case 128:
      return PMI_VEC128;
    case 256:
      return PMI_VEC256;
    case 512:
      return PMI_VEC512;
    default:
      llvm_unreachable("Unsupported register size.");
    }
  }

  return PMI_None;
}

void X86RegisterBankInfo::getInstrPartialMappingIdxs(
    const MachineInstr &MI, const MachineRegisterInfo &MRI, const bool isFP,
    SmallVectorImpl<PartialMappingIdx> &OpRegBankIdx) {

  unsigned NumOperands = MI.getNumOperands();
  for (unsigned Idx = 0; Idx < NumOperands; ++Idx) {
    auto &MO = MI.getOperand(Idx);
    if (!MO.isReg())
      OpRegBankIdx[Idx] = PMI_None;
    else
      OpRegBankIdx[Idx] = getPartialMappingIdx(MRI.getType(MO.getReg()), isFP);
  }
}

bool X86RegisterBankInfo::getInstrValueMapping(
    const MachineInstr &MI,
    const SmallVectorImpl<PartialMappingIdx> &OpRegBankIdx,
    SmallVectorImpl<const ValueMapping *> &OpdsMapping) {

  unsigned NumOperands = MI.getNumOperands();
  for (unsigned Idx = 0; Idx < NumOperands; ++Idx) {
    if (!MI.getOperand(Idx).isReg())
      continue;

    auto Mapping = getValueMapping(OpRegBankIdx[Idx], 1);
    if (!Mapping->isValid())
      return false;

    OpdsMapping[Idx] = Mapping;
  }
  return true;
}

const RegisterBankInfo::InstructionMapping &
X86RegisterBankInfo::getSameOperandsMapping(const MachineInstr &MI,
                                            bool isFP) const {
  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineRegisterInfo &MRI = MF.getRegInfo();

  unsigned NumOperands = MI.getNumOperands();
  LLT Ty = MRI.getType(MI.getOperand(0).getReg());

  if (NumOperands != 3 || (Ty != MRI.getType(MI.getOperand(1).getReg())) ||
      (Ty != MRI.getType(MI.getOperand(2).getReg())))
    llvm_unreachable("Unsupported operand mapping yet.");

  auto Mapping = getValueMapping(getPartialMappingIdx(Ty, isFP), 3);
  return getInstructionMapping(DefaultMappingID, 1, Mapping, NumOperands);
}

const RegisterBankInfo::InstructionMapping &
X86RegisterBankInfo::getInstrMapping(const MachineInstr &MI) const {
  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineRegisterInfo &MRI = MF.getRegInfo();
  auto Opc = MI.getOpcode();

  // Try the default logic for non-generic instructions that are either copies
  // or already have some operands assigned to banks.
  if (!isPreISelGenericOpcode(Opc) || Opc == TargetOpcode::G_PHI) {
    const InstructionMapping &Mapping = getInstrMappingImpl(MI);
    if (Mapping.isValid())
      return Mapping;
  }

  switch (Opc) {
  case TargetOpcode::G_ADD:
  case TargetOpcode::G_SUB:
  case TargetOpcode::G_MUL:
  case TargetOpcode::G_SHL:
  case TargetOpcode::G_LSHR:
  case TargetOpcode::G_ASHR:
    return getSameOperandsMapping(MI, false);
    break;
  case TargetOpcode::G_FADD:
  case TargetOpcode::G_FSUB:
  case TargetOpcode::G_FMUL:
  case TargetOpcode::G_FDIV:
    return getSameOperandsMapping(MI, true);
    break;
  default:
    break;
  }

  unsigned NumOperands = MI.getNumOperands();
  SmallVector<PartialMappingIdx, 4> OpRegBankIdx(NumOperands);

  switch (Opc) {
  case TargetOpcode::G_FPEXT:
  case TargetOpcode::G_FCONSTANT:
    // Instruction having only floating-point operands (all scalars in VECRReg)
    getInstrPartialMappingIdxs(MI, MRI, /* isFP */ true, OpRegBankIdx);
    break;
  case TargetOpcode::G_SITOFP: {
    // Some of the floating-point instructions have mixed GPR and FP operands:
    // fine-tune the computed mapping.
    auto &Op0 = MI.getOperand(0);
    auto &Op1 = MI.getOperand(1);
    const LLT Ty0 = MRI.getType(Op0.getReg());
    const LLT Ty1 = MRI.getType(Op1.getReg());
    OpRegBankIdx[0] = getPartialMappingIdx(Ty0, /* isFP */ true);
    OpRegBankIdx[1] = getPartialMappingIdx(Ty1, /* isFP */ false);
    break;
  }
  case TargetOpcode::G_FCMP: {
    LLT Ty1 = MRI.getType(MI.getOperand(2).getReg());
    LLT Ty2 = MRI.getType(MI.getOperand(3).getReg());
    (void)Ty2;
    assert(Ty1.getSizeInBits() == Ty2.getSizeInBits() &&
           "Mismatched operand sizes for G_FCMP");

    unsigned Size = Ty1.getSizeInBits();
    (void)Size;
    assert((Size == 32 || Size == 64) && "Unsupported size for G_FCMP");

    auto FpRegBank = getPartialMappingIdx(Ty1, /* isFP */ true);
    OpRegBankIdx = {PMI_GPR8,
                    /* Predicate */ PMI_None, FpRegBank, FpRegBank};
    break;
  }
  case TargetOpcode::G_TRUNC:
  case TargetOpcode::G_ANYEXT: {
    auto &Op0 = MI.getOperand(0);
    auto &Op1 = MI.getOperand(1);
    const LLT Ty0 = MRI.getType(Op0.getReg());
    const LLT Ty1 = MRI.getType(Op1.getReg());

    bool isFPTrunc = (Ty0.getSizeInBits() == 32 || Ty0.getSizeInBits() == 64) &&
                     Ty1.getSizeInBits() == 128 && Opc == TargetOpcode::G_TRUNC;
    bool isFPAnyExt =
        Ty0.getSizeInBits() == 128 &&
        (Ty1.getSizeInBits() == 32 || Ty1.getSizeInBits() == 64) &&
        Opc == TargetOpcode::G_ANYEXT;

    getInstrPartialMappingIdxs(MI, MRI, /* isFP */ isFPTrunc || isFPAnyExt,
                               OpRegBankIdx);
  } break;
  default:
    // Track the bank of each register, use NotFP mapping (all scalars in GPRs)
    getInstrPartialMappingIdxs(MI, MRI, /* isFP */ false, OpRegBankIdx);
    break;
  }

  // Finally construct the computed mapping.
  SmallVector<const ValueMapping *, 8> OpdsMapping(NumOperands);
  if (!getInstrValueMapping(MI, OpRegBankIdx, OpdsMapping))
    return getInvalidInstructionMapping();

  return getInstructionMapping(DefaultMappingID, /* Cost */ 1,
                               getOperandsMapping(OpdsMapping), NumOperands);
}

void X86RegisterBankInfo::applyMappingImpl(
    const OperandsMapper &OpdMapper) const {
  return applyDefaultMapping(OpdMapper);
}

RegisterBankInfo::InstructionMappings
X86RegisterBankInfo::getInstrAlternativeMappings(const MachineInstr &MI) const {

  const MachineFunction &MF = *MI.getParent()->getParent();
  const TargetSubtargetInfo &STI = MF.getSubtarget();
  const TargetRegisterInfo &TRI = *STI.getRegisterInfo();
  const MachineRegisterInfo &MRI = MF.getRegInfo();

  switch (MI.getOpcode()) {
  case TargetOpcode::G_LOAD:
  case TargetOpcode::G_STORE:
  case TargetOpcode::G_IMPLICIT_DEF: {
    // we going to try to map 32/64 bit to PMI_FP32/PMI_FP64
    unsigned Size = getSizeInBits(MI.getOperand(0).getReg(), MRI, TRI);
    if (Size != 32 && Size != 64)
      break;

    unsigned NumOperands = MI.getNumOperands();

    // Track the bank of each register, use FP mapping (all scalars in VEC)
    SmallVector<PartialMappingIdx, 4> OpRegBankIdx(NumOperands);
    getInstrPartialMappingIdxs(MI, MRI, /* isFP */ true, OpRegBankIdx);

    // Finally construct the computed mapping.
    SmallVector<const ValueMapping *, 8> OpdsMapping(NumOperands);
    if (!getInstrValueMapping(MI, OpRegBankIdx, OpdsMapping))
      break;

    const RegisterBankInfo::InstructionMapping &Mapping = getInstructionMapping(
        /*ID*/ 1, /*Cost*/ 1, getOperandsMapping(OpdsMapping), NumOperands);
    InstructionMappings AltMappings;
    AltMappings.push_back(&Mapping);
    return AltMappings;
  }
  default:
    break;
  }
  return RegisterBankInfo::getInstrAlternativeMappings(MI);
}
