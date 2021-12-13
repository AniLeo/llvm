; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -licm -loop-vectorize -force-vector-width=4 -dce -instcombine -licm -S | FileCheck %s

; First licm pass is to hoist/sink invariant stores if possible. Today LICM does
; not hoist/sink the invariant stores. Even if that changes, we should still
; vectorize this loop in case licm is not run.

; The next licm pass after vectorization is to hoist/sink loop invariant
; instructions.
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"

; all tests check that it is legal to vectorize the stores to invariant
; address.


; memory check is found.conflict = b[max(n-1,1)] > a && (i8* a)+1 > (i8* b)


define i32 @inv_val_store_to_inv_address_with_reduction(i32* %a, i64 %n, i32* %b) {
; CHECK-LABEL: @inv_val_store_to_inv_address_with_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[SMAX6:%.*]] = call i64 @llvm.smax.i64(i64 [[N]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX6]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 1
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N]], i64 1)
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i32, i32* [[B:%.*]], i64 [[SMAX]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i32* [[SCEVGEP4]], [[A]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i32* [[SCEVGEP]], [[B]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX6]], 9223372036854775804
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP2]] = add <4 x i32> [[VEC_PHI]], [[WIDE_LOAD]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP3]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[DOTLCSSA:%.*]] = phi <4 x i32> [ [[TMP2]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[DOTLCSSA]])
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX6]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ [[TMP4]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[I0:%.*]] = phi i32 [ [[I3:%.*]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[I1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[I2:%.*]] = load i32, i32* [[I1]], align 8
; CHECK-NEXT:    [[I3]] = add i32 [[I0]], [[I2]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    [[I3_LCSSA:%.*]] = phi i32 [ [[I3]], [[FOR_BODY]] ]
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[I4:%.*]] = phi i32 [ [[TMP4]], [[MIDDLE_BLOCK]] ], [ [[I3_LCSSA]], [[FOR_END_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[I4]]
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %i0 = phi i32 [ %i3, %for.body ], [ 0, %entry ]
  %i1 = getelementptr inbounds i32, i32* %b, i64 %i
  %i2 = load i32, i32* %i1, align 8
  %i3 = add i32 %i0, %i2
  store i32 %ntrunc, i32* %a
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %i4 = phi i32 [ %i3, %for.body ]
  ret i32 %i4
}

define void @inv_val_store_to_inv_address(i32* %a, i64 %n, i32* %b) {
; CHECK-LABEL: @inv_val_store_to_inv_address(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[SMAX6:%.*]] = call i64 @llvm.smax.i64(i64 [[N]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX6]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 1
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N]], i64 1)
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i32, i32* [[B:%.*]], i64 [[SMAX]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i32* [[SCEVGEP4]], [[A]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i32* [[SCEVGEP]], [[B]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX6]], 9223372036854775804
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4, !alias.scope !8, !noalias !11
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[BROADCAST_SPLAT]], <4 x i32>* [[TMP1]], align 4, !alias.scope !11
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP2]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX6]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[I1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[I1]], align 4
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]], !llvm.loop [[LOOP14:![0-9]+]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %i1 = getelementptr inbounds i32, i32* %b, i64 %i
  %i2 = load i32, i32* %i1, align 8
  store i32 %ntrunc, i32* %a
  store i32 %ntrunc, i32* %i1
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}


; Both of these tests below are handled as predicated stores.

; Conditional store
; if (b[i] == k) a = ntrunc
; TODO: We can be better with the code gen for the first test and we can have
; just one scalar store if vector.or.reduce(vector_cmp(b[i] == k)) is 1.



