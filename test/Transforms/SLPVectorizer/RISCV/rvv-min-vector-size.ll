; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -mtriple=riscv64 -mattr=+experimental-v \
; RUN: -riscv-v-vector-bits-min=128 -S | FileCheck %s --check-prefixes=CHECK,CHECK-128
; RUN: opt < %s -slp-vectorizer -mtriple=riscv64 -mattr=+experimental-v \
; RUN: -riscv-v-vector-bits-min=256 -S | FileCheck %s --check-prefixes=CHECK,CHECK-256
; RUN: opt < %s -slp-vectorizer -mtriple=riscv64 -mattr=+experimental-v \
; RUN: -riscv-v-vector-bits-min=512 -S | FileCheck %s --check-prefixes=CHECK,CHECK-512

target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64"

define void @foo(i64* nocapture writeonly %da) {
; CHECK-128-LABEL: @foo(
; CHECK-128-NEXT:  entry:
; CHECK-128-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[DA:%.*]], i64 1
; CHECK-128-NEXT:    [[TMP0:%.*]] = bitcast i64* [[DA]] to <2 x i64>*
; CHECK-128-NEXT:    store <2 x i64> <i64 0, i64 1>, <2 x i64>* [[TMP0]], align 8
; CHECK-128-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i64, i64* [[DA]], i64 2
; CHECK-128-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i64, i64* [[DA]], i64 3
; CHECK-128-NEXT:    [[TMP1:%.*]] = bitcast i64* [[ARRAYIDX2]] to <2 x i64>*
; CHECK-128-NEXT:    store <2 x i64> <i64 2, i64 3>, <2 x i64>* [[TMP1]], align 8
; CHECK-128-NEXT:    ret void
;
; CHECK-256-LABEL: @foo(
; CHECK-256-NEXT:  entry:
; CHECK-256-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[DA:%.*]], i64 1
; CHECK-256-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i64, i64* [[DA]], i64 2
; CHECK-256-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i64, i64* [[DA]], i64 3
; CHECK-256-NEXT:    [[TMP0:%.*]] = bitcast i64* [[DA]] to <4 x i64>*
; CHECK-256-NEXT:    store <4 x i64> <i64 0, i64 1, i64 2, i64 3>, <4 x i64>* [[TMP0]], align 8
; CHECK-256-NEXT:    ret void
;
; CHECK-512-LABEL: @foo(
; CHECK-512-NEXT:  entry:
; CHECK-512-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[DA:%.*]], i64 1
; CHECK-512-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i64, i64* [[DA]], i64 2
; CHECK-512-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i64, i64* [[DA]], i64 3
; CHECK-512-NEXT:    [[TMP0:%.*]] = bitcast i64* [[DA]] to <4 x i64>*
; CHECK-512-NEXT:    store <4 x i64> <i64 0, i64 1, i64 2, i64 3>, <4 x i64>* [[TMP0]], align 8
; CHECK-512-NEXT:    ret void
;
entry:
  store i64 0, i64* %da, align 8
  %arrayidx1 = getelementptr inbounds i64, i64* %da, i64 1
  store i64 1, i64* %arrayidx1, align 8
  %arrayidx2 = getelementptr inbounds i64, i64* %da, i64 2
  store i64 2, i64* %arrayidx2, align 8
  %arrayidx3 = getelementptr inbounds i64, i64* %da, i64 3
  store i64 3, i64* %arrayidx3, align 8
  ret void
}

define void @foo8(i8* nocapture writeonly %da) {
; CHECK-LABEL: @foo8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, i8* [[DA:%.*]], i8 1
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[DA]] to <2 x i8>*
; CHECK-NEXT:    store <2 x i8> <i8 0, i8 1>, <2 x i8>* [[TMP0]], align 8
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i8, i8* [[DA]], i8 2
; CHECK-NEXT:    ret void
;
entry:
  store i8 0, i8* %da, align 8
  %arrayidx1 = getelementptr inbounds i8, i8* %da, i8 1
  store i8 1, i8* %arrayidx1, align 8
  %arrayidx2 = getelementptr inbounds i8, i8* %da, i8 2
  ret void
}
