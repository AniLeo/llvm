//===--------- Definition of the AddressSanitizer class ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the AddressSanitizer class which is a port of the legacy
// AddressSanitizer pass to use the new PassManager infrastructure.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_TRANSFORMS_INSTRUMENTATION_ADDRESSSANITIZER_H
#define LLVM_TRANSFORMS_INSTRUMENTATION_ADDRESSSANITIZER_H

#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/Instrumentation/AddressSanitizerOptions.h"

namespace llvm {
class Function;
class FunctionPass;
class GlobalVariable;
class MDNode;
class Module;
class ModulePass;
class raw_ostream;

struct AddressSanitizerOptions {
  bool CompileKernel = false;
  bool Recover = false;
  bool UseAfterScope = false;
  AsanDetectStackUseAfterReturnMode UseAfterReturn =
      AsanDetectStackUseAfterReturnMode::Runtime;
};

/// Public interface to the address sanitizer module pass for instrumenting code
/// to check for various memory errors.
///
/// This adds 'asan.module_ctor' to 'llvm.global_ctors'. This pass may also
/// run intependently of the function address sanitizer.
class ModuleAddressSanitizerPass
    : public PassInfoMixin<ModuleAddressSanitizerPass> {
public:
  ModuleAddressSanitizerPass(
      const AddressSanitizerOptions &Options, bool UseGlobalGC = true,
      bool UseOdrIndicator = false,
      AsanDtorKind DestructorKind = AsanDtorKind::Global);
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
  void printPipeline(raw_ostream &OS,
                     function_ref<StringRef(StringRef)> MapClassName2PassName);
  static bool isRequired() { return true; }

private:
  AddressSanitizerOptions Options;
  bool UseGlobalGC;
  bool UseOdrIndicator;
  AsanDtorKind DestructorKind;
};

struct ASanAccessInfo {
  const int32_t Packed;
  const uint8_t AccessSizeIndex;
  const bool IsWrite;
  const bool CompileKernel;

  explicit ASanAccessInfo(int32_t Packed);
  ASanAccessInfo(bool IsWrite, bool CompileKernel, uint8_t AccessSizeIndex);
};

} // namespace llvm

#endif
