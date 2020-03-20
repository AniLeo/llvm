; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi, -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK-MVE-FP
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi, -mattr=+mve.fp -fp-contract=fast -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK-MVE-VMLA
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK-MVE

define arm_aapcs_vfpcc <8 x half> @vfma16_v1(<8 x half> %src1, <8 x half> %src2, <8 x half> %src3) {
; CHECK-MVE-FP-LABEL: vfma16_v1:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmul.f16 q1, q1, q2
; CHECK-MVE-FP-NEXT:    vadd.f16 q0, q0, q1
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfma16_v1:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vfma.f16 q0, q1, q2
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfma16_v1:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .vsave {d8, d9, d10}
; CHECK-MVE-NEXT:    vpush {d8, d9, d10}
; CHECK-MVE-NEXT:    vmovx.f16 s13, s0
; CHECK-MVE-NEXT:    vmla.f16 s0, s4, s8
; CHECK-MVE-NEXT:    vmovx.f16 s12, s8
; CHECK-MVE-NEXT:    vmovx.f16 s14, s4
; CHECK-MVE-NEXT:    vmov.f32 s16, s1
; CHECK-MVE-NEXT:    vmla.f16 s13, s14, s12
; CHECK-MVE-NEXT:    vmov r1, s0
; CHECK-MVE-NEXT:    vmla.f16 s16, s5, s9
; CHECK-MVE-NEXT:    vmov r0, s13
; CHECK-MVE-NEXT:    vmov.16 q3[0], r1
; CHECK-MVE-NEXT:    vmov.16 q3[1], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmovx.f16 s16, s9
; CHECK-MVE-NEXT:    vmovx.f16 s18, s5
; CHECK-MVE-NEXT:    vmovx.f16 s20, s1
; CHECK-MVE-NEXT:    vmov.16 q3[2], r0
; CHECK-MVE-NEXT:    vmla.f16 s20, s18, s16
; CHECK-MVE-NEXT:    vmov.f32 s16, s2
; CHECK-MVE-NEXT:    vmov r0, s20
; CHECK-MVE-NEXT:    vmla.f16 s16, s6, s10
; CHECK-MVE-NEXT:    vmov.16 q3[3], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmovx.f16 s16, s10
; CHECK-MVE-NEXT:    vmovx.f16 s18, s6
; CHECK-MVE-NEXT:    vmovx.f16 s20, s2
; CHECK-MVE-NEXT:    vmov.16 q3[4], r0
; CHECK-MVE-NEXT:    vmla.f16 s20, s18, s16
; CHECK-MVE-NEXT:    vmov.f32 s16, s3
; CHECK-MVE-NEXT:    vmov r0, s20
; CHECK-MVE-NEXT:    vmla.f16 s16, s7, s11
; CHECK-MVE-NEXT:    vmovx.f16 s8, s11
; CHECK-MVE-NEXT:    vmovx.f16 s4, s7
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmov.16 q3[5], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmla.f16 s0, s4, s8
; CHECK-MVE-NEXT:    vmov.16 q3[6], r0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.16 q3[7], r0
; CHECK-MVE-NEXT:    vmov q0, q3
; CHECK-MVE-NEXT:    vpop {d8, d9, d10}
; CHECK-MVE-NEXT:    bx lr
entry:
  %0 = fmul <8 x half> %src2, %src3
  %1 = fadd <8 x half> %src1, %0
  ret <8 x half> %1
}

