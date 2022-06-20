//===-- WebAssemblyAsmPrinter.cpp - WebAssembly LLVM assembly writer ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file contains a printer that converts from our internal
/// representation of machine-dependent LLVM code to the WebAssembly assembly
/// language.
///
//===----------------------------------------------------------------------===//

#include "WebAssemblyAsmPrinter.h"
#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "MCTargetDesc/WebAssemblyTargetStreamer.h"
#include "TargetInfo/WebAssemblyTargetInfo.h"
#include "Utils/WebAssemblyTypeUtilities.h"
#include "Utils/WebAssemblyUtilities.h"
#include "WebAssembly.h"
#include "WebAssemblyMCInstLower.h"
#include "WebAssemblyMachineFunctionInfo.h"
#include "WebAssemblyRegisterInfo.h"
#include "WebAssemblyRuntimeLibcallSignatures.h"
#include "WebAssemblyTargetMachine.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/BinaryFormat/Wasm.h"
#include "llvm/CodeGen/Analysis.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineModuleInfoImpls.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Metadata.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCSectionWasm.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/MCSymbolWasm.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "asm-printer"

extern cl::opt<bool> WasmKeepRegisters;

//===----------------------------------------------------------------------===//
// Helpers.
//===----------------------------------------------------------------------===//

MVT WebAssemblyAsmPrinter::getRegType(unsigned RegNo) const {
  const TargetRegisterInfo *TRI = Subtarget->getRegisterInfo();
  const TargetRegisterClass *TRC = MRI->getRegClass(RegNo);
  for (MVT T : {MVT::i32, MVT::i64, MVT::f32, MVT::f64, MVT::v16i8, MVT::v8i16,
                MVT::v4i32, MVT::v2i64, MVT::v4f32, MVT::v2f64})
    if (TRI->isTypeLegalForClass(*TRC, T))
      return T;
  LLVM_DEBUG(errs() << "Unknown type for register number: " << RegNo);
  llvm_unreachable("Unknown register type");
  return MVT::Other;
}

std::string WebAssemblyAsmPrinter::regToString(const MachineOperand &MO) {
  Register RegNo = MO.getReg();
  assert(Register::isVirtualRegister(RegNo) &&
         "Unlowered physical register encountered during assembly printing");
  assert(!MFI->isVRegStackified(RegNo));
  unsigned WAReg = MFI->getWAReg(RegNo);
  assert(WAReg != WebAssemblyFunctionInfo::UnusedReg);
  return '$' + utostr(WAReg);
}

WebAssemblyTargetStreamer *WebAssemblyAsmPrinter::getTargetStreamer() {
  MCTargetStreamer *TS = OutStreamer->getTargetStreamer();
  return static_cast<WebAssemblyTargetStreamer *>(TS);
}

// Emscripten exception handling helpers
//
// This converts invoke names generated by LowerEmscriptenEHSjLj to real names
// that are expected by JavaScript glue code. The invoke names generated by
// Emscripten JS glue code are based on their argument and return types; for
// example, for a function that takes an i32 and returns nothing, it is
// 'invoke_vi'. But the format of invoke generated by LowerEmscriptenEHSjLj pass
// contains a mangled string generated from their IR types, for example,
// "__invoke_void_%struct.mystruct*_int", because final wasm types are not
// available in the IR pass. So we convert those names to the form that
// Emscripten JS code expects.
//
// Refer to LowerEmscriptenEHSjLj pass for more details.

// Returns true if the given function name is an invoke name generated by
// LowerEmscriptenEHSjLj pass.
static bool isEmscriptenInvokeName(StringRef Name) {
  if (Name.front() == '"' && Name.back() == '"')
    Name = Name.substr(1, Name.size() - 2);
  return Name.startswith("__invoke_");
}

// Returns a character that represents the given wasm value type in invoke
// signatures.
static char getInvokeSig(wasm::ValType VT) {
  switch (VT) {
  case wasm::ValType::I32:
    return 'i';
  case wasm::ValType::I64:
    return 'j';
  case wasm::ValType::F32:
    return 'f';
  case wasm::ValType::F64:
    return 'd';
  case wasm::ValType::V128:
    return 'V';
  case wasm::ValType::FUNCREF:
    return 'F';
  case wasm::ValType::EXTERNREF:
    return 'X';
  }
  llvm_unreachable("Unhandled wasm::ValType enum");
}

