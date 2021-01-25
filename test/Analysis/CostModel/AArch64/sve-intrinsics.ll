; RUN: opt -cost-model -analyze -mtriple=aarch64--linux-gnu -mattr=+sve  < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning


define void @vector_insert_extract(<vscale x 4 x i32> %v0, <vscale x 16 x i32> %v1, <16 x i32> %v2) {
; CHECK-LABEL: 'vector_insert_extract'
; CHECK-NEXT: Cost Model: Found an estimated cost of 72 for instruction: %extract_fixed_from_scalable = call <16 x i32> @llvm.experimental.vector.extract.v16i32.nxv4i32(<vscale x 4 x i32> %v0, i64 0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 72 for instruction: %insert_fixed_into_scalable = call <vscale x 4 x i32> @llvm.experimental.vector.insert.nxv4i32.v16i32(<vscale x 4 x i32> %v0, <16 x i32> %v2, i64 0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %extract_scalable_from_scalable = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32> %v1, i64 0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %insert_scalable_into_scalable = call <vscale x 16 x i32> @llvm.experimental.vector.insert.nxv16i32.nxv4i32(<vscale x 16 x i32> %v1, <vscale x 4 x i32> %v0, i64 0)
  %extract_fixed_from_scalable = call <16 x i32> @llvm.experimental.vector.extract.v16i32.nxv4i32(<vscale x 4 x i32> %v0, i64 0)
  %insert_fixed_into_scalable = call <vscale x 4 x i32> @llvm.experimental.vector.insert.nxv4i32.v16i32(<vscale x 4 x i32> %v0, <16 x i32> %v2, i64 0)
  %extract_scalable_from_scalable = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32> %v1, i64 0)
  %insert_scalable_into_scalable = call <vscale x 16 x i32> @llvm.experimental.vector.insert.nxv16i32.nxv4i32(<vscale x 16 x i32> %v1, <vscale x 4 x i32> %v0, i64 0)
  ret void
}
declare <16 x i32> @llvm.experimental.vector.extract.v16i32.nxv4i32(<vscale x 4 x i32>, i64)
declare <vscale x 4 x i32> @llvm.experimental.vector.insert.nxv4i32.v16i32(<vscale x 4 x i32>, <16 x i32>, i64)
declare <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32>, i64)
declare <vscale x 16 x i32> @llvm.experimental.vector.insert.nxv16i32.nxv4i32(<vscale x 16 x i32>, <vscale x 4 x i32>, i64)


