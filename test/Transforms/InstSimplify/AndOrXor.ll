; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define i64 @pow2(i32 %x) {
; CHECK-LABEL: @pow2(
; CHECK:         [[NEGX:%.*]] = sub i32 0, %x
; CHECK-NEXT:    [[X2:%.*]] = and i32 %x, [[NEGX]]
; CHECK-NEXT:    [[E:%.*]] = zext i32 [[X2]] to i64
; CHECK-NEXT:    ret i64 [[E]]
;
  %negx = sub i32 0, %x
  %x2 = and i32 %x, %negx
  %e = zext i32 %x2 to i64
  %nege = sub i64 0, %e
  %e2 = and i64 %e, %nege
  ret i64 %e2
}

define i64 @pow2b(i32 %x) {
; CHECK-LABEL: @pow2b(
; CHECK:         [[SH:%.*]] = shl i32 2, %x
; CHECK-NEXT:    [[E:%.*]] = zext i32 [[SH]] to i64
; CHECK-NEXT:    ret i64 [[E]]
;
  %sh = shl i32 2, %x
  %e = zext i32 %sh to i64
  %nege = sub i64 0, %e
  %e2 = and i64 %e, %nege
  ret i64 %e2
}

define i32 @sub_neg_nuw(i32 %x, i32 %y) {
; CHECK-LABEL: @sub_neg_nuw(
; CHECK:         ret i32 %x
;
  %neg = sub nuw i32 0, %y
  %sub = sub i32 %x, %neg
  ret i32 %sub
}

define i1 @and_of_icmps0(i32 %b) {
; CHECK-LABEL: @and_of_icmps0(
; CHECK:         ret i1 false
;
  %1 = add i32 %b, 2
  %2 = icmp ult i32 %1, 4
  %cmp3 = icmp sgt i32 %b, 2
  %cmp = and i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @and_of_icmps1(i32 %b) {
; CHECK-LABEL: @and_of_icmps1(
; CHECK:         ret i1 false
;
  %1 = add nsw i32 %b, 2
  %2 = icmp slt i32 %1, 4
  %cmp3 = icmp sgt i32 %b, 2
  %cmp = and i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @and_of_icmps2(i32 %b) {
; CHECK-LABEL: @and_of_icmps2(
; CHECK:         ret i1 false
;
  %1 = add i32 %b, 2
  %2 = icmp ule i32 %1, 3
  %cmp3 = icmp sgt i32 %b, 2
  %cmp = and i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @and_of_icmps3(i32 %b) {
; CHECK-LABEL: @and_of_icmps3(
; CHECK:         ret i1 false
;
  %1 = add nsw i32 %b, 2
  %2 = icmp sle i32 %1, 3
  %cmp3 = icmp sgt i32 %b, 2
  %cmp = and i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @and_of_icmps4(i32 %b) {
; CHECK-LABEL: @and_of_icmps4(
; CHECK:         ret i1 false
;
  %1 = add nuw i32 %b, 2
  %2 = icmp ult i32 %1, 4
  %cmp3 = icmp ugt i32 %b, 2
  %cmp = and i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @and_of_icmps5(i32 %b) {
; CHECK-LABEL: @and_of_icmps5(
; CHECK:         ret i1 false
;
  %1 = add nuw i32 %b, 2
  %2 = icmp ule i32 %1, 3
  %cmp3 = icmp ugt i32 %b, 2
  %cmp = and i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @or_of_icmps0(i32 %b) {
; CHECK-LABEL: @or_of_icmps0(
; CHECK:         ret i1 true
;
  %1 = add i32 %b, 2
  %2 = icmp uge i32 %1, 4
  %cmp3 = icmp sle i32 %b, 2
  %cmp = or i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @or_of_icmps1(i32 %b) {
; CHECK-LABEL: @or_of_icmps1(
; CHECK:         ret i1 true
;
  %1 = add nsw i32 %b, 2
  %2 = icmp sge i32 %1, 4
  %cmp3 = icmp sle i32 %b, 2
  %cmp = or i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @or_of_icmps2(i32 %b) {
; CHECK-LABEL: @or_of_icmps2(
; CHECK:         ret i1 true
;
  %1 = add i32 %b, 2
  %2 = icmp ugt i32 %1, 3
  %cmp3 = icmp sle i32 %b, 2
  %cmp = or i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @or_of_icmps3(i32 %b) {
; CHECK-LABEL: @or_of_icmps3(
; CHECK:         ret i1 true
;
  %1 = add nsw i32 %b, 2
  %2 = icmp sgt i32 %1, 3
  %cmp3 = icmp sle i32 %b, 2
  %cmp = or i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @or_of_icmps4(i32 %b) {
; CHECK-LABEL: @or_of_icmps4(
; CHECK:         ret i1 true
;
  %1 = add nuw i32 %b, 2
  %2 = icmp uge i32 %1, 4
  %cmp3 = icmp ule i32 %b, 2
  %cmp = or i1 %2, %cmp3
  ret i1 %cmp
}

define i1 @or_of_icmps5(i32 %b) {
; CHECK-LABEL: @or_of_icmps5(
; CHECK:         ret i1 true
;
  %1 = add nuw i32 %b, 2
  %2 = icmp ugt i32 %1, 3
  %cmp3 = icmp ule i32 %b, 2
  %cmp = or i1 %2, %cmp3
  ret i1 %cmp
}

define i32 @neg_nuw(i32 %x) {
; CHECK-LABEL: @neg_nuw(
; CHECK:         ret i32 0
;
  %neg = sub nuw i32 0, %x
  ret i32 %neg
}

define i1 @and_icmp1(i32 %x, i32 %y) {
; CHECK-LABEL: @and_icmp1(
; CHECK:         [[TMP1:%.*]] = icmp ult i32 %x, %y
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %1 = icmp ult i32 %x, %y
  %2 = icmp ne i32 %y, 0
  %3 = and i1 %1, %2
  ret i1 %3
}

define i1 @and_icmp2(i32 %x, i32 %y) {
; CHECK-LABEL: @and_icmp2(
; CHECK:         ret i1 false
;
  %1 = icmp ult i32 %x, %y
  %2 = icmp eq i32 %y, 0
  %3 = and i1 %1, %2
  ret i1 %3
}

define i1 @or_icmp1(i32 %x, i32 %y) {
; CHECK-LABEL: @or_icmp1(
; CHECK:         [[TMP1:%.*]] = icmp ne i32 %y, 0
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %1 = icmp ult i32 %x, %y
  %2 = icmp ne i32 %y, 0
  %3 = or i1 %1, %2
  ret i1 %3
}

define i1 @or_icmp2(i32 %x, i32 %y) {
; CHECK-LABEL: @or_icmp2(
; CHECK:         ret i1 true
;
  %1 = icmp uge i32 %x, %y
  %2 = icmp ne i32 %y, 0
  %3 = or i1 %1, %2
  ret i1 %3
}

define i1 @or_icmp3(i32 %x, i32 %y) {
; CHECK-LABEL: @or_icmp3(
; CHECK:         [[TMP1:%.*]] = icmp uge i32 %x, %y
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %1 = icmp uge i32 %x, %y
  %2 = icmp eq i32 %y, 0
  %3 = or i1 %1, %2
  ret i1 %3
}

