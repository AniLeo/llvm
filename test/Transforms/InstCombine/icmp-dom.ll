; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define void @idom_sign_bit_check_edge_dominates(i64 %a) {
; CHECK-LABEL: @idom_sign_bit_check_edge_dominates(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[LAND_LHS_TRUE:%.*]], label [[LOR_RHS:%.*]]
; CHECK:       land.lhs.true:
; CHECK-NEXT:    br label [[LOR_END:%.*]]
; CHECK:       lor.rhs:
; CHECK-NEXT:    [[CMP2_NOT:%.*]] = icmp eq i64 [[A]], 0
; CHECK-NEXT:    br i1 [[CMP2_NOT]], label [[LOR_END]], label [[LAND_RHS:%.*]]
; CHECK:       land.rhs:
; CHECK-NEXT:    br label [[LOR_END]]
; CHECK:       lor.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp slt i64 %a, 0
  br i1 %cmp, label %land.lhs.true, label %lor.rhs

land.lhs.true:
  br label %lor.end

lor.rhs:
  %cmp2 = icmp sgt i64 %a, 0
  br i1 %cmp2, label %land.rhs, label %lor.end

land.rhs:
  br label %lor.end

lor.end:
  ret void
}

define void @idom_sign_bit_check_edge_not_dominates(i64 %a) {
; CHECK-LABEL: @idom_sign_bit_check_edge_not_dominates(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[LAND_LHS_TRUE:%.*]], label [[LOR_RHS:%.*]]
; CHECK:       land.lhs.true:
; CHECK-NEXT:    br i1 undef, label [[LOR_END:%.*]], label [[LOR_RHS]]
; CHECK:       lor.rhs:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i64 [[A]], 0
; CHECK-NEXT:    br i1 [[CMP2]], label [[LAND_RHS:%.*]], label [[LOR_END]]
; CHECK:       land.rhs:
; CHECK-NEXT:    br label [[LOR_END]]
; CHECK:       lor.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp slt i64 %a, 0
  br i1 %cmp, label %land.lhs.true, label %lor.rhs

land.lhs.true:
  br i1 undef, label %lor.end, label %lor.rhs

lor.rhs:
  %cmp2 = icmp sgt i64 %a, 0
  br i1 %cmp2, label %land.rhs, label %lor.end

land.rhs:
  br label %lor.end

lor.end:
  ret void
}

define void @idom_sign_bit_check_edge_dominates_select(i64 %a, i64 %b) {
; CHECK-LABEL: @idom_sign_bit_check_edge_dominates_select(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[LAND_LHS_TRUE:%.*]], label [[LOR_RHS:%.*]]
; CHECK:       land.lhs.true:
; CHECK-NEXT:    br label [[LOR_END:%.*]]
; CHECK:       lor.rhs:
; CHECK-NEXT:    [[CMP3_NOT:%.*]] = icmp eq i64 [[A]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP3_NOT]], label [[LOR_END]], label [[LAND_RHS:%.*]]
; CHECK:       land.rhs:
; CHECK-NEXT:    br label [[LOR_END]]
; CHECK:       lor.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp slt i64 %a, 5
  br i1 %cmp, label %land.lhs.true, label %lor.rhs

land.lhs.true:
  br label %lor.end

lor.rhs:
  %cmp2 = icmp sgt i64 %a, 5
  %select = select i1 %cmp2, i64 %a, i64 5
  %cmp3 = icmp ne i64 %select, %b
  br i1 %cmp3, label %land.rhs, label %lor.end

land.rhs:
  br label %lor.end

lor.end:
  ret void
}

define void @idom_zbranch(i64 %a) {
; CHECK-LABEL: @idom_zbranch(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i64 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[LOR_END:%.*]], label [[LOR_RHS:%.*]]
; CHECK:       lor.rhs:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i64 [[A]], 0
; CHECK-NEXT:    br i1 [[CMP2]], label [[LAND_RHS:%.*]], label [[LOR_END]]
; CHECK:       land.rhs:
; CHECK-NEXT:    br label [[LOR_END]]
; CHECK:       lor.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i64 %a, 0
  br i1 %cmp, label %lor.end, label %lor.rhs

lor.rhs:
  %cmp2 = icmp slt i64 %a, 0
  br i1 %cmp2, label %land.rhs, label %lor.end

land.rhs:
  br label %lor.end

lor.end:
  ret void
}

define void @idom_not_zbranch(i32 %a, i32 %b) {
; CHECK-LABEL: @idom_not_zbranch(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[RETURN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CMP2_NOT:%.*]] = icmp eq i32 [[A]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP2_NOT]], label [[RETURN]], label [[IF_THEN3:%.*]]
; CHECK:       if.then3:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i32 %a, 0
  br i1 %cmp, label %return, label %if.end

if.end:
  %cmp1 = icmp slt i32 %a, 0
  %a. = select i1 %cmp1, i32 %a, i32 0
  %cmp2 = icmp ne i32 %a., %b
  br i1 %cmp2, label %if.then3, label %return

if.then3:
  br label %return

return:
  ret void
}

