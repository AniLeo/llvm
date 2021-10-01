; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=x86_64-pc_linux -loop-vectorize -instcombine < %s | FileCheck %s --check-prefix=SSE
; RUN: opt -S -mtriple=x86_64-pc_linux -loop-vectorize -instcombine -mcpu=sandybridge < %s | FileCheck %s --check-prefix=AVX1
; RUN: opt -S -mtriple=x86_64-pc_linux -loop-vectorize -instcombine -mcpu=haswell < %s | FileCheck %s --check-prefix=AVX2
; RUN: opt -S -mtriple=x86_64-pc_linux -loop-vectorize -instcombine -mcpu=slm < %s | FileCheck %s --check-prefix=SSE
; RUN: opt -S -mtriple=x86_64-pc_linux -loop-vectorize -instcombine -mcpu=atom < %s | FileCheck %s --check-prefix=SSE

define void @foo(i32* noalias nocapture %a, i32* noalias nocapture readonly %b) {
; SSE-LABEL: @foo(
; SSE-NEXT:  entry:
; SSE-NEXT:    br label [[FOR_BODY:%.*]]
; SSE:       for.cond.cleanup:
; SSE-NEXT:    ret void
; SSE:       for.body:
; SSE-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; SSE-NEXT:    [[TMP0:%.*]] = shl nuw nsw i64 [[INDVARS_IV]], 1
; SSE-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[TMP0]]
; SSE-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; SSE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP0]], 1
; SSE-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[TMP2]]
; SSE-NEXT:    [[TMP3:%.*]] = load i32, i32* [[ARRAYIDX3]], align 4
; SSE-NEXT:    [[ADD4:%.*]] = add nsw i32 [[TMP3]], [[TMP1]]
; SSE-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; SSE-NEXT:    store i32 [[ADD4]], i32* [[ARRAYIDX6]], align 4
; SSE-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; SSE-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 1024
; SSE-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
;
; AVX1-LABEL: @foo(
; AVX1-NEXT:  entry:
; AVX1-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; AVX1:       vector.ph:
; AVX1-NEXT:    br label [[VECTOR_BODY:%.*]]
; AVX1:       vector.body:
; AVX1-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; AVX1-NEXT:    [[TMP0:%.*]] = shl nsw i64 [[INDEX]], 1
; AVX1-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[TMP0]]
; AVX1-NEXT:    [[TMP2:%.*]] = bitcast i32* [[TMP1]] to <8 x i32>*
; AVX1-NEXT:    [[WIDE_VEC:%.*]] = load <8 x i32>, <8 x i32>* [[TMP2]], align 4
; AVX1-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <8 x i32> [[WIDE_VEC]], <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; AVX1-NEXT:    [[STRIDED_VEC1:%.*]] = shufflevector <8 x i32> [[WIDE_VEC]], <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; AVX1-NEXT:    [[TMP3:%.*]] = add nsw <4 x i32> [[STRIDED_VEC1]], [[STRIDED_VEC]]
; AVX1-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDEX]]
; AVX1-NEXT:    [[TMP5:%.*]] = bitcast i32* [[TMP4]] to <4 x i32>*
; AVX1-NEXT:    store <4 x i32> [[TMP3]], <4 x i32>* [[TMP5]], align 4
; AVX1-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; AVX1-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; AVX1-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; AVX1:       middle.block:
; AVX1-NEXT:    br i1 true, label [[FOR_COND_CLEANUP:%.*]], label [[SCALAR_PH]]
; AVX1:       scalar.ph:
; AVX1-NEXT:    br label [[FOR_BODY:%.*]]
; AVX1:       for.cond.cleanup:
; AVX1-NEXT:    ret void
; AVX1:       for.body:
; AVX1-NEXT:    br i1 undef, label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
;
; AVX2-LABEL: @foo(
; AVX2-NEXT:  entry:
; AVX2-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; AVX2:       vector.ph:
; AVX2-NEXT:    br label [[VECTOR_BODY:%.*]]
; AVX2:       vector.body:
; AVX2-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; AVX2-NEXT:    [[TMP0:%.*]] = shl nsw i64 [[INDEX]], 1
; AVX2-NEXT:    [[TMP1:%.*]] = shl i64 [[INDEX]], 1
; AVX2-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 8
; AVX2-NEXT:    [[TMP3:%.*]] = shl i64 [[INDEX]], 1
; AVX2-NEXT:    [[TMP4:%.*]] = or i64 [[TMP3]], 16
; AVX2-NEXT:    [[TMP5:%.*]] = shl i64 [[INDEX]], 1
; AVX2-NEXT:    [[TMP6:%.*]] = or i64 [[TMP5]], 24
; AVX2-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 [[TMP0]]
; AVX2-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[TMP2]]
; AVX2-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[TMP4]]
; AVX2-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[TMP6]]
; AVX2-NEXT:    [[TMP11:%.*]] = bitcast i32* [[TMP7]] to <8 x i32>*
; AVX2-NEXT:    [[TMP12:%.*]] = bitcast i32* [[TMP8]] to <8 x i32>*
; AVX2-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP9]] to <8 x i32>*
; AVX2-NEXT:    [[TMP14:%.*]] = bitcast i32* [[TMP10]] to <8 x i32>*
; AVX2-NEXT:    [[WIDE_VEC:%.*]] = load <8 x i32>, <8 x i32>* [[TMP11]], align 4
; AVX2-NEXT:    [[WIDE_VEC1:%.*]] = load <8 x i32>, <8 x i32>* [[TMP12]], align 4
; AVX2-NEXT:    [[WIDE_VEC2:%.*]] = load <8 x i32>, <8 x i32>* [[TMP13]], align 4
; AVX2-NEXT:    [[WIDE_VEC3:%.*]] = load <8 x i32>, <8 x i32>* [[TMP14]], align 4
; AVX2-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <8 x i32> [[WIDE_VEC]], <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; AVX2-NEXT:    [[STRIDED_VEC4:%.*]] = shufflevector <8 x i32> [[WIDE_VEC1]], <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; AVX2-NEXT:    [[STRIDED_VEC5:%.*]] = shufflevector <8 x i32> [[WIDE_VEC2]], <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; AVX2-NEXT:    [[STRIDED_VEC6:%.*]] = shufflevector <8 x i32> [[WIDE_VEC3]], <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; AVX2-NEXT:    [[STRIDED_VEC7:%.*]] = shufflevector <8 x i32> [[WIDE_VEC]], <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; AVX2-NEXT:    [[STRIDED_VEC8:%.*]] = shufflevector <8 x i32> [[WIDE_VEC1]], <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; AVX2-NEXT:    [[STRIDED_VEC9:%.*]] = shufflevector <8 x i32> [[WIDE_VEC2]], <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; AVX2-NEXT:    [[STRIDED_VEC10:%.*]] = shufflevector <8 x i32> [[WIDE_VEC3]], <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; AVX2-NEXT:    [[TMP15:%.*]] = add nsw <4 x i32> [[STRIDED_VEC7]], [[STRIDED_VEC]]
; AVX2-NEXT:    [[TMP16:%.*]] = add nsw <4 x i32> [[STRIDED_VEC8]], [[STRIDED_VEC4]]
; AVX2-NEXT:    [[TMP17:%.*]] = add nsw <4 x i32> [[STRIDED_VEC9]], [[STRIDED_VEC5]]
; AVX2-NEXT:    [[TMP18:%.*]] = add nsw <4 x i32> [[STRIDED_VEC10]], [[STRIDED_VEC6]]
; AVX2-NEXT:    [[TMP19:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDEX]]
; AVX2-NEXT:    [[TMP20:%.*]] = bitcast i32* [[TMP19]] to <4 x i32>*
; AVX2-NEXT:    store <4 x i32> [[TMP15]], <4 x i32>* [[TMP20]], align 4
; AVX2-NEXT:    [[TMP21:%.*]] = getelementptr inbounds i32, i32* [[TMP19]], i64 4
; AVX2-NEXT:    [[TMP22:%.*]] = bitcast i32* [[TMP21]] to <4 x i32>*
; AVX2-NEXT:    store <4 x i32> [[TMP16]], <4 x i32>* [[TMP22]], align 4
; AVX2-NEXT:    [[TMP23:%.*]] = getelementptr inbounds i32, i32* [[TMP19]], i64 8
; AVX2-NEXT:    [[TMP24:%.*]] = bitcast i32* [[TMP23]] to <4 x i32>*
; AVX2-NEXT:    store <4 x i32> [[TMP17]], <4 x i32>* [[TMP24]], align 4
; AVX2-NEXT:    [[TMP25:%.*]] = getelementptr inbounds i32, i32* [[TMP19]], i64 12
; AVX2-NEXT:    [[TMP26:%.*]] = bitcast i32* [[TMP25]] to <4 x i32>*
; AVX2-NEXT:    store <4 x i32> [[TMP18]], <4 x i32>* [[TMP26]], align 4
; AVX2-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 16
; AVX2-NEXT:    [[TMP27:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; AVX2-NEXT:    br i1 [[TMP27]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; AVX2:       middle.block:
; AVX2-NEXT:    br i1 true, label [[FOR_COND_CLEANUP:%.*]], label [[SCALAR_PH]]
; AVX2:       scalar.ph:
; AVX2-NEXT:    br label [[FOR_BODY:%.*]]
; AVX2:       for.cond.cleanup:
; AVX2-NEXT:    ret void
; AVX2:       for.body:
; AVX2-NEXT:    br i1 undef, label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
;
entry:
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body
  ret void

for.body:                                         ; preds = %for.body, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %0 = shl nsw i64 %indvars.iv, 1
  %arrayidx = getelementptr inbounds i32, i32* %b, i64 %0
  %1 = load i32, i32* %arrayidx, align 4
  %2 = or i64 %0, 1
  %arrayidx3 = getelementptr inbounds i32, i32* %b, i64 %2
  %3 = load i32, i32* %arrayidx3, align 4
  %add4 = add nsw i32 %3, %1
  %arrayidx6 = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  store i32 %add4, i32* %arrayidx6, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 1024
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}
