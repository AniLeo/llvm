; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; This test makes sure that mul instructions are properly eliminated.
; This test is for Integer BitWidth >= 64 && BitWidth % 2 >= 1024.

define i177 @test1(i177 %X) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[Y:%.*]] = shl i177 [[X:%.*]], 155
; CHECK-NEXT:    ret i177 [[Y]]
;
  %C = shl i177 1, 155
  %Y = mul i177 %X, %C
  ret i177 %Y
}

define <2 x i177> @test2(<2 x i177> %X) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[Y:%.*]] = shl <2 x i177> [[X:%.*]], <i177 155, i177 155>
; CHECK-NEXT:    ret <2 x i177> [[Y]]
;
  %C = shl <2 x i177> <i177 1, i177 1>, <i177 155, i177 155>
  %Y = mul <2 x i177> %X, %C
  ret <2 x i177> %Y
}

define <2 x i177> @test3(<2 x i177> %X) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[Y:%.*]] = shl <2 x i177> [[X:%.*]], <i177 150, i177 155>
; CHECK-NEXT:    ret <2 x i177> [[Y]]
;
  %C = shl <2 x i177> <i177 1, i177 1>, <i177 150, i177 155>
  %Y = mul <2 x i177> %X, %C
  ret <2 x i177> %Y
}
