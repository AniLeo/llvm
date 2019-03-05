//===- llvm/MC/MCSubtargetInfo.h - Subtarget Information --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the subtarget options of a Target machine.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCSUBTARGETINFO_H
#define LLVM_MC_MCSUBTARGETINFO_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Triple.h"
#include "llvm/MC/MCInstrItineraries.h"
#include "llvm/MC/MCSchedule.h"
#include "llvm/MC/SubtargetFeature.h"
#include <algorithm>
#include <cassert>
#include <cstdint>
#include <string>

namespace llvm {

class MCInst;

//===----------------------------------------------------------------------===//

/// Used to provide key value pairs for feature and CPU bit flags.
struct SubtargetFeatureKV {
  const char *Key;                      ///< K-V key string
  const char *Desc;                     ///< Help descriptor
  unsigned Value;                       ///< K-V integer value
  FeatureBitArray Implies;              ///< K-V bit mask

  /// Compare routine for std::lower_bound
  bool operator<(StringRef S) const {
    return StringRef(Key) < S;
  }

  /// Compare routine for std::is_sorted.
  bool operator<(const SubtargetFeatureKV &Other) const {
    return StringRef(Key) < StringRef(Other.Key);
  }
};

//===----------------------------------------------------------------------===//

/// Used to provide key value pairs for feature and CPU bit flags.
struct SubtargetSubTypeKV {
  const char *Key;                      ///< K-V key string
  FeatureBitArray Implies;              ///< K-V bit mask

  /// Compare routine for std::lower_bound
  bool operator<(StringRef S) const {
    return StringRef(Key) < S;
  }

  /// Compare routine for std::is_sorted.
  bool operator<(const SubtargetSubTypeKV &Other) const {
    return StringRef(Key) < StringRef(Other.Key);
  }
};

//===----------------------------------------------------------------------===//

/// Used to provide key value pairs for CPU and arbitrary pointers.
struct SubtargetInfoKV {
  const char *Key;                      ///< K-V key string
  const void *Value;                    ///< K-V pointer value

  /// Compare routine for std::lower_bound
  bool operator<(StringRef S) const {
    return StringRef(Key) < S;
  }

  /// Compare routine for std::is_sorted.
  bool operator<(const SubtargetInfoKV &Other) const {
    return StringRef(Key) < StringRef(Other.Key);
  }
};

//===----------------------------------------------------------------------===//
///
/// Generic base class for all target subtargets.
///
class MCSubtargetInfo {
  Triple TargetTriple;
  std::string CPU; // CPU being targeted.
  ArrayRef<SubtargetFeatureKV> ProcFeatures;  // Processor feature list
  ArrayRef<SubtargetSubTypeKV> ProcDesc;  // Processor descriptions

  // Scheduler machine model
  const SubtargetInfoKV *ProcSchedModels;
  const MCWriteProcResEntry *WriteProcResTable;
  const MCWriteLatencyEntry *WriteLatencyTable;
  const MCReadAdvanceEntry *ReadAdvanceTable;
  const MCSchedModel *CPUSchedModel;

  const InstrStage *Stages;            // Instruction itinerary stages
  const unsigned *OperandCycles;       // Itinerary operand cycles
  const unsigned *ForwardingPaths;
  FeatureBitset FeatureBits;           // Feature bits for current CPU + FS

public:
  MCSubtargetInfo(const MCSubtargetInfo &) = default;
  MCSubtargetInfo(const Triple &TT, StringRef CPU, StringRef FS,
                  ArrayRef<SubtargetFeatureKV> PF,
                  ArrayRef<SubtargetSubTypeKV> PD,
                  const SubtargetInfoKV *ProcSched,
                  const MCWriteProcResEntry *WPR, const MCWriteLatencyEntry *WL,
                  const MCReadAdvanceEntry *RA, const InstrStage *IS,
                  const unsigned *OC, const unsigned *FP);
  MCSubtargetInfo() = delete;
  MCSubtargetInfo &operator=(const MCSubtargetInfo &) = delete;
  MCSubtargetInfo &operator=(MCSubtargetInfo &&) = delete;
  virtual ~MCSubtargetInfo() = default;

  const Triple &getTargetTriple() const { return TargetTriple; }
  StringRef getCPU() const { return CPU; }

  const FeatureBitset& getFeatureBits() const { return FeatureBits; }
  void setFeatureBits(const FeatureBitset &FeatureBits_) {
    FeatureBits = FeatureBits_;
  }