define arm_aapcs_vfpcc <8 x half> @vfma16_v2(<8 x half> %src1, <8 x half> %src2, <8 x half> %src3) {
; CHECK-MVE-FP-LABEL: vfma16_v2:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmul.f16 q1, q1, q2
; CHECK-MVE-FP-NEXT:    vadd.f16 q0, q1, q0
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfma16_v2:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vfma.f16 q0, q1, q2
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfma16_v2:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .vsave {d8, d9, d10}
; CHECK-MVE-NEXT:    vpush {d8, d9, d10}
; CHECK-MVE-NEXT:    vmovx.f16 s13, s0
; CHECK-MVE-NEXT:    vmla.f16 s0, s4, s8
; CHECK-MVE-NEXT:    vmovx.f16 s12, s8
; CHECK-MVE-NEXT:    vmovx.f16 s14, s4
; CHECK-MVE-NEXT:    vmov.f32 s16, s1
; CHECK-MVE-NEXT:    vmla.f16 s13, s14, s12
; CHECK-MVE-NEXT:    vmov r1, s0
; CHECK-MVE-NEXT:    vmla.f16 s16, s5, s9
; CHECK-MVE-NEXT:    vmov r0, s13
; CHECK-MVE-NEXT:    vmov.16 q3[0], r1
; CHECK-MVE-NEXT:    vmov.16 q3[1], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmovx.f16 s16, s9
; CHECK-MVE-NEXT:    vmovx.f16 s18, s5
; CHECK-MVE-NEXT:    vmovx.f16 s20, s1
; CHECK-MVE-NEXT:    vmov.16 q3[2], r0
; CHECK-MVE-NEXT:    vmla.f16 s20, s18, s16
; CHECK-MVE-NEXT:    vmov.f32 s16, s2
; CHECK-MVE-NEXT:    vmov r0, s20
; CHECK-MVE-NEXT:    vmla.f16 s16, s6, s10
; CHECK-MVE-NEXT:    vmov.16 q3[3], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmovx.f16 s16, s10
; CHECK-MVE-NEXT:    vmovx.f16 s18, s6
; CHECK-MVE-NEXT:    vmovx.f16 s20, s2
; CHECK-MVE-NEXT:    vmov.16 q3[4], r0
; CHECK-MVE-NEXT:    vmla.f16 s20, s18, s16
; CHECK-MVE-NEXT:    vmov.f32 s16, s3
; CHECK-MVE-NEXT:    vmov r0, s20
; CHECK-MVE-NEXT:    vmla.f16 s16, s7, s11
; CHECK-MVE-NEXT:    vmovx.f16 s8, s11
; CHECK-MVE-NEXT:    vmovx.f16 s4, s7
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmov.16 q3[5], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmla.f16 s0, s4, s8
; CHECK-MVE-NEXT:    vmov.16 q3[6], r0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.16 q3[7], r0
; CHECK-MVE-NEXT:    vmov q0, q3
; CHECK-MVE-NEXT:    vpop {d8, d9, d10}
; CHECK-MVE-NEXT:    bx lr
entry:
  %0 = fmul <8 x half> %src2, %src3
  %1 = fadd <8 x half> %0, %src1
  ret <8 x half> %1
}

