; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma -fp-contract=fast | FileCheck %s --check-prefix=FMA
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma4,+fma -fp-contract=fast | FileCheck %s --check-prefix=FMA4
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma4 -fp-contract=fast | FileCheck %s --check-prefix=FMA4
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512dq -fp-contract=fast | FileCheck %s --check-prefix=AVX512

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

;
; Patterns (+ fneg variants): mul(add(1.0,x),y), mul(sub(1.0,x),y), mul(sub(x,1.0),y)
;

define <16 x float> @test_v16f32_mul_add_x_one_y(<16 x float> %x, <16 x float> %y) {
; FMA-LABEL: test_v16f32_mul_add_x_one_y:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd213ps %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmadd213ps %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_mul_add_x_one_y:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddps %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddps %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_mul_add_x_one_y:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd213ps %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %a = fadd <16 x float> %x, <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>
  %m = fmul <16 x float> %a, %y
  ret <16 x float> %m
}

define <8 x double> @test_v8f64_mul_y_add_x_one(<8 x double> %x, <8 x double> %y) {
; FMA-LABEL: test_v8f64_mul_y_add_x_one:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd213pd %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmadd213pd %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_mul_y_add_x_one:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddpd %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddpd %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_mul_y_add_x_one:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd213pd %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %a = fadd <8 x double> %x, <double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0>
  %m = fmul <8 x double> %y, %a
  ret <8 x double> %m
}

define <16 x float> @test_v16f32_mul_add_x_negone_y(<16 x float> %x, <16 x float> %y) {
; FMA-LABEL: test_v16f32_mul_add_x_negone_y:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub213ps %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmsub213ps %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_mul_add_x_negone_y:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubps %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmsubps %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_mul_add_x_negone_y:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmsub213ps %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %a = fadd <16 x float> %x, <float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0>
  %m = fmul <16 x float> %a, %y
  ret <16 x float> %m
}

define <8 x double> @test_v8f64_mul_y_add_x_negone(<8 x double> %x, <8 x double> %y) {
; FMA-LABEL: test_v8f64_mul_y_add_x_negone:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub213pd %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmsub213pd %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_mul_y_add_x_negone:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubpd %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmsubpd %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_mul_y_add_x_negone:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmsub213pd %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %a = fadd <8 x double> %x, <double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0>
  %m = fmul <8 x double> %y, %a
  ret <8 x double> %m
}

define <16 x float> @test_v16f32_mul_sub_one_x_y(<16 x float> %x, <16 x float> %y) {
; FMA-LABEL: test_v16f32_mul_sub_one_x_y:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmadd213ps %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfnmadd213ps %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_mul_sub_one_x_y:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmaddps %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmaddps %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_mul_sub_one_x_y:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmadd213ps %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <16 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %x
  %m = fmul <16 x float> %s, %y
  ret <16 x float> %m
}

define <8 x double> @test_v8f64_mul_y_sub_one_x(<8 x double> %x, <8 x double> %y) {
; FMA-LABEL: test_v8f64_mul_y_sub_one_x:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmadd213pd %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfnmadd213pd %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_mul_y_sub_one_x:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmaddpd %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmaddpd %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_mul_y_sub_one_x:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmadd213pd %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <8 x double> <double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0>, %x
  %m = fmul <8 x double> %y, %s
  ret <8 x double> %m
}

define <16 x float> @test_v16f32_mul_sub_negone_x_y(<16 x float> %x, <16 x float> %y) {
; FMA-LABEL: test_v16f32_mul_sub_negone_x_y:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmsub213ps %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfnmsub213ps %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_mul_sub_negone_x_y:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmsubps %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmsubps %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_mul_sub_negone_x_y:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmsub213ps %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <16 x float> <float -1.0, float -1.0, float -1.0, float -1.0,float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0>, %x
  %m = fmul <16 x float> %s, %y
  ret <16 x float> %m
}

define <8 x double> @test_v8f64_mul_y_sub_negone_x(<8 x double> %x, <8 x double> %y) {
; FMA-LABEL: test_v8f64_mul_y_sub_negone_x:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmsub213pd %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfnmsub213pd %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_mul_y_sub_negone_x:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmsubpd %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmsubpd %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_mul_y_sub_negone_x:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmsub213pd %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <8 x double> <double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0>, %x
  %m = fmul <8 x double> %y, %s
  ret <8 x double> %m
}

define <16 x float> @test_v16f32_mul_sub_x_one_y(<16 x float> %x, <16 x float> %y) {
; FMA-LABEL: test_v16f32_mul_sub_x_one_y:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub213ps %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmsub213ps %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_mul_sub_x_one_y:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubps %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmsubps %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_mul_sub_x_one_y:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmsub213ps %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <16 x float> %x, <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>
  %m = fmul <16 x float> %s, %y
  ret <16 x float> %m
}

