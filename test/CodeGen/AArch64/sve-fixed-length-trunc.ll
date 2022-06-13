; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -aarch64-sve-vector-bits-min=256  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_256
; RUN: llc -aarch64-sve-vector-bits-min=512  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=2048 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512

target triple = "aarch64-unknown-linux-gnu"

;
; truncate i16 -> i8
;

define <16 x i8> @trunc_v16i16_v16i8(<16 x i16>* %in) vscale_range(2,0) #0 {
; CHECK-LABEL: trunc_v16i16_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl16
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %a = load <16 x i16>, <16 x i16>* %in
  %b = trunc <16 x i16> %a to <16 x i8>
  ret <16 x i8> %b
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v32i16_v32i8(<32 x i16>* %in, <32 x i8>* %out) #0 {
; VBITS_GE_256-LABEL: trunc_v32i16_v32i8:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x8, #16
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x8, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.b, vl16
; VBITS_GE_256-NEXT:    uzp1 z0.b, z0.b, z0.b
; VBITS_GE_256-NEXT:    uzp1 z1.b, z1.b, z1.b
; VBITS_GE_256-NEXT:    splice z1.b, p0, z1.b, z0.b
; VBITS_GE_256-NEXT:    ptrue p0.b, vl32
; VBITS_GE_256-NEXT:    add z0.b, z1.b, z1.b
; VBITS_GE_256-NEXT:    st1b { z0.b }, p0, [x1]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: trunc_v32i16_v32i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.h, vl32
; VBITS_GE_512-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ptrue p0.b, vl32
; VBITS_GE_512-NEXT:    uzp1 z0.b, z0.b, z0.b
; VBITS_GE_512-NEXT:    add z0.b, z0.b, z0.b
; VBITS_GE_512-NEXT:    st1b { z0.b }, p0, [x1]
; VBITS_GE_512-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %in
  %b = trunc <32 x i16> %a to <32 x i8>
  %c = add <32 x i8> %b, %b
  store <32 x i8> %c, <32 x i8>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v64i16_v64i8(<64 x i16>* %in, <64 x i8>* %out) vscale_range(8,0) #0 {
; CHECK-LABEL: trunc_v64i16_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl64
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    add z0.b, z0.b, z0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <64 x i16>, <64 x i16>* %in
  %b = trunc <64 x i16> %a to <64 x i8>
  %c = add <64 x i8> %b, %b
  store <64 x i8> %c, <64 x i8>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v128i16_v128i8(<128 x i16>* %in, <128 x i8>* %out) vscale_range(16,0) #0 {
; CHECK-LABEL: trunc_v128i16_v128i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl128
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.b, vl128
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    add z0.b, z0.b, z0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <128 x i16>, <128 x i16>* %in
  %b = trunc <128 x i16> %a to <128 x i8>
  %c = add <128 x i8> %b, %b
  store <128 x i8> %c, <128 x i8>* %out
  ret void
}

;
; truncate i32 -> i8
;

define <8 x i8> @trunc_v8i32_v8i8(<8 x i32>* %in) vscale_range(2,0) #0 {
; CHECK-LABEL: trunc_v8i32_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %in
  %b = trunc <8 x i32> %a to <8 x i8>
  ret <8 x i8> %b
}

define <16 x i8> @trunc_v16i32_v16i8(<16 x i32>* %in) #0 {
; VBITS_GE_256-LABEL: trunc_v16i32_v16i8:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x8, #8
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_256-NEXT:    uzp1 z1.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    uzp1 z2.b, z0.b, z0.b
; VBITS_GE_256-NEXT:    uzp1 z0.b, z1.b, z1.b
; VBITS_GE_256-NEXT:    mov v0.d[1], v2.d[0]
; VBITS_GE_256-NEXT:    // kill: def $q0 killed $q0 killed $z0
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: trunc_v16i32_v16i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_512-NEXT:    uzp1 z0.b, z0.b, z0.b
; VBITS_GE_512-NEXT:    // kill: def $q0 killed $q0 killed $z0
; VBITS_GE_512-NEXT:    ret
  %a = load <16 x i32>, <16 x i32>* %in
  %b = trunc <16 x i32> %a to <16 x i8>
  ret <16 x i8> %b
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v32i32_v32i8(<32 x i32>* %in, <32 x i8>* %out) vscale_range(8,0) #0 {
; CHECK-LABEL: trunc_v32i32_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl32
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.b, vl32
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    add z0.b, z0.b, z0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <32 x i32>, <32 x i32>* %in
  %b = trunc <32 x i32> %a to <32 x i8>
  %c = add <32 x i8> %b, %b
  store <32 x i8> %c, <32 x i8>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v64i32_v64i8(<64 x i32>* %in, <64 x i8>* %out) vscale_range(16,0) #0 {
