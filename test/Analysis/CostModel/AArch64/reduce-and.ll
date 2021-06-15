; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64-unknown-linux-gnu -cost-model -cost-kind=throughput -analyze | FileCheck %s

define i32 @reduce_i1(i32 %arg) {
; CHECK-LABEL: 'reduce_i1'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1 = call i1 @llvm.vector.reduce.and.v1i1(<1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2 = call i1 @llvm.vector.reduce.and.v2i1(<2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4 = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8 = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16 = call i1 @llvm.vector.reduce.and.v16i1(<16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 91 for instruction: %V32 = call i1 @llvm.vector.reduce.and.v32i1(<32 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 181 for instruction: %V64 = call i1 @llvm.vector.reduce.and.v64i1(<64 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 362 for instruction: %V128 = call i1 @llvm.vector.reduce.and.v128i1(<128 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %V1i8 = call i8 @llvm.vector.reduce.and.v1i8(<1 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 13 for instruction: %V3i8 = call i8 @llvm.vector.reduce.and.v3i8(<3 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V4i8 = call i8 @llvm.vector.reduce.and.v4i8(<4 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %V8i8 = call i8 @llvm.vector.reduce.and.v8i8(<8 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 17 for instruction: %V16i8 = call i8 @llvm.vector.reduce.and.v16i8(<16 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %V32i8 = call i8 @llvm.vector.reduce.and.v32i8(<32 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V64i8 = call i8 @llvm.vector.reduce.and.v64i8(<64 x i8> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %V4i16 = call i16 @llvm.vector.reduce.and.v4i16(<4 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %V8i16 = call i16 @llvm.vector.reduce.and.v8i16(<8 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V16i16 = call i16 @llvm.vector.reduce.and.v16i16(<16 x i16> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2i32 = call i32 @llvm.vector.reduce.and.v2i32(<2 x i32> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %V4i32 = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8i32 = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2i64 = call i64 @llvm.vector.reduce.and.v2i64(<2 x i64> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4i64 = call i64 @llvm.vector.reduce.and.v4i64(<4 x i64> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;

  %V1   = call i1 @llvm.vector.reduce.and.v1i1(<1 x i1> undef)
  %V2   = call i1 @llvm.vector.reduce.and.v2i1(<2 x i1> undef)
  %V4   = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> undef)
  %V8   = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> undef)
  %V16  = call i1 @llvm.vector.reduce.and.v16i1(<16 x i1> undef)
  %V32  = call i1 @llvm.vector.reduce.and.v32i1(<32 x i1> undef)
  %V64  = call i1 @llvm.vector.reduce.and.v64i1(<64 x i1> undef)
  %V128 = call i1 @llvm.vector.reduce.and.v128i1(<128 x i1> undef)

  %V1i8 = call i8 @llvm.vector.reduce.and.v1i8(<1 x i8> undef)
  %V3i8 = call i8 @llvm.vector.reduce.and.v3i8(<3 x i8> undef)
  %V4i8 = call i8 @llvm.vector.reduce.and.v4i8(<4 x i8> undef)
  %V8i8 = call i8 @llvm.vector.reduce.and.v8i8(<8 x i8> undef)
  %V16i8 = call i8 @llvm.vector.reduce.and.v16i8(<16 x i8> undef)
  %V32i8 = call i8 @llvm.vector.reduce.and.v32i8(<32 x i8> undef)
  %V64i8 = call i8 @llvm.vector.reduce.and.v64i8(<64 x i8> undef)
  %V4i16 = call i16 @llvm.vector.reduce.and.v4i16(<4 x i16> undef)
  %V8i16 = call i16 @llvm.vector.reduce.and.v8i16(<8 x i16> undef)
  %V16i16 = call i16 @llvm.vector.reduce.and.v16i16(<16 x i16> undef)
  %V2i32 = call i32 @llvm.vector.reduce.and.v2i32(<2 x i32> undef)
  %V4i32 = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> undef)
  %V8i32 = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> undef)
  %V2i64 = call i64 @llvm.vector.reduce.and.v2i64(<2 x i64> undef)
  %V4i64 = call i64 @llvm.vector.reduce.and.v4i64(<4 x i64> undef)
  ret i32 undef
}

declare i1 @llvm.vector.reduce.and.v1i1(<1 x i1>)
declare i1 @llvm.vector.reduce.and.v2i1(<2 x i1>)
declare i1 @llvm.vector.reduce.and.v4i1(<4 x i1>)
declare i1 @llvm.vector.reduce.and.v8i1(<8 x i1>)
declare i1 @llvm.vector.reduce.and.v16i1(<16 x i1>)
declare i1 @llvm.vector.reduce.and.v32i1(<32 x i1>)
declare i1 @llvm.vector.reduce.and.v64i1(<64 x i1>)
declare i1 @llvm.vector.reduce.and.v128i1(<128 x i1>)
declare i8 @llvm.vector.reduce.and.v1i8(<1 x i8>)
declare i8 @llvm.vector.reduce.and.v3i8(<3 x i8>)
declare i8 @llvm.vector.reduce.and.v4i8(<4 x i8>)
declare i8 @llvm.vector.reduce.and.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.and.v16i8(<16 x i8>)
declare i8 @llvm.vector.reduce.and.v32i8(<32 x i8>)
declare i8 @llvm.vector.reduce.and.v64i8(<64 x i8>)
declare i16 @llvm.vector.reduce.and.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.and.v8i16(<8 x i16>)
declare i16 @llvm.vector.reduce.and.v16i16(<16 x i16>)
declare i32 @llvm.vector.reduce.and.v2i32(<2 x i32>)
declare i32 @llvm.vector.reduce.and.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.and.v8i32(<8 x i32>)
declare i64 @llvm.vector.reduce.and.v2i64(<2 x i64>)
declare i64 @llvm.vector.reduce.and.v4i64(<4 x i64>)
