; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECKLE
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECKLE
; RUN: llc -mtriple=thumbebv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECKBE

define arm_aapcs_vfpcc <16 x i8> @mov_int8_1() {
; CHECK-LABEL: mov_int8_1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q0, #0x1
; CHECK-NEXT:    bx lr
entry:
  ret <16 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
}

define arm_aapcs_vfpcc <16 x i8> @mov_int8_m1() {
; CHECK-LABEL: mov_int8_m1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q0, #0xff
; CHECK-NEXT:    bx lr
entry:
  ret <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
}

; This has 0x01020304 or 0x04030201 vdup.32'd to q reg depending on endianness.
; The big endian is different as there is an implicit vrev64.8 out of the
; function, which gets constant folded away.
define arm_aapcs_vfpcc <16 x i8> @mov_int8_1234() {
; CHECKLE-LABEL: mov_int8_1234:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    movw r0, #513
; CHECKLE-NEXT:    movt r0, #1027
; CHECKLE-NEXT:    vdup.32 q0, r0
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: mov_int8_1234:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    movw r0, #772
; CHECKBE-NEXT:    movt r0, #258
; CHECKBE-NEXT:    vdup.32 q0, r0
; CHECKBE-NEXT:    bx lr
entry:
  ret <16 x i8> <i8 1, i8 2, i8 3, i8 4, i8 1, i8 2, i8 3, i8 4, i8 1, i8 2, i8 3, i8 4, i8 1, i8 2, i8 3, i8 4>
}

define arm_aapcs_vfpcc <8 x i16> @mov_int16_1() {
; CHECK-LABEL: mov_int16_1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i16 q0, #0x1
; CHECK-NEXT:    bx lr
entry:
  ret <8 x i16> <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
}

define arm_aapcs_vfpcc <8 x i16> @mov_int16_m1() {
; CHECK-LABEL: mov_int16_m1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q0, #0xff
; CHECK-NEXT:    bx lr
entry:
  ret <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
}

define arm_aapcs_vfpcc <8 x i16> @mov_int16_256() {
; CHECK-LABEL: mov_int16_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i16 q0, #0x100
; CHECK-NEXT:    bx lr
entry:
  ret <8 x i16> <i16 256, i16 256, i16 256, i16 256, i16 256, i16 256, i16 256, i16 256>
}

define arm_aapcs_vfpcc <8 x i16> @mov_int16_257() {
; CHECK-LABEL: mov_int16_257:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q0, #0x1
; CHECK-NEXT:    bx lr
entry:
  ret <8 x i16> <i16 257, i16 257, i16 257, i16 257, i16 257, i16 257, i16 257, i16 257>
}

