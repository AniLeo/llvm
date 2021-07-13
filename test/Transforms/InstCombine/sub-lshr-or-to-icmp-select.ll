; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine %s -S -o - | FileCheck %s

; Scalar Types

define i32 @neg_or_lshr_i32(i32 %x) {
; CHECK-LABEL: @neg_or_lshr_i32(
; CHECK-NEXT:    [[NEG:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[NEG]], [[X]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[OR]], 31
; CHECK-NEXT:    ret i32 [[SHR]]
;
  %neg = sub i32 0, %x
  %or = or i32 %neg, %x
  %shr = lshr i32 %or, 31
  ret i32 %shr
}

; Commute

define i32 @neg_or_lshr_i32_commute(i32 %x0) {
; CHECK-LABEL: @neg_or_lshr_i32_commute(
; CHECK-NEXT:    [[X:%.*]] = sdiv i32 42, [[X0:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = sub nsw i32 0, [[X]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X]], [[NEG]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[OR]], 31
; CHECK-NEXT:    ret i32 [[SHR]]
;
  %x = sdiv i32 42, %x0 ; thwart complexity-based canonicalization
  %neg = sub i32 0, %x
  %or = or i32 %x, %neg
  %shr = lshr i32 %or, 31
  ret i32 %shr
}

; Vector Types

define <4 x i32> @neg_or_lshr_i32_vec(<4 x i32> %x) {
; CHECK-LABEL: @neg_or_lshr_i32_vec(
; CHECK-NEXT:    [[NEG:%.*]] = sub <4 x i32> zeroinitializer, [[X:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i32> [[NEG]], [[X]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr <4 x i32> [[OR]], <i32 31, i32 31, i32 31, i32 31>
; CHECK-NEXT:    ret <4 x i32> [[SHR]]
;
  %neg = sub <4 x i32> zeroinitializer, %x
  %or = or <4 x i32> %neg, %x
  %shr = lshr <4 x i32> %or, <i32 31, i32 31, i32 31, i32 31>
  ret <4 x i32> %shr
}

define <4 x i32> @neg_or_lshr_i32_vec_commute(<4 x i32> %x0) {
; CHECK-LABEL: @neg_or_lshr_i32_vec_commute(
; CHECK-NEXT:    [[X:%.*]] = sdiv <4 x i32> <i32 42, i32 42, i32 42, i32 42>, [[X0:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = sub nsw <4 x i32> zeroinitializer, [[X]]
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i32> [[X]], [[NEG]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr <4 x i32> [[OR]], <i32 31, i32 31, i32 31, i32 31>
; CHECK-NEXT:    ret <4 x i32> [[SHR]]
;
  %x = sdiv <4 x i32> <i32 42, i32 42, i32 42, i32 42>, %x0 ; thwart complexity-based canonicalization
  %neg = sub <4 x i32> zeroinitializer, %x
  %or = or <4 x i32> %x, %neg
  %shr = lshr <4 x i32> %or, <i32 31, i32 31, i32 31, i32 31>
  ret <4 x i32> %shr
}

; Extra uses

define i32 @neg_extra_use_or_lshr_i32(i32 %x, i32* %p) {
; CHECK-LABEL: @neg_extra_use_or_lshr_i32(
; CHECK-NEXT:    [[NEG:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[NEG]], [[X]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[OR]], 31
; CHECK-NEXT:    store i32 [[NEG]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 [[SHR]]
;
  %neg = sub i32 0, %x
  %or = or i32 %neg, %x
  %shr = lshr i32 %or, 31
  store i32 %neg, i32* %p
  ret i32 %shr
}

; Negative Tests

define i32 @neg_or_extra_use_lshr_i32(i32 %x, i32* %p) {
; CHECK-LABEL: @neg_or_extra_use_lshr_i32(
; CHECK-NEXT:    [[NEG:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[NEG]], [[X]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[OR]], 31
; CHECK-NEXT:    store i32 [[OR]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 [[SHR]]
;
  %neg = sub i32 0, %x
  %or = or i32 %neg, %x
  %shr = lshr i32 %or, 31
  store i32 %or, i32* %p
  ret i32 %shr
}
