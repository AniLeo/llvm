//===- MipsRegisterBankInfo.cpp ---------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for Mips.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "MipsInstrInfo.h"
#include "MipsRegisterBankInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

#define GET_TARGET_REGBANK_IMPL

#define DEBUG_TYPE "registerbankinfo"

#include "MipsGenRegisterBank.inc"

namespace llvm {
namespace Mips {
enum PartialMappingIdx {
  PMI_GPR,
  PMI_Min = PMI_GPR,
};

RegisterBankInfo::PartialMapping PartMappings[]{
    {0, 32, GPRBRegBank}
};

enum ValueMappingIdx { InvalidIdx = 0, GPRIdx = 1 };

RegisterBankInfo::ValueMapping ValueMappings[] = {
    // invalid
    {nullptr, 0},
    // 3 operands in GPRs
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1}};

} // end namespace Mips
} // end namespace llvm

using namespace llvm;

MipsRegisterBankInfo::MipsRegisterBankInfo(const TargetRegisterInfo &TRI)
    : MipsGenRegisterBankInfo() {}

const RegisterBank &MipsRegisterBankInfo::getRegBankFromRegClass(
    const TargetRegisterClass &RC) const {
  using namespace Mips;

  switch (RC.getID()) {
  case Mips::GPR32RegClassID:
  case Mips::CPU16Regs_and_GPRMM16ZeroRegClassID:
  case Mips::GPRMM16MovePPairFirstRegClassID:
  case Mips::CPU16Regs_and_GPRMM16MovePPairSecondRegClassID:
  case Mips::GPRMM16MoveP_and_CPU16Regs_and_GPRMM16ZeroRegClassID:
  case Mips::GPRMM16MovePPairFirst_and_GPRMM16MovePPairSecondRegClassID:
  case Mips::SP32RegClassID:
    return getRegBank(Mips::GPRBRegBankID);
  default:
    llvm_unreachable("Register class not supported");
  }
}

const RegisterBankInfo::InstructionMapping &
MipsRegisterBankInfo::getInstrMapping(const MachineInstr &MI) const {

  unsigned Opc = MI.getOpcode();

  const RegisterBankInfo::InstructionMapping &Mapping = getInstrMappingImpl(MI);
  if (Mapping.isValid())
    return Mapping;

  using namespace TargetOpcode;

  unsigned NumOperands = MI.getNumOperands();
  const ValueMapping *OperandsMapping = &Mips::ValueMappings[Mips::GPRIdx];

  switch (Opc) {
  case G_ADD:
  case G_LOAD:
  case G_STORE:
  case G_GEP:
  case G_AND:
  case G_OR:
  case G_XOR:
  case G_SHL:
  case G_ASHR:
  case G_LSHR:
    OperandsMapping = &Mips::ValueMappings[Mips::GPRIdx];
    break;
  case G_CONSTANT:
  case G_FRAME_INDEX:
  case G_GLOBAL_VALUE:
    OperandsMapping =
        getOperandsMapping({&Mips::ValueMappings[Mips::GPRIdx], nullptr});
    break;
  case G_ICMP:
    OperandsMapping =
        getOperandsMapping({&Mips::ValueMappings[Mips::GPRIdx], nullptr,
                            &Mips::ValueMappings[Mips::GPRIdx],
                            &Mips::ValueMappings[Mips::GPRIdx]});
    break;
  default:
    return getInvalidInstructionMapping();
  }

  return getInstructionMapping(DefaultMappingID, /*Cost=*/1, OperandsMapping,
                               NumOperands);
}
