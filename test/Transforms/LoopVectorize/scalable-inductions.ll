; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -scalable-vectorization=on -force-target-instruction-cost=1 -force-target-supports-scalable-vectors -dce -instcombine < %s -S | FileCheck %s

; Test that we can add on the induction variable
;   for (long long i = 0; i < n; i++) {
;     a[i] = b[i] + i;
;   }
; with an unroll factor (interleave count) of 2.

define void @add_ind64_unrolled(i64* noalias nocapture %a, i64* noalias nocapture readonly %b, i64 %n) {
; CHECK-LABEL: @add_ind64_unrolled(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 2
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ugt i64 [[TMP1]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 2
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = call <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
; CHECK-NEXT:    [[DOTSPLATINSERT2:%.*]] = insertelement <vscale x 2 x i64> poison, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[DOTSPLAT3:%.*]] = shufflevector <vscale x 2 x i64> [[DOTSPLATINSERT2]], <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = add <vscale x 2 x i64> [[DOTSPLAT3]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP7:%.*]] = shl i64 [[TMP6]], 1
; CHECK-NEXT:    [[DOTSPLATINSERT4:%.*]] = insertelement <vscale x 2 x i64> poison, i64 [[TMP7]], i32 0
; CHECK-NEXT:    [[DOTSPLAT5:%.*]] = shufflevector <vscale x 2 x i64> [[DOTSPLATINSERT4]], <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = add <vscale x 2 x i64> [[DOTSPLAT5]], [[TMP4]]
; CHECK-NEXT:    [[TMP9:%.*]] = add <vscale x 2 x i64> [[DOTSPLAT3]], [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i64, i64* [[B:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i64* [[TMP10]] to <vscale x 2 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x i64>, <vscale x 2 x i64>* [[TMP11]], align 8
; CHECK-NEXT:    [[TMP12:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP13:%.*]] = shl i32 [[TMP12]], 1
; CHECK-NEXT:    [[TMP14:%.*]] = sext i32 [[TMP13]] to i64
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds i64, i64* [[TMP10]], i64 [[TMP14]]
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast i64* [[TMP15]] to <vscale x 2 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD6:%.*]] = load <vscale x 2 x i64>, <vscale x 2 x i64>* [[TMP16]], align 8
; CHECK-NEXT:    [[TMP17:%.*]] = add nsw <vscale x 2 x i64> [[WIDE_LOAD]], [[TMP5]]
; CHECK-NEXT:    [[TMP18:%.*]] = add nsw <vscale x 2 x i64> [[WIDE_LOAD6]], [[TMP9]]
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr inbounds i64, i64* [[A:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast i64* [[TMP19]] to <vscale x 2 x i64>*
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP17]], <vscale x 2 x i64>* [[TMP20]], align 8
; CHECK-NEXT:    [[TMP21:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP22:%.*]] = shl i32 [[TMP21]], 1
; CHECK-NEXT:    [[TMP23:%.*]] = sext i32 [[TMP22]] to i64
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds i64, i64* [[TMP19]], i64 [[TMP23]]
; CHECK-NEXT:    [[TMP25:%.*]] = bitcast i64* [[TMP24]] to <vscale x 2 x i64>*
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP18]], <vscale x 2 x i64>* [[TMP25]], align 8
; CHECK-NEXT:    [[TMP26:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP27:%.*]] = shl i64 [[TMP26]], 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP27]]
; CHECK-NEXT:    [[TMP28:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP28]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[B]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP29:%.*]] = load i64, i64* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[TMP29]], [[I_08]]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[I_08]]
; CHECK-NEXT:    store i64 [[ADD]], i64* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i64, i64* %b, i64 %i.08
  %0 = load i64, i64* %arrayidx, align 8
  %add = add nsw i64 %0, %i.08
  %arrayidx1 = getelementptr inbounds i64, i64* %a, i64 %i.08
  store i64 %add, i64* %arrayidx1, align 8
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %exit, label %for.body, !llvm.loop !0

exit:                                 ; preds = %for.body
  ret void
}


; Same as above, except we test with a vectorisation factor of (1, scalable)

