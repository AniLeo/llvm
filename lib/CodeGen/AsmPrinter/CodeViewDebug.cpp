//===-- llvm/lib/CodeGen/AsmPrinter/CodeViewDebug.cpp --*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains support for writing Microsoft CodeView debug info.
//
//===----------------------------------------------------------------------===//

#include "CodeViewDebug.h"
#include "llvm/ADT/TinyPtrVector.h"
#include "llvm/DebugInfo/CodeView/CodeView.h"
#include "llvm/DebugInfo/CodeView/FieldListRecordBuilder.h"
#include "llvm/DebugInfo/CodeView/Line.h"
#include "llvm/DebugInfo/CodeView/SymbolRecord.h"
#include "llvm/DebugInfo/CodeView/TypeDumper.h"
#include "llvm/DebugInfo/CodeView/TypeIndex.h"
#include "llvm/DebugInfo/CodeView/TypeRecord.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCSectionCOFF.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/COFF.h"
#include "llvm/Support/ScopedPrinter.h"
#include "llvm/Target/TargetFrameLowering.h"
#include "llvm/Target/TargetRegisterInfo.h"
#include "llvm/Target/TargetSubtargetInfo.h"

using namespace llvm;
using namespace llvm::codeview;

CodeViewDebug::CodeViewDebug(AsmPrinter *AP)
    : DebugHandlerBase(AP), OS(*Asm->OutStreamer), CurFn(nullptr) {
  // If module doesn't have named metadata anchors or COFF debug section
  // is not available, skip any debug info related stuff.
  if (!MMI->getModule()->getNamedMetadata("llvm.dbg.cu") ||
      !AP->getObjFileLowering().getCOFFDebugSymbolsSection()) {
    Asm = nullptr;
    return;
  }

  // Tell MMI that we have debug info.
  MMI->setDebugInfoAvailability(true);
}

StringRef CodeViewDebug::getFullFilepath(const DIFile *File) {
  std::string &Filepath = FileToFilepathMap[File];
  if (!Filepath.empty())
    return Filepath;

  StringRef Dir = File->getDirectory(), Filename = File->getFilename();

  // Clang emits directory and relative filename info into the IR, but CodeView
  // operates on full paths.  We could change Clang to emit full paths too, but
  // that would increase the IR size and probably not needed for other users.
  // For now, just concatenate and canonicalize the path here.
  if (Filename.find(':') == 1)
    Filepath = Filename;
  else
    Filepath = (Dir + "\\" + Filename).str();

  // Canonicalize the path.  We have to do it textually because we may no longer
  // have access the file in the filesystem.
  // First, replace all slashes with backslashes.
  std::replace(Filepath.begin(), Filepath.end(), '/', '\\');

  // Remove all "\.\" with "\".
  size_t Cursor = 0;
  while ((Cursor = Filepath.find("\\.\\", Cursor)) != std::string::npos)
    Filepath.erase(Cursor, 2);

  // Replace all "\XXX\..\" with "\".  Don't try too hard though as the original
  // path should be well-formatted, e.g. start with a drive letter, etc.
  Cursor = 0;
  while ((Cursor = Filepath.find("\\..\\", Cursor)) != std::string::npos) {
    // Something's wrong if the path starts with "\..\", abort.
    if (Cursor == 0)
      break;

    size_t PrevSlash = Filepath.rfind('\\', Cursor - 1);
    if (PrevSlash == std::string::npos)
      // Something's wrong, abort.
      break;

    Filepath.erase(PrevSlash, Cursor + 3 - PrevSlash);
    // The next ".." might be following the one we've just erased.
    Cursor = PrevSlash;
  }

  // Remove all duplicate backslashes.
  Cursor = 0;
  while ((Cursor = Filepath.find("\\\\", Cursor)) != std::string::npos)
    Filepath.erase(Cursor, 1);

  return Filepath;
}

unsigned CodeViewDebug::maybeRecordFile(const DIFile *F) {
  unsigned NextId = FileIdMap.size() + 1;
  auto Insertion = FileIdMap.insert(std::make_pair(F, NextId));
  if (Insertion.second) {
    // We have to compute the full filepath and emit a .cv_file directive.
    StringRef FullPath = getFullFilepath(F);
    NextId = OS.EmitCVFileDirective(NextId, FullPath);
    assert(NextId == FileIdMap.size() && ".cv_file directive failed");
  }
  return Insertion.first->second;
}

CodeViewDebug::InlineSite &
CodeViewDebug::getInlineSite(const DILocation *InlinedAt,
                             const DISubprogram *Inlinee) {
  auto SiteInsertion = CurFn->InlineSites.insert({InlinedAt, InlineSite()});
  InlineSite *Site = &SiteInsertion.first->second;
  if (SiteInsertion.second) {
    Site->SiteFuncId = NextFuncId++;
    Site->Inlinee = Inlinee;
    InlinedSubprograms.insert(Inlinee);
    getFuncIdForSubprogram(Inlinee);
  }
  return *Site;
}

static const DISubprogram *getQualifiedNameComponents(
    const DIScope *Scope, SmallVectorImpl<StringRef> &QualifiedNameComponents) {
  const DISubprogram *ClosestSubprogram = nullptr;
  while (Scope != nullptr) {
    if (ClosestSubprogram == nullptr)
      ClosestSubprogram = dyn_cast<DISubprogram>(Scope);
    StringRef ScopeName = Scope->getName();
    if (!ScopeName.empty())
      QualifiedNameComponents.push_back(ScopeName);
    Scope = Scope->getScope().resolve();
  }
  return ClosestSubprogram;
}

static std::string getQualifiedName(ArrayRef<StringRef> QualifiedNameComponents,
                                    StringRef TypeName) {
  std::string FullyQualifiedName;
  for (StringRef QualifiedNameComponent : reverse(QualifiedNameComponents)) {
    FullyQualifiedName.append(QualifiedNameComponent);
    FullyQualifiedName.append("::");
  }
  FullyQualifiedName.append(TypeName);
  return FullyQualifiedName;
}

static std::string getFullyQualifiedName(const DIScope *Scope, StringRef Name) {
  SmallVector<StringRef, 5> QualifiedNameComponents;
  getQualifiedNameComponents(Scope, QualifiedNameComponents);
  return getQualifiedName(QualifiedNameComponents, Name);
}

TypeIndex CodeViewDebug::getScopeIndex(const DIScope *Scope) {
  // No scope means global scope and that uses the zero index.
  if (!Scope || isa<DIFile>(Scope))
    return TypeIndex();

  assert(!isa<DIType>(Scope) && "shouldn't make a namespace scope for a type");

  // Check if we've already translated this scope.
  auto I = TypeIndices.find({Scope, nullptr});
  if (I != TypeIndices.end())
    return I->second;

  // Build the fully qualified name of the scope.
  std::string ScopeName =
      getFullyQualifiedName(Scope->getScope().resolve(), Scope->getName());
  TypeIndex TI =
      TypeTable.writeStringId(StringIdRecord(TypeIndex(), ScopeName));
  return recordTypeIndexForDINode(Scope, TI);
}

TypeIndex CodeViewDebug::getFuncIdForSubprogram(const DISubprogram *SP) {
  // It's possible to ask for the FuncId of a function which doesn't have a
  // subprogram: inlining a function with debug info into a function with none.
  if (!SP)
    return TypeIndex::None();

  // Check if we've already translated this subprogram.
  auto I = TypeIndices.find({SP, nullptr});
  if (I != TypeIndices.end())
    return I->second;

  // The display name includes function template arguments. Drop them to match
  // MSVC.
  StringRef DisplayName = SP->getDisplayName().split('<').first;

  const DIScope *Scope = SP->getScope().resolve();
  TypeIndex TI;
  if (const auto *Class = dyn_cast_or_null<DICompositeType>(Scope)) {
    // If the scope is a DICompositeType, then this must be a method. Member
    // function types take some special handling, and require access to the
    // subprogram.
    TypeIndex ClassType = getTypeIndex(Class);
    MemberFuncIdRecord MFuncId(ClassType, getMemberFunctionType(SP, Class),
                               DisplayName);
    TI = TypeTable.writeMemberFuncId(MFuncId);
  } else {
    // Otherwise, this must be a free function.
    TypeIndex ParentScope = getScopeIndex(Scope);
    FuncIdRecord FuncId(ParentScope, getTypeIndex(SP->getType()), DisplayName);
    TI = TypeTable.writeFuncId(FuncId);
  }

  return recordTypeIndexForDINode(SP, TI);
}

TypeIndex CodeViewDebug::getMemberFunctionType(const DISubprogram *SP,
                                               const DICompositeType *Class) {
  // Key the MemberFunctionRecord into the map as {SP, Class}. It won't collide
  // with the MemberFuncIdRecord, which is keyed in as {SP, nullptr}.
  auto I = TypeIndices.find({SP, nullptr});
  if (I != TypeIndices.end())
    return I->second;

  // FIXME: Get the ThisAdjustment off of SP when it is available.
  TypeIndex TI =
      lowerTypeMemberFunction(SP->getType(), Class, /*ThisAdjustment=*/0);

  return recordTypeIndexForDINode(SP, TI, Class);
}

TypeIndex CodeViewDebug::recordTypeIndexForDINode(const DINode *Node, TypeIndex TI,
                                             const DIType *ClassTy) {
  auto InsertResult = TypeIndices.insert({{Node, ClassTy}, TI});
  (void)InsertResult;
  assert(InsertResult.second && "DINode was already assigned a type index");
  return TI;
}

unsigned CodeViewDebug::getPointerSizeInBytes() {
  return MMI->getModule()->getDataLayout().getPointerSizeInBits() / 8;
}

