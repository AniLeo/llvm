; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -csky-no-aliases -mattr=+e2 -mattr=+2e3 < %s -mtriple=csky | FileCheck %s

define i32 @ctlz(i32 %x) {
; CHECK-LABEL: ctlz:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ff1.32 a0, a0
; CHECK-NEXT:    rts16
entry:
  %nlz = call i32 @llvm.ctlz.i32(i32 %x, i1 1)
  ret i32 %nlz
}

define i32 @bswap(i32 %x) {
; CHECK-LABEL: bswap:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    revb16 a0, a0
; CHECK-NEXT:    rts16
entry:
  %revb32 = call i32 @llvm.bswap.i32(i32 %x)
  ret i32 %revb32
}

define i32 @bitreverse(i32 %x) {
; CHECK-LABEL: bitreverse:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    brev32 a0, a0
; CHECK-NEXT:    rts16
entry:
  %brev32 = call i32 @llvm.bitreverse.i32(i32 %x)
  ret i32 %brev32
}

declare i32 @llvm.bswap.i32(i32)
declare i32 @llvm.ctlz.i32 (i32, i1)
declare i32 @llvm.bitreverse.i32(i32)
