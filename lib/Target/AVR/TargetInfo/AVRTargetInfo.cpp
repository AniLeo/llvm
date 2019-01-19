//===-- AVRTargetInfo.cpp - AVR Target Implementation ---------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/IR/Module.h"
#include "llvm/Support/TargetRegistry.h"
namespace llvm {
Target &getTheAVRTarget() {
  static Target TheAVRTarget;
  return TheAVRTarget;
}
}

extern "C" void LLVMInitializeAVRTargetInfo() {
  llvm::RegisterTarget<llvm::Triple::avr> X(llvm::getTheAVRTarget(), "avr",
                                            "Atmel AVR Microcontroller", "AVR");
}

