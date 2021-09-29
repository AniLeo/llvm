//===-- PerfReader.h - perfscript reader -----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_PROFGEN_PERFREADER_H
#define LLVM_TOOLS_LLVM_PROFGEN_PERFREADER_H
#include "ErrorHandling.h"
#include "ProfiledBinary.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Regex.h"
#include <cstdint>
#include <fstream>
#include <list>
#include <map>
#include <vector>

using namespace llvm;
using namespace sampleprof;

namespace llvm {
namespace sampleprof {

// Stream based trace line iterator
class TraceStream {
  std::string CurrentLine;
  std::ifstream Fin;
  bool IsAtEoF = false;
  uint64_t LineNumber = 0;

public:
  TraceStream(StringRef Filename) : Fin(Filename.str()) {
    if (!Fin.good())
      exitWithError("Error read input perf script file", Filename);
    advance();
  }

  StringRef getCurrentLine() {
    assert(!IsAtEoF && "Line iterator reaches the End-of-File!");
    return CurrentLine;
  }

  uint64_t getLineNumber() { return LineNumber; }

  bool isAtEoF() { return IsAtEoF; }

  // Read the next line
  void advance() {
    if (!std::getline(Fin, CurrentLine)) {
      IsAtEoF = true;
      return;
    }
    LineNumber++;
  }
};

// The type of perfscript
enum PerfScriptType {
  PERF_UNKNOWN = 0,
  PERF_INVALID = 1,
  PERF_LBR = 2,       // Only LBR sample
  PERF_LBR_STACK = 3, // Hybrid sample including call stack and LBR stack.
};

// The parsed LBR sample entry.
struct LBREntry {
  uint64_t Source = 0;
  uint64_t Target = 0;
  // An artificial branch stands for a series of consecutive branches starting
  // from the current binary with a transition through external code and
  // eventually landing back in the current binary.
  bool IsArtificial = false;
  LBREntry(uint64_t S, uint64_t T, bool I)
      : Source(S), Target(T), IsArtificial(I) {}

#ifndef NDEBUG
  void print() const {
    dbgs() << "from " << format("%#010x", Source) << " to "
           << format("%#010x", Target);
    if (IsArtificial)
      dbgs() << " Artificial";
  }
#endif
};

#ifndef NDEBUG
static inline void printLBRStack(const SmallVectorImpl<LBREntry> &LBRStack) {
  for (size_t I = 0; I < LBRStack.size(); I++) {
    dbgs() << "[" << I << "] ";
    LBRStack[I].print();
    dbgs() << "\n";
  }
}

static inline void printCallStack(const SmallVectorImpl<uint64_t> &CallStack) {
  for (size_t I = 0; I < CallStack.size(); I++) {
    dbgs() << "[" << I << "] " << format("%#010x", CallStack[I]) << "\n";
  }
}
#endif

// Hash interface for generic data of type T
// Data should implement a \fn getHashCode and a \fn isEqual
// Currently getHashCode is non-virtual to avoid the overhead of calling vtable,
// i.e we explicitly calculate hash of derived class, assign to base class's
// HashCode. This also provides the flexibility for calculating the hash code
// incrementally(like rolling hash) during frame stack unwinding since unwinding
// only changes the leaf of frame stack. \fn isEqual is a virtual function,
// which will have perf overhead. In the future, if we redesign a better hash
// function, then we can just skip this or switch to non-virtual function(like
// just ignore comparision if hash conflicts probabilities is low)
template <class T> class Hashable {
public:
  std::shared_ptr<T> Data;
  Hashable(const std::shared_ptr<T> &D) : Data(D) {}

  // Hash code generation
  struct Hash {
    uint64_t operator()(const Hashable<T> &Key) const {
      // Don't make it virtual for getHashCode
      uint64_t Hash = Key.Data->getHashCode();
      assert(Hash && "Should generate HashCode for it!");
      return Hash;
    }
  };

  // Hash equal
  struct Equal {
    bool operator()(const Hashable<T> &LHS, const Hashable<T> &RHS) const {
      // Precisely compare the data, vtable will have overhead.
      return LHS.Data->isEqual(RHS.Data.get());
    }
  };

  T *getPtr() const { return Data.get(); }
};

struct PerfSample {
  // LBR stack recorded in FIFO order.
  SmallVector<LBREntry, 16> LBRStack;
  // Call stack recorded in FILO(leaf to root) order, it's used for CS-profile
  // generation
  SmallVector<uint64_t, 16> CallStack;

