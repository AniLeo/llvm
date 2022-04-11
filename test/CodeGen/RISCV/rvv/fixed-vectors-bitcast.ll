; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v,+d,+zfh,+experimental-zvfh -verify-machineinstrs \
; RUN:     -riscv-v-vector-bits-min=128 -target-abi=ilp32d < %s \
; RUN:     | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+v,+d,+zfh,+experimental-zvfh -verify-machineinstrs \
; RUN:     -riscv-v-vector-bits-min=128 -target-abi=lp64d < %s \
; RUN:     | FileCheck %s --check-prefixes=CHECK,RV64
; RUN: llc -mtriple=riscv32 -mattr=+zve32f,+d,+zfh,+experimental-zvfh -verify-machineinstrs \
; RUN:     -riscv-v-vector-bits-min=128 -target-abi=ilp32d < %s \
; RUN:     | FileCheck %s --check-prefixes=ELEN32,RV32ELEN32
; RUN: llc -mtriple=riscv64 -mattr=+zve32f,+d,+zfh,+experimental-zvfh -verify-machineinstrs \
; RUN:     -riscv-v-vector-bits-min=128 -target-abi=lp64d < %s \
; RUN:     | FileCheck %s --check-prefixes=ELEN32,RV64ELEN32

define <32 x i1> @bitcast_v4i8_v32i1(<4 x i8> %a, <32 x i1> %b) {
; CHECK-LABEL: bitcast_v4i8_v32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli zero, a0, e8, m2, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v4i8_v32i1:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    li a0, 32
; ELEN32-NEXT:    vsetvli zero, a0, e8, m2, ta, mu
; ELEN32-NEXT:    vmxor.mm v0, v0, v8
; ELEN32-NEXT:    ret
  %c = bitcast <4 x i8> %a to <32 x i1>
  %d = xor <32 x i1> %b, %c
  ret <32 x i1> %d
}

define i8 @bitcast_v1i8_i8(<1 x i8> %a) {
; CHECK-LABEL: bitcast_v1i8_i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, mf8, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v1i8_i8:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e8, mf4, ta, mu
; ELEN32-NEXT:    vmv.x.s a0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <1 x i8> %a to i8
  ret i8 %b
}

define i16 @bitcast_v2i8_i16(<2 x i8> %a) {
; CHECK-LABEL: bitcast_v2i8_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, mf4, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v2i8_i16:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e16, mf2, ta, mu
; ELEN32-NEXT:    vmv.x.s a0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <2 x i8> %a to i16
  ret i16 %b
}

define i16 @bitcast_v1i16_i16(<1 x i16> %a) {
; CHECK-LABEL: bitcast_v1i16_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, mf4, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v1i16_i16:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e16, mf2, ta, mu
; ELEN32-NEXT:    vmv.x.s a0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <1 x i16> %a to i16
  ret i16 %b
}

define i32 @bitcast_v4i8_i32(<4 x i8> %a) {
; CHECK-LABEL: bitcast_v4i8_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v4i8_i32:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e32, m1, ta, mu
; ELEN32-NEXT:    vmv.x.s a0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <4 x i8> %a to i32
  ret i32 %b
}

define i32 @bitcast_v2i16_i32(<2 x i16> %a) {
; CHECK-LABEL: bitcast_v2i16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v2i16_i32:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e32, m1, ta, mu
; ELEN32-NEXT:    vmv.x.s a0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <2 x i16> %a to i32
  ret i32 %b
}

define i32 @bitcast_v1i32_i32(<1 x i32> %a) {
; CHECK-LABEL: bitcast_v1i32_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v1i32_i32:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e32, m1, ta, mu
; ELEN32-NEXT:    vmv.x.s a0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <1 x i32> %a to i32
  ret i32 %b
}

define i64 @bitcast_v8i8_i64(<8 x i8> %a) {
; RV32-LABEL: bitcast_v8i8_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    li a0, 32
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV32-NEXT:    vsrl.vx v9, v8, a0
; RV32-NEXT:    vmv.x.s a1, v9
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_v8i8_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_v8i8_i64:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; RV32ELEN32-NEXT:    vslidedown.vi v9, v8, 1
; RV32ELEN32-NEXT:    vmv.x.s a1, v9
; RV32ELEN32-NEXT:    vmv.x.s a0, v8
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_v8i8_i64:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    addi sp, sp, -16
; RV64ELEN32-NEXT:    .cfi_def_cfa_offset 16
; RV64ELEN32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64ELEN32-NEXT:    addi a0, sp, 8
; RV64ELEN32-NEXT:    vse8.v v8, (a0)
; RV64ELEN32-NEXT:    ld a0, 8(sp)
; RV64ELEN32-NEXT:    addi sp, sp, 16
; RV64ELEN32-NEXT:    ret
  %b = bitcast <8 x i8> %a to i64
  ret i64 %b
}

