; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -slp-vectorize-hor -slp-vectorize-hor-store -S < %s -mtriple=x86_64-apple-macosx -mcpu=corei7-avx | FileCheck %s

;void Distance(float *p1, int p2, unsigned long p3[], float p4[]) {
;  long a = p3[0] = 5;
;  p1 += p2;
;  p4[3] += p1[a];
;  p3[0] >>= 5;
;  p3[1] >>= 5;
;  p3[2] >>= 5;
;  p3[3] >>= 5;
;  p1 += p2;
;  p4[0] += p1[p3[0] & a];
;}

define void @_Z8DistanceIlLi5EEvPfiPmS0_(float* %p1, i32 %p2, i64* %p3, float* %p4) {
; CHECK-LABEL: @_Z8DistanceIlLi5EEvPfiPmS0_(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i64 5, i64* [[P3:%.*]], align 8
; CHECK-NEXT:    [[IDX_EXT:%.*]] = sext i32 [[P2:%.*]] to i64
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds float, float* [[P1:%.*]], i64 [[IDX_EXT]]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds float, float* [[ADD_PTR]], i64 5
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[P4:%.*]], i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = fadd float [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store float [[ADD]], float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* [[P3]], align 8
; CHECK-NEXT:    [[SHR:%.*]] = lshr i64 [[TMP2]], 5
; CHECK-NEXT:    store i64 [[SHR]], i64* [[P3]], align 8
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds i64, i64* [[P3]], i64 1
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i64, i64* [[P3]], i64 2
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i64* [[ARRAYIDX4]] to <2 x i64>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <2 x i64>, <2 x i64>* [[TMP3]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = lshr <2 x i64> [[TMP4]], <i64 5, i64 5>
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i64* [[ARRAYIDX4]] to <2 x i64>*
; CHECK-NEXT:    store <2 x i64> [[TMP5]], <2 x i64>* [[TMP6]], align 8
; CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds i64, i64* [[P3]], i64 3
; CHECK-NEXT:    [[TMP7:%.*]] = load i64, i64* [[ARRAYIDX8]], align 8
; CHECK-NEXT:    [[SHR9:%.*]] = lshr i64 [[TMP7]], 5
; CHECK-NEXT:    store i64 [[SHR9]], i64* [[ARRAYIDX8]], align 8
; CHECK-NEXT:    [[ADD_PTR11:%.*]] = getelementptr inbounds float, float* [[ADD_PTR]], i64 [[IDX_EXT]]
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[SHR]], 5
; CHECK-NEXT:    [[ARRAYIDX13:%.*]] = getelementptr inbounds float, float* [[ADD_PTR11]], i64 [[AND]]
; CHECK-NEXT:    [[TMP8:%.*]] = load float, float* [[ARRAYIDX13]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = load float, float* [[P4]], align 4
; CHECK-NEXT:    [[ADD15:%.*]] = fadd float [[TMP8]], [[TMP9]]
; CHECK-NEXT:    store float [[ADD15]], float* [[P4]], align 4
; CHECK-NEXT:    ret void
;
entry:
  store i64 5, i64* %p3, align 8
  %idx.ext = sext i32 %p2 to i64
  %add.ptr = getelementptr inbounds float, float* %p1, i64 %idx.ext
  %arrayidx1 = getelementptr inbounds float, float* %add.ptr, i64 5
  %0 = load float, float* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds float, float* %p4, i64 3
  %1 = load float, float* %arrayidx2, align 4
  %add = fadd float %0, %1
  store float %add, float* %arrayidx2, align 4
  %2 = load i64, i64* %p3, align 8
  %shr = lshr i64 %2, 5
  store i64 %shr, i64* %p3, align 8
  %arrayidx4 = getelementptr inbounds i64, i64* %p3, i64 1
  %3 = load i64, i64* %arrayidx4, align 8
  %shr5 = lshr i64 %3, 5
  store i64 %shr5, i64* %arrayidx4, align 8
  %arrayidx6 = getelementptr inbounds i64, i64* %p3, i64 2
  %4 = load i64, i64* %arrayidx6, align 8
  %shr7 = lshr i64 %4, 5
  store i64 %shr7, i64* %arrayidx6, align 8
  %arrayidx8 = getelementptr inbounds i64, i64* %p3, i64 3
  %5 = load i64, i64* %arrayidx8, align 8
  %shr9 = lshr i64 %5, 5
  store i64 %shr9, i64* %arrayidx8, align 8
  %add.ptr11 = getelementptr inbounds float, float* %add.ptr, i64 %idx.ext
  %and = and i64 %shr, 5
  %arrayidx13 = getelementptr inbounds float, float* %add.ptr11, i64 %and
  %6 = load float, float* %arrayidx13, align 4
  %7 = load float, float* %p4, align 4
  %add15 = fadd float %6, %7
  store float %add15, float* %p4, align 4
  ret void
}