define void @add_ind64_unrolled_nxv1i64(i64* noalias nocapture %a, i64* noalias nocapture readonly %b, i64 %n) {
; CHECK-LABEL: @add_ind64_unrolled_nxv1i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ugt i64 [[TMP1]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 1
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = call <vscale x 1 x i64> @llvm.experimental.stepvector.nxv1i64()
; CHECK-NEXT:    [[DOTSPLATINSERT2:%.*]] = insertelement <vscale x 1 x i64> poison, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[DOTSPLAT3:%.*]] = shufflevector <vscale x 1 x i64> [[DOTSPLATINSERT2]], <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = add <vscale x 1 x i64> [[DOTSPLAT3]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[DOTSPLATINSERT4:%.*]] = insertelement <vscale x 1 x i64> poison, i64 [[TMP6]], i32 0
; CHECK-NEXT:    [[DOTSPLAT5:%.*]] = shufflevector <vscale x 1 x i64> [[DOTSPLATINSERT4]], <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP7:%.*]] = add <vscale x 1 x i64> [[DOTSPLAT5]], [[TMP4]]
; CHECK-NEXT:    [[TMP8:%.*]] = add <vscale x 1 x i64> [[DOTSPLAT3]], [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i64, i64* [[B:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i64* [[TMP9]] to <vscale x 1 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 1 x i64>, <vscale x 1 x i64>* [[TMP10]], align 8
; CHECK-NEXT:    [[TMP11:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP12:%.*]] = sext i32 [[TMP11]] to i64
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i64, i64* [[TMP9]], i64 [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast i64* [[TMP13]] to <vscale x 1 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD6:%.*]] = load <vscale x 1 x i64>, <vscale x 1 x i64>* [[TMP14]], align 8
; CHECK-NEXT:    [[TMP15:%.*]] = add nsw <vscale x 1 x i64> [[WIDE_LOAD]], [[TMP5]]
; CHECK-NEXT:    [[TMP16:%.*]] = add nsw <vscale x 1 x i64> [[WIDE_LOAD6]], [[TMP8]]
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i64, i64* [[A:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i64* [[TMP17]] to <vscale x 1 x i64>*
; CHECK-NEXT:    store <vscale x 1 x i64> [[TMP15]], <vscale x 1 x i64>* [[TMP18]], align 8
; CHECK-NEXT:    [[TMP19:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP20:%.*]] = sext i32 [[TMP19]] to i64
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds i64, i64* [[TMP17]], i64 [[TMP20]]
; CHECK-NEXT:    [[TMP22:%.*]] = bitcast i64* [[TMP21]] to <vscale x 1 x i64>*
; CHECK-NEXT:    store <vscale x 1 x i64> [[TMP16]], <vscale x 1 x i64>* [[TMP22]], align 8
; CHECK-NEXT:    [[TMP23:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP24:%.*]] = shl i64 [[TMP23]], 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP24]]
; CHECK-NEXT:    [[TMP25:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP25]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[B]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP26:%.*]] = load i64, i64* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[TMP26]], [[I_08]]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[I_08]]
; CHECK-NEXT:    store i64 [[ADD]], i64* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i64, i64* %b, i64 %i.08
  %0 = load i64, i64* %arrayidx, align 8
  %add = add nsw i64 %0, %i.08
  %arrayidx1 = getelementptr inbounds i64, i64* %a, i64 %i.08
  store i64 %add, i64* %arrayidx1, align 8
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %exit, label %for.body, !llvm.loop !9

exit:                                 ; preds = %for.body
  ret void
}


; Test that we can vectorize a separate induction variable (not used for the branch)
;   int r = 0;
;   for (long long i = 0; i < n; i++) {
;     a[i] = r;
;     r += 2;
;   }
; with an unroll factor (interleave count) of 1.


define void @add_unique_ind32(i32* noalias nocapture %a, i64 %n) {
; CHECK-LABEL: @add_unique_ind32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 2
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ugt i64 [[TMP1]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 2
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[IND_END:%.*]] = shl i32 [[CAST_CRD]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = call <vscale x 4 x i32> @llvm.experimental.stepvector.nxv4i32()
; CHECK-NEXT:    [[TMP5:%.*]] = shl <vscale x 4 x i32> [[TMP4]], shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i32 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP7:%.*]] = shl i32 [[TMP6]], 3
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[TMP7]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 4 x i32> [[DOTSPLATINSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <vscale x 4 x i32> [ [[TMP5]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <vscale x 4 x i32>*
; CHECK-NEXT:    store <vscale x 4 x i32> [[VEC_IND]], <vscale x 4 x i32>* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP11:%.*]] = shl i64 [[TMP10]], 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP11]]
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <vscale x 4 x i32> [[VEC_IND]], [[DOTSPLAT]]
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[R_07:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[I_08]]
; CHECK-NEXT:    store i32 [[R_07]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nuw nsw i32 [[R_07]], 2
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %r.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %i.08
  store i32 %r.07, i32* %arrayidx, align 4
  %add = add nuw nsw i32 %r.07, 2
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %exit, label %for.body, !llvm.loop !6

exit:                                 ; preds = %for.body
  ret void
}


