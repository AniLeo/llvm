; Check getIntrinsicInstrCost in BasicTTIImpl.h for vector.reverse

; RUN: opt -cost-model -analyze -mtriple=aarch64--linux-gnu -mattr=+sve  < %s | FileCheck %s

define void @vector_reverse() #0{
; CHECK-LABEL: 'vector_reverse':
; CHECK-NEXT: Cost Model: Found an estimated cost of 90 for instruction:   %1 = call <16 x i8> @llvm.experimental.vector.reverse.v16i8(<16 x i8> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 180 for instruction:   %2 = call <32 x i8> @llvm.experimental.vector.reverse.v32i8(<32 x i8> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 42 for instruction:   %3 = call <8 x i16> @llvm.experimental.vector.reverse.v8i16(<8 x i16> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 84 for instruction:   %4 = call <16 x i16> @llvm.experimental.vector.reverse.v16i16(<16 x i16> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 18 for instruction:   %5 = call <4 x i32> @llvm.experimental.vector.reverse.v4i32(<4 x i32> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 36 for instruction:   %6 = call <8 x i32> @llvm.experimental.vector.reverse.v8i32(<8 x i32> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 6 for instruction:   %7 = call <2 x i64> @llvm.experimental.vector.reverse.v2i64(<2 x i64> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 12 for instruction:   %8 = call <4 x i64> @llvm.experimental.vector.reverse.v4i64(<4 x i64> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 42 for instruction:   %9 = call <8 x half> @llvm.experimental.vector.reverse.v8f16(<8 x half> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 84 for instruction:   %10 = call <16 x half> @llvm.experimental.vector.reverse.v16f16(<16 x half> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 18 for instruction:   %11 = call <4 x float> @llvm.experimental.vector.reverse.v4f32(<4 x float> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 36 for instruction:   %12 = call <8 x float> @llvm.experimental.vector.reverse.v8f32(<8 x float> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 6 for instruction:   %13 = call <2 x double> @llvm.experimental.vector.reverse.v2f64(<2 x double> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 12 for instruction:   %14 = call <4 x double> @llvm.experimental.vector.reverse.v4f64(<4 x double> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 42 for instruction:   %15 = call <8 x bfloat> @llvm.experimental.vector.reverse.v8bf16(<8 x bfloat> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 84 for instruction:   %16 = call <16 x bfloat> @llvm.experimental.vector.reverse.v16bf16(<16 x bfloat> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 0 for instruction:   ret void

  call <16 x i8> @llvm.experimental.vector.reverse.v16i8(<16 x i8> undef)
  call <32 x i8> @llvm.experimental.vector.reverse.v32i8(<32 x i8> undef)
  call <8 x i16> @llvm.experimental.vector.reverse.v8i16(<8 x i16> undef)
  call <16 x i16> @llvm.experimental.vector.reverse.v16i16(<16 x i16> undef)
  call <4 x i32> @llvm.experimental.vector.reverse.v4i32(<4 x i32> undef)
  call <8 x i32> @llvm.experimental.vector.reverse.v8i32(<8 x i32> undef)
  call <2 x i64> @llvm.experimental.vector.reverse.v2i64(<2 x i64> undef)
  call <4 x i64> @llvm.experimental.vector.reverse.v4i64(<4 x i64> undef)
  call <8 x half> @llvm.experimental.vector.reverse.v8f16(<8 x half> undef)
  call <16 x half> @llvm.experimental.vector.reverse.v16f16(<16 x half> undef)
  call <4 x float> @llvm.experimental.vector.reverse.v4f32(<4 x float> undef)
  call <8 x float> @llvm.experimental.vector.reverse.v8f32(<8 x float> undef)
  call <2 x double> @llvm.experimental.vector.reverse.v2f64(<2 x double> undef)
  call <4 x double> @llvm.experimental.vector.reverse.v4f64(<4 x double> undef)
  call <8 x bfloat> @llvm.experimental.vector.reverse.v8bf16(<8 x bfloat> undef)
  call <16 x bfloat> @llvm.experimental.vector.reverse.v16bf16(<16 x bfloat> undef)
  ret void
}

attributes #0 = { "target-features"="+sve,+bf16" }
declare <16 x i8> @llvm.experimental.vector.reverse.v16i8(<16 x i8>)
declare <32 x i8> @llvm.experimental.vector.reverse.v32i8(<32 x i8>)
declare <8 x i16> @llvm.experimental.vector.reverse.v8i16(<8 x i16>)
declare <16 x i16> @llvm.experimental.vector.reverse.v16i16(<16 x i16>)
declare <4 x i32> @llvm.experimental.vector.reverse.v4i32(<4 x i32>)
declare <8 x i32> @llvm.experimental.vector.reverse.v8i32(<8 x i32>)
declare <2 x i64> @llvm.experimental.vector.reverse.v2i64(<2 x i64>)
declare <4 x i64> @llvm.experimental.vector.reverse.v4i64(<4 x i64>)
declare <8 x half> @llvm.experimental.vector.reverse.v8f16(<8 x half>)
declare <16 x half> @llvm.experimental.vector.reverse.v16f16(<16 x half>)
declare <4 x float> @llvm.experimental.vector.reverse.v4f32(<4 x float>)
declare <8 x float> @llvm.experimental.vector.reverse.v8f32(<8 x float>)
declare <2 x double> @llvm.experimental.vector.reverse.v2f64(<2 x double>)
declare <4 x double> @llvm.experimental.vector.reverse.v4f64(<4 x double>)
declare <8 x bfloat> @llvm.experimental.vector.reverse.v8bf16(<8 x bfloat>)
declare <16 x bfloat> @llvm.experimental.vector.reverse.v16bf16(<16 x bfloat>)
