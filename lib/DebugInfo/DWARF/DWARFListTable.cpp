//===- DWARFListTable.cpp ---------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DebugInfo/DWARF/DWARFListTable.h"
#include "llvm/BinaryFormat/Dwarf.h"
#include "llvm/Support/Errc.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

Error DWARFListTableHeader::extract(DWARFDataExtractor Data,
                                    uint32_t *OffsetPtr) {
  HeaderOffset = *OffsetPtr;
  // Read and verify the length field.
  if (!Data.isValidOffsetForDataOfSize(*OffsetPtr, sizeof(uint32_t))) {
    // By setting *OffsetPtr to 0, we indicate to the caller that
    // we could not detemine the length of the table.
    *OffsetPtr = 0;
    return createStringError(errc::invalid_argument,
                             "section is not large enough to contain a "
                             "%s table length at offset 0x%" PRIx32,
                             SectionName.data(), HeaderOffset);
  }
  // TODO: Add support for DWARF64.
  HeaderData.Length = Data.getU32(OffsetPtr);
  if (HeaderData.Length == 0xffffffffu) {
    *OffsetPtr = 0;
    return createStringError(errc::not_supported,
                       "DWARF64 is not supported in %s at offset 0x%" PRIx32,
                       SectionName.data(), HeaderOffset);
  }

  uint32_t TableLength = HeaderData.Length + sizeof(uint32_t);
  uint32_t End = HeaderOffset + TableLength;
  Format = dwarf::DwarfFormat::DWARF32;
  if (TableLength < sizeof(Header)) {
    *OffsetPtr = End;
    return createStringError(errc::invalid_argument,
                             "%s table at offset 0x%" PRIx32
                             " has too small length (0x%" PRIx32
                             ") to contain a complete header",
                             SectionName.data(), HeaderOffset, TableLength);
  }
  if (!Data.isValidOffsetForDataOfSize(HeaderOffset, TableLength)) {
    *OffsetPtr = 0; // No recovery if the length exceeds the section size.
    return createStringError(
        errc::invalid_argument,
        "section is not large enough to contain a %s table "
        "of length 0x%" PRIx32 " at offset 0x%" PRIx32,
        SectionName.data(), TableLength, HeaderOffset);
  }

  HeaderData.Version = Data.getU16(OffsetPtr);
  HeaderData.AddrSize = Data.getU8(OffsetPtr);
  HeaderData.SegSize = Data.getU8(OffsetPtr);
  HeaderData.OffsetEntryCount = Data.getU32(OffsetPtr);

  // Perform basic validation of the remaining header fields.
  if (HeaderData.Version != 5) {
    *OffsetPtr = End;
    return createStringError(errc::invalid_argument,
                             "unrecognised %s table version %" PRIu16
                             " in table at offset 0x%" PRIx32,
                             SectionName.data(), HeaderData.Version,
                             HeaderOffset);
  }
  if (HeaderData.AddrSize != 4 && HeaderData.AddrSize != 8) {
    *OffsetPtr = End;
    return createStringError(errc::not_supported,
                       "%s table at offset 0x%" PRIx32
                       " has unsupported address size %" PRIu8,
                       SectionName.data(), HeaderOffset, HeaderData.AddrSize);
  }
  if (HeaderData.SegSize != 0) {
    *OffsetPtr = End;
    return createStringError(errc::not_supported,
                       "%s table at offset 0x%" PRIx32
                       " has unsupported segment selector size %" PRIu8,
                       SectionName.data(), HeaderOffset, HeaderData.SegSize);
  }
  if (End < HeaderOffset + sizeof(HeaderData) +
                HeaderData.OffsetEntryCount * sizeof(uint32_t)) {
    *OffsetPtr = End;
    return createStringError(errc::invalid_argument,
        "%s table at offset 0x%" PRIx32 " has more offset entries (%" PRIu32
        ") than there is space for",
        SectionName.data(), HeaderOffset, HeaderData.OffsetEntryCount);
  }
  Data.setAddressSize(HeaderData.AddrSize);
  for (uint32_t I = 0; I < HeaderData.OffsetEntryCount; ++I)
    Offsets.push_back(Data.getU32(OffsetPtr));
  return Error::success();
}

void DWARFListTableHeader::dump(raw_ostream &OS, DIDumpOptions DumpOpts) const {
  if (DumpOpts.Verbose)
    OS << format("0x%8.8" PRIx32 ": ", HeaderOffset);
  OS << format(
      "%s list header: length = 0x%8.8" PRIx32 ", version = 0x%4.4" PRIx16 ", "
      "addr_size = 0x%2.2" PRIx8 ", seg_size = 0x%2.2" PRIx8
      ", offset_entry_count = "
      "0x%8.8" PRIx32 "\n",
      ListTypeString.data(), HeaderData.Length, HeaderData.Version,
      HeaderData.AddrSize, HeaderData.SegSize, HeaderData.OffsetEntryCount);

  if (HeaderData.OffsetEntryCount > 0) {
    OS << "offsets: [";
    for (const auto &Off : Offsets) {
      OS << format("\n0x%8.8" PRIx32, Off);
      if (DumpOpts.Verbose)
        OS << format(" => 0x%8.8" PRIx32,
                     Off + HeaderOffset + sizeof(HeaderData));
    }
    OS << "\n]\n";
  }
}

uint32_t DWARFListTableHeader::getTableLength() const {
  if (HeaderData.Length == 0)
    return 0;
  assert(HeaderData.Version > 0 &&
         "No DWARF version in header when using getTableLength()");
  // TODO: DWARF64 support.
  return HeaderData.Length + (HeaderData.Version > 4) * sizeof(uint32_t);
}
