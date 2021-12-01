; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer -slp-threshold=0 < %s | FileCheck %s

define <4 x float> @simple_select(<4 x float> %a, <4 x float> %b, <4 x i32> %c) {
; CHECK-LABEL: @simple_select(
; CHECK-NEXT:    [[C0:%.*]] = extractelement <4 x i32> [[C:%.*]], i32 0
; CHECK-NEXT:    [[C1:%.*]] = extractelement <4 x i32> [[C]], i32 1
; CHECK-NEXT:    [[A0:%.*]] = extractelement <4 x float> [[A:%.*]], i32 0
; CHECK-NEXT:    [[A1:%.*]] = extractelement <4 x float> [[A]], i32 1
; CHECK-NEXT:    [[B0:%.*]] = extractelement <4 x float> [[B:%.*]], i32 0
; CHECK-NEXT:    [[B1:%.*]] = extractelement <4 x float> [[B]], i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> poison, i32 [[C0]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i32> [[TMP1]], i32 [[C1]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne <2 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <2 x float> poison, float [[A0]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <2 x float> [[TMP4]], float [[A1]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x float> poison, float [[B0]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <2 x float> [[TMP6]], float [[B1]], i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = select <2 x i1> [[TMP3]], <2 x float> [[TMP5]], <2 x float> [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <2 x float> [[TMP8]], <2 x float> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[RB1:%.*]] = shufflevector <4 x float> <float poison, float poison, float undef, float undef>, <4 x float> [[TMP9]], <4 x i32> <i32 4, i32 5, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x float> [[RB1]]
;
  %c0 = extractelement <4 x i32> %c, i32 0
  %c1 = extractelement <4 x i32> %c, i32 1
  %a0 = extractelement <4 x float> %a, i32 0
  %a1 = extractelement <4 x float> %a, i32 1
  %b0 = extractelement <4 x float> %b, i32 0
  %b1 = extractelement <4 x float> %b, i32 1
  %cmp0 = icmp ne i32 %c0, 0
  %cmp1 = icmp ne i32 %c1, 0
  %s0 = select i1 %cmp0, float %a0, float %b0
  %s1 = select i1 %cmp1, float %a1, float %b1
  %ra = insertelement <4 x float> <float poison, float poison, float undef, float undef>, float %s0, i32 0
  %rb = insertelement <4 x float> %ra, float %s1, i32 1
  ret <4 x float> %rb
}
