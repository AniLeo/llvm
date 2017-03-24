//===-- SIMachineScheduler.cpp - SI Scheduler Interface -------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
/// \file
/// \brief SI Machine Scheduler interface
//
//===----------------------------------------------------------------------===//

#include "AMDGPU.h"
#include "SIInstrInfo.h"
#include "SIMachineScheduler.h"
#include "SIRegisterInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/LiveInterval.h"
#include "llvm/CodeGen/LiveIntervalAnalysis.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/MachineScheduler.h"
#include "llvm/CodeGen/RegisterPressure.h"
#include "llvm/CodeGen/SlotIndexes.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetRegisterInfo.h"
#include <algorithm>
#include <cassert>
#include <map>
#include <set>
#include <utility>
#include <vector>

using namespace llvm;

#define DEBUG_TYPE "misched"

// This scheduler implements a different scheduling algorithm than
// GenericScheduler.
//
// There are several specific architecture behaviours that can't be modelled
// for GenericScheduler:
// . When accessing the result of an SGPR load instruction, you have to wait
// for all the SGPR load instructions before your current instruction to
// have finished.
// . When accessing the result of an VGPR load instruction, you have to wait
// for all the VGPR load instructions previous to the VGPR load instruction
// you are interested in to finish.
// . The less the register pressure, the best load latencies are hidden
//
// Moreover some specifities (like the fact a lot of instructions in the shader
// have few dependencies) makes the generic scheduler have some unpredictable
// behaviours. For example when register pressure becomes high, it can either
// manage to prevent register pressure from going too high, or it can
// increase register pressure even more than if it hadn't taken register
// pressure into account.
//
// Also some other bad behaviours are generated, like loading at the beginning
// of the shader a constant in VGPR you won't need until the end of the shader.
//
// The scheduling problem for SI can distinguish three main parts:
// . Hiding high latencies (texture sampling, etc)
// . Hiding low latencies (SGPR constant loading, etc)
// . Keeping register usage low for better latency hiding and general
//   performance
//
// Some other things can also affect performance, but are hard to predict
// (cache usage, the fact the HW can issue several instructions from different
// wavefronts if different types, etc)
//
// This scheduler tries to solve the scheduling problem by dividing it into
// simpler sub-problems. It divides the instructions into blocks, schedules
// locally inside the blocks where it takes care of low latencies, and then
// chooses the order of the blocks by taking care of high latencies.
// Dividing the instructions into blocks helps control keeping register
// usage low.
//
// First the instructions are put into blocks.
//   We want the blocks help control register usage and hide high latencies
//   later. To help control register usage, we typically want all local
//   computations, when for example you create a result that can be comsummed
//   right away, to be contained in a block. Block inputs and outputs would
//   typically be important results that are needed in several locations of
//   the shader. Since we do want blocks to help hide high latencies, we want
//   the instructions inside the block to have a minimal set of dependencies
//   on high latencies. It will make it easy to pick blocks to hide specific
//   high latencies.
//   The block creation algorithm is divided into several steps, and several
//   variants can be tried during the scheduling process.
//
// Second the order of the instructions inside the blocks is chosen.
//   At that step we do take into account only register usage and hiding
//   low latency instructions
//
// Third the block order is chosen, there we try to hide high latencies
// and keep register usage low.
//
// After the third step, a pass is done to improve the hiding of low
// latencies.
//
// Actually when talking about 'low latency' or 'high latency' it includes
// both the latency to get the cache (or global mem) data go to the register,
// and the bandwidth limitations.
// Increasing the number of active wavefronts helps hide the former, but it
// doesn't solve the latter, thus why even if wavefront count is high, we have
// to try have as many instructions hiding high latencies as possible.
// The OpenCL doc says for example latency of 400 cycles for a global mem access,
// which is hidden by 10 instructions if the wavefront count is 10.

// Some figures taken from AMD docs:
// Both texture and constant L1 caches are 4-way associative with 64 bytes
// lines.
// Constant cache is shared with 4 CUs.
// For texture sampling, the address generation unit receives 4 texture
// addresses per cycle, thus we could expect texture sampling latency to be
// equivalent to 4 instructions in the very best case (a VGPR is 64 work items,
// instructions in a wavefront group are executed every 4 cycles),
// or 16 instructions if the other wavefronts associated to the 3 other VALUs
// of the CU do texture sampling too. (Don't take these figures too seriously,
// as I'm not 100% sure of the computation)
// Data exports should get similar latency.
// For constant loading, the cache is shader with 4 CUs.
// The doc says "a throughput of 16B/cycle for each of the 4 Compute Unit"
// I guess if the other CU don't read the cache, it can go up to 64B/cycle.
// It means a simple s_buffer_load should take one instruction to hide, as
// well as a s_buffer_loadx2 and potentially a s_buffer_loadx8 if on the same
// cache line.
//
// As of today the driver doesn't preload the constants in cache, thus the
// first loads get extra latency. The doc says global memory access can be
// 300-600 cycles. We do not specially take that into account when scheduling
// As we expect the driver to be able to preload the constants soon.

// common code //

#ifndef NDEBUG

static const char *getReasonStr(SIScheduleCandReason Reason) {
  switch (Reason) {
  case NoCand:         return "NOCAND";
  case RegUsage:       return "REGUSAGE";
  case Latency:        return "LATENCY";
  case Successor:      return "SUCCESSOR";
  case Depth:          return "DEPTH";
  case NodeOrder:      return "ORDER";
  }
  llvm_unreachable("Unknown reason!");
}

#endif

static bool tryLess(int TryVal, int CandVal,
                    SISchedulerCandidate &TryCand,
                    SISchedulerCandidate &Cand,
                    SIScheduleCandReason Reason) {
  if (TryVal < CandVal) {
    TryCand.Reason = Reason;
    return true;
  }
  if (TryVal > CandVal) {
    if (Cand.Reason > Reason)
      Cand.Reason = Reason;
    return true;
  }
  Cand.setRepeat(Reason);
  return false;
}

static bool tryGreater(int TryVal, int CandVal,
                       SISchedulerCandidate &TryCand,
                       SISchedulerCandidate &Cand,
                       SIScheduleCandReason Reason) {
  if (TryVal > CandVal) {
    TryCand.Reason = Reason;
    return true;
  }
  if (TryVal < CandVal) {
    if (Cand.Reason > Reason)
      Cand.Reason = Reason;
    return true;
  }
  Cand.setRepeat(Reason);
  return false;
}

// SIScheduleBlock //

void SIScheduleBlock::addUnit(SUnit *SU) {
  NodeNum2Index[SU->NodeNum] = SUnits.size();
  SUnits.push_back(SU);
}

#ifndef NDEBUG
void SIScheduleBlock::traceCandidate(const SISchedCandidate &Cand) {

  dbgs() << "  SU(" << Cand.SU->NodeNum << ") " << getReasonStr(Cand.Reason);
  dbgs() << '\n';
}
#endif

void SIScheduleBlock::tryCandidateTopDown(SISchedCandidate &Cand,
                                          SISchedCandidate &TryCand) {
  // Initialize the candidate if needed.
  if (!Cand.isValid()) {
    TryCand.Reason = NodeOrder;
    return;
  }

  if (Cand.SGPRUsage > 60 &&
      tryLess(TryCand.SGPRUsage, Cand.SGPRUsage, TryCand, Cand, RegUsage))
    return;

  // Schedule low latency instructions as top as possible.
  // Order of priority is:
  // . Low latency instructions which do not depend on other low latency
  //   instructions we haven't waited for
  // . Other instructions which do not depend on low latency instructions
  //   we haven't waited for
  // . Low latencies
  // . All other instructions
  // Goal is to get: low latency instructions - independent instructions
  //     - (eventually some more low latency instructions)
  //     - instructions that depend on the first low latency instructions.
  // If in the block there is a lot of constant loads, the SGPR usage
  // could go quite high, thus above the arbitrary limit of 60 will encourage
  // use the already loaded constants (in order to release some SGPRs) before
  // loading more.
  if (tryLess(TryCand.HasLowLatencyNonWaitedParent,
              Cand.HasLowLatencyNonWaitedParent,
              TryCand, Cand, SIScheduleCandReason::Depth))
    return;

  if (tryGreater(TryCand.IsLowLatency, Cand.IsLowLatency,
                 TryCand, Cand, SIScheduleCandReason::Depth))
    return;

  if (TryCand.IsLowLatency &&
      tryLess(TryCand.LowLatencyOffset, Cand.LowLatencyOffset,
              TryCand, Cand, SIScheduleCandReason::Depth))
    return;

  if (tryLess(TryCand.VGPRUsage, Cand.VGPRUsage, TryCand, Cand, RegUsage))
    return;

  // Fall through to original instruction order.
  if (TryCand.SU->NodeNum < Cand.SU->NodeNum) {
    TryCand.Reason = NodeOrder;
  }
}

