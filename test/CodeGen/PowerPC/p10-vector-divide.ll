; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s

; This test case aims to test the vector divide instructions on Power10.
; This includes the low order and extended versions of vector divide,
; that operate on signed and unsigned words and doublewords.

define <2 x i64> @test_vdivud(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vdivud:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdivud v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = udiv <2 x i64> %a, %b
  ret <2 x i64> %div
}

define <2 x i64> @test_vdivsd(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vdivsd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdivsd v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = sdiv <2 x i64> %a, %b
  ret <2 x i64> %div
}

define <4 x i32> @test_vdivuw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vdivuw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdivuw v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = udiv <4 x i32> %a, %b
  ret <4 x i32> %div
}

define <4 x i32> @test_vdivsw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vdivsw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdivsw v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = sdiv <4 x i32> %a, %b
  ret <4 x i32> %div
}

; Test the vector divide extended intrinsics.
declare <4 x i32> @llvm.ppc.altivec.vdivesw(<4 x i32>, <4 x i32>)
declare <4 x i32> @llvm.ppc.altivec.vdiveuw(<4 x i32>, <4 x i32>)
declare <2 x i64> @llvm.ppc.altivec.vdivesd(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.ppc.altivec.vdiveud(<2 x i64>, <2 x i64>)

define <4 x i32> @test_vdivesw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vdivesw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdivesw v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = tail call <4 x i32> @llvm.ppc.altivec.vdivesw(<4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %div
}

define <4 x i32> @test_vdiveuw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vdiveuw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdiveuw v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = tail call <4 x i32> @llvm.ppc.altivec.vdiveuw(<4 x i32> %a, <4 x i32> %b)
  ret <4 x i32> %div
}

define <1 x i128> @test_vdivsq(<1 x i128> %x, <1 x i128> %y) nounwind readnone {
; CHECK-LABEL: test_vdivsq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vdivsq v2, v2, v3
; CHECK-NEXT:    blr
  %tmp = sdiv <1 x i128> %x, %y
  ret <1 x i128> %tmp
}

define <1 x i128> @test_vdivuq(<1 x i128> %x, <1 x i128> %y) nounwind readnone {
; CHECK-LABEL: test_vdivuq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vdivuq v2, v2, v3
; CHECK-NEXT:    blr
  %tmp = udiv <1 x i128> %x, %y
  ret <1 x i128> %tmp
}

define <2 x i64> @test_vdivesd(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vdivesd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdivesd v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = tail call <2 x i64> @llvm.ppc.altivec.vdivesd(<2 x i64> %a, <2 x i64> %b)
  ret <2 x i64> %div
}

define <2 x i64> @test_vdiveud(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vdiveud:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdiveud v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %div = tail call <2 x i64> @llvm.ppc.altivec.vdiveud(<2 x i64> %a, <2 x i64> %b)
  ret <2 x i64> %div
}
