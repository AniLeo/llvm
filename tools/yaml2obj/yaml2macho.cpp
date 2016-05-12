//===- yaml2macho - Convert YAML to a Mach object file --------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief The Mach component of yaml2obj.
///
//===----------------------------------------------------------------------===//

#include "yaml2obj.h"
#include "llvm/ObjectYAML/MachOYAML.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/MachO.h"
#include "llvm/Support/YAMLTraits.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

class MachOWriter {
public:
  MachOWriter(MachOYAML::Object &Obj) : Obj(Obj) {
    is64Bit = Obj.Header.magic == MachO::MH_MAGIC_64 ||
              Obj.Header.magic == MachO::MH_CIGAM_64;
    bzero(&Header64, sizeof(MachO::mach_header_64));
  }

  Error writeMachO(raw_ostream &OS);

private:
  Error writeHeader(raw_ostream &OS);

  MachOYAML::Object Obj;
  bool is64Bit;

  union {
    MachO::mach_header_64 Header64;
    MachO::mach_header Header;
  };
};

Error MachOWriter::writeMachO(raw_ostream &OS) {
  if (auto Err = writeHeader(OS))
    return Err;
  return Error::success();
}

Error MachOWriter::writeHeader(raw_ostream &OS) {
  Header.magic = Obj.Header.magic;
  Header.cputype = Obj.Header.cputype;
  Header.cpusubtype = Obj.Header.cpusubtype;
  Header.filetype = Obj.Header.filetype;
  Header.ncmds = Obj.Header.ncmds;
  Header.sizeofcmds = Obj.Header.sizeofcmds;
  Header.flags = Obj.Header.flags;

  if (is64Bit)
    OS.write((const char *)&Header64, sizeof(MachO::mach_header_64));
  else
    OS.write((const char *)&Header, sizeof(MachO::mach_header));

  return Error::success();
}

} // end anonymous namespace

int yaml2macho(yaml::Input &YIn, raw_ostream &Out) {
  MachOYAML::Object Doc;
  YIn >> Doc;
  if (YIn.error()) {
    errs() << "yaml2obj: Failed to parse YAML file!\n";
    return 1;
  }

  MachOWriter Writer(Doc);
  if (auto Err = Writer.writeMachO(Out)) {
    errs() << toString(std::move(Err));
    return 1;
  }
  return 0;
}
