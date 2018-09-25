//===-- BenchmarkResult.cpp -------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "BenchmarkResult.h"
#include "BenchmarkRunner.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ObjectYAML/YAML.h"
#include "llvm/Support/FileOutputBuffer.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/raw_ostream.h"

static constexpr const char kIntegerFormat[] = "i_0x%" PRId64 "x";
static constexpr const char kDoubleFormat[] = "f_%la";
static constexpr const char kInvalidOperand[] = "INVALID";

// A mutable struct holding an LLVMState that can be passed through the
// serialization process to encode/decode registers and instructions.
struct YamlContext {
  YamlContext(const exegesis::LLVMState &State)
      : State(&State), ErrorStream(LastError) {}

  void serializeMCInst(const llvm::MCInst &MCInst, llvm::raw_ostream &OS) {
    OS << getInstrName(MCInst.getOpcode());
    for (const auto &Op : MCInst) {
      OS << ' ';
      serializeMCOperand(Op, OS);
    }
  }

  void deserializeMCInst(llvm::StringRef String, llvm::MCInst &Value) {
    llvm::SmallVector<llvm::StringRef, 8> Pieces;
    String.split(Pieces, " ", /* MaxSplit */ -1, /* KeepEmpty */ false);
    if (Pieces.empty()) {
      ErrorStream << "Unknown Instruction: '" << String << "'";
      return;
    }
    bool ProcessOpcode = true;
    for (llvm::StringRef Piece : Pieces) {
      if (ProcessOpcode)
        Value.setOpcode(getInstrOpcode(Piece));
      else
        Value.addOperand(deserializeMCOperand(Piece));
      ProcessOpcode = false;
    }
  }

  std::string &getLastError() { return ErrorStream.str(); }

private:
  void serializeMCOperand(const llvm::MCOperand &MCOperand,
                          llvm::raw_ostream &OS) {
    if (MCOperand.isReg()) {
      OS << getRegName(MCOperand.getReg());
    } else if (MCOperand.isImm()) {
      OS << llvm::format(kIntegerFormat, MCOperand.getImm());
    } else if (MCOperand.isFPImm()) {
      OS << llvm::format(kDoubleFormat, MCOperand.getFPImm());
    } else {
      OS << kInvalidOperand;
    }
  }

  llvm::MCOperand deserializeMCOperand(llvm::StringRef String) {
    assert(!String.empty());
    int64_t IntValue = 0;
    double DoubleValue = 0;
    if (sscanf(String.data(), kIntegerFormat, &IntValue) == 1)
      return llvm::MCOperand::createImm(IntValue);
    if (sscanf(String.data(), kDoubleFormat, &DoubleValue) == 1)
      return llvm::MCOperand::createFPImm(DoubleValue);
    if (unsigned RegNo = getRegNo(String))
      return llvm::MCOperand::createReg(RegNo);
    if (String != kInvalidOperand)
      ErrorStream << "Unknown Operand: '" << String << "'";
    return {};
  }

  llvm::StringRef getRegName(unsigned RegNo) {
    const llvm::StringRef RegName = State->getRegInfo().getName(RegNo);
    if (RegName.empty())
      ErrorStream << "No register with enum value" << RegNo;
    return RegName;
  }

  llvm::StringRef getInstrName(unsigned InstrNo) {
    const llvm::StringRef InstrName = State->getInstrInfo().getName(InstrNo);
    if (InstrName.empty())
      ErrorStream << "No opcode with enum value" << InstrNo;
    return InstrName;
  }

  unsigned getRegNo(llvm::StringRef RegName) {
    const llvm::MCRegisterInfo &RegInfo = State->getRegInfo();
    for (unsigned E = RegInfo.getNumRegs(), I = 0; I < E; ++I)
      if (RegInfo.getName(I) == RegName)
        return I;
    ErrorStream << "No register with name " << RegName;
    return 0;
  }