define i64 @bitcast_v4i16_i64(<4 x i16> %a) {
; RV32-LABEL: bitcast_v4i16_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    li a0, 32
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV32-NEXT:    vsrl.vx v9, v8, a0
; RV32-NEXT:    vmv.x.s a1, v9
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_v4i16_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_v4i16_i64:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; RV32ELEN32-NEXT:    vslidedown.vi v9, v8, 1
; RV32ELEN32-NEXT:    vmv.x.s a1, v9
; RV32ELEN32-NEXT:    vmv.x.s a0, v8
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_v4i16_i64:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    addi sp, sp, -16
; RV64ELEN32-NEXT:    .cfi_def_cfa_offset 16
; RV64ELEN32-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; RV64ELEN32-NEXT:    addi a0, sp, 8
; RV64ELEN32-NEXT:    vse16.v v8, (a0)
; RV64ELEN32-NEXT:    ld a0, 8(sp)
; RV64ELEN32-NEXT:    addi sp, sp, 16
; RV64ELEN32-NEXT:    ret
  %b = bitcast <4 x i16> %a to i64
  ret i64 %b
}

define i64 @bitcast_v2i32_i64(<2 x i32> %a) {
; RV32-LABEL: bitcast_v2i32_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    li a0, 32
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV32-NEXT:    vsrl.vx v9, v8, a0
; RV32-NEXT:    vmv.x.s a1, v9
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_v2i32_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_v2i32_i64:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; RV32ELEN32-NEXT:    vslidedown.vi v9, v8, 1
; RV32ELEN32-NEXT:    vmv.x.s a1, v9
; RV32ELEN32-NEXT:    vmv.x.s a0, v8
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_v2i32_i64:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    addi sp, sp, -16
; RV64ELEN32-NEXT:    .cfi_def_cfa_offset 16
; RV64ELEN32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV64ELEN32-NEXT:    addi a0, sp, 8
; RV64ELEN32-NEXT:    vse32.v v8, (a0)
; RV64ELEN32-NEXT:    ld a0, 8(sp)
; RV64ELEN32-NEXT:    addi sp, sp, 16
; RV64ELEN32-NEXT:    ret
  %b = bitcast <2 x i32> %a to i64
  ret i64 %b
}

define i64 @bitcast_v1i64_i64(<1 x i64> %a) {
; RV32-LABEL: bitcast_v1i64_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    li a0, 32
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV32-NEXT:    vsrl.vx v9, v8, a0
; RV32-NEXT:    vmv.x.s a1, v9
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_v1i64_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v1i64_i64:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    ret
  %b = bitcast <1 x i64> %a to i64
  ret i64 %b
}

define half @bitcast_v2i8_f16(<2 x i8> %a) {
; CHECK-LABEL: bitcast_v2i8_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, mf4, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v2i8_f16:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e16, mf2, ta, mu
; ELEN32-NEXT:    vfmv.f.s fa0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <2 x i8> %a to half
  ret half %b
}

define half @bitcast_v1i16_f16(<1 x i16> %a) {
; CHECK-LABEL: bitcast_v1i16_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, mf4, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v1i16_f16:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e16, mf2, ta, mu
; ELEN32-NEXT:    vfmv.f.s fa0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <1 x i16> %a to half
  ret half %b
}

define float @bitcast_v4i8_f32(<4 x i8> %a) {
; CHECK-LABEL: bitcast_v4i8_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v4i8_f32:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e32, m1, ta, mu
; ELEN32-NEXT:    vfmv.f.s fa0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <4 x i8> %a to float
  ret float %b
}

define float @bitcast_v2i16_f32(<2 x i16> %a) {
; CHECK-LABEL: bitcast_v2i16_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v2i16_f32:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e32, m1, ta, mu
; ELEN32-NEXT:    vfmv.f.s fa0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <2 x i16> %a to float
  ret float %b
}