void CodeViewDebug::recordLocalVariable(LocalVariable &&Var,
                                        const DILocation *InlinedAt) {
  if (InlinedAt) {
    // This variable was inlined. Associate it with the InlineSite.
    const DISubprogram *Inlinee = Var.DIVar->getScope()->getSubprogram();
    InlineSite &Site = getInlineSite(InlinedAt, Inlinee);
    Site.InlinedLocals.emplace_back(Var);
  } else {
    // This variable goes in the main ProcSym.
    CurFn->Locals.emplace_back(Var);
  }
}

static void addLocIfNotPresent(SmallVectorImpl<const DILocation *> &Locs,
                               const DILocation *Loc) {
  auto B = Locs.begin(), E = Locs.end();
  if (std::find(B, E, Loc) == E)
    Locs.push_back(Loc);
}

void CodeViewDebug::maybeRecordLocation(const DebugLoc &DL,
                                        const MachineFunction *MF) {
  // Skip this instruction if it has the same location as the previous one.
  if (DL == CurFn->LastLoc)
    return;

  const DIScope *Scope = DL.get()->getScope();
  if (!Scope)
    return;

  // Skip this line if it is longer than the maximum we can record.
  LineInfo LI(DL.getLine(), DL.getLine(), /*IsStatement=*/true);
  if (LI.getStartLine() != DL.getLine() || LI.isAlwaysStepInto() ||
      LI.isNeverStepInto())
    return;

  ColumnInfo CI(DL.getCol(), /*EndColumn=*/0);
  if (CI.getStartColumn() != DL.getCol())
    return;

  if (!CurFn->HaveLineInfo)
    CurFn->HaveLineInfo = true;
  unsigned FileId = 0;
  if (CurFn->LastLoc.get() && CurFn->LastLoc->getFile() == DL->getFile())
    FileId = CurFn->LastFileId;
  else
    FileId = CurFn->LastFileId = maybeRecordFile(DL->getFile());
  CurFn->LastLoc = DL;

  unsigned FuncId = CurFn->FuncId;
  if (const DILocation *SiteLoc = DL->getInlinedAt()) {
    const DILocation *Loc = DL.get();

    // If this location was actually inlined from somewhere else, give it the ID
    // of the inline call site.
    FuncId =
        getInlineSite(SiteLoc, Loc->getScope()->getSubprogram()).SiteFuncId;

    // Ensure we have links in the tree of inline call sites.
    bool FirstLoc = true;
    while ((SiteLoc = Loc->getInlinedAt())) {
      InlineSite &Site =
          getInlineSite(SiteLoc, Loc->getScope()->getSubprogram());
      if (!FirstLoc)
        addLocIfNotPresent(Site.ChildSites, Loc);
      FirstLoc = false;
      Loc = SiteLoc;
    }
    addLocIfNotPresent(CurFn->ChildSites, Loc);
  }

  OS.EmitCVLocDirective(FuncId, FileId, DL.getLine(), DL.getCol(),
                        /*PrologueEnd=*/false,
                        /*IsStmt=*/false, DL->getFilename());
}

void CodeViewDebug::emitCodeViewMagicVersion() {
  OS.EmitValueToAlignment(4);
  OS.AddComment("Debug section magic");
  OS.EmitIntValue(COFF::DEBUG_SECTION_MAGIC, 4);
}

void CodeViewDebug::endModule() {
  if (!Asm || !MMI->hasDebugInfo())
    return;

  assert(Asm != nullptr);

  // The COFF .debug$S section consists of several subsections, each starting
  // with a 4-byte control code (e.g. 0xF1, 0xF2, etc) and then a 4-byte length
  // of the payload followed by the payload itself.  The subsections are 4-byte
  // aligned.

  // Use the generic .debug$S section, and make a subsection for all the inlined
  // subprograms.
  switchToDebugSectionForSymbol(nullptr);
  emitInlineeLinesSubsection();

  // Emit per-function debug information.
  for (auto &P : FnDebugInfo)
    if (!P.first->isDeclarationForLinker())
      emitDebugInfoForFunction(P.first, P.second);

  // Emit global variable debug information.
  setCurrentSubprogram(nullptr);
  emitDebugInfoForGlobals();

  // Emit retained types.
  emitDebugInfoForRetainedTypes();

  // Switch back to the generic .debug$S section after potentially processing
  // comdat symbol sections.
  switchToDebugSectionForSymbol(nullptr);

  // Emit UDT records for any types used by global variables.
  if (!GlobalUDTs.empty()) {
    MCSymbol *SymbolsEnd = beginCVSubsection(ModuleSubstreamKind::Symbols);
    emitDebugInfoForUDTs(GlobalUDTs);
    endCVSubsection(SymbolsEnd);
  }

  // This subsection holds a file index to offset in string table table.
  OS.AddComment("File index to string table offset subsection");
  OS.EmitCVFileChecksumsDirective();

  // This subsection holds the string table.
  OS.AddComment("String table");
  OS.EmitCVStringTableDirective();

  // Emit type information last, so that any types we translate while emitting
  // function info are included.
  emitTypeInformation();

  clear();
}

static void emitNullTerminatedSymbolName(MCStreamer &OS, StringRef S) {
  // Microsoft's linker seems to have trouble with symbol names longer than
  // 0xffd8 bytes.
  S = S.substr(0, 0xffd8);
  SmallString<32> NullTerminatedString(S);
  NullTerminatedString.push_back('\0');
  OS.EmitBytes(NullTerminatedString);
}

void CodeViewDebug::emitTypeInformation() {
  // Do nothing if we have no debug info or if no non-trivial types were emitted
  // to TypeTable during codegen.
  NamedMDNode *CU_Nodes = MMI->getModule()->getNamedMetadata("llvm.dbg.cu");
  if (!CU_Nodes)
    return;
  if (TypeTable.empty())
    return;

  // Start the .debug$T section with 0x4.
  OS.SwitchSection(Asm->getObjFileLowering().getCOFFDebugTypesSection());
  emitCodeViewMagicVersion();

  SmallString<8> CommentPrefix;
  if (OS.isVerboseAsm()) {
    CommentPrefix += '\t';
    CommentPrefix += Asm->MAI->getCommentString();
    CommentPrefix += ' ';
  }

  CVTypeDumper CVTD(nullptr, /*PrintRecordBytes=*/false);
  TypeTable.ForEachRecord(
      [&](TypeIndex Index, StringRef Record) {
        if (OS.isVerboseAsm()) {
          // Emit a block comment describing the type record for readability.
          SmallString<512> CommentBlock;
          raw_svector_ostream CommentOS(CommentBlock);
          ScopedPrinter SP(CommentOS);
          SP.setPrefix(CommentPrefix);
          CVTD.setPrinter(&SP);
          Error EC = CVTD.dump({Record.bytes_begin(), Record.bytes_end()});
          assert(!EC && "produced malformed type record");
          consumeError(std::move(EC));
          // emitRawComment will insert its own tab and comment string before
          // the first line, so strip off our first one. It also prints its own
          // newline.
          OS.emitRawComment(
              CommentOS.str().drop_front(CommentPrefix.size() - 1).rtrim());
        }
        OS.EmitBinaryData(Record);
      });
}

void CodeViewDebug::emitInlineeLinesSubsection() {
  if (InlinedSubprograms.empty())
    return;

  OS.AddComment("Inlinee lines subsection");
  MCSymbol *InlineEnd = beginCVSubsection(ModuleSubstreamKind::InlineeLines);

  // We don't provide any extra file info.
  // FIXME: Find out if debuggers use this info.
  OS.AddComment("Inlinee lines signature");
  OS.EmitIntValue(unsigned(InlineeLinesSignature::Normal), 4);

  for (const DISubprogram *SP : InlinedSubprograms) {
    assert(TypeIndices.count({SP, nullptr}));
    TypeIndex InlineeIdx = TypeIndices[{SP, nullptr}];

    OS.AddBlankLine();
    unsigned FileId = maybeRecordFile(SP->getFile());
    OS.AddComment("Inlined function " + SP->getDisplayName() + " starts at " +
                  SP->getFilename() + Twine(':') + Twine(SP->getLine()));
    OS.AddBlankLine();
    // The filechecksum table uses 8 byte entries for now, and file ids start at
    // 1.
    unsigned FileOffset = (FileId - 1) * 8;
    OS.AddComment("Type index of inlined function");
    OS.EmitIntValue(InlineeIdx.getIndex(), 4);
    OS.AddComment("Offset into filechecksum table");
    OS.EmitIntValue(FileOffset, 4);
    OS.AddComment("Starting line number");
    OS.EmitIntValue(SP->getLine(), 4);
  }

  endCVSubsection(InlineEnd);
}

void CodeViewDebug::collectInlineSiteChildren(
    SmallVectorImpl<unsigned> &Children, const FunctionInfo &FI,
    const InlineSite &Site) {
  for (const DILocation *ChildSiteLoc : Site.ChildSites) {
    auto I = FI.InlineSites.find(ChildSiteLoc);
    const InlineSite &ChildSite = I->second;
    Children.push_back(ChildSite.SiteFuncId);
    collectInlineSiteChildren(Children, FI, ChildSite);
  }
}

