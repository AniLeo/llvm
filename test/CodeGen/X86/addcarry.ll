; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s

declare { i8, i64 } @llvm.x86.addcarry.64(i8, i64, i64)
declare { i64, i1 } @llvm.uadd.with.overflow.i64(i64, i64) #1

define i128 @add128(i128 %a, i128 %b) nounwind {
; CHECK-LABEL: add128:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    addq %rdx, %rax
; CHECK-NEXT:    adcq %rcx, %rsi
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    retq
entry:
  %0 = add i128 %a, %b
  ret i128 %0
}

define void @add128_rmw(i128* %a, i128 %b) nounwind {
; CHECK-LABEL: add128_rmw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    retq
entry:
  %0 = load i128, i128* %a
  %1 = add i128 %0, %b
  store i128 %1, i128* %a
  ret void
}

define void @add128_rmw2(i128 %a, i128* %b) nounwind {
; CHECK-LABEL: add128_rmw2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rdi, (%rdx)
; CHECK-NEXT:    adcq %rsi, 8(%rdx)
; CHECK-NEXT:    retq
entry:
  %0 = load i128, i128* %b
  %1 = add i128 %a, %0
  store i128 %1, i128* %b
  ret void
}

define i256 @add256(i256 %a, i256 %b) nounwind {
; CHECK-LABEL: add256:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    addq %r9, %rsi
; CHECK-NEXT:    adcq {{[0-9]+}}(%rsp), %rdx
; CHECK-NEXT:    adcq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    adcq {{[0-9]+}}(%rsp), %r8
; CHECK-NEXT:    movq %rdx, 8(%rdi)
; CHECK-NEXT:    movq %rsi, (%rdi)
; CHECK-NEXT:    movq %rcx, 16(%rdi)
; CHECK-NEXT:    movq %r8, 24(%rdi)
; CHECK-NEXT:    retq
entry:
  %0 = add i256 %a, %b
  ret i256 %0
}

define void @add256_rmw(i256* %a, i256 %b) nounwind {
; CHECK-LABEL: add256_rmw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    adcq %rcx, 16(%rdi)
; CHECK-NEXT:    adcq %r8, 24(%rdi)
; CHECK-NEXT:    retq
entry:
  %0 = load i256, i256* %a
  %1 = add i256 %0, %b
  store i256 %1, i256* %a
  ret void
}

define void @add256_rmw2(i256 %a, i256* %b) nounwind {
; CHECK-LABEL: add256_rmw2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rdi, (%r8)
; CHECK-NEXT:    adcq %rsi, 8(%r8)
; CHECK-NEXT:    adcq %rdx, 16(%r8)
; CHECK-NEXT:    adcq %rcx, 24(%r8)
; CHECK-NEXT:    retq
entry:
  %0 = load i256, i256* %b
  %1 = add i256 %a, %0
  store i256 %1, i256* %b
  ret void
}

define void @a(i64* nocapture %s, i64* nocapture %t, i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: a:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rcx, %rdx
; CHECK-NEXT:    adcq $0, %r8
; CHECK-NEXT:    movq %r8, (%rdi)
; CHECK-NEXT:    movq %rdx, (%rsi)
; CHECK-NEXT:    retq
entry:
 %0 = zext i64 %a to i128
 %1 = zext i64 %b to i128
 %2 = add i128 %1, %0
 %3 = zext i64 %c to i128
 %4 = shl i128 %3, 64
 %5 = add i128 %4, %2
 %6 = lshr i128 %5, 64
 %7 = trunc i128 %6 to i64
 store i64 %7, i64* %s, align 8
 %8 = trunc i128 %2 to i64
 store i64 %8, i64* %t, align 8
 ret void
}

define void @b(i32* nocapture %r, i64 %a, i64 %b, i32 %c) nounwind {
; CHECK-LABEL: b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rdx, %rsi
; CHECK-NEXT:    adcl $0, %ecx
; CHECK-NEXT:    movl %ecx, (%rdi)
; CHECK-NEXT:    retq
entry:
 %0 = zext i64 %a to i128
 %1 = zext i64 %b to i128
 %2 = zext i32 %c to i128
 %3 = add i128 %1, %0
 %4 = lshr i128 %3, 64
 %5 = add i128 %4, %2
 %6 = trunc i128 %5 to i32
 store i32 %6, i32* %r, align 4
 ret void
}

define void @c(i16* nocapture %r, i64 %a, i64 %b, i16 %c) nounwind {
; CHECK-LABEL: c:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rdx, %rsi
; CHECK-NEXT:    adcw $0, %cx
; CHECK-NEXT:    movw %cx, (%rdi)
; CHECK-NEXT:    retq
entry:
 %0 = zext i64 %a to i128
 %1 = zext i64 %b to i128
 %2 = zext i16 %c to i128
 %3 = add i128 %1, %0
 %4 = lshr i128 %3, 64
 %5 = add i128 %4, %2
 %6 = trunc i128 %5 to i16
 store i16 %6, i16* %r, align 4
 ret void
}