  virtual ~PerfSample() = default;
  uint64_t getHashCode() const {
    // Use simple DJB2 hash
    auto HashCombine = [](uint64_t H, uint64_t V) {
      return ((H << 5) + H) + V;
    };
    uint64_t Hash = 5381;
    for (const auto &Value : CallStack) {
      Hash = HashCombine(Hash, Value);
    }
    for (const auto &Entry : LBRStack) {
      Hash = HashCombine(Hash, Entry.Source);
      Hash = HashCombine(Hash, Entry.Target);
    }
    return Hash;
  }

  bool isEqual(const PerfSample *Other) const {
    const SmallVector<uint64_t, 16> &OtherCallStack = Other->CallStack;
    const SmallVector<LBREntry, 16> &OtherLBRStack = Other->LBRStack;

    if (CallStack.size() != OtherCallStack.size() ||
        LBRStack.size() != OtherLBRStack.size())
      return false;

    if (!std::equal(CallStack.begin(), CallStack.end(), OtherCallStack.begin()))
      return false;

    for (size_t I = 0; I < OtherLBRStack.size(); I++) {
      if (LBRStack[I].Source != OtherLBRStack[I].Source ||
          LBRStack[I].Target != OtherLBRStack[I].Target)
        return false;
    }
    return true;
  }

#ifndef NDEBUG
  void print() const {
    dbgs() << "LBR stack\n";
    printLBRStack(LBRStack);
    dbgs() << "Call stack\n";
    printCallStack(CallStack);
  }
#endif
};
// After parsing the sample, we record the samples by aggregating them
// into this counter. The key stores the sample data and the value is
// the sample repeat times.
using AggregatedCounter =
    std::unordered_map<Hashable<PerfSample>, uint64_t,
                       Hashable<PerfSample>::Hash, Hashable<PerfSample>::Equal>;

using SampleVector = SmallVector<std::tuple<uint64_t, uint64_t, uint64_t>, 16>;
// The state for the unwinder, it doesn't hold the data but only keep the
// pointer/index of the data, While unwinding, the CallStack is changed
// dynamicially and will be recorded as the context of the sample
struct UnwindState {
  // Profiled binary that current frame address belongs to
  const ProfiledBinary *Binary;
  // Call stack trie node
  struct ProfiledFrame {
    const uint64_t Address = 0;
    ProfiledFrame *Parent;
    SampleVector RangeSamples;
    SampleVector BranchSamples;
    std::unordered_map<uint64_t, std::unique_ptr<ProfiledFrame>> Children;

    ProfiledFrame(uint64_t Addr = 0, ProfiledFrame *P = nullptr)
        : Address(Addr), Parent(P) {}
    ProfiledFrame *getOrCreateChildFrame(uint64_t Address) {
      assert(Address && "Address can't be zero!");
      auto Ret = Children.emplace(
          Address, std::make_unique<ProfiledFrame>(Address, this));
      return Ret.first->second.get();
    }
    void recordRangeCount(uint64_t Start, uint64_t End, uint64_t Count) {
      RangeSamples.emplace_back(std::make_tuple(Start, End, Count));
    }
    void recordBranchCount(uint64_t Source, uint64_t Target, uint64_t Count) {
      BranchSamples.emplace_back(std::make_tuple(Source, Target, Count));
    }
    bool isDummyRoot() { return Address == 0; }
    bool isLeafFrame() { return Children.empty(); }
  };

