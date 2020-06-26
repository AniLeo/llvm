; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc <4 x float> @fpext_4(<4 x half> %src1) {
; CHECK-LABEL: fpext_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtt.f32.f16 s7, s1
; CHECK-NEXT:    vcvtb.f32.f16 s6, s1
; CHECK-NEXT:    vcvtt.f32.f16 s5, s0
; CHECK-NEXT:    vcvtb.f32.f16 s4, s0
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %out = fpext <4 x half> %src1 to <4 x float>
  ret <4 x float> %out
}

define arm_aapcs_vfpcc <8 x float> @fpext_8(<8 x half> %src1) {
; CHECK-LABEL: fpext_8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtt.f32.f16 s11, s1
; CHECK-NEXT:    vcvtb.f32.f16 s10, s1
; CHECK-NEXT:    vcvtt.f32.f16 s9, s0
; CHECK-NEXT:    vcvtb.f32.f16 s8, s0
; CHECK-NEXT:    vcvtt.f32.f16 s7, s3
; CHECK-NEXT:    vcvtb.f32.f16 s6, s3
; CHECK-NEXT:    vcvtt.f32.f16 s5, s2
; CHECK-NEXT:    vcvtb.f32.f16 s4, s2
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %out = fpext <8 x half> %src1 to <8 x float>
  ret <8 x float> %out
}


define arm_aapcs_vfpcc <4 x half> @fptrunc_4(<4 x float> %src1) {
; CHECK-LABEL: fptrunc_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 s4, s0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vcvtb.f16.f32 s4, s1
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    vmov.16 q1[0], r0
; CHECK-NEXT:    vcvtb.f16.f32 s8, s2
; CHECK-NEXT:    vmov.16 q1[1], r1
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vcvtb.f16.f32 s0, s3
; CHECK-NEXT:    vmov.16 q1[2], r0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vmov.16 q1[3], r0
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %out = fptrunc <4 x float> %src1 to <4 x half>
  ret <4 x half> %out
}

define arm_aapcs_vfpcc <8 x half> @fptrunc_8(<8 x float> %src1) {
; CHECK-LABEL: fptrunc_8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov q2, q0
; CHECK-NEXT:    vcvtb.f16.f32 s0, s8
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vcvtb.f16.f32 s0, s9
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vcvtb.f16.f32 s12, s10
; CHECK-NEXT:    vmov.16 q0[1], r1
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vcvtb.f16.f32 s8, s11
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vcvtb.f16.f32 s8, s4
; CHECK-NEXT:    vmov.16 q0[3], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vcvtb.f16.f32 s8, s5
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vcvtb.f16.f32 s8, s6
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vcvtb.f16.f32 s4, s7
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    bx lr
entry:
  %out = fptrunc <8 x float> %src1 to <8 x half>
  ret <8 x half> %out
}


define arm_aapcs_vfpcc <8 x half> @shuffle_trunc1(<4 x float> %src1, <4 x float> %src2) {
; CHECK-LABEL: shuffle_trunc1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vcvtt.f16.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <4 x float> %src1, <4 x float> %src2, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  %out = fptrunc <8 x float> %strided.vec to <8 x half>
  ret <8 x half> %out
}

define arm_aapcs_vfpcc <8 x half> @shuffle_trunc2(<4 x float> %src1, <4 x float> %src2) {
; CHECK-LABEL: shuffle_trunc2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q1, q1
; CHECK-NEXT:    vcvtt.f16.f32 q1, q0
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <4 x float> %src1, <4 x float> %src2, <8 x i32> <i32 4, i32 0, i32 5, i32 1, i32 6, i32 2, i32 7, i32 3>
  %out = fptrunc <8 x float> %strided.vec to <8 x half>
  ret <8 x half> %out
}

define arm_aapcs_vfpcc <16 x half> @shuffle_trunc3(<8 x float> %src1, <8 x float> %src2) {
; CHECK-LABEL: shuffle_trunc3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vcvtb.f16.f32 q1, q1
; CHECK-NEXT:    vcvtt.f16.f32 q0, q2
; CHECK-NEXT:    vcvtt.f16.f32 q1, q3
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x float> %src1, <8 x float> %src2, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  %out = fptrunc <16 x float> %strided.vec to <16 x half>
  ret <16 x half> %out
}

