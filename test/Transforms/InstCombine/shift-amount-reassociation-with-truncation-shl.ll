; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; Given pattern:
;   (trunc (x << Q) to iDst) << K
; we should rewrite it as
;   (trunc (x << (Q+K)) to iDst)  iff (Q+K) u< iDst
; This is only valid for shl.
; THIS FOLD DOES *NOT* REQUIRE ANY 'nuw'/`nsw` FLAGS!

; Basic scalar test

define i16 @t0(i32 %x, i16 %y) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[X_TR:%.*]] = trunc i32 [[X:%.*]] to i16
; CHECK-NEXT:    [[T5:%.*]] = shl i16 [[X_TR]], 8
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = shl i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -24
  %t5 = shl i16 %t3, %t4
  ret i16 %t5
}

define <2 x i16> @t1_vec_splat(<2 x i32> %x, <2 x i16> %y) {
; CHECK-LABEL: @t1_vec_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i32> [[X:%.*]], <i32 8, i32 8>
; CHECK-NEXT:    [[T5:%.*]] = trunc <2 x i32> [[TMP1]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[T5]]
;
  %t0 = sub <2 x i16> <i16 32, i16 32>, %y
  %t1 = zext <2 x i16> %t0 to <2 x i32>
  %t2 = shl <2 x i32> %x, %t1
  %t3 = trunc <2 x i32> %t2 to <2 x i16>
  %t4 = add <2 x i16> %y, <i16 -24, i16 -24>
  %t5 = shl <2 x i16> %t3, %t4
  ret <2 x i16> %t5
}

