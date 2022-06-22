; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s

declare { i8, i64 } @llvm.x86.subborrow.64(i8, i64, i64)
declare { i64, i1 } @llvm.usub.with.overflow.i64(i64, i64)

define i128 @sub128(i128 %a, i128 %b) nounwind {
; CHECK-LABEL: sub128:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    sbbq %rcx, %rsi
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    retq
entry:
  %0 = sub i128 %a, %b
  ret i128 %0
}

define i256 @sub256(i256 %a, i256 %b) nounwind {
; CHECK-LABEL: sub256:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %r9, %rsi
; CHECK-NEXT:    sbbq {{[0-9]+}}(%rsp), %rdx
; CHECK-NEXT:    sbbq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    sbbq {{[0-9]+}}(%rsp), %r8
; CHECK-NEXT:    movq %rcx, 16(%rdi)
; CHECK-NEXT:    movq %rdx, 8(%rdi)
; CHECK-NEXT:    movq %rsi, (%rdi)
; CHECK-NEXT:    movq %r8, 24(%rdi)
; CHECK-NEXT:    retq
entry:
  %0 = sub i256 %a, %b
  ret i256 %0
}

%S = type { [4 x i64] }

define %S @negate(ptr nocapture readonly %this) {
; CHECK-LABEL: negate:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    xorl %r8d, %r8d
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    subq (%rsi), %rdx
; CHECK-NEXT:    movl $0, %edi
; CHECK-NEXT:    sbbq 8(%rsi), %rdi
; CHECK-NEXT:    movl $0, %ecx
; CHECK-NEXT:    sbbq 16(%rsi), %rcx
; CHECK-NEXT:    sbbq 24(%rsi), %r8
; CHECK-NEXT:    movq %rdx, (%rax)
; CHECK-NEXT:    movq %rdi, 8(%rax)
; CHECK-NEXT:    movq %rcx, 16(%rax)
; CHECK-NEXT:    movq %r8, 24(%rax)
; CHECK-NEXT:    retq
entry:
  %0 = load i64, ptr %this, align 8
  %1 = xor i64 %0, -1
  %2 = zext i64 %1 to i128
  %3 = add nuw nsw i128 %2, 1
  %4 = trunc i128 %3 to i64
  %5 = lshr i128 %3, 64
  %6 = getelementptr inbounds %S, ptr %this, i64 0, i32 0, i64 1
  %7 = load i64, ptr %6, align 8
  %8 = xor i64 %7, -1
  %9 = zext i64 %8 to i128
  %10 = add nuw nsw i128 %5, %9
  %11 = trunc i128 %10 to i64
  %12 = lshr i128 %10, 64
  %13 = getelementptr inbounds %S, ptr %this, i64 0, i32 0, i64 2
  %14 = load i64, ptr %13, align 8
  %15 = xor i64 %14, -1
  %16 = zext i64 %15 to i128
  %17 = add nuw nsw i128 %12, %16
  %18 = lshr i128 %17, 64
  %19 = trunc i128 %17 to i64
  %20 = getelementptr inbounds %S, ptr %this, i64 0, i32 0, i64 3
  %21 = load i64, ptr %20, align 8
  %22 = xor i64 %21, -1
  %23 = zext i64 %22 to i128
  %24 = add nuw nsw i128 %18, %23
  %25 = trunc i128 %24 to i64
  %26 = insertvalue [4 x i64] undef, i64 %4, 0
  %27 = insertvalue [4 x i64] %26, i64 %11, 1
  %28 = insertvalue [4 x i64] %27, i64 %19, 2
  %29 = insertvalue [4 x i64] %28, i64 %25, 3
  %30 = insertvalue %S undef, [4 x i64] %29, 0
  ret %S %30
}