void CodeViewDebug::emitInlinedCallSite(const FunctionInfo &FI,
                                        const DILocation *InlinedAt,
                                        const InlineSite &Site) {
  MCSymbol *InlineBegin = MMI->getContext().createTempSymbol(),
           *InlineEnd = MMI->getContext().createTempSymbol();

  assert(TypeIndices.count({Site.Inlinee, nullptr}));
  TypeIndex InlineeIdx = TypeIndices[{Site.Inlinee, nullptr}];

  // SymbolRecord
  OS.AddComment("Record length");
  OS.emitAbsoluteSymbolDiff(InlineEnd, InlineBegin, 2);   // RecordLength
  OS.EmitLabel(InlineBegin);
  OS.AddComment("Record kind: S_INLINESITE");
  OS.EmitIntValue(SymbolKind::S_INLINESITE, 2); // RecordKind

  OS.AddComment("PtrParent");
  OS.EmitIntValue(0, 4);
  OS.AddComment("PtrEnd");
  OS.EmitIntValue(0, 4);
  OS.AddComment("Inlinee type index");
  OS.EmitIntValue(InlineeIdx.getIndex(), 4);

  unsigned FileId = maybeRecordFile(Site.Inlinee->getFile());
  unsigned StartLineNum = Site.Inlinee->getLine();
  SmallVector<unsigned, 3> SecondaryFuncIds;
  collectInlineSiteChildren(SecondaryFuncIds, FI, Site);

  OS.EmitCVInlineLinetableDirective(Site.SiteFuncId, FileId, StartLineNum,
                                    FI.Begin, FI.End, SecondaryFuncIds);

  OS.EmitLabel(InlineEnd);

  for (const LocalVariable &Var : Site.InlinedLocals)
    emitLocalVariable(Var);

  // Recurse on child inlined call sites before closing the scope.
  for (const DILocation *ChildSite : Site.ChildSites) {
    auto I = FI.InlineSites.find(ChildSite);
    assert(I != FI.InlineSites.end() &&
           "child site not in function inline site map");
    emitInlinedCallSite(FI, ChildSite, I->second);
  }

  // Close the scope.
  OS.AddComment("Record length");
  OS.EmitIntValue(2, 2);                                  // RecordLength
  OS.AddComment("Record kind: S_INLINESITE_END");
  OS.EmitIntValue(SymbolKind::S_INLINESITE_END, 2); // RecordKind
}

void CodeViewDebug::switchToDebugSectionForSymbol(const MCSymbol *GVSym) {
  // If we have a symbol, it may be in a section that is COMDAT. If so, find the
  // comdat key. A section may be comdat because of -ffunction-sections or
  // because it is comdat in the IR.
  MCSectionCOFF *GVSec =
      GVSym ? dyn_cast<MCSectionCOFF>(&GVSym->getSection()) : nullptr;
  const MCSymbol *KeySym = GVSec ? GVSec->getCOMDATSymbol() : nullptr;

  MCSectionCOFF *DebugSec = cast<MCSectionCOFF>(
      Asm->getObjFileLowering().getCOFFDebugSymbolsSection());
  DebugSec = OS.getContext().getAssociativeCOFFSection(DebugSec, KeySym);

  OS.SwitchSection(DebugSec);

  // Emit the magic version number if this is the first time we've switched to
  // this section.
  if (ComdatDebugSections.insert(DebugSec).second)
    emitCodeViewMagicVersion();
}

void CodeViewDebug::emitDebugInfoForFunction(const Function *GV,
                                             FunctionInfo &FI) {
  // For each function there is a separate subsection
  // which holds the PC to file:line table.
  const MCSymbol *Fn = Asm->getSymbol(GV);
  assert(Fn);

  // Switch to the to a comdat section, if appropriate.
  switchToDebugSectionForSymbol(Fn);

  std::string FuncName;
  auto *SP = GV->getSubprogram();
  setCurrentSubprogram(SP);

  // If we have a display name, build the fully qualified name by walking the
  // chain of scopes.
  if (SP != nullptr && !SP->getDisplayName().empty())
    FuncName =
        getFullyQualifiedName(SP->getScope().resolve(), SP->getDisplayName());

  // If our DISubprogram name is empty, use the mangled name.
  if (FuncName.empty())
    FuncName = GlobalValue::getRealLinkageName(GV->getName());

  // Emit a symbol subsection, required by VS2012+ to find function boundaries.
  OS.AddComment("Symbol subsection for " + Twine(FuncName));
  MCSymbol *SymbolsEnd = beginCVSubsection(ModuleSubstreamKind::Symbols);
  {
    MCSymbol *ProcRecordBegin = MMI->getContext().createTempSymbol(),
             *ProcRecordEnd = MMI->getContext().createTempSymbol();
    OS.AddComment("Record length");
    OS.emitAbsoluteSymbolDiff(ProcRecordEnd, ProcRecordBegin, 2);
    OS.EmitLabel(ProcRecordBegin);

    OS.AddComment("Record kind: S_GPROC32_ID");
    OS.EmitIntValue(unsigned(SymbolKind::S_GPROC32_ID), 2);

    // These fields are filled in by tools like CVPACK which run after the fact.
    OS.AddComment("PtrParent");
    OS.EmitIntValue(0, 4);
    OS.AddComment("PtrEnd");
    OS.EmitIntValue(0, 4);
    OS.AddComment("PtrNext");
    OS.EmitIntValue(0, 4);
    // This is the important bit that tells the debugger where the function
    // code is located and what's its size:
    OS.AddComment("Code size");
    OS.emitAbsoluteSymbolDiff(FI.End, Fn, 4);
    OS.AddComment("Offset after prologue");
    OS.EmitIntValue(0, 4);
    OS.AddComment("Offset before epilogue");
    OS.EmitIntValue(0, 4);
    OS.AddComment("Function type index");
    OS.EmitIntValue(getFuncIdForSubprogram(GV->getSubprogram()).getIndex(), 4);
    OS.AddComment("Function section relative address");
    OS.EmitCOFFSecRel32(Fn);
    OS.AddComment("Function section index");
    OS.EmitCOFFSectionIndex(Fn);
    OS.AddComment("Flags");
    OS.EmitIntValue(0, 1);
    // Emit the function display name as a null-terminated string.
    OS.AddComment("Function name");
    // Truncate the name so we won't overflow the record length field.
    emitNullTerminatedSymbolName(OS, FuncName);
    OS.EmitLabel(ProcRecordEnd);

    for (const LocalVariable &Var : FI.Locals)
      emitLocalVariable(Var);

    // Emit inlined call site information. Only emit functions inlined directly
    // into the parent function. We'll emit the other sites recursively as part
    // of their parent inline site.
    for (const DILocation *InlinedAt : FI.ChildSites) {
      auto I = FI.InlineSites.find(InlinedAt);
      assert(I != FI.InlineSites.end() &&
             "child site not in function inline site map");
      emitInlinedCallSite(FI, InlinedAt, I->second);
    }

    if (SP != nullptr)
      emitDebugInfoForUDTs(LocalUDTs);

    // We're done with this function.
    OS.AddComment("Record length");
    OS.EmitIntValue(0x0002, 2);
    OS.AddComment("Record kind: S_PROC_ID_END");
    OS.EmitIntValue(unsigned(SymbolKind::S_PROC_ID_END), 2);
  }
  endCVSubsection(SymbolsEnd);

  // We have an assembler directive that takes care of the whole line table.
  OS.EmitCVLinetableDirective(FI.FuncId, Fn, FI.End);
}

CodeViewDebug::LocalVarDefRange
CodeViewDebug::createDefRangeMem(uint16_t CVRegister, int Offset) {
  LocalVarDefRange DR;
  DR.InMemory = -1;
  DR.DataOffset = Offset;
  assert(DR.DataOffset == Offset && "truncation");
  DR.StructOffset = 0;
  DR.CVRegister = CVRegister;
  return DR;
}

CodeViewDebug::LocalVarDefRange
CodeViewDebug::createDefRangeReg(uint16_t CVRegister) {
  LocalVarDefRange DR;
  DR.InMemory = 0;
  DR.DataOffset = 0;
  DR.StructOffset = 0;
  DR.CVRegister = CVRegister;
  return DR;
}

void CodeViewDebug::collectVariableInfoFromMMITable(
    DenseSet<InlinedVariable> &Processed) {
  const TargetSubtargetInfo &TSI = Asm->MF->getSubtarget();
  const TargetFrameLowering *TFI = TSI.getFrameLowering();
  const TargetRegisterInfo *TRI = TSI.getRegisterInfo();

  for (const MachineModuleInfo::VariableDbgInfo &VI :
       MMI->getVariableDbgInfo()) {
    if (!VI.Var)
      continue;
    assert(VI.Var->isValidLocationForIntrinsic(VI.Loc) &&
           "Expected inlined-at fields to agree");

    Processed.insert(InlinedVariable(VI.Var, VI.Loc->getInlinedAt()));
    LexicalScope *Scope = LScopes.findLexicalScope(VI.Loc);

    // If variable scope is not found then skip this variable.
    if (!Scope)
      continue;

    // Get the frame register used and the offset.
    unsigned FrameReg = 0;
    int FrameOffset = TFI->getFrameIndexReference(*Asm->MF, VI.Slot, FrameReg);
    uint16_t CVReg = TRI->getCodeViewRegNum(FrameReg);

    // Calculate the label ranges.
    LocalVarDefRange DefRange = createDefRangeMem(CVReg, FrameOffset);
    for (const InsnRange &Range : Scope->getRanges()) {
      const MCSymbol *Begin = getLabelBeforeInsn(Range.first);
      const MCSymbol *End = getLabelAfterInsn(Range.second);
      End = End ? End : Asm->getFunctionEnd();
      DefRange.Ranges.emplace_back(Begin, End);
    }

    LocalVariable Var;
    Var.DIVar = VI.Var;
    Var.DefRanges.emplace_back(std::move(DefRange));
    recordLocalVariable(std::move(Var), VI.Loc->getInlinedAt());
  }
}

