; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=avx2 | FileCheck %s

; Make sure this sequence doesn't hang in DAG combine.

define <8 x i32> @foo(<8 x i64> %x, <4 x i64> %y) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vandps %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %ymm1, %ymm1
; CHECK-NEXT:    vperm2f128 {{.*#+}} ymm2 = ymm0[2,3],ymm1[2,3]
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[0,2],ymm2[0,2],ymm0[4,6],ymm2[4,6]
; CHECK-NEXT:    retl
  %a = shufflevector <4 x i64> %y, <4 x i64> <i64 12345, i64 67890, i64 13579, i64 24680>, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %b = and <8 x i64> %x, %a
  %c = trunc <8 x i64> %b to <8 x i32>
  ret <8 x i32> %c
}

