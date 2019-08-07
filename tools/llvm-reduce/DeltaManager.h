//===- DeltaManager.h - Runs Delta Passes to reduce Input -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file calls each specialized Delta pass in order to reduce the input IR
// file.
//
//===----------------------------------------------------------------------===//

#include "TestRunner.h"
#include "deltas/Delta.h"
#include "deltas/RemoveFunctions.h"
#include "deltas/RemoveGlobalVars.h"

namespace llvm {

inline void runDeltaPasses(TestRunner &Tester) {
  // TODO: Add option to only call certain delta passes
  outs() << "Reducing functions...\n";
  removeFunctionsDeltaPass(Tester);
  outs() << "Reducing GVs...\n";
  removeGlobalsDeltaPass(Tester);
  // TODO: Implement the remaining Delta Passes
}

} // namespace llvm
