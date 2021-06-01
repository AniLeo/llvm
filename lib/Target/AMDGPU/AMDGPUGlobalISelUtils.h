//===- AMDGPUGlobalISelUtils -------------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPU_AMDGPUGLOBALISELUTILS_H
#define LLVM_LIB_TARGET_AMDGPU_AMDGPUGLOBALISELUTILS_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/CodeGen/Register.h"
#include <utility>

namespace llvm {

class MachineRegisterInfo;

namespace AMDGPU {

/// Returns base register and constant offset.
std::pair<Register, unsigned>
getBaseWithConstantOffset(MachineRegisterInfo &MRI, Register Reg);

bool isLegalVOP3PShuffleMask(ArrayRef<int> Mask);

}
}

#endif
