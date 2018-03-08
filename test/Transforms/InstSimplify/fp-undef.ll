; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define float @fadd_undef_op0(float %x) {
; CHECK-LABEL: @fadd_undef_op0(
; CHECK-NEXT:    [[R:%.*]] = fadd float undef, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fadd float undef, %x
  ret float %r
}

define float @fadd_undef_op1(float %x) {
; CHECK-LABEL: @fadd_undef_op1(
; CHECK-NEXT:    [[R:%.*]] = fadd float [[X:%.*]], undef
; CHECK-NEXT:    ret float [[R]]
;
  %r = fadd float %x, undef
  ret float %r
}

define float @fsub_undef_op0(float %x) {
; CHECK-LABEL: @fsub_undef_op0(
; CHECK-NEXT:    [[R:%.*]] = fsub float undef, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub float undef, %x
  ret float %r
}

define float @fsub_undef_op1(float %x) {
; CHECK-LABEL: @fsub_undef_op1(
; CHECK-NEXT:    [[R:%.*]] = fsub float [[X:%.*]], undef
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub float %x, undef
  ret float %r
}

define float @fmul_undef_op0(float %x) {
; CHECK-LABEL: @fmul_undef_op0(
; CHECK-NEXT:    [[R:%.*]] = fmul float undef, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fmul float undef, %x
  ret float %r
}

define float @fmul_undef_op1(float %x) {
; CHECK-LABEL: @fmul_undef_op1(
; CHECK-NEXT:    [[R:%.*]] = fmul float [[X:%.*]], undef
; CHECK-NEXT:    ret float [[R]]
;
  %r = fmul float %x, undef
  ret float %r
}

define float @fdiv_undef_op0(float %x) {
; CHECK-LABEL: @fdiv_undef_op0(
; CHECK-NEXT:    ret float undef
;
  %r = fdiv float undef, %x
  ret float %r
}

define float @fdiv_undef_op1(float %x) {
; CHECK-LABEL: @fdiv_undef_op1(
; CHECK-NEXT:    ret float undef
;
  %r = fdiv float %x, undef
  ret float %r
}

define float @frem_undef_op0(float %x) {
; CHECK-LABEL: @frem_undef_op0(
; CHECK-NEXT:    ret float undef
;
  %r = frem float undef, %x
  ret float %r
}

define float @frem_undef_op1(float %x) {
; CHECK-LABEL: @frem_undef_op1(
; CHECK-NEXT:    ret float undef
;
  %r = frem float %x, undef
  ret float %r
}

; Repeat all tests with fast-math-flags. Alternate 'nnan' and 'fast' for more coverage.

define float @fadd_undef_op0_nnan(float %x) {
; CHECK-LABEL: @fadd_undef_op0_nnan(
; CHECK-NEXT:    [[R:%.*]] = fadd nnan float undef, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fadd nnan float undef, %x
  ret float %r
}

define float @fadd_undef_op1_fast(float %x) {
; CHECK-LABEL: @fadd_undef_op1_fast(
; CHECK-NEXT:    [[R:%.*]] = fadd fast float [[X:%.*]], undef
; CHECK-NEXT:    ret float [[R]]
;
  %r = fadd fast float %x, undef
  ret float %r
}

define float @fsub_undef_op0_fast(float %x) {
; CHECK-LABEL: @fsub_undef_op0_fast(
; CHECK-NEXT:    [[R:%.*]] = fsub fast float undef, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub fast float undef, %x
  ret float %r
}

define float @fsub_undef_op1_nnan(float %x) {
; CHECK-LABEL: @fsub_undef_op1_nnan(
; CHECK-NEXT:    [[R:%.*]] = fsub nnan float [[X:%.*]], undef
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub nnan float %x, undef
  ret float %r
}

define float @fmul_undef_op0_nnan(float %x) {
; CHECK-LABEL: @fmul_undef_op0_nnan(
; CHECK-NEXT:    [[R:%.*]] = fmul nnan float undef, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fmul nnan float undef, %x
  ret float %r
}

define float @fmul_undef_op1_fast(float %x) {
; CHECK-LABEL: @fmul_undef_op1_fast(
; CHECK-NEXT:    [[R:%.*]] = fmul fast float [[X:%.*]], undef
; CHECK-NEXT:    ret float [[R]]
;
  %r = fmul fast float %x, undef
  ret float %r
}

define float @fdiv_undef_op0_fast(float %x) {
; CHECK-LABEL: @fdiv_undef_op0_fast(
; CHECK-NEXT:    ret float undef
;
  %r = fdiv fast float undef, %x
  ret float %r
}

define float @fdiv_undef_op1_nnan(float %x) {
; CHECK-LABEL: @fdiv_undef_op1_nnan(
; CHECK-NEXT:    ret float undef
;
  %r = fdiv nnan float %x, undef
  ret float %r
}

define float @frem_undef_op0_nnan(float %x) {
; CHECK-LABEL: @frem_undef_op0_nnan(
; CHECK-NEXT:    ret float undef
;
  %r = frem nnan float undef, %x
  ret float %r
}

define float @frem_undef_op1_fast(float %x) {
; CHECK-LABEL: @frem_undef_op1_fast(
; CHECK-NEXT:    ret float undef
;
  %r = frem fast float %x, undef
  ret float %r
}

; Constant folding - undef undef.

define double @fadd_undef_undef(double %x) {
; CHECK-LABEL: @fadd_undef_undef(
; CHECK-NEXT:    ret double fadd (double undef, double undef)
;
  %r = fadd double undef, undef
  ret double %r
}

define double @fsub_undef_undef(double %x) {
; CHECK-LABEL: @fsub_undef_undef(
; CHECK-NEXT:    ret double fsub (double undef, double undef)
;
  %r = fsub double undef, undef
  ret double %r
}

define double @fmul_undef_undef(double %x) {
; CHECK-LABEL: @fmul_undef_undef(
; CHECK-NEXT:    ret double fmul (double undef, double undef)
;
  %r = fmul double undef, undef
  ret double %r
}

define double @fdiv_undef_undef(double %x) {
; CHECK-LABEL: @fdiv_undef_undef(
; CHECK-NEXT:    ret double fdiv (double undef, double undef)
;
  %r = fdiv double undef, undef
  ret double %r
}

define double @frem_undef_undef(double %x) {
; CHECK-LABEL: @frem_undef_undef(
; CHECK-NEXT:    ret double frem (double undef, double undef)
;
  %r = frem double undef, undef
  ret double %r
}

; Constant folding.

define float @fadd_undef_op0_nnan_constant(float %x) {
; CHECK-LABEL: @fadd_undef_op0_nnan_constant(
; CHECK-NEXT:    ret float fadd (float undef, float 1.000000e+00)
;
  %r = fadd nnan float undef, 1.0
  ret float %r
}

define float @fadd_undef_op1_constant(float %x) {
; CHECK-LABEL: @fadd_undef_op1_constant(
; CHECK-NEXT:    ret float fadd (float 2.000000e+00, float undef)
;
  %r = fadd float 2.0, undef
  ret float %r
}

define float @fsub_undef_op0_fast_constant(float %x) {
; CHECK-LABEL: @fsub_undef_op0_fast_constant(
; CHECK-NEXT:    ret float fsub (float undef, float 3.000000e+00)
;
  %r = fsub fast float undef, 3.0
  ret float %r
}

define float @fsub_undef_op1_constant(float %x) {
; CHECK-LABEL: @fsub_undef_op1_constant(
; CHECK-NEXT:    ret float fsub (float 4.000000e+00, float undef)
;
  %r = fsub float 4.0, undef
  ret float %r
}

define float @fmul_undef_op0_nnan_constant(float %x) {
; CHECK-LABEL: @fmul_undef_op0_nnan_constant(
; CHECK-NEXT:    ret float fmul (float undef, float 5.000000e+00)
;
  %r = fmul nnan float undef, 5.0
  ret float %r
}

define float @fmul_undef_op1_constant(float %x) {
; CHECK-LABEL: @fmul_undef_op1_constant(
; CHECK-NEXT:    ret float fmul (float 6.000000e+00, float undef)
;
  %r = fmul float 6.0, undef
  ret float %r
}

define float @fdiv_undef_op0_fast_constant(float %x) {
; CHECK-LABEL: @fdiv_undef_op0_fast_constant(
; CHECK-NEXT:    ret float fdiv (float undef, float 7.000000e+00)
;
  %r = fdiv fast float undef, 7.0
  ret float %r
}

define float @fdiv_undef_op1_constant(float %x) {
; CHECK-LABEL: @fdiv_undef_op1_constant(
; CHECK-NEXT:    ret float fdiv (float 8.000000e+00, float undef)
;
  %r = fdiv float 8.0, undef
  ret float %r
}

define float @frem_undef_op0_nnan_constant(float %x) {
; CHECK-LABEL: @frem_undef_op0_nnan_constant(
; CHECK-NEXT:    ret float frem (float undef, float 9.000000e+00)
;
  %r = frem nnan float undef, 9.0
  ret float %r
}

define float @frem_undef_op1_constant(float %x) {
; CHECK-LABEL: @frem_undef_op1_constant(
; CHECK-NEXT:    ret float frem (float 1.000000e+01, float undef)
;
  %r = frem float 10.0, undef
  ret float %r
}

; Constant folding - special constants: NaN.

define double @fadd_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fadd_undef_op0_constant_nan(
; CHECK-NEXT:    ret double fadd (double undef, double 0x7FF8000000000000)
;
  %r = fadd double undef, 0x7FF8000000000000
  ret double %r
}

define double @fadd_undef_op1_fast_constant_nan(double %x) {
; CHECK-LABEL: @fadd_undef_op1_fast_constant_nan(
; CHECK-NEXT:    ret double fadd (double 0xFFF0000000000001, double undef)
;
  %r = fadd fast double 0xFFF0000000000001, undef
  ret double %r
}

define double @fsub_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fsub_undef_op0_constant_nan(
; CHECK-NEXT:    ret double fsub (double undef, double 0xFFF8000000000010)
;
  %r = fsub double undef, 0xFFF8000000000010
  ret double %r
}

define double @fsub_undef_op1_nnan_constant_nan(double %x) {
; CHECK-LABEL: @fsub_undef_op1_nnan_constant_nan(
; CHECK-NEXT:    ret double fsub (double 0x7FF0000000000011, double undef)
;
  %r = fsub nnan double 0x7FF0000000000011, undef
  ret double %r
}

define double @fmul_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fmul_undef_op0_constant_nan(
; CHECK-NEXT:    ret double fmul (double undef, double 0x7FF8000000000100)
;
  %r = fmul double undef, 0x7FF8000000000100
  ret double %r
}

define double @fmul_undef_op1_fast_constant_nan(double %x) {
; CHECK-LABEL: @fmul_undef_op1_fast_constant_nan(
; CHECK-NEXT:    ret double fmul (double 0xFFF0000000000101, double undef)
;
  %r = fmul fast double 0xFFF0000000000101, undef
  ret double %r
}

define double @fdiv_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fdiv_undef_op0_constant_nan(
; CHECK-NEXT:    ret double fdiv (double undef, double 0xFFF8000000000110)
;
  %r = fdiv double undef, 0xFFF8000000000110
  ret double %r
}

define double @fdiv_undef_op1_nnan_constant_nan(double %x) {
; CHECK-LABEL: @fdiv_undef_op1_nnan_constant_nan(
; CHECK-NEXT:    ret double fdiv (double 0x7FF0000000000111, double undef)
;
  %r = fdiv nnan double 0x7FF0000000000111, undef
  ret double %r
}

define double @frem_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @frem_undef_op0_constant_nan(
; CHECK-NEXT:    ret double frem (double undef, double 0x7FF8000000001000)
;
  %r = frem double undef, 0x7FF8000000001000
  ret double %r
}

define double @frem_undef_op1_fast_constant_nan(double %x) {
; CHECK-LABEL: @frem_undef_op1_fast_constant_nan(
; CHECK-NEXT:    ret double frem (double 0xFFF0000000001001, double undef)
;
  %r = frem fast double 0xFFF0000000001001, undef
  ret double %r
}

; Constant folding - special constants: Inf.

define double @fadd_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fadd_undef_op0_constant_inf(
; CHECK-NEXT:    ret double fadd (double undef, double 0x7FF0000000000000)
;
  %r = fadd double undef, 0x7FF0000000000000
  ret double %r
}

define double @fadd_undef_op1_fast_constant_inf(double %x) {
; CHECK-LABEL: @fadd_undef_op1_fast_constant_inf(
; CHECK-NEXT:    ret double fadd (double 0xFFF0000000000000, double undef)
;
  %r = fadd fast double 0xFFF0000000000000, undef
  ret double %r
}

define double @fsub_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fsub_undef_op0_constant_inf(
; CHECK-NEXT:    ret double fsub (double undef, double 0xFFF8000000000000)
;
  %r = fsub double undef, 0xFFF8000000000000
  ret double %r
}

define double @fsub_undef_op1_ninf_constant_inf(double %x) {
; CHECK-LABEL: @fsub_undef_op1_ninf_constant_inf(
; CHECK-NEXT:    ret double fsub (double 0x7FF0000000000000, double undef)
;
  %r = fsub ninf double 0x7FF0000000000000, undef
  ret double %r
}

define double @fmul_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fmul_undef_op0_constant_inf(
; CHECK-NEXT:    ret double fmul (double undef, double 0x7FF8000000000000)
;
  %r = fmul double undef, 0x7FF8000000000000
  ret double %r
}

define double @fmul_undef_op1_fast_constant_inf(double %x) {
; CHECK-LABEL: @fmul_undef_op1_fast_constant_inf(
; CHECK-NEXT:    ret double fmul (double 0xFFF0000000000000, double undef)
;
  %r = fmul fast double 0xFFF0000000000000, undef
  ret double %r
}

define double @fdiv_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fdiv_undef_op0_constant_inf(
; CHECK-NEXT:    ret double fdiv (double undef, double 0xFFF8000000000000)
;
  %r = fdiv double undef, 0xFFF8000000000000
  ret double %r
}

define double @fdiv_undef_op1_ninf_constant_inf(double %x) {
; CHECK-LABEL: @fdiv_undef_op1_ninf_constant_inf(
; CHECK-NEXT:    ret double fdiv (double 0x7FF0000000000000, double undef)
;
  %r = fdiv ninf double 0x7FF0000000000000, undef
  ret double %r
}

define double @frem_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @frem_undef_op0_constant_inf(
; CHECK-NEXT:    ret double frem (double undef, double 0x7FF8000000000000)
;
  %r = frem double undef, 0x7FF8000000000000
  ret double %r
}

define double @frem_undef_op1_fast_constant_inf(double %x) {
; CHECK-LABEL: @frem_undef_op1_fast_constant_inf(
; CHECK-NEXT:    ret double frem (double 0xFFF0000000000000, double undef)
;
  %r = frem fast double 0xFFF0000000000000, undef
  ret double %r
}

