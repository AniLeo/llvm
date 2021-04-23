//===- ELFObjcopy.h ---------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_OBJCOPY_ELFOBJCOPY_H
#define LLVM_TOOLS_OBJCOPY_ELFOBJCOPY_H

namespace llvm {
class Error;
class MemoryBuffer;
class raw_ostream;

namespace object {
class ELFObjectFileBase;
} // end namespace object

namespace objcopy {
struct CommonConfig;
struct ELFConfig;

namespace elf {
Error executeObjcopyOnIHex(const CommonConfig &Config,
                           const ELFConfig &ELFConfig, MemoryBuffer &In,
                           raw_ostream &Out);
Error executeObjcopyOnRawBinary(const CommonConfig &Config,
                                const ELFConfig &ELFConfig, MemoryBuffer &In,
                                raw_ostream &Out);
Error executeObjcopyOnBinary(const CommonConfig &Config,
                             const ELFConfig &ELFConfig,
                             object::ELFObjectFileBase &In, raw_ostream &Out);

} // end namespace elf
} // end namespace objcopy
} // end namespace llvm

#endif // LLVM_TOOLS_OBJCOPY_ELFOBJCOPY_H