define %S @sub(ptr nocapture readonly %this, %S %arg.b) {
; CHECK-LABEL: sub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq (%rsi), %r10
; CHECK-NEXT:    movq 8(%rsi), %rdi
; CHECK-NEXT:    subq %rdx, %r10
; CHECK-NEXT:    setae %dl
; CHECK-NEXT:    addb $-1, %dl
; CHECK-NEXT:    adcq $0, %rdi
; CHECK-NEXT:    setb %dl
; CHECK-NEXT:    movzbl %dl, %r11d
; CHECK-NEXT:    notq %rcx
; CHECK-NEXT:    addq %rdi, %rcx
; CHECK-NEXT:    adcq 16(%rsi), %r11
; CHECK-NEXT:    setb %dl
; CHECK-NEXT:    movzbl %dl, %edx
; CHECK-NEXT:    notq %r8
; CHECK-NEXT:    addq %r11, %r8
; CHECK-NEXT:    adcq 24(%rsi), %rdx
; CHECK-NEXT:    notq %r9
; CHECK-NEXT:    addq %rdx, %r9
; CHECK-NEXT:    movq %r10, (%rax)
; CHECK-NEXT:    movq %rcx, 8(%rax)
; CHECK-NEXT:    movq %r8, 16(%rax)
; CHECK-NEXT:    movq %r9, 24(%rax)
; CHECK-NEXT:    retq
entry:
  %0 = extractvalue %S %arg.b, 0
  %.elt6 = extractvalue [4 x i64] %0, 1
  %.elt8 = extractvalue [4 x i64] %0, 2
  %.elt10 = extractvalue [4 x i64] %0, 3
  %.elt = extractvalue [4 x i64] %0, 0
  %1 = load i64, ptr %this, align 8
  %2 = zext i64 %1 to i128
  %3 = add nuw nsw i128 %2, 1
  %4 = xor i64 %.elt, -1
  %5 = zext i64 %4 to i128
  %6 = add nuw nsw i128 %3, %5
  %7 = trunc i128 %6 to i64
  %8 = lshr i128 %6, 64
  %9 = getelementptr inbounds %S, ptr %this, i64 0, i32 0, i64 1
  %10 = load i64, ptr %9, align 8
  %11 = zext i64 %10 to i128
  %12 = add nuw nsw i128 %8, %11
  %13 = xor i64 %.elt6, -1
  %14 = zext i64 %13 to i128
  %15 = add nuw nsw i128 %12, %14
  %16 = trunc i128 %15 to i64
  %17 = lshr i128 %15, 64
  %18 = getelementptr inbounds %S, ptr %this, i64 0, i32 0, i64 2
  %19 = load i64, ptr %18, align 8
  %20 = zext i64 %19 to i128
  %21 = add nuw nsw i128 %17, %20
  %22 = xor i64 %.elt8, -1
  %23 = zext i64 %22 to i128
  %24 = add nuw nsw i128 %21, %23
  %25 = lshr i128 %24, 64
  %26 = trunc i128 %24 to i64
  %27 = getelementptr inbounds %S, ptr %this, i64 0, i32 0, i64 3
  %28 = load i64, ptr %27, align 8
  %29 = zext i64 %28 to i128
  %30 = add nuw nsw i128 %25, %29
  %31 = xor i64 %.elt10, -1
  %32 = zext i64 %31 to i128
  %33 = add nuw nsw i128 %30, %32
  %34 = trunc i128 %33 to i64
  %35 = insertvalue [4 x i64] undef, i64 %7, 0
  %36 = insertvalue [4 x i64] %35, i64 %16, 1
  %37 = insertvalue [4 x i64] %36, i64 %26, 2
  %38 = insertvalue [4 x i64] %37, i64 %34, 3
  %39 = insertvalue %S undef, [4 x i64] %38, 0
  ret %S %39
}

declare {i64, i1} @llvm.uadd.with.overflow(i64, i64)
declare {i64, i1} @llvm.usub.with.overflow(i64, i64)

define i64 @sub_from_carry(i64 %x, i64 %y, ptr %valout, i64 %z) {
; CHECK-LABEL: sub_from_carry:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    negq %rax
; CHECK-NEXT:    addq %rsi, %rdi
; CHECK-NEXT:    movq %rdi, (%rdx)
; CHECK-NEXT:    adcq $0, %rax
; CHECK-NEXT:    retq
  %agg = call {i64, i1} @llvm.uadd.with.overflow(i64 %x, i64 %y)
  %val = extractvalue {i64, i1} %agg, 0
  %ov = extractvalue {i64, i1} %agg, 1
  store i64 %val, ptr %valout, align 4
  %carry = zext i1 %ov to i64
  %res = sub i64 %carry, %z
  ret i64 %res
}

