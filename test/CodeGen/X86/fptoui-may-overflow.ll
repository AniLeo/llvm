; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx | FileCheck %s

; @fptoui_zext is legal to optimize to a single vcvttps2dq: if one of the i8
; results of fptoui is poisoned, the corresponding i32 result of the zext is
; also poisoned. We currently don't implement this optimization.

define <16 x i8> @fptoui_zext(<4 x float> %arg) {
; CHECK-LABEL: fptoui_zext:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vpackusdw %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vpackuswb %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vpmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-NEXT:    retq
  %f = fptoui <4 x float> %arg to <4 x i8>
  %z = zext <4 x i8> %f to <4 x i32>
  %b = bitcast <4 x i32> %z to <16 x i8>
  ret <16 x i8> %b
}

; In @fptoui_shuffle, we must preserve the vpand for correctnesss. Only the
; i8 values extracted from %s are poison.  The values from the zeroinitializer
; are not.

define <16 x i8> @fptoui_shuffle(<4 x float> %arg) {
; CHECK-LABEL: fptoui_shuffle:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %f = fptoui <4 x float> %arg to <4 x i8>
  %s = shufflevector <4 x i8> %f, <4 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %ss = shufflevector <16 x i8> %s, <16 x i8> zeroinitializer, <16 x i32> <i32 0, i32 17, i32 18, i32 19, i32 1, i32 21, i32 22, i32 23, i32 2, i32 25, i32 26, i32 27, i32 3, i32 29, i32 30, i32 31>
  ret <16 x i8> %ss
}
