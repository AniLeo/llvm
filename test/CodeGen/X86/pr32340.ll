; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -fast-isel-sink-local-values -O0 -mtriple=x86_64-unknown-linux-gnu -fast-isel-abort=1 -o - %s | FileCheck %s -check-prefix=X64

@var_825 = external global i16, align 2
@var_32 = external global i16, align 2
@var_901 = external global i16, align 2
@var_826 = external global i64, align 8
@var_57 = external global i64, align 8
@var_900 = external global i16, align 2
@var_28 = external constant i64, align 8
@var_827 = external global i16, align 2

define void @foo() {
; X64-LABEL: foo:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movw $0, var_825
; X64-NEXT:    movzwl var_32, %ecx
; X64-NEXT:    movzwl var_901, %eax
; X64-NEXT:    movl %ecx, %edx
; X64-NEXT:    xorl %eax, %edx
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    xorl %edx, %eax
; X64-NEXT:    addl %ecx, %eax
; X64-NEXT:    cltq
; X64-NEXT:    movq %rax, var_826
; X64-NEXT:    movzwl var_32, %eax
; X64-NEXT:    # kill: def $rax killed $eax
; X64-NEXT:    movzwl var_901, %ecx
; X64-NEXT:    xorl $51981, %ecx # imm = 0xCB0D
; X64-NEXT:    movslq %ecx, %rdx
; X64-NEXT:    movabsq $-1142377792914660288, %rcx # imm = 0xF02575732E06E440
; X64-NEXT:    xorq %rcx, %rdx
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    xorq %rdx, %rcx
; X64-NEXT:    xorq $-1, %rcx
; X64-NEXT:    xorq %rcx, %rax
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    orq var_57, %rcx
; X64-NEXT:    orq %rcx, %rax
; X64-NEXT:    # kill: def $ax killed $ax killed $rax
; X64-NEXT:    movw %ax, var_900
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    # kill: def $rax killed $eax
; X64-NEXT:    cmpq var_28, %rax
; X64-NEXT:    setne %al
; X64-NEXT:    andb $1, %al
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    movw %ax, var_827
; X64-NEXT:    retq
entry:
  store i16 0, i16* @var_825, align 2
  %v0 = load i16, i16* @var_32, align 2
  %conv = zext i16 %v0 to i32
  %v2 = load i16, i16* @var_901, align 2
  %conv2 = zext i16 %v2 to i32
  %xor = xor i32 %conv, %conv2
  %xor3 = xor i32 %conv, %xor
  %add = add nsw i32 %xor3, %conv
  %conv5 = sext i32 %add to i64
  store i64 %conv5, i64* @var_826, align 8
  %v4 = load i16, i16* @var_32, align 2
  %conv6 = zext i16 %v4 to i64
  %v6 = load i16, i16* @var_901, align 2
  %conv8 = zext i16 %v6 to i32
  %xor9 = xor i32 51981, %conv8
  %conv10 = sext i32 %xor9 to i64
  %xor11 = xor i64 -1142377792914660288, %conv10
  %xor12 = xor i64 %conv6, %xor11
  %neg = xor i64 %xor12, -1
  %xor13 = xor i64 %conv6, %neg
  %v9 = load i16, i16* @var_901, align 2
  %v10 = load i64, i64* @var_57, align 8
  %or = or i64 %xor13, %v10
  %or23 = or i64 %xor13, %or
  %conv24 = trunc i64 %or23 to i16
  store i16 %conv24, i16* @var_900, align 2
  %v11 = load i64, i64* @var_28, align 8
  %cmp = icmp ne i64 0, %v11
  %conv25 = zext i1 %cmp to i16
  store i16 %conv25, i16* @var_827, align 2
  ret void
}
