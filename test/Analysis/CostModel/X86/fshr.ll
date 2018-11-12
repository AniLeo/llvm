; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+ssse3 | FileCheck %s --check-prefixes=CHECK,SSE,SSSE3
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512F
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512BW
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512DQ
;
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mcpu=slm | FileCheck %s --check-prefixes=SLM
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mcpu=goldmont | FileCheck %s --check-prefixes=GLM
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mcpu=bdver2 | FileCheck %s --check-prefixes=BDVER2
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mcpu=btver2 | FileCheck %s --check-prefixes=BTVER2

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

;
; Funnel Shifts
;
; TODO - Add uniform, constant and uniform-constant tests

define void @var_funnel_i64(i64 %a64, <2 x i64> %a128, <4 x i64> %a256, <8 x i64> %a512, i64 %b64, <2 x i64> %b128, <4 x i64> %b256, <8 x i64> %b512, i64 %c64, <2 x i64> %c128, <4 x i64> %c256, <8 x i64> %c512) {
; CHECK-LABEL: 'var_funnel_i64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %b64, i64 %c64)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %b128, <2 x i64> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %b256, <4 x i64> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %b512, <8 x i64> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_funnel_i64'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %b64, i64 %c64)
; SLM-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %b128, <2 x i64> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %b256, <4 x i64> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %b512, <8 x i64> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_funnel_i64'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %b64, i64 %c64)
; GLM-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %b128, <2 x i64> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %b256, <4 x i64> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %b512, <8 x i64> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_funnel_i64'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %b64, i64 %c64)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %b128, <2 x i64> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %b256, <4 x i64> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %b512, <8 x i64> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_funnel_i64'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %b64, i64 %c64)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %b128, <2 x i64> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %b256, <4 x i64> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %b512, <8 x i64> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I64    = call i64 @llvm.fshr.i64(i64 %a64, i64 %b64, i64 %c64)
  %V2I64  = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %b128, <2 x i64> %c128)
  %V4I64  = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %b256, <4 x i64> %c256)
  %V8I64  = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %b512, <8 x i64> %c512)
  ret void
}

define void @var_funnel_i32(i32 %a32, <4 x i32> %a128, <8 x i32> %a256, <16 x i32> %a512, i32 %b32, <4 x i32> %b128, <8 x i32> %b256, <16 x i32> %b512, i32 %c32, <4 x i32> %c128, <8 x i32> %c256, <16 x i32> %c512) {
; CHECK-LABEL: 'var_funnel_i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %b32, i32 %c32)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %b128, <4 x i32> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %b256, <8 x i32> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %b512, <16 x i32> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_funnel_i32'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %b32, i32 %c32)
; SLM-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %b128, <4 x i32> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %b256, <8 x i32> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %b512, <16 x i32> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_funnel_i32'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %b32, i32 %c32)
; GLM-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %b128, <4 x i32> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %b256, <8 x i32> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %b512, <16 x i32> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_funnel_i32'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %b32, i32 %c32)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %b128, <4 x i32> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %b256, <8 x i32> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %b512, <16 x i32> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_funnel_i32'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %b32, i32 %c32)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %b128, <4 x i32> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %b256, <8 x i32> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %b512, <16 x i32> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I32   = call i32 @llvm.fshr.i32(i32 %a32, i32 %b32, i32 %c32)
  %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %b128, <4 x i32> %c128)
  %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %b256, <8 x i32> %c256)
  %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %b512, <16 x i32> %c512)
  ret void
}

define void @var_funnel_i16(i16 %a16, <8 x i16> %a128, <16 x i16> %a256, <32 x i16> %a512, i16 %b16, <8 x i16> %b128, <16 x i16> %b256, <32 x i16> %b512, i16 %c16, <8 x i16> %c128, <16 x i16> %c256, <32 x i16> %c512) {
; CHECK-LABEL: 'var_funnel_i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %b16, i16 %c16)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %b128, <8 x i16> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %b256, <16 x i16> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %b512, <32 x i16> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_funnel_i16'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %b16, i16 %c16)
; SLM-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %b128, <8 x i16> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %b256, <16 x i16> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %b512, <32 x i16> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_funnel_i16'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %b16, i16 %c16)
; GLM-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %b128, <8 x i16> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %b256, <16 x i16> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %b512, <32 x i16> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_funnel_i16'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %b16, i16 %c16)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %b128, <8 x i16> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %b256, <16 x i16> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %b512, <32 x i16> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_funnel_i16'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %b16, i16 %c16)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %b128, <8 x i16> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %b256, <16 x i16> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %b512, <32 x i16> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I16    = call i16 @llvm.fshr.i16(i16 %a16, i16 %b16, i16 %c16)
  %V8I16  = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %b128, <8 x i16> %c128)
  %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %b256, <16 x i16> %c256)
  %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %b512, <32 x i16> %c512)
  ret void
}

