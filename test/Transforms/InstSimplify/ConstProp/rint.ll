; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -early-cse -earlycse-debug-hash < %s | FileCheck %s

declare float @nearbyintf(float) #0
declare float @llvm.nearbyint.f32(float)
declare double @nearbyint(double) #0
declare double @llvm.nearbyint.f64(double)
declare float @rintf(float) #0
declare float @llvm.rint.f32(float)
declare double @rint(double) #0
declare double @llvm.rint.f64(double)

define float @constant_fold_rint_f32_01() #0 {
; CHECK-LABEL: @constant_fold_rint_f32_01(
; CHECK-NEXT:    ret float 1.000000e+00
;
  %x = call float @nearbyintf(float 1.25) #0
  ret float %x
}

define float @constant_fold_rint_f32_02() #0 {
; CHECK-LABEL: @constant_fold_rint_f32_02(
; CHECK-NEXT:    ret float -1.000000e+00
;
  %x = call float @llvm.nearbyint.f32(float -1.25) #0
  ret float %x
}

define float @constant_fold_rint_f32_03() #0 {
; CHECK-LABEL: @constant_fold_rint_f32_03(
; CHECK-NEXT:    ret float 2.000000e+00
;
  %x = call float @rintf(float 1.5) #0
  ret float %x
}

define float @constant_fold_rint_f32_04() #0 {
; CHECK-LABEL: @constant_fold_rint_f32_04(
; CHECK-NEXT:    ret float -2.000000e+00
;
  %x = call float @llvm.rint.f32(float -1.5) #0
  ret float %x
}

define float @constant_fold_rint_f32_05() #0 {
; CHECK-LABEL: @constant_fold_rint_f32_05(
; CHECK-NEXT:    ret float 3.000000e+00
;
  %x = call float @nearbyintf(float 2.75) #0
  ret float %x
}

define float @constant_fold_rint_f32_06() #0 {
; CHECK-LABEL: @constant_fold_rint_f32_06(
; CHECK-NEXT:    ret float -3.000000e+00
;
  %x = call float @llvm.nearbyint.f32(float -2.75) #0
  ret float %x
}

define double @constant_fold_rint_f64_01() #0 {
; CHECK-LABEL: @constant_fold_rint_f64_01(
; CHECK-NEXT:    ret double 1.000000e+00
;
  %x = call double @rint(double 1.3) #0
  ret double %x
}

define double @constant_fold_rint_f64_02() #0 {
; CHECK-LABEL: @constant_fold_rint_f64_02(
; CHECK-NEXT:    ret double -1.000000e+00
;
  %x = call double @llvm.rint.f64(double -1.3) #0
  ret double %x
}

define double @constant_fold_rint_f64_03() #0 {
; CHECK-LABEL: @constant_fold_rint_f64_03(
; CHECK-NEXT:    ret double 2.000000e+00
;
  %x = call double @nearbyint(double 1.5) #0
  ret double %x
}

define double @constant_fold_rint_f64_04() #0 {
; CHECK-LABEL: @constant_fold_rint_f64_04(
; CHECK-NEXT:    ret double -2.000000e+00
;
  %x = call double @llvm.nearbyint.f64(double -1.5) #0
  ret double %x
}

define double @constant_fold_rint_f64_05() #0 {
; CHECK-LABEL: @constant_fold_rint_f64_05(
; CHECK-NEXT:    ret double 3.000000e+00
;
  %x = call double @rint(double 2.7) #0
  ret double %x
}

define double @constant_fold_rint_f64_06() #0 {
; CHECK-LABEL: @constant_fold_rint_f64_06(
; CHECK-NEXT:    ret double -3.000000e+00
;
  %x = call double @llvm.rint.f64(double -2.7) #0
  ret double %x
}

attributes #0 = { nounwind readnone willreturn }
