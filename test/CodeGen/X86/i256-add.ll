; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefix=X64

define void @add(i256* %p, i256* %q) nounwind {
; X32-LABEL: add:
; X32:       # %bb.0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    pushl %ebx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $8, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl 28(%ecx), %eax
; X32-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X32-NEXT:    movl 24(%ecx), %eax
; X32-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X32-NEXT:    movl 20(%ecx), %esi
; X32-NEXT:    movl 16(%ecx), %edi
; X32-NEXT:    movl 12(%ecx), %ebx
; X32-NEXT:    movl 8(%ecx), %ebp
; X32-NEXT:    movl (%ecx), %edx
; X32-NEXT:    movl 4(%ecx), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    addl %edx, (%eax)
; X32-NEXT:    adcl %ecx, 4(%eax)
; X32-NEXT:    adcl %ebp, 8(%eax)
; X32-NEXT:    adcl %ebx, 12(%eax)
; X32-NEXT:    adcl %edi, 16(%eax)
; X32-NEXT:    adcl %esi, 20(%eax)
; X32-NEXT:    movl (%esp), %ecx # 4-byte Reload
; X32-NEXT:    adcl %ecx, 24(%eax)
; X32-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X32-NEXT:    adcl %ecx, 28(%eax)
; X32-NEXT:    addl $8, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    popl %ebx
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: add:
; X64:       # %bb.0:
; X64-NEXT:    movq 24(%rsi), %rax
; X64-NEXT:    movq 16(%rsi), %rcx
; X64-NEXT:    movq (%rsi), %rdx
; X64-NEXT:    movq 8(%rsi), %rsi
; X64-NEXT:    addq %rdx, (%rdi)
; X64-NEXT:    adcq %rsi, 8(%rdi)
; X64-NEXT:    adcq %rcx, 16(%rdi)
; X64-NEXT:    adcq %rax, 24(%rdi)
; X64-NEXT:    retq
  %a = load i256, i256* %p
  %b = load i256, i256* %q
  %c = add i256 %a, %b
  store i256 %c, i256* %p
  ret void
}
define void @sub(i256* %p, i256* %q) nounwind {
; X32-LABEL: sub:
; X32:       # %bb.0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    pushl %ebx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $8, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl 28(%ecx), %eax
; X32-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X32-NEXT:    movl 24(%ecx), %eax
; X32-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X32-NEXT:    movl 20(%ecx), %esi
; X32-NEXT:    movl 16(%ecx), %edi
; X32-NEXT:    movl 12(%ecx), %ebx
; X32-NEXT:    movl 8(%ecx), %ebp
; X32-NEXT:    movl (%ecx), %edx
; X32-NEXT:    movl 4(%ecx), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    subl %edx, (%eax)
; X32-NEXT:    sbbl %ecx, 4(%eax)
; X32-NEXT:    sbbl %ebp, 8(%eax)
; X32-NEXT:    sbbl %ebx, 12(%eax)
; X32-NEXT:    sbbl %edi, 16(%eax)
; X32-NEXT:    sbbl %esi, 20(%eax)
; X32-NEXT:    movl (%esp), %ecx # 4-byte Reload
; X32-NEXT:    sbbl %ecx, 24(%eax)
; X32-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X32-NEXT:    sbbl %ecx, 28(%eax)
; X32-NEXT:    addl $8, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    popl %ebx
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: sub:
; X64:       # %bb.0:
; X64-NEXT:    movq 24(%rsi), %rax
; X64-NEXT:    movq 16(%rsi), %rcx
; X64-NEXT:    movq (%rsi), %rdx
; X64-NEXT:    movq 8(%rsi), %rsi
; X64-NEXT:    subq %rdx, (%rdi)
; X64-NEXT:    sbbq %rsi, 8(%rdi)
; X64-NEXT:    sbbq %rcx, 16(%rdi)
; X64-NEXT:    sbbq %rax, 24(%rdi)
; X64-NEXT:    retq
  %a = load i256, i256* %p
  %b = load i256, i256* %q
  %c = sub i256 %a, %b
  store i256 %c, i256* %p
  ret void
}
