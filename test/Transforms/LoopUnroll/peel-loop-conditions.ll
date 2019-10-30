; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -loop-unroll -verify-dom-info | FileCheck %s

declare void @f1()
declare void @f2()

; Check that we can peel off iterations that make conditions true.
define void @test1(i32 %k) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; CHECK:       for.body.peel.begin:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; CHECK:       for.body.peel:
; CHECK-NEXT:    [[CMP1_PEEL:%.*]] = icmp ult i32 0, 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL]], label [[IF_THEN_PEEL:%.*]], label [[IF_ELSE_PEEL:%.*]]
; CHECK:       if.else.peel:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC_PEEL:%.*]]
; CHECK:       if.then.peel:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL]]
; CHECK:       for.inc.peel:
; CHECK-NEXT:    [[INC_PEEL:%.*]] = add nsw i32 0, 1
; CHECK-NEXT:    [[CMP_PEEL:%.*]] = icmp slt i32 [[INC_PEEL]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PEEL]], label [[FOR_BODY_PEEL_NEXT:%.*]], label [[FOR_END:%[^,]*]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL2:%.*]]
; CHECK:       for.body.peel2:
; CHECK-NEXT:    [[CMP1_PEEL3:%.*]] = icmp ult i32 [[INC_PEEL]], 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL3]], label [[IF_THEN_PEEL5:%.*]], label [[IF_ELSE_PEEL4:%.*]]
; CHECK:       if.else.peel4:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC_PEEL6:%.*]]
; CHECK:       if.then.peel5:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL6]]
; CHECK:       for.inc.peel6:
; CHECK-NEXT:    [[INC_PEEL7:%.*]] = add nsw i32 [[INC_PEEL]], 1
; CHECK-NEXT:    [[CMP_PEEL8:%.*]] = icmp slt i32 [[INC_PEEL7]], [[K]]
; CHECK-NEXT:    br i1 [[CMP_PEEL8]], label [[FOR_BODY_PEEL_NEXT1:%.*]], label [[FOR_END]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next1:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_NEXT9:%.*]]
; CHECK:       for.body.peel.next9:
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH_PEEL_NEWPH:%.*]]
; CHECK:       for.body.lr.ph.peel.newph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ [[INC_PEEL7]], [[FOR_BODY_LR_PH_PEEL_NEWPH]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    br i1 false, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]], !llvm.loop !{{.*}}
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  %cmp1 = icmp ult i32 %i.05, 2
  br i1 %cmp1, label %if.then, label %if.else

if.then:
  call void @f1()
  br label %for.inc

if.else:
  call void @f2()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !1

for.end:
  ret void
}

!1 = distinct !{!1}

