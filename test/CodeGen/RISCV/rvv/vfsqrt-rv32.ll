; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+d,+zfh -verify-machineinstrs \
; RUN:   < %s | FileCheck %s
declare <vscale x 1 x half> @llvm.riscv.vfsqrt.nxv1f16(
  <vscale x 1 x half>,
  i32);

define <vscale x 1 x half> @intrinsic_vfsqrt_v_nxv1f16_nxv1f16(<vscale x 1 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfsqrt.nxv1f16(
    <vscale x 1 x half> %0,
    i32 %1)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfsqrt.mask.nxv1f16(
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  i32,
  i32);

define <vscale x 1 x half> @intrinsic_vfsqrt_mask_v_nxv1f16_nxv1f16(<vscale x 1 x i1> %0, <vscale x 1 x half> %1, <vscale x 1 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfsqrt.mask.nxv1f16(
    <vscale x 1 x half> %1,
    <vscale x 1 x half> %2,
    <vscale x 1 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfsqrt.nxv2f16(
  <vscale x 2 x half>,
  i32);

define <vscale x 2 x half> @intrinsic_vfsqrt_v_nxv2f16_nxv2f16(<vscale x 2 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfsqrt.nxv2f16(
    <vscale x 2 x half> %0,
    i32 %1)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfsqrt.mask.nxv2f16(
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  i32,
  i32);

define <vscale x 2 x half> @intrinsic_vfsqrt_mask_v_nxv2f16_nxv2f16(<vscale x 2 x i1> %0, <vscale x 2 x half> %1, <vscale x 2 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfsqrt.mask.nxv2f16(
    <vscale x 2 x half> %1,
    <vscale x 2 x half> %2,
    <vscale x 2 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfsqrt.nxv4f16(
  <vscale x 4 x half>,
  i32);

define <vscale x 4 x half> @intrinsic_vfsqrt_v_nxv4f16_nxv4f16(<vscale x 4 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfsqrt.nxv4f16(
    <vscale x 4 x half> %0,
    i32 %1)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfsqrt.mask.nxv4f16(
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  i32,
  i32);

define <vscale x 4 x half> @intrinsic_vfsqrt_mask_v_nxv4f16_nxv4f16(<vscale x 4 x i1> %0, <vscale x 4 x half> %1, <vscale x 4 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfsqrt.mask.nxv4f16(
    <vscale x 4 x half> %1,
    <vscale x 4 x half> %2,
    <vscale x 4 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfsqrt.nxv8f16(
  <vscale x 8 x half>,
  i32);

define <vscale x 8 x half> @intrinsic_vfsqrt_v_nxv8f16_nxv8f16(<vscale x 8 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfsqrt.nxv8f16(
    <vscale x 8 x half> %0,
    i32 %1)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfsqrt.mask.nxv8f16(
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  i32,
  i32);

define <vscale x 8 x half> @intrinsic_vfsqrt_mask_v_nxv8f16_nxv8f16(<vscale x 8 x i1> %0, <vscale x 8 x half> %1, <vscale x 8 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfsqrt.mask.nxv8f16(
    <vscale x 8 x half> %1,
    <vscale x 8 x half> %2,
    <vscale x 8 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfsqrt.nxv16f16(
  <vscale x 16 x half>,
  i32);

define <vscale x 16 x half> @intrinsic_vfsqrt_v_nxv16f16_nxv16f16(<vscale x 16 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfsqrt.nxv16f16(
    <vscale x 16 x half> %0,
    i32 %1)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfsqrt.mask.nxv16f16(
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  i32,
  i32);

define <vscale x 16 x half> @intrinsic_vfsqrt_mask_v_nxv16f16_nxv16f16(<vscale x 16 x i1> %0, <vscale x 16 x half> %1, <vscale x 16 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfsqrt.mask.nxv16f16(
    <vscale x 16 x half> %1,
    <vscale x 16 x half> %2,
    <vscale x 16 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 16 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vfsqrt.nxv32f16(
  <vscale x 32 x half>,
  i32);

define <vscale x 32 x half> @intrinsic_vfsqrt_v_nxv32f16_nxv32f16(<vscale x 32 x half> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv32f16_nxv32f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m8, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x half> @llvm.riscv.vfsqrt.nxv32f16(
    <vscale x 32 x half> %0,
    i32 %1)

  ret <vscale x 32 x half> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfsqrt.nxv1f32(
  <vscale x 1 x float>,
  i32);

define <vscale x 1 x float> @intrinsic_vfsqrt_v_nxv1f32_nxv1f32(<vscale x 1 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfsqrt.nxv1f32(
    <vscale x 1 x float> %0,
    i32 %1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfsqrt.mask.nxv1f32(
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  i32,
  i32);

define <vscale x 1 x float> @intrinsic_vfsqrt_mask_v_nxv1f32_nxv1f32(<vscale x 1 x i1> %0, <vscale x 1 x float> %1, <vscale x 1 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfsqrt.mask.nxv1f32(
    <vscale x 1 x float> %1,
    <vscale x 1 x float> %2,
    <vscale x 1 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfsqrt.nxv2f32(
  <vscale x 2 x float>,
  i32);

define <vscale x 2 x float> @intrinsic_vfsqrt_v_nxv2f32_nxv2f32(<vscale x 2 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfsqrt.nxv2f32(
    <vscale x 2 x float> %0,
    i32 %1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfsqrt.mask.nxv2f32(
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  i32,
  i32);

define <vscale x 2 x float> @intrinsic_vfsqrt_mask_v_nxv2f32_nxv2f32(<vscale x 2 x i1> %0, <vscale x 2 x float> %1, <vscale x 2 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfsqrt.mask.nxv2f32(
    <vscale x 2 x float> %1,
    <vscale x 2 x float> %2,
    <vscale x 2 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfsqrt.nxv4f32(
  <vscale x 4 x float>,
  i32);

define <vscale x 4 x float> @intrinsic_vfsqrt_v_nxv4f32_nxv4f32(<vscale x 4 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfsqrt.nxv4f32(
    <vscale x 4 x float> %0,
    i32 %1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfsqrt.mask.nxv4f32(
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  i32,
  i32);

define <vscale x 4 x float> @intrinsic_vfsqrt_mask_v_nxv4f32_nxv4f32(<vscale x 4 x i1> %0, <vscale x 4 x float> %1, <vscale x 4 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfsqrt.mask.nxv4f32(
    <vscale x 4 x float> %1,
    <vscale x 4 x float> %2,
    <vscale x 4 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfsqrt.nxv8f32(
  <vscale x 8 x float>,
  i32);

define <vscale x 8 x float> @intrinsic_vfsqrt_v_nxv8f32_nxv8f32(<vscale x 8 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfsqrt.nxv8f32(
    <vscale x 8 x float> %0,
    i32 %1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfsqrt.mask.nxv8f32(
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  i32,
  i32);

define <vscale x 8 x float> @intrinsic_vfsqrt_mask_v_nxv8f32_nxv8f32(<vscale x 8 x i1> %0, <vscale x 8 x float> %1, <vscale x 8 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfsqrt.mask.nxv8f32(
    <vscale x 8 x float> %1,
    <vscale x 8 x float> %2,
    <vscale x 8 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfsqrt.nxv16f32(
  <vscale x 16 x float>,
  i32);

define <vscale x 16 x float> @intrinsic_vfsqrt_v_nxv16f32_nxv16f32(<vscale x 16 x float> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv16f32_nxv16f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m8, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfsqrt.nxv16f32(
    <vscale x 16 x float> %0,
    i32 %1)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfsqrt.nxv1f64(
  <vscale x 1 x double>,
  i32);

define <vscale x 1 x double> @intrinsic_vfsqrt_v_nxv1f64_nxv1f64(<vscale x 1 x double> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv1f64_nxv1f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfsqrt.nxv1f64(
    <vscale x 1 x double> %0,
    i32 %1)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfsqrt.mask.nxv1f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x i1>,
  i32,
  i32);

define <vscale x 1 x double> @intrinsic_vfsqrt_mask_v_nxv1f64_nxv1f64(<vscale x 1 x i1> %0, <vscale x 1 x double> %1, <vscale x 1 x double> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv1f64_nxv1f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfsqrt.mask.nxv1f64(
    <vscale x 1 x double> %1,
    <vscale x 1 x double> %2,
    <vscale x 1 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfsqrt.nxv2f64(
  <vscale x 2 x double>,
  i32);

define <vscale x 2 x double> @intrinsic_vfsqrt_v_nxv2f64_nxv2f64(<vscale x 2 x double> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv2f64_nxv2f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfsqrt.nxv2f64(
    <vscale x 2 x double> %0,
    i32 %1)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfsqrt.mask.nxv2f64(
  <vscale x 2 x double>,
  <vscale x 2 x double>,
  <vscale x 2 x i1>,
  i32,
  i32);

define <vscale x 2 x double> @intrinsic_vfsqrt_mask_v_nxv2f64_nxv2f64(<vscale x 2 x i1> %0, <vscale x 2 x double> %1, <vscale x 2 x double> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv2f64_nxv2f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfsqrt.mask.nxv2f64(
    <vscale x 2 x double> %1,
    <vscale x 2 x double> %2,
    <vscale x 2 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfsqrt.nxv4f64(
  <vscale x 4 x double>,
  i32);

define <vscale x 4 x double> @intrinsic_vfsqrt_v_nxv4f64_nxv4f64(<vscale x 4 x double> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv4f64_nxv4f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfsqrt.nxv4f64(
    <vscale x 4 x double> %0,
    i32 %1)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfsqrt.mask.nxv4f64(
  <vscale x 4 x double>,
  <vscale x 4 x double>,
  <vscale x 4 x i1>,
  i32,
  i32);

define <vscale x 4 x double> @intrinsic_vfsqrt_mask_v_nxv4f64_nxv4f64(<vscale x 4 x i1> %0, <vscale x 4 x double> %1, <vscale x 4 x double> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_mask_v_nxv4f64_nxv4f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfsqrt.mask.nxv4f64(
    <vscale x 4 x double> %1,
    <vscale x 4 x double> %2,
    <vscale x 4 x i1> %0,
    i32 %3, i32 1)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfsqrt.nxv8f64(
  <vscale x 8 x double>,
  i32);

define <vscale x 8 x double> @intrinsic_vfsqrt_v_nxv8f64_nxv8f64(<vscale x 8 x double> %0, i32 %1) nounwind {
; CHECK-LABEL: intrinsic_vfsqrt_v_nxv8f64_nxv8f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vfsqrt.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfsqrt.nxv8f64(
    <vscale x 8 x double> %0,
    i32 %1)

  ret <vscale x 8 x double> %a
}
