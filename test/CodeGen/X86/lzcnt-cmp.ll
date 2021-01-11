; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s --check-prefixes=X86,X86-BSR
; RUN: llc < %s -mtriple=i686-- -mattr=+lzcnt | FileCheck %s --check-prefixes=X86,X86-LZCNT
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s --check-prefixes=X64,X64-BSR
; RUN: llc < %s -mtriple=x86_64-- -mattr=+lzcnt | FileCheck %s --check-prefixes=X64,X64-LZCNT

define i1 @lshr_ctlz_cmpeq_one_i64(i64 %in) nounwind {
; X86-LABEL: lshr_ctlz_cmpeq_one_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-BSR-LABEL: lshr_ctlz_cmpeq_one_i64:
; X64-BSR:       # %bb.0:
; X64-BSR-NEXT:    testq %rdi, %rdi
; X64-BSR-NEXT:    je .LBB0_1
; X64-BSR-NEXT:  # %bb.2: # %cond.false
; X64-BSR-NEXT:    bsrq %rdi, %rax
; X64-BSR-NEXT:    xorq $63, %rax
; X64-BSR-NEXT:    jmp .LBB0_3
; X64-BSR-NEXT:  .LBB0_1:
; X64-BSR-NEXT:    movl $64, %eax
; X64-BSR-NEXT:  .LBB0_3: # %cond.end
; X64-BSR-NEXT:    shrq $6, %rax
; X64-BSR-NEXT:    cmpq $1, %rax
; X64-BSR-NEXT:    sete %al
; X64-BSR-NEXT:    retq
;
; X64-LZCNT-LABEL: lshr_ctlz_cmpeq_one_i64:
; X64-LZCNT:       # %bb.0:
; X64-LZCNT-NEXT:    testq %rdi, %rdi
; X64-LZCNT-NEXT:    sete %al
; X64-LZCNT-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 0)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp eq i64 %lshr, 1
  ret i1 %icmp
}

define i1 @lshr_ctlz_undef_cmpeq_one_i64(i64 %in) nounwind {
; X86-BSR-LABEL: lshr_ctlz_undef_cmpeq_one_i64:
; X86-BSR:       # %bb.0:
; X86-BSR-NEXT:    xorl %eax, %eax
; X86-BSR-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-BSR-NEXT:    jne .LBB1_2
; X86-BSR-NEXT:  # %bb.1:
; X86-BSR-NEXT:    bsrl {{[0-9]+}}(%esp), %eax
; X86-BSR-NEXT:    xorl $31, %eax
; X86-BSR-NEXT:    addl $32, %eax
; X86-BSR-NEXT:  .LBB1_2:
; X86-BSR-NEXT:    testl $-64, %eax
; X86-BSR-NEXT:    setne %al
; X86-BSR-NEXT:    retl
;
; X86-LZCNT-LABEL: lshr_ctlz_undef_cmpeq_one_i64:
; X86-LZCNT:       # %bb.0:
; X86-LZCNT-NEXT:    xorl %eax, %eax
; X86-LZCNT-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-LZCNT-NEXT:    jne .LBB1_2
; X86-LZCNT-NEXT:  # %bb.1:
; X86-LZCNT-NEXT:    lzcntl {{[0-9]+}}(%esp), %eax
; X86-LZCNT-NEXT:    addl $32, %eax
; X86-LZCNT-NEXT:  .LBB1_2:
; X86-LZCNT-NEXT:    testb $64, %al
; X86-LZCNT-NEXT:    setne %al
; X86-LZCNT-NEXT:    retl
;
; X64-BSR-LABEL: lshr_ctlz_undef_cmpeq_one_i64:
; X64-BSR:       # %bb.0:
; X64-BSR-NEXT:    bsrq %rdi, %rax
; X64-BSR-NEXT:    shrq $6, %rax
; X64-BSR-NEXT:    cmpl $1, %eax
; X64-BSR-NEXT:    sete %al
; X64-BSR-NEXT:    retq
;
; X64-LZCNT-LABEL: lshr_ctlz_undef_cmpeq_one_i64:
; X64-LZCNT:       # %bb.0:
; X64-LZCNT-NEXT:    lzcntq %rdi, %rax
; X64-LZCNT-NEXT:    shrq $6, %rax
; X64-LZCNT-NEXT:    cmpl $1, %eax
; X64-LZCNT-NEXT:    sete %al
; X64-LZCNT-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 -1)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp eq i64 %lshr, 1
  ret i1 %icmp
}

