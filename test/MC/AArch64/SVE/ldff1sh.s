// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d -mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

ldff1sh { z31.s }, p7/z, [sp]
// CHECK-INST: ldff1sh { z31.s }, p7/z, [sp]
// CHECK-ENCODING: [0xff,0x7f,0x3f,0xa5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 7f 3f a5 <unknown>

ldff1sh { z31.d }, p7/z, [sp]
// CHECK-INST: ldff1sh { z31.d }, p7/z, [sp]
// CHECK-ENCODING: [0xff,0x7f,0x1f,0xa5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 7f 1f a5 <unknown>

ldff1sh { z31.s }, p7/z, [sp, xzr, lsl #1]
// CHECK-INST: ldff1sh { z31.s }, p7/z, [sp]
// CHECK-ENCODING: [0xff,0x7f,0x3f,0xa5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 7f 3f a5 <unknown>

ldff1sh { z31.d }, p7/z, [sp, xzr, lsl #1]
// CHECK-INST: ldff1sh { z31.d }, p7/z, [sp]
// CHECK-ENCODING: [0xff,0x7f,0x1f,0xa5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff 7f 1f a5 <unknown>

ldff1sh { z0.s }, p0/z, [x0, x0, lsl #1]
// CHECK-INST: ldff1sh { z0.s }, p0/z, [x0, x0, lsl #1]
// CHECK-ENCODING: [0x00,0x60,0x20,0xa5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 20 a5 <unknown>

ldff1sh { z0.d }, p0/z, [x0, x0, lsl #1]
// CHECK-INST: ldff1sh { z0.d }, p0/z, [x0, x0, lsl #1]
// CHECK-ENCODING: [0x00,0x60,0x00,0xa5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 00 a5 <unknown>
