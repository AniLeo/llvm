//===- lib/MC/MCAsmStreamer.cpp - Text Assembly Output ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Optional.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/Twine.h"
#include "llvm/DebugInfo/CodeView/SymbolRecord.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCCodeView.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSectionMachO.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbolXCOFF.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/LEB128.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/TargetRegistry.h"
#include <cctype>

using namespace llvm;

namespace {

class MCAsmStreamer final : public MCStreamer {
  std::unique_ptr<formatted_raw_ostream> OSOwner;
  formatted_raw_ostream &OS;
  const MCAsmInfo *MAI;
  std::unique_ptr<MCInstPrinter> InstPrinter;
  std::unique_ptr<MCAssembler> Assembler;

  SmallString<128> ExplicitCommentToEmit;
  SmallString<128> CommentToEmit;
  raw_svector_ostream CommentStream;
  raw_null_ostream NullStream;

  unsigned IsVerboseAsm : 1;
  unsigned ShowInst : 1;
  unsigned UseDwarfDirectory : 1;

  void EmitRegisterName(int64_t Register);
  void emitCFIStartProcImpl(MCDwarfFrameInfo &Frame) override;
  void emitCFIEndProcImpl(MCDwarfFrameInfo &Frame) override;

public:
  MCAsmStreamer(MCContext &Context, std::unique_ptr<formatted_raw_ostream> os,
                bool isVerboseAsm, bool useDwarfDirectory,
                MCInstPrinter *printer, std::unique_ptr<MCCodeEmitter> emitter,
                std::unique_ptr<MCAsmBackend> asmbackend, bool showInst)
      : MCStreamer(Context), OSOwner(std::move(os)), OS(*OSOwner),
        MAI(Context.getAsmInfo()), InstPrinter(printer),
        Assembler(std::make_unique<MCAssembler>(
            Context, std::move(asmbackend), std::move(emitter),
            (asmbackend) ? asmbackend->createObjectWriter(NullStream)
                         : nullptr)),
        CommentStream(CommentToEmit), IsVerboseAsm(isVerboseAsm),
        ShowInst(showInst), UseDwarfDirectory(useDwarfDirectory) {
    assert(InstPrinter);
    if (IsVerboseAsm)
        InstPrinter->setCommentStream(CommentStream);
    if (Assembler->getBackendPtr())
      setAllowAutoPadding(Assembler->getBackend().allowAutoPadding());

    Context.setUseNamesOnTempLabels(true);
  }

  MCAssembler &getAssembler() { return *Assembler; }
  MCAssembler *getAssemblerPtr() override { return nullptr; }

  inline void EmitEOL() {
    // Dump Explicit Comments here.
    emitExplicitComments();
    // If we don't have any comments, just emit a \n.
    if (!IsVerboseAsm) {
      OS << '\n';
      return;
    }
    EmitCommentsAndEOL();
  }

  void emitSyntaxDirective() override;

  void EmitCommentsAndEOL();

  /// Return true if this streamer supports verbose assembly at all.
  bool isVerboseAsm() const override { return IsVerboseAsm; }

  /// Do we support EmitRawText?
  bool hasRawTextSupport() const override { return true; }

  /// Add a comment that can be emitted to the generated .s file to make the
  /// output of the compiler more readable. This only affects the MCAsmStreamer
  /// and only when verbose assembly output is enabled.
  void AddComment(const Twine &T, bool EOL = true) override;

  /// Add a comment showing the encoding of an instruction.
  void AddEncodingComment(const MCInst &Inst, const MCSubtargetInfo &);

  /// Return a raw_ostream that comments can be written to.
  /// Unlike AddComment, you are required to terminate comments with \n if you
  /// use this method.
  raw_ostream &GetCommentOS() override {
    if (!IsVerboseAsm)
      return nulls();  // Discard comments unless in verbose asm mode.
    return CommentStream;
  }

  void emitRawComment(const Twine &T, bool TabPrefix = true) override;

  void addExplicitComment(const Twine &T) override;
  void emitExplicitComments() override;

  /// Emit a blank line to a .s file to pretty it up.
  void AddBlankLine() override {
    EmitEOL();
  }

  /// @name MCStreamer Interface
  /// @{

  void changeSection(MCSection *Section, const MCExpr *Subsection) override;

  void emitELFSymverDirective(StringRef AliasName,
                              const MCSymbol *Aliasee) override;

  void emitLOHDirective(MCLOHType Kind, const MCLOHArgs &Args) override;
  void emitLabel(MCSymbol *Symbol, SMLoc Loc = SMLoc()) override;

  void emitAssemblerFlag(MCAssemblerFlag Flag) override;
  void emitLinkerOptions(ArrayRef<std::string> Options) override;
  void emitDataRegion(MCDataRegionType Kind) override;
  void emitVersionMin(MCVersionMinType Kind, unsigned Major, unsigned Minor,
                      unsigned Update, VersionTuple SDKVersion) override;
  void emitBuildVersion(unsigned Platform, unsigned Major, unsigned Minor,
                        unsigned Update, VersionTuple SDKVersion) override;
  void emitThumbFunc(MCSymbol *Func) override;

  void emitAssignment(MCSymbol *Symbol, const MCExpr *Value) override;
  void emitWeakReference(MCSymbol *Alias, const MCSymbol *Symbol) override;
  bool emitSymbolAttribute(MCSymbol *Symbol, MCSymbolAttr Attribute,
                           SMLoc) override;

  void emitSymbolDesc(MCSymbol *Symbol, unsigned DescValue) override;
  void BeginCOFFSymbolDef(const MCSymbol *Symbol) override;
  void EmitCOFFSymbolStorageClass(int StorageClass) override;
  void EmitCOFFSymbolType(int Type) override;
  void EndCOFFSymbolDef() override;
  void EmitCOFFSafeSEH(MCSymbol const *Symbol) override;
  void EmitCOFFSymbolIndex(MCSymbol const *Symbol) override;
  void EmitCOFFSectionIndex(MCSymbol const *Symbol) override;
  void EmitCOFFSecRel32(MCSymbol const *Symbol, uint64_t Offset) override;
  void EmitCOFFImgRel32(MCSymbol const *Symbol, int64_t Offset) override;
  void emitXCOFFLocalCommonSymbol(MCSymbol *LabelSym, uint64_t Size,
                                  MCSymbol *CsectSym,
                                  unsigned ByteAlign) override;
  void emitXCOFFSymbolLinkageWithVisibility(MCSymbol *Symbol,
                                            MCSymbolAttr Linakge,
                                            MCSymbolAttr Visibility) override;
  void emitXCOFFRenameDirective(const MCSymbol *Name,
                                StringRef Rename) override;

  void emitELFSize(MCSymbol *Symbol, const MCExpr *Value) override;
  void emitCommonSymbol(MCSymbol *Symbol, uint64_t Size,
                        unsigned ByteAlignment) override;

  /// Emit a local common (.lcomm) symbol.
  ///
  /// @param Symbol - The common symbol to emit.
  /// @param Size - The size of the common symbol.
  /// @param ByteAlignment - The alignment of the common symbol in bytes.
  void emitLocalCommonSymbol(MCSymbol *Symbol, uint64_t Size,
                             unsigned ByteAlignment) override;

  void emitZerofill(MCSection *Section, MCSymbol *Symbol = nullptr,
                    uint64_t Size = 0, unsigned ByteAlignment = 0,
                    SMLoc Loc = SMLoc()) override;

  void emitTBSSSymbol(MCSection *Section, MCSymbol *Symbol, uint64_t Size,
                      unsigned ByteAlignment = 0) override;

  void emitBinaryData(StringRef Data) override;

  void emitBytes(StringRef Data) override;

  void emitValueImpl(const MCExpr *Value, unsigned Size,
                     SMLoc Loc = SMLoc()) override;
  void emitIntValue(uint64_t Value, unsigned Size) override;
  void emitIntValueInHex(uint64_t Value, unsigned Size) override;
  void emitIntValueInHexWithPadding(uint64_t Value, unsigned Size) override;

  void emitULEB128Value(const MCExpr *Value) override;

  void emitSLEB128Value(const MCExpr *Value) override;

  void emitDTPRel32Value(const MCExpr *Value) override;
  void emitDTPRel64Value(const MCExpr *Value) override;
  void emitTPRel32Value(const MCExpr *Value) override;
  void emitTPRel64Value(const MCExpr *Value) override;

  void emitGPRel64Value(const MCExpr *Value) override;

  void emitGPRel32Value(const MCExpr *Value) override;

  void emitFill(const MCExpr &NumBytes, uint64_t FillValue,
                SMLoc Loc = SMLoc()) override;

  void emitFill(const MCExpr &NumValues, int64_t Size, int64_t Expr,
                SMLoc Loc = SMLoc()) override;

  void emitValueToAlignment(unsigned ByteAlignment, int64_t Value = 0,
                            unsigned ValueSize = 1,
                            unsigned MaxBytesToEmit = 0) override;

  void emitCodeAlignment(unsigned ByteAlignment,
                         unsigned MaxBytesToEmit = 0) override;

  void emitValueToOffset(const MCExpr *Offset,
                         unsigned char Value,
                         SMLoc Loc) override;

  void emitFileDirective(StringRef Filename) override;
  Expected<unsigned> tryEmitDwarfFileDirective(unsigned FileNo,
                                               StringRef Directory,
                                               StringRef Filename,
                                               Optional<MD5::MD5Result> Checksum = None,
                                               Optional<StringRef> Source = None,
                                               unsigned CUID = 0) override;
  void emitDwarfFile0Directive(StringRef Directory, StringRef Filename,
                               Optional<MD5::MD5Result> Checksum,
                               Optional<StringRef> Source,
                               unsigned CUID = 0) override;
  void emitDwarfLocDirective(unsigned FileNo, unsigned Line, unsigned Column,
                             unsigned Flags, unsigned Isa,
                             unsigned Discriminator,
                             StringRef FileName) override;
  MCSymbol *getDwarfLineTableSymbol(unsigned CUID) override;

