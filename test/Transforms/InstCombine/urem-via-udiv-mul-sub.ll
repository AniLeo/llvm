; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Fold
;   x - ((x / y) * y)
; to
;   x % y

; Also,
;   ((x / y) * y)
; can then be simplified to
;   x - (x % y)

declare void @use8(i8)
declare void @use2xi8(<2 x i8>)

define i8 @t0_basic(i8 %x, i8 %y) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[DIV]])
; CHECK-NEXT:    [[ROUNDXDOWNTOMULTIPLEOFY:%.*]] = mul i8 [[DIV]], [[Y]]
; CHECK-NEXT:    [[REM:%.*]] = sub i8 [[X]], [[ROUNDXDOWNTOMULTIPLEOFY]]
; CHECK-NEXT:    ret i8 [[REM]]
;
  %div = udiv i8 %x, %y
  call void @use8(i8 %div)
  %roundXdownToMultipleOfY = mul i8 %div, %y
  %rem = sub i8 %x, %roundXdownToMultipleOfY
  ret i8 %rem
}

define <2 x i8> @t1_vector(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t1_vector(
; CHECK-NEXT:    [[DIV:%.*]] = udiv <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use2xi8(<2 x i8> [[DIV]])
; CHECK-NEXT:    [[ROUNDXDOWNTOMULTIPLEOFY:%.*]] = mul <2 x i8> [[DIV]], [[Y]]
; CHECK-NEXT:    [[REM:%.*]] = sub <2 x i8> [[X]], [[ROUNDXDOWNTOMULTIPLEOFY]]
; CHECK-NEXT:    ret <2 x i8> [[REM]]
;
  %div = udiv <2 x i8> %x, %y
  call void @use2xi8(<2 x i8> %div)
  %roundXdownToMultipleOfY = mul <2 x i8> %div, %y
  %rem = sub <2 x i8> %x, %roundXdownToMultipleOfY
  ret <2 x i8> %rem
}

; Extra use

define i8 @t4_extrause(i8 %x, i8 %y) {
; CHECK-LABEL: @t4_extrause(
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[DIV]])
; CHECK-NEXT:    [[ROUNDXDOWNTOMULTIPLEOFY:%.*]] = mul i8 [[DIV]], [[Y]]
; CHECK-NEXT:    call void @use8(i8 [[ROUNDXDOWNTOMULTIPLEOFY]])
; CHECK-NEXT:    [[REM:%.*]] = sub i8 [[X]], [[ROUNDXDOWNTOMULTIPLEOFY]]
; CHECK-NEXT:    ret i8 [[REM]]
;
  %div = udiv i8 %x, %y
  call void @use8(i8 %div)
  %roundXdownToMultipleOfY = mul i8 %div, %y
  call void @use8(i8 %roundXdownToMultipleOfY)
  %rem = sub i8 %x, %roundXdownToMultipleOfY
  ret i8 %rem
}

; Commutativity

declare i8 @gen8()

define i8 @t5_commutative(i8 %x) {
; CHECK-LABEL: @t5_commutative(
; CHECK-NEXT:    [[Y:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[X:%.*]], [[Y]]
; CHECK-NEXT:    call void @use8(i8 [[DIV]])
; CHECK-NEXT:    [[ROUNDXDOWNTOMULTIPLEOFY:%.*]] = mul i8 [[Y]], [[DIV]]
; CHECK-NEXT:    [[REM:%.*]] = sub i8 [[X]], [[ROUNDXDOWNTOMULTIPLEOFY]]
; CHECK-NEXT:    ret i8 [[REM]]
;
  %y = call i8 @gen8()
  %div = udiv i8 %x, %y
  call void @use8(i8 %div)
  %roundXdownToMultipleOfY = mul i8 %y, %div ; swapped
  %rem = sub i8 %x, %roundXdownToMultipleOfY
  ret i8 %rem
}

; Negative tests

define i8 @n6_different_x(i8 %x0, i8 %x1, i8 %y) {
; CHECK-LABEL: @n6_different_x(
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[X0:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[DIV]])
; CHECK-NEXT:    [[ROUNDXDOWNTOMULTIPLEOFY:%.*]] = mul i8 [[DIV]], [[Y]]
; CHECK-NEXT:    [[REM:%.*]] = sub i8 [[X1:%.*]], [[ROUNDXDOWNTOMULTIPLEOFY]]
; CHECK-NEXT:    ret i8 [[REM]]
;
  %div = udiv i8 %x0, %y
  call void @use8(i8 %div)
  %roundXdownToMultipleOfY = mul i8 %div, %y
  %rem = sub i8 %x1, %roundXdownToMultipleOfY
  ret i8 %rem
}

define i8 @n6_different_y(i8 %x, i8 %y0, i8 %y1) {
; CHECK-LABEL: @n6_different_y(
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[X:%.*]], [[Y0:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[DIV]])
; CHECK-NEXT:    [[ROUNDXDOWNTOMULTIPLEOFY:%.*]] = mul i8 [[DIV]], [[Y1:%.*]]
; CHECK-NEXT:    [[REM:%.*]] = sub i8 [[X]], [[ROUNDXDOWNTOMULTIPLEOFY]]
; CHECK-NEXT:    ret i8 [[REM]]
;
  %div = udiv i8 %x, %y0
  call void @use8(i8 %div)
  %roundXdownToMultipleOfY = mul i8 %div, %y1
  %rem = sub i8 %x, %roundXdownToMultipleOfY
  ret i8 %rem
}
