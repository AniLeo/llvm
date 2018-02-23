//===- MipsInstructionSelector.cpp ------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for
/// Mips.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "MipsRegisterBankInfo.h"
#include "MipsSubtarget.h"
#include "MipsTargetMachine.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

namespace {

class MipsInstructionSelector : public InstructionSelector {
public:
  MipsInstructionSelector(const MipsTargetMachine &TM, const MipsSubtarget &STI,
                          const MipsRegisterBankInfo &RBI);

  bool select(MachineInstr &I, CodeGenCoverage &CoverageInfo) const override;

private:
  const MipsTargetMachine &TM;
  const MipsSubtarget &STI;
  const MipsInstrInfo &TII;
  const MipsRegisterInfo &TRI;
  const MipsRegisterBankInfo &RBI;
};

} // end anonymous namespace

MipsInstructionSelector::MipsInstructionSelector(
    const MipsTargetMachine &TM, const MipsSubtarget &STI,
    const MipsRegisterBankInfo &RBI)
    : InstructionSelector(), TM(TM), STI(STI), TII(*STI.getInstrInfo()),
      TRI(*STI.getRegisterInfo()), RBI(RBI) {}

bool MipsInstructionSelector::select(MachineInstr &I,
                                     CodeGenCoverage &CoverageInfo) const {

  if (!isPreISelGenericOpcode(I.getOpcode())) {
    // Not global isel generic opcode.
    // TODO: select copy
    return true;
  }

  // We didn't select anything.
  return false;
}

namespace llvm {
InstructionSelector *createMipsInstructionSelector(const MipsTargetMachine &TM,
                                                   MipsSubtarget &Subtarget,
                                                   MipsRegisterBankInfo &RBI) {
  return new MipsInstructionSelector(TM, Subtarget, RBI);
}
} // end namespace llvm
