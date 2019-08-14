; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s  -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: opt < %s  -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+sse4.1 | FileCheck %s --check-prefixes=CHECK,SSE,SSE41
; RUN: opt < %s  -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: opt < %s  -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: opt < %s  -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512F
; RUN: opt < %s  -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512BW
; RUN: opt < %s  -cost-model -analyze -mtriple=x86_64-apple-macosx10.8.0 -mattr=+avx512dq | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512DQ

define i32 @add(i32 %arg) {
; SSE-LABEL: 'add'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A = zext <4 x i1> undef to <4 x i32>
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B = sext <4 x i1> undef to <4 x i32>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %C = trunc <4 x i32> undef to <4 x i1>
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %D = zext <8 x i1> undef to <8 x i32>
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %E = sext <8 x i1> undef to <8 x i32>
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F = trunc <8 x i32> undef to <8 x i1>
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %G = zext i1 undef to i32
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %H = trunc i32 undef to i1
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'add'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A = zext <4 x i1> undef to <4 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B = sext <4 x i1> undef to <4 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %C = trunc <4 x i32> undef to <4 x i1>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D = zext <8 x i1> undef to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %E = sext <8 x i1> undef to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %F = trunc <8 x i32> undef to <8 x i1>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %G = zext i1 undef to i32
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %H = trunc i32 undef to i1
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'add'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A = zext <4 x i1> undef to <4 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B = sext <4 x i1> undef to <4 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %C = trunc <4 x i32> undef to <4 x i1>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %D = zext <8 x i1> undef to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %E = sext <8 x i1> undef to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %F = trunc <8 x i32> undef to <8 x i1>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %G = zext i1 undef to i32
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %H = trunc i32 undef to i1
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'add'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %A = zext <4 x i1> undef to <4 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %B = sext <4 x i1> undef to <4 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %C = trunc <4 x i32> undef to <4 x i1>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %D = zext <8 x i1> undef to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %E = sext <8 x i1> undef to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %F = trunc <8 x i32> undef to <8 x i1>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %G = zext i1 undef to i32
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %H = trunc i32 undef to i1
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  ; -- Same size registeres --
  %A = zext <4 x i1> undef to <4 x i32>
  %B = sext <4 x i1> undef to <4 x i32>
  %C = trunc <4 x i32> undef to <4 x i1>

  ; -- Different size registers --
  %D = zext <8 x i1> undef to <8 x i32>
  %E = sext <8 x i1> undef to <8 x i32>
  %F = trunc <8 x i32> undef to <8 x i1>

  ; -- scalars --
  %G = zext i1 undef to i32
  %H = trunc i32 undef to i1

  ret i32 undef
}

