; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

; SLP vectorization example from http://cs.stanford.edu/people/eschkufz/research/asplos291-schkufza.pdf
define void @SAXPY(i32* noalias nocapture %x, i32* noalias nocapture %y, i32 %a, i64 %i) {
; CHECK-LABEL: @SAXPY(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[X:%.*]], i64 [[I:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[Y:%.*]], i64 [[I]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP1]] to <4 x i32>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x i32>, <4 x i32>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x i32> undef, i32 [[A:%.*]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x i32> [[TMP5]], i32 [[A]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x i32> [[TMP6]], i32 [[A]], i32 2
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <4 x i32> [[TMP7]], i32 [[A]], i32 3
; CHECK-NEXT:    [[TMP9:%.*]] = mul nsw <4 x i32> [[TMP8]], [[TMP4]]
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[TMP11:%.*]] = load <4 x i32>, <4 x i32>* [[TMP10]], align 4
; CHECK-NEXT:    [[TMP12:%.*]] = add nsw <4 x i32> [[TMP9]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP1]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP12]], <4 x i32>* [[TMP13]], align 4
; CHECK-NEXT:    ret void
;
  %1 = getelementptr inbounds i32, i32* %x, i64 %i
  %2 = load i32, i32* %1, align 4
  %3 = mul nsw i32 %2, %a
  %4 = getelementptr inbounds i32, i32* %y, i64 %i
  %5 = load i32, i32* %4, align 4
  %6 = add nsw i32 %3, %5
  store i32 %6, i32* %1, align 4
  %7 = add i64 %i, 1
  %8 = getelementptr inbounds i32, i32* %x, i64 %7
  %9 = load i32, i32* %8, align 4
  %10 = mul nsw i32 %9, %a
  %11 = getelementptr inbounds i32, i32* %y, i64 %7
  %12 = load i32, i32* %11, align 4
  %13 = add nsw i32 %10, %12
  store i32 %13, i32* %8, align 4
  %14 = add i64 %i, 2
  %15 = getelementptr inbounds i32, i32* %x, i64 %14
  %16 = load i32, i32* %15, align 4
  %17 = mul nsw i32 %16, %a
  %18 = getelementptr inbounds i32, i32* %y, i64 %14
  %19 = load i32, i32* %18, align 4
  %20 = add nsw i32 %17, %19
  store i32 %20, i32* %15, align 4
  %21 = add i64 %i, 3
  %22 = getelementptr inbounds i32, i32* %x, i64 %21
  %23 = load i32, i32* %22, align 4
  %24 = mul nsw i32 %23, %a
  %25 = getelementptr inbounds i32, i32* %y, i64 %21
  %26 = load i32, i32* %25, align 4
  %27 = add nsw i32 %24, %26
  store i32 %27, i32* %22, align 4
  ret void
}

; Make sure we don't crash on this one.
define void @SAXPY_crash(i32* noalias nocapture %x, i32* noalias nocapture %y, i64 %i) {
; CHECK-LABEL: @SAXPY_crash(
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[I:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[X:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[Y:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP3]] to <2 x i32>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x i32>, <2 x i32>* [[TMP4]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = add nsw <2 x i32> undef, [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP2]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> [[TMP6]], <2 x i32>* [[TMP7]], align 4
; CHECK-NEXT:    ret void
;
  %1 = add i64 %i, 1
  %2 = getelementptr inbounds i32, i32* %x, i64 %1
  %3 = getelementptr inbounds i32, i32* %y, i64 %1
  %4 = load i32, i32* %3, align 4
  %5 = add nsw i32 undef, %4
  store i32 %5, i32* %2, align 4
  %6 = add i64 %i, 2
  %7 = getelementptr inbounds i32, i32* %x, i64 %6
  %8 = getelementptr inbounds i32, i32* %y, i64 %6
  %9 = load i32, i32* %8, align 4
  %10 = add nsw i32 undef, %9
  store i32 %10, i32* %7, align 4
  ret void
}
