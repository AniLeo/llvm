; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

; FP_EXTEND

define <vscale x 8 x float> @fcvts_nxv8f16(<vscale x 8 x half> %a) {
; CHECK-LABEL: fcvts_nxv8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z1.s, z0.h
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    uunpkhi z2.s, z0.h
; CHECK-NEXT:    fcvt z0.s, p0/m, z1.h
; CHECK-NEXT:    fcvt z1.s, p0/m, z2.h
; CHECK-NEXT:    ret
  %res = fpext <vscale x 8 x half> %a to <vscale x 8 x float>
  ret <vscale x 8 x float> %res
}

define <vscale x 4 x double> @fcvtd_nxv4f16(<vscale x 4 x half> %a) {
; CHECK-LABEL: fcvtd_nxv4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uunpkhi z2.d, z0.s
; CHECK-NEXT:    fcvt z0.d, p0/m, z1.h
; CHECK-NEXT:    fcvt z1.d, p0/m, z2.h
; CHECK-NEXT:    ret
  %res = fpext <vscale x 4 x half> %a to <vscale x 4 x double>
  ret <vscale x 4 x double> %res
}

define <vscale x 8 x double> @fcvtd_nxv8f16(<vscale x 8 x half> %a) {
; CHECK-LABEL: fcvtd_nxv8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z1.s, z0.h
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uunpklo z2.d, z1.s
; CHECK-NEXT:    uunpkhi z1.d, z1.s
; CHECK-NEXT:    uunpklo z3.d, z0.s
; CHECK-NEXT:    uunpkhi z4.d, z0.s
; CHECK-NEXT:    fcvt z0.d, p0/m, z2.h
; CHECK-NEXT:    fcvt z1.d, p0/m, z1.h
; CHECK-NEXT:    fcvt z2.d, p0/m, z3.h
; CHECK-NEXT:    fcvt z3.d, p0/m, z4.h
; CHECK-NEXT:    ret
  %res = fpext <vscale x 8 x half> %a to <vscale x 8 x double>
  ret <vscale x 8 x double> %res
}

define <vscale x 4 x double> @fcvtd_nxv4f32(<vscale x 4 x float> %a) {
; CHECK-LABEL: fcvtd_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uunpkhi z2.d, z0.s
; CHECK-NEXT:    fcvt z0.d, p0/m, z1.s
; CHECK-NEXT:    fcvt z1.d, p0/m, z2.s
; CHECK-NEXT:    ret
  %res = fpext <vscale x 4 x float> %a to <vscale x 4 x double>
  ret <vscale x 4 x double> %res
}

define <vscale x 8 x double> @fcvtd_nxv8f32(<vscale x 8 x float> %a) {
; CHECK-LABEL: fcvtd_nxv8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z2.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uunpkhi z3.d, z0.s
; CHECK-NEXT:    uunpklo z4.d, z1.s
; CHECK-NEXT:    uunpkhi z5.d, z1.s
; CHECK-NEXT:    fcvt z0.d, p0/m, z2.s
; CHECK-NEXT:    fcvt z1.d, p0/m, z3.s
; CHECK-NEXT:    fcvt z2.d, p0/m, z4.s
; CHECK-NEXT:    fcvt z3.d, p0/m, z5.s
; CHECK-NEXT:    ret
  %res = fpext <vscale x 8 x float> %a to <vscale x 8 x double>
  ret <vscale x 8 x double> %res
}

; FP_ROUND

define <vscale x 8 x half> @fcvth_nxv8f32(<vscale x 8 x float> %a) {
; CHECK-LABEL: fcvth_nxv8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    fcvt z1.h, p0/m, z1.s
; CHECK-NEXT:    fcvt z0.h, p0/m, z0.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z1.h
; CHECK-NEXT:    ret
  %res = fptrunc <vscale x 8 x float> %a to <vscale x 8 x half>
  ret <vscale x 8 x half> %res
}

define <vscale x 8 x half> @fcvth_nxv8f64(<vscale x 8 x double> %a) {
; CHECK-LABEL: fcvth_nxv8f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcvt z3.h, p0/m, z3.d
; CHECK-NEXT:    fcvt z2.h, p0/m, z2.d
; CHECK-NEXT:    fcvt z1.h, p0/m, z1.d
; CHECK-NEXT:    fcvt z0.h, p0/m, z0.d
; CHECK-NEXT:    uzp1 z2.s, z2.s, z3.s
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %res = fptrunc <vscale x 8 x double> %a to <vscale x 8 x half>
  ret <vscale x 8 x half> %res
}

define <vscale x 4 x half> @fcvth_nxv4f64(<vscale x 4 x double> %a) {
; CHECK-LABEL: fcvth_nxv4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcvt z1.h, p0/m, z1.d
; CHECK-NEXT:    fcvt z0.h, p0/m, z0.d
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    ret
  %res = fptrunc <vscale x 4 x double> %a to <vscale x 4 x half>
  ret <vscale x 4 x half> %res
}