; basic test for combineCarryDiamond()
define { i64, i64, i1 } @subcarry_2x64(i64 %x0, i64 %x1, i64 %y0, i64 %y1) nounwind {
; CHECK-LABEL: subcarry_2x64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    sbbq %rcx, %rsi
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    retq
  %t0 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x0, i64 %y0)
  %s0 = extractvalue { i64, i1 } %t0, 0
  %k0 = extractvalue { i64, i1 } %t0, 1

  %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x1, i64 %y1)
  %s1 = extractvalue { i64, i1 } %t1, 0
  %k1 = extractvalue { i64, i1 } %t1, 1

  %zk0 = zext i1 %k0 to i64
  %t2 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %s1, i64 %zk0)
  %s2 = extractvalue { i64, i1 } %t2, 0
  %k2 = extractvalue { i64, i1 } %t2, 1
  %k = or i1 %k1, %k2

  %r0 = insertvalue { i64, i64, i1 } poison, i64 %s0, 0
  %r1 = insertvalue { i64, i64, i1 } %r0, i64 %s2, 1
  %r = insertvalue { i64, i64, i1 } %r1, i1 %k, 2
  ret { i64, i64, i1 } %r
}

; basic test for combineCarryDiamond() with or operands reversed
define { i64, i64, i1 } @subcarry_2x64_or_reversed(i64 %x0, i64 %x1, i64 %y0, i64 %y1) nounwind {
; CHECK-LABEL: subcarry_2x64_or_reversed:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    sbbq %rcx, %rsi
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    retq
  %t0 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x0, i64 %y0)
  %s0 = extractvalue { i64, i1 } %t0, 0
  %k0 = extractvalue { i64, i1 } %t0, 1

  %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x1, i64 %y1)
  %s1 = extractvalue { i64, i1 } %t1, 0
  %k1 = extractvalue { i64, i1 } %t1, 1

  %zk0 = zext i1 %k0 to i64
  %t2 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %s1, i64 %zk0)
  %s2 = extractvalue { i64, i1 } %t2, 0
  %k2 = extractvalue { i64, i1 } %t2, 1
  %k = or i1 %k2, %k1  ; reverse natural order of operands

  %r0 = insertvalue { i64, i64, i1 } poison, i64 %s0, 0
  %r1 = insertvalue { i64, i64, i1 } %r0, i64 %s2, 1
  %r = insertvalue { i64, i64, i1 } %r1, i1 %k, 2
  ret { i64, i64, i1 } %r
}

; basic test for combineCarryDiamond() with xor operands reversed
define { i64, i64, i1 } @subcarry_2x64_xor_reversed(i64 %x0, i64 %x1, i64 %y0, i64 %y1) nounwind {
; CHECK-LABEL: subcarry_2x64_xor_reversed:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    sbbq %rcx, %rsi
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    retq
  %t0 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x0, i64 %y0)
  %s0 = extractvalue { i64, i1 } %t0, 0
  %k0 = extractvalue { i64, i1 } %t0, 1

  %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x1, i64 %y1)
  %s1 = extractvalue { i64, i1 } %t1, 0
  %k1 = extractvalue { i64, i1 } %t1, 1

  %zk0 = zext i1 %k0 to i64
  %t2 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %s1, i64 %zk0)
  %s2 = extractvalue { i64, i1 } %t2, 0
  %k2 = extractvalue { i64, i1 } %t2, 1
  %k = xor i1 %k2, %k1  ; reverse natural order of operands

  %r0 = insertvalue { i64, i64, i1 } poison, i64 %s0, 0
  %r1 = insertvalue { i64, i64, i1 } %r0, i64 %s2, 1
  %r = insertvalue { i64, i64, i1 } %r1, i1 %k, 2
  ret { i64, i64, i1 } %r
}

; basic test for combineCarryDiamond() with and operands reversed
define { i64, i64, i1 } @subcarry_2x64_and_reversed(i64 %x0, i64 %x1, i64 %y0, i64 %y1) nounwind {
; CHECK-LABEL: subcarry_2x64_and_reversed:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    sbbq %rcx, %rsi
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    retq
  %t0 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x0, i64 %y0)
  %s0 = extractvalue { i64, i1 } %t0, 0
  %k0 = extractvalue { i64, i1 } %t0, 1

  %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x1, i64 %y1)
  %s1 = extractvalue { i64, i1 } %t1, 0
  %k1 = extractvalue { i64, i1 } %t1, 1

  %zk0 = zext i1 %k0 to i64
  %t2 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %s1, i64 %zk0)
  %s2 = extractvalue { i64, i1 } %t2, 0
  %k2 = extractvalue { i64, i1 } %t2, 1
  %k = and i1 %k2, %k1  ; reverse natural order of operands

  %r0 = insertvalue { i64, i64, i1 } poison, i64 %s0, 0
  %r1 = insertvalue { i64, i64, i1 } %r0, i64 %s2, 1
  %r = insertvalue { i64, i64, i1 } %r1, i1 %k, 2
  ret { i64, i64, i1 } %r
}

