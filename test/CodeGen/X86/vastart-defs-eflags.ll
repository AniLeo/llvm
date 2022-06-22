; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc %s -o - | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.10.0"

; Check that vastart handling doesn't get between testb and je for the branch.
define i32 @check_flag(i32 %flags, ...) nounwind {
; CHECK-LABEL: check_flag:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    subq $56, %rsp
; CHECK-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rcx, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %r8, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %r9, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je LBB0_4
; CHECK-NEXT:  ## %bb.3: ## %entry
; CHECK-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm1, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm2, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm3, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm4, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm5, (%rsp)
; CHECK-NEXT:    movaps %xmm6, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movaps %xmm7, {{[0-9]+}}(%rsp)
; CHECK-NEXT:  LBB0_4: ## %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl $512, %edi ## imm = 0x200
; CHECK-NEXT:    je LBB0_2
; CHECK-NEXT:  ## %bb.1: ## %if.then
; CHECK-NEXT:    leaq -{{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq %rax, 16
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq %rax, 8
; CHECK-NEXT:    movl $48, 4
; CHECK-NEXT:    movl $8, 0
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:  LBB0_2: ## %if.end
; CHECK-NEXT:    addq $56, %rsp
; CHECK-NEXT:    retq
entry:
  %and = and i32 %flags, 512
  %tobool = icmp eq i32 %and, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @llvm.va_start(ptr null)
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %hasflag = phi i32 [ 1, %if.then ], [ 0, %entry ]
  ret i32 %hasflag
}

declare void @llvm.va_start(ptr) nounwind
