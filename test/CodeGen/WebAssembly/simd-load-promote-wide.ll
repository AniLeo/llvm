; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mattr=+simd128 | FileCheck %s

; Test wide load+promote patterns, which after combines and legalization are
; represented differently than 128-bit load+promote patterns.

target triple = "wasm32-unknown-unknown"

define <4 x double> @load_promote_v2f64(<4 x float>* %p) {
; CHECK-LABEL: load_promote_v2f64:
; CHECK:         .functype load_promote_v2f64 (i32, i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 8
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    # fallthrough-return
  %e = load <4 x float>, <4 x float>* %p
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}

define <4 x double> @load_promote_v2f64_with_folded_offset(<4 x float>* %p) {
; CHECK-LABEL: load_promote_v2f64_with_folded_offset:
; CHECK:         .functype load_promote_v2f64_with_folded_offset (i32, i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 24
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 16
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    # fallthrough-return
  %q = ptrtoint <4 x float>* %p to i32
  %r = add nuw i32 %q, 16
  %s = inttoptr i32 %r to <4 x float>*
  %e = load <4 x float>, <4 x float>* %s
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}

define <4 x double> @load_promote_v2f64_with_folded_gep_offset(<4 x float>* %p) {
; CHECK-LABEL: load_promote_v2f64_with_folded_gep_offset:
; CHECK:         .functype load_promote_v2f64_with_folded_gep_offset (i32, i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 24
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 16
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    # fallthrough-return
  %s = getelementptr inbounds <4 x float>, <4 x float>* %p, i32 1
  %e = load <4 x float>, <4 x float>* %s
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}

define <4 x double> @load_promote_v2f64_with_unfolded_gep_negative_offset(<4 x float>* %p) {
; CHECK-LABEL: load_promote_v2f64_with_unfolded_gep_negative_offset:
; CHECK:         .functype load_promote_v2f64_with_unfolded_gep_negative_offset (i32, i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const -16
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    local.tee 1
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 8
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    # fallthrough-return
  %s = getelementptr inbounds <4 x float>, <4 x float>* %p, i32 -1
  %e = load <4 x float>, <4 x float>* %s
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}

define <4 x double> @load_promote_v2f64_with_unfolded_offset(<4 x float>* %p) {
; CHECK-LABEL: load_promote_v2f64_with_unfolded_offset:
; CHECK:         .functype load_promote_v2f64_with_unfolded_offset (i32, i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 24
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 16
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    # fallthrough-return
  %q = ptrtoint <4 x float>* %p to i32
  %r = add nsw i32 %q, 16
  %s = inttoptr i32 %r to <4 x float>*
  %e = load <4 x float>, <4 x float>* %s
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}

define <4 x double> @load_promote_v2f64_with_unfolded_gep_offset(<4 x float>* %p) {
; CHECK-LABEL: load_promote_v2f64_with_unfolded_gep_offset:
; CHECK:         .functype load_promote_v2f64_with_unfolded_gep_offset (i32, i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 24
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i32.const 16
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    # fallthrough-return
  %s = getelementptr <4 x float>, <4 x float>* %p, i32 1
  %e = load <4 x float>, <4 x float>* %s
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}

define <4 x double> @load_promote_v2f64_from_numeric_address() {
; CHECK-LABEL: load_promote_v2f64_from_numeric_address:
; CHECK:         .functype load_promote_v2f64_from_numeric_address (i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    i32.const 40
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    i32.const 32
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    # fallthrough-return
  %s = inttoptr i32 32 to <4 x float>*
  %e = load <4 x float>, <4 x float>* %s
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}

@gv_v4f32 = global <4 x float> <float 42., float 42., float 42., float 42.>
define <4 x double> @load_promote_v2f64_from_global_address() {
; CHECK-LABEL: load_promote_v2f64_from_global_address:
; CHECK:         .functype load_promote_v2f64_from_global_address (i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    i32.const gv_v4f32
; CHECK-NEXT:    i32.const 8
; CHECK-NEXT:    i32.add
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 16
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    i32.const gv_v4f32
; CHECK-NEXT:    v128.load64_zero 0
; CHECK-NEXT:    f64x2.promote_low_f32x4
; CHECK-NEXT:    v128.store 0
; CHECK-NEXT:    # fallthrough-return
  %e = load <4 x float>, <4 x float>* @gv_v4f32
  %v = fpext <4 x float> %e to <4 x double>
  ret <4 x double> %v
}
