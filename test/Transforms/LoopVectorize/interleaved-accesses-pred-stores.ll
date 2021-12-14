; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-vectorize -instcombine -force-vector-width=2 -force-vector-interleave=1 -enable-interleaved-mem-accesses < %s | FileCheck %s
; RUN: opt -S -loop-vectorize -instcombine -force-vector-width=2 -force-vector-interleave=1 -enable-interleaved-mem-accesses -enable-masked-interleaved-mem-accesses < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"
%pair = type { i64, i64 }

; Ensure that we vectorize the interleaved load group even though the loop
; contains a conditional store. The store group contains gaps and is not
; vectorized.
;
;
;
;
;

define void @interleaved_with_cond_store_0(%pair *%p, i64 %x, i64 %n) {
; CHECK-LABEL: @interleaved_with_cond_store_0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 3
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = and i64 [[SMAX]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[TMP0]], i64 2, i64 [[N_MOD_VF]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub nsw i64 [[SMAX]], [[TMP1]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[X:%.*]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE2:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [[PAIR:%.*]], %pair* [[P:%.*]], i64 [[INDEX]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i64* [[TMP2]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <4 x i64>, <4 x i64>* [[TMP3]], align 8
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <4 x i64> [[WIDE_VEC]], <4 x i64> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq <2 x i64> [[STRIDED_VEC]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x i1> [[TMP4]], i64 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x i64> [[WIDE_VEC]], i64 0
; CHECK-NEXT:    store i64 [[TMP6]], i64* [[TMP2]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i1> [[TMP4]], i64 1
; CHECK-NEXT:    br i1 [[TMP7]], label [[PRED_STORE_IF1:%.*]], label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.if1:
; CHECK-NEXT:    [[TMP8:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x i64> [[WIDE_VEC]], i64 2
; CHECK-NEXT:    store i64 [[TMP10]], i64* [[TMP9]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.continue2:
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[IF_MERGE:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[P_1:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[I]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = load i64, i64* [[P_1]], align 8
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[TMP12]], [[X]]
; CHECK-NEXT:    br i1 [[TMP13]], label [[IF_THEN:%.*]], label [[IF_MERGE]]
; CHECK:       if.then:
; CHECK-NEXT:    store i64 [[TMP12]], i64* [[P_1]], align 8
; CHECK-NEXT:    br label [[IF_MERGE]]
; CHECK:       if.merge:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END:%.*]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i  = phi i64 [ %i.next, %if.merge ], [ 0, %entry ]
  %p.1 = getelementptr inbounds %pair, %pair* %p, i64 %i, i32 1
  %0 = load i64, i64* %p.1, align 8
  %1 = icmp eq i64 %0, %x
  br i1 %1, label %if.then, label %if.merge

if.then:
  store i64 %0, i64* %p.1, align 8
  br label %if.merge

if.merge:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:
  ret void
}

; Ensure that we don't form a single interleaved group for the two loads. The
; conditional store prevents the second load from being hoisted. The two load
; groups are separately vectorized. The store group contains gaps and is not
; vectorized.
;
;
;
;
;
;

define void @interleaved_with_cond_store_1(%pair *%p, i64 %x, i64 %n) {
; CHECK-LABEL: @interleaved_with_cond_store_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 3
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = and i64 [[SMAX]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[TMP0]], i64 2, i64 [[N_MOD_VF]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub nsw i64 [[SMAX]], [[TMP1]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[X:%.*]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE2:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[PAIR:%.*]], %pair* [[P:%.*]], i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[INDEX]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i64* [[TMP4]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <4 x i64>, <4 x i64>* [[TMP6]], align 8
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <4 x i64> [[WIDE_VEC]], <4 x i64> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq <2 x i64> [[STRIDED_VEC]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i1> [[TMP7]], i64 0
; CHECK-NEXT:    br i1 [[TMP8]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <4 x i64> [[WIDE_VEC]], i64 0
; CHECK-NEXT:    store i64 [[TMP9]], i64* [[TMP3]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x i1> [[TMP7]], i64 1
; CHECK-NEXT:    br i1 [[TMP10]], label [[PRED_STORE_IF1:%.*]], label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.if1:
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x i64> [[WIDE_VEC]], i64 2
; CHECK-NEXT:    store i64 [[TMP12]], i64* [[TMP11]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.continue2:
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i64* [[TMP3]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_VEC3:%.*]] = load <4 x i64>, <4 x i64>* [[TMP13]], align 8
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <4 x i64> [[WIDE_VEC3]], i64 0
; CHECK-NEXT:    store i64 [[TMP14]], i64* [[TMP4]], align 8
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x i64> [[WIDE_VEC3]], i64 2
; CHECK-NEXT:    store i64 [[TMP15]], i64* [[TMP5]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP16:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP16]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[IF_MERGE:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[P_0:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[I]], i32 0
; CHECK-NEXT:    [[P_1:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[I]], i32 1
; CHECK-NEXT:    [[TMP17:%.*]] = load i64, i64* [[P_1]], align 8
; CHECK-NEXT:    [[TMP18:%.*]] = icmp eq i64 [[TMP17]], [[X]]
; CHECK-NEXT:    br i1 [[TMP18]], label [[IF_THEN:%.*]], label [[IF_MERGE]]
; CHECK:       if.then:
; CHECK-NEXT:    store i64 [[TMP17]], i64* [[P_0]], align 8
; CHECK-NEXT:    br label [[IF_MERGE]]
; CHECK:       if.merge:
; CHECK-NEXT:    [[TMP19:%.*]] = load i64, i64* [[P_0]], align 8
; CHECK-NEXT:    store i64 [[TMP19]], i64* [[P_1]], align 8
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END:%.*]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i  = phi i64 [ %i.next, %if.merge ], [ 0, %entry ]
  %p.0 = getelementptr inbounds %pair, %pair* %p, i64 %i, i32 0
  %p.1 = getelementptr inbounds %pair, %pair* %p, i64 %i, i32 1
  %0 = load i64, i64* %p.1, align 8
  %1 = icmp eq i64 %0, %x
  br i1 %1, label %if.then, label %if.merge

if.then:
  store i64 %0, i64* %p.0, align 8
  br label %if.merge

if.merge:
  %2 = load i64, i64* %p.0, align 8
  store i64 %2, i64 *%p.1, align 8
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:
  ret void
}

; Ensure that we don't create a single interleaved group for the two stores.
; The second store is conditional and we can't sink the first store inside the
; predicated block. The load group is vectorized, and the store groups contain
; gaps and are not vectorized.
;
;
;
;
;

define void @interleaved_with_cond_store_2(%pair *%p, i64 %x, i64 %n) {
; CHECK-LABEL: @interleaved_with_cond_store_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 3
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = and i64 [[SMAX]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i64 [[N_MOD_VF]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[TMP0]], i64 2, i64 [[N_MOD_VF]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub nsw i64 [[SMAX]], [[TMP1]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[X:%.*]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE2:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[PAIR:%.*]], %pair* [[P:%.*]], i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[INDEX]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i64* [[TMP5]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <4 x i64>, <4 x i64>* [[TMP6]], align 8
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <4 x i64> [[WIDE_VEC]], <4 x i64> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    store i64 [[X]], i64* [[TMP3]], align 8
; CHECK-NEXT:    store i64 [[X]], i64* [[TMP4]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq <2 x i64> [[STRIDED_VEC]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i1> [[TMP7]], i64 0
; CHECK-NEXT:    br i1 [[TMP8]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <4 x i64> [[WIDE_VEC]], i64 0
; CHECK-NEXT:    store i64 [[TMP9]], i64* [[TMP5]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x i1> [[TMP7]], i64 1
; CHECK-NEXT:    br i1 [[TMP10]], label [[PRED_STORE_IF1:%.*]], label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.if1:
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x i64> [[WIDE_VEC]], i64 2
; CHECK-NEXT:    store i64 [[TMP12]], i64* [[TMP11]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.continue2:
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP13]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[IF_MERGE:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[P_0:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[I]], i32 0
; CHECK-NEXT:    [[P_1:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[P]], i64 [[I]], i32 1
; CHECK-NEXT:    [[TMP14:%.*]] = load i64, i64* [[P_1]], align 8
; CHECK-NEXT:    store i64 [[X]], i64* [[P_0]], align 8
; CHECK-NEXT:    [[TMP15:%.*]] = icmp eq i64 [[TMP14]], [[X]]
; CHECK-NEXT:    br i1 [[TMP15]], label [[IF_THEN:%.*]], label [[IF_MERGE]]
; CHECK:       if.then:
; CHECK-NEXT:    store i64 [[TMP14]], i64* [[P_1]], align 8
; CHECK-NEXT:    br label [[IF_MERGE]]
; CHECK:       if.merge:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END:%.*]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i  = phi i64 [ %i.next, %if.merge ], [ 0, %entry ]
  %p.0 = getelementptr inbounds %pair, %pair* %p, i64 %i, i32 0
  %p.1 = getelementptr inbounds %pair, %pair* %p, i64 %i, i32 1
  %0 = load i64, i64* %p.1, align 8
  store i64 %x, i64* %p.0, align 8
  %1 = icmp eq i64 %0, %x
  br i1 %1, label %if.then, label %if.merge

if.then:
  store i64 %0, i64* %p.1, align 8
  br label %if.merge

if.merge:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:
  ret void
}
