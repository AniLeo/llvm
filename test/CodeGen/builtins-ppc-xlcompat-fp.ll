; REQUIRES: power-pc-registered-target
; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-unknown \
; RUN:   -mcpu=pwr7 < %s | FileCheck %s --check-prefix=CHECK-PWR7
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown \
; RUN:   -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK-PWR8
; RUN: llc -verify-machineinstrs -mtriple=powerpc-unknown-aix \
; RUN:   -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK-PWR8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown \
; RUN:   -mattr=-vsx -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK-NOVSX

define dso_local double @test_fsel(double %a, double %b, double %c) local_unnamed_addr {
; CHECK-PWR7-LABEL: test_fsel:
; CHECK-PWR7:       # %bb.0: # %entry
; CHECK-PWR7-NEXT:    fsel 1, 1, 2, 3
; CHECK-PWR7-NEXT:    blr
;
; CHECK-PWR8-LABEL: test_fsel:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    fsel 1, 1, 2, 3
; CHECK-PWR8-NEXT:    blr
;
; CHECK-NOVSX-LABEL: test_fsel:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    fsel 1, 1, 2, 3
; CHECK-NOVSX-NEXT:    blr

entry:
  %0 = tail call double @llvm.ppc.fsel(double %a, double %b, double %c)
  ret double %0
}

declare double @llvm.ppc.fsel(double, double, double)

define dso_local float @test_fsels(float %a, float %b, float %c) local_unnamed_addr {
; CHECK-PWR7-LABEL: test_fsels:
; CHECK-PWR7:       # %bb.0: # %entry
; CHECK-PWR7-NEXT:    fsel 1, 1, 2, 3
; CHECK-PWR7-NEXT:    blr
;
; CHECK-PWR8-LABEL: test_fsels:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    fsel 1, 1, 2, 3
; CHECK-PWR8-NEXT:    blr
;
; CHECK-NOVSX-LABEL: test_fsels:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    fsel 1, 1, 2, 3
; CHECK-NOVSX-NEXT:    blr

entry:
  %0 = tail call float @llvm.ppc.fsels(float %a, float %b, float %c)
  ret float %0
}

declare float @llvm.ppc.fsels(float, float, float)

define dso_local double @test_frsqrte(double %a) local_unnamed_addr {
; CHECK-PWR7-LABEL: test_frsqrte:
; CHECK-PWR7:       # %bb.0: # %entry
; CHECK-PWR7-NEXT:    xsrsqrtedp 1, 1
; CHECK-PWR7-NEXT:    blr
;
; CHECK-PWR8-LABEL: test_frsqrte:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    xsrsqrtedp 1, 1
; CHECK-PWR8-NEXT:    blr
;
; CHECK-NOVSX-LABEL: test_frsqrte:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    frsqrte 1, 1
; CHECK-NOVSX-NEXT:    blr

entry:
  %0 = tail call double @llvm.ppc.frsqrte(double %a)
  ret double %0
}

declare double @llvm.ppc.frsqrte(double)

define dso_local float @test_frsqrtes(float %a) local_unnamed_addr {
; CHECK-PWR7-LABEL: test_frsqrtes:
; CHECK-PWR7:       # %bb.0: # %entry
; CHECK-PWR7-NEXT:    frsqrtes 1, 1
; CHECK-PWR7-NEXT:    blr
;
; CHECK-PWR8-LABEL: test_frsqrtes:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    xsrsqrtesp 1, 1
; CHECK-PWR8-NEXT:    blr
;
; CHECK-NOVSX-LABEL: test_frsqrtes:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    frsqrtes 1, 1
; CHECK-NOVSX-NEXT:    blr

entry:
  %0 = tail call float @llvm.ppc.frsqrtes(float %a)
  ret float %0
}

declare float @llvm.ppc.frsqrtes(float)
