; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; PR1907

define i1 @test(i32 %c84.17) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[TMP2696:%.*]] = icmp ne i32 [[C84_17:%.*]], 34
; CHECK-NEXT:    [[TMP2699:%.*]] = icmp sgt i32 [[C84_17]], -1
; CHECK-NEXT:    [[TMP2703:%.*]] = and i1 [[TMP2696]], [[TMP2699]]
; CHECK-NEXT:    ret i1 [[TMP2703]]
;
  %tmp2696 = icmp ne i32 %c84.17, 34		; <i1> [#uses=2]
  %tmp2699 = icmp sgt i32 %c84.17, -1		; <i1> [#uses=1]
  %tmp2703 = and i1 %tmp2696, %tmp2699		; <i1> [#uses=1]
  ret i1 %tmp2703
}

define i1 @test_logical(i32 %c84.17) {
; CHECK-LABEL: @test_logical(
; CHECK-NEXT:    [[TMP2696:%.*]] = icmp ne i32 [[C84_17:%.*]], 34
; CHECK-NEXT:    [[TMP2699:%.*]] = icmp sgt i32 [[C84_17]], -1
; CHECK-NEXT:    [[TMP2703:%.*]] = and i1 [[TMP2696]], [[TMP2699]]
; CHECK-NEXT:    ret i1 [[TMP2703]]
;
  %tmp2696 = icmp ne i32 %c84.17, 34
  %tmp2699 = icmp sgt i32 %c84.17, -1
  %tmp2703 = select i1 %tmp2696, i1 %tmp2699, i1 false
  ret i1 %tmp2703
}
