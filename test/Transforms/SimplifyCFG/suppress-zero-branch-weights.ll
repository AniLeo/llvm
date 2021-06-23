; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 < %s | FileCheck %s

; We're sign extending an 8-bit value.
; The switch condition must be in the range [-128, 127], so any cases outside of that range must be dead.
; Only the first case has a non-zero weight, but that gets eliminated. Note
; that this shouldn't have been the case in the first place, but the test here
; ensures that all-zero branch weights are not attached causing problems downstream.

define i1 @repeated_signbits(i8 %condition) {
; CHECK-LABEL: @repeated_signbits(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SEXT:%.*]] = sext i8 [[CONDITION:%.*]] to i32
; CHECK-NEXT:    switch i32 [[SEXT]], label [[DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[COMMON_RET:%.*]]
; CHECK-NEXT:    i32 127, label [[COMMON_RET]]
; CHECK-NEXT:    i32 -128, label [[COMMON_RET]]
; CHECK-NEXT:    i32 -1, label [[COMMON_RET]]
; CHECK-NEXT:    ]
; CHECK:       common.ret:
; CHECK-NEXT:    [[COMMON_RET_OP:%.*]] = phi i1 [ false, [[DEFAULT]] ], [ true, [[ENTRY:%.*]] ], [ true, [[ENTRY]] ], [ true, [[ENTRY]] ], [ true, [[ENTRY]] ]
; CHECK-NEXT:    ret i1 [[COMMON_RET_OP]]
; CHECK:       default:
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %sext = sext i8 %condition to i32
  switch i32 %sext, label %default [
  i32 -2147483648, label %a
  i32 -129, label %a
  i32 -128, label %a
  i32 -1, label %a
  i32  0, label %a
  i32  127, label %a
  i32  128, label %a
  i32  2147483647, label %a
  ], !prof !1

a:
  ret i1 1

default:
  ret i1 0
}

!1 = !{!"branch_weights", i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0}

