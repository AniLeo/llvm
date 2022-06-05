//===--------------------- InstrBuilder.h -----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
///
/// A builder class for instructions that are statically analyzed by llvm-mca.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MCA_INSTRBUILDER_H
#define LLVM_MCA_INSTRBUILDER_H

#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MCA/Instruction.h"
#include "llvm/MCA/Support.h"
#include "llvm/Support/Error.h"

namespace llvm {
namespace mca {

class RecycledInstErr : public ErrorInfo<RecycledInstErr> {
  Instruction *RecycledInst;

public:
  static char ID;

  explicit RecycledInstErr(Instruction *Inst) : RecycledInst(Inst) {}
  // Always need to carry an Instruction
  RecycledInstErr() = delete;

  Instruction *getInst() const { return RecycledInst; }

  void log(raw_ostream &OS) const override {
    OS << "Instruction is recycled\n";
  }

  std::error_code convertToErrorCode() const override {
    return llvm::inconvertibleErrorCode();
  }
};

/// A builder class that knows how to construct Instruction objects.
///
/// Every llvm-mca Instruction is described by an object of class InstrDesc.
/// An InstrDesc describes which registers are read/written by the instruction,
/// as well as the instruction latency and hardware resources consumed.
///
/// This class is used by the tool to construct Instructions and instruction
/// descriptors (i.e. InstrDesc objects).
/// Information from the machine scheduling model is used to identify processor
/// resources that are consumed by an instruction.
class InstrBuilder {
  const MCSubtargetInfo &STI;
  const MCInstrInfo &MCII;
  const MCRegisterInfo &MRI;
  const MCInstrAnalysis *MCIA;
  SmallVector<uint64_t, 8> ProcResourceMasks;

  DenseMap<unsigned short, std::unique_ptr<const InstrDesc>> Descriptors;
  DenseMap<const MCInst *, std::unique_ptr<const InstrDesc>> VariantDescriptors;

  bool FirstCallInst;
  bool FirstReturnInst;

  using InstRecycleCallback =
      llvm::function_ref<Instruction *(const InstrDesc &)>;
  InstRecycleCallback InstRecycleCB;

  Expected<const InstrDesc &> createInstrDescImpl(const MCInst &MCI);
  Expected<const InstrDesc &> getOrCreateInstrDesc(const MCInst &MCI);

  InstrBuilder(const InstrBuilder &) = delete;
  InstrBuilder &operator=(const InstrBuilder &) = delete;

  void populateWrites(InstrDesc &ID, const MCInst &MCI, unsigned SchedClassID);
  void populateReads(InstrDesc &ID, const MCInst &MCI, unsigned SchedClassID);
  Error verifyInstrDesc(const InstrDesc &ID, const MCInst &MCI) const;

public:
  InstrBuilder(const MCSubtargetInfo &STI, const MCInstrInfo &MCII,
               const MCRegisterInfo &RI, const MCInstrAnalysis *IA);

  void clear() {
    Descriptors.clear();
    VariantDescriptors.clear();
    FirstCallInst = true;
    FirstReturnInst = true;
  }

  /// Set a callback which is invoked to retrieve a recycled mca::Instruction
  /// or null if there isn't any.
  void setInstRecycleCallback(InstRecycleCallback CB) { InstRecycleCB = CB; }

  Expected<std::unique_ptr<Instruction>> createInstruction(const MCInst &MCI);
};
} // namespace mca
} // namespace llvm

#endif // LLVM_MCA_INSTRBUILDER_H
