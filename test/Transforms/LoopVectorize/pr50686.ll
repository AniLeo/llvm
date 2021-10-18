; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=4 -force-vector-interleave=1 -S < %s | FileCheck %s

define void @m(i32* nocapture %p, i32* nocapture %p2, i32 %q) {
; CHECK-LABEL: @m(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P1:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    [[P23:%.*]] = bitcast i32* [[P2:%.*]] to i8*
; CHECK-NEXT:    [[ARRAYIDX9_1:%.*]] = getelementptr inbounds i32, i32* [[P2]], i64 1
; CHECK-NEXT:    [[ARRAYIDX9_2:%.*]] = getelementptr inbounds i32, i32* [[P2]], i64 2
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[P]], i64 63
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = bitcast i32* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i32, i32* [[P2]], i64 3
; CHECK-NEXT:    [[SCEVGEP45:%.*]] = bitcast i32* [[SCEVGEP4]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[P1]], [[SCEVGEP45]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[P23]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[P2]], align 4, !alias.scope !0
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = sub nsw <4 x i32> zeroinitializer, [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[ARRAYIDX9_1]], align 4, !alias.scope !0
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT6:%.*]] = insertelement <4 x i32> poison, i32 [[TMP3]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT7:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT6]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = sub nsw <4 x i32> [[TMP2]], [[BROADCAST_SPLAT7]]
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32* [[ARRAYIDX9_2]], align 4, !alias.scope !0
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT8:%.*]] = insertelement <4 x i32> poison, i32 [[TMP5]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT9:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT8]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = sub nsw <4 x i32> [[TMP4]], [[BROADCAST_SPLAT9]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP6]], <4 x i32>* [[TMP9]], align 4, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], 60
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 63, 60
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END17:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 60, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_COND5:%.*]]
; CHECK:       for.cond5:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_COND5]] ]
; CHECK-NEXT:    [[I3:%.*]] = load i32, i32* [[P2]], align 4
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[I3]]
; CHECK-NEXT:    [[I4:%.*]] = load i32, i32* [[ARRAYIDX9_1]], align 4
; CHECK-NEXT:    [[SUB_1:%.*]] = sub nsw i32 [[SUB]], [[I4]]
; CHECK-NEXT:    [[I5:%.*]] = load i32, i32* [[ARRAYIDX9_2]], align 4
; CHECK-NEXT:    [[SUB_2:%.*]] = sub nsw i32 [[SUB_1]], [[I5]]
; CHECK-NEXT:    [[ARRAYIDX14:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[SUB_2]], i32* [[ARRAYIDX14]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 63
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END17]], label [[FOR_COND5]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end17:
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx9.1 = getelementptr inbounds i32, i32* %p2, i64 1
  %arrayidx9.2 = getelementptr inbounds i32, i32* %p2, i64 2
  br label %for.cond5

for.cond5:                              ; preds = %entry, %for.cond5
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.cond5 ]
  %i3 = load i32, i32* %p2, align 4
  %sub = sub nsw i32 0, %i3
  %i4 = load i32, i32* %arrayidx9.1, align 4
  %sub.1 = sub nsw i32 %sub, %i4
  %i5 = load i32, i32* %arrayidx9.2, align 4
  %sub.2 = sub nsw i32 %sub.1, %i5
  %arrayidx14 = getelementptr inbounds i32, i32* %p, i64 %indvars.iv
  store i32 %sub.2, i32* %arrayidx14, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 63
  br i1 %exitcond, label %for.end17, label %for.cond5

for.end17:                                        ; preds = %for.cond5
  ret void
}
