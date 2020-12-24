; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine %s | FileCheck %s

define <2 x i8> @add_constant(i8 %x) {
; CHECK-LABEL: @add_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = add <2 x i8> [[INS]], <i8 42, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = add <2 x i8> %ins, <i8 42, i8 undef>
  ret <2 x i8> %bo
}

define <2 x i8> @add_constant_not_undef_lane(i8 %x) {
; CHECK-LABEL: @add_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = add <2 x i8> [[INS]], <i8 42, i8 -42>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = add <2 x i8> %ins, <i8 42, i8 -42>
  ret <2 x i8> %bo
}

; IR flags are not required, but they should propagate.

define <2 x i8> @sub_constant_op0(i8 %x) {
; CHECK-LABEL: @sub_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = sub nuw nsw <2 x i8> <i8 undef, i8 -42>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = sub nsw nuw <2 x i8> <i8 undef, i8 -42>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @sub_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @sub_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = sub nuw <2 x i8> <i8 42, i8 -42>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = sub nuw <2 x i8> <i8 42, i8 -42>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @sub_constant_op1(i8 %x) {
; CHECK-LABEL: @sub_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = add <2 x i8> [[INS]], <i8 -42, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = sub nuw <2 x i8> %ins, <i8 42, i8 undef>
  ret <2 x i8> %bo
}

define <2 x i8> @sub_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @sub_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = add <2 x i8> [[INS]], <i8 -42, i8 42>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = sub nuw <2 x i8> %ins, <i8 42, i8 -42>
  ret <2 x i8> %bo
}

define <3 x i8> @mul_constant(i8 %x) {
; CHECK-LABEL: @mul_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <3 x i8> poison, i8 [[X:%.*]], i32 2
; CHECK-NEXT:    [[BO:%.*]] = mul <3 x i8> [[INS]], <i8 undef, i8 undef, i8 -42>
; CHECK-NEXT:    ret <3 x i8> [[BO]]
;
  %ins = insertelement <3 x i8> poison, i8 %x, i32 2
  %bo = mul <3 x i8> %ins, <i8 undef, i8 undef, i8 -42>
  ret <3 x i8> %bo
}

define <3 x i8> @mul_constant_not_undef_lane(i8 %x) {
; CHECK-LABEL: @mul_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <3 x i8> poison, i8 [[X:%.*]], i32 2
; CHECK-NEXT:    [[BO:%.*]] = mul <3 x i8> [[INS]], <i8 42, i8 undef, i8 -42>
; CHECK-NEXT:    ret <3 x i8> [[BO]]
;
  %ins = insertelement <3 x i8> poison, i8 %x, i32 2
  %bo = mul <3 x i8> %ins, <i8 42, i8 undef, i8 -42>
  ret <3 x i8> %bo
}

