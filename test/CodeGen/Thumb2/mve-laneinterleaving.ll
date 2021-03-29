; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc <4 x i32> @sext_trunc_i32(<4 x i32> %a) {
; CHECK-LABEL: sext_trunc_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <4 x i32> %a to <4 x i64>
  %t = trunc <4 x i64> %sa to <4 x i32>
  ret <4 x i32> %t
}

define arm_aapcs_vfpcc <8 x i16> @sext_trunc_i16(<8 x i16> %a) {
; CHECK-LABEL: sext_trunc_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <8 x i16> %a to <8 x i32>
  %t = trunc <8 x i32> %sa to <8 x i16>
  ret <8 x i16> %t
}

define arm_aapcs_vfpcc <16 x i8> @sext_trunc_i8(<16 x i8> %a) {
; CHECK-LABEL: sext_trunc_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <16 x i8> %a to <16 x i16>
  %t = trunc <16 x i16> %sa to <16 x i8>
  ret <16 x i8> %t
}

define arm_aapcs_vfpcc <4 x i32> @zext_trunc_i32(<4 x i32> %a) {
; CHECK-LABEL: zext_trunc_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %sa = zext <4 x i32> %a to <4 x i64>
  %t = trunc <4 x i64> %sa to <4 x i32>
  ret <4 x i32> %t
}

define arm_aapcs_vfpcc <8 x i16> @zext_trunc_i16(<8 x i16> %a) {
; CHECK-LABEL: zext_trunc_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %sa = zext <8 x i16> %a to <8 x i32>
  %t = trunc <8 x i32> %sa to <8 x i16>
  ret <8 x i16> %t
}

define arm_aapcs_vfpcc <16 x i8> @zext_trunc_i8(<16 x i8> %a) {
; CHECK-LABEL: zext_trunc_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %sa = zext <16 x i8> %a to <16 x i16>
  %t = trunc <16 x i16> %sa to <16 x i8>
  ret <16 x i8> %t
}

define arm_aapcs_vfpcc <4 x i32> @ext_add_trunc_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: ext_add_trunc_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s8, s6
; CHECK-NEXT:    vmov.f32 s12, s2
; CHECK-NEXT:    vmov.f32 s14, s3
; CHECK-NEXT:    vmov.f32 s10, s7
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov r1, s12
; CHECK-NEXT:    vmov.f32 s2, s1
; CHECK-NEXT:    vmov.f32 s6, s5
; CHECK-NEXT:    vmov r2, s14
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    add.w r12, r1, r0
; CHECK-NEXT:    vmov r1, s10
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    add r1, r2
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    add r2, r3
; CHECK-NEXT:    vmov r3, s4
; CHECK-NEXT:    add r0, r3
; CHECK-NEXT:    vmov q0[2], q0[0], r0, r12
; CHECK-NEXT:    vmov q0[3], q0[1], r2, r1
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <4 x i32> %a to <4 x i64>
  %sb = zext <4 x i32> %b to <4 x i64>
  %add = add <4 x i64> %sa, %sb
  %t = trunc <4 x i64> %add to <4 x i32>
  ret <4 x i32> %t
}

define arm_aapcs_vfpcc <8 x i16> @ext_add_trunc_v8i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: ext_add_trunc_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev32.16 q3, q0
; CHECK-NEXT:    vrev32.16 q2, q1
; CHECK-NEXT:    vadd.i32 q2, q3, q2
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmovnt.i32 q0, q2
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <8 x i16> %a to <8 x i32>
  %sb = zext <8 x i16> %b to <8 x i32>
  %add = add <8 x i32> %sa, %sb
  %t = trunc <8 x i32> %add to <8 x i16>
  ret <8 x i16> %t
}

define arm_aapcs_vfpcc <16 x i8> @ext_add_trunc_v16i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: ext_add_trunc_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev16.8 q3, q0
; CHECK-NEXT:    vrev16.8 q2, q1
; CHECK-NEXT:    vadd.i16 q2, q3, q2
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmovnt.i16 q0, q2
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <16 x i8> %a to <16 x i16>
  %sb = zext <16 x i8> %b to <16 x i16>
  %add = add <16 x i16> %sa, %sb
  %t = trunc <16 x i16> %add to <16 x i8>
  ret <16 x i8> %t
}

