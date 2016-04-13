; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare double @fabs(double) readonly

define double @test(double %X) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[Y:%.*]] = fadd double %X, 0.000000e+00
; CHECK-NEXT:    ret double [[Y]]
;
  %Y = fadd double %X, 0.0          ;; Should be a single add x, 0.0
  %Z = fadd double %Y, 0.0
  ret double %Z
}

define double @test1(double %X) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[Y:%.*]] = call double @fabs(double %X)
; CHECK-NEXT:    ret double [[Y]]
;
  %Y = call double @fabs(double %X)
  %Z = fadd double %Y, 0.0
  ret double %Z
}
