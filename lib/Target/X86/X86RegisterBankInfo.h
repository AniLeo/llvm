//===- X86RegisterBankInfo ---------------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file declares the targeting of the RegisterBankInfo class for X86.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_X86_X86REGISTERBANKINFO_H
#define LLVM_LIB_TARGET_X86_X86REGISTERBANKINFO_H

#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"

#define GET_REGBANK_DECLARATIONS
#include "X86GenRegisterBank.inc"

namespace llvm {

class LLT;

class X86GenRegisterBankInfo : public RegisterBankInfo {
protected:
#define GET_TARGET_REGBANK_CLASS
#include "X86GenRegisterBank.inc"
#define GET_TARGET_REGBANK_INFO_CLASS
#include "X86GenRegisterBankInfo.def"

  static RegisterBankInfo::PartialMapping PartMappings[];
  static RegisterBankInfo::ValueMapping ValMappings[];

  static PartialMappingIdx getPartialMappingIdx(const LLT &Ty, bool isFP);
  static const RegisterBankInfo::ValueMapping *
  getValueMapping(PartialMappingIdx Idx, unsigned NumOperands);
};

class TargetRegisterInfo;

/// This class provides the information for the target register banks.
class X86RegisterBankInfo final : public X86GenRegisterBankInfo {
private:
  /// Get an instruction mapping.
  /// \return An InstructionMappings with a statically allocated
  /// OperandsMapping.
  const InstructionMapping &getSameOperandsMapping(const MachineInstr &MI,
                                                   bool isFP) const;

  /// Track the bank of each instruction operand(register)
  static void
  getInstrPartialMappingIdxs(const MachineInstr &MI,
                             const MachineRegisterInfo &MRI, const bool isFP,
                             SmallVectorImpl<PartialMappingIdx> &OpRegBankIdx);

  /// Construct the instruction ValueMapping from PartialMappingIdxs
  /// \return true if mapping succeeded.
  static bool
  getInstrValueMapping(const MachineInstr &MI,
                       const SmallVectorImpl<PartialMappingIdx> &OpRegBankIdx,
                       SmallVectorImpl<const ValueMapping *> &OpdsMapping);

public:
  X86RegisterBankInfo(const TargetRegisterInfo &TRI);

  const RegisterBank &getRegBankFromRegClass(const TargetRegisterClass &RC,
                                             LLT) const override;

  InstructionMappings
  getInstrAlternativeMappings(const MachineInstr &MI) const override;

  /// See RegisterBankInfo::applyMapping.
  void applyMappingImpl(const OperandsMapper &OpdMapper) const override;

  const InstructionMapping &
  getInstrMapping(const MachineInstr &MI) const override;
};

} // namespace llvm
#endif
