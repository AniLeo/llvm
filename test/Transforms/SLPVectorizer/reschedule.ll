; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer < %s | FileCheck %s

declare void @use(double, double)

; Create a situation where a previously scheduled instruction is encountered
; again, and needs to be unscheduled.
define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  for.body602:
; CHECK-NEXT:    [[MUL701:%.*]] = fmul double 0.000000e+00, 0.000000e+00
; CHECK-NEXT:    [[MUL703:%.*]] = fmul double 0.000000e+00, 0.000000e+00
; CHECK-NEXT:    [[I4:%.*]] = call double @llvm.fmuladd.f64(double [[MUL701]], double 0.000000e+00, double [[MUL703]])
; CHECK-NEXT:    store double [[I4]], double* null, align 8
; CHECK-NEXT:    [[I5:%.*]] = load double, double* null, align 8
; CHECK-NEXT:    [[I6:%.*]] = load double, double* null, align 8
; CHECK-NEXT:    [[MUL746:%.*]] = fmul double 0.000000e+00, [[I6]]
; CHECK-NEXT:    [[MUL747:%.*]] = fmul double 0.000000e+00, [[I5]]
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> poison, double [[MUL746]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> [[TMP0]], double [[MUL701]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> zeroinitializer, <2 x double> zeroinitializer, <2 x double> [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> poison, double [[MUL747]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <2 x double> [[TMP3]], double [[MUL703]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[TMP2]], <2 x double> zeroinitializer, <2 x double> [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[TMP5]], <2 x double> zeroinitializer, <2 x double> zeroinitializer)
; CHECK-NEXT:    [[TMP7:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> zeroinitializer, <2 x double> [[TMP6]], <2 x double> zeroinitializer)
; CHECK-NEXT:    br label [[FOR_COND794_PREHEADER:%.*]]
; CHECK:       for.cond794.preheader:
; CHECK-NEXT:    [[TMP8:%.*]] = phi <2 x double> [ [[TMP7]], [[FOR_BODY602:%.*]] ]
; CHECK-NEXT:    ret void
;
for.body602:
  %mul701 = fmul double 0.000000e+00, 0.000000e+00
  %mul703 = fmul double 0.000000e+00, 0.000000e+00
  %i = call double @llvm.fmuladd.f64(double 0.000000e+00, double 0.000000e+00, double %mul701)
  %i1 = call double @llvm.fmuladd.f64(double %i, double 0.000000e+00, double %mul703)
  %i2 = call double @llvm.fmuladd.f64(double %i1, double 0.000000e+00, double 0.000000e+00)
  %i3 = call double @llvm.fmuladd.f64(double 0.000000e+00, double %i2, double 0.000000e+00)
  %i4 = call double @llvm.fmuladd.f64(double %mul701, double 0.000000e+00, double %mul703)
  store double %i4, double* null, align 8
  %i5 = load double, double* null, align 8
  %i6 = load double, double* null, align 8
  %mul746 = fmul double 0.000000e+00, %i6
  %mul747 = fmul double 0.000000e+00, %i5
  %i7 = call double @llvm.fmuladd.f64(double 0.000000e+00, double 0.000000e+00, double %mul746)
  %i8 = call double @llvm.fmuladd.f64(double %i7, double 0.000000e+00, double %mul747)
  %i9 = call double @llvm.fmuladd.f64(double %i8, double 0.000000e+00, double 0.000000e+00)
  %i10 = call double @llvm.fmuladd.f64(double 0.000000e+00, double %i9, double 0.000000e+00)
  br label %for.cond794.preheader

for.cond794.preheader:                            ; preds = %for.body602
  %fullElectEnergy.1.lcssa = phi double [ %i10, %for.body602 ]
  %electEnergy.1.lcssa = phi double [ %i3, %for.body602 ]
  ret void

}

declare double @llvm.fmuladd.f64(double, double, double)
