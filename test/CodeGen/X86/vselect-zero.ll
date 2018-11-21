; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2   | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx    | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2   | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

; PR28925

define <4 x i32> @test1(<4 x i1> %cond, <4 x i32> %x) {
; SSE-LABEL: test1:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $31, %xmm0
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    pandn %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX-NEXT:    vpandn %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %r = select <4 x i1> %cond, <4 x i32> zeroinitializer, <4 x i32> %x
  ret <4 x i32> %r
}

define <4 x i32> @test2(<4 x float> %a, <4 x float> %b, <4 x i32> %x) {
; SSE-LABEL: test2:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpneqps %xmm1, %xmm0
; SSE-NEXT:    andps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test2:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpneqps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq <4 x float> %a, %b
  %r = select <4 x i1> %cond, <4 x i32> zeroinitializer, <4 x i32> %x
  ret <4 x i32> %r
}

define float @fsel_zero_false_val(float %a, float %b, float %x) {
; SSE-LABEL: fsel_zero_false_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqss %xmm1, %xmm0
; SSE-NEXT:    andps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_zero_false_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq float %a, %b
  %r = select i1 %cond, float %x, float 0.0
  ret float %r
}

define float @fsel_zero_true_val(float %a, float %b, float %x) {
; SSE-LABEL: fsel_zero_true_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqss %xmm1, %xmm0
; SSE-NEXT:    andnps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_zero_true_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vandnps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq float %a, %b
  %r = select i1 %cond, float 0.0, float %x
  ret float %r
}

define double @fsel_nonzero_false_val(double %x, double %y, double %z) {
; SSE-LABEL: fsel_nonzero_false_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqsd %xmm1, %xmm0
; SSE-NEXT:    andpd %xmm0, %xmm2
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    andnpd %xmm1, %xmm0
; SSE-NEXT:    orpd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_nonzero_false_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vandpd %xmm2, %xmm0, %xmm1
; AVX-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; AVX-NEXT:    vandnpd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vorpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq double %x, %y
  %r = select i1 %cond, double %z, double 42.0
  ret double %r
}

define double @fsel_nonzero_true_val(double %x, double %y, double %z) {
; SSE-LABEL: fsel_nonzero_true_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqsd %xmm1, %xmm0
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    andpd %xmm0, %xmm1
; SSE-NEXT:    andnpd %xmm2, %xmm0
; SSE-NEXT:    orpd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_nonzero_true_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vandpd %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vandnpd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vorpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq double %x, %y
  %r = select i1 %cond, double 42.0, double %z
  ret double %r
}

