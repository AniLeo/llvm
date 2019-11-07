//===- XCOFFObjectFile.h - XCOFF object file implementation -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the XCOFFObjectFile class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_OBJECT_XCOFFOBJECTFILE_H
#define LLVM_OBJECT_XCOFFOBJECTFILE_H

#include "llvm/BinaryFormat/XCOFF.h"
#include "llvm/Object/ObjectFile.h"

namespace llvm {
namespace object {

struct XCOFFFileHeader32 {
  support::ubig16_t Magic;
  support::ubig16_t NumberOfSections;

  // Unix time value, value of 0 indicates no timestamp.
  // Negative values are reserved.
  support::big32_t TimeStamp;

  support::ubig32_t SymbolTableOffset; // File offset to symbol table.
  support::big32_t NumberOfSymTableEntries;
  support::ubig16_t AuxHeaderSize;
  support::ubig16_t Flags;
};

struct XCOFFFileHeader64 {
  support::ubig16_t Magic;
  support::ubig16_t NumberOfSections;

  // Unix time value, value of 0 indicates no timestamp.
  // Negative values are reserved.
  support::big32_t TimeStamp;

  support::ubig64_t SymbolTableOffset; // File offset to symbol table.
  support::ubig16_t AuxHeaderSize;
  support::ubig16_t Flags;
  support::ubig32_t NumberOfSymTableEntries;
};

template <typename T> struct XCOFFSectionHeader {
  // Least significant 3 bits are reserved.
  static constexpr unsigned SectionFlagsReservedMask = 0x7;

  // The low order 16 bits of section flags denotes the section type.
  static constexpr unsigned SectionFlagsTypeMask = 0xffffu;

public:
  StringRef getName() const;
  uint16_t getSectionType() const;
  bool isReservedSectionType() const;
};

struct XCOFFSectionHeader32 : XCOFFSectionHeader<XCOFFSectionHeader32> {
  char Name[XCOFF::NameSize];
  support::ubig32_t PhysicalAddress;
  support::ubig32_t VirtualAddress;
  support::ubig32_t SectionSize;
  support::ubig32_t FileOffsetToRawData;
  support::ubig32_t FileOffsetToRelocationInfo;
  support::ubig32_t FileOffsetToLineNumberInfo;
  support::ubig16_t NumberOfRelocations;
  support::ubig16_t NumberOfLineNumbers;
  support::big32_t Flags;
};

struct XCOFFSectionHeader64 : XCOFFSectionHeader<XCOFFSectionHeader64> {
  char Name[XCOFF::NameSize];
  support::ubig64_t PhysicalAddress;
  support::ubig64_t VirtualAddress;
  support::ubig64_t SectionSize;
  support::big64_t FileOffsetToRawData;
  support::big64_t FileOffsetToRelocationInfo;
  support::big64_t FileOffsetToLineNumberInfo;
  support::ubig32_t NumberOfRelocations;
  support::ubig32_t NumberOfLineNumbers;
  support::big32_t Flags;
  char Padding[4];
};

struct XCOFFSymbolEntry {
  enum { NAME_IN_STR_TBL_MAGIC = 0x0 };
  typedef struct {
    support::big32_t Magic; // Zero indicates name in string table.
    support::ubig32_t Offset;
  } NameInStrTblType;

  typedef struct {
    uint8_t LanguageId;
    uint8_t CpuTypeId;
  } CFileLanguageIdAndTypeIdType;

  union {
    char SymbolName[XCOFF::NameSize];
    NameInStrTblType NameInStrTbl;
  };

  support::ubig32_t Value; // Symbol value; storage class-dependent.
  support::big16_t SectionNumber;

  union {
    support::ubig16_t SymbolType;
    CFileLanguageIdAndTypeIdType CFileLanguageIdAndTypeId;
  };

  XCOFF::StorageClass StorageClass;
  uint8_t NumberOfAuxEntries;
};

struct XCOFFStringTable {
  uint32_t Size;
  const char *Data;
};

struct XCOFFCsectAuxEnt32 {
  support::ubig32_t
      SectionOrLength; // If the symbol type is XTY_SD or XTY_CM, the csect
                       // length.
                       // If the symbol type is XTY_LD, the symbol table
                       // index of the containing csect.
                       // If the symbol type is XTY_ER, 0.
  support::ubig32_t ParameterHashIndex;
  support::ubig16_t TypeChkSectNum;
  uint8_t SymbolAlignmentAndType;
  XCOFF::StorageMappingClass StorageMappingClass;
  support::ubig32_t StabInfoIndex;
  support::ubig16_t StabSectNum;
};

struct XCOFFFileAuxEnt {
  typedef struct {
    support::big32_t Magic; // Zero indicates name in string table.
    support::ubig32_t Offset;
    char NamePad[XCOFF::FileNamePadSize];
  } NameInStrTblType;
  union {
    char Name[XCOFF::NameSize + XCOFF::FileNamePadSize];
    NameInStrTblType NameInStrTbl;
  };
  XCOFF::CFileStringType Type;
  uint8_t ReservedZeros[2];
  uint8_t AuxType; // 64-bit XCOFF file only.
};

struct XCOFFSectAuxEntForStat {
  support::ubig32_t SectionLength;
  support::ubig16_t NumberOfRelocEnt;
  support::ubig16_t NumberOfLineNum;
  uint8_t Pad[10];
};

struct XCOFFRelocation32 {
  // Masks for packing/unpacking the r_rsize field of relocations.

