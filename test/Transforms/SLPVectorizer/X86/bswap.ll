; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@src64 = common global [4 x i64] zeroinitializer, align 32
@dst64 = common global [4 x i64] zeroinitializer, align 32
@src32 = common global [8 x i32] zeroinitializer, align 32
@dst32 = common global [8 x i32] zeroinitializer, align 32
@src16 = common global [16 x i16] zeroinitializer, align 32
@dst16 = common global [16 x i16] zeroinitializer, align 32

declare i64 @llvm.bswap.i64(i64)
declare i32 @llvm.bswap.i32(i32)
declare i16 @llvm.bswap.i16(i16)

define void @bswap_2i64() #0 {
; SSE-LABEL: @bswap_2i64(
; SSE-NEXT:    [[LD0:%.*]] = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i32 0, i64 0), align 8
; SSE-NEXT:    [[LD1:%.*]] = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i32 0, i64 1), align 8
; SSE-NEXT:    [[BSWAP0:%.*]] = call i64 @llvm.bswap.i64(i64 [[LD0]])
; SSE-NEXT:    [[BSWAP1:%.*]] = call i64 @llvm.bswap.i64(i64 [[LD1]])
; SSE-NEXT:    store i64 [[BSWAP0]], i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i32 0, i64 0), align 8
; SSE-NEXT:    store i64 [[BSWAP1]], i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i32 0, i64 1), align 8
; SSE-NEXT:    ret void
;
; AVX-LABEL: @bswap_2i64(
; AVX-NEXT:    [[TMP1:%.*]] = load <2 x i64>, <2 x i64>* bitcast ([4 x i64]* @src64 to <2 x i64>*), align 8
; AVX-NEXT:    [[TMP2:%.*]] = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> [[TMP1]])
; AVX-NEXT:    store <2 x i64> [[TMP2]], <2 x i64>* bitcast ([4 x i64]* @dst64 to <2 x i64>*), align 8
; AVX-NEXT:    ret void
;
  %ld0 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i32 0, i64 0), align 8
  %ld1 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i32 0, i64 1), align 8
  %bswap0 = call i64 @llvm.bswap.i64(i64 %ld0)
  %bswap1 = call i64 @llvm.bswap.i64(i64 %ld1)
  store i64 %bswap0, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i32 0, i64 0), align 8
  store i64 %bswap1, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i32 0, i64 1), align 8
  ret void
}

define void @bswap_4i64() #0 {
; SSE-LABEL: @bswap_4i64(
; SSE-NEXT:    [[LD0:%.*]] = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 0), align 4
; SSE-NEXT:    [[LD1:%.*]] = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 1), align 4
; SSE-NEXT:    [[LD2:%.*]] = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 2), align 4
; SSE-NEXT:    [[LD3:%.*]] = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 3), align 4
; SSE-NEXT:    [[BSWAP0:%.*]] = call i64 @llvm.bswap.i64(i64 [[LD0]])
; SSE-NEXT:    [[BSWAP1:%.*]] = call i64 @llvm.bswap.i64(i64 [[LD1]])
; SSE-NEXT:    [[BSWAP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[LD2]])
; SSE-NEXT:    [[BSWAP3:%.*]] = call i64 @llvm.bswap.i64(i64 [[LD3]])
; SSE-NEXT:    store i64 [[BSWAP0]], i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 0), align 4
; SSE-NEXT:    store i64 [[BSWAP1]], i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 1), align 4
; SSE-NEXT:    store i64 [[BSWAP2]], i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 2), align 4
; SSE-NEXT:    store i64 [[BSWAP3]], i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 3), align 4
; SSE-NEXT:    ret void
;
; AVX-LABEL: @bswap_4i64(
; AVX-NEXT:    [[TMP1:%.*]] = load <4 x i64>, <4 x i64>* bitcast ([4 x i64]* @src64 to <4 x i64>*), align 4
; AVX-NEXT:    [[TMP2:%.*]] = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> [[TMP1]])
; AVX-NEXT:    store <4 x i64> [[TMP2]], <4 x i64>* bitcast ([4 x i64]* @dst64 to <4 x i64>*), align 4
; AVX-NEXT:    ret void
;
  %ld0 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 0), align 4
  %ld1 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 1), align 4
  %ld2 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 2), align 4
  %ld3 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @src64, i64 0, i64 3), align 4
  %bswap0 = call i64 @llvm.bswap.i64(i64 %ld0)
  %bswap1 = call i64 @llvm.bswap.i64(i64 %ld1)
  %bswap2 = call i64 @llvm.bswap.i64(i64 %ld2)
  %bswap3 = call i64 @llvm.bswap.i64(i64 %ld3)
  store i64 %bswap0, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 0), align 4
  store i64 %bswap1, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 1), align 4
  store i64 %bswap2, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 2), align 4
  store i64 %bswap3, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @dst64, i64 0, i64 3), align 4
  ret void
}

