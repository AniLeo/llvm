; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; This is the loop in c++ being vectorize in this file with
;experimental.vector.reverse
;  #pragma clang loop vectorize_width(8, scalable)
;  for (int i = N-1; i >= 0; --i)
;    a[i] = b[i] + 1.0;

; RUN: opt -loop-vectorize -dce -instcombine -mtriple aarch64-linux-gnu -S < %s | FileCheck %s

define void @vector_reverse_f64(i64 %N, double* %a, double* %b) #0{
; CHECK-LABEL: @vector_reverse_f64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP7:%.*]] = icmp sgt i64 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP7]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 3
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ugt i64 [[TMP1]], [[N]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr double, double* [[A:%.*]], i64 [[N]]
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr double, double* [[B:%.*]], i64 [[N]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt double* [[SCEVGEP4]], [[A]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt double* [[SCEVGEP]], [[B]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i64 [[INDEX]], -1
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[TMP4]], [[N]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[DOTNEG:%.*]] = mul i32 [[TMP7]], -8
; CHECK-NEXT:    [[TMP8:%.*]] = or i32 [[DOTNEG]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds double, double* [[TMP6]], i64 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast double* [[TMP10]] to <vscale x 8 x double>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 8 x double>, <vscale x 8 x double>* [[TMP11]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP13:%.*]] = fadd <vscale x 8 x double> [[WIDE_LOAD]], shufflevector (<vscale x 8 x double> insertelement (<vscale x 8 x double> poison, double 1.000000e+00, i32 0), <vscale x 8 x double> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP14:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[DOTNEG7:%.*]] = mul i32 [[TMP14]], -8
; CHECK-NEXT:    [[TMP15:%.*]] = or i32 [[DOTNEG7]], 1
; CHECK-NEXT:    [[TMP16:%.*]] = sext i32 [[TMP15]] to i64
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds double, double* [[TMP12]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast double* [[TMP17]] to <vscale x 8 x double>*
; CHECK-NEXT:    store <vscale x 8 x double> [[TMP13]], <vscale x 8 x double>* [[TMP18]], align 8, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[TMP19:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP20:%.*]] = shl i64 [[TMP19]], 3
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP20]]
; CHECK-NEXT:    [[TMP21:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP21]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_MOD_VF]], [[MIDDLE_BLOCK]] ], [ [[N]], [[FOR_BODY_PREHEADER]] ], [ [[N]], [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08_IN:%.*]] = phi i64 [ [[I_08:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[I_08]] = add nsw i64 [[I_08_IN]], -1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP22:%.*]] = load double, double* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[TMP22]], 1.000000e+00
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[I_08]]
; CHECK-NEXT:    store double [[ADD]], double* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i64 [[I_08_IN]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_COND_CLEANUP_LOOPEXIT]], !llvm.loop [[LOOP8:![0-9]+]]
;
entry:
  %cmp7 = icmp sgt i64 %N, 0
  br i1 %cmp7, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.08.in = phi i64 [ %i.08, %for.body ], [ %N, %entry ]
  %i.08 = add nsw i64 %i.08.in, -1
  %arrayidx = getelementptr inbounds double, double* %b, i64 %i.08
  %0 = load double, double* %arrayidx, align 8
  %add = fadd double %0, 1.000000e+00
  %arrayidx1 = getelementptr inbounds double, double* %a, i64 %i.08
  store double %add, double* %arrayidx1, align 8
  %cmp = icmp sgt i64 %i.08.in, 1
  br i1 %cmp, label %for.body, label %for.cond.cleanup, !llvm.loop !0
}


define void @vector_reverse_i64(i64 %N, i64* %a, i64* %b) #0 {
; CHECK-LABEL: @vector_reverse_i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP8:%.*]] = icmp sgt i64 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP8]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 3
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ugt i64 [[TMP1]], [[N]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i64, i64* [[A:%.*]], i64 [[N]]
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i64, i64* [[B:%.*]], i64 [[N]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i64* [[SCEVGEP4]], [[A]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i64* [[SCEVGEP]], [[B]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i64 [[INDEX]], -1
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[TMP4]], [[N]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i64, i64* [[B]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[DOTNEG:%.*]] = mul i32 [[TMP7]], -8
; CHECK-NEXT:    [[TMP8:%.*]] = or i32 [[DOTNEG]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i64, i64* [[TMP6]], i64 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i64* [[TMP10]] to <vscale x 8 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 8 x i64>, <vscale x 8 x i64>* [[TMP11]], align 8, !alias.scope !9
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP13:%.*]] = add <vscale x 8 x i64> [[WIDE_LOAD]], shufflevector (<vscale x 8 x i64> insertelement (<vscale x 8 x i64> poison, i64 1, i32 0), <vscale x 8 x i64> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP14:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[DOTNEG7:%.*]] = mul i32 [[TMP14]], -8
; CHECK-NEXT:    [[TMP15:%.*]] = or i32 [[DOTNEG7]], 1
; CHECK-NEXT:    [[TMP16:%.*]] = sext i32 [[TMP15]] to i64
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i64, i64* [[TMP12]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i64* [[TMP17]] to <vscale x 8 x i64>*
; CHECK-NEXT:    store <vscale x 8 x i64> [[TMP13]], <vscale x 8 x i64>* [[TMP18]], align 8, !alias.scope !12, !noalias !9
; CHECK-NEXT:    [[TMP19:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP20:%.*]] = shl i64 [[TMP19]], 3
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP20]]
; CHECK-NEXT:    [[TMP21:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP21]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP14:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_MOD_VF]], [[MIDDLE_BLOCK]] ], [ [[N]], [[FOR_BODY_PREHEADER]] ], [ [[N]], [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_09_IN:%.*]] = phi i64 [ [[I_09:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[I_09]] = add nsw i64 [[I_09_IN]], -1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[B]], i64 [[I_09]]
; CHECK-NEXT:    [[TMP22:%.*]] = load i64, i64* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[ADD:%.*]] = add i64 [[TMP22]], 1
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[I_09]]
; CHECK-NEXT:    store i64 [[ADD]], i64* [[ARRAYIDX2]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i64 [[I_09_IN]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_COND_CLEANUP_LOOPEXIT]], !llvm.loop [[LOOP15:![0-9]+]]
;
entry:
  %cmp8 = icmp sgt i64 %N, 0
  br i1 %cmp8, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.09.in = phi i64 [ %i.09, %for.body ], [ %N, %entry ]
  %i.09 = add nsw i64 %i.09.in, -1
  %arrayidx = getelementptr inbounds i64, i64* %b, i64 %i.09
  %0 = load i64, i64* %arrayidx, align 8
  %add = add i64 %0, 1
  %arrayidx2 = getelementptr inbounds i64, i64* %a, i64 %i.09
  store i64 %add, i64* %arrayidx2, align 8
  %cmp = icmp sgt i64 %i.09.in, 1
  br i1 %cmp, label %for.body, label %for.cond.cleanup, !llvm.loop !0
}

attributes #0 = { "target-cpu"="generic" "target-features"="+neon,+sve" }

!0 = distinct !{!0, !1, !2, !3, !4}
!1 = !{!"llvm.loop.mustprogress"}
!2 = !{!"llvm.loop.vectorize.width", i32 8}
!3 = !{!"llvm.loop.vectorize.scalable.enable", i1 true}
!4 = !{!"llvm.loop.vectorize.enable", i1 true}

