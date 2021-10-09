; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-apple-darwin | FileCheck %s

; rdar://9332258

define float @test1(float %x, float %y) nounwind {
; CHECK-LABEL: test1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.4s v2, #128, lsl #24
; CHECK-NEXT:    ; kill: def $s0 killed $s0 def $q0
; CHECK-NEXT:    ; kill: def $s1 killed $s1 def $q1
; CHECK-NEXT:    bit.16b v0, v1, v2
; CHECK-NEXT:    ; kill: def $s0 killed $s0 killed $q0
; CHECK-NEXT:    ret
entry:
  %0 = tail call float @copysignf(float %x, float %y) nounwind readnone
  ret float %0
}

define double @test2(double %x, double %y) nounwind {
; CHECK-LABEL: test2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.2d v2, #0000000000000000
; CHECK-NEXT:    ; kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    ; kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    fneg.2d v2, v2
; CHECK-NEXT:    bit.16b v0, v1, v2
; CHECK-NEXT:    ; kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
entry:
  %0 = tail call double @copysign(double %x, double %y) nounwind readnone
  ret double %0
}

; rdar://9545768
define double @test3(double %a, float %b, float %c) nounwind {
; CHECK-LABEL: test3:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    movi.2d v3, #0000000000000000
; CHECK-NEXT:    ; kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    fadd s1, s1, s2
; CHECK-NEXT:    fneg.2d v2, v3
; CHECK-NEXT:    fcvt d1, s1
; CHECK-NEXT:    bit.16b v0, v1, v2
; CHECK-NEXT:    ; kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
  %tmp1 = fadd float %b, %c
  %tmp2 = fpext float %tmp1 to double
  %tmp = tail call double @copysign( double %a, double %tmp2 ) nounwind readnone
  ret double %tmp
}

define float @test4() nounwind {
; CHECK-LABEL: test4:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; CHECK-NEXT:    bl _bar
; CHECK-NEXT:    movi.4s v1, #128, lsl #24
; CHECK-NEXT:    fcvt s0, d0
; CHECK-NEXT:    fmov s2, #0.50000000
; CHECK-NEXT:    bit.16b v2, v0, v1
; CHECK-NEXT:    fadd s0, s0, s2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %0 = tail call double (...) @bar() nounwind
  %1 = fptrunc double %0 to float
  %2 = tail call float @copysignf(float 5.000000e-01, float %1) nounwind readnone
  %3 = fadd float %1, %2
  ret float %3
}

declare double @bar(...)
declare double @copysign(double, double) nounwind readnone
declare float @copysignf(float, float) nounwind readnone
