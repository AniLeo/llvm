; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)

declare <8 x half> @llvm.arm.mve.vcmulq.v8f16(i32, <8 x half>, <8 x half>)
declare <4 x float> @llvm.arm.mve.vcmulq.v4f32(i32, <4 x float>, <4 x float>)

declare <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32, <8 x half>, <8 x half>, <8 x half>, <8 x i1>)
declare <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32, <4 x float>, <4 x float>, <4 x float>, <4 x i1>)

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_f16(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: test_vcmulq_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f16 q0, q0, q1, #0
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x half> @llvm.arm.mve.vcmulq.v8f16(i32 0, <8 x half> %a, <8 x half> %b)
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_vcmulq_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f32 q2, q0, q1, #0
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x float> @llvm.arm.mve.vcmulq.v4f32(i32 0, <4 x float> %a, <4 x float> %b)
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot90_f16(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: test_vcmulq_rot90_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x half> @llvm.arm.mve.vcmulq.v8f16(i32 1, <8 x half> %a, <8 x half> %b)
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot90_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_vcmulq_rot90_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x float> @llvm.arm.mve.vcmulq.v4f32(i32 1, <4 x float> %a, <4 x float> %b)
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot180_f16(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: test_vcmulq_rot180_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f16 q0, q0, q1, #180
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x half> @llvm.arm.mve.vcmulq.v8f16(i32 2, <8 x half> %a, <8 x half> %b)
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot180_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_vcmulq_rot180_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f32 q2, q0, q1, #180
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x float> @llvm.arm.mve.vcmulq.v4f32(i32 2, <4 x float> %a, <4 x float> %b)
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot270_f16(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: test_vcmulq_rot270_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x half> @llvm.arm.mve.vcmulq.v8f16(i32 3, <8 x half> %a, <8 x half> %b)
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot270_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_vcmulq_rot270_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcmul.f32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x float> @llvm.arm.mve.vcmulq.v4f32(i32 3, <4 x float> %a, <4 x float> %b)
  ret <4 x float> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_m_f16(<8 x half> %inactive, <8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q1, q2, #0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 0, <8 x half> %inactive, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q0, q1, q2, #0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 0, <4 x float> %inactive, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot90_m_f16(<8 x half> %inactive, <8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot90_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 1, <8 x half> %inactive, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot90_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot90_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q0, q1, q2, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 1, <4 x float> %inactive, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot180_m_f16(<8 x half> %inactive, <8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot180_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q1, q2, #180
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 2, <8 x half> %inactive, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot180_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot180_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q0, q1, q2, #180
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 2, <4 x float> %inactive, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot270_m_f16(<8 x half> %inactive, <8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot270_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 3, <8 x half> %inactive, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot270_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot270_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q0, q1, q2, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 3, <4 x float> %inactive, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q0, q1, #0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 0, <8 x half> undef, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_x_f32(<4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_x_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q2, q0, q1, #0
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 0, <4 x float> undef, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot90_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot90_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q0, q1, #90
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 1, <8 x half> undef, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot90_x_f32(<4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot90_x_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q2, q0, q1, #90
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 1, <4 x float> undef, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot180_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot180_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q0, q1, #180
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 2, <8 x half> undef, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot180_x_f32(<4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot180_x_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q2, q0, q1, #180
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 2, <4 x float> undef, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vcmulq_rot270_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot270_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f16 q0, q0, q1, #270
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x half> @llvm.arm.mve.vcmulq.predicated.v8f16.v8i1(i32 3, <8 x half> undef, <8 x half> %a, <8 x half> %b, <8 x i1> %1)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vcmulq_rot270_x_f32(<4 x float> %a, <4 x float> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vcmulq_rot270_x_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmult.f32 q2, q0, q1, #270
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.vcmulq.predicated.v4f32.v4i1(i32 3, <4 x float> undef, <4 x float> %a, <4 x float> %b, <4 x i1> %1)
  ret <4 x float> %2
}
