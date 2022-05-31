; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=newgvn -S %s | FileCheck %s

define void @d() {
; CHECK-LABEL: @d(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br label [[FOR_COND1:%.*]]
; CHECK:       for.cond1:
; CHECK-NEXT:    [[TMP0:%.*]] = phi i32 [ [[INC18:%.*]], [[FOR_INC17:%.*]] ], [ 0, [[FOR_COND]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[TMP0]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END19:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 undef, label [[FOR_BODY3:%.*]], label [[FOR_BODY_FOR_COND4_CRIT_EDGE:%.*]]
; CHECK:       for.body.for.cond4_crit_edge:
; CHECK-NEXT:    br label [[FOR_COND4:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    br label [[CLEANUP14:%.*]]
; CHECK:       for.cond4:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[CLEANUP:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    br label [[FOR_COND6:%.*]]
; CHECK:       for.cond6:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_INC:%.*]] ], [ 0, [[IF_END]] ]
; CHECK-NEXT:    [[CMP7:%.*]] = icmp sle i64 [[TMP1]], 1
; CHECK-NEXT:    br i1 [[CMP7]], label [[FOR_INC]], label [[FOR_END9:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nsw i64 [[TMP1]], 1
; CHECK-NEXT:    br label [[FOR_COND6]]
; CHECK:       for.end9:
; CHECK-NEXT:    br i1 true, label [[IF_THEN11:%.*]], label [[IF_END12:%.*]]
; CHECK:       if.then11:
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       if.end12:
; CHECK-NEXT:    store i8 poison, ptr null, align 1
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[CLEANUP_DEST:%.*]] = phi i32 [ poison, [[IF_END12]] ], [ 1, [[IF_THEN11]] ], [ 9, [[IF_THEN]] ]
; CHECK-NEXT:    switch i32 [[CLEANUP_DEST]], label [[CLEANUP14]] [
; CHECK-NEXT:    i32 0, label [[FOR_COND4]]
; CHECK-NEXT:    i32 9, label [[FOR_END13:%.*]]
; CHECK-NEXT:    ]
; CHECK:       for.end13:
; CHECK-NEXT:    br label [[CLEANUP14]]
; CHECK:       cleanup14:
; CHECK-NEXT:    [[CLEANUP_DEST15:%.*]] = phi i32 [ 0, [[FOR_END13]] ], [ [[CLEANUP_DEST]], [[CLEANUP]] ], [ 1, [[FOR_BODY3]] ]
; CHECK-NEXT:    [[COND1:%.*]] = icmp eq i32 [[CLEANUP_DEST15]], 0
; CHECK-NEXT:    br i1 [[COND1]], label [[FOR_INC17]], label [[CLEANUP20:%.*]]
; CHECK:       for.inc17:
; CHECK-NEXT:    [[INC18]] = add nsw i32 [[TMP0]], 1
; CHECK-NEXT:    br label [[FOR_COND1]]
; CHECK:       for.end19:
; CHECK-NEXT:    br label [[CLEANUP20]]
; CHECK:       cleanup20:
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i1 [ true, [[FOR_END19]] ], [ [[COND1]], [[CLEANUP14]] ]
; CHECK-NEXT:    [[CLEANUP_DEST21:%.*]] = phi i32 [ [[CLEANUP_DEST15]], [[CLEANUP14]] ], [ 0, [[FOR_END19]] ]
; CHECK-NEXT:    br i1 [[PHIOFOPS]], label [[FOR_COND]], label [[CLEANUP23:%.*]]
; CHECK:       cleanup23:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %cleanup20, %entry
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc17, %for.cond
  %0 = phi i32 [ %inc18, %for.inc17 ], [ 0, %for.cond ]
  %cmp = icmp sle i32 %0, 1
  br i1 %cmp, label %for.body, label %for.end19

for.body:                                         ; preds = %for.cond1
  br i1 undef, label %for.body3, label %for.body.for.cond4_crit_edge

for.body.for.cond4_crit_edge:                     ; preds = %for.body
  br label %for.cond4

for.body3:                                        ; preds = %for.body
  br label %cleanup14

for.cond4:                                        ; preds = %cleanup, %for.body.for.cond4_crit_edge
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %for.cond4
  br label %cleanup

if.end:                                           ; preds = %for.cond4
  br label %for.cond6

for.cond6:                                        ; preds = %for.inc, %if.end
  %1 = phi i64 [ %inc, %for.inc ], [ 0, %if.end ]
  %cmp7 = icmp sle i64 %1, 1
  br i1 %cmp7, label %for.inc, label %for.end9

for.inc:                                          ; preds = %for.cond6
  %inc = add nsw i64 %1, 1
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br i1 true, label %if.then11, label %if.end12

if.then11:                                        ; preds = %for.end9
  br label %cleanup

if.end12:                                         ; preds = %for.end9
  br label %cleanup

cleanup:                                          ; preds = %if.end12, %if.then11, %if.then
  %cleanup.dest = phi i32 [ undef, %if.end12 ], [ 1, %if.then11 ], [ 9, %if.then ]
  switch i32 %cleanup.dest, label %cleanup14 [
  i32 0, label %for.cond4
  i32 9, label %for.end13
  ]

for.end13:                                        ; preds = %cleanup
  br label %cleanup14

cleanup14:                                        ; preds = %for.end13, %cleanup, %for.body3
  %cleanup.dest15 = phi i32 [ 0, %for.end13 ], [ %cleanup.dest, %cleanup ], [ 1, %for.body3 ]
  %cond1 = icmp eq i32 %cleanup.dest15, 0
  br i1 %cond1, label %for.inc17, label %cleanup20

for.inc17:                                        ; preds = %cleanup14
  %inc18 = add nsw i32 %0, 1
  br label %for.cond1

for.end19:                                        ; preds = %for.cond1
  br label %cleanup20

cleanup20:                                        ; preds = %for.end19, %cleanup14
  %cleanup.dest21 = phi i32 [ %cleanup.dest15, %cleanup14 ], [ 0, %for.end19 ]
  %cond = icmp eq i32 %cleanup.dest21, 0
  br i1 %cond, label %for.cond, label %cleanup23

cleanup23:                                        ; preds = %cleanup20
  ret void
}
