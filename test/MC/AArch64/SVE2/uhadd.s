// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2 < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d -mattr=+sve2 - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

uhadd z0.b, p0/m, z0.b, z1.b
// CHECK-INST: uhadd z0.b, p0/m, z0.b, z1.b
// CHECK-ENCODING: [0x20,0x80,0x11,0x44]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: 20 80 11 44 <unknown>

uhadd z0.h, p0/m, z0.h, z1.h
// CHECK-INST: uhadd z0.h, p0/m, z0.h, z1.h
// CHECK-ENCODING: [0x20,0x80,0x51,0x44]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: 20 80 51 44 <unknown>

uhadd z29.s, p7/m, z29.s, z30.s
// CHECK-INST: uhadd z29.s, p7/m, z29.s, z30.s
// CHECK-ENCODING: [0xdd,0x9f,0x91,0x44]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: dd 9f 91 44 <unknown>

uhadd z31.d, p7/m, z31.d, z30.d
// CHECK-INST: uhadd z31.d, p7/m, z31.d, z30.d
// CHECK-ENCODING: [0xdf,0x9f,0xd1,0x44]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: df 9f d1 44 <unknown>

// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z31.d, p0/z, z6.d
// CHECK-INST: movprfx z31.d, p0/z, z6.d
// CHECK-ENCODING: [0xdf,0x20,0xd0,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: df 20 d0 04 <unknown>

uhadd z31.d, p0/m, z31.d, z30.d
// CHECK-INST: uhadd z31.d, p0/m, z31.d, z30.d
// CHECK-ENCODING: [0xdf,0x83,0xd1,0x44]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: df 83 d1 44 <unknown>

movprfx z31, z6
// CHECK-INST: movprfx z31, z6
// CHECK-ENCODING: [0xdf,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: df bc 20 04 <unknown>

uhadd z31.d, p7/m, z31.d, z30.d
// CHECK-INST: uhadd z31.d, p7/m, z31.d, z30.d
// CHECK-ENCODING: [0xdf,0x9f,0xd1,0x44]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: df 9f d1 44 <unknown>
