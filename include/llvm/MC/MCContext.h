//===- MCContext.h - Machine Code Context -----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCCONTEXT_H
#define LLVM_MC_MCCONTEXT_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/BinaryFormat/Dwarf.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/BinaryFormat/XCOFF.h"
#include "llvm/MC/MCAsmMacro.h"
#include "llvm/MC/MCDwarf.h"
#include "llvm/MC/MCPseudoProbe.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/MC/SectionKind.h"
#include "llvm/Support/Allocator.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/MD5.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <map>
#include <memory>
#include <string>
#include <utility>
#include <vector>

namespace llvm {

  class CodeViewContext;
  class MCAsmInfo;
  class MCLabel;
  class MCObjectFileInfo;
  class MCRegisterInfo;
  class MCSection;
  class MCSectionCOFF;
  class MCSectionELF;
  class MCSectionGOFF;
  class MCSectionMachO;
  class MCSectionWasm;
  class MCSectionXCOFF;
  class MCStreamer;
  class MCSymbol;
  class MCSymbolELF;
  class MCSymbolWasm;
  class MCSymbolXCOFF;
  class MDNode;
  class SMDiagnostic;
  class SMLoc;
  class SourceMgr;

  /// Context object for machine code objects.  This class owns all of the
  /// sections that it creates.
  ///
  class MCContext {
  public:
    using SymbolTable = StringMap<MCSymbol *, BumpPtrAllocator &>;
    using DiagHandlerTy =
        std::function<void(const SMDiagnostic &, bool, const SourceMgr &,
                           std::vector<const MDNode *> &)>;
    enum Environment { IsMachO, IsELF, IsGOFF, IsCOFF, IsWasm, IsXCOFF };

  private:
    Environment Env;

    /// The triple for this object.
    Triple TT;

    /// The SourceMgr for this object, if any.
    const SourceMgr *SrcMgr;

    /// The SourceMgr for inline assembly, if any.
    std::unique_ptr<SourceMgr> InlineSrcMgr;
    std::vector<const MDNode *> LocInfos;

    DiagHandlerTy DiagHandler;

    /// The MCAsmInfo for this target.
    const MCAsmInfo *MAI;

    /// The MCRegisterInfo for this target.
    const MCRegisterInfo *MRI;

    /// The MCObjectFileInfo for this target.
    const MCObjectFileInfo *MOFI;

    /// The MCSubtargetInfo for this target.
    const MCSubtargetInfo *MSTI;

    std::unique_ptr<CodeViewContext> CVContext;

    /// Allocator object used for creating machine code objects.
    ///
    /// We use a bump pointer allocator to avoid the need to track all allocated
    /// objects.
    BumpPtrAllocator Allocator;

    SpecificBumpPtrAllocator<MCSectionCOFF> COFFAllocator;
    SpecificBumpPtrAllocator<MCSectionELF> ELFAllocator;
    SpecificBumpPtrAllocator<MCSectionMachO> MachOAllocator;
    SpecificBumpPtrAllocator<MCSectionGOFF> GOFFAllocator;
    SpecificBumpPtrAllocator<MCSectionWasm> WasmAllocator;
    SpecificBumpPtrAllocator<MCSectionXCOFF> XCOFFAllocator;
    SpecificBumpPtrAllocator<MCInst> MCInstAllocator;

    /// Bindings of names to symbols.
    SymbolTable Symbols;

    /// A mapping from a local label number and an instance count to a symbol.
    /// For example, in the assembly
    ///     1:
    ///     2:
    ///     1:
    /// We have three labels represented by the pairs (1, 0), (2, 0) and (1, 1)
    DenseMap<std::pair<unsigned, unsigned>, MCSymbol *> LocalSymbols;

    /// Keeps tracks of names that were used both for used declared and
    /// artificial symbols. The value is "true" if the name has been used for a
    /// non-section symbol (there can be at most one of those, plus an unlimited
    /// number of section symbols with the same name).
    StringMap<bool, BumpPtrAllocator &> UsedNames;

    /// Keeps track of labels that are used in inline assembly.
    SymbolTable InlineAsmUsedLabelNames;

    /// The next ID to dole out to an unnamed assembler temporary symbol with
    /// a given prefix.
    StringMap<unsigned> NextID;

    /// Instances of directional local labels.
    DenseMap<unsigned, MCLabel *> Instances;
    /// NextInstance() creates the next instance of the directional local label
    /// for the LocalLabelVal and adds it to the map if needed.
    unsigned NextInstance(unsigned LocalLabelVal);
    /// GetInstance() gets the current instance of the directional local label
    /// for the LocalLabelVal and adds it to the map if needed.
    unsigned GetInstance(unsigned LocalLabelVal);

