; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -show-mc-encoding | FileCheck %s

@d = dso_local global i8 0, align 1
@d64 = dso_local global i64 0

define i32 @test1(i32 %X, ptr %y) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpl $0, (%rsi) # encoding: [0x83,0x3e,0x00]
; CHECK-NEXT:    je .LBB0_2 # encoding: [0x74,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB0_2-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.1: # %cond_true
; CHECK-NEXT:    movl $1, %eax # encoding: [0xb8,0x01,0x00,0x00,0x00]
; CHECK-NEXT:    retq # encoding: [0xc3]
; CHECK-NEXT:  .LBB0_2: # %ReturnBlock
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %tmp = load i32, ptr %y
  %tmp.upgrd.1 = icmp eq i32 %tmp, 0
  br i1 %tmp.upgrd.1, label %ReturnBlock, label %cond_true

cond_true:
  ret i32 1

ReturnBlock:
  ret i32 0
}

define i32 @test2(i32 %X, ptr %y) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testl $536870911, (%rsi) # encoding: [0xf7,0x06,0xff,0xff,0xff,0x1f]
; CHECK-NEXT:    # imm = 0x1FFFFFFF
; CHECK-NEXT:    je .LBB1_2 # encoding: [0x74,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB1_2-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.1: # %cond_true
; CHECK-NEXT:    movl $1, %eax # encoding: [0xb8,0x01,0x00,0x00,0x00]
; CHECK-NEXT:    retq # encoding: [0xc3]
; CHECK-NEXT:  .LBB1_2: # %ReturnBlock
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %tmp = load i32, ptr %y
  %tmp1 = shl i32 %tmp, 3
  %tmp1.upgrd.2 = icmp eq i32 %tmp1, 0
  br i1 %tmp1.upgrd.2, label %ReturnBlock, label %cond_true

cond_true:
  ret i32 1

ReturnBlock:
  ret i32 0
}

define i8 @test2b(i8 %X, ptr %y) nounwind {
; CHECK-LABEL: test2b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testb $31, (%rsi) # encoding: [0xf6,0x06,0x1f]
; CHECK-NEXT:    je .LBB2_2 # encoding: [0x74,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB2_2-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.1: # %cond_true
; CHECK-NEXT:    movb $1, %al # encoding: [0xb0,0x01]
; CHECK-NEXT:    retq # encoding: [0xc3]
; CHECK-NEXT:  .LBB2_2: # %ReturnBlock
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %tmp = load i8, ptr %y
  %tmp1 = shl i8 %tmp, 3
  %tmp1.upgrd.2 = icmp eq i8 %tmp1, 0
  br i1 %tmp1.upgrd.2, label %ReturnBlock, label %cond_true

cond_true:
  ret i8 1

ReturnBlock:
  ret i8 0
}

define i64 @test3(i64 %x) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testq %rdi, %rdi # encoding: [0x48,0x85,0xff]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %t = icmp eq i64 %x, 0
  %r = zext i1 %t to i64
  ret i64 %r
}

define i64 @test4(i64 %x) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testq %rdi, %rdi # encoding: [0x48,0x85,0xff]
; CHECK-NEXT:    setle %al # encoding: [0x0f,0x9e,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %t = icmp slt i64 %x, 1
  %r = zext i1 %t to i64
  ret i64 %r
}

define i32 @test5(double %A) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ucomisd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0 # encoding: [0x66,0x0f,0x2e,0x05,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 4, value: {{\.?LCPI[0-9]+_[0-9]+}}-4, kind: reloc_riprel_4byte
; CHECK-NEXT:    ja .LBB5_3 # encoding: [0x77,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB5_3-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    ucomisd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0 # encoding: [0x66,0x0f,0x2e,0x05,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 4, value: {{\.?LCPI[0-9]+_[0-9]+}}-4, kind: reloc_riprel_4byte
; CHECK-NEXT:    jb .LBB5_3 # encoding: [0x72,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB5_3-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.2: # %bb12
; CHECK-NEXT:    movl $32, %eax # encoding: [0xb8,0x20,0x00,0x00,0x00]
; CHECK-NEXT:    retq # encoding: [0xc3]
; CHECK-NEXT:  .LBB5_3: # %bb8
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    jmp foo@PLT # TAILCALL
; CHECK-NEXT:    # encoding: [0xeb,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: foo@PLT-1, kind: FK_PCRel_1
entry:
  %tmp2 = fcmp ogt double %A, 1.500000e+02
  %tmp5 = fcmp ult double %A, 7.500000e+01
  %bothcond = or i1 %tmp2, %tmp5
  br i1 %bothcond, label %bb8, label %bb12

