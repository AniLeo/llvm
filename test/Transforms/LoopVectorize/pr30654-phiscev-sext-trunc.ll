; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-vectorize -force-vector-width=4 -force-vector-interleave=1 < %s 2>&1 | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Check that the vectorizer identifies the %p.09 phi,
; as an induction variable, despite the potential overflow
; due to the truncation from 32bit to 8bit.
; SCEV will detect the pattern "sext(trunc(%p.09)) + %step"
; and generate the required runtime checks under which
; we can assume no overflow. We check here that we generate
; exactly two runtime checks:
; 1) an overflow check:
;    {0,+,(trunc i32 %step to i8)}<%for.body> Added Flags: <nssw>
; 2) an equality check verifying that the step of the induction
;    is equal to sext(trunc(step)):
;    Equal predicate: %step == (sext i8 (trunc i32 %step to i8) to i32)
;
; See also pr30654.
;
; int a[N];
; void doit1(int n, int step) {
;   int i;
;   char p = 0;
;   for (i = 0; i < n; i++) {
;      a[i] = p;
;      p = p + step;
;   }
; }
;

@a = common local_unnamed_addr global [250 x i32] zeroinitializer, align 16

; Function Attrs: norecurse nounwind uwtable
define void @doit1(i32 %n, i32 %step) local_unnamed_addr {
; CHECK-LABEL: @doit1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP7:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP7]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[WIDE_TRIP_COUNT]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[STEP:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i8 [[TMP1]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP3]], i8 [[TMP2]], i8 [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = trunc i64 [[TMP0]] to i8
; CHECK-NEXT:    [[MUL:%.*]] = call { i8, i1 } @llvm.umul.with.overflow.i8(i8 [[TMP4]], i8 [[TMP5]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i8, i1 } [[MUL]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i8, i1 } [[MUL]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = add i8 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP7:%.*]] = sub i8 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp sgt i8 [[TMP7]], 0
; CHECK-NEXT:    [[TMP9:%.*]] = icmp slt i8 [[TMP6]], 0
; CHECK-NEXT:    [[TMP10:%.*]] = select i1 [[TMP3]], i1 [[TMP8]], i1 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ugt i64 [[TMP0]], 255
; CHECK-NEXT:    [[TMP12:%.*]] = icmp ne i8 [[TMP1]], 0
; CHECK-NEXT:    [[TMP13:%.*]] = and i1 [[TMP11]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = or i1 [[TMP10]], [[TMP13]]
; CHECK-NEXT:    [[TMP15:%.*]] = or i1 [[TMP14]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[TMP16:%.*]] = or i1 false, [[TMP15]]
; CHECK-NEXT:    [[TMP17:%.*]] = sext i8 [[TMP1]] to i32
; CHECK-NEXT:    [[IDENT_CHECK:%.*]] = icmp ne i32 [[STEP]], [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = or i1 [[TMP16]], [[IDENT_CHECK]]
; CHECK-NEXT:    br i1 [[TMP18]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF]]
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[IND_END:%.*]] = mul i32 [[CAST_CRD]], [[STEP]]
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[STEP]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP19:%.*]] = mul <4 x i32> <i32 0, i32 1, i32 2, i32 3>, [[DOTSPLAT]]
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <4 x i32> zeroinitializer, [[TMP19]]
; CHECK-NEXT:    [[TMP20:%.*]] = mul i32 [[STEP]], 4
; CHECK-NEXT:    [[DOTSPLATINSERT2:%.*]] = insertelement <4 x i32> poison, i32 [[TMP20]], i32 0
; CHECK-NEXT:    [[DOTSPLAT3:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT2]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP21:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 [[TMP21]]
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds i32, i32* [[TMP22]], i32 0
; CHECK-NEXT:    [[TMP24:%.*]] = bitcast i32* [[TMP23]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[VEC_IND]], <4 x i32>* [[TMP24]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], [[DOTSPLAT3]]
; CHECK-NEXT:    [[TMP25:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP25]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[P_09:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 [[P_09]], 24
; CHECK-NEXT:    [[CONV:%.*]] = ashr exact i32 [[SEXT]], 24
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[CONV]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[CONV]], [[STEP]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp7 = icmp sgt i32 %n, 0
  br i1 %cmp7, label %for.body.preheader, label %for.end

for.body.preheader:
  %wide.trip.count = zext i32 %n to i64
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %p.09 = phi i32 [ %add, %for.body ], [ 0, %for.body.preheader ]
  %sext = shl i32 %p.09, 24
  %conv = ashr exact i32 %sext, 24
  %arrayidx = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %conv, i32* %arrayidx, align 4
  %add = add nsw i32 %conv, %step
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.end.loopexit, label %for.body

for.end.loopexit:
  br label %for.end

for.end:
  ret void
}

; Same as above, but for checking the SCEV "zext(trunc(%p.09)) + %step".
; Here we expect the following two predicates to be added for runtime checking:
; 1) {0,+,(trunc i32 %step to i8)}<%for.body> Added Flags: <nusw>
; 2) Equal predicate: %step == (sext i8 (trunc i32 %step to i8) to i32)
;
; int a[N];
; void doit2(int n, int step) {
;   int i;
;   unsigned char p = 0;
;   for (i = 0; i < n; i++) {
;      a[i] = p;
;      p = p + step;
;   }
; }
;


