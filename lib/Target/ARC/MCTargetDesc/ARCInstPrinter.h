//===- ARCInstPrinter.h - Convert ARC MCInst to assembly syntax -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file contains the declaration of the ARCInstPrinter class,
/// which is used to print ARC MCInst to a .s file.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_ARC_INSTPRINTER_ARCINSTPRINTER_H
#define LLVM_LIB_TARGET_ARC_INSTPRINTER_ARCINSTPRINTER_H

#include "llvm/MC/MCInstPrinter.h"

namespace llvm {

class ARCInstPrinter : public MCInstPrinter {
public:
  ARCInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                 const MCRegisterInfo &MRI)
      : MCInstPrinter(MAI, MII, MRI) {}

  // Autogenerated by tblgen.
  std::pair<const char *, uint64_t> getMnemonic(const MCInst *MI) override;
  void printInstruction(const MCInst *MI, uint64_t Address, raw_ostream &O);
  static const char *getRegisterName(unsigned RegNo);

  void printRegName(raw_ostream &OS, unsigned RegNo) const override;
  void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                 const MCSubtargetInfo &STI, raw_ostream &O) override;

private:
  void printMemOperandRI(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  void printOperand(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  void printOperand(const MCInst *MI, uint64_t /*Address*/, unsigned OpNum,
                    raw_ostream &O) {
    printOperand(MI, OpNum, O);
  }
  void printPredicateOperand(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  void printBRCCPredicateOperand(const MCInst *MI, unsigned OpNum,
                                 raw_ostream &O);
};
} // end namespace llvm

#endif // LLVM_LIB_TARGET_ARC_INSTPRINTER_ARCINSTPRINTER_H
