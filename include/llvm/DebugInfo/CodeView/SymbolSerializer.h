//===- symbolSerializer.h ---------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DEBUGINFO_CODEVIEW_SYMBOLSERIALIZER_H
#define LLVM_DEBUGINFO_CODEVIEW_SYMBOLSERIALIZER_H

#include "llvm/DebugInfo/CodeView/SymbolRecordMapping.h"
#include "llvm/DebugInfo/CodeView/SymbolVisitorCallbacks.h"

#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/iterator_range.h"
#include "llvm/Support/Allocator.h"
#include "llvm/Support/BinaryByteStream.h"
#include "llvm/Support/BinaryStreamWriter.h"
#include "llvm/Support/Error.h"

namespace llvm {
class BinaryStreamWriter;
namespace codeview {

class SymbolSerializer : public SymbolVisitorCallbacks {
  BumpPtrAllocator &Storage;
  std::vector<uint8_t> RecordBuffer;
  MutableBinaryByteStream Stream;
  BinaryStreamWriter Writer;
  SymbolRecordMapping Mapping;
  Optional<SymbolKind> CurrentSymbol;

  Error writeRecordPrefix(SymbolKind Kind) {
    RecordPrefix Prefix;
    Prefix.RecordKind = Kind;
    Prefix.RecordLen = 0;
    if (auto EC = Writer.writeObject(Prefix))
      return EC;
    return Error::success();
  }

public:
  template <typename SymType>
  static CVSymbol writeOneSymbol(SymType &Sym, BumpPtrAllocator &Storage,
                                 CodeViewContainer Container) {
    CVSymbol Result;
    Result.Type = static_cast<SymbolKind>(Sym.Kind);
    SymbolSerializer Serializer(Storage, Container);
    consumeError(Serializer.visitSymbolBegin(Result));
    consumeError(Serializer.visitKnownRecord(Result, Sym));
    consumeError(Serializer.visitSymbolEnd(Result));
    return Result;
  }

  SymbolSerializer(BumpPtrAllocator &Storage, CodeViewContainer Container);

  virtual Error visitSymbolBegin(CVSymbol &Record) override;
  virtual Error visitSymbolEnd(CVSymbol &Record) override;

#define SYMBOL_RECORD(EnumName, EnumVal, Name)                                 \
  virtual Error visitKnownRecord(CVSymbol &CVR, Name &Record) override {       \
    return visitKnownRecordImpl(CVR, Record);                                  \
  }
#define SYMBOL_RECORD_ALIAS(EnumName, EnumVal, Name, AliasName)
#include "llvm/DebugInfo/CodeView/CodeViewSymbols.def"

private:
  template <typename RecordKind>
  Error visitKnownRecordImpl(CVSymbol &CVR, RecordKind &Record) {
    return Mapping.visitKnownRecord(CVR, Record);
  }
};
}
}

#endif