    /// The file name of the log file from the environment variable
    /// AS_SECURE_LOG_FILE.  Which must be set before the .secure_log_unique
    /// directive is used or it is an error.
    char *SecureLogFile;
    /// The stream that gets written to for the .secure_log_unique directive.
    std::unique_ptr<raw_fd_ostream> SecureLog;
    /// Boolean toggled when .secure_log_unique / .secure_log_reset is seen to
    /// catch errors if .secure_log_unique appears twice without
    /// .secure_log_reset appearing between them.
    bool SecureLogUsed = false;

    /// The compilation directory to use for DW_AT_comp_dir.
    SmallString<128> CompilationDir;

    /// Prefix replacement map for source file information.
    std::map<const std::string, const std::string> DebugPrefixMap;

    /// The main file name if passed in explicitly.
    std::string MainFileName;

    /// The dwarf file and directory tables from the dwarf .file directive.
    /// We now emit a line table for each compile unit. To reduce the prologue
    /// size of each line table, the files and directories used by each compile
    /// unit are separated.
    std::map<unsigned, MCDwarfLineTable> MCDwarfLineTablesCUMap;

    /// The current dwarf line information from the last dwarf .loc directive.
    MCDwarfLoc CurrentDwarfLoc;
    bool DwarfLocSeen = false;

    /// Generate dwarf debugging info for assembly source files.
    bool GenDwarfForAssembly = false;

    /// The current dwarf file number when generate dwarf debugging info for
    /// assembly source files.
    unsigned GenDwarfFileNumber = 0;

    /// Sections for generating the .debug_ranges and .debug_aranges sections.
    SetVector<MCSection *> SectionsForRanges;

    /// The information gathered from labels that will have dwarf label
    /// entries when generating dwarf assembly source files.
    std::vector<MCGenDwarfLabelEntry> MCGenDwarfLabelEntries;

    /// The string to embed in the debug information for the compile unit, if
    /// non-empty.
    StringRef DwarfDebugFlags;

    /// The string to embed in as the dwarf AT_producer for the compile unit, if
    /// non-empty.
    StringRef DwarfDebugProducer;

    /// The maximum version of dwarf that we should emit.
    uint16_t DwarfVersion = 4;

    /// The format of dwarf that we emit.
    dwarf::DwarfFormat DwarfFormat = dwarf::DWARF32;

    /// Honor temporary labels, this is useful for debugging semantic
    /// differences between temporary and non-temporary labels (primarily on
    /// Darwin).
    bool AllowTemporaryLabels = true;
    bool UseNamesOnTempLabels = false;

    /// The Compile Unit ID that we are currently processing.
    unsigned DwarfCompileUnitID = 0;

    /// A collection of MCPseudoProbe in the current module
    MCPseudoProbeTable PseudoProbeTable;

    // Sections are differentiated by the quadruple (section_name, group_name,
    // unique_id, link_to_symbol_name). Sections sharing the same quadruple are
    // combined into one section.
    struct ELFSectionKey {
      std::string SectionName;
      StringRef GroupName;
      StringRef LinkedToName;
      unsigned UniqueID;

      ELFSectionKey(StringRef SectionName, StringRef GroupName,
                    StringRef LinkedToName, unsigned UniqueID)
          : SectionName(SectionName), GroupName(GroupName),
            LinkedToName(LinkedToName), UniqueID(UniqueID) {}

      bool operator<(const ELFSectionKey &Other) const {
        if (SectionName != Other.SectionName)
          return SectionName < Other.SectionName;
        if (GroupName != Other.GroupName)
          return GroupName < Other.GroupName;
        if (int O = LinkedToName.compare(Other.LinkedToName))
          return O < 0;
        return UniqueID < Other.UniqueID;
      }
    };

    struct COFFSectionKey {
      std::string SectionName;
      StringRef GroupName;
      int SelectionKey;
      unsigned UniqueID;

      COFFSectionKey(StringRef SectionName, StringRef GroupName,
                     int SelectionKey, unsigned UniqueID)
          : SectionName(SectionName), GroupName(GroupName),
            SelectionKey(SelectionKey), UniqueID(UniqueID) {}

