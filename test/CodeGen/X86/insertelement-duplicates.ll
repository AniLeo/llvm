; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE-32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE-64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX-32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX-64

define void @PR15298(<4 x float>* nocapture %source, <8 x float>* nocapture %dest) nounwind noinline {
; SSE-32-LABEL: PR15298:
; SSE-32:       # BB#0: # %L.entry
; SSE-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; SSE-32-NEXT:    movaps 304(%ecx), %xmm0
; SSE-32-NEXT:    xorps %xmm1, %xmm1
; SSE-32-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0],xmm1[0,1]
; SSE-32-NEXT:    shufps {{.*#+}} xmm0 = xmm0[2,0,1,3]
; SSE-32-NEXT:    movups %xmm1, 624(%eax)
; SSE-32-NEXT:    movups %xmm0, 608(%eax)
; SSE-32-NEXT:    retl
;
; SSE-64-LABEL: PR15298:
; SSE-64:       # BB#0: # %L.entry
; SSE-64-NEXT:    movaps 304(%rdi), %xmm0
; SSE-64-NEXT:    xorps %xmm1, %xmm1
; SSE-64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0],xmm1[0,1]
; SSE-64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[2,0,1,3]
; SSE-64-NEXT:    movups %xmm1, 624(%rsi)
; SSE-64-NEXT:    movups %xmm0, 608(%rsi)
; SSE-64-NEXT:    retq
;
; AVX-32-LABEL: PR15298:
; AVX-32:       # BB#0: # %L.entry
; AVX-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; AVX-32-NEXT:    vbroadcastss 304(%ecx), %xmm0
; AVX-32-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-32-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0],ymm0[1,2],ymm1[3,4,5,6,7]
; AVX-32-NEXT:    vmovups %ymm0, 608(%eax)
; AVX-32-NEXT:    vzeroupper
; AVX-32-NEXT:    retl
;
; AVX-64-LABEL: PR15298:
; AVX-64:       # BB#0: # %L.entry
; AVX-64-NEXT:    vbroadcastss 304(%rdi), %xmm0
; AVX-64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-64-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0],ymm0[1,2],ymm1[3,4,5,6,7]
; AVX-64-NEXT:    vmovups %ymm0, 608(%rsi)
; AVX-64-NEXT:    vzeroupper
; AVX-64-NEXT:    retq
L.entry:
  %0 = getelementptr inbounds <4 x float>, <4 x float>* %source, i32 19
  %1 = load <4 x float>, <4 x float>* %0, align 16
  %2 = extractelement <4 x float> %1, i32 0
  %3 = insertelement <8 x float> <float 0.000000e+00, float undef, float undef, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00>, float %2, i32 2
  %4 = insertelement <8 x float> %3, float %2, i32 1
  %5 = getelementptr <8 x float>, <8 x float>* %dest, i32 19
  store <8 x float> %4, <8 x float>* %5, align 4
  ret void
}