define arm_aapcs_vfpcc <16 x half> @shuffle_trunc4(<8 x float> %src1, <8 x float> %src2) {
; CHECK-LABEL: shuffle_trunc4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q2, q2
; CHECK-NEXT:    vcvtb.f16.f32 q3, q3
; CHECK-NEXT:    vcvtt.f16.f32 q2, q0
; CHECK-NEXT:    vcvtt.f16.f32 q3, q1
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    vmov q1, q3
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x float> %src1, <8 x float> %src2, <16 x i32> <i32 8, i32 0, i32 9, i32 1, i32 10, i32 2, i32 11, i32 3, i32 12, i32 4, i32 13, i32 5, i32 14, i32 6, i32 15, i32 7>
  %out = fptrunc <16 x float> %strided.vec to <16 x half>
  ret <16 x half> %out
}

define arm_aapcs_vfpcc <8 x half> @shuffle_trunc5(<4 x float> %src1, <4 x float> %src2) {
; CHECK-LABEL: shuffle_trunc5:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vcvtt.f16.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %out1 = fptrunc <4 x float> %src1 to <4 x half>
  %out2 = fptrunc <4 x float> %src2 to <4 x half>
  %s = shufflevector <4 x half> %out1, <4 x half> %out2, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  ret <8 x half> %s
}

define arm_aapcs_vfpcc <8 x half> @shuffle_trunc6(<4 x float> %src1, <4 x float> %src2) {
; CHECK-LABEL: shuffle_trunc6:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q1, q1
; CHECK-NEXT:    vcvtt.f16.f32 q1, q0
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %out1 = fptrunc <4 x float> %src1 to <4 x half>
  %out2 = fptrunc <4 x float> %src2 to <4 x half>
  %s = shufflevector <4 x half> %out1, <4 x half> %out2, <8 x i32> <i32 4, i32 0, i32 5, i32 1, i32 6, i32 2, i32 7, i32 3>
  ret <8 x half> %s
}

define arm_aapcs_vfpcc <16 x half> @shuffle_trunc7(<8 x float> %src1, <8 x float> %src2) {
; CHECK-LABEL: shuffle_trunc7:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vcvtb.f16.f32 q1, q1
; CHECK-NEXT:    vcvtt.f16.f32 q0, q2
; CHECK-NEXT:    vcvtt.f16.f32 q1, q3
; CHECK-NEXT:    bx lr
entry:
  %out1 = fptrunc <8 x float> %src1 to <8 x half>
  %out2 = fptrunc <8 x float> %src2 to <8 x half>
  %s = shufflevector <8 x half> %out1, <8 x half> %out2, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  ret <16 x half> %s
}

define arm_aapcs_vfpcc <16 x half> @shuffle_trunc8(<8 x float> %src1, <8 x float> %src2) {
; CHECK-LABEL: shuffle_trunc8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q2, q2
; CHECK-NEXT:    vcvtb.f16.f32 q3, q3
; CHECK-NEXT:    vcvtt.f16.f32 q2, q0
; CHECK-NEXT:    vcvtt.f16.f32 q3, q1
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    vmov q1, q3
; CHECK-NEXT:    bx lr
entry:
  %out1 = fptrunc <8 x float> %src1 to <8 x half>
  %out2 = fptrunc <8 x float> %src2 to <8 x half>
  %s = shufflevector <8 x half> %out1, <8 x half> %out2, <16 x i32> <i32 8, i32 0, i32 9, i32 1, i32 10, i32 2, i32 11, i32 3, i32 12, i32 4, i32 13, i32 5, i32 14, i32 6, i32 15, i32 7>
  ret <16 x half> %s
}




define arm_aapcs_vfpcc <4 x float> @load_ext_4(<4 x half>* %src) {
; CHECK-LABEL: load_ext_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    vcvtb.f32.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %wide.load = load <4 x half>, <4 x half>* %src, align 4
  %e = fpext <4 x half> %wide.load to <4 x float>
  ret <4 x float> %e
}