      bool operator<(const COFFSectionKey &Other) const {
        if (SectionName != Other.SectionName)
          return SectionName < Other.SectionName;
        if (GroupName != Other.GroupName)
          return GroupName < Other.GroupName;
        if (SelectionKey != Other.SelectionKey)
          return SelectionKey < Other.SelectionKey;
        return UniqueID < Other.UniqueID;
      }
    };

    struct WasmSectionKey {
      std::string SectionName;
      StringRef GroupName;
      unsigned UniqueID;

      WasmSectionKey(StringRef SectionName, StringRef GroupName,
                     unsigned UniqueID)
          : SectionName(SectionName), GroupName(GroupName), UniqueID(UniqueID) {
      }

      bool operator<(const WasmSectionKey &Other) const {
        if (SectionName != Other.SectionName)
          return SectionName < Other.SectionName;
        if (GroupName != Other.GroupName)
          return GroupName < Other.GroupName;
        return UniqueID < Other.UniqueID;
      }
    };

    struct XCOFFSectionKey {
      // Section name.
      std::string SectionName;
      // Section property.
      // For csect section, it is storage mapping class.
      // For debug section, it is section type flags.
      union {
        XCOFF::StorageMappingClass MappingClass;
        XCOFF::DwarfSectionSubtypeFlags DwarfSubtypeFlags;
      };
      bool IsCsect;

      XCOFFSectionKey(StringRef SectionName,
                      XCOFF::StorageMappingClass MappingClass)
          : SectionName(SectionName), MappingClass(MappingClass),
            IsCsect(true) {}

      XCOFFSectionKey(StringRef SectionName,
                      XCOFF::DwarfSectionSubtypeFlags DwarfSubtypeFlags)
          : SectionName(SectionName), DwarfSubtypeFlags(DwarfSubtypeFlags),
            IsCsect(false) {}

      bool operator<(const XCOFFSectionKey &Other) const {
        if (IsCsect && Other.IsCsect)
          return std::tie(SectionName, MappingClass) <
                 std::tie(Other.SectionName, Other.MappingClass);
        if (IsCsect != Other.IsCsect)
          return IsCsect;
        return std::tie(SectionName, DwarfSubtypeFlags) <
               std::tie(Other.SectionName, Other.DwarfSubtypeFlags);
      }
    };

    StringMap<MCSectionMachO *> MachOUniquingMap;
    std::map<ELFSectionKey, MCSectionELF *> ELFUniquingMap;
    std::map<COFFSectionKey, MCSectionCOFF *> COFFUniquingMap;
    std::map<std::string, MCSectionGOFF *> GOFFUniquingMap;
    std::map<WasmSectionKey, MCSectionWasm *> WasmUniquingMap;
    std::map<XCOFFSectionKey, MCSectionXCOFF *> XCOFFUniquingMap;
    StringMap<bool> RelSecNames;

    SpecificBumpPtrAllocator<MCSubtargetInfo> MCSubtargetAllocator;

    /// Do automatic reset in destructor
    bool AutoReset;

    MCTargetOptions const *TargetOptions;

    bool HadError = false;

    void reportCommon(SMLoc Loc,
                      std::function<void(SMDiagnostic &, const SourceMgr *)>);

    MCSymbol *createSymbolImpl(const StringMapEntry<bool> *Name,
                               bool CanBeUnnamed);
    MCSymbol *createSymbol(StringRef Name, bool AlwaysAddSuffix,
                           bool IsTemporary);

    MCSymbol *getOrCreateDirectionalLocalSymbol(unsigned LocalLabelVal,
                                                unsigned Instance);

    MCSectionELF *createELFSectionImpl(StringRef Section, unsigned Type,
                                       unsigned Flags, SectionKind K,
                                       unsigned EntrySize,
                                       const MCSymbolELF *Group, bool IsComdat,
                                       unsigned UniqueID,
                                       const MCSymbolELF *LinkedToSym);

    MCSymbolXCOFF *createXCOFFSymbolImpl(const StringMapEntry<bool> *Name,
                                         bool IsTemporary);

    /// Map of currently defined macros.
    StringMap<MCAsmMacro> MacroMap;

    struct ELFEntrySizeKey {
      std::string SectionName;
      unsigned Flags;
      unsigned EntrySize;

      ELFEntrySizeKey(StringRef SectionName, unsigned Flags, unsigned EntrySize)
          : SectionName(SectionName), Flags(Flags), EntrySize(EntrySize) {}

      bool operator<(const ELFEntrySizeKey &Other) const {
        if (SectionName != Other.SectionName)
          return SectionName < Other.SectionName;
        if (Flags != Other.Flags)
          return Flags < Other.Flags;
        return EntrySize < Other.EntrySize;
      }
    };