define <2 x i16> @t2_vec_nonsplat(<2 x i32> %x, <2 x i16> %y) {
; CHECK-LABEL: @t2_vec_nonsplat(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i32> [[X:%.*]], <i32 8, i32 30>
; CHECK-NEXT:    [[T5:%.*]] = trunc <2 x i32> [[TMP1]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[T5]]
;
  %t0 = sub <2 x i16> <i16 32, i16 30>, %y
  %t1 = zext <2 x i16> %t0 to <2 x i32>
  %t2 = shl <2 x i32> %x, %t1
  %t3 = trunc <2 x i32> %t2 to <2 x i16>
  %t4 = add <2 x i16> %y, <i16 -24, i16 0>
  %t5 = shl <2 x i16> %t3, %t4
  ret <2 x i16> %t5
}

; Basic vector tests

define <3 x i16> @t3_vec_nonsplat_undef0(<3 x i32> %x, <3 x i16> %y) {
; CHECK-LABEL: @t3_vec_nonsplat_undef0(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <3 x i32> [[X:%.*]], <i32 8, i32 0, i32 8>
; CHECK-NEXT:    [[T5:%.*]] = trunc <3 x i32> [[TMP1]] to <3 x i16>
; CHECK-NEXT:    ret <3 x i16> [[T5]]
;
  %t0 = sub <3 x i16> <i16 32, i16 undef, i16 32>, %y
  %t1 = zext <3 x i16> %t0 to <3 x i32>
  %t2 = shl <3 x i32> %x, %t1
  %t3 = trunc <3 x i32> %t2 to <3 x i16>
  %t4 = add <3 x i16> %y, <i16 -24, i16 -24, i16 -24>
  %t5 = shl <3 x i16> %t3, %t4
  ret <3 x i16> %t5
}

define <3 x i16> @t4_vec_nonsplat_undef1(<3 x i32> %x, <3 x i16> %y) {
; CHECK-LABEL: @t4_vec_nonsplat_undef1(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <3 x i32> [[X:%.*]], <i32 8, i32 0, i32 8>
; CHECK-NEXT:    [[T5:%.*]] = trunc <3 x i32> [[TMP1]] to <3 x i16>
; CHECK-NEXT:    ret <3 x i16> [[T5]]
;
  %t0 = sub <3 x i16> <i16 32, i16 32, i16 32>, %y
  %t1 = zext <3 x i16> %t0 to <3 x i32>
  %t2 = shl <3 x i32> %x, %t1
  %t3 = trunc <3 x i32> %t2 to <3 x i16>
  %t4 = add <3 x i16> %y, <i16 -24, i16 undef, i16 -24>
  %t5 = shl <3 x i16> %t3, %t4
  ret <3 x i16> %t5
}

define <3 x i16> @t5_vec_nonsplat_undef1(<3 x i32> %x, <3 x i16> %y) {
; CHECK-LABEL: @t5_vec_nonsplat_undef1(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <3 x i32> [[X:%.*]], <i32 8, i32 0, i32 8>
; CHECK-NEXT:    [[T5:%.*]] = trunc <3 x i32> [[TMP1]] to <3 x i16>
; CHECK-NEXT:    ret <3 x i16> [[T5]]
;
  %t0 = sub <3 x i16> <i16 32, i16 undef, i16 32>, %y
  %t1 = zext <3 x i16> %t0 to <3 x i32>
  %t2 = shl <3 x i32> %x, %t1
  %t3 = trunc <3 x i32> %t2 to <3 x i16>
  %t4 = add <3 x i16> %y, <i16 -24, i16 undef, i16 -24>
  %t5 = shl <3 x i16> %t3, %t4
  ret <3 x i16> %t5
}

; One-use tests

declare void @use16(i16)
declare void @use32(i32)

define i16 @t6_extrause0(i32 %x, i16 %y) {
; CHECK-LABEL: @t6_extrause0(
; CHECK-NEXT:    [[T0:%.*]] = sub i16 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = zext i16 [[T0]] to i32
; CHECK-NEXT:    [[T2:%.*]] = shl i32 [[X:%.*]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[T2]] to i16
; CHECK-NEXT:    call void @use16(i16 [[T3]])
; CHECK-NEXT:    [[X_TR:%.*]] = trunc i32 [[X]] to i16
; CHECK-NEXT:    [[T5:%.*]] = shl i16 [[X_TR]], 8
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = shl i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -24
  call void @use16(i16 %t3)
  %t5 = shl i16 %t3, %t4
  ret i16 %t5
}

define i16 @t7_extrause1(i32 %x, i16 %y) {
; CHECK-LABEL: @t7_extrause1(
; CHECK-NEXT:    [[T4:%.*]] = add i16 [[Y:%.*]], -24
; CHECK-NEXT:    call void @use16(i16 [[T4]])
; CHECK-NEXT:    [[X_TR:%.*]] = trunc i32 [[X:%.*]] to i16
; CHECK-NEXT:    [[T5:%.*]] = shl i16 [[X_TR]], 8
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = shl i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -24
  call void @use16(i16 %t4)
  %t5 = shl i16 %t3, %t4
  ret i16 %t5
}

define i16 @t8_extrause2(i32 %x, i16 %y) {
; CHECK-LABEL: @t8_extrause2(
; CHECK-NEXT:    [[T0:%.*]] = sub i16 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = zext i16 [[T0]] to i32
; CHECK-NEXT:    [[T2:%.*]] = shl i32 [[X:%.*]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[T2]] to i16
; CHECK-NEXT:    [[T4:%.*]] = add i16 [[Y]], -24
; CHECK-NEXT:    call void @use16(i16 [[T3]])
; CHECK-NEXT:    call void @use16(i16 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl i16 [[T3]], [[T4]]
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = shl i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -24
  call void @use16(i16 %t3)
  call void @use16(i16 %t4)
  %t5 = shl i16 %t3, %t4
  ret i16 %t5
}

; No 'nuw'/'nsw' flags are to be propagated!
; But we can't test that, such IR does not reach that code.

; Negative tests

; Can't fold, total shift would be 32
define i16 @n11(i32 %x, i16 %y) {
; CHECK-LABEL: @n11(
; CHECK-NEXT:    [[T0:%.*]] = sub i16 30, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = zext i16 [[T0]] to i32
; CHECK-NEXT:    [[T2:%.*]] = shl i32 [[X:%.*]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[T2]] to i16
; CHECK-NEXT:    [[T4:%.*]] = add i16 [[Y]], -31
; CHECK-NEXT:    [[T5:%.*]] = shl i16 [[T3]], [[T4]]
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 30, %y
  %t1 = zext i16 %t0 to i32
  %t2 = shl i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -31
  %t5 = shl i16 %t3, %t4
  ret i16 %t5
}

; Bit width mismatch of shit amount

@Y32 = global i32 42
@Y16 = global i16 42
define i16 @t01(i32 %x) {
; CHECK-LABEL: @t01(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], ptrtoint (i32* @Y32 to i32)
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[T0]] to i16
; CHECK-NEXT:    [[T2:%.*]] = shl i16 [[T1]], ptrtoint (i16* @Y16 to i16)
; CHECK-NEXT:    ret i16 [[T2]]
;
  %t0 = shl i32 %x, ptrtoint (i32* @Y32 to i32)
  %t1 = trunc i32 %t0 to i16
  %t2 = shl i16 %t1, ptrtoint (i16* @Y16 to i16)
  ret i16 %t2
}
