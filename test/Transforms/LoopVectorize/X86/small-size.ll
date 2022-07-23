; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -loop-vectorize -force-vector-interleave=1 -force-vector-width=4 -loop-vectorize-with-block-frequency -dce -instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@b = common global [2048 x i32] zeroinitializer, align 16
@c = common global [2048 x i32] zeroinitializer, align 16
@a = common global [2048 x i32] zeroinitializer, align 16
@G = common global [32 x [1024 x i32]] zeroinitializer, align 16
@ub = common global [1024 x i32] zeroinitializer, align 16
@uc = common global [1024 x i32] zeroinitializer, align 16
@d = common global [2048 x i32] zeroinitializer, align 16
@fa = common global [1024 x float] zeroinitializer, align 16
@fb = common global [1024 x float] zeroinitializer, align 16
@ic = common global [1024 x i32] zeroinitializer, align 16
@da = common global [1024 x float] zeroinitializer, align 16
@db = common global [1024 x float] zeroinitializer, align 16
@dc = common global [1024 x float] zeroinitializer, align 16
@dd = common global [1024 x float] zeroinitializer, align 16
@dj = common global [1024 x i32] zeroinitializer, align 16

; We can optimize this test without a tail.
define void @example1() optsize {
; CHECK-LABEL: @example1(
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[TMP1]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP2]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP3]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP4]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <4 x i32> [[WIDE_LOAD1]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP6]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP5]], <4 x i32>* [[TMP7]], align 16
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[TMP10:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[TMP9:%.*]]
; CHECK:       9:
; CHECK-NEXT:    br i1 poison, label [[TMP10]], label [[TMP9]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       10:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %indvars.iv = phi i64 [ 0, %0 ], [ %indvars.iv.next, %1 ]
  %2 = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 %indvars.iv
  %3 = load i32, i32* %2, align 4
  %4 = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 %indvars.iv
  %5 = load i32, i32* %4, align 4
  %6 = add nsw i32 %5, %3
  %7 = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %6, i32* %7, align 4
  %indvars.iv.next = add i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, 256
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}

