; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i64 @match_unsigned(i64 %x) {
; CHECK-LABEL: @match_unsigned(
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[X:%.*]], 19136
; CHECK-NEXT:    ret i64 [[UREM]]
;
  %t = urem i64 %x, 299
  %t1 = udiv i64 %x, 299
  %t2 = urem i64 %t1, 64
  %t3 = mul i64 %t2, 299
  %t4 = add i64 %t, %t3
  ret i64 %t4
}

define <2 x i64> @match_unsigned_vector(<2 x i64> %x) {
; CHECK-LABEL: @match_unsigned_vector(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[UREM:%.*]] = urem <2 x i64> [[X:%.*]], <i64 19136, i64 19136>
; CHECK-NEXT:    ret <2 x i64> [[UREM]]
;
bb:
  %tmp = urem <2 x i64> %x, <i64 299, i64 299>
  %tmp1 = udiv <2 x i64> %x, <i64 299, i64 299>
  %tmp2 = urem <2 x i64> %tmp1, <i64 64, i64 64>
  %tmp3 = mul <2 x i64> %tmp2, <i64 299, i64 299>
  %tmp4 = add <2 x i64> %tmp, %tmp3
  ret <2 x i64> %tmp4
}
define i64 @match_andAsRem_lshrAsDiv_shlAsMul(i64 %x) {
; CHECK-LABEL: @match_andAsRem_lshrAsDiv_shlAsMul(
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[X:%.*]], 576
; CHECK-NEXT:    ret i64 [[UREM]]
;
  %t = and i64 %x, 63
  %t1 = lshr i64 %x, 6
  %t2 = urem i64 %t1, 9
  %t3 = shl i64 %t2, 6
  %t4 = add i64 %t, %t3
  ret i64 %t4
}

define i64 @match_signed(i64 %x) {
; CHECK-LABEL: @match_signed(
; CHECK-NEXT:    [[SREM1:%.*]] = srem i64 [[X:%.*]], 172224
; CHECK-NEXT:    ret i64 [[SREM1]]
;
  %t = srem i64 %x, 299
  %t1 = sdiv i64 %x, 299
  %t2 = srem i64 %t1, 64
  %t3 = sdiv i64 %x, 19136
  %t4 = srem i64 %t3, 9
  %t5 = mul i64 %t2, 299
  %t6 = add i64 %t, %t5
  %t7 = mul i64 %t4, 19136
  %t8 = add i64 %t6, %t7
  ret i64 %t8
}

define <2 x i64> @match_signed_vector(<2 x i64> %x) {
; CHECK-LABEL: @match_signed_vector(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[SREM1:%.*]] = srem <2 x i64> [[X:%.*]], <i64 172224, i64 172224>
; CHECK-NEXT:    ret <2 x i64> [[SREM1]]
;
bb:
  %tmp = srem <2 x i64> %x, <i64 299, i64 299>
  %tmp1 = sdiv <2 x i64> %x, <i64 299, i64 299>
  %tmp2 = srem <2 x i64> %tmp1, <i64 64, i64 64>
  %tmp3 = sdiv <2 x i64> %x, <i64 19136, i64 19136>
  %tmp4 = srem <2 x i64> %tmp3, <i64 9, i64 9>
  %tmp5 = mul <2 x i64> %tmp2, <i64 299, i64 299>
  %tmp6 = add <2 x i64> %tmp, %tmp5
  %tmp7 = mul <2 x i64> %tmp4, <i64 19136, i64 19136>
  %tmp8 = add <2 x i64> %tmp6, %tmp7
  ret <2 x i64> %tmp8
}

define i64 @not_match_inconsistent_signs(i64 %x) {
; CHECK-LABEL: @not_match_inconsistent_signs(
; CHECK-NEXT:    [[T:%.*]] = urem i64 [[X:%.*]], 299
; CHECK-NEXT:    [[T1:%.*]] = sdiv i64 [[X]], 299
; CHECK-NEXT:    [[T2:%.*]] = and i64 [[T1]], 63
; CHECK-NEXT:    [[T3:%.*]] = mul nuw nsw i64 [[T2]], 299
; CHECK-NEXT:    [[T4:%.*]] = add nuw nsw i64 [[T]], [[T3]]
; CHECK-NEXT:    ret i64 [[T4]]
;
  %t = urem i64 %x, 299
  %t1 = sdiv i64 %x, 299
  %t2 = urem i64 %t1, 64
  %t3 = mul i64 %t2, 299
  %t4 = add i64 %t, %t3
  ret i64 %t4
}

define i64 @not_match_inconsistent_values(i64 %x) {
; CHECK-LABEL: @not_match_inconsistent_values(
; CHECK-NEXT:    [[T:%.*]] = urem i64 [[X:%.*]], 299
; CHECK-NEXT:    [[T1:%.*]] = udiv i64 [[X]], 29
; CHECK-NEXT:    [[T2:%.*]] = and i64 [[T1]], 63
; CHECK-NEXT:    [[T3:%.*]] = mul nuw nsw i64 [[T2]], 299
; CHECK-NEXT:    [[T4:%.*]] = add nuw nsw i64 [[T]], [[T3]]
; CHECK-NEXT:    ret i64 [[T4]]
;
  %t = urem i64 %x, 299
  %t1 = udiv i64 %x, 29
  %t2 = urem i64 %t1, 64
  %t3 = mul i64 %t2, 299
  %t4 = add i64 %t, %t3
  ret i64 %t4
}

define i32 @not_match_overflow(i32 %x) {
; CHECK-LABEL: @not_match_overflow(
; CHECK-NEXT:    [[X_FR:%.*]] = freeze i32 [[X:%.*]]
; CHECK-NEXT:    [[T:%.*]] = urem i32 [[X_FR]], 299
; CHECK-NEXT:    [[TMP1:%.*]] = urem i32 [[X_FR]], 299
; CHECK-NEXT:    [[T3:%.*]] = sub nuw i32 [[X_FR]], [[TMP1]]
; CHECK-NEXT:    [[T4:%.*]] = add i32 [[T]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t = urem i32 %x, 299
  %t1 = udiv i32 %x, 299
  %t2 = urem i32 %t1, 147483647
  %t3 = mul i32 %t2, 299
  %t4 = add i32 %t, %t3
  ret i32 %t4
}
