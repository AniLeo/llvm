; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin | FileCheck %s
; PR17338

@t1.global = internal global i64 -1, align 8

define i32 @t1() nounwind ssp {
; CHECK-LABEL: t1:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpl $0, _t1.global
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    retl
entry:
  %0 = load i64, i64* @t1.global, align 8
  %and = and i64 4294967295, %0
  %cmp = icmp sgt i64 %and, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}
