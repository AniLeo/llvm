; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

; X == 42.0 ? X : 42.0 --> 42.0

define double @oeq(double %x) {
; CHECK-LABEL: @oeq(
; CHECK-NEXT:    ret double 4.200000e+01
;
  %cmp = fcmp oeq double %x, 42.0
  %cond = select i1 %cmp, double %x, double 42.0
  ret double %cond
}

; X == 42.0 ? 42.0 : X --> X

define float @oeq_swapped(float %x) {
; CHECK-LABEL: @oeq_swapped(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %cmp = fcmp oeq float %x, 42.0
  %cond = select i1 %cmp, float 42.0, float %x
  ret float %cond
}

; x != y ? x : y -> x if it's the right kind of != and at least
; one of x and y is not negative zero.

; X != 42.0 ? X : 42.0 --> X

define double @une(double %x) {
; CHECK-LABEL: @une(
; CHECK-NEXT:    ret double [[X:%.*]]
;
  %cmp = fcmp une double %x, 42.0
  %cond = select i1 %cmp, double %x, double 42.0
  ret double %cond
}

; X != 42.0 ? 42.0 : X --> 42.0

define double @une_swapped(double %x) {
; CHECK-LABEL: @une_swapped(
; CHECK-NEXT:    ret double 4.200000e+01
;
  %cmp = fcmp une double %x, 42.0
  %cond = select i1 %cmp, double 42.0, double %x
  ret double %cond
}

; X == 0.0 ? X : 0.0 --> ? (X could be -0.0)

define double @oeq_zero(double %x) {
; CHECK-LABEL: @oeq_zero(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oeq double [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], double [[X]], double 0.000000e+00
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp oeq double %x, 0.0
  %cond = select i1 %cmp, double %x, double 0.0
  ret double %cond
}

; X == 0.0 ? 0.0 : X --> ? (change sign if X is -0.0)

define float @oeq_zero_swapped(float %x) {
; CHECK-LABEL: @oeq_zero_swapped(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], float 0.000000e+00, float [[X]]
; CHECK-NEXT:    ret float [[COND]]
;
  %cmp = fcmp oeq float %x, 0.0
  %cond = select i1 %cmp, float 0.0, float %x
  ret float %cond
}

; X != 0.0 ? X : -0.0 --> ? (change sign if X is 0.0)

define double @une_zero(double %x) {
; CHECK-LABEL: @une_zero(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une double [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], double [[X]], double -0.000000e+00
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp une double %x, 0.0
  %cond = select i1 %cmp, double %x, double -0.0
  ret double %cond
}

; X != 0.0 ? -0.0 : X --> ? (X could be 0.0)

define double @une_zero_swapped(double %x) {
; CHECK-LABEL: @une_zero_swapped(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une double [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], double -0.000000e+00, double [[X]]
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp une double %x, 0.0
  %cond = select i1 %cmp, double -0.0, double %x
  ret double %cond
}

; X == 0.0 ? X : 0.0 --> 0.0

define double @oeq_zero_nsz(double %x) {
; CHECK-LABEL: @oeq_zero_nsz(
; CHECK-NEXT:    ret double 0.000000e+00
;
  %cmp = fcmp oeq double %x, 0.0
  %cond = select nsz i1 %cmp, double %x, double 0.0
  ret double %cond
}

; X == 0.0 ? 0.0 : X --> X

define float @oeq_zero_swapped_nsz(float %x) {
; CHECK-LABEL: @oeq_zero_swapped_nsz(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %cmp = fcmp oeq float %x, 0.0
  %cond = select fast i1 %cmp, float 0.0, float %x
  ret float %cond
}

; X != 0.0 ? X : 0.0 --> X

define double @une_zero_nsz(double %x) {
; CHECK-LABEL: @une_zero_nsz(
; CHECK-NEXT:    ret double [[X:%.*]]
;
  %cmp = fcmp une double %x, 0.0
  %cond = select nsz ninf i1 %cmp, double %x, double 0.0
  ret double %cond
}

; X != 0.0 ? 0.0 : X --> 0.0

define <2 x double> @une_zero_swapped_nsz(<2 x double> %x) {
; CHECK-LABEL: @une_zero_swapped_nsz(
; CHECK-NEXT:    ret <2 x double> zeroinitializer
;
  %cmp = fcmp une <2 x double> %x, <double 0.0, double 0.0>
  %cond = select nsz <2 x i1> %cmp, <2 x double> <double 0.0, double 0.0>, <2 x double> %x
  ret <2 x double> %cond
}

; X == Y ? X : Y --> Y

define double @oeq_nsz(double %x, double %y) {
; CHECK-LABEL: @oeq_nsz(
; CHECK-NEXT:    ret double [[Y:%.*]]
;
  %cmp = fcmp oeq double %x, %y
  %cond = select fast i1 %cmp, double %x, double %y
  ret double %cond
}

; X == Y ? Y : X --> X

define <2 x float> @oeq_swapped_nsz(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @oeq_swapped_nsz(
; CHECK-NEXT:    ret <2 x float> [[X:%.*]]
;
  %cmp = fcmp oeq <2 x float> %x, %y
  %cond = select nsz nnan <2 x i1> %cmp, <2 x float> %y, <2 x float> %x
  ret <2 x float> %cond
}

; X != Y ? X : Y --> X

define double @une_nsz(double %x, double %y) {
; CHECK-LABEL: @une_nsz(
; CHECK-NEXT:    ret double [[X:%.*]]
;
  %cmp = fcmp une double %x, %y
  %cond = select nsz i1 %cmp, double %x, double %y
  ret double %cond
}

; X != Y ? Y : X --> Y

define <2 x double> @une_swapped_nsz(<2 x double> %x, <2 x double> %y) {
; CHECK-LABEL: @une_swapped_nsz(
; CHECK-NEXT:    ret <2 x double> [[Y:%.*]]
;
  %cmp = fcmp une <2 x double> %x, %y
  %cond = select fast <2 x i1> %cmp, <2 x double> %y, <2 x double> %x
  ret <2 x double> %cond
}

; Harder - mismatched zero constants (not typical due to canonicalization):
; X != 0.0 ? X : -0.0 --> X

define double @une_zero_mismatch_nsz(double %x) {
; CHECK-LABEL: @une_zero_mismatch_nsz(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une double [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[COND:%.*]] = select ninf nsz i1 [[CMP]], double [[X]], double -0.000000e+00
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp une double %x, 0.0
  %cond = select nsz ninf i1 %cmp, double %x, double -0.0
  ret double %cond
}

; Even harder - mismatched vector zero constants (not typical due to canonicalization):
; X != 0.0 ? -0.0 : X --> 0.0

define <2 x double> @une_zero_mismatch_swapped_nsz(<2 x double> %x) {
; CHECK-LABEL: @une_zero_mismatch_swapped_nsz(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une <2 x double> [[X:%.*]], <double -0.000000e+00, double 0.000000e+00>
; CHECK-NEXT:    [[COND:%.*]] = select nsz <2 x i1> [[CMP]], <2 x double> <double 0.000000e+00, double -0.000000e+00>, <2 x double> [[X]]
; CHECK-NEXT:    ret <2 x double> [[COND]]
;
  %cmp = fcmp une <2 x double> %x, <double -0.0, double 0.0>
  %cond = select nsz <2 x i1> %cmp, <2 x double> <double 0.0, double -0.0>, <2 x double> %x
  ret <2 x double> %cond
}

define double @une_could_be_negzero(double %x, double %y) {
; CHECK-LABEL: @une_could_be_negzero(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], double [[X]], double [[Y]]
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp une double %x, %y
  %cond = select i1 %cmp, double %x, double %y
  ret double %cond
}

define double @une_swapped_could_be_negzero(double %x, double %y) {
; CHECK-LABEL: @une_swapped_could_be_negzero(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], double [[Y]], double [[X]]
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp une double %x, %y
  %cond = select i1 %cmp, double %y, double %x
  ret double %cond
}

define double @one(double %x) {
; CHECK-LABEL: @one(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp one double [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], double [[X]], double -1.000000e+00
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp one double %x, -1.0
  %cond = select i1 %cmp, double %x, double -1.0
  ret double %cond
}

define double @one_swapped(double %x) {
; CHECK-LABEL: @one_swapped(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp one double [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], double -1.000000e+00, double [[X]]
; CHECK-NEXT:    ret double [[COND]]
;
  %cmp = fcmp one double %x, -1.0
  %cond = select i1 %cmp, double -1.0, double %x
  ret double %cond
}