  bool EmitCVFileDirective(unsigned FileNo, StringRef Filename,
                           ArrayRef<uint8_t> Checksum,
                           unsigned ChecksumKind) override;
  bool EmitCVFuncIdDirective(unsigned FuncId) override;
  bool EmitCVInlineSiteIdDirective(unsigned FunctionId, unsigned IAFunc,
                                   unsigned IAFile, unsigned IALine,
                                   unsigned IACol, SMLoc Loc) override;
  void emitCVLocDirective(unsigned FunctionId, unsigned FileNo, unsigned Line,
                          unsigned Column, bool PrologueEnd, bool IsStmt,
                          StringRef FileName, SMLoc Loc) override;
  void emitCVLinetableDirective(unsigned FunctionId, const MCSymbol *FnStart,
                                const MCSymbol *FnEnd) override;
  void emitCVInlineLinetableDirective(unsigned PrimaryFunctionId,
                                      unsigned SourceFileId,
                                      unsigned SourceLineNum,
                                      const MCSymbol *FnStartSym,
                                      const MCSymbol *FnEndSym) override;

  void PrintCVDefRangePrefix(
      ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges);

  void emitCVDefRangeDirective(
      ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
      codeview::DefRangeRegisterRelHeader DRHdr) override;

  void emitCVDefRangeDirective(
      ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
      codeview::DefRangeSubfieldRegisterHeader DRHdr) override;

  void emitCVDefRangeDirective(
      ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
      codeview::DefRangeRegisterHeader DRHdr) override;

  void emitCVDefRangeDirective(
      ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
      codeview::DefRangeFramePointerRelHeader DRHdr) override;

  void emitCVStringTableDirective() override;
  void emitCVFileChecksumsDirective() override;
  void emitCVFileChecksumOffsetDirective(unsigned FileNo) override;
  void EmitCVFPOData(const MCSymbol *ProcSym, SMLoc L) override;

  void emitIdent(StringRef IdentString) override;
  void emitCFIBKeyFrame() override;
  void emitCFISections(bool EH, bool Debug) override;
  void emitCFIDefCfa(int64_t Register, int64_t Offset) override;
  void emitCFIDefCfaOffset(int64_t Offset) override;
  void emitCFIDefCfaRegister(int64_t Register) override;
  void emitCFIOffset(int64_t Register, int64_t Offset) override;
  void emitCFIPersonality(const MCSymbol *Sym, unsigned Encoding) override;
  void emitCFILsda(const MCSymbol *Sym, unsigned Encoding) override;
  void emitCFIRememberState() override;
  void emitCFIRestoreState() override;
  void emitCFIRestore(int64_t Register) override;
  void emitCFISameValue(int64_t Register) override;
  void emitCFIRelOffset(int64_t Register, int64_t Offset) override;
  void emitCFIAdjustCfaOffset(int64_t Adjustment) override;
  void emitCFIEscape(StringRef Values) override;
  void emitCFIGnuArgsSize(int64_t Size) override;
  void emitCFISignalFrame() override;
  void emitCFIUndefined(int64_t Register) override;
  void emitCFIRegister(int64_t Register1, int64_t Register2) override;
  void emitCFIWindowSave() override;
  void emitCFINegateRAState() override;
  void emitCFIReturnColumn(int64_t Register) override;

  void EmitWinCFIStartProc(const MCSymbol *Symbol, SMLoc Loc) override;
  void EmitWinCFIEndProc(SMLoc Loc) override;
  void EmitWinCFIFuncletOrFuncEnd(SMLoc Loc) override;
  void EmitWinCFIStartChained(SMLoc Loc) override;
  void EmitWinCFIEndChained(SMLoc Loc) override;
  void EmitWinCFIPushReg(MCRegister Register, SMLoc Loc) override;
  void EmitWinCFISetFrame(MCRegister Register, unsigned Offset,
                          SMLoc Loc) override;
  void EmitWinCFIAllocStack(unsigned Size, SMLoc Loc) override;
  void EmitWinCFISaveReg(MCRegister Register, unsigned Offset,
                         SMLoc Loc) override;
  void EmitWinCFISaveXMM(MCRegister Register, unsigned Offset,
                         SMLoc Loc) override;
  void EmitWinCFIPushFrame(bool Code, SMLoc Loc) override;
  void EmitWinCFIEndProlog(SMLoc Loc) override;

  void EmitWinEHHandler(const MCSymbol *Sym, bool Unwind, bool Except,
                        SMLoc Loc) override;
  void EmitWinEHHandlerData(SMLoc Loc) override;

  void emitCGProfileEntry(const MCSymbolRefExpr *From,
                          const MCSymbolRefExpr *To, uint64_t Count) override;

  void emitInstruction(const MCInst &Inst, const MCSubtargetInfo &STI) override;

  void emitBundleAlignMode(unsigned AlignPow2) override;
  void emitBundleLock(bool AlignToEnd) override;
  void emitBundleUnlock() override;

  Optional<std::pair<bool, std::string>>
  emitRelocDirective(const MCExpr &Offset, StringRef Name, const MCExpr *Expr,
                     SMLoc Loc, const MCSubtargetInfo &STI) override;

  void emitAddrsig() override;
  void emitAddrsigSym(const MCSymbol *Sym) override;

  /// If this file is backed by an assembly streamer, this dumps the specified
  /// string in the output .s file. This capability is indicated by the
  /// hasRawTextSupport() predicate.
  void emitRawTextImpl(StringRef String) override;

  void finishImpl() override;
};

} // end anonymous namespace.

void MCAsmStreamer::AddComment(const Twine &T, bool EOL) {
  if (!IsVerboseAsm) return;

  T.toVector(CommentToEmit);

  if (EOL)
    CommentToEmit.push_back('\n'); // Place comment in a new line.
}

void MCAsmStreamer::EmitCommentsAndEOL() {
  if (CommentToEmit.empty() && CommentStream.GetNumBytesInBuffer() == 0) {
    OS << '\n';
    return;
  }

  StringRef Comments = CommentToEmit;

  assert(Comments.back() == '\n' &&
         "Comment array not newline terminated");
  do {
    // Emit a line of comments.
    OS.PadToColumn(MAI->getCommentColumn());
    size_t Position = Comments.find('\n');
    OS << MAI->getCommentString() << ' ' << Comments.substr(0, Position) <<'\n';

    Comments = Comments.substr(Position+1);
  } while (!Comments.empty());

  CommentToEmit.clear();
}

static inline int64_t truncateToSize(int64_t Value, unsigned Bytes) {
  assert(Bytes > 0 && Bytes <= 8 && "Invalid size!");
  return Value & ((uint64_t) (int64_t) -1 >> (64 - Bytes * 8));
}

void MCAsmStreamer::emitRawComment(const Twine &T, bool TabPrefix) {
  if (TabPrefix)
    OS << '\t';
  OS << MAI->getCommentString() << T;
  EmitEOL();
}

void MCAsmStreamer::addExplicitComment(const Twine &T) {
  StringRef c = T.getSingleStringRef();
  if (c.equals(StringRef(MAI->getSeparatorString())))
    return;
  if (c.startswith(StringRef("//"))) {
    ExplicitCommentToEmit.append("\t");
    ExplicitCommentToEmit.append(MAI->getCommentString());
    // drop //
    ExplicitCommentToEmit.append(c.slice(2, c.size()).str());
  } else if (c.startswith(StringRef("/*"))) {
    size_t p = 2, len = c.size() - 2;
    // emit each line in comment as separate newline.
    do {
      size_t newp = std::min(len, c.find_first_of("\r\n", p));
      ExplicitCommentToEmit.append("\t");
      ExplicitCommentToEmit.append(MAI->getCommentString());
      ExplicitCommentToEmit.append(c.slice(p, newp).str());
      // If we have another line in this comment add line
      if (newp < len)
        ExplicitCommentToEmit.append("\n");
      p = newp + 1;
    } while (p < len);
  } else if (c.startswith(StringRef(MAI->getCommentString()))) {
    ExplicitCommentToEmit.append("\t");
    ExplicitCommentToEmit.append(c.str());
  } else if (c.front() == '#') {

    ExplicitCommentToEmit.append("\t");
    ExplicitCommentToEmit.append(MAI->getCommentString());
    ExplicitCommentToEmit.append(c.slice(1, c.size()).str());
  } else
    assert(false && "Unexpected Assembly Comment");
  // full line comments immediately output
  if (c.back() == '\n')
    emitExplicitComments();
}

void MCAsmStreamer::emitExplicitComments() {
  StringRef Comments = ExplicitCommentToEmit;
  if (!Comments.empty())
    OS << Comments;
  ExplicitCommentToEmit.clear();
}

void MCAsmStreamer::changeSection(MCSection *Section,
                                  const MCExpr *Subsection) {
  assert(Section && "Cannot switch to a null section!");
  if (MCTargetStreamer *TS = getTargetStreamer()) {
    TS->changeSection(getCurrentSectionOnly(), Section, Subsection, OS);
  } else {
    Section->PrintSwitchToSection(
        *MAI, getContext().getObjectFileInfo()->getTargetTriple(), OS,
        Subsection);
  }
}

void MCAsmStreamer::emitELFSymverDirective(StringRef AliasName,
                                           const MCSymbol *Aliasee) {
  OS << ".symver ";
  Aliasee->print(OS, MAI);
  OS << ", " << AliasName;
  EmitEOL();
}

void MCAsmStreamer::emitLabel(MCSymbol *Symbol, SMLoc Loc) {
  MCStreamer::emitLabel(Symbol, Loc);

  Symbol->print(OS, MAI);
  OS << MAI->getLabelSuffix();

  EmitEOL();
}

void MCAsmStreamer::emitLOHDirective(MCLOHType Kind, const MCLOHArgs &Args) {
  StringRef str = MCLOHIdToName(Kind);

#ifndef NDEBUG
  int NbArgs = MCLOHIdToNbArgs(Kind);
  assert(NbArgs != -1 && ((size_t)NbArgs) == Args.size() && "Malformed LOH!");
  assert(str != "" && "Invalid LOH name");
#endif

  OS << "\t" << MCLOHDirectiveName() << " " << str << "\t";
  bool IsFirst = true;
  for (const MCSymbol *Arg : Args) {
    if (!IsFirst)
      OS << ", ";
    IsFirst = false;
    Arg->print(OS, MAI);
  }
  EmitEOL();
}

