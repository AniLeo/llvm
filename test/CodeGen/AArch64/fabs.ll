; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-unknown | FileCheck %s

; Test against PR36600: https://bugs.llvm.org/show_bug.cgi?id=36600
; This is not fabs. If X = -0.0, it should return -0.0 not 0.0.

define double @not_fabs(double %x) #0 {
; CHECK-LABEL: not_fabs:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fneg d1, d0
; CHECK-NEXT:    fcmp d0, #0.0
; CHECK-NEXT:    fcsel d0, d1, d0, le
; CHECK-NEXT:    ret
  %cmp = fcmp nnan ole double %x, 0.0
  %sub = fsub nnan double -0.0, %x
  %cond = select i1 %cmp, double %sub, double %x
  ret double %cond
}

; Try again with different type, predicate, and compare constant.

define float @still_not_fabs(float %x) #0 {
; CHECK-LABEL: still_not_fabs:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI1_0
; CHECK-NEXT:    ldr s1, [x8, :lo12:.LCPI1_0]
; CHECK-NEXT:    fneg s2, s0
; CHECK-NEXT:    fcmp s0, s1
; CHECK-NEXT:    fcsel s0, s0, s2, ge
; CHECK-NEXT:    ret
  %cmp = fcmp nnan oge float %x, -0.0
  %sub = fsub nnan float -0.0, %x
  %cond = select i1 %cmp, float %x, float %sub
  ret float %cond
}

define float @nabsf(float %a) {
; CHECK-LABEL: nabsf:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    orr w8, w8, #0x80000000
; CHECK-NEXT:    fmov s0, w8
; CHECK-NEXT:    ret
  %conv = bitcast float %a to i32
  %and = or i32 %conv, -2147483648
  %conv1 = bitcast i32 %and to float
  ret float %conv1
}

define double @nabsd(double %a) {
; CHECK-LABEL: nabsd:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    orr x8, x8, #0x8000000000000000
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %conv = bitcast double %a to i64
  %and = or i64 %conv, -9223372036854775808
  %conv1 = bitcast i64 %and to double
  ret double %conv1
}

define <4 x float> @nabsv4f32(<4 x float> %a) {
; CHECK-LABEL: nabsv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr v0.4s, #128, lsl #24
; CHECK-NEXT:    ret
  %conv = bitcast <4 x float> %a to <4 x i32>
  %and = or <4 x i32> %conv, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %conv1 = bitcast <4 x i32> %and to <4 x float>
  ret <4 x float> %conv1
}

define <2 x double> @nabsv2d64(<2 x double> %a) {
; CHECK-LABEL: nabsv2d64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr x8, xzr, #0x8000000000000000
; CHECK-NEXT:    dup v1.2d, x8
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %conv = bitcast <2 x double> %a to <2 x i64>
  %and = or <2 x i64> %conv, <i64 -9223372036854775808, i64 -9223372036854775808>
  %conv1 = bitcast <2 x i64> %and to <2 x double>
  ret <2 x double> %conv1
}

attributes #0 = { "no-nans-fp-math"="true" }

