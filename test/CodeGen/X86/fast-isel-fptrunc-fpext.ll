; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 -fast-isel -fast-isel-abort=1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx -fast-isel -fast-isel-abort=1 | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -fast-isel -fast-isel-abort=1 | FileCheck %s --check-prefix=AVX
;
; Verify that fast-isel doesn't select legacy SSE instructions on targets that
; feature AVX.
;
; Test cases are obtained from the following code snippet:
; ///
; double single_to_double_rr(float x) {
;   return (double)x;
; }
; float double_to_single_rr(double x) {
;   return (float)x;
; }
; double single_to_double_rm(ptr x) {
;   return (double)*x;
; }
; float double_to_single_rm(ptr x) {
;   return (float)*x;
; }
; ///

define double @single_to_double_rr(float %x) {
; SSE-LABEL: single_to_double_rr:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    cvtss2sd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: single_to_double_rr:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vcvtss2sd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %conv = fpext float %x to double
  ret double %conv
}

define float @double_to_single_rr(double %x) {
; SSE-LABEL: double_to_single_rr:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    cvtsd2ss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: double_to_single_rr:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vcvtsd2ss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %conv = fptrunc double %x to float
  ret float %conv
}

define double @single_to_double_rm(ptr %x) {
; SSE-LABEL: single_to_double_rm:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    cvtss2sd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: single_to_double_rm:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vcvtss2sd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %0 = load float, ptr %x, align 4
  %conv = fpext float %0 to double
  ret double %conv
}

define double @single_to_double_rm_optsize(ptr %x) optsize {
; SSE-LABEL: single_to_double_rm_optsize:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    cvtss2sd (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: single_to_double_rm_optsize:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vcvtss2sd (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %0 = load float, ptr %x, align 4
  %conv = fpext float %0 to double
  ret double %conv
}

define float @double_to_single_rm(ptr %x) {
; SSE-LABEL: double_to_single_rm:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    cvtsd2ss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: double_to_single_rm:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vcvtsd2ss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %0 = load double, ptr %x, align 8
  %conv = fptrunc double %0 to float
  ret float %conv
}

define float @double_to_single_rm_optsize(ptr %x) optsize {
; SSE-LABEL: double_to_single_rm_optsize:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    cvtsd2ss (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: double_to_single_rm_optsize:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vcvtsd2ss (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %0 = load double, ptr %x, align 8
  %conv = fptrunc double %0 to float
  ret float %conv
}