; Check we peel off the maximum number of iterations that make conditions true.
define void @test2(i32 %k) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; CHECK:       for.body.peel.begin:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; CHECK:       for.body.peel:
; CHECK-NEXT:    [[CMP1_PEEL:%.*]] = icmp ult i32 0, 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL]], label [[IF_THEN_PEEL:%.*]], label [[IF_ELSE_PEEL:%.*]]
; CHECK:       if.else.peel:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[IF2_PEEL:%.*]]
; CHECK:       if.then.peel:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[IF2_PEEL]]
; CHECK:       if2.peel:
; CHECK-NEXT:    [[CMP2_PEEL:%.*]] = icmp ult i32 0, 4
; CHECK-NEXT:    br i1 [[CMP2_PEEL]], label [[IF_THEN2_PEEL:%.*]], label [[FOR_INC_PEEL:%.*]]
; CHECK:       if.then2.peel:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL]]
; CHECK:       for.inc.peel:
; CHECK-NEXT:    [[INC_PEEL:%.*]] = add nsw i32 0, 1
; CHECK-NEXT:    [[CMP_PEEL:%.*]] = icmp slt i32 [[INC_PEEL]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PEEL]], label [[FOR_BODY_PEEL_NEXT:%.*]], label [[FOR_END:%[^,]*]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL2:%.*]]
; CHECK:       for.body.peel2:
; CHECK-NEXT:    [[CMP1_PEEL3:%.*]] = icmp ult i32 [[INC_PEEL]], 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL3]], label [[IF_THEN_PEEL5:%.*]], label [[IF_ELSE_PEEL4:%.*]]
; CHECK:       if.else.peel4:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[IF2_PEEL6:%.*]]
; CHECK:       if.then.peel5:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[IF2_PEEL6]]
; CHECK:       if2.peel6:
; CHECK-NEXT:    [[CMP2_PEEL7:%.*]] = icmp ult i32 [[INC_PEEL]], 4
; CHECK-NEXT:    br i1 [[CMP2_PEEL7]], label [[IF_THEN2_PEEL8:%.*]], label [[FOR_INC_PEEL9:%.*]]
; CHECK:       if.then2.peel8:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL9]]
; CHECK:       for.inc.peel9:
; CHECK-NEXT:    [[INC_PEEL10:%.*]] = add nsw i32 [[INC_PEEL]], 1
; CHECK-NEXT:    [[CMP_PEEL11:%.*]] = icmp slt i32 [[INC_PEEL10]], [[K]]
; CHECK-NEXT:    br i1 [[CMP_PEEL11]], label [[FOR_BODY_PEEL_NEXT1:%.*]], label [[FOR_END]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next1:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL13:%.*]]
; CHECK:       for.body.peel13:
; CHECK-NEXT:    [[CMP1_PEEL14:%.*]] = icmp ult i32 [[INC_PEEL10]], 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL14]], label [[IF_THEN_PEEL16:%.*]], label [[IF_ELSE_PEEL15:%.*]]
; CHECK:       if.else.peel15:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[IF2_PEEL17:%.*]]
; CHECK:       if.then.peel16:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[IF2_PEEL17]]
; CHECK:       if2.peel17:
; CHECK-NEXT:    [[CMP2_PEEL18:%.*]] = icmp ult i32 [[INC_PEEL10]], 4
; CHECK-NEXT:    br i1 [[CMP2_PEEL18]], label [[IF_THEN2_PEEL19:%.*]], label [[FOR_INC_PEEL20:%.*]]
; CHECK:       if.then2.peel19:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL20]]
; CHECK:       for.inc.peel20:
; CHECK-NEXT:    [[INC_PEEL21:%.*]] = add nsw i32 [[INC_PEEL10]], 1
; CHECK-NEXT:    [[CMP_PEEL22:%.*]] = icmp slt i32 [[INC_PEEL21]], [[K]]
; CHECK-NEXT:    br i1 [[CMP_PEEL22]], label [[FOR_BODY_PEEL_NEXT12:%.*]], label [[FOR_END]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next12:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL24:%.*]]
; CHECK:       for.body.peel24:
; CHECK-NEXT:    [[CMP1_PEEL25:%.*]] = icmp ult i32 [[INC_PEEL21]], 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL25]], label [[IF_THEN_PEEL27:%.*]], label [[IF_ELSE_PEEL26:%.*]]
; CHECK:       if.else.peel26:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[IF2_PEEL28:%.*]]
; CHECK:       if.then.peel27:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[IF2_PEEL28]]
; CHECK:       if2.peel28:
; CHECK-NEXT:    [[CMP2_PEEL29:%.*]] = icmp ult i32 [[INC_PEEL21]], 4
; CHECK-NEXT:    br i1 [[CMP2_PEEL29]], label [[IF_THEN2_PEEL30:%.*]], label [[FOR_INC_PEEL31:%.*]]
; CHECK:       if.then2.peel30:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL31]]
; CHECK:       for.inc.peel31:
; CHECK-NEXT:    [[INC_PEEL32:%.*]] = add nsw i32 [[INC_PEEL21]], 1
; CHECK-NEXT:    [[CMP_PEEL33:%.*]] = icmp slt i32 [[INC_PEEL32]], [[K]]
; CHECK-NEXT:    br i1 [[CMP_PEEL33]], label [[FOR_BODY_PEEL_NEXT23:%.*]], label [[FOR_END]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next23:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_NEXT34:%.*]]
; CHECK:       for.body.peel.next34:
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH_PEEL_NEWPH:%.*]]
; CHECK:       for.body.lr.ph.peel.newph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ [[INC_PEEL32]], [[FOR_BODY_LR_PH_PEEL_NEWPH]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    br i1 false, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[IF2:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[IF2]]
; CHECK:       if2:
; CHECK-NEXT:    br i1 false, label [[IF_THEN2:%.*]], label [[FOR_INC]]
; CHECK:       if.then2:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]], !llvm.loop !{{.*}}
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  %cmp1 = icmp ult i32 %i.05, 2
  br i1 %cmp1, label %if.then, label %if.else

if.then:
  call void @f1()
  br label %if2

if.else:
  call void @f2()
  br label %if2

if2:
  %cmp2 = icmp ult i32 %i.05, 4
  br i1 %cmp2, label %if.then2, label %for.inc

if.then2:
  call void @f1()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !2

for.end:
  ret void
}

!2 = distinct !{!2}

