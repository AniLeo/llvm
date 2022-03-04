//===- llvm-objcopy.cpp ---------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "ObjcopyOptions.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/ObjCopy/COFF/COFFConfig.h"
#include "llvm/ObjCopy/COFF/COFFObjcopy.h"
#include "llvm/ObjCopy/CommonConfig.h"
#include "llvm/ObjCopy/ELF/ELFConfig.h"
#include "llvm/ObjCopy/ELF/ELFObjcopy.h"
#include "llvm/ObjCopy/MachO/MachOConfig.h"
#include "llvm/ObjCopy/MachO/MachOObjcopy.h"
#include "llvm/ObjCopy/ObjCopy.h"
#include "llvm/ObjCopy/wasm/WasmConfig.h"
#include "llvm/ObjCopy/wasm/WasmObjcopy.h"
#include "llvm/Object/Archive.h"
#include "llvm/Object/ArchiveWriter.h"
#include "llvm/Object/Binary.h"
#include "llvm/Object/COFF.h"
#include "llvm/Object/ELFObjectFile.h"
#include "llvm/Object/ELFTypes.h"
#include "llvm/Object/Error.h"
#include "llvm/Object/MachO.h"
#include "llvm/Object/MachOUniversal.h"
#include "llvm/Object/Wasm.h"
#include "llvm/Option/Arg.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Option/Option.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Errc.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/Host.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/Memory.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/Process.h"
#include "llvm/Support/SmallVectorMemoryBuffer.h"
#include "llvm/Support/StringSaver.h"
#include "llvm/Support/WithColor.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <memory>
#include <string>
#include <system_error>
#include <utility>

using namespace llvm;
using namespace llvm::objcopy;
using namespace llvm::object;

// The name this program was invoked as.
static StringRef ToolName;

static ErrorSuccess reportWarning(Error E) {
  assert(E);
  WithColor::warning(errs(), ToolName) << toString(std::move(E)) << '\n';
  return Error::success();
}

static Expected<DriverConfig> getDriverConfig(ArrayRef<const char *> Args) {
  StringRef Stem = sys::path::stem(ToolName);
  auto Is = [=](StringRef Tool) {
    // We need to recognize the following filenames:
    //
    // llvm-objcopy -> objcopy
    // strip-10.exe -> strip
    // powerpc64-unknown-freebsd13-objcopy -> objcopy
    // llvm-install-name-tool -> install-name-tool
    auto I = Stem.rfind_insensitive(Tool);
    return I != StringRef::npos &&
           (I + Tool.size() == Stem.size() || !isAlnum(Stem[I + Tool.size()]));
  };

  if (Is("bitcode-strip") || Is("bitcode_strip"))
    return parseBitcodeStripOptions(Args, reportWarning);
  else if (Is("strip"))
    return parseStripOptions(Args, reportWarning);
  else if (Is("install-name-tool") || Is("install_name_tool"))
    return parseInstallNameToolOptions(Args);
  else
    return parseObjcopyOptions(Args, reportWarning);
}

/// The function executeObjcopyOnIHex does the dispatch based on the format
/// of the output specified by the command line options.
static Error executeObjcopyOnIHex(ConfigManager &ConfigMgr, MemoryBuffer &In,
                                  raw_ostream &Out) {
  // TODO: support output formats other than ELF.
  Expected<const ELFConfig &> ELFConfig = ConfigMgr.getELFConfig();
  if (!ELFConfig)
    return ELFConfig.takeError();

  return elf::executeObjcopyOnIHex(ConfigMgr.getCommonConfig(), *ELFConfig, In,
                                   Out);
}

