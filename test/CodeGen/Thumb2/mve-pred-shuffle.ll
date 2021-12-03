; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define <2 x i64> @shuffle1_v2i64(<2 x i64> %src, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: shuffle1_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    orrs r2, r3
; CHECK-NEXT:    mov.w r3, #0
; CHECK-NEXT:    cset r2, eq
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    csetm r2, ne
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    bfi r3, r2, #0, #8
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    bfi r3, r0, #8, #8
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vmsr p0, r3
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <2 x i64> %src, zeroinitializer
  %sh = shufflevector <2 x i1> %c, <2 x i1> undef, <2 x i32> <i32 1, i32 0>
  %s = select <2 x i1> %sh, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define <4 x i32> @shuffle1_v4i32(<4 x i32> %src, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: shuffle1_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    vmrs r0, p0
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    lsrs r0, r0, #16
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %src, zeroinitializer
  %sh = shufflevector <4 x i1> %c, <4 x i1> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %s = select <4 x i1> %sh, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define <8 x i16> @shuffle1_v8i16(<8 x i16> %src, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: shuffle1_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    vmrs r0, p0
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    lsrs r0, r0, #16
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %src, zeroinitializer
  %sh = shufflevector <8 x i1> %c, <8 x i1> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %s = select <8 x i1> %sh, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define <16 x i8> @shuffle1_v16i8(<16 x i8> %src, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: shuffle1_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-NEXT:    vmrs r0, p0
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    lsrs r0, r0, #16
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <16 x i8> %src, zeroinitializer
  %sh = shufflevector <16 x i1> %c, <16 x i1> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %s = select <16 x i1> %sh, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %s
}

define <2 x i64> @shuffle2_v2i64(<2 x i64> %src, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: shuffle2_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    mov.w r1, #0
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    bfi r1, r0, #0, #8
; CHECK-NEXT:    orrs.w r0, r2, r3
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    bfi r1, r0, #8, #8
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <2 x i64> %src, zeroinitializer
  %sh = shufflevector <2 x i1> %c, <2 x i1> undef, <2 x i32> <i32 0, i32 1>
  %s = select <2 x i1> %sh, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define <4 x i32> @shuffle2_v4i32(<4 x i32> %src, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: shuffle2_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %src, zeroinitializer
  %sh = shufflevector <4 x i1> %c, <4 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %s = select <4 x i1> %sh, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define <8 x i16> @shuffle2_v8i16(<8 x i16> %src, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: shuffle2_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %src, zeroinitializer
  %sh = shufflevector <8 x i1> %c, <8 x i1> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s = select <8 x i1> %sh, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define <16 x i8> @shuffle2_v16i8(<16 x i8> %src, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: shuffle2_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <16 x i8> %src, zeroinitializer
  %sh = shufflevector <16 x i1> %c, <16 x i1> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %s = select <16 x i1> %sh, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %s
}

define <2 x i64> @shuffle3_v2i64(<2 x i64> %src, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: shuffle3_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <2 x i64> %src, zeroinitializer
  %sh = shufflevector <2 x i1> %c, <2 x i1> undef, <2 x i32> <i32 0, i32 0>
  %s = select <2 x i1> %sh, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define <4 x i32> @shuffle3_v4i32(<4 x i32> %src, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: shuffle3_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vdup.32 q0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i32 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %src, zeroinitializer
  %sh = shufflevector <4 x i1> %c, <4 x i1> undef, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  %s = select <4 x i1> %sh, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define <8 x i16> @shuffle3_v8i16(<8 x i16> %src, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: shuffle3_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov.u16 r0, q0[0]
; CHECK-NEXT:    vdup.16 q0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %src, zeroinitializer
  %sh = shufflevector <8 x i1> %c, <8 x i1> undef, <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %s = select <8 x i1> %sh, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define <16 x i8> @shuffle3_v16i8(<16 x i8> %src, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: shuffle3_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov.u8 r0, q0[0]
; CHECK-NEXT:    vdup.8 q0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i8 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <16 x i8> %src, zeroinitializer
  %sh = shufflevector <16 x i1> %c, <16 x i1> undef, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %s = select <16 x i1> %sh, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %s
}

define <2 x i64> @shuffle4_v2i64(<2 x i64> %src, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: shuffle4_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    orrs.w r0, r2, r3
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <2 x i64> %src, zeroinitializer
  %sh = shufflevector <2 x i1> %c, <2 x i1> undef, <2 x i32> <i32 1, i32 1>
  %s = select <2 x i1> %sh, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define <4 x i32> @shuffle4_v4i32(<4 x i32> %src, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: shuffle4_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov.f32 s4, s0
; CHECK-NEXT:    vmov.f32 s5, s0
; CHECK-NEXT:    vmov.f32 s6, s0
; CHECK-NEXT:    vmov.f32 s7, s1
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vcmp.i32 ne, q1, zr
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %src, zeroinitializer
  %sh = shufflevector <4 x i1> %c, <4 x i1> undef, <4 x i32> <i32 0, i32 0, i32 0, i32 1>
  %s = select <4 x i1> %sh, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define <8 x i16> @shuffle4_v8i16(<8 x i16> %src, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: shuffle4_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov.u16 r0, q0[0]
; CHECK-NEXT:    vdup.16 q1, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vmov.f32 s7, s0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vcmp.i16 ne, q1, zr
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %src, zeroinitializer
  %sh = shufflevector <8 x i1> %c, <8 x i1> undef, <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 1>
  %s = select <8 x i1> %sh, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define <16 x i8> @shuffle4_v16i8(<16 x i8> %src, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: shuffle4_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov.u8 r0, q0[0]
; CHECK-NEXT:    vdup.8 q1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[1]
; CHECK-NEXT:    vmov.8 q1[15], r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vcmp.i8 ne, q1, zr
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <16 x i8> %src, zeroinitializer
  %sh = shufflevector <16 x i1> %c, <16 x i1> undef, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 1>
  %s = select <16 x i1> %sh, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %s
}

define <2 x i64> @shuffle5_b_v2i64(<4 x i32> %src, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: shuffle5_b_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov q0[2], q0[0], r0, r1
; CHECK-NEXT:    vmov q0[3], q0[1], r0, r1
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i32 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %src, zeroinitializer
  %sh = shufflevector <4 x i1> %c, <4 x i1> undef, <2 x i32> <i32 0, i32 1>
  %s = select <2 x i1> %sh, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define <2 x i64> @shuffle5_t_v2i64(<4 x i32> %src, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: shuffle5_t_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    vmov q0[2], q0[0], r0, r1
; CHECK-NEXT:    vmov q0[3], q0[1], r0, r1
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i32 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %src, zeroinitializer
  %sh = shufflevector <4 x i1> %c, <4 x i1> undef, <2 x i32> <i32 2, i32 3>
  %s = select <2 x i1> %sh, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define <4 x i32> @shuffle5_b_v4i32(<8 x i16> %src, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: shuffle5_b_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov.u16 r0, q0[2]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[3]
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vcmp.i32 ne, q1, zr
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %src, zeroinitializer
  %sh = shufflevector <8 x i1> %c, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %s = select <4 x i1> %sh, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define <4 x i32> @shuffle5_t_v4i32(<8 x i16> %src, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: shuffle5_t_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[7]
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vcmp.i32 ne, q1, zr
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %src, zeroinitializer
  %sh = shufflevector <8 x i1> %c, <8 x i1> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s = select <4 x i1> %sh, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define <8 x i16> @shuffle5_b_v8i16(<16 x i8> %src, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: shuffle5_b_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q1, q1, q0
; CHECK-NEXT:    vmov.u8 r0, q1[0]
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vmov.u8 r0, q1[1]
; CHECK-NEXT:    vmov.16 q0[1], r0
; CHECK-NEXT:    vmov.u8 r0, q1[2]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.u8 r0, q1[3]
; CHECK-NEXT:    vmov.16 q0[3], r0
; CHECK-NEXT:    vmov.u8 r0, q1[4]
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov.u8 r0, q1[5]
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov.u8 r0, q1[6]
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov.u8 r0, q1[7]
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <16 x i8> %src, zeroinitializer
  %sh = shufflevector <16 x i1> %c, <16 x i1> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s = select <8 x i1> %sh, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define <8 x i16> @shuffle5_t_v8i16(<16 x i8> %src, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: shuffle5_t_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0xff
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-NEXT:    vmov.i8 q0, #0x0
; CHECK-NEXT:    vpsel q1, q1, q0
; CHECK-NEXT:    vmov.u8 r0, q1[8]
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vmov.u8 r0, q1[9]
; CHECK-NEXT:    vmov.16 q0[1], r0
; CHECK-NEXT:    vmov.u8 r0, q1[10]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.u8 r0, q1[11]
; CHECK-NEXT:    vmov.16 q0[3], r0
; CHECK-NEXT:    vmov.u8 r0, q1[12]
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov.u8 r0, q1[13]
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov.u8 r0, q1[14]
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov.u8 r0, q1[15]
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <16 x i8> %src, zeroinitializer
  %sh = shufflevector <16 x i1> %c, <16 x i1> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %s = select <8 x i1> %sh, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define <4 x i32> @shuffle6_v2i64(<2 x i64> %src1, <2 x i64> %src2, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: shuffle6_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    mov.w r1, #0
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    bfi r1, r0, #0, #4
; CHECK-NEXT:    orrs.w r0, r2, r3
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    bfi r1, r0, #4, #4
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r0, r2, d0
; CHECK-NEXT:    orrs r0, r2
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    bfi r1, r0, #8, #4
; CHECK-NEXT:    vmov r0, r2, d1
; CHECK-NEXT:    orrs r0, r2
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    bfi r1, r0, #12, #4
; CHECK-NEXT:    add r0, sp, #32
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c1 = icmp eq <2 x i64> %src1, zeroinitializer
  %c2 = icmp eq <2 x i64> %src2, zeroinitializer
  %sh = shufflevector <2 x i1> %c1, <2 x i1> %c2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %s = select <4 x i1> %sh, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define <8 x i16> @shuffle6_v4i32(<4 x i32> %src1, <4 x i32> %src2, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: shuffle6_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0x0
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vmov.i8 q2, #0xff
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    vpsel q3, q2, q1
; CHECK-NEXT:    vmov r0, r1, d6
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vmov.16 q0[1], r1
; CHECK-NEXT:    vmov r0, r1, d7
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vmov.16 q0[3], r1
; CHECK-NEXT:    vcmp.i32 eq, q3, zr
; CHECK-NEXT:    vpsel q1, q2, q1
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov.16 q0[5], r1
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    add r0, sp, #32
; CHECK-NEXT:    vmov.16 q0[7], r1
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c1 = icmp eq <4 x i32> %src1, zeroinitializer
  %c2 = icmp eq <4 x i32> %src2, zeroinitializer
  %sh = shufflevector <4 x i1> %c1, <4 x i1> %c2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s = select <8 x i1> %sh, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define <16 x i8> @shuffle6_v8i16(<8 x i16> %src1, <8 x i16> %src2, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: shuffle6_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov.i8 q1, #0x0
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    vmov.i8 q2, #0xff
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    vpsel q3, q2, q1
; CHECK-NEXT:    vmov.u16 r0, q3[0]
; CHECK-NEXT:    vmov.8 q0[0], r0
; CHECK-NEXT:    vmov.u16 r0, q3[1]
; CHECK-NEXT:    vmov.8 q0[1], r0
; CHECK-NEXT:    vmov.u16 r0, q3[2]
; CHECK-NEXT:    vmov.8 q0[2], r0
; CHECK-NEXT:    vmov.u16 r0, q3[3]
; CHECK-NEXT:    vmov.8 q0[3], r0
; CHECK-NEXT:    vmov.u16 r0, q3[4]
; CHECK-NEXT:    vmov.8 q0[4], r0
; CHECK-NEXT:    vmov.u16 r0, q3[5]
; CHECK-NEXT:    vmov.8 q0[5], r0
; CHECK-NEXT:    vmov.u16 r0, q3[6]
; CHECK-NEXT:    vmov.8 q0[6], r0
; CHECK-NEXT:    vmov.u16 r0, q3[7]
; CHECK-NEXT:    vmov.8 q0[7], r0
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.i16 eq, q3, zr
; CHECK-NEXT:    vpsel q1, q2, q1
; CHECK-NEXT:    vmov.u16 r0, q1[0]
; CHECK-NEXT:    vmov.8 q0[8], r0
; CHECK-NEXT:    vmov.u16 r0, q1[1]
; CHECK-NEXT:    vmov.8 q0[9], r0
; CHECK-NEXT:    vmov.u16 r0, q1[2]
; CHECK-NEXT:    vmov.8 q0[10], r0
; CHECK-NEXT:    vmov.u16 r0, q1[3]
; CHECK-NEXT:    vmov.8 q0[11], r0
; CHECK-NEXT:    vmov.u16 r0, q1[4]
; CHECK-NEXT:    vmov.8 q0[12], r0
; CHECK-NEXT:    vmov.u16 r0, q1[5]
; CHECK-NEXT:    vmov.8 q0[13], r0
; CHECK-NEXT:    vmov.u16 r0, q1[6]
; CHECK-NEXT:    vmov.8 q0[14], r0
; CHECK-NEXT:    vmov.u16 r0, q1[7]
; CHECK-NEXT:    vmov.8 q0[15], r0
; CHECK-NEXT:    add r0, sp, #32
; CHECK-NEXT:    vcmp.i8 ne, q0, zr
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    add r0, sp, #16
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %c1 = icmp eq <8 x i16> %src1, zeroinitializer
  %c2 = icmp eq <8 x i16> %src2, zeroinitializer
  %sh = shufflevector <8 x i1> %c1, <8 x i1> %c2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %s = select <16 x i1> %sh, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %s
}