define void @var_funnel_i8(i8 %a8, <16 x i8> %a128, <32 x i8> %a256, <64 x i8> %a512, i8 %b8, <16 x i8> %b128, <32 x i8> %b256, <64 x i8> %b512, i8 %c8, <16 x i8> %c128, <32 x i8> %c256, <64 x i8> %c512) {
; CHECK-LABEL: 'var_funnel_i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %b8, i8 %c8)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %b128, <16 x i8> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %b256, <32 x i8> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 320 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %b512, <64 x i8> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_funnel_i8'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %b8, i8 %c8)
; SLM-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %b128, <16 x i8> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %b256, <32 x i8> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 320 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %b512, <64 x i8> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_funnel_i8'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %b8, i8 %c8)
; GLM-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %b128, <16 x i8> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %b256, <32 x i8> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 320 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %b512, <64 x i8> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_funnel_i8'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %b8, i8 %c8)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %b128, <16 x i8> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %b256, <32 x i8> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 320 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %b512, <64 x i8> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_funnel_i8'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %b8, i8 %c8)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %b128, <16 x i8> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %b256, <32 x i8> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 320 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %b512, <64 x i8> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I8    = call i8 @llvm.fshr.i8(i8 %a8, i8 %b8, i8 %c8)
  %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %b128, <16 x i8> %c128)
  %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %b256, <32 x i8> %c256)
  %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %b512, <64 x i8> %c512)
  ret void
}

;
; Unary Funnel Shifts (Rotates)
;
; TODO - Add uniform, constant and uniform-constant tests

define void @var_rotate_i64(i64 %a64, <2 x i64> %a128, <4 x i64> %a256, <8 x i64> %a512, i64 %c64, <2 x i64> %c128, <4 x i64> %c256, <8 x i64> %c512) {
; CHECK-LABEL: 'var_rotate_i64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %a64, i64 %c64)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %a128, <2 x i64> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %a256, <4 x i64> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %a512, <8 x i64> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_rotate_i64'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %a64, i64 %c64)
; SLM-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %a128, <2 x i64> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %a256, <4 x i64> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %a512, <8 x i64> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_rotate_i64'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %a64, i64 %c64)
; GLM-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %a128, <2 x i64> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %a256, <4 x i64> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %a512, <8 x i64> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_rotate_i64'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %a64, i64 %c64)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %a128, <2 x i64> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %a256, <4 x i64> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %a512, <8 x i64> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_rotate_i64'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = call i64 @llvm.fshr.i64(i64 %a64, i64 %a64, i64 %c64)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V2I64 = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %a128, <2 x i64> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V4I64 = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %a256, <4 x i64> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I64 = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %a512, <8 x i64> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I64    = call i64 @llvm.fshr.i64(i64 %a64, i64 %a64, i64 %c64)
  %V2I64  = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %a128, <2 x i64> %a128, <2 x i64> %c128)
  %V4I64  = call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %a256, <4 x i64> %a256, <4 x i64> %c256)
  %V8I64  = call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %a512, <8 x i64> %a512, <8 x i64> %c512)
  ret void
}

define void @var_rotate_i32(i32 %a32, <4 x i32> %a128, <8 x i32> %a256, <16 x i32> %a512, i32 %c32, <4 x i32> %c128, <8 x i32> %c256, <16 x i32> %c512) {
; CHECK-LABEL: 'var_rotate_i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %a32, i32 %c32)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %a128, <4 x i32> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %a256, <8 x i32> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %a512, <16 x i32> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_rotate_i32'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %a32, i32 %c32)
; SLM-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %a128, <4 x i32> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %a256, <8 x i32> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %a512, <16 x i32> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_rotate_i32'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %a32, i32 %c32)
; GLM-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %a128, <4 x i32> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %a256, <8 x i32> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %a512, <16 x i32> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_rotate_i32'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %a32, i32 %c32)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %a128, <4 x i32> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %a256, <8 x i32> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %a512, <16 x i32> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_rotate_i32'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = call i32 @llvm.fshr.i32(i32 %a32, i32 %a32, i32 %c32)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %a128, <4 x i32> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %a256, <8 x i32> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %a512, <16 x i32> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I32   = call i32 @llvm.fshr.i32(i32 %a32, i32 %a32, i32 %c32)
  %V2I32 = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %a128, <4 x i32> %a128, <4 x i32> %c128)
  %V4I32 = call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %a256, <8 x i32> %a256, <8 x i32> %c256)
  %V8I32 = call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %a512, <16 x i32> %a512, <16 x i32> %c512)
  ret void
}

