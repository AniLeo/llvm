; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -constprop -S | FileCheck %s
; PR2165

define <1 x i64> @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret <1 x i64> <i64 63>
;
  %A = bitcast i64 63 to <1 x i64>
  ret <1 x i64> %A
}

; Ensure that a FP source operand isn't propagated to an icmp.

@a = external global i16, align 1
@b = external global i16, align 1

define i1 @bad_icmp_constexpr_bitcast() {
; CHECK-LABEL: @bad_icmp_constexpr_bitcast(
; CHECK-NEXT:    ret i1 icmp eq (i32 ptrtoint (i16* @a to i32), i32 bitcast (float fadd (float bitcast (i32 ptrtoint (i16* @b to i32) to float), float 2.000000e+00) to i32))
;
  %cmp = icmp eq i32 ptrtoint (i16* @a to i32), bitcast (float fadd (float bitcast (i32 ptrtoint (i16* @b to i32) to float), float 2.0) to i32)
  ret i1 %cmp
}

; Ensure that an integer source operand isn't propagated to a fcmp.

@c = external global i16, align 1
@d = external global i16, align 1

define i1 @bad_fcmp_constexpr_bitcast() {
; CHECK-LABEL: @bad_fcmp_constexpr_bitcast(
; CHECK-NEXT:    ret i1 fcmp oeq (float bitcast (i32 ptrtoint (i16* @c to i32) to float), float bitcast (i32 add (i32 ptrtoint (i16* @d to i32), i32 2) to float))
;
  %cmp = fcmp oeq float bitcast (i32 ptrtoint (i16* @c to i32) to float), bitcast (i32 add (i32 ptrtoint (i16* @d to i32), i32 2) to float)
  ret i1 %cmp
}

; Ensure that an "ordered and equal" fcmp of a ConstantExpr to itself is not folded, since the ConstantExpr may be a NaN.

define i1 @fcmp_constexpr_oeq(float %conv) {
; CHECK-LABEL: @fcmp_constexpr_oeq(
; CHECK-NEXT:    ret i1 fcmp oeq (float bitcast (i32 ptrtoint (i16* @a to i32) to float), float bitcast (i32 ptrtoint (i16* @a to i32) to float))
;
  %cmp = fcmp oeq float bitcast (i32 ptrtoint (i16* @a to i32) to float), bitcast (i32 ptrtoint (i16* @a to i32) to float)
  ret i1 %cmp
}

; Ensure that an "unordered or not equal" fcmp of a ConstantExpr to itself is not folded, since the ConstantExpr may be a NaN.

define i1 @fcmp_constexpr_une(float %conv) {
; CHECK-LABEL: @fcmp_constexpr_une(
; CHECK-NEXT:    ret i1 fcmp une (float bitcast (i32 ptrtoint (i16* @a to i32) to float), float bitcast (i32 ptrtoint (i16* @a to i32) to float))
;
  %cmp = fcmp une float bitcast (i32 ptrtoint (i16* @a to i32) to float), bitcast (i32 ptrtoint (i16* @a to i32) to float)
  ret i1 %cmp
}

define i1 @fcmp_constexpr_ueq(float %conv) {
; CHECK-LABEL: @fcmp_constexpr_ueq(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ueq float bitcast (i32 ptrtoint (i16* @a to i32) to float), bitcast (i32 ptrtoint (i16* @a to i32) to float)
  ret i1 %cmp
}

define i1 @fcmp_constexpr_one(float %conv) {
; CHECK-LABEL: @fcmp_constexpr_one(
; CHECK-NEXT:    ret i1 false
;
  %cmp = fcmp one float bitcast (i32 ptrtoint (i16* @a to i32) to float), bitcast (i32 ptrtoint (i16* @a to i32) to float)
  ret i1 %cmp
}
