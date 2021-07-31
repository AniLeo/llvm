; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define void @_start() {
; CHECK-LABEL: _start:
; CHECK:       # %bb.0: # %Entry
; CHECK-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq -{{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    shrdq $2, %rcx, %rax
; CHECK-NEXT:    shrq $2, %rcx
; CHECK-NEXT:    leaq 1(,%rax,4), %rdx
; CHECK-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    shrdq $62, %rcx, %rax
; CHECK-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    orq $-2, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq $-1, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    retq
Entry:
  %y = alloca <3 x i129>, align 4
  %L = load <3 x i129>, <3 x i129>* %y
  %I1 = insertelement <3 x i129> %L, i129 340282366920938463463374607431768211455, i32 1
  store <3 x i129> %I1, <3 x i129>* %y
  ret void
}
