; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define i32 @poison(i32 %x) {
; CHECK-LABEL: @poison(
; CHECK-NEXT:    ret i32 poison
;
  %v = and i32 %x, poison
  ret i32 %v
}

; (X | Y) & (X | ~Y) --> X (commuted 8 ways)

define i8 @or_or_not_commute0(i8 %x, i8 %y) {
; CHECK-LABEL: @or_or_not_commute0(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %ynot = xor i8 %y, -1
  %xory = or i8 %x, %y
  %xorynot = or i8 %x, %ynot
  %and = and i8 %xory, %xorynot
  ret i8 %and
}

define <2 x i5> @or_or_not_commute1(<2 x i5> %x, <2 x i5> %y) {
; CHECK-LABEL: @or_or_not_commute1(
; CHECK-NEXT:    ret <2 x i5> [[X:%.*]]
;
  %ynot = xor <2 x i5> %y, <i5 -1, i5 -1>
  %xory = or <2 x i5> %x, %y
  %xorynot = or <2 x i5> %x, %ynot
  %and = and <2 x i5> %xorynot, %xory
  ret <2 x i5> %and
}

define <2 x i8> @or_or_not_commute2(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @or_or_not_commute2(
; CHECK-NEXT:    ret <2 x i8> [[X:%.*]]
;
  %ynot = xor <2 x i8> %y, <i8 poison, i8 -1>
  %xory = or <2 x i8> %x, %y
  %xorynot = or <2 x i8> %ynot, %x
  %and = and <2 x i8> %xory, %xorynot
  ret <2 x i8> %and
}

define i8 @or_or_not_commute3(i8 %x, i8 %y) {
; CHECK-LABEL: @or_or_not_commute3(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %ynot = xor i8 %y, -1
  %xory = or i8 %x, %y
  %xorynot = or i8 %ynot, %x
  %and = and i8 %xorynot, %xory
  ret i8 %and
}
define i8 @or_or_not_commute4(i8 %x, i8 %y) {
; CHECK-LABEL: @or_or_not_commute4(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %ynot = xor i8 %y, -1
  %xory = or i8 %y, %x
  %xorynot = or i8 %x, %ynot
  %and = and i8 %xory, %xorynot
  ret i8 %and
}

define i8 @or_or_not_commute5(i8 %x, i8 %y) {
; CHECK-LABEL: @or_or_not_commute5(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %ynot = xor i8 %y, -1
  %xory = or i8 %y, %x
  %xorynot = or i8 %x, %ynot
  %and = and i8 %xorynot, %xory
  ret i8 %and
}

define i8 @or_or_not_commute6(i8 %x, i8 %y) {
; CHECK-LABEL: @or_or_not_commute6(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %ynot = xor i8 %y, -1
  %xory = or i8 %y, %x
  %xorynot = or i8 %ynot, %x
  %and = and i8 %xory, %xorynot
  ret i8 %and
}

define i8 @or_or_not_commute7(i8 %x, i8 %y) {
; CHECK-LABEL: @or_or_not_commute7(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %ynot = xor i8 %y, -1
  %xory = or i8 %y, %x
  %xorynot = or i8 %ynot, %x
  %and = and i8 %xorynot, %xory
  ret i8 %and
}

; negative test - wrong logic op

define i8 @or_xor_not(i8 %x, i8 %y) {
; CHECK-LABEL: @or_xor_not(
; CHECK-NEXT:    [[YNOT:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[XXORY:%.*]] = xor i8 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[XORYNOT:%.*]] = or i8 [[X]], [[YNOT]]
; CHECK-NEXT:    [[AND:%.*]] = and i8 [[XORYNOT]], [[XXORY]]
; CHECK-NEXT:    ret i8 [[AND]]
;
  %ynot = xor i8 %y, -1
  %xxory = xor i8 %y, %x
  %xorynot = or i8 %x, %ynot
  %and = and i8 %xorynot, %xxory
  ret i8 %and
}

; negative test - must have common operands

define i8 @or_or_not_no_common_op(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @or_or_not_no_common_op(
; CHECK-NEXT:    [[XORZ:%.*]] = or i8 [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[YNOT:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[XORYNOT:%.*]] = or i8 [[X]], [[YNOT]]
; CHECK-NEXT:    [[AND:%.*]] = and i8 [[XORYNOT]], [[XORZ]]
; CHECK-NEXT:    ret i8 [[AND]]
;
  %xorz = or i8 %z, %x
  %ynot = xor i8 %y, -1
  %xorynot = or i8 %x, %ynot
  %and = and i8 %xorynot, %xorz
  ret i8 %and
}
