; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=thumbv8.1m.main-arm-eabihf -mattr=+mve.fp -loop-vectorize -tail-predication=enabled -S < %s | \
; RUN:  FileCheck %s -check-prefix=CHECK

; RUN: opt -mtriple=thumbv8.1m.main-arm-eabihf -mattr=+mve.fp -loop-vectorize -tail-predication=enabled \
; RUN:     -prefer-predicate-over-epilogue=predicate-dont-vectorize -S < %s | \
; RUN:     FileCheck -check-prefix=PREDFLAG %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"

; This test has a loop hint "predicate.predicate" set to false, so shouldn't
; get tail-folded, except with -prefer-predicate-over-epilog which then
; overrules this.
;
define dso_local void @flag_overrules_hint(i32* noalias nocapture %A, i32* noalias nocapture readonly %B, i32* noalias nocapture readonly %C) local_unnamed_addr #0 {
; CHECK-LABEL: @flag_overrules_hint(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw <4 x i32> [[WIDE_LOAD1]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i32* [[TMP9]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP7]], <4 x i32>* [[TMP10]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], 428
; CHECK-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 430, 428
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 428, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP13:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP13]], [[TMP12]]
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX4]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 430
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
;
; PREDFLAG-LABEL: @flag_overrules_hint(
; PREDFLAG-NEXT:  entry:
; PREDFLAG-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; PREDFLAG:       vector.ph:
; PREDFLAG-NEXT:    br label [[VECTOR_BODY:%.*]]
; PREDFLAG:       vector.body:
; PREDFLAG-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; PREDFLAG-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; PREDFLAG-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i64(i64 [[TMP0]], i64 430)
; PREDFLAG-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[TMP0]]
; PREDFLAG-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; PREDFLAG-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 [[TMP0]]
; PREDFLAG-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0
; PREDFLAG-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP6]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP7:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD1]], [[WIDE_MASKED_LOAD]]
; PREDFLAG-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[TMP0]]
; PREDFLAG-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[TMP8]], i32 0
; PREDFLAG-NEXT:    [[TMP10:%.*]] = bitcast i32* [[TMP9]] to <4 x i32>*
; PREDFLAG-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP7]], <4 x i32>* [[TMP10]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; PREDFLAG-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; PREDFLAG-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], 432
; PREDFLAG-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; PREDFLAG:       middle.block:
; PREDFLAG-NEXT:    br i1 true, label [[FOR_COND_CLEANUP:%.*]], label [[SCALAR_PH]]
; PREDFLAG:       scalar.ph:
; PREDFLAG-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 432, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; PREDFLAG-NEXT:    br label [[FOR_BODY:%.*]]
; PREDFLAG:       for.cond.cleanup:
; PREDFLAG-NEXT:    ret void
; PREDFLAG:       for.body:
; PREDFLAG-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; PREDFLAG-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV]]
; PREDFLAG-NEXT:    [[TMP12:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; PREDFLAG-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[INDVARS_IV]]
; PREDFLAG-NEXT:    [[TMP13:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; PREDFLAG-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP13]], [[TMP12]]
; PREDFLAG-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; PREDFLAG-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX4]], align 4
; PREDFLAG-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; PREDFLAG-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 430
; PREDFLAG-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
;

entry:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %B, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %C, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %1, %0
  %arrayidx4 = getelementptr inbounds i32, i32* %A, i64 %indvars.iv
  store i32 %add, i32* %arrayidx4, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 430
  br i1 %exitcond, label %for.cond.cleanup, label %for.body, !llvm.loop !10
}

