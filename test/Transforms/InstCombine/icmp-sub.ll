; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i1 @test_nuw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_and_unsigned_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp ugt i64 [[X:%.*]], 7
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp ult i64 %y, 3
  ret i1 %z
}

define i1 @test_nsw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_nsw_and_signed_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i64 [[X:%.*]], -7
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i64 3, %x
  %z = icmp sgt i64 %y, 10
  ret i1 %z
}

define i1 @test_nuw_nsw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_nsw_and_unsigned_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp ugt i64 [[X:%.*]], 6
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw nsw i64 10, %x
  %z = icmp ule i64 %y, 3
  ret i1 %z
}

define i1 @test_nuw_nsw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_nsw_and_signed_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i64 [[X:%.*]], 7
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw nsw i64 10, %x
  %z = icmp slt i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_nuw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_negative_nuw_and_signed_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nuw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i64 [[Y]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp slt i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_nsw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_negative_nsw_and_unsigned_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nsw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp ult i64 [[Y]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i64 10, %x
  %z = icmp ult i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_combined_sub_unsigned_overflow(i64 %x) {
; CHECK-LABEL: @test_negative_combined_sub_unsigned_overflow(
; CHECK-NEXT:    [[Y:%.*]] = sub nuw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp ult i64 [[Y]], 11
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp ult i64 %y, 11
  ret i1 %z
}

define i1 @test_negative_combined_sub_signed_overflow(i8 %x) {
; CHECK-LABEL: @test_negative_combined_sub_signed_overflow(
; CHECK-NEXT:    [[Y:%.*]] = sub nsw i8 127, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i8 [[Y]], -1
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i8 127, %x
  %z = icmp slt i8 %y, -1
  ret i1 %z
}

define i1 @test_sub_0_Y_eq_0(i8 %y) {
; CHECK-LABEL: @test_sub_0_Y_eq_0(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 0, %y
  %z = icmp eq i8 %s, 0
  ret i1 %z
}

define i1 @test_sub_0_Y_ne_0(i8 %y) {
; CHECK-LABEL: @test_sub_0_Y_ne_0(
; CHECK-NEXT:    [[Z:%.*]] = icmp ne i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 0, %y
  %z = icmp ne i8 %s, 0
  ret i1 %z
}

define i1 @test_sub_4_Y_ne_4(i8 %y) {
; CHECK-LABEL: @test_sub_4_Y_ne_4(
; CHECK-NEXT:    [[Z:%.*]] = icmp ne i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 4, %y
  %z = icmp ne i8 %s, 4
  ret i1 %z
}

define i1 @test_sub_127_Y_eq_127(i8 %y) {
; CHECK-LABEL: @test_sub_127_Y_eq_127(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 127, %y
  %z = icmp eq i8 %s, 127
  ret i1 %z
}

define i1 @test_sub_255_Y_eq_255(i8 %y) {
; CHECK-LABEL: @test_sub_255_Y_eq_255(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 255, %y
  %z = icmp eq i8 %s, 255
  ret i1 %z
}
define <2 x i1> @test_sub_255_Y_eq_255_vec(<2 x i8> %y) {
; CHECK-LABEL: @test_sub_255_Y_eq_255_vec(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq <2 x i8> [[Y:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[Z]]
;
  %s = sub <2 x i8> <i8 255, i8 255>, %y
  %z = icmp eq <2 x i8> %s, <i8 255, i8 255>
  ret <2 x i1> %z
}

define <2 x i1> @icmp_eq_sub_undef(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_undef(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[A:%.*]], <i32 5, i32 undef>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 undef>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 10>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_sub_non_splat(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_non_splat(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[A:%.*]], <i32 5, i32 6>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 16>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 10>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_sub_undef2(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_undef2(
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i32> <i32 15, i32 15>, [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[SUB]], <i32 10, i32 undef>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 15>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 undef>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_sub_non_splat2(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_non_splat2(
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i32> <i32 15, i32 15>, [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[SUB]], <i32 10, i32 11>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 15>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 11>
  ret <2 x i1> %cmp
}
