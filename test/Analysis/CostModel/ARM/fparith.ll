; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -cost-model -analyze -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve < %s | FileCheck %s --check-prefix=CHECK-MVE
; RUN: opt -cost-model -analyze -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve.fp < %s | FileCheck %s --check-prefix=CHECK-MVEFP

define void @f32() {
; CHECK-MVE-LABEL: 'f32'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = fadd float undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = fsub float undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fmul float undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-MVEFP-LABEL: 'f32'
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = fadd float undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = fsub float undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fmul float undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %c = fadd float undef, undef
  %d = fsub float undef, undef
  %e = fmul float undef, undef
  ret void
}

define void @f16() {
; CHECK-MVE-LABEL: 'f16'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = fadd half undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = fsub half undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fmul half undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-MVEFP-LABEL: 'f16'
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = fadd half undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = fsub half undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fmul half undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %c = fadd half undef, undef
  %d = fsub half undef, undef
  %e = fmul half undef, undef
  ret void
}

define void @f64() {
; CHECK-MVE-LABEL: 'f64'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = fadd double undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = fsub double undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fmul double undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-MVEFP-LABEL: 'f64'
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = fadd double undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = fsub double undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fmul double undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %c = fadd double undef, undef
  %d = fsub double undef, undef
  %e = fmul double undef, undef
  ret void
}

define void @vf32() {
; CHECK-MVE-LABEL: 'vf32'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %c2 = fadd <2 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %d2 = fsub <2 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %e2 = fmul <2 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %c4 = fadd <4 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %d4 = fsub <4 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %e4 = fmul <4 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %c8 = fadd <8 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %d8 = fsub <8 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %e8 = fmul <8 x float> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-MVEFP-LABEL: 'vf32'
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %c2 = fadd <2 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %d2 = fsub <2 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %e2 = fmul <2 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %c4 = fadd <4 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %d4 = fsub <4 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %e4 = fmul <4 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %c8 = fadd <8 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %d8 = fsub <8 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %e8 = fmul <8 x float> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %c2 = fadd <2 x float> undef, undef
  %d2 = fsub <2 x float> undef, undef
  %e2 = fmul <2 x float> undef, undef
  %c4 = fadd <4 x float> undef, undef
  %d4 = fsub <4 x float> undef, undef
  %e4 = fmul <4 x float> undef, undef
  %c8 = fadd <8 x float> undef, undef
  %d8 = fsub <8 x float> undef, undef
  %e8 = fmul <8 x float> undef, undef
  ret void
}

define void @vf16() {
; CHECK-MVE-LABEL: 'vf16'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %c2 = fadd <2 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %d2 = fsub <2 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %e2 = fmul <2 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %c4 = fadd <4 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %d4 = fsub <4 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %e4 = fmul <4 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %c8 = fadd <8 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %d8 = fsub <8 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %e8 = fmul <8 x half> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-MVEFP-LABEL: 'vf16'
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %c2 = fadd <2 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %d2 = fsub <2 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %e2 = fmul <2 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %c4 = fadd <4 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %d4 = fsub <4 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %e4 = fmul <4 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %c8 = fadd <8 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %d8 = fsub <8 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %e8 = fmul <8 x half> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %c2 = fadd <2 x half> undef, undef
  %d2 = fsub <2 x half> undef, undef
  %e2 = fmul <2 x half> undef, undef
  %c4 = fadd <4 x half> undef, undef
  %d4 = fsub <4 x half> undef, undef
  %e4 = fmul <4 x half> undef, undef
  %c8 = fadd <8 x half> undef, undef
  %d8 = fsub <8 x half> undef, undef
  %e8 = fmul <8 x half> undef, undef
  ret void
}

define void @vf64() {
; CHECK-MVE-LABEL: 'vf64'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %c2 = fadd <2 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %d2 = fsub <2 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %e2 = fmul <2 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %c4 = fadd <4 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %d4 = fsub <4 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %e4 = fmul <4 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %c8 = fadd <8 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %d8 = fsub <8 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %e8 = fmul <8 x double> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-MVEFP-LABEL: 'vf64'
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %c2 = fadd <2 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %d2 = fsub <2 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %e2 = fmul <2 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %c4 = fadd <4 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %d4 = fsub <4 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %e4 = fmul <4 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %c8 = fadd <8 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %d8 = fsub <8 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %e8 = fmul <8 x double> undef, undef
; CHECK-MVEFP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %c2 = fadd <2 x double> undef, undef
  %d2 = fsub <2 x double> undef, undef
  %e2 = fmul <2 x double> undef, undef
  %c4 = fadd <4 x double> undef, undef
  %d4 = fsub <4 x double> undef, undef
  %e4 = fmul <4 x double> undef, undef
  %c8 = fadd <8 x double> undef, undef
  %d8 = fsub <8 x double> undef, undef
  %e8 = fmul <8 x double> undef, undef
  ret void
}