SUnit* SIScheduleBlock::pickNode() {
  SISchedCandidate TopCand;

  for (SUnit* SU : TopReadySUs) {
    SISchedCandidate TryCand;
    std::vector<unsigned> pressure;
    std::vector<unsigned> MaxPressure;
    // Predict register usage after this instruction.
    TryCand.SU = SU;
    TopRPTracker.getDownwardPressure(SU->getInstr(), pressure, MaxPressure);
    TryCand.SGPRUsage = pressure[DAG->getSGPRSetID()];
    TryCand.VGPRUsage = pressure[DAG->getVGPRSetID()];
    TryCand.IsLowLatency = DAG->IsLowLatencySU[SU->NodeNum];
    TryCand.LowLatencyOffset = DAG->LowLatencyOffset[SU->NodeNum];
    TryCand.HasLowLatencyNonWaitedParent =
      HasLowLatencyNonWaitedParent[NodeNum2Index[SU->NodeNum]];
    tryCandidateTopDown(TopCand, TryCand);
    if (TryCand.Reason != NoCand)
      TopCand.setBest(TryCand);
  }

  return TopCand.SU;
}


// Schedule something valid.
void SIScheduleBlock::fastSchedule() {
  TopReadySUs.clear();
  if (Scheduled)
    undoSchedule();

  for (SUnit* SU : SUnits) {
    if (!SU->NumPredsLeft)
      TopReadySUs.push_back(SU);
  }

  while (!TopReadySUs.empty()) {
    SUnit *SU = TopReadySUs[0];
    ScheduledSUnits.push_back(SU);
    nodeScheduled(SU);
  }

  Scheduled = true;
}

// Returns if the register was set between first and last.
static bool isDefBetween(unsigned Reg,
                           SlotIndex First, SlotIndex Last,
                           const MachineRegisterInfo *MRI,
                           const LiveIntervals *LIS) {
  for (MachineRegisterInfo::def_instr_iterator
       UI = MRI->def_instr_begin(Reg),
       UE = MRI->def_instr_end(); UI != UE; ++UI) {
    const MachineInstr* MI = &*UI;
    if (MI->isDebugValue())
      continue;
    SlotIndex InstSlot = LIS->getInstructionIndex(*MI).getRegSlot();
    if (InstSlot >= First && InstSlot <= Last)
      return true;
  }
  return false;
}

void SIScheduleBlock::initRegPressure(MachineBasicBlock::iterator BeginBlock,
                                      MachineBasicBlock::iterator EndBlock) {
  IntervalPressure Pressure, BotPressure;
  RegPressureTracker RPTracker(Pressure), BotRPTracker(BotPressure);
  LiveIntervals *LIS = DAG->getLIS();
  MachineRegisterInfo *MRI = DAG->getMRI();
  DAG->initRPTracker(TopRPTracker);
  DAG->initRPTracker(BotRPTracker);
  DAG->initRPTracker(RPTracker);

  // Goes though all SU. RPTracker captures what had to be alive for the SUs
  // to execute, and what is still alive at the end.
  for (SUnit* SU : ScheduledSUnits) {
    RPTracker.setPos(SU->getInstr());
    RPTracker.advance();
  }

  // Close the RPTracker to finalize live ins/outs.
  RPTracker.closeRegion();

  // Initialize the live ins and live outs.
  TopRPTracker.addLiveRegs(RPTracker.getPressure().LiveInRegs);
  BotRPTracker.addLiveRegs(RPTracker.getPressure().LiveOutRegs);

  // Do not Track Physical Registers, because it messes up.
  for (const auto &RegMaskPair : RPTracker.getPressure().LiveInRegs) {
    if (TargetRegisterInfo::isVirtualRegister(RegMaskPair.RegUnit))
      LiveInRegs.insert(RegMaskPair.RegUnit);
  }
  LiveOutRegs.clear();
  // There is several possibilities to distinguish:
  // 1) Reg is not input to any instruction in the block, but is output of one
  // 2) 1) + read in the block and not needed after it
  // 3) 1) + read in the block but needed in another block
  // 4) Reg is input of an instruction but another block will read it too
  // 5) Reg is input of an instruction and then rewritten in the block.
  //    result is not read in the block (implies used in another block)
  // 6) Reg is input of an instruction and then rewritten in the block.
  //    result is read in the block and not needed in another block
  // 7) Reg is input of an instruction and then rewritten in the block.
  //    result is read in the block but also needed in another block
  // LiveInRegs will contains all the regs in situation 4, 5, 6, 7
  // We want LiveOutRegs to contain only Regs whose content will be read after
  // in another block, and whose content was written in the current block,
  // that is we want it to get 1, 3, 5, 7
  // Since we made the MIs of a block to be packed all together before
  // scheduling, then the LiveIntervals were correct, and the RPTracker was
  // able to correctly handle 5 vs 6, 2 vs 3.
  // (Note: This is not sufficient for RPTracker to not do mistakes for case 4)
  // The RPTracker's LiveOutRegs has 1, 3, (some correct or incorrect)4, 5, 7
  // Comparing to LiveInRegs is not sufficient to differenciate 4 vs 5, 7
  // The use of findDefBetween removes the case 4.
  for (const auto &RegMaskPair : RPTracker.getPressure().LiveOutRegs) {
    unsigned Reg = RegMaskPair.RegUnit;
    if (TargetRegisterInfo::isVirtualRegister(Reg) &&
        isDefBetween(Reg, LIS->getInstructionIndex(*BeginBlock).getRegSlot(),
                     LIS->getInstructionIndex(*EndBlock).getRegSlot(), MRI,
                     LIS)) {
      LiveOutRegs.insert(Reg);
    }
  }

  // Pressure = sum_alive_registers register size
  // Internally llvm will represent some registers as big 128 bits registers
  // for example, but they actually correspond to 4 actual 32 bits registers.
  // Thus Pressure is not equal to num_alive_registers * constant.
  LiveInPressure = TopPressure.MaxSetPressure;
  LiveOutPressure = BotPressure.MaxSetPressure;

  // Prepares TopRPTracker for top down scheduling.
  TopRPTracker.closeTop();
}

void SIScheduleBlock::schedule(MachineBasicBlock::iterator BeginBlock,
                               MachineBasicBlock::iterator EndBlock) {
  if (!Scheduled)
    fastSchedule();

  // PreScheduling phase to set LiveIn and LiveOut.
  initRegPressure(BeginBlock, EndBlock);
  undoSchedule();

  // Schedule for real now.

  TopReadySUs.clear();

  for (SUnit* SU : SUnits) {
    if (!SU->NumPredsLeft)
      TopReadySUs.push_back(SU);
  }

  while (!TopReadySUs.empty()) {
    SUnit *SU = pickNode();
    ScheduledSUnits.push_back(SU);
    TopRPTracker.setPos(SU->getInstr());
    TopRPTracker.advance();
    nodeScheduled(SU);
  }

  // TODO: compute InternalAdditionnalPressure.
  InternalAdditionnalPressure.resize(TopPressure.MaxSetPressure.size());

  // Check everything is right.
#ifndef NDEBUG
  assert(SUnits.size() == ScheduledSUnits.size() &&
            TopReadySUs.empty());
  for (SUnit* SU : SUnits) {
    assert(SU->isScheduled &&
              SU->NumPredsLeft == 0);
  }
#endif

  Scheduled = true;
}

void SIScheduleBlock::undoSchedule() {
  for (SUnit* SU : SUnits) {
    SU->isScheduled = false;
    for (SDep& Succ : SU->Succs) {
      if (BC->isSUInBlock(Succ.getSUnit(), ID))
        undoReleaseSucc(SU, &Succ);
    }
  }
  HasLowLatencyNonWaitedParent.assign(SUnits.size(), 0);
  ScheduledSUnits.clear();
  Scheduled = false;
}

void SIScheduleBlock::undoReleaseSucc(SUnit *SU, SDep *SuccEdge) {
  SUnit *SuccSU = SuccEdge->getSUnit();

  if (SuccEdge->isWeak()) {
    ++SuccSU->WeakPredsLeft;
    return;
  }
  ++SuccSU->NumPredsLeft;
}

void SIScheduleBlock::releaseSucc(SUnit *SU, SDep *SuccEdge) {
  SUnit *SuccSU = SuccEdge->getSUnit();

  if (SuccEdge->isWeak()) {
    --SuccSU->WeakPredsLeft;
    return;
  }
#ifndef NDEBUG
  if (SuccSU->NumPredsLeft == 0) {
    dbgs() << "*** Scheduling failed! ***\n";
    SuccSU->dump(DAG);
    dbgs() << " has been released too many times!\n";
    llvm_unreachable(nullptr);
  }
#endif

  --SuccSU->NumPredsLeft;
}

/// Release Successors of the SU that are in the block or not.
void SIScheduleBlock::releaseSuccessors(SUnit *SU, bool InOrOutBlock) {
  for (SDep& Succ : SU->Succs) {
    SUnit *SuccSU = Succ.getSUnit();

    if (SuccSU->NodeNum >= DAG->SUnits.size())
        continue;

    if (BC->isSUInBlock(SuccSU, ID) != InOrOutBlock)
      continue;

    releaseSucc(SU, &Succ);
    if (SuccSU->NumPredsLeft == 0 && InOrOutBlock)
      TopReadySUs.push_back(SuccSU);
  }
}

