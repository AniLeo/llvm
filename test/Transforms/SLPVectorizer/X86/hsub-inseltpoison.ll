; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=slm -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=SLM
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=knl -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skx -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX

;
; 128-bit vectors
;

define <2 x double> @test_v2f64(<2 x double> %a, <2 x double> %b) {
; SSE-LABEL: @test_v2f64(
; SSE-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[A:%.*]], <2 x double> [[B:%.*]], <2 x i32> <i32 0, i32 2>
; SSE-NEXT:    [[TMP2:%.*]] = shufflevector <2 x double> [[A]], <2 x double> [[B]], <2 x i32> <i32 1, i32 3>
; SSE-NEXT:    [[TMP3:%.*]] = fsub <2 x double> [[TMP1]], [[TMP2]]
; SSE-NEXT:    ret <2 x double> [[TMP3]]
;
; SLM-LABEL: @test_v2f64(
; SLM-NEXT:    [[A0:%.*]] = extractelement <2 x double> [[A:%.*]], i32 0
; SLM-NEXT:    [[A1:%.*]] = extractelement <2 x double> [[A]], i32 1
; SLM-NEXT:    [[B0:%.*]] = extractelement <2 x double> [[B:%.*]], i32 0
; SLM-NEXT:    [[B1:%.*]] = extractelement <2 x double> [[B]], i32 1
; SLM-NEXT:    [[R0:%.*]] = fsub double [[A0]], [[A1]]
; SLM-NEXT:    [[R1:%.*]] = fsub double [[B0]], [[B1]]
; SLM-NEXT:    [[R00:%.*]] = insertelement <2 x double> poison, double [[R0]], i32 0
; SLM-NEXT:    [[R01:%.*]] = insertelement <2 x double> [[R00]], double [[R1]], i32 1
; SLM-NEXT:    ret <2 x double> [[R01]]
;
; AVX-LABEL: @test_v2f64(
; AVX-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[A:%.*]], <2 x double> [[B:%.*]], <2 x i32> <i32 0, i32 2>
; AVX-NEXT:    [[TMP2:%.*]] = shufflevector <2 x double> [[A]], <2 x double> [[B]], <2 x i32> <i32 1, i32 3>
; AVX-NEXT:    [[TMP3:%.*]] = fsub <2 x double> [[TMP1]], [[TMP2]]
; AVX-NEXT:    ret <2 x double> [[TMP3]]
;
  %a0 = extractelement <2 x double> %a, i32 0
  %a1 = extractelement <2 x double> %a, i32 1
  %b0 = extractelement <2 x double> %b, i32 0
  %b1 = extractelement <2 x double> %b, i32 1
  %r0 = fsub double %a0, %a1
  %r1 = fsub double %b0, %b1
  %r00 = insertelement <2 x double> poison, double %r0, i32 0
  %r01 = insertelement <2 x double>  %r00, double %r1, i32 1
  ret <2 x double> %r01
}

define <4 x float> @test_v4f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test_v4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[A:%.*]], <4 x float> [[B:%.*]], <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x float> [[A]], <4 x float> [[B]], <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; CHECK-NEXT:    [[TMP3:%.*]] = fsub <4 x float> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <4 x float> [[TMP3]]
;
  %a0 = extractelement <4 x float> %a, i32 0
  %a1 = extractelement <4 x float> %a, i32 1
  %a2 = extractelement <4 x float> %a, i32 2
  %a3 = extractelement <4 x float> %a, i32 3
  %b0 = extractelement <4 x float> %b, i32 0
  %b1 = extractelement <4 x float> %b, i32 1
  %b2 = extractelement <4 x float> %b, i32 2
  %b3 = extractelement <4 x float> %b, i32 3
  %r0 = fsub float %a0, %a1
  %r1 = fsub float %a2, %a3
  %r2 = fsub float %b0, %b1
  %r3 = fsub float %b2, %b3
  %r00 = insertelement <4 x float> poison, float %r0, i32 0
  %r01 = insertelement <4 x float>  %r00, float %r1, i32 1
  %r02 = insertelement <4 x float>  %r01, float %r2, i32 2
  %r03 = insertelement <4 x float>  %r02, float %r3, i32 3
  ret <4 x float> %r03
}

