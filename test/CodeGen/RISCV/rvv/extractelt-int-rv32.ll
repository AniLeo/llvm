; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+experimental-zvfh,+v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

define signext i8 @extractelt_nxv1i8_0(<vscale x 1 x i8> %v) {
; CHECK-LABEL: extractelt_nxv1i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, mf8, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i8> %v, i32 0
  ret i8 %r
}

define signext i8 @extractelt_nxv1i8_imm(<vscale x 1 x i8> %v) {
; CHECK-LABEL: extractelt_nxv1i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i8> %v, i32 2
  ret i8 %r
}

define signext i8 @extractelt_nxv1i8_idx(<vscale x 1 x i8> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv1i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i8> %v, i32 %idx
  ret i8 %r
}

define signext i8 @extractelt_nxv2i8_0(<vscale x 2 x i8> %v) {
; CHECK-LABEL: extractelt_nxv2i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i8> %v, i32 0
  ret i8 %r
}

define signext i8 @extractelt_nxv2i8_imm(<vscale x 2 x i8> %v) {
; CHECK-LABEL: extractelt_nxv2i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i8> %v, i32 2
  ret i8 %r
}

define signext i8 @extractelt_nxv2i8_idx(<vscale x 2 x i8> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv2i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i8> %v, i32 %idx
  ret i8 %r
}

define signext i8 @extractelt_nxv4i8_0(<vscale x 4 x i8> %v) {
; CHECK-LABEL: extractelt_nxv4i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i8> %v, i32 0
  ret i8 %r
}

define signext i8 @extractelt_nxv4i8_imm(<vscale x 4 x i8> %v) {
; CHECK-LABEL: extractelt_nxv4i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i8> %v, i32 2
  ret i8 %r
}

define signext i8 @extractelt_nxv4i8_idx(<vscale x 4 x i8> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv4i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i8> %v, i32 %idx
  ret i8 %r
}

define signext i8 @extractelt_nxv8i8_0(<vscale x 8 x i8> %v) {
; CHECK-LABEL: extractelt_nxv8i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, m1, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i8> %v, i32 0
  ret i8 %r
}

define signext i8 @extractelt_nxv8i8_imm(<vscale x 8 x i8> %v) {
; CHECK-LABEL: extractelt_nxv8i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i8> %v, i32 2
  ret i8 %r
}

define signext i8 @extractelt_nxv8i8_idx(<vscale x 8 x i8> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv8i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i8> %v, i32 %idx
  ret i8 %r
}

define signext i8 @extractelt_nxv16i8_0(<vscale x 16 x i8> %v) {
; CHECK-LABEL: extractelt_nxv16i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, m2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i8> %v, i32 0
  ret i8 %r
}

define signext i8 @extractelt_nxv16i8_imm(<vscale x 16 x i8> %v) {
; CHECK-LABEL: extractelt_nxv16i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m2, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i8> %v, i32 2
  ret i8 %r
}

define signext i8 @extractelt_nxv16i8_idx(<vscale x 16 x i8> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv16i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i8> %v, i32 %idx
  ret i8 %r
}

define signext i8 @extractelt_nxv32i8_0(<vscale x 32 x i8> %v) {
; CHECK-LABEL: extractelt_nxv32i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, m4, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 32 x i8> %v, i32 0
  ret i8 %r
}

define signext i8 @extractelt_nxv32i8_imm(<vscale x 32 x i8> %v) {
; CHECK-LABEL: extractelt_nxv32i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m4, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 32 x i8> %v, i32 2
  ret i8 %r
}

define signext i8 @extractelt_nxv32i8_idx(<vscale x 32 x i8> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv32i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m4, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 32 x i8> %v, i32 %idx
  ret i8 %r
}

define signext i8 @extractelt_nxv64i8_0(<vscale x 64 x i8> %v) {
; CHECK-LABEL: extractelt_nxv64i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e8, m8, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 64 x i8> %v, i32 0
  ret i8 %r
}

define signext i8 @extractelt_nxv64i8_imm(<vscale x 64 x i8> %v) {
; CHECK-LABEL: extractelt_nxv64i8_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 64 x i8> %v, i32 2
  ret i8 %r
}

define signext i8 @extractelt_nxv64i8_idx(<vscale x 64 x i8> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv64i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 64 x i8> %v, i32 %idx
  ret i8 %r
}

define signext i16 @extractelt_nxv1i16_0(<vscale x 1 x i16> %v) {
; CHECK-LABEL: extractelt_nxv1i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, mf4, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i16> %v, i32 0
  ret i16 %r
}

