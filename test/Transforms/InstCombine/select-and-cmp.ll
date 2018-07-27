; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"

define i32 @select_and_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %z
  %B = icmp eq i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

define <2 x i8> @select_and_icmp_vec(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_and_icmp_vec(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq <2 x i8> [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and <2 x i1> [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select <2 x i1> [[C]], <2 x i8> [[Z]], <2 x i8> [[X]]
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %A = icmp eq <2 x i8> %x, %z
  %B = icmp eq <2 x i8> %y, %z
  %C = and <2 x i1> %A, %B
  %D = select <2 x i1> %C, <2 x i8> %z, <2 x i8> %x
  ret <2 x i8> %D
}

define i32 @select_and_icmp2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[Y]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %z
  %B = icmp eq i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %y
  ret i32 %D
}

define i32 @select_and_inv_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_inv_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[B]], [[A]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %z
  %B = icmp eq i32 %y, %z
  %C = and i1 %B , %A
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

define i32 @select_and_icmp_inv(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp_inv(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Z]], [[Y:%.*]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %z, %x
  %B = icmp eq i32 %z, %y
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

; Negative tests
define i32 @select_and_icmp_pred_bad_1(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp_pred_bad_1(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp ne i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %z
  %B = icmp ne i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

define i32 @select_and_icmp_pred_bad_2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp_pred_bad_2(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp ne i32 %x, %z
  %B = icmp eq i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

define i32 @select_and_icmp_pred_bad_3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp_pred_bad_3(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp ne i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp ne i32 %x, %z
  %B = icmp ne i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

define i32 @select_and_icmp_pred_bad_4(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp_pred_bad_4(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = or i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %z
  %B = icmp eq i32 %y, %z
  %C = or i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

define i32 @select_and_icmp_bad_true_val(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_and_icmp_bad_true_val(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[K:%.*]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %z
  %B = icmp eq i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %k, i32 %x
  ret i32 %D
}

define i32 @select_and_icmp_bad_false_val(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_and_icmp_bad_false_val(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[K:%.*]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %z
  %B = icmp eq i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %k
  ret i32 %D
}

define i32 @select_and_icmp_bad_op(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_and_icmp_bad_op(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[K:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X:%.*]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %k, %z
  %B = icmp eq i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}

define i32 @select_and_icmp_bad_op_2(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_and_icmp_bad_op_2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[K:%.*]]
; CHECK-NEXT:    [[B:%.*]] = icmp eq i32 [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = and i1 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[Z]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %A = icmp eq i32 %x, %k
  %B = icmp eq i32 %y, %z
  %C = and i1 %A, %B
  %D = select i1 %C, i32 %z, i32 %x
  ret i32 %D
}