void MCAsmStreamer::emitAssemblerFlag(MCAssemblerFlag Flag) {
  switch (Flag) {
  case MCAF_SyntaxUnified:         OS << "\t.syntax unified"; break;
  case MCAF_SubsectionsViaSymbols: OS << ".subsections_via_symbols"; break;
  case MCAF_Code16:                OS << '\t'<< MAI->getCode16Directive();break;
  case MCAF_Code32:                OS << '\t'<< MAI->getCode32Directive();break;
  case MCAF_Code64:                OS << '\t'<< MAI->getCode64Directive();break;
  }
  EmitEOL();
}

void MCAsmStreamer::emitLinkerOptions(ArrayRef<std::string> Options) {
  assert(!Options.empty() && "At least one option is required!");
  OS << "\t.linker_option \"" << Options[0] << '"';
  for (ArrayRef<std::string>::iterator it = Options.begin() + 1,
         ie = Options.end(); it != ie; ++it) {
    OS << ", " << '"' << *it << '"';
  }
  EmitEOL();
}

void MCAsmStreamer::emitDataRegion(MCDataRegionType Kind) {
  if (!MAI->doesSupportDataRegionDirectives())
    return;
  switch (Kind) {
  case MCDR_DataRegion:            OS << "\t.data_region"; break;
  case MCDR_DataRegionJT8:         OS << "\t.data_region jt8"; break;
  case MCDR_DataRegionJT16:        OS << "\t.data_region jt16"; break;
  case MCDR_DataRegionJT32:        OS << "\t.data_region jt32"; break;
  case MCDR_DataRegionEnd:         OS << "\t.end_data_region"; break;
  }
  EmitEOL();
}

static const char *getVersionMinDirective(MCVersionMinType Type) {
  switch (Type) {
  case MCVM_WatchOSVersionMin: return ".watchos_version_min";
  case MCVM_TvOSVersionMin:    return ".tvos_version_min";
  case MCVM_IOSVersionMin:     return ".ios_version_min";
  case MCVM_OSXVersionMin:     return ".macosx_version_min";
  }
  llvm_unreachable("Invalid MC version min type");
}

static void EmitSDKVersionSuffix(raw_ostream &OS,
                                 const VersionTuple &SDKVersion) {
  if (SDKVersion.empty())
    return;
  OS << '\t' << "sdk_version " << SDKVersion.getMajor();
  if (auto Minor = SDKVersion.getMinor()) {
    OS << ", " << *Minor;
    if (auto Subminor = SDKVersion.getSubminor()) {
      OS << ", " << *Subminor;
    }
  }
}

void MCAsmStreamer::emitVersionMin(MCVersionMinType Type, unsigned Major,
                                   unsigned Minor, unsigned Update,
                                   VersionTuple SDKVersion) {
  OS << '\t' << getVersionMinDirective(Type) << ' ' << Major << ", " << Minor;
  if (Update)
    OS << ", " << Update;
  EmitSDKVersionSuffix(OS, SDKVersion);
  EmitEOL();
}

static const char *getPlatformName(MachO::PlatformType Type) {
  switch (Type) {
  case MachO::PLATFORM_MACOS:            return "macos";
  case MachO::PLATFORM_IOS:              return "ios";
  case MachO::PLATFORM_TVOS:             return "tvos";
  case MachO::PLATFORM_WATCHOS:          return "watchos";
  case MachO::PLATFORM_BRIDGEOS:         return "bridgeos";
  case MachO::PLATFORM_MACCATALYST:      return "macCatalyst";
  case MachO::PLATFORM_IOSSIMULATOR:     return "iossimulator";
  case MachO::PLATFORM_TVOSSIMULATOR:    return "tvossimulator";
  case MachO::PLATFORM_WATCHOSSIMULATOR: return "watchossimulator";
  case MachO::PLATFORM_DRIVERKIT:        return "driverkit";
  }
  llvm_unreachable("Invalid Mach-O platform type");
}

void MCAsmStreamer::emitBuildVersion(unsigned Platform, unsigned Major,
                                     unsigned Minor, unsigned Update,
                                     VersionTuple SDKVersion) {
  const char *PlatformName = getPlatformName((MachO::PlatformType)Platform);
  OS << "\t.build_version " << PlatformName << ", " << Major << ", " << Minor;
  if (Update)
    OS << ", " << Update;
  EmitSDKVersionSuffix(OS, SDKVersion);
  EmitEOL();
}

void MCAsmStreamer::emitThumbFunc(MCSymbol *Func) {
  // This needs to emit to a temporary string to get properly quoted
  // MCSymbols when they have spaces in them.
  OS << "\t.thumb_func";
  // Only Mach-O hasSubsectionsViaSymbols()
  if (MAI->hasSubsectionsViaSymbols()) {
    OS << '\t';
    Func->print(OS, MAI);
  }
  EmitEOL();
}

void MCAsmStreamer::emitAssignment(MCSymbol *Symbol, const MCExpr *Value) {
  // Do not emit a .set on inlined target assignments.
  bool EmitSet = true;
  if (auto *E = dyn_cast<MCTargetExpr>(Value))
    if (E->inlineAssignedExpr())
      EmitSet = false;
  if (EmitSet) {
    OS << ".set ";
    Symbol->print(OS, MAI);
    OS << ", ";
    Value->print(OS, MAI);

    EmitEOL();
  }

  MCStreamer::emitAssignment(Symbol, Value);
}

void MCAsmStreamer::emitWeakReference(MCSymbol *Alias, const MCSymbol *Symbol) {
  OS << ".weakref ";
  Alias->print(OS, MAI);
  OS << ", ";
  Symbol->print(OS, MAI);
  EmitEOL();
}

bool MCAsmStreamer::emitSymbolAttribute(MCSymbol *Symbol,
                                        MCSymbolAttr Attribute, SMLoc) {
  switch (Attribute) {
  case MCSA_Invalid: llvm_unreachable("Invalid symbol attribute");
  case MCSA_ELF_TypeFunction:    /// .type _foo, STT_FUNC  # aka @function
  case MCSA_ELF_TypeIndFunction: /// .type _foo, STT_GNU_IFUNC
  case MCSA_ELF_TypeObject:      /// .type _foo, STT_OBJECT  # aka @object
  case MCSA_ELF_TypeTLS:         /// .type _foo, STT_TLS     # aka @tls_object
  case MCSA_ELF_TypeCommon:      /// .type _foo, STT_COMMON  # aka @common
  case MCSA_ELF_TypeNoType:      /// .type _foo, STT_NOTYPE  # aka @notype
  case MCSA_ELF_TypeGnuUniqueObject:  /// .type _foo, @gnu_unique_object
    if (!MAI->hasDotTypeDotSizeDirective())
      return false; // Symbol attribute not supported
    OS << "\t.type\t";
    Symbol->print(OS, MAI);
    OS << ',' << ((MAI->getCommentString()[0] != '@') ? '@' : '%');
    switch (Attribute) {
    default: return false;
    case MCSA_ELF_TypeFunction:    OS << "function"; break;
    case MCSA_ELF_TypeIndFunction: OS << "gnu_indirect_function"; break;
    case MCSA_ELF_TypeObject:      OS << "object"; break;
    case MCSA_ELF_TypeTLS:         OS << "tls_object"; break;
    case MCSA_ELF_TypeCommon:      OS << "common"; break;
    case MCSA_ELF_TypeNoType:      OS << "notype"; break;
    case MCSA_ELF_TypeGnuUniqueObject: OS << "gnu_unique_object"; break;
    }
    EmitEOL();
    return true;
  case MCSA_Global: // .globl/.global
    OS << MAI->getGlobalDirective();
    break;
  case MCSA_LGlobal:        OS << "\t.lglobl\t";          break;
  case MCSA_Hidden:         OS << "\t.hidden\t";          break;
  case MCSA_IndirectSymbol: OS << "\t.indirect_symbol\t"; break;
  case MCSA_Internal:       OS << "\t.internal\t";        break;
  case MCSA_LazyReference:  OS << "\t.lazy_reference\t";  break;
  case MCSA_Local:          OS << "\t.local\t";           break;
  case MCSA_NoDeadStrip:
    if (!MAI->hasNoDeadStrip())
      return false;
    OS << "\t.no_dead_strip\t";
    break;
  case MCSA_SymbolResolver: OS << "\t.symbol_resolver\t"; break;
  case MCSA_AltEntry:       OS << "\t.alt_entry\t";       break;
  case MCSA_PrivateExtern:
    OS << "\t.private_extern\t";
    break;
  case MCSA_Protected:      OS << "\t.protected\t";       break;
  case MCSA_Reference:      OS << "\t.reference\t";       break;
  case MCSA_Extern:
    OS << "\t.extern\t";
    break;
  case MCSA_Weak:           OS << MAI->getWeakDirective(); break;
  case MCSA_WeakDefinition:
    OS << "\t.weak_definition\t";
    break;
      // .weak_reference
  case MCSA_WeakReference:  OS << MAI->getWeakRefDirective(); break;
  case MCSA_WeakDefAutoPrivate: OS << "\t.weak_def_can_be_hidden\t"; break;
  case MCSA_Cold:
    // Assemblers currently do not support a .cold directive.
    return false;
  }

  Symbol->print(OS, MAI);
  EmitEOL();

  return true;
}

void MCAsmStreamer::emitSymbolDesc(MCSymbol *Symbol, unsigned DescValue) {
  OS << ".desc" << ' ';
  Symbol->print(OS, MAI);
  OS << ',' << DescValue;
  EmitEOL();
}

void MCAsmStreamer::emitSyntaxDirective() {
  if (MAI->getAssemblerDialect() == 1) {
    OS << "\t.intel_syntax noprefix";
    EmitEOL();
  }
  // FIXME: Currently emit unprefix'ed registers.
  // The intel_syntax directive has one optional argument
  // with may have a value of prefix or noprefix.
}

void MCAsmStreamer::BeginCOFFSymbolDef(const MCSymbol *Symbol) {
  OS << "\t.def\t ";
  Symbol->print(OS, MAI);
  OS << ';';
  EmitEOL();
}

void MCAsmStreamer::EmitCOFFSymbolStorageClass (int StorageClass) {
  OS << "\t.scl\t" << StorageClass << ';';
  EmitEOL();
}

