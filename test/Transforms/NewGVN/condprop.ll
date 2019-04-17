; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -newgvn -S | FileCheck %s


declare void @foo(i1)
declare void @bar(i32)

define void @test3(i32 %x, i32 %y) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[XZ:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[YZ:%.*]] = icmp eq i32 [[Y:%.*]], 0
; CHECK-NEXT:    [[Z:%.*]] = and i1 [[XZ]], [[YZ]]
; CHECK-NEXT:    br i1 [[Z]], label [[BOTH_ZERO:%.*]], label [[NOPE:%.*]]
; CHECK:       both_zero:
; CHECK-NEXT:    call void @foo(i1 true)
; CHECK-NEXT:    call void @foo(i1 true)
; CHECK-NEXT:    call void @bar(i32 0)
; CHECK-NEXT:    call void @bar(i32 0)
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @foo(i1 false)
; CHECK-NEXT:    ret void
;
  %xz = icmp eq i32 %x, 0
  %yz = icmp eq i32 %y, 0
  %z = and i1 %xz, %yz
  br i1 %z, label %both_zero, label %nope
both_zero:
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  ret void
nope:
  call void @foo(i1 %z)
  ret void
}
define void @test4(i1 %b, i32 %x) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    br i1 [[B:%.*]], label [[SW:%.*]], label [[CASE3:%.*]]
; CHECK:       sw:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[CASE0:%.*]]
; CHECK-NEXT:    i32 1, label [[CASE1:%.*]]
; CHECK-NEXT:    i32 2, label [[CASE0]]
; CHECK-NEXT:    i32 3, label [[CASE3]]
; CHECK-NEXT:    i32 4, label [[DEFAULT]]
; CHECK-NEXT:    ]
; CHECK:       default:
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    ret void
; CHECK:       case0:
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    ret void
; CHECK:       case1:
; CHECK-NEXT:    call void @bar(i32 1)
; CHECK-NEXT:    ret void
; CHECK:       case3:
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    ret void
;
  br i1 %b, label %sw, label %case3
sw:
  switch i32 %x, label %default [
  i32 0, label %case0
  i32 1, label %case1
  i32 2, label %case0
  i32 3, label %case3
  i32 4, label %default
  ]
default:
  call void @bar(i32 %x)
  ret void
case0:
  call void @bar(i32 %x)
  ret void
case1:
  call void @bar(i32 %x)
  ret void
case3:
  call void @bar(i32 %x)
  ret void
}

define i1 @test5(i32 %x, i32 %y) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[SAME:%.*]], label [[DIFFERENT:%.*]]
; CHECK:       same:
; CHECK-NEXT:    ret i1 false
; CHECK:       different:
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp eq i32 %x, %y
  br i1 %cmp, label %same, label %different

same:
  %cmp2 = icmp ne i32 %x, %y
  ret i1 %cmp2

different:
  %cmp3 = icmp eq i32 %x, %y
  ret i1 %cmp3
}


define i1 @test7(i32 %x, i32 %y) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[SAME:%.*]], label [[DIFFERENT:%.*]]
; CHECK:       same:
; CHECK-NEXT:    ret i1 false
; CHECK:       different:
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp sgt i32 %x, %y
  br i1 %cmp, label %same, label %different

same:
  %cmp2 = icmp sle i32 %x, %y
  ret i1 %cmp2

different:
  %cmp3 = icmp sgt i32 %x, %y
  ret i1 %cmp3
}

define i1 @test7_fp(float %x, float %y) {
; CHECK-LABEL: @test7_fp(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[SAME:%.*]], label [[DIFFERENT:%.*]]
; CHECK:       same:
; CHECK-NEXT:    ret i1 false
; CHECK:       different:
; CHECK-NEXT:    ret i1 false
;
  %cmp = fcmp ogt float %x, %y
  br i1 %cmp, label %same, label %different

same:
  %cmp2 = fcmp ule float %x, %y
  ret i1 %cmp2

different:
  %cmp3 = fcmp ogt float %x, %y
  ret i1 %cmp3
}

; PR1768
define i32 @test9(i32 %i, i32 %j) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[I:%.*]], [[J:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[RET:%.*]]
; CHECK:       cond_true:
; CHECK-NEXT:    ret i32 0
; CHECK:       ret:
; CHECK-NEXT:    ret i32 5
;
  %cmp = icmp eq i32 %i, %j
  br i1 %cmp, label %cond_true, label %ret

cond_true:
  %diff = sub i32 %i, %j
  ret i32 %diff

ret:
  ret i32 5
}

; PR1768
define i32 @test10(i32 %j, i32 %i) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[I:%.*]], [[J:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[RET:%.*]]
; CHECK:       cond_true:
; CHECK-NEXT:    ret i32 0
; CHECK:       ret:
; CHECK-NEXT:    ret i32 5
;
  %cmp = icmp eq i32 %i, %j
  br i1 %cmp, label %cond_true, label %ret

cond_true:
  %diff = sub i32 %i, %j
  ret i32 %diff

ret:
  ret i32 5
}

declare i32 @yogibar()

define i32 @test11(i32 %x) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[V0:%.*]] = call i32 @yogibar()
; CHECK-NEXT:    [[V1:%.*]] = call i32 @yogibar()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[V0]], [[V1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[NEXT:%.*]]
; CHECK:       cond_true:
; CHECK-NEXT:    ret i32 [[V0]]
; CHECK:       next:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[X:%.*]], [[V0]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[COND_TRUE2:%.*]], label [[NEXT2:%.*]]
; CHECK:       cond_true2:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       next2:
; CHECK-NEXT:    ret i32 0
;
  %v0 = call i32 @yogibar()
  %v1 = call i32 @yogibar()
  %cmp = icmp eq i32 %v0, %v1
  br i1 %cmp, label %cond_true, label %next

cond_true:
  ret i32 %v1

next:
  %cmp2 = icmp eq i32 %x, %v0
  br i1 %cmp2, label %cond_true2, label %next2

cond_true2:
  ret i32 %v0

next2:
  ret i32 0
}

define i32 @test12(i32 %x) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond_true:
; CHECK-NEXT:    br label [[RET:%.*]]
; CHECK:       cond_false:
; CHECK-NEXT:    br label [[RET]]
; CHECK:       ret:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ 0, [[COND_TRUE]] ], [ [[X]], [[COND_FALSE]] ]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %cmp = icmp eq i32 %x, 0
  br i1 %cmp, label %cond_true, label %cond_false

cond_true:
  br label %ret

cond_false:
  br label %ret

ret:
  %res = phi i32 [ %x, %cond_true ], [ %x, %cond_false ]
  ret i32 %res
}
