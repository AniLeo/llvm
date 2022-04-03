; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; To test epilogue-vectorization we need to make sure that the vectorizer actually vectorizes the loop.
; Without a target triple this becomes difficult, unless we force vectorization through user hints.
; Currently user provided vectorization hints prevent epilogue vectorization unless the forced
; VF is the same as the epilogue vectorization VF. To make these tests target independent we'll use a
; trick where both VFs are forced to be the same value.
; RUN: opt < %s -passes='loop-vectorize' -enable-epilogue-vectorization -force-vector-width=2 -epilogue-vectorization-force-VF=2 -S | FileCheck %s --check-prefix VF-TWO-CHECK

target datalayout = "e-m:e-i64:64-n32:64"

; Some limited forms of live-outs (non-reduction, non-recurrences) are supported.
define signext i32 @f1(i32* noalias %A, i32* noalias %B, i32 signext %n) {
; VF-TWO-CHECK-LABEL: @f1(
; VF-TWO-CHECK-NEXT:  entry:
; VF-TWO-CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[N:%.*]], 0
; VF-TWO-CHECK-NEXT:    br i1 [[CMP1]], label [[ITER_CHECK:%.*]], label [[FOR_END:%.*]]
; VF-TWO-CHECK:       iter.check:
; VF-TWO-CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; VF-TWO-CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 2
; VF-TWO-CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; VF-TWO-CHECK:       vector.main.loop.iter.check:
; VF-TWO-CHECK-NEXT:    [[MIN_ITERS_CHECK1:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 2
; VF-TWO-CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK1]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; VF-TWO-CHECK:       vector.ph:
; VF-TWO-CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 2
; VF-TWO-CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF]]
; VF-TWO-CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; VF-TWO-CHECK:       vector.body:
; VF-TWO-CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; VF-TWO-CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; VF-TWO-CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[TMP0]]
; VF-TWO-CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; VF-TWO-CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <2 x i32>*
; VF-TWO-CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i32>, <2 x i32>* [[TMP3]], align 4
; VF-TWO-CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[TMP0]]
; VF-TWO-CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0
; VF-TWO-CHECK-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <2 x i32>*
; VF-TWO-CHECK-NEXT:    [[WIDE_LOAD2:%.*]] = load <2 x i32>, <2 x i32>* [[TMP6]], align 4
; VF-TWO-CHECK-NEXT:    [[TMP7:%.*]] = add nsw <2 x i32> [[WIDE_LOAD]], [[WIDE_LOAD2]]
; VF-TWO-CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; VF-TWO-CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; VF-TWO-CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; VF-TWO-CHECK:       middle.block:
; VF-TWO-CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; VF-TWO-CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i32> [[TMP7]], i32 1
; VF-TWO-CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; VF-TWO-CHECK:       vec.epilog.iter.check:
; VF-TWO-CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; VF-TWO-CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK:%.*]] = icmp ult i64 [[N_VEC_REMAINING]], 2
; VF-TWO-CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; VF-TWO-CHECK:       vec.epilog.ph:
; VF-TWO-CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; VF-TWO-CHECK-NEXT:    [[N_MOD_VF4:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 2
; VF-TWO-CHECK-NEXT:    [[N_VEC5:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF4]]
; VF-TWO-CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; VF-TWO-CHECK:       vec.epilog.vector.body:
; VF-TWO-CHECK-NEXT:    [[INDEX6:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT7:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; VF-TWO-CHECK-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX6]], 0
; VF-TWO-CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP10]]
; VF-TWO-CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[TMP11]], i32 0
; VF-TWO-CHECK-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP12]] to <2 x i32>*
; VF-TWO-CHECK-NEXT:    [[WIDE_LOAD9:%.*]] = load <2 x i32>, <2 x i32>* [[TMP13]], align 4
; VF-TWO-CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[TMP10]]
; VF-TWO-CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds i32, i32* [[TMP14]], i32 0
; VF-TWO-CHECK-NEXT:    [[TMP16:%.*]] = bitcast i32* [[TMP15]] to <2 x i32>*
; VF-TWO-CHECK-NEXT:    [[WIDE_LOAD10:%.*]] = load <2 x i32>, <2 x i32>* [[TMP16]], align 4
; VF-TWO-CHECK-NEXT:    [[TMP17:%.*]] = add nsw <2 x i32> [[WIDE_LOAD9]], [[WIDE_LOAD10]]
; VF-TWO-CHECK-NEXT:    [[INDEX_NEXT7]] = add nuw i64 [[INDEX6]], 2
; VF-TWO-CHECK-NEXT:    [[TMP18:%.*]] = icmp eq i64 [[INDEX_NEXT7]], [[N_VEC5]]
; VF-TWO-CHECK-NEXT:    br i1 [[TMP18]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP2:!llvm.loop !.*]]
; VF-TWO-CHECK:       vec.epilog.middle.block:
; VF-TWO-CHECK-NEXT:    [[CMP_N8:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC5]]
; VF-TWO-CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x i32> [[TMP17]], i32 1
; VF-TWO-CHECK-NEXT:    br i1 [[CMP_N8]], label [[FOR_END_LOOPEXIT_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; VF-TWO-CHECK:       vec.epilog.scalar.ph:
; VF-TWO-CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC5]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[ITER_CHECK]] ]
; VF-TWO-CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; VF-TWO-CHECK:       for.body:
; VF-TWO-CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; VF-TWO-CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; VF-TWO-CHECK-NEXT:    [[TMP20:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; VF-TWO-CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV]]
; VF-TWO-CHECK-NEXT:    [[TMP21:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; VF-TWO-CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP20]], [[TMP21]]
; VF-TWO-CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; VF-TWO-CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; VF-TWO-CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT_LOOPEXIT]], [[LOOP4:!llvm.loop !.*]]
; VF-TWO-CHECK:       for.end.loopexit.loopexit:
; VF-TWO-CHECK-NEXT:    [[ADD_LCSSA3:%.*]] = phi i32 [ [[ADD]], [[FOR_BODY]] ], [ [[TMP19]], [[VEC_EPILOG_MIDDLE_BLOCK]] ]
; VF-TWO-CHECK-NEXT:    br label [[FOR_END_LOOPEXIT]]
; VF-TWO-CHECK:       for.end.loopexit:
; VF-TWO-CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[TMP9]], [[MIDDLE_BLOCK]] ], [ [[ADD_LCSSA3]], [[FOR_END_LOOPEXIT_LOOPEXIT]] ]
; VF-TWO-CHECK-NEXT:    br label [[FOR_END]]
; VF-TWO-CHECK:       for.end:
; VF-TWO-CHECK-NEXT:    [[RES_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_END_LOOPEXIT]] ]
; VF-TWO-CHECK-NEXT:    ret i32 [[RES_0_LCSSA]]
;
entry:
  %cmp1 = icmp sgt i32 %n, 0
  br i1 %cmp1, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %wide.trip.count = zext i32 %n to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %B, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %0, %1
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  %add.lcssa = phi i32 [ %add, %for.body ]
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  %res.0.lcssa = phi i32 [ 0, %entry ], [ %add.lcssa, %for.end.loopexit ]
  ret i32 %res.0.lcssa
}
