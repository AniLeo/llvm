; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s
; PR2581

define i32 @test1(i1 %C) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EXIT:%.*]], label [[BODY:%.*]]
; CHECK:       body:
; CHECK-NEXT:    ret i32 11
; CHECK:       exit:
; CHECK-NEXT:    ret i32 10
;
  br i1 %C, label %exit, label %body

body:           ; preds = %0
  %A = select i1 %C, i32 10, i32 11
  ret i32 %A

exit:           ; preds = %0
  ret i32 10
}

; PR4420
declare i1 @ext()
define i1 @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = tail call i1 @ext()
; CHECK-NEXT:    br i1 [[COND]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[COND2:%.*]] = tail call i1 @ext()
; CHECK-NEXT:    br i1 [[COND2]], label [[BB3:%.*]], label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    ret i1 false
; CHECK:       bb3:
; CHECK-NEXT:    [[RES:%.*]] = tail call i1 @ext()
; CHECK-NEXT:    ret i1 [[RES]]
;
entry:
  %cond = tail call i1 @ext()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %cond2 = tail call i1 @ext()
  br i1 %cond2, label %bb3, label %bb2

bb2:
  %cond_merge = phi i1 [ %cond, %entry ], [ false, %bb1 ]
  ret i1 %cond_merge

bb3:
  %res = tail call i1 @ext()
  ret i1 %res
}

; PR4855
@gv = internal constant i8 7
define i8 @test3(i8* %a) nounwind {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8* [[A:%.*]], @gv
; CHECK-NEXT:    br i1 [[COND]], label [[BB2:%.*]], label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret i8 0
; CHECK:       bb2:
; CHECK-NEXT:    [[SHOULD_BE_CONST:%.*]] = load i8, i8* @gv, align 1
; CHECK-NEXT:    ret i8 [[SHOULD_BE_CONST]]
;
entry:
  %cond = icmp eq i8* %a, @gv
  br i1 %cond, label %bb2, label %bb

bb:
  ret i8 0

bb2:
  %should_be_const = load i8, i8* %a
  ret i8 %should_be_const
}

; PR1757
define i32 @test4(i32) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  EntryBlock:
; CHECK-NEXT:    [[DOTDEMORGAN:%.*]] = icmp sgt i32 [[TMP0:%.*]], 2
; CHECK-NEXT:    br i1 [[DOTDEMORGAN]], label [[GREATERTHANTWO:%.*]], label [[LESSTHANOREQUALTOTWO:%.*]]
; CHECK:       GreaterThanTwo:
; CHECK-NEXT:    br i1 false, label [[IMPOSSIBLE:%.*]], label [[NOTTWOANDGREATERTHANTWO:%.*]]
; CHECK:       NotTwoAndGreaterThanTwo:
; CHECK-NEXT:    ret i32 2
; CHECK:       Impossible:
; CHECK-NEXT:    ret i32 1
; CHECK:       LessThanOrEqualToTwo:
; CHECK-NEXT:    ret i32 0
;
EntryBlock:
  %.demorgan = icmp sgt i32 %0, 2
  br i1 %.demorgan, label %GreaterThanTwo, label %LessThanOrEqualToTwo

GreaterThanTwo:
  icmp eq i32 %0, 2
  br i1 %1, label %Impossible, label %NotTwoAndGreaterThanTwo

NotTwoAndGreaterThanTwo:
  ret i32 2

Impossible:
  ret i32 1

LessThanOrEqualToTwo:
  ret i32 0
}

