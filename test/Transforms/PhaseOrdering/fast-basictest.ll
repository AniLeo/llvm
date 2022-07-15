; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
;
; Test cases in this file are intended to be run with both reassociate and
; instcombine passes enabled.
;
; Test numbering remains continuous across:
; - InstCombine/fast-basictest.ll
; - PhaseOrdering/fast-basictest.ll
; - PhaseOrdering/fast-reassociate-gvn.ll
; - Reassociate/fast-basictest.ll
;
; RUN: opt < %s -reassociate -instcombine -S | FileCheck %s --check-prefixes=CHECK,REASSOC_AND_IC --allow-unused-prefixes
; RUN: opt < %s -O2 -S | FileCheck %s --check-prefixes=CHECK,O2 --allow-unused-prefixes

; test2 ... test18 - both reassociate and instcombine passes
; are required to perform a transform

; ((a + (-3)) + b) + 3 -> a + b

define float @test2(float %reg109, float %reg1111) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[REG117:%.*]] = fadd fast float [[REG109:%.*]], [[REG1111:%.*]]
; CHECK-NEXT:    ret float [[REG117]]
;
  %reg115 = fadd fast float %reg109, -3.000000e+01
  %reg116 = fadd fast float %reg115, %reg1111
  %reg117 = fadd fast float %reg116, 3.000000e+01
  ret float %reg117
}

