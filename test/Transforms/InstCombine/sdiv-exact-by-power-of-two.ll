; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; Fold
;   x s/EXACT (1 << y)
; to
;   x a>>EXACT y
; iff 1<<y is non-negative

define i8 @t0(i8 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[DIV:%.*]] = ashr exact i8 [[X:%.*]], 5
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %div = sdiv exact i8 %x, 32
  ret i8 %div
}
define i8 @n1(i8 %x) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i8 [[X:%.*]], 32
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %div = sdiv i8 %x, 32 ; not exact
  ret i8 %div
}
define i8 @n2(i8 %x) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X:%.*]], -128
; CHECK-NEXT:    [[DIV:%.*]] = zext i1 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %div = sdiv i8 %x, 128 ; negative divisor
  ret i8 %div
}

define <2 x i8> @t3_vec_splat(<2 x i8> %x) {
; CHECK-LABEL: @t3_vec_splat(
; CHECK-NEXT:    [[DIV:%.*]] = ashr exact <2 x i8> [[X:%.*]], <i8 5, i8 5>
; CHECK-NEXT:    ret <2 x i8> [[DIV]]
;
  %div = sdiv exact <2 x i8> %x, <i8 32, i8 32>
  ret <2 x i8> %div
}

define <2 x i8> @t4_vec(<2 x i8> %x) {
; CHECK-LABEL: @t4_vec(
; CHECK-NEXT:    [[DIV:%.*]] = ashr exact <2 x i8> [[X:%.*]], <i8 5, i8 4>
; CHECK-NEXT:    ret <2 x i8> [[DIV]]
;
  %div = sdiv exact <2 x i8> %x, <i8 32, i8 16>
  ret <2 x i8> %div
}

define <2 x i8> @n5_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @n5_vec_undef(
; CHECK-NEXT:    ret <2 x i8> undef
;
  %div = sdiv exact <2 x i8> %x, <i8 32, i8 undef>
  ret <2 x i8> %div
}
define <2 x i8> @n6_vec_negative(<2 x i8> %x) {
; CHECK-LABEL: @n6_vec_negative(
; CHECK-NEXT:    [[DIV:%.*]] = sdiv exact <2 x i8> [[X:%.*]], <i8 32, i8 -128>
; CHECK-NEXT:    ret <2 x i8> [[DIV]]
;
  %div = sdiv exact <2 x i8> %x, <i8 32, i8 128> ; non-non-negative divisor
  ret <2 x i8> %div
}
