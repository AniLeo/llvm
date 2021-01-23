; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-reduce -S < %s | FileCheck %s
; We find it is very bad to allow LSR formula containing SCEVAddRecExpr Reg
; from siblings of current loop. When one loop is LSR optimized, it can
; insert lsr.iv for other sibling loops, which sometimes leads to many extra
; lsr.iv inserted for loops.

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@cond = common local_unnamed_addr global i64 0, align 8

; Check there is no extra lsr.iv generated in foo.
define void @foo(i64 %N) local_unnamed_addr {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[DO_BODY:%.*]]
; CHECK:       do.body:
; CHECK-NEXT:    [[I_0:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[DO_BODY]] ]
; CHECK-NEXT:    tail call void @goo(i64 [[I_0]], i64 [[I_0]])
; CHECK-NEXT:    [[INC]] = add nuw i64 [[I_0]], 1
; CHECK-NEXT:    [[T0:%.*]] = load i64, i64* @cond, align 8
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[T0]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[DO_BODY2_PREHEADER:%.*]], label [[DO_BODY]]
; CHECK:       do.body2.preheader:
; CHECK-NEXT:    br label [[DO_BODY2:%.*]]
; CHECK:       do.body2:
; CHECK-NEXT:    [[I_1:%.*]] = phi i64 [ [[INC3:%.*]], [[DO_BODY2]] ], [ 0, [[DO_BODY2_PREHEADER]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INC]], [[I_1]]
; CHECK-NEXT:    tail call void @goo(i64 [[I_1]], i64 [[TMP0]])
; CHECK-NEXT:    [[INC3]] = add nuw i64 [[I_1]], 1
; CHECK-NEXT:    [[T1:%.*]] = load i64, i64* @cond, align 8
; CHECK-NEXT:    [[TOBOOL6:%.*]] = icmp eq i64 [[T1]], 0
; CHECK-NEXT:    br i1 [[TOBOOL6]], label [[DO_BODY8_PREHEADER:%.*]], label [[DO_BODY2]]
; CHECK:       do.body8.preheader:
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INC]], [[INC3]]
; CHECK-NEXT:    br label [[DO_BODY8:%.*]]
; CHECK:       do.body8:
; CHECK-NEXT:    [[I_2:%.*]] = phi i64 [ [[INC9:%.*]], [[DO_BODY8]] ], [ 0, [[DO_BODY8_PREHEADER]] ]
; CHECK-NEXT:    [[J_2:%.*]] = phi i64 [ [[INC10:%.*]], [[DO_BODY8]] ], [ [[TMP1]], [[DO_BODY8_PREHEADER]] ]
; CHECK-NEXT:    tail call void @goo(i64 [[I_2]], i64 [[J_2]])
; CHECK-NEXT:    [[INC9]] = add nuw nsw i64 [[I_2]], 1
; CHECK-NEXT:    [[INC10]] = add i64 [[J_2]], 1
; CHECK-NEXT:    [[T2:%.*]] = load i64, i64* @cond, align 8
; CHECK-NEXT:    [[TOBOOL12:%.*]] = icmp eq i64 [[T2]], 0
; CHECK-NEXT:    br i1 [[TOBOOL12]], label [[DO_BODY14_PREHEADER:%.*]], label [[DO_BODY8]]
; CHECK:       do.body14.preheader:
; CHECK-NEXT:    br label [[DO_BODY14:%.*]]
; CHECK:       do.body14:
; CHECK-NEXT:    [[I_3:%.*]] = phi i64 [ [[INC15:%.*]], [[DO_BODY14]] ], [ 0, [[DO_BODY14_PREHEADER]] ]
; CHECK-NEXT:    [[J_3:%.*]] = phi i64 [ [[INC16:%.*]], [[DO_BODY14]] ], [ [[INC10]], [[DO_BODY14_PREHEADER]] ]
; CHECK-NEXT:    tail call void @goo(i64 [[I_3]], i64 [[J_3]])
; CHECK-NEXT:    [[INC15]] = add nuw nsw i64 [[I_3]], 1
; CHECK-NEXT:    [[INC16]] = add i64 [[J_3]], 1
; CHECK-NEXT:    [[T3:%.*]] = load i64, i64* @cond, align 8
; CHECK-NEXT:    [[TOBOOL18:%.*]] = icmp eq i64 [[T3]], 0
; CHECK-NEXT:    br i1 [[TOBOOL18]], label [[DO_BODY20_PREHEADER:%.*]], label [[DO_BODY14]]
; CHECK:       do.body20.preheader:
; CHECK-NEXT:    br label [[DO_BODY20:%.*]]
; CHECK:       do.body20:
; CHECK-NEXT:    [[I_4:%.*]] = phi i64 [ [[INC21:%.*]], [[DO_BODY20]] ], [ 0, [[DO_BODY20_PREHEADER]] ]
; CHECK-NEXT:    [[J_4:%.*]] = phi i64 [ [[INC22:%.*]], [[DO_BODY20]] ], [ [[INC16]], [[DO_BODY20_PREHEADER]] ]
; CHECK-NEXT:    tail call void @goo(i64 [[I_4]], i64 [[J_4]])
; CHECK-NEXT:    [[INC21]] = add nuw nsw i64 [[I_4]], 1
; CHECK-NEXT:    [[INC22]] = add i64 [[J_4]], 1
; CHECK-NEXT:    [[T4:%.*]] = load i64, i64* @cond, align 8
; CHECK-NEXT:    [[TOBOOL24:%.*]] = icmp eq i64 [[T4]], 0
; CHECK-NEXT:    br i1 [[TOBOOL24]], label [[DO_BODY26_PREHEADER:%.*]], label [[DO_BODY20]]
; CHECK:       do.body26.preheader:
; CHECK-NEXT:    br label [[DO_BODY26:%.*]]
; CHECK:       do.body26:
; CHECK-NEXT:    [[I_5:%.*]] = phi i64 [ [[INC27:%.*]], [[DO_BODY26]] ], [ 0, [[DO_BODY26_PREHEADER]] ]
; CHECK-NEXT:    [[J_5:%.*]] = phi i64 [ [[INC28:%.*]], [[DO_BODY26]] ], [ [[INC22]], [[DO_BODY26_PREHEADER]] ]
; CHECK-NEXT:    tail call void @goo(i64 [[I_5]], i64 [[J_5]])
; CHECK-NEXT:    [[INC27]] = add nuw nsw i64 [[I_5]], 1
; CHECK-NEXT:    [[INC28]] = add nsw i64 [[J_5]], 1
; CHECK-NEXT:    [[T5:%.*]] = load i64, i64* @cond, align 8
; CHECK-NEXT:    [[TOBOOL30:%.*]] = icmp eq i64 [[T5]], 0
; CHECK-NEXT:    br i1 [[TOBOOL30]], label [[DO_END31:%.*]], label [[DO_BODY26]]
; CHECK:       do.end31:
; CHECK-NEXT:    ret void
;
entry:
  br label %do.body

