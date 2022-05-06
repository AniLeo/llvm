; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=x86_64-unknown-linux-gnu -mattr=+sse2 | FileCheck %s -check-prefixes=SSE2
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=x86_64-unknown-linux-gnu -mattr=+sse4.1 | FileCheck %s -check-prefixes=SSE41
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=x86_64-unknown-linux-gnu -mattr=+avx | FileCheck %s -check-prefixes=AVX,AVX1
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 | FileCheck %s -check-prefixes=AVX,AVX2
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+avx512vl  | FileCheck %s -check-prefixes=AVX,AVX512,AVX512F
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512bw,+avx512vl | FileCheck %s -check-prefixes=AVX,AVX512,AVX512BW

; Verify the cost of vector select instructions.

define i32 @test_select() {
; SSE2-LABEL: 'test_select'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = select i1 undef, i64 undef, i64 undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I64 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I64 = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I64 = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = select i1 undef, i32 undef, i32 undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I32 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I32 = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16I32 = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = select i1 undef, i16 undef, i16 undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I16 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I16 = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V32I16 = select <32 x i1> undef, <32 x i16> undef, <32 x i16> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = select i1 undef, i8 undef, i8 undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I8 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I8 = select <32 x i1> undef, <32 x i8> undef, <32 x i8> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V64I8 = select <64 x i1> undef, <64 x i8> undef, <64 x i8> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE41-LABEL: 'test_select'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = select i1 undef, i64 undef, i64 undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I64 = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I64 = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = select i1 undef, i32 undef, i32 undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I32 = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I32 = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = select i1 undef, i16 undef, i16 undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = select <32 x i1> undef, <32 x i16> undef, <32 x i16> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = select i1 undef, i8 undef, i8 undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = select <32 x i1> undef, <32 x i8> undef, <32 x i8> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = select <64 x i1> undef, <64 x i8> undef, <64 x i8> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'test_select'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = select i1 undef, i64 undef, i64 undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I64 = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I64 = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = select i1 undef, i32 undef, i32 undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I32 = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I32 = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = select i1 undef, i16 undef, i16 undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = select <32 x i1> undef, <32 x i16> undef, <32 x i16> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = select i1 undef, i8 undef, i8 undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = select <32 x i1> undef, <32 x i8> undef, <32 x i8> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = select <64 x i1> undef, <64 x i8> undef, <64 x i8> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'test_select'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = select i1 undef, i64 undef, i64 undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I64 = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I64 = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = select i1 undef, i32 undef, i32 undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I32 = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I32 = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = select i1 undef, i16 undef, i16 undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I16 = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I16 = select <32 x i1> undef, <32 x i16> undef, <32 x i16> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = select i1 undef, i8 undef, i8 undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32I8 = select <32 x i1> undef, <32 x i8> undef, <32 x i8> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V64I8 = select <64 x i1> undef, <64 x i8> undef, <64 x i8> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512F-LABEL: 'test_select'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = select i1 undef, i64 undef, i64 undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I64 = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I64 = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = select i1 undef, i32 undef, i32 undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I32 = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I32 = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = select i1 undef, i16 undef, i16 undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I16 = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I16 = select <32 x i1> undef, <32 x i16> undef, <32 x i16> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = select i1 undef, i8 undef, i8 undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32I8 = select <32 x i1> undef, <32 x i8> undef, <32 x i8> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V64I8 = select <64 x i1> undef, <64 x i8> undef, <64 x i8> undef
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512BW-LABEL: 'test_select'
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = select i1 undef, i64 undef, i64 undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I64 = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I64 = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = select i1 undef, i32 undef, i32 undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I32 = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I32 = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = select i1 undef, i16 undef, i16 undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I16 = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32I16 = select <32 x i1> undef, <32 x i16> undef, <32 x i16> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = select i1 undef, i8 undef, i8 undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32I8 = select <32 x i1> undef, <32 x i8> undef, <32 x i8> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64I8 = select <64 x i1> undef, <64 x i8> undef, <64 x i8> undef
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %I64 = select i1 undef, i64 undef, i64 undef
  %V2I64 = select <2 x i1> undef, <2 x i64> undef, <2 x i64> undef
  %V4I64 = select <4 x i1> undef, <4 x i64> undef, <4 x i64> undef
  %V8I64 = select <8 x i1> undef, <8 x i64> undef, <8 x i64> undef

  %I32 = select i1 undef, i32 undef, i32 undef
  %V4I32 = select <4 x i1> undef, <4 x i32> undef, <4 x i32> undef
  %V8I32 = select <8 x i1> undef, <8 x i32> undef, <8 x i32> undef
  %V16I32 = select <16 x i1> undef, <16 x i32> undef, <16 x i32> undef

  %I16 = select i1 undef, i16 undef, i16 undef
  %V8I16 = select <8 x i1> undef, <8 x i16> undef, <8 x i16> undef
  %V16I16 = select <16 x i1> undef, <16 x i16> undef, <16 x i16> undef
  %V32I16 = select <32 x i1> undef, <32 x i16> undef, <32 x i16> undef

  %I8 = select i1 undef, i8 undef, i8 undef
  %V16I8 = select <16 x i1> undef, <16 x i8> undef, <16 x i8> undef
  %V32I8 = select <32 x i1> undef, <32 x i8> undef, <32 x i8> undef
  %V64I8 = select <64 x i1> undef, <64 x i8> undef, <64 x i8> undef

  ret i32 undef
}

