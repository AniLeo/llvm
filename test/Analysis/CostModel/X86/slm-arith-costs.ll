; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -cost-model -analyze -mcpu=slm | FileCheck %s --check-prefixes=CHECK,SLM
; RUN: opt < %s -cost-model -analyze -mcpu=goldmont | FileCheck %s --check-prefixes=CHECK,GLM
; RUN: opt < %s -cost-model -analyze -mcpu=goldmont-plus | FileCheck %s --check-prefixes=CHECK,GLM

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define <2 x i64> @slm-costs_64_vector_add(<2 x i64> %a, <2 x i64> %b) {
; SLM-LABEL: 'slm-costs_64_vector_add'
; SLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = add <2 x i64> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %res
;
; GLM-LABEL: 'slm-costs_64_vector_add'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = add <2 x i64> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %res
;
entry:
  %res = add <2 x i64> %a, %b
  ret <2 x i64> %res
}

define <2 x i64> @slm-costs_64_vector_sub(<2 x i64> %a, <2 x i64> %b) {
; SLM-LABEL: 'slm-costs_64_vector_sub'
; SLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = sub <2 x i64> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %res
;
; GLM-LABEL: 'slm-costs_64_vector_sub'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = sub <2 x i64> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %res
;
entry:
  %res = sub <2 x i64> %a, %b
  ret <2 x i64> %res
}

; 8bit mul
define i8 @slm-costs_8_scalar_mul(i8 %a, i8 %b)  {
; CHECK-LABEL: 'slm-costs_8_scalar_mul'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = mul nsw i8 %a, %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %res
;
entry:
  %res = mul nsw i8 %a, %b
  ret i8 %res
}

define <2 x i8> @slm-costs_8_v2_mul(<2 x i8> %a, <2 x i8> %b)  {
; SLM-LABEL: 'slm-costs_8_v2_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <2 x i8> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i8> %res
;
; GLM-LABEL: 'slm-costs_8_v2_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = mul nsw <2 x i8> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i8> %res
;
entry:
  %res = mul nsw <2 x i8> %a, %b
  ret <2 x i8> %res
}

define <4 x i8> @slm-costs_8_v4_mul(<4 x i8> %a, <4 x i8> %b)  {
; SLM-LABEL: 'slm-costs_8_v4_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <4 x i8> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i8> %res
;
; GLM-LABEL: 'slm-costs_8_v4_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = mul nsw <4 x i8> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i8> %res
;
entry:
  %res = mul nsw <4 x i8> %a, %b
  ret <4 x i8> %res
}

