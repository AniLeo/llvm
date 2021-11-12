; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -loop-unroll -unroll-runtime=true -unroll-count=4 -unroll-remainder -instcombine | FileCheck %s

define i32 @unroll(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %N) local_unnamed_addr #0 {
;
; CHECK-LABEL: @unroll(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP9:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP9]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[WIDE_TRIP_COUNT]], -1
; CHECK-NEXT:    [[XTRAITER:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[TMP0]], 3
; CHECK-NEXT:    br i1 [[TMP1]], label [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA:%.*]], label [[FOR_BODY_LR_PH_NEW:%.*]]
; CHECK:       for.body.lr.ph.new:
; CHECK-NEXT:    [[UNROLL_ITER:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 4294967292
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit.unr-lcssa.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]]
; CHECK:       for.cond.cleanup.loopexit.unr-lcssa:
; CHECK-NEXT:    [[ADD_LCSSA_PH:%.*]] = phi i32 [ undef, [[FOR_BODY_LR_PH]] ], [ [[ADD_3:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    [[INDVARS_IV_UNR:%.*]] = phi i64 [ 0, [[FOR_BODY_LR_PH]] ], [ [[INDVARS_IV_NEXT_3:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA_LOOPEXIT]] ]
; CHECK-NEXT:    [[C_010_UNR:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH]] ], [ [[ADD_3]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA_LOOPEXIT]] ]
; CHECK-NEXT:    [[LCMP_MOD_NOT:%.*]] = icmp eq i64 [[XTRAITER]], 0
; CHECK-NEXT:    br i1 [[LCMP_MOD_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY_EPIL_PREHEADER:%.*]]
; CHECK:       for.body.epil.preheader:
; CHECK-NEXT:    br label [[FOR_BODY_EPIL:%.*]]
; CHECK:       for.body.epil:
; CHECK-NEXT:    [[ARRAYIDX_EPIL:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV_UNR]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX_EPIL]], align 4
; CHECK-NEXT:    [[ARRAYIDX2_EPIL:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[INDVARS_IV_UNR]]
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[ARRAYIDX2_EPIL]], align 4
; CHECK-NEXT:    [[MUL_EPIL:%.*]] = mul nsw i32 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[ADD_EPIL:%.*]] = add nsw i32 [[MUL_EPIL]], [[C_010_UNR]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_EPIL:%.*]] = add nuw nsw i64 [[INDVARS_IV_UNR]], 1
; CHECK-NEXT:    [[EPIL_ITER_CMP_NOT:%.*]] = icmp eq i64 [[XTRAITER]], 1
; CHECK-NEXT:    br i1 [[EPIL_ITER_CMP_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT_EPILOG_LCSSA:%.*]], label [[FOR_BODY_EPIL_1:%.*]]
; CHECK:       for.body.epil.1:
; CHECK-NEXT:    [[ARRAYIDX_EPIL_1:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV_NEXT_EPIL]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[ARRAYIDX_EPIL_1]], align 4
; CHECK-NEXT:    [[ARRAYIDX2_EPIL_1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV_NEXT_EPIL]]
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32* [[ARRAYIDX2_EPIL_1]], align 4
; CHECK-NEXT:    [[MUL_EPIL_1:%.*]] = mul nsw i32 [[TMP5]], [[TMP4]]
; CHECK-NEXT:    [[ADD_EPIL_1:%.*]] = add nsw i32 [[MUL_EPIL_1]], [[ADD_EPIL]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_EPIL_1:%.*]] = add nuw nsw i64 [[INDVARS_IV_UNR]], 2
; CHECK-NEXT:    [[EPIL_ITER_CMP_1_NOT:%.*]] = icmp eq i64 [[XTRAITER]], 2
; CHECK-NEXT:    br i1 [[EPIL_ITER_CMP_1_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT_EPILOG_LCSSA]], label [[FOR_BODY_EPIL_2:%.*]]
; CHECK:       for.body.epil.2:
; CHECK-NEXT:    [[ARRAYIDX_EPIL_2:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV_NEXT_EPIL_1]]
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, i32* [[ARRAYIDX_EPIL_2]], align 4
; CHECK-NEXT:    [[ARRAYIDX2_EPIL_2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV_NEXT_EPIL_1]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, i32* [[ARRAYIDX2_EPIL_2]], align 4
; CHECK-NEXT:    [[MUL_EPIL_2:%.*]] = mul nsw i32 [[TMP7]], [[TMP6]]
; CHECK-NEXT:    [[ADD_EPIL_2:%.*]] = add nsw i32 [[MUL_EPIL_2]], [[ADD_EPIL_1]]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP_LOOPEXIT_EPILOG_LCSSA]]
; CHECK:       for.cond.cleanup.loopexit.epilog-lcssa:
; CHECK-NEXT:    [[ADD_LCSSA_PH1:%.*]] = phi i32 [ [[ADD_EPIL]], [[FOR_BODY_EPIL]] ], [ [[ADD_EPIL_1]], [[FOR_BODY_EPIL_1]] ], [ [[ADD_EPIL_2]], [[FOR_BODY_EPIL_2]] ]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP_LOOPEXIT]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD_LCSSA_PH]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ], [ [[ADD_LCSSA_PH1]], [[FOR_COND_CLEANUP_LOOPEXIT_EPILOG_LCSSA]] ]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[C_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[C_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_BODY_LR_PH_NEW]] ], [ [[INDVARS_IV_NEXT_3]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[C_010:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH_NEW]] ], [ [[ADD_3]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[NITER:%.*]] = phi i64 [ [[UNROLL_ITER]], [[FOR_BODY_LR_PH_NEW]] ], [ [[NITER_NSUB_3:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[MUL:%.*]] = mul nsw i32 [[TMP9]], [[TMP8]]
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[MUL]], [[C_010]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = or i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[ARRAYIDX_1]], align 4
; CHECK-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[TMP11:%.*]] = load i32, i32* [[ARRAYIDX2_1]], align 4
; CHECK-NEXT:    [[MUL_1:%.*]] = mul nsw i32 [[TMP11]], [[TMP10]]
; CHECK-NEXT:    [[ADD_1:%.*]] = add nsw i32 [[MUL_1]], [[ADD]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_1:%.*]] = or i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV_NEXT_1]]
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32* [[ARRAYIDX_2]], align 4
; CHECK-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV_NEXT_1]]
; CHECK-NEXT:    [[TMP13:%.*]] = load i32, i32* [[ARRAYIDX2_2]], align 4
; CHECK-NEXT:    [[MUL_2:%.*]] = mul nsw i32 [[TMP13]], [[TMP12]]
; CHECK-NEXT:    [[ADD_2:%.*]] = add nsw i32 [[MUL_2]], [[ADD_1]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_2:%.*]] = or i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV_NEXT_2]]
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[ARRAYIDX_3]], align 4
; CHECK-NEXT:    [[ARRAYIDX2_3:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDVARS_IV_NEXT_2]]
; CHECK-NEXT:    [[TMP15:%.*]] = load i32, i32* [[ARRAYIDX2_3]], align 4
; CHECK-NEXT:    [[MUL_3:%.*]] = mul nsw i32 [[TMP15]], [[TMP14]]
; CHECK-NEXT:    [[ADD_3]] = add nsw i32 [[MUL_3]], [[ADD_2]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_3]] = add nuw nsw i64 [[INDVARS_IV]], 4
; CHECK-NEXT:    [[NITER_NSUB_3]] = add i64 [[NITER]], -4
; CHECK-NEXT:    [[NITER_NCMP_3:%.*]] = icmp eq i64 [[NITER_NSUB_3]], 0
; CHECK-NEXT:    br i1 [[NITER_NCMP_3]], label [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
;
entry:
  %cmp9 = icmp eq i32 %N, 0
  br i1 %cmp9, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:
  %wide.trip.count = zext i32 %N to i64
  br label %for.body

for.cond.cleanup:
  %c.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %c.0.lcssa











for.body:
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.body ]
  %c.010 = phi i32 [ 0, %for.body.lr.ph ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %b, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx2, align 4
  %mul = mul nsw i32 %1, %0
  %add = add nsw i32 %mul, %c.010
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}
