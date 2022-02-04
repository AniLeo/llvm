; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare void @use(i32)

define i32 @test1(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 [[SUB]], i32 [[Y:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[COND]], [[X]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %sub = sub i32 0, %x
  %cond = select i1 %c, i32 %sub, i32 %y
  %add = add i32 %cond, %x
  ret i32 %add
}

define i32 @test2(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 [[SUB]], i32 [[X]]
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[COND]], [[X]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %sub = sub i32 0, %x
  %cond = select i1 %c, i32 %sub, i32 %x
  %add = add i32 %cond, %x
  ret i32 %add
}

define i32 @test3(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 [[SUB]], i32 1
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[COND]], [[X]]
; CHECK-NEXT:    ret i32 [[MUL]]
;
entry:
  %sub = sub i32 0, %x
  %cond = select i1 %c, i32 %sub, i32 1
  %mul = mul i32 %cond, %x
  ret i32 %mul
}

define i32 @test4(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 [[SUB]], i32 1
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[COND]], [[X]]
; CHECK-NEXT:    ret i32 [[MUL]]
;
entry:
  %sub = sub i32 0, %x
  %cond = select i1 %c, i32 %sub, i32 1
  %mul = mul i32 %cond, %x
  ret i32 %mul
}

define i32 @test5(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 [[X:%.*]], i32 0
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[COND]], [[X]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %cond = select i1 %c, i32 %x, i32 0
  %add = add i32 %cond, %x
  ret i32 %add
}

define i32 @test6(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 7, i32 [[X:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[COND]], [[X]]
; CHECK-NEXT:    ret i32 [[AND]]
;
entry:
  %cond = select i1 %c, i32 7, i32 %x
  %and = and i32 %cond, %x
  ret i32 %and
}

define i32 @test7(i1 %c, i32 %x) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 [[X]], i32 [[SUB]]
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[X]], [[COND]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
entry:
  %sub = sub i32 0, %x
  %cond = select i1 %c, i32 %x, i32 %sub
  %div = sdiv i32 %x, %cond
  ret i32 %div
}


define i32 @test8(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 7, i32 [[Y:%.*]]
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 42, [[COND]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
entry:
  %cond = select i1 %c, i32 7, i32 %y
  %div = sdiv i32 42, %cond
  ret i32 %div
}

define i32 @test9(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 1, i32 [[X:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[COND]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
entry:
  %cond = select i1 %c, i32 1, i32 %x
  %sub = sub nsw i32 0, %cond
  ret i32 %sub
}

define i32 @test10(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 7, i32 [[Y:%.*]]
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 42, [[COND]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
entry:
  %cond = select i1 %c, i32 7, i32 %y
  %div = udiv i32 42, %cond
  ret i32 %div
}

define i32 @test11(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 7, i32 [[Y:%.*]]
; CHECK-NEXT:    [[DIV:%.*]] = srem i32 42, [[COND]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
entry:
  %cond = select i1 %c, i32 7, i32 %y
  %div = srem i32 42, %cond
  ret i32 %div
}

define i32 @test12(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 7, i32 [[Y:%.*]]
; CHECK-NEXT:    [[DIV:%.*]] = urem i32 42, [[COND]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
entry:
  %cond = select i1 %c, i32 7, i32 %y
  %div = urem i32 42, %cond
  ret i32 %div
}

define i32 @extra_use(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: @extra_use(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 1, i32 [[X:%.*]]
; CHECK-NEXT:    tail call void @use(i32 [[COND]])
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[COND]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
entry:
  %cond = select i1 %c, i32 1, i32 %x
  tail call void @use(i32 %cond)
  %sub = sub nsw i32 0, %cond
  ret i32 %sub
}


define i32 @extra_use2(i1 %c, i32 %x) {
; CHECK-LABEL: @extra_use2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[C:%.*]], i32 [[X]], i32 [[SUB]]
; CHECK-NEXT:    tail call void @use(i32 [[COND]])
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[COND]], [[X]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
entry:
  %sub = sub i32 0, %x
  %cond = select i1 %c, i32 %x, i32 %sub
  tail call void @use(i32 %cond)
  %div = sdiv i32 %cond, %x
  ret i32 %div
}
