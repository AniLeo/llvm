; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=thumbv8.1m.main-arm-eabihf -mattr=+mve.fp -loop-vectorize -tail-predication=enabled -S < %s | \
; RUN:  FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"

; Test that ARMTTIImpl::preferPredicateOverEpilogue triggers tail-folding.

define dso_local void @f1(i32* noalias nocapture %A, i32* noalias nocapture readonly %B, i32* noalias nocapture readonly %C, i32 %N) {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP8:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP8]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP6]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD1]], [[WIDE_MASKED_LOAD]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i32* [[TMP9]] to <4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP7]], <4 x i32>* [[TMP10]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_09:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[I_09]]
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[I_09]]
; CHECK-NEXT:    [[TMP13:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP13]], [[TMP12]]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[I_09]]
; CHECK-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_09]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
;
entry:
  %cmp8 = icmp sgt i32 %N, 0
  br i1 %cmp8, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.09 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %B, i32 %i.09
  %0 = load i32, i32* %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, i32* %C, i32 %i.09
  %1 = load i32, i32* %arrayidx1, align 4
  %add = add nsw i32 %1, %0
  %arrayidx2 = getelementptr inbounds i32, i32* %A, i32 %i.09
  store i32 %add, i32* %arrayidx2, align 4
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond.not = icmp eq i32 %inc, %N
  br i1 %exitcond.not, label %for.cond.cleanup.loopexit, label %for.body
}

