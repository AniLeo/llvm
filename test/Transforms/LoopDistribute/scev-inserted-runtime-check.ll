; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -loop-distribute -enable-loop-distribute -S -enable-mem-access-versioning=0 < %s | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; PredicatedScalarEvolution decides it needs to insert a bounds check
; not based on memory access.

define void @f(i32* noalias %a, i32* noalias %b, i32* noalias %c, i32* noalias %d, i32* noalias %e, i64 %N) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A5:%.*]] = bitcast i32* [[A:%.*]] to i8*
; CHECK-NEXT:    br label [[FOR_BODY_LVER_CHECK:%.*]]
; CHECK:       for.body.lver.check:
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[TMP0]] to i32
; CHECK-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 2, i32 [[TMP1]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ugt i64 [[TMP0]], 4294967295
; CHECK-NEXT:    [[TMP8:%.*]] = or i1 false, [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = or i1 [[TMP8]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[MUL2:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 8, i64 [[TMP0]])
; CHECK-NEXT:    [[MUL_RESULT3:%.*]] = extractvalue { i64, i1 } [[MUL2]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW4:%.*]] = extractvalue { i64, i1 } [[MUL2]], 1
; CHECK-NEXT:    [[TMP11:%.*]] = sub i64 0, [[MUL_RESULT3]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr i8, i8* [[A5]], i64 [[MUL_RESULT3]]
; CHECK-NEXT:    [[TMP15:%.*]] = icmp ult i8* [[TMP12]], [[A5]]
; CHECK-NEXT:    [[TMP17:%.*]] = or i1 [[TMP15]], [[MUL_OVERFLOW4]]
; CHECK-NEXT:    [[TMP18:%.*]] = or i1 [[TMP9]], [[TMP17]]
; CHECK-NEXT:    br i1 [[TMP18]], label [[FOR_BODY_PH_LVER_ORIG:%.*]], label [[FOR_BODY_PH_LDIST1:%.*]]
; CHECK:       for.body.ph.lver.orig:
; CHECK-NEXT:    br label [[FOR_BODY_LVER_ORIG:%.*]]
; CHECK:       for.body.lver.orig:
; CHECK-NEXT:    [[IND_LVER_ORIG:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[ADD_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; CHECK-NEXT:    [[IND1_LVER_ORIG:%.*]] = phi i32 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC1_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; CHECK-NEXT:    [[MUL_LVER_ORIG:%.*]] = mul i32 [[IND1_LVER_ORIG]], 2
; CHECK-NEXT:    [[MUL_EXT_LVER_ORIG:%.*]] = zext i32 [[MUL_LVER_ORIG]] to i64
; CHECK-NEXT:    [[ARRAYIDXA_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADA_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXA_LVER_ORIG]], align 4
; CHECK-NEXT:    [[ARRAYIDXB_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADB_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXB_LVER_ORIG]], align 4
; CHECK-NEXT:    [[MULA_LVER_ORIG:%.*]] = mul i32 [[LOADB_LVER_ORIG]], [[LOADA_LVER_ORIG]]
; CHECK-NEXT:    [[ADD_LVER_ORIG]] = add nuw nsw i64 [[IND_LVER_ORIG]], 1
; CHECK-NEXT:    [[INC1_LVER_ORIG]] = add i32 [[IND1_LVER_ORIG]], 1
; CHECK-NEXT:    [[ARRAYIDXA_PLUS_4_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[ADD_LVER_ORIG]]
; CHECK-NEXT:    store i32 [[MULA_LVER_ORIG]], i32* [[ARRAYIDXA_PLUS_4_LVER_ORIG]], align 4
; CHECK-NEXT:    [[ARRAYIDXD_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[D:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADD_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXD_LVER_ORIG]], align 4
; CHECK-NEXT:    [[ARRAYIDXE_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[E:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADE_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXE_LVER_ORIG]], align 4
; CHECK-NEXT:    [[MULC_LVER_ORIG:%.*]] = mul i32 [[LOADD_LVER_ORIG]], [[LOADE_LVER_ORIG]]
; CHECK-NEXT:    [[ARRAYIDXC_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    store i32 [[MULC_LVER_ORIG]], i32* [[ARRAYIDXC_LVER_ORIG]], align 4
; CHECK-NEXT:    [[EXITCOND_LVER_ORIG:%.*]] = icmp eq i64 [[ADD_LVER_ORIG]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_LVER_ORIG]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LVER_ORIG]]
; CHECK:       for.body.ph.ldist1:
; CHECK-NEXT:    br label [[FOR_BODY_LDIST1:%.*]]
; CHECK:       for.body.ldist1:
; CHECK-NEXT:    [[IND_LDIST1:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LDIST1]] ], [ [[ADD_LDIST1:%.*]], [[FOR_BODY_LDIST1]] ]
; CHECK-NEXT:    [[IND1_LDIST1:%.*]] = phi i32 [ 0, [[FOR_BODY_PH_LDIST1]] ], [ [[INC1_LDIST1:%.*]], [[FOR_BODY_LDIST1]] ]
; CHECK-NEXT:    [[MUL_LDIST1:%.*]] = mul i32 [[IND1_LDIST1]], 2
; CHECK-NEXT:    [[MUL_EXT_LDIST1:%.*]] = zext i32 [[MUL_LDIST1]] to i64
; CHECK-NEXT:    [[ARRAYIDXA_LDIST1:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[MUL_EXT_LDIST1]]
; CHECK-NEXT:    [[LOADA_LDIST1:%.*]] = load i32, i32* [[ARRAYIDXA_LDIST1]], align 4, !alias.scope !0
; CHECK-NEXT:    [[ARRAYIDXB_LDIST1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[MUL_EXT_LDIST1]]
; CHECK-NEXT:    [[LOADB_LDIST1:%.*]] = load i32, i32* [[ARRAYIDXB_LDIST1]], align 4
; CHECK-NEXT:    [[MULA_LDIST1:%.*]] = mul i32 [[LOADB_LDIST1]], [[LOADA_LDIST1]]
; CHECK-NEXT:    [[ADD_LDIST1]] = add nuw nsw i64 [[IND_LDIST1]], 1
; CHECK-NEXT:    [[INC1_LDIST1]] = add i32 [[IND1_LDIST1]], 1
; CHECK-NEXT:    [[ARRAYIDXA_PLUS_4_LDIST1:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[ADD_LDIST1]]
; CHECK-NEXT:    store i32 [[MULA_LDIST1]], i32* [[ARRAYIDXA_PLUS_4_LDIST1]], align 4, !alias.scope !3
; CHECK-NEXT:    [[EXITCOND_LDIST1:%.*]] = icmp eq i64 [[ADD_LDIST1]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_LDIST1]], label [[FOR_BODY_PH:%.*]], label [[FOR_BODY_LDIST1]]
; CHECK:       for.body.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[FOR_BODY_PH]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[IND1:%.*]] = phi i32 [ 0, [[FOR_BODY_PH]] ], [ [[INC1:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; CHECK-NEXT:    [[MUL_EXT:%.*]] = zext i32 [[MUL]] to i64
; CHECK-NEXT:    [[ADD]] = add nuw nsw i64 [[IND]], 1
; CHECK-NEXT:    [[INC1]] = add i32 [[IND1]], 1
; CHECK-NEXT:    [[ARRAYIDXD:%.*]] = getelementptr inbounds i32, i32* [[D]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADD:%.*]] = load i32, i32* [[ARRAYIDXD]], align 4
; CHECK-NEXT:    [[ARRAYIDXE:%.*]] = getelementptr inbounds i32, i32* [[E]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADE:%.*]] = load i32, i32* [[ARRAYIDXE]], align 4
; CHECK-NEXT:    [[MULC:%.*]] = mul i32 [[LOADD]], [[LOADE]]
; CHECK-NEXT:    [[ARRAYIDXC:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[MUL_EXT]]
; CHECK-NEXT:    store i32 [[MULC]], i32* [[ARRAYIDXC]], align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[ADD]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT6:%.*]], label [[FOR_BODY]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END:%.*]]
; CHECK:       for.end.loopexit6:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %ind1 = phi i32 [ 0, %entry ], [ %inc1, %for.body ]

  %mul = mul i32 %ind1, 2
  %mul_ext = zext i32 %mul to i64


  %arrayidxA = getelementptr inbounds i32, i32* %a, i64 %mul_ext
  %loadA = load i32, i32* %arrayidxA, align 4

  %arrayidxB = getelementptr inbounds i32, i32* %b, i64 %mul_ext
  %loadB = load i32, i32* %arrayidxB, align 4

  %mulA = mul i32 %loadB, %loadA

  %add = add nuw nsw i64 %ind, 1
  %inc1 = add i32 %ind1, 1

  %arrayidxA_plus_4 = getelementptr inbounds i32, i32* %a, i64 %add
  store i32 %mulA, i32* %arrayidxA_plus_4, align 4

  %arrayidxD = getelementptr inbounds i32, i32* %d, i64 %mul_ext
  %loadD = load i32, i32* %arrayidxD, align 4

  %arrayidxE = getelementptr inbounds i32, i32* %e, i64 %mul_ext
  %loadE = load i32, i32* %arrayidxE, align 4

  %mulC = mul i32 %loadD, %loadE

  %arrayidxC = getelementptr inbounds i32, i32* %c, i64 %mul_ext
  store i32 %mulC, i32* %arrayidxC, align 4

  %exitcond = icmp eq i64 %add, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare void @use64(i64)
@global_a = common local_unnamed_addr global [8192 x i32] zeroinitializer, align 16

define void @f_with_offset(i32* noalias %b, i32* noalias %c, i32* noalias %d, i32* noalias %e, i64 %N) {
; CHECK-LABEL: @f_with_offset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_BASE:%.*]] = getelementptr [8192 x i32], [8192 x i32]* @global_a, i32 0, i32 0
; CHECK-NEXT:    [[A_INTPTR:%.*]] = ptrtoint i32* [[A_BASE]] to i64
; CHECK-NEXT:    call void @use64(i64 [[A_INTPTR]])
; CHECK-NEXT:    [[A:%.*]] = getelementptr i32, i32* [[A_BASE]], i32 42
; CHECK-NEXT:    br label [[FOR_BODY_LVER_CHECK:%.*]]
; CHECK:       for.body.lver.check:
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[TMP0]] to i32
; CHECK-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 2, i32 [[TMP1]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ugt i64 [[TMP0]], 4294967295
; CHECK-NEXT:    [[TMP8:%.*]] = or i1 false, [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = or i1 [[TMP8]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[MUL2:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 8, i64 [[TMP0]])
; CHECK-NEXT:    [[MUL_RESULT3:%.*]] = extractvalue { i64, i1 } [[MUL2]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW4:%.*]] = extractvalue { i64, i1 } [[MUL2]], 1
; CHECK-NEXT:    [[TMP11:%.*]] = sub i64 0, [[MUL_RESULT3]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr i8, i8* bitcast (i32* getelementptr inbounds ([8192 x i32], [8192 x i32]* @global_a, i64 0, i64 42) to i8*), i64 [[MUL_RESULT3]]
; CHECK-NEXT:    [[TMP15:%.*]] = icmp ult i8* [[TMP12]], bitcast (i32* getelementptr inbounds ([8192 x i32], [8192 x i32]* @global_a, i64 0, i64 42) to i8*)
; CHECK-NEXT:    [[TMP17:%.*]] = or i1 [[TMP15]], [[MUL_OVERFLOW4]]
; CHECK-NEXT:    [[TMP18:%.*]] = or i1 [[TMP9]], [[TMP17]]
; CHECK-NEXT:    br i1 [[TMP18]], label [[FOR_BODY_PH_LVER_ORIG:%.*]], label [[FOR_BODY_PH_LDIST1:%.*]]
; CHECK:       for.body.ph.lver.orig:
; CHECK-NEXT:    br label [[FOR_BODY_LVER_ORIG:%.*]]
; CHECK:       for.body.lver.orig:
; CHECK-NEXT:    [[IND_LVER_ORIG:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[ADD_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; CHECK-NEXT:    [[IND1_LVER_ORIG:%.*]] = phi i32 [ 0, [[FOR_BODY_PH_LVER_ORIG]] ], [ [[INC1_LVER_ORIG:%.*]], [[FOR_BODY_LVER_ORIG]] ]
; CHECK-NEXT:    [[MUL_LVER_ORIG:%.*]] = mul i32 [[IND1_LVER_ORIG]], 2
; CHECK-NEXT:    [[MUL_EXT_LVER_ORIG:%.*]] = zext i32 [[MUL_LVER_ORIG]] to i64
; CHECK-NEXT:    [[ARRAYIDXA_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADA_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXA_LVER_ORIG]], align 4
; CHECK-NEXT:    [[ARRAYIDXB_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADB_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXB_LVER_ORIG]], align 4
; CHECK-NEXT:    [[MULA_LVER_ORIG:%.*]] = mul i32 [[LOADB_LVER_ORIG]], [[LOADA_LVER_ORIG]]
; CHECK-NEXT:    [[ADD_LVER_ORIG]] = add nuw nsw i64 [[IND_LVER_ORIG]], 1
; CHECK-NEXT:    [[INC1_LVER_ORIG]] = add i32 [[IND1_LVER_ORIG]], 1
; CHECK-NEXT:    [[ARRAYIDXA_PLUS_4_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[ADD_LVER_ORIG]]
; CHECK-NEXT:    store i32 [[MULA_LVER_ORIG]], i32* [[ARRAYIDXA_PLUS_4_LVER_ORIG]], align 4
; CHECK-NEXT:    [[ARRAYIDXD_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[D:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADD_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXD_LVER_ORIG]], align 4
; CHECK-NEXT:    [[ARRAYIDXE_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[E:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    [[LOADE_LVER_ORIG:%.*]] = load i32, i32* [[ARRAYIDXE_LVER_ORIG]], align 4
; CHECK-NEXT:    [[MULC_LVER_ORIG:%.*]] = mul i32 [[LOADD_LVER_ORIG]], [[LOADE_LVER_ORIG]]
; CHECK-NEXT:    [[ARRAYIDXC_LVER_ORIG:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 [[MUL_EXT_LVER_ORIG]]
; CHECK-NEXT:    store i32 [[MULC_LVER_ORIG]], i32* [[ARRAYIDXC_LVER_ORIG]], align 4
; CHECK-NEXT:    [[EXITCOND_LVER_ORIG:%.*]] = icmp eq i64 [[ADD_LVER_ORIG]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_LVER_ORIG]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LVER_ORIG]]
; CHECK:       for.body.ph.ldist1:
; CHECK-NEXT:    br label [[FOR_BODY_LDIST1:%.*]]
; CHECK:       for.body.ldist1:
; CHECK-NEXT:    [[IND_LDIST1:%.*]] = phi i64 [ 0, [[FOR_BODY_PH_LDIST1]] ], [ [[ADD_LDIST1:%.*]], [[FOR_BODY_LDIST1]] ]
; CHECK-NEXT:    [[IND1_LDIST1:%.*]] = phi i32 [ 0, [[FOR_BODY_PH_LDIST1]] ], [ [[INC1_LDIST1:%.*]], [[FOR_BODY_LDIST1]] ]
; CHECK-NEXT:    [[MUL_LDIST1:%.*]] = mul i32 [[IND1_LDIST1]], 2
; CHECK-NEXT:    [[MUL_EXT_LDIST1:%.*]] = zext i32 [[MUL_LDIST1]] to i64
; CHECK-NEXT:    [[ARRAYIDXA_LDIST1:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[MUL_EXT_LDIST1]]
; CHECK-NEXT:    [[LOADA_LDIST1:%.*]] = load i32, i32* [[ARRAYIDXA_LDIST1]], align 4, !alias.scope !5
; CHECK-NEXT:    [[ARRAYIDXB_LDIST1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[MUL_EXT_LDIST1]]
; CHECK-NEXT:    [[LOADB_LDIST1:%.*]] = load i32, i32* [[ARRAYIDXB_LDIST1]], align 4
; CHECK-NEXT:    [[MULA_LDIST1:%.*]] = mul i32 [[LOADB_LDIST1]], [[LOADA_LDIST1]]
; CHECK-NEXT:    [[ADD_LDIST1]] = add nuw nsw i64 [[IND_LDIST1]], 1
; CHECK-NEXT:    [[INC1_LDIST1]] = add i32 [[IND1_LDIST1]], 1
; CHECK-NEXT:    [[ARRAYIDXA_PLUS_4_LDIST1:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[ADD_LDIST1]]
; CHECK-NEXT:    store i32 [[MULA_LDIST1]], i32* [[ARRAYIDXA_PLUS_4_LDIST1]], align 4, !alias.scope !8
; CHECK-NEXT:    [[EXITCOND_LDIST1:%.*]] = icmp eq i64 [[ADD_LDIST1]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_LDIST1]], label [[FOR_BODY_PH:%.*]], label [[FOR_BODY_LDIST1]]
; CHECK:       for.body.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[FOR_BODY_PH]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[IND1:%.*]] = phi i32 [ 0, [[FOR_BODY_PH]] ], [ [[INC1:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; CHECK-NEXT:    [[MUL_EXT:%.*]] = zext i32 [[MUL]] to i64
; CHECK-NEXT:    [[ADD]] = add nuw nsw i64 [[IND]], 1
; CHECK-NEXT:    [[INC1]] = add i32 [[IND1]], 1
; CHECK-NEXT:    [[ARRAYIDXD:%.*]] = getelementptr inbounds i32, i32* [[D]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADD:%.*]] = load i32, i32* [[ARRAYIDXD]], align 4
; CHECK-NEXT:    [[ARRAYIDXE:%.*]] = getelementptr inbounds i32, i32* [[E]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADE:%.*]] = load i32, i32* [[ARRAYIDXE]], align 4
; CHECK-NEXT:    [[MULC:%.*]] = mul i32 [[LOADD]], [[LOADE]]
; CHECK-NEXT:    [[ARRAYIDXC:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[MUL_EXT]]
; CHECK-NEXT:    store i32 [[MULC]], i32* [[ARRAYIDXC]], align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[ADD]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END_LOOPEXIT5:%.*]], label [[FOR_BODY]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END:%.*]]
; CHECK:       for.end.loopexit5:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %a_base = getelementptr [8192 x i32], [8192 x i32]* @global_a, i32 0, i32 0
  %a_intptr = ptrtoint i32* %a_base to i64
  call void @use64(i64 %a_intptr)
  %a = getelementptr i32, i32* %a_base, i32 42
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %ind1 = phi i32 [ 0, %entry ], [ %inc1, %for.body ]

  %mul = mul i32 %ind1, 2
  %mul_ext = zext i32 %mul to i64


  %arrayidxA = getelementptr inbounds i32, i32* %a, i64 %mul_ext
  %loadA = load i32, i32* %arrayidxA, align 4

  %arrayidxB = getelementptr inbounds i32, i32* %b, i64 %mul_ext
  %loadB = load i32, i32* %arrayidxB, align 4

  %mulA = mul i32 %loadB, %loadA

  %add = add nuw nsw i64 %ind, 1
  %inc1 = add i32 %ind1, 1

  %arrayidxA_plus_4 = getelementptr inbounds i32, i32* %a, i64 %add
  store i32 %mulA, i32* %arrayidxA_plus_4, align 4

  %arrayidxD = getelementptr inbounds i32, i32* %d, i64 %mul_ext
  %loadD = load i32, i32* %arrayidxD, align 4

  %arrayidxE = getelementptr inbounds i32, i32* %e, i64 %mul_ext
  %loadE = load i32, i32* %arrayidxE, align 4

  %mulC = mul i32 %loadD, %loadE

  %arrayidxC = getelementptr inbounds i32, i32* %c, i64 %mul_ext
  store i32 %mulC, i32* %arrayidxC, align 4

  %exitcond = icmp eq i64 %add, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

; Can't add control dependency with convergent in loop body.
define void @f_with_convergent(i32* noalias %a, i32* noalias %b, i32* noalias %c, i32* noalias %d, i32* noalias %e, i64 %N) #1 {
; CHECK-LABEL: @f_with_convergent(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[IND1:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[INC1:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[IND1]], 2
; CHECK-NEXT:    [[MUL_EXT:%.*]] = zext i32 [[MUL]] to i64
; CHECK-NEXT:    [[ARRAYIDXA:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADA:%.*]] = load i32, i32* [[ARRAYIDXA]], align 4
; CHECK-NEXT:    [[ARRAYIDXB:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADB:%.*]] = load i32, i32* [[ARRAYIDXB]], align 4
; CHECK-NEXT:    [[MULA:%.*]] = mul i32 [[LOADB]], [[LOADA]]
; CHECK-NEXT:    [[ADD]] = add nuw nsw i64 [[IND]], 1
; CHECK-NEXT:    [[INC1]] = add i32 [[IND1]], 1
; CHECK-NEXT:    [[ARRAYIDXA_PLUS_4:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[ADD]]
; CHECK-NEXT:    store i32 [[MULA]], i32* [[ARRAYIDXA_PLUS_4]], align 4
; CHECK-NEXT:    [[ARRAYIDXD:%.*]] = getelementptr inbounds i32, i32* [[D:%.*]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADD:%.*]] = load i32, i32* [[ARRAYIDXD]], align 4
; CHECK-NEXT:    [[ARRAYIDXE:%.*]] = getelementptr inbounds i32, i32* [[E:%.*]], i64 [[MUL_EXT]]
; CHECK-NEXT:    [[LOADE:%.*]] = load i32, i32* [[ARRAYIDXE]], align 4
; CHECK-NEXT:    [[CONVERGENTD:%.*]] = call i32 @llvm.convergent(i32 [[LOADD]])
; CHECK-NEXT:    [[MULC:%.*]] = mul i32 [[CONVERGENTD]], [[LOADE]]
; CHECK-NEXT:    [[ARRAYIDXC:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 [[MUL_EXT]]
; CHECK-NEXT:    store i32 [[MULC]], i32* [[ARRAYIDXC]], align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[ADD]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %ind1 = phi i32 [ 0, %entry ], [ %inc1, %for.body ]

  %mul = mul i32 %ind1, 2
  %mul_ext = zext i32 %mul to i64


  %arrayidxA = getelementptr inbounds i32, i32* %a, i64 %mul_ext
  %loadA = load i32, i32* %arrayidxA, align 4

  %arrayidxB = getelementptr inbounds i32, i32* %b, i64 %mul_ext
  %loadB = load i32, i32* %arrayidxB, align 4

  %mulA = mul i32 %loadB, %loadA

  %add = add nuw nsw i64 %ind, 1
  %inc1 = add i32 %ind1, 1

  %arrayidxA_plus_4 = getelementptr inbounds i32, i32* %a, i64 %add
  store i32 %mulA, i32* %arrayidxA_plus_4, align 4

  %arrayidxD = getelementptr inbounds i32, i32* %d, i64 %mul_ext
  %loadD = load i32, i32* %arrayidxD, align 4

  %arrayidxE = getelementptr inbounds i32, i32* %e, i64 %mul_ext
  %loadE = load i32, i32* %arrayidxE, align 4

  %convergentD = call i32 @llvm.convergent(i32 %loadD)
  %mulC = mul i32 %convergentD, %loadE

  %arrayidxC = getelementptr inbounds i32, i32* %c, i64 %mul_ext
  store i32 %mulC, i32* %arrayidxC, align 4

  %exitcond = icmp eq i64 %add, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare i32 @llvm.convergent(i32) #0

attributes #0 = { nounwind readnone convergent }
attributes #1 = { nounwind convergent }
