//===-- DataExtractor.cpp -------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/DataExtractor.h"
#include "llvm/Support/Errc.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/Host.h"
#include "llvm/Support/LEB128.h"
#include "llvm/Support/SwapByteOrder.h"

using namespace llvm;

static void unexpectedEndReached(Error *E, uint64_t Offset) {
  if (E)
    *E = createStringError(errc::illegal_byte_sequence,
                           "unexpected end of data at offset 0x%" PRIx64,
                           Offset);
}

static bool isError(Error *E) { return E && *E; }

template <typename T>
static T getU(uint64_t *offset_ptr, const DataExtractor *de,
              bool isLittleEndian, const char *Data, llvm::Error *Err) {
  ErrorAsOutParameter ErrAsOut(Err);
  T val = 0;
  if (isError(Err))
    return val;

  uint64_t offset = *offset_ptr;
  if (!de->isValidOffsetForDataOfSize(offset, sizeof(T))) {
    unexpectedEndReached(Err, offset);
    return val;
  }
  std::memcpy(&val, &Data[offset], sizeof(val));
  if (sys::IsLittleEndianHost != isLittleEndian)
    sys::swapByteOrder(val);

  // Advance the offset
  *offset_ptr += sizeof(val);
  return val;
}

template <typename T>
static T *getUs(uint64_t *offset_ptr, T *dst, uint32_t count,
                const DataExtractor *de, bool isLittleEndian, const char *Data,
                llvm::Error *Err) {
  ErrorAsOutParameter ErrAsOut(Err);
  if (isError(Err))
    return nullptr;

  uint64_t offset = *offset_ptr;

  if (!de->isValidOffsetForDataOfSize(offset, sizeof(*dst) * count)) {
    unexpectedEndReached(Err, offset);
    return nullptr;
  }
  for (T *value_ptr = dst, *end = dst + count; value_ptr != end;
       ++value_ptr, offset += sizeof(*dst))
    *value_ptr = getU<T>(offset_ptr, de, isLittleEndian, Data, Err);
  // Advance the offset
  *offset_ptr = offset;
  // Return a non-NULL pointer to the converted data as an indicator of
  // success
  return dst;
}

uint8_t DataExtractor::getU8(uint64_t *offset_ptr, llvm::Error *Err) const {
  return getU<uint8_t>(offset_ptr, this, IsLittleEndian, Data.data(), Err);
}

uint8_t *
DataExtractor::getU8(uint64_t *offset_ptr, uint8_t *dst, uint32_t count) const {
  return getUs<uint8_t>(offset_ptr, dst, count, this, IsLittleEndian,
                        Data.data(), nullptr);
}

uint8_t *DataExtractor::getU8(Cursor &C, uint8_t *Dst, uint32_t Count) const {
  return getUs<uint8_t>(&C.Offset, Dst, Count, this, IsLittleEndian,
                        Data.data(), &C.Err);
}

uint16_t DataExtractor::getU16(uint64_t *offset_ptr, llvm::Error *Err) const {
  return getU<uint16_t>(offset_ptr, this, IsLittleEndian, Data.data(), Err);
}

uint16_t *DataExtractor::getU16(uint64_t *offset_ptr, uint16_t *dst,
                                uint32_t count) const {
  return getUs<uint16_t>(offset_ptr, dst, count, this, IsLittleEndian,
                         Data.data(), nullptr);
}

uint32_t DataExtractor::getU24(uint64_t *OffsetPtr, Error *Err) const {
  uint24_t ExtractedVal =
      getU<uint24_t>(OffsetPtr, this, IsLittleEndian, Data.data(), Err);
  // The 3 bytes are in the correct byte order for the host.
  return ExtractedVal.getAsUint32(sys::IsLittleEndianHost);
}

uint32_t DataExtractor::getU32(uint64_t *offset_ptr, llvm::Error *Err) const {
  return getU<uint32_t>(offset_ptr, this, IsLittleEndian, Data.data(), Err);
}

uint32_t *DataExtractor::getU32(uint64_t *offset_ptr, uint32_t *dst,
                                uint32_t count) const {
  return getUs<uint32_t>(offset_ptr, dst, count, this, IsLittleEndian,
                         Data.data(), nullptr);
}

uint64_t DataExtractor::getU64(uint64_t *offset_ptr, llvm::Error *Err) const {
  return getU<uint64_t>(offset_ptr, this, IsLittleEndian, Data.data(), Err);
}

