; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define i64 @foo(i64 %x, i64 %y) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bsrq %rdi, %rax
; CHECK-NEXT:    xorq $64, %rax
; CHECK-NEXT:    bsrq %rsi, %rcx
; CHECK-NEXT:    cmoveq %rax, %rcx
; CHECK-NEXT:    movl $63, %eax
; CHECK-NEXT:    subq %rcx, %rax
; CHECK-NEXT:    retq
  %1 = tail call i64 @llvm.ctlz.i64(i64 %x, i1 true)
  %2 = xor i64 %1, 127
  %3 = tail call i64 @llvm.ctlz.i64(i64 %y, i1 true)
  %4 = xor i64 %3, 63
  %5 = icmp eq i64 %y, 0
  %6 = select i1 %5, i64 %2, i64 %4
  %7 = sub nsw i64 63, %6
  ret i64 %7
}

declare i64 @llvm.ctlz.i64(i64, i1)