define void @d(i8* nocapture %r, i64 %a, i64 %b, i8 %c) nounwind {
; CHECK-LABEL: d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq %rdx, %rsi
; CHECK-NEXT:    adcb $0, %cl
; CHECK-NEXT:    movb %cl, (%rdi)
; CHECK-NEXT:    retq
entry:
 %0 = zext i64 %a to i128
 %1 = zext i64 %b to i128
 %2 = zext i8 %c to i128
 %3 = add i128 %1, %0
 %4 = lshr i128 %3, 64
 %5 = add i128 %4, %2
 %6 = trunc i128 %5 to i8
 store i8 %6, i8* %r, align 4
 ret void
}

define i8 @e(i32* nocapture %a, i32 %b) nounwind {
; CHECK-LABEL: e:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    movl (%rdi), %ecx
; CHECK-NEXT:    leal (%rsi,%rcx), %edx
; CHECK-NEXT:    addl %esi, %edx
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    addl %esi, %ecx
; CHECK-NEXT:    movl %edx, (%rdi)
; CHECK-NEXT:    adcb $0, %al
; CHECK-NEXT:    retq
  %1 = load i32, i32* %a, align 4
  %2 = add i32 %1, %b
  %3 = icmp ult i32 %2, %b
  %4 = zext i1 %3 to i8
  %5 = add i32 %2, %b
  store i32 %5, i32* %a, align 4
  %6 = icmp ult i32 %5, %b
  %7 = zext i1 %6 to i8
  %8 = add nuw nsw i8 %7, %4
  ret i8 %8
}

%scalar = type { [4 x i64] }

define %scalar @pr31719(%scalar* nocapture readonly %this, %scalar %arg.b) {
; CHECK-LABEL: pr31719:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    addq (%rsi), %rdx
; CHECK-NEXT:    adcq 8(%rsi), %rcx
; CHECK-NEXT:    adcq 16(%rsi), %r8
; CHECK-NEXT:    adcq 24(%rsi), %r9
; CHECK-NEXT:    movq %rdx, (%rdi)
; CHECK-NEXT:    movq %rcx, 8(%rdi)
; CHECK-NEXT:    movq %r8, 16(%rdi)
; CHECK-NEXT:    movq %r9, 24(%rdi)
; CHECK-NEXT:    retq
entry:
  %0 = extractvalue %scalar %arg.b, 0
  %.elt = extractvalue [4 x i64] %0, 0
  %.elt24 = extractvalue [4 x i64] %0, 1
  %.elt26 = extractvalue [4 x i64] %0, 2
  %.elt28 = extractvalue [4 x i64] %0, 3
  %1 = getelementptr inbounds %scalar , %scalar* %this, i64 0, i32 0, i64 0
  %2 = load i64, i64* %1, align 8
  %3 = zext i64 %2 to i128
  %4 = zext i64 %.elt to i128
  %5 = add nuw nsw i128 %3, %4
  %6 = trunc i128 %5 to i64
  %7 = lshr i128 %5, 64
  %8 = getelementptr inbounds %scalar , %scalar * %this, i64 0, i32 0, i64 1
  %9 = load i64, i64* %8, align 8
  %10 = zext i64 %9 to i128
  %11 = zext i64 %.elt24 to i128
  %12 = add nuw nsw i128 %10, %11
  %13 = add nuw nsw i128 %12, %7
  %14 = trunc i128 %13 to i64
  %15 = lshr i128 %13, 64
  %16 = getelementptr inbounds %scalar , %scalar* %this, i64 0, i32 0, i64 2
  %17 = load i64, i64* %16, align 8
  %18 = zext i64 %17 to i128
  %19 = zext i64 %.elt26 to i128
  %20 = add nuw nsw i128 %18, %19
  %21 = add nuw nsw i128 %20, %15
  %22 = trunc i128 %21 to i64
  %23 = lshr i128 %21, 64
  %24 = getelementptr inbounds %scalar , %scalar* %this, i64 0, i32 0, i64 3
  %25 = load i64, i64* %24, align 8
  %26 = zext i64 %25 to i128
  %27 = zext i64 %.elt28 to i128
  %28 = add nuw nsw i128 %26, %27
  %29 = add nuw nsw i128 %28, %23
  %30 = trunc i128 %29 to i64
  %31 = insertvalue [4 x i64] undef, i64 %6, 0
  %32 = insertvalue [4 x i64] %31, i64 %14, 1
  %33 = insertvalue [4 x i64] %32, i64 %22, 2
  %34 = insertvalue [4 x i64] %33, i64 %30, 3
  %35 = insertvalue %scalar undef, [4 x i64] %34, 0
  ret %scalar %35
}

%accumulator= type { i64, i64, i32 }

