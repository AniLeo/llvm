; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

declare <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32)
declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)

declare <16 x i8> @llvm.arm.mve.vcaddq.v16i8(i32, i32, <16 x i8>, <16 x i8>)
declare <4 x i32> @llvm.arm.mve.vcaddq.v4i32(i32, i32, <4 x i32>, <4 x i32>)
declare <8 x i16> @llvm.arm.mve.vcaddq.v8i16(i32, i32, <8 x i16>, <8 x i16>)
declare <8 x half> @llvm.arm.mve.vcaddq.v8f16(i32, i32, <8 x half>, <8 x half>)
declare <4 x float> @llvm.arm.mve.vcaddq.v4f32(i32, i32, <4 x float>, <4 x float>)

declare <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32, i32, <16 x i8>, <16 x i8>, <16 x i8>, <16 x i1>)
declare <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32, i32, <8 x i16>, <8 x i16>, <8 x i16>, <8 x i1>)
declare <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32, i32, <4 x i32>, <4 x i32>, <4 x i32>, <4 x i1>)
declare <8 x half> @llvm.arm.mve.vcaddq.predicated.v8f16.v8i1(i32, i32, <8 x half>, <8 x half>, <8 x half>, <8 x i1>)
declare <4 x float> @llvm.arm.mve.vcaddq.predicated.v4f32.v4i1(i32, i32, <4 x float>, <4 x float>, <4 x float>, <4 x i1>)

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot90_u8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: test_vcaddq_rot90_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i8 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.arm.mve.vcaddq.v16i8(i32 1, i32 0, <16 x i8> %a, <16 x i8> %b)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot90_u16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vcaddq_rot90_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.arm.mve.vcaddq.v8i16(i32 1, i32 0, <8 x i16> %a, <8 x i16> %b)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot90_u32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vcaddq_rot90_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vcaddq.v4i32(i32 1, i32 0, <4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot90_s8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: test_vcaddq_rot90_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i8 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.arm.mve.vcaddq.v16i8(i32 1, i32 0, <16 x i8> %a, <16 x i8> %b)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot90_s16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vcaddq_rot90_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.arm.mve.vcaddq.v8i16(i32 1, i32 0, <8 x i16> %a, <8 x i16> %b)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot90_s32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vcaddq_rot90_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vcaddq.v4i32(i32 1, i32 0, <4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vcaddq_rot90_f16(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: test_vcaddq_rot90_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.f16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x half> @llvm.arm.mve.vcaddq.v8f16(i32 1, i32 0, <8 x half> %a, <8 x half> %b)
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <4 x float> @test_vcaddq_rot90_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_vcaddq_rot90_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.f32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x float> @llvm.arm.mve.vcaddq.v4f32(i32 1, i32 0, <4 x float> %a, <4 x float> %b)
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot270_u8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: test_vcaddq_rot270_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i8 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.arm.mve.vcaddq.v16i8(i32 1, i32 1, <16 x i8> %a, <16 x i8> %b)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot270_u16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vcaddq_rot270_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.arm.mve.vcaddq.v8i16(i32 1, i32 1, <8 x i16> %a, <8 x i16> %b)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot270_u32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vcaddq_rot270_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vcaddq.v4i32(i32 1, i32 1, <4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot270_s8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: test_vcaddq_rot270_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i8 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.arm.mve.vcaddq.v16i8(i32 1, i32 1, <16 x i8> %a, <16 x i8> %b)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot270_s16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vcaddq_rot270_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.arm.mve.vcaddq.v8i16(i32 1, i32 1, <8 x i16> %a, <8 x i16> %b)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot270_s32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vcaddq_rot270_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.i32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vcaddq.v4i32(i32 1, i32 1, <4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vcaddq_rot270_f16(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: test_vcaddq_rot270_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.f16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x half> @llvm.arm.mve.vcaddq.v8f16(i32 1, i32 1, <8 x half> %a, <8 x half> %b)
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <4 x float> @test_vcaddq_rot270_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_vcaddq_rot270_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcadd.f32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x float> @llvm.arm.mve.vcaddq.v4f32(i32 1, i32 1, <4 x float> %a, <4 x float> %b)
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot90_m_u8(<16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 0, <16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot90_m_u16(<8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 0, <8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot90_m_u32(<4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 0, <4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot90_m_s8(<16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 0, <16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot90_m_s16(<8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 0, <8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot90_m_s32(<4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 0, <4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcaddq_rot90_m_f16(<8 x half> %inactive, <8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f16 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcaddq.predicated.v8f16.v8i1(i32 1, i32 0, <8 x half> %inactive, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcaddq_rot90_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f32 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcaddq.predicated.v4f32.v4i1(i32 1, i32 0, <4 x float> %inactive, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot270_m_u8(<16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 1, <16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot270_m_u16(<8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 1, <8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot270_m_u32(<4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 1, <4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot270_m_s8(<16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 1, <16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot270_m_s16(<8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 1, <8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot270_m_s32(<4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 1, <4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcaddq_rot270_m_f16(<8 x half> %inactive, <8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f16 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcaddq.predicated.v8f16.v8i1(i32 1, i32 1, <8 x half> %inactive, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcaddq_rot270_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f32 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcaddq.predicated.v4f32.v4i1(i32 1, i32 1, <4 x float> %inactive, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot90_x_u8(<16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 0, <16 x i8> undef, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot90_x_u16(<8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 0, <8 x i16> undef, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot90_x_u32(<4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 0, <4 x i32> undef, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot90_x_s8(<16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 0, <16 x i8> undef, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot90_x_s16(<8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 0, <8 x i16> undef, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot90_x_s32(<4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 0, <4 x i32> undef, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcaddq_rot90_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcaddq.predicated.v8f16.v8i1(i32 1, i32 0, <8 x half> undef, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcaddq_rot90_x_f32(<4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot90_x_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcaddq.predicated.v4f32.v4i1(i32 1, i32 0, <4 x float> undef, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot270_x_u8(<16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 1, <16 x i8> undef, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot270_x_u16(<8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 1, <8 x i16> undef, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot270_x_u32(<4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 1, <4 x i32> undef, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vcaddq_rot270_x_s8(<16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i8 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 1, i32 1, <16 x i8> undef, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcaddq_rot270_x_s16(<8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 1, i32 1, <8 x i16> undef, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcaddq_rot270_x_s32(<4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.i32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 1, i32 1, <4 x i32> undef, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcaddq_rot270_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcaddq.predicated.v8f16.v8i1(i32 1, i32 1, <8 x half> undef, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcaddq_rot270_x_f32(<4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcaddq_rot270_x_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcaddt.f32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcaddq.predicated.v4f32.v4i1(i32 1, i32 1, <4 x float> undef, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vhcaddq_rot90_s8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: test_vhcaddq_rot90_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vhcadd.s8 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.arm.mve.vcaddq.v16i8(i32 0, i32 0, <16 x i8> %a, <16 x i8> %b)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vhcaddq_rot90_s16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vhcaddq_rot90_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vhcadd.s16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.arm.mve.vcaddq.v8i16(i32 0, i32 0, <8 x i16> %a, <8 x i16> %b)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vhcaddq_rot90_s32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vhcaddq_rot90_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vhcadd.s32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vcaddq.v4i32(i32 0, i32 0, <4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <16 x i8> @test_vhcaddq_rot270_s8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: test_vhcaddq_rot270_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vhcadd.s8 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.arm.mve.vcaddq.v16i8(i32 0, i32 1, <16 x i8> %a, <16 x i8> %b)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vhcaddq_rot270_s16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vhcaddq_rot270_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vhcadd.s16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.arm.mve.vcaddq.v8i16(i32 0, i32 1, <8 x i16> %a, <8 x i16> %b)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vhcaddq_rot270_s32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vhcaddq_rot270_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vhcadd.s32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vcaddq.v4i32(i32 0, i32 1, <4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <16 x i8> @test_vhcaddq_rot90_x_s8(<16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot90_x_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s8 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 0, i32 0, <16 x i8> undef, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vhcaddq_rot90_x_s16(<8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot90_x_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 0, i32 0, <8 x i16> undef, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vhcaddq_rot90_x_s32(<4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot90_x_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 0, i32 0, <4 x i32> undef, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vhcaddq_rot270_x_s8(<16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot270_x_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s8 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 0, i32 1, <16 x i8> undef, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vhcaddq_rot270_x_s16(<8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot270_x_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 0, i32 1, <8 x i16> undef, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vhcaddq_rot270_x_s32(<4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot270_x_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 0, i32 1, <4 x i32> undef, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vhcaddq_rot90_m_s8(<16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot90_m_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s8 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 0, i32 0, <16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vhcaddq_rot90_m_s16(<8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot90_m_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s16 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 0, i32 0, <8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vhcaddq_rot90_m_s32(<4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot90_m_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s32 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 0, i32 0, <4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vhcaddq_rot270_m_s8(<16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot270_m_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s8 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.vcaddq.predicated.v16i8.v16i1(i32 0, i32 1, <16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, <16 x i1> %1)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vhcaddq_rot270_m_s16(<8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot270_m_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s16 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.vcaddq.predicated.v8i16.v8i1(i32 0, i32 1, <8 x i16> %inactive, <8 x i16> %a, <8 x i16> %b, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vhcaddq_rot270_m_s32(<4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vhcaddq_rot270_m_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vhcaddt.s32 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vcaddq.predicated.v4i32.v4i1(i32 0, i32 1, <4 x i32> %inactive, <4 x i32> %a, <4 x i32> %b, <4 x i1> %1)
  ret <4 x i32> %2
}