void CodeViewDebug::collectVariableInfo(const DISubprogram *SP) {
  DenseSet<InlinedVariable> Processed;
  // Grab the variable info that was squirreled away in the MMI side-table.
  collectVariableInfoFromMMITable(Processed);

  const TargetRegisterInfo *TRI = Asm->MF->getSubtarget().getRegisterInfo();

  for (const auto &I : DbgValues) {
    InlinedVariable IV = I.first;
    if (Processed.count(IV))
      continue;
    const DILocalVariable *DIVar = IV.first;
    const DILocation *InlinedAt = IV.second;

    // Instruction ranges, specifying where IV is accessible.
    const auto &Ranges = I.second;

    LexicalScope *Scope = nullptr;
    if (InlinedAt)
      Scope = LScopes.findInlinedScope(DIVar->getScope(), InlinedAt);
    else
      Scope = LScopes.findLexicalScope(DIVar->getScope());
    // If variable scope is not found then skip this variable.
    if (!Scope)
      continue;

    LocalVariable Var;
    Var.DIVar = DIVar;

    // Calculate the definition ranges.
    for (auto I = Ranges.begin(), E = Ranges.end(); I != E; ++I) {
      const InsnRange &Range = *I;
      const MachineInstr *DVInst = Range.first;
      assert(DVInst->isDebugValue() && "Invalid History entry");
      const DIExpression *DIExpr = DVInst->getDebugExpression();

      // Bail if there is a complex DWARF expression for now.
      if (DIExpr && DIExpr->getNumElements() > 0)
        continue;

      // Bail if operand 0 is not a valid register. This means the variable is a
      // simple constant, or is described by a complex expression.
      // FIXME: Find a way to represent constant variables, since they are
      // relatively common.
      unsigned Reg =
          DVInst->getOperand(0).isReg() ? DVInst->getOperand(0).getReg() : 0;
      if (Reg == 0)
        continue;

      // Handle the two cases we can handle: indirect in memory and in register.
      bool IsIndirect = DVInst->getOperand(1).isImm();
      unsigned CVReg = TRI->getCodeViewRegNum(DVInst->getOperand(0).getReg());
      {
        LocalVarDefRange DefRange;
        if (IsIndirect) {
          int64_t Offset = DVInst->getOperand(1).getImm();
          DefRange = createDefRangeMem(CVReg, Offset);
        } else {
          DefRange = createDefRangeReg(CVReg);
        }
        if (Var.DefRanges.empty() ||
            Var.DefRanges.back().isDifferentLocation(DefRange)) {
          Var.DefRanges.emplace_back(std::move(DefRange));
        }
      }

      // Compute the label range.
      const MCSymbol *Begin = getLabelBeforeInsn(Range.first);
      const MCSymbol *End = getLabelAfterInsn(Range.second);
      if (!End) {
        if (std::next(I) != E)
          End = getLabelBeforeInsn(std::next(I)->first);
        else
          End = Asm->getFunctionEnd();
      }

      // If the last range end is our begin, just extend the last range.
      // Otherwise make a new range.
      SmallVectorImpl<std::pair<const MCSymbol *, const MCSymbol *>> &Ranges =
          Var.DefRanges.back().Ranges;
      if (!Ranges.empty() && Ranges.back().second == Begin)
        Ranges.back().second = End;
      else
        Ranges.emplace_back(Begin, End);

      // FIXME: Do more range combining.
    }

    recordLocalVariable(std::move(Var), InlinedAt);
  }
}

void CodeViewDebug::beginFunction(const MachineFunction *MF) {
  assert(!CurFn && "Can't process two functions at once!");

  if (!Asm || !MMI->hasDebugInfo())
    return;

  DebugHandlerBase::beginFunction(MF);

  const Function *GV = MF->getFunction();
  assert(FnDebugInfo.count(GV) == false);
  CurFn = &FnDebugInfo[GV];
  CurFn->FuncId = NextFuncId++;
  CurFn->Begin = Asm->getFunctionBegin();

  // Find the end of the function prolog.  First known non-DBG_VALUE and
  // non-frame setup location marks the beginning of the function body.
  // FIXME: is there a simpler a way to do this? Can we just search
  // for the first instruction of the function, not the last of the prolog?
  DebugLoc PrologEndLoc;
  bool EmptyPrologue = true;
  for (const auto &MBB : *MF) {
    for (const auto &MI : MBB) {
      if (!MI.isDebugValue() && !MI.getFlag(MachineInstr::FrameSetup) &&
          MI.getDebugLoc()) {
        PrologEndLoc = MI.getDebugLoc();
        break;
      } else if (!MI.isDebugValue()) {
        EmptyPrologue = false;
      }
    }
  }

  // Record beginning of function if we have a non-empty prologue.
  if (PrologEndLoc && !EmptyPrologue) {
    DebugLoc FnStartDL = PrologEndLoc.getFnDebugLoc();
    maybeRecordLocation(FnStartDL, MF);
  }
}

void CodeViewDebug::addToUDTs(const DIType *Ty, TypeIndex TI) {
  SmallVector<StringRef, 5> QualifiedNameComponents;
  const DISubprogram *ClosestSubprogram = getQualifiedNameComponents(
      Ty->getScope().resolve(), QualifiedNameComponents);

  std::string FullyQualifiedName =
      getQualifiedName(QualifiedNameComponents, Ty->getName());

  if (ClosestSubprogram == nullptr)
    GlobalUDTs.emplace_back(std::move(FullyQualifiedName), TI);
  else if (ClosestSubprogram == CurrentSubprogram)
    LocalUDTs.emplace_back(std::move(FullyQualifiedName), TI);

  // TODO: What if the ClosestSubprogram is neither null or the current
  // subprogram?  Currently, the UDT just gets dropped on the floor.
  //
  // The current behavior is not desirable.  To get maximal fidelity, we would
  // need to perform all type translation before beginning emission of .debug$S
  // and then make LocalUDTs a member of FunctionInfo
}

TypeIndex CodeViewDebug::lowerType(const DIType *Ty, const DIType *ClassTy) {
  // Generic dispatch for lowering an unknown type.
  switch (Ty->getTag()) {
  case dwarf::DW_TAG_array_type:
    return lowerTypeArray(cast<DICompositeType>(Ty));
  case dwarf::DW_TAG_typedef:
    return lowerTypeAlias(cast<DIDerivedType>(Ty));
  case dwarf::DW_TAG_base_type:
    return lowerTypeBasic(cast<DIBasicType>(Ty));
  case dwarf::DW_TAG_pointer_type:
  case dwarf::DW_TAG_reference_type:
  case dwarf::DW_TAG_rvalue_reference_type:
    return lowerTypePointer(cast<DIDerivedType>(Ty));
  case dwarf::DW_TAG_ptr_to_member_type:
    return lowerTypeMemberPointer(cast<DIDerivedType>(Ty));
  case dwarf::DW_TAG_const_type:
  case dwarf::DW_TAG_volatile_type:
    return lowerTypeModifier(cast<DIDerivedType>(Ty));
  case dwarf::DW_TAG_subroutine_type:
    if (ClassTy) {
      // The member function type of a member function pointer has no
      // ThisAdjustment.
      return lowerTypeMemberFunction(cast<DISubroutineType>(Ty), ClassTy,
                                     /*ThisAdjustment=*/0);
    }
    return lowerTypeFunction(cast<DISubroutineType>(Ty));
  case dwarf::DW_TAG_enumeration_type:
    return lowerTypeEnum(cast<DICompositeType>(Ty));
  case dwarf::DW_TAG_class_type:
  case dwarf::DW_TAG_structure_type:
    return lowerTypeClass(cast<DICompositeType>(Ty));
  case dwarf::DW_TAG_union_type:
    return lowerTypeUnion(cast<DICompositeType>(Ty));
  default:
    // Use the null type index.
    return TypeIndex();
  }
}

TypeIndex CodeViewDebug::lowerTypeAlias(const DIDerivedType *Ty) {
  DITypeRef UnderlyingTypeRef = Ty->getBaseType();
  TypeIndex UnderlyingTypeIndex = getTypeIndex(UnderlyingTypeRef);
  StringRef TypeName = Ty->getName();

  addToUDTs(Ty, UnderlyingTypeIndex);

  if (UnderlyingTypeIndex == TypeIndex(SimpleTypeKind::Int32Long) &&
      TypeName == "HRESULT")
    return TypeIndex(SimpleTypeKind::HResult);
  if (UnderlyingTypeIndex == TypeIndex(SimpleTypeKind::UInt16Short) &&
      TypeName == "wchar_t")
    return TypeIndex(SimpleTypeKind::WideCharacter);

  return UnderlyingTypeIndex;
}

TypeIndex CodeViewDebug::lowerTypeArray(const DICompositeType *Ty) {
  DITypeRef ElementTypeRef = Ty->getBaseType();
  TypeIndex ElementTypeIndex = getTypeIndex(ElementTypeRef);
  // IndexType is size_t, which depends on the bitness of the target.
  TypeIndex IndexType = Asm->MAI->getPointerSize() == 8
                            ? TypeIndex(SimpleTypeKind::UInt64Quad)
                            : TypeIndex(SimpleTypeKind::UInt32Long);
  uint64_t Size = Ty->getSizeInBits() / 8;
  ArrayRecord Record(ElementTypeIndex, IndexType, Size, Ty->getName());
  return TypeTable.writeArray(Record);
}

