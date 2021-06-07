; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-vectorize -force-vector-interleave=3 -force-vector-width=2 -S | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

; Make sure the loop is vectorized and unrolled under -Os without folding its
; tail based on its trip-count being provably divisible by chosen VFxIC.

define dso_local void @constTC(i32* noalias nocapture %A) optsize {
; CHECK-LABEL: @constTC(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i32> poison, i32 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i32> [[BROADCAST_SPLATINSERT]], <2 x i32> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <2 x i32> [[BROADCAST_SPLAT]], <i32 0, i32 1>
; CHECK-NEXT:    [[INDUCTION1:%.*]] = add <2 x i32> [[BROADCAST_SPLAT]], <i32 2, i32 3>
; CHECK-NEXT:    [[INDUCTION2:%.*]] = add <2 x i32> [[BROADCAST_SPLAT]], <i32 4, i32 5>
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP6]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> <i32 13, i32 13>, <2 x i32>* [[TMP7]], align 1
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i32 2
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> <i32 13, i32 13>, <2 x i32>* [[TMP9]], align 1
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i32 4
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i32* [[TMP10]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> <i32 13, i32 13>, <2 x i32>* [[TMP11]], align 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 6
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i32 [[INDEX_NEXT]], 1800
; CHECK-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 1800, 1800
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ 1800, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[RIV:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[RIVPLUS1:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[RIV]]
; CHECK-NEXT:    store i32 13, i32* [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[RIVPLUS1]] = add nuw nsw i32 [[RIV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[RIVPLUS1]], 1800
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT]], label [[LOOP]], [[LOOP2:!llvm.loop !.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %riv = phi i32 [ 0, %entry ], [ %rivPlus1, %loop ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %riv
  store i32 13, i32* %arrayidx, align 1
  %rivPlus1 = add nuw nsw i32 %riv, 1
  %cond = icmp eq i32 %rivPlus1, 1800
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}
