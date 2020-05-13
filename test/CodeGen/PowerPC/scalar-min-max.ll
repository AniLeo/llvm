; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr8 -ppc-asm-full-reg-names --enable-unsafe-fp-math \
; RUN:   -verify-machineinstrs --enable-no-signed-zeros-fp-math \
; RUN:   --enable-no-nans-fp-math \
; RUN:   -mtriple=powerpc64le-unknown-unknown < %s | FileCheck %s
; RUN: llc -mcpu=pwr9 -ppc-asm-full-reg-names --enable-unsafe-fp-math \
; RUN:   -verify-machineinstrs --enable-no-signed-zeros-fp-math \
; RUN:   --enable-no-nans-fp-math \
; RUN:   -mtriple=powerpc64le-unknown-unknown < %s | FileCheck %s
; RUN: llc -mcpu=pwr9 -ppc-asm-full-reg-names -verify-machineinstrs \
; RUN:   -mtriple=powerpc64le-unknown-unknown < %s | FileCheck %s \
; RUN:   --check-prefix=NO-FAST-P9
; RUN: llc -mcpu=pwr8 -ppc-asm-full-reg-names -verify-machineinstrs \
; RUN:   -mtriple=powerpc64le-unknown-unknown < %s | FileCheck %s \
; RUN:   --check-prefix=NO-FAST-P8
define dso_local float @testfmax(float %a, float %b) local_unnamed_addr {
; CHECK-LABEL: testfmax:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmaxdp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testfmax:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmaxcdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testfmax:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    fcmpu cr0, f1, f2
; NO-FAST-P8-NEXT:    bgtlr cr0
; NO-FAST-P8-NEXT:  # %bb.1: # %entry
; NO-FAST-P8-NEXT:    fmr f1, f2
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp ogt float %a, %b
  %cond = select i1 %cmp, float %a, float %b
  ret float %cond
}

define dso_local double @testdmax(double %a, double %b) local_unnamed_addr {
; CHECK-LABEL: testdmax:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmaxdp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testdmax:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmaxcdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testdmax:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    xscmpudp cr0, f1, f2
; NO-FAST-P8-NEXT:    bgtlr cr0
; NO-FAST-P8-NEXT:  # %bb.1: # %entry
; NO-FAST-P8-NEXT:    fmr f1, f2
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp ogt double %a, %b
  %cond = select i1 %cmp, double %a, double %b
  ret double %cond
}

define dso_local float @testfmin(float %a, float %b) local_unnamed_addr {
; CHECK-LABEL: testfmin:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmindp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testfmin:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmincdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testfmin:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    fcmpu cr0, f1, f2
; NO-FAST-P8-NEXT:    bltlr cr0
; NO-FAST-P8-NEXT:  # %bb.1: # %entry
; NO-FAST-P8-NEXT:    fmr f1, f2
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp olt float %a, %b
  %cond = select i1 %cmp, float %a, float %b
  ret float %cond
}

define dso_local double @testdmin(double %a, double %b) local_unnamed_addr {
; CHECK-LABEL: testdmin:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmindp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testdmin:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmincdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testdmin:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    xscmpudp cr0, f1, f2
; NO-FAST-P8-NEXT:    bltlr cr0
; NO-FAST-P8-NEXT:  # %bb.1: # %entry
; NO-FAST-P8-NEXT:    fmr f1, f2
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp olt double %a, %b
  %cond = select i1 %cmp, double %a, double %b
  ret double %cond
}

define dso_local float @testfmax_fast(float %a, float %b) local_unnamed_addr {
; CHECK-LABEL: testfmax_fast:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmaxdp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testfmax_fast:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmaxcdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testfmax_fast:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    xssubsp f0, f2, f1
; NO-FAST-P8-NEXT:    fsel f1, f0, f2, f1
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp fast ogt float %a, %b
  %cond = select i1 %cmp, float %a, float %b
  ret float %cond
}
define dso_local double @testdmax_fast(double %a, double %b) local_unnamed_addr {
; CHECK-LABEL: testdmax_fast:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmaxdp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testdmax_fast:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmaxcdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testdmax_fast:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    xssubdp f0, f2, f1
; NO-FAST-P8-NEXT:    fsel f1, f0, f2, f1
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp fast ogt double %a, %b
  %cond = select i1 %cmp, double %a, double %b
  ret double %cond
}
define dso_local float @testfmin_fast(float %a, float %b) local_unnamed_addr {
; CHECK-LABEL: testfmin_fast:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmindp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testfmin_fast:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmincdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testfmin_fast:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    xssubsp f0, f1, f2
; NO-FAST-P8-NEXT:    fsel f1, f0, f2, f1
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp fast olt float %a, %b
  %cond = select i1 %cmp, float %a, float %b
  ret float %cond
}
define dso_local double @testdmin_fast(double %a, double %b) local_unnamed_addr {
; CHECK-LABEL: testdmin_fast:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmindp f1, f1, f2
; CHECK-NEXT:    blr
;
; NO-FAST-P9-LABEL: testdmin_fast:
; NO-FAST-P9:       # %bb.0: # %entry
; NO-FAST-P9-NEXT:    xsmincdp f1, f1, f2
; NO-FAST-P9-NEXT:    blr
;
; NO-FAST-P8-LABEL: testdmin_fast:
; NO-FAST-P8:       # %bb.0: # %entry
; NO-FAST-P8-NEXT:    xssubdp f0, f1, f2
; NO-FAST-P8-NEXT:    fsel f1, f0, f2, f1
; NO-FAST-P8-NEXT:    blr
entry:
  %cmp = fcmp fast olt double %a, %b
  %cond = select i1 %cmp, double %a, double %b
  ret double %cond
}