TypeIndex CodeViewDebug::lowerTypeBasic(const DIBasicType *Ty) {
  TypeIndex Index;
  dwarf::TypeKind Kind;
  uint32_t ByteSize;

  Kind = static_cast<dwarf::TypeKind>(Ty->getEncoding());
  ByteSize = Ty->getSizeInBits() / 8;

  SimpleTypeKind STK = SimpleTypeKind::None;
  switch (Kind) {
  case dwarf::DW_ATE_address:
    // FIXME: Translate
    break;
  case dwarf::DW_ATE_boolean:
    switch (ByteSize) {
    case 1:  STK = SimpleTypeKind::Boolean8;   break;
    case 2:  STK = SimpleTypeKind::Boolean16;  break;
    case 4:  STK = SimpleTypeKind::Boolean32;  break;
    case 8:  STK = SimpleTypeKind::Boolean64;  break;
    case 16: STK = SimpleTypeKind::Boolean128; break;
    }
    break;
  case dwarf::DW_ATE_complex_float:
    switch (ByteSize) {
    case 2:  STK = SimpleTypeKind::Complex16;  break;
    case 4:  STK = SimpleTypeKind::Complex32;  break;
    case 8:  STK = SimpleTypeKind::Complex64;  break;
    case 10: STK = SimpleTypeKind::Complex80;  break;
    case 16: STK = SimpleTypeKind::Complex128; break;
    }
    break;
  case dwarf::DW_ATE_float:
    switch (ByteSize) {
    case 2:  STK = SimpleTypeKind::Float16;  break;
    case 4:  STK = SimpleTypeKind::Float32;  break;
    case 6:  STK = SimpleTypeKind::Float48;  break;
    case 8:  STK = SimpleTypeKind::Float64;  break;
    case 10: STK = SimpleTypeKind::Float80;  break;
    case 16: STK = SimpleTypeKind::Float128; break;
    }
    break;
  case dwarf::DW_ATE_signed:
    switch (ByteSize) {
    case 1:  STK = SimpleTypeKind::SByte;      break;
    case 2:  STK = SimpleTypeKind::Int16Short; break;
    case 4:  STK = SimpleTypeKind::Int32;      break;
    case 8:  STK = SimpleTypeKind::Int64Quad;  break;
    case 16: STK = SimpleTypeKind::Int128Oct;  break;
    }
    break;
  case dwarf::DW_ATE_unsigned:
    switch (ByteSize) {
    case 1:  STK = SimpleTypeKind::Byte;        break;
    case 2:  STK = SimpleTypeKind::UInt16Short; break;
    case 4:  STK = SimpleTypeKind::UInt32;      break;
    case 8:  STK = SimpleTypeKind::UInt64Quad;  break;
    case 16: STK = SimpleTypeKind::UInt128Oct;  break;
    }
    break;
  case dwarf::DW_ATE_UTF:
    switch (ByteSize) {
    case 2: STK = SimpleTypeKind::Character16; break;
    case 4: STK = SimpleTypeKind::Character32; break;
    }
    break;
  case dwarf::DW_ATE_signed_char:
    if (ByteSize == 1)
      STK = SimpleTypeKind::SignedCharacter;
    break;
  case dwarf::DW_ATE_unsigned_char:
    if (ByteSize == 1)
      STK = SimpleTypeKind::UnsignedCharacter;
    break;
  default:
    break;
  }

  // Apply some fixups based on the source-level type name.
  if (STK == SimpleTypeKind::Int32 && Ty->getName() == "long int")
    STK = SimpleTypeKind::Int32Long;
  if (STK == SimpleTypeKind::UInt32 && Ty->getName() == "long unsigned int")
    STK = SimpleTypeKind::UInt32Long;
  if (STK == SimpleTypeKind::UInt16Short &&
      (Ty->getName() == "wchar_t" || Ty->getName() == "__wchar_t"))
    STK = SimpleTypeKind::WideCharacter;
  if ((STK == SimpleTypeKind::SignedCharacter ||
       STK == SimpleTypeKind::UnsignedCharacter) &&
      Ty->getName() == "char")
    STK = SimpleTypeKind::NarrowCharacter;

  return TypeIndex(STK);
}

TypeIndex CodeViewDebug::lowerTypePointer(const DIDerivedType *Ty) {
  TypeIndex PointeeTI = getTypeIndex(Ty->getBaseType());

  // While processing the type being pointed to it is possible we already
  // created this pointer type.  If so, we check here and return the existing
  // pointer type.
  auto I = TypeIndices.find({Ty, nullptr});
  if (I != TypeIndices.end())
    return I->second;

  // Pointers to simple types can use SimpleTypeMode, rather than having a
  // dedicated pointer type record.
  if (PointeeTI.isSimple() &&
      PointeeTI.getSimpleMode() == SimpleTypeMode::Direct &&
      Ty->getTag() == dwarf::DW_TAG_pointer_type) {
    SimpleTypeMode Mode = Ty->getSizeInBits() == 64
                              ? SimpleTypeMode::NearPointer64
                              : SimpleTypeMode::NearPointer32;
    return TypeIndex(PointeeTI.getSimpleKind(), Mode);
  }

  PointerKind PK =
      Ty->getSizeInBits() == 64 ? PointerKind::Near64 : PointerKind::Near32;
  PointerMode PM = PointerMode::Pointer;
  switch (Ty->getTag()) {
  default: llvm_unreachable("not a pointer tag type");
  case dwarf::DW_TAG_pointer_type:
    PM = PointerMode::Pointer;
    break;
  case dwarf::DW_TAG_reference_type:
    PM = PointerMode::LValueReference;
    break;
  case dwarf::DW_TAG_rvalue_reference_type:
    PM = PointerMode::RValueReference;
    break;
  }
  // FIXME: MSVC folds qualifiers into PointerOptions in the context of a method
  // 'this' pointer, but not normal contexts. Figure out what we're supposed to
  // do.
  PointerOptions PO = PointerOptions::None;
  PointerRecord PR(PointeeTI, PK, PM, PO, Ty->getSizeInBits() / 8);
  return TypeTable.writePointer(PR);
}

static PointerToMemberRepresentation
translatePtrToMemberRep(unsigned SizeInBytes, bool IsPMF, unsigned Flags) {
  // SizeInBytes being zero generally implies that the member pointer type was
  // incomplete, which can happen if it is part of a function prototype. In this
  // case, use the unknown model instead of the general model.
  if (IsPMF) {
    switch (Flags & DINode::FlagPtrToMemberRep) {
    case 0:
      return SizeInBytes == 0 ? PointerToMemberRepresentation::Unknown
                              : PointerToMemberRepresentation::GeneralFunction;
    case DINode::FlagSingleInheritance:
      return PointerToMemberRepresentation::SingleInheritanceFunction;
    case DINode::FlagMultipleInheritance:
      return PointerToMemberRepresentation::MultipleInheritanceFunction;
    case DINode::FlagVirtualInheritance:
      return PointerToMemberRepresentation::VirtualInheritanceFunction;
    }
  } else {
    switch (Flags & DINode::FlagPtrToMemberRep) {
    case 0:
      return SizeInBytes == 0 ? PointerToMemberRepresentation::Unknown
                              : PointerToMemberRepresentation::GeneralData;
    case DINode::FlagSingleInheritance:
      return PointerToMemberRepresentation::SingleInheritanceData;
    case DINode::FlagMultipleInheritance:
      return PointerToMemberRepresentation::MultipleInheritanceData;
    case DINode::FlagVirtualInheritance:
      return PointerToMemberRepresentation::VirtualInheritanceData;
    }
  }
  llvm_unreachable("invalid ptr to member representation");
}

TypeIndex CodeViewDebug::lowerTypeMemberPointer(const DIDerivedType *Ty) {
  assert(Ty->getTag() == dwarf::DW_TAG_ptr_to_member_type);
  TypeIndex ClassTI = getTypeIndex(Ty->getClassType());
  TypeIndex PointeeTI = getTypeIndex(Ty->getBaseType(), Ty->getClassType());
  PointerKind PK = Asm->MAI->getPointerSize() == 8 ? PointerKind::Near64
                                                   : PointerKind::Near32;
  bool IsPMF = isa<DISubroutineType>(Ty->getBaseType());
  PointerMode PM = IsPMF ? PointerMode::PointerToMemberFunction
                         : PointerMode::PointerToDataMember;
  PointerOptions PO = PointerOptions::None; // FIXME
  assert(Ty->getSizeInBits() / 8 <= 0xff && "pointer size too big");
  uint8_t SizeInBytes = Ty->getSizeInBits() / 8;
  MemberPointerInfo MPI(
      ClassTI, translatePtrToMemberRep(SizeInBytes, IsPMF, Ty->getFlags()));
  PointerRecord PR(PointeeTI, PK, PM, PO, SizeInBytes, MPI);
  return TypeTable.writePointer(PR);
}

/// Given a DWARF calling convention, get the CodeView equivalent. If we don't
/// have a translation, use the NearC convention.
static CallingConvention dwarfCCToCodeView(unsigned DwarfCC) {
  switch (DwarfCC) {
  case dwarf::DW_CC_normal:             return CallingConvention::NearC;
  case dwarf::DW_CC_BORLAND_msfastcall: return CallingConvention::NearFast;
  case dwarf::DW_CC_BORLAND_thiscall:   return CallingConvention::ThisCall;
  case dwarf::DW_CC_BORLAND_stdcall:    return CallingConvention::NearStdCall;
  case dwarf::DW_CC_BORLAND_pascal:     return CallingConvention::NearPascal;
  case dwarf::DW_CC_LLVM_vectorcall:    return CallingConvention::NearVector;
  }
  return CallingConvention::NearC;
}

TypeIndex CodeViewDebug::lowerTypeModifier(const DIDerivedType *Ty) {
  ModifierOptions Mods = ModifierOptions::None;
  bool IsModifier = true;
  const DIType *BaseTy = Ty;
  while (IsModifier && BaseTy) {
    // FIXME: Need to add DWARF tag for __unaligned.
    switch (BaseTy->getTag()) {
    case dwarf::DW_TAG_const_type:
      Mods |= ModifierOptions::Const;
      break;
    case dwarf::DW_TAG_volatile_type:
      Mods |= ModifierOptions::Volatile;
      break;
    default:
      IsModifier = false;
      break;
    }
    if (IsModifier)
      BaseTy = cast<DIDerivedType>(BaseTy)->getBaseType().resolve();
  }
  TypeIndex ModifiedTI = getTypeIndex(BaseTy);

  // While processing the type being pointed to, it is possible we already
  // created this modifier type.  If so, we check here and return the existing
  // modifier type.
  auto I = TypeIndices.find({Ty, nullptr});
  if (I != TypeIndices.end())
    return I->second;

  ModifierRecord MR(ModifiedTI, Mods);
  return TypeTable.writeModifier(MR);
}

