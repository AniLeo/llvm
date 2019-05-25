; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -vectorize-num-stores-pred=1 -force-vector-width=1 -force-vector-interleave=2 -loop-vectorize -verify-loop-info -simplifycfg < %s | FileCheck %s --check-prefix=UNROLL
; RUN: opt -S -vectorize-num-stores-pred=1 -force-vector-width=1 -force-vector-interleave=2 -loop-vectorize -verify-loop-info < %s | FileCheck %s --check-prefix=UNROLL-NOSIMPLIFY
; RUN: opt -S -vectorize-num-stores-pred=1 -force-vector-width=2 -force-vector-interleave=1 -loop-vectorize -verify-loop-info -simplifycfg < %s | FileCheck %s --check-prefix=VEC

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; Test predication of stores.
define i32 @test(i32* nocapture %f) #0 {
; UNROLL-LABEL: @test(
; UNROLL-NEXT:  entry:
; UNROLL-NEXT:    br label [[VECTOR_BODY:%.*]]
; UNROLL:       vector.body:
; UNROLL-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE3:%.*]] ]
; UNROLL-NEXT:    [[INDUCTION:%.*]] = add i64 [[INDEX]], 0
; UNROLL-NEXT:    [[INDUCTION1:%.*]] = add i64 [[INDEX]], 1
; UNROLL-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[F:%.*]], i64 [[INDUCTION]]
; UNROLL-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[F]], i64 [[INDUCTION1]]
; UNROLL-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]], align 4
; UNROLL-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]], align 4
; UNROLL-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[TMP2]], 100
; UNROLL-NEXT:    [[TMP5:%.*]] = icmp sgt i32 [[TMP3]], 100
; UNROLL-NEXT:    br i1 [[TMP4]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; UNROLL:       pred.store.if:
; UNROLL-NEXT:    [[TMP6:%.*]] = add nsw i32 [[TMP2]], 20
; UNROLL-NEXT:    store i32 [[TMP6]], i32* [[TMP0]], align 4
; UNROLL-NEXT:    br label [[PRED_STORE_CONTINUE]]
; UNROLL:       pred.store.continue:
; UNROLL-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF2:%.*]], label [[PRED_STORE_CONTINUE3]]
; UNROLL:       pred.store.if2:
; UNROLL-NEXT:    [[TMP7:%.*]] = add nsw i32 [[TMP3]], 20
; UNROLL-NEXT:    store i32 [[TMP7]], i32* [[TMP1]], align 4
; UNROLL-NEXT:    br label [[PRED_STORE_CONTINUE3]]
; UNROLL:       pred.store.continue3:
; UNROLL-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; UNROLL-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], 128
; UNROLL-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; UNROLL:       middle.block:
; UNROLL-NEXT:    [[CMP_N:%.*]] = icmp eq i64 128, 128
; UNROLL-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[FOR_BODY:%.*]]
; UNROLL:       for.body:
; UNROLL-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ], [ 128, [[MIDDLE_BLOCK]] ]
; UNROLL-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[F]], i64 [[INDVARS_IV]]
; UNROLL-NEXT:    [[TMP9:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; UNROLL-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[TMP9]], 100
; UNROLL-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; UNROLL:       if.then:
; UNROLL-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP9]], 20
; UNROLL-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX]], align 4
; UNROLL-NEXT:    br label [[FOR_INC]]
; UNROLL:       for.inc:
; UNROLL-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; UNROLL-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 128
; UNROLL-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !2
; UNROLL:       for.end:
; UNROLL-NEXT:    ret i32 0
;
; UNROLL-NOSIMPLIFY-LABEL: @test(
; UNROLL-NOSIMPLIFY-NEXT:  entry:
; UNROLL-NOSIMPLIFY-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; UNROLL-NOSIMPLIFY:       vector.ph:
; UNROLL-NOSIMPLIFY-NEXT:    br label [[VECTOR_BODY:%.*]]
; UNROLL-NOSIMPLIFY:       vector.body:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE3:%.*]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION:%.*]] = add i64 [[INDEX]], 0
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION1:%.*]] = add i64 [[INDEX]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[F:%.*]], i64 [[INDUCTION]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[F]], i64 [[INDUCTION1]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[TMP2]], 100
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP5:%.*]] = icmp sgt i32 [[TMP3]], 100
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[TMP4]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; UNROLL-NOSIMPLIFY:       pred.store.if:
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP6:%.*]] = add nsw i32 [[TMP2]], 20
; UNROLL-NOSIMPLIFY-NEXT:    store i32 [[TMP6]], i32* [[TMP0]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    br label [[PRED_STORE_CONTINUE]]
; UNROLL-NOSIMPLIFY:       pred.store.continue:
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF2:%.*]], label [[PRED_STORE_CONTINUE3]]
; UNROLL-NOSIMPLIFY:       pred.store.if2:
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP7:%.*]] = add nsw i32 [[TMP3]], 20
; UNROLL-NOSIMPLIFY-NEXT:    store i32 [[TMP7]], i32* [[TMP1]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    br label [[PRED_STORE_CONTINUE3]]
; UNROLL-NOSIMPLIFY:       pred.store.continue3:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], 128
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; UNROLL-NOSIMPLIFY:       middle.block:
; UNROLL-NOSIMPLIFY-NEXT:    [[CMP_N:%.*]] = icmp eq i64 128, 128
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; UNROLL-NOSIMPLIFY:       scalar.ph:
; UNROLL-NOSIMPLIFY-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 128, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_BODY:%.*]]
; UNROLL-NOSIMPLIFY:       for.body:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[F]], i64 [[INDVARS_IV]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP9:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[TMP9]], 100
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; UNROLL-NOSIMPLIFY:       if.then:
; UNROLL-NOSIMPLIFY-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP9]], 20
; UNROLL-NOSIMPLIFY-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_INC]]
; UNROLL-NOSIMPLIFY:       for.inc:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 128
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !2
; UNROLL-NOSIMPLIFY:       for.end:
; UNROLL-NOSIMPLIFY-NEXT:    ret i32 0
;
; VEC-LABEL: @test(
; VEC-NEXT:  entry:
; VEC-NEXT:    br label [[VECTOR_BODY:%.*]]
; VEC:       vector.body:
; VEC-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE2:%.*]] ]
; VEC-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> undef, i64 [[INDEX]], i32 0
; VEC-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> undef, <2 x i32> zeroinitializer
; VEC-NEXT:    [[INDUCTION:%.*]] = add <2 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1>
; VEC-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; VEC-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[F:%.*]], i64 [[TMP0]]
; VEC-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; VEC-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <2 x i32>*
; VEC-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i32>, <2 x i32>* [[TMP3]], align 4
; VEC-NEXT:    [[TMP4:%.*]] = icmp sgt <2 x i32> [[WIDE_LOAD]], <i32 100, i32 100>
; VEC-NEXT:    [[TMP5:%.*]] = extractelement <2 x i1> [[TMP4]], i32 0
; VEC-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; VEC:       pred.store.if:
; VEC-NEXT:    [[TMP6:%.*]] = extractelement <2 x i32> [[WIDE_LOAD]], i32 0
; VEC-NEXT:    [[TMP7:%.*]] = add nsw i32 [[TMP6]], 20
; VEC-NEXT:    store i32 [[TMP7]], i32* [[TMP1]], align 4
; VEC-NEXT:    br label [[PRED_STORE_CONTINUE]]
; VEC:       pred.store.continue:
; VEC-NEXT:    [[TMP8:%.*]] = extractelement <2 x i1> [[TMP4]], i32 1
; VEC-NEXT:    br i1 [[TMP8]], label [[PRED_STORE_IF1:%.*]], label [[PRED_STORE_CONTINUE2]]
; VEC:       pred.store.if1:
; VEC-NEXT:    [[TMP9:%.*]] = extractelement <2 x i32> [[WIDE_LOAD]], i32 1
; VEC-NEXT:    [[TMP10:%.*]] = add nsw i32 [[TMP9]], 20
; VEC-NEXT:    [[TMP11:%.*]] = add i64 [[INDEX]], 1
; VEC-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[F]], i64 [[TMP11]]
; VEC-NEXT:    store i32 [[TMP10]], i32* [[TMP12]], align 4
; VEC-NEXT:    br label [[PRED_STORE_CONTINUE2]]
; VEC:       pred.store.continue2:
; VEC-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; VEC-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[INDEX_NEXT]], 128
; VEC-NEXT:    br i1 [[TMP13]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; VEC:       middle.block:
; VEC-NEXT:    [[CMP_N:%.*]] = icmp eq i64 128, 128
; VEC-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[FOR_BODY:%.*]]
; VEC:       for.body:
; VEC-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ], [ 128, [[MIDDLE_BLOCK]] ]
; VEC-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[F]], i64 [[INDVARS_IV]]
; VEC-NEXT:    [[TMP14:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; VEC-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[TMP14]], 100
; VEC-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; VEC:       if.then:
; VEC-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP14]], 20
; VEC-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX]], align 4
; VEC-NEXT:    br label [[FOR_INC]]
; VEC:       for.inc:
; VEC-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; VEC-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 128
; VEC-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !2
; VEC:       for.end:
; VEC-NEXT:    ret i32 0
;
entry:
  br label %for.body



