; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

declare double @llvm.pow.f64(double, double)
declare float @llvm.pow.f32(float, float)

; pow(x, 4.0f)
define float @test_simplify_4f(float %x) {
; CHECK-LABEL: @test_simplify_4f(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast float [[TMP1]], [[TMP1]]
; CHECK-NEXT:    ret float [[TMP2]]
;
  %1 = call fast float @llvm.pow.f32(float %x, float 4.000000e+00)
  ret float %1
}

; pow(x, 3.0)
define double @test_simplify_3(double %x) {
; CHECK-LABEL: @test_simplify_3(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[X]]
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 3.000000e+00)
  ret double %1
}

; pow(x, 4.0)
define double @test_simplify_4(double %x) {
; CHECK-LABEL: @test_simplify_4(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 4.000000e+00)
  ret double %1
}

; pow(x, 15.0)
define double @test_simplify_15(double %x) {
; CHECK-LABEL: @test_simplify_15(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[X]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP3]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = fmul fast double [[TMP2]], [[TMP4]]
; CHECK-NEXT:    ret double [[TMP5]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 1.500000e+01)
  ret double %1
}

; pow(x, -7.0)
define double @test_simplify_neg_7(double %x) {
; CHECK-LABEL: @test_simplify_neg_7(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[X]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = fdiv fast double 1.000000e+00, [[TMP4]]
; CHECK-NEXT:    ret double [[TMP5]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double -7.000000e+00)
  ret double %1
}

; pow(x, -19.0)
define double @test_simplify_neg_19(double %x) {
; CHECK-LABEL: @test_simplify_neg_19(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP3]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = fmul fast double [[TMP1]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = fmul fast double [[TMP5]], [[X]]
; CHECK-NEXT:    [[TMP7:%.*]] = fdiv fast double 1.000000e+00, [[TMP6]]
; CHECK-NEXT:    ret double [[TMP7]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double -1.900000e+01)
  ret double %1
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

; pow(x, 32.0)
define double @test_simplify_32(double %x) {
; CHECK-LABEL: @test_simplify_32(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast double [[TMP3]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = fmul fast double [[TMP4]], [[TMP4]]
; CHECK-NEXT:    ret double [[TMP5]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 3.200000e+01)
  ret double %1
}

; pow(x, 33.0)
define double @test_simplify_33(double %x) {
; CHECK-LABEL: @test_simplify_33(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.pow.f64(double [[X:%.*]], double 3.300000e+01)
; CHECK-NEXT:    ret double [[TMP1]]
;
  %1 = call fast double @llvm.pow.f64(double %x, double 3.300000e+01)
  ret double %1
}