/// The function executeObjcopyOnRawBinary does the dispatch based on the format
/// of the output specified by the command line options.
static Error executeObjcopyOnRawBinary(ConfigManager &ConfigMgr,
                                       MemoryBuffer &In, raw_ostream &Out) {
  const CommonConfig &Config = ConfigMgr.getCommonConfig();
  switch (Config.OutputFormat) {
  case FileFormat::ELF:
  // FIXME: Currently, we call elf::executeObjcopyOnRawBinary even if the
  // output format is binary/ihex or it's not given. This behavior differs from
  // GNU objcopy. See https://bugs.llvm.org/show_bug.cgi?id=42171 for details.
  case FileFormat::Binary:
  case FileFormat::IHex:
  case FileFormat::Unspecified:
    Expected<const ELFConfig &> ELFConfig = ConfigMgr.getELFConfig();
    if (!ELFConfig)
      return ELFConfig.takeError();

    return elf::executeObjcopyOnRawBinary(Config, *ELFConfig, In, Out);
  }

  llvm_unreachable("unsupported output format");
}

static Error restoreStatOnFile(StringRef Filename,
                               const sys::fs::file_status &Stat,
                               const ConfigManager &ConfigMgr) {
  int FD;
  const CommonConfig &Config = ConfigMgr.getCommonConfig();

  // Writing to stdout should not be treated as an error here, just
  // do not set access/modification times or permissions.
  if (Filename == "-")
    return Error::success();

  if (auto EC =
          sys::fs::openFileForWrite(Filename, FD, sys::fs::CD_OpenExisting))
    return createFileError(Filename, EC);

  if (Config.PreserveDates)
    if (auto EC = sys::fs::setLastAccessAndModificationTime(
            FD, Stat.getLastAccessedTime(), Stat.getLastModificationTime()))
      return createFileError(Filename, EC);

  sys::fs::file_status OStat;
  if (std::error_code EC = sys::fs::status(FD, OStat))
    return createFileError(Filename, EC);
  if (OStat.type() == sys::fs::file_type::regular_file) {
#ifndef _WIN32
    // Keep ownership if llvm-objcopy is called under root.
    if (Config.InputFilename == Config.OutputFilename && OStat.getUser() == 0)
      sys::fs::changeFileOwnership(FD, Stat.getUser(), Stat.getGroup());
#endif

    sys::fs::perms Perm = Stat.permissions();
    if (Config.InputFilename != Config.OutputFilename)
      Perm = static_cast<sys::fs::perms>(Perm & ~sys::fs::getUmask() & ~06000);
#ifdef _WIN32
    if (auto EC = sys::fs::setPermissions(Filename, Perm))
#else
    if (auto EC = sys::fs::setPermissions(FD, Perm))
#endif
      return createFileError(Filename, EC);
  }

  if (auto EC = sys::Process::SafelyCloseFileDescriptor(FD))
    return createFileError(Filename, EC);

  return Error::success();
}