// Given the wasm signature, generate the invoke name in the format JS glue code
// expects.
static std::string getEmscriptenInvokeSymbolName(wasm::WasmSignature *Sig) {
  assert(Sig->Returns.size() <= 1);
  std::string Ret = "invoke_";
  if (!Sig->Returns.empty())
    for (auto VT : Sig->Returns)
      Ret += getInvokeSig(VT);
  else
    Ret += 'v';
  // Invokes' first argument is a pointer to the original function, so skip it
  for (unsigned I = 1, E = Sig->Params.size(); I < E; I++)
    Ret += getInvokeSig(Sig->Params[I]);
  return Ret;
}

//===----------------------------------------------------------------------===//
// WebAssemblyAsmPrinter Implementation.
//===----------------------------------------------------------------------===//

MCSymbolWasm *WebAssemblyAsmPrinter::getMCSymbolForFunction(
    const Function *F, bool EnableEmEH, wasm::WasmSignature *Sig,
    bool &InvokeDetected) {
  MCSymbolWasm *WasmSym = nullptr;
  if (EnableEmEH && isEmscriptenInvokeName(F->getName())) {
    assert(Sig);
    InvokeDetected = true;
    if (Sig->Returns.size() > 1) {
      std::string Msg =
          "Emscripten EH/SjLj does not support multivalue returns: " +
          std::string(F->getName()) + ": " +
          WebAssembly::signatureToString(Sig);
      report_fatal_error(Twine(Msg));
    }
    WasmSym = cast<MCSymbolWasm>(
        GetExternalSymbolSymbol(getEmscriptenInvokeSymbolName(Sig)));
  } else {
    WasmSym = cast<MCSymbolWasm>(getSymbol(F));
  }
  return WasmSym;
}

void WebAssemblyAsmPrinter::emitGlobalVariable(const GlobalVariable *GV) {
  if (!WebAssembly::isWasmVarAddressSpace(GV->getAddressSpace())) {
    AsmPrinter::emitGlobalVariable(GV);
    return;
  }

  assert(!GV->isThreadLocal());

  MCSymbolWasm *Sym = cast<MCSymbolWasm>(getSymbol(GV));

  if (!Sym->getType()) {
    SmallVector<MVT, 1> VTs;
    Type *GlobalVT = GV->getValueType();
    if (Subtarget) {
      // Subtarget is only set when a function is defined, because
      // each function can declare a different subtarget. For example,
      // on ARM a compilation unit might have a function on ARM and
      // another on Thumb. Therefore only if Subtarget is non-null we
      // can actually calculate the legal VTs.
      const WebAssemblyTargetLowering &TLI = *Subtarget->getTargetLowering();
      computeLegalValueVTs(TLI, GV->getParent()->getContext(),
                           GV->getParent()->getDataLayout(), GlobalVT, VTs);
    }
    WebAssembly::wasmSymbolSetType(Sym, GlobalVT, VTs);
  }

  emitVisibility(Sym, GV->getVisibility(), !GV->isDeclaration());
  emitSymbolType(Sym);
  if (GV->hasInitializer()) {
    assert(getSymbolPreferLocal(*GV) == Sym);
    emitLinkage(GV, Sym);
    OutStreamer->emitLabel(Sym);
    // TODO: Actually emit the initializer value.  Otherwise the global has the
    // default value for its type (0, ref.null, etc).
    OutStreamer->addBlankLine();
  }
}

