//===- AArch64RegisterBankInfo.cpp -------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for
/// AArch64.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "AArch64RegisterBankInfo.h"
#include "AArch64InstrInfo.h" // For XXXRegClassID.
#include "llvm/CodeGen/LowLevelType.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/Target/TargetRegisterInfo.h"
#include "llvm/Target/TargetSubtargetInfo.h"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

AArch64RegisterBankInfo::AArch64RegisterBankInfo(const TargetRegisterInfo &TRI)
    : RegisterBankInfo(AArch64::NumRegisterBanks) {
  // Initialize the GPR bank.
  createRegisterBank(AArch64::GPRRegBankID, "GPR");
  // The GPR register bank is fully defined by all the registers in
  // GR64all + its subclasses.
  addRegBankCoverage(AArch64::GPRRegBankID, AArch64::GPR64allRegClassID, TRI);
  const RegisterBank &RBGPR = getRegBank(AArch64::GPRRegBankID);
  (void)RBGPR;
  assert(RBGPR.covers(*TRI.getRegClass(AArch64::GPR32RegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.getSize() == 64 && "GPRs should hold up to 64-bit");

  // Initialize the FPR bank.
  createRegisterBank(AArch64::FPRRegBankID, "FPR");
  // The FPR register bank is fully defined by all the registers in
  // GR64all + its subclasses.
  addRegBankCoverage(AArch64::FPRRegBankID, AArch64::QQQQRegClassID, TRI);
  const RegisterBank &RBFPR = getRegBank(AArch64::FPRRegBankID);
  (void)RBFPR;
  assert(RBFPR.covers(*TRI.getRegClass(AArch64::QQRegClassID)) &&
         "Subclass not added?");
  assert(RBFPR.covers(*TRI.getRegClass(AArch64::FPR64RegClassID)) &&
         "Subclass not added?");
  assert(RBFPR.getSize() == 512 &&
         "FPRs should hold up to 512-bit via QQQQ sequence");

  // Initialize the CCR bank.
  createRegisterBank(AArch64::CCRRegBankID, "CCR");
  addRegBankCoverage(AArch64::CCRRegBankID, AArch64::CCRRegClassID, TRI);
  const RegisterBank &RBCCR = getRegBank(AArch64::CCRRegBankID);
  (void)RBCCR;
  assert(RBCCR.covers(*TRI.getRegClass(AArch64::CCRRegClassID)) &&
         "Class not added?");
  assert(RBCCR.getSize() == 32 && "CCR should hold up to 32-bit");

  assert(verify(TRI) && "Invalid register bank information");
}

unsigned AArch64RegisterBankInfo::copyCost(const RegisterBank &A,
                                           const RegisterBank &B,
                                           unsigned Size) const {
  // What do we do with different size?
  // copy are same size.
  // Will introduce other hooks for different size:
  // * extract cost.
  // * build_sequence cost.
  // TODO: Add more accurate cost for FPR to/from GPR.
  return RegisterBankInfo::copyCost(A, B, Size);
}

const RegisterBank &AArch64RegisterBankInfo::getRegBankFromRegClass(
    const TargetRegisterClass &RC) const {
  switch (RC.getID()) {
  case AArch64::FPR8RegClassID:
  case AArch64::FPR16RegClassID:
  case AArch64::FPR32RegClassID:
  case AArch64::FPR64RegClassID:
  case AArch64::FPR128RegClassID:
  case AArch64::FPR128_loRegClassID:
  case AArch64::DDRegClassID:
  case AArch64::DDDRegClassID:
  case AArch64::DDDDRegClassID:
  case AArch64::QQRegClassID:
  case AArch64::QQQRegClassID:
  case AArch64::QQQQRegClassID:
    return getRegBank(AArch64::FPRRegBankID);
  case AArch64::GPR32commonRegClassID:
  case AArch64::GPR32RegClassID:
  case AArch64::GPR32spRegClassID:
  case AArch64::GPR32sponlyRegClassID:
  case AArch64::GPR32allRegClassID:
  case AArch64::GPR64commonRegClassID:
  case AArch64::GPR64RegClassID:
  case AArch64::GPR64spRegClassID:
  case AArch64::GPR64sponlyRegClassID:
  case AArch64::GPR64allRegClassID:
  case AArch64::tcGPR64RegClassID:
  case AArch64::WSeqPairsClassRegClassID:
  case AArch64::XSeqPairsClassRegClassID:
    return getRegBank(AArch64::GPRRegBankID);
  case AArch64::CCRRegClassID:
    return getRegBank(AArch64::CCRRegBankID);
  default:
    llvm_unreachable("Register class not supported");
  }
}

RegisterBankInfo::InstructionMappings
AArch64RegisterBankInfo::getInstrAlternativeMappings(
    const MachineInstr &MI) const {
  switch (MI.getOpcode()) {
  case TargetOpcode::G_OR: {
    // 32 and 64-bit or can be mapped on either FPR or
    // GPR for the same cost.
    const MachineFunction &MF = *MI.getParent()->getParent();
    const TargetSubtargetInfo &STI = MF.getSubtarget();
    const TargetRegisterInfo &TRI = *STI.getRegisterInfo();
    const MachineRegisterInfo &MRI = MF.getRegInfo();

    unsigned Size = getSizeInBits(MI.getOperand(0).getReg(), MRI, TRI);
    if (Size != 32 && Size != 64)
      break;

    // If the instruction has any implicit-defs or uses,
    // do not mess with it.
    if (MI.getNumOperands() != 3)
      break;
    InstructionMappings AltMappings;
    InstructionMapping GPRMapping(/*ID*/ 1, /*Cost*/ 1, /*NumOperands*/ 3);
    InstructionMapping FPRMapping(/*ID*/ 2, /*Cost*/ 1, /*NumOperands*/ 3);
    for (unsigned Idx = 0; Idx != 3; ++Idx) {
      GPRMapping.setOperandMapping(Idx, Size,
                                   getRegBank(AArch64::GPRRegBankID));
      FPRMapping.setOperandMapping(Idx, Size,
                                   getRegBank(AArch64::FPRRegBankID));
    }
    AltMappings.emplace_back(std::move(GPRMapping));
    AltMappings.emplace_back(std::move(FPRMapping));
    return AltMappings;
  }
  default:
    break;
  }
  return RegisterBankInfo::getInstrAlternativeMappings(MI);
}

void AArch64RegisterBankInfo::applyMappingImpl(
    const OperandsMapper &OpdMapper) const {
  switch (OpdMapper.getMI().getOpcode()) {
  case TargetOpcode::G_ADD:
  case TargetOpcode::G_OR: {
    // Those ID must match getInstrAlternativeMappings.
    assert((OpdMapper.getInstrMapping().getID() == 1 ||
            OpdMapper.getInstrMapping().getID() == 2) &&
           "Don't know how to handle that ID");
    return applyDefaultMapping(OpdMapper);
  }
  default:
    llvm_unreachable("Don't know how to handle that operation");
  }
}

RegisterBankInfo::InstructionMapping
AArch64RegisterBankInfo::getInstrMapping(const MachineInstr &MI) const {
  RegisterBankInfo::InstructionMapping Mapping = getInstrMappingImpl(MI);
  if (Mapping.isValid())
    return Mapping;

  // As a top-level guess, vectors go in FPRs, scalars in GPRs. Obviously this
  // won't work for normal floating-point types (or NZCV). When such
  // instructions exist we'll need to look at the MI's opcode.
  auto &MRI = MI.getParent()->getParent()->getRegInfo();
  LLT Ty = MRI.getType(MI.getOperand(0).getReg());
  unsigned BankID;
  if (Ty.isVector())
    BankID = AArch64::FPRRegBankID;
  else
    BankID = AArch64::GPRRegBankID;

  Mapping = InstructionMapping{1, 1, MI.getNumOperands()};
  int Size = Ty.isSized() ? Ty.getSizeInBits() : 0;
  for (unsigned Idx = 0; Idx < MI.getNumOperands(); ++Idx)
    Mapping.setOperandMapping(Idx, Size, getRegBank(BankID));

  return Mapping;
}
