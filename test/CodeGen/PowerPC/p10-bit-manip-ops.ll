; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-aix \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s

; These test cases aim to test the bit manipulation operations on Power10.

declare <2 x i64> @llvm.ppc.altivec.vpdepd(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.ppc.altivec.vpextd(<2 x i64>, <2 x i64>)
declare i64 @llvm.ppc.pdepd(i64, i64)
declare i64 @llvm.ppc.pextd(i64, i64)
declare <2 x i64> @llvm.ppc.altivec.vcfuged(<2 x i64>, <2 x i64>)
declare i64 @llvm.ppc.cfuged(i64, i64)
declare i64 @llvm.ppc.altivec.vgnb(<1 x i128>, i32)
declare <2 x i64> @llvm.ppc.vsx.xxeval(<2 x i64>, <2 x i64>, <2 x i64>, i32)
declare <2 x i64> @llvm.ppc.altivec.vclzdm(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.ppc.altivec.vctzdm(<2 x i64>, <2 x i64>)
declare i64 @llvm.ppc.cntlzdm(i64, i64)
declare i64 @llvm.ppc.cnttzdm(i64, i64)

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

define <2 x i64> @test_vcfuged(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vcfuged:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vcfuged v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %tmp = tail call <2 x i64> @llvm.ppc.altivec.vcfuged(<2 x i64> %a, <2 x i64> %b)
  ret <2 x i64> %tmp
}

define i64 @test_cfuged(i64 %a, i64 %b) {
; CHECK-LABEL: test_cfuged:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cfuged r3, r3, r4
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.cfuged(i64 %a, i64 %b)
  ret i64 %tmp
}

define i64 @test_vgnb_1(<1 x i128> %a) {
; CHECK-LABEL: test_vgnb_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vgnb r3, v2, 2
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.altivec.vgnb(<1 x i128> %a, i32 2)
  ret i64 %tmp
}

define i64 @test_vgnb_2(<1 x i128> %a) {
; CHECK-LABEL: test_vgnb_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vgnb r3, v2, 7
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.altivec.vgnb(<1 x i128> %a, i32 7)
  ret i64 %tmp
}

define i64 @test_vgnb_3(<1 x i128> %a) {
; CHECK-LABEL: test_vgnb_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vgnb r3, v2, 5
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.altivec.vgnb(<1 x i128> %a, i32 5)
  ret i64 %tmp
}

define <2 x i64> @test_xxeval(<2 x i64> %a, <2 x i64> %b, <2 x i64> %c) {
; CHECK-LABEL: test_xxeval:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxeval v2, v2, v3, v4, 255
; CHECK-NEXT:    blr
entry:
  %tmp = tail call <2 x i64> @llvm.ppc.vsx.xxeval(<2 x i64> %a, <2 x i64> %b, <2 x i64> %c, i32 255)
  ret <2 x i64> %tmp
}

define <2 x i64> @test_vclzdm(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vclzdm:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vclzdm v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %tmp = tail call <2 x i64> @llvm.ppc.altivec.vclzdm(<2 x i64> %a, <2 x i64> %b)
  ret <2 x i64> %tmp
}

define <2 x i64> @test_vctzdm(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vctzdm:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vctzdm v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %tmp = tail call <2 x i64> @llvm.ppc.altivec.vctzdm(<2 x i64> %a, <2 x i64> %b)
  ret <2 x i64> %tmp
}

define i64 @test_cntlzdm(i64 %a, i64 %b) {
; CHECK-LABEL: test_cntlzdm:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cntlzdm r3, r3, r4
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.cntlzdm(i64 %a, i64 %b)
  ret i64 %tmp
}

define i64 @test_cnttzdm(i64 %a, i64 %b) {
; CHECK-LABEL: test_cnttzdm:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cnttzdm r3, r3, r4
; CHECK-NEXT:    blr
entry:
  %tmp = tail call i64 @llvm.ppc.cnttzdm(i64 %a, i64 %b)
  ret i64 %tmp
}
