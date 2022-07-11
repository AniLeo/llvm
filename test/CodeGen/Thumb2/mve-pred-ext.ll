; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-MVE
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-MVEFP

define arm_aapcs_vfpcc <4 x i32> @sext_v4i1_v4i32(<4 x i32> %src) {
; CHECK-LABEL: sext_v4i1_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vmov.i8 q2, #0xff
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    vpsel q0, q2, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %src, zeroinitializer
  %0 = sext <4 x i1> %c to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <4 x i32> @sext_v4i1_v4f32(<4 x float> %src1, <4 x float> %src2) {
; CHECK-MVE-LABEL: sext_v4i1_v4f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcmp.f32 s2, s6
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f32 s0, s4
; CHECK-MVE-NEXT:    csetm r0, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f32 s3, s7
; CHECK-MVE-NEXT:    csetm r1, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f32 s1, s5
; CHECK-MVE-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-MVE-NEXT:    csetm r2, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    csetm r3, ne
; CHECK-MVE-NEXT:    vmov q0[3], q0[1], r3, r2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: sext_v4i1_v4f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q2, #0x0
; CHECK-MVEFP-NEXT:    vmov.i8 q3, #0xff
; CHECK-MVEFP-NEXT:    vcmp.f32 ne, q0, q1
; CHECK-MVEFP-NEXT:    vpsel q0, q3, q2
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = fcmp une <4 x float> %src1, %src2
  %0 = sext <4 x i1> %c to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @sext_v8i1_v8i16(<8 x i16> %src) {
; CHECK-LABEL: sext_v8i1_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i16 q1, #0x0
; CHECK-NEXT:    vmov.i8 q2, #0xff
; CHECK-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-NEXT:    vpsel q0, q2, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %src, zeroinitializer
  %0 = sext <8 x i1> %c to <8 x i16>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <8 x i16> @sext_v8i1_v8f32(<8 x half> %src1, <8 x half> %src2) {
; CHECK-MVE-LABEL: sext_v8i1_v8f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    push {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    vcmp.f16 s3, s7
; CHECK-MVE-NEXT:    vmovx.f16 s8, s7
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vmovx.f16 s10, s3
; CHECK-MVE-NEXT:    vcmp.f16 s10, s8
; CHECK-MVE-NEXT:    csetm r12, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s2, s6
; CHECK-MVE-NEXT:    vmovx.f16 s6, s6
; CHECK-MVE-NEXT:    vmovx.f16 s2, s2
; CHECK-MVE-NEXT:    csetm lr, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s2, s6
; CHECK-MVE-NEXT:    vmovx.f16 s2, s5
; CHECK-MVE-NEXT:    vmovx.f16 s6, s1
; CHECK-MVE-NEXT:    csetm r2, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s1, s5
; CHECK-MVE-NEXT:    csetm r3, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s6, s2
; CHECK-MVE-NEXT:    vmovx.f16 s2, s4
; CHECK-MVE-NEXT:    csetm r0, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s0, s4
; CHECK-MVE-NEXT:    vmovx.f16 s0, s0
; CHECK-MVE-NEXT:    csetm r1, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s0, s2
; CHECK-MVE-NEXT:    csetm r4, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vmov.16 q0[0], r4
; CHECK-MVE-NEXT:    csetm r5, ne
; CHECK-MVE-NEXT:    vmov.16 q0[1], r5
; CHECK-MVE-NEXT:    vmov.16 q0[2], r0
; CHECK-MVE-NEXT:    vmov.16 q0[3], r1
; CHECK-MVE-NEXT:    vmov.16 q0[4], r2
; CHECK-MVE-NEXT:    vmov.16 q0[5], r3
; CHECK-MVE-NEXT:    vmov.16 q0[6], r12
; CHECK-MVE-NEXT:    vmov.16 q0[7], lr
; CHECK-MVE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-MVEFP-LABEL: sext_v8i1_v8f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i16 q2, #0x0
; CHECK-MVEFP-NEXT:    vmov.i8 q3, #0xff
; CHECK-MVEFP-NEXT:    vcmp.f16 ne, q0, q1
; CHECK-MVEFP-NEXT:    vpsel q0, q3, q2
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = fcmp une <8 x half> %src1, %src2
  %0 = sext <8 x i1> %c to <8 x i16>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <16 x i8> @sext_v16i1_v16i8(<16 x i8> %src) {
; CHECK-LABEL: sext_v16i1_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q1, #0x0
; CHECK-NEXT:    vmov.i8 q2, #0xff
; CHECK-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-NEXT:    vpsel q0, q2, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp sgt <16 x i8> %src, zeroinitializer
  %0 = sext <16 x i1> %c to <16 x i8>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <2 x i64> @sext_v2i1_v2i64(<2 x i64> %src) {
; CHECK-LABEL: sext_v2i1_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    mov.w r12, #0
; CHECK-NEXT:    vmov r2, r3, d0
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    sbcs.w r0, r12, r1
; CHECK-NEXT:    csetm r0, lt
; CHECK-NEXT:    rsbs r1, r2, #0
; CHECK-NEXT:    sbcs.w r1, r12, r3
; CHECK-NEXT:    csetm r1, lt
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    bx lr
entry:
  %c = icmp sgt <2 x i64> %src, zeroinitializer
  %0 = sext <2 x i1> %c to <2 x i64>
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <2 x i64> @sext_v2i1_v2f64(<2 x double> %src) {
; CHECK-MVE-LABEL: sext_v2i1_v2f64:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r4, r5, r6, lr}
; CHECK-MVE-NEXT:    push {r4, r5, r6, lr}
; CHECK-MVE-NEXT:    .vsave {d8, d9}
; CHECK-MVE-NEXT:    vpush {d8, d9}
; CHECK-MVE-NEXT:    vmov q4, q0
; CHECK-MVE-NEXT:    vldr d0, .LCPI6_0
; CHECK-MVE-NEXT:    vmov r0, r1, d9
; CHECK-MVE-NEXT:    vmov r4, r5, d0
; CHECK-MVE-NEXT:    mov r2, r4
; CHECK-MVE-NEXT:    mov r3, r5
; CHECK-MVE-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVE-NEXT:    vmov r2, r1, d8
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    mov r3, r5
; CHECK-MVE-NEXT:    csetm r6, eq
; CHECK-MVE-NEXT:    mov r0, r2
; CHECK-MVE-NEXT:    mov r2, r4
; CHECK-MVE-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    csetm r0, eq
; CHECK-MVE-NEXT:    vmov q0[2], q0[0], r0, r6
; CHECK-MVE-NEXT:    vmov q0[3], q0[1], r0, r6
; CHECK-MVE-NEXT:    vpop {d8, d9}
; CHECK-MVE-NEXT:    pop {r4, r5, r6, pc}
; CHECK-MVE-NEXT:    .p2align 3
; CHECK-MVE-NEXT:  @ %bb.1:
; CHECK-MVE-NEXT:  .LCPI6_0:
; CHECK-MVE-NEXT:    .long 0 @ double 0
; CHECK-MVE-NEXT:    .long 0
;
; CHECK-MVEFP-LABEL: sext_v2i1_v2f64:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    .save {r4, r5, r6, lr}
; CHECK-MVEFP-NEXT:    push {r4, r5, r6, lr}
; CHECK-MVEFP-NEXT:    .vsave {d8, d9}
; CHECK-MVEFP-NEXT:    vpush {d8, d9}
; CHECK-MVEFP-NEXT:    vmov q4, q0
; CHECK-MVEFP-NEXT:    vldr d0, .LCPI6_0
; CHECK-MVEFP-NEXT:    vmov r0, r1, d9
; CHECK-MVEFP-NEXT:    vmov r4, r5, d0
; CHECK-MVEFP-NEXT:    mov r2, r4
; CHECK-MVEFP-NEXT:    mov r3, r5
; CHECK-MVEFP-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVEFP-NEXT:    mov r6, r0
; CHECK-MVEFP-NEXT:    vmov r0, r1, d8
; CHECK-MVEFP-NEXT:    mov r2, r4
; CHECK-MVEFP-NEXT:    mov r3, r5
; CHECK-MVEFP-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVEFP-NEXT:    cmp r6, #0
; CHECK-MVEFP-NEXT:    csetm r1, eq
; CHECK-MVEFP-NEXT:    cmp r0, #0
; CHECK-MVEFP-NEXT:    csetm r0, eq
; CHECK-MVEFP-NEXT:    vmov q0[2], q0[0], r0, r1
; CHECK-MVEFP-NEXT:    vmov q0[3], q0[1], r0, r1
; CHECK-MVEFP-NEXT:    vpop {d8, d9}
; CHECK-MVEFP-NEXT:    pop {r4, r5, r6, pc}
; CHECK-MVEFP-NEXT:    .p2align 3
; CHECK-MVEFP-NEXT:  @ %bb.1:
; CHECK-MVEFP-NEXT:  .LCPI6_0:
; CHECK-MVEFP-NEXT:    .long 0 @ double 0
; CHECK-MVEFP-NEXT:    .long 0
entry:
  %c = fcmp une <2 x double> %src, zeroinitializer
  %0 = sext <2 x i1> %c to <2 x i64>
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <4 x i32> @zext_v4i1_v4i32(<4 x i32> %src) {
; CHECK-LABEL: zext_v4i1_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vmov.i32 q2, #0x1
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    vpsel q0, q2, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %src, zeroinitializer
  %0 = zext <4 x i1> %c to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <4 x i32> @zext_v4i1_v4f32(<4 x float> %src1, <4 x float> %src2) {
; CHECK-MVE-LABEL: zext_v4i1_v4f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcmp.f32 s3, s7
; CHECK-MVE-NEXT:    vmov.i32 q2, #0x1
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f32 s1, s5
; CHECK-MVE-NEXT:    csetm r0, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f32 s2, s6
; CHECK-MVE-NEXT:    csetm r1, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f32 s0, s4
; CHECK-MVE-NEXT:    csetm r2, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    csetm r3, ne
; CHECK-MVE-NEXT:    vmov q0[2], q0[0], r3, r2
; CHECK-MVE-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-MVE-NEXT:    vand q0, q0, q2
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: zext_v4i1_v4f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q2, #0x0
; CHECK-MVEFP-NEXT:    vmov.i32 q3, #0x1
; CHECK-MVEFP-NEXT:    vcmp.f32 ne, q0, q1
; CHECK-MVEFP-NEXT:    vpsel q0, q3, q2
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = fcmp une <4 x float> %src1, %src2
  %0 = zext <4 x i1> %c to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @zext_v8i1_v8i16(<8 x i16> %src) {
; CHECK-LABEL: zext_v8i1_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i16 q1, #0x0
; CHECK-NEXT:    vmov.i16 q2, #0x1
; CHECK-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-NEXT:    vpsel q0, q2, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %src, zeroinitializer
  %0 = zext <8 x i1> %c to <8 x i16>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <8 x i16> @zext_v8i1_v8f32(<8 x half> %src1, <8 x half> %src2) {
; CHECK-MVE-LABEL: zext_v8i1_v8f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    push {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    vmovx.f16 s8, s7
; CHECK-MVE-NEXT:    vmovx.f16 s10, s3
; CHECK-MVE-NEXT:    vcmp.f16 s10, s8
; CHECK-MVE-NEXT:    vmovx.f16 s8, s6
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vmovx.f16 s10, s2
; CHECK-MVE-NEXT:    vcmp.f16 s10, s8
; CHECK-MVE-NEXT:    vmovx.f16 s8, s5
; CHECK-MVE-NEXT:    vmovx.f16 s10, s1
; CHECK-MVE-NEXT:    csetm r12, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s3, s7
; CHECK-MVE-NEXT:    csetm lr, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s10, s8
; CHECK-MVE-NEXT:    csetm r2, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s2, s6
; CHECK-MVE-NEXT:    vmovx.f16 s2, s4
; CHECK-MVE-NEXT:    vmovx.f16 s6, s0
; CHECK-MVE-NEXT:    csetm r3, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s6, s2
; CHECK-MVE-NEXT:    csetm r0, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s1, s5
; CHECK-MVE-NEXT:    csetm r1, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    vcmp.f16 s0, s4
; CHECK-MVE-NEXT:    vmov.i16 q0, #0x1
; CHECK-MVE-NEXT:    csetm r4, ne
; CHECK-MVE-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-MVE-NEXT:    csetm r5, ne
; CHECK-MVE-NEXT:    vmov.16 q1[0], r5
; CHECK-MVE-NEXT:    vmov.16 q1[1], r1
; CHECK-MVE-NEXT:    vmov.16 q1[2], r4
; CHECK-MVE-NEXT:    vmov.16 q1[3], r3
; CHECK-MVE-NEXT:    vmov.16 q1[4], r0
; CHECK-MVE-NEXT:    vmov.16 q1[5], lr
; CHECK-MVE-NEXT:    vmov.16 q1[6], r2
; CHECK-MVE-NEXT:    vmov.16 q1[7], r12
; CHECK-MVE-NEXT:    vand q0, q1, q0
; CHECK-MVE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-MVEFP-LABEL: zext_v8i1_v8f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i16 q2, #0x0
; CHECK-MVEFP-NEXT:    vmov.i16 q3, #0x1
; CHECK-MVEFP-NEXT:    vcmp.f16 ne, q0, q1
; CHECK-MVEFP-NEXT:    vpsel q0, q3, q2
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = fcmp une <8 x half> %src1, %src2
  %0 = zext <8 x i1> %c to <8 x i16>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <16 x i8> @zext_v16i1_v16i8(<16 x i8> %src) {
; CHECK-LABEL: zext_v16i1_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q1, #0x0
; CHECK-NEXT:    vmov.i8 q2, #0x1
; CHECK-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-NEXT:    vpsel q0, q2, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp sgt <16 x i8> %src, zeroinitializer
  %0 = zext <16 x i1> %c to <16 x i8>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <2 x i64> @zext_v2i1_v2i64(<2 x i64> %src) {
; CHECK-LABEL: zext_v2i1_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    mov.w r12, #0
; CHECK-NEXT:    vmov r2, r3, d0
; CHECK-NEXT:    vldr s1, .LCPI12_0
; CHECK-NEXT:    vmov.f32 s3, s1
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    sbcs.w r0, r12, r1
; CHECK-NEXT:    cset r0, lt
; CHECK-NEXT:    rsbs r1, r2, #0
; CHECK-NEXT:    sbcs.w r1, r12, r3
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    cset r0, lt
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI12_0:
; CHECK-NEXT:    .long 0x00000000 @ float 0
entry:
  %c = icmp sgt <2 x i64> %src, zeroinitializer
  %0 = zext <2 x i1> %c to <2 x i64>
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <2 x i64> @zext_v2i1_v2f64(<2 x double> %src) {
; CHECK-MVE-LABEL: zext_v2i1_v2f64:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r4, r5, r6, lr}
; CHECK-MVE-NEXT:    push {r4, r5, r6, lr}
; CHECK-MVE-NEXT:    .vsave {d8, d9}
; CHECK-MVE-NEXT:    vpush {d8, d9}
; CHECK-MVE-NEXT:    vmov q4, q0
; CHECK-MVE-NEXT:    vldr d0, .LCPI13_0
; CHECK-MVE-NEXT:    vmov r0, r1, d9
; CHECK-MVE-NEXT:    vmov r4, r5, d0
; CHECK-MVE-NEXT:    mov r2, r4
; CHECK-MVE-NEXT:    mov r3, r5
; CHECK-MVE-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVE-NEXT:    vmov r2, r1, d8
; CHECK-MVE-NEXT:    adr r3, .LCPI13_1
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vldrw.u32 q4, [r3]
; CHECK-MVE-NEXT:    mov r3, r5
; CHECK-MVE-NEXT:    csetm r6, eq
; CHECK-MVE-NEXT:    mov r0, r2
; CHECK-MVE-NEXT:    mov r2, r4
; CHECK-MVE-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    csetm r0, eq
; CHECK-MVE-NEXT:    vmov q0[2], q0[0], r0, r6
; CHECK-MVE-NEXT:    vand q0, q0, q4
; CHECK-MVE-NEXT:    vpop {d8, d9}
; CHECK-MVE-NEXT:    pop {r4, r5, r6, pc}
; CHECK-MVE-NEXT:    .p2align 4
; CHECK-MVE-NEXT:  @ %bb.1:
; CHECK-MVE-NEXT:  .LCPI13_1:
; CHECK-MVE-NEXT:    .long 1 @ 0x1
; CHECK-MVE-NEXT:    .long 0 @ 0x0
; CHECK-MVE-NEXT:    .long 1 @ 0x1
; CHECK-MVE-NEXT:    .long 0 @ 0x0
; CHECK-MVE-NEXT:  .LCPI13_0:
; CHECK-MVE-NEXT:    .long 0 @ double 0
; CHECK-MVE-NEXT:    .long 0
;
; CHECK-MVEFP-LABEL: zext_v2i1_v2f64:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    .save {r4, r5, r6, lr}
; CHECK-MVEFP-NEXT:    push {r4, r5, r6, lr}
; CHECK-MVEFP-NEXT:    .vsave {d8, d9}
; CHECK-MVEFP-NEXT:    vpush {d8, d9}
; CHECK-MVEFP-NEXT:    vmov q4, q0
; CHECK-MVEFP-NEXT:    vldr d0, .LCPI13_0
; CHECK-MVEFP-NEXT:    vmov r0, r1, d8
; CHECK-MVEFP-NEXT:    vmov r4, r5, d0
; CHECK-MVEFP-NEXT:    mov r2, r4
; CHECK-MVEFP-NEXT:    mov r3, r5
; CHECK-MVEFP-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVEFP-NEXT:    mov r6, r0
; CHECK-MVEFP-NEXT:    vmov r0, r1, d9
; CHECK-MVEFP-NEXT:    mov r2, r4
; CHECK-MVEFP-NEXT:    mov r3, r5
; CHECK-MVEFP-NEXT:    bl __aeabi_dcmpeq
; CHECK-MVEFP-NEXT:    cmp r0, #0
; CHECK-MVEFP-NEXT:    vldr s1, .LCPI13_1
; CHECK-MVEFP-NEXT:    cset r0, eq
; CHECK-MVEFP-NEXT:    cmp r6, #0
; CHECK-MVEFP-NEXT:    vmov s2, r0
; CHECK-MVEFP-NEXT:    cset r0, eq
; CHECK-MVEFP-NEXT:    vmov s0, r0
; CHECK-MVEFP-NEXT:    vmov.f32 s3, s1
; CHECK-MVEFP-NEXT:    vpop {d8, d9}
; CHECK-MVEFP-NEXT:    pop {r4, r5, r6, pc}
; CHECK-MVEFP-NEXT:    .p2align 3
; CHECK-MVEFP-NEXT:  @ %bb.1:
; CHECK-MVEFP-NEXT:  .LCPI13_0:
; CHECK-MVEFP-NEXT:    .long 0 @ double 0
; CHECK-MVEFP-NEXT:    .long 0
; CHECK-MVEFP-NEXT:  .LCPI13_1:
; CHECK-MVEFP-NEXT:    .long 0x00000000 @ float 0
entry:
  %c = fcmp une <2 x double> %src, zeroinitializer
  %0 = zext <2 x i1> %c to <2 x i64>
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <4 x i32> @trunc_v4i1_v4i32(<4 x i32> %src) {
; CHECK-LABEL: trunc_v4i1_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q2, #0x1
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vand q2, q0, q2
; CHECK-NEXT:    vcmp.i32 ne, q2, zr
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <4 x i32> %src to <4 x i1>
  %1 = select <4 x i1> %0, <4 x i32> %src, <4 x i32> zeroinitializer
  ret <4 x i32> %1
}

define arm_aapcs_vfpcc <8 x i16> @trunc_v8i1_v8i16(<8 x i16> %src) {
; CHECK-LABEL: trunc_v8i1_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i16 q2, #0x1
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vand q2, q0, q2
; CHECK-NEXT:    vcmp.i16 ne, q2, zr
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <8 x i16> %src to <8 x i1>
  %1 = select <8 x i1> %0, <8 x i16> %src, <8 x i16> zeroinitializer
  ret <8 x i16> %1
}

define arm_aapcs_vfpcc <16 x i8> @trunc_v16i1_v16i8(<16 x i8> %src) {
; CHECK-LABEL: trunc_v16i1_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 q2, #0x1
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vand q2, q0, q2
; CHECK-NEXT:    vcmp.i8 ne, q2, zr
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <16 x i8> %src to <16 x i1>
  %1 = select <16 x i1> %0, <16 x i8> %src, <16 x i8> zeroinitializer
  ret <16 x i8> %1
}

define arm_aapcs_vfpcc <2 x i64> @trunc_v2i1_v2i64(<2 x i64> %src) {
; CHECK-LABEL: trunc_v2i1_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    and r1, r1, #1
; CHECK-NEXT:    rsbs r1, r1, #0
; CHECK-NEXT:    bfi r0, r1, #0, #8
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    and r1, r1, #1
; CHECK-NEXT:    rsbs r1, r1, #0
; CHECK-NEXT:    bfi r0, r1, #8, #8
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <2 x i64> %src to <2 x i1>
  %1 = select <2 x i1> %0, <2 x i64> %src, <2 x i64> zeroinitializer
  ret <2 x i64> %1
}


define arm_aapcs_vfpcc <4 x float> @uitofp_v4i1_v4f32(<4 x i32> %src) {
; CHECK-MVE-LABEL: uitofp_v4i1_v4f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-MVE-NEXT:    vmrs r0, p0
; CHECK-MVE-NEXT:    ubfx r2, r0, #12, #1
; CHECK-MVE-NEXT:    ubfx r1, r0, #8, #1
; CHECK-MVE-NEXT:    vmov s0, r2
; CHECK-MVE-NEXT:    ubfx r2, r0, #4, #1
; CHECK-MVE-NEXT:    and r0, r0, #1
; CHECK-MVE-NEXT:    vcvt.f32.u32 s3, s0
; CHECK-MVE-NEXT:    vmov s0, r1
; CHECK-MVE-NEXT:    vcvt.f32.u32 s2, s0
; CHECK-MVE-NEXT:    vmov s0, r2
; CHECK-MVE-NEXT:    vcvt.f32.u32 s1, s0
; CHECK-MVE-NEXT:    vmov s0, r0
; CHECK-MVE-NEXT:    vcvt.f32.u32 s0, s0
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: uitofp_v4i1_v4f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.f32 q2, #1.000000e+00
; CHECK-MVEFP-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %src, zeroinitializer
  %0 = uitofp <4 x i1> %c to <4 x float>
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <4 x float> @sitofp_v4i1_v4f32(<4 x i32> %src) {
; CHECK-MVE-LABEL: sitofp_v4i1_v4f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-MVE-NEXT:    vmrs r0, p0
; CHECK-MVE-NEXT:    and r1, r0, #1
; CHECK-MVE-NEXT:    ubfx r2, r0, #8, #1
; CHECK-MVE-NEXT:    ubfx r3, r0, #4, #1
; CHECK-MVE-NEXT:    ubfx r0, r0, #12, #1
; CHECK-MVE-NEXT:    rsbs r2, r2, #0
; CHECK-MVE-NEXT:    rsbs r0, r0, #0
; CHECK-MVE-NEXT:    vmov s0, r0
; CHECK-MVE-NEXT:    rsbs r0, r3, #0
; CHECK-MVE-NEXT:    vcvt.f32.s32 s3, s0
; CHECK-MVE-NEXT:    vmov s0, r2
; CHECK-MVE-NEXT:    vcvt.f32.s32 s2, s0
; CHECK-MVE-NEXT:    vmov s0, r0
; CHECK-MVE-NEXT:    rsbs r0, r1, #0
; CHECK-MVE-NEXT:    vcvt.f32.s32 s1, s0
; CHECK-MVE-NEXT:    vmov s0, r0
; CHECK-MVE-NEXT:    vcvt.f32.s32 s0, s0
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: sitofp_v4i1_v4f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.f32 q2, #-1.000000e+00
; CHECK-MVEFP-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %src, zeroinitializer
  %0 = sitofp <4 x i1> %c to <4 x float>
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <4 x float> @fptoui_v4i1_v4f32(<4 x float> %src) {
; CHECK-MVE-LABEL: fptoui_v4i1_v4f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcvt.s32.f32 s6, s3
; CHECK-MVE-NEXT:    vldr s8, .LCPI20_0
; CHECK-MVE-NEXT:    vcvt.s32.f32 s2, s2
; CHECK-MVE-NEXT:    vcvt.s32.f32 s10, s1
; CHECK-MVE-NEXT:    vmov.f32 s4, #1.000000e+00
; CHECK-MVE-NEXT:    vcvt.s32.f32 s0, s0
; CHECK-MVE-NEXT:    vmov r0, s6
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s2
; CHECK-MVE-NEXT:    vseleq.f32 s3, s8, s4
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s10
; CHECK-MVE-NEXT:    vseleq.f32 s2, s8, s4
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vseleq.f32 s1, s8, s4
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vseleq.f32 s0, s8, s4
; CHECK-MVE-NEXT:    bx lr
; CHECK-MVE-NEXT:    .p2align 2
; CHECK-MVE-NEXT:  @ %bb.1:
; CHECK-MVE-NEXT:  .LCPI20_0:
; CHECK-MVE-NEXT:    .long 0x00000000 @ float 0
;
; CHECK-MVEFP-LABEL: fptoui_v4i1_v4f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.f32 q2, #1.000000e+00
; CHECK-MVEFP-NEXT:    vcmp.f32 ne, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fptoui <4 x float> %src to <4 x i1>
  %s = select <4 x i1> %0, <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>, <4 x float> zeroinitializer
  ret <4 x float> %s
}

define arm_aapcs_vfpcc <4 x float> @fptosi_v4i1_v4f32(<4 x float> %src) {
; CHECK-MVE-LABEL: fptosi_v4i1_v4f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcvt.s32.f32 s8, s3
; CHECK-MVE-NEXT:    vldr s10, .LCPI21_0
; CHECK-MVE-NEXT:    vcvt.s32.f32 s2, s2
; CHECK-MVE-NEXT:    vcvt.s32.f32 s6, s1
; CHECK-MVE-NEXT:    vmov.f32 s4, #1.000000e+00
; CHECK-MVE-NEXT:    vcvt.s32.f32 s0, s0
; CHECK-MVE-NEXT:    vmov r0, s8
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s2
; CHECK-MVE-NEXT:    vseleq.f32 s3, s10, s4
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s6
; CHECK-MVE-NEXT:    vseleq.f32 s2, s10, s4
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vseleq.f32 s1, s10, s4
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vseleq.f32 s0, s10, s4
; CHECK-MVE-NEXT:    bx lr
; CHECK-MVE-NEXT:    .p2align 2
; CHECK-MVE-NEXT:  @ %bb.1:
; CHECK-MVE-NEXT:  .LCPI21_0:
; CHECK-MVE-NEXT:    .long 0x00000000 @ float 0
;
; CHECK-MVEFP-LABEL: fptosi_v4i1_v4f32:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.f32 q2, #1.000000e+00
; CHECK-MVEFP-NEXT:    vcmp.f32 ne, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fptosi <4 x float> %src to <4 x i1>
  %s = select <4 x i1> %0, <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>, <4 x float> zeroinitializer
  ret <4 x float> %s
}

define arm_aapcs_vfpcc <8 x half> @uitofp_v8i1_v8f16(<8 x i16> %src) {
; CHECK-MVE-LABEL: uitofp_v8i1_v8f16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-MVE-NEXT:    vmrs r0, p0
; CHECK-MVE-NEXT:    and r1, r0, #1
; CHECK-MVE-NEXT:    ubfx r2, r0, #2, #1
; CHECK-MVE-NEXT:    vmov s0, r1
; CHECK-MVE-NEXT:    ubfx r1, r0, #4, #1
; CHECK-MVE-NEXT:    vmov s2, r2
; CHECK-MVE-NEXT:    ubfx r2, r0, #6, #1
; CHECK-MVE-NEXT:    vcvt.f16.u32 s2, s2
; CHECK-MVE-NEXT:    vcvt.f16.u32 s0, s0
; CHECK-MVE-NEXT:    vmov s4, r2
; CHECK-MVE-NEXT:    vins.f16 s0, s2
; CHECK-MVE-NEXT:    vmov s2, r1
; CHECK-MVE-NEXT:    ubfx r1, r0, #8, #1
; CHECK-MVE-NEXT:    ubfx r2, r0, #10, #1
; CHECK-MVE-NEXT:    vcvt.f16.u32 s1, s2
; CHECK-MVE-NEXT:    vcvt.f16.u32 s4, s4
; CHECK-MVE-NEXT:    vmov s2, r1
; CHECK-MVE-NEXT:    ubfx r1, r0, #12, #1
; CHECK-MVE-NEXT:    vins.f16 s1, s4
; CHECK-MVE-NEXT:    vmov s4, r2
; CHECK-MVE-NEXT:    ubfx r0, r0, #14, #1
; CHECK-MVE-NEXT:    vcvt.f16.u32 s4, s4
; CHECK-MVE-NEXT:    vcvt.f16.u32 s2, s2
; CHECK-MVE-NEXT:    vins.f16 s2, s4
; CHECK-MVE-NEXT:    vmov s4, r0
; CHECK-MVE-NEXT:    vmov s6, r1
; CHECK-MVE-NEXT:    vcvt.f16.u32 s4, s4
; CHECK-MVE-NEXT:    vcvt.f16.u32 s3, s6
; CHECK-MVE-NEXT:    vins.f16 s3, s4
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: uitofp_v8i1_v8f16:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i16 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.i16 q2, #0x3c00
; CHECK-MVEFP-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %src, zeroinitializer
  %0 = uitofp <8 x i1> %c to <8 x half>
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <8 x half> @sitofp_v8i1_v8f16(<8 x i16> %src) {
; CHECK-MVE-LABEL: sitofp_v8i1_v8f16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-MVE-NEXT:    vmrs r0, p0
; CHECK-MVE-NEXT:    and r1, r0, #1
; CHECK-MVE-NEXT:    ubfx r2, r0, #2, #1
; CHECK-MVE-NEXT:    rsbs r1, r1, #0
; CHECK-MVE-NEXT:    rsbs r2, r2, #0
; CHECK-MVE-NEXT:    vmov s0, r2
; CHECK-MVE-NEXT:    ubfx r2, r0, #6, #1
; CHECK-MVE-NEXT:    vcvt.f16.s32 s2, s0
; CHECK-MVE-NEXT:    vmov s0, r1
; CHECK-MVE-NEXT:    ubfx r1, r0, #4, #1
; CHECK-MVE-NEXT:    rsbs r2, r2, #0
; CHECK-MVE-NEXT:    vcvt.f16.s32 s0, s0
; CHECK-MVE-NEXT:    rsbs r1, r1, #0
; CHECK-MVE-NEXT:    vins.f16 s0, s2
; CHECK-MVE-NEXT:    vmov s2, r2
; CHECK-MVE-NEXT:    ubfx r2, r0, #10, #1
; CHECK-MVE-NEXT:    vmov s4, r1
; CHECK-MVE-NEXT:    ubfx r1, r0, #8, #1
; CHECK-MVE-NEXT:    rsbs r2, r2, #0
; CHECK-MVE-NEXT:    vcvt.f16.s32 s2, s2
; CHECK-MVE-NEXT:    vcvt.f16.s32 s1, s4
; CHECK-MVE-NEXT:    rsbs r1, r1, #0
; CHECK-MVE-NEXT:    vins.f16 s1, s2
; CHECK-MVE-NEXT:    vmov s2, r2
; CHECK-MVE-NEXT:    vcvt.f16.s32 s4, s2
; CHECK-MVE-NEXT:    vmov s2, r1
; CHECK-MVE-NEXT:    ubfx r1, r0, #12, #1
; CHECK-MVE-NEXT:    ubfx r0, r0, #14, #1
; CHECK-MVE-NEXT:    rsbs r1, r1, #0
; CHECK-MVE-NEXT:    rsbs r0, r0, #0
; CHECK-MVE-NEXT:    vcvt.f16.s32 s2, s2
; CHECK-MVE-NEXT:    vins.f16 s2, s4
; CHECK-MVE-NEXT:    vmov s4, r0
; CHECK-MVE-NEXT:    vmov s6, r1
; CHECK-MVE-NEXT:    vcvt.f16.s32 s4, s4
; CHECK-MVE-NEXT:    vcvt.f16.s32 s3, s6
; CHECK-MVE-NEXT:    vins.f16 s3, s4
; CHECK-MVE-NEXT:    bx lr
;
; CHECK-MVEFP-LABEL: sitofp_v8i1_v8f16:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i16 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.i16 q2, #0xbc00
; CHECK-MVEFP-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %src, zeroinitializer
  %0 = sitofp <8 x i1> %c to <8 x half>
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <8 x half> @fptoui_v8i1_v8f16(<8 x half> %src) {
; CHECK-MVE-LABEL: fptoui_v8i1_v8f16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s0
; CHECK-MVE-NEXT:    vmovx.f16 s0, s0
; CHECK-MVE-NEXT:    vcvt.s32.f16 s0, s0
; CHECK-MVE-NEXT:    vldr.16 s8, .LCPI24_0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.f16 s6, #1.000000e+00
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s1
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vseleq.f16 s0, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s0, s10
; CHECK-MVE-NEXT:    vmovx.f16 s10, s1
; CHECK-MVE-NEXT:    vcvt.s32.f16 s10, s10
; CHECK-MVE-NEXT:    vmov r0, s10
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s2
; CHECK-MVE-NEXT:    vmovx.f16 s2, s2
; CHECK-MVE-NEXT:    vcvt.s32.f16 s2, s2
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s2
; CHECK-MVE-NEXT:    vseleq.f16 s1, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s1, s10
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s3
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vseleq.f16 s2, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s2, s10
; CHECK-MVE-NEXT:    vmovx.f16 s10, s3
; CHECK-MVE-NEXT:    vcvt.s32.f16 s10, s10
; CHECK-MVE-NEXT:    vmov r0, s10
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    cmp r0, #0
; CHECK-MVE-NEXT:    vseleq.f16 s3, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s3, s10
; CHECK-MVE-NEXT:    bx lr
; CHECK-MVE-NEXT:    .p2align 1
; CHECK-MVE-NEXT:  @ %bb.1:
; CHECK-MVE-NEXT:  .LCPI24_0:
; CHECK-MVE-NEXT:    .short 0x0000 @ half 0
;
; CHECK-MVEFP-LABEL: fptoui_v8i1_v8f16:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.i16 q2, #0x3c00
; CHECK-MVEFP-NEXT:    vcmp.f16 ne, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fptoui <8 x half> %src to <8 x i1>
  %s = select <8 x i1> %0, <8 x half> <half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0>, <8 x half> zeroinitializer
  ret <8 x half> %s
}

define arm_aapcs_vfpcc <8 x half> @fptosi_v8i1_v8f16(<8 x half> %src) {
; CHECK-MVE-LABEL: fptosi_v8i1_v8f16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s0
; CHECK-MVE-NEXT:    vmovx.f16 s0, s0
; CHECK-MVE-NEXT:    vcvt.s32.f16 s0, s0
; CHECK-MVE-NEXT:    vldr.16 s8, .LCPI25_0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.f16 s6, #1.000000e+00
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s1
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vseleq.f16 s0, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s0, s10
; CHECK-MVE-NEXT:    vmovx.f16 s10, s1
; CHECK-MVE-NEXT:    vcvt.s32.f16 s10, s10
; CHECK-MVE-NEXT:    vmov r0, s10
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s2
; CHECK-MVE-NEXT:    vmovx.f16 s2, s2
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    vcvt.s32.f16 s2, s2
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s2
; CHECK-MVE-NEXT:    vseleq.f16 s1, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s1, s10
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    vcvt.s32.f16 s4, s3
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vseleq.f16 s2, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s2, s10
; CHECK-MVE-NEXT:    vmovx.f16 s10, s3
; CHECK-MVE-NEXT:    vcvt.s32.f16 s10, s10
; CHECK-MVE-NEXT:    vmov r0, s10
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vmov r0, s4
; CHECK-MVE-NEXT:    vseleq.f16 s10, s8, s6
; CHECK-MVE-NEXT:    lsls r0, r0, #31
; CHECK-MVE-NEXT:    vseleq.f16 s3, s8, s6
; CHECK-MVE-NEXT:    vins.f16 s3, s10
; CHECK-MVE-NEXT:    bx lr
; CHECK-MVE-NEXT:    .p2align 1
; CHECK-MVE-NEXT:  @ %bb.1:
; CHECK-MVE-NEXT:  .LCPI25_0:
; CHECK-MVE-NEXT:    .short 0x0000 @ half 0
;
; CHECK-MVEFP-LABEL: fptosi_v8i1_v8f16:
; CHECK-MVEFP:       @ %bb.0: @ %entry
; CHECK-MVEFP-NEXT:    vmov.i32 q1, #0x0
; CHECK-MVEFP-NEXT:    vmov.i16 q2, #0x3c00
; CHECK-MVEFP-NEXT:    vcmp.f16 ne, q0, zr
; CHECK-MVEFP-NEXT:    vpsel q0, q2, q1
; CHECK-MVEFP-NEXT:    bx lr
entry:
  %0 = fptosi <8 x half> %src to <8 x i1>
  %s = select <8 x i1> %0, <8 x half> <half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0>, <8 x half> zeroinitializer
  ret <8 x half> %s
}


define arm_aapcs_vfpcc <2 x double> @uitofp_v2i1_v2f64(<2 x i64> %src) {
; CHECK-LABEL: uitofp_v2i1_v2f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov q4, q0
; CHECK-NEXT:    movs r4, #0
; CHECK-NEXT:    vmov r0, r1, d9
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    sbcs.w r0, r4, r1
; CHECK-NEXT:    cset r0, lt
; CHECK-NEXT:    bl __aeabi_ui2d
; CHECK-NEXT:    vmov r2, r3, d8
; CHECK-NEXT:    vmov d9, r0, r1
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sbcs.w r2, r4, r3
; CHECK-NEXT:    cset r2, lt
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    bl __aeabi_ui2d
; CHECK-NEXT:    vmov d8, r0, r1
; CHECK-NEXT:    vmov q0, q4
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    pop {r4, pc}
entry:
  %c = icmp sgt <2 x i64> %src, zeroinitializer
  %0 = uitofp <2 x i1> %c to <2 x double>
  ret <2 x double> %0
}

define arm_aapcs_vfpcc <2 x double> @sitofp_v2i1_v2f64(<2 x i64> %src) {
; CHECK-LABEL: sitofp_v2i1_v2f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov q4, q0
; CHECK-NEXT:    movs r4, #0
; CHECK-NEXT:    vmov r0, r1, d9
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    sbcs.w r0, r4, r1
; CHECK-NEXT:    csetm r0, lt
; CHECK-NEXT:    bl __aeabi_i2d
; CHECK-NEXT:    vmov r2, r3, d8
; CHECK-NEXT:    vmov d9, r0, r1
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sbcs.w r2, r4, r3
; CHECK-NEXT:    csetm r2, lt
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    bl __aeabi_i2d
; CHECK-NEXT:    vmov d8, r0, r1
; CHECK-NEXT:    vmov q0, q4
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    pop {r4, pc}
entry:
  %c = icmp sgt <2 x i64> %src, zeroinitializer
  %0 = sitofp <2 x i1> %c to <2 x double>
  ret <2 x double> %0
}

define arm_aapcs_vfpcc <2 x double> @fptoui_v2i1_v2f64(<2 x double> %src) {
; CHECK-LABEL: fptoui_v2i1_v2f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov q4, q0
; CHECK-NEXT:    vmov r0, r1, d8
; CHECK-NEXT:    bl __aeabi_d2iz
; CHECK-NEXT:    vmov r2, r1, d9
; CHECK-NEXT:    movs r4, #0
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    adr r3, .LCPI28_0
; CHECK-NEXT:    bfi r4, r0, #0, #8
; CHECK-NEXT:    vmov.i32 q4, #0x0
; CHECK-NEXT:    vldrw.u32 q5, [r3]
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    bl __aeabi_d2iz
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    bfi r4, r0, #8, #8
; CHECK-NEXT:    vmsr p0, r4
; CHECK-NEXT:    vpsel q0, q5, q4
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    pop {r4, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI28_0:
; CHECK-NEXT:    .long 0 @ double 1
; CHECK-NEXT:    .long 1072693248
; CHECK-NEXT:    .long 0 @ double 1
; CHECK-NEXT:    .long 1072693248
entry:
  %0 = fptoui <2 x double> %src to <2 x i1>
  %s = select <2 x i1> %0, <2 x double> <double 1.0, double 1.0>, <2 x double> zeroinitializer
  ret <2 x double> %s
}

define arm_aapcs_vfpcc <2 x double> @fptosi_v2i1_v2f64(<2 x double> %src) {
; CHECK-LABEL: fptosi_v2i1_v2f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov q4, q0
; CHECK-NEXT:    vmov r0, r1, d8
; CHECK-NEXT:    bl __aeabi_d2iz
; CHECK-NEXT:    vmov r2, r1, d9
; CHECK-NEXT:    movs r4, #0
; CHECK-NEXT:    adr r3, .LCPI29_0
; CHECK-NEXT:    bfi r4, r0, #0, #8
; CHECK-NEXT:    vmov.i32 q4, #0x0
; CHECK-NEXT:    vldrw.u32 q5, [r3]
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    bl __aeabi_d2iz
; CHECK-NEXT:    bfi r4, r0, #8, #8
; CHECK-NEXT:    vmsr p0, r4
; CHECK-NEXT:    vpsel q0, q5, q4
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    pop {r4, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI29_0:
; CHECK-NEXT:    .long 0 @ double 1
; CHECK-NEXT:    .long 1072693248
; CHECK-NEXT:    .long 0 @ double 1
; CHECK-NEXT:    .long 1072693248
entry:
  %0 = fptosi <2 x double> %src to <2 x i1>
  %s = select <2 x i1> %0, <2 x double> <double 1.0, double 1.0>, <2 x double> zeroinitializer
  ret <2 x double> %s
}
