; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s --check-prefixes=CHECK
; RUN: FileCheck --check-prefix=WARN --allow-empty %s < %t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; LEGAL INTEGER TYPES

define <vscale x 2 x i64> @stepvector_nxv2i64() {
; CHECK-LABEL: stepvector_nxv2i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
  ret <vscale x 2 x i64> %0
}

define <vscale x 4 x i32> @stepvector_nxv4i32() {
; CHECK-LABEL: stepvector_nxv4i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 4 x i32> @llvm.experimental.stepvector.nxv4i32()
  ret <vscale x 4 x i32> %0
}

define <vscale x 8 x i16> @stepvector_nxv8i16() {
; CHECK-LABEL: stepvector_nxv8i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    index z0.h, #0, #1
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 8 x i16> @llvm.experimental.stepvector.nxv8i16()
  ret <vscale x 8 x i16> %0
}

define <vscale x 16 x i8> @stepvector_nxv16i8() {
; CHECK-LABEL: stepvector_nxv16i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    index z0.b, #0, #1
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 16 x i8> @llvm.experimental.stepvector.nxv16i8()
  ret <vscale x 16 x i8> %0
}

; ILLEGAL INTEGER TYPES

define <vscale x 4 x i64> @stepvector_nxv4i64() {
; CHECK-LABEL: stepvector_nxv4i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cntd x8
; CHECK-NEXT:    mov z1.d, x8
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    add z1.d, z0.d, z1.d
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  ret <vscale x 4 x i64> %0
}

define <vscale x 16 x i32> @stepvector_nxv16i32() {
; CHECK-LABEL: stepvector_nxv16i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cntw x9
; CHECK-NEXT:    cnth x8
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    mov z1.s, w9
; CHECK-NEXT:    mov z3.s, w8
; CHECK-NEXT:    add z1.s, z0.s, z1.s
; CHECK-NEXT:    add z2.s, z0.s, z3.s
; CHECK-NEXT:    add z3.s, z1.s, z3.s
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
  ret <vscale x 16 x i32> %0
}

define <vscale x 2 x i32> @stepvector_nxv2i32() {
; CHECK-LABEL: stepvector_nxv2i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 2 x i32> @llvm.experimental.stepvector.nxv2i32()
  ret <vscale x 2 x i32> %0
}

define <vscale x 4 x i16> @stepvector_nxv4i16() {
; CHECK-LABEL: stepvector_nxv4i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 4 x i16> @llvm.experimental.stepvector.nxv4i16()
  ret <vscale x 4 x i16> %0
}

define <vscale x 8 x i8> @stepvector_nxv8i8() {
; CHECK-LABEL: stepvector_nxv8i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    index z0.h, #0, #1
; CHECK-NEXT:    ret
entry:
  %0 = call <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
  ret <vscale x 8 x i8> %0
}

declare <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
declare <vscale x 4 x i32> @llvm.experimental.stepvector.nxv4i32()
declare <vscale x 8 x i16> @llvm.experimental.stepvector.nxv8i16()
declare <vscale x 16 x i8> @llvm.experimental.stepvector.nxv16i8()

declare <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
declare <vscale x 16 x i32> @llvm.experimental.stepvector.nxv16i32()
declare <vscale x 2 x i32> @llvm.experimental.stepvector.nxv2i32()
declare <vscale x 8 x i8> @llvm.experimental.stepvector.nxv8i8()
declare <vscale x 4 x i16> @llvm.experimental.stepvector.nxv4i16()
