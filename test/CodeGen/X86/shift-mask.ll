; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-pc-linux | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-pc-linux | FileCheck %s --check-prefixes=CHECK,X64,X64-MASK
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=bdver1 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-SHIFT2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=bdver2 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-TBM
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=bdver3 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-TBM
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=bdver4 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-TBM
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=btver1 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-SHIFT2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=btver2 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-BMI,X64-BMI1
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=znver1 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-BMI,X64-BMI2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mcpu=znver2 | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-BMI,X64-BMI2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+fast-scalar-shift-masks | FileCheck %s --check-prefixes=CHECK,X64,X64-SHIFT,X64-SHIFT2

;
; fold (shl (lshr x, c1), c2) -> (0) (and x, MASK) or
;                                (1) (and (shl x, (sub c2, c1), MASK) or
;                                (2) (and (lshr x, (sub c1, c2), MASK)
;

define i8 @test_i8_shl_lshr_0(i8 %a0) {
; X86-LABEL: test_i8_shl_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    andb $-8, %al
; X86-NEXT:    retl
;
; X64-LABEL: test_i8_shl_lshr_0:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $-8, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = lshr i8 %a0, 3
  %2 = shl i8 %1, 3
  ret i8 %2
}

define i8 @test_i8_shl_lshr_1(i8 %a0) {
; X86-LABEL: test_i8_shl_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shlb $2, %al
; X86-NEXT:    andb $-32, %al
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i8_shl_lshr_1:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-MASK-NEXT:    leal (,%rdi,4), %eax
; X64-MASK-NEXT:    andb $-32, %al
; X64-MASK-NEXT:    # kill: def $al killed $al killed $eax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i8_shl_lshr_1:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    movl %edi, %eax
; X64-SHIFT-NEXT:    shrb $3, %al
; X64-SHIFT-NEXT:    shlb $5, %al
; X64-SHIFT-NEXT:    # kill: def $al killed $al killed $eax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i8 %a0, 3
  %2 = shl i8 %1, 5
  ret i8 %2
}

define i8 @test_i8_shl_lshr_2(i8 %a0) {
; X86-LABEL: test_i8_shl_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shrb $2, %al
; X86-NEXT:    andb $56, %al
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i8_shl_lshr_2:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    movl %edi, %eax
; X64-MASK-NEXT:    shrb $2, %al
; X64-MASK-NEXT:    andb $56, %al
; X64-MASK-NEXT:    # kill: def $al killed $al killed $eax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i8_shl_lshr_2:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-SHIFT-NEXT:    shrb $5, %dil
; X64-SHIFT-NEXT:    leal (,%rdi,8), %eax
; X64-SHIFT-NEXT:    # kill: def $al killed $al killed $eax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i8 %a0, 5
  %2 = shl i8 %1, 3
  ret i8 %2
}

define i16 @test_i16_shl_lshr_0(i16 %a0) {
; X86-LABEL: test_i16_shl_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    andl $-8, %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i16_shl_lshr_0:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $65528, %eax # imm = 0xFFF8
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %1 = lshr i16 %a0, 3
  %2 = shl i16 %1, 3
  ret i16 %2
}

define i16 @test_i16_shl_lshr_1(i16 %a0) {
; X86-LABEL: test_i16_shl_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shll $2, %eax
; X86-NEXT:    andl $65504, %eax # imm = 0xFFE0
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i16_shl_lshr_1:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-MASK-NEXT:    leal (,%rdi,4), %eax
; X64-MASK-NEXT:    andl $65504, %eax # imm = 0xFFE0
; X64-MASK-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i16_shl_lshr_1:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    movzwl %di, %eax
; X64-SHIFT-NEXT:    shrl $3, %eax
; X64-SHIFT-NEXT:    shll $5, %eax
; X64-SHIFT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i16 %a0, 3
  %2 = shl i16 %1, 5
  ret i16 %2
}

define i16 @test_i16_shl_lshr_2(i16 %a0) {
; X86-LABEL: test_i16_shl_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrl $2, %eax
; X86-NEXT:    andl $16376, %eax # imm = 0x3FF8
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i16_shl_lshr_2:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    movl %edi, %eax
; X64-MASK-NEXT:    shrl $2, %eax
; X64-MASK-NEXT:    andl $16376, %eax # imm = 0x3FF8
; X64-MASK-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i16_shl_lshr_2:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    movzwl %di, %eax
; X64-SHIFT-NEXT:    shrl $5, %eax
; X64-SHIFT-NEXT:    shll $3, %eax
; X64-SHIFT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i16 %a0, 5
  %2 = shl i16 %1, 3
  ret i16 %2
}

define i32 @test_i32_shl_lshr_0(i32 %a0) {
; X86-LABEL: test_i32_shl_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    andl $-8, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i32_shl_lshr_0:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $-8, %eax
; X64-NEXT:    retq
  %1 = lshr i32 %a0, 3
  %2 = shl i32 %1, 3
  ret i32 %2
}

define i32 @test_i32_shl_lshr_1(i32 %a0) {
; X86-LABEL: test_i32_shl_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shll $2, %eax
; X86-NEXT:    andl $-32, %eax
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i32_shl_lshr_1:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-MASK-NEXT:    leal (,%rdi,4), %eax
; X64-MASK-NEXT:    andl $-32, %eax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i32_shl_lshr_1:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    movl %edi, %eax
; X64-SHIFT-NEXT:    shrl $3, %eax
; X64-SHIFT-NEXT:    shll $5, %eax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i32 %a0, 3
  %2 = shl i32 %1, 5
  ret i32 %2
}

define i32 @test_i32_shl_lshr_2(i32 %a0) {
; X86-LABEL: test_i32_shl_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrl $2, %eax
; X86-NEXT:    andl $-8, %eax
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i32_shl_lshr_2:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    movl %edi, %eax
; X64-MASK-NEXT:    shrl $2, %eax
; X64-MASK-NEXT:    andl $-8, %eax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i32_shl_lshr_2:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-SHIFT-NEXT:    shrl $5, %edi
; X64-SHIFT-NEXT:    leal (,%rdi,8), %eax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i32 %a0, 5
  %2 = shl i32 %1, 3
  ret i32 %2
}

define i64 @test_i64_shl_lshr_0(i64 %a0) {
; X86-LABEL: test_i64_shl_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    andl $-8, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i64_shl_lshr_0:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    andq $-8, %rax
; X64-NEXT:    retq
  %1 = lshr i64 %a0, 3
  %2 = shl i64 %1, 3
  ret i64 %2
}

define i64 @test_i64_shl_lshr_1(i64 %a0) {
; X86-LABEL: test_i64_shl_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    leal (,%ecx,4), %eax
; X86-NEXT:    andl $-32, %eax
; X86-NEXT:    shldl $2, %ecx, %edx
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i64_shl_lshr_1:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    leaq (,%rdi,4), %rax
; X64-MASK-NEXT:    andq $-32, %rax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i64_shl_lshr_1:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    movq %rdi, %rax
; X64-SHIFT-NEXT:    shrq $3, %rax
; X64-SHIFT-NEXT:    shlq $5, %rax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i64 %a0, 3
  %2 = shl i64 %1, 5
  ret i64 %2
}

define i64 @test_i64_shl_lshr_2(i64 %a0) {
; X86-LABEL: test_i64_shl_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shrdl $2, %edx, %eax
; X86-NEXT:    andl $-8, %eax
; X86-NEXT:    shrl $2, %edx
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i64_shl_lshr_2:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    movq %rdi, %rax
; X64-MASK-NEXT:    shrq $2, %rax
; X64-MASK-NEXT:    andq $-8, %rax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT-LABEL: test_i64_shl_lshr_2:
; X64-SHIFT:       # %bb.0:
; X64-SHIFT-NEXT:    shrq $5, %rdi
; X64-SHIFT-NEXT:    leaq (,%rdi,8), %rax
; X64-SHIFT-NEXT:    retq
  %1 = lshr i64 %a0, 5
  %2 = shl i64 %1, 3
  ret i64 %2
}

;
; fold (lshr (shl x, c1), c2) -> (0) (and x, MASK) or
;                                (1) (and (shl x, (sub c1, c2), MASK) or
;                                (2) (and (lshr x, (sub c2, c1), MASK)
;

define i8 @test_i8_lshr_lshr_0(i8 %a0) {
; X86-LABEL: test_i8_lshr_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    andb $31, %al
; X86-NEXT:    retl
;
; X64-LABEL: test_i8_lshr_lshr_0:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $31, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = shl i8 %a0, 3
  %2 = lshr i8 %1, 3
  ret i8 %2
}

define i8 @test_i8_lshr_lshr_1(i8 %a0) {
; X86-LABEL: test_i8_lshr_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shlb $3, %al
; X86-NEXT:    shrb $5, %al
; X86-NEXT:    retl
;
; X64-LABEL: test_i8_lshr_lshr_1:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (,%rdi,8), %eax
; X64-NEXT:    shrb $5, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = shl i8 %a0, 3
  %2 = lshr i8 %1, 5
  ret i8 %2
}

define i8 @test_i8_lshr_lshr_2(i8 %a0) {
; X86-LABEL: test_i8_lshr_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shlb $5, %al
; X86-NEXT:    shrb $3, %al
; X86-NEXT:    retl
;
; X64-LABEL: test_i8_lshr_lshr_2:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb $5, %al
; X64-NEXT:    shrb $3, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = shl i8 %a0, 5
  %2 = lshr i8 %1, 3
  ret i8 %2
}

define i16 @test_i16_lshr_lshr_0(i16 %a0) {
; X86-LABEL: test_i16_lshr_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    andl $8191, %eax # imm = 0x1FFF
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i16_lshr_lshr_0:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $8191, %eax # imm = 0x1FFF
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %1 = shl i16 %a0, 3
  %2 = lshr i16 %1, 3
  ret i16 %2
}

define i16 @test_i16_lshr_lshr_1(i16 %a0) {
; X86-LABEL: test_i16_lshr_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrl $2, %eax
; X86-NEXT:    andl $2047, %eax # imm = 0x7FF
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i16_lshr_lshr_1:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    movl %edi, %eax
; X64-MASK-NEXT:    shrl $2, %eax
; X64-MASK-NEXT:    andl $2047, %eax # imm = 0x7FF
; X64-MASK-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT2-LABEL: test_i16_lshr_lshr_1:
; X64-SHIFT2:       # %bb.0:
; X64-SHIFT2-NEXT:    movl %edi, %eax
; X64-SHIFT2-NEXT:    shrl $2, %eax
; X64-SHIFT2-NEXT:    andl $2047, %eax # imm = 0x7FF
; X64-SHIFT2-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-SHIFT2-NEXT:    retq
;
; X64-TBM-LABEL: test_i16_lshr_lshr_1:
; X64-TBM:       # %bb.0:
; X64-TBM-NEXT:    bextrl $2818, %edi, %eax # imm = 0xB02
; X64-TBM-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-TBM-NEXT:    retq
;
; X64-BMI-LABEL: test_i16_lshr_lshr_1:
; X64-BMI:       # %bb.0:
; X64-BMI-NEXT:    movl $2818, %eax # imm = 0xB02
; X64-BMI-NEXT:    bextrl %eax, %edi, %eax
; X64-BMI-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-BMI-NEXT:    retq
  %1 = shl i16 %a0, 3
  %2 = lshr i16 %1, 5
  ret i16 %2
}

define i16 @test_i16_lshr_lshr_2(i16 %a0) {
; X86-LABEL: test_i16_lshr_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shll $2, %eax
; X86-NEXT:    andl $8188, %eax # imm = 0x1FFC
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i16_lshr_lshr_2:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (,%rdi,4), %eax
; X64-NEXT:    andl $8188, %eax # imm = 0x1FFC
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %1 = shl i16 %a0, 5
  %2 = lshr i16 %1, 3
  ret i16 %2
}

define i32 @test_i32_lshr_lshr_0(i32 %a0) {
; X86-LABEL: test_i32_lshr_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movl $536870911, %eax # imm = 0x1FFFFFFF
; X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i32_lshr_lshr_0:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $536870911, %eax # imm = 0x1FFFFFFF
; X64-NEXT:    retq
  %1 = shl i32 %a0, 3
  %2 = lshr i32 %1, 3
  ret i32 %2
}

define i32 @test_i32_lshr_lshr_1(i32 %a0) {
; X86-LABEL: test_i32_lshr_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shll $3, %eax
; X86-NEXT:    shrl $5, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i32_lshr_lshr_1:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (,%rdi,8), %eax
; X64-NEXT:    shrl $5, %eax
; X64-NEXT:    retq
  %1 = shl i32 %a0, 3
  %2 = lshr i32 %1, 5
  ret i32 %2
}

define i32 @test_i32_lshr_lshr_2(i32 %a0) {
; X86-LABEL: test_i32_lshr_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shll $5, %eax
; X86-NEXT:    shrl $3, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i32_lshr_lshr_2:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $5, %eax
; X64-NEXT:    shrl $3, %eax
; X64-NEXT:    retq
  %1 = shl i32 %a0, 5
  %2 = lshr i32 %1, 3
  ret i32 %2
}

define i64 @test_i64_lshr_lshr_0(i64 %a0) {
; X86-LABEL: test_i64_lshr_lshr_0:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl $536870911, %edx # imm = 0x1FFFFFFF
; X86-NEXT:    andl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    retl
;
; X64-MASK-LABEL: test_i64_lshr_lshr_0:
; X64-MASK:       # %bb.0:
; X64-MASK-NEXT:    movabsq $2305843009213693951, %rax # imm = 0x1FFFFFFFFFFFFFFF
; X64-MASK-NEXT:    andq %rdi, %rax
; X64-MASK-NEXT:    retq
;
; X64-SHIFT2-LABEL: test_i64_lshr_lshr_0:
; X64-SHIFT2:       # %bb.0:
; X64-SHIFT2-NEXT:    movabsq $2305843009213693951, %rax # imm = 0x1FFFFFFFFFFFFFFF
; X64-SHIFT2-NEXT:    andq %rdi, %rax
; X64-SHIFT2-NEXT:    retq
;
; X64-TBM-LABEL: test_i64_lshr_lshr_0:
; X64-TBM:       # %bb.0:
; X64-TBM-NEXT:    bextrq $15616, %rdi, %rax # imm = 0x3D00
; X64-TBM-NEXT:    retq
;
; X64-BMI1-LABEL: test_i64_lshr_lshr_0:
; X64-BMI1:       # %bb.0:
; X64-BMI1-NEXT:    movl $15616, %eax # imm = 0x3D00
; X64-BMI1-NEXT:    bextrq %rax, %rdi, %rax
; X64-BMI1-NEXT:    retq
;
; X64-BMI2-LABEL: test_i64_lshr_lshr_0:
; X64-BMI2:       # %bb.0:
; X64-BMI2-NEXT:    movb $61, %al
; X64-BMI2-NEXT:    bzhiq %rax, %rdi, %rax
; X64-BMI2-NEXT:    retq
  %1 = shl i64 %a0, 3
  %2 = lshr i64 %1, 3
  ret i64 %2
}

define i64 @test_i64_lshr_lshr_1(i64 %a0) {
; X86-LABEL: test_i64_lshr_lshr_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shldl $3, %eax, %edx
; X86-NEXT:    shll $3, %eax
; X86-NEXT:    shrdl $5, %edx, %eax
; X86-NEXT:    shrl $5, %edx
; X86-NEXT:    retl
;
; X64-LABEL: test_i64_lshr_lshr_1:
; X64:       # %bb.0:
; X64-NEXT:    leaq (,%rdi,8), %rax
; X64-NEXT:    shrq $5, %rax
; X64-NEXT:    retq
  %1 = shl i64 %a0, 3
  %2 = lshr i64 %1, 5
  ret i64 %2
}

define i64 @test_i64_lshr_lshr_2(i64 %a0) {
; X86-LABEL: test_i64_lshr_lshr_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shldl $5, %eax, %edx
; X86-NEXT:    shll $5, %eax
; X86-NEXT:    shrdl $3, %edx, %eax
; X86-NEXT:    shrl $3, %edx
; X86-NEXT:    retl
;
; X64-LABEL: test_i64_lshr_lshr_2:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shlq $5, %rax
; X64-NEXT:    shrq $3, %rax
; X64-NEXT:    retq
  %1 = shl i64 %a0, 5
  %2 = lshr i64 %1, 3
  ret i64 %2
}
