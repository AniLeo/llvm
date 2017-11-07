# RUN: llvm-mc -triple=aarch64-none-linux-gnu -show-encoding -disassemble -mattr=+sve < %s | FileCheck %s
# RUN: llvm-mc -triple=aarch64-none-linux-gnu -show-encoding -disassemble -mattr=-sve 2>&1 < %s | FileCheck --check-prefix=CHECK-ERROR  %s
0xff,0x03,0xbf,0x04
# CHECK: add     z31.s, z31.s, z31.s // encoding: [0xff,0x03,0xbf,0x04]
# CHECK-ERROR: invalid instruction encoding
0xb7,0x01,0xe8,0x04
# CHECK: add     z23.d, z13.d, z8.d // encoding: [0xb7,0x01,0xe8,0x04]
# CHECK-ERROR: invalid instruction encoding
0x00,0x00,0xa0,0x04
# CHECK: add     z0.s, z0.s, z0.s // encoding: [0x00,0x00,0xa0,0x04]
# CHECK-ERROR: invalid instruction encoding
0xff,0x03,0xff,0x04
# CHECK: add     z31.d, z31.d, z31.d // encoding: [0xff,0x03,0xff,0x04]
# CHECK-ERROR: invalid instruction encoding
0x55,0x01,0x35,0x04
# CHECK: add     z21.b, z10.b, z21.b // encoding: [0x55,0x01,0x35,0x04]
# CHECK-ERROR: invalid instruction encoding
0xff,0x03,0x3f,0x04
# CHECK: add     z31.b, z31.b, z31.b // encoding: [0xff,0x03,0x3f,0x04]
# CHECK-ERROR: invalid instruction encoding
0x00,0x00,0x60,0x04
# CHECK: add     z0.h, z0.h, z0.h // encoding: [0x00,0x00,0x60,0x04]
# CHECK-ERROR: invalid instruction encoding
0xb7,0x01,0x28,0x04
# CHECK: add     z23.b, z13.b, z8.b // encoding: [0xb7,0x01,0x28,0x04]
# CHECK-ERROR: invalid instruction encoding
0x00,0x00,0xe0,0x04
# CHECK: add     z0.d, z0.d, z0.d // encoding: [0x00,0x00,0xe0,0x04]
# CHECK-ERROR: invalid instruction encoding
0xff,0x03,0x7f,0x04
# CHECK: add     z31.h, z31.h, z31.h // encoding: [0xff,0x03,0x7f,0x04]
# CHECK-ERROR: invalid instruction encoding
0x00,0x00,0x20,0x04
# CHECK: add     z0.b, z0.b, z0.b // encoding: [0x00,0x00,0x20,0x04]
# CHECK-ERROR: invalid instruction encoding
0x55,0x01,0xf5,0x04
# CHECK: add     z21.d, z10.d, z21.d // encoding: [0x55,0x01,0xf5,0x04]
# CHECK-ERROR: invalid instruction encoding
0x55,0x01,0x75,0x04
# CHECK: add     z21.h, z10.h, z21.h // encoding: [0x55,0x01,0x75,0x04]
# CHECK-ERROR: invalid instruction encoding
0x55,0x01,0xb5,0x04
# CHECK: add     z21.s, z10.s, z21.s // encoding: [0x55,0x01,0xb5,0x04]
# CHECK-ERROR: invalid instruction encoding
0xb7,0x01,0x68,0x04
# CHECK: add     z23.h, z13.h, z8.h // encoding: [0xb7,0x01,0x68,0x04]
# CHECK-ERROR: invalid instruction encoding
0xb7,0x01,0xa8,0x04
# CHECK: add     z23.s, z13.s, z8.s // encoding: [0xb7,0x01,0xa8,0x04]
# CHECK-ERROR: invalid instruction encoding
