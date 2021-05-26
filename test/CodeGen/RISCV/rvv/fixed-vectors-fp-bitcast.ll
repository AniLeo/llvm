; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh,+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 < %s | FileCheck %s --check-prefixes=CHECK,RV32-FP
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh,+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 < %s | FileCheck %s --check-prefixes=CHECK,RV64-FP

define i16 @bitcast_v1f16_i16(<1 x half> %a) {
; CHECK-LABEL: bitcast_v1f16_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %b = bitcast <1 x half> %a to i16
  ret i16 %b
}

define half @bitcast_v1f16_f16(<1 x half> %a) {
; CHECK-LABEL: bitcast_v1f16_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vfmv.f.s ft0, v8
; CHECK-NEXT:    fmv.x.h a0, ft0
; CHECK-NEXT:    ret
  %b = bitcast <1 x half> %a to half
  ret half %b
}

define i32 @bitcast_v2f16_i32(<2 x half> %a) {
; CHECK-LABEL: bitcast_v2f16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %b = bitcast <2 x half> %a to i32
  ret i32 %b
}

define i32 @bitcast_v1f32_i32(<1 x float> %a) {
; CHECK-LABEL: bitcast_v1f32_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %b = bitcast <1 x float> %a to i32
  ret i32 %b
}

define float @bitcast_v2f16_f32(<2 x half> %a) {
; RV32-FP-LABEL: bitcast_v2f16_f32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetvli zero, zero, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.x.s a0, v8
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v2f16_f32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e32,mf2,ta,mu
; RV64-FP-NEXT:    vfmv.f.s ft0, v8
; RV64-FP-NEXT:    fmv.x.w a0, ft0
; RV64-FP-NEXT:    ret
  %b = bitcast <2 x half> %a to float
  ret float %b
}

define float @bitcast_v1f32_f32(<1 x float> %a) {
; RV32-FP-LABEL: bitcast_v1f32_f32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetvli zero, zero, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.x.s a0, v8
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v1f32_f32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e32,mf2,ta,mu
; RV64-FP-NEXT:    vfmv.f.s ft0, v8
; RV64-FP-NEXT:    fmv.x.w a0, ft0
; RV64-FP-NEXT:    ret
  %b = bitcast <1 x float> %a to float
  ret float %b
}

define i64 @bitcast_v4f16_i64(<4 x half> %a) {
; RV32-FP-LABEL: bitcast_v4f16_i64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi a0, zero, 32
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vsrl.vx v25, v8, a0
; RV32-FP-NEXT:    vmv.x.s a1, v25
; RV32-FP-NEXT:    vmv.x.s a0, v8
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v4f16_i64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.x.s a0, v8
; RV64-FP-NEXT:    ret
  %b = bitcast <4 x half> %a to i64
  ret i64 %b
}

define i64 @bitcast_v2f32_i64(<2 x float> %a) {
; RV32-FP-LABEL: bitcast_v2f32_i64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi a0, zero, 32
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vsrl.vx v25, v8, a0
; RV32-FP-NEXT:    vmv.x.s a1, v25
; RV32-FP-NEXT:    vmv.x.s a0, v8
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v2f32_i64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.x.s a0, v8
; RV64-FP-NEXT:    ret
  %b = bitcast <2 x float> %a to i64
  ret i64 %b
}

define i64 @bitcast_v1f64_i64(<1 x double> %a) {
; RV32-FP-LABEL: bitcast_v1f64_i64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi a0, zero, 32
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vsrl.vx v25, v8, a0
; RV32-FP-NEXT:    vmv.x.s a1, v25
; RV32-FP-NEXT:    vmv.x.s a0, v8
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v1f64_i64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.x.s a0, v8
; RV64-FP-NEXT:    ret
  %b = bitcast <1 x double> %a to i64
  ret i64 %b
}

define double @bitcast_v4f16_f64(<4 x half> %a) {
; RV32-FP-LABEL: bitcast_v4f16_f64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.f.s ft0, v8
; RV32-FP-NEXT:    fsd ft0, 8(sp)
; RV32-FP-NEXT:    lw a0, 8(sp)
; RV32-FP-NEXT:    lw a1, 12(sp)
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v4f16_f64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.x.s a0, v8
; RV64-FP-NEXT:    ret
  %b = bitcast <4 x half> %a to double
  ret double %b
}

