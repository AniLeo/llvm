; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -mattr=+avx512f -mtriple=x86_64 -S < %s | FileCheck %s

define void @test(float* noalias %0, float* %p) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x float*> poison, float* [[P:%.*]], i32 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <8 x float*> [[TMP2]], <8 x float*> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr float, <8 x float*> [[SHUFFLE]], <8 x i64> <i64 15, i64 4, i64 5, i64 0, i64 2, i64 6, i64 7, i64 8>
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds float, float* [[TMP0:%.*]], i64 2
; CHECK-NEXT:    [[TMP5:%.*]] = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> [[TMP3]], i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef)
; CHECK-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <8 x float> [[TMP5]], <8 x float> poison, <16 x i32> <i32 4, i32 3, i32 0, i32 1, i32 2, i32 0, i32 1, i32 2, i32 0, i32 2, i32 5, i32 6, i32 7, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <16 x float> <float poison, float poison, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00>, <16 x float> [[SHUFFLE1]], <16 x i32> <i32 18, i32 19, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP7:%.*]] = fadd reassoc nsz arcp contract afn <16 x float> [[SHUFFLE1]], [[TMP6]]
; CHECK-NEXT:    [[SHUFFLE2:%.*]] = shufflevector <16 x float> [[TMP7]], <16 x float> poison, <16 x i32> <i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 1, i32 9, i32 0, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP4]] to <16 x float>*
; CHECK-NEXT:    store <16 x float> [[SHUFFLE2]], <16 x float>* [[TMP8]], align 4
; CHECK-NEXT:    ret void
;
  %2 = getelementptr inbounds float, float* %p, i64 2
  %3 = getelementptr inbounds float, float* %p, i64 4
  %4 = load float, float* %3, align 4
  %5 = getelementptr inbounds float, float* %p, i64 5
  %6 = load float, float* %5, align 16
  %7 = getelementptr inbounds float, float* %p, i64 15
  %8 = load float, float* %7, align 4
  %9 = fadd reassoc nsz arcp contract afn float %8, 0.000000e+00
  %10 = getelementptr inbounds float, float* %0, i64 2
  store float %9, float* %10, align 4
  %11 = fadd reassoc nsz arcp contract afn float %4, 0.000000e+00
  %12 = getelementptr inbounds float, float* %0, i64 3
  store float %11, float* %12, align 4
  %13 = fadd reassoc nsz arcp contract afn float %6, 0.000000e+00
  %14 = getelementptr inbounds float, float* %0, i64 4
  store float %13, float* %14, align 4
  %15 = fadd reassoc nsz arcp contract afn float %8, 0.000000e+00
  %16 = getelementptr inbounds float, float* %0, i64 5
  store float %15, float* %16, align 4
  %17 = fadd reassoc nsz arcp contract afn float %4, 0.000000e+00
  %18 = load float, float* %p, align 16
  %19 = getelementptr inbounds float, float* %0, i64 6
  store float %17, float* %19, align 4
  %20 = fadd reassoc nsz arcp contract afn float %6, 0.000000e+00
  %21 = getelementptr inbounds float, float* %0, i64 7
  store float %20, float* %21, align 4
  %22 = fadd reassoc nsz arcp contract afn float %8, 0.000000e+00
  %23 = load float, float* %2, align 8
  %24 = getelementptr inbounds float, float* %0, i64 8
  store float %22, float* %24, align 4
  %25 = fadd reassoc nsz arcp contract afn float %4, %18
  %26 = getelementptr inbounds float, float* %0, i64 9
  store float %25, float* %26, align 4
  %27 = fadd reassoc nsz arcp contract afn float %6, 0.000000e+00
  %28 = getelementptr inbounds float, float* %0, i64 10
  store float %27, float* %28, align 4
  %29 = fadd reassoc nsz arcp contract afn float %8, %23
  %30 = getelementptr inbounds float, float* %0, i64 11
  store float %29, float* %30, align 4
  %31 = getelementptr inbounds float, float* %p, i64 6
  %32 = load float, float* %31, align 4
  %33 = fadd reassoc nsz arcp contract afn float %32, 0.000000e+00
  %34 = getelementptr inbounds float, float* %0, i64 12
  store float %33, float* %34, align 4
  %35 = getelementptr inbounds float, float* %p, i64 7
  %36 = load float, float* %35, align 8
  %37 = fadd reassoc nsz arcp contract afn float %36, 0.000000e+00
  %38 = getelementptr inbounds float, float* %0, i64 13
  store float %37, float* %38, align 4
  %39 = getelementptr inbounds float, float* %p, i64 8
  %40 = load float, float* %39, align 4
  %41 = fadd reassoc nsz arcp contract afn float %40, 0.000000e+00
  %42 = getelementptr inbounds float, float* %0, i64 14
  store float %41, float* %42, align 4
  %43 = fadd reassoc nsz arcp contract afn float %32, 0.000000e+00
  %44 = getelementptr inbounds float, float* %0, i64 15
  store float %43, float* %44, align 4
  %45 = fadd reassoc nsz arcp contract afn float %36, 0.000000e+00
  %46 = getelementptr inbounds float, float* %0, i64 16
  store float %45, float* %46, align 4
  %47 = fadd reassoc nsz arcp contract afn float %40, 0.000000e+00
  %48 = getelementptr inbounds float, float* %0, i64 17
  store float %47, float* %48, align 4
  ret void
}
