; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s  -cost-model -analyze -mtriple=thumbv7-apple-ios6.0.0 -mcpu=swift | FileCheck %s
target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
target triple = "thumbv7-apple-ios6.0.0"

;; Reverse shuffles should be lowered to vrev and possibly a vext (for quadwords)
define void @reverse() {
; CHECK-LABEL: 'reverse'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v9 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v10 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v12 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v13 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v15 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v17 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v7 = shufflevector <2 x i8> undef, <2 x i8>undef, <2 x i32> <i32 1, i32 0>
  %v8 = shufflevector <4 x i8> undef, <4 x i8>undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %v9 = shufflevector <8 x i8> undef, <8 x i8>undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %v10 = shufflevector <16 x i8> undef, <16 x i8>undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v11 = shufflevector <2 x i16> undef, <2 x i16>undef, <2 x i32> <i32 1, i32 0>
  %v12 = shufflevector <4 x i16> undef, <4 x i16>undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %v13 = shufflevector <8 x i16> undef, <8 x i16>undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v14 = shufflevector <2 x i32> undef, <2 x i32>undef, <2 x i32> <i32 1, i32 0>
  %v15 = shufflevector <4 x i32> undef, <4 x i32>undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>

  %v16 = shufflevector <2 x float> undef, <2 x float>undef, <2 x i32> <i32 1, i32 0>
  %v17 = shufflevector <4 x float> undef, <4 x float>undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>

  ret void
}