    // Symbols must be assigned to a section with a compatible entry size and
    // flags. This map is used to assign unique IDs to sections to distinguish
    // between sections with identical names but incompatible entry sizes and/or
    // flags. This can occur when a symbol is explicitly assigned to a section,
    // e.g. via __attribute__((section("myname"))).
    std::map<ELFEntrySizeKey, unsigned> ELFEntrySizeMap;

    // This set is used to record the generic mergeable section names seen.
    // These are sections that are created as mergeable e.g. .debug_str. We need
    // to avoid assigning non-mergeable symbols to these sections. It is used
    // to prevent non-mergeable symbols being explicitly assigned  to mergeable
    // sections (e.g. via _attribute_((section("myname")))).
    DenseSet<StringRef> ELFSeenGenericMergeableSections;

  public:
    explicit MCContext(const Triple &TheTriple, const MCAsmInfo *MAI,
                       const MCRegisterInfo *MRI, const MCSubtargetInfo *MSTI,
                       const SourceMgr *Mgr = nullptr,
                       MCTargetOptions const *TargetOpts = nullptr,
                       bool DoAutoReset = true);
    MCContext(const MCContext &) = delete;
    MCContext &operator=(const MCContext &) = delete;
    ~MCContext();

    Environment getObjectFileType() const { return Env; }

    const Triple &getTargetTriple() const { return TT; }
    const SourceMgr *getSourceManager() const { return SrcMgr; }

    void initInlineSourceManager();
    SourceMgr *getInlineSourceManager() {
      return InlineSrcMgr.get();
    }
    std::vector<const MDNode *> &getLocInfos() { return LocInfos; }
    void setDiagnosticHandler(DiagHandlerTy DiagHandler) {
      this->DiagHandler = DiagHandler;
    }

    void setObjectFileInfo(const MCObjectFileInfo *Mofi) { MOFI = Mofi; }

    const MCAsmInfo *getAsmInfo() const { return MAI; }

    const MCRegisterInfo *getRegisterInfo() const { return MRI; }

    const MCObjectFileInfo *getObjectFileInfo() const { return MOFI; }

    const MCSubtargetInfo *getSubtargetInfo() const { return MSTI; }

    CodeViewContext &getCVContext();

    void setAllowTemporaryLabels(bool Value) { AllowTemporaryLabels = Value; }
    void setUseNamesOnTempLabels(bool Value) { UseNamesOnTempLabels = Value; }

    /// \name Module Lifetime Management
    /// @{

    /// reset - return object to right after construction state to prepare
    /// to process a new module
    void reset();

    /// @}

    /// \name McInst Management

    /// Create and return a new MC instruction.
    MCInst *createMCInst();

    /// \name Symbol Management
    /// @{

    /// Create and return a new linker temporary symbol with a unique but
    /// unspecified name.
    MCSymbol *createLinkerPrivateTempSymbol();

    /// Create a temporary symbol with a unique name. The name will be omitted
    /// in the symbol table if UseNamesOnTempLabels is false (default except
    /// MCAsmStreamer). The overload without Name uses an unspecified name.
    MCSymbol *createTempSymbol();
    MCSymbol *createTempSymbol(const Twine &Name, bool AlwaysAddSuffix = true);

    /// Create a temporary symbol with a unique name whose name cannot be
    /// omitted in the symbol table. This is rarely used.
    MCSymbol *createNamedTempSymbol();
    MCSymbol *createNamedTempSymbol(const Twine &Name);

    /// Create the definition of a directional local symbol for numbered label
    /// (used for "1:" definitions).
    MCSymbol *createDirectionalLocalSymbol(unsigned LocalLabelVal);

    /// Create and return a directional local symbol for numbered label (used
    /// for "1b" or 1f" references).
    MCSymbol *getDirectionalLocalSymbol(unsigned LocalLabelVal, bool Before);

    /// Lookup the symbol inside with the specified \p Name.  If it exists,
    /// return it.  If not, create a forward reference and return it.
    ///
    /// \param Name - The symbol name, which must be unique across all symbols.
    MCSymbol *getOrCreateSymbol(const Twine &Name);

    /// Gets a symbol that will be defined to the final stack offset of a local
    /// variable after codegen.
    ///
    /// \param Idx - The index of a local variable passed to \@llvm.localescape.
    MCSymbol *getOrCreateFrameAllocSymbol(StringRef FuncName, unsigned Idx);