define void @bswap_4i32() #0 {
; CHECK-LABEL: @bswap_4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([8 x i32]* @src32 to <4 x i32>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> [[TMP1]])
; CHECK-NEXT:    store <4 x i32> [[TMP2]], <4 x i32>* bitcast ([8 x i32]* @dst32 to <4 x i32>*), align 4
; CHECK-NEXT:    ret void
;
  %ld0 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 0), align 4
  %ld1 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 1), align 4
  %ld2 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 2), align 4
  %ld3 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 3), align 4
  %bswap0 = call i32 @llvm.bswap.i32(i32 %ld0)
  %bswap1 = call i32 @llvm.bswap.i32(i32 %ld1)
  %bswap2 = call i32 @llvm.bswap.i32(i32 %ld2)
  %bswap3 = call i32 @llvm.bswap.i32(i32 %ld3)
  store i32 %bswap0, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 0), align 4
  store i32 %bswap1, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 1), align 4
  store i32 %bswap2, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 2), align 4
  store i32 %bswap3, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 3), align 4
  ret void
}

define void @bswap_8i32() #0 {
; SSE-LABEL: @bswap_8i32(
; SSE-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* bitcast ([8 x i32]* @src32 to <4 x i32>*), align 2
; SSE-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> [[TMP1]])
; SSE-NEXT:    store <4 x i32> [[TMP2]], <4 x i32>* bitcast ([8 x i32]* @dst32 to <4 x i32>*), align 2
; SSE-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* bitcast (i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 4) to <4 x i32>*), align 2
; SSE-NEXT:    [[TMP4:%.*]] = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> [[TMP3]])
; SSE-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* bitcast (i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 4) to <4 x i32>*), align 2
; SSE-NEXT:    ret void
;
; AVX-LABEL: @bswap_8i32(
; AVX-NEXT:    [[TMP1:%.*]] = load <8 x i32>, <8 x i32>* bitcast ([8 x i32]* @src32 to <8 x i32>*), align 2
; AVX-NEXT:    [[TMP2:%.*]] = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> [[TMP1]])
; AVX-NEXT:    store <8 x i32> [[TMP2]], <8 x i32>* bitcast ([8 x i32]* @dst32 to <8 x i32>*), align 2
; AVX-NEXT:    ret void
;
  %ld0 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 0), align 2
  %ld1 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 1), align 2
  %ld2 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 2), align 2
  %ld3 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 3), align 2
  %ld4 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 4), align 2
  %ld5 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 5), align 2
  %ld6 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 6), align 2
  %ld7 = load i32, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @src32, i32 0, i64 7), align 2
  %bswap0 = call i32 @llvm.bswap.i32(i32 %ld0)
  %bswap1 = call i32 @llvm.bswap.i32(i32 %ld1)
  %bswap2 = call i32 @llvm.bswap.i32(i32 %ld2)
  %bswap3 = call i32 @llvm.bswap.i32(i32 %ld3)
  %bswap4 = call i32 @llvm.bswap.i32(i32 %ld4)
  %bswap5 = call i32 @llvm.bswap.i32(i32 %ld5)
  %bswap6 = call i32 @llvm.bswap.i32(i32 %ld6)
  %bswap7 = call i32 @llvm.bswap.i32(i32 %ld7)
  store i32 %bswap0, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 0), align 2
  store i32 %bswap1, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 1), align 2
  store i32 %bswap2, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 2), align 2
  store i32 %bswap3, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 3), align 2
  store i32 %bswap4, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 4), align 2
  store i32 %bswap5, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 5), align 2
  store i32 %bswap6, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 6), align 2
  store i32 %bswap7, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @dst32, i32 0, i64 7), align 2
  ret void
}

define void @bswap_8i16() #0 {
; CHECK-LABEL: @bswap_8i16(
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x i16>, <8 x i16>* bitcast ([16 x i16]* @src16 to <8 x i16>*), align 2
; CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> [[TMP1]])
; CHECK-NEXT:    store <8 x i16> [[TMP2]], <8 x i16>* bitcast ([16 x i16]* @dst16 to <8 x i16>*), align 2
; CHECK-NEXT:    ret void
;
  %ld0 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 0), align 2
  %ld1 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 1), align 2
  %ld2 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 2), align 2
  %ld3 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 3), align 2
  %ld4 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 4), align 2
  %ld5 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 5), align 2
  %ld6 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 6), align 2
  %ld7 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 7), align 2
  %bswap0 = call i16 @llvm.bswap.i16(i16 %ld0)
  %bswap1 = call i16 @llvm.bswap.i16(i16 %ld1)
  %bswap2 = call i16 @llvm.bswap.i16(i16 %ld2)
  %bswap3 = call i16 @llvm.bswap.i16(i16 %ld3)
  %bswap4 = call i16 @llvm.bswap.i16(i16 %ld4)
  %bswap5 = call i16 @llvm.bswap.i16(i16 %ld5)
  %bswap6 = call i16 @llvm.bswap.i16(i16 %ld6)
  %bswap7 = call i16 @llvm.bswap.i16(i16 %ld7)
  store i16 %bswap0, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 0), align 2
  store i16 %bswap1, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 1), align 2
  store i16 %bswap2, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 2), align 2
  store i16 %bswap3, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 3), align 2
  store i16 %bswap4, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 4), align 2
  store i16 %bswap5, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 5), align 2
  store i16 %bswap6, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 6), align 2
  store i16 %bswap7, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 7), align 2
  ret void
}