declare i32* @f(i32*)
define void @test5(i32* %x, i32* %y) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE:%.*]] = icmp eq i32* [[X:%.*]], null
; CHECK-NEXT:    br i1 [[PRE]], label [[RETURN:%.*]], label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32* [ [[F:%.*]], [[LOOP]] ], [ [[X]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[F]] = tail call i32* @f(i32* [[PHI]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i32* [[F]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP1]], i32* [[F]], i32* null
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32* [[SEL]], null
; CHECK-NEXT:    br i1 [[CMP2]], label [[RETURN]], label [[LOOP]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  %pre = icmp eq i32* %x, null
  br i1 %pre, label %return, label %loop

loop:
  %phi = phi i32* [ %sel, %loop ], [ %x, %entry ]
  %f = tail call i32* @f(i32* %phi)
  %cmp1 = icmp ne i32* %f, %y
  %sel = select i1 %cmp1, i32* %f, i32* null
  %cmp2 = icmp eq i32* %sel, null
  br i1 %cmp2, label %return, label %loop

return:
  ret void
}

define i32 @switch1(i32 %s) {
; CHECK-LABEL: @switch1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[S:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[NEGATIVE:%.*]], label [[OUT:%.*]]
; CHECK:       negative:
; CHECK-NEXT:    switch i32 [[S]], label [[OUT]] [
; CHECK-NEXT:    i32 -2, label [[NEXT:%.*]]
; CHECK-NEXT:    i32 -1, label [[NEXT]]
; CHECK-NEXT:    ]
; CHECK:       out:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ -1, [[NEGATIVE]] ]
; CHECK-NEXT:    ret i32 [[P]]
; CHECK:       next:
; CHECK-NEXT:    ret i32 0
;
entry:
  %cmp = icmp slt i32 %s, 0
  br i1 %cmp, label %negative, label %out

negative:
  switch i32 %s, label %out [
  i32 0, label %out
  i32 1, label %out
  i32 -1, label %next
  i32 -2, label %next
  i32 2, label %out
  i32 3, label %out
  ]

out:
  %p = phi i32 [ 1, %entry ], [ -1, %negative ], [ -1, %negative ], [ -1, %negative ], [ -1, %negative ], [ -1, %negative ]
  ret i32 %p

next:
  %q = phi i32 [ 0, %negative ], [ 0, %negative ]
  ret i32 %q
}

define i32 @switch2(i32 %s) {
; CHECK-LABEL: @switch2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[S:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[POSITIVE:%.*]], label [[OUT:%.*]]
; CHECK:       positive:
; CHECK-NEXT:    br label [[OUT]]
; CHECK:       out:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ 1, [[POSITIVE]] ]
; CHECK-NEXT:    ret i32 [[P]]
; CHECK:       next:
; CHECK-NEXT:    ret i32 0
;
entry:
  %cmp = icmp sgt i32 %s, 0
  br i1 %cmp, label %positive, label %out

positive:
  switch i32 %s, label %out [
  i32 0, label %out
  i32 -1, label %next
  i32 -2, label %next
  ]

out:
  %p = phi i32 [ -1, %entry ], [ 1, %positive ], [ 1, %positive ]
  ret i32 %p

next:
  %q = phi i32 [ 0, %positive ], [ 0, %positive ]
  ret i32 %q
}

define i32 @switch3(i32 %s) {
; CHECK-LABEL: @switch3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[S:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[POSITIVE:%.*]], label [[OUT:%.*]]
; CHECK:       positive:
; CHECK-NEXT:    br label [[OUT]]
; CHECK:       out:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ 1, [[POSITIVE]] ]
; CHECK-NEXT:    ret i32 [[P]]
; CHECK:       next:
; CHECK-NEXT:    ret i32 0
;
entry:
  %cmp = icmp sgt i32 %s, 0
  br i1 %cmp, label %positive, label %out

positive:
  switch i32 %s, label %out [
  i32 -1, label %out
  i32 -2, label %next
  i32 -3, label %next
  ]

out:
  %p = phi i32 [ -1, %entry ], [ 1, %positive ], [ 1, %positive ]
  ret i32 %p

next:
  %q = phi i32 [ 0, %positive ], [ 0, %positive ]
  ret i32 %q
}

define void @switch4(i32 %s) {
; CHECK-LABEL: @switch4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[S:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[ZERO:%.*]], label [[OUT:%.*]]
; CHECK:       zero:
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       out:
; CHECK-NEXT:    ret void
; CHECK:       next:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp eq i32 %s, 0
  br i1 %cmp, label %zero, label %out

zero:
  switch i32 %s, label %out [
  i32 0, label %next
  i32 1, label %out
  i32 -1, label %out
  ]

out:
  ret void

next:
  ret void
}

