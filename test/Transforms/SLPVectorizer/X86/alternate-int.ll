; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=slm -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefixes=CHECK,SLM
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefixes=CHECK,AVX1
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefixes=CHECK,AVX2
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=knl -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefixes=CHECK,AVX512
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skx -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefixes=CHECK,AVX512

define <8 x i32> @add_sub_v8i32(<8 x i32> %a, <8 x i32> %b) {
; CHECK-LABEL: @add_sub_v8i32(
; CHECK-NEXT:    [[TMP1:%.*]] = add <8 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = sub <8 x i32> [[A]], [[B]]
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
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
  %ab0 = add i32 %a0, %b0
  %ab1 = add i32 %a1, %b1
  %ab2 = add i32 %a2, %b2
  %ab3 = add i32 %a3, %b3
  %ab4 = sub i32 %a4, %b4
  %ab5 = sub i32 %a5, %b5
  %ab6 = sub i32 %a6, %b6
  %ab7 = sub i32 %a7, %b7
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}

define <4 x i32> @add_and_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @add_and_v4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i32> [[A]], [[B]]
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> [[TMP2]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
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
  %ab0 = add i32 %a0, %b0
  %ab1 = add i32 %a1, %b1
  %ab2 = and i32 %a2, %b2
  %ab3 = and i32 %a3, %b3
  %r0 = insertelement <4 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <4 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <4 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <4 x i32>   %r2, i32 %ab3, i32 3
  ret <4 x i32> %r3
}

define <4 x i32> @add_mul_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @add_mul_v4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = mul <4 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = add <4 x i32> [[A]], [[B]]
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> [[TMP2]], <4 x i32> <i32 0, i32 5, i32 6, i32 3>
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
  %ab0 = mul i32 %a0, %b0
  %ab1 = add i32 %a1, %b1
  %ab2 = add i32 %a2, %b2
  %ab3 = mul i32 %a3, %b3
  %r0 = insertelement <4 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <4 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <4 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <4 x i32>   %r2, i32 %ab3, i32 3
  ret <4 x i32> %r3
}

define <8 x i32> @ashr_shl_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: @ashr_shl_v8i32(
; SSE-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], [[B:%.*]]
; SSE-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], [[B]]
; SSE-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP2]], <8 x i32> poison, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; SSE-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
; SSE-NEXT:    [[R71:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP4]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11>
; SSE-NEXT:    ret <8 x i32> [[R71]]
;
; SLM-LABEL: @ashr_shl_v8i32(
; SLM-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], [[B:%.*]]
; SLM-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], [[B]]
; SLM-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; SLM-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX1-LABEL: @ashr_shl_v8i32(
; AVX1-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], [[B:%.*]]
; AVX1-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], [[B]]
; AVX1-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; AVX1-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX2-LABEL: @ashr_shl_v8i32(
; AVX2-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], [[B:%.*]]
; AVX2-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], [[B]]
; AVX2-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; AVX2-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX512-LABEL: @ashr_shl_v8i32(
; AVX512-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], [[B:%.*]]
; AVX512-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], [[B]]
; AVX512-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; AVX512-NEXT:    ret <8 x i32> [[TMP3]]
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
  %ab0 = ashr i32 %a0, %b0
  %ab1 = ashr i32 %a1, %b1
  %ab2 = ashr i32 %a2, %b2
  %ab3 = ashr i32 %a3, %b3
  %ab4 = shl  i32 %a4, %b4
  %ab5 = shl  i32 %a5, %b5
  %ab6 = shl  i32 %a6, %b6
  %ab7 = shl  i32 %a7, %b7
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}