define <8 x double> @test_v8f64_mul_y_sub_x_one(<8 x double> %x, <8 x double> %y) {
; FMA-LABEL: test_v8f64_mul_y_sub_x_one:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub213pd %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmsub213pd %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_mul_y_sub_x_one:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubpd %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmsubpd %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_mul_y_sub_x_one:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmsub213pd %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <8 x double> %x, <double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0>
  %m = fmul <8 x double> %y, %s
  ret <8 x double> %m
}

define <16 x float> @test_v16f32_mul_sub_x_negone_y(<16 x float> %x, <16 x float> %y) {
; FMA-LABEL: test_v16f32_mul_sub_x_negone_y:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd213ps %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmadd213ps %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_mul_sub_x_negone_y:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddps %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddps %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_mul_sub_x_negone_y:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd213ps %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <16 x float> %x, <float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0, float -1.0>
  %m = fmul <16 x float> %s, %y
  ret <16 x float> %m
}

define <8 x double> @test_v8f64_mul_y_sub_x_negone(<8 x double> %x, <8 x double> %y) {
; FMA-LABEL: test_v8f64_mul_y_sub_x_negone:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd213pd %ymm2, %ymm2, %ymm0
; FMA-NEXT:    vfmadd213pd %ymm3, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_mul_y_sub_x_negone:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddpd %ymm2, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddpd %ymm3, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_mul_y_sub_x_negone:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd213pd %zmm1, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %s = fsub <8 x double> %x, <double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0, double -1.0>
  %m = fmul <8 x double> %y, %s
  ret <8 x double> %m
}

;
; Interpolation Patterns: add(mul(x,t),mul(sub(1.0,t),y))
;

define <16 x float> @test_v16f32_interp(<16 x float> %x, <16 x float> %y, <16 x float> %t) {
; FMA-LABEL: test_v16f32_interp:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmadd213ps %ymm3, %ymm5, %ymm3
; FMA-NEXT:    vfnmadd213ps %ymm2, %ymm4, %ymm2
; FMA-NEXT:    vfmadd213ps %ymm2, %ymm4, %ymm0
; FMA-NEXT:    vfmadd213ps %ymm3, %ymm5, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_interp:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmaddps %ymm3, %ymm3, %ymm5, %ymm3
; FMA4-NEXT:    vfnmaddps %ymm2, %ymm2, %ymm4, %ymm2
; FMA4-NEXT:    vfmaddps %ymm2, %ymm4, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddps %ymm3, %ymm5, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_interp:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovaps %zmm2, %zmm3
; AVX512-NEXT:    vfnmadd213ps %zmm1, %zmm1, %zmm3
; AVX512-NEXT:    vfmadd213ps %zmm3, %zmm2, %zmm0
; AVX512-NEXT:    retq
  %t1 = fsub <16 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %t
  %tx = fmul <16 x float> %x, %t
  %ty = fmul <16 x float> %y, %t1
  %r = fadd <16 x float> %tx, %ty
  ret <16 x float> %r
}

define <8 x double> @test_v8f64_interp(<8 x double> %x, <8 x double> %y, <8 x double> %t) {
; FMA-LABEL: test_v8f64_interp:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmadd213pd %ymm3, %ymm5, %ymm3
; FMA-NEXT:    vfnmadd213pd %ymm2, %ymm4, %ymm2
; FMA-NEXT:    vfmadd213pd %ymm2, %ymm4, %ymm0
; FMA-NEXT:    vfmadd213pd %ymm3, %ymm5, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_interp:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmaddpd %ymm3, %ymm3, %ymm5, %ymm3
; FMA4-NEXT:    vfnmaddpd %ymm2, %ymm2, %ymm4, %ymm2
; FMA4-NEXT:    vfmaddpd %ymm2, %ymm4, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddpd %ymm3, %ymm5, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_interp:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmovaps %zmm2, %zmm3
; AVX512-NEXT:    vfnmadd213pd %zmm1, %zmm1, %zmm3
; AVX512-NEXT:    vfmadd213pd %zmm3, %zmm2, %zmm0
; AVX512-NEXT:    retq
  %t1 = fsub <8 x double> <double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0>, %t
  %tx = fmul <8 x double> %x, %t
  %ty = fmul <8 x double> %y, %t1
  %r = fadd <8 x double> %tx, %ty
  ret <8 x double> %r
}

;
; Pattern: (fneg (fma x, y, z)) -> (fma x, -y, -z)
;