define void @muladd(%accumulator* nocapture %this, i64 %arg.a, i64 %arg.b) {
; CHECK-LABEL: muladd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    mulq %rsi
; CHECK-NEXT:    addq %rax, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    adcl $0, 16(%rdi)
; CHECK-NEXT:    retq
entry:
  %0 = zext i64 %arg.a to i128
  %1 = zext i64 %arg.b to i128
  %2 = mul nuw i128 %1, %0
  %3 = getelementptr inbounds %accumulator, %accumulator* %this, i64 0, i32 0
  %4 = load i64, i64* %3, align 8
  %5 = zext i64 %4 to i128
  %6 = add i128 %5, %2
  %7 = trunc i128 %6 to i64
  store i64 %7, i64* %3, align 8
  %8 = lshr i128 %6, 64
  %9 = getelementptr inbounds %accumulator, %accumulator* %this, i64 0, i32 1
  %10 = load i64, i64* %9, align 8
  %11 = zext i64 %10 to i128
  %12 = add nuw nsw i128 %8, %11
  %13 = trunc i128 %12 to i64
  store i64 %13, i64* %9, align 8
  %14 = lshr i128 %12, 64
  %15 = getelementptr inbounds %accumulator, %accumulator* %this, i64 0, i32 2
  %16 = load i32, i32* %15, align 4
  %17 = zext i32 %16 to i128
  %18 = add nuw nsw i128 %14, %17
  %19 = trunc i128 %18 to i32
  store i32 %19, i32* %15, align 4
  ret void
}

define i64 @shiftadd(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: shiftadd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    addq %rsi, %rdi
; CHECK-NEXT:    adcq %rcx, %rax
; CHECK-NEXT:    retq
entry:
  %0 = zext i64 %a to i128
  %1 = zext i64 %b to i128
  %2 = add i128 %0, %1
  %3 = lshr i128 %2, 64
  %4 = trunc i128 %3 to i64
  %5 = add i64 %c, %d
  %6 = add i64 %4, %5
  ret i64 %6
}

%S = type { [4 x i64] }

define %S @readd(%S* nocapture readonly %this, %S %arg.b) {
; CHECK-LABEL: readd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    addq (%rsi), %rdx
; CHECK-NEXT:    movq 8(%rsi), %r11
; CHECK-NEXT:    adcq $0, %r11
; CHECK-NEXT:    setb %r10b
; CHECK-NEXT:    movzbl %r10b, %edi
; CHECK-NEXT:    addq %rcx, %r11
; CHECK-NEXT:    adcq 16(%rsi), %rdi
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movzbl %cl, %ecx
; CHECK-NEXT:    addq %r8, %rdi
; CHECK-NEXT:    adcq 24(%rsi), %rcx
; CHECK-NEXT:    addq %r9, %rcx
; CHECK-NEXT:    movq %rdx, (%rax)
; CHECK-NEXT:    movq %r11, 8(%rax)
; CHECK-NEXT:    movq %rdi, 16(%rax)
; CHECK-NEXT:    movq %rcx, 24(%rax)
; CHECK-NEXT:    retq
entry:
  %0 = extractvalue %S %arg.b, 0
  %.elt6 = extractvalue [4 x i64] %0, 1
  %.elt8 = extractvalue [4 x i64] %0, 2
  %.elt10 = extractvalue [4 x i64] %0, 3
  %.elt = extractvalue [4 x i64] %0, 0
  %1 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 0
  %2 = load i64, i64* %1, align 8
  %3 = zext i64 %2 to i128
  %4 = zext i64 %.elt to i128
  %5 = add nuw nsw i128 %3, %4
  %6 = trunc i128 %5 to i64
  %7 = lshr i128 %5, 64
  %8 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 1
  %9 = load i64, i64* %8, align 8
  %10 = zext i64 %9 to i128
  %11 = add nuw nsw i128 %7, %10
  %12 = zext i64 %.elt6 to i128
  %13 = add nuw nsw i128 %11, %12
  %14 = trunc i128 %13 to i64
  %15 = lshr i128 %13, 64
  %16 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 2
  %17 = load i64, i64* %16, align 8
  %18 = zext i64 %17 to i128
  %19 = add nuw nsw i128 %15, %18
  %20 = zext i64 %.elt8 to i128
  %21 = add nuw nsw i128 %19, %20
  %22 = lshr i128 %21, 64
  %23 = trunc i128 %21 to i64
  %24 = getelementptr inbounds %S, %S* %this, i64 0,i32 0, i64 3
  %25 = load i64, i64* %24, align 8
  %26 = zext i64 %25 to i128
  %27 = add nuw nsw i128 %22, %26
  %28 = zext i64 %.elt10 to i128
  %29 = add nuw nsw i128 %27, %28
  %30 = trunc i128 %29 to i64
  %31 = insertvalue [4 x i64] undef, i64 %6, 0
  %32 = insertvalue [4 x i64] %31, i64 %14, 1
  %33 = insertvalue [4 x i64] %32, i64 %23, 2
  %34 = insertvalue [4 x i64] %33, i64 %30, 3
  %35 = insertvalue %S undef, [4 x i64] %34, 0
  ret %S %35
}

define i128 @addcarry1_not(i128 %n) {
; CHECK-LABEL: addcarry1_not:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    negq %rax
; CHECK-NEXT:    sbbq %rsi, %rdx
; CHECK-NEXT:    retq
  %1 = xor i128 %n, -1
  %2 = add i128 %1, 1
  ret i128 %2
}

