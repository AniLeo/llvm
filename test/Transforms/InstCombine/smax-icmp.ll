; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

; If we have an smax feeding a signed or equality icmp that shares an
; operand with the smax, the compare should always be folded.
; Test all 4 foldable predicates (eq,ne,sgt,sle) * 4 commutation
; possibilities for each predicate. Note that folds to true/false
; (predicate = sge/slt) or folds to an existing instruction should be
; handled by InstSimplify.

; smax(X, Y) == X --> X >= Y

define i1 @eq_smax1(i32 %x, i32 %y) {
; CHECK-LABEL: @eq_smax1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp eq i32 %sel, %x
  ret i1 %cmp2
}

; Commute max operands.

define i1 @eq_smax2(i32 %x, i32 %y) {
; CHECK-LABEL: @eq_smax2(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp eq i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the max op to the RHS.

define i1 @eq_smax3(i32 %a, i32 %y) {
; CHECK-LABEL: @eq_smax3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp eq i32 %x, %sel
  ret i1 %cmp2
}

; Commute max operands.

define i1 @eq_smax4(i32 %a, i32 %y) {
; CHECK-LABEL: @eq_smax4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp eq i32 %x, %sel
  ret i1 %cmp2
}

; smax(X, Y) <= X --> X >= Y

define i1 @sle_smax1(i32 %x, i32 %y) {
; CHECK-LABEL: @sle_smax1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp sle i32 %sel, %x
  ret i1 %cmp2
}

; Commute max operands.

define i1 @sle_smax2(i32 %x, i32 %y) {
; CHECK-LABEL: @sle_smax2(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp sle i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the max op to the RHS.

define i1 @sle_smax3(i32 %a, i32 %y) {
; CHECK-LABEL: @sle_smax3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp sge i32 %x, %sel
  ret i1 %cmp2
}

; Commute max operands.

define i1 @sle_smax4(i32 %a, i32 %y) {
; CHECK-LABEL: @sle_smax4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp sge i32 %x, %sel
  ret i1 %cmp2
}

; smax(X, Y) != X --> X < Y

define i1 @ne_smax1(i32 %x, i32 %y) {
; CHECK-LABEL: @ne_smax1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp ne i32 %sel, %x
  ret i1 %cmp2
}

; Commute max operands.

define i1 @ne_smax2(i32 %x, i32 %y) {
; CHECK-LABEL: @ne_smax2(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp ne i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the max op to the RHS.

define i1 @ne_smax3(i32 %a, i32 %y) {
; CHECK-LABEL: @ne_smax3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp ne i32 %x, %sel
  ret i1 %cmp2
}

; Commute max operands.

define i1 @ne_smax4(i32 %a, i32 %y) {
; CHECK-LABEL: @ne_smax4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp ne i32 %x, %sel
  ret i1 %cmp2
}

; smax(X, Y) > X --> X < Y

define i1 @sgt_smax1(i32 %x, i32 %y) {
; CHECK-LABEL: @sgt_smax1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp sgt i32 %sel, %x
  ret i1 %cmp2
}

; Commute max operands.

define i1 @sgt_smax2(i32 %x, i32 %y) {
; CHECK-LABEL: @sgt_smax2(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp sgt i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the max op to the RHS.

define i1 @sgt_smax3(i32 %a, i32 %y) {
; CHECK-LABEL: @sgt_smax3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp slt i32 %x, %sel
  ret i1 %cmp2
}

; Commute max operands.

define i1 @sgt_smax4(i32 %a, i32 %y) {
; CHECK-LABEL: @sgt_smax4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp sgt i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp slt i32 %x, %sel
  ret i1 %cmp2
}