define i32 @zext_sext(<8 x i1> %in) {
; SSE2-LABEL: 'zext_sext'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A1 = zext <16 x i8> undef to <16 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %A2 = sext <16 x i8> undef to <16 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %A = sext <8 x i16> undef to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %B = zext <8 x i16> undef to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %C = sext <4 x i32> undef to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %C.v8i8.z = zext <8 x i8> undef to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %C.v8i8.s = sext <8 x i8> undef to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %C.v4i16.z = zext <4 x i16> undef to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %C.v4i16.s = sext <4 x i16> undef to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %C.v4i8.z = zext <4 x i8> undef to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %C.v4i8.s = sext <4 x i8> undef to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %D = zext <4 x i32> undef to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %D1 = zext <8 x i32> undef to <8 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %D2 = sext <8 x i32> undef to <8 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %D3 = zext <16 x i16> undef to <16 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %D4 = zext <16 x i8> undef to <16 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %D5 = zext <16 x i1> undef to <16 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %E = trunc <4 x i64> undef to <4 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %F = trunc <8 x i32> undef to <8 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %F1 = trunc <16 x i16> undef to <16 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %F2 = trunc <8 x i32> undef to <8 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F3 = trunc <4 x i64> undef to <4 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %G = trunc <8 x i64> undef to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %G1 = trunc <16 x i32> undef to <16 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %G2 = trunc <16 x i32> undef to <16 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SSE41-LABEL: 'zext_sext'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %A1 = zext <16 x i8> undef to <16 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %A2 = sext <16 x i8> undef to <16 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %A = sext <8 x i16> undef to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B = zext <8 x i16> undef to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C = sext <4 x i32> undef to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C.v8i8.z = zext <8 x i8> undef to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C.v8i8.s = sext <8 x i8> undef to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C.v4i16.z = zext <4 x i16> undef to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C.v4i16.s = sext <4 x i16> undef to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C.v4i8.z = zext <4 x i8> undef to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C.v4i8.s = sext <4 x i8> undef to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %D = zext <4 x i32> undef to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %D1 = zext <8 x i32> undef to <8 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %D2 = sext <8 x i32> undef to <8 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D3 = zext <16 x i16> undef to <16 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D4 = zext <16 x i8> undef to <16 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %D5 = zext <16 x i1> undef to <16 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %E = trunc <4 x i64> undef to <4 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %F = trunc <8 x i32> undef to <8 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %F1 = trunc <16 x i16> undef to <16 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %F2 = trunc <8 x i32> undef to <8 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %F3 = trunc <4 x i64> undef to <4 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %G = trunc <8 x i64> undef to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %G1 = trunc <16 x i32> undef to <16 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %G2 = trunc <16 x i32> undef to <16 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'zext_sext'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %A1 = zext <16 x i8> undef to <16 x i16>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %A2 = sext <16 x i8> undef to <16 x i16>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %A = sext <8 x i16> undef to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %B = zext <8 x i16> undef to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %C = sext <4 x i32> undef to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %C.v8i8.z = zext <8 x i8> undef to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %C.v8i8.s = sext <8 x i8> undef to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %C.v4i16.z = zext <4 x i16> undef to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %C.v4i16.s = sext <4 x i16> undef to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %C.v4i8.z = zext <4 x i8> undef to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %C.v4i8.s = sext <4 x i8> undef to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D = zext <4 x i32> undef to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %D1 = zext <8 x i32> undef to <8 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %D2 = sext <8 x i32> undef to <8 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D3 = zext <16 x i16> undef to <16 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D4 = zext <16 x i8> undef to <16 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %D5 = zext <16 x i1> undef to <16 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %E = trunc <4 x i64> undef to <4 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %F = trunc <8 x i32> undef to <8 x i16>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %F1 = trunc <16 x i16> undef to <16 x i8>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %F2 = trunc <8 x i32> undef to <8 x i8>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %F3 = trunc <4 x i64> undef to <4 x i8>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %G = trunc <8 x i64> undef to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %G1 = trunc <16 x i32> undef to <16 x i16>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %G2 = trunc <16 x i32> undef to <16 x i8>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'zext_sext'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A1 = zext <16 x i8> undef to <16 x i16>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A2 = sext <16 x i8> undef to <16 x i16>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A = sext <8 x i16> undef to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %B = zext <8 x i16> undef to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C = sext <4 x i32> undef to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v8i8.z = zext <8 x i8> undef to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v8i8.s = sext <8 x i8> undef to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i16.z = zext <4 x i16> undef to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i16.s = sext <4 x i16> undef to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i8.z = zext <4 x i8> undef to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i8.s = sext <4 x i8> undef to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D = zext <4 x i32> undef to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %D1 = zext <8 x i32> undef to <8 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %D2 = sext <8 x i32> undef to <8 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D3 = zext <16 x i16> undef to <16 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %D4 = zext <16 x i8> undef to <16 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %D5 = zext <16 x i1> undef to <16 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %E = trunc <4 x i64> undef to <4 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %F = trunc <8 x i32> undef to <8 x i16>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %F1 = trunc <16 x i16> undef to <16 x i8>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %F2 = trunc <8 x i32> undef to <8 x i8>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %F3 = trunc <4 x i64> undef to <4 x i8>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %G = trunc <8 x i64> undef to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %G1 = trunc <16 x i32> undef to <16 x i16>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %G2 = trunc <16 x i32> undef to <16 x i8>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'zext_sext'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A1 = zext <16 x i8> undef to <16 x i16>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A2 = sext <16 x i8> undef to <16 x i16>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A = sext <8 x i16> undef to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %B = zext <8 x i16> undef to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C = sext <4 x i32> undef to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v8i8.z = zext <8 x i8> undef to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v8i8.s = sext <8 x i8> undef to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i16.z = zext <4 x i16> undef to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i16.s = sext <4 x i16> undef to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i8.z = zext <4 x i8> undef to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %C.v4i8.s = sext <4 x i8> undef to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D = zext <4 x i32> undef to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D1 = zext <8 x i32> undef to <8 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D2 = sext <8 x i32> undef to <8 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D3 = zext <16 x i16> undef to <16 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D4 = zext <16 x i8> undef to <16 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %D5 = zext <16 x i1> undef to <16 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %E = trunc <4 x i64> undef to <4 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %F = trunc <8 x i32> undef to <8 x i16>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %F1 = trunc <16 x i16> undef to <16 x i8>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %F2 = trunc <8 x i32> undef to <8 x i8>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %F3 = trunc <4 x i64> undef to <4 x i8>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %G = trunc <8 x i64> undef to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %G1 = trunc <16 x i32> undef to <16 x i16>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %G2 = trunc <16 x i32> undef to <16 x i8>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %Z = zext <8 x i1> %in to <8 x i32>
  %S = sext <8 x i1> %in to <8 x i32>

  %A1 = zext <16 x i8> undef to <16 x i16>
  %A2 = sext <16 x i8> undef to <16 x i16>
  %A = sext <8 x i16> undef to <8 x i32>
  %B = zext <8 x i16> undef to <8 x i32>
  %C = sext <4 x i32> undef to <4 x i64>

  %C.v8i8.z = zext <8 x i8> undef to <8 x i32>
  %C.v8i8.s = sext <8 x i8> undef to <8 x i32>
  %C.v4i16.z = zext <4 x i16> undef to <4 x i64>
  %C.v4i16.s = sext <4 x i16> undef to <4 x i64>

  %C.v4i8.z = zext <4 x i8> undef to <4 x i64>
  %C.v4i8.s = sext <4 x i8> undef to <4 x i64>

  %D = zext <4 x i32> undef to <4 x i64>

  %D1 = zext <8 x i32> undef to <8 x i64>

  %D2 = sext <8 x i32> undef to <8 x i64>

  %D3 = zext <16 x i16> undef to <16 x i32>
  %D4 = zext <16 x i8> undef to <16 x i32>
  %D5 = zext <16 x i1> undef to <16 x i32>

  %E = trunc <4 x i64> undef to <4 x i32>
  %F = trunc <8 x i32> undef to <8 x i16>
  %F1 = trunc <16 x i16> undef to <16 x i8>
  %F2 = trunc <8 x i32> undef to <8 x i8>
  %F3 = trunc <4 x i64> undef to <4 x i8>

  %G = trunc <8 x i64> undef to <8 x i32>
  %G1 = trunc <16 x i32> undef to <16 x i16>
  %G2 = trunc <16 x i32> undef to <16 x i8>
  ret i32 undef
}

