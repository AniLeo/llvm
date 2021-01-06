; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=+lzcnt | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-- -mattr=+lzcnt | FileCheck %s --check-prefix=X64

define i1 @lshr_ctlz_cmpeq_one_i64(i64 %in) {
; X86-LABEL: lshr_ctlz_cmpeq_one_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: lshr_ctlz_cmpeq_one_i64:
; X64:       # %bb.0:
; X64-NEXT:    testq %rdi, %rdi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 0)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp eq i64 %lshr, 1
  ret i1 %icmp
}

define i1 @lshr_ctlz_undef_cmpeq_one_i64(i64 %in) {
; X86-LABEL: lshr_ctlz_undef_cmpeq_one_i64:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    jne .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    lzcntl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    addl $32, %eax
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    testb $64, %al
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: lshr_ctlz_undef_cmpeq_one_i64:
; X64:       # %bb.0:
; X64-NEXT:    lzcntq %rdi, %rax
; X64-NEXT:    shrq $6, %rax
; X64-NEXT:    cmpl $1, %eax
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 -1)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp eq i64 %lshr, 1
  ret i1 %icmp
}

define i1 @lshr_ctlz_cmpne_zero_i64(i64 %in) {
; X86-LABEL: lshr_ctlz_cmpne_zero_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: lshr_ctlz_cmpne_zero_i64:
; X64:       # %bb.0:
; X64-NEXT:    testq %rdi, %rdi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 0)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp ne i64 %lshr, 0
  ret i1 %icmp
}

define i1 @lshr_ctlz_undef_cmpne_zero_i64(i64 %in) {
; X86-LABEL: lshr_ctlz_undef_cmpne_zero_i64:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    jne .LBB3_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    lzcntl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    addl $32, %eax
; X86-NEXT:  .LBB3_2:
; X86-NEXT:    testb $64, %al
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: lshr_ctlz_undef_cmpne_zero_i64:
; X64:       # %bb.0:
; X64-NEXT:    lzcntq %rdi, %rax
; X64-NEXT:    testb $64, %al
; X64-NEXT:    setne %al
; X64-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 -1)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp ne i64 %lshr, 0
  ret i1 %icmp
}

define <2 x i64> @lshr_ctlz_cmpeq_zero_v2i64(<2 x i64> %in) {
; X86-LABEL: lshr_ctlz_cmpeq_zero_v2i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    orl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    setne %cl
; X86-NEXT:    negl %ecx
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    orl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    setne %dl
; X86-NEXT:    negl %edx
; X86-NEXT:    movl %edx, 12(%eax)
; X86-NEXT:    movl %edx, 8(%eax)
; X86-NEXT:    movl %ecx, 4(%eax)
; X86-NEXT:    movl %ecx, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl $4
;
; X64-LABEL: lshr_ctlz_cmpeq_zero_v2i64:
; X64:       # %bb.0:
; X64-NEXT:    pxor %xmm1, %xmm1
; X64-NEXT:    pcmpeqd %xmm0, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,0,3,2]
; X64-NEXT:    pand %xmm1, %xmm2
; X64-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-NEXT:    pxor %xmm2, %xmm0
; X64-NEXT:    retq
  %ctlz = call <2 x i64> @llvm.ctlz.v2i64(<2 x i64> %in, i1 0)
  %lshr = lshr <2 x i64> %ctlz, <i64 6, i64 6>
  %icmp = icmp eq <2 x i64> %lshr, zeroinitializer
  %sext = sext <2 x i1> %icmp to <2 x i64>
  ret <2 x i64> %sext
}

define <2 x i64> @lshr_ctlz_cmpne_zero_v2i64(<2 x i64> %in) {
; X86-LABEL: lshr_ctlz_cmpne_zero_v2i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    orl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    sete %cl
; X86-NEXT:    negl %ecx
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    orl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    sete %dl
; X86-NEXT:    negl %edx
; X86-NEXT:    movl %edx, 12(%eax)
; X86-NEXT:    movl %edx, 8(%eax)
; X86-NEXT:    movl %ecx, 4(%eax)
; X86-NEXT:    movl %ecx, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl $4
;
; X64-LABEL: lshr_ctlz_cmpne_zero_v2i64:
; X64:       # %bb.0:
; X64-NEXT:    pxor %xmm1, %xmm1
; X64-NEXT:    pcmpeqd %xmm0, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,0,3,2]
; X64-NEXT:    pand %xmm1, %xmm0
; X64-NEXT:    retq
  %ctlz = call <2 x i64> @llvm.ctlz.v2i64(<2 x i64> %in, i1 0)
  %lshr = lshr <2 x i64> %ctlz, <i64 6, i64 6>
  %icmp = icmp ne <2 x i64> %lshr, zeroinitializer
  %sext = sext <2 x i1> %icmp to <2 x i64>
  ret <2 x i64> %sext
}

declare i64 @llvm.ctlz.i64(i64, i1)
declare <2 x i64> @llvm.ctlz.v2i64(<2 x i64>, i1)
