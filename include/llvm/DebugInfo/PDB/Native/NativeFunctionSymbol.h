//===- NativeFunctionSymbol.h - info about function symbols -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DEBUGINFO_PDB_NATIVE_NATIVEFUNCTIONSYMBOL_H
#define LLVM_DEBUGINFO_PDB_NATIVE_NATIVEFUNCTIONSYMBOL_H

#include "llvm/DebugInfo/CodeView/CodeView.h"
#include "llvm/DebugInfo/CodeView/SymbolRecord.h"
#include "llvm/DebugInfo/PDB/Native/NativeRawSymbol.h"
#include "llvm/DebugInfo/PDB/Native/NativeSession.h"

namespace llvm {
namespace pdb {

class NativeFunctionSymbol : public NativeRawSymbol {
public:
  NativeFunctionSymbol(NativeSession &Session, SymIndexId Id,
                       const codeview::ProcSym &Sym);

  ~NativeFunctionSymbol() override;

  void dump(raw_ostream &OS, int Indent, PdbSymbolIdField ShowIdFields,
            PdbSymbolIdField RecurseIdFields) const override;

  uint32_t getAddressOffset() const override;
  uint32_t getAddressSection() const override;
  std::string getName() const override;
  PDB_SymType getSymTag() const override;
  uint64_t getLength() const override;
  uint32_t getRelativeVirtualAddress() const override;
  uint64_t getVirtualAddress() const override;

protected:
  const codeview::ProcSym Sym;
};

} // namespace pdb
} // namespace llvm

#endif // LLVM_DEBUGINFO_PDB_NATIVE_NATIVEFUNCTIONSYMBOL_H