/// The function executeObjcopy does the higher level dispatch based on the type
/// of input (raw binary, archive or single object file) and takes care of the
/// format-agnostic modifications, i.e. preserving dates.
static Error executeObjcopy(ConfigManager &ConfigMgr) {
  CommonConfig &Config = ConfigMgr.Common;

  sys::fs::file_status Stat;
  if (Config.InputFilename != "-") {
    if (auto EC = sys::fs::status(Config.InputFilename, Stat))
      return createFileError(Config.InputFilename, EC);
  } else {
    Stat.permissions(static_cast<sys::fs::perms>(0777));
  }

  std::function<Error(raw_ostream & OutFile)> ObjcopyFunc;

  OwningBinary<llvm::object::Binary> BinaryHolder;
  std::unique_ptr<MemoryBuffer> MemoryBufferHolder;

  if (Config.InputFormat == FileFormat::Binary ||
      Config.InputFormat == FileFormat::IHex) {
    ErrorOr<std::unique_ptr<MemoryBuffer>> BufOrErr =
        MemoryBuffer::getFileOrSTDIN(Config.InputFilename);
    if (!BufOrErr)
      return createFileError(Config.InputFilename, BufOrErr.getError());
    MemoryBufferHolder = std::move(*BufOrErr);

    if (Config.InputFormat == FileFormat::Binary)
      ObjcopyFunc = [&](raw_ostream &OutFile) -> Error {
        // Handle FileFormat::Binary.
        return executeObjcopyOnRawBinary(ConfigMgr, *MemoryBufferHolder,
                                         OutFile);
      };
    else
      ObjcopyFunc = [&](raw_ostream &OutFile) -> Error {
        // Handle FileFormat::IHex.
        return executeObjcopyOnIHex(ConfigMgr, *MemoryBufferHolder, OutFile);
      };
  } else {
    Expected<OwningBinary<llvm::object::Binary>> BinaryOrErr =
        createBinary(Config.InputFilename);
    if (!BinaryOrErr)
      return createFileError(Config.InputFilename, BinaryOrErr.takeError());
    BinaryHolder = std::move(*BinaryOrErr);

    if (Archive *Ar = dyn_cast<Archive>(BinaryHolder.getBinary())) {
      // Handle Archive.
      if (Error E = executeObjcopyOnArchive(ConfigMgr, *Ar))
        return E;
    } else {
      // Handle llvm::object::Binary.
      ObjcopyFunc = [&](raw_ostream &OutFile) -> Error {
        return executeObjcopyOnBinary(ConfigMgr, *BinaryHolder.getBinary(),
                                      OutFile);
      };
    }
  }

  if (ObjcopyFunc) {
    if (Config.SplitDWO.empty()) {
      // Apply transformations described by Config and store result into
      // Config.OutputFilename using specified ObjcopyFunc function.
      if (Error E = writeToOutput(Config.OutputFilename, ObjcopyFunc))
        return E;
    } else {
      Config.ExtractDWO = true;
      Config.StripDWO = false;
      // Copy .dwo tables from the Config.InputFilename into Config.SplitDWO
      // file using specified ObjcopyFunc function.
      if (Error E = writeToOutput(Config.SplitDWO, ObjcopyFunc))
        return E;
      Config.ExtractDWO = false;
      Config.StripDWO = true;
      // Apply transformations described by Config, remove .dwo tables and
      // store result into Config.OutputFilename using specified ObjcopyFunc
      // function.
      if (Error E = writeToOutput(Config.OutputFilename, ObjcopyFunc))
        return E;
    }
  }

  if (Error E = restoreStatOnFile(Config.OutputFilename, Stat, ConfigMgr))
    return E;

  if (!Config.SplitDWO.empty()) {
    Stat.permissions(static_cast<sys::fs::perms>(0666));
    if (Error E = restoreStatOnFile(Config.SplitDWO, Stat, ConfigMgr))
      return E;
  }

  return Error::success();
}

int main(int argc, char **argv) {
  InitLLVM X(argc, argv);
  ToolName = argv[0];

  // Expand response files.
  // TODO: Move these lines, which are copied from lib/Support/CommandLine.cpp,
  // into a separate function in the CommandLine library and call that function
  // here. This is duplicated code.
  SmallVector<const char *, 20> NewArgv(argv, argv + argc);
  BumpPtrAllocator A;
  StringSaver Saver(A);
  cl::ExpandResponseFiles(Saver,
                          Triple(sys::getProcessTriple()).isOSWindows()
                              ? cl::TokenizeWindowsCommandLine
                              : cl::TokenizeGNUCommandLine,
                          NewArgv);

  auto Args = makeArrayRef(NewArgv).drop_front();
  Expected<DriverConfig> DriverConfig = getDriverConfig(Args);

  if (!DriverConfig) {
    logAllUnhandledErrors(DriverConfig.takeError(),
                          WithColor::error(errs(), ToolName));
    return 1;
  }
  for (ConfigManager &ConfigMgr : DriverConfig->CopyConfigs) {
    if (Error E = executeObjcopy(ConfigMgr)) {
      logAllUnhandledErrors(std::move(E), WithColor::error(errs(), ToolName));
      return 1;
    }
  }

  return 0;
}
