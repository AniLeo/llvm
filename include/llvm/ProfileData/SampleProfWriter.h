//===- SampleProfWriter.h - Write LLVM sample profile data ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains definitions needed for writing sample profiles.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_PROFILEDATA_SAMPLEPROFWRITER_H
#define LLVM_PROFILEDATA_SAMPLEPROFWRITER_H

#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IR/ProfileSummary.h"
#include "llvm/ProfileData/SampleProf.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cstdint>
#include <memory>
#include <set>
#include <system_error>

namespace llvm {
namespace sampleprof {

/// Sample-based profile writer. Base class.
class SampleProfileWriter {
public:
  virtual ~SampleProfileWriter() = default;

  /// Write sample profiles in \p S.
  ///
  /// \returns status code of the file update operation.
  virtual std::error_code writeSample(const FunctionSamples &S) = 0;

  /// Write all the sample profiles in the given map of samples.
  ///
  /// \returns status code of the file update operation.
  virtual std::error_code write(const StringMap<FunctionSamples> &ProfileMap);

  raw_ostream &getOutputStream() { return *OutputStream; }

  /// Profile writer factory.
  ///
  /// Create a new file writer based on the value of \p Format.
  static ErrorOr<std::unique_ptr<SampleProfileWriter>>
  create(StringRef Filename, SampleProfileFormat Format);

  /// Create a new stream writer based on the value of \p Format.
  /// For testing.
  static ErrorOr<std::unique_ptr<SampleProfileWriter>>
  create(std::unique_ptr<raw_ostream> &OS, SampleProfileFormat Format);

  virtual void setProfileSymbolList(ProfileSymbolList *PSL) {}

protected:
  SampleProfileWriter(std::unique_ptr<raw_ostream> &OS)
      : OutputStream(std::move(OS)) {}

  /// Write a file header for the profile file.
  virtual std::error_code
  writeHeader(const StringMap<FunctionSamples> &ProfileMap) = 0;

  // Write function profiles to the profile file.
  virtual std::error_code
  writeFuncProfiles(const StringMap<FunctionSamples> &ProfileMap);

  /// Output stream where to emit the profile to.
  std::unique_ptr<raw_ostream> OutputStream;

  /// Profile summary.
  std::unique_ptr<ProfileSummary> Summary;

  /// Compute summary for this profile.
  void computeSummary(const StringMap<FunctionSamples> &ProfileMap);

  /// Profile format.
  SampleProfileFormat Format;
};

/// Sample-based profile writer (text format).
class SampleProfileWriterText : public SampleProfileWriter {
public:
  std::error_code writeSample(const FunctionSamples &S) override;

protected:
  SampleProfileWriterText(std::unique_ptr<raw_ostream> &OS)
      : SampleProfileWriter(OS), Indent(0) {}

  std::error_code
  writeHeader(const StringMap<FunctionSamples> &ProfileMap) override {
    return sampleprof_error::success;
  }

private:
  /// Indent level to use when writing.
  ///
  /// This is used when printing inlined callees.
  unsigned Indent;

  friend ErrorOr<std::unique_ptr<SampleProfileWriter>>
  SampleProfileWriter::create(std::unique_ptr<raw_ostream> &OS,
                              SampleProfileFormat Format);
};

/// Sample-based profile writer (binary format).
class SampleProfileWriterBinary : public SampleProfileWriter {
public:
  SampleProfileWriterBinary(std::unique_ptr<raw_ostream> &OS)
      : SampleProfileWriter(OS) {}

  virtual std::error_code writeSample(const FunctionSamples &S) override;

protected:
  virtual std::error_code writeMagicIdent(SampleProfileFormat Format);
  virtual std::error_code writeNameTable();
  virtual std::error_code
  writeHeader(const StringMap<FunctionSamples> &ProfileMap) override;
  std::error_code writeSummary();
  std::error_code writeNameIdx(StringRef FName);
  std::error_code writeBody(const FunctionSamples &S);
  inline void stablizeNameTable(std::set<StringRef> &V);

  MapVector<StringRef, uint32_t> NameTable;

  void addName(StringRef FName);
  void addNames(const FunctionSamples &S);

private:
  friend ErrorOr<std::unique_ptr<SampleProfileWriter>>
  SampleProfileWriter::create(std::unique_ptr<raw_ostream> &OS,
                              SampleProfileFormat Format);
};

class SampleProfileWriterRawBinary : public SampleProfileWriterBinary {
  using SampleProfileWriterBinary::SampleProfileWriterBinary;
};

class SampleProfileWriterExtBinaryBase : public SampleProfileWriterBinary {
  using SampleProfileWriterBinary::SampleProfileWriterBinary;
public:
  virtual std::error_code
  write(const StringMap<FunctionSamples> &ProfileMap) override;

