; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
;RUN: opt -S -slp-vectorizer -mtriple=x86_64-unknown-linux-android23 < %s | FileCheck %s

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds float, ptr undef, i32 2
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x float>, ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x float>, ptr undef, align 4
; CHECK-NEXT:    [[TMP4:%.*]] = fsub <2 x float> [[TMP2]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x float> [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x float> [[TMP4]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = fcmp olt float [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x float> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <2 x float> undef, float [[TMP8]], i64 0
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <2 x float> zeroinitializer, float 0.000000e+00, i64 0
; CHECK-NEXT:    store <2 x float> zeroinitializer, ptr null, align 4
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x float> [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <2 x float> [[TMP9]], float [[TMP11]], i64 0
; CHECK-NEXT:    store <2 x float> zeroinitializer, ptr null, align 4
; CHECK-NEXT:    ret void
;
  %1 = getelementptr inbounds float, ptr undef, i32 2
  %2 = load float, ptr %1, align 4
  %3 = load float, ptr undef, align 4
  %4 = fsub float %2, %3
  %5 = getelementptr inbounds float, ptr undef, i32 3
  %6 = load float, ptr %5, align 4
  %7 = getelementptr inbounds float, ptr undef, i32 1
  %8 = load float, ptr %7, align 4
  %9 = fsub float %6, %8
  %10 = fcmp olt float %9, %4
  %11 = insertelement <2 x float> undef, float %3, i64 0
  %12 = insertelement <2 x float> zeroinitializer, float 0.000000e+00, i64 0
  store <2 x float> zeroinitializer, ptr null, align 4
  %13 = insertelement <2 x float> %11, float %6, i64 0
  store <2 x float> zeroinitializer, ptr null, align 4
  ret void
}