define i1 @arg_attribute(i8* nonnull %a) {
; CHECK-LABEL: @arg_attribute(
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp eq i8* %a, null
  br label %exit

exit:
  ret i1 %cmp
}

declare nonnull i8* @return_nonnull()
define i1 @call_attribute() {
; CHECK-LABEL: @call_attribute(
; CHECK-NEXT:    [[A:%.*]] = call i8* @return_nonnull()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[A]], null
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
  %a = call i8* @return_nonnull()
  %cmp = icmp eq i8* %a, null
  br label %exit

exit:
  ret i1 %cmp
}

define i1 @umin(i32 %a, i32 %b) {
; CHECK-LABEL: @umin(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i32 [[B:%.*]], 20
; CHECK-NEXT:    br i1 [[CMP2]], label [[B_GUARD:%.*]], label [[OUT]]
; CHECK:       b_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp ult i32 [[A]], [[B]]
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[SEL_CMP]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[MIN]], 7
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp ult i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %cmp2 = icmp ult i32 %b, 20
  br i1 %cmp2, label %b_guard, label %out

b_guard:
  %sel_cmp = icmp ult i32 %a, %b
  %min = select i1 %sel_cmp, i32 %a, i32 %b
  %res = icmp eq i32 %min, 7
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define i1 @smin(i32 %a, i32 %b) {
; CHECK-LABEL: @smin(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i32 [[B:%.*]], 20
; CHECK-NEXT:    br i1 [[CMP2]], label [[B_GUARD:%.*]], label [[OUT]]
; CHECK:       b_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp sle i32 [[A]], [[B]]
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[SEL_CMP]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[MIN]], 7
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp ult i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %cmp2 = icmp ult i32 %b, 20
  br i1 %cmp2, label %b_guard, label %out

b_guard:
  %sel_cmp = icmp sle i32 %a, %b
  %min = select i1 %sel_cmp, i32 %a, i32 %b
  %res = icmp eq i32 %min, 7
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define i1 @smax(i32 %a, i32 %b) {
; CHECK-LABEL: @smax(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[B:%.*]], 20
; CHECK-NEXT:    br i1 [[CMP2]], label [[B_GUARD:%.*]], label [[OUT]]
; CHECK:       b_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp sge i32 [[A]], [[B]]
; CHECK-NEXT:    [[MAX:%.*]] = select i1 [[SEL_CMP]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[MAX]], 7
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sgt i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %cmp2 = icmp sgt i32 %b, 20
  br i1 %cmp2, label %b_guard, label %out

b_guard:
  %sel_cmp = icmp sge i32 %a, %b
  %max = select i1 %sel_cmp, i32 %a, i32 %b
  %res = icmp eq i32 %max, 7
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define i1 @umax(i32 %a, i32 %b) {
; CHECK-LABEL: @umax(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[B:%.*]], 20
; CHECK-NEXT:    br i1 [[CMP2]], label [[B_GUARD:%.*]], label [[OUT]]
; CHECK:       b_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp uge i32 [[A]], [[B]]
; CHECK-NEXT:    [[MAX:%.*]] = select i1 [[SEL_CMP]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[MAX]], 7
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sgt i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %cmp2 = icmp sgt i32 %b, 20
  br i1 %cmp2, label %b_guard, label %out

b_guard:
  %sel_cmp = icmp uge i32 %a, %b
  %max = select i1 %sel_cmp, i32 %a, i32 %b
  %res = icmp eq i32 %max, 7
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define i1 @clamp_low1(i32 %a) {
; CHECK-LABEL: @clamp_low1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp eq i32 [[A]], 5
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[A]], -1
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[SEL_CMP]], i32 5, i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[SEL]], 4
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sge i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %sel_cmp = icmp eq i32 %a, 5
  %add = add i32 %a, -1
  %sel = select i1 %sel_cmp, i32 5, i32 %a
  %res = icmp eq i32 %sel, 4
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define i1 @clamp_low2(i32 %a) {
; CHECK-LABEL: @clamp_low2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp ne i32 [[A]], 5
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[A]], -1
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[SEL_CMP]], i32 [[A]], i32 5
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[SEL]], 4
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sge i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %sel_cmp = icmp ne i32 %a, 5
  %add = add i32 %a, -1
  %sel = select i1 %sel_cmp, i32 %a, i32 5
  %res = icmp eq i32 %sel, 4
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define i1 @clamp_high1(i32 %a) {
; CHECK-LABEL: @clamp_high1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp eq i32 [[A]], 5
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[A]], 1
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[SEL_CMP]], i32 5, i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[SEL]], 6
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sle i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %sel_cmp = icmp eq i32 %a, 5
  %add = add i32 %a, 1
  %sel = select i1 %sel_cmp, i32 5, i32 %a
  %res = icmp eq i32 %sel, 6
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define i1 @clamp_high2(i32 %a) {
; CHECK-LABEL: @clamp_high2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp ne i32 [[A]], 5
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[A]], 1
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[SEL_CMP]], i32 [[A]], i32 5
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[SEL]], 6
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sle i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %sel_cmp = icmp ne i32 %a, 5
  %add = add i32 %a, 1
  %sel = select i1 %sel_cmp, i32 %a, i32 5
  %res = icmp eq i32 %sel, 6
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

