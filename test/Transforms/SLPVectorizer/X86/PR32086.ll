; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -slp-vectorize-hor -slp-vectorize-hor-store -S < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=bdver2 | FileCheck %s

define void @i64_simplified(i64* noalias %st, i64* noalias %ld) {
; CHECK-LABEL: @i64_simplified(
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[LD:%.*]], i64 1
; CHECK-NEXT:    [[T0:%.*]] = load i64, i64* [[LD]], align 8
; CHECK-NEXT:    [[T1:%.*]] = load i64, i64* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i64, i64* [[ST:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i64, i64* [[ST]], i64 2
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i64, i64* [[ST]], i64 3
; CHECK-NEXT:    store i64 [[T0]], i64* [[ST]], align 8
; CHECK-NEXT:    store i64 [[T1]], i64* [[ARRAYIDX3]], align 8
; CHECK-NEXT:    store i64 [[T0]], i64* [[ARRAYIDX4]], align 8
; CHECK-NEXT:    store i64 [[T1]], i64* [[ARRAYIDX5]], align 8
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
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[LD:%.*]], i64 1
; CHECK-NEXT:    [[T0:%.*]] = load i64, i64* [[LD]], align 8
; CHECK-NEXT:    [[T1:%.*]] = load i64, i64* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i64, i64* [[ST:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i64, i64* [[ST]], i64 2
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i64, i64* [[ST]], i64 3
; CHECK-NEXT:    store i64 [[T1]], i64* [[ST]], align 8
; CHECK-NEXT:    store i64 [[T0]], i64* [[ARRAYIDX3]], align 8
; CHECK-NEXT:    store i64 [[T1]], i64* [[ARRAYIDX4]], align 8
; CHECK-NEXT:    store i64 [[T0]], i64* [[ARRAYIDX5]], align 8
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