define double @bitcast_v2f32_f64(<2 x float> %a) {
; RV32-FP-LABEL: bitcast_v2f32_f64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.f.s ft0, v8
; RV32-FP-NEXT:    fsd ft0, 8(sp)
; RV32-FP-NEXT:    lw a0, 8(sp)
; RV32-FP-NEXT:    lw a1, 12(sp)
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v2f32_f64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.x.s a0, v8
; RV64-FP-NEXT:    ret
  %b = bitcast <2 x float> %a to double
  ret double %b
}

define double @bitcast_v1f64_f64(<1 x double> %a) {
; RV32-FP-LABEL: bitcast_v1f64_f64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.f.s ft0, v8
; RV32-FP-NEXT:    fsd ft0, 8(sp)
; RV32-FP-NEXT:    lw a0, 8(sp)
; RV32-FP-NEXT:    lw a1, 12(sp)
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_v1f64_f64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.x.s a0, v8
; RV64-FP-NEXT:    ret
  %b = bitcast <1 x double> %a to double
  ret double %b
}

define <1 x half> @bitcast_i16_v1f16(i16 %a) {
; CHECK-LABEL: bitcast_i16_v1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16,mf4,ta,mu
; CHECK-NEXT:    vmv.v.x v8, a0
; CHECK-NEXT:    ret
  %b = bitcast i16 %a to <1 x half>
  ret <1 x half> %b
}

define <2 x half> @bitcast_i32_v2f16(i32 %a) {
; RV32-FP-LABEL: bitcast_i32_v2f16:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.s.x v8, a0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_i32_v2f16:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV64-FP-NEXT:    vmv.v.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast i32 %a to <2 x half>
  ret <2 x half> %b
}

define <1 x float> @bitcast_i32_v1f32(i32 %a) {
; RV32-FP-LABEL: bitcast_i32_v1f32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.s.x v8, a0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_i32_v1f32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV64-FP-NEXT:    vmv.v.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast i32 %a to <1 x float>
  ret <1 x float> %b
}

define <4 x half> @bitcast_i64_v4f16(i64 %a) {
; RV32-FP-LABEL: bitcast_i64_v4f16:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 2, e32,m1,ta,mu
; RV32-FP-NEXT:    vmv.v.i v25, 0
; RV32-FP-NEXT:    vslide1up.vx v26, v25, a1
; RV32-FP-NEXT:    vslide1up.vx v25, v26, a0
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vslideup.vi v8, v25, 0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_i64_v4f16:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast i64 %a to <4 x half>
  ret <4 x half> %b
}

define <2 x float> @bitcast_i64_v2f32(i64 %a) {
; RV32-FP-LABEL: bitcast_i64_v2f32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 2, e32,m1,ta,mu
; RV32-FP-NEXT:    vmv.v.i v25, 0
; RV32-FP-NEXT:    vslide1up.vx v26, v25, a1
; RV32-FP-NEXT:    vslide1up.vx v25, v26, a0
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vslideup.vi v8, v25, 0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_i64_v2f32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast i64 %a to <2 x float>
  ret <2 x float> %b
}

define <1 x double> @bitcast_i64_v1f64(i64 %a) {
; RV32-FP-LABEL: bitcast_i64_v1f64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 2, e32,m1,ta,mu
; RV32-FP-NEXT:    vmv.v.i v25, 0
; RV32-FP-NEXT:    vslide1up.vx v26, v25, a1
; RV32-FP-NEXT:    vslide1up.vx v25, v26, a0
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vslideup.vi v8, v25, 0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_i64_v1f64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast i64 %a to <1 x double>
  ret <1 x double> %b
}

define <1 x i16> @bitcast_f16_v1i16(half %a) {
; CHECK-LABEL: bitcast_f16_v1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetivli zero, 1, e16,mf4,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, ft0
; CHECK-NEXT:    ret
  %b = bitcast half %a to <1 x i16>
  ret <1 x i16> %b
}

define <1 x half> @bitcast_f16_v1f16(half %a) {
; CHECK-LABEL: bitcast_f16_v1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetivli zero, 1, e16,mf4,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, ft0
; CHECK-NEXT:    ret
  %b = bitcast half %a to <1 x half>
  ret <1 x half> %b
}

define <2 x i16> @bitcast_f32_v2i16(float %a) {
; RV32-FP-LABEL: bitcast_f32_v2i16:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.s.x v8, a0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f32_v2i16:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    fmv.w.x ft0, a0
; RV64-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV64-FP-NEXT:    vfmv.s.f v8, ft0
; RV64-FP-NEXT:    ret
  %b = bitcast float %a to <2 x i16>
  ret <2 x i16> %b
}

