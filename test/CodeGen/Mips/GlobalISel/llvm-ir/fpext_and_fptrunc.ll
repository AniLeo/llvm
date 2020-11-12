; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel \
; RUN:     -verify-machineinstrs %s -o -| FileCheck %s
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -mattr=+fp64,+mips32r2 -global-isel \
; RUN:     -verify-machineinstrs %s -o -| FileCheck %s

define double @fpext(float %a) {
; CHECK-LABEL: fpext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cvt.d.s $f0, $f12
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    nop
entry:
  %conv = fpext float %a to double
  ret double %conv
}

define float @fptrunc(double %a) {
; CHECK-LABEL: fptrunc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cvt.s.d $f0, $f12
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    nop
entry:
  %conv = fptrunc double %a to float
  ret float %conv
}
