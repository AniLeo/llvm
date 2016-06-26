; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s


define i32 @foo(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[E:%.*]] = icmp slt i32 %a, %b
; CHECK-NEXT:    [[J:%.*]] = select i1 [[E]], i32 %c, i32 %d
; CHECK-NEXT:    ret i32 [[J]]
;
  %e = icmp slt i32 %a, %b
  %f = sext i1 %e to i32
  %g = and i32 %c, %f
  %h = xor i32 %f, -1
  %i = and i32 %d, %h
  %j = or i32 %g, %i
  ret i32 %j
}

define i32 @bar(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[E:%.*]] = icmp slt i32 %a, %b
; CHECK-NEXT:    [[J:%.*]] = select i1 [[E]], i32 %c, i32 %d
; CHECK-NEXT:    ret i32 [[J]]
;
  %e = icmp slt i32 %a, %b
  %f = sext i1 %e to i32
  %g = and i32 %c, %f
  %h = xor i32 %f, -1
  %i = and i32 %d, %h
  %j = or i32 %i, %g
  ret i32 %j
}

define i32 @goo(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @goo(
; CHECK-NEXT:    [[T0:%.*]] = icmp slt i32 %a, %b
; CHECK-NEXT:    [[T3:%.*]] = select i1 [[T0]], i32 %c, i32 %d
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = icmp slt i32 %a, %b
  %iftmp.0.0 = select i1 %t0, i32 -1, i32 0
  %t1 = and i32 %iftmp.0.0, %c
  %not = xor i32 %iftmp.0.0, -1
  %t2 = and i32 %not, %d
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

define i32 @poo(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @poo(
; CHECK-NEXT:    [[T0:%.*]] = icmp slt i32 %a, %b
; CHECK-NEXT:    [[T3:%.*]] = select i1 [[T0]], i32 %c, i32 %d
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = icmp slt i32 %a, %b
  %iftmp.0.0 = select i1 %t0, i32 -1, i32 0
  %t1 = and i32 %iftmp.0.0, %c
  %iftmp = select i1 %t0, i32 0, i32 -1
  %t2 = and i32 %iftmp, %d
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

define i32 @par(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @par(
; CHECK-NEXT:    [[T0:%.*]] = icmp slt i32 %a, %b
; CHECK-NEXT:    [[T3:%.*]] = select i1 [[T0]], i32 %c, i32 %d
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = icmp slt i32 %a, %b
  %iftmp.1.0 = select i1 %t0, i32 -1, i32 0
  %t1 = and i32 %iftmp.1.0, %c
  %not = xor i32 %iftmp.1.0, -1
  %t2 = and i32 %not, %d
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

; In the following tests (8 commutation variants), verify that a bitcast doesn't get
; in the way of a select transform. These bitcasts are common in SSE/AVX and possibly
; other vector code because of canonicalization to i64 elements for vectors.

; The fptosi instructions are included to avoid commutation canonicalization based on
; operator weight. Using another cast operator ensures that both operands of all logic
; ops are equally weighted, and this ensures that we're testing all commutation
; possibilities.

define <2 x i64> @bitcast_select_swap0(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap0(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap1(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap1(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap2(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap2(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap3(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap3(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap4(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap4(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap5(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap5(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap6(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap6(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap7(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap7(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> %a to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> %b to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> %cmp, <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[OR:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

; FIXME: Missed conversions to select below here.

define i1 @bools(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @bools(
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 %c, true
; CHECK-NEXT:    [[AND1:%.*]] = and i1 [[NOT]], %a
; CHECK-NEXT:    [[AND2:%.*]] = and i1 %c, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[AND1]], [[AND2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %not = xor i1 %c, -1
  %and1 = and i1 %not, %a
  %and2 = and i1 %c, %b
  %or = or i1 %and1, %and2
  ret i1 %or
}

define <4 x i1> @vec_of_bools(<4 x i1> %a, <4 x i1> %b, <4 x i1> %c) {
; CHECK-LABEL: @vec_of_bools(
; CHECK-NEXT:    [[NOT:%.*]] = xor <4 x i1> %c, <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i1> [[NOT]], %a
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i1> %b, %c
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i1> [[AND2]], [[AND1]]
; CHECK-NEXT:    ret <4 x i1> [[OR]]
;
  %not = xor <4 x i1> %c, <i1 true, i1 true, i1 true, i1 true>
  %and1 = and <4 x i1> %not, %a
  %and2 = and <4 x i1> %b, %c
  %or = or <4 x i1> %and2, %and1
  ret <4 x i1> %or
}

define i4 @vec_of_casted_bools(i4 %a, i4 %b, <4 x i1> %c) {
; CHECK-LABEL: @vec_of_casted_bools(
; CHECK-NEXT:    [[NOT:%.*]] = xor <4 x i1> %c, <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <4 x i1> [[NOT]] to i4
; CHECK-NEXT:    [[BC2:%.*]] = bitcast <4 x i1> %c to i4
; CHECK-NEXT:    [[AND1:%.*]] = and i4 [[BC1]], %a
; CHECK-NEXT:    [[AND2:%.*]] = and i4 [[BC2]], %b
; CHECK-NEXT:    [[OR:%.*]] = or i4 [[AND1]], [[AND2]]
; CHECK-NEXT:    ret i4 [[OR]]
;
  %not = xor <4 x i1> %c, <i1 true, i1 true, i1 true, i1 true>
  %bc1 = bitcast <4 x i1> %not to i4
  %bc2 = bitcast <4 x i1> %c to i4
  %and1 = and i4 %a, %bc1
  %and2 = and i4 %bc2, %b
  %or = or i4 %and1, %and2
  ret i4 %or
}

; Inverted 'and' constants mean this is a select.

define <4 x i32> @vec_sel_consts(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @vec_sel_consts(
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 -1>
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i32> %b, <i32 0, i32 -1, i32 -1, i32 0>
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i32> [[AND1]], [[AND2]]
; CHECK-NEXT:    ret <4 x i32> [[OR]]
;
  %and1 = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 -1>
  %and2 = and <4 x i32> %b, <i32 0, i32 -1, i32 -1, i32 0>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}

; The select condition constant is always derived from the first operand of the 'or'.

define <3 x i129> @vec_sel_consts_weird(<3 x i129> %a, <3 x i129> %b) {
; CHECK-LABEL: @vec_sel_consts_weird(
; CHECK-NEXT:    [[AND1:%.*]] = and <3 x i129> %a, <i129 -1, i129 0, i129 -1>
; CHECK-NEXT:    [[AND2:%.*]] = and <3 x i129> %b, <i129 0, i129 -1, i129 0>
; CHECK-NEXT:    [[OR:%.*]] = or <3 x i129> [[AND2]], [[AND1]]
; CHECK-NEXT:    ret <3 x i129> [[OR]]
;
  %and1 = and <3 x i129> %a, <i129 -1, i129 0, i129 -1>
  %and2 = and <3 x i129> %b, <i129 0, i129 -1, i129 0>
  %or = or <3 x i129> %and2, %and1
  ret <3 x i129> %or
}

; The mask elements must be inverted for this to be a select.

define <4 x i32> @vec_not_sel_consts(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @vec_not_sel_consts(
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 0>
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i32> %b, <i32 0, i32 -1, i32 0, i32 -1>
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i32> [[AND1]], [[AND2]]
; CHECK-NEXT:    ret <4 x i32> [[OR]]
;
  %and1 = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 0>
  %and2 = and <4 x i32> %b, <i32 0, i32 -1, i32 0, i32 -1>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}

; The inverted constants may be operands of xor instructions.

define <4 x i32> @vec_sel_xor(<4 x i32> %a, <4 x i32> %b, <4 x i1> %c) {
; CHECK-LABEL: @vec_sel_xor(
; CHECK-NEXT:    [[MASK:%.*]] = sext <4 x i1> %c to <4 x i32>
; CHECK-NEXT:    [[MASK_FLIP1:%.*]] = xor <4 x i32> [[MASK]], <i32 -1, i32 0, i32 0, i32 0>
; CHECK-NEXT:    [[NOT_MASK_FLIP1:%.*]] = xor <4 x i32> [[MASK]], <i32 0, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i32> [[NOT_MASK_FLIP1]], %a
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i32> [[MASK_FLIP1]], %b
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i32> [[AND1]], [[AND2]]
; CHECK-NEXT:    ret <4 x i32> [[OR]]
;
  %mask = sext <4 x i1> %c to <4 x i32>
  %mask_flip1 = xor <4 x i32> %mask, <i32 -1, i32 0, i32 0, i32 0>
  %not_mask_flip1 = xor <4 x i32> %mask, <i32 0, i32 -1, i32 -1, i32 -1>
  %and1 = and <4 x i32> %not_mask_flip1, %a
  %and2 = and <4 x i32> %mask_flip1, %b
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}