define arm_aapcs_vfpcc <8 x half> @vfms16(<8 x half> %src1, <8 x half> %src2, <8 x half> %src3) {
; CHECK-MVE-FP-LABEL: vfms16:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmul.f16 q1, q1, q2
; CHECK-MVE-FP-NEXT:    vsub.f16 q0, q0, q1
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfms16:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vfms.f16 q0, q1, q2
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfms16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .vsave {d8, d9, d10}
; CHECK-MVE-NEXT:    vpush {d8, d9, d10}
; CHECK-MVE-NEXT:    vmovx.f16 s13, s0
; CHECK-MVE-NEXT:    vmls.f16 s0, s4, s8
; CHECK-MVE-NEXT:    vmovx.f16 s12, s8
; CHECK-MVE-NEXT:    vmovx.f16 s14, s4
; CHECK-MVE-NEXT:    vmov.f32 s16, s1
; CHECK-MVE-NEXT:    vmls.f16 s13, s14, s12
; CHECK-MVE-NEXT:    vmov r1, s0
; CHECK-MVE-NEXT:    vmls.f16 s16, s5, s9
; CHECK-MVE-NEXT:    vmov r0, s13
; CHECK-MVE-NEXT:    vmov.16 q3[0], r1
; CHECK-MVE-NEXT:    vmov.16 q3[1], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmovx.f16 s16, s9
; CHECK-MVE-NEXT:    vmovx.f16 s18, s5
; CHECK-MVE-NEXT:    vmovx.f16 s20, s1
; CHECK-MVE-NEXT:    vmov.16 q3[2], r0
; CHECK-MVE-NEXT:    vmls.f16 s20, s18, s16
; CHECK-MVE-NEXT:    vmov.f32 s16, s2
; CHECK-MVE-NEXT:    vmov r0, s20
; CHECK-MVE-NEXT:    vmls.f16 s16, s6, s10
; CHECK-MVE-NEXT:    vmov.16 q3[3], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmovx.f16 s16, s10
; CHECK-MVE-NEXT:    vmovx.f16 s18, s6
; CHECK-MVE-NEXT:    vmovx.f16 s20, s2
; CHECK-MVE-NEXT:    vmov.16 q3[4], r0
; CHECK-MVE-NEXT:    vmls.f16 s20, s18, s16
; CHECK-MVE-NEXT:    vmov.f32 s16, s3
; CHECK-MVE-NEXT:    vmov r0, s20
; CHECK-MVE-NEXT:    vmls.f16 s16, s7, s11
; CHECK-MVE-NEXT:    vmovx.f16 s8, s11
; CHECK-MVE-NEXT:    vmovx.f16 s4, s7
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmov.16 q3[5], r0
; CHECK-MVE-NEXT:    vmov r0, s16
; CHECK-MVE-NEXT:    vmls.f16 s0, s4, s8
; CHECK-MVE-NEXT:    vmov.16 q3[6], r0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.16 q3[7], r0
; CHECK-MVE-NEXT:    vmov q0, q3
; CHECK-MVE-NEXT:    vpop {d8, d9, d10}
; CHECK-MVE-NEXT:    bx lr
entry:
  %0 = fmul <8 x half> %src2, %src3
  %1 = fsub <8 x half> %src1, %0
  ret <8 x half> %1
}

define arm_aapcs_vfpcc <8 x half> @vfmar16(<8 x half> %src1, <8 x half> %src2, float %src3o) {
; CHECK-MVE-FP-LABEL: vfmar16:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vcvtb.f16.f32 s8, s8
; CHECK-MVE-FP-NEXT:    vmov.f16 r0, s8
; CHECK-MVE-FP-NEXT:    vmul.f16 q1, q1, r0
; CHECK-MVE-FP-NEXT:    vadd.f16 q0, q0, q1
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfmar16:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vcvtb.f16.f32 s8, s8
; CHECK-MVE-VMLA-NEXT:    vmov.f16 r0, s8
; CHECK-MVE-VMLA-NEXT:    vfma.f16 q0, q1, r0
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfmar16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcvtb.f16.f32 s12, s8
; CHECK-MVE-NEXT:    vmov.f32 s8, s0
; CHECK-MVE-NEXT:    vmla.f16 s8, s4, s12
; CHECK-MVE-NEXT:    vmov.f32 s14, s1
; CHECK-MVE-NEXT:    vmov r0, s8
; CHECK-MVE-NEXT:    vmovx.f16 s8, s4
; CHECK-MVE-NEXT:    vmovx.f16 s10, s0
; CHECK-MVE-NEXT:    vmla.f16 s14, s5, s12
; CHECK-MVE-NEXT:    vmla.f16 s10, s8, s12
; CHECK-MVE-NEXT:    vmovx.f16 s13, s1
; CHECK-MVE-NEXT:    vmov r1, s10
; CHECK-MVE-NEXT:    vmov.16 q2[0], r0
; CHECK-MVE-NEXT:    vmov r0, s14
; CHECK-MVE-NEXT:    vmovx.f16 s14, s5
; CHECK-MVE-NEXT:    vmov.16 q2[1], r1
; CHECK-MVE-NEXT:    vmla.f16 s13, s14, s12
; CHECK-MVE-NEXT:    vmov.f32 s14, s2
; CHECK-MVE-NEXT:    vmov.16 q2[2], r0
; CHECK-MVE-NEXT:    vmov r0, s13
; CHECK-MVE-NEXT:    vmla.f16 s14, s6, s12
; CHECK-MVE-NEXT:    vmov.16 q2[3], r0
; CHECK-MVE-NEXT:    vmov r0, s14
; CHECK-MVE-NEXT:    vmovx.f16 s14, s6
; CHECK-MVE-NEXT:    vmovx.f16 s13, s2
; CHECK-MVE-NEXT:    vmla.f16 s13, s14, s12
; CHECK-MVE-NEXT:    vmov.f32 s14, s3
; CHECK-MVE-NEXT:    vmov.16 q2[4], r0
; CHECK-MVE-NEXT:    vmov r0, s13
; CHECK-MVE-NEXT:    vmla.f16 s14, s7, s12
; CHECK-MVE-NEXT:    vmovx.f16 s4, s7
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmov.16 q2[5], r0
; CHECK-MVE-NEXT:    vmov r0, s14
; CHECK-MVE-NEXT:    vmla.f16 s0, s4, s12
; CHECK-MVE-NEXT:    vmov.16 q2[6], r0
; CHECK-MVE-NEXT:    vmov r0, s0
; CHECK-MVE-NEXT:    vmov.16 q2[7], r0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
entry:
  %src3 = fptrunc float %src3o to half
  %i = insertelement <8 x half> undef, half %src3, i32 0
  %sp = shufflevector <8 x half> %i, <8 x half> undef, <8 x i32> zeroinitializer
  %0 = fmul <8 x half> %src2, %sp
  %1 = fadd <8 x half> %src1, %0
  ret <8 x half> %1
}