define <8 x i32> @ashr_shl_v8i32_const(<8 x i32> %a) {
; SSE-LABEL: @ashr_shl_v8i32_const(
; SSE-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; SSE-NEXT:    [[TMP2:%.*]] = ashr <4 x i32> [[TMP1]], <i32 2, i32 2, i32 2, i32 2>
; SSE-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; SSE-NEXT:    [[TMP4:%.*]] = shl <4 x i32> [[TMP3]], <i32 3, i32 3, i32 3, i32 3>
; SSE-NEXT:    [[R71:%.*]] = shufflevector <4 x i32> [[TMP2]], <4 x i32> [[TMP4]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; SSE-NEXT:    ret <8 x i32> [[R71]]
;
; SLM-LABEL: @ashr_shl_v8i32_const(
; SLM-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; SLM-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; SLM-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; SLM-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX1-LABEL: @ashr_shl_v8i32_const(
; AVX1-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; AVX1-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; AVX1-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; AVX1-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX2-LABEL: @ashr_shl_v8i32_const(
; AVX2-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; AVX2-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; AVX2-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; AVX2-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX512-LABEL: @ashr_shl_v8i32_const(
; AVX512-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A:%.*]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; AVX512-NEXT:    [[TMP2:%.*]] = shl <8 x i32> [[A]], <i32 2, i32 2, i32 2, i32 2, i32 3, i32 3, i32 3, i32 3>
; AVX512-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[TMP2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; AVX512-NEXT:    ret <8 x i32> [[TMP3]]
;
  %a0 = extractelement <8 x i32> %a, i32 0
  %a1 = extractelement <8 x i32> %a, i32 1
  %a2 = extractelement <8 x i32> %a, i32 2
  %a3 = extractelement <8 x i32> %a, i32 3
  %a4 = extractelement <8 x i32> %a, i32 4
  %a5 = extractelement <8 x i32> %a, i32 5
  %a6 = extractelement <8 x i32> %a, i32 6
  %a7 = extractelement <8 x i32> %a, i32 7
  %ab0 = ashr i32 %a0, 2
  %ab1 = ashr i32 %a1, 2
  %ab2 = ashr i32 %a2, 2
  %ab3 = ashr i32 %a3, 2
  %ab4 = shl  i32 %a4, 3
  %ab5 = shl  i32 %a5, 3
  %ab6 = shl  i32 %a6, 3
  %ab7 = shl  i32 %a7, 3
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}

define <8 x i32> @ashr_lshr_shl_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: @ashr_lshr_shl_v8i32(
; SSE-NEXT:    [[A6:%.*]] = extractelement <8 x i32> [[A:%.*]], i64 6
; SSE-NEXT:    [[A7:%.*]] = extractelement <8 x i32> [[A]], i64 7
; SSE-NEXT:    [[B6:%.*]] = extractelement <8 x i32> [[B:%.*]], i64 6
; SSE-NEXT:    [[B7:%.*]] = extractelement <8 x i32> [[B]], i64 7
; SSE-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; SSE-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[B]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; SSE-NEXT:    [[TMP3:%.*]] = ashr <4 x i32> [[TMP1]], [[TMP2]]
; SSE-NEXT:    [[TMP4:%.*]] = lshr <4 x i32> [[TMP1]], [[TMP2]]
; SSE-NEXT:    [[TMP5:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; SSE-NEXT:    [[TMP6:%.*]] = lshr <8 x i32> [[A]], [[B]]
; SSE-NEXT:    [[TMP7:%.*]] = shufflevector <8 x i32> [[TMP6]], <8 x i32> poison, <2 x i32> <i32 4, i32 5>
; SSE-NEXT:    [[AB6:%.*]] = shl i32 [[A6]], [[B6]]
; SSE-NEXT:    [[AB7:%.*]] = shl i32 [[A7]], [[B7]]
; SSE-NEXT:    [[TMP8:%.*]] = shufflevector <4 x i32> [[TMP5]], <4 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
; SSE-NEXT:    [[TMP9:%.*]] = shufflevector <2 x i32> [[TMP7]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; SSE-NEXT:    [[R51:%.*]] = shufflevector <8 x i32> [[TMP8]], <8 x i32> [[TMP9]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 undef, i32 undef>
; SSE-NEXT:    [[R6:%.*]] = insertelement <8 x i32> [[R51]], i32 [[AB6]], i64 6
; SSE-NEXT:    [[R7:%.*]] = insertelement <8 x i32> [[R6]], i32 [[AB7]], i64 7
; SSE-NEXT:    ret <8 x i32> [[R7]]
;
; SLM-LABEL: @ashr_lshr_shl_v8i32(
; SLM-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; SLM-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[B:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; SLM-NEXT:    [[TMP3:%.*]] = ashr <4 x i32> [[TMP1]], [[TMP2]]
; SLM-NEXT:    [[TMP4:%.*]] = lshr <4 x i32> [[TMP1]], [[TMP2]]
; SLM-NEXT:    [[TMP5:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; SLM-NEXT:    [[TMP6:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; SLM-NEXT:    [[TMP7:%.*]] = shufflevector <8 x i32> [[B]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; SLM-NEXT:    [[TMP8:%.*]] = lshr <4 x i32> [[TMP6]], [[TMP7]]
; SLM-NEXT:    [[TMP9:%.*]] = shl <4 x i32> [[TMP6]], [[TMP7]]
; SLM-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> [[TMP9]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; SLM-NEXT:    [[R71:%.*]] = shufflevector <4 x i32> [[TMP5]], <4 x i32> [[TMP10]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; SLM-NEXT:    ret <8 x i32> [[R71]]
;
; AVX1-LABEL: @ashr_lshr_shl_v8i32(
; AVX1-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; AVX1-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[B:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; AVX1-NEXT:    [[TMP3:%.*]] = ashr <4 x i32> [[TMP1]], [[TMP2]]
; AVX1-NEXT:    [[TMP4:%.*]] = lshr <4 x i32> [[TMP1]], [[TMP2]]
; AVX1-NEXT:    [[TMP5:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; AVX1-NEXT:    [[TMP6:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; AVX1-NEXT:    [[TMP7:%.*]] = shufflevector <8 x i32> [[B]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; AVX1-NEXT:    [[TMP8:%.*]] = lshr <4 x i32> [[TMP6]], [[TMP7]]
; AVX1-NEXT:    [[TMP9:%.*]] = shl <4 x i32> [[TMP6]], [[TMP7]]
; AVX1-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> [[TMP9]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; AVX1-NEXT:    [[R71:%.*]] = shufflevector <4 x i32> [[TMP5]], <4 x i32> [[TMP10]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; AVX1-NEXT:    ret <8 x i32> [[R71]]
;
; AVX2-LABEL: @ashr_lshr_shl_v8i32(
; AVX2-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; AVX2-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[B:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; AVX2-NEXT:    [[TMP3:%.*]] = ashr <4 x i32> [[TMP1]], [[TMP2]]
; AVX2-NEXT:    [[TMP4:%.*]] = lshr <4 x i32> [[TMP1]], [[TMP2]]
; AVX2-NEXT:    [[TMP5:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; AVX2-NEXT:    [[TMP6:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; AVX2-NEXT:    [[TMP7:%.*]] = shufflevector <8 x i32> [[B]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; AVX2-NEXT:    [[TMP8:%.*]] = lshr <4 x i32> [[TMP6]], [[TMP7]]
; AVX2-NEXT:    [[TMP9:%.*]] = shl <4 x i32> [[TMP6]], [[TMP7]]
; AVX2-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> [[TMP9]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; AVX2-NEXT:    [[R71:%.*]] = shufflevector <4 x i32> [[TMP5]], <4 x i32> [[TMP10]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; AVX2-NEXT:    ret <8 x i32> [[R71]]
;
; AVX512-LABEL: @ashr_lshr_shl_v8i32(
; AVX512-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; AVX512-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[B:%.*]], <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; AVX512-NEXT:    [[TMP3:%.*]] = ashr <4 x i32> [[TMP1]], [[TMP2]]
; AVX512-NEXT:    [[TMP4:%.*]] = lshr <4 x i32> [[TMP1]], [[TMP2]]
; AVX512-NEXT:    [[TMP5:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; AVX512-NEXT:    [[TMP6:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; AVX512-NEXT:    [[TMP7:%.*]] = shufflevector <8 x i32> [[B]], <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; AVX512-NEXT:    [[TMP8:%.*]] = lshr <4 x i32> [[TMP6]], [[TMP7]]
; AVX512-NEXT:    [[TMP9:%.*]] = shl <4 x i32> [[TMP6]], [[TMP7]]
; AVX512-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> [[TMP9]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; AVX512-NEXT:    [[R71:%.*]] = shufflevector <4 x i32> [[TMP5]], <4 x i32> [[TMP10]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; AVX512-NEXT:    ret <8 x i32> [[R71]]
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
  %ab0 = ashr i32 %a0, %b0
  %ab1 = ashr i32 %a1, %b1
  %ab2 = lshr i32 %a2, %b2
  %ab3 = lshr i32 %a3, %b3
  %ab4 = lshr i32 %a4, %b4
  %ab5 = lshr i32 %a5, %b5
  %ab6 = shl  i32 %a6, %b6
  %ab7 = shl  i32 %a7, %b7
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}

define <8 x i32> @add_v8i32_undefs(<8 x i32> %a) {
; CHECK-LABEL: @add_v8i32_undefs(
; CHECK-NEXT:    [[TMP1:%.*]] = add <8 x i32> [[A:%.*]], <i32 undef, i32 4, i32 8, i32 16, i32 undef, i32 4, i32 8, i32 16>
; CHECK-NEXT:    ret <8 x i32> [[TMP1]]
;
  %a0 = extractelement <8 x i32> %a, i32 0
  %a1 = extractelement <8 x i32> %a, i32 1
  %a2 = extractelement <8 x i32> %a, i32 2
  %a3 = extractelement <8 x i32> %a, i32 3
  %a4 = extractelement <8 x i32> %a, i32 4
  %a5 = extractelement <8 x i32> %a, i32 5
  %a6 = extractelement <8 x i32> %a, i32 6
  %a7 = extractelement <8 x i32> %a, i32 7
  %ab0 = add i32 %a0, undef
  %ab1 = add i32 %a1, 4
  %ab2 = add i32 %a2, 8
  %ab3 = add i32 %a3, 16
  %ab4 = add i32 %a4, undef
  %ab5 = add i32 %a5, 4
  %ab6 = add i32 %a6, 8
  %ab7 = add i32 %a7, 16
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}

define <8 x i32> @sdiv_v8i32_undefs(<8 x i32> %a) {
; SSE-LABEL: @sdiv_v8i32_undefs(
; SSE-NEXT:    [[A1:%.*]] = extractelement <8 x i32> [[A:%.*]], i64 1
; SSE-NEXT:    [[A2:%.*]] = extractelement <8 x i32> [[A]], i64 2
; SSE-NEXT:    [[A3:%.*]] = extractelement <8 x i32> [[A]], i64 3
; SSE-NEXT:    [[A5:%.*]] = extractelement <8 x i32> [[A]], i64 5
; SSE-NEXT:    [[A6:%.*]] = extractelement <8 x i32> [[A]], i64 6
; SSE-NEXT:    [[A7:%.*]] = extractelement <8 x i32> [[A]], i64 7
; SSE-NEXT:    [[AB1:%.*]] = sdiv i32 [[A1]], 4
; SSE-NEXT:    [[AB2:%.*]] = sdiv i32 [[A2]], 8
; SSE-NEXT:    [[AB3:%.*]] = sdiv i32 [[A3]], 16
; SSE-NEXT:    [[AB5:%.*]] = sdiv i32 [[A5]], 4
; SSE-NEXT:    [[AB6:%.*]] = sdiv i32 [[A6]], 8
; SSE-NEXT:    [[AB7:%.*]] = sdiv i32 [[A7]], 16
; SSE-NEXT:    [[R1:%.*]] = insertelement <8 x i32> <i32 poison, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>, i32 [[AB1]], i64 1
; SSE-NEXT:    [[R2:%.*]] = insertelement <8 x i32> [[R1]], i32 [[AB2]], i64 2
; SSE-NEXT:    [[R3:%.*]] = insertelement <8 x i32> [[R2]], i32 [[AB3]], i64 3
; SSE-NEXT:    [[R5:%.*]] = insertelement <8 x i32> [[R3]], i32 [[AB5]], i64 5
; SSE-NEXT:    [[R6:%.*]] = insertelement <8 x i32> [[R5]], i32 [[AB6]], i64 6
; SSE-NEXT:    [[R7:%.*]] = insertelement <8 x i32> [[R6]], i32 [[AB7]], i64 7
; SSE-NEXT:    ret <8 x i32> [[R7]]
;
; SLM-LABEL: @sdiv_v8i32_undefs(
; SLM-NEXT:    [[A1:%.*]] = extractelement <8 x i32> [[A:%.*]], i64 1
; SLM-NEXT:    [[A2:%.*]] = extractelement <8 x i32> [[A]], i64 2
; SLM-NEXT:    [[A3:%.*]] = extractelement <8 x i32> [[A]], i64 3
; SLM-NEXT:    [[A5:%.*]] = extractelement <8 x i32> [[A]], i64 5
; SLM-NEXT:    [[A6:%.*]] = extractelement <8 x i32> [[A]], i64 6
; SLM-NEXT:    [[A7:%.*]] = extractelement <8 x i32> [[A]], i64 7
; SLM-NEXT:    [[AB1:%.*]] = sdiv i32 [[A1]], 4
; SLM-NEXT:    [[AB2:%.*]] = sdiv i32 [[A2]], 8
; SLM-NEXT:    [[AB3:%.*]] = sdiv i32 [[A3]], 16
; SLM-NEXT:    [[AB5:%.*]] = sdiv i32 [[A5]], 4
; SLM-NEXT:    [[AB6:%.*]] = sdiv i32 [[A6]], 8
; SLM-NEXT:    [[AB7:%.*]] = sdiv i32 [[A7]], 16
; SLM-NEXT:    [[R1:%.*]] = insertelement <8 x i32> <i32 poison, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>, i32 [[AB1]], i64 1
; SLM-NEXT:    [[R2:%.*]] = insertelement <8 x i32> [[R1]], i32 [[AB2]], i64 2
; SLM-NEXT:    [[R3:%.*]] = insertelement <8 x i32> [[R2]], i32 [[AB3]], i64 3
; SLM-NEXT:    [[R5:%.*]] = insertelement <8 x i32> [[R3]], i32 [[AB5]], i64 5
; SLM-NEXT:    [[R6:%.*]] = insertelement <8 x i32> [[R5]], i32 [[AB6]], i64 6
; SLM-NEXT:    [[R7:%.*]] = insertelement <8 x i32> [[R6]], i32 [[AB7]], i64 7
; SLM-NEXT:    ret <8 x i32> [[R7]]
;
; AVX1-LABEL: @sdiv_v8i32_undefs(
; AVX1-NEXT:    [[A1:%.*]] = extractelement <8 x i32> [[A:%.*]], i64 1
; AVX1-NEXT:    [[A2:%.*]] = extractelement <8 x i32> [[A]], i64 2
; AVX1-NEXT:    [[A3:%.*]] = extractelement <8 x i32> [[A]], i64 3
; AVX1-NEXT:    [[A5:%.*]] = extractelement <8 x i32> [[A]], i64 5
; AVX1-NEXT:    [[A6:%.*]] = extractelement <8 x i32> [[A]], i64 6
; AVX1-NEXT:    [[A7:%.*]] = extractelement <8 x i32> [[A]], i64 7
; AVX1-NEXT:    [[AB1:%.*]] = sdiv i32 [[A1]], 4
; AVX1-NEXT:    [[AB2:%.*]] = sdiv i32 [[A2]], 8
; AVX1-NEXT:    [[AB3:%.*]] = sdiv i32 [[A3]], 16
; AVX1-NEXT:    [[AB5:%.*]] = sdiv i32 [[A5]], 4
; AVX1-NEXT:    [[AB6:%.*]] = sdiv i32 [[A6]], 8
; AVX1-NEXT:    [[AB7:%.*]] = sdiv i32 [[A7]], 16
; AVX1-NEXT:    [[R1:%.*]] = insertelement <8 x i32> <i32 poison, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>, i32 [[AB1]], i64 1
; AVX1-NEXT:    [[R2:%.*]] = insertelement <8 x i32> [[R1]], i32 [[AB2]], i64 2
; AVX1-NEXT:    [[R3:%.*]] = insertelement <8 x i32> [[R2]], i32 [[AB3]], i64 3
; AVX1-NEXT:    [[R5:%.*]] = insertelement <8 x i32> [[R3]], i32 [[AB5]], i64 5
; AVX1-NEXT:    [[R6:%.*]] = insertelement <8 x i32> [[R5]], i32 [[AB6]], i64 6
; AVX1-NEXT:    [[R7:%.*]] = insertelement <8 x i32> [[R6]], i32 [[AB7]], i64 7
; AVX1-NEXT:    ret <8 x i32> [[R7]]
;
; AVX2-LABEL: @sdiv_v8i32_undefs(
; AVX2-NEXT:    [[A1:%.*]] = extractelement <8 x i32> [[A:%.*]], i64 1
; AVX2-NEXT:    [[A5:%.*]] = extractelement <8 x i32> [[A]], i64 5
; AVX2-NEXT:    [[AB1:%.*]] = sdiv i32 [[A1]], 4
; AVX2-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <2 x i32> <i32 2, i32 3>
; AVX2-NEXT:    [[TMP2:%.*]] = sdiv <2 x i32> [[TMP1]], <i32 8, i32 16>
; AVX2-NEXT:    [[AB5:%.*]] = sdiv i32 [[A5]], 4
; AVX2-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <2 x i32> <i32 6, i32 7>
; AVX2-NEXT:    [[TMP4:%.*]] = sdiv <2 x i32> [[TMP3]], <i32 8, i32 16>
; AVX2-NEXT:    [[R1:%.*]] = insertelement <8 x i32> <i32 poison, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>, i32 [[AB1]], i64 1
; AVX2-NEXT:    [[TMP5:%.*]] = shufflevector <2 x i32> [[TMP2]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; AVX2-NEXT:    [[R32:%.*]] = shufflevector <8 x i32> [[R1]], <8 x i32> [[TMP5]], <8 x i32> <i32 undef, i32 1, i32 8, i32 9, i32 undef, i32 undef, i32 undef, i32 undef>
; AVX2-NEXT:    [[R5:%.*]] = insertelement <8 x i32> [[R32]], i32 [[AB5]], i64 5
; AVX2-NEXT:    [[TMP6:%.*]] = shufflevector <2 x i32> [[TMP4]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; AVX2-NEXT:    [[R71:%.*]] = shufflevector <8 x i32> [[R5]], <8 x i32> [[TMP6]], <8 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 undef, i32 5, i32 8, i32 9>
; AVX2-NEXT:    ret <8 x i32> [[R71]]
;
; AVX512-LABEL: @sdiv_v8i32_undefs(
; AVX512-NEXT:    [[A1:%.*]] = extractelement <8 x i32> [[A:%.*]], i64 1
; AVX512-NEXT:    [[A5:%.*]] = extractelement <8 x i32> [[A]], i64 5
; AVX512-NEXT:    [[AB1:%.*]] = sdiv i32 [[A1]], 4
; AVX512-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <2 x i32> <i32 2, i32 3>
; AVX512-NEXT:    [[TMP2:%.*]] = sdiv <2 x i32> [[TMP1]], <i32 8, i32 16>
; AVX512-NEXT:    [[AB5:%.*]] = sdiv i32 [[A5]], 4
; AVX512-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i32> [[A]], <8 x i32> undef, <2 x i32> <i32 6, i32 7>
; AVX512-NEXT:    [[TMP4:%.*]] = sdiv <2 x i32> [[TMP3]], <i32 8, i32 16>
; AVX512-NEXT:    [[R1:%.*]] = insertelement <8 x i32> <i32 poison, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>, i32 [[AB1]], i64 1
; AVX512-NEXT:    [[TMP5:%.*]] = shufflevector <2 x i32> [[TMP2]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; AVX512-NEXT:    [[R32:%.*]] = shufflevector <8 x i32> [[R1]], <8 x i32> [[TMP5]], <8 x i32> <i32 undef, i32 1, i32 8, i32 9, i32 undef, i32 undef, i32 undef, i32 undef>
; AVX512-NEXT:    [[R5:%.*]] = insertelement <8 x i32> [[R32]], i32 [[AB5]], i64 5
; AVX512-NEXT:    [[TMP6:%.*]] = shufflevector <2 x i32> [[TMP4]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; AVX512-NEXT:    [[R71:%.*]] = shufflevector <8 x i32> [[R5]], <8 x i32> [[TMP6]], <8 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 undef, i32 5, i32 8, i32 9>
; AVX512-NEXT:    ret <8 x i32> [[R71]]
;
  %a0 = extractelement <8 x i32> %a, i32 0
  %a1 = extractelement <8 x i32> %a, i32 1
  %a2 = extractelement <8 x i32> %a, i32 2
  %a3 = extractelement <8 x i32> %a, i32 3
  %a4 = extractelement <8 x i32> %a, i32 4
  %a5 = extractelement <8 x i32> %a, i32 5
  %a6 = extractelement <8 x i32> %a, i32 6
  %a7 = extractelement <8 x i32> %a, i32 7
  %ab0 = sdiv i32 %a0, undef
  %ab1 = sdiv i32 %a1, 4
  %ab2 = sdiv i32 %a2, 8
  %ab3 = sdiv i32 %a3, 16
  %ab4 = sdiv i32 %a4, undef
  %ab5 = sdiv i32 %a5, 4
  %ab6 = sdiv i32 %a6, 8
  %ab7 = sdiv i32 %a7, 16
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}

define <8 x i32> @add_sub_v8i32_splat(<8 x i32> %a, i32 %b) {
; CHECK-LABEL: @add_sub_v8i32_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> poison, i32 [[B:%.*]], i64 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = add <8 x i32> [[SHUFFLE]], [[A:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sub <8 x i32> [[SHUFFLE]], [[A]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <8 x i32> [[TMP2]], <8 x i32> [[TMP3]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    ret <8 x i32> [[TMP4]]
;
  %a0 = extractelement <8 x i32> %a, i32 0
  %a1 = extractelement <8 x i32> %a, i32 1
  %a2 = extractelement <8 x i32> %a, i32 2
  %a3 = extractelement <8 x i32> %a, i32 3
  %a4 = extractelement <8 x i32> %a, i32 4
  %a5 = extractelement <8 x i32> %a, i32 5
  %a6 = extractelement <8 x i32> %a, i32 6
  %a7 = extractelement <8 x i32> %a, i32 7
  %ab0 = add i32 %a0, %b
  %ab1 = add i32 %b, %a1
  %ab2 = add i32 %a2, %b
  %ab3 = add i32 %b, %a3
  %ab4 = sub i32 %b, %a4
  %ab5 = sub i32 %b, %a5
  %ab6 = sub i32 %b, %a6
  %ab7 = sub i32 %b, %a7
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}
