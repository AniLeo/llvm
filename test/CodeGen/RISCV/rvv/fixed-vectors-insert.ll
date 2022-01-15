; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+zfh,+f,+d -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+zfh,+f,+d -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

; FIXME: This codegen needs to be improved. These tests previously asserted
; type legalizing the i64 type on RV32.

define void @insertelt_v4i64(<4 x i64>* %x, i64 %y) {
; RV32-LABEL: insertelt_v4i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 4, e64, m2, ta, mu
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vsetivli zero, 2, e32, m2, ta, mu
; RV32-NEXT:    vmv.v.i v10, 0
; RV32-NEXT:    vslide1up.vx v12, v10, a2
; RV32-NEXT:    vslide1up.vx v10, v12, a1
; RV32-NEXT:    vsetivli zero, 4, e64, m2, tu, mu
; RV32-NEXT:    vslideup.vi v8, v10, 3
; RV32-NEXT:    vse64.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_v4i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, mu
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vmv.s.x v10, a1
; RV64-NEXT:    vsetvli zero, zero, e64, m2, tu, mu
; RV64-NEXT:    vslideup.vi v8, v10, 3
; RV64-NEXT:    vse64.v v8, (a0)
; RV64-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %x
  %b = insertelement <4 x i64> %a, i64 %y, i32 3
  store <4 x i64> %b, <4 x i64>* %x
  ret void
}

; This uses a non-power of 2 type so that it isn't an MVT.
; The align keeps the type legalizer from using a 256 bit load so we must split
; it. This some operations that weren't support for scalable vectors when
; this test was written.
define void @insertelt_v3i64(<3 x i64>* %x, i64 %y) {
; RV32-LABEL: insertelt_v3i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; RV32-NEXT:    vmv.v.i v10, 0
; RV32-NEXT:    vsetivli zero, 2, e64, m2, tu, mu
; RV32-NEXT:    vslideup.vi v10, v8, 0
; RV32-NEXT:    lw a3, 16(a0)
; RV32-NEXT:    addi a4, a0, 20
; RV32-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; RV32-NEXT:    vlse32.v v8, (a4), zero
; RV32-NEXT:    vsetvli zero, zero, e32, m1, tu, mu
; RV32-NEXT:    vmv.s.x v8, a3
; RV32-NEXT:    vsetvli zero, zero, e64, m2, tu, mu
; RV32-NEXT:    vslideup.vi v10, v8, 2
; RV32-NEXT:    vsetivli zero, 2, e32, m2, ta, mu
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vslide1up.vx v12, v8, a2
; RV32-NEXT:    vslide1up.vx v8, v12, a1
; RV32-NEXT:    vsetivli zero, 3, e64, m2, tu, mu
; RV32-NEXT:    vslideup.vi v10, v8, 2
; RV32-NEXT:    sw a1, 16(a0)
; RV32-NEXT:    sw a2, 20(a0)
; RV32-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; RV32-NEXT:    vse64.v v10, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_v3i64:
; RV64:       # %bb.0:
; RV64-NEXT:    sd a1, 16(a0)
; RV64-NEXT:    ret
  %a = load <3 x i64>, <3 x i64>* %x, align 8
  %b = insertelement <3 x i64> %a, i64 %y, i32 2
  store <3 x i64> %b, <3 x i64>* %x
  ret void
}

define void @insertelt_v16i8(<16 x i8>* %x, i8 %y) {
; CHECK-LABEL: insertelt_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vmv.s.x v9, a1
; CHECK-NEXT:    vsetivli zero, 15, e8, m1, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v9, 14
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vse8.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <16 x i8>, <16 x i8>* %x
  %b = insertelement <16 x i8> %a, i8 %y, i32 14
  store <16 x i8> %b, <16 x i8>* %x
  ret void
}

define void @insertelt_v32i16(<32 x i16>* %x, i16 %y, i32 %idx) {
; RV32-LABEL: insertelt_v32i16:
; RV32:       # %bb.0:
; RV32-NEXT:    li a3, 32
; RV32-NEXT:    vsetvli zero, a3, e16, m4, ta, mu
; RV32-NEXT:    vle16.v v8, (a0)
; RV32-NEXT:    vmv.s.x v12, a1
; RV32-NEXT:    addi a1, a2, 1
; RV32-NEXT:    vsetvli zero, a1, e16, m4, tu, mu
; RV32-NEXT:    vslideup.vx v8, v12, a2
; RV32-NEXT:    vsetvli zero, a3, e16, m4, ta, mu
; RV32-NEXT:    vse16.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_v32i16:
; RV64:       # %bb.0:
; RV64-NEXT:    li a3, 32
; RV64-NEXT:    vsetvli zero, a3, e16, m4, ta, mu
; RV64-NEXT:    vle16.v v8, (a0)
; RV64-NEXT:    vmv.s.x v12, a1
; RV64-NEXT:    sext.w a1, a2
; RV64-NEXT:    addi a2, a1, 1
; RV64-NEXT:    vsetvli zero, a2, e16, m4, tu, mu
; RV64-NEXT:    vslideup.vx v8, v12, a1
; RV64-NEXT:    vsetvli zero, a3, e16, m4, ta, mu
; RV64-NEXT:    vse16.v v8, (a0)
; RV64-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %x
  %b = insertelement <32 x i16> %a, i16 %y, i32 %idx
  store <32 x i16> %b, <32 x i16>* %x
  ret void
}

