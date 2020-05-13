; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

define arm_aapcs_vfpcc <4 x i32> @test_vaddq_u32(<4 x i32> %a, <4 x i32> %b) local_unnamed_addr #0 {
; CHECK-LABEL: test_vaddq_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vadd.i32 q0, q1, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = add <4 x i32> %b, %a
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vaddq_f16(<8 x half> %a, <8 x half> %b) local_unnamed_addr #0 {
; CHECK-LABEL: test_vaddq_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vadd.f16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = fadd <8 x half> %a, %b
  ret <8 x half> %0
}

define arm_aapcs_vfpcc <16 x i8> @test_vaddq_m_s8(<16 x i8> %inactive, <16 x i8> %a, <16 x i8> %b, i16 zeroext %p) local_unnamed_addr #1 {
; CHECK-LABEL: test_vaddq_m_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.i8 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = tail call <16 x i8> @llvm.arm.mve.add.predicated.v16i8.v16i1(<16 x i8> %a, <16 x i8> %b, <16 x i1> %1, <16 x i8> %inactive)
  ret <16 x i8> %2
}

declare <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32) #2

declare <16 x i8> @llvm.arm.mve.add.predicated.v16i8.v16i1(<16 x i8>, <16 x i8>, <16 x i1>, <16 x i8>) #2

define arm_aapcs_vfpcc <4 x float> @test_vaddq_m_f32(<4 x float> %inactive, <4 x float> %a, <4 x float> %b, i16 zeroext %p) local_unnamed_addr #1 {
; CHECK-LABEL: test_vaddq_m_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.f32 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> %a, <4 x float> %b, <4 x i1> %1, <4 x float> %inactive)
  ret <4 x float> %2
}

declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32) #2

declare <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float>, <4 x float>, <4 x i1>, <4 x float>) #2

define arm_aapcs_vfpcc <8 x i16> @test_vaddq_x_u16(<8 x i16> %a, <8 x i16> %b, i16 zeroext %p) local_unnamed_addr #1 {
; CHECK-LABEL: test_vaddq_x_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.i16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.add.predicated.v8i16.v8i1(<8 x i16> %a, <8 x i16> %b, <8 x i1> %1, <8 x i16> undef)
  ret <8 x i16> %2
}

declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32) #2

declare <8 x i16> @llvm.arm.mve.add.predicated.v8i16.v8i1(<8 x i16>, <8 x i16>, <8 x i1>, <8 x i16>) #2

define arm_aapcs_vfpcc <8 x half> @test_vaddq_x_f16(<8 x half> %a, <8 x half> %b, i16 zeroext %p) local_unnamed_addr #1 {
; CHECK-LABEL: test_vaddq_x_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.f16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x half> @llvm.arm.mve.add.predicated.v8f16.v8i1(<8 x half> %a, <8 x half> %b, <8 x i1> %1, <8 x half> undef)
  ret <8 x half> %2
}

declare <8 x half> @llvm.arm.mve.add.predicated.v8f16.v8i1(<8 x half>, <8 x half>, <8 x i1>, <8 x half>) #2

define arm_aapcs_vfpcc <4 x i32> @test_vaddq_n_u32(<4 x i32> %a, i32 %b) {
; CHECK-LABEL: test_vaddq_n_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <4 x i32> undef, i32 %b, i32 0
  %.splat = shufflevector <4 x i32> %.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = add <4 x i32> %.splat, %a
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x half> @test_vaddq_n_f16(<8 x half> %a, float %b.coerce) {
; CHECK-LABEL: test_vaddq_n_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vadd.f16 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %0 = bitcast float %b.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %.splatinsert = insertelement <8 x half> undef, half %1, i32 0
  %.splat = shufflevector <8 x half> %.splatinsert, <8 x half> undef, <8 x i32> zeroinitializer
  %2 = fadd <8 x half> %.splat, %a
  ret <8 x half> %2
}

define arm_aapcs_vfpcc <16 x i8> @test_vaddq_m_n_s8(<16 x i8> %inactive, <16 x i8> %a, i8 signext %b, i16 zeroext %p) {
; CHECK-LABEL: test_vaddq_m_n_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.i8 q0, q1, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <16 x i8> undef, i8 %b, i32 0
  %.splat = shufflevector <16 x i8> %.splatinsert, <16 x i8> undef, <16 x i32> zeroinitializer
  %0 = zext i16 %p to i32
  %1 = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %0)
  %2 = call <16 x i8> @llvm.arm.mve.add.predicated.v16i8.v16i1(<16 x i8> %a, <16 x i8> %.splat, <16 x i1> %1, <16 x i8> %inactive)
  ret <16 x i8> %2
}

define arm_aapcs_vfpcc <4 x float> @test_vaddq_m_n_f32(<4 x float> %inactive, <4 x float> %a, float %b, i16 zeroext %p) {
; CHECK-LABEL: test_vaddq_m_n_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s8
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.f32 q0, q1, r1
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <4 x float> undef, float %b, i32 0
  %.splat = shufflevector <4 x float> %.splatinsert, <4 x float> undef, <4 x i32> zeroinitializer
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> %a, <4 x float> %.splat, <4 x i1> %1, <4 x float> %inactive)
  ret <4 x float> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vaddq_x_n_u16(<8 x i16> %a, i16 zeroext %b, i16 zeroext %p) {
; CHECK-LABEL: test_vaddq_x_n_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.i16 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <8 x i16> undef, i16 %b, i32 0
  %.splat = shufflevector <8 x i16> %.splatinsert, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = zext i16 %p to i32
  %1 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = call <8 x i16> @llvm.arm.mve.add.predicated.v8i16.v8i1(<8 x i16> %a, <8 x i16> %.splat, <8 x i1> %1, <8 x i16> undef)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <8 x half> @test_vaddq_x_n_f16(<8 x half> %a, float %b.coerce, i16 zeroext %p) {
; CHECK-LABEL: test_vaddq_x_n_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddt.f16 q0, q0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = bitcast float %b.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %.splatinsert = insertelement <8 x half> undef, half %1, i32 0
  %.splat = shufflevector <8 x half> %.splatinsert, <8 x half> undef, <8 x i32> zeroinitializer
  %2 = zext i16 %p to i32
  %3 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %2)
  %4 = call <8 x half> @llvm.arm.mve.add.predicated.v8f16.v8i1(<8 x half> %a, <8 x half> %.splat, <8 x i1> %3, <8 x half> undef)
  ret <8 x half> %4
}
