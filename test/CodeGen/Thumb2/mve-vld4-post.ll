; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve.fp,+fp64 -mve-max-interleave-factor=4 -verify-machineinstrs %s -o - | FileCheck %s

; i32

define <16 x i32> *@vld4_v4i32(<16 x i32> *%src, <4 x i32> *%dst) {
; CHECK-LABEL: vld4_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vld40.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld41.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld42.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld43.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1_q2_q3
; CHECK-NEXT:    vadd.i32 q4, q2, q3
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vadd.i32 q0, q0, q4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x i32>, <16 x i32>* %src, align 4
  %s1 = shufflevector <16 x i32> %l1, <16 x i32> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %s2 = shufflevector <16 x i32> %l1, <16 x i32> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %s3 = shufflevector <16 x i32> %l1, <16 x i32> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %s4 = shufflevector <16 x i32> %l1, <16 x i32> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %a1 = add <4 x i32> %s1, %s2
  %a2 = add <4 x i32> %s3, %s4
  %a3 = add <4 x i32> %a1, %a2
  store <4 x i32> %a3, <4 x i32> *%dst
  %ret = getelementptr inbounds <16 x i32>, <16 x i32>* %src, i32 1
  ret <16 x i32> *%ret
}

; i16

define <32 x i16> *@vld4_v8i16(<32 x i16> *%src, <8 x i16> *%dst) {
; CHECK-LABEL: vld4_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vld40.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld41.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld42.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld43.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1_q2_q3
; CHECK-NEXT:    vadd.i16 q4, q2, q3
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vadd.i16 q0, q0, q4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <32 x i16>, <32 x i16>* %src, align 4
  %s1 = shufflevector <32 x i16> %l1, <32 x i16> undef, <8 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28>
  %s2 = shufflevector <32 x i16> %l1, <32 x i16> undef, <8 x i32> <i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29>
  %s3 = shufflevector <32 x i16> %l1, <32 x i16> undef, <8 x i32> <i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30>
  %s4 = shufflevector <32 x i16> %l1, <32 x i16> undef, <8 x i32> <i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %a1 = add <8 x i16> %s1, %s2
  %a2 = add <8 x i16> %s3, %s4
  %a3 = add <8 x i16> %a1, %a2
  store <8 x i16> %a3, <8 x i16> *%dst
  %ret = getelementptr inbounds <32 x i16>, <32 x i16>* %src, i32 1
  ret <32 x i16> *%ret
}

; i8

define <64 x i8> *@vld4_v16i8(<64 x i8> *%src, <16 x i8> *%dst) {
; CHECK-LABEL: vld4_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vld40.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld41.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld42.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld43.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1_q2_q3
; CHECK-NEXT:    vadd.i8 q4, q2, q3
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vadd.i8 q0, q0, q4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <64 x i8>, <64 x i8>* %src, align 4
  %s1 = shufflevector <64 x i8> %l1, <64 x i8> undef, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28, i32 32, i32 36, i32 40, i32 44, i32 48, i32 52, i32 56, i32 60>
  %s2 = shufflevector <64 x i8> %l1, <64 x i8> undef, <16 x i32> <i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29, i32 33, i32 37, i32 41, i32 45, i32 49, i32 53, i32 57, i32 61>
  %s3 = shufflevector <64 x i8> %l1, <64 x i8> undef, <16 x i32> <i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30, i32 34, i32 38, i32 42, i32 46, i32 50, i32 54, i32 58, i32 62>
  %s4 = shufflevector <64 x i8> %l1, <64 x i8> undef, <16 x i32> <i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31, i32 35, i32 39, i32 43, i32 47, i32 51, i32 55, i32 59, i32 63>
  %a1 = add <16 x i8> %s1, %s2
  %a2 = add <16 x i8> %s3, %s4
  %a3 = add <16 x i8> %a1, %a2
  store <16 x i8> %a3, <16 x i8> *%dst
  %ret = getelementptr inbounds <64 x i8>, <64 x i8>* %src, i32 1
  ret <64 x i8> *%ret
}

; i64

