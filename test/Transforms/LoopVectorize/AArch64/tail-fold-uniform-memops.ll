; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -scalable-vectorization=off -force-vector-width=4 -prefer-predicate-over-epilogue=predicate-dont-vectorize -S < %s | FileCheck %s

; NOTE: These tests aren't really target-specific, but it's convenient to target AArch64
; so that TTI.isLegalMaskedLoad can return true.

target triple = "aarch64-linux-gnu"

; The original loop had an unconditional uniform load. Let's make sure
; we don't artificially create new predicated blocks for the load.
define void @uniform_load(i32* noalias %dst, i32* noalias readonly %src, i64 %n) #0 {
; CHECK-LABEL: @uniform_load(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[N:%.*]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i64(i64 [[TMP0]], i64 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[SRC:%.*]], align 4
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[DST:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP3]] to <4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[BROADCAST_SPLAT]], <4 x i32>* [[TMP4]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[SRC]], align 4
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[DST]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    store i32 [[VAL]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;

entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %val = load i32, i32* %src, align 4
  %arrayidx = getelementptr inbounds i32, i32* %dst, i64 %indvars.iv
  store i32 %val, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %n
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; The original loop had a conditional uniform load. In this case we actually
; do need to perform conditional loads and so we end up using a gather instead.
; However, we at least ensure the mask is the overlap of the loop predicate
; and the original condition.
define void @cond_uniform_load(i32* nocapture %dst, i32* nocapture readonly %src, i32* nocapture readonly %cond, i64 %n) #0 {
; CHECK-LABEL: @cond_uniform_load(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DST1:%.*]] = bitcast i32* [[DST:%.*]] to i8*
; CHECK-NEXT:    [[COND3:%.*]] = bitcast i32* [[COND:%.*]] to i8*
; CHECK-NEXT:    [[SRC6:%.*]] = bitcast i32* [[SRC:%.*]] to i8*
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[DST]], i64 [[N:%.*]]
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = bitcast i32* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i32, i32* [[COND]], i64 [[N]]
; CHECK-NEXT:    [[SCEVGEP45:%.*]] = bitcast i32* [[SCEVGEP4]] to i8*
; CHECK-NEXT:    [[SCEVGEP7:%.*]] = getelementptr i32, i32* [[SRC]], i64 1
; CHECK-NEXT:    [[SCEVGEP78:%.*]] = bitcast i32* [[SCEVGEP7]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[DST1]], [[SCEVGEP45]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[COND3]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[BOUND09:%.*]] = icmp ult i8* [[DST1]], [[SCEVGEP78]]
; CHECK-NEXT:    [[BOUND110:%.*]] = icmp ult i8* [[SRC6]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT11:%.*]] = and i1 [[BOUND09]], [[BOUND110]]
; CHECK-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[FOUND_CONFLICT]], [[FOUND_CONFLICT11]]
; CHECK-NEXT:    br i1 [[CONFLICT_RDX]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[N]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX12:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT19:%.*]], [[PRED_LOAD_CONTINUE18:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX12]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i64(i64 [[TMP0]], i64 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[COND]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison), !alias.scope !4
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq <4 x i32> [[WIDE_MASKED_LOAD]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = xor <4 x i1> [[TMP4]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP6:%.*]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i1> [[TMP5]], <4 x i1> zeroinitializer
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i1> [[TMP6]], i32 0
; CHECK-NEXT:    br i1 [[TMP7]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[SRC]], align 4, !alias.scope !7
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <4 x i32> poison, i32 [[TMP8]], i32 0
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP10:%.*]] = phi <4 x i32> [ poison, [[VECTOR_BODY]] ], [ [[TMP9]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x i1> [[TMP6]], i32 1
; CHECK-NEXT:    br i1 [[TMP11]], label [[PRED_LOAD_IF13:%.*]], label [[PRED_LOAD_CONTINUE14:%.*]]
; CHECK:       pred.load.if13:
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32* [[SRC]], align 4, !alias.scope !7
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <4 x i32> [[TMP10]], i32 [[TMP12]], i32 1
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE14]]
; CHECK:       pred.load.continue14:
; CHECK-NEXT:    [[TMP14:%.*]] = phi <4 x i32> [ [[TMP10]], [[PRED_LOAD_CONTINUE]] ], [ [[TMP13]], [[PRED_LOAD_IF13]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x i1> [[TMP6]], i32 2
; CHECK-NEXT:    br i1 [[TMP15]], label [[PRED_LOAD_IF15:%.*]], label [[PRED_LOAD_CONTINUE16:%.*]]
; CHECK:       pred.load.if15:
; CHECK-NEXT:    [[TMP16:%.*]] = load i32, i32* [[SRC]], align 4, !alias.scope !7
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <4 x i32> [[TMP14]], i32 [[TMP16]], i32 2
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE16]]
; CHECK:       pred.load.continue16:
; CHECK-NEXT:    [[TMP18:%.*]] = phi <4 x i32> [ [[TMP14]], [[PRED_LOAD_CONTINUE14]] ], [ [[TMP17]], [[PRED_LOAD_IF15]] ]
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <4 x i1> [[TMP6]], i32 3
; CHECK-NEXT:    br i1 [[TMP19]], label [[PRED_LOAD_IF17:%.*]], label [[PRED_LOAD_CONTINUE18]]
; CHECK:       pred.load.if17:
; CHECK-NEXT:    [[TMP20:%.*]] = load i32, i32* [[SRC]], align 4, !alias.scope !7
; CHECK-NEXT:    [[TMP21:%.*]] = insertelement <4 x i32> [[TMP18]], i32 [[TMP20]], i32 3
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE18]]
; CHECK:       pred.load.continue18:
; CHECK-NEXT:    [[TMP22:%.*]] = phi <4 x i32> [ [[TMP18]], [[PRED_LOAD_CONTINUE16]] ], [ [[TMP21]], [[PRED_LOAD_IF17]] ]
; CHECK-NEXT:    [[TMP23:%.*]] = select <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i1> [[TMP4]], <4 x i1> zeroinitializer
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP23]], <4 x i32> zeroinitializer, <4 x i32> [[TMP22]]
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds i32, i32* [[DST]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP25:%.*]] = or <4 x i1> [[TMP6]], [[TMP23]]
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr inbounds i32, i32* [[TMP24]], i32 0
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast i32* [[TMP26]] to <4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> [[PREDPHI]], <4 x i32>* [[TMP27]], i32 4, <4 x i1> [[TMP25]]), !alias.scope !9, !noalias !11
; CHECK-NEXT:    [[INDEX_NEXT19]] = add i64 [[INDEX12]], 4
; CHECK-NEXT:    [[TMP28:%.*]] = icmp eq i64 [[INDEX_NEXT19]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP28]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ [[INDEX_NEXT:%.*]], [[IF_END:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[COND]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP29:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TOBOOL_NOT:%.*]] = icmp eq i32 [[TMP29]], 0
; CHECK-NEXT:    br i1 [[TOBOOL_NOT]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[TMP30:%.*]] = load i32, i32* [[SRC]], align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[VAL_0:%.*]] = phi i32 [ [[TMP30]], [[IF_THEN]] ], [ 0, [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[DST]], i64 [[INDEX]]
; CHECK-NEXT:    store i32 [[VAL_0]], i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %if.end
  %index = phi i64 [ %index.next, %if.end ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %cond, i64 %index
  %0 = load i32, i32* %arrayidx, align 4
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  %1 = load i32, i32* %src, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %val.0 = phi i32 [ %1, %if.then ], [ 0, %for.body ]
  %arrayidx1 = getelementptr inbounds i32, i32* %dst, i64 %index
  store i32 %val.0, i32* %arrayidx1, align 4
  %index.next = add nuw i64 %index, 1
  %exitcond.not = icmp eq i64 %index.next, %n
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.inc, %entry
  ret void
}

attributes #0 = { "target-features"="+neon,+sve,+v8.1a" vscale_range(2, 0) }
