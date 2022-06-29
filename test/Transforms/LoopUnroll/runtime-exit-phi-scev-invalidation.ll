; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='loop-unroll<runtime>' -S %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-ni:1-p2:32:8:8:32-ni:2"

; Make sure SCEVs for phis are properly invalidated after phis are modified.

declare void @llvm.experimental.deoptimize.isVoid(...)

declare i32 @get()

define void @pr56282() {
; CHECK-LABEL: @pr56282(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    [[OUTER_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[OUTER_IV_NEXT:%.*]], [[INNER_2:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[OUTER_IV]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = freeze i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[TMP1]], -1
; CHECK-NEXT:    [[XTRAITER:%.*]] = and i64 [[TMP1]], 7
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ult i64 [[TMP2]], 7
; CHECK-NEXT:    br i1 [[TMP3]], label [[OUTER_MIDDLE_UNR_LCSSA:%.*]], label [[OUTER_HEADER_NEW:%.*]]
; CHECK:       outer.header.new:
; CHECK-NEXT:    [[UNROLL_ITER:%.*]] = sub i64 [[TMP1]], [[XTRAITER]]
; CHECK-NEXT:    br label [[INNER_1_HEADER:%.*]]
; CHECK:       inner.1.header:
; CHECK-NEXT:    [[INNER_1_IV:%.*]] = phi i64 [ 0, [[OUTER_HEADER_NEW]] ], [ [[INNER_1_IV_NEXT_7:%.*]], [[INNER_1_LATCH_7:%.*]] ]
; CHECK-NEXT:    [[NITER:%.*]] = phi i64 [ 0, [[OUTER_HEADER_NEW]] ], [ [[NITER_NEXT_7:%.*]], [[INNER_1_LATCH_7]] ]
; CHECK-NEXT:    [[INNER_1_IV_NEXT:%.*]] = add nuw nsw i64 [[INNER_1_IV]], 1
; CHECK-NEXT:    [[V:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1:%.*]] = icmp ugt i32 [[V]], 0
; CHECK-NEXT:    br i1 [[C_1]], label [[INNER_1_LATCH:%.*]], label [[EXIT_DEOPT_LOOPEXIT:%.*]]
; CHECK:       inner.1.latch:
; CHECK-NEXT:    [[NITER_NEXT:%.*]] = add nuw nsw i64 [[NITER]], 1
; CHECK-NEXT:    [[INNER_1_IV_NEXT_1:%.*]] = add nuw nsw i64 [[INNER_1_IV_NEXT]], 1
; CHECK-NEXT:    [[V_1:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_1:%.*]] = icmp ugt i32 [[V_1]], 0
; CHECK-NEXT:    br i1 [[C_1_1]], label [[INNER_1_LATCH_1:%.*]], label [[EXIT_DEOPT_LOOPEXIT]]
; CHECK:       inner.1.latch.1:
; CHECK-NEXT:    [[NITER_NEXT_1:%.*]] = add nuw nsw i64 [[NITER_NEXT]], 1
; CHECK-NEXT:    [[INNER_1_IV_NEXT_2:%.*]] = add nuw nsw i64 [[INNER_1_IV_NEXT_1]], 1
; CHECK-NEXT:    [[V_2:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_2:%.*]] = icmp ugt i32 [[V_2]], 0
; CHECK-NEXT:    br i1 [[C_1_2]], label [[INNER_1_LATCH_2:%.*]], label [[EXIT_DEOPT_LOOPEXIT]]
; CHECK:       inner.1.latch.2:
; CHECK-NEXT:    [[NITER_NEXT_2:%.*]] = add nuw nsw i64 [[NITER_NEXT_1]], 1
; CHECK-NEXT:    [[INNER_1_IV_NEXT_3:%.*]] = add nuw nsw i64 [[INNER_1_IV_NEXT_2]], 1
; CHECK-NEXT:    [[V_3:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_3:%.*]] = icmp ugt i32 [[V_3]], 0
; CHECK-NEXT:    br i1 [[C_1_3]], label [[INNER_1_LATCH_3:%.*]], label [[EXIT_DEOPT_LOOPEXIT]]
; CHECK:       inner.1.latch.3:
; CHECK-NEXT:    [[NITER_NEXT_3:%.*]] = add nuw nsw i64 [[NITER_NEXT_2]], 1
; CHECK-NEXT:    [[INNER_1_IV_NEXT_4:%.*]] = add nuw nsw i64 [[INNER_1_IV_NEXT_3]], 1
; CHECK-NEXT:    [[V_4:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_4:%.*]] = icmp ugt i32 [[V_4]], 0
; CHECK-NEXT:    br i1 [[C_1_4]], label [[INNER_1_LATCH_4:%.*]], label [[EXIT_DEOPT_LOOPEXIT]]
; CHECK:       inner.1.latch.4:
; CHECK-NEXT:    [[NITER_NEXT_4:%.*]] = add nuw nsw i64 [[NITER_NEXT_3]], 1
; CHECK-NEXT:    [[INNER_1_IV_NEXT_5:%.*]] = add nuw nsw i64 [[INNER_1_IV_NEXT_4]], 1
; CHECK-NEXT:    [[V_5:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_5:%.*]] = icmp ugt i32 [[V_5]], 0
; CHECK-NEXT:    br i1 [[C_1_5]], label [[INNER_1_LATCH_5:%.*]], label [[EXIT_DEOPT_LOOPEXIT]]
; CHECK:       inner.1.latch.5:
; CHECK-NEXT:    [[NITER_NEXT_5:%.*]] = add nuw nsw i64 [[NITER_NEXT_4]], 1
; CHECK-NEXT:    [[INNER_1_IV_NEXT_6:%.*]] = add nuw nsw i64 [[INNER_1_IV_NEXT_5]], 1
; CHECK-NEXT:    [[V_6:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_6:%.*]] = icmp ugt i32 [[V_6]], 0
; CHECK-NEXT:    br i1 [[C_1_6]], label [[INNER_1_LATCH_6:%.*]], label [[EXIT_DEOPT_LOOPEXIT]]
; CHECK:       inner.1.latch.6:
; CHECK-NEXT:    [[NITER_NEXT_6:%.*]] = add nuw nsw i64 [[NITER_NEXT_5]], 1
; CHECK-NEXT:    [[INNER_1_IV_NEXT_7]] = add nuw nsw i64 [[INNER_1_IV_NEXT_6]], 1
; CHECK-NEXT:    [[V_7:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_7:%.*]] = icmp ugt i32 [[V_7]], 0
; CHECK-NEXT:    br i1 [[C_1_7]], label [[INNER_1_LATCH_7]], label [[EXIT_DEOPT_LOOPEXIT]]
; CHECK:       inner.1.latch.7:
; CHECK-NEXT:    [[NITER_NEXT_7]] = add i64 [[NITER_NEXT_6]], 1
; CHECK-NEXT:    [[NITER_NCMP_7:%.*]] = icmp ne i64 [[NITER_NEXT_7]], [[UNROLL_ITER]]
; CHECK-NEXT:    br i1 [[NITER_NCMP_7]], label [[INNER_1_HEADER]], label [[OUTER_MIDDLE_UNR_LCSSA_LOOPEXIT:%.*]]
; CHECK:       outer.middle.unr-lcssa.loopexit:
; CHECK-NEXT:    [[V_LCSSA1_PH_PH:%.*]] = phi i32 [ [[V_7]], [[INNER_1_LATCH_7]] ]
; CHECK-NEXT:    [[INNER_1_IV_UNR_PH:%.*]] = phi i64 [ [[INNER_1_IV_NEXT_7]], [[INNER_1_LATCH_7]] ]
; CHECK-NEXT:    br label [[OUTER_MIDDLE_UNR_LCSSA]]
; CHECK:       outer.middle.unr-lcssa:
; CHECK-NEXT:    [[V_LCSSA1_PH:%.*]] = phi i32 [ undef, [[OUTER_HEADER]] ], [ [[V_LCSSA1_PH_PH]], [[OUTER_MIDDLE_UNR_LCSSA_LOOPEXIT]] ]
; CHECK-NEXT:    [[INNER_1_IV_UNR:%.*]] = phi i64 [ 0, [[OUTER_HEADER]] ], [ [[INNER_1_IV_UNR_PH]], [[OUTER_MIDDLE_UNR_LCSSA_LOOPEXIT]] ]
; CHECK-NEXT:    [[LCMP_MOD:%.*]] = icmp ne i64 [[XTRAITER]], 0
; CHECK-NEXT:    br i1 [[LCMP_MOD]], label [[INNER_1_HEADER_EPIL_PREHEADER:%.*]], label [[OUTER_MIDDLE:%.*]]
; CHECK:       inner.1.header.epil.preheader:
; CHECK-NEXT:    br label [[INNER_1_HEADER_EPIL:%.*]]
; CHECK:       inner.1.header.epil:
; CHECK-NEXT:    [[INNER_1_IV_EPIL:%.*]] = phi i64 [ [[INNER_1_IV_UNR]], [[INNER_1_HEADER_EPIL_PREHEADER]] ], [ [[INNER_1_IV_NEXT_EPIL:%.*]], [[INNER_1_LATCH_EPIL:%.*]] ]
; CHECK-NEXT:    [[EPIL_ITER:%.*]] = phi i64 [ 0, [[INNER_1_HEADER_EPIL_PREHEADER]] ], [ [[EPIL_ITER_NEXT:%.*]], [[INNER_1_LATCH_EPIL]] ]
; CHECK-NEXT:    [[INNER_1_IV_NEXT_EPIL]] = add nuw nsw i64 [[INNER_1_IV_EPIL]], 1
; CHECK-NEXT:    [[V_EPIL:%.*]] = call i32 @get()
; CHECK-NEXT:    [[C_1_EPIL:%.*]] = icmp ugt i32 [[V_EPIL]], 0
; CHECK-NEXT:    br i1 [[C_1_EPIL]], label [[INNER_1_LATCH_EPIL]], label [[EXIT_DEOPT_LOOPEXIT3:%.*]]
; CHECK:       inner.1.latch.epil:
; CHECK-NEXT:    [[C_2_EPIL:%.*]] = icmp ult i64 [[INNER_1_IV_EPIL]], [[OUTER_IV]]
; CHECK-NEXT:    [[EPIL_ITER_NEXT]] = add i64 [[EPIL_ITER]], 1
; CHECK-NEXT:    [[EPIL_ITER_CMP:%.*]] = icmp ne i64 [[EPIL_ITER_NEXT]], [[XTRAITER]]
; CHECK-NEXT:    br i1 [[EPIL_ITER_CMP]], label [[INNER_1_HEADER_EPIL]], label [[OUTER_MIDDLE_EPILOG_LCSSA:%.*]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       outer.middle.epilog-lcssa:
; CHECK-NEXT:    [[V_LCSSA1_PH2:%.*]] = phi i32 [ [[V_EPIL]], [[INNER_1_LATCH_EPIL]] ]
; CHECK-NEXT:    br label [[OUTER_MIDDLE]]
; CHECK:       outer.middle:
; CHECK-NEXT:    [[V_LCSSA1:%.*]] = phi i32 [ [[V_LCSSA1_PH]], [[OUTER_MIDDLE_UNR_LCSSA]] ], [ [[V_LCSSA1_PH2]], [[OUTER_MIDDLE_EPILOG_LCSSA]] ]
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[V_LCSSA1]], 0
; CHECK-NEXT:    br i1 [[C_3]], label [[INNER_2_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       inner.2.preheader:
; CHECK-NEXT:    br label [[INNER_2]]
; CHECK:       inner.2:
; CHECK-NEXT:    [[OUTER_IV_NEXT]] = add nuw nsw i64 [[OUTER_IV]], 1
; CHECK-NEXT:    br label [[OUTER_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       exit.deopt.loopexit:
; CHECK-NEXT:    br label [[EXIT_DEOPT:%.*]]
; CHECK:       exit.deopt.loopexit3:
; CHECK-NEXT:    br label [[EXIT_DEOPT]]
; CHECK:       exit.deopt:
; CHECK-NEXT:    call void (...) @llvm.experimental.deoptimize.isVoid(i32 0) [ "deopt"() ]
; CHECK-NEXT:    ret void
;
entry:
  br label %outer.header

outer.header:
  %outer.iv = phi i64 [ 0, %entry ], [ %outer.iv.next, %outer.latch ]
  br label %inner.1.header

inner.1.header:
  %inner.1.iv = phi i64 [ 0, %outer.header ], [ %inner.1.iv.next, %inner.1.latch ]
  %inner.1.iv.next = add nuw nsw i64 %inner.1.iv, 1
  %v = call i32 @get()
  %c.1 = icmp ugt i32 %v, 0
  br i1 %c.1, label %inner.1.latch, label %exit.deopt

inner.1.latch:                                    ; preds = %inner.1.header
  %c.2 = icmp ult i64 %inner.1.iv, %outer.iv
  br i1 %c.2, label %inner.1.header, label %outer.middle

outer.middle:
  %c.3 = icmp ugt i32 %v, 0
  br i1 %c.3, label %inner.2, label %exit

inner.2:
  %inner.2.iv = phi i64 [ 0, %outer.middle ], [ %inner.2.iv.next, %inner.2 ]
  %inner.2.iv.next = add nsw i64 %inner.2.iv, -1
  %iv.trunc = trunc i64 %inner.2.iv to i32
  %c.4 = icmp ult i32 %v, %iv.trunc
  br i1 %c.4, label %inner.2, label %outer.latch

outer.latch:
  %outer.iv.next = add nuw nsw i64 %outer.iv, 1
  br label %outer.header

exit:
  ret void

exit.deopt:
  call void (...) @llvm.experimental.deoptimize.isVoid(i32 0) [ "deopt"() ]
  ret void
}
