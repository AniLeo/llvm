; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define i8 @t1(ptr %X, i64 %i) {
; CHECK-LABEL: t1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andq $-255, %rsi
; CHECK-NEXT:    movzbl (%rdi,%rsi,4), %eax
; CHECK-NEXT:    retq

entry:
  %tmp2 = shl i64 %i, 2
  %tmp4 = and i64 %tmp2, -1020
  %tmp7 = getelementptr i8, ptr %X, i64 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}

define i8 @t2(ptr %X, i64 %i) {
; CHECK-LABEL: t2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andq $-14, %rsi
; CHECK-NEXT:    movzbl (%rdi,%rsi,4), %eax
; CHECK-NEXT:    retq

entry:
  %tmp2 = shl i64 %i, 2
  %tmp4 = and i64 %tmp2, -56
  %tmp7 = getelementptr i8, ptr %X, i64 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}

define i8 @t3(ptr %X, i64 %i) {
; CHECK-LABEL: t3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    movzbl (%rdi,%rax,4), %eax
; CHECK-NEXT:    retq

entry:
  %tmp2 = shl i64 %i, 2
  %tmp4 = and i64 %tmp2, 17179869180
  %tmp7 = getelementptr i8, ptr %X, i64 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}

define i8 @t4(ptr %X, i64 %i) {
; CHECK-LABEL: t4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andl $-2, %esi
; CHECK-NEXT:    movzbl (%rdi,%rsi,4), %eax
; CHECK-NEXT:    retq

entry:
  %tmp2 = shl i64 %i, 2
  %tmp4 = and i64 %tmp2, 17179869176
  %tmp7 = getelementptr i8, ptr %X, i64 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}

define i8 @t5(ptr %X, i64 %i) {
; CHECK-LABEL: t5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andl $-250002, %esi # imm = 0xFFFC2F6E
; CHECK-NEXT:    movzbl (%rdi,%rsi,4), %eax
; CHECK-NEXT:    retq

entry:
  %tmp2 = shl i64 %i, 2
  %tmp4 = and i64 %tmp2, 17178869176
  %tmp7 = getelementptr i8, ptr %X, i64 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}

define i8 @t6(ptr %X, i32 %i) {
; CHECK-LABEL: t6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    andl $15, %esi
; CHECK-NEXT:    movzbl (%rdi,%rsi,4), %eax
; CHECK-NEXT:    retq
entry:
  %tmp2 = shl i32 %i, 2
  %tmp3 = zext i32 %tmp2 to i64
  %tmp4 = and i64 %tmp3, 60
  %tmp7 = getelementptr i8, ptr %X, i64 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}

