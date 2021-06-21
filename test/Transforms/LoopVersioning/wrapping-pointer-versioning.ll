; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-versioning -S < %s | FileCheck %s -check-prefix=LV

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; For this loop:
;   unsigned index = 0;
;   for (int i = 0; i < n; i++) {
;    A[2 * index] = A[2 * index] + B[i];
;    index++;
;   }
;
; SCEV is unable to prove that A[2 * i] does not overflow.
;
; Analyzing the IR does not help us because the GEPs are not
; affine AddRecExprs. However, we can turn them into AddRecExprs
; using SCEV Predicates.
;
; Once we have an affine expression we need to add an additional NUSW
; to check that the pointers don't wrap since the GEPs are not
; inbound.

; The expression for %mul_ext as analyzed by SCEV is
;    (zext i32 {0,+,2}<%for.body> to i64)
; We have added the nusw flag to turn this expression into the SCEV expression:
;    i64 {0,+,2}<%for.body>

define void @f1(i16* noalias %a,
; LV-LABEL: @f1(
; LV-NEXT:  for.body.lver.check:
; LV-NEXT:    [[A2:%.*]] = ptrtoint i16* [[A:%.*]] to i64
; LV-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], -1
; LV-NEXT:    [[TMP1:%.*]] = trunc i64 [[TMP0]] to i32
; LV-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 2, i32 [[TMP1]])
; LV-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; LV-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; LV-NEXT:    [[TMP2:%.*]] = add i32 0, [[MUL_RESULT]]
; LV-NEXT:    [[TMP3:%.*]] = sub i32 0, [[MUL_RESULT]]
; LV-NEXT:    [[TMP4:%.*]] = icmp ugt i32 [[TMP3]], 0
; LV-NEXT:    [[TMP5:%.*]] = icmp ult i32 [[TMP2]], 0
; LV-NEXT:    [[TMP6:%.*]] = select i1 false, i1 [[TMP4]], i1 [[TMP5]]
; LV-NEXT:    [[TMP7:%.*]] = icmp ugt i64 [[TMP0]], 4294967295
; LV-NEXT:    [[TMP8:%.*]] = or i1 [[TMP6]], [[TMP7]]
; LV-NEXT:    [[TMP9:%.*]] = or i1 [[TMP8]], [[MUL_OVERFLOW]]
; LV-NEXT:    [[TMP10:%.*]] = or i1 false, [[TMP9]]
; LV-NEXT:    [[MUL3:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 4, i64 [[TMP0]])
; LV-NEXT:    [[MUL_RESULT4:%.*]] = extractvalue { i64, i1 } [[MUL3]], 0
; LV-NEXT:    [[MUL_OVERFLOW5:%.*]] = extractvalue { i64, i1 } [[MUL3]], 1
; LV-NEXT:    [[TMP11:%.*]] = add i64 [[A2]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP12:%.*]] = sub i64 [[A2]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP13:%.*]] = icmp ugt i64 [[TMP12]], [[A2]]
; LV-NEXT:    [[TMP14:%.*]] = icmp ult i64 [[TMP11]], [[A2]]
; LV-NEXT:    [[TMP15:%.*]] = select i1 false, i1 [[TMP13]], i1 [[TMP14]]
; LV-NEXT:    [[TMP16:%.*]] = or i1 [[TMP15]], [[MUL_OVERFLOW5]]
; LV-NEXT:    [[TMP17:%.*]] = or i1 [[TMP10]], [[TMP16]]
; LV-NEXT:    br i1 [[TMP17]], label [[FOR_BODY_PH_LVER_ORIG:%.*]], label [[FOR_BODY_PH:%.*]]
; LV:       for.body.ph.lver.orig:
; LV-NEXT:    br label [[FOR_BODY_LVER_ORIG:%.*]]
; LV:       for.body.lver.orig:
; LV-NEXT:    [[IND_LVER_ORIG:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[IND1_LVER_ORIG:%.*]] = phi i32 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC1_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[MUL_LVER_ORIG:%.*]] = mul i32 [[IND1_LVER_ORIG]], 2
; LV-NEXT:    [[MUL_EXT_LVER_ORIG:%.*]] = zext i32 [[MUL_LVER_ORIG]] to i64
; LV-NEXT:    [[ARRAYIDXA_LVER_ORIG:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT_LVER_ORIG]]
; LV-NEXT:    [[LOADA_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[ARRAYIDXB_LVER_ORIG:%.*]] = getelementptr i16, i16* [[B:%.*]], i64 [[IND_LVER_ORIG]]
; LV-NEXT:    [[LOADB_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXB_LVER_ORIG]], align 2
; LV-NEXT:    [[ADD_LVER_ORIG:%.*]] = mul i16 [[LOADA_LVER_ORIG]], [[LOADB_LVER_ORIG]]
; LV-NEXT:    store i16 [[ADD_LVER_ORIG]], i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[INC_LVER_ORIG]] = add nuw nsw i64 [[IND_LVER_ORIG]], 1
; LV-NEXT:    [[INC1_LVER_ORIG]] = add i32 [[IND1_LVER_ORIG]], 1
; LV-NEXT:    [[EXITCOND_LVER_ORIG:%.*]] = icmp eq i64 [[INC_LVER_ORIG]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND_LVER_ORIG]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LVER_ORIG]]
; LV:       for.body.ph:
; LV-NEXT:    br label [[FOR_BODY:%.*]]
; LV:       for.body:
; LV-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[FOR_BODY_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[IND1:%.*]] = phi i32 [ 0, [[FOR_BODY_PH]] ], [ [[INC1:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; LV-NEXT:    [[MUL_EXT:%.*]] = zext i32 [[MUL]] to i64
; LV-NEXT:    [[ARRAYIDXA:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT]]
; LV-NEXT:    [[LOADA:%.*]] = load i16, i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[ARRAYIDXB:%.*]] = getelementptr i16, i16* [[B]], i64 [[IND]]
; LV-NEXT:    [[LOADB:%.*]] = load i16, i16* [[ARRAYIDXB]], align 2
; LV-NEXT:    [[ADD:%.*]] = mul i16 [[LOADA]], [[LOADB]]
; LV-NEXT:    store i16 [[ADD]], i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[INC]] = add nuw nsw i64 [[IND]], 1
; LV-NEXT:    [[INC1]] = add i32 [[IND1]], 1
; LV-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INC]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT6:%.*]], label [[FOR_BODY]]
; LV:       for.end.loopexit:
; LV-NEXT:    br label [[FOR_END:%.*]]
; LV:       for.end.loopexit6:
; LV-NEXT:    br label [[FOR_END]]
; LV:       for.end:
; LV-NEXT:    ret void
;
  i16* noalias %b, i64 %N) {
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %ind1 = phi i32 [ 0, %entry ], [ %inc1, %for.body ]

  %mul = mul i32 %ind1, 2
  %mul_ext = zext i32 %mul to i64

  %arrayidxA = getelementptr i16, i16* %a, i64 %mul_ext
  %loadA = load i16, i16* %arrayidxA, align 2

  %arrayidxB = getelementptr i16, i16* %b, i64 %ind
  %loadB = load i16, i16* %arrayidxB, align 2

  %add = mul i16 %loadA, %loadB

  store i16 %add, i16* %arrayidxA, align 2

  %inc = add nuw nsw i64 %ind, 1
  %inc1 = add i32 %ind1, 1

  %exitcond = icmp eq i64 %inc, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

; For this loop:
;   unsigned index = n;
;   for (int i = 0; i < n; i++) {
;    A[2 * index] = A[2 * index] + B[i];
;    index--;
;   }
;
; the SCEV expression for 2 * index is not an AddRecExpr
; (and implictly not affine). However, we are able to make assumptions
; that will turn the expression into an affine one and continue the
; analysis.
;
; Once we have an affine expression we need to add an additional NUSW
; to check that the pointers don't wrap since the GEPs are not
; inbounds.
;
; This loop has a negative stride for A, and the nusw flag is required in
; order to properly extend the increment from i32 -4 to i64 -4.

; The expression for %mul_ext as analyzed by SCEV is
;     (zext i32 {(2 * (trunc i64 %N to i32)),+,-2}<%for.body> to i64)
; We have added the nusw flag to turn this expression into the following SCEV:
;     i64 {zext i32 (2 * (trunc i64 %N to i32)) to i64,+,-2}<%for.body>

define void @f2(i16* noalias %a,
; LV-LABEL: @f2(
; LV-NEXT:  for.body.lver.check:
; LV-NEXT:    [[A2:%.*]] = ptrtoint i16* [[A:%.*]] to i64
; LV-NEXT:    [[TRUNCN:%.*]] = trunc i64 [[N:%.*]] to i32
; LV-NEXT:    [[TMP0:%.*]] = add i64 [[N]], -1
; LV-NEXT:    [[TMP1:%.*]] = shl i32 [[TRUNCN]], 1
; LV-NEXT:    [[TMP2:%.*]] = trunc i64 [[TMP0]] to i32
; LV-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 2, i32 [[TMP2]])
; LV-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; LV-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; LV-NEXT:    [[TMP3:%.*]] = add i32 [[TMP1]], [[MUL_RESULT]]
; LV-NEXT:    [[TMP4:%.*]] = sub i32 [[TMP1]], [[MUL_RESULT]]
; LV-NEXT:    [[TMP5:%.*]] = icmp ugt i32 [[TMP4]], [[TMP1]]
; LV-NEXT:    [[TMP6:%.*]] = icmp ult i32 [[TMP3]], [[TMP1]]
; LV-NEXT:    [[TMP7:%.*]] = select i1 true, i1 [[TMP5]], i1 [[TMP6]]
; LV-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[TMP0]], 4294967295
; LV-NEXT:    [[TMP9:%.*]] = or i1 [[TMP7]], [[TMP8]]
; LV-NEXT:    [[TMP10:%.*]] = or i1 [[TMP9]], [[MUL_OVERFLOW]]
; LV-NEXT:    [[TMP11:%.*]] = or i1 false, [[TMP10]]
; LV-NEXT:    [[TMP12:%.*]] = trunc i64 [[N]] to i31
; LV-NEXT:    [[TMP13:%.*]] = zext i31 [[TMP12]] to i64
; LV-NEXT:    [[TMP14:%.*]] = shl nuw nsw i64 [[TMP13]], 2
; LV-NEXT:    [[TMP15:%.*]] = add i64 [[A2]], [[TMP14]]
; LV-NEXT:    [[MUL3:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 4, i64 [[TMP0]])
; LV-NEXT:    [[MUL_RESULT4:%.*]] = extractvalue { i64, i1 } [[MUL3]], 0
; LV-NEXT:    [[MUL_OVERFLOW5:%.*]] = extractvalue { i64, i1 } [[MUL3]], 1
; LV-NEXT:    [[TMP16:%.*]] = add i64 [[TMP15]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP17:%.*]] = sub i64 [[TMP15]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP18:%.*]] = icmp ugt i64 [[TMP17]], [[TMP15]]
; LV-NEXT:    [[TMP19:%.*]] = icmp ult i64 [[TMP16]], [[TMP15]]
; LV-NEXT:    [[TMP20:%.*]] = select i1 true, i1 [[TMP18]], i1 [[TMP19]]
; LV-NEXT:    [[TMP21:%.*]] = or i1 [[TMP20]], [[MUL_OVERFLOW5]]
; LV-NEXT:    [[TMP22:%.*]] = or i1 [[TMP11]], [[TMP21]]
; LV-NEXT:    br i1 [[TMP22]], label [[FOR_BODY_PH_LVER_ORIG:%.*]], label [[FOR_BODY_PH:%.*]]
; LV:       for.body.ph.lver.orig:
; LV-NEXT:    br label [[FOR_BODY_LVER_ORIG:%.*]]
; LV:       for.body.lver.orig:
; LV-NEXT:    [[IND_LVER_ORIG:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[IND1_LVER_ORIG:%.*]] = phi i32 [ [[TRUNCN]], [[FOR_BODY_PH_LVER_ORIG]] ], [ [[DEC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[MUL_LVER_ORIG:%.*]] = mul i32 [[IND1_LVER_ORIG]], 2
; LV-NEXT:    [[MUL_EXT_LVER_ORIG:%.*]] = zext i32 [[MUL_LVER_ORIG]] to i64
; LV-NEXT:    [[ARRAYIDXA_LVER_ORIG:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT_LVER_ORIG]]
; LV-NEXT:    [[LOADA_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[ARRAYIDXB_LVER_ORIG:%.*]] = getelementptr i16, i16* [[B:%.*]], i64 [[IND_LVER_ORIG]]
; LV-NEXT:    [[LOADB_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXB_LVER_ORIG]], align 2
; LV-NEXT:    [[ADD_LVER_ORIG:%.*]] = mul i16 [[LOADA_LVER_ORIG]], [[LOADB_LVER_ORIG]]
; LV-NEXT:    store i16 [[ADD_LVER_ORIG]], i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[INC_LVER_ORIG]] = add nuw nsw i64 [[IND_LVER_ORIG]], 1
; LV-NEXT:    [[DEC_LVER_ORIG]] = sub i32 [[IND1_LVER_ORIG]], 1
; LV-NEXT:    [[EXITCOND_LVER_ORIG:%.*]] = icmp eq i64 [[INC_LVER_ORIG]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND_LVER_ORIG]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LVER_ORIG]]
; LV:       for.body.ph:
; LV-NEXT:    br label [[FOR_BODY:%.*]]
; LV:       for.body:
; LV-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[FOR_BODY_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[IND1:%.*]] = phi i32 [ [[TRUNCN]], [[FOR_BODY_PH]] ], [ [[DEC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; LV-NEXT:    [[MUL_EXT:%.*]] = zext i32 [[MUL]] to i64
; LV-NEXT:    [[ARRAYIDXA:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT]]
; LV-NEXT:    [[LOADA:%.*]] = load i16, i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[ARRAYIDXB:%.*]] = getelementptr i16, i16* [[B]], i64 [[IND]]
; LV-NEXT:    [[LOADB:%.*]] = load i16, i16* [[ARRAYIDXB]], align 2
; LV-NEXT:    [[ADD:%.*]] = mul i16 [[LOADA]], [[LOADB]]
; LV-NEXT:    store i16 [[ADD]], i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[INC]] = add nuw nsw i64 [[IND]], 1
; LV-NEXT:    [[DEC]] = sub i32 [[IND1]], 1
; LV-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INC]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT6:%.*]], label [[FOR_BODY]]
; LV:       for.end.loopexit:
; LV-NEXT:    br label [[FOR_END:%.*]]
; LV:       for.end.loopexit6:
; LV-NEXT:    br label [[FOR_END]]
; LV:       for.end:
; LV-NEXT:    ret void
;
  i16* noalias %b, i64 %N) {
entry:
  %TruncN = trunc i64 %N to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %ind1 = phi i32 [ %TruncN, %entry ], [ %dec, %for.body ]

  %mul = mul i32 %ind1, 2
  %mul_ext = zext i32 %mul to i64

  %arrayidxA = getelementptr i16, i16* %a, i64 %mul_ext
  %loadA = load i16, i16* %arrayidxA, align 2

  %arrayidxB = getelementptr i16, i16* %b, i64 %ind
  %loadB = load i16, i16* %arrayidxB, align 2

  %add = mul i16 %loadA, %loadB

  store i16 %add, i16* %arrayidxA, align 2

  %inc = add nuw nsw i64 %ind, 1
  %dec = sub i32 %ind1, 1

  %exitcond = icmp eq i64 %inc, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

; We replicate the tests above, but this time sign extend 2 * index instead
; of zero extending it.

; The expression for %mul_ext as analyzed by SCEV is
;     i64 (sext i32 {0,+,2}<%for.body> to i64)
; We have added the nssw flag to turn this expression into the following SCEV:
;     i64 {0,+,2}<%for.body>

define void @f3(i16* noalias %a,
; LV-LABEL: @f3(
; LV-NEXT:  for.body.lver.check:
; LV-NEXT:    [[A2:%.*]] = ptrtoint i16* [[A:%.*]] to i64
; LV-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], -1
; LV-NEXT:    [[TMP1:%.*]] = trunc i64 [[TMP0]] to i32
; LV-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 2, i32 [[TMP1]])
; LV-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; LV-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; LV-NEXT:    [[TMP2:%.*]] = add i32 0, [[MUL_RESULT]]
; LV-NEXT:    [[TMP3:%.*]] = sub i32 0, [[MUL_RESULT]]
; LV-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[TMP3]], 0
; LV-NEXT:    [[TMP5:%.*]] = icmp slt i32 [[TMP2]], 0
; LV-NEXT:    [[TMP6:%.*]] = select i1 false, i1 [[TMP4]], i1 [[TMP5]]
; LV-NEXT:    [[TMP7:%.*]] = icmp ugt i64 [[TMP0]], 4294967295
; LV-NEXT:    [[TMP8:%.*]] = or i1 [[TMP6]], [[TMP7]]
; LV-NEXT:    [[TMP9:%.*]] = or i1 [[TMP8]], [[MUL_OVERFLOW]]
; LV-NEXT:    [[TMP10:%.*]] = or i1 false, [[TMP9]]
; LV-NEXT:    [[MUL3:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 4, i64 [[TMP0]])
; LV-NEXT:    [[MUL_RESULT4:%.*]] = extractvalue { i64, i1 } [[MUL3]], 0
; LV-NEXT:    [[MUL_OVERFLOW5:%.*]] = extractvalue { i64, i1 } [[MUL3]], 1
; LV-NEXT:    [[TMP11:%.*]] = add i64 [[A2]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP12:%.*]] = sub i64 [[A2]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP13:%.*]] = icmp ugt i64 [[TMP12]], [[A2]]
; LV-NEXT:    [[TMP14:%.*]] = icmp ult i64 [[TMP11]], [[A2]]
; LV-NEXT:    [[TMP15:%.*]] = select i1 false, i1 [[TMP13]], i1 [[TMP14]]
; LV-NEXT:    [[TMP16:%.*]] = or i1 [[TMP15]], [[MUL_OVERFLOW5]]
; LV-NEXT:    [[TMP17:%.*]] = or i1 [[TMP10]], [[TMP16]]
; LV-NEXT:    br i1 [[TMP17]], label [[FOR_BODY_PH_LVER_ORIG:%.*]], label [[FOR_BODY_PH:%.*]]
; LV:       for.body.ph.lver.orig:
; LV-NEXT:    br label [[FOR_BODY_LVER_ORIG:%.*]]
; LV:       for.body.lver.orig:
; LV-NEXT:    [[IND_LVER_ORIG:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[IND1_LVER_ORIG:%.*]] = phi i32 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC1_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[MUL_LVER_ORIG:%.*]] = mul i32 [[IND1_LVER_ORIG]], 2
; LV-NEXT:    [[MUL_EXT_LVER_ORIG:%.*]] = sext i32 [[MUL_LVER_ORIG]] to i64
; LV-NEXT:    [[ARRAYIDXA_LVER_ORIG:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT_LVER_ORIG]]
; LV-NEXT:    [[LOADA_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[ARRAYIDXB_LVER_ORIG:%.*]] = getelementptr i16, i16* [[B:%.*]], i64 [[IND_LVER_ORIG]]
; LV-NEXT:    [[LOADB_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXB_LVER_ORIG]], align 2
; LV-NEXT:    [[ADD_LVER_ORIG:%.*]] = mul i16 [[LOADA_LVER_ORIG]], [[LOADB_LVER_ORIG]]
; LV-NEXT:    store i16 [[ADD_LVER_ORIG]], i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[INC_LVER_ORIG]] = add nuw nsw i64 [[IND_LVER_ORIG]], 1
; LV-NEXT:    [[INC1_LVER_ORIG]] = add i32 [[IND1_LVER_ORIG]], 1
; LV-NEXT:    [[EXITCOND_LVER_ORIG:%.*]] = icmp eq i64 [[INC_LVER_ORIG]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND_LVER_ORIG]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LVER_ORIG]]
; LV:       for.body.ph:
; LV-NEXT:    br label [[FOR_BODY:%.*]]
; LV:       for.body:
; LV-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[FOR_BODY_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[IND1:%.*]] = phi i32 [ 0, [[FOR_BODY_PH]] ], [ [[INC1:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; LV-NEXT:    [[MUL_EXT:%.*]] = sext i32 [[MUL]] to i64
; LV-NEXT:    [[ARRAYIDXA:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT]]
; LV-NEXT:    [[LOADA:%.*]] = load i16, i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[ARRAYIDXB:%.*]] = getelementptr i16, i16* [[B]], i64 [[IND]]
; LV-NEXT:    [[LOADB:%.*]] = load i16, i16* [[ARRAYIDXB]], align 2
; LV-NEXT:    [[ADD:%.*]] = mul i16 [[LOADA]], [[LOADB]]
; LV-NEXT:    store i16 [[ADD]], i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[INC]] = add nuw nsw i64 [[IND]], 1
; LV-NEXT:    [[INC1]] = add i32 [[IND1]], 1
; LV-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INC]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT6:%.*]], label [[FOR_BODY]]
; LV:       for.end.loopexit:
; LV-NEXT:    br label [[FOR_END:%.*]]
; LV:       for.end.loopexit6:
; LV-NEXT:    br label [[FOR_END]]
; LV:       for.end:
; LV-NEXT:    ret void
;
  i16* noalias %b, i64 %N) {
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %ind1 = phi i32 [ 0, %entry ], [ %inc1, %for.body ]

  %mul = mul i32 %ind1, 2
  %mul_ext = sext i32 %mul to i64

  %arrayidxA = getelementptr i16, i16* %a, i64 %mul_ext
  %loadA = load i16, i16* %arrayidxA, align 2

  %arrayidxB = getelementptr i16, i16* %b, i64 %ind
  %loadB = load i16, i16* %arrayidxB, align 2

  %add = mul i16 %loadA, %loadB

  store i16 %add, i16* %arrayidxA, align 2

  %inc = add nuw nsw i64 %ind, 1
  %inc1 = add i32 %ind1, 1

  %exitcond = icmp eq i64 %inc, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

define void @f4(i16* noalias %a,
; LV-LABEL: @f4(
; LV-NEXT:  for.body.lver.check:
; LV-NEXT:    [[A2:%.*]] = ptrtoint i16* [[A:%.*]] to i64
; LV-NEXT:    [[TRUNCN:%.*]] = trunc i64 [[N:%.*]] to i32
; LV-NEXT:    [[TMP0:%.*]] = add i64 [[N]], -1
; LV-NEXT:    [[TMP1:%.*]] = shl i32 [[TRUNCN]], 1
; LV-NEXT:    [[TMP2:%.*]] = trunc i64 [[TMP0]] to i32
; LV-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 2, i32 [[TMP2]])
; LV-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; LV-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; LV-NEXT:    [[TMP3:%.*]] = add i32 [[TMP1]], [[MUL_RESULT]]
; LV-NEXT:    [[TMP4:%.*]] = sub i32 [[TMP1]], [[MUL_RESULT]]
; LV-NEXT:    [[TMP5:%.*]] = icmp sgt i32 [[TMP4]], [[TMP1]]
; LV-NEXT:    [[TMP6:%.*]] = icmp slt i32 [[TMP3]], [[TMP1]]
; LV-NEXT:    [[TMP7:%.*]] = select i1 true, i1 [[TMP5]], i1 [[TMP6]]
; LV-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[TMP0]], 4294967295
; LV-NEXT:    [[TMP9:%.*]] = or i1 [[TMP7]], [[TMP8]]
; LV-NEXT:    [[TMP10:%.*]] = or i1 [[TMP9]], [[MUL_OVERFLOW]]
; LV-NEXT:    [[TMP11:%.*]] = or i1 false, [[TMP10]]
; LV-NEXT:    [[TMP12:%.*]] = sext i32 [[TMP1]] to i64
; LV-NEXT:    [[TMP13:%.*]] = shl nsw i64 [[TMP12]], 1
; LV-NEXT:    [[TMP14:%.*]] = add i64 [[A2]], [[TMP13]]
; LV-NEXT:    [[MUL3:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 4, i64 [[TMP0]])
; LV-NEXT:    [[MUL_RESULT4:%.*]] = extractvalue { i64, i1 } [[MUL3]], 0
; LV-NEXT:    [[MUL_OVERFLOW5:%.*]] = extractvalue { i64, i1 } [[MUL3]], 1
; LV-NEXT:    [[TMP15:%.*]] = add i64 [[TMP14]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP16:%.*]] = sub i64 [[TMP14]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP17:%.*]] = icmp ugt i64 [[TMP16]], [[TMP14]]
; LV-NEXT:    [[TMP18:%.*]] = icmp ult i64 [[TMP15]], [[TMP14]]
; LV-NEXT:    [[TMP19:%.*]] = select i1 true, i1 [[TMP17]], i1 [[TMP18]]
; LV-NEXT:    [[TMP20:%.*]] = or i1 [[TMP19]], [[MUL_OVERFLOW5]]
; LV-NEXT:    [[TMP21:%.*]] = or i1 [[TMP11]], [[TMP20]]
; LV-NEXT:    br i1 [[TMP21]], label [[FOR_BODY_PH_LVER_ORIG:%.*]], label [[FOR_BODY_PH:%.*]]
; LV:       for.body.ph.lver.orig:
; LV-NEXT:    br label [[FOR_BODY_LVER_ORIG:%.*]]
; LV:       for.body.lver.orig:
; LV-NEXT:    [[IND_LVER_ORIG:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[IND1_LVER_ORIG:%.*]] = phi i32 [ [[TRUNCN]], [[FOR_BODY_PH_LVER_ORIG]] ], [ [[DEC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[MUL_LVER_ORIG:%.*]] = mul i32 [[IND1_LVER_ORIG]], 2
; LV-NEXT:    [[MUL_EXT_LVER_ORIG:%.*]] = sext i32 [[MUL_LVER_ORIG]] to i64
; LV-NEXT:    [[ARRAYIDXA_LVER_ORIG:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT_LVER_ORIG]]
; LV-NEXT:    [[LOADA_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[ARRAYIDXB_LVER_ORIG:%.*]] = getelementptr i16, i16* [[B:%.*]], i64 [[IND_LVER_ORIG]]
; LV-NEXT:    [[LOADB_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXB_LVER_ORIG]], align 2
; LV-NEXT:    [[ADD_LVER_ORIG:%.*]] = mul i16 [[LOADA_LVER_ORIG]], [[LOADB_LVER_ORIG]]
; LV-NEXT:    store i16 [[ADD_LVER_ORIG]], i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[INC_LVER_ORIG]] = add nuw nsw i64 [[IND_LVER_ORIG]], 1
; LV-NEXT:    [[DEC_LVER_ORIG]] = sub i32 [[IND1_LVER_ORIG]], 1
; LV-NEXT:    [[EXITCOND_LVER_ORIG:%.*]] = icmp eq i64 [[INC_LVER_ORIG]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND_LVER_ORIG]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LVER_ORIG]]
; LV:       for.body.ph:
; LV-NEXT:    br label [[FOR_BODY:%.*]]
; LV:       for.body:
; LV-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[FOR_BODY_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[IND1:%.*]] = phi i32 [ [[TRUNCN]], [[FOR_BODY_PH]] ], [ [[DEC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; LV-NEXT:    [[MUL_EXT:%.*]] = sext i32 [[MUL]] to i64
; LV-NEXT:    [[ARRAYIDXA:%.*]] = getelementptr i16, i16* [[A]], i64 [[MUL_EXT]]
; LV-NEXT:    [[LOADA:%.*]] = load i16, i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[ARRAYIDXB:%.*]] = getelementptr i16, i16* [[B]], i64 [[IND]]
; LV-NEXT:    [[LOADB:%.*]] = load i16, i16* [[ARRAYIDXB]], align 2
; LV-NEXT:    [[ADD:%.*]] = mul i16 [[LOADA]], [[LOADB]]
; LV-NEXT:    store i16 [[ADD]], i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[INC]] = add nuw nsw i64 [[IND]], 1
; LV-NEXT:    [[DEC]] = sub i32 [[IND1]], 1
; LV-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INC]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT6:%.*]], label [[FOR_BODY]]
; LV:       for.end.loopexit:
; LV-NEXT:    br label [[FOR_END:%.*]]
; LV:       for.end.loopexit6:
; LV-NEXT:    br label [[FOR_END]]
; LV:       for.end:
; LV-NEXT:    ret void
;
  i16* noalias %b, i64 %N) {
entry:
  %TruncN = trunc i64 %N to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %ind1 = phi i32 [ %TruncN, %entry ], [ %dec, %for.body ]

  %mul = mul i32 %ind1, 2
  %mul_ext = sext i32 %mul to i64

  %arrayidxA = getelementptr i16, i16* %a, i64 %mul_ext
  %loadA = load i16, i16* %arrayidxA, align 2

  %arrayidxB = getelementptr i16, i16* %b, i64 %ind
  %loadB = load i16, i16* %arrayidxB, align 2

  %add = mul i16 %loadA, %loadB

  store i16 %add, i16* %arrayidxA, align 2

  %inc = add nuw nsw i64 %ind, 1
  %dec = sub i32 %ind1, 1

  %exitcond = icmp eq i64 %inc, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

; The following function is similar to the one above, but has the GEP
; to pointer %A inbounds. The index %mul doesn't have the nsw flag.
; This means that the SCEV expression for %mul can wrap and we need
; a SCEV predicate to continue analysis.
;
; We can still analyze this by adding the required no wrap SCEV predicates.

define void @f5(i16* noalias %a,
; LV-LABEL: @f5(
; LV-NEXT:  for.body.lver.check:
; LV-NEXT:    [[A2:%.*]] = ptrtoint i16* [[A:%.*]] to i64
; LV-NEXT:    [[TRUNCN:%.*]] = trunc i64 [[N:%.*]] to i32
; LV-NEXT:    [[TMP0:%.*]] = add i64 [[N]], -1
; LV-NEXT:    [[TMP1:%.*]] = shl i32 [[TRUNCN]], 1
; LV-NEXT:    [[TMP2:%.*]] = trunc i64 [[TMP0]] to i32
; LV-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 2, i32 [[TMP2]])
; LV-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; LV-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; LV-NEXT:    [[TMP3:%.*]] = add i32 [[TMP1]], [[MUL_RESULT]]
; LV-NEXT:    [[TMP4:%.*]] = sub i32 [[TMP1]], [[MUL_RESULT]]
; LV-NEXT:    [[TMP5:%.*]] = icmp sgt i32 [[TMP4]], [[TMP1]]
; LV-NEXT:    [[TMP6:%.*]] = icmp slt i32 [[TMP3]], [[TMP1]]
; LV-NEXT:    [[TMP7:%.*]] = select i1 true, i1 [[TMP5]], i1 [[TMP6]]
; LV-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[TMP0]], 4294967295
; LV-NEXT:    [[TMP9:%.*]] = or i1 [[TMP7]], [[TMP8]]
; LV-NEXT:    [[TMP10:%.*]] = or i1 [[TMP9]], [[MUL_OVERFLOW]]
; LV-NEXT:    [[TMP11:%.*]] = or i1 false, [[TMP10]]
; LV-NEXT:    [[TMP12:%.*]] = sext i32 [[TMP1]] to i64
; LV-NEXT:    [[TMP13:%.*]] = shl nsw i64 [[TMP12]], 1
; LV-NEXT:    [[TMP14:%.*]] = add i64 [[A2]], [[TMP13]]
; LV-NEXT:    [[MUL3:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 4, i64 [[TMP0]])
; LV-NEXT:    [[MUL_RESULT4:%.*]] = extractvalue { i64, i1 } [[MUL3]], 0
; LV-NEXT:    [[MUL_OVERFLOW5:%.*]] = extractvalue { i64, i1 } [[MUL3]], 1
; LV-NEXT:    [[TMP15:%.*]] = add i64 [[TMP14]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP16:%.*]] = sub i64 [[TMP14]], [[MUL_RESULT4]]
; LV-NEXT:    [[TMP17:%.*]] = icmp ugt i64 [[TMP16]], [[TMP14]]
; LV-NEXT:    [[TMP18:%.*]] = icmp ult i64 [[TMP15]], [[TMP14]]
; LV-NEXT:    [[TMP19:%.*]] = select i1 true, i1 [[TMP17]], i1 [[TMP18]]
; LV-NEXT:    [[TMP20:%.*]] = or i1 [[TMP19]], [[MUL_OVERFLOW5]]
; LV-NEXT:    [[TMP21:%.*]] = or i1 [[TMP11]], [[TMP20]]
; LV-NEXT:    br i1 [[TMP21]], label [[FOR_BODY_PH_LVER_ORIG:%.*]], label [[FOR_BODY_PH:%.*]]
; LV:       for.body.ph.lver.orig:
; LV-NEXT:    br label [[FOR_BODY_LVER_ORIG:%.*]]
; LV:       for.body.lver.orig:
; LV-NEXT:    [[IND_LVER_ORIG:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[IND1_LVER_ORIG:%.*]] = phi i32 [ [[TRUNCN]], [[FOR_BODY_PH_LVER_ORIG]] ], [ [[DEC_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; LV-NEXT:    [[MUL_LVER_ORIG:%.*]] = mul i32 [[IND1_LVER_ORIG]], 2
; LV-NEXT:    [[ARRAYIDXA_LVER_ORIG:%.*]] = getelementptr inbounds i16, i16* [[A]], i32 [[MUL_LVER_ORIG]]
; LV-NEXT:    [[LOADA_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[ARRAYIDXB_LVER_ORIG:%.*]] = getelementptr inbounds i16, i16* [[B:%.*]], i64 [[IND_LVER_ORIG]]
; LV-NEXT:    [[LOADB_LVER_ORIG:%.*]] = load i16, i16* [[ARRAYIDXB_LVER_ORIG]], align 2
; LV-NEXT:    [[ADD_LVER_ORIG:%.*]] = mul i16 [[LOADA_LVER_ORIG]], [[LOADB_LVER_ORIG]]
; LV-NEXT:    store i16 [[ADD_LVER_ORIG]], i16* [[ARRAYIDXA_LVER_ORIG]], align 2
; LV-NEXT:    [[INC_LVER_ORIG]] = add nuw nsw i64 [[IND_LVER_ORIG]], 1
; LV-NEXT:    [[DEC_LVER_ORIG]] = sub i32 [[IND1_LVER_ORIG]], 1
; LV-NEXT:    [[EXITCOND_LVER_ORIG:%.*]] = icmp eq i64 [[INC_LVER_ORIG]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND_LVER_ORIG]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LVER_ORIG]]
; LV:       for.body.ph:
; LV-NEXT:    br label [[FOR_BODY:%.*]]
; LV:       for.body:
; LV-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[FOR_BODY_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[IND1:%.*]] = phi i32 [ [[TRUNCN]], [[FOR_BODY_PH]] ], [ [[DEC:%.*]], [[FOR_BODY]] ]
; LV-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; LV-NEXT:    [[ARRAYIDXA:%.*]] = getelementptr inbounds i16, i16* [[A]], i32 [[MUL]]
; LV-NEXT:    [[LOADA:%.*]] = load i16, i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[ARRAYIDXB:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 [[IND]]
; LV-NEXT:    [[LOADB:%.*]] = load i16, i16* [[ARRAYIDXB]], align 2
; LV-NEXT:    [[ADD:%.*]] = mul i16 [[LOADA]], [[LOADB]]
; LV-NEXT:    store i16 [[ADD]], i16* [[ARRAYIDXA]], align 2
; LV-NEXT:    [[INC]] = add nuw nsw i64 [[IND]], 1
; LV-NEXT:    [[DEC]] = sub i32 [[IND1]], 1
; LV-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INC]], [[N]]
; LV-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT6:%.*]], label [[FOR_BODY]]
; LV:       for.end.loopexit:
; LV-NEXT:    br label [[FOR_END:%.*]]
; LV:       for.end.loopexit6:
; LV-NEXT:    br label [[FOR_END]]
; LV:       for.end:
; LV-NEXT:    ret void
;
  i16* noalias %b, i64 %N) {
entry:
  %TruncN = trunc i64 %N to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %ind1 = phi i32 [ %TruncN, %entry ], [ %dec, %for.body ]

  %mul = mul i32 %ind1, 2

  %arrayidxA = getelementptr inbounds i16, i16* %a, i32 %mul
  %loadA = load i16, i16* %arrayidxA, align 2

  %arrayidxB = getelementptr inbounds i16, i16* %b, i64 %ind
  %loadB = load i16, i16* %arrayidxB, align 2

  %add = mul i16 %loadA, %loadB

  store i16 %add, i16* %arrayidxA, align 2

  %inc = add nuw nsw i64 %ind, 1
  %dec = sub i32 %ind1, 1

  %exitcond = icmp eq i64 %inc, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}
