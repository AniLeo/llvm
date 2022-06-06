; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Don't use SVE when its registers are no bigger than NEON.
; RUN: llc -aarch64-sve-vector-bits-min=128  < %s | not grep ptrue
; RUN: llc -aarch64-sve-vector-bits-min=256  < %s | FileCheck %s -D#VBYTES=32  -check-prefixes=CHECK,VBITS_GE_256
; RUN: llc -aarch64-sve-vector-bits-min=384  < %s | FileCheck %s -D#VBYTES=32  -check-prefixes=CHECK,VBITS_GE_256
; RUN: llc -aarch64-sve-vector-bits-min=512  < %s | FileCheck %s -D#VBYTES=64  -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=640  < %s | FileCheck %s -D#VBYTES=64  -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=768  < %s | FileCheck %s -D#VBYTES=64  -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=896  < %s | FileCheck %s -D#VBYTES=64  -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=1024 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1152 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1280 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1408 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1536 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1664 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1792 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1920 < %s | FileCheck %s -D#VBYTES=128 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=2048 < %s | FileCheck %s -D#VBYTES=256 -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024,VBITS_GE_2048

target triple = "aarch64-unknown-linux-gnu"

define <4 x i32> @load_zext_v4i16i32(<4 x i16>* %ap) #0 {
; CHECK-LABEL: load_zext_v4i16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %ap
  %val = zext <4 x i16> %a to <4 x i32>
  ret <4 x i32> %val
}

; Don't try to use SVE for irregular types.
define <2 x i256> @load_zext_v2i64i256(<2 x i64>* %ap) #0 {
; CHECK-LABEL: load_zext_v2i64i256:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    mov x1, xzr
; CHECK-NEXT:    mov x2, xzr
; CHECK-NEXT:    mov x3, xzr
; CHECK-NEXT:    mov x5, xzr
; CHECK-NEXT:    mov x6, xzr
; CHECK-NEXT:    mov x4, v0.d[1]
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    mov x7, xzr
; CHECK-NEXT:    ret
  %a = load <2 x i64>, <2 x i64>* %ap
  %val = zext <2 x i64> %a to <2 x i256>
  ret <2 x i256> %val
}

define <8 x i32> @load_zext_v8i16i32(<8 x i16>* %ap) #0 {
; CHECK-LABEL: load_zext_v8i16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1h { z0.s }, p0/z, [x0]
; CHECK-NEXT:    st1w { z0.s }, p0, [x8]
; CHECK-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %ap
  %val = zext <8 x i16> %a to <8 x i32>
  ret <8 x i32> %val
}

