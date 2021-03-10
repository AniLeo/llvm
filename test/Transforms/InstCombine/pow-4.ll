; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s                        | FileCheck %s --check-prefixes=CHECK,SQRT
; RUN: opt -instcombine -S < %s -disable-builtin sqrt  | FileCheck %s --check-prefixes=CHECK,NOSQRT
declare double @llvm.pow.f64(double, double)
declare float @llvm.pow.f32(float, float)
declare <2 x double> @llvm.pow.v2f64(<2 x double>, <2 x double>)
declare <2 x float> @llvm.pow.v2f32(<2 x float>, <2 x float>)
declare <4 x float> @llvm.pow.v4f32(<4 x float>, <4 x float>)
declare double @pow(double, double)

; pow(x, 3.0)
define double @test_simplify_3(double %x) {
; CHECK-LABEL: @test_simplify_3(
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[SQUARE]], [[X]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 3.000000e+00)
  ret double %1
}

; powf(x, 4.0)
define float @test_simplify_4f(float %x) {
; CHECK-LABEL: @test_simplify_4f(
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast float [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    ret float [[TMP1]]
;
  %1 = call fast float @llvm.pow.f32(float %x, float 4.000000e+00)
  ret float %1
}

; pow(x, 4.0)
define double @test_simplify_4(double %x) {
; CHECK-LABEL: @test_simplify_4(
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 4.000000e+00)
  ret double %1
}

; powf(x, <15.0, 15.0>)
define <2 x float> @test_simplify_15(<2 x float> %x) {
; CHECK-LABEL: @test_simplify_15(
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast <2 x float> [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <2 x float> [[SQUARE]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <2 x float> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast <2 x float> [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast <2 x float> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    ret <2 x float> [[TMP4]]
;
  %1 = call fast <2 x float> @llvm.pow.v2f32(<2 x float> %x, <2 x float> <float 1.500000e+01, float 1.500000e+01>)
  ret <2 x float> %1
}

; pow(x, -7.0)
define <2 x double> @test_simplify_neg_7(<2 x double> %x) {
; CHECK-LABEL: @test_simplify_neg_7(
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast <2 x double> [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <2 x double> [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <2 x double> [[TMP1]], [[X]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast <2 x double> [[SQUARE]], [[TMP2]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast <2 x double> <double 1.000000e+00, double 1.000000e+00>, [[TMP3]]
; CHECK-NEXT:    ret <2 x double> [[RECIPROCAL]]
;
  %1 = call fast <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double -7.000000e+00, double -7.000000e+00>)
  ret <2 x double> %1
}

; powf(x, -19.0)
define float @test_simplify_neg_19(float %x) {
; CHECK-LABEL: @test_simplify_neg_19(
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast float [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast float [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast float [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast float [[SQUARE]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = fmul fast float [[TMP4]], [[X]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast float 1.000000e+00, [[TMP5]]
; CHECK-NEXT:    ret float [[RECIPROCAL]]
;
  %1 = call fast float @llvm.pow.f32(float %x, float -1.900000e+01)
  ret float %1
}

; pow(x, 11.23)
define double @test_simplify_11_23(double %x) {
; CHECK-LABEL: @test_simplify_11_23(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.pow.f64(double [[X:%.*]], double 1.123000e+01)
; CHECK-NEXT:    ret double [[TMP1]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 1.123000e+01)
  ret double %1
}

; powf(x, 32.0)
define float @test_simplify_32(float %x) {
; CHECK-LABEL: @test_simplify_32(
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast float [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast float [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast float [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast float [[TMP3]], [[TMP3]]
; CHECK-NEXT:    ret float [[TMP4]]
;
  %1 = call fast float @llvm.pow.f32(float %x, float 3.200000e+01)
  ret float %1
}

; pow(x, 33.0)
define double @test_simplify_33(double %x) {
; CHECK-LABEL: @test_simplify_33(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.powi.f64(double [[X:%.*]], i32 33)
; CHECK-NEXT:    ret double [[TMP1]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 3.300000e+01)
  ret double %1
}

; pow(x, 16.5) with double
define double @test_simplify_16_5(double %x) {
; CHECK-LABEL: @test_simplify_16_5(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast double [[X]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP3]], [[SQRT]]
; CHECK-NEXT:    ret double [[TMP4]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 1.650000e+01)
  ret double %1
}

; pow(x, -16.5) with double
define double @test_simplify_neg_16_5(double %x) {
; CHECK-LABEL: @test_simplify_neg_16_5(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast double [[X]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP3]], [[SQRT]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast double 1.000000e+00, [[TMP4]]
; CHECK-NEXT:    ret double [[RECIPROCAL]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double -1.650000e+01)
  ret double %1
}

; pow(x, 16.5) with double

define double @test_simplify_16_5_libcall(double %x) {
; SQRT-LABEL: @test_simplify_16_5_libcall(
; SQRT-NEXT:    [[SQRT:%.*]] = call fast double @sqrt(double [[X:%.*]])
; SQRT-NEXT:    [[SQUARE:%.*]] = fmul fast double [[X]], [[X]]
; SQRT-NEXT:    [[TMP1:%.*]] = fmul fast double [[SQUARE]], [[SQUARE]]
; SQRT-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; SQRT-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[TMP2]]
; SQRT-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP3]], [[SQRT]]
; SQRT-NEXT:    ret double [[TMP4]]
;
; NOSQRT-LABEL: @test_simplify_16_5_libcall(
; NOSQRT-NEXT:    [[TMP1:%.*]] = call fast double @pow(double [[X:%.*]], double 1.650000e+01)
; NOSQRT-NEXT:    ret double [[TMP1]]
;
  %1 = call fast double @pow(double %x, double 1.650000e+01)
  ret double %1
}

; pow(x, -16.5) with double

define double @test_simplify_neg_16_5_libcall(double %x) {
; SQRT-LABEL: @test_simplify_neg_16_5_libcall(
; SQRT-NEXT:    [[SQRT:%.*]] = call fast double @sqrt(double [[X:%.*]])
; SQRT-NEXT:    [[SQUARE:%.*]] = fmul fast double [[X]], [[X]]
; SQRT-NEXT:    [[TMP1:%.*]] = fmul fast double [[SQUARE]], [[SQUARE]]
; SQRT-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; SQRT-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[TMP2]]
; SQRT-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP3]], [[SQRT]]
; SQRT-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast double 1.000000e+00, [[TMP4]]
; SQRT-NEXT:    ret double [[RECIPROCAL]]
;
; NOSQRT-LABEL: @test_simplify_neg_16_5_libcall(
; NOSQRT-NEXT:    [[TMP1:%.*]] = call fast double @pow(double [[X:%.*]], double -1.650000e+01)
; NOSQRT-NEXT:    ret double [[TMP1]]
;
  %1 = call fast double @pow(double %x, double -1.650000e+01)
  ret double %1
}

; pow(x, -8.5) with float
define float @test_simplify_neg_8_5(float %x) {
; CHECK-LABEL: @test_simplify_neg_8_5(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast float @llvm.sqrt.f32(float [[X:%.*]])
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast float [[X]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast float [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast float [[TMP1]], [[SQRT]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast float 1.000000e+00, [[TMP2]]
; CHECK-NEXT:    ret float [[RECIPROCAL]]
;
  %1 = call fast float @llvm.pow.f32(float %x, float -0.450000e+01)
  ret float %1
}

; pow(x, 7.5) with <2 x double>
define <2 x double> @test_simplify_7_5(<2 x double> %x) {
; CHECK-LABEL: @test_simplify_7_5(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast <2 x double> @llvm.sqrt.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast <2 x double> [[X]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <2 x double> [[SQUARE]], [[SQUARE]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <2 x double> [[TMP1]], [[X]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast <2 x double> [[SQUARE]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast <2 x double> [[TMP3]], [[SQRT]]
; CHECK-NEXT:    ret <2 x double> [[TMP4]]
;
  %1 = call fast <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double 7.500000e+00, double 7.500000e+00>)
  ret <2 x double> %1
}

; pow(x, 3.5) with <4 x float>
define <4 x float> @test_simplify_3_5(<4 x float> %x) {
; CHECK-LABEL: @test_simplify_3_5(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> [[X:%.*]])
; CHECK-NEXT:    [[SQUARE:%.*]] = fmul fast <4 x float> [[X]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <4 x float> [[SQUARE]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <4 x float> [[TMP1]], [[SQRT]]
; CHECK-NEXT:    ret <4 x float> [[TMP2]]
;
  %1 = call fast <4 x float> @llvm.pow.v4f32(<4 x float> %x, <4 x float> <float 3.500000e+00, float 3.500000e+00, float 3.500000e+00, float 3.500000e+00>)
  ret <4 x float> %1
}

; (float)pow((double)(float)x, 0.5)
define float @shrink_pow_libcall_half(float %x) {
; SQRT-LABEL: @shrink_pow_libcall_half(
; SQRT-NEXT:    [[SQRTF:%.*]] = call fast float @sqrtf(float [[X]])
; SQRT-NEXT:    ret float [[SQRTF]]
;
; NOSQRT-LABEL: @shrink_pow_libcall_half(
; NOSQRT-NEXT:    [[SQRTF:%.*]] = call fast float @sqrtf(float [[X:%.*]])
; NOSQRT-NEXT:    ret float [[SQRTF]]
;
  %dx = fpext float %x to double
  %call = call fast double @pow(double %dx, double 0.5)
  %fr = fptrunc double %call to float
  ret float %fr
}

; Make sure that -0.0 exponent is always simplified.

define double @PR43233(double %x) {
; CHECK-LABEL: @PR43233(
; CHECK-NEXT:    ret double 1.000000e+00
;
  %r = call fast double @llvm.pow.f64(double %x, double -0.0)
  ret double %r
}