define void @var_rotate_i16(i16 %a16, <8 x i16> %a128, <16 x i16> %a256, <32 x i16> %a512, i16 %c16, <8 x i16> %c128, <16 x i16> %c256, <32 x i16> %c512) {
; CHECK-LABEL: 'var_rotate_i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %a16, i16 %c16)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %a128, <8 x i16> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %a256, <16 x i16> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %a512, <32 x i16> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_rotate_i16'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %a16, i16 %c16)
; SLM-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %a128, <8 x i16> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %a256, <16 x i16> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %a512, <32 x i16> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_rotate_i16'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %a16, i16 %c16)
; GLM-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %a128, <8 x i16> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %a256, <16 x i16> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %a512, <32 x i16> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_rotate_i16'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %a16, i16 %c16)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %a128, <8 x i16> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %a256, <16 x i16> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %a512, <32 x i16> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_rotate_i16'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = call i16 @llvm.fshr.i16(i16 %a16, i16 %a16, i16 %c16)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %V8I16 = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %a128, <8 x i16> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %a256, <16 x i16> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %a512, <32 x i16> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I16    = call i16 @llvm.fshr.i16(i16 %a16, i16 %a16, i16 %c16)
  %V8I16  = call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %a128, <8 x i16> %a128, <8 x i16> %c128)
  %V16I16 = call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %a256, <16 x i16> %a256, <16 x i16> %c256)
  %V32I16 = call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %a512, <32 x i16> %a512, <32 x i16> %c512)
  ret void
}

define void @var_rotate_i8(i8 %a8, <16 x i8> %a128, <32 x i8> %a256, <64 x i8> %a512, i8 %c8, <16 x i8> %c128, <32 x i8> %c256, <64 x i8> %c512) {
; CHECK-LABEL: 'var_rotate_i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %a8, i8 %c8)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %a128, <16 x i8> %c128)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %a256, <32 x i8> %c256)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 256 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %a512, <64 x i8> %c512)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SLM-LABEL: 'var_rotate_i8'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %a8, i8 %c8)
; SLM-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %a128, <16 x i8> %c128)
; SLM-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %a256, <32 x i8> %c256)
; SLM-NEXT:  Cost Model: Found an estimated cost of 256 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %a512, <64 x i8> %c512)
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; GLM-LABEL: 'var_rotate_i8'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %a8, i8 %c8)
; GLM-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %a128, <16 x i8> %c128)
; GLM-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %a256, <32 x i8> %c256)
; GLM-NEXT:  Cost Model: Found an estimated cost of 256 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %a512, <64 x i8> %c512)
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BDVER2-LABEL: 'var_rotate_i8'
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %a8, i8 %c8)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %a128, <16 x i8> %c128)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %a256, <32 x i8> %c256)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 256 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %a512, <64 x i8> %c512)
; BDVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; BTVER2-LABEL: 'var_rotate_i8'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = call i8 @llvm.fshr.i8(i8 %a8, i8 %a8, i8 %c8)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %a128, <16 x i8> %c128)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %a256, <32 x i8> %c256)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 256 for instruction: %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %a512, <64 x i8> %c512)
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %I8    = call i8 @llvm.fshr.i8(i8 %a8, i8 %a8, i8 %c8)
  %V16I8 = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a128, <16 x i8> %a128, <16 x i8> %c128)
  %V32I8 = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a256, <32 x i8> %a256, <32 x i8> %c256)
  %V64I8 = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a512, <64 x i8> %a512, <64 x i8> %c512)
  ret void
}

declare i64 @llvm.fshr.i64(i64, i64, i64)
declare i32 @llvm.fshr.i32(i32, i32, i32)
declare i16 @llvm.fshr.i16(i16, i16, i16)
declare i8  @llvm.fshr.i8 (i8,  i8,  i8)

declare <2 x i64>  @llvm.fshr.v2i64(<2 x i64>, <2 x i64>, <2 x i64>)
declare <4 x i32>  @llvm.fshr.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)
declare <8 x i16>  @llvm.fshr.v8i16(<8 x i16>, <8 x i16>, <8 x i16>)
declare <16 x i8>  @llvm.fshr.v16i8(<16 x i8>, <16 x i8>, <16 x i8>)

declare <4 x i64>  @llvm.fshr.v4i64(<4 x i64>, <4 x i64>, <4 x i64>)
declare <8 x i32>  @llvm.fshr.v8i32(<8 x i32>, <8 x i32>, <8 x i32>)
declare <16 x i16> @llvm.fshr.v16i16(<16 x i16>, <16 x i16>, <16 x i16>)
declare <32 x i8>  @llvm.fshr.v32i8(<32 x i8>, <32 x i8>, <32 x i8>)

declare <8 x i64>  @llvm.fshr.v8i64(<8 x i64>, <8 x i64>, <8 x i64>)
declare <16 x i32> @llvm.fshr.v16i32(<16 x i32>, <16 x i32>, <16 x i32>)
declare <32 x i16> @llvm.fshr.v32i16(<32 x i16>, <32 x i16>, <32 x i16>)
declare <64 x i8>  @llvm.fshr.v64i8(<64 x i8>, <64 x i8>, <64 x i8>)
