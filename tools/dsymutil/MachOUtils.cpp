//===-- MachOUtils.cpp - Mach-o specific helpers for dsymutil  ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "MachOUtils.h"
#include "BinaryHolder.h"
#include "DebugMap.h"
#include "LinkUtils.h"
#include "NonRelocatableStringpool.h"
#include "llvm/MC/MCAsmLayout.h"
#include "llvm/MC/MCMachObjectWriter.h"
#include "llvm/MC/MCObjectStreamer.h"
#include "llvm/MC/MCSectionMachO.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Object/MachO.h"
#include "llvm/Support/FileUtilities.h"
#include "llvm/Support/Program.h"
#include "llvm/Support/WithColor.h"
#include "llvm/Support/raw_ostream.h"

namespace llvm {
namespace dsymutil {
namespace MachOUtils {

llvm::Error ArchAndFile::createTempFile() {
  llvm::SmallString<128> TmpModel;
  llvm::sys::path::system_temp_directory(true, TmpModel);
  llvm::sys::path::append(TmpModel, "dsym.tmp%%%%%.dwarf");
  Expected<sys::fs::TempFile> T = sys::fs::TempFile::create(TmpModel);

  if (!T)
    return T.takeError();

  File = std::make_unique<sys::fs::TempFile>(std::move(*T));
  return Error::success();
}

llvm::StringRef ArchAndFile::path() const { return File->TmpName; }

ArchAndFile::~ArchAndFile() {
  if (File)
    if (auto E = File->discard())
      llvm::consumeError(std::move(E));
}

std::string getArchName(StringRef Arch) {
  if (Arch.startswith("thumb"))
    return (llvm::Twine("arm") + Arch.drop_front(5)).str();
  return Arch;
}

static bool runLipo(StringRef SDKPath, SmallVectorImpl<StringRef> &Args) {
  auto Path = sys::findProgramByName("lipo", makeArrayRef(SDKPath));
  if (!Path)
    Path = sys::findProgramByName("lipo");

  if (!Path) {
    WithColor::error() << "lipo: " << Path.getError().message() << "\n";
    return false;
  }

  std::string ErrMsg;
  int result = sys::ExecuteAndWait(*Path, Args, None, {}, 0, 0, &ErrMsg);
  if (result) {
    WithColor::error() << "lipo: " << ErrMsg << "\n";
    return false;
  }

  return true;
}

bool generateUniversalBinary(SmallVectorImpl<ArchAndFile> &ArchFiles,
                             StringRef OutputFileName,
                             const LinkOptions &Options, StringRef SDKPath) {
  // No need to merge one file into a universal fat binary.
  if (ArchFiles.size() == 1) {
    if (auto E = ArchFiles.front().File->keep(OutputFileName)) {
      WithColor::error() << "while keeping " << ArchFiles.front().path()
                         << " as " << OutputFileName << ": "
                         << toString(std::move(E)) << "\n";
      return false;
    }
    return true;
  }

  SmallVector<StringRef, 8> Args;
  Args.push_back("lipo");
  Args.push_back("-create");

  for (auto &Thin : ArchFiles)
    Args.push_back(Thin.path());

  // Align segments to match dsymutil-classic alignment
  for (auto &Thin : ArchFiles) {
    Thin.Arch = getArchName(Thin.Arch);
    Args.push_back("-segalign");
    Args.push_back(Thin.Arch);
    Args.push_back("20");
  }

  Args.push_back("-output");
  Args.push_back(OutputFileName.data());

  if (Options.Verbose) {
    outs() << "Running lipo\n";
    for (auto Arg : Args)
      outs() << ' ' << Arg;
    outs() << "\n";
  }

  return Options.NoOutput ? true : runLipo(SDKPath, Args);
}

// Return a MachO::segment_command_64 that holds the same values as the passed
// MachO::segment_command. We do that to avoid having to duplicate the logic
// for 32bits and 64bits segments.
struct MachO::segment_command_64 adaptFrom32bits(MachO::segment_command Seg) {
  MachO::segment_command_64 Seg64;
  Seg64.cmd = Seg.cmd;
  Seg64.cmdsize = Seg.cmdsize;
  memcpy(Seg64.segname, Seg.segname, sizeof(Seg.segname));
  Seg64.vmaddr = Seg.vmaddr;
  Seg64.vmsize = Seg.vmsize;
  Seg64.fileoff = Seg.fileoff;
  Seg64.filesize = Seg.filesize;
  Seg64.maxprot = Seg.maxprot;
  Seg64.initprot = Seg.initprot;
  Seg64.nsects = Seg.nsects;
  Seg64.flags = Seg.flags;
  return Seg64;
}

// Iterate on all \a Obj segments, and apply \a Handler to them.
template <typename FunctionTy>
static void iterateOnSegments(const object::MachOObjectFile &Obj,
                              FunctionTy Handler) {
  for (const auto &LCI : Obj.load_commands()) {
    MachO::segment_command_64 Segment;
    if (LCI.C.cmd == MachO::LC_SEGMENT)
      Segment = adaptFrom32bits(Obj.getSegmentLoadCommand(LCI));
    else if (LCI.C.cmd == MachO::LC_SEGMENT_64)
      Segment = Obj.getSegment64LoadCommand(LCI);
    else
      continue;

    Handler(Segment);
  }
}

// Transfer the symbols described by \a NList to \a NewSymtab which is just the
// raw contents of the symbol table for the dSYM companion file. \returns
// whether the symbol was transferred or not.
template <typename NListTy>
static bool transferSymbol(NListTy NList, bool IsLittleEndian,
                           StringRef Strings, SmallVectorImpl<char> &NewSymtab,
                           NonRelocatableStringpool &NewStrings,
                           bool &InDebugNote) {
  // Do not transfer undefined symbols, we want real addresses.
  if ((NList.n_type & MachO::N_TYPE) == MachO::N_UNDF)
    return false;

  StringRef Name = StringRef(Strings.begin() + NList.n_strx);
  if (InDebugNote) {
    InDebugNote =
        (NList.n_type != MachO::N_SO) || (!Name.empty() && Name[0] != '\0');
    return false;
  } else if (NList.n_type == MachO::N_SO) {
    InDebugNote = true;
    return false;
  }

  // FIXME: The + 1 is here to mimic dsymutil-classic that has 2 empty
  // strings at the start of the generated string table (There is
  // corresponding code in the string table emission).
  NList.n_strx = NewStrings.getStringOffset(Name) + 1;
  if (IsLittleEndian != sys::IsLittleEndianHost)
    MachO::swapStruct(NList);

  NewSymtab.append(reinterpret_cast<char *>(&NList),
                   reinterpret_cast<char *>(&NList + 1));
  return true;
}

// Wrapper around transferSymbol to transfer all of \a Obj symbols
// to \a NewSymtab. This function does not write in the output file.
// \returns the number of symbols in \a NewSymtab.
static unsigned transferSymbols(const object::MachOObjectFile &Obj,
                                SmallVectorImpl<char> &NewSymtab,
                                NonRelocatableStringpool &NewStrings) {
  unsigned Syms = 0;
  StringRef Strings = Obj.getStringTableData();
  bool IsLittleEndian = Obj.isLittleEndian();
  bool InDebugNote = false;

  if (Obj.is64Bit()) {
    for (const object::SymbolRef &Symbol : Obj.symbols()) {
      object::DataRefImpl DRI = Symbol.getRawDataRefImpl();
      if (transferSymbol(Obj.getSymbol64TableEntry(DRI), IsLittleEndian,
                         Strings, NewSymtab, NewStrings, InDebugNote))
        ++Syms;
    }
  } else {
    for (const object::SymbolRef &Symbol : Obj.symbols()) {
      object::DataRefImpl DRI = Symbol.getRawDataRefImpl();
      if (transferSymbol(Obj.getSymbolTableEntry(DRI), IsLittleEndian, Strings,
                         NewSymtab, NewStrings, InDebugNote))
        ++Syms;
    }
  }
  return Syms;
}

static MachO::section
getSection(const object::MachOObjectFile &Obj,
           const MachO::segment_command &Seg,
           const object::MachOObjectFile::LoadCommandInfo &LCI, unsigned Idx) {
  return Obj.getSection(LCI, Idx);
}

static MachO::section_64
getSection(const object::MachOObjectFile &Obj,
           const MachO::segment_command_64 &Seg,
           const object::MachOObjectFile::LoadCommandInfo &LCI, unsigned Idx) {
  return Obj.getSection64(LCI, Idx);
}

// Transfer \a Segment from \a Obj to the output file. This calls into \a Writer
// to write these load commands directly in the output file at the current
// position.
// The function also tries to find a hole in the address map to fit the __DWARF
// segment of \a DwarfSegmentSize size. \a EndAddress is updated to point at the
// highest segment address.
// When the __LINKEDIT segment is transferred, its offset and size are set resp.
// to \a LinkeditOffset and \a LinkeditSize.
template <typename SegmentTy>
static void transferSegmentAndSections(
    const object::MachOObjectFile::LoadCommandInfo &LCI, SegmentTy Segment,
    const object::MachOObjectFile &Obj, MachObjectWriter &Writer,
    uint64_t LinkeditOffset, uint64_t LinkeditSize, uint64_t DwarfSegmentSize,
    uint64_t &GapForDwarf, uint64_t &EndAddress) {
  if (StringRef("__DWARF") == Segment.segname)
    return;

  Segment.fileoff = Segment.filesize = 0;

  if (StringRef("__LINKEDIT") == Segment.segname) {
    Segment.fileoff = LinkeditOffset;
    Segment.filesize = LinkeditSize;
    // Resize vmsize by rounding to the page size.
    Segment.vmsize = alignTo(LinkeditSize, 0x1000);
  }

  // Check if the end address of the last segment and our current
  // start address leave a sufficient gap to store the __DWARF
  // segment.
  uint64_t PrevEndAddress = EndAddress;
  EndAddress = alignTo(EndAddress, 0x1000);
  if (GapForDwarf == UINT64_MAX && Segment.vmaddr > EndAddress &&
      Segment.vmaddr - EndAddress >= DwarfSegmentSize)
    GapForDwarf = EndAddress;

  // The segments are not necessarily sorted by their vmaddr.
  EndAddress =
      std::max<uint64_t>(PrevEndAddress, Segment.vmaddr + Segment.vmsize);
  unsigned nsects = Segment.nsects;
  if (Obj.isLittleEndian() != sys::IsLittleEndianHost)
    MachO::swapStruct(Segment);
  Writer.W.OS.write(reinterpret_cast<char *>(&Segment), sizeof(Segment));
  for (unsigned i = 0; i < nsects; ++i) {
    auto Sect = getSection(Obj, Segment, LCI, i);
    Sect.offset = Sect.reloff = Sect.nreloc = 0;
    if (Obj.isLittleEndian() != sys::IsLittleEndianHost)
      MachO::swapStruct(Sect);
    Writer.W.OS.write(reinterpret_cast<char *>(&Sect), sizeof(Sect));
  }
}

// Write the __DWARF segment load command to the output file.
static void createDwarfSegment(uint64_t VMAddr, uint64_t FileOffset,
                               uint64_t FileSize, unsigned NumSections,
                               MCAsmLayout &Layout, MachObjectWriter &Writer) {
  Writer.writeSegmentLoadCommand("__DWARF", NumSections, VMAddr,
                                 alignTo(FileSize, 0x1000), FileOffset,
                                 FileSize, /* MaxProt */ 7,
                                 /* InitProt =*/3);

  for (unsigned int i = 0, n = Layout.getSectionOrder().size(); i != n; ++i) {
    MCSection *Sec = Layout.getSectionOrder()[i];
    if (Sec->begin() == Sec->end() || !Layout.getSectionFileSize(Sec))
      continue;

    unsigned Align = Sec->getAlignment();
    if (Align > 1) {
      VMAddr = alignTo(VMAddr, Align);
      FileOffset = alignTo(FileOffset, Align);
    }
    Writer.writeSection(Layout, *Sec, VMAddr, FileOffset, 0, 0, 0);

    FileOffset += Layout.getSectionAddressSize(Sec);
    VMAddr += Layout.getSectionAddressSize(Sec);
  }
}

static bool isExecutable(const object::MachOObjectFile &Obj) {
  if (Obj.is64Bit())
    return Obj.getHeader64().filetype != MachO::MH_OBJECT;
  else
    return Obj.getHeader().filetype != MachO::MH_OBJECT;
}

static bool hasLinkEditSegment(const object::MachOObjectFile &Obj) {
  bool HasLinkEditSegment = false;
  iterateOnSegments(Obj, [&](const MachO::segment_command_64 &Segment) {
    if (StringRef("__LINKEDIT") == Segment.segname)
      HasLinkEditSegment = true;
  });
  return HasLinkEditSegment;
}

static unsigned segmentLoadCommandSize(bool Is64Bit, unsigned NumSections) {
  if (Is64Bit)
    return sizeof(MachO::segment_command_64) +
           NumSections * sizeof(MachO::section_64);

  return sizeof(MachO::segment_command) + NumSections * sizeof(MachO::section);
}

// Stream a dSYM companion binary file corresponding to the binary referenced
// by \a DM to \a OutFile. The passed \a MS MCStreamer is setup to write to
// \a OutFile and it must be using a MachObjectWriter object to do so.
bool generateDsymCompanion(const DebugMap &DM, SymbolMapTranslator &Translator,
                           MCStreamer &MS, raw_fd_ostream &OutFile) {
  auto &ObjectStreamer = static_cast<MCObjectStreamer &>(MS);
  MCAssembler &MCAsm = ObjectStreamer.getAssembler();
  auto &Writer = static_cast<MachObjectWriter &>(MCAsm.getWriter());

  // Layout but don't emit.
  ObjectStreamer.flushPendingLabels();
  MCAsmLayout Layout(MCAsm);
  MCAsm.layout(Layout);

  BinaryHolder InputBinaryHolder(false);

  auto ObjectEntry = InputBinaryHolder.getObjectEntry(DM.getBinaryPath());
  if (!ObjectEntry) {
    auto Err = ObjectEntry.takeError();
    return error(Twine("opening ") + DM.getBinaryPath() + ": " +
                     toString(std::move(Err)),
                 "output file streaming");
  }

  auto Object =
      ObjectEntry->getObjectAs<object::MachOObjectFile>(DM.getTriple());
  if (!Object) {
    auto Err = Object.takeError();
    return error(Twine("opening ") + DM.getBinaryPath() + ": " +
                     toString(std::move(Err)),
                 "output file streaming");
  }

  auto &InputBinary = *Object;

  bool Is64Bit = Writer.is64Bit();
  MachO::symtab_command SymtabCmd = InputBinary.getSymtabLoadCommand();

  // Compute the number of load commands we will need.
  unsigned LoadCommandSize = 0;
  unsigned NumLoadCommands = 0;

  // Get LC_UUID and LC_BUILD_VERSION.
  MachO::uuid_command UUIDCmd;
  SmallVector<MachO::build_version_command, 2> BuildVersionCmd;
  memset(&UUIDCmd, 0, sizeof(UUIDCmd));
  for (auto &LCI : InputBinary.load_commands()) {
    switch (LCI.C.cmd) {
    case MachO::LC_UUID:
      if (UUIDCmd.cmd)
        return error("Binary contains more than one UUID");
      UUIDCmd = InputBinary.getUuidCommand(LCI);
      ++NumLoadCommands;
      LoadCommandSize += sizeof(UUIDCmd);
      break;
   case MachO::LC_BUILD_VERSION: {
      MachO::build_version_command Cmd;
      memset(&Cmd, 0, sizeof(Cmd));
      Cmd = InputBinary.getBuildVersionLoadCommand(LCI);
      ++NumLoadCommands;
      LoadCommandSize += sizeof(Cmd);
      // LLDB doesn't care about the build tools for now.
      Cmd.ntools = 0;
      BuildVersionCmd.push_back(Cmd);
      break;
    }
    default:
      break;
    }
  }

  // If we have a valid symtab to copy, do it.
  bool ShouldEmitSymtab =
      isExecutable(InputBinary) && hasLinkEditSegment(InputBinary);
  if (ShouldEmitSymtab) {
    LoadCommandSize += sizeof(MachO::symtab_command);
    ++NumLoadCommands;
  }

  unsigned HeaderSize =
      Is64Bit ? sizeof(MachO::mach_header_64) : sizeof(MachO::mach_header);
  // We will copy every segment that isn't __DWARF.
  iterateOnSegments(InputBinary, [&](const MachO::segment_command_64 &Segment) {
    if (StringRef("__DWARF") == Segment.segname)
      return;

    ++NumLoadCommands;
    LoadCommandSize += segmentLoadCommandSize(Is64Bit, Segment.nsects);
  });

  // We will add our own brand new __DWARF segment if we have debug
  // info.
  unsigned NumDwarfSections = 0;
  uint64_t DwarfSegmentSize = 0;

  for (unsigned int i = 0, n = Layout.getSectionOrder().size(); i != n; ++i) {
    MCSection *Sec = Layout.getSectionOrder()[i];
    if (Sec->begin() == Sec->end())
      continue;

    if (uint64_t Size = Layout.getSectionFileSize(Sec)) {
      DwarfSegmentSize = alignTo(DwarfSegmentSize, Sec->getAlignment());
      DwarfSegmentSize += Size;
      ++NumDwarfSections;
    }
  }

  if (NumDwarfSections) {
    ++NumLoadCommands;
    LoadCommandSize += segmentLoadCommandSize(Is64Bit, NumDwarfSections);
  }

  SmallString<0> NewSymtab;
  NonRelocatableStringpool NewStrings(Translator);
  unsigned NListSize = Is64Bit ? sizeof(MachO::nlist_64) : sizeof(MachO::nlist);
  unsigned NumSyms = 0;
  uint64_t NewStringsSize = 0;
  if (ShouldEmitSymtab) {
    NewSymtab.reserve(SymtabCmd.nsyms * NListSize / 2);
    NumSyms = transferSymbols(InputBinary, NewSymtab, NewStrings);
    NewStringsSize = NewStrings.getSize() + 1;
  }

  uint64_t SymtabStart = LoadCommandSize;
  SymtabStart += HeaderSize;
  SymtabStart = alignTo(SymtabStart, 0x1000);

  // We gathered all the information we need, start emitting the output file.
  Writer.writeHeader(MachO::MH_DSYM, NumLoadCommands, LoadCommandSize, false);

  // Write the load commands.
  assert(OutFile.tell() == HeaderSize);
  if (UUIDCmd.cmd != 0) {
    Writer.W.write<uint32_t>(UUIDCmd.cmd);
    Writer.W.write<uint32_t>(sizeof(UUIDCmd));
    OutFile.write(reinterpret_cast<const char *>(UUIDCmd.uuid), 16);
    assert(OutFile.tell() == HeaderSize + sizeof(UUIDCmd));
  }
  for (auto Cmd : BuildVersionCmd) {
    Writer.W.write<uint32_t>(Cmd.cmd);
    Writer.W.write<uint32_t>(sizeof(Cmd));
    Writer.W.write<uint32_t>(Cmd.platform);
    Writer.W.write<uint32_t>(Cmd.minos);
    Writer.W.write<uint32_t>(Cmd.sdk);
    Writer.W.write<uint32_t>(Cmd.ntools);
  }

  assert(SymtabCmd.cmd && "No symbol table.");
  uint64_t StringStart = SymtabStart + NumSyms * NListSize;
  if (ShouldEmitSymtab)
    Writer.writeSymtabLoadCommand(SymtabStart, NumSyms, StringStart,
                                  NewStringsSize);

  uint64_t DwarfSegmentStart = StringStart + NewStringsSize;
  DwarfSegmentStart = alignTo(DwarfSegmentStart, 0x1000);

  // Write the load commands for the segments and sections we 'import' from
  // the original binary.
  uint64_t EndAddress = 0;
  uint64_t GapForDwarf = UINT64_MAX;
  for (auto &LCI : InputBinary.load_commands()) {
    if (LCI.C.cmd == MachO::LC_SEGMENT)
      transferSegmentAndSections(LCI, InputBinary.getSegmentLoadCommand(LCI),
                                 InputBinary, Writer, SymtabStart,
                                 StringStart + NewStringsSize - SymtabStart,
                                 DwarfSegmentSize, GapForDwarf, EndAddress);
    else if (LCI.C.cmd == MachO::LC_SEGMENT_64)
      transferSegmentAndSections(LCI, InputBinary.getSegment64LoadCommand(LCI),
                                 InputBinary, Writer, SymtabStart,
                                 StringStart + NewStringsSize - SymtabStart,
                                 DwarfSegmentSize, GapForDwarf, EndAddress);
  }

  uint64_t DwarfVMAddr = alignTo(EndAddress, 0x1000);
  uint64_t DwarfVMMax = Is64Bit ? UINT64_MAX : UINT32_MAX;
  if (DwarfVMAddr + DwarfSegmentSize > DwarfVMMax ||
      DwarfVMAddr + DwarfSegmentSize < DwarfVMAddr /* Overflow */) {
    // There is no room for the __DWARF segment at the end of the
    // address space. Look through segments to find a gap.
    DwarfVMAddr = GapForDwarf;
    if (DwarfVMAddr == UINT64_MAX)
      warn("not enough VM space for the __DWARF segment.",
           "output file streaming");
  }

  // Write the load command for the __DWARF segment.
  createDwarfSegment(DwarfVMAddr, DwarfSegmentStart, DwarfSegmentSize,
                     NumDwarfSections, Layout, Writer);

  assert(OutFile.tell() == LoadCommandSize + HeaderSize);
  OutFile.write_zeros(SymtabStart - (LoadCommandSize + HeaderSize));
  assert(OutFile.tell() == SymtabStart);

  // Transfer symbols.
  if (ShouldEmitSymtab) {
    OutFile << NewSymtab.str();
    assert(OutFile.tell() == StringStart);

    // Transfer string table.
    // FIXME: The NonRelocatableStringpool starts with an empty string, but
    // dsymutil-classic starts the reconstructed string table with 2 of these.
    // Reproduce that behavior for now (there is corresponding code in
    // transferSymbol).
    OutFile << '\0';
    std::vector<DwarfStringPoolEntryRef> Strings =
        NewStrings.getEntriesForEmission();
    for (auto EntryRef : Strings) {
      OutFile.write(EntryRef.getString().data(),
                    EntryRef.getString().size() + 1);
    }
  }

  assert(OutFile.tell() == StringStart + NewStringsSize);

  // Pad till the Dwarf segment start.
  OutFile.write_zeros(DwarfSegmentStart - (StringStart + NewStringsSize));
  assert(OutFile.tell() == DwarfSegmentStart);

  // Emit the Dwarf sections contents.
  for (const MCSection &Sec : MCAsm) {
    if (Sec.begin() == Sec.end())
      continue;

    uint64_t Pos = OutFile.tell();
    OutFile.write_zeros(alignTo(Pos, Sec.getAlignment()) - Pos);
    MCAsm.writeSectionData(OutFile, &Sec, Layout);
  }

  return true;
}
} // namespace MachOUtils
} // namespace dsymutil
} // namespace llvm
