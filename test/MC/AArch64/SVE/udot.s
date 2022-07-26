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

udot  z0.s, z1.b, z31.b
// CHECK-INST: udot	z0.s, z1.b, z31.b
// CHECK-ENCODING: [0x20,0x04,0x9f,0x44]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 449f0420 <unknown>

udot  z0.d, z1.h, z31.h
// CHECK-INST: udot	z0.d, z1.h, z31.h
// CHECK-ENCODING: [0x20,0x04,0xdf,0x44]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 44df0420 <unknown>

udot  z0.s, z1.b, z7.b[3]
// CHECK-INST: udot	z0.s, z1.b, z7.b[3]
// CHECK-ENCODING: [0x20,0x04,0xbf,0x44]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 44bf0420 <unknown>

udot  z0.d, z1.h, z15.h[1]
// CHECK-INST: udot	z0.d, z1.h, z15.h[1]
// CHECK-ENCODING: [0x20,0x04,0xff,0x44]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 44ff0420 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

udot  z0.d, z1.h, z31.h
// CHECK-INST: udot	z0.d, z1.h, z31.h
// CHECK-ENCODING: [0x20,0x04,0xdf,0x44]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 44df0420 <unknown>

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

udot  z0.d, z1.h, z15.h[1]
// CHECK-INST: udot	z0.d, z1.h, z15.h[1]
// CHECK-ENCODING: [0x20,0x04,0xff,0x44]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 44ff0420 <unknown>
