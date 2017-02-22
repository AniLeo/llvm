//===- X86LegalizerInfo.cpp --------------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for X86.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "X86LegalizerInfo.h"
#include "X86Subtarget.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"
#include "llvm/Target/TargetOpcodes.h"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

X86LegalizerInfo::X86LegalizerInfo(const X86Subtarget &STI) : Subtarget(STI) {

  setLegalizerInfo32bit();
  setLegalizerInfo64bit();

  computeTables();
}

void X86LegalizerInfo::setLegalizerInfo32bit() {

  const LLT s8 = LLT::scalar(8);
  const LLT s16 = LLT::scalar(16);
  const LLT s32 = LLT::scalar(32);

  for (auto Ty : {s8, s16, s32}) {
    setAction({TargetOpcode::G_ADD, Ty}, Legal);
    setAction({TargetOpcode::G_SUB, Ty}, Legal);
  }
}

void X86LegalizerInfo::setLegalizerInfo64bit() {

  if (!Subtarget.is64Bit())
    return;

  const LLT s64 = LLT::scalar(64);

  setAction({TargetOpcode::G_ADD, s64}, Legal);
  setAction({TargetOpcode::G_SUB, s64}, Legal);
}
