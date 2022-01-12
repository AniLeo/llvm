//===-- M68kSubtarget.h - Define Subtarget for the M68k ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file declares the M68k specific subclass of TargetSubtargetInfo.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_CPU0_M68KSUBTARGET_H
#define LLVM_LIB_TARGET_CPU0_M68KSUBTARGET_H

#include "M68kFrameLowering.h"
#include "M68kISelLowering.h"
#include "M68kInstrInfo.h"

#include "llvm/ADT/BitVector.h"
#include "llvm/CodeGen/GlobalISel/CallLowering.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/LegalizerInfo.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/CodeGen/SelectionDAGTargetInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/MC/MCInstrItineraries.h"
#include "llvm/Support/Alignment.h"

#include <string>

#define GET_SUBTARGETINFO_HEADER
#include "M68kGenSubtargetInfo.inc"

extern bool M68kReserveGP;
extern bool M68kNoCpload;

namespace llvm {
class StringRef;

class M68kTargetMachine;

class M68kSubtarget : public M68kGenSubtargetInfo {
  virtual void anchor();

protected:
  // These define which ISA is supported. Since each Motorola M68k ISA is
  // built on top of the previous one whenever an ISA is selected the previous
  // selected as well.
  enum SubtargetEnum { M00, M10, M20, M30, M40, M60 };
  SubtargetEnum SubtargetKind = M00;

  BitVector UserReservedRegister;

  InstrItineraryData InstrItins;

  /// Small section is used.
  bool UseSmallSection = true;

  const M68kTargetMachine &TM;

  SelectionDAGTargetInfo TSInfo;
  M68kInstrInfo InstrInfo;
  M68kFrameLowering FrameLowering;
  M68kTargetLowering TLInfo;

  /// The minimum alignment known to hold of the stack frame on
  /// entry to the function and which must be maintained by every function.
  unsigned stackAlignment = 8;

  Triple TargetTriple;

public:
  /// This constructor initializes the data members to match that
  /// of the specified triple.
  M68kSubtarget(const Triple &TT, StringRef CPU, StringRef FS,
                const M68kTargetMachine &_TM);

  /// Parses features string setting specified subtarget options.  Definition
  /// of function is auto generated by tblgen.
  void ParseSubtargetFeatures(StringRef CPU, StringRef TuneCPU, StringRef FS);

  bool atLeastM68000() const { return SubtargetKind >= M00; }
  bool atLeastM68010() const { return SubtargetKind >= M10; }
  bool atLeastM68020() const { return SubtargetKind >= M20; }
  bool atLeastM68030() const { return SubtargetKind >= M30; }
  bool atLeastM68040() const { return SubtargetKind >= M40; }
  bool atLeastM68060() const { return SubtargetKind >= M60; }

  bool useSmallSection() const { return UseSmallSection; }

  bool abiUsesSoftFloat() const;

  const Triple &getTargetTriple() const { return TargetTriple; }

  bool isTargetELF() const { return TargetTriple.isOSBinFormatELF(); }

  /// Return true if the subtarget allows calls to immediate address.
  bool isLegalToCallImmediateAddr() const;

  bool isPositionIndependent() const;

  bool isRegisterReservedByUser(Register R) const {
    assert(R < M68k::NUM_TARGET_REGS && "Register out of range");
    return UserReservedRegister[R];
  }

  /// Classify a global variable reference for the current subtarget according
  /// to how we should reference it in a non-pcrel context.
  unsigned char classifyLocalReference(const GlobalValue *GV) const;

  /// Classify a global variable reference for the current subtarget according
  /// to how we should reference it in a non-pcrel context.
  unsigned char classifyGlobalReference(const GlobalValue *GV,
                                        const Module &M) const;
  unsigned char classifyGlobalReference(const GlobalValue *GV) const;

  /// Classify a external variable reference for the current subtarget according
  /// to how we should reference it in a non-pcrel context.
  unsigned char classifyExternalReference(const Module &M) const;

  /// Classify a global function reference for the current subtarget.
  unsigned char classifyGlobalFunctionReference(const GlobalValue *GV,
                                                const Module &M) const;
  unsigned char classifyGlobalFunctionReference(const GlobalValue *GV) const;

  /// Classify a blockaddress reference for the current subtarget according to
  /// how we should reference it in a non-pcrel context.
  unsigned char classifyBlockAddressReference() const;

  unsigned getJumpTableEncoding() const;

  /// TODO this must be controlled by options like -malign-int and -mshort
  Align getStackAlignment() const { return Align(stackAlignment); }

  /// getSlotSize - Stack slot size in bytes.
  unsigned getSlotSize() const { return 4; }

  M68kSubtarget &initializeSubtargetDependencies(StringRef CPU, Triple TT,
                                                 StringRef FS,
                                                 const M68kTargetMachine &TM);

  const SelectionDAGTargetInfo *getSelectionDAGInfo() const override {
    return &TSInfo;
  }

  const M68kInstrInfo *getInstrInfo() const override { return &InstrInfo; }

  const M68kFrameLowering *getFrameLowering() const override {
    return &FrameLowering;
  }

  const M68kRegisterInfo *getRegisterInfo() const override {
    return &InstrInfo.getRegisterInfo();
  }

  const M68kTargetLowering *getTargetLowering() const override {
    return &TLInfo;
  }

  const InstrItineraryData *getInstrItineraryData() const override {
    return &InstrItins;
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
};
} // namespace llvm

#endif // LLVM_LIB_TARGET_CPU0_M68KSUBTARGET_H