define i32 @masks8(<8 x i1> %in) {
; SSE-LABEL: 'masks8'
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'masks8'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'masks8'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'masks8'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <8 x i1> %in to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %S = sext <8 x i1> %in to <8 x i32>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %Z = zext <8 x i1> %in to <8 x i32>
  %S = sext <8 x i1> %in to <8 x i32>
  ret i32 undef
}

define i32 @masks4(<4 x i1> %in) {
; SSE-LABEL: 'masks4'
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <4 x i1> %in to <4 x i64>
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %S = sext <4 x i1> %in to <4 x i64>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX1-LABEL: 'masks4'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %Z = zext <4 x i1> %in to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %S = sext <4 x i1> %in to <4 x i64>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX2-LABEL: 'masks4'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <4 x i1> %in to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %S = sext <4 x i1> %in to <4 x i64>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'masks4'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %Z = zext <4 x i1> %in to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %S = sext <4 x i1> %in to <4 x i64>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %Z = zext <4 x i1> %in to <4 x i64>
  %S = sext <4 x i1> %in to <4 x i64>
  ret i32 undef
}

define void @sitofp4(<4 x i1> %a, <4 x i8> %b, <4 x i16> %c, <4 x i32> %d) {
; SSE-LABEL: 'sitofp4'
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %A1 = sitofp <4 x i1> %a to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %A2 = sitofp <4 x i1> %a to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %B1 = sitofp <4 x i8> %b to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %B2 = sitofp <4 x i8> %b to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %C1 = sitofp <4 x i16> %c to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %C2 = sitofp <4 x i16> %c to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %D1 = sitofp <4 x i32> %d to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %D2 = sitofp <4 x i32> %d to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX-LABEL: 'sitofp4'
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A1 = sitofp <4 x i1> %a to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A2 = sitofp <4 x i1> %a to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %B1 = sitofp <4 x i8> %b to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %B2 = sitofp <4 x i8> %b to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %C1 = sitofp <4 x i16> %c to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %C2 = sitofp <4 x i16> %c to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D1 = sitofp <4 x i32> %d to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D2 = sitofp <4 x i32> %d to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX512-LABEL: 'sitofp4'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A1 = sitofp <4 x i1> %a to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A2 = sitofp <4 x i1> %a to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %B1 = sitofp <4 x i8> %b to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %B2 = sitofp <4 x i8> %b to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %C1 = sitofp <4 x i16> %c to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %C2 = sitofp <4 x i16> %c to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D1 = sitofp <4 x i32> %d to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D2 = sitofp <4 x i32> %d to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %A1 = sitofp <4 x i1> %a to <4 x float>
  %A2 = sitofp <4 x i1> %a to <4 x double>
  %B1 = sitofp <4 x i8> %b to <4 x float>
  %B2 = sitofp <4 x i8> %b to <4 x double>
  %C1 = sitofp <4 x i16> %c to <4 x float>
  %C2 = sitofp <4 x i16> %c to <4 x double>
  %D1 = sitofp <4 x i32> %d to <4 x float>
  %D2 = sitofp <4 x i32> %d to <4 x double>
  ret void
}

