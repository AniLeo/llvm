//===-- CFGPrinter.h - CFG printer external interface -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines a 'dot-cfg' analysis pass, which emits the
// cfg.<fnname>.dot file for each function in the program, with a graph of the
// CFG for that function.
//
// This file defines external functions that can be called to explicitly
// instantiate the CFG printer.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_ANALYSIS_CFGPRINTER_H
#define LLVM_ANALYSIS_CFGPRINTER_H

#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/GraphWriter.h"

namespace llvm {
class CFGViewerPass
    : public PassInfoMixin<CFGViewerPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CFGOnlyViewerPass
    : public PassInfoMixin<CFGOnlyViewerPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CFGPrinterPass
    : public PassInfoMixin<CFGPrinterPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class CFGOnlyPrinterPass
    : public PassInfoMixin<CFGOnlyPrinterPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

class DOTFuncInfo {
private:
  const Function *F;
  const BlockFrequencyInfo *BFI;
  const BranchProbabilityInfo *BPI;

public:
  DOTFuncInfo(const Function *F) : DOTFuncInfo(F, nullptr, nullptr) {}

  DOTFuncInfo(const Function *F, const BlockFrequencyInfo *BFI,
             BranchProbabilityInfo *BPI)
      : F(F), BFI(BFI), BPI(BPI) {
  }

  const BlockFrequencyInfo *getBFI() { return BFI; }

  const BranchProbabilityInfo *getBPI() { return BPI; }

  const Function *getFunction() { return this->F; }
};

template <>
struct GraphTraits<DOTFuncInfo *> : public GraphTraits<const BasicBlock *> {
  static NodeRef getEntryNode(DOTFuncInfo *CFGInfo) {
    return &(CFGInfo->getFunction()->getEntryBlock());
  }

  // nodes_iterator/begin/end - Allow iteration over all nodes in the graph
  using nodes_iterator = pointer_iterator<Function::const_iterator>;

  static nodes_iterator nodes_begin(DOTFuncInfo *CFGInfo) {
    return nodes_iterator(CFGInfo->getFunction()->begin());
  }

  static nodes_iterator nodes_end(DOTFuncInfo *CFGInfo) {
    return nodes_iterator(CFGInfo->getFunction()->end());
  }

  static size_t size(DOTFuncInfo *CFGInfo) {
    return CFGInfo->getFunction()->size();
  }
};

template <> struct DOTGraphTraits<DOTFuncInfo *> : public DefaultDOTGraphTraits {

  // Cache for is hidden property
  llvm::DenseMap <const BasicBlock *, bool> isHiddenBasicBlock;

  DOTGraphTraits (bool isSimple=false) : DefaultDOTGraphTraits(isSimple) {}

  static std::string getGraphName(DOTFuncInfo *CFGInfo) {
    return "CFG for '" + CFGInfo->getFunction()->getName().str() + "' function";
  }

  static std::string getSimpleNodeLabel(const BasicBlock *Node, DOTFuncInfo *) {
    if (!Node->getName().empty())
      return Node->getName().str();

    std::string Str;
    raw_string_ostream OS(Str);

    Node->printAsOperand(OS, false);
    return OS.str();
  }

  static std::string getCompleteNodeLabel(const BasicBlock *Node,
                                          DOTFuncInfo *) {
    enum { MaxColumns = 80 };
    std::string Str;
    raw_string_ostream OS(Str);

    if (Node->getName().empty()) {
      Node->printAsOperand(OS, false);
      OS << ":";
    }

    OS << *Node;
    std::string OutStr = OS.str();
    if (OutStr[0] == '\n') OutStr.erase(OutStr.begin());

    // Process string output to make it nicer...
    unsigned ColNum = 0;
    unsigned LastSpace = 0;
    for (unsigned i = 0; i != OutStr.length(); ++i) {
      if (OutStr[i] == '\n') {                            // Left justify
        OutStr[i] = '\\';
        OutStr.insert(OutStr.begin()+i+1, 'l');
        ColNum = 0;
        LastSpace = 0;
      } else if (OutStr[i] == ';') {                      // Delete comments!
        unsigned Idx = OutStr.find('\n', i+1);            // Find end of line
        OutStr.erase(OutStr.begin()+i, OutStr.begin()+Idx);
        --i;
      } else if (ColNum == MaxColumns) {                  // Wrap lines.
        // Wrap very long names even though we can't find a space.
        if (!LastSpace)
          LastSpace = i;
        OutStr.insert(LastSpace, "\\l...");
        ColNum = i - LastSpace;
        LastSpace = 0;
        i += 3; // The loop will advance 'i' again.
      }
      else
        ++ColNum;
      if (OutStr[i] == ' ')
        LastSpace = i;
    }
    return OutStr;
  }

  std::string getNodeLabel(const BasicBlock *Node,
                           DOTFuncInfo *CFGInfo) {

    if (isSimple())
      return getSimpleNodeLabel(Node, CFGInfo);
    else
      return getCompleteNodeLabel(Node, CFGInfo);
  }

  static std::string getEdgeSourceLabel(const BasicBlock *Node,
                                        const_succ_iterator I) {
    // Label source of conditional branches with "T" or "F"
    if (const BranchInst *BI = dyn_cast<BranchInst>(Node->getTerminator()))
      if (BI->isConditional())
        return (I == succ_begin(Node)) ? "T" : "F";

    // Label source of switch edges with the associated value.
    if (const SwitchInst *SI = dyn_cast<SwitchInst>(Node->getTerminator())) {
      unsigned SuccNo = I.getSuccessorIndex();

      if (SuccNo == 0) return "def";

      std::string Str;
      raw_string_ostream OS(Str);
      auto Case = *SwitchInst::ConstCaseIt::fromSuccessorIndex(SI, SuccNo);
      OS << Case.getCaseValue()->getValue();
      return OS.str();
    }
    return "";
  }

  /// Display the raw branch weights from PGO.
  std::string getEdgeAttributes(const BasicBlock *Node, const_succ_iterator I,
                                DOTFuncInfo *CFGInfo) {
    const Instruction *TI = Node->getTerminator();
    if (TI->getNumSuccessors() == 1)
      return "";
    MDNode *WeightsNode = TI->getMetadata(LLVMContext::MD_prof);
    if (!WeightsNode)
      return "";

    MDString *MDName = cast<MDString>(WeightsNode->getOperand(0));
    if (MDName->getString() != "branch_weights")
      return "";
    unsigned OpNo = I.getSuccessorIndex() + 1;
    if (OpNo >= WeightsNode->getNumOperands())
      return "";
    ConstantInt *Weight =
        mdconst::dyn_extract<ConstantInt>(WeightsNode->getOperand(OpNo));
    if (!Weight)
      return "";

    // Prepend a 'W' to indicate that this is a weight rather than the actual
    // profile count (due to scaling).
    return ("label=\"W:" + Twine(Weight->getZExtValue()) + "\"").str();
  }
  bool isNodeHidden(const BasicBlock *Node);
  void computeHiddenNodes(const Function *F);
};
} // End llvm namespace

namespace llvm {
  class FunctionPass;
  FunctionPass *createCFGPrinterLegacyPassPass ();
  FunctionPass *createCFGOnlyPrinterLegacyPassPass ();
} // End llvm namespace

#endif
