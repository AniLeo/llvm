; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve < %s | FileCheck %s

define <vscale x 2 x i64> @masked_gather_nxv2i8(<vscale x 2 x i8*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1b { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x i8> @llvm.masked.gather.nxv2i8(<vscale x 2 x i8*> %ptrs, i32 1, <vscale x 2 x i1> %mask, <vscale x 2 x i8> undef)
  %vals.zext = zext <vscale x 2 x i8> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.zext
}

define <vscale x 2 x i64> @masked_gather_nxv2i16(<vscale x 2 x i16*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x i16> undef)
  %vals.zext = zext <vscale x 2 x i16> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.zext
}

define <vscale x 2 x i64> @masked_gather_nxv2i32(<vscale x 2 x i32*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1w { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*> %ptrs, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x i32> undef)
  %vals.zext = zext <vscale x 2 x i32> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.zext
}

define <vscale x 2 x i64> @masked_gather_nxv2i64(<vscale x 2 x i64*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %mask, <vscale x 2 x i64> undef)
  ret <vscale x 2 x i64> %vals
}

define <vscale x 2 x half> @masked_gather_nxv2f16(<vscale x 2 x half*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x half> @llvm.masked.gather.nxv2f16(<vscale x 2 x half*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x half> undef)
  ret <vscale x 2 x half> %vals
}

define <vscale x 2 x bfloat> @masked_gather_nxv2bf16(<vscale x 2 x bfloat*> %ptrs, <vscale x 2 x i1> %mask) #0 {
; CHECK-LABEL: masked_gather_nxv2bf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x bfloat> @llvm.masked.gather.nxv2bf16(<vscale x 2 x bfloat*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x bfloat> undef)
  ret <vscale x 2 x bfloat> %vals
}

define <vscale x 2 x float> @masked_gather_nxv2f32(<vscale x 2 x float*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1w { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x float> @llvm.masked.gather.nxv2f32(<vscale x 2 x float*> %ptrs, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x float> undef)
  ret <vscale x 2 x float> %vals
}

define <vscale x 2 x double> @masked_gather_nxv2f64(<vscale x 2 x double*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x double> @llvm.masked.gather.nxv2f64(<vscale x 2 x double*> %ptrs, i32 8, <vscale x 2 x i1> %mask, <vscale x 2 x double> undef)
  ret <vscale x 2 x double> %vals
}

define <vscale x 2 x i64> @masked_sgather_nxv2i8(<vscale x 2 x i8*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_sgather_nxv2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sb { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x i8> @llvm.masked.gather.nxv2i8(<vscale x 2 x i8*> %ptrs, i32 1, <vscale x 2 x i1> %mask, <vscale x 2 x i8> undef)
  %vals.sext = sext <vscale x 2 x i8> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.sext
}

define <vscale x 2 x i64> @masked_sgather_nxv2i16(<vscale x 2 x i16*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_sgather_nxv2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sh { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x i16> undef)
  %vals.sext = sext <vscale x 2 x i16> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.sext
}

define <vscale x 2 x i64> @masked_sgather_nxv2i32(<vscale x 2 x i32*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_sgather_nxv2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sw { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ret
  %vals = call <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*> %ptrs, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x i32> undef)
  %vals.sext = sext <vscale x 2 x i32> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.sext
}

declare <vscale x 2 x i8> @llvm.masked.gather.nxv2i8(<vscale x 2 x i8*>, i32, <vscale x 2 x i1>, <vscale x 2 x i8>)
declare <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*>, i32, <vscale x 2 x i1>, <vscale x 2 x i16>)
declare <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*>, i32, <vscale x 2 x i1>, <vscale x 2 x i32>)
declare <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*>, i32, <vscale x 2 x i1>, <vscale x 2 x i64>)
declare <vscale x 2 x half> @llvm.masked.gather.nxv2f16(<vscale x 2 x half*>, i32, <vscale x 2 x i1>, <vscale x 2 x half>)
declare <vscale x 2 x bfloat> @llvm.masked.gather.nxv2bf16(<vscale x 2 x bfloat*>, i32, <vscale x 2 x i1>, <vscale x 2 x bfloat>)
declare <vscale x 2 x float> @llvm.masked.gather.nxv2f32(<vscale x 2 x float*>, i32, <vscale x 2 x i1>, <vscale x 2 x float>)
declare <vscale x 2 x double> @llvm.masked.gather.nxv2f64(<vscale x 2 x double*>, i32, <vscale x 2 x i1>, <vscale x 2 x double>)
attributes #0 = { "target-features"="+sve,+bf16" }
