//===-- AbstractCallSite.cpp - Implementation of abstract call sites ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements abstract call sites which unify the interface for
// direct, indirect, and callback call sites.
//
// For more information see:
// https://llvm.org/devmtg/2018-10/talk-abstracts.html#talk20
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/IR/CallSite.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "abstract-call-sites"

STATISTIC(NumCallbackCallSites, "Number of callback call sites created");
STATISTIC(NumDirectAbstractCallSites,
          "Number of direct abstract call sites created");
STATISTIC(NumInvalidAbstractCallSitesUnknownUse,
          "Number of invalid abstract call sites created (unknown use)");
STATISTIC(NumInvalidAbstractCallSitesUnknownCallee,
          "Number of invalid abstract call sites created (unknown callee)");
STATISTIC(NumInvalidAbstractCallSitesNoCallback,
          "Number of invalid abstract call sites created (no callback)");

void AbstractCallSite::getCallbackUses(ImmutableCallSite ICS,
                                       SmallVectorImpl<const Use *> &CBUses) {
  const Function *Callee = ICS.getCalledFunction();
  if (!Callee)
    return;

  MDNode *CallbackMD = Callee->getMetadata(LLVMContext::MD_callback);
  if (!CallbackMD)
    return;

  for (const MDOperand &Op : CallbackMD->operands()) {
    MDNode *OpMD = cast<MDNode>(Op.get());
    auto *CBCalleeIdxAsCM = cast<ConstantAsMetadata>(OpMD->getOperand(0));
    uint64_t CBCalleeIdx =
        cast<ConstantInt>(CBCalleeIdxAsCM->getValue())->getZExtValue();
    CBUses.push_back(ICS.arg_begin() + CBCalleeIdx);
  }
}

/// Create an abstract call site from a use.
AbstractCallSite::AbstractCallSite(const Use *U) : CS(U->getUser()) {

  // First handle unknown users.
  if (!CS) {

    // If the use is actually in a constant cast expression which itself
    // has only one use, we look through the constant cast expression.
    // This happens by updating the use @p U to the use of the constant
    // cast expression and afterwards re-initializing CS accordingly.
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(U->getUser()))
      if (CE->getNumUses() == 1 && CE->isCast()) {
        U = &*CE->use_begin();
        CS = CallSite(U->getUser());
      }

    if (!CS) {
      NumInvalidAbstractCallSitesUnknownUse++;
      return;
    }
  }

  // Then handle direct or indirect calls. Thus, if U is the callee of the
  // call site CS it is not a callback and we are done.
  if (CS.isCallee(U)) {
    NumDirectAbstractCallSites++;
    return;
  }

  // If we cannot identify the broker function we cannot create a callback and
  // invalidate the abstract call site.
  Function *Callee = CS.getCalledFunction();
  if (!Callee) {
    NumInvalidAbstractCallSitesUnknownCallee++;
    CS = CallSite();
    return;
  }

  MDNode *CallbackMD = Callee->getMetadata(LLVMContext::MD_callback);
  if (!CallbackMD) {
    NumInvalidAbstractCallSitesNoCallback++;
    CS = CallSite();
    return;
  }

  unsigned UseIdx = CS.getArgumentNo(U);
  MDNode *CallbackEncMD = nullptr;
  for (const MDOperand &Op : CallbackMD->operands()) {
    MDNode *OpMD = cast<MDNode>(Op.get());
    auto *CBCalleeIdxAsCM = cast<ConstantAsMetadata>(OpMD->getOperand(0));
    uint64_t CBCalleeIdx =
        cast<ConstantInt>(CBCalleeIdxAsCM->getValue())->getZExtValue();
    if (CBCalleeIdx != UseIdx)
      continue;
    CallbackEncMD = OpMD;
    break;
  }

  if (!CallbackEncMD) {
    NumInvalidAbstractCallSitesNoCallback++;
    CS = CallSite();
    return;
  }

  NumCallbackCallSites++;

  assert(CallbackEncMD->getNumOperands() >= 2 && "Incomplete !callback metadata");

  unsigned NumCallOperands = CS.getNumArgOperands();
  // Skip the var-arg flag at the end when reading the metadata.
  for (unsigned u = 0, e = CallbackEncMD->getNumOperands() - 1; u < e; u++) {
    Metadata *OpAsM = CallbackEncMD->getOperand(u).get();
    auto *OpAsCM = cast<ConstantAsMetadata>(OpAsM);
    assert(OpAsCM->getType()->isIntegerTy(64) &&
           "Malformed !callback metadata");

    int64_t Idx = cast<ConstantInt>(OpAsCM->getValue())->getSExtValue();
    assert(-1 <= Idx && Idx <= NumCallOperands &&
           "Out-of-bounds !callback metadata index");

    CI.ParameterEncoding.push_back(Idx);
  }

  if (!Callee->isVarArg())
    return;

  Metadata *VarArgFlagAsM =
      CallbackEncMD->getOperand(CallbackEncMD->getNumOperands() - 1).get();
  auto *VarArgFlagAsCM = cast<ConstantAsMetadata>(VarArgFlagAsM);
  assert(VarArgFlagAsCM->getType()->isIntegerTy(1) &&
         "Malformed !callback metadata var-arg flag");

  if (VarArgFlagAsCM->getValue()->isNullValue())
    return;

  // Add all variadic arguments at the end.
  for (unsigned u = Callee->arg_size(); u < NumCallOperands; u++)
    CI.ParameterEncoding.push_back(u);
}
