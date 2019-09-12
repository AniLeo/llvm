; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define float @fadd_fpext_op0(float %x, double %y) {
; CHECK-LABEL: @fadd_fpext_op0(
; CHECK-NEXT:    [[EXT:%.*]] = fpext float [[X:%.*]] to double
; CHECK-NEXT:    [[BO:%.*]] = fadd reassoc double [[EXT]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fptrunc double [[BO]] to float
; CHECK-NEXT:    ret float [[R]]
;
  %ext = fpext float %x to double
  %bo = fadd reassoc double %ext, %y
  %r = fptrunc double %bo to float
  ret float %r
}

define half @fsub_fpext_op1(half %x, double %y) {
; CHECK-LABEL: @fsub_fpext_op1(
; CHECK-NEXT:    [[EXT:%.*]] = fpext half [[X:%.*]] to double
; CHECK-NEXT:    [[BO:%.*]] = fsub reassoc double [[Y:%.*]], [[EXT]]
; CHECK-NEXT:    [[R:%.*]] = fptrunc double [[BO]] to half
; CHECK-NEXT:    ret half [[R]]
;
  %ext = fpext half %x to double
  %bo = fsub reassoc double %y, %ext
  %r = fptrunc double %bo to half
  ret half %r
}

define <2 x float> @fdiv_constant_op0(<2 x double> %x) {
; CHECK-LABEL: @fdiv_constant_op0(
; CHECK-NEXT:    [[BO:%.*]] = fdiv reassoc <2 x double> <double 4.210000e+01, double -1.000000e-01>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fptrunc <2 x double> [[BO]] to <2 x float>
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %bo = fdiv reassoc <2 x double> <double 42.1, double -0.1>, %x
  %r = fptrunc <2 x double> %bo to <2 x float>
  ret <2 x float> %r
}

define <2 x half> @fmul_constant_op1(<2 x float> %x) {
; CHECK-LABEL: @fmul_constant_op1(
; CHECK-NEXT:    [[BO:%.*]] = fmul reassoc <2 x float> [[X:%.*]], <float 0x47EFFFFFE0000000, float 5.000000e-01>
; CHECK-NEXT:    [[R:%.*]] = fptrunc <2 x float> [[BO]] to <2 x half>
; CHECK-NEXT:    ret <2 x half> [[R]]
;
  %bo = fmul reassoc <2 x float> %x, <float 0x47efffffe0000000, float 0.5>
  %r = fptrunc <2 x float> %bo to <2 x half>
  ret <2 x half> %r
}
