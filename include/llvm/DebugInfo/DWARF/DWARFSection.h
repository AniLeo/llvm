//===- DWARFSection.h -------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DEBUGINFO_DWARF_DWARFSECTION_H
#define LLVM_DEBUGINFO_DWARF_DWARFSECTION_H

#include "llvm/ADT/StringRef.h"

namespace llvm {

struct DWARFSection {
  StringRef Data;
};

struct SectionName {
  StringRef Name;
  bool IsNameUnique;
};

struct SectionedAddress {
  uint64_t Address;
  uint64_t SectionIndex;
};

} // end namespace llvm

#endif // LLVM_DEBUGINFO_DWARF_DWARFSECTION_H