define void @reductions(<vscale x 4 x i32> %v0, <vscale x 4 x i64> %v1, <vscale x 4 x float> %v2, <vscale x 4 x double> %v3) {
; CHECK-LABEL: 'reductions'
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %add_nxv4i32 = call i32 @llvm.vector.reduce.add.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 3 for instruction: %add_nxv4i64 = call i64 @llvm.vector.reduce.add.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 16 for instruction: %mul_nxv4i32 = call i32 @llvm.vector.reduce.mul.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 16 for instruction: %mul_nxv4i64 = call i64 @llvm.vector.reduce.mul.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %and_nxv4i32 = call i32 @llvm.vector.reduce.and.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 3 for instruction: %and_nxv4i64 = call i64 @llvm.vector.reduce.and.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %or_nxv4i32 = call i32 @llvm.vector.reduce.or.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 3 for instruction: %or_nxv4i64 = call i64 @llvm.vector.reduce.or.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %xor_nxv4i32 = call i32 @llvm.vector.reduce.xor.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 3 for instruction: %xor_nxv4i64 = call i64 @llvm.vector.reduce.xor.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %umin_nxv4i32 = call i32 @llvm.vector.reduce.umin.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 4 for instruction: %umin_nxv4i64 = call i64 @llvm.vector.reduce.umin.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %smin_nxv4i32 = call i32 @llvm.vector.reduce.smin.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 4 for instruction: %smin_nxv4i64 = call i64 @llvm.vector.reduce.smin.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %umax_nxv4i32 = call i32 @llvm.vector.reduce.umax.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 4 for instruction: %umax_nxv4i64 = call i64 @llvm.vector.reduce.umax.nxv4i64(<vscale x 4 x i64> %v1)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %smax_nxv4i32 = call i32 @llvm.vector.reduce.smax.nxv4i32(<vscale x 4 x i32> %v0)
; CHECK-NEXT: Cost Model: Found an estimated cost of 4 for instruction: %smax_nxv4i64 = call i64 @llvm.vector.reduce.smax.nxv4i64(<vscale x 4 x i64> %v1)
  %add_nxv4i32 = call i32 @llvm.vector.reduce.add.nxv4i32(<vscale x 4 x i32> %v0)
  %add_nxv4i64 = call i64 @llvm.vector.reduce.add.nxv4i64(<vscale x 4 x i64> %v1)
  %mul_nxv4i32 = call i32 @llvm.vector.reduce.mul.nxv4i32(<vscale x 4 x i32> %v0)
  %mul_nxv4i64 = call i64 @llvm.vector.reduce.mul.nxv4i64(<vscale x 4 x i64> %v1)
  %and_nxv4i32 = call i32 @llvm.vector.reduce.and.nxv4i32(<vscale x 4 x i32> %v0)
  %and_nxv4i64 = call i64 @llvm.vector.reduce.and.nxv4i64(<vscale x 4 x i64> %v1)
  %or_nxv4i32 = call i32 @llvm.vector.reduce.or.nxv4i32(<vscale x 4 x i32> %v0)
  %or_nxv4i64 = call i64 @llvm.vector.reduce.or.nxv4i64(<vscale x 4 x i64> %v1)
  %xor_nxv4i32 = call i32 @llvm.vector.reduce.xor.nxv4i32(<vscale x 4 x i32> %v0)
  %xor_nxv4i64 = call i64 @llvm.vector.reduce.xor.nxv4i64(<vscale x 4 x i64> %v1)
  %umin_nxv4i32 = call i32 @llvm.vector.reduce.umin.nxv4i32(<vscale x 4 x i32> %v0)
  %umin_nxv4i64 = call i64 @llvm.vector.reduce.umin.nxv4i64(<vscale x 4 x i64> %v1)
  %smin_nxv4i32 = call i32 @llvm.vector.reduce.smin.nxv4i32(<vscale x 4 x i32> %v0)
  %smin_nxv4i64 = call i64 @llvm.vector.reduce.smin.nxv4i64(<vscale x 4 x i64> %v1)
  %umax_nxv4i32 = call i32 @llvm.vector.reduce.umax.nxv4i32(<vscale x 4 x i32> %v0)
  %umax_nxv4i64 = call i64 @llvm.vector.reduce.umax.nxv4i64(<vscale x 4 x i64> %v1)
  %smax_nxv4i32 = call i32 @llvm.vector.reduce.smax.nxv4i32(<vscale x 4 x i32> %v0)
  %smax_nxv4i64 = call i64 @llvm.vector.reduce.smax.nxv4i64(<vscale x 4 x i64> %v1)

; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %fadd_nxv4f32 = call float @llvm.vector.reduce.fadd.nxv4f32(float 0.000000e+00, <vscale x 4 x float> %v2)
; CHECK-NEXT: Cost Model: Found an estimated cost of 6 for instruction: %fadd_nxv4f64 = call double @llvm.vector.reduce.fadd.nxv4f64(double 0.000000e+00, <vscale x 4 x double> %v3)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %fmin_nxv4f32 = call float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float> %v2)
; CHECK-NEXT: Cost Model: Found an estimated cost of 4 for instruction: %fmin_nxv4f64 = call double @llvm.vector.reduce.fmin.nxv4f64(<vscale x 4 x double> %v3)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %fmax_nxv4f32 = call float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float> %v2)
; CHECK-NEXT: Cost Model: Found an estimated cost of 4 for instruction: %fmax_nxv4f64 = call double @llvm.vector.reduce.fmax.nxv4f64(<vscale x 4 x double> %v3)
  %fadd_nxv4f32 = call float @llvm.vector.reduce.fadd.nxv4f32(float 0.0, <vscale x 4 x float> %v2)
  %fadd_nxv4f64 = call double @llvm.vector.reduce.fadd.nxv4f64(double 0.0, <vscale x 4 x double> %v3)
  %fmin_nxv4f32 = call float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float> %v2)
  %fmin_nxv4f64 = call double @llvm.vector.reduce.fmin.nxv4f64(<vscale x 4 x double> %v3)
  %fmax_nxv4f32 = call float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float> %v2)
  %fmax_nxv4f64 = call double @llvm.vector.reduce.fmax.nxv4f64(<vscale x 4 x double> %v3)

  ret void
}
declare i32 @llvm.vector.reduce.add.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.add.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.mul.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.mul.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.and.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.and.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.or.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.or.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.xor.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.xor.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.umin.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.umin.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.smin.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.smin.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.umax.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.umax.nxv4i64(<vscale x 4 x i64>)
declare i32 @llvm.vector.reduce.smax.nxv4i32(<vscale x 4 x i32>)
declare i64 @llvm.vector.reduce.smax.nxv4i64(<vscale x 4 x i64>)
declare float @llvm.vector.reduce.fadd.nxv4f32(float, <vscale x 4 x float>)
declare double @llvm.vector.reduce.fadd.nxv4f64(double, <vscale x 4 x double>)
declare float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float>)
declare double @llvm.vector.reduce.fmin.nxv4f64(<vscale x 4 x double>)
declare float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float>)
declare double @llvm.vector.reduce.fmax.nxv4f64(<vscale x 4 x double>)


