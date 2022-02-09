; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64 -passes='print<cost-model>' 2>&1 -disable-output | FileCheck %s

; Verify the cost of scalar ctlz instructions.

define i64 @test_cttz_i64(i64 %a) {
;
; CHECK-LABEL: 'test_cttz_i64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cttz = call i64 @llvm.cttz.i64(i64 %a, i1 false)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i64 %cttz
;
  %cttz = call i64 @llvm.cttz.i64(i64 %a)
  ret i64 %cttz
}

define i32 @test_cttz_i32(i32 %a) {
;
; CHECK-LABEL: 'test_cttz_i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cttz = call i32 @llvm.cttz.i32(i32 %a, i1 false)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %cttz
;
  %cttz = call i32 @llvm.cttz.i32(i32 %a)
  ret i32 %cttz
}

define i16 @test_cttz_i16(i16 %a) {
;
; CHECK-LABEL: 'test_cttz_i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cttz = call i16 @llvm.cttz.i16(i16 %a, i1 false)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %cttz
;
  %cttz = call i16 @llvm.cttz.i16(i16 %a)
  ret i16 %cttz
}

define i8 @test_cttz_i8(i8 %a) {
;
; CHECK-LABEL: 'test_cttz_i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cttz = call i8 @llvm.cttz.i8(i8 %a, i1 false)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %cttz
;
  %cttz = call i8 @llvm.cttz.i8(i8 %a)
  ret i8 %cttz
}

declare i64 @llvm.cttz.i64(i64)
declare i32 @llvm.cttz.i32(i32)
declare i16 @llvm.cttz.i16(i16)
declare i8 @llvm.cttz.i8(i8)

; Verify the cost of vector cttz instructions.

define <2 x i64> @test_cttz_v2i64(<2 x i64> %a) {
;
; CHECK-LABEL: 'test_cttz_v2i64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %cttz = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %cttz
;
  %cttz = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %a, i1 true)
  ret <2 x i64> %cttz
}

define <2 x i32> @test_cttz_v2i32(<2 x i32> %a) {
;
; CHECK-LABEL: 'test_cttz_v2i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i32> %cttz
;
  %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %a, i1 true)
  ret <2 x i32> %cttz
}

define <4 x i32> @test_cttz_v4i32(<4 x i32> %a) {
;
; CHECK-LABEL: 'test_cttz_v4i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %cttz = call <4 x i32> @llvm.cttz.v4i32(<4 x i32> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %cttz
;
  %cttz = call <4 x i32> @llvm.cttz.v4i32(<4 x i32> %a, i1 true)
  ret <4 x i32> %cttz
}

define <2 x i16> @test_cttz_v2i16(<2 x i16> %a) {
;
; CHECK-LABEL: 'test_cttz_v2i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %cttz = call <2 x i16> @llvm.cttz.v2i16(<2 x i16> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i16> %cttz
;
  %cttz = call <2 x i16> @llvm.cttz.v2i16(<2 x i16> %a, i1 true)
  ret <2 x i16> %cttz
}

define <4 x i16> @test_cttz_v4i16(<4 x i16> %a) {
;
; CHECK-LABEL: 'test_cttz_v4i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %cttz = call <4 x i16> @llvm.cttz.v4i16(<4 x i16> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i16> %cttz
;
  %cttz = call <4 x i16> @llvm.cttz.v4i16(<4 x i16> %a, i1 true)
  ret <4 x i16> %cttz
}

define <8 x i16> @test_cttz_v8i16(<8 x i16> %a) {
;
; CHECK-LABEL: 'test_cttz_v8i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 50 for instruction: %cttz = call <8 x i16> @llvm.cttz.v8i16(<8 x i16> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %cttz
;
  %cttz = call <8 x i16> @llvm.cttz.v8i16(<8 x i16> %a, i1 true)
  ret <8 x i16> %cttz
}

define <2 x i8> @test_cttz_v2i8(<2 x i8> %a) {
;
; CHECK-LABEL: 'test_cttz_v2i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %cttz = call <2 x i8> @llvm.cttz.v2i8(<2 x i8> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i8> %cttz
;
  %cttz = call <2 x i8> @llvm.cttz.v2i8(<2 x i8> %a, i1 true)
  ret <2 x i8> %cttz
}

