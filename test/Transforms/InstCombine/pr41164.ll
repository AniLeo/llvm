; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

@wyhash64_x = global i64 0, align 8

define i64 @_Z8wyhash64v() {
; CHECK-LABEL: @_Z8wyhash64v(
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, i64* @wyhash64_x, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[TMP1]], 6971258582664805397
; CHECK-NEXT:    store i64 [[TMP2]], i64* @wyhash64_x, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = zext i64 [[TMP2]] to i128
; CHECK-NEXT:    [[TMP4:%.*]] = mul nuw i128 [[TMP3]], 11795372955171141389
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i128 [[TMP4]], 64
; CHECK-NEXT:    [[DOTMASKED:%.*]] = and i128 [[TMP4]], 18446744073709551615
; CHECK-NEXT:    [[TMP6:%.*]] = xor i128 [[TMP5]], [[DOTMASKED]]
; CHECK-NEXT:    [[TMP7:%.*]] = mul nuw nsw i128 [[TMP6]], 1946526487930394057
; CHECK-NEXT:    [[TMP8:%.*]] = lshr i128 [[TMP7]], 64
; CHECK-NEXT:    [[TMP9:%.*]] = xor i128 [[TMP8]], [[TMP7]]
; CHECK-NEXT:    [[TMP10:%.*]] = trunc i128 [[TMP9]] to i64
; CHECK-NEXT:    ret i64 [[TMP10]]
;
  %1 = load i64, i64* @wyhash64_x, align 8
  %2 = add i64 %1, 6971258582664805397
  store i64 %2, i64* @wyhash64_x, align 8
  %3 = zext i64 %2 to i128
  %4 = mul i128 %3, 11795372955171141389
  %5 = lshr i128 %4, 64
  %6 = xor i128 %5, %4
  %7 = trunc i128 %6 to i64
  %8 = zext i64 %7 to i128
  %9 = mul i128 %8, 1946526487930394057
  %10 = lshr i128 %9, 64
  %11 = xor i128 %10, %9
  %12 = trunc i128 %11 to i64
  ret i64 %12
}
