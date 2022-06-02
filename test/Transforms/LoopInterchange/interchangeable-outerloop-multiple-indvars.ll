; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -loop-interchange -verify-dom-info -verify-loop-info -verify-scev -verify-loop-lcssa -S | FileCheck %s

target triple = "powerpc64le-unknown-linux-gnu"
@b = constant [200 x [100 x i32]] zeroinitializer, align 4
@a = constant i32 0, align 4

; // Loop wth two outer indvars.
; int a, c, d, e;
; int b[200][100];
; void test1() {
;  for (c = 0, e = 1; c < 100 && e < 150; c++, e++) {
;    d = 5;
;    for (; d; d--)
;      a |= b[d][c + 9];
;   }
; }
define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_BODY4_PREHEADER:%.*]]
; CHECK:       for.cond2.preheader.preheader:
; CHECK-NEXT:    br label [[FOR_COND2_PREHEADER:%.*]]
; CHECK:       for.cond2.preheader:
; CHECK-NEXT:    [[INDVAR0:%.*]] = phi i64 [ [[INDVAR0_NEXT:%.*]], [[FOR_INC7:%.*]] ], [ 0, [[FOR_COND2_PREHEADER_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[INDVAR1:%.*]] = phi i32 [ [[INDVAR1_NEXT:%.*]], [[FOR_INC7]] ], [ 1, [[FOR_COND2_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[OR13:%.*]] = phi i32 [ [[OR:%.*]], [[FOR_INC7]] ], [ [[OR_REDUCTION:%.*]], [[FOR_COND2_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = add nsw i64 [[INDVAR0]], 9
; CHECK-NEXT:    br label [[FOR_BODY4_SPLIT1:%.*]]
; CHECK:       for.body4.preheader:
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
; CHECK:       for.body4:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP0:%.*]], [[FOR_BODY4_SPLIT:%.*]] ], [ 5, [[FOR_BODY4_PREHEADER]] ]
; CHECK-NEXT:    [[OR_REDUCTION]] = phi i32 [ [[OR_LCSSA:%.*]], [[FOR_BODY4_SPLIT]] ], [ [[A]], [[FOR_BODY4_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_COND2_PREHEADER_PREHEADER]]
; CHECK:       for.body4.split1:
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds [200 x [100 x i32]], [200 x [100 x i32]]* @b, i64 0, i64 [[INDVARS_IV]], i64 [[INDEX]]
; CHECK-NEXT:    [[LOAD_VAL:%.*]] = load i32, i32* [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[OR]] = or i32 [[OR13]], [[LOAD_VAL]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TOBOOL3:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 0
; CHECK-NEXT:    br label [[FOR_INC7]]
; CHECK:       for.body4.split:
; CHECK-NEXT:    [[OR_LCSSA]] = phi i32 [ [[OR]], [[FOR_INC7]] ]
; CHECK-NEXT:    [[TMP0]] = add nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[FOR_COND_FOR_END9_CRIT_EDGE:%.*]], label [[FOR_BODY4]]
; CHECK:       for.inc7:
; CHECK-NEXT:    [[INDVAR0_NEXT]] = add nsw i64 [[INDVAR0]], 1
; CHECK-NEXT:    [[INDVAR1_NEXT]] = add nsw i32 [[INDVAR1]], 1
; CHECK-NEXT:    [[INDVAR0_NEXT_TRUNC:%.*]] = trunc i64 [[INDVAR0_NEXT]] to i32
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[INDVAR0_NEXT_TRUNC]], 100
; CHECK-NEXT:    [[TOBOOL1:%.*]] = icmp ne i32 [[INDVAR1_NEXT]], 150
; CHECK-NEXT:    [[OUTER_COND:%.*]] = and i1 [[TOBOOL]], [[TOBOOL1]]
; CHECK-NEXT:    br i1 [[OUTER_COND]], label [[FOR_COND2_PREHEADER]], label [[FOR_BODY4_SPLIT]]
; CHECK:       for.cond.for.end9_crit_edge:
; CHECK-NEXT:    [[OR_LCSSA_LCSSA:%.*]] = phi i32 [ [[OR_LCSSA]], [[FOR_BODY4_SPLIT]] ]
; CHECK-NEXT:    store i32 [[OR_LCSSA_LCSSA]], i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_END9:%.*]]
; CHECK:       for.end9:
; CHECK-NEXT:    ret void
;


entry:
  %a = load i32, i32* @a, align 4
  br label %for.cond2.preheader

for.cond2.preheader:                              ; preds = %entry, %for.inc7
  %indvar0 = phi i64 [ 0, %entry ], [ %indvar0.next, %for.inc7 ]
  %or.reduction = phi i32 [ %a, %entry ], [ %or.lcssa, %for.inc7 ]
  %indvar1 = phi i32 [ 1, %entry ], [ %indvar1.next, %for.inc7 ]
  %index = add nsw i64 %indvar0, 9
  br label %for.body4

for.body4:                                        ; preds = %for.cond2.preheader, %for.body4
  %indvars.iv = phi i64 [ 5, %for.cond2.preheader ], [ %indvars.iv.next, %for.body4 ]
  %or13 = phi i32 [ %or.reduction, %for.cond2.preheader ], [ %or, %for.body4 ]
  %arrayidx6 = getelementptr inbounds [200 x [100 x i32]], [200 x [100 x i32]]* @b, i64 0, i64 %indvars.iv, i64 %index
  %load.val = load i32, i32* %arrayidx6, align 4
  %or = or i32 %or13, %load.val
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  %tobool3 = icmp eq i64 %indvars.iv.next, 0
  br i1 %tobool3, label %for.inc7, label %for.body4

for.inc7:                                         ; preds = %for.body4
  %or.lcssa = phi i32 [ %or, %for.body4 ]
  %indvar0.next = add nsw i64 %indvar0, 1
  %indvar1.next = add nsw i32 %indvar1, 1
  %indvar0.next.trunc = trunc i64 %indvar0.next to i32
  %tobool = icmp ne i32 %indvar0.next.trunc, 100
  %tobool1 = icmp ne i32 %indvar1.next, 150
  %outer.cond = and i1 %tobool, %tobool1
  br i1 %outer.cond, label %for.cond2.preheader, label %for.cond.for.end9_crit_edge

for.cond.for.end9_crit_edge:                      ; preds = %for.inc7
  %or.lcssa.lcssa = phi i32 [ %or.lcssa, %for.inc7 ]
  store i32 %or.lcssa.lcssa, i32* @a, align 4
  br label %for.end9

for.end9:                                         ; preds = %for.cond.for.end9_crit_edge, %entry
  ret void
}

; // Both two outer indvars are involved in array accesses
; // inside the inner loop.
; int a, c, d, e;
; int b[200][100];
; void test2() {
;  for (c = 0, e = 1; c < 100 && e < 150; c++, e++) {
;     d = 5;
;     for (; d; d--)
;       a |= b[d + e][c + 9];
;   }
; }

define void @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_BODY4_PREHEADER:%.*]]
; CHECK:       for.cond2.preheader.preheader:
; CHECK-NEXT:    br label [[FOR_COND2_PREHEADER:%.*]]
; CHECK:       for.cond2.preheader:
; CHECK-NEXT:    [[INDVAR0:%.*]] = phi i64 [ [[INDVAR0_NEXT:%.*]], [[FOR_INC7:%.*]] ], [ 0, [[FOR_COND2_PREHEADER_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[INDVAR1:%.*]] = phi i64 [ [[INDVAR1_NEXT:%.*]], [[FOR_INC7]] ], [ 1, [[FOR_COND2_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[OR13:%.*]] = phi i32 [ [[OR:%.*]], [[FOR_INC7]] ], [ [[OR_REDUCTION:%.*]], [[FOR_COND2_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[INDEX0:%.*]] = add nsw i64 [[INDVAR0]], 9
; CHECK-NEXT:    br label [[FOR_BODY4_SPLIT1:%.*]]
; CHECK:       for.body4.preheader:
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
; CHECK:       for.body4:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP0:%.*]], [[FOR_BODY4_SPLIT:%.*]] ], [ 5, [[FOR_BODY4_PREHEADER]] ]
; CHECK-NEXT:    [[OR_REDUCTION]] = phi i32 [ [[OR_LCSSA:%.*]], [[FOR_BODY4_SPLIT]] ], [ [[A]], [[FOR_BODY4_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_COND2_PREHEADER_PREHEADER]]
; CHECK:       for.body4.split1:
; CHECK-NEXT:    [[INDEX1:%.*]] = add nsw i64 [[INDVARS_IV]], [[INDVAR1]]
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds [200 x [100 x i32]], [200 x [100 x i32]]* @b, i64 0, i64 [[INDEX1]], i64 [[INDEX0]]
; CHECK-NEXT:    [[LOAD_VAL:%.*]] = load i32, i32* [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[OR]] = or i32 [[OR13]], [[LOAD_VAL]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TOBOOL3:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 0
; CHECK-NEXT:    br label [[FOR_INC7]]
; CHECK:       for.body4.split:
; CHECK-NEXT:    [[OR_LCSSA]] = phi i32 [ [[OR]], [[FOR_INC7]] ]
; CHECK-NEXT:    [[TMP0]] = add nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[FOR_COND_FOR_END9_CRIT_EDGE:%.*]], label [[FOR_BODY4]]
; CHECK:       for.inc7:
; CHECK-NEXT:    [[INDVAR0_NEXT]] = add nsw i64 [[INDVAR0]], 1
; CHECK-NEXT:    [[INDVAR1_NEXT]] = add nsw i64 [[INDVAR1]], 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i64 [[INDVAR0_NEXT]], 100
; CHECK-NEXT:    [[TOBOOL1:%.*]] = icmp ne i64 [[INDVAR1_NEXT]], 150
; CHECK-NEXT:    [[OUTER_COND:%.*]] = and i1 [[TOBOOL]], [[TOBOOL1]]
; CHECK-NEXT:    br i1 [[OUTER_COND]], label [[FOR_COND2_PREHEADER]], label [[FOR_BODY4_SPLIT]]
; CHECK:       for.cond.for.end9_crit_edge:
; CHECK-NEXT:    [[OR_LCSSA_LCSSA:%.*]] = phi i32 [ [[OR_LCSSA]], [[FOR_BODY4_SPLIT]] ]
; CHECK-NEXT:    store i32 [[OR_LCSSA_LCSSA]], i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_END9:%.*]]
; CHECK:       for.end9:
; CHECK-NEXT:    ret void
;
entry:
  %a = load i32, i32* @a, align 4
  br label %for.cond2.preheader

for.cond2.preheader:                              ; preds = %entry, %for.inc7
  %indvar0 = phi i64 [ 0, %entry ], [ %indvar0.next, %for.inc7 ]
  %or.reduction = phi i32 [ %a, %entry ], [ %or.lcssa, %for.inc7 ]
  %indvar1 = phi i64 [ 1, %entry ], [ %indvar1.next, %for.inc7 ]
  %index0 = add nsw i64 %indvar0, 9
  br label %for.body4

for.body4:                                        ; preds = %for.cond2.preheader, %for.body4
  %indvars.iv = phi i64 [ 5, %for.cond2.preheader ], [ %indvars.iv.next, %for.body4 ]
  %or13 = phi i32 [ %or.reduction, %for.cond2.preheader ], [ %or, %for.body4 ]
  %index1 = add nsw i64 %indvars.iv, %indvar1
  %arrayidx6 = getelementptr inbounds [200 x [100 x i32]], [200 x [100 x i32]]* @b, i64 0, i64 %index1, i64 %index0
  %load.val = load i32, i32* %arrayidx6, align 4
  %or = or i32 %or13, %load.val
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  %tobool3 = icmp eq i64 %indvars.iv.next, 0
  br i1 %tobool3, label %for.inc7, label %for.body4

for.inc7:                                         ; preds = %for.body4
  %or.lcssa = phi i32 [ %or, %for.body4 ]
  %indvar0.next = add nsw i64 %indvar0, 1
  %indvar1.next = add nsw i64 %indvar1, 1
  %tobool = icmp ne i64 %indvar0.next, 100
  %tobool1 = icmp ne i64 %indvar1.next, 150
  %outer.cond = and i1 %tobool, %tobool1
  br i1 %outer.cond, label %for.cond2.preheader, label %for.cond.for.end9_crit_edge

for.cond.for.end9_crit_edge:                      ; preds = %for.inc7
  %or.lcssa.lcssa = phi i32 [ %or.lcssa, %for.inc7 ]
  store i32 %or.lcssa.lcssa, i32* @a, align 4
  br label %for.end9

for.end9:                                         ; preds = %for.cond.for.end9_crit_edge, %entry
  ret void
}


; // Both two outer indvars are involved in a single
; // outer loop exit condition.
; int a, c, d, e;
; int b[200][100];
; void test3() {
;  for (c = 0, e = 1; c + e < 150; c++, e++) {
;     d = 5;
;     for (; d; d--)
;       a |= b[d + e][c + 9];
;   }
; }

define void @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_BODY4_PREHEADER:%.*]]
; CHECK:       for.cond2.preheader.preheader:
; CHECK-NEXT:    br label [[FOR_COND2_PREHEADER:%.*]]
; CHECK:       for.cond2.preheader:
; CHECK-NEXT:    [[INDVAR0:%.*]] = phi i64 [ [[INDVAR0_NEXT:%.*]], [[FOR_INC7:%.*]] ], [ 0, [[FOR_COND2_PREHEADER_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[INDVAR1:%.*]] = phi i64 [ [[INDVAR1_NEXT:%.*]], [[FOR_INC7]] ], [ 1, [[FOR_COND2_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[OR13:%.*]] = phi i32 [ [[OR:%.*]], [[FOR_INC7]] ], [ [[OR_REDUCTION:%.*]], [[FOR_COND2_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[INDEX0:%.*]] = add nsw i64 [[INDVAR0]], 9
; CHECK-NEXT:    br label [[FOR_BODY4_SPLIT1:%.*]]
; CHECK:       for.body4.preheader:
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
; CHECK:       for.body4:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP0:%.*]], [[FOR_BODY4_SPLIT:%.*]] ], [ 5, [[FOR_BODY4_PREHEADER]] ]
; CHECK-NEXT:    [[OR_REDUCTION]] = phi i32 [ [[OR_LCSSA:%.*]], [[FOR_BODY4_SPLIT]] ], [ [[A]], [[FOR_BODY4_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_COND2_PREHEADER_PREHEADER]]
; CHECK:       for.body4.split1:
; CHECK-NEXT:    [[INDEX1:%.*]] = add nsw i64 [[INDVARS_IV]], [[INDVAR1]]
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds [200 x [100 x i32]], [200 x [100 x i32]]* @b, i64 0, i64 [[INDEX1]], i64 [[INDEX0]]
; CHECK-NEXT:    [[LOAD_VAL:%.*]] = load i32, i32* [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[OR]] = or i32 [[OR13]], [[LOAD_VAL]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TOBOOL3:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 0
; CHECK-NEXT:    br label [[FOR_INC7]]
; CHECK:       for.body4.split:
; CHECK-NEXT:    [[OR_LCSSA]] = phi i32 [ [[OR]], [[FOR_INC7]] ]
; CHECK-NEXT:    [[TMP0]] = add nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[FOR_COND_FOR_END9_CRIT_EDGE:%.*]], label [[FOR_BODY4]]
; CHECK:       for.inc7:
; CHECK-NEXT:    [[INDVAR0_NEXT]] = add nsw i64 [[INDVAR0]], 1
; CHECK-NEXT:    [[INDVAR1_NEXT]] = add nsw i64 [[INDVAR1]], 1
; CHECK-NEXT:    [[OUTER_INDVAR_ADD:%.*]] = add nsw i64 [[INDVAR0_NEXT]], [[INDVAR1_NEXT]]
; CHECK-NEXT:    [[OUTER_COND:%.*]] = icmp slt i64 [[OUTER_INDVAR_ADD]], 150
; CHECK-NEXT:    br i1 [[OUTER_COND]], label [[FOR_COND2_PREHEADER]], label [[FOR_BODY4_SPLIT]]
; CHECK:       for.cond.for.end9_crit_edge:
; CHECK-NEXT:    [[OR_LCSSA_LCSSA:%.*]] = phi i32 [ [[OR_LCSSA]], [[FOR_BODY4_SPLIT]] ]
; CHECK-NEXT:    store i32 [[OR_LCSSA_LCSSA]], i32* @a, align 4
; CHECK-NEXT:    br label [[FOR_END9:%.*]]
; CHECK:       for.end9:
; CHECK-NEXT:    ret void
;
entry:
  %a = load i32, i32* @a, align 4
  br label %for.cond2.preheader

for.cond2.preheader:                              ; preds = %entry, %for.inc7
  %indvar0 = phi i64 [ 0, %entry ], [ %indvar0.next, %for.inc7 ]
  %or.reduction = phi i32 [ %a, %entry ], [ %or.lcssa, %for.inc7 ]
  %indvar1 = phi i64 [ 1, %entry ], [ %indvar1.next, %for.inc7 ]
  %index0 = add nsw i64 %indvar0, 9
  br label %for.body4

for.body4:                                        ; preds = %for.cond2.preheader, %for.body4
  %indvars.iv = phi i64 [ 5, %for.cond2.preheader ], [ %indvars.iv.next, %for.body4 ]
  %or13 = phi i32 [ %or.reduction, %for.cond2.preheader ], [ %or, %for.body4 ]
  %index1 = add nsw i64 %indvars.iv, %indvar1
  %arrayidx6 = getelementptr inbounds [200 x [100 x i32]], [200 x [100 x i32]]* @b, i64 0, i64 %index1, i64 %index0
  %load.val = load i32, i32* %arrayidx6, align 4
  %or = or i32 %or13, %load.val
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  %tobool3 = icmp eq i64 %indvars.iv.next, 0
  br i1 %tobool3, label %for.inc7, label %for.body4

for.inc7:                                         ; preds = %for.body4
  %or.lcssa = phi i32 [ %or, %for.body4 ]
  %indvar0.next = add nsw i64 %indvar0, 1
  %indvar1.next = add nsw i64 %indvar1, 1
  %outer.indvar.add = add nsw i64 %indvar0.next, %indvar1.next
  %outer.cond = icmp slt i64 %outer.indvar.add, 150
  br i1 %outer.cond, label %for.cond2.preheader, label %for.cond.for.end9_crit_edge

for.cond.for.end9_crit_edge:                      ; preds = %for.inc7
  %or.lcssa.lcssa = phi i32 [ %or.lcssa, %for.inc7 ]
  store i32 %or.lcssa.lcssa, i32* @a, align 4
  br label %for.end9

for.end9:                                         ; preds = %for.cond.for.end9_crit_edge, %entry
  ret void
}