; CHECK-LABEL: trunc_v64i32_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl64
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    add z0.b, z0.b, z0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <64 x i32>, <64 x i32>* %in
  %b = trunc <64 x i32> %a to <64 x i8>
  %c = add <64 x i8> %b, %b
  store <64 x i8> %c, <64 x i8>* %out
  ret void
}

;
; truncate i32 -> i16
;

define <8 x i16> @trunc_v8i32_v8i16(<8 x i32>* %in) vscale_range(2,0) #0 {
; CHECK-LABEL: trunc_v8i32_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %in
  %b = trunc <8 x i32> %a to <8 x i16>
  ret <8 x i16> %b
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v16i32_v16i16(<16 x i32>* %in, <16 x i16>* %out) #0 {
; VBITS_GE_256-LABEL: trunc_v16i32_v16i16:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x8, #8
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.h, vl8
; VBITS_GE_256-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_256-NEXT:    uzp1 z1.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    splice z1.h, p0, z1.h, z0.h
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    add z0.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    st1h { z0.h }, p0, [x1]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: trunc_v16i32_v16i16:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ptrue p0.h, vl16
; VBITS_GE_512-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_512-NEXT:    add z0.h, z0.h, z0.h
; VBITS_GE_512-NEXT:    st1h { z0.h }, p0, [x1]
; VBITS_GE_512-NEXT:    ret
  %a = load <16 x i32>, <16 x i32>* %in
  %b = trunc <16 x i32> %a to <16 x i16>
  %c = add <16 x i16> %b, %b
  store <16 x i16> %c, <16 x i16>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v32i32_v32i16(<32 x i32>* %in, <32 x i16>* %out) vscale_range(8,0) #0 {
; CHECK-LABEL: trunc_v32i32_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl32
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    add z0.h, z0.h, z0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <32 x i32>, <32 x i32>* %in
  %b = trunc <32 x i32> %a to <32 x i16>
  %c = add <32 x i16> %b, %b
  store <32 x i16> %c, <32 x i16>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v64i32_v64i16(<64 x i32>* %in, <64 x i16>* %out) vscale_range(16,0) #0 {
; CHECK-LABEL: trunc_v64i32_v64i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl64
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.h, vl64
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    add z0.h, z0.h, z0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <64 x i32>, <64 x i32>* %in
  %b = trunc <64 x i32> %a to <64 x i16>
  %c = add <64 x i16> %b, %b
  store <64 x i16> %c, <64 x i16>* %out
  ret void
}

;
; truncate i64 -> i8
;

; NOTE: v4i8 is not legal so result i8 elements are held within i16 containers.
define <4 x i8> @trunc_v4i64_v4i8(<4 x i64>* %in) vscale_range(2,0) #0 {
; CHECK-LABEL: trunc_v4i64_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl4
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %in
  %b = trunc <4 x i64> %a to <4 x i8>
  ret <4 x i8> %b
}

define <8 x i8> @trunc_v8i64_v8i8(<8 x i64>* %in) #0 {
; VBITS_GE_256-LABEL: trunc_v8i64_v8i8:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x8, #4
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    ld1d { z0.d }, p0/z, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl4
; VBITS_GE_256-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_256-NEXT:    uzp1 z1.s, z1.s, z1.s
; VBITS_GE_256-NEXT:    splice z1.s, p0, z1.s, z0.s
; VBITS_GE_256-NEXT:    uzp1 z0.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    uzp1 z0.b, z0.b, z0.b
; VBITS_GE_256-NEXT:    // kill: def $d0 killed $d0 killed $z0
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: trunc_v8i64_v8i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_512-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_512-NEXT:    uzp1 z0.b, z0.b, z0.b
; VBITS_GE_512-NEXT:    // kill: def $d0 killed $d0 killed $z0
; VBITS_GE_512-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %in
  %b = trunc <8 x i64> %a to <8 x i8>
  ret <8 x i8> %b
}

define <16 x i8> @trunc_v16i64_v16i8(<16 x i64>* %in) vscale_range(8,0) #0 {
; CHECK-LABEL: trunc_v16i64_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl16
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %a = load <16 x i64>, <16 x i64>* %in
  %b = trunc <16 x i64> %a to <16 x i8>
  ret <16 x i8> %b
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v32i64_v32i8(<32 x i64>* %in, <32 x i8>* %out) vscale_range(16,0) #0 {
; CHECK-LABEL: trunc_v32i64_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl32
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.b, vl32
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    uzp1 z0.b, z0.b, z0.b
; CHECK-NEXT:    add z0.b, z0.b, z0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <32 x i64>, <32 x i64>* %in
  %b = trunc <32 x i64> %a to <32 x i8>
  %c = add <32 x i8> %b, %b
  store <32 x i8> %c, <32 x i8>* %out
  ret void
}

