; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -slp-vectorize-hor -slp-vectorize-hor-store -S < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=bdver2 | FileCheck %s

define void @i64_simplified(i64* noalias %st, i64* noalias %ld) {
; CHECK-LABEL: @i64_simplified(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i64* [[LD:%.*]] to <2 x i64>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i64>, <2 x i64>* [[TMP1]], align 8
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i64> [[TMP2]], <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i64* [[ST:%.*]] to <4 x i64>*
; CHECK-NEXT:    store <4 x i64> [[SHUFFLE]], <4 x i64>* [[TMP3]], align 8
; CHECK-NEXT:    ret void
;
  %arrayidx1 = getelementptr inbounds i64, i64* %ld, i64 1

  %t0 = load i64, i64* %ld, align 8
  %t1 = load i64, i64* %arrayidx1, align 8

  %arrayidx3 = getelementptr inbounds i64, i64* %st, i64 1
  %arrayidx4 = getelementptr inbounds i64, i64* %st, i64 2
  %arrayidx5 = getelementptr inbounds i64, i64* %st, i64 3

  store i64 %t0, i64* %st, align 8
  store i64 %t1, i64* %arrayidx3, align 8
  store i64 %t0, i64* %arrayidx4, align 8
  store i64 %t1, i64* %arrayidx5, align 8
  ret void
}

define void @i64_simplifiedi_reversed(i64* noalias %st, i64* noalias %ld) {
; CHECK-LABEL: @i64_simplifiedi_reversed(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i64* [[LD:%.*]] to <2 x i64>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i64>, <2 x i64>* [[TMP1]], align 8
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i64> [[TMP2]], <2 x i64> poison, <4 x i32> <i32 1, i32 0, i32 1, i32 0>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i64* [[ST:%.*]] to <4 x i64>*
; CHECK-NEXT:    store <4 x i64> [[SHUFFLE]], <4 x i64>* [[TMP3]], align 8
; CHECK-NEXT:    ret void
;
  %arrayidx1 = getelementptr inbounds i64, i64* %ld, i64 1

  %t0 = load i64, i64* %ld, align 8
  %t1 = load i64, i64* %arrayidx1, align 8

  %arrayidx3 = getelementptr inbounds i64, i64* %st, i64 1
  %arrayidx4 = getelementptr inbounds i64, i64* %st, i64 2
  %arrayidx5 = getelementptr inbounds i64, i64* %st, i64 3

  store i64 %t1, i64* %st, align 8
  store i64 %t0, i64* %arrayidx3, align 8
  store i64 %t1, i64* %arrayidx4, align 8
  store i64 %t0, i64* %arrayidx5, align 8
  ret void
}

define void @i64_simplifiedi_extract(i64* noalias %st, i64* noalias %ld) {
; CHECK-LABEL: @i64_simplifiedi_extract(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i64* [[LD:%.*]] to <2 x i64>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i64>, <2 x i64>* [[TMP1]], align 8
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i64> [[TMP2]], <2 x i64> poison, <4 x i32> <i32 0, i32 0, i32 0, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i64* [[ST:%.*]] to <4 x i64>*
; CHECK-NEXT:    store <4 x i64> [[SHUFFLE]], <4 x i64>* [[TMP3]], align 8
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i64> [[SHUFFLE]], i32 3
; CHECK-NEXT:    store i64 [[TMP4]], i64* [[LD]], align 8
; CHECK-NEXT:    ret void
;
  %arrayidx1 = getelementptr inbounds i64, i64* %ld, i64 1

  %t0 = load i64, i64* %ld, align 8
  %t1 = load i64, i64* %arrayidx1, align 8

  %arrayidx3 = getelementptr inbounds i64, i64* %st, i64 1
  %arrayidx4 = getelementptr inbounds i64, i64* %st, i64 2
  %arrayidx5 = getelementptr inbounds i64, i64* %st, i64 3

  store i64 %t0, i64* %st, align 8
  store i64 %t0, i64* %arrayidx3, align 8
  store i64 %t0, i64* %arrayidx4, align 8
  store i64 %t1, i64* %arrayidx5, align 8
  store i64 %t1, i64* %ld, align 8
  ret void
}

