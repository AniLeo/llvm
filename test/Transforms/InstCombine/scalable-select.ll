; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

; This test checks a regression in the select operand folding combine, in which
; Constant::getUniqueInteger would crash for a scalable-vector zeroinitializer.
define <vscale x 1 x i32> @select_opt(<vscale x 1 x i32> %b, <vscale x 1 x i1> %m) {
; CHECK-LABEL: @select_opt(
; CHECK-NEXT:    [[C:%.*]] = add nsw <vscale x 1 x i32> [[B:%.*]], shufflevector (<vscale x 1 x i32> insertelement (<vscale x 1 x i32> undef, i32 2, i32 0), <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer)
; CHECK-NEXT:    [[D:%.*]] = select <vscale x 1 x i1> [[M:%.*]], <vscale x 1 x i32> [[C]], <vscale x 1 x i32> [[B]]
; CHECK-NEXT:    ret <vscale x 1 x i32> [[D]]
;
  %head = insertelement <vscale x 1 x i32> undef, i32 2, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %c = add nsw <vscale x 1 x i32> %b, %splat
  %d = select <vscale x 1 x i1> %m, <vscale x 1 x i32> %c, <vscale x 1 x i32> %b
  ret <vscale x 1 x i32> %d
}
