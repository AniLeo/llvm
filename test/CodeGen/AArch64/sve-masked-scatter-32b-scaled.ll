; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scaled unpacked 32-bit offsets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define void @masked_scatter_nxv2i16_sext(<vscale x 2 x i16> %data, i16* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i16_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, sxtw #1]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16> %data, <vscale x 2 x i16*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i32_sext(<vscale x 2 x i32> %data, i32* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i32_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, sxtw #2]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32> %data, <vscale x 2 x i32*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i64_sext(<vscale x 2 x i64> %data, i64* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i64_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, sxtw #3]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr i64, i64* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x i64*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f16_sext(<vscale x 2 x half> %data, half* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f16_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, sxtw #1]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr half, half* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half> %data, <vscale x 2 x half*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2bf16_sext(<vscale x 2 x bfloat> %data, bfloat* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv2bf16_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, sxtw #1]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr bfloat, bfloat* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat> %data, <vscale x 2 x bfloat*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f32_sext(<vscale x 2 x float> %data, float* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f32_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, sxtw #2]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr float, float* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float> %data, <vscale x 2 x float*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f64_sext(<vscale x 2 x double> %data, double* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f64_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, sxtw #3]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr double, double* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double> %data, <vscale x 2 x double*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i16_zext(<vscale x 2 x i16> %data, i16* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i16_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, uxtw #1]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16> %data, <vscale x 2 x i16*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i32_zext(<vscale x 2 x i32> %data, i32* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i32_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, uxtw #2]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32> %data, <vscale x 2 x i32*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i64_zext(<vscale x 2 x i64> %data, i64* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i64_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, uxtw #3]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr i64, i64* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x i64*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f16_zext(<vscale x 2 x half> %data, half* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f16_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, uxtw #1]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr half, half* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half> %data, <vscale x 2 x half*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2bf16_zext(<vscale x 2 x bfloat> %data, bfloat* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv2bf16_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, uxtw #1]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr bfloat, bfloat* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat> %data, <vscale x 2 x bfloat*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f32_zext(<vscale x 2 x float> %data, float* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f32_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, uxtw #2]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr float, float* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float> %data, <vscale x 2 x float*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f64_zext(<vscale x 2 x double> %data, double* %base, <vscale x 2 x i32> %indexes, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f64_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, uxtw #3]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 2 x i32> %indexes to <vscale x 2 x i64>
  %ptrs = getelementptr double, double* %base, <vscale x 2 x i64> %ext
  call void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double> %data, <vscale x 2 x double*> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scaled packed 32-bit offset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define void @masked_scatter_nxv4i16_sext(<vscale x 4 x i16> %data, i16* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i16_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw #1]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16> %data, <vscale x 4 x i16*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i32_sext(<vscale x 4 x i32> %data, i32* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i32_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, sxtw #2]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> %data, <vscale x 4 x i32*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f16_sext(<vscale x 4 x half> %data, half* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4f16_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw #1]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr half, half* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x half*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4bf16_sext(<vscale x 4 x bfloat> %data, bfloat* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4bf16_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw #1]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr bfloat, bfloat* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4bf16(<vscale x 4 x bfloat> %data, <vscale x 4 x bfloat*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f32_sext(<vscale x 4 x float> %data, float* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4f32_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, sxtw #2]
; CHECK-NEXT:    ret
  %ext = sext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr float, float* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float> %data, <vscale x 4 x float*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i16_zext(<vscale x 4 x i16> %data, i16* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i16_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, uxtw #1]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16> %data, <vscale x 4 x i16*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i32_zext(<vscale x 4 x i32> %data, i32* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i32_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, uxtw #2]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> %data, <vscale x 4 x i32*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f16_zext(<vscale x 4 x half> %data, half* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4f16_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, uxtw #1]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr half, half* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x half*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4bf16_zext(<vscale x 4 x bfloat> %data, bfloat* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4bf16_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, uxtw #1]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr bfloat, bfloat* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4bf16(<vscale x 4 x bfloat> %data, <vscale x 4 x bfloat*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f32_zext(<vscale x 4 x float> %data, float* %base, <vscale x 4 x i32> %indexes, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4f32_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, uxtw #2]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 4 x i32> %indexes to <vscale x 4 x i64>
  %ptrs = getelementptr float, float* %base, <vscale x 4 x i64> %ext
  call void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float> %data, <vscale x 4 x float*> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

declare void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half>, <vscale x 2 x half*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half>, <vscale x 4 x half*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4bf16(<vscale x 4 x bfloat>, <vscale x 4 x bfloat*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float>, <vscale x 4 x float*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat>, <vscale x 2 x bfloat*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double>, <vscale x 2 x double*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x i16*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x i8*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16>, <vscale x 4 x i16*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i32*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8>, <vscale x 4 x i8*>, i32, <vscale x 4 x i1>)
attributes #0 = { "target-features"="+sve,+bf16" }
