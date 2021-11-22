; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x i8> @vsra_vv_nxv1i8(<vscale x 1 x i8> %va, <vscale x 1 x i8> %vb) {
; CHECK-LABEL: vsra_vv_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 1 x i8> %va, %vb
  ret <vscale x 1 x i8> %vc
}

define <vscale x 1 x i8> @vsra_vx_nxv1i8(<vscale x 1 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vsra_vx_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 1 x i8> %head, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i8> %va, %splat
  ret <vscale x 1 x i8> %vc
}

define <vscale x 1 x i8> @vsra_vi_nxv1i8_0(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vsra_vi_nxv1i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i8> undef, i8 6, i32 0
  %splat = shufflevector <vscale x 1 x i8> %head, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i8> %va, %splat
  ret <vscale x 1 x i8> %vc
}

define <vscale x 2 x i8> @vsra_vv_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i8> %vb) {
; CHECK-LABEL: vsra_vv_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 2 x i8> %va, %vb
  ret <vscale x 2 x i8> %vc
}

define <vscale x 2 x i8> @vsra_vx_nxv2i8(<vscale x 2 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vsra_vx_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 2 x i8> %head, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i8> %va, %splat
  ret <vscale x 2 x i8> %vc
}

define <vscale x 2 x i8> @vsra_vi_nxv2i8_0(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vsra_vi_nxv2i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i8> undef, i8 6, i32 0
  %splat = shufflevector <vscale x 2 x i8> %head, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i8> %va, %splat
  ret <vscale x 2 x i8> %vc
}

define <vscale x 4 x i8> @vsra_vv_nxv4i8(<vscale x 4 x i8> %va, <vscale x 4 x i8> %vb) {
; CHECK-LABEL: vsra_vv_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 4 x i8> %va, %vb
  ret <vscale x 4 x i8> %vc
}

define <vscale x 4 x i8> @vsra_vx_nxv4i8(<vscale x 4 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vsra_vx_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 4 x i8> %head, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i8> %va, %splat
  ret <vscale x 4 x i8> %vc
}

define <vscale x 4 x i8> @vsra_vi_nxv4i8_0(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vsra_vi_nxv4i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i8> undef, i8 6, i32 0
  %splat = shufflevector <vscale x 4 x i8> %head, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i8> %va, %splat
  ret <vscale x 4 x i8> %vc
}

define <vscale x 8 x i8> @vsra_vv_nxv8i8(<vscale x 8 x i8> %va, <vscale x 8 x i8> %vb) {
; CHECK-LABEL: vsra_vv_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m1, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 8 x i8> %va, %vb
  ret <vscale x 8 x i8> %vc
}

define <vscale x 8 x i8> @vsra_vx_nxv8i8(<vscale x 8 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vsra_vx_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 8 x i8> %head, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i8> %va, %splat
  ret <vscale x 8 x i8> %vc
}

define <vscale x 8 x i8> @vsra_vi_nxv8i8_0(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vsra_vi_nxv8i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m1, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i8> undef, i8 6, i32 0
  %splat = shufflevector <vscale x 8 x i8> %head, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i8> %va, %splat
  ret <vscale x 8 x i8> %vc
}

define <vscale x 16 x i8> @vsra_vv_nxv16i8(<vscale x 16 x i8> %va, <vscale x 16 x i8> %vb) {
; CHECK-LABEL: vsra_vv_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m2, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 16 x i8> %va, %vb
  ret <vscale x 16 x i8> %vc
}

define <vscale x 16 x i8> @vsra_vx_nxv16i8(<vscale x 16 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vsra_vx_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 16 x i8> %head, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %vc = ashr <vscale x 16 x i8> %va, %splat
  ret <vscale x 16 x i8> %vc
}

define <vscale x 16 x i8> @vsra_vi_nxv16i8_0(<vscale x 16 x i8> %va) {
; CHECK-LABEL: vsra_vi_nxv16i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m2, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i8> undef, i8 6, i32 0
  %splat = shufflevector <vscale x 16 x i8> %head, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %vc = ashr <vscale x 16 x i8> %va, %splat
  ret <vscale x 16 x i8> %vc
}

define <vscale x 32 x i8> @vsra_vv_nxv32i8(<vscale x 32 x i8> %va, <vscale x 32 x i8> %vb) {
; CHECK-LABEL: vsra_vv_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m4, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 32 x i8> %va, %vb
  ret <vscale x 32 x i8> %vc
}

define <vscale x 32 x i8> @vsra_vx_nxv32i8(<vscale x 32 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vsra_vx_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 32 x i8> %head, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %vc = ashr <vscale x 32 x i8> %va, %splat
  ret <vscale x 32 x i8> %vc
}

