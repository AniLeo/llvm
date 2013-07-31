//===-- SystemZSubtarget.h - SystemZ subtarget information -----*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the SystemZ specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef SYSTEMZSUBTARGET_H
#define SYSTEMZSUBTARGET_H

#include "llvm/ADT/Triple.h"
#include "llvm/Target/TargetSubtargetInfo.h"
#include <string>

#define GET_SUBTARGETINFO_HEADER
#include "SystemZGenSubtargetInfo.inc"

namespace llvm {
class GlobalValue;
class StringRef;

class SystemZSubtarget : public SystemZGenSubtargetInfo {
protected:
  bool HasDistinctOps;
  bool HasLoadStoreOnCond;
  bool HasHighWord;

private:
  Triple TargetTriple;

public:
  SystemZSubtarget(const std::string &TT, const std::string &CPU,
                   const std::string &FS);

  // Automatically generated by tblgen.
  void ParseSubtargetFeatures(StringRef CPU, StringRef FS);

  // Return true if the target has the distinct-operands facility.
  bool hasDistinctOps() const { return HasDistinctOps; }

  // Return true if the target has the load/store-on-condition facility.
  bool hasLoadStoreOnCond() const { return HasLoadStoreOnCond; }

  // Return true if the target has the high-word facility.
  bool hasHighWord() const { return HasHighWord; }

  // Return true if GV can be accessed using LARL for reloc model RM
  // and code model CM.
  bool isPC32DBLSymbol(const GlobalValue *GV, Reloc::Model RM,
                       CodeModel::Model CM) const;

  bool isTargetELF() const { return TargetTriple.isOSBinFormatELF(); }
};
} // end namespace llvm

#endif
