; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

define i32 @foo(i32* nocapture %A, i32 %n) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP62:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP62]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[ARRAYIDX]] to <8 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x i32>, <8 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> poison, i32 [[N]], i32 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <8 x i32> [[TMP2]], <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <8 x i32> [[TMP1]], [[SHUFFLE]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[ARRAYIDX]] to <8 x i32>*
; CHECK-NEXT:    store <8 x i32> [[TMP3]], <8 x i32>* [[TMP4]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 8
; CHECK-NEXT:    [[TMP5:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP5]], [[N]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i32 undef
;
entry:
  %cmp62 = icmp sgt i32 %n, 0
  br i1 %cmp62, label %for.body, label %for.end

for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %add1 = add nsw i32 %0, %n
  store i32 %add1, i32* %arrayidx, align 4
  %1 = or i64 %indvars.iv, 1
  %arrayidx4 = getelementptr inbounds i32, i32* %A, i64 %1
  %2 = load i32, i32* %arrayidx4, align 4
  %add5 = add nsw i32 %2, %n
  store i32 %add5, i32* %arrayidx4, align 4
  %3 = or i64 %indvars.iv, 2
  %arrayidx8 = getelementptr inbounds i32, i32* %A, i64 %3
  %4 = load i32, i32* %arrayidx8, align 4
  %add9 = add nsw i32 %4, %n
  store i32 %add9, i32* %arrayidx8, align 4
  %5 = or i64 %indvars.iv, 3
  %arrayidx12 = getelementptr inbounds i32, i32* %A, i64 %5
  %6 = load i32, i32* %arrayidx12, align 4
  %add13 = add nsw i32 %6, %n
  store i32 %add13, i32* %arrayidx12, align 4
  %7 = or i64 %indvars.iv, 4
  %arrayidx16 = getelementptr inbounds i32, i32* %A, i64 %7
  %8 = load i32, i32* %arrayidx16, align 4
  %add17 = add nsw i32 %8, %n
  store i32 %add17, i32* %arrayidx16, align 4
  %9 = or i64 %indvars.iv, 5
  %arrayidx20 = getelementptr inbounds i32, i32* %A, i64 %9
  %10 = load i32, i32* %arrayidx20, align 4
  %add21 = add nsw i32 %10, %n
  store i32 %add21, i32* %arrayidx20, align 4
  %11 = or i64 %indvars.iv, 6
  %arrayidx24 = getelementptr inbounds i32, i32* %A, i64 %11
  %12 = load i32, i32* %arrayidx24, align 4
  %add25 = add nsw i32 %12, %n
  store i32 %add25, i32* %arrayidx24, align 4
  %13 = or i64 %indvars.iv, 7
  %arrayidx28 = getelementptr inbounds i32, i32* %A, i64 %13
  %14 = load i32, i32* %arrayidx28, align 4
  %add29 = add nsw i32 %14, %n
  store i32 %add29, i32* %arrayidx28, align 4
  %indvars.iv.next = add i64 %indvars.iv, 8
  %15 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %15, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret i32 undef
}