;
; truncate i64 -> i16
;

define <4 x i16> @trunc_v4i64_v4i16(<4 x i64>* %in) vscale_range(2,0) #0 {
; CHECK-LABEL: trunc_v4i64_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl4
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %in
  %b = trunc <4 x i64> %a to <4 x i16>
  ret <4 x i16> %b
}

define <8 x i16> @trunc_v8i64_v8i16(<8 x i64>* %in) #0 {
; VBITS_GE_256-LABEL: trunc_v8i64_v8i16:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x8, #4
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    ld1d { z0.d }, p0/z, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_256-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_256-NEXT:    uzp1 z1.s, z1.s, z1.s
; VBITS_GE_256-NEXT:    uzp1 z2.h, z0.h, z0.h
; VBITS_GE_256-NEXT:    uzp1 z0.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    mov v0.d[1], v2.d[0]
; VBITS_GE_256-NEXT:    // kill: def $q0 killed $q0 killed $z0
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: trunc_v8i64_v8i16:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_512-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_512-NEXT:    // kill: def $q0 killed $q0 killed $z0
; VBITS_GE_512-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %in
  %b = trunc <8 x i64> %a to <8 x i16>
  ret <8 x i16> %b
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v16i64_v16i16(<16 x i64>* %in, <16 x i16>* %out) vscale_range(8,0) #0 {
; CHECK-LABEL: trunc_v16i64_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl16
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.h, vl16
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    add z0.h, z0.h, z0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <16 x i64>, <16 x i64>* %in
  %b = trunc <16 x i64> %a to <16 x i16>
  %c = add <16 x i16> %b, %b
  store <16 x i16> %c, <16 x i16>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v32i64_v32i16(<32 x i64>* %in, <32 x i16>* %out) vscale_range(16,0) #0 {
; CHECK-LABEL: trunc_v32i64_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl32
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    add z0.h, z0.h, z0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <32 x i64>, <32 x i64>* %in
  %b = trunc <32 x i64> %a to <32 x i16>
  %c = add <32 x i16> %b, %b
  store <32 x i16> %c, <32 x i16>* %out
  ret void
}

;
; truncate i64 -> i32
;

define <4 x i32> @trunc_v4i64_v4i32(<4 x i64>* %in) vscale_range(2,0) #0 {
; CHECK-LABEL: trunc_v4i64_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl4
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %in
  %b = trunc <4 x i64> %a to <4 x i32>
  ret <4 x i32> %b
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v8i64_v8i32(<8 x i64>* %in, <8 x i32>* %out) #0 {
; VBITS_GE_256-LABEL: trunc_v8i64_v8i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x8, #4
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    ld1d { z0.d }, p0/z, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl4
; VBITS_GE_256-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_256-NEXT:    uzp1 z1.s, z1.s, z1.s
; VBITS_GE_256-NEXT:    splice z1.s, p0, z1.s, z0.s
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    add z0.s, z1.s, z1.s
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x1]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: trunc_v8i64_v8i32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ptrue p0.s, vl8
; VBITS_GE_512-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_512-NEXT:    add z0.s, z0.s, z0.s
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x1]
; VBITS_GE_512-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %in
  %b = trunc <8 x i64> %a to <8 x i32>
  %c = add <8 x i32> %b, %b
  store <8 x i32> %c, <8 x i32>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v16i64_v16i32(<16 x i64>* %in, <16 x i32>* %out) vscale_range(8,0) #0 {
; CHECK-LABEL: trunc_v16i64_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl16
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    add z0.s, z0.s, z0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <16 x i64>, <16 x i64>* %in
  %b = trunc <16 x i64> %a to <16 x i32>
  %c = add <16 x i32> %b, %b
  store <16 x i32> %c, <16 x i32>* %out
  ret void
}

; NOTE: Extra 'add' is to prevent the truncate being combined with the store.
define void @trunc_v32i64_v32i32(<32 x i64>* %in, <32 x i32>* %out) vscale_range(16,0) #0 {
; CHECK-LABEL: trunc_v32i64_v32i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl32
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ptrue p0.s, vl32
; CHECK-NEXT:    uzp1 z0.s, z0.s, z0.s
; CHECK-NEXT:    add z0.s, z0.s, z0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <32 x i64>, <32 x i64>* %in
  %b = trunc <32 x i64> %a to <32 x i32>
  %c = add <32 x i32> %b, %b
  store <32 x i32> %c, <32 x i32>* %out
  ret void
}

attributes #0 = { nounwind "target-features"="+sve" }
