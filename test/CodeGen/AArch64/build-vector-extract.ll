; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

define <2 x i64> @extract0_i32_zext_insert0_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract0_i32_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    zip1 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 0
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i32_zext_insert0_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract0_i32_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 0
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i32_zext_insert0_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract1_i32_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    zip1 v0.4s, v0.4s, v0.4s
; CHECK-NEXT:    ext v0.16b, v0.16b, v1.16b, #12
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 1
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i32_zext_insert0_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract1_i32_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 1
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i32_zext_insert0_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract2_i32_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    uzp1 v0.4s, v0.4s, v0.4s
; CHECK-NEXT:    ext v0.16b, v0.16b, v1.16b, #12
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 2
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i32_zext_insert0_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract2_i32_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    mov w8, v0.s[2]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 2
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i32_zext_insert0_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract3_i32_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    ext v0.16b, v0.16b, v1.16b, #12
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 3
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i32_zext_insert0_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract3_i32_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    mov w8, v0.s[3]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 3
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i32_zext_insert1_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract0_i32_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    zip1 v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    ext v0.16b, v0.16b, v1.16b, #8
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 0
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i32_zext_insert1_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract0_i32_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 0
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i32_zext_insert1_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract1_i32_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    ext v0.16b, v0.16b, v1.16b, #4
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 1
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i32_zext_insert1_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract1_i32_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 1
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i32_zext_insert1_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract2_i32_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov v0.s[3], wzr
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 2
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i32_zext_insert1_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract2_i32_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    mov w8, v0.s[2]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 2
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i32_zext_insert1_i64_undef(<4 x i32> %x) {
; CHECK-LABEL: extract3_i32_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    ext v0.16b, v0.16b, v1.16b, #4
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 3
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i32_zext_insert1_i64_zero(<4 x i32> %x) {
; CHECK-LABEL: extract3_i32_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    mov w8, v0.s[3]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <4 x i32> %x, i32 3
  %z = zext i32 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i16_zext_insert0_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract0_i16_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[0]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 0
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i16_zext_insert0_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract0_i16_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[0]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 0
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i16_zext_insert0_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract1_i16_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 1
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i16_zext_insert0_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract1_i16_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 1
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i16_zext_insert0_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract2_i16_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[2]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 2
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i16_zext_insert0_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract2_i16_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[2]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 2
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i16_zext_insert0_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract3_i16_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[3]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 3
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i16_zext_insert0_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract3_i16_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[3]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 3
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i16_zext_insert1_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract0_i16_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[0]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 0
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i16_zext_insert1_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract0_i16_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[0]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 0
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i16_zext_insert1_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract1_i16_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 1
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i16_zext_insert1_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract1_i16_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 1
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i16_zext_insert1_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract2_i16_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[2]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 2
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i16_zext_insert1_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract2_i16_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[2]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 2
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i16_zext_insert1_i64_undef(<8 x i16> %x) {
; CHECK-LABEL: extract3_i16_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.h[3]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 3
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i16_zext_insert1_i64_zero(<8 x i16> %x) {
; CHECK-LABEL: extract3_i16_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.h[3]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <8 x i16> %x, i32 3
  %z = zext i16 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

; i8

define <2 x i64> @extract0_i8_zext_insert0_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract0_i8_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[0]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 0
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i8_zext_insert0_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract0_i8_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[0]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 0
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i8_zext_insert0_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract1_i8_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 1
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i8_zext_insert0_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract1_i8_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 1
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i8_zext_insert0_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract2_i8_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[2]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 2
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i8_zext_insert0_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract2_i8_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[2]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 2
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i8_zext_insert0_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract3_i8_zext_insert0_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[3]
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 3
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i8_zext_insert0_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract3_i8_zext_insert0_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[3]
; CHECK-NEXT:    mov v1.d[0], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 3
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 0
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i8_zext_insert1_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract0_i8_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[0]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 0
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract0_i8_zext_insert1_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract0_i8_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[0]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 0
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i8_zext_insert1_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract1_i8_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 1
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract1_i8_zext_insert1_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract1_i8_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 1
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i8_zext_insert1_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract2_i8_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[2]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 2
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract2_i8_zext_insert1_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract2_i8_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[2]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 2
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i8_zext_insert1_i64_undef(<16 x i8> %x) {
; CHECK-LABEL: extract3_i8_zext_insert1_i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umov w8, v0.b[3]
; CHECK-NEXT:    dup v0.2d, x8
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 3
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> undef, i64 %z, i32 1
  ret <2 x i64> %r
}

define <2 x i64> @extract3_i8_zext_insert1_i64_zero(<16 x i8> %x) {
; CHECK-LABEL: extract3_i8_zext_insert1_i64_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    umov w8, v0.b[3]
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %e = extractelement <16 x i8> %x, i32 3
  %z = zext i8 %e to i64
  %r = insertelement <2 x i64> zeroinitializer, i64 %z, i32 1
  ret <2 x i64> %r
}


; This would crash because we did not expect to create
; a shuffle for a vector where the source operand is
; not the same size as the result.
; TODO: Should we handle this pattern? Ie, is moving to/from
; registers the optimal code?

define <4 x i32> @larger_bv_than_source(<4 x i16> %t0) {
; CHECK-LABEL: larger_bv_than_source:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w8, v0.h[2]
; CHECK-NEXT:    fmov s0, w8
; CHECK-NEXT:    ret
  %t1 = extractelement <4 x i16> %t0, i32 2
  %vgetq_lane = zext i16 %t1 to i32
  %t2 = insertelement <4 x i32> undef, i32 %vgetq_lane, i64 0
  ret <4 x i32> %t2
}

