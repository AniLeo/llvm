; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -S -mtriple=x86_64-unknown-linux -mcpu=core-avx2 | FileCheck %s
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.S = type { [3 x float], [3 x float], [4 x float] }

define i32 @foo(i32 %0, i32* %1, float* %2)  {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[T4:%.*]] = alloca [[STRUCT_S:%.*]], align 8
; CHECK-NEXT:    [[T8:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[T4]], i64 0, i32 1
; CHECK-NEXT:    [[T9:%.*]] = getelementptr inbounds [3 x float], [3 x float]* [[T8]], i64 1, i64 0
; CHECK-NEXT:    [[T14:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[T4]], i64 0, i32 1, i64 0
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast float* [[T14]] to <2 x float>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x float>, <2 x float>* [[TMP4]], align 4
; CHECK-NEXT:    br label [[T37:%.*]]
; CHECK:       t37:
; CHECK-NEXT:    [[TMP6:%.*]] = phi <2 x float> [ [[TMP5]], [[TMP3:%.*]] ], [ [[T89:%.*]], [[T37]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = fdiv fast <2 x float> <float 1.000000e+00, float 1.000000e+00>, [[TMP6]]
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x float> [[TMP7]], <2 x float> poison, <4 x i32> <i32 0, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[T21:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[T4]], i64 0, i32 2, i64 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[T21]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[SHUFFLE]], <4 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[T88:%.*]] = bitcast float* [[T9]] to <2 x float>*
; CHECK-NEXT:    [[T89]] = load <2 x float>, <2 x float>* [[T88]], align 4
; CHECK-NEXT:    br i1 undef, label [[T37]], label [[T55:%.*]]
; CHECK:       t55:
; CHECK-NEXT:    ret i32 0
;
  %t4 = alloca %struct.S, align 8
  %t8 = getelementptr inbounds %struct.S, %struct.S* %t4, i64 0, i32 1
  %t9 = getelementptr inbounds [3 x float], [3 x float]* %t8, i64 1, i64 0
  %t14 = getelementptr inbounds %struct.S, %struct.S* %t4, i64 0, i32 1, i64 0
  %t11 = getelementptr inbounds %struct.S, %struct.S* %t4, i64 0, i32 1, i64 1
  %t15 = load float, float* %t14, align 4
  %t16 = load float, float* %t11, align 4
  br label %t37

t37:

  %t18 = phi float [ %t16, %3 ], [ %x24, %t37 ]
  %t19 = phi float [ %t15, %3 ], [ %x23, %t37 ]
  %t20 = fdiv fast float 1.000000e+00, %t19
  %t24 = fdiv fast float 1.000000e+00, %t18
  %t21 = getelementptr inbounds %struct.S, %struct.S* %t4, i64 0, i32 2, i64 0
  %t25 = getelementptr inbounds %struct.S, %struct.S* %t4, i64 0, i32 2, i64 1
  %t31 = getelementptr inbounds %struct.S, %struct.S* %t4, i64 0, i32 2, i64 2
  %t33 = getelementptr inbounds %struct.S, %struct.S* %t4, i64 0, i32 2, i64 3
  store float %t20, float* %t21, align 4
  store float %t24, float* %t25, align 4
  store float %t24, float* %t31, align 4
  store float %t24, float* %t33, align 4
  %t88 = bitcast float* %t9 to <2 x float>*
  %t89 = load <2 x float>, <2 x float>* %t88, align 4
  %x23 = extractelement <2 x float> %t89, i32 0
  %x24 = extractelement <2 x float> %t89, i32 1
  br i1 undef, label %t37, label %t55

t55:

  ret i32 0

}

