; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -aarch64-sve-vector-bits-min=256 -aarch64-sve-vector-bits-max=256 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_EQ_256
; RUN: llc -aarch64-sve-vector-bits-min=512 -aarch64-sve-vector-bits-max=512 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_EQ_512

target triple = "aarch64-unknown-linux-gnu"

define void @zip1_v32i8(<32 x i8>* %a, <32 x i8>* %b) #0 {
; VBITS_EQ_256-LABEL: zip1_v32i8:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.b
; VBITS_EQ_256-NEXT:    ld1b { z0.b }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1b { z1.b }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    zip1 z0.b, z0.b, z1.b
; VBITS_EQ_256-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: zip1_v32i8:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.b, vl32
; VBITS_EQ_512-NEXT:    ld1b { z0.b }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1b { z1.b }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    zip1 z0.b, z0.b, z1.b
; VBITS_EQ_512-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load volatile <32 x i8>, <32 x i8>* %a
  %tmp2 = load volatile <32 x i8>, <32 x i8>* %b
  %tmp3 = shufflevector <32 x i8> %tmp1, <32 x i8> %tmp2, <32 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47>
  store volatile <32 x i8> %tmp3, <32 x i8>* %a
  ret void
}

define void @zip_v32i16(<32 x i16>* %a, <32 x i16>* %b) #0 {
; VBITS_EQ_256-LABEL: zip_v32i16:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    mov x8, #16
; VBITS_EQ_256-NEXT:    ptrue p0.h
; VBITS_EQ_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x8, lsl #1]
; VBITS_EQ_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1h { z2.h }, p0/z, [x1, x8, lsl #1]
; VBITS_EQ_256-NEXT:    ld1h { z3.h }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    zip2 z4.h, z1.h, z3.h
; VBITS_EQ_256-NEXT:    zip1 z1.h, z1.h, z3.h
; VBITS_EQ_256-NEXT:    zip2 z3.h, z0.h, z2.h
; VBITS_EQ_256-NEXT:    zip1 z0.h, z0.h, z2.h
; VBITS_EQ_256-NEXT:    add z0.h, z1.h, z0.h
; VBITS_EQ_256-NEXT:    add z1.h, z4.h, z3.h
; VBITS_EQ_256-NEXT:    st1h { z1.h }, p0, [x0, x8, lsl #1]
; VBITS_EQ_256-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: zip_v32i16:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.h
; VBITS_EQ_512-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    zip1 z2.h, z0.h, z1.h
; VBITS_EQ_512-NEXT:    zip2 z0.h, z0.h, z1.h
; VBITS_EQ_512-NEXT:    add z0.h, z2.h, z0.h
; VBITS_EQ_512-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <32 x i16>, <32 x i16>* %a
  %tmp2 = load <32 x i16>, <32 x i16>* %b
  %tmp3 = shufflevector <32 x i16> %tmp1, <32 x i16> %tmp2, <32 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47>
  %tmp4 = shufflevector <32 x i16> %tmp1, <32 x i16> %tmp2, <32 x i32> <i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>
  %tmp5 = add <32 x i16> %tmp3, %tmp4
  store <32 x i16> %tmp5, <32 x i16>* %a
  ret void
}

define void @zip1_v16i16(<16 x i16>* %a, <16 x i16>* %b) #0 {
; VBITS_EQ_256-LABEL: zip1_v16i16:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.h
; VBITS_EQ_256-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    zip1 z0.h, z0.h, z1.h
; VBITS_EQ_256-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: zip1_v16i16:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.h, vl16
; VBITS_EQ_512-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    zip1 z0.h, z0.h, z1.h
; VBITS_EQ_512-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load volatile <16 x i16>, <16 x i16>* %a
  %tmp2 = load volatile <16 x i16>, <16 x i16>* %b
  %tmp3 = shufflevector <16 x i16> %tmp1, <16 x i16> %tmp2, <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
  store volatile <16 x i16> %tmp3, <16 x i16>* %a
  ret void
}

