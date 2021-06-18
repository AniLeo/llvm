; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-deletion -S | FileCheck %s
; RUN: opt < %s -passes='loop(loop-deletion)' -S | FileCheck %s

; The idea is that we know that %is.positive is true on the 1st iteration,
; it means that we can evaluate %merge.phi = %sub on the 1st iteration,
; and therefore prove that %sum.next = %sum + %sub = %sum + %limit - %sum = %limit,
; and predicate is false.

; TODO: We can break the backedge here.
define i32 @test_ne(i32 %limit) {
; CHECK-LABEL: @test_ne(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOOP_GUARD:%.*]] = icmp sgt i32 [[LIMIT:%.*]], 0
; CHECK-NEXT:    br i1 [[LOOP_GUARD]], label [[LOOP_PREHEADER:%.*]], label [[FAILURE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LIMIT]], [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ne i32 [[SUM_NEXT]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %loop_guard = icmp sgt i32 %limit, 0
  br i1 %loop_guard, label %loop, label %failure

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 %limit, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ne i32 %sum.next, %limit
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_slt(i32 %limit) {
; CHECK-LABEL: @test_slt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOOP_GUARD:%.*]] = icmp sgt i32 [[LIMIT:%.*]], 0
; CHECK-NEXT:    br i1 [[LOOP_GUARD]], label [[LOOP_PREHEADER:%.*]], label [[FAILURE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LIMIT]], [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[SUM_NEXT]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %loop_guard = icmp sgt i32 %limit, 0
  br i1 %loop_guard, label %loop, label %failure

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 %limit, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp slt i32 %sum.next, %limit
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_ult(i32 %limit) {
; CHECK-LABEL: @test_ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOOP_GUARD:%.*]] = icmp sgt i32 [[LIMIT:%.*]], 0
; CHECK-NEXT:    br i1 [[LOOP_GUARD]], label [[LOOP_PREHEADER:%.*]], label [[FAILURE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LIMIT]], [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[SUM_NEXT]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %loop_guard = icmp sgt i32 %limit, 0
  br i1 %loop_guard, label %loop, label %failure

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 %limit, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ult i32 %sum.next, %limit
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_sgt(i32 %limit) {
; CHECK-LABEL: @test_sgt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOOP_GUARD:%.*]] = icmp sgt i32 [[LIMIT:%.*]], 0
; CHECK-NEXT:    br i1 [[LOOP_GUARD]], label [[LOOP_PREHEADER:%.*]], label [[FAILURE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LIMIT]], [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp sgt i32 [[SUM_NEXT]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %loop_guard = icmp sgt i32 %limit, 0
  br i1 %loop_guard, label %loop, label %failure

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 %limit, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp sgt i32 %sum.next, %limit
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_ugt(i32 %limit) {
; CHECK-LABEL: @test_ugt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOOP_GUARD:%.*]] = icmp sgt i32 [[LIMIT:%.*]], 0
; CHECK-NEXT:    br i1 [[LOOP_GUARD]], label [[LOOP_PREHEADER:%.*]], label [[FAILURE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LIMIT]], [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ugt i32 [[SUM_NEXT]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %loop_guard = icmp sgt i32 %limit, 0
  br i1 %loop_guard, label %loop, label %failure

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 %limit, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ugt i32 %sum.next, %limit
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_multiple_pred(i32 %limit) {
; CHECK-LABEL: @test_multiple_pred(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOOP_GUARD:%.*]] = icmp sgt i32 [[LIMIT:%.*]], 0
; CHECK-NEXT:    br i1 [[LOOP_GUARD]], label [[LOOP_PREHEADER:%.*]], label [[FAILURE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LIMIT]], [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    switch i32 [[LIMIT]], label [[FAILURE_LOOPEXIT:%.*]] [
; CHECK-NEXT:    i32 100, label [[BACKEDGE]]
; CHECK-NEXT:    i32 200, label [[BACKEDGE]]
; CHECK-NEXT:    ]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[IF_TRUE]] ], [ [[SUB]], [[IF_TRUE]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ne i32 [[SUM_NEXT]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure.loopexit:
; CHECK-NEXT:    br label [[FAILURE]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %loop_guard = icmp sgt i32 %limit, 0
  br i1 %loop_guard, label %loop, label %failure

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 %limit, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %if.true, label %if.false

if.true:
  switch i32 %limit, label %failure [
  i32 100, label %backedge
  i32 200, label %backedge
  ]

if.false:                                         ; preds = %loop
  br label %backedge

backedge:
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %if.true ], [ %sub, %if.true ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ne i32 %sum.next, %limit
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

define i32 @test_ne_const() {
; CHECK-LABEL: @test_ne_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT:%.*]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ne i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[BACKEDGE_LOOP_CRIT_EDGE:%.*]], label [[DONE:%.*]]
; CHECK:       backedge.loop_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:

  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ne i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

define i32 @test_slt_const() {
; CHECK-LABEL: @test_slt_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT:%.*]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[BACKEDGE_LOOP_CRIT_EDGE:%.*]], label [[DONE:%.*]]
; CHECK:       backedge.loop_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:

  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp slt i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

define i32 @test_ult_const() {
; CHECK-LABEL: @test_ult_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT:%.*]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[BACKEDGE_LOOP_CRIT_EDGE:%.*]], label [[DONE:%.*]]
; CHECK:       backedge.loop_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:

  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ult i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

define i32 @test_sgt_const() {
; CHECK-LABEL: @test_sgt_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT:%.*]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp sgt i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[BACKEDGE_LOOP_CRIT_EDGE:%.*]], label [[DONE:%.*]]
; CHECK:       backedge.loop_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:

  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp sgt i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

define i32 @test_ugt_const() {
; CHECK-LABEL: @test_ugt_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[BACKEDGE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT:%.*]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ugt i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[BACKEDGE_LOOP_CRIT_EDGE:%.*]], label [[DONE:%.*]]
; CHECK:       backedge.loop_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:

  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ugt i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

define i32 @test_multiple_pred_const() {
; CHECK-LABEL: @test_multiple_pred_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    switch i32 4, label [[FAILURE:%.*]] [
; CHECK-NEXT:    i32 100, label [[BACKEDGE:%.*]]
; CHECK-NEXT:    i32 200, label [[BACKEDGE]]
; CHECK-NEXT:    ]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[IF_TRUE]] ], [ [[SUB]], [[IF_TRUE]] ]
; CHECK-NEXT:    [[SUM_NEXT:%.*]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ne i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[BACKEDGE_LOOP_CRIT_EDGE:%.*]], label [[DONE:%.*]]
; CHECK:       backedge.loop_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:

  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %if.true, label %if.false

if.true:
  switch i32 4, label %failure [
  i32 100, label %backedge
  i32 200, label %backedge
  ]

if.false:                                         ; preds = %loop
  br label %backedge

backedge:
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %if.true ], [ %sub, %if.true ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ne i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_multiple_pred_2() {
; CHECK-LABEL: @test_multiple_pred_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    br i1 [[IS_POSITIVE]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br i1 undef, label [[IF_TRUE_1:%.*]], label [[IF_TRUE_2:%.*]]
; CHECK:       if.true.1:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       if.true.2:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       if.false:
; CHECK-NEXT:    br i1 undef, label [[IF_FALSE_1:%.*]], label [[IF_FALSE_2:%.*]]
; CHECK:       if.false.1:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       if.false.2:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE_1]] ], [ 0, [[IF_FALSE_2]] ], [ [[SUB]], [[IF_TRUE_1]] ], [ [[SUB]], [[IF_TRUE_2]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ne i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:

  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  br i1 %is.positive, label %if.true, label %if.false

if.true:
  br i1 undef, label %if.true.1, label %if.true.2

if.true.1:
  br label %backedge

if.true.2:
  br label %backedge

if.false:                                         ; preds = %loop
  br i1 undef, label %if.false.1, label %if.false.2

if.false.1:
  br label %backedge

if.false.2:
  br label %backedge

backedge:
  %merge.phi = phi i32 [ 0, %if.false.1 ], [ 0, %if.false.2 ], [ %sub, %if.true.1 ], [ %sub, %if.true.2 ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ne i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_select(i32 %limit) {
; CHECK-LABEL: @test_select(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOOP_GUARD:%.*]] = icmp sgt i32 [[LIMIT:%.*]], 0
; CHECK-NEXT:    br i1 [[LOOP_GUARD]], label [[LOOP_PREHEADER:%.*]], label [[FAILURE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ [[SUM_NEXT:%.*]], [[LOOP]] ], [ 0, [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LIMIT]], [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[IS_POSITIVE]], i32 [[SUB]], i32 0
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[SEL]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ne i32 [[SUM_NEXT]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[LOOP]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %loop_guard = icmp sgt i32 %limit, 0
  br i1 %loop_guard, label %loop, label %failure

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %loop ]
  %sub = sub i32 %limit, %sum
  %is.positive = icmp sgt i32 %sub, 0
  %sel = select i1 %is.positive, i32 %sub, i32 0
  %sum.next = add i32 %sum, %sel
  %loop.cond = icmp ne i32 %sum.next, %limit
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %loop ]
  ret i32 %sum.next.lcssa

failure:
  unreachable
}

; TODO: We can break the backedge here.
define i32 @test_select_const(i32 %x) {
; CHECK-LABEL: @test_select_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[SUM_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 4, [[SUM]]
; CHECK-NEXT:    [[IS_POSITIVE:%.*]] = icmp sgt i32 [[SUB]], 0
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[IS_POSITIVE]], i32 [[SUB]], i32 [[X:%.*]]
; CHECK-NEXT:    [[SEL_COND:%.*]] = icmp sgt i32 [[SEL]], 0
; CHECK-NEXT:    br i1 [[SEL_COND]], label [[BACKEDGE]], label [[IF_FALSE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[MERGE_PHI:%.*]] = phi i32 [ 0, [[IF_FALSE]] ], [ [[SUB]], [[LOOP]] ]
; CHECK-NEXT:    [[SUM_NEXT]] = add i32 [[SUM]], [[MERGE_PHI]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ne i32 [[SUM_NEXT]], 4
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[SUM_NEXT_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[SUM_NEXT_LCSSA]]
;
entry:
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %backedge ]
  %sub = sub i32 4, %sum
  %is.positive = icmp sgt i32 %sub, 0
  %sel = select i1 %is.positive, i32 %sub, i32 %x
  %sel.cond = icmp sgt i32 %sel, 0
  br i1 %sel.cond, label %backedge, label %if.false

if.false:                                         ; preds = %loop
  br label %backedge

backedge:                                         ; preds = %if.false, %loop
  %merge.phi = phi i32 [ 0, %if.false ], [ %sub, %loop ]
  %sum.next = add i32 %sum, %merge.phi
  %loop.cond = icmp ne i32 %sum.next, 4
  br i1 %loop.cond, label %loop, label %done

done:                                             ; preds = %backedge
  %sum.next.lcssa = phi i32 [ %sum.next, %backedge ]
  ret i32 %sum.next.lcssa
}
