; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64--linux-gnu -cost-model -analyze | FileCheck %s

define void @broadcast() {
; CHECK-LABEL: 'broadcast'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v7 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v9 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v10 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v11 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v12 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v13 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v14 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v15 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16 = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v17 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %v7 = shufflevector <2 x i8> undef, <2 x i8>undef, <2 x i32> zeroinitializer
  %v8 = shufflevector <4 x i8> undef, <4 x i8>undef, <4 x i32> zeroinitializer
  %v9 = shufflevector <8 x i8> undef, <8 x i8>undef, <8 x i32> zeroinitializer
  %v10 = shufflevector <16 x i8> undef, <16 x i8>undef, <16 x i32> zeroinitializer

  %v11 = shufflevector <2 x i16> undef, <2 x i16>undef, <2 x i32> zeroinitializer
  %v12 = shufflevector <4 x i16> undef, <4 x i16>undef, <4 x i32> zeroinitializer
  %v13 = shufflevector <8 x i16> undef, <8 x i16>undef, <8 x i32> zeroinitializer

  %v14 = shufflevector <2 x i32> undef, <2 x i32>undef, <2 x i32> zeroinitializer
  %v15 = shufflevector <4 x i32> undef, <4 x i32>undef, <4 x i32> zeroinitializer

  %v16 = shufflevector <2 x float> undef, <2 x float>undef, <2 x i32> zeroinitializer
  %v17 = shufflevector <4 x float> undef, <4 x float>undef, <4 x i32> zeroinitializer

  ret void
}