define arm_aapcs_vfpcc <8 x float> @load_ext_8(<8 x half>* %src) {
; CHECK-LABEL: load_ext_8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q1, [r0, #8]
; CHECK-NEXT:    vcvtb.f32.f16 q0, q0
; CHECK-NEXT:    vcvtb.f32.f16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %wide.load = load <8 x half>, <8 x half>* %src, align 4
  %e = fpext <8 x half> %wide.load to <8 x float>
  ret <8 x float> %e
}

define arm_aapcs_vfpcc <16 x float> @load_ext_16(<16 x half>* %src) {
; CHECK-LABEL: load_ext_16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q1, [r0, #8]
; CHECK-NEXT:    vldrh.u32 q2, [r0, #16]
; CHECK-NEXT:    vldrh.u32 q3, [r0, #24]
; CHECK-NEXT:    vcvtb.f32.f16 q0, q0
; CHECK-NEXT:    vcvtb.f32.f16 q1, q1
; CHECK-NEXT:    vcvtb.f32.f16 q2, q2
; CHECK-NEXT:    vcvtb.f32.f16 q3, q3
; CHECK-NEXT:    bx lr
entry:
  %wide.load = load <16 x half>, <16 x half>* %src, align 4
  %e = fpext <16 x half> %wide.load to <16 x float>
  ret <16 x float> %e
}

define arm_aapcs_vfpcc <4 x float> @load_shuffleext_8(<8 x half>* %src) {
; CHECK-LABEL: load_shuffleext_8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vcvtb.f32.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %wide.load = load <8 x half>, <8 x half>* %src, align 4
  %sh = shufflevector <8 x half> %wide.load, <8 x half> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %e = fpext <4 x half> %sh to <4 x float>
  ret <4 x float> %e
}

define arm_aapcs_vfpcc <8 x float> @load_shuffleext_16(<16 x half>* %src) {
; CHECK-LABEL: load_shuffleext_16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.16 {q2, q3}, [r0]
; CHECK-NEXT:    vld21.16 {q2, q3}, [r0]
; CHECK-NEXT:    vcvtt.f32.f16 s3, s9
; CHECK-NEXT:    vcvtb.f32.f16 s2, s9
; CHECK-NEXT:    vcvtt.f32.f16 s1, s8
; CHECK-NEXT:    vcvtb.f32.f16 s0, s8
; CHECK-NEXT:    vcvtt.f32.f16 s7, s11
; CHECK-NEXT:    vcvtb.f32.f16 s6, s11
; CHECK-NEXT:    vcvtt.f32.f16 s5, s10
; CHECK-NEXT:    vcvtb.f32.f16 s4, s10
; CHECK-NEXT:    bx lr
entry:
  %wide.load = load <16 x half>, <16 x half>* %src, align 4
  %sh = shufflevector <16 x half> %wide.load, <16 x half> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %e = fpext <8 x half> %sh to <8 x float>
  ret <8 x float> %e
}




define arm_aapcs_vfpcc void @store_trunc_4(<4 x half>* %src, <4 x float> %val) {
; CHECK-LABEL: store_trunc_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vstrh.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %e = fptrunc <4 x float> %val to <4 x half>
  store <4 x half> %e, <4 x half>* %src, align 4
  ret void
}

define arm_aapcs_vfpcc void @store_trunc_8(<8 x half>* %src, <8 x float> %val) {
; CHECK-LABEL: store_trunc_8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q1, q1
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vstrh.32 q1, [r0, #8]
; CHECK-NEXT:    vstrh.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %e = fptrunc <8 x float> %val to <8 x half>
  store <8 x half> %e, <8 x half>* %src, align 4
  ret void
}

define arm_aapcs_vfpcc void @store_trunc_16(<16 x half>* %src, <16 x float> %val) {
; CHECK-LABEL: store_trunc_16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q3, q3
; CHECK-NEXT:    vcvtb.f16.f32 q2, q2
; CHECK-NEXT:    vcvtb.f16.f32 q1, q1
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vstrh.32 q3, [r0, #24]
; CHECK-NEXT:    vstrh.32 q2, [r0, #16]
; CHECK-NEXT:    vstrh.32 q1, [r0, #8]
; CHECK-NEXT:    vstrh.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %e = fptrunc <16 x float> %val to <16 x half>
  store <16 x half> %e, <16 x half>* %src, align 4
  ret void
}

define arm_aapcs_vfpcc void @store_shuffletrunc_8(<8 x half>* %src, <4 x float> %val1, <4 x float> %val2) {
; CHECK-LABEL: store_shuffletrunc_8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vcvtt.f16.f32 q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <4 x float> %val1, <4 x float> %val2, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  %out = fptrunc <8 x float> %strided.vec to <8 x half>
  store <8 x half> %out, <8 x half>* %src, align 4
  ret void
}

define arm_aapcs_vfpcc void @store_shuffletrunc_16(<16 x half>* %src, <8 x float> %val1, <8 x float> %val2) {
; CHECK-LABEL: store_shuffletrunc_16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.f16.f32 q1, q1
; CHECK-NEXT:    vcvtb.f16.f32 q0, q0
; CHECK-NEXT:    vcvtt.f16.f32 q1, q3
; CHECK-NEXT:    vcvtt.f16.f32 q0, q2
; CHECK-NEXT:    vstrw.32 q1, [r0, #16]
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %strided.vec = shufflevector <8 x float> %val1, <8 x float> %val2, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  %out = fptrunc <16 x float> %strided.vec to <16 x half>
  store <16 x half> %out, <16 x half>* %src, align 4
  ret void
}
