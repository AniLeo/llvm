//===-- SparcMCTargetDesc.h - Sparc Target Descriptions ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides Sparc specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_SPARC_MCTARGETDESC_SPARCMCTARGETDESC_H
#define LLVM_LIB_TARGET_SPARC_MCTARGETDESC_SPARCMCTARGETDESC_H

#include "llvm/Support/DataTypes.h"

#include <memory>

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class MCTargetOptions;
class Target;
class Triple;
class StringRef;
class raw_pwrite_stream;
class raw_ostream;

MCCodeEmitter *createSparcMCCodeEmitter(const MCInstrInfo &MCII,
                                        const MCRegisterInfo &MRI,
                                        MCContext &Ctx);
MCAsmBackend *createSparcAsmBackend(const Target &T, const MCSubtargetInfo &STI,
                                    const MCRegisterInfo &MRI,
                                    const MCTargetOptions &Options);
std::unique_ptr<MCObjectTargetWriter> createSparcELFObjectWriter(bool Is64Bit,
                                                                 uint8_t OSABI);
} // End llvm namespace

// Defines symbolic names for Sparc registers.  This defines a mapping from
// register name to register number.
//
#define GET_REGINFO_ENUM
#include "SparcGenRegisterInfo.inc"

// Defines symbolic names for the Sparc instructions.
//
#define GET_INSTRINFO_ENUM
#include "SparcGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "SparcGenSubtargetInfo.inc"

#endif
