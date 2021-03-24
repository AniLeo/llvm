; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -cost-model -analyze -mtriple=riscv64 -mattr=+experimental-v,+f,+d,+experimental-zfh -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 < %s 2>%t | FileCheck %s

define i32 @masked_scatter() {
; CHECK-LABEL: 'masked_scatter'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.v8f64.v8p0f64(<8 x double> undef, <8 x double*> undef, i32 1, <8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.v4f64.v4p0f64(<4 x double> undef, <4 x double*> undef, i32 1, <4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.v2f64.v2p0f64(<2 x double> undef, <2 x double*> undef, i32 8, <2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: call void @llvm.masked.scatter.v1f64.v1p0f64(<1 x double> undef, <1 x double*> undef, i32 8, <1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.v16f32.v16p0f32(<16 x float> undef, <16 x float*> undef, i32 1, <16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.v8f32.v8p0f32(<8 x float> undef, <8 x float*> undef, i32 1, <8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> undef, <4 x float*> undef, i32 2, <4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.v2f32.v2p0f32(<2 x float> undef, <2 x float*> undef, i32 2, <2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: call void @llvm.masked.scatter.v1f32.v1p0f32(<1 x float> undef, <1 x float*> undef, i32 2, <1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: call void @llvm.masked.scatter.v32f16.v32p0f16(<32 x half> undef, <32 x half*> undef, i32 1, <32 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.v16f16.v16p0f16(<16 x half> undef, <16 x half*> undef, i32 1, <16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half> undef, <8 x half*> undef, i32 2, <8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.v4f16.v4p0f16(<4 x half> undef, <4 x half*> undef, i32 2, <4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.v2f16.v2p0f16(<2 x half> undef, <2 x half*> undef, i32 2, <2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: call void @llvm.masked.scatter.v1f16.v1p0f16(<1 x half> undef, <1 x half*> undef, i32 2, <1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.v8i64.v8p0i64(<8 x i64> undef, <8 x i64*> undef, i32 1, <8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.v4i64.v4p0i64(<4 x i64> undef, <4 x i64*> undef, i32 1, <4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.v2i64.v2p0i64(<2 x i64> undef, <2 x i64*> undef, i32 8, <2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: call void @llvm.masked.scatter.v1i64.v1p0i64(<1 x i64> undef, <1 x i64*> undef, i32 8, <1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> undef, <16 x i32*> undef, i32 1, <16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.v8i32.v8p0i32(<8 x i32> undef, <8 x i32*> undef, i32 1, <8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> undef, <4 x i32*> undef, i32 4, <4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.v2i32.v2p0i32(<2 x i32> undef, <2 x i32*> undef, i32 4, <2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: call void @llvm.masked.scatter.v1i32.v1p0i32(<1 x i32> undef, <1 x i32*> undef, i32 4, <1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: call void @llvm.masked.scatter.v32i16.v32p0i16(<32 x i16> undef, <32 x i16*> undef, i32 1, <32 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.v16i16.v16p0i16(<16 x i16> undef, <16 x i16*> undef, i32 1, <16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> undef, <8 x i16*> undef, i32 2, <8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> undef, <4 x i16*> undef, i32 2, <4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.v2i16.v2p0i16(<2 x i16> undef, <2 x i16*> undef, i32 2, <2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: call void @llvm.masked.scatter.v1i16.v1p0i16(<1 x i16> undef, <1 x i16*> undef, i32 2, <1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: call void @llvm.masked.scatter.v64i8.v64p0i8(<64 x i8> undef, <64 x i8*> undef, i32 1, <64 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: call void @llvm.masked.scatter.v32i8.v32p0i8(<32 x i8> undef, <32 x i8*> undef, i32 1, <32 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.v16i8.v16p0i8(<16 x i8> undef, <16 x i8*> undef, i32 1, <16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.v8i8.v8p0i8(<8 x i8> undef, <8 x i8*> undef, i32 1, <8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> undef, <4 x i8*> undef, i32 1, <4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.v2i8.v2p0i8(<2 x i8> undef, <2 x i8*> undef, i32 1, <2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: call void @llvm.masked.scatter.v1i8.v1p0i8(<1 x i8> undef, <1 x i8*> undef, i32 1, <1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 0
;
  call void @llvm.masked.scatter.v8f64.v8p0f64(<8 x double> undef, <8 x double*> undef, i32 1, <8 x i1> undef)
  call void @llvm.masked.scatter.v4f64.v4p0f64(<4 x double> undef, <4 x double*> undef, i32 1, <4 x i1> undef)
  call void @llvm.masked.scatter.v2f64.v2p0f64(<2 x double> undef, <2 x double*> undef, i32 8, <2 x i1> undef)
  call void @llvm.masked.scatter.v1f64.v1p0f64(<1 x double> undef, <1 x double*> undef, i32 8, <1 x i1> undef)

  call void @llvm.masked.scatter.v16f32.v16p0f32(<16 x float> undef, <16 x float*> undef, i32 1, <16 x i1> undef)
  call void @llvm.masked.scatter.v8f32.v8p0f32(<8 x float> undef, <8 x float*> undef, i32 1, <8 x i1> undef)
  call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> undef, <4 x float*> undef, i32 2, <4 x i1> undef)
  call void @llvm.masked.scatter.v2f32.v2p0f32(<2 x float> undef, <2 x float*> undef, i32 2, <2 x i1> undef)
  call void @llvm.masked.scatter.v1f32.v1p0f32(<1 x float> undef, <1 x float*> undef, i32 2, <1 x i1> undef)

  call void @llvm.masked.scatter.v32f16.v32p0f16(<32 x half> undef, <32 x half*> undef, i32 1, <32 x i1> undef)
  call void @llvm.masked.scatter.v16f16.v16p0f16(<16 x half> undef, <16 x half*> undef, i32 1, <16 x i1> undef)
  call void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half> undef, <8 x half*> undef, i32 2, <8 x i1> undef)
  call void @llvm.masked.scatter.v4f16.v4p0f16(<4 x half> undef, <4 x half*> undef, i32 2, <4 x i1> undef)
  call void @llvm.masked.scatter.v2f16.v2p0f16(<2 x half> undef, <2 x half*> undef, i32 2, <2 x i1> undef)
  call void @llvm.masked.scatter.v1f16.v1p0f16(<1 x half> undef, <1 x half*> undef, i32 2, <1 x i1> undef)

  call void @llvm.masked.scatter.v8i64.v8p0i64(<8 x i64> undef, <8 x i64*> undef, i32 1, <8 x i1> undef)
  call void @llvm.masked.scatter.v4i64.v4p0i64(<4 x i64> undef, <4 x i64*> undef, i32 1, <4 x i1> undef)
  call void @llvm.masked.scatter.v2i64.v2p0i64(<2 x i64> undef, <2 x i64*> undef, i32 8, <2 x i1> undef)
  call void @llvm.masked.scatter.v1i64.v1p0i64(<1 x i64> undef, <1 x i64*> undef, i32 8, <1 x i1> undef)

  call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> undef, <16 x i32*> undef, i32 1, <16 x i1> undef)
  call void @llvm.masked.scatter.v8i32.v8p0i32(<8 x i32> undef, <8 x i32*> undef, i32 1, <8 x i1> undef)
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> undef, <4 x i32*> undef, i32 4, <4 x i1> undef)
  call void @llvm.masked.scatter.v2i32.v2p0i32(<2 x i32> undef, <2 x i32*> undef, i32 4, <2 x i1> undef)
  call void @llvm.masked.scatter.v1i32.v1p0i32(<1 x i32> undef, <1 x i32*> undef, i32 4, <1 x i1> undef)

  call void @llvm.masked.scatter.v32i16.v32p0i16(<32 x i16> undef, <32 x i16*> undef, i32 1, <32 x i1> undef)
  call void @llvm.masked.scatter.v16i16.v16p0i16(<16 x i16> undef, <16 x i16*> undef, i32 1, <16 x i1> undef)
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> undef, <8 x i16*> undef, i32 2, <8 x i1> undef)
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> undef, <4 x i16*> undef, i32 2, <4 x i1> undef)
  call void @llvm.masked.scatter.v2i16.v2p0i16(<2 x i16> undef, <2 x i16*> undef, i32 2, <2 x i1> undef)
  call void @llvm.masked.scatter.v1i16.v1p0i16(<1 x i16> undef, <1 x i16*> undef, i32 2, <1 x i1> undef)

  call void @llvm.masked.scatter.v64i8.v64p0i8(<64 x i8> undef, <64 x i8*> undef, i32 1, <64 x i1> undef)
  call void @llvm.masked.scatter.v32i8.v32p0i8(<32 x i8> undef, <32 x i8*> undef, i32 1, <32 x i1> undef)
  call void @llvm.masked.scatter.v16i8.v16p0i8(<16 x i8> undef, <16 x i8*> undef, i32 1, <16 x i1> undef)
  call void @llvm.masked.scatter.v8i8.v8p0i8(<8 x i8> undef, <8 x i8*> undef, i32 1, <8 x i1> undef)
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> undef, <4 x i8*> undef, i32 1, <4 x i1> undef)
  call void @llvm.masked.scatter.v2i8.v2p0i8(<2 x i8> undef, <2 x i8*> undef, i32 1, <2 x i1> undef)
  call void @llvm.masked.scatter.v1i8.v1p0i8(<1 x i8> undef, <1 x i8*> undef, i32 1, <1 x i1> undef)

  ret i32 0
}

declare void @llvm.masked.scatter.v8f64.v8p0f64(<8 x double>, <8 x double*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v4f64.v4p0f64(<4 x double>, <4 x double*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v2f64.v2p0f64(<2 x double>, <2 x double*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v1f64.v1p0f64(<1 x double>, <1 x double*>, i32, <1 x i1>)

declare void @llvm.masked.scatter.v16f32.v16p0f32(<16 x float>, <16 x float*>, i32, <16 x i1>)
declare void @llvm.masked.scatter.v8f32.v8p0f32(<8 x float>, <8 x float*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float>, <4 x float*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v2f32.v2p0f32(<2 x float>, <2 x float*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v1f32.v1p0f32(<1 x float>, <1 x float*>, i32, <1 x i1>)

declare void @llvm.masked.scatter.v32f16.v32p0f16(<32 x half>, <32 x half*>, i32, <32 x i1>)
declare void @llvm.masked.scatter.v16f16.v16p0f16(<16 x half>, <16 x half*>, i32, <16 x i1>)
declare void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half>, <8 x half*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v4f16.v4p0f16(<4 x half>, <4 x half*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v2f16.v2p0f16(<2 x half>, <2 x half*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v1f16.v1p0f16(<1 x half>, <1 x half*>, i32, <1 x i1>)

declare void @llvm.masked.scatter.v8i64.v8p0i64(<8 x i64>, <8 x i64*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v4i64.v4p0i64(<4 x i64>, <4 x i64*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v2i64.v2p0i64(<2 x i64>, <2 x i64*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v1i64.v1p0i64(<1 x i64>, <1 x i64*>, i32, <1 x i1>)

declare void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32>, <16 x i32*>, i32, <16 x i1>)
declare void @llvm.masked.scatter.v8i32.v8p0i32(<8 x i32>, <8 x i32*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32>, <4 x i32*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v2i32.v2p0i32(<2 x i32>, <2 x i32*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v1i32.v1p0i32(<1 x i32>, <1 x i32*>, i32, <1 x i1>)

declare void @llvm.masked.scatter.v32i16.v32p0i16(<32 x i16>, <32 x i16*>, i32, <32 x i1>)
declare void @llvm.masked.scatter.v16i16.v16p0i16(<16 x i16>, <16 x i16*>, i32, <16 x i1>)
declare void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16>, <8 x i16*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16>, <4 x i16*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v2i16.v2p0i16(<2 x i16>, <2 x i16*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v1i16.v1p0i16(<1 x i16>, <1 x i16*>, i32, <1 x i1>)

declare void @llvm.masked.scatter.v64i8.v64p0i8(<64 x i8>, <64 x i8*>, i32, <64 x i1>)
declare void @llvm.masked.scatter.v32i8.v32p0i8(<32 x i8>, <32 x i8*>, i32, <32 x i1>)
declare void @llvm.masked.scatter.v16i8.v16p0i8(<16 x i8>, <16 x i8*>, i32, <16 x i1>)
declare void @llvm.masked.scatter.v8i8.v8p0i8(<8 x i8>, <8 x i8*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8>, <4 x i8*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v2i8.v2p0i8(<2 x i8>, <2 x i8*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v1i8.v1p0i8(<1 x i8>, <1 x i8*>, i32, <1 x i1>)
