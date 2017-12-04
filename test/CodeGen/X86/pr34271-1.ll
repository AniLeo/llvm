; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=avx512vl,avx512bw | FileCheck %s

define <16 x i16> @foo(<16 x i32> %i) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpminud {{.*}}(%rip){1to16}, %zmm0, %zmm0
; CHECK-NEXT:    vpmovdw %zmm0, %ymm0
; CHECK-NEXT:    retq
  %x3 = icmp ult <16 x i32> %i, <i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009>
  %x5 = select <16 x i1> %x3, <16 x i32> %i, <16 x i32> <i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009, i32 16843009>
  %x6 = trunc <16 x i32> %x5 to <16 x i16>
  ret <16 x i16> %x6
}
