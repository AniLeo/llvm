// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2 < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d --mattr=+sve2 - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

bsl1n z0.d, z0.d, z1.d, z2.d
// CHECK-INST: bsl1n z0.d, z0.d, z1.d, z2.d
// CHECK-ENCODING: [0x40,0x3c,0x61,0x04]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: 40 3c 61 04 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z31, z7
// CHECK-INST: movprfx z31, z7
// CHECK-ENCODING: [0xff,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bc 20 04 <unknown>

bsl1n z31.d, z31.d, z30.d, z29.d
// CHECK-INST: bsl1n z31.d, z31.d, z30.d, z29.d
// CHECK-ENCODING: [0xbf,0x3f,0x7e,0x04]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: bf 3f 7e 04 <unknown>
