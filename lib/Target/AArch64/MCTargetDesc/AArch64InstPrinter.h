//===-- AArch64InstPrinter.h - Convert AArch64 MCInst to assembly syntax --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This class prints an AArch64 MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_MCTARGETDESC_AARCH64INSTPRINTER_H
#define LLVM_LIB_TARGET_AARCH64_MCTARGETDESC_AARCH64INSTPRINTER_H

#include "MCTargetDesc/AArch64MCTargetDesc.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/MC/MCInstPrinter.h"
#include "../Utils/AArch64BaseInfo.h"

namespace llvm {

class AArch64InstPrinter : public MCInstPrinter {
public:
  AArch64InstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                     const MCRegisterInfo &MRI);

  bool applyTargetSpecificCLOption(StringRef Opt) override;

  void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                 const MCSubtargetInfo &STI, raw_ostream &O) override;
  void printRegName(raw_ostream &OS, unsigned RegNo) const override;

  // Autogenerated by tblgen.
  std::pair<const char *, uint64_t> getMnemonic(const MCInst *MI) override;
  virtual void printInstruction(const MCInst *MI, uint64_t Address,
                                const MCSubtargetInfo &STI, raw_ostream &O);
  virtual bool printAliasInstr(const MCInst *MI, uint64_t Address,
                               const MCSubtargetInfo &STI, raw_ostream &O);
  virtual void printCustomAliasOperand(const MCInst *MI, uint64_t Address,
                                       unsigned OpIdx, unsigned PrintMethodIdx,
                                       const MCSubtargetInfo &STI,
                                       raw_ostream &O);

  virtual StringRef getRegName(unsigned RegNo) const {
    return getRegisterName(RegNo);
  }

  static const char *getRegisterName(unsigned RegNo,
                                     unsigned AltIdx = AArch64::NoRegAltName);

