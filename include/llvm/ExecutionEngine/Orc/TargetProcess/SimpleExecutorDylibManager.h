//===--------------- SimpleExecutorDylibManager.h ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// A simple dynamic library management class. Allows dynamic libraries to be
// loaded and searched.
//
// FIXME: The functionality in this file should be moved to the ORC runtime.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_SIMPLEEXECUTORDYLIBMANAGER_H
#define LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_SIMPLEEXECUTORDYLIBMANAGER_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ExecutionEngine/Orc/Shared/ExecutorAddress.h"
#include "llvm/ExecutionEngine/Orc/Shared/SimpleRemoteEPCUtils.h"
#include "llvm/ExecutionEngine/Orc/Shared/TargetProcessControlTypes.h"
#include "llvm/ExecutionEngine/Orc/Shared/WrapperFunctionUtils.h"
#include "llvm/ExecutionEngine/Orc/TargetProcess/ExecutorBootstrapService.h"
#include "llvm/Support/DynamicLibrary.h"
#include "llvm/Support/Error.h"

#include <mutex>

namespace llvm {
namespace orc {
namespace rt_bootstrap {

/// Simple page-based allocator.
class SimpleExecutorDylibManager : public ExecutorBootstrapService {
public:
  virtual ~SimpleExecutorDylibManager();

  Expected<tpctypes::DylibHandle> open(const std::string &Path, uint64_t Mode);
  Expected<std::vector<ExecutorAddress>> lookup(tpctypes::DylibHandle H,
                                                const RemoteSymbolLookupSet &L);

  Error shutdown() override;
  void addBootstrapSymbols(StringMap<ExecutorAddress> &M) override;

private:
  using DylibsMap = DenseMap<uint64_t, sys::DynamicLibrary>;

  static llvm::orc::shared::detail::CWrapperFunctionResult
  openWrapper(const char *ArgData, size_t ArgSize);

  static llvm::orc::shared::detail::CWrapperFunctionResult
  lookupWrapper(const char *ArgData, size_t ArgSize);

  std::mutex M;
  uint64_t NextId = 0;
  DylibsMap Dylibs;
};

} // end namespace rt_bootstrap
} // end namespace orc
} // end namespace llvm

#endif // LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_SIMPLEEXECUTORDYLIBMANAGER_H
