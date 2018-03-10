; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; PR4374

define float @test1(float %a, float %b) nounwind {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[T1:%.*]] = fsub float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fsub float -0.000000e+00, [[T1]]
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %a, %b
  %t2 = fsub float -0.000000e+00, %t1
  ret float %t2
}

; <rdar://problem/7530098>

define double @test2(double %x, double %y) nounwind {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[T1:%.*]] = fadd double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fsub double [[X]], [[T1]]
; CHECK-NEXT:    ret double [[T2]]
;
  %t1 = fadd double %x, %y
  %t2 = fsub double %x, %t1
  ret double %t2
}

