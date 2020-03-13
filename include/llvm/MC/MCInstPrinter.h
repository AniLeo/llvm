//===- MCInstPrinter.h - MCInst to target assembly syntax -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCINSTPRINTER_H
#define LLVM_MC_MCINSTPRINTER_H

#include "llvm/Support/Format.h"
#include <cstdint>

namespace llvm {

class MCAsmInfo;
class MCInst;
class MCOperand;
class MCInstrInfo;
class MCRegisterInfo;
class MCSubtargetInfo;
class raw_ostream;
class StringRef;

/// Convert `Bytes' to a hex string and output to `OS'
void dumpBytes(ArrayRef<uint8_t> Bytes, raw_ostream &OS);

namespace HexStyle {

enum Style {
  C,  ///< 0xff
  Asm ///< 0ffh
};

} // end namespace HexStyle

struct AliasMatchingData;

/// This is an instance of a target assembly language printer that
/// converts an MCInst to valid target assembly syntax.
class MCInstPrinter {
protected:
  /// A stream that comments can be emitted to if desired.  Each comment
  /// must end with a newline.  This will be null if verbose assembly emission
  /// is disabled.
  raw_ostream *CommentStream = nullptr;
  const MCAsmInfo &MAI;
  const MCInstrInfo &MII;
  const MCRegisterInfo &MRI;

  /// True if we are printing marked up assembly.
  bool UseMarkup = false;

  /// True if we are printing immediates as hex.
  bool PrintImmHex = false;

  /// Which style to use for printing hexadecimal values.
  HexStyle::Style PrintHexStyle = HexStyle::C;

  /// Utility function for printing annotations.
  void printAnnotation(raw_ostream &OS, StringRef Annot);

  /// Helper for matching MCInsts to alias patterns when printing instructions.
  const char *matchAliasPatterns(const MCInst *MI, const MCSubtargetInfo *STI,
                                 const AliasMatchingData &M);

public:
  MCInstPrinter(const MCAsmInfo &mai, const MCInstrInfo &mii,
                const MCRegisterInfo &mri) : MAI(mai), MII(mii), MRI(mri) {}

  virtual ~MCInstPrinter();

  /// Customize the printer according to a command line option.
  /// @return true if the option is recognized and applied.
  virtual bool applyTargetSpecificCLOption(StringRef Opt) { return false; }

  /// Specify a stream to emit comments to.
  void setCommentStream(raw_ostream &OS) { CommentStream = &OS; }

  /// Print the specified MCInst to the specified raw_ostream.
  virtual void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                         const MCSubtargetInfo &STI, raw_ostream &OS) = 0;

  /// Return the name of the specified opcode enum (e.g. "MOV32ri") or
  /// empty if we can't resolve it.
  StringRef getOpcodeName(unsigned Opcode) const;

  /// Print the assembler register name.
  virtual void printRegName(raw_ostream &OS, unsigned RegNo) const;

  bool getUseMarkup() const { return UseMarkup; }
  void setUseMarkup(bool Value) { UseMarkup = Value; }

  /// Utility functions to make adding mark ups simpler.
  StringRef markup(StringRef s) const;

  bool getPrintImmHex() const { return PrintImmHex; }
  void setPrintImmHex(bool Value) { PrintImmHex = Value; }

  void setPrintHexStyle(HexStyle::Style Value) { PrintHexStyle = Value; }

  /// Utility function to print immediates in decimal or hex.
  format_object<int64_t> formatImm(int64_t Value) const {
    return PrintImmHex ? formatHex(Value) : formatDec(Value);
  }

  /// Utility functions to print decimal/hexadecimal values.
  format_object<int64_t> formatDec(int64_t Value) const;
  format_object<int64_t> formatHex(int64_t Value) const;
  format_object<uint64_t> formatHex(uint64_t Value) const;
};

/// Map from opcode to pattern list by binary search.
struct PatternsForOpcode {
  uint32_t Opcode;
  uint16_t PatternStart;
  uint16_t NumPatterns;
};

/// Data for each alias pattern. Includes feature bits, string, number of
/// operands, and a variadic list of conditions to check.
struct AliasPattern {
  uint32_t AsmStrOffset;
  uint32_t AliasCondStart;
  uint8_t NumOperands;
  uint8_t NumConds;
};

struct AliasPatternCond {
  enum CondKind : uint8_t {
    K_Feature,       // Match only if a feature is enabled.
    K_NegFeature,    // Match only if a feature is disabled.
    K_OrFeature,     // Match only if one of a set of features is enabled.
    K_OrNegFeature,  // Match only if one of a set of features is disabled.
    K_EndOrFeatures, // Note end of list of K_Or(Neg)?Features.
    K_Ignore,        // Match any operand.
    K_Reg,           // Match a specific register.
    K_TiedReg,       // Match another already matched register.
    K_Imm,           // Match a specific immediate.
    K_RegClass,      // Match registers in a class.
    K_Custom,        // Call custom matcher by index.
  };

  CondKind Kind;
  uint32_t Value;
};

/// Tablegenerated data structures needed to match alias patterns.
struct AliasMatchingData {
  ArrayRef<PatternsForOpcode> OpToPatterns;
  ArrayRef<AliasPattern> Patterns;
  ArrayRef<AliasPatternCond> PatternConds;
  StringRef AsmStrings;
  bool (*ValidateMCOperand)(const MCOperand &MCOp, const MCSubtargetInfo &STI,
                            unsigned PredicateIndex);
};

} // end namespace llvm

#endif // LLVM_MC_MCINSTPRINTER_H
