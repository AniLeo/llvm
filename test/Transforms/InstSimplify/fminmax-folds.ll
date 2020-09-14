; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare float @llvm.minimum.f32(float, float)
declare float @llvm.maximum.f32(float, float)
declare <2 x float> @llvm.minnum.v2f32(<2 x float>, <2 x float>)
declare <2 x float> @llvm.maxnum.v2f32(<2 x float>, <2 x float>)
declare <2 x float> @llvm.minimum.v2f32(<2 x float>, <2 x float>)
declare <2 x float> @llvm.maximum.v2f32(<2 x float>, <2 x float>)

declare double @llvm.minnum.f64(double, double)
declare double @llvm.maxnum.f64(double, double)
declare <2 x double> @llvm.minnum.v2f64(<2 x double>, <2 x double>)
declare <2 x double> @llvm.maxnum.v2f64(<2 x double>, <2 x double>)
declare double @llvm.minimum.f64(double, double)
declare double @llvm.maximum.f64(double, double)
declare <2 x double> @llvm.minimum.v2f64(<2 x double>, <2 x double>)
declare <2 x double> @llvm.maximum.v2f64(<2 x double>, <2 x double>)

define float @test_minnum_const_nan(float %x) {
; CHECK-LABEL: @test_minnum_const_nan(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %r = call float @llvm.minnum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}

define float @test_maxnum_const_nan(float %x) {
; CHECK-LABEL: @test_maxnum_const_nan(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %r = call float @llvm.maxnum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}

define float @test_maximum_const_nan(float %x) {
; CHECK-LABEL: @test_maximum_const_nan(
; CHECK-NEXT:    ret float 0x7FFF000000000000
;
  %r = call float @llvm.maximum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}

define float @test_minimum_const_nan(float %x) {
; CHECK-LABEL: @test_minimum_const_nan(
; CHECK-NEXT:    ret float 0x7FFF000000000000
;
  %r = call float @llvm.minimum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}

define float @test_minnum_const_inf(float %x) {
; CHECK-LABEL: @test_minnum_const_inf(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float 0x7FF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.minnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maxnum_const_inf(float %x) {
; CHECK-LABEL: @test_maxnum_const_inf(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %r = call float @llvm.maxnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maximum_const_inf(float %x) {
; CHECK-LABEL: @test_maximum_const_inf(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float 0x7FF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.maximum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minimum_const_inf(float %x) {
; CHECK-LABEL: @test_minimum_const_inf(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float 0x7FF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.minimum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minnum_const_neg_inf(float %x) {
; CHECK-LABEL: @test_minnum_const_neg_inf(
; CHECK-NEXT:    ret float 0xFFF0000000000000
;
  %r = call float @llvm.minnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maxnum_const_neg_inf(float %x) {
; CHECK-LABEL: @test_maxnum_const_neg_inf(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float 0xFFF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.maxnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maximum_const_neg_inf(float %x) {
; CHECK-LABEL: @test_maximum_const_neg_inf(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float 0xFFF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.maximum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minimum_const_neg_inf(float %x) {
; CHECK-LABEL: @test_minimum_const_neg_inf(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float 0xFFF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.minimum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minnum_const_inf_nnan(float %x) {
; CHECK-LABEL: @test_minnum_const_inf_nnan(
; CHECK-NEXT:    [[R:%.*]] = call nnan float @llvm.minnum.f32(float [[X:%.*]], float 0x7FF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan float @llvm.minnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maxnum_const_inf_nnan(float %x) {
; CHECK-LABEL: @test_maxnum_const_inf_nnan(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %r = call nnan float @llvm.maxnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maximum_const_inf_nnan(float %x) {
; CHECK-LABEL: @test_maximum_const_inf_nnan(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %r = call nnan float @llvm.maximum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minimum_const_inf_nnan(float %x) {
; CHECK-LABEL: @test_minimum_const_inf_nnan(
; CHECK-NEXT:    [[R:%.*]] = call nnan float @llvm.minimum.f32(float [[X:%.*]], float 0x7FF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan float @llvm.minimum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minnum_const_inf_nnan_comm(float %x) {
; CHECK-LABEL: @test_minnum_const_inf_nnan_comm(
; CHECK-NEXT:    [[R:%.*]] = call nnan float @llvm.minnum.f32(float 0x7FF0000000000000, float [[X:%.*]])
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan float @llvm.minnum.f32(float 0x7ff0000000000000, float %x)
  ret float %r
}

define float @test_maxnum_const_inf_nnan_comm(float %x) {
; CHECK-LABEL: @test_maxnum_const_inf_nnan_comm(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %r = call nnan float @llvm.maxnum.f32(float 0x7ff0000000000000, float %x)
  ret float %r
}

define float @test_maximum_const_inf_nnan_comm(float %x) {
; CHECK-LABEL: @test_maximum_const_inf_nnan_comm(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %r = call nnan float @llvm.maximum.f32(float 0x7ff0000000000000, float %x)
  ret float %r
}

define float @test_minimum_const_inf_nnan_comm(float %x) {
; CHECK-LABEL: @test_minimum_const_inf_nnan_comm(
; CHECK-NEXT:    [[R:%.*]] = call nnan float @llvm.minimum.f32(float 0x7FF0000000000000, float [[X:%.*]])
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan float @llvm.minimum.f32(float 0x7ff0000000000000, float %x)
  ret float %r
}

define <2 x float> @test_minnum_const_inf_nnan_comm_vec(<2 x float> %x) {
; CHECK-LABEL: @test_minnum_const_inf_nnan_comm_vec(
; CHECK-NEXT:    [[R:%.*]] = call nnan <2 x float> @llvm.minnum.v2f32(<2 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000>, <2 x float> [[X:%.*]])
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %r = call nnan <2 x float> @llvm.minnum.v2f32(<2 x float> <float 0x7ff0000000000000, float 0x7ff0000000000000>, <2 x float> %x)
  ret <2 x float> %r
}

define <2 x float> @test_maxnum_const_inf_nnan_comm_vec(<2 x float> %x) {
; CHECK-LABEL: @test_maxnum_const_inf_nnan_comm_vec(
; CHECK-NEXT:    ret <2 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000>
;
  %r = call nnan <2 x float> @llvm.maxnum.v2f32(<2 x float> <float 0x7ff0000000000000, float 0x7ff0000000000000>, <2 x float> %x)
  ret <2 x float> %r
}

define <2 x float> @test_maximum_const_inf_nnan_comm_vec(<2 x float> %x) {
; CHECK-LABEL: @test_maximum_const_inf_nnan_comm_vec(
; CHECK-NEXT:    ret <2 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000>
;
  %r = call nnan <2 x float> @llvm.maximum.v2f32(<2 x float> <float 0x7ff0000000000000, float 0x7ff0000000000000>, <2 x float> %x)
  ret <2 x float> %r
}

define <2 x float> @test_minimum_const_inf_nnan_comm_vec(<2 x float> %x) {
; CHECK-LABEL: @test_minimum_const_inf_nnan_comm_vec(
; CHECK-NEXT:    [[R:%.*]] = call nnan <2 x float> @llvm.minimum.v2f32(<2 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000>, <2 x float> [[X:%.*]])
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %r = call nnan <2 x float> @llvm.minimum.v2f32(<2 x float> <float 0x7ff0000000000000, float 0x7ff0000000000000>, <2 x float> %x)
  ret <2 x float> %r
}

define float @test_minnum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: @test_minnum_const_neg_inf_nnan(
; CHECK-NEXT:    ret float 0xFFF0000000000000
;
  %r = call nnan float @llvm.minnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maxnum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: @test_maxnum_const_neg_inf_nnan(
; CHECK-NEXT:    [[R:%.*]] = call nnan float @llvm.maxnum.f32(float [[X:%.*]], float 0xFFF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan float @llvm.maxnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maximum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: @test_maximum_const_neg_inf_nnan(
; CHECK-NEXT:    [[R:%.*]] = call nnan float @llvm.maximum.f32(float [[X:%.*]], float 0xFFF0000000000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan float @llvm.maximum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minimum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: @test_minimum_const_neg_inf_nnan(
; CHECK-NEXT:    ret float 0xFFF0000000000000
;
  %r = call nnan float @llvm.minimum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minnum_const_max(float %x) {
; CHECK-LABEL: @test_minnum_const_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.minnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_max(float %x) {
; CHECK-LABEL: @test_maxnum_const_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.maxnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maximum_const_max(float %x) {
; CHECK-LABEL: @test_maximum_const_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.maximum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minimum_const_max(float %x) {
; CHECK-LABEL: @test_minimum_const_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.minimum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minnum_const_neg_max(float %x) {
; CHECK-LABEL: @test_minnum_const_neg_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.minnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_neg_max(float %x) {
; CHECK-LABEL: @test_maxnum_const_neg_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.maxnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maximum_const_neg_max(float %x) {
; CHECK-LABEL: @test_maximum_const_neg_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.maximum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minimum_const_neg_max(float %x) {
; CHECK-LABEL: @test_minimum_const_neg_max(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call float @llvm.minimum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minnum_const_max_ninf(float %x) {
; CHECK-LABEL: @test_minnum_const_max_ninf(
; CHECK-NEXT:    [[R:%.*]] = call ninf float @llvm.minnum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call ninf float @llvm.minnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_max_ninf(float %x) {
; CHECK-LABEL: @test_maxnum_const_max_ninf(
; CHECK-NEXT:    ret float 0x47EFFFFFE0000000
;
  %r = call ninf float @llvm.maxnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maximum_const_max_ninf(float %x) {
; CHECK-LABEL: @test_maximum_const_max_ninf(
; CHECK-NEXT:    [[R:%.*]] = call ninf float @llvm.maximum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call ninf float @llvm.maximum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minimum_const_max_ninf(float %x) {
; CHECK-LABEL: @test_minimum_const_max_ninf(
; CHECK-NEXT:    [[R:%.*]] = call ninf float @llvm.minimum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call ninf float @llvm.minimum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minnum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: @test_minnum_const_neg_max_ninf(
; CHECK-NEXT:    ret float 0xC7EFFFFFE0000000
;
  %r = call ninf float @llvm.minnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: @test_maxnum_const_neg_max_ninf(
; CHECK-NEXT:    [[R:%.*]] = call ninf float @llvm.maxnum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call ninf float @llvm.maxnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maximum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: @test_maximum_const_neg_max_ninf(
; CHECK-NEXT:    [[R:%.*]] = call ninf float @llvm.maximum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call ninf float @llvm.maximum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minimum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: @test_minimum_const_neg_max_ninf(
; CHECK-NEXT:    [[R:%.*]] = call ninf float @llvm.minimum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call ninf float @llvm.minimum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minnum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_minnum_const_max_nnan_ninf(
; CHECK-NEXT:    [[R:%.*]] = call nnan ninf float @llvm.minnum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan ninf float @llvm.minnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_maxnum_const_max_nnan_ninf(
; CHECK-NEXT:    ret float 0x47EFFFFFE0000000
;
  %r = call nnan ninf float @llvm.maxnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maximum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_maximum_const_max_nnan_ninf(
; CHECK-NEXT:    ret float 0x47EFFFFFE0000000
;
  %r = call nnan ninf float @llvm.maximum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minimum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_minimum_const_max_nnan_ninf(
; CHECK-NEXT:    [[R:%.*]] = call nnan ninf float @llvm.minimum.f32(float [[X:%.*]], float 0x47EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan ninf float @llvm.minimum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minnum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_minnum_const_neg_max_nnan_ninf(
; CHECK-NEXT:    ret float 0xC7EFFFFFE0000000
;
  %r = call nnan ninf float @llvm.minnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_maxnum_const_neg_max_nnan_ninf(
; CHECK-NEXT:    [[R:%.*]] = call nnan ninf float @llvm.maxnum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan ninf float @llvm.maxnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maximum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_maximum_const_neg_max_nnan_ninf(
; CHECK-NEXT:    [[R:%.*]] = call nnan ninf float @llvm.maximum.f32(float [[X:%.*]], float 0xC7EFFFFFE0000000)
; CHECK-NEXT:    ret float [[R]]
;
  %r = call nnan ninf float @llvm.maximum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minimum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: @test_minimum_const_neg_max_nnan_ninf(
; CHECK-NEXT:    ret float 0xC7EFFFFFE0000000
;
  %r = call nnan ninf float @llvm.minimum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

; From the LangRef for minnum/maxnum:
; "If either operand is a NaN, returns the other non-NaN operand."

define double @maxnum_nan_op0(double %x) {
; CHECK-LABEL: @maxnum_nan_op0(
; CHECK-NEXT:    ret double [[X:%.*]]
;
  %r = call double @llvm.maxnum.f64(double 0x7ff8000000000000, double %x)
  ret double %r
}

define double @maxnum_nan_op1(double %x) {
; CHECK-LABEL: @maxnum_nan_op1(
; CHECK-NEXT:    ret double [[X:%.*]]
;
  %r = call double @llvm.maxnum.f64(double %x, double 0x7ff800000000dead)
  ret double %r
}

define double @minnum_nan_op0(double %x) {
; CHECK-LABEL: @minnum_nan_op0(
; CHECK-NEXT:    ret double [[X:%.*]]
;
  %r = call double @llvm.minnum.f64(double 0x7ff8000dead00000, double %x)
  ret double %r
}

define double @minnum_nan_op1(double %x) {
; CHECK-LABEL: @minnum_nan_op1(
; CHECK-NEXT:    ret double [[X:%.*]]
;
  %r = call double @llvm.minnum.f64(double %x, double 0x7ff800dead00dead)
  ret double %r
}

define <2 x double> @maxnum_nan_op0_vec(<2 x double> %x) {
; CHECK-LABEL: @maxnum_nan_op0_vec(
; CHECK-NEXT:    ret <2 x double> [[X:%.*]]
;
  %r = call <2 x double> @llvm.maxnum.v2f64(<2 x double> <double 0x7ff8000000000000, double undef>, <2 x double> %x)
  ret <2 x double> %r
}

define <2 x double> @maxnum_nan_op1_vec(<2 x double> %x) {
; CHECK-LABEL: @maxnum_nan_op1_vec(
; CHECK-NEXT:    ret <2 x double> [[X:%.*]]
;
  %r = call <2 x double> @llvm.maxnum.v2f64(<2 x double> %x, <2 x double> <double 0x7ff800000000dead, double 0x7ff8ffffffffffff>)
  ret <2 x double> %r
}

define <2 x double> @minnum_nan_op0_vec(<2 x double> %x) {
; CHECK-LABEL: @minnum_nan_op0_vec(
; CHECK-NEXT:    ret <2 x double> [[X:%.*]]
;
  %r = call <2 x double> @llvm.minnum.v2f64(<2 x double> <double undef, double 0x7ff8000dead00000>, <2 x double> %x)
  ret <2 x double> %r
}

define <2 x double> @minnum_nan_op1_vec(<2 x double> %x) {
; CHECK-LABEL: @minnum_nan_op1_vec(
; CHECK-NEXT:    ret <2 x double> [[X:%.*]]
;
  %r = call <2 x double> @llvm.minnum.v2f64(<2 x double> %x, <2 x double> <double 0x7ff800dead00dead, double 0x7ff800dead00dead>)
  ret <2 x double> %r
}

define float @maxnum_undef_op1(float %x) {
; CHECK-LABEL: @maxnum_undef_op1(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.maxnum.f32(float %x, float undef)
  ret float %val
}

define float @maxnum_undef_op0(float %x) {
; CHECK-LABEL: @maxnum_undef_op0(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.maxnum.f32(float undef, float %x)
  ret float %val
}

define float @minnum_undef_op1(float %x) {
; CHECK-LABEL: @minnum_undef_op1(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.minnum.f32(float %x, float undef)
  ret float %val
}

define float @minnum_undef_op0(float %x) {
; CHECK-LABEL: @minnum_undef_op0(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.minnum.f32(float undef, float %x)
  ret float %val
}

define float @minnum_undef_undef(float %x) {
; CHECK-LABEL: @minnum_undef_undef(
; CHECK-NEXT:    ret float undef
;
  %val = call float @llvm.minnum.f32(float undef, float undef)
  ret float %val
}

define float @maxnum_undef_undef(float %x) {
; CHECK-LABEL: @maxnum_undef_undef(
; CHECK-NEXT:    ret float undef
;
  %val = call float @llvm.maxnum.f32(float undef, float undef)
  ret float %val
}

define float @minnum_same_args(float %x) {
; CHECK-LABEL: @minnum_same_args(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %y = call float @llvm.minnum.f32(float %x, float %x)
  ret float %y
}

define float @maxnum_same_args(float %x) {
; CHECK-LABEL: @maxnum_same_args(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %y = call float @llvm.maxnum.f32(float %x, float %x)
  ret float %y
}

define float @minnum_x_minnum_x_y(float %x, float %y) {
; CHECK-LABEL: @minnum_x_minnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %x, float %a)
  ret float %b
}

define float @minnum_y_minnum_x_y(float %x, float %y) {
; CHECK-LABEL: @minnum_y_minnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %y, float %a)
  ret float %b
}

define float @minnum_x_y_minnum_x(float %x, float %y) {
; CHECK-LABEL: @minnum_x_y_minnum_x(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %a, float %x)
  ret float %b
}

define float @minnum_x_y_minnum_y(float %x, float %y) {
; CHECK-LABEL: @minnum_x_y_minnum_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %a, float %y)
  ret float %b
}

; negative test

define float @minnum_z_minnum_x_y(float %x, float %y, float %z) {
; CHECK-LABEL: @minnum_z_minnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minnum.f32(float [[Z:%.*]], float [[A]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %z, float %a)
  ret float %b
}

; negative test

define float @minnum_x_y_minnum_z(float %x, float %y, float %z) {
; CHECK-LABEL: @minnum_x_y_minnum_z(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minnum.f32(float [[A]], float [[Z:%.*]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %a, float %z)
  ret float %b
}

; minnum(X, -INF) --> -INF

define float @minnum_neginf(float %x) {
; CHECK-LABEL: @minnum_neginf(
; CHECK-NEXT:    ret float 0xFFF0000000000000
;
  %val = call float @llvm.minnum.f32(float %x, float 0xFFF0000000000000)
  ret float %val
}

define <2 x double> @minnum_neginf_commute_vec(<2 x double> %x) {
; CHECK-LABEL: @minnum_neginf_commute_vec(
; CHECK-NEXT:    ret <2 x double> <double 0xFFF0000000000000, double 0xFFF0000000000000>
;
  %r = call <2 x double> @llvm.minnum.v2f64(<2 x double> <double 0xFFF0000000000000, double 0xFFF0000000000000>, <2 x double> %x)
  ret <2 x double> %r
}

; negative test

define float @minnum_inf(float %x) {
; CHECK-LABEL: @minnum_inf(
; CHECK-NEXT:    [[VAL:%.*]] = call float @llvm.minnum.f32(float 0x7FF0000000000000, float [[X:%.*]])
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.minnum.f32(float 0x7FF0000000000000, float %x)
  ret float %val
}
define float @maxnum_x_maxnum_x_y(float %x, float %y) {
; CHECK-LABEL: @maxnum_x_maxnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  %b = call float @llvm.maxnum.f32(float %x, float %a)
  ret float %b
}

define float @maxnum_y_maxnum_x_y(float %x, float %y) {
; CHECK-LABEL: @maxnum_y_maxnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  %b = call float @llvm.maxnum.f32(float %y, float %a)
  ret float %b
}

define float @maxnum_x_y_maxnum_x(float %x, float %y) {
; CHECK-LABEL: @maxnum_x_y_maxnum_x(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  %b = call float @llvm.maxnum.f32(float %a, float %x)
  ret float %b
}

define float @maxnum_x_y_maxnum_y(float %x, float %y) {
; CHECK-LABEL: @maxnum_x_y_maxnum_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  %b = call float @llvm.maxnum.f32(float %a, float %y)
  ret float %b
}

; negative test

define float @maxnum_z_maxnum_x_y(float %x, float %y, float %z) {
; CHECK-LABEL: @maxnum_z_maxnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.maxnum.f32(float [[Z:%.*]], float [[A]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  %b = call float @llvm.maxnum.f32(float %z, float %a)
  ret float %b
}

; negative test

define float @maxnum_x_y_maxnum_z(float %x, float %y, float %z) {
; CHECK-LABEL: @maxnum_x_y_maxnum_z(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.maxnum.f32(float [[A]], float [[Z:%.*]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  %b = call float @llvm.maxnum.f32(float %a, float %z)
  ret float %b
}

; maxnum(X, INF) --> INF

define <2 x double> @maxnum_inf(<2 x double> %x) {
; CHECK-LABEL: @maxnum_inf(
; CHECK-NEXT:    ret <2 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000>
;
  %val = call <2 x double> @llvm.maxnum.v2f64(<2 x double> %x, <2 x double><double 0x7FF0000000000000, double 0x7FF0000000000000>)
  ret <2 x double> %val
}

define float @maxnum_inf_commute(float %x) {
; CHECK-LABEL: @maxnum_inf_commute(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %val = call float @llvm.maxnum.f32(float 0x7FF0000000000000, float %x)
  ret float %val
}

; negative test

define float @maxnum_neginf(float %x) {
; CHECK-LABEL: @maxnum_neginf(
; CHECK-NEXT:    [[VAL:%.*]] = call float @llvm.maxnum.f32(float 0xFFF0000000000000, float [[X:%.*]])
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.maxnum.f32(float 0xFFF0000000000000, float %x)
  ret float %val
}

; From the LangRef for minimum/maximum:
; "If either operand is a NaN, returns NaN."

define double @maximum_nan_op0(double %x) {
; CHECK-LABEL: @maximum_nan_op0(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = call double @llvm.maximum.f64(double 0x7ff8000000000000, double %x)
  ret double %r
}

define double @maximum_nan_op1(double %x) {
; CHECK-LABEL: @maximum_nan_op1(
; CHECK-NEXT:    ret double 0x7FF800000000DEAD
;
  %r = call double @llvm.maximum.f64(double %x, double 0x7ff800000000dead)
  ret double %r
}

define double @minimum_nan_op0(double %x) {
; CHECK-LABEL: @minimum_nan_op0(
; CHECK-NEXT:    ret double 0x7FF8000DEAD00000
;
  %r = call double @llvm.minimum.f64(double 0x7ff8000dead00000, double %x)
  ret double %r
}

define double @minimum_nan_op1(double %x) {
; CHECK-LABEL: @minimum_nan_op1(
; CHECK-NEXT:    ret double 0x7FF800DEAD00DEAD
;
  %r = call double @llvm.minimum.f64(double %x, double 0x7ff800dead00dead)
  ret double %r
}

define <2 x double> @maximum_nan_op0_vec(<2 x double> %x) {
; CHECK-LABEL: @maximum_nan_op0_vec(
; CHECK-NEXT:    ret <2 x double> <double 0x7FF8000000000000, double undef>
;
  %r = call <2 x double> @llvm.maximum.v2f64(<2 x double> <double 0x7ff8000000000000, double undef>, <2 x double> %x)
  ret <2 x double> %r
}

define <2 x double> @maximum_nan_op1_vec(<2 x double> %x) {
; CHECK-LABEL: @maximum_nan_op1_vec(
; CHECK-NEXT:    ret <2 x double> <double 0x7FF800000000DEAD, double 0x7FF8FFFFFFFFFFFF>
;
  %r = call <2 x double> @llvm.maximum.v2f64(<2 x double> %x, <2 x double> <double 0x7ff800000000dead, double 0x7ff8ffffffffffff>)
  ret <2 x double> %r
}

define <2 x double> @minimum_nan_op0_vec(<2 x double> %x) {
; CHECK-LABEL: @minimum_nan_op0_vec(
; CHECK-NEXT:    ret <2 x double> <double undef, double 0x7FF8000DEAD00000>
;
  %r = call <2 x double> @llvm.minimum.v2f64(<2 x double> <double undef, double 0x7ff8000dead00000>, <2 x double> %x)
  ret <2 x double> %r
}

define <2 x double> @minimum_nan_op1_vec(<2 x double> %x) {
; CHECK-LABEL: @minimum_nan_op1_vec(
; CHECK-NEXT:    ret <2 x double> <double 0x7FF800DEAD00DEAD, double 0x7FF800DEAD00DEAD>
;
  %r = call <2 x double> @llvm.minimum.v2f64(<2 x double> %x, <2 x double> <double 0x7ff800dead00dead, double 0x7ff800dead00dead>)
  ret <2 x double> %r
}

define float @maximum_undef_op1(float %x) {
; CHECK-LABEL: @maximum_undef_op1(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.maximum.f32(float %x, float undef)
  ret float %val
}

define float @maximum_undef_op0(float %x) {
; CHECK-LABEL: @maximum_undef_op0(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.maximum.f32(float undef, float %x)
  ret float %val
}

define float @minimum_undef_op1(float %x) {
; CHECK-LABEL: @minimum_undef_op1(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.minimum.f32(float %x, float undef)
  ret float %val
}

define float @minimum_undef_op0(float %x) {
; CHECK-LABEL: @minimum_undef_op0(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %val = call float @llvm.minimum.f32(float undef, float %x)
  ret float %val
}

define float @minimum_undef_undef(float %x) {
; CHECK-LABEL: @minimum_undef_undef(
; CHECK-NEXT:    ret float undef
;
  %val = call float @llvm.minimum.f32(float undef, float undef)
  ret float %val
}

define float @maximum_undef_undef(float %x) {
; CHECK-LABEL: @maximum_undef_undef(
; CHECK-NEXT:    ret float undef
;
  %val = call float @llvm.maximum.f32(float undef, float undef)
  ret float %val
}

define float @minimum_same_args(float %x) {
; CHECK-LABEL: @minimum_same_args(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %y = call float @llvm.minimum.f32(float %x, float %x)
  ret float %y
}

define float @maximum_same_args(float %x) {
; CHECK-LABEL: @maximum_same_args(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %y = call float @llvm.maximum.f32(float %x, float %x)
  ret float %y
}

define float @minimum_x_minimum_x_y(float %x, float %y) {
; CHECK-LABEL: @minimum_x_minimum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minimum.f32(float %x, float %y)
  %b = call float @llvm.minimum.f32(float %x, float %a)
  ret float %b
}

define float @minimum_y_minimum_x_y(float %x, float %y) {
; CHECK-LABEL: @minimum_y_minimum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minimum.f32(float %x, float %y)
  %b = call float @llvm.minimum.f32(float %y, float %a)
  ret float %b
}

define float @minimum_x_y_minimum_x(float %x, float %y) {
; CHECK-LABEL: @minimum_x_y_minimum_x(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minimum.f32(float %x, float %y)
  %b = call float @llvm.minimum.f32(float %a, float %x)
  ret float %b
}

define float @minimum_x_y_minimum_y(float %x, float %y) {
; CHECK-LABEL: @minimum_x_y_minimum_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minimum.f32(float %x, float %y)
  %b = call float @llvm.minimum.f32(float %a, float %y)
  ret float %b
}

; negative test

define float @minimum_z_minimum_x_y(float %x, float %y, float %z) {
; CHECK-LABEL: @minimum_z_minimum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minimum.f32(float [[Z:%.*]], float [[A]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.minimum.f32(float %x, float %y)
  %b = call float @llvm.minimum.f32(float %z, float %a)
  ret float %b
}

; negative test

define float @minimum_x_y_minimum_z(float %x, float %y, float %z) {
; CHECK-LABEL: @minimum_x_y_minimum_z(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minimum.f32(float [[A]], float [[Z:%.*]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.minimum.f32(float %x, float %y)
  %b = call float @llvm.minimum.f32(float %a, float %z)
  ret float %b
}

define float @maximum_x_maximum_x_y(float %x, float %y) {
; CHECK-LABEL: @maximum_x_maximum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maximum.f32(float %x, float %y)
  %b = call float @llvm.maximum.f32(float %x, float %a)
  ret float %b
}

define float @maximum_y_maximum_x_y(float %x, float %y) {
; CHECK-LABEL: @maximum_y_maximum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maximum.f32(float %x, float %y)
  %b = call float @llvm.maximum.f32(float %y, float %a)
  ret float %b
}

define float @maximum_x_y_maximum_x(float %x, float %y) {
; CHECK-LABEL: @maximum_x_y_maximum_x(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maximum.f32(float %x, float %y)
  %b = call float @llvm.maximum.f32(float %a, float %x)
  ret float %b
}

define float @maximum_x_y_maximum_y(float %x, float %y) {
; CHECK-LABEL: @maximum_x_y_maximum_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.maximum.f32(float %x, float %y)
  %b = call float @llvm.maximum.f32(float %a, float %y)
  ret float %b
}

; negative test

define float @maximum_z_maximum_x_y(float %x, float %y, float %z) {
; CHECK-LABEL: @maximum_z_maximum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.maximum.f32(float [[Z:%.*]], float [[A]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.maximum.f32(float %x, float %y)
  %b = call float @llvm.maximum.f32(float %z, float %a)
  ret float %b
}

; negative test

define float @maximum_x_y_maximum_z(float %x, float %y, float %z) {
; CHECK-LABEL: @maximum_x_y_maximum_z(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maximum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.maximum.f32(float [[A]], float [[Z:%.*]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.maximum.f32(float %x, float %y)
  %b = call float @llvm.maximum.f32(float %a, float %z)
  ret float %b
}

; negative test - minimum(X, -INF) != -INF because X could be NaN

define float @minimum_neginf(float %x) {
; CHECK-LABEL: @minimum_neginf(
; CHECK-NEXT:    [[VAL:%.*]] = call float @llvm.minimum.f32(float [[X:%.*]], float 0xFFF0000000000000)
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.minimum.f32(float %x, float 0xFFF0000000000000)
  ret float %val
}

; negative test - minimum(-INF, X) != -INF because X could be NaN

define <2 x double> @minimum_neginf_commute_vec(<2 x double> %x) {
; CHECK-LABEL: @minimum_neginf_commute_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x double> @llvm.minimum.v2f64(<2 x double> <double 0xFFF0000000000000, double 0xFFF0000000000000>, <2 x double> [[X:%.*]])
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %r = call <2 x double> @llvm.minimum.v2f64(<2 x double> <double 0xFFF0000000000000, double 0xFFF0000000000000>, <2 x double> %x)
  ret <2 x double> %r
}

; TODO: minimum(INF, X) --> X

define float @minimum_inf(float %x) {
; CHECK-LABEL: @minimum_inf(
; CHECK-NEXT:    [[VAL:%.*]] = call float @llvm.minimum.f32(float 0x7FF0000000000000, float [[X:%.*]])
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.minimum.f32(float 0x7FF0000000000000, float %x)
  ret float %val
}

; negative test - maximum(X, INF) != INF because X could be NaN

define <2 x double> @maximum_inf(<2 x double> %x) {
; CHECK-LABEL: @maximum_inf(
; CHECK-NEXT:    [[VAL:%.*]] = call <2 x double> @llvm.maximum.v2f64(<2 x double> [[X:%.*]], <2 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000>)
; CHECK-NEXT:    ret <2 x double> [[VAL]]
;
  %val = call <2 x double> @llvm.maximum.v2f64(<2 x double> %x, <2 x double><double 0x7FF0000000000000, double 0x7FF0000000000000>)
  ret <2 x double> %val
}

; negative test - maximum(INF, X) != INF because X could be NaN

define float @maximum_inf_commute(float %x) {
; CHECK-LABEL: @maximum_inf_commute(
; CHECK-NEXT:    [[VAL:%.*]] = call float @llvm.maximum.f32(float 0x7FF0000000000000, float [[X:%.*]])
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.maximum.f32(float 0x7FF0000000000000, float %x)
  ret float %val
}
