//===-- Lanai.h - Top-level interface for Lanai representation --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the entry points for global functions defined in the LLVM
// Lanai back-end.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LANAI_LANAI_H
#define LLVM_LIB_TARGET_LANAI_LANAI_H

#include "LanaiAluCode.h"
#include "LanaiCondCode.h"
#include "MCTargetDesc/LanaiBaseInfo.h"
#include "MCTargetDesc/LanaiMCTargetDesc.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
class FunctionPass;
class LanaiTargetMachine;
class MachineFunctionPass;
class TargetMachine;
class formatted_raw_ostream;

// createLanaiISelDag - This pass converts a legalized DAG into a
// Lanai-specific DAG, ready for instruction scheduling.
FunctionPass *createLanaiISelDag(LanaiTargetMachine &TM);

// createLanaiDelaySlotFillerPass - This pass fills delay slots
// with useful instructions or nop's
FunctionPass *createLanaiDelaySlotFillerPass(const LanaiTargetMachine &TM);

// createLanaiMemAluCombinerPass - This pass combines loads/stores and
// arithmetic operations.
FunctionPass *createLanaiMemAluCombinerPass();

// createLanaiSetflagAluCombinerPass - This pass combines SET_FLAG and ALU
// operations.
FunctionPass *createLanaiSetflagAluCombinerPass();

Target &getTheLanaiTarget();
} // namespace llvm

#endif // LLVM_LIB_TARGET_LANAI_LANAI_H
