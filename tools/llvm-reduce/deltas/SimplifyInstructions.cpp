//===- SimplifyInstructions.cpp - Specialized Delta Pass ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a function which calls the Generic Delta pass in order
// to simplify Instructions in defined functions.
//
//===----------------------------------------------------------------------===//

#include "SimplifyInstructions.h"
#include "llvm/Analysis/InstructionSimplify.h"
#include "llvm/IR/Constants.h"

using namespace llvm;

/// Calls simplifyInstruction in each instruction in functions, and replaces
/// their values.
static void extractInstrFromModule(Oracle &O, Module &Program) {
  std::vector<Instruction *> InstsToDelete;

  const DataLayout &DL = Program.getDataLayout();

  std::vector<Instruction *> InstToDelete;
  for (auto &F : Program) {
    for (auto &BB : F) {
      for (auto &Inst : BB) {
        if (O.shouldKeep())
          continue;

        SimplifyQuery Q(DL, &Inst);
        if (Value *Simplified = simplifyInstruction(&Inst, Q)) {
          Inst.replaceAllUsesWith(Simplified);
          InstToDelete.push_back(&Inst);
        }
      }
    }
  }

  for (Instruction *I : InstToDelete)
    I->eraseFromParent();
}

void llvm::simplifyInstructionsDeltaPass(TestRunner &Test) {
  outs() << "*** Simplifying Instructions...\n";
  runDeltaPass(Test, extractInstrFromModule);
}
