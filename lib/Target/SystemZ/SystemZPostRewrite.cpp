//==---- SystemZPostRewrite.cpp - Select pseudos after RegAlloc ---*- C++ -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains a pass that is run immediately after VirtRegRewriter
// but before MachineCopyPropagation. The purpose is to lower pseudos to
// target instructions before any later pass might substitute a register for
// another.
//
//===----------------------------------------------------------------------===//

#include "SystemZ.h"
#include "SystemZInstrInfo.h"
#include "SystemZSubtarget.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
using namespace llvm;

#define SYSTEMZ_POSTREWRITE_NAME "SystemZ Post Rewrite pass"

#define DEBUG_TYPE "systemz-postrewrite"
STATISTIC(MemFoldCopies, "Number of copies inserted before folded mem ops.");

namespace llvm {
  void initializeSystemZPostRewritePass(PassRegistry&);
}

namespace {

class SystemZPostRewrite : public MachineFunctionPass {
public:
  static char ID;
  SystemZPostRewrite() : MachineFunctionPass(ID) {
    initializeSystemZPostRewritePass(*PassRegistry::getPassRegistry());
  }

  const SystemZInstrInfo *TII;

  bool runOnMachineFunction(MachineFunction &Fn) override;

  StringRef getPassName() const override { return SYSTEMZ_POSTREWRITE_NAME; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesAll();
    MachineFunctionPass::getAnalysisUsage(AU);
  }

private:
  bool selectMI(MachineBasicBlock &MBB, MachineBasicBlock::iterator MBBI,
                MachineBasicBlock::iterator &NextMBBI);
  bool selectMBB(MachineBasicBlock &MBB);
};

char SystemZPostRewrite::ID = 0;

} // end anonymous namespace

INITIALIZE_PASS(SystemZPostRewrite, "systemz-post-rewrite",
                SYSTEMZ_POSTREWRITE_NAME, false, false)

/// Returns an instance of the Post Rewrite pass.
FunctionPass *llvm::createSystemZPostRewritePass(SystemZTargetMachine &TM) {
  return new SystemZPostRewrite();
}

/// If MBBI references a pseudo instruction that should be selected here,
/// do it and return true.  Otherwise return false.
bool SystemZPostRewrite::selectMI(MachineBasicBlock &MBB,
                                MachineBasicBlock::iterator MBBI,
                                MachineBasicBlock::iterator &NextMBBI) {
  MachineInstr &MI = *MBBI;
  unsigned Opcode = MI.getOpcode();

  // Note: If this could be done during regalloc in foldMemoryOperandImpl()
  // while also updating the LiveIntervals, there would be no need for the
  // MemFoldPseudo to begin with.
  int TargetMemOpcode = SystemZ::getTargetMemOpcode(Opcode);
  if (TargetMemOpcode != -1) {
    MI.setDesc(TII->get(TargetMemOpcode));
    MI.tieOperands(0, 1);
    unsigned DstReg = MI.getOperand(0).getReg();
    MachineOperand &SrcMO = MI.getOperand(1);
    if (DstReg != SrcMO.getReg()) {
      BuildMI(MBB, &MI, MI.getDebugLoc(), TII->get(SystemZ::COPY), DstReg)
        .addReg(SrcMO.getReg());
      SrcMO.setReg(DstReg);
      MemFoldCopies++;
    }
    return true;
  }

  return false;
}

/// Iterate over the instructions in basic block MBB and select any
/// pseudo instructions.  Return true if anything was modified.
bool SystemZPostRewrite::selectMBB(MachineBasicBlock &MBB) {
  bool Modified = false;

  MachineBasicBlock::iterator MBBI = MBB.begin(), E = MBB.end();
  while (MBBI != E) {
    MachineBasicBlock::iterator NMBBI = std::next(MBBI);
    Modified |= selectMI(MBB, MBBI, NMBBI);
    MBBI = NMBBI;
  }

  return Modified;
}

bool SystemZPostRewrite::runOnMachineFunction(MachineFunction &MF) {
  TII = static_cast<const SystemZInstrInfo *>(MF.getSubtarget().getInstrInfo());

  bool Modified = false;
  for (auto &MBB : MF)
    Modified |= selectMBB(MBB);

  return Modified;
}

