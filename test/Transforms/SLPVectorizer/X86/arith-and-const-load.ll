; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64    -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=SSE
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64-v2 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=SSE
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64-v3 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=AVX
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64-v4 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=AVX

; // PR49934
; void baz(unsigned char *dst, unsigned char *src) {
;   for( int x = 0; x < 8; x++ ) {
;     dst[x] = src[x]&(~63);
;   }
; }

define void @and4(ptr noalias nocapture noundef writeonly %dst, ptr noalias nocapture noundef readonly %src) {
; SSE-LABEL: @and4(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load i8, ptr [[SRC:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], -64
; SSE-NEXT:    store i8 [[TMP1]], ptr [[DST:%.*]], align 1
; SSE-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 1
; SSE-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = and i8 [[TMP2]], -64
; SSE-NEXT:    [[ARRAYIDX3_1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 1
; SSE-NEXT:    store i8 [[TMP3]], ptr [[ARRAYIDX3_1]], align 1
; SSE-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 2
; SSE-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; SSE-NEXT:    [[TMP5:%.*]] = and i8 [[TMP4]], -64
; SSE-NEXT:    [[ARRAYIDX3_2:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 2
; SSE-NEXT:    store i8 [[TMP5]], ptr [[ARRAYIDX3_2]], align 1
; SSE-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 3
; SSE-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; SSE-NEXT:    [[TMP7:%.*]] = and i8 [[TMP6]], -64
; SSE-NEXT:    [[ARRAYIDX3_3:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 3
; SSE-NEXT:    store i8 [[TMP7]], ptr [[ARRAYIDX3_3]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @and4(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load i8, ptr [[SRC:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], -64
; AVX-NEXT:    store i8 [[TMP1]], ptr [[DST:%.*]], align 1
; AVX-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 1
; AVX-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = and i8 [[TMP2]], -64
; AVX-NEXT:    [[ARRAYIDX3_1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 1
; AVX-NEXT:    store i8 [[TMP3]], ptr [[ARRAYIDX3_1]], align 1
; AVX-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 2
; AVX-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; AVX-NEXT:    [[TMP5:%.*]] = and i8 [[TMP4]], -64
; AVX-NEXT:    [[ARRAYIDX3_2:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 2
; AVX-NEXT:    store i8 [[TMP5]], ptr [[ARRAYIDX3_2]], align 1
; AVX-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 3
; AVX-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; AVX-NEXT:    [[TMP7:%.*]] = and i8 [[TMP6]], -64
; AVX-NEXT:    [[ARRAYIDX3_3:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 3
; AVX-NEXT:    store i8 [[TMP7]], ptr [[ARRAYIDX3_3]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %src, align 1
  %1 = and i8 %0, -64
  store i8 %1, ptr %dst, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %src, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %3 = and i8 %2, -64
  %arrayidx3.1 = getelementptr inbounds i8, ptr %dst, i64 1
  store i8 %3, ptr %arrayidx3.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %src, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %5 = and i8 %4, -64
  %arrayidx3.2 = getelementptr inbounds i8, ptr %dst, i64 2
  store i8 %5, ptr %arrayidx3.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %src, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %7 = and i8 %6, -64
  %arrayidx3.3 = getelementptr inbounds i8, ptr %dst, i64 3
  store i8 %7, ptr %arrayidx3.3, align 1
  ret void
}

define void @and8(ptr noalias nocapture noundef writeonly %dst, ptr noalias nocapture noundef readonly %src) {
; SSE-LABEL: @and8(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load i8, ptr [[SRC:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], -64
; SSE-NEXT:    store i8 [[TMP1]], ptr [[DST:%.*]], align 1
; SSE-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 1
; SSE-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = and i8 [[TMP2]], -64
; SSE-NEXT:    [[ARRAYIDX3_1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 1
; SSE-NEXT:    store i8 [[TMP3]], ptr [[ARRAYIDX3_1]], align 1
; SSE-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 2
; SSE-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; SSE-NEXT:    [[TMP5:%.*]] = and i8 [[TMP4]], -64
; SSE-NEXT:    [[ARRAYIDX3_2:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 2
; SSE-NEXT:    store i8 [[TMP5]], ptr [[ARRAYIDX3_2]], align 1
; SSE-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 3
; SSE-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; SSE-NEXT:    [[TMP7:%.*]] = and i8 [[TMP6]], -64
; SSE-NEXT:    [[ARRAYIDX3_3:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 3
; SSE-NEXT:    store i8 [[TMP7]], ptr [[ARRAYIDX3_3]], align 1
; SSE-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 4
; SSE-NEXT:    [[TMP8:%.*]] = load i8, ptr [[ARRAYIDX_4]], align 1
; SSE-NEXT:    [[TMP9:%.*]] = and i8 [[TMP8]], -64
; SSE-NEXT:    [[ARRAYIDX3_4:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 4
; SSE-NEXT:    store i8 [[TMP9]], ptr [[ARRAYIDX3_4]], align 1
; SSE-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 5
; SSE-NEXT:    [[TMP10:%.*]] = load i8, ptr [[ARRAYIDX_5]], align 1
; SSE-NEXT:    [[TMP11:%.*]] = and i8 [[TMP10]], -64
; SSE-NEXT:    [[ARRAYIDX3_5:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 5
; SSE-NEXT:    store i8 [[TMP11]], ptr [[ARRAYIDX3_5]], align 1
; SSE-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 6
; SSE-NEXT:    [[TMP12:%.*]] = load i8, ptr [[ARRAYIDX_6]], align 1
; SSE-NEXT:    [[TMP13:%.*]] = and i8 [[TMP12]], -64
; SSE-NEXT:    [[ARRAYIDX3_6:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 6
; SSE-NEXT:    store i8 [[TMP13]], ptr [[ARRAYIDX3_6]], align 1
; SSE-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 7
; SSE-NEXT:    [[TMP14:%.*]] = load i8, ptr [[ARRAYIDX_7]], align 1
; SSE-NEXT:    [[TMP15:%.*]] = and i8 [[TMP14]], -64
; SSE-NEXT:    [[ARRAYIDX3_7:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 7
; SSE-NEXT:    store i8 [[TMP15]], ptr [[ARRAYIDX3_7]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @and8(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load i8, ptr [[SRC:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], -64
; AVX-NEXT:    store i8 [[TMP1]], ptr [[DST:%.*]], align 1
; AVX-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 1
; AVX-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = and i8 [[TMP2]], -64
; AVX-NEXT:    [[ARRAYIDX3_1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 1
; AVX-NEXT:    store i8 [[TMP3]], ptr [[ARRAYIDX3_1]], align 1
; AVX-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 2
; AVX-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; AVX-NEXT:    [[TMP5:%.*]] = and i8 [[TMP4]], -64
; AVX-NEXT:    [[ARRAYIDX3_2:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 2
; AVX-NEXT:    store i8 [[TMP5]], ptr [[ARRAYIDX3_2]], align 1
; AVX-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 3
; AVX-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; AVX-NEXT:    [[TMP7:%.*]] = and i8 [[TMP6]], -64
; AVX-NEXT:    [[ARRAYIDX3_3:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 3
; AVX-NEXT:    store i8 [[TMP7]], ptr [[ARRAYIDX3_3]], align 1
; AVX-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 4
; AVX-NEXT:    [[TMP8:%.*]] = load i8, ptr [[ARRAYIDX_4]], align 1
; AVX-NEXT:    [[TMP9:%.*]] = and i8 [[TMP8]], -64
; AVX-NEXT:    [[ARRAYIDX3_4:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 4
; AVX-NEXT:    store i8 [[TMP9]], ptr [[ARRAYIDX3_4]], align 1
; AVX-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 5
; AVX-NEXT:    [[TMP10:%.*]] = load i8, ptr [[ARRAYIDX_5]], align 1
; AVX-NEXT:    [[TMP11:%.*]] = and i8 [[TMP10]], -64
; AVX-NEXT:    [[ARRAYIDX3_5:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 5
; AVX-NEXT:    store i8 [[TMP11]], ptr [[ARRAYIDX3_5]], align 1
; AVX-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 6
; AVX-NEXT:    [[TMP12:%.*]] = load i8, ptr [[ARRAYIDX_6]], align 1
; AVX-NEXT:    [[TMP13:%.*]] = and i8 [[TMP12]], -64
; AVX-NEXT:    [[ARRAYIDX3_6:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 6
; AVX-NEXT:    store i8 [[TMP13]], ptr [[ARRAYIDX3_6]], align 1
; AVX-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 7
; AVX-NEXT:    [[TMP14:%.*]] = load i8, ptr [[ARRAYIDX_7]], align 1
; AVX-NEXT:    [[TMP15:%.*]] = and i8 [[TMP14]], -64
; AVX-NEXT:    [[ARRAYIDX3_7:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 7
; AVX-NEXT:    store i8 [[TMP15]], ptr [[ARRAYIDX3_7]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %src, align 1
  %1 = and i8 %0, -64
  store i8 %1, ptr %dst, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %src, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %3 = and i8 %2, -64
  %arrayidx3.1 = getelementptr inbounds i8, ptr %dst, i64 1
  store i8 %3, ptr %arrayidx3.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %src, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %5 = and i8 %4, -64
  %arrayidx3.2 = getelementptr inbounds i8, ptr %dst, i64 2
  store i8 %5, ptr %arrayidx3.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %src, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %7 = and i8 %6, -64
  %arrayidx3.3 = getelementptr inbounds i8, ptr %dst, i64 3
  store i8 %7, ptr %arrayidx3.3, align 1
  %arrayidx.4 = getelementptr inbounds i8, ptr %src, i64 4
  %8 = load i8, ptr %arrayidx.4, align 1
  %9 = and i8 %8, -64
  %arrayidx3.4 = getelementptr inbounds i8, ptr %dst, i64 4
  store i8 %9, ptr %arrayidx3.4, align 1
  %arrayidx.5 = getelementptr inbounds i8, ptr %src, i64 5
  %10 = load i8, ptr %arrayidx.5, align 1
  %11 = and i8 %10, -64
  %arrayidx3.5 = getelementptr inbounds i8, ptr %dst, i64 5
  store i8 %11, ptr %arrayidx3.5, align 1
  %arrayidx.6 = getelementptr inbounds i8, ptr %src, i64 6
  %12 = load i8, ptr %arrayidx.6, align 1
  %13 = and i8 %12, -64
  %arrayidx3.6 = getelementptr inbounds i8, ptr %dst, i64 6
  store i8 %13, ptr %arrayidx3.6, align 1
  %arrayidx.7 = getelementptr inbounds i8, ptr %src, i64 7
  %14 = load i8, ptr %arrayidx.7, align 1
  %15 = and i8 %14, -64
  %arrayidx3.7 = getelementptr inbounds i8, ptr %dst, i64 7
  store i8 %15, ptr %arrayidx3.7, align 1
  ret void
}

define void @and16(ptr noalias nocapture noundef writeonly %dst, ptr noalias nocapture noundef readonly %src) {
; SSE-LABEL: @and16(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load <16 x i8>, ptr [[SRC:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = and <16 x i8> [[TMP0]], <i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64>
; SSE-NEXT:    store <16 x i8> [[TMP1]], ptr [[DST:%.*]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @and16(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load <16 x i8>, ptr [[SRC:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = and <16 x i8> [[TMP0]], <i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64>
; AVX-NEXT:    store <16 x i8> [[TMP1]], ptr [[DST:%.*]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %src, align 1
  %1 = and i8 %0, -64
  store i8 %1, ptr %dst, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %src, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %3 = and i8 %2, -64
  %arrayidx3.1 = getelementptr inbounds i8, ptr %dst, i64 1
  store i8 %3, ptr %arrayidx3.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %src, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %5 = and i8 %4, -64
  %arrayidx3.2 = getelementptr inbounds i8, ptr %dst, i64 2
  store i8 %5, ptr %arrayidx3.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %src, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %7 = and i8 %6, -64
  %arrayidx3.3 = getelementptr inbounds i8, ptr %dst, i64 3
  store i8 %7, ptr %arrayidx3.3, align 1
  %arrayidx.4 = getelementptr inbounds i8, ptr %src, i64 4
  %8 = load i8, ptr %arrayidx.4, align 1
  %9 = and i8 %8, -64
  %arrayidx3.4 = getelementptr inbounds i8, ptr %dst, i64 4
  store i8 %9, ptr %arrayidx3.4, align 1
  %arrayidx.5 = getelementptr inbounds i8, ptr %src, i64 5
  %10 = load i8, ptr %arrayidx.5, align 1
  %11 = and i8 %10, -64
  %arrayidx3.5 = getelementptr inbounds i8, ptr %dst, i64 5
  store i8 %11, ptr %arrayidx3.5, align 1
  %arrayidx.6 = getelementptr inbounds i8, ptr %src, i64 6
  %12 = load i8, ptr %arrayidx.6, align 1
  %13 = and i8 %12, -64
  %arrayidx3.6 = getelementptr inbounds i8, ptr %dst, i64 6
  store i8 %13, ptr %arrayidx3.6, align 1
  %arrayidx.7 = getelementptr inbounds i8, ptr %src, i64 7
  %14 = load i8, ptr %arrayidx.7, align 1
  %15 = and i8 %14, -64
  %arrayidx3.7 = getelementptr inbounds i8, ptr %dst, i64 7
  store i8 %15, ptr %arrayidx3.7, align 1
  %arrayidx.8 = getelementptr inbounds i8, ptr %src, i64 8
  %16 = load i8, ptr %arrayidx.8, align 1
  %17 = and i8 %16, -64
  %arrayidx3.8 = getelementptr inbounds i8, ptr %dst, i64 8
  store i8 %17, ptr %arrayidx3.8, align 1
  %arrayidx.9 = getelementptr inbounds i8, ptr %src, i64 9
  %18 = load i8, ptr %arrayidx.9, align 1
  %19 = and i8 %18, -64
  %arrayidx3.9 = getelementptr inbounds i8, ptr %dst, i64 9
  store i8 %19, ptr %arrayidx3.9, align 1
  %arrayidx.10 = getelementptr inbounds i8, ptr %src, i64 10
  %20 = load i8, ptr %arrayidx.10, align 1
  %21 = and i8 %20, -64
  %arrayidx3.10 = getelementptr inbounds i8, ptr %dst, i64 10
  store i8 %21, ptr %arrayidx3.10, align 1
  %arrayidx.11 = getelementptr inbounds i8, ptr %src, i64 11
  %22 = load i8, ptr %arrayidx.11, align 1
  %23 = and i8 %22, -64
  %arrayidx3.11 = getelementptr inbounds i8, ptr %dst, i64 11
  store i8 %23, ptr %arrayidx3.11, align 1
  %arrayidx.12 = getelementptr inbounds i8, ptr %src, i64 12
  %24 = load i8, ptr %arrayidx.12, align 1
  %25 = and i8 %24, -64
  %arrayidx3.12 = getelementptr inbounds i8, ptr %dst, i64 12
  store i8 %25, ptr %arrayidx3.12, align 1
  %arrayidx.13 = getelementptr inbounds i8, ptr %src, i64 13
  %26 = load i8, ptr %arrayidx.13, align 1
  %27 = and i8 %26, -64
  %arrayidx3.13 = getelementptr inbounds i8, ptr %dst, i64 13
  store i8 %27, ptr %arrayidx3.13, align 1
  %arrayidx.14 = getelementptr inbounds i8, ptr %src, i64 14
  %28 = load i8, ptr %arrayidx.14, align 1
  %29 = and i8 %28, -64
  %arrayidx3.14 = getelementptr inbounds i8, ptr %dst, i64 14
  store i8 %29, ptr %arrayidx3.14, align 1
  %arrayidx.15 = getelementptr inbounds i8, ptr %src, i64 15
  %30 = load i8, ptr %arrayidx.15, align 1
  %31 = and i8 %30, -64
  %arrayidx3.15 = getelementptr inbounds i8, ptr %dst, i64 15
  store i8 %31, ptr %arrayidx3.15, align 1
  ret void
}

define void @and32(ptr noalias nocapture noundef writeonly %dst, ptr noalias nocapture noundef readonly %src) {
; SSE-LABEL: @and32(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load <16 x i8>, ptr [[SRC:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = and <16 x i8> [[TMP0]], <i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64>
; SSE-NEXT:    store <16 x i8> [[TMP1]], ptr [[DST:%.*]], align 1
; SSE-NEXT:    [[ARRAYIDX_16:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 16
; SSE-NEXT:    [[ARRAYIDX3_16:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 16
; SSE-NEXT:    [[TMP2:%.*]] = load <16 x i8>, ptr [[ARRAYIDX_16]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = and <16 x i8> [[TMP2]], <i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64>
; SSE-NEXT:    store <16 x i8> [[TMP3]], ptr [[ARRAYIDX3_16]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @and32(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load <32 x i8>, ptr [[SRC:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = and <32 x i8> [[TMP0]], <i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64, i8 -64>
; AVX-NEXT:    store <32 x i8> [[TMP1]], ptr [[DST:%.*]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %src, align 1
  %1 = and i8 %0, -64
  store i8 %1, ptr %dst, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %src, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %3 = and i8 %2, -64
  %arrayidx3.1 = getelementptr inbounds i8, ptr %dst, i64 1
  store i8 %3, ptr %arrayidx3.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %src, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %5 = and i8 %4, -64
  %arrayidx3.2 = getelementptr inbounds i8, ptr %dst, i64 2
  store i8 %5, ptr %arrayidx3.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %src, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %7 = and i8 %6, -64
  %arrayidx3.3 = getelementptr inbounds i8, ptr %dst, i64 3
  store i8 %7, ptr %arrayidx3.3, align 1
  %arrayidx.4 = getelementptr inbounds i8, ptr %src, i64 4
  %8 = load i8, ptr %arrayidx.4, align 1
  %9 = and i8 %8, -64
  %arrayidx3.4 = getelementptr inbounds i8, ptr %dst, i64 4
  store i8 %9, ptr %arrayidx3.4, align 1
  %arrayidx.5 = getelementptr inbounds i8, ptr %src, i64 5
  %10 = load i8, ptr %arrayidx.5, align 1
  %11 = and i8 %10, -64
  %arrayidx3.5 = getelementptr inbounds i8, ptr %dst, i64 5
  store i8 %11, ptr %arrayidx3.5, align 1
  %arrayidx.6 = getelementptr inbounds i8, ptr %src, i64 6
  %12 = load i8, ptr %arrayidx.6, align 1
  %13 = and i8 %12, -64
  %arrayidx3.6 = getelementptr inbounds i8, ptr %dst, i64 6
  store i8 %13, ptr %arrayidx3.6, align 1
  %arrayidx.7 = getelementptr inbounds i8, ptr %src, i64 7
  %14 = load i8, ptr %arrayidx.7, align 1
  %15 = and i8 %14, -64
  %arrayidx3.7 = getelementptr inbounds i8, ptr %dst, i64 7
  store i8 %15, ptr %arrayidx3.7, align 1
  %arrayidx.8 = getelementptr inbounds i8, ptr %src, i64 8
  %16 = load i8, ptr %arrayidx.8, align 1
  %17 = and i8 %16, -64
  %arrayidx3.8 = getelementptr inbounds i8, ptr %dst, i64 8
  store i8 %17, ptr %arrayidx3.8, align 1
  %arrayidx.9 = getelementptr inbounds i8, ptr %src, i64 9
  %18 = load i8, ptr %arrayidx.9, align 1
  %19 = and i8 %18, -64
  %arrayidx3.9 = getelementptr inbounds i8, ptr %dst, i64 9
  store i8 %19, ptr %arrayidx3.9, align 1
  %arrayidx.10 = getelementptr inbounds i8, ptr %src, i64 10
  %20 = load i8, ptr %arrayidx.10, align 1
  %21 = and i8 %20, -64
  %arrayidx3.10 = getelementptr inbounds i8, ptr %dst, i64 10
  store i8 %21, ptr %arrayidx3.10, align 1
  %arrayidx.11 = getelementptr inbounds i8, ptr %src, i64 11
  %22 = load i8, ptr %arrayidx.11, align 1
  %23 = and i8 %22, -64
  %arrayidx3.11 = getelementptr inbounds i8, ptr %dst, i64 11
  store i8 %23, ptr %arrayidx3.11, align 1
  %arrayidx.12 = getelementptr inbounds i8, ptr %src, i64 12
  %24 = load i8, ptr %arrayidx.12, align 1
  %25 = and i8 %24, -64
  %arrayidx3.12 = getelementptr inbounds i8, ptr %dst, i64 12
  store i8 %25, ptr %arrayidx3.12, align 1
  %arrayidx.13 = getelementptr inbounds i8, ptr %src, i64 13
  %26 = load i8, ptr %arrayidx.13, align 1
  %27 = and i8 %26, -64
  %arrayidx3.13 = getelementptr inbounds i8, ptr %dst, i64 13
  store i8 %27, ptr %arrayidx3.13, align 1
  %arrayidx.14 = getelementptr inbounds i8, ptr %src, i64 14
  %28 = load i8, ptr %arrayidx.14, align 1
  %29 = and i8 %28, -64
  %arrayidx3.14 = getelementptr inbounds i8, ptr %dst, i64 14
  store i8 %29, ptr %arrayidx3.14, align 1
  %arrayidx.15 = getelementptr inbounds i8, ptr %src, i64 15
  %30 = load i8, ptr %arrayidx.15, align 1
  %31 = and i8 %30, -64
  %arrayidx3.15 = getelementptr inbounds i8, ptr %dst, i64 15
  store i8 %31, ptr %arrayidx3.15, align 1
  %arrayidx.16 = getelementptr inbounds i8, ptr %src, i64 16
  %32 = load i8, ptr %arrayidx.16, align 1
  %33 = and i8 %32, -64
  %arrayidx3.16 = getelementptr inbounds i8, ptr %dst, i64 16
  store i8 %33, ptr %arrayidx3.16, align 1
  %arrayidx.17 = getelementptr inbounds i8, ptr %src, i64 17
  %34 = load i8, ptr %arrayidx.17, align 1
  %35 = and i8 %34, -64
  %arrayidx3.17 = getelementptr inbounds i8, ptr %dst, i64 17
  store i8 %35, ptr %arrayidx3.17, align 1
  %arrayidx.18 = getelementptr inbounds i8, ptr %src, i64 18
  %36 = load i8, ptr %arrayidx.18, align 1
  %37 = and i8 %36, -64
  %arrayidx3.18 = getelementptr inbounds i8, ptr %dst, i64 18
  store i8 %37, ptr %arrayidx3.18, align 1
  %arrayidx.19 = getelementptr inbounds i8, ptr %src, i64 19
  %38 = load i8, ptr %arrayidx.19, align 1
  %39 = and i8 %38, -64
  %arrayidx3.19 = getelementptr inbounds i8, ptr %dst, i64 19
  store i8 %39, ptr %arrayidx3.19, align 1
  %arrayidx.20 = getelementptr inbounds i8, ptr %src, i64 20
  %40 = load i8, ptr %arrayidx.20, align 1
  %41 = and i8 %40, -64
  %arrayidx3.20 = getelementptr inbounds i8, ptr %dst, i64 20
  store i8 %41, ptr %arrayidx3.20, align 1
  %arrayidx.21 = getelementptr inbounds i8, ptr %src, i64 21
  %42 = load i8, ptr %arrayidx.21, align 1
  %43 = and i8 %42, -64
  %arrayidx3.21 = getelementptr inbounds i8, ptr %dst, i64 21
  store i8 %43, ptr %arrayidx3.21, align 1
  %arrayidx.22 = getelementptr inbounds i8, ptr %src, i64 22
  %44 = load i8, ptr %arrayidx.22, align 1
  %45 = and i8 %44, -64
  %arrayidx3.22 = getelementptr inbounds i8, ptr %dst, i64 22
  store i8 %45, ptr %arrayidx3.22, align 1
  %arrayidx.23 = getelementptr inbounds i8, ptr %src, i64 23
  %46 = load i8, ptr %arrayidx.23, align 1
  %47 = and i8 %46, -64
  %arrayidx3.23 = getelementptr inbounds i8, ptr %dst, i64 23
  store i8 %47, ptr %arrayidx3.23, align 1
  %arrayidx.24 = getelementptr inbounds i8, ptr %src, i64 24
  %48 = load i8, ptr %arrayidx.24, align 1
  %49 = and i8 %48, -64
  %arrayidx3.24 = getelementptr inbounds i8, ptr %dst, i64 24
  store i8 %49, ptr %arrayidx3.24, align 1
  %arrayidx.25 = getelementptr inbounds i8, ptr %src, i64 25
  %50 = load i8, ptr %arrayidx.25, align 1
  %51 = and i8 %50, -64
  %arrayidx3.25 = getelementptr inbounds i8, ptr %dst, i64 25
  store i8 %51, ptr %arrayidx3.25, align 1
  %arrayidx.26 = getelementptr inbounds i8, ptr %src, i64 26
  %52 = load i8, ptr %arrayidx.26, align 1
  %53 = and i8 %52, -64
  %arrayidx3.26 = getelementptr inbounds i8, ptr %dst, i64 26
  store i8 %53, ptr %arrayidx3.26, align 1
  %arrayidx.27 = getelementptr inbounds i8, ptr %src, i64 27
  %54 = load i8, ptr %arrayidx.27, align 1
  %55 = and i8 %54, -64
  %arrayidx3.27 = getelementptr inbounds i8, ptr %dst, i64 27
  store i8 %55, ptr %arrayidx3.27, align 1
  %arrayidx.28 = getelementptr inbounds i8, ptr %src, i64 28
  %56 = load i8, ptr %arrayidx.28, align 1
  %57 = and i8 %56, -64
  %arrayidx3.28 = getelementptr inbounds i8, ptr %dst, i64 28
  store i8 %57, ptr %arrayidx3.28, align 1
  %arrayidx.29 = getelementptr inbounds i8, ptr %src, i64 29
  %58 = load i8, ptr %arrayidx.29, align 1
  %59 = and i8 %58, -64
  %arrayidx3.29 = getelementptr inbounds i8, ptr %dst, i64 29
  store i8 %59, ptr %arrayidx3.29, align 1
  %arrayidx.30 = getelementptr inbounds i8, ptr %src, i64 30
  %60 = load i8, ptr %arrayidx.30, align 1
  %61 = and i8 %60, -64
  %arrayidx3.30 = getelementptr inbounds i8, ptr %dst, i64 30
  store i8 %61, ptr %arrayidx3.30, align 1
  %arrayidx.31 = getelementptr inbounds i8, ptr %src, i64 31
  %62 = load i8, ptr %arrayidx.31, align 1
  %63 = and i8 %62, -64
  %arrayidx3.31 = getelementptr inbounds i8, ptr %dst, i64 31
  store i8 %63, ptr %arrayidx3.31, align 1
  ret void
}