define i32 @test_select_fp() {
; SSE2-LABEL: 'test_select_fp'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = select i1 undef, double undef, double undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2F64 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4F64 = select <4 x i1> undef, <4 x double> undef, <4 x double> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8F64 = select <8 x i1> undef, <8 x double> undef, <8 x double> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = select i1 undef, float undef, float undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4F32 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F32 = select <8 x i1> undef, <8 x float> undef, <8 x float> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V16F32 = select <16 x i1> undef, <16 x float> undef, <16 x float> undef
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE41-LABEL: 'test_select_fp'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = select i1 undef, double undef, double undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4F64 = select <4 x i1> undef, <4 x double> undef, <4 x double> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8F64 = select <8 x i1> undef, <8 x double> undef, <8 x double> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = select i1 undef, float undef, float undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8F32 = select <8 x i1> undef, <8 x float> undef, <8 x float> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16F32 = select <16 x i1> undef, <16 x float> undef, <16 x float> undef
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'test_select_fp'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = select i1 undef, double undef, double undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = select <4 x i1> undef, <4 x double> undef, <4 x double> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8F64 = select <8 x i1> undef, <8 x double> undef, <8 x double> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = select i1 undef, float undef, float undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = select <8 x i1> undef, <8 x float> undef, <8 x float> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16F32 = select <16 x i1> undef, <16 x float> undef, <16 x float> undef
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'test_select_fp'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = select i1 undef, double undef, double undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = select <4 x i1> undef, <4 x double> undef, <4 x double> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8F64 = select <8 x i1> undef, <8 x double> undef, <8 x double> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = select i1 undef, float undef, float undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = select <8 x i1> undef, <8 x float> undef, <8 x float> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16F32 = select <16 x i1> undef, <16 x float> undef, <16 x float> undef
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'test_select_fp'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F64 = select i1 undef, double undef, double undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2F64 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F64 = select <4 x i1> undef, <4 x double> undef, <4 x double> undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F64 = select <8 x i1> undef, <8 x double> undef, <8 x double> undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F32 = select i1 undef, float undef, float undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4F32 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8F32 = select <8 x i1> undef, <8 x float> undef, <8 x float> undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16F32 = select <16 x i1> undef, <16 x float> undef, <16 x float> undef
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %F64 = select i1 undef, double undef, double undef
  %V2F64 = select <2 x i1> undef, <2 x double> undef, <2 x double> undef
  %V4F64 = select <4 x i1> undef, <4 x double> undef, <4 x double> undef
  %V8F64 = select <8 x i1> undef, <8 x double> undef, <8 x double> undef

  %F32 = select i1 undef, float undef, float undef
  %V4F32 = select <4 x i1> undef, <4 x float> undef, <4 x float> undef
  %V8F32 = select <8 x i1> undef, <8 x float> undef, <8 x float> undef
  %V16F32 = select <16 x i1> undef, <16 x float> undef, <16 x float> undef

  ret i32 undef
}

; Immediate blend instructions for <2 x double> and <4 x float> added at SSE41.
; Integers of the same size should also use those instructions.

