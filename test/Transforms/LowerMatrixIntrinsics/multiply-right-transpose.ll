; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics -S < %s | FileCheck %s
; RUN: opt -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s

define <4 x double> @multiply_right_transpose_2x2(<4 x double> %a, <4 x double> %b) {
; CHECK-LABEL: @multiply_right_transpose_2x2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <4 x double> [[A:%.*]], <4 x double> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <4 x double> [[A]], <4 x double> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <4 x double> [[B:%.*]], <4 x double> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <4 x double> [[B]], <4 x double> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x double> [[SPLIT]], <2 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <2 x double> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x double> poison, double [[TMP0]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = fmul <1 x double> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[BLOCK4:%.*]] = shufflevector <2 x double> [[SPLIT1]], <2 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x double> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT5:%.*]] = insertelement <1 x double> poison, double [[TMP2]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT6:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT5]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = fmul <1 x double> [[BLOCK4]], [[SPLAT_SPLAT6]]
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <1 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <1 x double> [[TMP4]], <1 x double> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <2 x double> undef, <2 x double> [[TMP5]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK7:%.*]] = shufflevector <2 x double> [[SPLIT]], <2 x double> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x double> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT8:%.*]] = insertelement <1 x double> poison, double [[TMP7]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT9:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT8]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = fmul <1 x double> [[BLOCK7]], [[SPLAT_SPLAT9]]
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x double> [[SPLIT1]], <2 x double> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x double> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <1 x double> poison, double [[TMP9]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT11]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = fmul <1 x double> [[BLOCK10]], [[SPLAT_SPLAT12]]
; CHECK-NEXT:    [[TMP11:%.*]] = fadd <1 x double> [[TMP8]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <1 x double> [[TMP11]], <1 x double> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <2 x double> [[TMP6]], <2 x double> [[TMP12]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x double> [[SPLIT]], <2 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x double> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT14:%.*]] = insertelement <1 x double> poison, double [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT15:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT14]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = fmul <1 x double> [[BLOCK13]], [[SPLAT_SPLAT15]]
; CHECK-NEXT:    [[BLOCK16:%.*]] = shufflevector <2 x double> [[SPLIT1]], <2 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <2 x double> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT17:%.*]] = insertelement <1 x double> poison, double [[TMP16]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT18:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT17]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP17:%.*]] = fmul <1 x double> [[BLOCK16]], [[SPLAT_SPLAT18]]
; CHECK-NEXT:    [[TMP18:%.*]] = fadd <1 x double> [[TMP15]], [[TMP17]]
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <1 x double> [[TMP18]], <1 x double> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <2 x double> undef, <2 x double> [[TMP19]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK19:%.*]] = shufflevector <2 x double> [[SPLIT]], <2 x double> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <2 x double> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT20:%.*]] = insertelement <1 x double> poison, double [[TMP21]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT20]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP22:%.*]] = fmul <1 x double> [[BLOCK19]], [[SPLAT_SPLAT21]]
; CHECK-NEXT:    [[BLOCK22:%.*]] = shufflevector <2 x double> [[SPLIT1]], <2 x double> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <2 x double> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT23:%.*]] = insertelement <1 x double> poison, double [[TMP23]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT23]], <1 x double> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP24:%.*]] = fmul <1 x double> [[BLOCK22]], [[SPLAT_SPLAT24]]
; CHECK-NEXT:    [[TMP25:%.*]] = fadd <1 x double> [[TMP22]], [[TMP24]]
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <1 x double> [[TMP25]], <1 x double> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP27:%.*]] = shufflevector <2 x double> [[TMP20]], <2 x double> [[TMP26]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[TMP28:%.*]] = shufflevector <2 x double> [[TMP13]], <2 x double> [[TMP27]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x double> [[TMP28]]
;
entry:
  %bt = call <4 x double> @llvm.matrix.transpose.v4f64(<4 x double> %b, i32 2, i32 2)
  %c = call <4 x double> @llvm.matrix.multiply.v4f64.v4f64.v4f64(<4 x double> %a, <4 x double> %bt, i32 2, i32 2, i32 2)
  ret <4 x double> %c
}

declare <4 x double> @llvm.matrix.multiply.v4f64.v4f64.v4f64(<4 x double>, <4 x double>, i32, i32, i32)
declare <4 x double> @llvm.matrix.transpose.v4f64(<4 x double>, i32, i32)