define arm_aapcs_vfpcc <8 x half> @vfma16(<8 x half> %src1, <8 x half> %src2, float %src3o) {
; CHECK-MVE-FP-LABEL: vfma16:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vcvtb.f16.f32 s8, s8
; CHECK-MVE-FP-NEXT:    vmul.f16 q0, q0, q1
; CHECK-MVE-FP-NEXT:    vmov.f16 r0, s8
; CHECK-MVE-FP-NEXT:    vadd.f16 q0, q0, r0
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfma16:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vcvtb.f16.f32 s8, s8
; CHECK-MVE-VMLA-NEXT:    vmov.f16 r0, s8
; CHECK-MVE-VMLA-NEXT:    vfmas.f16 q0, q1, r0
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfma16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vcvtb.f16.f32 s12, s8
; CHECK-MVE-NEXT:    vmovx.f16 s10, s0
; CHECK-MVE-NEXT:    vmov.f32 s8, s12
; CHECK-MVE-NEXT:    vmovx.f16 s13, s1
; CHECK-MVE-NEXT:    vmla.f16 s8, s0, s4
; CHECK-MVE-NEXT:    vmov.f32 s14, s12
; CHECK-MVE-NEXT:    vmov r0, s8
; CHECK-MVE-NEXT:    vmovx.f16 s8, s4
; CHECK-MVE-NEXT:    vmla.f16 s14, s10, s8
; CHECK-MVE-NEXT:    vmov.16 q2[0], r0
; CHECK-MVE-NEXT:    vmov r1, s14
; CHECK-MVE-NEXT:    vmovx.f16 s4, s7
; CHECK-MVE-NEXT:    vmov.f32 s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[1], r1
; CHECK-MVE-NEXT:    vmla.f16 s14, s1, s5
; CHECK-MVE-NEXT:    vmov.f32 s15, s12
; CHECK-MVE-NEXT:    vmov r0, s14
; CHECK-MVE-NEXT:    vmovx.f16 s14, s5
; CHECK-MVE-NEXT:    vmla.f16 s15, s13, s14
; CHECK-MVE-NEXT:    vmov.f32 s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[2], r0
; CHECK-MVE-NEXT:    vmov r0, s15
; CHECK-MVE-NEXT:    vmla.f16 s14, s2, s6
; CHECK-MVE-NEXT:    vmov.16 q2[3], r0
; CHECK-MVE-NEXT:    vmov r0, s14
; CHECK-MVE-NEXT:    vmovx.f16 s14, s6
; CHECK-MVE-NEXT:    vmovx.f16 s13, s2
; CHECK-MVE-NEXT:    vmov.f32 s15, s12
; CHECK-MVE-NEXT:    vmla.f16 s15, s13, s14
; CHECK-MVE-NEXT:    vmov.f32 s14, s12
; CHECK-MVE-NEXT:    vmov.16 q2[4], r0
; CHECK-MVE-NEXT:    vmov r0, s15
; CHECK-MVE-NEXT:    vmovx.f16 s0, s3
; CHECK-MVE-NEXT:    vmla.f16 s14, s3, s7
; CHECK-MVE-NEXT:    vmov.16 q2[5], r0
; CHECK-MVE-NEXT:    vmov r0, s14
; CHECK-MVE-NEXT:    vmla.f16 s12, s0, s4
; CHECK-MVE-NEXT:    vmov.16 q2[6], r0
; CHECK-MVE-NEXT:    vmov r0, s12
; CHECK-MVE-NEXT:    vmov.16 q2[7], r0
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
entry:
  %src3 = fptrunc float %src3o to half
  %i = insertelement <8 x half> undef, half %src3, i32 0
  %sp = shufflevector <8 x half> %i, <8 x half> undef, <8 x i32> zeroinitializer
  %0 = fmul <8 x half> %src1, %src2
  %1 = fadd <8 x half> %sp, %0
  ret <8 x half> %1
}