define <16 x i32> @load_zext_v16i16i32(<16 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_zext_v16i16i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    uunpklo z1.s, z0.h
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    uunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: load_zext_v16i16i32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1h { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_512-NEXT:    ret

  ; Ensure sensible type legalistaion
  %a = load <16 x i16>, <16 x i16>* %ap
  %val = zext <16 x i16> %a to <16 x i32>
  ret <16 x i32> %val
}

define <32 x i32> @load_zext_v32i16i32(<32 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_zext_v32i16i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x10, #24
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x9, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    uunpklo z2.s, z0.h
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    uunpklo z2.s, z1.h
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    uunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    uunpklo z1.s, z1.h
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_1024-LABEL: load_zext_v32i16i32:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    ptrue p0.s, vl32
; VBITS_GE_1024-NEXT:    ld1h { z0.s }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_1024-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %ap
  %val = zext <32 x i16> %a to <32 x i32>
  ret <32 x i32> %val
}

define <64 x i32> @load_zext_v64i16i32(<64 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_zext_v64i16i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    mov x10, #32
; VBITS_GE_256-NEXT:    mov x11, #48
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x12, #24
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x9, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0, x10, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z2.h }, p0/z, [x0, x11, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z3.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    uunpklo z4.s, z0.h
; VBITS_GE_256-NEXT:    uunpklo z5.s, z1.h
; VBITS_GE_256-NEXT:    uunpklo z6.s, z2.h
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    st1w { z6.s }, p0, [x8, x11, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z5.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    mov x10, #56
; VBITS_GE_256-NEXT:    mov x11, #40
; VBITS_GE_256-NEXT:    st1w { z4.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    ext z2.b, z2.b, z2.b, #16
; VBITS_GE_256-NEXT:    uunpklo z7.s, z3.h
; VBITS_GE_256-NEXT:    ext z3.b, z3.b, z3.b, #16
; VBITS_GE_256-NEXT:    uunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    uunpklo z1.s, z1.h
; VBITS_GE_256-NEXT:    uunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    uunpklo z3.s, z3.h
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8, x11, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x12, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z3.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z7.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_zext_v64i16i32:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.s, vl64
; VBITS_GE_2048-NEXT:    ld1h { z0.s }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <64 x i16>, <64 x i16>* %ap
  %val = zext <64 x i16> %a to <64 x i32>
  ret <64 x i32> %val
}

define <4 x i32> @load_sext_v4i16i32(<4 x i16>* %ap) #0 {
; CHECK-LABEL: load_sext_v4i16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    sshll v0.4s, v0.4h, #0
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %ap
  %val = sext <4 x i16> %a to <4 x i32>
  ret <4 x i32> %val
}

define <8 x i32> @load_sext_v8i16i32(<8 x i16>* %ap) #0 {
; CHECK-LABEL: load_sext_v8i16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1sh { z0.s }, p0/z, [x0]
; CHECK-NEXT:    st1w { z0.s }, p0, [x8]
; CHECK-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %ap
  %val = sext <8 x i16> %a to <8 x i32>
  ret <8 x i32> %val
}

define <16 x i32> @load_sext_v16i16i32(<16 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_sext_v16i16i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    sunpklo z1.s, z0.h
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    sunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: load_sext_v16i16i32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1sh { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_512-NEXT:    ret

  ; Ensure sensible type legalistaion
  %a = load <16 x i16>, <16 x i16>* %ap
  %val = sext <16 x i16> %a to <16 x i32>
  ret <16 x i32> %val
}

define <32 x i32> @load_sext_v32i16i32(<32 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_sext_v32i16i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x10, #24
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x9, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    sunpklo z2.s, z0.h
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    sunpklo z2.s, z1.h
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    sunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    sunpklo z1.s, z1.h
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_1024-LABEL: load_sext_v32i16i32:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    ptrue p0.s, vl32
; VBITS_GE_1024-NEXT:    ld1sh { z0.s }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_1024-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %ap
  %val = sext <32 x i16> %a to <32 x i32>
  ret <32 x i32> %val
}

define <64 x i32> @load_sext_v64i16i32(<64 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_sext_v64i16i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    mov x10, #32
; VBITS_GE_256-NEXT:    mov x11, #48
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x12, #24
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x9, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0, x10, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z2.h }, p0/z, [x0, x11, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z3.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    sunpklo z4.s, z0.h
; VBITS_GE_256-NEXT:    sunpklo z5.s, z1.h
; VBITS_GE_256-NEXT:    sunpklo z6.s, z2.h
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    st1w { z6.s }, p0, [x8, x11, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z5.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    mov x10, #56
; VBITS_GE_256-NEXT:    mov x11, #40
; VBITS_GE_256-NEXT:    st1w { z4.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    ext z2.b, z2.b, z2.b, #16
; VBITS_GE_256-NEXT:    sunpklo z7.s, z3.h
; VBITS_GE_256-NEXT:    ext z3.b, z3.b, z3.b, #16
; VBITS_GE_256-NEXT:    sunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    sunpklo z1.s, z1.h
; VBITS_GE_256-NEXT:    sunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    sunpklo z3.s, z3.h
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8, x11, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x12, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z3.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z7.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_sext_v64i16i32:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.s, vl64
; VBITS_GE_2048-NEXT:    ld1sh { z0.s }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <64 x i16>, <64 x i16>* %ap
  %val = sext <64 x i16> %a to <64 x i32>
  ret <64 x i32> %val
}

define <32 x i64> @load_zext_v32i8i64(<32 x i8>* %ap) #0 {
; VBITS_GE_256-LABEL: load_zext_v32i8i64:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.b, vl32
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    ld1b { z0.b }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    mov x10, #24
; VBITS_GE_256-NEXT:    ushll2 v2.8h, v0.16b, #0
; VBITS_GE_256-NEXT:    ushll v1.8h, v0.8b, #0
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    ext v3.16b, v2.16b, v2.16b, #8
; VBITS_GE_256-NEXT:    uunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    ushll2 v4.8h, v0.16b, #0
; VBITS_GE_256-NEXT:    uunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #12
; VBITS_GE_256-NEXT:    uunpklo z2.s, z4.h
; VBITS_GE_256-NEXT:    ext v4.16b, v4.16b, v4.16b, #8
; VBITS_GE_256-NEXT:    uunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    uunpklo z3.s, z3.h
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #28
; VBITS_GE_256-NEXT:    uunpklo z2.d, z3.s
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    ext v2.16b, v1.16b, v1.16b, #8
; VBITS_GE_256-NEXT:    uunpklo z3.s, z4.h
; VBITS_GE_256-NEXT:    ushll v0.8h, v0.8b, #0
; VBITS_GE_256-NEXT:    uunpklo z3.d, z3.s
; VBITS_GE_256-NEXT:    st1d { z3.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #4
; VBITS_GE_256-NEXT:    ext v3.16b, v0.16b, v0.16b, #8
; VBITS_GE_256-NEXT:    uunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    uunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    uunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    uunpklo z0.d, z2.s
; VBITS_GE_256-NEXT:    mov x9, #20
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    uunpklo z0.s, z1.h
; VBITS_GE_256-NEXT:    uunpklo z1.s, z3.h
; VBITS_GE_256-NEXT:    uunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    uunpklo z1.d, z1.s
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_zext_v32i8i64:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.d, vl32
; VBITS_GE_2048-NEXT:    ld1b { z0.d }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <32 x i8>, <32 x i8>* %ap
  %val = zext <32 x i8> %a to <32 x i64>
  ret <32 x i64> %val
}

define <32 x i64> @load_sext_v32i8i64(<32 x i8>* %ap) #0 {
; VBITS_GE_256-LABEL: load_sext_v32i8i64:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.b, vl32
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    ld1b { z0.b }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    mov x10, #24
; VBITS_GE_256-NEXT:    sshll2 v2.8h, v0.16b, #0
; VBITS_GE_256-NEXT:    sshll v1.8h, v0.8b, #0
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    ext v3.16b, v2.16b, v2.16b, #8
; VBITS_GE_256-NEXT:    sunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    sshll2 v4.8h, v0.16b, #0
; VBITS_GE_256-NEXT:    sunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #12
; VBITS_GE_256-NEXT:    sunpklo z2.s, z4.h
; VBITS_GE_256-NEXT:    ext v4.16b, v4.16b, v4.16b, #8
; VBITS_GE_256-NEXT:    sunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    sunpklo z3.s, z3.h
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #28
; VBITS_GE_256-NEXT:    sunpklo z2.d, z3.s
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    ext v2.16b, v1.16b, v1.16b, #8
; VBITS_GE_256-NEXT:    sunpklo z3.s, z4.h
; VBITS_GE_256-NEXT:    sshll v0.8h, v0.8b, #0
; VBITS_GE_256-NEXT:    sunpklo z3.d, z3.s
; VBITS_GE_256-NEXT:    st1d { z3.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #4
; VBITS_GE_256-NEXT:    ext v3.16b, v0.16b, v0.16b, #8
; VBITS_GE_256-NEXT:    sunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    sunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    sunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    sunpklo z0.d, z2.s
; VBITS_GE_256-NEXT:    mov x9, #20
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    sunpklo z0.s, z1.h
; VBITS_GE_256-NEXT:    sunpklo z1.s, z3.h
; VBITS_GE_256-NEXT:    sunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    sunpklo z1.d, z1.s
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_sext_v32i8i64:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.d, vl32
; VBITS_GE_2048-NEXT:    ld1sb { z0.d }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <32 x i8>, <32 x i8>* %ap
  %val = sext <32 x i8> %a to <32 x i64>
  ret <32 x i64> %val
}

define <32 x i64> @load_zext_v32i16i64(<32 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_zext_v32i16i64:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x10, #24
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x9, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    ext v2.16b, v0.16b, v0.16b, #8
; VBITS_GE_256-NEXT:    uunpklo z3.s, z0.h
; VBITS_GE_256-NEXT:    uunpklo z3.d, z3.s
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    ext v5.16b, v1.16b, v1.16b, #8
; VBITS_GE_256-NEXT:    st1d { z3.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #20
; VBITS_GE_256-NEXT:    uunpklo z4.s, z1.h
; VBITS_GE_256-NEXT:    ext v3.16b, v0.16b, v0.16b, #8
; VBITS_GE_256-NEXT:    uunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    uunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    uunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    uunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    ext v6.16b, v1.16b, v1.16b, #8
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    mov x10, #4
; VBITS_GE_256-NEXT:    uunpklo z5.s, z5.h
; VBITS_GE_256-NEXT:    uunpklo z1.s, z1.h
; VBITS_GE_256-NEXT:    uunpklo z5.d, z5.s
; VBITS_GE_256-NEXT:    uunpklo z1.d, z1.s
; VBITS_GE_256-NEXT:    uunpklo z0.s, z3.h
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #28
; VBITS_GE_256-NEXT:    st1d { z5.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #12
; VBITS_GE_256-NEXT:    uunpklo z2.s, z6.h
; VBITS_GE_256-NEXT:    uunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    uunpklo z1.d, z4.s
; VBITS_GE_256-NEXT:    uunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_zext_v32i16i64:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.d, vl32
; VBITS_GE_2048-NEXT:    ld1h { z0.d }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %ap
  %val = zext <32 x i16> %a to <32 x i64>
  ret <32 x i64> %val
}

define <32 x i64> @load_sext_v32i16i64(<32 x i16>* %ap) #0 {
; VBITS_GE_256-LABEL: load_sext_v32i16i64:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x10, #24
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x9, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    ext v2.16b, v0.16b, v0.16b, #8
; VBITS_GE_256-NEXT:    sunpklo z3.s, z0.h
; VBITS_GE_256-NEXT:    sunpklo z3.d, z3.s
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    ext v5.16b, v1.16b, v1.16b, #8
; VBITS_GE_256-NEXT:    st1d { z3.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #20
; VBITS_GE_256-NEXT:    sunpklo z4.s, z1.h
; VBITS_GE_256-NEXT:    ext v3.16b, v0.16b, v0.16b, #8
; VBITS_GE_256-NEXT:    sunpklo z2.s, z2.h
; VBITS_GE_256-NEXT:    sunpklo z0.s, z0.h
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    sunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    sunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    ext v6.16b, v1.16b, v1.16b, #8
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    mov x10, #4
; VBITS_GE_256-NEXT:    sunpklo z5.s, z5.h
; VBITS_GE_256-NEXT:    sunpklo z1.s, z1.h
; VBITS_GE_256-NEXT:    sunpklo z5.d, z5.s
; VBITS_GE_256-NEXT:    sunpklo z1.d, z1.s
; VBITS_GE_256-NEXT:    sunpklo z0.s, z3.h
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #28
; VBITS_GE_256-NEXT:    st1d { z5.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #12
; VBITS_GE_256-NEXT:    sunpklo z2.s, z6.h
; VBITS_GE_256-NEXT:    sunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    sunpklo z1.d, z4.s
; VBITS_GE_256-NEXT:    sunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_sext_v32i16i64:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.d, vl32
; VBITS_GE_2048-NEXT:    ld1sh { z0.d }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %ap
  %val = sext <32 x i16> %a to <32 x i64>
  ret <32 x i64> %val
}

define <32 x i64> @load_zext_v32i32i64(<32 x i32>* %ap) #0 {
; VBITS_GE_256-LABEL: load_zext_v32i32i64:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    mov x10, #16
; VBITS_GE_256-NEXT:    mov x11, #24
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    mov x12, #12
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0, x10, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x0, x11, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    uunpklo z4.d, z0.s
; VBITS_GE_256-NEXT:    uunpklo z5.d, z1.s
; VBITS_GE_256-NEXT:    uunpklo z6.d, z2.s
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    st1d { z6.d }, p0, [x8, x11, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z5.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #28
; VBITS_GE_256-NEXT:    mov x11, #20
; VBITS_GE_256-NEXT:    st1d { z4.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #4
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    ext z2.b, z2.b, z2.b, #16
; VBITS_GE_256-NEXT:    uunpklo z7.d, z3.s
; VBITS_GE_256-NEXT:    ext z3.b, z3.b, z3.b, #16
; VBITS_GE_256-NEXT:    uunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    uunpklo z1.d, z1.s
; VBITS_GE_256-NEXT:    uunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    uunpklo z3.d, z3.s
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8, x11, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x12, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z3.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z7.d }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_zext_v32i32i64:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.d, vl32
; VBITS_GE_2048-NEXT:    ld1w { z0.d }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <32 x i32>, <32 x i32>* %ap
  %val = zext <32 x i32> %a to <32 x i64>
  ret <32 x i64> %val
}

define <32 x i64> @load_sext_v32i32i64(<32 x i32>* %ap) #0 {
; VBITS_GE_256-LABEL: load_sext_v32i32i64:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    mov x10, #16
; VBITS_GE_256-NEXT:    mov x11, #24
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    mov x12, #12
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0, x10, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x0, x11, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    sunpklo z4.d, z0.s
; VBITS_GE_256-NEXT:    sunpklo z5.d, z1.s
; VBITS_GE_256-NEXT:    sunpklo z6.d, z2.s
; VBITS_GE_256-NEXT:    ext z0.b, z0.b, z0.b, #16
; VBITS_GE_256-NEXT:    st1d { z6.d }, p0, [x8, x11, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z5.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    mov x10, #28
; VBITS_GE_256-NEXT:    mov x11, #20
; VBITS_GE_256-NEXT:    st1d { z4.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    mov x9, #4
; VBITS_GE_256-NEXT:    ext z1.b, z1.b, z1.b, #16
; VBITS_GE_256-NEXT:    ext z2.b, z2.b, z2.b, #16
; VBITS_GE_256-NEXT:    sunpklo z7.d, z3.s
; VBITS_GE_256-NEXT:    ext z3.b, z3.b, z3.b, #16
; VBITS_GE_256-NEXT:    sunpklo z0.d, z0.s
; VBITS_GE_256-NEXT:    sunpklo z1.d, z1.s
; VBITS_GE_256-NEXT:    sunpklo z2.d, z2.s
; VBITS_GE_256-NEXT:    sunpklo z3.d, z3.s
; VBITS_GE_256-NEXT:    st1d { z2.d }, p0, [x8, x10, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x8, x11, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x8, x12, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z3.d }, p0, [x8, x9, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z7.d }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_sext_v32i32i64:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.d, vl32
; VBITS_GE_2048-NEXT:    ld1sw { z0.d }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1d { z0.d }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %a = load <32 x i32>, <32 x i32>* %ap
  %val = sext <32 x i32> %a to <32 x i64>
  ret <32 x i64> %val
}

attributes #0 = { "target-features"="+sve" }