MCSymbol *WebAssemblyAsmPrinter::getOrCreateWasmSymbol(StringRef Name) {
  auto *WasmSym = cast<MCSymbolWasm>(GetExternalSymbolSymbol(Name));

  // May be called multiple times, so early out.
  if (WasmSym->getType())
    return WasmSym;

  const WebAssemblySubtarget &Subtarget = getSubtarget();

  // Except for certain known symbols, all symbols used by CodeGen are
  // functions. It's OK to hardcode knowledge of specific symbols here; this
  // method is precisely there for fetching the signatures of known
  // Clang-provided symbols.
  if (Name == "__stack_pointer" || Name == "__tls_base" ||
      Name == "__memory_base" || Name == "__table_base" ||
      Name == "__tls_size" || Name == "__tls_align") {
    bool Mutable =
        Name == "__stack_pointer" || Name == "__tls_base";
    WasmSym->setType(wasm::WASM_SYMBOL_TYPE_GLOBAL);
    WasmSym->setGlobalType(wasm::WasmGlobalType{
        uint8_t(Subtarget.hasAddr64() ? wasm::WASM_TYPE_I64
                                      : wasm::WASM_TYPE_I32),
        Mutable});
    return WasmSym;
  }

  if (Name.startswith("GCC_except_table")) {
    WasmSym->setType(wasm::WASM_SYMBOL_TYPE_DATA);
    return WasmSym;
  }

  SmallVector<wasm::ValType, 4> Returns;
  SmallVector<wasm::ValType, 4> Params;
  if (Name == "__cpp_exception" || Name == "__c_longjmp") {
    WasmSym->setType(wasm::WASM_SYMBOL_TYPE_TAG);
    // In static linking we define tag symbols in WasmException::endModule().
    // But we may have multiple objects to be linked together, each of which
    // defines the tag symbols. To resolve them, we declare them as weak. In
    // dynamic linking we make tag symbols undefined in the backend, define it
    // in JS, and feed them to each importing module.
    if (!isPositionIndependent())
      WasmSym->setWeak(true);
    WasmSym->setExternal(true);

    // Currently both C++ exceptions and C longjmps have a single pointer type
    // param. For C++ exceptions it is a pointer to an exception object, and for
    // C longjmps it is pointer to a struct that contains a setjmp buffer and a
    // longjmp return value. We may consider using multiple value parameters for
    // longjmps later when multivalue support is ready.
    wasm::ValType AddrType =
        Subtarget.hasAddr64() ? wasm::ValType::I64 : wasm::ValType::I32;
    Params.push_back(AddrType);
  } else { // Function symbols
    WasmSym->setType(wasm::WASM_SYMBOL_TYPE_FUNCTION);
    getLibcallSignature(Subtarget, Name, Returns, Params);
  }
  auto Signature = std::make_unique<wasm::WasmSignature>(std::move(Returns),
                                                         std::move(Params));
  WasmSym->setSignature(Signature.get());
  addSignature(std::move(Signature));

  return WasmSym;
}

void WebAssemblyAsmPrinter::emitSymbolType(const MCSymbolWasm *Sym) {
  Optional<wasm::WasmSymbolType> WasmTy = Sym->getType();
  if (!WasmTy)
    return;

  switch (WasmTy.getValue()) {
  case wasm::WASM_SYMBOL_TYPE_GLOBAL:
    getTargetStreamer()->emitGlobalType(Sym);
    break;
  case wasm::WASM_SYMBOL_TYPE_TAG:
    getTargetStreamer()->emitTagType(Sym);
    break;
  case wasm::WASM_SYMBOL_TYPE_TABLE:
    getTargetStreamer()->emitTableType(Sym);
    break;
  default:
    break; // We only handle globals, tags and tables here
  }
}

