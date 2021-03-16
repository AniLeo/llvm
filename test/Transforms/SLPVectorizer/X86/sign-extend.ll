; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer < %s -S -o - -mtriple=x86_64-apple-macosx10.10.0 -mcpu=core2 | FileCheck %s

define <4 x i32> @sign_extend_v_v(<4 x i16> %lhs) {
; CHECK-LABEL: @sign_extend_v_v(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = sext <4 x i16> [[LHS:%.*]] to <4 x i32>
; CHECK-NEXT:    ret <4 x i32> [[TMP0]]
;
entry:
  %vecext = extractelement <4 x i16> %lhs, i32 0
  %conv = sext i16 %vecext to i32
  %vecinit = insertelement <4 x i32> undef, i32 %conv, i32 0
  %vecext1 = extractelement <4 x i16> %lhs, i32 1
  %conv2 = sext i16 %vecext1 to i32
  %vecinit3 = insertelement <4 x i32> %vecinit, i32 %conv2, i32 1
  %vecext4 = extractelement <4 x i16> %lhs, i32 2
  %conv5 = sext i16 %vecext4 to i32
  %vecinit6 = insertelement <4 x i32> %vecinit3, i32 %conv5, i32 2
  %vecext7 = extractelement <4 x i16> %lhs, i32 3
  %conv8 = sext i16 %vecext7 to i32
  %vecinit9 = insertelement <4 x i32> %vecinit6, i32 %conv8, i32 3
  ret <4 x i32> %vecinit9
}

define <4 x i16> @truncate_v_v(<4 x i32> %lhs) {
; CHECK-LABEL: @truncate_v_v(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc <4 x i32> [[LHS:%.*]] to <4 x i16>
; CHECK-NEXT:    ret <4 x i16> [[TMP0]]
;
entry:
  %vecext = extractelement <4 x i32> %lhs, i32 0
  %conv = trunc i32 %vecext to i16
  %vecinit = insertelement <4 x i16> undef, i16 %conv, i32 0
  %vecext1 = extractelement <4 x i32> %lhs, i32 1
  %conv2 = trunc i32 %vecext1 to i16
  %vecinit3 = insertelement <4 x i16> %vecinit, i16 %conv2, i32 1
  %vecext4 = extractelement <4 x i32> %lhs, i32 2
  %conv5 = trunc i32 %vecext4 to i16
  %vecinit6 = insertelement <4 x i16> %vecinit3, i16 %conv5, i32 2
  %vecext7 = extractelement <4 x i32> %lhs, i32 3
  %conv8 = trunc i32 %vecext7 to i16
  %vecinit9 = insertelement <4 x i16> %vecinit6, i16 %conv8, i32 3
  ret <4 x i16> %vecinit9
}
