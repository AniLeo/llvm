; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; (x&z) ^ (y&z) -> (x^y)&z
define i32 @test1(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[T61:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T7:%.*]] = and i32 [[T61]], [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[T7]]
;
  %t3 = and i32 %z, %x
  %t6 = and i32 %z, %y
  %t7 = xor i32 %t3, %t6
  ret i32 %t7
}

; (x & y) ^ (x|y) -> x^y
define i32 @test2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[T7:%.*]] = xor i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[T7]]
;
  %t3 = and i32 %y, %x
  %t6 = or i32 %y, %x
  %t7 = xor i32 %t3, %t6
  ret i32 %t7
}

define i32 @PR38761(i32 %a, i32 %b) {
; CHECK-LABEL: @PR38761(
; CHECK-NEXT:    [[B_LOBIT_NOT1_DEMORGAN:%.*]] = or i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[B_LOBIT_NOT1:%.*]] = xor i32 [[B_LOBIT_NOT1_DEMORGAN]], -1
; CHECK-NEXT:    [[AND:%.*]] = lshr i32 [[B_LOBIT_NOT1]], 31
; CHECK-NEXT:    ret i32 [[AND]]
;
  %a.lobit = lshr i32 %a, 31
  %a.lobit.not = xor i32 %a.lobit, 1
  %b.lobit = lshr i32 %b, 31
  %b.lobit.not = xor i32 %b.lobit, 1
  %and = and i32 %b.lobit.not, %a.lobit.not
  ret i32 %and
}