  unsigned getInstrOpcode(llvm::StringRef InstrName) {
    const llvm::MCInstrInfo &InstrInfo = State->getInstrInfo();
    for (unsigned E = InstrInfo.getNumOpcodes(), I = 0; I < E; ++I)
      if (InstrInfo.getName(I) == InstrName)
        return I;
    ErrorStream << "No opcode with name " << InstrName;
    return 0;
  }

  const exegesis::LLVMState *State;
  std::string LastError;
  llvm::raw_string_ostream ErrorStream;
};

// Defining YAML traits for IO.
namespace llvm {
namespace yaml {

// std::vector<llvm::MCInst> will be rendered as a list.
template <> struct SequenceElementTraits<llvm::MCInst> {
  static const bool flow = false;
};

template <> struct ScalarTraits<llvm::MCInst> {

  static void output(const llvm::MCInst &Value, void *Ctx,
                     llvm::raw_ostream &Out) {
    reinterpret_cast<YamlContext *>(Ctx)->serializeMCInst(Value, Out);
  }

  static StringRef input(StringRef Scalar, void *Ctx, llvm::MCInst &Value) {
    YamlContext &Context = *reinterpret_cast<YamlContext *>(Ctx);
    Context.deserializeMCInst(Scalar, Value);
    return Context.getLastError();
  }

  static QuotingType mustQuote(StringRef) { return QuotingType::Single; }

  static const bool flow = true;
};

// std::vector<exegesis::Measure> will be rendered as a list.
template <> struct SequenceElementTraits<exegesis::BenchmarkMeasure> {
  static const bool flow = false;
};

// exegesis::Measure is rendererd as a flow instead of a list.
// e.g. { "key": "the key", "value": 0123 }
template <> struct MappingTraits<exegesis::BenchmarkMeasure> {
  static void mapping(IO &Io, exegesis::BenchmarkMeasure &Obj) {
    Io.mapRequired("key", Obj.Key);
    Io.mapRequired("value", Obj.Value);
    Io.mapOptional("debug_string", Obj.DebugString);
  }
  static const bool flow = true;
};

template <>
struct ScalarEnumerationTraits<exegesis::InstructionBenchmark::ModeE> {
  static void enumeration(IO &Io,
                          exegesis::InstructionBenchmark::ModeE &Value) {
    Io.enumCase(Value, "", exegesis::InstructionBenchmark::Unknown);
    Io.enumCase(Value, "latency", exegesis::InstructionBenchmark::Latency);
    Io.enumCase(Value, "uops", exegesis::InstructionBenchmark::Uops);
  }
};

template <>
struct MappingContextTraits<exegesis::InstructionBenchmarkKey, YamlContext> {
  static void mapping(IO &Io, exegesis::InstructionBenchmarkKey &Obj,
                      YamlContext &Context) {
    Io.setContext(&Context);
    Io.mapRequired("instructions", Obj.Instructions);
    Io.mapOptional("config", Obj.Config);
  }
};

template <>
struct MappingContextTraits<exegesis::InstructionBenchmark, YamlContext> {
  class NormalizedBinary {
  public:
    NormalizedBinary(IO &io) {}
    NormalizedBinary(IO &, std::vector<uint8_t> &Data) : Binary(Data) {}
    std::vector<uint8_t> denormalize(IO &) {
      std::vector<uint8_t> Data;
      std::string Str;
      raw_string_ostream OSS(Str);
      Binary.writeAsBinary(OSS);
      OSS.flush();
      Data.assign(Str.begin(), Str.end());
      return Data;
    }

    BinaryRef Binary;
  };

