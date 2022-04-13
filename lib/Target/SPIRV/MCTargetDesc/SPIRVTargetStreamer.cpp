//=====- SPIRVTargetStreamer.cpp - SPIRVTargetStreamer class ------------=====//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the SPIRVTargetStreamer class.
//
//===----------------------------------------------------------------------===//

#include "SPIRVTargetStreamer.h"

using namespace llvm;

SPIRVTargetStreamer::SPIRVTargetStreamer(MCStreamer &S) : MCTargetStreamer(S) {}
SPIRVTargetStreamer::~SPIRVTargetStreamer() {}