; basic test for combineCarryDiamond() with add operands reversed
define { i64, i64, i1 } @subcarry_2x64_add_reversed(i64 %x0, i64 %x1, i64 %y0, i64 %y1) nounwind {
; CHECK-LABEL: subcarry_2x64_add_reversed:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq %rsi, %rdi
; CHECK-NEXT:    subq %rcx, %rdi
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    sbbq $0, %rdi
; CHECK-NEXT:    setb %r8b
; CHECK-NEXT:    cmpq %rcx, %rsi
; CHECK-NEXT:    adcb $0, %r8b
; CHECK-NEXT:    movq %rdi, %rdx
; CHECK-NEXT:    movl %r8d, %ecx
; CHECK-NEXT:    retq
  %t0 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x0, i64 %y0)
  %s0 = extractvalue { i64, i1 } %t0, 0
  %k0 = extractvalue { i64, i1 } %t0, 1

  %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %x1, i64 %y1)
  %s1 = extractvalue { i64, i1 } %t1, 0
  %k1 = extractvalue { i64, i1 } %t1, 1

  %zk0 = zext i1 %k0 to i64
  %t2 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %s1, i64 %zk0)
  %s2 = extractvalue { i64, i1 } %t2, 0
  %k2 = extractvalue { i64, i1 } %t2, 1
  %k = add i1 %k2, %k1  ; reverse natural order of operands

  %r0 = insertvalue { i64, i64, i1 } poison, i64 %s0, 0
  %r1 = insertvalue { i64, i64, i1 } %r0, i64 %s2, 1
  %r = insertvalue { i64, i64, i1 } %r1, i1 %k, 2
  ret { i64, i64, i1 } %r
}

; Here %carryin is considered as valid carry flag for combining into ADDCARRY
; although %carryin does not come from any carry-producing instruction.
define { i64, i1 } @subcarry_fake_carry(i64 %a, i64 %b, i1 %carryin) {
; CHECK-LABEL: subcarry_fake_carry:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    btl $0, %edx
; CHECK-NEXT:    sbbq %rsi, %rax
; CHECK-NEXT:    setb %dl
; CHECK-NEXT:    retq
    %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %a, i64 %b)
    %partial = extractvalue { i64, i1 } %t1, 0
    %k1 = extractvalue { i64, i1 } %t1, 1

    %zcarryin = zext i1 %carryin to i64
    %s = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %partial, i64 %zcarryin)
    %k2 = extractvalue { i64, i1 } %s, 1

    %carryout = or i1 %k1, %k2

    %ret = insertvalue { i64, i1 } %s, i1 %carryout, 1
    ret { i64, i1 } %ret
}

; negative test: %carryin does not look like carry
define { i64, i1 } @subcarry_carry_not_zext(i64 %a, i64 %b, i64 %carryin) {
; CHECK-LABEL: subcarry_carry_not_zext:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %rsi, %rax
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    setb %dl
; CHECK-NEXT:    orb %cl, %dl
; CHECK-NEXT:    retq
    %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %a, i64 %b)
    %partial = extractvalue { i64, i1 } %t1, 0
    %k1 = extractvalue { i64, i1 } %t1, 1

    %s = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %partial, i64 %carryin)
    %k2 = extractvalue { i64, i1 } %s, 1

    %carryout = or i1 %k1, %k2

    %ret = insertvalue { i64, i1 } %s, i1 %carryout, 1
    ret { i64, i1 } %ret
}