define arm_aapcs_vfpcc <16 x i16> @ext_add_trunc_v16i16(<16 x i16> %a, <16 x i16> %b) {
; CHECK-LABEL: ext_add_trunc_v16i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vrev32.16 q5, q0
; CHECK-NEXT:    vrev32.16 q4, q2
; CHECK-NEXT:    vadd.i32 q0, q0, q2
; CHECK-NEXT:    vadd.i32 q4, q5, q4
; CHECK-NEXT:    vmovnt.i32 q0, q4
; CHECK-NEXT:    vrev32.16 q4, q1
; CHECK-NEXT:    vrev32.16 q2, q3
; CHECK-NEXT:    vadd.i32 q1, q1, q3
; CHECK-NEXT:    vadd.i32 q2, q4, q2
; CHECK-NEXT:    vmovnt.i32 q1, q2
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <16 x i16> %a to <16 x i32>
  %sb = zext <16 x i16> %b to <16 x i32>
  %add = add <16 x i32> %sa, %sb
  %t = trunc <16 x i32> %add to <16 x i16>
  ret <16 x i16> %t
}

define arm_aapcs_vfpcc <32 x i8> @ext_add_trunc_v32i8(<32 x i8> %a, <32 x i8> %b) {
; CHECK-LABEL: ext_add_trunc_v32i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vrev16.8 q5, q0
; CHECK-NEXT:    vrev16.8 q4, q2
; CHECK-NEXT:    vadd.i16 q0, q0, q2
; CHECK-NEXT:    vadd.i16 q4, q5, q4
; CHECK-NEXT:    vmovnt.i16 q0, q4
; CHECK-NEXT:    vrev16.8 q4, q1
; CHECK-NEXT:    vrev16.8 q2, q3
; CHECK-NEXT:    vadd.i16 q1, q1, q3
; CHECK-NEXT:    vadd.i16 q2, q4, q2
; CHECK-NEXT:    vmovnt.i16 q1, q2
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <32 x i8> %a to <32 x i16>
  %sb = zext <32 x i8> %b to <32 x i16>
  %add = add <32 x i16> %sa, %sb
  %t = trunc <32 x i16> %add to <32 x i8>
  ret <32 x i8> %t
}

define arm_aapcs_vfpcc <4 x i32> @ext_add_ashr_trunc_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: ext_add_ashr_trunc_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov.f32 s16, s6
; CHECK-NEXT:    vmov.i64 q3, #0xffffffff
; CHECK-NEXT:    vmov.f32 s18, s7
; CHECK-NEXT:    vmov.f32 s8, s2
; CHECK-NEXT:    vand q4, q4, q3
; CHECK-NEXT:    vmov.f32 s10, s3
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov r3, s16
; CHECK-NEXT:    vmov r2, s17
; CHECK-NEXT:    vmov.f32 s6, s5
; CHECK-NEXT:    vand q3, q1, q3
; CHECK-NEXT:    vmov.f32 s2, s1
; CHECK-NEXT:    vmov lr, s19
; CHECK-NEXT:    asrs r1, r0, #31
; CHECK-NEXT:    adds r0, r0, r3
; CHECK-NEXT:    adcs r1, r2
; CHECK-NEXT:    vmov r2, s12
; CHECK-NEXT:    lsrl r0, r1, #1
; CHECK-NEXT:    vmov r3, s13
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    adds r2, r2, r1
; CHECK-NEXT:    asr.w r12, r1, #31
; CHECK-NEXT:    adc.w r1, r12, r3
; CHECK-NEXT:    lsrl r2, r1, #1
; CHECK-NEXT:    vmov r3, s18
; CHECK-NEXT:    vmov r1, s10
; CHECK-NEXT:    vmov q1[2], q1[0], r2, r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov r2, s15
; CHECK-NEXT:    adds r4, r1, r3
; CHECK-NEXT:    vmov r3, s14
; CHECK-NEXT:    asr.w r12, r1, #31
; CHECK-NEXT:    adc.w r1, r12, lr
; CHECK-NEXT:    lsrl r4, r1, #1
; CHECK-NEXT:    asrs r1, r0, #31
; CHECK-NEXT:    adds r0, r0, r3
; CHECK-NEXT:    adcs r1, r2
; CHECK-NEXT:    lsrl r0, r1, #1
; CHECK-NEXT:    vmov q1[3], q1[1], r0, r4
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    pop {r4, pc}
entry:
  %sa = sext <4 x i32> %a to <4 x i64>
  %sb = zext <4 x i32> %b to <4 x i64>
  %add = add <4 x i64> %sa, %sb
  %sh = ashr <4 x i64> %add, <i64 1, i64 1, i64 1, i64 1>
  %t = trunc <4 x i64> %sh to <4 x i32>
  ret <4 x i32> %t
}

