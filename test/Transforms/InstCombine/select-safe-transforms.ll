; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine-unsafe-select-transform=0 -instcombine -S | FileCheck %s

define i1 @cond_eq_and(i8 %X, i8 %Y, i8 noundef %C) {
; CHECK-LABEL: @cond_eq_and(
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8 [[X:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[LHS:%.*]] = icmp ult i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 [[LHS]], i1 false
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp eq i8 %X, %C
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 %lhs, i1 false
  ret i1 %res
}

define i1 @cond_eq_and_const(i8 %X, i8 %Y) {
; CHECK-LABEL: @cond_eq_and_const(
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8 [[X:%.*]], 10
; CHECK-NEXT:    [[LHS:%.*]] = icmp ult i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 [[LHS]], i1 false
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp eq i8 %X, 10
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 %lhs, i1 false
  ret i1 %res
}

define i1 @cond_eq_or(i8 %X, i8 %Y, i8 noundef %C) {
; CHECK-LABEL: @cond_eq_or(
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i8 [[X:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[LHS:%.*]] = icmp ult i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 true, i1 [[LHS]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp ne i8 %X, %C
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 true, i1 %lhs
  ret i1 %res
}

define i1 @cond_eq_or_const(i8 %X, i8 %Y) {
; CHECK-LABEL: @cond_eq_or_const(
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i8 [[X:%.*]], 10
; CHECK-NEXT:    [[LHS:%.*]] = icmp ult i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 true, i1 [[LHS]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp ne i8 %X, 10
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 true, i1 %lhs
  ret i1 %res
}

define i1 @merge_and(i1 %X, i1 %Y) {
; CHECK-LABEL: @merge_and(
; CHECK-NEXT:    [[C:%.*]] = select i1 [[X:%.*]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    ret i1 [[C]]
;
  %c = select i1 %X, i1 %Y, i1 false
  %res = and i1 %X, %c
  ret i1 %res
}

define i1 @merge_or(i1 %X, i1 %Y) {
; CHECK-LABEL: @merge_or(
; CHECK-NEXT:    [[C:%.*]] = select i1 [[X:%.*]], i1 true, i1 [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %c = select i1 %X, i1 true, i1 %Y
  %res = or i1 %X, %c
  ret i1 %res
}

define i1 @xor_and(i1 %c, i32 %X, i32 %Y) {
; CHECK-LABEL: @xor_and(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT_C:%.*]] = xor i1 [[C:%.*]], true
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[NOT_C]], i1 true, i1 [[COMP]]
; CHECK-NEXT:    ret i1 [[SEL]]
;
  %comp = icmp ult i32 %X, %Y
  %sel = select i1 %c, i1 %comp, i1 false
  %res = xor i1 %sel, true
  ret i1 %res
}

define <2 x i1> @xor_and2(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_and2(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> [[COMP]], <2 x i1> <i1 false, i1 true>
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> %comp, <2 x i1> <i1 true, i1 false>
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}

@glb = global i8 0

define <2 x i1> @xor_and3(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_and3(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> [[COMP]], <2 x i1> <i1 icmp ne (i8* inttoptr (i64 1234 to i8*), i8* @glb), i1 true>
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> %comp, <2 x i1> <i1 icmp eq (i8* @glb, i8* inttoptr (i64 1234 to i8*)), i1 false>
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}

define i1 @xor_or(i1 %c, i32 %X, i32 %Y) {
; CHECK-LABEL: @xor_or(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT_C:%.*]] = xor i1 [[C:%.*]], true
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[NOT_C]], i1 [[COMP]], i1 false
; CHECK-NEXT:    ret i1 [[SEL]]
;
  %comp = icmp ult i32 %X, %Y
  %sel = select i1 %c, i1 true, i1 %comp
  %res = xor i1 %sel, true
  ret i1 %res
}

define <2 x i1> @xor_or2(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_or2(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> <i1 false, i1 true>, <2 x i1> [[COMP]]
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> <i1 true, i1 false>, <2 x i1> %comp
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}

define <2 x i1> @xor_or3(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_or3(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> <i1 icmp ne (i8* inttoptr (i64 1234 to i8*), i8* @glb), i1 true>, <2 x i1> [[COMP]]
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> <i1 icmp eq (i8* @glb, i8* inttoptr (i64 1234 to i8*)), i1 false>, <2 x i1> %comp
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}
