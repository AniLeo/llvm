//===- ARMRegisterBankInfo ---------------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file declares the targeting of the RegisterBankInfo class for ARM.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_ARM_ARMREGISTERBANKINFO_H
#define LLVM_LIB_TARGET_ARM_ARMREGISTERBANKINFO_H

#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"

#define GET_REGBANK_DECLARATIONS
#include "ARMGenRegisterBank.inc"

namespace llvm {

class TargetRegisterInfo;

class ARMGenRegisterBankInfo : public RegisterBankInfo {
#define GET_TARGET_REGBANK_CLASS
#include "ARMGenRegisterBank.inc"
};

/// This class provides the information for the target register banks.
class ARMRegisterBankInfo final : public ARMGenRegisterBankInfo {
public:
  ARMRegisterBankInfo(const TargetRegisterInfo &TRI);

  const RegisterBank &
  getRegBankFromRegClass(const TargetRegisterClass &RC) const override;

  const InstructionMapping &
  getInstrMapping(const MachineInstr &MI) const override;
};
} // End llvm namespace.
#endif