define <vscale x 32 x i8> @vsra_vi_nxv32i8_0(<vscale x 32 x i8> %va) {
; CHECK-LABEL: vsra_vi_nxv32i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m4, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i8> undef, i8 6, i32 0
  %splat = shufflevector <vscale x 32 x i8> %head, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %vc = ashr <vscale x 32 x i8> %va, %splat
  ret <vscale x 32 x i8> %vc
}

define <vscale x 64 x i8> @vsra_vv_nxv64i8(<vscale x 64 x i8> %va, <vscale x 64 x i8> %vb) {
; CHECK-LABEL: vsra_vv_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m8, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 64 x i8> %va, %vb
  ret <vscale x 64 x i8> %vc
}

define <vscale x 64 x i8> @vsra_vx_nxv64i8(<vscale x 64 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vsra_vx_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 64 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 64 x i8> %head, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
  %vc = ashr <vscale x 64 x i8> %va, %splat
  ret <vscale x 64 x i8> %vc
}

define <vscale x 64 x i8> @vsra_vi_nxv64i8_0(<vscale x 64 x i8> %va) {
; CHECK-LABEL: vsra_vi_nxv64i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m8, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 64 x i8> undef, i8 6, i32 0
  %splat = shufflevector <vscale x 64 x i8> %head, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
  %vc = ashr <vscale x 64 x i8> %va, %splat
  ret <vscale x 64 x i8> %vc
}

define <vscale x 1 x i16> @vsra_vv_nxv1i16(<vscale x 1 x i16> %va, <vscale x 1 x i16> %vb) {
; CHECK-LABEL: vsra_vv_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 1 x i16> %va, %vb
  ret <vscale x 1 x i16> %vc
}

define <vscale x 1 x i16> @vsra_vx_nxv1i16(<vscale x 1 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vsra_vx_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 1 x i16> %head, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i16> %va, %splat
  ret <vscale x 1 x i16> %vc
}

define <vscale x 1 x i16> @vsra_vi_nxv1i16_0(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vsra_vi_nxv1i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i16> undef, i16 6, i32 0
  %splat = shufflevector <vscale x 1 x i16> %head, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i16> %va, %splat
  ret <vscale x 1 x i16> %vc
}

define <vscale x 2 x i16> @vsra_vv_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i16> %vb) {
; CHECK-LABEL: vsra_vv_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 2 x i16> %va, %vb
  ret <vscale x 2 x i16> %vc
}

define <vscale x 2 x i16> @vsra_vx_nxv2i16(<vscale x 2 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vsra_vx_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 2 x i16> %head, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i16> %va, %splat
  ret <vscale x 2 x i16> %vc
}

define <vscale x 2 x i16> @vsra_vi_nxv2i16_0(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vsra_vi_nxv2i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i16> undef, i16 6, i32 0
  %splat = shufflevector <vscale x 2 x i16> %head, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i16> %va, %splat
  ret <vscale x 2 x i16> %vc
}

define <vscale x 4 x i16> @vsra_vv_nxv4i16(<vscale x 4 x i16> %va, <vscale x 4 x i16> %vb) {
; CHECK-LABEL: vsra_vv_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 4 x i16> %va, %vb
  ret <vscale x 4 x i16> %vc
}

define <vscale x 4 x i16> @vsra_vx_nxv4i16(<vscale x 4 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vsra_vx_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 4 x i16> %head, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i16> %va, %splat
  ret <vscale x 4 x i16> %vc
}

define <vscale x 4 x i16> @vsra_vi_nxv4i16_0(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vsra_vi_nxv4i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i16> undef, i16 6, i32 0
  %splat = shufflevector <vscale x 4 x i16> %head, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i16> %va, %splat
  ret <vscale x 4 x i16> %vc
}

define <vscale x 8 x i16> @vsra_vv_nxv8i16(<vscale x 8 x i16> %va, <vscale x 8 x i16> %vb) {
; CHECK-LABEL: vsra_vv_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 8 x i16> %va, %vb
  ret <vscale x 8 x i16> %vc
}

define <vscale x 8 x i16> @vsra_vx_nxv8i16(<vscale x 8 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vsra_vx_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 8 x i16> %head, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i16> %va, %splat
  ret <vscale x 8 x i16> %vc
}

define <vscale x 8 x i16> @vsra_vi_nxv8i16_0(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vsra_vi_nxv8i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i16> undef, i16 6, i32 0
  %splat = shufflevector <vscale x 8 x i16> %head, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i16> %va, %splat
  ret <vscale x 8 x i16> %vc
}

