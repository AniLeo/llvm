//===- LoadsTest.cpp - local load analysis unit tests ---------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/Loads.h"
#include "llvm/AsmParser/Parser.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/SourceMgr.h"
#include "gtest/gtest.h"

using namespace llvm;

static std::unique_ptr<Module> parseIR(LLVMContext &C, const char *IR) {
  SMDiagnostic Err;
  std::unique_ptr<Module> Mod = parseAssemblyString(IR, Err, C);
  if (!Mod)
    Err.print("AnalysisTests", errs());
  return Mod;
}

TEST(LoadsTest, FindAvailableLoadedValueSameBasePtrConstantOffsetsNullAA) {
  LLVMContext C;
  std::unique_ptr<Module> M = parseIR(C,
                                      R"IR(
%class = type <{ i32, i32 }>

define i32 @f() {
entry:
  %o = alloca %class
  %f1 = getelementptr inbounds %class, %class* %o, i32 0, i32 0
  store i32 42, i32* %f1
  %f2 = getelementptr inbounds %class, %class* %o, i32 0, i32 1
  store i32 43, i32* %f2
  %v = load i32, i32* %f1
  ret i32 %v
}
)IR");
  auto *GV = M->getNamedValue("f");
  ASSERT_TRUE(GV);
  auto *F = dyn_cast<Function>(GV);
  ASSERT_TRUE(F);
  Instruction *Inst = &F->front().front();
  auto *AI = dyn_cast<AllocaInst>(Inst);
  ASSERT_TRUE(AI);
  Inst = &*++F->front().rbegin();
  auto *LI = dyn_cast<LoadInst>(Inst);
  ASSERT_TRUE(LI);
  BasicBlock::iterator BBI(LI);
  Value *Loaded = FindAvailableLoadedValue(
      LI, LI->getParent(), BBI, 0, nullptr, nullptr);
  ASSERT_TRUE(Loaded);
  auto *CI = dyn_cast<ConstantInt>(Loaded);
  ASSERT_TRUE(CI);
  ASSERT_TRUE(CI->equalsInt(42));
}
