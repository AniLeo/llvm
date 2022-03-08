; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s

define <9 x double> @strided_load_3x3(double* %in, i64 %stride) {
; CHECK-LABEL: @strided_load_3x3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_START:%.*]] = mul i64 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[IN:%.*]], i64 [[VEC_START]]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[VEC_GEP]] to <3 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <3 x double>, <3 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_START1:%.*]] = mul i64 1, [[STRIDE]]
; CHECK-NEXT:    [[VEC_GEP2:%.*]] = getelementptr double, double* [[IN]], i64 [[VEC_START1]]
; CHECK-NEXT:    [[VEC_CAST3:%.*]] = bitcast double* [[VEC_GEP2]] to <3 x double>*
; CHECK-NEXT:    [[COL_LOAD4:%.*]] = load <3 x double>, <3 x double>* [[VEC_CAST3]], align 8
; CHECK-NEXT:    [[VEC_START5:%.*]] = mul i64 2, [[STRIDE]]
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr double, double* [[IN]], i64 [[VEC_START5]]
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <3 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <3 x double>, <3 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <3 x double> [[COL_LOAD]], <3 x double> [[COL_LOAD4]], <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <3 x double> [[COL_LOAD8]], <3 x double> poison, <6 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <6 x double> [[TMP0]], <6 x double> [[TMP1]], <9 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
; CHECK-NEXT:    ret <9 x double> [[TMP2]]
;
entry:
  %load = call <9 x double> @llvm.matrix.column.major.load.v9f64.i64(double* %in, i64 %stride, i1 false, i32 3, i32 3)
  ret <9 x double> %load
}

declare <9 x double> @llvm.matrix.column.major.load.v9f64.i64(double*, i64, i1, i32, i32)

define <9 x double> @strided_load_9x1(double* %in, i64 %stride) {
; CHECK-LABEL: @strided_load_9x1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_START:%.*]] = mul i64 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[IN:%.*]], i64 [[VEC_START]]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[VEC_GEP]] to <9 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <9 x double>, <9 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    ret <9 x double> [[COL_LOAD]]
;
entry:
  %load = call <9 x double> @llvm.matrix.column.major.load.v9f64.i64(double* %in, i64 %stride, i1 false, i32 9, i32 1)
  ret <9 x double> %load
}

declare <8 x double> @llvm.matrix.column.major.load.v8f64.i64(double*, i64, i1, i32, i32)

define <8 x double> @strided_load_4x2(double* %in, i64 %stride) {
; CHECK-LABEL: @strided_load_4x2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_START:%.*]] = mul i64 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[IN:%.*]], i64 [[VEC_START]]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[VEC_GEP]] to <4 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <4 x double>, <4 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_START1:%.*]] = mul i64 1, [[STRIDE]]
; CHECK-NEXT:    [[VEC_GEP2:%.*]] = getelementptr double, double* [[IN]], i64 [[VEC_START1]]
; CHECK-NEXT:    [[VEC_CAST3:%.*]] = bitcast double* [[VEC_GEP2]] to <4 x double>*
; CHECK-NEXT:    [[COL_LOAD4:%.*]] = load <4 x double>, <4 x double>* [[VEC_CAST3]], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <4 x double> [[COL_LOAD]], <4 x double> [[COL_LOAD4]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x double> [[TMP0]]
;
entry:
  %load = call <8 x double> @llvm.matrix.column.major.load.v8f64.i64(double* %in, i64 %stride, i1 false, i32 4, i32 2)
  ret <8 x double> %load
}

declare <8 x double> @llvm.matrix.column.major.load.v8f64.i32(double*, i32, i1, i32, i32)

define <8 x double> @strided_load_4x2_stride_i32(double* %in, i32 %stride) {
; CHECK-LABEL: @strided_load_4x2_stride_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_START:%.*]] = mul i32 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[IN:%.*]], i32 [[VEC_START]]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[VEC_GEP]] to <4 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <4 x double>, <4 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_START1:%.*]] = mul i32 1, [[STRIDE]]
; CHECK-NEXT:    [[VEC_GEP2:%.*]] = getelementptr double, double* [[IN]], i32 [[VEC_START1]]
; CHECK-NEXT:    [[VEC_CAST3:%.*]] = bitcast double* [[VEC_GEP2]] to <4 x double>*
; CHECK-NEXT:    [[COL_LOAD4:%.*]] = load <4 x double>, <4 x double>* [[VEC_CAST3]], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <4 x double> [[COL_LOAD]], <4 x double> [[COL_LOAD4]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x double> [[TMP0]]
;
entry:
  %load = call <8 x double> @llvm.matrix.column.major.load.v8f64.i32(double* %in, i32 %stride, i1 false, i32 4, i32 2)
  ret <8 x double> %load
}
