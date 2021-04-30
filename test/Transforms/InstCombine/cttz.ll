; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -instcombine | FileCheck %s

declare i32 @llvm.cttz.i32(i32, i1)
declare <2 x i64> @llvm.cttz.v2i64(<2 x i64>, i1)
declare void @use(i32)

define i32 @cttz_zext_zero_undef(i16 %x) {
; CHECK-LABEL: @cttz_zext_zero_undef(
; CHECK-NEXT:    [[Z:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[Z]], i1 true), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %z = zext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %z, i1 true)
  ret i32 %tz
}

define i32 @cttz_zext_zero_def(i16 %x) {
; CHECK-LABEL: @cttz_zext_zero_def(
; CHECK-NEXT:    [[Z:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[Z]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %z = zext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %z, i1 false)
  ret i32 %tz
}

define i32 @cttz_zext_zero_undef_extra_use(i16 %x) {
; CHECK-LABEL: @cttz_zext_zero_undef_extra_use(
; CHECK-NEXT:    [[Z:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    call void @use(i32 [[Z]])
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[Z]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %z = zext i16 %x to i32
  call void @use(i32 %z)
  %tz = call i32 @llvm.cttz.i32(i32 %z, i1 true)
  ret i32 %tz
}

define <2 x i64> @cttz_zext_zero_undef_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_zext_zero_undef_vec(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TZ:%.*]] = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[Z]], i1 true)
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %z = zext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %z, i1 true)
  ret <2 x i64> %tz
}

define <2 x i64> @cttz_zext_zero_def_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_zext_zero_def_vec(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TZ:%.*]] = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[Z]], i1 false)
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %z = zext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %z, i1 false)
  ret <2 x i64> %tz
}

define i32 @cttz_sext_zero_undef(i16 %x) {
; CHECK-LABEL: @cttz_sext_zero_undef(
; CHECK-NEXT:    [[S:%.*]] = sext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[S]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %s = sext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %s, i1 true)
  ret i32 %tz
}

define i32 @cttz_sext_zero_def(i16 %x) {
; CHECK-LABEL: @cttz_sext_zero_def(
; CHECK-NEXT:    [[S:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[S]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %s = zext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %s, i1 false)
  ret i32 %tz
}

define i32 @cttz_zext_sero_undef_extra_use(i16 %x) {
; CHECK-LABEL: @cttz_zext_sero_undef_extra_use(
; CHECK-NEXT:    [[S:%.*]] = sext i16 [[X:%.*]] to i32
; CHECK-NEXT:    call void @use(i32 [[S]])
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[S]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %s = sext i16 %x to i32
  call void @use(i32 %s)
  %tz = call i32 @llvm.cttz.i32(i32 %s, i1 true)
  ret i32 %tz
}

define <2 x i64> @cttz_sext_zero_undef_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_sext_zero_undef_vec(
; CHECK-NEXT:    [[S:%.*]] = sext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TZ:%.*]] = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[S]], i1 true)
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %s = sext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %s, i1 true)
  ret <2 x i64> %tz
}

define <2 x i64> @cttz_sext_zero_def_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_sext_zero_def_vec(
; CHECK-NEXT:    [[S:%.*]] = sext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TZ:%.*]] = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[S]], i1 false)
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %s = sext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %s, i1 false)
  ret <2 x i64> %tz
}
