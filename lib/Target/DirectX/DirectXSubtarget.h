//===-- DirectXSubtarget.h - Define Subtarget for DirectX -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the DirectX specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DIRECTX_DIRECTXSUBTARGET_H
#define LLVM_DIRECTX_DIRECTXSUBTARGET_H

#include "DirectXFrameLowering.h"
#include "DirectXInstrInfo.h"
#include "DirectXTargetLowering.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetMachine.h"

#define GET_SUBTARGETINFO_HEADER
#include "DirectXGenSubtargetInfo.inc"

namespace llvm {

class DirectXTargetMachine;

class DirectXSubtarget : public DirectXGenSubtargetInfo {
  DirectXFrameLowering FL;
  DirectXTargetLowering TL;
  DirectXInstrInfo InstrInfo;

  virtual void anchor(); // virtual anchor method

public:
  DirectXSubtarget(const Triple &TT, StringRef CPU, StringRef FS,
                   const DirectXTargetMachine &TM);

  /// Parses a subtarget feature string, setting appropriate options.
  /// \note Definition of function is auto generated by `tblgen`.
  void ParseSubtargetFeatures(StringRef CPU, StringRef TuneCPU, StringRef FS);

  const DirectXTargetLowering *getTargetLowering() const override {
    return &TL;
  }

  const DirectXFrameLowering *getFrameLowering() const override { return &FL; }

  const DirectXInstrInfo *getInstrInfo() const override { return &InstrInfo; }
};

} // end namespace llvm

#endif // LLVM_DIRECTX_DIRECTXSUBTARGET_H