for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
  %arrayidx = getelementptr inbounds i32, i32* %f, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp sgt i32 %0, 100
  br i1 %cmp1, label %if.then, label %for.inc

if.then:
  %add = add nsw i32 %0, 20
  store i32 %add, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 128
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret i32 0
}

; Track basic blocks when unrolling conditional blocks. This code used to assert
; because we did not update the phi nodes with the proper predecessor in the
; vectorized loop body.
; PR18724

define void @bug18724(i1 %cond) {
; UNROLL-LABEL: @bug18724(
; UNROLL-NEXT:  entry:
; UNROLL-NEXT:    [[TMP0:%.*]] = xor i1 [[COND:%.*]], true
; UNROLL-NEXT:    call void @llvm.assume(i1 [[TMP0]])
; UNROLL-NEXT:    br label [[FOR_BODY14:%.*]]
; UNROLL:       for.body14:
; UNROLL-NEXT:    [[INDVARS_IV3:%.*]] = phi i64 [ [[INDVARS_IV_NEXT4:%.*]], [[FOR_INC23:%.*]] ], [ undef, [[ENTRY:%.*]] ]
; UNROLL-NEXT:    [[INEWCHUNKS_120:%.*]] = phi i32 [ [[INEWCHUNKS_2:%.*]], [[FOR_INC23]] ], [ undef, [[ENTRY]] ]
; UNROLL-NEXT:    [[ARRAYIDX16:%.*]] = getelementptr inbounds [768 x i32], [768 x i32]* undef, i64 0, i64 [[INDVARS_IV3]]
; UNROLL-NEXT:    [[TMP:%.*]] = load i32, i32* [[ARRAYIDX16]], align 4
; UNROLL-NEXT:    br i1 undef, label [[IF_THEN18:%.*]], label [[FOR_INC23]]
; UNROLL:       if.then18:
; UNROLL-NEXT:    store i32 2, i32* [[ARRAYIDX16]], align 4
; UNROLL-NEXT:    [[INC21:%.*]] = add nsw i32 [[INEWCHUNKS_120]], 1
; UNROLL-NEXT:    br label [[FOR_INC23]]
; UNROLL:       for.inc23:
; UNROLL-NEXT:    [[INEWCHUNKS_2]] = phi i32 [ [[INC21]], [[IF_THEN18]] ], [ [[INEWCHUNKS_120]], [[FOR_BODY14]] ]
; UNROLL-NEXT:    [[INDVARS_IV_NEXT4]] = add nsw i64 [[INDVARS_IV3]], 1
; UNROLL-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV3]] to i32
; UNROLL-NEXT:    [[CMP13:%.*]] = icmp slt i32 [[TMP1]], 0
; UNROLL-NEXT:    call void @llvm.assume(i1 [[CMP13]])
; UNROLL-NEXT:    br label [[FOR_BODY14]]
;
; UNROLL-NOSIMPLIFY-LABEL: @bug18724(
; UNROLL-NOSIMPLIFY-NEXT:  entry:
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_BODY9:%.*]]
; UNROLL-NOSIMPLIFY:       for.body9:
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[COND:%.*]], label [[FOR_INC26:%.*]], label [[FOR_BODY14_PREHEADER:%.*]]
; UNROLL-NOSIMPLIFY:       for.body14.preheader:
; UNROLL-NOSIMPLIFY-NEXT:    br i1 true, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; UNROLL-NOSIMPLIFY:       vector.ph:
; UNROLL-NOSIMPLIFY-NEXT:    br label [[VECTOR_BODY:%.*]]
; UNROLL-NOSIMPLIFY:       vector.body:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE4:%.*]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[VEC_PHI:%.*]] = phi i32 [ undef, [[VECTOR_PH]] ], [ [[PREDPHI:%.*]], [[PRED_STORE_CONTINUE4]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[VEC_PHI2:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[PREDPHI5:%.*]], [[PRED_STORE_CONTINUE4]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[OFFSET_IDX:%.*]] = add i64 undef, [[INDEX]]
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION:%.*]] = add i64 [[OFFSET_IDX]], 0
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION1:%.*]] = add i64 [[OFFSET_IDX]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [768 x i32], [768 x i32]* undef, i64 0, i64 [[INDUCTION]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [768 x i32], [768 x i32]* undef, i64 0, i64 [[INDUCTION1]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    br i1 undef, label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; UNROLL-NOSIMPLIFY:       pred.store.if:
; UNROLL-NOSIMPLIFY-NEXT:    store i32 2, i32* [[TMP0]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    br label [[PRED_STORE_CONTINUE]]
; UNROLL-NOSIMPLIFY:       pred.store.continue:
; UNROLL-NOSIMPLIFY-NEXT:    br i1 undef, label [[PRED_STORE_IF3:%.*]], label [[PRED_STORE_CONTINUE4]]
; UNROLL-NOSIMPLIFY:       pred.store.if3:
; UNROLL-NOSIMPLIFY-NEXT:    store i32 2, i32* [[TMP1]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    br label [[PRED_STORE_CONTINUE4]]
; UNROLL-NOSIMPLIFY:       pred.store.continue4:
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP4:%.*]] = add nsw i32 [[VEC_PHI]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP5:%.*]] = add nsw i32 [[VEC_PHI2]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[PREDPHI]] = select i1 undef, i32 [[VEC_PHI]], i32 [[TMP4]]
; UNROLL-NOSIMPLIFY-NEXT:    [[PREDPHI5]] = select i1 undef, i32 [[VEC_PHI2]], i32 [[TMP5]]
; UNROLL-NOSIMPLIFY-NEXT:    [[OFFSET_IDX6:%.*]] = add i64 undef, [[INDEX]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP6:%.*]] = trunc i64 [[OFFSET_IDX6]] to i32
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION7:%.*]] = add i32 [[TMP6]], 0
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION8:%.*]] = add i32 [[TMP6]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 0
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !3
; UNROLL-NOSIMPLIFY:       middle.block:
; UNROLL-NOSIMPLIFY-NEXT:    [[BIN_RDX:%.*]] = add i32 [[PREDPHI5]], [[PREDPHI]]
; UNROLL-NOSIMPLIFY-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1, 0
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[CMP_N]], label [[FOR_INC26_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; UNROLL-NOSIMPLIFY:       scalar.ph:
; UNROLL-NOSIMPLIFY-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ undef, [[MIDDLE_BLOCK]] ], [ undef, [[FOR_BODY14_PREHEADER]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ undef, [[FOR_BODY14_PREHEADER]] ], [ [[BIN_RDX]], [[MIDDLE_BLOCK]] ]
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_BODY14:%.*]]
; UNROLL-NOSIMPLIFY:       for.body14:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDVARS_IV3:%.*]] = phi i64 [ [[INDVARS_IV_NEXT4:%.*]], [[FOR_INC23:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[INEWCHUNKS_120:%.*]] = phi i32 [ [[INEWCHUNKS_2:%.*]], [[FOR_INC23]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[ARRAYIDX16:%.*]] = getelementptr inbounds [768 x i32], [768 x i32]* undef, i64 0, i64 [[INDVARS_IV3]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP:%.*]] = load i32, i32* [[ARRAYIDX16]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    br i1 undef, label [[IF_THEN18:%.*]], label [[FOR_INC23]]
; UNROLL-NOSIMPLIFY:       if.then18:
; UNROLL-NOSIMPLIFY-NEXT:    store i32 2, i32* [[ARRAYIDX16]], align 4
; UNROLL-NOSIMPLIFY-NEXT:    [[INC21:%.*]] = add nsw i32 [[INEWCHUNKS_120]], 1
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_INC23]]
; UNROLL-NOSIMPLIFY:       for.inc23:
; UNROLL-NOSIMPLIFY-NEXT:    [[INEWCHUNKS_2]] = phi i32 [ [[INC21]], [[IF_THEN18]] ], [ [[INEWCHUNKS_120]], [[FOR_BODY14]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[INDVARS_IV_NEXT4]] = add nsw i64 [[INDVARS_IV3]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV3]] to i32
; UNROLL-NOSIMPLIFY-NEXT:    [[CMP13:%.*]] = icmp slt i32 [[TMP1]], 0
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[CMP13]], label [[FOR_BODY14]], label [[FOR_INC26_LOOPEXIT]], !llvm.loop !4
; UNROLL-NOSIMPLIFY:       for.inc26.loopexit:
; UNROLL-NOSIMPLIFY-NEXT:    [[INEWCHUNKS_2_LCSSA:%.*]] = phi i32 [ [[INEWCHUNKS_2]], [[FOR_INC23]] ], [ [[BIN_RDX]], [[MIDDLE_BLOCK]] ]
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_INC26]]
; UNROLL-NOSIMPLIFY:       for.inc26:
; UNROLL-NOSIMPLIFY-NEXT:    [[INEWCHUNKS_1_LCSSA:%.*]] = phi i32 [ undef, [[FOR_BODY9]] ], [ [[INEWCHUNKS_2_LCSSA]], [[FOR_INC26_LOOPEXIT]] ]
; UNROLL-NOSIMPLIFY-NEXT:    unreachable
;
; VEC-LABEL: @bug18724(
; VEC-NEXT:  entry:
; VEC-NEXT:    [[TMP0:%.*]] = xor i1 [[COND:%.*]], true
; VEC-NEXT:    call void @llvm.assume(i1 [[TMP0]])
; VEC-NEXT:    br label [[FOR_BODY14:%.*]]
; VEC:       for.body14:
; VEC-NEXT:    [[INDVARS_IV3:%.*]] = phi i64 [ [[INDVARS_IV_NEXT4:%.*]], [[FOR_INC23:%.*]] ], [ undef, [[ENTRY:%.*]] ]
; VEC-NEXT:    [[INEWCHUNKS_120:%.*]] = phi i32 [ [[INEWCHUNKS_2:%.*]], [[FOR_INC23]] ], [ undef, [[ENTRY]] ]
; VEC-NEXT:    [[ARRAYIDX16:%.*]] = getelementptr inbounds [768 x i32], [768 x i32]* undef, i64 0, i64 [[INDVARS_IV3]]
; VEC-NEXT:    [[TMP:%.*]] = load i32, i32* [[ARRAYIDX16]], align 4
; VEC-NEXT:    br i1 undef, label [[IF_THEN18:%.*]], label [[FOR_INC23]]
; VEC:       if.then18:
; VEC-NEXT:    store i32 2, i32* [[ARRAYIDX16]], align 4
; VEC-NEXT:    [[INC21:%.*]] = add nsw i32 [[INEWCHUNKS_120]], 1
; VEC-NEXT:    br label [[FOR_INC23]]
; VEC:       for.inc23:
; VEC-NEXT:    [[INEWCHUNKS_2]] = phi i32 [ [[INC21]], [[IF_THEN18]] ], [ [[INEWCHUNKS_120]], [[FOR_BODY14]] ]
; VEC-NEXT:    [[INDVARS_IV_NEXT4]] = add nsw i64 [[INDVARS_IV3]], 1
; VEC-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV3]] to i32
; VEC-NEXT:    [[CMP13:%.*]] = icmp slt i32 [[TMP1]], 0
; VEC-NEXT:    call void @llvm.assume(i1 [[CMP13]])
; VEC-NEXT:    br label [[FOR_BODY14]]
;
entry:
  br label %for.body9

