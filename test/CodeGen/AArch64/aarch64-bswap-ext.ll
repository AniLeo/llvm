; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

define <2 x i32> @test1(<2 x i16> %v2i16) {
; CHECK-LABEL: test1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    rev32 v0.8b, v0.8b
; CHECK-NEXT:    sshr v0.2s, v0.2s, #16
; CHECK-NEXT:    ret
  %v2i16_rev = call <2 x i16> @llvm.bswap.v2i16(<2 x i16> %v2i16)
  %v2i32 = sext <2 x i16> %v2i16_rev to <2 x i32>
  ret <2 x i32> %v2i32
}

define <2 x float> @test2(<2 x i16> %v2i16) {
; CHECK-LABEL: test2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    rev32 v0.8b, v0.8b
; CHECK-NEXT:    sshr v0.2s, v0.2s, #16
; CHECK-NEXT:    scvtf v0.2s, v0.2s
; CHECK-NEXT:    ret
  %v2i16_rev = call <2 x i16> @llvm.bswap.v2i16(<2 x i16> %v2i16)
  %v2f32 = sitofp <2 x i16> %v2i16_rev to <2 x float>
  ret <2 x float> %v2f32
}

declare <2 x i16> @llvm.bswap.v2i16(<2 x i16>) nounwind readnone