define void @zip1_v8i32(<8 x i32>* %a, <8 x i32>* %b) #0 {
; VBITS_EQ_256-LABEL: zip1_v8i32:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.s
; VBITS_EQ_256-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    zip1 z0.s, z0.s, z1.s
; VBITS_EQ_256-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: zip1_v8i32:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.s, vl8
; VBITS_EQ_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    zip1 z0.s, z0.s, z1.s
; VBITS_EQ_512-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load volatile <8 x i32>, <8 x i32>* %a
  %tmp2 = load volatile <8 x i32>, <8 x i32>* %b
  %tmp3 = shufflevector <8 x i32> %tmp1, <8 x i32> %tmp2, <8 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11>
  store volatile <8 x i32> %tmp3, <8 x i32>* %a
  ret void
}

define void @zip_v4f64(<4 x double>* %a, <4 x double>* %b) #0 {
; VBITS_EQ_256-LABEL: zip_v4f64:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.d
; VBITS_EQ_256-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    zip1 z2.d, z0.d, z1.d
; VBITS_EQ_256-NEXT:    zip2 z0.d, z0.d, z1.d
; VBITS_EQ_256-NEXT:    fadd z0.d, z2.d, z0.d
; VBITS_EQ_256-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: zip_v4f64:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; VBITS_EQ_512-NEXT:    .cfi_def_cfa_offset 16
; VBITS_EQ_512-NEXT:    mov x29, sp
; VBITS_EQ_512-NEXT:    .cfi_def_cfa w29, 16
; VBITS_EQ_512-NEXT:    .cfi_offset w30, -8
; VBITS_EQ_512-NEXT:    .cfi_offset w29, -16
; VBITS_EQ_512-NEXT:    sub x9, sp, #48
; VBITS_EQ_512-NEXT:    and sp, x9, #0xffffffffffffffe0
; VBITS_EQ_512-NEXT:    ptrue p0.d, vl4
; VBITS_EQ_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    mov z2.d, z1.d[3]
; VBITS_EQ_512-NEXT:    mov z3.d, z0.d[3]
; VBITS_EQ_512-NEXT:    stp d3, d2, [sp, #16]
; VBITS_EQ_512-NEXT:    mov z2.d, z1.d[2]
; VBITS_EQ_512-NEXT:    mov z3.d, z0.d[2]
; VBITS_EQ_512-NEXT:    zip1 z0.d, z0.d, z1.d
; VBITS_EQ_512-NEXT:    stp d3, d2, [sp]
; VBITS_EQ_512-NEXT:    ld1d { z2.d }, p0/z, [sp]
; VBITS_EQ_512-NEXT:    fadd z0.d, p0/m, z0.d, z2.d
; VBITS_EQ_512-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_EQ_512-NEXT:    mov sp, x29
; VBITS_EQ_512-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <4 x double>, <4 x double>* %a
  %tmp2 = load <4 x double>, <4 x double>* %b
  %tmp3 = shufflevector <4 x double> %tmp1, <4 x double> %tmp2, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %tmp4 = shufflevector <4 x double> %tmp1, <4 x double> %tmp2, <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  %tmp5 = fadd <4 x double> %tmp3, %tmp4
  store <4 x double> %tmp5, <4 x double>* %a
  ret void
}

; Don't use SVE for 128-bit vectors
define void @zip_v4i32(<4 x i32>* %a, <4 x i32>* %b) #0 {
; CHECK-LABEL: zip_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    zip1 v2.4s, v0.4s, v1.4s
; CHECK-NEXT:    zip2 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <4 x i32>, <4 x i32>* %a
  %tmp2 = load <4 x i32>, <4 x i32>* %b
  %tmp3 = shufflevector <4 x i32> %tmp1, <4 x i32> %tmp2, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %tmp4 = shufflevector <4 x i32> %tmp1, <4 x i32> %tmp2, <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  %tmp5 = add <4 x i32> %tmp3, %tmp4
  store <4 x i32> %tmp5, <4 x i32>* %a
  ret void
}

define void @zip1_v8i32_undef(<8 x i32>* %a) #0 {
; VBITS_EQ_256-LABEL: zip1_v8i32_undef:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.s
; VBITS_EQ_256-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    zip1 z0.s, z0.s, z0.s
; VBITS_EQ_256-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: zip1_v8i32_undef:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.s, vl8
; VBITS_EQ_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    zip1 z0.s, z0.s, z0.s
; VBITS_EQ_512-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load  volatile <8 x i32>, <8 x i32>* %a
  %tmp2 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 0, i32 0, i32 1, i32 1, i32 2, i32 2, i32 3, i32 3>
  store volatile <8 x i32> %tmp2, <8 x i32>* %a
  ret void
}