void SIScheduleBlock::nodeScheduled(SUnit *SU) {
  // Is in TopReadySUs
  assert (!SU->NumPredsLeft);
  std::vector<SUnit *>::iterator I = llvm::find(TopReadySUs, SU);
  if (I == TopReadySUs.end()) {
    dbgs() << "Data Structure Bug in SI Scheduler\n";
    llvm_unreachable(nullptr);
  }
  TopReadySUs.erase(I);

  releaseSuccessors(SU, true);
  // Scheduling this node will trigger a wait,
  // thus propagate to other instructions that they do not need to wait either.
  if (HasLowLatencyNonWaitedParent[NodeNum2Index[SU->NodeNum]])
    HasLowLatencyNonWaitedParent.assign(SUnits.size(), 0);

  if (DAG->IsLowLatencySU[SU->NodeNum]) {
     for (SDep& Succ : SU->Succs) {
      std::map<unsigned, unsigned>::iterator I =
        NodeNum2Index.find(Succ.getSUnit()->NodeNum);
      if (I != NodeNum2Index.end())
        HasLowLatencyNonWaitedParent[I->second] = 1;
    }
  }
  SU->isScheduled = true;
}

void SIScheduleBlock::finalizeUnits() {
  // We remove links from outside blocks to enable scheduling inside the block.
  for (SUnit* SU : SUnits) {
    releaseSuccessors(SU, false);
    if (DAG->IsHighLatencySU[SU->NodeNum])
      HighLatencyBlock = true;
  }
  HasLowLatencyNonWaitedParent.resize(SUnits.size(), 0);
}

// we maintain ascending order of IDs
void SIScheduleBlock::addPred(SIScheduleBlock *Pred) {
  unsigned PredID = Pred->getID();

  // Check if not already predecessor.
  for (SIScheduleBlock* P : Preds) {
    if (PredID == P->getID())
      return;
  }
  Preds.push_back(Pred);

  assert(none_of(Succs,
                 [=](SIScheduleBlock *S) { return PredID == S->getID(); }) &&
         "Loop in the Block Graph!");
}

void SIScheduleBlock::addSucc(SIScheduleBlock *Succ) {
  unsigned SuccID = Succ->getID();

  // Check if not already predecessor.
  for (SIScheduleBlock* S : Succs) {
    if (SuccID == S->getID())
      return;
  }
  if (Succ->isHighLatencyBlock())
    ++NumHighLatencySuccessors;
  Succs.push_back(Succ);
  assert(none_of(Preds,
                 [=](SIScheduleBlock *P) { return SuccID == P->getID(); }) &&
         "Loop in the Block Graph!");
}

#ifndef NDEBUG
void SIScheduleBlock::printDebug(bool full) {
  dbgs() << "Block (" << ID << ")\n";
  if (!full)
    return;

  dbgs() << "\nContains High Latency Instruction: "
         << HighLatencyBlock << '\n';
  dbgs() << "\nDepends On:\n";
  for (SIScheduleBlock* P : Preds) {
    P->printDebug(false);
  }

  dbgs() << "\nSuccessors:\n";
  for (SIScheduleBlock* S : Succs) {
    S->printDebug(false);
  }

  if (Scheduled) {
    dbgs() << "LiveInPressure " << LiveInPressure[DAG->getSGPRSetID()] << ' '
           << LiveInPressure[DAG->getVGPRSetID()] << '\n';
    dbgs() << "LiveOutPressure " << LiveOutPressure[DAG->getSGPRSetID()] << ' '
           << LiveOutPressure[DAG->getVGPRSetID()] << "\n\n";
    dbgs() << "LiveIns:\n";
    for (unsigned Reg : LiveInRegs)
      dbgs() << PrintVRegOrUnit(Reg, DAG->getTRI()) << ' ';

    dbgs() << "\nLiveOuts:\n";
    for (unsigned Reg : LiveOutRegs)
      dbgs() << PrintVRegOrUnit(Reg, DAG->getTRI()) << ' ';
  }

  dbgs() << "\nInstructions:\n";
  if (!Scheduled) {
    for (SUnit* SU : SUnits) {
      SU->dump(DAG);
    }
  } else {
    for (SUnit* SU : SUnits) {
      SU->dump(DAG);
    }
  }

  dbgs() << "///////////////////////\n";
}
#endif

// SIScheduleBlockCreator //

SIScheduleBlockCreator::SIScheduleBlockCreator(SIScheduleDAGMI *DAG) :
DAG(DAG) {
}

SIScheduleBlockCreator::~SIScheduleBlockCreator() = default;

SIScheduleBlocks
SIScheduleBlockCreator::getBlocks(SISchedulerBlockCreatorVariant BlockVariant) {
  std::map<SISchedulerBlockCreatorVariant, SIScheduleBlocks>::iterator B =
    Blocks.find(BlockVariant);
  if (B == Blocks.end()) {
    SIScheduleBlocks Res;
    createBlocksForVariant(BlockVariant);
    topologicalSort();
    scheduleInsideBlocks();
    fillStats();
    Res.Blocks = CurrentBlocks;
    Res.TopDownIndex2Block = TopDownIndex2Block;
    Res.TopDownBlock2Index = TopDownBlock2Index;
    Blocks[BlockVariant] = Res;
    return Res;
  } else {
    return B->second;
  }
}

bool SIScheduleBlockCreator::isSUInBlock(SUnit *SU, unsigned ID) {
  if (SU->NodeNum >= DAG->SUnits.size())
    return false;
  return CurrentBlocks[Node2CurrentBlock[SU->NodeNum]]->getID() == ID;
}

void SIScheduleBlockCreator::colorHighLatenciesAlone() {
  unsigned DAGSize = DAG->SUnits.size();

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SUnit *SU = &DAG->SUnits[i];
    if (DAG->IsHighLatencySU[SU->NodeNum]) {
      CurrentColoring[SU->NodeNum] = NextReservedID++;
    }
  }
}

void SIScheduleBlockCreator::colorHighLatenciesGroups() {
  unsigned DAGSize = DAG->SUnits.size();
  unsigned NumHighLatencies = 0;
  unsigned GroupSize;
  unsigned Color = NextReservedID;
  unsigned Count = 0;
  std::set<unsigned> FormingGroup;

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SUnit *SU = &DAG->SUnits[i];
    if (DAG->IsHighLatencySU[SU->NodeNum])
      ++NumHighLatencies;
  }

  if (NumHighLatencies == 0)
    return;

  if (NumHighLatencies <= 6)
    GroupSize = 2;
  else if (NumHighLatencies <= 12)
    GroupSize = 3;
  else
    GroupSize = 4;

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SUnit *SU = &DAG->SUnits[i];
    if (DAG->IsHighLatencySU[SU->NodeNum]) {
      unsigned CompatibleGroup = true;
      unsigned ProposedColor = Color;
      for (unsigned j : FormingGroup) {
        // TODO: Currently CompatibleGroup will always be false,
        // because the graph enforces the load order. This
        // can be fixed, but as keeping the load order is often
        // good for performance that causes a performance hit (both
        // the default scheduler and this scheduler).
        // When this scheduler determines a good load order,
        // this can be fixed.
        if (!DAG->canAddEdge(SU, &DAG->SUnits[j]) ||
            !DAG->canAddEdge(&DAG->SUnits[j], SU))
          CompatibleGroup = false;
      }
      if (!CompatibleGroup || ++Count == GroupSize) {
        FormingGroup.clear();
        Color = ++NextReservedID;
        if (!CompatibleGroup) {
          ProposedColor = Color;
          FormingGroup.insert(SU->NodeNum);
        }
        Count = 0;
      } else {
        FormingGroup.insert(SU->NodeNum);
      }
      CurrentColoring[SU->NodeNum] = ProposedColor;
    }
  }
}