; negative test: %carryin does not look like carry
define { i64, i1 } @subcarry_carry_not_i1(i64 %a, i64 %b, i8 %carryin) {
; CHECK-LABEL: subcarry_carry_not_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edx killed $edx def $rdx
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    subq %rsi, %rax
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movzbl %dl, %edx
; CHECK-NEXT:    subq %rdx, %rax
; CHECK-NEXT:    setb %dl
; CHECK-NEXT:    orb %cl, %dl
; CHECK-NEXT:    retq
    %t1 = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %a, i64 %b)
    %partial = extractvalue { i64, i1 } %t1, 0
    %k1 = extractvalue { i64, i1 } %t1, 1

    %zcarryin = zext i8 %carryin to i64
    %s = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %partial, i64 %zcarryin)
    %k2 = extractvalue { i64, i1 } %s, 1

    %carryout = or i1 %k1, %k2

    %ret = insertvalue { i64, i1 } %s, i1 %carryout, 1
    ret { i64, i1 } %ret
}

%struct.U320 = type { [5 x i64] }

define i32 @sub_U320_without_i128_or(ptr nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: sub_U320_without_i128_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq %rsi, (%rdi)
; CHECK-NEXT:    sbbq %rdx, 8(%rdi)
; CHECK-NEXT:    sbbq %rcx, 16(%rdi)
; CHECK-NEXT:    sbbq %r8, 24(%rdi)
; CHECK-NEXT:    sbbq %r9, 32(%rdi)
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    retq
  %7 = load i64, ptr %0, align 8
  %8 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 1
  %9 = load i64, ptr %8, align 8
  %10 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 2
  %11 = load i64, ptr %10, align 8
  %12 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 3
  %13 = load i64, ptr %12, align 8
  %14 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 4
  %15 = load i64, ptr %14, align 8
  %16 = sub i64 %7, %1
  %17 = sub i64 %9, %2
  %18 = icmp ult i64 %7, %1
  %19 = zext i1 %18 to i64
  %20 = sub i64 %17, %19
  %21 = sub i64 %11, %3
  %22 = icmp ult i64 %9, %2
  %23 = icmp ult i64 %17, %19
  %24 = or i1 %22, %23
  %25 = zext i1 %24 to i64
  %26 = sub i64 %21, %25
  %27 = sub i64 %13, %4
  %28 = icmp ult i64 %11, %3
  %29 = icmp ult i64 %21, %25
  %30 = or i1 %28, %29
  %31 = zext i1 %30 to i64
  %32 = sub i64 %27, %31
  %33 = sub i64 %15, %5
  %34 = icmp ult i64 %13, %4
  %35 = icmp ult i64 %27, %31
  %36 = or i1 %34, %35
  %37 = zext i1 %36 to i64
  %38 = sub i64 %33, %37
  store i64 %16, ptr %0, align 8
  store i64 %20, ptr %8, align 8
  store i64 %26, ptr %10, align 8
  store i64 %32, ptr %12, align 8
  store i64 %38, ptr %14, align 8
  %39 = icmp ult i64 %15, %5
  %40 = icmp ult i64 %33, %37
  %41 = or i1 %39, %40
  %42 = zext i1 %41 to i32
  ret i32 %42
}

