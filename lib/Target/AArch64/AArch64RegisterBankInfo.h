//===- AArch64RegisterBankInfo -----------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file declares the targeting of the RegisterBankInfo class for AArch64.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_AARCH64REGISTERBANKINFO_H
#define LLVM_LIB_TARGET_AARCH64_AARCH64REGISTERBANKINFO_H

#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"

namespace llvm {

class TargetRegisterInfo;

namespace AArch64 {
enum {
  GPRRegBankID = 0, /// General Purpose Registers: W, X.
  FPRRegBankID = 1, /// Floating Point/Vector Registers: B, H, S, D, Q.
  CCRRegBankID = 2, /// Conditional register: NZCV.
  NumRegisterBanks
};

extern RegisterBank GPRRegBank;
extern RegisterBank FPRRegBank;
extern RegisterBank CCRRegBank;
} // End AArch64 namespace.

/// This class provides the information for the target register banks.
class AArch64RegisterBankInfo final : public RegisterBankInfo {
  /// See RegisterBankInfo::applyMapping.
  void applyMappingImpl(const OperandsMapper &OpdMapper) const override;

  /// Get an instruction mapping where all the operands map to
  /// the same register bank and have similar size.
  ///
  /// \pre MI.getNumOperands() <= 3
  ///
  /// \return An InstructionMappings with a statically allocated
  /// OperandsMapping.
  static InstructionMapping
  getSameKindOfOperandsMapping(const MachineInstr &MI);

public:
  AArch64RegisterBankInfo(const TargetRegisterInfo &TRI);
  /// Get the cost of a copy from \p B to \p A, or put differently,
  /// get the cost of A = COPY B. Since register banks may cover
  /// different size, \p Size specifies what will be the size in bits
  /// that will be copied around.
  ///
  /// \note Since this is a copy, both registers have the same size.
  unsigned copyCost(const RegisterBank &A, const RegisterBank &B,
                    unsigned Size) const override;

  /// Get a register bank that covers \p RC.
  ///
  /// \pre \p RC is a user-defined register class (as opposed as one
  /// generated by TableGen).
  ///
  /// \note The mapping RC -> RegBank could be built while adding the
  /// coverage for the register banks. However, we do not do it, because,
  /// at least for now, we only need this information for register classes
  /// that are used in the description of instruction. In other words,
  /// there are just a handful of them and we do not want to waste space.
  ///
  /// \todo This should be TableGen'ed.
  const RegisterBank &
  getRegBankFromRegClass(const TargetRegisterClass &RC) const override;

  /// Get the alternative mappings for \p MI.
  /// Alternative in the sense different from getInstrMapping.
  InstructionMappings
  getInstrAlternativeMappings(const MachineInstr &MI) const override;

  InstructionMapping getInstrMapping(const MachineInstr &MI) const override;
};
} // End llvm namespace.
#endif