  // The msb is used to indicate if the bits being relocated are signed or
  // unsigned.
  static constexpr uint8_t XR_SIGN_INDICATOR_MASK = 0x80;

  // The 2nd msb is used to indicate that the binder has replaced/modified the
  // original instruction.
  static constexpr uint8_t XR_FIXUP_INDICATOR_MASK = 0x40;

  // The remaining bits specify the bit length of the relocatable reference
  // minus one.
  static constexpr uint8_t XR_BIASED_LENGTH_MASK = 0x3f;

public:
  support::ubig32_t VirtualAddress;
  support::ubig32_t SymbolIndex;

  // Packed field, see XR_* masks for details of packing.
  uint8_t Info;

  XCOFF::RelocationType Type;

public:
  bool isRelocationSigned() const;
  bool isFixupIndicated() const;

  // Returns the number of bits being relocated.
  uint8_t getRelocatedLength() const;
};

class XCOFFObjectFile : public ObjectFile {
private:
  const void *FileHeader = nullptr;
  const void *SectionHeaderTable = nullptr;

  const XCOFFSymbolEntry *SymbolTblPtr = nullptr;
  XCOFFStringTable StringTable = {0, nullptr};

  const XCOFFFileHeader32 *fileHeader32() const;
  const XCOFFFileHeader64 *fileHeader64() const;

  const XCOFFSectionHeader32 *sectionHeaderTable32() const;
  const XCOFFSectionHeader64 *sectionHeaderTable64() const;

  size_t getFileHeaderSize() const;
  size_t getSectionHeaderSize() const;

  const XCOFFSectionHeader32 *toSection32(DataRefImpl Ref) const;
  const XCOFFSectionHeader64 *toSection64(DataRefImpl Ref) const;
  uintptr_t getSectionHeaderTableAddress() const;
  uintptr_t getEndOfSymbolTableAddress() const;

  // This returns a pointer to the start of the storage for the name field of
  // the 32-bit or 64-bit SectionHeader struct. This string is *not* necessarily
  // null-terminated.
  const char *getSectionNameInternal(DataRefImpl Sec) const;

  // This function returns string table entry.
  Expected<StringRef> getStringTableEntry(uint32_t Offset) const;

  static bool isReservedSectionNumber(int16_t SectionNumber);

  // Constructor and "create" factory function. The constructor is only a thin
  // wrapper around the base constructor. The "create" function fills out the
  // XCOFF-specific information and performs the error checking along the way.
  XCOFFObjectFile(unsigned Type, MemoryBufferRef Object);
  static Expected<std::unique_ptr<XCOFFObjectFile>> create(unsigned Type,
                                                           MemoryBufferRef MBR);

  // Helper for parsing the StringTable. Returns an 'Error' if parsing failed
  // and an XCOFFStringTable if parsing succeeded.
  static Expected<XCOFFStringTable> parseStringTable(const XCOFFObjectFile *Obj,
                                                     uint64_t Offset);

  // Make a friend so it can call the private 'create' function.
  friend Expected<std::unique_ptr<ObjectFile>>
  ObjectFile::createXCOFFObjectFile(MemoryBufferRef Object, unsigned FileType);

  void checkSectionAddress(uintptr_t Addr, uintptr_t TableAddr) const;

public:
  // Interface inherited from base classes.
  void moveSymbolNext(DataRefImpl &Symb) const override;
  uint32_t getSymbolFlags(DataRefImpl Symb) const override;
  basic_symbol_iterator symbol_begin() const override;
  basic_symbol_iterator symbol_end() const override;

  Expected<StringRef> getSymbolName(DataRefImpl Symb) const override;
  Expected<uint64_t> getSymbolAddress(DataRefImpl Symb) const override;
  uint64_t getSymbolValueImpl(DataRefImpl Symb) const override;
  uint64_t getCommonSymbolSizeImpl(DataRefImpl Symb) const override;
  Expected<SymbolRef::Type> getSymbolType(DataRefImpl Symb) const override;
  Expected<section_iterator> getSymbolSection(DataRefImpl Symb) const override;

