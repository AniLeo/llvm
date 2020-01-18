//===- AMDGPURegisterBankInfo -----------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file declares the targeting of the RegisterBankInfo class for AMDGPU.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPU_AMDGPUREGISTERBANKINFO_H
#define LLVM_LIB_TARGET_AMDGPU_AMDGPUREGISTERBANKINFO_H

#include "llvm/ADT/SmallSet.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/Register.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"

#define GET_REGBANK_DECLARATIONS
#include "AMDGPUGenRegisterBank.inc"
#undef GET_REGBANK_DECLARATIONS

namespace llvm {

class LLT;
class GCNSubtarget;
class MachineIRBuilder;
class SIInstrInfo;
class SIRegisterInfo;
class TargetRegisterInfo;

/// This class provides the information for the target register banks.
class AMDGPUGenRegisterBankInfo : public RegisterBankInfo {

protected:

#define GET_TARGET_REGBANK_CLASS
#include "AMDGPUGenRegisterBank.inc"
};
class AMDGPURegisterBankInfo : public AMDGPUGenRegisterBankInfo {
public:
  const GCNSubtarget &Subtarget;
  const SIRegisterInfo *TRI;
  const SIInstrInfo *TII;

  bool buildVCopy(MachineIRBuilder &B, Register DstReg, Register SrcReg) const;

  bool collectWaterfallOperands(
    SmallSet<Register, 4> &SGPROperandRegs,
    MachineInstr &MI,
    MachineRegisterInfo &MRI,
    ArrayRef<unsigned> OpIndices) const;

  bool executeInWaterfallLoop(
    MachineIRBuilder &B,
    iterator_range<MachineBasicBlock::iterator> Range,
    SmallSet<Register, 4> &SGPROperandRegs,
    MachineRegisterInfo &MRI) const;

  bool executeInWaterfallLoop(MachineIRBuilder &B,
                              MachineInstr &MI,
                              MachineRegisterInfo &MRI,
                              ArrayRef<unsigned> OpIndices) const;
  bool executeInWaterfallLoop(MachineInstr &MI,
                              MachineRegisterInfo &MRI,
                              ArrayRef<unsigned> OpIndices) const;

  void constrainOpWithReadfirstlane(MachineInstr &MI, MachineRegisterInfo &MRI,
                                    unsigned OpIdx) const;
  bool applyMappingWideLoad(MachineInstr &MI,
                            const AMDGPURegisterBankInfo::OperandsMapper &OpdMapper,
                            MachineRegisterInfo &MRI) const;
  bool
  applyMappingImage(MachineInstr &MI,
                    const AMDGPURegisterBankInfo::OperandsMapper &OpdMapper,
                    MachineRegisterInfo &MRI, int RSrcIdx) const;

  void lowerScalarMinMax(MachineIRBuilder &B, MachineInstr &MI) const;

  Register handleD16VData(MachineIRBuilder &B, MachineRegisterInfo &MRI,
                          Register Reg) const;

  std::pair<Register, unsigned>
  splitBufferOffsets(MachineIRBuilder &B, Register Offset) const;

  MachineInstr *selectStoreIntrinsic(MachineIRBuilder &B,
                                     MachineInstr &MI) const;

  /// See RegisterBankInfo::applyMapping.
  void applyMappingImpl(const OperandsMapper &OpdMapper) const override;

  const ValueMapping *getValueMappingForPtr(const MachineRegisterInfo &MRI,
                                            Register Ptr) const;

  const RegisterBankInfo::InstructionMapping &
  getInstrMappingForLoad(const MachineInstr &MI) const;

  unsigned getRegBankID(Register Reg, const MachineRegisterInfo &MRI,
                        const TargetRegisterInfo &TRI,
                        unsigned Default = AMDGPU::VGPRRegBankID) const;

  // Return a value mapping for an operand that is required to be an SGPR.
  const ValueMapping *getSGPROpMapping(Register Reg,
                                       const MachineRegisterInfo &MRI,
                                       const TargetRegisterInfo &TRI) const;

  // Return a value mapping for an operand that is required to be a VGPR.
  const ValueMapping *getVGPROpMapping(Register Reg,
                                       const MachineRegisterInfo &MRI,
                                       const TargetRegisterInfo &TRI) const;

  // Return a value mapping for an operand that is required to be a AGPR.
  const ValueMapping *getAGPROpMapping(Register Reg,
                                       const MachineRegisterInfo &MRI,
                                       const TargetRegisterInfo &TRI) const;

  /// Split 64-bit value \p Reg into two 32-bit halves and populate them into \p
  /// Regs. This appropriately sets the regbank of the new registers.
  void split64BitValueForMapping(MachineIRBuilder &B,
                                 SmallVector<Register, 2> &Regs,
                                 LLT HalfTy,
                                 Register Reg) const;

  template <unsigned NumOps>
  struct OpRegBankEntry {
    int8_t RegBanks[NumOps];
    int16_t Cost;
  };

  template <unsigned NumOps>
  InstructionMappings
  addMappingFromTable(const MachineInstr &MI, const MachineRegisterInfo &MRI,
                      const std::array<unsigned, NumOps> RegSrcOpIdx,
                      ArrayRef<OpRegBankEntry<NumOps>> Table) const;

  RegisterBankInfo::InstructionMappings
  getInstrAlternativeMappingsIntrinsic(
      const MachineInstr &MI, const MachineRegisterInfo &MRI) const;

  RegisterBankInfo::InstructionMappings
  getInstrAlternativeMappingsIntrinsicWSideEffects(
      const MachineInstr &MI, const MachineRegisterInfo &MRI) const;

  bool isSALUMapping(const MachineInstr &MI) const;

  const InstructionMapping &getDefaultMappingSOP(const MachineInstr &MI) const;
  const InstructionMapping &getDefaultMappingVOP(const MachineInstr &MI) const;
  const InstructionMapping &getDefaultMappingAllVGPR(
    const MachineInstr &MI) const;

  const InstructionMapping &getImageMapping(const MachineRegisterInfo &MRI,
                                            const MachineInstr &MI,
                                            int RsrcIdx) const;

public:
  AMDGPURegisterBankInfo(const GCNSubtarget &STI);

  unsigned copyCost(const RegisterBank &A, const RegisterBank &B,
                    unsigned Size) const override;

  unsigned getBreakDownCost(const ValueMapping &ValMapping,
                            const RegisterBank *CurBank = nullptr) const override;

  const RegisterBank &getRegBankFromRegClass(const TargetRegisterClass &RC,
                                             LLT) const override;

  InstructionMappings
  getInstrAlternativeMappings(const MachineInstr &MI) const override;

  const InstructionMapping &
  getInstrMapping(const MachineInstr &MI) const override;
};
} // End llvm namespace.
#endif
