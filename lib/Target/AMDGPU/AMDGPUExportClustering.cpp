//===--- AMDGPUExportClusting.cpp - AMDGPU Export Clustering  -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
/// \file This file contains a DAG scheduling mutation to cluster shader
///       exports.
//
//===----------------------------------------------------------------------===//

#include "AMDGPUExportClustering.h"
#include "AMDGPUSubtarget.h"
#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "SIInstrInfo.h"

using namespace llvm;

namespace {

class ExportClustering : public ScheduleDAGMutation {
public:
  ExportClustering() {}
  void apply(ScheduleDAGInstrs *DAG) override;
};

static bool isExport(const SUnit &SU) {
  const MachineInstr *MI = SU.getInstr();
  return MI->getOpcode() == AMDGPU::EXP ||
         MI->getOpcode() == AMDGPU::EXP_DONE;
}

static bool isPositionExport(const SIInstrInfo *TII, SUnit *SU) {
  const MachineInstr *MI = SU->getInstr();
  int Imm = TII->getNamedOperand(*MI, AMDGPU::OpName::tgt)->getImm();
  return Imm >= 12 && Imm <= 15;
}

static void sortChain(const SIInstrInfo *TII, SmallVector<SUnit *, 8> &Chain,
                      unsigned PosCount) {
  if (!PosCount || PosCount == Chain.size())
    return;

  // Position exports should occur as soon as possible in the shader
  // for optimal performance.  This moves position exports before
  // other exports while preserving the order within different export
  // types (pos or other).
  SmallVector<SUnit *, 8> Copy(Chain);
  unsigned PosIdx = 0;
  unsigned OtherIdx = PosCount;
  for (SUnit *SU : Copy) {
    if (isPositionExport(TII, SU))
      Chain[PosIdx++] = SU;
    else
      Chain[OtherIdx++] = SU;
  }
}

static void buildCluster(ArrayRef<SUnit *> Exports, ScheduleDAGInstrs *DAG) {
  SUnit *ChainHead = Exports.front();

  // Now construct cluster from chain by adding new edges.
  for (unsigned Idx = 0, End = Exports.size() - 1; Idx < End; ++Idx) {
    SUnit *SUa = Exports[Idx];
    SUnit *SUb = Exports[Idx + 1];

    // Copy all dependencies to the head of the chain to avoid any
    // computation being inserted into the chain.
    for (const SDep &Pred : SUb->Preds) {
      SUnit *PredSU = Pred.getSUnit();
      if (!isExport(*PredSU) && !Pred.isWeak())
        DAG->addEdge(ChainHead, SDep(PredSU, SDep::Artificial));
    }

    // New barrier edge ordering exports
    DAG->addEdge(SUb, SDep(SUa, SDep::Barrier));
    // Also add cluster edge
    DAG->addEdge(SUb, SDep(SUa, SDep::Cluster));
  }
}

void ExportClustering::apply(ScheduleDAGInstrs *DAG) {
  const SIInstrInfo *TII = static_cast<const SIInstrInfo *>(DAG->TII);

  SmallVector<SUnit *, 8> Chain;

  // Pass through DAG gathering a list of exports and removing barrier edges
  // creating dependencies on exports. Freeing exports of successor edges
  // allows more scheduling freedom, and nothing should be order dependent
  // on exports.  Edges will be added later to order the exports.
  unsigned PosCount = 0;
  for (SUnit &SU : DAG->SUnits) {
    if (isExport(SU)) {
      Chain.push_back(&SU);
      if (isPositionExport(TII, &SU))
        PosCount++;
    }

    SmallVector<SDep, 2> ToRemove;
    for (const SDep &Pred : SU.Preds) {
      SUnit *PredSU = Pred.getSUnit();
      if (Pred.isBarrier() && isExport(*PredSU))
        ToRemove.push_back(Pred);
    }
    for (SDep Pred : ToRemove)
      SU.removePred(Pred);
  }

  // Apply clustering if there are multiple exports
  if (Chain.size() > 1) {
    sortChain(TII, Chain, PosCount);
    buildCluster(Chain, DAG);
  }
}

} // end namespace

namespace llvm {

std::unique_ptr<ScheduleDAGMutation> createAMDGPUExportClusteringDAGMutation() {
  return std::make_unique<ExportClustering>();
}

} // end namespace llvm
