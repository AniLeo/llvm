//===- llvm/CodeGen/GlobalISel/RegisterBankInfo.cpp --------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the RegisterBankInfo class.
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/Target/TargetRegisterInfo.h"

#include <algorithm> // For std::max.

#define DEBUG_TYPE "registerbankinfo"

using namespace llvm;

RegisterBankInfo::RegisterBankInfo(unsigned NumRegBanks)
    : NumRegBanks(NumRegBanks) {
  RegBanks.reset(new RegisterBank[NumRegBanks]);
}

RegisterBankInfo::~RegisterBankInfo() {}

void RegisterBankInfo::verify(const TargetRegisterInfo &TRI) const {
  for (unsigned Idx = 0, End = getNumRegBanks(); Idx != End; ++Idx) {
    const RegisterBank &RegBank = getRegBank(Idx);
    assert(Idx == RegBank.getID() &&
           "ID does not match the index in the array");
    RegBank.verify(TRI);
  }
}

void RegisterBankInfo::createRegisterBank(unsigned ID, const char *Name) {
  RegisterBank &RegBank = getRegBank(ID);
  assert(RegBank.getID() == RegisterBank::InvalidID &&
         "A register bank should be created only once");
  RegBank.ID = ID;
  RegBank.Name = Name;
}

void RegisterBankInfo::addRegBankCoverage(unsigned ID,
                                          const TargetRegisterClass &RC,
                                          const TargetRegisterInfo &TRI) {
  RegisterBank &RB = getRegBank(ID);
  unsigned NbOfRegClasses = TRI.getNumRegClasses();
  // Check if RB is underconstruction.
  if (!RB.isValid())
    RB.ContainedRegClasses.resize(NbOfRegClasses);
  else if (RB.contains(RC))
    // If RB already contains this register class, there is nothing
    // to do.
    return;

  BitVector &Covered = RB.ContainedRegClasses;
  SmallVector<unsigned, 8> WorkList;

  WorkList.push_back(RC.getID());
  Covered.set(RC.getID());

  unsigned &MaxSize = RB.Size;
  do {
    unsigned RCId = WorkList.pop_back_val();

    const TargetRegisterClass &CurRC = *TRI.getRegClass(RCId);
    // Remember the biggest size in bits.
    MaxSize = std::max(MaxSize, CurRC.getSize() * 8);

    // Walk through all sub register classes and push them into the worklist.
    const uint32_t *SubClassMask = CurRC.getSubClassMask();
    // The subclasses mask is broken down into chunks of uint32_t, but it still
    // represents all register classes.
    for (unsigned Base = 0; Base < NbOfRegClasses; Base += 32) {
      unsigned Idx = Base;
      for (uint32_t Mask = *SubClassMask++; Mask; Mask >>= 1, ++Idx) {
        unsigned Offset = countTrailingZeros(Mask);
        unsigned SubRCId = Idx + Offset;
        if (!Covered.test(SubRCId))
          WorkList.push_back(SubRCId);
        // Remember that we saw the sub class.
        Covered.set(SubRCId);
        // Move the cursor to the next sub class.
        // I.e., eat up the zeros then move to the next bit.
        // This last part is done as part of the loop increment.

        // By construction, Offset must be less than 32.
        // Otherwise, than means Mask was zero. I.e., no UB.
        Mask >>= Offset;
        // Remember that we shifted the base offset.
        Idx += Offset;
      }
    }

  } while (!WorkList.empty());
}
