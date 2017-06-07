//===- ARMLegalizerInfo.cpp --------------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for ARM.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "ARMLegalizerInfo.h"
#include "ARMSubtarget.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"
#include "llvm/Target/TargetOpcodes.h"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

ARMLegalizerInfo::ARMLegalizerInfo(const ARMSubtarget &ST) {
  using namespace TargetOpcode;

  const LLT p0 = LLT::pointer(0, 32);

  const LLT s1 = LLT::scalar(1);
  const LLT s8 = LLT::scalar(8);
  const LLT s16 = LLT::scalar(16);
  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);

  setAction({G_FRAME_INDEX, p0}, Legal);

  for (unsigned Op : {G_LOAD, G_STORE}) {
    for (auto Ty : {s1, s8, s16, s32, p0})
      setAction({Op, Ty}, Legal);
    setAction({Op, 1, p0}, Legal);
  }

  for (unsigned Op : {G_ADD, G_SUB, G_MUL, G_AND, G_OR}) {
    for (auto Ty : {s1, s8, s16})
      setAction({Op, Ty}, WidenScalar);
    setAction({Op, s32}, Legal);
  }

  for (unsigned Op : {G_SDIV, G_UDIV}) {
    for (auto Ty : {s8, s16})
      // FIXME: We need WidenScalar here, but in the case of targets with
      // software division we'll also need Libcall afterwards. Treat as Custom
      // until we have better support for chaining legalization actions.
      setAction({Op, Ty}, Custom);
    if (ST.hasDivideInARMMode())
      setAction({Op, s32}, Legal);
    else
      setAction({Op, s32}, Libcall);
  }

  for (unsigned Op : {G_SEXT, G_ZEXT}) {
    setAction({Op, s32}, Legal);
    for (auto Ty : {s1, s8, s16})
      setAction({Op, 1, Ty}, Legal);
  }

  setAction({G_GEP, p0}, Legal);
  setAction({G_GEP, 1, s32}, Legal);

  setAction({G_CONSTANT, s32}, Legal);

  if (!ST.useSoftFloat() && ST.hasVFP2()) {
    setAction({G_FADD, s32}, Legal);
    setAction({G_FADD, s64}, Legal);

    setAction({G_LOAD, s64}, Legal);
    setAction({G_STORE, s64}, Legal);
  } else {
    for (auto Ty : {s32, s64})
      setAction({G_FADD, Ty}, Libcall);
  }

  for (unsigned Op : {G_FREM, G_FPOW})
    for (auto Ty : {s32, s64})
      setAction({Op, Ty}, Libcall);

  computeTables();
}

bool ARMLegalizerInfo::legalizeCustom(MachineInstr &MI,
                                      MachineRegisterInfo &MRI,
                                      MachineIRBuilder &MIRBuilder) const {
  using namespace TargetOpcode;

  switch (MI.getOpcode()) {
  default:
    return false;
  case G_SDIV:
  case G_UDIV: {
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    if (Ty != LLT::scalar(16) && Ty != LLT::scalar(8))
      return false;

    // We need to widen to 32 bits and then maybe, if the target requires,
    // transform into a libcall.
    LegalizerHelper Helper(MIRBuilder.getMF());

    MachineInstr *NewMI = nullptr;
    Helper.MIRBuilder.recordInsertions([&](MachineInstr *MI) {
      // Store the new, 32-bit div instruction.
      if (MI->getOpcode() == G_SDIV || MI->getOpcode() == G_UDIV)
        NewMI = MI;
    });

    auto Result = Helper.widenScalar(MI, 0, LLT::scalar(32));
    Helper.MIRBuilder.stopRecordingInsertions();
    if (Result == LegalizerHelper::UnableToLegalize) {
      return false;
    }
    assert(NewMI && "Couldn't find widened instruction");
    assert((NewMI->getOpcode() == G_SDIV || NewMI->getOpcode() == G_UDIV) &&
           "Unexpected widened instruction");
    assert(MRI.getType(NewMI->getOperand(0).getReg()).getSizeInBits() == 32 &&
           "Unexpected type for the widened instruction");

    Result = Helper.legalizeInstrStep(*NewMI);
    if (Result == LegalizerHelper::UnableToLegalize) {
      return false;
    }
    return true;
  }
  }
}
