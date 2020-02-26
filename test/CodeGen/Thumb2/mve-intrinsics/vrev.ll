; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @test_vrev16q_m_i8(<16 x i8> %inactive, <16 x i8> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev16q_m_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev16t.8 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = tail call <16 x i8> @llvm.arm.mve.vrev.predicated.v16i8.v16i1(<16 x i8> %a, i32 16, <16 x i1> %1, <16 x i8> %inactive)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vrev32q_m_i8(<16 x i8> %inactive, <16 x i8> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev32q_m_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev32t.8 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = tail call <16 x i8> @llvm.arm.mve.vrev.predicated.v16i8.v16i1(<16 x i8> %a, i32 32, <16 x i1> %1, <16 x i8> %inactive)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vrev32q_m_i16(<8 x i16> %inactive, <8 x i16> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev32q_m_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev32t.16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vrev.predicated.v8i16.v8i1(<8 x i16> %a, i32 32, <8 x i1> %1, <8 x i16> %inactive)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vrev32q_m_f16(<8 x half> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev32q_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev32t.16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x half> @llvm.arm.mve.vrev.predicated.v8f16.v8i1(<8 x half> %a, i32 32, <8 x i1> %1, <8 x half> %inactive)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vrev64q_m_i8(<16 x i8> %inactive, <16 x i8> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev64q_m_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev64t.8 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = tail call <16 x i8> @llvm.arm.mve.vrev.predicated.v16i8.v16i1(<16 x i8> %a, i32 64, <16 x i1> %1, <16 x i8> %inactive)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vrev64q_m_i16(<8 x i16> %inactive, <8 x i16> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev64q_m_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev64t.16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vrev.predicated.v8i16.v8i1(<8 x i16> %a, i32 64, <8 x i1> %1, <8 x i16> %inactive)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vrev64q_m_f16(<8 x half> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev64q_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev64t.16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x half> @llvm.arm.mve.vrev.predicated.v8f16.v8i1(<8 x half> %a, i32 64, <8 x i1> %1, <8 x half> %inactive)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vrev64q_m_i32(<4 x i32> %inactive, <4 x i32> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev64q_m_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev64t.32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vrev.predicated.v4i32.v4i1(<4 x i32> %a, i32 64, <4 x i1> %1, <4 x i32> %inactive)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vrev64q_m_f32(<4 x float> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vrev64q_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vrev64t.32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x float> @llvm.arm.mve.vrev.predicated.v4f32.v4i1(<4 x float> %a, i32 64, <4 x i1> %1, <4 x float> %inactive)
  ret <4 x float> %2
}

declare <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32)
declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)

declare <16 x i8> @llvm.arm.mve.vrev.predicated.v16i8.v16i1(<16 x i8>, i32, <16 x i1>, <16 x i8>)
declare <8 x i16> @llvm.arm.mve.vrev.predicated.v8i16.v8i1(<8 x i16>, i32, <8 x i1>, <8 x i16>)
declare <8 x half> @llvm.arm.mve.vrev.predicated.v8f16.v8i1(<8 x half>, i32, <8 x i1>, <8 x half>)
declare <4 x i32> @llvm.arm.mve.vrev.predicated.v4i32.v4i1(<4 x i32>, i32, <4 x i1>, <4 x i32>)
declare <4 x float> @llvm.arm.mve.vrev.predicated.v4f32.v4i1(<4 x float>, i32, <4 x i1>, <4 x float>)
