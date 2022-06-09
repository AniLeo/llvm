; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -S -mtriple=riscv64 -loop-unroll | FileCheck %s

; Demonstrate handling of invalid costs in LoopUnroll.  This test uses
; scalable vectors on RISCV w/o +V to create a situation where a construct
; can not be lowered, and is thus invalid regardless of what the target
; does or does not implement in terms of a cost model.

target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64-unknown-unknown"

define void @invalid(<vscale x 1 x i8>* %p) nounwind ssp {
; CHECK-LABEL: @invalid(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[A:%.*]] = load <vscale x 1 x i8>, <vscale x 1 x i8>* [[P:%.*]], align 1
; CHECK-NEXT:    [[B:%.*]] = add <vscale x 1 x i8> [[A]], [[A]]
; CHECK-NEXT:    store <vscale x 1 x i8> [[B]], <vscale x 1 x i8>* [[P]], align 1
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_0]], 10
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %a = load <vscale x 1 x i8>, <vscale x 1 x i8>* %p
  %b = add <vscale x 1 x i8> %a, %a
  store <vscale x 1 x i8> %b, <vscale x 1 x i8>* %p
  %inc = add nsw i32 %i.0, 1
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}


declare void @f()