define signext i16 @extractelt_nxv1i16_imm(<vscale x 1 x i16> %v) {
; CHECK-LABEL: extractelt_nxv1i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i16> %v, i32 2
  ret i16 %r
}

define signext i16 @extractelt_nxv1i16_idx(<vscale x 1 x i16> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv1i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i16> %v, i32 %idx
  ret i16 %r
}

define signext i16 @extractelt_nxv2i16_0(<vscale x 2 x i16> %v) {
; CHECK-LABEL: extractelt_nxv2i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, mf2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i16> %v, i32 0
  ret i16 %r
}

define signext i16 @extractelt_nxv2i16_imm(<vscale x 2 x i16> %v) {
; CHECK-LABEL: extractelt_nxv2i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i16> %v, i32 2
  ret i16 %r
}

define signext i16 @extractelt_nxv2i16_idx(<vscale x 2 x i16> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv2i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i16> %v, i32 %idx
  ret i16 %r
}

define signext i16 @extractelt_nxv4i16_0(<vscale x 4 x i16> %v) {
; CHECK-LABEL: extractelt_nxv4i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, m1, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i16> %v, i32 0
  ret i16 %r
}

define signext i16 @extractelt_nxv4i16_imm(<vscale x 4 x i16> %v) {
; CHECK-LABEL: extractelt_nxv4i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m1, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i16> %v, i32 2
  ret i16 %r
}

define signext i16 @extractelt_nxv4i16_idx(<vscale x 4 x i16> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv4i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i16> %v, i32 %idx
  ret i16 %r
}

define signext i16 @extractelt_nxv8i16_0(<vscale x 8 x i16> %v) {
; CHECK-LABEL: extractelt_nxv8i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, m2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i16> %v, i32 0
  ret i16 %r
}

define signext i16 @extractelt_nxv8i16_imm(<vscale x 8 x i16> %v) {
; CHECK-LABEL: extractelt_nxv8i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m2, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i16> %v, i32 2
  ret i16 %r
}

define signext i16 @extractelt_nxv8i16_idx(<vscale x 8 x i16> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv8i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i16> %v, i32 %idx
  ret i16 %r
}

define signext i16 @extractelt_nxv16i16_0(<vscale x 16 x i16> %v) {
; CHECK-LABEL: extractelt_nxv16i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i16> %v, i32 0
  ret i16 %r
}

define signext i16 @extractelt_nxv16i16_imm(<vscale x 16 x i16> %v) {
; CHECK-LABEL: extractelt_nxv16i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m4, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i16> %v, i32 2
  ret i16 %r
}

define signext i16 @extractelt_nxv16i16_idx(<vscale x 16 x i16> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv16i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m4, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i16> %v, i32 %idx
  ret i16 %r
}

define signext i16 @extractelt_nxv32i16_0(<vscale x 32 x i16> %v) {
; CHECK-LABEL: extractelt_nxv32i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e16, m8, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 32 x i16> %v, i32 0
  ret i16 %r
}

define signext i16 @extractelt_nxv32i16_imm(<vscale x 32 x i16> %v) {
; CHECK-LABEL: extractelt_nxv32i16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 32 x i16> %v, i32 2
  ret i16 %r
}

define signext i16 @extractelt_nxv32i16_idx(<vscale x 32 x i16> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv32i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, m8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 32 x i16> %v, i32 %idx
  ret i16 %r
}

define i32 @extractelt_nxv1i32_0(<vscale x 1 x i32> %v) {
; CHECK-LABEL: extractelt_nxv1i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i32> %v, i32 0
  ret i32 %r
}

define i32 @extractelt_nxv1i32_imm(<vscale x 1 x i32> %v) {
; CHECK-LABEL: extractelt_nxv1i32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i32> %v, i32 2
  ret i32 %r
}

define i32 @extractelt_nxv1i32_idx(<vscale x 1 x i32> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv1i32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i32> %v, i32 %idx
  ret i32 %r
}

define i32 @extractelt_nxv2i32_0(<vscale x 2 x i32> %v) {
; CHECK-LABEL: extractelt_nxv2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, m1, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i32> %v, i32 0
  ret i32 %r
}

define i32 @extractelt_nxv2i32_imm(<vscale x 2 x i32> %v) {
; CHECK-LABEL: extractelt_nxv2i32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i32> %v, i32 2
  ret i32 %r
}

define i32 @extractelt_nxv2i32_idx(<vscale x 2 x i32> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv2i32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i32> %v, i32 %idx
  ret i32 %r
}

define i32 @extractelt_nxv4i32_0(<vscale x 4 x i32> %v) {
; CHECK-LABEL: extractelt_nxv4i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, m2, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i32> %v, i32 0
  ret i32 %r
}

