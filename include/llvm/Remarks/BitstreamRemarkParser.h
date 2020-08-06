//===-- BitstreamRemarkParser.h - Bitstream parser --------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides an implementation of the remark parser using the LLVM
// Bitstream format.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_REMARKS_BITSTREAM_REMARK_PARSER_H
#define LLVM_REMARKS_BITSTREAM_REMARK_PARSER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Bitstream/BitstreamReader.h"
#include "llvm/Support/Error.h"
#include <array>
#include <cstdint>

namespace llvm {
namespace remarks {

/// Helper to parse a META_BLOCK for a bitstream remark container.
struct BitstreamMetaParserHelper {
  /// The Bitstream reader.
  BitstreamCursor &Stream;
  /// Reference to the storage for the block info.
  BitstreamBlockInfo &BlockInfo;
  /// The parsed content: depending on the container type, some fields might be
  /// empty.
  Optional<uint64_t> ContainerVersion;
  Optional<uint8_t> ContainerType;
  Optional<StringRef> StrTabBuf;
  Optional<StringRef> ExternalFilePath;
  Optional<uint64_t> RemarkVersion;

  /// Continue parsing with \p Stream. \p Stream is expected to contain a
  /// ENTER_SUBBLOCK to the META_BLOCK at the current position.
  /// \p Stream is expected to have a BLOCKINFO_BLOCK set.
  BitstreamMetaParserHelper(BitstreamCursor &Stream,
                            BitstreamBlockInfo &BlockInfo);

  /// Parse the META_BLOCK and fill the available entries.
  /// This helper does not check for the validity of the fields.
  Error parse();
};

/// Helper to parse a REMARK_BLOCK for a bitstream remark container.
struct BitstreamRemarkParserHelper {
  /// The Bitstream reader.
  BitstreamCursor &Stream;
  /// The parsed content: depending on the remark, some fields might be empty.
  Optional<uint8_t> Type;
  Optional<uint64_t> RemarkNameIdx;
  Optional<uint64_t> PassNameIdx;
  Optional<uint64_t> FunctionNameIdx;
  Optional<uint64_t> SourceFileNameIdx;
  Optional<uint32_t> SourceLine;
  Optional<uint32_t> SourceColumn;
  Optional<uint64_t> Hotness;
  struct Argument {
    Optional<uint64_t> KeyIdx;
    Optional<uint64_t> ValueIdx;
    Optional<uint64_t> SourceFileNameIdx;
    Optional<uint32_t> SourceLine;
    Optional<uint32_t> SourceColumn;
  };
  Optional<ArrayRef<Argument>> Args;
  /// Avoid re-allocating a vector every time.
  SmallVector<Argument, 8> TmpArgs;

  /// Continue parsing with \p Stream. \p Stream is expected to contain a
  /// ENTER_SUBBLOCK to the REMARK_BLOCK at the current position.
  /// \p Stream is expected to have a BLOCKINFO_BLOCK set and to have already
  /// parsed the META_BLOCK.
  BitstreamRemarkParserHelper(BitstreamCursor &Stream);

  /// Parse the REMARK_BLOCK and fill the available entries.
  /// This helper does not check for the validity of the fields.
  Error parse();
};

/// Helper to parse any bitstream remark container.
struct BitstreamParserHelper {
  /// The Bitstream reader.
  BitstreamCursor Stream;
  /// The block info block.
  BitstreamBlockInfo BlockInfo;
  /// Start parsing at \p Buffer.
  BitstreamParserHelper(StringRef Buffer);
  /// Parse the magic number.
  Expected<std::array<char, 4>> parseMagic();
  /// Parse the block info block containing all the abbrevs.
  /// This needs to be called before calling any other parsing function.
  Error parseBlockInfoBlock();
  /// Return true if the next block is a META_BLOCK. This function does not move
  /// the cursor.
  Expected<bool> isMetaBlock();
  /// Return true if the next block is a REMARK_BLOCK. This function does not
  /// move the cursor.
  Expected<bool> isRemarkBlock();
  /// Return true if the parser reached the end of the stream.
  bool atEndOfStream() { return Stream.AtEndOfStream(); }
  /// Jump to the end of the stream, skipping everything.
  void skipToEnd() { return Stream.skipToEnd(); }
};

} // end namespace remarks
} // end namespace llvm

#endif /* LLVM_REMARKS_BITSTREAM_REMARK_PARSER_H */
