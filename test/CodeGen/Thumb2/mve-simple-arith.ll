; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-MVE
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-MVEFP

define arm_aapcs_vfpcc <16 x i8> @add_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: add_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = add <16 x i8> %src1, %src2
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @add_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: add_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = add <8 x i16> %src1, %src2
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @add_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: add_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = add nsw <4 x i32> %src1, %src2
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @add_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: add_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    adds.w lr, r3, r2
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    adc.w r12, r1, r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    adds r0, r0, r2
; CHECK-NEXT:    adcs r1, r3
; CHECK-NEXT:    vmov q0[2], q0[0], r0, lr
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r12
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = add nsw <2 x i64> %src1, %src2
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <4 x float> @add_float32_t(<4 x float> %src1, <4 x float> %src2) {
; CHECK-MVE-LABEL: add_float32_t:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vadd.f32 s11, s7, s3
; CHECK-MVE-NEXT:    vadd.f32 s10, s6, s2
; CHECK-MVE-NEXT:    vadd.f32 s9, s5, s1
; CHECK-MVE-NEXT:    vadd.f32 s8, s4, s0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: add_float32_t:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vadd.f32 q0, q1, q0
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fadd nnan ninf nsz <4 x float> %src2, %src1
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <8 x half> @add_float16_t(<8 x half> %src1, <8 x half> %src2) {
; CHECK-MVE-LABEL: add_float16_t:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vadd.f16 s8, s4, s0
; CHECK-MVE-NEXT:    vmovx.f16 s10, s4
; CHECK-MVE-NEXT:    vmov r0, s8
; CHECK-MVE-NEXT:    vmovx.f16 s8, s0
; CHECK-MVE-NEXT:    vadd.f16 s8, s10, s8
; CHECK-MVE-NEXT:    vadd.f16 s12, s5, s1
; CHECK-MVE-NEXT:    vmov r1, s8
; CHECK-MVE-NEXT:    vmov.16 q2[0], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s12, s1
; CHECK-MVE-NEXT:    vmovx.f16 s14, s5
; CHECK-MVE-NEXT:    vmov.16 q2[1], r1
; CHECK-MVE-NEXT:    vadd.f16 s12, s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[2], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vadd.f16 s12, s6, s2
; CHECK-MVE-NEXT:    vmov.16 q2[3], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s12, s2
; CHECK-MVE-NEXT:    vmovx.f16 s14, s6
; CHECK-MVE-NEXT:    vadd.f16 s12, s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[4], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmovx.f16 s2, s7
; CHECK-MVE-NEXT:    vadd.f16 s12, s7, s3
; CHECK-MVE-NEXT:    vmov.16 q2[5], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vadd.f16 s0, s2, s0
; CHECK-MVE-NEXT:    vmov.16 q2[6], r0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.16 q2[7], r0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: add_float16_t:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vadd.f16 q0, q1, q0
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fadd nnan ninf nsz <8 x half> %src2, %src1
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <2 x double> @add_float64_t(<2 x double> %src1, <2 x double> %src2) {
; CHECK-LABEL: add_float64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov q4, q1
; CHECK-NEXT:    vmov q5, q0
; CHECK-NEXT:    vmov r0, r1, d9
; CHECK-NEXT:    vmov r2, r3, d11
; CHECK-NEXT:    bl __aeabi_dadd
; CHECK-NEXT:    vmov lr, r12, d8
; CHECK-NEXT:    vmov r2, r3, d10
; CHECK-NEXT:    vmov d9, r0, r1
; CHECK-NEXT:    mov r0, lr
; CHECK-NEXT:    mov r1, r12
; CHECK-NEXT:    bl __aeabi_dadd
; CHECK-NEXT:    vmov d8, r0, r1
; CHECK-NEXT:    vmov q0, q4
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = fadd nnan ninf nsz <2 x double> %src2, %src1
  ret <2 x double> %0
}


define arm_aapcs_vfpcc <16 x i8> @sub_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: sub_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vsub.i8 q0, q1, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = sub <16 x i8> %src2, %src1
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @sub_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: sub_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vsub.i16 q0, q1, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = sub <8 x i16> %src2, %src1
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @sub_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: sub_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vsub.i32 q0, q1, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = sub nsw <4 x i32> %src2, %src1
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @sub_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: sub_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov r3, s4
; CHECK-NEXT:    vmov r0, s1
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    subs.w lr, r3, r2
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    vmov r3, s7
; CHECK-NEXT:    sbc.w r12, r1, r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    subs r0, r2, r0
; CHECK-NEXT:    sbc.w r1, r3, r1
; CHECK-NEXT:    vmov q0[2], q0[0], r0, lr
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r12
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = sub nsw <2 x i64> %src2, %src1
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <4 x float> @sub_float32_t(<4 x float> %src1, <4 x float> %src2) {
; CHECK-MVE-LABEL: sub_float32_t:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vsub.f32 s11, s7, s3
; CHECK-MVE-NEXT:    vsub.f32 s10, s6, s2
; CHECK-MVE-NEXT:    vsub.f32 s9, s5, s1
; CHECK-MVE-NEXT:    vsub.f32 s8, s4, s0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: sub_float32_t:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vsub.f32 q0, q1, q0
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fsub nnan ninf nsz <4 x float> %src2, %src1
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <8 x half> @sub_float16_t(<8 x half> %src1, <8 x half> %src2) {
; CHECK-MVE-LABEL: sub_float16_t:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vsub.f16 s8, s4, s0
; CHECK-MVE-NEXT:    vmovx.f16 s10, s4
; CHECK-MVE-NEXT:    vmov r0, s8
; CHECK-MVE-NEXT:    vmovx.f16 s8, s0
; CHECK-MVE-NEXT:    vsub.f16 s8, s10, s8
; CHECK-MVE-NEXT:    vsub.f16 s12, s5, s1
; CHECK-MVE-NEXT:    vmov r1, s8
; CHECK-MVE-NEXT:    vmov.16 q2[0], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s12, s1
; CHECK-MVE-NEXT:    vmovx.f16 s14, s5
; CHECK-MVE-NEXT:    vmov.16 q2[1], r1
; CHECK-MVE-NEXT:    vsub.f16 s12, s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[2], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vsub.f16 s12, s6, s2
; CHECK-MVE-NEXT:    vmov.16 q2[3], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s12, s2
; CHECK-MVE-NEXT:    vmovx.f16 s14, s6
; CHECK-MVE-NEXT:    vsub.f16 s12, s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[4], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmovx.f16 s2, s7
; CHECK-MVE-NEXT:    vsub.f16 s12, s7, s3
; CHECK-MVE-NEXT:    vmov.16 q2[5], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vsub.f16 s0, s2, s0
; CHECK-MVE-NEXT:    vmov.16 q2[6], r0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.16 q2[7], r0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: sub_float16_t:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vsub.f16 q0, q1, q0
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fsub nnan ninf nsz <8 x half> %src2, %src1
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <2 x double> @sub_float64_t(<2 x double> %src1, <2 x double> %src2) {
; CHECK-LABEL: sub_float64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov q4, q1
; CHECK-NEXT:    vmov q5, q0
; CHECK-NEXT:    vmov r0, r1, d9
; CHECK-NEXT:    vmov r2, r3, d11
; CHECK-NEXT:    bl __aeabi_dsub
; CHECK-NEXT:    vmov lr, r12, d8
; CHECK-NEXT:    vmov r2, r3, d10
; CHECK-NEXT:    vmov d9, r0, r1
; CHECK-NEXT:    mov r0, lr
; CHECK-NEXT:    mov r1, r12
; CHECK-NEXT:    bl __aeabi_dsub
; CHECK-NEXT:    vmov d8, r0, r1
; CHECK-NEXT:    vmov q0, q4
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = fsub nnan ninf nsz <2 x double> %src2, %src1
  ret <2 x double> %0
}


define arm_aapcs_vfpcc <16 x i8> @mul_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: mul_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = mul <16 x i8> %src1, %src2
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @mul_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: mul_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = mul <8 x i16> %src1, %src2
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @mul_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: mul_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = mul nsw <4 x i32> %src1, %src2
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @mul_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: mul_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov r2, s5
; CHECK-NEXT:    umull r12, r3, r1, r0
; CHECK-NEXT:    mla lr, r1, r2, r3
; CHECK-NEXT:    vmov r3, s6
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s7
; CHECK-NEXT:    umull r4, r5, r1, r3
; CHECK-NEXT:    mla r1, r1, r2, r5
; CHECK-NEXT:    vmov r2, s1
; CHECK-NEXT:    mla r0, r2, r0, lr
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov q0[2], q0[0], r4, r12
; CHECK-NEXT:    mla r1, r2, r3, r1
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %0 = mul nsw <2 x i64> %src1, %src2
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <8 x half> @mul_float16_t(<8 x half> %src1, <8 x half> %src2) {
; CHECK-MVE-LABEL: mul_float16_t:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vmul.f16 s8, s4, s0
; CHECK-MVE-NEXT:    vmovx.f16 s10, s4
; CHECK-MVE-NEXT:    vmov r0, s8
; CHECK-MVE-NEXT:    vmovx.f16 s8, s0
; CHECK-MVE-NEXT:    vmul.f16 s8, s10, s8
; CHECK-MVE-NEXT:    vmul.f16 s12, s5, s1
; CHECK-MVE-NEXT:    vmov r1, s8
; CHECK-MVE-NEXT:    vmov.16 q2[0], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s12, s1
; CHECK-MVE-NEXT:    vmovx.f16 s14, s5
; CHECK-MVE-NEXT:    vmov.16 q2[1], r1
; CHECK-MVE-NEXT:    vmul.f16 s12, s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[2], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmul.f16 s12, s6, s2
; CHECK-MVE-NEXT:    vmov.16 q2[3], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s12, s2
; CHECK-MVE-NEXT:    vmovx.f16 s14, s6
; CHECK-MVE-NEXT:    vmul.f16 s12, s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[4], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmovx.f16 s2, s7
; CHECK-MVE-NEXT:    vmul.f16 s12, s7, s3
; CHECK-MVE-NEXT:    vmov.16 q2[5], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmul.f16 s0, s2, s0
; CHECK-MVE-NEXT:    vmov.16 q2[6], r0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.16 q2[7], r0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: mul_float16_t:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmul.f16 q0, q1, q0
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fmul nnan ninf nsz <8 x half> %src2, %src1
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <4 x float> @mul_float32_t(<4 x float> %src1, <4 x float> %src2) {
; CHECK-MVE-LABEL: mul_float32_t:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vmul.f32 s11, s7, s3
; CHECK-MVE-NEXT:    vmul.f32 s10, s6, s2
; CHECK-MVE-NEXT:    vmul.f32 s9, s5, s1
; CHECK-MVE-NEXT:    vmul.f32 s8, s4, s0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: mul_float32_t:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmul.f32 q0, q1, q0
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fmul nnan ninf nsz <4 x float> %src2, %src1
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <2 x double> @mul_float64_t(<2 x double> %src1, <2 x double> %src2) {
; CHECK-LABEL: mul_float64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov q4, q1
; CHECK-NEXT:    vmov q5, q0
; CHECK-NEXT:    vmov r0, r1, d9
; CHECK-NEXT:    vmov r2, r3, d11
; CHECK-NEXT:    bl __aeabi_dmul
; CHECK-NEXT:    vmov lr, r12, d8
; CHECK-NEXT:    vmov r2, r3, d10
; CHECK-NEXT:    vmov d9, r0, r1
; CHECK-NEXT:    mov r0, lr
; CHECK-NEXT:    mov r1, r12
; CHECK-NEXT:    bl __aeabi_dmul
; CHECK-NEXT:    vmov d8, r0, r1
; CHECK-NEXT:    vmov q0, q4
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = fmul nnan ninf nsz <2 x double> %src2, %src1
  ret <2 x double> %0
}

