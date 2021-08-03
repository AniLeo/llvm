; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O0 -mtriple=aarch64-unknown-unknown | FileCheck %s

; Function Attrs: nobuiltin nounwind readonly
define i8 @popcount128(i128* nocapture nonnull readonly %0) {
; CHECK-LABEL: popcount128:
; CHECK:       // %bb.0: // %Entry
; CHECK-NEXT:    ldr x8, [x0, #8]
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    mov v0.d[1], x8
; CHECK-NEXT:    cnt v0.16b, v0.16b
; CHECK-NEXT:    uaddlv h1, v0.16b
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov s0, s1
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
Entry:
  %1 = load i128, i128* %0, align 16
  %2 = tail call i128 @llvm.ctpop.i128(i128 %1)
  %3 = trunc i128 %2 to i8
  ret i8 %3
}

; Function Attrs: nounwind readnone speculatable willreturn
declare i128 @llvm.ctpop.i128(i128)

; Function Attrs: nobuiltin nounwind readonly
define i16 @popcount256(i256* nocapture nonnull readonly %0) {
; CHECK-LABEL: popcount256:
; CHECK:       // %bb.0: // %Entry
; CHECK-NEXT:    ldr x8, [x0, #8]
; CHECK-NEXT:    ldr x9, [x0, #24]
; CHECK-NEXT:    ldr d1, [x0, #16]
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    mov v0.d[1], x9
; CHECK-NEXT:    cnt v0.16b, v0.16b
; CHECK-NEXT:    uaddlv h1, v0.16b
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov s0, s1
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    mov v0.d[1], x8
; CHECK-NEXT:    cnt v0.16b, v0.16b
; CHECK-NEXT:    uaddlv h1, v0.16b
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov s0, s1
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    add w0, w8, w9
; CHECK-NEXT:    ret
Entry:
  %1 = load i256, i256* %0, align 16
  %2 = tail call i256 @llvm.ctpop.i256(i256 %1)
  %3 = trunc i256 %2 to i16
  ret i16 %3
}

; Function Attrs: nounwind readnone speculatable willreturn
declare i256 @llvm.ctpop.i256(i256)

define <1 x i128> @popcount1x128(<1 x i128> %0) {
; CHECK-LABEL: popcount1x128:
; CHECK:       // %bb.0: // %Entry
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov d0, x0
; CHECK-NEXT:    mov v0.d[1], x1
; CHECK-NEXT:    cnt v0.16b, v0.16b
; CHECK-NEXT:    uaddlv h1, v0.16b
; CHECK-NEXT:    // implicit-def: $q0
; CHECK-NEXT:    fmov s0, s1
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    // kill: def $x0 killed $w0
; CHECK-NEXT:    movi v0.2d, #0000000000000000
; CHECK-NEXT:    mov x1, v0.d[1]
; CHECK-NEXT:    ret
Entry:
  %1 = tail call <1 x i128> @llvm.ctpop.v1.i128(<1 x i128> %0)
  ret <1 x i128> %1
}

declare <1 x i128> @llvm.ctpop.v1.i128(<1 x i128>)
