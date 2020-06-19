; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv8.6a-arm-none-eabi -mattr=+bf16,+neon,fullfp16 < %s | FileCheck %s
; FIXME: Remove fullfp16 once bfloat arguments and returns lowering stops
; depending on it.

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8.6a-arm-none-eabi"

define arm_aapcs_vfpcc <4 x bfloat> @test_vcreate_bf16(i64 %a) {
; CHECK-LABEL: test_vcreate_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = bitcast i64 %a to <4 x bfloat>
  ret <4 x bfloat> %0
}

define arm_aapcs_vfpcc <4 x bfloat> @test_vdup_n_bf16(bfloat %v) {
; CHECK-LABEL: test_vdup_n_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $s0 killed $s0 def $d0
; CHECK-NEXT:    vdup.16 d0, d0[0]
; CHECK-NEXT:    bx lr
entry:
  %vecinit.i = insertelement <4 x bfloat> undef, bfloat %v, i32 0
  %vecinit3.i = shufflevector <4 x bfloat> %vecinit.i, <4 x bfloat> undef, <4 x i32> zeroinitializer
  ret <4 x bfloat> %vecinit3.i
}

define arm_aapcs_vfpcc <8 x bfloat> @test_vdupq_n_bf16(bfloat %v) {
; CHECK-LABEL: test_vdupq_n_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $s0 killed $s0 def $d0
; CHECK-NEXT:    vdup.16 q0, d0[0]
; CHECK-NEXT:    bx lr
entry:
  %vecinit.i = insertelement <8 x bfloat> undef, bfloat %v, i32 0
  %vecinit7.i = shufflevector <8 x bfloat> %vecinit.i, <8 x bfloat> undef, <8 x i32> zeroinitializer
  ret <8 x bfloat> %vecinit7.i
}

define arm_aapcs_vfpcc <4 x bfloat> @test_vdup_lane_bf16(<4 x bfloat> %v) {
; CHECK-LABEL: test_vdup_lane_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.16 d0, d0[1]
; CHECK-NEXT:    bx lr
entry:
  %lane = shufflevector <4 x bfloat> %v, <4 x bfloat> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x bfloat> %lane
}

define arm_aapcs_vfpcc <8 x bfloat> @test_vdupq_lane_bf16(<4 x bfloat> %v) {
; CHECK-LABEL: test_vdupq_lane_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    vdup.16 q0, d0[1]
; CHECK-NEXT:    bx lr
entry:
  %lane = shufflevector <4 x bfloat> %v, <4 x bfloat> undef, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  ret <8 x bfloat> %lane
}

define arm_aapcs_vfpcc <4 x bfloat> @test_vdup_laneq_bf16(<8 x bfloat> %v) {
; CHECK-LABEL: test_vdup_laneq_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.16 d0, d1[3]
; CHECK-NEXT:    bx lr
entry:
  %lane = shufflevector <8 x bfloat> %v, <8 x bfloat> undef, <4 x i32> <i32 7, i32 7, i32 7, i32 7>
  ret <4 x bfloat> %lane
}

define arm_aapcs_vfpcc <8 x bfloat> @test_vdupq_laneq_bf16(<8 x bfloat> %v) {
; CHECK-LABEL: test_vdupq_laneq_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.16 q0, d1[3]
; CHECK-NEXT:    bx lr
entry:
  %lane = shufflevector <8 x bfloat> %v, <8 x bfloat> undef, <8 x i32> <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
  ret <8 x bfloat> %lane
}

define arm_aapcs_vfpcc <8 x bfloat> @test_vcombine_bf16(<4 x bfloat> %low, <4 x bfloat> %high) {
; CHECK-LABEL: test_vcombine_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f64 d16, d1
; CHECK-NEXT:    vorr d17, d0, d0
; CHECK-NEXT:    vorr q0, q8, q8
; CHECK-NEXT:    bx lr
entry:
  %shuffle.i = shufflevector <4 x bfloat> %high, <4 x bfloat> %low, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x bfloat> %shuffle.i
}

define arm_aapcs_vfpcc <4 x bfloat> @test_vget_high_bf16(<8 x bfloat> %a) {
; CHECK-LABEL: test_vget_high_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f64 d0, d1
; CHECK-NEXT:    bx lr
entry:
  %shuffle.i = shufflevector <8 x bfloat> %a, <8 x bfloat> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  ret <4 x bfloat> %shuffle.i
}

define arm_aapcs_vfpcc <4 x bfloat> @test_vget_low_bf16(<8 x bfloat> %a) {
; CHECK-LABEL: test_vget_low_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    bx lr
entry:
  %shuffle.i = shufflevector <8 x bfloat> %a, <8 x bfloat> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x bfloat> %shuffle.i
}

define arm_aapcs_vfpcc bfloat @test_vgetq_lane_bf16_even(<8 x bfloat> %v) {
; CHECK-LABEL: test_vgetq_lane_bf16_even:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s0, s3
; CHECK-NEXT:    bx lr
entry:
  %0 = extractelement <8 x bfloat> %v, i32 6
  ret bfloat %0
}

define arm_aapcs_vfpcc bfloat @test_vgetq_lane_bf16_odd(<8 x bfloat> %v) {
; CHECK-LABEL: test_vgetq_lane_bf16_odd:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovx.f16 s0, s3
; CHECK-NEXT:    bx lr
entry:
  %0 = extractelement <8 x bfloat> %v, i32 7
  ret bfloat %0
}

define arm_aapcs_vfpcc bfloat @test_vget_lane_bf16_even(<4 x bfloat> %v) {
; CHECK-LABEL: test_vget_lane_bf16_even:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f32 s0, s1
; CHECK-NEXT:    bx lr
entry:
  %0 = extractelement <4 x bfloat> %v, i32 2
  ret bfloat %0
}

define arm_aapcs_vfpcc bfloat @test_vget_lane_bf16_odd(<4 x bfloat> %v) {
; CHECK-LABEL: test_vget_lane_bf16_odd:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovx.f16 s0, s0
; CHECK-NEXT:    bx lr
entry:
  %0 = extractelement <4 x bfloat> %v, i32 1
  ret bfloat %0
}

define arm_aapcs_vfpcc <4 x bfloat> @test_vset_lane_bf16(bfloat %a, <4 x bfloat> %v) {
; CHECK-LABEL: test_vset_lane_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vmov.16 d1[1], r0
; CHECK-NEXT:    vorr d0, d1, d1
; CHECK-NEXT:    bx lr
entry:
  %0 = insertelement <4 x bfloat> %v, bfloat %a, i32 1
  ret <4 x bfloat> %0
}

define arm_aapcs_vfpcc <8 x bfloat> @test_vsetq_lane_bf16(bfloat %a, <8 x bfloat> %v) {
; CHECK-LABEL: test_vsetq_lane_bf16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vmov.16 d3[3], r0
; CHECK-NEXT:    vorr q0, q1, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = insertelement <8 x bfloat> %v, bfloat %a, i32 7
  ret <8 x bfloat> %0
}
