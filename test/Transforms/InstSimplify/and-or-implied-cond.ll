; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instsimplify < %s | FileCheck %s

define i1 @or_implied(i8 %x, i1 %c) {
; CHECK-LABEL: @or_implied(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp eq i8 %x, 0
  %cmp2 = icmp ne i8 %x, 1
  %and = and i1 %cmp, %c
  %or = or i1 %and, %cmp2
  ret i1 %or
}

define i1 @or_implied_comm1(i8 %x, i1 %c) {
; CHECK-LABEL: @or_implied_comm1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp eq i8 %x, 0
  %cmp2 = icmp ne i8 %x, 1
  %and = and i1 %cmp, %c
  %or = or i1 %cmp2, %and
  ret i1 %or
}

define i1 @or_implied_comm2(i8 %x, i1 %c) {
; CHECK-LABEL: @or_implied_comm2(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp eq i8 %x, 0
  %cmp2 = icmp ne i8 %x, 1
  %and = and i1 %c, %cmp
  %or = or i1 %and, %cmp2
  ret i1 %or
}

define i1 @or_implied_comm3(i8 %x, i1 %c) {
; CHECK-LABEL: @or_implied_comm3(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp eq i8 %x, 0
  %cmp2 = icmp ne i8 %x, 1
  %and = and i1 %c, %cmp
  %or = or i1 %cmp2, %and
  ret i1 %or
}

define i1 @or_not_implied(i8 %x, i1 %c) {
; CHECK-LABEL: @or_not_implied(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[X]], 0
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[CMP]], [[C:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[AND]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp = icmp eq i8 %x, 0
  %cmp2 = icmp ne i8 %x, 0
  %and = and i1 %cmp, %c
  %or = or i1 %and, %cmp2
  ret i1 %or
}

define i1 @and_implied(i8 %x, i1 %c) {
; CHECK-LABEL: @and_implied(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp ne i8 %x, 0
  %cmp2 = icmp eq i8 %x, 1
  %or = or i1 %cmp, %c
  %and = and i1 %or, %cmp2
  ret i1 %and
}

define i1 @and_implied_comm1(i8 %x, i1 %c) {
; CHECK-LABEL: @and_implied_comm1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp ne i8 %x, 0
  %cmp2 = icmp eq i8 %x, 1
  %or = or i1 %cmp, %c
  %and = and i1 %cmp2, %or
  ret i1 %and
}

define i1 @and_implied_comm2(i8 %x, i1 %c) {
; CHECK-LABEL: @and_implied_comm2(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp ne i8 %x, 0
  %cmp2 = icmp eq i8 %x, 1
  %or = or i1 %c, %cmp
  %and = and i1 %or, %cmp2
  ret i1 %and
}

define i1 @and_implied_comm3(i8 %x, i1 %c) {
; CHECK-LABEL: @and_implied_comm3(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp ne i8 %x, 0
  %cmp2 = icmp eq i8 %x, 1
  %or = or i1 %c, %cmp
  %and = and i1 %cmp2, %or
  ret i1 %and
}

define i1 @and_not_implied(i8 %x, i1 %c) {
; CHECK-LABEL: @and_not_implied(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[X]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP]], [[C:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[OR]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[AND]]
;
  %cmp = icmp ne i8 %x, 0
  %cmp2 = icmp eq i8 %x, 0
  %or = or i1 %cmp, %c
  %and = and i1 %or, %cmp2
  ret i1 %and
}
