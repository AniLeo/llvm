; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -passes="print<cost-model>" 2>&1 -disable-output -mattr=+avx512fp16 | FileCheck %s

define void @test_vXf16(<2 x half> %src32, <4 x half> %src64, <8 x half> %src128, <16 x half> %src256, <32 x half> %src512) {
; CHECK-LABEL: 'test_vXf16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32 = shufflevector <2 x half> %src32, <2 x half> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64 = shufflevector <4 x half> %src64, <4 x half> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V128 = shufflevector <8 x half> %src128, <8 x half> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V256 = shufflevector <16 x half> %src256, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V512 = shufflevector <32 x half> %src512, <32 x half> undef, <32 x i32> <i32 31, i32 30, i32 29, i32 28, i32 27, i32 26, i32 25, i32 24, i32 23, i32 22, i32 21, i32 20, i32 19, i32 18, i32 17, i32 16, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %V32  = shufflevector <2 x half> %src32, <2 x half> undef, <2 x i32> <i32 1, i32 0>
  %V64  = shufflevector <4 x half> %src64, <4 x half> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %V128 = shufflevector <8 x half> %src128, <8 x half> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %V256 = shufflevector <16 x half> %src256, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %V512 = shufflevector <32 x half> %src512, <32 x half> undef, <32 x i32> <i32 31, i32 30, i32 29, i32 28, i32 27, i32 26, i32 25, i32 24, i32 23, i32 22, i32 21, i32 20, i32 19, i32 18, i32 17, i32 16, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  ret void
}
