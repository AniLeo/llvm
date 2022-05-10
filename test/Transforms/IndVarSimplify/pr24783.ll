; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars < %s | FileCheck %s

target datalayout = "E-m:e-i64:64-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

define void @f(i32* %end.s, i8** %loc, i32 %p) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[END:%.*]] = getelementptr inbounds i32, i32* [[END_S:%.*]], i32 [[P:%.*]]
; CHECK-NEXT:    br label [[WHILE_BODY_I:%.*]]
; CHECK:       while.body.i:
; CHECK-NEXT:    br i1 true, label [[LOOP_EXIT:%.*]], label [[WHILE_BODY_I]]
; CHECK:       loop.exit:
; CHECK-NEXT:    [[END1:%.*]] = bitcast i32* [[END]] to i8*
; CHECK-NEXT:    store i8* [[END1]], i8** [[LOC:%.*]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %end = getelementptr inbounds i32, i32* %end.s, i32 %p
  %init = bitcast i32* %end.s to i8*
  br label %while.body.i

while.body.i:
  %ptr = phi i8* [ %ptr.inc, %while.body.i ], [ %init, %entry ]
  %ptr.inc = getelementptr inbounds i8, i8* %ptr, i8 1
  %ptr.inc.cast = bitcast i8* %ptr.inc to i32*
  %cmp.i = icmp eq i32* %ptr.inc.cast, %end
  br i1 %cmp.i, label %loop.exit, label %while.body.i

loop.exit:
  %ptr.inc.lcssa = phi i8* [ %ptr.inc, %while.body.i ]
  store i8* %ptr.inc.lcssa, i8** %loc
  ret void
}
