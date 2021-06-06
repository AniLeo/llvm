; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+sse2 | FileCheck %s -check-prefixes=SSE2
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+sse4.2 | FileCheck %s -check-prefixes=SSE42
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+avx | FileCheck %s -check-prefixes=AVX,AVX1
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+avx2 | FileCheck %s -check-prefixes=AVX,AVX2
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+xop,+avx | FileCheck %s -check-prefixes=AVX,AVX1
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+xop,+avx2 | FileCheck %s -check-prefixes=AVX,AVX2
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+avx512f | FileCheck %s -check-prefixes=AVX,AVX512,AVX512F
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze -mattr=+avx512bw | FileCheck %s -check-prefixes=AVX,AVX512,AVX512BW

; Verify the cost of vector bswap instructions.

declare <2 x i64> @llvm.bswap.v2i64(<2 x i64>)
declare <4 x i32> @llvm.bswap.v4i32(<4 x i32>)
declare <8 x i16> @llvm.bswap.v8i16(<8 x i16>)

declare <4 x i64> @llvm.bswap.v4i64(<4 x i64>)
declare <8 x i32> @llvm.bswap.v8i32(<8 x i32>)
declare <16 x i16> @llvm.bswap.v16i16(<16 x i16>)

declare <8 x i64> @llvm.bswap.v8i64(<8 x i64>)
declare <16 x i32> @llvm.bswap.v16i32(<16 x i32>)
declare <32 x i16> @llvm.bswap.v32i16(<32 x i16>)

define <2 x i64> @var_bswap_v2i64(<2 x i64> %a) {
; SSE2-LABEL: 'var_bswap_v2i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %bswap = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %bswap
;
; SSE42-LABEL: 'var_bswap_v2i64'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %bswap
;
; AVX-LABEL: 'var_bswap_v2i64'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %a)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %bswap
;
  %bswap = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %a)
  ret <2 x i64> %bswap
}

define <4 x i64> @var_bswap_v4i64(<4 x i64> %a) {
; SSE2-LABEL: 'var_bswap_v4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %bswap = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %bswap
;
; SSE42-LABEL: 'var_bswap_v4i64'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %bswap
;
; AVX1-LABEL: 'var_bswap_v4i64'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %a)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %bswap
;
; AVX2-LABEL: 'var_bswap_v4i64'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %a)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %bswap
;
; AVX512-LABEL: 'var_bswap_v4i64'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %a)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %bswap
;
  %bswap = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %a)
  ret <4 x i64> %bswap
}

define <8 x i64> @var_bswap_v8i64(<8 x i64> %a) {
; SSE2-LABEL: 'var_bswap_v8i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 28 for instruction: %bswap = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %bswap
;
; SSE42-LABEL: 'var_bswap_v8i64'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %bswap
;
; AVX1-LABEL: 'var_bswap_v8i64'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %bswap = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %a)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %bswap
;
; AVX2-LABEL: 'var_bswap_v8i64'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %a)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %bswap
;
; AVX512F-LABEL: 'var_bswap_v8i64'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %a)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %bswap
;
; AVX512BW-LABEL: 'var_bswap_v8i64'
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %a)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %bswap
;
  %bswap = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %a)
  ret <8 x i64> %bswap
}

define <4 x i32> @var_bswap_v4i32(<4 x i32> %a) {
; SSE2-LABEL: 'var_bswap_v4i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %bswap = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %bswap
;
; SSE42-LABEL: 'var_bswap_v4i32'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %bswap
;
; AVX-LABEL: 'var_bswap_v4i32'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %a)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %bswap
;
  %bswap = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %a)
  ret <4 x i32> %bswap
}

define <8 x i32> @var_bswap_v8i32(<8 x i32> %a) {
; SSE2-LABEL: 'var_bswap_v8i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %bswap = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %bswap
;
; SSE42-LABEL: 'var_bswap_v8i32'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %bswap
;
; AVX1-LABEL: 'var_bswap_v8i32'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %a)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %bswap
;
; AVX2-LABEL: 'var_bswap_v8i32'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %a)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %bswap
;
; AVX512-LABEL: 'var_bswap_v8i32'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %a)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %bswap
;
  %bswap = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %a)
  ret <8 x i32> %bswap
}

define <16 x i32> @var_bswap_v16i32(<16 x i32> %a) {
; SSE2-LABEL: 'var_bswap_v16i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 28 for instruction: %bswap = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %bswap
;
; SSE42-LABEL: 'var_bswap_v16i32'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %bswap
;
; AVX1-LABEL: 'var_bswap_v16i32'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %bswap = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %a)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %bswap
;
; AVX2-LABEL: 'var_bswap_v16i32'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %a)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %bswap
;
; AVX512F-LABEL: 'var_bswap_v16i32'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %a)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %bswap
;
; AVX512BW-LABEL: 'var_bswap_v16i32'
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %a)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %bswap
;
  %bswap = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %a)
  ret <16 x i32> %bswap
}

define <8 x i16> @var_bswap_v8i16(<8 x i16> %a) {
; SSE2-LABEL: 'var_bswap_v8i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %bswap = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %bswap
;
; SSE42-LABEL: 'var_bswap_v8i16'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %bswap
;
; AVX-LABEL: 'var_bswap_v8i16'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %a)
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %bswap
;
  %bswap = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %a)
  ret <8 x i16> %bswap
}

define <16 x i16> @var_bswap_v16i16(<16 x i16> %a) {
; SSE2-LABEL: 'var_bswap_v16i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %bswap = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %bswap
;
; SSE42-LABEL: 'var_bswap_v16i16'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %bswap
;
; AVX1-LABEL: 'var_bswap_v16i16'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %a)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %bswap
;
; AVX2-LABEL: 'var_bswap_v16i16'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %a)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %bswap
;
; AVX512-LABEL: 'var_bswap_v16i16'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %a)
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %bswap
;
  %bswap = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %a)
  ret <16 x i16> %bswap
}

define <32 x i16> @var_bswap_v32i16(<32 x i16> %a) {
; SSE2-LABEL: 'var_bswap_v32i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 28 for instruction: %bswap = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %a)
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i16> %bswap
;
; SSE42-LABEL: 'var_bswap_v32i16'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %a)
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i16> %bswap
;
; AVX1-LABEL: 'var_bswap_v32i16'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %bswap = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %a)
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i16> %bswap
;
; AVX2-LABEL: 'var_bswap_v32i16'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %a)
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i16> %bswap
;
; AVX512F-LABEL: 'var_bswap_v32i16'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %a)
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i16> %bswap
;
; AVX512BW-LABEL: 'var_bswap_v32i16'
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %a)
; AVX512BW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i16> %bswap
;
  %bswap = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %a)
  ret <32 x i16> %bswap
}
