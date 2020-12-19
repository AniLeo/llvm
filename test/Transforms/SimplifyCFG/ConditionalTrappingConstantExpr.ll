; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s

@G = extern_weak global i32

; PR3354
; Do not merge bb1 into the entry block, it might trap.

define i32 @admiral(i32 %a, i32 %b) {
; CHECK-LABEL: @admiral(
; CHECK-NEXT:    [[C:%.*]] = icmp sle i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[BB2:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[D:%.*]] = icmp sgt i32 sdiv (i32 -32768, i32 ptrtoint (i32* @G to i32)), 0
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[D]], i32 927, i32 42
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[MERGE:%.*]] = phi i32 [ 42, [[TMP0:%.*]] ], [ [[SPEC_SELECT]], [[BB1]] ]
; CHECK-NEXT:    ret i32 [[MERGE]]
;
  %c = icmp sle i32 %a, %b
  br i1 %c, label %bb2, label %bb1
bb1:
  %d = icmp sgt i32 sdiv (i32 -32768, i32 ptrtoint (i32* @G to i32)), 0
  br i1 %d, label %bb6, label %bb2
bb2:
  ret i32 42
bb6:
  ret i32 927
}

define i32 @ackbar(i1 %c) {
; CHECK-LABEL: @ackbar(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB5:%.*]], label [[BB6:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 icmp sgt (i32 sdiv (i32 32767, i32 ptrtoint (i32* @G to i32)), i32 0), i32 42, i32 927
; CHECK-NEXT:    br label [[BB6]]
; CHECK:       bb6:
; CHECK-NEXT:    [[MERGE:%.*]] = phi i32 [ 42, [[TMP0:%.*]] ], [ [[SPEC_SELECT]], [[BB5]] ]
; CHECK-NEXT:    ret i32 [[MERGE]]
;
  br i1 %c, label %bb5, label %bb6
bb5:
  br i1 icmp sgt (i32 sdiv (i32 32767, i32 ptrtoint (i32* @G to i32)), i32 0), label %bb6, label %bb7
bb6:
  ret i32 42
bb7:
  ret i32 927
}

; FP ops don't trap by default, so this is safe to hoist.

define i32 @tarp(i1 %c) {
; CHECK-LABEL: @tarp(
; CHECK-NEXT:  bb9:
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 fcmp oeq (float fdiv (float 3.000000e+00, float sitofp (i32 ptrtoint (i32* @G to i32) to float)), float 1.000000e+00), i32 42, i32 927
; CHECK-NEXT:    [[MERGE:%.*]] = select i1 [[C:%.*]], i32 [[SPEC_SELECT]], i32 42
; CHECK-NEXT:    ret i32 [[MERGE]]
;
  br i1 %c, label %bb8, label %bb9
bb8:
  br i1 fcmp oeq (float fdiv (float 3.0, float sitofp (i32 ptrtoint (i32* @G to i32) to float)), float 1.0), label %bb9, label %bb10
bb9:
  ret i32 42
bb10:
  ret i32 927
}
