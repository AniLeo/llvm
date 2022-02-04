; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Should fold
;   (%y ^ -1) u< %x
; to
;   @llvm.uadd.with.overflow(%x, %y) + extractvalue + not
;
; All tests here have extra uses, to ensure that the pattern isn't perturbed.

declare void @use8(i8)
declare void @use2x8(<2 x i8>)

define i1 @t0_basic(i8 %x, i8 %y) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp ult i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp ult i8 %t0, %x
  ret i1 %r
}

define <2 x i1> @t1_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t1_vec(
; CHECK-NEXT:    [[T0:%.*]] = xor <2 x i8> [[Y:%.*]], <i8 -1, i8 -1>
; CHECK-NEXT:    call void @use2x8(<2 x i8> [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp ult <2 x i8> [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %t0 = xor <2 x i8> %y, <i8 -1, i8 -1>
  call void @use2x8(<2 x i8> %t0)
  %r = icmp ult <2 x i8> %t0, %x
  ret <2 x i1> %r
}

; Commutativity

declare i8 @gen8()

define i1 @t2_commutative(i8 %y) {
; CHECK-LABEL: @t2_commutative(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[R:%.*]] = icmp ule i8 [[X]], [[T0]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %x = call i8 @gen8()
  %r = icmp ule i8 %x, %t0 ; swapped
  ret i1 %r
}

; Extra-use tests

define i1 @t3_no_extrause(i8 %x, i8 %y) {
; CHECK-LABEL: @t3_no_extrause(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = icmp ult i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  %r = icmp ult i8 %t0, %x
  ret i1 %r
}

; Negative tests

define i1 @n4_wrong_pred0(i8 %x, i8 %y) {
; CHECK-LABEL: @n4_wrong_pred0(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp ule i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp ule i8 %t0, %x
  ret i1 %r
}

define i1 @n5_wrong_pred1(i8 %x, i8 %y) {
; CHECK-LABEL: @n5_wrong_pred1(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp ugt i8 %t0, %x
  ret i1 %r
}

define i1 @n6_wrong_pred2(i8 %x, i8 %y) {
; CHECK-LABEL: @n6_wrong_pred2(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp eq i8 %t0, %x
  ret i1 %r
}

define i1 @n7_wrong_pred3(i8 %x, i8 %y) {
; CHECK-LABEL: @n7_wrong_pred3(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp ne i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp ne i8 %t0, %x
  ret i1 %r
}

define i1 @n8_wrong_pred4(i8 %x, i8 %y) {
; CHECK-LABEL: @n8_wrong_pred4(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp slt i8 %t0, %x
  ret i1 %r
}

define i1 @n9_wrong_pred5(i8 %x, i8 %y) {
; CHECK-LABEL: @n9_wrong_pred5(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp sle i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp sle i8 %t0, %x
  ret i1 %r
}

define i1 @n10_wrong_pred6(i8 %x, i8 %y) {
; CHECK-LABEL: @n10_wrong_pred6(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp sgt i8 %t0, %x
  ret i1 %r
}

define i1 @n11_wrong_pred7(i8 %x, i8 %y) {
; CHECK-LABEL: @n11_wrong_pred7(
; CHECK-NEXT:    [[T0:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp sge i8 [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = xor i8 %y, -1
  call void @use8(i8 %t0)
  %r = icmp sge i8 %t0, %x
  ret i1 %r
}

define <2 x i1> @n12_vec_nonsplat(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @n12_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = xor <2 x i8> [[Y:%.*]], <i8 -1, i8 -2>
; CHECK-NEXT:    call void @use2x8(<2 x i8> [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp ult <2 x i8> [[T0]], [[X:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %t0 = xor <2 x i8> %y, <i8 -1, i8 -2> ; must be -1.
  call void @use2x8(<2 x i8> %t0)
  %r = icmp ult <2 x i8> %t0, %x
  ret <2 x i1> %r
}