; Just showing arbitrary constants work, not really a clamp
define i1 @clamp_high3(i32 %a) {
; CHECK-LABEL: @clamp_high3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[A:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[A_GUARD:%.*]], label [[OUT:%.*]]
; CHECK:       a_guard:
; CHECK-NEXT:    [[SEL_CMP:%.*]] = icmp ne i32 [[A]], 5
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[A]], 100
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[SEL_CMP]], i32 [[A]], i32 5
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[SEL]], 105
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 false
; CHECK:       out:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp = icmp sle i32 %a, 5
  br i1 %cmp, label %a_guard, label %out

a_guard:
  %sel_cmp = icmp ne i32 %a, 5
  %add = add i32 %a, 100
  %sel = select i1 %sel_cmp, i32 %a, i32 5
  %res = icmp eq i32 %sel, 105
  br label %next
next:
  ret i1 %res
out:
  ret i1 false
}

define void @abs1(i32 %a, i1* %p) {
; CHECK-LABEL: @abs1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A:%.*]], 10
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[A]], -20
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    br i1 [[AND]], label [[GUARD:%.*]], label [[EXIT:%.*]]
; CHECK:       guard:
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[A]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[A]], 0
; CHECK-NEXT:    [[ABS:%.*]] = select i1 [[CMP]], i32 [[SUB]], i32 [[A]]
; CHECK-NEXT:    br label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    store i1 true, i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[C2:%.*]] = icmp slt i32 [[ABS]], 19
; CHECK-NEXT:    store i1 [[C2]], i1* [[P]], align 1
; CHECK-NEXT:    store i1 true, i1* [[P]], align 1
; CHECK-NEXT:    [[C4:%.*]] = icmp sge i32 [[ABS]], 1
; CHECK-NEXT:    store i1 [[C4]], i1* [[P]], align 1
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp slt i32 %a, 10
  %cmp2 = icmp sgt i32 %a, -20
  %and = and i1 %cmp1, %cmp2
  br i1 %and, label %guard, label %exit

guard:
  %sub = sub i32 0, %a
  %cmp = icmp slt i32 %a, 0
  %abs = select i1 %cmp, i32 %sub, i32 %a
  br label %split

split:
  %c1 = icmp slt i32 %abs, 20
  store i1 %c1, i1* %p
  %c2 = icmp slt i32 %abs, 19
  store i1 %c2, i1* %p
  %c3 = icmp sge i32 %abs, 0
  store i1 %c3, i1* %p
  %c4 = icmp sge i32 %abs, 1
  store i1 %c4, i1* %p
  br label %exit

exit:
  ret void
}

