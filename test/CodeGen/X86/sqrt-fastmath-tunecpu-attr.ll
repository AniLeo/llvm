; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-- < %s | FileCheck %s

define float @f32_tune_nhm(float %f) #0 {
; CHECK-LABEL: f32_tune_nhm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rsqrtss %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm0, %xmm2
; CHECK-NEXT:    mulss %xmm1, %xmm2
; CHECK-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; CHECK-NEXT:    mulss %xmm2, %xmm3
; CHECK-NEXT:    mulss %xmm1, %xmm2
; CHECK-NEXT:    addss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm2
; CHECK-NEXT:    mulss %xmm3, %xmm2
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    cmpltss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    andnps %xmm2, %xmm0
; CHECK-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f)
  ret float %call
}

define float @f32_no_tune(float %f) #1 {
; CHECK-LABEL: f32_no_tune:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sqrtss %xmm0, %xmm0
; CHECK-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f)
  ret float %call
}

define float @f32_tune_generic(float %f) #2 {
; CHECK-LABEL: f32_tune_generic:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sqrtss %xmm0, %xmm0
; CHECK-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f)
  ret float %call
}

define float @f32_tune_x86_64(float %f) #3 {
; CHECK-LABEL: f32_tune_x86_64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rsqrtss %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm0, %xmm2
; CHECK-NEXT:    mulss %xmm1, %xmm2
; CHECK-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; CHECK-NEXT:    mulss %xmm2, %xmm3
; CHECK-NEXT:    mulss %xmm1, %xmm2
; CHECK-NEXT:    addss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm2
; CHECK-NEXT:    mulss %xmm3, %xmm2
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    cmpltss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    andnps %xmm2, %xmm0
; CHECK-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f)
  ret float %call
}

define float @f32_tune_snb(float %f) #4 {
; CHECK-LABEL: f32_tune_snb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sqrtss %xmm0, %xmm0
; CHECK-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f)
  ret float %call
}

define float @f32_target_snb_tune_snb(float %f) #5 {
; CHECK-LABEL: f32_target_snb_tune_snb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f)
  ret float %call
}

declare float @llvm.sqrt.f32(float)

attributes #0 = { "target-cpu"="x86-64" "tune-cpu"="nehalem" }
attributes #1 = { "target-cpu"="x86-64" }
attributes #2 = { "target-cpu"="x86-64" "tune-cpu"="generic" }
attributes #3 = { "target-cpu"="x86-64" "tune-cpu"="x86-64" }
attributes #4 = { "target-cpu"="x86-64" "tune-cpu"="sandybridge" }
attributes #5 = { "target-cpu"="sandybridge" "tune-cpu"="sandybridge" }
