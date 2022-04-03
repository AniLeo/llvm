; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -mtriple=s390x-ibm-linux -mcpu=z13 -force-vector-width=2 -S %s | FileCheck %s

; Test case from PR44020.

; In func_21, %rec forms a first order recurrence and we predicate to avoid
; scalar iteration overhead for a low trip count loop. Make sure we pick
; the correct insertion point when fixing first order recurrences.

@A = external dso_local global [5 x i32], align 4
@B = external dso_local global [5 x i32], align 4

define void @func_21() {
; CHECK-LABEL: @func_21(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE4:%.*]] ]
; CHECK-NEXT:    [[VECTOR_RECUR:%.*]] = phi <2 x i32> [ <i32 poison, i32 0>, [[VECTOR_PH]] ], [ [[TMP12:%.*]], [[PRED_STORE_CONTINUE4]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[PRED_STORE_CONTINUE4]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ule <2 x i64> [[VEC_IND]], <i64 4, i64 4>
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x i1> [[TMP2]], i32 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [5 x i32], [5 x i32]* @A, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32* [[TMP4]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i32> poison, i32 [[TMP5]], i32 0
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = phi <2 x i32> [ poison, [[VECTOR_BODY]] ], [ [[TMP6]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i1> [[TMP2]], i32 1
; CHECK-NEXT:    br i1 [[TMP8]], label [[PRED_LOAD_IF1:%.*]], label [[PRED_LOAD_CONTINUE2:%.*]]
; CHECK:       pred.load.if1:
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [5 x i32], [5 x i32]* @A, i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <2 x i32> [[TMP7]], i32 [[TMP10]], i32 1
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE2]]
; CHECK:       pred.load.continue2:
; CHECK-NEXT:    [[TMP12]] = phi <2 x i32> [ [[TMP7]], [[PRED_LOAD_CONTINUE]] ], [ [[TMP11]], [[PRED_LOAD_IF1]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <2 x i32> [[VECTOR_RECUR]], <2 x i32> [[TMP12]], <2 x i32> <i32 1, i32 2>
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x i1> [[TMP2]], i32 0
; CHECK-NEXT:    br i1 [[TMP14]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [5 x i32], [5 x i32]* @B, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <2 x i32> [[TMP13]], i32 0
; CHECK-NEXT:    store i32 [[TMP16]], i32* [[TMP15]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <2 x i1> [[TMP2]], i32 1
; CHECK-NEXT:    br i1 [[TMP17]], label [[PRED_STORE_IF3:%.*]], label [[PRED_STORE_CONTINUE4]]
; CHECK:       pred.store.if3:
; CHECK-NEXT:    [[TMP18:%.*]] = getelementptr inbounds [5 x i32], [5 x i32]* @B, i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x i32> [[TMP13]], i32 1
; CHECK-NEXT:    store i32 [[TMP19]], i32* [[TMP18]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE4]]
; CHECK:       pred.store.continue4:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP20:%.*]] = icmp eq i64 [[INDEX_NEXT]], 6
; CHECK-NEXT:    br i1 [[TMP20]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT:%.*]] = extractelement <2 x i32> [[TMP12]], i32 1
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT_FOR_PHI:%.*]] = extractelement <2 x i32> [[TMP12]], i32 0
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[SCALAR_RECUR_INIT:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[VECTOR_RECUR_EXTRACT]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 6, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SCALAR_RECUR:%.*]] = phi i32 [ [[SCALAR_RECUR_INIT]], [[SCALAR_PH]] ], [ [[LV:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[A_PTR:%.*]] = getelementptr inbounds [5 x i32], [5 x i32]* @A, i64 0, i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[LV]] = load i32, i32* [[A_PTR]], align 4
; CHECK-NEXT:    [[B_PTR:%.*]] = getelementptr inbounds [5 x i32], [5 x i32]* @B, i64 0, i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[SCALAR_RECUR]], i32* [[B_PTR]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 5
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT]], label [[LOOP]], [[LOOP2:!llvm.loop !.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                    ; preds = %loop, %entry
  %rec = phi i32 [ 0, %entry], [ %lv, %loop ]
  %indvars.iv = phi i64 [ 0, %entry], [ %indvars.iv.next, %loop ]
  %A.ptr= getelementptr inbounds [5 x i32], [5 x i32]* @A, i64 0, i64 %indvars.iv
  %lv = load i32, i32* %A.ptr, align 4
  %B.ptr = getelementptr inbounds [5 x i32], [5 x i32]* @B, i64 0, i64 %indvars.iv
  store i32 %rec, i32* %B.ptr, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 5
  br i1 %exitcond, label %exit, label %loop

exit:                                             ; preds = %loop
  ret void
}
