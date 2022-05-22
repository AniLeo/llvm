; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

; abs(undef) should fold to 0 not undef.

declare i32 @llvm.abs.i32(i32, i1 immarg) #0

define i32 @abs(i32 %0) {
; CHECK-LABEL: abs:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %2 = call i32 @llvm.abs.i32(i32 undef, i1 false)
  ret i32 %2
}
