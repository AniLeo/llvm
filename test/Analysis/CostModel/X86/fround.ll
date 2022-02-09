; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mattr=+sse2 | FileCheck %s --check-prefixes=SSE2
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE42
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx2 | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512f | FileCheck %s --check-prefixes=AVX512
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=AVX512
;
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mcpu=slm | FileCheck %s --check-prefixes=SSE42
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mcpu=goldmont | FileCheck %s --check-prefixes=SSE42
; RUN: opt < %s -enable-no-nans-fp-math  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=x86_64-apple-macosx10.8.0 -mcpu=btver2 | FileCheck %s --check-prefixes=AVX

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

define i32 @ceil(i32 %arg) {
; SSE2-LABEL: 'ceil'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F32 = call float @llvm.ceil.f32(float undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 43 for instruction: %V4F32 = call <4 x float> @llvm.ceil.v4f32(<4 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 86 for instruction: %V8F32 = call <8 x float> @llvm.ceil.v8f32(<8 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 172 for instruction: %V16F32 = call <16 x float> @llvm.ceil.v16f32(<16 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F64 = call double @llvm.ceil.f64(double undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V2F64 = call <2 x double> @llvm.ceil.v2f64(<2 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %V4F64 = call <4 x double> @llvm.ceil.v4f64(<4 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 84 for instruction: %V8F64 = call <8 x double> @llvm.ceil.v8f64(<8 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'ceil'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.ceil.f32(float undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.ceil.v4f32(<4 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F32 = call <8 x float> @llvm.ceil.v8f32(<8 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16F32 = call <16 x float> @llvm.ceil.v16f32(<16 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.ceil.f64(double undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.ceil.v2f64(<2 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4F64 = call <4 x double> @llvm.ceil.v4f64(<4 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8F64 = call <8 x double> @llvm.ceil.v8f64(<8 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'ceil'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.ceil.f32(float undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.ceil.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.ceil.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16F32 = call <16 x float> @llvm.ceil.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.ceil.f64(double undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.ceil.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.ceil.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F64 = call <8 x double> @llvm.ceil.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'ceil'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.ceil.f32(float undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.ceil.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.ceil.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = call <16 x float> @llvm.ceil.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.ceil.f64(double undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.ceil.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.ceil.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = call <8 x double> @llvm.ceil.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %F32 = call float @llvm.ceil.f32(float undef)
  %V4F32 = call <4 x float> @llvm.ceil.v4f32(<4 x float> undef)
  %V8F32 = call <8 x float> @llvm.ceil.v8f32(<8 x float> undef)
  %V16F32 = call <16 x float> @llvm.ceil.v16f32(<16 x float> undef)

  %F64 = call double @llvm.ceil.f64(double undef)
  %V2F64 = call <2 x double> @llvm.ceil.v2f64(<2 x double> undef)
  %V4F64 = call <4 x double> @llvm.ceil.v4f64(<4 x double> undef)
  %V8F64 = call <8 x double> @llvm.ceil.v8f64(<8 x double> undef)

  ret i32 undef
}

define i32 @floor(i32 %arg) {
; SSE2-LABEL: 'floor'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F32 = call float @llvm.floor.f32(float undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 43 for instruction: %V4F32 = call <4 x float> @llvm.floor.v4f32(<4 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 86 for instruction: %V8F32 = call <8 x float> @llvm.floor.v8f32(<8 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 172 for instruction: %V16F32 = call <16 x float> @llvm.floor.v16f32(<16 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F64 = call double @llvm.floor.f64(double undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V2F64 = call <2 x double> @llvm.floor.v2f64(<2 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %V4F64 = call <4 x double> @llvm.floor.v4f64(<4 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 84 for instruction: %V8F64 = call <8 x double> @llvm.floor.v8f64(<8 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'floor'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.floor.f32(float undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.floor.v4f32(<4 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F32 = call <8 x float> @llvm.floor.v8f32(<8 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16F32 = call <16 x float> @llvm.floor.v16f32(<16 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.floor.f64(double undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.floor.v2f64(<2 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4F64 = call <4 x double> @llvm.floor.v4f64(<4 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8F64 = call <8 x double> @llvm.floor.v8f64(<8 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'floor'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.floor.f32(float undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.floor.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.floor.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16F32 = call <16 x float> @llvm.floor.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.floor.f64(double undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.floor.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.floor.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F64 = call <8 x double> @llvm.floor.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'floor'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.floor.f32(float undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.floor.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.floor.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = call <16 x float> @llvm.floor.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.floor.f64(double undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.floor.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.floor.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = call <8 x double> @llvm.floor.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %F32 = call float @llvm.floor.f32(float undef)
  %V4F32 = call <4 x float> @llvm.floor.v4f32(<4 x float> undef)
  %V8F32 = call <8 x float> @llvm.floor.v8f32(<8 x float> undef)
  %V16F32 = call <16 x float> @llvm.floor.v16f32(<16 x float> undef)

  %F64 = call double @llvm.floor.f64(double undef)
  %V2F64 = call <2 x double> @llvm.floor.v2f64(<2 x double> undef)
  %V4F64 = call <4 x double> @llvm.floor.v4f64(<4 x double> undef)
  %V8F64 = call <8 x double> @llvm.floor.v8f64(<8 x double> undef)

  ret i32 undef
}

define i32 @nearbyint(i32 %arg) {
; SSE2-LABEL: 'nearbyint'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F32 = call float @llvm.nearbyint.f32(float undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 43 for instruction: %V4F32 = call <4 x float> @llvm.nearbyint.v4f32(<4 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 86 for instruction: %V8F32 = call <8 x float> @llvm.nearbyint.v8f32(<8 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 172 for instruction: %V16F32 = call <16 x float> @llvm.nearbyint.v16f32(<16 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F64 = call double @llvm.nearbyint.f64(double undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V2F64 = call <2 x double> @llvm.nearbyint.v2f64(<2 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %V4F64 = call <4 x double> @llvm.nearbyint.v4f64(<4 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 84 for instruction: %V8F64 = call <8 x double> @llvm.nearbyint.v8f64(<8 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'nearbyint'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.nearbyint.f32(float undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.nearbyint.v4f32(<4 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F32 = call <8 x float> @llvm.nearbyint.v8f32(<8 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16F32 = call <16 x float> @llvm.nearbyint.v16f32(<16 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.nearbyint.f64(double undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.nearbyint.v2f64(<2 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4F64 = call <4 x double> @llvm.nearbyint.v4f64(<4 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8F64 = call <8 x double> @llvm.nearbyint.v8f64(<8 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'nearbyint'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.nearbyint.f32(float undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.nearbyint.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.nearbyint.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16F32 = call <16 x float> @llvm.nearbyint.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.nearbyint.f64(double undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.nearbyint.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.nearbyint.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F64 = call <8 x double> @llvm.nearbyint.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'nearbyint'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.nearbyint.f32(float undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.nearbyint.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.nearbyint.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = call <16 x float> @llvm.nearbyint.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.nearbyint.f64(double undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.nearbyint.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.nearbyint.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = call <8 x double> @llvm.nearbyint.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %F32 = call float @llvm.nearbyint.f32(float undef)
  %V4F32 = call <4 x float> @llvm.nearbyint.v4f32(<4 x float> undef)
  %V8F32 = call <8 x float> @llvm.nearbyint.v8f32(<8 x float> undef)
  %V16F32 = call <16 x float> @llvm.nearbyint.v16f32(<16 x float> undef)

  %F64 = call double @llvm.nearbyint.f64(double undef)
  %V2F64 = call <2 x double> @llvm.nearbyint.v2f64(<2 x double> undef)
  %V4F64 = call <4 x double> @llvm.nearbyint.v4f64(<4 x double> undef)
  %V8F64 = call <8 x double> @llvm.nearbyint.v8f64(<8 x double> undef)

  ret i32 undef
}

define i32 @rint(i32 %arg) {
; SSE2-LABEL: 'rint'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F32 = call float @llvm.rint.f32(float undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 43 for instruction: %V4F32 = call <4 x float> @llvm.rint.v4f32(<4 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 86 for instruction: %V8F32 = call <8 x float> @llvm.rint.v8f32(<8 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 172 for instruction: %V16F32 = call <16 x float> @llvm.rint.v16f32(<16 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F64 = call double @llvm.rint.f64(double undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V2F64 = call <2 x double> @llvm.rint.v2f64(<2 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %V4F64 = call <4 x double> @llvm.rint.v4f64(<4 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 84 for instruction: %V8F64 = call <8 x double> @llvm.rint.v8f64(<8 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'rint'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.rint.f32(float undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.rint.v4f32(<4 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F32 = call <8 x float> @llvm.rint.v8f32(<8 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16F32 = call <16 x float> @llvm.rint.v16f32(<16 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.rint.f64(double undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.rint.v2f64(<2 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4F64 = call <4 x double> @llvm.rint.v4f64(<4 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8F64 = call <8 x double> @llvm.rint.v8f64(<8 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'rint'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.rint.f32(float undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.rint.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.rint.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16F32 = call <16 x float> @llvm.rint.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.rint.f64(double undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.rint.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.rint.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F64 = call <8 x double> @llvm.rint.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'rint'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.rint.f32(float undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.rint.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.rint.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = call <16 x float> @llvm.rint.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.rint.f64(double undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.rint.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.rint.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = call <8 x double> @llvm.rint.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %F32 = call float @llvm.rint.f32(float undef)
  %V4F32 = call <4 x float> @llvm.rint.v4f32(<4 x float> undef)
  %V8F32 = call <8 x float> @llvm.rint.v8f32(<8 x float> undef)
  %V16F32 = call <16 x float> @llvm.rint.v16f32(<16 x float> undef)

  %F64 = call double @llvm.rint.f64(double undef)
  %V2F64 = call <2 x double> @llvm.rint.v2f64(<2 x double> undef)
  %V4F64 = call <4 x double> @llvm.rint.v4f64(<4 x double> undef)
  %V8F64 = call <8 x double> @llvm.rint.v8f64(<8 x double> undef)

  ret i32 undef
}

define i32 @trunc(i32 %arg) {
; SSE2-LABEL: 'trunc'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F32 = call float @llvm.trunc.f32(float undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 43 for instruction: %V4F32 = call <4 x float> @llvm.trunc.v4f32(<4 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 86 for instruction: %V8F32 = call <8 x float> @llvm.trunc.v8f32(<8 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 172 for instruction: %V16F32 = call <16 x float> @llvm.trunc.v16f32(<16 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %F64 = call double @llvm.trunc.f64(double undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V2F64 = call <2 x double> @llvm.trunc.v2f64(<2 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %V4F64 = call <4 x double> @llvm.trunc.v4f64(<4 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 84 for instruction: %V8F64 = call <8 x double> @llvm.trunc.v8f64(<8 x double> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'trunc'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.trunc.f32(float undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.trunc.v4f32(<4 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F32 = call <8 x float> @llvm.trunc.v8f32(<8 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16F32 = call <16 x float> @llvm.trunc.v16f32(<16 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.trunc.f64(double undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.trunc.v2f64(<2 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4F64 = call <4 x double> @llvm.trunc.v4f64(<4 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8F64 = call <8 x double> @llvm.trunc.v8f64(<8 x double> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'trunc'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.trunc.f32(float undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.trunc.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.trunc.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16F32 = call <16 x float> @llvm.trunc.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.trunc.f64(double undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.trunc.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.trunc.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F64 = call <8 x double> @llvm.trunc.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'trunc'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = call float @llvm.trunc.f32(float undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = call <4 x float> @llvm.trunc.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = call <8 x float> @llvm.trunc.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = call <16 x float> @llvm.trunc.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = call double @llvm.trunc.f64(double undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = call <2 x double> @llvm.trunc.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = call <4 x double> @llvm.trunc.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = call <8 x double> @llvm.trunc.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %F32 = call float @llvm.trunc.f32(float undef)
  %V4F32 = call <4 x float> @llvm.trunc.v4f32(<4 x float> undef)
  %V8F32 = call <8 x float> @llvm.trunc.v8f32(<8 x float> undef)
  %V16F32 = call <16 x float> @llvm.trunc.v16f32(<16 x float> undef)

  %F64 = call double @llvm.trunc.f64(double undef)
  %V2F64 = call <2 x double> @llvm.trunc.v2f64(<2 x double> undef)
  %V4F64 = call <4 x double> @llvm.trunc.v4f64(<4 x double> undef)
  %V8F64 = call <8 x double> @llvm.trunc.v8f64(<8 x double> undef)

  ret i32 undef
}

declare float @llvm.ceil.f32(float)
declare <4 x float> @llvm.ceil.v4f32(<4 x float>)
declare <8 x float> @llvm.ceil.v8f32(<8 x float>)
declare <16 x float> @llvm.ceil.v16f32(<16 x float>)

declare double @llvm.ceil.f64(double)
declare <2 x double> @llvm.ceil.v2f64(<2 x double>)
declare <4 x double> @llvm.ceil.v4f64(<4 x double>)
declare <8 x double> @llvm.ceil.v8f64(<8 x double>)

declare float @llvm.floor.f32(float)
declare <4 x float> @llvm.floor.v4f32(<4 x float>)
declare <8 x float> @llvm.floor.v8f32(<8 x float>)
declare <16 x float> @llvm.floor.v16f32(<16 x float>)

declare double @llvm.floor.f64(double)
declare <2 x double> @llvm.floor.v2f64(<2 x double>)
declare <4 x double> @llvm.floor.v4f64(<4 x double>)
declare <8 x double> @llvm.floor.v8f64(<8 x double>)

declare float @llvm.nearbyint.f32(float)
declare <4 x float> @llvm.nearbyint.v4f32(<4 x float>)
declare <8 x float> @llvm.nearbyint.v8f32(<8 x float>)
declare <16 x float> @llvm.nearbyint.v16f32(<16 x float>)

declare double @llvm.nearbyint.f64(double)
declare <2 x double> @llvm.nearbyint.v2f64(<2 x double>)
declare <4 x double> @llvm.nearbyint.v4f64(<4 x double>)
declare <8 x double> @llvm.nearbyint.v8f64(<8 x double>)

declare float @llvm.rint.f32(float)
declare <4 x float> @llvm.rint.v4f32(<4 x float>)
declare <8 x float> @llvm.rint.v8f32(<8 x float>)
declare <16 x float> @llvm.rint.v16f32(<16 x float>)

declare double @llvm.rint.f64(double)
declare <2 x double> @llvm.rint.v2f64(<2 x double>)
declare <4 x double> @llvm.rint.v4f64(<4 x double>)
declare <8 x double> @llvm.rint.v8f64(<8 x double>)

declare float @llvm.trunc.f32(float)
declare <4 x float> @llvm.trunc.v4f32(<4 x float>)
declare <8 x float> @llvm.trunc.v8f32(<8 x float>)
declare <16 x float> @llvm.trunc.v16f32(<16 x float>)

declare double @llvm.trunc.f64(double)
declare <2 x double> @llvm.trunc.v2f64(<2 x double>)
declare <4 x double> @llvm.trunc.v4f64(<4 x double>)
declare <8 x double> @llvm.trunc.v8f64(<8 x double>)
