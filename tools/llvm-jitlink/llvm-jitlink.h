//===---- llvm-jitlink.h - Session and format-specific decls ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Utilities for remote-JITing with LLI.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_JITLINK_LLVM_JITLINK_H
#define LLVM_TOOLS_LLVM_JITLINK_LLVM_JITLINK_H

#include "llvm/ADT/Triple.h"
#include "llvm/ExecutionEngine/Orc/Core.h"
#include "llvm/ExecutionEngine/Orc/ObjectLinkingLayer.h"
#include "llvm/ExecutionEngine/RuntimeDyldChecker.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/raw_ostream.h"

#include <vector>

namespace llvm {

struct Session {
  orc::ExecutionSession ES;
  orc::JITDylib *MainJD;
  orc::ObjectLinkingLayer ObjLayer;
  std::vector<orc::JITDylib *> JDSearchOrder;
  Triple TT;

  Session(Triple TT);
  static Expected<std::unique_ptr<Session>> Create(Triple TT);
  void dumpSessionInfo(raw_ostream &OS);
  void modifyPassConfig(const Triple &FTT,
                        jitlink::PassConfiguration &PassConfig);

  using MemoryRegionInfo = RuntimeDyldChecker::MemoryRegionInfo;

  struct FileInfo {
    StringMap<MemoryRegionInfo> SectionInfos;
    StringMap<MemoryRegionInfo> StubInfos;
    StringMap<MemoryRegionInfo> GOTEntryInfos;
  };

  using SymbolInfoMap = StringMap<MemoryRegionInfo>;
  using FileInfoMap = StringMap<FileInfo>;

  Expected<FileInfo &> findFileInfo(StringRef FileName);
  Expected<MemoryRegionInfo &> findSectionInfo(StringRef FileName,
                                               StringRef SectionName);
  Expected<MemoryRegionInfo &> findStubInfo(StringRef FileName,
                                            StringRef TargetName);
  Expected<MemoryRegionInfo &> findGOTEntryInfo(StringRef FileName,
                                                StringRef TargetName);

  bool isSymbolRegistered(StringRef Name);
  Expected<MemoryRegionInfo &> findSymbolInfo(StringRef SymbolName,
                                              Twine ErrorMsgStem);

  SymbolInfoMap SymbolInfos;
  FileInfoMap FileInfos;
  uint64_t SizeBeforePruning = 0;
  uint64_t SizeAfterFixups = 0;

private:
  Session(Triple TT, Error &Err);
};

Error registerMachOStubsAndGOT(Session &S, jitlink::LinkGraph &G);

} // end namespace llvm

#endif // LLVM_TOOLS_LLVM_JITLINK_LLVM_JITLINK_H
