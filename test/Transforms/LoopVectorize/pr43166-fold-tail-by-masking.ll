; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=loop-vectorize -force-vector-width=4 -S | FileCheck %s


; Test cases below are reduced (and slightly modified) reproducers based on a
; problem seen when compiling a C program like this:
;
;    #include <stdint.h>
;    #include <stdio.h>
;
;    int y = 0;
;    int b = 1;
;    int d = 1;
;
;    int main() {
;      #pragma clang loop vectorize_width(4)
;      for (int i = 0; i < 3; ++i) {
;        b = (y == 0) ? d : (d / y);
;      }
;
;      if (b == 1)
;        printf("GOOD!\n");
;      else
;        printf("BAD!\n");
;    }
;
; When compiled+executed using
;    build-all/bin/clang -O1 lv-bug.c && ./a.out
; the result is "GOOD!"
;
; When compiled+executed using
;    build-all/bin/clang -O1 lv-bug.c -fvectorize && ./a.out
; the result is "BAD!"


; This test case miscompiled with clang 8.0.0 (see PR43166), now we get
;   loop not vectorized: Cannot fold tail by masking in the presence of live outs.
; instead.
define i64 @test1(i64 %y) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[COND_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[Y:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_END]], label [[COND_FALSE:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    [[DIV:%.*]] = xor i64 3, [[Y]]
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i64 [ [[DIV]], [[COND_FALSE]] ], [ 77, [[FOR_BODY]] ]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], 3
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[COND_LCSSA:%.*]] = phi i64 [ [[COND]], [[COND_END]] ]
; CHECK-NEXT:    ret i64 [[COND_LCSSA]]
;
entry:
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %inc, %cond.end ]
  %cmp = icmp eq i64 %y, 0
  br i1 %cmp, label %cond.end, label %cond.false

cond.false:
  %div = xor i64 3, %y
  br label %cond.end

cond.end:
  %cond = phi i64 [ %div, %cond.false ], [ 77, %for.body ]
  %inc = add nuw nsw i32 %i, 1
  %exitcond = icmp eq i32 %inc, 3
  br i1 %exitcond, label %for.cond.cleanup, label %for.body

for.cond.cleanup:
  ret i64 %cond
}

; This test case miscompiled with clang 8.0.0 (see PR43166), now we get
;   loop not vectorized: Cannot fold tail by masking in the presence of live outs.
; instead.
define i64 @test2(i64 %y) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[COND_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[Y:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_END]], label [[COND_FALSE:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i64 [ 55, [[COND_FALSE]] ], [ 77, [[FOR_BODY]] ]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], 3
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[COND_LCSSA:%.*]] = phi i64 [ [[COND]], [[COND_END]] ]
; CHECK-NEXT:    ret i64 [[COND_LCSSA]]
;
entry:
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %inc, %cond.end ]
  %cmp = icmp eq i64 %y, 0
  br i1 %cmp, label %cond.end, label %cond.false

cond.false:
  br label %cond.end

cond.end:
  %cond = phi i64 [ 55, %cond.false ], [ 77, %for.body ]
  %inc = add nuw nsw i32 %i, 1
  %exitcond = icmp eq i32 %inc, 3
  br i1 %exitcond, label %for.cond.cleanup, label %for.body

for.cond.cleanup:
  ret i64 %cond
}

; This test case miscompiled with clang 8.0.0 (see PR43166), now we get
;   loop not vectorized: Cannot fold tail by masking in the presence of live outs.
; instead.
define i32 @test3(i64 %y) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[COND_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[Y:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_END]], label [[COND_FALSE:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ 55, [[COND_FALSE]] ], [ [[I]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], 3
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[COND_LCSSA:%.*]] = phi i32 [ [[COND]], [[COND_END]] ]
; CHECK-NEXT:    ret i32 [[COND_LCSSA]]
;
entry:
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %inc, %cond.end ]
  %cmp = icmp eq i64 %y, 0
  br i1 %cmp, label %cond.end, label %cond.false

cond.false:
  br label %cond.end

cond.end:
  %cond = phi i32 [ 55, %cond.false ], [ %i, %for.body ]
  %inc = add nuw nsw i32 %i, 1
  %exitcond = icmp eq i32 %inc, 3
  br i1 %exitcond, label %for.cond.cleanup, label %for.body

for.cond.cleanup:
  ret i32 %cond
}
