; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Fold
;   (%x - %y) u> %x
; to
;   @llvm.sub.with.overflow(%x, %y) + extractvalue

define i1 @t0_basic(i8 %x, i8 %y) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp ugt i8 %t0, %x
  ret i1 %r
}

define <2 x i1> @t1_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t1_vec(
; CHECK-NEXT:    [[R:%.*]] = icmp ugt <2 x i8> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %t0 = sub <2 x i8> %x, %y
  %r = icmp ugt <2 x i8> %t0, %x
  ret <2 x i1> %r
}

; Commutativity

define i1 @t2_commutative(i8 %x, i8 %y) {
; CHECK-LABEL: @t2_commutative(
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp ult i8 %x, %t0 ; swapped
  ret i1 %r
}

; Extra-use tests

declare void @use8(i8)

define i1 @t3_extrause0(i8 %x, i8 %y) {
; CHECK-LABEL: @t3_extrause0(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp ult i8 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  call void @use8(i8 %t0)
  %r = icmp ugt i8 %t0, %x
  ret i1 %r
}

; Negative tests

define i1 @n4_not_commutative(i8 %x, i8 %y) {
; CHECK-LABEL: @n4_not_commutative(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp ugt i8 %t0, %y ; can't check against %y.
  ret i1 %r
}

define i1 @n5_wrong_pred0(i8 %x, i8 %y) {
; CHECK-LABEL: @n5_wrong_pred0(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp uge i8 [[T0]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp uge i8 %t0, %x
  ret i1 %r
}

define i1 @n6_wrong_pred1(i8 %x, i8 %y) {
; CHECK-LABEL: @n6_wrong_pred1(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ult i8 [[T0]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp ult i8 %t0, %x
  ret i1 %r
}

define i1 @n7_wrong_pred2(i8 %x, i8 %y) {
; CHECK-LABEL: @n7_wrong_pred2(
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp eq i8 %t0, %x
  ret i1 %r
}

define i1 @n8_wrong_pred3(i8 %x, i8 %y) {
; CHECK-LABEL: @n8_wrong_pred3(
; CHECK-NEXT:    [[R:%.*]] = icmp ne i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp ne i8 %t0, %x
  ret i1 %r
}

define i1 @n9_wrong_pred4(i8 %x, i8 %y) {
; CHECK-LABEL: @n9_wrong_pred4(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[T0]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp slt i8 %t0, %x
  ret i1 %r
}

define i1 @n10_wrong_pred5(i8 %x, i8 %y) {
; CHECK-LABEL: @n10_wrong_pred5(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sle i8 [[T0]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp sle i8 %t0, %x
  ret i1 %r
}

define i1 @n11_wrong_pred6(i8 %x, i8 %y) {
; CHECK-LABEL: @n11_wrong_pred6(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[T0]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp sgt i8 %t0, %x
  ret i1 %r
}

define i1 @n12_wrong_pred7(i8 %x, i8 %y) {
; CHECK-LABEL: @n12_wrong_pred7(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sge i8 [[T0]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = sub i8 %x, %y
  %r = icmp sge i8 %t0, %x
  ret i1 %r
}
