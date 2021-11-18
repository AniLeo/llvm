; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s --check-prefix=HAS-RAX
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+sse | FileCheck %s --check-prefix=HAS-RAX
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=-sse | FileCheck %s --check-prefix=NO-RAX

define void @foo() {
; HAS-RAX-LABEL: foo:
; HAS-RAX:       # %bb.0:
; HAS-RAX-NEXT:    movl $1, %edi
; HAS-RAX-NEXT:    xorl %eax, %eax
; HAS-RAX-NEXT:    jmp bar@PLT # TAILCALL
;
; NO-RAX-LABEL: foo:
; NO-RAX:       # %bb.0:
; NO-RAX-NEXT:    movl $1, %edi
; NO-RAX-NEXT:    jmp bar@PLT # TAILCALL
  tail call void (i32, ...) @bar(i32 1)
  ret void
}

define void @bar(i32, ...) nounwind {
; HAS-RAX-LABEL: bar:
; HAS-RAX:       # %bb.0:
; HAS-RAX-NEXT:    subq $56, %rsp
; HAS-RAX-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movq %rcx, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movq %r8, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movq %r9, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    testb %al, %al
; HAS-RAX-NEXT:    je .LBB1_2
; HAS-RAX-NEXT:  # %bb.1:
; HAS-RAX-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movaps %xmm1, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movaps %xmm2, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movaps %xmm3, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movaps %xmm4, -{{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movaps %xmm5, (%rsp)
; HAS-RAX-NEXT:    movaps %xmm6, {{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:    movaps %xmm7, {{[0-9]+}}(%rsp)
; HAS-RAX-NEXT:  .LBB1_2:
; HAS-RAX-NEXT:    leaq {{[0-9]+}}(%rsp), %rax
; HAS-RAX-NEXT:    movq %rax, 8
; HAS-RAX-NEXT:    leaq -{{[0-9]+}}(%rsp), %rax
; HAS-RAX-NEXT:    movq %rax, 16
; HAS-RAX-NEXT:    movl $8, 0
; HAS-RAX-NEXT:    movl $48, 4
; HAS-RAX-NEXT:    addq $56, %rsp
; HAS-RAX-NEXT:    retq
;
; NO-RAX-LABEL: bar:
; NO-RAX:       # %bb.0:
; NO-RAX-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; NO-RAX-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; NO-RAX-NEXT:    movq %rcx, -{{[0-9]+}}(%rsp)
; NO-RAX-NEXT:    movq %r8, -{{[0-9]+}}(%rsp)
; NO-RAX-NEXT:    movq %r9, -{{[0-9]+}}(%rsp)
; NO-RAX-NEXT:    leaq {{[0-9]+}}(%rsp), %rax
; NO-RAX-NEXT:    movq %rax, 8
; NO-RAX-NEXT:    leaq -{{[0-9]+}}(%rsp), %rax
; NO-RAX-NEXT:    movq %rax, 16
; NO-RAX-NEXT:    movl $8, 0
; NO-RAX-NEXT:    movl $48, 4
; NO-RAX-NEXT:    retq
  call void @llvm.va_start(i8* null)
  ret void
}

declare void @llvm.va_start(i8*)

!llvm.module.flags = !{!0}
!0 = !{i32 4, !"SkipRaxSetup", i32 1}
