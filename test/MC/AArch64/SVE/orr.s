// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d -mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN



orr     z5.b, z5.b, #0xf9
// CHECK-INST: orr     z5.b, z5.b, #0xf9
// CHECK-ENCODING: [0xa5,0x2e,0x00,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: a5 2e 00 05 <unknown>

orr     z23.h, z23.h, #0xfff9
// CHECK-INST: orr     z23.h, z23.h, #0xfff9
// CHECK-ENCODING: [0xb7,0x6d,0x00,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: b7 6d 00 05 <unknown>

orr     z0.s, z0.s, #0xfffffff9
// CHECK-INST: orr     z0.s, z0.s, #0xfffffff9
// CHECK-ENCODING: [0xa0,0xeb,0x00,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: a0 eb 00 05 <unknown>

orr     z0.d, z0.d, #0xfffffffffffffff9
// CHECK-INST: orr     z0.d, z0.d, #0xfffffffffffffff9
// CHECK-ENCODING: [0xa0,0xef,0x03,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: a0 ef 03 05 <unknown>

orr     z5.b, z5.b, #0x6
// CHECK-INST: orr     z5.b, z5.b, #0x6
// CHECK-ENCODING: [0x25,0x3e,0x00,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 25 3e 00 05 <unknown>

orr     z23.h, z23.h, #0x6
// CHECK-INST: orr     z23.h, z23.h, #0x6
// CHECK-ENCODING: [0x37,0x7c,0x00,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 37 7c 00 05 <unknown>

orr     z0.s, z0.s, #0x6
// CHECK-INST: orr     z0.s, z0.s, #0x6
// CHECK-ENCODING: [0x20,0xf8,0x00,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 20 f8 00 05 <unknown>

orr     z0.d, z0.d, #0x6
// CHECK-INST: orr     z0.d, z0.d, #0x6
// CHECK-ENCODING: [0x20,0xf8,0x03,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 20 f8 03 05 <unknown>

orr     z0.d, z0.d, z0.d    // should use mov-alias
// CHECK-INST: mov     z0.d, z0.d
// CHECK-ENCODING: [0x00,0x30,0x60,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 30 60 04 <unknown>

orr     z23.d, z13.d, z8.d  // should not use mov-alias
// CHECK-INST: orr     z23.d, z13.d, z8.d
// CHECK-ENCODING: [0xb7,0x31,0x68,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: b7 31 68 04 <unknown>

orr     z31.b, p7/m, z31.b, z31.b
// CHECK-INST: orr     z31.b, p7/m, z31.b, z31.b
// CHECK-ENCODING: [0xff,0x1f,0x18,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 1f 18 04 <unknown>

orr     z31.h, p7/m, z31.h, z31.h
// CHECK-INST: orr     z31.h, p7/m, z31.h, z31.h
// CHECK-ENCODING: [0xff,0x1f,0x58,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 1f 58 04 <unknown>

orr     z31.s, p7/m, z31.s, z31.s
// CHECK-INST: orr     z31.s, p7/m, z31.s, z31.s
// CHECK-ENCODING: [0xff,0x1f,0x98,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 1f 98 04 <unknown>

orr     z31.d, p7/m, z31.d, z31.d
// CHECK-INST: orr     z31.d, p7/m, z31.d, z31.d
// CHECK-ENCODING: [0xff,0x1f,0xd8,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 1f d8 04 <unknown>

orr     p0.b, p0/z, p0.b, p1.b
// CHECK-INST: orr     p0.b, p0/z, p0.b, p1.b
// CHECK-ENCODING: [0x00,0x40,0x81,0x25]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 40 81 25 <unknown>

orr     p0.b, p0/z, p0.b, p0.b
// CHECK-INST: mov     p0.b, p0.b
// CHECK-ENCODING: [0x00,0x40,0x80,0x25]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 40 80 25 <unknown>

orr     p15.b, p15/z, p15.b, p15.b
// CHECK-INST: mov     p15.b, p15.b
// CHECK-ENCODING: [0xef,0x7d,0x8f,0x25]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ef 7d 8f 25 <unknown>


// --------------------------------------------------------------------------//
// Test aliases.

orr     z0.s, z0.s, z0.s
// CHECK-INST: mov     z0.d, z0.d
// CHECK-ENCODING: [0x00,0x30,0x60,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 30 60 04 <unknown>

orr     z0.h, z0.h, z0.h
// CHECK-INST: mov     z0.d, z0.d
// CHECK-ENCODING: [0x00,0x30,0x60,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 30 60 04 <unknown>

orr     z0.b, z0.b, z0.b
// CHECK-INST: mov     z0.d, z0.d
// CHECK-ENCODING: [0x00,0x30,0x60,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 30 60 04 <unknown>

orr     z23.s, z13.s, z8.s  // should not use mov-alias
// CHECK-INST: orr     z23.d, z13.d, z8.d
// CHECK-ENCODING: [0xb7,0x31,0x68,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: b7 31 68 04 <unknown>

orr     z23.h, z13.h, z8.h  // should not use mov-alias
// CHECK-INST: orr     z23.d, z13.d, z8.d
// CHECK-ENCODING: [0xb7,0x31,0x68,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: b7 31 68 04 <unknown>

orr     z23.b, z13.b, z8.b  // should not use mov-alias
// CHECK-INST: orr     z23.d, z13.d, z8.d
// CHECK-ENCODING: [0xb7,0x31,0x68,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: b7 31 68 04 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z4.d, p7/z, z6.d
// CHECK-INST: movprfx	z4.d, p7/z, z6.d
// CHECK-ENCODING: [0xc4,0x3c,0xd0,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: c4 3c d0 04 <unknown>

orr     z4.d, p7/m, z4.d, z31.d
// CHECK-INST: orr	z4.d, p7/m, z4.d, z31.d
// CHECK-ENCODING: [0xe4,0x1f,0xd8,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: e4 1f d8 04 <unknown>

movprfx z4, z6
// CHECK-INST: movprfx	z4, z6
// CHECK-ENCODING: [0xc4,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: c4 bc 20 04 <unknown>

orr     z4.d, p7/m, z4.d, z31.d
// CHECK-INST: orr	z4.d, p7/m, z4.d, z31.d
// CHECK-ENCODING: [0xe4,0x1f,0xd8,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: e4 1f d8 04 <unknown>

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: e0 bc 20 04 <unknown>

orr     z0.d, z0.d, #0x6
// CHECK-INST: orr	z0.d, z0.d, #0x6
// CHECK-ENCODING: [0x20,0xf8,0x03,0x05]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 20 f8 03 05 <unknown>
