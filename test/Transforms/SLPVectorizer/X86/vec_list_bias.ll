; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -mtriple=x86_64-unknown-linux-gnu -mcpu=skylake -S | FileCheck %s

; Check no vectorization triggered with any portion of
; insertelement <8 x i32> instructions that build entire vector.
; Vectorization triggered by cost bias caused by subtracting
; the cost of entire "aggregate build" sequence while
; building vectorizable tree from only a portion of it.

define void @test(i32* nocapture %t2) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[T3:%.*]] = load i32, i32* [[T2:%.*]], align 4
; CHECK-NEXT:    [[T4:%.*]] = getelementptr inbounds i32, i32* [[T2]], i64 7
; CHECK-NEXT:    [[T5:%.*]] = load i32, i32* [[T4]], align 4
; CHECK-NEXT:    [[T8:%.*]] = getelementptr inbounds i32, i32* [[T2]], i64 1
; CHECK-NEXT:    [[T9:%.*]] = load i32, i32* [[T8]], align 4
; CHECK-NEXT:    [[T10:%.*]] = getelementptr inbounds i32, i32* [[T2]], i64 6
; CHECK-NEXT:    [[T11:%.*]] = load i32, i32* [[T10]], align 4
; CHECK-NEXT:    [[T14:%.*]] = getelementptr inbounds i32, i32* [[T2]], i64 2
; CHECK-NEXT:    [[T15:%.*]] = load i32, i32* [[T14]], align 4
; CHECK-NEXT:    [[T16:%.*]] = getelementptr inbounds i32, i32* [[T2]], i64 5
; CHECK-NEXT:    [[T17:%.*]] = load i32, i32* [[T16]], align 4
; CHECK-NEXT:    [[T20:%.*]] = getelementptr inbounds i32, i32* [[T2]], i64 3
; CHECK-NEXT:    [[T21:%.*]] = load i32, i32* [[T20]], align 4
; CHECK-NEXT:    [[T22:%.*]] = getelementptr inbounds i32, i32* [[T2]], i64 4
; CHECK-NEXT:    [[T23:%.*]] = load i32, i32* [[T22]], align 4
; CHECK-NEXT:    [[T24:%.*]] = add nsw i32 [[T23]], [[T21]]
; CHECK-NEXT:    [[T25:%.*]] = sub nsw i32 [[T21]], [[T23]]
; CHECK-NEXT:    [[T27:%.*]] = sub nsw i32 [[T3]], [[T24]]
; CHECK-NEXT:    [[T29:%.*]] = sub nsw i32 [[T9]], [[T15]]
; CHECK-NEXT:    [[T30:%.*]] = add nsw i32 [[T27]], [[T29]]
; CHECK-NEXT:    [[T31:%.*]] = mul nsw i32 [[T30]], 4433
; CHECK-NEXT:    [[T34:%.*]] = mul nsw i32 [[T29]], -15137
; CHECK-NEXT:    [[T37:%.*]] = add nsw i32 [[T25]], [[T11]]
; CHECK-NEXT:    [[T38:%.*]] = add nsw i32 [[T17]], [[T5]]
; CHECK-NEXT:    [[T39:%.*]] = add nsw i32 [[T37]], [[T38]]
; CHECK-NEXT:    [[T40:%.*]] = mul nsw i32 [[T39]], 9633
; CHECK-NEXT:    [[T41:%.*]] = mul nsw i32 [[T25]], 2446
; CHECK-NEXT:    [[T42:%.*]] = mul nsw i32 [[T17]], 16819
; CHECK-NEXT:    [[T47:%.*]] = mul nsw i32 [[T37]], -16069
; CHECK-NEXT:    [[T48:%.*]] = mul nsw i32 [[T38]], -3196
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i32> poison, i32 [[T15]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i32> [[TMP1]], i32 [[T40]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i32> [[TMP2]], i32 [[T27]], i32 2
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x i32> [[TMP3]], i32 [[T47]], i32 3
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x i32> <i32 poison, i32 poison, i32 6270, i32 poison>, i32 [[T9]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x i32> [[TMP5]], i32 [[T48]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x i32> [[TMP6]], i32 [[T40]], i32 3
; CHECK-NEXT:    [[TMP8:%.*]] = add nsw <4 x i32> [[TMP4]], [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = mul nsw <4 x i32> [[TMP4]], [[TMP7]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> [[TMP9]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x i32> [[TMP10]], <4 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 undef, i32 3>
; CHECK-NEXT:    [[T71:%.*]] = insertelement <8 x i32> [[TMP11]], i32 [[T34]], i32 6
; CHECK-NEXT:    [[T76:%.*]] = shl <8 x i32> [[T71]], <i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3>
; CHECK-NEXT:    [[T79:%.*]] = bitcast i32* [[T2]] to <8 x i32>*
; CHECK-NEXT:    store <8 x i32> [[T76]], <8 x i32>* [[T79]], align 4
; CHECK-NEXT:    ret void
;
  %t3 = load i32, i32* %t2, align 4
  %t4 = getelementptr inbounds i32, i32* %t2, i64 7
  %t5 = load i32, i32* %t4, align 4
  %t8 = getelementptr inbounds i32, i32* %t2, i64 1
  %t9 = load i32, i32* %t8, align 4
  %t10 = getelementptr inbounds i32, i32* %t2, i64 6
  %t11 = load i32, i32* %t10, align 4
  %t14 = getelementptr inbounds i32, i32* %t2, i64 2
  %t15 = load i32, i32* %t14, align 4
  %t16 = getelementptr inbounds i32, i32* %t2, i64 5
  %t17 = load i32, i32* %t16, align 4
  %t20 = getelementptr inbounds i32, i32* %t2, i64 3
  %t21 = load i32, i32* %t20, align 4
  %t22 = getelementptr inbounds i32, i32* %t2, i64 4
  %t23 = load i32, i32* %t22, align 4
  %t24 = add nsw i32 %t23, %t21
  %t25 = sub nsw i32 %t21, %t23
  %t27 = sub nsw i32 %t3, %t24
  %t28 = add nsw i32 %t15, %t9
  %t29 = sub nsw i32 %t9, %t15
  %t30 = add nsw i32 %t27, %t29
  %t31 = mul nsw i32 %t30, 4433
  %t32 = mul nsw i32 %t27, 6270
  %t34 = mul nsw i32 %t29, -15137
  %t37 = add nsw i32 %t25, %t11
  %t38 = add nsw i32 %t17, %t5
  %t39 = add nsw i32 %t37, %t38
  %t40 = mul nsw i32 %t39, 9633
  %t41 = mul nsw i32 %t25, 2446
  %t42 = mul nsw i32 %t17, 16819
  %t47 = mul nsw i32 %t37, -16069
  %t48 = mul nsw i32 %t38, -3196
  %t49 = add nsw i32 %t40, %t47
  %t50 = add nsw i32 %t40, %t48
  %t65 = insertelement <8 x i32> undef, i32 %t28, i32 0
  %t66 = insertelement <8 x i32> %t65, i32 %t50, i32 1
  %t67 = insertelement <8 x i32> %t66, i32 %t32, i32 2
  %t68 = insertelement <8 x i32> %t67, i32 %t49, i32 3
  %t69 = insertelement <8 x i32> %t68, i32 %t28, i32 4
  %t70 = insertelement <8 x i32> %t69, i32 %t50, i32 5
  %t71 = insertelement <8 x i32> %t70, i32 %t34, i32 6
  %t72 = insertelement <8 x i32> %t71, i32 %t49, i32 7
  %t76 = shl <8 x i32> %t72, <i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3>
  %t79 = bitcast i32* %t2 to <8 x i32>*
  store <8 x i32> %t76, <8 x i32>* %t79, align 4
  ret void
}
