//=-- CoverageMapping.h - Code coverage mapping support ---------*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Code coverage mapping data is generated by clang and read by
// llvm-cov to show code coverage statistics for a file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_PROFILEDATA_COVERAGEMAPPING_H_
#define LLVM_PROFILEDATA_COVERAGEMAPPING_H_

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/Triple.h"
#include "llvm/ADT/iterator.h"
#include "llvm/ProfileData/InstrProf.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/Endian.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/raw_ostream.h"
#include <system_error>
#include <tuple>

namespace llvm {
namespace coverage {
enum class coveragemap_error {
  success = 0,
  eof,
  no_data_found,
  unsupported_version,
  truncated,
  malformed
};
} // end of coverage namespace.
}

namespace std {
template <>
struct is_error_code_enum<llvm::coverage::coveragemap_error> : std::true_type {
};
}

namespace llvm {
class IndexedInstrProfReader;
namespace coverage {

class CoverageMappingReader;

class CoverageMapping;
struct CounterExpressions;

/// \brief A Counter is an abstract value that describes how to compute the
/// execution count for a region of code using the collected profile count data.
struct Counter {
  enum CounterKind { Zero, CounterValueReference, Expression };
  static const unsigned EncodingTagBits = 2;
  static const unsigned EncodingTagMask = 0x3;
  static const unsigned EncodingCounterTagAndExpansionRegionTagBits =
      EncodingTagBits + 1;

private:
  CounterKind Kind;
  unsigned ID;

  Counter(CounterKind Kind, unsigned ID) : Kind(Kind), ID(ID) {}

public:
  Counter() : Kind(Zero), ID(0) {}

  CounterKind getKind() const { return Kind; }

  bool isZero() const { return Kind == Zero; }

  bool isExpression() const { return Kind == Expression; }

  unsigned getCounterID() const { return ID; }

  unsigned getExpressionID() const { return ID; }

  friend bool operator==(const Counter &LHS, const Counter &RHS) {
    return LHS.Kind == RHS.Kind && LHS.ID == RHS.ID;
  }

  friend bool operator!=(const Counter &LHS, const Counter &RHS) {
    return !(LHS == RHS);
  }

  friend bool operator<(const Counter &LHS, const Counter &RHS) {
    return std::tie(LHS.Kind, LHS.ID) < std::tie(RHS.Kind, RHS.ID);
  }

  /// \brief Return the counter that represents the number zero.
  static Counter getZero() { return Counter(); }

  /// \brief Return the counter that corresponds to a specific profile counter.
  static Counter getCounter(unsigned CounterId) {
    return Counter(CounterValueReference, CounterId);
  }

  /// \brief Return the counter that corresponds to a specific
  /// addition counter expression.
  static Counter getExpression(unsigned ExpressionId) {
    return Counter(Expression, ExpressionId);
  }
};

/// \brief A Counter expression is a value that represents an arithmetic
/// operation with two counters.
struct CounterExpression {
  enum ExprKind { Subtract, Add };
  ExprKind Kind;
  Counter LHS, RHS;

  CounterExpression(ExprKind Kind, Counter LHS, Counter RHS)
      : Kind(Kind), LHS(LHS), RHS(RHS) {}
};

/// \brief A Counter expression builder is used to construct the
/// counter expressions. It avoids unnecessary duplication
/// and simplifies algebraic expressions.
class CounterExpressionBuilder {
  /// \brief A list of all the counter expressions
  std::vector<CounterExpression> Expressions;
  /// \brief A lookup table for the index of a given expression.
  llvm::DenseMap<CounterExpression, unsigned> ExpressionIndices;

  /// \brief Return the counter which corresponds to the given expression.
  ///
  /// If the given expression is already stored in the builder, a counter
  /// that references that expression is returned. Otherwise, the given
  /// expression is added to the builder's collection of expressions.
  Counter get(const CounterExpression &E);

  /// \brief Gather the terms of the expression tree for processing.
  ///
  /// This collects each addition and subtraction referenced by the counter into
  /// a sequence that can be sorted and combined to build a simplified counter
  /// expression.
  void extractTerms(Counter C, int Sign,
                    SmallVectorImpl<std::pair<unsigned, int>> &Terms);

  /// \brief Simplifies the given expression tree
  /// by getting rid of algebraically redundant operations.
  Counter simplify(Counter ExpressionTree);

public:
  ArrayRef<CounterExpression> getExpressions() const { return Expressions; }

