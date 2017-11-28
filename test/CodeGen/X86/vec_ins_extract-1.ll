; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X64

; Inserts and extracts with variable indices must be lowered
; to memory accesses.

define i32 @t0(i32 inreg %t7, <4 x i32> inreg %t8) nounwind {
; X32-LABEL: t0:
; X32:       # BB#0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-16, %esp
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    andl $3, %eax
; X32-NEXT:    movaps %xmm0, (%esp)
; X32-NEXT:    movl $76, (%esp,%eax,4)
; X32-NEXT:    movl (%esp), %eax
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: t0:
; X64:       # BB#0:
; X64-NEXT:    # kill: %edi<def> %edi<kill> %rdi<def>
; X64-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-NEXT:    andl $3, %edi
; X64-NEXT:    movl $76, -24(%rsp,%rdi,4)
; X64-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-NEXT:    retq
  %t13 = insertelement <4 x i32> %t8, i32 76, i32 %t7
  %t9 = extractelement <4 x i32> %t13, i32 0
  ret i32 %t9
}

define i32 @t1(i32 inreg %t7, <4 x i32> inreg %t8) nounwind {
; X32-LABEL: t1:
; X32:       # BB#0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-16, %esp
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    andl $3, %eax
; X32-NEXT:    movl $76, %ecx
; X32-NEXT:    pinsrd $0, %ecx, %xmm0
; X32-NEXT:    movdqa %xmm0, (%esp)
; X32-NEXT:    movl (%esp,%eax,4), %eax
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: t1:
; X64:       # BB#0:
; X64-NEXT:    # kill: %edi<def> %edi<kill> %rdi<def>
; X64-NEXT:    movl $76, %eax
; X64-NEXT:    pinsrd $0, %eax, %xmm0
; X64-NEXT:    movdqa %xmm0, -{{[0-9]+}}(%rsp)
; X64-NEXT:    andl $3, %edi
; X64-NEXT:    movl -24(%rsp,%rdi,4), %eax
; X64-NEXT:    retq
  %t13 = insertelement <4 x i32> %t8, i32 76, i32 0
  %t9 = extractelement <4 x i32> %t13, i32 %t7
  ret i32 %t9
}

define <4 x i32> @t2(i32 inreg %t7, <4 x i32> inreg %t8) nounwind {
; X32-LABEL: t2:
; X32:       # BB#0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-16, %esp
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    andl $3, %eax
; X32-NEXT:    movdqa %xmm0, (%esp)
; X32-NEXT:    pinsrd $0, (%esp,%eax,4), %xmm0
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: t2:
; X64:       # BB#0:
; X64-NEXT:    # kill: %edi<def> %edi<kill> %rdi<def>
; X64-NEXT:    movdqa %xmm0, -{{[0-9]+}}(%rsp)
; X64-NEXT:    andl $3, %edi
; X64-NEXT:    pinsrd $0, -24(%rsp,%rdi,4), %xmm0
; X64-NEXT:    retq
  %t9 = extractelement <4 x i32> %t8, i32 %t7
  %t13 = insertelement <4 x i32> %t8, i32 %t9, i32 0
  ret <4 x i32> %t13
}

define <4 x i32> @t3(i32 inreg %t7, <4 x i32> inreg %t8) nounwind {
; X32-LABEL: t3:
; X32:       # BB#0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-16, %esp
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    andl $3, %eax
; X32-NEXT:    movaps %xmm0, (%esp)
; X32-NEXT:    movss %xmm0, (%esp,%eax,4)
; X32-NEXT:    movaps (%esp), %xmm0
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: t3:
; X64:       # BB#0:
; X64-NEXT:    # kill: %edi<def> %edi<kill> %rdi<def>
; X64-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-NEXT:    andl $3, %edi
; X64-NEXT:    movss %xmm0, -24(%rsp,%rdi,4)
; X64-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; X64-NEXT:    retq
  %t9 = extractelement <4 x i32> %t8, i32 0
  %t13 = insertelement <4 x i32> %t8, i32 %t9, i32 %t7
  ret <4 x i32> %t13
}
