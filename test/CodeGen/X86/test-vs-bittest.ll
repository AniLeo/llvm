; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define void @test64(i64 inreg %x) {
; CHECK-LABEL: test64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $2048, %edi # imm = 0x800
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB0_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 2048
  %s = icmp eq i64 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_optsize(i64 inreg %x) optsize {
; CHECK-LABEL: test64_optsize:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jb .LBB1_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB1_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 2048
  %s = icmp eq i64 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_pgso(i64 inreg %x) !prof !14 {
; CHECK-LABEL: test64_pgso:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jb .LBB2_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB2_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 2048
  %s = icmp eq i64 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

; This test is identical to test64 above with only the destination of the br
; reversed. This somehow causes the two functions to get slightly different
; initial IR. One has an extra invert of the setcc. This previous caused one
; the functions to use a BT while the other used a TEST due to another DAG
; combine messing with an expected canonical form.
define void @test64_2(i64 inreg %x) {
; CHECK-LABEL: test64_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $2048, %edi # imm = 0x800
; CHECK-NEXT:    je .LBB3_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB3_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 2048
  %s = icmp eq i64 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_optsize_2(i64 inreg %x) optsize {
; CHECK-LABEL: test64_optsize_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jae .LBB4_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB4_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 2048
  %s = icmp eq i64 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_pgso_2(i64 inreg %x) !prof !14 {
; CHECK-LABEL: test64_pgso_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jae .LBB5_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB5_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 2048
  %s = icmp eq i64 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_3(i64 inreg %x) {
; CHECK-LABEL: test64_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btq $32, %rdi
; CHECK-NEXT:    jb .LBB6_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB6_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 4294967296
  %s = icmp eq i64 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_optsize_3(i64 inreg %x) optsize {
; CHECK-LABEL: test64_optsize_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btq $32, %rdi
; CHECK-NEXT:    jb .LBB7_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB7_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 4294967296
  %s = icmp eq i64 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_pgso_3(i64 inreg %x) !prof !14 {
; CHECK-LABEL: test64_pgso_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btq $32, %rdi
; CHECK-NEXT:    jb .LBB8_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB8_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 4294967296
  %s = icmp eq i64 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_4(i64 inreg %x) {
; CHECK-LABEL: test64_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btq $32, %rdi
; CHECK-NEXT:    jae .LBB9_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB9_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 4294967296
  %s = icmp eq i64 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_optsize_4(i64 inreg %x) optsize {
; CHECK-LABEL: test64_optsize_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btq $32, %rdi
; CHECK-NEXT:    jae .LBB10_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB10_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 4294967296
  %s = icmp eq i64 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test64_pgso_4(i64 inreg %x) !prof !14 {
; CHECK-LABEL: test64_pgso_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btq $32, %rdi
; CHECK-NEXT:    jae .LBB11_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB11_2: # %no
; CHECK-NEXT:    retq
  %t = and i64 %x, 4294967296
  %s = icmp eq i64 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test32(i32 inreg %x) {
; CHECK-LABEL: test32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $2048, %edi # imm = 0x800
; CHECK-NEXT:    jne .LBB12_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB12_2: # %no
; CHECK-NEXT:    retq
  %t = and i32 %x, 2048
  %s = icmp eq i32 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test32_optsize(i32 inreg %x) optsize {
; CHECK-LABEL: test32_optsize:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jb .LBB13_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB13_2: # %no
; CHECK-NEXT:    retq
  %t = and i32 %x, 2048
  %s = icmp eq i32 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test32_2(i32 inreg %x) {
; CHECK-LABEL: test32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $2048, %edi # imm = 0x800
; CHECK-NEXT:    je .LBB14_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB14_2: # %no
; CHECK-NEXT:    retq
  %t = and i32 %x, 2048
  %s = icmp eq i32 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test32_optsize_2(i32 inreg %x) optsize {
; CHECK-LABEL: test32_optsize_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jae .LBB15_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB15_2: # %no
; CHECK-NEXT:    retq
  %t = and i32 %x, 2048
  %s = icmp eq i32 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test32_pgso_2(i32 inreg %x) !prof !14 {
; CHECK-LABEL: test32_pgso_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jae .LBB16_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB16_2: # %no
; CHECK-NEXT:    retq
  %t = and i32 %x, 2048
  %s = icmp eq i32 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test16(i16 inreg %x) {
; CHECK-LABEL: test16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $2048, %edi # imm = 0x800
; CHECK-NEXT:    jne .LBB17_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB17_2: # %no
; CHECK-NEXT:    retq
  %t = and i16 %x, 2048
  %s = icmp eq i16 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test16_optsize(i16 inreg %x) optsize {
; CHECK-LABEL: test16_optsize:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jb .LBB18_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB18_2: # %no
; CHECK-NEXT:    retq
  %t = and i16 %x, 2048
  %s = icmp eq i16 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test16_pgso(i16 inreg %x) !prof !14 {
; CHECK-LABEL: test16_pgso:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jb .LBB19_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB19_2: # %no
; CHECK-NEXT:    retq
  %t = and i16 %x, 2048
  %s = icmp eq i16 %t, 0
  br i1 %s, label %yes, label %no

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test16_2(i16 inreg %x) {
; CHECK-LABEL: test16_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $2048, %edi # imm = 0x800
; CHECK-NEXT:    je .LBB20_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB20_2: # %no
; CHECK-NEXT:    retq
  %t = and i16 %x, 2048
  %s = icmp eq i16 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test16_optsize_2(i16 inreg %x) optsize {
; CHECK-LABEL: test16_optsize_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jae .LBB21_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB21_2: # %no
; CHECK-NEXT:    retq
  %t = and i16 %x, 2048
  %s = icmp eq i16 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define void @test16_pgso_2(i16 inreg %x) !prof !14 {
; CHECK-LABEL: test16_pgso_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    btl $11, %edi
; CHECK-NEXT:    jae .LBB22_2
; CHECK-NEXT:  # %bb.1: # %yes
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .LBB22_2: # %no
; CHECK-NEXT:    retq
  %t = and i16 %x, 2048
  %s = icmp eq i16 %t, 0
  br i1 %s, label %no, label %yes

yes:
  call void @bar()
  ret void
no:
  ret void
}

define i64 @is_upper_bit_clear_i64(i64 %x) {
; CHECK-LABEL: is_upper_bit_clear_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    btq $37, %rdi
; CHECK-NEXT:    setae %al
; CHECK-NEXT:    retq
  %sh = lshr i64 %x, 37
  %m = and i64 %sh, 1
  %r = xor i64 %m, 1
  ret i64 %r
}

define i64 @is_lower_bit_clear_i64(i64 %x) {
; CHECK-LABEL: is_lower_bit_clear_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl $134217728, %edi # imm = 0x8000000
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %sh = lshr i64 %x, 27
  %m = and i64 %sh, 1
  %r = xor i64 %m, 1
  ret i64 %r
}

define i32 @is_bit_clear_i32(i32 %x) {
; CHECK-LABEL: is_bit_clear_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl $134217728, %edi # imm = 0x8000000
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %sh = lshr i32 %x, 27
  %n = xor i32 %sh, -1
  %r = and i32 %n, 1
  ret i32 %r
}

define i16 @is_bit_clear_i16(i16 %x) {
; CHECK-LABEL: is_bit_clear_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb $-128, %dil
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
  %sh = lshr i16 %x, 7
  %m = and i16 %sh, 1
  %r = xor i16 %m, 1
  ret i16 %r
}

define i8 @is_bit_clear_i8(i8 %x) {
; CHECK-LABEL: is_bit_clear_i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $8, %dil
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %sh = lshr i8 %x, 3
  %m = and i8 %sh, 1
  %r = xor i8 %m, 1
  ret i8 %r
}

; TODO: We could use bt/test on the 64-bit value.

define i8 @overshift(i64 %x) {
; CHECK-LABEL: overshift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    shrq $42, %rax
; CHECK-NEXT:    notb %al
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $rax
; CHECK-NEXT:    retq
  %a = lshr i64 %x, 42
  %t = trunc i64 %a to i8
  %n = xor i8 %t, -1
  %r = and i8 %n, 1
  ret i8 %r
}

define i32 @setcc_is_bit_clear(i32 %x) {
; CHECK-LABEL: setcc_is_bit_clear:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl $1024, %edi # imm = 0x400
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %a1 = and i32 %x, 1024
  %b1 = icmp eq i32 %a1, 0
  %r = zext i1 %b1 to i32
  ret i32 %r
}

define i32 @is_bit_set(i32 %x) {
; CHECK-LABEL: is_bit_set:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shrl $10, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    retq
  %sh = lshr i32 %x, 10
  %m = and i32 %sh, 1
  ret i32 %m
}

define i32 @setcc_is_bit_set(i32 %x) {
; CHECK-LABEL: setcc_is_bit_set:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shrl $10, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    retq
  %a1 = and i32 %x, 1024
  %b1 = icmp ne i32 %a1, 0
  %r = zext i1 %b1 to i32
  ret i32 %r
}

declare void @bar()

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"ProfileSummary", !1}
!1 = !{!2, !3, !4, !5, !6, !7, !8, !9}
!2 = !{!"ProfileFormat", !"InstrProf"}
!3 = !{!"TotalCount", i64 10000}
!4 = !{!"MaxCount", i64 10}
!5 = !{!"MaxInternalCount", i64 1}
!6 = !{!"MaxFunctionCount", i64 1000}
!7 = !{!"NumCounts", i64 3}
!8 = !{!"NumFunctions", i64 3}
!9 = !{!"DetailedSummary", !10}
!10 = !{!11, !12, !13}
!11 = !{i32 10000, i64 100, i32 1}
!12 = !{i32 999000, i64 100, i32 1}
!13 = !{i32 999999, i64 1, i32 2}
!14 = !{!"function_entry_count", i64 0}