define arm_aapcs_vfpcc <8 x i16> @ext_add_ashr_trunc_i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: ext_add_ashr_trunc_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u16 q2, q1
; CHECK-NEXT:    vmovlb.s16 q3, q0
; CHECK-NEXT:    vmovlt.u16 q1, q1
; CHECK-NEXT:    vmovlt.s16 q0, q0
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vadd.i32 q2, q3, q2
; CHECK-NEXT:    vshr.u32 q1, q0, #1
; CHECK-NEXT:    vshr.u32 q0, q2, #1
; CHECK-NEXT:    vmovnt.i32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <8 x i16> %a to <8 x i32>
  %sb = zext <8 x i16> %b to <8 x i32>
  %add = add <8 x i32> %sa, %sb
  %sh = ashr <8 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %t = trunc <8 x i32> %sh to <8 x i16>
  ret <8 x i16> %t
}

define arm_aapcs_vfpcc <16 x i8> @ext_add_ashr_trunc_i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: ext_add_ashr_trunc_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u8 q2, q1
; CHECK-NEXT:    vmovlb.s8 q3, q0
; CHECK-NEXT:    vmovlt.u8 q1, q1
; CHECK-NEXT:    vmovlt.s8 q0, q0
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vadd.i16 q2, q3, q2
; CHECK-NEXT:    vshr.u16 q1, q0, #1
; CHECK-NEXT:    vshr.u16 q0, q2, #1
; CHECK-NEXT:    vmovnt.i16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <16 x i8> %a to <16 x i16>
  %sb = zext <16 x i8> %b to <16 x i16>
  %add = add <16 x i16> %sa, %sb
  %sh = ashr <16 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %t = trunc <16 x i16> %sh to <16 x i8>
  ret <16 x i8> %t
}

