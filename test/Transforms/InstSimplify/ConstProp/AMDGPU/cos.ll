; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

declare half @llvm.amdgcn.cos.f16(half) #0
declare float @llvm.amdgcn.cos.f32(float) #0
declare double @llvm.amdgcn.cos.f64(double) #0

define void @test_f16(half* %p) {
; CHECK-LABEL: @test_f16(
; CHECK-NEXT:    store volatile half 0xH3C00, half* [[P:%.*]], align 2
; CHECK-NEXT:    store volatile half 0xH3C00, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH39A8, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH39A8, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH0000, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH0000, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xHBC00, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xHBC00, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH3C00, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH3C00, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH3C00, half* [[P]], align 2
; CHECK-NEXT:    store volatile half 0xH3C00, half* [[P]], align 2
; CHECK-NEXT:    [[P1000:%.*]] = call half @llvm.amdgcn.cos.f16(half 0xH63D0)
; CHECK-NEXT:    store volatile half [[P1000]], half* [[P]], align 2
; CHECK-NEXT:    [[N1000:%.*]] = call half @llvm.amdgcn.cos.f16(half 0xHE3D0)
; CHECK-NEXT:    store volatile half [[N1000]], half* [[P]], align 2
; CHECK-NEXT:    [[PINF:%.*]] = call half @llvm.amdgcn.cos.f16(half 0xH7C00)
; CHECK-NEXT:    store volatile half [[PINF]], half* [[P]], align 2
; CHECK-NEXT:    [[NINF:%.*]] = call half @llvm.amdgcn.cos.f16(half 0xHFC00)
; CHECK-NEXT:    store volatile half [[NINF]], half* [[P]], align 2
; CHECK-NEXT:    [[NAN:%.*]] = call half @llvm.amdgcn.cos.f16(half 0xH7E00)
; CHECK-NEXT:    store volatile half [[NAN]], half* [[P]], align 2
; CHECK-NEXT:    ret void
;
  %p0 = call half @llvm.amdgcn.cos.f16(half +0.0)
  store volatile half %p0, half* %p
  %n0 = call half @llvm.amdgcn.cos.f16(half -0.0)
  store volatile half %n0, half* %p
  %p0125 = call half @llvm.amdgcn.cos.f16(half +0.125)
  store volatile half %p0125, half* %p
  %n0125 = call half @llvm.amdgcn.cos.f16(half -0.125)
  store volatile half %n0125, half* %p
  %p025 = call half @llvm.amdgcn.cos.f16(half +0.25)
  store volatile half %p025, half* %p
  %n025 = call half @llvm.amdgcn.cos.f16(half -0.25)
  store volatile half %n025, half* %p
  %p05 = call half @llvm.amdgcn.cos.f16(half +0.5)
  store volatile half %p05, half* %p
  %n05 = call half @llvm.amdgcn.cos.f16(half -0.5)
  store volatile half %n05, half* %p
  %p1 = call half @llvm.amdgcn.cos.f16(half +1.0)
  store volatile half %p1, half* %p
  %n1 = call half @llvm.amdgcn.cos.f16(half -1.0)
  store volatile half %n1, half* %p
  %p256 = call half @llvm.amdgcn.cos.f16(half +256.0)
  store volatile half %p256, half* %p
  %n256 = call half @llvm.amdgcn.cos.f16(half -256.0)
  store volatile half %n256, half* %p
  %p1000 = call half @llvm.amdgcn.cos.f16(half +1000.0)
  store volatile half %p1000, half* %p
  %n1000 = call half @llvm.amdgcn.cos.f16(half -1000.0)
  store volatile half %n1000, half* %p
  %pinf = call half @llvm.amdgcn.cos.f16(half 0xH7C00) ; +inf
  store volatile half %pinf, half* %p
  %ninf = call half @llvm.amdgcn.cos.f16(half 0xHFC00) ; -inf
  store volatile half %ninf, half* %p
  %nan = call half @llvm.amdgcn.cos.f16(half 0xH7E00) ; nan
  store volatile half %nan, half* %p
  ret void
}

define void @test_f32(float* %p) {
; CHECK-LABEL: @test_f32(
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P:%.*]], align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 0x3FE6A09E60000000, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 0x3FE6A09E60000000, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float -1.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float -1.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]], align 4
; CHECK-NEXT:    [[P1000:%.*]] = call float @llvm.amdgcn.cos.f32(float 1.000000e+03)
; CHECK-NEXT:    store volatile float [[P1000]], float* [[P]], align 4
; CHECK-NEXT:    [[N1000:%.*]] = call float @llvm.amdgcn.cos.f32(float -1.000000e+03)
; CHECK-NEXT:    store volatile float [[N1000]], float* [[P]], align 4
; CHECK-NEXT:    [[PINF:%.*]] = call float @llvm.amdgcn.cos.f32(float 0x7FF0000000000000)
; CHECK-NEXT:    store volatile float [[PINF]], float* [[P]], align 4
; CHECK-NEXT:    [[NINF:%.*]] = call float @llvm.amdgcn.cos.f32(float 0xFFF0000000000000)
; CHECK-NEXT:    store volatile float [[NINF]], float* [[P]], align 4
; CHECK-NEXT:    [[NAN:%.*]] = call float @llvm.amdgcn.cos.f32(float 0x7FF8000000000000)
; CHECK-NEXT:    store volatile float [[NAN]], float* [[P]], align 4
; CHECK-NEXT:    ret void
;
  %p0 = call float @llvm.amdgcn.cos.f32(float +0.0)
  store volatile float %p0, float* %p
  %n0 = call float @llvm.amdgcn.cos.f32(float -0.0)
  store volatile float %n0, float* %p
  %p0125 = call float @llvm.amdgcn.cos.f32(float +0.125)
  store volatile float %p0125, float* %p
  %n0125 = call float @llvm.amdgcn.cos.f32(float -0.125)
  store volatile float %n0125, float* %p
  %p025 = call float @llvm.amdgcn.cos.f32(float +0.25)
  store volatile float %p025, float* %p
  %n025 = call float @llvm.amdgcn.cos.f32(float -0.25)
  store volatile float %n025, float* %p
  %p05 = call float @llvm.amdgcn.cos.f32(float +0.5)
  store volatile float %p05, float* %p
  %n05 = call float @llvm.amdgcn.cos.f32(float -0.5)
  store volatile float %n05, float* %p
  %p1 = call float @llvm.amdgcn.cos.f32(float +1.0)
  store volatile float %p1, float* %p
  %n1 = call float @llvm.amdgcn.cos.f32(float -1.0)
  store volatile float %n1, float* %p
  %p256 = call float @llvm.amdgcn.cos.f32(float +256.0)
  store volatile float %p256, float* %p
  %n256 = call float @llvm.amdgcn.cos.f32(float -256.0)
  store volatile float %n256, float* %p
  %p1000 = call float @llvm.amdgcn.cos.f32(float +1000.0)
  store volatile float %p1000, float* %p
  %n1000 = call float @llvm.amdgcn.cos.f32(float -1000.0)
  store volatile float %n1000, float* %p
  %pinf = call float @llvm.amdgcn.cos.f32(float 0x7FF0000000000000) ; +inf
  store volatile float %pinf, float* %p
  %ninf = call float @llvm.amdgcn.cos.f32(float 0xFFF0000000000000) ; -inf
  store volatile float %ninf, float* %p
  %nan = call float @llvm.amdgcn.cos.f32(float 0x7FF8000000000000) ; nan
  store volatile float %nan, float* %p
  ret void
}

