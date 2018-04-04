@ PR18921, "vmov" part.
@ RUN: llvm-mc -triple=armv7-linux-gnueabi -show-encoding < %s | FileCheck %s
.text
        vmov.i64        d2, #0xffffffffffffffff
        vmov.i64        q2, #0xffffffffffffffff
        vmov.i32        d2, #0xffffffff
        vmov.i32        q2, #0xffffffff
        vmov.i64        d2, #0xabababababababab
        vmov.i64        q2, #0xabababababababab
        vmov.i32        d2, #0xabababab
        vmov.i32        q2, #0xabababab
        vmov.i16        q2, #0xabab
        vmov.i16        q2, #0xabab

@ CHECK: vmov.i64 d2, #0xffffffffffffffff @ encoding: [0x3f,0x2e,0x87,0xf3]
@ CHECK: vmov.i64 q2, #0xffffffffffffffff @ encoding: [0x7f,0x4e,0x87,0xf3]
@ CHECK: vmov.i8 d2, #0xff @ encoding: [0x1f,0x2e,0x87,0xf3]
@ CHECK: vmov.i8 q2, #0xff @ encoding: [0x5f,0x4e,0x87,0xf3]
@ CHECK: vmov.i8 d2, #0xab @ encoding: [0x1b,0x2e,0x82,0xf3]
@ CHECK: vmov.i8 q2, #0xab @ encoding: [0x5b,0x4e,0x82,0xf3]
@ CHECK: vmov.i8 d2, #0xab @ encoding: [0x1b,0x2e,0x82,0xf3]
@ CHECK: vmov.i8 q2, #0xab @ encoding: [0x5b,0x4e,0x82,0xf3]
@ CHECK: vmov.i8 q2, #0xab @ encoding: [0x5b,0x4e,0x82,0xf3]
@ CHECK: vmov.i8 q2, #0xab @ encoding: [0x5b,0x4e,0x82,0xf3]

        vmov.i64        d2, #0xff00ff00ff00ff00
        vmov.i64        q2, #0xff00ff00ff00ff00
        vmov.i64        d2, #0x00a500a500a500a5
        vmov.i64        q2, #0x00a500a500a500a5
        vmov.i32        d2, #0x00a500a5
        vmov.i32        q2, #0x00a500a5
        vmov.i64        d2, #0xa500a500a500a500
        vmov.i64        q2, #0xa500a500a500a500
        vmov.i32        d2, #0xa500a500
        vmov.i32        q2, #0xa500a500

@ CHECK: vmov.i64 d2, #0xff00ff00ff00ff00 @ encoding: [0x3a,0x2e,0x82,0xf3]
@ CHECK: vmov.i64 q2, #0xff00ff00ff00ff00 @ encoding: [0x7a,0x4e,0x82,0xf3]
@ CHECK: vmov.i16 d2, #0xa5 @ encoding: [0x15,0x28,0x82,0xf3]
@ CHECK: vmov.i16 q2, #0xa5 @ encoding: [0x55,0x48,0x82,0xf3]
@ CHECK: vmov.i16 d2, #0xa5 @ encoding: [0x15,0x28,0x82,0xf3]
@ CHECK: vmov.i16 q2, #0xa5 @ encoding: [0x55,0x48,0x82,0xf3]
@ CHECK: vmov.i16 d2, #0xa500 @ encoding: [0x15,0x2a,0x82,0xf3]
@ CHECK: vmov.i16 q2, #0xa500 @ encoding: [0x55,0x4a,0x82,0xf3]
@ CHECK: vmov.i16 d2, #0xa500 @ encoding: [0x15,0x2a,0x82,0xf3]
@ CHECK: vmov.i16 q2, #0xa500 @ encoding: [0x55,0x4a,0x82,0xf3]

        vmov.i64        d2, #0x000000a5000000a5
        vmov.i64        q2, #0x000000a5000000a5
        vmov.i64        d2, #0x00a5ffff00a5ffff
        vmov.i64        q2, #0x00a5ffff00a5ffff

