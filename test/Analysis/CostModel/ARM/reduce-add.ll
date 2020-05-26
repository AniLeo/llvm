; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -cost-model -analyze -mtriple=thumbv8m.main < %s | FileCheck %s --check-prefix=V8M-RECIP
; RUN: opt -cost-model -analyze -mtriple=armv8a-linux-gnueabihf < %s | FileCheck %s --check-prefix=NEON-RECIP
; RUN: opt -cost-model -analyze -mtriple=armv8.1m.main -mattr=+mve < %s | FileCheck %s --check-prefix=MVE-RECIP
; RUN: opt -cost-model -analyze -cost-kind=code-size -mtriple=thumbv8m.main < %s | FileCheck %s --check-prefix=V8M-SIZE
; RUN: opt -cost-model -analyze -cost-kind=code-size -mtriple=armv8a-linux-gnueabihf < %s | FileCheck %s --check-prefix=NEON-SIZE
; RUN: opt -cost-model -analyze -cost-kind=code-size -mtriple=armv8.1m.main -mattr=+mve < %s | FileCheck %s --check-prefix=MVE-SIZE

define i32 @reduce_i64(i32 %arg) {
; V8M-RECIP-LABEL: 'reduce_i64'
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 44 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 92 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; NEON-RECIP-LABEL: 'reduce_i64'
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 29 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 55 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 107 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; MVE-RECIP-LABEL: 'reduce_i64'
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 30 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 66 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 202 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 730 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; V8M-SIZE-LABEL: 'reduce_i64'
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; NEON-SIZE-LABEL: 'reduce_i64'
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; MVE-SIZE-LABEL: 'reduce_i64'
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V1 = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %V1  = call i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64> undef)
  %V2  = call i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64> undef)
  %V4  = call i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64> undef)
  %V8  = call i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64> undef)
  %V16 = call i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64> undef)
  ret i32 undef
}

define i32 @reduce_i32(i32 %arg) {
; V8M-RECIP-LABEL: 'reduce_i32'
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 46 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 94 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 190 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 382 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; V8M-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; NEON-RECIP-LABEL: 'reduce_i32'
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 53 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 150 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 391 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 488 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 682 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 1070 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; NEON-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; MVE-RECIP-LABEL: 'reduce_i32'
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 28 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 136 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 782 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 4120 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 5658 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 11806 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 36390 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; MVE-RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; V8M-SIZE-LABEL: 'reduce_i32'
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; V8M-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; NEON-SIZE-LABEL: 'reduce_i32'
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; NEON-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; MVE-SIZE-LABEL: 'reduce_i32'
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2 = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4 = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8 = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16 = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V32 = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64 = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
; MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %V2   = call i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8> undef)
  %V4   = call i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8> undef)
  %V8   = call i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8> undef)
  %V16  = call i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8> undef)
  %V32  = call i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8> undef)
  %V64  = call i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8> undef)
  %V128 = call i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8> undef)
  ret i32 undef
}

declare i64 @llvm.experimental.vector.reduce.add.v1i64(<1 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v2i64(<2 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v4i64(<4 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v8i64(<8 x i64>)
declare i64 @llvm.experimental.vector.reduce.add.v16i64(<16 x i64>)

declare i32 @llvm.experimental.vector.reduce.add.v2i32(<2 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v8i32(<8 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v16i32(<16 x i32>)
declare i32 @llvm.experimental.vector.reduce.add.v32i32(<32 x i32>)

declare i16 @llvm.experimental.vector.reduce.add.v2i16(<2 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v4i16(<4 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v8i16(<8 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v16i16(<16 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v32i16(<32 x i16>)
declare i16 @llvm.experimental.vector.reduce.add.v64i16(<64 x i16>)

declare i8 @llvm.experimental.vector.reduce.add.v2i8(<2 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v4i8(<4 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v8i8(<8 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v16i8(<16 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v32i8(<32 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v64i8(<64 x i8>)
declare i8 @llvm.experimental.vector.reduce.add.v128i8(<128 x i8>)