; Check that we can peel off iterations that make a condition false.
define void @test3(i32 %k) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; CHECK:       for.body.peel.begin:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; CHECK:       for.body.peel:
; CHECK-NEXT:    [[CMP1_PEEL:%.*]] = icmp ugt i32 0, 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL]], label [[IF_THEN_PEEL:%.*]], label [[IF_ELSE_PEEL:%.*]]
; CHECK:       if.else.peel:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC_PEEL:%.*]]
; CHECK:       if.then.peel:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL]]
; CHECK:       for.inc.peel:
; CHECK-NEXT:    [[INC_PEEL:%.*]] = add nsw i32 0, 1
; CHECK-NEXT:    [[CMP_PEEL:%.*]] = icmp slt i32 [[INC_PEEL]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PEEL]], label [[FOR_BODY_PEEL_NEXT:%.*]], label [[FOR_END:%[^,]*]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL2:%.*]]
; CHECK:       for.body.peel2:
; CHECK-NEXT:    [[CMP1_PEEL3:%.*]] = icmp ugt i32 [[INC_PEEL]], 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL3]], label [[IF_THEN_PEEL5:%.*]], label [[IF_ELSE_PEEL4:%.*]]
; CHECK:       if.else.peel4:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC_PEEL6:%.*]]
; CHECK:       if.then.peel5:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL6]]
; CHECK:       for.inc.peel6:
; CHECK-NEXT:    [[INC_PEEL7:%.*]] = add nsw i32 [[INC_PEEL]], 1
; CHECK-NEXT:    [[CMP_PEEL8:%.*]] = icmp slt i32 [[INC_PEEL7]], [[K]]
; CHECK-NEXT:    br i1 [[CMP_PEEL8]], label [[FOR_BODY_PEEL_NEXT1:%.*]], label [[FOR_END]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next1:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL10:%.*]]
; CHECK:       for.body.peel10:
; CHECK-NEXT:    [[CMP1_PEEL11:%.*]] = icmp ugt i32 [[INC_PEEL7]], 2
; CHECK-NEXT:    br i1 [[CMP1_PEEL11]], label [[IF_THEN_PEEL13:%.*]], label [[IF_ELSE_PEEL12:%.*]]
; CHECK:       if.else.peel12:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC_PEEL14:%.*]]
; CHECK:       if.then.peel13:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC_PEEL14]]
; CHECK:       for.inc.peel14:
; CHECK-NEXT:    [[INC_PEEL15:%.*]] = add nsw i32 [[INC_PEEL7]], 1
; CHECK-NEXT:    [[CMP_PEEL16:%.*]] = icmp slt i32 [[INC_PEEL15]], [[K]]
; CHECK-NEXT:    br i1 [[CMP_PEEL16]], label [[FOR_BODY_PEEL_NEXT9:%.*]], label [[FOR_END]]
; Verify that MD_loop metadata is dropped.
; CHECK-NOT:   , !llvm.loop !{{[0-9]*}}
; CHECK:       for.body.peel.next9:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_NEXT17:%.*]]
; CHECK:       for.body.peel.next17:
; CHECK-NEXT:    br label [[FOR_BODY_LR_PH_PEEL_NEWPH:%.*]]
; CHECK:       for.body.lr.ph.peel.newph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ [[INC_PEEL15]], [[FOR_BODY_LR_PH_PEEL_NEWPH]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    br i1 true, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]], !llvm.loop !{{.*}}
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  %cmp1 = icmp ugt i32 %i.05, 2
  br i1 %cmp1, label %if.then, label %if.else

if.then:
  call void @f1()
  br label %for.inc

if.else:
  call void @f2()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end, !llvm.loop !3

for.end:
  ret void
}

!3 = distinct !{!3}

; Test that we only peel off iterations if it simplifies a condition in the
; loop body after peeling at most MaxPeelCount iterations.
define void @test4(i32 %k) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH:%.*]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[I_05]], 9999
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  %cmp1 = icmp ugt i32 %i.05, 9999
  br i1 %cmp1, label %if.then, label %for.inc

if.then:
  call void @f1()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret void
}

