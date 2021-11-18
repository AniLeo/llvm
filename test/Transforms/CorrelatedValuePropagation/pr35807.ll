; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=correlated-propagation -S %s | FileCheck %s

target triple = "x86_64-apple-darwin17.4.0"

define void @patatino() {
; CHECK-LABEL: @patatino(
; CHECK-NEXT:    br i1 undef, label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb4:
; CHECK-NEXT:    br i1 undef, label [[BB40:%.*]], label [[BB22:%.*]]
; CHECK:       bb7:
; CHECK-NEXT:    br label [[BB14:%.*]]
; CHECK:       bb12:
; CHECK-NEXT:    br label [[BB14]]
; CHECK:       bb14:
; CHECK-NEXT:    [[TMP19:%.*]] = icmp sgt i32 undef, undef
; CHECK-NEXT:    [[TMP20:%.*]] = select i1 [[TMP19]], i64 [[TMP20]], i64 0
; CHECK-NEXT:    br i1 undef, label [[BB40]], label [[BB7:%.*]]
; CHECK:       bb22:
; CHECK-NEXT:    br label [[BB24:%.*]]
; CHECK:       bb24:
; CHECK-NEXT:    br label [[BB32:%.*]]
; CHECK:       bb32:
; CHECK-NEXT:    br i1 undef, label [[BB40]], label [[BB24]]
; CHECK:       bb40:
; CHECK-NEXT:    [[TMP41:%.*]] = phi i64 [ 4, [[BB4]] ], [ [[TMP20]], [[BB14]] ], [ undef, [[BB32]] ]
; CHECK-NEXT:    ret void
;
  br i1 undef, label %bb3, label %bb4

bb3:
  br label %bb3

bb4:
  br i1 undef, label %bb40, label %bb22

bb7:
  br label %bb14

bb12:
  br label %bb14

; This block is unreachable. Due to the non-standard definition of
; dominance in LLVM where uses in unreachable blocks are dominated
; by anything, it contains an instruction of the form
; %def = OP %def, %something
bb14:
  %tmp19 = icmp sgt i32 undef, undef
  %tmp20 = select i1 %tmp19, i64 %tmp20, i64 0
  br i1 undef, label %bb40, label %bb7

bb22:
  br label %bb24

bb24:
  br label %bb32

bb32:
  br i1 undef, label %bb40, label %bb24

bb40:
  %tmp41 = phi i64 [ 4, %bb4 ], [ %tmp20, %bb14 ], [ undef, %bb32 ]
  ret void
}
