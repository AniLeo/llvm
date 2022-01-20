//===-- RISCVSubtarget.h - Define Subtarget for the RISCV -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the RISCV specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_RISCV_RISCVSUBTARGET_H
#define LLVM_LIB_TARGET_RISCV_RISCVSUBTARGET_H

#include "MCTargetDesc/RISCVBaseInfo.h"
#include "RISCVFrameLowering.h"
#include "RISCVISelLowering.h"
#include "RISCVInstrInfo.h"
#include "llvm/CodeGen/GlobalISel/CallLowering.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/LegalizerInfo.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/CodeGen/SelectionDAGTargetInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetMachine.h"

#define GET_SUBTARGETINFO_HEADER
#include "RISCVGenSubtargetInfo.inc"

namespace llvm {
class StringRef;

class RISCVSubtarget : public RISCVGenSubtargetInfo {
public:
  enum ExtZvl : unsigned {
    NotSet = 0,
    Zvl32b = 32,
    Zvl64b = 64,
    Zvl128b = 128,
    Zvl256b = 256,
    Zvl512b = 512,
    Zvl1024b = 1024,
    Zvl2048b = 2048,
    Zvl4096b = 4096,
    Zvl8192b = 8192,
    Zvl16384b = 16384,
    Zvl32768b = 32768,
    Zvl65536b = 65536
  };

  enum RISCVProcFamilyEnum : uint8_t {
    Others,
    SiFive7,
  };

private:
  virtual void anchor();

  RISCVProcFamilyEnum RISCVProcFamily = Others;

  bool HasStdExtM = false;
  bool HasStdExtA = false;
  bool HasStdExtF = false;
  bool HasStdExtD = false;
  bool HasStdExtC = false;
  bool HasStdExtZba = false;
  bool HasStdExtZbb = false;
  bool HasStdExtZbc = false;
  bool HasStdExtZbe = false;
  bool HasStdExtZbf = false;
  bool HasStdExtZbm = false;
  bool HasStdExtZbp = false;
  bool HasStdExtZbr = false;
  bool HasStdExtZbs = false;
  bool HasStdExtZbt = false;
  bool HasStdExtV = false;
  bool HasStdExtZve32x = false;
  bool HasStdExtZve32f = false;
  bool HasStdExtZve64x = false;
  bool HasStdExtZve64f = false;
  bool HasStdExtZve64d = false;
  bool HasStdExtZfhmin = false;
  bool HasStdExtZfh = false;
  bool HasRV64 = false;
  bool IsRV32E = false;
  bool EnableLinkerRelax = false;
  bool EnableRVCHintInstrs = true;
  bool EnableSaveRestore = false;
  unsigned XLen = 32;
  ExtZvl ZvlLen = ExtZvl::NotSet;
  MVT XLenVT = MVT::i32;
  uint8_t MaxInterleaveFactor = 2;
  RISCVABI::ABI TargetABI = RISCVABI::ABI_Unknown;
  BitVector UserReservedRegister;
  RISCVFrameLowering FrameLowering;
  RISCVInstrInfo InstrInfo;
  RISCVRegisterInfo RegInfo;
  RISCVTargetLowering TLInfo;
  SelectionDAGTargetInfo TSInfo;

  /// Initializes using the passed in CPU and feature strings so that we can
  /// use initializer lists for subtarget initialization.
  RISCVSubtarget &initializeSubtargetDependencies(const Triple &TT,
                                                  StringRef CPU,
                                                  StringRef TuneCPU,
                                                  StringRef FS,
                                                  StringRef ABIName);

public:
  // Initializes the data members to match that of the specified triple.
  RISCVSubtarget(const Triple &TT, StringRef CPU, StringRef TuneCPU,
                 StringRef FS, StringRef ABIName, const TargetMachine &TM);

  // Parses features string setting specified subtarget options. The
  // definition of this function is auto-generated by tblgen.
  void ParseSubtargetFeatures(StringRef CPU, StringRef TuneCPU, StringRef FS);

  const RISCVFrameLowering *getFrameLowering() const override {
    return &FrameLowering;
  }
  const RISCVInstrInfo *getInstrInfo() const override { return &InstrInfo; }
  const RISCVRegisterInfo *getRegisterInfo() const override {
    return &RegInfo;
  }
  const RISCVTargetLowering *getTargetLowering() const override {
    return &TLInfo;
  }
  const SelectionDAGTargetInfo *getSelectionDAGInfo() const override {
    return &TSInfo;
  }
  bool enableMachineScheduler() const override { return true; }

  /// Returns RISCV processor family.
  /// Avoid this function! CPU specifics should be kept local to this class
  /// and preferably modeled with SubtargetFeatures or properties in
  /// initializeProperties().
  RISCVProcFamilyEnum getProcFamily() const { return RISCVProcFamily; }

