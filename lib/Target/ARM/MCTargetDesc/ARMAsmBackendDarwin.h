//===-- ARMAsmBackendDarwin.h   ARM Asm Backend Darwin ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_ARM_ARMASMBACKENDDARWIN_H
#define LLVM_LIB_TARGET_ARM_ARMASMBACKENDDARWIN_H

#include "ARMAsmBackend.h"
#include "llvm/BinaryFormat/MachO.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/Object/MachO.h"

namespace llvm {
class ARMAsmBackendDarwin : public ARMAsmBackend {
  const MCRegisterInfo &MRI;
  Triple TT;
public:
  const MachO::CPUSubTypeARM Subtype;
  ARMAsmBackendDarwin(const Target &T, const MCSubtargetInfo &STI,
                      const MCRegisterInfo &MRI)
      : ARMAsmBackend(T, STI, support::little), MRI(MRI),
        TT(STI.getTargetTriple()),
        Subtype((MachO::CPUSubTypeARM)cantFail(
            object::MachOObjectFile::getCPUSubTypeFromTriple(
                STI.getTargetTriple()))) {}

  std::unique_ptr<MCObjectTargetWriter>
  createObjectTargetWriter() const override {
    return createARMMachObjectWriter(
        /*Is64Bit=*/false,
        cantFail(object::MachOObjectFile::getCPUTypeFromTriple(TT)), Subtype);
  }

  uint32_t generateCompactUnwindEncoding(
      ArrayRef<MCCFIInstruction> Instrs) const override;
};
} // end namespace llvm

#endif
