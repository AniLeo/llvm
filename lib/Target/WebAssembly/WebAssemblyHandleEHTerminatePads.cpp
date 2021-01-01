// WebAssemblyHandleEHTerminatePads.cpp - WebAssembly Handle EH TerminatePads //
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Add catch_all blocks to terminate pads.
///
/// Terminate pads are cleanup pads with a __clang_call_terminate call. These
/// are reached when an exception is thrown again in the middle of processing a
/// thrown exception, to terminate the program. These are cleanup pads that
/// should run regardless whether the thrown exception is a C++ exception or
/// not.
///
/// Because __clang_call_terminate takes an exception pointer, and
/// llvm.get.exception intrinsic is selected to 'catch' instruction in
/// instruction selection, terminate pads have a catch instruction and are in
/// this form after LateEHPrepare, even though they are cleanup pads:
/// termpad:
///   %exn = catch $__cpp_exception
///   call @__clang_call_terminate(%exn)
///   unreachable
///
/// This pass assumes LateEHPrepare ensured every terminate pad is a single
/// BB.
///
/// __clang_call_terminate is a function generated by clang, in the form of
/// void __clang_call_terminate(i8* %arg) {
///   call @__cxa_begin_catch(%arg)
///   call void @std::terminate()
///   unreachable
/// }
///
/// To make the terminate pads reachable when a foreign exception is thrown,
/// this pass attaches an additional catch_all BB after this catch terminate pad
/// BB, with a call to std::terminate, because foreign exceptions don't have a
/// valid exception pointer to call __cxa_begin_catch with. So the code example
/// becomes:
/// termpad:
///   %exn = catch $__cpp_exception
///   call @__clang_call_terminate(%exn)
///   unreachable
/// termpad-catchall:
///   catch_all
///   call @std::terminate()
///   unreachable
///
/// We do this at the very end of compilation pipeline, even after CFGStackify,
/// because even though wasm spec allows multiple catch/catch_all blocks per a
/// try instruction, it has been convenient to maintain the invariant so far
/// that there has been only a single catch or catch_all attached to a try. This
/// assumption makes ExceptionInfo generation and CFGStackify simpler, because
/// we have been always able to assume an EH pad is an end of try block and a
/// start of catch/catch_all block.
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "WebAssembly.h"
#include "WebAssemblySubtarget.h"
#include "WebAssemblyUtilities.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/Target/TargetMachine.h"
using namespace llvm;

#define DEBUG_TYPE "wasm-handle-termpads"

namespace {
class WebAssemblyHandleEHTerminatePads final : public MachineFunctionPass {
  StringRef getPassName() const override {
    return "WebAssembly Handle EH Terminate Pads";
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

public:
  static char ID; // Pass identification, replacement for typeid
  WebAssemblyHandleEHTerminatePads() : MachineFunctionPass(ID) {}
};
} // end anonymous namespace

char WebAssemblyHandleEHTerminatePads::ID = 0;
INITIALIZE_PASS(WebAssemblyHandleEHTerminatePads, DEBUG_TYPE,
                "WebAssembly Handle EH Terminate Pads", false, false)

FunctionPass *llvm::createWebAssemblyHandleEHTerminatePads() {
  return new WebAssemblyHandleEHTerminatePads();
}

bool WebAssemblyHandleEHTerminatePads::runOnMachineFunction(
    MachineFunction &MF) {
  LLVM_DEBUG(dbgs() << "********** Handle EH Terminate Pads **********\n"
                       "********** Function: "
                    << MF.getName() << '\n');

  if (MF.getTarget().getMCAsmInfo()->getExceptionHandlingType() !=
          ExceptionHandling::Wasm ||
      !MF.getFunction().hasPersonalityFn())
    return false;

  const auto &TII = *MF.getSubtarget<WebAssemblySubtarget>().getInstrInfo();

  // Find calls to __clang_call_terminate()
  SmallVector<MachineInstr *, 8> ClangCallTerminateCalls;
  for (auto &MBB : MF) {
    for (auto &MI : MBB) {
      if (MI.isCall()) {
        const MachineOperand &CalleeOp = MI.getOperand(0);
        if (CalleeOp.isGlobal() && CalleeOp.getGlobal()->getName() ==
                                       WebAssembly::ClangCallTerminateFn)
          ClangCallTerminateCalls.push_back(&MI);
      }
    }
  }

  if (ClangCallTerminateCalls.empty())
    return false;

  for (auto *Call : ClangCallTerminateCalls) {
    // This should be an EH pad because LateEHPrepare ensures terminate pads are
    // a single BB.
    MachineBasicBlock *CatchBB = Call->getParent();
    assert(CatchBB->isEHPad());

    auto *CatchAllBB = MF.CreateMachineBasicBlock();
    MF.insert(std::next(CatchBB->getIterator()), CatchAllBB);
    CatchAllBB->setIsEHPad(true);
    for (auto *Pred : CatchBB->predecessors())
      Pred->addSuccessor(CatchAllBB);

    // If the definition of __clang_call_terminate exists in the module, there
    // should be a declaration of std::terminate within the same module, because
    // __clang_call_terminate calls it.
    const auto *StdTerminateFn =
        MF.getMMI().getModule()->getNamedValue(WebAssembly::StdTerminateFn);
    assert(StdTerminateFn && "std::terminate() does not exist in the module");

    // Generate a BB in the form of:
    //   catch_all
    //   call @std::terminate
    //   unreachable
    BuildMI(CatchAllBB, Call->getDebugLoc(), TII.get(WebAssembly::CATCH_ALL));
    BuildMI(CatchAllBB, Call->getDebugLoc(), TII.get(WebAssembly::CALL))
        .addGlobalAddress(StdTerminateFn);
    BuildMI(CatchAllBB, Call->getDebugLoc(), TII.get(WebAssembly::UNREACHABLE));
  }

  return true;
}