; Verify that fold is not done without 'fast'
define float @test2_no_FMF(float %reg109, float %reg1111) {
; CHECK-LABEL: @test2_no_FMF(
; CHECK-NEXT:    [[REG115:%.*]] = fadd float [[REG109:%.*]], -3.000000e+01
; CHECK-NEXT:    [[REG116:%.*]] = fadd float [[REG115]], [[REG1111:%.*]]
; CHECK-NEXT:    [[REG117:%.*]] = fadd float [[REG116]], 3.000000e+01
; CHECK-NEXT:    ret float [[REG117]]
;
  %reg115 = fadd float %reg109, -3.000000e+01
  %reg116 = fadd float %reg115, %reg1111
  %reg117 = fadd float %reg116, 3.000000e+01
  ret float %reg117
}

define float @test2_reassoc(float %reg109, float %reg1111) {
; CHECK-LABEL: @test2_reassoc(
; CHECK-NEXT:    [[REG115:%.*]] = fadd reassoc float [[REG109:%.*]], -3.000000e+01
; CHECK-NEXT:    [[REG116:%.*]] = fadd reassoc float [[REG115]], [[REG1111:%.*]]
; CHECK-NEXT:    [[REG117:%.*]] = fadd reassoc float [[REG116]], 3.000000e+01
; CHECK-NEXT:    ret float [[REG117]]
;
  %reg115 = fadd reassoc float %reg109, -3.000000e+01
  %reg116 = fadd reassoc float %reg115, %reg1111
  %reg117 = fadd reassoc float %reg116, 3.000000e+01
  ret float %reg117
}

; (x1 * 47) + (x2 * -47) => (x1 - x2) * 47

define float @test13(float %X1, float %X2) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub fast float [[X1:%.*]], [[X2:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast float [[TMP1]], 4.700000e+01
; CHECK-NEXT:    ret float [[TMP2]]
;
  %B = fmul fast float %X1, 47.   ; X1*47
  %C = fmul fast float %X2, -47.  ; X2*-47
  %D = fadd fast float %B, %C     ; X1*47 + X2*-47 -> 47*(X1-X2)
  ret float %D
}

; Check again with 'reassoc' and 'nsz' ('nsz' not technically required).
define float @test13_reassoc_nsz(float %X1, float %X2) {
; CHECK-LABEL: @test13_reassoc_nsz(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc nsz float [[X1:%.*]], [[X2:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], 4.700000e+01
; CHECK-NEXT:    ret float [[TMP2]]
;
  %B = fmul reassoc nsz float %X1, 47.   ; X1*47
  %C = fmul reassoc nsz float %X2, -47.  ; X2*-47
  %D = fadd reassoc nsz float %B, %C     ; X1*47 + X2*-47 -> 47*(X1-X2)
  ret float %D
}

; TODO: This doesn't require 'nsz'.  It should fold to ((x1 - x2) * 47.0)
define float @test13_reassoc(float %X1, float %X2) {
; CHECK-LABEL: @test13_reassoc(
; CHECK-NEXT:    [[B:%.*]] = fmul reassoc float [[X1:%.*]], 4.700000e+01
; CHECK-NEXT:    [[C:%.*]] = fmul reassoc float [[X2:%.*]], 4.700000e+01
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc float [[B]], [[C]]
; CHECK-NEXT:    ret float [[TMP1]]
;
  %B = fmul reassoc float %X1, 47.   ; X1*47
  %C = fmul reassoc float %X2, -47.  ; X2*-47
  %D = fadd reassoc float %B, %C     ; X1*47 + X2*-47 -> 47*(X1-X2)
  ret float %D
}

; (b+(a+1234))+-a -> b+1234

define float @test15(float %b, float %a) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd fast float [[B:%.*]], 1.234000e+03
; CHECK-NEXT:    ret float [[TMP1]]
;
  %1 = fadd fast float %a, 1234.0
  %2 = fadd fast float %b, %1
  %3 = fsub fast float 0.0, %a
  %4 = fadd fast float %2, %3
  ret float %4
}

define float @test15_unary_fneg(float %b, float %a) {
; CHECK-LABEL: @test15_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd fast float [[B:%.*]], 1.234000e+03
; CHECK-NEXT:    ret float [[TMP1]]
;
  %1 = fadd fast float %a, 1234.0
  %2 = fadd fast float %b, %1
  %3 = fneg fast float %a
  %4 = fadd fast float %2, %3
  ret float %4
}

define float @test15_reassoc_nsz(float %b, float %a) {
; CHECK-LABEL: @test15_reassoc_nsz(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[B:%.*]], 1.234000e+03
; CHECK-NEXT:    ret float [[TMP1]]
;
  %1 = fadd reassoc nsz float %a, 1234.0
  %2 = fadd reassoc nsz float %b, %1
  %3 = fsub reassoc nsz float 0.0, %a
  %4 = fadd reassoc nsz float %2, %3
  ret float %4
}

define float @test15_reassoc(float %b, float %a) {
; CHECK-LABEL: @test15_reassoc(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc float [[A:%.*]], 1.234000e+03
; CHECK-NEXT:    [[TMP2:%.*]] = fadd reassoc float [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = fsub reassoc float 0.000000e+00, [[A]]
; CHECK-NEXT:    [[TMP4:%.*]] = fadd reassoc float [[TMP3]], [[TMP2]]
; CHECK-NEXT:    ret float [[TMP4]]
;
  %1 = fadd reassoc float %a, 1234.0
  %2 = fadd reassoc float %b, %1
  %3 = fsub reassoc float 0.0, %a
  %4 = fadd reassoc float %2, %3
  ret float %4
}

; Test that we can turn things like X*-(Y*Z) -> X*-1*Y*Z.

define float @test16(float %a, float %b, float %z) {
; REASSOC_AND_IC-LABEL: @test16(
; REASSOC_AND_IC-NEXT:    [[C:%.*]] = fmul fast float [[A:%.*]], 1.234500e+04
; REASSOC_AND_IC-NEXT:    [[E:%.*]] = fmul fast float [[C]], [[B:%.*]]
; REASSOC_AND_IC-NEXT:    [[F:%.*]] = fmul fast float [[E]], [[Z:%.*]]
; REASSOC_AND_IC-NEXT:    ret float [[F]]
;
; O2-LABEL: @test16(
; O2-NEXT:    [[D:%.*]] = fmul fast float [[A:%.*]], 1.234500e+04
; O2-NEXT:    [[E:%.*]] = fmul fast float [[D]], [[B:%.*]]
; O2-NEXT:    [[G:%.*]] = fmul fast float [[E]], [[Z:%.*]]
; O2-NEXT:    ret float [[G]]
;
  %c = fsub fast float 0.000000e+00, %z
  %d = fmul fast float %a, %b
  %e = fmul fast float %c, %d
  %f = fmul fast float %e, 1.234500e+04
  %g = fsub fast float 0.000000e+00, %f
  ret float %g
}

define float @test16_unary_fneg(float %a, float %b, float %z) {
; REASSOC_AND_IC-LABEL: @test16_unary_fneg(
; REASSOC_AND_IC-NEXT:    [[E:%.*]] = fmul fast float [[A:%.*]], 1.234500e+04
; REASSOC_AND_IC-NEXT:    [[F:%.*]] = fmul fast float [[E]], [[B:%.*]]
; REASSOC_AND_IC-NEXT:    [[G:%.*]] = fmul fast float [[F]], [[Z:%.*]]
; REASSOC_AND_IC-NEXT:    ret float [[G]]
;
; O2-LABEL: @test16_unary_fneg(
; O2-NEXT:    [[D:%.*]] = fmul fast float [[A:%.*]], 1.234500e+04
; O2-NEXT:    [[E:%.*]] = fmul fast float [[D]], [[B:%.*]]
; O2-NEXT:    [[G:%.*]] = fmul fast float [[E]], [[Z:%.*]]
; O2-NEXT:    ret float [[G]]
;
  %c = fneg fast float %z
  %d = fmul fast float %a, %b
  %e = fmul fast float %c, %d
  %f = fmul fast float %e, 1.234500e+04
  %g = fneg fast float %f
  ret float %g
}

define float @test16_reassoc_nsz(float %a, float %b, float %z) {
; REASSOC_AND_IC-LABEL: @test16_reassoc_nsz(
; REASSOC_AND_IC-NEXT:    [[C:%.*]] = fmul reassoc nsz float [[A:%.*]], 1.234500e+04
; REASSOC_AND_IC-NEXT:    [[E:%.*]] = fmul reassoc nsz float [[C]], [[B:%.*]]
; REASSOC_AND_IC-NEXT:    [[F:%.*]] = fmul reassoc nsz float [[E]], [[Z:%.*]]
; REASSOC_AND_IC-NEXT:    ret float [[F]]
;
; O2-LABEL: @test16_reassoc_nsz(
; O2-NEXT:    [[D:%.*]] = fmul reassoc nsz float [[A:%.*]], 1.234500e+04
; O2-NEXT:    [[E:%.*]] = fmul reassoc nsz float [[D]], [[B:%.*]]
; O2-NEXT:    [[G:%.*]] = fmul reassoc nsz float [[E]], [[Z:%.*]]
; O2-NEXT:    ret float [[G]]
;
  %c = fsub reassoc nsz float 0.000000e+00, %z
  %d = fmul reassoc nsz float %a, %b
  %e = fmul reassoc nsz float %c, %d
  %f = fmul reassoc nsz float %e, 1.234500e+04
  %g = fsub reassoc nsz float 0.000000e+00, %f
  ret float %g
}

define float @test16_reassoc(float %a, float %b, float %z) {
; CHECK-LABEL: @test16_reassoc(
; CHECK-NEXT:    [[C:%.*]] = fsub reassoc float 0.000000e+00, [[Z:%.*]]
; CHECK-NEXT:    [[D:%.*]] = fmul reassoc float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[E:%.*]] = fmul reassoc float [[D]], [[C]]
; CHECK-NEXT:    [[F:%.*]] = fmul reassoc float [[E]], 1.234500e+04
; CHECK-NEXT:    [[G:%.*]] = fsub reassoc float 0.000000e+00, [[F]]
; CHECK-NEXT:    ret float [[G]]
;
  %c = fsub reassoc float 0.000000e+00, %z
  %d = fmul reassoc float %a, %b
  %e = fmul reassoc float %c, %d
  %f = fmul reassoc float %e, 1.234500e+04
  %g = fsub reassoc float 0.000000e+00, %f
  ret float %g
}

; With sub reassociation, constant folding can eliminate the 12 and -12 constants.

define float @test18(float %A, float %B) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[Z:%.*]] = fsub fast float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret float [[Z]]
;
  %X = fadd fast float -1.200000e+01, %A
  %Y = fsub fast float %X, %B
  %Z = fadd fast float %Y, 1.200000e+01
  ret float %Z
}

define float @test18_reassoc(float %A, float %B) {
; CHECK-LABEL: @test18_reassoc(
; CHECK-NEXT:    [[X:%.*]] = fadd reassoc float [[A:%.*]], -1.200000e+01
; CHECK-NEXT:    [[Y:%.*]] = fsub reassoc float [[X]], [[B:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = fadd reassoc float [[Y]], 1.200000e+01
; CHECK-NEXT:    ret float [[Z]]
;
  %X = fadd reassoc float -1.200000e+01, %A
  %Y = fsub reassoc float %X, %B
  %Z = fadd reassoc float %Y, 1.200000e+01
  ret float %Z
}

; test18 - check that the bug described in the revision does not appear:
; https://reviews.llvm.org/D72521

; With sub reassociation, constant folding can eliminate the uses of %a.

define float @test19(float %a, float %b, float %c) nounwind  {
; REASSOC_AND_IC-LABEL: @test19(
; REASSOC_AND_IC-NEXT:    [[TMP1:%.*]] = fadd fast float [[B:%.*]], [[C:%.*]]
; REASSOC_AND_IC-NEXT:    [[T7:%.*]] = fneg fast float [[TMP1]]
; REASSOC_AND_IC-NEXT:    ret float [[T7]]
;
; O2-LABEL: @test19(
; O2-NEXT:    [[TMP1:%.*]] = fadd fast float [[C:%.*]], [[B:%.*]]
; O2-NEXT:    [[T7:%.*]] = fneg fast float [[TMP1]]
; O2-NEXT:    ret float [[T7]]
;
  %t3 = fsub fast float %a, %b
  %t5 = fsub fast float %t3, %c
  %t7 = fsub fast float %t5, %a
  ret float %t7
}

define float @test19_reassoc_nsz(float %a, float %b, float %c) nounwind  {
; CHECK-LABEL: @test19_reassoc_nsz(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[C:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T7:%.*]] = fneg reassoc nsz float [[TMP1]]
; CHECK-NEXT:    ret float [[T7]]
;
  %t3 = fsub reassoc nsz float %a, %b
  %t5 = fsub reassoc nsz float %t3, %c
  %t7 = fsub reassoc nsz float %t5, %a
  ret float %t7
}

; Verify the fold is not done with only 'reassoc' ('nsz' is required).
define float @test19_reassoc(float %a, float %b, float %c) nounwind  {
; CHECK-LABEL: @test19_reassoc(
; CHECK-NEXT:    [[T3:%.*]] = fsub reassoc float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T5:%.*]] = fsub reassoc float [[T3]], [[C:%.*]]
; CHECK-NEXT:    [[T7:%.*]] = fsub reassoc float [[T5]], [[A]]
; CHECK-NEXT:    ret float [[T7]]
;
  %t3 = fsub reassoc float %a, %b
  %t5 = fsub reassoc float %t3, %c
  %t7 = fsub reassoc float %t5, %a
  ret float %t7
}
