; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -vector-library=Accelerate -S %s | FileCheck %s
; RUN: opt -slp-vectorizer -S %s | FileCheck --check-prefix NOACCELERATE %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-ios14.0.0"

declare float @llvm.sin.f32(float) #1


; Accelerate provides sin() for <4 x float>
define <4 x float> @sin_4x(<4 x float>* %a) {
; CHECK-LABEL: @sin_4x(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, <4 x float>* [[A:%.*]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = call fast <4 x float> @vsinf(<4 x float> [[TMP0]])
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x float> [[TMP1]], i32 0
; CHECK-NEXT:    [[VECINS:%.*]] = insertelement <4 x float> undef, float [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <4 x float> [[TMP1]], i32 1
; CHECK-NEXT:    [[VECINS_1:%.*]] = insertelement <4 x float> [[VECINS]], float [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP1]], i32 2
; CHECK-NEXT:    [[VECINS_2:%.*]] = insertelement <4 x float> [[VECINS_1]], float [[TMP4]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP1]], i32 3
; CHECK-NEXT:    [[VECINS_3:%.*]] = insertelement <4 x float> [[VECINS_2]], float [[TMP5]], i32 3
; CHECK-NEXT:    ret <4 x float> [[VECINS_3]]
;
; NOACCELERATE-LABEL: @sin_4x(
; NOACCELERATE-NEXT:  entry:
; NOACCELERATE-NEXT:    [[TMP0:%.*]] = load <4 x float>, <4 x float>* [[A:%.*]], align 16
; NOACCELERATE-NEXT:    [[VECEXT:%.*]] = extractelement <4 x float> [[TMP0]], i32 0
; NOACCELERATE-NEXT:    [[TMP1:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT]])
; NOACCELERATE-NEXT:    [[VECINS:%.*]] = insertelement <4 x float> undef, float [[TMP1]], i32 0
; NOACCELERATE-NEXT:    [[VECEXT_1:%.*]] = extractelement <4 x float> [[TMP0]], i32 1
; NOACCELERATE-NEXT:    [[TMP2:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT_1]])
; NOACCELERATE-NEXT:    [[VECINS_1:%.*]] = insertelement <4 x float> [[VECINS]], float [[TMP2]], i32 1
; NOACCELERATE-NEXT:    [[VECEXT_2:%.*]] = extractelement <4 x float> [[TMP0]], i32 2
; NOACCELERATE-NEXT:    [[TMP3:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT_2]])
; NOACCELERATE-NEXT:    [[VECINS_2:%.*]] = insertelement <4 x float> [[VECINS_1]], float [[TMP3]], i32 2
; NOACCELERATE-NEXT:    [[VECEXT_3:%.*]] = extractelement <4 x float> [[TMP0]], i32 3
; NOACCELERATE-NEXT:    [[TMP4:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT_3]])
; NOACCELERATE-NEXT:    [[VECINS_3:%.*]] = insertelement <4 x float> [[VECINS_2]], float [[TMP4]], i32 3
; NOACCELERATE-NEXT:    ret <4 x float> [[VECINS_3]]
;
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %vecext = extractelement <4 x float> %0, i32 0
  %1 = tail call fast float @llvm.sin.f32(float %vecext)
  %vecins = insertelement <4 x float> undef, float %1, i32 0
  %vecext.1 = extractelement <4 x float> %0, i32 1
  %2 = tail call fast float @llvm.sin.f32(float %vecext.1)
  %vecins.1 = insertelement <4 x float> %vecins, float %2, i32 1
  %vecext.2 = extractelement <4 x float> %0, i32 2
  %3 = tail call fast float @llvm.sin.f32(float %vecext.2)
  %vecins.2 = insertelement <4 x float> %vecins.1, float %3, i32 2
  %vecext.3 = extractelement <4 x float> %0, i32 3
  %4 = tail call fast float @llvm.sin.f32(float %vecext.3)
  %vecins.3 = insertelement <4 x float> %vecins.2, float %4, i32 3
  ret <4 x float> %vecins.3
}