define void @trn_v32i8(<32 x i8>* %a, <32 x i8>* %b) #0 {
; VBITS_EQ_256-LABEL: trn_v32i8:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.b
; VBITS_EQ_256-NEXT:    ld1b { z0.b }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1b { z1.b }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    trn1 z2.b, z0.b, z1.b
; VBITS_EQ_256-NEXT:    trn2 z0.b, z0.b, z1.b
; VBITS_EQ_256-NEXT:    add z0.b, z2.b, z0.b
; VBITS_EQ_256-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: trn_v32i8:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.b, vl32
; VBITS_EQ_512-NEXT:    ld1b { z0.b }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1b { z1.b }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    trn1 z2.b, z0.b, z1.b
; VBITS_EQ_512-NEXT:    trn2 z0.b, z0.b, z1.b
; VBITS_EQ_512-NEXT:    add z0.b, z2.b, z0.b
; VBITS_EQ_512-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <32 x i8>, <32 x i8>* %a
  %tmp2 = load <32 x i8>, <32 x i8>* %b
  %tmp3 = shufflevector <32 x i8> %tmp1, <32 x i8> %tmp2, <32 x i32> <i32 0, i32 32, i32 2, i32 34, i32 4, i32 36, i32 6, i32 38, i32 8, i32 40, i32 10, i32 42, i32 12, i32 44, i32 14, i32 46, i32 16, i32 48, i32 18, i32 50, i32 20, i32 52, i32 22, i32 54, i32 24, i32 56, i32 26, i32 58, i32 28, i32 60, i32 30, i32 62>
  %tmp4 = shufflevector <32 x i8> %tmp1, <32 x i8> %tmp2, <32 x i32> <i32 1, i32 33, i32 3, i32 35, i32 undef, i32 37, i32 7, i32 undef, i32 undef, i32 41, i32 11, i32 43, i32 13, i32 45, i32 15, i32 47, i32 17, i32 49, i32 19, i32 51, i32 21, i32 53, i32 23, i32 55, i32 25, i32 57, i32 27, i32 59, i32 29, i32 61, i32 31, i32 63>
  %tmp5 = add <32 x i8> %tmp3, %tmp4
  store <32 x i8> %tmp5, <32 x i8>* %a
  ret void
}

