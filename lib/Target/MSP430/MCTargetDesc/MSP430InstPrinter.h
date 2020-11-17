//= MSP430InstPrinter.h - Convert MSP430 MCInst to assembly syntax -*- C++ -*-//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This class prints a MSP430 MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_MSP430_MCTARGETDESC_MSP430INSTPRINTER_H
#define LLVM_LIB_TARGET_MSP430_MCTARGETDESC_MSP430INSTPRINTER_H

#include "llvm/MC/MCInstPrinter.h"

namespace llvm {
  class MSP430InstPrinter : public MCInstPrinter {
  public:
    MSP430InstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                      const MCRegisterInfo &MRI)
      : MCInstPrinter(MAI, MII, MRI) {}

    void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                   const MCSubtargetInfo &STI, raw_ostream &O) override;

    // Autogenerated by tblgen.
    std::pair<const char *, uint64_t> getMnemonic(const MCInst *MI) override;
    void printInstruction(const MCInst *MI, uint64_t Address, raw_ostream &O);
    bool printAliasInstr(const MCInst *MI, uint64_t Address, raw_ostream &O);
    void printCustomAliasOperand(const MCInst *MI, uint64_t Address,
                                 unsigned OpIdx, unsigned PrintMethodIdx,
                                 raw_ostream &O);
    static const char *getRegisterName(unsigned RegNo);

private:
    void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O,
                      const char *Modifier = nullptr);
    void printPCRelImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
    void printSrcMemOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O,
                            const char *Modifier = nullptr);
    void printIndRegOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
    void printPostIndRegOperand(const MCInst *MI, unsigned OpNo,
                                raw_ostream &O);
    void printCCOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);

  };
}

#endif
