; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK

define <8 x i8> @vnsra_v8i16_v8i8_scalar(<8 x i16> %x, i16 %y) {
; CHECK-LABEL: vnsra_v8i16_v8i8_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vnsra.wx v8, v8, a0
; CHECK-NEXT:    ret
  %insert = insertelement <8 x i16> undef, i16 %y, i16 0
  %splat = shufflevector <8 x i16> %insert, <8 x i16> undef, <8 x i32> zeroinitializer
  %a = ashr <8 x i16> %x, %splat
  %b = trunc <8 x i16> %a to <8 x i8>
  ret <8 x i8> %b
}

define <4 x i16> @vnsra_v4i32_v4i16_scalar(<4 x i32> %x, i32 %y) {
; CHECK-LABEL: vnsra_v4i32_v4i16_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vnsra.wx v8, v8, a0
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i32> undef, i32 %y, i32 0
  %splat = shufflevector <4 x i32> %insert, <4 x i32> undef, <4 x i32> zeroinitializer
  %a = ashr <4 x i32> %x, %splat
  %b = trunc <4 x i32> %a to <4 x i16>
  ret <4 x i16> %b
}

define <2 x i32> @vnsra_v2i64_v2i32_scalar(<2 x i64> %x, i64 %y) {
; CHECK-LABEL: vnsra_v2i64_v2i32_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vnsra.wx v8, v8, a0
; CHECK-NEXT:    ret
; RV32-LABEL: vnsra_v2i64_v2i32_scalar:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    vsetivli zero, 2, e64,m1,ta,mu
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v25, (a0), zero
; RV32-NEXT:    vsra.vv v25, v8, v25
; RV32-NEXT:    vsetivli zero, 2, e32,mf2,ta,mu
; RV32-NEXT:    vnsrl.wi v8, v25, 0
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
; RV64-LABEL: vnsra_v2i64_v2i32_scalar:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e32,mf2,ta,mu
; RV64-NEXT:    vnsra.wx v25, v8, a0
; RV64-NEXT:    vmv1r.v v8, v25
; RV64-NEXT:    ret
  %insert = insertelement <2 x i64> undef, i64 %y, i32 0
  %splat = shufflevector <2 x i64> %insert, <2 x i64> undef, <2 x i32> zeroinitializer
  %a = ashr <2 x i64> %x, %splat
  %b = trunc <2 x i64> %a to <2 x i32>
  ret <2 x i32> %b
}

define <8 x i8> @vnsra_v8i16_v8i8_imm(<8 x i16> %x) {
; CHECK-LABEL: vnsra_v8i16_v8i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 8
; CHECK-NEXT:    ret
  %a = ashr <8 x i16> %x, <i16 8, i16 8, i16 8, i16 8,i16 8, i16 8, i16 8, i16 8>
  %b = trunc <8 x i16> %a to <8 x i8>
  ret <8 x i8> %b
}

define <4 x i16> @vnsra_v4i32_v4i16_imm(<4 x i32> %x) {
; CHECK-LABEL: vnsra_v4i32_v4i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 16
; CHECK-NEXT:    ret
  %a = ashr <4 x i32> %x, <i32 16, i32 16, i32 16, i32 16>
  %b = trunc <4 x i32> %a to <4 x i16>
  ret <4 x i16> %b
}

define <2 x i32> @vnsra_v2i64_v2i32_imm(<2 x i64> %x) {
; CHECK-LABEL: vnsra_v2i64_v2i32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 31
; CHECK-NEXT:    ret
  %a = ashr <2 x i64> %x, <i64 31, i64 31>
  %b = trunc <2 x i64> %a to <2 x i32>
  ret <2 x i32> %b
}

define <8 x i8> @vnsrl_v8i16_v8i8_scalar(<8 x i16> %x, i16 %y) {
; CHECK-LABEL: vnsrl_v8i16_v8i8_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wx v8, v8, a0
; CHECK-NEXT:    ret
  %insert = insertelement <8 x i16> undef, i16 %y, i16 0
  %splat = shufflevector <8 x i16> %insert, <8 x i16> undef, <8 x i32> zeroinitializer
  %a = lshr <8 x i16> %x, %splat
  %b = trunc <8 x i16> %a to <8 x i8>
  ret <8 x i8> %b
}

define <4 x i16> @vnsrl_v4i32_v4i16_scalar(<4 x i32> %x, i32 %y) {
; CHECK-LABEL: vnsrl_v4i32_v4i16_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wx v8, v8, a0
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i32> undef, i32 %y, i32 0
  %splat = shufflevector <4 x i32> %insert, <4 x i32> undef, <4 x i32> zeroinitializer
  %a = lshr <4 x i32> %x, %splat
  %b = trunc <4 x i32> %a to <4 x i16>
  ret <4 x i16> %b
}

define <2 x i32> @vnsrl_v2i64_v2i32_scalar(<2 x i64> %x, i64 %y) {
; CHECK-LABEL: vnsrl_v2i64_v2i32_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wx v8, v8, a0
; CHECK-NEXT:    ret
; RV32-LABEL: vnsrl_v2i64_v2i32_scalar:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    vsetivli zero, 2, e64,m1,ta,mu
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v25, (a0), zero
; RV32-NEXT:    vsrl.vv v25, v8, v25
; RV32-NEXT:    vsetivli zero, 2, e32,mf2,ta,mu
; RV32-NEXT:    vnsrl.wi v8, v25, 0
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
; RV64-LABEL: vnsrl_v2i64_v2i32_scalar:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e32,mf2,ta,mu
; RV64-NEXT:    vnsrl.wx v25, v8, a0
; RV64-NEXT:    vmv1r.v v8, v25
; RV64-NEXT:    ret
  %insert = insertelement <2 x i64> undef, i64 %y, i32 0
  %splat = shufflevector <2 x i64> %insert, <2 x i64> undef, <2 x i32> zeroinitializer
  %a = lshr <2 x i64> %x, %splat
  %b = trunc <2 x i64> %a to <2 x i32>
  ret <2 x i32> %b
}

define <8 x i8> @vnsrl_v8i16_v8i8_imm(<8 x i16> %x) {
; CHECK-LABEL: vnsrl_v8i16_v8i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 8
; CHECK-NEXT:    ret
  %a = lshr <8 x i16> %x, <i16 8, i16 8, i16 8, i16 8,i16 8, i16 8, i16 8, i16 8>
  %b = trunc <8 x i16> %a to <8 x i8>
  ret <8 x i8> %b
}

define <4 x i16> @vnsrl_v4i32_v4i16_imm(<4 x i32> %x) {
; CHECK-LABEL: vnsrl_v4i32_v4i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 16
; CHECK-NEXT:    ret
  %a = lshr <4 x i32> %x, <i32 16, i32 16, i32 16, i32 16>
  %b = trunc <4 x i32> %a to <4 x i16>
  ret <4 x i16> %b
}

define <2 x i32> @vnsrl_v2i64_v2i32_imm(<2 x i64> %x) {
; CHECK-LABEL: vnsrl_v2i64_v2i32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 31
; CHECK-NEXT:    ret
  %a = lshr <2 x i64> %x, <i64 31, i64 31>
  %b = trunc <2 x i64> %a to <2 x i32>
  ret <2 x i32> %b
}