define dso_local void @f32_reduction(float* nocapture readonly %Input, i32 %N, float* nocapture %Output) {
; CHECK-LABEL: @f32_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP6:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP6]], label [[WHILE_END:%.*]], label [[WHILE_BODY_PREHEADER:%.*]]
; CHECK:       while.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = sub i32 [[N]], [[N_VEC]]
; CHECK-NEXT:    [[IND_END2:%.*]] = getelementptr float, float* [[INPUT:%.*]], i32 [[N_VEC]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x float> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr float, float* [[INPUT]], i32 [[TMP0]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = add <4 x i32> [[BROADCAST_SPLAT]], <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x i32> [[VEC_IV]], i32 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP1]], i32 [[N]])
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr float, float* [[NEXT_GEP]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[TMP2]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x float> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = fadd fast <4 x float> [[WIDE_MASKED_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP5]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x float> [[TMP4]], <4 x float> [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP7:%.*]] = call fast float @llvm.vector.reduce.fadd.v4f32(float -0.000000e+00, <4 x float> [[TMP5]])
; CHECK-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[N]], [[WHILE_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi float* [ [[IND_END2]], [[MIDDLE_BLOCK]] ], [ [[INPUT]], [[WHILE_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi float [ 0.000000e+00, [[WHILE_BODY_PREHEADER]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[BLKCNT_09:%.*]] = phi i32 [ [[DEC:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[SUM_08:%.*]] = phi float [ [[ADD:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INPUT_ADDR_07:%.*]] = phi float* [ [[INCDEC_PTR:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds float, float* [[INPUT_ADDR_07]], i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load float, float* [[INPUT_ADDR_07]], align 4
; CHECK-NEXT:    [[ADD]] = fadd fast float [[TMP8]], [[SUM_08]]
; CHECK-NEXT:    [[DEC]] = add i32 [[BLKCNT_09]], -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[DEC]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[WHILE_END_LOOPEXIT]], label [[WHILE_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       while.end.loopexit:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi float [ [[ADD]], [[WHILE_BODY]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[WHILE_END]]
; CHECK:       while.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[WHILE_END_LOOPEXIT]] ]
; CHECK-NEXT:    [[CONV:%.*]] = uitofp i32 [[N]] to float
; CHECK-NEXT:    [[DIV:%.*]] = fdiv fast float [[SUM_0_LCSSA]], [[CONV]]
; CHECK-NEXT:    store float [[DIV]], float* [[OUTPUT:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %cmp6 = icmp eq i32 %N, 0
  br i1 %cmp6, label %while.end, label %while.body.preheader

while.body.preheader:                             ; preds = %entry
  br label %while.body

while.body:                                       ; preds = %while.body.preheader, %while.body
  %blkCnt.09 = phi i32 [ %dec, %while.body ], [ %N, %while.body.preheader ]
  %sum.08 = phi float [ %add, %while.body ], [ 0.000000e+00, %while.body.preheader ]
  %Input.addr.07 = phi float* [ %incdec.ptr, %while.body ], [ %Input, %while.body.preheader ]
  %incdec.ptr = getelementptr inbounds float, float* %Input.addr.07, i32 1
  %0 = load float, float* %Input.addr.07, align 4
  %add = fadd fast float %0, %sum.08
  %dec = add i32 %blkCnt.09, -1
  %cmp = icmp eq i32 %dec, 0
  br i1 %cmp, label %while.end.loopexit, label %while.body

while.end.loopexit:                               ; preds = %while.body
  %add.lcssa = phi float [ %add, %while.body ]
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %entry
  %sum.0.lcssa = phi float [ 0.000000e+00, %entry ], [ %add.lcssa, %while.end.loopexit ]
  %conv = uitofp i32 %N to float
  %div = fdiv fast float %sum.0.lcssa, %conv
  store float %div, float* %Output, align 4
  ret void
}

define dso_local void @f16_reduction(half* nocapture readonly %Input, i32 %N, half* nocapture %Output) {
; CHECK-LABEL: @f16_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP6:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP6]], label [[WHILE_END:%.*]], label [[WHILE_BODY_PREHEADER:%.*]]
; CHECK:       while.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 7
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 8
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = sub i32 [[N]], [[N_VEC]]
; CHECK-NEXT:    [[IND_END2:%.*]] = getelementptr half, half* [[INPUT:%.*]], i32 [[N_VEC]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <8 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr half, half* [[INPUT]], i32 [[TMP0]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <8 x i32> poison, i32 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <8 x i32> [[BROADCAST_SPLATINSERT]], <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = add <8 x i32> [[BROADCAST_SPLAT]], <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <8 x i32> [[VEC_IV]], i32 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 [[TMP1]], i32 [[N]])
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr half, half* [[NEXT_GEP]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast half* [[TMP2]] to <8 x half>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* [[TMP3]], i32 2, <8 x i1> [[ACTIVE_LANE_MASK]], <8 x half> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = fadd fast <8 x half> [[WIDE_MASKED_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP5]] = select <8 x i1> [[ACTIVE_LANE_MASK]], <8 x half> [[TMP4]], <8 x half> [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 8
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP7:%.*]] = call fast half @llvm.vector.reduce.fadd.v8f16(half 0xH8000, <8 x half> [[TMP5]])
; CHECK-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[N]], [[WHILE_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi half* [ [[IND_END2]], [[MIDDLE_BLOCK]] ], [ [[INPUT]], [[WHILE_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi half [ 0xH0000, [[WHILE_BODY_PREHEADER]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[BLKCNT_09:%.*]] = phi i32 [ [[DEC:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[SUM_08:%.*]] = phi half [ [[ADD:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INPUT_ADDR_07:%.*]] = phi half* [ [[INCDEC_PTR:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds half, half* [[INPUT_ADDR_07]], i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load half, half* [[INPUT_ADDR_07]], align 2
; CHECK-NEXT:    [[ADD]] = fadd fast half [[TMP8]], [[SUM_08]]
; CHECK-NEXT:    [[DEC]] = add i32 [[BLKCNT_09]], -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[DEC]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[WHILE_END_LOOPEXIT]], label [[WHILE_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       while.end.loopexit:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi half [ [[ADD]], [[WHILE_BODY]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[WHILE_END]]
; CHECK:       while.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi half [ 0xH0000, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[WHILE_END_LOOPEXIT]] ]
; CHECK-NEXT:    [[CONV:%.*]] = uitofp i32 [[N]] to half
; CHECK-NEXT:    [[DIV:%.*]] = fdiv fast half [[SUM_0_LCSSA]], [[CONV]]
; CHECK-NEXT:    store half [[DIV]], half* [[OUTPUT:%.*]], align 2
; CHECK-NEXT:    ret void
;
entry:
  %cmp6 = icmp eq i32 %N, 0
  br i1 %cmp6, label %while.end, label %while.body.preheader

while.body.preheader:                             ; preds = %entry
  br label %while.body

while.body:                                       ; preds = %while.body.preheader, %while.body
  %blkCnt.09 = phi i32 [ %dec, %while.body ], [ %N, %while.body.preheader ]
  %sum.08 = phi half [ %add, %while.body ], [ 0.000000e+00, %while.body.preheader ]
  %Input.addr.07 = phi half* [ %incdec.ptr, %while.body ], [ %Input, %while.body.preheader ]
  %incdec.ptr = getelementptr inbounds half, half* %Input.addr.07, i32 1
  %0 = load half, half* %Input.addr.07, align 2
  %add = fadd fast half %0, %sum.08
  %dec = add i32 %blkCnt.09, -1
  %cmp = icmp eq i32 %dec, 0
  br i1 %cmp, label %while.end.loopexit, label %while.body

while.end.loopexit:                               ; preds = %while.body
  %add.lcssa = phi half [ %add, %while.body ]
  br label %while.end

while.end:                                        ; preds = %while.end.loopexit, %entry
  %sum.0.lcssa = phi half [ 0.000000e+00, %entry ], [ %add.lcssa, %while.end.loopexit ]
  %conv = uitofp i32 %N to half
  %div = fdiv fast half %sum.0.lcssa, %conv
  store half %div, half* %Output, align 2
  ret void
}

define dso_local void @mixed_f32_i32_reduction(float* nocapture readonly %fInput, i32* nocapture readonly %iInput, i32 %N, float* nocapture %fOutput, i32* nocapture %iOutput) {
; CHECK-LABEL: @mixed_f32_i32_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP15:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP15]], label [[WHILE_END:%.*]], label [[WHILE_BODY_PREHEADER:%.*]]
; CHECK:       while.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = sub i32 [[N]], [[N_VEC]]
; CHECK-NEXT:    [[IND_END2:%.*]] = getelementptr float, float* [[FINPUT:%.*]], i32 [[N_VEC]]
; CHECK-NEXT:    [[IND_END4:%.*]] = getelementptr i32, i32* [[IINPUT:%.*]], i32 [[N_VEC]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[TMP7:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI5:%.*]] = phi <4 x float> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP11:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr float, float* [[FINPUT]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[NEXT_GEP6:%.*]] = getelementptr i32, i32* [[IINPUT]], i32 [[TMP1]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = add <4 x i32> [[BROADCAST_SPLAT]], <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x i32> [[VEC_IV]], i32 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP2]], i32 [[N]])
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i32, i32* [[NEXT_GEP6]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP3]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP4]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP5:%.*]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> [[WIDE_MASKED_LOAD]], <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    [[TMP7]] = add i32 [[TMP6]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr float, float* [[NEXT_GEP]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[TMP8]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD7:%.*]] = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* [[TMP9]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x float> poison)
; CHECK-NEXT:    [[TMP10:%.*]] = fadd fast <4 x float> [[WIDE_MASKED_LOAD7]], [[VEC_PHI5]]
; CHECK-NEXT:    [[TMP11]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x float> [[TMP10]], <4 x float> [[VEC_PHI5]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP13:%.*]] = call fast float @llvm.vector.reduce.fadd.v4f32(float -0.000000e+00, <4 x float> [[TMP11]])
; CHECK-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[N]], [[WHILE_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi float* [ [[IND_END2]], [[MIDDLE_BLOCK]] ], [ [[FINPUT]], [[WHILE_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL3:%.*]] = phi i32* [ [[IND_END4]], [[MIDDLE_BLOCK]] ], [ [[IINPUT]], [[WHILE_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[WHILE_BODY_PREHEADER]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX8:%.*]] = phi float [ 0.000000e+00, [[WHILE_BODY_PREHEADER]] ], [ [[TMP13]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[BLKCNT_020:%.*]] = phi i32 [ [[DEC:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ISUM_019:%.*]] = phi i32 [ [[ADD2:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[FSUM_018:%.*]] = phi float [ [[ADD:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX8]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[FINPUT_ADDR_017:%.*]] = phi float* [ [[INCDEC_PTR:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[IINPUT_ADDR_016:%.*]] = phi i32* [ [[INCDEC_PTR1:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL3]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds float, float* [[FINPUT_ADDR_017]], i32 1
; CHECK-NEXT:    [[INCDEC_PTR1]] = getelementptr inbounds i32, i32* [[IINPUT_ADDR_016]], i32 1
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[IINPUT_ADDR_016]], align 4
; CHECK-NEXT:    [[ADD2]] = add nsw i32 [[TMP14]], [[ISUM_019]]
; CHECK-NEXT:    [[TMP15:%.*]] = load float, float* [[FINPUT_ADDR_017]], align 4
; CHECK-NEXT:    [[ADD]] = fadd fast float [[TMP15]], [[FSUM_018]]
; CHECK-NEXT:    [[DEC]] = add i32 [[BLKCNT_020]], -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[DEC]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[WHILE_END_LOOPEXIT]], label [[WHILE_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       while.end.loopexit:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi float [ [[ADD]], [[WHILE_BODY]] ], [ [[TMP13]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[ADD2_LCSSA:%.*]] = phi i32 [ [[ADD2]], [[WHILE_BODY]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[PHITMP:%.*]] = sitofp i32 [[ADD2_LCSSA]] to float
; CHECK-NEXT:    br label [[WHILE_END]]
; CHECK:       while.end:
; CHECK-NEXT:    [[FSUM_0_LCSSA:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[WHILE_END_LOOPEXIT]] ]
; CHECK-NEXT:    [[ISUM_0_LCSSA:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[PHITMP]], [[WHILE_END_LOOPEXIT]] ]
; CHECK-NEXT:    [[CONV:%.*]] = uitofp i32 [[N]] to float
; CHECK-NEXT:    [[DIV:%.*]] = fdiv fast float [[FSUM_0_LCSSA]], [[CONV]]
; CHECK-NEXT:    store float [[DIV]], float* [[FOUTPUT:%.*]], align 4
; CHECK-NEXT:    [[DIV5:%.*]] = fdiv fast float [[ISUM_0_LCSSA]], [[CONV]]
; CHECK-NEXT:    [[CONV6:%.*]] = fptosi float [[DIV5]] to i32
; CHECK-NEXT:    store i32 [[CONV6]], i32* [[IOUTPUT:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %cmp15 = icmp eq i32 %N, 0
  br i1 %cmp15, label %while.end, label %while.body.preheader

while.body.preheader:
  br label %while.body

while.body:
  %blkCnt.020 = phi i32 [ %dec, %while.body ], [ %N, %while.body.preheader ]
  %isum.019 = phi i32 [ %add2, %while.body ], [ 0, %while.body.preheader ]
  %fsum.018 = phi float [ %add, %while.body ], [ 0.000000e+00, %while.body.preheader ]
  %fInput.addr.017 = phi float* [ %incdec.ptr, %while.body ], [ %fInput, %while.body.preheader ]
  %iInput.addr.016 = phi i32* [ %incdec.ptr1, %while.body ], [ %iInput, %while.body.preheader ]
  %incdec.ptr = getelementptr inbounds float, float* %fInput.addr.017, i32 1
  %incdec.ptr1 = getelementptr inbounds i32, i32* %iInput.addr.016, i32 1
  %0 = load i32, i32* %iInput.addr.016, align 4
  %add2 = add nsw i32 %0, %isum.019
  %1 = load float, float* %fInput.addr.017, align 4
  %add = fadd fast float %1, %fsum.018
  %dec = add i32 %blkCnt.020, -1
  %cmp = icmp eq i32 %dec, 0
  br i1 %cmp, label %while.end.loopexit, label %while.body

while.end.loopexit:
  %add.lcssa = phi float [ %add, %while.body ]
  %add2.lcssa = phi i32 [ %add2, %while.body ]
  %phitmp = sitofp i32 %add2.lcssa to float
  br label %while.end

while.end:
  %fsum.0.lcssa = phi float [ 0.000000e+00, %entry ], [ %add.lcssa, %while.end.loopexit ]
  %isum.0.lcssa = phi float [ 0.000000e+00, %entry ], [ %phitmp, %while.end.loopexit ]
  %conv = uitofp i32 %N to float
  %div = fdiv fast float %fsum.0.lcssa, %conv
  store float %div, float* %fOutput, align 4
  %div5 = fdiv fast float %isum.0.lcssa, %conv
  %conv6 = fptosi float %div5 to i32
  store i32 %conv6, i32* %iOutput, align 4
  ret void
}

define dso_local i32 @i32_mul_reduction(i32* noalias nocapture readonly %B, i32 %N) {
; CHECK-LABEL: @i32_mul_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP6]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, [[VECTOR_PH]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = mul <4 x i32> [[WIDE_MASKED_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP5]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> [[TMP4]], <4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.vector.reduce.mul.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    br i1 true, label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 1, [[FOR_BODY_PREHEADER]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[MUL_LCSSA:%.*]] = phi i32 [ [[MUL:%.*]], [[FOR_BODY]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[S_0_LCSSA:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[MUL_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[S_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[S_07:%.*]] = phi i32 [ [[MUL]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[I_08]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[MUL]] = mul nsw i32 [[TMP8]], [[S_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP11:![0-9]+]]
;
entry:
  %cmp6 = icmp sgt i32 %N, 0
  br i1 %cmp6, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup.loopexit:
  %mul.lcssa = phi i32 [ %mul, %for.body ]
  br label %for.cond.cleanup

for.cond.cleanup:
  %S.0.lcssa = phi i32 [ 1, %entry ], [ %mul.lcssa, %for.cond.cleanup.loopexit ]
  ret i32 %S.0.lcssa

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %S.07 = phi i32 [ %mul, %for.body ], [ 1, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %B, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %mul = mul nsw i32 %0, %S.07
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %N
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}

define dso_local i32 @i32_or_reduction(i32* noalias nocapture readonly %B, i32 %N) {
; CHECK-LABEL: @i32_or_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP6]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ <i32 1, i32 0, i32 0, i32 0>, [[VECTOR_PH]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = or <4 x i32> [[WIDE_MASKED_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP5]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> [[TMP4]], <4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    br i1 true, label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 1, [[FOR_BODY_PREHEADER]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[OR_LCSSA:%.*]] = phi i32 [ [[OR:%.*]], [[FOR_BODY]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[S_0_LCSSA:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[OR_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[S_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[S_07:%.*]] = phi i32 [ [[OR]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[I_08]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[OR]] = or i32 [[TMP8]], [[S_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP13:![0-9]+]]
;
entry:
  %cmp6 = icmp sgt i32 %N, 0
  br i1 %cmp6, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %or.lcssa = phi i32 [ %or, %for.body ]
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %S.0.lcssa = phi i32 [ 1, %entry ], [ %or.lcssa, %for.cond.cleanup.loopexit ]
  ret i32 %S.0.lcssa

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %S.07 = phi i32 [ %or, %for.body ], [ 1, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %B, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %or = or i32 %0, %S.07
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %N
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}

define dso_local i32 @i32_and_reduction(i32* noalias nocapture readonly %A, i32 %N, i32 %S) {
; CHECK-LABEL: @i32_and_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, i32 [[S:%.*]], i32 0
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ [[TMP0]], [[VECTOR_PH]] ], [ [[TMP6:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP1]], i32 [[N]])
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP3]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP4]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP5:%.*]] = and <4 x i32> [[WIDE_MASKED_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP6]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> [[TMP5]], <4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP14:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[TMP6]])
; CHECK-NEXT:    br i1 true, label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ [[S]], [[FOR_BODY_PREHEADER]] ], [ [[TMP8]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[AND_LCSSA:%.*]] = phi i32 [ [[AND:%.*]], [[FOR_BODY]] ], [ [[TMP8]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[S_ADDR_0_LCSSA:%.*]] = phi i32 [ [[S]], [[ENTRY:%.*]] ], [ [[AND_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[S_ADDR_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_07:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[S_ADDR_06:%.*]] = phi i32 [ [[AND]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[I_07]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[AND]] = and i32 [[TMP9]], [[S_ADDR_06]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_07]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP15:![0-9]+]]
;
entry:
  %cmp5 = icmp sgt i32 %N, 0
  br i1 %cmp5, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %and.lcssa = phi i32 [ %and, %for.body ]
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %S.addr.0.lcssa = phi i32 [ %S, %entry ], [ %and.lcssa, %for.cond.cleanup.loopexit ]
  ret i32 %S.addr.0.lcssa

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %S.addr.06 = phi i32 [ %and, %for.body ], [ %S, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %i.07
  %0 = load i32, i32* %arrayidx, align 4
  %and = and i32 %0, %S.addr.06
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond = icmp eq i32 %inc, %N
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}
