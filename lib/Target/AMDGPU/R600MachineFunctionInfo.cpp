//===-- R600MachineFunctionInfo.cpp - R600 Machine Function Info-*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
/// \file
//===----------------------------------------------------------------------===//

#include "R600MachineFunctionInfo.h"

using namespace llvm;

R600MachineFunctionInfo::R600MachineFunctionInfo(const MachineFunction &MF)
  : AMDGPUMachineFunction(MF) { }
