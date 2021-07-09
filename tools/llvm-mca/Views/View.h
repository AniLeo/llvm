//===----------------------- View.h -----------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file defines the main interface for Views. Each view contributes a
/// portion of the final report generated by the tool.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_MCA_VIEW_H
#define LLVM_TOOLS_LLVM_MCA_VIEW_H

#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MCA/HWEventListener.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/JSON.h"

namespace llvm {
namespace mca {

class View : public HWEventListener {
public:
  virtual ~View() = default;

  virtual void printView(llvm::raw_ostream &OS) const = 0;
  virtual StringRef getNameAsString() const = 0;

  virtual void printViewJSON(llvm::raw_ostream &OS);
  virtual json::Value toJSON() const { return "not implemented"; }
  virtual bool isSerializable() const { return true; }
  void anchor() override;
};
} // namespace mca
} // namespace llvm

#endif