define i128 @addcarry_to_subcarry(i64 %a, i64 %b) {
; CHECK-LABEL: addcarry_to_subcarry:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    notq %rsi
; CHECK-NEXT:    setae %cl
; CHECK-NEXT:    addb $-1, %cl
; CHECK-NEXT:    adcq $0, %rax
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movzbl %cl, %edx
; CHECK-NEXT:    addq %rsi, %rax
; CHECK-NEXT:    adcq $0, %rdx
; CHECK-NEXT:    retq
  %notb = xor i64 %b, -1
  %notb128 = zext i64 %notb to i128
  %a128 = zext i64 %a to i128
  %sum1 = add i128 %a128, 1
  %sub1 = add i128 %sum1, %notb128
  %hi = lshr i128 %sub1, 64
  %sum2 = add i128 %hi, %a128
  %sub2 = add i128 %sum2, %notb128
  ret i128 %sub2
}

%struct.U320 = type { [5 x i64] }

define i32 @add_U320_without_i128_add(%struct.U320* nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: add_U320_without_i128_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    .cfi_offset %rbx, -24
; CHECK-NEXT:    .cfi_offset %r14, -16
; CHECK-NEXT:    movq 16(%rdi), %rax
; CHECK-NEXT:    leaq (%rax,%rcx), %r10
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    movq %rax, %rdx
; CHECK-NEXT:    adcq %rcx, %rdx
; CHECK-NEXT:    movq 24(%rdi), %r11
; CHECK-NEXT:    leaq (%r8,%r11), %r14
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    cmpq %r10, %rdx
; CHECK-NEXT:    setb %bl
; CHECK-NEXT:    addq %rcx, %rax
; CHECK-NEXT:    adcq %r14, %rbx
; CHECK-NEXT:    movq 32(%rdi), %r10
; CHECK-NEXT:    leaq (%r9,%r10), %rcx
; CHECK-NEXT:    xorl %esi, %esi
; CHECK-NEXT:    cmpq %r14, %rbx
; CHECK-NEXT:    setb %sil
; CHECK-NEXT:    addq %r11, %r8
; CHECK-NEXT:    adcq %rcx, %rsi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpq %rcx, %rsi
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    addq %r10, %r9
; CHECK-NEXT:    movq %rdx, 16(%rdi)
; CHECK-NEXT:    movq %rbx, 24(%rdi)
; CHECK-NEXT:    movq %rsi, 32(%rdi)
; CHECK-NEXT:    adcl $0, %eax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  %7 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 0
  %8 = load i64, i64* %7, align 8
  %9 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 2
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 3
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 4
  %16 = load i64, i64* %15, align 8
  %17 = add i64 %8, %1
  %18 = add i64 %10, %2
  %19 = icmp ult i64 %17, %1
  %20 = zext i1 %19 to i64
  %21 = add i64 %18, %20
  %22 = add i64 %12, %3
  %23 = icmp ult i64 %18, %10
  %24 = zext i1 %23 to i64
  %25 = icmp ult i64 %21, %18
  %26 = zext i1 %25 to i64
  %27 = add i64 %22, %24
  %28 = add i64 %27, %26
  %29 = add i64 %14, %4
  %30 = icmp ult i64 %22, %12
  %31 = zext i1 %30 to i64
  %32 = icmp ult i64 %28, %22
  %33 = zext i1 %32 to i64
  %34 = add i64 %29, %31
  %35 = add i64 %34, %33
  %36 = add i64 %16, %5
  %37 = icmp ult i64 %29, %14
  %38 = zext i1 %37 to i64
  %39 = icmp ult i64 %35, %29
  %40 = zext i1 %39 to i64
  %41 = add i64 %36, %38
  %42 = add i64 %41, %40
  store i64 %17, i64* %7, align 8
  store i64 %21, i64* %9, align 8
  store i64 %28, i64* %11, align 8
  store i64 %35, i64* %13, align 8
  store i64 %42, i64* %15, align 8
  %43 = icmp ult i64 %36, %16
  %44 = zext i1 %43 to i32
  %45 = icmp ult i64 %42, %36
  %46 = zext i1 %45 to i32
  %47 = add nuw nsw i32 %46, %44
  ret i32 %47
}

define i32 @add_U320_without_i128_or(%struct.U320* nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: add_U320_without_i128_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    adcq %rcx, 16(%rdi)
; CHECK-NEXT:    adcq %r8, 24(%rdi)
; CHECK-NEXT:    adcq %r9, 32(%rdi)
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    retq
  %7 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 0
  %8 = load i64, i64* %7, align 8
  %9 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 2
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 3
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 4
  %16 = load i64, i64* %15, align 8
  %17 = add i64 %8, %1
  %18 = add i64 %10, %2
  %19 = icmp ult i64 %17, %1
  %20 = zext i1 %19 to i64
  %21 = add i64 %18, %20
  %22 = add i64 %12, %3
  %23 = icmp ult i64 %18, %10
  %24 = icmp ult i64 %21, %18
  %25 = or i1 %23, %24
  %26 = zext i1 %25 to i64
  %27 = add i64 %22, %26
  %28 = add i64 %14, %4
  %29 = icmp ult i64 %22, %12
  %30 = icmp ult i64 %27, %22
  %31 = or i1 %29, %30
  %32 = zext i1 %31 to i64
  %33 = add i64 %28, %32
  %34 = add i64 %16, %5
  %35 = icmp ult i64 %28, %14
  %36 = icmp ult i64 %33, %28
  %37 = or i1 %35, %36
  %38 = zext i1 %37 to i64
  %39 = add i64 %34, %38
  store i64 %17, i64* %7, align 8
  store i64 %21, i64* %9, align 8
  store i64 %27, i64* %11, align 8
  store i64 %33, i64* %13, align 8
  store i64 %39, i64* %15, align 8
  %40 = icmp ult i64 %34, %16
  %41 = icmp ult i64 %39, %34
  %42 = or i1 %40, %41
  %43 = zext i1 %42 to i32
  ret i32 %43
}