void SIScheduleBlockCreator::colorComputeReservedDependencies() {
  unsigned DAGSize = DAG->SUnits.size();
  std::map<std::set<unsigned>, unsigned> ColorCombinations;

  CurrentTopDownReservedDependencyColoring.clear();
  CurrentBottomUpReservedDependencyColoring.clear();

  CurrentTopDownReservedDependencyColoring.resize(DAGSize, 0);
  CurrentBottomUpReservedDependencyColoring.resize(DAGSize, 0);

  // Traverse TopDown, and give different colors to SUs depending
  // on which combination of High Latencies they depend on.

  for (unsigned SUNum : DAG->TopDownIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    std::set<unsigned> SUColors;

    // Already given.
    if (CurrentColoring[SU->NodeNum]) {
      CurrentTopDownReservedDependencyColoring[SU->NodeNum] =
        CurrentColoring[SU->NodeNum];
      continue;
    }

   for (SDep& PredDep : SU->Preds) {
      SUnit *Pred = PredDep.getSUnit();
      if (PredDep.isWeak() || Pred->NodeNum >= DAGSize)
        continue;
      if (CurrentTopDownReservedDependencyColoring[Pred->NodeNum] > 0)
        SUColors.insert(CurrentTopDownReservedDependencyColoring[Pred->NodeNum]);
    }
    // Color 0 by default.
    if (SUColors.empty())
      continue;
    // Same color than parents.
    if (SUColors.size() == 1 && *SUColors.begin() > DAGSize)
      CurrentTopDownReservedDependencyColoring[SU->NodeNum] =
        *SUColors.begin();
    else {
      std::map<std::set<unsigned>, unsigned>::iterator Pos =
        ColorCombinations.find(SUColors);
      if (Pos != ColorCombinations.end()) {
          CurrentTopDownReservedDependencyColoring[SU->NodeNum] = Pos->second;
      } else {
        CurrentTopDownReservedDependencyColoring[SU->NodeNum] =
          NextNonReservedID;
        ColorCombinations[SUColors] = NextNonReservedID++;
      }
    }
  }

  ColorCombinations.clear();

  // Same as before, but BottomUp.

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    std::set<unsigned> SUColors;

    // Already given.
    if (CurrentColoring[SU->NodeNum]) {
      CurrentBottomUpReservedDependencyColoring[SU->NodeNum] =
        CurrentColoring[SU->NodeNum];
      continue;
    }

    for (SDep& SuccDep : SU->Succs) {
      SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      if (CurrentBottomUpReservedDependencyColoring[Succ->NodeNum] > 0)
        SUColors.insert(CurrentBottomUpReservedDependencyColoring[Succ->NodeNum]);
    }
    // Keep color 0.
    if (SUColors.empty())
      continue;
    // Same color than parents.
    if (SUColors.size() == 1 && *SUColors.begin() > DAGSize)
      CurrentBottomUpReservedDependencyColoring[SU->NodeNum] =
        *SUColors.begin();
    else {
      std::map<std::set<unsigned>, unsigned>::iterator Pos =
        ColorCombinations.find(SUColors);
      if (Pos != ColorCombinations.end()) {
        CurrentBottomUpReservedDependencyColoring[SU->NodeNum] = Pos->second;
      } else {
        CurrentBottomUpReservedDependencyColoring[SU->NodeNum] =
          NextNonReservedID;
        ColorCombinations[SUColors] = NextNonReservedID++;
      }
    }
  }
}

void SIScheduleBlockCreator::colorAccordingToReservedDependencies() {
  unsigned DAGSize = DAG->SUnits.size();
  std::map<std::pair<unsigned, unsigned>, unsigned> ColorCombinations;

  // Every combination of colors given by the top down
  // and bottom up Reserved node dependency

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SUnit *SU = &DAG->SUnits[i];
    std::pair<unsigned, unsigned> SUColors;

    // High latency instructions: already given.
    if (CurrentColoring[SU->NodeNum])
      continue;

    SUColors.first = CurrentTopDownReservedDependencyColoring[SU->NodeNum];
    SUColors.second = CurrentBottomUpReservedDependencyColoring[SU->NodeNum];

    std::map<std::pair<unsigned, unsigned>, unsigned>::iterator Pos =
      ColorCombinations.find(SUColors);
    if (Pos != ColorCombinations.end()) {
      CurrentColoring[SU->NodeNum] = Pos->second;
    } else {
      CurrentColoring[SU->NodeNum] = NextNonReservedID;
      ColorCombinations[SUColors] = NextNonReservedID++;
    }
  }
}

void SIScheduleBlockCreator::colorEndsAccordingToDependencies() {
  unsigned DAGSize = DAG->SUnits.size();
  std::vector<int> PendingColoring = CurrentColoring;

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    std::set<unsigned> SUColors;
    std::set<unsigned> SUColorsPending;

    if (CurrentColoring[SU->NodeNum] <= (int)DAGSize)
      continue;

    if (CurrentBottomUpReservedDependencyColoring[SU->NodeNum] > 0 ||
        CurrentTopDownReservedDependencyColoring[SU->NodeNum] > 0)
      continue;

    for (SDep& SuccDep : SU->Succs) {
      SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      if (CurrentBottomUpReservedDependencyColoring[Succ->NodeNum] > 0 ||
          CurrentTopDownReservedDependencyColoring[Succ->NodeNum] > 0)
        SUColors.insert(CurrentColoring[Succ->NodeNum]);
      SUColorsPending.insert(PendingColoring[Succ->NodeNum]);
    }
    if (SUColors.size() == 1 && SUColorsPending.size() == 1)
      PendingColoring[SU->NodeNum] = *SUColors.begin();
    else // TODO: Attribute new colors depending on color
         // combination of children.
      PendingColoring[SU->NodeNum] = NextNonReservedID++;
  }
  CurrentColoring = PendingColoring;
}


void SIScheduleBlockCreator::colorForceConsecutiveOrderInGroup() {
  unsigned DAGSize = DAG->SUnits.size();
  unsigned PreviousColor;
  std::set<unsigned> SeenColors;

  if (DAGSize <= 1)
    return;

  PreviousColor = CurrentColoring[0];

  for (unsigned i = 1, e = DAGSize; i != e; ++i) {
    SUnit *SU = &DAG->SUnits[i];
    unsigned CurrentColor = CurrentColoring[i];
    unsigned PreviousColorSave = PreviousColor;
    assert(i == SU->NodeNum);

    if (CurrentColor != PreviousColor)
      SeenColors.insert(PreviousColor);
    PreviousColor = CurrentColor;

    if (CurrentColoring[SU->NodeNum] <= (int)DAGSize)
      continue;

    if (SeenColors.find(CurrentColor) == SeenColors.end())
      continue;

    if (PreviousColorSave != CurrentColor)
      CurrentColoring[i] = NextNonReservedID++;
    else
      CurrentColoring[i] = CurrentColoring[i-1];
  }
}

void SIScheduleBlockCreator::colorMergeConstantLoadsNextGroup() {
  unsigned DAGSize = DAG->SUnits.size();

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    std::set<unsigned> SUColors;

    if (CurrentColoring[SU->NodeNum] <= (int)DAGSize)
      continue;

    // No predecessor: Vgpr constant loading.
    // Low latency instructions usually have a predecessor (the address)
    if (SU->Preds.size() > 0 && !DAG->IsLowLatencySU[SU->NodeNum])
      continue;

    for (SDep& SuccDep : SU->Succs) {
      SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      SUColors.insert(CurrentColoring[Succ->NodeNum]);
    }
    if (SUColors.size() == 1)
      CurrentColoring[SU->NodeNum] = *SUColors.begin();
  }
}

void SIScheduleBlockCreator::colorMergeIfPossibleNextGroup() {
  unsigned DAGSize = DAG->SUnits.size();

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    std::set<unsigned> SUColors;

    if (CurrentColoring[SU->NodeNum] <= (int)DAGSize)
      continue;

    for (SDep& SuccDep : SU->Succs) {
       SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      SUColors.insert(CurrentColoring[Succ->NodeNum]);
    }
    if (SUColors.size() == 1)
      CurrentColoring[SU->NodeNum] = *SUColors.begin();
  }
}

void SIScheduleBlockCreator::colorMergeIfPossibleNextGroupOnlyForReserved() {
  unsigned DAGSize = DAG->SUnits.size();

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    std::set<unsigned> SUColors;

    if (CurrentColoring[SU->NodeNum] <= (int)DAGSize)
      continue;

    for (SDep& SuccDep : SU->Succs) {
       SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      SUColors.insert(CurrentColoring[Succ->NodeNum]);
    }
    if (SUColors.size() == 1 && *SUColors.begin() <= DAGSize)
      CurrentColoring[SU->NodeNum] = *SUColors.begin();
  }
}

void SIScheduleBlockCreator::colorMergeIfPossibleSmallGroupsToNextGroup() {
  unsigned DAGSize = DAG->SUnits.size();
  std::map<unsigned, unsigned> ColorCount;

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    unsigned color = CurrentColoring[SU->NodeNum];
    std::map<unsigned, unsigned>::iterator Pos = ColorCount.find(color);
      if (Pos != ColorCount.end()) {
        ++ColorCount[color];
      } else {
        ColorCount[color] = 1;
      }
  }

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    unsigned color = CurrentColoring[SU->NodeNum];
    std::set<unsigned> SUColors;

    if (CurrentColoring[SU->NodeNum] <= (int)DAGSize)
      continue;

    if (ColorCount[color] > 1)
      continue;

    for (SDep& SuccDep : SU->Succs) {
       SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      SUColors.insert(CurrentColoring[Succ->NodeNum]);
    }
    if (SUColors.size() == 1 && *SUColors.begin() != color) {
      --ColorCount[color];
      CurrentColoring[SU->NodeNum] = *SUColors.begin();
      ++ColorCount[*SUColors.begin()];
    }
  }
}

void SIScheduleBlockCreator::cutHugeBlocks() {
  // TODO
}

void SIScheduleBlockCreator::regroupNoUserInstructions() {
  unsigned DAGSize = DAG->SUnits.size();
  int GroupID = NextNonReservedID++;

  for (unsigned SUNum : DAG->BottomUpIndex2SU) {
    SUnit *SU = &DAG->SUnits[SUNum];
    bool hasSuccessor = false;

    if (CurrentColoring[SU->NodeNum] <= (int)DAGSize)
      continue;

    for (SDep& SuccDep : SU->Succs) {
       SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      hasSuccessor = true;
    }
    if (!hasSuccessor)
      CurrentColoring[SU->NodeNum] = GroupID;
  }
}

