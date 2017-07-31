; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @func1(i32 %a, i32 %b) {
; CHECK-LABEL: @func1(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, 1
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP1]], %b
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = or i32 %b, %a
  %tmp1 = and i32 %tmp, 1
  %tmp2 = and i32 %b, -2
  %tmp3 = or i32 %tmp1, %tmp2
  ret i32 %tmp3
}

define i32 @func2(i32 %a, i32 %b) {
; CHECK-LABEL: @func2(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, 1
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP1]], %b
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = or i32 %a, %b
  %tmp1 = and i32 1, %tmp
  %tmp2 = and i32 -2, %b
  %tmp3 = or i32 %tmp1, %tmp2
  ret i32 %tmp3
}

define i32 @func3(i32 %a, i32 %b) {
; CHECK-LABEL: @func3(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, 1
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP1]], %b
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = or i32 %b, %a
  %tmp1 = and i32 %tmp, 1
  %tmp2 = and i32 %b, -2
  %tmp3 = or i32 %tmp2, %tmp1
  ret i32 %tmp3
}

define i32 @func4(i32 %a, i32 %b) {
; CHECK-LABEL: @func4(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, 1
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP1]], %b
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = or i32 %a, %b
  %tmp1 = and i32 1, %tmp
  %tmp2 = and i32 -2, %b
  %tmp3 = or i32 %tmp2, %tmp1
  ret i32 %tmp3
}

; Check variants of:
; and ({x}or X, Y), C --> {x}or X, (and Y, C)
; ...in the following 5 tests.

define i8 @and_or_hoist_mask(i8 %a, i8 %b) {
; CHECK-LABEL: @and_or_hoist_mask(
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 %a, 6
; CHECK-NEXT:    [[B_MASKED:%.*]] = and i8 %b, 3
; CHECK-NEXT:    [[AND:%.*]] = or i8 [[SH]], [[B_MASKED]]
; CHECK-NEXT:    ret i8 [[AND]]
;
  %sh = lshr i8 %a, 6
  %or = or i8 %sh, %b
  %and = and i8 %or, 3
  ret i8 %and
}

define <2 x i8> @and_xor_hoist_mask_vec_splat(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @and_xor_hoist_mask_vec_splat(
; CHECK-NEXT:    [[SH:%.*]] = lshr <2 x i8> %a, <i8 6, i8 6>
; CHECK-NEXT:    [[B_MASKED:%.*]] = and <2 x i8> %b, <i8 3, i8 3>
; CHECK-NEXT:    [[AND:%.*]] = xor <2 x i8> [[SH]], [[B_MASKED]]
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %sh = lshr <2 x i8> %a, <i8 6, i8 6>
  %xor = xor <2 x i8> %sh, %b
  %and = and <2 x i8> %xor, <i8 3, i8 3>
  ret <2 x i8> %and
}

define i8 @and_xor_hoist_mask_commute(i8 %a, i8 %b) {
; CHECK-LABEL: @and_xor_hoist_mask_commute(
; CHECK-NEXT:    [[C:%.*]] = mul i8 %b, 43
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 %a, 6
; CHECK-NEXT:    [[C_MASKED:%.*]] = and i8 [[C]], 3
; CHECK-NEXT:    [[AND:%.*]] = xor i8 [[C_MASKED]], [[SH]]
; CHECK-NEXT:    ret i8 [[AND]]
;
  %c = mul i8 %b, 43 ; thwart complexity-based ordering
  %sh = lshr i8 %a, 6
  %xor = xor i8 %c, %sh
  %and = and i8 %xor, 3
  ret i8 %and
}

define <2 x i8> @and_or_hoist_mask_commute_vec_splat(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @and_or_hoist_mask_commute_vec_splat(
; CHECK-NEXT:    [[C:%.*]] = mul <2 x i8> %b, <i8 43, i8 43>
; CHECK-NEXT:    [[SH:%.*]] = lshr <2 x i8> %a, <i8 6, i8 6>
; CHECK-NEXT:    [[C_MASKED:%.*]] = and <2 x i8> [[C]], <i8 3, i8 3>
; CHECK-NEXT:    [[AND:%.*]] = or <2 x i8> [[C_MASKED]], [[SH]]
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %c = mul <2 x i8> %b, <i8 43, i8 43> ; thwart complexity-based ordering
  %sh = lshr <2 x i8> %a, <i8 6, i8 6>
  %or = or <2 x i8> %c, %sh
  %and = and <2 x i8> %or, <i8 3, i8 3>
  ret <2 x i8> %and
}

; Don't transform if the 'or' has multiple uses because that would increase instruction count.

define i8 @and_or_do_not_hoist_mask(i8 %a, i8 %b) {
; CHECK-LABEL: @and_or_do_not_hoist_mask(
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 %a, 6
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[SH]], %b
; CHECK-NEXT:    [[AND:%.*]] = and i8 [[OR]], 3
; CHECK-NEXT:    [[EXTRA_USE_OF_OR:%.*]] = mul i8 [[OR]], [[AND]]
; CHECK-NEXT:    ret i8 [[EXTRA_USE_OF_OR]]
;
  %sh = lshr i8 %a, 6
  %or = or i8 %sh, %b
  %and = and i8 %or, 3
  %extra_use_of_or = mul i8 %or, %and
  ret i8 %extra_use_of_or
}