; Accelerate *does not* provide sin() for <2 x float>.
define <2 x float> @sin_2x(<2 x float>* %a) {
; CHECK-LABEL: @sin_2x(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x float>, <2 x float>* [[A:%.*]], align 16
; CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <2 x float> [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT]]) #1
; CHECK-NEXT:    [[VECINS:%.*]] = insertelement <2 x float> undef, float [[TMP1]], i32 0
; CHECK-NEXT:    [[VECEXT_1:%.*]] = extractelement <2 x float> [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT_1]]) #1
; CHECK-NEXT:    [[VECINS_1:%.*]] = insertelement <2 x float> [[VECINS]], float [[TMP2]], i32 1
; CHECK-NEXT:    ret <2 x float> [[VECINS_1]]
;
; NOACCELERATE-LABEL: @sin_2x(
; NOACCELERATE-NEXT:  entry:
; NOACCELERATE-NEXT:    [[TMP0:%.*]] = load <2 x float>, <2 x float>* [[A:%.*]], align 16
; NOACCELERATE-NEXT:    [[VECEXT:%.*]] = extractelement <2 x float> [[TMP0]], i32 0
; NOACCELERATE-NEXT:    [[TMP1:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT]])
; NOACCELERATE-NEXT:    [[VECINS:%.*]] = insertelement <2 x float> undef, float [[TMP1]], i32 0
; NOACCELERATE-NEXT:    [[VECEXT_1:%.*]] = extractelement <2 x float> [[TMP0]], i32 1
; NOACCELERATE-NEXT:    [[TMP2:%.*]] = tail call fast float @llvm.sin.f32(float [[VECEXT_1]])
; NOACCELERATE-NEXT:    [[VECINS_1:%.*]] = insertelement <2 x float> [[VECINS]], float [[TMP2]], i32 1
; NOACCELERATE-NEXT:    ret <2 x float> [[VECINS_1]]
;
entry:
  %0 = load <2 x float>, <2 x float>* %a, align 16
  %vecext = extractelement <2 x float> %0, i32 0
  %1 = tail call fast float @llvm.sin.f32(float %vecext)
  %vecins = insertelement <2 x float> undef, float %1, i32 0
  %vecext.1 = extractelement <2 x float> %0, i32 1
  %2 = tail call fast float @llvm.sin.f32(float %vecext.1)
  %vecins.1 = insertelement <2 x float> %vecins, float %2, i32 1
  ret <2 x float> %vecins.1
}


declare float @llvm.cos.f32(float) #1

; Accelerate provides cos() for <4 x float>
define <4 x float> @cos_4x(<4 x float>* %a) {
; CHECK-LABEL: @cos_4x(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, <4 x float>* [[A:%.*]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = call fast <4 x float> @vcosf(<4 x float> [[TMP0]])
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x float> [[TMP1]], i32 0
; CHECK-NEXT:    [[VECINS:%.*]] = insertelement <4 x float> undef, float [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <4 x float> [[TMP1]], i32 1
; CHECK-NEXT:    [[VECINS_1:%.*]] = insertelement <4 x float> [[VECINS]], float [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP1]], i32 2
; CHECK-NEXT:    [[VECINS_2:%.*]] = insertelement <4 x float> [[VECINS_1]], float [[TMP4]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP1]], i32 3
; CHECK-NEXT:    [[VECINS_3:%.*]] = insertelement <4 x float> [[VECINS_2]], float [[TMP5]], i32 3
; CHECK-NEXT:    ret <4 x float> [[VECINS_3]]
;
; NOACCELERATE-LABEL: @cos_4x(
; NOACCELERATE-NEXT:  entry:
; NOACCELERATE-NEXT:    [[TMP0:%.*]] = load <4 x float>, <4 x float>* [[A:%.*]], align 16
; NOACCELERATE-NEXT:    [[VECEXT:%.*]] = extractelement <4 x float> [[TMP0]], i32 0
; NOACCELERATE-NEXT:    [[TMP1:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT]])
; NOACCELERATE-NEXT:    [[VECINS:%.*]] = insertelement <4 x float> undef, float [[TMP1]], i32 0
; NOACCELERATE-NEXT:    [[VECEXT_1:%.*]] = extractelement <4 x float> [[TMP0]], i32 1
; NOACCELERATE-NEXT:    [[TMP2:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT_1]])
; NOACCELERATE-NEXT:    [[VECINS_1:%.*]] = insertelement <4 x float> [[VECINS]], float [[TMP2]], i32 1
; NOACCELERATE-NEXT:    [[VECEXT_2:%.*]] = extractelement <4 x float> [[TMP0]], i32 2
; NOACCELERATE-NEXT:    [[TMP3:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT_2]])
; NOACCELERATE-NEXT:    [[VECINS_2:%.*]] = insertelement <4 x float> [[VECINS_1]], float [[TMP3]], i32 2
; NOACCELERATE-NEXT:    [[VECEXT_3:%.*]] = extractelement <4 x float> [[TMP0]], i32 3
; NOACCELERATE-NEXT:    [[TMP4:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT_3]])
; NOACCELERATE-NEXT:    [[VECINS_3:%.*]] = insertelement <4 x float> [[VECINS_2]], float [[TMP4]], i32 3
; NOACCELERATE-NEXT:    ret <4 x float> [[VECINS_3]]
;
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %vecext = extractelement <4 x float> %0, i32 0
  %1 = tail call fast float @llvm.cos.f32(float %vecext)
  %vecins = insertelement <4 x float> undef, float %1, i32 0
  %vecext.1 = extractelement <4 x float> %0, i32 1
  %2 = tail call fast float @llvm.cos.f32(float %vecext.1)
  %vecins.1 = insertelement <4 x float> %vecins, float %2, i32 1
  %vecext.2 = extractelement <4 x float> %0, i32 2
  %3 = tail call fast float @llvm.cos.f32(float %vecext.2)
  %vecins.2 = insertelement <4 x float> %vecins.1, float %3, i32 2
  %vecext.3 = extractelement <4 x float> %0, i32 3
  %4 = tail call fast float @llvm.cos.f32(float %vecext.3)
  %vecins.3 = insertelement <4 x float> %vecins.2, float %4, i32 3
  ret <4 x float> %vecins.3
}