define <16 x float> @test_v16f32_fneg_fmadd(<16 x float> %a0, <16 x float> %a1, <16 x float> %a2) #0 {
; FMA-LABEL: test_v16f32_fneg_fmadd:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmsub213ps %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmsub213ps %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_fneg_fmadd:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmsubps %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmsubps %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_fneg_fmadd:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmsub213ps %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %mul = fmul <16 x float> %a0, %a1
  %add = fadd <16 x float> %mul, %a2
  %neg = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %add
  ret <16 x float> %neg
}

define <8 x double> @test_v8f64_fneg_fmsub(<8 x double> %a0, <8 x double> %a1, <8 x double> %a2) #0 {
; FMA-LABEL: test_v8f64_fneg_fmsub:
; FMA:       # BB#0:
; FMA-NEXT:    vfnmadd213pd %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmadd213pd %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_fneg_fmsub:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfnmaddpd %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmaddpd %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_fneg_fmsub:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfnmadd213pd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %mul = fmul <8 x double> %a0, %a1
  %sub = fsub <8 x double> %mul, %a2
  %neg = fsub <8 x double> <double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0>, %sub
  ret <8 x double> %neg
}

define <16 x float> @test_v16f32_fneg_fnmadd(<16 x float> %a0, <16 x float> %a1, <16 x float> %a2) #0 {
; FMA-LABEL: test_v16f32_fneg_fnmadd:
; FMA:       # BB#0:
; FMA-NEXT:    vfmsub213ps %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfmsub213ps %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_fneg_fnmadd:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmsubps %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmsubps %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_fneg_fnmadd:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmsub213ps %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %mul = fmul <16 x float> %a0, %a1
  %neg0 = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %mul
  %add = fadd <16 x float> %neg0, %a2
  %neg1 = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %add
  ret <16 x float> %neg1
}

define <8 x double> @test_v8f64_fneg_fnmsub(<8 x double> %a0, <8 x double> %a1, <8 x double> %a2) #0 {
; FMA-LABEL: test_v8f64_fneg_fnmsub:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd213pd %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfmadd213pd %ymm5, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_fneg_fnmsub:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddpd %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfmaddpd %ymm5, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_fneg_fnmsub:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd213pd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %mul = fmul <8 x double> %a0, %a1
  %neg0 = fsub <8 x double> <double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0>, %mul
  %sub = fsub <8 x double> %neg0, %a2
  %neg1 = fsub <8 x double> <double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0>, %sub
  ret <8 x double> %neg1
}

;
; Pattern: (fma x, c1, (fmul x, c2)) -> (fmul x, c1+c2)
;

define <16 x float> @test_v16f32_fma_x_c1_fmul_x_c2(<16 x float> %x) #0 {
; FMA-LABEL: test_v16f32_fma_x_c1_fmul_x_c2:
; FMA:       # BB#0:
; FMA-NEXT:    vmulps {{.*}}(%rip), %ymm0, %ymm0
; FMA-NEXT:    vmulps {{.*}}(%rip), %ymm1, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_fma_x_c1_fmul_x_c2:
; FMA4:       # BB#0:
; FMA4-NEXT:    vmulps {{.*}}(%rip), %ymm0, %ymm0
; FMA4-NEXT:    vmulps {{.*}}(%rip), %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_fma_x_c1_fmul_x_c2:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmulps {{.*}}(%rip), %zmm0, %zmm0
; AVX512-NEXT:    retq
  %m0 = fmul <16 x float> %x, <float 17.0, float 16.0, float 15.0, float 14.0, float 13.0, float 12.0, float 11.0, float 10.0, float 9.0, float 8.0, float 7.0, float 6.0, float 5.0, float 4.0, float 3.0, float 2.0>
  %m1 = fmul <16 x float> %x, <float 16.0, float 15.0, float 14.0, float 13.0, float 12.0, float 11.0, float 10.0, float 9.0, float 8.0, float 7.0, float 6.0, float 5.0, float 4.0, float 3.0, float 2.0, float 1.0>
  %a  = fadd <16 x float> %m0, %m1
  ret <16 x float> %a
}

;
; Pattern: (fma (fmul x, c1), c2, y) -> (fma x, c1*c2, y)
;

