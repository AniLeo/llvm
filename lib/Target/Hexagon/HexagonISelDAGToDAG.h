//===-- HexagonISelDAGToDAG.h -----------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
// Hexagon specific code to select Hexagon machine instructions for
// SelectionDAG operations.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_HEXAGON_HEXAGONISELDAGTODAG_H
#define LLVM_LIB_TARGET_HEXAGON_HEXAGONISELDAGTODAG_H

#include "HexagonSubtarget.h"
#include "HexagonTargetMachine.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/Support/CodeGen.h"

#include <vector>

namespace llvm {
class MachineFunction;
class HexagonInstrInfo;
class HexagonRegisterInfo;
class HexagonTargetLowering;

class HexagonDAGToDAGISel : public SelectionDAGISel {
  const HexagonSubtarget *HST;
  const HexagonInstrInfo *HII;
  const HexagonRegisterInfo *HRI;
public:
  explicit HexagonDAGToDAGISel(HexagonTargetMachine &tm,
                               CodeGenOpt::Level OptLevel)
      : SelectionDAGISel(tm, OptLevel), HST(nullptr), HII(nullptr),
        HRI(nullptr) {}

  bool runOnMachineFunction(MachineFunction &MF) override {
    // Reset the subtarget each time through.
    HST = &MF.getSubtarget<HexagonSubtarget>();
    HII = HST->getInstrInfo();
    HRI = HST->getRegisterInfo();
    SelectionDAGISel::runOnMachineFunction(MF);
    updateAligna();
    return true;
  }

  bool ComplexPatternFuncMutatesDAG() const override {
    return true;
  }
  void PreprocessISelDAG() override;
  void EmitFunctionEntryCode() override;

  void Select(SDNode *N) override;

  // Complex Pattern Selectors.
  inline bool SelectAddrGA(SDValue &N, SDValue &R);
  inline bool SelectAddrGP(SDValue &N, SDValue &R);
  inline bool SelectAnyImm(SDValue &N, SDValue &R);
  inline bool SelectAnyInt(SDValue &N, SDValue &R);
  bool SelectAnyImmediate(SDValue &N, SDValue &R, uint32_t LogAlign);
  bool SelectGlobalAddress(SDValue &N, SDValue &R, bool UseGP,
                           uint32_t LogAlign);
  bool SelectAddrFI(SDValue &N, SDValue &R);
  bool DetectUseSxtw(SDValue &N, SDValue &R);

  inline bool SelectAnyImm0(SDValue &N, SDValue &R);
  inline bool SelectAnyImm1(SDValue &N, SDValue &R);
  inline bool SelectAnyImm2(SDValue &N, SDValue &R);
  inline bool SelectAnyImm3(SDValue &N, SDValue &R);

  StringRef getPassName() const override {
    return "Hexagon DAG->DAG Pattern Instruction Selection";
  }

  // Generate a machine instruction node corresponding to the circ/brev
  // load intrinsic.
  MachineSDNode *LoadInstrForLoadIntrinsic(SDNode *IntN);
  // Given the circ/brev load intrinsic and the already generated machine
  // instruction, generate the appropriate store (that is a part of the
  // intrinsic's functionality).
  SDNode *StoreInstrForLoadIntrinsic(MachineSDNode *LoadN, SDNode *IntN);

  void SelectFrameIndex(SDNode *N);
  /// SelectInlineAsmMemoryOperand - Implement addressing mode selection for
  /// inline asm expressions.
  bool SelectInlineAsmMemoryOperand(const SDValue &Op,
                                    unsigned ConstraintID,
                                    std::vector<SDValue> &OutOps) override;
  bool tryLoadOfLoadIntrinsic(LoadSDNode *N);
  bool SelectBrevLdIntrinsic(SDNode *IntN);
  bool SelectNewCircIntrinsic(SDNode *IntN);
  void SelectLoad(SDNode *N);
  void SelectIndexedLoad(LoadSDNode *LD, const SDLoc &dl);
  void SelectIndexedStore(StoreSDNode *ST, const SDLoc &dl);
  void SelectStore(SDNode *N);
  void SelectSHL(SDNode *N);
  void SelectZeroExtend(SDNode *N);
  void SelectIntrinsicWChain(SDNode *N);
  void SelectIntrinsicWOChain(SDNode *N);
  void SelectConstant(SDNode *N);
  void SelectConstantFP(SDNode *N);
  void SelectV65Gather(SDNode *N);
  void SelectV65GatherPred(SDNode *N);
  void SelectHVXDualOutput(SDNode *N);
  void SelectAddSubCarry(SDNode *N);
  void SelectVAlign(SDNode *N);
  void SelectVAlignAddr(SDNode *N);
  void SelectTypecast(SDNode *N);
  void SelectP2D(SDNode *N);
  void SelectD2P(SDNode *N);
  void SelectQ2V(SDNode *N);
  void SelectV2Q(SDNode *N);

  // Include the declarations autogenerated from the selection patterns.
  #define GET_DAGISEL_DECL
  #include "HexagonGenDAGISel.inc"

private:
  // This is really only to get access to ReplaceNode (which is a protected
  // member). Any other members used by HvxSelector can be moved around to
  // make them accessible).
  friend struct HvxSelector;

  SDValue selectUndef(const SDLoc &dl, MVT ResTy) {
    SDNode *U = CurDAG->getMachineNode(TargetOpcode::IMPLICIT_DEF, dl, ResTy);
    return SDValue(U, 0);
  }

  void SelectHvxShuffle(SDNode *N);
  void SelectHvxRor(SDNode *N);
  void SelectHvxVAlign(SDNode *N);

  bool keepsLowBits(const SDValue &Val, unsigned NumBits, SDValue &Src);
  bool isAlignedMemNode(const MemSDNode *N) const;
  bool isSmallStackStore(const StoreSDNode *N) const;
  bool isPositiveHalfWord(const SDNode *N) const;
  bool hasOneUse(const SDNode *N) const;

  // DAG preprocessing functions.
  void ppSimplifyOrSelect0(std::vector<SDNode*> &&Nodes);
  void ppAddrReorderAddShl(std::vector<SDNode*> &&Nodes);
  void ppAddrRewriteAndSrl(std::vector<SDNode*> &&Nodes);
  void ppHoistZextI1(std::vector<SDNode*> &&Nodes);

  // Function postprocessing.
  void updateAligna();

  SmallDenseMap<SDNode *,int> RootWeights;
  SmallDenseMap<SDNode *,int> RootHeights;
  SmallDenseMap<const Value *,int> GAUsesInFunction;
  int getWeight(SDNode *N);
  int getHeight(SDNode *N);
  SDValue getMultiplierForSHL(SDNode *N);
  SDValue factorOutPowerOf2(SDValue V, unsigned Power);
  unsigned getUsesInFunction(const Value *V);
  SDValue balanceSubTree(SDNode *N, bool Factorize = false);
  void rebalanceAddressTrees();
}; // end HexagonDAGToDAGISel
}

#endif // LLVM_LIB_TARGET_HEXAGON_HEXAGONISELDAGTODAG_H