define void @trn_v32i16(<32 x i16>* %a, <32 x i16>* %b) #0 {
; VBITS_EQ_256-LABEL: trn_v32i16:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    mov x8, #16
; VBITS_EQ_256-NEXT:    ptrue p0.h
; VBITS_EQ_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x8, lsl #1]
; VBITS_EQ_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1h { z2.h }, p0/z, [x1, x8, lsl #1]
; VBITS_EQ_256-NEXT:    ld1h { z3.h }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    trn1 z4.h, z0.h, z2.h
; VBITS_EQ_256-NEXT:    trn1 z5.h, z1.h, z3.h
; VBITS_EQ_256-NEXT:    trn2 z0.h, z0.h, z2.h
; VBITS_EQ_256-NEXT:    trn2 z1.h, z1.h, z3.h
; VBITS_EQ_256-NEXT:    add z0.h, z4.h, z0.h
; VBITS_EQ_256-NEXT:    add z1.h, z5.h, z1.h
; VBITS_EQ_256-NEXT:    st1h { z0.h }, p0, [x0, x8, lsl #1]
; VBITS_EQ_256-NEXT:    st1h { z1.h }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: trn_v32i16:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.h
; VBITS_EQ_512-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    trn1 z2.h, z0.h, z1.h
; VBITS_EQ_512-NEXT:    trn2 z0.h, z0.h, z1.h
; VBITS_EQ_512-NEXT:    add z0.h, z2.h, z0.h
; VBITS_EQ_512-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <32 x i16>, <32 x i16>* %a
  %tmp2 = load <32 x i16>, <32 x i16>* %b
  %tmp3 = shufflevector <32 x i16> %tmp1, <32 x i16> %tmp2, <32 x i32> <i32 0, i32 32, i32 2, i32 34, i32 4, i32 36, i32 6, i32 38, i32 8, i32 40, i32 10, i32 42, i32 12, i32 44, i32 14, i32 46, i32 16, i32 48, i32 18, i32 50, i32 20, i32 52, i32 22, i32 54, i32 24, i32 56, i32 26, i32 58, i32 28, i32 60, i32 30, i32 62>
  %tmp4 = shufflevector <32 x i16> %tmp1, <32 x i16> %tmp2, <32 x i32> <i32 1, i32 33, i32 3, i32 35, i32 undef, i32 37, i32 7, i32 undef, i32 undef, i32 41, i32 11, i32 43, i32 13, i32 45, i32 15, i32 47, i32 17, i32 49, i32 19, i32 51, i32 21, i32 53, i32 23, i32 55, i32 25, i32 57, i32 27, i32 59, i32 29, i32 61, i32 31, i32 63>
  %tmp5 = add <32 x i16> %tmp3, %tmp4
  store <32 x i16> %tmp5, <32 x i16>* %a
  ret void
}

define void @trn_v16i16(<16 x i16>* %a, <16 x i16>* %b) #0 {
; VBITS_EQ_256-LABEL: trn_v16i16:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.h
; VBITS_EQ_256-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    trn1 z2.h, z0.h, z1.h
; VBITS_EQ_256-NEXT:    trn2 z0.h, z0.h, z1.h
; VBITS_EQ_256-NEXT:    add z0.h, z2.h, z0.h
; VBITS_EQ_256-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: trn_v16i16:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.h, vl16
; VBITS_EQ_512-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    trn1 z2.h, z0.h, z1.h
; VBITS_EQ_512-NEXT:    trn2 z0.h, z0.h, z1.h
; VBITS_EQ_512-NEXT:    add z0.h, z2.h, z0.h
; VBITS_EQ_512-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <16 x i16>, <16 x i16>* %a
  %tmp2 = load <16 x i16>, <16 x i16>* %b
  %tmp3 = shufflevector <16 x i16> %tmp1, <16 x i16> %tmp2, <16 x i32> <i32 0, i32 16, i32 2, i32 18, i32 4, i32 20, i32 6, i32 22, i32 8, i32 24, i32 10, i32 26, i32 12, i32 28, i32 14, i32 30>
  %tmp4 = shufflevector <16 x i16> %tmp1, <16 x i16> %tmp2, <16 x i32> <i32 1, i32 17, i32 3, i32 19, i32 5, i32 21, i32 7, i32 23, i32 9, i32 25, i32 11, i32 27, i32 13, i32 29, i32 15, i32 31>
  %tmp5 = add <16 x i16> %tmp3, %tmp4
  store <16 x i16> %tmp5, <16 x i16>* %a
  ret void
}

define void @trn_v8i32(<8 x i32>* %a, <8 x i32>* %b) #0 {
; VBITS_EQ_256-LABEL: trn_v8i32:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.s
; VBITS_EQ_256-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    trn1 z2.s, z0.s, z1.s
; VBITS_EQ_256-NEXT:    trn2 z0.s, z0.s, z1.s
; VBITS_EQ_256-NEXT:    add z0.s, z2.s, z0.s
; VBITS_EQ_256-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: trn_v8i32:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.s, vl8
; VBITS_EQ_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    trn1 z2.s, z0.s, z1.s
; VBITS_EQ_512-NEXT:    trn2 z0.s, z0.s, z1.s
; VBITS_EQ_512-NEXT:    add z0.s, z2.s, z0.s
; VBITS_EQ_512-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <8 x i32>, <8 x i32>* %a
  %tmp2 = load <8 x i32>, <8 x i32>* %b
  %tmp3 = shufflevector <8 x i32> %tmp1, <8 x i32> %tmp2, <8 x i32> <i32 0, i32 8, i32 undef, i32 undef, i32 4, i32 12, i32 6, i32 14>
  %tmp4 = shufflevector <8 x i32> %tmp1, <8 x i32> %tmp2, <8 x i32> <i32 1, i32 undef, i32 3, i32 11, i32 5, i32 13, i32 undef, i32 undef>
  %tmp5 = add <8 x i32> %tmp3, %tmp4
  store <8 x i32> %tmp5, <8 x i32>* %a
  ret void
}

