; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -mtriple=x86_64-unknown -mattr=+avx -slp-vectorizer | FileCheck %s

;void jumble (int * restrict A, int * restrict B) {
  ;  int tmp0 = A[10]*A[0];
  ;  int tmp1 = A[11]*A[1];
  ;  int tmp2 = A[12]*A[3];
  ;  int tmp3 = A[13]*A[2];
  ;  B[0] = tmp0;
  ;  B[1] = tmp1;
  ;  B[2] = tmp2;
  ;  B[3] = tmp3;
  ;}

; Function Attrs: norecurse nounwind uwtable
define void @jumble1(i32* noalias nocapture readonly %A, i32* noalias nocapture %B) {
; CHECK-LABEL: @jumble1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 10
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 11
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 1
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 12
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 3
; CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 13
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[ARRAYIDX]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 2
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[A]] to <4 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> poison, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = mul nsw <4 x i32> [[TMP1]], [[SHUFFLE]]
; CHECK-NEXT:    [[ARRAYIDX12:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX13:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 2
; CHECK-NEXT:    [[ARRAYIDX14:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 3
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i32* [[B]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* [[TMP5]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx = getelementptr inbounds i32, i32* %A, i64 10
  %0 = load i32, i32* %arrayidx, align 4
  %1 = load i32, i32* %A, align 4
  %mul = mul nsw i32 %0, %1
  %arrayidx2 = getelementptr inbounds i32, i32* %A, i64 11
  %2 = load i32, i32* %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds i32, i32* %A, i64 1
  %3 = load i32, i32* %arrayidx3, align 4
  %mul4 = mul nsw i32 %2, %3
  %arrayidx5 = getelementptr inbounds i32, i32* %A, i64 12
  %4 = load i32, i32* %arrayidx5, align 4
  %arrayidx6 = getelementptr inbounds i32, i32* %A, i64 3
  %5 = load i32, i32* %arrayidx6, align 4
  %mul7 = mul nsw i32 %4, %5
  %arrayidx8 = getelementptr inbounds i32, i32* %A, i64 13
  %6 = load i32, i32* %arrayidx8, align 4
  %arrayidx9 = getelementptr inbounds i32, i32* %A, i64 2
  %7 = load i32, i32* %arrayidx9, align 4
  %mul10 = mul nsw i32 %6, %7
  store i32 %mul, i32* %B, align 4
  %arrayidx12 = getelementptr inbounds i32, i32* %B, i64 1
  store i32 %mul4, i32* %arrayidx12, align 4
  %arrayidx13 = getelementptr inbounds i32, i32* %B, i64 2
  store i32 %mul7, i32* %arrayidx13, align 4
  %arrayidx14 = getelementptr inbounds i32, i32* %B, i64 3
  store i32 %mul10, i32* %arrayidx14, align 4
  ret void
}

;Reversing the operand of MUL

; Function Attrs: norecurse nounwind uwtable
define void @jumble2(i32* noalias nocapture readonly %A, i32* noalias nocapture %B) {
; CHECK-LABEL: @jumble2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 10
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 11
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 1
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 12
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 3
; CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 13
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[ARRAYIDX]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 2
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[A]] to <4 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i32> [[TMP3]], <4 x i32> poison, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = mul nsw <4 x i32> [[SHUFFLE]], [[TMP1]]
; CHECK-NEXT:    [[ARRAYIDX12:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX13:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 2
; CHECK-NEXT:    [[ARRAYIDX14:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 3
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i32* [[B]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* [[TMP5]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx = getelementptr inbounds i32, i32* %A, i64 10
  %0 = load i32, i32* %arrayidx, align 4
  %1 = load i32, i32* %A, align 4
  %mul = mul nsw i32 %1, %0
  %arrayidx2 = getelementptr inbounds i32, i32* %A, i64 11
  %2 = load i32, i32* %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds i32, i32* %A, i64 1
  %3 = load i32, i32* %arrayidx3, align 4
  %mul4 = mul nsw i32 %3, %2
  %arrayidx5 = getelementptr inbounds i32, i32* %A, i64 12
  %4 = load i32, i32* %arrayidx5, align 4
  %arrayidx6 = getelementptr inbounds i32, i32* %A, i64 3
  %5 = load i32, i32* %arrayidx6, align 4
  %mul7 = mul nsw i32 %5, %4
  %arrayidx8 = getelementptr inbounds i32, i32* %A, i64 13
  %6 = load i32, i32* %arrayidx8, align 4
  %arrayidx9 = getelementptr inbounds i32, i32* %A, i64 2
  %7 = load i32, i32* %arrayidx9, align 4
  %mul10 = mul nsw i32 %7, %6
  store i32 %mul, i32* %B, align 4
  %arrayidx12 = getelementptr inbounds i32, i32* %B, i64 1
  store i32 %mul4, i32* %arrayidx12, align 4
  %arrayidx13 = getelementptr inbounds i32, i32* %B, i64 2
  store i32 %mul7, i32* %arrayidx13, align 4
  %arrayidx14 = getelementptr inbounds i32, i32* %B, i64 3
  store i32 %mul10, i32* %arrayidx14, align 4
  ret void
}

