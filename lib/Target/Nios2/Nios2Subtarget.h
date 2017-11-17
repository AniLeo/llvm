//===-- Nios2Subtarget.h - Define Subtarget for the Nios2 -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the Nios2 specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_NIOS2_NIOS2SUBTARGET_H
#define LLVM_LIB_TARGET_NIOS2_NIOS2SUBTARGET_H

#include "Nios2FrameLowering.h"
#include "Nios2InstrInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"

#define GET_SUBTARGETINFO_HEADER
#include "Nios2GenSubtargetInfo.inc"

namespace llvm {
class StringRef;

class Nios2TargetMachine;

class Nios2Subtarget : public Nios2GenSubtargetInfo {
  virtual void anchor();

public:
  // Nios2 R2 features
  // Bit manipulation instructions extension
  bool HasBMX;
  // Code Density instructions extension
  bool HasCDX;
  // Multi-Processor instructions extension
  bool HasMPX;
  // New mandatory instructions
  bool HasR2Mandatory;

protected:
  enum Nios2ArchEnum {
    // Nios2 R1 ISA
    Nios2r1,
    // Nios2 R2 ISA
    Nios2r2
  };

  // Nios2 architecture version
  Nios2ArchEnum Nios2ArchVersion;

  const Nios2TargetMachine &TM;

  Triple TargetTriple;

  std::unique_ptr<const Nios2InstrInfo> InstrInfo;
  std::unique_ptr<const Nios2FrameLowering> FrameLowering;

public:
  /// This constructor initializes the data members to match that
  /// of the specified triple.
  Nios2Subtarget(const Triple &TT, const std::string &CPU,
                 const std::string &FS, const Nios2TargetMachine &_TM);

  /// ParseSubtargetFeatures - Parses features string setting specified
  /// subtarget options.  Definition of function is auto generated by tblgen.
  void ParseSubtargetFeatures(StringRef CPU, StringRef FS);

  bool hasNios2r1() const { return Nios2ArchVersion >= Nios2r1; }
  bool isNios2r1() const { return Nios2ArchVersion == Nios2r1; }
  bool hasNios2r2() const { return Nios2ArchVersion >= Nios2r2; }
  bool isNios2r2() const { return Nios2ArchVersion == Nios2r2; }

  Nios2Subtarget &initializeSubtargetDependencies(StringRef CPU, StringRef FS,
                                                  const TargetMachine &TM);

  const TargetFrameLowering *getFrameLowering() const override {
    return FrameLowering.get();
  }
  const Nios2RegisterInfo *getRegisterInfo() const override {
    return &InstrInfo->getRegisterInfo();
  }
};
} // namespace llvm

#endif
