; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; This checks updating of phi nodes when the transformation is deemed
; unprofitable after IV widening.

; RUN: opt < %s -S -loop-flatten \
; RUN:     -verify-loop-info -verify-dom-info -verify-scev -verify | \
; RUN:     FileCheck %s --check-prefix=CHECK

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@d = dso_local global i32 0, align 4
@b = internal global i32 0, align 4
@a = internal global i32 0, align 4
@c = dso_local global i32* null, align 8

define dso_local i32 @fn1() local_unnamed_addr #0 {
; CHECK-LABEL: @fn1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @d, align 4
; CHECK-NEXT:    store i32 [[TMP0]], i32* @b, align 4
; CHECK-NEXT:    store i32 [[TMP0]], i32* @a, align 4
; CHECK-NEXT:    [[CMP15:%.*]] = icmp sgt i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[CMP15]], label [[FOR_COND1_PREHEADER_US_PREHEADER:%.*]], label [[FOR_END6:%.*]]
; CHECK:       for.cond1.preheader.us.preheader:
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = sext i32 [[TMP0]] to i64
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER_US:%.*]]
; CHECK:       for.cond1.preheader.us:
; CHECK-NEXT:    [[INDVAR2:%.*]] = phi i64 [ [[INDVAR_NEXT3:%.*]], [[FOR_COND1_FOR_INC4_CRIT_EDGE_US:%.*]] ], [ 0, [[FOR_COND1_PREHEADER_US_PREHEADER]] ]
; CHECK-NEXT:    [[I_016_US:%.*]] = phi i32 [ [[INC5_US:%.*]], [[FOR_COND1_FOR_INC4_CRIT_EDGE_US]] ], [ 0, [[FOR_COND1_PREHEADER_US_PREHEADER]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32*, i32** @c, align 8
; CHECK-NEXT:    [[TMP5:%.*]] = mul nsw i64 [[INDVAR2]], [[TMP2]]
; CHECK-NEXT:    [[MUL_US:%.*]] = mul nsw i32 [[I_016_US]], [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = sext i32 [[MUL_US]] to i64
; CHECK-NEXT:    br label [[FOR_BODY3_US:%.*]]
; CHECK:       for.body3.us:
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i64 [ [[INDVAR_NEXT:%.*]], [[FOR_BODY3_US]] ], [ 0, [[FOR_COND1_PREHEADER_US]] ]
; CHECK-NEXT:    [[J_014_US:%.*]] = phi i32 [ 0, [[FOR_COND1_PREHEADER_US]] ], [ [[INC_US:%.*]], [[FOR_BODY3_US]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw i64 [[INDVAR]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = sext i32 [[J_014_US]] to i64
; CHECK-NEXT:    [[TMP9:%.*]] = add nsw i64 [[TMP8]], [[TMP5]]
; CHECK-NEXT:    [[ADD_US:%.*]] = add nsw i32 [[J_014_US]], [[MUL_US]]
; CHECK-NEXT:    [[IDXPROM_US:%.*]] = sext i32 [[ADD_US]] to i64
; CHECK-NEXT:    [[ARRAYIDX_US:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i64 [[TMP7]]
; CHECK-NEXT:    store i32 32, i32* [[ARRAYIDX_US]], align 4
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; CHECK-NEXT:    [[INC_US]] = add nuw nsw i32 [[J_014_US]], 1
; CHECK-NEXT:    [[CMP2_US:%.*]] = icmp slt i64 [[INDVAR_NEXT]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP2_US]], label [[FOR_BODY3_US]], label [[FOR_COND1_FOR_INC4_CRIT_EDGE_US]]
; CHECK:       for.cond1.for.inc4_crit_edge.us:
; CHECK-NEXT:    [[INDVAR_NEXT3]] = add i64 [[INDVAR2]], 1
; CHECK-NEXT:    [[INC5_US]] = add nuw nsw i32 [[I_016_US]], 1
; CHECK-NEXT:    [[CMP_US:%.*]] = icmp slt i64 [[INDVAR_NEXT3]], [[TMP3]]
; CHECK-NEXT:    br i1 [[CMP_US]], label [[FOR_COND1_PREHEADER_US]], label [[FOR_END6_LOOPEXIT:%.*]]
; CHECK:       for.end6.loopexit:
; CHECK-NEXT:    br label [[FOR_END6]]
; CHECK:       for.end6:
; CHECK-NEXT:    ret i32 undef
;
entry:
  %0 = load i32, i32* @d, align 4
  store i32 %0, i32* @b, align 4
  store i32 %0, i32* @a, align 4
  %cmp15 = icmp sgt i32 %0, 0
  br i1 %cmp15, label %for.cond1.preheader.us.preheader, label %for.end6

for.cond1.preheader.us.preheader:
  br label %for.cond1.preheader.us

for.cond1.preheader.us:
  %i.016.us = phi i32 [ %inc5.us, %for.cond1.for.inc4_crit_edge.us ], [ 0, %for.cond1.preheader.us.preheader ]
  %1 = load i32*, i32** @c, align 8
  %mul.us = mul nsw i32 %i.016.us, %0
  br label %for.body3.us

for.body3.us:
  %j.014.us = phi i32 [ 0, %for.cond1.preheader.us ], [ %inc.us, %for.body3.us ]
  %add.us = add nsw i32 %j.014.us, %mul.us
  %idxprom.us = sext i32 %add.us to i64
  %arrayidx.us = getelementptr inbounds i32, i32* %1, i64 %idxprom.us
  store i32 32, i32* %arrayidx.us, align 4
  %inc.us = add nuw nsw i32 %j.014.us, 1
  %cmp2.us = icmp slt i32 %inc.us, %0
  br i1 %cmp2.us, label %for.body3.us, label %for.cond1.for.inc4_crit_edge.us

for.cond1.for.inc4_crit_edge.us:
  %inc5.us = add nuw nsw i32 %i.016.us, 1
  %cmp.us = icmp slt i32 %inc5.us, %0
  br i1 %cmp.us, label %for.cond1.preheader.us, label %for.end6.loopexit

for.end6.loopexit:
  br label %for.end6

for.end6:
  ret i32 undef
}
