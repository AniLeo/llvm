; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+fma | FileCheck %s --check-prefix=FMA
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefix=FMA

; PR31866
; complex float complex_square_f32(complex float x) {
;   return x*x;
; }

define <2 x float> @complex_square_f32(<2 x float>) #0 {
; SSE-LABEL: complex_square_f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    addss %xmm0, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    mulss %xmm0, %xmm0
; SSE-NEXT:    mulss %xmm1, %xmm1
; SSE-NEXT:    subss %xmm1, %xmm0
; SSE-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[2,3]
; SSE-NEXT:    retq
;
; AVX1-LABEL: complex_square_f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-NEXT:    vaddss %xmm0, %xmm0, %xmm2
; AVX1-NEXT:    vmulss %xmm2, %xmm1, %xmm2
; AVX1-NEXT:    vmulss %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    vmulss %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[2,3]
; AVX1-NEXT:    retq
;
; FMA-LABEL: complex_square_f32:
; FMA:       # %bb.0:
; FMA-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; FMA-NEXT:    vaddss %xmm0, %xmm0, %xmm2
; FMA-NEXT:    vmulss %xmm2, %xmm1, %xmm2
; FMA-NEXT:    vmulss %xmm1, %xmm1, %xmm1
; FMA-NEXT:    vfmsub231ss {{.*#+}} xmm1 = (xmm0 * xmm0) - xmm1
; FMA-NEXT:    vinsertps {{.*#+}} xmm0 = xmm1[0],xmm2[0],xmm1[2,3]
; FMA-NEXT:    retq
  %2 = extractelement <2 x float> %0, i32 0
  %3 = extractelement <2 x float> %0, i32 1
  %4 = fmul fast float %3, 2.000000e+00
  %5 = fmul fast float %4, %2
  %6 = fmul fast float %2, %2
  %7 = fmul fast float %3, %3
  %8 = fsub fast float %6, %7
  %9 = insertelement <2 x float> undef, float %8, i32 0
  %10 = insertelement <2 x float> %9, float %5, i32 1
  ret <2 x float> %10
}

define <2 x double> @complex_square_f64(<2 x double>) #0 {
; SSE-LABEL: complex_square_f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE-NEXT:    movapd %xmm0, %xmm2
; SSE-NEXT:    addsd %xmm0, %xmm2
; SSE-NEXT:    mulsd %xmm1, %xmm2
; SSE-NEXT:    mulsd %xmm0, %xmm0
; SSE-NEXT:    mulsd %xmm1, %xmm1
; SSE-NEXT:    subsd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; SSE-NEXT:    retq
;
; AVX1-LABEL: complex_square_f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX1-NEXT:    vaddsd %xmm0, %xmm0, %xmm2
; AVX1-NEXT:    vmulsd %xmm2, %xmm1, %xmm2
; AVX1-NEXT:    vmulsd %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    vmulsd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX1-NEXT:    retq
;
; FMA-LABEL: complex_square_f64:
; FMA:       # %bb.0:
; FMA-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; FMA-NEXT:    vaddsd %xmm0, %xmm0, %xmm2
; FMA-NEXT:    vmulsd %xmm2, %xmm1, %xmm2
; FMA-NEXT:    vmulsd %xmm1, %xmm1, %xmm1
; FMA-NEXT:    vfmsub231sd {{.*#+}} xmm1 = (xmm0 * xmm0) - xmm1
; FMA-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm1[0],xmm2[0]
; FMA-NEXT:    retq
  %2 = extractelement <2 x double> %0, i32 0
  %3 = extractelement <2 x double> %0, i32 1
  %4 = fmul fast double %3, 2.000000e+00
  %5 = fmul fast double %4, %2
  %6 = fmul fast double %2, %2
  %7 = fmul fast double %3, %3
  %8 = fsub fast double %6, %7
  %9 = insertelement <2 x double> undef, double %8, i32 0
  %10 = insertelement <2 x double> %9, double %5, i32 1
  ret <2 x double> %10
}

; complex float complex_mul_f32(complex float x, complex float y) {
;   return x*y;
; }

define <2 x float> @complex_mul_f32(<2 x float>, <2 x float>) #0 {
; SSE-LABEL: complex_mul_f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE-NEXT:    movshdup {{.*#+}} xmm3 = xmm1[1,1,3,3]
; SSE-NEXT:    movaps %xmm3, %xmm4
; SSE-NEXT:    mulss %xmm0, %xmm4
; SSE-NEXT:    mulss %xmm1, %xmm0
; SSE-NEXT:    mulss %xmm2, %xmm1
; SSE-NEXT:    addss %xmm4, %xmm1
; SSE-NEXT:    mulss %xmm2, %xmm3
; SSE-NEXT:    subss %xmm3, %xmm0
; SSE-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[2,3]
; SSE-NEXT:    retq
;
; AVX1-LABEL: complex_mul_f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; AVX1-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm1[1,1,3,3]
; AVX1-NEXT:    vmulss %xmm0, %xmm3, %xmm4
; AVX1-NEXT:    vmulss %xmm2, %xmm1, %xmm5
; AVX1-NEXT:    vaddss %xmm5, %xmm4, %xmm4
; AVX1-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vmulss %xmm2, %xmm3, %xmm1
; AVX1-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[2,3]
; AVX1-NEXT:    retq
;
; FMA-LABEL: complex_mul_f32:
; FMA:       # %bb.0:
; FMA-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; FMA-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm1[1,1,3,3]
; FMA-NEXT:    vmulss %xmm2, %xmm1, %xmm4
; FMA-NEXT:    vfmadd231ss {{.*#+}} xmm4 = (xmm3 * xmm0) + xmm4
; FMA-NEXT:    vmulss %xmm2, %xmm3, %xmm2
; FMA-NEXT:    vfmsub231ss {{.*#+}} xmm2 = (xmm1 * xmm0) - xmm2
; FMA-NEXT:    vinsertps {{.*#+}} xmm0 = xmm2[0],xmm4[0],xmm2[2,3]
; FMA-NEXT:    retq
  %3 = extractelement <2 x float> %0, i32 0
  %4 = extractelement <2 x float> %0, i32 1
  %5 = extractelement <2 x float> %1, i32 0
  %6 = extractelement <2 x float> %1, i32 1
  %7 = fmul fast float %6, %3
  %8 = fmul fast float %5, %4
  %9 = fadd fast float %7, %8
  %10 = fmul fast float %5, %3
  %11 = fmul fast float %6, %4
  %12 = fsub fast float %10, %11
  %13 = insertelement <2 x float> undef, float %12, i32 0
  %14 = insertelement <2 x float> %13, float %9, i32 1
  ret <2 x float> %14
}

define <2 x double> @complex_mul_f64(<2 x double>, <2 x double>) #0 {
; SSE-LABEL: complex_mul_f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movapd %xmm0, %xmm2
; SSE-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm0[1]
; SSE-NEXT:    movapd %xmm1, %xmm3
; SSE-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1],xmm1[1]
; SSE-NEXT:    movapd %xmm3, %xmm4
; SSE-NEXT:    mulsd %xmm0, %xmm4
; SSE-NEXT:    mulsd %xmm1, %xmm0
; SSE-NEXT:    mulsd %xmm2, %xmm1
; SSE-NEXT:    addsd %xmm4, %xmm1
; SSE-NEXT:    mulsd %xmm2, %xmm3
; SSE-NEXT:    subsd %xmm3, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-NEXT:    retq
;
; AVX1-LABEL: complex_mul_f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm0[1,0]
; AVX1-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm1[1,0]
; AVX1-NEXT:    vmulsd %xmm0, %xmm3, %xmm4
; AVX1-NEXT:    vmulsd %xmm2, %xmm1, %xmm5
; AVX1-NEXT:    vaddsd %xmm5, %xmm4, %xmm4
; AVX1-NEXT:    vmulsd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vmulsd %xmm2, %xmm3, %xmm1
; AVX1-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm0[0],xmm4[0]
; AVX1-NEXT:    retq
;
; FMA-LABEL: complex_mul_f64:
; FMA:       # %bb.0:
; FMA-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm0[1,0]
; FMA-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm1[1,0]
; FMA-NEXT:    vmulsd %xmm2, %xmm1, %xmm4
; FMA-NEXT:    vfmadd231sd {{.*#+}} xmm4 = (xmm3 * xmm0) + xmm4
; FMA-NEXT:    vmulsd %xmm2, %xmm3, %xmm2
; FMA-NEXT:    vfmsub231sd {{.*#+}} xmm2 = (xmm1 * xmm0) - xmm2
; FMA-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm2[0],xmm4[0]
; FMA-NEXT:    retq
  %3 = extractelement <2 x double> %0, i32 0
  %4 = extractelement <2 x double> %0, i32 1
  %5 = extractelement <2 x double> %1, i32 0
  %6 = extractelement <2 x double> %1, i32 1
  %7 = fmul fast double %6, %3
  %8 = fmul fast double %5, %4
  %9 = fadd fast double %7, %8
  %10 = fmul fast double %5, %3
  %11 = fmul fast double %6, %4
  %12 = fsub fast double %10, %11
  %13 = insertelement <2 x double> undef, double %12, i32 0
  %14 = insertelement <2 x double> %13, double %9, i32 1
  ret <2 x double> %14
}

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "no-infs-fp-math" "no-nans-fp-math" "no-signed-zeros-fp-math" "no-trapping-math" "unsafe-fp-math"  }
