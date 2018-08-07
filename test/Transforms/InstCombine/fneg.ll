; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(float)

; -(X * C) --> X * (-C)

define float @fmul_fneg(float %x) {
; CHECK-LABEL: @fmul_fneg(
; CHECK-NEXT:    [[M:%.*]] = fmul float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[M]]
; CHECK-NEXT:    ret float [[R]]
;
  %m = fmul float %x, 42.0
  %r = fsub float -0.0, %m
  ret float %r
}

; Extra use is ok.

define float @fmul_fneg_extra_use(float %x) {
; CHECK-LABEL: @fmul_fneg_extra_use(
; CHECK-NEXT:    [[M:%.*]] = fmul float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[M]]
; CHECK-NEXT:    call void @use(float [[M]])
; CHECK-NEXT:    ret float [[R]]
;
  %m = fmul float %x, 42.0
  %r = fsub float -0.0, %m
  call void @use(float %m)
  ret float %r
}

; Try a vector. Use special constants (NaN, INF, undef) because they don't change anything.

define <4 x double> @fmul_fneg_vec(<4 x double> %x) {
; CHECK-LABEL: @fmul_fneg_vec(
; CHECK-NEXT:    [[M:%.*]] = fmul <4 x double> [[X:%.*]], <double 4.200000e+01, double 0xFF80000000000000, double 0x7FF0000000000000, double undef>
; CHECK-NEXT:    [[R:%.*]] = fsub <4 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, [[M]]
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %m = fmul <4 x double> %x, <double 42.0, double 0x7FF80000000000000, double 0x7FF0000000000000, double undef>
  %r = fsub <4 x double> <double -0.0, double -0.0, double -0.0, double -0.0>, %m
  ret <4 x double> %r
}

; -(X / C) --> X / (-C)

define float @fdiv_op1_constant_fneg(float %x) {
; CHECK-LABEL: @fdiv_op1_constant_fneg(
; CHECK-NEXT:    [[D:%.*]] = fdiv float [[X:%.*]], -4.200000e+01
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[D]]
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float %x, -42.0
  %r = fsub float -0.0, %d
  ret float %r
}

; Extra use is ok.

define float @fdiv_op1_constant_fneg_extra_use(float %x) {
; CHECK-LABEL: @fdiv_op1_constant_fneg_extra_use(
; CHECK-NEXT:    [[D:%.*]] = fdiv float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[D]]
; CHECK-NEXT:    call void @use(float [[D]])
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float %x, 42.0
  %r = fsub float -0.0, %d
  call void @use(float %d)
  ret float %r
}

; Try a vector. Use special constants (NaN, INF, undef) because they don't change anything.

define <4 x double> @fdiv_op1_constant_fneg_vec(<4 x double> %x) {
; CHECK-LABEL: @fdiv_op1_constant_fneg_vec(
; CHECK-NEXT:    [[D:%.*]] = fdiv <4 x double> [[X:%.*]], <double -4.200000e+01, double 0xFFF800000ABCD000, double 0xFFF0000000000000, double undef>
; CHECK-NEXT:    [[R:%.*]] = fsub <4 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, [[D]]
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %d = fdiv <4 x double> %x, <double -42.0, double 0xFFF800000ABCD000, double 0xFFF0000000000000, double undef>
  %r = fsub <4 x double> <double -0.0, double -0.0, double -0.0, double -0.0>, %d
  ret <4 x double> %r
}

; -(C / X) --> (-C) / X

define float @fdiv_op0_constant_fneg(float %x) {
; CHECK-LABEL: @fdiv_op0_constant_fneg(
; CHECK-NEXT:    [[D:%.*]] = fdiv float 4.200000e+01, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[D]]
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float 42.0, %x
  %r = fsub float -0.0, %d
  ret float %r
}

; Extra use is ok.

define float @fdiv_op0_constant_fneg_extra_use(float %x) {
; CHECK-LABEL: @fdiv_op0_constant_fneg_extra_use(
; CHECK-NEXT:    [[D:%.*]] = fdiv float -4.200000e+01, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[D]]
; CHECK-NEXT:    call void @use(float [[D]])
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float -42.0, %x
  %r = fsub float -0.0, %d
  call void @use(float %d)
  ret float %r
}

; Try a vector. Use special constants (NaN, INF, undef) because they don't change anything.

define <4 x double> @fdiv_op0_constant_fneg_vec(<4 x double> %x) {
; CHECK-LABEL: @fdiv_op0_constant_fneg_vec(
; CHECK-NEXT:    [[D:%.*]] = fdiv <4 x double> <double -4.200000e+01, double 0xFF80000000000000, double 0xFFF0000000000000, double undef>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fsub <4 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, [[D]]
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %d = fdiv <4 x double> <double -42.0, double 0x7FF80000000000000, double 0xFFF0000000000000, double undef>, %x
  %r = fsub <4 x double> <double -0.0, double -0.0, double -0.0, double -0.0>, %d
  ret <4 x double> %r
}

