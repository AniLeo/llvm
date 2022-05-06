; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define <4 x float> @foo(<4 x float>* %p) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps (%rdi), %xmm0
; CHECK-NEXT:    retq
  %t = load <4 x float>, <4 x float>* %p
  ret <4 x float> %t
}

define <2 x double> @bar(<2 x double>* %p) nounwind {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps (%rdi), %xmm0
; CHECK-NEXT:    retq
  %t = load <2 x double>, <2 x double>* %p
  ret <2 x double> %t
}