for.body9:
  br i1 %cond, label %for.inc26, label %for.body14

for.body14:
  %indvars.iv3 = phi i64 [ %indvars.iv.next4, %for.inc23 ], [ undef, %for.body9 ]
  %iNewChunks.120 = phi i32 [ %iNewChunks.2, %for.inc23 ], [ undef, %for.body9 ]
  %arrayidx16 = getelementptr inbounds [768 x i32], [768 x i32]* undef, i64 0, i64 %indvars.iv3
  %tmp = load i32, i32* %arrayidx16, align 4
  br i1 undef, label %if.then18, label %for.inc23

if.then18:
  store i32 2, i32* %arrayidx16, align 4
  %inc21 = add nsw i32 %iNewChunks.120, 1
  br label %for.inc23

for.inc23:
  %iNewChunks.2 = phi i32 [ %inc21, %if.then18 ], [ %iNewChunks.120, %for.body14 ]
  %indvars.iv.next4 = add nsw i64 %indvars.iv3, 1
  %tmp1 = trunc i64 %indvars.iv3 to i32
  %cmp13 = icmp slt i32 %tmp1, 0
  br i1 %cmp13, label %for.body14, label %for.inc26

for.inc26:
  %iNewChunks.1.lcssa = phi i32 [ undef, %for.body9 ], [ %iNewChunks.2, %for.inc23 ]
  unreachable
}

