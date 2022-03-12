//==- BLAKE3.h - BLAKE3 C++ wrapper for LLVM ---------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This is a C++ wrapper of the BLAKE3 C interface.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_BLAKE3_H
#define LLVM_SUPPORT_BLAKE3_H

#include "llvm-c/blake3.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"

namespace llvm {

/// The constant \p BLAKE3_OUT_LEN provides the default output length,
/// 32 bytes, which is recommended for most callers.
///
/// Outputs shorter than the default length of 32 bytes (256 bits) provide
/// less security. An N-bit BLAKE3 output is intended to provide N bits of
/// first and second preimage resistance and N/2 bits of collision
/// resistance, for any N up to 256. Longer outputs don't provide any
/// additional security.
///
/// Shorter BLAKE3 outputs are prefixes of longer ones. Explicitly
/// requesting a short output is equivalent to truncating the default-length
/// output.
template <size_t NumBytes = BLAKE3_OUT_LEN>
using BLAKE3Result = std::array<uint8_t, NumBytes>;

/// A class that wrap the BLAKE3 algorithm.
class BLAKE3 {
public:
  BLAKE3() { init(); }

  /// Reinitialize the internal state
  void init() { blake3_hasher_init(&Hasher); }

  /// Digest more data.
  void update(ArrayRef<uint8_t> Data) {
    blake3_hasher_update(&Hasher, Data.data(), Data.size());
  }

  /// Digest more data.
  void update(StringRef Str) {
    blake3_hasher_update(&Hasher, Str.data(), Str.size());
  }

  /// Finalize the hasher and put the result in \p Result.
  /// This doesn't modify the hasher itself, and it's possible to finalize again
  /// after adding more input.
  template <size_t NumBytes = BLAKE3_OUT_LEN>
  void final(BLAKE3Result<NumBytes> &Result) {
    blake3_hasher_finalize(&Hasher, Result.data(), Result.size());
  }

  /// Finalize the hasher and return an output of any length, given in bytes.
  /// This doesn't modify the hasher itself, and it's possible to finalize again
  /// after adding more input.
  template <size_t NumBytes = BLAKE3_OUT_LEN> BLAKE3Result<NumBytes> final() {
    BLAKE3Result<NumBytes> Result;
    blake3_hasher_finalize(&Hasher, Result.data(), Result.size());
    return Result;
  }

  /// Returns a BLAKE3 hash for the given data.
  template <size_t NumBytes = BLAKE3_OUT_LEN>
  static BLAKE3Result<NumBytes> hash(ArrayRef<uint8_t> Data) {
    BLAKE3 Hasher;
    Hasher.update(Data);
    return Hasher.final<NumBytes>();
  }

private:
  blake3_hasher Hasher;
};

} // namespace llvm

#endif