    MCSymbol *getOrCreateParentFrameOffsetSymbol(StringRef FuncName);

    MCSymbol *getOrCreateLSDASymbol(StringRef FuncName);

    /// Get the symbol for \p Name, or null.
    MCSymbol *lookupSymbol(const Twine &Name) const;

    /// Set value for a symbol.
    void setSymbolValue(MCStreamer &Streamer, StringRef Sym, uint64_t Val);

    /// getSymbols - Get a reference for the symbol table for clients that
    /// want to, for example, iterate over all symbols. 'const' because we
    /// still want any modifications to the table itself to use the MCContext
    /// APIs.
    const SymbolTable &getSymbols() const { return Symbols; }

    /// isInlineAsmLabel - Return true if the name is a label referenced in
    /// inline assembly.
    MCSymbol *getInlineAsmLabel(StringRef Name) const {
      return InlineAsmUsedLabelNames.lookup(Name);
    }

    /// registerInlineAsmLabel - Records that the name is a label referenced in
    /// inline assembly.
    void registerInlineAsmLabel(MCSymbol *Sym);

    /// @}

    /// \name Section Management
    /// @{

    enum : unsigned {
      /// Pass this value as the UniqueID during section creation to get the
      /// generic section with the given name and characteristics. The usual
      /// sections such as .text use this ID.
      GenericSectionID = ~0U
    };

    /// Return the MCSection for the specified mach-o section.  This requires
    /// the operands to be valid.
    MCSectionMachO *getMachOSection(StringRef Segment, StringRef Section,
                                    unsigned TypeAndAttributes,
                                    unsigned Reserved2, SectionKind K,
                                    const char *BeginSymName = nullptr);

    MCSectionMachO *getMachOSection(StringRef Segment, StringRef Section,
                                    unsigned TypeAndAttributes, SectionKind K,
                                    const char *BeginSymName = nullptr) {
      return getMachOSection(Segment, Section, TypeAndAttributes, 0, K,
                             BeginSymName);
    }

    MCSectionELF *getELFSection(const Twine &Section, unsigned Type,
                                unsigned Flags) {
      return getELFSection(Section, Type, Flags, 0, "", false);
    }

    MCSectionELF *getELFSection(const Twine &Section, unsigned Type,
                                unsigned Flags, unsigned EntrySize) {
      return getELFSection(Section, Type, Flags, EntrySize, "", false,
                           MCSection::NonUniqueID, nullptr);
    }

    MCSectionELF *getELFSection(const Twine &Section, unsigned Type,
                                unsigned Flags, unsigned EntrySize,
                                const Twine &Group, bool IsComdat) {
      return getELFSection(Section, Type, Flags, EntrySize, Group, IsComdat,
                           MCSection::NonUniqueID, nullptr);
    }

    MCSectionELF *getELFSection(const Twine &Section, unsigned Type,
                                unsigned Flags, unsigned EntrySize,
                                const Twine &Group, bool IsComdat,
                                unsigned UniqueID,
                                const MCSymbolELF *LinkedToSym);

    MCSectionELF *getELFSection(const Twine &Section, unsigned Type,
                                unsigned Flags, unsigned EntrySize,
                                const MCSymbolELF *Group, bool IsComdat,
                                unsigned UniqueID,
                                const MCSymbolELF *LinkedToSym);

    /// Get a section with the provided group identifier. This section is
    /// named by concatenating \p Prefix with '.' then \p Suffix. The \p Type
    /// describes the type of the section and \p Flags are used to further
    /// configure this named section.
    MCSectionELF *getELFNamedSection(const Twine &Prefix, const Twine &Suffix,
                                     unsigned Type, unsigned Flags,
                                     unsigned EntrySize = 0);

    MCSectionELF *createELFRelSection(const Twine &Name, unsigned Type,
                                      unsigned Flags, unsigned EntrySize,
                                      const MCSymbolELF *Group,
                                      const MCSectionELF *RelInfoSection);

    void renameELFSection(MCSectionELF *Section, StringRef Name);

    MCSectionELF *createELFGroupSection(const MCSymbolELF *Group,
                                        bool IsComdat);

    void recordELFMergeableSectionInfo(StringRef SectionName, unsigned Flags,
                                       unsigned UniqueID, unsigned EntrySize);

    bool isELFImplicitMergeableSectionNamePrefix(StringRef Name);

    bool isELFGenericMergeableSection(StringRef Name);

