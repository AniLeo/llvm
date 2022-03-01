; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -passes=instcombine | FileCheck %s

define i1 @test_direct_implication(i1 %cond) {
; CHECK-LABEL: @test_direct_implication(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    ret i1 [[COND]]
;
entry:
  br i1 %cond, label %if.true, label %if.false

if.true:
  br label %merge

if.false:
  br label %merge

merge:
  %ret = phi i1 [true, %if.true], [false, %if.false]
  ret i1 %ret
}

define i1 @test_inverted_implication(i1 %cond) {
; CHECK-LABEL: @test_inverted_implication(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[TMP0:%.*]] = xor i1 [[COND]], true
; CHECK-NEXT:    ret i1 [[TMP0]]
;
entry:
  br i1 %cond, label %if.true, label %if.false

if.true:
  br label %merge

if.false:
  br label %merge

merge:
  %ret = phi i1 [false, %if.true], [true, %if.false]
  ret i1 %ret
}

define i1 @test_edge_dominance(i1 %cmp) {
; CHECK-LABEL: @test_edge_dominance(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_END:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br i1 %cmp, label %if.end, label %if.then

if.then:
  br label %if.end

if.end:
  %phi = phi i1 [ true, %entry ], [ false, %if.then ]
  ret i1 %phi
}

define i1 @test_direct_implication_complex_cfg(i1 %cond, i32 %cnt1) {
; CHECK-LABEL: @test_direct_implication_complex_cfg(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    [[IV1:%.*]] = phi i32 [ 0, [[IF_TRUE]] ], [ [[IV1_NEXT:%.*]], [[LOOP1]] ]
; CHECK-NEXT:    [[IV1_NEXT]] = add i32 [[IV1]], 1
; CHECK-NEXT:    [[LOOP_COND_1:%.*]] = icmp slt i32 [[IV1_NEXT]], [[CNT1:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND_1]], label [[LOOP1]], label [[IF_TRUE_END:%.*]]
; CHECK:       if.true.end:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    ret i1 [[COND]]
;
entry:
  br i1 %cond, label %if.true, label %if.false

if.true:
  br label %loop1

loop1:
  %iv1 = phi i32 [0, %if.true], [%iv1.next, %loop1]
  %iv1.next = add i32 %iv1, 1
  %loop.cond.1 = icmp slt i32 %iv1.next, %cnt1
  br i1 %loop.cond.1, label %loop1, label %if.true.end

if.true.end:
  br label %merge

if.false:
  br label %merge

merge:
  %ret = phi i1 [true, %if.true.end], [false, %if.false]
  ret i1 %ret
}

define i1 @test_inverted_implication_complex_cfg(i1 %cond, i32 %cnt1) {
; CHECK-LABEL: @test_inverted_implication_complex_cfg(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    [[IV1:%.*]] = phi i32 [ 0, [[IF_TRUE]] ], [ [[IV1_NEXT:%.*]], [[LOOP1]] ]
; CHECK-NEXT:    [[IV1_NEXT]] = add i32 [[IV1]], 1
; CHECK-NEXT:    [[LOOP_COND_1:%.*]] = icmp slt i32 [[IV1_NEXT]], [[CNT1:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND_1]], label [[LOOP1]], label [[IF_TRUE_END:%.*]]
; CHECK:       if.true.end:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[TMP0:%.*]] = xor i1 [[COND]], true
; CHECK-NEXT:    ret i1 [[TMP0]]
;
entry:
  br i1 %cond, label %if.true, label %if.false

if.true:
  br label %loop1

loop1:
  %iv1 = phi i32 [0, %if.true], [%iv1.next, %loop1]
  %iv1.next = add i32 %iv1, 1
  %loop.cond.1 = icmp slt i32 %iv1.next, %cnt1
  br i1 %loop.cond.1, label %loop1, label %if.true.end

if.true.end:
  br label %merge

if.false:
  br label %merge

merge:
  %ret = phi i1 [false, %if.true.end], [true, %if.false]
  ret i1 %ret
}

define i1 @test_multiple_predecessors(i1 %cond, i1 %cond2) {
; CHECK-LABEL: @test_multiple_predecessors(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br i1 [[COND2:%.*]], label [[IF2_TRUE:%.*]], label [[IF2_FALSE:%.*]]
; CHECK:       if2.true:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       if2.false:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    ret i1 [[COND]]
;
entry:
  br i1 %cond, label %if.true, label %if.false

if.true:
  br label %merge

if.false:
  br i1 %cond2, label %if2.true, label %if2.false

if2.true:
  br label %merge

if2.false:
  br label %merge

merge:
  %ret = phi i1 [ true, %if.true ], [ false, %if2.true ], [ false, %if2.false ]
  ret i1 %ret
}

define i1 @test_multiple_predecessors_wrong_value(i1 %cond, i1 %cond2) {
; CHECK-LABEL: @test_multiple_predecessors_wrong_value(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br i1 [[COND2:%.*]], label [[IF2_TRUE:%.*]], label [[IF2_FALSE:%.*]]
; CHECK:       if2.true:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       if2.false:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[RET:%.*]] = phi i1 [ true, [[IF_TRUE]] ], [ true, [[IF2_TRUE]] ], [ false, [[IF2_FALSE]] ]
; CHECK-NEXT:    ret i1 [[RET]]
;
entry:
  br i1 %cond, label %if.true, label %if.false

if.true:
  br label %merge

if.false:
  br i1 %cond2, label %if2.true, label %if2.false

if2.true:
  br label %merge

if2.false:
  br label %merge

merge:
  %ret = phi i1 [ true, %if.true ], [ true, %if2.true ], [ false, %if2.false ]
  ret i1 %ret
}

define i1 @test_multiple_predecessors_no_edge_domination(i1 %cond, i1 %cond2) {
; CHECK-LABEL: @test_multiple_predecessors_no_edge_domination(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br i1 [[COND2:%.*]], label [[MERGE:%.*]], label [[IF_FALSE]]
; CHECK:       if.false:
; CHECK-NEXT:    br i1 [[COND2]], label [[IF2_TRUE:%.*]], label [[IF2_FALSE:%.*]]
; CHECK:       if2.true:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       if2.false:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[RET:%.*]] = phi i1 [ true, [[IF_TRUE]] ], [ false, [[IF2_TRUE]] ], [ false, [[IF2_FALSE]] ]
; CHECK-NEXT:    ret i1 [[RET]]
;
entry:
  br i1 %cond, label %if.true, label %if.false

if.true:
  br i1 %cond2, label %merge, label %if.false

if.false:
  br i1 %cond2, label %if2.true, label %if2.false

if2.true:
  br label %merge

if2.false:
  br label %merge

merge:
  %ret = phi i1 [ true, %if.true ], [ false, %if2.true ], [ false, %if2.false ]
  ret i1 %ret
}
