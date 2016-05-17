//===- MachOYAML.cpp - MachO YAMLIO implementation ------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines classes for handling the YAML representation of MachO.
//
//===----------------------------------------------------------------------===//

#include "llvm/ObjectYAML/MachOYAML.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Format.h"

#include <string.h> // For memcpy and memset.

namespace llvm {

MachOYAML::LoadCommand::~LoadCommand() {}

namespace yaml {

void ScalarTraits<char_16>::output(const char_16 &Val, void *,
                                   llvm::raw_ostream &Out) {
  Out << Val;
}

StringRef ScalarTraits<char_16>::input(StringRef Scalar, void *, char_16 &Val) {
  size_t CopySize = 16 >= Scalar.size() ? 16 : Scalar.size();
  memcpy((void *)Val, Scalar.data(), CopySize);

  if (Scalar.size() < 16) {
    memset((void *)&Val[Scalar.size()], 0, 16 - Scalar.size());
  }

  return StringRef();
}

bool ScalarTraits<char_16>::mustQuote(StringRef S) { return needsQuotes(S); }

void ScalarTraits<uuid_t>::output(const uuid_t &Val, void *,
                                  llvm::raw_ostream &Out) {
  for (int Idx = 0; Idx < 16; ++Idx) {
    Out << format("%02" PRIX32, Val[Idx]);
    if (Idx == 3 || Idx == 5 || Idx == 7 || Idx == 9)
      Out << "-";
  }
}

StringRef ScalarTraits<uuid_t>::input(StringRef Scalar, void *, uuid_t &Val) {
  size_t OutIdx = 0;
  for (size_t Idx = 0; Idx < Scalar.size(); ++Idx) {
    if (Scalar[Idx] == '-' || OutIdx >= 16)
      continue;
    unsigned long long TempInt;
    if (getAsUnsignedInteger(Scalar.slice(Idx, Idx + 2), 16, TempInt))
      return "invalid number";
    if (TempInt > 0xFF)
      return "out of range number";
    Val[OutIdx] = static_cast<uint8_t>(TempInt);
    ++Idx; // increment idx an extra time because we're consuming 2 chars
    ++OutIdx;
  }
  return StringRef();
}

bool ScalarTraits<uuid_t>::mustQuote(StringRef S) { return needsQuotes(S); }

void MappingTraits<MachOYAML::FileHeader>::mapping(
    IO &IO, MachOYAML::FileHeader &FileHdr) {
  IO.mapRequired("magic", FileHdr.magic);
  IO.mapRequired("cputype", FileHdr.cputype);
  IO.mapRequired("cpusubtype", FileHdr.cpusubtype);
  IO.mapRequired("filetype", FileHdr.filetype);
  IO.mapRequired("ncmds", FileHdr.ncmds);
  IO.mapRequired("sizeofcmds", FileHdr.sizeofcmds);
  IO.mapRequired("flags", FileHdr.flags);
  IO.mapOptional("reserved", FileHdr.reserved,
                 static_cast<llvm::yaml::Hex32>(0xDEADBEEFu));
}

void MappingTraits<MachOYAML::Object>::mapping(IO &IO,
                                               MachOYAML::Object &Object) {
  // If the context isn't already set, tag the document as !mach-o.
  // For Fat files there will be a different tag so they can be differentiated.
  if (!IO.getContext()) {
    IO.setContext(&Object);
    IO.mapTag("!mach-o", true);
  }
  IO.mapRequired("FileHeader", Object.Header);
  IO.mapOptional("LoadCommands", Object.LoadCommands);
  IO.setContext(nullptr);
}

void MappingTraits<MachOYAML::LoadCommand>::mapping(
    IO &IO, MachOYAML::LoadCommand &LoadCommand) {
  IO.mapRequired(
      "cmd", (MachO::LoadCommandType &)LoadCommand.Data.load_command_data.cmd);
  IO.mapRequired("cmdsize", LoadCommand.Data.load_command_data.cmdsize);

#define HANDLE_LOAD_COMMAND(LCName, LCValue, LCStruct)                         \
  case MachO::LCName:                                                          \
    MappingTraits<MachO::LCStruct>::mapping(IO,                                \
                                            LoadCommand.Data.LCStruct##_data); \
    break;

  switch (LoadCommand.Data.load_command_data.cmd) {
#include "llvm/Support/MachO.def"
  }
  if (LoadCommand.Data.load_command_data.cmd == MachO::LC_SEGMENT ||
      LoadCommand.Data.load_command_data.cmd == MachO::LC_SEGMENT_64) {
    IO.mapOptional("Sections", LoadCommand.Sections);
  }
}

void MappingTraits<MachO::dyld_info_command>::mapping(
    IO &IO, MachO::dyld_info_command &LoadCommand) {
  IO.mapRequired("rebase_off", LoadCommand.rebase_off);
  IO.mapRequired("rebase_size", LoadCommand.rebase_size);
  IO.mapRequired("bind_off", LoadCommand.bind_size);
  IO.mapRequired("weak_bind_off", LoadCommand.weak_bind_off);
  IO.mapRequired("weak_bind_size", LoadCommand.weak_bind_size);
  IO.mapRequired("lazy_bind_off", LoadCommand.lazy_bind_size);
  IO.mapRequired("export_off", LoadCommand.export_off);
  IO.mapRequired("export_size", LoadCommand.export_size);
}

void MappingTraits<MachOYAML::Section>::mapping(IO &IO,
                                                MachOYAML::Section &Section) {
  IO.mapRequired("sectname", Section.sectname);
  IO.mapRequired("segname", Section.segname);
  IO.mapRequired("addr", Section.addr);
  IO.mapRequired("size", Section.size);
  IO.mapRequired("offset", Section.offset);
  IO.mapRequired("align", Section.align);
  IO.mapRequired("reloff", Section.reloff);
  IO.mapRequired("nreloc", Section.nreloc);
  IO.mapRequired("flags", Section.flags);
  IO.mapRequired("reserved1", Section.reserved1);
  IO.mapRequired("reserved2", Section.reserved2);
  IO.mapOptional("reserved3", Section.reserved3);
}

void MappingTraits<MachO::dylib>::mapping(IO &IO, MachO::dylib &DylibStruct) {
  IO.mapRequired("name", DylibStruct.name);
  IO.mapRequired("timestamp", DylibStruct.timestamp);
  IO.mapRequired("current_version", DylibStruct.current_version);
  IO.mapRequired("compatibility_version", DylibStruct.compatibility_version);
}

void MappingTraits<MachO::dylib_command>::mapping(
    IO &IO, MachO::dylib_command &LoadCommand) {
  IO.mapRequired("dylib", LoadCommand.dylib);
}

void MappingTraits<MachO::dylinker_command>::mapping(
    IO &IO, MachO::dylinker_command &LoadCommand) {

  IO.mapRequired("name", LoadCommand.name);
}

void MappingTraits<MachO::dysymtab_command>::mapping(
    IO &IO, MachO::dysymtab_command &LoadCommand) {

  IO.mapRequired("ilocalsym", LoadCommand.ilocalsym);
  IO.mapRequired("nlocalsym", LoadCommand.nlocalsym);
  IO.mapRequired("iextdefsym", LoadCommand.iextdefsym);
  IO.mapRequired("nextdefsym", LoadCommand.nextdefsym);
  IO.mapRequired("iundefsym", LoadCommand.iundefsym);
  IO.mapRequired("nundefsym", LoadCommand.nundefsym);
  IO.mapRequired("tocoff", LoadCommand.tocoff);
  IO.mapRequired("ntoc", LoadCommand.ntoc);
  IO.mapRequired("modtaboff", LoadCommand.modtaboff);
  IO.mapRequired("nmodtab", LoadCommand.nmodtab);
  IO.mapRequired("extrefsymoff", LoadCommand.extrefsymoff);
  IO.mapRequired("nextrefsyms", LoadCommand.nextrefsyms);
  IO.mapRequired("indirectsymoff", LoadCommand.indirectsymoff);
  IO.mapRequired("nindirectsyms", LoadCommand.nindirectsyms);
  IO.mapRequired("extreloff", LoadCommand.extreloff);
  IO.mapRequired("nextrel", LoadCommand.nextrel);
  IO.mapRequired("locreloff", LoadCommand.locreloff);
  IO.mapRequired("nlocrel", LoadCommand.nlocrel);
}

void MappingTraits<MachO::encryption_info_command>::mapping(
    IO &IO, MachO::encryption_info_command &LoadCommand) {

  IO.mapRequired("cryptoff", LoadCommand.cryptoff);
  IO.mapRequired("cryptsize", LoadCommand.cryptsize);
  IO.mapRequired("cryptid", LoadCommand.cryptid);
}

void MappingTraits<MachO::encryption_info_command_64>::mapping(
    IO &IO, MachO::encryption_info_command_64 &LoadCommand) {

  IO.mapRequired("cryptoff", LoadCommand.cryptoff);
  IO.mapRequired("cryptsize", LoadCommand.cryptsize);
  IO.mapRequired("cryptid", LoadCommand.cryptid);
  IO.mapRequired("pad", LoadCommand.pad);
}

void MappingTraits<MachO::entry_point_command>::mapping(
    IO &IO, MachO::entry_point_command &LoadCommand) {

  IO.mapRequired("entryoff", LoadCommand.entryoff);
  IO.mapRequired("stacksize", LoadCommand.stacksize);
}

void MappingTraits<MachO::fvmfile_command>::mapping(
    IO &IO, MachO::fvmfile_command &LoadCommand) {

  IO.mapRequired("name", LoadCommand.name);
  IO.mapRequired("header_addr", LoadCommand.header_addr);
}

void MappingTraits<MachO::fvmlib>::mapping(IO &IO, MachO::fvmlib &FVMLib) {
  IO.mapRequired("name", FVMLib.name);
  IO.mapRequired("minor_version", FVMLib.minor_version);
  IO.mapRequired("header_addr", FVMLib.header_addr);
}

void MappingTraits<MachO::fvmlib_command>::mapping(
    IO &IO, MachO::fvmlib_command &LoadCommand) {

  IO.mapRequired("fvmlib", LoadCommand.fvmlib);
}

void MappingTraits<MachO::ident_command>::mapping(
    IO &IO, MachO::ident_command &LoadCommand) {}

void MappingTraits<MachO::linkedit_data_command>::mapping(
    IO &IO, MachO::linkedit_data_command &LoadCommand) {

  IO.mapRequired("dataoff", LoadCommand.dataoff);
  IO.mapRequired("datasize", LoadCommand.datasize);
}

void MappingTraits<MachO::linker_option_command>::mapping(
    IO &IO, MachO::linker_option_command &LoadCommand) {

  IO.mapRequired("count", LoadCommand.count);
}

void MappingTraits<MachO::prebind_cksum_command>::mapping(
    IO &IO, MachO::prebind_cksum_command &LoadCommand) {

  IO.mapRequired("cksum", LoadCommand.cksum);
}

void MappingTraits<MachO::load_command>::mapping(
    IO &IO, MachO::load_command &LoadCommand) {}

void MappingTraits<MachO::prebound_dylib_command>::mapping(
    IO &IO, MachO::prebound_dylib_command &LoadCommand) {

  IO.mapRequired("name", LoadCommand.name);
  IO.mapRequired("nmodules", LoadCommand.nmodules);
  IO.mapRequired("linked_modules", LoadCommand.linked_modules);
}

void MappingTraits<MachO::routines_command>::mapping(
    IO &IO, MachO::routines_command &LoadCommand) {

  IO.mapRequired("init_address", LoadCommand.init_address);
  IO.mapRequired("init_module", LoadCommand.init_module);
  IO.mapRequired("reserved1", LoadCommand.reserved1);
  IO.mapRequired("reserved2", LoadCommand.reserved2);
  IO.mapRequired("reserved3", LoadCommand.reserved3);
  IO.mapRequired("reserved4", LoadCommand.reserved4);
  IO.mapRequired("reserved5", LoadCommand.reserved5);
  IO.mapRequired("reserved6", LoadCommand.reserved6);
}

void MappingTraits<MachO::routines_command_64>::mapping(
    IO &IO, MachO::routines_command_64 &LoadCommand) {

  IO.mapRequired("init_address", LoadCommand.init_address);
  IO.mapRequired("init_module", LoadCommand.init_module);
  IO.mapRequired("reserved1", LoadCommand.reserved1);
  IO.mapRequired("reserved2", LoadCommand.reserved2);
  IO.mapRequired("reserved3", LoadCommand.reserved3);
  IO.mapRequired("reserved4", LoadCommand.reserved4);
  IO.mapRequired("reserved5", LoadCommand.reserved5);
  IO.mapRequired("reserved6", LoadCommand.reserved6);
}

void MappingTraits<MachO::rpath_command>::mapping(
    IO &IO, MachO::rpath_command &LoadCommand) {

  IO.mapRequired("path", LoadCommand.path);
}

void MappingTraits<MachO::section>::mapping(IO &IO, MachO::section &Section) {
  IO.mapRequired("sectname", Section.sectname);
  IO.mapRequired("segname", Section.segname);
  IO.mapRequired("addr", Section.addr);
  IO.mapRequired("size", Section.size);
  IO.mapRequired("offset", Section.offset);
  IO.mapRequired("align", Section.align);
  IO.mapRequired("reloff", Section.reloff);
  IO.mapRequired("nreloc", Section.nreloc);
  IO.mapRequired("flags", Section.flags);
  IO.mapRequired("reserved1", Section.reserved1);
  IO.mapRequired("reserved2", Section.reserved2);
}

void MappingTraits<MachO::section_64>::mapping(IO &IO,
                                               MachO::section_64 &Section) {
  IO.mapRequired("sectname", Section.sectname);
  IO.mapRequired("segname", Section.segname);
  IO.mapRequired("addr", Section.addr);
  IO.mapRequired("size", Section.size);
  IO.mapRequired("offset", Section.offset);
  IO.mapRequired("align", Section.align);
  IO.mapRequired("reloff", Section.reloff);
  IO.mapRequired("nreloc", Section.nreloc);
  IO.mapRequired("flags", Section.flags);
  IO.mapRequired("reserved1", Section.reserved1);
  IO.mapRequired("reserved2", Section.reserved2);
  IO.mapRequired("reserved3", Section.reserved3);
}

void MappingTraits<MachO::segment_command>::mapping(
    IO &IO, MachO::segment_command &LoadCommand) {

  IO.mapRequired("segname", LoadCommand.segname);
  IO.mapRequired("vmaddr", LoadCommand.vmaddr);
  IO.mapRequired("vmsize", LoadCommand.vmsize);
  IO.mapRequired("fileoff", LoadCommand.fileoff);
  IO.mapRequired("filesize", LoadCommand.filesize);
  IO.mapRequired("maxprot", LoadCommand.maxprot);
  IO.mapRequired("initprot", LoadCommand.initprot);
  IO.mapRequired("nsects", LoadCommand.nsects);
  IO.mapRequired("flags", LoadCommand.flags);
}

void MappingTraits<MachO::segment_command_64>::mapping(
    IO &IO, MachO::segment_command_64 &LoadCommand) {

  IO.mapRequired("segname", LoadCommand.segname);
  IO.mapRequired("vmaddr", LoadCommand.vmaddr);
  IO.mapRequired("vmsize", LoadCommand.vmsize);
  IO.mapRequired("fileoff", LoadCommand.fileoff);
  IO.mapRequired("filesize", LoadCommand.filesize);
  IO.mapRequired("maxprot", LoadCommand.maxprot);
  IO.mapRequired("initprot", LoadCommand.initprot);
  IO.mapRequired("nsects", LoadCommand.nsects);
  IO.mapRequired("flags", LoadCommand.flags);
}

void MappingTraits<MachO::source_version_command>::mapping(
    IO &IO, MachO::source_version_command &LoadCommand) {

  IO.mapRequired("version", LoadCommand.version);
}

void MappingTraits<MachO::sub_client_command>::mapping(
    IO &IO, MachO::sub_client_command &LoadCommand) {

  IO.mapRequired("client", LoadCommand.client);
}

void MappingTraits<MachO::sub_framework_command>::mapping(
    IO &IO, MachO::sub_framework_command &LoadCommand) {

  IO.mapRequired("umbrella", LoadCommand.umbrella);
}

void MappingTraits<MachO::sub_library_command>::mapping(
    IO &IO, MachO::sub_library_command &LoadCommand) {

  IO.mapRequired("sub_library", LoadCommand.sub_library);
}

void MappingTraits<MachO::sub_umbrella_command>::mapping(
    IO &IO, MachO::sub_umbrella_command &LoadCommand) {

  IO.mapRequired("sub_umbrella", LoadCommand.sub_umbrella);
}

void MappingTraits<MachO::symseg_command>::mapping(
    IO &IO, MachO::symseg_command &LoadCommand) {

  IO.mapRequired("offset", LoadCommand.offset);
  IO.mapRequired("size", LoadCommand.size);
}

void MappingTraits<MachO::symtab_command>::mapping(
    IO &IO, MachO::symtab_command &LoadCommand) {

  IO.mapRequired("symoff", LoadCommand.symoff);
  IO.mapRequired("nsyms", LoadCommand.nsyms);
  IO.mapRequired("stroff", LoadCommand.stroff);
  IO.mapRequired("strsize", LoadCommand.strsize);
}

void MappingTraits<MachO::thread_command>::mapping(
    IO &IO, MachO::thread_command &LoadCommand) {}

void MappingTraits<MachO::twolevel_hints_command>::mapping(
    IO &IO, MachO::twolevel_hints_command &LoadCommand) {

  IO.mapRequired("offset", LoadCommand.offset);
  IO.mapRequired("nhints", LoadCommand.nhints);
}

void MappingTraits<MachO::uuid_command>::mapping(
    IO &IO, MachO::uuid_command &LoadCommand) {

  IO.mapRequired("cmdsize", LoadCommand.cmdsize);
  IO.mapRequired("uuid", LoadCommand.uuid);
}

void MappingTraits<MachO::version_min_command>::mapping(
    IO &IO, MachO::version_min_command &LoadCommand) {

  IO.mapRequired("version", LoadCommand.version);
  IO.mapRequired("sdk", LoadCommand.sdk);
}

} // namespace llvm::yaml

} // namespace llvm
