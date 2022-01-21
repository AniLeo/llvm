; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-elen-max=32 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+d,+v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-elen-max=32 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64
; RUN: llc -mtriple=riscv32 -mattr=+d,+zve32f -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+d,+zve32f -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

; Test that limiting ELEN, either through the command line or zve32, scalarizes
; elements larger than that and disables some fractional LMULs.

; This should use LMUL=1.
define void @add_v4i32(<4 x i32>* %x, <4 x i32>* %y) {
; CHECK-LABEL: add_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vle32.v v9, (a1)
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <4 x i32>, <4 x i32>* %x
  %b = load <4 x i32>, <4 x i32>* %y
  %c = add <4 x i32> %a, %b
  store <4 x i32> %c, <4 x i32>* %x
  ret void
}

; i64 vectors should be scalarized
define void @add_v2i64(<2 x i64>* %x, <2 x i64>* %y) {
; RV32-LABEL: add_v2i64:
; RV32:       # %bb.0:
; RV32-NEXT:    lw a2, 8(a0)
; RV32-NEXT:    lw a3, 12(a0)
; RV32-NEXT:    lw a4, 0(a0)
; RV32-NEXT:    lw a5, 4(a0)
; RV32-NEXT:    lw a6, 4(a1)
; RV32-NEXT:    lw a7, 0(a1)
; RV32-NEXT:    lw t0, 8(a1)
; RV32-NEXT:    lw a1, 12(a1)
; RV32-NEXT:    add a5, a5, a6
; RV32-NEXT:    add a6, a4, a7
; RV32-NEXT:    sltu a4, a6, a4
; RV32-NEXT:    add a4, a5, a4
; RV32-NEXT:    add a1, a3, a1
; RV32-NEXT:    add a3, a2, t0
; RV32-NEXT:    sltu a2, a3, a2
; RV32-NEXT:    add a1, a1, a2
; RV32-NEXT:    sw a3, 8(a0)
; RV32-NEXT:    sw a6, 0(a0)
; RV32-NEXT:    sw a1, 12(a0)
; RV32-NEXT:    sw a4, 4(a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: add_v2i64:
; RV64:       # %bb.0:
; RV64-NEXT:    ld a2, 8(a0)
; RV64-NEXT:    ld a3, 0(a0)
; RV64-NEXT:    ld a4, 0(a1)
; RV64-NEXT:    ld a1, 8(a1)
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    add a1, a2, a1
; RV64-NEXT:    sd a1, 8(a0)
; RV64-NEXT:    sd a3, 0(a0)
; RV64-NEXT:    ret
  %a = load <2 x i64>, <2 x i64>* %x
  %b = load <2 x i64>, <2 x i64>* %y
  %c = add <2 x i64> %a, %b
  store <2 x i64> %c, <2 x i64>* %x
  ret void
}

; This should use LMUL=1 becuase there are no fractional i32 LMULs with ELEN=32
define void @add_v2i32(<2 x i32>* %x, <2 x i32>* %y) {
; CHECK-LABEL: add_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vle32.v v9, (a1)
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = load <2 x i32>, <2 x i32>* %y
  %c = add <2 x i32> %a, %b
  store <2 x i32> %c, <2 x i32>* %x
  ret void
}

; i64 vectors should be scalarized
define void @add_v1i64(<1 x i64>* %x, <1 x i64>* %y) {
; RV32-LABEL: add_v1i64:
; RV32:       # %bb.0:
; RV32-NEXT:    lw a2, 0(a0)
; RV32-NEXT:    lw a3, 4(a0)
; RV32-NEXT:    lw a4, 4(a1)
; RV32-NEXT:    lw a1, 0(a1)
; RV32-NEXT:    add a3, a3, a4
; RV32-NEXT:    add a1, a2, a1
; RV32-NEXT:    sltu a2, a1, a2
; RV32-NEXT:    add a2, a3, a2
; RV32-NEXT:    sw a1, 0(a0)
; RV32-NEXT:    sw a2, 4(a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: add_v1i64:
; RV64:       # %bb.0:
; RV64-NEXT:    ld a2, 0(a0)
; RV64-NEXT:    ld a1, 0(a1)
; RV64-NEXT:    add a1, a2, a1
; RV64-NEXT:    sd a1, 0(a0)
; RV64-NEXT:    ret
  %a = load <1 x i64>, <1 x i64>* %x
  %b = load <1 x i64>, <1 x i64>* %y
  %c = add <1 x i64> %a, %b
  store <1 x i64> %c, <1 x i64>* %x
  ret void
}

; This should use LMUL=1.
define void @fadd_v4f32(<4 x float>* %x, <4 x float>* %y) {
; CHECK-LABEL: fadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vle32.v v9, (a1)
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <4 x float>, <4 x float>* %x
  %b = load <4 x float>, <4 x float>* %y
  %c = fadd <4 x float> %a, %b
  store <4 x float> %c, <4 x float>* %x
  ret void
}

; double vectors should be scalarized
define void @fadd_v2f64(<2 x double>* %x, <2 x double>* %y) {
; CHECK-LABEL: fadd_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fld ft0, 8(a0)
; CHECK-NEXT:    fld ft1, 0(a0)
; CHECK-NEXT:    fld ft2, 0(a1)
; CHECK-NEXT:    fld ft3, 8(a1)
; CHECK-NEXT:    fadd.d ft1, ft1, ft2
; CHECK-NEXT:    fadd.d ft0, ft0, ft3
; CHECK-NEXT:    fsd ft0, 8(a0)
; CHECK-NEXT:    fsd ft1, 0(a0)
; CHECK-NEXT:    ret
  %a = load <2 x double>, <2 x double>* %x
  %b = load <2 x double>, <2 x double>* %y
  %c = fadd <2 x double> %a, %b
  store <2 x double> %c, <2 x double>* %x
  ret void
}

; This should use LMUL=1 becuase there are no fractional float LMULs with ELEN=32
define void @fadd_v2f32(<2 x float>* %x, <2 x float>* %y) {
; CHECK-LABEL: fadd_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vle32.v v9, (a1)
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <2 x float>, <2 x float>* %x
  %b = load <2 x float>, <2 x float>* %y
  %c = fadd <2 x float> %a, %b
  store <2 x float> %c, <2 x float>* %x
  ret void
}

; double vectors should be scalarized
define void @fadd_v1f64(<1 x double>* %x, <1 x double>* %y) {
; CHECK-LABEL: fadd_v1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fld ft0, 0(a0)
; CHECK-NEXT:    fld ft1, 0(a1)
; CHECK-NEXT:    fadd.d ft0, ft0, ft1
; CHECK-NEXT:    fsd ft0, 0(a0)
; CHECK-NEXT:    ret
  %a = load <1 x double>, <1 x double>* %x
  %b = load <1 x double>, <1 x double>* %y
  %c = fadd <1 x double> %a, %b
  store <1 x double> %c, <1 x double>* %x
  ret void
}
