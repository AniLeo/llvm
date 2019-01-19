//===-- llvm/CodeGen/DAGCombine.h  ------- SelectionDAG Nodes ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//

#ifndef LLVM_CODEGEN_DAGCOMBINE_H
#define LLVM_CODEGEN_DAGCOMBINE_H

namespace llvm {

enum CombineLevel {
  BeforeLegalizeTypes,
  AfterLegalizeTypes,
  AfterLegalizeVectorOps,
  AfterLegalizeDAG
};

} // end llvm namespace

#endif