do.body:                                          ; preds = %do.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %do.body ]
  tail call void @goo(i64 %i.0, i64 %i.0)
  %inc = add nuw nsw i64 %i.0, 1
  %t0 = load i64, i64* @cond, align 8
  %tobool = icmp eq i64 %t0, 0
  br i1 %tobool, label %do.body2.preheader, label %do.body

do.body2.preheader:                               ; preds = %do.body
  br label %do.body2

do.body2:                                         ; preds = %do.body2.preheader, %do.body2
  %i.1 = phi i64 [ %inc3, %do.body2 ], [ 0, %do.body2.preheader ]
  %j.1 = phi i64 [ %inc4, %do.body2 ], [ %inc, %do.body2.preheader ]
  tail call void @goo(i64 %i.1, i64 %j.1)
  %inc3 = add nuw nsw i64 %i.1, 1
  %inc4 = add nsw i64 %j.1, 1
  %t1 = load i64, i64* @cond, align 8
  %tobool6 = icmp eq i64 %t1, 0
  br i1 %tobool6, label %do.body8.preheader, label %do.body2

do.body8.preheader:                               ; preds = %do.body2
  br label %do.body8

do.body8:                                         ; preds = %do.body8.preheader, %do.body8
  %i.2 = phi i64 [ %inc9, %do.body8 ], [ 0, %do.body8.preheader ]
  %j.2 = phi i64 [ %inc10, %do.body8 ], [ %inc4, %do.body8.preheader ]
  tail call void @goo(i64 %i.2, i64 %j.2)
  %inc9 = add nuw nsw i64 %i.2, 1
  %inc10 = add nsw i64 %j.2, 1
  %t2 = load i64, i64* @cond, align 8
  %tobool12 = icmp eq i64 %t2, 0
  br i1 %tobool12, label %do.body14.preheader, label %do.body8

do.body14.preheader:                              ; preds = %do.body8
  br label %do.body14

do.body14:                                        ; preds = %do.body14.preheader, %do.body14
  %i.3 = phi i64 [ %inc15, %do.body14 ], [ 0, %do.body14.preheader ]
  %j.3 = phi i64 [ %inc16, %do.body14 ], [ %inc10, %do.body14.preheader ]
  tail call void @goo(i64 %i.3, i64 %j.3)
  %inc15 = add nuw nsw i64 %i.3, 1
  %inc16 = add nsw i64 %j.3, 1
  %t3 = load i64, i64* @cond, align 8
  %tobool18 = icmp eq i64 %t3, 0
  br i1 %tobool18, label %do.body20.preheader, label %do.body14

do.body20.preheader:                              ; preds = %do.body14
  br label %do.body20

do.body20:                                        ; preds = %do.body20.preheader, %do.body20
  %i.4 = phi i64 [ %inc21, %do.body20 ], [ 0, %do.body20.preheader ]
  %j.4 = phi i64 [ %inc22, %do.body20 ], [ %inc16, %do.body20.preheader ]
  tail call void @goo(i64 %i.4, i64 %j.4)
  %inc21 = add nuw nsw i64 %i.4, 1
  %inc22 = add nsw i64 %j.4, 1
  %t4 = load i64, i64* @cond, align 8
  %tobool24 = icmp eq i64 %t4, 0
  br i1 %tobool24, label %do.body26.preheader, label %do.body20

do.body26.preheader:                              ; preds = %do.body20
  br label %do.body26

do.body26:                                        ; preds = %do.body26.preheader, %do.body26
  %i.5 = phi i64 [ %inc27, %do.body26 ], [ 0, %do.body26.preheader ]
  %j.5 = phi i64 [ %inc28, %do.body26 ], [ %inc22, %do.body26.preheader ]
  tail call void @goo(i64 %i.5, i64 %j.5)
  %inc27 = add nuw nsw i64 %i.5, 1
  %inc28 = add nsw i64 %j.5, 1
  %t5 = load i64, i64* @cond, align 8
  %tobool30 = icmp eq i64 %t5, 0
  br i1 %tobool30, label %do.end31, label %do.body26

do.end31:                                         ; preds = %do.body26
  ret void
}

declare void @goo(i64, i64) local_unnamed_addr

