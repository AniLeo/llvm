; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; Given pattern:
;   (trunc (iSrc x l>> Q) to iDst) l>> K
; we should rewrite it as
;   (trunc (iSrc x l>> (Q+K)) to iDst)
; iff (Q+K) is bitwidth(iSrc)-1
; THIS FOLD DOES *NOT* REQUIRE ANY 'nuw'/`nsw` FLAGS!

; Basic scalar test

define i16 @t0(i32 %x, i16 %y) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[T5:%.*]] = trunc i32 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = lshr i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -1
  %t5 = lshr i16 %t3, %t4
  ret i16 %t5
}

; Basic vector tests

define <2 x i16> @t1_vec_splat(<2 x i32> %x, <2 x i16> %y) {
; CHECK-LABEL: @t1_vec_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 31, i32 31>
; CHECK-NEXT:    [[T5:%.*]] = trunc <2 x i32> [[TMP1]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[T5]]
;
  %t0 = sub <2 x i16> <i16 32, i16 32>, %y
  %t1 = zext <2 x i16> %t0 to <2 x i32>
  %t2 = lshr <2 x i32> %x, %t1
  %t3 = trunc <2 x i32> %t2 to <2 x i16>
  %t4 = add <2 x i16> %y, <i16 -1, i16 -1>
  %t5 = lshr <2 x i16> %t3, %t4
  ret <2 x i16> %t5
}

define <3 x i16> @t3_vec_nonsplat_undef0(<3 x i32> %x, <3 x i16> %y) {
; CHECK-LABEL: @t3_vec_nonsplat_undef0(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <3 x i32> [[X:%.*]], <i32 31, i32 0, i32 31>
; CHECK-NEXT:    [[T5:%.*]] = trunc <3 x i32> [[TMP1]] to <3 x i16>
; CHECK-NEXT:    ret <3 x i16> [[T5]]
;
  %t0 = sub <3 x i16> <i16 32, i16 undef, i16 32>, %y
  %t1 = zext <3 x i16> %t0 to <3 x i32>
  %t2 = lshr <3 x i32> %x, %t1
  %t3 = trunc <3 x i32> %t2 to <3 x i16>
  %t4 = add <3 x i16> %y, <i16 -1, i16 -1, i16 -1>
  %t5 = lshr <3 x i16> %t3, %t4
  ret <3 x i16> %t5
}

define <3 x i16> @t4_vec_nonsplat_undef1(<3 x i32> %x, <3 x i16> %y) {
; CHECK-LABEL: @t4_vec_nonsplat_undef1(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <3 x i32> [[X:%.*]], <i32 31, i32 0, i32 31>
; CHECK-NEXT:    [[T5:%.*]] = trunc <3 x i32> [[TMP1]] to <3 x i16>
; CHECK-NEXT:    ret <3 x i16> [[T5]]
;
  %t0 = sub <3 x i16> <i16 32, i16 32, i16 32>, %y
  %t1 = zext <3 x i16> %t0 to <3 x i32>
  %t2 = lshr <3 x i32> %x, %t1
  %t3 = trunc <3 x i32> %t2 to <3 x i16>
  %t4 = add <3 x i16> %y, <i16 -1, i16 undef, i16 -1>
  %t5 = lshr <3 x i16> %t3, %t4
  ret <3 x i16> %t5
}

define <3 x i16> @t5_vec_nonsplat_undef1(<3 x i32> %x, <3 x i16> %y) {
; CHECK-LABEL: @t5_vec_nonsplat_undef1(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <3 x i32> [[X:%.*]], <i32 31, i32 0, i32 31>
; CHECK-NEXT:    [[T5:%.*]] = trunc <3 x i32> [[TMP1]] to <3 x i16>
; CHECK-NEXT:    ret <3 x i16> [[T5]]
;
  %t0 = sub <3 x i16> <i16 32, i16 undef, i16 32>, %y
  %t1 = zext <3 x i16> %t0 to <3 x i32>
  %t2 = lshr <3 x i32> %x, %t1
  %t3 = trunc <3 x i32> %t2 to <3 x i16>
  %t4 = add <3 x i16> %y, <i16 -1, i16 undef, i16 -1>
  %t5 = lshr <3 x i16> %t3, %t4
  ret <3 x i16> %t5
}

; One-use tests

declare void @use16(i16)
declare void @use32(i32)

define i16 @t6_extrause0(i32 %x, i16 %y) {
; CHECK-LABEL: @t6_extrause0(
; CHECK-NEXT:    [[T0:%.*]] = sub i16 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = zext i16 [[T0]] to i32
; CHECK-NEXT:    [[T2:%.*]] = lshr i32 [[X:%.*]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[T2]] to i16
; CHECK-NEXT:    call void @use16(i16 [[T3]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X]], 31
; CHECK-NEXT:    [[T5:%.*]] = trunc i32 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = lshr i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -1
  call void @use16(i16 %t3)
  %t5 = lshr i16 %t3, %t4
  ret i16 %t5
}

define i16 @t7_extrause1(i32 %x, i16 %y) {
; CHECK-LABEL: @t7_extrause1(
; CHECK-NEXT:    [[T4:%.*]] = add i16 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use16(i16 [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[T5:%.*]] = trunc i32 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = lshr i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -1
  call void @use16(i16 %t4)
  %t5 = lshr i16 %t3, %t4
  ret i16 %t5
}

define i16 @t8_extrause2(i32 %x, i16 %y) {
; CHECK-LABEL: @t8_extrause2(
; CHECK-NEXT:    [[T0:%.*]] = sub i16 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = zext i16 [[T0]] to i32
; CHECK-NEXT:    [[T2:%.*]] = lshr i32 [[X:%.*]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[T2]] to i16
; CHECK-NEXT:    [[T4:%.*]] = add i16 [[Y]], -1
; CHECK-NEXT:    call void @use16(i16 [[T3]])
; CHECK-NEXT:    call void @use16(i16 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = lshr i16 [[T3]], [[T4]]
; CHECK-NEXT:    ret i16 [[T5]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = lshr i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -1
  call void @use16(i16 %t3)
  call void @use16(i16 %t4)
  %t5 = lshr i16 %t3, %t4
  ret i16 %t5
}

; No 'nuw'/'nsw' flags are to be propagated!
; But we can't test that, such IR does not reach that code.

; Negative tests

; Can only fold if we are extracting the sign bit.
define i16 @t9_lshr(i32 %x, i16 %y) {
; CHECK-LABEL: @t9_lshr(
; CHECK-NEXT:    [[T0:%.*]] = sub i16 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = zext i16 [[T0]] to i32
; CHECK-NEXT:    [[T2:%.*]] = lshr i32 [[X:%.*]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[T2]] to i16
; CHECK-NEXT:    ret i16 [[T3]]
;
  %t0 = sub i16 32, %y
  %t1 = zext i16 %t0 to i32
  %t2 = lshr i32 %x, %t1
  %t3 = trunc i32 %t2 to i16
  %t4 = add i16 %y, -2
  %t5 = lshr i16 %t3, %t4
  ret i16 %t3
}
