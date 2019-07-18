; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+ssse3 | FileCheck %s --check-prefixes=SSE,SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2

;
; Partial Vector Loads - PR16739
;

define <4 x float> @load_float4_float3(<4 x float>* nocapture readonly dereferenceable(16)) {
; SSE-LABEL: load_float4_float3:
; SSE:       # %bb.0:
; SSE-NEXT:    movups (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_float4_float3:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovups (%rdi), %xmm0
; AVX-NEXT:    retq
  %p0 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 0
  %p1 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 1
  %p2 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 2
  %ld0 = load float, float* %p0, align 4
  %ld1 = load float, float* %p1, align 4
  %ld2 = load float, float* %p2, align 4
  %r0 = insertelement <4 x float> undef, float %ld0, i32 0
  %r1 = insertelement <4 x float> %r0,   float %ld1, i32 1
  %r2 = insertelement <4 x float> %r1,   float %ld2, i32 2
  ret <4 x float> %r2
}

define <8 x float> @load_float8_float3(<4 x float>* nocapture readonly dereferenceable(16)) {
; SSE-LABEL: load_float8_float3:
; SSE:       # %bb.0:
; SSE-NEXT:    movups (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_float8_float3:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovups (%rdi), %xmm0
; AVX-NEXT:    retq
  %p0 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 0
  %p1 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 1
  %p2 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 2
  %ld0 = load float, float* %p0, align 4
  %ld1 = load float, float* %p1, align 4
  %ld2 = load float, float* %p2, align 4
  %r0 = insertelement <8 x float> undef, float %ld0, i32 0
  %r1 = insertelement <8 x float> %r0,   float %ld1, i32 1
  %r2 = insertelement <8 x float> %r1,   float %ld2, i32 2
  ret <8 x float> %r2
}

define <4 x float> @load_float4_float3_as_float2_float(<4 x float>* nocapture readonly dereferenceable(16)) {
; SSE-LABEL: load_float4_float3_as_float2_float:
; SSE:       # %bb.0:
; SSE-NEXT:    movups (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_float4_float3_as_float2_float:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovups (%rdi), %xmm0
; AVX-NEXT:    retq
  %2 = bitcast <4 x float>* %0 to <2 x float>*
  %3 = load <2 x float>, <2 x float>* %2, align 4
  %4 = extractelement <2 x float> %3, i32 0
  %5 = insertelement <4 x float> undef, float %4, i32 0
  %6 = extractelement <2 x float> %3, i32 1
  %7 = insertelement <4 x float> %5, float %6, i32 1
  %8 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 2
  %9 = load float, float* %8, align 4
  %10 = insertelement <4 x float> %7, float %9, i32 2
  ret <4 x float> %10
}

define <4 x float> @load_float4_float3_trunc(<4 x float>* nocapture readonly dereferenceable(16)) {
; SSE-LABEL: load_float4_float3_trunc:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_float4_float3_trunc:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    retq
  %2 = bitcast <4 x float>* %0 to i64*
  %3 = load i64, i64* %2, align 16
  %4 = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0, i64 2
  %5 = bitcast float* %4 to i64*
  %6 = load i64, i64* %5, align 8
  %7 = trunc i64 %3 to i32
  %8 = bitcast i32 %7 to float
  %9 = insertelement <4 x float> undef, float %8, i32 0
  %10 = lshr i64 %3, 32
  %11 = trunc i64 %10 to i32
  %12 = bitcast i32 %11 to float
  %13 = insertelement <4 x float> %9, float %12, i32 1
  %14 = trunc i64 %6 to i32
  %15 = bitcast i32 %14 to float
  %16 = insertelement <4 x float> %13, float %15, i32 2
  ret <4 x float> %16
}

; PR21780
define <4 x double> @load_double4_0u2u(double* nocapture readonly dereferenceable(32)) {
; SSE2-LABEL: load_double4_0u2u:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0,0]
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0,0]
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: load_double4_0u2u:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movddup {{.*#+}} xmm0 = mem[0,0]
; SSSE3-NEXT:    movddup {{.*#+}} xmm1 = mem[0,0]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: load_double4_0u2u:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movddup {{.*#+}} xmm0 = mem[0,0]
; SSE41-NEXT:    movddup {{.*#+}} xmm1 = mem[0,0]
; SSE41-NEXT:    retq
;
; AVX-LABEL: load_double4_0u2u:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} ymm0 = mem[0,0,2,2]
; AVX-NEXT:    retq
  %2 = load double, double* %0, align 8
  %3 = insertelement <4 x double> undef, double %2, i32 0
  %4 = getelementptr inbounds double, double* %0, i64 2
  %5 = load double, double* %4, align 8
  %6 = insertelement <4 x double> %3, double %5, i32 2
  %7 = shufflevector <4 x double> %6, <4 x double> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
  ret <4 x double> %7
}
