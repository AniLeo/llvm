; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -verify-machineinstrs \
; RUN:   < %s | FileCheck %s
declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i8.nxv1i8(
  <vscale x 1 x i8>,
  <vscale x 1 x i8>,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vv_nxv1i1_nxv1i8_nxv1i8(<vscale x 1 x i8> %0, <vscale x 1 x i8> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv1i1_nxv1i8_nxv1i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i8.nxv1i8(
    <vscale x 1 x i8> %0,
    <vscale x 1 x i8> %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i8.nxv2i8(
  <vscale x 2 x i8>,
  <vscale x 2 x i8>,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vv_nxv2i1_nxv2i8_nxv2i8(<vscale x 2 x i8> %0, <vscale x 2 x i8> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv2i1_nxv2i8_nxv2i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i8.nxv2i8(
    <vscale x 2 x i8> %0,
    <vscale x 2 x i8> %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i8.nxv4i8(
  <vscale x 4 x i8>,
  <vscale x 4 x i8>,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vv_nxv4i1_nxv4i8_nxv4i8(<vscale x 4 x i8> %0, <vscale x 4 x i8> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv4i1_nxv4i8_nxv4i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i8.nxv4i8(
    <vscale x 4 x i8> %0,
    <vscale x 4 x i8> %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i8.nxv8i8(
  <vscale x 8 x i8>,
  <vscale x 8 x i8>,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vv_nxv8i1_nxv8i8_nxv8i8(<vscale x 8 x i8> %0, <vscale x 8 x i8> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv8i1_nxv8i8_nxv8i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i8.nxv8i8(
    <vscale x 8 x i8> %0,
    <vscale x 8 x i8> %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i8.nxv16i8(
  <vscale x 16 x i8>,
  <vscale x 16 x i8>,
  i32);

define <vscale x 16 x i1> @intrinsic_vmsbc_vv_nxv16i1_nxv16i8_nxv16i8(<vscale x 16 x i8> %0, <vscale x 16 x i8> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv16i1_nxv16i8_nxv16i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e8, m2, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i8.nxv16i8(
    <vscale x 16 x i8> %0,
    <vscale x 16 x i8> %1,
    i32 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i8.nxv32i8(
  <vscale x 32 x i8>,
  <vscale x 32 x i8>,
  i32);

define <vscale x 32 x i1> @intrinsic_vmsbc_vv_nxv32i1_nxv32i8_nxv32i8(<vscale x 32 x i8> %0, <vscale x 32 x i8> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv32i1_nxv32i8_nxv32i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e8, m4, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i8.nxv32i8(
    <vscale x 32 x i8> %0,
    <vscale x 32 x i8> %1,
    i32 %2)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 64 x i1> @llvm.riscv.vmsbc.nxv64i8.nxv64i8(
  <vscale x 64 x i8>,
  <vscale x 64 x i8>,
  i32);

define <vscale x 64 x i1> @intrinsic_vmsbc_vv_nxv64i1_nxv64i8_nxv64i8(<vscale x 64 x i8> %0, <vscale x 64 x i8> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv64i1_nxv64i8_nxv64i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e8, m8, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 64 x i1> @llvm.riscv.vmsbc.nxv64i8.nxv64i8(
    <vscale x 64 x i8> %0,
    <vscale x 64 x i8> %1,
    i32 %2)

  ret <vscale x 64 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i16.nxv1i16(
  <vscale x 1 x i16>,
  <vscale x 1 x i16>,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vv_nxv1i1_nxv1i16_nxv1i16(<vscale x 1 x i16> %0, <vscale x 1 x i16> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv1i1_nxv1i16_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i16.nxv1i16(
    <vscale x 1 x i16> %0,
    <vscale x 1 x i16> %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i16.nxv2i16(
  <vscale x 2 x i16>,
  <vscale x 2 x i16>,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vv_nxv2i1_nxv2i16_nxv2i16(<vscale x 2 x i16> %0, <vscale x 2 x i16> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv2i1_nxv2i16_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i16.nxv2i16(
    <vscale x 2 x i16> %0,
    <vscale x 2 x i16> %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i16.nxv4i16(
  <vscale x 4 x i16>,
  <vscale x 4 x i16>,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vv_nxv4i1_nxv4i16_nxv4i16(<vscale x 4 x i16> %0, <vscale x 4 x i16> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv4i1_nxv4i16_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i16.nxv4i16(
    <vscale x 4 x i16> %0,
    <vscale x 4 x i16> %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i16.nxv8i16(
  <vscale x 8 x i16>,
  <vscale x 8 x i16>,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vv_nxv8i1_nxv8i16_nxv8i16(<vscale x 8 x i16> %0, <vscale x 8 x i16> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv8i1_nxv8i16_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i16.nxv8i16(
    <vscale x 8 x i16> %0,
    <vscale x 8 x i16> %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i16.nxv16i16(
  <vscale x 16 x i16>,
  <vscale x 16 x i16>,
  i32);

define <vscale x 16 x i1> @intrinsic_vmsbc_vv_nxv16i1_nxv16i16_nxv16i16(<vscale x 16 x i16> %0, <vscale x 16 x i16> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv16i1_nxv16i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i16.nxv16i16(
    <vscale x 16 x i16> %0,
    <vscale x 16 x i16> %1,
    i32 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i16.nxv32i16(
  <vscale x 32 x i16>,
  <vscale x 32 x i16>,
  i32);

define <vscale x 32 x i1> @intrinsic_vmsbc_vv_nxv32i1_nxv32i16_nxv32i16(<vscale x 32 x i16> %0, <vscale x 32 x i16> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv32i1_nxv32i16_nxv32i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m8, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i16.nxv32i16(
    <vscale x 32 x i16> %0,
    <vscale x 32 x i16> %1,
    i32 %2)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i32.nxv1i32(
  <vscale x 1 x i32>,
  <vscale x 1 x i32>,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vv_nxv1i1_nxv1i32_nxv1i32(<vscale x 1 x i32> %0, <vscale x 1 x i32> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv1i1_nxv1i32_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i32.nxv1i32(
    <vscale x 1 x i32> %0,
    <vscale x 1 x i32> %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i32.nxv2i32(
  <vscale x 2 x i32>,
  <vscale x 2 x i32>,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vv_nxv2i1_nxv2i32_nxv2i32(<vscale x 2 x i32> %0, <vscale x 2 x i32> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv2i1_nxv2i32_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i32.nxv2i32(
    <vscale x 2 x i32> %0,
    <vscale x 2 x i32> %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i32.nxv4i32(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vv_nxv4i1_nxv4i32_nxv4i32(<vscale x 4 x i32> %0, <vscale x 4 x i32> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv4i1_nxv4i32_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i32.nxv4i32(
    <vscale x 4 x i32> %0,
    <vscale x 4 x i32> %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i32.nxv8i32(
  <vscale x 8 x i32>,
  <vscale x 8 x i32>,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vv_nxv8i1_nxv8i32_nxv8i32(<vscale x 8 x i32> %0, <vscale x 8 x i32> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv8i1_nxv8i32_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i32.nxv8i32(
    <vscale x 8 x i32> %0,
    <vscale x 8 x i32> %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i32.nxv16i32(
  <vscale x 16 x i32>,
  <vscale x 16 x i32>,
  i32);

define <vscale x 16 x i1> @intrinsic_vmsbc_vv_nxv16i1_nxv16i32_nxv16i32(<vscale x 16 x i32> %0, <vscale x 16 x i32> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv16i1_nxv16i32_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, m8, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i32.nxv16i32(
    <vscale x 16 x i32> %0,
    <vscale x 16 x i32> %1,
    i32 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i64.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vv_nxv1i1_nxv1i64_nxv1i64(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv1i1_nxv1i64_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i64.nxv1i64(
    <vscale x 1 x i64> %0,
    <vscale x 1 x i64> %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i64.nxv2i64(
  <vscale x 2 x i64>,
  <vscale x 2 x i64>,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vv_nxv2i1_nxv2i64_nxv2i64(<vscale x 2 x i64> %0, <vscale x 2 x i64> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv2i1_nxv2i64_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i64.nxv2i64(
    <vscale x 2 x i64> %0,
    <vscale x 2 x i64> %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i64.nxv4i64(
  <vscale x 4 x i64>,
  <vscale x 4 x i64>,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vv_nxv4i1_nxv4i64_nxv4i64(<vscale x 4 x i64> %0, <vscale x 4 x i64> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv4i1_nxv4i64_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v12
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i64.nxv4i64(
    <vscale x 4 x i64> %0,
    <vscale x 4 x i64> %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i64.nxv8i64(
  <vscale x 8 x i64>,
  <vscale x 8 x i64>,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vv_nxv8i1_nxv8i64_nxv8i64(<vscale x 8 x i64> %0, <vscale x 8 x i64> %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vv_nxv8i1_nxv8i64_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vmsbc.vv v0, v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i64.nxv8i64(
    <vscale x 8 x i64> %0,
    <vscale x 8 x i64> %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i8.i8(
  <vscale x 1 x i8>,
  i8,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vx_nxv1i1_nxv1i8_i8(<vscale x 1 x i8> %0, i8 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv1i1_nxv1i8_i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i8.i8(
    <vscale x 1 x i8> %0,
    i8 %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i8.i8(
  <vscale x 2 x i8>,
  i8,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vx_nxv2i1_nxv2i8_i8(<vscale x 2 x i8> %0, i8 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv2i1_nxv2i8_i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e8, mf4, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i8.i8(
    <vscale x 2 x i8> %0,
    i8 %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i8.i8(
  <vscale x 4 x i8>,
  i8,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vx_nxv4i1_nxv4i8_i8(<vscale x 4 x i8> %0, i8 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv4i1_nxv4i8_i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e8, mf2, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i8.i8(
    <vscale x 4 x i8> %0,
    i8 %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i8.i8(
  <vscale x 8 x i8>,
  i8,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vx_nxv8i1_nxv8i8_i8(<vscale x 8 x i8> %0, i8 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv8i1_nxv8i8_i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e8, m1, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i8.i8(
    <vscale x 8 x i8> %0,
    i8 %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i8.i8(
  <vscale x 16 x i8>,
  i8,
  i32);

define <vscale x 16 x i1> @intrinsic_vmsbc_vx_nxv16i1_nxv16i8_i8(<vscale x 16 x i8> %0, i8 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv16i1_nxv16i8_i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i8.i8(
    <vscale x 16 x i8> %0,
    i8 %1,
    i32 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i8.i8(
  <vscale x 32 x i8>,
  i8,
  i32);

define <vscale x 32 x i1> @intrinsic_vmsbc_vx_nxv32i1_nxv32i8_i8(<vscale x 32 x i8> %0, i8 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv32i1_nxv32i8_i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e8, m4, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i8.i8(
    <vscale x 32 x i8> %0,
    i8 %1,
    i32 %2)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 64 x i1> @llvm.riscv.vmsbc.nxv64i8.i8(
  <vscale x 64 x i8>,
  i8,
  i32);

define <vscale x 64 x i1> @intrinsic_vmsbc_vx_nxv64i1_nxv64i8_i8(<vscale x 64 x i8> %0, i8 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv64i1_nxv64i8_i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e8, m8, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 64 x i1> @llvm.riscv.vmsbc.nxv64i8.i8(
    <vscale x 64 x i8> %0,
    i8 %1,
    i32 %2)

  ret <vscale x 64 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i16.i16(
  <vscale x 1 x i16>,
  i16,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vx_nxv1i1_nxv1i16_i16(<vscale x 1 x i16> %0, i16 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv1i1_nxv1i16_i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, mf4, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i16.i16(
    <vscale x 1 x i16> %0,
    i16 %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i16.i16(
  <vscale x 2 x i16>,
  i16,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vx_nxv2i1_nxv2i16_i16(<vscale x 2 x i16> %0, i16 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv2i1_nxv2i16_i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, mf2, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i16.i16(
    <vscale x 2 x i16> %0,
    i16 %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i16.i16(
  <vscale x 4 x i16>,
  i16,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vx_nxv4i1_nxv4i16_i16(<vscale x 4 x i16> %0, i16 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv4i1_nxv4i16_i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i16.i16(
    <vscale x 4 x i16> %0,
    i16 %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i16.i16(
  <vscale x 8 x i16>,
  i16,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vx_nxv8i1_nxv8i16_i16(<vscale x 8 x i16> %0, i16 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv8i1_nxv8i16_i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, m2, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i16.i16(
    <vscale x 8 x i16> %0,
    i16 %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i16.i16(
  <vscale x 16 x i16>,
  i16,
  i32);

define <vscale x 16 x i1> @intrinsic_vmsbc_vx_nxv16i1_nxv16i16_i16(<vscale x 16 x i16> %0, i16 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv16i1_nxv16i16_i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i16.i16(
    <vscale x 16 x i16> %0,
    i16 %1,
    i32 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i16.i16(
  <vscale x 32 x i16>,
  i16,
  i32);

define <vscale x 32 x i1> @intrinsic_vmsbc_vx_nxv32i1_nxv32i16_i16(<vscale x 32 x i16> %0, i16 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv32i1_nxv32i16_i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, m8, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x i1> @llvm.riscv.vmsbc.nxv32i16.i16(
    <vscale x 32 x i16> %0,
    i16 %1,
    i32 %2)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i32.i32(
  <vscale x 1 x i32>,
  i32,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vx_nxv1i1_nxv1i32_i32(<vscale x 1 x i32> %0, i32 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv1i1_nxv1i32_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e32, mf2, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i32.i32(
    <vscale x 1 x i32> %0,
    i32 %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i32.i32(
  <vscale x 2 x i32>,
  i32,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vx_nxv2i1_nxv2i32_i32(<vscale x 2 x i32> %0, i32 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv2i1_nxv2i32_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i32.i32(
    <vscale x 2 x i32> %0,
    i32 %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i32.i32(
  <vscale x 4 x i32>,
  i32,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vx_nxv4i1_nxv4i32_i32(<vscale x 4 x i32> %0, i32 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv4i1_nxv4i32_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i32.i32(
    <vscale x 4 x i32> %0,
    i32 %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i32.i32(
  <vscale x 8 x i32>,
  i32,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vx_nxv8i1_nxv8i32_i32(<vscale x 8 x i32> %0, i32 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv8i1_nxv8i32_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e32, m4, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i32.i32(
    <vscale x 8 x i32> %0,
    i32 %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i32.i32(
  <vscale x 16 x i32>,
  i32,
  i32);

define <vscale x 16 x i1> @intrinsic_vmsbc_vx_nxv16i1_nxv16i32_i32(<vscale x 16 x i32> %0, i32 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv16i1_nxv16i32_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e32, m8, ta, mu
; CHECK-NEXT:    vmsbc.vx v0, v8, a0
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i1> @llvm.riscv.vmsbc.nxv16i32.i32(
    <vscale x 16 x i32> %0,
    i32 %1,
    i32 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i64.i64(
  <vscale x 1 x i64>,
  i64,
  i32);

define <vscale x 1 x i1> @intrinsic_vmsbc_vx_nxv1i1_nxv1i64_i64(<vscale x 1 x i64> %0, i64 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv1i1_nxv1i64_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    sw a1, 12(sp)
; CHECK-NEXT:    sw a0, 8(sp)
; CHECK-NEXT:    addi a0, sp, 8
; CHECK-NEXT:    vsetvli zero, a2, e64, m1, ta, mu
; CHECK-NEXT:    vlse64.v v9, (a0), zero
; CHECK-NEXT:    vmsbc.vv v0, v8, v9
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i1> @llvm.riscv.vmsbc.nxv1i64.i64(
    <vscale x 1 x i64> %0,
    i64 %1,
    i32 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i64.i64(
  <vscale x 2 x i64>,
  i64,
  i32);

define <vscale x 2 x i1> @intrinsic_vmsbc_vx_nxv2i1_nxv2i64_i64(<vscale x 2 x i64> %0, i64 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv2i1_nxv2i64_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    sw a1, 12(sp)
; CHECK-NEXT:    sw a0, 8(sp)
; CHECK-NEXT:    addi a0, sp, 8
; CHECK-NEXT:    vsetvli zero, a2, e64, m2, ta, mu
; CHECK-NEXT:    vlse64.v v10, (a0), zero
; CHECK-NEXT:    vmsbc.vv v0, v8, v10
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i1> @llvm.riscv.vmsbc.nxv2i64.i64(
    <vscale x 2 x i64> %0,
    i64 %1,
    i32 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i64.i64(
  <vscale x 4 x i64>,
  i64,
  i32);

define <vscale x 4 x i1> @intrinsic_vmsbc_vx_nxv4i1_nxv4i64_i64(<vscale x 4 x i64> %0, i64 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv4i1_nxv4i64_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    sw a1, 12(sp)
; CHECK-NEXT:    sw a0, 8(sp)
; CHECK-NEXT:    addi a0, sp, 8
; CHECK-NEXT:    vsetvli zero, a2, e64, m4, ta, mu
; CHECK-NEXT:    vlse64.v v12, (a0), zero
; CHECK-NEXT:    vmsbc.vv v0, v8, v12
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i1> @llvm.riscv.vmsbc.nxv4i64.i64(
    <vscale x 4 x i64> %0,
    i64 %1,
    i32 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i64.i64(
  <vscale x 8 x i64>,
  i64,
  i32);

define <vscale x 8 x i1> @intrinsic_vmsbc_vx_nxv8i1_nxv8i64_i64(<vscale x 8 x i64> %0, i64 %1, i32 %2) nounwind {
; CHECK-LABEL: intrinsic_vmsbc_vx_nxv8i1_nxv8i64_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    sw a1, 12(sp)
; CHECK-NEXT:    sw a0, 8(sp)
; CHECK-NEXT:    addi a0, sp, 8
; CHECK-NEXT:    vsetvli zero, a2, e64, m8, ta, mu
; CHECK-NEXT:    vlse64.v v16, (a0), zero
; CHECK-NEXT:    vmsbc.vv v0, v8, v16
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i1> @llvm.riscv.vmsbc.nxv8i64.i64(
    <vscale x 8 x i64> %0,
    i64 %1,
    i32 %2)

  ret <vscale x 8 x i1> %a
}