define float @bitcast_v1i32_f32(<1 x i32> %a) {
; CHECK-LABEL: bitcast_v1i32_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v1i32_f32:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 0, e32, m1, ta, mu
; ELEN32-NEXT:    vfmv.f.s fa0, v8
; ELEN32-NEXT:    ret
  %b = bitcast <1 x i32> %a to float
  ret float %b
}

define double @bitcast_v8i8_f64(<8 x i8> %a) {
; CHECK-LABEL: bitcast_v8i8_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v8i8_f64:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    addi sp, sp, -16
; ELEN32-NEXT:    .cfi_def_cfa_offset 16
; ELEN32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; ELEN32-NEXT:    addi a0, sp, 8
; ELEN32-NEXT:    vse8.v v8, (a0)
; ELEN32-NEXT:    fld fa0, 8(sp)
; ELEN32-NEXT:    addi sp, sp, 16
; ELEN32-NEXT:    ret
  %b = bitcast <8 x i8> %a to double
  ret double %b
}

define double @bitcast_v4i16_f64(<4 x i16> %a) {
; CHECK-LABEL: bitcast_v4i16_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v4i16_f64:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    addi sp, sp, -16
; ELEN32-NEXT:    .cfi_def_cfa_offset 16
; ELEN32-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; ELEN32-NEXT:    addi a0, sp, 8
; ELEN32-NEXT:    vse16.v v8, (a0)
; ELEN32-NEXT:    fld fa0, 8(sp)
; ELEN32-NEXT:    addi sp, sp, 16
; ELEN32-NEXT:    ret
  %b = bitcast <4 x i16> %a to double
  ret double %b
}

define double @bitcast_v2i32_f64(<2 x i32> %a) {
; CHECK-LABEL: bitcast_v2i32_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_v2i32_f64:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    addi sp, sp, -16
; ELEN32-NEXT:    .cfi_def_cfa_offset 16
; ELEN32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; ELEN32-NEXT:    addi a0, sp, 8
; ELEN32-NEXT:    vse32.v v8, (a0)
; ELEN32-NEXT:    fld fa0, 8(sp)
; ELEN32-NEXT:    addi sp, sp, 16
; ELEN32-NEXT:    ret
  %b = bitcast <2 x i32> %a to double
  ret double %b
}

define double @bitcast_v1i64_f64(<1 x i64> %a) {
; CHECK-LABEL: bitcast_v1i64_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_v1i64_f64:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    addi sp, sp, -16
; RV32ELEN32-NEXT:    .cfi_def_cfa_offset 16
; RV32ELEN32-NEXT:    sw a1, 12(sp)
; RV32ELEN32-NEXT:    sw a0, 8(sp)
; RV32ELEN32-NEXT:    fld fa0, 8(sp)
; RV32ELEN32-NEXT:    addi sp, sp, 16
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_v1i64_f64:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    addi sp, sp, -16
; RV64ELEN32-NEXT:    .cfi_def_cfa_offset 16
; RV64ELEN32-NEXT:    sd a0, 8(sp)
; RV64ELEN32-NEXT:    fld fa0, 8(sp)
; RV64ELEN32-NEXT:    addi sp, sp, 16
; RV64ELEN32-NEXT:    ret
  %b = bitcast <1 x i64> %a to double
  ret double %b
}

define <1 x i16> @bitcast_i16_v1i16(i16 %a) {
; CHECK-LABEL: bitcast_i16_v1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, mf4, ta, mu
; CHECK-NEXT:    vmv.v.x v8, a0
; CHECK-NEXT:    ret
;
; ELEN32-LABEL: bitcast_i16_v1i16:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; ELEN32-NEXT:    vmv.v.x v8, a0
; ELEN32-NEXT:    ret
  %b = bitcast i16 %a to <1 x i16>
  ret <1 x i16> %b
}

define <2 x i16> @bitcast_i32_v2i16(i32 %a) {
; RV32-LABEL: bitcast_i32_v2i16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV32-NEXT:    vmv.s.x v8, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_i32_v2i16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV64-NEXT:    vmv.v.x v8, a0
; RV64-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_i32_v2i16:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; RV32ELEN32-NEXT:    vmv.s.x v8, a0
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_i32_v2i16:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; RV64ELEN32-NEXT:    vmv.v.x v8, a0
; RV64ELEN32-NEXT:    ret
  %b = bitcast i32 %a to <2 x i16>
  ret <2 x i16> %b
}

