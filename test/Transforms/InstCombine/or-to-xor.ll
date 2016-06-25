; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @func1(i32 %a, i32 %b) {
; CHECK-LABEL: @func1(
; CHECK-NEXT:    [[T2:%.*]] = xor i32 %a, %b
; CHECK-NEXT:    ret i32 [[T2]]
;
  %b_not = xor i32 %b, -1
  %t0 = and i32 %a, %b_not
  %a_not = xor i32 %a, -1
  %t1 = and i32 %a_not, %b
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

define i32 @func2(i32 %a, i32 %b) {
; CHECK-LABEL: @func2(
; CHECK-NEXT:    [[T2:%.*]] = xor i32 %a, %b
; CHECK-NEXT:    ret i32 [[T2]]
;
  %b_not = xor i32 %b, -1
  %t0 = and i32 %b_not, %a
  %a_not = xor i32 %a, -1
  %t1 = and i32 %a_not, %b
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

define i32 @func3(i32 %a, i32 %b) {
; CHECK-LABEL: @func3(
; CHECK-NEXT:    [[T2:%.*]] = xor i32 %a, %b
; CHECK-NEXT:    ret i32 [[T2]]
;
  %b_not = xor i32 %b, -1
  %t0 = and i32 %a, %b_not
  %a_not = xor i32 %a, -1
  %t1 = and i32 %b, %a_not
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

define i32 @func4(i32 %a, i32 %b) {
; CHECK-LABEL: @func4(
; CHECK-NEXT:    [[T2:%.*]] = xor i32 %a, %b
; CHECK-NEXT:    ret i32 [[T2]]
;
  %b_not = xor i32 %b, -1
  %t0 = and i32 %b_not, %a
  %a_not = xor i32 %a, -1
  %t1 = and i32 %b, %a_not
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