void MCAsmStreamer::EmitCOFFSymbolType (int Type) {
  OS << "\t.type\t" << Type << ';';
  EmitEOL();
}

void MCAsmStreamer::EndCOFFSymbolDef() {
  OS << "\t.endef";
  EmitEOL();
}

void MCAsmStreamer::EmitCOFFSafeSEH(MCSymbol const *Symbol) {
  OS << "\t.safeseh\t";
  Symbol->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::EmitCOFFSymbolIndex(MCSymbol const *Symbol) {
  OS << "\t.symidx\t";
  Symbol->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::EmitCOFFSectionIndex(MCSymbol const *Symbol) {
  OS << "\t.secidx\t";
  Symbol->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::EmitCOFFSecRel32(MCSymbol const *Symbol, uint64_t Offset) {
  OS << "\t.secrel32\t";
  Symbol->print(OS, MAI);
  if (Offset != 0)
    OS << '+' << Offset;
  EmitEOL();
}

void MCAsmStreamer::EmitCOFFImgRel32(MCSymbol const *Symbol, int64_t Offset) {
  OS << "\t.rva\t";
  Symbol->print(OS, MAI);
  if (Offset > 0)
    OS << '+' << Offset;
  else if (Offset < 0)
    OS << '-' << -Offset;
  EmitEOL();
}

// We need an XCOFF-specific version of this directive as the AIX syntax
// requires a QualName argument identifying the csect name and storage mapping
// class to appear before the alignment if we are specifying it.
void MCAsmStreamer::emitXCOFFLocalCommonSymbol(MCSymbol *LabelSym,
                                               uint64_t Size,
                                               MCSymbol *CsectSym,
                                               unsigned ByteAlignment) {
  assert(MAI->getLCOMMDirectiveAlignmentType() == LCOMM::Log2Alignment &&
         "We only support writing log base-2 alignment format with XCOFF.");
  assert(isPowerOf2_32(ByteAlignment) && "Alignment must be a power of 2.");

  OS << "\t.lcomm\t";
  LabelSym->print(OS, MAI);
  OS << ',' << Size << ',';
  CsectSym->print(OS, MAI);
  OS << ',' << Log2_32(ByteAlignment);

  EmitEOL();

  // Print symbol's rename (original name contains invalid character(s)) if
  // there is one.
  MCSymbolXCOFF *XSym = cast<MCSymbolXCOFF>(CsectSym);
  if (XSym->hasRename())
    emitXCOFFRenameDirective(XSym, XSym->getSymbolTableName());
}

void MCAsmStreamer::emitXCOFFSymbolLinkageWithVisibility(
    MCSymbol *Symbol, MCSymbolAttr Linkage, MCSymbolAttr Visibility) {

  switch (Linkage) {
  case MCSA_Global:
    OS << MAI->getGlobalDirective();
    break;
  case MCSA_Weak:
    OS << MAI->getWeakDirective();
    break;
  case MCSA_Extern:
    OS << "\t.extern\t";
    break;
  case MCSA_LGlobal:
    OS << "\t.lglobl\t";
    break;
  default:
    report_fatal_error("unhandled linkage type");
  }

  Symbol->print(OS, MAI);

  switch (Visibility) {
  case MCSA_Invalid:
    // Nothing to do.
    break;
  case MCSA_Hidden:
    OS << ",hidden";
    break;
  case MCSA_Protected:
    OS << ",protected";
    break;
  default:
    report_fatal_error("unexpected value for Visibility type");
  }
  EmitEOL();

  // Print symbol's rename (original name contains invalid character(s)) if
  // there is one.
  if (cast<MCSymbolXCOFF>(Symbol)->hasRename())
    emitXCOFFRenameDirective(Symbol,
                             cast<MCSymbolXCOFF>(Symbol)->getSymbolTableName());
}

void MCAsmStreamer::emitXCOFFRenameDirective(const MCSymbol *Name,
                                             StringRef Rename) {
  OS << "\t.rename\t";
  Name->print(OS, MAI);
  const char DQ = '"';
  OS << ',' << DQ;
  for (char C : Rename) {
    // To escape a double quote character, the character should be doubled.
    if (C == DQ)
      OS << DQ;
    OS << C;
  }
  OS << DQ;
  EmitEOL();
}

void MCAsmStreamer::emitELFSize(MCSymbol *Symbol, const MCExpr *Value) {
  assert(MAI->hasDotTypeDotSizeDirective());
  OS << "\t.size\t";
  Symbol->print(OS, MAI);
  OS << ", ";
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitCommonSymbol(MCSymbol *Symbol, uint64_t Size,
                                     unsigned ByteAlignment) {
  OS << "\t.comm\t";
  Symbol->print(OS, MAI);
  OS << ',' << Size;

  if (ByteAlignment != 0) {
    if (MAI->getCOMMDirectiveAlignmentIsInBytes())
      OS << ',' << ByteAlignment;
    else
      OS << ',' << Log2_32(ByteAlignment);
  }
  EmitEOL();

  // Print symbol's rename (original name contains invalid character(s)) if
  // there is one.
  MCSymbolXCOFF *XSym = dyn_cast<MCSymbolXCOFF>(Symbol);
  if (XSym && XSym->hasRename())
    emitXCOFFRenameDirective(XSym, XSym->getSymbolTableName());

}

void MCAsmStreamer::emitLocalCommonSymbol(MCSymbol *Symbol, uint64_t Size,
                                          unsigned ByteAlign) {
  OS << "\t.lcomm\t";
  Symbol->print(OS, MAI);
  OS << ',' << Size;

  if (ByteAlign > 1) {
    switch (MAI->getLCOMMDirectiveAlignmentType()) {
    case LCOMM::NoAlignment:
      llvm_unreachable("alignment not supported on .lcomm!");
    case LCOMM::ByteAlignment:
      OS << ',' << ByteAlign;
      break;
    case LCOMM::Log2Alignment:
      assert(isPowerOf2_32(ByteAlign) && "alignment must be a power of 2");
      OS << ',' << Log2_32(ByteAlign);
      break;
    }
  }
  EmitEOL();
}

void MCAsmStreamer::emitZerofill(MCSection *Section, MCSymbol *Symbol,
                                 uint64_t Size, unsigned ByteAlignment,
                                 SMLoc Loc) {
  if (Symbol)
    AssignFragment(Symbol, &Section->getDummyFragment());

  // Note: a .zerofill directive does not switch sections.
  OS << ".zerofill ";

  assert(Section->getVariant() == MCSection::SV_MachO &&
         ".zerofill is a Mach-O specific directive");
  // This is a mach-o specific directive.

  const MCSectionMachO *MOSection = ((const MCSectionMachO*)Section);
  OS << MOSection->getSegmentName() << "," << MOSection->getName();

  if (Symbol) {
    OS << ',';
    Symbol->print(OS, MAI);
    OS << ',' << Size;
    if (ByteAlignment != 0)
      OS << ',' << Log2_32(ByteAlignment);
  }
  EmitEOL();
}

// .tbss sym, size, align
// This depends that the symbol has already been mangled from the original,
// e.g. _a.
void MCAsmStreamer::emitTBSSSymbol(MCSection *Section, MCSymbol *Symbol,
                                   uint64_t Size, unsigned ByteAlignment) {
  AssignFragment(Symbol, &Section->getDummyFragment());

  assert(Symbol && "Symbol shouldn't be NULL!");
  // Instead of using the Section we'll just use the shortcut.

  assert(Section->getVariant() == MCSection::SV_MachO &&
         ".zerofill is a Mach-O specific directive");
  // This is a mach-o specific directive and section.

  OS << ".tbss ";
  Symbol->print(OS, MAI);
  OS << ", " << Size;

  // Output align if we have it.  We default to 1 so don't bother printing
  // that.
  if (ByteAlignment > 1) OS << ", " << Log2_32(ByteAlignment);

  EmitEOL();
}

static inline char toOctal(int X) { return (X&7)+'0'; }

static void PrintByteList(StringRef Data, raw_ostream &OS,
                          MCAsmInfo::AsmCharLiteralSyntax ACLS) {
  assert(!Data.empty() && "Cannot generate an empty list.");
  const auto printCharacterInOctal = [&OS](unsigned char C) {
    OS << '0';
    OS << toOctal(C >> 6);
    OS << toOctal(C >> 3);
    OS << toOctal(C >> 0);
  };
  const auto printOneCharacterFor = [printCharacterInOctal](
                                        auto printOnePrintingCharacter) {
    return [printCharacterInOctal, printOnePrintingCharacter](unsigned char C) {
      if (isPrint(C)) {
        printOnePrintingCharacter(static_cast<char>(C));
        return;
      }
      printCharacterInOctal(C);
    };
  };
  const auto printCharacterList = [Data, &OS](const auto &printOneCharacter) {
    const auto BeginPtr = Data.begin(), EndPtr = Data.end();
    for (const unsigned char C : make_range(BeginPtr, EndPtr - 1)) {
      printOneCharacter(C);
      OS << ',';
    }
    printOneCharacter(*(EndPtr - 1));
  };
  switch (ACLS) {
  case MCAsmInfo::ACLS_Unknown:
    printCharacterList(printCharacterInOctal);
    return;
  case MCAsmInfo::ACLS_SingleQuotePrefix:
    printCharacterList(printOneCharacterFor([&OS](char C) {
      const char AsmCharLitBuf[2] = {'\'', C};
      OS << StringRef(AsmCharLitBuf, sizeof(AsmCharLitBuf));
    }));
    return;
  }
  llvm_unreachable("Invalid AsmCharLiteralSyntax value!");
}

static void PrintQuotedString(StringRef Data, raw_ostream &OS) {
  OS << '"';

  for (unsigned i = 0, e = Data.size(); i != e; ++i) {
    unsigned char C = Data[i];
    if (C == '"' || C == '\\') {
      OS << '\\' << (char)C;
      continue;
    }

    if (isPrint((unsigned char)C)) {
      OS << (char)C;
      continue;
    }

    switch (C) {
      case '\b': OS << "\\b"; break;
      case '\f': OS << "\\f"; break;
      case '\n': OS << "\\n"; break;
      case '\r': OS << "\\r"; break;
      case '\t': OS << "\\t"; break;
      default:
        OS << '\\';
        OS << toOctal(C >> 6);
        OS << toOctal(C >> 3);
        OS << toOctal(C >> 0);
        break;
    }
  }

  OS << '"';
}

void MCAsmStreamer::emitBytes(StringRef Data) {
  assert(getCurrentSectionOnly() &&
         "Cannot emit contents before setting section!");
  if (Data.empty()) return;

  const auto emitAsString = [this](StringRef Data) {
    // If the data ends with 0 and the target supports .asciz, use it, otherwise
    // use .ascii or a byte-list directive
    if (MAI->getAscizDirective() && Data.back() == 0) {
      OS << MAI->getAscizDirective();
      Data = Data.substr(0, Data.size() - 1);
    } else if (LLVM_LIKELY(MAI->getAsciiDirective())) {
      OS << MAI->getAsciiDirective();
    } else if (MAI->getByteListDirective()) {
      OS << MAI->getByteListDirective();
      PrintByteList(Data, OS, MAI->characterLiteralSyntax());
      EmitEOL();
      return true;
    } else {
      return false;
    }

    PrintQuotedString(Data, OS);
    EmitEOL();
    return true;
  };

  if (Data.size() != 1 && emitAsString(Data))
    return;

  // Only single byte is provided or no ascii, asciz, or byte-list directives
  // are applicable. Emit as vector of individual 8bits data elements.
  if (MCTargetStreamer *TS = getTargetStreamer()) {
    TS->emitRawBytes(Data);
    return;
  }
  const char *Directive = MAI->getData8bitsDirective();
  for (const unsigned char C : Data.bytes()) {
    OS << Directive << (unsigned)C;
    EmitEOL();
  }
}

void MCAsmStreamer::emitBinaryData(StringRef Data) {
  // This is binary data. Print it in a grid of hex bytes for readability.
  const size_t Cols = 4;
  for (size_t I = 0, EI = alignTo(Data.size(), Cols); I < EI; I += Cols) {
    size_t J = I, EJ = std::min(I + Cols, Data.size());
    assert(EJ > 0);
    OS << MAI->getData8bitsDirective();
    for (; J < EJ - 1; ++J)
      OS << format("0x%02x", uint8_t(Data[J])) << ", ";
    OS << format("0x%02x", uint8_t(Data[J]));
    EmitEOL();
  }
}

void MCAsmStreamer::emitIntValue(uint64_t Value, unsigned Size) {
  emitValue(MCConstantExpr::create(Value, getContext()), Size);
}

void MCAsmStreamer::emitIntValueInHex(uint64_t Value, unsigned Size) {
  emitValue(MCConstantExpr::create(Value, getContext(), true), Size);
}

void MCAsmStreamer::emitIntValueInHexWithPadding(uint64_t Value,
                                                 unsigned Size) {
  emitValue(MCConstantExpr::create(Value, getContext(), true, Size), Size);
}

void MCAsmStreamer::emitValueImpl(const MCExpr *Value, unsigned Size,
                                  SMLoc Loc) {
  assert(Size <= 8 && "Invalid size");
  assert(getCurrentSectionOnly() &&
         "Cannot emit contents before setting section!");
  const char *Directive = nullptr;
  switch (Size) {
  default: break;
  case 1: Directive = MAI->getData8bitsDirective();  break;
  case 2: Directive = MAI->getData16bitsDirective(); break;
  case 4: Directive = MAI->getData32bitsDirective(); break;
  case 8: Directive = MAI->getData64bitsDirective(); break;
  }

  if (!Directive) {
    int64_t IntValue;
    if (!Value->evaluateAsAbsolute(IntValue))
      report_fatal_error("Don't know how to emit this value.");

    // We couldn't handle the requested integer size so we fallback by breaking
    // the request down into several, smaller, integers.
    // Since sizes greater or equal to "Size" are invalid, we use the greatest
    // power of 2 that is less than "Size" as our largest piece of granularity.
    bool IsLittleEndian = MAI->isLittleEndian();
    for (unsigned Emitted = 0; Emitted != Size;) {
      unsigned Remaining = Size - Emitted;
      // The size of our partial emission must be a power of two less than
      // Size.
      unsigned EmissionSize = PowerOf2Floor(std::min(Remaining, Size - 1));
      // Calculate the byte offset of our partial emission taking into account
      // the endianness of the target.
      unsigned ByteOffset =
          IsLittleEndian ? Emitted : (Remaining - EmissionSize);
      uint64_t ValueToEmit = IntValue >> (ByteOffset * 8);
      // We truncate our partial emission to fit within the bounds of the
      // emission domain.  This produces nicer output and silences potential
      // truncation warnings when round tripping through another assembler.
      uint64_t Shift = 64 - EmissionSize * 8;
      assert(Shift < static_cast<uint64_t>(
                         std::numeric_limits<unsigned long long>::digits) &&
             "undefined behavior");
      ValueToEmit &= ~0ULL >> Shift;
      emitIntValue(ValueToEmit, EmissionSize);
      Emitted += EmissionSize;
    }
    return;
  }

  assert(Directive && "Invalid size for machine code value!");
  OS << Directive;
  if (MCTargetStreamer *TS = getTargetStreamer()) {
    TS->emitValue(Value);
  } else {
    Value->print(OS, MAI);
    EmitEOL();
  }
}

void MCAsmStreamer::emitULEB128Value(const MCExpr *Value) {
  int64_t IntValue;
  if (Value->evaluateAsAbsolute(IntValue)) {
    emitULEB128IntValue(IntValue);
    return;
  }
  OS << "\t.uleb128 ";
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitSLEB128Value(const MCExpr *Value) {
  int64_t IntValue;
  if (Value->evaluateAsAbsolute(IntValue)) {
    emitSLEB128IntValue(IntValue);
    return;
  }
  OS << "\t.sleb128 ";
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitDTPRel64Value(const MCExpr *Value) {
  assert(MAI->getDTPRel64Directive() != nullptr);
  OS << MAI->getDTPRel64Directive();
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitDTPRel32Value(const MCExpr *Value) {
  assert(MAI->getDTPRel32Directive() != nullptr);
  OS << MAI->getDTPRel32Directive();
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitTPRel64Value(const MCExpr *Value) {
  assert(MAI->getTPRel64Directive() != nullptr);
  OS << MAI->getTPRel64Directive();
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitTPRel32Value(const MCExpr *Value) {
  assert(MAI->getTPRel32Directive() != nullptr);
  OS << MAI->getTPRel32Directive();
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitGPRel64Value(const MCExpr *Value) {
  assert(MAI->getGPRel64Directive() != nullptr);
  OS << MAI->getGPRel64Directive();
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitGPRel32Value(const MCExpr *Value) {
  assert(MAI->getGPRel32Directive() != nullptr);
  OS << MAI->getGPRel32Directive();
  Value->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitFill(const MCExpr &NumBytes, uint64_t FillValue,
                             SMLoc Loc) {
  int64_t IntNumBytes;
  const bool IsAbsolute = NumBytes.evaluateAsAbsolute(IntNumBytes);
  if (IsAbsolute && IntNumBytes == 0)
    return;

  if (const char *ZeroDirective = MAI->getZeroDirective()) {
    if (MAI->doesZeroDirectiveSupportNonZeroValue() || FillValue == 0) {
      // FIXME: Emit location directives
      OS << ZeroDirective;
      NumBytes.print(OS, MAI);
      if (FillValue != 0)
        OS << ',' << (int)FillValue;
      EmitEOL();
    } else {
      if (!IsAbsolute)
        report_fatal_error(
            "Cannot emit non-absolute expression lengths of fill.");
      for (int i = 0; i < IntNumBytes; ++i) {
        OS << MAI->getData8bitsDirective() << (int)FillValue;
        EmitEOL();
      }
    }
    return;
  }

  MCStreamer::emitFill(NumBytes, FillValue);
}

void MCAsmStreamer::emitFill(const MCExpr &NumValues, int64_t Size,
                             int64_t Expr, SMLoc Loc) {
  // FIXME: Emit location directives
  OS << "\t.fill\t";
  NumValues.print(OS, MAI);
  OS << ", " << Size << ", 0x";
  OS.write_hex(truncateToSize(Expr, 4));
  EmitEOL();
}

void MCAsmStreamer::emitValueToAlignment(unsigned ByteAlignment, int64_t Value,
                                         unsigned ValueSize,
                                         unsigned MaxBytesToEmit) {
  if (MAI->useDotAlignForAlignment()) {
    if (!isPowerOf2_32(ByteAlignment))
      report_fatal_error("Only power-of-two alignments are supported "
                         "with .align.");
    OS << "\t.align\t";
    OS << Log2_32(ByteAlignment);
    EmitEOL();
    return;
  }

  // Some assemblers don't support non-power of two alignments, so we always
  // emit alignments as a power of two if possible.
  if (isPowerOf2_32(ByteAlignment)) {
    switch (ValueSize) {
    default:
      llvm_unreachable("Invalid size for machine code value!");
    case 1:
      OS << "\t.p2align\t";
      break;
    case 2:
      OS << ".p2alignw ";
      break;
    case 4:
      OS << ".p2alignl ";
      break;
    case 8:
      llvm_unreachable("Unsupported alignment size!");
    }

    OS << Log2_32(ByteAlignment);

    if (Value || MaxBytesToEmit) {
      OS << ", 0x";
      OS.write_hex(truncateToSize(Value, ValueSize));

      if (MaxBytesToEmit)
        OS << ", " << MaxBytesToEmit;
    }
    EmitEOL();
    return;
  }

  // Non-power of two alignment.  This is not widely supported by assemblers.
  // FIXME: Parameterize this based on MAI.
  switch (ValueSize) {
  default: llvm_unreachable("Invalid size for machine code value!");
  case 1: OS << ".balign";  break;
  case 2: OS << ".balignw"; break;
  case 4: OS << ".balignl"; break;
  case 8: llvm_unreachable("Unsupported alignment size!");
  }

  OS << ' ' << ByteAlignment;
  OS << ", " << truncateToSize(Value, ValueSize);
  if (MaxBytesToEmit)
    OS << ", " << MaxBytesToEmit;
  EmitEOL();
}

void MCAsmStreamer::emitCodeAlignment(unsigned ByteAlignment,
                                      unsigned MaxBytesToEmit) {
  // Emit with a text fill value.
  emitValueToAlignment(ByteAlignment, MAI->getTextAlignFillValue(),
                       1, MaxBytesToEmit);
}

void MCAsmStreamer::emitValueToOffset(const MCExpr *Offset,
                                      unsigned char Value,
                                      SMLoc Loc) {
  // FIXME: Verify that Offset is associated with the current section.
  OS << ".org ";
  Offset->print(OS, MAI);
  OS << ", " << (unsigned)Value;
  EmitEOL();
}

void MCAsmStreamer::emitFileDirective(StringRef Filename) {
  assert(MAI->hasSingleParameterDotFile());
  OS << "\t.file\t";
  PrintQuotedString(Filename, OS);
  EmitEOL();
}

static void printDwarfFileDirective(unsigned FileNo, StringRef Directory,
                                    StringRef Filename,
                                    Optional<MD5::MD5Result> Checksum,
                                    Optional<StringRef> Source,
                                    bool UseDwarfDirectory,
                                    raw_svector_ostream &OS) {
  SmallString<128> FullPathName;

  if (!UseDwarfDirectory && !Directory.empty()) {
    if (sys::path::is_absolute(Filename))
      Directory = "";
    else {
      FullPathName = Directory;
      sys::path::append(FullPathName, Filename);
      Directory = "";
      Filename = FullPathName;
    }
  }

  OS << "\t.file\t" << FileNo << ' ';
  if (!Directory.empty()) {
    PrintQuotedString(Directory, OS);
    OS << ' ';
  }
  PrintQuotedString(Filename, OS);
  if (Checksum)
    OS << " md5 0x" << Checksum->digest();
  if (Source) {
    OS << " source ";
    PrintQuotedString(*Source, OS);
  }
}

Expected<unsigned> MCAsmStreamer::tryEmitDwarfFileDirective(
    unsigned FileNo, StringRef Directory, StringRef Filename,
    Optional<MD5::MD5Result> Checksum, Optional<StringRef> Source, unsigned CUID) {
  assert(CUID == 0 && "multiple CUs not supported by MCAsmStreamer");

  MCDwarfLineTable &Table = getContext().getMCDwarfLineTable(CUID);
  unsigned NumFiles = Table.getMCDwarfFiles().size();
  Expected<unsigned> FileNoOrErr =
      Table.tryGetFile(Directory, Filename, Checksum, Source,
                       getContext().getDwarfVersion(), FileNo);
  if (!FileNoOrErr)
    return FileNoOrErr.takeError();
  FileNo = FileNoOrErr.get();
  if (NumFiles == Table.getMCDwarfFiles().size())
    return FileNo;

  SmallString<128> Str;
  raw_svector_ostream OS1(Str);
  printDwarfFileDirective(FileNo, Directory, Filename, Checksum, Source,
                          UseDwarfDirectory, OS1);

  if (MCTargetStreamer *TS = getTargetStreamer())
    TS->emitDwarfFileDirective(OS1.str());
  else
    emitRawText(OS1.str());

  return FileNo;
}

void MCAsmStreamer::emitDwarfFile0Directive(StringRef Directory,
                                            StringRef Filename,
                                            Optional<MD5::MD5Result> Checksum,
                                            Optional<StringRef> Source,
                                            unsigned CUID) {
  assert(CUID == 0);
  // .file 0 is new for DWARF v5.
  if (getContext().getDwarfVersion() < 5)
    return;
  // Inform MCDwarf about the root file.
  getContext().setMCLineTableRootFile(CUID, Directory, Filename, Checksum,
                                      Source);

  SmallString<128> Str;
  raw_svector_ostream OS1(Str);
  printDwarfFileDirective(0, Directory, Filename, Checksum, Source,
                          UseDwarfDirectory, OS1);

  if (MCTargetStreamer *TS = getTargetStreamer())
    TS->emitDwarfFileDirective(OS1.str());
  else
    emitRawText(OS1.str());
}

void MCAsmStreamer::emitDwarfLocDirective(unsigned FileNo, unsigned Line,
                                          unsigned Column, unsigned Flags,
                                          unsigned Isa, unsigned Discriminator,
                                          StringRef FileName) {
  OS << "\t.loc\t" << FileNo << " " << Line << " " << Column;
  if (MAI->supportsExtendedDwarfLocDirective()) {
    if (Flags & DWARF2_FLAG_BASIC_BLOCK)
      OS << " basic_block";
    if (Flags & DWARF2_FLAG_PROLOGUE_END)
      OS << " prologue_end";
    if (Flags & DWARF2_FLAG_EPILOGUE_BEGIN)
      OS << " epilogue_begin";

    unsigned OldFlags = getContext().getCurrentDwarfLoc().getFlags();
    if ((Flags & DWARF2_FLAG_IS_STMT) != (OldFlags & DWARF2_FLAG_IS_STMT)) {
      OS << " is_stmt ";

      if (Flags & DWARF2_FLAG_IS_STMT)
        OS << "1";
      else
        OS << "0";
    }

    if (Isa)
      OS << " isa " << Isa;
    if (Discriminator)
      OS << " discriminator " << Discriminator;
  }

  if (IsVerboseAsm) {
    OS.PadToColumn(MAI->getCommentColumn());
    OS << MAI->getCommentString() << ' ' << FileName << ':'
       << Line << ':' << Column;
  }
  EmitEOL();
  this->MCStreamer::emitDwarfLocDirective(FileNo, Line, Column, Flags, Isa,
                                          Discriminator, FileName);
}

MCSymbol *MCAsmStreamer::getDwarfLineTableSymbol(unsigned CUID) {
  // Always use the zeroth line table, since asm syntax only supports one line
  // table for now.
  return MCStreamer::getDwarfLineTableSymbol(0);
}

bool MCAsmStreamer::EmitCVFileDirective(unsigned FileNo, StringRef Filename,
                                        ArrayRef<uint8_t> Checksum,
                                        unsigned ChecksumKind) {
  if (!getContext().getCVContext().addFile(*this, FileNo, Filename, Checksum,
                                           ChecksumKind))
    return false;

  OS << "\t.cv_file\t" << FileNo << ' ';
  PrintQuotedString(Filename, OS);

  if (!ChecksumKind) {
    EmitEOL();
    return true;
  }

  OS << ' ';
  PrintQuotedString(toHex(Checksum), OS);
  OS << ' ' << ChecksumKind;

  EmitEOL();
  return true;
}

bool MCAsmStreamer::EmitCVFuncIdDirective(unsigned FuncId) {
  OS << "\t.cv_func_id " << FuncId << '\n';
  return MCStreamer::EmitCVFuncIdDirective(FuncId);
}

bool MCAsmStreamer::EmitCVInlineSiteIdDirective(unsigned FunctionId,
                                                unsigned IAFunc,
                                                unsigned IAFile,
                                                unsigned IALine, unsigned IACol,
                                                SMLoc Loc) {
  OS << "\t.cv_inline_site_id " << FunctionId << " within " << IAFunc
     << " inlined_at " << IAFile << ' ' << IALine << ' ' << IACol << '\n';
  return MCStreamer::EmitCVInlineSiteIdDirective(FunctionId, IAFunc, IAFile,
                                                 IALine, IACol, Loc);
}

void MCAsmStreamer::emitCVLocDirective(unsigned FunctionId, unsigned FileNo,
                                       unsigned Line, unsigned Column,
                                       bool PrologueEnd, bool IsStmt,
                                       StringRef FileName, SMLoc Loc) {
  // Validate the directive.
  if (!checkCVLocSection(FunctionId, FileNo, Loc))
    return;

  OS << "\t.cv_loc\t" << FunctionId << " " << FileNo << " " << Line << " "
     << Column;
  if (PrologueEnd)
    OS << " prologue_end";

  if (IsStmt)
    OS << " is_stmt 1";

  if (IsVerboseAsm) {
    OS.PadToColumn(MAI->getCommentColumn());
    OS << MAI->getCommentString() << ' ' << FileName << ':' << Line << ':'
       << Column;
  }
  EmitEOL();
}

void MCAsmStreamer::emitCVLinetableDirective(unsigned FunctionId,
                                             const MCSymbol *FnStart,
                                             const MCSymbol *FnEnd) {
  OS << "\t.cv_linetable\t" << FunctionId << ", ";
  FnStart->print(OS, MAI);
  OS << ", ";
  FnEnd->print(OS, MAI);
  EmitEOL();
  this->MCStreamer::emitCVLinetableDirective(FunctionId, FnStart, FnEnd);
}

void MCAsmStreamer::emitCVInlineLinetableDirective(unsigned PrimaryFunctionId,
                                                   unsigned SourceFileId,
                                                   unsigned SourceLineNum,
                                                   const MCSymbol *FnStartSym,
                                                   const MCSymbol *FnEndSym) {
  OS << "\t.cv_inline_linetable\t" << PrimaryFunctionId << ' ' << SourceFileId
     << ' ' << SourceLineNum << ' ';
  FnStartSym->print(OS, MAI);
  OS << ' ';
  FnEndSym->print(OS, MAI);
  EmitEOL();
  this->MCStreamer::emitCVInlineLinetableDirective(
      PrimaryFunctionId, SourceFileId, SourceLineNum, FnStartSym, FnEndSym);
}

void MCAsmStreamer::PrintCVDefRangePrefix(
    ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges) {
  OS << "\t.cv_def_range\t";
  for (std::pair<const MCSymbol *, const MCSymbol *> Range : Ranges) {
    OS << ' ';
    Range.first->print(OS, MAI);
    OS << ' ';
    Range.second->print(OS, MAI);
  }
}

void MCAsmStreamer::emitCVDefRangeDirective(
    ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
    codeview::DefRangeRegisterRelHeader DRHdr) {
  PrintCVDefRangePrefix(Ranges);
  OS << ", reg_rel, ";
  OS << DRHdr.Register << ", " << DRHdr.Flags << ", "
     << DRHdr.BasePointerOffset;
  EmitEOL();
}

void MCAsmStreamer::emitCVDefRangeDirective(
    ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
    codeview::DefRangeSubfieldRegisterHeader DRHdr) {
  PrintCVDefRangePrefix(Ranges);
  OS << ", subfield_reg, ";
  OS << DRHdr.Register << ", " << DRHdr.OffsetInParent;
  EmitEOL();
}

void MCAsmStreamer::emitCVDefRangeDirective(
    ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
    codeview::DefRangeRegisterHeader DRHdr) {
  PrintCVDefRangePrefix(Ranges);
  OS << ", reg, ";
  OS << DRHdr.Register;
  EmitEOL();
}

void MCAsmStreamer::emitCVDefRangeDirective(
    ArrayRef<std::pair<const MCSymbol *, const MCSymbol *>> Ranges,
    codeview::DefRangeFramePointerRelHeader DRHdr) {
  PrintCVDefRangePrefix(Ranges);
  OS << ", frame_ptr_rel, ";
  OS << DRHdr.Offset;
  EmitEOL();
}

void MCAsmStreamer::emitCVStringTableDirective() {
  OS << "\t.cv_stringtable";
  EmitEOL();
}

void MCAsmStreamer::emitCVFileChecksumsDirective() {
  OS << "\t.cv_filechecksums";
  EmitEOL();
}

void MCAsmStreamer::emitCVFileChecksumOffsetDirective(unsigned FileNo) {
  OS << "\t.cv_filechecksumoffset\t" << FileNo;
  EmitEOL();
}

void MCAsmStreamer::EmitCVFPOData(const MCSymbol *ProcSym, SMLoc L) {
  OS << "\t.cv_fpo_data\t";
  ProcSym->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitIdent(StringRef IdentString) {
  assert(MAI->hasIdentDirective() && ".ident directive not supported");
  OS << "\t.ident\t";
  PrintQuotedString(IdentString, OS);
  EmitEOL();
}

void MCAsmStreamer::emitCFISections(bool EH, bool Debug) {
  MCStreamer::emitCFISections(EH, Debug);
  OS << "\t.cfi_sections ";
  if (EH) {
    OS << ".eh_frame";
    if (Debug)
      OS << ", .debug_frame";
  } else if (Debug) {
    OS << ".debug_frame";
  }

  EmitEOL();
}

void MCAsmStreamer::emitCFIStartProcImpl(MCDwarfFrameInfo &Frame) {
  OS << "\t.cfi_startproc";
  if (Frame.IsSimple)
    OS << " simple";
  EmitEOL();
}

void MCAsmStreamer::emitCFIEndProcImpl(MCDwarfFrameInfo &Frame) {
  MCStreamer::emitCFIEndProcImpl(Frame);
  OS << "\t.cfi_endproc";
  EmitEOL();
}

void MCAsmStreamer::EmitRegisterName(int64_t Register) {
  if (!MAI->useDwarfRegNumForCFI()) {
    // User .cfi_* directives can use arbitrary DWARF register numbers, not
    // just ones that map to LLVM register numbers and have known names.
    // Fall back to using the original number directly if no name is known.
    const MCRegisterInfo *MRI = getContext().getRegisterInfo();
    if (Optional<unsigned> LLVMRegister = MRI->getLLVMRegNum(Register, true)) {
      InstPrinter->printRegName(OS, *LLVMRegister);
      return;
    }
  }
  OS << Register;
}

void MCAsmStreamer::emitCFIDefCfa(int64_t Register, int64_t Offset) {
  MCStreamer::emitCFIDefCfa(Register, Offset);
  OS << "\t.cfi_def_cfa ";
  EmitRegisterName(Register);
  OS << ", " << Offset;
  EmitEOL();
}

void MCAsmStreamer::emitCFIDefCfaOffset(int64_t Offset) {
  MCStreamer::emitCFIDefCfaOffset(Offset);
  OS << "\t.cfi_def_cfa_offset " << Offset;
  EmitEOL();
}

static void PrintCFIEscape(llvm::formatted_raw_ostream &OS, StringRef Values) {
  OS << "\t.cfi_escape ";
  if (!Values.empty()) {
    size_t e = Values.size() - 1;
    for (size_t i = 0; i < e; ++i)
      OS << format("0x%02x", uint8_t(Values[i])) << ", ";
    OS << format("0x%02x", uint8_t(Values[e]));
  }
}

void MCAsmStreamer::emitCFIEscape(StringRef Values) {
  MCStreamer::emitCFIEscape(Values);
  PrintCFIEscape(OS, Values);
  EmitEOL();
}

void MCAsmStreamer::emitCFIGnuArgsSize(int64_t Size) {
  MCStreamer::emitCFIGnuArgsSize(Size);

  uint8_t Buffer[16] = { dwarf::DW_CFA_GNU_args_size };
  unsigned Len = encodeULEB128(Size, Buffer + 1) + 1;

  PrintCFIEscape(OS, StringRef((const char *)&Buffer[0], Len));
  EmitEOL();
}

void MCAsmStreamer::emitCFIDefCfaRegister(int64_t Register) {
  MCStreamer::emitCFIDefCfaRegister(Register);
  OS << "\t.cfi_def_cfa_register ";
  EmitRegisterName(Register);
  EmitEOL();
}

void MCAsmStreamer::emitCFIOffset(int64_t Register, int64_t Offset) {
  this->MCStreamer::emitCFIOffset(Register, Offset);
  OS << "\t.cfi_offset ";
  EmitRegisterName(Register);
  OS << ", " << Offset;
  EmitEOL();
}

void MCAsmStreamer::emitCFIPersonality(const MCSymbol *Sym,
                                       unsigned Encoding) {
  MCStreamer::emitCFIPersonality(Sym, Encoding);
  OS << "\t.cfi_personality " << Encoding << ", ";
  Sym->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitCFILsda(const MCSymbol *Sym, unsigned Encoding) {
  MCStreamer::emitCFILsda(Sym, Encoding);
  OS << "\t.cfi_lsda " << Encoding << ", ";
  Sym->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::emitCFIRememberState() {
  MCStreamer::emitCFIRememberState();
  OS << "\t.cfi_remember_state";
  EmitEOL();
}

void MCAsmStreamer::emitCFIRestoreState() {
  MCStreamer::emitCFIRestoreState();
  OS << "\t.cfi_restore_state";
  EmitEOL();
}

void MCAsmStreamer::emitCFIRestore(int64_t Register) {
  MCStreamer::emitCFIRestore(Register);
  OS << "\t.cfi_restore ";
  EmitRegisterName(Register);
  EmitEOL();
}

void MCAsmStreamer::emitCFISameValue(int64_t Register) {
  MCStreamer::emitCFISameValue(Register);
  OS << "\t.cfi_same_value ";
  EmitRegisterName(Register);
  EmitEOL();
}

void MCAsmStreamer::emitCFIRelOffset(int64_t Register, int64_t Offset) {
  MCStreamer::emitCFIRelOffset(Register, Offset);
  OS << "\t.cfi_rel_offset ";
  EmitRegisterName(Register);
  OS << ", " << Offset;
  EmitEOL();
}

void MCAsmStreamer::emitCFIAdjustCfaOffset(int64_t Adjustment) {
  MCStreamer::emitCFIAdjustCfaOffset(Adjustment);
  OS << "\t.cfi_adjust_cfa_offset " << Adjustment;
  EmitEOL();
}

void MCAsmStreamer::emitCFISignalFrame() {
  MCStreamer::emitCFISignalFrame();
  OS << "\t.cfi_signal_frame";
  EmitEOL();
}

void MCAsmStreamer::emitCFIUndefined(int64_t Register) {
  MCStreamer::emitCFIUndefined(Register);
  OS << "\t.cfi_undefined ";
  EmitRegisterName(Register);
  EmitEOL();
}

void MCAsmStreamer::emitCFIRegister(int64_t Register1, int64_t Register2) {
  MCStreamer::emitCFIRegister(Register1, Register2);
  OS << "\t.cfi_register ";
  EmitRegisterName(Register1);
  OS << ", ";
  EmitRegisterName(Register2);
  EmitEOL();
}

void MCAsmStreamer::emitCFIWindowSave() {
  MCStreamer::emitCFIWindowSave();
  OS << "\t.cfi_window_save";
  EmitEOL();
}

void MCAsmStreamer::emitCFINegateRAState() {
  MCStreamer::emitCFINegateRAState();
  OS << "\t.cfi_negate_ra_state";
  EmitEOL();
}

void MCAsmStreamer::emitCFIReturnColumn(int64_t Register) {
  MCStreamer::emitCFIReturnColumn(Register);
  OS << "\t.cfi_return_column ";
  EmitRegisterName(Register);
  EmitEOL();
}

void MCAsmStreamer::emitCFIBKeyFrame() {
  MCStreamer::emitCFIBKeyFrame();
  OS << "\t.cfi_b_key_frame";
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIStartProc(const MCSymbol *Symbol, SMLoc Loc) {
  MCStreamer::EmitWinCFIStartProc(Symbol, Loc);

  OS << ".seh_proc ";
  Symbol->print(OS, MAI);
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIEndProc(SMLoc Loc) {
  MCStreamer::EmitWinCFIEndProc(Loc);

  OS << "\t.seh_endproc";
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIFuncletOrFuncEnd(SMLoc Loc) {
  MCStreamer::EmitWinCFIFuncletOrFuncEnd(Loc);

  OS << "\t.seh_endfunclet";
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIStartChained(SMLoc Loc) {
  MCStreamer::EmitWinCFIStartChained(Loc);

  OS << "\t.seh_startchained";
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIEndChained(SMLoc Loc) {
  MCStreamer::EmitWinCFIEndChained(Loc);

  OS << "\t.seh_endchained";
  EmitEOL();
}

void MCAsmStreamer::EmitWinEHHandler(const MCSymbol *Sym, bool Unwind,
                                     bool Except, SMLoc Loc) {
  MCStreamer::EmitWinEHHandler(Sym, Unwind, Except, Loc);

  OS << "\t.seh_handler ";
  Sym->print(OS, MAI);
  if (Unwind)
    OS << ", @unwind";
  if (Except)
    OS << ", @except";
  EmitEOL();
}

void MCAsmStreamer::EmitWinEHHandlerData(SMLoc Loc) {
  MCStreamer::EmitWinEHHandlerData(Loc);

  // Switch sections. Don't call SwitchSection directly, because that will
  // cause the section switch to be visible in the emitted assembly.
  // We only do this so the section switch that terminates the handler
  // data block is visible.
  WinEH::FrameInfo *CurFrame = getCurrentWinFrameInfo();

  // Do nothing if no frame is open. MCStreamer should've already reported an
  // error.
  if (!CurFrame)
    return;

  MCSection *TextSec = &CurFrame->Function->getSection();
  MCSection *XData = getAssociatedXDataSection(TextSec);
  SwitchSectionNoChange(XData);

  OS << "\t.seh_handlerdata";
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIPushReg(MCRegister Register, SMLoc Loc) {
  MCStreamer::EmitWinCFIPushReg(Register, Loc);

  OS << "\t.seh_pushreg ";
  InstPrinter->printRegName(OS, Register);
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFISetFrame(MCRegister Register, unsigned Offset,
                                       SMLoc Loc) {
  MCStreamer::EmitWinCFISetFrame(Register, Offset, Loc);

  OS << "\t.seh_setframe ";
  InstPrinter->printRegName(OS, Register);
  OS << ", " << Offset;
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIAllocStack(unsigned Size, SMLoc Loc) {
  MCStreamer::EmitWinCFIAllocStack(Size, Loc);

  OS << "\t.seh_stackalloc " << Size;
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFISaveReg(MCRegister Register, unsigned Offset,
                                      SMLoc Loc) {
  MCStreamer::EmitWinCFISaveReg(Register, Offset, Loc);

  OS << "\t.seh_savereg ";
  InstPrinter->printRegName(OS, Register);
  OS << ", " << Offset;
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFISaveXMM(MCRegister Register, unsigned Offset,
                                      SMLoc Loc) {
  MCStreamer::EmitWinCFISaveXMM(Register, Offset, Loc);

  OS << "\t.seh_savexmm ";
  InstPrinter->printRegName(OS, Register);
  OS << ", " << Offset;
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIPushFrame(bool Code, SMLoc Loc) {
  MCStreamer::EmitWinCFIPushFrame(Code, Loc);

  OS << "\t.seh_pushframe";
  if (Code)
    OS << " @code";
  EmitEOL();
}

void MCAsmStreamer::EmitWinCFIEndProlog(SMLoc Loc) {
  MCStreamer::EmitWinCFIEndProlog(Loc);

  OS << "\t.seh_endprologue";
  EmitEOL();
}

void MCAsmStreamer::emitCGProfileEntry(const MCSymbolRefExpr *From,
                                       const MCSymbolRefExpr *To,
                                       uint64_t Count) {
  OS << "\t.cg_profile ";
  From->getSymbol().print(OS, MAI);
  OS << ", ";
  To->getSymbol().print(OS, MAI);
  OS << ", " << Count;
  EmitEOL();
}

void MCAsmStreamer::AddEncodingComment(const MCInst &Inst,
                                       const MCSubtargetInfo &STI) {
  raw_ostream &OS = GetCommentOS();
  SmallString<256> Code;
  SmallVector<MCFixup, 4> Fixups;
  raw_svector_ostream VecOS(Code);

  // If we have no code emitter, don't emit code.
  if (!getAssembler().getEmitterPtr())
    return;

  getAssembler().getEmitter().encodeInstruction(Inst, VecOS, Fixups, STI);

  // If we are showing fixups, create symbolic markers in the encoded
  // representation. We do this by making a per-bit map to the fixup item index,
  // then trying to display it as nicely as possible.
  SmallVector<uint8_t, 64> FixupMap;
  FixupMap.resize(Code.size() * 8);
  for (unsigned i = 0, e = Code.size() * 8; i != e; ++i)
    FixupMap[i] = 0;

  for (unsigned i = 0, e = Fixups.size(); i != e; ++i) {
    MCFixup &F = Fixups[i];
    const MCFixupKindInfo &Info =
        getAssembler().getBackend().getFixupKindInfo(F.getKind());
    for (unsigned j = 0; j != Info.TargetSize; ++j) {
      unsigned Index = F.getOffset() * 8 + Info.TargetOffset + j;
      assert(Index < Code.size() * 8 && "Invalid offset in fixup!");
      FixupMap[Index] = 1 + i;
    }
  }

  // FIXME: Note the fixup comments for Thumb2 are completely bogus since the
  // high order halfword of a 32-bit Thumb2 instruction is emitted first.
  OS << "encoding: [";
  for (unsigned i = 0, e = Code.size(); i != e; ++i) {
    if (i)
      OS << ',';

    // See if all bits are the same map entry.
    uint8_t MapEntry = FixupMap[i * 8 + 0];
    for (unsigned j = 1; j != 8; ++j) {
      if (FixupMap[i * 8 + j] == MapEntry)
        continue;

      MapEntry = uint8_t(~0U);
      break;
    }

    if (MapEntry != uint8_t(~0U)) {
      if (MapEntry == 0) {
        OS << format("0x%02x", uint8_t(Code[i]));
      } else {
        if (Code[i]) {
          // FIXME: Some of the 8 bits require fix up.
          OS << format("0x%02x", uint8_t(Code[i])) << '\''
             << char('A' + MapEntry - 1) << '\'';
        } else
          OS << char('A' + MapEntry - 1);
      }
    } else {
      // Otherwise, write out in binary.
      OS << "0b";
      for (unsigned j = 8; j--;) {
        unsigned Bit = (Code[i] >> j) & 1;

        unsigned FixupBit;
        if (MAI->isLittleEndian())
          FixupBit = i * 8 + j;
        else
          FixupBit = i * 8 + (7-j);

        if (uint8_t MapEntry = FixupMap[FixupBit]) {
          assert(Bit == 0 && "Encoder wrote into fixed up bit!");
          OS << char('A' + MapEntry - 1);
        } else
          OS << Bit;
      }
    }
  }
  OS << "]\n";

  for (unsigned i = 0, e = Fixups.size(); i != e; ++i) {
    MCFixup &F = Fixups[i];
    const MCFixupKindInfo &Info =
        getAssembler().getBackend().getFixupKindInfo(F.getKind());
    OS << "  fixup " << char('A' + i) << " - " << "offset: " << F.getOffset()
       << ", value: " << *F.getValue() << ", kind: " << Info.Name << "\n";
  }
}

void MCAsmStreamer::emitInstruction(const MCInst &Inst,
                                    const MCSubtargetInfo &STI) {
  assert(getCurrentSectionOnly() &&
         "Cannot emit contents before setting section!");

  // Show the encoding in a comment if we have a code emitter.
  AddEncodingComment(Inst, STI);

  // Show the MCInst if enabled.
  if (ShowInst) {
    Inst.dump_pretty(GetCommentOS(), InstPrinter.get(), "\n ");
    GetCommentOS() << "\n";
  }

  if(getTargetStreamer())
    getTargetStreamer()->prettyPrintAsm(*InstPrinter, 0, Inst, STI, OS);
  else
    InstPrinter->printInst(&Inst, 0, "", STI, OS);

  StringRef Comments = CommentToEmit;
  if (Comments.size() && Comments.back() != '\n')
    GetCommentOS() << "\n";

  EmitEOL();
}

void MCAsmStreamer::emitBundleAlignMode(unsigned AlignPow2) {
  OS << "\t.bundle_align_mode " << AlignPow2;
  EmitEOL();
}

void MCAsmStreamer::emitBundleLock(bool AlignToEnd) {
  OS << "\t.bundle_lock";
  if (AlignToEnd)
    OS << " align_to_end";
  EmitEOL();
}

void MCAsmStreamer::emitBundleUnlock() {
  OS << "\t.bundle_unlock";
  EmitEOL();
}

Optional<std::pair<bool, std::string>>
MCAsmStreamer::emitRelocDirective(const MCExpr &Offset, StringRef Name,
                                  const MCExpr *Expr, SMLoc,
                                  const MCSubtargetInfo &STI) {
  OS << "\t.reloc ";
  Offset.print(OS, MAI);
  OS << ", " << Name;
  if (Expr) {
    OS << ", ";
    Expr->print(OS, MAI);
  }
  EmitEOL();
  return None;
}

void MCAsmStreamer::emitAddrsig() {
  OS << "\t.addrsig";
  EmitEOL();
}

void MCAsmStreamer::emitAddrsigSym(const MCSymbol *Sym) {
  OS << "\t.addrsig_sym ";
  Sym->print(OS, MAI);
  EmitEOL();
}

/// EmitRawText - If this file is backed by an assembly streamer, this dumps
/// the specified string in the output .s file.  This capability is
/// indicated by the hasRawTextSupport() predicate.
void MCAsmStreamer::emitRawTextImpl(StringRef String) {
  if (!String.empty() && String.back() == '\n')
    String = String.substr(0, String.size()-1);
  OS << String;
  EmitEOL();
}

void MCAsmStreamer::finishImpl() {
  // If we are generating dwarf for assembly source files dump out the sections.
  if (getContext().getGenDwarfForAssembly())
    MCGenDwarfInfo::Emit(this);

  // Emit the label for the line table, if requested - since the rest of the
  // line table will be defined by .loc/.file directives, and not emitted
  // directly, the label is the only work required here.
  const auto &Tables = getContext().getMCDwarfLineTables();
  if (!Tables.empty()) {
    assert(Tables.size() == 1 && "asm output only supports one line table");
    if (auto *Label = Tables.begin()->second.getLabel()) {
      SwitchSection(getContext().getObjectFileInfo()->getDwarfLineSection());
      emitLabel(Label);
    }
  }
}

MCStreamer *llvm::createAsmStreamer(MCContext &Context,
                                    std::unique_ptr<formatted_raw_ostream> OS,
                                    bool isVerboseAsm, bool useDwarfDirectory,
                                    MCInstPrinter *IP,
                                    std::unique_ptr<MCCodeEmitter> &&CE,
                                    std::unique_ptr<MCAsmBackend> &&MAB,
                                    bool ShowInst) {
  return new MCAsmStreamer(Context, std::move(OS), isVerboseAsm,
                           useDwarfDirectory, IP, std::move(CE), std::move(MAB),
                           ShowInst);
}
