; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -loop-vectorize -mtriple=powerpc64-unknown-linux-gnu | FileCheck %s

define void @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UMIN:%.*]] = call i64 @llvm.umin.i64(i64 undef, i64 undef)
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[UMIN]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 undef, [[TMP0]]
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP1]], 2
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP1]], 2
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP1]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = sub i32 0, [[N_VEC]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = sub i32 0, [[INDEX]]
; CHECK-NEXT:    [[INDUCTION:%.*]] = add i32 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[INDUCTION1:%.*]] = add i32 [[OFFSET_IDX]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw i32 -1, [[INDUCTION]]
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw i32 -1, [[INDUCTION1]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* undef, i32 [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* undef, i32 [[TMP3]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP1]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[COUNT_09:%.*]] = phi i32 [ [[ADD:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ADD]] = add nsw i32 -1, [[COUNT_09]]
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, i8* undef, i32 [[ADD]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8* undef, [[G]]
; CHECK-NEXT:    br i1 [[CMP]], label [[WHILE_BODY]], label [[WHILE_END_LOOPEXIT]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       while.end.loopexit:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.body

while.body:                                       ; preds = %while.body, %entry
  %count.09 = phi i32 [ %add, %while.body ], [ 0, %entry ]
  %add = add nsw i32 -1, %count.09
  %G = getelementptr i8, i8* undef, i32 %add
  %cmp = icmp ult i8* undef, %G
  br i1 %cmp, label %while.body, label %while.end.loopexit

while.end.loopexit:                               ; preds = %while.body
  ret void
}