TypeIndex CodeViewDebug::lowerTypeFunction(const DISubroutineType *Ty) {
  SmallVector<TypeIndex, 8> ReturnAndArgTypeIndices;
  for (DITypeRef ArgTypeRef : Ty->getTypeArray())
    ReturnAndArgTypeIndices.push_back(getTypeIndex(ArgTypeRef));

  TypeIndex ReturnTypeIndex = TypeIndex::Void();
  ArrayRef<TypeIndex> ArgTypeIndices = None;
  if (!ReturnAndArgTypeIndices.empty()) {
    auto ReturnAndArgTypesRef = makeArrayRef(ReturnAndArgTypeIndices);
    ReturnTypeIndex = ReturnAndArgTypesRef.front();
    ArgTypeIndices = ReturnAndArgTypesRef.drop_front();
  }

  ArgListRecord ArgListRec(TypeRecordKind::ArgList, ArgTypeIndices);
  TypeIndex ArgListIndex = TypeTable.writeArgList(ArgListRec);

  CallingConvention CC = dwarfCCToCodeView(Ty->getCC());

  ProcedureRecord Procedure(ReturnTypeIndex, CC, FunctionOptions::None,
                            ArgTypeIndices.size(), ArgListIndex);
  return TypeTable.writeProcedure(Procedure);
}

TypeIndex CodeViewDebug::lowerTypeMemberFunction(const DISubroutineType *Ty,
                                                 const DIType *ClassTy,
                                                 int ThisAdjustment) {
  // Lower the containing class type.
  TypeIndex ClassType = getTypeIndex(ClassTy);

  SmallVector<TypeIndex, 8> ReturnAndArgTypeIndices;
  for (DITypeRef ArgTypeRef : Ty->getTypeArray())
    ReturnAndArgTypeIndices.push_back(getTypeIndex(ArgTypeRef));

  TypeIndex ReturnTypeIndex = TypeIndex::Void();
  ArrayRef<TypeIndex> ArgTypeIndices = None;
  if (!ReturnAndArgTypeIndices.empty()) {
    auto ReturnAndArgTypesRef = makeArrayRef(ReturnAndArgTypeIndices);
    ReturnTypeIndex = ReturnAndArgTypesRef.front();
    ArgTypeIndices = ReturnAndArgTypesRef.drop_front();
  }
  TypeIndex ThisTypeIndex = TypeIndex::Void();
  if (!ArgTypeIndices.empty()) {
    ThisTypeIndex = ArgTypeIndices.front();
    ArgTypeIndices = ArgTypeIndices.drop_front();
  }

  ArgListRecord ArgListRec(TypeRecordKind::ArgList, ArgTypeIndices);
  TypeIndex ArgListIndex = TypeTable.writeArgList(ArgListRec);

  CallingConvention CC = dwarfCCToCodeView(Ty->getCC());

  // TODO: Need to use the correct values for:
  //       FunctionOptions
  //       ThisPointerAdjustment.
  TypeIndex TI = TypeTable.writeMemberFunction(MemberFunctionRecord(
      ReturnTypeIndex, ClassType, ThisTypeIndex, CC, FunctionOptions::None,
      ArgTypeIndices.size(), ArgListIndex, ThisAdjustment));

  return TI;
}

static MemberAccess translateAccessFlags(unsigned RecordTag, unsigned Flags) {
  switch (Flags & DINode::FlagAccessibility) {
  case DINode::FlagPrivate:   return MemberAccess::Private;
  case DINode::FlagPublic:    return MemberAccess::Public;
  case DINode::FlagProtected: return MemberAccess::Protected;
  case 0:
    // If there was no explicit access control, provide the default for the tag.
    return RecordTag == dwarf::DW_TAG_class_type ? MemberAccess::Private
                                                 : MemberAccess::Public;
  }
  llvm_unreachable("access flags are exclusive");
}

static MethodOptions translateMethodOptionFlags(const DISubprogram *SP) {
  if (SP->isArtificial())
    return MethodOptions::CompilerGenerated;

  // FIXME: Handle other MethodOptions.

  return MethodOptions::None;
}

static MethodKind translateMethodKindFlags(const DISubprogram *SP,
                                           bool Introduced) {
  switch (SP->getVirtuality()) {
  case dwarf::DW_VIRTUALITY_none:
    break;
  case dwarf::DW_VIRTUALITY_virtual:
    return Introduced ? MethodKind::IntroducingVirtual : MethodKind::Virtual;
  case dwarf::DW_VIRTUALITY_pure_virtual:
    return Introduced ? MethodKind::PureIntroducingVirtual
                      : MethodKind::PureVirtual;
  default:
    llvm_unreachable("unhandled virtuality case");
  }

  // FIXME: Get Clang to mark DISubprogram as static and do something with it.

  return MethodKind::Vanilla;
}

static TypeRecordKind getRecordKind(const DICompositeType *Ty) {
  switch (Ty->getTag()) {
  case dwarf::DW_TAG_class_type:     return TypeRecordKind::Class;
  case dwarf::DW_TAG_structure_type: return TypeRecordKind::Struct;
  }
  llvm_unreachable("unexpected tag");
}

/// Return the HasUniqueName option if it should be present in ClassOptions, or
/// None otherwise.
static ClassOptions getRecordUniqueNameOption(const DICompositeType *Ty) {
  // MSVC always sets this flag now, even for local types. Clang doesn't always
  // appear to give every type a linkage name, which may be problematic for us.
  // FIXME: Investigate the consequences of not following them here.
  return !Ty->getIdentifier().empty() ? ClassOptions::HasUniqueName
                                      : ClassOptions::None;
}

TypeIndex CodeViewDebug::lowerTypeEnum(const DICompositeType *Ty) {
  ClassOptions CO = ClassOptions::None | getRecordUniqueNameOption(Ty);
  TypeIndex FTI;
  unsigned EnumeratorCount = 0;

  if (Ty->isForwardDecl()) {
    CO |= ClassOptions::ForwardReference;
  } else {
    FieldListRecordBuilder Fields;
    for (const DINode *Element : Ty->getElements()) {
      // We assume that the frontend provides all members in source declaration
      // order, which is what MSVC does.
      if (auto *Enumerator = dyn_cast_or_null<DIEnumerator>(Element)) {
        Fields.writeEnumerator(EnumeratorRecord(
            MemberAccess::Public, APSInt::getUnsigned(Enumerator->getValue()),
            Enumerator->getName()));
        EnumeratorCount++;
      }
    }
    FTI = TypeTable.writeFieldList(Fields);
  }

  std::string FullName =
      getFullyQualifiedName(Ty->getScope().resolve(), Ty->getName());

  return TypeTable.writeEnum(EnumRecord(EnumeratorCount, CO, FTI, FullName,
                                        Ty->getIdentifier(),
                                        getTypeIndex(Ty->getBaseType())));
}

//===----------------------------------------------------------------------===//
// ClassInfo
//===----------------------------------------------------------------------===//

struct llvm::ClassInfo {
  struct MemberInfo {
    const DIDerivedType *MemberTypeNode;
    unsigned BaseOffset;
  };
  // [MemberInfo]
  typedef std::vector<MemberInfo> MemberList;

  typedef TinyPtrVector<const DISubprogram *> MethodsList;
  // MethodName -> MethodsList
  typedef MapVector<MDString *, MethodsList> MethodsMap;

  /// Direct members.
  MemberList Members;
  // Direct overloaded methods gathered by name.
  MethodsMap Methods;
};

void CodeViewDebug::clear() {
  assert(CurFn == nullptr);
  FileIdMap.clear();
  FnDebugInfo.clear();
  FileToFilepathMap.clear();
  LocalUDTs.clear();
  GlobalUDTs.clear();
  TypeIndices.clear();
  CompleteTypeIndices.clear();
}

void CodeViewDebug::collectMemberInfo(ClassInfo &Info,
                                      const DIDerivedType *DDTy) {
  if (!DDTy->getName().empty()) {
    Info.Members.push_back({DDTy, 0});
    return;
  }
  // An unnamed member must represent a nested struct or union. Add all the
  // indirect fields to the current record.
  assert((DDTy->getOffsetInBits() % 8) == 0 && "Unnamed bitfield member!");
  unsigned Offset = DDTy->getOffsetInBits() / 8;
  const DIType *Ty = DDTy->getBaseType().resolve();
  const DICompositeType *DCTy = cast<DICompositeType>(Ty);
  ClassInfo NestedInfo = collectClassInfo(DCTy);
  for (const ClassInfo::MemberInfo &IndirectField : NestedInfo.Members)
    Info.Members.push_back(
        {IndirectField.MemberTypeNode, IndirectField.BaseOffset + Offset});
}

ClassInfo CodeViewDebug::collectClassInfo(const DICompositeType *Ty) {
  ClassInfo Info;
  // Add elements to structure type.
  DINodeArray Elements = Ty->getElements();
  for (auto *Element : Elements) {
    // We assume that the frontend provides all members in source declaration
    // order, which is what MSVC does.
    if (!Element)
      continue;
    if (auto *SP = dyn_cast<DISubprogram>(Element)) {
      Info.Methods[SP->getRawName()].push_back(SP);
    } else if (auto *DDTy = dyn_cast<DIDerivedType>(Element)) {
      if (DDTy->getTag() == dwarf::DW_TAG_member)
        collectMemberInfo(Info, DDTy);
      else if (DDTy->getTag() == dwarf::DW_TAG_inheritance) {
        // FIXME: collect class info from inheritance.
      } else if (DDTy->getTag() == dwarf::DW_TAG_friend) {
        // Ignore friend members. It appears that MSVC emitted info about
        // friends in the past, but modern versions do not.
      }
      // FIXME: Get Clang to emit function virtual table here and handle it.
      // FIXME: Get clang to emit nested types here and do something with
      // them.
    }
    // Skip other unrecognized kinds of elements.
  }
  return Info;
}

