; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686 -mattr=cmov | FileCheck %s --check-prefix=X86

declare  i4  @llvm.umul.fix.i4   (i4,  i4, i32)
declare  i32 @llvm.umul.fix.i32  (i32, i32, i32)
declare  i64 @llvm.umul.fix.i64  (i64, i64, i32)
declare  <4 x i32> @llvm.umul.fix.v4i32(<4 x i32>, <4 x i32>, i32)

define i32 @func(i32 %x, i32 %y) nounwind {
; X64-LABEL: func:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    shrq $32, %rax
; X64-NEXT:    shldl $30, %ecx, %eax
; X64-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-NEXT:    retq
;
; X86-LABEL: func:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    shrdl $2, %edx, %eax
; X86-NEXT:    retl
  %tmp = call i32 @llvm.umul.fix.i32(i32 %x, i32 %y, i32 2)
  ret i32 %tmp
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; X64-LABEL: func2:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    mulq %rsi
; X64-NEXT:    shrdq $2, %rdx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    mull %ebp
; X86-NEXT:    movl %eax, %esi
; X86-NEXT:    addl %edx, %ebx
; X86-NEXT:    adcl $0, %edi
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %ebp
; X86-NEXT:    addl %ebx, %eax
; X86-NEXT:    adcl %edi, %edx
; X86-NEXT:    imull {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    addl %ecx, %edx
; X86-NEXT:    shldl $30, %eax, %edx
; X86-NEXT:    shldl $30, %esi, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.umul.fix.i64(i64 %x, i64 %y, i32 2)
  ret i64 %tmp
}

define i4 @func3(i4 %x, i4 %y) nounwind {
; X64-LABEL: func3:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $15, %al
; X64-NEXT:    andb $15, %sil
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    mulb %sil
; X64-NEXT:    shrb $2, %al
; X64-NEXT:    retq
;
; X86-LABEL: func3:
; X86:       # %bb.0:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    andb $15, %al
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andb $15, %cl
; X86-NEXT:    mulb %cl
; X86-NEXT:    shrb $2, %al
; X86-NEXT:    retl
  %tmp = call i4 @llvm.umul.fix.i4(i4 %x, i4 %y, i32 2)
  ret i4 %tmp
}

define <4 x i32> @vec(<4 x i32> %x, <4 x i32> %y) nounwind {
; X64-LABEL: vec:
; X64:       # %bb.0:
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[0,2,2,3]
; X64-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; X64-NEXT:    pmuludq %xmm2, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[0,2,2,3]
; X64-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X64-NEXT:    psrld $2, %xmm3
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; X64-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; X64-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X64-NEXT:    pslld $30, %xmm0
; X64-NEXT:    por %xmm3, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: vec:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shldl $30, %eax, %esi
; X86-NEXT:    movl %ebx, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %ebx
; X86-NEXT:    shldl $30, %eax, %ebx
; X86-NEXT:    movl %ebp, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %ebp
; X86-NEXT:    shldl $30, %eax, %ebp
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    shldl $30, %eax, %edx
; X86-NEXT:    movl %edx, 12(%ecx)
; X86-NEXT:    movl %ebp, 8(%ecx)
; X86-NEXT:    movl %ebx, 4(%ecx)
; X86-NEXT:    movl %esi, (%ecx)
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
  %tmp = call <4 x i32> @llvm.umul.fix.v4i32(<4 x i32> %x, <4 x i32> %y, i32 2)
  ret <4 x i32> %tmp
}

; These result in regular integer multiplication
define i32 @func4(i32 %x, i32 %y) nounwind {
; X64-LABEL: func4:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    imull %esi, %eax
; X64-NEXT:    retq
;
; X86-LABEL: func4:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
  %tmp = call i32 @llvm.umul.fix.i32(i32 %x, i32 %y, i32 0)
  ret i32 %tmp
}

define i64 @func5(i64 %x, i64 %y) nounwind {
; X64-LABEL: func5:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    imulq %rsi, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func5:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %esi
; X86-NEXT:    imull {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    addl %ecx, %edx
; X86-NEXT:    imull {{[0-9]+}}(%esp), %esi
; X86-NEXT:    addl %esi, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i64 @llvm.umul.fix.i64(i64 %x, i64 %y, i32 0)
  ret i64 %tmp
}

define i4 @func6(i4 %x, i4 %y) nounwind {
; X64-LABEL: func6:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $15, %al
; X64-NEXT:    andb $15, %sil
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    mulb %sil
; X64-NEXT:    retq
;
; X86-LABEL: func6:
; X86:       # %bb.0:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    andb $15, %al
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andb $15, %cl
; X86-NEXT:    mulb %cl
; X86-NEXT:    retl
  %tmp = call i4 @llvm.umul.fix.i4(i4 %x, i4 %y, i32 0)
  ret i4 %tmp
}

define <4 x i32> @vec2(<4 x i32> %x, <4 x i32> %y) nounwind {
; X64-LABEL: vec2:
; X64:       # %bb.0:
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; X64-NEXT:    pmuludq %xmm2, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X64-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X64-NEXT:    retq
;
; X86-LABEL: vec2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    imull {{[0-9]+}}(%esp), %edi
; X86-NEXT:    imull {{[0-9]+}}(%esp), %esi
; X86-NEXT:    imull {{[0-9]+}}(%esp), %edx
; X86-NEXT:    imull {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, 12(%eax)
; X86-NEXT:    movl %edx, 8(%eax)
; X86-NEXT:    movl %esi, 4(%eax)
; X86-NEXT:    movl %edi, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
  %tmp = call <4 x i32> @llvm.umul.fix.v4i32(<4 x i32> %x, <4 x i32> %y, i32 0)
  ret <4 x i32> %tmp
}

define i64 @func7(i64 %x, i64 %y) nounwind {
; X64-LABEL: func7:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    mulq %rsi
; X64-NEXT:    shrdq $32, %rdx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func7:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    mull %ebp
; X86-NEXT:    addl %edx, %ebx
; X86-NEXT:    adcl $0, %esi
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %ebp
; X86-NEXT:    addl %ebx, %eax
; X86-NEXT:    adcl %esi, %edx
; X86-NEXT:    imull {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    addl %ecx, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.umul.fix.i64(i64 %x, i64 %y, i32 32)
  ret i64 %tmp
}

define i64 @func8(i64 %x, i64 %y) nounwind {
; X64-LABEL: func8:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    mulq %rsi
; X64-NEXT:    shrdq $63, %rdx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func8:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    mull %ebp
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    movl %eax, %edi
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    mull %ebx
; X86-NEXT:    addl %edx, %edi
; X86-NEXT:    adcl $0, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    mull %ebp
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    movl %eax, %ebp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    mull %ebx
; X86-NEXT:    addl %edi, %eax
; X86-NEXT:    adcl %edx, %ecx
; X86-NEXT:    adcl $0, %esi
; X86-NEXT:    addl %ebp, %ecx
; X86-NEXT:    adcl $0, %esi
; X86-NEXT:    shldl $1, %ecx, %esi
; X86-NEXT:    shrdl $31, %ecx, %eax
; X86-NEXT:    movl %esi, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.umul.fix.i64(i64 %x, i64 %y, i32 63)
  ret i64 %tmp
}

define i64 @func9(i64 %x, i64 %y) nounwind {
; X64-LABEL: func9:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    mulq %rsi
; X64-NEXT:    movq %rdx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func9:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    mull %esi
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %ebp
; X86-NEXT:    addl %ebx, %ebp
; X86-NEXT:    adcl $0, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    mull %esi
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    addl %ebp, %eax
; X86-NEXT:    adcl %edx, %ecx
; X86-NEXT:    adcl $0, %edi
; X86-NEXT:    addl %ebx, %ecx
; X86-NEXT:    adcl $0, %edi
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    movl %edi, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.umul.fix.i64(i64 %x, i64 %y, i32 64)
  ret i64 %tmp
}