; Function Attrs: norecurse nounwind uwtable
define void @doit2(i32 %n, i32 %step) local_unnamed_addr  {
; CHECK-LABEL: @doit2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP7:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP7]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[WIDE_TRIP_COUNT]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[STEP:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i8 [[TMP1]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP3]], i8 [[TMP2]], i8 [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = trunc i64 [[TMP0]] to i8
; CHECK-NEXT:    [[MUL:%.*]] = call { i8, i1 } @llvm.umul.with.overflow.i8(i8 [[TMP4]], i8 [[TMP5]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i8, i1 } [[MUL]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i8, i1 } [[MUL]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = add i8 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP7:%.*]] = sub i8 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ugt i8 [[TMP7]], 0
; CHECK-NEXT:    [[TMP9:%.*]] = icmp ult i8 [[TMP6]], 0
; CHECK-NEXT:    [[TMP10:%.*]] = select i1 [[TMP3]], i1 [[TMP8]], i1 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ugt i64 [[TMP0]], 255
; CHECK-NEXT:    [[TMP12:%.*]] = icmp ne i8 [[TMP1]], 0
; CHECK-NEXT:    [[TMP13:%.*]] = and i1 [[TMP11]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = or i1 [[TMP10]], [[TMP13]]
; CHECK-NEXT:    [[TMP15:%.*]] = or i1 [[TMP14]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[TMP16:%.*]] = or i1 false, [[TMP15]]
; CHECK-NEXT:    [[TMP17:%.*]] = sext i8 [[TMP1]] to i32
; CHECK-NEXT:    [[IDENT_CHECK:%.*]] = icmp ne i32 [[STEP]], [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = or i1 [[TMP16]], [[IDENT_CHECK]]
; CHECK-NEXT:    br i1 [[TMP18]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF]]
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[IND_END:%.*]] = mul i32 [[CAST_CRD]], [[STEP]]
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[STEP]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP19:%.*]] = mul <4 x i32> <i32 0, i32 1, i32 2, i32 3>, [[DOTSPLAT]]
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <4 x i32> zeroinitializer, [[TMP19]]
; CHECK-NEXT:    [[TMP20:%.*]] = mul i32 [[STEP]], 4
; CHECK-NEXT:    [[DOTSPLATINSERT2:%.*]] = insertelement <4 x i32> poison, i32 [[TMP20]], i32 0
; CHECK-NEXT:    [[DOTSPLAT3:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT2]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP21:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 [[TMP21]]
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds i32, i32* [[TMP22]], i32 0
; CHECK-NEXT:    [[TMP24:%.*]] = bitcast i32* [[TMP23]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[VEC_IND]], <4 x i32>* [[TMP24]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], [[DOTSPLAT3]]
; CHECK-NEXT:    [[TMP25:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP25]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[P_09:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[CONV:%.*]] = and i32 [[P_09]], 255
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[CONV]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[CONV]], [[STEP]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp7 = icmp sgt i32 %n, 0
  br i1 %cmp7, label %for.body.preheader, label %for.end

for.body.preheader:
  %wide.trip.count = zext i32 %n to i64
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %p.09 = phi i32 [ %add, %for.body ], [ 0, %for.body.preheader ]
  %conv = and i32 %p.09, 255
  %arrayidx = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %conv, i32* %arrayidx, align 4
  %add = add nsw i32 %conv, %step
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.end.loopexit, label %for.body

for.end.loopexit:
  br label %for.end

for.end:
  ret void
}

; Here we check that the same phi scev analysis would fail
; to create the runtime checks because the step is not invariant.
; As a result vectorization will fail.
;
; int a[N];
; void doit3(int n, int step) {
;   int i;
;   char p = 0;
;   for (i = 0; i < n; i++) {
;      a[i] = p;
;      p = p + step;
;      step += 2;
;   }
; }
;


; Function Attrs: norecurse nounwind uwtable
define void @doit3(i32 %n, i32 %step) local_unnamed_addr {
; CHECK-LABEL: @doit3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP9:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP9]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[P_012:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[STEP_ADDR_010:%.*]] = phi i32 [ [[ADD3:%.*]], [[FOR_BODY]] ], [ [[STEP:%.*]], [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 [[P_012]], 24
; CHECK-NEXT:    [[CONV:%.*]] = ashr exact i32 [[SEXT]], 24
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[CONV]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[CONV]], [[STEP_ADDR_010]]
; CHECK-NEXT:    [[ADD3]] = add nsw i32 [[STEP_ADDR_010]], 2
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp9 = icmp sgt i32 %n, 0
  br i1 %cmp9, label %for.body.preheader, label %for.end

for.body.preheader:
  %wide.trip.count = zext i32 %n to i64
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %p.012 = phi i32 [ %add, %for.body ], [ 0, %for.body.preheader ]
  %step.addr.010 = phi i32 [ %add3, %for.body ], [ %step, %for.body.preheader ]
  %sext = shl i32 %p.012, 24
  %conv = ashr exact i32 %sext, 24
  %arrayidx = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %conv, i32* %arrayidx, align 4
  %add = add nsw i32 %conv, %step.addr.010
  %add3 = add nsw i32 %step.addr.010, 2
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.end.loopexit, label %for.body

for.end.loopexit:
  br label %for.end

for.end:
  ret void
}


; Lastly, we also check the case where we can tell at compile time that
; the step of the induction is equal to sext(trunc(step)), in which case
; we don't have to check this equality at runtime (we only need the
; runtime overflow check). Therefore only the following overflow predicate
; will be added for runtime checking:
; {0,+,%cstep}<%for.body> Added Flags: <nssw>
;
; a[N];
; void doit4(int n, char cstep) {
;   int i;
;   char p = 0;
;   int istep = cstep;
;  for (i = 0; i < n; i++) {
;      a[i] = p;
;      p = p + istep;
;   }
; }