define void @test_f64(double* %p) {
; CHECK-LABEL: @test_f64(
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 0x3FE6A09E667F3B{{.*}}, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 0x3FE6A09E667F3B{{.*}}, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double -1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double -1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    [[P1000:%.*]] = call double @llvm.amdgcn.cos.f64(double 1.000000e+03)
; CHECK-NEXT:    store volatile double [[P1000]], double* [[P]], align 8
; CHECK-NEXT:    [[N1000:%.*]] = call double @llvm.amdgcn.cos.f64(double -1.000000e+03)
; CHECK-NEXT:    store volatile double [[N1000]], double* [[P]], align 8
; CHECK-NEXT:    [[PINF:%.*]] = call double @llvm.amdgcn.cos.f64(double 0x7FF0000000000000)
; CHECK-NEXT:    store volatile double [[PINF]], double* [[P]], align 8
; CHECK-NEXT:    [[NINF:%.*]] = call double @llvm.amdgcn.cos.f64(double 0xFFF0000000000000)
; CHECK-NEXT:    store volatile double [[NINF]], double* [[P]], align 8
; CHECK-NEXT:    [[NAN:%.*]] = call double @llvm.amdgcn.cos.f64(double 0x7FF8000000000000)
; CHECK-NEXT:    store volatile double [[NAN]], double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %p0 = call double @llvm.amdgcn.cos.f64(double +0.0)
  store volatile double %p0, double* %p
  %n0 = call double @llvm.amdgcn.cos.f64(double -0.0)
  store volatile double %n0, double* %p
  %p0125 = call double @llvm.amdgcn.cos.f64(double +0.125)
  store volatile double %p0125, double* %p
  %n0125 = call double @llvm.amdgcn.cos.f64(double -0.125)
  store volatile double %n0125, double* %p
  %p025 = call double @llvm.amdgcn.cos.f64(double +0.25)
  store volatile double %p025, double* %p
  %n025 = call double @llvm.amdgcn.cos.f64(double -0.25)
  store volatile double %n025, double* %p
  %p05 = call double @llvm.amdgcn.cos.f64(double +0.5)
  store volatile double %p05, double* %p
  %n05 = call double @llvm.amdgcn.cos.f64(double -0.5)
  store volatile double %n05, double* %p
  %p1 = call double @llvm.amdgcn.cos.f64(double +1.0)
  store volatile double %p1, double* %p
  %n1 = call double @llvm.amdgcn.cos.f64(double -1.0)
  store volatile double %n1, double* %p
  %p256 = call double @llvm.amdgcn.cos.f64(double +256.0)
  store volatile double %p256, double* %p
  %n256 = call double @llvm.amdgcn.cos.f64(double -256.0)
  store volatile double %n256, double* %p
  %p1000 = call double @llvm.amdgcn.cos.f64(double +1000.0)
  store volatile double %p1000, double* %p
  %n1000 = call double @llvm.amdgcn.cos.f64(double -1000.0)
  store volatile double %n1000, double* %p
  %pinf = call double @llvm.amdgcn.cos.f64(double 0x7FF0000000000000) ; +inf
  store volatile double %pinf, double* %p
  %ninf = call double @llvm.amdgcn.cos.f64(double 0xFFF0000000000000) ; -inf
  store volatile double %ninf, double* %p
  %nan = call double @llvm.amdgcn.cos.f64(double 0x7FF8000000000000) ; nan
  store volatile double %nan, double* %p
  ret void
}

define void @test_f16_strictfp (half* %p) #1 {
; CHECK-LABEL: @test_f16_strictfp(
; CHECK-NEXT:    [[P0:%.*]] = call half @llvm.amdgcn.cos.f16(half 0xH0000) #1
; CHECK-NEXT:    store volatile half [[P0]], half* [[P:%.*]], align 2
; CHECK-NEXT:    [[P025:%.*]] = call half @llvm.amdgcn.cos.f16(half 0xH3400) #1
; CHECK-NEXT:    store volatile half [[P025]], half* [[P]], align 2
; CHECK-NEXT:    ret void
;
  %p0 = call half @llvm.amdgcn.cos.f16(half +0.0) #1
  store volatile half %p0, half* %p
  %p025 = call half @llvm.amdgcn.cos.f16(half +0.25) #1
  store volatile half %p025, half* %p
  ret void
}

define void @test_f32_strictfp(float* %p) #1 {
; CHECK-LABEL: @test_f32_strictfp(
; CHECK-NEXT:    [[P0:%.*]] = call float @llvm.amdgcn.cos.f32(float 0.000000e+00) #1
; CHECK-NEXT:    store volatile float [[P0]], float* [[P:%.*]], align 4
; CHECK-NEXT:    [[P025:%.*]] = call float @llvm.amdgcn.cos.f32(float 2.500000e-01) #1
; CHECK-NEXT:    store volatile float [[P025]], float* [[P]], align 4
; CHECK-NEXT:    ret void
;
  %p0 = call float @llvm.amdgcn.cos.f32(float +0.0) #1
  store volatile float %p0, float* %p
  %p025 = call float @llvm.amdgcn.cos.f32(float +0.25) #1
  store volatile float %p025, float* %p
  ret void
}

define void @test_f64_strictfp(double* %p) #1 {
; CHECK-LABEL: @test_f64_strictfp(
; CHECK-NEXT:    [[P0:%.*]] = call double @llvm.amdgcn.cos.f64(double 0.000000e+00) #1
; CHECK-NEXT:    store volatile double [[P0]], double* [[P:%.*]], align 8
; CHECK-NEXT:    [[P025:%.*]] = call double @llvm.amdgcn.cos.f64(double 2.500000e-01) #1
; CHECK-NEXT:    store volatile double [[P025]], double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %p0 = call double @llvm.amdgcn.cos.f64(double +0.0) #1
  store volatile double %p0, double* %p
  %p025 = call double @llvm.amdgcn.cos.f64(double +0.25) #1
  store volatile double %p025, double* %p
  ret void
}

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { strictfp }
