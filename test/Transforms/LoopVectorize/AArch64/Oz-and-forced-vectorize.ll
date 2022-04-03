; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -Oz -S -enable-new-pm=0  < %s | FileCheck %s
; RUN: opt -passes='default<Oz>' -S < %s | FileCheck %s

; Forcing vectorization should allow for more aggressive loop-rotation with
; -Oz, because LV requires rotated loops. Make sure the loop in @foo is
; vectorized with -Oz.

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-ios5.0.0"

define void @foo(float* noalias nocapture %ptrA, float* noalias nocapture readonly %ptrB, i64 %size) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXITCOND1:%.*]] = icmp eq i64 [[SIZE:%.*]], 0
; CHECK-NEXT:    br i1 [[EXITCOND1]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SIZE]], 8
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[FOR_BODY_PREHEADER6:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SIZE]], -8
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds float, float* [[PTRB:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[TMP0]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds float, float* [[TMP0]], i64 4
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[TMP2]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD3:%.*]] = load <4 x float>, <4 x float>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds float, float* [[PTRA:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast float* [[TMP4]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD4:%.*]] = load <4 x float>, <4 x float>* [[TMP5]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[TMP4]], i64 4
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast float* [[TMP6]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD5:%.*]] = load <4 x float>, <4 x float>* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = fmul <4 x float> [[WIDE_LOAD]], [[WIDE_LOAD4]]
; CHECK-NEXT:    [[TMP9:%.*]] = fmul <4 x float> [[WIDE_LOAD3]], [[WIDE_LOAD5]]
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast float* [[TMP4]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP8]], <4 x float>* [[TMP10]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast float* [[TMP6]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP9]], <4 x float>* [[TMP11]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_VEC]], [[SIZE]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_PREHEADER6]]
; CHECK:       for.body.preheader6:
; CHECK-NEXT:    [[INDVARS_IV2_PH:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[N_VEC]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV2:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[INDVARS_IV2_PH]], [[FOR_BODY_PREHEADER6]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[PTRB]], i64 [[INDVARS_IV2]]
; CHECK-NEXT:    [[TMP13:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[PTRA]], i64 [[INDVARS_IV2]]
; CHECK-NEXT:    [[TMP14:%.*]] = load float, float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[MUL3:%.*]] = fmul float [[TMP13]], [[TMP14]]
; CHECK-NEXT:    store float [[MUL3]], float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV2]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], [[SIZE]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %exitcond = icmp eq i64 %indvars.iv, %size
  br i1 %exitcond, label %for.cond.cleanup, label %for.body

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds float, float* %ptrB, i64 %indvars.iv
  %0 = load float, float* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds float, float* %ptrA, i64 %indvars.iv
  %1 = load float, float* %arrayidx2, align 4
  %mul3 = fmul float %0, %1
  store float %mul3, float* %arrayidx2, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  br label %for.cond, !llvm.loop !0

for.cond.cleanup:                                 ; preds = %for.cond
  ret void
}

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.vectorize.enable", i1 true}
