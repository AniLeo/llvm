; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN:  opt < %s -slp-vectorizer -instcombine -S -mtriple=x86_64-unknown-linux -mattr=+sse2     | FileCheck %s --check-prefixes=CHECK,SSE
; RUN:  opt < %s -slp-vectorizer -instcombine -S -mtriple=x86_64-unknown-linux -mattr=+avx      | FileCheck %s --check-prefixes=CHECK,AVX
; RUN:  opt < %s -slp-vectorizer -instcombine -S -mtriple=x86_64-unknown-linux -mattr=+avx2     | FileCheck %s --check-prefixes=CHECK,AVX
; RUN:  opt < %s -slp-vectorizer -instcombine -S -mtriple=x86_64-unknown-linux -mattr=+avx512f  | FileCheck %s --check-prefixes=CHECK,AVX
; RUN:  opt < %s -slp-vectorizer -instcombine -S -mtriple=x86_64-unknown-linux -mattr=+avx512vl | FileCheck %s --check-prefixes=CHECK,AVX

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

define void @gather_load_2(i32* %0, i32* readonly %1) {
; CHECK-LABEL: @gather_load_2(
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[TMP1:%.*]], i64 1
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw i32 [[TMP4]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[TMP0:%.*]], i64 1
; CHECK-NEXT:    store i32 [[TMP5]], i32* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 10
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = add nsw i32 [[TMP8]], 2
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 2
; CHECK-NEXT:    store i32 [[TMP9]], i32* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 3
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32* [[TMP11]], align 4
; CHECK-NEXT:    [[TMP13:%.*]] = add nsw i32 [[TMP12]], 3
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 3
; CHECK-NEXT:    store i32 [[TMP13]], i32* [[TMP10]], align 4
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 5
; CHECK-NEXT:    [[TMP16:%.*]] = load i32, i32* [[TMP15]], align 4
; CHECK-NEXT:    [[TMP17:%.*]] = add nsw i32 [[TMP16]], 4
; CHECK-NEXT:    store i32 [[TMP17]], i32* [[TMP14]], align 4
; CHECK-NEXT:    ret void
;
  %3 = getelementptr inbounds i32, i32* %1, i64 1
  %4 = load i32, i32* %3, align 4
  %5 = add nsw i32 %4, 1
  %6 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 %5, i32* %0, align 4
  %7 = getelementptr inbounds i32, i32* %1, i64 10
  %8 = load i32, i32* %7, align 4
  %9 = add nsw i32 %8, 2
  %10 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 %9, i32* %6, align 4
  %11 = getelementptr inbounds i32, i32* %1, i64 3
  %12 = load i32, i32* %11, align 4
  %13 = add nsw i32 %12, 3
  %14 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 %13, i32* %10, align 4
  %15 = getelementptr inbounds i32, i32* %1, i64 5
  %16 = load i32, i32* %15, align 4
  %17 = add nsw i32 %16, 4
  store i32 %17, i32* %14, align 4
  ret void
}