define <vscale x 4 x float> @fcvts_nxv4f64(<vscale x 4 x double> %a) {
; CHECK-LABEL: fcvts_nxv4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcvt z1.s, p0/m, z1.d
; CHECK-NEXT:    fcvt z0.s, p0/m, z0.d
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    ret
  %res = fptrunc <vscale x 4 x double> %a to <vscale x 4 x float>
  ret <vscale x 4 x float> %res
}

define <vscale x 8 x float> @fcvts_nxv8f64(<vscale x 8 x double> %a) {
; CHECK-LABEL: fcvts_nxv8f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcvt z1.s, p0/m, z1.d
; CHECK-NEXT:    fcvt z0.s, p0/m, z0.d
; CHECK-NEXT:    fcvt z3.s, p0/m, z3.d
; CHECK-NEXT:    fcvt z2.s, p0/m, z2.d
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    uzp1 z1.s, z2.s, z3.s
; CHECK-NEXT:    ret
  %res = fptrunc <vscale x 8 x double> %a to <vscale x 8 x float>
  ret <vscale x 8 x float> %res
}

; FP_TO_SINT

; Split operand
define <vscale x 4 x i32> @fcvtzs_s_nxv4f64(<vscale x 4 x double> %a) {
; CHECK-LABEL: fcvtzs_s_nxv4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcvtzs z1.d, p0/m, z1.d
; CHECK-NEXT:    fcvtzs z0.d, p0/m, z0.d
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    ret
  %res = fptosi <vscale x 4 x double> %a to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %res
}

define <vscale x 8 x i16> @fcvtzs_h_nxv8f64(<vscale x 8 x double> %a) {
; CHECK-LABEL: fcvtzs_h_nxv8f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcvtzs z3.d, p0/m, z3.d
; CHECK-NEXT:    fcvtzs z2.d, p0/m, z2.d
; CHECK-NEXT:    fcvtzs z1.d, p0/m, z1.d
; CHECK-NEXT:    fcvtzs z0.d, p0/m, z0.d
; CHECK-NEXT:    uzp1 z2.s, z2.s, z3.s
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %res = fptosi <vscale x 8 x double> %a to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %res
}

; Split result
define <vscale x 4 x i64> @fcvtzs_d_nxv4f32(<vscale x 4 x float> %a) {
; CHECK-LABEL: fcvtzs_d_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uunpkhi z2.d, z0.s
; CHECK-NEXT:    fcvtzs z0.d, p0/m, z1.s
; CHECK-NEXT:    fcvtzs z1.d, p0/m, z2.s
; CHECK-NEXT:    ret
  %res = fptosi <vscale x 4 x float> %a to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %res
}

define <vscale x 16 x i32> @fcvtzs_s_nxv16f16(<vscale x 16 x half> %a) {
; CHECK-LABEL: fcvtzs_s_nxv16f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z2.s, z0.h
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    uunpkhi z3.s, z0.h
; CHECK-NEXT:    uunpklo z4.s, z1.h
; CHECK-NEXT:    uunpkhi z5.s, z1.h
; CHECK-NEXT:    fcvtzs z0.s, p0/m, z2.h
; CHECK-NEXT:    fcvtzs z1.s, p0/m, z3.h
; CHECK-NEXT:    fcvtzs z2.s, p0/m, z4.h
; CHECK-NEXT:    fcvtzs z3.s, p0/m, z5.h
; CHECK-NEXT:    ret
  %res = fptosi <vscale x 16 x half> %a to <vscale x 16 x i32>
  ret <vscale x 16 x i32> %res
}

; FP_TO_UINT

; Split operand
define <vscale x 4 x i32> @fcvtzu_s_nxv4f64(<vscale x 4 x double> %a) {
; CHECK-LABEL: fcvtzu_s_nxv4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fcvtzs z1.d, p0/m, z1.d
; CHECK-NEXT:    fcvtzs z0.d, p0/m, z0.d
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    ret
  %res = fptoui <vscale x 4 x double> %a to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %res
}

; Split result
define <vscale x 4 x i64> @fcvtzu_d_nxv4f32(<vscale x 4 x float> %a) {
; CHECK-LABEL: fcvtzu_d_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uunpkhi z2.d, z0.s
; CHECK-NEXT:    fcvtzu z0.d, p0/m, z1.s
; CHECK-NEXT:    fcvtzu z1.d, p0/m, z2.s
; CHECK-NEXT:    ret
  %res = fptoui <vscale x 4 x float> %a to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %res
}

; SINT_TO_FP

; Split operand
define <vscale x 4 x float> @scvtf_s_nxv4i64(<vscale x 4 x i64> %a) {
; CHECK-LABEL: scvtf_s_nxv4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    scvtf z1.s, p0/m, z1.d
; CHECK-NEXT:    scvtf z0.s, p0/m, z0.d
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    ret
  %res = sitofp <vscale x 4 x i64> %a to <vscale x 4 x float>
  ret <vscale x 4 x float> %res
}