define i32 @add_U320_without_i128_xor(%struct.U320* nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: add_U320_without_i128_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    adcq %rcx, 16(%rdi)
; CHECK-NEXT:    adcq %r8, 24(%rdi)
; CHECK-NEXT:    adcq %r9, 32(%rdi)
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    retq
  %7 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 0
  %8 = load i64, i64* %7, align 8
  %9 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 2
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 3
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 4
  %16 = load i64, i64* %15, align 8
  %17 = add i64 %8, %1
  %18 = add i64 %10, %2
  %19 = icmp ult i64 %17, %1
  %20 = zext i1 %19 to i64
  %21 = add i64 %18, %20
  %22 = add i64 %12, %3
  %23 = icmp ult i64 %18, %10
  %24 = icmp ult i64 %21, %18
  %25 = xor i1 %23, %24
  %26 = zext i1 %25 to i64
  %27 = add i64 %22, %26
  %28 = add i64 %14, %4
  %29 = icmp ult i64 %22, %12
  %30 = icmp ult i64 %27, %22
  %31 = xor i1 %29, %30
  %32 = zext i1 %31 to i64
  %33 = add i64 %28, %32
  %34 = add i64 %16, %5
  %35 = icmp ult i64 %28, %14
  %36 = icmp ult i64 %33, %28
  %37 = xor i1 %35, %36
  %38 = zext i1 %37 to i64
  %39 = add i64 %34, %38
  store i64 %17, i64* %7, align 8
  store i64 %21, i64* %9, align 8
  store i64 %27, i64* %11, align 8
  store i64 %33, i64* %13, align 8
  store i64 %39, i64* %15, align 8
  %40 = icmp ult i64 %34, %16
  %41 = icmp ult i64 %39, %34
  %42 = xor i1 %40, %41
  %43 = zext i1 %42 to i32
  ret i32 %43
}

; Either the primary addition can overflow or the addition of the carry, but
; they cannot both overflow.
define i32 @bogus_add_U320_without_i128_and(%struct.U320* nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: bogus_add_U320_without_i128_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    addq %rcx, 16(%rdi)
; CHECK-NEXT:    addq %r8, 24(%rdi)
; CHECK-NEXT:    addq %r9, 32(%rdi)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %7 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 0
  %8 = load i64, i64* %7, align 8
  %9 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 2
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 3
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 4
  %16 = load i64, i64* %15, align 8
  %17 = add i64 %8, %1
  %18 = add i64 %10, %2
  %19 = icmp ult i64 %17, %1
  %20 = zext i1 %19 to i64
  %21 = add i64 %18, %20
  %22 = add i64 %12, %3
  %23 = icmp ult i64 %18, %10
  %24 = icmp ult i64 %21, %18
  %25 = and i1 %23, %24
  %26 = zext i1 %25 to i64
  %27 = add i64 %22, %26
  %28 = add i64 %14, %4
  %29 = icmp ult i64 %22, %12
  %30 = icmp ult i64 %27, %22
  %31 = and i1 %29, %30
  %32 = zext i1 %31 to i64
  %33 = add i64 %28, %32
  %34 = add i64 %16, %5
  %35 = icmp ult i64 %28, %14
  %36 = icmp ult i64 %33, %28
  %37 = and i1 %35, %36
  %38 = zext i1 %37 to i64
  %39 = add i64 %34, %38
  store i64 %17, i64* %7, align 8
  store i64 %21, i64* %9, align 8
  store i64 %27, i64* %11, align 8
  store i64 %33, i64* %13, align 8
  store i64 %39, i64* %15, align 8
  %40 = icmp ult i64 %34, %16
  %41 = icmp ult i64 %39, %34
  %42 = and i1 %40, %41
  %43 = zext i1 %42 to i32
  ret i32 %43
}