define arm_aapcs_vfpcc <16 x i8> @ext_add_ashr_trunc_i8i32(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: ext_add_ashr_trunc_i8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov.u8 r0, q1[2]
; CHECK-NEXT:    vmov.u8 r1, q1[0]
; CHECK-NEXT:    vmov q2[2], q2[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q1[3]
; CHECK-NEXT:    vmov.u8 r1, q1[1]
; CHECK-NEXT:    vmov.i32 q3, #0xff
; CHECK-NEXT:    vmov q2[3], q2[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[2]
; CHECK-NEXT:    vmov.u8 r1, q0[0]
; CHECK-NEXT:    vand q2, q2, q3
; CHECK-NEXT:    vmov q4[2], q4[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[3]
; CHECK-NEXT:    vmov.u8 r1, q0[1]
; CHECK-NEXT:    vmov q4[3], q4[1], r1, r0
; CHECK-NEXT:    vmov.u8 r1, q1[4]
; CHECK-NEXT:    vmovlb.s8 q4, q4
; CHECK-NEXT:    vmovlb.s16 q4, q4
; CHECK-NEXT:    vadd.i32 q2, q4, q2
; CHECK-NEXT:    vshr.u32 q4, q2, #1
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmov.8 q2[0], r0
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    vmov.8 q2[1], r0
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    vmov.8 q2[2], r0
; CHECK-NEXT:    vmov r0, s19
; CHECK-NEXT:    vmov.8 q2[3], r0
; CHECK-NEXT:    vmov.u8 r0, q1[6]
; CHECK-NEXT:    vmov q4[2], q4[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q1[7]
; CHECK-NEXT:    vmov.u8 r1, q1[5]
; CHECK-NEXT:    vmov q4[3], q4[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[6]
; CHECK-NEXT:    vmov.u8 r1, q0[4]
; CHECK-NEXT:    vand q4, q4, q3
; CHECK-NEXT:    vmov q5[2], q5[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[7]
; CHECK-NEXT:    vmov.u8 r1, q0[5]
; CHECK-NEXT:    vmov q5[3], q5[1], r1, r0
; CHECK-NEXT:    vmov.u8 r1, q1[8]
; CHECK-NEXT:    vmovlb.s8 q5, q5
; CHECK-NEXT:    vmovlb.s16 q5, q5
; CHECK-NEXT:    vadd.i32 q4, q5, q4
; CHECK-NEXT:    vshr.u32 q4, q4, #1
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmov.8 q2[4], r0
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    vmov.8 q2[5], r0
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    vmov.8 q2[6], r0
; CHECK-NEXT:    vmov r0, s19
; CHECK-NEXT:    vmov.8 q2[7], r0
; CHECK-NEXT:    vmov.u8 r0, q1[10]
; CHECK-NEXT:    vmov q4[2], q4[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q1[11]
; CHECK-NEXT:    vmov.u8 r1, q1[9]
; CHECK-NEXT:    vmov q4[3], q4[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[10]
; CHECK-NEXT:    vmov.u8 r1, q0[8]
; CHECK-NEXT:    vand q4, q4, q3
; CHECK-NEXT:    vmov q5[2], q5[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[11]
; CHECK-NEXT:    vmov.u8 r1, q0[9]
; CHECK-NEXT:    vmov q5[3], q5[1], r1, r0
; CHECK-NEXT:    vmov.u8 r1, q1[12]
; CHECK-NEXT:    vmovlb.s8 q5, q5
; CHECK-NEXT:    vmovlb.s16 q5, q5
; CHECK-NEXT:    vadd.i32 q4, q5, q4
; CHECK-NEXT:    vshr.u32 q4, q4, #1
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmov.8 q2[8], r0
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    vmov.8 q2[9], r0
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    vmov.8 q2[10], r0
; CHECK-NEXT:    vmov r0, s19
; CHECK-NEXT:    vmov.8 q2[11], r0
; CHECK-NEXT:    vmov.u8 r0, q1[14]
; CHECK-NEXT:    vmov q4[2], q4[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q1[15]
; CHECK-NEXT:    vmov.u8 r1, q1[13]
; CHECK-NEXT:    vmov q4[3], q4[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[14]
; CHECK-NEXT:    vmov.u8 r1, q0[12]
; CHECK-NEXT:    vand q1, q4, q3
; CHECK-NEXT:    vmov q3[2], q3[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[15]
; CHECK-NEXT:    vmov.u8 r1, q0[13]
; CHECK-NEXT:    vmov q3[3], q3[1], r1, r0
; CHECK-NEXT:    vmovlb.s8 q0, q3
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vshr.u32 q0, q0, #1
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vmov.8 q2[12], r0
; CHECK-NEXT:    vmov r0, s1
; CHECK-NEXT:    vmov.8 q2[13], r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov.8 q2[14], r0
; CHECK-NEXT:    vmov r0, s3
; CHECK-NEXT:    vmov.8 q2[15], r0
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <16 x i8> %a to <16 x i32>
  %sb = zext <16 x i8> %b to <16 x i32>
  %add = add <16 x i32> %sa, %sb
  %sh = ashr <16 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %t = trunc <16 x i32> %sh to <16 x i8>
  ret <16 x i8> %t
}

define arm_aapcs_vfpcc <4 x i32> @ext_ops_trunc_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: ext_ops_trunc_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov.f32 s8, s6
; CHECK-NEXT:    vmov.i64 q4, #0xffffffff
; CHECK-NEXT:    vmov.f32 s10, s7
; CHECK-NEXT:    vmov.f32 s12, s2
; CHECK-NEXT:    vand q2, q2, q4
; CHECK-NEXT:    vmov.f32 s14, s3
; CHECK-NEXT:    vmov r10, s12
; CHECK-NEXT:    vmov r4, s8
; CHECK-NEXT:    vmov r1, s9
; CHECK-NEXT:    vmov.f32 s6, s5
; CHECK-NEXT:    vand q1, q1, q4
; CHECK-NEXT:    vmov.f32 s2, s1
; CHECK-NEXT:    vmov r9, s0
; CHECK-NEXT:    vmov r11, s4
; CHECK-NEXT:    vmov r7, s5
; CHECK-NEXT:    adds.w r2, r10, r4
; CHECK-NEXT:    asr.w r0, r10, #31
; CHECK-NEXT:    adc.w r5, r0, r1
; CHECK-NEXT:    asrl r2, r5, r4
; CHECK-NEXT:    subs r6, r2, r4
; CHECK-NEXT:    sbc.w r12, r5, r1
; CHECK-NEXT:    adds.w r0, r9, r11
; CHECK-NEXT:    asr.w r2, r9, #31
; CHECK-NEXT:    adc.w r3, r2, r7
; CHECK-NEXT:    umull r8, r5, r6, r4
; CHECK-NEXT:    asrl r0, r3, r11
; CHECK-NEXT:    subs.w r0, r0, r11
; CHECK-NEXT:    mla r5, r12, r4, r5
; CHECK-NEXT:    sbc.w r12, r3, r7
; CHECK-NEXT:    umull r2, r1, r0, r11
; CHECK-NEXT:    muls r0, r7, r0
; CHECK-NEXT:    vmov r7, s14
; CHECK-NEXT:    orr.w lr, r1, r0
; CHECK-NEXT:    rsb.w r0, r10, #0
; CHECK-NEXT:    lsll r8, r5, r0
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov r1, s11
; CHECK-NEXT:    lsll r8, r5, r4
; CHECK-NEXT:    vmov r5, s6
; CHECK-NEXT:    eor.w r4, r4, r10
; CHECK-NEXT:    orr.w r4, r4, r10, asr #31
; CHECK-NEXT:    asrs r3, r7, #31
; CHECK-NEXT:    adds r6, r7, r0
; CHECK-NEXT:    adcs r3, r1
; CHECK-NEXT:    asrl r6, r3, r0
; CHECK-NEXT:    subs r6, r6, r0
; CHECK-NEXT:    sbc.w r1, r3, r1
; CHECK-NEXT:    umull r6, r3, r6, r0
; CHECK-NEXT:    mla r1, r1, r0, r3
; CHECK-NEXT:    rsbs r3, r7, #0
; CHECK-NEXT:    lsll r6, r1, r3
; CHECK-NEXT:    lsll r6, r1, r0
; CHECK-NEXT:    eors r0, r7
; CHECK-NEXT:    vmov q3[2], q3[0], r8, r6
; CHECK-NEXT:    vmov r6, s2
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    orr.w r0, r0, r7, asr #31
; CHECK-NEXT:    adds.w r8, r6, r5
; CHECK-NEXT:    eor.w r7, r6, r5
; CHECK-NEXT:    asr.w r3, r6, #31
; CHECK-NEXT:    orr.w r7, r7, r6, asr #31
; CHECK-NEXT:    adcs r3, r1
; CHECK-NEXT:    asrl r8, r3, r5
; CHECK-NEXT:    subs.w r8, r8, r5
; CHECK-NEXT:    sbcs r3, r1
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    mul r1, r8, r1
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    cmp r4, #0
; CHECK-NEXT:    cset r4, eq
; CHECK-NEXT:    cmp r4, #0
; CHECK-NEXT:    csetm r4, ne
; CHECK-NEXT:    vmov.32 q4[1], r4
; CHECK-NEXT:    vmov q4[2], q4[0], r4, r0
; CHECK-NEXT:    umull r4, r0, r8, r5
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    eor.w r1, r9, r11
; CHECK-NEXT:    orr.w r1, r1, r9, asr #31
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    cset r1, eq
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    cmp r7, #0
; CHECK-NEXT:    cset r7, eq
; CHECK-NEXT:    vmov.32 q0[1], r1
; CHECK-NEXT:    cmp r7, #0
; CHECK-NEXT:    csetm r7, ne
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r7
; CHECK-NEXT:    mla r7, r3, r5, r0
; CHECK-NEXT:    rsbs r1, r6, #0
; CHECK-NEXT:    vbic q5, q1, q0
; CHECK-NEXT:    mla r3, r12, r11, lr
; CHECK-NEXT:    rsb.w r0, r9, #0
; CHECK-NEXT:    lsll r4, r7, r1
; CHECK-NEXT:    vbic q1, q2, q4
; CHECK-NEXT:    lsll r2, r3, r0
; CHECK-NEXT:    vand q2, q3, q4
; CHECK-NEXT:    lsll r4, r7, r5
; CHECK-NEXT:    lsll r2, r3, r11
; CHECK-NEXT:    vorr q1, q2, q1
; CHECK-NEXT:    vmov q2[2], q2[0], r2, r4
; CHECK-NEXT:    vand q0, q2, q0
; CHECK-NEXT:    vorr q0, q0, q5
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11, pc}
entry:
  %sa = sext <4 x i32> %a to <4 x i64>
  %sb = zext <4 x i32> %b to <4 x i64>
  %add = add <4 x i64> %sa, %sb
  %ashr = ashr <4 x i64> %add, %sb
  %sub = sub <4 x i64> %ashr, %sb
  %mul = mul <4 x i64> %sub, %sb
  %lshr = lshr <4 x i64> %mul, %sa
  %shl = shl <4 x i64> %lshr, %sb
  %cmp = icmp eq <4 x i64> %sa, %sb
  %sel = select <4 x i1> %cmp, <4 x i64> %shl, <4 x i64> %sb
  %t = trunc <4 x i64> %sel to <4 x i32>
  ret <4 x i32> %t
}

define arm_aapcs_vfpcc <8 x i16> @ext_ops_trunc_i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: ext_ops_trunc_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmovlt.u16 q2, q1
; CHECK-NEXT:    vmovlt.s16 q3, q0
; CHECK-NEXT:    vadd.i32 q4, q3, q2
; CHECK-NEXT:    vneg.s32 q5, q2
; CHECK-NEXT:    vshl.s32 q4, q4, q5
; CHECK-NEXT:    vneg.s32 q5, q3
; CHECK-NEXT:    vsub.i32 q4, q4, q2
; CHECK-NEXT:    vcmp.i32 eq, q3, q2
; CHECK-NEXT:    vmul.i32 q4, q4, q2
; CHECK-NEXT:    vmovlb.u16 q1, q1
; CHECK-NEXT:    vshl.u32 q4, q4, q5
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    vshl.u32 q4, q4, q2
; CHECK-NEXT:    vadd.i32 q3, q0, q1
; CHECK-NEXT:    vpsel q2, q4, q2
; CHECK-NEXT:    vneg.s32 q4, q1
; CHECK-NEXT:    vshl.s32 q3, q3, q4
; CHECK-NEXT:    vneg.s32 q4, q0
; CHECK-NEXT:    vsub.i32 q3, q3, q1
; CHECK-NEXT:    vcmp.i32 eq, q0, q1
; CHECK-NEXT:    vmul.i32 q3, q3, q1
; CHECK-NEXT:    vshl.u32 q3, q3, q4
; CHECK-NEXT:    vshl.u32 q3, q3, q1
; CHECK-NEXT:    vpsel q0, q3, q1
; CHECK-NEXT:    vmovnt.i32 q0, q2
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <8 x i16> %a to <8 x i32>
  %sb = zext <8 x i16> %b to <8 x i32>
  %add = add <8 x i32> %sa, %sb
  %ashr = ashr <8 x i32> %add, %sb
  %sub = sub <8 x i32> %ashr, %sb
  %mul = mul <8 x i32> %sub, %sb
  %lshr = lshr <8 x i32> %mul, %sa
  %shl = shl <8 x i32> %lshr, %sb
  %cmp = icmp eq <8 x i32> %sa, %sb
  %sel = select <8 x i1> %cmp, <8 x i32> %shl, <8 x i32> %sb
  %t = trunc <8 x i32> %sel to <8 x i16>
  ret <8 x i16> %t
}

define arm_aapcs_vfpcc <16 x i8> @ext_ops_trunc_i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: ext_ops_trunc_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmovlt.u8 q2, q1
; CHECK-NEXT:    vmovlt.s8 q3, q0
; CHECK-NEXT:    vadd.i16 q4, q3, q2
; CHECK-NEXT:    vneg.s16 q5, q2
; CHECK-NEXT:    vshl.s16 q4, q4, q5
; CHECK-NEXT:    vneg.s16 q5, q3
; CHECK-NEXT:    vsub.i16 q4, q4, q2
; CHECK-NEXT:    vcmp.i16 eq, q3, q2
; CHECK-NEXT:    vmul.i16 q4, q4, q2
; CHECK-NEXT:    vmovlb.u8 q1, q1
; CHECK-NEXT:    vshl.u16 q4, q4, q5
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vshl.u16 q4, q4, q2
; CHECK-NEXT:    vadd.i16 q3, q0, q1
; CHECK-NEXT:    vpsel q2, q4, q2
; CHECK-NEXT:    vneg.s16 q4, q1
; CHECK-NEXT:    vshl.s16 q3, q3, q4
; CHECK-NEXT:    vneg.s16 q4, q0
; CHECK-NEXT:    vsub.i16 q3, q3, q1
; CHECK-NEXT:    vcmp.i16 eq, q0, q1
; CHECK-NEXT:    vmul.i16 q3, q3, q1
; CHECK-NEXT:    vshl.u16 q3, q3, q4
; CHECK-NEXT:    vshl.u16 q3, q3, q1
; CHECK-NEXT:    vpsel q0, q3, q1
; CHECK-NEXT:    vmovnt.i16 q0, q2
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <16 x i8> %a to <16 x i16>
  %sb = zext <16 x i8> %b to <16 x i16>
  %add = add <16 x i16> %sa, %sb
  %ashr = ashr <16 x i16> %add, %sb
  %sub = sub <16 x i16> %ashr, %sb
  %mul = mul <16 x i16> %sub, %sb
  %lshr = lshr <16 x i16> %mul, %sa
  %shl = shl <16 x i16> %lshr, %sb
  %cmp = icmp eq <16 x i16> %sa, %sb
  %sel = select <16 x i1> %cmp, <16 x i16> %shl, <16 x i16> %sb
  %t = trunc <16 x i16> %sel to <16 x i8>
  ret <16 x i8> %t
}

define arm_aapcs_vfpcc <8 x i16> @ext_intrinsics_trunc_i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: ext_intrinsics_trunc_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov.u16 r0, q1[2]
; CHECK-NEXT:    vmov.u16 r1, q1[0]
; CHECK-NEXT:    vmov q2, q0
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q1[3]
; CHECK-NEXT:    vmov.u16 r1, q1[1]
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q2[2]
; CHECK-NEXT:    vmov.u16 r1, q2[0]
; CHECK-NEXT:    vmovlb.u16 q0, q0
; CHECK-NEXT:    vmov q3[2], q3[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q2[3]
; CHECK-NEXT:    vmov.u16 r1, q2[1]
; CHECK-NEXT:    vmov q3[3], q3[1], r1, r0
; CHECK-NEXT:    vmov.u16 r1, q2[4]
; CHECK-NEXT:    vmovlb.s16 q3, q3
; CHECK-NEXT:    vqadd.s32 q4, q3, q0
; CHECK-NEXT:    vqadd.u32 q4, q4, q0
; CHECK-NEXT:    vqsub.s32 q4, q4, q3
; CHECK-NEXT:    vqsub.u32 q4, q4, q0
; CHECK-NEXT:    vabs.s32 q4, q4
; CHECK-NEXT:    vmin.s32 q4, q4, q3
; CHECK-NEXT:    vmax.s32 q4, q4, q0
; CHECK-NEXT:    vmin.u32 q3, q4, q3
; CHECK-NEXT:    vmax.u32 q3, q3, q0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vmov r0, s13
; CHECK-NEXT:    vmov.16 q0[1], r0
; CHECK-NEXT:    vmov r0, s14
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov r0, s15
; CHECK-NEXT:    vmov.16 q0[3], r0
; CHECK-NEXT:    vmov.u16 r0, q2[6]
; CHECK-NEXT:    vmov q3[2], q3[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q2[7]
; CHECK-NEXT:    vmov.u16 r1, q2[5]
; CHECK-NEXT:    vmov q3[3], q3[1], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q1[6]
; CHECK-NEXT:    vmov.u16 r1, q1[4]
; CHECK-NEXT:    vmov q2[2], q2[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q1[7]
; CHECK-NEXT:    vmov.u16 r1, q1[5]
; CHECK-NEXT:    vmov q2[3], q2[1], r1, r0
; CHECK-NEXT:    vmovlb.u16 q1, q2
; CHECK-NEXT:    vmovlb.s16 q2, q3
; CHECK-NEXT:    vqadd.s32 q3, q2, q1
; CHECK-NEXT:    vqadd.u32 q3, q3, q1
; CHECK-NEXT:    vqsub.s32 q3, q3, q2
; CHECK-NEXT:    vqsub.u32 q3, q3, q1
; CHECK-NEXT:    vabs.s32 q3, q3
; CHECK-NEXT:    vmin.s32 q3, q3, q2
; CHECK-NEXT:    vmax.s32 q3, q3, q1
; CHECK-NEXT:    vmin.u32 q2, q3, q2
; CHECK-NEXT:    vmax.u32 q1, q2, q1
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %sa = sext <8 x i16> %a to <8 x i32>
  %sb = zext <8 x i16> %b to <8 x i32>
  %sadd = call <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32> %sa, <8 x i32> %sb)
  %uadd = call <8 x i32> @llvm.uadd.sat.v8i32(<8 x i32> %sadd, <8 x i32> %sb)
  %ssub = call <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32> %uadd, <8 x i32> %sa)
  %usub = call <8 x i32> @llvm.usub.sat.v8i32(<8 x i32> %ssub, <8 x i32> %sb)
  %abs = call <8 x i32> @llvm.abs.v8i32(<8 x i32> %usub, i1 true)
  %smin = call <8 x i32> @llvm.smin.v8i32(<8 x i32> %abs, <8 x i32> %sa)
  %smax = call <8 x i32> @llvm.smax.v8i32(<8 x i32> %smin, <8 x i32> %sb)
  %umin = call <8 x i32> @llvm.umin.v8i32(<8 x i32> %smax, <8 x i32> %sa)
  %umax = call <8 x i32> @llvm.umax.v8i32(<8 x i32> %umin, <8 x i32> %sb)
  %t = trunc <8 x i32> %umax to <8 x i16>
  ret <8 x i16> %t
}

define arm_aapcs_vfpcc <8 x half> @ext_fpintrinsics_trunc_half(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: ext_fpintrinsics_trunc_half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov q2, q0
; CHECK-NEXT:    vcvtt.f32.f16 s3, s5
; CHECK-NEXT:    vcvtt.f32.f16 s15, s9
; CHECK-NEXT:    vcvtb.f32.f16 s2, s5
; CHECK-NEXT:    vcvtb.f32.f16 s14, s9
; CHECK-NEXT:    vcvtt.f32.f16 s1, s4
; CHECK-NEXT:    vcvtt.f32.f16 s13, s8
; CHECK-NEXT:    vcvtb.f32.f16 s0, s4
; CHECK-NEXT:    vcvtb.f32.f16 s12, s8
; CHECK-NEXT:    vabs.f32 q4, q3
; CHECK-NEXT:    vminnm.f32 q4, q4, q3
; CHECK-NEXT:    vmaxnm.f32 q4, q4, q0
; CHECK-NEXT:    vfma.f32 q0, q4, q3
; CHECK-NEXT:    vcvtt.f32.f16 s19, s11
; CHECK-NEXT:    vrintp.f32 q0, q0
; CHECK-NEXT:    vcvtb.f32.f16 s18, s11
; CHECK-NEXT:    vrintm.f32 q0, q0
; CHECK-NEXT:    vcvtt.f32.f16 s17, s10
; CHECK-NEXT:    vrintx.f32 q0, q0
; CHECK-NEXT:    vcvtb.f32.f16 s16, s10
; CHECK-NEXT:    vrinta.f32 q0, q0
; CHECK-NEXT:    vrintz.f32 q3, q0
; CHECK-NEXT:    vcvtb.f16.f32 s0, s12
; CHECK-NEXT:    vcvtt.f16.f32 s0, s13
; CHECK-NEXT:    vcvtb.f16.f32 s1, s14
; CHECK-NEXT:    vcvtt.f16.f32 s1, s15
; CHECK-NEXT:    vcvtt.f32.f16 s15, s7
; CHECK-NEXT:    vcvtb.f32.f16 s14, s7
; CHECK-NEXT:    vcvtt.f32.f16 s13, s6
; CHECK-NEXT:    vcvtb.f32.f16 s12, s6
; CHECK-NEXT:    vabs.f32 q1, q4
; CHECK-NEXT:    vminnm.f32 q1, q1, q4
; CHECK-NEXT:    vmaxnm.f32 q1, q1, q3
; CHECK-NEXT:    vfma.f32 q3, q1, q4
; CHECK-NEXT:    vrintp.f32 q1, q3
; CHECK-NEXT:    vrintm.f32 q1, q1
; CHECK-NEXT:    vrintx.f32 q1, q1
; CHECK-NEXT:    vrinta.f32 q1, q1
; CHECK-NEXT:    vrintz.f32 q1, q1
; CHECK-NEXT:    vcvtb.f16.f32 s2, s4
; CHECK-NEXT:    vcvtt.f16.f32 s2, s5
; CHECK-NEXT:    vcvtb.f16.f32 s3, s6
; CHECK-NEXT:    vcvtt.f16.f32 s3, s7
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %sa = fpext <8 x half> %a to <8 x float>
  %sb = fpext <8 x half> %b to <8 x float>
  %abs = call <8 x float> @llvm.fabs.v8f32(<8 x float> %sa)
  %min = call <8 x float> @llvm.minnum.v8f32(<8 x float> %abs, <8 x float> %sa)
  %max = call <8 x float> @llvm.maxnum.v8f32(<8 x float> %min, <8 x float> %sb)
  %fma = call <8 x float> @llvm.fma.v8f32(<8 x float> %max, <8 x float> %sa, <8 x float> %sb)
  %ceil = call <8 x float> @llvm.ceil.v8f32(<8 x float> %fma)
  %floor = call <8 x float> @llvm.floor.v8f32(<8 x float> %ceil)
  %rint = call <8 x float> @llvm.rint.v8f32(<8 x float> %floor)
  %round = call <8 x float> @llvm.round.v8f32(<8 x float> %rint)
  %trunc = call <8 x float> @llvm.trunc.v8f32(<8 x float> %round)
  %t = fptrunc <8 x float> %trunc to <8 x half>
  ret <8 x half> %t
}

declare <8 x i32> @llvm.abs.v8i32(<8 x i32>, i1)
declare <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.uadd.sat.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.usub.sat.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.smin.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.smax.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.umin.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.umax.v8i32(<8 x i32>, <8 x i32>)
declare <8 x float> @llvm.fabs.v8f32(<8 x float>)
declare <8 x float> @llvm.minnum.v8f32(<8 x float>, <8 x float>)
declare <8 x float> @llvm.maxnum.v8f32(<8 x float>, <8 x float>)
declare <8 x float> @llvm.fma.v8f32(<8 x float>, <8 x float>, <8 x float>)
declare <8 x float> @llvm.ceil.v8f32(<8 x float>)
declare <8 x float> @llvm.floor.v8f32(<8 x float>)
declare <8 x float> @llvm.rint.v8f32(<8 x float>)
declare <8 x float> @llvm.round.v8f32(<8 x float>)
declare <8 x float> @llvm.trunc.v8f32(<8 x float>)
