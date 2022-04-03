; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -S < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

define void @inv_store_i16(i16* noalias %dst, i16* noalias readonly %src, i64 %N) #0 {
; CHECK-LABEL: @inv_store_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], [[TMP1]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 4 x i16*> poison, i16* [[DST:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 4 x i16*> [[BROADCAST_SPLATINSERT]], <vscale x 4 x i16*> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i16, i16* [[SRC:%.*]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i16, i16* [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i16* [[TMP6]] to <vscale x 4 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 4 x i16>, <vscale x 4 x i16>* [[TMP7]], align 2
; CHECK-NEXT:    call void @llvm.masked.scatter.nxv4i16.nxv4p0i16(<vscale x 4 x i16> [[WIDE_LOAD]], <vscale x 4 x i16*> [[BROADCAST_SPLAT]], i32 2, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i32 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer))
; CHECK-NEXT:    [[TMP8:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP9:%.*]] = mul i64 [[TMP8]], 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP9]]
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_INC24:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY14:%.*]]
; CHECK:       for.body14:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY14]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, i16* [[SRC]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[LD:%.*]] = load i16, i16* [[ARRAYIDX]], align 2
; CHECK-NEXT:    store i16 [[LD]], i16* [[DST]], align 2
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_INC24]], label [[FOR_BODY14]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       for.inc24:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body14

for.body14:                                       ; preds = %for.body14, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body14 ]
  %arrayidx = getelementptr inbounds i16, i16* %src, i64 %indvars.iv
  %ld = load i16, i16* %arrayidx
  store i16 %ld, i16* %dst, align 2
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %N
  br i1 %exitcond.not, label %for.inc24, label %for.body14, !llvm.loop !0

for.inc24:                                        ; preds = %for.body14, %for.body
  ret void
}


define void @cond_inv_store_i32(i32* noalias %dst, i32* noalias readonly %src, i64 %N) #0 {
; CHECK-LABEL: @cond_inv_store_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], [[TMP1]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 4 x i32*> poison, i32* [[DST:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 4 x i32*> [[BROADCAST_SPLATINSERT]], <vscale x 4 x i32*> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[SRC:%.*]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP6]] to <vscale x 4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = icmp sgt <vscale x 4 x i32> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    call void @llvm.masked.scatter.nxv4i32.nxv4p0i32(<vscale x 4 x i32> [[WIDE_LOAD]], <vscale x 4 x i32*> [[BROADCAST_SPLAT]], i32 4, <vscale x 4 x i1> [[TMP8]])
; CHECK-NEXT:    [[TMP9:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP10:%.*]] = mul i64 [[TMP9]], 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP10]]
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_09:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_INC:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[SRC]], i64 [[I_09]]
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[TMP12]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[TMP12]], i32* [[DST]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_09]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.inc
  %i.09 = phi i64 [ %inc, %for.inc ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %src, i64 %i.09
  %0 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp sgt i32 %0, 0
  br i1 %cmp1, label %if.then, label %for.inc

if.then:                                          ; preds = %for.body
  store i32 %0, i32* %dst, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %inc = add nuw nsw i64 %i.09, 1
  %exitcond.not = icmp eq i64 %inc, %N
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !0

for.end:                                          ; preds = %for.inc, %entry
  ret void
}

attributes #0 = { "target-features"="+neon,+sve" vscale_range(1, 16) }

!0 = distinct !{!0, !1, !2, !3, !4, !5}
!1 = !{!"llvm.loop.mustprogress"}
!2 = !{!"llvm.loop.vectorize.width", i32 4}
!3 = !{!"llvm.loop.vectorize.scalable.enable", i1 true}
!4 = !{!"llvm.loop.vectorize.enable", i1 true}
!5 = !{!"llvm.loop.interleave.count", i32 1}
