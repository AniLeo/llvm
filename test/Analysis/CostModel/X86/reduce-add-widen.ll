; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+ssse3 | FileCheck %s --check-prefixes=CHECK,SSE,SSSE3
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512F
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512BW
; RUN: opt < %s -x86-experimental-vector-widening-legalization -cost-model -mtriple=x86_64-apple-darwin -analyze -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512DQ

define i32 @reduce_i64(i32 %arg) {
; SSE2-LABEL: 'reduce_i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSSE3-LABEL: 'reduce_i64'
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'reduce_i64'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_i64'
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_i64'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V1  = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
  %V2  = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
  %V4  = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
  %V8  = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
  %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
  ret i32 undef
}

define i32 @reduce_i32(i32 %arg) {
; SSE2-LABEL: 'reduce_i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16 = call i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V32 = call i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSSE3-LABEL: 'reduce_i32'
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16 = call i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V32 = call i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'reduce_i32'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8 = call i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V16 = call i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V32 = call i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'reduce_i32'
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V16 = call i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V32 = call i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32> undef)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'reduce_i32'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V8 = call i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V32 = call i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32> undef)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V2  = call i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32> undef)
  %V4  = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> undef)
  %V8  = call i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32> undef)
  %V16 = call i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32> undef)
  %V32 = call i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32> undef)
  ret i32 undef
}

define i32 @reduce_i16(i32 %arg) {
; SSE2-LABEL: 'reduce_i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 13 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 19 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 26 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSSE3-LABEL: 'reduce_i16'
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'reduce_i16'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'reduce_i16'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 49 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 53 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 61 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'reduce_i16'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512F-LABEL: 'reduce_i16'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512BW-LABEL: 'reduce_i16'
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512DQ-LABEL: 'reduce_i16'
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4 = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8 = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V2  = call i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16> undef)
  %V4  = call i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16> undef)
  %V8  = call i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16> undef)
  %V16 = call i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16> undef)
  %V32 = call i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16> undef)
  %V64 = call i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16> undef)
  ret i32 undef
}

define i32 @reduce_i8(i32 %arg) {
; SSE2-LABEL: 'reduce_i8'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 23 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 45 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 46 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 52 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSSE3-LABEL: 'reduce_i8'
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE42-LABEL: 'reduce_i8'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'reduce_i8'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 61 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 65 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 73 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'reduce_i8'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 26 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 27 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 29 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512F-LABEL: 'reduce_i8'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 26 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 27 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 29 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512BW-LABEL: 'reduce_i8'
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 55 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 56 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512DQ-LABEL: 'reduce_i8'
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 26 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 27 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 29 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %V2   = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
  %V4   = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
  %V8   = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
  %V16  = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
  %V32  = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
  %V64  = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
  %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
  ret i32 undef
}

declare i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64>)

declare i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32>)

declare i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16>)

declare i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8>)
