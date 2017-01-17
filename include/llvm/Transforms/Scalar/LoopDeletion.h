//===- LoopDeletion.h - Loop Deletion -------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides the interface for the Loop Deletion Pass.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_LOOPDELETION_H
#define LLVM_TRANSFORMS_SCALAR_LOOPDELETION_H

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/Scalar/LoopPassManager.h"

namespace llvm {

class LoopDeletionPass : public PassInfoMixin<LoopDeletionPass> {
public:
  LoopDeletionPass() {}
  PreservedAnalyses run(Loop &L, LoopAnalysisManager &AM,
                        LoopStandardAnalysisResults &AR, LPMUpdater &U);

  bool runImpl(Loop *L, DominatorTree &DT, ScalarEvolution &SE, LoopInfo &LI);

private:
  bool isLoopDead(Loop *L, ScalarEvolution &SE,
                  SmallVectorImpl<BasicBlock *> &ExitingBlocks,
                  BasicBlock *ExitBlock, bool &Changed, BasicBlock *Preheader);
};
}

#endif // LLVM_TRANSFORMS_SCALAR_LOOPDELETION_H
