; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s -mtriple=powerpc64-unknown-linux -mcpu=pwr8 | FileCheck %s
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr9 | FileCheck %s
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr8 -mattr=-vsx | FileCheck %s -check-prefix=NOVSX

declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fadd.f64(double, double, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double>, <2 x double>, metadata, metadata)

declare float @llvm.experimental.constrained.fsub.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fsub.f64(double, double, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fsub.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fsub.v2f64(<2 x double>, <2 x double>, metadata, metadata)

declare float @llvm.experimental.constrained.fmul.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fmul.f64(double, double, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fmul.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double>, <2 x double>, metadata, metadata)

declare float @llvm.experimental.constrained.fdiv.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fdiv.f64(double, double, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fdiv.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fdiv.v2f64(<2 x double>, <2 x double>, metadata, metadata)

declare float @llvm.experimental.constrained.fma.f32(float, float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fma.f64(double, double, double, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fma.v4f32(<4 x float>, <4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fma.v2f64(<2 x double>, <2 x double>, <2 x double>, metadata, metadata)

declare float @llvm.experimental.constrained.sqrt.f32(float, metadata, metadata)
declare double @llvm.experimental.constrained.sqrt.f64(double, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.sqrt.v4f32(<4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.sqrt.v2f64(<2 x double>, metadata, metadata)

define float @fadd_f32(float %f1, float %f2) {
; CHECK-LABEL: fadd_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsaddsp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fadd_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fadds f1, f1, f2
; NOVSX-NEXT:    blr
  %res = call float @llvm.experimental.constrained.fadd.f32(
                        float %f1, float %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret float %res
}

define double @fadd_f64(double %f1, double %f2) {
; CHECK-LABEL: fadd_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsadddp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fadd_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fadd f1, f1, f2
; NOVSX-NEXT:    blr
  %res = call double @llvm.experimental.constrained.fadd.f64(
                        double %f1, double %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %res
}

define <4 x float> @fadd_v4f32(<4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvaddsp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fadd_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    addi r4, r1, -48
; NOVSX-NEXT:    stvx v3, 0, r3
; NOVSX-NEXT:    stvx v2, 0, r4
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -20(r1)
; NOVSX-NEXT:    lfs f1, -36(r1)
; NOVSX-NEXT:    fadds f0, f1, f0
; NOVSX-NEXT:    lfs f1, -40(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -24(r1)
; NOVSX-NEXT:    fadds f0, f1, f0
; NOVSX-NEXT:    lfs f1, -44(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -28(r1)
; NOVSX-NEXT:    fadds f0, f1, f0
; NOVSX-NEXT:    lfs f1, -48(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -32(r1)
; NOVSX-NEXT:    fadds f0, f1, f0
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    blr
  %res = call <4 x float> @llvm.experimental.constrained.fadd.v4f32(
                        <4 x float> %vf1, <4 x float> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <4 x float> %res
}

define <2 x double> @fadd_v2f64(<2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fadd_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvadddp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fadd_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fadd f2, f2, f4
; NOVSX-NEXT:    fadd f1, f1, f3
; NOVSX-NEXT:    blr
  %res = call <2 x double> @llvm.experimental.constrained.fadd.v2f64(
                        <2 x double> %vf1, <2 x double> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <2 x double> %res
}

define float @fsub_f32(float %f1, float %f2) {
; CHECK-LABEL: fsub_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xssubsp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsub_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fsubs f1, f1, f2
; NOVSX-NEXT:    blr

  %res = call float @llvm.experimental.constrained.fsub.f32(
                        float %f1, float %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret float %res;
}

define double @fsub_f64(double %f1, double %f2) {
; CHECK-LABEL: fsub_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xssubdp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsub_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fsub f1, f1, f2
; NOVSX-NEXT:    blr

  %res = call double @llvm.experimental.constrained.fsub.f64(
                        double %f1, double %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %res;
}

define <4 x float> @fsub_v4f32(<4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fsub_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvsubsp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsub_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    addi r4, r1, -48
; NOVSX-NEXT:    stvx v3, 0, r3
; NOVSX-NEXT:    stvx v2, 0, r4
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -20(r1)
; NOVSX-NEXT:    lfs f1, -36(r1)
; NOVSX-NEXT:    fsubs f0, f1, f0
; NOVSX-NEXT:    lfs f1, -40(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -24(r1)
; NOVSX-NEXT:    fsubs f0, f1, f0
; NOVSX-NEXT:    lfs f1, -44(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -28(r1)
; NOVSX-NEXT:    fsubs f0, f1, f0
; NOVSX-NEXT:    lfs f1, -48(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -32(r1)
; NOVSX-NEXT:    fsubs f0, f1, f0
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    blr
  %res = call <4 x float> @llvm.experimental.constrained.fsub.v4f32(
                        <4 x float> %vf1, <4 x float> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <4 x float> %res;
}

define <2 x double> @fsub_v2f64(<2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fsub_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvsubdp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsub_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fsub f2, f2, f4
; NOVSX-NEXT:    fsub f1, f1, f3
; NOVSX-NEXT:    blr
  %res = call <2 x double> @llvm.experimental.constrained.fsub.v2f64(
                        <2 x double> %vf1, <2 x double> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <2 x double> %res;
}

define float @fmul_f32(float %f1, float %f2) {
; CHECK-LABEL: fmul_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmulsp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmul_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmuls f1, f1, f2
; NOVSX-NEXT:    blr

  %res = call float @llvm.experimental.constrained.fmul.f32(
                        float %f1, float %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret float %res;
}

define double @fmul_f64(double %f1, double %f2) {
; CHECK-LABEL: fmul_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmuldp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmul_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmul f1, f1, f2
; NOVSX-NEXT:    blr

  %res = call double @llvm.experimental.constrained.fmul.f64(
                        double %f1, double %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %res;
}

define <4 x float> @fmul_v4f32(<4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fmul_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmulsp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmul_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    addi r4, r1, -48
; NOVSX-NEXT:    stvx v3, 0, r3
; NOVSX-NEXT:    stvx v2, 0, r4
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -20(r1)
; NOVSX-NEXT:    lfs f1, -36(r1)
; NOVSX-NEXT:    fmuls f0, f1, f0
; NOVSX-NEXT:    lfs f1, -40(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -24(r1)
; NOVSX-NEXT:    fmuls f0, f1, f0
; NOVSX-NEXT:    lfs f1, -44(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -28(r1)
; NOVSX-NEXT:    fmuls f0, f1, f0
; NOVSX-NEXT:    lfs f1, -48(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -32(r1)
; NOVSX-NEXT:    fmuls f0, f1, f0
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    blr
  %res = call <4 x float> @llvm.experimental.constrained.fmul.v4f32(
                        <4 x float> %vf1, <4 x float> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <4 x float> %res;
}

define <2 x double> @fmul_v2f64(<2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fmul_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmuldp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmul_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmul f2, f2, f4
; NOVSX-NEXT:    fmul f1, f1, f3
; NOVSX-NEXT:    blr
  %res = call <2 x double> @llvm.experimental.constrained.fmul.v2f64(
                        <2 x double> %vf1, <2 x double> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <2 x double> %res;
}

define float @fdiv_f32(float %f1, float %f2) {
; CHECK-LABEL: fdiv_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsdivsp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fdiv_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fdivs f1, f1, f2
; NOVSX-NEXT:    blr

  %res = call float @llvm.experimental.constrained.fdiv.f32(
                        float %f1, float %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret float %res;
}

define double @fdiv_f64(double %f1, double %f2) {
; CHECK-LABEL: fdiv_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsdivdp f1, f1, f2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fdiv_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fdiv f1, f1, f2
; NOVSX-NEXT:    blr

  %res = call double @llvm.experimental.constrained.fdiv.f64(
                        double %f1, double %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %res;
}

define <4 x float> @fdiv_v4f32(<4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fdiv_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvdivsp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fdiv_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    addi r4, r1, -48
; NOVSX-NEXT:    stvx v3, 0, r3
; NOVSX-NEXT:    stvx v2, 0, r4
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -20(r1)
; NOVSX-NEXT:    lfs f1, -36(r1)
; NOVSX-NEXT:    fdivs f0, f1, f0
; NOVSX-NEXT:    lfs f1, -40(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -24(r1)
; NOVSX-NEXT:    fdivs f0, f1, f0
; NOVSX-NEXT:    lfs f1, -44(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -28(r1)
; NOVSX-NEXT:    fdivs f0, f1, f0
; NOVSX-NEXT:    lfs f1, -48(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -32(r1)
; NOVSX-NEXT:    fdivs f0, f1, f0
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    blr
  %res = call <4 x float> @llvm.experimental.constrained.fdiv.v4f32(
                        <4 x float> %vf1, <4 x float> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <4 x float> %res
}

define <2 x double> @fdiv_v2f64(<2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fdiv_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvdivdp v2, v2, v3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fdiv_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fdiv f2, f2, f4
; NOVSX-NEXT:    fdiv f1, f1, f3
; NOVSX-NEXT:    blr
  %res = call <2 x double> @llvm.experimental.constrained.fdiv.v2f64(
                        <2 x double> %vf1, <2 x double> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <2 x double> %res
}

define double @no_fma_fold(double %f1, double %f2, double %f3) {
; CHECK-LABEL: no_fma_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmuldp f0, f1, f2
; CHECK-NEXT:    xsadddp f1, f0, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: no_fma_fold:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmul f0, f1, f2
; NOVSX-NEXT:    fadd f1, f0, f3
; NOVSX-NEXT:    blr
  %mul = call double @llvm.experimental.constrained.fmul.f64(
                        double %f1, double %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %add = call double @llvm.experimental.constrained.fadd.f64(
                        double %mul, double %f3,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %add
}

define float @fmadd_f32(float %f0, float %f1, float %f2) {
; CHECK-LABEL: fmadd_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmaddasp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmadd_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmadds f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %res = call float @llvm.experimental.constrained.fma.f32(
                        float %f0, float %f1, float %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret float %res
}

define double @fmadd_f64(double %f0, double %f1, double %f2) {
; CHECK-LABEL: fmadd_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmaddadp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmadd_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmadd f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %res = call double @llvm.experimental.constrained.fma.f64(
                        double %f0, double %f1, double %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %res
}

define <4 x float> @fmadd_v4f32(<4 x float> %vf0, <4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fmadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmaddasp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmadd_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    addi r4, r1, -48
; NOVSX-NEXT:    stvx v4, 0, r3
; NOVSX-NEXT:    addi r3, r1, -64
; NOVSX-NEXT:    stvx v3, 0, r4
; NOVSX-NEXT:    stvx v2, 0, r3
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -20(r1)
; NOVSX-NEXT:    lfs f1, -36(r1)
; NOVSX-NEXT:    lfs f2, -52(r1)
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    lfs f1, -40(r1)
; NOVSX-NEXT:    lfs f2, -56(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -24(r1)
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    lfs f1, -44(r1)
; NOVSX-NEXT:    lfs f2, -60(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -28(r1)
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    lfs f1, -48(r1)
; NOVSX-NEXT:    lfs f2, -64(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -32(r1)
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    blr
  %res = call <4 x float> @llvm.experimental.constrained.fma.v4f32(
                        <4 x float> %vf0, <4 x float> %vf1, <4 x float> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <4 x float> %res
}

define <2 x double> @fmadd_v2f64(<2 x double> %vf0, <2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fmadd_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmaddadp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmadd_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmadd f2, f2, f4, f6
; NOVSX-NEXT:    fmadd f1, f1, f3, f5
; NOVSX-NEXT:    blr
  %res = call <2 x double> @llvm.experimental.constrained.fma.v2f64(
                        <2 x double> %vf0, <2 x double> %vf1, <2 x double> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <2 x double> %res
}

define float @fmsub_f32(float %f0, float %f1, float %f2) {
; CHECK-LABEL: fmsub_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmsubasp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmsub_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmsubs f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %neg = fneg float %f2
  %res = call float @llvm.experimental.constrained.fma.f32(
                        float %f0, float %f1, float %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret float %res
}

define double @fmsub_f64(double %f0, double %f1, double %f2) {
; CHECK-LABEL: fmsub_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmsubadp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmsub_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmsub f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %neg = fneg double %f2
  %res = call double @llvm.experimental.constrained.fma.f64(
                        double %f0, double %f1, double %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %res
}

define <4 x float> @fmsub_v4f32(<4 x float> %vf0, <4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fmsub_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmsubasp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmsub_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    vspltisb v5, -1
; NOVSX-NEXT:    addi r3, r1, -48
; NOVSX-NEXT:    addi r4, r1, -64
; NOVSX-NEXT:    stvx v3, 0, r3
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    stvx v2, 0, r4
; NOVSX-NEXT:    vslw v5, v5, v5
; NOVSX-NEXT:    vsubfp v4, v5, v4
; NOVSX-NEXT:    stvx v4, 0, r3
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -36(r1)
; NOVSX-NEXT:    lfs f1, -52(r1)
; NOVSX-NEXT:    lfs f2, -20(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    lfs f1, -56(r1)
; NOVSX-NEXT:    lfs f2, -24(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -40(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    lfs f1, -60(r1)
; NOVSX-NEXT:    lfs f2, -28(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -44(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    lfs f1, -64(r1)
; NOVSX-NEXT:    lfs f2, -32(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -48(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    blr
  %neg = fneg <4 x float> %vf2
  %res = call <4 x float> @llvm.experimental.constrained.fma.v4f32(
                        <4 x float> %vf0, <4 x float> %vf1, <4 x float> %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <4 x float> %res
}

define <2 x double> @fmsub_v2f64(<2 x double> %vf0, <2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fmsub_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmsubadp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fmsub_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fmsub f2, f2, f4, f6
; NOVSX-NEXT:    fmsub f1, f1, f3, f5
; NOVSX-NEXT:    blr
  %neg = fneg <2 x double> %vf2
  %res = call <2 x double> @llvm.experimental.constrained.fma.v2f64(
                        <2 x double> %vf0, <2 x double> %vf1, <2 x double> %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <2 x double> %res
}

define float @fnmadd_f32(float %f0, float %f1, float %f2) {
; CHECK-LABEL: fnmadd_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsnmaddasp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmadd_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fnmadds f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %fma = call float @llvm.experimental.constrained.fma.f32(
                        float %f0, float %f1, float %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg float %fma
  ret float %res
}

define double @fnmadd_f64(double %f0, double %f1, double %f2) {
; CHECK-LABEL: fnmadd_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsnmaddadp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmadd_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fnmadd f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %fma = call double @llvm.experimental.constrained.fma.f64(
                        double %f0, double %f1, double %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg double %fma
  ret double %res
}

define <4 x float> @fnmadd_v4f32(<4 x float> %vf0, <4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fnmadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmaddasp v4, v2, v3
; CHECK-NEXT:    xvnegsp v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmadd_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    addi r4, r1, -48
; NOVSX-NEXT:    stvx v4, 0, r3
; NOVSX-NEXT:    addi r3, r1, -64
; NOVSX-NEXT:    stvx v3, 0, r4
; NOVSX-NEXT:    stvx v2, 0, r3
; NOVSX-NEXT:    vspltisb v2, -1
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -20(r1)
; NOVSX-NEXT:    lfs f1, -36(r1)
; NOVSX-NEXT:    lfs f2, -52(r1)
; NOVSX-NEXT:    vslw v2, v2, v2
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    lfs f1, -40(r1)
; NOVSX-NEXT:    lfs f2, -56(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -24(r1)
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    lfs f1, -44(r1)
; NOVSX-NEXT:    lfs f2, -60(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -28(r1)
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    lfs f1, -48(r1)
; NOVSX-NEXT:    lfs f2, -64(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -32(r1)
; NOVSX-NEXT:    fmadds f0, f2, f1, f0
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v3, 0, r3
; NOVSX-NEXT:    vsubfp v2, v2, v3
; NOVSX-NEXT:    blr
  %fma = call <4 x float> @llvm.experimental.constrained.fma.v4f32(
                        <4 x float> %vf0, <4 x float> %vf1, <4 x float> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg <4 x float> %fma
  ret <4 x float> %res
}

define <2 x double> @fnmadd_v2f64(<2 x double> %vf0, <2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fnmadd_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvnmaddadp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmadd_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fnmadd f2, f2, f4, f6
; NOVSX-NEXT:    fnmadd f1, f1, f3, f5
; NOVSX-NEXT:    blr
  %fma = call <2 x double> @llvm.experimental.constrained.fma.v2f64(
                        <2 x double> %vf0, <2 x double> %vf1, <2 x double> %vf2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg <2 x double> %fma
  ret <2 x double> %res
}

define float @fnmsub_f32(float %f0, float %f1, float %f2) {
; CHECK-LABEL: fnmsub_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsnmsubasp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmsub_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fnmsubs f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %neg = fneg float %f2
  %fma = call float @llvm.experimental.constrained.fma.f32(
                        float %f0, float %f1, float %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg float %fma
  ret float %res
}

define double @fnmsub_f64(double %f0, double %f1, double %f2) {
; CHECK-LABEL: fnmsub_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsnmsubadp f3, f1, f2
; CHECK-NEXT:    fmr f1, f3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmsub_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fnmsub f1, f1, f2, f3
; NOVSX-NEXT:    blr
  %neg = fneg double %f2
  %fma = call double @llvm.experimental.constrained.fma.f64(
                        double %f0, double %f1, double %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg double %fma
  ret double %res
}

define <4 x float> @fnmsub_v4f32(<4 x float> %vf0, <4 x float> %vf1, <4 x float> %vf2) {
; CHECK-LABEL: fnmsub_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvnmsubasp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmsub_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    vspltisb v5, -1
; NOVSX-NEXT:    addi r3, r1, -48
; NOVSX-NEXT:    addi r4, r1, -64
; NOVSX-NEXT:    stvx v3, 0, r3
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    stvx v2, 0, r4
; NOVSX-NEXT:    vslw v5, v5, v5
; NOVSX-NEXT:    vsubfp v4, v5, v4
; NOVSX-NEXT:    stvx v4, 0, r3
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -36(r1)
; NOVSX-NEXT:    lfs f1, -52(r1)
; NOVSX-NEXT:    lfs f2, -20(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    lfs f1, -56(r1)
; NOVSX-NEXT:    lfs f2, -24(r1)
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -40(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    lfs f1, -60(r1)
; NOVSX-NEXT:    lfs f2, -28(r1)
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -44(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    lfs f1, -64(r1)
; NOVSX-NEXT:    lfs f2, -32(r1)
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -48(r1)
; NOVSX-NEXT:    fmadds f0, f1, f0, f2
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    vsubfp v2, v5, v2
; NOVSX-NEXT:    blr
  %neg = fneg <4 x float> %vf2
  %fma = call <4 x float> @llvm.experimental.constrained.fma.v4f32(
                        <4 x float> %vf0, <4 x float> %vf1, <4 x float> %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg <4 x float> %fma
  ret <4 x float> %res
}

define <2 x double> @fnmsub_v2f64(<2 x double> %vf0, <2 x double> %vf1, <2 x double> %vf2) {
; CHECK-LABEL: fnmsub_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvnmsubadp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fnmsub_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fnmsub f2, f2, f4, f6
; NOVSX-NEXT:    fnmsub f1, f1, f3, f5
; NOVSX-NEXT:    blr
  %neg = fneg <2 x double> %vf2
  %fma = call <2 x double> @llvm.experimental.constrained.fma.v2f64(
                        <2 x double> %vf0, <2 x double> %vf1, <2 x double> %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg <2 x double> %fma
  ret <2 x double> %res
}

define float @fsqrt_f32(float %f1) {
; CHECK-LABEL: fsqrt_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xssqrtsp f1, f1
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsqrt_f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fsqrts f1, f1
; NOVSX-NEXT:    blr
  %res = call float @llvm.experimental.constrained.sqrt.f32(
                        float %f1,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret float %res
}

define double @fsqrt_f64(double %f1) {
; CHECK-LABEL: fsqrt_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xssqrtdp f1, f1
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsqrt_f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fsqrt f1, f1
; NOVSX-NEXT:    blr
  %res = call double @llvm.experimental.constrained.sqrt.f64(
                        double %f1,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret double %res
}

define <4 x float> @fsqrt_v4f32(<4 x float> %vf1) {
; CHECK-LABEL: fsqrt_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvsqrtsp v2, v2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsqrt_v4f32:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    addi r3, r1, -32
; NOVSX-NEXT:    stvx v2, 0, r3
; NOVSX-NEXT:    addi r3, r1, -16
; NOVSX-NEXT:    lfs f0, -20(r1)
; NOVSX-NEXT:    fsqrts f0, f0
; NOVSX-NEXT:    stfs f0, -4(r1)
; NOVSX-NEXT:    lfs f0, -24(r1)
; NOVSX-NEXT:    fsqrts f0, f0
; NOVSX-NEXT:    stfs f0, -8(r1)
; NOVSX-NEXT:    lfs f0, -28(r1)
; NOVSX-NEXT:    fsqrts f0, f0
; NOVSX-NEXT:    stfs f0, -12(r1)
; NOVSX-NEXT:    lfs f0, -32(r1)
; NOVSX-NEXT:    fsqrts f0, f0
; NOVSX-NEXT:    stfs f0, -16(r1)
; NOVSX-NEXT:    lvx v2, 0, r3
; NOVSX-NEXT:    blr
  %res = call <4 x float> @llvm.experimental.constrained.sqrt.v4f32(
                        <4 x float> %vf1,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <4 x float> %res
}

define <2 x double> @fsqrt_v2f64(<2 x double> %vf1) {
; CHECK-LABEL: fsqrt_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvsqrtdp v2, v2
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: fsqrt_v2f64:
; NOVSX:       # %bb.0:
; NOVSX-NEXT:    fsqrt f2, f2
; NOVSX-NEXT:    fsqrt f1, f1
; NOVSX-NEXT:    blr
  %res = call <2 x double> @llvm.experimental.constrained.sqrt.v2f64(
                        <2 x double> %vf1,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret <2 x double> %res
}