define arm_aapcs_vfpcc <4 x float> @vfma32_v1(<4 x float> %src1, <4 x float> %src2, <4 x float> %src3) {
; CHECK-MVE-FP-LABEL: vfma32_v1:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmul.f32 q1, q1, q2
; CHECK-MVE-FP-NEXT:    vadd.f32 q0, q0, q1
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfma32_v1:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vfma.f32 q0, q1, q2
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfma32_v1:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vmla.f32 s3, s7, s11
; CHECK-MVE-NEXT:    vmla.f32 s2, s6, s10
; CHECK-MVE-NEXT:    vmla.f32 s1, s5, s9
; CHECK-MVE-NEXT:    vmla.f32 s0, s4, s8
; CHECK-MVE-NEXT:    bx lr
entry:
  %0 = fmul <4 x float> %src2, %src3
  %1 = fadd <4 x float> %src1, %0
  ret <4 x float> %1
}

define arm_aapcs_vfpcc <4 x float> @vfma32_v2(<4 x float> %src1, <4 x float> %src2, <4 x float> %src3) {
; CHECK-MVE-FP-LABEL: vfma32_v2:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmul.f32 q1, q1, q2
; CHECK-MVE-FP-NEXT:    vadd.f32 q0, q1, q0
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfma32_v2:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vfma.f32 q0, q1, q2
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfma32_v2:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vmla.f32 s3, s7, s11
; CHECK-MVE-NEXT:    vmla.f32 s2, s6, s10
; CHECK-MVE-NEXT:    vmla.f32 s1, s5, s9
; CHECK-MVE-NEXT:    vmla.f32 s0, s4, s8
; CHECK-MVE-NEXT:    bx lr
entry:
  %0 = fmul <4 x float> %src2, %src3
  %1 = fadd <4 x float> %0, %src1
  ret <4 x float> %1
}

