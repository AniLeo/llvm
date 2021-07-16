; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu -mcpu=bdver2 < %s | FileCheck %s

%"struct.std::array" = type { [32 x i8] }

; Function Attrs: nounwind uwtable
define fastcc void @_ZN12_GLOBAL__N_127PolynomialMultiplyRecognize9recognizeEv() unnamed_addr #0 align 2 {
; CHECK-LABEL: @_ZN12_GLOBAL__N_127PolynomialMultiplyRecognize9recognizeEv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[IF_END50_I:%.*]], label [[IF_THEN22_I:%.*]]
; CHECK:       if.then22.i:
; CHECK-NEXT:    [[SUB_I:%.*]] = add nsw i32 undef, -1
; CHECK-NEXT:    [[CONV31_I:%.*]] = and i32 undef, [[SUB_I]]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 0
; CHECK-NEXT:    [[ARRAYIDX_I_I7_1_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 1
; CHECK-NEXT:    [[ARRAYIDX_I_I7_2_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 2
; CHECK-NEXT:    [[ARRAYIDX_I_I7_3_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i32> poison, i32 [[CONV31_I]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i32> [[TMP1]], i32 [[CONV31_I]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i32> [[TMP2]], i32 [[CONV31_I]], i32 2
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x i32> [[TMP3]], i32 [[CONV31_I]], i32 3
; CHECK-NEXT:    [[TMP5:%.*]] = lshr <4 x i32> [[TMP4]], <i32 1, i32 2, i32 3, i32 4>
; CHECK-NEXT:    [[ARRAYIDX_I_I7_4_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 4
; CHECK-NEXT:    [[SHR_4_I_I:%.*]] = lshr i32 [[CONV31_I]], 5
; CHECK-NEXT:    [[ARRAYIDX_I_I7_5_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 5
; CHECK-NEXT:    [[ARRAYIDX_I_I7_6_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 6
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i32> poison, i32 [[CONV31_I]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <2 x i32> [[TMP6]], i32 [[CONV31_I]], i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = lshr <2 x i32> [[TMP7]], <i32 6, i32 7>
; CHECK-NEXT:    [[ARRAYIDX_I_I7_7_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 7
; CHECK-NEXT:    [[ARRAYIDX_I_I7_8_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 8
; CHECK-NEXT:    [[ARRAYIDX_I_I7_9_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 9
; CHECK-NEXT:    [[ARRAYIDX_I_I7_10_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 10
; CHECK-NEXT:    [[TMP9:%.*]] = lshr <4 x i32> [[TMP4]], <i32 8, i32 9, i32 10, i32 11>
; CHECK-NEXT:    [[ARRAYIDX_I_I7_11_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 11
; CHECK-NEXT:    [[ARRAYIDX_I_I7_12_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 12
; CHECK-NEXT:    [[ARRAYIDX_I_I7_13_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 13
; CHECK-NEXT:    [[ARRAYIDX_I_I7_14_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 14
; CHECK-NEXT:    [[TMP10:%.*]] = lshr <4 x i32> [[TMP4]], <i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x i32> [[TMP10]], i32 3
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <16 x i32> poison, i32 [[SUB_I]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x i32> [[TMP5]], <4 x i32> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <16 x i32> [[TMP12]], <16 x i32> [[TMP13]], <16 x i32> <i32 0, i32 16, i32 17, i32 18, i32 19, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <16 x i32> [[TMP14]], i32 [[SHR_4_I_I]], i32 5
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <2 x i32> [[TMP8]], <2 x i32> poison, <16 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <16 x i32> [[TMP15]], <16 x i32> [[TMP16]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 16, i32 17, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <4 x i32> [[TMP9]], <4 x i32> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <16 x i32> [[TMP17]], <16 x i32> [[TMP18]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <4 x i32> [[TMP10]], <4 x i32> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP21:%.*]] = shufflevector <16 x i32> [[TMP19]], <16 x i32> [[TMP20]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
; CHECK-NEXT:    [[TMP22:%.*]] = trunc <16 x i32> [[TMP21]] to <16 x i8>
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <4 x i32> [[TMP10]], i32 2
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <4 x i32> [[TMP10]], i32 1
; CHECK-NEXT:    [[TMP25:%.*]] = extractelement <4 x i32> [[TMP10]], i32 0
; CHECK-NEXT:    [[TMP26:%.*]] = extractelement <4 x i32> [[TMP9]], i32 3
; CHECK-NEXT:    [[TMP27:%.*]] = extractelement <4 x i32> [[TMP9]], i32 2
; CHECK-NEXT:    [[TMP28:%.*]] = extractelement <4 x i32> [[TMP9]], i32 1
; CHECK-NEXT:    [[TMP29:%.*]] = extractelement <4 x i32> [[TMP9]], i32 0
; CHECK-NEXT:    [[TMP30:%.*]] = extractelement <2 x i32> [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP31:%.*]] = extractelement <2 x i32> [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP32:%.*]] = extractelement <4 x i32> [[TMP5]], i32 3
; CHECK-NEXT:    [[TMP33:%.*]] = extractelement <4 x i32> [[TMP5]], i32 2
; CHECK-NEXT:    [[TMP34:%.*]] = extractelement <4 x i32> [[TMP5]], i32 1
; CHECK-NEXT:    [[TMP35:%.*]] = extractelement <4 x i32> [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP36:%.*]] = and <16 x i8> [[TMP22]], <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
; CHECK-NEXT:    [[ARRAYIDX_I_I7_15_I_I:%.*]] = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 15
; CHECK-NEXT:    [[TMP37:%.*]] = bitcast i8* [[TMP0]] to <16 x i8>*
; CHECK-NEXT:    store <16 x i8> [[TMP36]], <16 x i8>* [[TMP37]], align 1
; CHECK-NEXT:    unreachable
; CHECK:       if.end50.i:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %if.end50.i, label %if.then22.i

if.then22.i:                                      ; preds = %entry
  %sub.i = add nsw i32 undef, -1
  %conv31.i = and i32 undef, %sub.i
  %0 = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 0
  %1 = trunc i32 %sub.i to i8
  %conv.i.i1199 = and i8 %1, 1
  store i8 %conv.i.i1199, i8* %0, align 1
  %shr.i.i = lshr i32 %conv31.i, 1
  %2 = trunc i32 %shr.i.i to i8
  %conv.1.i.i = and i8 %2, 1
  %arrayidx.i.i7.1.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 1
  store i8 %conv.1.i.i, i8* %arrayidx.i.i7.1.i.i, align 1
  %shr.1.i.i = lshr i32 %conv31.i, 2
  %3 = trunc i32 %shr.1.i.i to i8
  %conv.2.i.i = and i8 %3, 1
  %arrayidx.i.i7.2.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 2
  store i8 %conv.2.i.i, i8* %arrayidx.i.i7.2.i.i, align 1
  %shr.2.i.i = lshr i32 %conv31.i, 3
  %4 = trunc i32 %shr.2.i.i to i8
  %conv.3.i.i = and i8 %4, 1
  %arrayidx.i.i7.3.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 3
  store i8 %conv.3.i.i, i8* %arrayidx.i.i7.3.i.i, align 1
  %shr.3.i.i = lshr i32 %conv31.i, 4
  %5 = trunc i32 %shr.3.i.i to i8
  %conv.4.i.i = and i8 %5, 1
  %arrayidx.i.i7.4.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 4
  store i8 %conv.4.i.i, i8* %arrayidx.i.i7.4.i.i, align 1
  %shr.4.i.i = lshr i32 %conv31.i, 5
  %6 = trunc i32 %shr.4.i.i to i8
  %conv.5.i.i = and i8 %6, 1
  %arrayidx.i.i7.5.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 5
  store i8 %conv.5.i.i, i8* %arrayidx.i.i7.5.i.i, align 1
  %shr.5.i.i = lshr i32 %conv31.i, 6
  %7 = trunc i32 %shr.5.i.i to i8
  %conv.6.i.i = and i8 %7, 1
  %arrayidx.i.i7.6.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 6
  store i8 %conv.6.i.i, i8* %arrayidx.i.i7.6.i.i, align 1
  %shr.6.i.i = lshr i32 %conv31.i, 7
  %8 = trunc i32 %shr.6.i.i to i8
  %conv.7.i.i = and i8 %8, 1
  %arrayidx.i.i7.7.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 7
  store i8 %conv.7.i.i, i8* %arrayidx.i.i7.7.i.i, align 1
  %shr.7.i.i = lshr i32 %conv31.i, 8
  %9 = trunc i32 %shr.7.i.i to i8
  %conv.8.i.i = and i8 %9, 1
  %arrayidx.i.i7.8.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 8
  store i8 %conv.8.i.i, i8* %arrayidx.i.i7.8.i.i, align 1
  %shr.8.i.i = lshr i32 %conv31.i, 9
  %10 = trunc i32 %shr.8.i.i to i8
  %conv.9.i.i = and i8 %10, 1
  %arrayidx.i.i7.9.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 9
  store i8 %conv.9.i.i, i8* %arrayidx.i.i7.9.i.i, align 1
  %shr.9.i.i = lshr i32 %conv31.i, 10
  %11 = trunc i32 %shr.9.i.i to i8
  %conv.10.i.i = and i8 %11, 1
  %arrayidx.i.i7.10.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 10
  store i8 %conv.10.i.i, i8* %arrayidx.i.i7.10.i.i, align 1
  %shr.10.i.i = lshr i32 %conv31.i, 11
  %12 = trunc i32 %shr.10.i.i to i8
  %conv.11.i.i = and i8 %12, 1
  %arrayidx.i.i7.11.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 11
  store i8 %conv.11.i.i, i8* %arrayidx.i.i7.11.i.i, align 1
  %shr.11.i.i = lshr i32 %conv31.i, 12
  %13 = trunc i32 %shr.11.i.i to i8
  %conv.12.i.i = and i8 %13, 1
  %arrayidx.i.i7.12.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 12
  store i8 %conv.12.i.i, i8* %arrayidx.i.i7.12.i.i, align 1
  %shr.12.i.i = lshr i32 %conv31.i, 13
  %14 = trunc i32 %shr.12.i.i to i8
  %conv.13.i.i = and i8 %14, 1
  %arrayidx.i.i7.13.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 13
  store i8 %conv.13.i.i, i8* %arrayidx.i.i7.13.i.i, align 1
  %shr.13.i.i = lshr i32 %conv31.i, 14
  %15 = trunc i32 %shr.13.i.i to i8
  %conv.14.i.i = and i8 %15, 1
  %arrayidx.i.i7.14.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 14
  store i8 %conv.14.i.i, i8* %arrayidx.i.i7.14.i.i, align 1
  %shr.14.i.i = lshr i32 %conv31.i, 15
  %16 = trunc i32 %shr.14.i.i to i8
  %conv.15.i.i = and i8 %16, 1
  %arrayidx.i.i7.15.i.i = getelementptr inbounds %"struct.std::array", %"struct.std::array"* undef, i64 0, i32 0, i64 15
  store i8 %conv.15.i.i, i8* %arrayidx.i.i7.15.i.i, align 1
  unreachable

if.end50.i:                                       ; preds = %entry
  ret void
}
