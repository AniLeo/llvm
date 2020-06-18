; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s

; These test cases aim to test the bit manipulation operations on Power10.

declare <2 x i64> @llvm.ppc.altivec.vpdepd(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.ppc.altivec.vpextd(<2 x i64>, <2 x i64>)
declare i64 @llvm.ppc.pdepd(i64, i64)
declare i64 @llvm.ppc.pextd(i64, i64)

define <2 x i64> @test_vpdepd(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vpdepd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpdepd v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %tmp = tail call <2 x i64> @llvm.ppc.altivec.vpdepd(<2 x i64> %a, <2 x i64> %b)
  ret <2 x i64> %tmp
}

define <2 x i64> @test_vpextd(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vpextd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpextd v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %tmp = tail call <2 x i64> @llvm.ppc.altivec.vpextd(<2 x i64> %a, <2 x i64> %b)
  ret <2 x i64> %tmp
}

define i64 @test_pdepd(i64 %a, i64 %b) {
; CHECK-LABEL: test_pdepd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pdepd r3, r3, r4
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.pdepd(i64 %a, i64 %b)
  ret i64 %tmp
}

define i64 @test_pextd(i64 %a, i64 %b) {
; CHECK-LABEL: test_pextd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pextd r3, r3, r4
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.pextd(i64 %a, i64 %b)
  ret i64 %tmp
}
