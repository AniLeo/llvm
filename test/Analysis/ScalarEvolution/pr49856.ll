; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

define void @test() {
; CHECK-LABEL: 'test'
; CHECK-NEXT:  Classifying expressions for: @test
; CHECK-NEXT:    %tmp = phi i32 [ 2, %bb ], [ %tmp2, %bb3 ]
; CHECK-NEXT:    --> %tmp U: [1,-2147483648) S: [0,-2147483648)
; CHECK-NEXT:    %tmp2 = add nuw nsw i32 %tmp, 1
; CHECK-NEXT:    --> (1 + %tmp)<nuw> U: [1,-2147483647) S: [1,-2147483647)
; CHECK-NEXT:  Determining loop execution counts for: @test
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb3, %bb
  %tmp = phi i32 [ 2, %bb ], [ %tmp2, %bb3 ]
  %tmp2 = add nuw nsw i32 %tmp, 1
  ret void

bb3:                                              ; No predecessors!
  br label %bb1
}
