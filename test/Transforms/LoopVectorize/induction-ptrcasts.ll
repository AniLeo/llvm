; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -force-vector-width=1 -force-vector-interleave=2 -S %s | FileCheck --check-prefix=VF1 %s
; RUN: opt -passes=loop-vectorize -force-vector-width=2 -force-vector-interleave=1 -S %s | FileCheck --check-prefix=VF2 %s

@f = external dso_local global i32, align 4

define void @int_iv_based_on_pointer_iv(i8* %A) {
; VF1-LABEL: @int_iv_based_on_pointer_iv(
; VF1:       vector.body:
; VF1-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %vector.ph ], [ [[INDEX_NEXT:%.*]], %vector.body ]
; VF1-NEXT:    [[OFFSET_IDX:%.*]] = mul i64 [[INDEX]], 4
; VF1-NEXT:    [[INDUCTION:%.*]] = add i64 [[OFFSET_IDX]], 0
; VF1-NEXT:    [[INDUCTION3:%.*]] = add i64 [[OFFSET_IDX]], 4
; VF1-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i8, i8* [[A:%.*]], i64 [[INDUCTION]]
; VF1-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 [[INDUCTION3]]
; VF1-NEXT:    store i8 0, i8* [[TMP7]], align 1
; VF1-NEXT:    store i8 0, i8* [[TMP8]], align 1
; VF1-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; VF1-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[INDEX_NEXT]],
; VF1-NEXT:    br i1 [[TMP13]], label %middle.block, label %vector.body
;
; VF2-LABEL: @int_iv_based_on_pointer_iv(
; VF2:       vector.body:
; VF2-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %vector.ph ], [ [[INDEX_NEXT:%.*]], %vector.body ]
; VF2-NEXT:    [[OFFSET_IDX:%.*]] = mul i64 [[INDEX]], 4
; VF2-NEXT:    [[TMP3:%.*]] = add i64 [[OFFSET_IDX]], 0
; VF2-NEXT:    [[TMP4:%.*]] = add i64 [[OFFSET_IDX]], 4
; VF2-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i8, i8* [[A:%.*]], i64 [[TMP3]]
; VF2-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 [[TMP4]]
; VF2-NEXT:    store i8 0, i8* [[TMP9]], align 1
; VF2-NEXT:    store i8 0, i8* [[TMP10]], align 1
; VF2-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; VF2-NEXT:    [[TMP14:%.*]] = icmp eq i64 [[INDEX_NEXT]],
; VF2-NEXT:    br i1 [[TMP14]], label %middle.block, label %vector.body
;
entry:
  br label %loop

loop:
  %iv.int = phi i64 [ 0, %entry ], [ %iv.int.next, %loop ]
  %iv.ptr = phi i32* [ null, %entry ], [ %iv.ptr.next, %loop ]
  %iv.ptr.next = getelementptr inbounds i32, i32* %iv.ptr, i64 1
  %gep.A = getelementptr inbounds i8, i8* %A, i64 %iv.int
  store i8 0, i8* %gep.A
  %iv.int.next = ptrtoint i32* %iv.ptr.next to i64
  %sub.ptr.sub = sub i64 ptrtoint (i32* @f to i64), %iv.int.next
  %cmp = icmp sgt i64 %sub.ptr.sub, 0
  br i1 %cmp, label %loop, label %exit

exit:
  ret void
}
