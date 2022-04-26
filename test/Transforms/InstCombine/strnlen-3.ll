; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Verify that strnlen calls with conditional expressions involving constant
; string arguments with nonconstant offsets and constant bounds or constant
; offsets and nonconstant bounds are folded correctly.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare i64 @strnlen(i8*, i64)

@sx = external global [0 x i8]
@a3 = constant [3 x i8] c"123"
@s3 = constant [4 x i8] c"123\00"
@s5 = constant [6 x i8] c"12345\00"
@s5_3 = constant [10 x i8] c"12345\00abc\00"


; Fold strnlen(sx + i, 0) to 0.

define i64 @fold_strnlen_sx_pi_0(i64 %i) {
; CHECK-LABEL: @fold_strnlen_sx_pi_0(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr [0 x i8], [0 x i8]* @sx, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* [[PTR]], i64 0)
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @sx, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 0)
  ret i64 %len
}


; Do not fold strnlen(sx + i, n).

define i64 @call_strnlen_sx_pi_n(i64 %i, i64 %n) {
; CHECK-LABEL: @call_strnlen_sx_pi_n(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [0 x i8], [0 x i8]* @sx, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* nonnull [[PTR]], i64 [[N:%.*]])
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [0 x i8], [0 x i8]* @sx, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 %n)
  ret i64 %len
}


; Fold strnlen(a3 + i, 2) to min(3 - i, 2).

define i64 @call_strnlen_a3_pi_2(i64 %i) {
; CHECK-LABEL: @call_strnlen_a3_pi_2(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [3 x i8], [3 x i8]* @a3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* noundef nonnull [[PTR]], i64 2)
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [3 x i8], [3 x i8]* @a3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 2)
  ret i64 %len
}


; Fold strnlen(a3 + i, 3) to min(3 - i, 3).

define i64 @call_strnlen_a3_pi_3(i64 %i) {
; CHECK-LABEL: @call_strnlen_a3_pi_3(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [3 x i8], [3 x i8]* @a3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* noundef nonnull [[PTR]], i64 3)
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [3 x i8], [3 x i8]* @a3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 3)
  ret i64 %len
}


; Fold strnlen(s3 + i, 0) to 0.

define i64 @fold_strnlen_s3_pi_0(i64 %i) {
; CHECK-LABEL: @fold_strnlen_s3_pi_0(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* nonnull [[PTR]], i64 0)
; CHECK-NEXT:    ret i64 [[LEN]]
;
  %ptr = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 0)
  ret i64 %len
}


; Fold strnlen(s5 + i, 0) to 0.

define i64 @call_strnlen_s5_pi_0(i64 zeroext %i) {
; CHECK-LABEL: @call_strnlen_s5_pi_0(
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @s5, i64 0, i64 0), i64 0)
; CHECK-NEXT:    ret i64 [[LEN]]
;
  %ptr = getelementptr [6 x i8], [6 x i8]* @s5, i32 0, i32 0
  %len = call i64 @strnlen(i8* %ptr, i64 0)
  ret i64 %len
}


; Fold strnlen(s5_3 + i, 0) to 0.

define i64 @fold_strnlen_s5_3_pi_0(i64 zeroext %i) {
; CHECK-LABEL: @fold_strnlen_s5_3_pi_0(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr [10 x i8], [10 x i8]* @s5_3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* [[PTR]], i64 0)
; CHECK-NEXT:    ret i64 [[LEN]]
;
  %ptr = getelementptr [10 x i8], [10 x i8]* @s5_3, i32 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 0)
  ret i64 %len
}


; Do not fold strnlen(s5_3 + i, n).

define i64 @call_strnlen_s5_3_pi_n(i64 zeroext %i, i64 %n) {
; CHECK-LABEL: @call_strnlen_s5_3_pi_n(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [10 x i8], [10 x i8]* @s5_3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* nonnull [[PTR]], i64 [[N:%.*]])
; CHECK-NEXT:    ret i64 [[LEN]]
;
  %ptr = getelementptr inbounds [10 x i8], [10 x i8]* @s5_3, i32 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 %n)
  ret i64 %len
}


; Fold strnlen(a3, n) to min(sizeof(a3), n)

define i64 @fold_strnlen_a3_n(i64 %n) {
; CHECK-LABEL: @fold_strnlen_a3_n(
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @a3, i64 0, i64 0), i64 [[N:%.*]])
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr [3 x i8], [3 x i8]* @a3, i64 0, i64 0
  %len = call i64 @strnlen(i8* %ptr, i64 %n)
  ret i64 %len
}


; Fold strnlen(s3, n) to min(strlen(s3), n)

define i64 @fold_strnlen_s3_n(i64 %n) {
; CHECK-LABEL: @fold_strnlen_s3_n(
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @s3, i64 0, i64 0), i64 [[N:%.*]])
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr [4 x i8], [4 x i8]* @s3, i64 0, i64 0
  %len = call i64 @strnlen(i8* %ptr, i64 %n)
  ret i64 %len
}


; Fold strnlen(a3 + i, 2) to min(sizeof(a3) - i, 2)

define i64 @fold_strnlen_a3_pi_2(i64 %i) {
; CHECK-LABEL: @fold_strnlen_a3_pi_2(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [3 x i8], [3 x i8]* @a3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* noundef nonnull [[PTR]], i64 2)
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [3 x i8], [3 x i8]* @a3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 2)
  ret i64 %len
}


; Fold strnlen(s3 + i, 2) to min(strlen(s3) - i, 2)

define i64 @fold_strnlen_s3_pi_2(i64 %i) {
; CHECK-LABEL: @fold_strnlen_s3_pi_2(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* noundef nonnull [[PTR]], i64 2)
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 2)
  ret i64 %len
}


; Fold strnlen(s3 + i, 3) to min(strlen(s3) - i, 3)

define i64 @fold_strnlen_s3_pi_3(i64 %i) {
; CHECK-LABEL: @fold_strnlen_s3_pi_3(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* noundef nonnull [[PTR]], i64 3)
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 3)
  ret i64 %len
}


; Fold strnlen(s3 + i, n) to min(strlen(s3) - i, n)

define i64 @fold_strnlen_s3_pi_n(i64 %i, i64 %n) {
; CHECK-LABEL: @fold_strnlen_s3_pi_n(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* nonnull [[PTR]], i64 [[N:%.*]])
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [4 x i8], [4 x i8]* @s3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 %n)
  ret i64 %len
}


; Do not fold strnlen(s5_3 + i, 2).  The result is in [0, 2] but there's
; no simple way to derive its lower bound from the offset.

define i64 @call_strnlen_s5_3_pi_2(i64 %i) {
; CHECK-LABEL: @call_strnlen_s5_3_pi_2(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [10 x i8], [10 x i8]* @s5_3, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* noundef nonnull [[PTR]], i64 2)
; CHECK-NEXT:    ret i64 [[LEN]]
;

  %ptr = getelementptr inbounds [10 x i8], [10 x i8]* @s5_3, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 2)
  ret i64 %len
}
