; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x i16> @vsext_nxv1i8_nxv1i16(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vsext_nxv1i8_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 1 x i8> %va to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %evec
}

define <vscale x 1 x i16> @vzext_nxv1i8_nxv1i16(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vzext_nxv1i8_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vzext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 1 x i8> %va to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %evec
}

define <vscale x 1 x i32> @vsext_nxv1i8_nxv1i32(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vsext_nxv1i8_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vsext.vf4 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 1 x i8> %va to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %evec
}

define <vscale x 1 x i32> @vzext_nxv1i8_nxv1i32(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vzext_nxv1i8_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vzext.vf4 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 1 x i8> %va to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %evec
}

define <vscale x 1 x i64> @vsext_nxv1i8_nxv1i64(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vsext_nxv1i8_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsext.vf8 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 1 x i8> %va to <vscale x 1 x i64>
  ret <vscale x 1 x i64> %evec
}

define <vscale x 1 x i64> @vzext_nxv1i8_nxv1i64(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vzext_nxv1i8_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vzext.vf8 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 1 x i8> %va to <vscale x 1 x i64>
  ret <vscale x 1 x i64> %evec
}

define <vscale x 2 x i16> @vsext_nxv2i8_nxv2i16(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vsext_nxv2i8_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 2 x i8> %va to <vscale x 2 x i16>
  ret <vscale x 2 x i16> %evec
}

define <vscale x 2 x i16> @vzext_nxv2i8_nxv2i16(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vzext_nxv2i8_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vzext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 2 x i8> %va to <vscale x 2 x i16>
  ret <vscale x 2 x i16> %evec
}

define <vscale x 2 x i32> @vsext_nxv2i8_nxv2i32(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vsext_nxv2i8_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vsext.vf4 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 2 x i8> %va to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %evec
}

define <vscale x 2 x i32> @vzext_nxv2i8_nxv2i32(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vzext_nxv2i8_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vzext.vf4 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 2 x i8> %va to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %evec
}

define <vscale x 2 x i64> @vsext_nxv2i8_nxv2i64(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vsext_nxv2i8_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsext.vf8 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = sext <vscale x 2 x i8> %va to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %evec
}

define <vscale x 2 x i64> @vzext_nxv2i8_nxv2i64(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vzext_nxv2i8_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vzext.vf8 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = zext <vscale x 2 x i8> %va to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %evec
}

define <vscale x 4 x i16> @vsext_nxv4i8_nxv4i16(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vsext_nxv4i8_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 4 x i8> %va to <vscale x 4 x i16>
  ret <vscale x 4 x i16> %evec
}

define <vscale x 4 x i16> @vzext_nxv4i8_nxv4i16(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vzext_nxv4i8_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; CHECK-NEXT:    vzext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 4 x i8> %va to <vscale x 4 x i16>
  ret <vscale x 4 x i16> %evec
}

define <vscale x 4 x i32> @vsext_nxv4i8_nxv4i32(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vsext_nxv4i8_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vsext.vf4 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = sext <vscale x 4 x i8> %va to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %evec
}

define <vscale x 4 x i32> @vzext_nxv4i8_nxv4i32(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vzext_nxv4i8_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vzext.vf4 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = zext <vscale x 4 x i8> %va to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %evec
}

define <vscale x 4 x i64> @vsext_nxv4i8_nxv4i64(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vsext_nxv4i8_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsext.vf8 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = sext <vscale x 4 x i8> %va to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %evec
}

define <vscale x 4 x i64> @vzext_nxv4i8_nxv4i64(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vzext_nxv4i8_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vzext.vf8 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = zext <vscale x 4 x i8> %va to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %evec
}

define <vscale x 8 x i16> @vsext_nxv8i8_nxv8i16(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vsext_nxv8i8_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; CHECK-NEXT:    vsext.vf2 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = sext <vscale x 8 x i8> %va to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %evec
}

define <vscale x 8 x i16> @vzext_nxv8i8_nxv8i16(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vzext_nxv8i8_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; CHECK-NEXT:    vzext.vf2 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = zext <vscale x 8 x i8> %va to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %evec
}

