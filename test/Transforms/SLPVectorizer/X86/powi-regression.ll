; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-linux-gnu -mcpu=x86-64-v2 -basic-aa -slp-vectorizer -S | FileCheck %s

; FIXME: Ensure llvm.powi.* intrinsics are vectorized.

define <2 x double> @PR53887_v2f64(<2 x double> noundef %x) {
; CHECK-LABEL: @PR53887_v2f64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call fast <2 x double> @llvm.powi.v2f64.i32(<2 x double> [[X:%.*]], i32 6)
; CHECK-NEXT:    ret <2 x double> [[TMP0]]
;
entry:
  %vecext = extractelement <2 x double> %x, i64 0
  %0 = tail call fast double @llvm.powi.f64.i32(double %vecext, i32 6)
  %vecinit = insertelement <2 x double> undef, double %0, i64 0
  %vecext1 = extractelement <2 x double> %x, i64 1
  %1 = tail call fast double @llvm.powi.f64.i32(double %vecext1, i32 6)
  %vecinit3 = insertelement <2 x double> %vecinit, double %1, i64 1
  ret <2 x double> %vecinit3
}

define <4 x double> @PR53887_v4f64(<4 x double> noundef %x) {
; CHECK-LABEL: @PR53887_v4f64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call fast <4 x double> @llvm.powi.v4f64.i32(<4 x double> [[X:%.*]], i32 6)
; CHECK-NEXT:    ret <4 x double> [[TMP0]]
;
entry:
  %vecext = extractelement <4 x double> %x, i64 0
  %0 = tail call fast double @llvm.powi.f64.i32(double %vecext, i32 6) #2
  %vecinit = insertelement <4 x double> undef, double %0, i64 0
  %vecext1 = extractelement <4 x double> %x, i64 1
  %1 = tail call fast double @llvm.powi.f64.i32(double %vecext1, i32 6) #2
  %vecinit3 = insertelement <4 x double> %vecinit, double %1, i64 1
  %vecext4 = extractelement <4 x double> %x, i64 2
  %2 = tail call fast double @llvm.powi.f64.i32(double %vecext4, i32 6) #2
  %vecinit6 = insertelement <4 x double> %vecinit3, double %2, i64 2
  %vecext7 = extractelement <4 x double> %x, i64 3
  %3 = tail call fast double @llvm.powi.f64.i32(double %vecext7, i32 6) #2
  %vecinit9 = insertelement <4 x double> %vecinit6, double %3, i64 3
  ret <4 x double> %vecinit9
}

declare double @llvm.powi.f64.i32(double, i32)
