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
#include "ARMCallLowering.h"
#include "ARMSubtarget.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"
#include "llvm/CodeGen/LowLevelType.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"
#include "llvm/Target/TargetOpcodes.h"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

static bool AEABI(const ARMSubtarget &ST) {
  return ST.isTargetAEABI() || ST.isTargetGNUAEABI() || ST.isTargetMuslAEABI();
}

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

  for (unsigned Op : {G_ADD, G_SUB, G_MUL, G_AND, G_OR, G_XOR}) {
    for (auto Ty : {s1, s8, s16})
      setAction({Op, Ty}, WidenScalar);
    setAction({Op, s32}, Legal);
  }

  for (unsigned Op : {G_SDIV, G_UDIV}) {
    for (auto Ty : {s8, s16})
      setAction({Op, Ty}, WidenScalar);
    if (ST.hasDivideInARMMode())
      setAction({Op, s32}, Legal);
    else
      setAction({Op, s32}, Libcall);
  }

  // FIXME: Support s8 and s16 as well
  for (unsigned Op : {G_SREM, G_UREM})
    if (ST.hasDivideInARMMode())
      setAction({Op, s32}, Lower);
    else if (AEABI(ST))
      setAction({Op, s32}, Custom);
    else
      setAction({Op, s32}, Libcall);

  for (unsigned Op : {G_SEXT, G_ZEXT}) {
    setAction({Op, s32}, Legal);
    for (auto Ty : {s1, s8, s16})
      setAction({Op, 1, Ty}, Legal);
  }

  setAction({G_GEP, p0}, Legal);
  setAction({G_GEP, 1, s32}, Legal);

  setAction({G_SELECT, s32}, Legal);
  setAction({G_SELECT, p0}, Legal);
  setAction({G_SELECT, 1, s1}, Legal);

  setAction({G_CONSTANT, s32}, Legal);

  setAction({G_ICMP, s1}, Legal);
  for (auto Ty : {s8, s16})
    setAction({G_ICMP, 1, Ty}, WidenScalar);
  for (auto Ty : {s32, p0})
    setAction({G_ICMP, 1, Ty}, Legal);

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
  case G_SREM:
  case G_UREM: {
    unsigned OriginalResult = MI.getOperand(0).getReg();
    auto Size = MRI.getType(OriginalResult).getSizeInBits();
    if (Size != 32)
      return false;

    auto Libcall =
        MI.getOpcode() == G_SREM ? RTLIB::SDIVREM_I32 : RTLIB::UDIVREM_I32;

    // Our divmod libcalls return a struct containing the quotient and the
    // remainder. We need to create a virtual register for it.
    auto &Ctx = MIRBuilder.getMF().getFunction()->getContext();
    Type *ArgTy = Type::getInt32Ty(Ctx);
    StructType *RetTy = StructType::get(Ctx, {ArgTy, ArgTy}, /* Packed */ true);
    auto RetVal = MRI.createGenericVirtualRegister(
        getLLTForType(*RetTy, MIRBuilder.getMF().getDataLayout()));

    auto Status = replaceWithLibcall(MI, MIRBuilder, Libcall, {RetVal, RetTy},
                                     {{MI.getOperand(1).getReg(), ArgTy},
                                      {MI.getOperand(2).getReg(), ArgTy}});
    if (Status != LegalizerHelper::Legalized)
      return false;

    // The remainder is the second result of divmod. Split the return value into
    // a new, unused register for the quotient and the destination of the
    // original instruction for the remainder.
    MIRBuilder.buildUnmerge(
        {MRI.createGenericVirtualRegister(LLT::scalar(32)), OriginalResult},
        RetVal);

    return LegalizerHelper::Legalized;
  }
  }
}
