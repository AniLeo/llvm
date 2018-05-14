//=- WebAssemblyMCCodeEmitter.cpp - Convert WebAssembly code to machine code -//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file implements the WebAssemblyMCCodeEmitter class.
///
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/WebAssemblyFixupKinds.h"
#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/LEB128.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "mccodeemitter"

STATISTIC(MCNumEmitted, "Number of MC instructions emitted.");
STATISTIC(MCNumFixups, "Number of MC fixups created.");

namespace {
class WebAssemblyMCCodeEmitter final : public MCCodeEmitter {
  const MCInstrInfo &MCII;

  // Implementation generated by tablegen.
  uint64_t getBinaryCodeForInstr(const MCInst &MI,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  void encodeInstruction(const MCInst &MI, raw_ostream &OS,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const override;

public:
  WebAssemblyMCCodeEmitter(const MCInstrInfo &mcii) : MCII(mcii) {}
};
} // end anonymous namespace

MCCodeEmitter *llvm::createWebAssemblyMCCodeEmitter(const MCInstrInfo &MCII) {
  return new WebAssemblyMCCodeEmitter(MCII);
}

void WebAssemblyMCCodeEmitter::encodeInstruction(
    const MCInst &MI, raw_ostream &OS, SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI) const {
  uint64_t Start = OS.tell();

  uint64_t Binary = getBinaryCodeForInstr(MI, Fixups, STI);
  if (Binary <= UINT8_MAX) {
    OS << uint8_t(Binary);
  } else {
    assert(Binary <= UINT16_MAX && "Several-byte opcodes not supported yet");
    OS << uint8_t(Binary >> 8)
       << uint8_t(Binary);
  }

  // For br_table instructions, encode the size of the table. In the MCInst,
  // there's an index operand, one operand for each table entry, and the
  // default operand.
  if (MI.getOpcode() == WebAssembly::BR_TABLE_I32 ||
      MI.getOpcode() == WebAssembly::BR_TABLE_I64)
    encodeULEB128(MI.getNumOperands() - 2, OS);

  const MCInstrDesc &Desc = MCII.get(MI.getOpcode());
  for (unsigned i = 0, e = MI.getNumOperands(); i < e; ++i) {
    const MCOperand &MO = MI.getOperand(i);
    if (MO.isReg()) {
      /* nothing to encode */
    } else if (MO.isImm()) {
      if (i < Desc.getNumOperands()) {
        assert(Desc.TSFlags == 0 &&
               "WebAssembly non-variable_ops don't use TSFlags");
        const MCOperandInfo &Info = Desc.OpInfo[i];
        LLVM_DEBUG(dbgs() << "Encoding immediate: type="
                          << int(Info.OperandType) << "\n");
        if (Info.OperandType == WebAssembly::OPERAND_I32IMM) {
          encodeSLEB128(int32_t(MO.getImm()), OS);
        } else if (Info.OperandType == WebAssembly::OPERAND_OFFSET32) {
          encodeULEB128(uint32_t(MO.getImm()), OS);
        } else if (Info.OperandType == WebAssembly::OPERAND_I64IMM) {
          encodeSLEB128(int64_t(MO.getImm()), OS);
        } else if (Info.OperandType == WebAssembly::OPERAND_GLOBAL) {
          llvm_unreachable("wasm globals should only be accessed symbolicly");
        } else if (Info.OperandType == WebAssembly::OPERAND_SIGNATURE) {
          OS << uint8_t(MO.getImm());
        } else {
          encodeULEB128(uint64_t(MO.getImm()), OS);
        }
      } else {
        assert(Desc.TSFlags == (WebAssemblyII::VariableOpIsImmediate |
                                WebAssemblyII::VariableOpImmediateIsLabel));
        encodeULEB128(uint64_t(MO.getImm()), OS);
      }
    } else if (MO.isFPImm()) {
      assert(i < Desc.getNumOperands() &&
             "Unexpected floating-point immediate as a non-fixed operand");
      assert(Desc.TSFlags == 0 &&
             "WebAssembly variable_ops floating point ops don't use TSFlags");
      const MCOperandInfo &Info = Desc.OpInfo[i];
      if (Info.OperandType == WebAssembly::OPERAND_F32IMM) {
        // TODO: MC converts all floating point immediate operands to double.
        // This is fine for numeric values, but may cause NaNs to change bits.
        float f = float(MO.getFPImm());
        support::endian::Writer<support::little>(OS).write<float>(f);
      } else {
        assert(Info.OperandType == WebAssembly::OPERAND_F64IMM);
        double d = MO.getFPImm();
        support::endian::Writer<support::little>(OS).write<double>(d);
      }
    } else if (MO.isExpr()) {
      const MCOperandInfo &Info = Desc.OpInfo[i];
      llvm::MCFixupKind FixupKind;
      size_t PaddedSize = 5;
      if (Info.OperandType == WebAssembly::OPERAND_I32IMM) {
        FixupKind = MCFixupKind(WebAssembly::fixup_code_sleb128_i32);
      } else if (Info.OperandType == WebAssembly::OPERAND_I64IMM) {
        FixupKind = MCFixupKind(WebAssembly::fixup_code_sleb128_i64);
        PaddedSize = 10;
      } else if (Info.OperandType == WebAssembly::OPERAND_FUNCTION32 ||
                 Info.OperandType == WebAssembly::OPERAND_OFFSET32 ||
                 Info.OperandType == WebAssembly::OPERAND_TYPEINDEX) {
        FixupKind = MCFixupKind(WebAssembly::fixup_code_uleb128_i32);
      } else if (Info.OperandType == WebAssembly::OPERAND_GLOBAL) {
        FixupKind = MCFixupKind(WebAssembly::fixup_code_global_index);
      } else {
        llvm_unreachable("unexpected symbolic operand kind");
      }
      Fixups.push_back(MCFixup::create(
          OS.tell() - Start, MO.getExpr(),
          FixupKind, MI.getLoc()));
      ++MCNumFixups;
      encodeULEB128(0, OS, PaddedSize);
    } else {
      llvm_unreachable("unexpected operand kind");
    }
  }

  ++MCNumEmitted; // Keep track of the # of mi's emitted.
}

#include "WebAssemblyGenMCCodeEmitter.inc"