void SIScheduleBlockCreator::createBlocksForVariant(SISchedulerBlockCreatorVariant BlockVariant) {
  unsigned DAGSize = DAG->SUnits.size();
  std::map<unsigned,unsigned> RealID;

  CurrentBlocks.clear();
  CurrentColoring.clear();
  CurrentColoring.resize(DAGSize, 0);
  Node2CurrentBlock.clear();

  // Restore links previous scheduling variant has overridden.
  DAG->restoreSULinksLeft();

  NextReservedID = 1;
  NextNonReservedID = DAGSize + 1;

  DEBUG(dbgs() << "Coloring the graph\n");

  if (BlockVariant == SISchedulerBlockCreatorVariant::LatenciesGrouped)
    colorHighLatenciesGroups();
  else
    colorHighLatenciesAlone();
  colorComputeReservedDependencies();
  colorAccordingToReservedDependencies();
  colorEndsAccordingToDependencies();
  if (BlockVariant == SISchedulerBlockCreatorVariant::LatenciesAlonePlusConsecutive)
    colorForceConsecutiveOrderInGroup();
  regroupNoUserInstructions();
  colorMergeConstantLoadsNextGroup();
  colorMergeIfPossibleNextGroupOnlyForReserved();

  // Put SUs of same color into same block
  Node2CurrentBlock.resize(DAGSize, -1);
  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SUnit *SU = &DAG->SUnits[i];
    unsigned Color = CurrentColoring[SU->NodeNum];
    if (RealID.find(Color) == RealID.end()) {
      int ID = CurrentBlocks.size();
      BlockPtrs.push_back(llvm::make_unique<SIScheduleBlock>(DAG, this, ID));
      CurrentBlocks.push_back(BlockPtrs.rbegin()->get());
      RealID[Color] = ID;
    }
    CurrentBlocks[RealID[Color]]->addUnit(SU);
    Node2CurrentBlock[SU->NodeNum] = RealID[Color];
  }

  // Build dependencies between blocks.
  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SUnit *SU = &DAG->SUnits[i];
    int SUID = Node2CurrentBlock[i];
     for (SDep& SuccDep : SU->Succs) {
       SUnit *Succ = SuccDep.getSUnit();
      if (SuccDep.isWeak() || Succ->NodeNum >= DAGSize)
        continue;
      if (Node2CurrentBlock[Succ->NodeNum] != SUID)
        CurrentBlocks[SUID]->addSucc(CurrentBlocks[Node2CurrentBlock[Succ->NodeNum]]);
    }
    for (SDep& PredDep : SU->Preds) {
      SUnit *Pred = PredDep.getSUnit();
      if (PredDep.isWeak() || Pred->NodeNum >= DAGSize)
        continue;
      if (Node2CurrentBlock[Pred->NodeNum] != SUID)
        CurrentBlocks[SUID]->addPred(CurrentBlocks[Node2CurrentBlock[Pred->NodeNum]]);
    }
  }

  // Free root and leafs of all blocks to enable scheduling inside them.
  for (unsigned i = 0, e = CurrentBlocks.size(); i != e; ++i) {
    SIScheduleBlock *Block = CurrentBlocks[i];
    Block->finalizeUnits();
  }
  DEBUG(
    dbgs() << "Blocks created:\n\n";
    for (unsigned i = 0, e = CurrentBlocks.size(); i != e; ++i) {
      SIScheduleBlock *Block = CurrentBlocks[i];
      Block->printDebug(true);
    }
  );
}

// Two functions taken from Codegen/MachineScheduler.cpp

/// Non-const version.
static MachineBasicBlock::iterator
nextIfDebug(MachineBasicBlock::iterator I,
            MachineBasicBlock::const_iterator End) {
  for (; I != End; ++I) {
    if (!I->isDebugValue())
      break;
  }
  return I;
}

void SIScheduleBlockCreator::topologicalSort() {
  unsigned DAGSize = CurrentBlocks.size();
  std::vector<int> WorkList;

  DEBUG(dbgs() << "Topological Sort\n");

  WorkList.reserve(DAGSize);
  TopDownIndex2Block.resize(DAGSize);
  TopDownBlock2Index.resize(DAGSize);
  BottomUpIndex2Block.resize(DAGSize);

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SIScheduleBlock *Block = CurrentBlocks[i];
    unsigned Degree = Block->getSuccs().size();
    TopDownBlock2Index[i] = Degree;
    if (Degree == 0) {
      WorkList.push_back(i);
    }
  }

  int Id = DAGSize;
  while (!WorkList.empty()) {
    int i = WorkList.back();
    SIScheduleBlock *Block = CurrentBlocks[i];
    WorkList.pop_back();
    TopDownBlock2Index[i] = --Id;
    TopDownIndex2Block[Id] = i;
    for (SIScheduleBlock* Pred : Block->getPreds()) {
      if (!--TopDownBlock2Index[Pred->getID()])
        WorkList.push_back(Pred->getID());
    }
  }

#ifndef NDEBUG
  // Check correctness of the ordering.
  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SIScheduleBlock *Block = CurrentBlocks[i];
    for (SIScheduleBlock* Pred : Block->getPreds()) {
      assert(TopDownBlock2Index[i] > TopDownBlock2Index[Pred->getID()] &&
      "Wrong Top Down topological sorting");
    }
  }
#endif

  BottomUpIndex2Block = std::vector<int>(TopDownIndex2Block.rbegin(),
                                         TopDownIndex2Block.rend());
}

void SIScheduleBlockCreator::scheduleInsideBlocks() {
  unsigned DAGSize = CurrentBlocks.size();

  DEBUG(dbgs() << "\nScheduling Blocks\n\n");

  // We do schedule a valid scheduling such that a Block corresponds
  // to a range of instructions.
  DEBUG(dbgs() << "First phase: Fast scheduling for Reg Liveness\n");
  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SIScheduleBlock *Block = CurrentBlocks[i];
    Block->fastSchedule();
  }

  // Note: the following code, and the part restoring previous position
  // is by far the most expensive operation of the Scheduler.

  // Do not update CurrentTop.
  MachineBasicBlock::iterator CurrentTopFastSched = DAG->getCurrentTop();
  std::vector<MachineBasicBlock::iterator> PosOld;
  std::vector<MachineBasicBlock::iterator> PosNew;
  PosOld.reserve(DAG->SUnits.size());
  PosNew.reserve(DAG->SUnits.size());

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    int BlockIndice = TopDownIndex2Block[i];
    SIScheduleBlock *Block = CurrentBlocks[BlockIndice];
    std::vector<SUnit*> SUs = Block->getScheduledUnits();

    for (SUnit* SU : SUs) {
      MachineInstr *MI = SU->getInstr();
      MachineBasicBlock::iterator Pos = MI;
      PosOld.push_back(Pos);
      if (&*CurrentTopFastSched == MI) {
        PosNew.push_back(Pos);
        CurrentTopFastSched = nextIfDebug(++CurrentTopFastSched,
                                          DAG->getCurrentBottom());
      } else {
        // Update the instruction stream.
        DAG->getBB()->splice(CurrentTopFastSched, DAG->getBB(), MI);

        // Update LiveIntervals.
        // Note: Moving all instructions and calling handleMove every time
        // is the most cpu intensive operation of the scheduler.
        // It would gain a lot if there was a way to recompute the
        // LiveIntervals for the entire scheduling region.
        DAG->getLIS()->handleMove(*MI, /*UpdateFlags=*/true);
        PosNew.push_back(CurrentTopFastSched);
      }
    }
  }

  // Now we have Block of SUs == Block of MI.
  // We do the final schedule for the instructions inside the block.
  // The property that all the SUs of the Block are grouped together as MI
  // is used for correct reg usage tracking.
  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    SIScheduleBlock *Block = CurrentBlocks[i];
    std::vector<SUnit*> SUs = Block->getScheduledUnits();
    Block->schedule((*SUs.begin())->getInstr(), (*SUs.rbegin())->getInstr());
  }

  DEBUG(dbgs() << "Restoring MI Pos\n");
  // Restore old ordering (which prevents a LIS->handleMove bug).
  for (unsigned i = PosOld.size(), e = 0; i != e; --i) {
    MachineBasicBlock::iterator POld = PosOld[i-1];
    MachineBasicBlock::iterator PNew = PosNew[i-1];
    if (PNew != POld) {
      // Update the instruction stream.
      DAG->getBB()->splice(POld, DAG->getBB(), PNew);

      // Update LiveIntervals.
      DAG->getLIS()->handleMove(*POld, /*UpdateFlags=*/true);
    }
  }

  DEBUG(
    for (unsigned i = 0, e = CurrentBlocks.size(); i != e; ++i) {
      SIScheduleBlock *Block = CurrentBlocks[i];
      Block->printDebug(true);
    }
  );
}