  ProfiledFrame DummyTrieRoot;
  ProfiledFrame *CurrentLeafFrame;
  // Used to fall through the LBR stack
  uint32_t LBRIndex = 0;
  // Reference to PerfSample.LBRStack
  const SmallVector<LBREntry, 16> &LBRStack;
  // Used to iterate the address range
  InstructionPointer InstPtr;
  UnwindState(const PerfSample *Sample, const ProfiledBinary *Binary)
      : Binary(Binary), LBRStack(Sample->LBRStack),
        InstPtr(Binary, Sample->CallStack.front()) {
    initFrameTrie(Sample->CallStack);
  }

  bool validateInitialState() {
    uint64_t LBRLeaf = LBRStack[LBRIndex].Target;
    uint64_t LeafAddr = CurrentLeafFrame->Address;
    // When we take a stack sample, ideally the sampling distance between the
    // leaf IP of stack and the last LBR target shouldn't be very large.
    // Use a heuristic size (0x100) to filter out broken records.
    if (LeafAddr < LBRLeaf || LeafAddr >= LBRLeaf + 0x100) {
      WithColor::warning() << "Bogus trace: stack tip = "
                           << format("%#010x", LeafAddr)
                           << ", LBR tip = " << format("%#010x\n", LBRLeaf);
      return false;
    }
    return true;
  }

  void checkStateConsistency() {
    assert(InstPtr.Address == CurrentLeafFrame->Address &&
           "IP should align with context leaf");
  }

  bool hasNextLBR() const { return LBRIndex < LBRStack.size(); }
  uint64_t getCurrentLBRSource() const { return LBRStack[LBRIndex].Source; }
  uint64_t getCurrentLBRTarget() const { return LBRStack[LBRIndex].Target; }
  const LBREntry &getCurrentLBR() const { return LBRStack[LBRIndex]; }
  void advanceLBR() { LBRIndex++; }

  ProfiledFrame *getParentFrame() { return CurrentLeafFrame->Parent; }

  void pushFrame(uint64_t Address) {
    CurrentLeafFrame = CurrentLeafFrame->getOrCreateChildFrame(Address);
  }

  void switchToFrame(uint64_t Address) {
    if (CurrentLeafFrame->Address == Address)
      return;
    CurrentLeafFrame = CurrentLeafFrame->Parent->getOrCreateChildFrame(Address);
  }

  void popFrame() { CurrentLeafFrame = CurrentLeafFrame->Parent; }

  void initFrameTrie(const SmallVectorImpl<uint64_t> &CallStack) {
    ProfiledFrame *Cur = &DummyTrieRoot;
    for (auto Address : reverse(CallStack)) {
      Cur = Cur->getOrCreateChildFrame(Address);
    }
    CurrentLeafFrame = Cur;
  }

  ProfiledFrame *getDummyRootPtr() { return &DummyTrieRoot; }
};

// Base class for sample counter key with context
struct ContextKey {
  uint64_t HashCode = 0;
  virtual ~ContextKey() = default;
  uint64_t getHashCode() const { return HashCode; }
  virtual bool isEqual(const ContextKey *K) const {
    return HashCode == K->HashCode;
  };

  // Utilities for LLVM-style RTTI
  enum ContextKind { CK_StringBased, CK_ProbeBased };
  const ContextKind Kind;
  ContextKind getKind() const { return Kind; }
  ContextKey(ContextKind K) : Kind(K){};
};

// String based context id
struct StringBasedCtxKey : public ContextKey {
  SampleContextFrameVector Context;

  bool WasLeafInlined;
  StringBasedCtxKey() : ContextKey(CK_StringBased), WasLeafInlined(false){};
  static bool classof(const ContextKey *K) {
    return K->getKind() == CK_StringBased;
  }

  bool isEqual(const ContextKey *K) const override {
    const StringBasedCtxKey *Other = dyn_cast<StringBasedCtxKey>(K);
    return Context == Other->Context;
  }

  void genHashCode() { HashCode = hash_value(SampleContextFrames(Context)); }
};

// Probe based context key as the intermediate key of context
// String based context key will introduce redundant string handling
// since the callee context is inferred from the context string which
// need to be splitted by '@' to get the last location frame, so we
// can just use probe instead and generate the string in the end.
struct ProbeBasedCtxKey : public ContextKey {
  SmallVector<const MCDecodedPseudoProbe *, 16> Probes;