define void @trn_v4f64(<4 x double>* %a, <4 x double>* %b) #0 {
; VBITS_EQ_256-LABEL: trn_v4f64:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.d
; VBITS_EQ_256-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_EQ_256-NEXT:    trn1 z2.d, z0.d, z1.d
; VBITS_EQ_256-NEXT:    trn2 z0.d, z0.d, z1.d
; VBITS_EQ_256-NEXT:    fadd z0.d, z2.d, z0.d
; VBITS_EQ_256-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: trn_v4f64:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.d, vl4
; VBITS_EQ_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_EQ_512-NEXT:    trn1 z2.d, z0.d, z1.d
; VBITS_EQ_512-NEXT:    trn2 z0.d, z0.d, z1.d
; VBITS_EQ_512-NEXT:    fadd z0.d, p0/m, z0.d, z2.d
; VBITS_EQ_512-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <4 x double>, <4 x double>* %a
  %tmp2 = load <4 x double>, <4 x double>* %b
  %tmp3 = shufflevector <4 x double> %tmp1, <4 x double> %tmp2, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  %tmp4 = shufflevector <4 x double> %tmp1, <4 x double> %tmp2, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  %tmp5 = fadd <4 x double> %tmp3, %tmp4
  store <4 x double> %tmp5, <4 x double>* %a
  ret void
}

; Don't use SVE for 128-bit vectors
define void @trn_v4f32(<4 x float>* %a, <4 x float>* %b) #0 {
; CHECK-LABEL: trn_v4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    trn1 v2.4s, v0.4s, v1.4s
; CHECK-NEXT:    trn2 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    fadd v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <4 x float>, <4 x float>* %a
  %tmp2 = load <4 x float>, <4 x float>* %b
  %tmp3 = shufflevector <4 x float> %tmp1, <4 x float> %tmp2, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  %tmp4 = shufflevector <4 x float> %tmp1, <4 x float> %tmp2, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  %tmp5 = fadd <4 x float> %tmp3, %tmp4
  store <4 x float> %tmp5, <4 x float>* %a
  ret void
}

define void @trn_v8i32_undef(<8 x i32>* %a) #0 {
; VBITS_EQ_256-LABEL: trn_v8i32_undef:
; VBITS_EQ_256:       // %bb.0:
; VBITS_EQ_256-NEXT:    ptrue p0.s
; VBITS_EQ_256-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_256-NEXT:    trn1 z1.s, z0.s, z0.s
; VBITS_EQ_256-NEXT:    trn2 z0.s, z0.s, z0.s
; VBITS_EQ_256-NEXT:    add z0.s, z1.s, z0.s
; VBITS_EQ_256-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_256-NEXT:    ret
;
; VBITS_EQ_512-LABEL: trn_v8i32_undef:
; VBITS_EQ_512:       // %bb.0:
; VBITS_EQ_512-NEXT:    ptrue p0.s, vl8
; VBITS_EQ_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_EQ_512-NEXT:    trn1 z1.s, z0.s, z0.s
; VBITS_EQ_512-NEXT:    trn2 z0.s, z0.s, z0.s
; VBITS_EQ_512-NEXT:    add z0.s, z1.s, z0.s
; VBITS_EQ_512-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_EQ_512-NEXT:    ret
  %tmp1 = load <8 x i32>, <8 x i32>* %a
  %tmp3 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>
  %tmp4 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7>
  %tmp5 = add <8 x i32> %tmp3, %tmp4
  store <8 x i32> %tmp5, <8 x i32>* %a
  ret void
}