void SIScheduleBlockCreator::fillStats() {
  unsigned DAGSize = CurrentBlocks.size();

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    int BlockIndice = TopDownIndex2Block[i];
    SIScheduleBlock *Block = CurrentBlocks[BlockIndice];
    if (Block->getPreds().empty())
      Block->Depth = 0;
    else {
      unsigned Depth = 0;
      for (SIScheduleBlock *Pred : Block->getPreds()) {
        if (Depth < Pred->Depth + 1)
          Depth = Pred->Depth + 1;
      }
      Block->Depth = Depth;
    }
  }

  for (unsigned i = 0, e = DAGSize; i != e; ++i) {
    int BlockIndice = BottomUpIndex2Block[i];
    SIScheduleBlock *Block = CurrentBlocks[BlockIndice];
    if (Block->getSuccs().empty())
      Block->Height = 0;
    else {
      unsigned Height = 0;
      for (SIScheduleBlock *Succ : Block->getSuccs()) {
        if (Height < Succ->Height + 1)
          Height = Succ->Height + 1;
      }
      Block->Height = Height;
    }
  }
}

// SIScheduleBlockScheduler //

SIScheduleBlockScheduler::SIScheduleBlockScheduler(SIScheduleDAGMI *DAG,
                                                   SISchedulerBlockSchedulerVariant Variant,
                                                   SIScheduleBlocks  BlocksStruct) :
  DAG(DAG), Variant(Variant), Blocks(BlocksStruct.Blocks),
  LastPosWaitedHighLatency(0), NumBlockScheduled(0), VregCurrentUsage(0),
  SregCurrentUsage(0), maxVregUsage(0), maxSregUsage(0) {

  // Fill the usage of every output
  // Warning: while by construction we always have a link between two blocks
  // when one needs a result from the other, the number of users of an output
  // is not the sum of child blocks having as input the same virtual register.
  // Here is an example. A produces x and y. B eats x and produces x'.
  // C eats x' and y. The register coalescer may have attributed the same
  // virtual register to x and x'.
  // To count accurately, we do a topological sort. In case the register is
  // found for several parents, we increment the usage of the one with the
  // highest topological index.
  LiveOutRegsNumUsages.resize(Blocks.size());
  for (unsigned i = 0, e = Blocks.size(); i != e; ++i) {
    SIScheduleBlock *Block = Blocks[i];
    for (unsigned Reg : Block->getInRegs()) {
      bool Found = false;
      int topoInd = -1;
      for (SIScheduleBlock* Pred: Block->getPreds()) {
        std::set<unsigned> PredOutRegs = Pred->getOutRegs();
        std::set<unsigned>::iterator RegPos = PredOutRegs.find(Reg);

        if (RegPos != PredOutRegs.end()) {
          Found = true;
          if (topoInd < BlocksStruct.TopDownBlock2Index[Pred->getID()]) {
            topoInd = BlocksStruct.TopDownBlock2Index[Pred->getID()];
          }
        }
      }

      if (!Found)
        continue;

      int PredID = BlocksStruct.TopDownIndex2Block[topoInd];
      std::map<unsigned, unsigned>::iterator RegPos =
        LiveOutRegsNumUsages[PredID].find(Reg);
      if (RegPos != LiveOutRegsNumUsages[PredID].end()) {
        ++LiveOutRegsNumUsages[PredID][Reg];
      } else {
        LiveOutRegsNumUsages[PredID][Reg] = 1;
      }
    }
  }

  LastPosHighLatencyParentScheduled.resize(Blocks.size(), 0);
  BlockNumPredsLeft.resize(Blocks.size());
  BlockNumSuccsLeft.resize(Blocks.size());

  for (unsigned i = 0, e = Blocks.size(); i != e; ++i) {
    SIScheduleBlock *Block = Blocks[i];
    BlockNumPredsLeft[i] = Block->getPreds().size();
    BlockNumSuccsLeft[i] = Block->getSuccs().size();
  }

#ifndef NDEBUG
  for (unsigned i = 0, e = Blocks.size(); i != e; ++i) {
    SIScheduleBlock *Block = Blocks[i];
    assert(Block->getID() == i);
  }
#endif

  std::set<unsigned> InRegs = DAG->getInRegs();
  addLiveRegs(InRegs);

  // Fill LiveRegsConsumers for regs that were already
  // defined before scheduling.
  for (unsigned i = 0, e = Blocks.size(); i != e; ++i) {
    SIScheduleBlock *Block = Blocks[i];
    for (unsigned Reg : Block->getInRegs()) {
      bool Found = false;
      for (SIScheduleBlock* Pred: Block->getPreds()) {
        std::set<unsigned> PredOutRegs = Pred->getOutRegs();
        std::set<unsigned>::iterator RegPos = PredOutRegs.find(Reg);

        if (RegPos != PredOutRegs.end()) {
          Found = true;
          break;
        }
      }

      if (!Found) {
        if (LiveRegsConsumers.find(Reg) == LiveRegsConsumers.end())
          LiveRegsConsumers[Reg] = 1;
        else
          ++LiveRegsConsumers[Reg];
      }
    }
  }

  for (unsigned i = 0, e = Blocks.size(); i != e; ++i) {
    SIScheduleBlock *Block = Blocks[i];
    if (BlockNumPredsLeft[i] == 0) {
      ReadyBlocks.push_back(Block);
    }
  }

  while (SIScheduleBlock *Block = pickBlock()) {
    BlocksScheduled.push_back(Block);
    blockScheduled(Block);
  }

  DEBUG(
    dbgs() << "Block Order:";
    for (SIScheduleBlock* Block : BlocksScheduled) {
      dbgs() << ' ' << Block->getID();
    }
    dbgs() << '\n';
  );
}

bool SIScheduleBlockScheduler::tryCandidateLatency(SIBlockSchedCandidate &Cand,
                                                   SIBlockSchedCandidate &TryCand) {
  if (!Cand.isValid()) {
    TryCand.Reason = NodeOrder;
    return true;
  }

  // Try to hide high latencies.
  if (tryLess(TryCand.LastPosHighLatParentScheduled,
              Cand.LastPosHighLatParentScheduled, TryCand, Cand, Latency))
    return true;
  // Schedule high latencies early so you can hide them better.
  if (tryGreater(TryCand.IsHighLatency, Cand.IsHighLatency,
                 TryCand, Cand, Latency))
    return true;
  if (TryCand.IsHighLatency && tryGreater(TryCand.Height, Cand.Height,
                                          TryCand, Cand, Depth))
    return true;
  if (tryGreater(TryCand.NumHighLatencySuccessors,
                 Cand.NumHighLatencySuccessors,
                 TryCand, Cand, Successor))
    return true;
  return false;
}

bool SIScheduleBlockScheduler::tryCandidateRegUsage(SIBlockSchedCandidate &Cand,
                                                    SIBlockSchedCandidate &TryCand) {
  if (!Cand.isValid()) {
    TryCand.Reason = NodeOrder;
    return true;
  }

  if (tryLess(TryCand.VGPRUsageDiff > 0, Cand.VGPRUsageDiff > 0,
              TryCand, Cand, RegUsage))
    return true;
  if (tryGreater(TryCand.NumSuccessors > 0,
                 Cand.NumSuccessors > 0,
                 TryCand, Cand, Successor))
    return true;
  if (tryGreater(TryCand.Height, Cand.Height, TryCand, Cand, Depth))
    return true;
  if (tryLess(TryCand.VGPRUsageDiff, Cand.VGPRUsageDiff,
              TryCand, Cand, RegUsage))
    return true;
  return false;
}

