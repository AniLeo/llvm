; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp,+fp64 -verify-machineinstrs %s -o - | FileCheck %s

; i32

define void @vld2_v2i32(<4 x i32> *%src, <2 x i32> *%dst) {
; CHECK-LABEL: vld2_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vrev64.32 q1, q0
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    add r0, r2
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    add r2, r3
; CHECK-NEXT:    strd r2, r0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <4 x i32>, <4 x i32>* %src, align 4
  %s1 = shufflevector <4 x i32> %l1, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %s2 = shufflevector <4 x i32> %l1, <4 x i32> undef, <2 x i32> <i32 1, i32 3>
  %a = add <2 x i32> %s1, %s2
  store <2 x i32> %a, <2 x i32> *%dst
  ret void
}

define void @vld2_v4i32(<8 x i32> *%src, <4 x i32> *%dst) {
; CHECK-LABEL: vld2_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.32 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.32 {q0, q1}, [r0]
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x i32>, <8 x i32>* %src, align 4
  %s1 = shufflevector <8 x i32> %l1, <8 x i32> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x i32> %l1, <8 x i32> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = add <4 x i32> %s1, %s2
  store <4 x i32> %a, <4 x i32> *%dst
  ret void
}

define void @vld2_v8i32(<16 x i32> *%src, <8 x i32> *%dst) {
; CHECK-LABEL: vld2_v8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.32 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.32 {q0, q1}, [r0]!
; CHECK-NEXT:    vld20.32 {q2, q3}, [r0]
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vld21.32 {q2, q3}, [r0]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vadd.i32 q1, q2, q3
; CHECK-NEXT:    vstrw.32 q1, [r1, #16]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x i32>, <16 x i32>* %src, align 4
  %s1 = shufflevector <16 x i32> %l1, <16 x i32> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %s2 = shufflevector <16 x i32> %l1, <16 x i32> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = add <8 x i32> %s1, %s2
  store <8 x i32> %a, <8 x i32> *%dst
  ret void
}

define void @vld2_v16i32(<32 x i32> *%src, <16 x i32> *%dst) {
; CHECK-LABEL: vld2_v16i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    vpush {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    vld20.32 {q0, q1}, [r0]
; CHECK-NEXT:    add.w r2, r0, #96
; CHECK-NEXT:    add.w r3, r0, #64
; CHECK-NEXT:    vld21.32 {q0, q1}, [r0]!
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vld20.32 {q1, q2}, [r3]
; CHECK-NEXT:    vld20.32 {q3, q4}, [r2]
; CHECK-NEXT:    vld20.32 {q5, q6}, [r0]
; CHECK-NEXT:    vld21.32 {q5, q6}, [r0]
; CHECK-NEXT:    vld21.32 {q1, q2}, [r3]
; CHECK-NEXT:    vld21.32 {q3, q4}, [r2]
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q1_q2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vadd.i32 q5, q5, q6
; CHECK-NEXT:    vadd.i32 q1, q1, q2
; CHECK-NEXT:    vadd.i32 q3, q3, q4
; CHECK-NEXT:    vstrw.32 q1, [r1, #32]
; CHECK-NEXT:    vstrw.32 q3, [r1, #48]
; CHECK-NEXT:    vstrw.32 q5, [r1, #16]
; CHECK-NEXT:    vpop {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <32 x i32>, <32 x i32>* %src, align 4
  %s1 = shufflevector <32 x i32> %l1, <32 x i32> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %s2 = shufflevector <32 x i32> %l1, <32 x i32> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %a = add <16 x i32> %s1, %s2
  store <16 x i32> %a, <16 x i32> *%dst
  ret void
}

define void @vld2_v4i32_align1(<8 x i32> *%src, <4 x i32> *%dst) {
; CHECK-LABEL: vld2_v4i32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q1, [r0]
; CHECK-NEXT:    vldrb.u8 q0, [r0, #16]
; CHECK-NEXT:    vmov.f32 s8, s5
; CHECK-NEXT:    vmov.f32 s9, s7
; CHECK-NEXT:    vmov.f32 s5, s6
; CHECK-NEXT:    vmov.f32 s10, s1
; CHECK-NEXT:    vmov.f32 s6, s0
; CHECK-NEXT:    vmov.f32 s11, s3
; CHECK-NEXT:    vmov.f32 s7, s2
; CHECK-NEXT:    vadd.i32 q0, q1, q2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x i32>, <8 x i32>* %src, align 1
  %s1 = shufflevector <8 x i32> %l1, <8 x i32> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x i32> %l1, <8 x i32> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = add <4 x i32> %s1, %s2
  store <4 x i32> %a, <4 x i32> *%dst
  ret void
}

; i16

define void @vld2_v2i16(<4 x i16> *%src, <2 x i16> *%dst) {
; CHECK-LABEL: vld2_v2i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    vrev64.32 q1, q0
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    add r0, r2
; CHECK-NEXT:    strh r0, [r1, #2]
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    add r0, r2
; CHECK-NEXT:    strh r0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <4 x i16>, <4 x i16>* %src, align 2
  %s1 = shufflevector <4 x i16> %l1, <4 x i16> undef, <2 x i32> <i32 0, i32 2>
  %s2 = shufflevector <4 x i16> %l1, <4 x i16> undef, <2 x i32> <i32 1, i32 3>
  %a = add <2 x i16> %s1, %s2
  store <2 x i16> %a, <2 x i16> *%dst
  ret void
}

define void @vld2_v4i16(<8 x i16> *%src, <4 x i16> *%dst) {
; CHECK-LABEL: vld2_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r0]
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vstrh.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x i16>, <8 x i16>* %src, align 2
  %s1 = shufflevector <8 x i16> %l1, <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x i16> %l1, <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = add <4 x i16> %s1, %s2
  store <4 x i16> %a, <4 x i16> *%dst
  ret void
}

define void @vld2_v8i16(<16 x i16> *%src, <8 x i16> *%dst) {
; CHECK-LABEL: vld2_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.16 {q0, q1}, [r0]
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x i16>, <16 x i16>* %src, align 2
  %s1 = shufflevector <16 x i16> %l1, <16 x i16> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %s2 = shufflevector <16 x i16> %l1, <16 x i16> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = add <8 x i16> %s1, %s2
  store <8 x i16> %a, <8 x i16> *%dst
  ret void
}

define void @vld2_v16i16(<32 x i16> *%src, <16 x i16> *%dst) {
; CHECK-LABEL: vld2_v16i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.16 {q0, q1}, [r0]!
; CHECK-NEXT:    vld20.16 {q2, q3}, [r0]
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vld21.16 {q2, q3}, [r0]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vadd.i16 q1, q2, q3
; CHECK-NEXT:    vstrw.32 q1, [r1, #16]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <32 x i16>, <32 x i16>* %src, align 2
  %s1 = shufflevector <32 x i16> %l1, <32 x i16> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %s2 = shufflevector <32 x i16> %l1, <32 x i16> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %a = add <16 x i16> %s1, %s2
  store <16 x i16> %a, <16 x i16> *%dst
  ret void
}

define void @vld2_v8i16_align1(<16 x i16> *%src, <8 x i16> *%dst) {
; CHECK-LABEL: vld2_v8i16_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q1, [r0]
; CHECK-NEXT:    vldrb.u8 q2, [r0, #16]
; CHECK-NEXT:    vmov.u16 r2, q1[1]
; CHECK-NEXT:    vmov.u16 r0, q2[1]
; CHECK-NEXT:    vmov.16 q0[0], r2
; CHECK-NEXT:    vmov.u16 r2, q1[3]
; CHECK-NEXT:    vmov.16 q0[1], r2
; CHECK-NEXT:    vmov.u16 r2, q1[5]
; CHECK-NEXT:    vmov.16 q0[2], r2
; CHECK-NEXT:    vmov.u16 r2, q1[7]
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov.u16 r0, q2[3]
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov.u16 r0, q2[5]
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov.u16 r0, q2[7]
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    vmov.u16 r0, q1[0]
; CHECK-NEXT:    vmov.16 q3[0], r0
; CHECK-NEXT:    vmov.u16 r0, q1[2]
; CHECK-NEXT:    vmov.16 q3[1], r0
; CHECK-NEXT:    vmov.u16 r0, q1[4]
; CHECK-NEXT:    vmov.16 q3[2], r0
; CHECK-NEXT:    vmov.u16 r0, q1[6]
; CHECK-NEXT:    vmov.16 q3[3], r0
; CHECK-NEXT:    vmov.u16 r0, q2[0]
; CHECK-NEXT:    vmov.16 q3[4], r0
; CHECK-NEXT:    vmov.u16 r0, q2[2]
; CHECK-NEXT:    vmov.16 q3[5], r0
; CHECK-NEXT:    vmov.u16 r0, q2[4]
; CHECK-NEXT:    vmov.16 q3[6], r0
; CHECK-NEXT:    vmov.u16 r0, q2[6]
; CHECK-NEXT:    vmov.16 q3[7], r0
; CHECK-NEXT:    vadd.i16 q0, q3, q0
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x i16>, <16 x i16>* %src, align 1
  %s1 = shufflevector <16 x i16> %l1, <16 x i16> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %s2 = shufflevector <16 x i16> %l1, <16 x i16> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = add <8 x i16> %s1, %s2
  store <8 x i16> %a, <8 x i16> *%dst
  ret void
}

; i8

define void @vld2_v2i8(<4 x i8> *%src, <2 x i8> *%dst) {
; CHECK-LABEL: vld2_v2i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r0]
; CHECK-NEXT:    vrev64.32 q1, q0
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    add r0, r2
; CHECK-NEXT:    strb r0, [r1, #1]
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    add r0, r2
; CHECK-NEXT:    strb r0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <4 x i8>, <4 x i8>* %src, align 1
  %s1 = shufflevector <4 x i8> %l1, <4 x i8> undef, <2 x i32> <i32 0, i32 2>
  %s2 = shufflevector <4 x i8> %l1, <4 x i8> undef, <2 x i32> <i32 1, i32 3>
  %a = add <2 x i8> %s1, %s2
  store <2 x i8> %a, <2 x i8> *%dst
  ret void
}

define void @vld2_v4i8(<8 x i8> *%src, <4 x i8> *%dst) {
; CHECK-LABEL: vld2_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r0]
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vstrb.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x i8>, <8 x i8>* %src, align 1
  %s1 = shufflevector <8 x i8> %l1, <8 x i8> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x i8> %l1, <8 x i8> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = add <4 x i8> %s1, %s2
  store <4 x i8> %a, <4 x i8> *%dst
  ret void
}

define void @vld2_v8i8(<16 x i8> *%src, <8 x i8> *%dst) {
; CHECK-LABEL: vld2_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0]
; CHECK-NEXT:    vrev16.8 q1, q0
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vstrb.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x i8>, <16 x i8>* %src, align 1
  %s1 = shufflevector <16 x i8> %l1, <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %s2 = shufflevector <16 x i8> %l1, <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = add <8 x i8> %s1, %s2
  store <8 x i8> %a, <8 x i8> *%dst
  ret void
}

define void @vld2_v16i8(<32 x i8> *%src, <16 x i8> *%dst) {
; CHECK-LABEL: vld2_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.8 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.8 {q0, q1}, [r0]
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <32 x i8>, <32 x i8>* %src, align 1
  %s1 = shufflevector <32 x i8> %l1, <32 x i8> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %s2 = shufflevector <32 x i8> %l1, <32 x i8> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %a = add <16 x i8> %s1, %s2
  store <16 x i8> %a, <16 x i8> *%dst
  ret void
}

; i64

define void @vld2_v2i64(<4 x i64> *%src, <2 x i64> *%dst) {
; CHECK-LABEL: vld2_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    vmov.f64 d2, d1
; CHECK-NEXT:    vmov.f32 s5, s3
; CHECK-NEXT:    vmov.f32 s6, s10
; CHECK-NEXT:    vmov.f32 s2, s8
; CHECK-NEXT:    vmov.f32 s3, s9
; CHECK-NEXT:    vmov.f32 s7, s11
; CHECK-NEXT:    vmov r3, s6
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov r4, s0
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r12, s7
; CHECK-NEXT:    adds.w lr, r0, r3
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r3, s5
; CHECK-NEXT:    adc.w r12, r12, r2
; CHECK-NEXT:    vmov r2, s1
; CHECK-NEXT:    adds r0, r0, r4
; CHECK-NEXT:    vmov q0[2], q0[0], r0, lr
; CHECK-NEXT:    adcs r2, r3
; CHECK-NEXT:    vmov q0[3], q0[1], r2, r12
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    pop {r4, pc}
entry:
  %l1 = load <4 x i64>, <4 x i64>* %src, align 8
  %s1 = shufflevector <4 x i64> %l1, <4 x i64> undef, <2 x i32> <i32 0, i32 2>
  %s2 = shufflevector <4 x i64> %l1, <4 x i64> undef, <2 x i32> <i32 1, i32 3>
  %a = add <2 x i64> %s1, %s2
  store <2 x i64> %a, <2 x i64> *%dst
  ret void
}

define void @vld2_v4i64(<8 x i64> *%src, <4 x i64> *%dst) {
; CHECK-LABEL: vld2_v4i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q5, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #32]
; CHECK-NEXT:    vldrw.u32 q4, [r0, #48]
; CHECK-NEXT:    vmov.f64 d4, d1
; CHECK-NEXT:    vmov.f32 s9, s3
; CHECK-NEXT:    vmov.f32 s10, s22
; CHECK-NEXT:    vmov.f32 s2, s20
; CHECK-NEXT:    vmov.f32 s11, s23
; CHECK-NEXT:    vmov.f32 s3, s21
; CHECK-NEXT:    vmov r3, s10
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov.f64 d6, d3
; CHECK-NEXT:    vmov r12, s11
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov.f32 s13, s7
; CHECK-NEXT:    vmov.f32 s14, s18
; CHECK-NEXT:    vmov.f32 s6, s16
; CHECK-NEXT:    vmov.f32 s7, s17
; CHECK-NEXT:    vmov.f32 s15, s19
; CHECK-NEXT:    vmov r4, s6
; CHECK-NEXT:    vmov r5, s12
; CHECK-NEXT:    vmov r6, s4
; CHECK-NEXT:    adds.w lr, r0, r3
; CHECK-NEXT:    vmov r3, s14
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    adc.w r12, r12, r2
; CHECK-NEXT:    vmov r2, s15
; CHECK-NEXT:    adds r3, r3, r4
; CHECK-NEXT:    vmov r4, s5
; CHECK-NEXT:    adcs r0, r2
; CHECK-NEXT:    vmov r2, s13
; CHECK-NEXT:    adds r5, r5, r6
; CHECK-NEXT:    vmov r6, s0
; CHECK-NEXT:    vmov q3[2], q3[0], r5, r3
; CHECK-NEXT:    adcs r2, r4
; CHECK-NEXT:    vmov r4, s8
; CHECK-NEXT:    vmov q3[3], q3[1], r2, r0
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov r2, s1
; CHECK-NEXT:    vstrw.32 q3, [r1, #16]
; CHECK-NEXT:    adds r4, r4, r6
; CHECK-NEXT:    vmov q1[2], q1[0], r4, lr
; CHECK-NEXT:    adcs r0, r2
; CHECK-NEXT:    vmov q1[3], q1[1], r0, r12
; CHECK-NEXT:    vstrw.32 q1, [r1]
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %l1 = load <8 x i64>, <8 x i64>* %src, align 8
  %s1 = shufflevector <8 x i64> %l1, <8 x i64> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x i64> %l1, <8 x i64> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = add <4 x i64> %s1, %s2
  store <4 x i64> %a, <4 x i64> *%dst
  ret void
}

; f32

define void @vld2_v2f32(<4 x float> *%src, <2 x float> *%dst) {
; CHECK-LABEL: vld2_v2f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov.f32 s4, s1
; CHECK-NEXT:    vmov.f32 s5, s3
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vadd.f32 q0, q0, q1
; CHECK-NEXT:    vstmia r1, {s0, s1}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <4 x float>, <4 x float>* %src, align 4
  %s1 = shufflevector <4 x float> %l1, <4 x float> undef, <2 x i32> <i32 0, i32 2>
  %s2 = shufflevector <4 x float> %l1, <4 x float> undef, <2 x i32> <i32 1, i32 3>
  %a = fadd <2 x float> %s1, %s2
  store <2 x float> %a, <2 x float> *%dst
  ret void
}

define void @vld2_v4f32(<8 x float> *%src, <4 x float> *%dst) {
; CHECK-LABEL: vld2_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.32 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.32 {q0, q1}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x float>, <8 x float>* %src, align 4
  %s1 = shufflevector <8 x float> %l1, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x float> %l1, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = fadd <4 x float> %s1, %s2
  store <4 x float> %a, <4 x float> *%dst
  ret void
}

define void @vld2_v8f32(<16 x float> *%src, <8 x float> *%dst) {
; CHECK-LABEL: vld2_v8f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.32 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.32 {q0, q1}, [r0]!
; CHECK-NEXT:    vld20.32 {q2, q3}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q0, q1
; CHECK-NEXT:    vld21.32 {q2, q3}, [r0]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vadd.f32 q1, q2, q3
; CHECK-NEXT:    vstrw.32 q1, [r1, #16]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x float>, <16 x float>* %src, align 4
  %s1 = shufflevector <16 x float> %l1, <16 x float> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %s2 = shufflevector <16 x float> %l1, <16 x float> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = fadd <8 x float> %s1, %s2
  store <8 x float> %a, <8 x float> *%dst
  ret void
}

define void @vld2_v16f32(<32 x float> *%src, <16 x float> *%dst) {
; CHECK-LABEL: vld2_v16f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    vpush {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    vld20.32 {q0, q1}, [r0]
; CHECK-NEXT:    add.w r2, r0, #96
; CHECK-NEXT:    add.w r3, r0, #64
; CHECK-NEXT:    vld21.32 {q0, q1}, [r0]!
; CHECK-NEXT:    vadd.f32 q0, q0, q1
; CHECK-NEXT:    vld20.32 {q1, q2}, [r3]
; CHECK-NEXT:    vld20.32 {q3, q4}, [r2]
; CHECK-NEXT:    vld20.32 {q5, q6}, [r0]
; CHECK-NEXT:    vld21.32 {q5, q6}, [r0]
; CHECK-NEXT:    vld21.32 {q1, q2}, [r3]
; CHECK-NEXT:    vld21.32 {q3, q4}, [r2]
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q1_q2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vadd.f32 q5, q5, q6
; CHECK-NEXT:    vadd.f32 q1, q1, q2
; CHECK-NEXT:    vadd.f32 q3, q3, q4
; CHECK-NEXT:    vstrw.32 q1, [r1, #32]
; CHECK-NEXT:    vstrw.32 q3, [r1, #48]
; CHECK-NEXT:    vstrw.32 q5, [r1, #16]
; CHECK-NEXT:    vpop {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <32 x float>, <32 x float>* %src, align 4
  %s1 = shufflevector <32 x float> %l1, <32 x float> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %s2 = shufflevector <32 x float> %l1, <32 x float> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %a = fadd <16 x float> %s1, %s2
  store <16 x float> %a, <16 x float> *%dst
  ret void
}

define void @vld2_v4f32_align1(<8 x float> *%src, <4 x float> *%dst) {
; CHECK-LABEL: vld2_v4f32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q1, [r0]
; CHECK-NEXT:    vldrb.u8 q0, [r0, #16]
; CHECK-NEXT:    vmov.f32 s8, s5
; CHECK-NEXT:    vmov.f32 s9, s7
; CHECK-NEXT:    vmov.f32 s5, s6
; CHECK-NEXT:    vmov.f32 s10, s1
; CHECK-NEXT:    vmov.f32 s6, s0
; CHECK-NEXT:    vmov.f32 s11, s3
; CHECK-NEXT:    vmov.f32 s7, s2
; CHECK-NEXT:    vadd.f32 q0, q1, q2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x float>, <8 x float>* %src, align 1
  %s1 = shufflevector <8 x float> %l1, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x float> %l1, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = fadd <4 x float> %s1, %s2
  store <4 x float> %a, <4 x float> *%dst
  ret void
}

; f16

define void @vld2_v2f16(<4 x half> *%src, <2 x half> *%dst) {
; CHECK-LABEL: vld2_v2f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r2, [r0]
; CHECK-NEXT:    ldr r0, [r0, #4]
; CHECK-NEXT:    vmov.32 q0[0], r2
; CHECK-NEXT:    vmov.32 q0[1], r0
; CHECK-NEXT:    vmovx.f16 s4, s1
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmovx.f16 s4, s0
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmov.16 q1[0], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov.16 q1[1], r0
; CHECK-NEXT:    vmov r0, s1
; CHECK-NEXT:    vmov.16 q0[0], r2
; CHECK-NEXT:    vmov.16 q0[1], r0
; CHECK-NEXT:    vadd.f16 q0, q0, q1
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    str r0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <4 x half>, <4 x half>* %src, align 2
  %s1 = shufflevector <4 x half> %l1, <4 x half> undef, <2 x i32> <i32 0, i32 2>
  %s2 = shufflevector <4 x half> %l1, <4 x half> undef, <2 x i32> <i32 1, i32 3>
  %a = fadd <2 x half> %s1, %s2
  store <2 x half> %a, <2 x half> *%dst
  ret void
}

define void @vld2_v4f16(<8 x half> *%src, <4 x half> *%dst) {
; CHECK-LABEL: vld2_v4f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r0]
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s8, s0
; CHECK-NEXT:    vmov r0, s1
; CHECK-NEXT:    vmov.16 q1[0], r2
; CHECK-NEXT:    vmov.16 q1[1], r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov.16 q1[2], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmovx.f16 s8, s1
; CHECK-NEXT:    vmovx.f16 s12, s2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmov.16 q2[0], r0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vmov.16 q2[1], r2
; CHECK-NEXT:    vmovx.f16 s12, s3
; CHECK-NEXT:    vmov.16 q2[2], r0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vmov.16 q2[3], r0
; CHECK-NEXT:    vmov r0, s3
; CHECK-NEXT:    vmov.16 q1[3], r0
; CHECK-NEXT:    vadd.f16 q0, q1, q2
; CHECK-NEXT:    vmov r2, s1
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    strd r0, r2, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x half>, <8 x half>* %src, align 2
  %s1 = shufflevector <8 x half> %l1, <8 x half> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x half> %l1, <8 x half> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = fadd <4 x half> %s1, %s2
  store <4 x half> %a, <4 x half> *%dst
  ret void
}

define void @vld2_v8f16(<16 x half> *%src, <8 x half> *%dst) {
; CHECK-LABEL: vld2_v8f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.16 {q0, q1}, [r0]
; CHECK-NEXT:    vadd.f16 q0, q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x half>, <16 x half>* %src, align 2
  %s1 = shufflevector <16 x half> %l1, <16 x half> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %s2 = shufflevector <16 x half> %l1, <16 x half> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = fadd <8 x half> %s1, %s2
  store <8 x half> %a, <8 x half> *%dst
  ret void
}

define void @vld2_v16f16(<32 x half> *%src, <16 x half> *%dst) {
; CHECK-LABEL: vld2_v16f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.16 {q0, q1}, [r0]!
; CHECK-NEXT:    vld20.16 {q2, q3}, [r0]
; CHECK-NEXT:    vadd.f16 q0, q0, q1
; CHECK-NEXT:    vld21.16 {q2, q3}, [r0]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vadd.f16 q2, q2, q3
; CHECK-NEXT:    vstrw.32 q2, [r1, #16]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <32 x half>, <32 x half>* %src, align 2
  %s1 = shufflevector <32 x half> %l1, <32 x half> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %s2 = shufflevector <32 x half> %l1, <32 x half> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %a = fadd <16 x half> %s1, %s2
  store <16 x half> %a, <16 x half> *%dst
  ret void
}

define void @vld2_v8f16_align1(<16 x half> *%src, <8 x half> *%dst) {
; CHECK-LABEL: vld2_v8f16_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8}
; CHECK-NEXT:    vpush {d8}
; CHECK-NEXT:    vldrb.u8 q2, [r0]
; CHECK-NEXT:    vldrb.u8 q1, [r0, #16]
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmovx.f16 s12, s8
; CHECK-NEXT:    vmov.16 q0[0], r2
; CHECK-NEXT:    vmov r3, s9
; CHECK-NEXT:    vmov.16 q0[1], r3
; CHECK-NEXT:    vmov r2, s10
; CHECK-NEXT:    vmov.16 q0[2], r2
; CHECK-NEXT:    vmov r2, s11
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vmovx.f16 s12, s9
; CHECK-NEXT:    vmovx.f16 s16, s10
; CHECK-NEXT:    vmov r2, s12
; CHECK-NEXT:    vmov.16 q3[0], r0
; CHECK-NEXT:    vmov.16 q3[1], r2
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmovx.f16 s8, s11
; CHECK-NEXT:    vmov.16 q3[2], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmovx.f16 s8, s4
; CHECK-NEXT:    vmov.16 q3[3], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmovx.f16 s8, s5
; CHECK-NEXT:    vmov.16 q3[4], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmovx.f16 s8, s6
; CHECK-NEXT:    vmov.16 q3[5], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmovx.f16 s8, s7
; CHECK-NEXT:    vmov.16 q3[6], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov.16 q3[7], r0
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    vadd.f16 q0, q0, q3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    vpop {d8}
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <16 x half>, <16 x half>* %src, align 1
  %s1 = shufflevector <16 x half> %l1, <16 x half> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %s2 = shufflevector <16 x half> %l1, <16 x half> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = fadd <8 x half> %s1, %s2
  store <8 x half> %a, <8 x half> *%dst
  ret void
}

; f64

define void @vld2_v2f64(<4 x double> *%src, <2 x double> *%dst) {
; CHECK-LABEL: vld2_v2f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vadd.f64 d1, d0, d1
; CHECK-NEXT:    vadd.f64 d0, d2, d3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <4 x double>, <4 x double>* %src, align 8
  %s1 = shufflevector <4 x double> %l1, <4 x double> undef, <2 x i32> <i32 0, i32 2>
  %s2 = shufflevector <4 x double> %l1, <4 x double> undef, <2 x i32> <i32 1, i32 3>
  %a = fadd <2 x double> %s1, %s2
  store <2 x double> %a, <2 x double> *%dst
  ret void
}

define void @vld2_v4f64(<8 x double> *%src, <4 x double> *%dst) {
; CHECK-LABEL: vld2_v4f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #32]
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vadd.f64 d1, d0, d1
; CHECK-NEXT:    vadd.f64 d0, d2, d3
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vadd.f64 d3, d2, d3
; CHECK-NEXT:    vstrw.32 q0, [r1, #16]
; CHECK-NEXT:    vadd.f64 d2, d4, d5
; CHECK-NEXT:    vstrw.32 q1, [r1]
; CHECK-NEXT:    bx lr
entry:
  %l1 = load <8 x double>, <8 x double>* %src, align 8
  %s1 = shufflevector <8 x double> %l1, <8 x double> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s2 = shufflevector <8 x double> %l1, <8 x double> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %a = fadd <4 x double> %s1, %s2
  store <4 x double> %a, <4 x double> *%dst
  ret void
}