; In this case we cannot peel the inner loop, because the condition involves
; the outer induction variable.
define void @test5(i32 %k) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH:%.*]] ], [ [[J_INC:%.*]], [[OUTER_INC:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ 0, [[OUTER_HEADER]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[J]], 2
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[OUTER_INC]]
; CHECK:       outer.inc:
; CHECK-NEXT:    [[J_INC]] = add nsw i32 [[J]], 1
; CHECK-NEXT:    [[OUTER_CMP:%.*]] = icmp slt i32 [[J_INC]], [[K]]
; CHECK-NEXT:    br i1 [[OUTER_CMP]], label [[OUTER_HEADER]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %outer.header

outer.header:
  %j = phi i32 [ 0, %for.body.lr.ph ], [ %j.inc, %outer.inc ]
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %outer.header ], [ %inc, %for.inc ]
  %cmp1 = icmp ult i32 %j, 2
  br i1 %cmp1, label %if.then, label %if.else

if.then:
  call void @f1()
  br label %for.inc

if.else:
  call void @f2()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %outer.inc

outer.inc:
  %j.inc = add nsw i32 %j, 1
  %outer.cmp = icmp slt i32 %j.inc, %k
  br i1 %outer.cmp, label %outer.header, label %for.end


for.end:
  ret void
}

; In this test, the condition involves 2 AddRecs. Without evaluating both
; AddRecs, we cannot prove that the condition becomes known in the loop body
; after peeling.
define void @test6(i32 %k) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 4, [[ENTRY]] ], [ [[J_INC:%.*]], [[FOR_INC]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[I_05]], [[J]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_05]], 2
; CHECK-NEXT:    [[J_INC]] = add nsw i32 [[J]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %j = phi i32 [ 4, %entry ], [ %j.inc, %for.inc ]
  %cmp1 = icmp ult i32 %i.05, %j
  br i1 %cmp1, label %if.then, label %if.else

if.then:
  call void @f1()
  br label %for.inc

if.else:
  call void @f2()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 2
  %j.inc = add nsw i32 %j, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret void
}

define void @test7(i32 %k) {
; FIXME: Could simplify loop body by peeling one additional iteration after
;        i != 3 becomes false
; CHECK-LABEL: @test7(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH:%.*]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i32 [[I_05]], 3
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  %cmp1 = icmp ne i32 %i.05, 3
  br i1 %cmp1, label %if.then, label %for.inc

if.then:
  call void @f1()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret void
}

define void @test8(i32 %k) {
; FIXME: Could simplify loop body by peeling one additional iteration after
;        i == 3 becomes true.
; CHECK-LABEL: @test8(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH:%.*]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[I_05]], 3
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  %cmp1 = icmp eq i32 %i.05, 3
  br i1 %cmp1, label %if.then, label %for.inc

if.then:
  call void @f1()
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret void
}

; Comparison with non-monotonic predicate due to possible wrapping, loop
; body cannot be simplified.
define void @test9(i32 %k) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_05:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH:%.*]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[I_05]], 3
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add i32 [[I_05]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[K:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
for.body.lr.ph:
  br label %for.body

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.inc ]
  %cmp1 = icmp slt i32 %i.05, 3
  br i1 %cmp1, label %if.then, label %for.inc

if.then:
  call void @f1()
  br label %for.inc

for.inc:
  %inc = add i32 %i.05, 1
  %cmp = icmp slt i32 %inc, %k
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret void
}
; CHECK-NOT: llvm.loop.unroll.disable

define void @test_10__peel_first_iter_via_slt_pred(i32 %len) {
; CHECK-LABEL: @test_10__peel_first_iter_via_slt_pred(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[LEN:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; CHECK:       for.body.peel.begin:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; CHECK:       for.body.peel:
; CHECK-NEXT:    [[CMP1_PEEL:%.*]] = icmp slt i32 0, 1
; CHECK-NEXT:    br i1 [[CMP1_PEEL]], label [[IF_THEN_PEEL:%.*]], label [[IF_END_PEEL:%.*]]
; CHECK:       if.then.peel:
; CHECK-NEXT:    call void @init()
; CHECK-NEXT:    br label [[IF_END_PEEL]]
; CHECK:       if.end.peel:
; CHECK-NEXT:    call void @sink()
; CHECK-NEXT:    [[INC_PEEL:%.*]] = add nuw nsw i32 0, 1
; CHECK-NEXT:    [[EXITCOND_PEEL:%.*]] = icmp eq i32 [[INC_PEEL]], [[LEN]]
; CHECK-NEXT:    br i1 [[EXITCOND_PEEL]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY_PEEL_NEXT:%.*]]
; CHECK:       for.body.peel.next:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_NEXT1:%.*]]
; CHECK:       for.body.peel.next1:
; CHECK-NEXT:    br label [[FOR_BODY_PREHEADER_PEEL_NEWPH:%.*]]
; CHECK:       for.body.preheader.peel.newph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP_LOOPEXIT]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_06:%.*]] = phi i32 [ [[INC:%.*]], [[IF_END:%.*]] ], [ [[INC_PEEL]], [[FOR_BODY_PREHEADER_PEEL_NEWPH]] ]
; CHECK-NEXT:    br i1 false, label [[IF_THEN:%.*]], label [[IF_END]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @init()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    call void @sink()
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_06]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[LEN]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT_LOOPEXIT:%.*]], label [[FOR_BODY]], !llvm.loop !6
;
entry:
  %cmp5 = icmp sgt i32 %len, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %if.end, %entry
  ret void

