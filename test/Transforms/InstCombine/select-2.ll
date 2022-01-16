; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Make sure instcombine don't fold select into operands. We don't want to emit
; select of two integers unless it's selecting 0 / 1.

define i32 @t1(i32 %c, i32 %x) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[T1:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[T2:%.*]] = lshr i32 [[X:%.*]], 18
; CHECK-NEXT:    [[T3:%.*]] = select i1 [[T1]], i32 [[T2]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t1 = icmp eq i32 %c, 0
  %t2 = lshr i32 %x, 18
  %t3 = select i1 %t1, i32 %t2, i32 %x
  ret i32 %t3
}

define i32 @t2(i32 %c, i32 %x) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[T1:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[X:%.*]], 18
; CHECK-NEXT:    [[T3:%.*]] = select i1 [[T1]], i32 [[T2]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t1 = icmp eq i32 %c, 0
  %t2 = and i32 %x, 18
  %t3 = select i1 %t1, i32 %t2, i32 %x
  ret i32 %t3
}

define float @t3(float %x, float %y) {
; CHECK-LABEL: @t3(
; CHECK-NEXT:    [[T1:%.*]] = fcmp ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[X_OP:%.*]] = fadd fast float [[X]], 1.000000e+00
; CHECK-NEXT:    [[T3:%.*]] = select i1 [[T1]], float [[X_OP]], float 2.000000e+00
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fcmp ogt float %x, %y
  %t2 = select i1 %t1, float %x, float 1.0
  %t3 = fadd fast float %t2, 1.0
  ret float %t3
}
