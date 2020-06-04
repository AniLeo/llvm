; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

define float @func1(float %a, float %b) {
; CHECK-LABEL: func1:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    fadd.s %s0, %s0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd float %a, %b
  ret float %r
}

define double @func2(double %a, double %b) {
; CHECK-LABEL: func2:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    fadd.d %s0, %s0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd double %a, %b
  ret double %r
}

define float @func4(float %a) {
; CHECK-LABEL: func4:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea.sl %s1, 1084227584
; CHECK-NEXT:    fadd.s %s0, %s0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd float %a, 5.000000e+00
  ret float %r
}

define double @func5(double %a) {
; CHECK-LABEL: func5:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea.sl %s1, 1075052544
; CHECK-NEXT:    fadd.d %s0, %s0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd double %a, 5.000000e+00
  ret double %r
}

define float @func7(float %a) {
; CHECK-LABEL: func7:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea.sl %s1, 2139095039
; CHECK-NEXT:    fadd.s %s0, %s0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd float %a, 0x47EFFFFFE0000000
  ret float %r
}

define double @func8(double %a) {
; CHECK-LABEL: func8:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, -1
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, 2146435071(, %s1)
; CHECK-NEXT:    fadd.d %s0, %s0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd double %a, 0x7FEFFFFFFFFFFFFF
  ret double %r
}

define float @fadds_imm(float %a) {
; CHECK-LABEL: fadds_imm:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    fadd.s %s0, %s0, (2)1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd float %a, -2.e+00
  ret float %r
}

define double @faddd_imm(double %a) {
; CHECK-LABEL: faddd_imm:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    fadd.d %s0, %s0, (2)1
; CHECK-NEXT:    or %s11, 0, %s9
  %r = fadd double %a, -2.e+00
  ret double %r
}
