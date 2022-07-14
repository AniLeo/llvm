; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -indvars -replexitval=always -S | FileCheck %s
; Make sure IndVars preserves LCSSA form, especially across loop nests.

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

define void @PR18642(i32 %x) {
; CHECK-LABEL: @PR18642(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    br label [[INNER_HEADER:%.*]]
; CHECK:       inner.header:
; CHECK-NEXT:    br i1 false, label [[INNER_LATCH:%.*]], label [[OUTER_LATCH:%.*]]
; CHECK:       inner.latch:
; CHECK-NEXT:    br i1 true, label [[INNER_HEADER]], label [[EXIT_LOOPEXIT:%.*]]
; CHECK:       outer.latch:
; CHECK-NEXT:    br i1 false, label [[OUTER_HEADER]], label [[EXIT_LOOPEXIT1:%.*]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    [[INC_LCSSA:%.*]] = phi i32 [ -2147483648, [[INNER_LATCH]] ]
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit.loopexit1:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[EXIT_PHI:%.*]] = phi i32 [ [[INC_LCSSA]], [[EXIT_LOOPEXIT]] ], [ undef, [[EXIT_LOOPEXIT1]] ]
; CHECK-NEXT:    ret void
;
entry:
  br label %outer.header

outer.header:
  %outer.iv = phi i32 [ 0, %entry ], [ %x, %outer.latch ]
  br label %inner.header

inner.header:
  %inner.iv = phi i32 [ undef, %outer.header ], [ %inc, %inner.latch ]
  %cmp1 = icmp slt i32 %inner.iv, %outer.iv
  br i1 %cmp1, label %inner.latch, label %outer.latch

inner.latch:
  %inc = add nsw i32 %inner.iv, 1
  %cmp2 = icmp slt i32 %inner.iv, %outer.iv
  br i1 %cmp2, label %inner.header, label %exit

outer.latch:
  br i1 undef, label %outer.header, label %exit

exit:
  %exit.phi = phi i32 [ %inc, %inner.latch ], [ undef, %outer.latch ]
  ret void
}

define i64 @unconditional_exit_simplification(i64 %arg) {
; CHECK-LABEL: @unconditional_exit_simplification(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    [[IV2:%.*]] = phi i64 [ 0, [[LOOP1]] ], [ 1, [[LOOP2]] ]
; CHECK-NEXT:    br i1 true, label [[LOOP2]], label [[LOOP1_LATCH:%.*]]
; CHECK:       loop1.latch:
; CHECK-NEXT:    [[RES_LCSSA:%.*]] = phi i64 [ [[IV2]], [[LOOP2]] ]
; CHECK-NEXT:    br i1 false, label [[LOOP1]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES_LCSSA2:%.*]] = phi i64 [ [[RES_LCSSA]], [[LOOP1_LATCH]] ]
; CHECK-NEXT:    ret i64 [[RES_LCSSA2]]
;
entry:
  br label %loop1

loop1:
  %iv1 = phi i64 [ 0, %entry ], [ 1, %loop1.latch ]
  br label %loop2

loop2:
  %iv2 = phi i64 [ 0, %loop1 ], [ 1, %loop2 ]
  %res = add nuw nsw i64 %iv1, %iv2
  br i1 true, label %loop2, label %loop1.latch

loop1.latch:
  %res.lcssa = phi i64 [ %res, %loop2 ]
  br i1 false, label %loop1, label %exit

exit:
  %res.lcssa2 = phi i64 [ %res.lcssa, %loop1.latch ]
  ret i64 %res.lcssa2
}
