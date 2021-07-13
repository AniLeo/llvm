; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr9 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr9 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-aix \
; RUN:   -mcpu=pwr9 < %s | FileCheck %s

define dso_local i64 @test_builtin_ppc_cmpeqb(i64 %a, i64 %b) {
; CHECK-LABEL: test_builtin_ppc_cmpeqb:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpeqb 0, 3, 4
; CHECK-NEXT:    setb 3, 0
; CHECK-NEXT:    blr
entry:
  %0 = call i64 @llvm.ppc.cmpeqb(i64 %a, i64 %b)
  ret i64 %0
}

declare i64 @llvm.ppc.cmpeqb(i64, i64)

define dso_local i64 @test_builtin_ppc_setb(i64 %a, i64 %b) {
; CHECK-LABEL: test_builtin_ppc_setb:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 3, 4
; CHECK-NEXT:    setb 3, 0
; CHECK-NEXT:    blr
entry:
  %0 = call i64 @llvm.ppc.setb(i64 %a, i64 %b)
  ret i64 %0
}

declare i64 @llvm.ppc.setb(i64, i64)