protected:
  bool printSysAlias(const MCInst *MI, const MCSubtargetInfo &STI,
                     raw_ostream &O);
  // Operand printers
  void printOperand(const MCInst *MI, unsigned OpNo, const MCSubtargetInfo &STI,
                    raw_ostream &O);
  void printImm(const MCInst *MI, unsigned OpNo, const MCSubtargetInfo &STI,
                raw_ostream &O);
  void printImmHex(const MCInst *MI, unsigned OpNo, const MCSubtargetInfo &STI,
                   raw_ostream &O);
  template <int Size>
  void printSImm(const MCInst *MI, unsigned OpNo, const MCSubtargetInfo &STI,
                 raw_ostream &O);
  template <typename T> void printImmSVE(T Value, raw_ostream &O);
  void printPostIncOperand(const MCInst *MI, unsigned OpNo, unsigned Imm,
                           raw_ostream &O);
  template <int Amount>
  void printPostIncOperand(const MCInst *MI, unsigned OpNo,
                           const MCSubtargetInfo &STI, raw_ostream &O) {
    printPostIncOperand(MI, OpNo, Amount, O);
  }

  void printVRegOperand(const MCInst *MI, unsigned OpNo,
                        const MCSubtargetInfo &STI, raw_ostream &O);
  void printSysCROperand(const MCInst *MI, unsigned OpNo,
                         const MCSubtargetInfo &STI, raw_ostream &O);
  void printAddSubImm(const MCInst *MI, unsigned OpNum,
                      const MCSubtargetInfo &STI, raw_ostream &O);
  template <typename T>
  void printLogicalImm(const MCInst *MI, unsigned OpNum,
                       const MCSubtargetInfo &STI, raw_ostream &O);
  void printShifter(const MCInst *MI, unsigned OpNum,
                    const MCSubtargetInfo &STI, raw_ostream &O);
  void printShiftedRegister(const MCInst *MI, unsigned OpNum,
                            const MCSubtargetInfo &STI, raw_ostream &O);
  void printExtendedRegister(const MCInst *MI, unsigned OpNum,
                             const MCSubtargetInfo &STI, raw_ostream &O);
  void printArithExtend(const MCInst *MI, unsigned OpNum,
                        const MCSubtargetInfo &STI, raw_ostream &O);

  void printMemExtend(const MCInst *MI, unsigned OpNum, raw_ostream &O,
                      char SrcRegKind, unsigned Width);
  template <char SrcRegKind, unsigned Width>
  void printMemExtend(const MCInst *MI, unsigned OpNum,
                      const MCSubtargetInfo &STI, raw_ostream &O) {
    printMemExtend(MI, OpNum, O, SrcRegKind, Width);
  }
  template <bool SignedExtend, int ExtWidth, char SrcRegKind, char Suffix>
  void printRegWithShiftExtend(const MCInst *MI, unsigned OpNum,
                               const MCSubtargetInfo &STI, raw_ostream &O);
  void printCondCode(const MCInst *MI, unsigned OpNum,
                     const MCSubtargetInfo &STI, raw_ostream &O);
  void printInverseCondCode(const MCInst *MI, unsigned OpNum,
                            const MCSubtargetInfo &STI, raw_ostream &O);
  void printAlignedLabel(const MCInst *MI, uint64_t Address, unsigned OpNum,
                         const MCSubtargetInfo &STI, raw_ostream &O);
  void printUImm12Offset(const MCInst *MI, unsigned OpNum, unsigned Scale,
                         raw_ostream &O);
  void printAMIndexedWB(const MCInst *MI, unsigned OpNum, unsigned Scale,
                        raw_ostream &O);

  template <int Scale>
  void printUImm12Offset(const MCInst *MI, unsigned OpNum,
                         const MCSubtargetInfo &STI, raw_ostream &O) {
    printUImm12Offset(MI, OpNum, Scale, O);
  }

  template <int BitWidth>
  void printAMIndexedWB(const MCInst *MI, unsigned OpNum,
                        const MCSubtargetInfo &STI, raw_ostream &O) {
    printAMIndexedWB(MI, OpNum, BitWidth / 8, O);
  }

  void printAMNoIndex(const MCInst *MI, unsigned OpNum,
                      const MCSubtargetInfo &STI, raw_ostream &O);

  template <int Scale>
  void printImmScale(const MCInst *MI, unsigned OpNum,
                     const MCSubtargetInfo &STI, raw_ostream &O);

  template <bool IsSVEPrefetch = false>
  void printPrefetchOp(const MCInst *MI, unsigned OpNum,
                       const MCSubtargetInfo &STI, raw_ostream &O);

  void printPSBHintOp(const MCInst *MI, unsigned OpNum,
                      const MCSubtargetInfo &STI, raw_ostream &O);

  void printBTIHintOp(const MCInst *MI, unsigned OpNum,
                      const MCSubtargetInfo &STI, raw_ostream &O);

  void printFPImmOperand(const MCInst *MI, unsigned OpNum,
                         const MCSubtargetInfo &STI, raw_ostream &O);

  void printVectorList(const MCInst *MI, unsigned OpNum,
                       const MCSubtargetInfo &STI, raw_ostream &O,
                       StringRef LayoutSuffix);

  /// Print a list of vector registers where the type suffix is implicit
  /// (i.e. attached to the instruction rather than the registers).
  void printImplicitlyTypedVectorList(const MCInst *MI, unsigned OpNum,
                                      const MCSubtargetInfo &STI,
                                      raw_ostream &O);

  template <unsigned NumLanes, char LaneKind>
  void printTypedVectorList(const MCInst *MI, unsigned OpNum,
                            const MCSubtargetInfo &STI, raw_ostream &O);

  void printVectorIndex(const MCInst *MI, unsigned OpNum,
                        const MCSubtargetInfo &STI, raw_ostream &O);
  void printAdrpLabel(const MCInst *MI, uint64_t Address, unsigned OpNum,
                      const MCSubtargetInfo &STI, raw_ostream &O);
  void printBarrierOption(const MCInst *MI, unsigned OpNum,
                          const MCSubtargetInfo &STI, raw_ostream &O);
  void printBarriernXSOption(const MCInst *MI, unsigned OpNum,
                             const MCSubtargetInfo &STI, raw_ostream &O);
  void printMSRSystemRegister(const MCInst *MI, unsigned OpNum,
                              const MCSubtargetInfo &STI, raw_ostream &O);
  void printMRSSystemRegister(const MCInst *MI, unsigned OpNum,
                              const MCSubtargetInfo &STI, raw_ostream &O);
  void printSystemPStateField(const MCInst *MI, unsigned OpNum,
                              const MCSubtargetInfo &STI, raw_ostream &O);
  void printSIMDType10Operand(const MCInst *MI, unsigned OpNum,
                              const MCSubtargetInfo &STI, raw_ostream &O);
  template<int64_t Angle, int64_t Remainder>
  void printComplexRotationOp(const MCInst *MI, unsigned OpNo,
                            const MCSubtargetInfo &STI, raw_ostream &O);
  template<unsigned size>
  void printGPRSeqPairsClassOperand(const MCInst *MI, unsigned OpNum,
                                    const MCSubtargetInfo &STI,
                                    raw_ostream &O);
  template <typename T>
  void printImm8OptLsl(const MCInst *MI, unsigned OpNum,
                       const MCSubtargetInfo &STI, raw_ostream &O);
  template <typename T>
  void printSVELogicalImm(const MCInst *MI, unsigned OpNum,
                          const MCSubtargetInfo &STI, raw_ostream &O);
  void printSVEPattern(const MCInst *MI, unsigned OpNum,
                       const MCSubtargetInfo &STI, raw_ostream &O);

  template <bool IsVertical>
  void printMatrixTileVector(const MCInst *MI, unsigned OpNum,
                             const MCSubtargetInfo &STI, raw_ostream &O);
  void printMatrixTile(const MCInst *MI, unsigned OpNum,
                       const MCSubtargetInfo &STI, raw_ostream &O);
  template <int EltSize>
  void printMatrix(const MCInst *MI, unsigned OpNum, const MCSubtargetInfo &STI,
                   raw_ostream &O);
  void printSVCROp(const MCInst *MI, unsigned OpNum, const MCSubtargetInfo &STI,
                   raw_ostream &O);
  template <char = 0>
  void printSVERegOp(const MCInst *MI, unsigned OpNum,
                    const MCSubtargetInfo &STI, raw_ostream &O);
  void printGPR64as32(const MCInst *MI, unsigned OpNum,
                      const MCSubtargetInfo &STI, raw_ostream &O);
  void printGPR64x8(const MCInst *MI, unsigned OpNum,
                    const MCSubtargetInfo &STI, raw_ostream &O);
  template <int Width>
  void printZPRasFPR(const MCInst *MI, unsigned OpNum,
                     const MCSubtargetInfo &STI, raw_ostream &O);
  template <unsigned ImmIs0, unsigned ImmIs1>
  void printExactFPImm(const MCInst *MI, unsigned OpNum,
                       const MCSubtargetInfo &STI, raw_ostream &O);
};

class AArch64AppleInstPrinter : public AArch64InstPrinter {
public:
  AArch64AppleInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                          const MCRegisterInfo &MRI);

  void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                 const MCSubtargetInfo &STI, raw_ostream &O) override;

  std::pair<const char *, uint64_t> getMnemonic(const MCInst *MI) override;
  void printInstruction(const MCInst *MI, uint64_t Address,
                        const MCSubtargetInfo &STI, raw_ostream &O) override;
  bool printAliasInstr(const MCInst *MI, uint64_t Address,
                       const MCSubtargetInfo &STI, raw_ostream &O) override;
  void printCustomAliasOperand(const MCInst *MI, uint64_t Address,
                               unsigned OpIdx, unsigned PrintMethodIdx,
                               const MCSubtargetInfo &STI,
                               raw_ostream &O) override;

  StringRef getRegName(unsigned RegNo) const override {
    return getRegisterName(RegNo);
  }

  static const char *getRegisterName(unsigned RegNo,
                                     unsigned AltIdx = AArch64::NoRegAltName);
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_AARCH64_MCTARGETDESC_AARCH64INSTPRINTER_H