void WebAssemblyAsmPrinter::emitDecls(const Module &M) {
  if (signaturesEmitted)
    return;
  signaturesEmitted = true;

  // Normally symbols for globals get discovered as the MI gets lowered,
  // but we need to know about them ahead of time. This will however,
  // only find symbols that have been used. Unused symbols from globals will
  // not be found here.
  MachineModuleInfoWasm &MMIW = MMI->getObjFileInfo<MachineModuleInfoWasm>();
  for (const auto &Name : MMIW.MachineSymbolsUsed) {
    auto *WasmSym = cast<MCSymbolWasm>(getOrCreateWasmSymbol(Name.getKey()));
    if (WasmSym->isFunction()) {
      // TODO(wvo): is there any case where this overlaps with the call to
      // emitFunctionType in the loop below?
      getTargetStreamer()->emitFunctionType(WasmSym);
    }
  }

  for (auto &It : OutContext.getSymbols()) {
    // Emit .globaltype, .tagtype, or .tabletype declarations for extern
    // declarations, i.e. those that have only been declared (but not defined)
    // in the current module
    auto Sym = cast<MCSymbolWasm>(It.getValue());
    if (!Sym->isDefined())
      emitSymbolType(Sym);
  }

  DenseSet<MCSymbol *> InvokeSymbols;
  for (const auto &F : M) {
    if (F.isIntrinsic())
      continue;

    // Emit function type info for all functions. This will emit duplicate
    // information for defined functions (which already have function type
    // info emitted alongside their definition), but this is necessary in
    // order to enable the single-pass WebAssemblyAsmTypeCheck to succeed.
    SmallVector<MVT, 4> Results;
    SmallVector<MVT, 4> Params;
    computeSignatureVTs(F.getFunctionType(), &F, F, TM, Params, Results);
    // At this point these MCSymbols may or may not have been created already
    // and thus also contain a signature, but we need to get the signature
    // anyway here in case it is an invoke that has not yet been created. We
    // will discard it later if it turns out not to be necessary.
    auto Signature = signatureFromMVTs(Results, Params);
    bool InvokeDetected = false;
    auto *Sym = getMCSymbolForFunction(
        &F, WebAssembly::WasmEnableEmEH || WebAssembly::WasmEnableEmSjLj,
        Signature.get(), InvokeDetected);

    // Multiple functions can be mapped to the same invoke symbol. For
    // example, two IR functions '__invoke_void_i8*' and '__invoke_void_i32'
    // are both mapped to '__invoke_vi'. We keep them in a set once we emit an
    // Emscripten EH symbol so we don't emit the same symbol twice.
    if (InvokeDetected && !InvokeSymbols.insert(Sym).second)
      continue;

    Sym->setType(wasm::WASM_SYMBOL_TYPE_FUNCTION);
    if (!Sym->getSignature()) {
      Sym->setSignature(Signature.get());
      addSignature(std::move(Signature));
    } else {
      // This symbol has already been created and had a signature. Discard it.
      Signature.reset();
    }

    getTargetStreamer()->emitFunctionType(Sym);

    if (F.hasFnAttribute("wasm-import-module")) {
      StringRef Name =
          F.getFnAttribute("wasm-import-module").getValueAsString();
      Sym->setImportModule(storeName(Name));
      getTargetStreamer()->emitImportModule(Sym, Name);
    }
    if (F.hasFnAttribute("wasm-import-name")) {
      // If this is a converted Emscripten EH/SjLj symbol, we shouldn't use
      // the original function name but the converted symbol name.
      StringRef Name =
          InvokeDetected
              ? Sym->getName()
              : F.getFnAttribute("wasm-import-name").getValueAsString();
      Sym->setImportName(storeName(Name));
      getTargetStreamer()->emitImportName(Sym, Name);
    }

    if (F.hasFnAttribute("wasm-export-name")) {
      auto *Sym = cast<MCSymbolWasm>(getSymbol(&F));
      StringRef Name = F.getFnAttribute("wasm-export-name").getValueAsString();
      Sym->setExportName(storeName(Name));
      getTargetStreamer()->emitExportName(Sym, Name);
    }
  }
}

