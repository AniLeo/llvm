//===-- tools/llvm-reduce/TestRunner.h ---------------------------*- C++ -*-===/
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_REDUCE_TESTRUNNER_H
#define LLVM_TOOLS_LLVM_REDUCE_TESTRUNNER_H

#include "ReducerWorkItem.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/Program.h"
#include <vector>

namespace llvm {

// This class contains all the info necessary for running the provided
// interesting-ness test, as well as the most reduced module and its
// respective filename.
class TestRunner {
public:
  TestRunner(StringRef TestName, const std::vector<std::string> &TestArgs,
             std::unique_ptr<ReducerWorkItem> Program);

  /// Runs the interesting-ness test for the specified file
  /// @returns 0 if test was successful, 1 if otherwise
  int run(StringRef Filename);

  /// Returns the most reduced version of the original testcase
  ReducerWorkItem &getProgram() const { return *Program; }

  void setProgram(std::unique_ptr<ReducerWorkItem> P) {
    assert(P && "Setting null program?");
    Program = std::move(P);
  }

private:
  StringRef TestName;
  const std::vector<std::string> &TestArgs;
  std::unique_ptr<ReducerWorkItem> Program;
};

} // namespace llvm

#endif
