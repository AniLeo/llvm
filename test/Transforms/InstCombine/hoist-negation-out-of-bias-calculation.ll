; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -instcombine | FileCheck %s

; Fold
;   (X & (- Y)) - X
; to
;   - (X & (Y - 1))
;
; This allows us to possibly hoist said negation further out.

; https://bugs.llvm.org/show_bug.cgi?id=44448

; Base tests

define i8 @t0(i8 %x, i8 %y) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 0, [[TMP2]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %negy = sub i8 0, %y
  %unbiasedx = and i8 %negy, %x
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}

declare i8 @gen8()

define i8 @t1_commutative(i8 %y) {
; CHECK-LABEL: @t1_commutative(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[X]], [[TMP1]]
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 0, [[TMP2]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %x = call i8 @gen8()
  %negy = sub i8 0, %y
  %unbiasedx = and i8 %x, %negy ; commutative, swapped
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}

define <2 x i8> @t2_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t2_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = add <2 x i8> [[Y:%.*]], <i8 -1, i8 -1>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i8> [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP2]]
; CHECK-NEXT:    ret <2 x i8> [[NEGBIAS]]
;
  %negy = sub <2 x i8> <i8 0, i8 0>, %y
  %unbiasedx = and <2 x i8> %negy, %x
  %negbias = sub <2 x i8> %unbiasedx, %x
  ret <2 x i8> %negbias
}

define <2 x i8> @t3_vec_undef(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t3_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = add <2 x i8> [[Y:%.*]], <i8 -1, i8 -1>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i8> [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP2]]
; CHECK-NEXT:    ret <2 x i8> [[NEGBIAS]]
;
  %negy = sub <2 x i8> <i8 0, i8 undef>, %y
  %unbiasedx = and <2 x i8> %negy, %x
  %negbias = sub <2 x i8> %unbiasedx, %x
  ret <2 x i8> %negbias
}

; Extra uses always prevent fold

declare void @use8(i8)

define i8 @n4_extrause0(i8 %x, i8 %y) {
; CHECK-LABEL: @n4_extrause0(
; CHECK-NEXT:    [[NEGY:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[NEGY]])
; CHECK-NEXT:    [[UNBIASEDX:%.*]] = and i8 [[NEGY]], [[X:%.*]]
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 [[UNBIASEDX]], [[X]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %negy = sub i8 0, %y
  call void @use8(i8 %negy)
  %unbiasedx = and i8 %negy, %x
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}
define i8 @n5_extrause1(i8 %x, i8 %y) {
; CHECK-LABEL: @n5_extrause1(
; CHECK-NEXT:    [[NEGY:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    [[UNBIASEDX:%.*]] = and i8 [[NEGY]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[UNBIASEDX]])
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 [[UNBIASEDX]], [[X]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %negy = sub i8 0, %y
  %unbiasedx = and i8 %negy, %x
  call void @use8(i8 %unbiasedx)
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}
define i8 @n6_extrause2(i8 %x, i8 %y) {
; CHECK-LABEL: @n6_extrause2(
; CHECK-NEXT:    [[NEGY:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[NEGY]])
; CHECK-NEXT:    [[UNBIASEDX:%.*]] = and i8 [[NEGY]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[UNBIASEDX]])
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 [[UNBIASEDX]], [[X]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %negy = sub i8 0, %y
  call void @use8(i8 %negy)
  %unbiasedx = and i8 %negy, %x
  call void @use8(i8 %unbiasedx)
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}

; Negative tests

define i8 @n7(i8 %x, i8 %y) {
; CHECK-LABEL: @n7(
; CHECK-NEXT:    [[NEGY_NOT:%.*]] = add i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[NEGBIAS:%.*]] = and i8 [[NEGY_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %negy = sub i8 0, %y
  %unbiasedx = and i8 %negy, %x
  %negbias = sub i8 %x, %unbiasedx ; wrong order
  ret i8 %negbias
}

define i8 @n8(i8 %x, i8 %y) {
; CHECK-LABEL: @n8(
; CHECK-NEXT:    [[NEGY:%.*]] = sub i8 1, [[Y:%.*]]
; CHECK-NEXT:    [[UNBIASEDX:%.*]] = and i8 [[NEGY]], [[X:%.*]]
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 [[UNBIASEDX]], [[X]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %negy = sub i8 1, %y ; not negation
  %unbiasedx = and i8 %negy, %x
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}

define i8 @n9(i8 %x0, i8 %x1, i8 %y) {
; CHECK-LABEL: @n9(
; CHECK-NEXT:    [[NEGY:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    [[UNBIASEDX:%.*]] = and i8 [[NEGY]], [[X1:%.*]]
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 [[UNBIASEDX]], [[X0:%.*]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %negy = sub i8 0, %y
  %unbiasedx = and i8 %x1, %negy ; not %x0
  %negbias = sub i8 %unbiasedx, %x0 ; not %x1
  ret i8 %negbias
}