  /// \brief Return a counter that represents the expression
  /// that adds LHS and RHS.
  Counter add(Counter LHS, Counter RHS);

  /// \brief Return a counter that represents the expression
  /// that subtracts RHS from LHS.
  Counter subtract(Counter LHS, Counter RHS);
};

/// \brief A Counter mapping region associates a source range with
/// a specific counter.
struct CounterMappingRegion {
  enum RegionKind {
    /// \brief A CodeRegion associates some code with a counter
    CodeRegion,

    /// \brief An ExpansionRegion represents a file expansion region that
    /// associates a source range with the expansion of a virtual source file,
    /// such as for a macro instantiation or #include file.
    ExpansionRegion,

    /// \brief A SkippedRegion represents a source range with code that
    /// was skipped by a preprocessor or similar means.
    SkippedRegion
  };

  Counter Count;
  unsigned FileID, ExpandedFileID;
  unsigned LineStart, ColumnStart, LineEnd, ColumnEnd;
  RegionKind Kind;

  CounterMappingRegion(Counter Count, unsigned FileID, unsigned ExpandedFileID,
                       unsigned LineStart, unsigned ColumnStart,
                       unsigned LineEnd, unsigned ColumnEnd, RegionKind Kind)
      : Count(Count), FileID(FileID), ExpandedFileID(ExpandedFileID),
        LineStart(LineStart), ColumnStart(ColumnStart), LineEnd(LineEnd),
        ColumnEnd(ColumnEnd), Kind(Kind) {}

  static CounterMappingRegion
  makeRegion(Counter Count, unsigned FileID, unsigned LineStart,
             unsigned ColumnStart, unsigned LineEnd, unsigned ColumnEnd) {
    return CounterMappingRegion(Count, FileID, 0, LineStart, ColumnStart,
                                LineEnd, ColumnEnd, CodeRegion);
  }

  static CounterMappingRegion
  makeExpansion(unsigned FileID, unsigned ExpandedFileID, unsigned LineStart,
                unsigned ColumnStart, unsigned LineEnd, unsigned ColumnEnd) {
    return CounterMappingRegion(Counter(), FileID, ExpandedFileID, LineStart,
                                ColumnStart, LineEnd, ColumnEnd,
                                ExpansionRegion);
  }

  static CounterMappingRegion
  makeSkipped(unsigned FileID, unsigned LineStart, unsigned ColumnStart,
              unsigned LineEnd, unsigned ColumnEnd) {
    return CounterMappingRegion(Counter(), FileID, 0, LineStart, ColumnStart,
                                LineEnd, ColumnEnd, SkippedRegion);
  }


  inline std::pair<unsigned, unsigned> startLoc() const {
    return std::pair<unsigned, unsigned>(LineStart, ColumnStart);
  }

  inline std::pair<unsigned, unsigned> endLoc() const {
    return std::pair<unsigned, unsigned>(LineEnd, ColumnEnd);
  }

  bool operator<(const CounterMappingRegion &Other) const {
    if (FileID != Other.FileID)
      return FileID < Other.FileID;
    return startLoc() < Other.startLoc();
  }

  bool contains(const CounterMappingRegion &Other) const {
    if (FileID != Other.FileID)
      return false;
    if (startLoc() > Other.startLoc())
      return false;
    if (endLoc() < Other.endLoc())
      return false;
    return true;
  }
};

/// \brief Associates a source range with an execution count.
struct CountedRegion : public CounterMappingRegion {
  uint64_t ExecutionCount;

  CountedRegion(const CounterMappingRegion &R, uint64_t ExecutionCount)
      : CounterMappingRegion(R), ExecutionCount(ExecutionCount) {}
};

/// \brief A Counter mapping context is used to connect the counters,
/// expressions and the obtained counter values.
class CounterMappingContext {
  ArrayRef<CounterExpression> Expressions;
  ArrayRef<uint64_t> CounterValues;

public:
  CounterMappingContext(ArrayRef<CounterExpression> Expressions,
                        ArrayRef<uint64_t> CounterValues = None)
      : Expressions(Expressions), CounterValues(CounterValues) {}

  void setCounts(ArrayRef<uint64_t> Counts) { CounterValues = Counts; }

  void dump(const Counter &C, llvm::raw_ostream &OS) const;
  void dump(const Counter &C) const { dump(C, dbgs()); }