TypeIndex CodeViewDebug::lowerTypeClass(const DICompositeType *Ty) {
  // First, construct the forward decl.  Don't look into Ty to compute the
  // forward decl options, since it might not be available in all TUs.
  TypeRecordKind Kind = getRecordKind(Ty);
  ClassOptions CO =
      ClassOptions::ForwardReference | getRecordUniqueNameOption(Ty);
  std::string FullName =
      getFullyQualifiedName(Ty->getScope().resolve(), Ty->getName());
  TypeIndex FwdDeclTI = TypeTable.writeClass(ClassRecord(
      Kind, 0, CO, HfaKind::None, WindowsRTClassKind::None, TypeIndex(),
      TypeIndex(), TypeIndex(), 0, FullName, Ty->getIdentifier()));
  if (!Ty->isForwardDecl())
    DeferredCompleteTypes.push_back(Ty);
  return FwdDeclTI;
}

TypeIndex CodeViewDebug::lowerCompleteTypeClass(const DICompositeType *Ty) {
  // Construct the field list and complete type record.
  TypeRecordKind Kind = getRecordKind(Ty);
  // FIXME: Other ClassOptions, like ContainsNestedClass and NestedClass.
  ClassOptions CO = ClassOptions::None | getRecordUniqueNameOption(Ty);
  TypeIndex FieldTI;
  TypeIndex VShapeTI;
  unsigned FieldCount;
  std::tie(FieldTI, VShapeTI, FieldCount) = lowerRecordFieldList(Ty);

  std::string FullName =
      getFullyQualifiedName(Ty->getScope().resolve(), Ty->getName());

  uint64_t SizeInBytes = Ty->getSizeInBits() / 8;

  TypeIndex ClassTI = TypeTable.writeClass(ClassRecord(
      Kind, FieldCount, CO, HfaKind::None, WindowsRTClassKind::None, FieldTI,
      TypeIndex(), VShapeTI, SizeInBytes, FullName, Ty->getIdentifier()));

  TypeTable.writeUdtSourceLine(UdtSourceLineRecord(
      ClassTI, TypeTable.writeStringId(StringIdRecord(
                   TypeIndex(0x0), getFullFilepath(Ty->getFile()))),
      Ty->getLine()));

  addToUDTs(Ty, ClassTI);

  return ClassTI;
}

TypeIndex CodeViewDebug::lowerTypeUnion(const DICompositeType *Ty) {
  ClassOptions CO =
      ClassOptions::ForwardReference | getRecordUniqueNameOption(Ty);
  std::string FullName =
      getFullyQualifiedName(Ty->getScope().resolve(), Ty->getName());
  TypeIndex FwdDeclTI =
      TypeTable.writeUnion(UnionRecord(0, CO, HfaKind::None, TypeIndex(), 0,
                                       FullName, Ty->getIdentifier()));
  if (!Ty->isForwardDecl())
    DeferredCompleteTypes.push_back(Ty);
  return FwdDeclTI;
}

TypeIndex CodeViewDebug::lowerCompleteTypeUnion(const DICompositeType *Ty) {
  ClassOptions CO = ClassOptions::None | getRecordUniqueNameOption(Ty);
  TypeIndex FieldTI;
  unsigned FieldCount;
  std::tie(FieldTI, std::ignore, FieldCount) = lowerRecordFieldList(Ty);
  uint64_t SizeInBytes = Ty->getSizeInBits() / 8;
  std::string FullName =
      getFullyQualifiedName(Ty->getScope().resolve(), Ty->getName());

  TypeIndex UnionTI = TypeTable.writeUnion(
      UnionRecord(FieldCount, CO, HfaKind::None, FieldTI, SizeInBytes, FullName,
                  Ty->getIdentifier()));

  TypeTable.writeUdtSourceLine(UdtSourceLineRecord(
      UnionTI, TypeTable.writeStringId(StringIdRecord(
                   TypeIndex(0x0), getFullFilepath(Ty->getFile()))),
      Ty->getLine()));

  addToUDTs(Ty, UnionTI);

  return UnionTI;
}

std::tuple<TypeIndex, TypeIndex, unsigned>
CodeViewDebug::lowerRecordFieldList(const DICompositeType *Ty) {
  // Manually count members. MSVC appears to count everything that generates a
  // field list record. Each individual overload in a method overload group
  // contributes to this count, even though the overload group is a single field
  // list record.
  unsigned MemberCount = 0;
  ClassInfo Info = collectClassInfo(Ty);
  FieldListRecordBuilder Fields;

  // Create members.
  for (ClassInfo::MemberInfo &MemberInfo : Info.Members) {
    const DIDerivedType *Member = MemberInfo.MemberTypeNode;
    TypeIndex MemberBaseType = getTypeIndex(Member->getBaseType());

    if (Member->isStaticMember()) {
      Fields.writeStaticDataMember(StaticDataMemberRecord(
          translateAccessFlags(Ty->getTag(), Member->getFlags()),
          MemberBaseType, Member->getName()));
      MemberCount++;
      continue;
    }

    uint64_t OffsetInBytes = MemberInfo.BaseOffset;

    // FIXME: Handle bitfield type memeber.
    OffsetInBytes += Member->getOffsetInBits() / 8;

    Fields.writeDataMember(
        DataMemberRecord(translateAccessFlags(Ty->getTag(), Member->getFlags()),
                         MemberBaseType, OffsetInBytes, Member->getName()));
    MemberCount++;
  }

  // Create methods
  for (auto &MethodItr : Info.Methods) {
    StringRef Name = MethodItr.first->getString();

    std::vector<OneMethodRecord> Methods;
    for (const DISubprogram *SP : MethodItr.second) {
      TypeIndex MethodType = getMemberFunctionType(SP, Ty);
      bool Introduced = SP->getFlags() & DINode::FlagIntroducedVirtual;

      unsigned VFTableOffset = -1;
      if (Introduced)
        VFTableOffset = SP->getVirtualIndex() * getPointerSizeInBytes();

      Methods.push_back(
          OneMethodRecord(MethodType, translateMethodKindFlags(SP, Introduced),
                          translateMethodOptionFlags(SP),
                          translateAccessFlags(Ty->getTag(), SP->getFlags()),
                          VFTableOffset, Name));
      MemberCount++;
    }
    assert(Methods.size() > 0 && "Empty methods map entry");
    if (Methods.size() == 1)
      Fields.writeOneMethod(Methods[0]);
    else {
      TypeIndex MethodList =
          TypeTable.writeMethodOverloadList(MethodOverloadListRecord(Methods));
      Fields.writeOverloadedMethod(
          OverloadedMethodRecord(Methods.size(), MethodList, Name));
    }
  }
  TypeIndex FieldTI = TypeTable.writeFieldList(Fields);
  return std::make_tuple(FieldTI, TypeIndex(), MemberCount);
}

struct CodeViewDebug::TypeLoweringScope {
  TypeLoweringScope(CodeViewDebug &CVD) : CVD(CVD) { ++CVD.TypeEmissionLevel; }
  ~TypeLoweringScope() {
    // Don't decrement TypeEmissionLevel until after emitting deferred types, so
    // inner TypeLoweringScopes don't attempt to emit deferred types.
    if (CVD.TypeEmissionLevel == 1)
      CVD.emitDeferredCompleteTypes();
    --CVD.TypeEmissionLevel;
  }
  CodeViewDebug &CVD;
};

TypeIndex CodeViewDebug::getTypeIndex(DITypeRef TypeRef, DITypeRef ClassTyRef) {
  const DIType *Ty = TypeRef.resolve();
  const DIType *ClassTy = ClassTyRef.resolve();

  // The null DIType is the void type. Don't try to hash it.
  if (!Ty)
    return TypeIndex::Void();

  // Check if we've already translated this type. Don't try to do a
  // get-or-create style insertion that caches the hash lookup across the
  // lowerType call. It will update the TypeIndices map.
  auto I = TypeIndices.find({Ty, ClassTy});
  if (I != TypeIndices.end())
    return I->second;

  TypeIndex TI;
  {
    TypeLoweringScope S(*this);
    TI = lowerType(Ty, ClassTy);
    recordTypeIndexForDINode(Ty, TI, ClassTy);
  }

  return TI;
}

TypeIndex CodeViewDebug::getCompleteTypeIndex(DITypeRef TypeRef) {
  const DIType *Ty = TypeRef.resolve();

  // The null DIType is the void type. Don't try to hash it.
  if (!Ty)
    return TypeIndex::Void();

  // If this is a non-record type, the complete type index is the same as the
  // normal type index. Just call getTypeIndex.
  switch (Ty->getTag()) {
  case dwarf::DW_TAG_class_type:
  case dwarf::DW_TAG_structure_type:
  case dwarf::DW_TAG_union_type:
    break;
  default:
    return getTypeIndex(Ty);
  }

  // Check if we've already translated the complete record type.  Lowering a
  // complete type should never trigger lowering another complete type, so we
  // can reuse the hash table lookup result.
  const auto *CTy = cast<DICompositeType>(Ty);
  auto InsertResult = CompleteTypeIndices.insert({CTy, TypeIndex()});
  if (!InsertResult.second)
    return InsertResult.first->second;

  TypeLoweringScope S(*this);

  // Make sure the forward declaration is emitted first. It's unclear if this
  // is necessary, but MSVC does it, and we should follow suit until we can show
  // otherwise.
  TypeIndex FwdDeclTI = getTypeIndex(CTy);

  // Just use the forward decl if we don't have complete type info. This might
  // happen if the frontend is using modules and expects the complete definition
  // to be emitted elsewhere.
  if (CTy->isForwardDecl())
    return FwdDeclTI;

  TypeIndex TI;
  switch (CTy->getTag()) {
  case dwarf::DW_TAG_class_type:
  case dwarf::DW_TAG_structure_type:
    TI = lowerCompleteTypeClass(CTy);
    break;
  case dwarf::DW_TAG_union_type:
    TI = lowerCompleteTypeUnion(CTy);
    break;
  default:
    llvm_unreachable("not a record");
  }

  InsertResult.first->second = TI;
  return TI;
}

