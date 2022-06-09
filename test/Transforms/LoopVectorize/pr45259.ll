; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=loop-vectorize -force-vector-width=4 -force-vector-interleave=1 | FileCheck %s

; Check that we can vectorize this loop without crashing.

define i8 @widget(i8* %arr, i8 %t9) {
; CHECK-LABEL: @widget(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[ARR1:%.*]] = ptrtoint i8* [[ARR:%.*]] to i64
; CHECK-NEXT:    br label [[BB6:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[T1_0:%.*]] = phi i8* [ [[ARR]], [[BB:%.*]] ], [ null, [[BB6]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C]], label [[FOR_PREHEADER:%.*]], label [[BB6]]
; CHECK:       for.preheader:
; CHECK-NEXT:    [[T1_0_LCSSA:%.*]] = phi i8* [ [[T1_0]], [[BB6]] ]
; CHECK-NEXT:    [[T1_0_LCSSA2:%.*]] = ptrtoint i8* [[T1_0_LCSSA]] to i64
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[ARR1]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 0, [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[T1_0_LCSSA2]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP3]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 -1, [[ARR1]]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[TMP4]], [[T1_0_LCSSA2]]
; CHECK-NEXT:    [[TMP6:%.*]] = trunc i64 [[TMP5]] to i8
; CHECK-NEXT:    [[TMP7:%.*]] = add i8 1, [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp slt i8 [[TMP7]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = icmp ugt i64 [[TMP5]], 255
; CHECK-NEXT:    [[TMP10:%.*]] = or i1 [[TMP8]], [[TMP9]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP3]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP3]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = trunc i32 [[N_VEC]] to i8
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i8> poison, i8 [[T9:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i8> [[BROADCAST_SPLATINSERT]], <4 x i8> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i8> [ <i8 0, i8 1, i8 2, i8 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP11:%.*]] = add <4 x i8> [[VEC_IND]], <i8 1, i8 1, i8 1, i8 1>
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x i8> [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i8, i8* [[ARR]], i8 [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = icmp slt <4 x i8> [[TMP11]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP15:%.*]] = zext <4 x i1> [[TMP14]] to <4 x i8>
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds i8, i8* [[TMP13]], i32 0
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast i8* [[TMP16]] to <4 x i8>*
; CHECK-NEXT:    store <4 x i8> [[TMP15]], <4 x i8>* [[TMP17]], align 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i8> [[VEC_IND]], <i8 4, i8 4, i8 4, i8 4>
; CHECK-NEXT:    [[TMP18:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP18]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP3]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_PREHEADER]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds i8, i8* [[ARR]], i8 [[IV_NEXT]]
; CHECK-NEXT:    [[T3_I:%.*]] = icmp slt i8 [[IV_NEXT]], [[T9]]
; CHECK-NEXT:    [[T3_I8:%.*]] = zext i1 [[T3_I]] to i8
; CHECK-NEXT:    store i8 [[T3_I8]], i8* [[PTR]], align 1
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i8* [[T1_0_LCSSA]], [[PTR]]
; CHECK-NEXT:    br i1 [[EC]], label [[FOR_EXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.exit:
; CHECK-NEXT:    [[IV_NEXT_LCSSA:%.*]] = phi i8 [ [[IV_NEXT]], [[FOR_BODY]] ], [ [[IND_END]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i8 [[IV_NEXT_LCSSA]]
;
bb:
  br label %bb6

bb6:
  %t1.0 = phi i8* [ %arr, %bb ], [ null, %bb6 ]
  %c = call i1 @cond()
  br i1 %c, label %for.preheader, label %bb6

for.preheader:
  br label %for.body

for.body:
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %for.preheader ]
  %iv.next = add i8 %iv, 1
  %ptr = getelementptr inbounds i8, i8* %arr, i8 %iv.next
  %t3.i = icmp slt i8 %iv.next, %t9
  %t3.i8 = zext i1 %t3.i to i8
  store i8 %t3.i8, i8* %ptr
  %ec = icmp eq i8* %t1.0, %ptr
  br i1 %ec, label %for.exit, label %for.body

for.exit:
  %iv.next.lcssa = phi i8 [ %iv.next, %for.body ]
  ret i8 %iv.next.lcssa
}

declare i1 @cond()