define i32 @sub_U320_usubo(ptr nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: sub_U320_usubo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq %rsi, (%rdi)
; CHECK-NEXT:    sbbq %rdx, 8(%rdi)
; CHECK-NEXT:    sbbq %rcx, 16(%rdi)
; CHECK-NEXT:    sbbq %r8, 24(%rdi)
; CHECK-NEXT:    sbbq %r9, 32(%rdi)
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    retq
  %7 = load i64, ptr %0, align 8
  %8 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 1
  %9 = load i64, ptr %8, align 8
  %10 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 2
  %11 = load i64, ptr %10, align 8
  %12 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 3
  %13 = load i64, ptr %12, align 8
  %14 = getelementptr inbounds %struct.U320, ptr %0, i64 0, i32 0, i64 4
  %15 = load i64, ptr %14, align 8
  %16 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %7, i64 %1)
  %17 = extractvalue { i64, i1 } %16, 1
  %18 = extractvalue { i64, i1 } %16, 0
  %19 = zext i1 %17 to i64
  %20 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %9, i64 %2)
  %21 = extractvalue { i64, i1 } %20, 1
  %22 = extractvalue { i64, i1 } %20, 0
  %23 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %22, i64 %19)
  %24 = extractvalue { i64, i1 } %23, 1
  %25 = extractvalue { i64, i1 } %23, 0
  %26 = or i1 %21, %24
  %27 = zext i1 %26 to i64
  %28 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %11, i64 %3)
  %29 = extractvalue { i64, i1 } %28, 1
  %30 = extractvalue { i64, i1 } %28, 0
  %31 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %30, i64 %27)
  %32 = extractvalue { i64, i1 } %31, 1
  %33 = extractvalue { i64, i1 } %31, 0
  %34 = or i1 %29, %32
  %35 = zext i1 %34 to i64
  %36 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %13, i64 %4)
  %37 = extractvalue { i64, i1 } %36, 1
  %38 = extractvalue { i64, i1 } %36, 0
  %39 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %38, i64 %35)
  %40 = extractvalue { i64, i1 } %39, 1
  %41 = extractvalue { i64, i1 } %39, 0
  %42 = or i1 %37, %40
  %43 = zext i1 %42 to i64
  %44 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %15, i64 %5)
  %45 = extractvalue { i64, i1 } %44, 1
  %46 = extractvalue { i64, i1 } %44, 0
  %47 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %46, i64 %43)
  %48 = extractvalue { i64, i1 } %47, 1
  %49 = extractvalue { i64, i1 } %47, 0
  %50 = or i1 %45, %48
  store i64 %18, ptr %0, align 8
  store i64 %25, ptr %8, align 8
  store i64 %33, ptr %10, align 8
  store i64 %41, ptr %12, align 8
  store i64 %49, ptr %14, align 8
  %51 = zext i1 %50 to i32
  ret i32 %51
}

%struct.U192 = type { [3 x i64] }

define void @PR39464(ptr noalias nocapture sret(%struct.U192) %0, ptr nocapture readonly dereferenceable(24) %1, ptr nocapture readonly dereferenceable(24) %2) {
; CHECK-LABEL: PR39464:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq (%rsi), %rcx
; CHECK-NEXT:    subq (%rdx), %rcx
; CHECK-NEXT:    movq %rcx, (%rdi)
; CHECK-NEXT:    movq 8(%rsi), %rcx
; CHECK-NEXT:    sbbq 8(%rdx), %rcx
; CHECK-NEXT:    movq %rcx, 8(%rdi)
; CHECK-NEXT:    movq 16(%rsi), %rcx
; CHECK-NEXT:    sbbq 16(%rdx), %rcx
; CHECK-NEXT:    movq %rcx, 16(%rdi)
; CHECK-NEXT:    retq
  %4 = load i64, ptr %1, align 8
  %5 = load i64, ptr %2, align 8
  %6 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %4, i64 %5)
  %7 = extractvalue { i64, i1 } %6, 1
  %8 = extractvalue { i64, i1 } %6, 0
  %9 = zext i1 %7 to i64
  store i64 %8, ptr %0, align 8
  %10 = getelementptr inbounds %struct.U192, ptr %1, i64 0, i32 0, i64 1
  %11 = load i64, ptr %10, align 8
  %12 = getelementptr inbounds %struct.U192, ptr %2, i64 0, i32 0, i64 1
  %13 = load i64, ptr %12, align 8
  %14 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %11, i64 %13)
  %15 = extractvalue { i64, i1 } %14, 1
  %16 = extractvalue { i64, i1 } %14, 0
  %17 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %16, i64 %9)
  %18 = extractvalue { i64, i1 } %17, 1
  %19 = extractvalue { i64, i1 } %17, 0
  %20 = or i1 %15, %18
  %21 = zext i1 %20 to i64
  %22 = getelementptr inbounds %struct.U192, ptr %0, i64 0, i32 0, i64 1
  store i64 %19, ptr %22, align 8
  %23 = getelementptr inbounds %struct.U192, ptr %1, i64 0, i32 0, i64 2
  %24 = load i64, ptr %23, align 8
  %25 = getelementptr inbounds %struct.U192, ptr %2, i64 0, i32 0, i64 2
  %26 = load i64, ptr %25, align 8
  %27 = sub i64 %24, %26
  %28 = sub i64 %27, %21
  %29 = getelementptr inbounds %struct.U192, ptr %0, i64 0, i32 0, i64 2
  store i64 %28, ptr %29, align 8
  ret void
}

%uint128 = type { i64, i64 }
%uint256 = type { %uint128, %uint128 }

