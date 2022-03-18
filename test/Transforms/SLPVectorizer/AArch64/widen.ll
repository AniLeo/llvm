; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"
target triple = "aarch64"

; This should not be matched as a load combining candidate.
; There are no 'or' operations, so it can't be a bswap or
; other pattern that we are expecting the backend to handle.

define void @PR50256(i8* %a, i16* %b, i32 %n) {
; CHECK-LABEL: @PR50256(
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i8, i8* [[A:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 2
; CHECK-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 3
; CHECK-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 4
; CHECK-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 5
; CHECK-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 7
; CHECK-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 6
; CHECK-NEXT:    [[ARRAYIDX_8:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 8
; CHECK-NEXT:    [[ARRAYIDX_9:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 9
; CHECK-NEXT:    [[ARRAYIDX_10:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 10
; CHECK-NEXT:    [[ARRAYIDX_11:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 11
; CHECK-NEXT:    [[ARRAYIDX_12:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 12
; CHECK-NEXT:    [[ARRAYIDX_13:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 13
; CHECK-NEXT:    [[ARRAYIDX_14:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 14
; CHECK-NEXT:    [[ARRAYIDX_15:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 15
; CHECK-NEXT:    [[ARRAYIDX3_1:%.*]] = getelementptr inbounds i16, i16* [[B:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX3_2:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 2
; CHECK-NEXT:    [[ARRAYIDX3_3:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 3
; CHECK-NEXT:    [[ARRAYIDX3_4:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 4
; CHECK-NEXT:    [[ARRAYIDX3_5:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 5
; CHECK-NEXT:    [[ARRAYIDX3_6:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 6
; CHECK-NEXT:    [[ARRAYIDX3_7:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 7
; CHECK-NEXT:    [[ARRAYIDX3_8:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 8
; CHECK-NEXT:    [[ARRAYIDX3_9:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 9
; CHECK-NEXT:    [[ARRAYIDX3_10:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 10
; CHECK-NEXT:    [[ARRAYIDX3_11:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 11
; CHECK-NEXT:    [[ARRAYIDX3_12:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 12
; CHECK-NEXT:    [[ARRAYIDX3_13:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 13
; CHECK-NEXT:    [[ARRAYIDX3_14:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 14
; CHECK-NEXT:    [[ARRAYIDX3_15:%.*]] = getelementptr inbounds i16, i16* [[B]], i64 15
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[A]] to <8 x i8>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i8>, <8 x i8>* [[TMP1]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = zext <8 x i8> [[TMP2]] to <8 x i16>
; CHECK-NEXT:    [[TMP4:%.*]] = shl nuw <8 x i16> [[TMP3]], <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i16* [[B]] to <8 x i16>*
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i8* [[ARRAYIDX_8]] to <8 x i8>*
; CHECK-NEXT:    [[TMP7:%.*]] = load <8 x i8>, <8 x i8>* [[TMP6]], align 1
; CHECK-NEXT:    [[TMP8:%.*]] = zext <8 x i8> [[TMP7]] to <8 x i16>
; CHECK-NEXT:    [[TMP9:%.*]] = shl nuw <8 x i16> [[TMP8]], <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
; CHECK-NEXT:    store <8 x i16> [[TMP4]], <8 x i16>* [[TMP5]], align 2
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i16* [[ARRAYIDX3_8]] to <8 x i16>*
; CHECK-NEXT:    store <8 x i16> [[TMP9]], <8 x i16>* [[TMP10]], align 2
; CHECK-NEXT:    ret void
;
  %arrayidx.1 = getelementptr inbounds i8, i8* %a, i64 1
  %arrayidx.2 = getelementptr inbounds i8, i8* %a, i64 2
  %arrayidx.3 = getelementptr inbounds i8, i8* %a, i64 3
  %arrayidx.4 = getelementptr inbounds i8, i8* %a, i64 4
  %arrayidx.5 = getelementptr inbounds i8, i8* %a, i64 5
  %arrayidx.7 = getelementptr inbounds i8, i8* %a, i64 7
  %arrayidx.6 = getelementptr inbounds i8, i8* %a, i64 6
  %arrayidx.8 = getelementptr inbounds i8, i8* %a, i64 8
  %arrayidx.9 = getelementptr inbounds i8, i8* %a, i64 9
  %arrayidx.10 = getelementptr inbounds i8, i8* %a, i64 10
  %arrayidx.11 = getelementptr inbounds i8, i8* %a, i64 11
  %arrayidx.12 = getelementptr inbounds i8, i8* %a, i64 12
  %arrayidx.13 = getelementptr inbounds i8, i8* %a, i64 13
  %arrayidx.14 = getelementptr inbounds i8, i8* %a, i64 14
  %arrayidx.15 = getelementptr inbounds i8, i8* %a, i64 15
  %i = load i8, i8* %a, align 1
  %i1 = load i8, i8* %arrayidx.1, align 1
  %i2 = load i8, i8* %arrayidx.2, align 1
  %i3 = load i8, i8* %arrayidx.3, align 1
  %i4 = load i8, i8* %arrayidx.4, align 1
  %i5 = load i8, i8* %arrayidx.5, align 1
  %i6 = load i8, i8* %arrayidx.6, align 1
  %i7 = load i8, i8* %arrayidx.7, align 1
  %i8 = load i8, i8* %arrayidx.8, align 1
  %i9 = load i8, i8* %arrayidx.9, align 1
  %i10 = load i8, i8* %arrayidx.10, align 1
  %i11 = load i8, i8* %arrayidx.11, align 1
  %i12 = load i8, i8* %arrayidx.12, align 1
  %i13 = load i8, i8* %arrayidx.13, align 1
  %i14 = load i8, i8* %arrayidx.14, align 1
  %i15 = load i8, i8* %arrayidx.15, align 1
  %conv5 = zext i8 %i to i16
  %conv5.1 = zext i8 %i1 to i16
  %conv5.2 = zext i8 %i2 to i16
  %conv5.3 = zext i8 %i3 to i16
  %conv5.4 = zext i8 %i4 to i16
  %conv5.5 = zext i8 %i5 to i16
  %conv5.6 = zext i8 %i6 to i16
  %conv5.7 = zext i8 %i7 to i16
  %conv5.8 = zext i8 %i8 to i16
  %conv5.9 = zext i8 %i9 to i16
  %conv5.10 = zext i8 %i10 to i16
  %conv5.11 = zext i8 %i11 to i16
  %conv5.12 = zext i8 %i12 to i16
  %conv5.13 = zext i8 %i13 to i16
  %conv5.14 = zext i8 %i14 to i16
  %conv5.15 = zext i8 %i15 to i16
  %shl = shl nuw i16 %conv5, 8
  %shl.1 = shl nuw i16 %conv5.1, 8
  %shl.2 = shl nuw i16 %conv5.2, 8
  %shl.3 = shl nuw i16 %conv5.3, 8
  %shl.4 = shl nuw i16 %conv5.4, 8
  %shl.5 = shl nuw i16 %conv5.5, 8
  %shl.6 = shl nuw i16 %conv5.6, 8
  %shl.7 = shl nuw i16 %conv5.7, 8
  %shl.8 = shl nuw i16 %conv5.8, 8
  %shl.9 = shl nuw i16 %conv5.9, 8
  %shl.10 = shl nuw i16 %conv5.10, 8
  %shl.11 = shl nuw i16 %conv5.11, 8
  %shl.12 = shl nuw i16 %conv5.12, 8
  %shl.13 = shl nuw i16 %conv5.13, 8
  %shl.14 = shl nuw i16 %conv5.14, 8
  %shl.15 = shl nuw i16 %conv5.15, 8
  %arrayidx3.1 = getelementptr inbounds i16, i16* %b, i64 1
  %arrayidx3.2 = getelementptr inbounds i16, i16* %b, i64 2
  %arrayidx3.3 = getelementptr inbounds i16, i16* %b, i64 3
  %arrayidx3.4 = getelementptr inbounds i16, i16* %b, i64 4
  %arrayidx3.5 = getelementptr inbounds i16, i16* %b, i64 5
  %arrayidx3.6 = getelementptr inbounds i16, i16* %b, i64 6
  %arrayidx3.7 = getelementptr inbounds i16, i16* %b, i64 7
  %arrayidx3.8 = getelementptr inbounds i16, i16* %b, i64 8
  %arrayidx3.9 = getelementptr inbounds i16, i16* %b, i64 9
  %arrayidx3.10 = getelementptr inbounds i16, i16* %b, i64 10
  %arrayidx3.11 = getelementptr inbounds i16, i16* %b, i64 11
  %arrayidx3.12 = getelementptr inbounds i16, i16* %b, i64 12
  %arrayidx3.13 = getelementptr inbounds i16, i16* %b, i64 13
  %arrayidx3.14 = getelementptr inbounds i16, i16* %b, i64 14
  %arrayidx3.15 = getelementptr inbounds i16, i16* %b, i64 15
  store i16 %shl, i16* %b, align 2
  store i16 %shl.1, i16* %arrayidx3.1, align 2
  store i16 %shl.2, i16* %arrayidx3.2, align 2
  store i16 %shl.3, i16* %arrayidx3.3, align 2
  store i16 %shl.4, i16* %arrayidx3.4, align 2
  store i16 %shl.5, i16* %arrayidx3.5, align 2
  store i16 %shl.6, i16* %arrayidx3.6, align 2
  store i16 %shl.7, i16* %arrayidx3.7, align 2
  store i16 %shl.8, i16* %arrayidx3.8, align 2
  store i16 %shl.9, i16* %arrayidx3.9, align 2
  store i16 %shl.10, i16* %arrayidx3.10, align 2
  store i16 %shl.11, i16* %arrayidx3.11, align 2
  store i16 %shl.12, i16* %arrayidx3.12, align 2
  store i16 %shl.13, i16* %arrayidx3.13, align 2
  store i16 %shl.14, i16* %arrayidx3.14, align 2
  store i16 %shl.15, i16* %arrayidx3.15, align 2
  ret void
}
