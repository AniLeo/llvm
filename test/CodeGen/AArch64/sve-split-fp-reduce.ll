; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

; FADD

define double @fadda_nxv8f64(double %init, <vscale x 8 x double> %a) {
; CHECK-LABEL: fadda_nxv8f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fadda d0, p0, d0, z1.d
; CHECK-NEXT:    fadda d0, p0, d0, z2.d
; CHECK-NEXT:    fadda d0, p0, d0, z3.d
; CHECK-NEXT:    fadda d0, p0, d0, z4.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call double @llvm.vector.reduce.fadd.nxv8f64(double %init, <vscale x 8 x double> %a)
  ret double %res
}

; FADDV

define float @faddv_nxv8f32(float %init, <vscale x 8 x float> %a) {
; CHECK-LABEL: faddv_nxv8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fadd z1.s, z1.s, z2.s
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    faddv s1, p0, z1.s
; CHECK-NEXT:    fadd s0, s0, s1
; CHECK-NEXT:    ret
  %res = call fast float @llvm.vector.reduce.fadd.nxv8f32(float %init, <vscale x 8 x float> %a)
  ret float %res
}

; FMAXV

define double @fmaxv_nxv8f64(<vscale x 8 x double> %a) {
; CHECK-LABEL: fmaxv_nxv8f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fmaxnm z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    fmaxnm z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    fmaxnm z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    fmaxnmv d0, p0, z0.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call double @llvm.vector.reduce.fmax.nxv8f64(<vscale x 8 x double> %a)
  ret double %res
}

; FMINV

define half @fminv_nxv16f16(<vscale x 16 x half> %a) {
; CHECK-LABEL: fminv_nxv16f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    fminnm z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    fminnmv h0, p0, z0.h
; CHECK-NEXT:    // kill: def $h0 killed $h0 killed $z0
; CHECK-NEXT:    ret
  %res = call half @llvm.vector.reduce.fmin.nxv16f16(<vscale x 16 x half> %a)
  ret half %res
}

declare double @llvm.vector.reduce.fadd.nxv8f64(double, <vscale x 8 x double>)
declare float @llvm.vector.reduce.fadd.nxv8f32(float, <vscale x 8 x float>)

declare double @llvm.vector.reduce.fmax.nxv8f64(<vscale x 8 x double>)

declare half @llvm.vector.reduce.fmin.nxv16f16(<vscale x 16 x half>)
