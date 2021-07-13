; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

; i16 -> i32

define arm_aapcs_vfpcc <4 x i32> @sext_i32_0246(<8 x i16> %src) {
; CHECK-LABEL: sext_i32_0246:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x i16> %src, <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %out = sext <4 x i16> %strided.vec to <4 x i32>
  ret <4 x i32> %out
}

define arm_aapcs_vfpcc <4 x i32> @sext_i32_0246_swapped(<8 x i16> %src) {
; CHECK-LABEL: sext_i32_0246_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vldrh.s32 q0, [r0]
; CHECK-NEXT:    vldrh.s32 q1, [r0, #8]
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    add sp, #16
; CHECK-NEXT:    bx lr
entry:
  %out = sext <8 x i16> %src to <8 x i32>
  %strided.vec = shufflevector <8 x i32> %out, <8 x i32> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  ret <4 x i32> %strided.vec
}

define arm_aapcs_vfpcc <4 x i32> @sext_i32_1357(<8 x i16> %src) {
; CHECK-LABEL: sext_i32_1357:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x i16> %src, <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %out = sext <4 x i16> %strided.vec to <4 x i32>
  ret <4 x i32> %out
}

define arm_aapcs_vfpcc <4 x i32> @sext_i32_1357_swapped(<8 x i16> %src) {
; CHECK-LABEL: sext_i32_1357_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vldrh.s32 q2, [r0]
; CHECK-NEXT:    vldrh.s32 q1, [r0, #8]
; CHECK-NEXT:    vmov.f32 s0, s9
; CHECK-NEXT:    vmov.f32 s1, s11
; CHECK-NEXT:    vmov.f32 s2, s5
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    add sp, #16
; CHECK-NEXT:    bx lr
entry:
  %out = sext <8 x i16> %src to <8 x i32>
  %strided.vec = shufflevector <8 x i32> %out, <8 x i32> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  ret <4 x i32> %strided.vec
}

define arm_aapcs_vfpcc <8 x i32> @sext_i32_02468101214(<16 x i16> %src) {
; CHECK-LABEL: sext_i32_02468101214:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i16> %src, <16 x i16> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %out = sext <8 x i16> %strided.vec to <8 x i32>
  ret <8 x i32> %out
}

define arm_aapcs_vfpcc <8 x i32> @sext_i32_02468101214_swapped(<16 x i16> %src) {
; CHECK-LABEL: sext_i32_02468101214_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #32
; CHECK-NEXT:    sub sp, #32
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    add r1, sp, #16
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vstrw.32 q1, [r1]
; CHECK-NEXT:    vldrh.s32 q0, [r0]
; CHECK-NEXT:    vldrh.s32 q1, [r0, #8]
; CHECK-NEXT:    vldrh.s32 q2, [r1, #8]
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vmov.f32 s5, s6
; CHECK-NEXT:    vmov.f32 s6, s8
; CHECK-NEXT:    vmov.f32 s7, s10
; CHECK-NEXT:    add sp, #32
; CHECK-NEXT:    bx lr
entry:
  %out = sext <16 x i16> %src to <16 x i32>
  %strided.vec = shufflevector <16 x i32> %out, <16 x i32> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  ret <8 x i32> %strided.vec
}

define arm_aapcs_vfpcc <8 x i32> @sext_i32_13579111315(<16 x i16> %src) {
; CHECK-LABEL: sext_i32_13579111315:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.s16 q0, q0
; CHECK-NEXT:    vmovlt.s16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i16> %src, <16 x i16> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %out = sext <8 x i16> %strided.vec to <8 x i32>
  ret <8 x i32> %out
}

define arm_aapcs_vfpcc <8 x i32> @sext_i32_13579111315_swapped(<16 x i16> %src) {
; CHECK-LABEL: sext_i32_13579111315_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #32
; CHECK-NEXT:    sub sp, #32
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    add r1, sp, #16
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vstrw.32 q1, [r1]
; CHECK-NEXT:    vldrh.s32 q2, [r0]
; CHECK-NEXT:    vldrh.s32 q1, [r0, #8]
; CHECK-NEXT:    vldrh.s32 q3, [r1]
; CHECK-NEXT:    vmov.f32 s0, s9
; CHECK-NEXT:    vmov.f32 s1, s11
; CHECK-NEXT:    vldrh.s32 q2, [r1, #8]
; CHECK-NEXT:    vmov.f32 s2, s5
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    vmov.f32 s4, s13
; CHECK-NEXT:    vmov.f32 s5, s15
; CHECK-NEXT:    vmov.f32 s6, s9
; CHECK-NEXT:    vmov.f32 s7, s11
; CHECK-NEXT:    add sp, #32
; CHECK-NEXT:    bx lr
entry:
  %out = sext <16 x i16> %src to <16 x i32>
  %strided.vec = shufflevector <16 x i32> %out, <16 x i32> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  ret <8 x i32> %strided.vec
}

define arm_aapcs_vfpcc <4 x i32> @zext_i32_0246(<8 x i16> %src) {
; CHECK-LABEL: zext_i32_0246:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x i16> %src, <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %out = zext <4 x i16> %strided.vec to <4 x i32>
  ret <4 x i32> %out
}

define arm_aapcs_vfpcc <4 x i32> @zext_i32_0246_swapped(<8 x i16> %src) {
; CHECK-LABEL: zext_i32_0246_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q1, [r0, #8]
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    add sp, #16
; CHECK-NEXT:    bx lr
entry:
  %out = zext <8 x i16> %src to <8 x i32>
  %strided.vec = shufflevector <8 x i32> %out, <8 x i32> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  ret <4 x i32> %strided.vec
}

define arm_aapcs_vfpcc <4 x i32> @zext_i32_1357(<8 x i16> %src) {
; CHECK-LABEL: zext_i32_1357:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.u16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x i16> %src, <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %out = zext <4 x i16> %strided.vec to <4 x i32>
  ret <4 x i32> %out
}

define arm_aapcs_vfpcc <4 x i32> @zext_i32_1357_swapped(<8 x i16> %src) {
; CHECK-LABEL: zext_i32_1357_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q2, [r0]
; CHECK-NEXT:    vldrh.u32 q1, [r0, #8]
; CHECK-NEXT:    vmov.f32 s0, s9
; CHECK-NEXT:    vmov.f32 s1, s11
; CHECK-NEXT:    vmov.f32 s2, s5
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    add sp, #16
; CHECK-NEXT:    bx lr
entry:
  %out = zext <8 x i16> %src to <8 x i32>
  %strided.vec = shufflevector <8 x i32> %out, <8 x i32> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  ret <4 x i32> %strided.vec
}

define arm_aapcs_vfpcc <8 x i32> @zext_i32_02468101214(<16 x i16> %src) {
; CHECK-LABEL: zext_i32_02468101214:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u16 q0, q0
; CHECK-NEXT:    vmovlb.u16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i16> %src, <16 x i16> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %out = zext <8 x i16> %strided.vec to <8 x i32>
  ret <8 x i32> %out
}

define arm_aapcs_vfpcc <8 x i32> @zext_i32_02468101214_swapped(<16 x i16> %src) {
; CHECK-LABEL: zext_i32_02468101214_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #32
; CHECK-NEXT:    sub sp, #32
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    add r1, sp, #16
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vstrw.32 q1, [r1]
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q1, [r0, #8]
; CHECK-NEXT:    vldrh.u32 q2, [r1, #8]
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vmov.f32 s5, s6
; CHECK-NEXT:    vmov.f32 s6, s8
; CHECK-NEXT:    vmov.f32 s7, s10
; CHECK-NEXT:    add sp, #32
; CHECK-NEXT:    bx lr
entry:
  %out = zext <16 x i16> %src to <16 x i32>
  %strided.vec = shufflevector <16 x i32> %out, <16 x i32> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  ret <8 x i32> %strided.vec
}

define arm_aapcs_vfpcc <8 x i32> @zext_i32_13579111315(<16 x i16> %src) {
; CHECK-LABEL: zext_i32_13579111315:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.u16 q0, q0
; CHECK-NEXT:    vmovlt.u16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i16> %src, <16 x i16> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %out = zext <8 x i16> %strided.vec to <8 x i32>
  ret <8 x i32> %out
}

define arm_aapcs_vfpcc <8 x i32> @zext_i32_13579111315_swapped(<16 x i16> %src) {
; CHECK-LABEL: zext_i32_13579111315_swapped:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #32
; CHECK-NEXT:    sub sp, #32
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    add r1, sp, #16
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vstrw.32 q1, [r1]
; CHECK-NEXT:    vldrh.u32 q2, [r0]
; CHECK-NEXT:    vldrh.u32 q1, [r0, #8]
; CHECK-NEXT:    vldrh.u32 q3, [r1]
; CHECK-NEXT:    vmov.f32 s0, s9
; CHECK-NEXT:    vmov.f32 s1, s11
; CHECK-NEXT:    vldrh.u32 q2, [r1, #8]
; CHECK-NEXT:    vmov.f32 s2, s5
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    vmov.f32 s4, s13
; CHECK-NEXT:    vmov.f32 s5, s15
; CHECK-NEXT:    vmov.f32 s6, s9
; CHECK-NEXT:    vmov.f32 s7, s11
; CHECK-NEXT:    add sp, #32
; CHECK-NEXT:    bx lr
entry:
  %out = zext <16 x i16> %src to <16 x i32>
  %strided.vec = shufflevector <16 x i32> %out, <16 x i32> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  ret <8 x i32> %strided.vec
}

define arm_aapcs_vfpcc <8 x i32> @sext_i32_02481357(<8 x i16> %src) {
; CHECK-LABEL: sext_i32_02481357:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s16 q2, q0
; CHECK-NEXT:    vmovlt.s16 q1, q0
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x i16> %src, <8 x i16> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 1, i32 3, i32 5, i32 7>
  %out = sext <8 x i16> %strided.vec to <8 x i32>
  ret <8 x i32> %out
}


; i8 -> i16

define arm_aapcs_vfpcc <8 x i16> @sext_i16_02468101214(<16 x i8> %src) {
; CHECK-LABEL: sext_i16_02468101214:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i8> %src, <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %out = sext <8 x i8> %strided.vec to <8 x i16>
  ret <8 x i16> %out
}

define arm_aapcs_vfpcc <8 x i16> @sext_i16_13579111315(<16 x i8> %src) {
; CHECK-LABEL: sext_i16_13579111315:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.s8 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i8> %src, <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %out = sext <8 x i8> %strided.vec to <8 x i16>
  ret <8 x i16> %out
}

define arm_aapcs_vfpcc <16 x i16> @sext_i16_024681012141618202224262830(<32 x i8> %src) {
; CHECK-LABEL: sext_i16_024681012141618202224262830:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s8 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <32 x i8> %src, <32 x i8> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %out = sext <16 x i8> %strided.vec to <16 x i16>
  ret <16 x i16> %out
}

define arm_aapcs_vfpcc <16 x i16> @sext_i16_135791113151719212325272931(<32 x i8> %src) {
; CHECK-LABEL: sext_i16_135791113151719212325272931:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.s8 q0, q0
; CHECK-NEXT:    vmovlt.s8 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <32 x i8> %src, <32 x i8> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %out = sext <16 x i8> %strided.vec to <16 x i16>
  ret <16 x i16> %out
}

define arm_aapcs_vfpcc <8 x i16> @zext_i16_02468101214(<16 x i8> %src) {
; CHECK-LABEL: zext_i16_02468101214:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u8 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i8> %src, <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %out = zext <8 x i8> %strided.vec to <8 x i16>
  ret <8 x i16> %out
}

define arm_aapcs_vfpcc <8 x i16> @zext_i16_13579111315(<16 x i8> %src) {
; CHECK-LABEL: zext_i16_13579111315:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.u8 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x i8> %src, <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %out = zext <8 x i8> %strided.vec to <8 x i16>
  ret <8 x i16> %out
}

define arm_aapcs_vfpcc <16 x i16> @zext_i16_024681012141618202224262830(<32 x i8> %src) {
; CHECK-LABEL: zext_i16_024681012141618202224262830:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u8 q0, q0
; CHECK-NEXT:    vmovlb.u8 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <32 x i8> %src, <32 x i8> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %out = zext <16 x i8> %strided.vec to <16 x i16>
  ret <16 x i16> %out
}

define arm_aapcs_vfpcc <16 x i16> @zext_i16_135791113151719212325272931(<32 x i8> %src) {
; CHECK-LABEL: zext_i16_135791113151719212325272931:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlt.u8 q0, q0
; CHECK-NEXT:    vmovlt.u8 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <32 x i8> %src, <32 x i8> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %out = zext <16 x i8> %strided.vec to <16 x i16>
  ret <16 x i16> %out
}


; f16 -> f32

define arm_aapcs_vfpcc <4 x float> @fpext_0246(<8 x half> %src) {
; CHECK-LABEL: fpext_0246:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f32.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x half> %src, <8 x half> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %out = fpext <4 x half> %strided.vec to <4 x float>
  ret <4 x float> %out
}

define arm_aapcs_vfpcc <4 x float> @fpext_1357(<8 x half> %src) {
; CHECK-LABEL: fpext_1357:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtt.f32.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x half> %src, <8 x half> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %out = fpext <4 x half> %strided.vec to <4 x float>
  ret <4 x float> %out
}

define arm_aapcs_vfpcc <8 x float> @fpext_02468101214(<16 x half> %src) {
; CHECK-LABEL: fpext_02468101214:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f32.f16 q0, q0
; CHECK-NEXT:    vcvtb.f32.f16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x half> %src, <16 x half> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %out = fpext <8 x half> %strided.vec to <8 x float>
  ret <8 x float> %out
}

define arm_aapcs_vfpcc <8 x float> @fpext_13579111315(<16 x half> %src) {
; CHECK-LABEL: fpext_13579111315:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtt.f32.f16 q0, q0
; CHECK-NEXT:    vcvtt.f32.f16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <16 x half> %src, <16 x half> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %out = fpext <8 x half> %strided.vec to <8 x float>
  ret <8 x float> %out
}
