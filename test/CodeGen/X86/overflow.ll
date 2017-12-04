; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X64

define i128 @mulhioverflow(i64 %a, i64 %b, i64 %c) nounwind {
; X32-LABEL: mulhioverflow:
; X32:       # %bb.0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    pushl %ebx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    mull %ebp
; X32-NEXT:    movl %edx, %ebx
; X32-NEXT:    movl %esi, %eax
; X32-NEXT:    mull %ebp
; X32-NEXT:    movl %edx, %ebp
; X32-NEXT:    movl %eax, %esi
; X32-NEXT:    addl %ebx, %esi
; X32-NEXT:    adcl $0, %ebp
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    mull %edi
; X32-NEXT:    movl %edx, %ebx
; X32-NEXT:    addl %esi, %eax
; X32-NEXT:    adcl %ebp, %ebx
; X32-NEXT:    setb %al
; X32-NEXT:    movzbl %al, %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    mull %edi
; X32-NEXT:    movl %edx, %esi
; X32-NEXT:    movl %eax, %ebp
; X32-NEXT:    addl %ebx, %ebp
; X32-NEXT:    adcl %ecx, %esi
; X32-NEXT:    xorl %ecx, %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    mull %ecx
; X32-NEXT:    movl %edx, %edi
; X32-NEXT:    movl %eax, %ebx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    mull %ecx
; X32-NEXT:    addl %ebx, %eax
; X32-NEXT:    adcl %edi, %edx
; X32-NEXT:    addl %ebp, %eax
; X32-NEXT:    adcl %esi, %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    andl $1, %ecx
; X32-NEXT:    addl %eax, %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %ecx, (%eax)
; X32-NEXT:    adcl $0, %edx
; X32-NEXT:    movl %edx, 4(%eax)
; X32-NEXT:    setb %cl
; X32-NEXT:    movzbl %cl, %ecx
; X32-NEXT:    movl %ecx, 8(%eax)
; X32-NEXT:    movl $0, 12(%eax)
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    popl %ebx
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl $4
;
; X64-LABEL: mulhioverflow:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdx, %rcx
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    mulq %rsi
; X64-NEXT:    andl $1, %ecx
; X64-NEXT:    leaq (%rcx,%rdx), %rax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    retq
  %1 = zext i64 %a to i128
  %2 = zext i64 %b to i128
  %3 = mul i128 %1, %2
  %4 = lshr i128 %3, 64
  %5 = and i64 %c, 1
  %6 = zext i64 %5 to i128
  %7 = add i128 %4, %6
  ret i128 %7
}