for.body:                                         ; preds = %entry, %if.end
  %i.06 = phi i32 [ %inc, %if.end ], [ 0, %entry ]
  %cmp1 = icmp slt i32 %i.06, 1
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  call void @init()
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  call void @sink()
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

define void @test_11__peel_first_iter_via_sgt_pred(i32 %len) {
; CHECK-LABEL: @test_11__peel_first_iter_via_sgt_pred(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[LEN:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; CHECK:       for.body.peel.begin:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; CHECK:       for.body.peel:
; CHECK-NEXT:    [[CMP1_PEEL:%.*]] = icmp sgt i32 0, 0
; CHECK-NEXT:    br i1 [[CMP1_PEEL]], label [[IF_END_PEEL:%.*]], label [[IF_THEN_PEEL:%.*]]
; CHECK:       if.then.peel:
; CHECK-NEXT:    call void @init()
; CHECK-NEXT:    br label [[IF_END_PEEL]]
; CHECK:       if.end.peel:
; CHECK-NEXT:    call void @sink()
; CHECK-NEXT:    [[INC_PEEL:%.*]] = add nuw nsw i32 0, 1
; CHECK-NEXT:    [[EXITCOND_PEEL:%.*]] = icmp eq i32 [[INC_PEEL]], [[LEN]]
; CHECK-NEXT:    br i1 [[EXITCOND_PEEL]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY_PEEL_NEXT:%.*]]
; CHECK:       for.body.peel.next:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_NEXT1:%.*]]
; CHECK:       for.body.peel.next1:
; CHECK-NEXT:    br label [[FOR_BODY_PREHEADER_PEEL_NEWPH:%.*]]
; CHECK:       for.body.preheader.peel.newph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP_LOOPEXIT]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_06:%.*]] = phi i32 [ [[INC:%.*]], [[IF_END:%.*]] ], [ [[INC_PEEL]], [[FOR_BODY_PREHEADER_PEEL_NEWPH]] ]
; CHECK-NEXT:    br i1 true, label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @init()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    call void @sink()
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_06]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[LEN]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT_LOOPEXIT:%.*]], label [[FOR_BODY]], !llvm.loop !8
;
entry:
  %cmp5 = icmp sgt i32 %len, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %if.end, %entry
  ret void

for.body:                                         ; preds = %entry, %if.end
  %i.06 = phi i32 [ %inc, %if.end ], [ 0, %entry ]
  %cmp1 = icmp sgt i32 %i.06, 0
  br i1 %cmp1, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  call void @init()
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  call void @sink()
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

define void @test12__peel_first_iter_via_eq_pred(i32 %len) {
; CHECK-LABEL: @test12__peel_first_iter_via_eq_pred(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[LEN:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_06:%.*]] = phi i32 [ [[INC:%.*]], [[IF_END:%.*]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[I_06]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[IF_END]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @init()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    call void @sink()
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_06]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[LEN]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY]]
;
entry:
  %cmp5 = icmp sgt i32 %len, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %if.end, %entry
  ret void

for.body:                                         ; preds = %entry, %if.end
  %i.06 = phi i32 [ %inc, %if.end ], [ 0, %entry ]
  %cmp1 = icmp eq i32 %i.06, 0
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  call void @init()
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  call void @sink()
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

define void @test13__peel_first_iter_via_ne_pred(i32 %len) {
; CHECK-LABEL: @test13__peel_first_iter_via_ne_pred(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sgt i32 [[LEN:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_06:%.*]] = phi i32 [ [[INC:%.*]], [[IF_END:%.*]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i32 [[I_06]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @init()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    call void @sink()
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_06]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[LEN]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY]]
;
entry:
  %cmp5 = icmp sgt i32 %len, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %if.end, %entry
  ret void

for.body:                                         ; preds = %entry, %if.end
  %i.06 = phi i32 [ %inc, %if.end ], [ 0, %entry ]
  %cmp1 = icmp ne i32 %i.06, 0
  br i1 %cmp1, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  call void @init()
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  call void @sink()
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

declare void @init()
declare void @sink()
