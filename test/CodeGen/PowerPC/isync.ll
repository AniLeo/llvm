; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu < %s \
; RUN:     -verify-machineinstrs -ppc-asm-full-reg-names \
; RUN:     -ppc-vsr-nums-as-vr | FileCheck %s

define void @isync_test() {
; CHECK-LABEL: isync_test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    isync
; CHECK-NEXT:    blr

entry:
  tail call void @llvm.ppc.isync()
  ret void
}

declare void @llvm.ppc.isync()
