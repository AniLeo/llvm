; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+ssse3 | FileCheck %s --check-prefixes=CHECK,SSE,SSSE3
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX1
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX2
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX512
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -passes="print<cost-model>" 2>&1 -disable-output -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=CHECK,AVX512

define <4 x i32> @test1(<4 x i32> %a) {
; CHECK-LABEL: 'test1'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %div = udiv <4 x i32> %a, <i32 7, i32 7, i32 7, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %div
;
  %div = udiv <4 x i32> %a, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %div
}

define <8 x i32> @test2(<8 x i32> %a) {
; SSE-LABEL: 'test2'
; SSE-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %div = udiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX1-LABEL: 'test2'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %div = udiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX2-LABEL: 'test2'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %div = udiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX512-LABEL: 'test2'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %div = udiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
  %div = udiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7,i32 7, i32 7, i32 7, i32 7>
  ret <8 x i32> %div
}

define <8 x i16> @test3(<8 x i16> %a) {
; CHECK-LABEL: 'test3'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = udiv <8 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %div
;
  %div = udiv <8 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <8 x i16> %div
}

define <16 x i16> @test4(<16 x i16> %a) {
; SSE-LABEL: 'test4'
; SSE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %div = udiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
; AVX1-LABEL: 'test4'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %div = udiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
; AVX2-LABEL: 'test4'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = udiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
; AVX512-LABEL: 'test4'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = udiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
  %div = udiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7,i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7,i16 7, i16 7, i16 7, i16 7>
  ret <16 x i16> %div
}

define <8 x i16> @test5(<8 x i16> %a) {
; CHECK-LABEL: 'test5'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = sdiv <8 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %div
;
  %div = sdiv <8 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <8 x i16> %div
}

define <16 x i16> @test6(<16 x i16> %a) {
; SSE-LABEL: 'test6'
; SSE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %div = sdiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
; AVX1-LABEL: 'test6'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %div = sdiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
; AVX2-LABEL: 'test6'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = sdiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
; AVX512-LABEL: 'test6'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = sdiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %div
;
  %div = sdiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7,i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7,i16 7, i16 7, i16 7, i16 7>
  ret <16 x i16> %div
}

define <16 x i8> @test7(<16 x i8> %a) {
; CHECK-LABEL: 'test7'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %div = sdiv <16 x i8> %a, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %div
;
  %div = sdiv <16 x i8> %a, <i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7>
  ret <16 x i8> %div
}

define <4 x i32> @test8(<4 x i32> %a) {
; CHECK-LABEL: 'test8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = sdiv <4 x i32> %a, <i32 7, i32 7, i32 7, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %div
;
  %div = sdiv <4 x i32> %a, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %div
}

define <8 x i32> @test9(<8 x i32> %a) {
; SSE-LABEL: 'test9'
; SSE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %div = sdiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX1-LABEL: 'test9'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %div = sdiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX2-LABEL: 'test9'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = sdiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX512-LABEL: 'test9'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %div = sdiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
  %div = sdiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7,i32 7, i32 7, i32 7, i32 7>
  ret <8 x i32> %div
}

define <8 x i32> @test10(<8 x i32> %a) {
; SSE2-LABEL: 'test10'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 38 for instruction: %div = sdiv <8 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; SSSE3-LABEL: 'test10'
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 38 for instruction: %div = sdiv <8 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; SSE42-LABEL: 'test10'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 30 for instruction: %div = sdiv <8 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX1-LABEL: 'test10'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %div = sdiv <8 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX2-LABEL: 'test10'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %div = sdiv <8 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
; AVX512-LABEL: 'test10'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %div = sdiv <8 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %div
;
  %div = sdiv <8 x i32> %a, <i32 8, i32 7, i32 7, i32 7,i32 7, i32 7, i32 7, i32 7>
  ret <8 x i32> %div
}

define <16 x i32> @test11(<16 x i32> %a) {
; SSE2-LABEL: 'test11'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 76 for instruction: %div = sdiv <16 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %div
;
; SSSE3-LABEL: 'test11'
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 76 for instruction: %div = sdiv <16 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSSE3-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %div
;
; SSE42-LABEL: 'test11'
; SSE42-NEXT:  Cost Model: Found an estimated cost of 60 for instruction: %div = sdiv <16 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; SSE42-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %div
;
; AVX1-LABEL: 'test11'
; AVX1-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %div = sdiv <16 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %div
;
; AVX2-LABEL: 'test11'
; AVX2-NEXT:  Cost Model: Found an estimated cost of 30 for instruction: %div = sdiv <16 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %div
;
; AVX512-LABEL: 'test11'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %div = sdiv <16 x i32> %a, <i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 8, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %div
;
  %div = sdiv <16 x i32> %a, <i32 8, i32 7, i32 7, i32 7,i32 7, i32 7, i32 7, i32 7, i32 8, i32 7, i32 7, i32 7,i32 7, i32 7, i32 7, i32 7>
  ret <16 x i32> %div
}
