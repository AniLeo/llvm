//===- Main.cpp - Top-Level TableGen implementation -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// TableGen is a tool which can be used to build up a description of something,
// then invoke one or more "tablegen backends" to emit information about the
// description in some predefined format.  In practice, this is used by the LLVM
// code generators to automate generation of a code generator through a
// high-level description of the target.
//
//===----------------------------------------------------------------------===//

#include "llvm/TableGen/Main.h"
#include "TGParser.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/Record.h"
#include <algorithm>
#include <cstdio>
#include <system_error>
using namespace llvm;

static cl::opt<std::string>
OutputFilename("o", cl::desc("Output filename"), cl::value_desc("filename"),
               cl::init("-"));

static cl::opt<std::string>
DependFilename("d",
               cl::desc("Dependency filename"),
               cl::value_desc("filename"),
               cl::init(""));

static cl::opt<std::string>
InputFilename(cl::Positional, cl::desc("<input file>"), cl::init("-"));

static cl::list<std::string>
IncludeDirs("I", cl::desc("Directory of include files"),
            cl::value_desc("directory"), cl::Prefix);

static cl::list<std::string>
MacroNames("D", cl::desc("Name of the macro to be defined"),
            cl::value_desc("macro name"), cl::Prefix);

static cl::opt<bool>
WriteIfChanged("write-if-changed", cl::desc("Only write output if it changed"));

static int reportError(const char *ProgName, Twine Msg) {
  errs() << ProgName << ": " << Msg;
  errs().flush();
  return 1;
}

/// Create a dependency file for `-d` option.
///
/// This functionality is really only for the benefit of the build system.
/// It is similar to GCC's `-M*` family of options.
static int createDependencyFile(const TGParser &Parser, const char *argv0) {
  if (OutputFilename == "-")
    return reportError(argv0, "the option -d must be used together with -o\n");

  std::error_code EC;
  ToolOutputFile DepOut(DependFilename, EC, sys::fs::OF_None);
  if (EC)
    return reportError(argv0, "error opening " + DependFilename + ":" +
                                  EC.message() + "\n");
  DepOut.os() << OutputFilename << ":";
  for (const auto &Dep : Parser.getDependencies()) {
    DepOut.os() << ' ' << Dep;
  }
  DepOut.os() << "\n";
  DepOut.keep();
  return 0;
}

int llvm::TableGenMain(const char *argv0, TableGenMainFn *MainFn) {
  RecordKeeper Records;

  // Parse the input file.
  ErrorOr<std::unique_ptr<MemoryBuffer>> FileOrErr =
      MemoryBuffer::getFileOrSTDIN(InputFilename);
  if (std::error_code EC = FileOrErr.getError())
    return reportError(argv0, "Could not open input file '" + InputFilename +
                                  "': " + EC.message() + "\n");

  // Tell SrcMgr about this buffer, which is what TGParser will pick up.
  SrcMgr.AddNewSourceBuffer(std::move(*FileOrErr), SMLoc());

  // Record the location of the include directory so that the lexer can find
  // it later.
  SrcMgr.setIncludeDirs(IncludeDirs);

  TGParser Parser(SrcMgr, MacroNames, Records);

  if (Parser.ParseFile())
    return 1;

  // Write output to memory.
  std::string OutString;
  raw_string_ostream Out(OutString);
  if (MainFn(Out, Records))
    return 1;

  // Always write the depfile, even if the main output hasn't changed.
  // If it's missing, Ninja considers the output dirty.  If this was below
  // the early exit below and someone deleted the .inc.d file but not the .inc
  // file, tablegen would never write the depfile.
  if (!DependFilename.empty()) {
    if (int Ret = createDependencyFile(Parser, argv0))
      return Ret;
  }

  if (WriteIfChanged) {
    // Only updates the real output file if there are any differences.
    // This prevents recompilation of all the files depending on it if there
    // aren't any.
    if (auto ExistingOrErr = MemoryBuffer::getFile(OutputFilename))
      if (std::move(ExistingOrErr.get())->getBuffer() == Out.str())
        return 0;
  }

  std::error_code EC;
  ToolOutputFile OutFile(OutputFilename, EC, sys::fs::OF_None);
  if (EC)
    return reportError(argv0, "error opening " + OutputFilename + ":" +
                                  EC.message() + "\n");
  OutFile.os() << Out.str();

  if (ErrorsPrinted > 0)
    return reportError(argv0, Twine(ErrorsPrinted) + " errors.\n");

  // Declare success.
  OutFile.keep();
  return 0;
}
