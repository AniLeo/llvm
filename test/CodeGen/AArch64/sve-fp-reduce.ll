; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve -asm-verbose=0 < %s | FileCheck %s

; FADD

define half @fadda_nxv2f16(half %init, <vscale x 2 x half> %a) {
; CHECK-LABEL: fadda_nxv2f16:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fadda h0, p0, h0, z1.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fadd.nxv2f16(half %init, <vscale x 2 x half> %a)
  ret half %res
}

define half @fadda_nxv4f16(half %init, <vscale x 4 x half> %a) {
; CHECK-LABEL: fadda_nxv4f16:
; CHECK:      ptrue p0.s
; CHECK-NEXT: fadda h0, p0, h0, z1.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fadd.nxv4f16(half %init, <vscale x 4 x half> %a)
  ret half %res
}

define half @fadda_nxv8f16(half %init, <vscale x 8 x half> %a) {
; CHECK-LABEL: fadda_nxv8f16:
; CHECK:      ptrue p0.h
; CHECK-NEXT: fadda h0, p0, h0, z1.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fadd.nxv8f16(half %init, <vscale x 8 x half> %a)
  ret half %res
}

define half @fadda_nxv6f16(<vscale x 6 x half> %v, half %s) {
; CHECK-LABEL: fadda_nxv6f16:
; CHECK:      str x29, [sp, #-16]!
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset w29, -16
; CHECK-NEXT: addvl sp, sp, #-1
; CHECK-NEXT: .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22
; CHECK-NEXT: adrp x8, .LCPI3_0
; CHECK-NEXT: add x8, x8, :lo12:.LCPI3_0
; CHECK-NEXT: ptrue p0.h
; CHECK-NEXT: ptrue p1.d
; CHECK-NEXT: st1h { z0.h }, p0, [sp]
; CHECK-NEXT: ld1rh { z0.d }, p1/z, [x8]
; CHECK-NEXT: st1h { z0.d }, p1, [sp, #3, mul vl]
; CHECK-NEXT: fmov s0, s1
; CHECK-NEXT: ld1h { z2.h }, p0/z, [sp]
; CHECK-NEXT: fadda h0, p0, h0, z2.h
; CHECK-NEXT: addvl sp, sp, #1
; CHECK-NEXT: ldr x29, [sp], #16
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fadd.nxv6f16(half %s, <vscale x 6 x half> %v)
  ret half %res
}

define half @fadda_nxv10f16(<vscale x 10 x half> %v, half %s) {
; CHECK-LABEL: fadda_nxv10f16:
; CHECK:      str x29, [sp, #-16]!
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset w29, -16
; CHECK-NEXT: addvl sp, sp, #-3
; CHECK-NEXT: .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x18, 0x92, 0x2e, 0x00, 0x1e, 0x22
; CHECK-NEXT: adrp x8, .LCPI4_0
; CHECK-NEXT: add x8, x8, :lo12:.LCPI4_0
; CHECK-NEXT: ptrue p0.h
; CHECK-NEXT: ptrue p1.d
; CHECK-NEXT: st1h { z1.h }, p0, [sp]
; CHECK-NEXT: ld1rh { z1.d }, p1/z, [x8]
; CHECK-NEXT: addvl x8, sp, #1
; CHECK-NEXT: fadda h2, p0, h2, z0.h
; CHECK-NEXT: st1h { z1.d }, p1, [sp, #1, mul vl]
; CHECK-NEXT: ld1h { z3.h }, p0/z, [sp]
; CHECK-NEXT: st1h { z3.h }, p0, [sp, #1, mul vl]
; CHECK-NEXT: st1h { z1.d }, p1, [sp, #6, mul vl]
; CHECK-NEXT: ld1h { z3.h }, p0/z, [sp, #1, mul vl]
; CHECK-NEXT: st1h { z3.h }, p0, [sp, #2, mul vl]
; CHECK-NEXT: st1h { z1.d }, p1, [x8, #7, mul vl]
; CHECK-NEXT: ld1h { z1.h }, p0/z, [sp, #2, mul vl]
; CHECK-NEXT: fadda h2, p0, h2, z1.h
; CHECK-NEXT: fmov s0, s2
; CHECK-NEXT: addvl sp, sp, #3
; CHECK-NEXT: ldr x29, [sp], #16
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fadd.nxv10f16(half %s, <vscale x 10 x half> %v)
  ret half %res
}

define half @fadda_nxv12f16(<vscale x 12 x half> %v, half %s) {
; CHECK-LABEL: fadda_nxv12f16:
; CHECK:      adrp x8, .LCPI5_0
; CHECK-NEXT: add x8, x8, :lo12:.LCPI5_0
; CHECK-NEXT: ptrue p0.s
; CHECK-NEXT: uunpklo z1.s, z1.h
; CHECK-NEXT: ld1rh { z3.s }, p0/z, [x8]
; CHECK-NEXT: ptrue p0.h
; CHECK-NEXT: fadda h2, p0, h2, z0.h
; CHECK-NEXT: uzp1 z1.h, z1.h, z3.h
; CHECK-NEXT: fadda h2, p0, h2, z1.h
; CHECK-NEXT: fmov s0, s2
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fadd.nxv12f16(half %s, <vscale x 12 x half> %v)
  ret half %res
}

define float @fadda_nxv2f32(float %init, <vscale x 2 x float> %a) {
; CHECK-LABEL: fadda_nxv2f32:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fadda s0, p0, s0, z1.s
; CHECK-NEXT: ret
  %res = call float @llvm.vector.reduce.fadd.nxv2f32(float %init, <vscale x 2 x float> %a)
  ret float %res
}

define float @fadda_nxv4f32(float %init, <vscale x 4 x float> %a) {
; CHECK-LABEL: fadda_nxv4f32:
; CHECK:      ptrue p0.s
; CHECK-NEXT: fadda s0, p0, s0, z1.s
; CHECK-NEXT: ret
  %res = call float @llvm.vector.reduce.fadd.nxv4f32(float %init, <vscale x 4 x float> %a)
  ret float %res
}

define double @fadda_nxv2f64(double %init, <vscale x 2 x double> %a) {
; CHECK-LABEL: fadda_nxv2f64:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fadda d0, p0, d0, z1.d
; CHECK-NEXT: ret
  %res = call double @llvm.vector.reduce.fadd.nxv2f64(double %init, <vscale x 2 x double> %a)
  ret double %res
}

; FADDV

define half @faddv_nxv2f16(half %init, <vscale x 2 x half> %a) {
; CHECK-LABEL: faddv_nxv2f16:
; CHECK:      ptrue p0.d
; CHECK-NEXT: faddv h1, p0, z1.h
; CHECK-NEXT: fadd h0, h0, h1
; CHECK-NEXT: ret
  %res = call fast half @llvm.vector.reduce.fadd.nxv2f16(half %init, <vscale x 2 x half> %a)
  ret half %res
}

define half @faddv_nxv4f16(half %init, <vscale x 4 x half> %a) {
; CHECK-LABEL: faddv_nxv4f16:
; CHECK:      ptrue p0.s
; CHECK-NEXT: faddv h1, p0, z1.h
; CHECK-NEXT: fadd h0, h0, h1
; CHECK-NEXT: ret
  %res = call fast half @llvm.vector.reduce.fadd.nxv4f16(half %init, <vscale x 4 x half> %a)
  ret half %res
}

define half @faddv_nxv8f16(half %init, <vscale x 8 x half> %a) {
; CHECK-LABEL: faddv_nxv8f16:
; CHECK:      ptrue p0.h
; CHECK-NEXT: faddv h1, p0, z1.h
; CHECK-NEXT: fadd h0, h0, h1
; CHECK-NEXT: ret
  %res = call fast half @llvm.vector.reduce.fadd.nxv8f16(half %init, <vscale x 8 x half> %a)
  ret half %res
}

define float @faddv_nxv2f32(float %init, <vscale x 2 x float> %a) {
; CHECK-LABEL: faddv_nxv2f32:
; CHECK:      ptrue p0.d
; CHECK-NEXT: faddv s1, p0, z1.s
; CHECK-NEXT: fadd s0, s0, s1
; CHECK-NEXT: ret
  %res = call fast float @llvm.vector.reduce.fadd.nxv2f32(float %init, <vscale x 2 x float> %a)
  ret float %res
}

define float @faddv_nxv4f32(float %init, <vscale x 4 x float> %a) {
; CHECK-LABEL: faddv_nxv4f32:
; CHECK:      ptrue p0.s
; CHECK-NEXT: faddv s1, p0, z1.s
; CHECK-NEXT: fadd s0, s0, s1
; CHECK-NEXT: ret
  %res = call fast float @llvm.vector.reduce.fadd.nxv4f32(float %init, <vscale x 4 x float> %a)
  ret float %res
}

define double @faddv_nxv2f64(double %init, <vscale x 2 x double> %a) {
; CHECK-LABEL: faddv_nxv2f64:
; CHECK:      ptrue p0.d
; CHECK-NEXT: faddv d1, p0, z1.d
; CHECK-NEXT: fadd d0, d0, d1
; CHECK-NEXT: ret
  %res = call fast double @llvm.vector.reduce.fadd.nxv2f64(double %init, <vscale x 2 x double> %a)
  ret double %res
}

; FMAXV

define half @fmaxv_nxv2f16(<vscale x 2 x half> %a) {
; CHECK-LABEL: fmaxv_nxv2f16:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fmaxnmv h0, p0, z0.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fmax.nxv2f16(<vscale x 2 x half> %a)
  ret half %res
}

define half @fmaxv_nxv4f16(<vscale x 4 x half> %a) {
; CHECK-LABEL: fmaxv_nxv4f16:
; CHECK:      ptrue p0.s
; CHECK-NEXT: fmaxnmv h0, p0, z0.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fmax.nxv4f16(<vscale x 4 x half> %a)
  ret half %res
}

define half @fmaxv_nxv8f16(<vscale x 8 x half> %a) {
; CHECK-LABEL: fmaxv_nxv8f16:
; CHECK:      ptrue p0.h
; CHECK-NEXT: fmaxnmv h0, p0, z0.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fmax.nxv8f16(<vscale x 8 x half> %a)
  ret half %res
}

define float @fmaxv_nxv2f32(<vscale x 2 x float> %a) {
; CHECK-LABEL: fmaxv_nxv2f32:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fmaxnmv s0, p0, z0.s
; CHECK-NEXT: ret
  %res = call float @llvm.vector.reduce.fmax.nxv2f32(<vscale x 2 x float> %a)
  ret float %res
}

define float @fmaxv_nxv4f32(<vscale x 4 x float> %a) {
; CHECK-LABEL: fmaxv_nxv4f32:
; CHECK:      ptrue p0.s
; CHECK-NEXT: fmaxnmv s0, p0, z0.s
; CHECK-NEXT: ret
  %res = call float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float> %a)
  ret float %res
}

define double @fmaxv_nxv2f64(<vscale x 2 x double> %a) {
; CHECK-LABEL: fmaxv_nxv2f64:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fmaxnmv d0, p0, z0.d
; CHECK-NEXT: ret
  %res = call double @llvm.vector.reduce.fmax.nxv2f64(<vscale x 2 x double> %a)
  ret double %res
}

; FMINV

define half @fminv_nxv2f16(<vscale x 2 x half> %a) {
; CHECK-LABEL: fminv_nxv2f16:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fminnmv h0, p0, z0.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fmin.nxv2f16(<vscale x 2 x half> %a)
  ret half %res
}

define half @fminv_nxv4f16(<vscale x 4 x half> %a) {
; CHECK-LABEL: fminv_nxv4f16:
; CHECK:      ptrue p0.s
; CHECK-NEXT: fminnmv h0, p0, z0.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fmin.nxv4f16(<vscale x 4 x half> %a)
  ret half %res
}

define half @fminv_nxv8f16(<vscale x 8 x half> %a) {
; CHECK-LABEL: fminv_nxv8f16:
; CHECK:      ptrue p0.h
; CHECK-NEXT: fminnmv h0, p0, z0.h
; CHECK-NEXT: ret
  %res = call half @llvm.vector.reduce.fmin.nxv8f16(<vscale x 8 x half> %a)
  ret half %res
}

define float @fminv_nxv2f32(<vscale x 2 x float> %a) {
; CHECK-LABEL: fminv_nxv2f32:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fminnmv s0, p0, z0.s
; CHECK-NEXT: ret
  %res = call float @llvm.vector.reduce.fmin.nxv2f32(<vscale x 2 x float> %a)
  ret float %res
}

define float @fminv_nxv4f32(<vscale x 4 x float> %a) {
; CHECK-LABEL: fminv_nxv4f32:
; CHECK:      ptrue p0.s
; CHECK-NEXT: fminnmv s0, p0, z0.s
; CHECK-NEXT: ret
  %res = call float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float> %a)
  ret float %res
}

define double @fminv_nxv2f64(<vscale x 2 x double> %a) {
; CHECK-LABEL: fminv_nxv2f64:
; CHECK:      ptrue p0.d
; CHECK-NEXT: fminnmv d0, p0, z0.d
; CHECK-NEXT: ret
  %res = call double @llvm.vector.reduce.fmin.nxv2f64(<vscale x 2 x double> %a)
  ret double %res
}

declare half @llvm.vector.reduce.fadd.nxv2f16(half, <vscale x 2 x half>)
declare half @llvm.vector.reduce.fadd.nxv4f16(half, <vscale x 4 x half>)
declare half @llvm.vector.reduce.fadd.nxv8f16(half, <vscale x 8 x half>)
declare half @llvm.vector.reduce.fadd.nxv6f16(half, <vscale x 6 x half>)
declare half @llvm.vector.reduce.fadd.nxv10f16(half, <vscale x 10 x half>)
declare half @llvm.vector.reduce.fadd.nxv12f16(half, <vscale x 12 x half>)
declare float @llvm.vector.reduce.fadd.nxv2f32(float, <vscale x 2 x float>)
declare float @llvm.vector.reduce.fadd.nxv4f32(float, <vscale x 4 x float>)
declare double @llvm.vector.reduce.fadd.nxv2f64(double, <vscale x 2 x double>)

declare half @llvm.vector.reduce.fmax.nxv2f16(<vscale x 2 x half>)
declare half @llvm.vector.reduce.fmax.nxv4f16(<vscale x 4 x half>)
declare half @llvm.vector.reduce.fmax.nxv8f16(<vscale x 8 x half>)
declare float @llvm.vector.reduce.fmax.nxv2f32(<vscale x 2 x float>)
declare float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float>)
declare double @llvm.vector.reduce.fmax.nxv2f64(<vscale x 2 x double>)

declare half @llvm.vector.reduce.fmin.nxv2f16(<vscale x 2 x half>)
declare half @llvm.vector.reduce.fmin.nxv4f16(<vscale x 4 x half>)
declare half @llvm.vector.reduce.fmin.nxv8f16(<vscale x 8 x half>)
declare float @llvm.vector.reduce.fmin.nxv2f32(<vscale x 2 x float>)
declare float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float>)
declare double @llvm.vector.reduce.fmin.nxv2f64(<vscale x 2 x double>)