  /// \brief Return the number of times that a region of code associated with
  /// this counter was executed.
  ErrorOr<int64_t> evaluate(const Counter &C) const;
};

/// \brief Code coverage information for a single function.
struct FunctionRecord {
  /// \brief Raw function name.
  std::string Name;
  /// \brief Associated files.
  std::vector<std::string> Filenames;
  /// \brief Regions in the function along with their counts.
  std::vector<CountedRegion> CountedRegions;
  /// \brief The number of times this function was executed.
  uint64_t ExecutionCount;

  FunctionRecord(StringRef Name, ArrayRef<StringRef> Filenames)
      : Name(Name), Filenames(Filenames.begin(), Filenames.end()) {}

  void pushRegion(CounterMappingRegion Region, uint64_t Count) {
    if (CountedRegions.empty())
      ExecutionCount = Count;
    CountedRegions.emplace_back(Region, Count);
  }
};

/// \brief Iterator over Functions, optionally filtered to a single file.
class FunctionRecordIterator
    : public iterator_facade_base<FunctionRecordIterator,
                                  std::forward_iterator_tag, FunctionRecord> {
  ArrayRef<FunctionRecord> Records;
  ArrayRef<FunctionRecord>::iterator Current;
  StringRef Filename;

  /// \brief Skip records whose primary file is not \c Filename.
  void skipOtherFiles();

public:
  FunctionRecordIterator(ArrayRef<FunctionRecord> Records_,
                         StringRef Filename = "")
      : Records(Records_), Current(Records.begin()), Filename(Filename) {
    skipOtherFiles();
  }

  FunctionRecordIterator() : Current(Records.begin()) {}

  bool operator==(const FunctionRecordIterator &RHS) const {
    return Current == RHS.Current && Filename == RHS.Filename;
  }

  const FunctionRecord &operator*() const { return *Current; }

  FunctionRecordIterator &operator++() {
    assert(Current != Records.end() && "incremented past end");
    ++Current;
    skipOtherFiles();
    return *this;
  }
};

/// \brief Coverage information for a macro expansion or #included file.
///
/// When covered code has pieces that can be expanded for more detail, such as a
/// preprocessor macro use and its definition, these are represented as
/// expansions whose coverage can be looked up independently.
struct ExpansionRecord {
  /// \brief The abstract file this expansion covers.
  unsigned FileID;
  /// \brief The region that expands to this record.
  const CountedRegion &Region;
  /// \brief Coverage for the expansion.
  const FunctionRecord &Function;

  ExpansionRecord(const CountedRegion &Region,
                  const FunctionRecord &Function)
      : FileID(Region.ExpandedFileID), Region(Region), Function(Function) {}
};

/// \brief The execution count information starting at a point in a file.
///
/// A sequence of CoverageSegments gives execution counts for a file in format
/// that's simple to iterate through for processing.
struct CoverageSegment {
  /// \brief The line where this segment begins.
  unsigned Line;
  /// \brief The column where this segment begins.
  unsigned Col;
  /// \brief The execution count, or zero if no count was recorded.
  uint64_t Count;
  /// \brief When false, the segment was uninstrumented or skipped.
  bool HasCount;
  /// \brief Whether this enters a new region or returns to a previous count.
  bool IsRegionEntry;

  CoverageSegment(unsigned Line, unsigned Col, bool IsRegionEntry)
      : Line(Line), Col(Col), Count(0), HasCount(false),
        IsRegionEntry(IsRegionEntry) {}

  CoverageSegment(unsigned Line, unsigned Col, uint64_t Count,
                  bool IsRegionEntry)
      : Line(Line), Col(Col), Count(Count), HasCount(true),
        IsRegionEntry(IsRegionEntry) {}

  friend bool operator==(const CoverageSegment &L, const CoverageSegment &R) {
    return std::tie(L.Line, L.Col, L.Count, L.HasCount, L.IsRegionEntry) ==
           std::tie(R.Line, R.Col, R.Count, R.HasCount, R.IsRegionEntry);
  }
};

/// \brief Coverage information to be processed or displayed.
///
/// This represents the coverage of an entire file, expansion, or function. It
/// provides a sequence of CoverageSegments to iterate through, as well as the
/// list of expansions that can be further processed.
class CoverageData {
  std::string Filename;
  std::vector<CoverageSegment> Segments;
  std::vector<ExpansionRecord> Expansions;
  friend class CoverageMapping;

public:
  CoverageData() {}

  CoverageData(StringRef Filename) : Filename(Filename) {}

  CoverageData(CoverageData &&RHS)
      : Filename(std::move(RHS.Filename)), Segments(std::move(RHS.Segments)),
        Expansions(std::move(RHS.Expansions)) {}