void WebAssemblyAsmPrinter::emitEndOfAsmFile(Module &M) {
  // This is required to emit external declarations (like .functypes) when
  // no functions are defined in the compilation unit and therefore,
  // emitDecls() is not called until now.
  emitDecls(M);

  // When a function's address is taken, a TABLE_INDEX relocation is emitted
  // against the function symbol at the use site.  However the relocation
  // doesn't explicitly refer to the table.  In the future we may want to
  // define a new kind of reloc against both the function and the table, so
  // that the linker can see that the function symbol keeps the table alive,
  // but for now manually mark the table as live.
  for (const auto &F : M) {
    if (!F.isIntrinsic() && F.hasAddressTaken()) {
      MCSymbolWasm *FunctionTable =
          WebAssembly::getOrCreateFunctionTableSymbol(OutContext, Subtarget);
      OutStreamer->emitSymbolAttribute(FunctionTable, MCSA_NoDeadStrip);    
      break;
    }
  }

  for (const auto &G : M.globals()) {
    if (!G.hasInitializer() && G.hasExternalLinkage() &&
        !WebAssembly::isWasmVarAddressSpace(G.getAddressSpace()) &&
        G.getValueType()->isSized()) {
      uint16_t Size = M.getDataLayout().getTypeAllocSize(G.getValueType());
      OutStreamer->emitELFSize(getSymbol(&G),
                               MCConstantExpr::create(Size, OutContext));
    }
  }

  if (const NamedMDNode *Named = M.getNamedMetadata("wasm.custom_sections")) {
    for (const Metadata *MD : Named->operands()) {
      const auto *Tuple = dyn_cast<MDTuple>(MD);
      if (!Tuple || Tuple->getNumOperands() != 2)
        continue;
      const MDString *Name = dyn_cast<MDString>(Tuple->getOperand(0));
      const MDString *Contents = dyn_cast<MDString>(Tuple->getOperand(1));
      if (!Name || !Contents)
        continue;

      OutStreamer->pushSection();
      std::string SectionName = (".custom_section." + Name->getString()).str();
      MCSectionWasm *MySection =
          OutContext.getWasmSection(SectionName, SectionKind::getMetadata());
      OutStreamer->switchSection(MySection);
      OutStreamer->emitBytes(Contents->getString());
      OutStreamer->popSection();
    }
  }

  EmitProducerInfo(M);
  EmitTargetFeatures(M);
}

void WebAssemblyAsmPrinter::EmitProducerInfo(Module &M) {
  llvm::SmallVector<std::pair<std::string, std::string>, 4> Languages;
  if (const NamedMDNode *Debug = M.getNamedMetadata("llvm.dbg.cu")) {
    llvm::SmallSet<StringRef, 4> SeenLanguages;
    for (size_t I = 0, E = Debug->getNumOperands(); I < E; ++I) {
      const auto *CU = cast<DICompileUnit>(Debug->getOperand(I));
      StringRef Language = dwarf::LanguageString(CU->getSourceLanguage());
      Language.consume_front("DW_LANG_");
      if (SeenLanguages.insert(Language).second)
        Languages.emplace_back(Language.str(), "");
    }
  }

  llvm::SmallVector<std::pair<std::string, std::string>, 4> Tools;
  if (const NamedMDNode *Ident = M.getNamedMetadata("llvm.ident")) {
    llvm::SmallSet<StringRef, 4> SeenTools;
    for (size_t I = 0, E = Ident->getNumOperands(); I < E; ++I) {
      const auto *S = cast<MDString>(Ident->getOperand(I)->getOperand(0));
      std::pair<StringRef, StringRef> Field = S->getString().split("version");
      StringRef Name = Field.first.trim();
      StringRef Version = Field.second.trim();
      if (SeenTools.insert(Name).second)
        Tools.emplace_back(Name.str(), Version.str());
    }
  }

  int FieldCount = int(!Languages.empty()) + int(!Tools.empty());
  if (FieldCount != 0) {
    MCSectionWasm *Producers = OutContext.getWasmSection(
        ".custom_section.producers", SectionKind::getMetadata());
    OutStreamer->pushSection();
    OutStreamer->switchSection(Producers);
    OutStreamer->emitULEB128IntValue(FieldCount);
    for (auto &Producers : {std::make_pair("language", &Languages),
            std::make_pair("processed-by", &Tools)}) {
      if (Producers.second->empty())
        continue;
      OutStreamer->emitULEB128IntValue(strlen(Producers.first));
      OutStreamer->emitBytes(Producers.first);
      OutStreamer->emitULEB128IntValue(Producers.second->size());
      for (auto &Producer : *Producers.second) {
        OutStreamer->emitULEB128IntValue(Producer.first.size());
        OutStreamer->emitBytes(Producer.first);
        OutStreamer->emitULEB128IntValue(Producer.second.size());
        OutStreamer->emitBytes(Producer.second);
      }
    }
    OutStreamer->popSection();
  }
}