; Emit zip2 instruction for v32i8 shuffle with vscale_range(2,2),
; since the size of v32i8 is the same as the runtime vector length.
define void @zip2_v32i8(<32 x i8>* %a, <32 x i8>* %b) #1 {
; CHECK-LABEL: zip2_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    ld1b { z1.b }, p0/z, [x1]
; CHECK-NEXT:    zip2 z0.b, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load volatile <32 x i8>, <32 x i8>* %a
  %tmp2 = load volatile <32 x i8>, <32 x i8>* %b
  %tmp3 = shufflevector <32 x i8> %tmp1, <32 x i8> %tmp2, <32 x i32> <i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>
  store volatile <32 x i8> %tmp3, <32 x i8>* %a
  ret void
}

; Emit zip2 instruction for v16i16 shuffle with vscale_range(2,2),
; since the size of v16i16 is the same as the runtime vector length.
define void @zip2_v16i16(<16 x i16>* %a, <16 x i16>* %b) #1 {
; CHECK-LABEL: zip2_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x1]
; CHECK-NEXT:    zip2 z0.h, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load volatile <16 x i16>, <16 x i16>* %a
  %tmp2 = load volatile <16 x i16>, <16 x i16>* %b
  %tmp3 = shufflevector <16 x i16> %tmp1, <16 x i16> %tmp2, <16 x i32> <i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
  store volatile <16 x i16> %tmp3, <16 x i16>* %a
  ret void
}

; Emit zip2 instruction for v8i32 shuffle with vscale_range(2,2),
; since the size of v8i32 is the same as the runtime vector length.
define void @zip2_v8i32(<8 x i32>* %a, <8 x i32>* %b) #1 {
; CHECK-LABEL: zip2_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    zip2 z0.s, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load volatile <8 x i32>, <8 x i32>* %a
  %tmp2 = load volatile <8 x i32>, <8 x i32>* %b
  %tmp3 = shufflevector <8 x i32> %tmp1, <8 x i32> %tmp2, <8 x i32> <i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  store volatile <8 x i32> %tmp3, <8 x i32>* %a
  ret void
}

; Emit zip2 instruction for v8i32 and undef shuffle with vscale_range(2,2)
define void @zip2_v8i32_undef(<8 x i32>* %a) #1 {
; CHECK-LABEL: zip2_v8i32_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    zip2 z0.s, z0.s, z0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load volatile <8 x i32>, <8 x i32>* %a
  %tmp2 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 4, i32 4, i32 5, i32 5, i32 6, i32 6, i32 7, i32 7>
  store volatile <8 x i32> %tmp2, <8 x i32>* %a
  ret void
}

; Emit uzp1/2 instruction for v32i8 shuffle with vscale_range(2,2),
; since the size of v32i8 is the same as the runtime vector length.
define void @uzp_v32i8(<32 x i8>* %a, <32 x i8>* %b) #1 {
; CHECK-LABEL: uzp_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    ld1b { z1.b }, p0/z, [x1]
; CHECK-NEXT:    uzp1 z2.b, z0.b, z1.b
; CHECK-NEXT:    uzp2 z0.b, z0.b, z1.b
; CHECK-NEXT:    add z0.b, z2.b, z0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <32 x i8>, <32 x i8>* %a
  %tmp2 = load <32 x i8>, <32 x i8>* %b
  %tmp3 = shufflevector <32 x i8> %tmp1, <32 x i8> %tmp2, <32 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30, i32 32, i32 34, i32 36, i32 38, i32 40, i32 42, i32 44, i32 46, i32 48, i32 50, i32 52, i32 54, i32 56, i32 58, i32 60, i32 62>
  %tmp4 = shufflevector <32 x i8> %tmp1, <32 x i8> %tmp2, <32 x i32> <i32 1, i32 3, i32 5, i32 undef, i32 9, i32 11, i32 13, i32 undef, i32 undef, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31, i32 33, i32 35, i32 37, i32 39, i32 41, i32 43, i32 45, i32 47, i32 49, i32 51, i32 53, i32 55, i32 57, i32 59, i32 61, i32 63>
  %tmp5 = add <32 x i8> %tmp3, %tmp4
  store <32 x i8> %tmp5, <32 x i8>* %a
  ret void
}