define <16 x float> @test_v16f32_fma_fmul_x_c1_c2_y(<16 x float> %x, <16 x float> %y) #0 {
; FMA-LABEL: test_v16f32_fma_fmul_x_c1_c2_y:
; FMA:       # BB#0:
; FMA-NEXT:    vfmadd132ps {{.*}}(%rip), %ymm2, %ymm0
; FMA-NEXT:    vfmadd132ps {{.*}}(%rip), %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_fma_fmul_x_c1_c2_y:
; FMA4:       # BB#0:
; FMA4-NEXT:    vfmaddps %ymm2, {{.*}}(%rip), %ymm0, %ymm0
; FMA4-NEXT:    vfmaddps %ymm3, {{.*}}(%rip), %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_fma_fmul_x_c1_c2_y:
; AVX512:       # BB#0:
; AVX512-NEXT:    vfmadd231ps {{.*}}(%rip), %zmm0, %zmm1
; AVX512-NEXT:    vmovaps %zmm1, %zmm0
; AVX512-NEXT:    retq
  %m0 = fmul <16 x float> %x,  <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0, float 9.0, float 10.0, float 11.0, float 12.0, float 13.0, float 14.0, float 15.0, float 16.0>
  %m1 = fmul <16 x float> %m0, <float 16.0, float 15.0, float 14.0, float 13.0, float 12.0, float 11.0, float 10.0, float 9.0, float 8.0, float 7.0, float 6.0, float 5.0, float 4.0, float 3.0, float 2.0, float 1.0>
  %a  = fadd <16 x float> %m1, %y
  ret <16 x float> %a
}

; Pattern: (fneg (fmul x, y)) -> (fnmsub x, y, 0)

define <16 x float> @test_v16f32_fneg_fmul(<16 x float> %x, <16 x float> %y) #0 {
; FMA-LABEL: test_v16f32_fneg_fmul:
; FMA:       # BB#0:
; FMA-NEXT:    vxorps %ymm4, %ymm4, %ymm4
; FMA-NEXT:    vfnmsub213ps %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmsub213ps %ymm4, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v16f32_fneg_fmul:
; FMA4:       # BB#0:
; FMA4-NEXT:    vxorps %ymm4, %ymm4, %ymm4
; FMA4-NEXT:    vfnmsubps %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmsubps %ymm4, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v16f32_fneg_fmul:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; AVX512-NEXT:    vfnmsub213ps %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %m = fmul nsz <16 x float> %x, %y
  %n = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %m
  ret <16 x float> %n
}

define <8 x double> @test_v8f64_fneg_fmul(<8 x double> %x, <8 x double> %y) #0 {
; FMA-LABEL: test_v8f64_fneg_fmul:
; FMA:       # BB#0:
; FMA-NEXT:    vxorpd %ymm4, %ymm4, %ymm4
; FMA-NEXT:    vfnmsub213pd %ymm4, %ymm2, %ymm0
; FMA-NEXT:    vfnmsub213pd %ymm4, %ymm3, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_fneg_fmul:
; FMA4:       # BB#0:
; FMA4-NEXT:    vxorpd %ymm4, %ymm4, %ymm4
; FMA4-NEXT:    vfnmsubpd %ymm4, %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vfnmsubpd %ymm4, %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_fneg_fmul:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; AVX512-NEXT:    vfnmsub213pd %zmm2, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %m = fmul nsz <8 x double> %x, %y
  %n = fsub <8 x double> <double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0>, %m
  ret <8 x double> %n
}

define <8 x double> @test_v8f64_fneg_fmul_no_nsz(<8 x double> %x, <8 x double> %y) #0 {
; FMA-LABEL: test_v8f64_fneg_fmul_no_nsz:
; FMA:       # BB#0:
; FMA-NEXT:    vmulpd %ymm3, %ymm1, %ymm1
; FMA-NEXT:    vmulpd %ymm2, %ymm0, %ymm0
; FMA-NEXT:    vmovapd {{.*#+}} ymm2 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
; FMA-NEXT:    vxorpd %ymm2, %ymm0, %ymm0
; FMA-NEXT:    vxorpd %ymm2, %ymm1, %ymm1
; FMA-NEXT:    retq
;
; FMA4-LABEL: test_v8f64_fneg_fmul_no_nsz:
; FMA4:       # BB#0:
; FMA4-NEXT:    vmulpd %ymm3, %ymm1, %ymm1
; FMA4-NEXT:    vmulpd %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vmovapd {{.*#+}} ymm2 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
; FMA4-NEXT:    vxorpd %ymm2, %ymm0, %ymm0
; FMA4-NEXT:    vxorpd %ymm2, %ymm1, %ymm1
; FMA4-NEXT:    retq
;
; AVX512-LABEL: test_v8f64_fneg_fmul_no_nsz:
; AVX512:       # BB#0:
; AVX512-NEXT:    vmulpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vxorpd {{.*}}(%rip), %zmm0, %zmm0
; AVX512-NEXT:    retq
  %m = fmul <8 x double> %x, %y
  %n = fsub <8 x double> <double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0>, %m
  ret <8 x double> %n
}

attributes #0 = { "unsafe-fp-math"="true" }
