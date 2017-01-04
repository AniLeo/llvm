; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 < %s | FileCheck %s
target triple = "powerpc64le--linux-gnu"

define i1 @Test(double %a) {
; CHECK-LABEL: Test:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    xscvdpsxws 1, 1
; CHECK-NEXT:    mfvsrwz 3, 1
; CHECK-NEXT:    xori 3, 3, 65534
; CHECK-NEXT:    cntlzw 3, 3
; CHECK-NEXT:    srwi 3, 3, 5
; CHECK-NEXT:    # implicit-def: %X4
; CHECK-NEXT:    mr 4, 3
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
entry:
  %conv = fptoui double %a to i16
  %cmp = icmp eq i16 %conv, -2
  ret i1 %cmp
}
