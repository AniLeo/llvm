; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

; Overflow on a float to int or int to float conversion is undefined (PR21130).

define i8 @overflow_fptosi() {
; CHECK-LABEL: @overflow_fptosi(
; CHECK-NEXT:    ret i8 poison
;
  %i = fptosi double 1.56e+02 to i8
  ret i8 %i
}

define i8 @overflow_fptoui() {
; CHECK-LABEL: @overflow_fptoui(
; CHECK-NEXT:    ret i8 poison
;
  %i = fptoui double 2.56e+02 to i8
  ret i8 %i
}

; The maximum float is approximately 2 ** 128 which is 3.4E38.
; The constant below is 4E38. Use a 130 bit integer to hold that
; number; 129-bits for the value + 1 bit for the sign.

define float @overflow_uitofp() {
; CHECK-LABEL: @overflow_uitofp(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %i = uitofp i130 400000000000000000000000000000000000000 to float
  ret float %i
}

define float @overflow_sitofp() {
; CHECK-LABEL: @overflow_sitofp(
; CHECK-NEXT:    ret float 0x7FF0000000000000
;
  %i = sitofp i130 400000000000000000000000000000000000000 to float
  ret float %i
}

; https://llvm.org/PR43907 - make sure that NaN doesn't morph into Inf.
; SNaN becomes QNaN.

define float @nan_f64_trunc() {
; CHECK-LABEL: @nan_f64_trunc(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %f = fptrunc double 0x7FF0000000000001 to float
  ret float %f
}

; Verify again with a vector and different destination type.
; SNaN becomes SNaN (first two elements).
; QNaN remains QNaN (third element).
; Lower 42 bits of NaN source payload are lost.

define <3 x half> @nan_v3f64_trunc() {
; CHECK-LABEL: @nan_v3f64_trunc(
; CHECK-NEXT:    ret <3 x half> <half 0xH7E00, half 0xH7E00, half 0xH7E00>
;
  %f = fptrunc <3 x double> <double 0x7FF0020000000000, double 0x7FF003FFFFFFFFFF, double 0x7FF8000000000001> to <3 x half>
  ret <3 x half> %f
}

define bfloat @nan_bf16_trunc() {
; CHECK-LABEL: @nan_bf16_trunc(
; CHECK-NEXT:    ret bfloat 0xR7FC0
;
  %f = fptrunc double 0x7FF0000000000001 to bfloat
  ret bfloat %f
}

define float @trunc_denorm_lost_fraction0() {
; CHECK-LABEL: @trunc_denorm_lost_fraction0(
; CHECK-NEXT:    ret float 0.000000e+00
;
  %b = fptrunc double 0x0000000010000000 to float
  ret float %b
}

; FIXME: This should be 0.0.

define float @trunc_denorm_lost_fraction1() {
; CHECK-LABEL: @trunc_denorm_lost_fraction1(
; CHECK-NEXT:    ret float 0x36A0000000000000
;
  %b = fptrunc double 0x0000000010000001 to float
  ret float %b
}

; FIXME: This should be 0.0.

define float @trunc_denorm_lost_fraction2() {
; CHECK-LABEL: @trunc_denorm_lost_fraction2(
; CHECK-NEXT:    ret float 0x36A0000000000000
;
  %b = fptrunc double 0x000000001fffffff to float
  ret float %b
}

define float @trunc_denorm_lost_fraction3() {
; CHECK-LABEL: @trunc_denorm_lost_fraction3(
; CHECK-NEXT:    ret float 0.000000e+00
;
  %b = fptrunc double 0x0000000020000000 to float
  ret float %b
}

; FIXME: This should be -0.0.

define float @trunc_denorm_lost_fraction4() {
; CHECK-LABEL: @trunc_denorm_lost_fraction4(
; CHECK-NEXT:    ret float 0xB6A0000000000000
;
  %b = fptrunc double 0x8000000010000001 to float
  ret float %b
}
