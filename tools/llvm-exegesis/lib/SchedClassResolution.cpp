//===-- SchedClassResolution.cpp --------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "SchedClassResolution.h"
#include "BenchmarkResult.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/Support/FormatVariadic.h"
#include <limits>
#include <unordered_set>
#include <vector>

namespace llvm {
namespace exegesis {

// Return the non-redundant list of WriteProcRes used by the given sched class.
// The scheduling model for LLVM is such that each instruction has a certain
// number of uops which consume resources which are described by WriteProcRes
// entries. Each entry describe how many cycles are spent on a specific ProcRes
// kind.
// For example, an instruction might have 3 uOps, one dispatching on P0
// (ProcResIdx=1) and two on P06 (ProcResIdx = 7).
// Note that LLVM additionally denormalizes resource consumption to include
// usage of super resources by subresources. So in practice if there exists a
// P016 (ProcResIdx=10), then the cycles consumed by P0 are also consumed by
// P06 (ProcResIdx = 7) and P016 (ProcResIdx = 10), and the resources consumed
// by P06 are also consumed by P016. In the figure below, parenthesized cycles
// denote implied usage of superresources by subresources:
//            P0      P06    P016
//     uOp1    1      (1)     (1)
//     uOp2            1      (1)
//     uOp3            1      (1)
//     =============================
//             1       3       3
// Eventually we end up with three entries for the WriteProcRes of the
// instruction:
//    {ProcResIdx=1,  Cycles=1}  // P0
//    {ProcResIdx=7,  Cycles=3}  // P06
//    {ProcResIdx=10, Cycles=3}  // P016
//
// Note that in this case, P016 does not contribute any cycles, so it would
// be removed by this function.
// FIXME: Move this to MCSubtargetInfo and use it in llvm-mca.
static llvm::SmallVector<llvm::MCWriteProcResEntry, 8>
getNonRedundantWriteProcRes(const llvm::MCSchedClassDesc &SCDesc,
                            const llvm::MCSubtargetInfo &STI) {
  llvm::SmallVector<llvm::MCWriteProcResEntry, 8> Result;
  const auto &SM = STI.getSchedModel();
  const unsigned NumProcRes = SM.getNumProcResourceKinds();

  // This assumes that the ProcResDescs are sorted in topological order, which
  // is guaranteed by the tablegen backend.
  llvm::SmallVector<float, 32> ProcResUnitUsage(NumProcRes);
  for (const auto *WPR = STI.getWriteProcResBegin(&SCDesc),
                  *const WPREnd = STI.getWriteProcResEnd(&SCDesc);
       WPR != WPREnd; ++WPR) {
    const llvm::MCProcResourceDesc *const ProcResDesc =
        SM.getProcResource(WPR->ProcResourceIdx);
    if (ProcResDesc->SubUnitsIdxBegin == nullptr) {
      // This is a ProcResUnit.
      Result.push_back({WPR->ProcResourceIdx, WPR->Cycles});
      ProcResUnitUsage[WPR->ProcResourceIdx] += WPR->Cycles;
    } else {
      // This is a ProcResGroup. First see if it contributes any cycles or if
      // it has cycles just from subunits.
      float RemainingCycles = WPR->Cycles;
      for (const auto *SubResIdx = ProcResDesc->SubUnitsIdxBegin;
           SubResIdx != ProcResDesc->SubUnitsIdxBegin + ProcResDesc->NumUnits;
           ++SubResIdx) {
        RemainingCycles -= ProcResUnitUsage[*SubResIdx];
      }
      if (RemainingCycles < 0.01f) {
        // The ProcResGroup contributes no cycles of its own.
        continue;
      }
      // The ProcResGroup contributes `RemainingCycles` cycles of its own.
      Result.push_back({WPR->ProcResourceIdx,
                        static_cast<uint16_t>(std::round(RemainingCycles))});
      // Spread the remaining cycles over all subunits.
      for (const auto *SubResIdx = ProcResDesc->SubUnitsIdxBegin;
           SubResIdx != ProcResDesc->SubUnitsIdxBegin + ProcResDesc->NumUnits;
           ++SubResIdx) {
        ProcResUnitUsage[*SubResIdx] += RemainingCycles / ProcResDesc->NumUnits;
      }
    }
  }
  return Result;
}

// Distributes a pressure budget as evenly as possible on the provided subunits
// given the already existing port pressure distribution.
//
// The algorithm is as follows: while there is remaining pressure to
// distribute, find the subunits with minimal pressure, and distribute
// remaining pressure equally up to the pressure of the unit with
// second-to-minimal pressure.
// For example, let's assume we want to distribute 2*P1256
// (Subunits = [P1,P2,P5,P6]), and the starting DensePressure is:
//     DensePressure =        P0   P1   P2   P3   P4   P5   P6   P7
//                           0.1  0.3  0.2  0.0  0.0  0.5  0.5  0.5
//     RemainingPressure = 2.0
// We sort the subunits by pressure:
//     Subunits = [(P2,p=0.2), (P1,p=0.3), (P5,p=0.5), (P6, p=0.5)]
// We'll first start by the subunits with minimal pressure, which are at
// the beginning of the sorted array. In this example there is one (P2).
// The subunit with second-to-minimal pressure is the next one in the
// array (P1). So we distribute 0.1 pressure to P2, and remove 0.1 cycles
// from the budget.
//     Subunits = [(P2,p=0.3), (P1,p=0.3), (P5,p=0.5), (P5,p=0.5)]
//     RemainingPressure = 1.9
// We repeat this process: distribute 0.2 pressure on each of the minimal
// P2 and P1, decrease budget by 2*0.2:
//     Subunits = [(P2,p=0.5), (P1,p=0.5), (P5,p=0.5), (P5,p=0.5)]
//     RemainingPressure = 1.5
// There are no second-to-minimal subunits so we just share the remaining
// budget (1.5 cycles) equally:
//     Subunits = [(P2,p=0.875), (P1,p=0.875), (P5,p=0.875), (P5,p=0.875)]
//     RemainingPressure = 0.0
// We stop as there is no remaining budget to distribute.
static void distributePressure(float RemainingPressure,
                               llvm::SmallVector<uint16_t, 32> Subunits,
                               llvm::SmallVector<float, 32> &DensePressure) {
  // Find the number of subunits with minimal pressure (they are at the
  // front).
  llvm::sort(Subunits, [&DensePressure](const uint16_t A, const uint16_t B) {
    return DensePressure[A] < DensePressure[B];
  });
  const auto getPressureForSubunit = [&DensePressure,
                                      &Subunits](size_t I) -> float & {
    return DensePressure[Subunits[I]];
  };
  size_t NumMinimalSU = 1;
  while (NumMinimalSU < Subunits.size() &&
         getPressureForSubunit(NumMinimalSU) == getPressureForSubunit(0)) {
    ++NumMinimalSU;
  }
  while (RemainingPressure > 0.0f) {
    if (NumMinimalSU == Subunits.size()) {
      // All units are minimal, just distribute evenly and be done.
      for (size_t I = 0; I < NumMinimalSU; ++I) {
        getPressureForSubunit(I) += RemainingPressure / NumMinimalSU;
      }
      return;
    }
    // Distribute the remaining pressure equally.
    const float MinimalPressure = getPressureForSubunit(NumMinimalSU - 1);
    const float SecondToMinimalPressure = getPressureForSubunit(NumMinimalSU);
    assert(MinimalPressure < SecondToMinimalPressure);
    const float Increment = SecondToMinimalPressure - MinimalPressure;
    if (RemainingPressure <= NumMinimalSU * Increment) {
      // There is not enough remaining pressure.
      for (size_t I = 0; I < NumMinimalSU; ++I) {
        getPressureForSubunit(I) += RemainingPressure / NumMinimalSU;
      }
      return;
    }
    // Bump all minimal pressure subunits to `SecondToMinimalPressure`.
    for (size_t I = 0; I < NumMinimalSU; ++I) {
      getPressureForSubunit(I) = SecondToMinimalPressure;
      RemainingPressure -= SecondToMinimalPressure;
    }
    while (NumMinimalSU < Subunits.size() &&
           getPressureForSubunit(NumMinimalSU) == SecondToMinimalPressure) {
      ++NumMinimalSU;
    }
  }
}

std::vector<std::pair<uint16_t, float>> computeIdealizedProcResPressure(
    const llvm::MCSchedModel &SM,
    llvm::SmallVector<llvm::MCWriteProcResEntry, 8> WPRS) {
  // DensePressure[I] is the port pressure for Proc Resource I.
  llvm::SmallVector<float, 32> DensePressure(SM.getNumProcResourceKinds());
  llvm::sort(WPRS, [](const llvm::MCWriteProcResEntry &A,
                      const llvm::MCWriteProcResEntry &B) {
    return A.ProcResourceIdx < B.ProcResourceIdx;
  });
  for (const llvm::MCWriteProcResEntry &WPR : WPRS) {
    // Get units for the entry.
    const llvm::MCProcResourceDesc *const ProcResDesc =
        SM.getProcResource(WPR.ProcResourceIdx);
    if (ProcResDesc->SubUnitsIdxBegin == nullptr) {
      // This is a ProcResUnit.
      DensePressure[WPR.ProcResourceIdx] += WPR.Cycles;
    } else {
      // This is a ProcResGroup.
      llvm::SmallVector<uint16_t, 32> Subunits(ProcResDesc->SubUnitsIdxBegin,
                                               ProcResDesc->SubUnitsIdxBegin +
                                                   ProcResDesc->NumUnits);
      distributePressure(WPR.Cycles, Subunits, DensePressure);
    }
  }
  // Turn dense pressure into sparse pressure by removing zero entries.
  std::vector<std::pair<uint16_t, float>> Pressure;
  for (unsigned I = 0, E = SM.getNumProcResourceKinds(); I < E; ++I) {
    if (DensePressure[I] > 0.0f)
      Pressure.emplace_back(I, DensePressure[I]);
  }
  return Pressure;
}

ResolvedSchedClass::ResolvedSchedClass(const llvm::MCSubtargetInfo &STI,
                                       unsigned ResolvedSchedClassId,
                                       bool WasVariant)
    : SchedClassId(ResolvedSchedClassId),
      SCDesc(STI.getSchedModel().getSchedClassDesc(ResolvedSchedClassId)),
      WasVariant(WasVariant),
      NonRedundantWriteProcRes(getNonRedundantWriteProcRes(*SCDesc, STI)),
      IdealizedProcResPressure(computeIdealizedProcResPressure(
          STI.getSchedModel(), NonRedundantWriteProcRes)) {
  assert((SCDesc == nullptr || !SCDesc->isVariant()) &&
         "ResolvedSchedClass should never be variant");
}

static unsigned ResolveVariantSchedClassId(const llvm::MCSubtargetInfo &STI,
                                           unsigned SchedClassId,
                                           const llvm::MCInst &MCI) {
  const auto &SM = STI.getSchedModel();
  while (SchedClassId && SM.getSchedClassDesc(SchedClassId)->isVariant())
    SchedClassId =
        STI.resolveVariantSchedClass(SchedClassId, &MCI, SM.getProcessorID());
  return SchedClassId;
}

std::pair<unsigned /*SchedClassId*/, bool /*WasVariant*/>
ResolvedSchedClass::resolveSchedClassId(
    const llvm::MCSubtargetInfo &SubtargetInfo,
    const llvm::MCInstrInfo &InstrInfo, const llvm::MCInst &MCI) {
  unsigned SchedClassId = InstrInfo.get(MCI.getOpcode()).getSchedClass();
  const bool WasVariant = SchedClassId && SubtargetInfo.getSchedModel()
                                              .getSchedClassDesc(SchedClassId)
                                              ->isVariant();
  SchedClassId = ResolveVariantSchedClassId(SubtargetInfo, SchedClassId, MCI);
  return std::make_pair(SchedClassId, WasVariant);
}

} // namespace exegesis
} // namespace llvm
