//===- AMDGPUGlobalISelUtils -------------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPU_AMDGPUGLOBALISELUTILS_H
#define LLVM_LIB_TARGET_AMDGPU_AMDGPUGLOBALISELUTILS_H

#include "llvm/CodeGen/Register.h"
#include <tuple>

namespace llvm {

class MachineInstr;
class MachineRegisterInfo;

namespace AMDGPU {

/// Returns Base register, constant offset, and offset def point.
std::tuple<Register, unsigned, MachineInstr *>
getBaseWithConstantOffset(MachineRegisterInfo &MRI, Register Reg);

}
}

#endif