  ProbeBasedCtxKey() : ContextKey(CK_ProbeBased) {}
  static bool classof(const ContextKey *K) {
    return K->getKind() == CK_ProbeBased;
  }

  bool isEqual(const ContextKey *K) const override {
    const ProbeBasedCtxKey *O = dyn_cast<ProbeBasedCtxKey>(K);
    assert(O != nullptr && "Probe based key shouldn't be null in isEqual");
    return std::equal(Probes.begin(), Probes.end(), O->Probes.begin(),
                      O->Probes.end());
  }

  void genHashCode() {
    for (const auto *P : Probes) {
      HashCode = hash_combine(HashCode, P);
    }
    if (HashCode == 0) {
      // Avoid zero value of HashCode when it's an empty list
      HashCode = 1;
    }
  }
};

// The counter of branch samples for one function indexed by the branch,
// which is represented as the source and target offset pair.
using BranchSample = std::map<std::pair<uint64_t, uint64_t>, uint64_t>;
// The counter of range samples for one function indexed by the range,
// which is represented as the start and end offset pair.
using RangeSample = std::map<std::pair<uint64_t, uint64_t>, uint64_t>;
// Wrapper for sample counters including range counter and branch counter
struct SampleCounter {
  RangeSample RangeCounter;
  BranchSample BranchCounter;

  void recordRangeCount(uint64_t Start, uint64_t End, uint64_t Repeat) {
    assert(Start <= End && "Invalid instruction range");
    RangeCounter[{Start, End}] += Repeat;
  }
  void recordBranchCount(uint64_t Source, uint64_t Target, uint64_t Repeat) {
    BranchCounter[{Source, Target}] += Repeat;
  }
};

// Sample counter with context to support context-sensitive profile
using ContextSampleCounterMap =
    std::unordered_map<Hashable<ContextKey>, SampleCounter,
                       Hashable<ContextKey>::Hash, Hashable<ContextKey>::Equal>;

struct FrameStack {
  SmallVector<uint64_t, 16> Stack;
  ProfiledBinary *Binary;
  FrameStack(ProfiledBinary *B) : Binary(B) {}
  bool pushFrame(UnwindState::ProfiledFrame *Cur) {
    Stack.push_back(Cur->Address);
    return true;
  }

  void popFrame() {
    if (!Stack.empty())
      Stack.pop_back();
  }
  std::shared_ptr<StringBasedCtxKey> getContextKey();
};

struct ProbeStack {
  SmallVector<const MCDecodedPseudoProbe *, 16> Stack;
  ProfiledBinary *Binary;
  ProbeStack(ProfiledBinary *B) : Binary(B) {}
  bool pushFrame(UnwindState::ProfiledFrame *Cur) {
    const MCDecodedPseudoProbe *CallProbe =
        Binary->getCallProbeForAddr(Cur->Address);
    // We may not find a probe for a merged or external callsite.
    // Callsite merging may cause the loss of original probe IDs.
    // Cutting off the context from here since the inliner will
    // not know how to consume a context with unknown callsites.
    if (!CallProbe)
      return false;
    Stack.push_back(CallProbe);
    return true;
  }

