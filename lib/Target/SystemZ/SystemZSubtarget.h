//===-- SystemZSubtarget.h - SystemZ subtarget information -----*- C++ -*--===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the SystemZ specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_SYSTEMZ_SYSTEMZSUBTARGET_H
#define LLVM_LIB_TARGET_SYSTEMZ_SYSTEMZSUBTARGET_H

#include "SystemZFrameLowering.h"
#include "SystemZISelLowering.h"
#include "SystemZInstrInfo.h"
#include "SystemZRegisterInfo.h"
#include "SystemZSelectionDAGInfo.h"
#include "llvm/ADT/Triple.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include <string>

#define GET_SUBTARGETINFO_HEADER
#include "SystemZGenSubtargetInfo.inc"

namespace llvm {
class GlobalValue;
class StringRef;

class SystemZSubtarget : public SystemZGenSubtargetInfo {
  virtual void anchor();
protected:
  bool HasDistinctOps;
  bool HasLoadStoreOnCond;
  bool HasHighWord;
  bool HasFPExtension;
  bool HasPopulationCount;
  bool HasMessageSecurityAssist3;
  bool HasMessageSecurityAssist4;
  bool HasResetReferenceBitsMultiple;
  bool HasFastSerialization;
  bool HasInterlockedAccess1;
  bool HasMiscellaneousExtensions;
  bool HasExecutionHint;
  bool HasLoadAndTrap;
  bool HasTransactionalExecution;
  bool HasProcessorAssist;
  bool HasDFPZonedConversion;
  bool HasEnhancedDAT2;
  bool HasVector;
  bool HasLoadStoreOnCond2;
  bool HasLoadAndZeroRightmostByte;
  bool HasMessageSecurityAssist5;
  bool HasDFPPackedConversion;
  bool HasMiscellaneousExtensions2;
  bool HasGuardedStorage;
  bool HasMessageSecurityAssist7;
  bool HasMessageSecurityAssist8;
  bool HasVectorEnhancements1;
  bool HasVectorPackedDecimal;
  bool HasInsertReferenceBitsMultiple;
  bool HasMiscellaneousExtensions3;
  bool HasMessageSecurityAssist9;
  bool HasVectorEnhancements2;
  bool HasVectorPackedDecimalEnhancement;
  bool HasEnhancedSort;
  bool HasDeflateConversion;
  bool HasVectorPackedDecimalEnhancement2;
  bool HasNNPAssist;
  bool HasBEAREnhancement;
  bool HasResetDATProtection;
  bool HasProcessorActivityInstrumentation;
  bool HasSoftFloat;

private:
  Triple TargetTriple;
  std::unique_ptr<SystemZCallingConventionRegisters> SpecialRegisters;
  SystemZInstrInfo InstrInfo;
  SystemZTargetLowering TLInfo;
  SystemZSelectionDAGInfo TSInfo;
  std::unique_ptr<const SystemZFrameLowering> FrameLowering;

  SystemZSubtarget &initializeSubtargetDependencies(StringRef CPU,
                                                    StringRef FS);
  SystemZCallingConventionRegisters *initializeSpecialRegisters(void);

public:
  SystemZSubtarget(const Triple &TT, const std::string &CPU,
                   const std::string &FS, const TargetMachine &TM);

  SystemZCallingConventionRegisters *getSpecialRegisters() const {
    assert(SpecialRegisters && "Unsupported SystemZ calling convention");
    return SpecialRegisters.get();
  }

  template <class SR> SR &getSpecialRegisters() const {
    return *static_cast<SR *>(getSpecialRegisters());
  }

  const TargetFrameLowering *getFrameLowering() const override {
    return FrameLowering.get();
  }

  template <class TFL> const TFL *getFrameLowering() const {
    return static_cast<const TFL *>(getFrameLowering());
  }

  const SystemZInstrInfo *getInstrInfo() const override { return &InstrInfo; }
  const SystemZRegisterInfo *getRegisterInfo() const override {
    return &InstrInfo.getRegisterInfo();
  }
  const SystemZTargetLowering *getTargetLowering() const override {
    return &TLInfo;
  }
  const SelectionDAGTargetInfo *getSelectionDAGInfo() const override {
    return &TSInfo;
  }

  // True if the subtarget should run MachineScheduler after aggressive
  // coalescing. This currently replaces the SelectionDAG scheduler with the
  // "source" order scheduler.
  bool enableMachineScheduler() const override { return true; }

  // This is important for reducing register pressure in vector code.
  bool useAA() const override { return true; }

  // Always enable the early if-conversion pass.
  bool enableEarlyIfConversion() const override { return true; }

  // Enable tracking of subregister liveness in register allocator.
  bool enableSubRegLiveness() const override;

  // Automatically generated by tblgen.
  void ParseSubtargetFeatures(StringRef CPU, StringRef TuneCPU, StringRef FS);

  // Return true if the target has the distinct-operands facility.
  bool hasDistinctOps() const { return HasDistinctOps; }

  // Return true if the target has the load/store-on-condition facility.
  bool hasLoadStoreOnCond() const { return HasLoadStoreOnCond; }

  // Return true if the target has the load/store-on-condition facility 2.
  bool hasLoadStoreOnCond2() const { return HasLoadStoreOnCond2; }

  // Return true if the target has the high-word facility.
  bool hasHighWord() const { return HasHighWord; }

  // Return true if the target has the floating-point extension facility.
  bool hasFPExtension() const { return HasFPExtension; }

  // Return true if the target has the population-count facility.
  bool hasPopulationCount() const { return HasPopulationCount; }

  // Return true if the target has the message-security-assist
  // extension facility 3.
  bool hasMessageSecurityAssist3() const { return HasMessageSecurityAssist3; }