; The 256-bit subtraction implementation using two inlined usubo procedures for U128 type { i64, i64 }.
; This is similar to how LLVM legalize types in CodeGen.
define void @sub_U256_without_i128_or_recursive(ptr sret(%uint256) %0, ptr %1, ptr %2) nounwind {
; CHECK-LABEL: sub_U256_without_i128_or_recursive:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq (%rsi), %r8
; CHECK-NEXT:    movq 8(%rsi), %r9
; CHECK-NEXT:    movq 16(%rsi), %rcx
; CHECK-NEXT:    movq 24(%rsi), %rsi
; CHECK-NEXT:    xorl %edi, %edi
; CHECK-NEXT:    subq 16(%rdx), %rcx
; CHECK-NEXT:    setb %dil
; CHECK-NEXT:    subq 24(%rdx), %rsi
; CHECK-NEXT:    subq (%rdx), %r8
; CHECK-NEXT:    sbbq 8(%rdx), %r9
; CHECK-NEXT:    sbbq $0, %rcx
; CHECK-NEXT:    sbbq %rdi, %rsi
; CHECK-NEXT:    movq %r8, (%rax)
; CHECK-NEXT:    movq %r9, 8(%rax)
; CHECK-NEXT:    movq %rcx, 16(%rax)
; CHECK-NEXT:    movq %rsi, 24(%rax)
; CHECK-NEXT:    retq
  %4 = load i64, ptr %1, align 8
  %5 = getelementptr inbounds %uint256, ptr %1, i64 0, i32 0, i32 1
  %6 = load i64, ptr %5, align 8
  %7 = load i64, ptr %2, align 8
  %8 = getelementptr inbounds %uint256, ptr %2, i64 0, i32 0, i32 1
  %9 = load i64, ptr %8, align 8
  %10 = sub i64 %4, %7
  %11 = icmp ult i64 %4, %7
  %12 = sub i64 %6, %9
  %13 = icmp ult i64 %6, %9
  %14 = zext i1 %11 to i64
  %15 = sub i64 %12, %14
  %16 = icmp ult i64 %12, %14
  %17 = or i1 %13, %16
  %18 = getelementptr inbounds %uint256, ptr %1, i64 0, i32 1, i32 0
  %19 = load i64, ptr %18, align 8
  %20 = getelementptr inbounds %uint256, ptr %1, i64 0, i32 1, i32 1
  %21 = load i64, ptr %20, align 8
  %22 = getelementptr inbounds %uint256, ptr %2, i64 0, i32 1, i32 0
  %23 = load i64, ptr %22, align 8
  %24 = getelementptr inbounds %uint256, ptr %2, i64 0, i32 1, i32 1
  %25 = load i64, ptr %24, align 8
  %26 = sub i64 %19, %23
  %27 = icmp ult i64 %19, %23
  %28 = sub i64 %21, %25
  %29 = zext i1 %27 to i64
  %30 = sub i64 %28, %29
  %31 = zext i1 %17 to i64
  %32 = sub i64 %26, %31
  %33 = icmp ult i64 %26, %31
  %34 = zext i1 %33 to i64
  %35 = sub i64 %30, %34
  store i64 %10, ptr %0, align 8
  %36 = getelementptr inbounds %uint256, ptr %0, i64 0, i32 0, i32 1
  store i64 %15, ptr %36, align 8
  %37 = getelementptr inbounds %uint256, ptr %0, i64 0, i32 1, i32 0
  store i64 %32, ptr %37, align 8
  %38 = getelementptr inbounds %uint256, ptr %0, i64 0, i32 1, i32 1
  store i64 %35, ptr %38, align 8
  ret void
}

define i1 @subcarry_ult_2x64(i64 %x0, i64 %x1, i64 %y0, i64 %y1) nounwind {
; CHECK-LABEL: subcarry_ult_2x64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq %rcx, %rsi
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    cmpq %rdx, %rdi
; CHECK-NEXT:    sbbq $0, %rsi
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    orb %cl, %al
; CHECK-NEXT:    retq
  %b0 = icmp ult i64 %x0, %y0
  %d1 = sub i64 %x1, %y1
  %b10 = icmp ult i64 %x1, %y1
  %b0z = zext i1 %b0 to i64
  %b11 = icmp ult i64 %d1, %b0z
  %b1 = or i1 %b10, %b11
  ret i1 %b1
}
