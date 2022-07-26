//===-- MachineFunctionPass.cpp -------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the definitions of the MachineFunctionPass members.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/Analysis/BasicAliasAnalysis.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/IVUsers.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/MemoryDependenceAnalysis.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionAliasAnalysis.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineOptimizationRemarkEmitter.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/PrintPasses.h"

using namespace llvm;
using namespace ore;

Pass *MachineFunctionPass::createPrinterPass(raw_ostream &O,
                                             const std::string &Banner) const {
  return createMachineFunctionPrinterPass(O, Banner);
}

bool MachineFunctionPass::runOnFunction(Function &F) {
  // Do not codegen any 'available_externally' functions at all, they have
  // definitions outside the translation unit.
  if (F.hasAvailableExternallyLinkage())
    return false;

  MachineModuleInfo &MMI = getAnalysis<MachineModuleInfoWrapperPass>().getMMI();
  MachineFunction &MF = MMI.getOrCreateMachineFunction(F);

  MachineFunctionProperties &MFProps = MF.getProperties();

#ifndef NDEBUG
  if (!MFProps.verifyRequiredProperties(RequiredProperties)) {
    errs() << "MachineFunctionProperties required by " << getPassName()
           << " pass are not met by function " << F.getName() << ".\n"
           << "Required properties: ";
    RequiredProperties.print(errs());
    errs() << "\nCurrent properties: ";
    MFProps.print(errs());
    errs() << "\n";
    llvm_unreachable("MachineFunctionProperties check failed");
  }
#endif
  // Collect the MI count of the function before the pass.
  unsigned CountBefore, CountAfter;

  // Check if the user asked for size remarks.
  bool ShouldEmitSizeRemarks =
      F.getParent()->shouldEmitInstrCountChangedRemark();

  // If we want size remarks, collect the number of MachineInstrs in our
  // MachineFunction before the pass runs.
  if (ShouldEmitSizeRemarks)
    CountBefore = MF.getInstructionCount();

  // For --print-changed, if the function name is a candidate, save the
  // serialized MF to be compared later.
  // TODO Implement --filter-passes.
  SmallString<0> BeforeStr, AfterStr;
  bool ShouldPrintChanged = PrintChanged != ChangePrinter::None &&
                            isFunctionInPrintList(MF.getName());
  if (ShouldPrintChanged) {
    raw_svector_ostream OS(BeforeStr);
    MF.print(OS);
  }

  bool RV = runOnMachineFunction(MF);

  if (ShouldEmitSizeRemarks) {
    // We wanted size remarks. Check if there was a change to the number of
    // MachineInstrs in the module. Emit a remark if there was a change.
    CountAfter = MF.getInstructionCount();
    if (CountBefore != CountAfter) {
      MachineOptimizationRemarkEmitter MORE(MF, nullptr);
      MORE.emit([&]() {
        int64_t Delta = static_cast<int64_t>(CountAfter) -
                        static_cast<int64_t>(CountBefore);
        MachineOptimizationRemarkAnalysis R("size-info", "FunctionMISizeChange",
                                            MF.getFunction().getSubprogram(),
                                            &MF.front());
        R << NV("Pass", getPassName())
          << ": Function: " << NV("Function", F.getName()) << ": "
          << "MI Instruction count changed from "
          << NV("MIInstrsBefore", CountBefore) << " to "
          << NV("MIInstrsAfter", CountAfter)
          << "; Delta: " << NV("Delta", Delta);
        return R;
      });
    }
  }

  MFProps.set(SetProperties);
  MFProps.reset(ClearedProperties);

  // For --print-changed, print if the serialized MF has changed. Modes other
  // than quiet/verbose are unimplemented and treated the same as 'quiet'.
  if (ShouldPrintChanged) {
    raw_svector_ostream OS(AfterStr);
    MF.print(OS);
    if (BeforeStr != AfterStr) {
      StringRef Arg;
      if (const PassInfo *PI = Pass::lookupPassInfo(getPassID()))
        Arg = PI->getPassArgument();
      errs() << ("*** IR Dump After " + getPassName() + " (" + Arg + ") on " +
                 MF.getName() + " ***\n" + AfterStr);
    } else if (PrintChanged == ChangePrinter::Verbose) {
      errs() << ("*** IR Dump After " + getPassName() + " on " + MF.getName() +
                 " omitted because no change ***\n");
    }
  }
  return RV;
}

void MachineFunctionPass::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<MachineModuleInfoWrapperPass>();
  AU.addPreserved<MachineModuleInfoWrapperPass>();

  // MachineFunctionPass preserves all LLVM IR passes, but there's no
  // high-level way to express this. Instead, just list a bunch of
  // passes explicitly. This does not include setPreservesCFG,
  // because CodeGen overloads that to mean preserving the MachineBasicBlock
  // CFG in addition to the LLVM IR CFG.
  AU.addPreserved<BasicAAWrapperPass>();
  AU.addPreserved<DominanceFrontierWrapperPass>();
  AU.addPreserved<DominatorTreeWrapperPass>();
  AU.addPreserved<AAResultsWrapperPass>();
  AU.addPreserved<GlobalsAAWrapperPass>();
  AU.addPreserved<IVUsersWrapperPass>();
  AU.addPreserved<LoopInfoWrapperPass>();
  AU.addPreserved<MemoryDependenceWrapperPass>();
  AU.addPreserved<ScalarEvolutionWrapperPass>();
  AU.addPreserved<SCEVAAWrapperPass>();

  FunctionPass::getAnalysisUsage(AU);
}
