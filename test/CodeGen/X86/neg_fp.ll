; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=+sse4.1 | FileCheck %s

; Test that when we don't -enable-unsafe-fp-math, we don't do the optimization
; -0 - (A - B) to (B - A) because A==B, -0 != 0

define float @negfp(float %a, float %b) {
; CHECK-LABEL: negfp:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    subss {{[0-9]+}}(%esp), %xmm0
; CHECK-NEXT:    xorps {{\.LCPI.*}}, %xmm0
; CHECK-NEXT:    movss %xmm0, (%esp)
; CHECK-NEXT:    flds (%esp)
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
	%sub = fsub float %a, %b		; <float> [#uses=1]
	%neg = fsub float -0.000000e+00, %sub		; <float> [#uses=1]
	ret float %neg
}