define <vscale x 16 x i16> @vsra_vv_nxv16i16(<vscale x 16 x i16> %va, <vscale x 16 x i16> %vb) {
; CHECK-LABEL: vsra_vv_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 16 x i16> %va, %vb
  ret <vscale x 16 x i16> %vc
}

define <vscale x 16 x i16> @vsra_vx_nxv16i16(<vscale x 16 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vsra_vx_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m4, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 16 x i16> %head, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %vc = ashr <vscale x 16 x i16> %va, %splat
  ret <vscale x 16 x i16> %vc
}

define <vscale x 16 x i16> @vsra_vi_nxv16i16_0(<vscale x 16 x i16> %va) {
; CHECK-LABEL: vsra_vi_nxv16i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i16> undef, i16 6, i32 0
  %splat = shufflevector <vscale x 16 x i16> %head, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %vc = ashr <vscale x 16 x i16> %va, %splat
  ret <vscale x 16 x i16> %vc
}

define <vscale x 32 x i16> @vsra_vv_nxv32i16(<vscale x 32 x i16> %va, <vscale x 32 x i16> %vb) {
; CHECK-LABEL: vsra_vv_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 32 x i16> %va, %vb
  ret <vscale x 32 x i16> %vc
}

define <vscale x 32 x i16> @vsra_vx_nxv32i16(<vscale x 32 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vsra_vx_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m8, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 32 x i16> %head, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
  %vc = ashr <vscale x 32 x i16> %va, %splat
  ret <vscale x 32 x i16> %vc
}

define <vscale x 32 x i16> @vsra_vi_nxv32i16_0(<vscale x 32 x i16> %va) {
; CHECK-LABEL: vsra_vi_nxv32i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 6
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i16> undef, i16 6, i32 0
  %splat = shufflevector <vscale x 32 x i16> %head, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
  %vc = ashr <vscale x 32 x i16> %va, %splat
  ret <vscale x 32 x i16> %vc
}

define <vscale x 1 x i32> @vsra_vv_nxv1i32(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb) {
; CHECK-LABEL: vsra_vv_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 1 x i32> %va, %vb
  ret <vscale x 1 x i32> %vc
}

define <vscale x 1 x i32> @vsra_vx_nxv1i32(<vscale x 1 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vsra_vx_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i32> %va, %splat
  ret <vscale x 1 x i32> %vc
}

define <vscale x 1 x i32> @vsra_vi_nxv1i32_0(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vsra_vi_nxv1i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 31, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i32> %va, %splat
  ret <vscale x 1 x i32> %vc
}

define <vscale x 2 x i32> @vsra_vv_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb) {
; CHECK-LABEL: vsra_vv_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 2 x i32> %va, %vb
  ret <vscale x 2 x i32> %vc
}

define <vscale x 2 x i32> @vsra_vx_nxv2i32(<vscale x 2 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vsra_vx_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i32> %va, %splat
  ret <vscale x 2 x i32> %vc
}

define <vscale x 2 x i32> @vsra_vi_nxv2i32_0(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vsra_vi_nxv2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 31, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i32> %va, %splat
  ret <vscale x 2 x i32> %vc
}

define <vscale x 4 x i32> @vsra_vv_nxv4i32(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb) {
; CHECK-LABEL: vsra_vv_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 4 x i32> %va, %vb
  ret <vscale x 4 x i32> %vc
}

define <vscale x 4 x i32> @vsra_vx_nxv4i32(<vscale x 4 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vsra_vx_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i32> %va, %splat
  ret <vscale x 4 x i32> %vc
}

define <vscale x 4 x i32> @vsra_vi_nxv4i32_0(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vsra_vi_nxv4i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 31, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i32> %va, %splat
  ret <vscale x 4 x i32> %vc
}

define <vscale x 8 x i32> @vsra_vv_nxv8i32(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb) {
; CHECK-LABEL: vsra_vv_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 8 x i32> %va, %vb
  ret <vscale x 8 x i32> %vc
}

define <vscale x 8 x i32> @vsra_vx_nxv8i32(<vscale x 8 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vsra_vx_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i32> %va, %splat
  ret <vscale x 8 x i32> %vc
}

define <vscale x 8 x i32> @vsra_vi_nxv8i32_0(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vsra_vi_nxv8i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 31, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i32> %va, %splat
  ret <vscale x 8 x i32> %vc
}

define <vscale x 16 x i32> @vsra_vv_nxv16i32(<vscale x 16 x i32> %va, <vscale x 16 x i32> %vb) {
; CHECK-LABEL: vsra_vv_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 16 x i32> %va, %vb
  ret <vscale x 16 x i32> %vc
}