define <2 x i64> @test_2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: 'test_2i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %sel
;
; SSE41-LABEL: 'test_2i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %sel
;
; AVX-LABEL: 'test_2i64'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %sel
;
  %sel = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %sel
}

define <2 x double> @test_2double(<2 x double> %a, <2 x double> %b) {
; SSE2-LABEL: 'test_2double'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %sel
;
; SSE41-LABEL: 'test_2double'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %sel
;
; AVX-LABEL: 'test_2double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %sel
;
  %sel = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %sel
}

define <4 x i32> @test_4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: 'test_4i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x i32> %a, <4 x i32> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %sel
;
; SSE41-LABEL: 'test_4i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x i32> %a, <4 x i32> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %sel
;
; AVX-LABEL: 'test_4i32'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x i32> %a, <4 x i32> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %sel
}

define <4 x float> @test_4float(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: 'test_4float'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %sel
;
; SSE41-LABEL: 'test_4float'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %sel
;
; AVX-LABEL: 'test_4float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %sel
}

define <16 x i8> @test_16i8(<16 x i8> %a, <16 x i8> %b) {
; SSE2-LABEL: 'test_16i8'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <16 x i8> %a, <16 x i8> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %sel
;
; SSE41-LABEL: 'test_16i8'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <16 x i8> %a, <16 x i8> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %sel
;
; AVX-LABEL: 'test_16i8'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <16 x i8> %a, <16 x i8> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %sel
;
  %sel = select <16 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %sel
}

; Immediate blend instructions for <4 x double> and <8 x float> added at AVX.
; Integers of the same size should also use those instructions.

define <4 x i64> @test_4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-LABEL: 'test_4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i64> %a, <4 x i64> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %sel
;
; SSE41-LABEL: 'test_4i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i64> %a, <4 x i64> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %sel
;
; AVX-LABEL: 'test_4i64'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i64> %a, <4 x i64> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i64> %a, <4 x i64> %b
  ret <4 x i64> %sel
}

define <4 x double> @test_4double(<4 x double> %a, <4 x double> %b) {
; SSE2-LABEL: 'test_4double'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x double> %a, <4 x double> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x double> %sel
;
; SSE41-LABEL: 'test_4double'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x double> %a, <4 x double> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x double> %sel
;
; AVX-LABEL: 'test_4double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x double> %a, <4 x double> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x double> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x double> %a, <4 x double> %b
  ret <4 x double> %sel
}

define <8 x i32> @test_8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE2-LABEL: 'test_8i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 false>, <8 x i32> %a, <8 x i32> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %sel
;
; SSE41-LABEL: 'test_8i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 false>, <8 x i32> %a, <8 x i32> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %sel
;
; AVX-LABEL: 'test_8i32'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 false>, <8 x i32> %a, <8 x i32> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %sel
;
  %sel = select <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 false>, <8 x i32> %a, <8 x i32> %b
  ret <8 x i32> %sel
}

define <8 x float> @test_8float(<8 x float> %a, <8 x float> %b) {
; SSE2-LABEL: 'test_8float'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <8 x float> %a, <8 x float> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x float> %sel
;
; SSE41-LABEL: 'test_8float'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <8 x float> %a, <8 x float> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x float> %sel
;
; AVX-LABEL: 'test_8float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <8 x float> %a, <8 x float> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x float> %sel
;
  %sel = select <8 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <8 x float> %a, <8 x float> %b
  ret <8 x float> %sel
}

define <16 x i16> @test_16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE2-LABEL: 'test_16i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %sel
;
; SSE41-LABEL: 'test_16i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %sel
;
; AVX1-LABEL: 'test_16i16'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %sel
;
; AVX2-LABEL: 'test_16i16'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %sel
;
; AVX512-LABEL: 'test_16i16'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %sel
;
  %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
  ret <16 x i16> %sel
}

define <32 x i8> @test_32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE2-LABEL: 'test_32i8'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %sel
;
; SSE41-LABEL: 'test_32i8'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %sel
;
; AVX1-LABEL: 'test_32i8'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %sel
;
; AVX2-LABEL: 'test_32i8'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %sel
;
; AVX512-LABEL: 'test_32i8'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %sel
;
  %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
  ret <32 x i8> %sel
}

