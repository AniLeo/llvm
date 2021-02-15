; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars -loop-load-elim < %s 2>&1 | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:1-p2:32:8:8:32-ni:2"
target triple = "x86_64-unknown-linux-gnu"

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[A_01:%.*]] = phi i16 [ undef, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[INC]] = add nsw i16 [[A_01]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i16 [[INC]], 2
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 false, [[CMP]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.cond:                                         ; preds = %for.body
  %a.0 = phi i16 [ %inc, %for.body ]
  %cmp = icmp sle i16 %a.0, 2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond, %entry
  %a.01 = phi i16 [ undef, %entry ], [ %a.0, %for.cond ]
  %inc = add nsw i16 %a.01, 1
  br i1 false, label %for.cond, label %for.end

for.end:                                          ; preds = %for.body, %for.cond
  ret void
}