define i32 @extractelt_nxv4i32_imm(<vscale x 4 x i32> %v) {
; CHECK-LABEL: extractelt_nxv4i32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m2, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i32> %v, i32 2
  ret i32 %r
}

define i32 @extractelt_nxv4i32_idx(<vscale x 4 x i32> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv4i32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i32> %v, i32 %idx
  ret i32 %r
}

define i32 @extractelt_nxv8i32_0(<vscale x 8 x i32> %v) {
; CHECK-LABEL: extractelt_nxv8i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, m4, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i32> %v, i32 0
  ret i32 %r
}

define i32 @extractelt_nxv8i32_imm(<vscale x 8 x i32> %v) {
; CHECK-LABEL: extractelt_nxv8i32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m4, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i32> %v, i32 2
  ret i32 %r
}

define i32 @extractelt_nxv8i32_idx(<vscale x 8 x i32> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv8i32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m4, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i32> %v, i32 %idx
  ret i32 %r
}

define i32 @extractelt_nxv16i32_0(<vscale x 16 x i32> %v) {
; CHECK-LABEL: extractelt_nxv16i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 0, e32, m8, ta, mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i32> %v, i32 0
  ret i32 %r
}

define i32 @extractelt_nxv16i32_imm(<vscale x 16 x i32> %v) {
; CHECK-LABEL: extractelt_nxv16i32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i32> %v, i32 2
  ret i32 %r
}

define i32 @extractelt_nxv16i32_idx(<vscale x 16 x i32> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv16i32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 16 x i32> %v, i32 %idx
  ret i32 %r
}

define i64 @extractelt_nxv1i64_0(<vscale x 1 x i64> %v) {
; CHECK-LABEL: extractelt_nxv1i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; CHECK-NEXT:    vsrl.vx v9, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v9
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i64> %v, i32 0
  ret i64 %r
}

define i64 @extractelt_nxv1i64_imm(<vscale x 1 x i64> %v) {
; CHECK-LABEL: extractelt_nxv1i64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i64> %v, i32 2
  ret i64 %r
}

define i64 @extractelt_nxv1i64_idx(<vscale x 1 x i64> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv1i64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 1 x i64> %v, i32 %idx
  ret i64 %r
}

define i64 @extractelt_nxv2i64_0(<vscale x 2 x i64> %v) {
; CHECK-LABEL: extractelt_nxv2i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetivli zero, 1, e64, m2, ta, mu
; CHECK-NEXT:    vsrl.vx v10, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v10
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i64> %v, i32 0
  ret i64 %r
}

define i64 @extractelt_nxv2i64_imm(<vscale x 2 x i64> %v) {
; CHECK-LABEL: extractelt_nxv2i64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m2, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i64> %v, i32 2
  ret i64 %r
}

define i64 @extractelt_nxv2i64_idx(<vscale x 2 x i64> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv2i64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 2 x i64> %v, i32 %idx
  ret i64 %r
}

define i64 @extractelt_nxv4i64_0(<vscale x 4 x i64> %v) {
; CHECK-LABEL: extractelt_nxv4i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetivli zero, 1, e64, m4, ta, mu
; CHECK-NEXT:    vsrl.vx v12, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v12
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i64> %v, i32 0
  ret i64 %r
}

define i64 @extractelt_nxv4i64_imm(<vscale x 4 x i64> %v) {
; CHECK-LABEL: extractelt_nxv4i64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m4, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i64> %v, i32 2
  ret i64 %r
}

define i64 @extractelt_nxv4i64_idx(<vscale x 4 x i64> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv4i64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m4, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 4 x i64> %v, i32 %idx
  ret i64 %r
}

define i64 @extractelt_nxv8i64_0(<vscale x 8 x i64> %v) {
; CHECK-LABEL: extractelt_nxv8i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetivli zero, 1, e64, m8, ta, mu
; CHECK-NEXT:    vsrl.vx v16, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v16
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i64> %v, i32 0
  ret i64 %r
}

define i64 @extractelt_nxv8i64_imm(<vscale x 8 x i64> %v) {
; CHECK-LABEL: extractelt_nxv8i64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i64> %v, i32 2
  ret i64 %r
}

define i64 @extractelt_nxv8i64_idx(<vscale x 8 x i64> %v, i32 %idx) {
; CHECK-LABEL: extractelt_nxv8i64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a1, v8
; CHECK-NEXT:    ret
  %r = extractelement <vscale x 8 x i64> %v, i32 %idx
  ret i64 %r
}
