//===- AArch64RegisterBankInfo.cpp -------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for
/// AArch64.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "AArch64RegisterBankInfo.h"
#include "AArch64InstrInfo.h" // For XXXRegClassID.
#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/Target/TargetRegisterInfo.h"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

AArch64RegisterBankInfo::AArch64RegisterBankInfo(const TargetRegisterInfo &TRI)
    : RegisterBankInfo(AArch64::NumRegisterBanks) {
  // Initialize the GPR bank.
  createRegisterBank(AArch64::GPRRegBankID, "GPR");
  // The GPR register bank is fully defined by all the registers in
  // GR64all + its subclasses.
  addRegBankCoverage(AArch64::GPRRegBankID, AArch64::GPR64allRegClassID, TRI);
  const RegisterBank &RBGPR = getRegBank(AArch64::GPRRegBankID);
  (void)RBGPR;
  assert(RBGPR.contains(*TRI.getRegClass(AArch64::GPR32RegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.getSize() == 64 && "GPRs should hold up to 64-bit");

  // Initialize the FPR bank.
  createRegisterBank(AArch64::FPRRegBankID, "FPR");
  // The FPR register bank is fully defined by all the registers in
  // GR64all + its subclasses.
  addRegBankCoverage(AArch64::FPRRegBankID, AArch64::QQQQRegClassID, TRI);
  const RegisterBank &RBFPR = getRegBank(AArch64::FPRRegBankID);
  (void)RBFPR;
  assert(RBFPR.contains(*TRI.getRegClass(AArch64::QQRegClassID)) &&
         "Subclass not added?");
  assert(RBFPR.contains(*TRI.getRegClass(AArch64::FPR64RegClassID)) &&
         "Subclass not added?");
  assert(RBFPR.getSize() == 512 &&
         "FPRs should hold up to 512-bit via QQQQ sequence");

  verify(TRI);
}

unsigned AArch64RegisterBankInfo::copyCost(const RegisterBank &A,
                                           const RegisterBank &B) const {
  // What do we do with different size?
  // copy are same size.
  // Will introduce other hooks for different size:
  // * extract cost.
  // * build_sequence cost.
  return 0;
}
