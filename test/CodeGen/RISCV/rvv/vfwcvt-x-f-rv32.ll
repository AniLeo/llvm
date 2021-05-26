; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+d,+experimental-zfh -verify-machineinstrs \
; RUN:   < %s | FileCheck %s
declare <vscale x 1 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv1i32.nxv1f16(
  <vscale x 1 x half>,
  i32);

define <vscale x 1 x i32> @intrinsic_vfwcvt_x.f.v_nxv1i32_nxv1f16(<vscale x 1 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv1i32_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf4,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv1i32.nxv1f16(
    <vscale x 1 x half> %0,
    i32 %1)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv1i32.nxv1f16(
  <vscale x 1 x i32>,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x i32> @intrinsic_vfwcvt_mask_x.f.v_nxv1i32_nxv1f16(<vscale x 1 x i32> %0, <vscale x 1 x half> %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv1i32_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf4,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv1i32.nxv1f16(
    <vscale x 1 x i32> %0,
    <vscale x 1 x half> %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv2i32.nxv2f16(
  <vscale x 2 x half>,
  i32);

define <vscale x 2 x i32> @intrinsic_vfwcvt_x.f.v_nxv2i32_nxv2f16(<vscale x 2 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv2i32_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf2,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv2i32.nxv2f16(
    <vscale x 2 x half> %0,
    i32 %1)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv2i32.nxv2f16(
  <vscale x 2 x i32>,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x i32> @intrinsic_vfwcvt_mask_x.f.v_nxv2i32_nxv2f16(<vscale x 2 x i32> %0, <vscale x 2 x half> %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv2i32_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf2,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv2i32.nxv2f16(
    <vscale x 2 x i32> %0,
    <vscale x 2 x half> %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv4i32.nxv4f16(
  <vscale x 4 x half>,
  i32);

define <vscale x 4 x i32> @intrinsic_vfwcvt_x.f.v_nxv4i32_nxv4f16(<vscale x 4 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv4i32_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m1,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv4i32.nxv4f16(
    <vscale x 4 x half> %0,
    i32 %1)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv4i32.nxv4f16(
  <vscale x 4 x i32>,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x i32> @intrinsic_vfwcvt_mask_x.f.v_nxv4i32_nxv4f16(<vscale x 4 x i32> %0, <vscale x 4 x half> %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv4i32_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m1,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv4i32.nxv4f16(
    <vscale x 4 x i32> %0,
    <vscale x 4 x half> %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv8i32.nxv8f16(
  <vscale x 8 x half>,
  i32);

define <vscale x 8 x i32> @intrinsic_vfwcvt_x.f.v_nxv8i32_nxv8f16(<vscale x 8 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv8i32_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m2,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv8i32.nxv8f16(
    <vscale x 8 x half> %0,
    i32 %1)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv8i32.nxv8f16(
  <vscale x 8 x i32>,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x i32> @intrinsic_vfwcvt_mask_x.f.v_nxv8i32_nxv8f16(<vscale x 8 x i32> %0, <vscale x 8 x half> %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv8i32_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m2,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv8i32.nxv8f16(
    <vscale x 8 x i32> %0,
    <vscale x 8 x half> %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv16i32.nxv16f16(
  <vscale x 16 x half>,
  i32);

define <vscale x 16 x i32> @intrinsic_vfwcvt_x.f.v_nxv16i32_nxv16f16(<vscale x 16 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv16i32_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m4,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vfwcvt.x.f.v.nxv16i32.nxv16f16(
    <vscale x 16 x half> %0,
    i32 %1)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv16i32.nxv16f16(
  <vscale x 16 x i32>,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x i32> @intrinsic_vfwcvt_mask_x.f.v_nxv16i32_nxv16f16(<vscale x 16 x i32> %0, <vscale x 16 x half> %1, <vscale x 16 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv16i32_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m4,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vfwcvt.x.f.v.mask.nxv16i32.nxv16f16(
    <vscale x 16 x i32> %0,
    <vscale x 16 x half> %1,
    <vscale x 16 x i1> %2,
    i32 %3)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv1i64.nxv1f32(
  <vscale x 1 x float>,
  i32);

define <vscale x 1 x i64> @intrinsic_vfwcvt_x.f.v_nxv1i64_nxv1f32(<vscale x 1 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv1i64_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,mf2,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv1i64.nxv1f32(
    <vscale x 1 x float> %0,
    i32 %1)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv1i64.nxv1f32(
  <vscale x 1 x i64>,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x i64> @intrinsic_vfwcvt_mask_x.f.v_nxv1i64_nxv1f32(<vscale x 1 x i64> %0, <vscale x 1 x float> %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv1i64_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,mf2,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv1i64.nxv1f32(
    <vscale x 1 x i64> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv2i64.nxv2f32(
  <vscale x 2 x float>,
  i32);

define <vscale x 2 x i64> @intrinsic_vfwcvt_x.f.v_nxv2i64_nxv2f32(<vscale x 2 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv2i64_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m1,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv2i64.nxv2f32(
    <vscale x 2 x float> %0,
    i32 %1)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv2i64.nxv2f32(
  <vscale x 2 x i64>,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x i64> @intrinsic_vfwcvt_mask_x.f.v_nxv2i64_nxv2f32(<vscale x 2 x i64> %0, <vscale x 2 x float> %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv2i64_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m1,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv2i64.nxv2f32(
    <vscale x 2 x i64> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv4i64.nxv4f32(
  <vscale x 4 x float>,
  i32);

define <vscale x 4 x i64> @intrinsic_vfwcvt_x.f.v_nxv4i64_nxv4f32(<vscale x 4 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv4i64_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m2,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv4i64.nxv4f32(
    <vscale x 4 x float> %0,
    i32 %1)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv4i64.nxv4f32(
  <vscale x 4 x i64>,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x i64> @intrinsic_vfwcvt_mask_x.f.v_nxv4i64_nxv4f32(<vscale x 4 x i64> %0, <vscale x 4 x float> %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv4i64_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m2,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv4i64.nxv4f32(
    <vscale x 4 x i64> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv8i64.nxv8f32(
  <vscale x 8 x float>,
  i32);

define <vscale x 8 x i64> @intrinsic_vfwcvt_x.f.v_nxv8i64_nxv8f32(<vscale x 8 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_x.f.v_nxv8i64_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m4,ta,mu
; CHECK-NEXT:    vfwcvt.x.f.v v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vfwcvt.x.f.v.nxv8i64.nxv8f32(
    <vscale x 8 x float> %0,
    i32 %1)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv8i64.nxv8f32(
  <vscale x 8 x i64>,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x i64> @intrinsic_vfwcvt_mask_x.f.v_nxv8i64_nxv8f32(<vscale x 8 x i64> %0, <vscale x 8 x float> %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfwcvt_mask_x.f.v_nxv8i64_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m4,tu,mu
; CHECK-NEXT:    vfwcvt.x.f.v v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vfwcvt.x.f.v.mask.nxv8i64.nxv8f32(
    <vscale x 8 x i64> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x i64> %a
}