define <1 x i32> @bitcast_i32_v1i32(i32 %a) {
; RV32-LABEL: bitcast_i32_v1i32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV32-NEXT:    vmv.s.x v8, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_i32_v1i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV64-NEXT:    vmv.v.x v8, a0
; RV64-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_i32_v1i32:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; RV32ELEN32-NEXT:    vmv.s.x v8, a0
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_i32_v1i32:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; RV64ELEN32-NEXT:    vmv.v.x v8, a0
; RV64ELEN32-NEXT:    ret
  %b = bitcast i32 %a to <1 x i32>
  ret <1 x i32> %b
}

define <4 x i16> @bitcast_i64_v4i16(i64 %a) {
; RV32-LABEL: bitcast_i64_v4i16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vslide1up.vx v9, v8, a1
; RV32-NEXT:    vslide1up.vx v10, v9, a0
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV32-NEXT:    vslideup.vi v8, v10, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_i64_v4i16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV64-NEXT:    vmv.s.x v8, a0
; RV64-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_i64_v4i16:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV32ELEN32-NEXT:    vmv.v.x v8, a1
; RV32ELEN32-NEXT:    vsetvli zero, zero, e32, m1, tu, mu
; RV32ELEN32-NEXT:    vmv.s.x v8, a0
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_i64_v4i16:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    addi sp, sp, -16
; RV64ELEN32-NEXT:    .cfi_def_cfa_offset 16
; RV64ELEN32-NEXT:    sd a0, 8(sp)
; RV64ELEN32-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; RV64ELEN32-NEXT:    addi a0, sp, 8
; RV64ELEN32-NEXT:    vle16.v v8, (a0)
; RV64ELEN32-NEXT:    addi sp, sp, 16
; RV64ELEN32-NEXT:    ret
  %b = bitcast i64 %a to <4 x i16>
  ret <4 x i16> %b
}

define <2 x i32> @bitcast_i64_v2i32(i64 %a) {
; RV32-LABEL: bitcast_i64_v2i32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vslide1up.vx v9, v8, a1
; RV32-NEXT:    vslide1up.vx v10, v9, a0
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV32-NEXT:    vslideup.vi v8, v10, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_i64_v2i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV64-NEXT:    vmv.s.x v8, a0
; RV64-NEXT:    ret
;
; RV32ELEN32-LABEL: bitcast_i64_v2i32:
; RV32ELEN32:       # %bb.0:
; RV32ELEN32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV32ELEN32-NEXT:    vmv.v.x v8, a1
; RV32ELEN32-NEXT:    vsetvli zero, zero, e32, m1, tu, mu
; RV32ELEN32-NEXT:    vmv.s.x v8, a0
; RV32ELEN32-NEXT:    ret
;
; RV64ELEN32-LABEL: bitcast_i64_v2i32:
; RV64ELEN32:       # %bb.0:
; RV64ELEN32-NEXT:    addi sp, sp, -16
; RV64ELEN32-NEXT:    .cfi_def_cfa_offset 16
; RV64ELEN32-NEXT:    sd a0, 8(sp)
; RV64ELEN32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV64ELEN32-NEXT:    addi a0, sp, 8
; RV64ELEN32-NEXT:    vle32.v v8, (a0)
; RV64ELEN32-NEXT:    addi sp, sp, 16
; RV64ELEN32-NEXT:    ret
  %b = bitcast i64 %a to <2 x i32>
  ret <2 x i32> %b
}

define <1 x i64> @bitcast_i64_v1i64(i64 %a) {
; RV32-LABEL: bitcast_i64_v1i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vslide1up.vx v9, v8, a1
; RV32-NEXT:    vslide1up.vx v10, v9, a0
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV32-NEXT:    vslideup.vi v8, v10, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: bitcast_i64_v1i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV64-NEXT:    vmv.s.x v8, a0
; RV64-NEXT:    ret
;
; ELEN32-LABEL: bitcast_i64_v1i64:
; ELEN32:       # %bb.0:
; ELEN32-NEXT:    ret
  %b = bitcast i64 %a to <1 x i64>
  ret <1 x i64> %b
}
