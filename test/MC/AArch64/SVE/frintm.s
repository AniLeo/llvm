// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

frintm   z31.h, p7/m, z31.h
// CHECK-INST: frintm	z31.h, p7/m, z31.h
// CHECK-ENCODING: [0xff,0xbf,0x42,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bf 42 65 <unknown>

frintm   z31.s, p7/m, z31.s
// CHECK-INST: frintm	z31.s, p7/m, z31.s
// CHECK-ENCODING: [0xff,0xbf,0x82,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bf 82 65 <unknown>

frintm   z31.d, p7/m, z31.d
// CHECK-INST: frintm	z31.d, p7/m, z31.d
// CHECK-ENCODING: [0xff,0xbf,0xc2,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bf c2 65 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z4.d, p7/z, z6.d
// CHECK-INST: movprfx	z4.d, p7/z, z6.d
// CHECK-ENCODING: [0xc4,0x3c,0xd0,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: c4 3c d0 04 <unknown>

frintm   z4.d, p7/m, z31.d
// CHECK-INST: frintm	z4.d, p7/m, z31.d
// CHECK-ENCODING: [0xe4,0xbf,0xc2,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: e4 bf c2 65 <unknown>

movprfx z4, z6
// CHECK-INST: movprfx	z4, z6
// CHECK-ENCODING: [0xc4,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: c4 bc 20 04 <unknown>

frintm   z4.d, p7/m, z31.d
// CHECK-INST: frintm	z4.d, p7/m, z31.d
// CHECK-ENCODING: [0xe4,0xbf,0xc2,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: e4 bf c2 65 <unknown>
