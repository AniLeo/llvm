//===-- SPIRVTargetInfo.h - SPIRV Target Implementation ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_SPIRV_TARGETINFO_SPIRVTARGETINFO_H
#define LLVM_LIB_TARGET_SPIRV_TARGETINFO_SPIRVTARGETINFO_H

namespace llvm {

class Target;

Target &getTheSPIRV32Target();
Target &getTheSPIRV64Target();

} // namespace llvm

#endif // LLVM_LIB_TARGET_SPIRV_TARGETINFO_SPIRVTARGETINFO_H
