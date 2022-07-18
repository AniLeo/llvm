; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg < %s | FileCheck %s

declare void @foo()
declare void @bar()
declare void @use.i1(i1)
declare void @use.i32(i32)

define void @test_phi_simple(i1 %c) {
; CHECK-LABEL: @test_phi_simple(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  %c2 = phi i1 [ true, %if ], [ false, %else ]
  br i1 %c2, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_phi_extra_use(i1 %c) {
; CHECK-LABEL: @test_phi_extra_use(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    call void @use.i1(i1 true)
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @use.i1(i1 false)
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  %c2 = phi i1 [ true, %if ], [ false, %else ]
  call void @use.i1(i1 %c2)
  br i1 %c2, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_phi_extra_use_different_block(i1 %c) {
; CHECK-LABEL: @test_phi_extra_use_different_block(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[C2:%.*]] = phi i1 [ true, [[IF]] ], [ false, [[ELSE]] ]
; CHECK-NEXT:    br i1 [[C2]], label [[IF2:%.*]], label [[ELSE2:%.*]]
; CHECK:       if2:
; CHECK-NEXT:    call void @use.i1(i1 [[C2]])
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else2:
; CHECK-NEXT:    call void @use.i1(i1 [[C2]])
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  %c2 = phi i1 [ true, %if ], [ false, %else ]
  br i1 %c2, label %if2, label %else2

if2:
  call void @use.i1(i1 %c2)
  call void @foo()
  br label %join2

else2:
  call void @use.i1(i1 %c2)
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_same_cond_simple(i1 %c) {
; CHECK-LABEL: @test_same_cond_simple(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    br i1 [[C]], label [[IF2:%.*]], label [[ELSE2:%.*]]
; CHECK:       if2:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else2:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  br i1 %c, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_same_cond_extra_use(i1 %c) {
; CHECK-LABEL: @test_same_cond_extra_use(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    call void @use.i1(i1 [[C]])
; CHECK-NEXT:    br i1 [[C]], label [[IF2:%.*]], label [[ELSE2:%.*]]
; CHECK:       if2:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else2:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  call void @use.i1(i1 %c)
  br i1 %c, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_same_cond_extra_use_different_block(i1 %c) {
; CHECK-LABEL: @test_same_cond_extra_use_different_block(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    br i1 [[C]], label [[IF2:%.*]], label [[ELSE2:%.*]]
; CHECK:       if2:
; CHECK-NEXT:    call void @use.i1(i1 [[C]])
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else2:
; CHECK-NEXT:    call void @use.i1(i1 [[C]])
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  br i1 %c, label %if2, label %else2

if2:
  call void @use.i1(i1 %c)
  call void @foo()
  br label %join2

else2:
  call void @use.i1(i1 %c)
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_multiple_threadable_preds_with_phi(i1 %cond1, i1 %cond2) {
; CHECK-LABEL: @test_multiple_threadable_preds_with_phi(
; CHECK-NEXT:    br i1 [[COND1:%.*]], label [[IF1:%.*]], label [[IF2:%.*]]
; CHECK:       if1:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br i1 [[COND2:%.*]], label [[IF3_CRITEDGE:%.*]], label [[EXIT:%.*]]
; CHECK:       if2:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br i1 [[COND2]], label [[IF3_CRITEDGE]], label [[EXIT]]
; CHECK:       if3.critedge:
; CHECK-NEXT:    [[PHI_PH:%.*]] = phi i32 [ 2, [[IF2]] ], [ 1, [[IF1]] ]
; CHECK-NEXT:    call void @use.i32(i32 [[PHI_PH]])
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br i1 %cond1, label %if1, label %if2

if1:
  call void @foo()
  br i1 %cond2, label %join, label %exit

if2:
  call void @bar()
  br i1 %cond2, label %join, label %exit

join:
  %phi = phi i32 [ 1, %if1 ], [ 2, %if2 ]
  call void @use.i32(i32 %phi)
  br i1 %cond2, label %if3, label %exit

if3:
  call void @foo()
  br label %exit

exit:
  ret void
}

; This test case used to infinite loop.

define void @infloop(i1 %cmp.a, i1 %cmp.b, i1 %cmp.c) {
; CHECK-LABEL: @infloop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br i1 [[CMP_A:%.*]], label [[FOR:%.*]], label [[WHILE_BODY_THREAD:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 [[CMP_B:%.*]], label [[WHILE_BODY:%.*]], label [[FOR_BODY:%.*]]
; CHECK:       for:
; CHECK-NEXT:    tail call void @foo()
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       while.body:
; CHECK-NEXT:    br i1 [[CMP_C:%.*]], label [[C_EXIT:%.*]], label [[LAND:%.*]]
; CHECK:       while.body.thread:
; CHECK-NEXT:    br i1 [[CMP_C]], label [[WHILE_COND]], label [[LAND]]
; CHECK:       land:
; CHECK-NEXT:    tail call void @bar()
; CHECK-NEXT:    br label [[WHILE_COND]]
; CHECK:       c.exit:
; CHECK-NEXT:    br i1 [[CMP_A]], label [[FOR_D:%.*]], label [[WHILE_BODY_THREAD]]
; CHECK:       for.d:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond

while.cond:                                       ; preds = %land, %while.body.thread, %entry
  br i1 %cmp.a, label %for, label %while.body.thread

for.body:                                         ; preds = %for, %for.body
  br i1 %cmp.b, label %while.body, label %for.body

for:                                              ; preds = %while.cond
  tail call void @foo()
  br label %for.body

while.body:                                       ; preds = %for.body
  br i1 %cmp.c, label %c.exit, label %land

while.body.thread:                                ; preds = %c.exit, %while.cond
  br i1 %cmp.c, label %while.cond, label %land

land:                                             ; preds = %while.body.thread, %while.body
  tail call void @bar()
  br label %while.cond

c.exit:                                           ; preds = %while.body
  br i1 %cmp.a, label %for.d, label %while.cond

for.d:                                            ; preds = %c.exit
  ret void
}

; A combination of "branch to common dest" and jump threading kept peeling
; off loop iterations here.

define void @infloop_pr56203(i1 %c1, i1 %c2) {
; CHECK-LABEL: @infloop_pr56203(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[EXIT:%.*]], label [[IF:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i64 0, 0
; CHECK-NEXT:    [[OR_COND:%.*]] = or i1 [[C2:%.*]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[EXIT]], label [[LOOP_SPLIT:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i64 0, 0
; CHECK-NEXT:    br i1 [[C3_OLD]], label [[EXIT]], label [[LOOP_SPLIT]]
; CHECK:       loop.split:
; CHECK-NEXT:    br i1 [[C1]], label [[LOOP_LATCH:%.*]], label [[LOOP:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 %c1, label %exit, label %if

if:
  call void @foo()
  br i1 %c2, label %exit, label %loop

loop:
  %c3 = icmp eq i64 0, 0
  br i1 %c3, label %exit, label %loop.split

loop.split:
  br i1 %c1, label %loop.latch, label %loop

loop.latch:
  call void @foo()
  br label %loop

exit:
  ret void
}

define void @callbr() {
; CHECK-LABEL: @callbr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    callbr void asm sideeffect "", "!i,~{dirflag},~{fpsr},~{flags}"()
; CHECK-NEXT:    to label [[IF_END:%.*]] [label %if.end]
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:
  callbr void asm sideeffect "", "!i,~{dirflag},~{fpsr},~{flags}"()
  to label %join [label %target]

target:
  br label %join

join:
  %phi = phi i1 [ false, %target ], [ false, %entry ]
  br i1 %phi, label %if.then, label %if.end

if.then:
  call void @foo()
  br label %if.end

if.end:
  ret void
}
