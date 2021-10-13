//===-- PerfReader.cpp - perfscript reader  ---------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "PerfReader.h"
#include "ProfileGenerator.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Process.h"

#define DEBUG_TYPE "perf-reader"

static cl::opt<bool> ShowMmapEvents("show-mmap-events", cl::ReallyHidden,
                                    cl::init(false), cl::ZeroOrMore,
                                    cl::desc("Print binary load events."));

cl::opt<bool> SkipSymbolization("skip-symbolization", cl::ReallyHidden,
                                cl::init(false), cl::ZeroOrMore,
                                cl::desc("Dump the unsymbolized profile to the "
                                         "output file. It will show unwinder "
                                         "output for CS profile generation."));
cl::opt<bool> UseOffset("use-offset", cl::ReallyHidden, cl::init(true),
                        cl::ZeroOrMore,
                        cl::desc("Work with `--skip-symbolization` to dump the "
                                 "offset instead of virtual address."));
cl::opt<bool>
    IgnoreStackSamples("ignore-stack-samples", cl::ReallyHidden,
                       cl::init(false), cl::ZeroOrMore,
                       cl::desc("Ignore call stack samples for hybrid samples "
                                "and produce context-insensitive profile."));

extern cl::opt<std::string> PerfTraceFilename;
extern cl::opt<bool> ShowDisassemblyOnly;
extern cl::opt<bool> ShowSourceLocations;
extern cl::opt<std::string> OutputFilename;