define <4 x i32> @slm-costs_8_v4_zext_mul(<4 x i8> %a)  {
; SLM-LABEL: 'slm-costs_8_v4_zext_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i8> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %res = mul nsw <4 x i32> %zext, <i32 255, i32 255, i32 255, i32 255>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_8_v4_zext_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i8> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %zext, <i32 255, i32 255, i32 255, i32 255>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %zext = zext <4 x i8> %a to <4 x i32>
  %res = mul nsw <4 x i32> %zext, <i32 255, i32 255, i32 255, i32 255>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_8_v4_zext_mul_fail(<4 x i8> %a)  {
; SLM-LABEL: 'slm-costs_8_v4_zext_mul_fail'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i8> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <4 x i32> %zext, <i32 255, i32 255, i32 -1, i32 255>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_8_v4_zext_mul_fail'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i8> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %zext, <i32 255, i32 255, i32 -1, i32 255>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %zext = zext <4 x i8> %a to <4 x i32>
  %res = mul nsw <4 x i32> %zext, <i32 255, i32 255, i32 -1, i32 255>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_8_v4_zext_mul_fail_2(<4 x i8> %a)  {
; SLM-LABEL: 'slm-costs_8_v4_zext_mul_fail_2'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i8> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <4 x i32> %zext, <i32 255, i32 256, i32 255, i32 255>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_8_v4_zext_mul_fail_2'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i8> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %zext, <i32 255, i32 256, i32 255, i32 255>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %zext = zext <4 x i8> %a to <4 x i32>
  %res = mul nsw <4 x i32> %zext, <i32 255, i32 256, i32 255, i32 255>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_8_v4_sext_mul(<4 x i8> %a)  {
; SLM-LABEL: 'slm-costs_8_v4_sext_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i8> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %res = mul nsw <4 x i32> %sext, <i32 127, i32 -128, i32 127, i32 -128>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_8_v4_sext_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i8> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %sext, <i32 127, i32 -128, i32 127, i32 -128>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %sext = sext <4 x i8> %a to <4 x i32>
  %res = mul nsw <4 x i32> %sext, <i32 127, i32 -128, i32 127, i32 -128>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_8_v4_sext_mul_fail(<4 x i8> %a)  {
; SLM-LABEL: 'slm-costs_8_v4_sext_mul_fail'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i8> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <4 x i32> %sext, <i32 127, i32 -128, i32 128, i32 -128>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_8_v4_sext_mul_fail'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i8> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %sext, <i32 127, i32 -128, i32 128, i32 -128>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %sext = sext <4 x i8> %a to <4 x i32>
  %res = mul nsw <4 x i32> %sext, <i32 127, i32 -128, i32 128, i32 -128>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_8_v4_sext_mul_fail_2(<4 x i8> %a)  {
; SLM-LABEL: 'slm-costs_8_v4_sext_mul_fail_2'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i8> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <4 x i32> %sext, <i32 127, i32 -129, i32 127, i32 -128>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_8_v4_sext_mul_fail_2'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i8> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %sext, <i32 127, i32 -129, i32 127, i32 -128>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %sext = sext <4 x i8> %a to <4 x i32>
  %res = mul nsw <4 x i32> %sext, <i32 127, i32 -129, i32 127, i32 -128>
  ret <4 x i32> %res
}

define <8 x i8> @slm-costs_8_v8_mul(<8 x i8> %a, <8 x i8> %b)  {
; SLM-LABEL: 'slm-costs_8_v8_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <8 x i8> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i8> %res
;
; GLM-LABEL: 'slm-costs_8_v8_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = mul nsw <8 x i8> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i8> %res
;
entry:
  %res = mul nsw <8 x i8> %a, %b
  ret <8 x i8> %res
}

define <16 x i8> @slm-costs_8_v16_mul(<16 x i8> %a, <16 x i8> %b)  {
; SLM-LABEL: 'slm-costs_8_v16_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %res = mul nsw <16 x i8> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %res
;
; GLM-LABEL: 'slm-costs_8_v16_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %res = mul nsw <16 x i8> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %res
;
entry:
  %res = mul nsw <16 x i8> %a, %b
  ret <16 x i8> %res
}

; 16bit mul
define i16 @slm-costs_16_scalar_mul(i16 %a, i16 %b)  {
; CHECK-LABEL: 'slm-costs_16_scalar_mul'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = mul nsw i16 %a, %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %res
;
entry:
  %res = mul nsw i16 %a, %b
  ret i16 %res
}

define <2 x i16> @slm-costs_16_v2_mul(<2 x i16> %a, <2 x i16> %b)  {
; SLM-LABEL: 'slm-costs_16_v2_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <2 x i16> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i16> %res
;
; GLM-LABEL: 'slm-costs_16_v2_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = mul nsw <2 x i16> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i16> %res
;
entry:
  %res = mul nsw <2 x i16> %a, %b
  ret <2 x i16> %res
}

define <4 x i16> @slm-costs_16_v4_mul(<4 x i16> %a, <4 x i16> %b)  {
; SLM-LABEL: 'slm-costs_16_v4_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i16> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i16> %res
;
; GLM-LABEL: 'slm-costs_16_v4_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = mul nsw <4 x i16> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i16> %res
;
entry:
  %res = mul nsw <4 x i16> %a, %b
  ret <4 x i16> %res
}

define <4 x i32> @slm-costs_16_v4_zext_mul(<4 x i16> %a)  {
; SLM-LABEL: 'slm-costs_16_v4_zext_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i16> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <4 x i32> %zext, <i32 65535, i32 65535, i32 65535, i32 65535>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_16_v4_zext_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i16> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %zext, <i32 65535, i32 65535, i32 65535, i32 65535>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %zext = zext <4 x i16> %a to <4 x i32>
  %res = mul nsw <4 x i32> %zext, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_16_v4_zext_mul_fail(<4 x i16> %a)  {
; SLM-LABEL: 'slm-costs_16_v4_zext_mul_fail'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i16> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %res = mul nsw <4 x i32> %zext, <i32 -1, i32 65535, i32 65535, i32 65535>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_16_v4_zext_mul_fail'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i16> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %zext, <i32 -1, i32 65535, i32 65535, i32 65535>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %zext = zext <4 x i16> %a to <4 x i32>
  %res = mul nsw <4 x i32> %zext, <i32 -1, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_16_v4_zext_mul_fail_2(<4 x i16> %a)  {
; SLM-LABEL: 'slm-costs_16_v4_zext_mul_fail_2'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i16> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %res = mul nsw <4 x i32> %zext, <i32 65536, i32 65535, i32 65535, i32 65535>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_16_v4_zext_mul_fail_2'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zext = zext <4 x i16> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %zext, <i32 65536, i32 65535, i32 65535, i32 65535>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %zext = zext <4 x i16> %a to <4 x i32>
  %res = mul nsw <4 x i32> %zext, <i32 65536, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_16_v4_sext_mul(<4 x i16> %a)  {
; SLM-LABEL: 'slm-costs_16_v4_sext_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i16> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32767, i32 -32768>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_16_v4_sext_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i16> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32767, i32 -32768>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %sext = sext <4 x i16> %a to <4 x i32>
  %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32767, i32 -32768>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_16_v4_sext_mul_fail(<4 x i16> %a)  {
; SLM-LABEL: 'slm-costs_16_v4_sext_mul_fail'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i16> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32768, i32 -32768>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_16_v4_sext_mul_fail'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i16> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32768, i32 -32768>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %sext = sext <4 x i16> %a to <4 x i32>
  %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32768, i32 -32768>
  ret <4 x i32> %res
}

define <4 x i32> @slm-costs_16_v4_sext_mul_fail_2(<4 x i16> %a)  {
; SLM-LABEL: 'slm-costs_16_v4_sext_mul_fail_2'
; SLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i16> %a to <4 x i32>
; SLM-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32767, i32 -32769>
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_16_v4_sext_mul_fail_2'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sext = sext <4 x i16> %a to <4 x i32>
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32767, i32 -32769>
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %sext = sext <4 x i16> %a to <4 x i32>
  %res = mul nsw <4 x i32> %sext, <i32 32767, i32 -32768, i32 32767, i32 -32769>
  ret <4 x i32> %res
}

define <8 x i16> @slm-costs_16_v8_mul(<8 x i16> %a, <8 x i16> %b)  {
; SLM-LABEL: 'slm-costs_16_v8_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <8 x i16> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %res
;
; GLM-LABEL: 'slm-costs_16_v8_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = mul nsw <8 x i16> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %res
;
entry:
  %res = mul nsw <8 x i16> %a, %b
  ret <8 x i16> %res
}

define <16 x i16> @slm-costs_16_v16_mul(<16 x i16> %a, <16 x i16> %b)  {
; SLM-LABEL: 'slm-costs_16_v16_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = mul nsw <16 x i16> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %res
;
; GLM-LABEL: 'slm-costs_16_v16_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <16 x i16> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %res
;
entry:
  %res = mul nsw <16 x i16> %a, %b
  ret <16 x i16> %res
}

; 32bit mul
define i32 @slm-costs_32_scalar_mul(i32 %a, i32 %b)  {
; CHECK-LABEL: 'slm-costs_32_scalar_mul'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = mul nsw i32 %a, %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %res
;
entry:
  %res = mul nsw i32 %a, %b
  ret i32 %res
}

define <2 x i32> @slm-costs_32_v2_mul(<2 x i32> %a, <2 x i32> %b)  {
; SLM-LABEL: 'slm-costs_32_v2_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %res = mul nsw <2 x i32> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i32> %res
;
; GLM-LABEL: 'slm-costs_32_v2_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <2 x i32> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i32> %res
;
entry:
  %res = mul nsw <2 x i32> %a, %b
  ret <2 x i32> %res
}

define <4 x i32> @slm-costs_32_v4_mul(<4 x i32> %a, <4 x i32> %b)  {
; SLM-LABEL: 'slm-costs_32_v4_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %res = mul nsw <4 x i32> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
; GLM-LABEL: 'slm-costs_32_v4_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = mul nsw <4 x i32> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %res
;
entry:
  %res = mul nsw <4 x i32> %a, %b
  ret <4 x i32> %res
}

define <8 x i32> @slm-costs_32_v8_mul(<8 x i32> %a, <8 x i32> %b)  {
; SLM-LABEL: 'slm-costs_32_v8_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %res = mul nsw <8 x i32> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %res
;
; GLM-LABEL: 'slm-costs_32_v8_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = mul nsw <8 x i32> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %res
;
entry:
  %res = mul nsw <8 x i32> %a, %b
  ret <8 x i32> %res
}

define <16 x i32> @slm-costs_32_v16_mul(<16 x i32> %a, <16 x i32> %b)  {
; SLM-LABEL: 'slm-costs_32_v16_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 44 for instruction: %res = mul nsw <16 x i32> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %res
;
; GLM-LABEL: 'slm-costs_32_v16_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %res = mul nsw <16 x i32> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i32> %res
;
entry:
  %res = mul nsw <16 x i32> %a, %b
  ret <16 x i32> %res
}

; 64bit mul
define i64 @slm-costs_64_scalar_mul(i64 %a, i64 %b)  {
; CHECK-LABEL: 'slm-costs_64_scalar_mul'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = mul nsw i64 %a, %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i64 %res
;
entry:
  %res = mul nsw i64 %a, %b
  ret i64 %res
}

define <2 x i64> @slm-costs_64_v2_mul(<2 x i64> %a, <2 x i64> %b)  {
; SLM-LABEL: 'slm-costs_64_v2_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 17 for instruction: %res = mul nsw <2 x i64> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %res
;
; GLM-LABEL: 'slm-costs_64_v2_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %res = mul nsw <2 x i64> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %res
;
entry:
  %res = mul nsw <2 x i64> %a, %b
  ret <2 x i64> %res
}

define <4 x i64> @slm-costs_64_v4_mul(<4 x i64> %a, <4 x i64> %b)  {
; SLM-LABEL: 'slm-costs_64_v4_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %res = mul nsw <4 x i64> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %res
;
; GLM-LABEL: 'slm-costs_64_v4_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %res = mul nsw <4 x i64> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %res
;
entry:
  %res = mul nsw <4 x i64> %a, %b
  ret <4 x i64> %res
}

define <8 x i64> @slm-costs_64_v8_mul(<8 x i64> %a, <8 x i64> %b)  {
; SLM-LABEL: 'slm-costs_64_v8_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 68 for instruction: %res = mul nsw <8 x i64> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %res
;
; GLM-LABEL: 'slm-costs_64_v8_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %res = mul nsw <8 x i64> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i64> %res
;
entry:
  %res = mul nsw <8 x i64> %a, %b
  ret <8 x i64> %res
}

define <16 x i64> @slm-costs_64_v16_mul(<16 x i64> %a, <16 x i64> %b)  {
; SLM-LABEL: 'slm-costs_64_v16_mul'
; SLM-NEXT:  Cost Model: Found an estimated cost of 136 for instruction: %res = mul nsw <16 x i64> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i64> %res
;
; GLM-LABEL: 'slm-costs_64_v16_mul'
; GLM-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %res = mul nsw <16 x i64> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i64> %res
;
entry:
  %res = mul nsw <16 x i64> %a, %b
  ret <16 x i64> %res
}

; mulsd
define double @slm-costs_mulsd(double %a, double %b)  {
; SLM-LABEL: 'slm-costs_mulsd'
; SLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = fmul double %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret double %res
;
; GLM-LABEL: 'slm-costs_mulsd'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = fmul double %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret double %res
;
entry:
  %res = fmul double %a, %b
  ret double %res
}

; mulpd
define <2 x double> @slm-costs_mulpd(<2 x double> %a, <2 x double> %b)  {
; SLM-LABEL: 'slm-costs_mulpd'
; SLM-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %res = fmul <2 x double> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
; GLM-LABEL: 'slm-costs_mulpd'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = fmul <2 x double> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
entry:
  %res = fmul <2 x double> %a, %b
  ret <2 x double> %res
}

; mulps
define <4 x float> @slm-costs_mulps(<4 x float> %a, <4 x float> %b)  {
; SLM-LABEL: 'slm-costs_mulps'
; SLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = fmul <4 x float> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %res
;
; GLM-LABEL: 'slm-costs_mulps'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = fmul <4 x float> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %res
;
entry:
  %res = fmul <4 x float> %a, %b
  ret <4 x float> %res
}

; divss
define float @slm-costs_divss(float %a, float %b)  {
; SLM-LABEL: 'slm-costs_divss'
; SLM-NEXT:  Cost Model: Found an estimated cost of 17 for instruction: %res = fdiv float %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret float %res
;
; GLM-LABEL: 'slm-costs_divss'
; GLM-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %res = fdiv float %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret float %res
;
entry:
  %res = fdiv float %a, %b
  ret float %res
}

; divps
define <4 x float> @slm-costs_divps(<4 x float> %a, <4 x float> %b)  {
; SLM-LABEL: 'slm-costs_divps'
; SLM-NEXT:  Cost Model: Found an estimated cost of 39 for instruction: %res = fdiv <4 x float> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %res
;
; GLM-LABEL: 'slm-costs_divps'
; GLM-NEXT:  Cost Model: Found an estimated cost of 35 for instruction: %res = fdiv <4 x float> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %res
;
entry:
  %res = fdiv <4 x float> %a, %b
  ret <4 x float> %res
}

; divsd
define double @slm-costs_divsd(double %a, double %b)  {
; SLM-LABEL: 'slm-costs_divsd'
; SLM-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %res = fdiv double %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret double %res
;
; GLM-LABEL: 'slm-costs_divsd'
; GLM-NEXT:  Cost Model: Found an estimated cost of 33 for instruction: %res = fdiv double %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret double %res
;
entry:
  %res = fdiv double %a, %b
  ret double %res
}

; divpd
define <2 x double> @slm-costs_divpd(<2 x double> %a, <2 x double> %b)  {
; SLM-LABEL: 'slm-costs_divpd'
; SLM-NEXT:  Cost Model: Found an estimated cost of 69 for instruction: %res = fdiv <2 x double> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
; GLM-LABEL: 'slm-costs_divpd'
; GLM-NEXT:  Cost Model: Found an estimated cost of 65 for instruction: %res = fdiv <2 x double> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
entry:
  %res = fdiv <2 x double> %a, %b
  ret <2 x double> %res
}

; addpd
define <2 x double> @slm-costs_addpd(<2 x double> %a, <2 x double> %b)  {
; SLM-LABEL: 'slm-costs_addpd'
; SLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = fadd <2 x double> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
; GLM-LABEL: 'slm-costs_addpd'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = fadd <2 x double> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
entry:
  %res = fadd <2 x double> %a, %b
  ret <2 x double> %res
}

; subpd
define <2 x double> @slm-costs_subpd(<2 x double> %a, <2 x double> %b)  {
; SLM-LABEL: 'slm-costs_subpd'
; SLM-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %res = fsub <2 x double> %a, %b
; SLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
; GLM-LABEL: 'slm-costs_subpd'
; GLM-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %res = fsub <2 x double> %a, %b
; GLM-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %res
;
entry:
  %res = fsub <2 x double> %a, %b
  ret <2 x double> %res
}