define void @add_U320_without_i128_or_no_ret(%struct.U320* nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: add_U320_without_i128_or_no_ret:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    adcq %rcx, 16(%rdi)
; CHECK-NEXT:    adcq %r8, 24(%rdi)
; CHECK-NEXT:    adcq %r9, 32(%rdi)
; CHECK-NEXT:    retq
  %7 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 0
  %8 = load i64, i64* %7, align 8
  %9 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 2
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 3
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 4
  %16 = load i64, i64* %15, align 8
  %17 = add i64 %8, %1
  %18 = add i64 %10, %2
  %19 = icmp ult i64 %17, %1
  %20 = zext i1 %19 to i64
  %21 = add i64 %18, %20
  %22 = add i64 %12, %3
  %23 = icmp ult i64 %18, %10
  %24 = icmp ult i64 %21, %18
  %25 = or i1 %23, %24
  %26 = zext i1 %25 to i64
  %27 = add i64 %22, %26
  %28 = add i64 %14, %4
  %29 = icmp ult i64 %22, %12
  %30 = icmp ult i64 %27, %22
  %31 = or i1 %29, %30
  %32 = zext i1 %31 to i64
  %33 = add i64 %28, %32
  %34 = add i64 %16, %5
  %35 = icmp ult i64 %28, %14
  %36 = icmp ult i64 %33, %28
  %37 = or i1 %35, %36
  %38 = zext i1 %37 to i64
  %39 = add i64 %34, %38
  store i64 %17, i64* %7, align 8
  store i64 %21, i64* %9, align 8
  store i64 %27, i64* %11, align 8
  store i64 %33, i64* %13, align 8
  store i64 %39, i64* %15, align 8
  ret void
}

define i32 @add_U320_uaddo(%struct.U320* nocapture dereferenceable(40) %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5) {
; CHECK-LABEL: add_U320_uaddo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rsi, (%rdi)
; CHECK-NEXT:    adcq %rdx, 8(%rdi)
; CHECK-NEXT:    adcq %rcx, 16(%rdi)
; CHECK-NEXT:    adcq %r8, 24(%rdi)
; CHECK-NEXT:    adcq %r9, 32(%rdi)
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    retq
  %7 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 0
  %8 = load i64, i64* %7, align 8
  %9 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 2
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 3
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %struct.U320, %struct.U320* %0, i64 0, i32 0, i64 4
  %16 = load i64, i64* %15, align 8
  %17 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %8, i64 %1)
  %18 = extractvalue { i64, i1 } %17, 1
  %19 = extractvalue { i64, i1 } %17, 0
  %20 = zext i1 %18 to i64
  %21 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %10, i64 %2)
  %22 = extractvalue { i64, i1 } %21, 1
  %23 = extractvalue { i64, i1 } %21, 0
  %24 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %23, i64 %20)
  %25 = extractvalue { i64, i1 } %24, 1
  %26 = extractvalue { i64, i1 } %24, 0
  %27 = or i1 %22, %25
  %28 = zext i1 %27 to i64
  %29 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %12, i64 %3)
  %30 = extractvalue { i64, i1 } %29, 1
  %31 = extractvalue { i64, i1 } %29, 0
  %32 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %31, i64 %28)
  %33 = extractvalue { i64, i1 } %32, 1
  %34 = extractvalue { i64, i1 } %32, 0
  %35 = or i1 %30, %33
  %36 = zext i1 %35 to i64
  %37 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %14, i64 %4)
  %38 = extractvalue { i64, i1 } %37, 1
  %39 = extractvalue { i64, i1 } %37, 0
  %40 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %39, i64 %36)
  %41 = extractvalue { i64, i1 } %40, 1
  %42 = extractvalue { i64, i1 } %40, 0
  %43 = or i1 %38, %41
  %44 = zext i1 %43 to i64
  %45 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %16, i64 %5)
  %46 = extractvalue { i64, i1 } %45, 1
  %47 = extractvalue { i64, i1 } %45, 0
  %48 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %47, i64 %44)
  %49 = extractvalue { i64, i1 } %48, 1
  %50 = extractvalue { i64, i1 } %48, 0
  %51 = or i1 %46, %49
  store i64 %19, i64* %7, align 8
  store i64 %26, i64* %9, align 8
  store i64 %34, i64* %11, align 8
  store i64 %42, i64* %13, align 8
  store i64 %50, i64* %15, align 8
  %52 = zext i1 %51 to i32
  ret i32 %52
}

%struct.U192 = type { [3 x i64] }

