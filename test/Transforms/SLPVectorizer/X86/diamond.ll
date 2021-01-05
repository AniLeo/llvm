; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

; int foo(int * restrict B,  int * restrict A, int n, int m) {
;   B[0] = n * A[0] + m * A[0];
;   B[1] = n * A[1] + m * A[1];
;   B[2] = n * A[2] + m * A[2];
;   B[3] = n * A[3] + m * A[3];
;   return 0;
; }

define i32 @foo(i32* noalias nocapture %B, i32* noalias nocapture %A, i32 %n, i32 %m) #0 {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MUL238:%.*]] = add i32 [[M:%.*]], [[N:%.*]]
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 2
; CHECK-NEXT:    [[ARRAYIDX15:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 2
; CHECK-NEXT:    [[ARRAYIDX16:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 3
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i32> poison, i32 [[MUL238]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i32> [[TMP2]], i32 [[MUL238]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x i32> [[TMP3]], i32 [[MUL238]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x i32> [[TMP4]], i32 [[MUL238]], i32 3
; CHECK-NEXT:    [[TMP6:%.*]] = mul <4 x i32> [[TMP1]], [[TMP5]]
; CHECK-NEXT:    [[ARRAYIDX21:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 3
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[B]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP6]], <4 x i32>* [[TMP7]], align 4
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = load i32, i32* %A, align 4
  %mul238 = add i32 %m, %n
  %add = mul i32 %0, %mul238
  store i32 %add, i32* %B, align 4
  %arrayidx4 = getelementptr inbounds i32, i32* %A, i64 1
  %1 = load i32, i32* %arrayidx4, align 4
  %add8 = mul i32 %1, %mul238
  %arrayidx9 = getelementptr inbounds i32, i32* %B, i64 1
  store i32 %add8, i32* %arrayidx9, align 4
  %arrayidx10 = getelementptr inbounds i32, i32* %A, i64 2
  %2 = load i32, i32* %arrayidx10, align 4
  %add14 = mul i32 %2, %mul238
  %arrayidx15 = getelementptr inbounds i32, i32* %B, i64 2
  store i32 %add14, i32* %arrayidx15, align 4
  %arrayidx16 = getelementptr inbounds i32, i32* %A, i64 3
  %3 = load i32, i32* %arrayidx16, align 4
  %add20 = mul i32 %3, %mul238
  %arrayidx21 = getelementptr inbounds i32, i32* %B, i64 3
  store i32 %add20, i32* %arrayidx21, align 4
  ret i32 0
}


; int extr_user(int * restrict B,  int * restrict A, int n, int m) {
;   B[0] = n * A[0] + m * A[0];
;   B[1] = n * A[1] + m * A[1];
;   B[2] = n * A[2] + m * A[2];
;   B[3] = n * A[3] + m * A[3];
;   return A[0];
; }

define i32 @extr_user(i32* noalias nocapture %B, i32* noalias nocapture %A, i32 %n, i32 %m) {
; CHECK-LABEL: @extr_user(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MUL238:%.*]] = add i32 [[M:%.*]], [[N:%.*]]
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 2
; CHECK-NEXT:    [[ARRAYIDX15:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 2
; CHECK-NEXT:    [[ARRAYIDX16:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 3
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i32> poison, i32 [[MUL238]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i32> [[TMP2]], i32 [[MUL238]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x i32> [[TMP3]], i32 [[MUL238]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x i32> [[TMP4]], i32 [[MUL238]], i32 3
; CHECK-NEXT:    [[TMP6:%.*]] = mul <4 x i32> [[TMP1]], [[TMP5]]
; CHECK-NEXT:    [[ARRAYIDX21:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 3
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[B]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP6]], <4 x i32>* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x i32> [[TMP1]], i32 0
; CHECK-NEXT:    ret i32 [[TMP8]]
;
entry:
  %0 = load i32, i32* %A, align 4
  %mul238 = add i32 %m, %n
  %add = mul i32 %0, %mul238
  store i32 %add, i32* %B, align 4
  %arrayidx4 = getelementptr inbounds i32, i32* %A, i64 1
  %1 = load i32, i32* %arrayidx4, align 4
  %add8 = mul i32 %1, %mul238
  %arrayidx9 = getelementptr inbounds i32, i32* %B, i64 1
  store i32 %add8, i32* %arrayidx9, align 4
  %arrayidx10 = getelementptr inbounds i32, i32* %A, i64 2
  %2 = load i32, i32* %arrayidx10, align 4
  %add14 = mul i32 %2, %mul238
  %arrayidx15 = getelementptr inbounds i32, i32* %B, i64 2
  store i32 %add14, i32* %arrayidx15, align 4
  %arrayidx16 = getelementptr inbounds i32, i32* %A, i64 3
  %3 = load i32, i32* %arrayidx16, align 4
  %add20 = mul i32 %3, %mul238
  %arrayidx21 = getelementptr inbounds i32, i32* %B, i64 3
  store i32 %add20, i32* %arrayidx21, align 4
  ret i32 %0  ;<--------- This value has multiple users
}

; In this example we have an external user that is not the first element in the vector.
define i32 @extr_user1(i32* noalias nocapture %B, i32* noalias nocapture %A, i32 %n, i32 %m) {
; CHECK-LABEL: @extr_user1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MUL238:%.*]] = add i32 [[M:%.*]], [[N:%.*]]
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 2
; CHECK-NEXT:    [[ARRAYIDX15:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 2
; CHECK-NEXT:    [[ARRAYIDX16:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 3
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i32> poison, i32 [[MUL238]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i32> [[TMP2]], i32 [[MUL238]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x i32> [[TMP3]], i32 [[MUL238]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x i32> [[TMP4]], i32 [[MUL238]], i32 3
; CHECK-NEXT:    [[TMP6:%.*]] = mul <4 x i32> [[TMP1]], [[TMP5]]
; CHECK-NEXT:    [[ARRAYIDX21:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 3
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[B]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP6]], <4 x i32>* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x i32> [[TMP1]], i32 1
; CHECK-NEXT:    ret i32 [[TMP8]]
;
entry:
  %0 = load i32, i32* %A, align 4
  %mul238 = add i32 %m, %n
  %add = mul i32 %0, %mul238
  store i32 %add, i32* %B, align 4
  %arrayidx4 = getelementptr inbounds i32, i32* %A, i64 1
  %1 = load i32, i32* %arrayidx4, align 4
  %add8 = mul i32 %1, %mul238
  %arrayidx9 = getelementptr inbounds i32, i32* %B, i64 1
  store i32 %add8, i32* %arrayidx9, align 4
  %arrayidx10 = getelementptr inbounds i32, i32* %A, i64 2
  %2 = load i32, i32* %arrayidx10, align 4
  %add14 = mul i32 %2, %mul238
  %arrayidx15 = getelementptr inbounds i32, i32* %B, i64 2
  store i32 %add14, i32* %arrayidx15, align 4
  %arrayidx16 = getelementptr inbounds i32, i32* %A, i64 3
  %3 = load i32, i32* %arrayidx16, align 4
  %add20 = mul i32 %3, %mul238
  %arrayidx21 = getelementptr inbounds i32, i32* %B, i64 3
  store i32 %add20, i32* %arrayidx21, align 4
  ret i32 %1  ;<--------- This value has multiple users
}
