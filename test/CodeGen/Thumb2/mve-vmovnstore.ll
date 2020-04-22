; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc void @vmovn32_trunc1(<4 x i32> %src1, <4 x i32> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn32_trunc1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i32 q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <4 x i32> %src1, <4 x i32> %src2, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  %out = trunc <8 x i32> %strided.vec to <8 x i16>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn32_trunc2(<4 x i32> %src1, <4 x i32> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn32_trunc2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i32 q1, q0
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <4 x i32> %src1, <4 x i32> %src2, <8 x i32> <i32 4, i32 0, i32 5, i32 1, i32 6, i32 2, i32 7, i32 3>
  %out = trunc <8 x i32> %strided.vec to <8 x i16>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn16_trunc1(<8 x i16> %src1, <8 x i16> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn16_trunc1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i16 q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x i16> %src1, <8 x i16> %src2, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  %out = trunc <16 x i16> %strided.vec to <16 x i8>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn16_trunc2(<8 x i16> %src1, <8 x i16> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn16_trunc2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i16 q1, q0
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x i16> %src1, <8 x i16> %src2, <16 x i32> <i32 8, i32 0, i32 9, i32 1, i32 10, i32 2, i32 11, i32 3, i32 12, i32 4, i32 13, i32 5, i32 14, i32 6, i32 15, i32 7>
  %out = trunc <16 x i16> %strided.vec to <16 x i8>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}


define arm_aapcs_vfpcc void @vmovn64_t1(<2 x i64> %src1, <2 x i64> %src2, <2 x i64> *%dest) {
; CHECK-LABEL: vmovn64_t1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s5
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <2 x i64> %src1, <2 x i64> %src2, <2 x i32> <i32 0, i32 2>
  store <2 x i64> %out, <2 x i64> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn64_t2(<2 x i64> %src1, <2 x i64> %src2, <2 x i64> *%dest) {
; CHECK-LABEL: vmovn64_t2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s6, s0
; CHECK-NEXT:    vmov.f32 s7, s1
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <2 x i64> %src1, <2 x i64> %src2, <2 x i32> <i32 2, i32 0>
  store <2 x i64> %out, <2 x i64> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn64_b1(<2 x i64> %src1, <2 x i64> %src2, <2 x i64> *%dest) {
; CHECK-LABEL: vmovn64_b1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s2, s6
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <2 x i64> %src1, <2 x i64> %src2, <2 x i32> <i32 0, i32 3>
  store <2 x i64> %out, <2 x i64> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn64_b2(<2 x i64> %src1, <2 x i64> %src2, <2 x i64> *%dest) {
; CHECK-LABEL: vmovn64_b2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s8, s6
; CHECK-NEXT:    vmov.f32 s9, s7
; CHECK-NEXT:    vmov.f32 s10, s0
; CHECK-NEXT:    vmov.f32 s11, s1
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <2 x i64> %src1, <2 x i64> %src2, <2 x i32> <i32 3, i32 0>
  store <2 x i64> %out, <2 x i64> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn64_b3(<2 x i64> %src1, <2 x i64> %src2, <2 x i64> *%dest) {
; CHECK-LABEL: vmovn64_b3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s8, s2
; CHECK-NEXT:    vmov.f32 s9, s3
; CHECK-NEXT:    vmov.f32 s10, s4
; CHECK-NEXT:    vmov.f32 s11, s5
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <2 x i64> %src1, <2 x i64> %src2, <2 x i32> <i32 1, i32 2>
  store <2 x i64> %out, <2 x i64> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn64_b4(<2 x i64> %src1, <2 x i64> %src2, <2 x i64> *%dest) {
; CHECK-LABEL: vmovn64_b4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s6, s2
; CHECK-NEXT:    vmov.f32 s7, s3
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <2 x i64> %src1, <2 x i64> %src2, <2 x i32> <i32 2, i32 1>
  store <2 x i64> %out, <2 x i64> *%dest, align 8
  ret void
}



define arm_aapcs_vfpcc void @vmovn32_t1(<4 x i32> %src1, <4 x i32> %src2, <4 x i32> *%dest) {
; CHECK-LABEL: vmovn32_t1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s1, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <4 x i32> %src1, <4 x i32> %src2, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  store <4 x i32> %out, <4 x i32> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn32_t2(<4 x i32> %src1, <4 x i32> %src2, <4 x i32> *%dest) {
; CHECK-LABEL: vmovn32_t2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s5, s0
; CHECK-NEXT:    vmov.f32 s7, s2
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <4 x i32> %src1, <4 x i32> %src2, <4 x i32> <i32 4, i32 0, i32 6, i32 2>
  store <4 x i32> %out, <4 x i32> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn32_b1(<4 x i32> %src1, <4 x i32> %src2, <4 x i32> *%dest) {
; CHECK-LABEL: vmovn32_b1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s1, s5
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <4 x i32> %src1, <4 x i32> %src2, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  store <4 x i32> %out, <4 x i32> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn32_b2(<4 x i32> %src1, <4 x i32> %src2, <4 x i32> *%dest) {
; CHECK-LABEL: vmovn32_b2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s8, s5
; CHECK-NEXT:    vmov.f32 s9, s0
; CHECK-NEXT:    vmov.f32 s10, s7
; CHECK-NEXT:    vmov.f32 s11, s2
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <4 x i32> %src1, <4 x i32> %src2, <4 x i32> <i32 5, i32 0, i32 7, i32 2>
  store <4 x i32> %out, <4 x i32> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn32_b3(<4 x i32> %src1, <4 x i32> %src2, <4 x i32> *%dest) {
; CHECK-LABEL: vmovn32_b3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s8, s1
; CHECK-NEXT:    vmov.f32 s9, s4
; CHECK-NEXT:    vmov.f32 s10, s3
; CHECK-NEXT:    vmov.f32 s11, s6
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <4 x i32> %src1, <4 x i32> %src2, <4 x i32> <i32 1, i32 4, i32 3, i32 6>
  store <4 x i32> %out, <4 x i32> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn32_b4(<4 x i32> %src1, <4 x i32> %src2, <4 x i32> *%dest) {
; CHECK-LABEL: vmovn32_b4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s5, s1
; CHECK-NEXT:    vmov.f32 s7, s3
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <4 x i32> %src1, <4 x i32> %src2, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  store <4 x i32> %out, <4 x i32> *%dest, align 8
  ret void
}




define arm_aapcs_vfpcc void @vmovn16_t1(<8 x i16> %src1, <8 x i16> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn16_t1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i32 q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <8 x i16> %src1, <8 x i16> %src2, <8 x i32> <i32 0, i32 8, i32 2, i32 10, i32 4, i32 12, i32 6, i32 14>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn16_t2(<8 x i16> %src1, <8 x i16> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn16_t2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i32 q1, q0
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <8 x i16> %src1, <8 x i16> %src2, <8 x i32> <i32 8, i32 0, i32 10, i32 2, i32 12, i32 4, i32 14, i32 6>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn16_b1(<8 x i16> %src1, <8 x i16> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn16_b1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnb.i32 q1, q0
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <8 x i16> %src1, <8 x i16> %src2, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 4, i32 13, i32 6, i32 15>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn16_b2(<8 x i16> %src1, <8 x i16> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn16_b2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u16 r1, q1[1]
; CHECK-NEXT:    vmov.16 q2[0], r1
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vmov.16 q2[1], r1
; CHECK-NEXT:    vmov.u16 r1, q1[3]
; CHECK-NEXT:    vmov.16 q2[2], r1
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    vmov.16 q2[3], r1
; CHECK-NEXT:    vmov.u16 r1, q1[5]
; CHECK-NEXT:    vmov.16 q2[4], r1
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    vmov.16 q2[5], r1
; CHECK-NEXT:    vmov.u16 r1, q1[7]
; CHECK-NEXT:    vmov.16 q2[6], r1
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    vmov.16 q2[7], r1
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <8 x i16> %src1, <8 x i16> %src2, <8 x i32> <i32 9, i32 0, i32 11, i32 2, i32 13, i32 4, i32 15, i32 6>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn16_b3(<8 x i16> %src1, <8 x i16> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn16_b3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    vmov.16 q2[0], r1
; CHECK-NEXT:    vmov.u16 r1, q1[0]
; CHECK-NEXT:    vmov.16 q2[1], r1
; CHECK-NEXT:    vmov.u16 r1, q0[3]
; CHECK-NEXT:    vmov.16 q2[2], r1
; CHECK-NEXT:    vmov.u16 r1, q1[2]
; CHECK-NEXT:    vmov.16 q2[3], r1
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    vmov.16 q2[4], r1
; CHECK-NEXT:    vmov.u16 r1, q1[4]
; CHECK-NEXT:    vmov.16 q2[5], r1
; CHECK-NEXT:    vmov.u16 r1, q0[7]
; CHECK-NEXT:    vmov.16 q2[6], r1
; CHECK-NEXT:    vmov.u16 r1, q1[6]
; CHECK-NEXT:    vmov.16 q2[7], r1
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <8 x i16> %src1, <8 x i16> %src2, <8 x i32> <i32 1, i32 8, i32 3, i32 10, i32 5, i32 12, i32 7, i32 14>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn16_b4(<8 x i16> %src1, <8 x i16> %src2, <8 x i16> *%dest) {
; CHECK-LABEL: vmovn16_b4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnb.i32 q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <8 x i16> %src1, <8 x i16> %src2, <8 x i32> <i32 8, i32 1, i32 10, i32 3, i32 12, i32 5, i32 14, i32 7>
  store <8 x i16> %out, <8 x i16> *%dest, align 8
  ret void
}


define arm_aapcs_vfpcc void @vmovn8_b1(<16 x i8> %src1, <16 x i8> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn8_b1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i16 q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <16 x i8> %src1, <16 x i8> %src2, <16 x i32> <i32 0, i32 16, i32 2, i32 18, i32 4, i32 20, i32 6, i32 22, i32 8, i32 24, i32 10, i32 26, i32 12, i32 28, i32 14, i32 30>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn8_b2(<16 x i8> %src1, <16 x i8> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn8_b2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnt.i16 q1, q0
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <16 x i8> %src1, <16 x i8> %src2, <16 x i32> <i32 16, i32 0, i32 18, i32 2, i32 20, i32 4, i32 22, i32 6, i32 24, i32 8, i32 26, i32 10, i32 28, i32 12, i32 30, i32 14>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn8_t1(<16 x i8> %src1, <16 x i8> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn8_t1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnb.i16 q1, q0
; CHECK-NEXT:    vstrw.32 q1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <16 x i8> %src1, <16 x i8> %src2, <16 x i32> <i32 0, i32 17, i32 2, i32 19, i32 4, i32 21, i32 6, i32 23, i32 8, i32 25, i32 10, i32 27, i32 12, i32 29, i32 14, i32 31>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn8_t2(<16 x i8> %src1, <16 x i8> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn8_t2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u8 r1, q1[1]
; CHECK-NEXT:    vmov.8 q2[0], r1
; CHECK-NEXT:    vmov.u8 r1, q0[0]
; CHECK-NEXT:    vmov.8 q2[1], r1
; CHECK-NEXT:    vmov.u8 r1, q1[3]
; CHECK-NEXT:    vmov.8 q2[2], r1
; CHECK-NEXT:    vmov.u8 r1, q0[2]
; CHECK-NEXT:    vmov.8 q2[3], r1
; CHECK-NEXT:    vmov.u8 r1, q1[5]
; CHECK-NEXT:    vmov.8 q2[4], r1
; CHECK-NEXT:    vmov.u8 r1, q0[4]
; CHECK-NEXT:    vmov.8 q2[5], r1
; CHECK-NEXT:    vmov.u8 r1, q1[7]
; CHECK-NEXT:    vmov.8 q2[6], r1
; CHECK-NEXT:    vmov.u8 r1, q0[6]
; CHECK-NEXT:    vmov.8 q2[7], r1
; CHECK-NEXT:    vmov.u8 r1, q1[9]
; CHECK-NEXT:    vmov.8 q2[8], r1
; CHECK-NEXT:    vmov.u8 r1, q0[8]
; CHECK-NEXT:    vmov.8 q2[9], r1
; CHECK-NEXT:    vmov.u8 r1, q1[11]
; CHECK-NEXT:    vmov.8 q2[10], r1
; CHECK-NEXT:    vmov.u8 r1, q0[10]
; CHECK-NEXT:    vmov.8 q2[11], r1
; CHECK-NEXT:    vmov.u8 r1, q1[13]
; CHECK-NEXT:    vmov.8 q2[12], r1
; CHECK-NEXT:    vmov.u8 r1, q0[12]
; CHECK-NEXT:    vmov.8 q2[13], r1
; CHECK-NEXT:    vmov.u8 r1, q1[15]
; CHECK-NEXT:    vmov.8 q2[14], r1
; CHECK-NEXT:    vmov.u8 r1, q0[14]
; CHECK-NEXT:    vmov.8 q2[15], r1
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <16 x i8> %src1, <16 x i8> %src2, <16 x i32> <i32 17, i32 0, i32 19, i32 2, i32 21, i32 4, i32 23, i32 6, i32 25, i32 8, i32 27, i32 10, i32 29, i32 12, i32 31, i32 14>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn8_t3(<16 x i8> %src1, <16 x i8> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn8_t3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u8 r1, q0[1]
; CHECK-NEXT:    vmov.8 q2[0], r1
; CHECK-NEXT:    vmov.u8 r1, q1[0]
; CHECK-NEXT:    vmov.8 q2[1], r1
; CHECK-NEXT:    vmov.u8 r1, q0[3]
; CHECK-NEXT:    vmov.8 q2[2], r1
; CHECK-NEXT:    vmov.u8 r1, q1[2]
; CHECK-NEXT:    vmov.8 q2[3], r1
; CHECK-NEXT:    vmov.u8 r1, q0[5]
; CHECK-NEXT:    vmov.8 q2[4], r1
; CHECK-NEXT:    vmov.u8 r1, q1[4]
; CHECK-NEXT:    vmov.8 q2[5], r1
; CHECK-NEXT:    vmov.u8 r1, q0[7]
; CHECK-NEXT:    vmov.8 q2[6], r1
; CHECK-NEXT:    vmov.u8 r1, q1[6]
; CHECK-NEXT:    vmov.8 q2[7], r1
; CHECK-NEXT:    vmov.u8 r1, q0[9]
; CHECK-NEXT:    vmov.8 q2[8], r1
; CHECK-NEXT:    vmov.u8 r1, q1[8]
; CHECK-NEXT:    vmov.8 q2[9], r1
; CHECK-NEXT:    vmov.u8 r1, q0[11]
; CHECK-NEXT:    vmov.8 q2[10], r1
; CHECK-NEXT:    vmov.u8 r1, q1[10]
; CHECK-NEXT:    vmov.8 q2[11], r1
; CHECK-NEXT:    vmov.u8 r1, q0[13]
; CHECK-NEXT:    vmov.8 q2[12], r1
; CHECK-NEXT:    vmov.u8 r1, q1[12]
; CHECK-NEXT:    vmov.8 q2[13], r1
; CHECK-NEXT:    vmov.u8 r1, q0[15]
; CHECK-NEXT:    vmov.8 q2[14], r1
; CHECK-NEXT:    vmov.u8 r1, q1[14]
; CHECK-NEXT:    vmov.8 q2[15], r1
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <16 x i8> %src1, <16 x i8> %src2, <16 x i32> <i32 1, i32 16, i32 3, i32 18, i32 5, i32 20, i32 7, i32 22, i32 9, i32 24, i32 11, i32 26, i32 13, i32 28, i32 15, i32 30>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}

define arm_aapcs_vfpcc void @vmovn8_t4(<16 x i8> %src1, <16 x i8> %src2, <16 x i8> *%dest) {
; CHECK-LABEL: vmovn8_t4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovnb.i16 q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %out = shufflevector <16 x i8> %src1, <16 x i8> %src2, <16 x i32> <i32 16, i32 1, i32 18, i32 3, i32 20, i32 5, i32 22, i32 7, i32 24, i32 9, i32 26, i32 11, i32 28, i32 13, i32 30, i32 15>
  store <16 x i8> %out, <16 x i8> *%dest, align 8
  ret void
}