    /// Return the unique ID of the section with the given name, flags and entry
    /// size, if it exists.
    Optional<unsigned> getELFUniqueIDForEntsize(StringRef SectionName,
                                                unsigned Flags,
                                                unsigned EntrySize);

    MCSectionGOFF *getGOFFSection(StringRef Section, SectionKind Kind);

    MCSectionCOFF *getCOFFSection(StringRef Section, unsigned Characteristics,
                                  SectionKind Kind, StringRef COMDATSymName,
                                  int Selection,
                                  unsigned UniqueID = GenericSectionID,
                                  const char *BeginSymName = nullptr);

    MCSectionCOFF *getCOFFSection(StringRef Section, unsigned Characteristics,
                                  SectionKind Kind,
                                  const char *BeginSymName = nullptr);

    /// Gets or creates a section equivalent to Sec that is associated with the
    /// section containing KeySym. For example, to create a debug info section
    /// associated with an inline function, pass the normal debug info section
    /// as Sec and the function symbol as KeySym.
    MCSectionCOFF *
    getAssociativeCOFFSection(MCSectionCOFF *Sec, const MCSymbol *KeySym,
                              unsigned UniqueID = GenericSectionID);

    MCSectionWasm *getWasmSection(const Twine &Section, SectionKind K,
                                  unsigned Flags = 0) {
      return getWasmSection(Section, K, Flags, nullptr);
    }

    MCSectionWasm *getWasmSection(const Twine &Section, SectionKind K,
                                  unsigned Flags, const char *BeginSymName) {
      return getWasmSection(Section, K, Flags, "", ~0, BeginSymName);
    }

    MCSectionWasm *getWasmSection(const Twine &Section, SectionKind K,
                                  unsigned Flags, const Twine &Group,
                                  unsigned UniqueID) {
      return getWasmSection(Section, K, Flags, Group, UniqueID, nullptr);
    }

    MCSectionWasm *getWasmSection(const Twine &Section, SectionKind K,
                                  unsigned Flags, const Twine &Group,
                                  unsigned UniqueID, const char *BeginSymName);

    MCSectionWasm *getWasmSection(const Twine &Section, SectionKind K,
                                  unsigned Flags, const MCSymbolWasm *Group,
                                  unsigned UniqueID, const char *BeginSymName);

    MCSectionXCOFF *getXCOFFSection(
        StringRef Section, SectionKind K,
        Optional<XCOFF::CsectProperties> CsectProp = None,
        bool MultiSymbolsAllowed = false, const char *BeginSymName = nullptr,
        Optional<XCOFF::DwarfSectionSubtypeFlags> DwarfSubtypeFlags = None);

    // Create and save a copy of STI and return a reference to the copy.
    MCSubtargetInfo &getSubtargetCopy(const MCSubtargetInfo &STI);

    /// @}

    /// \name Dwarf Management
    /// @{

    /// Get the compilation directory for DW_AT_comp_dir
    /// The compilation directory should be set with \c setCompilationDir before
    /// calling this function. If it is unset, an empty string will be returned.
    StringRef getCompilationDir() const { return CompilationDir; }

    /// Set the compilation directory for DW_AT_comp_dir
    void setCompilationDir(StringRef S) { CompilationDir = S.str(); }

    /// Add an entry to the debug prefix map.
    void addDebugPrefixMapEntry(const std::string &From, const std::string &To);

    // Remaps all debug directory paths in-place as per the debug prefix map.
    void RemapDebugPaths();

    /// Get the main file name for use in error messages and debug
    /// info. This can be set to ensure we've got the correct file name
    /// after preprocessing or for -save-temps.
    const std::string &getMainFileName() const { return MainFileName; }

    /// Set the main file name and override the default.
    void setMainFileName(StringRef S) { MainFileName = std::string(S); }

    /// Creates an entry in the dwarf file and directory tables.
    Expected<unsigned> getDwarfFile(StringRef Directory, StringRef FileName,
                                    unsigned FileNumber,
                                    Optional<MD5::MD5Result> Checksum,
                                    Optional<StringRef> Source, unsigned CUID);

    bool isValidDwarfFileNumber(unsigned FileNumber, unsigned CUID = 0);

    const std::map<unsigned, MCDwarfLineTable> &getMCDwarfLineTables() const {
      return MCDwarfLineTablesCUMap;
    }

    MCDwarfLineTable &getMCDwarfLineTable(unsigned CUID) {
      return MCDwarfLineTablesCUMap[CUID];
    }

