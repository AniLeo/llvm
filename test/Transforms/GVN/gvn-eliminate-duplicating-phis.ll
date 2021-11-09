; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -gvn -indvars -S %s | FileCheck %s

target triple = "aarch64--linux-gnu"

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @escape(i32* %ptr)

declare void @foo(i64 %v) readonly

define void @non_local_load(i32* %ptr) {
; CHECK-LABEL: @non_local_load(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[PTR:%.*]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ [[VAL_INC:%.*]], [[LOOP]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[VAL_INC]] = add nuw nsw i32 [[VAL]], 1
; CHECK-NEXT:    store i32 [[VAL_INC]], i32* [[PTR]], align 4
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp eq i32 [[VAL]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %ptr
  br label %loop

loop:
  %iv = phi i32 [ %iv.next, %loop ], [ 0, %entry ]
  %val = load i32, i32* %ptr
  %val.inc = add i32 %val, 1
  store i32 %val.inc, i32* %ptr
  %iv.next = add i32 %iv, 1
  %loop.cond = icmp eq i32 %iv, 1000
  br i1 %loop.cond, label %exit, label %loop

exit:
  ret void
}

define void @non_local_load_with_iv_zext(i32* %ptr) {
; CHECK-LABEL: @non_local_load_with_iv_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[PTR:%.*]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[LOOP]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ [[VAL_INC:%.*]], [[LOOP]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    [[VAL_INC]] = add nuw nsw i32 [[VAL]], 1
; CHECK-NEXT:    store i32 [[VAL_INC]], i32* [[PTR]], align 4
; CHECK-NEXT:    call void @foo(i64 [[INDVARS_IV]])
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp eq i64 [[INDVARS_IV]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %ptr
  br label %loop

loop:
  %iv = phi i32 [ %iv.next, %loop ], [ 0, %entry ]
  %val = load i32, i32* %ptr
  %val.inc = add i32 %val, 1
  store i32 %val.inc, i32* %ptr
  %iv.wide = zext i32 %iv to i64
  call void @foo(i64 %iv.wide)
  %iv.next = add i32 %iv, 1
  %loop.cond = icmp eq i32 %iv, 1000
  br i1 %loop.cond, label %exit, label %loop

exit:
  ret void
}

define void @two_non_local_loads(i32* %ptr1) {
; CHECK-LABEL: @two_non_local_loads(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i32, i32* [[PTR1:%.*]], i64 1
; CHECK-NEXT:    store i32 0, i32* [[PTR1]], align 4
; CHECK-NEXT:    store i32 0, i32* [[PTR2]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[LOOP]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[VAL2:%.*]] = phi i32 [ [[VAL2_INC:%.*]], [[LOOP]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    [[VAL2_INC]] = add nuw nsw i32 [[VAL2]], 1
; CHECK-NEXT:    store i32 [[VAL2_INC]], i32* [[PTR1]], align 4
; CHECK-NEXT:    store i32 [[VAL2_INC]], i32* [[PTR2]], align 4
; CHECK-NEXT:    call void @foo(i64 [[INDVARS_IV]])
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp eq i64 [[INDVARS_IV]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %ptr2 = getelementptr inbounds i32, i32* %ptr1, i64 1
  store i32 0, i32* %ptr1
  store i32 0, i32* %ptr2
  br label %loop

loop:
  %iv = phi i32 [ %iv.next, %loop ], [ 0, %entry ]
  %val1 = load i32, i32* %ptr1
  %val1.inc = add i32 %val1, 1
  store i32 %val1.inc, i32* %ptr1
  %val2 = load i32, i32* %ptr2
  %val2.inc = add i32 %val2, 1
  store i32 %val2.inc, i32* %ptr2
  %iv.wide = zext i32 %iv to i64
  call void @foo(i64 %iv.wide)
  %iv.next = add i32 %iv, 1
  %loop.cond = icmp eq i32 %iv, 1000
  br i1 %loop.cond, label %exit, label %loop

exit:
  ret void
}