  void moveSectionNext(DataRefImpl &Sec) const override;
  Expected<StringRef> getSectionName(DataRefImpl Sec) const override;
  uint64_t getSectionAddress(DataRefImpl Sec) const override;
  uint64_t getSectionIndex(DataRefImpl Sec) const override;
  uint64_t getSectionSize(DataRefImpl Sec) const override;
  Expected<ArrayRef<uint8_t>>
  getSectionContents(DataRefImpl Sec) const override;
  uint64_t getSectionAlignment(DataRefImpl Sec) const override;
  bool isSectionCompressed(DataRefImpl Sec) const override;
  bool isSectionText(DataRefImpl Sec) const override;
  bool isSectionData(DataRefImpl Sec) const override;
  bool isSectionBSS(DataRefImpl Sec) const override;

  bool isSectionVirtual(DataRefImpl Sec) const override;
  relocation_iterator section_rel_begin(DataRefImpl Sec) const override;
  relocation_iterator section_rel_end(DataRefImpl Sec) const override;

  void moveRelocationNext(DataRefImpl &Rel) const override;
  uint64_t getRelocationOffset(DataRefImpl Rel) const override;
  symbol_iterator getRelocationSymbol(DataRefImpl Rel) const override;
  uint64_t getRelocationType(DataRefImpl Rel) const override;
  void getRelocationTypeName(DataRefImpl Rel,
                             SmallVectorImpl<char> &Result) const override;

  section_iterator section_begin() const override;
  section_iterator section_end() const override;
  uint8_t getBytesInAddress() const override;
  StringRef getFileFormatName() const override;
  Triple::ArchType getArch() const override;
  SubtargetFeatures getFeatures() const override;
  Expected<uint64_t> getStartAddress() const override;
  bool isRelocatableObject() const override;

  // Below here is the non-inherited interface.
  bool is64Bit() const;

  const XCOFFSymbolEntry *getPointerToSymbolTable() const {
    assert(!is64Bit() && "Symbol table handling not supported yet.");
    return SymbolTblPtr;
  }

  Expected<StringRef>
  getSymbolSectionName(const XCOFFSymbolEntry *SymEntPtr) const;

  const XCOFFSymbolEntry *toSymbolEntry(DataRefImpl Ref) const;

  // File header related interfaces.
  uint16_t getMagic() const;
  uint16_t getNumberOfSections() const;
  int32_t getTimeStamp() const;

  // Symbol table offset and entry count are handled differently between
  // XCOFF32 and XCOFF64.
  uint32_t getSymbolTableOffset32() const;
  uint64_t getSymbolTableOffset64() const;

  // Note that this value is signed and might return a negative value. Negative
  // values are reserved for future use.
  int32_t getRawNumberOfSymbolTableEntries32() const;

  // The sanitized value appropriate to use as an index into the symbol table.
  uint32_t getLogicalNumberOfSymbolTableEntries32() const;

  uint32_t getNumberOfSymbolTableEntries64() const;
  uint32_t getSymbolIndex(uintptr_t SymEntPtr) const;
  Expected<StringRef> getSymbolNameByIndex(uint32_t SymbolTableIndex) const;

  Expected<StringRef> getCFileName(const XCOFFFileAuxEnt *CFileEntPtr) const;
  uint16_t getOptionalHeaderSize() const;
  uint16_t getFlags() const;

  // Section header table related interfaces.
  ArrayRef<XCOFFSectionHeader32> sections32() const;
  ArrayRef<XCOFFSectionHeader64> sections64() const;

  int32_t getSectionFlags(DataRefImpl Sec) const;
  Expected<DataRefImpl> getSectionByNum(int16_t Num) const;

  void checkSymbolEntryPointer(uintptr_t SymbolEntPtr) const;

  // Relocation-related interfaces.
  Expected<uint32_t>
  getLogicalNumberOfRelocationEntries(const XCOFFSectionHeader32 &Sec) const;

  Expected<ArrayRef<XCOFFRelocation32>>
  relocations(const XCOFFSectionHeader32 &) const;
}; // XCOFFObjectFile

class XCOFFSymbolRef {
  const DataRefImpl SymEntDataRef;
  const XCOFFObjectFile *const OwningObjectPtr;

public:
  XCOFFSymbolRef(DataRefImpl SymEntDataRef,
                 const XCOFFObjectFile *OwningObjectPtr)
      : SymEntDataRef(SymEntDataRef), OwningObjectPtr(OwningObjectPtr){};

  XCOFF::StorageClass getStorageClass() const;
  uint8_t getNumberOfAuxEntries() const;
  const XCOFFCsectAuxEnt32 *getXCOFFCsectAuxEnt32() const;
  uint16_t getType() const;
  int16_t getSectionNumber() const;

  bool hasCsectAuxEnt() const;
  bool isFunction() const;
};

} // namespace object
} // namespace llvm

#endif // LLVM_OBJECT_XCOFFOBJECTFILE_H
