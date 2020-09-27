; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constraint-elimination -S %s | FileCheck %s
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

; Test cases where both the true and false successors reach the same block,
; dominated by one of them.

declare void @use(i1)

define i32 @test1(i32 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ule i32 [[X:%.*]], 10
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ule i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    ret i32 20
;
entry:
  %c.1 = icmp ule i32 %x, 10
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %c.2 = icmp ule i32 %x, 10
  call void @use(i1 %c.2)
  br label %bb2

bb2:
  %c.3 = icmp ugt i32 %x, 10
  call void @use(i1 %c.3)
  ret i32 20
}


define i32 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ule i32 [[X:%.*]], 10
; CHECK-NEXT:    br i1 [[C_1]], label [[BB2:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    ret i32 20
; CHECK:       bb2:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ule i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    br label [[BB1]]
;
entry:
  %c.1 = icmp ule i32 %x, 10
  br i1 %c.1, label %bb2, label %bb1

bb1:
  %c.2 = icmp ugt i32 %x, 10
  call void @use(i1 %c.2)
  ret i32 20

bb2:
  %c.3 = icmp ule i32 %x, 10
  call void @use(i1 %c.3)
  br label %bb1
}


; Test cases where the true/false successors are not domianted by the conditional branching block.
define i32 @test3(i32 %x, i1 %c) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB_COND:%.*]], label [[BB1:%.*]]
; CHECK:       bb.cond:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ule i32 [[X:%.*]], 10
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ule i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    ret i32 10
; CHECK:       bb2:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret i32 20
;
entry:
  br i1 %c, label %bb.cond, label %bb1

bb.cond:
  %c.1 = icmp ule i32 %x, 10
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %c.2 = icmp ule i32 %x, 10
  call void @use(i1 %c.2)
  ret i32 10

bb2:
  %c.3 = icmp ugt i32 %x, 10
  call void @use(i1 %c.3)
  ret i32 20
}

define i32 @test4(i32 %x, i1 %c) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB_COND:%.*]], label [[BB2:%.*]]
; CHECK:       bb.cond:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ule i32 [[X:%.*]], 10
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2]]
; CHECK:       bb1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ule i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret i32 10
; CHECK:       bb2:
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[X]], 10
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    ret i32 20
;
entry:
  br i1 %c, label %bb.cond, label %bb2

bb.cond:
  %c.1 = icmp ule i32 %x, 10
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %c.2 = icmp ule i32 %x, 10
  call void @use(i1 %c.2)
  ret i32 10

bb2:
  %c.3 = icmp ugt i32 %x, 10
  call void @use(i1 %c.3)
  ret i32 20
}