bb8:
  %tmp9 = tail call i32 (...) @foo() nounwind
  ret i32 %tmp9

bb12:
  ret i32 32
}

declare i32 @foo(...)

define i32 @test6() nounwind align 2 {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpq $0, -{{[0-9]+}}(%rsp) # encoding: [0x48,0x83,0x7c,0x24,0xf8,0x00]
; CHECK-NEXT:    je .LBB6_1 # encoding: [0x74,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB6_1-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.2: # %F
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
; CHECK-NEXT:  .LBB6_1: # %T
; CHECK-NEXT:    movl $1, %eax # encoding: [0xb8,0x01,0x00,0x00,0x00]
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %A = alloca { i64, i64 }, align 8
  %B = getelementptr inbounds { i64, i64 }, ptr %A, i64 0, i32 1
  %C = load i64, ptr %B
  %D = icmp eq i64 %C, 0
  br i1 %D, label %T, label %F

T:
  ret i32 1

F:
  ret i32 0
}

define i32 @test7(i64 %res) nounwind {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    shrq $32, %rdi # encoding: [0x48,0xc1,0xef,0x20]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %lnot = icmp ult i64 %res, 4294967296
  %lnot.ext = zext i1 %lnot to i32
  ret i32 %lnot.ext
}

define i32 @test8(i64 %res) nounwind {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrq $32, %rdi # encoding: [0x48,0xc1,0xef,0x20]
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    cmpl $3, %edi # encoding: [0x83,0xff,0x03]
; CHECK-NEXT:    setb %al # encoding: [0x0f,0x92,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %lnot = icmp ult i64 %res, 12884901888
  %lnot.ext = zext i1 %lnot to i32
  ret i32 %lnot.ext
}

define i32 @test9(i64 %res) nounwind {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    shrq $33, %rdi # encoding: [0x48,0xc1,0xef,0x21]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %lnot = icmp ult i64 %res, 8589934592
  %lnot.ext = zext i1 %lnot to i32
  ret i32 %lnot.ext
}

define i32 @test10(i64 %res) nounwind {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    shrq $32, %rdi # encoding: [0x48,0xc1,0xef,0x20]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %lnot = icmp uge i64 %res, 4294967296
  %lnot.ext = zext i1 %lnot to i32
  ret i32 %lnot.ext
}

