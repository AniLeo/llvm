; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-unroll -verify-loop-lcssa -S | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; This test shows how unrolling an inner loop could break LCSSA for an outer
; loop, and there is no cheap way to recover it.
;
; In this case the inner loop, L3, is being unrolled. It only runs one
; iteration, so unrolling basically means replacing
;   br i1 true, label %exit, label %L3_header
; with
;   br label %exit
;
; However, this change messes up the loops structure: for instance, block
; L3_body no longer belongs to L2. It becomes an exit block for L2, so LCSSA
; phis for definitions in L2 should now be placed there. In particular, we need
; to insert such a definition for %y1.

define void @foo1() {
; CHECK-LABEL: @foo1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[L1_HEADER:%.*]]
; CHECK:       L1_header:
; CHECK-NEXT:    br label [[L2_HEADER:%.*]]
; CHECK:       L2_header:
; CHECK-NEXT:    [[Y1:%.*]] = phi i64 [ undef, [[L1_HEADER]] ], [ [[X_LCSSA:%.*]], [[L2_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[L3_HEADER:%.*]]
; CHECK:       L3_header:
; CHECK-NEXT:    br i1 true, label [[L2_LATCH]], label [[L3_BODY:%.*]]
; CHECK:       L2_latch:
; CHECK-NEXT:    [[X_LCSSA]] = phi i64 [ undef, [[L3_HEADER]] ]
; CHECK-NEXT:    br label [[L2_HEADER]]
; CHECK:       L3_body:
; CHECK-NEXT:    [[Y1_LCSSA:%.*]] = phi i64 [ [[Y1]], [[L3_HEADER]] ]
; CHECK-NEXT:    store i64 [[Y1_LCSSA]], i64* undef, align 8
; CHECK-NEXT:    br i1 false, label [[L3_LATCH:%.*]], label [[L1_LATCH:%.*]]
; CHECK:       L3_latch:
; CHECK-NEXT:    ret void
; CHECK:       L1_latch:
; CHECK-NEXT:    [[Y_LCSSA:%.*]] = phi i64 [ [[Y1_LCSSA]], [[L3_BODY]] ]
; CHECK-NEXT:    br label [[L1_HEADER]]
;
entry:
  br label %L1_header

L1_header:
  br label %L2_header

L2_header:
  %y1 = phi i64 [ undef, %L1_header ], [ %x.lcssa, %L2_latch ]
  br label %L3_header

L3_header:
  %y2 = phi i64 [ 0, %L3_latch ], [ %y1, %L2_header ]
  %x = add i64 undef, -1
  br i1 true, label %L2_latch, label %L3_body

L2_latch:
  %x.lcssa = phi i64 [ %x, %L3_header ]
  br label %L2_header

L3_body:
  store i64 %y1, i64* undef
  br i1 false, label %L3_latch, label %L1_latch

L3_latch:
  br i1 true, label %exit, label %L3_header

L1_latch:
  %y.lcssa = phi i64 [ %y2, %L3_body ]
  br label %L1_header

exit:
  ret void
}

; Additional tests for some corner cases.
define void @foo2() {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[L1_HEADER:%.*]]
; CHECK:       L1_header:
; CHECK-NEXT:    br label [[L2_HEADER:%.*]]
; CHECK:       L2_header.loopexit:
; CHECK-NEXT:    [[DEC_US_LCSSA:%.*]] = phi i64 [ undef, [[L3_HEADER:%.*]] ]
; CHECK-NEXT:    br label [[L2_HEADER]]
; CHECK:       L2_header:
; CHECK-NEXT:    [[A:%.*]] = phi i64 [ undef, [[L1_HEADER]] ], [ [[DEC_US_LCSSA]], [[L2_HEADER_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    br label [[L3_HEADER]]
; CHECK:       L3_header:
; CHECK-NEXT:    br i1 true, label [[L2_HEADER_LOOPEXIT]], label [[L3_BREAK_TO_L1:%.*]]
; CHECK:       L3_break_to_L1:
; CHECK-NEXT:    [[A_LCSSA:%.*]] = phi i64 [ [[A]], [[L3_HEADER]] ]
; CHECK-NEXT:    br i1 false, label [[L3_LATCH:%.*]], label [[L1_LATCH:%.*]]
; CHECK:       L1_latch:
; CHECK-NEXT:    [[B_LCSSA:%.*]] = phi i64 [ [[A_LCSSA]], [[L3_BREAK_TO_L1]] ]
; CHECK-NEXT:    br label [[L1_HEADER]]
; CHECK:       L3_latch:
; CHECK-NEXT:    ret void
;
entry:
  br label %L1_header

L1_header:
  br label %L2_header

L2_header:
  %a = phi i64 [ undef, %L1_header ], [ %dec_us, %L3_header ]
  br label %L3_header

L3_header:
  %b = phi i64 [ 0, %L3_latch ], [ %a, %L2_header ]
  %dec_us = add i64 undef, -1
  br i1 true, label %L2_header, label %L3_break_to_L1

L3_break_to_L1:
  br i1 false, label %L3_latch, label %L1_latch

L1_latch:
  %b_lcssa = phi i64 [ %b, %L3_break_to_L1 ]
  br label %L1_header

L3_latch:
  br i1 true, label %Exit, label %L3_header

Exit:
  ret void
}

define void @foo3() {
; CHECK-LABEL: @foo3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[L1_HEADER:%.*]]
; CHECK:       L1_header:
; CHECK-NEXT:    [[A:%.*]] = phi i8* [ [[B:%.*]], [[L1_LATCH:%.*]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br i1 undef, label [[L2_HEADER_PREHEADER:%.*]], label [[L1_LATCH]]
; CHECK:       L2_header.preheader:
; CHECK-NEXT:    br label [[L2_HEADER:%.*]]
; CHECK:       L2_header:
; CHECK-NEXT:    br i1 false, label [[L2_LATCH:%.*]], label [[L1_LATCH_LOOPEXIT:%.*]]
; CHECK:       L2_latch:
; CHECK-NEXT:    [[A_LCSSA:%.*]] = phi i8* [ [[A]], [[L2_HEADER]] ]
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       L1_latch.loopexit:
; CHECK-NEXT:    br label [[L1_LATCH]]
; CHECK:       L1_latch:
; CHECK-NEXT:    [[B]] = phi i8* [ undef, [[L1_HEADER]] ], [ null, [[L1_LATCH_LOOPEXIT]] ]
; CHECK-NEXT:    br label [[L1_HEADER]]
; CHECK:       Exit:
; CHECK-NEXT:    [[A_LCSSA2:%.*]] = phi i8* [ [[A_LCSSA]], [[L2_LATCH]] ]
; CHECK-NEXT:    ret void
;
entry:
  br label %L1_header

L1_header:
  %a = phi i8* [ %b, %L1_latch ], [ null, %entry ]
  br i1 undef, label %L2_header, label %L1_latch

L2_header:
  br i1 undef, label %L2_latch, label %L1_latch

L2_latch:
  br i1 true, label %L2_exit, label %L2_header

L1_latch:
  %b = phi i8* [ undef, %L1_header ], [ null, %L2_header ]
  br label %L1_header

L2_exit:
  %a_lcssa1 = phi i8* [ %a, %L2_latch ]
  br label %Exit

Exit:
  %a_lcssa2 = phi i8* [ %a_lcssa1, %L2_exit ]
  ret void
}

; PR26688
define i8 @foo4() {
; CHECK-LABEL: @foo4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[L1_HEADER:%.*]]
; CHECK:       L1_header:
; CHECK-NEXT:    br label [[L2_HEADER:%.*]]
; CHECK:       L2_header.loopexit:
; CHECK-NEXT:    br label [[L2_HEADER]]
; CHECK:       L2_header:
; CHECK-NEXT:    br label [[L3_HEADER:%.*]]
; CHECK:       L3_header:
; CHECK-NEXT:    br i1 true, label [[L2_HEADER_LOOPEXIT:%.*]], label [[L3_EXITING:%.*]]
; CHECK:       L3_exiting:
; CHECK-NEXT:    br i1 true, label [[L3_BODY:%.*]], label [[L1_LATCH:%.*]]
; CHECK:       L3_body:
; CHECK-NEXT:    [[X_LCSSA:%.*]] = phi i1 [ false, [[L3_EXITING]] ]
; CHECK-NEXT:    br i1 [[X_LCSSA]], label [[L3_LATCH:%.*]], label [[L3_LATCH]]
; CHECK:       L3_latch:
; CHECK-NEXT:    ret i8 0
; CHECK:       L1_latch:
; CHECK-NEXT:    unreachable
;
entry:
  br label %L1_header

L1_header:
  %x = icmp eq i32 1, 0
  br label %L2_header

L2_header:
  br label %L3_header

L3_header:
  br i1 true, label %L2_header, label %L3_exiting

L3_exiting:
  br i1 true, label %L3_body, label %L1_latch

L3_body:
  br i1 %x, label %L3_latch, label %L3_latch

L3_latch:
  br i1 false, label %L3_header, label %exit

L1_latch:
  br label %L1_header

exit:
  ret i8 0
}

define void @foo5() {
; CHECK-LABEL: @foo5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER:%.*]]
; CHECK:       outer:
; CHECK-NEXT:    br label [[INNER1:%.*]]
; CHECK:       inner1:
; CHECK-NEXT:    br label [[INNER2_INDIRECT_EXIT:%.*]]
; CHECK:       inner2_indirect_exit:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ [[B:%.*]], [[INNER2_LATCH:%.*]] ], [ undef, [[INNER1]] ]
; CHECK-NEXT:    indirectbr i8* undef, [label [[INNER2_LATCH]], label [[INNER3:%.*]], label %outer_latch]
; CHECK:       inner2_latch:
; CHECK-NEXT:    [[B]] = load i32, i32* undef, align 8
; CHECK-NEXT:    br label [[INNER2_INDIRECT_EXIT]]
; CHECK:       inner3:
; CHECK-NEXT:    [[A_LCSSA:%.*]] = phi i32 [ [[A_LCSSA]], [[INNER3]] ], [ [[A]], [[INNER2_INDIRECT_EXIT]] ]
; CHECK-NEXT:    br i1 true, label [[OUTER_LATCH_LOOPEXIT:%.*]], label [[INNER3]]
; CHECK:       outer_latch.loopexit:
; CHECK-NEXT:    [[A_LCSSA_LCSSA2:%.*]] = phi i32 [ [[A_LCSSA]], [[INNER3]] ]
; CHECK-NEXT:    [[A_LCSSA_LCSSA:%.*]] = phi i32 [ [[A_LCSSA]], [[INNER3]] ]
; CHECK-NEXT:    br label [[OUTER_LATCH:%.*]]
; CHECK:       outer_latch:
; CHECK-NEXT:    br label [[OUTER]]
;
entry:
  br label %outer

outer:
  br label %inner1

inner1:
  br i1 true, label %inner2_indirect_exit.preheader, label %inner1

inner2_indirect_exit.preheader:
  br label %inner2_indirect_exit

inner2_indirect_exit:
  %a = phi i32 [ %b, %inner2_latch ], [ undef, %inner2_indirect_exit.preheader ]
  indirectbr i8* undef, [label %inner2_latch, label %inner3, label %outer_latch]

inner2_latch:
  %b = load i32, i32* undef, align 8
  br label %inner2_indirect_exit

inner3:
  %a.lcssa = phi i32 [ %a.lcssa, %inner3 ], [ %a, %inner2_indirect_exit ]
  br i1 true, label %outer_latch.loopexit, label %inner3

outer_latch.loopexit:
  %a.lcssa.lcssa = phi i32 [ %a.lcssa, %inner3 ]
  br label %outer_latch

outer_latch:
  br label %outer
}