define arm_aapcs_vfpcc <8 x i16> @mov_int16_258() {
; CHECK-LABEL: mov_int16_258:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mov.w r0, #258
; CHECK-NEXT:    vdup.16 q0, r0
; CHECK-NEXT:    bx lr
entry:
  ret <8 x i16> <i16 258, i16 258, i16 258, i16 258, i16 258, i16 258, i16 258, i16 258>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_1() {
; CHECK-LABEL: mov_int32_1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q0, #0x1
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 1, i32 1, i32 1, i32 1>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_256() {
; CHECK-LABEL: mov_int32_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q0, #0x100
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 256, i32 256, i32 256, i32 256>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_65536() {
; CHECK-LABEL: mov_int32_65536:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q0, #0x10000
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 65536, i32 65536, i32 65536, i32 65536>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_16777216() {
; CHECK-LABEL: mov_int32_16777216:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q0, #0x1000000
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 16777216, i32 16777216, i32 16777216, i32 16777216>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_16777217() {
; CHECK-LABEL: mov_int32_16777217:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r0, #1
; CHECK-NEXT:    movt r0, #256
; CHECK-NEXT:    vdup.32 q0, r0
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 16777217, i32 16777217, i32 16777217, i32 16777217>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_17919() {
; CHECK-LABEL: mov_int32_17919:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q0, #0x45ff
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 17919, i32 17919, i32 17919, i32 17919>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_4587519() {
; CHECK-LABEL: mov_int32_4587519:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q0, #0x45ffff
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 4587519, i32 4587519, i32 4587519, i32 4587519>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_m1() {
; CHECK-LABEL: mov_int32_m1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q0, #0xff
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_4294901760() {
; CHECK-LABEL: mov_int32_4294901760:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmvn.i32 q0, #0xffff
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 4294901760, i32 4294901760, i32 4294901760, i32 4294901760>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_4278190335() {
; CHECK-LABEL: mov_int32_4278190335:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r0, #255
; CHECK-NEXT:    movt r0, #65280
; CHECK-NEXT:    vdup.32 q0, r0
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 4278190335, i32 4278190335, i32 4278190335, i32 4278190335>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_4278255615() {
; CHECK-LABEL: mov_int32_4278255615:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmvn.i32 q0, #0xff0000
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 4278255615, i32 4278255615, i32 4278255615, i32 4278255615>
}

define arm_aapcs_vfpcc <4 x i32> @mov_int32_16908546() {
; CHECK-LABEL: mov_int32_16908546:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mov.w r0, #258
; CHECK-NEXT:    vdup.16 q0, r0
; CHECK-NEXT:    bx lr
entry:
  ret <4 x i32> <i32 16908546, i32 16908546, i32 16908546, i32 16908546>
}

define arm_aapcs_vfpcc <2 x i64> @mov_int64_1() {
; CHECKLE-LABEL: mov_int64_1:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    adr r0, .LCPI20_0
; CHECKLE-NEXT:    vldrw.u32 q0, [r0]
; CHECKLE-NEXT:    bx lr
; CHECKLE-NEXT:    .p2align 4
; CHECKLE-NEXT:  @ %bb.1:
; CHECKLE-NEXT:  .LCPI20_0:
; CHECKLE-NEXT:    .long 1 @ double 4.9406564584124654E-324
; CHECKLE-NEXT:    .long 0
; CHECKLE-NEXT:    .long 1 @ double 4.9406564584124654E-324
; CHECKLE-NEXT:    .long 0
;
; CHECKBE-LABEL: mov_int64_1:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    adr r0, .LCPI20_0
; CHECKBE-NEXT:    vldrb.u8 q1, [r0]
; CHECKBE-NEXT:    vrev64.8 q0, q1
; CHECKBE-NEXT:    bx lr
; CHECKBE-NEXT:    .p2align 4
; CHECKBE-NEXT:  @ %bb.1:
; CHECKBE-NEXT:  .LCPI20_0:
; CHECKBE-NEXT:    .long 0 @ double 4.9406564584124654E-324
; CHECKBE-NEXT:    .long 1
; CHECKBE-NEXT:    .long 0 @ double 4.9406564584124654E-324
; CHECKBE-NEXT:    .long 1
entry:
  ret <2 x i64> <i64 1, i64 1>
}

define arm_aapcs_vfpcc <2 x i64> @mov_int64_ff() {
; CHECK-LABEL: mov_int64_ff:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i64 q0, #0xff
; CHECK-NEXT:    bx lr
entry:
  ret <2 x i64> < i64 255, i64 255 >
}

define arm_aapcs_vfpcc <2 x i64> @mov_int64_m1() {
; CHECK-LABEL: mov_int64_m1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q0, #0xff
; CHECK-NEXT:    bx lr
entry:
  ret <2 x i64> < i64 -1, i64 -1 >
}

define arm_aapcs_vfpcc <2 x i64> @mov_int64_ff0000ff0000ffff() {
; CHECK-LABEL: mov_int64_ff0000ff0000ffff:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i64 q0, #0xff0000ff0000ffff
; CHECK-NEXT:    bx lr
entry:
  ret <2 x i64> < i64 18374687574888349695, i64 18374687574888349695 >
}

define arm_aapcs_vfpcc <2 x i64> @mov_int64_f_0() {
; CHECKLE-LABEL: mov_int64_f_0:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    adr r0, .LCPI24_0
; CHECKLE-NEXT:    vldrw.u32 q0, [r0]
; CHECKLE-NEXT:    bx lr
; CHECKLE-NEXT:    .p2align 4
; CHECKLE-NEXT:  @ %bb.1:
; CHECKLE-NEXT:  .LCPI24_0:
; CHECKLE-NEXT:    .long 255 @ double 1.2598673968951787E-321
; CHECKLE-NEXT:    .long 0
; CHECKLE-NEXT:    .long 0 @ double 0
; CHECKLE-NEXT:    .long 0
;
; CHECKBE-LABEL: mov_int64_f_0:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    adr r0, .LCPI24_0
; CHECKBE-NEXT:    vldrb.u8 q1, [r0]
; CHECKBE-NEXT:    vrev64.8 q0, q1
; CHECKBE-NEXT:    bx lr
; CHECKBE-NEXT:    .p2align 4
; CHECKBE-NEXT:  @ %bb.1:
; CHECKBE-NEXT:  .LCPI24_0:
; CHECKBE-NEXT:    .long 0 @ double 1.2598673968951787E-321
; CHECKBE-NEXT:    .long 255
; CHECKBE-NEXT:    .long 0 @ double 0
; CHECKBE-NEXT:    .long 0
entry:
  ret <2 x i64> < i64 255, i64 0 >
}

define arm_aapcs_vfpcc <16 x i8> @mov_int64_0f000f0f() {
; CHECKLE-LABEL: mov_int64_0f000f0f:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    vmov.i64 q0, #0xff000000ff00ff
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: mov_int64_0f000f0f:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    vmov.i64 q0, #0xff00ff000000ff00
; CHECKBE-NEXT:    bx lr
entry:
  ret <16 x i8> <i8 -1, i8 0, i8 -1, i8 0, i8 0, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 0, i8 0, i8 -1, i8 0>
}

define arm_aapcs_vfpcc <8 x i16> @mov_int64_ff00ffff() {
; CHECKLE-LABEL: mov_int64_ff00ffff:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    vmov.i64 q0, #0xffffffff0000ffff
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: mov_int64_ff00ffff:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    vmov.i64 q0, #0xffff0000ffffffff
; CHECKBE-NEXT:    bx lr
entry:
  ret <8 x i16> <i16 -1, i16 0, i16 -1, i16 -1, i16 -1, i16 0, i16 -1, i16 -1>
}

define arm_aapcs_vfpcc <16 x i8> @mov_int64_0f0f0f0f0f0f0f0f() {
; CHECKLE-LABEL: mov_int64_0f0f0f0f0f0f0f0f:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    vmov.i16 q0, #0xff
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: mov_int64_0f0f0f0f0f0f0f0f:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    vmov.i16 q0, #0xff00
; CHECKBE-NEXT:    bx lr
entry:
  ret <16 x i8> <i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0>
}

define arm_aapcs_vfpcc <4 x float> @mov_float_1() {
; CHECK-LABEL: mov_float_1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mov.w r0, #1065353216
; CHECK-NEXT:    vdup.32 q0, r0
; CHECK-NEXT:    bx lr
entry:
  ret <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
}

define arm_aapcs_vfpcc <4 x float> @mov_float_m3() {
; CHECK-LABEL: mov_float_m3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    movt r0, #49216
; CHECK-NEXT:    vdup.32 q0, r0
; CHECK-NEXT:    bx lr
entry:
  ret <4 x float> <float -3.000000e+00, float -3.000000e+00, float -3.000000e+00, float -3.000000e+00>
}

define arm_aapcs_vfpcc <8 x half> @mov_float16_1() {
; CHECK-LABEL: mov_float16_1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i16 q0, #0x3c00
; CHECK-NEXT:    bx lr

entry:
  ret <8 x half> <half 1.000000e+00, half 1.000000e+00, half 1.000000e+00, half 1.000000e+00, half 1.000000e+00, half 1.000000e+00, half 1.000000e+00, half 1.000000e+00>
}

define arm_aapcs_vfpcc <8 x half> @mov_float16_m3() {
; CHECK-LABEL: mov_float16_m3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i16 q0, #0xc200
; CHECK-NEXT:    bx lr

entry:
  ret <8 x half> <half -3.000000e+00, half -3.000000e+00, half -3.000000e+00, half -3.000000e+00, half -3.000000e+00, half -3.000000e+00, half -3.000000e+00, half -3.000000e+00>
}

define arm_aapcs_vfpcc <2 x double> @mov_double_1() {
; CHECKLE-LABEL: mov_double_1:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    adr r0, .LCPI32_0
; CHECKLE-NEXT:    vldrw.u32 q0, [r0]
; CHECKLE-NEXT:    bx lr
; CHECKLE-NEXT:    .p2align 4
; CHECKLE-NEXT:  @ %bb.1:
; CHECKLE-NEXT:  .LCPI32_0:
; CHECKLE-NEXT:    .long 0 @ double 1
; CHECKLE-NEXT:    .long 1072693248
; CHECKLE-NEXT:    .long 0 @ double 1
; CHECKLE-NEXT:    .long 1072693248
;
; CHECKBE-LABEL: mov_double_1:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    adr r0, .LCPI32_0
; CHECKBE-NEXT:    vldrb.u8 q1, [r0]
; CHECKBE-NEXT:    vrev64.8 q0, q1
; CHECKBE-NEXT:    bx lr
; CHECKBE-NEXT:    .p2align 4
; CHECKBE-NEXT:  @ %bb.1:
; CHECKBE-NEXT:  .LCPI32_0:
; CHECKBE-NEXT:    .long 1072693248 @ double 1
; CHECKBE-NEXT:    .long 0
; CHECKBE-NEXT:    .long 1072693248 @ double 1
; CHECKBE-NEXT:    .long 0
entry:
  ret <2 x double> <double 1.000000e+00, double 1.000000e+00>
}

define arm_aapcs_vfpcc <16 x i8> @test(<16 x i8> %i) {
; CHECKLE-LABEL: test:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    vmov.i64 q1, #0xff000000ff00ff
; CHECKLE-NEXT:    vorr q0, q0, q1
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: test:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    vmov.i64 q1, #0xff00ff000000ff00
; CHECKBE-NEXT:    vrev64.8 q2, q1
; CHECKBE-NEXT:    vrev64.8 q1, q0
; CHECKBE-NEXT:    vorr q1, q1, q2
; CHECKBE-NEXT:    vrev64.8 q0, q1
; CHECKBE-NEXT:    bx lr
entry:
  %o = or <16 x i8> %i, <i8 -1, i8 0, i8 -1, i8 0, i8 0, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 -1, i8 0, i8 0, i8 0, i8 -1, i8 0>
  ret <16 x i8> %o
}

define arm_aapcs_vfpcc <8 x i16> @test2(<8 x i16> %i) {
; CHECKLE-LABEL: test2:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    vmov.i64 q1, #0xffffffff0000ffff
; CHECKLE-NEXT:    vorr q0, q0, q1
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: test2:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    vmov.i64 q1, #0xffff0000ffffffff
; CHECKBE-NEXT:    vrev64.16 q2, q1
; CHECKBE-NEXT:    vrev64.16 q1, q0
; CHECKBE-NEXT:    vorr q1, q1, q2
; CHECKBE-NEXT:    vrev64.16 q0, q1
; CHECKBE-NEXT:    bx lr
entry:
  %o = or <8 x i16> %i, <i16 -1, i16 0, i16 -1, i16 -1, i16 -1, i16 0, i16 -1, i16 -1>
  ret <8 x i16> %o
}

define arm_aapcs_vfpcc <4 x i32> @i1and_vmov(<4 x i32> %a, <4 x i32> %b, i32 %c) {
; CHECKLE-LABEL: i1and_vmov:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    cmp r0, #0
; CHECKLE-NEXT:    mov.w r1, #15
; CHECKLE-NEXT:    csetm r0, eq
; CHECKLE-NEXT:    ands r0, r1
; CHECKLE-NEXT:    vmsr p0, r0
; CHECKLE-NEXT:    vpsel q0, q0, q1
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: i1and_vmov:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    cmp r0, #0
; CHECKBE-NEXT:    mov.w r1, #15
; CHECKBE-NEXT:    csetm r0, eq
; CHECKBE-NEXT:    vrev64.32 q2, q1
; CHECKBE-NEXT:    ands r0, r1
; CHECKBE-NEXT:    vrev64.32 q1, q0
; CHECKBE-NEXT:    vmsr p0, r0
; CHECKBE-NEXT:    vpsel q1, q1, q2
; CHECKBE-NEXT:    vrev64.32 q0, q1
; CHECKBE-NEXT:    bx lr
entry:
  %c1 = icmp eq i32 %c, zeroinitializer
  %broadcast.splatinsert1967 = insertelement <4 x i1> undef, i1 %c1, i32 0
  %broadcast.splat1968 = shufflevector <4 x i1> %broadcast.splatinsert1967, <4 x i1> undef, <4 x i32> zeroinitializer
  %l699 = and <4 x i1> %broadcast.splat1968, <i1 true, i1 false, i1 false, i1 false>
  %s = select <4 x i1> %l699, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <4 x i32> @i1or_vmov(<4 x i32> %a, <4 x i32> %b, i32 %c) {
; CHECKLE-LABEL: i1or_vmov:
; CHECKLE:       @ %bb.0: @ %entry
; CHECKLE-NEXT:    cmp r0, #0
; CHECKLE-NEXT:    mov.w r1, #15
; CHECKLE-NEXT:    csetm r0, eq
; CHECKLE-NEXT:    orrs r0, r1
; CHECKLE-NEXT:    vmsr p0, r0
; CHECKLE-NEXT:    vpsel q0, q0, q1
; CHECKLE-NEXT:    bx lr
;
; CHECKBE-LABEL: i1or_vmov:
; CHECKBE:       @ %bb.0: @ %entry
; CHECKBE-NEXT:    cmp r0, #0
; CHECKBE-NEXT:    mov.w r1, #15
; CHECKBE-NEXT:    csetm r0, eq
; CHECKBE-NEXT:    vrev64.32 q2, q1
; CHECKBE-NEXT:    orrs r0, r1
; CHECKBE-NEXT:    vrev64.32 q1, q0
; CHECKBE-NEXT:    vmsr p0, r0
; CHECKBE-NEXT:    vpsel q1, q1, q2
; CHECKBE-NEXT:    vrev64.32 q0, q1
; CHECKBE-NEXT:    bx lr
entry:
  %c1 = icmp eq i32 %c, zeroinitializer
  %broadcast.splatinsert1967 = insertelement <4 x i1> undef, i1 %c1, i32 0
  %broadcast.splat1968 = shufflevector <4 x i1> %broadcast.splatinsert1967, <4 x i1> undef, <4 x i32> zeroinitializer
  %l699 = or <4 x i1> %broadcast.splat1968, <i1 true, i1 false, i1 false, i1 false>
  %s = select <4 x i1> %l699, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <2 x i64> @v2i1and_vmov(<2 x i64> %a, <2 x i64> %b, i32 %c) {
; CHECK-LABEL: v2i1and_vmov:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    mov.w r1, #0
; CHECK-NEXT:    csetm r0, eq
; CHECK-NEXT:    bfi r1, r0, #0, #8
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c1 = icmp eq i32 %c, zeroinitializer
  %broadcast.splatinsert1967 = insertelement <2 x i1> undef, i1 %c1, i32 0
  %broadcast.splat1968 = shufflevector <2 x i1> %broadcast.splatinsert1967, <2 x i1> undef, <2 x i32> zeroinitializer
  %l699 = and <2 x i1> %broadcast.splat1968, <i1 true, i1 false>
  %s = select <2 x i1> %l699, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define arm_aapcs_vfpcc <2 x i64> @v2i1or_vmov(<2 x i64> %a, <2 x i64> %b, i32 %c) {
; CHECK-LABEL: v2i1or_vmov:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    mov.w r1, #255
; CHECK-NEXT:    csetm r0, eq
; CHECK-NEXT:    bfi r1, r0, #8, #8
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c1 = icmp eq i32 %c, zeroinitializer
  %broadcast.splatinsert1967 = insertelement <2 x i1> undef, i1 %c1, i32 0
  %broadcast.splat1968 = shufflevector <2 x i1> %broadcast.splatinsert1967, <2 x i1> undef, <2 x i32> zeroinitializer
  %l699 = or <2 x i1> %broadcast.splat1968, <i1 true, i1 false>
  %s = select <2 x i1> %l699, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}