  bool hasStdExtM() const { return HasStdExtM; }
  bool hasStdExtA() const { return HasStdExtA; }
  bool hasStdExtF() const { return HasStdExtF; }
  bool hasStdExtD() const { return HasStdExtD; }
  bool hasStdExtC() const { return HasStdExtC; }
  bool hasStdExtZba() const { return HasStdExtZba; }
  bool hasStdExtZbb() const { return HasStdExtZbb; }
  bool hasStdExtZbc() const { return HasStdExtZbc; }
  bool hasStdExtZbe() const { return HasStdExtZbe; }
  bool hasStdExtZbf() const { return HasStdExtZbf; }
  bool hasStdExtZbm() const { return HasStdExtZbm; }
  bool hasStdExtZbp() const { return HasStdExtZbp; }
  bool hasStdExtZbr() const { return HasStdExtZbr; }
  bool hasStdExtZbs() const { return HasStdExtZbs; }
  bool hasStdExtZbt() const { return HasStdExtZbt; }
  bool hasStdExtV() const { return HasStdExtV; }
  bool hasStdExtZve32x() const { return HasStdExtZve32x; }
  bool hasStdExtZve32f() const { return HasStdExtZve32f; }
  bool hasStdExtZve64x() const { return HasStdExtZve64x; }
  bool hasStdExtZve64f() const { return HasStdExtZve64f; }
  bool hasStdExtZve64d() const { return HasStdExtZve64d; }
  bool hasStdExtZvl() const { return ZvlLen != ExtZvl::NotSet; }
  bool hasStdExtZfhmin() const { return HasStdExtZfhmin; }
  bool hasStdExtZfh() const { return HasStdExtZfh; }
  bool is64Bit() const { return HasRV64; }
  bool isRV32E() const { return IsRV32E; }
  bool enableLinkerRelax() const { return EnableLinkerRelax; }
  bool enableRVCHintInstrs() const { return EnableRVCHintInstrs; }
  bool enableSaveRestore() const { return EnableSaveRestore; }
  MVT getXLenVT() const { return XLenVT; }
  unsigned getXLen() const { return XLen; }
  unsigned getFLen() const {
    if (HasStdExtD)
      return 64;

    if (HasStdExtF)
      return 32;

    return 0;
  }
  RISCVABI::ABI getTargetABI() const { return TargetABI; }
  bool isRegisterReservedByUser(Register i) const {
    assert(i < RISCV::NUM_TARGET_REGS && "Register out of range");
    return UserReservedRegister[i];
  }

  // Vector codegen related methods.
  bool hasVInstructions() const { return HasStdExtZve32x; }
  bool hasVInstructionsI64() const { return HasStdExtZve64x; }
  bool hasVInstructionsF16() const { return HasStdExtZve32f && HasStdExtZfh; }
  // FIXME: Consider Zfinx in the future
  bool hasVInstructionsF32() const { return HasStdExtZve32f && HasStdExtF; }
  // FIXME: Consider Zdinx in the future
  bool hasVInstructionsF64() const { return HasStdExtZve64d && HasStdExtD; }
  // F16 and F64 both require F32.
  bool hasVInstructionsAnyF() const { return hasVInstructionsF32(); }
  unsigned getMaxInterleaveFactor() const {
    return hasVInstructions() ? MaxInterleaveFactor : 1;
  }

protected:
  // GlobalISel related APIs.
  std::unique_ptr<CallLowering> CallLoweringInfo;
  std::unique_ptr<InstructionSelector> InstSelector;
  std::unique_ptr<LegalizerInfo> Legalizer;
  std::unique_ptr<RegisterBankInfo> RegBankInfo;

public:
  const CallLowering *getCallLowering() const override;
  InstructionSelector *getInstructionSelector() const override;
  const LegalizerInfo *getLegalizerInfo() const override;
  const RegisterBankInfo *getRegBankInfo() const override;

  bool useConstantPoolForLargeInts() const;

  // Maximum cost used for building integers, integers will be put into constant
  // pool if exceeded.
  unsigned getMaxBuildIntsCost() const;

  // Return the known range for the bit length of RVV data registers. A value
  // of 0 means nothing is known about that particular limit beyond what's
  // implied by the architecture.
  unsigned getMaxRVVVectorSizeInBits() const;
  unsigned getMinRVVVectorSizeInBits() const;
  unsigned getMaxLMULForFixedLengthVectors() const;
  unsigned getMaxELENForFixedLengthVectors() const;
  bool useRVVForFixedLengthVectors() const;
};
} // End llvm namespace

#endif
