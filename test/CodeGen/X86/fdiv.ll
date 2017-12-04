; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -enable-unsafe-fp-math | FileCheck %s

define double @exact(double %x) {
; Exact division by a constant converted to multiplication.
; CHECK-LABEL: exact:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulsd {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 2.0
  ret double %div
}

define double @inexact(double %x) {
; Inexact division by a constant converted to multiplication.
; CHECK-LABEL: inexact:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulsd {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0x41DFFFFFFFC00000
  ret double %div
}

define double @funky(double %x) {
; No conversion to multiplication if too funky.
; CHECK-LABEL: funky:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorpd %xmm1, %xmm1
; CHECK-NEXT:    divsd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0.0
  ret double %div
}

define double @denormal1(double %x) {
; Don't generate multiplication by a denormal.
; CHECK-LABEL: denormal1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    divsd {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0x7FD0000000000001
  ret double %div
}

define double @denormal2(double %x) {
; Don't generate multiplication by a denormal.
; CHECK-LABEL: denormal2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    divsd {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0x7FEFFFFFFFFFFFFF
  ret double %div
}

; Deleting the negates does not require unsafe-fp-math.

define float @double_negative(float %x, float %y) #0 {
; CHECK-LABEL: double_negative:
; CHECK:       # %bb.0:
; CHECK-NEXT:    divss %xmm1, %xmm0
; CHECK-NEXT:    retq
  %neg1 = fsub float -0.0, %x
  %neg2 = fsub float -0.0, %y
  %div = fdiv float %neg1, %neg2
  ret float %div
}

attributes #0 = { "unsafe-fp-math"="false" }

