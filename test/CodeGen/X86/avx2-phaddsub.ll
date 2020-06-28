; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686--   -mattr=+avx2           | FileCheck %s --check-prefixes=CHECK,X86,SLOW,X86-SLOW
; RUN: llc < %s -mtriple=i686--   -mattr=+avx2,fast-hops | FileCheck %s --check-prefixes=CHECK,X86,FAST,X86-FAST
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2           | FileCheck %s --check-prefixes=CHECK,X64,SLOW,X64-SLOW
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,fast-hops | FileCheck %s --check-prefixes=CHECK,X64,FAST,X64-FAST

define <16 x i16> @phaddw1(<16 x i16> %x, <16 x i16> %y) {
; CHECK-LABEL: phaddw1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddw %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <16 x i16> %x, <16 x i16> %y, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 16, i32 18, i32 20, i32 22, i32 8, i32 10, i32 12, i32 14, i32 24, i32 26, i32 28, i32 30>
  %b = shufflevector <16 x i16> %x, <16 x i16> %y, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 17, i32 19, i32 21, i32 23, i32 9, i32 11, i32 13, i32 15, i32 25, i32 27, i32 29, i32 31>
  %r = add <16 x i16> %a, %b
  ret <16 x i16> %r
}

define <16 x i16> @phaddw2(<16 x i16> %x, <16 x i16> %y) {
; CHECK-LABEL: phaddw2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddw %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <16 x i16> %x, <16 x i16> %y, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 17, i32 19, i32 21, i32 23, i32 9, i32 11, i32 13, i32 15, i32 25, i32 27, i32 29, i32 31>
  %b = shufflevector <16 x i16> %y, <16 x i16> %x, <16 x i32> <i32 16, i32 18, i32 20, i32 22, i32 0, i32 2, i32 4, i32 6, i32 24, i32 26, i32 28, i32 30, i32 8, i32 10, i32 12, i32 14>
  %r = add <16 x i16> %a, %b
  ret <16 x i16> %r
}

define <8 x i32> @phaddd1(<8 x i32> %x, <8 x i32> %y) {
; CHECK-LABEL: phaddd1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 0, i32 2, i32 8, i32 10, i32 4, i32 6, i32 12, i32 14>
  %b = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 1, i32 3, i32 9, i32 11, i32 5, i32 7, i32 13, i32 15>
  %r = add <8 x i32> %a, %b
  ret <8 x i32> %r
}

define <8 x i32> @phaddd2(<8 x i32> %x, <8 x i32> %y) {
; CHECK-LABEL: phaddd2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 1, i32 2, i32 9, i32 10, i32 5, i32 6, i32 13, i32 14>
  %b = shufflevector <8 x i32> %y, <8 x i32> %x, <8 x i32> <i32 8, i32 11, i32 0, i32 3, i32 12, i32 15, i32 4, i32 7>
  %r = add <8 x i32> %a, %b
  ret <8 x i32> %r
}

define <8 x i32> @phaddd3(<8 x i32> %x) {
; CHECK-LABEL: phaddd3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <8 x i32> %x, <8 x i32> undef, <8 x i32> <i32 undef, i32 2, i32 8, i32 10, i32 4, i32 6, i32 undef, i32 14>
  %b = shufflevector <8 x i32> %x, <8 x i32> undef, <8 x i32> <i32 1, i32 3, i32 9, i32 undef, i32 5, i32 7, i32 13, i32 15>
  %r = add <8 x i32> %a, %b
  ret <8 x i32> %r
}

define <16 x i16> @phsubw1(<16 x i16> %x, <16 x i16> %y) {
; CHECK-LABEL: phsubw1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphsubw %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <16 x i16> %x, <16 x i16> %y, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 16, i32 18, i32 20, i32 22, i32 8, i32 10, i32 12, i32 14, i32 24, i32 26, i32 28, i32 30>
  %b = shufflevector <16 x i16> %x, <16 x i16> %y, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 17, i32 19, i32 21, i32 23, i32 9, i32 11, i32 13, i32 15, i32 25, i32 27, i32 29, i32 31>
  %r = sub <16 x i16> %a, %b
  ret <16 x i16> %r
}

define <8 x i32> @phsubd1(<8 x i32> %x, <8 x i32> %y) {
; CHECK-LABEL: phsubd1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphsubd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 0, i32 2, i32 8, i32 10, i32 4, i32 6, i32 12, i32 14>
  %b = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 1, i32 3, i32 9, i32 11, i32 5, i32 7, i32 13, i32 15>
  %r = sub <8 x i32> %a, %b
  ret <8 x i32> %r
}

define <8 x i32> @phsubd2(<8 x i32> %x, <8 x i32> %y) {
; CHECK-LABEL: phsubd2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphsubd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 0, i32 undef, i32 8, i32 undef, i32 4, i32 6, i32 12, i32 14>
  %b = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 1, i32 undef, i32 9, i32 11, i32 5, i32 7, i32 undef, i32 15>
  %r = sub <8 x i32> %a, %b
  ret <8 x i32> %r
}
