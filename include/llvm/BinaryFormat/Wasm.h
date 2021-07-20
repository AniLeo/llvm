//===- Wasm.h - Wasm object file format -------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines manifest constants for the wasm object file format.
// See: https://github.com/WebAssembly/design/blob/master/BinaryEncoding.md
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_BINARYFORMAT_WASM_H
#define LLVM_BINARYFORMAT_WASM_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

namespace llvm {
namespace wasm {

// Object file magic string.
const char WasmMagic[] = {'\0', 'a', 's', 'm'};
// Wasm binary format version
const uint32_t WasmVersion = 0x1;
// Wasm linking metadata version
const uint32_t WasmMetadataVersion = 0x2;
// Wasm uses a 64k page size
const uint32_t WasmPageSize = 65536;

struct WasmObjectHeader {
  StringRef Magic;
  uint32_t Version;
};

struct WasmDylinkInfo {
  uint32_t MemorySize; // Memory size in bytes
  uint32_t MemoryAlignment;  // P2 alignment of memory
  uint32_t TableSize;  // Table size in elements
  uint32_t TableAlignment;  // P2 alignment of table
  std::vector<StringRef> Needed; // Shared library dependencies
};

struct WasmProducerInfo {
  std::vector<std::pair<std::string, std::string>> Languages;
  std::vector<std::pair<std::string, std::string>> Tools;
  std::vector<std::pair<std::string, std::string>> SDKs;
};

struct WasmFeatureEntry {
  uint8_t Prefix;
  std::string Name;
};

struct WasmExport {
  StringRef Name;
  uint8_t Kind;
  uint32_t Index;
};

struct WasmLimits {
  uint8_t Flags;
  uint64_t Minimum;
  uint64_t Maximum;
};

struct WasmTableType {
  uint8_t ElemType;
  WasmLimits Limits;
};

struct WasmTable {
  uint32_t Index;
  WasmTableType Type;
  StringRef SymbolName; // from the "linking" section
};

struct WasmInitExpr {
  uint8_t Opcode;
  union {
    int32_t Int32;
    int64_t Int64;
    uint32_t Float32;
    uint64_t Float64;
    uint32_t Global;
  } Value;
};

struct WasmGlobalType {
  uint8_t Type;
  bool Mutable;
};

struct WasmGlobal {
  uint32_t Index;
  WasmGlobalType Type;
  WasmInitExpr InitExpr;
  StringRef SymbolName; // from the "linking" section
};

struct WasmTagType {
  // Kind of tag. Currently only WASM_TAG_ATTRIBUTE_EXCEPTION is possible.
  uint8_t Attribute;
  uint32_t SigIndex;
};

struct WasmTag {
  uint32_t Index;
  WasmTagType Type;
  StringRef SymbolName; // from the "linking" section
};

struct WasmImport {
  StringRef Module;
  StringRef Field;
  uint8_t Kind;
  union {
    uint32_t SigIndex;
    WasmGlobalType Global;
    WasmTableType Table;
    WasmLimits Memory;
    WasmTagType Tag;
  };
};

struct WasmLocalDecl {
  uint8_t Type;
  uint32_t Count;
};

struct WasmFunction {
  uint32_t Index;
  std::vector<WasmLocalDecl> Locals;
  ArrayRef<uint8_t> Body;
  uint32_t CodeSectionOffset;
  uint32_t Size;
  uint32_t CodeOffset;  // start of Locals and Body
  Optional<StringRef> ExportName; // from the "export" section
  StringRef SymbolName; // from the "linking" section
  StringRef DebugName;  // from the "name" section
  uint32_t Comdat;      // from the "comdat info" section
};

struct WasmDataSegment {
  uint32_t InitFlags;
  // Present if InitFlags & WASM_DATA_SEGMENT_HAS_MEMINDEX.
  uint32_t MemoryIndex;
  // Present if InitFlags & WASM_DATA_SEGMENT_IS_PASSIVE == 0.
  WasmInitExpr Offset;

