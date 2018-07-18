// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d -mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

sdiv   z0.s, p7/m, z0.s, z31.s
// CHECK-INST: sdiv	z0.s, p7/m, z0.s, z31.s
// CHECK-ENCODING: [0xe0,0x1f,0x94,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: e0 1f 94 04 <unknown>

sdiv   z0.d, p7/m, z0.d, z31.d
// CHECK-INST: sdiv	z0.d, p7/m, z0.d, z31.d
// CHECK-ENCODING: [0xe0,0x1f,0xd4,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: e0 1f d4 04 <unknown>