@ CHECK: vmov.i32 d2, #0xa5 @ encoding: [0x15,0x20,0x82,0xf3]
@ CHECK: vmov.i32 q2, #0xa5 @ encoding: [0x55,0x40,0x82,0xf3]
@ CHECK: vmov.i32 d2, #0xa5ffff @ encoding: [0x15,0x2d,0x82,0xf3]
@ CHECK: vmov.i32 q2, #0xa5ffff @ encoding: [0x55,0x4d,0x82,0xf3]

        vmvn.i64        d2, #0xffffffffffffffff
        vmvn.i64        q2, #0xffffffffffffffff
        vmvn.i32        d2, #0xffffffff
        vmvn.i32        q2, #0xffffffff
        vmvn.i64        d2, #0xabababababababab
        vmvn.i64        q2, #0xabababababababab
        vmvn.i32        d2, #0xabababab
        vmvn.i32        q2, #0xabababab
        vmvn.i16        d2, #0xabab
        vmvn.i16        q2, #0xabab

@ CHECK: vmov.i8 d2, #0x0  @ encoding: [0x10,0x2e,0x80,0xf2]
@ CHECK: vmov.i8 q2, #0x0  @ encoding: [0x50,0x4e,0x80,0xf2]
@ CHECK: vmov.i8 d2, #0x0  @ encoding: [0x10,0x2e,0x80,0xf2]
@ CHECK: vmov.i8 q2, #0x0  @ encoding: [0x50,0x4e,0x80,0xf2]
@ CHECK: vmov.i8 d2, #0x54 @ encoding: [0x14,0x2e,0x85,0xf2]
@ CHECK: vmov.i8 q2, #0x54 @ encoding: [0x54,0x4e,0x85,0xf2]
@ CHECK: vmov.i8 d2, #0x54 @ encoding: [0x14,0x2e,0x85,0xf2]
@ CHECK: vmov.i8 q2, #0x54 @ encoding: [0x54,0x4e,0x85,0xf2]
@ CHECK: vmov.i8 d2, #0x54 @ encoding: [0x14,0x2e,0x85,0xf2]
@ CHECK: vmov.i8 q2, #0x54 @ encoding: [0x54,0x4e,0x85,0xf2]

        vmvn.i64        d2, #0x00a500a500a500a5
        vmvn.i64        q2, #0x00a500a500a500a5
        vmvn.i32        d2, #0x00a500a5
        vmvn.i32        q2, #0x00a500a5
        vmvn.i64        d2, #0xa500a500a500a500
        vmvn.i64        q2, #0xa500a500a500a500
        vmvn.i32        d2, #0xa500a500
        vmvn.i32        q2, #0xa500a500

@ CHECK: vmvn.i16 d2, #0xa5 @ encoding: [0x35,0x28,0x82,0xf3]
@ CHECK: vmvn.i16 q2, #0xa5 @ encoding: [0x75,0x48,0x82,0xf3]
@ CHECK: vmvn.i16 d2, #0xa5 @ encoding: [0x35,0x28,0x82,0xf3]
@ CHECK: vmvn.i16 q2, #0xa5 @ encoding: [0x75,0x48,0x82,0xf3]
@ CHECK: vmvn.i16 d2, #0xa500 @ encoding: [0x35,0x2a,0x82,0xf3]
@ CHECK: vmvn.i16 q2, #0xa500 @ encoding: [0x75,0x4a,0x82,0xf3]
@ CHECK: vmvn.i16 d2, #0xa500 @ encoding: [0x35,0x2a,0x82,0xf3]
@ CHECK: vmvn.i16 q2, #0xa500 @ encoding: [0x75,0x4a,0x82,0xf3]

        vmvn.i64        d2, #0x000000a5000000a5
        vmvn.i64        q2, #0x000000a5000000a5
        vmvn.i64        d2, #0x00a5ffff00a5ffff
        vmvn.i64        q2, #0x00a5ffff00a5ffff

@ CHECK: vmvn.i32 d2, #0xa5 @ encoding: [0x35,0x20,0x82,0xf3]
@ CHECK: vmvn.i32 q2, #0xa5 @ encoding: [0x75,0x40,0x82,0xf3]
@ CHECK: vmvn.i32 d2, #0xa5ffff @ encoding: [0x35,0x2d,0x82,0xf3]
@ CHECK: vmvn.i32 q2, #0xa5ffff @ encoding: [0x75,0x4d,0x82,0xf3]
