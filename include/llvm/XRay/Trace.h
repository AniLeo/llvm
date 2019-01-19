//===- Trace.h - XRay Trace Abstraction -----------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Defines the XRay Trace class representing records in an XRay trace file.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_XRAY_TRACE_H
#define LLVM_XRAY_TRACE_H

#include <cstdint>
#include <vector>

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/DataExtractor.h"
#include "llvm/Support/Error.h"
#include "llvm/XRay/XRayRecord.h"

namespace llvm {
namespace xray {

/// A Trace object represents the records that have been loaded from XRay
/// log files generated by instrumented binaries. We encapsulate the logic of
/// reading the traces in factory functions that populate the Trace object
/// appropriately.
///
/// Trace objects provide an accessor to an XRayFileHeader which says more about
/// details of the file from which the XRay trace was loaded from.
///
/// Usage:
///
///   if (auto TraceOrErr = loadTraceFile("xray-log.something.xray")) {
///     auto& T = *TraceOrErr;
///     // T.getFileHeader() will provide information from the trace header.
///     for (const XRayRecord &R : T) {
///       // ... do something with R here.
///     }
///   } else {
///     // Handle the error here.
///   }
///
class Trace {
  XRayFileHeader FileHeader;
  using RecordVector = std::vector<XRayRecord>;
  RecordVector Records;

  typedef std::vector<XRayRecord>::const_iterator citerator;

  friend Expected<Trace> loadTrace(const DataExtractor &, bool);

public:
  using size_type = RecordVector::size_type;
  using value_type = RecordVector::value_type;
  using const_iterator = RecordVector::const_iterator;

  /// Provides access to the loaded XRay trace file header.
  const XRayFileHeader &getFileHeader() const { return FileHeader; }

  const_iterator begin() const { return Records.begin(); }
  const_iterator end() const { return Records.end(); }
  bool empty() const { return Records.empty(); }
  size_type size() const { return Records.size(); }
};

/// This function will attempt to load XRay trace records from the provided
/// |Filename|.
Expected<Trace> loadTraceFile(StringRef Filename, bool Sort = false);

/// This function will attempt to load XRay trace records from the provided
/// DataExtractor.
Expected<Trace> loadTrace(const DataExtractor &Extractor, bool Sort = false);

} // namespace xray
} // namespace llvm

#endif // LLVM_XRAY_TRACE_H
