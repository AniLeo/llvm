; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 | FileCheck %s

define <8 x i32> @foo(<8 x i1> %bar) nounwind readnone {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    vpslld $31, %ymm0, %ymm0
; CHECK-NEXT:    vpsrad $31, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %s = sext <8 x i1> %bar to <8 x i32>
  ret <8 x i32> %s
}