; Can vectorize in 'optsize' mode by masking the needed tail.
define void @example2(i32 %n, i32 %x) optsize {
; CHECK-LABEL: @example2(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[DOTLR_PH5_PREHEADER:%.*]], label [[DOTPREHEADER:%.*]]
; CHECK:       .lr.ph5.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add nuw nsw i64 [[TMP3]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[N_RND_UP]], 8589934588
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> poison, i64 [[TMP3]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE6:%.*]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[PRED_STORE_CONTINUE6]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ule <4 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i1> [[TMP4]], i64 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    store i32 [[X:%.*]], i32* [[TMP6]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i1> [[TMP4]], i64 1
; CHECK-NEXT:    br i1 [[TMP7]], label [[PRED_STORE_IF1:%.*]], label [[PRED_STORE_CONTINUE2:%.*]]
; CHECK:       pred.store.if1:
; CHECK-NEXT:    [[TMP8:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP8]]
; CHECK-NEXT:    store i32 [[X]], i32* [[TMP9]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.continue2:
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x i1> [[TMP4]], i64 2
; CHECK-NEXT:    br i1 [[TMP10]], label [[PRED_STORE_IF3:%.*]], label [[PRED_STORE_CONTINUE4:%.*]]
; CHECK:       pred.store.if3:
; CHECK-NEXT:    [[TMP11:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP11]]
; CHECK-NEXT:    store i32 [[X]], i32* [[TMP12]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE4]]
; CHECK:       pred.store.continue4:
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x i1> [[TMP4]], i64 3
; CHECK-NEXT:    br i1 [[TMP13]], label [[PRED_STORE_IF5:%.*]], label [[PRED_STORE_CONTINUE6]]
; CHECK:       pred.store.if5:
; CHECK-NEXT:    [[TMP14:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP14]]
; CHECK-NEXT:    store i32 [[X]], i32* [[TMP15]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE6]]
; CHECK:       pred.store.continue6:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP16:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP16]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[DOT_PREHEADER_CRIT_EDGE:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[DOTLR_PH5:%.*]]
; CHECK:       ..preheader_crit_edge:
; CHECK-NEXT:    [[PHITMP:%.*]] = sext i32 [[N]] to i64
; CHECK-NEXT:    br label [[DOTPREHEADER]]
; CHECK:       .preheader:
; CHECK-NEXT:    [[I_0_LCSSA:%.*]] = phi i64 [ [[PHITMP]], [[DOT_PREHEADER_CRIT_EDGE]] ], [ 0, [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq i32 [[N]], 0
; CHECK-NEXT:    br i1 [[TMP17]], label [[DOT_CRIT_EDGE:%.*]], label [[DOTLR_PH_PREHEADER:%.*]]
; CHECK:       .lr.ph.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH8:%.*]], label [[VECTOR_PH9:%.*]]
; CHECK:       vector.ph9:
; CHECK-NEXT:    [[TMP18:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[TMP19:%.*]] = zext i32 [[TMP18]] to i64
; CHECK-NEXT:    [[N_RND_UP10:%.*]] = add nuw nsw i64 [[TMP19]], 4
; CHECK-NEXT:    [[N_VEC12:%.*]] = and i64 [[N_RND_UP10]], 8589934588
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT17:%.*]] = insertelement <4 x i64> poison, i64 [[TMP19]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT18:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT17]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY19:%.*]]
; CHECK:       vector.body19:
; CHECK-NEXT:    [[INDEX20:%.*]] = phi i64 [ 0, [[VECTOR_PH9]] ], [ [[INDEX_NEXT31:%.*]], [[PRED_STORE_CONTINUE30:%.*]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = add i64 [[I_0_LCSSA]], [[INDEX20]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT21:%.*]] = insertelement <4 x i64> poison, i64 [[INDEX20]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT22:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT21]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = or <4 x i64> [[BROADCAST_SPLAT22]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP20:%.*]] = icmp ule <4 x i64> [[VEC_IV]], [[BROADCAST_SPLAT18]]
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <4 x i1> [[TMP20]], i64 0
; CHECK-NEXT:    br i1 [[TMP21]], label [[PRED_STORE_IF23:%.*]], label [[PRED_STORE_CONTINUE24:%.*]]
; CHECK:       pred.store.if23:
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP23:%.*]] = load i32, i32* [[TMP22]], align 4
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP25:%.*]] = load i32, i32* [[TMP24]], align 4
; CHECK-NEXT:    [[TMP26:%.*]] = and i32 [[TMP25]], [[TMP23]]
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[OFFSET_IDX]]
; CHECK-NEXT:    store i32 [[TMP26]], i32* [[TMP27]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE24]]
; CHECK:       pred.store.continue24:
; CHECK-NEXT:    [[TMP28:%.*]] = extractelement <4 x i1> [[TMP20]], i64 1
; CHECK-NEXT:    br i1 [[TMP28]], label [[PRED_STORE_IF25:%.*]], label [[PRED_STORE_CONTINUE26:%.*]]
; CHECK:       pred.store.if25:
; CHECK-NEXT:    [[TMP29:%.*]] = add i64 [[OFFSET_IDX]], 1
; CHECK-NEXT:    [[TMP30:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP29]]
; CHECK-NEXT:    [[TMP31:%.*]] = load i32, i32* [[TMP30]], align 4
; CHECK-NEXT:    [[TMP32:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[TMP29]]
; CHECK-NEXT:    [[TMP33:%.*]] = load i32, i32* [[TMP32]], align 4
; CHECK-NEXT:    [[TMP34:%.*]] = and i32 [[TMP33]], [[TMP31]]
; CHECK-NEXT:    [[TMP35:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[TMP29]]
; CHECK-NEXT:    store i32 [[TMP34]], i32* [[TMP35]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE26]]
; CHECK:       pred.store.continue26:
; CHECK-NEXT:    [[TMP36:%.*]] = extractelement <4 x i1> [[TMP20]], i64 2
; CHECK-NEXT:    br i1 [[TMP36]], label [[PRED_STORE_IF27:%.*]], label [[PRED_STORE_CONTINUE28:%.*]]
; CHECK:       pred.store.if27:
; CHECK-NEXT:    [[TMP37:%.*]] = add i64 [[OFFSET_IDX]], 2
; CHECK-NEXT:    [[TMP38:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP37]]
; CHECK-NEXT:    [[TMP39:%.*]] = load i32, i32* [[TMP38]], align 4
; CHECK-NEXT:    [[TMP40:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[TMP37]]
; CHECK-NEXT:    [[TMP41:%.*]] = load i32, i32* [[TMP40]], align 4
; CHECK-NEXT:    [[TMP42:%.*]] = and i32 [[TMP41]], [[TMP39]]
; CHECK-NEXT:    [[TMP43:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[TMP37]]
; CHECK-NEXT:    store i32 [[TMP42]], i32* [[TMP43]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE28]]
; CHECK:       pred.store.continue28:
; CHECK-NEXT:    [[TMP44:%.*]] = extractelement <4 x i1> [[TMP20]], i64 3
; CHECK-NEXT:    br i1 [[TMP44]], label [[PRED_STORE_IF29:%.*]], label [[PRED_STORE_CONTINUE30]]
; CHECK:       pred.store.if29:
; CHECK-NEXT:    [[TMP45:%.*]] = add i64 [[OFFSET_IDX]], 3
; CHECK-NEXT:    [[TMP46:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP45]]
; CHECK-NEXT:    [[TMP47:%.*]] = load i32, i32* [[TMP46]], align 4
; CHECK-NEXT:    [[TMP48:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[TMP45]]
; CHECK-NEXT:    [[TMP49:%.*]] = load i32, i32* [[TMP48]], align 4
; CHECK-NEXT:    [[TMP50:%.*]] = and i32 [[TMP49]], [[TMP47]]
; CHECK-NEXT:    [[TMP51:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[TMP45]]
; CHECK-NEXT:    store i32 [[TMP50]], i32* [[TMP51]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE30]]
; CHECK:       pred.store.continue30:
; CHECK-NEXT:    [[INDEX_NEXT31]] = add i64 [[INDEX20]], 4
; CHECK-NEXT:    [[TMP52:%.*]] = icmp eq i64 [[INDEX_NEXT31]], [[N_VEC12]]
; CHECK-NEXT:    br i1 [[TMP52]], label [[MIDDLE_BLOCK7:%.*]], label [[VECTOR_BODY19]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block7:
; CHECK-NEXT:    br i1 true, label [[DOT_CRIT_EDGE_LOOPEXIT:%.*]], label [[SCALAR_PH8]]
; CHECK:       scalar.ph8:
; CHECK-NEXT:    br label [[DOTLR_PH:%.*]]
; CHECK:       .lr.ph5:
; CHECK-NEXT:    br i1 poison, label [[DOT_PREHEADER_CRIT_EDGE]], label [[DOTLR_PH5]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       .lr.ph:
; CHECK-NEXT:    br i1 poison, label [[DOT_CRIT_EDGE_LOOPEXIT]], label [[DOTLR_PH]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       ._crit_edge.loopexit:
; CHECK-NEXT:    br label [[DOT_CRIT_EDGE]]
; CHECK:       ._crit_edge:
; CHECK-NEXT:    ret void
;
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph5, label %.preheader

..preheader_crit_edge:                            ; preds = %.lr.ph5
  %phitmp = sext i32 %n to i64
  br label %.preheader

.preheader:                                       ; preds = %..preheader_crit_edge, %0
  %i.0.lcssa = phi i64 [ %phitmp, %..preheader_crit_edge ], [ 0, %0 ]
  %2 = icmp eq i32 %n, 0
  br i1 %2, label %._crit_edge, label %.lr.ph

.lr.ph5:                                          ; preds = %0, %.lr.ph5
  %indvars.iv6 = phi i64 [ %indvars.iv.next7, %.lr.ph5 ], [ 0, %0 ]
  %3 = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 %indvars.iv6
  store i32 %x, i32* %3, align 4
  %indvars.iv.next7 = add i64 %indvars.iv6, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next7 to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %n
  br i1 %exitcond, label %..preheader_crit_edge, label %.lr.ph5

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %.lr.ph ], [ %i.0.lcssa, %.preheader ]
  %.02 = phi i32 [ %4, %.lr.ph ], [ %n, %.preheader ]
  %4 = add nsw i32 %.02, -1
  %5 = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 %indvars.iv
  %6 = load i32, i32* %5, align 4
  %7 = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 %indvars.iv
  %8 = load i32, i32* %7, align 4
  %9 = and i32 %8, %6
  %10 = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %9, i32* %10, align 4
  %indvars.iv.next = add i64 %indvars.iv, 1
  %11 = icmp eq i32 %4, 0
  br i1 %11, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  ret void
}

; Loop has no primary induction as its integer IV has step -1 starting at
; unknown N, but can still be vectorized.
define void @example3(i32 %n, i32* noalias nocapture %p, i32* noalias nocapture %q) optsize {
; CHECK-LABEL: @example3(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[DOT_CRIT_EDGE:%.*]], label [[DOTLR_PH_PREHEADER:%.*]]
; CHECK:       .lr.ph.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add nuw nsw i64 [[TMP3]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[N_RND_UP]], 8589934588
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> poison, i64 [[TMP3]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE19:%.*]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT12:%.*]] = insertelement <4 x i64> poison, i64 [[INDEX]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT13:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT12]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = or <4 x i64> [[BROADCAST_SPLAT13]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ule <4 x i64> [[VEC_IV]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i1> [[TMP4]], i64 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i32, i32* [[P:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP8:%.*]] = getelementptr i32, i32* [[Q:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, i32* [[NEXT_GEP8]], align 16
; CHECK-NEXT:    store i32 [[TMP6]], i32* [[NEXT_GEP]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i1> [[TMP4]], i64 1
; CHECK-NEXT:    br i1 [[TMP7]], label [[PRED_STORE_IF14:%.*]], label [[PRED_STORE_CONTINUE15:%.*]]
; CHECK:       pred.store.if14:
; CHECK-NEXT:    [[TMP8:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP5:%.*]] = getelementptr i32, i32* [[P]], i64 [[TMP8]]
; CHECK-NEXT:    [[TMP9:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP9:%.*]] = getelementptr i32, i32* [[Q]], i64 [[TMP9]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[NEXT_GEP9]], align 16
; CHECK-NEXT:    store i32 [[TMP10]], i32* [[NEXT_GEP5]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE15]]
; CHECK:       pred.store.continue15:
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x i1> [[TMP4]], i64 2
; CHECK-NEXT:    br i1 [[TMP11]], label [[PRED_STORE_IF16:%.*]], label [[PRED_STORE_CONTINUE17:%.*]]
; CHECK:       pred.store.if16:
; CHECK-NEXT:    [[TMP12:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP6:%.*]] = getelementptr i32, i32* [[P]], i64 [[TMP12]]
; CHECK-NEXT:    [[TMP13:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP10:%.*]] = getelementptr i32, i32* [[Q]], i64 [[TMP13]]
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[NEXT_GEP10]], align 16
; CHECK-NEXT:    store i32 [[TMP14]], i32* [[NEXT_GEP6]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE17]]
; CHECK:       pred.store.continue17:
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x i1> [[TMP4]], i64 3
; CHECK-NEXT:    br i1 [[TMP15]], label [[PRED_STORE_IF18:%.*]], label [[PRED_STORE_CONTINUE19]]
; CHECK:       pred.store.if18:
; CHECK-NEXT:    [[TMP16:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP7:%.*]] = getelementptr i32, i32* [[P]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP17:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP11:%.*]] = getelementptr i32, i32* [[Q]], i64 [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = load i32, i32* [[NEXT_GEP11]], align 16
; CHECK-NEXT:    store i32 [[TMP18]], i32* [[NEXT_GEP7]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE19]]
; CHECK:       pred.store.continue19:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP19:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP19]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[DOT_CRIT_EDGE_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[DOTLR_PH:%.*]]
; CHECK:       .lr.ph:
; CHECK-NEXT:    br i1 poison, label [[DOT_CRIT_EDGE_LOOPEXIT]], label [[DOTLR_PH]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       ._crit_edge.loopexit:
; CHECK-NEXT:    br label [[DOT_CRIT_EDGE]]
; CHECK:       ._crit_edge:
; CHECK-NEXT:    ret void
;
  %1 = icmp eq i32 %n, 0
  br i1 %1, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %0, %.lr.ph
  %.05 = phi i32 [ %2, %.lr.ph ], [ %n, %0 ]
  %.014 = phi i32* [ %5, %.lr.ph ], [ %p, %0 ]
  %.023 = phi i32* [ %3, %.lr.ph ], [ %q, %0 ]
  %2 = add nsw i32 %.05, -1
  %3 = getelementptr inbounds i32, i32* %.023, i64 1
  %4 = load i32, i32* %.023, align 16
  %5 = getelementptr inbounds i32, i32* %.014, i64 1
  store i32 %4, i32* %.014, align 16
  %6 = icmp eq i32 %2, 0
  br i1 %6, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph, %0
  ret void
}

; We can't vectorize this one because we need a runtime ptr check.
define void @example23(i16* nocapture %src, i32* nocapture %dst) optsize {
; CHECK-LABEL: @example23(
; CHECK-NEXT:    br label [[TMP1:%.*]]
; CHECK:       1:
; CHECK-NEXT:    [[DOT04:%.*]] = phi i16* [ [[SRC:%.*]], [[TMP0:%.*]] ], [ [[TMP2:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[DOT013:%.*]] = phi i32* [ [[DST:%.*]], [[TMP0]] ], [ [[TMP6:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ 0, [[TMP0]] ], [ [[TMP7:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[TMP2]] = getelementptr inbounds i16, i16* [[DOT04]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i16, i16* [[DOT04]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = zext i16 [[TMP3]] to i32
; CHECK-NEXT:    [[TMP5:%.*]] = shl nuw nsw i32 [[TMP4]], 7
; CHECK-NEXT:    [[TMP6]] = getelementptr inbounds i32, i32* [[DOT013]], i64 1
; CHECK-NEXT:    store i32 [[TMP5]], i32* [[DOT013]], align 4
; CHECK-NEXT:    [[TMP7]] = add nuw nsw i32 [[I_02]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[TMP7]], 256
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[TMP8:%.*]], label [[TMP1]]
; CHECK:       8:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i32 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i32 %i.02, 1
  %exitcond = icmp eq i32 %7, 256
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}


; We CAN vectorize this example because the pointers are marked as noalias.
define void @example23b(i16* noalias nocapture %src, i32* noalias nocapture %dst) optsize {
; CHECK-LABEL: @example23b(
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i16, i16* [[SRC:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP4:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[NEXT_GEP]] to <4 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = zext <4 x i16> [[WIDE_LOAD]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = shl nuw nsw <4 x i32> [[TMP2]], <i32 7, i32 7, i32 7, i32 7>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[NEXT_GEP4]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP3]], <4 x i32>* [[TMP4]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[TMP7:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[TMP6:%.*]]
; CHECK:       6:
; CHECK-NEXT:    br i1 poison, label [[TMP7]], label [[TMP6]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       7:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i32 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i32 %i.02, 1
  %exitcond = icmp eq i32 %7, 256
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}

; We CAN vectorize this example by folding the tail it entails.
define void @example23c(i16* noalias nocapture %src, i32* noalias nocapture %dst) optsize {
; CHECK-LABEL: @example23c(
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE16:%.*]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> poison, i64 [[INDEX]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = or <4 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult <4 x i64> [[VEC_IV]], <i64 257, i64 257, i64 257, i64 257>
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x i1> [[TMP1]], i64 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[NEXT_GEP7:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i16, i16* [[SRC:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = load i16, i16* [[NEXT_GEP]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = zext i16 [[TMP3]] to i32
; CHECK-NEXT:    [[TMP5:%.*]] = shl nuw nsw i32 [[TMP4]], 7
; CHECK-NEXT:    store i32 [[TMP5]], i32* [[NEXT_GEP7]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x i1> [[TMP1]], i64 1
; CHECK-NEXT:    br i1 [[TMP6]], label [[PRED_STORE_IF11:%.*]], label [[PRED_STORE_CONTINUE12:%.*]]
; CHECK:       pred.store.if11:
; CHECK-NEXT:    [[TMP7:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP8:%.*]] = getelementptr i32, i32* [[DST]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP8:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP4:%.*]] = getelementptr i16, i16* [[SRC]], i64 [[TMP8]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i16, i16* [[NEXT_GEP4]], align 2
; CHECK-NEXT:    [[TMP10:%.*]] = zext i16 [[TMP9]] to i32
; CHECK-NEXT:    [[TMP11:%.*]] = shl nuw nsw i32 [[TMP10]], 7
; CHECK-NEXT:    store i32 [[TMP11]], i32* [[NEXT_GEP8]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE12]]
; CHECK:       pred.store.continue12:
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x i1> [[TMP1]], i64 2
; CHECK-NEXT:    br i1 [[TMP12]], label [[PRED_STORE_IF13:%.*]], label [[PRED_STORE_CONTINUE14:%.*]]
; CHECK:       pred.store.if13:
; CHECK-NEXT:    [[TMP13:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP9:%.*]] = getelementptr i32, i32* [[DST]], i64 [[TMP13]]
; CHECK-NEXT:    [[TMP14:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP5:%.*]] = getelementptr i16, i16* [[SRC]], i64 [[TMP14]]
; CHECK-NEXT:    [[TMP15:%.*]] = load i16, i16* [[NEXT_GEP5]], align 2
; CHECK-NEXT:    [[TMP16:%.*]] = zext i16 [[TMP15]] to i32
; CHECK-NEXT:    [[TMP17:%.*]] = shl nuw nsw i32 [[TMP16]], 7
; CHECK-NEXT:    store i32 [[TMP17]], i32* [[NEXT_GEP9]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE14]]
; CHECK:       pred.store.continue14:
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <4 x i1> [[TMP1]], i64 3
; CHECK-NEXT:    br i1 [[TMP18]], label [[PRED_STORE_IF15:%.*]], label [[PRED_STORE_CONTINUE16]]
; CHECK:       pred.store.if15:
; CHECK-NEXT:    [[TMP19:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP10:%.*]] = getelementptr i32, i32* [[DST]], i64 [[TMP19]]
; CHECK-NEXT:    [[TMP20:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP6:%.*]] = getelementptr i16, i16* [[SRC]], i64 [[TMP20]]
; CHECK-NEXT:    [[TMP21:%.*]] = load i16, i16* [[NEXT_GEP6]], align 2
; CHECK-NEXT:    [[TMP22:%.*]] = zext i16 [[TMP21]] to i32
; CHECK-NEXT:    [[TMP23:%.*]] = shl nuw nsw i32 [[TMP22]], 7
; CHECK-NEXT:    store i32 [[TMP23]], i32* [[NEXT_GEP10]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE16]]
; CHECK:       pred.store.continue16:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP24:%.*]] = icmp eq i64 [[INDEX_NEXT]], 260
; CHECK-NEXT:    br i1 [[TMP24]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[TMP26:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[TMP25:%.*]]
; CHECK:       25:
; CHECK-NEXT:    br i1 poison, label [[TMP26]], label [[TMP25]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       26:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i64 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i64 %i.02, 1
  %exitcond = icmp eq i64 %7, 257
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}

; We CAN'T vectorize this example because it would entail a tail and an
; induction is used outside the loop.
define i64 @example23d(i16* noalias nocapture %src, i32* noalias nocapture %dst) optsize {
; CHECK-LABEL: @example23d(
; CHECK-NEXT:    br label [[TMP1:%.*]]
; CHECK:       1:
; CHECK-NEXT:    [[DOT04:%.*]] = phi i16* [ [[SRC:%.*]], [[TMP0:%.*]] ], [ [[TMP2:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[DOT013:%.*]] = phi i32* [ [[DST:%.*]], [[TMP0]] ], [ [[TMP6:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[I_02:%.*]] = phi i64 [ 0, [[TMP0]] ], [ [[TMP7:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[TMP2]] = getelementptr inbounds i16, i16* [[DOT04]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i16, i16* [[DOT04]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = zext i16 [[TMP3]] to i32
; CHECK-NEXT:    [[TMP5:%.*]] = shl nuw nsw i32 [[TMP4]], 7
; CHECK-NEXT:    [[TMP6]] = getelementptr inbounds i32, i32* [[DOT013]], i64 1
; CHECK-NEXT:    store i32 [[TMP5]], i32* [[DOT013]], align 4
; CHECK-NEXT:    [[TMP7]] = add nuw nsw i64 [[I_02]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[TMP7]], 257
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[TMP8:%.*]], label [[TMP1]]
; CHECK:       8:
; CHECK-NEXT:    ret i64 [[TMP7]]
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i64 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i64 %i.02, 1
  %exitcond = icmp eq i64 %7, 257
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret i64 %7
}
