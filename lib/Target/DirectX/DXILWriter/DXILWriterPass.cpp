//===- DXILWriterPass.cpp - Bitcode writing pass --------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// DXILWriterPass implementation.
//
//===----------------------------------------------------------------------===//

#include "DXILWriterPass.h"
#include "DXILBitcodeWriter.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Analysis/ModuleSummaryAnalysis.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"

using namespace llvm;
using namespace llvm::dxil;

namespace {
class WriteDXILPass : public llvm::ModulePass {
  raw_ostream &OS; // raw_ostream to print on

public:
  static char ID; // Pass identification, replacement for typeid
  WriteDXILPass() : ModulePass(ID), OS(dbgs()) {
    initializeWriteDXILPassPass(*PassRegistry::getPassRegistry());
  }

  explicit WriteDXILPass(raw_ostream &o) : ModulePass(ID), OS(o) {
    initializeWriteDXILPassPass(*PassRegistry::getPassRegistry());
  }

  StringRef getPassName() const override { return "Bitcode Writer"; }

  bool runOnModule(Module &M) override {
    WriteDXILToFile(M, OS);
    return false;
  }
  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesAll();
  }
};
} // namespace

char WriteDXILPass::ID = 0;
INITIALIZE_PASS_BEGIN(WriteDXILPass, "write-bitcode", "Write Bitcode", false,
                      true)
INITIALIZE_PASS_DEPENDENCY(ModuleSummaryIndexWrapperPass)
INITIALIZE_PASS_END(WriteDXILPass, "write-bitcode", "Write Bitcode", false,
                    true)

ModulePass *llvm::createDXILWriterPass(raw_ostream &Str) {
  return new WriteDXILPass(Str);
}
