//===- OffloadYAML.h - Offload Binary YAMLIO implementation -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file declares classes for handling the YAML representation of
/// offloading binaries.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_OBJECTYAML_OFFLOADYAML_H
#define LLVM_OBJECTYAML_OFFLOADYAML_H

#include "llvm/ADT/MapVector.h"
#include "llvm/Object/OffloadBinary.h"
#include "llvm/ObjectYAML/YAML.h"
#include "llvm/Support/YAMLTraits.h"

namespace llvm {
namespace OffloadYAML {

struct Binary {
  struct StringEntry {
    StringRef Key;
    StringRef Value;
  };

  struct Member {
    Optional<object::ImageKind> ImageKind;
    Optional<object::OffloadKind> OffloadKind;
    Optional<uint32_t> Flags;
    Optional<std::vector<StringEntry>> StringEntries;
    Optional<yaml::BinaryRef> Content;
  };

  Optional<uint32_t> Version;
  Optional<uint64_t> Size;
  Optional<uint64_t> EntryOffset;
  Optional<uint64_t> EntrySize;
  std::vector<Member> Members;
};

} // end namespace OffloadYAML
} // end namespace llvm

LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::OffloadYAML::Binary::Member)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::OffloadYAML::Binary::StringEntry)

namespace llvm {
namespace yaml {

template <> struct ScalarEnumerationTraits<object::ImageKind> {
  static void enumeration(IO &IO, object::ImageKind &Value);
};

template <> struct ScalarEnumerationTraits<object::OffloadKind> {
  static void enumeration(IO &IO, object::OffloadKind &Value);
};

template <> struct MappingTraits<OffloadYAML::Binary> {
  static void mapping(IO &IO, OffloadYAML::Binary &O);
};

template <> struct MappingTraits<OffloadYAML::Binary::StringEntry> {
  static void mapping(IO &IO, OffloadYAML::Binary::StringEntry &M);
};

template <> struct MappingTraits<OffloadYAML::Binary::Member> {
  static void mapping(IO &IO, OffloadYAML::Binary::Member &M);
};

} // end namespace yaml
} // end namespace llvm

#endif // LLVM_OBJECTYAML_ARCHIVEYAML_H