void WebAssemblyAsmPrinter::EmitTargetFeatures(Module &M) {
  struct FeatureEntry {
    uint8_t Prefix;
    std::string Name;
  };

  // Read target features and linkage policies from module metadata
  SmallVector<FeatureEntry, 4> EmittedFeatures;
  auto EmitFeature = [&](std::string Feature) {
    std::string MDKey = (StringRef("wasm-feature-") + Feature).str();
    Metadata *Policy = M.getModuleFlag(MDKey);
    if (Policy == nullptr)
      return;

    FeatureEntry Entry;
    Entry.Prefix = 0;
    Entry.Name = Feature;

    if (auto *MD = cast<ConstantAsMetadata>(Policy))
      if (auto *I = cast<ConstantInt>(MD->getValue()))
        Entry.Prefix = I->getZExtValue();

    // Silently ignore invalid metadata
    if (Entry.Prefix != wasm::WASM_FEATURE_PREFIX_USED &&
        Entry.Prefix != wasm::WASM_FEATURE_PREFIX_REQUIRED &&
        Entry.Prefix != wasm::WASM_FEATURE_PREFIX_DISALLOWED)
      return;

    EmittedFeatures.push_back(Entry);
  };

  for (const SubtargetFeatureKV &KV : WebAssemblyFeatureKV) {
    EmitFeature(KV.Key);
  }
  // This pseudo-feature tells the linker whether shared memory would be safe
  EmitFeature("shared-mem");

  // This is an "architecture", not a "feature", but we emit it as such for
  // the benefit of tools like Binaryen and consistency with other producers.
  // FIXME: Subtarget is null here, so can't Subtarget->hasAddr64() ?
  if (M.getDataLayout().getPointerSize() == 8) {
    // Can't use EmitFeature since "wasm-feature-memory64" is not a module
    // flag.
    EmittedFeatures.push_back({wasm::WASM_FEATURE_PREFIX_USED, "memory64"});
  }

  if (EmittedFeatures.size() == 0)
    return;

  // Emit features and linkage policies into the "target_features" section
  MCSectionWasm *FeaturesSection = OutContext.getWasmSection(
      ".custom_section.target_features", SectionKind::getMetadata());
  OutStreamer->pushSection();
  OutStreamer->switchSection(FeaturesSection);

  OutStreamer->emitULEB128IntValue(EmittedFeatures.size());
  for (auto &F : EmittedFeatures) {
    OutStreamer->emitIntValue(F.Prefix, 1);
    OutStreamer->emitULEB128IntValue(F.Name.size());
    OutStreamer->emitBytes(F.Name);
  }

  OutStreamer->popSection();
}

void WebAssemblyAsmPrinter::emitConstantPool() {
  emitDecls(*MMI->getModule());
  assert(MF->getConstantPool()->getConstants().empty() &&
         "WebAssembly disables constant pools");
}

void WebAssemblyAsmPrinter::emitJumpTableInfo() {
  // Nothing to do; jump tables are incorporated into the instruction stream.
}

void WebAssemblyAsmPrinter::emitFunctionBodyStart() {
  const Function &F = MF->getFunction();
  SmallVector<MVT, 1> ResultVTs;
  SmallVector<MVT, 4> ParamVTs;
  computeSignatureVTs(F.getFunctionType(), &F, F, TM, ParamVTs, ResultVTs);

  auto Signature = signatureFromMVTs(ResultVTs, ParamVTs);
  auto *WasmSym = cast<MCSymbolWasm>(CurrentFnSym);
  WasmSym->setSignature(Signature.get());
  addSignature(std::move(Signature));
  WasmSym->setType(wasm::WASM_SYMBOL_TYPE_FUNCTION);

  getTargetStreamer()->emitFunctionType(WasmSym);

  // Emit the function index.
  if (MDNode *Idx = F.getMetadata("wasm.index")) {
    assert(Idx->getNumOperands() == 1);

    getTargetStreamer()->emitIndIdx(AsmPrinter::lowerConstant(
        cast<ConstantAsMetadata>(Idx->getOperand(0))->getValue()));
  }

  SmallVector<wasm::ValType, 16> Locals;
  valTypesFromMVTs(MFI->getLocals(), Locals);
  getTargetStreamer()->emitLocal(Locals);

  AsmPrinter::emitFunctionBodyStart();
}