uint64_t *DataExtractor::getU64(uint64_t *offset_ptr, uint64_t *dst,
                                uint32_t count) const {
  return getUs<uint64_t>(offset_ptr, dst, count, this, IsLittleEndian,
                         Data.data(), nullptr);
}

uint64_t DataExtractor::getUnsigned(uint64_t *offset_ptr, uint32_t byte_size,
                                    llvm::Error *Err) const {
  switch (byte_size) {
  case 1:
    return getU8(offset_ptr, Err);
  case 2:
    return getU16(offset_ptr, Err);
  case 4:
    return getU32(offset_ptr, Err);
  case 8:
    return getU64(offset_ptr, Err);
  }
  llvm_unreachable("getUnsigned unhandled case!");
}

int64_t
DataExtractor::getSigned(uint64_t *offset_ptr, uint32_t byte_size) const {
  switch (byte_size) {
  case 1:
    return (int8_t)getU8(offset_ptr);
  case 2:
    return (int16_t)getU16(offset_ptr);
  case 4:
    return (int32_t)getU32(offset_ptr);
  case 8:
    return (int64_t)getU64(offset_ptr);
  }
  llvm_unreachable("getSigned unhandled case!");
}

StringRef DataExtractor::getCStrRef(uint64_t *OffsetPtr, Error *Err) const {
  ErrorAsOutParameter ErrAsOut(Err);
  if (isError(Err))
    return StringRef();

  uint64_t Start = *OffsetPtr;
  StringRef::size_type Pos = Data.find('\0', Start);
  if (Pos != StringRef::npos) {
    *OffsetPtr = Pos + 1;
    return StringRef(Data.data() + Start, Pos - Start);
  }
  unexpectedEndReached(Err, Start);
  return StringRef();
}

StringRef DataExtractor::getFixedLengthString(uint64_t *OffsetPtr,
                                              uint64_t Length,
                                              StringRef TrimChars) const {
  StringRef Bytes(getBytes(OffsetPtr, Length));
  return Bytes.trim(TrimChars);
}

StringRef DataExtractor::getBytes(uint64_t *OffsetPtr, uint64_t Length,
                                  Error *Err) const {
  ErrorAsOutParameter ErrAsOut(Err);
  if (isError(Err))
    return StringRef();

  if (!isValidOffsetForDataOfSize(*OffsetPtr, Length)) {
    unexpectedEndReached(Err, *OffsetPtr);
    return StringRef();
  }

  StringRef Result = Data.substr(*OffsetPtr, Length);
  *OffsetPtr += Length;
  return Result;
}

template <typename T>
static T getLEB128(StringRef Data, uint64_t *OffsetPtr, Error *Err,
                   T (&Decoder)(const uint8_t *p, unsigned *n,
                                const uint8_t *end, const char **error)) {
  ArrayRef<uint8_t> Bytes = arrayRefFromStringRef(Data);
  assert(*OffsetPtr <= Bytes.size());
  ErrorAsOutParameter ErrAsOut(Err);
  if (isError(Err))
    return T();

  const char *error;
  unsigned bytes_read;
  T result =
      Decoder(Bytes.data() + *OffsetPtr, &bytes_read, Bytes.end(), &error);
  if (error) {
    if (Err)
      *Err = createStringError(errc::illegal_byte_sequence,
                               "unable to decode LEB128 at offset 0x%8.8" PRIx64
                               ": %s",
                               *OffsetPtr, error);
    return T();
  }
  *OffsetPtr += bytes_read;
  return result;
}

uint64_t DataExtractor::getULEB128(uint64_t *offset_ptr, Error *Err) const {
  return getLEB128(Data, offset_ptr, Err, decodeULEB128);
}

int64_t DataExtractor::getSLEB128(uint64_t *offset_ptr, Error *Err) const {
  return getLEB128(Data, offset_ptr, Err, decodeSLEB128);
}

void DataExtractor::skip(Cursor &C, uint64_t Length) const {
  ErrorAsOutParameter ErrAsOut(&C.Err);
  if (isError(&C.Err))
    return;

  if (isValidOffsetForDataOfSize(C.Offset, Length))
    C.Offset += Length;
  else
    unexpectedEndReached(&C.Err, C.Offset);
}