define <2 x i8> @shl_constant_op0(i8 %x) {
; CHECK-LABEL: @shl_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = shl <2 x i8> <i8 undef, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = shl <2 x i8> <i8 undef, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @shl_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @shl_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = shl <2 x i8> <i8 5, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = shl <2 x i8> <i8 5, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @shl_constant_op1(i8 %x) {
; CHECK-LABEL: @shl_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = shl nuw <2 x i8> [[INS]], <i8 5, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = shl nuw <2 x i8> %ins, <i8 5, i8 undef>
  ret <2 x i8> %bo
}

define <2 x i8> @shl_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @shl_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = shl nuw <2 x i8> [[INS]], <i8 5, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = shl nuw <2 x i8> %ins, <i8 5, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @ashr_constant_op0(i8 %x) {
; CHECK-LABEL: @ashr_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = ashr exact <2 x i8> <i8 undef, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = ashr exact <2 x i8> <i8 undef, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @ashr_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @ashr_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = lshr <2 x i8> <i8 5, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = ashr exact <2 x i8> <i8 5, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @ashr_constant_op1(i8 %x) {
; CHECK-LABEL: @ashr_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = ashr <2 x i8> [[INS]], <i8 5, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = ashr <2 x i8> %ins, <i8 5, i8 undef>
  ret <2 x i8> %bo
}

define <2 x i8> @ashr_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @ashr_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = ashr <2 x i8> [[INS]], <i8 5, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = ashr <2 x i8> %ins, <i8 5, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @lshr_constant_op0(i8 %x) {
; CHECK-LABEL: @lshr_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = lshr <2 x i8> <i8 5, i8 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = lshr <2 x i8> <i8 5, i8 undef>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @lshr_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @lshr_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = lshr <2 x i8> <i8 5, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = lshr <2 x i8> <i8 5, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @lshr_constant_op1(i8 %x) {
; CHECK-LABEL: @lshr_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = lshr exact <2 x i8> [[INS]], <i8 undef, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = lshr exact <2 x i8> %ins, <i8 undef, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @lshr_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @lshr_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = lshr exact <2 x i8> [[INS]], <i8 5, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = lshr exact <2 x i8> %ins, <i8 5, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @urem_constant_op0(i8 %x) {
; CHECK-LABEL: @urem_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = urem <2 x i8> <i8 5, i8 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = urem <2 x i8> <i8 5, i8 undef>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @urem_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @urem_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = urem <2 x i8> <i8 5, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = urem <2 x i8> <i8 5, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @urem_constant_op1(i8 %x) {
; CHECK-LABEL: @urem_constant_op1(
; CHECK-NEXT:    ret <2 x i8> undef
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = urem <2 x i8> %ins, <i8 undef, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @urem_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @urem_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = urem <2 x i8> [[INS]], <i8 5, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = urem <2 x i8> %ins, <i8 5, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @srem_constant_op0(i8 %x) {
; CHECK-LABEL: @srem_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = srem <2 x i8> <i8 5, i8 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = srem <2 x i8> <i8 5, i8 undef>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @srem_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @srem_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = srem <2 x i8> <i8 5, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = srem <2 x i8> <i8 5, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @srem_constant_op1(i8 %x) {
; CHECK-LABEL: @srem_constant_op1(
; CHECK-NEXT:    ret <2 x i8> undef
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = srem <2 x i8> %ins, <i8 undef, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @srem_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @srem_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = srem <2 x i8> [[INS]], <i8 5, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = srem <2 x i8> %ins, <i8 5, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @udiv_constant_op0(i8 %x) {
; CHECK-LABEL: @udiv_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = udiv exact <2 x i8> <i8 5, i8 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = udiv exact <2 x i8> <i8 5, i8 undef>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @udiv_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @udiv_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = udiv exact <2 x i8> <i8 5, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = udiv exact <2 x i8> <i8 5, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @udiv_constant_op1(i8 %x) {
; CHECK-LABEL: @udiv_constant_op1(
; CHECK-NEXT:    ret <2 x i8> undef
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = udiv <2 x i8> %ins, <i8 undef, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @udiv_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @udiv_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = udiv <2 x i8> [[INS]], <i8 5, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = udiv <2 x i8> %ins, <i8 5, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @sdiv_constant_op0(i8 %x) {
; CHECK-LABEL: @sdiv_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = sdiv <2 x i8> <i8 5, i8 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = sdiv <2 x i8> <i8 5, i8 undef>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @sdiv_constant_op0_not_undef_lane(i8 %x) {
; CHECK-LABEL: @sdiv_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = sdiv <2 x i8> <i8 5, i8 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = sdiv <2 x i8> <i8 5, i8 2>, %ins
  ret <2 x i8> %bo
}

define <2 x i8> @sdiv_constant_op1(i8 %x) {
; CHECK-LABEL: @sdiv_constant_op1(
; CHECK-NEXT:    ret <2 x i8> undef
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = sdiv exact <2 x i8> %ins, <i8 undef, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @sdiv_constant_op1_not_undef_lane(i8 %x) {
; CHECK-LABEL: @sdiv_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = sdiv exact <2 x i8> [[INS]], <i8 5, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = sdiv exact <2 x i8> %ins, <i8 5, i8 2>
  ret <2 x i8> %bo
}

define <2 x i8> @and_constant(i8 %x) {
; CHECK-LABEL: @and_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = and <2 x i8> [[INS]], <i8 42, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = and <2 x i8> %ins, <i8 42, i8 undef>
  ret <2 x i8> %bo
}

define <2 x i8> @and_constant_not_undef_lane(i8 %x) {
; CHECK-LABEL: @and_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = and <2 x i8> [[INS]], <i8 42, i8 -42>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = and <2 x i8> %ins, <i8 42, i8 -42>
  ret <2 x i8> %bo
}

define <2 x i8> @or_constant(i8 %x) {
; CHECK-LABEL: @or_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = or <2 x i8> [[INS]], <i8 undef, i8 -42>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = or <2 x i8> %ins, <i8 undef, i8 -42>
  ret <2 x i8> %bo
}

define <2 x i8> @or_constant_not_undef_lane(i8 %x) {
; CHECK-LABEL: @or_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = or <2 x i8> [[INS]], <i8 42, i8 -42>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 1
  %bo = or <2 x i8> %ins, <i8 42, i8 -42>
  ret <2 x i8> %bo
}

define <2 x i8> @xor_constant(i8 %x) {
; CHECK-LABEL: @xor_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = xor <2 x i8> [[INS]], <i8 42, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = xor <2 x i8> %ins, <i8 42, i8 undef>
  ret <2 x i8> %bo
}

define <2 x i8> @xor_constant_not_undef_lane(i8 %x) {
; CHECK-LABEL: @xor_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i8> poison, i8 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = xor <2 x i8> [[INS]], <i8 42, i8 -42>
; CHECK-NEXT:    ret <2 x i8> [[BO]]
;
  %ins = insertelement <2 x i8> poison, i8 %x, i32 0
  %bo = xor <2 x i8> %ins, <i8 42, i8 -42>
  ret <2 x i8> %bo
}

define <2 x float> @fadd_constant(float %x) {
; CHECK-LABEL: @fadd_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fadd <2 x float> [[INS]], <float 4.200000e+01, float undef>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = fadd <2 x float> %ins, <float 42.0, float undef>
  ret <2 x float> %bo
}

define <2 x float> @fadd_constant_not_undef_lane(float %x) {
; CHECK-LABEL: @fadd_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fadd <2 x float> [[INS]], <float 4.200000e+01, float -4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 1
  %bo = fadd <2 x float> %ins, <float 42.0, float -42.0>
  ret <2 x float> %bo
}

define <2 x float> @fsub_constant_op0(float %x) {
; CHECK-LABEL: @fsub_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fsub fast <2 x float> <float 4.200000e+01, float undef>, [[INS]]
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = fsub fast <2 x float> <float 42.0, float undef>, %ins
  ret <2 x float> %bo
}

define <2 x float> @fsub_constant_op0_not_undef_lane(float %x) {
; CHECK-LABEL: @fsub_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fsub nsz <2 x float> <float 4.200000e+01, float -4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 1
  %bo = fsub nsz <2 x float> <float 42.0, float -42.0>, %ins
  ret <2 x float> %bo
}

define <2 x float> @fsub_constant_op1(float %x) {
; CHECK-LABEL: @fsub_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fadd <2 x float> [[INS]], <float undef, float -4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 1
  %bo = fsub <2 x float> %ins, <float undef, float 42.0>
  ret <2 x float> %bo
}

define <2 x float> @fsub_constant_op1_not_undef_lane(float %x) {
; CHECK-LABEL: @fsub_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fadd <2 x float> [[INS]], <float -4.200000e+01, float 4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = fsub <2 x float> %ins, <float 42.0, float -42.0>
  ret <2 x float> %bo
}

define <2 x float> @fmul_constant(float %x) {
; CHECK-LABEL: @fmul_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fmul reassoc <2 x float> [[INS]], <float 4.200000e+01, float undef>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = fmul reassoc <2 x float> %ins, <float 42.0, float undef>
  ret <2 x float> %bo
}

define <2 x float> @fmul_constant_not_undef_lane(float %x) {
; CHECK-LABEL: @fmul_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fmul <2 x float> [[INS]], <float 4.200000e+01, float -4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 1
  %bo = fmul <2 x float> %ins, <float 42.0, float -42.0>
  ret <2 x float> %bo
}

define <2 x float> @fdiv_constant_op0(float %x) {
; CHECK-LABEL: @fdiv_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fdiv nnan <2 x float> <float undef, float 4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 1
  %bo = fdiv nnan <2 x float> <float undef, float 42.0>, %ins
  ret <2 x float> %bo
}

define <2 x float> @fdiv_constant_op0_not_undef_lane(float %x) {
; CHECK-LABEL: @fdiv_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fdiv ninf <2 x float> <float 4.200000e+01, float -4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = fdiv ninf <2 x float> <float 42.0, float -42.0>, %ins
  ret <2 x float> %bo
}

define <2 x float> @fdiv_constant_op1(float %x) {
; CHECK-LABEL: @fdiv_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fdiv <2 x float> [[INS]], <float 4.200000e+01, float undef>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = fdiv <2 x float> %ins, <float 42.0, float undef>
  ret <2 x float> %bo
}

define <2 x float> @fdiv_constant_op1_not_undef_lane(float %x) {
; CHECK-LABEL: @fdiv_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fdiv <2 x float> [[INS]], <float 4.200000e+01, float -4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = fdiv <2 x float> %ins, <float 42.0, float -42.0>
  ret <2 x float> %bo
}

define <2 x float> @frem_constant_op0(float %x) {
; CHECK-LABEL: @frem_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = frem fast <2 x float> <float 4.200000e+01, float undef>, [[INS]]
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = frem fast <2 x float> <float 42.0, float undef>, %ins
  ret <2 x float> %bo
}

define <2 x float> @frem_constant_op0_not_undef_lane(float %x) {
; CHECK-LABEL: @frem_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = frem <2 x float> <float 4.200000e+01, float -4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 1
  %bo = frem <2 x float> <float 42.0, float -42.0>, %ins
  ret <2 x float> %bo
}

define <2 x float> @frem_constant_op1(float %x) {
; CHECK-LABEL: @frem_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = frem ninf <2 x float> [[INS]], <float undef, float 4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 1
  %bo = frem ninf <2 x float> %ins, <float undef, float 42.0>
  ret <2 x float> %bo
}

define <2 x float> @frem_constant_op1_not_undef_lane(float %x) {
; CHECK-LABEL: @frem_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x float> poison, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = frem nnan <2 x float> [[INS]], <float 4.200000e+01, float -4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[BO]]
;
  %ins = insertelement <2 x float> poison, float %x, i32 0
  %bo = frem nnan <2 x float> %ins, <float 42.0, float -42.0>
  ret <2 x float> %bo
}

