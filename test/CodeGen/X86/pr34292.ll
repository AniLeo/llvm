; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+adx | FileCheck %s

; PR34292
@_ZL1c = external dso_local global i8
define void @sum_unroll(i64* nocapture readonly, i64* nocapture) {
; CHECK-LABEL: sum_unroll:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movb {{.*}}(%rip), %al
; CHECK-NEXT:    movq (%rdi), %rcx
; CHECK-NEXT:    addb $-1, %al
; CHECK-NEXT:    adcq %rcx, (%rsi)
; CHECK-NEXT:    movq 8(%rdi), %rax
; CHECK-NEXT:    adcq %rax, 8(%rsi)
; CHECK-NEXT:    movq 16(%rdi), %rax
; CHECK-NEXT:    adcq %rax, 16(%rsi)
; CHECK-NEXT:    movq 24(%rdi), %rax
; CHECK-NEXT:    adcq %rax, 24(%rsi)
; CHECK-NEXT:    setb {{.*}}(%rip)
; CHECK-NEXT:    retq
  %3 = load i8, i8* @_ZL1c, align 1
  %4 = load i64, i64* %0, align 8
  %5 = load i64, i64* %1, align 8
  %6 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %3, i64 %4, i64 %5)
  %7 = extractvalue { i8, i64 } %6, 1
  store i64 %7, i64* %1, align 8
  %8 = extractvalue { i8, i64 } %6, 0
  %9 = getelementptr inbounds i64, i64* %0, i64 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds i64, i64* %1, i64 1
  %12 = load i64, i64* %11, align 8
  %13 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %8, i64 %10, i64 %12)
  %14 = extractvalue { i8, i64 } %13, 1
  store i64 %14, i64* %11, align 8
  %15 = extractvalue { i8, i64 } %13, 0
  %16 = getelementptr inbounds i64, i64* %0, i64 2
  %17 = load i64, i64* %16, align 8
  %18 = getelementptr inbounds i64, i64* %1, i64 2
  %19 = load i64, i64* %18, align 8
  %20 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %15, i64 %17, i64 %19)
  %21 = extractvalue { i8, i64 } %20, 1
  store i64 %21, i64* %18, align 8
  %22 = extractvalue { i8, i64 } %20, 0
  %23 = getelementptr inbounds i64, i64* %0, i64 3
  %24 = load i64, i64* %23, align 8
  %25 = getelementptr inbounds i64, i64* %1, i64 3
  %26 = load i64, i64* %25, align 8
  %27 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %22, i64 %24, i64 %26)
  %28 = extractvalue { i8, i64 } %27, 1
  store i64 %28, i64* %25, align 8
  %29 = extractvalue { i8, i64 } %27, 0
  store i8 %29, i8* @_ZL1c, align 1
  ret void
}

declare { i8, i64 } @llvm.x86.addcarry.64(i8, i64, i64)