define dso_local void @interleave4(i32* noalias nocapture %A, i32* noalias nocapture readonly %B, i32* noalias nocapture readonly %C, i32 %N) local_unnamed_addr #0 {
; CHECK-LABEL: @interleave4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP8:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP8]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 15
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 16
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[INDEX]], 8
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[INDEX]], 12
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[ACTIVE_LANE_MASK1:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP1]], i32 [[N]])
; CHECK-NEXT:    [[ACTIVE_LANE_MASK2:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP2]], i32 [[N]])
; CHECK-NEXT:    [[ACTIVE_LANE_MASK3:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP3]], i32 [[N]])
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP3]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP9]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 4
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i32* [[TMP10]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD4:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP11]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK1]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 8
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP12]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD5:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP13]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK2]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 12
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast i32* [[TMP14]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD6:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP15]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK3]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP18:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[TMP3]]
; CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 0
; CHECK-NEXT:    [[TMP21:%.*]] = bitcast i32* [[TMP20]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD7:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP21]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 4
; CHECK-NEXT:    [[TMP23:%.*]] = bitcast i32* [[TMP22]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD8:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP23]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK1]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 8
; CHECK-NEXT:    [[TMP25:%.*]] = bitcast i32* [[TMP24]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD9:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP25]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK2]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 12
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast i32* [[TMP26]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD10:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP27]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK3]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP28:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD7]], [[WIDE_MASKED_LOAD]]
; CHECK-NEXT:    [[TMP29:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD8]], [[WIDE_MASKED_LOAD4]]
; CHECK-NEXT:    [[TMP30:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD9]], [[WIDE_MASKED_LOAD5]]
; CHECK-NEXT:    [[TMP31:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD10]], [[WIDE_MASKED_LOAD6]]
; CHECK-NEXT:    [[TMP32:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP33:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP34:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP35:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP3]]
; CHECK-NEXT:    [[TMP36:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 0
; CHECK-NEXT:    [[TMP37:%.*]] = bitcast i32* [[TMP36]] to <4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP28]], <4 x i32>* [[TMP37]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[TMP38:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 4
; CHECK-NEXT:    [[TMP39:%.*]] = bitcast i32* [[TMP38]] to <4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP29]], <4 x i32>* [[TMP39]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK1]])
; CHECK-NEXT:    [[TMP40:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 8
; CHECK-NEXT:    [[TMP41:%.*]] = bitcast i32* [[TMP40]] to <4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP30]], <4 x i32>* [[TMP41]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK2]])
; CHECK-NEXT:    [[TMP42:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 12
; CHECK-NEXT:    [[TMP43:%.*]] = bitcast i32* [[TMP42]] to <4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP31]], <4 x i32>* [[TMP43]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK3]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 16
; CHECK-NEXT:    [[TMP44:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP44]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
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
; CHECK-NEXT:    [[TMP45:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[I_09]]
; CHECK-NEXT:    [[TMP46:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP46]], [[TMP45]]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[I_09]]
; CHECK-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_09]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
;
; PREDFLAG-LABEL: @interleave4(
; PREDFLAG-NEXT:  entry:
; PREDFLAG-NEXT:    [[CMP8:%.*]] = icmp sgt i32 [[N:%.*]], 0
; PREDFLAG-NEXT:    br i1 [[CMP8]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; PREDFLAG:       for.body.preheader:
; PREDFLAG-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; PREDFLAG:       vector.ph:
; PREDFLAG-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 15
; PREDFLAG-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 16
; PREDFLAG-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; PREDFLAG-NEXT:    br label [[VECTOR_BODY:%.*]]
; PREDFLAG:       vector.body:
; PREDFLAG-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; PREDFLAG-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; PREDFLAG-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 4
; PREDFLAG-NEXT:    [[TMP2:%.*]] = add i32 [[INDEX]], 8
; PREDFLAG-NEXT:    [[TMP3:%.*]] = add i32 [[INDEX]], 12
; PREDFLAG-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; PREDFLAG-NEXT:    [[ACTIVE_LANE_MASK1:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP1]], i32 [[N]])
; PREDFLAG-NEXT:    [[ACTIVE_LANE_MASK2:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP2]], i32 [[N]])
; PREDFLAG-NEXT:    [[ACTIVE_LANE_MASK3:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP3]], i32 [[N]])
; PREDFLAG-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i32 [[TMP0]]
; PREDFLAG-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP1]]
; PREDFLAG-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP2]]
; PREDFLAG-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP3]]
; PREDFLAG-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0
; PREDFLAG-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP9]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 4
; PREDFLAG-NEXT:    [[TMP11:%.*]] = bitcast i32* [[TMP10]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD4:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP11]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK1]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 8
; PREDFLAG-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP12]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD5:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP13]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK2]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 12
; PREDFLAG-NEXT:    [[TMP15:%.*]] = bitcast i32* [[TMP14]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD6:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP15]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK3]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP16:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i32 [[TMP0]]
; PREDFLAG-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[TMP1]]
; PREDFLAG-NEXT:    [[TMP18:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[TMP2]]
; PREDFLAG-NEXT:    [[TMP19:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[TMP3]]
; PREDFLAG-NEXT:    [[TMP20:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 0
; PREDFLAG-NEXT:    [[TMP21:%.*]] = bitcast i32* [[TMP20]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD7:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP21]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP22:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 4
; PREDFLAG-NEXT:    [[TMP23:%.*]] = bitcast i32* [[TMP22]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD8:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP23]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK1]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP24:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 8
; PREDFLAG-NEXT:    [[TMP25:%.*]] = bitcast i32* [[TMP24]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD9:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP25]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK2]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP26:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i32 12
; PREDFLAG-NEXT:    [[TMP27:%.*]] = bitcast i32* [[TMP26]] to <4 x i32>*
; PREDFLAG-NEXT:    [[WIDE_MASKED_LOAD10:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP27]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK3]], <4 x i32> poison)
; PREDFLAG-NEXT:    [[TMP28:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD7]], [[WIDE_MASKED_LOAD]]
; PREDFLAG-NEXT:    [[TMP29:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD8]], [[WIDE_MASKED_LOAD4]]
; PREDFLAG-NEXT:    [[TMP30:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD9]], [[WIDE_MASKED_LOAD5]]
; PREDFLAG-NEXT:    [[TMP31:%.*]] = add nsw <4 x i32> [[WIDE_MASKED_LOAD10]], [[WIDE_MASKED_LOAD6]]
; PREDFLAG-NEXT:    [[TMP32:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i32 [[TMP0]]
; PREDFLAG-NEXT:    [[TMP33:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP1]]
; PREDFLAG-NEXT:    [[TMP34:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP2]]
; PREDFLAG-NEXT:    [[TMP35:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[TMP3]]
; PREDFLAG-NEXT:    [[TMP36:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 0
; PREDFLAG-NEXT:    [[TMP37:%.*]] = bitcast i32* [[TMP36]] to <4 x i32>*
; PREDFLAG-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP28]], <4 x i32>* [[TMP37]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; PREDFLAG-NEXT:    [[TMP38:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 4
; PREDFLAG-NEXT:    [[TMP39:%.*]] = bitcast i32* [[TMP38]] to <4 x i32>*
; PREDFLAG-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP29]], <4 x i32>* [[TMP39]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK1]])
; PREDFLAG-NEXT:    [[TMP40:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 8
; PREDFLAG-NEXT:    [[TMP41:%.*]] = bitcast i32* [[TMP40]] to <4 x i32>*
; PREDFLAG-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP30]], <4 x i32>* [[TMP41]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK2]])
; PREDFLAG-NEXT:    [[TMP42:%.*]] = getelementptr inbounds i32, i32* [[TMP32]], i32 12
; PREDFLAG-NEXT:    [[TMP43:%.*]] = bitcast i32* [[TMP42]] to <4 x i32>*
; PREDFLAG-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[TMP31]], <4 x i32>* [[TMP43]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK3]])
; PREDFLAG-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 16
; PREDFLAG-NEXT:    [[TMP44:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; PREDFLAG-NEXT:    br i1 [[TMP44]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; PREDFLAG:       middle.block:
; PREDFLAG-NEXT:    br i1 true, label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; PREDFLAG:       scalar.ph:
; PREDFLAG-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; PREDFLAG-NEXT:    br label [[FOR_BODY:%.*]]
; PREDFLAG:       for.cond.cleanup.loopexit:
; PREDFLAG-NEXT:    br label [[FOR_COND_CLEANUP]]
; PREDFLAG:       for.cond.cleanup:
; PREDFLAG-NEXT:    ret void
; PREDFLAG:       for.body:
; PREDFLAG-NEXT:    [[I_09:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; PREDFLAG-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[I_09]]
; PREDFLAG-NEXT:    [[TMP45:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; PREDFLAG-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[C]], i32 [[I_09]]
; PREDFLAG-NEXT:    [[TMP46:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; PREDFLAG-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP46]], [[TMP45]]
; PREDFLAG-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i32 [[I_09]]
; PREDFLAG-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX2]], align 4
; PREDFLAG-NEXT:    [[INC]] = add nuw nsw i32 [[I_09]], 1
; PREDFLAG-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; PREDFLAG-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
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
  %exitcond = icmp eq i32 %inc, %N
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body, !llvm.loop !14
}

!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.vectorize.predicate.enable", i1 false}
!12 = !{!"llvm.loop.vectorize.enable", i1 true}

!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.interleave.count", i32 4}