  void popFrame() {
    if (!Stack.empty())
      Stack.pop_back();
  }
  // Use pseudo probe based context key to get the sample counter
  // A context stands for a call path from 'main' to an uninlined
  // callee with all inline frames recovered on that path. The probes
  // belonging to that call path is the probes either originated from
  // the callee or from any functions inlined into the callee. Since
  // pseudo probes are organized in a tri-tree style after decoded,
  // the tree path from the tri-tree root (which is the uninlined
  // callee) to the probe node forms an inline context.
  // Here we use a list of probe(pointer) as the context key to speed up
  // aggregation and the final context string will be generate in
  // ProfileGenerator
  std::shared_ptr<ProbeBasedCtxKey> getContextKey();
};

/*
As in hybrid sample we have a group of LBRs and the most recent sampling call
stack, we can walk through those LBRs to infer more call stacks which would be
used as context for profile. VirtualUnwinder is the class to do the call stack
unwinding based on LBR state. Two types of unwinding are processd here:
1) LBR unwinding and 2) linear range unwinding.
Specifically, for each LBR entry(can be classified into call, return, regular
branch), LBR unwinding will replay the operation by pushing, popping or
switching leaf frame towards the call stack and since the initial call stack
is most recently sampled, the replay should be in anti-execution order, i.e. for
the regular case, pop the call stack when LBR is call, push frame on call stack
when LBR is return. After each LBR processed, it also needs to align with the
next LBR by going through instructions from previous LBR's target to current
LBR's source, which is the linear unwinding. As instruction from linear range
can come from different function by inlining, linear unwinding will do the range
splitting and record counters by the range with same inline context. Over those
unwinding process we will record each call stack as context id and LBR/linear
range as sample counter for further CS profile generation.
*/
class VirtualUnwinder {
public:
  VirtualUnwinder(ContextSampleCounterMap *Counter, ProfiledBinary *B)
      : CtxCounterMap(Counter), Binary(B) {}
  bool unwind(const PerfSample *Sample, uint64_t Repeat);
  std::set<uint64_t> &getUntrackedCallsites() { return UntrackedCallsites; }

private:
  bool isCallState(UnwindState &State) const {
    // The tail call frame is always missing here in stack sample, we will
    // use a specific tail call tracker to infer it.
    return Binary->addressIsCall(State.getCurrentLBRSource());
  }

  bool isReturnState(UnwindState &State) const {
    // Simply check addressIsReturn, as ret is always reliable, both for
    // regular call and tail call.
    return Binary->addressIsReturn(State.getCurrentLBRSource());
  }

  void unwindCall(UnwindState &State);
  void unwindLinear(UnwindState &State, uint64_t Repeat);
  void unwindReturn(UnwindState &State);
  void unwindBranchWithinFrame(UnwindState &State);

  template <typename T>
  void collectSamplesFromFrame(UnwindState::ProfiledFrame *Cur, T &Stack);
  // Collect each samples on trie node by DFS traversal
  template <typename T>
  void collectSamplesFromFrameTrie(UnwindState::ProfiledFrame *Cur, T &Stack);
  void collectSamplesFromFrameTrie(UnwindState::ProfiledFrame *Cur);

  void recordRangeCount(uint64_t Start, uint64_t End, UnwindState &State,
                        uint64_t Repeat);
  void recordBranchCount(const LBREntry &Branch, UnwindState &State,
                         uint64_t Repeat);

  ContextSampleCounterMap *CtxCounterMap;
  // Profiled binary that current frame address belongs to
  ProfiledBinary *Binary;
  // Keep track of all untracked callsites
  std::set<uint64_t> UntrackedCallsites;
};

// Read perf trace to parse the events and samples.
class PerfReaderBase {
public:
  PerfReaderBase(ProfiledBinary *B, StringRef PerfTrace,
                 PerfScriptType Type = PERF_UNKNOWN)
      : Binary(B), PerfTraceFile(PerfTrace), PerfType(Type) {
    // Initialize the base address to preferred address.
    Binary->setBaseAddress(Binary->getPreferredBaseAddress());
  };
  virtual ~PerfReaderBase() = default;
  static std::unique_ptr<PerfReaderBase>
  create(ProfiledBinary *Binary, StringRef PerfInputFile, bool IsPerfData);

  PerfScriptType getPerfScriptType() const { return PerfType; }
  // Entry of the reader to parse multiple perf traces
  void parsePerfTraces();
  const ContextSampleCounterMap &getSampleCounters() const {
    return SampleCounters;
  }
  bool profileIsCS() { return ProfileIsCS; }

protected:
  // The parsed MMap event
  struct MMapEvent {
    uint64_t PID = 0;
    uint64_t Address = 0;
    uint64_t Size = 0;
    uint64_t Offset = 0;
    StringRef BinaryPath;
  };

