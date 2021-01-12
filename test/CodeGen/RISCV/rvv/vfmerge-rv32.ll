; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+d,+experimental-zfh -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x half> @llvm.riscv.vfmerge.nxv1f16.nxv1f16(
  <vscale x 1 x half>,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x half> @intrinsic_vfmerge_vvm_nxv1f16_nxv1f16_nxv1f16(<vscale x 1 x half> %0, <vscale x 1 x half> %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv1f16_nxv1f16_nxv1f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 1 x half> @llvm.riscv.vfmerge.nxv1f16.nxv1f16(
    <vscale x 1 x half> %0,
    <vscale x 1 x half> %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfmerge.nxv1f16.f16(
  <vscale x 1 x half>,
  half,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x half> @intrinsic_vfmerge_vfm_nxv1f16_nxv1f16_f16(<vscale x 1 x half> %0, half %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv1f16_nxv1f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 1 x half> @llvm.riscv.vfmerge.nxv1f16.f16(
    <vscale x 1 x half> %0,
    half %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfmerge.nxv2f16.nxv2f16(
  <vscale x 2 x half>,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x half> @intrinsic_vfmerge_vvm_nxv2f16_nxv2f16_nxv2f16(<vscale x 2 x half> %0, <vscale x 2 x half> %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv2f16_nxv2f16_nxv2f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 2 x half> @llvm.riscv.vfmerge.nxv2f16.nxv2f16(
    <vscale x 2 x half> %0,
    <vscale x 2 x half> %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfmerge.nxv2f16.f16(
  <vscale x 2 x half>,
  half,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x half> @intrinsic_vfmerge_vfm_nxv2f16_nxv2f16_f16(<vscale x 2 x half> %0, half %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv2f16_nxv2f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 2 x half> @llvm.riscv.vfmerge.nxv2f16.f16(
    <vscale x 2 x half> %0,
    half %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfmerge.nxv4f16.nxv4f16(
  <vscale x 4 x half>,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x half> @intrinsic_vfmerge_vvm_nxv4f16_nxv4f16_nxv4f16(<vscale x 4 x half> %0, <vscale x 4 x half> %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv4f16_nxv4f16_nxv4f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 4 x half> @llvm.riscv.vfmerge.nxv4f16.nxv4f16(
    <vscale x 4 x half> %0,
    <vscale x 4 x half> %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfmerge.nxv4f16.f16(
  <vscale x 4 x half>,
  half,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x half> @intrinsic_vfmerge_vfm_nxv4f16_nxv4f16_f16(<vscale x 4 x half> %0, half %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv4f16_nxv4f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 4 x half> @llvm.riscv.vfmerge.nxv4f16.f16(
    <vscale x 4 x half> %0,
    half %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfmerge.nxv8f16.nxv8f16(
  <vscale x 8 x half>,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x half> @intrinsic_vfmerge_vvm_nxv8f16_nxv8f16_nxv8f16(<vscale x 8 x half> %0, <vscale x 8 x half> %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv8f16_nxv8f16_nxv8f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 8 x half> @llvm.riscv.vfmerge.nxv8f16.nxv8f16(
    <vscale x 8 x half> %0,
    <vscale x 8 x half> %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfmerge.nxv8f16.f16(
  <vscale x 8 x half>,
  half,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x half> @intrinsic_vfmerge_vfm_nxv8f16_nxv8f16_f16(<vscale x 8 x half> %0, half %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv8f16_nxv8f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 8 x half> @llvm.riscv.vfmerge.nxv8f16.f16(
    <vscale x 8 x half> %0,
    half %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfmerge.nxv16f16.nxv16f16(
  <vscale x 16 x half>,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x half> @intrinsic_vfmerge_vvm_nxv16f16_nxv16f16_nxv16f16(<vscale x 16 x half> %0, <vscale x 16 x half> %1, <vscale x 16 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv16f16_nxv16f16_nxv16f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 16 x half> @llvm.riscv.vfmerge.nxv16f16.nxv16f16(
    <vscale x 16 x half> %0,
    <vscale x 16 x half> %1,
    <vscale x 16 x i1> %2,
    i32 %3)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfmerge.nxv16f16.f16(
  <vscale x 16 x half>,
  half,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x half> @intrinsic_vfmerge_vfm_nxv16f16_nxv16f16_f16(<vscale x 16 x half> %0, half %1, <vscale x 16 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv16f16_nxv16f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 16 x half> @llvm.riscv.vfmerge.nxv16f16.f16(
    <vscale x 16 x half> %0,
    half %1,
    <vscale x 16 x i1> %2,
    i32 %3)

  ret <vscale x 16 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vfmerge.nxv32f16.nxv32f16(
  <vscale x 32 x half>,
  <vscale x 32 x half>,
  <vscale x 32 x i1>,
  i32);

define <vscale x 32 x half> @intrinsic_vfmerge_vvm_nxv32f16_nxv32f16_nxv32f16(<vscale x 32 x half> %0, <vscale x 32 x half> %1, <vscale x 32 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv32f16_nxv32f16_nxv32f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m8
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 32 x half> @llvm.riscv.vfmerge.nxv32f16.nxv32f16(
    <vscale x 32 x half> %0,
    <vscale x 32 x half> %1,
    <vscale x 32 x i1> %2,
    i32 %3)

  ret <vscale x 32 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vfmerge.nxv32f16.f16(
  <vscale x 32 x half>,
  half,
  <vscale x 32 x i1>,
  i32);

define <vscale x 32 x half> @intrinsic_vfmerge_vfm_nxv32f16_nxv32f16_f16(<vscale x 32 x half> %0, half %1, <vscale x 32 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv32f16_nxv32f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m8
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 32 x half> @llvm.riscv.vfmerge.nxv32f16.f16(
    <vscale x 32 x half> %0,
    half %1,
    <vscale x 32 x i1> %2,
    i32 %3)

  ret <vscale x 32 x half> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfmerge.nxv1f32.nxv1f32(
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x float> @intrinsic_vfmerge_vvm_nxv1f32_nxv1f32_nxv1f32(<vscale x 1 x float> %0, <vscale x 1 x float> %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv1f32_nxv1f32_nxv1f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 1 x float> @llvm.riscv.vfmerge.nxv1f32.nxv1f32(
    <vscale x 1 x float> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfmerge.nxv1f32.f32(
  <vscale x 1 x float>,
  float,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x float> @intrinsic_vfmerge_vfm_nxv1f32_nxv1f32_f32(<vscale x 1 x float> %0, float %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv1f32_nxv1f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 1 x float> @llvm.riscv.vfmerge.nxv1f32.f32(
    <vscale x 1 x float> %0,
    float %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfmerge.nxv2f32.nxv2f32(
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x float> @intrinsic_vfmerge_vvm_nxv2f32_nxv2f32_nxv2f32(<vscale x 2 x float> %0, <vscale x 2 x float> %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv2f32_nxv2f32_nxv2f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 2 x float> @llvm.riscv.vfmerge.nxv2f32.nxv2f32(
    <vscale x 2 x float> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfmerge.nxv2f32.f32(
  <vscale x 2 x float>,
  float,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x float> @intrinsic_vfmerge_vfm_nxv2f32_nxv2f32_f32(<vscale x 2 x float> %0, float %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv2f32_nxv2f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 2 x float> @llvm.riscv.vfmerge.nxv2f32.f32(
    <vscale x 2 x float> %0,
    float %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfmerge.nxv4f32.nxv4f32(
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x float> @intrinsic_vfmerge_vvm_nxv4f32_nxv4f32_nxv4f32(<vscale x 4 x float> %0, <vscale x 4 x float> %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv4f32_nxv4f32_nxv4f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 4 x float> @llvm.riscv.vfmerge.nxv4f32.nxv4f32(
    <vscale x 4 x float> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfmerge.nxv4f32.f32(
  <vscale x 4 x float>,
  float,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x float> @intrinsic_vfmerge_vfm_nxv4f32_nxv4f32_f32(<vscale x 4 x float> %0, float %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv4f32_nxv4f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 4 x float> @llvm.riscv.vfmerge.nxv4f32.f32(
    <vscale x 4 x float> %0,
    float %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfmerge.nxv8f32.nxv8f32(
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x float> @intrinsic_vfmerge_vvm_nxv8f32_nxv8f32_nxv8f32(<vscale x 8 x float> %0, <vscale x 8 x float> %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv8f32_nxv8f32_nxv8f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 8 x float> @llvm.riscv.vfmerge.nxv8f32.nxv8f32(
    <vscale x 8 x float> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfmerge.nxv8f32.f32(
  <vscale x 8 x float>,
  float,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x float> @intrinsic_vfmerge_vfm_nxv8f32_nxv8f32_f32(<vscale x 8 x float> %0, float %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv8f32_nxv8f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 8 x float> @llvm.riscv.vfmerge.nxv8f32.f32(
    <vscale x 8 x float> %0,
    float %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfmerge.nxv16f32.nxv16f32(
  <vscale x 16 x float>,
  <vscale x 16 x float>,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x float> @intrinsic_vfmerge_vvm_nxv16f32_nxv16f32_nxv16f32(<vscale x 16 x float> %0, <vscale x 16 x float> %1, <vscale x 16 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv16f32_nxv16f32_nxv16f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m8
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 16 x float> @llvm.riscv.vfmerge.nxv16f32.nxv16f32(
    <vscale x 16 x float> %0,
    <vscale x 16 x float> %1,
    <vscale x 16 x i1> %2,
    i32 %3)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfmerge.nxv16f32.f32(
  <vscale x 16 x float>,
  float,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x float> @intrinsic_vfmerge_vfm_nxv16f32_nxv16f32_f32(<vscale x 16 x float> %0, float %1, <vscale x 16 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv16f32_nxv16f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m8
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 16 x float> @llvm.riscv.vfmerge.nxv16f32.f32(
    <vscale x 16 x float> %0,
    float %1,
    <vscale x 16 x i1> %2,
    i32 %3)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfmerge.nxv1f64.nxv1f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x double> @intrinsic_vfmerge_vvm_nxv1f64_nxv1f64_nxv1f64(<vscale x 1 x double> %0, <vscale x 1 x double> %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv1f64_nxv1f64_nxv1f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 1 x double> @llvm.riscv.vfmerge.nxv1f64.nxv1f64(
    <vscale x 1 x double> %0,
    <vscale x 1 x double> %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfmerge.nxv1f64.f64(
  <vscale x 1 x double>,
  double,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x double> @intrinsic_vfmerge_vfm_nxv1f64_nxv1f64_f64(<vscale x 1 x double> %0, double %1, <vscale x 1 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv1f64_nxv1f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 1 x double> @llvm.riscv.vfmerge.nxv1f64.f64(
    <vscale x 1 x double> %0,
    double %1,
    <vscale x 1 x i1> %2,
    i32 %3)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfmerge.nxv2f64.nxv2f64(
  <vscale x 2 x double>,
  <vscale x 2 x double>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x double> @intrinsic_vfmerge_vvm_nxv2f64_nxv2f64_nxv2f64(<vscale x 2 x double> %0, <vscale x 2 x double> %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv2f64_nxv2f64_nxv2f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 2 x double> @llvm.riscv.vfmerge.nxv2f64.nxv2f64(
    <vscale x 2 x double> %0,
    <vscale x 2 x double> %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfmerge.nxv2f64.f64(
  <vscale x 2 x double>,
  double,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x double> @intrinsic_vfmerge_vfm_nxv2f64_nxv2f64_f64(<vscale x 2 x double> %0, double %1, <vscale x 2 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv2f64_nxv2f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 2 x double> @llvm.riscv.vfmerge.nxv2f64.f64(
    <vscale x 2 x double> %0,
    double %1,
    <vscale x 2 x i1> %2,
    i32 %3)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfmerge.nxv4f64.nxv4f64(
  <vscale x 4 x double>,
  <vscale x 4 x double>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x double> @intrinsic_vfmerge_vvm_nxv4f64_nxv4f64_nxv4f64(<vscale x 4 x double> %0, <vscale x 4 x double> %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv4f64_nxv4f64_nxv4f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 4 x double> @llvm.riscv.vfmerge.nxv4f64.nxv4f64(
    <vscale x 4 x double> %0,
    <vscale x 4 x double> %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfmerge.nxv4f64.f64(
  <vscale x 4 x double>,
  double,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x double> @intrinsic_vfmerge_vfm_nxv4f64_nxv4f64_f64(<vscale x 4 x double> %0, double %1, <vscale x 4 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv4f64_nxv4f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 4 x double> @llvm.riscv.vfmerge.nxv4f64.f64(
    <vscale x 4 x double> %0,
    double %1,
    <vscale x 4 x i1> %2,
    i32 %3)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfmerge.nxv8f64.nxv8f64(
  <vscale x 8 x double>,
  <vscale x 8 x double>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x double> @intrinsic_vfmerge_vvm_nxv8f64_nxv8f64_nxv8f64(<vscale x 8 x double> %0, <vscale x 8 x double> %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vvm_nxv8f64_nxv8f64_nxv8f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m8
; CHECK:       vmerge.vvm {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0
  %a = call <vscale x 8 x double> @llvm.riscv.vfmerge.nxv8f64.nxv8f64(
    <vscale x 8 x double> %0,
    <vscale x 8 x double> %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfmerge.nxv8f64.f64(
  <vscale x 8 x double>,
  double,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x double> @intrinsic_vfmerge_vfm_nxv8f64_nxv8f64_f64(<vscale x 8 x double> %0, double %1, <vscale x 8 x i1> %2, i32 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vfm_nxv8f64_nxv8f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m8
; CHECK:       vfmerge.vfm {{v[0-9]+}}, {{v[0-9]+}}, {{ft[0-9]+}}, v0
  %a = call <vscale x 8 x double> @llvm.riscv.vfmerge.nxv8f64.f64(
    <vscale x 8 x double> %0,
    double %1,
    <vscale x 8 x i1> %2,
    i32 %3)

  ret <vscale x 8 x double> %a
}

define <vscale x 1 x half> @intrinsic_vfmerge_vzm_nxv1f16_nxv1f16_f16(<vscale x 1 x half> %0, <vscale x 1 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv1f16_nxv1f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 1 x half> @llvm.riscv.vfmerge.nxv1f16.f16(
    <vscale x 1 x half> %0,
    half zeroinitializer,
    <vscale x 1 x i1> %1,
    i32 %2)

  ret <vscale x 1 x half> %a
}

define <vscale x 2 x half> @intrinsic_vfmerge_vzm_nxv2f16_nxv2f16_f16(<vscale x 2 x half> %0, <vscale x 2 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv2f16_nxv2f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 2 x half> @llvm.riscv.vfmerge.nxv2f16.f16(
    <vscale x 2 x half> %0,
    half zeroinitializer,
    <vscale x 2 x i1> %1,
    i32 %2)

  ret <vscale x 2 x half> %a
}

define <vscale x 4 x half> @intrinsic_vfmerge_vzm_nxv4f16_nxv4f16_f16(<vscale x 4 x half> %0, <vscale x 4 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv4f16_nxv4f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 4 x half> @llvm.riscv.vfmerge.nxv4f16.f16(
    <vscale x 4 x half> %0,
    half zeroinitializer,
    <vscale x 4 x i1> %1,
    i32 %2)

  ret <vscale x 4 x half> %a
}

define <vscale x 8 x half> @intrinsic_vfmerge_vzm_nxv8f16_nxv8f16_f16(<vscale x 8 x half> %0, <vscale x 8 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv8f16_nxv8f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 8 x half> @llvm.riscv.vfmerge.nxv8f16.f16(
    <vscale x 8 x half> %0,
    half zeroinitializer,
    <vscale x 8 x i1> %1,
    i32 %2)

  ret <vscale x 8 x half> %a
}

define <vscale x 16 x half> @intrinsic_vfmerge_vzm_nxv16f16_nxv16f16_f16(<vscale x 16 x half> %0, <vscale x 16 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv16f16_nxv16f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 16 x half> @llvm.riscv.vfmerge.nxv16f16.f16(
    <vscale x 16 x half> %0,
    half zeroinitializer,
    <vscale x 16 x i1> %1,
    i32 %2)

  ret <vscale x 16 x half> %a
}

define <vscale x 32 x half> @intrinsic_vfmerge_vzm_nxv32f16_nxv32f16_f16(<vscale x 32 x half> %0, <vscale x 32 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv32f16_nxv32f16_f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m8,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 32 x half> @llvm.riscv.vfmerge.nxv32f16.f16(
    <vscale x 32 x half> %0,
    half zeroinitializer,
    <vscale x 32 x i1> %1,
    i32 %2)

  ret <vscale x 32 x half> %a
}

define <vscale x 1 x float> @intrinsic_vfmerge_vzm_nxv1f32_nxv1f32_f32(<vscale x 1 x float> %0, <vscale x 1 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv1f32_nxv1f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 1 x float> @llvm.riscv.vfmerge.nxv1f32.f32(
    <vscale x 1 x float> %0,
    float zeroinitializer,
    <vscale x 1 x i1> %1,
    i32 %2)

  ret <vscale x 1 x float> %a
}

define <vscale x 2 x float> @intrinsic_vfmerge_vzm_nxv2f32_nxv2f32_f32(<vscale x 2 x float> %0, <vscale x 2 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv2f32_nxv2f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 2 x float> @llvm.riscv.vfmerge.nxv2f32.f32(
    <vscale x 2 x float> %0,
    float zeroinitializer,
    <vscale x 2 x i1> %1,
    i32 %2)

  ret <vscale x 2 x float> %a
}

define <vscale x 4 x float> @intrinsic_vfmerge_vzm_nxv4f32_nxv4f32_f32(<vscale x 4 x float> %0, <vscale x 4 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv4f32_nxv4f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 4 x float> @llvm.riscv.vfmerge.nxv4f32.f32(
    <vscale x 4 x float> %0,
    float zeroinitializer,
    <vscale x 4 x i1> %1,
    i32 %2)

  ret <vscale x 4 x float> %a
}

define <vscale x 8 x float> @intrinsic_vfmerge_vzm_nxv8f32_nxv8f32_f32(<vscale x 8 x float> %0, <vscale x 8 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv8f32_nxv8f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 8 x float> @llvm.riscv.vfmerge.nxv8f32.f32(
    <vscale x 8 x float> %0,
    float zeroinitializer,
    <vscale x 8 x i1> %1,
    i32 %2)

  ret <vscale x 8 x float> %a
}

define <vscale x 16 x float> @intrinsic_vfmerge_vzm_nxv16f32_nxv16f32_f32(<vscale x 16 x float> %0, <vscale x 16 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv16f32_nxv16f32_f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m8,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 16 x float> @llvm.riscv.vfmerge.nxv16f32.f32(
    <vscale x 16 x float> %0,
    float zeroinitializer,
    <vscale x 16 x i1> %1,
    i32 %2)

  ret <vscale x 16 x float> %a
}

define <vscale x 1 x double> @intrinsic_vfmerge_vzm_nxv1f64_nxv1f64_f64(<vscale x 1 x double> %0, <vscale x 1 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv1f64_nxv1f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 1 x double> @llvm.riscv.vfmerge.nxv1f64.f64(
    <vscale x 1 x double> %0,
    double zeroinitializer,
    <vscale x 1 x i1> %1,
    i32 %2)

  ret <vscale x 1 x double> %a
}

define <vscale x 2 x double> @intrinsic_vfmerge_vzm_nxv2f64_nxv2f64_f64(<vscale x 2 x double> %0, <vscale x 2 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv2f64_nxv2f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 2 x double> @llvm.riscv.vfmerge.nxv2f64.f64(
    <vscale x 2 x double> %0,
    double zeroinitializer,
    <vscale x 2 x i1> %1,
    i32 %2)

  ret <vscale x 2 x double> %a
}

define <vscale x 4 x double> @intrinsic_vfmerge_vzm_nxv4f64_nxv4f64_f64(<vscale x 4 x double> %0, <vscale x 4 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv4f64_nxv4f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 4 x double> @llvm.riscv.vfmerge.nxv4f64.f64(
    <vscale x 4 x double> %0,
    double zeroinitializer,
    <vscale x 4 x i1> %1,
    i32 %2)

  ret <vscale x 4 x double> %a
}

define <vscale x 8 x double> @intrinsic_vfmerge_vzm_nxv8f64_nxv8f64_f64(<vscale x 8 x double> %0, <vscale x 8 x i1> %1, i32 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfmerge_vzm_nxv8f64_nxv8f64_f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m8,ta,mu
; CHECK:       vmerge.vim {{v[0-9]+}}, {{v[0-9]+}}, 0, v0
  %a = call <vscale x 8 x double> @llvm.riscv.vfmerge.nxv8f64.f64(
    <vscale x 8 x double> %0,
    double zeroinitializer,
    <vscale x 8 x i1> %1,
    i32 %2)

  ret <vscale x 8 x double> %a
}
