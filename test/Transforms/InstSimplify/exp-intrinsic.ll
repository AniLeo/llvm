; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

declare double @llvm.exp.f64(double)
declare double @llvm.log.f64(double)

define double @exp_log(double %a) {
; CHECK-LABEL: @exp_log(
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.log.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.exp.f64(double [[TMP1]])
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = call double @llvm.log.f64(double %a)
  %2 = call double @llvm.exp.f64(double %1)
  ret double %2
}

define double @exp_log_fast(double %a) {
; CHECK-LABEL: @exp_log_fast(
; CHECK-NEXT:    ret double [[A:%.*]]
;
  %1 = call fast double @llvm.log.f64(double %a)
  %2 = call fast double @llvm.exp.f64(double %1)
  ret double %2
}

define double @exp_fast_log_strict(double %a) {
; CHECK-LABEL: @exp_fast_log_strict(
; CHECK-NEXT:    ret double [[A:%.*]]
;
  %1 = call double @llvm.log.f64(double %a)
  %2 = call fast double @llvm.exp.f64(double %1)
  ret double %2
}

define double @exp_strict_log_fast(double %a) {
; CHECK-LABEL: @exp_strict_log_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.log.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.exp.f64(double [[TMP1]])
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = call fast double @llvm.log.f64(double %a)
  %2 = call double @llvm.exp.f64(double %1)
  ret double %2
}

define double @exp_log_exp_log(double %a) {
; CHECK-LABEL: @exp_log_exp_log(
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.log.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.exp.f64(double [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = call double @llvm.log.f64(double [[TMP2]])
; CHECK-NEXT:    [[TMP4:%.*]] = call double @llvm.exp.f64(double [[TMP3]])
; CHECK-NEXT:    ret double [[TMP4]]
;
  %1 = call double @llvm.log.f64(double %a)
  %2 = call double @llvm.exp.f64(double %1)
  %3 = call double @llvm.log.f64(double %2)
  %4 = call double @llvm.exp.f64(double %3)
  ret double %4
}

define double @exp_log_exp_log_fast(double %a) {
; CHECK-LABEL: @exp_log_exp_log_fast(
; CHECK-NEXT:    ret double [[A:%.*]]
;
  %1 = call fast double @llvm.log.f64(double %a)
  %2 = call fast double @llvm.exp.f64(double %1)
  %3 = call fast double @llvm.log.f64(double %2)
  %4 = call fast double @llvm.exp.f64(double %3)
  ret double %4
}
