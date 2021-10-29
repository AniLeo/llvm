; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64 < %s | FileCheck %s

; Check the prolog won't be sunk across the save of CSRs.
define void @reduce(i32, i32, i32, i32, i32, i32, ...) nounwind {
; CHECK-LABEL: reduce:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je .LBB0_4
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm1, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm2, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm3, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm4, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm5, (%rsp)
; CHECK-NEXT:    movaps %xmm6, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm7, {{[0-9]+}}(%rsp)
; CHECK-NEXT:  .LBB0_4:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    subq $56, %rsp
; CHECK-NEXT:    leaq -{{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq %rax, 16
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq %rax, 8
; CHECK-NEXT:    movl $48, 4
; CHECK-NEXT:    movl $48, 0
; CHECK-NEXT:    addq $56, %rsp
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    retq
  br i1 undef, label %8, label %7

7:                                                ; preds = %6
  call void @llvm.va_start(i8* null)
  br label %8

8:                                                ; preds = %7, %6
  ret void
}

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)