define <vscale x 8 x i32> @vsext_nxv8i8_nxv8i32(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vsext_nxv8i8_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vsext.vf4 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = sext <vscale x 8 x i8> %va to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %evec
}

define <vscale x 8 x i32> @vzext_nxv8i8_nxv8i32(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vzext_nxv8i8_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vzext.vf4 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = zext <vscale x 8 x i8> %va to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %evec
}

define <vscale x 8 x i64> @vsext_nxv8i8_nxv8i64(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vsext_nxv8i8_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsext.vf8 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = sext <vscale x 8 x i8> %va to <vscale x 8 x i64>
  ret <vscale x 8 x i64> %evec
}

define <vscale x 8 x i64> @vzext_nxv8i8_nxv8i64(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vzext_nxv8i8_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vzext.vf8 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = zext <vscale x 8 x i8> %va to <vscale x 8 x i64>
  ret <vscale x 8 x i64> %evec
}

define <vscale x 16 x i16> @vsext_nxv16i8_nxv16i16(<vscale x 16 x i8> %va) {
; CHECK-LABEL: vsext_nxv16i8_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; CHECK-NEXT:    vsext.vf2 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = sext <vscale x 16 x i8> %va to <vscale x 16 x i16>
  ret <vscale x 16 x i16> %evec
}

define <vscale x 16 x i16> @vzext_nxv16i8_nxv16i16(<vscale x 16 x i8> %va) {
; CHECK-LABEL: vzext_nxv16i8_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; CHECK-NEXT:    vzext.vf2 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = zext <vscale x 16 x i8> %va to <vscale x 16 x i16>
  ret <vscale x 16 x i16> %evec
}

define <vscale x 16 x i32> @vsext_nxv16i8_nxv16i32(<vscale x 16 x i8> %va) {
; CHECK-LABEL: vsext_nxv16i8_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vsext.vf4 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = sext <vscale x 16 x i8> %va to <vscale x 16 x i32>
  ret <vscale x 16 x i32> %evec
}

define <vscale x 16 x i32> @vzext_nxv16i8_nxv16i32(<vscale x 16 x i8> %va) {
; CHECK-LABEL: vzext_nxv16i8_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vzext.vf4 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = zext <vscale x 16 x i8> %va to <vscale x 16 x i32>
  ret <vscale x 16 x i32> %evec
}

define <vscale x 32 x i16> @vsext_nxv32i8_nxv32i16(<vscale x 32 x i8> %va) {
; CHECK-LABEL: vsext_nxv32i8_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = sext <vscale x 32 x i8> %va to <vscale x 32 x i16>
  ret <vscale x 32 x i16> %evec
}

define <vscale x 32 x i16> @vzext_nxv32i8_nxv32i16(<vscale x 32 x i8> %va) {
; CHECK-LABEL: vzext_nxv32i8_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, mu
; CHECK-NEXT:    vzext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = zext <vscale x 32 x i8> %va to <vscale x 32 x i16>
  ret <vscale x 32 x i16> %evec
}

define <vscale x 1 x i32> @vsext_nxv1i16_nxv1i32(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vsext_nxv1i16_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 1 x i16> %va to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %evec
}

define <vscale x 1 x i32> @vzext_nxv1i16_nxv1i32(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vzext_nxv1i16_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vzext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 1 x i16> %va to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %evec
}

define <vscale x 1 x i64> @vsext_nxv1i16_nxv1i64(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vsext_nxv1i16_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsext.vf4 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 1 x i16> %va to <vscale x 1 x i64>
  ret <vscale x 1 x i64> %evec
}

define <vscale x 1 x i64> @vzext_nxv1i16_nxv1i64(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vzext_nxv1i16_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vzext.vf4 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 1 x i16> %va to <vscale x 1 x i64>
  ret <vscale x 1 x i64> %evec
}

define <vscale x 2 x i32> @vsext_nxv2i16_nxv2i32(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vsext_nxv2i16_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 2 x i16> %va to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %evec
}

define <vscale x 2 x i32> @vzext_nxv2i16_nxv2i32(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vzext_nxv2i16_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vzext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 2 x i16> %va to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %evec
}