define <2 x half> @bitcast_f32_v2f16(float %a) {
; RV32-FP-LABEL: bitcast_f32_v2f16:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.s.x v8, a0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f32_v2f16:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    fmv.w.x ft0, a0
; RV64-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV64-FP-NEXT:    vfmv.s.f v8, ft0
; RV64-FP-NEXT:    ret
  %b = bitcast float %a to <2 x half>
  ret <2 x half> %b
}

define <1 x i32> @bitcast_f32_v1i32(float %a) {
; RV32-FP-LABEL: bitcast_f32_v1i32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.s.x v8, a0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f32_v1i32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    fmv.w.x ft0, a0
; RV64-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV64-FP-NEXT:    vfmv.s.f v8, ft0
; RV64-FP-NEXT:    ret
  %b = bitcast float %a to <1 x i32>
  ret <1 x i32> %b
}

define <1 x float> @bitcast_f32_v1f32(float %a) {
; RV32-FP-LABEL: bitcast_f32_v1f32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV32-FP-NEXT:    vmv.s.x v8, a0
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f32_v1f32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    fmv.w.x ft0, a0
; RV64-FP-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; RV64-FP-NEXT:    vfmv.s.f v8, ft0
; RV64-FP-NEXT:    ret
  %b = bitcast float %a to <1 x float>
  ret <1 x float> %b
}

define <4 x i16> @bitcast_f64_v4i16(double %a) {
; RV32-FP-LABEL: bitcast_f64_v4i16:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    sw a0, 8(sp)
; RV32-FP-NEXT:    sw a1, 12(sp)
; RV32-FP-NEXT:    fld ft0, 8(sp)
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.s.f v8, ft0
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f64_v4i16:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast double %a to <4 x i16>
  ret <4 x i16> %b
}

define <4 x half> @bitcast_f64_v4f16(double %a) {
; RV32-FP-LABEL: bitcast_f64_v4f16:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    sw a0, 8(sp)
; RV32-FP-NEXT:    sw a1, 12(sp)
; RV32-FP-NEXT:    fld ft0, 8(sp)
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.s.f v8, ft0
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f64_v4f16:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast double %a to <4 x half>
  ret <4 x half> %b
}

define <2 x i32> @bitcast_f64_v2i32(double %a) {
; RV32-FP-LABEL: bitcast_f64_v2i32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    sw a0, 8(sp)
; RV32-FP-NEXT:    sw a1, 12(sp)
; RV32-FP-NEXT:    fld ft0, 8(sp)
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.s.f v8, ft0
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f64_v2i32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast double %a to <2 x i32>
  ret <2 x i32> %b
}

define <2 x float> @bitcast_f64_v2f32(double %a) {
; RV32-FP-LABEL: bitcast_f64_v2f32:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    sw a0, 8(sp)
; RV32-FP-NEXT:    sw a1, 12(sp)
; RV32-FP-NEXT:    fld ft0, 8(sp)
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.s.f v8, ft0
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f64_v2f32:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast double %a to <2 x float>
  ret <2 x float> %b
}

define <1 x i64> @bitcast_f64_v1i64(double %a) {
; RV32-FP-LABEL: bitcast_f64_v1i64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    sw a0, 8(sp)
; RV32-FP-NEXT:    sw a1, 12(sp)
; RV32-FP-NEXT:    fld ft0, 8(sp)
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.s.f v8, ft0
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f64_v1i64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast double %a to <1 x i64>
  ret <1 x i64> %b
}

define <1 x double> @bitcast_f64_v1f64(double %a) {
; RV32-FP-LABEL: bitcast_f64_v1f64:
; RV32-FP:       # %bb.0:
; RV32-FP-NEXT:    addi sp, sp, -16
; RV32-FP-NEXT:    .cfi_def_cfa_offset 16
; RV32-FP-NEXT:    sw a0, 8(sp)
; RV32-FP-NEXT:    sw a1, 12(sp)
; RV32-FP-NEXT:    fld ft0, 8(sp)
; RV32-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-FP-NEXT:    vfmv.s.f v8, ft0
; RV32-FP-NEXT:    addi sp, sp, 16
; RV32-FP-NEXT:    ret
;
; RV64-FP-LABEL: bitcast_f64_v1f64:
; RV64-FP:       # %bb.0:
; RV64-FP-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-FP-NEXT:    vmv.s.x v8, a0
; RV64-FP-NEXT:    ret
  %b = bitcast double %a to <1 x double>
  ret <1 x double> %b
}
