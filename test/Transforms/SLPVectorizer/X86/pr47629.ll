; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN:  opt < %s -slp-vectorizer -instcombine -S -mtriple=x86_64-unknown-linux -march=avx512 | FileCheck %s

define void @gather_load(i32* %0, i32* readonly %1) {
; CHECK-LABEL: @gather_load(
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[TMP1:%.*]], i64 1
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 11
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, i32* [[TMP5]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 4
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <4 x i32> undef, i32 [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x i32> [[TMP10]], i32 [[TMP6]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <4 x i32> [[TMP11]], i32 [[TMP8]], i32 2
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <4 x i32> [[TMP12]], i32 [[TMP9]], i32 3
; CHECK-NEXT:    [[TMP14:%.*]] = add nsw <4 x i32> [[TMP13]], <i32 1, i32 2, i32 3, i32 4>
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast i32* [[TMP0:%.*]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP14]], <4 x i32>* [[TMP15]], align 4
; CHECK-NEXT:    ret void
;
  %3 = getelementptr inbounds i32, i32* %1, i64 1
  %4 = load i32, i32* %1, align 4
  %5 = getelementptr inbounds i32, i32* %0, i64 1
  %6 = getelementptr inbounds i32, i32* %1, i64 11
  %7 = load i32, i32* %6, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 2
  %9 = getelementptr inbounds i32, i32* %1, i64 4
  %10 = load i32, i32* %9, align 4
  %11 = getelementptr inbounds i32, i32* %0, i64 3
  %12 = load i32, i32* %3, align 4
  %13 = insertelement <4 x i32> undef, i32 %4, i32 0
  %14 = insertelement <4 x i32> %13, i32 %7, i32 1
  %15 = insertelement <4 x i32> %14, i32 %10, i32 2
  %16 = insertelement <4 x i32> %15, i32 %12, i32 3
  %17 = add nsw <4 x i32> %16, <i32 1, i32 2, i32 3, i32 4>
  %18 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %17, <4 x i32>* %18, align 4
  ret void
}