; Test that we can vectorize a separate FP induction variable (not used for the branch)
;   float r = 0;
;   for (long long i = 0; i < n; i++) {
;     a[i] = r;
;     r += 2;
;   }
; with an unroll factor (interleave count) of 1.

define void @add_unique_indf32(float* noalias nocapture %a, i64 %n) {
; CHECK-LABEL: @add_unique_indf32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 2
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ugt i64 [[TMP1]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 2
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[CAST_CRD:%.*]] = sitofp i64 [[N_VEC]] to float
; CHECK-NEXT:    [[TMP4:%.*]] = fmul float [[CAST_CRD]], 2.000000e+00
; CHECK-NEXT:    [[IND_END:%.*]] = fadd float [[TMP4]], 0.000000e+00
; CHECK-NEXT:    [[TMP5:%.*]] = call <vscale x 4 x i32> @llvm.experimental.stepvector.nxv4i32()
; CHECK-NEXT:    [[TMP6:%.*]] = uitofp <vscale x 4 x i32> [[TMP5]] to <vscale x 4 x float>
; CHECK-NEXT:    [[TMP7:%.*]] = fmul <vscale x 4 x float> [[TMP6]], shufflevector (<vscale x 4 x float> insertelement (<vscale x 4 x float> poison, float 2.000000e+00, i32 0), <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[INDUCTION:%.*]] = fadd <vscale x 4 x float> [[TMP7]], zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP9:%.*]] = shl i32 [[TMP8]], 2
; CHECK-NEXT:    [[TMP10:%.*]] = uitofp i32 [[TMP9]] to float
; CHECK-NEXT:    [[TMP11:%.*]] = fmul float [[TMP10]], 2.000000e+00
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x float> poison, float [[TMP11]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 4 x float> [[DOTSPLATINSERT]], <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <vscale x 4 x float> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast float* [[TMP12]] to <vscale x 4 x float>*
; CHECK-NEXT:    store <vscale x 4 x float> [[VEC_IND]], <vscale x 4 x float>* [[TMP13]], align 4
; CHECK-NEXT:    [[TMP14:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP15:%.*]] = shl i64 [[TMP14]], 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP15]]
; CHECK-NEXT:    [[VEC_IND_NEXT]] = fadd <vscale x 4 x float> [[VEC_IND]], [[DOTSPLAT]]
; CHECK-NEXT:    [[TMP16:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP16]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi float [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0.000000e+00, [[ENTRY]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[R_07:%.*]] = phi float [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[I_08]]
; CHECK-NEXT:    store float [[R_07]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = fadd float [[R_07]], 2.000000e+00
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %r.07 = phi float [ %add, %for.body ], [ 0.000000e+00, %entry ]
  %arrayidx = getelementptr inbounds float, float* %a, i64 %i.08
  store float %r.07, float* %arrayidx, align 4
  %add = fadd float %r.07, 2.000000e+00
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %exit, label %for.body, !llvm.loop !6

exit:                                 ; preds = %for.body
  ret void
}

!0 = distinct !{!0, !1, !2, !3, !4, !5}
!1 = !{!"llvm.loop.mustprogress"}
!2 = !{!"llvm.loop.vectorize.width", i32 2}
!3 = !{!"llvm.loop.vectorize.scalable.enable", i1 true}
!4 = !{!"llvm.loop.interleave.count", i32 2}
!5 = !{!"llvm.loop.vectorize.enable", i1 true}
!6 = distinct !{!6, !1, !7, !3, !8, !5}
!7 = !{!"llvm.loop.vectorize.width", i32 4}
!8 = !{!"llvm.loop.interleave.count", i32 1}
!9 = distinct !{!9, !1, !10, !3, !4, !5}
!10 = !{!"llvm.loop.vectorize.width", i32 1}
