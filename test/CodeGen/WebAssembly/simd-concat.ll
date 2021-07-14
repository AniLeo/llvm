; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mattr=+simd128 | FileCheck %s

; Check that all varieties of vector concatenations get lowered to shuffles.

target triple = "wasm32-unknown--wasm"

define <16 x i8> @concat_v8i8(<8 x i8> %a, <8 x i8> %b) {
; CHECK-LABEL: concat_v8i8:
; CHECK:         .functype concat_v8i8 (v128, v128) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shuffle 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
; CHECK-NEXT:    # fallthrough-return
  %v = shufflevector <8 x i8> %a, <8 x i8> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i8> %v
}

define <8 x i8> @concat_v4i8(<4 x i8> %a, <4 x i8> %b) {
; CHECK-LABEL: concat_v4i8:
; CHECK:         .functype concat_v4i8 (v128, v128) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shuffle 0, 1, 4, 5, 8, 9, 12, 13, 16, 17, 20, 21, 24, 25, 28, 29
; CHECK-NEXT:    # fallthrough-return
  %v = shufflevector <4 x i8> %a, <4 x i8> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i8> %v
}

define <8 x i16> @concat_v4i16(<4 x i16> %a, <4 x i16> %b) {
; CHECK-LABEL: concat_v4i16:
; CHECK:         .functype concat_v4i16 (v128, v128) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shuffle 0, 1, 4, 5, 8, 9, 12, 13, 16, 17, 20, 21, 24, 25, 28, 29
; CHECK-NEXT:    # fallthrough-return
  %v = shufflevector <4 x i16> %a, <4 x i16> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i16> %v
}

define <4 x i8> @concat_v2i8(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: concat_v2i8:
; CHECK:         .functype concat_v2i8 (v128, v128) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shuffle 0, 1, 2, 3, 8, 9, 10, 11, 16, 17, 18, 19, 24, 25, 26, 27
; CHECK-NEXT:    # fallthrough-return
  %v = shufflevector <2 x i8> %a, <2 x i8> %b, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i8> %v
}

define <4 x i16> @concat_v2i16(<2 x i16> %a, <2 x i16> %b) {
; CHECK-LABEL: concat_v2i16:
; CHECK:         .functype concat_v2i16 (v128, v128) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shuffle 0, 1, 2, 3, 8, 9, 10, 11, 16, 17, 18, 19, 24, 25, 26, 27
; CHECK-NEXT:    # fallthrough-return
  %v = shufflevector <2 x i16> %a, <2 x i16> %b, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i16> %v
}

define <4 x i32> @concat_v2i32(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: concat_v2i32:
; CHECK:         .functype concat_v2i32 (v128, v128) -> (v128)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    local.get 0
; CHECK-NEXT:    local.get 1
; CHECK-NEXT:    i8x16.shuffle 0, 1, 2, 3, 8, 9, 10, 11, 16, 17, 18, 19, 24, 25, 26, 27
; CHECK-NEXT:    # fallthrough-return
  %v = shufflevector <2 x i32> %a, <2 x i32> %b, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %v
}
