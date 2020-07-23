; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s

; This test case aims to test the vector modulo instructions on Power10.
; The vector modulo instructions operate on signed and unsigned words
; and doublewords.

define <2 x i64> @test_vmodud(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vmodud:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmodud v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %rem = urem <2 x i64> %a, %b
  ret <2 x i64> %rem
}

define <2 x i64> @test_vmodsd(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vmodsd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmodsd v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %rem = srem <2 x i64> %a, %b
  ret <2 x i64> %rem
}

define <4 x i32> @test_vmoduw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vmoduw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmoduw v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %rem = urem <4 x i32> %a, %b
  ret <4 x i32> %rem
}

define <4 x i32> @test_vmodsw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vmodsw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmodsw v2, v2, v3
; CHECK-NEXT:    blr
entry:
  %rem = srem <4 x i32> %a, %b
  ret <4 x i32> %rem
}

define <2 x i64> @test_vmodud_with_div(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vmodud_with_div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmodud v4, v2, v3
; CHECK-NEXT:    vdivud v2, v2, v3
; CHECK-NEXT:    vaddudm v2, v4, v2
; CHECK-NEXT:    blr
entry:
  %rem = urem <2 x i64> %a, %b
  %div = udiv <2 x i64> %a, %b
  %add = add <2 x i64> %rem, %div
  ret <2 x i64> %add
}

define <2 x i64> @test_vmodsd_with_div(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vmodsd_with_div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmodsd v4, v2, v3
; CHECK-NEXT:    vdivsd v2, v2, v3
; CHECK-NEXT:    vaddudm v2, v4, v2
; CHECK-NEXT:    blr
entry:
  %rem = srem <2 x i64> %a, %b
  %div = sdiv <2 x i64> %a, %b
  %add = add <2 x i64> %rem, %div
  ret <2 x i64> %add
}

define <4 x i32> @test_vmoduw_with_div(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vmoduw_with_div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmoduw v4, v2, v3
; CHECK-NEXT:    vdivuw v2, v2, v3
; CHECK-NEXT:    vadduwm v2, v4, v2
; CHECK-NEXT:    blr
entry:
  %rem = urem <4 x i32> %a, %b
  %div = udiv <4 x i32> %a, %b
  %add = add <4 x i32> %rem, %div
  ret <4 x i32> %add
}

define <4 x i32> @test_vmodsw_div(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vmodsw_div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmodsw v4, v2, v3
; CHECK-NEXT:    vdivsw v2, v2, v3
; CHECK-NEXT:    vadduwm v2, v4, v2
; CHECK-NEXT:    blr
entry:
  %rem = srem <4 x i32> %a, %b
  %div = sdiv <4 x i32> %a, %b
  %add = add <4 x i32> %rem, %div
  ret <4 x i32> %add
}
