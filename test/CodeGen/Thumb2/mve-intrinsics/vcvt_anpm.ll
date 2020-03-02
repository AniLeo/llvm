; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

define arm_aapcs_vfpcc <8 x i16> @test_vcvtaq_s16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtaq_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvta.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvta.v8i16.v8f16(i32 0, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtaq_s32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtaq_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvta.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvta.v4i32.v4f32(i32 0, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtaq_u16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtaq_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvta.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvta.v8i16.v8f16(i32 1, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtaq_u32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtaq_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvta.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvta.v4i32.v4f32(i32 1, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtmq_s16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtmq_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtm.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvtm.v8i16.v8f16(i32 0, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtmq_s32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtmq_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtm.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvtm.v4i32.v4f32(i32 0, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtmq_u16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtmq_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtm.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvtm.v8i16.v8f16(i32 1, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtmq_u32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtmq_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtm.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvtm.v4i32.v4f32(i32 1, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtnq_s16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtnq_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtn.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvtn.v8i16.v8f16(i32 0, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtnq_s32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtnq_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtn.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvtn.v4i32.v4f32(i32 0, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtnq_u16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtnq_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtn.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvtn.v8i16.v8f16(i32 1, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtnq_u32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtnq_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtn.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvtn.v4i32.v4f32(i32 1, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtpq_s16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtpq_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtp.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvtp.v8i16.v8f16(i32 0, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtpq_s32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtpq_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtp.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvtp.v4i32.v4f32(i32 0, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtpq_u16_f16(<8 x half> %a) {
; CHECK-LABEL: test_vcvtpq_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtp.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <8 x i16> @llvm.arm.mve.vcvtp.v8i16.v8f16(i32 1, <8 x half> %a)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtpq_u32_f32(<4 x float> %a) {
; CHECK-LABEL: test_vcvtpq_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtp.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call <4 x i32> @llvm.arm.mve.vcvtp.v4i32.v4f32(i32 1, <4 x float> %a)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtaq_m_s16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_m_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.s16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvta.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtaq_m_s32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_m_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.s32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvta.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtaq_m_u16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_m_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.u16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvta.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtaq_m_u32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_m_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.u32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvta.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtmq_m_s16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_m_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.s16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtm.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtmq_m_s32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_m_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.s32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtm.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtmq_m_u16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_m_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.u16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtm.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtmq_m_u32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_m_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.u32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtm.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtnq_m_s16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_m_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.s16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtn.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtnq_m_s32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_m_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.s32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtn.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtnq_m_u16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_m_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.u16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtn.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtnq_m_u32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_m_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.u32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtn.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtpq_m_s16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_m_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.s16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtp.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtpq_m_s32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_m_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.s32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtp.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtpq_m_u16_f16(<8 x i16> %inactive, <8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_m_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.u16.f16 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtp.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> %inactive, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtpq_m_u32_f32(<4 x i32> %inactive, <4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_m_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.u32.f32 q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtp.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> %inactive, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtaq_x_s16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_x_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvta.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtaq_x_s32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_x_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvta.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtaq_x_u16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_x_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvta.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtaq_x_u32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtaq_x_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtat.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvta.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtmq_x_s16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_x_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtm.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtmq_x_s32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_x_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtm.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtmq_x_u16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_x_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtm.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtmq_x_u32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtmq_x_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtmt.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtm.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtnq_x_s16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_x_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtn.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtnq_x_s32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_x_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtn.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtnq_x_u16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_x_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtn.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtnq_x_u32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtnq_x_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtnt.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtn.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtpq_x_s16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_x_s16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.s16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtp.predicated.v8i16.v8f16.v8i1(i32 0, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtpq_x_s32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_x_s32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.s32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtp.predicated.v4i32.v4f32.v4i1(i32 0, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <8 x i16> @test_vcvtpq_x_u16_f16(<8 x half> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_x_u16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.u16.f16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call <8 x i16> @llvm.arm.mve.vcvtp.predicated.v8i16.v8f16.v8i1(i32 1, <8 x i16> undef, <8 x half> %a, <8 x i1> %1)
  ret <8 x i16> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vcvtpq_x_u32_f32(<4 x float> %a, i16 zeroext %p) {
; CHECK-LABEL: test_vcvtpq_x_u32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcvtpt.u32.f32 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = tail call <4 x i32> @llvm.arm.mve.vcvtp.predicated.v4i32.v4f32.v4i1(i32 1, <4 x i32> undef, <4 x float> %a, <4 x i1> %1)
  ret <4 x i32> %2
}

declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)

declare <8 x i16> @llvm.arm.mve.vcvta.v8i16.v8f16(i32, <8 x half>)
declare <4 x i32> @llvm.arm.mve.vcvta.v4i32.v4f32(i32, <4 x float>)
declare <8 x i16> @llvm.arm.mve.vcvtm.v8i16.v8f16(i32, <8 x half>)
declare <4 x i32> @llvm.arm.mve.vcvtm.v4i32.v4f32(i32, <4 x float>)
declare <8 x i16> @llvm.arm.mve.vcvtn.v8i16.v8f16(i32, <8 x half>)
declare <4 x i32> @llvm.arm.mve.vcvtn.v4i32.v4f32(i32, <4 x float>)
declare <8 x i16> @llvm.arm.mve.vcvtp.v8i16.v8f16(i32, <8 x half>)
declare <4 x i32> @llvm.arm.mve.vcvtp.v4i32.v4f32(i32, <4 x float>)

declare <8 x i16> @llvm.arm.mve.vcvta.predicated.v8i16.v8f16.v8i1(i32, <8 x i16>, <8 x half>, <8 x i1>)
declare <4 x i32> @llvm.arm.mve.vcvta.predicated.v4i32.v4f32.v4i1(i32, <4 x i32>, <4 x float>, <4 x i1>)
declare <8 x i16> @llvm.arm.mve.vcvtm.predicated.v8i16.v8f16.v8i1(i32, <8 x i16>, <8 x half>, <8 x i1>)
declare <4 x i32> @llvm.arm.mve.vcvtm.predicated.v4i32.v4f32.v4i1(i32, <4 x i32>, <4 x float>, <4 x i1>)
declare <8 x i16> @llvm.arm.mve.vcvtn.predicated.v8i16.v8f16.v8i1(i32, <8 x i16>, <8 x half>, <8 x i1>)
declare <4 x i32> @llvm.arm.mve.vcvtn.predicated.v4i32.v4f32.v4i1(i32, <4 x i32>, <4 x float>, <4 x i1>)
declare <8 x i16> @llvm.arm.mve.vcvtp.predicated.v8i16.v8f16.v8i1(i32, <8 x i16>, <8 x half>, <8 x i1>)
declare <4 x i32> @llvm.arm.mve.vcvtp.predicated.v4i32.v4f32.v4i1(i32, <4 x i32>, <4 x float>, <4 x i1>)
