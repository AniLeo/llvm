; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+v,+zfh,+experimental-zvfh \
; RUN:   -verify-machineinstrs -target-abi=ilp32d | FileCheck %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+v,+zfh,+experimental-zvfh \
; RUN:   -verify-machineinstrs -target-abi=lp64d | FileCheck %s
declare <vscale x 1 x float> @llvm.riscv.vfwnmacc.nxv1f32.nxv1f16(
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  iXLen,
  iXLen);

define <vscale x 1 x float>  @intrinsic_vfwnmacc_vv_nxv1f32_nxv1f16_nxv1f16(<vscale x 1 x float> %0, <vscale x 1 x half> %1, <vscale x 1 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv1f32_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v9, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwnmacc.nxv1f32.nxv1f16(
    <vscale x 1 x float> %0,
    <vscale x 1 x half> %1,
    <vscale x 1 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwnmacc.mask.nxv1f32.nxv1f16(
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  iXLen, iXLen);

define <vscale x 1 x float>  @intrinsic_vfwnmacc_mask_vv_nxv1f32_nxv1f16_nxv1f16(<vscale x 1 x float> %0, <vscale x 1 x half> %1, <vscale x 1 x half> %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv1f32_nxv1f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v9, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwnmacc.mask.nxv1f32.nxv1f16(
    <vscale x 1 x float> %0,
    <vscale x 1 x half> %1,
    <vscale x 1 x half> %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwnmacc.nxv2f32.nxv2f16(
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  iXLen,
  iXLen);

define <vscale x 2 x float>  @intrinsic_vfwnmacc_vv_nxv2f32_nxv2f16_nxv2f16(<vscale x 2 x float> %0, <vscale x 2 x half> %1, <vscale x 2 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv2f32_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v9, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwnmacc.nxv2f32.nxv2f16(
    <vscale x 2 x float> %0,
    <vscale x 2 x half> %1,
    <vscale x 2 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwnmacc.mask.nxv2f32.nxv2f16(
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  iXLen, iXLen);

define <vscale x 2 x float>  @intrinsic_vfwnmacc_mask_vv_nxv2f32_nxv2f16_nxv2f16(<vscale x 2 x float> %0, <vscale x 2 x half> %1, <vscale x 2 x half> %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv2f32_nxv2f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v9, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwnmacc.mask.nxv2f32.nxv2f16(
    <vscale x 2 x float> %0,
    <vscale x 2 x half> %1,
    <vscale x 2 x half> %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwnmacc.nxv4f32.nxv4f16(
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  iXLen,
  iXLen);

define <vscale x 4 x float>  @intrinsic_vfwnmacc_vv_nxv4f32_nxv4f16_nxv4f16(<vscale x 4 x float> %0, <vscale x 4 x half> %1, <vscale x 4 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv4f32_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v10, v11
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwnmacc.nxv4f32.nxv4f16(
    <vscale x 4 x float> %0,
    <vscale x 4 x half> %1,
    <vscale x 4 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwnmacc.mask.nxv4f32.nxv4f16(
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  iXLen, iXLen);

define <vscale x 4 x float>  @intrinsic_vfwnmacc_mask_vv_nxv4f32_nxv4f16_nxv4f16(<vscale x 4 x float> %0, <vscale x 4 x half> %1, <vscale x 4 x half> %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv4f32_nxv4f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v10, v11, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwnmacc.mask.nxv4f32.nxv4f16(
    <vscale x 4 x float> %0,
    <vscale x 4 x half> %1,
    <vscale x 4 x half> %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwnmacc.nxv8f32.nxv8f16(
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  iXLen,
  iXLen);

define <vscale x 8 x float>  @intrinsic_vfwnmacc_vv_nxv8f32_nxv8f16_nxv8f16(<vscale x 8 x float> %0, <vscale x 8 x half> %1, <vscale x 8 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv8f32_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v12, v14
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwnmacc.nxv8f32.nxv8f16(
    <vscale x 8 x float> %0,
    <vscale x 8 x half> %1,
    <vscale x 8 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwnmacc.mask.nxv8f32.nxv8f16(
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  iXLen, iXLen);

define <vscale x 8 x float>  @intrinsic_vfwnmacc_mask_vv_nxv8f32_nxv8f16_nxv8f16(<vscale x 8 x float> %0, <vscale x 8 x half> %1, <vscale x 8 x half> %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv8f32_nxv8f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v12, v14, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwnmacc.mask.nxv8f32.nxv8f16(
    <vscale x 8 x float> %0,
    <vscale x 8 x half> %1,
    <vscale x 8 x half> %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwnmacc.nxv16f32.nxv16f16(
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  iXLen,
  iXLen);

define <vscale x 16 x float>  @intrinsic_vfwnmacc_vv_nxv16f32_nxv16f16_nxv16f16(<vscale x 16 x float> %0, <vscale x 16 x half> %1, <vscale x 16 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv16f32_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v16, v20
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwnmacc.nxv16f32.nxv16f16(
    <vscale x 16 x float> %0,
    <vscale x 16 x half> %1,
    <vscale x 16 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwnmacc.mask.nxv16f32.nxv16f16(
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  iXLen, iXLen);

define <vscale x 16 x float>  @intrinsic_vfwnmacc_mask_vv_nxv16f32_nxv16f16_nxv16f16(<vscale x 16 x float> %0, <vscale x 16 x half> %1, <vscale x 16 x half> %2, <vscale x 16 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv16f32_nxv16f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v16, v20, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwnmacc.mask.nxv16f32.nxv16f16(
    <vscale x 16 x float> %0,
    <vscale x 16 x half> %1,
    <vscale x 16 x half> %2,
    <vscale x 16 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwnmacc.nxv1f64.nxv1f32(
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  iXLen,
  iXLen);

define <vscale x 1 x double>  @intrinsic_vfwnmacc_vv_nxv1f64_nxv1f32_nxv1f32(<vscale x 1 x double> %0, <vscale x 1 x float> %1, <vscale x 1 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv1f64_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v9, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwnmacc.nxv1f64.nxv1f32(
    <vscale x 1 x double> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwnmacc.mask.nxv1f64.nxv1f32(
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  iXLen, iXLen);

define <vscale x 1 x double>  @intrinsic_vfwnmacc_mask_vv_nxv1f64_nxv1f32_nxv1f32(<vscale x 1 x double> %0, <vscale x 1 x float> %1, <vscale x 1 x float> %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv1f64_nxv1f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v9, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwnmacc.mask.nxv1f64.nxv1f32(
    <vscale x 1 x double> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x float> %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwnmacc.nxv2f64.nxv2f32(
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  iXLen,
  iXLen);

define <vscale x 2 x double>  @intrinsic_vfwnmacc_vv_nxv2f64_nxv2f32_nxv2f32(<vscale x 2 x double> %0, <vscale x 2 x float> %1, <vscale x 2 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv2f64_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v10, v11
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwnmacc.nxv2f64.nxv2f32(
    <vscale x 2 x double> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwnmacc.mask.nxv2f64.nxv2f32(
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  iXLen, iXLen);

define <vscale x 2 x double>  @intrinsic_vfwnmacc_mask_vv_nxv2f64_nxv2f32_nxv2f32(<vscale x 2 x double> %0, <vscale x 2 x float> %1, <vscale x 2 x float> %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv2f64_nxv2f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v10, v11, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwnmacc.mask.nxv2f64.nxv2f32(
    <vscale x 2 x double> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x float> %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwnmacc.nxv4f64.nxv4f32(
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  iXLen,
  iXLen);

define <vscale x 4 x double>  @intrinsic_vfwnmacc_vv_nxv4f64_nxv4f32_nxv4f32(<vscale x 4 x double> %0, <vscale x 4 x float> %1, <vscale x 4 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv4f64_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v12, v14
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwnmacc.nxv4f64.nxv4f32(
    <vscale x 4 x double> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwnmacc.mask.nxv4f64.nxv4f32(
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  iXLen, iXLen);

define <vscale x 4 x double>  @intrinsic_vfwnmacc_mask_vv_nxv4f64_nxv4f32_nxv4f32(<vscale x 4 x double> %0, <vscale x 4 x float> %1, <vscale x 4 x float> %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv4f64_nxv4f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v12, v14, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwnmacc.mask.nxv4f64.nxv4f32(
    <vscale x 4 x double> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x float> %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwnmacc.nxv8f64.nxv8f32(
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  iXLen,
  iXLen);

define <vscale x 8 x double>  @intrinsic_vfwnmacc_vv_nxv8f64_nxv8f32_nxv8f32(<vscale x 8 x double> %0, <vscale x 8 x float> %1, <vscale x 8 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vv_nxv8f64_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v16, v20
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwnmacc.nxv8f64.nxv8f32(
    <vscale x 8 x double> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwnmacc.mask.nxv8f64.nxv8f32(
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  iXLen, iXLen);

define <vscale x 8 x double>  @intrinsic_vfwnmacc_mask_vv_nxv8f64_nxv8f32_nxv8f32(<vscale x 8 x double> %0, <vscale x 8 x float> %1, <vscale x 8 x float> %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vv_nxv8f64_nxv8f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vv v8, v16, v20, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwnmacc.mask.nxv8f64.nxv8f32(
    <vscale x 8 x double> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x float> %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 8 x double> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwnmacc.nxv1f32.f16(
  <vscale x 1 x float>,
  half,
  <vscale x 1 x half>,
  iXLen,
  iXLen);

define <vscale x 1 x float>  @intrinsic_vfwnmacc_vf_nxv1f32_f16_nxv1f16(<vscale x 1 x float> %0, half %1, <vscale x 1 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv1f32_f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwnmacc.nxv1f32.f16(
    <vscale x 1 x float> %0,
    half %1,
    <vscale x 1 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwnmacc.mask.nxv1f32.f16(
  <vscale x 1 x float>,
  half,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  iXLen, iXLen);

define <vscale x 1 x float> @intrinsic_vfwnmacc_mask_vf_nxv1f32_f16_nxv1f16(<vscale x 1 x float> %0, half %1, <vscale x 1 x half> %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv1f32_f16_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwnmacc.mask.nxv1f32.f16(
    <vscale x 1 x float> %0,
    half %1,
    <vscale x 1 x half> %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwnmacc.nxv2f32.f16(
  <vscale x 2 x float>,
  half,
  <vscale x 2 x half>,
  iXLen,
  iXLen);

define <vscale x 2 x float>  @intrinsic_vfwnmacc_vf_nxv2f32_f16_nxv2f16(<vscale x 2 x float> %0, half %1, <vscale x 2 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv2f32_f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwnmacc.nxv2f32.f16(
    <vscale x 2 x float> %0,
    half %1,
    <vscale x 2 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwnmacc.mask.nxv2f32.f16(
  <vscale x 2 x float>,
  half,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  iXLen, iXLen);

define <vscale x 2 x float> @intrinsic_vfwnmacc_mask_vf_nxv2f32_f16_nxv2f16(<vscale x 2 x float> %0, half %1, <vscale x 2 x half> %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv2f32_f16_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwnmacc.mask.nxv2f32.f16(
    <vscale x 2 x float> %0,
    half %1,
    <vscale x 2 x half> %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwnmacc.nxv4f32.f16(
  <vscale x 4 x float>,
  half,
  <vscale x 4 x half>,
  iXLen,
  iXLen);

define <vscale x 4 x float>  @intrinsic_vfwnmacc_vf_nxv4f32_f16_nxv4f16(<vscale x 4 x float> %0, half %1, <vscale x 4 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv4f32_f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwnmacc.nxv4f32.f16(
    <vscale x 4 x float> %0,
    half %1,
    <vscale x 4 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwnmacc.mask.nxv4f32.f16(
  <vscale x 4 x float>,
  half,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  iXLen, iXLen);

define <vscale x 4 x float> @intrinsic_vfwnmacc_mask_vf_nxv4f32_f16_nxv4f16(<vscale x 4 x float> %0, half %1, <vscale x 4 x half> %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv4f32_f16_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwnmacc.mask.nxv4f32.f16(
    <vscale x 4 x float> %0,
    half %1,
    <vscale x 4 x half> %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwnmacc.nxv8f32.f16(
  <vscale x 8 x float>,
  half,
  <vscale x 8 x half>,
  iXLen,
  iXLen);

define <vscale x 8 x float>  @intrinsic_vfwnmacc_vf_nxv8f32_f16_nxv8f16(<vscale x 8 x float> %0, half %1, <vscale x 8 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv8f32_f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwnmacc.nxv8f32.f16(
    <vscale x 8 x float> %0,
    half %1,
    <vscale x 8 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwnmacc.mask.nxv8f32.f16(
  <vscale x 8 x float>,
  half,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  iXLen, iXLen);

define <vscale x 8 x float> @intrinsic_vfwnmacc_mask_vf_nxv8f32_f16_nxv8f16(<vscale x 8 x float> %0, half %1, <vscale x 8 x half> %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv8f32_f16_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwnmacc.mask.nxv8f32.f16(
    <vscale x 8 x float> %0,
    half %1,
    <vscale x 8 x half> %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwnmacc.nxv16f32.f16(
  <vscale x 16 x float>,
  half,
  <vscale x 16 x half>,
  iXLen,
  iXLen);

define <vscale x 16 x float>  @intrinsic_vfwnmacc_vf_nxv16f32_f16_nxv16f16(<vscale x 16 x float> %0, half %1, <vscale x 16 x half> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv16f32_f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwnmacc.nxv16f32.f16(
    <vscale x 16 x float> %0,
    half %1,
    <vscale x 16 x half> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwnmacc.mask.nxv16f32.f16(
  <vscale x 16 x float>,
  half,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  iXLen, iXLen);

define <vscale x 16 x float> @intrinsic_vfwnmacc_mask_vf_nxv16f32_f16_nxv16f16(<vscale x 16 x float> %0, half %1, <vscale x 16 x half> %2, <vscale x 16 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv16f32_f16_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwnmacc.mask.nxv16f32.f16(
    <vscale x 16 x float> %0,
    half %1,
    <vscale x 16 x half> %2,
    <vscale x 16 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwnmacc.nxv1f64.f32(
  <vscale x 1 x double>,
  float,
  <vscale x 1 x float>,
  iXLen,
  iXLen);

define <vscale x 1 x double>  @intrinsic_vfwnmacc_vf_nxv1f64_f32_nxv1f32(<vscale x 1 x double> %0, float %1, <vscale x 1 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv1f64_f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwnmacc.nxv1f64.f32(
    <vscale x 1 x double> %0,
    float %1,
    <vscale x 1 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwnmacc.mask.nxv1f64.f32(
  <vscale x 1 x double>,
  float,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  iXLen, iXLen);

define <vscale x 1 x double> @intrinsic_vfwnmacc_mask_vf_nxv1f64_f32_nxv1f32(<vscale x 1 x double> %0, float %1, <vscale x 1 x float> %2, <vscale x 1 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv1f64_f32_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwnmacc.mask.nxv1f64.f32(
    <vscale x 1 x double> %0,
    float %1,
    <vscale x 1 x float> %2,
    <vscale x 1 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwnmacc.nxv2f64.f32(
  <vscale x 2 x double>,
  float,
  <vscale x 2 x float>,
  iXLen,
  iXLen);

define <vscale x 2 x double>  @intrinsic_vfwnmacc_vf_nxv2f64_f32_nxv2f32(<vscale x 2 x double> %0, float %1, <vscale x 2 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv2f64_f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwnmacc.nxv2f64.f32(
    <vscale x 2 x double> %0,
    float %1,
    <vscale x 2 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwnmacc.mask.nxv2f64.f32(
  <vscale x 2 x double>,
  float,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  iXLen, iXLen);

define <vscale x 2 x double> @intrinsic_vfwnmacc_mask_vf_nxv2f64_f32_nxv2f32(<vscale x 2 x double> %0, float %1, <vscale x 2 x float> %2, <vscale x 2 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv2f64_f32_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwnmacc.mask.nxv2f64.f32(
    <vscale x 2 x double> %0,
    float %1,
    <vscale x 2 x float> %2,
    <vscale x 2 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwnmacc.nxv4f64.f32(
  <vscale x 4 x double>,
  float,
  <vscale x 4 x float>,
  iXLen,
  iXLen);

define <vscale x 4 x double>  @intrinsic_vfwnmacc_vf_nxv4f64_f32_nxv4f32(<vscale x 4 x double> %0, float %1, <vscale x 4 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv4f64_f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwnmacc.nxv4f64.f32(
    <vscale x 4 x double> %0,
    float %1,
    <vscale x 4 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwnmacc.mask.nxv4f64.f32(
  <vscale x 4 x double>,
  float,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  iXLen, iXLen);

define <vscale x 4 x double> @intrinsic_vfwnmacc_mask_vf_nxv4f64_f32_nxv4f32(<vscale x 4 x double> %0, float %1, <vscale x 4 x float> %2, <vscale x 4 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv4f64_f32_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwnmacc.mask.nxv4f64.f32(
    <vscale x 4 x double> %0,
    float %1,
    <vscale x 4 x float> %2,
    <vscale x 4 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwnmacc.nxv8f64.f32(
  <vscale x 8 x double>,
  float,
  <vscale x 8 x float>,
  iXLen,
  iXLen);

define <vscale x 8 x double>  @intrinsic_vfwnmacc_vf_nxv8f64_f32_nxv8f32(<vscale x 8 x double> %0, float %1, <vscale x 8 x float> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_vf_nxv8f64_f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwnmacc.nxv8f64.f32(
    <vscale x 8 x double> %0,
    float %1,
    <vscale x 8 x float> %2,
    iXLen %3, iXLen 0)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwnmacc.mask.nxv8f64.f32(
  <vscale x 8 x double>,
  float,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  iXLen, iXLen);

define <vscale x 8 x double> @intrinsic_vfwnmacc_mask_vf_nxv8f64_f32_nxv8f32(<vscale x 8 x double> %0, float %1, <vscale x 8 x float> %2, <vscale x 8 x i1> %3, iXLen %4) nounwind {
; CHECK-LABEL: intrinsic_vfwnmacc_mask_vf_nxv8f64_f32_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, tu, mu
; CHECK-NEXT:    vfwnmacc.vf v8, fa0, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwnmacc.mask.nxv8f64.f32(
    <vscale x 8 x double> %0,
    float %1,
    <vscale x 8 x float> %2,
    <vscale x 8 x i1> %3,
    iXLen %4, iXLen 0);

  ret <vscale x 8 x double> %a
}
