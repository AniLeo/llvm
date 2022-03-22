; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64--linux-gnu -passes='print<cost-model>' 2>&1 -disable-output | FileCheck %s

define void @shuffle() {
; CHECK-LABEL: 'shuffle'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v9 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v10 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v12 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v13 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v15 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v17 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v7 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> <i32 1, i32 0>
  %v8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>
  %v9 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>
  %v10 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>

  %v11 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> <i32 1, i32 0>
  %v12 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>
  %v13 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>

  %v14 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
  %v15 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>

  %v16 = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> <i32 1, i32 0>
  %v17 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 1, i32 3, i32 2, i32 0>

  ret void
}

define void @concat() {
; CHECK-LABEL: 'concat'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4i8 = shufflevector <2 x i8> undef, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v8i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 45 for instruction: %v16i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4i16 = shufflevector <2 x i16> undef, <2 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v8i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %v16i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4i32 = shufflevector <2 x i32> undef, <2 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v8i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v4i64 = shufflevector <2 x i64> undef, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4f16 = shufflevector <2 x half> undef, <2 x half> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v8f16 = shufflevector <4 x half> undef, <4 x half> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %v16f16 = shufflevector <8 x half> undef, <8 x half> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4f32 = shufflevector <2 x float> undef, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v8f32 = shufflevector <4 x float> undef, <4 x float> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v4f64 = shufflevector <2 x double> undef, <2 x double> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v4i8 = shufflevector <2 x i8> undef, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v8i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v16i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  %v4i16 = shufflevector <2 x i16> undef, <2 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v8i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v16i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  %v4i32 = shufflevector <2 x i32> undef, <2 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v8i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

  %v4i64 = shufflevector <2 x i64> undef, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>

  %v4f16 = shufflevector <2 x half> undef, <2 x half> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v8f16 = shufflevector <4 x half> undef, <4 x half> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v16f16 = shufflevector <8 x half> undef, <8 x half> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  %v4f32 = shufflevector <2 x float> undef, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v8f32 = shufflevector <4 x float> undef, <4 x float> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

  %v4f64 = shufflevector <2 x double> undef, <2 x double> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>

  ret void
}

define void @insert_subvec() {
; CHECK-LABEL: 'insert_subvec'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v4i8_2_0 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4i8_2_1 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %v8i8_2_0 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 8, i32 9, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i8_2_1 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i8_2_2 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i8_2_3 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 9>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i8_2_05 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 8, i32 9, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 90 for instruction: %v16i8_4_0 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v16i8_4_1 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v16i8_4_2 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v16i8_4_3 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v16i8_4_05 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 18, i32 19, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v4i16_2_0 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4i16_2_1 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 42 for instruction: %v8i16_2_0 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 8, i32 9, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i16_2_1 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i16_2_2 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i16_2_3 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 9>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i16_2_05 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 8, i32 9, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 84 for instruction: %v16i16_4_0 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v16i16_4_1 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v16i16_4_2 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v16i16_4_3 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %v16i16_4_05 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 18, i32 19, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4i32_2_0 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v4i32_2_1 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v8i32_2_0 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 8, i32 9, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i32_2_1 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v8i32_2_2 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i32_2_3 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 9>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %v8i32_2_05 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 8, i32 9, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v16i32_4_0 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v16i32_4_1 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v16i32_4_2 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v16i32_4_3 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %v16i32_4_05 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 18, i32 19, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v4i8_2_0 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %v4i8_2_1 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
  %v8i8_2_0 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 8, i32 9, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v8i8_2_1 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 6, i32 7>
  %v8i8_2_2 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 6, i32 7>
  %v8i8_2_3 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 9>
  %v8i8_2_05 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 0, i32 8, i32 9, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v16i8_4_0 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v16i8_4_1 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v16i8_4_2 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 12, i32 13, i32 14, i32 15>
  %v16i8_4_3 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
  %v16i8_4_05 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 18, i32 19, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  %v4i16_2_0 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %v4i16_2_1 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
  %v8i16_2_0 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 8, i32 9, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v8i16_2_1 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 6, i32 7>
  %v8i16_2_2 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 6, i32 7>
  %v8i16_2_3 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 9>
  %v8i16_2_05 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 0, i32 8, i32 9, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v16i16_4_0 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v16i16_4_1 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v16i16_4_2 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 12, i32 13, i32 14, i32 15>
  %v16i16_4_3 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
  %v16i16_4_05 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 18, i32 19, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  %v4i32_2_0 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %v4i32_2_1 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
  %v8i32_2_0 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 8, i32 9, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v8i32_2_1 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 6, i32 7>
  %v8i32_2_2 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 6, i32 7>
  %v8i32_2_3 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 9>
  %v8i32_2_05 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 0, i32 8, i32 9, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v16i32_4_0 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v16i32_4_1 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v16i32_4_2 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 12, i32 13, i32 14, i32 15>
  %v16i32_4_3 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
  %v16i32_4_05 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 18, i32 19, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret void
}