define <vscale x 8 x half> @scvtf_h_nxv8i64(<vscale x 8 x i64> %a) {
; CHECK-LABEL: scvtf_h_nxv8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    scvtf z3.h, p0/m, z3.d
; CHECK-NEXT:    scvtf z2.h, p0/m, z2.d
; CHECK-NEXT:    scvtf z1.h, p0/m, z1.d
; CHECK-NEXT:    scvtf z0.h, p0/m, z0.d
; CHECK-NEXT:    uzp1 z2.s, z2.s, z3.s
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %res = sitofp <vscale x 8 x i64> %a to <vscale x 8 x half>
  ret <vscale x 8 x half> %res
}

; Split result
define <vscale x 16 x float> @scvtf_s_nxv16i8(<vscale x 16 x i8> %a) {
; CHECK-LABEL: scvtf_s_nxv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpklo z1.h, z0.b
; CHECK-NEXT:    sunpkhi z0.h, z0.b
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sunpklo z2.s, z1.h
; CHECK-NEXT:    sunpkhi z1.s, z1.h
; CHECK-NEXT:    sunpklo z3.s, z0.h
; CHECK-NEXT:    sunpkhi z4.s, z0.h
; CHECK-NEXT:    scvtf z0.s, p0/m, z2.s
; CHECK-NEXT:    scvtf z1.s, p0/m, z1.s
; CHECK-NEXT:    scvtf z2.s, p0/m, z3.s
; CHECK-NEXT:    scvtf z3.s, p0/m, z4.s
; CHECK-NEXT:    ret
  %res = sitofp <vscale x 16 x i8> %a to <vscale x 16 x float>
  ret <vscale x 16 x float> %res
}

define <vscale x 4 x double> @scvtf_d_nxv4i32(<vscale x 4 x i32> %a) {
; CHECK-LABEL: scvtf_d_nxv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpklo z1.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sunpkhi z2.d, z0.s
; CHECK-NEXT:    scvtf z0.d, p0/m, z1.d
; CHECK-NEXT:    scvtf z1.d, p0/m, z2.d
; CHECK-NEXT:    ret
  %res = sitofp <vscale x 4 x i32> %a to <vscale x 4 x double>
  ret <vscale x 4 x double> %res
}

define <vscale x 4 x double> @scvtf_d_nxv4i1(<vscale x 4 x i1> %a) {
; CHECK-LABEL: scvtf_d_nxv4i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p1.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ptrue p2.d
; CHECK-NEXT:    mov z0.d, p1/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    mov z1.d, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    scvtf z0.d, p2/m, z0.d
; CHECK-NEXT:    scvtf z1.d, p2/m, z1.d
; CHECK-NEXT:    ret
  %res = sitofp <vscale x 4 x i1> %a to <vscale x 4 x double>
  ret <vscale x 4 x double> %res
}

; UINT_TO_FP

; Split operand
define <vscale x 4 x float> @ucvtf_s_nxv4i64(<vscale x 4 x i64> %a) {
; CHECK-LABEL: ucvtf_s_nxv4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ucvtf z1.s, p0/m, z1.d
; CHECK-NEXT:    ucvtf z0.s, p0/m, z0.d
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    ret
  %res = uitofp <vscale x 4 x i64> %a to <vscale x 4 x float>
  ret <vscale x 4 x float> %res
}

define <vscale x 8 x half> @ucvtf_h_nxv8i64(<vscale x 8 x i64> %a) {
; CHECK-LABEL: ucvtf_h_nxv8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ucvtf z3.h, p0/m, z3.d
; CHECK-NEXT:    ucvtf z2.h, p0/m, z2.d
; CHECK-NEXT:    ucvtf z1.h, p0/m, z1.d
; CHECK-NEXT:    ucvtf z0.h, p0/m, z0.d
; CHECK-NEXT:    uzp1 z2.s, z2.s, z3.s
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %res = uitofp <vscale x 8 x i64> %a to <vscale x 8 x half>
  ret <vscale x 8 x half> %res
}

; Split result
define <vscale x 4 x double> @ucvtf_d_nxv4i32(<vscale x 4 x i32> %a) {
; CHECK-LABEL: ucvtf_d_nxv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uunpkhi z2.d, z0.s
; CHECK-NEXT:    ucvtf z0.d, p0/m, z1.d
; CHECK-NEXT:    ucvtf z1.d, p0/m, z2.d
; CHECK-NEXT:    ret
  %res = uitofp <vscale x 4 x i32> %a to <vscale x 4 x double>
  ret <vscale x 4 x double> %res
}

define <vscale x 4 x double> @ucvtf_d_nxv4i1(<vscale x 4 x i1> %a) {
; CHECK-LABEL: ucvtf_d_nxv4i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p1.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ptrue p2.d
; CHECK-NEXT:    mov z0.d, p1/z, #1 // =0x1
; CHECK-NEXT:    mov z1.d, p0/z, #1 // =0x1
; CHECK-NEXT:    ucvtf z0.d, p2/m, z0.d
; CHECK-NEXT:    ucvtf z1.d, p2/m, z1.d
; CHECK-NEXT:    ret
  %res = uitofp <vscale x 4 x i1> %a to <vscale x 4 x double>
  ret <vscale x 4 x double> %res
}