define void @bswap_16i16() #0 {
; SSE-LABEL: @bswap_16i16(
; SSE-NEXT:    [[TMP1:%.*]] = load <8 x i16>, <8 x i16>* bitcast ([16 x i16]* @src16 to <8 x i16>*), align 2
; SSE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> [[TMP1]])
; SSE-NEXT:    store <8 x i16> [[TMP2]], <8 x i16>* bitcast ([16 x i16]* @dst16 to <8 x i16>*), align 2
; SSE-NEXT:    [[TMP3:%.*]] = load <8 x i16>, <8 x i16>* bitcast (i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 8) to <8 x i16>*), align 2
; SSE-NEXT:    [[TMP4:%.*]] = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> [[TMP3]])
; SSE-NEXT:    store <8 x i16> [[TMP4]], <8 x i16>* bitcast (i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 8) to <8 x i16>*), align 2
; SSE-NEXT:    ret void
;
; AVX-LABEL: @bswap_16i16(
; AVX-NEXT:    [[TMP1:%.*]] = load <16 x i16>, <16 x i16>* bitcast ([16 x i16]* @src16 to <16 x i16>*), align 2
; AVX-NEXT:    [[TMP2:%.*]] = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> [[TMP1]])
; AVX-NEXT:    store <16 x i16> [[TMP2]], <16 x i16>* bitcast ([16 x i16]* @dst16 to <16 x i16>*), align 2
; AVX-NEXT:    ret void
;
  %ld0  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  0), align 2
  %ld1  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  1), align 2
  %ld2  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  2), align 2
  %ld3  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  3), align 2
  %ld4  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  4), align 2
  %ld5  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  5), align 2
  %ld6  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  6), align 2
  %ld7  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  7), align 2
  %ld8  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  8), align 2
  %ld9  = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64  9), align 2
  %ld10 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 10), align 2
  %ld11 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 11), align 2
  %ld12 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 12), align 2
  %ld13 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 13), align 2
  %ld14 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 14), align 2
  %ld15 = load i16, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @src16, i16 0, i64 15), align 2
  %bswap0  = call i16 @llvm.bswap.i16(i16 %ld0)
  %bswap1  = call i16 @llvm.bswap.i16(i16 %ld1)
  %bswap2  = call i16 @llvm.bswap.i16(i16 %ld2)
  %bswap3  = call i16 @llvm.bswap.i16(i16 %ld3)
  %bswap4  = call i16 @llvm.bswap.i16(i16 %ld4)
  %bswap5  = call i16 @llvm.bswap.i16(i16 %ld5)
  %bswap6  = call i16 @llvm.bswap.i16(i16 %ld6)
  %bswap7  = call i16 @llvm.bswap.i16(i16 %ld7)
  %bswap8  = call i16 @llvm.bswap.i16(i16 %ld8)
  %bswap9  = call i16 @llvm.bswap.i16(i16 %ld9)
  %bswap10 = call i16 @llvm.bswap.i16(i16 %ld10)
  %bswap11 = call i16 @llvm.bswap.i16(i16 %ld11)
  %bswap12 = call i16 @llvm.bswap.i16(i16 %ld12)
  %bswap13 = call i16 @llvm.bswap.i16(i16 %ld13)
  %bswap14 = call i16 @llvm.bswap.i16(i16 %ld14)
  %bswap15 = call i16 @llvm.bswap.i16(i16 %ld15)
  store i16 %bswap0 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  0), align 2
  store i16 %bswap1 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  1), align 2
  store i16 %bswap2 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  2), align 2
  store i16 %bswap3 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  3), align 2
  store i16 %bswap4 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  4), align 2
  store i16 %bswap5 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  5), align 2
  store i16 %bswap6 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  6), align 2
  store i16 %bswap7 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  7), align 2
  store i16 %bswap8 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  8), align 2
  store i16 %bswap9 , i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64  9), align 2
  store i16 %bswap10, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 10), align 2
  store i16 %bswap11, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 11), align 2
  store i16 %bswap12, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 12), align 2
  store i16 %bswap13, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 13), align 2
  store i16 %bswap14, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 14), align 2
  store i16 %bswap15, i16* getelementptr inbounds ([16 x i16], [16 x i16]* @dst16, i16 0, i64 15), align 2
  ret void
}

attributes #0 = { nounwind }
