// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2-bitperm < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2-bitperm < %s \
// RUN:        | llvm-objdump -d --mattr=+sve2-bitperm - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2-bitperm < %s \
// RUN:   | llvm-objdump -d --mattr=-sve2 - | FileCheck %s --check-prefix=CHECK-UNKNOWN

bdep z0.b, z1.b, z31.b
// CHECK-INST: bdep z0.b, z1.b, z31.b
// CHECK-ENCODING: [0x20,0xb4,0x1f,0x45]
// CHECK-ERROR: instruction requires: sve2-bitperm
// CHECK-UNKNOWN: 451fb420 <unknown>

bdep z0.h, z1.h, z31.h
// CHECK-INST: bdep z0.h, z1.h, z31.h
// CHECK-ENCODING: [0x20,0xb4,0x5f,0x45]
// CHECK-ERROR: instruction requires: sve2-bitperm
// CHECK-UNKNOWN: 455fb420 <unknown>

bdep z0.s, z1.s, z31.s
// CHECK-INST: bdep z0.s, z1.s, z31.s
// CHECK-ENCODING: [0x20,0xb4,0x9f,0x45]
// CHECK-ERROR: instruction requires: sve2-bitperm
// CHECK-UNKNOWN: 459fb420 <unknown>

bdep z0.d, z1.d, z31.d
// CHECK-INST: bdep z0.d, z1.d, z31.d
// CHECK-ENCODING: [0x20,0xb4,0xdf,0x45]
// CHECK-ERROR: instruction requires: sve2-bitperm
// CHECK-UNKNOWN: 45dfb420 <unknown>
