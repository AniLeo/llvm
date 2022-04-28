; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -force-vector-width=2 -force-vector-interleave=1 -S %s | FileCheck %s


; Test case where %gep has multiple uses of %iv.
define void @multiple_iv_uses_in_same_instruction([100 x [100 x i32]]* %ptr) {
; CHECK-LABEL: @multiple_iv_uses_in_same_instruction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i32> [ <i32 0, i32 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* [[PTR:%.*]], i64 0, i64 [[TMP0]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* [[PTR]], i64 0, i64 [[TMP1]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x i32> [[VEC_IND]], i32 0
; CHECK-NEXT:    store i32 [[TMP4]], i32* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x i32> [[VEC_IND]], i32 1
; CHECK-NEXT:    store i32 [[TMP5]], i32* [[TMP3]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i32> [[VEC_IND]], <i32 2, i32 2>
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 100, 100
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 100, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* [[PTR]], i64 0, i64 [[IV]], i64 [[IV]]
; CHECK-NEXT:    [[T:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    store i32 [[T]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %ptr, i64 0, i64 %iv, i64 %iv
  %t = trunc i64 %iv to i32
  store i32 %t, i32* %gep, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 100
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}