define void @abs2(i32 %a, i1* %p) {
; CHECK-LABEL: @abs2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A:%.*]], 10
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[A]], -20
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    br i1 [[AND]], label [[GUARD:%.*]], label [[EXIT:%.*]]
; CHECK:       guard:
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[A]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[A]], 0
; CHECK-NEXT:    [[ABS:%.*]] = select i1 [[CMP]], i32 [[A]], i32 [[SUB]]
; CHECK-NEXT:    br label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    store i1 true, i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[C2:%.*]] = icmp slt i32 [[ABS]], 19
; CHECK-NEXT:    store i1 [[C2]], i1* [[P]], align 1
; CHECK-NEXT:    store i1 true, i1* [[P]], align 1
; CHECK-NEXT:    [[C4:%.*]] = icmp sge i32 [[ABS]], 1
; CHECK-NEXT:    store i1 [[C4]], i1* [[P]], align 1
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp slt i32 %a, 10
  %cmp2 = icmp sgt i32 %a, -20
  %and = and i1 %cmp1, %cmp2
  br i1 %and, label %guard, label %exit

guard:
  %sub = sub i32 0, %a
  %cmp = icmp sge i32 %a, 0
  %abs = select i1 %cmp, i32 %a, i32 %sub
  br label %split

split:
  %c1 = icmp slt i32 %abs, 20
  store i1 %c1, i1* %p
  %c2 = icmp slt i32 %abs, 19
  store i1 %c2, i1* %p
  %c3 = icmp sge i32 %abs, 0
  store i1 %c3, i1* %p
  %c4 = icmp sge i32 %abs, 1
  store i1 %c4, i1* %p
  br label %exit

exit:
  ret void
}

define void @nabs1(i32 %a, i1* %p) {
; CHECK-LABEL: @nabs1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A:%.*]], 10
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[A]], -20
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    br i1 [[AND]], label [[GUARD:%.*]], label [[EXIT:%.*]]
; CHECK:       guard:
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[A]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A]], 0
; CHECK-NEXT:    [[NABS:%.*]] = select i1 [[CMP]], i32 [[SUB]], i32 [[A]]
; CHECK-NEXT:    br label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    store i1 true, i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[NABS]], -19
; CHECK-NEXT:    store i1 [[C2]], i1* [[P]], align 1
; CHECK-NEXT:    store i1 true, i1* [[P]], align 1
; CHECK-NEXT:    [[C4:%.*]] = icmp sle i32 [[NABS]], -1
; CHECK-NEXT:    store i1 [[C4]], i1* [[P]], align 1
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp slt i32 %a, 10
  %cmp2 = icmp sgt i32 %a, -20
  %and = and i1 %cmp1, %cmp2
  br i1 %and, label %guard, label %exit

guard:
  %sub = sub i32 0, %a
  %cmp = icmp sgt i32 %a, 0
  %nabs = select i1 %cmp, i32 %sub, i32 %a
  br label %split

split:
  %c1 = icmp sgt i32 %nabs, -20
  store i1 %c1, i1* %p
  %c2 = icmp sgt i32 %nabs, -19
  store i1 %c2, i1* %p
  %c3 = icmp sle i32 %nabs, 0
  store i1 %c3, i1* %p
  %c4 = icmp sle i32 %nabs, -1
  store i1 %c4, i1* %p
  br label %exit

exit:
  ret void
}

define void @nabs2(i32 %a, i1* %p) {
; CHECK-LABEL: @nabs2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A:%.*]], 10
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[A]], -20
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    br i1 [[AND]], label [[GUARD:%.*]], label [[EXIT:%.*]]
; CHECK:       guard:
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[A]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[A]], 0
; CHECK-NEXT:    [[NABS:%.*]] = select i1 [[CMP]], i32 [[A]], i32 [[SUB]]
; CHECK-NEXT:    br label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    store i1 true, i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[NABS]], -19
; CHECK-NEXT:    store i1 [[C2]], i1* [[P]], align 1
; CHECK-NEXT:    store i1 true, i1* [[P]], align 1
; CHECK-NEXT:    [[C4:%.*]] = icmp sle i32 [[NABS]], -1
; CHECK-NEXT:    store i1 [[C4]], i1* [[P]], align 1
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp slt i32 %a, 10
  %cmp2 = icmp sgt i32 %a, -20
  %and = and i1 %cmp1, %cmp2
  br i1 %and, label %guard, label %exit

