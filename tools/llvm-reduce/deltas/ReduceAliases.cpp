//===- ReduceAliases.cpp - Specialized Delta Pass -------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a function which calls the Generic Delta pass in order
// to reduce aliases in the provided Module.
//
//===----------------------------------------------------------------------===//

#include "ReduceAliases.h"
#include "Delta.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/GlobalValue.h"

using namespace llvm;

/// Removes all aliases aren't inside any of the
/// desired Chunks.
static void extractAliasesFromModule(Oracle &O, Module &Program) {
  for (auto &GA : make_early_inc_range(Program.aliases())) {
    if (!O.shouldKeep()) {
      GA.replaceAllUsesWith(GA.getAliasee());
      GA.eraseFromParent();
    }
  }
}

void llvm::reduceAliasesDeltaPass(TestRunner &Test) {
  errs() << "*** Reducing Aliases ...\n";
  runDeltaPass(Test, extractAliasesFromModule);
  errs() << "----------------------------\n";
}