define <vscale x 16 x i32> @vsra_vx_nxv16i32(<vscale x 16 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vsra_vx_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m8, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 16 x i32> %head, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
  %vc = ashr <vscale x 16 x i32> %va, %splat
  ret <vscale x 16 x i32> %vc
}

define <vscale x 16 x i32> @vsra_vi_nxv16i32_0(<vscale x 16 x i32> %va) {
; CHECK-LABEL: vsra_vi_nxv16i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i32> undef, i32 31, i32 0
  %splat = shufflevector <vscale x 16 x i32> %head, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
  %vc = ashr <vscale x 16 x i32> %va, %splat
  ret <vscale x 16 x i32> %vc
}

define <vscale x 1 x i64> @vsra_vv_nxv1i64(<vscale x 1 x i64> %va, <vscale x 1 x i64> %vb) {
; CHECK-LABEL: vsra_vv_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 1 x i64> %va, %vb
  ret <vscale x 1 x i64> %vc
}

define <vscale x 1 x i64> @vsra_vx_nxv1i64(<vscale x 1 x i64> %va, i64 %b) {
; CHECK-LABEL: vsra_vx_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i64> %va, %splat
  ret <vscale x 1 x i64> %vc
}

define <vscale x 1 x i64> @vsra_vi_nxv1i64_0(<vscale x 1 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv1i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 31, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i64> %va, %splat
  ret <vscale x 1 x i64> %vc
}

define <vscale x 1 x i64> @vsra_vi_nxv1i64_1(<vscale x 1 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv1i64_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vc = ashr <vscale x 1 x i64> %va, %splat
  ret <vscale x 1 x i64> %vc
}

define <vscale x 2 x i64> @vsra_vv_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i64> %vb) {
; CHECK-LABEL: vsra_vv_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 2 x i64> %va, %vb
  ret <vscale x 2 x i64> %vc
}

define <vscale x 2 x i64> @vsra_vx_nxv2i64(<vscale x 2 x i64> %va, i64 %b) {
; CHECK-LABEL: vsra_vx_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i64> %va, %splat
  ret <vscale x 2 x i64> %vc
}

define <vscale x 2 x i64> @vsra_vi_nxv2i64_0(<vscale x 2 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv2i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 31, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i64> %va, %splat
  ret <vscale x 2 x i64> %vc
}

define <vscale x 2 x i64> @vsra_vi_nxv2i64_1(<vscale x 2 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv2i64_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli a1, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vc = ashr <vscale x 2 x i64> %va, %splat
  ret <vscale x 2 x i64> %vc
}

define <vscale x 4 x i64> @vsra_vv_nxv4i64(<vscale x 4 x i64> %va, <vscale x 4 x i64> %vb) {
; CHECK-LABEL: vsra_vv_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 4 x i64> %va, %vb
  ret <vscale x 4 x i64> %vc
}

define <vscale x 4 x i64> @vsra_vx_nxv4i64(<vscale x 4 x i64> %va, i64 %b) {
; CHECK-LABEL: vsra_vx_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i64> %va, %splat
  ret <vscale x 4 x i64> %vc
}

define <vscale x 4 x i64> @vsra_vi_nxv4i64_0(<vscale x 4 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv4i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 31, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i64> %va, %splat
  ret <vscale x 4 x i64> %vc
}

define <vscale x 4 x i64> @vsra_vi_nxv4i64_1(<vscale x 4 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv4i64_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli a1, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vc = ashr <vscale x 4 x i64> %va, %splat
  ret <vscale x 4 x i64> %vc
}

define <vscale x 8 x i64> @vsra_vv_nxv8i64(<vscale x 8 x i64> %va, <vscale x 8 x i64> %vb) {
; CHECK-LABEL: vsra_vv_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsra.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = ashr <vscale x 8 x i64> %va, %vb
  ret <vscale x 8 x i64> %vc
}

define <vscale x 8 x i64> @vsra_vx_nxv8i64(<vscale x 8 x i64> %va, i64 %b) {
; CHECK-LABEL: vsra_vx_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i64> %va, %splat
  ret <vscale x 8 x i64> %vc
}

define <vscale x 8 x i64> @vsra_vi_nxv8i64_0(<vscale x 8 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv8i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsra.vi v8, v8, 31
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 31, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i64> %va, %splat
  ret <vscale x 8 x i64> %vc
}

define <vscale x 8 x i64> @vsra_vi_nxv8i64_1(<vscale x 8 x i64> %va) {
; CHECK-LABEL: vsra_vi_nxv8i64_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli a1, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsra.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vc = ashr <vscale x 8 x i64> %va, %splat
  ret <vscale x 8 x i64> %vc
}