define void @insertelt_v8f32(<8 x float>* %x, float %y, i32 %idx) {
; RV32-LABEL: insertelt_v8f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; RV32-NEXT:    vle32.v v8, (a0)
; RV32-NEXT:    vfmv.s.f v10, fa0
; RV32-NEXT:    addi a2, a1, 1
; RV32-NEXT:    vsetvli zero, a2, e32, m2, tu, mu
; RV32-NEXT:    vslideup.vx v8, v10, a1
; RV32-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; RV32-NEXT:    vse32.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_v8f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; RV64-NEXT:    vle32.v v8, (a0)
; RV64-NEXT:    vfmv.s.f v10, fa0
; RV64-NEXT:    sext.w a1, a1
; RV64-NEXT:    addi a2, a1, 1
; RV64-NEXT:    vsetvli zero, a2, e32, m2, tu, mu
; RV64-NEXT:    vslideup.vx v8, v10, a1
; RV64-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; RV64-NEXT:    vse32.v v8, (a0)
; RV64-NEXT:    ret
  %a = load <8 x float>, <8 x float>* %x
  %b = insertelement <8 x float> %a, float %y, i32 %idx
  store <8 x float> %b, <8 x float>* %x
  ret void
}

define void @insertelt_v8i64_0(<8 x i64>* %x) {
; CHECK-LABEL: insertelt_v8i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    li a1, -1
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, tu, mu
; CHECK-NEXT:    vmv.s.x v8, a1
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %x
  %b = insertelement <8 x i64> %a, i64 -1, i32 0
  store <8 x i64> %b, <8 x i64>* %x
  ret void
}

define void @insertelt_v8i64(<8 x i64>* %x, i32 %idx) {
; RV32-LABEL: insertelt_v8i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    li a2, -1
; RV32-NEXT:    vmv.s.x v12, a2
; RV32-NEXT:    addi a2, a1, 1
; RV32-NEXT:    vsetvli zero, a2, e64, m4, tu, mu
; RV32-NEXT:    vslideup.vx v8, v12, a1
; RV32-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV32-NEXT:    vse64.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_v8i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    li a2, -1
; RV64-NEXT:    vmv.s.x v12, a2
; RV64-NEXT:    sext.w a1, a1
; RV64-NEXT:    addi a2, a1, 1
; RV64-NEXT:    vsetvli zero, a2, e64, m4, tu, mu
; RV64-NEXT:    vslideup.vx v8, v12, a1
; RV64-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV64-NEXT:    vse64.v v8, (a0)
; RV64-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %x
  %b = insertelement <8 x i64> %a, i64 -1, i32 %idx
  store <8 x i64> %b, <8 x i64>* %x
  ret void
}

define void @insertelt_c6_v8i64_0(<8 x i64>* %x) {
; CHECK-LABEL: insertelt_c6_v8i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    li a1, 6
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, tu, mu
; CHECK-NEXT:    vmv.s.x v8, a1
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %x
  %b = insertelement <8 x i64> %a, i64 6, i32 0
  store <8 x i64> %b, <8 x i64>* %x
  ret void
}

define void @insertelt_c6_v8i64(<8 x i64>* %x, i32 %idx) {
; RV32-LABEL: insertelt_c6_v8i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    li a2, 6
; RV32-NEXT:    vmv.s.x v12, a2
; RV32-NEXT:    addi a2, a1, 1
; RV32-NEXT:    vsetvli zero, a2, e64, m4, tu, mu
; RV32-NEXT:    vslideup.vx v8, v12, a1
; RV32-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV32-NEXT:    vse64.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_c6_v8i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    li a2, 6
; RV64-NEXT:    vmv.s.x v12, a2
; RV64-NEXT:    sext.w a1, a1
; RV64-NEXT:    addi a2, a1, 1
; RV64-NEXT:    vsetvli zero, a2, e64, m4, tu, mu
; RV64-NEXT:    vslideup.vx v8, v12, a1
; RV64-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; RV64-NEXT:    vse64.v v8, (a0)
; RV64-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %x
  %b = insertelement <8 x i64> %a, i64 6, i32 %idx
  store <8 x i64> %b, <8 x i64>* %x
  ret void
}

; Test that using a insertelement at element 0 by a later operation doesn't
; crash the compiler.
define void @insertelt_c6_v8i64_0_add(<8 x i64>* %x, <8 x i64>* %y) {
; CHECK-LABEL: insertelt_c6_v8i64_0_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    li a2, 6
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, tu, mu
; CHECK-NEXT:    vmv.s.x v8, a2
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, ta, mu
; CHECK-NEXT:    vle64.v v12, (a1)
; CHECK-NEXT:    vadd.vv v8, v8, v12
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %x
  %b = insertelement <8 x i64> %a, i64 6, i32 0
  %c = load <8 x i64>, <8 x i64>* %y
  %d = add <8 x i64> %b, %c
  store <8 x i64> %d, <8 x i64>* %x
  ret void
}