define void @inv_val_store_to_inv_address_conditional(i32* %a, i64 %n, i32* %b, i32 %k) {
; CHECK-LABEL: @inv_val_store_to_inv_address_conditional(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[SMAX6:%.*]] = call i64 @llvm.smax.i64(i64 [[N]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX6]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N]], i64 1)
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[B:%.*]], i64 [[SMAX]]
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 1
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i32* [[SCEVGEP4]], [[B]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i32* [[SCEVGEP]], [[A]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX6]], 9223372036854775804
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[K:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT7:%.*]] = insertelement <4 x i32> poison, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT8:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT7]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE14:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 8, !alias.scope !15, !noalias !18
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <4 x i32> [[WIDE_LOAD]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP0]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[BROADCAST_SPLAT8]], <4 x i32>* [[TMP3]], align 4, !alias.scope !15, !noalias !18
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i1> [[TMP2]], i32 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4, !alias.scope !18
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i1> [[TMP2]], i32 1
; CHECK-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF9:%.*]], label [[PRED_STORE_CONTINUE10:%.*]]
; CHECK:       pred.store.if9:
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4, !alias.scope !18
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE10]]
; CHECK:       pred.store.continue10:
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x i1> [[TMP2]], i32 2
; CHECK-NEXT:    br i1 [[TMP6]], label [[PRED_STORE_IF11:%.*]], label [[PRED_STORE_CONTINUE12:%.*]]
; CHECK:       pred.store.if11:
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4, !alias.scope !18
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE12]]
; CHECK:       pred.store.continue12:
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i1> [[TMP2]], i32 3
; CHECK-NEXT:    br i1 [[TMP7]], label [[PRED_STORE_IF13:%.*]], label [[PRED_STORE_CONTINUE14]]
; CHECK:       pred.store.if13:
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4, !alias.scope !18
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE14]]
; CHECK:       pred.store.continue14:
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP20:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX6]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[LATCH:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[I1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[I2:%.*]] = load i32, i32* [[I1]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[I2]], [[K]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[I1]], align 4
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_STORE:%.*]], label [[LATCH]]
; CHECK:       cond_store:
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]], !llvm.loop [[LOOP21:![0-9]+]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %latch ], [ 0, %entry ]
  %i1 = getelementptr inbounds i32, i32* %b, i64 %i
  %i2 = load i32, i32* %i1, align 8
  %cmp = icmp eq i32 %i2, %k
  store i32 %ntrunc, i32* %i1
  br i1 %cmp, label %cond_store, label %latch

cond_store:
  store i32 %ntrunc, i32* %a
  br label %latch

latch:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}

; if (b[i] == k)
;    a = ntrunc
; else a = k;
; TODO: We could vectorize this once we support multiple uniform stores to the
; same address.
define void @inv_val_store_to_inv_address_conditional_diff_values(i32* %a, i64 %n, i32* %b, i32 %k) {
; CHECK-LABEL: @inv_val_store_to_inv_address_conditional_diff_values(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[LATCH:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[I1:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[I]]
; CHECK-NEXT:    [[I2:%.*]] = load i32, i32* [[I1]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[I2]], [[K:%.*]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[I1]], align 4
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_STORE:%.*]], label [[COND_STORE_K:%.*]]
; CHECK:       cond_store:
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       cond_store_k:
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[STOREMERGE:%.*]] = phi i32 [ [[K]], [[COND_STORE_K]] ], [ [[NTRUNC]], [[COND_STORE]] ]
; CHECK-NEXT:    store i32 [[STOREMERGE]], i32* [[A:%.*]], align 4
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %latch ], [ 0, %entry ]
  %i1 = getelementptr inbounds i32, i32* %b, i64 %i
  %i2 = load i32, i32* %i1, align 8
  %cmp = icmp eq i32 %i2, %k
  store i32 %ntrunc, i32* %i1
  br i1 %cmp, label %cond_store, label %cond_store_k

cond_store:
  store i32 %ntrunc, i32* %a
  br label %latch

cond_store_k:
  store i32 %k, i32 * %a
  br label %latch

latch:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}

; Multiple variant stores to the same uniform address
; We do not vectorize such loops currently.
;  for(; i < itr; i++) {
;    for(; j < itr; j++) {
;      var1[i] = var2[j] + var1[i];
;      var1[i]++;
;    }
;  }