  ArrayRef<uint8_t> Content;
  StringRef Name; // from the "segment info" section
  uint32_t Alignment;
  uint32_t LinkingFlags;
  uint32_t Comdat; // from the "comdat info" section
};

struct WasmElemSegment {
  uint32_t Flags;
  uint32_t TableNumber;
  uint8_t ElemKind;
  WasmInitExpr Offset;
  std::vector<uint32_t> Functions;
};

// Represents the location of a Wasm data symbol within a WasmDataSegment, as
// the index of the segment, and the offset and size within the segment.
struct WasmDataReference {
  uint32_t Segment;
  uint64_t Offset;
  uint64_t Size;
};

struct WasmRelocation {
  uint8_t Type;    // The type of the relocation.
  uint32_t Index;  // Index into either symbol or type index space.
  uint64_t Offset; // Offset from the start of the section.
  int64_t Addend;  // A value to add to the symbol.
};

struct WasmInitFunc {
  uint32_t Priority;
  uint32_t Symbol;
};

struct WasmSymbolInfo {
  StringRef Name;
  uint8_t Kind;
  uint32_t Flags;
  // For undefined symbols the module of the import
  Optional<StringRef> ImportModule;
  // For undefined symbols the name of the import
  Optional<StringRef> ImportName;
  // For symbols to be exported from the final module
  Optional<StringRef> ExportName;
  union {
    // For function, table, or global symbols, the index in function, table, or
    // global index space.
    uint32_t ElementIndex;
    // For a data symbols, the address of the data relative to segment.
    WasmDataReference DataRef;
  };
};

enum class NameType {
  FUNCTION,
  GLOBAL,
  DATA_SEGMENT,
};

struct WasmDebugName {
  NameType Type;
  uint32_t Index;
  StringRef Name;
};

struct WasmLinkingData {
  uint32_t Version;
  std::vector<WasmInitFunc> InitFunctions;
  std::vector<StringRef> Comdats;
  std::vector<WasmSymbolInfo> SymbolTable;
};

enum : unsigned {
  WASM_SEC_CUSTOM = 0,     // Custom / User-defined section
  WASM_SEC_TYPE = 1,       // Function signature declarations
  WASM_SEC_IMPORT = 2,     // Import declarations
  WASM_SEC_FUNCTION = 3,   // Function declarations
  WASM_SEC_TABLE = 4,      // Indirect function table and other tables
  WASM_SEC_MEMORY = 5,     // Memory attributes
  WASM_SEC_GLOBAL = 6,     // Global declarations
  WASM_SEC_EXPORT = 7,     // Exports
  WASM_SEC_START = 8,      // Start function declaration
  WASM_SEC_ELEM = 9,       // Elements section
  WASM_SEC_CODE = 10,      // Function bodies (code)
  WASM_SEC_DATA = 11,      // Data segments
  WASM_SEC_DATACOUNT = 12, // Data segment count
  WASM_SEC_TAG = 13        // Tag declarations
};

// Type immediate encodings used in various contexts.
enum : unsigned {
  WASM_TYPE_I32 = 0x7F,
  WASM_TYPE_I64 = 0x7E,
  WASM_TYPE_F32 = 0x7D,
  WASM_TYPE_F64 = 0x7C,
  WASM_TYPE_V128 = 0x7B,
  WASM_TYPE_FUNCREF = 0x70,
  WASM_TYPE_EXTERNREF = 0x6F,
  WASM_TYPE_FUNC = 0x60,
  WASM_TYPE_NORESULT = 0x40, // for blocks with no result values
};

// Kinds of externals (for imports and exports).
enum : unsigned {
  WASM_EXTERNAL_FUNCTION = 0x0,
  WASM_EXTERNAL_TABLE = 0x1,
  WASM_EXTERNAL_MEMORY = 0x2,
  WASM_EXTERNAL_GLOBAL = 0x3,
  WASM_EXTERNAL_TAG = 0x4,
};

// Opcodes used in initializer expressions.
enum : unsigned {
  WASM_OPCODE_END = 0x0b,
  WASM_OPCODE_CALL = 0x10,
  WASM_OPCODE_LOCAL_GET = 0x20,
  WASM_OPCODE_LOCAL_SET = 0x21,
  WASM_OPCODE_GLOBAL_GET = 0x23,
  WASM_OPCODE_GLOBAL_SET = 0x24,
  WASM_OPCODE_I32_STORE = 0x36,
  WASM_OPCODE_I64_STORE = 0x37,
  WASM_OPCODE_I32_CONST = 0x41,
  WASM_OPCODE_I64_CONST = 0x42,
  WASM_OPCODE_F32_CONST = 0x43,
  WASM_OPCODE_F64_CONST = 0x44,
  WASM_OPCODE_I32_ADD = 0x6a,
  WASM_OPCODE_I64_ADD = 0x7c,
  WASM_OPCODE_REF_NULL = 0xd0,
};

// Opcodes used in synthetic functions.
enum : unsigned {
  WASM_OPCODE_IF = 0x04,
  WASM_OPCODE_ELSE = 0x05,
  WASM_OPCODE_DROP = 0x1a,
  WASM_OPCODE_MISC_PREFIX = 0xfc,
  WASM_OPCODE_MEMORY_INIT = 0x08,
  WASM_OPCODE_DATA_DROP = 0x09,
  WASM_OPCODE_ATOMICS_PREFIX = 0xfe,
  WASM_OPCODE_ATOMIC_NOTIFY = 0x00,
  WASM_OPCODE_I32_ATOMIC_WAIT = 0x01,
  WASM_OPCODE_I32_ATOMIC_STORE = 0x17,
  WASM_OPCODE_I32_RMW_CMPXCHG = 0x48,
};

enum : unsigned {
  WASM_LIMITS_FLAG_NONE = 0x0,
  WASM_LIMITS_FLAG_HAS_MAX = 0x1,
  WASM_LIMITS_FLAG_IS_SHARED = 0x2,
  WASM_LIMITS_FLAG_IS_64 = 0x4,
};

enum : unsigned {
  WASM_DATA_SEGMENT_IS_PASSIVE = 0x01,
  WASM_DATA_SEGMENT_HAS_MEMINDEX = 0x02,
};

enum : unsigned {
  WASM_ELEM_SEGMENT_IS_PASSIVE = 0x01,
  WASM_ELEM_SEGMENT_HAS_TABLE_NUMBER = 0x02,
  WASM_ELEM_SEGMENT_HAS_INIT_EXPRS = 0x04,
};
const unsigned WASM_ELEM_SEGMENT_MASK_HAS_ELEM_KIND = 0x3;

// Feature policy prefixes used in the custom "target_features" section
enum : uint8_t {
  WASM_FEATURE_PREFIX_USED = '+',
  WASM_FEATURE_PREFIX_REQUIRED = '=',
  WASM_FEATURE_PREFIX_DISALLOWED = '-',
};

// Kind codes used in the custom "name" section
enum : unsigned {
  WASM_NAMES_FUNCTION = 1,
  WASM_NAMES_LOCAL = 2,
  WASM_NAMES_GLOBAL = 7,
  WASM_NAMES_DATA_SEGMENT = 9,
};

// Kind codes used in the custom "linking" section
enum : unsigned {
  WASM_SEGMENT_INFO = 0x5,
  WASM_INIT_FUNCS = 0x6,
  WASM_COMDAT_INFO = 0x7,
  WASM_SYMBOL_TABLE = 0x8,
};

// Kind codes used in the custom "linking" section in the WASM_COMDAT_INFO
enum : unsigned {
  WASM_COMDAT_DATA = 0x0,
  WASM_COMDAT_FUNCTION = 0x1,
  // GLOBAL, TAG, and TABLE are in here but LLVM doesn't use them yet.
  WASM_COMDAT_SECTION = 0x5,
};

// Kind codes used in the custom "linking" section in the WASM_SYMBOL_TABLE
enum WasmSymbolType : unsigned {
  WASM_SYMBOL_TYPE_FUNCTION = 0x0,
  WASM_SYMBOL_TYPE_DATA = 0x1,
  WASM_SYMBOL_TYPE_GLOBAL = 0x2,
  WASM_SYMBOL_TYPE_SECTION = 0x3,
  WASM_SYMBOL_TYPE_TAG = 0x4,
  WASM_SYMBOL_TYPE_TABLE = 0x5,
};

enum WasmSegmentFlag : unsigned {
  WASM_SEG_FLAG_STRINGS = 0x1,
  WASM_SEG_FLAG_TLS = 0x2,
};

// Kinds of tag attributes.
enum WasmTagAttribute : uint8_t {
  WASM_TAG_ATTRIBUTE_EXCEPTION = 0x0,
};

const unsigned WASM_SYMBOL_BINDING_MASK = 0x3;
const unsigned WASM_SYMBOL_VISIBILITY_MASK = 0xc;

const unsigned WASM_SYMBOL_BINDING_GLOBAL = 0x0;
const unsigned WASM_SYMBOL_BINDING_WEAK = 0x1;
const unsigned WASM_SYMBOL_BINDING_LOCAL = 0x2;
const unsigned WASM_SYMBOL_VISIBILITY_DEFAULT = 0x0;
const unsigned WASM_SYMBOL_VISIBILITY_HIDDEN = 0x4;
const unsigned WASM_SYMBOL_UNDEFINED = 0x10;
const unsigned WASM_SYMBOL_EXPORTED = 0x20;
const unsigned WASM_SYMBOL_EXPLICIT_NAME = 0x40;
const unsigned WASM_SYMBOL_NO_STRIP = 0x80;

#define WASM_RELOC(name, value) name = value,

enum : unsigned {
#include "WasmRelocs.def"
};

#undef WASM_RELOC

// Subset of types that a value can have
enum class ValType {
  I32 = WASM_TYPE_I32,
  I64 = WASM_TYPE_I64,
  F32 = WASM_TYPE_F32,
  F64 = WASM_TYPE_F64,
  V128 = WASM_TYPE_V128,
  FUNCREF = WASM_TYPE_FUNCREF,
  EXTERNREF = WASM_TYPE_EXTERNREF,
};

struct WasmSignature {
  SmallVector<ValType, 1> Returns;
  SmallVector<ValType, 4> Params;
  // Support empty and tombstone instances, needed by DenseMap.
  enum { Plain, Empty, Tombstone } State = Plain;

  WasmSignature(SmallVector<ValType, 1> &&InReturns,
                SmallVector<ValType, 4> &&InParams)
      : Returns(InReturns), Params(InParams) {}
  WasmSignature() = default;
};

// Useful comparison operators
inline bool operator==(const WasmSignature &LHS, const WasmSignature &RHS) {
  return LHS.State == RHS.State && LHS.Returns == RHS.Returns &&
         LHS.Params == RHS.Params;
}

inline bool operator!=(const WasmSignature &LHS, const WasmSignature &RHS) {
  return !(LHS == RHS);
}

inline bool operator==(const WasmGlobalType &LHS, const WasmGlobalType &RHS) {
  return LHS.Type == RHS.Type && LHS.Mutable == RHS.Mutable;
}

inline bool operator!=(const WasmGlobalType &LHS, const WasmGlobalType &RHS) {
  return !(LHS == RHS);
}

std::string toString(WasmSymbolType type);
std::string relocTypetoString(uint32_t type);
bool relocTypeHasAddend(uint32_t type);

} // end namespace wasm
} // end namespace llvm

#endif
