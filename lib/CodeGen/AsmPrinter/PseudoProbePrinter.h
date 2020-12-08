//===- PseudoProbePrinter.h - Pseudo probe encoding support -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains support for writing pseudo probe info into asm files.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_CODEGEN_ASMPRINTER_PSEUDOPROBEPRINTER_H
#define LLVM_LIB_CODEGEN_ASMPRINTER_PSEUDOPROBEPRINTER_H

#include "llvm/ADT/DenseMap.h"

namespace llvm {

class AsmPrinter;
class MCStreamer;
class Module;
class DILocation;

class PseudoProbeHandler {
  // Target of pseudo probe emission.
  AsmPrinter *Asm;
  // Name to GUID map
  DenseMap<StringRef, uint64_t> Names;

public:
  PseudoProbeHandler(AsmPrinter *A, Module *M);
  void emitPseudoProbe(uint64_t Guid, uint64_t Index, uint64_t Type,
                       uint64_t Attr, const DILocation *DebugLoc);
#ifndef NDEBUG
  void dump() const;
#endif
};

} // namespace llvm
#endif // LLVM_LIB_CODEGEN_ASMPRINTER_PSEUDOPROBEPRINTER_H
