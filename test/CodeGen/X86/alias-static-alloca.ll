; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux-gnu | FileCheck %s

; We should be able to bypass the load values to their corresponding
; stores here.

define i32 @foo(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    movl %esi, -8(%rsp)
; CHECK-NEXT:    movl %ecx, -16(%rsp)
; CHECK-NEXT:    movl %edi, -4(%rsp)
; CHECK-NEXT:    movl %edx, -12(%rsp)
; CHECK-NEXT:    leal (%rdi,%rsi), %eax
; CHECK-NEXT:    addl %edx, %eax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    retq
entry:
  %a0 = alloca i32
  %a1 = alloca i32
  %a2 = alloca i32
  %a3 = alloca i32
  store i32 %b, i32* %a1
  store i32 %d, i32* %a3
  store i32 %a, i32* %a0
  store i32 %c, i32* %a2
  %l0 = load i32, i32* %a0
  %l1 = load i32, i32* %a1
  %l2 = load i32, i32* %a2
  %l3 = load i32, i32* %a3
  %add0 = add nsw i32 %l0, %l1
  %add1 = add nsw i32 %add0, %l2
  %add2 = add nsw i32 %add1, %l3
  ret i32 %add2
}
