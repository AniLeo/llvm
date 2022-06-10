; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

; Function Attrs: nounwind ssp uwtable
define void @RCModelEstimator() {
; CHECK-LABEL: @RCModelEstimator(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[FOR_BODY_LR_PH:%.*]], label [[FOR_END_THREAD:%.*]]
; CHECK:       for.end.thread:
; CHECK-NEXT:    unreachable
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    br i1 undef, label [[FOR_END:%.*]], label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 undef, label [[FOR_END]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    br i1 undef, label [[FOR_BODY3:%.*]], label [[IF_END103:%.*]]
; CHECK:       for.cond14.preheader:
; CHECK-NEXT:    br i1 undef, label [[FOR_BODY16_LR_PH:%.*]], label [[IF_END103]]
; CHECK:       for.body16.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY16:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN7:%.*]], label [[FOR_INC11:%.*]]
; CHECK:       if.then7:
; CHECK-NEXT:    br label [[FOR_INC11]]
; CHECK:       for.inc11:
; CHECK-NEXT:    br i1 false, label [[FOR_COND14_PREHEADER:%.*]], label [[FOR_BODY3]]
; CHECK:       for.body16:
; CHECK-NEXT:    br i1 undef, label [[FOR_END39:%.*]], label [[FOR_BODY16]]
; CHECK:       for.end39:
; CHECK-NEXT:    br i1 undef, label [[IF_END103]], label [[FOR_COND45_PREHEADER:%.*]]
; CHECK:       for.cond45.preheader:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN88:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then88:
; CHECK-NEXT:    br label [[IF_END103]]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[IF_END103]]
; CHECK:       if.end103:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %for.body.lr.ph, label %for.end.thread

for.end.thread:                                   ; preds = %entry
  unreachable

for.body.lr.ph:                                   ; preds = %entry
  br i1 undef, label %for.end, label %for.body

for.body:                                         ; preds = %for.body, %for.body.lr.ph
  br i1 undef, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %for.body.lr.ph
  br i1 undef, label %for.body3, label %if.end103

for.cond14.preheader:                             ; preds = %for.inc11
  br i1 undef, label %for.body16.lr.ph, label %if.end103

for.body16.lr.ph:                                 ; preds = %for.cond14.preheader
  br label %for.body16

for.body3:                                        ; preds = %for.inc11, %for.end
  br i1 undef, label %if.then7, label %for.inc11

if.then7:                                         ; preds = %for.body3
  br label %for.inc11

for.inc11:                                        ; preds = %if.then7, %for.body3
  br i1 false, label %for.cond14.preheader, label %for.body3

for.body16:                                       ; preds = %for.body16, %for.body16.lr.ph
  br i1 undef, label %for.end39, label %for.body16

for.end39:                                        ; preds = %for.body16
  br i1 undef, label %if.end103, label %for.cond45.preheader

for.cond45.preheader:                             ; preds = %for.end39
  br i1 undef, label %if.then88, label %if.else

if.then88:                                        ; preds = %for.cond45.preheader
  %mul89 = fmul double 0.000000e+00, 0.000000e+00
  %mul90 = fmul double 0.000000e+00, 0.000000e+00
  %sub91 = fsub double %mul89, %mul90
  %div92 = fdiv double %sub91, poison
  %mul94 = fmul double 0.000000e+00, 0.000000e+00
  %mul95 = fmul double 0.000000e+00, 0.000000e+00
  %sub96 = fsub double %mul94, %mul95
  %div97 = fdiv double %sub96, poison
  br label %if.end103

if.else:                                          ; preds = %for.cond45.preheader
  br label %if.end103

if.end103:                                        ; preds = %if.else, %if.then88, %for.end39, %for.cond14.preheader, %for.end
  %0 = phi double [ 0.000000e+00, %for.end39 ], [ %div97, %if.then88 ], [ 0.000000e+00, %if.else ], [ 0.000000e+00, %for.cond14.preheader ], [ 0.000000e+00, %for.end ]
  %1 = phi double [ poison, %for.end39 ], [ %div92, %if.then88 ], [ poison, %if.else ], [ 0.000000e+00, %for.cond14.preheader ], [ 0.000000e+00, %for.end ]
  ret void
}


define void @intrapred_luma([13 x i16]* %ptr) {
; CHECK-LABEL: @intrapred_luma(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV153:%.*]] = trunc i32 3 to i16
; CHECK-NEXT:    [[ARRAYIDX154:%.*]] = getelementptr inbounds [13 x i16], [13 x i16]* [[PTR:%.*]], i64 0, i64 12
; CHECK-NEXT:    store i16 [[CONV153]], i16* [[ARRAYIDX154]], align 8
; CHECK-NEXT:    [[ARRAYIDX155:%.*]] = getelementptr inbounds [13 x i16], [13 x i16]* [[PTR]], i64 0, i64 11
; CHECK-NEXT:    store i16 [[CONV153]], i16* [[ARRAYIDX155]], align 2
; CHECK-NEXT:    [[ARRAYIDX156:%.*]] = getelementptr inbounds [13 x i16], [13 x i16]* [[PTR]], i64 0, i64 10
; CHECK-NEXT:    store i16 [[CONV153]], i16* [[ARRAYIDX156]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %conv153 = trunc i32 3 to i16
  %arrayidx154 = getelementptr inbounds [13 x i16], [13 x i16]* %ptr, i64 0, i64 12
  store i16 %conv153, i16* %arrayidx154, align 8
  %arrayidx155 = getelementptr inbounds [13 x i16], [13 x i16]* %ptr, i64 0, i64 11
  store i16 %conv153, i16* %arrayidx155, align 2
  %arrayidx156 = getelementptr inbounds [13 x i16], [13 x i16]* %ptr, i64 0, i64 10
  store i16 %conv153, i16* %arrayidx156, align 4
  ret void
}

define fastcc void @dct36(double* %inbuf) {
; CHECK-LABEL: @dct36(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX44:%.*]] = getelementptr inbounds double, double* [[INBUF:%.*]], i64 1
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast double* [[INBUF]] to <2 x double>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, <2 x double>* [[TMP0]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <2 x double> [[TMP1]], <2 x double> poison, <2 x i32> <i32 1, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <2 x double> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast double* [[ARRAYIDX44]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP3]], <2 x double>* [[TMP4]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx41 = getelementptr inbounds double, double* %inbuf, i64 2
  %arrayidx44 = getelementptr inbounds double, double* %inbuf, i64 1
  %0 = load double, double* %arrayidx44, align 8
  %add46 = fadd double %0, poison
  store double %add46, double* %arrayidx41, align 8
  %1 = load double, double* %inbuf, align 8
  %add49 = fadd double %1, %0
  store double %add49, double* %arrayidx44, align 8
  ret void
}
