//===-- RISCVInstructionSelector.cpp -----------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for
/// RISCV.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "RISCVRegisterBankInfo.h"
#include "RISCVSubtarget.h"
#include "RISCVTargetMachine.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelectorImpl.h"
#include "llvm/IR/IntrinsicsRISCV.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "riscv-isel"

using namespace llvm;

#define GET_GLOBALISEL_PREDICATE_BITSET
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATE_BITSET

namespace {

class RISCVInstructionSelector : public InstructionSelector {
public:
  RISCVInstructionSelector(const RISCVTargetMachine &TM,
                           const RISCVSubtarget &STI,
                           const RISCVRegisterBankInfo &RBI);

  bool select(MachineInstr &I) override;
  static const char *getName() { return DEBUG_TYPE; }

private:
  bool selectImpl(MachineInstr &I, CodeGenCoverage &CoverageInfo) const;

  const RISCVSubtarget &STI;
  const RISCVInstrInfo &TII;
  const RISCVRegisterInfo &TRI;
  const RISCVRegisterBankInfo &RBI;

  // FIXME: This is necessary because DAGISel uses "Subtarget->" and GlobalISel
  // uses "STI." in the code generated by TableGen. We need to unify the name of
  // Subtarget variable.
  const RISCVSubtarget *Subtarget = &STI;

#define GET_GLOBALISEL_PREDICATES_DECL
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATES_DECL

#define GET_GLOBALISEL_TEMPORARIES_DECL
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_TEMPORARIES_DECL
};

} // end anonymous namespace

#define GET_GLOBALISEL_IMPL
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_IMPL

RISCVInstructionSelector::RISCVInstructionSelector(
    const RISCVTargetMachine &TM, const RISCVSubtarget &STI,
    const RISCVRegisterBankInfo &RBI)
    : InstructionSelector(), STI(STI), TII(*STI.getInstrInfo()),
      TRI(*STI.getRegisterInfo()), RBI(RBI),

#define GET_GLOBALISEL_PREDICATES_INIT
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATES_INIT
#define GET_GLOBALISEL_TEMPORARIES_INIT
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_TEMPORARIES_INIT
{
}

bool RISCVInstructionSelector::select(MachineInstr &I) {

  if (!isPreISelGenericOpcode(I.getOpcode())) {
    // Certain non-generic instructions also need some special handling.
    return true;
  }

  if (selectImpl(I, *CoverageInfo))
    return true;

  return false;
}

namespace llvm {
InstructionSelector *
createRISCVInstructionSelector(const RISCVTargetMachine &TM,
                               RISCVSubtarget &Subtarget,
                               RISCVRegisterBankInfo &RBI) {
  return new RISCVInstructionSelector(TM, Subtarget, RBI);
}
} // end namespace llvm
