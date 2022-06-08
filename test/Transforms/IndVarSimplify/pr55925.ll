; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars < %s | FileCheck %s

; This tests the case where a terminator can be modeled by SCEV,
; because it has a returned attribute.

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

declare i32 @foo(i32)

define void @test(i8* %p) personality i8* undef {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH]] ]
; CHECK-NEXT:    [[RES:%.*]] = invoke i32 @foo(i32 returned [[IV]])
; CHECK-NEXT:    to label [[LOOP_LATCH]] unwind label [[EXIT:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i32 [[IV]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @foo(i32 [[TMP0]])
; CHECK-NEXT:    br label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[LP:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %res = invoke i32 @foo(i32 returned %iv)
  to label %loop.latch unwind label %exit

loop.latch:
  %ext = zext i32 %iv to i64
  %tmp5 = getelementptr inbounds i8, i8* %p, i64 %ext
  %iv.next = add nuw i32 %iv, 1
  call i32 @foo(i32 %res)
  br label %loop

exit:
  %lp = landingpad { i8*, i32 }
  cleanup
  ret void
}

define void @test_critedge(i1 %c, i8* %p) personality i8* undef {
; CHECK-LABEL: @test_critedge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH]] ]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LOOP_INVOKE:%.*]], label [[LOOP_OTHER:%.*]]
; CHECK:       loop.invoke:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[RES:%.*]] = invoke i32 @foo(i32 returned [[IV]])
; CHECK-NEXT:    to label [[LOOP_LATCH]] unwind label [[EXIT:%.*]]
; CHECK:       loop.other:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[TMP0]], [[LOOP_INVOKE]] ], [ 0, [[LOOP_OTHER]] ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i32 [[IV]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @foo(i32 [[PHI]])
; CHECK-NEXT:    br label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[LP:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop.latch ]
  br i1 %c, label %loop.invoke, label %loop.other

loop.invoke:
  %res = invoke i32 @foo(i32 returned %iv)
  to label %loop.latch unwind label %exit

loop.other:
  br label %loop.latch

loop.latch:
  %phi = phi i32 [ %res, %loop.invoke ], [ 0, %loop.other ]
  %ext = zext i32 %iv to i64
  %tmp5 = getelementptr inbounds i8, i8* %p, i64 %ext
  %iv.next = add nuw i32 %iv, 1
  call i32 @foo(i32 %phi)
  br label %loop

exit:
  %lp = landingpad { i8*, i32 }
  cleanup
  ret void
}
