; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -verify-machineinstrs -verify-coalescing -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -verify-machineinstrs -verify-coalescing -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -verify-machineinstrs -verify-coalescing -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -verify-machineinstrs -verify-coalescing -mattr=+avx512f | FileCheck %s --check-prefix=AVX512

; PR30607

define <2 x double> @insert_f64(double %a0, <2 x double> %a1) {
; SSE2-LABEL: insert_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_f64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
;
; AVX512-LABEL: insert_f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovsd {{.*#+}} xmm0 = xmm0[0],xmm1[1]
; AVX512-NEXT:    retq
 %1 = insertelement <2 x double> %a1, double %a0, i32 0
 ret <2 x double> %1
}

define <4 x float> @insert_f32(float %a0, <4 x float> %a1) {
; SSE2-LABEL: insert_f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX-NEXT:    retq
;
; AVX512-LABEL: insert_f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovss {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX512-NEXT:    retq
 %1 = insertelement <4 x float> %a1, float %a0, i32 0
 ret <4 x float> %1
}