/// Emit all the deferred complete record types. Try to do this in FIFO order,
/// and do this until fixpoint, as each complete record type typically references
/// many other record types.
void CodeViewDebug::emitDeferredCompleteTypes() {
  SmallVector<const DICompositeType *, 4> TypesToEmit;
  while (!DeferredCompleteTypes.empty()) {
    std::swap(DeferredCompleteTypes, TypesToEmit);
    for (const DICompositeType *RecordTy : TypesToEmit)
      getCompleteTypeIndex(RecordTy);
    TypesToEmit.clear();
  }
}

void CodeViewDebug::emitLocalVariable(const LocalVariable &Var) {
  // LocalSym record, see SymbolRecord.h for more info.
  MCSymbol *LocalBegin = MMI->getContext().createTempSymbol(),
           *LocalEnd = MMI->getContext().createTempSymbol();
  OS.AddComment("Record length");
  OS.emitAbsoluteSymbolDiff(LocalEnd, LocalBegin, 2);
  OS.EmitLabel(LocalBegin);

  OS.AddComment("Record kind: S_LOCAL");
  OS.EmitIntValue(unsigned(SymbolKind::S_LOCAL), 2);

  LocalSymFlags Flags = LocalSymFlags::None;
  if (Var.DIVar->isParameter())
    Flags |= LocalSymFlags::IsParameter;
  if (Var.DefRanges.empty())
    Flags |= LocalSymFlags::IsOptimizedOut;

  OS.AddComment("TypeIndex");
  TypeIndex TI = getCompleteTypeIndex(Var.DIVar->getType());
  OS.EmitIntValue(TI.getIndex(), 4);
  OS.AddComment("Flags");
  OS.EmitIntValue(static_cast<uint16_t>(Flags), 2);
  // Truncate the name so we won't overflow the record length field.
  emitNullTerminatedSymbolName(OS, Var.DIVar->getName());
  OS.EmitLabel(LocalEnd);

  // Calculate the on disk prefix of the appropriate def range record. The
  // records and on disk formats are described in SymbolRecords.h. BytePrefix
  // should be big enough to hold all forms without memory allocation.
  SmallString<20> BytePrefix;
  for (const LocalVarDefRange &DefRange : Var.DefRanges) {
    BytePrefix.clear();
    // FIXME: Handle bitpieces.
    if (DefRange.StructOffset != 0)
      continue;

    if (DefRange.InMemory) {
      DefRangeRegisterRelSym Sym(DefRange.CVRegister, 0, DefRange.DataOffset, 0,
                                 0, 0, ArrayRef<LocalVariableAddrGap>());
      ulittle16_t SymKind = ulittle16_t(S_DEFRANGE_REGISTER_REL);
      BytePrefix +=
          StringRef(reinterpret_cast<const char *>(&SymKind), sizeof(SymKind));
      BytePrefix +=
          StringRef(reinterpret_cast<const char *>(&Sym.Header),
                    sizeof(Sym.Header) - sizeof(LocalVariableAddrRange));
    } else {
      assert(DefRange.DataOffset == 0 && "unexpected offset into register");
      // Unclear what matters here.
      DefRangeRegisterSym Sym(DefRange.CVRegister, 0, 0, 0, 0,
                              ArrayRef<LocalVariableAddrGap>());
      ulittle16_t SymKind = ulittle16_t(S_DEFRANGE_REGISTER);
      BytePrefix +=
          StringRef(reinterpret_cast<const char *>(&SymKind), sizeof(SymKind));
      BytePrefix +=
          StringRef(reinterpret_cast<const char *>(&Sym.Header),
                    sizeof(Sym.Header) - sizeof(LocalVariableAddrRange));
    }
    OS.EmitCVDefRangeDirective(DefRange.Ranges, BytePrefix);
  }
}

void CodeViewDebug::endFunction(const MachineFunction *MF) {
  if (!Asm || !CurFn)  // We haven't created any debug info for this function.
    return;

  const Function *GV = MF->getFunction();
  assert(FnDebugInfo.count(GV));
  assert(CurFn == &FnDebugInfo[GV]);

  collectVariableInfo(GV->getSubprogram());

  DebugHandlerBase::endFunction(MF);

  // Don't emit anything if we don't have any line tables.
  if (!CurFn->HaveLineInfo) {
    FnDebugInfo.erase(GV);
    CurFn = nullptr;
    return;
  }

  CurFn->End = Asm->getFunctionEnd();

  CurFn = nullptr;
}

void CodeViewDebug::beginInstruction(const MachineInstr *MI) {
  DebugHandlerBase::beginInstruction(MI);

  // Ignore DBG_VALUE locations and function prologue.
  if (!Asm || MI->isDebugValue() || MI->getFlag(MachineInstr::FrameSetup))
    return;
  DebugLoc DL = MI->getDebugLoc();
  if (DL == PrevInstLoc || !DL)
    return;
  maybeRecordLocation(DL, Asm->MF);
}

MCSymbol *CodeViewDebug::beginCVSubsection(ModuleSubstreamKind Kind) {
  MCSymbol *BeginLabel = MMI->getContext().createTempSymbol(),
           *EndLabel = MMI->getContext().createTempSymbol();
  OS.EmitIntValue(unsigned(Kind), 4);
  OS.AddComment("Subsection size");
  OS.emitAbsoluteSymbolDiff(EndLabel, BeginLabel, 4);
  OS.EmitLabel(BeginLabel);
  return EndLabel;
}

void CodeViewDebug::endCVSubsection(MCSymbol *EndLabel) {
  OS.EmitLabel(EndLabel);
  // Every subsection must be aligned to a 4-byte boundary.
  OS.EmitValueToAlignment(4);
}

void CodeViewDebug::emitDebugInfoForUDTs(
    ArrayRef<std::pair<std::string, TypeIndex>> UDTs) {
  for (const std::pair<std::string, codeview::TypeIndex> &UDT : UDTs) {
    MCSymbol *UDTRecordBegin = MMI->getContext().createTempSymbol(),
             *UDTRecordEnd = MMI->getContext().createTempSymbol();
    OS.AddComment("Record length");
    OS.emitAbsoluteSymbolDiff(UDTRecordEnd, UDTRecordBegin, 2);
    OS.EmitLabel(UDTRecordBegin);

    OS.AddComment("Record kind: S_UDT");
    OS.EmitIntValue(unsigned(SymbolKind::S_UDT), 2);

    OS.AddComment("Type");
    OS.EmitIntValue(UDT.second.getIndex(), 4);

    emitNullTerminatedSymbolName(OS, UDT.first);
    OS.EmitLabel(UDTRecordEnd);
  }
}

void CodeViewDebug::emitDebugInfoForGlobals() {
  NamedMDNode *CUs = MMI->getModule()->getNamedMetadata("llvm.dbg.cu");
  for (const MDNode *Node : CUs->operands()) {
    const auto *CU = cast<DICompileUnit>(Node);

    // First, emit all globals that are not in a comdat in a single symbol
    // substream. MSVC doesn't like it if the substream is empty, so only open
    // it if we have at least one global to emit.
    switchToDebugSectionForSymbol(nullptr);
    MCSymbol *EndLabel = nullptr;
    for (const DIGlobalVariable *G : CU->getGlobalVariables()) {
      if (const auto *GV = dyn_cast_or_null<GlobalVariable>(G->getVariable())) {
        if (!GV->hasComdat() && !GV->isDeclarationForLinker()) {
          if (!EndLabel) {
            OS.AddComment("Symbol subsection for globals");
            EndLabel = beginCVSubsection(ModuleSubstreamKind::Symbols);
          }
          emitDebugInfoForGlobal(G, Asm->getSymbol(GV));
        }
      }
    }
    if (EndLabel)
      endCVSubsection(EndLabel);

    // Second, emit each global that is in a comdat into its own .debug$S
    // section along with its own symbol substream.
    for (const DIGlobalVariable *G : CU->getGlobalVariables()) {
      if (const auto *GV = dyn_cast_or_null<GlobalVariable>(G->getVariable())) {
        if (GV->hasComdat()) {
          MCSymbol *GVSym = Asm->getSymbol(GV);
          OS.AddComment("Symbol subsection for " +
                        Twine(GlobalValue::getRealLinkageName(GV->getName())));
          switchToDebugSectionForSymbol(GVSym);
          EndLabel = beginCVSubsection(ModuleSubstreamKind::Symbols);
          emitDebugInfoForGlobal(G, GVSym);
          endCVSubsection(EndLabel);
        }
      }
    }
  }
}

void CodeViewDebug::emitDebugInfoForRetainedTypes() {
  NamedMDNode *CUs = MMI->getModule()->getNamedMetadata("llvm.dbg.cu");
  for (const MDNode *Node : CUs->operands()) {
    for (auto *Ty : cast<DICompileUnit>(Node)->getRetainedTypes()) {
      if (DIType *RT = dyn_cast<DIType>(Ty)) {
        getTypeIndex(RT);
        // FIXME: Add to global/local DTU list.
      }
    }
  }
}

void CodeViewDebug::emitDebugInfoForGlobal(const DIGlobalVariable *DIGV,
                                           MCSymbol *GVSym) {
  // DataSym record, see SymbolRecord.h for more info.
  // FIXME: Thread local data, etc
  MCSymbol *DataBegin = MMI->getContext().createTempSymbol(),
           *DataEnd = MMI->getContext().createTempSymbol();
  OS.AddComment("Record length");
  OS.emitAbsoluteSymbolDiff(DataEnd, DataBegin, 2);
  OS.EmitLabel(DataBegin);
  OS.AddComment("Record kind: S_GDATA32");
  OS.EmitIntValue(unsigned(SymbolKind::S_GDATA32), 2);
  OS.AddComment("Type");
  OS.EmitIntValue(getCompleteTypeIndex(DIGV->getType()).getIndex(), 4);
  OS.AddComment("DataOffset");
  OS.EmitCOFFSecRel32(GVSym);
  OS.AddComment("Segment");
  OS.EmitCOFFSectionIndex(GVSym);
  OS.AddComment("Name");
  emitNullTerminatedSymbolName(OS, DIGV->getName());
  OS.EmitLabel(DataEnd);
}
