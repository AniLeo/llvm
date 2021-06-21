; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test merging of blocks that only have PHI nodes in them.  This tests the case
; where the mergedinto block doesn't have any PHI nodes, and is in fact
; dominated by the block-to-be-eliminated
;
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s
;

declare i1 @foo()

define i32 @test(i1 %a, i1 %b) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[C:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[C]], label [[M:%.*]], label [[P:%.*]]
; CHECK:       P:
; CHECK-NEXT:    [[D:%.*]] = call i1 @foo()
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[D]], i32 2, i32 1
; CHECK-NEXT:    br label [[M]]
; CHECK:       M:
; CHECK-NEXT:    [[W:%.*]] = phi i32 [ 0, [[TMP0:%.*]] ], [ [[SPEC_SELECT]], [[P]] ]
; CHECK-NEXT:    [[R:%.*]] = add i32 [[W]], 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = call i1 @foo()
  br i1 %c, label %N, label %P
P:
  %d = call i1 @foo()
  br i1 %d, label %N, label %Q
Q:
  br label %N
N:
  %W = phi i32 [0, %0], [1, %Q], [2, %P]
  ; This block should be foldable into M
  br label %M

M:
  %R = add i32 %W, 1
  ret i32 %R
}