define <4 x i8> @test_cttz_v4i8(<4 x i8> %a) {
;
; CHECK-LABEL: 'test_cttz_v4i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %cttz = call <4 x i8> @llvm.cttz.v4i8(<4 x i8> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i8> %cttz
;
  %cttz = call <4 x i8> @llvm.cttz.v4i8(<4 x i8> %a, i1 true)
  ret <4 x i8> %cttz
}

define <8 x i8> @test_cttz_v8i8(<8 x i8> %a) {
;
; CHECK-LABEL: 'test_cttz_v8i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 50 for instruction: %cttz = call <8 x i8> @llvm.cttz.v8i8(<8 x i8> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i8> %cttz
;
  %cttz = call <8 x i8> @llvm.cttz.v8i8(<8 x i8> %a, i1 true)
  ret <8 x i8> %cttz
}

define <16 x i8> @test_cttz_v16i8(<16 x i8> %a) {
;
; CHECK-LABEL: 'test_cttz_v16i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 106 for instruction: %cttz = call <16 x i8> @llvm.cttz.v16i8(<16 x i8> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %cttz
;
  %cttz = call <16 x i8> @llvm.cttz.v16i8(<16 x i8> %a, i1 true)
  ret <16 x i8> %cttz
}

define <4 x i64> @test_cttz_v4i64(<4 x i64> %a) {
;
; CHECK-LABEL: 'test_cttz_v4i64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %cttz = call <4 x i64> @llvm.cttz.v4i64(<4 x i64> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %cttz
;
  %cttz = call <4 x i64> @llvm.cttz.v4i64(<4 x i64> %a, i1 true)
  ret <4 x i64> %cttz
}

define <8 x i32> @test_cttz_v8i32(<8 x i32> %a) {
;
; CHECK-LABEL: 'test_cttz_v8i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 44 for instruction: %cttz = call <8 x i32> @llvm.cttz.v8i32(<8 x i32> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %cttz
;
  %cttz = call <8 x i32> @llvm.cttz.v8i32(<8 x i32> %a, i1 true)
  ret <8 x i32> %cttz
}

define <16 x i16> @test_cttz_v16i16(<16 x i16> %a) {
;
; CHECK-LABEL: 'test_cttz_v16i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 100 for instruction: %cttz = call <16 x i16> @llvm.cttz.v16i16(<16 x i16> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %cttz
;
  %cttz = call <16 x i16> @llvm.cttz.v16i16(<16 x i16> %a, i1 true)
  ret <16 x i16> %cttz
}

define <32 x i8> @test_cttz_v32i8(<32 x i8> %a) {
;
; CHECK-LABEL: 'test_cttz_v32i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 212 for instruction: %cttz = call <32 x i8> @llvm.cttz.v32i8(<32 x i8> %a, i1 true)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %cttz
;
  %cttz = call <32 x i8> @llvm.cttz.v32i8(<32 x i8> %a, i1 true)
  ret <32 x i8> %cttz
}

declare <2 x i64> @llvm.cttz.v2i64(<2 x i64>, i1)
declare <2 x i32> @llvm.cttz.v2i32(<2 x i32>, i1)
declare <4 x i32> @llvm.cttz.v4i32(<4 x i32>, i1)
declare <2 x i16> @llvm.cttz.v2i16(<2 x i16>, i1)
declare <4 x i16> @llvm.cttz.v4i16(<4 x i16>, i1)
declare <8 x i16> @llvm.cttz.v8i16(<8 x i16>, i1)
declare <2 x i8> @llvm.cttz.v2i8(<2 x i8>, i1)
declare <4 x i8> @llvm.cttz.v4i8(<4 x i8>, i1)
declare <8 x i8> @llvm.cttz.v8i8(<8 x i8>, i1)
declare <16 x i8> @llvm.cttz.v16i8(<16 x i8>, i1)

declare <4 x i64> @llvm.cttz.v4i64(<4 x i64>, i1)
declare <8 x i32> @llvm.cttz.v8i32(<8 x i32>, i1)
declare <16 x i16> @llvm.cttz.v16i16(<16 x i16>, i1)
declare <32 x i8> @llvm.cttz.v32i8(<32 x i8>, i1)