define void @PR39464(%struct.U192* noalias nocapture sret %0, %struct.U192* nocapture readonly dereferenceable(24) %1, %struct.U192* nocapture readonly dereferenceable(24) %2) {
; CHECK-LABEL: PR39464:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq (%rsi), %rcx
; CHECK-NEXT:    addq (%rdx), %rcx
; CHECK-NEXT:    movq %rcx, (%rdi)
; CHECK-NEXT:    movq 8(%rsi), %rcx
; CHECK-NEXT:    adcq 8(%rdx), %rcx
; CHECK-NEXT:    movq %rcx, 8(%rdi)
; CHECK-NEXT:    movq 16(%rsi), %rcx
; CHECK-NEXT:    adcq 16(%rdx), %rcx
; CHECK-NEXT:    movq %rcx, 16(%rdi)
; CHECK-NEXT:    retq
  %4 = getelementptr inbounds %struct.U192, %struct.U192* %1, i64 0, i32 0, i64 0
  %5 = load i64, i64* %4, align 8
  %6 = getelementptr inbounds %struct.U192, %struct.U192* %2, i64 0, i32 0, i64 0
  %7 = load i64, i64* %6, align 8
  %8 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %5, i64 %7)
  %9 = extractvalue { i64, i1 } %8, 1
  %10 = extractvalue { i64, i1 } %8, 0
  %11 = zext i1 %9 to i64
  %12 = getelementptr inbounds %struct.U192, %struct.U192* %0, i64 0, i32 0, i64 0
  store i64 %10, i64* %12, align 8
  %13 = getelementptr inbounds %struct.U192, %struct.U192* %1, i64 0, i32 0, i64 1
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %struct.U192, %struct.U192* %2, i64 0, i32 0, i64 1
  %16 = load i64, i64* %15, align 8
  %17 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %14, i64 %16)
  %18 = extractvalue { i64, i1 } %17, 1
  %19 = extractvalue { i64, i1 } %17, 0
  %20 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %19, i64 %11)
  %21 = extractvalue { i64, i1 } %20, 1
  %22 = extractvalue { i64, i1 } %20, 0
  %23 = or i1 %18, %21
  %24 = zext i1 %23 to i64
  %25 = getelementptr inbounds %struct.U192, %struct.U192* %0, i64 0, i32 0, i64 1
  store i64 %22, i64* %25, align 8
  %26 = getelementptr inbounds %struct.U192, %struct.U192* %1, i64 0, i32 0, i64 2
  %27 = load i64, i64* %26, align 8
  %28 = getelementptr inbounds %struct.U192, %struct.U192* %2, i64 0, i32 0, i64 2
  %29 = load i64, i64* %28, align 8
  %30 = add i64 %27, %29
  %31 = add i64 %30, %24
  %32 = getelementptr inbounds %struct.U192, %struct.U192* %0, i64 0, i32 0, i64 2
  store i64 %31, i64* %32, align 8
  ret void
}


%uint128 = type { i64, i64 }

define zeroext i1 @uaddo_U128_without_i128_or(i64 %0, i64 %1, i64 %2, i64 %3, %uint128* nocapture %4) nounwind {
; CHECK-LABEL: uaddo_U128_without_i128_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rdx, %rdi
; CHECK-NEXT:    adcq %rcx, %rsi
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movq %rsi, (%r8)
; CHECK-NEXT:    movq %rdi, 8(%r8)
; CHECK-NEXT:    retq
  %6 = add i64 %2, %0
  %7 = icmp ult i64 %6, %0
  %8 = add i64 %3, %1
  %9 = icmp ult i64 %8, %1
  %10 = zext i1 %7 to i64
  %11 = add i64 %8, %10
  %12 = icmp ult i64 %11, %8
  %13 = or i1 %9, %12
  %14 = getelementptr inbounds %uint128, %uint128* %4, i64 0, i32 0
  store i64 %11, i64* %14, align 8
  %15 = getelementptr inbounds %uint128, %uint128* %4, i64 0, i32 1
  store i64 %6, i64* %15, align 8
  ret i1 %13
}


%uint192 = type { i64, i64, i64 }

define void @add_U192_without_i128_or(%uint192* sret %0, i64 %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6) nounwind {
; CHECK-LABEL: add_U192_without_i128_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    addq %r8, %rsi
; CHECK-NEXT:    adcq %r9, %rdx
; CHECK-NEXT:    adcq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    movq %rcx, (%rdi)
; CHECK-NEXT:    movq %rdx, 8(%rdi)
; CHECK-NEXT:    movq %rsi, 16(%rdi)
; CHECK-NEXT:    retq
  %8 = add i64 %4, %1
  %9 = icmp ult i64 %8, %1
  %10 = add i64 %5, %2
  %11 = icmp ult i64 %10, %2
  %12 = zext i1 %9 to i64
  %13 = add i64 %10, %12
  %14 = icmp ult i64 %13, %10
  %15 = or i1 %11, %14
  %16 = add i64 %6, %3
  %17 = zext i1 %15 to i64
  %18 = add i64 %16, %17
  %19 = getelementptr inbounds %uint192, %uint192* %0, i64 0, i32 0
  store i64 %18, i64* %19, align 8
  %20 = getelementptr inbounds %uint192, %uint192* %0, i64 0, i32 1
  store i64 %13, i64* %20, align 8
  %21 = getelementptr inbounds %uint192, %uint192* %0, i64 0, i32 2
  store i64 %8, i64* %21, align 8
  ret void
}


%uint256 = type { %uint128, %uint128 }

