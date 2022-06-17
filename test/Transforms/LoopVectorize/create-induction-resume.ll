; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=loop-vectorize < %s | FileCheck %s

; This is a regression test. Without the fix it crashes on SSAUpdater due to
; LoopVectroizer created a phi node placeholder without incoming values but
; SSAUpdater expects that phi node is completely filled.

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:1-p2:32:8:8:32-ni:2"
define void @test(i32 %arg, i32 %L1.limit, i32 %L2.switch, i1 %c) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  L1.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i32 -1, [[ARG:%.*]]
; CHECK-NEXT:    br label [[L1_HEADER:%.*]]
; CHECK:       L1.header:
; CHECK-NEXT:    [[INDUCTION_IV:%.*]] = phi i32 [ [[INDUCTION_IV_NEXT:%.*]], [[L1_BACKEDGE:%.*]] ], [ [[TMP0]], [[L1_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i32 [ [[INDVAR_NEXT:%.*]], [[L1_BACKEDGE]] ], [ 0, [[L1_PREHEADER]] ]
; CHECK-NEXT:    [[L1_SUM:%.*]] = phi i32 [ [[ARG]], [[L1_PREHEADER]] ], [ [[L1_SUM_NEXT:%.*]], [[L1_BACKEDGE]] ]
; CHECK-NEXT:    [[L1_IV:%.*]] = phi i32 [ 1, [[L1_PREHEADER]] ], [ [[L1_IV_NEXT:%.*]], [[L1_BACKEDGE]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = mul nsw i32 [[INDVAR]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], -2
; CHECK-NEXT:    br i1 [[C:%.*]], label [[L1_BACKEDGE]], label [[L1_EARLY_EXIT:%.*]]
; CHECK:       L1.backedge:
; CHECK-NEXT:    [[L1_SUM_NEXT]] = add i32 [[L1_IV]], [[L1_SUM]]
; CHECK-NEXT:    [[L1_IV_NEXT]] = add nuw nsw i32 [[L1_IV]], 1
; CHECK-NEXT:    [[L1_EXIT_COND:%.*]] = icmp ult i32 [[L1_IV_NEXT]], [[L1_LIMIT:%.*]]
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i32 [[INDVAR]], 1
; CHECK-NEXT:    [[INDUCTION_IV_NEXT]] = add i32 [[INDUCTION_IV]], [[TMP2]]
; CHECK-NEXT:    br i1 [[L1_EXIT_COND]], label [[L1_HEADER]], label [[L1_EXIT:%.*]]
; CHECK:       L1.early.exit:
; CHECK-NEXT:    ret void
; CHECK:       L1.exit:
; CHECK-NEXT:    [[INDUCTION_IV_LCSSA3:%.*]] = phi i32 [ [[INDUCTION_IV]], [[L1_BACKEDGE]] ]
; CHECK-NEXT:    [[INDUCTION_IV_LCSSA1:%.*]] = phi i32 [ [[INDUCTION_IV]], [[L1_BACKEDGE]] ]
; CHECK-NEXT:    [[L1_EXIT_VAL:%.*]] = phi i32 [ [[L1_SUM_NEXT]], [[L1_BACKEDGE]] ]
; CHECK-NEXT:    br label [[L2_HEADER:%.*]]
; CHECK:       L2.header.loopexit:
; CHECK-NEXT:    br label [[L2_HEADER_BACKEDGE:%.*]]
; CHECK:       L2.header:
; CHECK-NEXT:    switch i32 [[L2_SWITCH:%.*]], label [[L2_HEADER_BACKEDGE]] [
; CHECK-NEXT:    i32 8, label [[L2_EXIT:%.*]]
; CHECK-NEXT:    i32 20, label [[L2_INNER_HEADER_PREHEADER:%.*]]
; CHECK-NEXT:    ]
; CHECK:       L2.header.backedge:
; CHECK-NEXT:    br label [[L2_HEADER]]
; CHECK:       L2.Inner.header.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP3:%.*]] = mul i32 12, [[INDUCTION_IV_LCSSA1]]
; CHECK-NEXT:    [[IND_END:%.*]] = add i32 1, [[TMP3]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i64 [[INDEX_NEXT]], 12
; CHECK-NEXT:    br i1 [[TMP4]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 12, 12
; CHECK-NEXT:    br i1 [[CMP_N]], label [[L2_HEADER_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 1, [[L2_INNER_HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL2:%.*]] = phi i64 [ 13, [[MIDDLE_BLOCK]] ], [ 1, [[L2_INNER_HEADER_PREHEADER]] ]
; CHECK-NEXT:    br label [[L2_INNER_HEADER:%.*]]
; CHECK:       L2.Inner.header:
; CHECK-NEXT:    [[L2_ACCUM:%.*]] = phi i32 [ [[L2_ACCUM_NEXT:%.*]], [[L2_INNER_HEADER]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[L2_IV:%.*]] = phi i64 [ [[L2_IV_NEXT:%.*]], [[L2_INNER_HEADER]] ], [ [[BC_RESUME_VAL2]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[L2_ACCUM_NEXT]] = sub i32 [[L2_ACCUM]], [[L1_EXIT_VAL]]
; CHECK-NEXT:    [[L2_DUMMY_BUT_NEED_IT:%.*]] = sext i32 [[L2_ACCUM_NEXT]] to i64
; CHECK-NEXT:    [[L2_IV_NEXT]] = add nuw nsw i64 [[L2_IV]], 1
; CHECK-NEXT:    [[L2_EXIT_COND:%.*]] = icmp ugt i64 [[L2_IV]], 11
; CHECK-NEXT:    br i1 [[L2_EXIT_COND]], label [[L2_HEADER_LOOPEXIT]], label [[L2_INNER_HEADER]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       L2.exit:
; CHECK-NEXT:    ret void
;
L1.preheader:
  br label %L1.header

L1.header:                                        ; preds = %L1.preheader, %L1.backedge
  %L1.sum = phi i32 [ %arg, %L1.preheader ], [ %L1.sum.next, %L1.backedge ]
  %L1.iv = phi i32 [ 1, %L1.preheader ], [ %L1.iv.next, %L1.backedge ]
  br i1 %c, label %L1.backedge, label %L1.early.exit

L1.backedge:                                      ; preds = %L1.header
  %L1.sum.next = add i32 %L1.iv, %L1.sum
  %L1.iv.next = add nuw nsw i32 %L1.iv, 1
  %L1.exit.cond = icmp ult i32 %L1.iv.next, %L1.limit
  br i1 %L1.exit.cond, label %L1.header, label %L1.exit

L1.early.exit:                                    ; preds = %L1.header
  ret void

L1.exit:                                          ; preds = %L1.backedge
  %L1.exit.val = phi i32 [ %L1.sum.next, %L1.backedge ]
  br label %L2.header

L2.header:                                        ; preds = %L2.Inner.header, %L1.exit, %L2.header
  switch i32 %L2.switch, label %L2.header [
  i32 8, label %L2.exit
  i32 20, label %L2.Inner.header
  ]

L2.Inner.header:                                  ; preds = %L2.Inner.header, %L2.header
  %L2.accum = phi i32 [ %L2.accum.next, %L2.Inner.header ], [ 1, %L2.header ]
  %L2.iv = phi i64 [ %L2.iv.next, %L2.Inner.header ], [ 1, %L2.header ]
  %L2.accum.next = sub i32 %L2.accum, %L1.exit.val
  %L2.dummy.but.need.it = sext i32 %L2.accum.next to i64
  %L2.iv.next = add nuw nsw i64 %L2.iv, 1
  %L2.exit_cond = icmp ugt i64 %L2.iv, 11
  br i1 %L2.exit_cond, label %L2.header, label %L2.Inner.header

L2.exit:                                          ; preds = %L2.header
  ret void
}

