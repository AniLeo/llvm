//===- PPCInstPrinter.h - Convert PPC MCInst to assembly syntax -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This class prints an PPC MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_POWERPC_MCTARGETDESC_PPCINSTPRINTER_H
#define LLVM_LIB_TARGET_POWERPC_MCTARGETDESC_PPCINSTPRINTER_H

#include "llvm/ADT/Triple.h"
#include "llvm/MC/MCInstPrinter.h"

namespace llvm {

class PPCInstPrinter : public MCInstPrinter {
  Triple TT;
private:
  bool showRegistersWithPercentPrefix(const char *RegName) const;
  bool showRegistersWithPrefix() const;
  const char *getVerboseConditionRegName(unsigned RegNum,
                                         unsigned RegEncoding) const;

public:
  PPCInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                 const MCRegisterInfo &MRI, Triple T)
    : MCInstPrinter(MAI, MII, MRI), TT(T) {}

  void printRegName(raw_ostream &OS, unsigned RegNo) const override;
  void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                 const MCSubtargetInfo &STI, raw_ostream &O) override;

  // Autogenerated by tblgen.
  void printInstruction(const MCInst *MI, uint64_t Address, raw_ostream &O);
  static const char *getRegisterName(unsigned RegNo);

  bool printAliasInstr(const MCInst *MI, uint64_t Address, raw_ostream &OS);
  void printCustomAliasOperand(const MCInst *MI, uint64_t Address,
                               unsigned OpIdx, unsigned PrintMethodIdx,
                               raw_ostream &OS);

  void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printPredicateOperand(const MCInst *MI, unsigned OpNo,
                             raw_ostream &O, const char *Modifier = nullptr);
  void printATBitsAsHint(const MCInst *MI, unsigned OpNo, raw_ostream &O);

  void printU1ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU2ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU3ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU4ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printS5ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU5ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU6ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU7ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU8ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU10ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU12ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printS16ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printS34ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printU16ImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printImmZeroOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printBranchOperand(const MCInst *MI, uint64_t Address, unsigned OpNo,
                          raw_ostream &O);
  void printAbsBranchOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printTLSCall(const MCInst *MI, unsigned OpNo, raw_ostream &O);

  void printcrbitm(const MCInst *MI, unsigned OpNo, raw_ostream &O);

  void printMemRegImm(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemRegImm34PCRel(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemRegImm34(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemRegReg(const MCInst *MI, unsigned OpNo, raw_ostream &O);
};
} // end namespace llvm

#endif
