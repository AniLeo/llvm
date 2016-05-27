//===- NameMap.cpp - PDB Name Map -------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DebugInfo/PDB/Raw/NameMap.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/DebugInfo/CodeView/StreamReader.h"
#include "llvm/DebugInfo/PDB/Raw/RawError.h"

using namespace llvm;
using namespace llvm::pdb;

NameMap::NameMap() {}

Error NameMap::load(codeview::StreamReader &Stream) {

  // This is some sort of weird string-set/hash table encoded in the stream.
  // It starts with the number of bytes in the table.
  uint32_t NumberOfBytes;
  if (auto EC = Stream.readInteger(NumberOfBytes))
    return joinErrors(std::move(EC),
                      make_error<RawError>(raw_error_code::corrupt_file,
                                           "Expected name map length"));
  if (Stream.bytesRemaining() < NumberOfBytes)
    return make_error<RawError>(raw_error_code::corrupt_file,
                                "Invalid name map length");

  // Following that field is the starting offset of strings in the name table.
  uint32_t StringsOffset = Stream.getOffset();
  Stream.setOffset(StringsOffset + NumberOfBytes);

  // This appears to be equivalent to the total number of strings *actually*
  // in the name table.
  uint32_t HashSize;
  if (auto EC = Stream.readInteger(HashSize))
    return joinErrors(std::move(EC),
                      make_error<RawError>(raw_error_code::corrupt_file,
                                           "Expected name map hash size"));

  // This appears to be an upper bound on the number of strings in the name
  // table.
  uint32_t MaxNumberOfStrings;
  if (auto EC = Stream.readInteger(MaxNumberOfStrings))
    return joinErrors(std::move(EC),
                      make_error<RawError>(raw_error_code::corrupt_file,
                                           "Expected name map max strings"));

  // This appears to be a hash table which uses bitfields to determine whether
  // or not a bucket is 'present'.
  uint32_t NumPresentWords;
  if (auto EC = Stream.readInteger(NumPresentWords))
    return joinErrors(std::move(EC),
                      make_error<RawError>(raw_error_code::corrupt_file,
                                           "Expected name map num words"));

  // Store all the 'present' bits in a vector for later processing.
  SmallVector<uint32_t, 1> PresentWords;
  for (uint32_t I = 0; I != NumPresentWords; ++I) {
    uint32_t Word;
    if (auto EC = Stream.readInteger(Word))
      return joinErrors(std::move(EC),
                        make_error<RawError>(raw_error_code::corrupt_file,
                                             "Expected name map word"));

    PresentWords.push_back(Word);
  }

  // This appears to be a hash table which uses bitfields to determine whether
  // or not a bucket is 'deleted'.
  uint32_t NumDeletedWords;
  if (auto EC = Stream.readInteger(NumDeletedWords))
    return joinErrors(
        std::move(EC),
        make_error<RawError>(raw_error_code::corrupt_file,
                             "Expected name map num deleted words"));

  // Store all the 'deleted' bits in a vector for later processing.
  SmallVector<uint32_t, 1> DeletedWords;
  for (uint32_t I = 0; I != NumDeletedWords; ++I) {
    uint32_t Word;
    if (auto EC = Stream.readInteger(Word))
      return joinErrors(std::move(EC),
                        make_error<RawError>(raw_error_code::corrupt_file,
                                             "Expected name map deleted word"));

    DeletedWords.push_back(Word);
  }

  BitVector Present(MaxNumberOfStrings, false);
  if (!PresentWords.empty())
    Present.setBitsInMask(PresentWords.data(), PresentWords.size());
  BitVector Deleted(MaxNumberOfStrings, false);
  if (!DeletedWords.empty())
    Deleted.setBitsInMask(DeletedWords.data(), DeletedWords.size());

  for (uint32_t I = 0; I < MaxNumberOfStrings; ++I) {
    if (!Present.test(I))
      continue;

    // For all present entries, dump out their mapping.

    // This appears to be an offset relative to the start of the strings.
    // It tells us where the null-terminated string begins.
    uint32_t NameOffset;
    if (auto EC = Stream.readInteger(NameOffset))
      return joinErrors(std::move(EC),
                        make_error<RawError>(raw_error_code::corrupt_file,
                                             "Expected name map name offset"));

    // This appears to be a stream number into the stream directory.
    uint32_t NameIndex;
    if (auto EC = Stream.readInteger(NameIndex))
      return joinErrors(std::move(EC),
                        make_error<RawError>(raw_error_code::corrupt_file,
                                             "Expected name map name index"));

    // Compute the offset of the start of the string relative to the stream.
    uint32_t StringOffset = StringsOffset + NameOffset;
    uint32_t OldOffset = Stream.getOffset();
    // Pump out our c-string from the stream.
    StringRef Str;
    Stream.setOffset(StringOffset);
    if (auto EC = Stream.readZeroString(Str))
      return joinErrors(std::move(EC),
                        make_error<RawError>(raw_error_code::corrupt_file,
                                             "Expected name map name"));

    Stream.setOffset(OldOffset);
    // Add this to a string-map from name to stream number.
    Mapping.insert({Str, NameIndex});
  }

  return Error::success();
}

iterator_range<StringMapConstIterator<uint32_t>> NameMap::entries() const {
  return llvm::make_range<StringMapConstIterator<uint32_t>>(Mapping.begin(),
                                                            Mapping.end());
}

bool NameMap::tryGetValue(StringRef Name, uint32_t &Value) const {
  auto Iter = Mapping.find(Name);
  if (Iter == Mapping.end())
    return false;
  Value = Iter->second;
  return true;
}