; Accelerate *does not* provide cos() for <2 x float>.
define <2 x float> @cos_2x(<2 x float>* %a) {
; CHECK-LABEL: @cos_2x(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x float>, <2 x float>* [[A:%.*]], align 16
; CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <2 x float> [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT]]) #2
; CHECK-NEXT:    [[VECINS:%.*]] = insertelement <2 x float> undef, float [[TMP1]], i32 0
; CHECK-NEXT:    [[VECEXT_1:%.*]] = extractelement <2 x float> [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT_1]]) #2
; CHECK-NEXT:    [[VECINS_1:%.*]] = insertelement <2 x float> [[VECINS]], float [[TMP2]], i32 1
; CHECK-NEXT:    ret <2 x float> [[VECINS_1]]
;
; NOACCELERATE-LABEL: @cos_2x(
; NOACCELERATE-NEXT:  entry:
; NOACCELERATE-NEXT:    [[TMP0:%.*]] = load <2 x float>, <2 x float>* [[A:%.*]], align 16
; NOACCELERATE-NEXT:    [[VECEXT:%.*]] = extractelement <2 x float> [[TMP0]], i32 0
; NOACCELERATE-NEXT:    [[TMP1:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT]])
; NOACCELERATE-NEXT:    [[VECINS:%.*]] = insertelement <2 x float> undef, float [[TMP1]], i32 0
; NOACCELERATE-NEXT:    [[VECEXT_1:%.*]] = extractelement <2 x float> [[TMP0]], i32 1
; NOACCELERATE-NEXT:    [[TMP2:%.*]] = tail call fast float @llvm.cos.f32(float [[VECEXT_1]])
; NOACCELERATE-NEXT:    [[VECINS_1:%.*]] = insertelement <2 x float> [[VECINS]], float [[TMP2]], i32 1
; NOACCELERATE-NEXT:    ret <2 x float> [[VECINS_1]]
;
entry:
  %0 = load <2 x float>, <2 x float>* %a, align 16
  %vecext = extractelement <2 x float> %0, i32 0
  %1 = tail call fast float @llvm.cos.f32(float %vecext)
  %vecins = insertelement <2 x float> undef, float %1, i32 0
  %vecext.1 = extractelement <2 x float> %0, i32 1
  %2 = tail call fast float @llvm.cos.f32(float %vecext.1)
  %vecins.1 = insertelement <2 x float> %vecins, float %2, i32 1
  ret <2 x float> %vecins.1
}
