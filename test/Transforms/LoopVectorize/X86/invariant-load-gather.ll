; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -S -mattr=avx512f -instcombine < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @inv_load_conditional(i32* %a, i64 %n, i32* %b, i32 %k) {
; CHECK-LABEL: @inv_load_conditional(
; CHECK-NEXT:  iter.check:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i64 [[N]], i64 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 8
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[A4:%.*]] = bitcast i32* [[A:%.*]] to i8*
; CHECK-NEXT:    [[B1:%.*]] = bitcast i32* [[B:%.*]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX2:%.*]] = select i1 [[TMP1]], i64 [[N]], i64 1
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[B]], i64 [[SMAX2]]
; CHECK-NEXT:    [[UGLYGEP:%.*]] = getelementptr i8, i8* [[A4]], i64 1
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i8* [[UGLYGEP]], [[B1]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i32* [[SCEVGEP]], [[A]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[VEC_EPILOG_SCALAR_PH]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK5:%.*]] = icmp ult i64 [[SMAX]], 16
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK5]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775792
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <16 x i32*> undef, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <16 x i32*> [[BROADCAST_SPLATINSERT]], <16 x i32*> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT6:%.*]] = insertelement <16 x i32> undef, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT7:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT6]], <16 x i32> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne <16 x i32*> [[BROADCAST_SPLAT]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    store <16 x i32> [[BROADCAST_SPLAT7]], <16 x i32>* [[TMP4]], align 4, !alias.scope !0, !noalias !3
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP5:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <16 x i32> @llvm.masked.gather.v16i32.v16p0i32(<16 x i32*> [[BROADCAST_SPLAT]], i32 4, <16 x i1> [[TMP3]], <16 x i32> undef), !alias.scope !3
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <16 x i1> [[TMP3]], <16 x i32> [[WIDE_MASKED_GATHER]], <16 x i32> <i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 1>
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <16 x i32> [[PREDPHI]], i32 15
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = and i64 [[SMAX]], 8
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK_NOT_NOT:%.*]] = icmp eq i64 [[N_VEC_REMAINING]], 0
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK_NOT_NOT]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX9:%.*]] = select i1 [[TMP7]], i64 [[N]], i64 1
; CHECK-NEXT:    [[N_VEC11:%.*]] = and i64 [[SMAX9]], 9223372036854775800
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT16:%.*]] = insertelement <8 x i32*> undef, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT17:%.*]] = shufflevector <8 x i32*> [[BROADCAST_SPLATINSERT16]], <8 x i32*> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT18:%.*]] = insertelement <8 x i32> undef, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT19:%.*]] = shufflevector <8 x i32> [[BROADCAST_SPLATINSERT18]], <8 x i32> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX12:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT13:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX12]]
; CHECK-NEXT:    [[TMP9:%.*]] = icmp ne <8 x i32*> [[BROADCAST_SPLAT17]], zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i32* [[TMP8]] to <8 x i32>*
; CHECK-NEXT:    store <8 x i32> [[BROADCAST_SPLAT19]], <8 x i32>* [[TMP10]], align 4
; CHECK-NEXT:    [[INDEX_NEXT13]] = add i64 [[INDEX12]], 8
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT13]], [[N_VEC11]]
; CHECK-NEXT:    br i1 [[TMP11]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP7:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[WIDE_MASKED_GATHER20:%.*]] = call <8 x i32> @llvm.masked.gather.v8i32.v8p0i32(<8 x i32*> [[BROADCAST_SPLAT17]], i32 4, <8 x i1> [[TMP9]], <8 x i32> undef)
; CHECK-NEXT:    [[PREDPHI21:%.*]] = select <8 x i1> [[TMP9]], <8 x i32> [[WIDE_MASKED_GATHER20]], <8 x i32> <i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 1>
; CHECK-NEXT:    [[CMP_N14:%.*]] = icmp eq i64 [[SMAX9]], [[N_VEC11]]
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <8 x i32> [[PREDPHI21]], i32 7
; CHECK-NEXT:    br i1 [[CMP_N14]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC11]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MEMCHECK]] ], [ 0, [[ITER_CHECK:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[LATCH:%.*]] ], [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i32* [[A]], null
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[TMP1]], align 4
; CHECK-NEXT:    br i1 [[CMP_NOT]], label [[LATCH]], label [[COND_LOAD:%.*]]
; CHECK:       cond_load:
; CHECK-NEXT:    [[ALOAD:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[A_LCSSA:%.*]] = phi i32 [ [[ALOAD]], [[COND_LOAD]] ], [ 1, [[FOR_BODY]] ]
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT]], [[LOOP9:!llvm.loop !.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    [[A_LCSSA_LCSSA8:%.*]] = phi i32 [ [[A_LCSSA]], [[LATCH]] ], [ [[TMP12]], [[VEC_EPILOG_MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[A_LCSSA_LCSSA:%.*]] = phi i32 [ [[TMP6]], [[MIDDLE_BLOCK]] ], [ [[A_LCSSA_LCSSA8]], [[FOR_END_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[A_LCSSA_LCSSA]]
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %latch ], [ 0, %entry ]
  %tmp1 = getelementptr inbounds i32, i32* %b, i64 %i
  %tmp2 = load i32, i32* %tmp1, align 8
  %cmp = icmp ne i32* %a, null
  store i32 %ntrunc, i32* %tmp1
  br i1 %cmp, label %cond_load, label %latch

cond_load:
  %aload = load i32, i32* %a, align 4
  br label %latch

latch:
  %a.lcssa = phi i32 [ %aload, %cond_load ], [ 1, %for.body ]
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret i32 %a.lcssa
}
