; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64

define void @PR36250() {
; X86-LABEL: PR36250:
; X86:       # %bb.0:
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    roll %ecx
; X86-NEXT:    addl %eax, %eax
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    orl %edx, %edx
; X86-NEXT:    orl %ecx, %edx
; X86-NEXT:    orl %eax, %edx
; X86-NEXT:    orl %ecx, %edx
; X86-NEXT:    sete (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: PR36250:
; X64:       # %bb.0:
; X64-NEXT:    movq (%rax), %rax
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    rolq %rcx
; X64-NEXT:    addq %rax, %rax
; X64-NEXT:    movq %rcx, %rdx
; X64-NEXT:    orq %rdx, %rdx
; X64-NEXT:    orq %rax, %rdx
; X64-NEXT:    orq %rcx, %rdx
; X64-NEXT:    sete (%rax)
; X64-NEXT:    retq
   %1 = load i448, i448* undef
   %2 = sub i448 0, %1
   %3 = icmp eq i448 %1, %2
   store i1 %3, i1* undef
   ret void
}
