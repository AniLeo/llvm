//===- RegAllocEvictionAdvisor.h - Interference resolution ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CODEGEN_REGALLOCEVICTIONADVISOR_H
#define LLVM_CODEGEN_REGALLOCEVICTIONADVISOR_H

#include "AllocationOrder.h"
#include "llvm/ADT/IndexedMap.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/CodeGen/LiveInterval.h"
#include "llvm/CodeGen/LiveIntervals.h"
#include "llvm/CodeGen/LiveRegMatrix.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/Register.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/Pass.h"

namespace llvm {

using SmallVirtRegSet = SmallSet<Register, 16>;

// Live ranges pass through a number of stages as we try to allocate them.
// Some of the stages may also create new live ranges:
//
// - Region splitting.
// - Per-block splitting.
// - Local splitting.
// - Spilling.
//
// Ranges produced by one of the stages skip the previous stages when they are
// dequeued. This improves performance because we can skip interference checks
// that are unlikely to give any results. It also guarantees that the live
// range splitting algorithm terminates, something that is otherwise hard to
// ensure.
enum LiveRangeStage {
  /// Newly created live range that has never been queued.
  RS_New,

  /// Only attempt assignment and eviction. Then requeue as RS_Split.
  RS_Assign,

  /// Attempt live range splitting if assignment is impossible.
  RS_Split,

  /// Attempt more aggressive live range splitting that is guaranteed to make
  /// progress.  This is used for split products that may not be making
  /// progress.
  RS_Split2,

  /// Live range will be spilled.  No more splitting will be attempted.
  RS_Spill,

  /// Live range is in memory. Because of other evictions, it might get moved
  /// in a register in the end.
  RS_Memory,

  /// There is nothing more we can do to this live range.  Abort compilation
  /// if it can't be assigned.
  RS_Done
};

/// Cost of evicting interference - used by default advisor, and the eviction
/// chain heuristic in RegAllocGreedy.
// FIXME: this can be probably made an implementation detail of the default
// advisor, if the eviction chain logic can be refactored.
struct EvictionCost {
  unsigned BrokenHints = 0; ///< Total number of broken hints.
  float MaxWeight = 0;      ///< Maximum spill weight evicted.

  EvictionCost() = default;

  bool isMax() const { return BrokenHints == ~0u; }

  void setMax() { BrokenHints = ~0u; }

  void setBrokenHints(unsigned NHints) { BrokenHints = NHints; }

  bool operator<(const EvictionCost &O) const {
    return std::tie(BrokenHints, MaxWeight) <
           std::tie(O.BrokenHints, O.MaxWeight);
  }
};

/// Track allocation stage and eviction loop prevention during allocation.
// TODO(mtrofin): Consider exposing RAGreedy in a header instead, and folding
// this back into it.
class ExtraRegInfo final {
  // RegInfo - Keep additional information about each live range.
  struct RegInfo {
    LiveRangeStage Stage = RS_New;

    // Cascade - Eviction loop prevention. See
    // canEvictInterferenceBasedOnCost().
    unsigned Cascade = 0;

    RegInfo() = default;
  };

  IndexedMap<RegInfo, VirtReg2IndexFunctor> Info;
  unsigned NextCascade = 1;

public:
  ExtraRegInfo() = default;
  ExtraRegInfo(const ExtraRegInfo &) = delete;

  LiveRangeStage getStage(Register Reg) const { return Info[Reg].Stage; }

  LiveRangeStage getStage(const LiveInterval &VirtReg) const {
    return getStage(VirtReg.reg());
  }

  void setStage(Register Reg, LiveRangeStage Stage) {
    Info.grow(Reg.id());
    Info[Reg].Stage = Stage;
  }

  void setStage(const LiveInterval &VirtReg, LiveRangeStage Stage) {
    setStage(VirtReg.reg(), Stage);
  }

  /// Return the current stage of the register, if present, otherwise initialize
  /// it and return that.
  LiveRangeStage getOrInitStage(Register Reg) {
    Info.grow(Reg.id());
    return getStage(Reg);
  }

  unsigned getCascade(Register Reg) const { return Info[Reg].Cascade; }

  void setCascade(Register Reg, unsigned Cascade) {
    Info.grow(Reg.id());
    Info[Reg].Cascade = Cascade;
  }

  unsigned getOrAssignNewCascade(Register Reg) {
    unsigned Cascade = getCascade(Reg);
    if (!Cascade) {
      Cascade = NextCascade++;
      setCascade(Reg, Cascade);
    }
    return Cascade;
  }

  unsigned getCascadeOrCurrentNext(Register Reg) const {
    unsigned Cascade = getCascade(Reg);
    if (!Cascade)
      Cascade = NextCascade;
    return Cascade;
  }

  template <typename Iterator>
  void setStage(Iterator Begin, Iterator End, LiveRangeStage NewStage) {
    for (; Begin != End; ++Begin) {
      Register Reg = *Begin;
      Info.grow(Reg.id());
      if (Info[Reg].Stage == RS_New)
        Info[Reg].Stage = NewStage;
    }
  }
  void LRE_DidCloneVirtReg(Register New, Register Old);
};
} // namespace llvm

#endif // LLVM_CODEGEN_REGALLOCEVICTIONADVISOR_H
