; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mtriple=aarch64 < %s | FileCheck %s

define void @test(ptr %p) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[INC:%.*]] = getelementptr inbounds i16, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, ptr [[INC]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i16, ptr [[P]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i16> zeroinitializer, i16 [[TMP0]], i32 5
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <8 x i16> [[TMP2]], i16 [[TMP1]], i32 7
; CHECK-NEXT:    ret void
;
entry:
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %0 = load i16, ptr %inc, align 4
  %1 = load i16, ptr %p, align 2
  %2 = insertelement <8 x i16> zeroinitializer, i16 %0, i32 5
  %3 = insertelement <8 x i16> %2, i16 %1, i32 7
  ret void
}
