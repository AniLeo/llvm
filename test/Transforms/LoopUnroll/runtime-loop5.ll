; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -loop-unroll -unroll-runtime=true -unroll-count=16 | FileCheck --check-prefix=UNROLL-16 %s
; RUN: opt < %s -S -loop-unroll -unroll-runtime=true -unroll-count=4 | FileCheck --check-prefix=UNROLL-4 %s

; RUN: opt < %s -S -passes='require<opt-remark-emit>,loop-unroll' -unroll-runtime=true -unroll-count=16 | FileCheck --check-prefix=UNROLL-16 %s
; RUN: opt < %s -S -passes='require<opt-remark-emit>,loop-unroll' -unroll-runtime=true -unroll-count=4 | FileCheck --check-prefix=UNROLL-4 %s

; Given that the trip-count of this loop is a 3-bit value, we cannot
; safely unroll it with a count of anything more than 8.

define i3 @test(i3* %a, i3 %n) {
; UNROLL-16-LABEL: @test(
; UNROLL-16-NEXT:  entry:
; UNROLL-16-NEXT:    [[CMP1:%.*]] = icmp eq i3 [[N:%.*]], 0
; UNROLL-16-NEXT:    br i1 [[CMP1]], label [[FOR_END:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; UNROLL-16:       for.body.preheader:
; UNROLL-16-NEXT:    br label [[FOR_BODY:%.*]]
; UNROLL-16:       for.body:
; UNROLL-16-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[INDVARS_IV_NEXT_15:%.*]], [[FOR_BODY_15:%.*]] ]
; UNROLL-16-NEXT:    [[SUM_02:%.*]] = phi i3 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[ADD_15:%.*]], [[FOR_BODY_15]] ]
; UNROLL-16-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i3, i3* [[A:%.*]], i64 [[INDVARS_IV]]
; UNROLL-16-NEXT:    [[TMP0:%.*]] = load i3, i3* [[ARRAYIDX]], align 1
; UNROLL-16-NEXT:    [[ADD:%.*]] = add nsw i3 [[TMP0]], [[SUM_02]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; UNROLL-16-NEXT:    [[EXITCOND:%.*]] = icmp eq i3 1, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_1:%.*]]
; UNROLL-16:       for.end.loopexit:
; UNROLL-16-NEXT:    [[ADD_LCSSA:%.*]] = phi i3 [ [[ADD]], [[FOR_BODY]] ], [ [[ADD_1:%.*]], [[FOR_BODY_1]] ], [ [[ADD_2:%.*]], [[FOR_BODY_2:%.*]] ], [ [[ADD_3:%.*]], [[FOR_BODY_3:%.*]] ], [ [[ADD_4:%.*]], [[FOR_BODY_4:%.*]] ], [ [[ADD_5:%.*]], [[FOR_BODY_5:%.*]] ], [ [[ADD_6:%.*]], [[FOR_BODY_6:%.*]] ], [ [[ADD_7:%.*]], [[FOR_BODY_7:%.*]] ], [ [[ADD_8:%.*]], [[FOR_BODY_8:%.*]] ], [ [[ADD_9:%.*]], [[FOR_BODY_9:%.*]] ], [ [[ADD_10:%.*]], [[FOR_BODY_10:%.*]] ], [ [[ADD_11:%.*]], [[FOR_BODY_11:%.*]] ], [ [[ADD_12:%.*]], [[FOR_BODY_12:%.*]] ], [ [[ADD_13:%.*]], [[FOR_BODY_13:%.*]] ], [ [[ADD_14:%.*]], [[FOR_BODY_14:%.*]] ], [ [[ADD_15]], [[FOR_BODY_15]] ]
; UNROLL-16-NEXT:    br label [[FOR_END]]
; UNROLL-16:       for.end:
; UNROLL-16-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i3 [ 0, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_END_LOOPEXIT]] ]
; UNROLL-16-NEXT:    ret i3 [[SUM_0_LCSSA]]
; UNROLL-16:       for.body.1:
; UNROLL-16-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT]]
; UNROLL-16-NEXT:    [[TMP1:%.*]] = load i3, i3* [[ARRAYIDX_1]], align 1
; UNROLL-16-NEXT:    [[ADD_1]] = add nsw i3 [[TMP1]], [[ADD]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_1:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT]], 1
; UNROLL-16-NEXT:    [[EXITCOND_1:%.*]] = icmp eq i3 2, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_1]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_2]]
; UNROLL-16:       for.body.2:
; UNROLL-16-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_1]]
; UNROLL-16-NEXT:    [[TMP2:%.*]] = load i3, i3* [[ARRAYIDX_2]], align 1
; UNROLL-16-NEXT:    [[ADD_2]] = add nsw i3 [[TMP2]], [[ADD_1]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_2:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_1]], 1
; UNROLL-16-NEXT:    [[EXITCOND_2:%.*]] = icmp eq i3 3, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_2]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_3]]
; UNROLL-16:       for.body.3:
; UNROLL-16-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_2]]
; UNROLL-16-NEXT:    [[TMP3:%.*]] = load i3, i3* [[ARRAYIDX_3]], align 1
; UNROLL-16-NEXT:    [[ADD_3]] = add nsw i3 [[TMP3]], [[ADD_2]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_3:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_2]], 1
; UNROLL-16-NEXT:    [[EXITCOND_3:%.*]] = icmp eq i3 -4, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_3]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_4]]
; UNROLL-16:       for.body.4:
; UNROLL-16-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_3]]
; UNROLL-16-NEXT:    [[TMP4:%.*]] = load i3, i3* [[ARRAYIDX_4]], align 1
; UNROLL-16-NEXT:    [[ADD_4]] = add nsw i3 [[TMP4]], [[ADD_3]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_4:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_3]], 1
; UNROLL-16-NEXT:    [[EXITCOND_4:%.*]] = icmp eq i3 -3, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_4]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_5]]
; UNROLL-16:       for.body.5:
; UNROLL-16-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_4]]
; UNROLL-16-NEXT:    [[TMP5:%.*]] = load i3, i3* [[ARRAYIDX_5]], align 1
; UNROLL-16-NEXT:    [[ADD_5]] = add nsw i3 [[TMP5]], [[ADD_4]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_5:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_4]], 1
; UNROLL-16-NEXT:    [[EXITCOND_5:%.*]] = icmp eq i3 -2, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_5]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_6]]
; UNROLL-16:       for.body.6:
; UNROLL-16-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_5]]
; UNROLL-16-NEXT:    [[TMP6:%.*]] = load i3, i3* [[ARRAYIDX_6]], align 1
; UNROLL-16-NEXT:    [[ADD_6]] = add nsw i3 [[TMP6]], [[ADD_5]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_6:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_5]], 1
; UNROLL-16-NEXT:    [[EXITCOND_6:%.*]] = icmp eq i3 -1, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_6]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_7]]
; UNROLL-16:       for.body.7:
; UNROLL-16-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_6]]
; UNROLL-16-NEXT:    [[TMP7:%.*]] = load i3, i3* [[ARRAYIDX_7]], align 1
; UNROLL-16-NEXT:    [[ADD_7]] = add nsw i3 [[TMP7]], [[ADD_6]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_7:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_6]], 1
; UNROLL-16-NEXT:    br i1 false, label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_8]]
; UNROLL-16:       for.body.8:
; UNROLL-16-NEXT:    [[ARRAYIDX_8:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_7]]
; UNROLL-16-NEXT:    [[TMP8:%.*]] = load i3, i3* [[ARRAYIDX_8]], align 1
; UNROLL-16-NEXT:    [[ADD_8]] = add nsw i3 [[TMP8]], [[ADD_7]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_8:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_7]], 1
; UNROLL-16-NEXT:    [[EXITCOND_8:%.*]] = icmp eq i3 1, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_8]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_9]]
; UNROLL-16:       for.body.9:
; UNROLL-16-NEXT:    [[ARRAYIDX_9:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_8]]
; UNROLL-16-NEXT:    [[TMP9:%.*]] = load i3, i3* [[ARRAYIDX_9]], align 1
; UNROLL-16-NEXT:    [[ADD_9]] = add nsw i3 [[TMP9]], [[ADD_8]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_9:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_8]], 1
; UNROLL-16-NEXT:    [[EXITCOND_9:%.*]] = icmp eq i3 2, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_9]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_10]]
; UNROLL-16:       for.body.10:
; UNROLL-16-NEXT:    [[ARRAYIDX_10:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_9]]
; UNROLL-16-NEXT:    [[TMP10:%.*]] = load i3, i3* [[ARRAYIDX_10]], align 1
; UNROLL-16-NEXT:    [[ADD_10]] = add nsw i3 [[TMP10]], [[ADD_9]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_10:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_9]], 1
; UNROLL-16-NEXT:    [[EXITCOND_10:%.*]] = icmp eq i3 3, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_10]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_11]]
; UNROLL-16:       for.body.11:
; UNROLL-16-NEXT:    [[ARRAYIDX_11:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_10]]
; UNROLL-16-NEXT:    [[TMP11:%.*]] = load i3, i3* [[ARRAYIDX_11]], align 1
; UNROLL-16-NEXT:    [[ADD_11]] = add nsw i3 [[TMP11]], [[ADD_10]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_11:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_10]], 1
; UNROLL-16-NEXT:    [[EXITCOND_11:%.*]] = icmp eq i3 -4, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_11]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_12]]
; UNROLL-16:       for.body.12:
; UNROLL-16-NEXT:    [[ARRAYIDX_12:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_11]]
; UNROLL-16-NEXT:    [[TMP12:%.*]] = load i3, i3* [[ARRAYIDX_12]], align 1
; UNROLL-16-NEXT:    [[ADD_12]] = add nsw i3 [[TMP12]], [[ADD_11]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_12:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_11]], 1
; UNROLL-16-NEXT:    [[EXITCOND_12:%.*]] = icmp eq i3 -3, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_12]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_13]]
; UNROLL-16:       for.body.13:
; UNROLL-16-NEXT:    [[ARRAYIDX_13:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_12]]
; UNROLL-16-NEXT:    [[TMP13:%.*]] = load i3, i3* [[ARRAYIDX_13]], align 1
; UNROLL-16-NEXT:    [[ADD_13]] = add nsw i3 [[TMP13]], [[ADD_12]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_13:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_12]], 1
; UNROLL-16-NEXT:    [[EXITCOND_13:%.*]] = icmp eq i3 -2, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_13]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_14]]
; UNROLL-16:       for.body.14:
; UNROLL-16-NEXT:    [[ARRAYIDX_14:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_13]]
; UNROLL-16-NEXT:    [[TMP14:%.*]] = load i3, i3* [[ARRAYIDX_14]], align 1
; UNROLL-16-NEXT:    [[ADD_14]] = add nsw i3 [[TMP14]], [[ADD_13]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_14:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_13]], 1
; UNROLL-16-NEXT:    [[EXITCOND_14:%.*]] = icmp eq i3 -1, [[N]]
; UNROLL-16-NEXT:    br i1 [[EXITCOND_14]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY_15]]
; UNROLL-16:       for.body.15:
; UNROLL-16-NEXT:    [[ARRAYIDX_15:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_14]]
; UNROLL-16-NEXT:    [[TMP15:%.*]] = load i3, i3* [[ARRAYIDX_15]], align 1
; UNROLL-16-NEXT:    [[ADD_15]] = add nsw i3 [[TMP15]], [[ADD_14]]
; UNROLL-16-NEXT:    [[INDVARS_IV_NEXT_15]] = add i64 [[INDVARS_IV_NEXT_14]], 1
; UNROLL-16-NEXT:    br i1 false, label [[FOR_END_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
;
; UNROLL-4-LABEL: @test(
; UNROLL-4-NEXT:  entry:
; UNROLL-4-NEXT:    [[CMP1:%.*]] = icmp eq i3 [[N:%.*]], 0
; UNROLL-4-NEXT:    br i1 [[CMP1]], label [[FOR_END:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; UNROLL-4:       for.body.preheader:
; UNROLL-4-NEXT:    [[TMP0:%.*]] = add i3 [[N]], -1
; UNROLL-4-NEXT:    [[XTRAITER:%.*]] = and i3 [[N]], 3
; UNROLL-4-NEXT:    [[TMP1:%.*]] = icmp ult i3 [[TMP0]], 3
; UNROLL-4-NEXT:    br i1 [[TMP1]], label [[FOR_END_LOOPEXIT_UNR_LCSSA:%.*]], label [[FOR_BODY_PREHEADER_NEW:%.*]]
; UNROLL-4:       for.body.preheader.new:
; UNROLL-4-NEXT:    [[UNROLL_ITER:%.*]] = sub i3 [[N]], [[XTRAITER]]
; UNROLL-4-NEXT:    br label [[FOR_BODY:%.*]]
; UNROLL-4:       for.body:
; UNROLL-4-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER_NEW]] ], [ [[INDVARS_IV_NEXT_3:%.*]], [[FOR_BODY]] ]
; UNROLL-4-NEXT:    [[SUM_02:%.*]] = phi i3 [ 0, [[FOR_BODY_PREHEADER_NEW]] ], [ [[ADD_3:%.*]], [[FOR_BODY]] ]
; UNROLL-4-NEXT:    [[NITER:%.*]] = phi i3 [ [[UNROLL_ITER]], [[FOR_BODY_PREHEADER_NEW]] ], [ [[NITER_NSUB_3:%.*]], [[FOR_BODY]] ]
; UNROLL-4-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i3, i3* [[A:%.*]], i64 [[INDVARS_IV]]
; UNROLL-4-NEXT:    [[TMP2:%.*]] = load i3, i3* [[ARRAYIDX]], align 1
; UNROLL-4-NEXT:    [[ADD:%.*]] = add nsw i3 [[TMP2]], [[SUM_02]]
; UNROLL-4-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; UNROLL-4-NEXT:    [[NITER_NSUB:%.*]] = sub i3 [[NITER]], 1
; UNROLL-4-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT]]
; UNROLL-4-NEXT:    [[TMP3:%.*]] = load i3, i3* [[ARRAYIDX_1]], align 1
; UNROLL-4-NEXT:    [[ADD_1:%.*]] = add nsw i3 [[TMP3]], [[ADD]]
; UNROLL-4-NEXT:    [[INDVARS_IV_NEXT_1:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT]], 1
; UNROLL-4-NEXT:    [[NITER_NSUB_1:%.*]] = sub i3 [[NITER_NSUB]], 1
; UNROLL-4-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_1]]
; UNROLL-4-NEXT:    [[TMP4:%.*]] = load i3, i3* [[ARRAYIDX_2]], align 1
; UNROLL-4-NEXT:    [[ADD_2:%.*]] = add nsw i3 [[TMP4]], [[ADD_1]]
; UNROLL-4-NEXT:    [[INDVARS_IV_NEXT_2:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_1]], 1
; UNROLL-4-NEXT:    [[NITER_NSUB_2:%.*]] = sub i3 [[NITER_NSUB_1]], 1
; UNROLL-4-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_NEXT_2]]
; UNROLL-4-NEXT:    [[TMP5:%.*]] = load i3, i3* [[ARRAYIDX_3]], align 1
; UNROLL-4-NEXT:    [[ADD_3]] = add nsw i3 [[TMP5]], [[ADD_2]]
; UNROLL-4-NEXT:    [[INDVARS_IV_NEXT_3]] = add i64 [[INDVARS_IV_NEXT_2]], 1
; UNROLL-4-NEXT:    [[NITER_NSUB_3]] = sub i3 [[NITER_NSUB_2]], 1
; UNROLL-4-NEXT:    [[NITER_NCMP_3:%.*]] = icmp eq i3 [[NITER_NSUB_3]], 0
; UNROLL-4-NEXT:    br i1 [[NITER_NCMP_3]], label [[FOR_END_LOOPEXIT_UNR_LCSSA_LOOPEXIT:%.*]], label [[FOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; UNROLL-4:       for.end.loopexit.unr-lcssa.loopexit:
; UNROLL-4-NEXT:    [[ADD_LCSSA_PH_PH:%.*]] = phi i3 [ [[ADD_3]], [[FOR_BODY]] ]
; UNROLL-4-NEXT:    [[INDVARS_IV_UNR_PH:%.*]] = phi i64 [ [[INDVARS_IV_NEXT_3]], [[FOR_BODY]] ]
; UNROLL-4-NEXT:    [[SUM_02_UNR_PH:%.*]] = phi i3 [ [[ADD_3]], [[FOR_BODY]] ]
; UNROLL-4-NEXT:    br label [[FOR_END_LOOPEXIT_UNR_LCSSA]]
; UNROLL-4:       for.end.loopexit.unr-lcssa:
; UNROLL-4-NEXT:    [[ADD_LCSSA_PH:%.*]] = phi i3 [ undef, [[FOR_BODY_PREHEADER]] ], [ [[ADD_LCSSA_PH_PH]], [[FOR_END_LOOPEXIT_UNR_LCSSA_LOOPEXIT]] ]
; UNROLL-4-NEXT:    [[INDVARS_IV_UNR:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[INDVARS_IV_UNR_PH]], [[FOR_END_LOOPEXIT_UNR_LCSSA_LOOPEXIT]] ]
; UNROLL-4-NEXT:    [[SUM_02_UNR:%.*]] = phi i3 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[SUM_02_UNR_PH]], [[FOR_END_LOOPEXIT_UNR_LCSSA_LOOPEXIT]] ]
; UNROLL-4-NEXT:    [[LCMP_MOD:%.*]] = icmp ne i3 [[XTRAITER]], 0
; UNROLL-4-NEXT:    br i1 [[LCMP_MOD]], label [[FOR_BODY_EPIL_PREHEADER:%.*]], label [[FOR_END_LOOPEXIT:%.*]]
; UNROLL-4:       for.body.epil.preheader:
; UNROLL-4-NEXT:    br label [[FOR_BODY_EPIL:%.*]]
; UNROLL-4:       for.body.epil:
; UNROLL-4-NEXT:    [[INDVARS_IV_EPIL:%.*]] = phi i64 [ [[INDVARS_IV_NEXT_EPIL:%.*]], [[FOR_BODY_EPIL]] ], [ [[INDVARS_IV_UNR]], [[FOR_BODY_EPIL_PREHEADER]] ]
; UNROLL-4-NEXT:    [[SUM_02_EPIL:%.*]] = phi i3 [ [[ADD_EPIL:%.*]], [[FOR_BODY_EPIL]] ], [ [[SUM_02_UNR]], [[FOR_BODY_EPIL_PREHEADER]] ]
; UNROLL-4-NEXT:    [[EPIL_ITER:%.*]] = phi i3 [ [[XTRAITER]], [[FOR_BODY_EPIL_PREHEADER]] ], [ [[EPIL_ITER_SUB:%.*]], [[FOR_BODY_EPIL]] ]
; UNROLL-4-NEXT:    [[ARRAYIDX_EPIL:%.*]] = getelementptr inbounds i3, i3* [[A]], i64 [[INDVARS_IV_EPIL]]
; UNROLL-4-NEXT:    [[TMP6:%.*]] = load i3, i3* [[ARRAYIDX_EPIL]], align 1
; UNROLL-4-NEXT:    [[ADD_EPIL]] = add nsw i3 [[TMP6]], [[SUM_02_EPIL]]
; UNROLL-4-NEXT:    [[INDVARS_IV_NEXT_EPIL]] = add i64 [[INDVARS_IV_EPIL]], 1
; UNROLL-4-NEXT:    [[LFTR_WIDEIV_EPIL:%.*]] = trunc i64 [[INDVARS_IV_NEXT_EPIL]] to i3
; UNROLL-4-NEXT:    [[EXITCOND_EPIL:%.*]] = icmp eq i3 [[LFTR_WIDEIV_EPIL]], [[N]]
; UNROLL-4-NEXT:    [[EPIL_ITER_SUB]] = sub i3 [[EPIL_ITER]], 1
; UNROLL-4-NEXT:    [[EPIL_ITER_CMP:%.*]] = icmp ne i3 [[EPIL_ITER_SUB]], 0
; UNROLL-4-NEXT:    br i1 [[EPIL_ITER_CMP]], label [[FOR_BODY_EPIL]], label [[FOR_END_LOOPEXIT_EPILOG_LCSSA:%.*]], !llvm.loop [[LOOP2:![0-9]+]]
; UNROLL-4:       for.end.loopexit.epilog-lcssa:
; UNROLL-4-NEXT:    [[ADD_LCSSA_PH1:%.*]] = phi i3 [ [[ADD_EPIL]], [[FOR_BODY_EPIL]] ]
; UNROLL-4-NEXT:    br label [[FOR_END_LOOPEXIT]]
; UNROLL-4:       for.end.loopexit:
; UNROLL-4-NEXT:    [[ADD_LCSSA:%.*]] = phi i3 [ [[ADD_LCSSA_PH]], [[FOR_END_LOOPEXIT_UNR_LCSSA]] ], [ [[ADD_LCSSA_PH1]], [[FOR_END_LOOPEXIT_EPILOG_LCSSA]] ]
; UNROLL-4-NEXT:    br label [[FOR_END]]
; UNROLL-4:       for.end:
; UNROLL-4-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i3 [ 0, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_END_LOOPEXIT]] ]
; UNROLL-4-NEXT:    ret i3 [[SUM_0_LCSSA]]
;
entry:
  %cmp1 = icmp eq i3 %n, 0
  br i1 %cmp1, label %for.end, label %for.body

for.body:                                         ; preds = %for.body, %entry
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %sum.02 = phi i3 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i3, i3* %a, i64 %indvars.iv
  %0 = load i3, i3* %arrayidx
  %add = add nsw i3 %0, %sum.02
  %indvars.iv.next = add i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i3
  %exitcond = icmp eq i3 %lftr.wideiv, %n
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %sum.0.lcssa = phi i3 [ 0, %entry ], [ %add, %for.body ]
  ret i3 %sum.0.lcssa
}
