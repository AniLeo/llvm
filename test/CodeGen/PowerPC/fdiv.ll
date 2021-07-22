; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr8 | FileCheck %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-ibm-aix-xcoff -mcpu=pwr8 -vec-extabi | FileCheck %s

define dso_local float @foo_nosw(float %0, float %1) local_unnamed_addr {
; CHECK-LABEL: foo_nosw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsdivsp 1, 1, 2
; CHECK-NEXT:    blr
  %3 = fdiv contract reassoc arcp nsz float %0, %1
  ret float %3
}

define dso_local float @foo(float %0, float %1) local_unnamed_addr {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsresp 3, 2
; CHECK-NEXT:    xsmulsp 0, 1, 3
; CHECK-NEXT:    xsnmsubasp 1, 2, 0
; CHECK-NEXT:    xsmaddasp 0, 3, 1
; CHECK-NEXT:    fmr 1, 0
; CHECK-NEXT:    blr
  %3 = fdiv contract reassoc arcp nsz ninf float %0, %1
  ret float %3
}

define dso_local float @fdiv_fast(float %0, float %1) local_unnamed_addr {
; CHECK-LABEL: fdiv_fast:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsresp 3, 2
; CHECK-NEXT:    xsmulsp 0, 1, 3
; CHECK-NEXT:    xsnmsubasp 1, 2, 0
; CHECK-NEXT:    xsmaddasp 0, 3, 1
; CHECK-NEXT:    fmr 1, 0
; CHECK-NEXT:    blr
  %3 = fdiv fast float %0, %1
  ret float %3
}
