//===----- RegisterEHFrames.h -- Register EH frame sections -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Support for dynamically registering and deregistering eh-frame sections
// in-process via libunwind.
//
// FIXME: The functionality in this file should be moved to the ORC runtime.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_REGISTEREHFRAMES_H
#define LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_REGISTEREHFRAMES_H

#include "llvm/ExecutionEngine/Orc/Shared/WrapperFunctionUtils.h"
#include "llvm/Support/Error.h"

namespace llvm {
namespace orc {

/// Register frames in the given eh-frame section with libunwind.
Error registerEHFrameSection(const void *EHFrameSectionAddr,
                             size_t EHFrameSectionSize);

/// Unregister frames in the given eh-frame section with libunwind.
Error deregisterEHFrameSection(const void *EHFrameSectionAddr,
                               size_t EHFrameSectionSize);

} // end namespace orc
} // end namespace llvm

/// An eh-frame registration utility suitable for use as a support function
/// call. This function expects the direct address and size of the eh-frame
/// section to register as its arguments (it does not treat its arguments as
/// pointers to an SPS-serialized arg buffer).
extern "C" llvm::orc::shared::CWrapperFunctionResult
llvm_orc_registerEHFrameSectionCustomDirectWrapper(
    const char *EHFrameSectionAddr, uint64_t Size);

/// An eh-frame deregistration utility suitable for use as a support function
/// call. This function expects the direct address and size of the eh-frame
/// section to register as its arguments (it does not treat its arguments as
/// pointers to an SPS-serialized arg buffer).
extern "C" llvm::orc::shared::CWrapperFunctionResult
llvm_orc_deregisterEHFrameSectionCustomDirectWrapper(
    const char *EHFrameSectionAddr, uint64_t Size);

extern "C" llvm::orc::shared::CWrapperFunctionResult
llvm_orc_registerEHFrameSectionWrapper(const char *Data, uint64_t Size);

extern "C" llvm::orc::shared::CWrapperFunctionResult
llvm_orc_deregisterEHFrameSectionWrapper(const char *Data, uint64_t Size);

#endif // LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_REGISTEREHFRAMES_H
