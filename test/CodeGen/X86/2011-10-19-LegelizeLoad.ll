; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=corei7 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i8:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.anon = type { <2 x i8> }

@i = global <2 x i8> <i8 150, i8 100>, align 8
@j = global <2 x i8> <i8 10, i8 13>, align 8
@res = common global %union.anon zeroinitializer, align 8

; Make sure we load the constants i and j starting offset zero.
; Also make sure that we sign-extend it.
; Based on /gcc-4_2-testsuite/src/gcc.c-torture/execute/pr23135.c

define i32 @main() nounwind uwtable {
; CHECK-LABEL: main:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq {{.*}}(%rip), %rsi
; CHECK-NEXT:    movq {{.*}}(%rip), %rax
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    shrq $8, %rdx
; CHECK-NEXT:    movsbl %al, %ecx
; CHECK-NEXT:    shrq $8, %rax
; CHECK-NEXT:    cbtw
; CHECK-NEXT:    idivb %dl
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    idivb %sil
; CHECK-NEXT:    movzbl %dl, %ecx
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    pinsrb $1, %ecx, %xmm0
; CHECK-NEXT:    pextrw $0, %xmm0, {{.*}}(%rip)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
entry:
  %0 = load <2 x i8>, <2 x i8>* @i, align 8
  %1 = load <2 x i8>, <2 x i8>* @j, align 8
  %div = sdiv <2 x i8> %1, %0
  store <2 x i8> %div, <2 x i8>* getelementptr inbounds (%union.anon, %union.anon* @res, i32 0, i32 0), align 8
  ret i32 0
}
