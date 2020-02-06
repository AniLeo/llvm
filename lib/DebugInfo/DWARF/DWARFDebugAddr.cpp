//===- DWARFDebugAddr.cpp -------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/DebugInfo/DWARF/DWARFDebugAddr.h"
#include "llvm/BinaryFormat/Dwarf.h"
#include "llvm/DebugInfo/DWARF/DWARFUnit.h"

using namespace llvm;

Error DWARFDebugAddrTable::extractAddresses(const DWARFDataExtractor &Data,
                                            uint64_t *OffsetPtr,
                                            uint64_t EndOffset) {
  assert(EndOffset >= *OffsetPtr);
  uint64_t DataSize = EndOffset - *OffsetPtr;
  assert(Data.isValidOffsetForDataOfSize(*OffsetPtr, DataSize));
  if (AddrSize != 4 && AddrSize != 8)
    return createStringError(errc::not_supported,
                             "address table at offset 0x%" PRIx64
                             " has unsupported address size %" PRIu8
                             " (4 and 8 are supported)",
                             Offset, AddrSize);
  if (DataSize % AddrSize != 0) {
    invalidateLength();
    return createStringError(errc::invalid_argument,
                             "address table at offset 0x%" PRIx64
                             " contains data of size 0x%" PRIx64
                             " which is not a multiple of addr size %" PRIu8,
                             Offset, DataSize, AddrSize);
  }
  Addrs.clear();
  size_t Count = DataSize / AddrSize;
  Addrs.reserve(Count);
  while (Count--)
    Addrs.push_back(Data.getRelocatedValue(AddrSize, OffsetPtr));
  return Error::success();
}

Error DWARFDebugAddrTable::extractV5(const DWARFDataExtractor &Data,
                                     uint64_t *OffsetPtr, uint8_t CUAddrSize,
                                     std::function<void(Error)> WarnCallback) {
  Offset = *OffsetPtr;
  // Check that we can read the unit length field.
  if (!Data.isValidOffsetForDataOfSize(Offset, 4))
    return createStringError(errc::invalid_argument,
                             "section is not large enough to contain an "
                             "address table length at offset 0x%" PRIx64,
                             Offset);
  // TODO: Add support for DWARF64.
  Format = dwarf::DwarfFormat::DWARF32;
  Length = Data.getU32(OffsetPtr);
  if (Length == dwarf::DW_LENGTH_DWARF64) {
    invalidateLength();
    return createStringError(
        errc::not_supported,
        "DWARF64 is not supported in .debug_addr at offset 0x%" PRIx64, Offset);
  }

  if (!Data.isValidOffsetForDataOfSize(*OffsetPtr, Length)) {
    uint32_t DiagnosticLength = Length;
    invalidateLength();
    return createStringError(
        errc::invalid_argument,
        "section is not large enough to contain an address table "
        "at offset 0x%" PRIx64 " with a unit_length value of 0x%" PRIx32,
        Offset, DiagnosticLength);
  }
  uint64_t EndOffset = *OffsetPtr + Length;
  // Ensure that we can read the remaining header fields.
  if (Length < 4) {
    uint32_t DiagnosticLength = Length;
    invalidateLength();
    return createStringError(
        errc::invalid_argument,
        "address table at offset 0x%" PRIx64
        " has a unit_length value of 0x%" PRIx32
        ", which is too small to contain a complete header",
        Offset, DiagnosticLength);
  }

  Version = Data.getU16(OffsetPtr);
  AddrSize = Data.getU8(OffsetPtr);
  SegSize = Data.getU8(OffsetPtr);

  // Perform a basic validation of the header fields.
  if (Version != 5)
    return createStringError(errc::not_supported,
                             "address table at offset 0x%" PRIx64
                             " has unsupported version %" PRIu16,
                             Offset, Version);
  // TODO: add support for non-zero segment selector size.
  if (SegSize != 0)
    return createStringError(errc::not_supported,
                             "address table at offset 0x%" PRIx64
                             " has unsupported segment selector size %" PRIu8,
                             Offset, SegSize);

  if (Error Err = extractAddresses(Data, OffsetPtr, EndOffset))
    return Err;
  if (CUAddrSize && AddrSize != CUAddrSize) {
    WarnCallback(createStringError(
        errc::invalid_argument,
        "address table at offset 0x%" PRIx64 " has address size %" PRIu8
        " which is different from CU address size %" PRIu8,
        Offset, AddrSize, CUAddrSize));
  }
  return Error::success();
}

Error DWARFDebugAddrTable::extractPreStandard(const DWARFDataExtractor &Data,
                                              uint64_t *OffsetPtr,
                                              uint16_t CUVersion,
                                              uint8_t CUAddrSize) {
  assert(CUVersion > 0 && CUVersion < 5);

  Offset = *OffsetPtr;
  Length = 0;
  Version = CUVersion;
  AddrSize = CUAddrSize;
  SegSize = 0;

  return extractAddresses(Data, OffsetPtr, Data.size());
}

Error DWARFDebugAddrTable::extract(const DWARFDataExtractor &Data,
                                   uint64_t *OffsetPtr,
                                   uint16_t CUVersion,
                                   uint8_t CUAddrSize,
                                   std::function<void(Error)> WarnCallback) {
  if (CUVersion > 0 && CUVersion < 5)
    return extractPreStandard(Data, OffsetPtr, CUVersion, CUAddrSize);
  if (CUVersion == 0)
    WarnCallback(createStringError(errc::invalid_argument,
                                   "DWARF version is not defined in CU,"
                                   " assuming version 5"));
  return extractV5(Data, OffsetPtr, CUAddrSize, WarnCallback);
}

void DWARFDebugAddrTable::dump(raw_ostream &OS, DIDumpOptions DumpOpts) const {
  if (DumpOpts.Verbose)
    OS << format("0x%8.8" PRIx32 ": ", Offset);
  if (Length)
    OS << format("Address table header: length = 0x%8.8" PRIx32
                 ", version = 0x%4.4" PRIx16 ", addr_size = 0x%2.2" PRIx8
                 ", seg_size = 0x%2.2" PRIx8 "\n",
                 Length, Version, AddrSize, SegSize);

  if (Addrs.size() > 0) {
    const char *AddrFmt =
        (AddrSize == 4) ? "0x%8.8" PRIx64 "\n" : "0x%16.16" PRIx64 "\n";
    OS << "Addrs: [\n";
    for (uint64_t Addr : Addrs)
      OS << format(AddrFmt, Addr);
    OS << "]\n";
  }
}

Expected<uint64_t> DWARFDebugAddrTable::getAddrEntry(uint32_t Index) const {
  if (Index < Addrs.size())
    return Addrs[Index];
  return createStringError(errc::invalid_argument,
                           "Index %" PRIu32 " is out of range of the "
                           "address table at offset 0x%" PRIx64,
                           Index, Offset);
}

Optional<uint64_t> DWARFDebugAddrTable::getFullLength() const {
  if (Length == 0)
    return None;
  // TODO: DWARF64 support.
  return Length + sizeof(uint32_t);
}

