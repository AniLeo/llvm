; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -mcpu=pwr10 \
; RUN:   -ppc-vsr-nums-as-vr -mtriple=powerpc64le-unknown-unknown < %s | FileCheck %s

; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -mcpu=pwr10 \
; RUN:   -ppc-vsr-nums-as-vr -mtriple=powerpc64-unknown-unknown < %s | FileCheck %s

define <16 x i8> @testVSLDBI(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: testVSLDBI:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsldbi v2, v2, v3, 1
; CHECK-NEXT:    blr
entry:
  %0 = tail call <16 x i8> @llvm.ppc.altivec.vsldbi(<16 x i8> %a, <16 x i8> %b, i32 1)
  ret <16 x i8> %0
}
declare <16 x i8> @llvm.ppc.altivec.vsldbi(<16 x i8>, <16 x i8>, i32 immarg)

define <16 x i8> @testVSRDBI(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: testVSRDBI:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsrdbi v2, v2, v3, 1
; CHECK-NEXT:    blr
entry:
  %0 = tail call <16 x i8> @llvm.ppc.altivec.vsrdbi(<16 x i8> %a, <16 x i8> %b, i32 1)
  ret <16 x i8> %0
}
declare <16 x i8> @llvm.ppc.altivec.vsrdbi(<16 x i8>, <16 x i8>, i32 immarg)

define <16 x i8> @testXXPERMX(<16 x i8> %a, <16 x i8> %b, <16 x i8> %c) {
; CHECK-LABEL: testXXPERMX:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxpermx v2, v2, v3, v4, 1
; CHECK-NEXT:    blr
entry:
  %0 = tail call <16 x i8> @llvm.ppc.vsx.xxpermx(<16 x i8> %a, <16 x i8> %b, <16 x i8> %c, i32 1)
  ret <16 x i8> %0
}
declare <16 x i8> @llvm.ppc.vsx.xxpermx(<16 x i8>, <16 x i8>, <16 x i8>, i32 immarg)
