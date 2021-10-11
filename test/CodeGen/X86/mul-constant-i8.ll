; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s --check-prefix=X64

define i8 @test_mul_by_1(i8 %x) {
; X64-LABEL: test_mul_by_1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 1
  ret i8 %m
}

define i8 @test_mul_by_2(i8 %x) {
; X64-LABEL: test_mul_by_2:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 2
  ret i8 %m
}

define i8 @test_mul_by_3(i8 %x) {
; X64-LABEL: test_mul_by_3:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 3
  ret i8 %m
}

define i8 @test_mul_by_4(i8 %x) {
; X64-LABEL: test_mul_by_4:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (,%rdi,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 4
  ret i8 %m
}

define i8 @test_mul_by_5(i8 %x) {
; X64-LABEL: test_mul_by_5:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 5
  ret i8 %m
}

define i8 @test_mul_by_6(i8 %x) {
; X64-LABEL: test_mul_by_6:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    leal (%rdi,%rdi,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 6
  ret i8 %m
}

define i8 @test_mul_by_7(i8 %x) {
; X64-LABEL: test_mul_by_7:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (,%rdi,8), %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 7
  ret i8 %m
}

define i8 @test_mul_by_8(i8 %x) {
; X64-LABEL: test_mul_by_8:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (,%rdi,8), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 8
  ret i8 %m
}

define i8 @test_mul_by_9(i8 %x) {
; X64-LABEL: test_mul_by_9:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 9
  ret i8 %m
}

define i8 @test_mul_by_10(i8 %x) {
; X64-LABEL: test_mul_by_10:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 10
  ret i8 %m
}

define i8 @test_mul_by_11(i8 %x) {
; X64-LABEL: test_mul_by_11:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    leal (%rdi,%rax,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 11
  ret i8 %m
}

define i8 @test_mul_by_12(i8 %x) {
; X64-LABEL: test_mul_by_12:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    shll $2, %edi
; X64-NEXT:    leal (%rdi,%rdi,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 12
  ret i8 %m
}

define i8 @test_mul_by_13(i8 %x) {
; X64-LABEL: test_mul_by_13:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,2), %eax
; X64-NEXT:    leal (%rdi,%rax,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 13
  ret i8 %m
}

define i8 @test_mul_by_14(i8 %x) {
; X64-LABEL: test_mul_by_14:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $4, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 14
  ret i8 %m
}

define i8 @test_mul_by_15(i8 %x) {
; X64-LABEL: test_mul_by_15:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    leal (%rax,%rax,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 15
  ret i8 %m
}

define i8 @test_mul_by_16(i8 %x) {
; X64-LABEL: test_mul_by_16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb $4, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 16
  ret i8 %m
}

define i8 @test_mul_by_17(i8 %x) {
; X64-LABEL: test_mul_by_17:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $4, %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 17
  ret i8 %m
}

define i8 @test_mul_by_18(i8 %x) {
; X64-LABEL: test_mul_by_18:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 18
  ret i8 %m
}

define i8 @test_mul_by_19(i8 %x) {
; X64-LABEL: test_mul_by_19:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    leal (%rdi,%rax,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 19
  ret i8 %m
}

define i8 @test_mul_by_20(i8 %x) {
; X64-LABEL: test_mul_by_20:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    shll $2, %edi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 20
  ret i8 %m
}

define i8 @test_mul_by_21(i8 %x) {
; X64-LABEL: test_mul_by_21:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    leal (%rdi,%rax,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 21
  ret i8 %m
}

define i8 @test_mul_by_22(i8 %x) {
; X64-LABEL: test_mul_by_22:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    leal (%rdi,%rax,4), %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 22
  ret i8 %m
}

define i8 @test_mul_by_23(i8 %x) {
; X64-LABEL: test_mul_by_23:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,2), %eax
; X64-NEXT:    shll $3, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 23
  ret i8 %m
}

define i8 @test_mul_by_24(i8 %x) {
; X64-LABEL: test_mul_by_24:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    shll $3, %edi
; X64-NEXT:    leal (%rdi,%rdi,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 24
  ret i8 %m
}

define i8 @test_mul_by_25(i8 %x) {
; X64-LABEL: test_mul_by_25:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    leal (%rax,%rax,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 25
  ret i8 %m
}

define i8 @test_mul_by_26(i8 %x) {
; X64-LABEL: test_mul_by_26:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    leal (%rax,%rax,4), %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 26
  ret i8 %m
}

define i8 @test_mul_by_27(i8 %x) {
; X64-LABEL: test_mul_by_27:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    leal (%rax,%rax,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 27
  ret i8 %m
}

define i8 @test_mul_by_28(i8 %x) {
; X64-LABEL: test_mul_by_28:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    leal (%rax,%rax,2), %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 28
  ret i8 %m
}

define i8 @test_mul_by_29(i8 %x) {
; X64-LABEL: test_mul_by_29:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    leal (%rax,%rax,2), %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 29
  ret i8 %m
}

define i8 @test_mul_by_30(i8 %x) {
; X64-LABEL: test_mul_by_30:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $5, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 30
  ret i8 %m
}

define i8 @test_mul_by_31(i8 %x) {
; X64-LABEL: test_mul_by_31:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $5, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 31
  ret i8 %m
}

define i8 @test_mul_by_32(i8 %x) {
; X64-LABEL: test_mul_by_32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb $5, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 32
  ret i8 %m
}

define i8 @test_mul_by_37(i8 %x) {
; X64-LABEL: test_mul_by_37:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    leal (%rdi,%rax,4), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 37
  ret i8 %m
}

define i8 @test_mul_by_41(i8 %x) {
; X64-LABEL: test_mul_by_41:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    leal (%rdi,%rax,8), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 41
  ret i8 %m
}

define i8 @test_mul_by_62(i8 %x) {
; X64-LABEL: test_mul_by_62:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $6, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 62
  ret i8 %m
}

define i8 @test_mul_by_66(i8 %x) {
; X64-LABEL: test_mul_by_66:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $6, %eax
; X64-NEXT:    leal (%rax,%rdi,2), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 66
  ret i8 %m
}

define i8 @test_mul_by_73(i8 %x) {
; X64-LABEL: test_mul_by_73:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    leal (%rdi,%rax,8), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 73
  ret i8 %m
}

define i8 @test_mul_by_520(i8 %x) {
; X64-LABEL: test_mul_by_520:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (,%rdi,8), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, 520
  ret i8 %m
}

define i8 @test_mul_by_neg10(i8 %x) {
; X64-LABEL: test_mul_by_neg10:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    leal (%rdi,%rdi,4), %eax
; X64-NEXT:    negl %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, -10
  ret i8 %m
}

define i8 @test_mul_by_neg36(i8 %x) {
; X64-LABEL: test_mul_by_neg36:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    shll $2, %edi
; X64-NEXT:    leal (%rdi,%rdi,8), %eax
; X64-NEXT:    negl %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %m = mul i8 %x, -36
  ret i8 %m
}

