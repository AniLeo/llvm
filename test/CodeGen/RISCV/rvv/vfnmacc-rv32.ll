; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+f,+experimental-zfh -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x half> @llvm.riscv.vfnmacc.nxv1f16.nxv1f16(
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  i32);

define <vscale x 1 x half>  @intrinsic_vfnmacc_vv_nxv1f16_nxv1f16_nxv1f16(<vscale x 1 x half> %0, <vscale x 1 x half> %1, <vscale x 1 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv1f16_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf4,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfnmacc.nxv1f16.nxv1f16(
    <vscale x 1 x half> %0,
    <vscale x 1 x half> %1,
    <vscale x 1 x half> %2,
    i32 %3)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfnmacc.mask.nxv1f16.nxv1f16(
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x half>  @intrinsic_vfnmacc_mask_vv_nxv1f16_nxv1f16_nxv1f16(<vscale x 1 x half> %0, <vscale x 1 x half> %1, <vscale x 1 x half> %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv1f16_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf4,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfnmacc.mask.nxv1f16.nxv1f16(
    <vscale x 1 x half> %0,
    <vscale x 1 x half> %1,
    <vscale x 1 x half> %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfnmacc.nxv2f16.nxv2f16(
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  i32);

define <vscale x 2 x half>  @intrinsic_vfnmacc_vv_nxv2f16_nxv2f16_nxv2f16(<vscale x 2 x half> %0, <vscale x 2 x half> %1, <vscale x 2 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv2f16_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfnmacc.nxv2f16.nxv2f16(
    <vscale x 2 x half> %0,
    <vscale x 2 x half> %1,
    <vscale x 2 x half> %2,
    i32 %3)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfnmacc.mask.nxv2f16.nxv2f16(
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x half>  @intrinsic_vfnmacc_mask_vv_nxv2f16_nxv2f16_nxv2f16(<vscale x 2 x half> %0, <vscale x 2 x half> %1, <vscale x 2 x half> %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv2f16_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfnmacc.mask.nxv2f16.nxv2f16(
    <vscale x 2 x half> %0,
    <vscale x 2 x half> %1,
    <vscale x 2 x half> %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfnmacc.nxv4f16.nxv4f16(
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  i32);

define <vscale x 4 x half>  @intrinsic_vfnmacc_vv_nxv4f16_nxv4f16_nxv4f16(<vscale x 4 x half> %0, <vscale x 4 x half> %1, <vscale x 4 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv4f16_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfnmacc.nxv4f16.nxv4f16(
    <vscale x 4 x half> %0,
    <vscale x 4 x half> %1,
    <vscale x 4 x half> %2,
    i32 %3)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfnmacc.mask.nxv4f16.nxv4f16(
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x half>  @intrinsic_vfnmacc_mask_vv_nxv4f16_nxv4f16_nxv4f16(<vscale x 4 x half> %0, <vscale x 4 x half> %1, <vscale x 4 x half> %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv4f16_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfnmacc.mask.nxv4f16.nxv4f16(
    <vscale x 4 x half> %0,
    <vscale x 4 x half> %1,
    <vscale x 4 x half> %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfnmacc.nxv8f16.nxv8f16(
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  i32);

define <vscale x 8 x half>  @intrinsic_vfnmacc_vv_nxv8f16_nxv8f16_nxv8f16(<vscale x 8 x half> %0, <vscale x 8 x half> %1, <vscale x 8 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv8f16_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v18, v20
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfnmacc.nxv8f16.nxv8f16(
    <vscale x 8 x half> %0,
    <vscale x 8 x half> %1,
    <vscale x 8 x half> %2,
    i32 %3)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfnmacc.mask.nxv8f16.nxv8f16(
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x half>  @intrinsic_vfnmacc_mask_vv_nxv8f16_nxv8f16_nxv8f16(<vscale x 8 x half> %0, <vscale x 8 x half> %1, <vscale x 8 x half> %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv8f16_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v18, v20, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfnmacc.mask.nxv8f16.nxv8f16(
    <vscale x 8 x half> %0,
    <vscale x 8 x half> %1,
    <vscale x 8 x half> %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfnmacc.nxv16f16.nxv16f16(
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  i32);

define <vscale x 16 x half>  @intrinsic_vfnmacc_vv_nxv16f16_nxv16f16_nxv16f16(<vscale x 16 x half> %0, <vscale x 16 x half> %1, <vscale x 16 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv16f16_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a2, zero, e16,m4,ta,mu
; CHECK-NEXT:    vle16.v v28, (a0)
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v20, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfnmacc.nxv16f16.nxv16f16(
    <vscale x 16 x half> %0,
    <vscale x 16 x half> %1,
    <vscale x 16 x half> %2,
    i32 %3)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfnmacc.mask.nxv16f16.nxv16f16(
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x half>  @intrinsic_vfnmacc_mask_vv_nxv16f16_nxv16f16_nxv16f16(<vscale x 16 x half> %0, <vscale x 16 x half> %1, <vscale x 16 x half> %2, <vscale x 16 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv16f16_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a2, zero, e16,m4,ta,mu
; CHECK-NEXT:    vle16.v v28, (a0)
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v20, v28, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfnmacc.mask.nxv16f16.nxv16f16(
    <vscale x 16 x half> %0,
    <vscale x 16 x half> %1,
    <vscale x 16 x half> %2,
    <vscale x 16 x i1> %3,
    i32 %4)

  ret <vscale x 16 x half> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfnmacc.nxv1f32.nxv1f32(
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  i32);

define <vscale x 1 x float>  @intrinsic_vfnmacc_vv_nxv1f32_nxv1f32_nxv1f32(<vscale x 1 x float> %0, <vscale x 1 x float> %1, <vscale x 1 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv1f32_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfnmacc.nxv1f32.nxv1f32(
    <vscale x 1 x float> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x float> %2,
    i32 %3)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfnmacc.mask.nxv1f32.nxv1f32(
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x float>  @intrinsic_vfnmacc_mask_vv_nxv1f32_nxv1f32_nxv1f32(<vscale x 1 x float> %0, <vscale x 1 x float> %1, <vscale x 1 x float> %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv1f32_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfnmacc.mask.nxv1f32.nxv1f32(
    <vscale x 1 x float> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x float> %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfnmacc.nxv2f32.nxv2f32(
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  i32);

define <vscale x 2 x float>  @intrinsic_vfnmacc_vv_nxv2f32_nxv2f32_nxv2f32(<vscale x 2 x float> %0, <vscale x 2 x float> %1, <vscale x 2 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv2f32_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfnmacc.nxv2f32.nxv2f32(
    <vscale x 2 x float> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x float> %2,
    i32 %3)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfnmacc.mask.nxv2f32.nxv2f32(
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x float>  @intrinsic_vfnmacc_mask_vv_nxv2f32_nxv2f32_nxv2f32(<vscale x 2 x float> %0, <vscale x 2 x float> %1, <vscale x 2 x float> %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv2f32_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v17, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfnmacc.mask.nxv2f32.nxv2f32(
    <vscale x 2 x float> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x float> %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfnmacc.nxv4f32.nxv4f32(
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  i32);

define <vscale x 4 x float>  @intrinsic_vfnmacc_vv_nxv4f32_nxv4f32_nxv4f32(<vscale x 4 x float> %0, <vscale x 4 x float> %1, <vscale x 4 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv4f32_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v18, v20
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfnmacc.nxv4f32.nxv4f32(
    <vscale x 4 x float> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x float> %2,
    i32 %3)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfnmacc.mask.nxv4f32.nxv4f32(
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x float>  @intrinsic_vfnmacc_mask_vv_nxv4f32_nxv4f32_nxv4f32(<vscale x 4 x float> %0, <vscale x 4 x float> %1, <vscale x 4 x float> %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv4f32_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v18, v20, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfnmacc.mask.nxv4f32.nxv4f32(
    <vscale x 4 x float> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x float> %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfnmacc.nxv8f32.nxv8f32(
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  i32);

define <vscale x 8 x float>  @intrinsic_vfnmacc_vv_nxv8f32_nxv8f32_nxv8f32(<vscale x 8 x float> %0, <vscale x 8 x float> %1, <vscale x 8 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vv_nxv8f32_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a2, zero, e32,m4,ta,mu
; CHECK-NEXT:    vle32.v v28, (a0)
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v20, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfnmacc.nxv8f32.nxv8f32(
    <vscale x 8 x float> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x float> %2,
    i32 %3)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfnmacc.mask.nxv8f32.nxv8f32(
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x float>  @intrinsic_vfnmacc_mask_vv_nxv8f32_nxv8f32_nxv8f32(<vscale x 8 x float> %0, <vscale x 8 x float> %1, <vscale x 8 x float> %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vv_nxv8f32_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a2, zero, e32,m4,ta,mu
; CHECK-NEXT:    vle32.v v28, (a0)
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vv v16, v20, v28, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfnmacc.mask.nxv8f32.nxv8f32(
    <vscale x 8 x float> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x float> %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x float> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfnmacc.nxv1f16.f16(
  <vscale x 1 x half>,
  half,
  <vscale x 1 x half>,
  i32);

define <vscale x 1 x half>  @intrinsic_vfnmacc_vf_nxv1f16_f16_nxv1f16(<vscale x 1 x half> %0, half %1, <vscale x 1 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv1f16_f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf4,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfnmacc.nxv1f16.f16(
    <vscale x 1 x half> %0,
    half %1,
    <vscale x 1 x half> %2,
    i32 %3)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfnmacc.mask.nxv1f16.f16(
  <vscale x 1 x half>,
  half,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x half> @intrinsic_vfnmacc_mask_vf_nxv1f16_f16_nxv1f16(<vscale x 1 x half> %0, half %1, <vscale x 1 x half> %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv1f16_f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf4,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfnmacc.mask.nxv1f16.f16(
    <vscale x 1 x half> %0,
    half %1,
    <vscale x 1 x half> %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfnmacc.nxv2f16.f16(
  <vscale x 2 x half>,
  half,
  <vscale x 2 x half>,
  i32);

define <vscale x 2 x half>  @intrinsic_vfnmacc_vf_nxv2f16_f16_nxv2f16(<vscale x 2 x half> %0, half %1, <vscale x 2 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv2f16_f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfnmacc.nxv2f16.f16(
    <vscale x 2 x half> %0,
    half %1,
    <vscale x 2 x half> %2,
    i32 %3)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfnmacc.mask.nxv2f16.f16(
  <vscale x 2 x half>,
  half,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x half> @intrinsic_vfnmacc_mask_vf_nxv2f16_f16_nxv2f16(<vscale x 2 x half> %0, half %1, <vscale x 2 x half> %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv2f16_f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfnmacc.mask.nxv2f16.f16(
    <vscale x 2 x half> %0,
    half %1,
    <vscale x 2 x half> %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfnmacc.nxv4f16.f16(
  <vscale x 4 x half>,
  half,
  <vscale x 4 x half>,
  i32);

define <vscale x 4 x half>  @intrinsic_vfnmacc_vf_nxv4f16_f16_nxv4f16(<vscale x 4 x half> %0, half %1, <vscale x 4 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv4f16_f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfnmacc.nxv4f16.f16(
    <vscale x 4 x half> %0,
    half %1,
    <vscale x 4 x half> %2,
    i32 %3)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfnmacc.mask.nxv4f16.f16(
  <vscale x 4 x half>,
  half,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x half> @intrinsic_vfnmacc_mask_vf_nxv4f16_f16_nxv4f16(<vscale x 4 x half> %0, half %1, <vscale x 4 x half> %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv4f16_f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfnmacc.mask.nxv4f16.f16(
    <vscale x 4 x half> %0,
    half %1,
    <vscale x 4 x half> %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfnmacc.nxv8f16.f16(
  <vscale x 8 x half>,
  half,
  <vscale x 8 x half>,
  i32);

define <vscale x 8 x half>  @intrinsic_vfnmacc_vf_nxv8f16_f16_nxv8f16(<vscale x 8 x half> %0, half %1, <vscale x 8 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv8f16_f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfnmacc.nxv8f16.f16(
    <vscale x 8 x half> %0,
    half %1,
    <vscale x 8 x half> %2,
    i32 %3)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfnmacc.mask.nxv8f16.f16(
  <vscale x 8 x half>,
  half,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x half> @intrinsic_vfnmacc_mask_vf_nxv8f16_f16_nxv8f16(<vscale x 8 x half> %0, half %1, <vscale x 8 x half> %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv8f16_f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfnmacc.mask.nxv8f16.f16(
    <vscale x 8 x half> %0,
    half %1,
    <vscale x 8 x half> %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfnmacc.nxv16f16.f16(
  <vscale x 16 x half>,
  half,
  <vscale x 16 x half>,
  i32);

define <vscale x 16 x half>  @intrinsic_vfnmacc_vf_nxv16f16_f16_nxv16f16(<vscale x 16 x half> %0, half %1, <vscale x 16 x half> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv16f16_f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v20
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfnmacc.nxv16f16.f16(
    <vscale x 16 x half> %0,
    half %1,
    <vscale x 16 x half> %2,
    i32 %3)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfnmacc.mask.nxv16f16.f16(
  <vscale x 16 x half>,
  half,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x half> @intrinsic_vfnmacc_mask_vf_nxv16f16_f16_nxv16f16(<vscale x 16 x half> %0, half %1, <vscale x 16 x half> %2, <vscale x 16 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv16f16_f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v20, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfnmacc.mask.nxv16f16.f16(
    <vscale x 16 x half> %0,
    half %1,
    <vscale x 16 x half> %2,
    <vscale x 16 x i1> %3,
    i32 %4)

  ret <vscale x 16 x half> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfnmacc.nxv1f32.f32(
  <vscale x 1 x float>,
  float,
  <vscale x 1 x float>,
  i32);

define <vscale x 1 x float>  @intrinsic_vfnmacc_vf_nxv1f32_f32_nxv1f32(<vscale x 1 x float> %0, float %1, <vscale x 1 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv1f32_f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfnmacc.nxv1f32.f32(
    <vscale x 1 x float> %0,
    float %1,
    <vscale x 1 x float> %2,
    i32 %3)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfnmacc.mask.nxv1f32.f32(
  <vscale x 1 x float>,
  float,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x float> @intrinsic_vfnmacc_mask_vf_nxv1f32_f32_nxv1f32(<vscale x 1 x float> %0, float %1, <vscale x 1 x float> %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv1f32_f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,mf2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfnmacc.mask.nxv1f32.f32(
    <vscale x 1 x float> %0,
    float %1,
    <vscale x 1 x float> %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfnmacc.nxv2f32.f32(
  <vscale x 2 x float>,
  float,
  <vscale x 2 x float>,
  i32);

define <vscale x 2 x float>  @intrinsic_vfnmacc_vf_nxv2f32_f32_nxv2f32(<vscale x 2 x float> %0, float %1, <vscale x 2 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv2f32_f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfnmacc.nxv2f32.f32(
    <vscale x 2 x float> %0,
    float %1,
    <vscale x 2 x float> %2,
    i32 %3)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfnmacc.mask.nxv2f32.f32(
  <vscale x 2 x float>,
  float,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x float> @intrinsic_vfnmacc_mask_vf_nxv2f32_f32_nxv2f32(<vscale x 2 x float> %0, float %1, <vscale x 2 x float> %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv2f32_f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m1,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfnmacc.mask.nxv2f32.f32(
    <vscale x 2 x float> %0,
    float %1,
    <vscale x 2 x float> %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfnmacc.nxv4f32.f32(
  <vscale x 4 x float>,
  float,
  <vscale x 4 x float>,
  i32);

define <vscale x 4 x float>  @intrinsic_vfnmacc_vf_nxv4f32_f32_nxv4f32(<vscale x 4 x float> %0, float %1, <vscale x 4 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv4f32_f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfnmacc.nxv4f32.f32(
    <vscale x 4 x float> %0,
    float %1,
    <vscale x 4 x float> %2,
    i32 %3)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfnmacc.mask.nxv4f32.f32(
  <vscale x 4 x float>,
  float,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x float> @intrinsic_vfnmacc_mask_vf_nxv4f32_f32_nxv4f32(<vscale x 4 x float> %0, float %1, <vscale x 4 x float> %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv4f32_f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m2,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfnmacc.mask.nxv4f32.f32(
    <vscale x 4 x float> %0,
    float %1,
    <vscale x 4 x float> %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfnmacc.nxv8f32.f32(
  <vscale x 8 x float>,
  float,
  <vscale x 8 x float>,
  i32);

define <vscale x 8 x float>  @intrinsic_vfnmacc_vf_nxv8f32_f32_nxv8f32(<vscale x 8 x float> %0, float %1, <vscale x 8 x float> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_vf_nxv8f32_f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v20
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfnmacc.nxv8f32.f32(
    <vscale x 8 x float> %0,
    float %1,
    <vscale x 8 x float> %2,
    i32 %3)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfnmacc.mask.nxv8f32.f32(
  <vscale x 8 x float>,
  float,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x float> @intrinsic_vfnmacc_mask_vf_nxv8f32_f32_nxv8f32(<vscale x 8 x float> %0, float %1, <vscale x 8 x float> %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vfnmacc_mask_vf_nxv8f32_f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,ta,mu
; CHECK-NEXT:    vfnmacc.vf v16, ft0, v20, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfnmacc.mask.nxv8f32.f32(
    <vscale x 8 x float> %0,
    float %1,
    <vscale x 8 x float> %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x float> %a
}