  // Return true if the target has the message-security-assist
  // extension facility 4.
  bool hasMessageSecurityAssist4() const { return HasMessageSecurityAssist4; }

  // Return true if the target has the reset-reference-bits-multiple facility.
  bool hasResetReferenceBitsMultiple() const {
    return HasResetReferenceBitsMultiple;
  }

  // Return true if the target has the fast-serialization facility.
  bool hasFastSerialization() const { return HasFastSerialization; }

  // Return true if the target has interlocked-access facility 1.
  bool hasInterlockedAccess1() const { return HasInterlockedAccess1; }

  // Return true if the target has the miscellaneous-extensions facility.
  bool hasMiscellaneousExtensions() const {
    return HasMiscellaneousExtensions;
  }

  // Return true if the target has the execution-hint facility.
  bool hasExecutionHint() const { return HasExecutionHint; }

  // Return true if the target has the load-and-trap facility.
  bool hasLoadAndTrap() const { return HasLoadAndTrap; }

  // Return true if the target has the transactional-execution facility.
  bool hasTransactionalExecution() const { return HasTransactionalExecution; }

  // Return true if the target has the processor-assist facility.
  bool hasProcessorAssist() const { return HasProcessorAssist; }

  // Return true if the target has the DFP zoned-conversion facility.
  bool hasDFPZonedConversion() const { return HasDFPZonedConversion; }

  // Return true if the target has the enhanced-DAT facility 2.
  bool hasEnhancedDAT2() const { return HasEnhancedDAT2; }

  // Return true if the target has the load-and-zero-rightmost-byte facility.
  bool hasLoadAndZeroRightmostByte() const {
    return HasLoadAndZeroRightmostByte;
  }

  // Return true if the target has the message-security-assist
  // extension facility 5.
  bool hasMessageSecurityAssist5() const { return HasMessageSecurityAssist5; }

  // Return true if the target has the DFP packed-conversion facility.
  bool hasDFPPackedConversion() const { return HasDFPPackedConversion; }

  // Return true if the target has the vector facility.
  bool hasVector() const { return HasVector; }

  // Return true if the target has the miscellaneous-extensions facility 2.
  bool hasMiscellaneousExtensions2() const {
    return HasMiscellaneousExtensions2;
  }

  // Return true if the target has the guarded-storage facility.
  bool hasGuardedStorage() const { return HasGuardedStorage; }

  // Return true if the target has the message-security-assist
  // extension facility 7.
  bool hasMessageSecurityAssist7() const { return HasMessageSecurityAssist7; }

  // Return true if the target has the message-security-assist
  // extension facility 8.
  bool hasMessageSecurityAssist8() const { return HasMessageSecurityAssist8; }

  // Return true if the target has the vector-enhancements facility 1.
  bool hasVectorEnhancements1() const { return HasVectorEnhancements1; }

  // Return true if the target has the vector-packed-decimal facility.
  bool hasVectorPackedDecimal() const { return HasVectorPackedDecimal; }

  // Return true if the target has the insert-reference-bits-multiple facility.
  bool hasInsertReferenceBitsMultiple() const {
    return HasInsertReferenceBitsMultiple;
  }

  // Return true if the target has the miscellaneous-extensions facility 3.
  bool hasMiscellaneousExtensions3() const {
    return HasMiscellaneousExtensions3;
  }

  // Return true if the target has the message-security-assist
  // extension facility 9.
  bool hasMessageSecurityAssist9() const { return HasMessageSecurityAssist9; }

  // Return true if the target has the vector-enhancements facility 2.
  bool hasVectorEnhancements2() const { return HasVectorEnhancements2; }

  // Return true if the target has the vector-packed-decimal
  // enhancement facility.
  bool hasVectorPackedDecimalEnhancement() const {
    return HasVectorPackedDecimalEnhancement;
  }

  // Return true if the target has the enhanced-sort facility.
  bool hasEnhancedSort() const { return HasEnhancedSort; }

  // Return true if the target has the deflate-conversion facility.
  bool hasDeflateConversion() const { return HasDeflateConversion; }

  // Return true if the target has the vector-packed-decimal
  // enhancement facility 2.
  bool hasVectorPackedDecimalEnhancement2() const {
    return HasVectorPackedDecimalEnhancement2;
  }

  // Return true if the target has the NNP-assist facility.
  bool hasNNPAssist() const { return HasNNPAssist; }

  // Return true if the target has the BEAR-enhancement facility.
  bool hasBEAREnhancement() const { return HasBEAREnhancement; }

  // Return true if the target has the reset-DAT-protection facility.
  bool hasResetDATProtection() const { return HasResetDATProtection; }

  // Return true if the target has the processor-activity-instrumentation
  // facility.
  bool hasProcessorActivityInstrumentation() const {
    return HasProcessorActivityInstrumentation;
  }

  // Return true if soft float should be used.
  bool hasSoftFloat() const { return HasSoftFloat; }

  // Return true if GV can be accessed using LARL for reloc model RM
  // and code model CM.
  bool isPC32DBLSymbol(const GlobalValue *GV, CodeModel::Model CM) const;

  bool isTargetELF() const { return TargetTriple.isOSBinFormatELF(); }

  // Returns TRUE if we are generating GOFF object code
  bool isTargetGOFF() const { return TargetTriple.isOSBinFormatGOFF(); }

  // Returns TRUE if we are using XPLINK64 linkage convention
  bool isTargetXPLINK64() const { return (isTargetGOFF() && isTargetzOS()); }

  // Returns TRUE if we are generating code for a s390x machine running zOS
  bool isTargetzOS() const { return TargetTriple.isOSzOS(); }
};
} // end namespace llvm

#endif
