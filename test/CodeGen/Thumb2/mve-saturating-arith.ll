; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @sadd_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: sadd_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @sadd_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: sadd_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @sadd_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: sadd_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @sadd_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: sadd_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vmov r0, r2, d2
; CHECK-NEXT:    vmov r3, r1, d0
; CHECK-NEXT:    adds.w r12, r3, r0
; CHECK-NEXT:    vmov r0, r4, d1
; CHECK-NEXT:    adc.w lr, r1, r2
; CHECK-NEXT:    subs.w r3, r12, r3
; CHECK-NEXT:    sbcs.w r1, lr, r1
; CHECK-NEXT:    cset r1, lt
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    cset r1, ne
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    cset r2, mi
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    it ne
; CHECK-NEXT:    eorne r1, r1, #1
; CHECK-NEXT:    rsbs r1, r1, #0
; CHECK-NEXT:    movs r2, #0
; CHECK-NEXT:    bfi r2, r1, #0, #8
; CHECK-NEXT:    vmov r1, r3, d3
; CHECK-NEXT:    adds r1, r1, r0
; CHECK-NEXT:    adc.w r5, r4, r3
; CHECK-NEXT:    subs r0, r1, r0
; CHECK-NEXT:    sbcs.w r0, r5, r4
; CHECK-NEXT:    vmov q0[2], q0[0], r12, r1
; CHECK-NEXT:    cset r0, lt
; CHECK-NEXT:    asr.w r1, lr, #31
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    vmov q0[3], q0[1], lr, r5
; CHECK-NEXT:    cset r0, ne
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    cset r3, mi
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    it ne
; CHECK-NEXT:    eorne r0, r0, #1
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    bfi r2, r0, #8, #8
; CHECK-NEXT:    asrs r0, r5, #31
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmsr p0, r2
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    adr r0, .LCPI3_0
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    veor q1, q1, q2
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI3_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
entry:
  %0 = call <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <16 x i8> @uadd_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: uadd_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @uadd_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: uadd_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @uadd_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: uadd_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @uadd_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: uadd_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    adds.w lr, r2, r0
; CHECK-NEXT:    vmov r0, r4, d0
; CHECK-NEXT:    adc.w r12, r3, r1
; CHECK-NEXT:    subs.w r2, lr, r2
; CHECK-NEXT:    sbcs.w r2, r12, r3
; CHECK-NEXT:    vmov r3, r1, d2
; CHECK-NEXT:    cset r2, lo
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    csetm r2, ne
; CHECK-NEXT:    adds r3, r3, r0
; CHECK-NEXT:    adcs r1, r4
; CHECK-NEXT:    subs r0, r3, r0
; CHECK-NEXT:    sbcs.w r0, r1, r4
; CHECK-NEXT:    vmov q1[2], q1[0], r3, lr
; CHECK-NEXT:    cset r0, lo
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r12
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmov q0[2], q0[0], r0, r2
; CHECK-NEXT:    vmov q0[3], q0[1], r0, r2
; CHECK-NEXT:    vorr q0, q1, q0
; CHECK-NEXT:    pop {r4, pc}
entry:
  %0 = call <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @ssub_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: ssub_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqsub.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @ssub_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: ssub_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqsub.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @ssub_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: ssub_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqsub.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @ssub_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: ssub_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vmov r1, r3, d2
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    rsbs r2, r1, #0
; CHECK-NEXT:    sbcs.w r2, r0, r3
; CHECK-NEXT:    vmov r2, r4, d0
; CHECK-NEXT:    cset lr, lt
; CHECK-NEXT:    subs.w r12, r2, r1
; CHECK-NEXT:    sbc.w r5, r4, r3
; CHECK-NEXT:    subs.w r2, r12, r2
; CHECK-NEXT:    sbcs.w r2, r5, r4
; CHECK-NEXT:    vmov r3, r4, d3
; CHECK-NEXT:    cset r2, lt
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    cset r2, ne
; CHECK-NEXT:    cmp.w lr, #0
; CHECK-NEXT:    it ne
; CHECK-NEXT:    eorne r2, r2, #1
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    rsbs r1, r3, #0
; CHECK-NEXT:    sbcs.w r1, r0, r4
; CHECK-NEXT:    bfi r0, r2, #0, #8
; CHECK-NEXT:    vmov r2, r1, d1
; CHECK-NEXT:    cset lr, lt
; CHECK-NEXT:    subs r3, r2, r3
; CHECK-NEXT:    sbc.w r4, r1, r4
; CHECK-NEXT:    subs r2, r3, r2
; CHECK-NEXT:    sbcs.w r1, r4, r1
; CHECK-NEXT:    vmov q0[2], q0[0], r12, r3
; CHECK-NEXT:    cset r1, lt
; CHECK-NEXT:    vmov q0[3], q0[1], r5, r4
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    cset r1, ne
; CHECK-NEXT:    cmp.w lr, #0
; CHECK-NEXT:    it ne
; CHECK-NEXT:    eorne r1, r1, #1
; CHECK-NEXT:    rsbs r1, r1, #0
; CHECK-NEXT:    bfi r0, r1, #8, #8
; CHECK-NEXT:    asrs r1, r5, #31
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    asrs r0, r4, #31
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    adr r0, .LCPI11_0
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    veor q1, q1, q2
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI11_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
entry:
  %0 = call <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <16 x i8> @usub_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: usub_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqsub.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @usub_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: usub_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqsub.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @usub_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: usub_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqsub.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @usub_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: usub_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    subs.w lr, r2, r0
; CHECK-NEXT:    vmov r0, r4, d0
; CHECK-NEXT:    sbc.w r12, r3, r1
; CHECK-NEXT:    subs.w r2, r2, lr
; CHECK-NEXT:    sbcs.w r2, r3, r12
; CHECK-NEXT:    vmov r3, r1, d2
; CHECK-NEXT:    cset r2, lo
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    csetm r2, ne
; CHECK-NEXT:    subs r3, r0, r3
; CHECK-NEXT:    sbc.w r1, r4, r1
; CHECK-NEXT:    subs r0, r0, r3
; CHECK-NEXT:    sbcs.w r0, r4, r1
; CHECK-NEXT:    vmov q1[2], q1[0], r3, lr
; CHECK-NEXT:    cset r0, lo
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r12
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmov q0[2], q0[0], r0, r2
; CHECK-NEXT:    vmov q0[3], q0[1], r0, r2
; CHECK-NEXT:    vbic q0, q1, q0
; CHECK-NEXT:    pop {r4, pc}
entry:
  %0 = call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}


declare <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
declare <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
declare <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
declare <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