define arm_aapcs_vfpcc <4 x float> @vfms32(<4 x float> %src1, <4 x float> %src2, <4 x float> %src3) {
; CHECK-MVE-FP-LABEL: vfms32:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmul.f32 q1, q1, q2
; CHECK-MVE-FP-NEXT:    vsub.f32 q0, q0, q1
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfms32:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vfms.f32 q0, q1, q2
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfms32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vmls.f32 s3, s7, s11
; CHECK-MVE-NEXT:    vmls.f32 s2, s6, s10
; CHECK-MVE-NEXT:    vmls.f32 s1, s5, s9
; CHECK-MVE-NEXT:    vmls.f32 s0, s4, s8
; CHECK-MVE-NEXT:    bx lr
entry:
  %0 = fmul <4 x float> %src2, %src3
  %1 = fsub <4 x float> %src1, %0
  ret <4 x float> %1
}

define arm_aapcs_vfpcc <4 x float> @vfmar32(<4 x float> %src1, <4 x float> %src2, float %src3) {
; CHECK-MVE-FP-LABEL: vfmar32:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmov r0, s8
; CHECK-MVE-FP-NEXT:    vmul.f32 q1, q1, r0
; CHECK-MVE-FP-NEXT:    vadd.f32 q0, q0, q1
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfmar32:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vmov r0, s8
; CHECK-MVE-VMLA-NEXT:    vfma.f32 q0, q1, r0
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfmar32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    vmla.f32 s3, s7, s8
; CHECK-MVE-NEXT:    vmla.f32 s2, s6, s8
; CHECK-MVE-NEXT:    vmla.f32 s1, s5, s8
; CHECK-MVE-NEXT:    vmla.f32 s0, s4, s8
; CHECK-MVE-NEXT:    bx lr
entry:
  %i = insertelement <4 x float> undef, float %src3, i32 0
  %sp = shufflevector <4 x float> %i, <4 x float> undef, <4 x i32> zeroinitializer
  %0 = fmul <4 x float> %src2, %sp
  %1 = fadd <4 x float> %src1, %0
  ret <4 x float> %1
}

define arm_aapcs_vfpcc <4 x float> @vfmas32(<4 x float> %src1, <4 x float> %src2, float %src3) {
; CHECK-MVE-FP-LABEL: vfmas32:
; CHECK-MVE-FP:       @ %bb.0: @ %entry
; CHECK-MVE-FP-NEXT:    vmov r0, s8
; CHECK-MVE-FP-NEXT:    vmul.f32 q0, q0, q1
; CHECK-MVE-FP-NEXT:    vadd.f32 q0, q0, r0
; CHECK-MVE-FP-NEXT:    bx lr
;
; CHECK-MVE-VMLA-LABEL: vfmas32:
; CHECK-MVE-VMLA:       @ %bb.0: @ %entry
; CHECK-MVE-VMLA-NEXT:    vmov r0, s8
; CHECK-MVE-VMLA-NEXT:    vfmas.f32 q0, q1, r0
; CHECK-MVE-VMLA-NEXT:    bx lr
;
; CHECK-MVE-LABEL: vfmas32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    @ kill: def $s8 killed $s8 def $q2
; CHECK-MVE-NEXT:    vmov.f32 s11, s8
; CHECK-MVE-NEXT:    vmla.f32 s11, s3, s7
; CHECK-MVE-NEXT:    vmov.f32 s10, s8
; CHECK-MVE-NEXT:    vmla.f32 s10, s2, s6
; CHECK-MVE-NEXT:    vmov.f32 s9, s8
; CHECK-MVE-NEXT:    vmla.f32 s9, s1, s5
; CHECK-MVE-NEXT:    vmla.f32 s8, s0, s4
; CHECK-MVE-NEXT:    vmov q0, q2
; CHECK-MVE-NEXT:    bx lr
entry:
  %i = insertelement <4 x float> undef, float %src3, i32 0
  %sp = shufflevector <4 x float> %i, <4 x float> undef, <4 x i32> zeroinitializer
  %0 = fmul <4 x float> %src1, %src2
  %1 = fadd <4 x float> %sp, %0
  ret <4 x float> %1
}