  /// \brief Get the name of the file this data covers.
  StringRef getFilename() { return Filename; }

  std::vector<CoverageSegment>::iterator begin() { return Segments.begin(); }
  std::vector<CoverageSegment>::iterator end() { return Segments.end(); }
  bool empty() { return Segments.empty(); }

  /// \brief Expansions that can be further processed.
  std::vector<ExpansionRecord> getExpansions() { return Expansions; }
};

/// \brief The mapping of profile information to coverage data.
///
/// This is the main interface to get coverage information, using a profile to
/// fill out execution counts.
class CoverageMapping {
  std::vector<FunctionRecord> Functions;
  unsigned MismatchedFunctionCount;

  CoverageMapping() : MismatchedFunctionCount(0) {}

public:
  /// \brief Load the coverage mapping using the given readers.
  static ErrorOr<std::unique_ptr<CoverageMapping>>
  load(CoverageMappingReader &CoverageReader,
       IndexedInstrProfReader &ProfileReader);

  /// \brief Load the coverage mapping from the given files.
  static ErrorOr<std::unique_ptr<CoverageMapping>>
  load(StringRef ObjectFilename, StringRef ProfileFilename,
       StringRef Arch = StringRef());

  /// \brief The number of functions that couldn't have their profiles mapped.
  ///
  /// This is a count of functions whose profile is out of date or otherwise
  /// can't be associated with any coverage information.
  unsigned getMismatchedCount() { return MismatchedFunctionCount; }

  /// \brief Returns the list of files that are covered.
  std::vector<StringRef> getUniqueSourceFiles() const;

  /// \brief Get the coverage for a particular file.
  ///
  /// The given filename must be the name as recorded in the coverage
  /// information. That is, only names returned from getUniqueSourceFiles will
  /// yield a result.
  CoverageData getCoverageForFile(StringRef Filename);

  /// \brief Gets all of the functions covered by this profile.
  iterator_range<FunctionRecordIterator> getCoveredFunctions() const {
    return make_range(FunctionRecordIterator(Functions),
                      FunctionRecordIterator());
  }

  /// \brief Gets all of the functions in a particular file.
  iterator_range<FunctionRecordIterator>
  getCoveredFunctions(StringRef Filename) const {
    return make_range(FunctionRecordIterator(Functions, Filename),
                      FunctionRecordIterator());
  }

  /// \brief Get the list of function instantiations in the file.
  ///
  /// Functions that are instantiated more than once, such as C++ template
  /// specializations, have distinct coverage records for each instantiation.
  std::vector<const FunctionRecord *> getInstantiations(StringRef Filename);

  /// \brief Get the coverage for a particular function.
  CoverageData getCoverageForFunction(const FunctionRecord &Function);

  /// \brief Get the coverage for an expansion within a coverage set.
  CoverageData getCoverageForExpansion(const ExpansionRecord &Expansion);
};

const std::error_category &coveragemap_category();

inline std::error_code make_error_code(coveragemap_error E) {
  return std::error_code(static_cast<int>(E), coveragemap_category());
}

// Profile coverage map has the following layout:
// [CoverageMapFileHeader]
// [ArrayStart]
//  [CovMapFunctionRecord]
//  [CovMapFunctionRecord]
//  ...
// [ArrayEnd]
// [Encoded Region Mapping Data]
LLVM_PACKED_START
template <class IntPtrT> struct CovMapFunctionRecordV1 {
#define COVMAP_V1
#define COVMAP_FUNC_RECORD(Type, LLVMType, Name, Init) Type Name;
#include "llvm/ProfileData/InstrProfData.inc"
#undef COVMAP_V1

  // Return the structural hash associated with the function.
  template <support::endianness Endian> uint64_t getFuncHash() const {
    return support::endian::byte_swap<uint64_t, Endian>(FuncHash);
  }
  // Return the coverage map data size for the funciton.
  template <support::endianness Endian> uint32_t getDataSize() const {
    return support::endian::byte_swap<uint32_t, Endian>(DataSize);
  }
  // Return function lookup key. The value is consider opaque.
  template <support::endianness Endian> IntPtrT getFuncNameRef() const {
    return support::endian::byte_swap<IntPtrT, Endian>(NamePtr);
  }
  // Return the PGO name of the function */
  template <support::endianness Endian>
  std::error_code getFuncName(InstrProfSymtab &ProfileNames,
                              StringRef &FuncName) const {
    IntPtrT NameRef = getFuncNameRef<Endian>();
    uint32_t NameS = support::endian::byte_swap<uint32_t, Endian>(NameSize);
    FuncName = ProfileNames.getFuncName(NameRef, NameS);
    if (NameS && FuncName.empty())
      return coveragemap_error::malformed;
    return std::error_code();
  }
};

struct CovMapFunctionRecord {
#define COVMAP_FUNC_RECORD(Type, LLVMType, Name, Init) Type Name;
#include "llvm/ProfileData/InstrProfData.inc"