  // Check whther a given line is LBR sample
  static bool isLBRSample(StringRef Line);
  // Extract perf script type by peaking at the input
  static PerfScriptType checkPerfScriptType(StringRef FileName);
  // Update base address based on mmap events
  void updateBinaryAddress(const MMapEvent &Event);
  // Parse a single line of a PERF_RECORD_MMAP2 event looking for a
  // mapping between the binary name and its memory layout.
  void parseMMap2Event(TraceStream &TraceIt);
  // Parse perf events/samples and do aggregation
  void parseAndAggregateTrace();
  // Parse either an MMAP event or a perf sample
  void parseEventOrSample(TraceStream &TraceIt);
  // Warn if the relevant mmap event is missing.
  void warnIfMissingMMap();
  // Emit accumulate warnings.
  void warnTruncatedStack();
  // Extract call stack from the perf trace lines
  bool extractCallstack(TraceStream &TraceIt,
                        SmallVectorImpl<uint64_t> &CallStack);
  // Extract LBR stack from one perf trace line
  bool extractLBRStack(TraceStream &TraceIt,
                       SmallVectorImpl<LBREntry> &LBRStack);
  uint64_t parseAggregatedCount(TraceStream &TraceIt);
  // Parse one sample from multiple perf lines, override this for different
  // sample type
  void parseSample(TraceStream &TraceIt);
  // An aggregated count is given to indicate how many times the sample is
  // repeated.
  virtual void parseSample(TraceStream &TraceIt, uint64_t Count) = 0;
  // Post process the profile after trace aggregation, we will do simple range
  // overlap computation for AutoFDO, or unwind for CSSPGO(hybrid sample).
  virtual void generateRawProfile() = 0;
  void writeRawProfile(StringRef Filename);
  void writeRawProfile(raw_fd_ostream &OS);

  ProfiledBinary *Binary = nullptr;
  StringRef PerfTraceFile;
  ContextSampleCounterMap SampleCounters;
  // Samples with the repeating time generated by the perf reader
  AggregatedCounter AggregatedSamples;
  PerfScriptType PerfType = PERF_UNKNOWN;
  // Keep track of all invalid return addresses
  std::set<uint64_t> InvalidReturnAddresses;

  bool ProfileIsCS = false;
};

/*
  The reader of LBR only perf script.
  A typical LBR sample is like:
    40062f 0x4005c8/0x4005dc/P/-/-/0   0x40062f/0x4005b0/P/-/-/0 ...
          ... 0x4005c8/0x4005dc/P/-/-/0
*/
class LBRPerfReader : public PerfReaderBase {
public:
  LBRPerfReader(ProfiledBinary *Binary, StringRef PerfTrace,
                PerfScriptType Type = PERF_LBR)
      : PerfReaderBase(Binary, PerfTrace, Type){};
  // Parse the LBR only sample.
  virtual void parseSample(TraceStream &TraceIt, uint64_t Count) override;
  virtual void generateRawProfile() override;

private:
  void computeCounterFromLBR(const PerfSample *Sample, uint64_t Repeat);
};

/*
  Hybrid perf script includes a group of hybrid samples(LBRs + call stack),
  which is used to generate CS profile. An example of hybrid sample:
    4005dc    # call stack leaf
    400634
    400684    # call stack root
    0x4005c8/0x4005dc/P/-/-/0   0x40062f/0x4005b0/P/-/-/0 ...
          ... 0x4005c8/0x4005dc/P/-/-/0    # LBR Entries
*/
class HybridPerfReader : public LBRPerfReader {
public:
  HybridPerfReader(ProfiledBinary *Binary, StringRef PerfTrace)
      : LBRPerfReader(Binary, PerfTrace, PERF_LBR_STACK){};
  // Parse the hybrid sample including the call and LBR line
  void parseSample(TraceStream &TraceIt, uint64_t Count) override;
  void generateRawProfile() override;

private:
  // Unwind the hybrid samples after aggregration
  void unwindSamples();
};

} // end namespace sampleprof
} // end namespace llvm

#endif