; Emit uzp1/2 instruction for v32i16 shuffle with vscale_range(2,2),
; v32i16 will be expanded into two v16i16, and the size of v16i16 is
; the same as the runtime vector length.
define void @uzp_v32i16(<32 x i16>* %a, <32 x i16>* %b) #1 {
; CHECK-LABEL: uzp_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #16
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0, x8, lsl #1]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z2.h }, p0/z, [x1, x8, lsl #1]
; CHECK-NEXT:    ld1h { z3.h }, p0/z, [x1]
; CHECK-NEXT:    uzp1 z5.h, z1.h, z0.h
; CHECK-NEXT:    uzp2 z0.h, z1.h, z0.h
; CHECK-NEXT:    uzp1 z4.h, z3.h, z2.h
; CHECK-NEXT:    uzp2 z2.h, z3.h, z2.h
; CHECK-NEXT:    add z0.h, z5.h, z0.h
; CHECK-NEXT:    add z1.h, z4.h, z2.h
; CHECK-NEXT:    st1h { z1.h }, p0, [x0, x8, lsl #1]
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <32 x i16>, <32 x i16>* %a
  %tmp2 = load <32 x i16>, <32 x i16>* %b
  %tmp3 = shufflevector <32 x i16> %tmp1, <32 x i16> %tmp2, <32 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30, i32 32, i32 34, i32 36, i32 38, i32 40, i32 42, i32 44, i32 46, i32 48, i32 50, i32 52, i32 54, i32 56, i32 58, i32 60, i32 62>
  %tmp4 = shufflevector <32 x i16> %tmp1, <32 x i16> %tmp2, <32 x i32> <i32 1, i32 3, i32 5, i32 undef, i32 9, i32 11, i32 13, i32 undef, i32 undef, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31, i32 33, i32 35, i32 37, i32 39, i32 41, i32 43, i32 45, i32 47, i32 49, i32 51, i32 53, i32 55, i32 57, i32 59, i32 61, i32 63>
  %tmp5 = add <32 x i16> %tmp3, %tmp4
  store <32 x i16> %tmp5, <32 x i16>* %a
  ret void
}

; Emit uzp1/2 instruction for v16i16 shuffle with vscale_range(2,2),
; since the size of v16i16 is the same as the runtime vector length.
define void @uzp_v16i16(<16 x i16>* %a, <16 x i16>* %b) #1 {
; CHECK-LABEL: uzp_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x1]
; CHECK-NEXT:    uzp1 z2.h, z0.h, z1.h
; CHECK-NEXT:    uzp2 z0.h, z0.h, z1.h
; CHECK-NEXT:    add z0.h, z2.h, z0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <16 x i16>, <16 x i16>* %a
  %tmp2 = load <16 x i16>, <16 x i16>* %b
  %tmp3 = shufflevector <16 x i16> %tmp1, <16 x i16> %tmp2, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %tmp4 = shufflevector <16 x i16> %tmp1, <16 x i16> %tmp2, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  %tmp5 = add <16 x i16> %tmp3, %tmp4
  store <16 x i16> %tmp5, <16 x i16>* %a
  ret void
}

; Emit uzp1/2 instruction for v8f32 shuffle with vscale_range(2,2),
; since the size of v8f32 is the same as the runtime vector length.
define void @uzp_v8f32(<8 x float>* %a, <8 x float>* %b) #1 {
; CHECK-LABEL: uzp_v8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    uzp1 z2.s, z0.s, z1.s
; CHECK-NEXT:    uzp2 z0.s, z0.s, z1.s
; CHECK-NEXT:    fadd z0.s, z2.s, z0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <8 x float>, <8 x float>* %a
  %tmp2 = load <8 x float>, <8 x float>* %b
  %tmp3 = shufflevector <8 x float> %tmp1, <8 x float> %tmp2, <8 x i32> <i32 0, i32 undef, i32 4, i32 6, i32 undef, i32 10, i32 12, i32 14>
  %tmp4 = shufflevector <8 x float> %tmp1, <8 x float> %tmp2, <8 x i32> <i32 1, i32 undef, i32 5, i32 7, i32 9, i32 11, i32 undef, i32 undef>
  %tmp5 = fadd <8 x float> %tmp3, %tmp4
  store <8 x float> %tmp5, <8 x float>* %a
  ret void
}

