; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple arm64-- | FileCheck %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

; Test the (concat_vectors (trunc), (trunc)) pattern.

define <4 x i16> @test_concat_truncate_v2i64_to_v4i16(<2 x i64> %a, <2 x i64> %b) #0 {
; CHECK-LABEL: test_concat_truncate_v2i64_to_v4i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
entry:
  %at = trunc <2 x i64> %a to <2 x i16>
  %bt = trunc <2 x i64> %b to <2 x i16>
  %shuffle = shufflevector <2 x i16> %at, <2 x i16> %bt, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i16> %shuffle
}

define <4 x i32> @test_concat_truncate_v2i64_to_v4i32(<2 x i64> %a, <2 x i64> %b) #0 {
; CHECK-LABEL: test_concat_truncate_v2i64_to_v4i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
entry:
  %at = trunc <2 x i64> %a to <2 x i32>
  %bt = trunc <2 x i64> %b to <2 x i32>
  %shuffle = shufflevector <2 x i32> %at, <2 x i32> %bt, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %shuffle
}

define <4 x i16> @test_concat_truncate_v2i32_to_v4i16(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: test_concat_truncate_v2i32_to_v4i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    ret
entry:
  %at = trunc <2 x i32> %a to <2 x i16>
  %bt = trunc <2 x i32> %b to <2 x i16>
  %shuffle = shufflevector <2 x i16> %at, <2 x i16> %bt, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i16> %shuffle
}

define <8 x i8> @test_concat_truncate_v4i32_to_v8i8(<4 x i32> %a, <4 x i32> %b) #0 {
; CHECK-LABEL: test_concat_truncate_v4i32_to_v8i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    ret
entry:
  %at = trunc <4 x i32> %a to <4 x i8>
  %bt = trunc <4 x i32> %b to <4 x i8>
  %shuffle = shufflevector <4 x i8> %at, <4 x i8> %bt, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i8> %shuffle
}

define <8 x i16> @test_concat_truncate_v4i32_to_v8i16(<4 x i32> %a, <4 x i32> %b) #0 {
; CHECK-LABEL: test_concat_truncate_v4i32_to_v8i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    ret
entry:
  %at = trunc <4 x i32> %a to <4 x i16>
  %bt = trunc <4 x i32> %b to <4 x i16>
  %shuffle = shufflevector <4 x i16> %at, <4 x i16> %bt, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i16> %shuffle
}

define <8 x i8> @test_concat_truncate_v4i16_to_v8i8(<4 x i16> %a, <4 x i16> %b) #0 {
; CHECK-LABEL: test_concat_truncate_v4i16_to_v8i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
entry:
  %at = trunc <4 x i16> %a to <4 x i8>
  %bt = trunc <4 x i16> %b to <4 x i8>
  %shuffle = shufflevector <4 x i8> %at, <4 x i8> %bt, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i8> %shuffle
}

define <16 x i8> @test_concat_truncate_v8i16_to_v16i8(<8 x i16> %a, <8 x i16> %b) #0 {
; CHECK-LABEL: test_concat_truncate_v8i16_to_v16i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %at = trunc <8 x i16> %a to <8 x i8>
  %bt = trunc <8 x i16> %b to <8 x i8>
  %shuffle = shufflevector <8 x i8> %at, <8 x i8> %bt, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32  9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i8> %shuffle
}

; The concat_vectors operation in this test is introduced when splitting
; the fptrunc operation due to the split <vscale x 4 x double> input operand.
define void @test_concat_fptrunc_v4f64_to_v4f32(<vscale x 4 x float>* %ptr) #1 {
; CHECK-LABEL: test_concat_fptrunc_v4f64_to_v4f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fmov z0.s, #1.00000000
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
entry:
  %0 = shufflevector <vscale x 4 x double> insertelement (<vscale x 4 x double> poison, double 1.000000e+00, i32 0), <vscale x 4 x double> poison, <vscale x 4 x i32> zeroinitializer
  %1 = fptrunc <vscale x 4 x double> %0 to <vscale x 4 x float>
  store <vscale x 4 x float> %1, <vscale x 4 x float>* %ptr, align 4
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { "target-features"="+sve" }