; Function Attrs: norecurse nounwind uwtable
define void @doit4(i32 %n, i8 signext %cstep) local_unnamed_addr {
; CHECK-LABEL: @doit4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = sext i8 [[CSTEP:%.*]] to i32
; CHECK-NEXT:    [[CMP10:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP10]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[WIDE_TRIP_COUNT]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 0, [[CSTEP]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i8 [[CSTEP]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP2]], i8 [[TMP1]], i8 [[CSTEP]]
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i64 [[TMP0]] to i8
; CHECK-NEXT:    [[MUL:%.*]] = call { i8, i1 } @llvm.umul.with.overflow.i8(i8 [[TMP3]], i8 [[TMP4]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i8, i1 } [[MUL]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i8, i1 } [[MUL]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = add i8 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP6:%.*]] = sub i8 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp sgt i8 [[TMP6]], 0
; CHECK-NEXT:    [[TMP8:%.*]] = icmp slt i8 [[TMP5]], 0
; CHECK-NEXT:    [[TMP9:%.*]] = select i1 [[TMP2]], i1 [[TMP7]], i1 [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = icmp ugt i64 [[TMP0]], 255
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ne i8 [[CSTEP]], 0
; CHECK-NEXT:    [[TMP12:%.*]] = and i1 [[TMP10]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = or i1 [[TMP9]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = or i1 [[TMP13]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[TMP15:%.*]] = or i1 false, [[TMP14]]
; CHECK-NEXT:    br i1 [[TMP15]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF]]
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[IND_END:%.*]] = mul i32 [[CAST_CRD]], [[CONV]]
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[CONV]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = mul <4 x i32> <i32 0, i32 1, i32 2, i32 3>, [[DOTSPLAT]]
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <4 x i32> zeroinitializer, [[TMP16]]
; CHECK-NEXT:    [[TMP17:%.*]] = mul i32 [[CONV]], 4
; CHECK-NEXT:    [[DOTSPLATINSERT2:%.*]] = insertelement <4 x i32> poison, i32 [[TMP17]], i32 0
; CHECK-NEXT:    [[DOTSPLAT3:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT2]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP18:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 [[TMP18]]
; CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds i32, i32* [[TMP19]], i32 0
; CHECK-NEXT:    [[TMP21:%.*]] = bitcast i32* [[TMP20]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[VEC_IND]], <4 x i32>* [[TMP21]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], [[DOTSPLAT3]]
; CHECK-NEXT:    [[TMP22:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP22]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[P_011:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 [[P_011]], 24
; CHECK-NEXT:    [[CONV2:%.*]] = ashr exact i32 [[SEXT]], 24
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[CONV2]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[CONV2]], [[CONV]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %conv = sext i8 %cstep to i32
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %for.body.preheader, label %for.end

for.body.preheader:
  %wide.trip.count = zext i32 %n to i64
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %p.011 = phi i32 [ %add, %for.body ], [ 0, %for.body.preheader ]
  %sext = shl i32 %p.011, 24
  %conv2 = ashr exact i32 %sext, 24
  %arrayidx = getelementptr inbounds [250 x i32], [250 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %conv2, i32* %arrayidx, align 4
  %add = add nsw i32 %conv2, %conv
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.end.loopexit, label %for.body

for.end.loopexit:
  br label %for.end

for.end:
  ret void
}