    const MCDwarfLineTable &getMCDwarfLineTable(unsigned CUID) const {
      auto I = MCDwarfLineTablesCUMap.find(CUID);
      assert(I != MCDwarfLineTablesCUMap.end());
      return I->second;
    }

    const SmallVectorImpl<MCDwarfFile> &getMCDwarfFiles(unsigned CUID = 0) {
      return getMCDwarfLineTable(CUID).getMCDwarfFiles();
    }

    const SmallVectorImpl<std::string> &getMCDwarfDirs(unsigned CUID = 0) {
      return getMCDwarfLineTable(CUID).getMCDwarfDirs();
    }

    unsigned getDwarfCompileUnitID() { return DwarfCompileUnitID; }

    void setDwarfCompileUnitID(unsigned CUIndex) {
      DwarfCompileUnitID = CUIndex;
    }

    /// Specifies the "root" file and directory of the compilation unit.
    /// These are "file 0" and "directory 0" in DWARF v5.
    void setMCLineTableRootFile(unsigned CUID, StringRef CompilationDir,
                                StringRef Filename,
                                Optional<MD5::MD5Result> Checksum,
                                Optional<StringRef> Source) {
      getMCDwarfLineTable(CUID).setRootFile(CompilationDir, Filename, Checksum,
                                            Source);
    }

    /// Reports whether MD5 checksum usage is consistent (all-or-none).
    bool isDwarfMD5UsageConsistent(unsigned CUID) const {
      return getMCDwarfLineTable(CUID).isMD5UsageConsistent();
    }

    /// Saves the information from the currently parsed dwarf .loc directive
    /// and sets DwarfLocSeen.  When the next instruction is assembled an entry
    /// in the line number table with this information and the address of the
    /// instruction will be created.
    void setCurrentDwarfLoc(unsigned FileNum, unsigned Line, unsigned Column,
                            unsigned Flags, unsigned Isa,
                            unsigned Discriminator) {
      CurrentDwarfLoc.setFileNum(FileNum);
      CurrentDwarfLoc.setLine(Line);
      CurrentDwarfLoc.setColumn(Column);
      CurrentDwarfLoc.setFlags(Flags);
      CurrentDwarfLoc.setIsa(Isa);
      CurrentDwarfLoc.setDiscriminator(Discriminator);
      DwarfLocSeen = true;
    }

    void clearDwarfLocSeen() { DwarfLocSeen = false; }

    bool getDwarfLocSeen() { return DwarfLocSeen; }
    const MCDwarfLoc &getCurrentDwarfLoc() { return CurrentDwarfLoc; }

    bool getGenDwarfForAssembly() { return GenDwarfForAssembly; }
    void setGenDwarfForAssembly(bool Value) { GenDwarfForAssembly = Value; }
    unsigned getGenDwarfFileNumber() { return GenDwarfFileNumber; }

    void setGenDwarfFileNumber(unsigned FileNumber) {
      GenDwarfFileNumber = FileNumber;
    }

    /// Specifies information about the "root file" for assembler clients
    /// (e.g., llvm-mc). Assumes compilation dir etc. have been set up.
    void setGenDwarfRootFile(StringRef FileName, StringRef Buffer);

    const SetVector<MCSection *> &getGenDwarfSectionSyms() {
      return SectionsForRanges;
    }

    bool addGenDwarfSection(MCSection *Sec) {
      return SectionsForRanges.insert(Sec);
    }

    void finalizeDwarfSections(MCStreamer &MCOS);

    const std::vector<MCGenDwarfLabelEntry> &getMCGenDwarfLabelEntries() const {
      return MCGenDwarfLabelEntries;
    }

    void addMCGenDwarfLabelEntry(const MCGenDwarfLabelEntry &E) {
      MCGenDwarfLabelEntries.push_back(E);
    }

    void setDwarfDebugFlags(StringRef S) { DwarfDebugFlags = S; }
    StringRef getDwarfDebugFlags() { return DwarfDebugFlags; }

    void setDwarfDebugProducer(StringRef S) { DwarfDebugProducer = S; }
    StringRef getDwarfDebugProducer() { return DwarfDebugProducer; }

    void setDwarfFormat(dwarf::DwarfFormat f) { DwarfFormat = f; }
    dwarf::DwarfFormat getDwarfFormat() const { return DwarfFormat; }

    void setDwarfVersion(uint16_t v) { DwarfVersion = v; }
    uint16_t getDwarfVersion() const { return DwarfVersion; }

    /// @}