; In the test below, it's more profitable for the expression feeding the
; conditional store to remain scalar. Since we can only type-shrink vector
; types, we shouldn't try to represent the expression in a smaller type.
;
define void @minimal_bit_widths(i1 %c) {
; UNROLL-LABEL: @minimal_bit_widths(
; UNROLL-NEXT:  entry:
; UNROLL-NEXT:    br label [[VECTOR_BODY:%.*]]
; UNROLL:       vector.body:
; UNROLL-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE6:%.*]] ]
; UNROLL-NEXT:    [[OFFSET_IDX:%.*]] = sub i64 undef, [[INDEX]]
; UNROLL-NEXT:    [[INDUCTION3:%.*]] = add i64 [[OFFSET_IDX]], 0
; UNROLL-NEXT:    [[INDUCTION4:%.*]] = add i64 [[OFFSET_IDX]], -1
; UNROLL-NEXT:    br i1 [[C:%.*]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE6]]
; UNROLL:       pred.store.if:
; UNROLL-NEXT:    [[INDUCTION:%.*]] = add i64 [[INDEX]], 0
; UNROLL-NEXT:    [[TMP0:%.*]] = getelementptr i8, i8* undef, i64 [[INDUCTION]]
; UNROLL-NEXT:    [[TMP1:%.*]] = load i8, i8* [[TMP0]], align 1
; UNROLL-NEXT:    [[TMP2:%.*]] = zext i8 [[TMP1]] to i32
; UNROLL-NEXT:    [[TMP3:%.*]] = trunc i32 [[TMP2]] to i8
; UNROLL-NEXT:    store i8 [[TMP3]], i8* [[TMP0]], align 1
; UNROLL-NEXT:    [[INDUCTION2:%.*]] = add i64 [[INDEX]], 1
; UNROLL-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* undef, i64 [[INDUCTION2]]
; UNROLL-NEXT:    [[TMP5:%.*]] = load i8, i8* [[TMP4]], align 1
; UNROLL-NEXT:    [[TMP6:%.*]] = zext i8 [[TMP5]] to i32
; UNROLL-NEXT:    [[TMP7:%.*]] = trunc i32 [[TMP6]] to i8
; UNROLL-NEXT:    store i8 [[TMP7]], i8* [[TMP4]], align 1
; UNROLL-NEXT:    br label [[PRED_STORE_CONTINUE6]]
; UNROLL:       pred.store.continue6:
; UNROLL-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; UNROLL-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], undef
; UNROLL-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !3
; UNROLL:       middle.block:
; UNROLL-NEXT:    [[CMP_N:%.*]] = icmp eq i64 undef, undef
; UNROLL-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[FOR_BODY:%.*]]
; UNROLL:       for.body:
; UNROLL-NEXT:    [[TMP0:%.*]] = phi i64 [ [[TMP6:%.*]], [[FOR_INC:%.*]] ], [ undef, [[MIDDLE_BLOCK]] ]
; UNROLL-NEXT:    [[TMP1:%.*]] = phi i64 [ [[TMP7:%.*]], [[FOR_INC]] ], [ undef, [[MIDDLE_BLOCK]] ]
; UNROLL-NEXT:    [[TMP2:%.*]] = getelementptr i8, i8* undef, i64 [[TMP0]]
; UNROLL-NEXT:    [[TMP3:%.*]] = load i8, i8* [[TMP2]], align 1
; UNROLL-NEXT:    br i1 [[C]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; UNROLL:       if.then:
; UNROLL-NEXT:    [[TMP4:%.*]] = zext i8 [[TMP3]] to i32
; UNROLL-NEXT:    [[TMP5:%.*]] = trunc i32 [[TMP4]] to i8
; UNROLL-NEXT:    store i8 [[TMP5]], i8* [[TMP2]], align 1
; UNROLL-NEXT:    br label [[FOR_INC]]
; UNROLL:       for.inc:
; UNROLL-NEXT:    [[TMP6]] = add nuw nsw i64 [[TMP0]], 1
; UNROLL-NEXT:    [[TMP7]] = add i64 [[TMP1]], -1
; UNROLL-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[TMP7]], 0
; UNROLL-NEXT:    br i1 [[TMP8]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !4
; UNROLL:       for.end:
; UNROLL-NEXT:    ret void
;
; UNROLL-NOSIMPLIFY-LABEL: @minimal_bit_widths(
; UNROLL-NOSIMPLIFY-NEXT:  entry:
; UNROLL-NOSIMPLIFY-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; UNROLL-NOSIMPLIFY:       vector.ph:
; UNROLL-NOSIMPLIFY-NEXT:    br label [[VECTOR_BODY:%.*]]
; UNROLL-NOSIMPLIFY:       vector.body:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE6:%.*]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[OFFSET_IDX:%.*]] = sub i64 undef, [[INDEX]]
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION3:%.*]] = add i64 [[OFFSET_IDX]], 0
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION4:%.*]] = add i64 [[OFFSET_IDX]], -1
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[C:%.*]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; UNROLL-NOSIMPLIFY:       pred.store.if:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION:%.*]] = add i64 [[INDEX]], 0
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP0:%.*]] = getelementptr i8, i8* undef, i64 [[INDUCTION]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP1:%.*]] = load i8, i8* [[TMP0]], align 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP2:%.*]] = zext i8 [[TMP1]] to i32
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP3:%.*]] = trunc i32 [[TMP2]] to i8
; UNROLL-NOSIMPLIFY-NEXT:    store i8 [[TMP3]], i8* [[TMP0]], align 1
; UNROLL-NOSIMPLIFY-NEXT:    br label [[PRED_STORE_CONTINUE]]
; UNROLL-NOSIMPLIFY:       pred.store.continue:
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[C]], label [[PRED_STORE_IF5:%.*]], label [[PRED_STORE_CONTINUE6]]
; UNROLL-NOSIMPLIFY:       pred.store.if5:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDUCTION2:%.*]] = add i64 [[INDEX]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* undef, i64 [[INDUCTION2]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP5:%.*]] = load i8, i8* [[TMP4]], align 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP6:%.*]] = zext i8 [[TMP5]] to i32
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP7:%.*]] = trunc i32 [[TMP6]] to i8
; UNROLL-NOSIMPLIFY-NEXT:    store i8 [[TMP7]], i8* [[TMP4]], align 1
; UNROLL-NOSIMPLIFY-NEXT:    br label [[PRED_STORE_CONTINUE6]]
; UNROLL-NOSIMPLIFY:       pred.store.continue6:
; UNROLL-NOSIMPLIFY-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], undef
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !5
; UNROLL-NOSIMPLIFY:       middle.block:
; UNROLL-NOSIMPLIFY-NEXT:    [[CMP_N:%.*]] = icmp eq i64 undef, undef
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; UNROLL-NOSIMPLIFY:       scalar.ph:
; UNROLL-NOSIMPLIFY-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ undef, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i64 [ undef, [[MIDDLE_BLOCK]] ], [ undef, [[ENTRY]] ]
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_BODY:%.*]]
; UNROLL-NOSIMPLIFY:       for.body:
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP0:%.*]] = phi i64 [ [[TMP6:%.*]], [[FOR_INC:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP1:%.*]] = phi i64 [ [[TMP7:%.*]], [[FOR_INC]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP2:%.*]] = getelementptr i8, i8* undef, i64 [[TMP0]]
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP3:%.*]] = load i8, i8* [[TMP2]], align 1
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[C]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; UNROLL-NOSIMPLIFY:       if.then:
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP4:%.*]] = zext i8 [[TMP3]] to i32
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP5:%.*]] = trunc i32 [[TMP4]] to i8
; UNROLL-NOSIMPLIFY-NEXT:    store i8 [[TMP5]], i8* [[TMP2]], align 1
; UNROLL-NOSIMPLIFY-NEXT:    br label [[FOR_INC]]
; UNROLL-NOSIMPLIFY:       for.inc:
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP6]] = add nuw nsw i64 [[TMP0]], 1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP7]] = add i64 [[TMP1]], -1
; UNROLL-NOSIMPLIFY-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[TMP7]], 0
; UNROLL-NOSIMPLIFY-NEXT:    br i1 [[TMP8]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !6
; UNROLL-NOSIMPLIFY:       for.end:
; UNROLL-NOSIMPLIFY-NEXT:    ret void
;
; VEC-LABEL: @minimal_bit_widths(
; VEC-NEXT:  entry:
; VEC-NEXT:    [[BROADCAST_SPLATINSERT5:%.*]] = insertelement <2 x i1> undef, i1 [[C:%.*]], i32 0
; VEC-NEXT:    [[BROADCAST_SPLAT6:%.*]] = shufflevector <2 x i1> [[BROADCAST_SPLATINSERT5]], <2 x i1> undef, <2 x i32> zeroinitializer
; VEC-NEXT:    br label [[VECTOR_BODY:%.*]]
; VEC:       vector.body:
; VEC-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE8:%.*]] ]
; VEC-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> undef, i64 [[INDEX]], i32 0
; VEC-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> undef, <2 x i32> zeroinitializer
; VEC-NEXT:    [[INDUCTION:%.*]] = add <2 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1>
; VEC-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; VEC-NEXT:    [[OFFSET_IDX:%.*]] = sub i64 undef, [[INDEX]]
; VEC-NEXT:    [[BROADCAST_SPLATINSERT2:%.*]] = insertelement <2 x i64> undef, i64 [[OFFSET_IDX]], i32 0
; VEC-NEXT:    [[BROADCAST_SPLAT3:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT2]], <2 x i64> undef, <2 x i32> zeroinitializer
; VEC-NEXT:    [[INDUCTION4:%.*]] = add <2 x i64> [[BROADCAST_SPLAT3]], <i64 0, i64 -1>
; VEC-NEXT:    [[TMP1:%.*]] = add i64 [[OFFSET_IDX]], 0
; VEC-NEXT:    [[TMP2:%.*]] = getelementptr i8, i8* undef, i64 [[TMP0]]
; VEC-NEXT:    [[TMP3:%.*]] = getelementptr i8, i8* [[TMP2]], i32 0
; VEC-NEXT:    [[TMP4:%.*]] = bitcast i8* [[TMP3]] to <2 x i8>*
; VEC-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i8>, <2 x i8>* [[TMP4]], align 1
; VEC-NEXT:    [[TMP5:%.*]] = extractelement <2 x i1> [[BROADCAST_SPLAT6]], i32 0
; VEC-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; VEC:       pred.store.if:
; VEC-NEXT:    [[TMP6:%.*]] = extractelement <2 x i8> [[WIDE_LOAD]], i32 0
; VEC-NEXT:    [[TMP7:%.*]] = zext i8 [[TMP6]] to i32
; VEC-NEXT:    [[TMP8:%.*]] = trunc i32 [[TMP7]] to i8
; VEC-NEXT:    store i8 [[TMP8]], i8* [[TMP2]], align 1
; VEC-NEXT:    br label [[PRED_STORE_CONTINUE]]
; VEC:       pred.store.continue:
; VEC-NEXT:    [[TMP9:%.*]] = extractelement <2 x i1> [[BROADCAST_SPLAT6]], i32 1
; VEC-NEXT:    br i1 [[TMP9]], label [[PRED_STORE_IF7:%.*]], label [[PRED_STORE_CONTINUE8]]
; VEC:       pred.store.if7:
; VEC-NEXT:    [[TMP10:%.*]] = extractelement <2 x i8> [[WIDE_LOAD]], i32 1
; VEC-NEXT:    [[TMP11:%.*]] = zext i8 [[TMP10]] to i32
; VEC-NEXT:    [[TMP12:%.*]] = trunc i32 [[TMP11]] to i8
; VEC-NEXT:    [[TMP13:%.*]] = add i64 [[INDEX]], 1
; VEC-NEXT:    [[TMP14:%.*]] = getelementptr i8, i8* undef, i64 [[TMP13]]
; VEC-NEXT:    store i8 [[TMP12]], i8* [[TMP14]], align 1
; VEC-NEXT:    br label [[PRED_STORE_CONTINUE8]]
; VEC:       pred.store.continue8:
; VEC-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 2
; VEC-NEXT:    [[TMP15:%.*]] = icmp eq i64 [[INDEX_NEXT]], undef
; VEC-NEXT:    br i1 [[TMP15]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !4
; VEC:       middle.block:
; VEC-NEXT:    [[CMP_N:%.*]] = icmp eq i64 undef, undef
; VEC-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[FOR_BODY:%.*]]
; VEC:       for.body:
; VEC-NEXT:    [[TMP0:%.*]] = phi i64 [ [[TMP6:%.*]], [[FOR_INC:%.*]] ], [ undef, [[MIDDLE_BLOCK]] ]
; VEC-NEXT:    [[TMP1:%.*]] = phi i64 [ [[TMP7:%.*]], [[FOR_INC]] ], [ undef, [[MIDDLE_BLOCK]] ]
; VEC-NEXT:    [[TMP2:%.*]] = getelementptr i8, i8* undef, i64 [[TMP0]]
; VEC-NEXT:    [[TMP3:%.*]] = load i8, i8* [[TMP2]], align 1
; VEC-NEXT:    br i1 [[C]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; VEC:       if.then:
; VEC-NEXT:    [[TMP4:%.*]] = zext i8 [[TMP3]] to i32
; VEC-NEXT:    [[TMP5:%.*]] = trunc i32 [[TMP4]] to i8
; VEC-NEXT:    store i8 [[TMP5]], i8* [[TMP2]], align 1
; VEC-NEXT:    br label [[FOR_INC]]
; VEC:       for.inc:
; VEC-NEXT:    [[TMP6]] = add nuw nsw i64 [[TMP0]], 1
; VEC-NEXT:    [[TMP7]] = add i64 [[TMP1]], -1
; VEC-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[TMP7]], 0
; VEC-NEXT:    br i1 [[TMP8]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !5
; VEC:       for.end:
; VEC-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %tmp0 = phi i64 [ %tmp6, %for.inc ], [ 0, %entry ]
  %tmp1 = phi i64 [ %tmp7, %for.inc ], [ undef, %entry ]
  %tmp2 = getelementptr i8, i8* undef, i64 %tmp0
  %tmp3 = load i8, i8* %tmp2, align 1
  br i1 %c, label %if.then, label %for.inc

if.then:
  %tmp4 = zext i8 %tmp3 to i32
  %tmp5 = trunc i32 %tmp4 to i8
  store i8 %tmp5, i8* %tmp2, align 1
  br label %for.inc

for.inc:
  %tmp6 = add nuw nsw i64 %tmp0, 1
  %tmp7 = add i64 %tmp1, -1
  %tmp8 = icmp eq i64 %tmp7, 0
  br i1 %tmp8, label %for.end, label %for.body

for.end:
  ret void
}
