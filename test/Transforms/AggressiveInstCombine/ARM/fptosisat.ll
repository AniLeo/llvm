; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=aggressive-instcombine -mtriple thumbv8.1m.main-none-eabi -S | FileCheck %s --check-prefixes=CHECK,CHECK-BASE
; RUN: opt < %s -passes=aggressive-instcombine -mtriple thumbv8.1m.main-none-eabi -mattr=+mve.fp -S | FileCheck %s --check-prefixes=CHECK,CHECK-MVEFP
; RUN: opt < %s -passes=aggressive-instcombine -mtriple thumbv8.1m.main-none-eabi -mattr=+mve.fp,+fp64 -S | FileCheck %s --check-prefixes=CHECK,CHECK-FP64

define i64 @f32_i32(float %in) {
; CHECK-BASE-LABEL: @f32_i32(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi float [[IN:%.*]] to i64
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call i64 @llvm.smin.i64(i64 [[CONV]], i64 2147483647)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call i64 @llvm.smax.i64(i64 [[MIN]], i64 -2147483648)
; CHECK-BASE-NEXT:    ret i64 [[MAX]]
;
; CHECK-MVEFP-LABEL: @f32_i32(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call i32 @llvm.fptosi.sat.i32.f32(float [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; CHECK-MVEFP-NEXT:    ret i64 [[TMP2]]
;
; CHECK-FP64-LABEL: @f32_i32(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call i32 @llvm.fptosi.sat.i32.f32(float [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; CHECK-FP64-NEXT:    ret i64 [[TMP2]]
;
  %conv = fptosi float %in to i64
  %min = call i64 @llvm.smin.i64(i64 %conv, i64 2147483647)
  %max = call i64 @llvm.smax.i64(i64 %min, i64 -2147483648)
  ret i64 %max
}

define i64 @f32_i31(float %in) {
; CHECK-BASE-LABEL: @f32_i31(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi float [[IN:%.*]] to i64
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call i64 @llvm.smin.i64(i64 [[CONV]], i64 1073741823)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call i64 @llvm.smax.i64(i64 [[MIN]], i64 -1073741824)
; CHECK-BASE-NEXT:    ret i64 [[MAX]]
;
; CHECK-MVEFP-LABEL: @f32_i31(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call i31 @llvm.fptosi.sat.i31.f32(float [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext i31 [[TMP1]] to i64
; CHECK-MVEFP-NEXT:    ret i64 [[TMP2]]
;
; CHECK-FP64-LABEL: @f32_i31(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call i31 @llvm.fptosi.sat.i31.f32(float [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext i31 [[TMP1]] to i64
; CHECK-FP64-NEXT:    ret i64 [[TMP2]]
;
  %conv = fptosi float %in to i64
  %min = call i64 @llvm.smin.i64(i64 %conv, i64 1073741823)
  %max = call i64 @llvm.smax.i64(i64 %min, i64 -1073741824)
  ret i64 %max
}

define i32 @f32_i16(float %in) {
; CHECK-LABEL: @f32_i16(
; CHECK-NEXT:    [[CONV:%.*]] = fptosi float [[IN:%.*]] to i32
; CHECK-NEXT:    [[MIN:%.*]] = call i32 @llvm.smin.i32(i32 [[CONV]], i32 32767)
; CHECK-NEXT:    [[MAX:%.*]] = call i32 @llvm.smax.i32(i32 [[MIN]], i32 -32768)
; CHECK-NEXT:    ret i32 [[MAX]]
;
  %conv = fptosi float %in to i32
  %min = call i32 @llvm.smin.i32(i32 %conv, i32 32767)
  %max = call i32 @llvm.smax.i32(i32 %min, i32 -32768)
  ret i32 %max
}

define i32 @f32_i8(float %in) {
; CHECK-LABEL: @f32_i8(
; CHECK-NEXT:    [[CONV:%.*]] = fptosi float [[IN:%.*]] to i32
; CHECK-NEXT:    [[MIN:%.*]] = call i32 @llvm.smin.i32(i32 [[CONV]], i32 127)
; CHECK-NEXT:    [[MAX:%.*]] = call i32 @llvm.smax.i32(i32 [[MIN]], i32 -128)
; CHECK-NEXT:    ret i32 [[MAX]]
;
  %conv = fptosi float %in to i32
  %min = call i32 @llvm.smin.i32(i32 %conv, i32 127)
  %max = call i32 @llvm.smax.i32(i32 %min, i32 -128)
  ret i32 %max
}

define i64 @f64_i32(double %in) {
; CHECK-BASE-LABEL: @f64_i32(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi double [[IN:%.*]] to i64
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call i64 @llvm.smin.i64(i64 [[CONV]], i64 2147483647)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call i64 @llvm.smax.i64(i64 [[MIN]], i64 -2147483648)
; CHECK-BASE-NEXT:    ret i64 [[MAX]]
;
; CHECK-MVEFP-LABEL: @f64_i32(
; CHECK-MVEFP-NEXT:    [[CONV:%.*]] = fptosi double [[IN:%.*]] to i64
; CHECK-MVEFP-NEXT:    [[MIN:%.*]] = call i64 @llvm.smin.i64(i64 [[CONV]], i64 2147483647)
; CHECK-MVEFP-NEXT:    [[MAX:%.*]] = call i64 @llvm.smax.i64(i64 [[MIN]], i64 -2147483648)
; CHECK-MVEFP-NEXT:    ret i64 [[MAX]]
;
; CHECK-FP64-LABEL: @f64_i32(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call i32 @llvm.fptosi.sat.i32.f64(double [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; CHECK-FP64-NEXT:    ret i64 [[TMP2]]
;
  %conv = fptosi double %in to i64
  %min = call i64 @llvm.smin.i64(i64 %conv, i64 2147483647)
  %max = call i64 @llvm.smax.i64(i64 %min, i64 -2147483648)
  ret i64 %max
}

define i64 @f64_i31(double %in) {
; CHECK-LABEL: @f64_i31(
; CHECK-NEXT:    [[CONV:%.*]] = fptosi double [[IN:%.*]] to i64
; CHECK-NEXT:    [[MIN:%.*]] = call i64 @llvm.smin.i64(i64 [[CONV]], i64 1073741823)
; CHECK-NEXT:    [[MAX:%.*]] = call i64 @llvm.smax.i64(i64 [[MIN]], i64 -1073741824)
; CHECK-NEXT:    ret i64 [[MAX]]
;
  %conv = fptosi double %in to i64
  %min = call i64 @llvm.smin.i64(i64 %conv, i64 1073741823)
  %max = call i64 @llvm.smax.i64(i64 %min, i64 -1073741824)
  ret i64 %max
}

define i32 @f64_i16(double %in) {
; CHECK-LABEL: @f64_i16(
; CHECK-NEXT:    [[CONV:%.*]] = fptosi double [[IN:%.*]] to i32
; CHECK-NEXT:    [[MIN:%.*]] = call i32 @llvm.smin.i32(i32 [[CONV]], i32 32767)
; CHECK-NEXT:    [[MAX:%.*]] = call i32 @llvm.smax.i32(i32 [[MIN]], i32 -32768)
; CHECK-NEXT:    ret i32 [[MAX]]
;
  %conv = fptosi double %in to i32
  %min = call i32 @llvm.smin.i32(i32 %conv, i32 32767)
  %max = call i32 @llvm.smax.i32(i32 %min, i32 -32768)
  ret i32 %max
}

define i64 @f16_i32(half %in) {
; CHECK-BASE-LABEL: @f16_i32(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi half [[IN:%.*]] to i64
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call i64 @llvm.smin.i64(i64 [[CONV]], i64 2147483647)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call i64 @llvm.smax.i64(i64 [[MIN]], i64 -2147483648)
; CHECK-BASE-NEXT:    ret i64 [[MAX]]
;
; CHECK-MVEFP-LABEL: @f16_i32(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call i32 @llvm.fptosi.sat.i32.f16(half [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; CHECK-MVEFP-NEXT:    ret i64 [[TMP2]]
;
; CHECK-FP64-LABEL: @f16_i32(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call i32 @llvm.fptosi.sat.i32.f16(half [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; CHECK-FP64-NEXT:    ret i64 [[TMP2]]
;
  %conv = fptosi half %in to i64
  %min = call i64 @llvm.smin.i64(i64 %conv, i64 2147483647)
  %max = call i64 @llvm.smax.i64(i64 %min, i64 -2147483648)
  ret i64 %max
}

define i64 @f16_i31(half %in) {
; CHECK-BASE-LABEL: @f16_i31(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi half [[IN:%.*]] to i64
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call i64 @llvm.smin.i64(i64 [[CONV]], i64 1073741823)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call i64 @llvm.smax.i64(i64 [[MIN]], i64 -1073741824)
; CHECK-BASE-NEXT:    ret i64 [[MAX]]
;
; CHECK-MVEFP-LABEL: @f16_i31(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call i31 @llvm.fptosi.sat.i31.f16(half [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext i31 [[TMP1]] to i64
; CHECK-MVEFP-NEXT:    ret i64 [[TMP2]]
;
; CHECK-FP64-LABEL: @f16_i31(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call i31 @llvm.fptosi.sat.i31.f16(half [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext i31 [[TMP1]] to i64
; CHECK-FP64-NEXT:    ret i64 [[TMP2]]
;
  %conv = fptosi half %in to i64
  %min = call i64 @llvm.smin.i64(i64 %conv, i64 1073741823)
  %max = call i64 @llvm.smax.i64(i64 %min, i64 -1073741824)
  ret i64 %max
}

define i32 @f16_i16(half %in) {
; CHECK-LABEL: @f16_i16(
; CHECK-NEXT:    [[CONV:%.*]] = fptosi half [[IN:%.*]] to i32
; CHECK-NEXT:    [[MIN:%.*]] = call i32 @llvm.smin.i32(i32 [[CONV]], i32 32767)
; CHECK-NEXT:    [[MAX:%.*]] = call i32 @llvm.smax.i32(i32 [[MIN]], i32 -32768)
; CHECK-NEXT:    ret i32 [[MAX]]
;
  %conv = fptosi half %in to i32
  %min = call i32 @llvm.smin.i32(i32 %conv, i32 32767)
  %max = call i32 @llvm.smax.i32(i32 %min, i32 -32768)
  ret i32 %max
}

define i32 @f16_i8(half %in) {
; CHECK-LABEL: @f16_i8(
; CHECK-NEXT:    [[CONV:%.*]] = fptosi half [[IN:%.*]] to i32
; CHECK-NEXT:    [[MIN:%.*]] = call i32 @llvm.smin.i32(i32 [[CONV]], i32 127)
; CHECK-NEXT:    [[MAX:%.*]] = call i32 @llvm.smax.i32(i32 [[MIN]], i32 -128)
; CHECK-NEXT:    ret i32 [[MAX]]
;
  %conv = fptosi half %in to i32
  %min = call i32 @llvm.smin.i32(i32 %conv, i32 127)
  %max = call i32 @llvm.smax.i32(i32 %min, i32 -128)
  ret i32 %max
}

define <2 x i64> @v2f32_i32(<2 x float> %in) {
; CHECK-BASE-LABEL: @v2f32_i32(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi <2 x float> [[IN:%.*]] to <2 x i64>
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call <2 x i64> @llvm.smin.v2i64(<2 x i64> [[CONV]], <2 x i64> <i64 2147483647, i64 2147483647>)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call <2 x i64> @llvm.smax.v2i64(<2 x i64> [[MIN]], <2 x i64> <i64 -2147483648, i64 -2147483648>)
; CHECK-BASE-NEXT:    ret <2 x i64> [[MAX]]
;
; CHECK-MVEFP-LABEL: @v2f32_i32(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.fptosi.sat.v2i32.v2f32(<2 x float> [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext <2 x i32> [[TMP1]] to <2 x i64>
; CHECK-MVEFP-NEXT:    ret <2 x i64> [[TMP2]]
;
; CHECK-FP64-LABEL: @v2f32_i32(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.fptosi.sat.v2i32.v2f32(<2 x float> [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext <2 x i32> [[TMP1]] to <2 x i64>
; CHECK-FP64-NEXT:    ret <2 x i64> [[TMP2]]
;
  %conv = fptosi <2 x float> %in to <2 x i64>
  %min = call <2 x i64> @llvm.smin.v2i64(<2 x i64> %conv, <2 x i64> <i64 2147483647, i64 2147483647>)
  %max = call <2 x i64> @llvm.smax.v2i64(<2 x i64> %min, <2 x i64> <i64 -2147483648, i64 -2147483648>)
  ret <2 x i64> %max
}

define <4 x i64> @v4f32_i32(<4 x float> %in) {
; CHECK-BASE-LABEL: @v4f32_i32(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi <4 x float> [[IN:%.*]] to <4 x i64>
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call <4 x i64> @llvm.smin.v4i64(<4 x i64> [[CONV]], <4 x i64> <i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647>)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call <4 x i64> @llvm.smax.v4i64(<4 x i64> [[MIN]], <4 x i64> <i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648>)
; CHECK-BASE-NEXT:    ret <4 x i64> [[MAX]]
;
; CHECK-MVEFP-LABEL: @v4f32_i32(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.fptosi.sat.v4i32.v4f32(<4 x float> [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext <4 x i32> [[TMP1]] to <4 x i64>
; CHECK-MVEFP-NEXT:    ret <4 x i64> [[TMP2]]
;
; CHECK-FP64-LABEL: @v4f32_i32(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.fptosi.sat.v4i32.v4f32(<4 x float> [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext <4 x i32> [[TMP1]] to <4 x i64>
; CHECK-FP64-NEXT:    ret <4 x i64> [[TMP2]]
;
  %conv = fptosi <4 x float> %in to <4 x i64>
  %min = call <4 x i64> @llvm.smin.v4i64(<4 x i64> %conv, <4 x i64> <i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647>)
  %max = call <4 x i64> @llvm.smax.v4i64(<4 x i64> %min, <4 x i64> <i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648>)
  ret <4 x i64> %max
}

define <8 x i64> @v8f32_i32(<8 x float> %in) {
; CHECK-BASE-LABEL: @v8f32_i32(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi <8 x float> [[IN:%.*]] to <8 x i64>
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call <8 x i64> @llvm.smin.v8i64(<8 x i64> [[CONV]], <8 x i64> <i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647>)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call <8 x i64> @llvm.smax.v8i64(<8 x i64> [[MIN]], <8 x i64> <i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648>)
; CHECK-BASE-NEXT:    ret <8 x i64> [[MAX]]
;
; CHECK-MVEFP-LABEL: @v8f32_i32(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call <8 x i32> @llvm.fptosi.sat.v8i32.v8f32(<8 x float> [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext <8 x i32> [[TMP1]] to <8 x i64>
; CHECK-MVEFP-NEXT:    ret <8 x i64> [[TMP2]]
;
; CHECK-FP64-LABEL: @v8f32_i32(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call <8 x i32> @llvm.fptosi.sat.v8i32.v8f32(<8 x float> [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext <8 x i32> [[TMP1]] to <8 x i64>
; CHECK-FP64-NEXT:    ret <8 x i64> [[TMP2]]
;
  %conv = fptosi <8 x float> %in to <8 x i64>
  %min = call <8 x i64> @llvm.smin.v8i64(<8 x i64> %conv, <8 x i64> <i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647, i64 2147483647>)
  %max = call <8 x i64> @llvm.smax.v8i64(<8 x i64> %min, <8 x i64> <i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648, i64 -2147483648>)
  ret <8 x i64> %max
}

define <4 x i32> @v4f16_i16(<4 x half> %in) {
; CHECK-BASE-LABEL: @v4f16_i16(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi <4 x half> [[IN:%.*]] to <4 x i32>
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call <4 x i32> @llvm.smin.v4i32(<4 x i32> [[CONV]], <4 x i32> <i32 32767, i32 32767, i32 32767, i32 32767>)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call <4 x i32> @llvm.smax.v4i32(<4 x i32> [[MIN]], <4 x i32> <i32 -32768, i32 -32768, i32 -32768, i32 -32768>)
; CHECK-BASE-NEXT:    ret <4 x i32> [[MAX]]
;
; CHECK-MVEFP-LABEL: @v4f16_i16(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call <4 x i16> @llvm.fptosi.sat.v4i16.v4f16(<4 x half> [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext <4 x i16> [[TMP1]] to <4 x i32>
; CHECK-MVEFP-NEXT:    ret <4 x i32> [[TMP2]]
;
; CHECK-FP64-LABEL: @v4f16_i16(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call <4 x i16> @llvm.fptosi.sat.v4i16.v4f16(<4 x half> [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext <4 x i16> [[TMP1]] to <4 x i32>
; CHECK-FP64-NEXT:    ret <4 x i32> [[TMP2]]
;
  %conv = fptosi <4 x half> %in to <4 x i32>
  %min = call <4 x i32> @llvm.smin.v4i32(<4 x i32> %conv, <4 x i32> <i32 32767, i32 32767, i32 32767, i32 32767>)
  %max = call <4 x i32> @llvm.smax.v4i32(<4 x i32> %min, <4 x i32> <i32 -32768, i32 -32768, i32 -32768, i32 -32768>)
  ret <4 x i32> %max
}

define <8 x i32> @v8f16_i16(<8 x half> %in) {
; CHECK-BASE-LABEL: @v8f16_i16(
; CHECK-BASE-NEXT:    [[CONV:%.*]] = fptosi <8 x half> [[IN:%.*]] to <8 x i32>
; CHECK-BASE-NEXT:    [[MIN:%.*]] = call <8 x i32> @llvm.smin.v8i32(<8 x i32> [[CONV]], <8 x i32> <i32 32767, i32 32767, i32 32767, i32 32767, i32 32767, i32 32767, i32 32767, i32 32767>)
; CHECK-BASE-NEXT:    [[MAX:%.*]] = call <8 x i32> @llvm.smax.v8i32(<8 x i32> [[MIN]], <8 x i32> <i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768>)
; CHECK-BASE-NEXT:    ret <8 x i32> [[MAX]]
;
; CHECK-MVEFP-LABEL: @v8f16_i16(
; CHECK-MVEFP-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.fptosi.sat.v8i16.v8f16(<8 x half> [[IN:%.*]])
; CHECK-MVEFP-NEXT:    [[TMP2:%.*]] = sext <8 x i16> [[TMP1]] to <8 x i32>
; CHECK-MVEFP-NEXT:    ret <8 x i32> [[TMP2]]
;
; CHECK-FP64-LABEL: @v8f16_i16(
; CHECK-FP64-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.fptosi.sat.v8i16.v8f16(<8 x half> [[IN:%.*]])
; CHECK-FP64-NEXT:    [[TMP2:%.*]] = sext <8 x i16> [[TMP1]] to <8 x i32>
; CHECK-FP64-NEXT:    ret <8 x i32> [[TMP2]]
;
  %conv = fptosi <8 x half> %in to <8 x i32>
  %min = call <8 x i32> @llvm.smin.v8i32(<8 x i32> %conv, <8 x i32> <i32 32767, i32 32767, i32 32767, i32 32767, i32 32767, i32 32767, i32 32767, i32 32767>)
  %max = call <8 x i32> @llvm.smax.v8i32(<8 x i32> %min, <8 x i32> <i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768, i32 -32768>)
  ret <8 x i32> %max
}


declare i64 @llvm.smin.i64(i64, i64)
declare i64 @llvm.smax.i64(i64, i64)
declare i32 @llvm.smin.i32(i32, i32)
declare i32 @llvm.smax.i32(i32, i32)
declare <2 x i64> @llvm.smin.v2i64(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.smax.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.smin.v4i64(<4 x i64>, <4 x i64>)
declare <4 x i64> @llvm.smax.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64> @llvm.smin.v8i64(<8 x i64>, <8 x i64>)
declare <8 x i64> @llvm.smax.v8i64(<8 x i64>, <8 x i64>)
declare <4 x i32> @llvm.smin.v4i32(<4 x i32>, <4 x i32>)
declare <4 x i32> @llvm.smax.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.smin.v8i32(<8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.smax.v8i32(<8 x i32>, <8 x i32>)
