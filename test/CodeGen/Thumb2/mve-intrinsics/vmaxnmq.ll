; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

define arm_aapcs_vfpcc <8 x half> @test_vmaxnmq_f16(<8 x half> %a, <8 x half> %b) local_unnamed_addr #0 {
; CHECK-LABEL: test_vmaxnmq_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmaxnm.f16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x half> @llvm.maxnum.v8f16(<8 x half> %a, <8 x half> %b)
  ret <8 x half> %0
}

declare <8 x half> @llvm.maxnum.v8f16(<8 x half>, <8 x half>) #1

define arm_aapcs_vfpcc <4 x float> @test_vmaxnmq_f32(<4 x float> %a, <4 x float> %b) local_unnamed_addr #0 {
; CHECK-LABEL: test_vmaxnmq_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmaxnm.f32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x float> @llvm.maxnum.v4f32(<4 x float> %a, <4 x float> %b)
  ret <4 x float> %0
}

declare <4 x float> @llvm.maxnum.v4f32(<4 x float>, <4 x float>) #1

define arm_aapcs_vfpcc <8 x half> @test_vmaxnmq_m_f16(<8 x half> %inactive, <8 x half> %a, <8 x half> %b, i16 zeroext %p) local_unnamed_addr #0 {
; CHECK-LABEL: test_vmaxnmq_m_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmaxnmt.f16 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x half> @llvm.arm.mve.max.predicated.v8f16.v8i1(<8 x half> %a, <8 x half> %b, i32 0, <8 x i1> %1, <8 x half> %inactive)
  ret <8 x half> %2
}

declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32) #2

declare <8 x half> @llvm.arm.mve.max.predicated.v8f16.v8i1(<8 x half>, <8 x half>, i32, <8 x i1>, <8 x half>) #2

define arm_aapcs_vfpcc <4 x float> @test_vmaxnmq_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) local_unnamed_addr #0 {
; CHECK-LABEL: test_vmaxnmq_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmaxnmt.f32 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x float> @llvm.arm.mve.max.predicated.v4f32.v4i1(<4 x float> %a, <4 x float> %b, i32 0, <4 x i1> %1, <4 x float> %inactive)
  ret <4 x float> %2
}

declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32) #2

declare <4 x float> @llvm.arm.mve.max.predicated.v4f32.v4i1(<4 x float>, <4 x float>, i32, <4 x i1>, <4 x float>) #2

define arm_aapcs_vfpcc <8 x half> @test_vmaxnmq_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) local_unnamed_addr #0 {
; CHECK-LABEL: test_vmaxnmq_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmaxnmt.f16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x half> @llvm.arm.mve.max.predicated.v8f16.v8i1(<8 x half> %a, <8 x half> %b, i32 0, <8 x i1> %1, <8 x half> undef)
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vmaxnmq_x_f32(<4 x float> %a, <4 x float> %b, i16 zeroext %p) local_unnamed_addr #0 {
; CHECK-LABEL: test_vmaxnmq_x_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmaxnmt.f32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x float> @llvm.arm.mve.max.predicated.v4f32.v4i1(<4 x float> %a, <4 x float> %b, i32 0, <4 x i1> %1, <4 x float> undef)
  ret <4 x float> %2
}