define void @sitofp8(<8 x i1> %a, <8 x i8> %b, <8 x i16> %c, <8 x i32> %d) {
; SSE-LABEL: 'sitofp8'
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %A1 = sitofp <8 x i1> %a to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %B1 = sitofp <8 x i8> %b to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %C1 = sitofp <8 x i16> %c to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %D1 = sitofp <8 x i32> %d to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX-LABEL: 'sitofp8'
; AVX-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %A1 = sitofp <8 x i1> %a to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %B1 = sitofp <8 x i8> %b to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %C1 = sitofp <8 x i16> %c to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D1 = sitofp <8 x i32> %d to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX512-LABEL: 'sitofp8'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %A1 = sitofp <8 x i1> %a to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %B1 = sitofp <8 x i8> %b to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %C1 = sitofp <8 x i16> %c to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D1 = sitofp <8 x i32> %d to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %A1 = sitofp <8 x i1> %a to <8 x float>
  %B1 = sitofp <8 x i8> %b to <8 x float>
  %C1 = sitofp <8 x i16> %c to <8 x float>
  %D1 = sitofp <8 x i32> %d to <8 x float>
  ret void
}

define void @uitofp4(<4 x i1> %a, <4 x i8> %b, <4 x i16> %c, <4 x i32> %d) {
; SSE-LABEL: 'uitofp4'
; SSE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %A1 = uitofp <4 x i1> %a to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %A2 = uitofp <4 x i1> %a to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %B1 = uitofp <4 x i8> %b to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %B2 = uitofp <4 x i8> %b to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %C1 = uitofp <4 x i16> %c to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %C2 = uitofp <4 x i16> %c to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %D1 = uitofp <4 x i32> %d to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %D2 = uitofp <4 x i32> %d to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX-LABEL: 'uitofp4'
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %A1 = uitofp <4 x i1> %a to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %A2 = uitofp <4 x i1> %a to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B1 = uitofp <4 x i8> %b to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B2 = uitofp <4 x i8> %b to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C1 = uitofp <4 x i16> %c to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C2 = uitofp <4 x i16> %c to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %D1 = uitofp <4 x i32> %d to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %D2 = uitofp <4 x i32> %d to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX512-LABEL: 'uitofp4'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %A1 = uitofp <4 x i1> %a to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %A2 = uitofp <4 x i1> %a to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B1 = uitofp <4 x i8> %b to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B2 = uitofp <4 x i8> %b to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C1 = uitofp <4 x i16> %c to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C2 = uitofp <4 x i16> %c to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D1 = uitofp <4 x i32> %d to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D2 = uitofp <4 x i32> %d to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %A1 = uitofp <4 x i1> %a to <4 x float>
  %A2 = uitofp <4 x i1> %a to <4 x double>
  %B1 = uitofp <4 x i8> %b to <4 x float>
  %B2 = uitofp <4 x i8> %b to <4 x double>
  %C1 = uitofp <4 x i16> %c to <4 x float>
  %C2 = uitofp <4 x i16> %c to <4 x double>
  %D1 = uitofp <4 x i32> %d to <4 x float>
  %D2 = uitofp <4 x i32> %d to <4 x double>
  ret void
}