define <vscale x 2 x i64> @vsext_nxv2i16_nxv2i64(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vsext_nxv2i16_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsext.vf4 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = sext <vscale x 2 x i16> %va to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %evec
}

define <vscale x 2 x i64> @vzext_nxv2i16_nxv2i64(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vzext_nxv2i16_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vzext.vf4 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = zext <vscale x 2 x i16> %va to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %evec
}

define <vscale x 4 x i32> @vsext_nxv4i16_nxv4i32(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vsext_nxv4i16_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vsext.vf2 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = sext <vscale x 4 x i16> %va to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %evec
}

define <vscale x 4 x i32> @vzext_nxv4i16_nxv4i32(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vzext_nxv4i16_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vzext.vf2 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = zext <vscale x 4 x i16> %va to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %evec
}

define <vscale x 4 x i64> @vsext_nxv4i16_nxv4i64(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vsext_nxv4i16_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsext.vf4 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = sext <vscale x 4 x i16> %va to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %evec
}

define <vscale x 4 x i64> @vzext_nxv4i16_nxv4i64(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vzext_nxv4i16_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vzext.vf4 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = zext <vscale x 4 x i16> %va to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %evec
}

define <vscale x 8 x i32> @vsext_nxv8i16_nxv8i32(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vsext_nxv8i16_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vsext.vf2 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = sext <vscale x 8 x i16> %va to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %evec
}

define <vscale x 8 x i32> @vzext_nxv8i16_nxv8i32(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vzext_nxv8i16_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vzext.vf2 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = zext <vscale x 8 x i16> %va to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %evec
}

define <vscale x 8 x i64> @vsext_nxv8i16_nxv8i64(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vsext_nxv8i16_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsext.vf4 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = sext <vscale x 8 x i16> %va to <vscale x 8 x i64>
  ret <vscale x 8 x i64> %evec
}

define <vscale x 8 x i64> @vzext_nxv8i16_nxv8i64(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vzext_nxv8i16_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vzext.vf4 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = zext <vscale x 8 x i16> %va to <vscale x 8 x i64>
  ret <vscale x 8 x i64> %evec
}

define <vscale x 16 x i32> @vsext_nxv16i16_nxv16i32(<vscale x 16 x i16> %va) {
; CHECK-LABEL: vsext_nxv16i16_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = sext <vscale x 16 x i16> %va to <vscale x 16 x i32>
  ret <vscale x 16 x i32> %evec
}

define <vscale x 16 x i32> @vzext_nxv16i16_nxv16i32(<vscale x 16 x i16> %va) {
; CHECK-LABEL: vzext_nxv16i16_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vzext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = zext <vscale x 16 x i16> %va to <vscale x 16 x i32>
  ret <vscale x 16 x i32> %evec
}

define <vscale x 1 x i64> @vsext_nxv1i32_nxv1i64(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vsext_nxv1i32_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  ret <vscale x 1 x i64> %evec
}

define <vscale x 1 x i64> @vzext_nxv1i32_nxv1i64(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vzext_nxv1i32_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vzext.vf2 v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %evec = zext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  ret <vscale x 1 x i64> %evec
}

define <vscale x 2 x i64> @vsext_nxv2i32_nxv2i64(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vsext_nxv2i32_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsext.vf2 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %evec
}

define <vscale x 2 x i64> @vzext_nxv2i32_nxv2i64(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vzext_nxv2i32_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vzext.vf2 v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %evec = zext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %evec
}

define <vscale x 4 x i64> @vsext_nxv4i32_nxv4i64(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vsext_nxv4i32_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsext.vf2 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %evec
}

define <vscale x 4 x i64> @vzext_nxv4i32_nxv4i64(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vzext_nxv4i32_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vzext.vf2 v12, v8
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %evec = zext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  ret <vscale x 4 x i64> %evec
}

define <vscale x 8 x i64> @vsext_nxv8i32_nxv8i64(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vsext_nxv8i32_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  ret <vscale x 8 x i64> %evec
}

define <vscale x 8 x i64> @vzext_nxv8i32_nxv8i64(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vzext_nxv8i32_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vzext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %evec = zext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  ret <vscale x 8 x i64> %evec
}

