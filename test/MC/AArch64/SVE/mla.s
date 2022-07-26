// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:   | llvm-objdump -d --mattr=-sve - | FileCheck %s --check-prefix=CHECK-UNKNOWN

mla z0.b, p7/m, z1.b, z31.b
// CHECK-INST: mla	z0.b, p7/m, z1.b, z31.b
// CHECK-ENCODING: [0x20,0x5c,0x1f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 041f5c20 <unknown>

mla z0.h, p7/m, z1.h, z31.h
// CHECK-INST: mla	z0.h, p7/m, z1.h, z31.h
// CHECK-ENCODING: [0x20,0x5c,0x5f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 045f5c20 <unknown>

mla z0.s, p7/m, z1.s, z31.s
// CHECK-INST: mla	z0.s, p7/m, z1.s, z31.s
// CHECK-ENCODING: [0x20,0x5c,0x9f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 049f5c20 <unknown>

mla z0.d, p7/m, z1.d, z31.d
// CHECK-INST: mla	z0.d, p7/m, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x5c,0xdf,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04df5c20 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z0.d, p7/z, z7.d
// CHECK-INST: movprfx	z0.d, p7/z, z7.d
// CHECK-ENCODING: [0xe0,0x3c,0xd0,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04d03ce0 <unknown>

mla z0.d, p7/m, z1.d, z31.d
// CHECK-INST: mla	z0.d, p7/m, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x5c,0xdf,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04df5c20 <unknown>

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

mla z0.d, p7/m, z1.d, z31.d
// CHECK-INST: mla	z0.d, p7/m, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x5c,0xdf,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04df5c20 <unknown>
