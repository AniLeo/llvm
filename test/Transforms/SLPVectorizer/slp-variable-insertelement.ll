; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -slp-max-vf=2 -slp-min-reg-size=32 -S < %s | FileCheck %s

; It is possible to compute the tree cost for an insertelement that does not
; have a constant index when the index is a PHI. Check if getInsertIndex
; returns None.

define void @test() local_unnamed_addr {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    unreachable
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ poison, [[FOR_BODY]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ poison, [[ENTRY]] ], [ 0, [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i32> poison, i32 poison, i32 [[I]]
; CHECK-NEXT:    br i1 poison, label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
;
entry:
  br label %for.body

for.cond.cleanup:
  unreachable

for.body:
  %i = phi i32 [ 0, %entry ], [ poison, %for.body ]
  %j = phi i32 [ poison, %entry ], [ 0, %for.body ]
  %0 = insertelement <4 x i32> poison, i32 poison, i32 %i
  br i1 poison, label %for.cond.cleanup, label %for.body
}
