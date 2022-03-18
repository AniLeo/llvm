; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+ssse3 | FileCheck %s --check-prefixes=SSE
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+avx | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+avx2 | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+avx512f | FileCheck %s --check-prefixes=AVX512
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=AVX512
; RUN: opt < %s -passes="print<cost-model>" -mtriple=x86_64-apple-darwin 2>&1 -disable-output -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=AVX512

define i32 @reduce_f64(i32 %arg) {
; SSE-LABEL: 'reduce_f64'
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_f64'
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_f64'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V1  = call double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
  %V2  = call double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
  %V4  = call double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
  %V8  = call double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
  %V16 = call double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
  ret i32 undef
}

define i32 @reduce_f32(i32 %arg) {
; SSE-LABEL: 'reduce_f32'
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %V32 = call float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_f32'
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V32 = call float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_f32'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16 = call float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V32 = call float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V1  = call float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
  %V2  = call float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
  %V4  = call float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
  %V8  = call float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
  %V16 = call float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
  %V32 = call float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
  ret i32 undef
}

; Fast Reductions

define i32 @reduce_f64_fast(i32 %arg) {
; SSE-LABEL: 'reduce_f64_fast'
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call fast double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call fast double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call fast double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call fast double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call fast double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_f64_fast'
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call fast double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call fast double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call fast double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call fast double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call fast double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_f64_fast'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call fast double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call fast double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call fast double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call fast double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call fast double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V1  = call fast double @llvm.vector.reduce.fmax.v1f64(<1 x double> undef)
  %V2  = call fast double @llvm.vector.reduce.fmax.v2f64(<2 x double> undef)
  %V4  = call fast double @llvm.vector.reduce.fmax.v4f64(<4 x double> undef)
  %V8  = call fast double @llvm.vector.reduce.fmax.v8f64(<8 x double> undef)
  %V16 = call fast double @llvm.vector.reduce.fmax.v16f64(<16 x double> undef)
  ret i32 undef
}

define i32 @reduce_f32_fast(i32 %arg) {
; SSE-LABEL: 'reduce_f32_fast'
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call fast float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call fast float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call fast float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call fast float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call fast float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %V32 = call fast float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_f32_fast'
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call fast float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call fast float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call fast float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call fast float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V16 = call fast float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V32 = call fast float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_f32_fast'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call fast float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call fast float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call fast float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call fast float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16 = call fast float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V32 = call fast float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V1  = call fast float @llvm.vector.reduce.fmax.v1f32(<1 x float> undef)
  %V2  = call fast float @llvm.vector.reduce.fmax.v2f32(<2 x float> undef)
  %V4  = call fast float @llvm.vector.reduce.fmax.v4f32(<4 x float> undef)
  %V8  = call fast float @llvm.vector.reduce.fmax.v8f32(<8 x float> undef)
  %V16 = call fast float @llvm.vector.reduce.fmax.v16f32(<16 x float> undef)
  %V32 = call fast float @llvm.vector.reduce.fmax.v32f32(<32 x float> undef)
  ret i32 undef
}

declare double @llvm.vector.reduce.fmax.v1f64(<1 x double>)
declare double @llvm.vector.reduce.fmax.v2f64(<2 x double>)
declare double @llvm.vector.reduce.fmax.v4f64(<4 x double>)
declare double @llvm.vector.reduce.fmax.v8f64(<8 x double>)
declare double @llvm.vector.reduce.fmax.v16f64(<16 x double>)

declare float @llvm.vector.reduce.fmax.v1f32(<1 x float>)
declare float @llvm.vector.reduce.fmax.v2f32(<2 x float>)
declare float @llvm.vector.reduce.fmax.v4f32(<4 x float>)
declare float @llvm.vector.reduce.fmax.v8f32(<8 x float>)
declare float @llvm.vector.reduce.fmax.v16f32(<16 x float>)
declare float @llvm.vector.reduce.fmax.v32f32(<32 x float>)