  static void mapping(IO &Io, exegesis::InstructionBenchmark &Obj,
                      YamlContext &Context) {
    Io.mapRequired("mode", Obj.Mode);
    Io.mapRequired("key", Obj.Key, Context);
    Io.mapRequired("cpu_name", Obj.CpuName);
    Io.mapRequired("llvm_triple", Obj.LLVMTriple);
    Io.mapRequired("num_repetitions", Obj.NumRepetitions);
    Io.mapRequired("measurements", Obj.Measurements);
    Io.mapRequired("error", Obj.Error);
    Io.mapOptional("info", Obj.Info);
    // AssembledSnippet
    MappingNormalization<NormalizedBinary, std::vector<uint8_t>> BinaryString(
        Io, Obj.AssembledSnippet);
    Io.mapOptional("assembled_snippet", BinaryString->Binary);
  }
};

} // namespace yaml
} // namespace llvm

namespace exegesis {

llvm::Expected<InstructionBenchmark>
InstructionBenchmark::readYaml(const LLVMState &State,
                               llvm::StringRef Filename) {
  if (auto ExpectedMemoryBuffer =
          llvm::errorOrToExpected(llvm::MemoryBuffer::getFile(Filename))) {
    llvm::yaml::Input Yin(*ExpectedMemoryBuffer.get());
    YamlContext Context(State);
    InstructionBenchmark Benchmark;
    if (Yin.setCurrentDocument())
      llvm::yaml::yamlize(Yin, Benchmark, /*unused*/ true, Context);
    if (!Context.getLastError().empty())
      return llvm::make_error<BenchmarkFailure>(Context.getLastError());
    return Benchmark;
  } else {
    return ExpectedMemoryBuffer.takeError();
  }
}

llvm::Expected<std::vector<InstructionBenchmark>>
InstructionBenchmark::readYamls(const LLVMState &State,
                                llvm::StringRef Filename) {
  if (auto ExpectedMemoryBuffer =
          llvm::errorOrToExpected(llvm::MemoryBuffer::getFile(Filename))) {
    llvm::yaml::Input Yin(*ExpectedMemoryBuffer.get());
    YamlContext Context(State);
    std::vector<InstructionBenchmark> Benchmarks;
    while (Yin.setCurrentDocument()) {
      Benchmarks.emplace_back();
      yamlize(Yin, Benchmarks.back(), /*unused*/ true, Context);
      if (Yin.error())
        return llvm::errorCodeToError(Yin.error());
      if (!Context.getLastError().empty())
        return llvm::make_error<BenchmarkFailure>(Context.getLastError());
      Yin.nextDocument();
    }
    return Benchmarks;
  } else {
    return ExpectedMemoryBuffer.takeError();
  }
}

void InstructionBenchmark::writeYamlTo(const LLVMState &State,
                                       llvm::raw_ostream &OS) {
  llvm::yaml::Output Yout(OS);
  YamlContext Context(State);
  llvm::yaml::yamlize(Yout, *this, /*unused*/ true, Context);
}

void InstructionBenchmark::readYamlFrom(const LLVMState &State,
                                        llvm::StringRef InputContent) {
  llvm::yaml::Input Yin(InputContent);
  YamlContext Context(State);
  if (Yin.setCurrentDocument())
    llvm::yaml::yamlize(Yin, *this, /*unused*/ true, Context);
}

llvm::Error InstructionBenchmark::writeYaml(const LLVMState &State,
                                            const llvm::StringRef Filename) {
  if (Filename == "-") {
    writeYamlTo(State, llvm::outs());
  } else {
    int ResultFD = 0;
    if (auto E = llvm::errorCodeToError(
            openFileForWrite(Filename, ResultFD, llvm::sys::fs::CD_CreateAlways,
                             llvm::sys::fs::F_Text))) {
      return E;
    }
    llvm::raw_fd_ostream Ostr(ResultFD, true /*shouldClose*/);
    writeYamlTo(State, Ostr);
  }
  return llvm::Error::success();
}

void BenchmarkMeasureStats::push(const BenchmarkMeasure &BM) {
  if (Key.empty())
    Key = BM.Key;
  assert(Key == BM.Key);
  ++NumValues;
  SumValues += BM.Value;
  MaxValue = std::max(MaxValue, BM.Value);
  MinValue = std::min(MinValue, BM.Value);
}

} // namespace exegesis
