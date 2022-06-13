; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -aarch64-sve-vector-bits-min=128  < %s | not grep ptrue
; RUN: llc -aarch64-sve-vector-bits-min=256  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_256
; RUN: llc -aarch64-sve-vector-bits-min=384  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_256
; RUN: llc -aarch64-sve-vector-bits-min=512  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=640  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=768  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=896  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=1024 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1152 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1280 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1408 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1536 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1664 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1792 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1920 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=2048 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_2048

target triple = "aarch64-unknown-linux-gnu"

; Don't use SVE for 64-bit vectors.
define <2 x float> @load_v2f32(<2 x float>* %a) #0 {
; CHECK-LABEL: load_v2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ret
  %load = load <2 x float>, <2 x float>* %a
  ret <2 x float> %load
}

; Don't use SVE for 128-bit vectors.
define <4 x float> @load_v4f32(<4 x float>* %a) #0 {
; CHECK-LABEL: load_v4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ret
  %load = load <4 x float>, <4 x float>* %a
  ret <4 x float> %load
}

define <8 x float> @load_v8f32(<8 x float>* %a) #0 {
; CHECK-LABEL: load_v8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    st1w { z0.s }, p0, [x8]
; CHECK-NEXT:    ret
  %load = load <8 x float>, <8 x float>* %a
  ret <8 x float> %load
}

define <16 x float> @load_v16f32(<16 x float>* %a) #0 {
; VBITS_GE_256-LABEL: load_v16f32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: load_v16f32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_512-NEXT:    ret
;
; VBITS_GE_1024-LABEL: load_v16f32:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    ptrue p0.s, vl16
; VBITS_GE_1024-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_1024-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_v16f32:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.s, vl16
; VBITS_GE_2048-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %load = load <16 x float>, <16 x float>* %a
  ret <16 x float> %load
}

define <32 x float> @load_v32f32(<32 x float>* %a) #0 {
; VBITS_GE_256-LABEL: load_v32f32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #16
; VBITS_GE_256-NEXT:    mov x10, #24
; VBITS_GE_256-NEXT:    mov x11, #8
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0, x10, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x0, x11, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8, x11, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z3.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: load_v32f32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    mov x9, #16
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_512-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_512-NEXT:    st1w { z1.s }, p0, [x8]
; VBITS_GE_512-NEXT:    ret
;
; VBITS_GE_1024-LABEL: load_v32f32:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    ptrue p0.s, vl32
; VBITS_GE_1024-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_1024-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_v32f32:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.s, vl32
; VBITS_GE_2048-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %load = load <32 x float>, <32 x float>* %a
  ret <32 x float> %load
}

define <64 x float> @load_v64f32(<64 x float>* %a) #0 {
; VBITS_GE_256-LABEL: load_v64f32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    mov x9, #8
; VBITS_GE_256-NEXT:    mov x10, #48
; VBITS_GE_256-NEXT:    mov x11, #56
; VBITS_GE_256-NEXT:    mov x12, #32
; VBITS_GE_256-NEXT:    mov x13, #40
; VBITS_GE_256-NEXT:    mov x14, #16
; VBITS_GE_256-NEXT:    mov x15, #24
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x10, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0, x11, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x0, x12, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x0, x13, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z4.s }, p0/z, [x0, x14, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z5.s }, p0/z, [x0, x15, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z6.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z7.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x8, x11, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z3.s }, p0, [x8, x13, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x8, x12, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z5.s }, p0, [x8, x15, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z4.s }, p0, [x8, x14, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z6.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z7.s }, p0, [x8]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: load_v64f32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    mov x9, #32
; VBITS_GE_512-NEXT:    mov x10, #48
; VBITS_GE_512-NEXT:    mov x11, #16
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_512-NEXT:    ld1w { z1.s }, p0/z, [x0, x10, lsl #2]
; VBITS_GE_512-NEXT:    ld1w { z2.s }, p0/z, [x0, x11, lsl #2]
; VBITS_GE_512-NEXT:    ld1w { z3.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    st1w { z1.s }, p0, [x8, x10, lsl #2]
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_512-NEXT:    st1w { z2.s }, p0, [x8, x11, lsl #2]
; VBITS_GE_512-NEXT:    st1w { z3.s }, p0, [x8]
; VBITS_GE_512-NEXT:    ret
;
; VBITS_GE_1024-LABEL: load_v64f32:
; VBITS_GE_1024:       // %bb.0:
; VBITS_GE_1024-NEXT:    mov x9, #32
; VBITS_GE_1024-NEXT:    ptrue p0.s, vl32
; VBITS_GE_1024-NEXT:    ld1w { z0.s }, p0/z, [x0, x9, lsl #2]
; VBITS_GE_1024-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_1024-NEXT:    st1w { z0.s }, p0, [x8, x9, lsl #2]
; VBITS_GE_1024-NEXT:    st1w { z1.s }, p0, [x8]
; VBITS_GE_1024-NEXT:    ret
;
; VBITS_GE_2048-LABEL: load_v64f32:
; VBITS_GE_2048:       // %bb.0:
; VBITS_GE_2048-NEXT:    ptrue p0.s, vl64
; VBITS_GE_2048-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_2048-NEXT:    st1w { z0.s }, p0, [x8]
; VBITS_GE_2048-NEXT:    ret
  %load = load <64 x float>, <64 x float>* %a
  ret <64 x float> %load
}

attributes #0 = { "target-features"="+sve" }