namespace llvm {
namespace sampleprof {

void VirtualUnwinder::unwindCall(UnwindState &State) {
  // The 2nd frame after leaf could be missing if stack sample is
  // taken when IP is within prolog/epilog, as frame chain isn't
  // setup yet. Fill in the missing frame in that case.
  // TODO: Currently we just assume all the addr that can't match the
  // 2nd frame is in prolog/epilog. In the future, we will switch to
  // pro/epi tracker(Dwarf CFI) for the precise check.
  uint64_t Source = State.getCurrentLBRSource();
  auto *ParentFrame = State.getParentFrame();
  if (ParentFrame == State.getDummyRootPtr() ||
      ParentFrame->Address != Source) {
    State.switchToFrame(Source);
  } else {
    State.popFrame();
  }
  State.InstPtr.update(Source);
}

void VirtualUnwinder::unwindLinear(UnwindState &State, uint64_t Repeat) {
  InstructionPointer &IP = State.InstPtr;
  uint64_t Target = State.getCurrentLBRTarget();
  uint64_t End = IP.Address;
  if (Binary->usePseudoProbes()) {
    // We don't need to top frame probe since it should be extracted
    // from the range.
    // The outcome of the virtual unwinding with pseudo probes is a
    // map from a context key to the address range being unwound.
    // This means basically linear unwinding is not needed for pseudo
    // probes. The range will be simply recorded here and will be
    // converted to a list of pseudo probes to report in ProfileGenerator.
    State.getParentFrame()->recordRangeCount(Target, End, Repeat);
  } else {
    // Unwind linear execution part.
    // Split and record the range by different inline context. For example:
    // [0x01] ... main:1          # Target
    // [0x02] ... main:2
    // [0x03] ... main:3 @ foo:1
    // [0x04] ... main:3 @ foo:2
    // [0x05] ... main:3 @ foo:3
    // [0x06] ... main:4
    // [0x07] ... main:5          # End
    // It will be recorded:
    // [main:*]         : [0x06, 0x07], [0x01, 0x02]
    // [main:3 @ foo:*] : [0x03, 0x05]
    while (IP.Address > Target) {
      uint64_t PrevIP = IP.Address;
      IP.backward();
      // Break into segments for implicit call/return due to inlining
      bool SameInlinee = Binary->inlineContextEqual(PrevIP, IP.Address);
      if (!SameInlinee) {
        State.switchToFrame(PrevIP);
        State.CurrentLeafFrame->recordRangeCount(PrevIP, End, Repeat);
        End = IP.Address;
      }
    }
    assert(IP.Address == Target && "The last one must be the target address.");
    // Record the remaining range, [0x01, 0x02] in the example
    State.switchToFrame(IP.Address);
    State.CurrentLeafFrame->recordRangeCount(IP.Address, End, Repeat);
  }
}

void VirtualUnwinder::unwindReturn(UnwindState &State) {
  // Add extra frame as we unwind through the return
  const LBREntry &LBR = State.getCurrentLBR();
  uint64_t CallAddr = Binary->getCallAddrFromFrameAddr(LBR.Target);
  State.switchToFrame(CallAddr);
  State.pushFrame(LBR.Source);
  State.InstPtr.update(LBR.Source);
}

void VirtualUnwinder::unwindBranchWithinFrame(UnwindState &State) {
  // TODO: Tolerate tail call for now, as we may see tail call from libraries.
  // This is only for intra function branches, excluding tail calls.
  uint64_t Source = State.getCurrentLBRSource();
  State.switchToFrame(Source);
  State.InstPtr.update(Source);
}

std::shared_ptr<StringBasedCtxKey> FrameStack::getContextKey() {
  std::shared_ptr<StringBasedCtxKey> KeyStr =
      std::make_shared<StringBasedCtxKey>();
  KeyStr->Context = Binary->getExpandedContext(Stack, KeyStr->WasLeafInlined);
  if (KeyStr->Context.empty())
    return nullptr;
  KeyStr->genHashCode();
  return KeyStr;
}

std::shared_ptr<ProbeBasedCtxKey> ProbeStack::getContextKey() {
  std::shared_ptr<ProbeBasedCtxKey> ProbeBasedKey =
      std::make_shared<ProbeBasedCtxKey>();
  for (auto CallProbe : Stack) {
    ProbeBasedKey->Probes.emplace_back(CallProbe);
  }
  CSProfileGenerator::compressRecursionContext<const MCDecodedPseudoProbe *>(
      ProbeBasedKey->Probes);
  CSProfileGenerator::trimContext<const MCDecodedPseudoProbe *>(
      ProbeBasedKey->Probes);

  ProbeBasedKey->genHashCode();
  return ProbeBasedKey;
}

template <typename T>
void VirtualUnwinder::collectSamplesFromFrame(UnwindState::ProfiledFrame *Cur,
                                              T &Stack) {
  if (Cur->RangeSamples.empty() && Cur->BranchSamples.empty())
    return;

  std::shared_ptr<ContextKey> Key = Stack.getContextKey();
  if (Key == nullptr)
    return;
  auto Ret = CtxCounterMap->emplace(Hashable<ContextKey>(Key), SampleCounter());
  SampleCounter &SCounter = Ret.first->second;
  for (auto &Item : Cur->RangeSamples) {
    uint64_t StartOffset = Binary->virtualAddrToOffset(std::get<0>(Item));
    uint64_t EndOffset = Binary->virtualAddrToOffset(std::get<1>(Item));
    SCounter.recordRangeCount(StartOffset, EndOffset, std::get<2>(Item));
  }

  for (auto &Item : Cur->BranchSamples) {
    uint64_t SourceOffset = Binary->virtualAddrToOffset(std::get<0>(Item));
    uint64_t TargetOffset = Binary->virtualAddrToOffset(std::get<1>(Item));
    SCounter.recordBranchCount(SourceOffset, TargetOffset, std::get<2>(Item));
  }
}

template <typename T>
void VirtualUnwinder::collectSamplesFromFrameTrie(
    UnwindState::ProfiledFrame *Cur, T &Stack) {
  if (!Cur->isDummyRoot()) {
    if (!Stack.pushFrame(Cur)) {
      // Process truncated context
      // Start a new traversal ignoring its bottom context
      T EmptyStack(Binary);
      collectSamplesFromFrame(Cur, EmptyStack);
      for (const auto &Item : Cur->Children) {
        collectSamplesFromFrameTrie(Item.second.get(), EmptyStack);
      }

      // Keep note of untracked call site and deduplicate them
      // for warning later.
      if (!Cur->isLeafFrame())
        UntrackedCallsites.insert(Cur->Address);

      return;
    }
  }

  collectSamplesFromFrame(Cur, Stack);
  // Process children frame
  for (const auto &Item : Cur->Children) {
    collectSamplesFromFrameTrie(Item.second.get(), Stack);
  }
  // Recover the call stack
  Stack.popFrame();
}

void VirtualUnwinder::collectSamplesFromFrameTrie(
    UnwindState::ProfiledFrame *Cur) {
  if (Binary->usePseudoProbes()) {
    ProbeStack Stack(Binary);
    collectSamplesFromFrameTrie<ProbeStack>(Cur, Stack);
  } else {
    FrameStack Stack(Binary);
    collectSamplesFromFrameTrie<FrameStack>(Cur, Stack);
  }
}

void VirtualUnwinder::recordBranchCount(const LBREntry &Branch,
                                        UnwindState &State, uint64_t Repeat) {
  if (Branch.IsArtificial)
    return;

  if (Binary->usePseudoProbes()) {
    // Same as recordRangeCount, We don't need to top frame probe since we will
    // extract it from branch's source address
    State.getParentFrame()->recordBranchCount(Branch.Source, Branch.Target,
                                              Repeat);
  } else {
    State.CurrentLeafFrame->recordBranchCount(Branch.Source, Branch.Target,
                                              Repeat);
  }
}

bool VirtualUnwinder::unwind(const PerfSample *Sample, uint64_t Repeat) {
  // Capture initial state as starting point for unwinding.
  UnwindState State(Sample, Binary);

  // Sanity check - making sure leaf of LBR aligns with leaf of stack sample
  // Stack sample sometimes can be unreliable, so filter out bogus ones.
  if (!State.validateInitialState())
    return false;

  // Also do not attempt linear unwind for the leaf range as it's incomplete.
  bool IsLeaf = true;

  // Now process the LBR samples in parrallel with stack sample
  // Note that we do not reverse the LBR entry order so we can
  // unwind the sample stack as we walk through LBR entries.
  while (State.hasNextLBR()) {
    State.checkStateConsistency();

    // Unwind implicit calls/returns from inlining, along the linear path,
    // break into smaller sub section each with its own calling context.
    if (!IsLeaf) {
      unwindLinear(State, Repeat);
    }
    IsLeaf = false;

    // Save the LBR branch before it gets unwound.
    const LBREntry &Branch = State.getCurrentLBR();

    if (isCallState(State)) {
      // Unwind calls - we know we encountered call if LBR overlaps with
      // transition between leaf the 2nd frame. Note that for calls that
      // were not in the original stack sample, we should have added the
      // extra frame when processing the return paired with this call.
      unwindCall(State);
    } else if (isReturnState(State)) {
      // Unwind returns - check whether the IP is indeed at a return instruction
      unwindReturn(State);
    } else {
      // Unwind branches - for regular intra function branches, we only
      // need to record branch with context.
      unwindBranchWithinFrame(State);
    }
    State.advanceLBR();
    // Record `branch` with calling context after unwinding.
    recordBranchCount(Branch, State, Repeat);
  }
  // As samples are aggregated on trie, record them into counter map
  collectSamplesFromFrameTrie(State.getDummyRootPtr());

  return true;
}

std::unique_ptr<PerfReaderBase> PerfReaderBase::create(ProfiledBinary *Binary,
                                                       StringRef PerfInputFile,
                                                       bool IsPerfData) {
  // For perf data input, we need to convert them into perf script first.
  if (IsPerfData) {
    std::string ConvertedPerfScript =
        convertPerfDataToTrace(Binary, PerfInputFile);
    // Let commoand opt own the string for converted perf trace file name
    PerfTraceFilename = ConvertedPerfScript;
    PerfInputFile = PerfTraceFilename;
  }

  PerfScriptType PerfType = checkPerfScriptType(PerfInputFile);
  std::unique_ptr<PerfReaderBase> PerfReader;
  if (PerfType == PERF_LBR_STACK) {
    PerfReader.reset(new HybridPerfReader(Binary, PerfInputFile));
  } else if (PerfType == PERF_LBR) {
    PerfReader.reset(new LBRPerfReader(Binary, PerfInputFile));
  } else {
    exitWithError("Unsupported perfscript!");
  }

  return PerfReader;
}

std::string PerfReaderBase::convertPerfDataToTrace(ProfiledBinary *Binary,
                                                   StringRef PerfData) {
  // Run perf script to retrieve PIDs matching binary we're interested in.
  auto PerfExecutable = sys::Process::FindInEnvPath("PATH", "perf");
  if (!PerfExecutable) {
    exitWithError("Perf not found.");
  }
  std::string PerfPath = *PerfExecutable;
  std::string PerfTraceFile = PerfData.str() + ".script.tmp";
  StringRef ScriptMMapArgs[] = {PerfPath, "script",   "--show-mmap-events",
                                "-F",     "comm,pid", "-i",
                                PerfData};
  Optional<StringRef> Redirects[] = {llvm::None,                // Stdin
                                     StringRef(PerfTraceFile),  // Stdout
                                     StringRef(PerfTraceFile)}; // Stderr
  sys::ExecuteAndWait(PerfPath, ScriptMMapArgs, llvm::None, Redirects);

  // Collect the PIDs
  TraceStream TraceIt(PerfTraceFile);
  std::string PIDs;
  std::unordered_set<uint32_t> PIDSet;
  while (!TraceIt.isAtEoF()) {
    MMapEvent MMap;
    if (isMMap2Event(TraceIt.getCurrentLine()) &&
        extractMMap2EventForBinary(Binary, TraceIt.getCurrentLine(), MMap)) {
      auto It = PIDSet.emplace(MMap.PID);
      if (It.second) {
        if (!PIDs.empty()) {
          PIDs.append(",");
        }
        PIDs.append(utostr(MMap.PID));
      }
    }
    TraceIt.advance();
  }

  if (PIDs.empty()) {
    exitWithError("No relevant mmap event is found in perf data.");
  }

  // Run perf script again to retrieve events for PIDs collected above
  StringRef ScriptSampleArgs[] = {PerfPath, "script",     "--show-mmap-events",
                                  "-F",     "ip,brstack", "--pid",
                                  PIDs,     "-i",         PerfData};
  sys::ExecuteAndWait(PerfPath, ScriptSampleArgs, llvm::None, Redirects);

  return PerfTraceFile;
}

void PerfReaderBase::updateBinaryAddress(const MMapEvent &Event) {
  // Drop the event which doesn't belong to user-provided binary
  StringRef BinaryName = llvm::sys::path::filename(Event.BinaryPath);
  if (Binary->getName() != BinaryName)
    return;

  // Drop the event if its image is loaded at the same address
  if (Event.Address == Binary->getBaseAddress()) {
    Binary->setIsLoadedByMMap(true);
    return;
  }

  if (Event.Offset == Binary->getTextSegmentOffset()) {
    // A binary image could be unloaded and then reloaded at different
    // place, so update binary load address.
    // Only update for the first executable segment and assume all other
    // segments are loaded at consecutive memory addresses, which is the case on
    // X64.
    Binary->setBaseAddress(Event.Address);
    Binary->setIsLoadedByMMap(true);
  } else {
    // Verify segments are loaded consecutively.
    const auto &Offsets = Binary->getTextSegmentOffsets();
    auto It = std::lower_bound(Offsets.begin(), Offsets.end(), Event.Offset);
    if (It != Offsets.end() && *It == Event.Offset) {
      // The event is for loading a separate executable segment.
      auto I = std::distance(Offsets.begin(), It);
      const auto &PreferredAddrs = Binary->getPreferredTextSegmentAddresses();
      if (PreferredAddrs[I] - Binary->getPreferredBaseAddress() !=
          Event.Address - Binary->getBaseAddress())
        exitWithError("Executable segments not loaded consecutively");
    } else {
      if (It == Offsets.begin())
        exitWithError("File offset not found");
      else {
        // Find the segment the event falls in. A large segment could be loaded
        // via multiple mmap calls with consecutive memory addresses.
        --It;
        assert(*It < Event.Offset);
        if (Event.Offset - *It != Event.Address - Binary->getBaseAddress())
          exitWithError("Segment not loaded by consecutive mmaps");
      }
    }
  }
}

static std::string getContextKeyStr(ContextKey *K,
                                    const ProfiledBinary *Binary) {
  if (const auto *CtxKey = dyn_cast<StringBasedCtxKey>(K)) {
    return SampleContext::getContextString(CtxKey->Context);
  } else if (const auto *CtxKey = dyn_cast<ProbeBasedCtxKey>(K)) {
    SampleContextFrameVector ContextStack;
    for (const auto *Probe : CtxKey->Probes) {
      Binary->getInlineContextForProbe(Probe, ContextStack, true);
    }
    // Probe context key at this point does not have leaf probe, so do not
    // include the leaf inline location.
    return SampleContext::getContextString(ContextStack, true);
  } else {
    llvm_unreachable("unexpected key type");
  }
}

void HybridPerfReader::unwindSamples() {
  std::set<uint64_t> AllUntrackedCallsites;
  for (const auto &Item : AggregatedSamples) {
    const PerfSample *Sample = Item.first.getPtr();
    VirtualUnwinder Unwinder(&SampleCounters, Binary);
    Unwinder.unwind(Sample, Item.second);
    auto &CurrUntrackedCallsites = Unwinder.getUntrackedCallsites();
    AllUntrackedCallsites.insert(CurrUntrackedCallsites.begin(),
                                 CurrUntrackedCallsites.end());
  }

  // Warn about untracked frames due to missing probes.
  for (auto Address : AllUntrackedCallsites)
    WithColor::warning() << "Profile context truncated due to missing probe "
                         << "for call instruction at "
                         << format("0x%" PRIx64, Address) << "\n";
}

bool PerfReaderBase::extractLBRStack(TraceStream &TraceIt,
                                     SmallVectorImpl<LBREntry> &LBRStack) {
  // The raw format of LBR stack is like:
  // 0x4005c8/0x4005dc/P/-/-/0 0x40062f/0x4005b0/P/-/-/0 ...
  //                           ... 0x4005c8/0x4005dc/P/-/-/0
  // It's in FIFO order and seperated by whitespace.
  SmallVector<StringRef, 32> Records;
  TraceIt.getCurrentLine().split(Records, " ", -1, false);
  auto WarnInvalidLBR = [](TraceStream &TraceIt) {
    WithColor::warning() << "Invalid address in LBR record at line "
                         << TraceIt.getLineNumber() << ": "
                         << TraceIt.getCurrentLine() << "\n";
  };

  // Skip the leading instruction pointer.
  size_t Index = 0;
  uint64_t LeadingAddr;
  if (!Records.empty() && Records[0].find('/') == StringRef::npos) {
    if (Records[0].getAsInteger(16, LeadingAddr)) {
      WarnInvalidLBR(TraceIt);
      TraceIt.advance();
      return false;
    }
    Index = 1;
  }
  // Now extract LBR samples - note that we do not reverse the
  // LBR entry order so we can unwind the sample stack as we walk
  // through LBR entries.
  uint64_t PrevTrDst = 0;

  while (Index < Records.size()) {
    auto &Token = Records[Index++];
    if (Token.size() == 0)
      continue;

    SmallVector<StringRef, 8> Addresses;
    Token.split(Addresses, "/");
    uint64_t Src;
    uint64_t Dst;

    // Stop at broken LBR records.
    if (Addresses.size() < 2 || Addresses[0].substr(2).getAsInteger(16, Src) ||
        Addresses[1].substr(2).getAsInteger(16, Dst)) {
      WarnInvalidLBR(TraceIt);
      break;
    }

    bool SrcIsInternal = Binary->addressIsCode(Src);
    bool DstIsInternal = Binary->addressIsCode(Dst);
    bool IsExternal = !SrcIsInternal && !DstIsInternal;
    bool IsIncoming = !SrcIsInternal && DstIsInternal;
    bool IsOutgoing = SrcIsInternal && !DstIsInternal;
    bool IsArtificial = false;

    // Ignore branches outside the current binary. Ignore all remaining branches
    // if there's no incoming branch before the external branch in reverse
    // order.
    if (IsExternal) {
      if (PrevTrDst)
        continue;
      if (!LBRStack.empty()) {
        WithColor::warning()
            << "Invalid transfer to external code in LBR record at line "
            << TraceIt.getLineNumber() << ": " << TraceIt.getCurrentLine()
            << "\n";
      }
      break;
    }

    if (IsOutgoing) {
      if (!PrevTrDst) {
        // This is unpaired outgoing jump which is likely due to interrupt or
        // incomplete LBR trace. Ignore current and subsequent entries since
        // they are likely in different contexts.
        break;
      }

      if (Binary->addressIsReturn(Src)) {
        // In a callback case, a return from internal code, say A, to external
        // runtime can happen. The external runtime can then call back to
        // another internal routine, say B. Making an artificial branch that
        // looks like a return from A to B can confuse the unwinder to treat
        // the instruction before B as the call instruction.
        break;
      }

      // For transition to external code, group the Source with the next
      // availabe transition target.
      Dst = PrevTrDst;
      PrevTrDst = 0;
      IsArtificial = true;
    } else {
      if (PrevTrDst) {
        // If we have seen an incoming transition from external code to internal
        // code, but not a following outgoing transition, the incoming
        // transition is likely due to interrupt which is usually unpaired.
        // Ignore current and subsequent entries since they are likely in
        // different contexts.
        break;
      }

      if (IsIncoming) {
        // For transition from external code (such as dynamic libraries) to
        // the current binary, keep track of the branch target which will be
        // grouped with the Source of the last transition from the current
        // binary.
        PrevTrDst = Dst;
        continue;
      }
    }

    // TODO: filter out buggy duplicate branches on Skylake

    LBRStack.emplace_back(LBREntry(Src, Dst, IsArtificial));
  }
  TraceIt.advance();
  return !LBRStack.empty();
}

bool PerfReaderBase::extractCallstack(TraceStream &TraceIt,
                                      SmallVectorImpl<uint64_t> &CallStack) {
  // The raw format of call stack is like:
  //            4005dc      # leaf frame
  //	          400634
  //	          400684      # root frame
  // It's in bottom-up order with each frame in one line.

  // Extract stack frames from sample
  while (!TraceIt.isAtEoF() && !TraceIt.getCurrentLine().startswith(" 0x")) {
    StringRef FrameStr = TraceIt.getCurrentLine().ltrim();
    uint64_t FrameAddr = 0;
    if (FrameStr.getAsInteger(16, FrameAddr)) {
      // We might parse a non-perf sample line like empty line and comments,
      // skip it
      TraceIt.advance();
      return false;
    }
    TraceIt.advance();
    // Currently intermixed frame from different binaries is not supported.
    // Ignore caller frames not from binary of interest.
    if (!Binary->addressIsCode(FrameAddr))
      break;

    // We need to translate return address to call address for non-leaf frames.
    if (!CallStack.empty()) {
      auto CallAddr = Binary->getCallAddrFromFrameAddr(FrameAddr);
      if (!CallAddr) {
        // Stop at an invalid return address caused by bad unwinding. This could
        // happen to frame-pointer-based unwinding and the callee functions that
        // do not have the frame pointer chain set up.
        InvalidReturnAddresses.insert(FrameAddr);
        break;
      }
      FrameAddr = CallAddr;
    }

    CallStack.emplace_back(FrameAddr);
  }

  // Skip other unrelated line, find the next valid LBR line
  // Note that even for empty call stack, we should skip the address at the
  // bottom, otherwise the following pass may generate a truncated callstack
  while (!TraceIt.isAtEoF() && !TraceIt.getCurrentLine().startswith(" 0x")) {
    TraceIt.advance();
  }
  // Filter out broken stack sample. We may not have complete frame info
  // if sample end up in prolog/epilog, the result is dangling context not
  // connected to entry point. This should be relatively rare thus not much
  // impact on overall profile quality. However we do want to filter them
  // out to reduce the number of different calling contexts. One instance
  // of such case - when sample landed in prolog/epilog, somehow stack
  // walking will be broken in an unexpected way that higher frames will be
  // missing.
  return !CallStack.empty() &&
         !Binary->addressInPrologEpilog(CallStack.front());
}

void PerfReaderBase::warnIfMissingMMap() {
  if (!Binary->getMissingMMapWarned() && !Binary->getIsLoadedByMMap()) {
    WithColor::warning() << "No relevant mmap event is matched for "
                         << Binary->getName()
                         << ", will use preferred address ("
                         << format("0x%" PRIx64,
                                   Binary->getPreferredBaseAddress())
                         << ") as the base loading address!\n";
    // Avoid redundant warning, only warn at the first unmatched sample.
    Binary->setMissingMMapWarned(true);
  }
}

void HybridPerfReader::parseSample(TraceStream &TraceIt, uint64_t Count) {
  // The raw hybird sample started with call stack in FILO order and followed
  // intermediately by LBR sample
  // e.g.
  // 	          4005dc    # call stack leaf
  //	          400634
  //	          400684    # call stack root
  // 0x4005c8/0x4005dc/P/-/-/0   0x40062f/0x4005b0/P/-/-/0 ...
  //          ... 0x4005c8/0x4005dc/P/-/-/0    # LBR Entries
  //
  std::shared_ptr<PerfSample> Sample = std::make_shared<PerfSample>();

  // Parsing call stack and populate into PerfSample.CallStack
  if (!extractCallstack(TraceIt, Sample->CallStack)) {
    // Skip the next LBR line matched current call stack
    if (!TraceIt.isAtEoF() && TraceIt.getCurrentLine().startswith(" 0x"))
      TraceIt.advance();
    return;
  }

  warnIfMissingMMap();

  if (!TraceIt.isAtEoF() && TraceIt.getCurrentLine().startswith(" 0x")) {
    // Parsing LBR stack and populate into PerfSample.LBRStack
    if (extractLBRStack(TraceIt, Sample->LBRStack)) {
      if (IgnoreStackSamples) {
        Sample->CallStack.clear();
      } else {
        // Canonicalize stack leaf to avoid 'random' IP from leaf frame skew LBR
        // ranges
        Sample->CallStack.front() = Sample->LBRStack[0].Target;
      }
      // Record samples by aggregation
      AggregatedSamples[Hashable<PerfSample>(Sample)] += Count;
    }
  } else {
    // LBR sample is encoded in single line after stack sample
    exitWithError("'Hybrid perf sample is corrupted, No LBR sample line");
  }
}

void PerfReaderBase::writeRawProfile(StringRef Filename) {
  std::error_code EC;
  raw_fd_ostream OS(Filename, EC, llvm::sys::fs::OF_TextWithCRLF);
  if (EC)
    exitWithError(EC, Filename);
  writeRawProfile(OS);
}

// Use ordered map to make the output deterministic
using OrderedCounterForPrint = std::map<std::string, SampleCounter *>;

void PerfReaderBase::writeRawProfile(raw_fd_ostream &OS) {
  /*
     Format:
     [context string]
     number of entries in RangeCounter
     from_1-to_1:count_1
     from_2-to_2:count_2
     ......
     from_n-to_n:count_n
     number of entries in BranchCounter
     src_1->dst_1:count_1
     src_2->dst_2:count_2
     ......
     src_n->dst_n:count_n
  */

  OrderedCounterForPrint OrderedCounters;
  for (auto &CI : SampleCounters) {
    OrderedCounters[getContextKeyStr(CI.first.getPtr(), Binary)] = &CI.second;
  }

  auto SCounterPrinter = [&](RangeSample Counter, StringRef Separator,
                             uint32_t Indent) {
    OS.indent(Indent);
    OS << Counter.size() << "\n";
    for (auto I : Counter) {
      uint64_t Start = UseOffset ? I.first.first
                                 : Binary->offsetToVirtualAddr(I.first.first);
      uint64_t End = UseOffset ? I.first.second
                               : Binary->offsetToVirtualAddr(I.first.second);
      OS.indent(Indent);
      OS << Twine::utohexstr(Start) << Separator << Twine::utohexstr(End) << ":"
         << I.second << "\n";
    }
  };

  for (auto &CI : OrderedCounters) {
    uint32_t Indent = 0;
    if (!CI.first.empty()) {
      // Context string key
      OS << "[" << CI.first << "]\n";
      Indent = 2;
    }

    SampleCounter &Counter = *CI.second;
    SCounterPrinter(Counter.RangeCounter, "-", Indent);
    SCounterPrinter(Counter.BranchCounter, "->", Indent);
  }
}

void LBRPerfReader::computeCounterFromLBR(const PerfSample *Sample,
                                          uint64_t Repeat) {
  SampleCounter &Counter = SampleCounters.begin()->second;
  uint64_t EndOffeset = 0;
  for (const LBREntry &LBR : Sample->LBRStack) {
    uint64_t SourceOffset = Binary->virtualAddrToOffset(LBR.Source);
    uint64_t TargetOffset = Binary->virtualAddrToOffset(LBR.Target);

    if (!LBR.IsArtificial) {
      Counter.recordBranchCount(SourceOffset, TargetOffset, Repeat);
    }

    // If this not the first LBR, update the range count between TO of current
    // LBR and FROM of next LBR.
    uint64_t StartOffset = TargetOffset;
    if (EndOffeset != 0)
      Counter.recordRangeCount(StartOffset, EndOffeset, Repeat);
    EndOffeset = SourceOffset;
  }
}

void LBRPerfReader::parseSample(TraceStream &TraceIt, uint64_t Count) {
  std::shared_ptr<PerfSample> Sample = std::make_shared<PerfSample>();
  // Parsing LBR stack and populate into PerfSample.LBRStack
  if (extractLBRStack(TraceIt, Sample->LBRStack)) {
    warnIfMissingMMap();
    // Record LBR only samples by aggregation
    AggregatedSamples[Hashable<PerfSample>(Sample)] += Count;
  }
}

void LBRPerfReader::generateRawProfile() {
  // There is no context for LBR only sample, so initialize one entry with
  // fake "empty" context key.
  assert(SampleCounters.empty() &&
         "Sample counter map should be empty before raw profile generation");
  std::shared_ptr<StringBasedCtxKey> Key =
      std::make_shared<StringBasedCtxKey>();
  Key->genHashCode();
  SampleCounters.emplace(Hashable<ContextKey>(Key), SampleCounter());
  for (const auto &Item : AggregatedSamples) {
    const PerfSample *Sample = Item.first.getPtr();
    computeCounterFromLBR(Sample, Item.second);
  }
}

uint64_t PerfReaderBase::parseAggregatedCount(TraceStream &TraceIt) {
  // The aggregated count is optional, so do not skip the line and return 1 if
  // it's unmatched
  uint64_t Count = 1;
  if (!TraceIt.getCurrentLine().getAsInteger(10, Count))
    TraceIt.advance();
  return Count;
}

void PerfReaderBase::parseSample(TraceStream &TraceIt) {
  uint64_t Count = parseAggregatedCount(TraceIt);
  assert(Count >= 1 && "Aggregated count should be >= 1!");
  parseSample(TraceIt, Count);
}

bool PerfReaderBase::extractMMap2EventForBinary(ProfiledBinary *Binary,
                                                StringRef Line,
                                                MMapEvent &MMap) {
  // Parse a line like:
  //  PERF_RECORD_MMAP2 2113428/2113428: [0x7fd4efb57000(0x204000) @ 0
  //  08:04 19532229 3585508847]: r-xp /usr/lib64/libdl-2.17.so
  constexpr static const char *const Pattern =
      "PERF_RECORD_MMAP2 ([0-9]+)/[0-9]+: "
      "\\[(0x[a-f0-9]+)\\((0x[a-f0-9]+)\\) @ "
      "(0x[a-f0-9]+|0) .*\\]: [-a-z]+ (.*)";
  // Field 0 - whole line
  // Field 1 - PID
  // Field 2 - base address
  // Field 3 - mmapped size
  // Field 4 - page offset
  // Field 5 - binary path
  enum EventIndex {
    WHOLE_LINE = 0,
    PID = 1,
    MMAPPED_ADDRESS = 2,
    MMAPPED_SIZE = 3,
    PAGE_OFFSET = 4,
    BINARY_PATH = 5
  };

  Regex RegMmap2(Pattern);
  SmallVector<StringRef, 6> Fields;
  bool R = RegMmap2.match(Line, &Fields);
  if (!R) {
    std::string ErrorMsg = "Cannot parse mmap event: " + Line.str() + " \n";
    exitWithError(ErrorMsg);
  }
  Fields[PID].getAsInteger(10, MMap.PID);
  Fields[MMAPPED_ADDRESS].getAsInteger(0, MMap.Address);
  Fields[MMAPPED_SIZE].getAsInteger(0, MMap.Size);
  Fields[PAGE_OFFSET].getAsInteger(0, MMap.Offset);
  MMap.BinaryPath = Fields[BINARY_PATH];
  if (ShowMmapEvents) {
    outs() << "Mmap: Binary " << MMap.BinaryPath << " loaded at "
           << format("0x%" PRIx64 ":", MMap.Address) << " \n";
  }

  StringRef BinaryName = llvm::sys::path::filename(MMap.BinaryPath);
  return Binary->getName() == BinaryName;
}

void PerfReaderBase::parseMMap2Event(TraceStream &TraceIt) {
  MMapEvent MMap;
  if (extractMMap2EventForBinary(Binary, TraceIt.getCurrentLine(), MMap))
    updateBinaryAddress(MMap);
  TraceIt.advance();
}

void PerfReaderBase::parseEventOrSample(TraceStream &TraceIt) {
  if (isMMap2Event(TraceIt.getCurrentLine()))
    parseMMap2Event(TraceIt);
  else
    parseSample(TraceIt);
}

void PerfReaderBase::parseAndAggregateTrace() {
  // Trace line iterator
  TraceStream TraceIt(PerfTraceFile);
  while (!TraceIt.isAtEoF())
    parseEventOrSample(TraceIt);
}

// A LBR sample is like:
// 40062f 0x5c6313f/0x5c63170/P/-/-/0  0x5c630e7/0x5c63130/P/-/-/0 ...
// A heuristic for fast detection by checking whether a
// leading "  0x" and the '/' exist.
bool PerfReaderBase::isLBRSample(StringRef Line) {
  // Skip the leading instruction pointer
  SmallVector<StringRef, 32> Records;
  Line.trim().split(Records, " ", 2, false);
  if (Records.size() < 2)
    return false;
  if (Records[1].startswith("0x") && Records[1].find('/') != StringRef::npos)
    return true;
  return false;
}

bool PerfReaderBase::isMMap2Event(StringRef Line) {
  // Short cut to avoid string find is possible.
  if (Line.empty() || Line.size() < 50)
    return false;

  if (std::isdigit(Line[0]))
    return false;

  // PERF_RECORD_MMAP2 does not appear at the beginning of the line
  // for ` perf script  --show-mmap-events  -i ...`
  return Line.find("PERF_RECORD_MMAP2") != StringRef::npos;
}

// The raw hybird sample is like
// e.g.
// 	          4005dc    # call stack leaf
//	          400634
//	          400684    # call stack root
// 0x4005c8/0x4005dc/P/-/-/0   0x40062f/0x4005b0/P/-/-/0 ...
//          ... 0x4005c8/0x4005dc/P/-/-/0    # LBR Entries
// Determine the perfscript contains hybrid samples(call stack + LBRs) by
// checking whether there is a non-empty call stack immediately followed by
// a LBR sample
PerfScriptType PerfReaderBase::checkPerfScriptType(StringRef FileName) {
  TraceStream TraceIt(FileName);
  uint64_t FrameAddr = 0;
  while (!TraceIt.isAtEoF()) {
    // Skip the aggregated count
    if (!TraceIt.getCurrentLine().getAsInteger(10, FrameAddr))
      TraceIt.advance();

    // Detect sample with call stack
    int32_t Count = 0;
    while (!TraceIt.isAtEoF() &&
           !TraceIt.getCurrentLine().ltrim().getAsInteger(16, FrameAddr)) {
      Count++;
      TraceIt.advance();
    }
    if (!TraceIt.isAtEoF()) {
      if (isLBRSample(TraceIt.getCurrentLine())) {
        if (Count > 0)
          return PERF_LBR_STACK;
        else
          return PERF_LBR;
      }
      TraceIt.advance();
    }
  }

  exitWithError("Invalid perf script input!");
  return PERF_INVALID;
}

void HybridPerfReader::generateRawProfile() {
  ProfileIsCS = !IgnoreStackSamples;
  if (ProfileIsCS)
    unwindSamples();
  else
    LBRPerfReader::generateRawProfile();
}

void PerfReaderBase::warnTruncatedStack() {
  for (auto Address : InvalidReturnAddresses) {
    WithColor::warning()
        << "Truncated stack sample due to invalid return address at "
        << format("0x%" PRIx64, Address)
        << ", likely caused by frame pointer omission\n";
  }
}

void PerfReaderBase::parsePerfTraces() {
  // Parse perf traces and do aggregation.
  parseAndAggregateTrace();

  // Generate unsymbolized profile.
  warnTruncatedStack();
  generateRawProfile();

  if (SkipSymbolization)
    writeRawProfile(OutputFilename);
}

} // end namespace sampleprof
} // end namespace llvm
