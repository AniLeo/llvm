; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -ipsccp -S %s -o -| FileCheck %s

define i64 @test1(i32 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[C]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[EXT_1:%.*]] = sext i32 [[X]] to i64
; CHECK-NEXT:    ret i64 [[EXT_1]]
; CHECK:       false:
; CHECK-NEXT:    [[EXT_2:%.*]] = sext i32 [[X]] to i64
; CHECK-NEXT:    ret i64 [[EXT_2]]
;
  %c = icmp sgt i32 %x, 0
  br i1 %c, label %true, label %false

true:
  %ext.1 = sext i32 %x to i64
  ret i64 %ext.1

false:
  %ext.2 = sext i32 %x to i64
  ret i64 %ext.2
}

define i64 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[C:%.*]] = icmp sge i32 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[C]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[EXT_1:%.*]] = sext i32 [[X]] to i64
; CHECK-NEXT:    ret i64 [[EXT_1]]
; CHECK:       false:
; CHECK-NEXT:    [[EXT_2:%.*]] = sext i32 [[X]] to i64
; CHECK-NEXT:    ret i64 [[EXT_2]]
;
  %c = icmp sge i32 %x, 0
  br i1 %c, label %true, label %false

true:
  %ext.1 = sext i32 %x to i64
  ret i64 %ext.1

false:
  %ext.2 = sext i32 %x to i64
  ret i64 %ext.2
}


define i64 @test3(i32 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[C:%.*]] = icmp sge i32 [[X:%.*]], -1
; CHECK-NEXT:    br i1 [[C]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[EXT_1:%.*]] = sext i32 [[X]] to i64
; CHECK-NEXT:    ret i64 [[EXT_1]]
; CHECK:       false:
; CHECK-NEXT:    [[EXT_2:%.*]] = sext i32 [[X]] to i64
; CHECK-NEXT:    ret i64 [[EXT_2]]
;
  %c = icmp sge i32 %x, -1
  br i1 %c, label %true, label %false

true:
  %ext.1 = sext i32 %x to i64
  ret i64 %ext.1

false:
  %ext.2 = sext i32 %x to i64
  ret i64 %ext.2
}

define i64 @test4_sext_op_can_be_undef(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test4_sext_op_can_be_undef(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[TRUE_1:%.*]], label [[FALSE:%.*]]
; CHECK:       true.1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[TRUE_2:%.*]], label [[EXIT:%.*]]
; CHECK:       true.2:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       false:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[TRUE_1]] ], [ 1, [[TRUE_2]] ], [ undef, [[FALSE]] ]
; CHECK-NEXT:    [[EXT:%.*]] = sext i32 [[P]] to i64
; CHECK-NEXT:    ret i64 [[EXT]]
;
  br i1 %c.1, label %true.1, label %false

true.1:
  br i1 %c.2, label %true.2, label %exit

true.2:
  br label %exit

false:
  br label %exit

exit:
  %p = phi i32 [ 0, %true.1 ], [ 1, %true.2], [ undef, %false ]
  %ext = sext i32 %p to i64
  ret i64 %ext
}

define i64 @test5(i32 %x) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[P:%.*]] = and i32 [[X:%.*]], 15
; CHECK-NEXT:    [[EXT:%.*]] = sext i32 [[P]] to i64
; CHECK-NEXT:    ret i64 [[EXT]]
;
  %p = and i32 %x, 15
  %ext = sext i32 %p to i64
  ret i64 %ext
}
