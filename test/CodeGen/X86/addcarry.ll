; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s

define void @a(i64* nocapture %s, i64* nocapture %t, i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: a:
; CHECK:       # BB#0: # %entry
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
; CHECK:       # BB#0: # %entry
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
; CHECK:       # BB#0: # %entry
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
; CHECK:       # BB#0: # %entry
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

%scalar = type { [4 x i64] }

define %scalar @pr31719(%scalar* nocapture readonly %this, %scalar %arg.b) {
; CHECK-LABEL: pr31719:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    xorl %r10d, %r10d
; CHECK-NEXT:    addq 8(%rsi), %rcx
; CHECK-NEXT:    setb %r10b
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    addq 16(%rsi), %r8
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    addq 24(%rsi), %r9
; CHECK-NEXT:    addq (%rsi), %rdx
; CHECK-NEXT:    adcq $0, %rcx
; CHECK-NEXT:    adcq %r8, %r10
; CHECK-NEXT:    adcq %r9, %rax
; CHECK-NEXT:    movq %rdx, (%rdi)
; CHECK-NEXT:    movq %rcx, 8(%rdi)
; CHECK-NEXT:    movq %r10, 16(%rdi)
; CHECK-NEXT:    movq %rax, 24(%rdi)
; CHECK-NEXT:    movq %rdi, %rax
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
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    mulq %rsi
; CHECK-NEXT:    addq (%rdi), %rax
; CHECK-NEXT:    movq %rax, (%rdi)
; CHECK-NEXT:    adcq 8(%rdi), %rdx
; CHECK-NEXT:    movq %rdx, 8(%rdi)
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
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    leaq (%rdx,%rcx), %rax
; CHECK-NEXT:    addq %rsi, %rdi
; CHECK-NEXT:    adcq $0, %rax
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
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addq (%rsi), %rdx
; CHECK-NEXT:    movq 8(%rsi), %r10
; CHECK-NEXT:    adcq $0, %r10
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    addq %rcx, %r10
; CHECK-NEXT:    adcq 16(%rsi), %rax
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movzbl %cl, %ecx
; CHECK-NEXT:    addq %r8, %rax
; CHECK-NEXT:    adcq 24(%rsi), %rcx
; CHECK-NEXT:    addq %r9, %rcx
; CHECK-NEXT:    movq %rdx, (%rdi)
; CHECK-NEXT:    movq %r10, 8(%rdi)
; CHECK-NEXT:    movq %rax, 16(%rdi)
; CHECK-NEXT:    movq %rcx, 24(%rdi)
; CHECK-NEXT:    movq %rdi, %rax
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
