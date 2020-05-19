//===-- AMDGPUMachineFunctionInfo.h -------------------------------*- C++ -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPU_AMDGPUMACHINEFUNCTION_H
#define LLVM_LIB_TARGET_AMDGPU_AMDGPUMACHINEFUNCTION_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "Utils/AMDGPUBaseInfo.h"

namespace llvm {

class GCNSubtarget;

class AMDGPUMachineFunction : public MachineFunctionInfo {
  /// A map to keep track of local memory objects and their offsets within the
  /// local memory space.
  SmallDenseMap<const GlobalValue *, unsigned, 4> LocalMemoryObjects;

protected:
  uint64_t ExplicitKernArgSize = 0; // Cache for this.
  Align MaxKernArgAlign;        // Cache for this.

  /// Number of bytes in the LDS that are being used.
  unsigned LDSSize = 0;

  // State of MODE register, assumed FP mode.
  AMDGPU::SIModeRegisterDefaults Mode;

  // Kernels + shaders. i.e. functions called by the driver and not called
  // by other functions.
  bool IsEntryFunction = false;

  bool NoSignedZerosFPMath = false;

  // Function may be memory bound.
  bool MemoryBound = false;

  // Kernel may need limited waves per EU for better performance.
  bool WaveLimiter = false;

public:
  AMDGPUMachineFunction(const MachineFunction &MF);

  uint64_t getExplicitKernArgSize() const {
    return ExplicitKernArgSize;
  }

  unsigned getMaxKernArgAlign() const { return MaxKernArgAlign.value(); }

  unsigned getLDSSize() const {
    return LDSSize;
  }

  AMDGPU::SIModeRegisterDefaults getMode() const {
    return Mode;
  }

  bool isEntryFunction() const {
    return IsEntryFunction;
  }

  bool hasNoSignedZerosFPMath() const {
    return NoSignedZerosFPMath;
  }

  bool isMemoryBound() const {
    return MemoryBound;
  }

  bool needsWaveLimiter() const {
    return WaveLimiter;
  }

  unsigned allocateLDSGlobal(const DataLayout &DL, const GlobalValue &GV);
};

}
#endif