define <2 x i64> @test_v2i64(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: @test_v2i64(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x i64> [[A:%.*]], <2 x i64> [[B:%.*]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <2 x i64> [[A]], <2 x i64> [[B]], <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[TMP3:%.*]] = sub <2 x i64> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i64> [[TMP3]]
;
  %a0 = extractelement <2 x i64> %a, i32 0
  %a1 = extractelement <2 x i64> %a, i32 1
  %b0 = extractelement <2 x i64> %b, i32 0
  %b1 = extractelement <2 x i64> %b, i32 1
  %r0 = sub i64 %a0, %a1
  %r1 = sub i64 %b0, %b1
  %r00 = insertelement <2 x i64> poison, i64 %r0, i32 0
  %r01 = insertelement <2 x i64>  %r00, i64 %r1, i32 1
  ret <2 x i64> %r01
}

define <4 x i32> @test_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @test_v4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[A:%.*]], <4 x i32> [[B:%.*]], <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[A]], <4 x i32> [[B]], <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; CHECK-NEXT:    [[TMP3:%.*]] = sub <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <4 x i32> [[TMP3]]
;
  %a0 = extractelement <4 x i32> %a, i32 0
  %a1 = extractelement <4 x i32> %a, i32 1
  %a2 = extractelement <4 x i32> %a, i32 2
  %a3 = extractelement <4 x i32> %a, i32 3
  %b0 = extractelement <4 x i32> %b, i32 0
  %b1 = extractelement <4 x i32> %b, i32 1
  %b2 = extractelement <4 x i32> %b, i32 2
  %b3 = extractelement <4 x i32> %b, i32 3
  %r0 = sub i32 %a0, %a1
  %r1 = sub i32 %a2, %a3
  %r2 = sub i32 %b0, %b1
  %r3 = sub i32 %b2, %b3
  %r00 = insertelement <4 x i32> poison, i32 %r0, i32 0
  %r01 = insertelement <4 x i32>  %r00, i32 %r1, i32 1
  %r02 = insertelement <4 x i32>  %r01, i32 %r2, i32 2
  %r03 = insertelement <4 x i32>  %r02, i32 %r3, i32 3
  ret <4 x i32> %r03
}

define <8 x i16> @test_v8i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: @test_v8i16(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> [[B:%.*]], <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[A]], <8 x i16> [[B]], <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = sub <8 x i16> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <8 x i16> [[TMP3]]
;
  %a0 = extractelement <8 x i16> %a, i32 0
  %a1 = extractelement <8 x i16> %a, i32 1
  %a2 = extractelement <8 x i16> %a, i32 2
  %a3 = extractelement <8 x i16> %a, i32 3
  %a4 = extractelement <8 x i16> %a, i32 4
  %a5 = extractelement <8 x i16> %a, i32 5
  %a6 = extractelement <8 x i16> %a, i32 6
  %a7 = extractelement <8 x i16> %a, i32 7
  %b0 = extractelement <8 x i16> %b, i32 0
  %b1 = extractelement <8 x i16> %b, i32 1
  %b2 = extractelement <8 x i16> %b, i32 2
  %b3 = extractelement <8 x i16> %b, i32 3
  %b4 = extractelement <8 x i16> %b, i32 4
  %b5 = extractelement <8 x i16> %b, i32 5
  %b6 = extractelement <8 x i16> %b, i32 6
  %b7 = extractelement <8 x i16> %b, i32 7
  %r0 = sub i16 %a0, %a1
  %r1 = sub i16 %a2, %a3
  %r2 = sub i16 %a4, %a5
  %r3 = sub i16 %a6, %a7
  %r4 = sub i16 %b0, %b1
  %r5 = sub i16 %b2, %b3
  %r6 = sub i16 %b4, %b5
  %r7 = sub i16 %b6, %b7
  %r00 = insertelement <8 x i16> poison, i16 %r0, i32 0
  %r01 = insertelement <8 x i16>  %r00, i16 %r1, i32 1
  %r02 = insertelement <8 x i16>  %r01, i16 %r2, i32 2
  %r03 = insertelement <8 x i16>  %r02, i16 %r3, i32 3
  %r04 = insertelement <8 x i16>  %r03, i16 %r4, i32 4
  %r05 = insertelement <8 x i16>  %r04, i16 %r5, i32 5
  %r06 = insertelement <8 x i16>  %r05, i16 %r6, i32 6
  %r07 = insertelement <8 x i16>  %r06, i16 %r7, i32 7
  ret <8 x i16> %r07
}