define void @gather_load_3(i32* %0, i32* readonly %1) {
; CHECK-LABEL: @gather_load_3(
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1:%.*]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = add i32 [[TMP3]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP0:%.*]], i64 1
; CHECK-NEXT:    store i32 [[TMP4]], i32* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 11
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, i32* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = add i32 [[TMP7]], 2
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 2
; CHECK-NEXT:    store i32 [[TMP8]], i32* [[TMP5]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 4
; CHECK-NEXT:    [[TMP11:%.*]] = load i32, i32* [[TMP10]], align 4
; CHECK-NEXT:    [[TMP12:%.*]] = add i32 [[TMP11]], 3
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 3
; CHECK-NEXT:    store i32 [[TMP12]], i32* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 15
; CHECK-NEXT:    [[TMP15:%.*]] = load i32, i32* [[TMP14]], align 4
; CHECK-NEXT:    [[TMP16:%.*]] = add i32 [[TMP15]], 4
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 4
; CHECK-NEXT:    store i32 [[TMP16]], i32* [[TMP13]], align 4
; CHECK-NEXT:    [[TMP18:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 18
; CHECK-NEXT:    [[TMP19:%.*]] = load i32, i32* [[TMP18]], align 4
; CHECK-NEXT:    [[TMP20:%.*]] = add i32 [[TMP19]], 1
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 5
; CHECK-NEXT:    store i32 [[TMP20]], i32* [[TMP17]], align 4
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 9
; CHECK-NEXT:    [[TMP23:%.*]] = load i32, i32* [[TMP22]], align 4
; CHECK-NEXT:    [[TMP24:%.*]] = add i32 [[TMP23]], 2
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 6
; CHECK-NEXT:    store i32 [[TMP24]], i32* [[TMP21]], align 4
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 6
; CHECK-NEXT:    [[TMP27:%.*]] = load i32, i32* [[TMP26]], align 4
; CHECK-NEXT:    [[TMP28:%.*]] = add i32 [[TMP27]], 3
; CHECK-NEXT:    [[TMP29:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 7
; CHECK-NEXT:    store i32 [[TMP28]], i32* [[TMP25]], align 4
; CHECK-NEXT:    [[TMP30:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 21
; CHECK-NEXT:    [[TMP31:%.*]] = load i32, i32* [[TMP30]], align 4
; CHECK-NEXT:    [[TMP32:%.*]] = add i32 [[TMP31]], 4
; CHECK-NEXT:    store i32 [[TMP32]], i32* [[TMP29]], align 4
; CHECK-NEXT:    ret void
;
  %3 = load i32, i32* %1, align 4
  %4 = add i32 %3, 1
  %5 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 %4, i32* %0, align 4
  %6 = getelementptr inbounds i32, i32* %1, i64 11
  %7 = load i32, i32* %6, align 4
  %8 = add i32 %7, 2
  %9 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 %8, i32* %5, align 4
  %10 = getelementptr inbounds i32, i32* %1, i64 4
  %11 = load i32, i32* %10, align 4
  %12 = add i32 %11, 3
  %13 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 %12, i32* %9, align 4
  %14 = getelementptr inbounds i32, i32* %1, i64 15
  %15 = load i32, i32* %14, align 4
  %16 = add i32 %15, 4
  %17 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 %16, i32* %13, align 4
  %18 = getelementptr inbounds i32, i32* %1, i64 18
  %19 = load i32, i32* %18, align 4
  %20 = add i32 %19, 1
  %21 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 %20, i32* %17, align 4
  %22 = getelementptr inbounds i32, i32* %1, i64 9
  %23 = load i32, i32* %22, align 4
  %24 = add i32 %23, 2
  %25 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 %24, i32* %21, align 4
  %26 = getelementptr inbounds i32, i32* %1, i64 6
  %27 = load i32, i32* %26, align 4
  %28 = add i32 %27, 3
  %29 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 %28, i32* %25, align 4
  %30 = getelementptr inbounds i32, i32* %1, i64 21
  %31 = load i32, i32* %30, align 4
  %32 = add i32 %31, 4
  store i32 %32, i32* %29, align 4
  ret void
}

define void @gather_load_4(i32* %t0, i32* readonly %t1) {
; SSE-LABEL: @gather_load_4(
; SSE-NEXT:    [[T5:%.*]] = getelementptr inbounds i32, i32* [[T0:%.*]], i64 1
; SSE-NEXT:    [[T6:%.*]] = getelementptr inbounds i32, i32* [[T1:%.*]], i64 11
; SSE-NEXT:    [[T9:%.*]] = getelementptr inbounds i32, i32* [[T0]], i64 2
; SSE-NEXT:    [[T10:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 4
; SSE-NEXT:    [[T13:%.*]] = getelementptr inbounds i32, i32* [[T0]], i64 3
; SSE-NEXT:    [[T14:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 15
; SSE-NEXT:    [[T17:%.*]] = getelementptr inbounds i32, i32* [[T0]], i64 4
; SSE-NEXT:    [[T18:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 18
; SSE-NEXT:    [[T21:%.*]] = getelementptr inbounds i32, i32* [[T0]], i64 5
; SSE-NEXT:    [[T22:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 9
; SSE-NEXT:    [[T25:%.*]] = getelementptr inbounds i32, i32* [[T0]], i64 6
; SSE-NEXT:    [[T26:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 6
; SSE-NEXT:    [[T29:%.*]] = getelementptr inbounds i32, i32* [[T0]], i64 7
; SSE-NEXT:    [[T30:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 21
; SSE-NEXT:    [[T3:%.*]] = load i32, i32* [[T1]], align 4
; SSE-NEXT:    [[T7:%.*]] = load i32, i32* [[T6]], align 4
; SSE-NEXT:    [[T11:%.*]] = load i32, i32* [[T10]], align 4
; SSE-NEXT:    [[T15:%.*]] = load i32, i32* [[T14]], align 4
; SSE-NEXT:    [[T19:%.*]] = load i32, i32* [[T18]], align 4
; SSE-NEXT:    [[T23:%.*]] = load i32, i32* [[T22]], align 4
; SSE-NEXT:    [[T27:%.*]] = load i32, i32* [[T26]], align 4
; SSE-NEXT:    [[T31:%.*]] = load i32, i32* [[T30]], align 4
; SSE-NEXT:    [[T4:%.*]] = add i32 [[T3]], 1
; SSE-NEXT:    [[T8:%.*]] = add i32 [[T7]], 2
; SSE-NEXT:    [[T12:%.*]] = add i32 [[T11]], 3
; SSE-NEXT:    [[T16:%.*]] = add i32 [[T15]], 4
; SSE-NEXT:    [[T20:%.*]] = add i32 [[T19]], 1
; SSE-NEXT:    [[T24:%.*]] = add i32 [[T23]], 2
; SSE-NEXT:    [[T28:%.*]] = add i32 [[T27]], 3
; SSE-NEXT:    [[T32:%.*]] = add i32 [[T31]], 4
; SSE-NEXT:    store i32 [[T4]], i32* [[T0]], align 4
; SSE-NEXT:    store i32 [[T8]], i32* [[T5]], align 4
; SSE-NEXT:    store i32 [[T12]], i32* [[T9]], align 4
; SSE-NEXT:    store i32 [[T16]], i32* [[T13]], align 4
; SSE-NEXT:    store i32 [[T20]], i32* [[T17]], align 4
; SSE-NEXT:    store i32 [[T24]], i32* [[T21]], align 4
; SSE-NEXT:    store i32 [[T28]], i32* [[T25]], align 4
; SSE-NEXT:    store i32 [[T32]], i32* [[T29]], align 4
; SSE-NEXT:    ret void
;
; AVX-LABEL: @gather_load_4(
; AVX-NEXT:    [[T6:%.*]] = getelementptr inbounds i32, i32* [[T1:%.*]], i64 11
; AVX-NEXT:    [[T10:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 4
; AVX-NEXT:    [[T14:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 15
; AVX-NEXT:    [[T18:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 18
; AVX-NEXT:    [[T22:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 9
; AVX-NEXT:    [[T26:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 6
; AVX-NEXT:    [[T30:%.*]] = getelementptr inbounds i32, i32* [[T1]], i64 21
; AVX-NEXT:    [[T3:%.*]] = load i32, i32* [[T1]], align 4
; AVX-NEXT:    [[T7:%.*]] = load i32, i32* [[T6]], align 4
; AVX-NEXT:    [[T11:%.*]] = load i32, i32* [[T10]], align 4
; AVX-NEXT:    [[T15:%.*]] = load i32, i32* [[T14]], align 4
; AVX-NEXT:    [[T19:%.*]] = load i32, i32* [[T18]], align 4
; AVX-NEXT:    [[T23:%.*]] = load i32, i32* [[T22]], align 4
; AVX-NEXT:    [[T27:%.*]] = load i32, i32* [[T26]], align 4
; AVX-NEXT:    [[T31:%.*]] = load i32, i32* [[T30]], align 4
; AVX-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> undef, i32 [[T3]], i32 0
; AVX-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> [[TMP1]], i32 [[T7]], i32 1
; AVX-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[T11]], i32 2
; AVX-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[T15]], i32 3
; AVX-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[T19]], i32 4
; AVX-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[T23]], i32 5
; AVX-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[T27]], i32 6
; AVX-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[T31]], i32 7
; AVX-NEXT:    [[TMP9:%.*]] = add <8 x i32> [[TMP8]], <i32 1, i32 2, i32 3, i32 4, i32 1, i32 2, i32 3, i32 4>
; AVX-NEXT:    [[TMP10:%.*]] = bitcast i32* [[T0:%.*]] to <8 x i32>*
; AVX-NEXT:    store <8 x i32> [[TMP9]], <8 x i32>* [[TMP10]], align 4
; AVX-NEXT:    ret void
;
  %t5 = getelementptr inbounds i32, i32* %t0, i64 1
  %t6 = getelementptr inbounds i32, i32* %t1, i64 11
  %t9 = getelementptr inbounds i32, i32* %t0, i64 2
  %t10 = getelementptr inbounds i32, i32* %t1, i64 4
  %t13 = getelementptr inbounds i32, i32* %t0, i64 3
  %t14 = getelementptr inbounds i32, i32* %t1, i64 15
  %t17 = getelementptr inbounds i32, i32* %t0, i64 4
  %t18 = getelementptr inbounds i32, i32* %t1, i64 18
  %t21 = getelementptr inbounds i32, i32* %t0, i64 5
  %t22 = getelementptr inbounds i32, i32* %t1, i64 9
  %t25 = getelementptr inbounds i32, i32* %t0, i64 6
  %t26 = getelementptr inbounds i32, i32* %t1, i64 6
  %t29 = getelementptr inbounds i32, i32* %t0, i64 7
  %t30 = getelementptr inbounds i32, i32* %t1, i64 21

  %t3 = load i32, i32* %t1, align 4
  %t7 = load i32, i32* %t6, align 4
  %t11 = load i32, i32* %t10, align 4
  %t15 = load i32, i32* %t14, align 4
  %t19 = load i32, i32* %t18, align 4
  %t23 = load i32, i32* %t22, align 4
  %t27 = load i32, i32* %t26, align 4
  %t31 = load i32, i32* %t30, align 4

  %t4 = add i32 %t3, 1
  %t8 = add i32 %t7, 2
  %t12 = add i32 %t11, 3
  %t16 = add i32 %t15, 4
  %t20 = add i32 %t19, 1
  %t24 = add i32 %t23, 2
  %t28 = add i32 %t27, 3
  %t32 = add i32 %t31, 4

  store i32 %t4, i32* %t0, align 4
  store i32 %t8, i32* %t5, align 4
  store i32 %t12, i32* %t9, align 4
  store i32 %t16, i32* %t13, align 4
  store i32 %t20, i32* %t17, align 4
  store i32 %t24, i32* %t21, align 4
  store i32 %t28, i32* %t25, align 4
  store i32 %t32, i32* %t29, align 4

  ret void
}
