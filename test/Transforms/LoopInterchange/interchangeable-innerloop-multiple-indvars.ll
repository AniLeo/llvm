; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -loop-interchange -cache-line-size=64 -verify-dom-info -verify-loop-info -verify-scev -verify-loop-lcssa -S | FileCheck %s

@b = common dso_local local_unnamed_addr global [200 x [200 x i32]] zeroinitializer, align 4
@a = common dso_local local_unnamed_addr global i32 0, align 4

;; int a, c, d, e;
;; int b[200][200];
;; void fn1() {
;;   for (c = 0; c < 100; c++) {
;;     for (d = 5, e = 5; d > 0, e > 0; d--, e--)
;;       a |= b[d][c + 9];
;;   }
;; }
;
; There are multiple inner loop indvars and only one
; of them is used in the loop exit condition at the
; inner loop latch.
;
define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_BODY3_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_OUTER:%.*]] = phi i64 [ [[INDVARS_OUTER_NEXT:%.*]], [[FOR_INC7:%.*]] ], [ 0, [[FOR_BODY_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[OR_REDUCTION_INNER:%.*]] = phi i32 [ [[OR:%.*]], [[FOR_INC7]] ], [ [[OR_REDUCTION_OUTER:%.*]], [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = add nsw i64 [[INDVARS_OUTER]], 9
; CHECK-NEXT:    br label [[FOR_BODY3_SPLIT1:%.*]]
; CHECK:       for.body3.preheader:
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[INDVAR0:%.*]] = phi i64 [ [[TMP0:%.*]], [[FOR_BODY3_SPLIT:%.*]] ], [ 5, [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    [[INDVAR1:%.*]] = phi i32 [ [[TMP1:%.*]], [[FOR_BODY3_SPLIT]] ], [ 5, [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    [[OR_REDUCTION_OUTER]] = phi i32 [ [[OR_LCSSA:%.*]], [[FOR_BODY3_SPLIT]] ], [ [[A]], [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_BODY_PREHEADER]]
; CHECK:       for.body3.split1:
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds [200 x [200 x i32]], [200 x [200 x i32]]* @b, i64 0, i64 [[INDVAR0]], i64 [[INDEX]]
; CHECK-NEXT:    [[LOAD_VAL:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[OR]] = or i32 [[OR_REDUCTION_INNER]], [[LOAD_VAL]]
; CHECK-NEXT:    [[INDVAR0_NEXT:%.*]] = add nsw i64 [[INDVAR0]], -1
; CHECK-NEXT:    [[INDVAR1_NEXT:%.*]] = add nsw i32 [[INDVAR1]], -1
; CHECK-NEXT:    [[TOBOOL2:%.*]] = icmp eq i32 [[INDVAR1_NEXT]], 0
; CHECK-NEXT:    br label [[FOR_INC7]]
; CHECK:       for.body3.split:
; CHECK-NEXT:    [[OR_LCSSA]] = phi i32 [ [[OR]], [[FOR_INC7]] ]
; CHECK-NEXT:    [[TMP0]] = add nsw i64 [[INDVAR0]], -1
; CHECK-NEXT:    [[TMP1]] = add nsw i32 [[INDVAR1]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[FOR_COND_FOR_END8_CRIT_EDGE:%.*]], label [[FOR_BODY3]]
; CHECK:       for.inc7:
; CHECK-NEXT:    [[INDVARS_OUTER_NEXT]] = add nsw i64 [[INDVARS_OUTER]], 1
; CHECK-NEXT:    [[INDVARS_OUTER_NEXT_TRUNC:%.*]] = trunc i64 [[INDVARS_OUTER_NEXT]] to i32
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[INDVARS_OUTER_NEXT_TRUNC]], 100
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[FOR_BODY3_SPLIT]], label [[FOR_BODY]]
; CHECK:       for.cond.for.end8_crit_edge:
; CHECK-NEXT:    [[OR_LCSSA_LCSSA:%.*]] = phi i32 [ [[OR_LCSSA]], [[FOR_BODY3_SPLIT]] ]
; CHECK-NEXT:    store i32 [[OR_LCSSA_LCSSA]], i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_END8:%.*]]
; CHECK:       for.end8:
; CHECK-NEXT:    ret void
;

entry:
  %a = load i32, i32* @a
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc7
  %indvars.outer = phi i64 [ 0, %entry ], [ %indvars.outer.next, %for.inc7 ]
  %or.reduction.outer = phi i32 [ %a, %entry ], [ %or.lcssa, %for.inc7 ]
  %index = add nsw i64 %indvars.outer, 9
  br label %for.body3

for.body3:                                        ; preds = %for.body, %for.body3
  %or.reduction.inner = phi i32 [ %or.reduction.outer, %for.body ], [ %or, %for.body3 ]
  %indvar0 = phi i64 [ 5, %for.body ], [ %indvar0.next, %for.body3 ]
  %indvar1 = phi i32 [ 5, %for.body ], [ %indvar1.next, %for.body3 ]
  %arrayidx5 = getelementptr inbounds [200 x [200 x i32]], [200 x [200 x i32]]* @b, i64 0, i64 %indvar0, i64 %index
  %load.val = load i32, i32* %arrayidx5, align 4
  %or = or i32 %or.reduction.inner, %load.val
  %indvar0.next = add nsw i64 %indvar0, -1
  %indvar1.next = add nsw i32 %indvar1, -1
  %tobool2 = icmp eq i32 %indvar1.next, 0
  br i1 %tobool2, label %for.inc7, label %for.body3

for.inc7:                                         ; preds = %for.body3
  %or.lcssa = phi i32 [ %or, %for.body3 ]
  %indvars.outer.next = add nsw i64 %indvars.outer, 1
  %indvars.outer.next.trunc = trunc i64 %indvars.outer.next to i32
  %tobool = icmp eq i32 %indvars.outer.next.trunc, 100
  br i1 %tobool, label %for.cond.for.end8_crit_edge, label %for.body

for.cond.for.end8_crit_edge:                      ; preds = %for.inc7
  %or.lcssa.lcssa = phi i32 [ %or.lcssa, %for.inc7 ]
  store i32 %or.lcssa.lcssa, i32* @a
  br label %for.end8

for.end8:                                         ; preds = %for.cond.for.end8_crit_edge, %entry
  ret void
}

;; int a, c, d, e;
;; int b[200][200];
;; void fn1() {
;;   for (c = 0 ; c < 100; c++) {
;;     for (d = 5, e = 6; d + e > 0; d--, e = e - 2)
;;       a |= b[d][c + 9];
;;   }
;; }
;
; All inner loop indvars are used in the inner latch.
;
define void @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_BODY3_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_OUTER:%.*]] = phi i64 [ [[INDVARS_OUTER_NEXT:%.*]], [[FOR_INC7:%.*]] ], [ 0, [[FOR_BODY_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[OR_REDUCTION_INNER:%.*]] = phi i32 [ [[OR:%.*]], [[FOR_INC7]] ], [ [[OR_REDUCTION_OUTER:%.*]], [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = add nsw i64 [[INDVARS_OUTER]], 9
; CHECK-NEXT:    br label [[FOR_BODY3_SPLIT1:%.*]]
; CHECK:       for.body3.preheader:
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[INDVAR0:%.*]] = phi i64 [ [[TMP2:%.*]], [[FOR_BODY3_SPLIT:%.*]] ], [ 5, [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    [[INDVAR1:%.*]] = phi i32 [ [[TMP0:%.*]], [[FOR_BODY3_SPLIT]] ], [ 6, [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    [[OR_REDUCTION_OUTER]] = phi i32 [ [[OR_LCSSA:%.*]], [[FOR_BODY3_SPLIT]] ], [ [[A]], [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_BODY_PREHEADER]]
; CHECK:       for.body3.split1:
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds [200 x [200 x i32]], [200 x [200 x i32]]* @b, i64 0, i64 [[INDVAR0]], i64 [[INDEX]]
; CHECK-NEXT:    [[LOAD_VAL:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[OR]] = or i32 [[OR_REDUCTION_INNER]], [[LOAD_VAL]]
; CHECK-NEXT:    [[INDVAR0_NEXT:%.*]] = add nsw i64 [[INDVAR0]], -1
; CHECK-NEXT:    [[INDVAR1_NEXT:%.*]] = add nsw i32 [[INDVAR1]], -2
; CHECK-NEXT:    [[INDVAR1_NEXT_EXT:%.*]] = sext i32 [[INDVAR1_NEXT]] to i64
; CHECK-NEXT:    [[INDVARS_ADD:%.*]] = add nsw i64 [[INDVAR0_NEXT]], [[INDVAR1_NEXT_EXT]]
; CHECK-NEXT:    [[TOBOOL2:%.*]] = icmp eq i64 [[INDVARS_ADD]], 0
; CHECK-NEXT:    br label [[FOR_INC7]]
; CHECK:       for.body3.split:
; CHECK-NEXT:    [[OR_LCSSA]] = phi i32 [ [[OR]], [[FOR_INC7]] ]
; CHECK-NEXT:    [[TMP0]] = add nsw i32 [[INDVAR1]], -2
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2]] = add nsw i64 [[INDVAR0]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i64 [[TMP3]], 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[FOR_COND_FOR_END8_CRIT_EDGE:%.*]], label [[FOR_BODY3]]
; CHECK:       for.inc7:
; CHECK-NEXT:    [[INDVARS_OUTER_NEXT]] = add nsw i64 [[INDVARS_OUTER]], 1
; CHECK-NEXT:    [[INDVARS_OUTER_NEXT_TRUNC:%.*]] = trunc i64 [[INDVARS_OUTER_NEXT]] to i32
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[INDVARS_OUTER_NEXT_TRUNC]], 100
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[FOR_BODY3_SPLIT]], label [[FOR_BODY]]
; CHECK:       for.cond.for.end8_crit_edge:
; CHECK-NEXT:    [[OR_LCSSA_LCSSA:%.*]] = phi i32 [ [[OR_LCSSA]], [[FOR_BODY3_SPLIT]] ]
; CHECK-NEXT:    store i32 [[OR_LCSSA_LCSSA]], i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_END8:%.*]]
; CHECK:       for.end8:
; CHECK-NEXT:    ret void
;
entry:
  %a = load i32, i32* @a
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc7
  %indvars.outer = phi i64 [ 0, %entry ], [ %indvars.outer.next, %for.inc7 ]
  %or.reduction.outer = phi i32 [ %a, %entry ], [ %or.lcssa, %for.inc7 ]
  %index = add nsw i64 %indvars.outer, 9
  br label %for.body3

for.body3:                                        ; preds = %for.body, %for.body3
  %or.reduction.inner = phi i32 [ %or.reduction.outer, %for.body ], [ %or, %for.body3 ]
  %indvar0 = phi i64 [ 5, %for.body ], [ %indvar0.next, %for.body3 ]
  %indvar1 = phi i32 [ 6, %for.body ], [ %indvar1.next, %for.body3 ]
  %arrayidx5 = getelementptr inbounds [200 x [200 x i32]], [200 x [200 x i32]]* @b, i64 0, i64 %indvar0, i64 %index
  %load.val = load i32, i32* %arrayidx5, align 4
  %or = or i32 %or.reduction.inner, %load.val
  %indvar0.next = add nsw i64 %indvar0, -1
  %indvar1.next = add nsw i32 %indvar1, -2
  %indvar1.next.ext = sext i32 %indvar1.next to i64
  %indvars.add = add nsw i64 %indvar0.next, %indvar1.next.ext
  %tobool2 = icmp eq i64 %indvars.add, 0
  br i1 %tobool2, label %for.inc7, label %for.body3

for.inc7:                                         ; preds = %for.body3
  %or.lcssa = phi i32 [ %or, %for.body3 ]
  %indvars.outer.next = add nsw i64 %indvars.outer, 1
  %indvars.outer.next.trunc = trunc i64 %indvars.outer.next to i32
  %tobool = icmp eq i32 %indvars.outer.next.trunc, 100
  br i1 %tobool, label %for.cond.for.end8_crit_edge, label %for.body

for.cond.for.end8_crit_edge:                      ; preds = %for.inc7
  %or.lcssa.lcssa = phi i32 [ %or.lcssa, %for.inc7 ]
  store i32 %or.lcssa.lcssa, i32* @a
  br label %for.end8

for.end8:                                         ; preds = %for.cond.for.end8_crit_edge, %entry
  ret void
}

;; int a, c, d, e;
;; int b[200][200];
;; void fn1() {
;;   for (c = 0 ; c < 100; c++) {
;;     d = 5;
;;     e = 49;
;;     for (; d != e; d++, e--)
;;       a |= b[d][c + 9];
;;   }
;; }
;
; Two inner loop indvars are involved in the inner loop exit
; condition as LHS and RHS.
define void @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_BODY3_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_OUTER:%.*]] = phi i64 [ [[INDVARS_OUTER_NEXT:%.*]], [[FOR_INC7:%.*]] ], [ 0, [[FOR_BODY_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[OR_REDUCTION_INNER:%.*]] = phi i32 [ [[OR:%.*]], [[FOR_INC7]] ], [ [[OR_REDUCTION_OUTER:%.*]], [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = add nsw i64 [[INDVARS_OUTER]], 9
; CHECK-NEXT:    br label [[FOR_BODY3_SPLIT1:%.*]]
; CHECK:       for.body3.preheader:
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[INDVAR0:%.*]] = phi i32 [ [[TMP1:%.*]], [[FOR_BODY3_SPLIT:%.*]] ], [ 5, [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    [[INDVAR1:%.*]] = phi i32 [ [[TMP0:%.*]], [[FOR_BODY3_SPLIT]] ], [ 49, [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    [[OR_REDUCTION_OUTER]] = phi i32 [ [[OR_LCSSA:%.*]], [[FOR_BODY3_SPLIT]] ], [ [[A]], [[FOR_BODY3_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_BODY_PREHEADER]]
; CHECK:       for.body3.split1:
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds [200 x [200 x i32]], [200 x [200 x i32]]* @b, i64 0, i32 [[INDVAR0]], i64 [[INDEX]]
; CHECK-NEXT:    [[LOAD_VAL:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[OR]] = or i32 [[OR_REDUCTION_INNER]], [[LOAD_VAL]]
; CHECK-NEXT:    [[INDVAR0_NEXT:%.*]] = add nsw i32 [[INDVAR0]], 1
; CHECK-NEXT:    [[INDVAR1_NEXT:%.*]] = add nsw i32 [[INDVAR1]], -1
; CHECK-NEXT:    [[TOBOOL2:%.*]] = icmp eq i32 [[INDVAR0_NEXT]], [[INDVAR1_NEXT]]
; CHECK-NEXT:    br label [[FOR_INC7]]
; CHECK:       for.body3.split:
; CHECK-NEXT:    [[OR_LCSSA]] = phi i32 [ [[OR]], [[FOR_INC7]] ]
; CHECK-NEXT:    [[TMP0]] = add nsw i32 [[INDVAR1]], -1
; CHECK-NEXT:    [[TMP1]] = add nsw i32 [[INDVAR0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], [[TMP0]]
; CHECK-NEXT:    br i1 [[TMP2]], label [[FOR_COND_FOR_END8_CRIT_EDGE:%.*]], label [[FOR_BODY3]]
; CHECK:       for.inc7:
; CHECK-NEXT:    [[INDVARS_OUTER_NEXT]] = add nsw i64 [[INDVARS_OUTER]], 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[INDVARS_OUTER_NEXT]], 100
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[FOR_BODY3_SPLIT]], label [[FOR_BODY]]
; CHECK:       for.cond.for.end8_crit_edge:
; CHECK-NEXT:    [[OR_LCSSA_LCSSA:%.*]] = phi i32 [ [[OR_LCSSA]], [[FOR_BODY3_SPLIT]] ]
; CHECK-NEXT:    store i32 [[OR_LCSSA_LCSSA]], i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_END8:%.*]]
; CHECK:       for.end8:
; CHECK-NEXT:    ret void
;

entry:
  %a = load i32, i32* @a
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc7
  %indvars.outer = phi i64 [ 0, %entry ], [ %indvars.outer.next, %for.inc7 ]
  %or.reduction.outer = phi i32 [ %a, %entry ], [ %or.lcssa, %for.inc7 ]
  %index = add nsw i64 %indvars.outer, 9
  br label %for.body3

for.body3:                                        ; preds = %for.body, %for.body3
  %or.reduction.inner = phi i32 [ %or.reduction.outer, %for.body ], [ %or, %for.body3 ]
  %indvar0 = phi i32 [ 5, %for.body ], [ %indvar0.next, %for.body3 ]
  %indvar1 = phi i32 [ 49, %for.body ], [ %indvar1.next, %for.body3 ]
  %arrayidx5 = getelementptr inbounds [200 x [200 x i32]], [200 x [200 x i32]]* @b, i64 0, i32 %indvar0, i64 %index
  %load.val = load i32, i32* %arrayidx5, align 4
  %or = or i32 %or.reduction.inner, %load.val
  %indvar0.next = add nsw i32 %indvar0, 1
  %indvar1.next = add nsw i32 %indvar1, -1
  %tobool2 = icmp eq i32 %indvar0.next, %indvar1.next
  br i1 %tobool2, label %for.inc7, label %for.body3

for.inc7:                                         ; preds = %for.body3
  %or.lcssa = phi i32 [ %or, %for.body3 ]
  %indvars.outer.next = add nsw i64 %indvars.outer, 1
  %tobool = icmp eq i64 %indvars.outer.next, 100
  br i1 %tobool, label %for.cond.for.end8_crit_edge, label %for.body

for.cond.for.end8_crit_edge:                      ; preds = %for.inc7
  %or.lcssa.lcssa = phi i32 [ %or.lcssa, %for.inc7 ]
  store i32 %or.lcssa.lcssa, i32* @a
  br label %for.end8

for.end8:                                         ; preds = %for.cond.for.end8_crit_edge, %entry
  ret void
}
