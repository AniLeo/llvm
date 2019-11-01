; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -verify -slp-vectorizer -o - -S -mtriple=x86_64-apple-macosx10.13.0 | FileCheck %s

@global = local_unnamed_addr global [6 x double] zeroinitializer, align 16

define { i64, i64 } @patatino(double %arg) {
; CHECK-LABEL: define {{[^@]+}}@patatino(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x double>, <2 x double>* bitcast ([6 x double]* @global to <2 x double>*), align 16
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, <2 x double>* bitcast (double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 2) to <2 x double>*), align 16
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> [[TMP2]], double [[ARG]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = fmul <2 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <2 x double> [[TMP0]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = load <2 x double>, <2 x double>* bitcast (double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 4) to <2 x double>*), align 16
; CHECK-NEXT:    [[TMP7:%.*]] = fadd <2 x double> [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = fptosi <2 x double> [[TMP7]] to <2 x i32>
; CHECK-NEXT:    [[TMP9:%.*]] = sext <2 x i32> [[TMP8]] to <2 x i64>
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x i64> [[TMP9]], i32 0
; CHECK-NEXT:    [[T16:%.*]] = insertvalue { i64, i64 } undef, i64 [[TMP10]], 0
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x i64> [[TMP9]], i32 1
; CHECK-NEXT:    [[T17:%.*]] = insertvalue { i64, i64 } [[T16]], i64 [[TMP11]], 1
; CHECK-NEXT:    ret { i64, i64 } [[T17]]
;
bb:
  %t = load double, double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 0), align 16
  %t1 = load double, double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 2), align 16
  %t2 = fmul double %t1, %arg
  %t3 = fadd double %t, %t2
  %t4 = load double, double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 4), align 16
  %t5 = fadd double %t4, %t3
  %t6 = fptosi double %t5 to i32
  %t7 = sext i32 %t6 to i64
  %t8 = load double, double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 1), align 8
  %t9 = load double, double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 3), align 8
  %t10 = fmul double %t9, %arg
  %t11 = fadd double %t8, %t10
  %t12 = load double, double* getelementptr inbounds ([6 x double], [6 x double]* @global, i64 0, i64 5), align 8
  %t13 = fadd double %t12, %t11
  %t14 = fptosi double %t13 to i32
  %t15 = sext i32 %t14 to i64
  %t16 = insertvalue { i64, i64 } undef, i64 %t7, 0
  %t17 = insertvalue { i64, i64 } %t16, i64 %t15, 1
  ret { i64, i64 } %t17
}