  bool hasFeature(unsigned Feature) const {
    return FeatureBits[Feature];
  }

protected:
  /// Initialize the scheduling model and feature bits.
  ///
  /// FIXME: Find a way to stick this in the constructor, since it should only
  /// be called during initialization.
  void InitMCProcessorInfo(StringRef CPU, StringRef FS);

public:
  /// Set the features to the default for the given CPU with an appended feature
  /// string.
  void setDefaultFeatures(StringRef CPU, StringRef FS);

  /// Toggle a feature and return the re-computed feature bits.
  /// This version does not change the implied bits.
  FeatureBitset ToggleFeature(uint64_t FB);

  /// Toggle a feature and return the re-computed feature bits.
  /// This version does not change the implied bits.
  FeatureBitset ToggleFeature(const FeatureBitset& FB);

  /// Toggle a set of features and return the re-computed feature bits.
  /// This version will also change all implied bits.
  FeatureBitset ToggleFeature(StringRef FS);

  /// Apply a feature flag and return the re-computed feature bits, including
  /// all feature bits implied by the flag.
  FeatureBitset ApplyFeatureFlag(StringRef FS);

  /// Check whether the subtarget features are enabled/disabled as per
  /// the provided string, ignoring all other features.
  bool checkFeatures(StringRef FS) const;

  /// Get the machine model of a CPU.
  const MCSchedModel &getSchedModelForCPU(StringRef CPU) const;

  /// Get the machine model for this subtarget's CPU.
  const MCSchedModel &getSchedModel() const { return *CPUSchedModel; }

  /// Return an iterator at the first process resource consumed by the given
  /// scheduling class.
  const MCWriteProcResEntry *getWriteProcResBegin(
    const MCSchedClassDesc *SC) const {
    return &WriteProcResTable[SC->WriteProcResIdx];
  }
  const MCWriteProcResEntry *getWriteProcResEnd(
    const MCSchedClassDesc *SC) const {
    return getWriteProcResBegin(SC) + SC->NumWriteProcResEntries;
  }

  const MCWriteLatencyEntry *getWriteLatencyEntry(const MCSchedClassDesc *SC,
                                                  unsigned DefIdx) const {
    assert(DefIdx < SC->NumWriteLatencyEntries &&
           "MachineModel does not specify a WriteResource for DefIdx");

    return &WriteLatencyTable[SC->WriteLatencyIdx + DefIdx];
  }

  int getReadAdvanceCycles(const MCSchedClassDesc *SC, unsigned UseIdx,
                           unsigned WriteResID) const {
    // TODO: The number of read advance entries in a class can be significant
    // (~50). Consider compressing the WriteID into a dense ID of those that are
    // used by ReadAdvance and representing them as a bitset.
    for (const MCReadAdvanceEntry *I = &ReadAdvanceTable[SC->ReadAdvanceIdx],
           *E = I + SC->NumReadAdvanceEntries; I != E; ++I) {
      if (I->UseIdx < UseIdx)
        continue;
      if (I->UseIdx > UseIdx)
        break;
      // Find the first WriteResIdx match, which has the highest cycle count.
      if (!I->WriteResourceID || I->WriteResourceID == WriteResID) {
        return I->Cycles;
      }
    }
    return 0;
  }

  /// Return the set of ReadAdvance entries declared by the scheduling class
  /// descriptor in input.
  ArrayRef<MCReadAdvanceEntry>
  getReadAdvanceEntries(const MCSchedClassDesc &SC) const {
    if (!SC.NumReadAdvanceEntries)
      return ArrayRef<MCReadAdvanceEntry>();
    return ArrayRef<MCReadAdvanceEntry>(&ReadAdvanceTable[SC.ReadAdvanceIdx],
                                        SC.NumReadAdvanceEntries);
  }

  /// Get scheduling itinerary of a CPU.
  InstrItineraryData getInstrItineraryForCPU(StringRef CPU) const;

  /// Initialize an InstrItineraryData instance.
  void initInstrItins(InstrItineraryData &InstrItins) const;

  /// Resolve a variant scheduling class for the given MCInst and CPU.
  virtual unsigned
  resolveVariantSchedClass(unsigned SchedClass, const MCInst *MI,
                           unsigned CPUID) const {
    return 0;
  }

  /// Check whether the CPU string is valid.
  bool isCPUStringValid(StringRef CPU) const {
    auto Found = std::lower_bound(ProcDesc.begin(), ProcDesc.end(), CPU);
    return Found != ProcDesc.end() && StringRef(Found->Key) == CPU;
  }
};

} // end namespace llvm

#endif // LLVM_MC_MCSUBTARGETINFO_H