; Classic unrolled 256-bit addition implementation using i64 as the word type.
; It starts by adding least significant words and propagates carry to additions of the higher words.
define void @add_U256_without_i128_or_by_i64_words(%uint256* sret %0, %uint256* %1, %uint256* %2) nounwind {
; CHECK-LABEL: add_U256_without_i128_or_by_i64_words:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq (%rdx), %r8
; CHECK-NEXT:    movq 8(%rdx), %rdi
; CHECK-NEXT:    addq (%rsi), %r8
; CHECK-NEXT:    adcq 8(%rsi), %rdi
; CHECK-NEXT:    movq 16(%rdx), %rcx
; CHECK-NEXT:    adcq 16(%rsi), %rcx
; CHECK-NEXT:    movq 24(%rdx), %rdx
; CHECK-NEXT:    adcq 24(%rsi), %rdx
; CHECK-NEXT:    movq %rdx, (%rax)
; CHECK-NEXT:    movq %rcx, 8(%rax)
; CHECK-NEXT:    movq %rdi, 16(%rax)
; CHECK-NEXT:    movq %r8, 24(%rax)
; CHECK-NEXT:    retq
  %4 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 0, i32 0
  %5 = load i64, i64* %4, align 8
  %6 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 0, i32 0
  %7 = load i64, i64* %6, align 8
  %8 = add i64 %7, %5
  %9 = icmp ult i64 %8, %5
  %10 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  %12 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 0, i32 1
  %13 = load i64, i64* %12, align 8
  %14 = add i64 %13, %11
  %15 = icmp ult i64 %14, %11
  %16 = zext i1 %9 to i64
  %17 = add i64 %14, %16
  %18 = icmp ult i64 %17, %16
  %19 = or i1 %15, %18
  %20 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 1, i32 0
  %21 = load i64, i64* %20, align 8
  %22 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 1, i32 0
  %23 = load i64, i64* %22, align 8
  %24 = add i64 %23, %21
  %25 = icmp ult i64 %24, %21
  %26 = zext i1 %19 to i64
  %27 = add i64 %24, %26
  %28 = icmp ult i64 %27, %26
  %29 = or i1 %25, %28
  %30 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 1, i32 1
  %31 = load i64, i64* %30, align 8
  %32 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 1, i32 1
  %33 = load i64, i64* %32, align 8
  %34 = add i64 %33, %31
  %35 = zext i1 %29 to i64
  %36 = add i64 %34, %35
  %37 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 0, i32 0
  store i64 %36, i64* %37, align 8
  %38 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 0, i32 1
  store i64 %27, i64* %38, align 8
  %39 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 1, i32 0
  store i64 %17, i64* %39, align 8
  %40 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 1, i32 1
  store i64 %8, i64* %40, align 8
  ret void
}

; The 256-bit addition implementation using two inlined uaddo procedures for U128 type { i64, i64 }.
; This is similar to how LLVM legalize types in CodeGen.
define void @add_U256_without_i128_or_recursive(%uint256* sret %0, %uint256* %1, %uint256* %2) nounwind {
; CHECK-LABEL: add_U256_without_i128_or_recursive:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq (%rdx), %r8
; CHECK-NEXT:    movq 8(%rdx), %rdi
; CHECK-NEXT:    addq (%rsi), %r8
; CHECK-NEXT:    adcq 8(%rsi), %rdi
; CHECK-NEXT:    movq 16(%rdx), %rcx
; CHECK-NEXT:    movq 24(%rdx), %rdx
; CHECK-NEXT:    adcq 16(%rsi), %rcx
; CHECK-NEXT:    adcq 24(%rsi), %rdx
; CHECK-NEXT:    movq %r8, (%rax)
; CHECK-NEXT:    movq %rdi, 8(%rax)
; CHECK-NEXT:    movq %rcx, 16(%rax)
; CHECK-NEXT:    movq %rdx, 24(%rax)
; CHECK-NEXT:    retq
  %4 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 0, i32 0
  %5 = load i64, i64* %4, align 8
  %6 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 0, i32 1
  %7 = load i64, i64* %6, align 8
  %8 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 0, i32 0
  %9 = load i64, i64* %8, align 8
  %10 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 0, i32 1
  %11 = load i64, i64* %10, align 8
  %12 = add i64 %9, %5
  %13 = icmp ult i64 %12, %5
  %14 = add i64 %11, %7
  %15 = icmp ult i64 %14, %7
  %16 = zext i1 %13 to i64
  %17 = add i64 %14, %16
  %18 = icmp ult i64 %17, %14
  %19 = or i1 %15, %18
  %20 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 1, i32 0
  %21 = load i64, i64* %20, align 8
  %22 = getelementptr inbounds %uint256, %uint256* %1, i64 0, i32 1, i32 1
  %23 = load i64, i64* %22, align 8
  %24 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 1, i32 0
  %25 = load i64, i64* %24, align 8
  %26 = getelementptr inbounds %uint256, %uint256* %2, i64 0, i32 1, i32 1
  %27 = load i64, i64* %26, align 8
  %28 = add i64 %25, %21
  %29 = icmp ult i64 %28, %21
  %30 = add i64 %27, %23
  %31 = zext i1 %29 to i64
  %32 = add i64 %30, %31
  %33 = zext i1 %19 to i64
  %34 = add i64 %28, %33
  %35 = icmp ult i64 %34, %28
  %36 = zext i1 %35 to i64
  %37 = add i64 %32, %36
  %38 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 0, i32 0
  store i64 %12, i64* %38, align 8
  %39 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 0, i32 1
  store i64 %17, i64* %39, align 8
  %40 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 1, i32 0
  store i64 %34, i64* %40, align 8
  %41 = getelementptr inbounds %uint256, %uint256* %0, i64 0, i32 1, i32 1
  store i64 %37, i64* %41, align 8
  ret void
}
