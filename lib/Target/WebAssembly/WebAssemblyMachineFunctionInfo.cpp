//=- WebAssemblyMachineFunctionInfo.cpp - WebAssembly Machine Function Info -=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file implements WebAssembly-specific per-machine-function
/// information.
///
//===----------------------------------------------------------------------===//

#include "WebAssemblyMachineFunctionInfo.h"
#include "WebAssemblyISelLowering.h"
#include "WebAssemblySubtarget.h"
#include "llvm/CodeGen/Analysis.h"
using namespace llvm;

WebAssemblyFunctionInfo::~WebAssemblyFunctionInfo() {}

void WebAssemblyFunctionInfo::initWARegs() {
  assert(WARegs.empty());
  unsigned Reg = UnusedReg;
  WARegs.resize(MF.getRegInfo().getNumVirtRegs(), Reg);
}

void llvm::ComputeLegalValueVTs(const Function &F, const TargetMachine &TM,
                                Type *Ty, SmallVectorImpl<MVT> &ValueVTs) {
  const DataLayout &DL(F.getParent()->getDataLayout());
  const WebAssemblyTargetLowering &TLI =
      *TM.getSubtarget<WebAssemblySubtarget>(F).getTargetLowering();
  SmallVector<EVT, 4> VTs;
  ComputeValueVTs(TLI, DL, Ty, VTs);

  for (EVT VT : VTs) {
    unsigned NumRegs = TLI.getNumRegisters(F.getContext(), VT);
    MVT RegisterVT = TLI.getRegisterType(F.getContext(), VT);
    for (unsigned i = 0; i != NumRegs; ++i)
      ValueVTs.push_back(RegisterVT);
  }
}

void llvm::ComputeSignatureVTs(const Function &F, const TargetMachine &TM,
                               SmallVectorImpl<MVT> &Params,
                               SmallVectorImpl<MVT> &Results) {
  ComputeLegalValueVTs(F, TM, F.getReturnType(), Results);

  if (Results.size() > 1) {
    // WebAssembly currently can't lower returns of multiple values without
    // demoting to sret (see WebAssemblyTargetLowering::CanLowerReturn). So
    // replace multiple return values with a pointer parameter.
    Results.clear();
    Params.push_back(
        MVT::getIntegerVT(TM.createDataLayout().getPointerSizeInBits()));
  }

  for (auto &Arg : F.args())
    ComputeLegalValueVTs(F, TM, Arg.getType(), Params);
}