define void @trueblock_cmp_eq(i32 %a, i32 %b) {
; CHECK-LABEL: @trueblock_cmp_eq(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_END:%.*]], label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[A]], 1
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN3:%.*]], label [[RETURN]]
; CHECK:       if.then3:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i32 %a, 0
  br i1 %cmp, label %if.end, label %return

if.end:
  %cmp1 = icmp slt i32 %a, 2
  br i1 %cmp1, label %if.then3, label %return

if.then3:
  br label %return

return:
  ret void
}

define i1 @trueblock_cmp_is_false(i32 %x, i32 %y) {
; CHECK-LABEL: @trueblock_cmp_is_false(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 false
; CHECK:       f:
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %cmp = icmp sgt i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  %cmp2 = icmp slt i32 %x, %y
  ret i1 %cmp2
f:
  ret i1 %cmp
}

define i1 @trueblock_cmp_is_false_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @trueblock_cmp_is_false_commute(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 false
; CHECK:       f:
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %cmp = icmp eq i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  %cmp2 = icmp sgt i32 %y, %x
  ret i1 %cmp2
f:
  ret i1 %cmp
}

define i1 @trueblock_cmp_is_true(i32 %x, i32 %y) {
; CHECK-LABEL: @trueblock_cmp_is_true(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 true
; CHECK:       f:
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %cmp = icmp ult i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  %cmp2 = icmp ne i32 %x, %y
  ret i1 %cmp2
f:
  ret i1 %cmp
}

define i1 @trueblock_cmp_is_true_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @trueblock_cmp_is_true_commute(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 true
; CHECK:       f:
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %cmp = icmp ugt i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  %cmp2 = icmp ne i32 %y, %x
  ret i1 %cmp2
f:
  ret i1 %cmp
}

define i1 @falseblock_cmp_is_false(i32 %x, i32 %y) {
; CHECK-LABEL: @falseblock_cmp_is_false(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 [[CMP]]
; CHECK:       f:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sle i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  ret i1 %cmp
f:
  %cmp2 = icmp slt i32 %x, %y
  ret i1 %cmp2
}

define i1 @falseblock_cmp_is_false_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @falseblock_cmp_is_false_commute(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 [[CMP]]
; CHECK:       f:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp eq i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  ret i1 %cmp
f:
  %cmp2 = icmp eq i32 %y, %x
  ret i1 %cmp2
}

define i1 @falseblock_cmp_is_true(i32 %x, i32 %y) {
; CHECK-LABEL: @falseblock_cmp_is_true(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 [[CMP]]
; CHECK:       f:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp ult i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  ret i1 %cmp
f:
  %cmp2 = icmp uge i32 %x, %y
  ret i1 %cmp2
}

define i1 @falseblock_cmp_is_true_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @falseblock_cmp_is_true_commute(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 [[CMP]]
; CHECK:       f:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %x, %y
  br i1 %cmp, label %t, label %f
t:
  ret i1 %cmp
f:
  %cmp2 = icmp sge i32 %y, %x
  ret i1 %cmp2
}

; This used to infinite loop because of a conflict
; with min/max canonicalization.

define i32 @PR48900(i32 %i, i1* %p) {
; CHECK-LABEL: @PR48900(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.umax.i32(i32 [[I:%.*]], i32 1)
; CHECK-NEXT:    [[I4:%.*]] = icmp sgt i32 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[I4]], label [[TRUELABEL:%.*]], label [[FALSELABEL:%.*]]
; CHECK:       truelabel:
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.umin.i32(i32 [[TMP1]], i32 2)
; CHECK-NEXT:    ret i32 [[TMP2]]
; CHECK:       falselabel:
; CHECK-NEXT:    ret i32 0
;
  %maxcmp = icmp ugt i32 %i, 1
  %umax = select i1 %maxcmp, i32 %i, i32 1
  %i4 = icmp sgt i32 %umax, 0
  br i1 %i4, label %truelabel, label %falselabel

truelabel:
  %mincmp = icmp ult i32 %umax, 2
  %smin = select i1 %mincmp, i32 %umax, i32 2
  ret i32 %smin

falselabel:
  ret i32 0
}

; This used to infinite loop because of a conflict
; with min/max canonicalization.

define i8 @PR48900_alt(i8 %i, i1* %p) {
; CHECK-LABEL: @PR48900_alt(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smax.i8(i8 [[I:%.*]], i8 -127)
; CHECK-NEXT:    [[I4:%.*]] = icmp ugt i8 [[TMP1]], -128
; CHECK-NEXT:    br i1 [[I4]], label [[TRUELABEL:%.*]], label [[FALSELABEL:%.*]]
; CHECK:       truelabel:
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.smin.i8(i8 [[TMP1]], i8 -126)
; CHECK-NEXT:    ret i8 [[TMP2]]
; CHECK:       falselabel:
; CHECK-NEXT:    ret i8 0
;
  %maxcmp = icmp sgt i8 %i, -127
  %smax = select i1 %maxcmp, i8 %i, i8 -127
  %i4 = icmp ugt i8 %smax, 128
  br i1 %i4, label %truelabel, label %falselabel

truelabel:
  %mincmp = icmp slt i8 %smax, -126
  %umin = select i1 %mincmp, i8 %smax, i8 -126
  ret i8 %umin

falselabel:
  ret i8 0
}
