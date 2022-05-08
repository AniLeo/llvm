; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64    -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=SSE
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64-v2 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=SSE
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64-v3 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=AVX
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown -mcpu=x86-64-v4 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefix=AVX

; // PR47491
; void pr(char* r, char* a){
;   for (int i = 0; i < 8; i++){
;       r[i] += a[i];
;   }
; }

define void @add4(ptr noalias nocapture noundef %r, ptr noalias nocapture noundef readonly %a) {
; SSE-LABEL: @add4(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load i8, ptr [[A:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = load i8, ptr [[R:%.*]], align 1
; SSE-NEXT:    [[ADD:%.*]] = add i8 [[TMP1]], [[TMP0]]
; SSE-NEXT:    store i8 [[ADD]], ptr [[R]], align 1
; SSE-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 1
; SSE-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; SSE-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 1
; SSE-NEXT:    [[TMP3:%.*]] = load i8, ptr [[ARRAYIDX2_1]], align 1
; SSE-NEXT:    [[ADD_1:%.*]] = add i8 [[TMP3]], [[TMP2]]
; SSE-NEXT:    store i8 [[ADD_1]], ptr [[ARRAYIDX2_1]], align 1
; SSE-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 2
; SSE-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; SSE-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 2
; SSE-NEXT:    [[TMP5:%.*]] = load i8, ptr [[ARRAYIDX2_2]], align 1
; SSE-NEXT:    [[ADD_2:%.*]] = add i8 [[TMP5]], [[TMP4]]
; SSE-NEXT:    store i8 [[ADD_2]], ptr [[ARRAYIDX2_2]], align 1
; SSE-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 3
; SSE-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; SSE-NEXT:    [[ARRAYIDX2_3:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 3
; SSE-NEXT:    [[TMP7:%.*]] = load i8, ptr [[ARRAYIDX2_3]], align 1
; SSE-NEXT:    [[ADD_3:%.*]] = add i8 [[TMP7]], [[TMP6]]
; SSE-NEXT:    store i8 [[ADD_3]], ptr [[ARRAYIDX2_3]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @add4(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load i8, ptr [[A:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = load i8, ptr [[R:%.*]], align 1
; AVX-NEXT:    [[ADD:%.*]] = add i8 [[TMP1]], [[TMP0]]
; AVX-NEXT:    store i8 [[ADD]], ptr [[R]], align 1
; AVX-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 1
; AVX-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; AVX-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 1
; AVX-NEXT:    [[TMP3:%.*]] = load i8, ptr [[ARRAYIDX2_1]], align 1
; AVX-NEXT:    [[ADD_1:%.*]] = add i8 [[TMP3]], [[TMP2]]
; AVX-NEXT:    store i8 [[ADD_1]], ptr [[ARRAYIDX2_1]], align 1
; AVX-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 2
; AVX-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; AVX-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 2
; AVX-NEXT:    [[TMP5:%.*]] = load i8, ptr [[ARRAYIDX2_2]], align 1
; AVX-NEXT:    [[ADD_2:%.*]] = add i8 [[TMP5]], [[TMP4]]
; AVX-NEXT:    store i8 [[ADD_2]], ptr [[ARRAYIDX2_2]], align 1
; AVX-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 3
; AVX-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; AVX-NEXT:    [[ARRAYIDX2_3:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 3
; AVX-NEXT:    [[TMP7:%.*]] = load i8, ptr [[ARRAYIDX2_3]], align 1
; AVX-NEXT:    [[ADD_3:%.*]] = add i8 [[TMP7]], [[TMP6]]
; AVX-NEXT:    store i8 [[ADD_3]], ptr [[ARRAYIDX2_3]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %a, align 1
  %1 = load i8, ptr %r, align 1
  %add = add i8 %1, %0
  store i8 %add, ptr %r, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %a, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %arrayidx2.1 = getelementptr inbounds i8, ptr %r, i64 1
  %3 = load i8, ptr %arrayidx2.1, align 1
  %add.1 = add i8 %3, %2
  store i8 %add.1, ptr %arrayidx2.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %a, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %arrayidx2.2 = getelementptr inbounds i8, ptr %r, i64 2
  %5 = load i8, ptr %arrayidx2.2, align 1
  %add.2 = add i8 %5, %4
  store i8 %add.2, ptr %arrayidx2.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %a, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %arrayidx2.3 = getelementptr inbounds i8, ptr %r, i64 3
  %7 = load i8, ptr %arrayidx2.3, align 1
  %add.3 = add i8 %7, %6
  store i8 %add.3, ptr %arrayidx2.3, align 1
  ret void
}

define void @add8(ptr noalias nocapture noundef %r, ptr noalias nocapture noundef readonly %a) {
; SSE-LABEL: @add8(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load i8, ptr [[A:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = load i8, ptr [[R:%.*]], align 1
; SSE-NEXT:    [[ADD:%.*]] = add i8 [[TMP1]], [[TMP0]]
; SSE-NEXT:    store i8 [[ADD]], ptr [[R]], align 1
; SSE-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 1
; SSE-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; SSE-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 1
; SSE-NEXT:    [[TMP3:%.*]] = load i8, ptr [[ARRAYIDX2_1]], align 1
; SSE-NEXT:    [[ADD_1:%.*]] = add i8 [[TMP3]], [[TMP2]]
; SSE-NEXT:    store i8 [[ADD_1]], ptr [[ARRAYIDX2_1]], align 1
; SSE-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 2
; SSE-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; SSE-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 2
; SSE-NEXT:    [[TMP5:%.*]] = load i8, ptr [[ARRAYIDX2_2]], align 1
; SSE-NEXT:    [[ADD_2:%.*]] = add i8 [[TMP5]], [[TMP4]]
; SSE-NEXT:    store i8 [[ADD_2]], ptr [[ARRAYIDX2_2]], align 1
; SSE-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 3
; SSE-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; SSE-NEXT:    [[ARRAYIDX2_3:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 3
; SSE-NEXT:    [[TMP7:%.*]] = load i8, ptr [[ARRAYIDX2_3]], align 1
; SSE-NEXT:    [[ADD_3:%.*]] = add i8 [[TMP7]], [[TMP6]]
; SSE-NEXT:    store i8 [[ADD_3]], ptr [[ARRAYIDX2_3]], align 1
; SSE-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 4
; SSE-NEXT:    [[TMP8:%.*]] = load i8, ptr [[ARRAYIDX_4]], align 1
; SSE-NEXT:    [[ARRAYIDX2_4:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 4
; SSE-NEXT:    [[TMP9:%.*]] = load i8, ptr [[ARRAYIDX2_4]], align 1
; SSE-NEXT:    [[ADD_4:%.*]] = add i8 [[TMP9]], [[TMP8]]
; SSE-NEXT:    store i8 [[ADD_4]], ptr [[ARRAYIDX2_4]], align 1
; SSE-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 5
; SSE-NEXT:    [[TMP10:%.*]] = load i8, ptr [[ARRAYIDX_5]], align 1
; SSE-NEXT:    [[ARRAYIDX2_5:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 5
; SSE-NEXT:    [[TMP11:%.*]] = load i8, ptr [[ARRAYIDX2_5]], align 1
; SSE-NEXT:    [[ADD_5:%.*]] = add i8 [[TMP11]], [[TMP10]]
; SSE-NEXT:    store i8 [[ADD_5]], ptr [[ARRAYIDX2_5]], align 1
; SSE-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 6
; SSE-NEXT:    [[TMP12:%.*]] = load i8, ptr [[ARRAYIDX_6]], align 1
; SSE-NEXT:    [[ARRAYIDX2_6:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 6
; SSE-NEXT:    [[TMP13:%.*]] = load i8, ptr [[ARRAYIDX2_6]], align 1
; SSE-NEXT:    [[ADD_6:%.*]] = add i8 [[TMP13]], [[TMP12]]
; SSE-NEXT:    store i8 [[ADD_6]], ptr [[ARRAYIDX2_6]], align 1
; SSE-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 7
; SSE-NEXT:    [[TMP14:%.*]] = load i8, ptr [[ARRAYIDX_7]], align 1
; SSE-NEXT:    [[ARRAYIDX2_7:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 7
; SSE-NEXT:    [[TMP15:%.*]] = load i8, ptr [[ARRAYIDX2_7]], align 1
; SSE-NEXT:    [[ADD_7:%.*]] = add i8 [[TMP15]], [[TMP14]]
; SSE-NEXT:    store i8 [[ADD_7]], ptr [[ARRAYIDX2_7]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @add8(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load i8, ptr [[A:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = load i8, ptr [[R:%.*]], align 1
; AVX-NEXT:    [[ADD:%.*]] = add i8 [[TMP1]], [[TMP0]]
; AVX-NEXT:    store i8 [[ADD]], ptr [[R]], align 1
; AVX-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 1
; AVX-NEXT:    [[TMP2:%.*]] = load i8, ptr [[ARRAYIDX_1]], align 1
; AVX-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 1
; AVX-NEXT:    [[TMP3:%.*]] = load i8, ptr [[ARRAYIDX2_1]], align 1
; AVX-NEXT:    [[ADD_1:%.*]] = add i8 [[TMP3]], [[TMP2]]
; AVX-NEXT:    store i8 [[ADD_1]], ptr [[ARRAYIDX2_1]], align 1
; AVX-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 2
; AVX-NEXT:    [[TMP4:%.*]] = load i8, ptr [[ARRAYIDX_2]], align 1
; AVX-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 2
; AVX-NEXT:    [[TMP5:%.*]] = load i8, ptr [[ARRAYIDX2_2]], align 1
; AVX-NEXT:    [[ADD_2:%.*]] = add i8 [[TMP5]], [[TMP4]]
; AVX-NEXT:    store i8 [[ADD_2]], ptr [[ARRAYIDX2_2]], align 1
; AVX-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 3
; AVX-NEXT:    [[TMP6:%.*]] = load i8, ptr [[ARRAYIDX_3]], align 1
; AVX-NEXT:    [[ARRAYIDX2_3:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 3
; AVX-NEXT:    [[TMP7:%.*]] = load i8, ptr [[ARRAYIDX2_3]], align 1
; AVX-NEXT:    [[ADD_3:%.*]] = add i8 [[TMP7]], [[TMP6]]
; AVX-NEXT:    store i8 [[ADD_3]], ptr [[ARRAYIDX2_3]], align 1
; AVX-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 4
; AVX-NEXT:    [[TMP8:%.*]] = load i8, ptr [[ARRAYIDX_4]], align 1
; AVX-NEXT:    [[ARRAYIDX2_4:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 4
; AVX-NEXT:    [[TMP9:%.*]] = load i8, ptr [[ARRAYIDX2_4]], align 1
; AVX-NEXT:    [[ADD_4:%.*]] = add i8 [[TMP9]], [[TMP8]]
; AVX-NEXT:    store i8 [[ADD_4]], ptr [[ARRAYIDX2_4]], align 1
; AVX-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 5
; AVX-NEXT:    [[TMP10:%.*]] = load i8, ptr [[ARRAYIDX_5]], align 1
; AVX-NEXT:    [[ARRAYIDX2_5:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 5
; AVX-NEXT:    [[TMP11:%.*]] = load i8, ptr [[ARRAYIDX2_5]], align 1
; AVX-NEXT:    [[ADD_5:%.*]] = add i8 [[TMP11]], [[TMP10]]
; AVX-NEXT:    store i8 [[ADD_5]], ptr [[ARRAYIDX2_5]], align 1
; AVX-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 6
; AVX-NEXT:    [[TMP12:%.*]] = load i8, ptr [[ARRAYIDX_6]], align 1
; AVX-NEXT:    [[ARRAYIDX2_6:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 6
; AVX-NEXT:    [[TMP13:%.*]] = load i8, ptr [[ARRAYIDX2_6]], align 1
; AVX-NEXT:    [[ADD_6:%.*]] = add i8 [[TMP13]], [[TMP12]]
; AVX-NEXT:    store i8 [[ADD_6]], ptr [[ARRAYIDX2_6]], align 1
; AVX-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 7
; AVX-NEXT:    [[TMP14:%.*]] = load i8, ptr [[ARRAYIDX_7]], align 1
; AVX-NEXT:    [[ARRAYIDX2_7:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 7
; AVX-NEXT:    [[TMP15:%.*]] = load i8, ptr [[ARRAYIDX2_7]], align 1
; AVX-NEXT:    [[ADD_7:%.*]] = add i8 [[TMP15]], [[TMP14]]
; AVX-NEXT:    store i8 [[ADD_7]], ptr [[ARRAYIDX2_7]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %a, align 1
  %1 = load i8, ptr %r, align 1
  %add = add i8 %1, %0
  store i8 %add, ptr %r, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %a, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %arrayidx2.1 = getelementptr inbounds i8, ptr %r, i64 1
  %3 = load i8, ptr %arrayidx2.1, align 1
  %add.1 = add i8 %3, %2
  store i8 %add.1, ptr %arrayidx2.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %a, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %arrayidx2.2 = getelementptr inbounds i8, ptr %r, i64 2
  %5 = load i8, ptr %arrayidx2.2, align 1
  %add.2 = add i8 %5, %4
  store i8 %add.2, ptr %arrayidx2.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %a, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %arrayidx2.3 = getelementptr inbounds i8, ptr %r, i64 3
  %7 = load i8, ptr %arrayidx2.3, align 1
  %add.3 = add i8 %7, %6
  store i8 %add.3, ptr %arrayidx2.3, align 1
  %arrayidx.4 = getelementptr inbounds i8, ptr %a, i64 4
  %8 = load i8, ptr %arrayidx.4, align 1
  %arrayidx2.4 = getelementptr inbounds i8, ptr %r, i64 4
  %9 = load i8, ptr %arrayidx2.4, align 1
  %add.4 = add i8 %9, %8
  store i8 %add.4, ptr %arrayidx2.4, align 1
  %arrayidx.5 = getelementptr inbounds i8, ptr %a, i64 5
  %10 = load i8, ptr %arrayidx.5, align 1
  %arrayidx2.5 = getelementptr inbounds i8, ptr %r, i64 5
  %11 = load i8, ptr %arrayidx2.5, align 1
  %add.5 = add i8 %11, %10
  store i8 %add.5, ptr %arrayidx2.5, align 1
  %arrayidx.6 = getelementptr inbounds i8, ptr %a, i64 6
  %12 = load i8, ptr %arrayidx.6, align 1
  %arrayidx2.6 = getelementptr inbounds i8, ptr %r, i64 6
  %13 = load i8, ptr %arrayidx2.6, align 1
  %add.6 = add i8 %13, %12
  store i8 %add.6, ptr %arrayidx2.6, align 1
  %arrayidx.7 = getelementptr inbounds i8, ptr %a, i64 7
  %14 = load i8, ptr %arrayidx.7, align 1
  %arrayidx2.7 = getelementptr inbounds i8, ptr %r, i64 7
  %15 = load i8, ptr %arrayidx2.7, align 1
  %add.7 = add i8 %15, %14
  store i8 %add.7, ptr %arrayidx2.7, align 1
  ret void
}

define void @add16(ptr noalias nocapture noundef %r, ptr noalias nocapture noundef readonly %a) {
; SSE-LABEL: @add16(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load <16 x i8>, ptr [[A:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = load <16 x i8>, ptr [[R:%.*]], align 1
; SSE-NEXT:    [[TMP2:%.*]] = add <16 x i8> [[TMP1]], [[TMP0]]
; SSE-NEXT:    store <16 x i8> [[TMP2]], ptr [[R]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @add16(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load <16 x i8>, ptr [[A:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = load <16 x i8>, ptr [[R:%.*]], align 1
; AVX-NEXT:    [[TMP2:%.*]] = add <16 x i8> [[TMP1]], [[TMP0]]
; AVX-NEXT:    store <16 x i8> [[TMP2]], ptr [[R]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %a, align 1
  %1 = load i8, ptr %r, align 1
  %add = add i8 %1, %0
  store i8 %add, ptr %r, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %a, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %arrayidx2.1 = getelementptr inbounds i8, ptr %r, i64 1
  %3 = load i8, ptr %arrayidx2.1, align 1
  %add.1 = add i8 %3, %2
  store i8 %add.1, ptr %arrayidx2.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %a, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %arrayidx2.2 = getelementptr inbounds i8, ptr %r, i64 2
  %5 = load i8, ptr %arrayidx2.2, align 1
  %add.2 = add i8 %5, %4
  store i8 %add.2, ptr %arrayidx2.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %a, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %arrayidx2.3 = getelementptr inbounds i8, ptr %r, i64 3
  %7 = load i8, ptr %arrayidx2.3, align 1
  %add.3 = add i8 %7, %6
  store i8 %add.3, ptr %arrayidx2.3, align 1
  %arrayidx.4 = getelementptr inbounds i8, ptr %a, i64 4
  %8 = load i8, ptr %arrayidx.4, align 1
  %arrayidx2.4 = getelementptr inbounds i8, ptr %r, i64 4
  %9 = load i8, ptr %arrayidx2.4, align 1
  %add.4 = add i8 %9, %8
  store i8 %add.4, ptr %arrayidx2.4, align 1
  %arrayidx.5 = getelementptr inbounds i8, ptr %a, i64 5
  %10 = load i8, ptr %arrayidx.5, align 1
  %arrayidx2.5 = getelementptr inbounds i8, ptr %r, i64 5
  %11 = load i8, ptr %arrayidx2.5, align 1
  %add.5 = add i8 %11, %10
  store i8 %add.5, ptr %arrayidx2.5, align 1
  %arrayidx.6 = getelementptr inbounds i8, ptr %a, i64 6
  %12 = load i8, ptr %arrayidx.6, align 1
  %arrayidx2.6 = getelementptr inbounds i8, ptr %r, i64 6
  %13 = load i8, ptr %arrayidx2.6, align 1
  %add.6 = add i8 %13, %12
  store i8 %add.6, ptr %arrayidx2.6, align 1
  %arrayidx.7 = getelementptr inbounds i8, ptr %a, i64 7
  %14 = load i8, ptr %arrayidx.7, align 1
  %arrayidx2.7 = getelementptr inbounds i8, ptr %r, i64 7
  %15 = load i8, ptr %arrayidx2.7, align 1
  %add.7 = add i8 %15, %14
  store i8 %add.7, ptr %arrayidx2.7, align 1
  %arrayidx.8 = getelementptr inbounds i8, ptr %a, i64 8
  %16 = load i8, ptr %arrayidx.8, align 1
  %arrayidx2.8 = getelementptr inbounds i8, ptr %r, i64 8
  %17 = load i8, ptr %arrayidx2.8, align 1
  %add.8 = add i8 %17, %16
  store i8 %add.8, ptr %arrayidx2.8, align 1
  %arrayidx.9 = getelementptr inbounds i8, ptr %a, i64 9
  %18 = load i8, ptr %arrayidx.9, align 1
  %arrayidx2.9 = getelementptr inbounds i8, ptr %r, i64 9
  %19 = load i8, ptr %arrayidx2.9, align 1
  %add.9 = add i8 %19, %18
  store i8 %add.9, ptr %arrayidx2.9, align 1
  %arrayidx.10 = getelementptr inbounds i8, ptr %a, i64 10
  %20 = load i8, ptr %arrayidx.10, align 1
  %arrayidx2.10 = getelementptr inbounds i8, ptr %r, i64 10
  %21 = load i8, ptr %arrayidx2.10, align 1
  %add.10 = add i8 %21, %20
  store i8 %add.10, ptr %arrayidx2.10, align 1
  %arrayidx.11 = getelementptr inbounds i8, ptr %a, i64 11
  %22 = load i8, ptr %arrayidx.11, align 1
  %arrayidx2.11 = getelementptr inbounds i8, ptr %r, i64 11
  %23 = load i8, ptr %arrayidx2.11, align 1
  %add.11 = add i8 %23, %22
  store i8 %add.11, ptr %arrayidx2.11, align 1
  %arrayidx.12 = getelementptr inbounds i8, ptr %a, i64 12
  %24 = load i8, ptr %arrayidx.12, align 1
  %arrayidx2.12 = getelementptr inbounds i8, ptr %r, i64 12
  %25 = load i8, ptr %arrayidx2.12, align 1
  %add.12 = add i8 %25, %24
  store i8 %add.12, ptr %arrayidx2.12, align 1
  %arrayidx.13 = getelementptr inbounds i8, ptr %a, i64 13
  %26 = load i8, ptr %arrayidx.13, align 1
  %arrayidx2.13 = getelementptr inbounds i8, ptr %r, i64 13
  %27 = load i8, ptr %arrayidx2.13, align 1
  %add.13 = add i8 %27, %26
  store i8 %add.13, ptr %arrayidx2.13, align 1
  %arrayidx.14 = getelementptr inbounds i8, ptr %a, i64 14
  %28 = load i8, ptr %arrayidx.14, align 1
  %arrayidx2.14 = getelementptr inbounds i8, ptr %r, i64 14
  %29 = load i8, ptr %arrayidx2.14, align 1
  %add.14 = add i8 %29, %28
  store i8 %add.14, ptr %arrayidx2.14, align 1
  %arrayidx.15 = getelementptr inbounds i8, ptr %a, i64 15
  %30 = load i8, ptr %arrayidx.15, align 1
  %arrayidx2.15 = getelementptr inbounds i8, ptr %r, i64 15
  %31 = load i8, ptr %arrayidx2.15, align 1
  %add.15 = add i8 %31, %30
  store i8 %add.15, ptr %arrayidx2.15, align 1
  ret void
}

define void @add32(ptr noalias nocapture noundef %r, ptr noalias nocapture noundef readonly %a) {
; SSE-LABEL: @add32(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load <16 x i8>, ptr [[A:%.*]], align 1
; SSE-NEXT:    [[TMP1:%.*]] = load <16 x i8>, ptr [[R:%.*]], align 1
; SSE-NEXT:    [[TMP2:%.*]] = add <16 x i8> [[TMP1]], [[TMP0]]
; SSE-NEXT:    store <16 x i8> [[TMP2]], ptr [[R]], align 1
; SSE-NEXT:    [[ARRAYIDX_16:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 16
; SSE-NEXT:    [[ARRAYIDX2_16:%.*]] = getelementptr inbounds i8, ptr [[R]], i64 16
; SSE-NEXT:    [[TMP3:%.*]] = load <16 x i8>, ptr [[ARRAYIDX_16]], align 1
; SSE-NEXT:    [[TMP4:%.*]] = load <16 x i8>, ptr [[ARRAYIDX2_16]], align 1
; SSE-NEXT:    [[TMP5:%.*]] = add <16 x i8> [[TMP4]], [[TMP3]]
; SSE-NEXT:    store <16 x i8> [[TMP5]], ptr [[ARRAYIDX2_16]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @add32(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load <32 x i8>, ptr [[A:%.*]], align 1
; AVX-NEXT:    [[TMP1:%.*]] = load <32 x i8>, ptr [[R:%.*]], align 1
; AVX-NEXT:    [[TMP2:%.*]] = add <32 x i8> [[TMP1]], [[TMP0]]
; AVX-NEXT:    store <32 x i8> [[TMP2]], ptr [[R]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i8, ptr %a, align 1
  %1 = load i8, ptr %r, align 1
  %add = add i8 %1, %0
  store i8 %add, ptr %r, align 1
  %arrayidx.1 = getelementptr inbounds i8, ptr %a, i64 1
  %2 = load i8, ptr %arrayidx.1, align 1
  %arrayidx2.1 = getelementptr inbounds i8, ptr %r, i64 1
  %3 = load i8, ptr %arrayidx2.1, align 1
  %add.1 = add i8 %3, %2
  store i8 %add.1, ptr %arrayidx2.1, align 1
  %arrayidx.2 = getelementptr inbounds i8, ptr %a, i64 2
  %4 = load i8, ptr %arrayidx.2, align 1
  %arrayidx2.2 = getelementptr inbounds i8, ptr %r, i64 2
  %5 = load i8, ptr %arrayidx2.2, align 1
  %add.2 = add i8 %5, %4
  store i8 %add.2, ptr %arrayidx2.2, align 1
  %arrayidx.3 = getelementptr inbounds i8, ptr %a, i64 3
  %6 = load i8, ptr %arrayidx.3, align 1
  %arrayidx2.3 = getelementptr inbounds i8, ptr %r, i64 3
  %7 = load i8, ptr %arrayidx2.3, align 1
  %add.3 = add i8 %7, %6
  store i8 %add.3, ptr %arrayidx2.3, align 1
  %arrayidx.4 = getelementptr inbounds i8, ptr %a, i64 4
  %8 = load i8, ptr %arrayidx.4, align 1
  %arrayidx2.4 = getelementptr inbounds i8, ptr %r, i64 4
  %9 = load i8, ptr %arrayidx2.4, align 1
  %add.4 = add i8 %9, %8
  store i8 %add.4, ptr %arrayidx2.4, align 1
  %arrayidx.5 = getelementptr inbounds i8, ptr %a, i64 5
  %10 = load i8, ptr %arrayidx.5, align 1
  %arrayidx2.5 = getelementptr inbounds i8, ptr %r, i64 5
  %11 = load i8, ptr %arrayidx2.5, align 1
  %add.5 = add i8 %11, %10
  store i8 %add.5, ptr %arrayidx2.5, align 1
  %arrayidx.6 = getelementptr inbounds i8, ptr %a, i64 6
  %12 = load i8, ptr %arrayidx.6, align 1
  %arrayidx2.6 = getelementptr inbounds i8, ptr %r, i64 6
  %13 = load i8, ptr %arrayidx2.6, align 1
  %add.6 = add i8 %13, %12
  store i8 %add.6, ptr %arrayidx2.6, align 1
  %arrayidx.7 = getelementptr inbounds i8, ptr %a, i64 7
  %14 = load i8, ptr %arrayidx.7, align 1
  %arrayidx2.7 = getelementptr inbounds i8, ptr %r, i64 7
  %15 = load i8, ptr %arrayidx2.7, align 1
  %add.7 = add i8 %15, %14
  store i8 %add.7, ptr %arrayidx2.7, align 1
  %arrayidx.8 = getelementptr inbounds i8, ptr %a, i64 8
  %16 = load i8, ptr %arrayidx.8, align 1
  %arrayidx2.8 = getelementptr inbounds i8, ptr %r, i64 8
  %17 = load i8, ptr %arrayidx2.8, align 1
  %add.8 = add i8 %17, %16
  store i8 %add.8, ptr %arrayidx2.8, align 1
  %arrayidx.9 = getelementptr inbounds i8, ptr %a, i64 9
  %18 = load i8, ptr %arrayidx.9, align 1
  %arrayidx2.9 = getelementptr inbounds i8, ptr %r, i64 9
  %19 = load i8, ptr %arrayidx2.9, align 1
  %add.9 = add i8 %19, %18
  store i8 %add.9, ptr %arrayidx2.9, align 1
  %arrayidx.10 = getelementptr inbounds i8, ptr %a, i64 10
  %20 = load i8, ptr %arrayidx.10, align 1
  %arrayidx2.10 = getelementptr inbounds i8, ptr %r, i64 10
  %21 = load i8, ptr %arrayidx2.10, align 1
  %add.10 = add i8 %21, %20
  store i8 %add.10, ptr %arrayidx2.10, align 1
  %arrayidx.11 = getelementptr inbounds i8, ptr %a, i64 11
  %22 = load i8, ptr %arrayidx.11, align 1
  %arrayidx2.11 = getelementptr inbounds i8, ptr %r, i64 11
  %23 = load i8, ptr %arrayidx2.11, align 1
  %add.11 = add i8 %23, %22
  store i8 %add.11, ptr %arrayidx2.11, align 1
  %arrayidx.12 = getelementptr inbounds i8, ptr %a, i64 12
  %24 = load i8, ptr %arrayidx.12, align 1
  %arrayidx2.12 = getelementptr inbounds i8, ptr %r, i64 12
  %25 = load i8, ptr %arrayidx2.12, align 1
  %add.12 = add i8 %25, %24
  store i8 %add.12, ptr %arrayidx2.12, align 1
  %arrayidx.13 = getelementptr inbounds i8, ptr %a, i64 13
  %26 = load i8, ptr %arrayidx.13, align 1
  %arrayidx2.13 = getelementptr inbounds i8, ptr %r, i64 13
  %27 = load i8, ptr %arrayidx2.13, align 1
  %add.13 = add i8 %27, %26
  store i8 %add.13, ptr %arrayidx2.13, align 1
  %arrayidx.14 = getelementptr inbounds i8, ptr %a, i64 14
  %28 = load i8, ptr %arrayidx.14, align 1
  %arrayidx2.14 = getelementptr inbounds i8, ptr %r, i64 14
  %29 = load i8, ptr %arrayidx2.14, align 1
  %add.14 = add i8 %29, %28
  store i8 %add.14, ptr %arrayidx2.14, align 1
  %arrayidx.15 = getelementptr inbounds i8, ptr %a, i64 15
  %30 = load i8, ptr %arrayidx.15, align 1
  %arrayidx2.15 = getelementptr inbounds i8, ptr %r, i64 15
  %31 = load i8, ptr %arrayidx2.15, align 1
  %add.15 = add i8 %31, %30
  store i8 %add.15, ptr %arrayidx2.15, align 1
  %arrayidx.16 = getelementptr inbounds i8, ptr %a, i64 16
  %32 = load i8, ptr %arrayidx.16, align 1
  %arrayidx2.16 = getelementptr inbounds i8, ptr %r, i64 16
  %33 = load i8, ptr %arrayidx2.16, align 1
  %add.16 = add i8 %33, %32
  store i8 %add.16, ptr %arrayidx2.16, align 1
  %arrayidx.17 = getelementptr inbounds i8, ptr %a, i64 17
  %34 = load i8, ptr %arrayidx.17, align 1
  %arrayidx2.17 = getelementptr inbounds i8, ptr %r, i64 17
  %35 = load i8, ptr %arrayidx2.17, align 1
  %add.17 = add i8 %35, %34
  store i8 %add.17, ptr %arrayidx2.17, align 1
  %arrayidx.18 = getelementptr inbounds i8, ptr %a, i64 18
  %36 = load i8, ptr %arrayidx.18, align 1
  %arrayidx2.18 = getelementptr inbounds i8, ptr %r, i64 18
  %37 = load i8, ptr %arrayidx2.18, align 1
  %add.18 = add i8 %37, %36
  store i8 %add.18, ptr %arrayidx2.18, align 1
  %arrayidx.19 = getelementptr inbounds i8, ptr %a, i64 19
  %38 = load i8, ptr %arrayidx.19, align 1
  %arrayidx2.19 = getelementptr inbounds i8, ptr %r, i64 19
  %39 = load i8, ptr %arrayidx2.19, align 1
  %add.19 = add i8 %39, %38
  store i8 %add.19, ptr %arrayidx2.19, align 1
  %arrayidx.20 = getelementptr inbounds i8, ptr %a, i64 20
  %40 = load i8, ptr %arrayidx.20, align 1
  %arrayidx2.20 = getelementptr inbounds i8, ptr %r, i64 20
  %41 = load i8, ptr %arrayidx2.20, align 1
  %add.20 = add i8 %41, %40
  store i8 %add.20, ptr %arrayidx2.20, align 1
  %arrayidx.21 = getelementptr inbounds i8, ptr %a, i64 21
  %42 = load i8, ptr %arrayidx.21, align 1
  %arrayidx2.21 = getelementptr inbounds i8, ptr %r, i64 21
  %43 = load i8, ptr %arrayidx2.21, align 1
  %add.21 = add i8 %43, %42
  store i8 %add.21, ptr %arrayidx2.21, align 1
  %arrayidx.22 = getelementptr inbounds i8, ptr %a, i64 22
  %44 = load i8, ptr %arrayidx.22, align 1
  %arrayidx2.22 = getelementptr inbounds i8, ptr %r, i64 22
  %45 = load i8, ptr %arrayidx2.22, align 1
  %add.22 = add i8 %45, %44
  store i8 %add.22, ptr %arrayidx2.22, align 1
  %arrayidx.23 = getelementptr inbounds i8, ptr %a, i64 23
  %46 = load i8, ptr %arrayidx.23, align 1
  %arrayidx2.23 = getelementptr inbounds i8, ptr %r, i64 23
  %47 = load i8, ptr %arrayidx2.23, align 1
  %add.23 = add i8 %47, %46
  store i8 %add.23, ptr %arrayidx2.23, align 1
  %arrayidx.24 = getelementptr inbounds i8, ptr %a, i64 24
  %48 = load i8, ptr %arrayidx.24, align 1
  %arrayidx2.24 = getelementptr inbounds i8, ptr %r, i64 24
  %49 = load i8, ptr %arrayidx2.24, align 1
  %add.24 = add i8 %49, %48
  store i8 %add.24, ptr %arrayidx2.24, align 1
  %arrayidx.25 = getelementptr inbounds i8, ptr %a, i64 25
  %50 = load i8, ptr %arrayidx.25, align 1
  %arrayidx2.25 = getelementptr inbounds i8, ptr %r, i64 25
  %51 = load i8, ptr %arrayidx2.25, align 1
  %add.25 = add i8 %51, %50
  store i8 %add.25, ptr %arrayidx2.25, align 1
  %arrayidx.26 = getelementptr inbounds i8, ptr %a, i64 26
  %52 = load i8, ptr %arrayidx.26, align 1
  %arrayidx2.26 = getelementptr inbounds i8, ptr %r, i64 26
  %53 = load i8, ptr %arrayidx2.26, align 1
  %add.26 = add i8 %53, %52
  store i8 %add.26, ptr %arrayidx2.26, align 1
  %arrayidx.27 = getelementptr inbounds i8, ptr %a, i64 27
  %54 = load i8, ptr %arrayidx.27, align 1
  %arrayidx2.27 = getelementptr inbounds i8, ptr %r, i64 27
  %55 = load i8, ptr %arrayidx2.27, align 1
  %add.27 = add i8 %55, %54
  store i8 %add.27, ptr %arrayidx2.27, align 1
  %arrayidx.28 = getelementptr inbounds i8, ptr %a, i64 28
  %56 = load i8, ptr %arrayidx.28, align 1
  %arrayidx2.28 = getelementptr inbounds i8, ptr %r, i64 28
  %57 = load i8, ptr %arrayidx2.28, align 1
  %add.28 = add i8 %57, %56
  store i8 %add.28, ptr %arrayidx2.28, align 1
  %arrayidx.29 = getelementptr inbounds i8, ptr %a, i64 29
  %58 = load i8, ptr %arrayidx.29, align 1
  %arrayidx2.29 = getelementptr inbounds i8, ptr %r, i64 29
  %59 = load i8, ptr %arrayidx2.29, align 1
  %add.29 = add i8 %59, %58
  store i8 %add.29, ptr %arrayidx2.29, align 1
  %arrayidx.30 = getelementptr inbounds i8, ptr %a, i64 30
  %60 = load i8, ptr %arrayidx.30, align 1
  %arrayidx2.30 = getelementptr inbounds i8, ptr %r, i64 30
  %61 = load i8, ptr %arrayidx2.30, align 1
  %add.30 = add i8 %61, %60
  store i8 %add.30, ptr %arrayidx2.30, align 1
  %arrayidx.31 = getelementptr inbounds i8, ptr %a, i64 31
  %62 = load i8, ptr %arrayidx.31, align 1
  %arrayidx2.31 = getelementptr inbounds i8, ptr %r, i64 31
  %63 = load i8, ptr %arrayidx2.31, align 1
  %add.31 = add i8 %63, %62
  store i8 %add.31, ptr %arrayidx2.31, align 1
  ret void
}