  void setToCompressAllSections();
  void setToCompressSection(SecType Type);

protected:
  uint64_t markSectionStart(SecType Type);
  std::error_code addNewSection(SecType Sec, uint64_t SectionStart);
  virtual void initSectionLayout() = 0;
  virtual std::error_code
  writeSections(const StringMap<FunctionSamples> &ProfileMap) = 0;

  // Specifiy the section layout in the profile. Note that the order in
  // SecHdrTable (order to collect sections) may be different from the
  // order in SectionLayout (order to write out sections into profile).
  SmallVector<SecHdrTableEntry, 8> SectionLayout;

private:
  void allocSecHdrTable();
  std::error_code writeSecHdrTable();
  virtual std::error_code
  writeHeader(const StringMap<FunctionSamples> &ProfileMap) override;
  void addSectionFlags(SecType Type, SecFlags Flags);
  SecHdrTableEntry &getEntryInLayout(SecType Type);
  std::error_code compressAndOutput();

  // We will swap the raw_ostream held by LocalBufStream and that
  // held by OutputStream if we try to add a section which needs
  // compression. After the swap, all the data written to output
  // will be temporarily buffered into the underlying raw_string_ostream
  // originally held by LocalBufStream. After the data writing for the
  // section is completed, compress the data in the local buffer,
  // swap the raw_ostream back and write the compressed data to the
  // real output.
  std::unique_ptr<raw_ostream> LocalBufStream;
  // The location where the output stream starts.
  uint64_t FileStart;
  // The location in the output stream where the SecHdrTable should be
  // written to.
  uint64_t SecHdrTableOffset;
  // Initial Section Flags setting.
  std::vector<SecHdrTableEntry> SecHdrTable;
};

class SampleProfileWriterExtBinary : public SampleProfileWriterExtBinaryBase {
public:
  SampleProfileWriterExtBinary(std::unique_ptr<raw_ostream> &OS)
      : SampleProfileWriterExtBinaryBase(OS) {
    initSectionLayout();
  }

  virtual void setProfileSymbolList(ProfileSymbolList *PSL) override {
    ProfSymList = PSL;
  };

private:
  virtual void initSectionLayout() override {
    SectionLayout = {{SecProfSummary},
                     {SecNameTable},
                     {SecLBRProfile},
                     {SecProfileSymbolList}};
  };
  virtual std::error_code
  writeSections(const StringMap<FunctionSamples> &ProfileMap) override;
  ProfileSymbolList *ProfSymList = nullptr;
};

// CompactBinary is a compact format of binary profile which both reduces
// the profile size and the load time needed when compiling. It has two
// major difference with Binary format.
// 1. It represents all the strings in name table using md5 hash.
// 2. It saves a function offset table which maps function name index to
// the offset of its function profile to the start of the binary profile,
// so by using the function offset table, for those function profiles which
// will not be needed when compiling a module, the profile reader does't
// have to read them and it saves compile time if the profile size is huge.
// The layout of the compact format is shown as follows:
//
//    Part1: Profile header, the same as binary format, containing magic
//           number, version, summary, name table...
//    Part2: Function Offset Table Offset, which saves the position of
//           Part4.
//    Part3: Function profile collection
//             function1 profile start
//                 ....
//             function2 profile start
//                 ....
//             function3 profile start
//                 ....
//                ......
//    Part4: Function Offset Table
//             function1 name index --> function1 profile start
//             function2 name index --> function2 profile start
//             function3 name index --> function3 profile start
//
// We need Part2 because profile reader can use it to find out and read
// function offset table without reading Part3 first.
class SampleProfileWriterCompactBinary : public SampleProfileWriterBinary {
  using SampleProfileWriterBinary::SampleProfileWriterBinary;

public:
  virtual std::error_code writeSample(const FunctionSamples &S) override;
  virtual std::error_code
  write(const StringMap<FunctionSamples> &ProfileMap) override;

protected:
  /// The table mapping from function name to the offset of its FunctionSample
  /// towards profile start.
  MapVector<StringRef, uint64_t> FuncOffsetTable;
  /// The offset of the slot to be filled with the offset of FuncOffsetTable
  /// towards profile start.
  uint64_t TableOffset;
  virtual std::error_code writeNameTable() override;
  virtual std::error_code
  writeHeader(const StringMap<FunctionSamples> &ProfileMap) override;
  std::error_code writeFuncOffsetTable();
};

} // end namespace sampleprof
} // end namespace llvm

#endif // LLVM_PROFILEDATA_SAMPLEPROFWRITER_H