SIScheduleBlock *SIScheduleBlockScheduler::pickBlock() {
  SIBlockSchedCandidate Cand;
  std::vector<SIScheduleBlock*>::iterator Best;
  SIScheduleBlock *Block;
  if (ReadyBlocks.empty())
    return nullptr;

  DAG->fillVgprSgprCost(LiveRegs.begin(), LiveRegs.end(),
                        VregCurrentUsage, SregCurrentUsage);
  if (VregCurrentUsage > maxVregUsage)
    maxVregUsage = VregCurrentUsage;
  if (SregCurrentUsage > maxSregUsage)
    maxSregUsage = SregCurrentUsage;
  DEBUG(
    dbgs() << "Picking New Blocks\n";
    dbgs() << "Available: ";
    for (SIScheduleBlock* Block : ReadyBlocks)
      dbgs() << Block->getID() << ' ';
    dbgs() << "\nCurrent Live:\n";
    for (unsigned Reg : LiveRegs)
      dbgs() << PrintVRegOrUnit(Reg, DAG->getTRI()) << ' ';
    dbgs() << '\n';
    dbgs() << "Current VGPRs: " << VregCurrentUsage << '\n';
    dbgs() << "Current SGPRs: " << SregCurrentUsage << '\n';
  );

  Cand.Block = nullptr;
  for (std::vector<SIScheduleBlock*>::iterator I = ReadyBlocks.begin(),
       E = ReadyBlocks.end(); I != E; ++I) {
    SIBlockSchedCandidate TryCand;
    TryCand.Block = *I;
    TryCand.IsHighLatency = TryCand.Block->isHighLatencyBlock();
    TryCand.VGPRUsageDiff =
      checkRegUsageImpact(TryCand.Block->getInRegs(),
                          TryCand.Block->getOutRegs())[DAG->getVGPRSetID()];
    TryCand.NumSuccessors = TryCand.Block->getSuccs().size();
    TryCand.NumHighLatencySuccessors =
      TryCand.Block->getNumHighLatencySuccessors();
    TryCand.LastPosHighLatParentScheduled =
      (unsigned int) std::max<int> (0,
         LastPosHighLatencyParentScheduled[TryCand.Block->getID()] -
           LastPosWaitedHighLatency);
    TryCand.Height = TryCand.Block->Height;
    // Try not to increase VGPR usage too much, else we may spill.
    if (VregCurrentUsage > 120 ||
        Variant != SISchedulerBlockSchedulerVariant::BlockLatencyRegUsage) {
      if (!tryCandidateRegUsage(Cand, TryCand) &&
          Variant != SISchedulerBlockSchedulerVariant::BlockRegUsage)
        tryCandidateLatency(Cand, TryCand);
    } else {
      if (!tryCandidateLatency(Cand, TryCand))
        tryCandidateRegUsage(Cand, TryCand);
    }
    if (TryCand.Reason != NoCand) {
      Cand.setBest(TryCand);
      Best = I;
      DEBUG(dbgs() << "Best Current Choice: " << Cand.Block->getID() << ' '
                   << getReasonStr(Cand.Reason) << '\n');
    }
  }

  DEBUG(
    dbgs() << "Picking: " << Cand.Block->getID() << '\n';
    dbgs() << "Is a block with high latency instruction: "
      << (Cand.IsHighLatency ? "yes\n" : "no\n");
    dbgs() << "Position of last high latency dependency: "
           << Cand.LastPosHighLatParentScheduled << '\n';
    dbgs() << "VGPRUsageDiff: " << Cand.VGPRUsageDiff << '\n';
    dbgs() << '\n';
  );

  Block = Cand.Block;
  ReadyBlocks.erase(Best);
  return Block;
}

// Tracking of currently alive registers to determine VGPR Usage.

void SIScheduleBlockScheduler::addLiveRegs(std::set<unsigned> &Regs) {
  for (unsigned Reg : Regs) {
    // For now only track virtual registers.
    if (!TargetRegisterInfo::isVirtualRegister(Reg))
      continue;
    // If not already in the live set, then add it.
    (void) LiveRegs.insert(Reg);
  }
}

void SIScheduleBlockScheduler::decreaseLiveRegs(SIScheduleBlock *Block,
                                       std::set<unsigned> &Regs) {
  for (unsigned Reg : Regs) {
    // For now only track virtual registers.
    std::set<unsigned>::iterator Pos = LiveRegs.find(Reg);
    assert (Pos != LiveRegs.end() && // Reg must be live.
               LiveRegsConsumers.find(Reg) != LiveRegsConsumers.end() &&
               LiveRegsConsumers[Reg] >= 1);
    --LiveRegsConsumers[Reg];
    if (LiveRegsConsumers[Reg] == 0)
      LiveRegs.erase(Pos);
  }
}

void SIScheduleBlockScheduler::releaseBlockSuccs(SIScheduleBlock *Parent) {
  for (SIScheduleBlock* Block : Parent->getSuccs()) {
    --BlockNumPredsLeft[Block->getID()];
    if (BlockNumPredsLeft[Block->getID()] == 0) {
      ReadyBlocks.push_back(Block);
    }
    // TODO: Improve check. When the dependency between the high latency
    // instructions and the instructions of the other blocks are WAR or WAW
    // there will be no wait triggered. We would like these cases to not
    // update LastPosHighLatencyParentScheduled.
    if (Parent->isHighLatencyBlock())
      LastPosHighLatencyParentScheduled[Block->getID()] = NumBlockScheduled;
  }
}

void SIScheduleBlockScheduler::blockScheduled(SIScheduleBlock *Block) {
  decreaseLiveRegs(Block, Block->getInRegs());
  addLiveRegs(Block->getOutRegs());
  releaseBlockSuccs(Block);
  for (std::map<unsigned, unsigned>::iterator RegI =
       LiveOutRegsNumUsages[Block->getID()].begin(),
       E = LiveOutRegsNumUsages[Block->getID()].end(); RegI != E; ++RegI) {
    std::pair<unsigned, unsigned> RegP = *RegI;
    if (LiveRegsConsumers.find(RegP.first) == LiveRegsConsumers.end())
      LiveRegsConsumers[RegP.first] = RegP.second;
    else {
      assert(LiveRegsConsumers[RegP.first] == 0);
      LiveRegsConsumers[RegP.first] += RegP.second;
    }
  }
  if (LastPosHighLatencyParentScheduled[Block->getID()] >
        (unsigned)LastPosWaitedHighLatency)
    LastPosWaitedHighLatency =
      LastPosHighLatencyParentScheduled[Block->getID()];
  ++NumBlockScheduled;
}

std::vector<int>
SIScheduleBlockScheduler::checkRegUsageImpact(std::set<unsigned> &InRegs,
                                     std::set<unsigned> &OutRegs) {
  std::vector<int> DiffSetPressure;
  DiffSetPressure.assign(DAG->getTRI()->getNumRegPressureSets(), 0);

  for (unsigned Reg : InRegs) {
    // For now only track virtual registers.
    if (!TargetRegisterInfo::isVirtualRegister(Reg))
      continue;
    if (LiveRegsConsumers[Reg] > 1)
      continue;
    PSetIterator PSetI = DAG->getMRI()->getPressureSets(Reg);
    for (; PSetI.isValid(); ++PSetI) {
      DiffSetPressure[*PSetI] -= PSetI.getWeight();
    }
  }

  for (unsigned Reg : OutRegs) {
    // For now only track virtual registers.
    if (!TargetRegisterInfo::isVirtualRegister(Reg))
      continue;
    PSetIterator PSetI = DAG->getMRI()->getPressureSets(Reg);
    for (; PSetI.isValid(); ++PSetI) {
      DiffSetPressure[*PSetI] += PSetI.getWeight();
    }
  }

  return DiffSetPressure;
}

// SIScheduler //

struct SIScheduleBlockResult
SIScheduler::scheduleVariant(SISchedulerBlockCreatorVariant BlockVariant,
                             SISchedulerBlockSchedulerVariant ScheduleVariant) {
  SIScheduleBlocks Blocks = BlockCreator.getBlocks(BlockVariant);
  SIScheduleBlockScheduler Scheduler(DAG, ScheduleVariant, Blocks);
  std::vector<SIScheduleBlock*> ScheduledBlocks;
  struct SIScheduleBlockResult Res;

  ScheduledBlocks = Scheduler.getBlocks();

  for (unsigned b = 0; b < ScheduledBlocks.size(); ++b) {
    SIScheduleBlock *Block = ScheduledBlocks[b];
    std::vector<SUnit*> SUs = Block->getScheduledUnits();

    for (SUnit* SU : SUs)
      Res.SUs.push_back(SU->NodeNum);
  }

  Res.MaxSGPRUsage = Scheduler.getSGPRUsage();
  Res.MaxVGPRUsage = Scheduler.getVGPRUsage();
  return Res;
}

// SIScheduleDAGMI //

SIScheduleDAGMI::SIScheduleDAGMI(MachineSchedContext *C) :
  ScheduleDAGMILive(C, llvm::make_unique<GenericScheduler>(C)) {
  SITII = static_cast<const SIInstrInfo*>(TII);
  SITRI = static_cast<const SIRegisterInfo*>(TRI);

  VGPRSetID = SITRI->getVGPRPressureSet();
  SGPRSetID = SITRI->getSGPRPressureSet();
}

SIScheduleDAGMI::~SIScheduleDAGMI() = default;

// Code adapted from scheduleDAG.cpp
// Does a topological sort over the SUs.
// Both TopDown and BottomUp
void SIScheduleDAGMI::topologicalSort() {
  Topo.InitDAGTopologicalSorting();

  TopDownIndex2SU = std::vector<int>(Topo.begin(), Topo.end());
  BottomUpIndex2SU = std::vector<int>(Topo.rbegin(), Topo.rend());
}

