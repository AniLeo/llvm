; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2   | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx    | FileCheck %s --check-prefixes=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2   | FileCheck %s --check-prefixes=AVX

; 0'th element insertion into an SSE register.

define <4 x float> @insert_f32_firstelt(<4 x float> %x, float* %s.addr) {
; SSE2-LABEL: insert_f32_firstelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_f32_firstelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_f32_firstelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX-NEXT:    retq
  %s = load float, float* %s.addr
  %i0 = insertelement <4 x float> %x, float %s, i32 0
  ret <4 x float> %i0
}

define <2 x double> @insert_f64_firstelt(<2 x double> %x, double* %s.addr) {
; SSE-LABEL: insert_f64_firstelt:
; SSE:       # %bb.0:
; SSE-NEXT:    movlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_f64_firstelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %s = load double, double* %s.addr
  %i0 = insertelement <2 x double> %x, double %s, i32 0
  ret <2 x double> %i0
}

define <16 x i8> @insert_i8_firstelt(<16 x i8> %x, i8* %s.addr) {
; SSE2-LABEL: insert_i8_firstelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    movzbl (%rdi), %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    pandn %xmm2, %xmm1
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i8_firstelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pinsrb $0, (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i8_firstelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrb $0, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i8, i8* %s.addr
  %i0 = insertelement <16 x i8> %x, i8 %s, i32 0
  ret <16 x i8> %i0
}

define <8 x i16> @insert_i16_firstelt(<8 x i16> %x, i16* %s.addr) {
; SSE-LABEL: insert_i16_firstelt:
; SSE:       # %bb.0:
; SSE-NEXT:    pinsrw $0, (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_i16_firstelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrw $0, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i16, i16* %s.addr
  %i0 = insertelement <8 x i16> %x, i16 %s, i32 0
  ret <8 x i16> %i0
}

define <4 x i32> @insert_i32_firstelt(<4 x i32> %x, i32* %s.addr) {
; SSE2-LABEL: insert_i32_firstelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i32_firstelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pinsrd $0, (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i32_firstelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrd $0, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i32, i32* %s.addr
  %i0 = insertelement <4 x i32> %x, i32 %s, i32 0
  ret <4 x i32> %i0
}

define <2 x i64> @insert_i64_firstelt(<2 x i64> %x, i64* %s.addr) {
; SSE2-LABEL: insert_i64_firstelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i64_firstelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pinsrq $0, (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i64_firstelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrq $0, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i64, i64* %s.addr
  %i0 = insertelement <2 x i64> %x, i64 %s, i32 0
  ret <2 x i64> %i0
}

; 1'th element insertion.

define <4 x float> @insert_f32_secondelt(<4 x float> %x, float* %s.addr) {
; SSE2-LABEL: insert_f32_secondelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,0],xmm0[2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_f32_secondelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_f32_secondelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; AVX-NEXT:    retq
  %s = load float, float* %s.addr
  %i0 = insertelement <4 x float> %x, float %s, i32 1
  ret <4 x float> %i0
}

define <2 x double> @insert_f64_secondelt(<2 x double> %x, double* %s.addr) {
; SSE-LABEL: insert_f64_secondelt:
; SSE:       # %bb.0:
; SSE-NEXT:    movhps {{.*#+}} xmm0 = xmm0[0,1],mem[0,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_f64_secondelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovhps {{.*#+}} xmm0 = xmm0[0,1],mem[0,1]
; AVX-NEXT:    retq
  %s = load double, double* %s.addr
  %i0 = insertelement <2 x double> %x, double %s, i32 1
  ret <2 x double> %i0
}

define <16 x i8> @insert_i8_secondelt(<16 x i8> %x, i8* %s.addr) {
; SSE2-LABEL: insert_i8_secondelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [255,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    movzbl (%rdi), %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    psllw $8, %xmm2
; SSE2-NEXT:    pandn %xmm2, %xmm1
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i8_secondelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pinsrb $1, (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i8_secondelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrb $1, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i8, i8* %s.addr
  %i0 = insertelement <16 x i8> %x, i8 %s, i32 1
  ret <16 x i8> %i0
}

define <8 x i16> @insert_i16_secondelt(<8 x i16> %x, i16* %s.addr) {
; SSE-LABEL: insert_i16_secondelt:
; SSE:       # %bb.0:
; SSE-NEXT:    pinsrw $1, (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_i16_secondelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrw $1, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i16, i16* %s.addr
  %i0 = insertelement <8 x i16> %x, i16 %s, i32 1
  ret <8 x i16> %i0
}

define <4 x i32> @insert_i32_secondelt(<4 x i32> %x, i32* %s.addr) {
; SSE2-LABEL: insert_i32_secondelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,0],xmm0[2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i32_secondelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pinsrd $1, (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i32_secondelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrd $1, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i32, i32* %s.addr
  %i0 = insertelement <4 x i32> %x, i32 %s, i32 1
  ret <4 x i32> %i0
}

define <2 x i64> @insert_i64_secondelt(<2 x i64> %x, i64* %s.addr) {
; SSE2-LABEL: insert_i64_secondelt:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i64_secondelt:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pinsrq $1, (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i64_secondelt:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrq $1, (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i64, i64* %s.addr
  %i0 = insertelement <2 x i64> %x, i64 %s, i32 1
  ret <2 x i64> %i0
}

; element insertion into two elements

define <4 x float> @insert_f32_two_elts(<4 x float> %x, float* %s.addr) {
; SSE-LABEL: insert_f32_two_elts:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[2,3]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_f32_two_elts:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm1[0,0],xmm0[2,3]
; AVX-NEXT:    retq
  %s = load float, float* %s.addr
  %i0 = insertelement <4 x float> %x, float %s, i32 0
  %i1 = insertelement <4 x float> %i0, float %s, i32 1
  ret <4 x float> %i1
}

define <2 x double> @insert_f64_two_elts(<2 x double> %x, double* %s.addr) {
; SSE2-LABEL: insert_f64_two_elts:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0,0]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_f64_two_elts:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movddup {{.*#+}} xmm0 = mem[0,0]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_f64_two_elts:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = mem[0,0]
; AVX-NEXT:    retq
  %s = load double, double* %s.addr
  %i0 = insertelement <2 x double> %x, double %s, i32 0
  %i1 = insertelement <2 x double> %i0, double %s, i32 1
  ret <2 x double> %i1
}

define <16 x i8> @insert_i8_two_elts(<16 x i8> %x, i8* %s.addr) {
; SSE2-LABEL: insert_i8_two_elts:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    movzbl (%rdi), %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    pandn %xmm2, %xmm1
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [255,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    psllw $8, %xmm2
; SSE2-NEXT:    pandn %xmm2, %xmm1
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i8_two_elts:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movzbl (%rdi), %eax
; SSE41-NEXT:    pinsrb $0, %eax, %xmm0
; SSE41-NEXT:    pinsrb $1, %eax, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i8_two_elts:
; AVX:       # %bb.0:
; AVX-NEXT:    movzbl (%rdi), %eax
; AVX-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $1, %eax, %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i8, i8* %s.addr
  %i0 = insertelement <16 x i8> %x, i8 %s, i32 0
  %i1 = insertelement <16 x i8> %i0, i8 %s, i32 1
  ret <16 x i8> %i1
}

define <8 x i16> @insert_i16_two_elts(<8 x i16> %x, i16* %s.addr) {
; SSE-LABEL: insert_i16_two_elts:
; SSE:       # %bb.0:
; SSE-NEXT:    movzwl (%rdi), %eax
; SSE-NEXT:    pinsrw $0, %eax, %xmm0
; SSE-NEXT:    pinsrw $1, %eax, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_i16_two_elts:
; AVX:       # %bb.0:
; AVX-NEXT:    movzwl (%rdi), %eax
; AVX-NEXT:    vpinsrw $0, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrw $1, %eax, %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i16, i16* %s.addr
  %i0 = insertelement <8 x i16> %x, i16 %s, i32 0
  %i1 = insertelement <8 x i16> %i0, i16 %s, i32 1
  ret <8 x i16> %i1
}

define <4 x i32> @insert_i32_two_elts(<4 x i32> %x, i32* %s.addr) {
; SSE2-LABEL: insert_i32_two_elts:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movl (%rdi), %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    movd %eax, %xmm1
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,0],xmm0[2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i32_two_elts:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movl (%rdi), %eax
; SSE41-NEXT:    pinsrd $0, %eax, %xmm0
; SSE41-NEXT:    pinsrd $1, %eax, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i32_two_elts:
; AVX:       # %bb.0:
; AVX-NEXT:    movl (%rdi), %eax
; AVX-NEXT:    vpinsrd $0, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrd $1, %eax, %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = load i32, i32* %s.addr
  %i0 = insertelement <4 x i32> %x, i32 %s, i32 0
  %i1 = insertelement <4 x i32> %i0, i32 %s, i32 1
  ret <4 x i32> %i1
}

define <2 x i64> @insert_i64_two_elts(<2 x i64> %x, i64* %s.addr) {
; SSE-LABEL: insert_i64_two_elts:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_i64_two_elts:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = mem[0,0]
; AVX-NEXT:    retq
  %s = load i64, i64* %s.addr
  %i0 = insertelement <2 x i64> %x, i64 %s, i32 0
  %i1 = insertelement <2 x i64> %i0, i64 %s, i32 1
  ret <2 x i64> %i1
}

; Special tests

define void @insert_i32_two_elts_into_different_vectors(<4 x i32> %x, <4 x i32> %y, i32* %s.addr, <4 x i32>* %x.out.addr, <4 x i32>* %y.out.addr) {
; SSE2-LABEL: insert_i32_two_elts_into_different_vectors:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movl (%rdi), %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[2,0],xmm1[2,3]
; SSE2-NEXT:    movaps %xmm0, (%rsi)
; SSE2-NEXT:    movaps %xmm2, (%rdx)
; SSE2-NEXT:    retq
;
; SSE41-LABEL: insert_i32_two_elts_into_different_vectors:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movl (%rdi), %eax
; SSE41-NEXT:    pinsrd $0, %eax, %xmm0
; SSE41-NEXT:    pinsrd $1, %eax, %xmm1
; SSE41-NEXT:    movdqa %xmm0, (%rsi)
; SSE41-NEXT:    movdqa %xmm1, (%rdx)
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_i32_two_elts_into_different_vectors:
; AVX:       # %bb.0:
; AVX-NEXT:    movl (%rdi), %eax
; AVX-NEXT:    vpinsrd $0, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrd $1, %eax, %xmm1, %xmm1
; AVX-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX-NEXT:    vmovdqa %xmm1, (%rdx)
; AVX-NEXT:    retq
  %s = load i32, i32* %s.addr
  %i0 = insertelement <4 x i32> %x, i32 %s, i32 0
  %i1 = insertelement <4 x i32> %y, i32 %s, i32 1
  store <4 x i32> %i0, <4 x i32>* %x.out.addr
  store <4 x i32> %i1, <4 x i32>* %y.out.addr
  ret void
}

define <4 x float> @insert_f32_two_elts_extrause_of_scalar(<4 x float> %x, float* %s.addr, float* %s.out) {
; SSE-LABEL: insert_f32_two_elts_extrause_of_scalar:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    movss %xmm1, (%rsi)
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[2,3]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: insert_f32_two_elts_extrause_of_scalar:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovss %xmm1, (%rsi)
; AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm1[0,0],xmm0[2,3]
; AVX-NEXT:    retq
  %s = load float, float* %s.addr
  store float %s, float* %s.out
  %i0 = insertelement <4 x float> %x, float %s, i32 0
  %i1 = insertelement <4 x float> %i0, float %s, i32 1
  ret <4 x float> %i1
}
