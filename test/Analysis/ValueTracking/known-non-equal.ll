; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instsimplify < %s -S | FileCheck %s

define i1 @test(i8* %pq, i8 %B) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    ret i1 false
;
  %q = load i8, i8* %pq, !range !0 ; %q is known nonzero; no known bits
  %A = add nsw i8 %B, %q
  %cmp = icmp eq i8 %A, %B
  ret i1 %cmp
}

define i1 @test2(i8 %a, i8 %b) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i1 false
;
  %A = or i8 %a, 2    ; %A[1] = 1
  %B = and i8 %b, -3  ; %B[1] = 0
  %cmp = icmp eq i8 %A, %B ; %A[1] and %B[1] are contradictory.
  ret i1 %cmp
}

define i1 @test3(i8 %B) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i1 false
;
  %A = add nsw i8 %B, 1
  %cmp = icmp eq i8 %A, %B
  ret i1 %cmp
}

define i1 @sext(i8 %B) {
; CHECK-LABEL: @sext(
; CHECK-NEXT:    ret i1 false
;
  %A = add nsw i8 %B, 1
  %A.cast = sext i8 %A to i32
  %B.cast = sext i8 %B to i32
  %cmp = icmp eq i32 %A.cast, %B.cast
  ret i1 %cmp
}

define i1 @zext(i8 %B) {
; CHECK-LABEL: @zext(
; CHECK-NEXT:    ret i1 false
;
  %A = add nsw i8 %B, 1
  %A.cast = zext i8 %A to i32
  %B.cast = zext i8 %B to i32
  %cmp = icmp eq i32 %A.cast, %B.cast
  ret i1 %cmp
}

define i1 @inttoptr(i32 %B) {
; CHECK-LABEL: @inttoptr(
; CHECK-NEXT:    [[A:%.*]] = add nsw i32 [[B:%.*]], 1
; CHECK-NEXT:    [[A_CAST:%.*]] = inttoptr i32 [[A]] to i8*
; CHECK-NEXT:    [[B_CAST:%.*]] = inttoptr i32 [[B]] to i8*
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[A_CAST]], [[B_CAST]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %A = add nsw i32 %B, 1
  %A.cast = inttoptr i32 %A to i8*
  %B.cast = inttoptr i32 %B to i8*
  %cmp = icmp eq i8* %A.cast, %B.cast
  ret i1 %cmp
}

define i1 @ptrtoint(i32* %B) {
; CHECK-LABEL: @ptrtoint(
; CHECK-NEXT:    [[A:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i32 1
; CHECK-NEXT:    [[A_CAST:%.*]] = ptrtoint i32* [[A]] to i32
; CHECK-NEXT:    [[B_CAST:%.*]] = ptrtoint i32* [[B]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A_CAST]], [[B_CAST]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %A = getelementptr inbounds i32, i32* %B, i32 1
  %A.cast = ptrtoint i32* %A to i32
  %B.cast = ptrtoint i32* %B to i32
  %cmp = icmp eq i32 %A.cast, %B.cast
  ret i1 %cmp
}

define i1 @add1(i8 %B, i8 %C) {
; CHECK-LABEL: @add1(
; CHECK-NEXT:    ret i1 false
;
  %A = add i8 %B, 1
  %A.op = add i8 %A, %C
  %B.op = add i8 %B, %C

  %cmp = icmp eq i8 %A.op, %B.op
  ret i1 %cmp
}

define i1 @add2(i8 %B, i8 %C) {
; CHECK-LABEL: @add2(
; CHECK-NEXT:    ret i1 false
;
  %A = add i8 %B, 1
  %A.op = add i8 %C, %A
  %B.op = add i8 %C, %B

  %cmp = icmp eq i8 %A.op, %B.op
  ret i1 %cmp
}

define i1 @sub1(i8 %B, i8 %C) {
; CHECK-LABEL: @sub1(
; CHECK-NEXT:    [[A:%.*]] = add i8 [[B:%.*]], 1
; CHECK-NEXT:    [[A_OP:%.*]] = sub i8 [[A]], [[C:%.*]]
; CHECK-NEXT:    [[B_OP:%.*]] = sub i8 [[B]], [[C]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A_OP]], [[B_OP]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %A = add i8 %B, 1
  %A.op = sub i8 %A, %C
  %B.op = sub i8 %B, %C

  %cmp = icmp eq i8 %A.op, %B.op
  ret i1 %cmp
}

define i1 @sub2(i8 %B, i8 %C) {
; CHECK-LABEL: @sub2(
; CHECK-NEXT:    [[A:%.*]] = add i8 [[B:%.*]], 1
; CHECK-NEXT:    [[A_OP:%.*]] = sub i8 [[C:%.*]], [[A]]
; CHECK-NEXT:    [[B_OP:%.*]] = sub i8 [[C]], [[B]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A_OP]], [[B_OP]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %A = add i8 %B, 1
  %A.op = sub i8 %C, %A
  %B.op = sub i8 %C, %B

  %cmp = icmp eq i8 %A.op, %B.op
  ret i1 %cmp
}

!0 = !{ i8 1, i8 5 }
