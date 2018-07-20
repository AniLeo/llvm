; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -o - %s -mtriple=x86_64--unknown-linux-gnu | FileCheck %s

; When compiled and run this should print zero.


@c = common local_unnamed_addr global i32 0, align 4
@f = common local_unnamed_addr global i32 0, align 4
@e = common local_unnamed_addr global i32 0, align 4
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; We should only see a single store to f (a bytes store to f+3).
define void @k(i32 %l) {
; CHECK-LABEL: k:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{.*}}(%rip), %eax
; CHECK-NEXT:    orl {{.*}}(%rip), %eax
; CHECK-NEXT:    shrl $24, %eax
; CHECK-NEXT:    movb %al, f+{{.*}}(%rip)
; CHECK-NEXT:    retq
  %load = load i32, i32* @c, align 4
  %load6 = load i32, i32* @f, align 4
  %clear7 = and i32 %load6, 16777215
  store i32 %clear7, i32* @c, align 4
  %neg = and i32 %load6, 2097151
  %value = xor i32 %neg, 2097151
  store i32 %load, i32* @c, align 4
  %t0 = load i32, i32* @e, align 4
  %value15 = xor i32 %t0, %value
  %clear16 = and i32 %load6, -16777216
  %set17 = or i32 %value15, %clear16
  store i32 %set17, i32* @f, align 4
  %clear25 = and i32 %set17, -16777216
  %set26 = or i32 %clear25, %clear7
  store i32 %set26, i32* @f, align 4
  ret void
}

declare i32 @printf(i8* nocapture readonly, ...)

define i32 @main() {
; CHECK-LABEL: main:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl $1, %edi
; CHECK-NEXT:    callq k
; CHECK-NEXT:    movl {{.*}}(%rip), %esi
; CHECK-NEXT:    movl $.L.str.1, %edi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    callq printf
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  tail call void @k(i32 1)
  %load = load i32, i32* @f, align 4
  %call = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 %load)
  ret i32 0
}
