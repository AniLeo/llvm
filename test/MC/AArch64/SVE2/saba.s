// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2 < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d --mattr=+sve2 - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:   | llvm-objdump -d --mattr=-sve2 - | FileCheck %s --check-prefix=CHECK-UNKNOWN

saba z0.b, z1.b, z31.b
// CHECK-INST: saba z0.b, z1.b, z31.b
// CHECK-ENCODING: [0x20,0xf8,0x1f,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 451ff820 <unknown>

saba z0.h, z1.h, z31.h
// CHECK-INST: saba z0.h, z1.h, z31.h
// CHECK-ENCODING: [0x20,0xf8,0x5f,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 455ff820 <unknown>

saba z0.s, z1.s, z31.s
// CHECK-INST: saba z0.s, z1.s, z31.s
// CHECK-ENCODING: [0x20,0xf8,0x9f,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 459ff820 <unknown>

saba z0.d, z1.d, z31.d
// CHECK-INST: saba z0.d, z1.d, z31.d
// CHECK-ENCODING: [0x20,0xf8,0xdf,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 45dff820 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

saba z0.d, z1.d, z31.d
// CHECK-INST: saba z0.d, z1.d, z31.d
// CHECK-ENCODING: [0x20,0xf8,0xdf,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 45dff820 <unknown>
