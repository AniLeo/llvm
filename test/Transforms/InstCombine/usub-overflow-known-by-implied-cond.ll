; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt -passes=instcombine -S %s | FileCheck %s

declare { i32, i1 } @llvm.usub.with.overflow.i32(i32, i32)

define i32 @test1(i32 %a, i32 %b) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[COND_NOT:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND_NOT]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB2:%.*]], label [[BB3]]
; CHECK:       bb2:
; CHECK-NEXT:    ret i32 poison
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp uge i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb2, label %bb3

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test2(i32 %a, i32 %b) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[COND_NOT:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND_NOT]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[SUB1:%.*]] = sub nuw i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[SUB1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp uge i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}


define i32 @test3(i32 %a, i32 %b) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB2:%.*]], label [[BB3]]
; CHECK:       bb2:
; CHECK-NEXT:    ret i32 poison
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb2, label %bb3

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test4(i32 %a, i32 %b) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[SUB1:%.*]] = sub nuw i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[SUB1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}


define i32 @test5(i32 %a, i32 %b) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[SUB1:%.*]] = sub nuw i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[SUB1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp eq i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test6(i32 %a, i32 %b) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 true, label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret i32 poison
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ult i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test7(i32 %a, i32 %b) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp slt i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test8(i32 %a, i32 %b) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[COND_NOT:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND_NOT]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ne i32 %a, %b
  br i1 %cond, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test9(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[COND]], [[COND2:%.*]]
; CHECK-NEXT:    br i1 [[AND]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[SUB1:%.*]] = sub nuw i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[SUB1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %and = and i1 %cond, %cond2
  br i1 %and, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test9_logical(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test9_logical(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[COND]], i1 [[COND2:%.*]], i1 false
; CHECK-NEXT:    br i1 [[AND]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[SUB1:%.*]] = sub nuw i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[SUB1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %and = select i1 %cond, i1 %cond2, i1 false
  br i1 %and, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test10(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[COND]], [[COND2:%.*]]
; CHECK-NEXT:    br i1 [[AND]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %and = and i1 %cond, %cond2
  br i1 %and, label %bb3, label %bb1

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test10_logical(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test10_logical(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[COND]], i1 [[COND2:%.*]], i1 false
; CHECK-NEXT:    br i1 [[AND]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %and = select i1 %cond, i1 %cond2, i1 false
  br i1 %and, label %bb3, label %bb1

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test11(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[COND]], [[COND2:%.*]]
; CHECK-NEXT:    br i1 [[OR]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %or = or i1 %cond, %cond2
  br i1 %or, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test11_logical(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test11_logical(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[COND]], i1 true, i1 [[COND2:%.*]]
; CHECK-NEXT:    br i1 [[OR]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %or = select i1 %cond, i1 true, i1 %cond2
  br i1 %or, label %bb1, label %bb3

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test12(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[COND]], [[COND2:%.*]]
; CHECK-NEXT:    br i1 [[OR]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %or = or i1 %cond, %cond2
  br i1 %or, label %bb3, label %bb1

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}

define i32 @test12_logical(i32 %a, i32 %b, i1 %cond2) {
; CHECK-LABEL: @test12_logical(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[COND]], i1 true, i1 [[COND2:%.*]]
; CHECK-NEXT:    br i1 [[OR]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[SUB1:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[C1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R1:%.*]] = extractvalue { i32, i1 } [[SUB1]], 0
; CHECK-NEXT:    ret i32 [[R1]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i32 %a, %b
  %or = select i1 %cond, i1 true, i1 %cond2
  br i1 %or, label %bb3, label %bb1

bb1:
  %sub1 = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %a, i32 %b)
  %r1 = extractvalue { i32, i1 } %sub1, 0
  %c1 = extractvalue { i32, i1 } %sub1, 1
  br i1 %c1, label %bb3, label %bb2

bb2:
  ret i32 %r1

bb3:
  ret i32 0
}