define i1 @lshr_ctlz_cmpne_zero_i64(i64 %in) nounwind {
; X86-LABEL: lshr_ctlz_cmpne_zero_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-BSR-LABEL: lshr_ctlz_cmpne_zero_i64:
; X64-BSR:       # %bb.0:
; X64-BSR-NEXT:    testq %rdi, %rdi
; X64-BSR-NEXT:    je .LBB2_1
; X64-BSR-NEXT:  # %bb.2: # %cond.false
; X64-BSR-NEXT:    bsrq %rdi, %rax
; X64-BSR-NEXT:    xorq $63, %rax
; X64-BSR-NEXT:    jmp .LBB2_3
; X64-BSR-NEXT:  .LBB2_1:
; X64-BSR-NEXT:    movl $64, %eax
; X64-BSR-NEXT:  .LBB2_3: # %cond.end
; X64-BSR-NEXT:    testq $-64, %rax
; X64-BSR-NEXT:    setne %al
; X64-BSR-NEXT:    retq
;
; X64-LZCNT-LABEL: lshr_ctlz_cmpne_zero_i64:
; X64-LZCNT:       # %bb.0:
; X64-LZCNT-NEXT:    testq %rdi, %rdi
; X64-LZCNT-NEXT:    sete %al
; X64-LZCNT-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 0)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp ne i64 %lshr, 0
  ret i1 %icmp
}

define i1 @lshr_ctlz_undef_cmpne_zero_i64(i64 %in) nounwind {
; X86-BSR-LABEL: lshr_ctlz_undef_cmpne_zero_i64:
; X86-BSR:       # %bb.0:
; X86-BSR-NEXT:    xorl %eax, %eax
; X86-BSR-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-BSR-NEXT:    jne .LBB3_2
; X86-BSR-NEXT:  # %bb.1:
; X86-BSR-NEXT:    bsrl {{[0-9]+}}(%esp), %eax
; X86-BSR-NEXT:    xorl $31, %eax
; X86-BSR-NEXT:    addl $32, %eax
; X86-BSR-NEXT:  .LBB3_2:
; X86-BSR-NEXT:    testl $-64, %eax
; X86-BSR-NEXT:    setne %al
; X86-BSR-NEXT:    retl
;
; X86-LZCNT-LABEL: lshr_ctlz_undef_cmpne_zero_i64:
; X86-LZCNT:       # %bb.0:
; X86-LZCNT-NEXT:    xorl %eax, %eax
; X86-LZCNT-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-LZCNT-NEXT:    jne .LBB3_2
; X86-LZCNT-NEXT:  # %bb.1:
; X86-LZCNT-NEXT:    lzcntl {{[0-9]+}}(%esp), %eax
; X86-LZCNT-NEXT:    addl $32, %eax
; X86-LZCNT-NEXT:  .LBB3_2:
; X86-LZCNT-NEXT:    testb $64, %al
; X86-LZCNT-NEXT:    setne %al
; X86-LZCNT-NEXT:    retl
;
; X64-BSR-LABEL: lshr_ctlz_undef_cmpne_zero_i64:
; X64-BSR:       # %bb.0:
; X64-BSR-NEXT:    bsrq %rdi, %rax
; X64-BSR-NEXT:    testq $-64, %rax
; X64-BSR-NEXT:    setne %al
; X64-BSR-NEXT:    retq
;
; X64-LZCNT-LABEL: lshr_ctlz_undef_cmpne_zero_i64:
; X64-LZCNT:       # %bb.0:
; X64-LZCNT-NEXT:    lzcntq %rdi, %rax
; X64-LZCNT-NEXT:    testb $64, %al
; X64-LZCNT-NEXT:    setne %al
; X64-LZCNT-NEXT:    retq
  %ctlz = call i64 @llvm.ctlz.i64(i64 %in, i1 -1)
  %lshr = lshr i64 %ctlz, 6
  %icmp = icmp ne i64 %lshr, 0
  ret i1 %icmp
}

define <2 x i64> @lshr_ctlz_cmpeq_zero_v2i64(<2 x i64> %in) nounwind {
; X86-LABEL: lshr_ctlz_cmpeq_zero_v2i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
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

define <2 x i64> @lshr_ctlz_cmpne_zero_v2i64(<2 x i64> %in) nounwind {
; X86-LABEL: lshr_ctlz_cmpne_zero_v2i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
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
