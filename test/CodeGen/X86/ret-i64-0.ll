; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

define i64 @foo() nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    retl
  ret i64 0
}
