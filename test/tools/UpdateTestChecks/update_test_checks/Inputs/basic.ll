; Example input for update_test_checks (taken from test/Transforms/InstSimplify/add.ll)
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

define i32 @common_sub_operand(i32 %X, i32 %Y) {
; CHECK-LABEL: @common_sub_operand(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %Z = sub i32 %X, %Y
  %Q = add i32 %Z, %Y
  ret i32 %Q
}

define i32 @negated_operand(i32 %x) {
; CHECK-LABEL: @negated_operand(
; CHECK-NEXT:    ret i32 0
;
  %negx = sub i32 0, %x
  %r = add i32 %negx, %x
  ret i32 %r
}

define <2 x i32> @negated_operand_commute_vec(<2 x i32> %x) {
; CHECK-LABEL: @negated_operand_commute_vec(
; CHECK-NEXT:    ret <2 x i32> zeroinitializer
;
  %negx = sub <2 x i32> zeroinitializer, %x
  %r = add <2 x i32> %x, %negx
  ret <2 x i32> %r
}

define i8 @knownnegation(i8 %x, i8 %y) {
; CHECK-LABEL: @knownnegation(
; CHECK-NEXT:    ret i8 0
;
  %xy = sub i8 %x, %y
  %yx = sub i8 %y, %x
  %r = add i8 %xy, %yx
  ret i8 %r
}

define <2 x i8> @knownnegation_commute_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @knownnegation_commute_vec(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %xy = sub <2 x i8> %x, %y
  %yx = sub <2 x i8> %y, %x
  %r = add <2 x i8> %yx, %xy
  ret <2 x i8> %r
}

define i32 @nameless_value(i32 %X) {
; CHECK-LABEL: @nameless_value(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 42, [[X:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = sub i32 42, %X
  ret i32 %1
}
