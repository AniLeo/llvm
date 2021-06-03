; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics-minimal -fuse-matrix-tile-size=2 -matrix-allow-contract -force-fuse-matrix -instcombine -verify-dom-info %s -S | FileCheck %s
; RUN: opt -passes='lower-matrix-intrinsics-minimal,instcombine,verify<domtree>' -fuse-matrix-tile-size=2 -matrix-allow-contract -force-fuse-matrix %s -S | FileCheck %s

; Test for the minimal version of the matrix lowering pass, which does not
; require DT or AA. Make sure no tiling is happening, even though it was
; requested.

; REQUIRES: aarch64-registered-target

target datalayout = "e-m:o-i64:64-f80:128-n8:8:32:64-S128"
target triple = "aarch64-apple-ios"

define void @multiply(<8 x double> * %A, <8 x double> * %B, <4 x double>* %C) {
; CHECK-LABEL: @multiply(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast <8 x double>* [[A:%.*]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr <8 x double>, <8 x double>* [[A]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD2:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST1]], align 8
; CHECK-NEXT:    [[VEC_GEP3:%.*]] = getelementptr <8 x double>, <8 x double>* [[A]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST4:%.*]] = bitcast double* [[VEC_GEP3]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD5:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST4]], align 8
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr <8 x double>, <8 x double>* [[A]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[VEC_CAST9:%.*]] = bitcast <8 x double>* [[B:%.*]] to <4 x double>*
; CHECK-NEXT:    [[COL_LOAD10:%.*]] = load <4 x double>, <4 x double>* [[VEC_CAST9]], align 8
; CHECK-NEXT:    [[VEC_GEP11:%.*]] = getelementptr <8 x double>, <8 x double>* [[B]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST12:%.*]] = bitcast double* [[VEC_GEP11]] to <4 x double>*
; CHECK-NEXT:    [[COL_LOAD13:%.*]] = load <4 x double>, <4 x double>* [[VEC_CAST12]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <4 x double> [[COL_LOAD10]], <4 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = fmul contract <2 x double> [[COL_LOAD]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[SPLAT_SPLAT16:%.*]] = shufflevector <4 x double> [[COL_LOAD10]], <4 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP1:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD2]], <2 x double> [[SPLAT_SPLAT16]], <2 x double> [[TMP0]])
; CHECK-NEXT:    [[SPLAT_SPLAT19:%.*]] = shufflevector <4 x double> [[COL_LOAD10]], <4 x double> undef, <2 x i32> <i32 2, i32 2>
; CHECK-NEXT:    [[TMP2:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD5]], <2 x double> [[SPLAT_SPLAT19]], <2 x double> [[TMP1]])
; CHECK-NEXT:    [[SPLAT_SPLAT22:%.*]] = shufflevector <4 x double> [[COL_LOAD10]], <4 x double> undef, <2 x i32> <i32 3, i32 3>
; CHECK-NEXT:    [[TMP3:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD8]], <2 x double> [[SPLAT_SPLAT22]], <2 x double> [[TMP2]])
; CHECK-NEXT:    [[SPLAT_SPLAT25:%.*]] = shufflevector <4 x double> [[COL_LOAD13]], <4 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = fmul contract <2 x double> [[COL_LOAD]], [[SPLAT_SPLAT25]]
; CHECK-NEXT:    [[SPLAT_SPLAT28:%.*]] = shufflevector <4 x double> [[COL_LOAD13]], <4 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP5:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD2]], <2 x double> [[SPLAT_SPLAT28]], <2 x double> [[TMP4]])
; CHECK-NEXT:    [[SPLAT_SPLAT31:%.*]] = shufflevector <4 x double> [[COL_LOAD13]], <4 x double> undef, <2 x i32> <i32 2, i32 2>
; CHECK-NEXT:    [[TMP6:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD5]], <2 x double> [[SPLAT_SPLAT31]], <2 x double> [[TMP5]])
; CHECK-NEXT:    [[SPLAT_SPLAT34:%.*]] = shufflevector <4 x double> [[COL_LOAD13]], <4 x double> undef, <2 x i32> <i32 3, i32 3>
; CHECK-NEXT:    [[TMP7:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD8]], <2 x double> [[SPLAT_SPLAT34]], <2 x double> [[TMP6]])
; CHECK-NEXT:    [[VEC_CAST35:%.*]] = bitcast <4 x double>* [[C:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP3]], <2 x double>* [[VEC_CAST35]], align 8
; CHECK-NEXT:    [[VEC_GEP36:%.*]] = getelementptr <4 x double>, <4 x double>* [[C]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST37:%.*]] = bitcast double* [[VEC_GEP36]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP7]], <2 x double>* [[VEC_CAST37]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %a = load <8 x double>, <8 x double>* %A, align 8
  %b = load <8 x double>, <8 x double>* %B, align 8

  %c = call <4 x double> @llvm.matrix.multiply(<8 x double> %a, <8 x double> %b, i32 2, i32 4, i32 2)

  store <4 x double> %c, <4 x double>* %C, align 8
  ret void
}

declare <4 x double> @llvm.matrix.multiply(<8 x double>, <8 x double>, i32, i32, i32)