guard:
  %sub = sub i32 0, %a
  %cmp = icmp slt i32 %a, 0
  %nabs = select i1 %cmp, i32 %a, i32 %sub
  br label %split

split:
  %c1 = icmp sgt i32 %nabs, -20
  store i1 %c1, i1* %p
  %c2 = icmp sgt i32 %nabs, -19
  store i1 %c2, i1* %p
  %c3 = icmp sle i32 %nabs, 0
  store i1 %c3, i1* %p
  %c4 = icmp sle i32 %nabs, -1
  store i1 %c4, i1* %p
  br label %exit

exit:
  ret void
}

define i1 @zext_unknown(i8 %a) {
; CHECK-LABEL: @zext_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A32:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[A32]], 256
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %a32 = zext i8 %a to i32
  %cmp = icmp sle i32 %a32, 256
  br label %exit
exit:
  ret i1 %cmp
}

define i1 @trunc_unknown(i32 %a) {
; CHECK-LABEL: @trunc_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A8:%.*]] = trunc i32 [[A:%.*]] to i8
; CHECK-NEXT:    [[A32:%.*]] = sext i8 [[A8]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[A32]], 128
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %a8 = trunc i32 %a to i8
  %a32 = sext i8 %a8 to i32
  %cmp = icmp sle i32 %a32, 128
  br label %exit
exit:
  ret i1 %cmp
}

; TODO: missed optimization
; Make sure we exercise non-integer inputs to unary operators (i.e. crash check).
define i1 @bitcast_unknown(float %a) {
; CHECK-LABEL: @bitcast_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A32:%.*]] = bitcast float [[A:%.*]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[A32]], 128
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %a32 = bitcast float %a to i32
  %cmp = icmp sle i32 %a32, 128
  br label %exit
exit:
  ret i1 %cmp
}

define i1 @bitcast_unknown2(i8* %p) {
; CHECK-LABEL: @bitcast_unknown2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P64:%.*]] = ptrtoint i8* [[P:%.*]] to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i64 [[P64]], 128
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %p64 = ptrtoint i8* %p to i64
  %cmp = icmp sle i64 %p64, 128
  br label %exit
exit:
  ret i1 %cmp
}


define i1 @and_unknown(i32 %a) {
; CHECK-LABEL: @and_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[A:%.*]], 128
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[AND]], 128
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %and = and i32 %a, 128
  %cmp = icmp sle i32 %and, 128
  br label %exit
exit:
  ret i1 %cmp
}

define i1 @lshr_unknown(i32 %a) {
; CHECK-LABEL: @lshr_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AND:%.*]] = lshr i32 [[A:%.*]], 30
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[AND]], 128
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %and = lshr i32 %a, 30
  %cmp = icmp sle i32 %and, 128
  br label %exit
exit:
  ret i1 %cmp
}

define i1 @urem_unknown(i32 %a) {
; CHECK-LABEL: @urem_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UREM:%.*]] = urem i32 [[A:%.*]], 30
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[UREM]], 30
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %urem = urem i32 %a, 30
  %cmp = icmp ult i32 %urem, 30
  br label %exit
exit:
  ret i1 %cmp
}

define i1 @srem_unknown(i32 %a) {
; CHECK-LABEL: @srem_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SREM:%.*]] = srem i32 [[A:%.*]], 30
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[SREM]], 30
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[SREM]], -30
; CHECK-NEXT:    br i1 undef, label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i1 true
; CHECK:       exit2:
; CHECK-NEXT:    ret i1 true
;
entry:
  %srem = srem i32 %a, 30
  %cmp1 = icmp slt i32 %srem, 30
  %cmp2 = icmp sgt i32 %srem, -30
  br i1 undef, label %exit1, label %exit2
exit1:
  ret i1 %cmp1
exit2:
  ret i1 %cmp2
}