define <8 x i64> *@vld4_v2i64(<8 x i64> *%src, <2 x i64> *%dst) {
; CHECK-LABEL: vld4_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vldrw.u32 q3, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q5, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #32]
; CHECK-NEXT:    vmov.f64 d8, d7
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    vmov.f32 s17, s15
; CHECK-NEXT:    vmov.f32 s18, s22
; CHECK-NEXT:    vmov.f32 s14, s20
; CHECK-NEXT:    vmov.f32 s19, s23
; CHECK-NEXT:    vmov.f32 s15, s21
; CHECK-NEXT:    vmov r2, s18
; CHECK-NEXT:    vmov r3, s14
; CHECK-NEXT:    vmov.f64 d2, d1
; CHECK-NEXT:    vmov.f32 s5, s3
; CHECK-NEXT:    vmov.f32 s6, s10
; CHECK-NEXT:    vmov.f32 s2, s8
; CHECK-NEXT:    vmov.f32 s3, s9
; CHECK-NEXT:    vmov.f32 s7, s11
; CHECK-NEXT:    vmov r12, s19
; CHECK-NEXT:    vmov lr, s15
; CHECK-NEXT:    vmov r4, s6
; CHECK-NEXT:    vmov r5, s2
; CHECK-NEXT:    vmov r7, s0
; CHECK-NEXT:    adds r6, r3, r2
; CHECK-NEXT:    vmov r2, s7
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    adc.w r12, r12, lr
; CHECK-NEXT:    adds r5, r5, r4
; CHECK-NEXT:    vmov r4, s16
; CHECK-NEXT:    adcs r2, r3
; CHECK-NEXT:    adds.w lr, r5, r6
; CHECK-NEXT:    adc.w r12, r12, r2
; CHECK-NEXT:    vmov r2, s12
; CHECK-NEXT:    vmov r6, s17
; CHECK-NEXT:    vmov r5, s13
; CHECK-NEXT:    vmov r3, s4
; CHECK-NEXT:    adds r2, r2, r4
; CHECK-NEXT:    vmov r4, s1
; CHECK-NEXT:    adcs r6, r5
; CHECK-NEXT:    vmov r5, s5
; CHECK-NEXT:    adds r3, r3, r7
; CHECK-NEXT:    adcs r4, r5
; CHECK-NEXT:    adds r2, r2, r3
; CHECK-NEXT:    adc.w r3, r4, r6
; CHECK-NEXT:    vmov.32 q0[0], r2
; CHECK-NEXT:    vmov.32 q0[1], r3
; CHECK-NEXT:    vmov.32 q0[2], lr
; CHECK-NEXT:    vmov.32 q0[3], r12
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %l1 = load <8 x i64>, <8 x i64>* %src, align 4
  %s1 = shufflevector <8 x i64> %l1, <8 x i64> undef, <2 x i32> <i32 0, i32 4>
  %s2 = shufflevector <8 x i64> %l1, <8 x i64> undef, <2 x i32> <i32 1, i32 5>
  %s3 = shufflevector <8 x i64> %l1, <8 x i64> undef, <2 x i32> <i32 2, i32 6>
  %s4 = shufflevector <8 x i64> %l1, <8 x i64> undef, <2 x i32> <i32 3, i32 7>
  %a1 = add <2 x i64> %s1, %s2
  %a2 = add <2 x i64> %s3, %s4
  %a3 = add <2 x i64> %a1, %a2
  store <2 x i64> %a3, <2 x i64> *%dst
  %ret = getelementptr inbounds <8 x i64>, <8 x i64>* %src, i32 1
  ret <8 x i64> *%ret
}

; f32

define <16 x float> *@vld4_v4f32(<16 x float> *%src, <4 x float> *%dst) {
; CHECK-LABEL: vld4_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vld40.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld41.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld42.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld43.32 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1_q2_q3
; CHECK-NEXT:    vadd.f32 q4, q2, q3
; CHECK-NEXT:    vadd.f32 q0, q0, q1
; CHECK-NEXT:    vadd.f32 q0, q0, q4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x float>, <16 x float>* %src, align 4
  %s1 = shufflevector <16 x float> %l1, <16 x float> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %s2 = shufflevector <16 x float> %l1, <16 x float> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %s3 = shufflevector <16 x float> %l1, <16 x float> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %s4 = shufflevector <16 x float> %l1, <16 x float> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %a1 = fadd <4 x float> %s1, %s2
  %a2 = fadd <4 x float> %s3, %s4
  %a3 = fadd <4 x float> %a1, %a2
  store <4 x float> %a3, <4 x float> *%dst
  %ret = getelementptr inbounds <16 x float>, <16 x float>* %src, i32 1
  ret <16 x float> *%ret
}

; f16

define <32 x half> *@vld4_v8f16(<32 x half> *%src, <8 x half> *%dst) {
; CHECK-LABEL: vld4_v8f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vld40.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld41.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld42.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld43.16 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1_q2_q3
; CHECK-NEXT:    vadd.f16 q4, q2, q3
; CHECK-NEXT:    vadd.f16 q0, q0, q1
; CHECK-NEXT:    vadd.f16 q0, q0, q4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <32 x half>, <32 x half>* %src, align 4
  %s1 = shufflevector <32 x half> %l1, <32 x half> undef, <8 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28>
  %s2 = shufflevector <32 x half> %l1, <32 x half> undef, <8 x i32> <i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29>
  %s3 = shufflevector <32 x half> %l1, <32 x half> undef, <8 x i32> <i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30>
  %s4 = shufflevector <32 x half> %l1, <32 x half> undef, <8 x i32> <i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %a1 = fadd <8 x half> %s1, %s2
  %a2 = fadd <8 x half> %s3, %s4
  %a3 = fadd <8 x half> %a1, %a2
  store <8 x half> %a3, <8 x half> *%dst
  %ret = getelementptr inbounds <32 x half>, <32 x half>* %src, i32 1
  ret <32 x half> *%ret
}

; f64

define <8 x double> *@vld4_v2f64(<8 x double> *%src, <2 x double> *%dst) {
; CHECK-LABEL: vld4_v2f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #32]
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vadd.f64 d0, d0, d1
; CHECK-NEXT:    vadd.f64 d1, d2, d3
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    adds r0, #64
; CHECK-NEXT:    vadd.f64 d2, d2, d3
; CHECK-NEXT:    vadd.f64 d3, d4, d5
; CHECK-NEXT:    vadd.f64 d1, d1, d0
; CHECK-NEXT:    vadd.f64 d0, d3, d2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x double>, <8 x double>* %src, align 4
  %s1 = shufflevector <8 x double> %l1, <8 x double> undef, <2 x i32> <i32 0, i32 4>
  %s2 = shufflevector <8 x double> %l1, <8 x double> undef, <2 x i32> <i32 1, i32 5>
  %s3 = shufflevector <8 x double> %l1, <8 x double> undef, <2 x i32> <i32 2, i32 6>
  %s4 = shufflevector <8 x double> %l1, <8 x double> undef, <2 x i32> <i32 3, i32 7>
  %a1 = fadd <2 x double> %s1, %s2
  %a2 = fadd <2 x double> %s3, %s4
  %a3 = fadd <2 x double> %a1, %a2
  store <2 x double> %a3, <2 x double> *%dst
  %ret = getelementptr inbounds <8 x double>, <8 x double>* %src, i32 1
  ret <8 x double> *%ret
}
