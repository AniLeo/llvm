// WebAssemblyInstPrinter.h - Print wasm MCInst to assembly syntax -*- C++ -*-//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This class prints an WebAssembly MCInst to wasm file syntax.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_WEBASSEMBLY_INSTPRINTER_WEBASSEMBLYINSTPRINTER_H
#define LLVM_LIB_TARGET_WEBASSEMBLY_INSTPRINTER_WEBASSEMBLYINSTPRINTER_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/BinaryFormat/Wasm.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/Support/MachineValueType.h"

namespace llvm {

class MCSubtargetInfo;

class WebAssemblyInstPrinter final : public MCInstPrinter {
  uint64_t ControlFlowCounter = 0;
  uint64_t EHPadStackCounter = 0;
  SmallVector<std::pair<uint64_t, bool>, 4> ControlFlowStack;
  SmallVector<uint64_t, 4> EHPadStack;

  enum EHInstKind { TRY, CATCH, END_TRY };
  EHInstKind LastSeenEHInst = END_TRY;

public:
  WebAssemblyInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                         const MCRegisterInfo &MRI);

  void printRegName(raw_ostream &OS, unsigned RegNo) const override;
  void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                 const MCSubtargetInfo &STI, raw_ostream &OS) override;

  // Used by tblegen code.
  void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O,
                    bool IsVariadicDef = false);
  void printBrList(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printWebAssemblyP2AlignOperand(const MCInst *MI, unsigned OpNo,
                                      raw_ostream &O);
  void printWebAssemblySignatureOperand(const MCInst *MI, unsigned OpNo,
                                        raw_ostream &O);
  void printWebAssemblyHeapTypeOperand(const MCInst *MI, unsigned OpNo,
                                       raw_ostream &O);

  // Autogenerated by tblgen.
  void printInstruction(const MCInst *MI, uint64_t Address, raw_ostream &O);
  static const char *getRegisterName(unsigned RegNo);
};

namespace WebAssembly {

const char *typeToString(wasm::ValType Ty);
const char *anyTypeToString(unsigned Ty);

std::string typeListToString(ArrayRef<wasm::ValType> List);
std::string signatureToString(const wasm::WasmSignature *Sig);

} // end namespace WebAssembly

} // end namespace llvm

#endif
