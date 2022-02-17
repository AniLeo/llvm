; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-linux-android | FileCheck %s

declare <2 x i16> @llvm.fshl.v2i16(<2 x i16>, <2 x i16>, <2 x i16>)

define <2 x i16>  @rotlv2_16(<2 x i16> %vec2_16, <2 x i16> %shift) {
; CHECK-LABEL: rotlv2_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.2s, #15
; CHECK-NEXT:    movi d3, #0x00ffff0000ffff
; CHECK-NEXT:    neg v4.2s, v1.2s
; CHECK-NEXT:    and v4.8b, v4.8b, v2.8b
; CHECK-NEXT:    and v3.8b, v0.8b, v3.8b
; CHECK-NEXT:    neg v4.2s, v4.2s
; CHECK-NEXT:    and v1.8b, v1.8b, v2.8b
; CHECK-NEXT:    ushl v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    ushl v2.2s, v3.2s, v4.2s
; CHECK-NEXT:    orr v0.8b, v0.8b, v2.8b
; CHECK-NEXT:    ret
  %1 = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> %vec2_16, <2 x i16> %vec2_16, <2 x i16> %shift)
  ret <2 x i16> %1
}
