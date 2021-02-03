; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; This test makes sure that these instructions are properly eliminated.
;
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @shl_C1_add_A_C2_i32(i16 %A) {
; CHECK-LABEL: @shl_C1_add_A_C2_i32(
; CHECK-NEXT:    [[B:%.*]] = zext i16 [[A:%.*]] to i32
; CHECK-NEXT:    [[D:%.*]] = shl i32 192, [[B]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %B = zext i16 %A to i32
  %C = add i32 %B, 5
  %D = shl i32 6, %C
  ret i32 %D
}

define i32 @ashr_C1_add_A_C2_i32(i32 %A) {
; CHECK-LABEL: @ashr_C1_add_A_C2_i32(
; CHECK-NEXT:    ret i32 0
;
  %B = and i32 %A, 65535
  %C = add i32 %B, 5
  %D = ashr i32 6, %C
  ret i32 %D
}

define i32 @lshr_C1_add_A_C2_i32(i32 %A) {
; CHECK-LABEL: @lshr_C1_add_A_C2_i32(
; CHECK-NEXT:    [[B:%.*]] = and i32 [[A:%.*]], 65535
; CHECK-NEXT:    [[D:%.*]] = shl i32 192, [[B]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %B = and i32 %A, 65535
  %C = add i32 %B, 5
  %D = shl i32 6, %C
  ret i32 %D
}

define <4 x i32> @shl_C1_add_A_C2_v4i32(<4 x i16> %A) {
; CHECK-LABEL: @shl_C1_add_A_C2_v4i32(
; CHECK-NEXT:    [[B:%.*]] = zext <4 x i16> [[A:%.*]] to <4 x i32>
; CHECK-NEXT:    [[D:%.*]] = shl <4 x i32> <i32 6, i32 4, i32 undef, i32 -458752>, [[B]]
; CHECK-NEXT:    ret <4 x i32> [[D]]
;
  %B = zext <4 x i16> %A to <4 x i32>
  %C = add <4 x i32> %B, <i32 0, i32 1, i32 50, i32 16>
  %D = shl <4 x i32> <i32 6, i32 2, i32 1, i32 -7>, %C
  ret <4 x i32> %D
}

define <4 x i32> @ashr_C1_add_A_C2_v4i32(<4 x i32> %A) {
; CHECK-LABEL: @ashr_C1_add_A_C2_v4i32(
; CHECK-NEXT:    [[B:%.*]] = and <4 x i32> [[A:%.*]], <i32 0, i32 15, i32 255, i32 65535>
; CHECK-NEXT:    [[D:%.*]] = ashr <4 x i32> <i32 6, i32 1, i32 undef, i32 -1>, [[B]]
; CHECK-NEXT:    ret <4 x i32> [[D]]
;
  %B = and <4 x i32> %A, <i32 0, i32 15, i32 255, i32 65535>
  %C = add <4 x i32> %B, <i32 0, i32 1, i32 50, i32 16>
  %D = ashr <4 x i32> <i32 6, i32 2, i32 1, i32 -7>, %C
  ret <4 x i32> %D
}

define <4 x i32> @lshr_C1_add_A_C2_v4i32(<4 x i32> %A) {
; CHECK-LABEL: @lshr_C1_add_A_C2_v4i32(
; CHECK-NEXT:    [[B:%.*]] = and <4 x i32> [[A:%.*]], <i32 0, i32 15, i32 255, i32 65535>
; CHECK-NEXT:    [[D:%.*]] = lshr <4 x i32> <i32 6, i32 1, i32 undef, i32 65535>, [[B]]
; CHECK-NEXT:    ret <4 x i32> [[D]]
;
  %B = and <4 x i32> %A, <i32 0, i32 15, i32 255, i32 65535>
  %C = add <4 x i32> %B, <i32 0, i32 1, i32 50, i32 16>
  %D = lshr <4 x i32> <i32 6, i32 2, i32 1, i32 -7>, %C
  ret <4 x i32> %D
}

define <4 x i32> @shl_C1_add_A_C2_v4i32_splat(i16 %I) {
; CHECK-LABEL: @shl_C1_add_A_C2_v4i32_splat(
; CHECK-NEXT:    [[A:%.*]] = zext i16 [[I:%.*]] to i32
; CHECK-NEXT:    [[B:%.*]] = insertelement <4 x i32> poison, i32 [[A]], i32 0
; CHECK-NEXT:    [[C:%.*]] = shufflevector <4 x i32> [[B]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[E:%.*]] = shl <4 x i32> <i32 6, i32 4, i32 undef, i32 -458752>, [[C]]
; CHECK-NEXT:    ret <4 x i32> [[E]]
;
  %A = zext i16 %I to i32
  %B = insertelement <4 x i32> poison, i32 %A, i32 0
  %C = shufflevector <4 x i32> %B, <4 x i32> poison, <4 x i32> zeroinitializer
  %D = add <4 x i32> %C, <i32 0, i32 1, i32 50, i32 16>
  %E = shl <4 x i32> <i32 6, i32 2, i32 1, i32 -7>, %D
  ret <4 x i32> %E
}

define <4 x i32> @ashr_C1_add_A_C2_v4i32_splat(i16 %I) {
; CHECK-LABEL: @ashr_C1_add_A_C2_v4i32_splat(
; CHECK-NEXT:    [[A:%.*]] = zext i16 [[I:%.*]] to i32
; CHECK-NEXT:    [[B:%.*]] = insertelement <4 x i32> poison, i32 [[A]], i32 0
; CHECK-NEXT:    [[C:%.*]] = shufflevector <4 x i32> [[B]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[E:%.*]] = ashr <4 x i32> <i32 6, i32 1, i32 undef, i32 -1>, [[C]]
; CHECK-NEXT:    ret <4 x i32> [[E]]
;
  %A = zext i16 %I to i32
  %B = insertelement <4 x i32> poison, i32 %A, i32 0
  %C = shufflevector <4 x i32> %B, <4 x i32> poison, <4 x i32> zeroinitializer
  %D = add <4 x i32> %C, <i32 0, i32 1, i32 50, i32 16>
  %E = ashr <4 x i32> <i32 6, i32 2, i32 1, i32 -7>, %D
  ret <4 x i32> %E
}

define <4 x i32> @lshr_C1_add_A_C2_v4i32_splat(i16 %I) {
; CHECK-LABEL: @lshr_C1_add_A_C2_v4i32_splat(
; CHECK-NEXT:    [[A:%.*]] = zext i16 [[I:%.*]] to i32
; CHECK-NEXT:    [[B:%.*]] = insertelement <4 x i32> poison, i32 [[A]], i32 0
; CHECK-NEXT:    [[C:%.*]] = shufflevector <4 x i32> [[B]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[E:%.*]] = lshr <4 x i32> <i32 6, i32 1, i32 undef, i32 65535>, [[C]]
; CHECK-NEXT:    ret <4 x i32> [[E]]
;
  %A = zext i16 %I to i32
  %B = insertelement <4 x i32> poison, i32 %A, i32 0
  %C = shufflevector <4 x i32> %B, <4 x i32> poison, <4 x i32> zeroinitializer
  %D = add <4 x i32> %C, <i32 0, i32 1, i32 50, i32 16>
  %E = lshr <4 x i32> <i32 6, i32 2, i32 1, i32 -7>, %D
  ret <4 x i32> %E
}