    char *getSecureLogFile() { return SecureLogFile; }
    raw_fd_ostream *getSecureLog() { return SecureLog.get(); }

    void setSecureLog(std::unique_ptr<raw_fd_ostream> Value) {
      SecureLog = std::move(Value);
    }

    bool getSecureLogUsed() { return SecureLogUsed; }
    void setSecureLogUsed(bool Value) { SecureLogUsed = Value; }

    void *allocate(unsigned Size, unsigned Align = 8) {
      return Allocator.Allocate(Size, Align);
    }

    void deallocate(void *Ptr) {}

    bool hadError() { return HadError; }
    void diagnose(const SMDiagnostic &SMD);
    void reportError(SMLoc L, const Twine &Msg);
    void reportWarning(SMLoc L, const Twine &Msg);

    const MCAsmMacro *lookupMacro(StringRef Name) {
      StringMap<MCAsmMacro>::iterator I = MacroMap.find(Name);
      return (I == MacroMap.end()) ? nullptr : &I->getValue();
    }

    void defineMacro(StringRef Name, MCAsmMacro Macro) {
      MacroMap.insert(std::make_pair(Name, std::move(Macro)));
    }

    void undefineMacro(StringRef Name) { MacroMap.erase(Name); }

    MCPseudoProbeTable &getMCPseudoProbeTable() { return PseudoProbeTable; }
  };

} // end namespace llvm

// operator new and delete aren't allowed inside namespaces.
// The throw specifications are mandated by the standard.
/// Placement new for using the MCContext's allocator.
///
/// This placement form of operator new uses the MCContext's allocator for
/// obtaining memory. It is a non-throwing new, which means that it returns
/// null on error. (If that is what the allocator does. The current does, so if
/// this ever changes, this operator will have to be changed, too.)
/// Usage looks like this (assuming there's an MCContext 'Context' in scope):
/// \code
/// // Default alignment (8)
/// IntegerLiteral *Ex = new (Context) IntegerLiteral(arguments);
/// // Specific alignment
/// IntegerLiteral *Ex2 = new (Context, 4) IntegerLiteral(arguments);
/// \endcode
/// Please note that you cannot use delete on the pointer; it must be
/// deallocated using an explicit destructor call followed by
/// \c Context.Deallocate(Ptr).
///
/// \param Bytes The number of bytes to allocate. Calculated by the compiler.
/// \param C The MCContext that provides the allocator.
/// \param Alignment The alignment of the allocated memory (if the underlying
///                  allocator supports it).
/// \return The allocated memory. Could be NULL.
inline void *operator new(size_t Bytes, llvm::MCContext &C,
                          size_t Alignment = 8) noexcept {
  return C.allocate(Bytes, Alignment);
}
/// Placement delete companion to the new above.
///
/// This operator is just a companion to the new above. There is no way of
/// invoking it directly; see the new operator for more details. This operator
/// is called implicitly by the compiler if a placement new expression using
/// the MCContext throws in the object constructor.
inline void operator delete(void *Ptr, llvm::MCContext &C, size_t) noexcept {
  C.deallocate(Ptr);
}

/// This placement form of operator new[] uses the MCContext's allocator for
/// obtaining memory. It is a non-throwing new[], which means that it returns
/// null on error.
/// Usage looks like this (assuming there's an MCContext 'Context' in scope):
/// \code
/// // Default alignment (8)
/// char *data = new (Context) char[10];
/// // Specific alignment
/// char *data = new (Context, 4) char[10];
/// \endcode
/// Please note that you cannot use delete on the pointer; it must be
/// deallocated using an explicit destructor call followed by
/// \c Context.Deallocate(Ptr).
///
/// \param Bytes The number of bytes to allocate. Calculated by the compiler.
/// \param C The MCContext that provides the allocator.
/// \param Alignment The alignment of the allocated memory (if the underlying
///                  allocator supports it).
/// \return The allocated memory. Could be NULL.
inline void *operator new[](size_t Bytes, llvm::MCContext &C,
                            size_t Alignment = 8) noexcept {
  return C.allocate(Bytes, Alignment);
}

/// Placement delete[] companion to the new[] above.
///
/// This operator is just a companion to the new[] above. There is no way of
/// invoking it directly; see the new[] operator for more details. This operator
/// is called implicitly by the compiler if a placement new[] expression using
/// the MCContext throws in the object constructor.
inline void operator delete[](void *Ptr, llvm::MCContext &C) noexcept {
  C.deallocate(Ptr);
}

#endif // LLVM_MC_MCCONTEXT_H
