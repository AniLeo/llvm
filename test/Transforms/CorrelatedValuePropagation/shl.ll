; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=correlated-propagation -S | FileCheck %s

define i8 @test0(i8 %a, i8 %b) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i8 [[SHL]]
;
  %shl = shl i8 %a, %b
  ret i8 %shl
}

define i8 @test1(i8 %a, i8 %b) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 [[A:%.*]], [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 8
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 %a, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test2(i8 %a, i8 %b) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 9
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 [[A:%.*]], [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 9
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 %a, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test3(i8 %a, i8 %b) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[B:%.*]], 6
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 [[A:%.*]], [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ugt i8 %b, 6
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 %a, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test4(i8 %a, i8 %b) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[B:%.*]], 7
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw nsw i8 [[A:%.*]], [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ugt i8 %b, 7
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 %a, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test5(i8 %b) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw nsw i8 0, [[B:%.*]]
; CHECK-NEXT:    ret i8 [[SHL]]
;
  %shl = shl i8 0, %b
  ret i8 %shl
}

define i8 @test6(i8 %b) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i8 1, [[B:%.*]]
; CHECK-NEXT:    ret i8 [[SHL]]
;
  %shl = shl i8 1, %b
  ret i8 %shl
}

define i8 @test7(i8 %b) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 7
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw nsw i8 1, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 7
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 1, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test8(i8 %b) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[SHL:%.*]] = shl nsw i8 -1, [[B:%.*]]
; CHECK-NEXT:    ret i8 [[SHL]]
;
  %shl = shl i8 -1, %b
  ret i8 %shl
}

define i8 @test9(i8 %b) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw nsw i8 -1, [[B]]
; CHECK-NEXT:    ret i8 -1
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp eq i8 %b, 0
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 -1, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test10(i8 %b) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 42, [[B:%.*]]
; CHECK-NEXT:    ret i8 [[SHL]]
;
  %shl = shl i8 42, %b
  ret i8 %shl
}

define i8 @test11(i8 %b) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 2
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw nsw i8 42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 2
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test12(i8 %b) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 3
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i8 42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 3
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test13(i8 %b) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 4
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 4
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test14(i8 %b) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 -42, [[B:%.*]]
; CHECK-NEXT:    ret i8 [[SHL]]
;
  %shl = shl i8 -42, %b
  ret i8 %shl
}

define i8 @test15(i8 %b) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 2
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nsw i8 -42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 2
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 -42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test16(i8 %b) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[B:%.*]], 3
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 -42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp ult i8 %b, 3
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 -42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test17(i8 %b) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[B:%.*]], 2
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw nsw i8 42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp slt i8 %b, 2
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test18(i8 %b) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[B:%.*]], 3
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i8 42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp slt i8 %b, 3
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i8 @test19(i8 %b) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[B:%.*]], 4
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 42, [[B]]
; CHECK-NEXT:    ret i8 [[SHL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry:
  %cmp = icmp slt i8 %b, 4
  br i1 %cmp, label %bb, label %exit

bb:
  %shl = shl i8 42, %b
  ret i8 %shl

exit:
  ret i8 0
}

define i1 @nuw_range1(i8 %b) {
; CHECK-LABEL: @nuw_range1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add nuw nsw i8 [[B:%.*]], 1
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i8 [[C]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[SHL]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %c = add nuw nsw i8 %b, 1
  %shl = shl nuw i8 %c, 2
  %cmp = icmp eq i8 %shl, 0
  ret i1 %cmp
}

define i1 @nuw_range2(i8 %b) {
; CHECK-LABEL: @nuw_range2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add nuw nsw i8 [[B:%.*]], 3
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i8 [[C]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[SHL]], 2
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %c = add nuw nsw i8 %b, 3
  %shl = shl nuw i8 %c, 2
  %cmp = icmp ult i8 %shl, 2
  ret i1 %cmp
}

define i1 @nsw_range1(i8 %b) {
; CHECK-LABEL: @nsw_range1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add nuw nsw i8 [[B:%.*]], -3
; CHECK-NEXT:    [[SHL:%.*]] = shl nsw i8 [[C]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[C]], [[SHL]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %c = add nuw nsw i8 %b, -3
  %shl = shl nsw i8 %c, 2
  %cmp = icmp slt i8 %c, %shl
  ret i1 %cmp
}