  // Return the structural hash associated with the function.
  template <support::endianness Endian> uint64_t getFuncHash() const {
    return support::endian::byte_swap<uint64_t, Endian>(FuncHash);
  }
  // Return the coverage map data size for the funciton.
  template <support::endianness Endian> uint32_t getDataSize() const {
    return support::endian::byte_swap<uint32_t, Endian>(DataSize);
  }
  // Return function lookup key. The value is consider opaque.
  template <support::endianness Endian> uint64_t getFuncNameRef() const {
    return support::endian::byte_swap<uint64_t, Endian>(NameRef);
  }
  // Return the PGO name of the function */
  template <support::endianness Endian>
  std::error_code getFuncName(InstrProfSymtab &ProfileNames,
                              StringRef &FuncName) const {
    uint64_t NameRef = getFuncNameRef<Endian>();
    FuncName = ProfileNames.getFuncName(NameRef);
    return std::error_code();
  }
};

// Per module coverage mapping data header, i.e. CoverageMapFileHeader
// documented above.
struct CovMapHeader {
#define COVMAP_HEADER(Type, LLVMType, Name, Init) Type Name;
#include "llvm/ProfileData/InstrProfData.inc"
  template <support::endianness Endian> uint32_t getNRecords() const {
    return support::endian::byte_swap<uint32_t, Endian>(NRecords);
  }
  template <support::endianness Endian> uint32_t getFilenamesSize() const {
    return support::endian::byte_swap<uint32_t, Endian>(FilenamesSize);
  }
  template <support::endianness Endian> uint32_t getCoverageSize() const {
    return support::endian::byte_swap<uint32_t, Endian>(CoverageSize);
  }
  template <support::endianness Endian> uint32_t getVersion() const {
    return support::endian::byte_swap<uint32_t, Endian>(Version);
  }
};

LLVM_PACKED_END

enum CovMapVersion {
  Version1 = 0,
  // Function's name reference from CovMapFuncRecord is changed from raw
  // name string pointer to MD5 to support name section compression. Name
  // section is also compressed.
  Version2 = 1,
  // The current version is Version2
  CurrentVersion = INSTR_PROF_COVMAP_VERSION
};

template <int CovMapVersion, class IntPtrT> struct CovMapTraits {
  typedef CovMapFunctionRecord CovMapFuncRecordType;
  typedef uint64_t NameRefType;
};

template <class IntPtrT> struct CovMapTraits<CovMapVersion::Version1, IntPtrT> {
  typedef CovMapFunctionRecordV1<IntPtrT> CovMapFuncRecordType;
  typedef IntPtrT NameRefType;
};

} // end namespace coverage

/// \brief Provide DenseMapInfo for CounterExpression
template<> struct DenseMapInfo<coverage::CounterExpression> {
  static inline coverage::CounterExpression getEmptyKey() {
    using namespace coverage;
    return CounterExpression(CounterExpression::ExprKind::Subtract,
                             Counter::getCounter(~0U),
                             Counter::getCounter(~0U));
  }

  static inline coverage::CounterExpression getTombstoneKey() {
    using namespace coverage;
    return CounterExpression(CounterExpression::ExprKind::Add,
                             Counter::getCounter(~0U),
                             Counter::getCounter(~0U));
  }

  static unsigned getHashValue(const coverage::CounterExpression &V) {
    return static_cast<unsigned>(
        hash_combine(V.Kind, V.LHS.getKind(), V.LHS.getCounterID(),
                     V.RHS.getKind(), V.RHS.getCounterID()));
  }

  static bool isEqual(const coverage::CounterExpression &LHS,
                      const coverage::CounterExpression &RHS) {
    return LHS.Kind == RHS.Kind && LHS.LHS == RHS.LHS && LHS.RHS == RHS.RHS;
  }
};

} // end namespace llvm

#endif // LLVM_PROFILEDATA_COVERAGEMAPPING_H_