void WebAssemblyAsmPrinter::emitInstruction(const MachineInstr *MI) {
  LLVM_DEBUG(dbgs() << "EmitInstruction: " << *MI << '\n');

  switch (MI->getOpcode()) {
  case WebAssembly::ARGUMENT_i32:
  case WebAssembly::ARGUMENT_i32_S:
  case WebAssembly::ARGUMENT_i64:
  case WebAssembly::ARGUMENT_i64_S:
  case WebAssembly::ARGUMENT_f32:
  case WebAssembly::ARGUMENT_f32_S:
  case WebAssembly::ARGUMENT_f64:
  case WebAssembly::ARGUMENT_f64_S:
  case WebAssembly::ARGUMENT_v16i8:
  case WebAssembly::ARGUMENT_v16i8_S:
  case WebAssembly::ARGUMENT_v8i16:
  case WebAssembly::ARGUMENT_v8i16_S:
  case WebAssembly::ARGUMENT_v4i32:
  case WebAssembly::ARGUMENT_v4i32_S:
  case WebAssembly::ARGUMENT_v2i64:
  case WebAssembly::ARGUMENT_v2i64_S:
  case WebAssembly::ARGUMENT_v4f32:
  case WebAssembly::ARGUMENT_v4f32_S:
  case WebAssembly::ARGUMENT_v2f64:
  case WebAssembly::ARGUMENT_v2f64_S:
    // These represent values which are live into the function entry, so there's
    // no instruction to emit.
    break;
  case WebAssembly::FALLTHROUGH_RETURN: {
    // These instructions represent the implicit return at the end of a
    // function body.
    if (isVerbose()) {
      OutStreamer->AddComment("fallthrough-return");
      OutStreamer->addBlankLine();
    }
    break;
  }
  case WebAssembly::COMPILER_FENCE:
    // This is a compiler barrier that prevents instruction reordering during
    // backend compilation, and should not be emitted.
    break;
  default: {
    WebAssemblyMCInstLower MCInstLowering(OutContext, *this);
    MCInst TmpInst;
    MCInstLowering.lower(MI, TmpInst);
    EmitToStreamer(*OutStreamer, TmpInst);
    break;
  }
  }
}

bool WebAssemblyAsmPrinter::PrintAsmOperand(const MachineInstr *MI,
                                            unsigned OpNo,
                                            const char *ExtraCode,
                                            raw_ostream &OS) {
  // First try the generic code, which knows about modifiers like 'c' and 'n'.
  if (!AsmPrinter::PrintAsmOperand(MI, OpNo, ExtraCode, OS))
    return false;

  if (!ExtraCode) {
    const MachineOperand &MO = MI->getOperand(OpNo);
    switch (MO.getType()) {
    case MachineOperand::MO_Immediate:
      OS << MO.getImm();
      return false;
    case MachineOperand::MO_Register:
      // FIXME: only opcode that still contains registers, as required by
      // MachineInstr::getDebugVariable().
      assert(MI->getOpcode() == WebAssembly::INLINEASM);
      OS << regToString(MO);
      return false;
    case MachineOperand::MO_GlobalAddress:
      PrintSymbolOperand(MO, OS);
      return false;
    case MachineOperand::MO_ExternalSymbol:
      GetExternalSymbolSymbol(MO.getSymbolName())->print(OS, MAI);
      printOffset(MO.getOffset(), OS);
      return false;
    case MachineOperand::MO_MachineBasicBlock:
      MO.getMBB()->getSymbol()->print(OS, MAI);
      return false;
    default:
      break;
    }
  }

  return true;
}

bool WebAssemblyAsmPrinter::PrintAsmMemoryOperand(const MachineInstr *MI,
                                                  unsigned OpNo,
                                                  const char *ExtraCode,
                                                  raw_ostream &OS) {
  // The current approach to inline asm is that "r" constraints are expressed
  // as local indices, rather than values on the operand stack. This simplifies
  // using "r" as it eliminates the need to push and pop the values in a
  // particular order, however it also makes it impossible to have an "m"
  // constraint. So we don't support it.

  return AsmPrinter::PrintAsmMemoryOperand(MI, OpNo, ExtraCode, OS);
}

// Force static initialization.
extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeWebAssemblyAsmPrinter() {
  RegisterAsmPrinter<WebAssemblyAsmPrinter> X(getTheWebAssemblyTarget32());
  RegisterAsmPrinter<WebAssemblyAsmPrinter> Y(getTheWebAssemblyTarget64());
}
