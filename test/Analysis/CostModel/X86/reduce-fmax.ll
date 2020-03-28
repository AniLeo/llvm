; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+ssse3 | FileCheck %s --check-prefixes=CHECK,SSE,SSSE3
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512F
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512BW
; RUN: opt < %s -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512DQ

define i32 @reduce_f64(i32 %arg) {
; SSE-LABEL: 'reduce_f64'
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call double @llvm.experimental.vector.reduce.fmax.v1f64(<1 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call double @llvm.experimental.vector.reduce.fmax.v2f64(<2 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V4 = call double @llvm.experimental.vector.reduce.fmax.v4f64(<4 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V8 = call double @llvm.experimental.vector.reduce.fmax.v8f64(<8 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V16 = call double @llvm.experimental.vector.reduce.fmax.v16f64(<16 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_f64'
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call double @llvm.experimental.vector.reduce.fmax.v1f64(<1 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call double @llvm.experimental.vector.reduce.fmax.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call double @llvm.experimental.vector.reduce.fmax.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8 = call double @llvm.experimental.vector.reduce.fmax.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16 = call double @llvm.experimental.vector.reduce.fmax.v16f64(<16 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_f64'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call double @llvm.experimental.vector.reduce.fmax.v1f64(<1 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call double @llvm.experimental.vector.reduce.fmax.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call double @llvm.experimental.vector.reduce.fmax.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call double @llvm.experimental.vector.reduce.fmax.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16 = call double @llvm.experimental.vector.reduce.fmax.v16f64(<16 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V1  = call double @llvm.experimental.vector.reduce.fmax.v1f64(<1 x double> undef)
  %V2  = call double @llvm.experimental.vector.reduce.fmax.v2f64(<2 x double> undef)
  %V4  = call double @llvm.experimental.vector.reduce.fmax.v4f64(<4 x double> undef)
  %V8  = call double @llvm.experimental.vector.reduce.fmax.v8f64(<8 x double> undef)
  %V16 = call double @llvm.experimental.vector.reduce.fmax.v16f64(<16 x double> undef)
  ret i32 undef
}

define i32 @reduce_f32(i32 %arg) {
; SSE2-LABEL: 'reduce_f32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.experimental.vector.reduce.fmax.v1f32(<1 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2 = call float @llvm.experimental.vector.reduce.fmax.v2f32(<2 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call float @llvm.experimental.vector.reduce.fmax.v4f32(<4 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8 = call float @llvm.experimental.vector.reduce.fmax.v8f32(<8 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16 = call float @llvm.experimental.vector.reduce.fmax.v16f32(<16 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V32 = call float @llvm.experimental.vector.reduce.fmax.v32f32(<32 x float> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSSE3-LABEL: 'reduce_f32'
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.experimental.vector.reduce.fmax.v1f32(<1 x float> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2 = call float @llvm.experimental.vector.reduce.fmax.v2f32(<2 x float> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call float @llvm.experimental.vector.reduce.fmax.v4f32(<4 x float> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8 = call float @llvm.experimental.vector.reduce.fmax.v8f32(<8 x float> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16 = call float @llvm.experimental.vector.reduce.fmax.v16f32(<16 x float> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V32 = call float @llvm.experimental.vector.reduce.fmax.v32f32(<32 x float> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'reduce_f32'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.experimental.vector.reduce.fmax.v1f32(<1 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call float @llvm.experimental.vector.reduce.fmax.v2f32(<2 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call float @llvm.experimental.vector.reduce.fmax.v4f32(<4 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call float @llvm.experimental.vector.reduce.fmax.v8f32(<8 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V16 = call float @llvm.experimental.vector.reduce.fmax.v16f32(<16 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V32 = call float @llvm.experimental.vector.reduce.fmax.v32f32(<32 x float> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_f32'
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.experimental.vector.reduce.fmax.v1f32(<1 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call float @llvm.experimental.vector.reduce.fmax.v2f32(<2 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call float @llvm.experimental.vector.reduce.fmax.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call float @llvm.experimental.vector.reduce.fmax.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16 = call float @llvm.experimental.vector.reduce.fmax.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32 = call float @llvm.experimental.vector.reduce.fmax.v32f32(<32 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_f32'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.experimental.vector.reduce.fmax.v1f32(<1 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call float @llvm.experimental.vector.reduce.fmax.v2f32(<2 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call float @llvm.experimental.vector.reduce.fmax.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call float @llvm.experimental.vector.reduce.fmax.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16 = call float @llvm.experimental.vector.reduce.fmax.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32 = call float @llvm.experimental.vector.reduce.fmax.v32f32(<32 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V1  = call float @llvm.experimental.vector.reduce.fmax.v1f32(<1 x float> undef)
  %V2  = call float @llvm.experimental.vector.reduce.fmax.v2f32(<2 x float> undef)
  %V4  = call float @llvm.experimental.vector.reduce.fmax.v4f32(<4 x float> undef)
  %V8  = call float @llvm.experimental.vector.reduce.fmax.v8f32(<8 x float> undef)
  %V16 = call float @llvm.experimental.vector.reduce.fmax.v16f32(<16 x float> undef)
  %V32 = call float @llvm.experimental.vector.reduce.fmax.v32f32(<32 x float> undef)
  ret i32 undef
}

declare double @llvm.experimental.vector.reduce.fmax.v1f64(<1 x double>)
declare double @llvm.experimental.vector.reduce.fmax.v2f64(<2 x double>)
declare double @llvm.experimental.vector.reduce.fmax.v4f64(<4 x double>)
declare double @llvm.experimental.vector.reduce.fmax.v8f64(<8 x double>)
declare double @llvm.experimental.vector.reduce.fmax.v16f64(<16 x double>)

declare float @llvm.experimental.vector.reduce.fmax.v1f32(<1 x float>)
declare float @llvm.experimental.vector.reduce.fmax.v2f32(<2 x float>)
declare float @llvm.experimental.vector.reduce.fmax.v4f32(<4 x float>)
declare float @llvm.experimental.vector.reduce.fmax.v8f32(<8 x float>)
declare float @llvm.experimental.vector.reduce.fmax.v16f32(<16 x float>)
declare float @llvm.experimental.vector.reduce.fmax.v32f32(<32 x float>)
