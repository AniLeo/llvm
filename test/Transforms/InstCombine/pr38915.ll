; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @PR38915(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @PR38915(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[X:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[M1N:%.*]] = select i1 [[TMP3]], i32 [[TMP1]], i32 [[TMP2]]
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[M1N]], [[Z:%.*]]
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[C2]], i32 [[M1N]], i32 [[Z]]
; CHECK-NEXT:    [[M2N:%.*]] = xor i32 [[M2]], -1
; CHECK-NEXT:    ret i32 [[M2N]]
;
  %xn = sub i32 0, %x
  %yn = sub i32 0, %y
  %c1 = icmp sgt i32 %xn, %yn
  %m1 = select i1 %c1, i32 %xn, i32 %yn
  %m1n = xor i32 %m1, -1
  %c2 = icmp sgt i32 %m1n, %z
  %m2 = select i1 %c2, i32 %m1n, i32 %z
  %m2n = xor i32 %m2, -1
  ret i32 %m2n
}
