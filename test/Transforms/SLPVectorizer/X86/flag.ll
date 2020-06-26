; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -slp-threshold=1000 -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

; Check that the command line flag works.
define i32 @rollable(i32* noalias nocapture %in, i32* noalias nocapture %out, i64 %n) {
; CHECK-LABEL: @rollable(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[DOT_CRIT_EDGE:%.*]], label [[DOTLR_PH:%.*]]
; CHECK:       .lr.ph:
; CHECK-NEXT:    [[I_019:%.*]] = phi i64 [ [[TMP26:%.*]], [[DOTLR_PH]] ], [ 0, [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[I_019]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[IN:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = or i64 [[TMP2]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[IN]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, i32* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = or i64 [[TMP2]], 2
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[IN]], i64 [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = or i64 [[TMP2]], 3
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[IN]], i64 [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = load i32, i32* [[TMP12]], align 4
; CHECK-NEXT:    [[TMP14:%.*]] = mul i32 [[TMP4]], 7
; CHECK-NEXT:    [[TMP15:%.*]] = add i32 [[TMP14]], 7
; CHECK-NEXT:    [[TMP16:%.*]] = mul i32 [[TMP7]], 7
; CHECK-NEXT:    [[TMP17:%.*]] = add i32 [[TMP16]], 14
; CHECK-NEXT:    [[TMP18:%.*]] = mul i32 [[TMP10]], 7
; CHECK-NEXT:    [[TMP19:%.*]] = add i32 [[TMP18]], 21
; CHECK-NEXT:    [[TMP20:%.*]] = mul i32 [[TMP13]], 7
; CHECK-NEXT:    [[TMP21:%.*]] = add i32 [[TMP20]], 28
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds i32, i32* [[OUT:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    store i32 [[TMP15]], i32* [[TMP22]], align 4
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds i32, i32* [[OUT]], i64 [[TMP5]]
; CHECK-NEXT:    store i32 [[TMP17]], i32* [[TMP23]], align 4
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds i32, i32* [[OUT]], i64 [[TMP8]]
; CHECK-NEXT:    store i32 [[TMP19]], i32* [[TMP24]], align 4
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr inbounds i32, i32* [[OUT]], i64 [[TMP11]]
; CHECK-NEXT:    store i32 [[TMP21]], i32* [[TMP25]], align 4
; CHECK-NEXT:    [[TMP26]] = add i64 [[I_019]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[TMP26]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[DOT_CRIT_EDGE]], label [[DOTLR_PH]]
; CHECK:       ._crit_edge:
; CHECK-NEXT:    ret i32 undef
;
  %1 = icmp eq i64 %n, 0
  br i1 %1, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %0, %.lr.ph
  %i.019 = phi i64 [ %26, %.lr.ph ], [ 0, %0 ]
  %2 = shl i64 %i.019, 2
  %3 = getelementptr inbounds i32, i32* %in, i64 %2
  %4 = load i32, i32* %3, align 4
  %5 = or i64 %2, 1
  %6 = getelementptr inbounds i32, i32* %in, i64 %5
  %7 = load i32, i32* %6, align 4
  %8 = or i64 %2, 2
  %9 = getelementptr inbounds i32, i32* %in, i64 %8
  %10 = load i32, i32* %9, align 4
  %11 = or i64 %2, 3
  %12 = getelementptr inbounds i32, i32* %in, i64 %11
  %13 = load i32, i32* %12, align 4
  %14 = mul i32 %4, 7
  %15 = add i32 %14, 7
  %16 = mul i32 %7, 7
  %17 = add i32 %16, 14
  %18 = mul i32 %10, 7
  %19 = add i32 %18, 21
  %20 = mul i32 %13, 7
  %21 = add i32 %20, 28
  %22 = getelementptr inbounds i32, i32* %out, i64 %2
  store i32 %15, i32* %22, align 4
  %23 = getelementptr inbounds i32, i32* %out, i64 %5
  store i32 %17, i32* %23, align 4
  %24 = getelementptr inbounds i32, i32* %out, i64 %8
  store i32 %19, i32* %24, align 4
  %25 = getelementptr inbounds i32, i32* %out, i64 %11
  store i32 %21, i32* %25, align 4
  %26 = add i64 %i.019, 1
  %exitcond = icmp eq i64 %26, %n
  br i1 %exitcond, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph, %0
  ret i32 undef
}