define i32 @multiple_uniform_stores(i32* nocapture %var1, i32* nocapture readonly %var2, i32 %itr) #0 {
; CHECK-LABEL: @multiple_uniform_stores(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP20:%.*]] = icmp eq i32 [[ITR:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP20]], label [[FOR_END10:%.*]], label [[FOR_COND1_PREHEADER_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader.preheader:
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    [[INDVARS_IV23:%.*]] = phi i64 [ [[INDVARS_IV_NEXT24:%.*]], [[FOR_INC8:%.*]] ], [ 0, [[FOR_COND1_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[J_022:%.*]] = phi i32 [ [[J_1_LCSSA:%.*]], [[FOR_INC8]] ], [ 0, [[FOR_COND1_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[CMP218:%.*]] = icmp ult i32 [[J_022]], [[ITR]]
; CHECK-NEXT:    br i1 [[CMP218]], label [[FOR_BODY3_LR_PH:%.*]], label [[FOR_INC8]]
; CHECK:       for.body3.lr.ph:
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[VAR1:%.*]], i64 [[INDVARS_IV23]]
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[J_022]] to i64
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP0]], [[FOR_BODY3_LR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY3]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[VAR2:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw i32 [[ADD]], 1
; CHECK-NEXT:    store i32 [[TMP3]], i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[LFTR_WIDEIV:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[LFTR_WIDEIV]], [[ITR]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_INC8_LOOPEXIT:%.*]], label [[FOR_BODY3]]
; CHECK:       for.inc8.loopexit:
; CHECK-NEXT:    br label [[FOR_INC8]]
; CHECK:       for.inc8:
; CHECK-NEXT:    [[J_1_LCSSA]] = phi i32 [ [[J_022]], [[FOR_COND1_PREHEADER]] ], [ [[ITR]], [[FOR_INC8_LOOPEXIT]] ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT24]] = add nuw nsw i64 [[INDVARS_IV23]], 1
; CHECK-NEXT:    [[LFTR_WIDEIV25:%.*]] = trunc i64 [[INDVARS_IV_NEXT24]] to i32
; CHECK-NEXT:    [[EXITCOND26:%.*]] = icmp eq i32 [[LFTR_WIDEIV25]], [[ITR]]
; CHECK-NEXT:    br i1 [[EXITCOND26]], label [[FOR_END10_LOOPEXIT:%.*]], label [[FOR_COND1_PREHEADER]]
; CHECK:       for.end10.loopexit:
; CHECK-NEXT:    br label [[FOR_END10]]
; CHECK:       for.end10:
; CHECK-NEXT:    ret i32 undef
;
entry:
  %cmp20 = icmp eq i32 %itr, 0
  br i1 %cmp20, label %for.end10, label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %entry, %for.inc8
  %indvars.iv23 = phi i64 [ %indvars.iv.next24, %for.inc8 ], [ 0, %entry ]
  %j.022 = phi i32 [ %j.1.lcssa, %for.inc8 ], [ 0, %entry ]
  %cmp218 = icmp ult i32 %j.022, %itr
  br i1 %cmp218, label %for.body3.lr.ph, label %for.inc8

for.body3.lr.ph:                                  ; preds = %for.cond1.preheader
  %arrayidx5 = getelementptr inbounds i32, i32* %var1, i64 %indvars.iv23
  %0 = zext i32 %j.022 to i64
  br label %for.body3

for.body3:                                        ; preds = %for.body3, %for.body3.lr.ph
  %indvars.iv = phi i64 [ %0, %for.body3.lr.ph ], [ %indvars.iv.next, %for.body3 ]
  %arrayidx = getelementptr inbounds i32, i32* %var2, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx, align 4
  %2 = load i32, i32* %arrayidx5, align 4
  %add = add nsw i32 %2, %1
  store i32 %add, i32* %arrayidx5, align 4
  %3 = load i32, i32* %arrayidx5, align 4
  %4 = add nsw i32 %3, 1
  store i32 %4, i32* %arrayidx5, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %itr
  br i1 %exitcond, label %for.inc8, label %for.body3

for.inc8:                                         ; preds = %for.body3, %for.cond1.preheader
  %j.1.lcssa = phi i32 [ %j.022, %for.cond1.preheader ], [ %itr, %for.body3 ]
  %indvars.iv.next24 = add nuw nsw i64 %indvars.iv23, 1
  %lftr.wideiv25 = trunc i64 %indvars.iv.next24 to i32
  %exitcond26 = icmp eq i32 %lftr.wideiv25, %itr
  br i1 %exitcond26, label %for.end10, label %for.cond1.preheader

for.end10:                                        ; preds = %for.inc8, %entry
  ret i32 undef
}

; second uniform store to the same address is conditional.
; we do not vectorize this.
define i32 @multiple_uniform_stores_conditional(i32* nocapture %var1, i32* nocapture readonly %var2, i32 %itr) #0 {
; CHECK-LABEL: @multiple_uniform_stores_conditional(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP20:%.*]] = icmp eq i32 [[ITR:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP20]], label [[FOR_END10:%.*]], label [[FOR_COND1_PREHEADER_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader.preheader:
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    [[INDVARS_IV23:%.*]] = phi i64 [ [[INDVARS_IV_NEXT24:%.*]], [[FOR_INC8:%.*]] ], [ 0, [[FOR_COND1_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[J_022:%.*]] = phi i32 [ [[J_1_LCSSA:%.*]], [[FOR_INC8]] ], [ 0, [[FOR_COND1_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[CMP218:%.*]] = icmp ult i32 [[J_022]], [[ITR]]
; CHECK-NEXT:    br i1 [[CMP218]], label [[FOR_BODY3_LR_PH:%.*]], label [[FOR_INC8]]
; CHECK:       for.body3.lr.ph:
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[VAR1:%.*]], i64 [[INDVARS_IV23]]
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[J_022]] to i64
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP0]], [[FOR_BODY3_LR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[VAR2:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt i32 [[ADD]], 42
; CHECK-NEXT:    br i1 [[TMP3]], label [[COND_STORE:%.*]], label [[LATCH]]
; CHECK:       cond_store:
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw i32 [[ADD]], 1
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[STOREMERGE:%.*]] = phi i32 [ [[TMP4]], [[COND_STORE]] ], [ [[ADD]], [[FOR_BODY3]] ]
; CHECK-NEXT:    store i32 [[STOREMERGE]], i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[LFTR_WIDEIV:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[LFTR_WIDEIV]], [[ITR]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_INC8_LOOPEXIT:%.*]], label [[FOR_BODY3]]
; CHECK:       for.inc8.loopexit:
; CHECK-NEXT:    br label [[FOR_INC8]]
; CHECK:       for.inc8:
; CHECK-NEXT:    [[J_1_LCSSA]] = phi i32 [ [[J_022]], [[FOR_COND1_PREHEADER]] ], [ [[ITR]], [[FOR_INC8_LOOPEXIT]] ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT24]] = add nuw nsw i64 [[INDVARS_IV23]], 1
; CHECK-NEXT:    [[LFTR_WIDEIV25:%.*]] = trunc i64 [[INDVARS_IV_NEXT24]] to i32
; CHECK-NEXT:    [[EXITCOND26:%.*]] = icmp eq i32 [[LFTR_WIDEIV25]], [[ITR]]
; CHECK-NEXT:    br i1 [[EXITCOND26]], label [[FOR_END10_LOOPEXIT:%.*]], label [[FOR_COND1_PREHEADER]]
; CHECK:       for.end10.loopexit:
; CHECK-NEXT:    br label [[FOR_END10]]
; CHECK:       for.end10:
; CHECK-NEXT:    ret i32 undef
;
entry:
  %cmp20 = icmp eq i32 %itr, 0
  br i1 %cmp20, label %for.end10, label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %entry, %for.inc8
  %indvars.iv23 = phi i64 [ %indvars.iv.next24, %for.inc8 ], [ 0, %entry ]
  %j.022 = phi i32 [ %j.1.lcssa, %for.inc8 ], [ 0, %entry ]
  %cmp218 = icmp ult i32 %j.022, %itr
  br i1 %cmp218, label %for.body3.lr.ph, label %for.inc8

for.body3.lr.ph:                                  ; preds = %for.cond1.preheader
  %arrayidx5 = getelementptr inbounds i32, i32* %var1, i64 %indvars.iv23
  %0 = zext i32 %j.022 to i64
  br label %for.body3

for.body3:                                        ; preds = %for.body3, %for.body3.lr.ph
  %indvars.iv = phi i64 [ %0, %for.body3.lr.ph ], [ %indvars.iv.next, %latch ]
  %arrayidx = getelementptr inbounds i32, i32* %var2, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx, align 4
  %2 = load i32, i32* %arrayidx5, align 4
  %add = add nsw i32 %2, %1
  store i32 %add, i32* %arrayidx5, align 4
  %3 = load i32, i32* %arrayidx5, align 4
  %4 = add nsw i32 %3, 1
  %5 = icmp ugt i32 %3, 42
  br i1 %5, label %cond_store, label %latch

cond_store:
  store i32 %4, i32* %arrayidx5, align 4
  br label %latch

latch:
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %itr
  br i1 %exitcond, label %for.inc8, label %for.body3

for.inc8:                                         ; preds = %for.body3, %for.cond1.preheader
  %j.1.lcssa = phi i32 [ %j.022, %for.cond1.preheader ], [ %itr, %latch ]
  %indvars.iv.next24 = add nuw nsw i64 %indvars.iv23, 1
  %lftr.wideiv25 = trunc i64 %indvars.iv.next24 to i32
  %exitcond26 = icmp eq i32 %lftr.wideiv25, %itr
  br i1 %exitcond26, label %for.end10, label %for.cond1.preheader

for.end10:                                        ; preds = %for.inc8, %entry
  ret i32 undef
}

; cannot vectorize loop with unsafe dependency between uniform load (%i10) and store
; (%i12) to the same address
; PR39653
; Note: %i10 could be replaced by phi(%arg4, %i12), a potentially vectorizable
; 1st-order-recurrence
define void @unsafe_dep_uniform_load_store(i32 %arg, i32 %arg1, i64 %arg2, i16* %arg3, i32 %arg4, i64 %arg5) {
; CHECK-LABEL: @unsafe_dep_uniform_load_store(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[I6:%.*]] = getelementptr inbounds i16, i16* [[ARG3:%.*]], i64 [[ARG5:%.*]]
; CHECK-NEXT:    br label [[BB7:%.*]]
; CHECK:       bb7:
; CHECK-NEXT:    [[I121:%.*]] = phi i32 [ [[ARG4:%.*]], [[BB:%.*]] ], [ [[I12:%.*]], [[BB7]] ]
; CHECK-NEXT:    [[I8:%.*]] = phi i64 [ 0, [[BB]] ], [ [[I24:%.*]], [[BB7]] ]
; CHECK-NEXT:    [[I9:%.*]] = phi i32 [ [[ARG1:%.*]], [[BB]] ], [ [[I23:%.*]], [[BB7]] ]
; CHECK-NEXT:    [[I11:%.*]] = mul nsw i32 [[I9]], [[I121]]
; CHECK-NEXT:    [[I12]] = srem i32 [[I11]], 65536
; CHECK-NEXT:    [[I13:%.*]] = add nsw i32 [[I12]], [[I9]]
; CHECK-NEXT:    [[I14:%.*]] = trunc i32 [[I13]] to i16
; CHECK-NEXT:    [[I15:%.*]] = trunc i64 [[I8]] to i32
; CHECK-NEXT:    [[I16:%.*]] = add i32 [[I15]], [[ARG:%.*]]
; CHECK-NEXT:    [[I17:%.*]] = zext i32 [[I16]] to i64
; CHECK-NEXT:    [[I18:%.*]] = getelementptr inbounds i16, i16* [[I6]], i64 [[I17]]
; CHECK-NEXT:    store i16 [[I14]], i16* [[I18]], align 2
; CHECK-NEXT:    [[I19:%.*]] = add i32 [[I13]], [[I9]]
; CHECK-NEXT:    [[I20:%.*]] = trunc i32 [[I19]] to i16
; CHECK-NEXT:    [[I21:%.*]] = and i16 [[I20]], 255
; CHECK-NEXT:    [[I22:%.*]] = getelementptr inbounds i16, i16* [[ARG3]], i64 [[I17]]
; CHECK-NEXT:    store i16 [[I21]], i16* [[I22]], align 2
; CHECK-NEXT:    [[I23]] = add nsw i32 [[I9]], 1
; CHECK-NEXT:    [[I24]] = add nuw nsw i64 [[I8]], 1
; CHECK-NEXT:    [[I25:%.*]] = icmp eq i64 [[I24]], [[ARG2:%.*]]
; CHECK-NEXT:    br i1 [[I25]], label [[BB26:%.*]], label [[BB7]]
; CHECK:       bb26:
; CHECK-NEXT:    ret void
;
bb:
  %i = alloca i32
  store i32 %arg4, i32* %i
  %i6 = getelementptr inbounds i16, i16* %arg3, i64 %arg5
  br label %bb7

bb7:
  %i8 = phi i64 [ 0, %bb ], [ %i24, %bb7 ]
  %i9 = phi i32 [ %arg1, %bb ], [ %i23, %bb7 ]
  %i10 = load i32, i32* %i
  %i11 = mul nsw i32 %i9, %i10
  %i12 = srem i32 %i11, 65536
  %i13 = add nsw i32 %i12, %i9
  %i14 = trunc i32 %i13 to i16
  %i15 = trunc i64 %i8 to i32
  %i16 = add i32 %arg, %i15
  %i17 = zext i32 %i16 to i64
  %i18 = getelementptr inbounds i16, i16* %i6, i64 %i17
  store i16 %i14, i16* %i18, align 2
  %i19 = add i32 %i13, %i9
  %i20 = trunc i32 %i19 to i16
  %i21 = and i16 %i20, 255
  %i22 = getelementptr inbounds i16, i16* %arg3, i64 %i17
  store i16 %i21, i16* %i22, align 2
  %i23 = add nsw i32 %i9, 1
  %i24 = add nuw nsw i64 %i8, 1
  %i25 = icmp eq i64 %i24, %arg2
  store i32 %i12, i32* %i
  br i1 %i25, label %bb26, label %bb7

bb26:
  ret void
}

; Make sure any check-not directives are not triggered by function declarations.
