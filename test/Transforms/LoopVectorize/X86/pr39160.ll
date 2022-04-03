; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -S < %s 2>&1 | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"
target triple = "x86_64-unknown-linux-gnu"

; Make sure that we can compile the test without crash.
define void @barney() {
; CHECK-LABEL: @barney(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP4:%.*]] = icmp slt i32 undef, 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[BB2]], label [[BB5:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 undef, i64 1)
; CHECK-NEXT:    br label [[BB19:%.*]]
; CHECK:       bb18:
; CHECK-NEXT:    ret void
; CHECK:       bb19:
; CHECK-NEXT:    [[TMP22:%.*]] = phi i32 [ [[TMP65_LCSSA:%.*]], [[BB36:%.*]] ], [ undef, [[BB5]] ]
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[UMAX]], 32
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[UMAX]], 32
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[UMAX]], [[N_MOD_VF]]
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = mul i32 [[CAST_CRD]], 13
; CHECK-NEXT:    [[IND_END:%.*]] = add i32 [[TMP22]], [[TMP0]]
; CHECK-NEXT:    [[IND_END3:%.*]] = add i64 1, [[N_VEC]]
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <16 x i32> poison, i32 [[TMP22]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <16 x i32> [[DOTSPLATINSERT]], <16 x i32> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <16 x i32> [[DOTSPLAT]], <i32 0, i32 13, i32 26, i32 39, i32 52, i32 65, i32 78, i32 91, i32 104, i32 117, i32 130, i32 143, i32 156, i32 169, i32 182, i32 195>
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <16 x i32> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[STEP_ADD:%.*]] = add <16 x i32> [[VEC_IND]], <i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208>
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = add i64 1, [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[OFFSET_IDX]], 16
; CHECK-NEXT:    [[TMP3:%.*]] = add <16 x i32> [[VEC_IND]], <i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13>
; CHECK-NEXT:    [[TMP4:%.*]] = add <16 x i32> [[STEP_ADD]], <i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13, i32 13>
; CHECK-NEXT:    [[TMP5:%.*]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = add nuw nsw i64 [[TMP2]], 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 32
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <16 x i32> [[STEP_ADD]], <i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208, i32 208>
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[UMAX]], [[N_VEC]]
; CHECK-NEXT:    [[TMP8:%.*]] = sub i64 [[N_VEC]], 1
; CHECK-NEXT:    [[CAST_CMO:%.*]] = trunc i64 [[TMP8]] to i32
; CHECK-NEXT:    [[TMP9:%.*]] = mul i32 [[CAST_CMO]], 13
; CHECK-NEXT:    [[IND_ESCAPE:%.*]] = add i32 [[TMP22]], [[TMP9]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[BB46:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[TMP22]], [[BB19]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL2:%.*]] = phi i64 [ [[IND_END3]], [[MIDDLE_BLOCK]] ], [ 1, [[BB19]] ]
; CHECK-NEXT:    br label [[BB50:%.*]]
; CHECK:       bb33:
; CHECK-NEXT:    [[TMP65_LCSSA]] = phi i32 [ [[TMP65:%.*]], [[BB62:%.*]] ]
; CHECK-NEXT:    br i1 true, label [[BB18:%.*]], label [[BB36]]
; CHECK:       bb36:
; CHECK-NEXT:    br label [[BB19]]
; CHECK:       bb46:
; CHECK-NEXT:    [[TMP52_LCSSA:%.*]] = phi i32 [ [[TMP52:%.*]], [[BB50]] ], [ [[IND_ESCAPE]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[TMP55_LCSSA:%.*]] = phi i32 [ [[TMP55:%.*]], [[BB50]] ], [ [[IND_END]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[TMP56_LCSSA:%.*]] = phi i64 [ [[TMP56:%.*]], [[BB50]] ], [ [[IND_END3]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br i1 true, label [[BB48:%.*]], label [[BB59:%.*]]
; CHECK:       bb48:
; CHECK-NEXT:    [[TMP52_LCSSA_LCSSA:%.*]] = phi i32 [ [[TMP52_LCSSA]], [[BB46]] ]
; CHECK-NEXT:    [[TMP49:%.*]] = add i32 [[TMP52_LCSSA_LCSSA]], 14
; CHECK-NEXT:    ret void
; CHECK:       bb50:
; CHECK-NEXT:    [[TMP52]] = phi i32 [ [[TMP55]], [[BB50]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[TMP53:%.*]] = phi i64 [ [[TMP56]], [[BB50]] ], [ [[BC_RESUME_VAL2]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[TMP54:%.*]] = add i32 [[TMP52]], 12
; CHECK-NEXT:    [[TMP55]] = add i32 [[TMP52]], 13
; CHECK-NEXT:    [[TMP56]] = add nuw nsw i64 [[TMP53]], 1
; CHECK-NEXT:    [[TMP58:%.*]] = icmp ult i64 [[TMP53]], undef
; CHECK-NEXT:    br i1 [[TMP58]], label [[BB50]], label [[BB46]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       bb59:
; CHECK-NEXT:    br label [[BB62]]
; CHECK:       bb62:
; CHECK-NEXT:    [[TMP63:%.*]] = phi i32 [ [[TMP65]], [[BB68:%.*]] ], [ [[TMP55_LCSSA]], [[BB59]] ]
; CHECK-NEXT:    [[TMP64:%.*]] = phi i64 [ [[TMP66:%.*]], [[BB68]] ], [ [[TMP56_LCSSA]], [[BB59]] ]
; CHECK-NEXT:    [[TMP65]] = add i32 [[TMP63]], 13
; CHECK-NEXT:    [[TMP66]] = add nuw nsw i64 [[TMP64]], 1
; CHECK-NEXT:    [[TMP67:%.*]] = icmp ult i64 [[TMP66]], 2
; CHECK-NEXT:    br i1 [[TMP67]], label [[BB68]], label [[BB33:%.*]]
; CHECK:       bb68:
; CHECK-NEXT:    br label [[BB62]]
;

bb:
  br label %bb2

bb2:                                              ; preds = %bb2, %bb
  %tmp4 = icmp slt i32 undef, 0
  br i1 %tmp4, label %bb2, label %bb5

bb5:                                              ; preds = %bb2
  br label %bb19

bb18:                                             ; preds = %bb33
  ret void

bb19:                                             ; preds = %bb36, %bb5
  %tmp21 = phi i64 [ undef, %bb36 ], [ 2, %bb5 ]
  %tmp22 = phi i32 [ %tmp65, %bb36 ], [ undef, %bb5 ]
  br label %bb50

bb33:                                             ; preds = %bb62
  br i1 undef, label %bb18, label %bb36

bb36:                                             ; preds = %bb33
  br label %bb19

bb46:                                             ; preds = %bb50
  br i1 undef, label %bb48, label %bb59

bb48:                                             ; preds = %bb46
  %tmp49 = add i32 %tmp52, 14
  ret void

bb50:                                             ; preds = %bb50, %bb19
  %tmp52 = phi i32 [ %tmp55, %bb50 ], [ %tmp22, %bb19 ]
  %tmp53 = phi i64 [ %tmp56, %bb50 ], [ 1, %bb19 ]
  %tmp54 = add i32 %tmp52, 12
  %tmp55 = add i32 %tmp52, 13
  %tmp56 = add nuw nsw i64 %tmp53, 1
  %tmp58 = icmp ult i64 %tmp53, undef
  br i1 %tmp58, label %bb50, label %bb46

bb59:                                             ; preds = %bb46
  br label %bb62

bb62:                                             ; preds = %bb68, %bb59
  %tmp63 = phi i32 [ %tmp65, %bb68 ], [ %tmp55, %bb59 ]
  %tmp64 = phi i64 [ %tmp66, %bb68 ], [ %tmp56, %bb59 ]
  %tmp65 = add i32 %tmp63, 13
  %tmp66 = add nuw nsw i64 %tmp64, 1
  %tmp67 = icmp ult i64 %tmp66, %tmp21
  br i1 %tmp67, label %bb68, label %bb33

bb68:                                             ; preds = %bb62
  br label %bb62
}

define i32 @foo(i32 addrspace(1)* %p) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER:%.*]]
; CHECK:       outer:
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i32 [ [[INDVAR_NEXT:%.*]], [[OUTER_LATCH:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 2, [[ENTRY]] ], [ [[IV_NEXT:%.*]], [[OUTER_LATCH]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDVAR]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP0]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP0]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP0]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = add i32 1, [[N_VEC]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[N_VEC]], 2
; CHECK-NEXT:    [[IND_END2:%.*]] = add i32 6, [[TMP1]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 6, i32 8, i32 10, i32 12>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2]] = or <4 x i32> [[VEC_PHI]], [[VEC_IND]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 8, i32 8, i32 8, i32 8>
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP3]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP4:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP2]])
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP0]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[OUTER_LATCH]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 1, [[OUTER]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i32 [ [[IND_END2]], [[MIDDLE_BLOCK]] ], [ 6, [[OUTER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[OUTER]] ], [ [[TMP4]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[TMP5:%.*]] = phi i32 [ [[TMP7:%.*]], [[INNER]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ [[TMP8:%.*]], [[INNER]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[B:%.*]] = phi i32 [ [[TMP6:%.*]], [[INNER]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[TMP6]] = add i32 [[B]], 2
; CHECK-NEXT:    [[TMP7]] = or i32 [[TMP5]], [[B]]
; CHECK-NEXT:    [[TMP8]] = add nuw nsw i32 [[A]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = zext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = icmp ugt i64 [[IV]], [[TMP9]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[INNER]], label [[OUTER_LATCH]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       outer_latch:
; CHECK-NEXT:    [[DOTLCSSA:%.*]] = phi i32 [ [[TMP7]], [[INNER]] ], [ [[TMP4]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    store atomic i32 [[DOTLCSSA]], i32 addrspace(1)* [[P:%.*]] unordered, align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ugt i64 [[IV]], 63
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i32 [[INDVAR]], 1
; CHECK-NEXT:    br i1 [[TMP11]], label [[EXIT:%.*]], label [[OUTER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
;

entry:
  br label %outer

outer:                                            ; preds = %outer_latch, %entry
  %iv = phi i64 [ 2, %entry ], [ %iv.next, %outer_latch ]
  br label %inner

inner:                                            ; preds = %inner, %outer
  %0 = phi i32 [ %2, %inner ], [ 0, %outer ]
  %a = phi i32 [ %3, %inner ], [ 1, %outer ]
  %b = phi i32 [ %1, %inner ], [ 6, %outer ]
  %1 = add i32 %b, 2
  %2 = or i32 %0, %b
  %3 = add nuw nsw i32 %a, 1
  %4 = zext i32 %3 to i64
  %5 = icmp ugt i64 %iv, %4
  br i1 %5, label %inner, label %outer_latch

outer_latch:                                      ; preds = %inner
  store atomic i32 %2, i32 addrspace(1)* %p unordered, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %6 = icmp ugt i64 %iv, 63
  br i1 %6, label %exit, label %outer

exit:                                             ; preds = %outer_latch
  ret i32 0
}
