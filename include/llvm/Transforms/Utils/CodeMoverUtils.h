//===- Transform/Utils/CodeMoverUtils.h - CodeMover Utils -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This family of functions determine movements are safe on basic blocks, and
// instructions contained within a function.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_UTILS_CODEMOVERUTILS_H
#define LLVM_TRANSFORMS_UTILS_CODEMOVERUTILS_H

namespace llvm {

class DependenceInfo;
class DominatorTree;
class Instruction;
class PostDominatorTree;

/// Return true if \p I0 and \p I1 are control flow equivalent.
/// Two instructions are control flow equivalent if when one executes,
/// the other is guaranteed to execute. This is determined using dominators
/// and post-dominators: if A dominates B and B post-dominates A then A and B
/// are control-flow equivalent.
bool isControlFlowEquivalent(const Instruction &I0, const Instruction &I1,
                             const DominatorTree &DT,
                             const PostDominatorTree &PDT);

/// Return true if \p I can be safely moved before \p InsertPoint.
bool isSafeToMoveBefore(Instruction &I, Instruction &InsertPoint,
                        const DominatorTree &DT, const PostDominatorTree &PDT,
                        DependenceInfo &DI);

} // end namespace llvm

#endif // LLVM_TRANSFORMS_UTILS_CODEMOVERUTILS_H