define void @uitofp8(<8 x i1> %a, <8 x i8> %b, <8 x i16> %c, <8 x i32> %d) {
; SSE-LABEL: 'uitofp8'
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %A1 = uitofp <8 x i1> %a to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %B1 = uitofp <8 x i8> %b to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %C1 = uitofp <8 x i16> %c to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %D1 = uitofp <8 x i32> %d to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX1-LABEL: 'uitofp8'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %A1 = uitofp <8 x i1> %a to <8 x float>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %B1 = uitofp <8 x i8> %b to <8 x float>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %C1 = uitofp <8 x i16> %c to <8 x float>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %D1 = uitofp <8 x i32> %d to <8 x float>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX2-LABEL: 'uitofp8'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %A1 = uitofp <8 x i1> %a to <8 x float>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %B1 = uitofp <8 x i8> %b to <8 x float>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %C1 = uitofp <8 x i16> %c to <8 x float>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %D1 = uitofp <8 x i32> %d to <8 x float>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX512-LABEL: 'uitofp8'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %A1 = uitofp <8 x i1> %a to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %B1 = uitofp <8 x i8> %b to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %C1 = uitofp <8 x i16> %c to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %D1 = uitofp <8 x i32> %d to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %A1 = uitofp <8 x i1> %a to <8 x float>
  %B1 = uitofp <8 x i8> %b to <8 x float>
  %C1 = uitofp <8 x i16> %c to <8 x float>
  %D1 = uitofp <8 x i32> %d to <8 x float>
  ret void
}

define void @fp_conv(<8 x float> %a, <16 x float>%b, <4 x float> %c) {
; SSE-LABEL: 'fp_conv'
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A1 = fpext <4 x float> %c to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %A2 = fpext <8 x float> %a to <8 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A3 = fptrunc <4 x double> undef to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %A4 = fptrunc <8 x double> undef to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX-LABEL: 'fp_conv'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A1 = fpext <4 x float> %c to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A2 = fpext <8 x float> %a to <8 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A3 = fptrunc <4 x double> undef to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %A4 = fptrunc <8 x double> undef to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; AVX512-LABEL: 'fp_conv'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A1 = fpext <4 x float> %c to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A2 = fpext <8 x float> %a to <8 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A3 = fptrunc <4 x double> undef to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %A4 = fptrunc <8 x double> undef to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %A1 = fpext <4 x float> %c to <4 x double>
  %A2 = fpext <8 x float> %a to <8 x double>
  %A3 = fptrunc <4 x double> undef to <4 x float>
  %A4 = fptrunc <8 x double> undef to <8 x float>
  ret void
}
