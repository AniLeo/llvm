//===-- M68kInstructionSelector.cpp -----------------------------*- C++ -*-===//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for
/// M68k.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "M68kRegisterBankInfo.h"
#include "M68kSubtarget.h"
#include "M68kTargetMachine.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelectorImpl.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "m68k-isel"

using namespace llvm;

#define GET_GLOBALISEL_PREDICATE_BITSET
#include "M68kGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATE_BITSET

namespace {

class M68kInstructionSelector : public InstructionSelector {
public:
  M68kInstructionSelector(const M68kTargetMachine &TM, const M68kSubtarget &STI,
                          const M68kRegisterBankInfo &RBI);

  bool select(MachineInstr &I) override;
  static const char *getName() { return DEBUG_TYPE; }

private:
  bool selectImpl(MachineInstr &I, CodeGenCoverage &CoverageInfo) const;

  const M68kTargetMachine &TM;
  const M68kInstrInfo &TII;
  const M68kRegisterInfo &TRI;
  const M68kRegisterBankInfo &RBI;

#define GET_GLOBALISEL_PREDICATES_DECL
#include "M68kGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATES_DECL

#define GET_GLOBALISEL_TEMPORARIES_DECL
#include "M68kGenGlobalISel.inc"
#undef GET_GLOBALISEL_TEMPORARIES_DECL
};

} // end anonymous namespace

#define GET_GLOBALISEL_IMPL
#include "M68kGenGlobalISel.inc"
#undef GET_GLOBALISEL_IMPL

M68kInstructionSelector::M68kInstructionSelector(
    const M68kTargetMachine &TM, const M68kSubtarget &STI,
    const M68kRegisterBankInfo &RBI)
    : InstructionSelector(), TM(TM), TII(*STI.getInstrInfo()),
      TRI(*STI.getRegisterInfo()), RBI(RBI),

#define GET_GLOBALISEL_PREDICATES_INIT
#include "M68kGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATES_INIT
#define GET_GLOBALISEL_TEMPORARIES_INIT
#include "M68kGenGlobalISel.inc"
#undef GET_GLOBALISEL_TEMPORARIES_INIT
{
}

bool M68kInstructionSelector::select(MachineInstr &I) {
  // Certain non-generic instructions also need some special handling.
  if (!isPreISelGenericOpcode(I.getOpcode()))
    return true;

  if (selectImpl(I, *CoverageInfo))
    return true;

  return false;
}

namespace llvm {
InstructionSelector *
createM68kInstructionSelector(const M68kTargetMachine &TM,
                              const M68kSubtarget &Subtarget,
                              const M68kRegisterBankInfo &RBI) {
  return new M68kInstructionSelector(TM, Subtarget, RBI);
}
} // end namespace llvm