define i32 @test11(i64 %l) nounwind {
; CHECK-LABEL: test11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrq $47, %rdi # encoding: [0x48,0xc1,0xef,0x2f]
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    cmpl $1, %edi # encoding: [0x83,0xff,0x01]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %shr.mask = and i64 %l, -140737488355328
  %cmp = icmp eq i64 %shr.mask, 140737488355328
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @test12() ssp uwtable {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax # encoding: [0x50]
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq test12b@PLT # encoding: [0xe8,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: test12b@PLT-4, kind: FK_PCRel_4
; CHECK-NEXT:    testb %al, %al # encoding: [0x84,0xc0]
; CHECK-NEXT:    je .LBB12_2 # encoding: [0x74,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB12_2-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.1: # %T
; CHECK-NEXT:    movl $1, %eax # encoding: [0xb8,0x01,0x00,0x00,0x00]
; CHECK-NEXT:    popq %rcx # encoding: [0x59]
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq # encoding: [0xc3]
; CHECK-NEXT:  .LBB12_2: # %F
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl $2, %eax # encoding: [0xb8,0x02,0x00,0x00,0x00]
; CHECK-NEXT:    popq %rcx # encoding: [0x59]
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %tmp1 = call zeroext i1 @test12b()
  br i1 %tmp1, label %T, label %F

T:
  ret i32 1

F:
  ret i32 2
}

declare zeroext i1 @test12b()

define i32 @test13(i32 %mask, i32 %base, i32 %intra) {
; CHECK-LABEL: test13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax # encoding: [0x89,0xf0]
; CHECK-NEXT:    testb $8, %dil # encoding: [0x40,0xf6,0xc7,0x08]
; CHECK-NEXT:    cmovnel %edx, %eax # encoding: [0x0f,0x45,0xc2]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i32 %mask, 8
  %tobool = icmp ne i32 %and, 0
  %cond = select i1 %tobool, i32 %intra, i32 %base
  ret i32 %cond
}

define i32 @test14(i32 %mask, i32 %base, i32 %intra) {
; CHECK-LABEL: test14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax # encoding: [0x89,0xf0]
; CHECK-NEXT:    shrl $7, %edi # encoding: [0xc1,0xef,0x07]
; CHECK-NEXT:    cmovnsl %edx, %eax # encoding: [0x0f,0x49,0xc2]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %s = lshr i32 %mask, 7
  %tobool = icmp sgt i32 %s, -1
  %cond = select i1 %tobool, i32 %intra, i32 %base
  ret i32 %cond
}

; PR19964
define zeroext i1 @test15(i32 %bf.load, i32 %n) {
; CHECK-LABEL: test15:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrl $16, %edi # encoding: [0xc1,0xef,0x10]
; CHECK-NEXT:    sete %cl # encoding: [0x0f,0x94,0xc1]
; CHECK-NEXT:    cmpl %esi, %edi # encoding: [0x39,0xf7]
; CHECK-NEXT:    setae %al # encoding: [0x0f,0x93,0xc0]
; CHECK-NEXT:    orb %cl, %al # encoding: [0x08,0xc8]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %bf.lshr = lshr i32 %bf.load, 16
  %cmp2 = icmp eq i32 %bf.lshr, 0
  %cmp5 = icmp uge i32 %bf.lshr, %n
  %.cmp5 = or i1 %cmp2, %cmp5
  ret i1 %.cmp5
}

define i8 @signbit_i16(i16 signext %L) {
; CHECK-LABEL: signbit_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testw %di, %di # encoding: [0x66,0x85,0xff]
; CHECK-NEXT:    setns %al # encoding: [0x0f,0x99,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %lshr = lshr i16 %L, 15
  %trunc = trunc i16 %lshr to i8
  %not = xor i8 %trunc, 1
  ret i8 %not
}

define i8 @signbit_i32(i32 %L) {
; CHECK-LABEL: signbit_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl %edi, %edi # encoding: [0x85,0xff]
; CHECK-NEXT:    setns %al # encoding: [0x0f,0x99,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %lshr = lshr i32 %L, 31
  %trunc = trunc i32 %lshr to i8
  %not = xor i8 %trunc, 1
  ret i8 %not
}

define i8 @signbit_i64(i64 %L) {
; CHECK-LABEL: signbit_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testq %rdi, %rdi # encoding: [0x48,0x85,0xff]
; CHECK-NEXT:    setns %al # encoding: [0x0f,0x99,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %lshr = lshr i64 %L, 63
  %trunc = trunc i64 %lshr to i8
  %not = xor i8 %trunc, 1
  ret i8 %not
}

define zeroext i1 @signbit_i32_i1(i32 %L) {
; CHECK-LABEL: signbit_i32_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl %edi, %edi # encoding: [0x85,0xff]
; CHECK-NEXT:    setns %al # encoding: [0x0f,0x99,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %lshr = lshr i32 %L, 31
  %trunc = trunc i32 %lshr to i1
  %not = xor i1 %trunc, true
  ret i1 %not
}

; This test failed due to incorrect handling of "shift + icmp" sequence
define void @test20(i32 %bf.load, i8 %x1, ptr %b_addr) {
; CHECK-LABEL: test20:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testl $16777215, %edi # encoding: [0xf7,0xc7,0xff,0xff,0xff,0x00]
; CHECK-NEXT:    # imm = 0xFFFFFF
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    movzbl %sil, %ecx # encoding: [0x40,0x0f,0xb6,0xce]
; CHECK-NEXT:    addl %eax, %ecx # encoding: [0x01,0xc1]
; CHECK-NEXT:    setne (%rdx) # encoding: [0x0f,0x95,0x02]
; CHECK-NEXT:    testl $16777215, %edi # encoding: [0xf7,0xc7,0xff,0xff,0xff,0x00]
; CHECK-NEXT:    # imm = 0xFFFFFF
; CHECK-NEXT:    setne d(%rip) # encoding: [0x0f,0x95,0x05,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 3, value: d-4, kind: reloc_riprel_4byte
; CHECK-NEXT:    retq # encoding: [0xc3]
  %bf.shl = shl i32 %bf.load, 8
  %bf.ashr = ashr exact i32 %bf.shl, 8
  %tobool4 = icmp ne i32 %bf.ashr, 0
  %conv = zext i1 %tobool4 to i32
  %conv6 = zext i8 %x1 to i32
  %add = add nuw nsw i32 %conv, %conv6
  %tobool7 = icmp ne i32 %add, 0
  %frombool = zext i1 %tobool7 to i8
  store i8 %frombool, ptr %b_addr, align 1
  %tobool14 = icmp ne i32 %bf.shl, 0
  %frombool15 = zext i1 %tobool14 to i8
  store i8 %frombool15, ptr @d, align 1
  ret void
}

define i32 @highmask_i64_simplify(i64 %val) {
; CHECK-LABEL: highmask_i64_simplify:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, -2199023255552
  %cmp = icmp ult i64 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @highmask_i64_mask64(i64 %val) {
; CHECK-LABEL: highmask_i64_mask64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    shrq $41, %rdi # encoding: [0x48,0xc1,0xef,0x29]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, -2199023255552
  %cmp = icmp ne i64 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i64 @highmask_i64_mask64_extra_use(i64 %val) nounwind {
; CHECK-LABEL: highmask_i64_mask64_extra_use:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    movq %rdi, %rcx # encoding: [0x48,0x89,0xf9]
; CHECK-NEXT:    shrq $41, %rcx # encoding: [0x48,0xc1,0xe9,0x29]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    imulq %rdi, %rax # encoding: [0x48,0x0f,0xaf,0xc7]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, -2199023255552
  %cmp = icmp ne i64 %and, 0
  %z = zext i1 %cmp to i64
  %ret = mul i64 %z, %val
  ret i64 %ret
}

define i32 @highmask_i64_mask32(i64 %val) {
; CHECK-LABEL: highmask_i64_mask32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    shrq $20, %rdi # encoding: [0x48,0xc1,0xef,0x14]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, -1048576
  %cmp = icmp eq i64 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i64 @highmask_i64_mask32_extra_use(i64 %val) nounwind {
; CHECK-LABEL: highmask_i64_mask32_extra_use:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testq $-1048576, %rdi # encoding: [0x48,0xf7,0xc7,0x00,0x00,0xf0,0xff]
; CHECK-NEXT:    # imm = 0xFFF00000
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    imulq %rdi, %rax # encoding: [0x48,0x0f,0xaf,0xc7]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, -1048576
  %cmp = icmp eq i64 %and, 0
  %z = zext i1 %cmp to i64
  %ret = mul i64 %z, %val
  ret i64 %ret
}

define i32 @highmask_i64_mask8(i64 %val) {
; CHECK-LABEL: highmask_i64_mask8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testq $-16, %rdi # encoding: [0x48,0xf7,0xc7,0xf0,0xff,0xff,0xff]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, -16
  %cmp = icmp ne i64 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @lowmask_i64_mask64(i64 %val) {
; CHECK-LABEL: lowmask_i64_mask64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    shlq $16, %rdi # encoding: [0x48,0xc1,0xe7,0x10]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, 281474976710655
  %cmp = icmp eq i64 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i64 @lowmask_i64_mask64_extra_use(i64 %val) nounwind {
; CHECK-LABEL: lowmask_i64_mask64_extra_use:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    movq %rdi, %rcx # encoding: [0x48,0x89,0xf9]
; CHECK-NEXT:    shlq $16, %rcx # encoding: [0x48,0xc1,0xe1,0x10]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    imulq %rdi, %rax # encoding: [0x48,0x0f,0xaf,0xc7]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, 281474976710655
  %cmp = icmp eq i64 %and, 0
  %z = zext i1 %cmp to i64
  %ret = mul i64 %z, %val
  ret i64 %ret
}

define i32 @lowmask_i64_mask32(i64 %val) {
; CHECK-LABEL: lowmask_i64_mask32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    shlq $44, %rdi # encoding: [0x48,0xc1,0xe7,0x2c]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, 1048575
  %cmp = icmp ne i64 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i64 @lowmask_i64_mask32_extra_use(i64 %val) nounwind {
; CHECK-LABEL: lowmask_i64_mask32_extra_use:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testl $1048575, %edi # encoding: [0xf7,0xc7,0xff,0xff,0x0f,0x00]
; CHECK-NEXT:    # imm = 0xFFFFF
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    imulq %rdi, %rax # encoding: [0x48,0x0f,0xaf,0xc7]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, 1048575
  %cmp = icmp ne i64 %and, 0
  %z = zext i1 %cmp to i64
  %ret = mul i64 %z, %val
  ret i64 %ret
}

define i32 @lowmask_i64_mask8(i64 %val) {
; CHECK-LABEL: lowmask_i64_mask8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testb $31, %dil # encoding: [0x40,0xf6,0xc7,0x1f]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i64 %val, 31
  %cmp = icmp eq i64 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @highmask_i32_mask32(i32 %val) {
; CHECK-LABEL: highmask_i32_mask32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testl $-1048576, %edi # encoding: [0xf7,0xc7,0x00,0x00,0xf0,0xff]
; CHECK-NEXT:    # imm = 0xFFF00000
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i32 %val, -1048576
  %cmp = icmp ne i32 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @highmask_i32_mask8(i32 %val) {
; CHECK-LABEL: highmask_i32_mask8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testl $-16, %edi # encoding: [0xf7,0xc7,0xf0,0xff,0xff,0xff]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i32 %val, -16
  %cmp = icmp eq i32 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @lowmask_i32_mask32(i32 %val) {
; CHECK-LABEL: lowmask_i32_mask32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testl $1048575, %edi # encoding: [0xf7,0xc7,0xff,0xff,0x0f,0x00]
; CHECK-NEXT:    # imm = 0xFFFFF
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i32 %val, 1048575
  %cmp = icmp eq i32 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @lowmask_i32_mask8(i32 %val) {
; CHECK-LABEL: lowmask_i32_mask8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testb $31, %dil # encoding: [0x40,0xf6,0xc7,0x1f]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %and = and i32 %val, 31
  %cmp = icmp ne i32 %and, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i1 @shifted_mask64_testb(i64 %a) {
; CHECK-LABEL: shifted_mask64_testb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrq $50, %rdi # encoding: [0x48,0xc1,0xef,0x32]
; CHECK-NEXT:    testb %dil, %dil # encoding: [0x40,0x84,0xff]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 287104476244869120  ; 0xff << 50
  %v1 = icmp ne i64 %v0, 0
  ret i1 %v1
}

define i1 @shifted_mask64_testw(i64 %a) {
; CHECK-LABEL: shifted_mask64_testw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrq $33, %rdi # encoding: [0x48,0xc1,0xef,0x21]
; CHECK-NEXT:    testw %di, %di # encoding: [0x66,0x85,0xff]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 562941363486720  ; 0xffff << 33
  %v1 = icmp ne i64 %v0, 0
  ret i1 %v1
}

define i1 @shifted_mask64_testl(i64 %a) {
; CHECK-LABEL: shifted_mask64_testl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrq $7, %rdi # encoding: [0x48,0xc1,0xef,0x07]
; CHECK-NEXT:    testl %edi, %edi # encoding: [0x85,0xff]
; CHECK-NEXT:    sete %al # encoding: [0x0f,0x94,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 549755813760  ; 0xffffffff << 7
  %v1 = icmp eq i64 %v0, 0
  ret i1 %v1
}

define i1 @shifted_mask64_extra_use_const(i64 %a) {
; CHECK-LABEL: shifted_mask64_extra_use_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movabsq $287104476244869120, %rcx # encoding: [0x48,0xb9,0x00,0x00,0x00,0x00,0x00,0x00,0xfc,0x03]
; CHECK-NEXT:    # imm = 0x3FC000000000000
; CHECK-NEXT:    testq %rcx, %rdi # encoding: [0x48,0x85,0xcf]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    movq %rcx, d64(%rip) # encoding: [0x48,0x89,0x0d,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 3, value: d64-4, kind: reloc_riprel_4byte
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 287104476244869120  ; 0xff << 50
  %v1 = icmp ne i64 %v0, 0
  store i64 287104476244869120, ptr @d64
  ret i1 %v1
}

define i1 @shifted_mask64_extra_use_and(i64 %a) {
; CHECK-LABEL: shifted_mask64_extra_use_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movabsq $287104476244869120, %rcx # encoding: [0x48,0xb9,0x00,0x00,0x00,0x00,0x00,0x00,0xfc,0x03]
; CHECK-NEXT:    # imm = 0x3FC000000000000
; CHECK-NEXT:    andq %rdi, %rcx # encoding: [0x48,0x21,0xf9]
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    movq %rcx, d64(%rip) # encoding: [0x48,0x89,0x0d,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 3, value: d64-4, kind: reloc_riprel_4byte
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 287104476244869120  ; 0xff << 50
  %v1 = icmp ne i64 %v0, 0
  store i64 %v0, ptr @d64
  ret i1 %v1
}

define i1 @shifted_mask32_testl_immediate(i64 %a) {
; CHECK-LABEL: shifted_mask32_testl_immediate:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $66846720, %edi # encoding: [0xf7,0xc7,0x00,0x00,0xfc,0x03]
; CHECK-NEXT:    # imm = 0x3FC0000
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 66846720  ; 0xff << 18
  %v1 = icmp ne i64 %v0, 0
  ret i1 %v1
}

define i1 @shifted_mask32_extra_use_const(i64 %a) {
; CHECK-LABEL: shifted_mask32_extra_use_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl $66846720, %edi # encoding: [0xf7,0xc7,0x00,0x00,0xfc,0x03]
; CHECK-NEXT:    # imm = 0x3FC0000
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    movq $66846720, d64(%rip) # encoding: [0x48,0xc7,0x05,A,A,A,A,0x00,0x00,0xfc,0x03]
; CHECK-NEXT:    # fixup A - offset: 3, value: d64-8, kind: reloc_riprel_4byte
; CHECK-NEXT:    # imm = 0x3FC0000
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 66846720  ; 0xff << 18
  %v1 = icmp ne i64 %v0, 0
  store i64 66846720, ptr @d64
  ret i1 %v1
}

define i1 @shifted_mask32_extra_use_and(i64 %a) {
; CHECK-LABEL: shifted_mask32_extra_use_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andq $66846720, %rdi # encoding: [0x48,0x81,0xe7,0x00,0x00,0xfc,0x03]
; CHECK-NEXT:    # imm = 0x3FC0000
; CHECK-NEXT:    setne %al # encoding: [0x0f,0x95,0xc0]
; CHECK-NEXT:    movq %rdi, d64(%rip) # encoding: [0x48,0x89,0x3d,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 3, value: d64-4, kind: reloc_riprel_4byte
; CHECK-NEXT:    retq # encoding: [0xc3]
  %v0 = and i64 %a, 66846720  ; 0xff << 50
  %v1 = icmp ne i64 %v0, 0
  store i64 %v0, ptr @d64
  ret i1 %v1
}

define { i64, i64 } @pr39968(i64, i64, i32) {
; CHECK-LABEL: pr39968:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK-NEXT:    testb $64, %dl # encoding: [0xf6,0xc2,0x40]
; CHECK-NEXT:    cmovneq %rdi, %rsi # encoding: [0x48,0x0f,0x45,0xf7]
; CHECK-NEXT:    cmovneq %rdi, %rax # encoding: [0x48,0x0f,0x45,0xc7]
; CHECK-NEXT:    movq %rsi, %rdx # encoding: [0x48,0x89,0xf2]
; CHECK-NEXT:    retq # encoding: [0xc3]
  %4 = and i32 %2, 64
  %5 = icmp ne i32 %4, 0
  %6 = select i1 %5, i64 %0, i64 %1
  %7 = select i1 %5, i64 %0, i64 0
  %8 = insertvalue { i64, i64 } undef, i64 %7, 0
  %9 = insertvalue { i64, i64 } %8, i64 %6, 1
  ret { i64, i64 } %9
}

; Make sure we use a 32-bit comparison without an extend based on the input
; being pre-sign extended by caller.
define i32 @pr42189(i16 signext %c) {
; CHECK-LABEL: pr42189:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpl $32767, %edi # encoding: [0x81,0xff,0xff,0x7f,0x00,0x00]
; CHECK-NEXT:    # imm = 0x7FFF
; CHECK-NEXT:    jne .LBB45_2 # encoding: [0x75,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: .LBB45_2-1, kind: FK_PCRel_1
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    jmp g@PLT # TAILCALL
; CHECK-NEXT:    # encoding: [0xeb,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: g@PLT-1, kind: FK_PCRel_1
; CHECK-NEXT:  .LBB45_2: # %if.end
; CHECK-NEXT:    jmp f@PLT # TAILCALL
; CHECK-NEXT:    # encoding: [0xeb,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: f@PLT-1, kind: FK_PCRel_1
entry:
  %cmp = icmp eq i16 %c, 32767
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call i32 @g()
  br label %return

if.end:                                           ; preds = %entry
  %call2 = tail call i32 @f()
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ %call2, %if.end ]
  ret i32 %retval.0
}

declare i32 @g()
declare i32 @f()