define void  @count_zeroes(<vscale x 4 x i32> %A) {
; CHECK-LABEL: 'count_zeroes'
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %ctlz = call <vscale x 4 x i32> @llvm.ctlz.nxv4i32(<vscale x 4 x i32> %A, i1 true)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %cttz = call <vscale x 4 x i32> @llvm.cttz.nxv4i32(<vscale x 4 x i32> %A, i1 true)
  %ctlz = call <vscale x 4 x i32> @llvm.ctlz.nxv4i32(<vscale x 4 x i32> %A, i1 true)
  %cttz = call <vscale x 4 x i32> @llvm.cttz.nxv4i32(<vscale x 4 x i32> %A, i1 true)
  ret void
}
declare <vscale x 4 x i32> @llvm.ctlz.nxv4i32(<vscale x 4 x i32>, i1)
declare <vscale x 4 x i32> @llvm.cttz.nxv4i32(<vscale x 4 x i32>, i1)


define void @vector_reverse() #0 {
; CHECK-LABEL: 'vector_reverse':
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv16i8 = call <vscale x 16 x i8> @llvm.experimental.vector.reverse.nxv16i8(<vscale x 16 x i8> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv32i8 = call <vscale x 32 x i8> @llvm.experimental.vector.reverse.nxv32i8(<vscale x 32 x i8> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv8i16 = call <vscale x 8 x i16> @llvm.experimental.vector.reverse.nxv8i16(<vscale x 8 x i16> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv16i16 = call <vscale x 16 x i16> @llvm.experimental.vector.reverse.nxv16i16(<vscale x 16 x i16> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv4i32 = call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv8i32 = call <vscale x 8 x i32> @llvm.experimental.vector.reverse.nxv8i32(<vscale x 8 x i32> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv2i64 = call <vscale x 2 x i64> @llvm.experimental.vector.reverse.nxv2i64(<vscale x 2 x i64> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv4i64 = call <vscale x 4 x i64> @llvm.experimental.vector.reverse.nxv4i64(<vscale x 4 x i64> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv8if16 = call <vscale x 8 x half> @llvm.experimental.vector.reverse.nxv8f16(<vscale x 8 x half> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv16f16 = call <vscale x 16 x half> @llvm.experimental.vector.reverse.nxv16f16(<vscale x 16 x half> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv4f32 = call <vscale x 4 x float> @llvm.experimental.vector.reverse.nxv4f32(<vscale x 4 x float> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv8f32 = call <vscale x 8 x float> @llvm.experimental.vector.reverse.nxv8f32(<vscale x 8 x float> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv2f64 = call <vscale x 2 x double> @llvm.experimental.vector.reverse.nxv2f64(<vscale x 2 x double> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv4f64 = call <vscale x 4 x double> @llvm.experimental.vector.reverse.nxv4f64(<vscale x 4 x double> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction: %reverse_nxv8bf16 = call <vscale x 8 x bfloat> @llvm.experimental.vector.reverse.nxv8bf16(<vscale x 8 x bfloat> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 2 for instruction: %reverse_nxv16bf16 = call <vscale x 16 x bfloat> @llvm.experimental.vector.reverse.nxv16bf16(<vscale x 16 x bfloat> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction:   %reverse_nxv16i1 = call <vscale x 16 x i1> @llvm.experimental.vector.reverse.nxv16i1(<vscale x 16 x i1> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction:   %reverse_nxv8i1 = call <vscale x 8 x i1> @llvm.experimental.vector.reverse.nxv8i1(<vscale x 8 x i1> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction:   %reverse_nxv4i1 = call <vscale x 4 x i1> @llvm.experimental.vector.reverse.nxv4i1(<vscale x 4 x i1> undef)
; CHECK-NEXT: Cost Model: Found an estimated cost of 1 for instruction:   %reverse_nxv2i1 = call <vscale x 2 x i1> @llvm.experimental.vector.reverse.nxv2i1(<vscale x 2 x i1> undef)

  %reverse_nxv16i8 = call <vscale x 16 x i8> @llvm.experimental.vector.reverse.nxv16i8(<vscale x 16 x i8> undef)
  %reverse_nxv32i8 = call <vscale x 32 x i8> @llvm.experimental.vector.reverse.nxv32i8(<vscale x 32 x i8> undef)
  %reverse_nxv8i16 = call <vscale x 8 x i16> @llvm.experimental.vector.reverse.nxv8i16(<vscale x 8 x i16> undef)
  %reverse_nxv16i16 = call <vscale x 16 x i16> @llvm.experimental.vector.reverse.nxv16i16(<vscale x 16 x i16> undef)
  %reverse_nxv4i32 = call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> undef)
  %reverse_nxv8i32 = call <vscale x 8 x i32> @llvm.experimental.vector.reverse.nxv8i32(<vscale x 8 x i32> undef)
  %reverse_nxv2i64 = call <vscale x 2 x i64> @llvm.experimental.vector.reverse.nxv2i64(<vscale x 2 x i64> undef)
  %reverse_nxv4i64 = call <vscale x 4 x i64> @llvm.experimental.vector.reverse.nxv4i64(<vscale x 4 x i64> undef)
  %reverse_nxv8if16 = call <vscale x 8 x half> @llvm.experimental.vector.reverse.nxv8f16(<vscale x 8 x half> undef)
  %reverse_nxv16f16 = call <vscale x 16 x half> @llvm.experimental.vector.reverse.nxv16f16(<vscale x 16 x half> undef)
  %reverse_nxv4f32 = call <vscale x 4 x float> @llvm.experimental.vector.reverse.nxv4f32(<vscale x 4 x float> undef)
  %reverse_nxv8f32 = call <vscale x 8 x float> @llvm.experimental.vector.reverse.nxv8f32(<vscale x 8 x float> undef)
  %reverse_nxv2f64 = call <vscale x 2 x double> @llvm.experimental.vector.reverse.nxv2f64(<vscale x 2 x double> undef)
  %reverse_nxv4f64 = call <vscale x 4 x double> @llvm.experimental.vector.reverse.nxv4f64(<vscale x 4 x double> undef)
  %reverse_nxv8bf16 = call <vscale x 8 x bfloat> @llvm.experimental.vector.reverse.nxv8bf16(<vscale x 8 x bfloat> undef)
  %reverse_nxv16bf16 = call <vscale x 16 x bfloat> @llvm.experimental.vector.reverse.nxv16bf16(<vscale x 16 x bfloat> undef)
  %reverse_nxv16i1 = call <vscale x 16 x i1> @llvm.experimental.vector.reverse.nxv16i1(<vscale x 16 x i1> undef)
  %reverse_nxv8i1 =  call <vscale x 8 x i1> @llvm.experimental.vector.reverse.nxv8i1(<vscale x 8 x i1> undef)
  %reverse_nxv4i1 = call <vscale x 4 x i1> @llvm.experimental.vector.reverse.nxv4i1(<vscale x 4 x i1> undef)
  %reverse_nxv2i1 = call <vscale x 2 x i1> @llvm.experimental.vector.reverse.nxv2i1(<vscale x 2 x i1> undef)
  ret void
}
declare <vscale x 16 x i8> @llvm.experimental.vector.reverse.nxv16i8(<vscale x 16 x i8>)
declare <vscale x 32 x i8> @llvm.experimental.vector.reverse.nxv32i8(<vscale x 32 x i8>)
declare <vscale x 8 x i16> @llvm.experimental.vector.reverse.nxv8i16(<vscale x 8 x i16>)
declare <vscale x 16 x i16> @llvm.experimental.vector.reverse.nxv16i16(<vscale x 16 x i16>)
declare <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32>)
declare <vscale x 8 x i32> @llvm.experimental.vector.reverse.nxv8i32(<vscale x 8 x i32>)
declare <vscale x 2 x i64> @llvm.experimental.vector.reverse.nxv2i64(<vscale x 2 x i64>)
declare <vscale x 4 x i64> @llvm.experimental.vector.reverse.nxv4i64(<vscale x 4 x i64>)
declare <vscale x 8 x half> @llvm.experimental.vector.reverse.nxv8f16(<vscale x 8 x half>)
declare <vscale x 16 x half> @llvm.experimental.vector.reverse.nxv16f16(<vscale x 16 x half>)
declare <vscale x 4 x float> @llvm.experimental.vector.reverse.nxv4f32(<vscale x 4 x float>)
declare <vscale x 8 x float> @llvm.experimental.vector.reverse.nxv8f32(<vscale x 8 x float>)
declare <vscale x 2 x double> @llvm.experimental.vector.reverse.nxv2f64(<vscale x 2 x double>)
declare <vscale x 4 x double> @llvm.experimental.vector.reverse.nxv4f64(<vscale x 4 x double>)
declare <vscale x 8 x bfloat> @llvm.experimental.vector.reverse.nxv8bf16(<vscale x 8 x bfloat>)
declare <vscale x 16 x bfloat> @llvm.experimental.vector.reverse.nxv16bf16(<vscale x 16 x bfloat>)
declare <vscale x 16 x i1> @llvm.experimental.vector.reverse.nxv16i1(<vscale x 16 x i1>)
declare <vscale x 8 x i1> @llvm.experimental.vector.reverse.nxv8i1(<vscale x 8 x i1>)
declare <vscale x 4 x i1> @llvm.experimental.vector.reverse.nxv4i1(<vscale x 4 x i1>)
declare <vscale x 2 x i1> @llvm.experimental.vector.reverse.nxv2i1(<vscale x 2 x i1>)

attributes #0 = { "target-features"="+sve,+bf16" }
