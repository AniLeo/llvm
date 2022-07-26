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

fmla z0.h, p7/m, z1.h, z31.h
// CHECK-INST: fmla	z0.h, p7/m, z1.h, z31.h
// CHECK-ENCODING: [0x20,0x1c,0x7f,0x65]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 657f1c20 <unknown>

fmla z0.s, p7/m, z1.s, z31.s
// CHECK-INST: fmla	z0.s, p7/m, z1.s, z31.s
// CHECK-ENCODING: [0x20,0x1c,0xbf,0x65]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 65bf1c20 <unknown>

fmla z0.d, p7/m, z1.d, z31.d
// CHECK-INST: fmla	z0.d, p7/m, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x1c,0xff,0x65]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 65ff1c20 <unknown>

fmla z0.h, z1.h, z7.h[7]
// CHECK-INST: fmla	z0.h, z1.h, z7.h[7]
// CHECK-ENCODING: [0x20,0x00,0x7f,0x64]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 647f0020 <unknown>

fmla z0.s, z1.s, z7.s[3]
// CHECK-INST: fmla	z0.s, z1.s, z7.s[3]
// CHECK-ENCODING: [0x20,0x00,0xbf,0x64]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 64bf0020 <unknown>

fmla z0.d, z1.d, z7.d[1]
// CHECK-INST: fmla	z0.d, z1.d, z7.d[1]
// CHECK-ENCODING: [0x20,0x00,0xf7,0x64]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 64f70020 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z0.d, p7/z, z7.d
// CHECK-INST: movprfx	z0.d, p7/z, z7.d
// CHECK-ENCODING: [0xe0,0x3c,0xd0,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04d03ce0 <unknown>

fmla z0.d, p7/m, z1.d, z31.d
// CHECK-INST: fmla	z0.d, p7/m, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x1c,0xff,0x65]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 65ff1c20 <unknown>

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

fmla z0.d, p7/m, z1.d, z31.d
// CHECK-INST: fmla	z0.d, p7/m, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x1c,0xff,0x65]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 65ff1c20 <unknown>

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

fmla z0.d, z1.d, z7.d[1]
// CHECK-INST: fmla	z0.d, z1.d, z7.d[1]
// CHECK-ENCODING: [0x20,0x00,0xf7,0x64]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 64f70020 <unknown>
