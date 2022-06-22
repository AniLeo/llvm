; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define void @foo(ptr %p, <4 x float> %x) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movups %xmm0, (%rdi)
; CHECK-NEXT:    retq
  store <4 x float> %x, ptr %p, align 4
  ret void
}

define void @bar(ptr %p, <2 x double> %x) nounwind {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movups %xmm0, (%rdi)
; CHECK-NEXT:    retq
  store <2 x double> %x, ptr %p, align 8
  ret void
}