define i1 @sdiv_unknown(i32 %a) {
; CHECK-LABEL: @sdiv_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SREM:%.*]] = sdiv i32 [[A:%.*]], 123
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[SREM]], 17459217
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[SREM]], -17459217
; CHECK-NEXT:    br i1 undef, label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i1 true
; CHECK:       exit2:
; CHECK-NEXT:    ret i1 true
;
entry:
  %srem = sdiv i32 %a, 123
  %cmp1 = icmp slt i32 %srem, 17459217
  %cmp2 = icmp sgt i32 %srem, -17459217
  br i1 undef, label %exit1, label %exit2
exit1:
  ret i1 %cmp1
exit2:
  ret i1 %cmp2
}

define i1 @uadd_sat_unknown(i32 %a) {
; CHECK-LABEL: @uadd_sat_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAL:%.*]] = call i32 @llvm.uadd.sat.i32(i32 [[A:%.*]], i32 100)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp uge i32 [[VAL]], 100
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[VAL]], 100
; CHECK-NEXT:    br i1 undef, label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i1 true
; CHECK:       exit2:
; CHECK-NEXT:    ret i1 [[CMP2]]
;
entry:
  %val = call i32 @llvm.uadd.sat.i32(i32 %a, i32 100)
  %cmp1 = icmp uge i32 %val, 100
  %cmp2 = icmp ugt i32 %val, 100
  br i1 undef, label %exit1, label %exit2
exit1:
  ret i1 %cmp1
exit2:
  ret i1 %cmp2
}

define i1 @usub_sat_unknown(i32 %a) {
; CHECK-LABEL: @usub_sat_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAL:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[A:%.*]], i32 100)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ule i32 [[VAL]], -101
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i32 [[VAL]], -101
; CHECK-NEXT:    br i1 undef, label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i1 true
; CHECK:       exit2:
; CHECK-NEXT:    ret i1 [[CMP2]]
;
entry:
  %val = call i32 @llvm.usub.sat.i32(i32 %a, i32 100)
  %cmp1 = icmp ule i32 %val, 4294967195
  %cmp2 = icmp ult i32 %val, 4294967195
  br i1 undef, label %exit1, label %exit2
exit1:
  ret i1 %cmp1
exit2:
  ret i1 %cmp2
}

define i1 @sadd_sat_unknown(i32 %a) {
; CHECK-LABEL: @sadd_sat_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAL:%.*]] = call i32 @llvm.sadd.sat.i32(i32 [[A:%.*]], i32 100)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sge i32 [[VAL]], -2147483548
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[VAL]], -2147483548
; CHECK-NEXT:    br i1 undef, label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i1 true
; CHECK:       exit2:
; CHECK-NEXT:    ret i1 [[CMP2]]
;
entry:
  %val = call i32 @llvm.sadd.sat.i32(i32 %a, i32 100)
  %cmp1 = icmp sge i32 %val, -2147483548
  %cmp2 = icmp sgt i32 %val, -2147483548
  br i1 undef, label %exit1, label %exit2
exit1:
  ret i1 %cmp1
exit2:
  ret i1 %cmp2
}

define i1 @ssub_sat_unknown(i32 %a) {
; CHECK-LABEL: @ssub_sat_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAL:%.*]] = call i32 @llvm.ssub.sat.i32(i32 [[A:%.*]], i32 100)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sle i32 [[VAL]], 2147483547
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[VAL]], 2147483547
; CHECK-NEXT:    br i1 undef, label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i1 true
; CHECK:       exit2:
; CHECK-NEXT:    ret i1 [[CMP2]]
;
entry:
  %val = call i32 @llvm.ssub.sat.i32(i32 %a, i32 100)
  %cmp1 = icmp sle i32 %val, 2147483547
  %cmp2 = icmp slt i32 %val, 2147483547
  br i1 undef, label %exit1, label %exit2
exit1:
  ret i1 %cmp1
exit2:
  ret i1 %cmp2
}

declare i32 @llvm.uadd.sat.i32(i32, i32)
declare i32 @llvm.usub.sat.i32(i32, i32)
declare i32 @llvm.sadd.sat.i32(i32, i32)
declare i32 @llvm.ssub.sat.i32(i32, i32)