; Emit uzp1/2 instruction for v4i64 shuffle with vscale_range(2,2),
; since the size of v4i64 is the same as the runtime vector length.
define void @uzp_v4i64(<4 x i64>* %a, <4 x i64>* %b) #1 {
; CHECK-LABEL: uzp_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x1]
; CHECK-NEXT:    uzp1 z2.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z0.d, z0.d, z1.d
; CHECK-NEXT:    add z0.d, z2.d, z0.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <4 x i64>, <4 x i64>* %a
  %tmp2 = load <4 x i64>, <4 x i64>* %b
  %tmp3 = shufflevector <4 x i64> %tmp1, <4 x i64> %tmp2, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp4 = shufflevector <4 x i64> %tmp1, <4 x i64> %tmp2, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %tmp5 = add <4 x i64> %tmp3, %tmp4
  store <4 x i64> %tmp5, <4 x i64>* %a
  ret void
}

; Don't use SVE for 128-bit vectors
define void @uzp_v8i16(<8 x i16>* %a, <8 x i16>* %b) #1 {
; CHECK-LABEL: uzp_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    uzp1 v2.8h, v0.8h, v1.8h
; CHECK-NEXT:    uzp2 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    add v0.8h, v2.8h, v0.8h
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <8 x i16>, <8 x i16>* %a
  %tmp2 = load <8 x i16>, <8 x i16>* %b
  %tmp3 = shufflevector <8 x i16> %tmp1, <8 x i16> %tmp2, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %tmp4 = shufflevector <8 x i16> %tmp1, <8 x i16> %tmp2, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %tmp5 = add <8 x i16> %tmp3, %tmp4
  store <8 x i16> %tmp5, <8 x i16>* %a
  ret void
}

; Emit uzp1/2 instruction for v8i32 and undef shuffle with vscale_range(2,2)
define void @uzp_v8i32_undef(<8 x i32>* %a) #1 {
; CHECK-LABEL: uzp_v8i32_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    uzp1 z1.s, z0.s, z0.s
; CHECK-NEXT:    uzp2 z0.s, z0.s, z0.s
; CHECK-NEXT:    add z0.s, z1.s, z0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <8 x i32>, <8 x i32>* %a
  %tmp3 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 0, i32 2, i32 4, i32 6>
  %tmp4 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 1, i32 3, i32 5, i32 7>
  %tmp5 = add <8 x i32> %tmp3, %tmp4
  store <8 x i32> %tmp5, <8 x i32>* %a
  ret void
}

; Only zip1 can be emitted safely with vscale_range(2,4).
; vscale_range(2,4) means different min/max vector sizes, zip2 relies on
; knowing which indices represent the high half of sve vector register.
define void @zip_vscale2_4(<4 x double>* %a, <4 x double>* %b) #2 {
; CHECK-LABEL: zip_vscale2_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    sub x9, sp, #48
; CHECK-NEXT:    and sp, x9, #0xffffffffffffffe0
; CHECK-NEXT:    ptrue p0.d, vl4
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x1]
; CHECK-NEXT:    mov z2.d, z1.d[3]
; CHECK-NEXT:    mov z3.d, z0.d[3]
; CHECK-NEXT:    stp d3, d2, [sp, #16]
; CHECK-NEXT:    mov z2.d, z1.d[2]
; CHECK-NEXT:    mov z3.d, z0.d[2]
; CHECK-NEXT:    zip1 z0.d, z0.d, z1.d
; CHECK-NEXT:    stp d3, d2, [sp]
; CHECK-NEXT:    ld1d { z2.d }, p0/z, [sp]
; CHECK-NEXT:    fadd z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %tmp1 = load <4 x double>, <4 x double>* %a
  %tmp2 = load <4 x double>, <4 x double>* %b
  %tmp3 = shufflevector <4 x double> %tmp1, <4 x double> %tmp2, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %tmp4 = shufflevector <4 x double> %tmp1, <4 x double> %tmp2, <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  %tmp5 = fadd <4 x double> %tmp3, %tmp4
  store <4 x double> %tmp5, <4 x double>* %a
  ret void
}

attributes #0 = { "target-features"="+sve" }
attributes #1 = { "target-features"="+sve" vscale_range(2,2) }
attributes #2 = { "target-features"="+sve" vscale_range(2,4) }
