; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+v,+zfh \
; RUN:   -verify-machineinstrs -target-abi=ilp32d | FileCheck %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+v,+zfh \
; RUN:   -verify-machineinstrs -target-abi=lp64d | FileCheck %s
declare <vscale x 1 x half> @llvm.riscv.vfcvt.f.x.v.nxv1f16.nxv1i16(
  <vscale x 1 x half>,
  <vscale x 1 x i16>,
  iXLen);

define <vscale x 1 x half> @intrinsic_vfcvt_f.x.v_nxv1f16_nxv1i16(<vscale x 1 x i16> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv1f16_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfcvt.f.x.v.nxv1f16.nxv1i16(
    <vscale x 1 x half> undef,
    <vscale x 1 x i16> %0,
    iXLen %1)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv1f16.nxv1i16(
  <vscale x 1 x half>,
  <vscale x 1 x i16>,
  <vscale x 1 x i1>,
  iXLen,
  iXLen);

define <vscale x 1 x half> @intrinsic_vfcvt_mask_f.x.v_nxv1f16_nxv1i16(<vscale x 1 x half> %0, <vscale x 1 x i16> %1, <vscale x 1 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv1f16_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv1f16.nxv1i16(
    <vscale x 1 x half> %0,
    <vscale x 1 x i16> %1,
    <vscale x 1 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfcvt.f.x.v.nxv2f16.nxv2i16(
  <vscale x 2 x half>,
  <vscale x 2 x i16>,
  iXLen);

define <vscale x 2 x half> @intrinsic_vfcvt_f.x.v_nxv2f16_nxv2i16(<vscale x 2 x i16> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv2f16_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfcvt.f.x.v.nxv2f16.nxv2i16(
    <vscale x 2 x half> undef,
    <vscale x 2 x i16> %0,
    iXLen %1)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv2f16.nxv2i16(
  <vscale x 2 x half>,
  <vscale x 2 x i16>,
  <vscale x 2 x i1>,
  iXLen,
  iXLen);

define <vscale x 2 x half> @intrinsic_vfcvt_mask_f.x.v_nxv2f16_nxv2i16(<vscale x 2 x half> %0, <vscale x 2 x i16> %1, <vscale x 2 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv2f16_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv2f16.nxv2i16(
    <vscale x 2 x half> %0,
    <vscale x 2 x i16> %1,
    <vscale x 2 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfcvt.f.x.v.nxv4f16.nxv4i16(
  <vscale x 4 x half>,
  <vscale x 4 x i16>,
  iXLen);

define <vscale x 4 x half> @intrinsic_vfcvt_f.x.v_nxv4f16_nxv4i16(<vscale x 4 x i16> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv4f16_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfcvt.f.x.v.nxv4f16.nxv4i16(
    <vscale x 4 x half> undef,
    <vscale x 4 x i16> %0,
    iXLen %1)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv4f16.nxv4i16(
  <vscale x 4 x half>,
  <vscale x 4 x i16>,
  <vscale x 4 x i1>,
  iXLen,
  iXLen);

define <vscale x 4 x half> @intrinsic_vfcvt_mask_f.x.v_nxv4f16_nxv4i16(<vscale x 4 x half> %0, <vscale x 4 x i16> %1, <vscale x 4 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv4f16_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv4f16.nxv4i16(
    <vscale x 4 x half> %0,
    <vscale x 4 x i16> %1,
    <vscale x 4 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfcvt.f.x.v.nxv8f16.nxv8i16(
  <vscale x 8 x half>,
  <vscale x 8 x i16>,
  iXLen);

define <vscale x 8 x half> @intrinsic_vfcvt_f.x.v_nxv8f16_nxv8i16(<vscale x 8 x i16> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv8f16_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfcvt.f.x.v.nxv8f16.nxv8i16(
    <vscale x 8 x half> undef,
    <vscale x 8 x i16> %0,
    iXLen %1)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv8f16.nxv8i16(
  <vscale x 8 x half>,
  <vscale x 8 x i16>,
  <vscale x 8 x i1>,
  iXLen,
  iXLen);

define <vscale x 8 x half> @intrinsic_vfcvt_mask_f.x.v_nxv8f16_nxv8i16(<vscale x 8 x half> %0, <vscale x 8 x i16> %1, <vscale x 8 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv8f16_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv8f16.nxv8i16(
    <vscale x 8 x half> %0,
    <vscale x 8 x i16> %1,
    <vscale x 8 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfcvt.f.x.v.nxv16f16.nxv16i16(
  <vscale x 16 x half>,
  <vscale x 16 x i16>,
  iXLen);

define <vscale x 16 x half> @intrinsic_vfcvt_f.x.v_nxv16f16_nxv16i16(<vscale x 16 x i16> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv16f16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfcvt.f.x.v.nxv16f16.nxv16i16(
    <vscale x 16 x half> undef,
    <vscale x 16 x i16> %0,
    iXLen %1)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv16f16.nxv16i16(
  <vscale x 16 x half>,
  <vscale x 16 x i16>,
  <vscale x 16 x i1>,
  iXLen,
  iXLen);

define <vscale x 16 x half> @intrinsic_vfcvt_mask_f.x.v_nxv16f16_nxv16i16(<vscale x 16 x half> %0, <vscale x 16 x i16> %1, <vscale x 16 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv16f16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv16f16.nxv16i16(
    <vscale x 16 x half> %0,
    <vscale x 16 x i16> %1,
    <vscale x 16 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 16 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vfcvt.f.x.v.nxv32f16.nxv32i16(
  <vscale x 32 x half>,
  <vscale x 32 x i16>,
  iXLen);

define <vscale x 32 x half> @intrinsic_vfcvt_f.x.v_nxv32f16_nxv32i16(<vscale x 32 x i16> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv32f16_nxv32i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x half> @llvm.riscv.vfcvt.f.x.v.nxv32f16.nxv32i16(
    <vscale x 32 x half> undef,
    <vscale x 32 x i16> %0,
    iXLen %1)

  ret <vscale x 32 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv32f16.nxv32i16(
  <vscale x 32 x half>,
  <vscale x 32 x i16>,
  <vscale x 32 x i1>,
  iXLen,
  iXLen);

define <vscale x 32 x half> @intrinsic_vfcvt_mask_f.x.v_nxv32f16_nxv32i16(<vscale x 32 x half> %0, <vscale x 32 x i16> %1, <vscale x 32 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv32f16_nxv32i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x half> @llvm.riscv.vfcvt.f.x.v.mask.nxv32f16.nxv32i16(
    <vscale x 32 x half> %0,
    <vscale x 32 x i16> %1,
    <vscale x 32 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 32 x half> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfcvt.f.x.v.nxv1f32.nxv1i32(
  <vscale x 1 x float>,
  <vscale x 1 x i32>,
  iXLen);

define <vscale x 1 x float> @intrinsic_vfcvt_f.x.v_nxv1f32_nxv1i32(<vscale x 1 x i32> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv1f32_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfcvt.f.x.v.nxv1f32.nxv1i32(
    <vscale x 1 x float> undef,
    <vscale x 1 x i32> %0,
    iXLen %1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv1f32.nxv1i32(
  <vscale x 1 x float>,
  <vscale x 1 x i32>,
  <vscale x 1 x i1>,
  iXLen,
  iXLen);

define <vscale x 1 x float> @intrinsic_vfcvt_mask_f.x.v_nxv1f32_nxv1i32(<vscale x 1 x float> %0, <vscale x 1 x i32> %1, <vscale x 1 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv1f32_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv1f32.nxv1i32(
    <vscale x 1 x float> %0,
    <vscale x 1 x i32> %1,
    <vscale x 1 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfcvt.f.x.v.nxv2f32.nxv2i32(
  <vscale x 2 x float>,
  <vscale x 2 x i32>,
  iXLen);

define <vscale x 2 x float> @intrinsic_vfcvt_f.x.v_nxv2f32_nxv2i32(<vscale x 2 x i32> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv2f32_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfcvt.f.x.v.nxv2f32.nxv2i32(
    <vscale x 2 x float> undef,
    <vscale x 2 x i32> %0,
    iXLen %1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv2f32.nxv2i32(
  <vscale x 2 x float>,
  <vscale x 2 x i32>,
  <vscale x 2 x i1>,
  iXLen,
  iXLen);

define <vscale x 2 x float> @intrinsic_vfcvt_mask_f.x.v_nxv2f32_nxv2i32(<vscale x 2 x float> %0, <vscale x 2 x i32> %1, <vscale x 2 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv2f32_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv2f32.nxv2i32(
    <vscale x 2 x float> %0,
    <vscale x 2 x i32> %1,
    <vscale x 2 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfcvt.f.x.v.nxv4f32.nxv4i32(
  <vscale x 4 x float>,
  <vscale x 4 x i32>,
  iXLen);

define <vscale x 4 x float> @intrinsic_vfcvt_f.x.v_nxv4f32_nxv4i32(<vscale x 4 x i32> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv4f32_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfcvt.f.x.v.nxv4f32.nxv4i32(
    <vscale x 4 x float> undef,
    <vscale x 4 x i32> %0,
    iXLen %1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv4f32.nxv4i32(
  <vscale x 4 x float>,
  <vscale x 4 x i32>,
  <vscale x 4 x i1>,
  iXLen,
  iXLen);

define <vscale x 4 x float> @intrinsic_vfcvt_mask_f.x.v_nxv4f32_nxv4i32(<vscale x 4 x float> %0, <vscale x 4 x i32> %1, <vscale x 4 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv4f32_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv4f32.nxv4i32(
    <vscale x 4 x float> %0,
    <vscale x 4 x i32> %1,
    <vscale x 4 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfcvt.f.x.v.nxv8f32.nxv8i32(
  <vscale x 8 x float>,
  <vscale x 8 x i32>,
  iXLen);

define <vscale x 8 x float> @intrinsic_vfcvt_f.x.v_nxv8f32_nxv8i32(<vscale x 8 x i32> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv8f32_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfcvt.f.x.v.nxv8f32.nxv8i32(
    <vscale x 8 x float> undef,
    <vscale x 8 x i32> %0,
    iXLen %1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv8f32.nxv8i32(
  <vscale x 8 x float>,
  <vscale x 8 x i32>,
  <vscale x 8 x i1>,
  iXLen,
  iXLen);

define <vscale x 8 x float> @intrinsic_vfcvt_mask_f.x.v_nxv8f32_nxv8i32(<vscale x 8 x float> %0, <vscale x 8 x i32> %1, <vscale x 8 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv8f32_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv8f32.nxv8i32(
    <vscale x 8 x float> %0,
    <vscale x 8 x i32> %1,
    <vscale x 8 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfcvt.f.x.v.nxv16f32.nxv16i32(
  <vscale x 16 x float>,
  <vscale x 16 x i32>,
  iXLen);

define <vscale x 16 x float> @intrinsic_vfcvt_f.x.v_nxv16f32_nxv16i32(<vscale x 16 x i32> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv16f32_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfcvt.f.x.v.nxv16f32.nxv16i32(
    <vscale x 16 x float> undef,
    <vscale x 16 x i32> %0,
    iXLen %1)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv16f32.nxv16i32(
  <vscale x 16 x float>,
  <vscale x 16 x i32>,
  <vscale x 16 x i1>,
  iXLen,
  iXLen);

define <vscale x 16 x float> @intrinsic_vfcvt_mask_f.x.v_nxv16f32_nxv16i32(<vscale x 16 x float> %0, <vscale x 16 x i32> %1, <vscale x 16 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv16f32_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfcvt.f.x.v.mask.nxv16f32.nxv16i32(
    <vscale x 16 x float> %0,
    <vscale x 16 x i32> %1,
    <vscale x 16 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfcvt.f.x.v.nxv1f64.nxv1i64(
  <vscale x 1 x double>,
  <vscale x 1 x i64>,
  iXLen);

define <vscale x 1 x double> @intrinsic_vfcvt_f.x.v_nxv1f64_nxv1i64(<vscale x 1 x i64> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv1f64_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfcvt.f.x.v.nxv1f64.nxv1i64(
    <vscale x 1 x double> undef,
    <vscale x 1 x i64> %0,
    iXLen %1)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv1f64.nxv1i64(
  <vscale x 1 x double>,
  <vscale x 1 x i64>,
  <vscale x 1 x i1>,
  iXLen,
  iXLen);

define <vscale x 1 x double> @intrinsic_vfcvt_mask_f.x.v_nxv1f64_nxv1i64(<vscale x 1 x double> %0, <vscale x 1 x i64> %1, <vscale x 1 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv1f64_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv1f64.nxv1i64(
    <vscale x 1 x double> %0,
    <vscale x 1 x i64> %1,
    <vscale x 1 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfcvt.f.x.v.nxv2f64.nxv2i64(
  <vscale x 2 x double>,
  <vscale x 2 x i64>,
  iXLen);

define <vscale x 2 x double> @intrinsic_vfcvt_f.x.v_nxv2f64_nxv2i64(<vscale x 2 x i64> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv2f64_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfcvt.f.x.v.nxv2f64.nxv2i64(
    <vscale x 2 x double> undef,
    <vscale x 2 x i64> %0,
    iXLen %1)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv2f64.nxv2i64(
  <vscale x 2 x double>,
  <vscale x 2 x i64>,
  <vscale x 2 x i1>,
  iXLen,
  iXLen);

define <vscale x 2 x double> @intrinsic_vfcvt_mask_f.x.v_nxv2f64_nxv2i64(<vscale x 2 x double> %0, <vscale x 2 x i64> %1, <vscale x 2 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv2f64_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv2f64.nxv2i64(
    <vscale x 2 x double> %0,
    <vscale x 2 x i64> %1,
    <vscale x 2 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfcvt.f.x.v.nxv4f64.nxv4i64(
  <vscale x 4 x double>,
  <vscale x 4 x i64>,
  iXLen);

define <vscale x 4 x double> @intrinsic_vfcvt_f.x.v_nxv4f64_nxv4i64(<vscale x 4 x i64> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv4f64_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfcvt.f.x.v.nxv4f64.nxv4i64(
    <vscale x 4 x double> undef,
    <vscale x 4 x i64> %0,
    iXLen %1)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv4f64.nxv4i64(
  <vscale x 4 x double>,
  <vscale x 4 x i64>,
  <vscale x 4 x i1>,
  iXLen,
  iXLen);

define <vscale x 4 x double> @intrinsic_vfcvt_mask_f.x.v_nxv4f64_nxv4i64(<vscale x 4 x double> %0, <vscale x 4 x i64> %1, <vscale x 4 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv4f64_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv4f64.nxv4i64(
    <vscale x 4 x double> %0,
    <vscale x 4 x i64> %1,
    <vscale x 4 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfcvt.f.x.v.nxv8f64.nxv8i64(
  <vscale x 8 x double>,
  <vscale x 8 x i64>,
  iXLen);

define <vscale x 8 x double> @intrinsic_vfcvt_f.x.v_nxv8f64_nxv8i64(<vscale x 8 x i64> %0, iXLen %1) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_f.x.v_nxv8f64_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfcvt.f.x.v.nxv8f64.nxv8i64(
    <vscale x 8 x double> undef,
    <vscale x 8 x i64> %0,
    iXLen %1)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv8f64.nxv8i64(
  <vscale x 8 x double>,
  <vscale x 8 x i64>,
  <vscale x 8 x i1>,
  iXLen,
  iXLen);

define <vscale x 8 x double> @intrinsic_vfcvt_mask_f.x.v_nxv8f64_nxv8i64(<vscale x 8 x double> %0, <vscale x 8 x i64> %1, <vscale x 8 x i1> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfcvt_mask_f.x.v_nxv8f64_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vfcvt.f.x.v v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfcvt.f.x.v.mask.nxv8f64.nxv8i64(
    <vscale x 8 x double> %0,
    <vscale x 8 x i64> %1,
    <vscale x 8 x i1> %2,
    iXLen %3, iXLen 1)

  ret <vscale x 8 x double> %a
}
