; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve < %s | FileCheck %s

define void @masked_scatter_nxv2i8(<vscale x 2 x i8> %data, <vscale x 2 x i8*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1b { z0.d }, p0, [z1.d, #1]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i8, <vscale x 2 x i8*> %bases, i32 1
  call void @llvm.masked.scatter.nxv2i8(<vscale x 2 x i8> %data, <vscale x 2 x i8*> %ptrs, i32 1, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2i16(<vscale x 2 x i16> %data, <vscale x 2 x i16*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [z1.d, #2]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i16, <vscale x 2 x i16*> %bases, i32 1
  call void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16> %data, <vscale x 2 x i16*> %ptrs, i32 2, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2i32(<vscale x 2 x i32> %data, <vscale x 2 x i32*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [z1.d, #4]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i32, <vscale x 2 x i32*> %bases, i32 1
  call void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32> %data, <vscale x 2 x i32*> %ptrs, i32 4, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x i64*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [z1.d, #8]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i64, <vscale x 2 x i64*> %bases, i32 1
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2f16(<vscale x 2 x half> %data, <vscale x 2 x half*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [z1.d, #4]
; CHECK-NEXT:    ret
  %ptrs = getelementptr half, <vscale x 2 x half*> %bases, i32 2
  call void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half> %data, <vscale x 2 x half*> %ptrs, i32 2, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2bf16(<vscale x 2 x bfloat> %data, <vscale x 2 x bfloat*> %bases, <vscale x 2 x i1> %mask) #0 {
; CHECK-LABEL: masked_scatter_nxv2bf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [z1.d, #4]
; CHECK-NEXT:    ret
  %ptrs = getelementptr bfloat, <vscale x 2 x bfloat*> %bases, i32 2
  call void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat> %data, <vscale x 2 x bfloat*> %ptrs, i32 2, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2f32(<vscale x 2 x float> %data, <vscale x 2 x float*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [z1.d, #12]
; CHECK-NEXT:    ret
  %ptrs = getelementptr float, <vscale x 2 x float*> %bases, i32 3
  call void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float> %data, <vscale x 2 x float*> %ptrs, i32 4, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2f64(<vscale x 2 x double> %data, <vscale x 2 x double*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [z1.d, #32]
; CHECK-NEXT:    ret
  %ptrs = getelementptr double, <vscale x 2 x double*> %bases, i32 4
  call void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double> %data, <vscale x 2 x double*> %ptrs, i32 8, <vscale x 2 x i1> %mask)
  ret void
}

; Test where the immediate is out of range

define void @masked_scatter_nxv2i8_range(<vscale x 2 x i8> %data, <vscale x 2 x i8*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2i8_range:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #32
; CHECK-NEXT:    st1b { z0.d }, p0, [x8, z1.d]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i8, <vscale x 2 x i8*> %bases, i32 32
  call void @llvm.masked.scatter.nxv2i8(<vscale x 2 x i8> %data, <vscale x 2 x i8*> %ptrs, i32 1, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2i16_range(<vscale x 2 x i16> %data, <vscale x 2 x i16*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2i16_range:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #64
; CHECK-NEXT:    st1h { z0.d }, p0, [x8, z1.d]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i16, <vscale x 2 x i16*> %bases, i32 32
  call void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16> %data, <vscale x 2 x i16*> %ptrs, i32 2, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2i32_range(<vscale x 2 x i32> %data, <vscale x 2 x i32*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2i32_range:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #128
; CHECK-NEXT:    st1w { z0.d }, p0, [x8, z1.d]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i32, <vscale x 2 x i32*> %bases, i32 32
  call void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32> %data, <vscale x 2 x i32*> %ptrs, i32 1, <vscale x 2 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv2f64_range(<vscale x 2 x double> %data, <vscale x 2 x double*> %bases, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_scatter_nxv2f64_range:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #256
; CHECK-NEXT:    st1d { z0.d }, p0, [x8, z1.d]
; CHECK-NEXT:    ret
  %ptrs = getelementptr double, <vscale x 2 x double*> %bases, i32 32
  call void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double> %data, <vscale x 2 x double*> %ptrs, i32 8, <vscale x 2 x i1> %mask)
  ret void
}

declare void @llvm.masked.scatter.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x i8*>,  i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x i16*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half>, <vscale x 2 x half*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat>, <vscale x 2 x bfloat*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double>, <vscale x 2 x double*>, i32, <vscale x 2 x i1>)
attributes #0 = { "target-features"="+sve,+bf16" }
