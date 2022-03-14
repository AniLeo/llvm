; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=ve -mattr=+vpu | FileCheck %s

declare <256 x float> @llvm.fma.v256f32(<256 x float>, <256 x float>, <256 x float>)

define fastcc <256 x float> @test_vec_fma_v256f32_vvv(<256 x float> %i0, <256 x float> %i1, <256 x float> %i2) {
; CHECK-LABEL: test_vec_fma_v256f32_vvv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vfmad.s %v0, %v2, %v0, %v1
; CHECK-NEXT:    b.l.t (, %s10)
  %r0 = call <256 x float> @llvm.fma.v256f32(<256 x float> %i0, <256 x float> %i1, <256 x float> %i2)
  ret <256 x float> %r0
}

define fastcc <256 x float> @test_vec_fma_v256f32_rvv(float %s0, <256 x float> %i1, <256 x float> %i2) {
; CHECK-LABEL: test_vec_fma_v256f32_rvv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vfmad.s %v0, %v1, %s0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %xins = insertelement <256 x float> undef, float %s0, i32 0
  %i0 = shufflevector <256 x float> %xins, <256 x float> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x float> @llvm.fma.v256f32(<256 x float> %i0, <256 x float> %i1, <256 x float> %i2)
  ret <256 x float> %r0
}

define fastcc <256 x float> @test_vec_fma_v256f32_vrv(<256 x float> %i0, float %s1, <256 x float> %i2) {
; CHECK-LABEL: test_vec_fma_v256f32_vrv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vfmad.s %v0, %v1, %s0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %yins = insertelement <256 x float> undef, float %s1, i32 0
  %i1 = shufflevector <256 x float> %yins, <256 x float> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x float> @llvm.fma.v256f32(<256 x float> %i0, <256 x float> %i1, <256 x float> %i2)
  ret <256 x float> %r0
}

define fastcc <256 x float> @test_vec_fma_v256f32_vvr(<256 x float> %i0, <256 x float> %i1, float %s2) {
; CHECK-LABEL: test_vec_fma_v256f32_vvr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vfmad.s %v0, %s0, %v0, %v1
; CHECK-NEXT:    b.l.t (, %s10)
  %zins = insertelement <256 x float> undef, float %s2, i32 0
  %i2 = shufflevector <256 x float> %zins, <256 x float> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x float> @llvm.fma.v256f32(<256 x float> %i0, <256 x float> %i1, <256 x float> %i2)
  ret <256 x float> %r0
}

declare <256 x double> @llvm.fma.v256f64(<256 x double>, <256 x double>, <256 x double>)

define fastcc <256 x double> @test_vec_fma_v256f64_vvv(<256 x double> %i0, <256 x double> %i1, <256 x double> %i2) {
; CHECK-LABEL: test_vec_fma_v256f64_vvv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vfmad.d %v0, %v2, %v0, %v1
; CHECK-NEXT:    b.l.t (, %s10)
  %r0 = call <256 x double> @llvm.fma.v256f64(<256 x double> %i0, <256 x double> %i1, <256 x double> %i2)
  ret <256 x double> %r0
}

define fastcc <256 x double> @test_vec_fma_v256f64_rvv(double %s0, <256 x double> %i1, <256 x double> %i2) {
; CHECK-LABEL: test_vec_fma_v256f64_rvv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vfmad.d %v0, %v1, %s0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %xins = insertelement <256 x double> undef, double %s0, i32 0
  %i0 = shufflevector <256 x double> %xins, <256 x double> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x double> @llvm.fma.v256f64(<256 x double> %i0, <256 x double> %i1, <256 x double> %i2)
  ret <256 x double> %r0
}

define fastcc <256 x double> @test_vec_fma_v256f64_vrv(<256 x double> %i0, double %s1, <256 x double> %i2) {
; CHECK-LABEL: test_vec_fma_v256f64_vrv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vfmad.d %v0, %v1, %s0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %yins = insertelement <256 x double> undef, double %s1, i32 0
  %i1 = shufflevector <256 x double> %yins, <256 x double> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x double> @llvm.fma.v256f64(<256 x double> %i0, <256 x double> %i1, <256 x double> %i2)
  ret <256 x double> %r0
}

define fastcc <256 x double> @test_vec_fma_v256f64_vvr(<256 x double> %i0, <256 x double> %i1, double %s2) {
; CHECK-LABEL: test_vec_fma_v256f64_vvr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vfmad.d %v0, %s0, %v0, %v1
; CHECK-NEXT:    b.l.t (, %s10)
  %zins = insertelement <256 x double> undef, double %s2, i32 0
  %i2 = shufflevector <256 x double> %zins, <256 x double> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x double> @llvm.fma.v256f64(<256 x double> %i0, <256 x double> %i1, <256 x double> %i2)
  ret <256 x double> %r0
}
