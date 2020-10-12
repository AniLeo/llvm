; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define double @std_cabs(double %real, double %imag) {
; CHECK-LABEL: @std_cabs(
; CHECK-NEXT:    [[CALL:%.*]] = tail call double @cabs(double [[REAL:%.*]], double [[IMAG:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call double @cabs(double %real, double %imag)
  ret double %call
}

define float @std_cabsf(float %real, float %imag) {
; CHECK-LABEL: @std_cabsf(
; CHECK-NEXT:    [[CALL:%.*]] = tail call float @cabsf(float [[REAL:%.*]], float [[IMAG:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call float @cabsf(float %real, float %imag)
  ret float %call
}

define fp128 @std_cabsl(fp128 %real, fp128 %imag) {
; CHECK-LABEL: @std_cabsl(
; CHECK-NEXT:    [[CALL:%.*]] = tail call fp128 @cabsl(fp128 [[REAL:%.*]], fp128 [[IMAG:%.*]])
; CHECK-NEXT:    ret fp128 [[CALL]]
;
  %call = tail call fp128 @cabsl(fp128 %real, fp128 %imag)
  ret fp128 %call
}

define double @fast_cabs(double %real, double %imag) {
; CHECK-LABEL: @fast_cabs(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast double [[REAL:%.*]], [[REAL]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast double [[IMAG:%.*]], [[IMAG]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd fast double [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[CABS:%.*]] = call fast double @llvm.sqrt.f64(double [[TMP3]])
; CHECK-NEXT:    ret double [[CABS]]
;
  %call = tail call fast double @cabs(double %real, double %imag)
  ret double %call
}

define float @fast_cabsf(float %real, float %imag) {
; CHECK-LABEL: @fast_cabsf(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast float [[REAL:%.*]], [[REAL]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast float [[IMAG:%.*]], [[IMAG]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd fast float [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[CABS:%.*]] = call fast float @llvm.sqrt.f32(float [[TMP3]])
; CHECK-NEXT:    ret float [[CABS]]
;
  %call = tail call fast float @cabsf(float %real, float %imag)
  ret float %call
}

define fp128 @fast_cabsl(fp128 %real, fp128 %imag) {
; CHECK-LABEL: @fast_cabsl(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast fp128 [[REAL:%.*]], [[REAL]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast fp128 [[IMAG:%.*]], [[IMAG]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd fast fp128 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[CABS:%.*]] = call fast fp128 @llvm.sqrt.f128(fp128 [[TMP3]])
; CHECK-NEXT:    ret fp128 [[CABS]]
;
  %call = tail call fast fp128 @cabsl(fp128 %real, fp128 %imag)
  ret fp128 %call
}

declare double @cabs(double %real, double %imag)
declare float @cabsf(float %real, float %imag)
declare fp128 @cabsl(fp128 %real, fp128 %imag)
