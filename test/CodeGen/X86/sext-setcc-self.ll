; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown < %s | FileCheck %s

define <4 x i32> @test_ueq(<4 x float> %in) {
; CHECK-LABEL: test_ueq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = fcmp ueq <4 x float> %in, %in
  %t1 = sext <4 x i1> %t0 to <4 x i32>
  ret <4 x i32> %t1
}

define <4 x i32> @test_uge(<4 x float> %in) {
; CHECK-LABEL: test_uge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = fcmp uge <4 x float> %in, %in
  %t1 = sext <4 x i1> %t0 to <4 x i32>
  ret <4 x i32> %t1
}

define <4 x i32> @test_ule(<4 x float> %in) {
; CHECK-LABEL: test_ule:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = fcmp ule <4 x float> %in, %in
  %t1 = sext <4 x i1> %t0 to <4 x i32>
  ret <4 x i32> %t1
}

define <4 x i32> @test_one(<4 x float> %in) {
; CHECK-LABEL: test_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = fcmp one <4 x float> %in, %in
  %t1 = sext <4 x i1> %t0 to <4 x i32>
  ret <4 x i32> %t1
}

define <4 x i32> @test_ogt(<4 x float> %in) {
; CHECK-LABEL: test_ogt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = fcmp ogt <4 x float> %in, %in
  %t1 = sext <4 x i1> %t0 to <4 x i32>
  ret <4 x i32> %t1
}

define <4 x i32> @test_olt(<4 x float> %in) {
; CHECK-LABEL: test_olt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = fcmp olt <4 x float> %in, %in
  %t1 = sext <4 x i1> %t0 to <4 x i32>
  ret <4 x i32> %t1
}