;
; 256-bit vectors
;

define <4 x double> @test_v4f64(<4 x double> %a, <4 x double> %b) {
; SSE-LABEL: @test_v4f64(
; SSE-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[A:%.*]], <4 x double> [[B:%.*]], <2 x i32> <i32 0, i32 4>
; SSE-NEXT:    [[TMP2:%.*]] = shufflevector <4 x double> [[A]], <4 x double> [[B]], <2 x i32> <i32 1, i32 5>
; SSE-NEXT:    [[TMP3:%.*]] = fsub <2 x double> [[TMP1]], [[TMP2]]
; SSE-NEXT:    [[TMP4:%.*]] = shufflevector <4 x double> [[A]], <4 x double> [[B]], <2 x i32> <i32 2, i32 6>
; SSE-NEXT:    [[TMP5:%.*]] = shufflevector <4 x double> [[A]], <4 x double> [[B]], <2 x i32> <i32 3, i32 7>
; SSE-NEXT:    [[TMP6:%.*]] = fsub <2 x double> [[TMP4]], [[TMP5]]
; SSE-NEXT:    [[R03:%.*]] = shufflevector <2 x double> [[TMP3]], <2 x double> [[TMP6]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; SSE-NEXT:    ret <4 x double> [[R03]]
;
; SLM-LABEL: @test_v4f64(
; SLM-NEXT:    [[A0:%.*]] = extractelement <4 x double> [[A:%.*]], i32 0
; SLM-NEXT:    [[A1:%.*]] = extractelement <4 x double> [[A]], i32 1
; SLM-NEXT:    [[A2:%.*]] = extractelement <4 x double> [[A]], i32 2
; SLM-NEXT:    [[A3:%.*]] = extractelement <4 x double> [[A]], i32 3
; SLM-NEXT:    [[B0:%.*]] = extractelement <4 x double> [[B:%.*]], i32 0
; SLM-NEXT:    [[B1:%.*]] = extractelement <4 x double> [[B]], i32 1
; SLM-NEXT:    [[B2:%.*]] = extractelement <4 x double> [[B]], i32 2
; SLM-NEXT:    [[B3:%.*]] = extractelement <4 x double> [[B]], i32 3
; SLM-NEXT:    [[R0:%.*]] = fsub double [[A0]], [[A1]]
; SLM-NEXT:    [[R1:%.*]] = fsub double [[B0]], [[B1]]
; SLM-NEXT:    [[R2:%.*]] = fsub double [[A2]], [[A3]]
; SLM-NEXT:    [[R3:%.*]] = fsub double [[B2]], [[B3]]
; SLM-NEXT:    [[R00:%.*]] = insertelement <4 x double> poison, double [[R0]], i32 0
; SLM-NEXT:    [[R01:%.*]] = insertelement <4 x double> [[R00]], double [[R1]], i32 1
; SLM-NEXT:    [[R02:%.*]] = insertelement <4 x double> [[R01]], double [[R2]], i32 2
; SLM-NEXT:    [[R03:%.*]] = insertelement <4 x double> [[R02]], double [[R3]], i32 3
; SLM-NEXT:    ret <4 x double> [[R03]]
;
; AVX-LABEL: @test_v4f64(
; AVX-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[A:%.*]], <4 x double> [[B:%.*]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; AVX-NEXT:    [[TMP2:%.*]] = shufflevector <4 x double> [[A]], <4 x double> [[B]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; AVX-NEXT:    [[TMP3:%.*]] = fsub <4 x double> [[TMP1]], [[TMP2]]
; AVX-NEXT:    ret <4 x double> [[TMP3]]
;
  %a0 = extractelement <4 x double> %a, i32 0
  %a1 = extractelement <4 x double> %a, i32 1
  %a2 = extractelement <4 x double> %a, i32 2
  %a3 = extractelement <4 x double> %a, i32 3
  %b0 = extractelement <4 x double> %b, i32 0
  %b1 = extractelement <4 x double> %b, i32 1
  %b2 = extractelement <4 x double> %b, i32 2
  %b3 = extractelement <4 x double> %b, i32 3
  %r0 = fsub double %a0, %a1
  %r1 = fsub double %b0, %b1
  %r2 = fsub double %a2, %a3
  %r3 = fsub double %b2, %b3
  %r00 = insertelement <4 x double> poison, double %r0, i32 0
  %r01 = insertelement <4 x double>  %r00, double %r1, i32 1
  %r02 = insertelement <4 x double>  %r01, double %r2, i32 2
  %r03 = insertelement <4 x double>  %r02, double %r3, i32 3
  ret <4 x double> %r03
}

define <8 x float> @test_v8f32(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: @test_v8f32(
; SSE-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[A:%.*]], <8 x float> [[B:%.*]], <8 x i32> <i32 0, i32 2, i32 8, i32 10, i32 4, i32 6, i32 12, i32 14>
; SSE-NEXT:    [[TMP2:%.*]] = shufflevector <8 x float> [[A]], <8 x float> [[B]], <8 x i32> <i32 1, i32 3, i32 9, i32 11, i32 5, i32 7, i32 13, i32 15>
; SSE-NEXT:    [[TMP3:%.*]] = fsub <8 x float> [[TMP1]], [[TMP2]]
; SSE-NEXT:    ret <8 x float> [[TMP3]]
;
; SLM-LABEL: @test_v8f32(
; SLM-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[A:%.*]], <8 x float> [[B:%.*]], <4 x i32> <i32 0, i32 2, i32 8, i32 10>
; SLM-NEXT:    [[TMP2:%.*]] = shufflevector <8 x float> [[A]], <8 x float> [[B]], <4 x i32> <i32 1, i32 3, i32 9, i32 11>
; SLM-NEXT:    [[TMP3:%.*]] = fsub <4 x float> [[TMP1]], [[TMP2]]
; SLM-NEXT:    [[TMP4:%.*]] = shufflevector <8 x float> [[A]], <8 x float> [[B]], <4 x i32> <i32 4, i32 6, i32 12, i32 14>
; SLM-NEXT:    [[TMP5:%.*]] = shufflevector <8 x float> [[A]], <8 x float> [[B]], <4 x i32> <i32 5, i32 7, i32 13, i32 15>
; SLM-NEXT:    [[TMP6:%.*]] = fsub <4 x float> [[TMP4]], [[TMP5]]
; SLM-NEXT:    [[R07:%.*]] = shufflevector <4 x float> [[TMP3]], <4 x float> [[TMP6]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; SLM-NEXT:    ret <8 x float> [[R07]]
;
; AVX-LABEL: @test_v8f32(
; AVX-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[A:%.*]], <8 x float> [[B:%.*]], <8 x i32> <i32 0, i32 2, i32 8, i32 10, i32 4, i32 6, i32 12, i32 14>
; AVX-NEXT:    [[TMP2:%.*]] = shufflevector <8 x float> [[A]], <8 x float> [[B]], <8 x i32> <i32 1, i32 3, i32 9, i32 11, i32 5, i32 7, i32 13, i32 15>
; AVX-NEXT:    [[TMP3:%.*]] = fsub <8 x float> [[TMP1]], [[TMP2]]
; AVX-NEXT:    ret <8 x float> [[TMP3]]
;
  %a0 = extractelement <8 x float> %a, i32 0
  %a1 = extractelement <8 x float> %a, i32 1
  %a2 = extractelement <8 x float> %a, i32 2
  %a3 = extractelement <8 x float> %a, i32 3
  %a4 = extractelement <8 x float> %a, i32 4
  %a5 = extractelement <8 x float> %a, i32 5
  %a6 = extractelement <8 x float> %a, i32 6
  %a7 = extractelement <8 x float> %a, i32 7
  %b0 = extractelement <8 x float> %b, i32 0
  %b1 = extractelement <8 x float> %b, i32 1
  %b2 = extractelement <8 x float> %b, i32 2
  %b3 = extractelement <8 x float> %b, i32 3
  %b4 = extractelement <8 x float> %b, i32 4
  %b5 = extractelement <8 x float> %b, i32 5
  %b6 = extractelement <8 x float> %b, i32 6
  %b7 = extractelement <8 x float> %b, i32 7
  %r0 = fsub float %a0, %a1
  %r1 = fsub float %a2, %a3
  %r2 = fsub float %b0, %b1
  %r3 = fsub float %b2, %b3
  %r4 = fsub float %a4, %a5
  %r5 = fsub float %a6, %a7
  %r6 = fsub float %b4, %b5
  %r7 = fsub float %b6, %b7
  %r00 = insertelement <8 x float> poison, float %r0, i32 0
  %r01 = insertelement <8 x float>  %r00, float %r1, i32 1
  %r02 = insertelement <8 x float>  %r01, float %r2, i32 2
  %r03 = insertelement <8 x float>  %r02, float %r3, i32 3
  %r04 = insertelement <8 x float>  %r03, float %r4, i32 4
  %r05 = insertelement <8 x float>  %r04, float %r5, i32 5
  %r06 = insertelement <8 x float>  %r05, float %r6, i32 6
  %r07 = insertelement <8 x float>  %r06, float %r7, i32 7
  ret <8 x float> %r07
}

define <4 x i64> @test_v4i64(<4 x i64> %a, <4 x i64> %b) {
; CHECK-LABEL: @test_v4i64(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i64> [[A:%.*]], <4 x i64> [[B:%.*]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i64> [[A]], <4 x i64> [[B]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP3:%.*]] = sub <4 x i64> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <4 x i64> [[TMP3]]
;
  %a0 = extractelement <4 x i64> %a, i32 0
  %a1 = extractelement <4 x i64> %a, i32 1
  %a2 = extractelement <4 x i64> %a, i32 2
  %a3 = extractelement <4 x i64> %a, i32 3
  %b0 = extractelement <4 x i64> %b, i32 0
  %b1 = extractelement <4 x i64> %b, i32 1
  %b2 = extractelement <4 x i64> %b, i32 2
  %b3 = extractelement <4 x i64> %b, i32 3
  %r0 = sub i64 %a0, %a1
  %r1 = sub i64 %b0, %b1
  %r2 = sub i64 %a2, %a3
  %r3 = sub i64 %b2, %b3
  %r00 = insertelement <4 x i64> poison, i64 %r0, i32 0
  %r01 = insertelement <4 x i64>  %r00, i64 %r1, i32 1
  %r02 = insertelement <4 x i64>  %r01, i64 %r2, i32 2
  %r03 = insertelement <4 x i64>  %r02, i64 %r3, i32 3
  ret <4 x i64> %r03
}

define <8 x i32> @test_v8i32(<8 x i32> %a, <8 x i32> %b) {
; CHECK-LABEL: @test_v8i32(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A:%.*]], <8 x i32> [[B:%.*]], <8 x i32> <i32 0, i32 2, i32 8, i32 10, i32 4, i32 6, i32 12, i32 14>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> [[B]], <8 x i32> <i32 1, i32 3, i32 9, i32 11, i32 5, i32 7, i32 13, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = sub <8 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <8 x i32> [[TMP3]]
;
  %a0 = extractelement <8 x i32> %a, i32 0
  %a1 = extractelement <8 x i32> %a, i32 1
  %a2 = extractelement <8 x i32> %a, i32 2
  %a3 = extractelement <8 x i32> %a, i32 3
  %a4 = extractelement <8 x i32> %a, i32 4
  %a5 = extractelement <8 x i32> %a, i32 5
  %a6 = extractelement <8 x i32> %a, i32 6
  %a7 = extractelement <8 x i32> %a, i32 7
  %b0 = extractelement <8 x i32> %b, i32 0
  %b1 = extractelement <8 x i32> %b, i32 1
  %b2 = extractelement <8 x i32> %b, i32 2
  %b3 = extractelement <8 x i32> %b, i32 3
  %b4 = extractelement <8 x i32> %b, i32 4
  %b5 = extractelement <8 x i32> %b, i32 5
  %b6 = extractelement <8 x i32> %b, i32 6
  %b7 = extractelement <8 x i32> %b, i32 7
  %r0 = sub i32 %a0, %a1
  %r1 = sub i32 %a2, %a3
  %r2 = sub i32 %b0, %b1
  %r3 = sub i32 %b2, %b3
  %r4 = sub i32 %a4, %a5
  %r5 = sub i32 %a6, %a7
  %r6 = sub i32 %b4, %b5
  %r7 = sub i32 %b6, %b7
  %r00 = insertelement <8 x i32> poison, i32 %r0, i32 0
  %r01 = insertelement <8 x i32>  %r00, i32 %r1, i32 1
  %r02 = insertelement <8 x i32>  %r01, i32 %r2, i32 2
  %r03 = insertelement <8 x i32>  %r02, i32 %r3, i32 3
  %r04 = insertelement <8 x i32>  %r03, i32 %r4, i32 4
  %r05 = insertelement <8 x i32>  %r04, i32 %r5, i32 5
  %r06 = insertelement <8 x i32>  %r05, i32 %r6, i32 6
  %r07 = insertelement <8 x i32>  %r06, i32 %r7, i32 7
  ret <8 x i32> %r07
}

define <16 x i16> @test_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: @test_v16i16(
; SSE-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i16> [[A:%.*]], <16 x i16> [[B:%.*]], <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 16, i32 18, i32 20, i32 22>
; SSE-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i16> [[A]], <16 x i16> [[B]], <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 17, i32 19, i32 21, i32 23>
; SSE-NEXT:    [[TMP3:%.*]] = sub <8 x i16> [[TMP1]], [[TMP2]]
; SSE-NEXT:    [[TMP4:%.*]] = shufflevector <16 x i16> [[A]], <16 x i16> [[B]], <8 x i32> <i32 8, i32 10, i32 12, i32 14, i32 24, i32 26, i32 28, i32 30>
; SSE-NEXT:    [[TMP5:%.*]] = shufflevector <16 x i16> [[A]], <16 x i16> [[B]], <8 x i32> <i32 9, i32 11, i32 13, i32 15, i32 25, i32 27, i32 29, i32 31>
; SSE-NEXT:    [[TMP6:%.*]] = sub <8 x i16> [[TMP4]], [[TMP5]]
; SSE-NEXT:    [[RV15:%.*]] = shufflevector <8 x i16> [[TMP3]], <8 x i16> [[TMP6]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; SSE-NEXT:    ret <16 x i16> [[RV15]]
;
; SLM-LABEL: @test_v16i16(
; SLM-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i16> [[A:%.*]], <16 x i16> [[B:%.*]], <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 16, i32 18, i32 20, i32 22, i32 8, i32 10, i32 12, i32 14, i32 24, i32 26, i32 28, i32 30>
; SLM-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i16> [[A]], <16 x i16> [[B]], <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 17, i32 19, i32 21, i32 23, i32 9, i32 11, i32 13, i32 15, i32 25, i32 27, i32 29, i32 31>
; SLM-NEXT:    [[TMP3:%.*]] = sub <16 x i16> [[TMP1]], [[TMP2]]
; SLM-NEXT:    ret <16 x i16> [[TMP3]]
;
; AVX-LABEL: @test_v16i16(
; AVX-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i16> [[A:%.*]], <16 x i16> [[B:%.*]], <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 16, i32 18, i32 20, i32 22, i32 8, i32 10, i32 12, i32 14, i32 24, i32 26, i32 28, i32 30>
; AVX-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i16> [[A]], <16 x i16> [[B]], <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 17, i32 19, i32 21, i32 23, i32 9, i32 11, i32 13, i32 15, i32 25, i32 27, i32 29, i32 31>
; AVX-NEXT:    [[TMP3:%.*]] = sub <16 x i16> [[TMP1]], [[TMP2]]
; AVX-NEXT:    ret <16 x i16> [[TMP3]]
;
  %a0  = extractelement <16 x i16> %a, i32 0
  %a1  = extractelement <16 x i16> %a, i32 1
  %a2  = extractelement <16 x i16> %a, i32 2
  %a3  = extractelement <16 x i16> %a, i32 3
  %a4  = extractelement <16 x i16> %a, i32 4
  %a5  = extractelement <16 x i16> %a, i32 5
  %a6  = extractelement <16 x i16> %a, i32 6
  %a7  = extractelement <16 x i16> %a, i32 7
  %a8  = extractelement <16 x i16> %a, i32 8
  %a9  = extractelement <16 x i16> %a, i32 9
  %a10 = extractelement <16 x i16> %a, i32 10
  %a11 = extractelement <16 x i16> %a, i32 11
  %a12 = extractelement <16 x i16> %a, i32 12
  %a13 = extractelement <16 x i16> %a, i32 13
  %a14 = extractelement <16 x i16> %a, i32 14
  %a15 = extractelement <16 x i16> %a, i32 15
  %b0  = extractelement <16 x i16> %b, i32 0
  %b1  = extractelement <16 x i16> %b, i32 1
  %b2  = extractelement <16 x i16> %b, i32 2
  %b3  = extractelement <16 x i16> %b, i32 3
  %b4  = extractelement <16 x i16> %b, i32 4
  %b5  = extractelement <16 x i16> %b, i32 5
  %b6  = extractelement <16 x i16> %b, i32 6
  %b7  = extractelement <16 x i16> %b, i32 7
  %b8  = extractelement <16 x i16> %b, i32 8
  %b9  = extractelement <16 x i16> %b, i32 9
  %b10 = extractelement <16 x i16> %b, i32 10
  %b11 = extractelement <16 x i16> %b, i32 11
  %b12 = extractelement <16 x i16> %b, i32 12
  %b13 = extractelement <16 x i16> %b, i32 13
  %b14 = extractelement <16 x i16> %b, i32 14
  %b15 = extractelement <16 x i16> %b, i32 15
  %r0  = sub i16 %a0 , %a1
  %r1  = sub i16 %a2 , %a3
  %r2  = sub i16 %a4 , %a5
  %r3  = sub i16 %a6 , %a7
  %r4  = sub i16 %b0 , %b1
  %r5  = sub i16 %b2 , %b3
  %r6  = sub i16 %b4 , %b5
  %r7  = sub i16 %b6 , %b7
  %r8  = sub i16 %a8 , %a9
  %r9  = sub i16 %a10, %a11
  %r10 = sub i16 %a12, %a13
  %r11 = sub i16 %a14, %a15
  %r12 = sub i16 %b8 , %b9
  %r13 = sub i16 %b10, %b11
  %r14 = sub i16 %b12, %b13
  %r15 = sub i16 %b14, %b15
  %rv0  = insertelement <16 x i16> poison, i16 %r0 , i32 0
  %rv1  = insertelement <16 x i16> %rv0 , i16 %r1 , i32 1
  %rv2  = insertelement <16 x i16> %rv1 , i16 %r2 , i32 2
  %rv3  = insertelement <16 x i16> %rv2 , i16 %r3 , i32 3
  %rv4  = insertelement <16 x i16> %rv3 , i16 %r4 , i32 4
  %rv5  = insertelement <16 x i16> %rv4 , i16 %r5 , i32 5
  %rv6  = insertelement <16 x i16> %rv5 , i16 %r6 , i32 6
  %rv7  = insertelement <16 x i16> %rv6 , i16 %r7 , i32 7
  %rv8  = insertelement <16 x i16> %rv7 , i16 %r8 , i32 8
  %rv9  = insertelement <16 x i16> %rv8 , i16 %r9 , i32 9
  %rv10 = insertelement <16 x i16> %rv9 , i16 %r10, i32 10
  %rv11 = insertelement <16 x i16> %rv10, i16 %r11, i32 11
  %rv12 = insertelement <16 x i16> %rv11, i16 %r12, i32 12
  %rv13 = insertelement <16 x i16> %rv12, i16 %r13, i32 13
  %rv14 = insertelement <16 x i16> %rv13, i16 %r14, i32 14
  %rv15 = insertelement <16 x i16> %rv14, i16 %r15, i32 15
  ret <16 x i16> %rv15
}
