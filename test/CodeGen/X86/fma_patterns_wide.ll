; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma -fp-contract=fast | FileCheck %s --check-prefix=FMA
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma4,+fma -fp-contract=fast | FileCheck %s --check-prefix=FMA
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma4 -fp-contract=fast | FileCheck %s --check-prefix=FMA4
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -fp-contract=fast | FileCheck %s --check-prefix=AVX512

;
; Pattern: (fadd (fmul x, y), z) -> (fmadd x,y,z)
;

define <16 x float> @test_16f32_fmadd(<16 x float> %a0, <16 x float> %a1, <16 x float> %a2) {
; FMA-LABEL: test_16f32_fmadd:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd213ps %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfmadd213ps %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_16f32_fmadd:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddps %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddps %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_16f32_fmadd:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd213ps %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <16 x float> %a0, %a1
  %res = fadd <16 x float> %x, %a2
  ret <16 x float> %res
}

define <8 x double> @test_8f64_fmadd(<8 x double> %a0, <8 x double> %a1, <8 x double> %a2) {
; FMA-LABEL: test_8f64_fmadd:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd213pd %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfmadd213pd %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_8f64_fmadd:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddpd %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddpd %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_8f64_fmadd:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd213pd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <8 x double> %a0, %a1
  %res = fadd <8 x double> %x, %a2
  ret <8 x double> %res
}

;
; Pattern: (fsub (fmul x, y), z) -> (fmsub x, y, z)
;

define <16 x float> @test_16f32_fmsub(<16 x float> %a0, <16 x float> %a1, <16 x float> %a2) {
; FMA-LABEL: test_16f32_fmsub:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub213ps %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfmsub213ps %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_16f32_fmsub:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubps %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmsubps %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_16f32_fmsub:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmsub213ps %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <16 x float> %a0, %a1
  %res = fsub <16 x float> %x, %a2
  ret <16 x float> %res
}

define <8 x double> @test_8f64_fmsub(<8 x double> %a0, <8 x double> %a1, <8 x double> %a2) {
; FMA-LABEL: test_8f64_fmsub:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub213pd %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfmsub213pd %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_8f64_fmsub:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubpd %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmsubpd %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_8f64_fmsub:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmsub213pd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <8 x double> %a0, %a1
  %res = fsub <8 x double> %x, %a2
  ret <8 x double> %res
}

;
; Pattern: (fsub z, (fmul x, y)) -> (fnmadd x, y, z)
;

define <16 x float> @test_16f32_fnmadd(<16 x float> %a0, <16 x float> %a1, <16 x float> %a2) {
; FMA-LABEL: test_16f32_fnmadd:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmadd213ps %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmadd213ps %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_16f32_fnmadd:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmaddps %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmaddps %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_16f32_fnmadd:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmadd213ps %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <16 x float> %a0, %a1
  %res = fsub <16 x float> %a2, %x
  ret <16 x float> %res
}

define <8 x double> @test_8f64_fnmadd(<8 x double> %a0, <8 x double> %a1, <8 x double> %a2) {
; FMA-LABEL: test_8f64_fnmadd:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmadd213pd %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmadd213pd %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_8f64_fnmadd:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmaddpd %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmaddpd %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_8f64_fnmadd:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmadd213pd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <8 x double> %a0, %a1
  %res = fsub <8 x double> %a2, %x
  ret <8 x double> %res
}

;
; Pattern: (fsub (fneg (fmul x, y)), z) -> (fnmsub x, y, z)
;

define <16 x float> @test_16f32_fnmsub(<16 x float> %a0, <16 x float> %a1, <16 x float> %a2) {
; FMA-LABEL: test_16f32_fnmsub:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmsub213ps %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmsub213ps %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_16f32_fnmsub:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmsubps %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmsubps %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_16f32_fnmsub:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmsub213ps %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <16 x float> %a0, %a1
  %y = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %x
  %res = fsub <16 x float> %y, %a2
  ret <16 x float> %res
}

define <8 x double> @test_8f64_fnmsub(<8 x double> %a0, <8 x double> %a1, <8 x double> %a2) {
; FMA-LABEL: test_8f64_fnmsub:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmsub213pd %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmsub213pd %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_8f64_fnmsub:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmsubpd %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmsubpd %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_8f64_fnmsub:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmsub213pd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %x = fmul <8 x double> %a0, %a1
  %y = fsub <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %x
  %res = fsub <8 x double> %y, %a2
  ret <8 x double> %res
}

;
; Load Folding Patterns
;

define <16 x float> @test_16f32_fmadd_load(<16 x float>* %a0, <16 x float> %a1, <16 x float> %a2) {
; FMA-LABEL: test_16f32_fmadd_load:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd132ps (%rdi), %ymm2, %ymm0
; FMA-NEXT:    vfmadd132ps 32(%rdi), %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_16f32_fmadd_load:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddps %ymm2, (%rdi), %ymm0, %ymm0
; FMA4-NEXT:    vfmaddps %ymm3, 32(%rdi), %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_16f32_fmadd_load:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovaps (%rdi), %zmm2
; AVX512-NEXT:    vfmadd213ps %zmm1, %zmm0, %zmm2
; AVX512-NEXT:    vmovaps %zmm2, %zmm0
; AVX512-NEXT:    retq
  %x = load <16 x float>, <16 x float>* %a0
  %y = fmul <16 x float> %x, %a1
  %res = fadd <16 x float> %y, %a2
  ret <16 x float> %res
}

define <8 x double> @test_8f64_fmsub_load(<8 x double>* %a0, <8 x double> %a1, <8 x double> %a2) {
; FMA-LABEL: test_8f64_fmsub_load:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub132pd (%rdi), %ymm2, %ymm0
; FMA-NEXT:    vfmsub132pd 32(%rdi), %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_8f64_fmsub_load:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubpd %ymm2, (%rdi), %ymm0, %ymm0
; FMA4-NEXT:    vfmsubpd %ymm3, 32(%rdi), %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_8f64_fmsub_load:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovapd (%rdi), %zmm2
; AVX512-NEXT:    vfmsub213pd %zmm1, %zmm0, %zmm2
; AVX512-NEXT:    vmovaps %zmm2, %zmm0
; AVX512-NEXT:    retq
  %x = load <8 x double>, <8 x double>* %a0
  %y = fmul <8 x double> %x, %a1
  %res = fsub <8 x double> %y, %a2
  ret <8 x double> %res
}
