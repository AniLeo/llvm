; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars -verify -loop-rotate -loop-idiom < %s | FileCheck %s
; RUN: opt -S -indvars -verify -loop-rotate -loop-idiom -verify-memoryssa < %s | FileCheck %s
target triple = "x86_64-unknown-linux-gnu"

; Verify that we invalidate SCEV properly.

define void @test_01() {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LBL1:%.*]]
; CHECK:       lbl1:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br i1 false, label [[FOR_BODY3_LR_PH:%.*]], label [[FOR_COND_FOR_END5_CRIT_EDGE:%.*]]
; CHECK:       for.body3.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.cond1:
; CHECK-NEXT:    br i1 false, label [[FOR_BODY3]], label [[FOR_COND1_FOR_END5_CRIT_EDGE:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    br i1 false, label [[IF_THEN:%.*]], label [[FOR_COND1:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[LBL1]]
; CHECK:       for.cond.for.end5_crit_edge:
; CHECK-NEXT:    br label [[FOR_END5:%.*]]
; CHECK:       for.cond1.for.end5_crit_edge:
; CHECK-NEXT:    br label [[FOR_END5]]
; CHECK:       for.end5:
; CHECK-NEXT:    ret void
;
entry:
  br label %lbl1

lbl1:                                             ; preds = %if.then, %entry
  br label %for.cond

for.cond:                                         ; preds = %lbl1
  br label %for.cond1

for.cond1:                                        ; preds = %if.end, %for.cond
  br i1 false, label %for.body3, label %for.end5

for.body3:                                        ; preds = %for.cond1
  br i1 false, label %if.then, label %if.end

if.then:                                          ; preds = %for.body3
  br label %lbl1

if.end:                                           ; preds = %for.body3
  br label %for.cond1

for.end5:                                         ; preds = %for.cond1
  ret void
}

define void @test_02() {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LBL1:%.*]]
; CHECK:       lbl1:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br i1 false, label [[IF_THEN:%.*]], label [[IF_END7:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br i1 false, label [[FOR_BODY_LR_PH:%.*]], label [[IF_THEN_FOR_END6_CRIT_EDGE:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 false, label [[IF_THEN3:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then3:
; CHECK-NEXT:    br label [[LBL1]]
; CHECK:       if.end:
; CHECK-NEXT:    br label [[FOR_COND4:%.*]]
; CHECK:       for.cond4:
; CHECK-NEXT:    br i1 false, label [[FOR_BODY]], label [[FOR_COND1_FOR_END6_CRIT_EDGE:%.*]]
; CHECK:       if.then.for.end6_crit_edge:
; CHECK-NEXT:    br label [[FOR_END6:%.*]]
; CHECK:       for.cond1.for.end6_crit_edge:
; CHECK-NEXT:    br label [[FOR_END6]]
; CHECK:       for.end6:
; CHECK-NEXT:    ret void
; CHECK:       if.end7:
; CHECK-NEXT:    unreachable
;
entry:
  br label %lbl1

lbl1:                                             ; preds = %if.then3, %entry
  br label %for.cond

for.cond:                                         ; preds = %lbl1
  br i1 false, label %if.then, label %if.end7

if.then:                                          ; preds = %for.cond
  br label %for.cond1

for.cond1:                                        ; preds = %for.cond4, %if.then
  br i1 undef, label %for.body, label %for.end6

for.body:                                         ; preds = %for.cond1
  br i1 false, label %if.then3, label %if.end

if.then3:                                         ; preds = %for.body
  br label %lbl1

if.end:                                           ; preds = %for.body
  br label %for.cond4

for.cond4:                                        ; preds = %if.end
  br label %for.cond1

for.end6:                                         ; preds = %for.cond1
  ret void

if.end7:                                          ; preds = %for.cond
  unreachable
}
