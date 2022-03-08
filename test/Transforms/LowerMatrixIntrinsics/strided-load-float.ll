; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s

define <9 x float> @strided_load_3x3(float* %in, i64 %stride) {
; CHECK-LABEL: @strided_load_3x3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_START:%.*]] = mul i64 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr float, float* [[IN:%.*]], i64 [[VEC_START]]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast float* [[VEC_GEP]] to <3 x float>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <3 x float>, <3 x float>* [[VEC_CAST]], align 4
; CHECK-NEXT:    [[VEC_START1:%.*]] = mul i64 1, [[STRIDE]]
; CHECK-NEXT:    [[VEC_GEP2:%.*]] = getelementptr float, float* [[IN]], i64 [[VEC_START1]]
; CHECK-NEXT:    [[VEC_CAST3:%.*]] = bitcast float* [[VEC_GEP2]] to <3 x float>*
; CHECK-NEXT:    [[COL_LOAD4:%.*]] = load <3 x float>, <3 x float>* [[VEC_CAST3]], align 4
; CHECK-NEXT:    [[VEC_START5:%.*]] = mul i64 2, [[STRIDE]]
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr float, float* [[IN]], i64 [[VEC_START5]]
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast float* [[VEC_GEP6]] to <3 x float>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <3 x float>, <3 x float>* [[VEC_CAST7]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <3 x float> [[COL_LOAD]], <3 x float> [[COL_LOAD4]], <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <3 x float> [[COL_LOAD8]], <3 x float> poison, <6 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <6 x float> [[TMP0]], <6 x float> [[TMP1]], <9 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
; CHECK-NEXT:    ret <9 x float> [[TMP2]]
;
entry:
  %load = call <9 x float> @llvm.matrix.column.major.load(float* %in, i64 %stride, i1 false, i32 3, i32 3)
  ret <9 x float> %load
}

declare <9 x float> @llvm.matrix.column.major.load(float*, i64, i1, i32, i32)

define <9 x float> @strided_load_9x1(float* %in, i64 %stride) {
; CHECK-LABEL: @strided_load_9x1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_START:%.*]] = mul i64 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr float, float* [[IN:%.*]], i64 [[VEC_START]]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast float* [[VEC_GEP]] to <9 x float>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <9 x float>, <9 x float>* [[VEC_CAST]], align 4
; CHECK-NEXT:    ret <9 x float> [[COL_LOAD]]
;
entry:
  %load = call <9 x float> @llvm.matrix.column.major.load(float* %in, i64 %stride, i1 false, i32 9, i32 1)
  ret <9 x float> %load
}

declare <8 x float> @llvm.matrix.column.major.load.v8f32(float*, i64, i1, i32, i32)

define <8 x float> @strided_load_4x2(float* %in, i64 %stride) {
; CHECK-LABEL: @strided_load_4x2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_START:%.*]] = mul i64 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr float, float* [[IN:%.*]], i64 [[VEC_START]]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast float* [[VEC_GEP]] to <4 x float>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <4 x float>, <4 x float>* [[VEC_CAST]], align 4
; CHECK-NEXT:    [[VEC_START1:%.*]] = mul i64 1, [[STRIDE]]
; CHECK-NEXT:    [[VEC_GEP2:%.*]] = getelementptr float, float* [[IN]], i64 [[VEC_START1]]
; CHECK-NEXT:    [[VEC_CAST3:%.*]] = bitcast float* [[VEC_GEP2]] to <4 x float>*
; CHECK-NEXT:    [[COL_LOAD4:%.*]] = load <4 x float>, <4 x float>* [[VEC_CAST3]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <4 x float> [[COL_LOAD]], <4 x float> [[COL_LOAD4]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x float> [[TMP0]]
;
entry:
  %load = call <8 x float> @llvm.matrix.column.major.load.v8f32(float* %in, i64 %stride, i1 false, i32 4, i32 2)
  ret <8 x float> %load
}