// Move low latencies further from their user without
// increasing SGPR usage (in general)
// This is to be replaced by a better pass that would
// take into account SGPR usage (based on VGPR Usage
// and the corresponding wavefront count), that would
// try to merge groups of loads if it make sense, etc
void SIScheduleDAGMI::moveLowLatencies() {
   unsigned DAGSize = SUnits.size();
   int LastLowLatencyUser = -1;
   int LastLowLatencyPos = -1;

   for (unsigned i = 0, e = ScheduledSUnits.size(); i != e; ++i) {
    SUnit *SU = &SUnits[ScheduledSUnits[i]];
    bool IsLowLatencyUser = false;
    unsigned MinPos = 0;

    for (SDep& PredDep : SU->Preds) {
      SUnit *Pred = PredDep.getSUnit();
      if (SITII->isLowLatencyInstruction(*Pred->getInstr())) {
        IsLowLatencyUser = true;
      }
      if (Pred->NodeNum >= DAGSize)
        continue;
      unsigned PredPos = ScheduledSUnitsInv[Pred->NodeNum];
      if (PredPos >= MinPos)
        MinPos = PredPos + 1;
    }

    if (SITII->isLowLatencyInstruction(*SU->getInstr())) {
      unsigned BestPos = LastLowLatencyUser + 1;
      if ((int)BestPos <= LastLowLatencyPos)
        BestPos = LastLowLatencyPos + 1;
      if (BestPos < MinPos)
        BestPos = MinPos;
      if (BestPos < i) {
        for (unsigned u = i; u > BestPos; --u) {
          ++ScheduledSUnitsInv[ScheduledSUnits[u-1]];
          ScheduledSUnits[u] = ScheduledSUnits[u-1];
        }
        ScheduledSUnits[BestPos] = SU->NodeNum;
        ScheduledSUnitsInv[SU->NodeNum] = BestPos;
      }
      LastLowLatencyPos = BestPos;
      if (IsLowLatencyUser)
        LastLowLatencyUser = BestPos;
    } else if (IsLowLatencyUser) {
      LastLowLatencyUser = i;
    // Moves COPY instructions on which depends
    // the low latency instructions too.
    } else if (SU->getInstr()->getOpcode() == AMDGPU::COPY) {
      bool CopyForLowLat = false;
      for (SDep& SuccDep : SU->Succs) {
        SUnit *Succ = SuccDep.getSUnit();
        if (SITII->isLowLatencyInstruction(*Succ->getInstr())) {
          CopyForLowLat = true;
        }
      }
      if (!CopyForLowLat)
        continue;
      if (MinPos < i) {
        for (unsigned u = i; u > MinPos; --u) {
          ++ScheduledSUnitsInv[ScheduledSUnits[u-1]];
          ScheduledSUnits[u] = ScheduledSUnits[u-1];
        }
        ScheduledSUnits[MinPos] = SU->NodeNum;
        ScheduledSUnitsInv[SU->NodeNum] = MinPos;
      }
    }
  }
}

void SIScheduleDAGMI::restoreSULinksLeft() {
  for (unsigned i = 0, e = SUnits.size(); i != e; ++i) {
    SUnits[i].isScheduled = false;
    SUnits[i].WeakPredsLeft = SUnitsLinksBackup[i].WeakPredsLeft;
    SUnits[i].NumPredsLeft = SUnitsLinksBackup[i].NumPredsLeft;
    SUnits[i].WeakSuccsLeft = SUnitsLinksBackup[i].WeakSuccsLeft;
    SUnits[i].NumSuccsLeft = SUnitsLinksBackup[i].NumSuccsLeft;
  }
}

// Return the Vgpr and Sgpr usage corresponding to some virtual registers.
template<typename _Iterator> void
SIScheduleDAGMI::fillVgprSgprCost(_Iterator First, _Iterator End,
                                  unsigned &VgprUsage, unsigned &SgprUsage) {
  VgprUsage = 0;
  SgprUsage = 0;
  for (_Iterator RegI = First; RegI != End; ++RegI) {
    unsigned Reg = *RegI;
    // For now only track virtual registers
    if (!TargetRegisterInfo::isVirtualRegister(Reg))
      continue;
    PSetIterator PSetI = MRI.getPressureSets(Reg);
    for (; PSetI.isValid(); ++PSetI) {
      if (*PSetI == VGPRSetID)
        VgprUsage += PSetI.getWeight();
      else if (*PSetI == SGPRSetID)
        SgprUsage += PSetI.getWeight();
    }
  }
}

void SIScheduleDAGMI::schedule()
{
  SmallVector<SUnit*, 8> TopRoots, BotRoots;
  SIScheduleBlockResult Best, Temp;
  DEBUG(dbgs() << "Preparing Scheduling\n");

  buildDAGWithRegPressure();
  DEBUG(
    for(SUnit& SU : SUnits)
       SU.dumpAll(this)
  );

  topologicalSort();
  findRootsAndBiasEdges(TopRoots, BotRoots);
  // We reuse several ScheduleDAGMI and ScheduleDAGMILive
  // functions, but to make them happy we must initialize
  // the default Scheduler implementation (even if we do not
  // run it)
  SchedImpl->initialize(this);
  initQueues(TopRoots, BotRoots);

  // Fill some stats to help scheduling.

  SUnitsLinksBackup = SUnits;
  IsLowLatencySU.clear();
  LowLatencyOffset.clear();
  IsHighLatencySU.clear();

  IsLowLatencySU.resize(SUnits.size(), 0);
  LowLatencyOffset.resize(SUnits.size(), 0);
  IsHighLatencySU.resize(SUnits.size(), 0);

  for (unsigned i = 0, e = (unsigned)SUnits.size(); i != e; ++i) {
    SUnit *SU = &SUnits[i];
    unsigned BaseLatReg;
    int64_t OffLatReg;
    if (SITII->isLowLatencyInstruction(*SU->getInstr())) {
      IsLowLatencySU[i] = 1;
      if (SITII->getMemOpBaseRegImmOfs(*SU->getInstr(), BaseLatReg, OffLatReg,
                                       TRI))
        LowLatencyOffset[i] = OffLatReg;
    } else if (SITII->isHighLatencyInstruction(*SU->getInstr()))
      IsHighLatencySU[i] = 1;
  }

  SIScheduler Scheduler(this);
  Best = Scheduler.scheduleVariant(SISchedulerBlockCreatorVariant::LatenciesAlone,
                                   SISchedulerBlockSchedulerVariant::BlockLatencyRegUsage);

  // if VGPR usage is extremely high, try other good performing variants
  // which could lead to lower VGPR usage
  if (Best.MaxVGPRUsage > 180) {
    static constexpr std::pair<SISchedulerBlockCreatorVariant,
                               SISchedulerBlockSchedulerVariant>
        Variants[] = {
      { LatenciesAlone, BlockRegUsageLatency },
//      { LatenciesAlone, BlockRegUsage },
      { LatenciesGrouped, BlockLatencyRegUsage },
//      { LatenciesGrouped, BlockRegUsageLatency },
//      { LatenciesGrouped, BlockRegUsage },
      { LatenciesAlonePlusConsecutive, BlockLatencyRegUsage },
//      { LatenciesAlonePlusConsecutive, BlockRegUsageLatency },
//      { LatenciesAlonePlusConsecutive, BlockRegUsage }
    };
    for (std::pair<SISchedulerBlockCreatorVariant, SISchedulerBlockSchedulerVariant> v : Variants) {
      Temp = Scheduler.scheduleVariant(v.first, v.second);
      if (Temp.MaxVGPRUsage < Best.MaxVGPRUsage)
        Best = Temp;
    }
  }
  // if VGPR usage is still extremely high, we may spill. Try other variants
  // which are less performing, but that could lead to lower VGPR usage.
  if (Best.MaxVGPRUsage > 200) {
    static constexpr std::pair<SISchedulerBlockCreatorVariant,
                               SISchedulerBlockSchedulerVariant>
        Variants[] = {
//      { LatenciesAlone, BlockRegUsageLatency },
      { LatenciesAlone, BlockRegUsage },
//      { LatenciesGrouped, BlockLatencyRegUsage },
      { LatenciesGrouped, BlockRegUsageLatency },
      { LatenciesGrouped, BlockRegUsage },
//      { LatenciesAlonePlusConsecutive, BlockLatencyRegUsage },
      { LatenciesAlonePlusConsecutive, BlockRegUsageLatency },
      { LatenciesAlonePlusConsecutive, BlockRegUsage }
    };
    for (std::pair<SISchedulerBlockCreatorVariant, SISchedulerBlockSchedulerVariant> v : Variants) {
      Temp = Scheduler.scheduleVariant(v.first, v.second);
      if (Temp.MaxVGPRUsage < Best.MaxVGPRUsage)
        Best = Temp;
    }
  }

  ScheduledSUnits = Best.SUs;
  ScheduledSUnitsInv.resize(SUnits.size());

  for (unsigned i = 0, e = (unsigned)SUnits.size(); i != e; ++i) {
    ScheduledSUnitsInv[ScheduledSUnits[i]] = i;
  }

  moveLowLatencies();

  // Tell the outside world about the result of the scheduling.

  assert(TopRPTracker.getPos() == RegionBegin && "bad initial Top tracker");
  TopRPTracker.setPos(CurrentTop);

  for (std::vector<unsigned>::iterator I = ScheduledSUnits.begin(),
       E = ScheduledSUnits.end(); I != E; ++I) {
    SUnit *SU = &SUnits[*I];

    scheduleMI(SU, true);

    DEBUG(dbgs() << "Scheduling SU(" << SU->NodeNum << ") "
                 << *SU->getInstr());
  }

  assert(CurrentTop == CurrentBottom && "Nonempty unscheduled zone.");

  placeDebugValues();

  DEBUG({
      unsigned BBNum = begin()->getParent()->getNumber();
      dbgs() << "*** Final schedule for BB#" << BBNum << " ***\n";
      dumpSchedule();
      dbgs() << '\n';
    });
}
