; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr9 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr9 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-aix \
; RUN:   -mcpu=pwr9 < %s | FileCheck %s

define dso_local i64 @extract_sig(double %d) {
; CHECK-LABEL: extract_sig:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsxsigdp 3, 1
; CHECK-NEXT:    blr
entry:
  %0 = tail call i64 @llvm.ppc.extract.sig(double %d)
  ret i64 %0
}
declare i64 @llvm.ppc.extract.sig(double)

define dso_local double @insert_exp(double %d, i64 %ull) {
; CHECK-LABEL: insert_exp:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mffprd 3, 1
; CHECK-NEXT:    xsiexpdp 1, 3, 4
; CHECK-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-NEXT:    blr
entry:
  %0 = tail call double @llvm.ppc.insert.exp(double %d, i64 %ull)
  ret double %0
}
declare double @llvm.ppc.insert.exp(double, i64)
