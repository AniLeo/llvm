; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define void @hang_2002-03-11(i32 %X) {
; CHECK-LABEL: @hang_2002-03-11(
; CHECK-NEXT:    ret void
;
  %reg117 = add i32 %X, 0
  ret void
}

; Instcombine was missing a test that caused it to make illegal transformations
; sometimes. In this case, it transformed the sub into an add:

define i32 @sub_failure_2002-05-14(i32 %i, i32 %j) {
; CHECK-LABEL: @sub_failure_2002-05-14(
; CHECK-NEXT:    [[A:%.*]] = mul i32 %i, %j
; CHECK-NEXT:    [[B:%.*]] = sub i32 2, [[A]]
; CHECK-NEXT:    ret i32 [[B]]
;
  %A = mul i32 %i, %j
  %B = sub i32 2, %A
  ret i32 %B
}

; This testcase was incorrectly getting completely eliminated. There should be
; SOME instruction named %c here, even if it's a bitwise and.

define i64 @cast_test_2002-08-02(i64 %A) {
; CHECK-LABEL: @cast_test_2002-08-02(
; CHECK-NEXT:    [[C2:%.*]] = and i64 %A, 255
; CHECK-NEXT:    ret i64 [[C2]]
;
  %c1 = trunc i64 %A to i8
  %c2 = zext i8 %c1 to i64
  ret i64 %c2
}

define i32 @missed_const_prop_2002-12-05(i32 %A) {
; CHECK-LABEL: @missed_const_prop_2002-12-05(
; CHECK-NEXT:    ret i32 0
;
  %A.neg = sub i32 0, %A
  %.neg = sub i32 0, 1
  %X = add i32 %.neg, 1
  %Y.neg.ra = add i32 %A, %X
  %r = add i32 %A.neg, %Y.neg.ra
  ret i32 %r
}

