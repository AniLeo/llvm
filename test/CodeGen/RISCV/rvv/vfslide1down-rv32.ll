; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+f,+experimental-zfh -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x half> @llvm.riscv.vfslide1down.nxv1f16.f16(
  <vscale x 1 x half>,
  half,
  i32);

define <vscale x 1 x half> @intrinsic_vfslide1down_vf_nxv1f16_nxv1f16_f16(<vscale x 1 x half> %0, half %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv1f16_nxv1f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf4,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfslide1down.nxv1f16.f16(
    <vscale x 1 x half> %0,
    half %1,
    i32 %2)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfslide1down.mask.nxv1f16.f16(
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  half,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x half> @intrinsic_vfslide1down_mask_vf_nxv1f16_nxv1f16_f16(<vscale x 1 x half> %0, <vscale x 1 x half> %1, half %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv1f16_nxv1f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf4,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v17, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfslide1down.mask.nxv1f16.f16(
    <vscale x 1 x half> %0,
    <vscale x 1 x half> %1,
    half %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfslide1down.nxv2f16.f16(
  <vscale x 2 x half>,
  half,
  i32);

define <vscale x 2 x half> @intrinsic_vfslide1down_vf_nxv2f16_nxv2f16_f16(<vscale x 2 x half> %0, half %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv2f16_nxv2f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf2,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfslide1down.nxv2f16.f16(
    <vscale x 2 x half> %0,
    half %1,
    i32 %2)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfslide1down.mask.nxv2f16.f16(
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  half,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x half> @intrinsic_vfslide1down_mask_vf_nxv2f16_nxv2f16_f16(<vscale x 2 x half> %0, <vscale x 2 x half> %1, half %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv2f16_nxv2f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf2,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v17, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfslide1down.mask.nxv2f16.f16(
    <vscale x 2 x half> %0,
    <vscale x 2 x half> %1,
    half %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfslide1down.nxv4f16.f16(
  <vscale x 4 x half>,
  half,
  i32);

define <vscale x 4 x half> @intrinsic_vfslide1down_vf_nxv4f16_nxv4f16_f16(<vscale x 4 x half> %0, half %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv4f16_nxv4f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m1,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfslide1down.nxv4f16.f16(
    <vscale x 4 x half> %0,
    half %1,
    i32 %2)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfslide1down.mask.nxv4f16.f16(
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  half,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x half> @intrinsic_vfslide1down_mask_vf_nxv4f16_nxv4f16_f16(<vscale x 4 x half> %0, <vscale x 4 x half> %1, half %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv4f16_nxv4f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m1,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v17, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfslide1down.mask.nxv4f16.f16(
    <vscale x 4 x half> %0,
    <vscale x 4 x half> %1,
    half %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfslide1down.nxv8f16.f16(
  <vscale x 8 x half>,
  half,
  i32);

define <vscale x 8 x half> @intrinsic_vfslide1down_vf_nxv8f16_nxv8f16_f16(<vscale x 8 x half> %0, half %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv8f16_nxv8f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m2,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfslide1down.nxv8f16.f16(
    <vscale x 8 x half> %0,
    half %1,
    i32 %2)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfslide1down.mask.nxv8f16.f16(
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  half,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x half> @intrinsic_vfslide1down_mask_vf_nxv8f16_nxv8f16_f16(<vscale x 8 x half> %0, <vscale x 8 x half> %1, half %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv8f16_nxv8f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m2,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v18, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfslide1down.mask.nxv8f16.f16(
    <vscale x 8 x half> %0,
    <vscale x 8 x half> %1,
    half %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfslide1down.nxv16f16.f16(
  <vscale x 16 x half>,
  half,
  i32);

define <vscale x 16 x half> @intrinsic_vfslide1down_vf_nxv16f16_nxv16f16_f16(<vscale x 16 x half> %0, half %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv16f16_nxv16f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfslide1down.nxv16f16.f16(
    <vscale x 16 x half> %0,
    half %1,
    i32 %2)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfslide1down.mask.nxv16f16.f16(
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  half,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x half> @intrinsic_vfslide1down_mask_vf_nxv16f16_nxv16f16_f16(<vscale x 16 x half> %0, <vscale x 16 x half> %1, half %2, <vscale x 16 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv16f16_nxv16f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v20, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfslide1down.mask.nxv16f16.f16(
    <vscale x 16 x half> %0,
    <vscale x 16 x half> %1,
    half %2,
    <vscale x 16 x i1> %3,
    i32 %4)

  ret <vscale x 16 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vfslide1down.nxv32f16.f16(
  <vscale x 32 x half>,
  half,
  i32);

define <vscale x 32 x half> @intrinsic_vfslide1down_vf_nxv32f16_nxv32f16_f16(<vscale x 32 x half> %0, half %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv32f16_nxv32f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m8,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 32 x half> @llvm.riscv.vfslide1down.nxv32f16.f16(
    <vscale x 32 x half> %0,
    half %1,
    i32 %2)

  ret <vscale x 32 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vfslide1down.mask.nxv32f16.f16(
  <vscale x 32 x half>,
  <vscale x 32 x half>,
  half,
  <vscale x 32 x i1>,
  i32);

define <vscale x 32 x half> @intrinsic_vfslide1down_mask_vf_nxv32f16_nxv32f16_f16(<vscale x 32 x half> %0, <vscale x 32 x half> %1, half %2, <vscale x 32 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv32f16_nxv32f16_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, zero, e16,m8,ta,mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    fmv.h.x ft0, a1
; CHECK-NEXT:    vsetvli a0, a2, e16,m8,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v8, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 32 x half> @llvm.riscv.vfslide1down.mask.nxv32f16.f16(
    <vscale x 32 x half> %0,
    <vscale x 32 x half> %1,
    half %2,
    <vscale x 32 x i1> %3,
    i32 %4)

  ret <vscale x 32 x half> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfslide1down.nxv1f32.f32(
  <vscale x 1 x float>,
  float,
  i32);

define <vscale x 1 x float> @intrinsic_vfslide1down_vf_nxv1f32_nxv1f32_f32(<vscale x 1 x float> %0, float %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv1f32_nxv1f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,mf2,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfslide1down.nxv1f32.f32(
    <vscale x 1 x float> %0,
    float %1,
    i32 %2)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfslide1down.mask.nxv1f32.f32(
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  float,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x float> @intrinsic_vfslide1down_mask_vf_nxv1f32_nxv1f32_f32(<vscale x 1 x float> %0, <vscale x 1 x float> %1, float %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv1f32_nxv1f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,mf2,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v17, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfslide1down.mask.nxv1f32.f32(
    <vscale x 1 x float> %0,
    <vscale x 1 x float> %1,
    float %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfslide1down.nxv2f32.f32(
  <vscale x 2 x float>,
  float,
  i32);

define <vscale x 2 x float> @intrinsic_vfslide1down_vf_nxv2f32_nxv2f32_f32(<vscale x 2 x float> %0, float %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv2f32_nxv2f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m1,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfslide1down.nxv2f32.f32(
    <vscale x 2 x float> %0,
    float %1,
    i32 %2)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfslide1down.mask.nxv2f32.f32(
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  float,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x float> @intrinsic_vfslide1down_mask_vf_nxv2f32_nxv2f32_f32(<vscale x 2 x float> %0, <vscale x 2 x float> %1, float %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv2f32_nxv2f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m1,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v17, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfslide1down.mask.nxv2f32.f32(
    <vscale x 2 x float> %0,
    <vscale x 2 x float> %1,
    float %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfslide1down.nxv4f32.f32(
  <vscale x 4 x float>,
  float,
  i32);

define <vscale x 4 x float> @intrinsic_vfslide1down_vf_nxv4f32_nxv4f32_f32(<vscale x 4 x float> %0, float %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv4f32_nxv4f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m2,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfslide1down.nxv4f32.f32(
    <vscale x 4 x float> %0,
    float %1,
    i32 %2)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfslide1down.mask.nxv4f32.f32(
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  float,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x float> @intrinsic_vfslide1down_mask_vf_nxv4f32_nxv4f32_f32(<vscale x 4 x float> %0, <vscale x 4 x float> %1, float %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv4f32_nxv4f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m2,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v18, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfslide1down.mask.nxv4f32.f32(
    <vscale x 4 x float> %0,
    <vscale x 4 x float> %1,
    float %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfslide1down.nxv8f32.f32(
  <vscale x 8 x float>,
  float,
  i32);

define <vscale x 8 x float> @intrinsic_vfslide1down_vf_nxv8f32_nxv8f32_f32(<vscale x 8 x float> %0, float %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv8f32_nxv8f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfslide1down.nxv8f32.f32(
    <vscale x 8 x float> %0,
    float %1,
    i32 %2)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfslide1down.mask.nxv8f32.f32(
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  float,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x float> @intrinsic_vfslide1down_mask_vf_nxv8f32_nxv8f32_f32(<vscale x 8 x float> %0, <vscale x 8 x float> %1, float %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv8f32_nxv8f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v20, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfslide1down.mask.nxv8f32.f32(
    <vscale x 8 x float> %0,
    <vscale x 8 x float> %1,
    float %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfslide1down.nxv16f32.f32(
  <vscale x 16 x float>,
  float,
  i32);

define <vscale x 16 x float> @intrinsic_vfslide1down_vf_nxv16f32_nxv16f32_f32(<vscale x 16 x float> %0, float %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_vf_nxv16f32_nxv16f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m8,ta,mu
; CHECK-NEXT:    vfslide1down.vf v16, v16, ft0
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfslide1down.nxv16f32.f32(
    <vscale x 16 x float> %0,
    float %1,
    i32 %2)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfslide1down.mask.nxv16f32.f32(
  <vscale x 16 x float>,
  <vscale x 16 x float>,
  float,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x float> @intrinsic_vfslide1down_mask_vf_nxv16f32_nxv16f32_f32(<vscale x 16 x float> %0, <vscale x 16 x float> %1, float %2, <vscale x 16 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfslide1down_mask_vf_nxv16f32_nxv16f32_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, zero, e32,m8,ta,mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    fmv.w.x ft0, a1
; CHECK-NEXT:    vsetvli a0, a2, e32,m8,tu,mu
; CHECK-NEXT:    vfslide1down.vf v16, v8, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfslide1down.mask.nxv16f32.f32(
    <vscale x 16 x float> %0,
    <vscale x 16 x float> %1,
    float %2,
    <vscale x 16 x i1> %3,
    i32 %4)

  ret <vscale x 16 x float> %a
}
