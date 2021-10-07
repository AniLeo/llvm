; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -target-abi=ilp32 \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -target-abi=lp64 \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

; This tests a mix of vmacc and vmsub by using different operand orders to
; trigger commuting in TwosubressInstructionPass.

define <vscale x 1 x i8> @vnmsub_vv_nxv1i8(<vscale x 1 x i8> %va, <vscale x 1 x i8> %vb, <vscale x 1 x i8> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v9, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 1 x i8> %va, %vb
  %y = sub <vscale x 1 x i8> %vc, %x
  ret <vscale x 1 x i8> %y
}

define <vscale x 1 x i8> @vnmsub_vx_nxv1i8(<vscale x 1 x i8> %va, <vscale x 1 x i8> %vb, i8 %c) {
; CHECK-LABEL: vnmsub_vx_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i8> undef, i8 %c, i32 0
  %splat = shufflevector <vscale x 1 x i8> %head, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %x = mul <vscale x 1 x i8> %va, %splat
  %y = sub <vscale x 1 x i8> %vb, %x
  ret <vscale x 1 x i8> %y
}

define <vscale x 2 x i8> @vnmsub_vv_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i8> %vb, <vscale x 2 x i8> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v10, v9
; CHECK-NEXT:    ret
  %x = mul <vscale x 2 x i8> %va, %vc
  %y = sub <vscale x 2 x i8> %vb, %x
  ret <vscale x 2 x i8> %y
}

define <vscale x 2 x i8> @vnmsub_vx_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i8> %vb, i8 %c) {
; CHECK-LABEL: vnmsub_vx_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i8> undef, i8 %c, i32 0
  %splat = shufflevector <vscale x 2 x i8> %head, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %x = mul <vscale x 2 x i8> %vb, %splat
  %y = sub <vscale x 2 x i8> %va, %x
  ret <vscale x 2 x i8> %y
}

define <vscale x 4 x i8> @vnmsub_vv_nxv4i8(<vscale x 4 x i8> %va, <vscale x 4 x i8> %vb, <vscale x 4 x i8> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v9, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 4 x i8> %vb, %va
  %y = sub <vscale x 4 x i8> %vc, %x
  ret <vscale x 4 x i8> %y
}

define <vscale x 4 x i8> @vnmsub_vx_nxv4i8(<vscale x 4 x i8> %va, <vscale x 4 x i8> %vb, i8 %c) {
; CHECK-LABEL: vnmsub_vx_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i8> undef, i8 %c, i32 0
  %splat = shufflevector <vscale x 4 x i8> %head, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %x = mul <vscale x 4 x i8> %va, %splat
  %y = sub <vscale x 4 x i8> %vb, %x
  ret <vscale x 4 x i8> %y
}

define <vscale x 8 x i8> @vnmsub_vv_nxv8i8(<vscale x 8 x i8> %va, <vscale x 8 x i8> %vb, <vscale x 8 x i8> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m1, ta, mu
; CHECK-NEXT:    vnmsac.vv v8, v10, v9
; CHECK-NEXT:    ret
  %x = mul <vscale x 8 x i8> %vb, %vc
  %y = sub <vscale x 8 x i8> %va, %x
  ret <vscale x 8 x i8> %y
}

define <vscale x 8 x i8> @vnmsub_vx_nxv8i8(<vscale x 8 x i8> %va, <vscale x 8 x i8> %vb, i8 %c) {
; CHECK-LABEL: vnmsub_vx_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i8> undef, i8 %c, i32 0
  %splat = shufflevector <vscale x 8 x i8> %head, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %x = mul <vscale x 8 x i8> %vb, %splat
  %y = sub <vscale x 8 x i8> %va, %x
  ret <vscale x 8 x i8> %y
}

define <vscale x 16 x i8> @vnmsub_vv_nxv16i8(<vscale x 16 x i8> %va, <vscale x 16 x i8> %vb, <vscale x 16 x i8> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m2, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v12, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 16 x i8> %vc, %va
  %y = sub <vscale x 16 x i8> %vb, %x
  ret <vscale x 16 x i8> %y
}

define <vscale x 16 x i8> @vnmsub_vx_nxv16i8(<vscale x 16 x i8> %va, <vscale x 16 x i8> %vb, i8 %c) {
; CHECK-LABEL: vnmsub_vx_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m2, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i8> undef, i8 %c, i32 0
  %splat = shufflevector <vscale x 16 x i8> %head, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %x = mul <vscale x 16 x i8> %va, %splat
  %y = sub <vscale x 16 x i8> %vb, %x
  ret <vscale x 16 x i8> %y
}

define <vscale x 32 x i8> @vnmsub_vv_nxv32i8(<vscale x 32 x i8> %va, <vscale x 32 x i8> %vb, <vscale x 32 x i8> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m4, ta, mu
; CHECK-NEXT:    vnmsac.vv v8, v16, v12
; CHECK-NEXT:    ret
  %x = mul <vscale x 32 x i8> %vc, %vb
  %y = sub <vscale x 32 x i8> %va, %x
  ret <vscale x 32 x i8> %y
}

define <vscale x 32 x i8> @vnmsub_vx_nxv32i8(<vscale x 32 x i8> %va, <vscale x 32 x i8> %vb, i8 %c) {
; CHECK-LABEL: vnmsub_vx_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i8> undef, i8 %c, i32 0
  %splat = shufflevector <vscale x 32 x i8> %head, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %x = mul <vscale x 32 x i8> %vb, %splat
  %y = sub <vscale x 32 x i8> %va, %x
  ret <vscale x 32 x i8> %y
}

define <vscale x 64 x i8> @vnmsub_vv_nxv64i8(<vscale x 64 x i8> %va, <vscale x 64 x i8> %vb, <vscale x 64 x i8> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8r.v v24, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e8, m8, ta, mu
; CHECK-NEXT:    vnmsac.vv v8, v16, v24
; CHECK-NEXT:    ret
  %x = mul <vscale x 64 x i8> %vc, %vb
  %y = sub <vscale x 64 x i8> %va, %x
  ret <vscale x 64 x i8> %y
}

define <vscale x 64 x i8> @vnmsub_vx_nxv64i8(<vscale x 64 x i8> %va, <vscale x 64 x i8> %vb, i8 %c) {
; CHECK-LABEL: vnmsub_vx_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 64 x i8> undef, i8 %c, i32 0
  %splat = shufflevector <vscale x 64 x i8> %head, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
  %x = mul <vscale x 64 x i8> %vb, %splat
  %y = sub <vscale x 64 x i8> %va, %x
  ret <vscale x 64 x i8> %y
}

define <vscale x 1 x i16> @vnmsub_vv_nxv1i16(<vscale x 1 x i16> %va, <vscale x 1 x i16> %vb, <vscale x 1 x i16> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v9, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 1 x i16> %va, %vb
  %y = sub <vscale x 1 x i16> %vc, %x
  ret <vscale x 1 x i16> %y
}

define <vscale x 1 x i16> @vnmsub_vx_nxv1i16(<vscale x 1 x i16> %va, <vscale x 1 x i16> %vb, i16 %c) {
; CHECK-LABEL: vnmsub_vx_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i16> undef, i16 %c, i32 0
  %splat = shufflevector <vscale x 1 x i16> %head, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %x = mul <vscale x 1 x i16> %va, %splat
  %y = sub <vscale x 1 x i16> %vb, %x
  ret <vscale x 1 x i16> %y
}

define <vscale x 2 x i16> @vnmsub_vv_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i16> %vb, <vscale x 2 x i16> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v10, v9
; CHECK-NEXT:    ret
  %x = mul <vscale x 2 x i16> %va, %vc
  %y = sub <vscale x 2 x i16> %vb, %x
  ret <vscale x 2 x i16> %y
}

define <vscale x 2 x i16> @vnmsub_vx_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i16> %vb, i16 %c) {
; CHECK-LABEL: vnmsub_vx_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i16> undef, i16 %c, i32 0
  %splat = shufflevector <vscale x 2 x i16> %head, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %x = mul <vscale x 2 x i16> %vb, %splat
  %y = sub <vscale x 2 x i16> %va, %x
  ret <vscale x 2 x i16> %y
}

define <vscale x 4 x i16> @vnmsub_vv_nxv4i16(<vscale x 4 x i16> %va, <vscale x 4 x i16> %vb, <vscale x 4 x i16> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v9, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 4 x i16> %vb, %va
  %y = sub <vscale x 4 x i16> %vc, %x
  ret <vscale x 4 x i16> %y
}

define <vscale x 4 x i16> @vnmsub_vx_nxv4i16(<vscale x 4 x i16> %va, <vscale x 4 x i16> %vb, i16 %c) {
; CHECK-LABEL: vnmsub_vx_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i16> undef, i16 %c, i32 0
  %splat = shufflevector <vscale x 4 x i16> %head, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %x = mul <vscale x 4 x i16> %va, %splat
  %y = sub <vscale x 4 x i16> %vb, %x
  ret <vscale x 4 x i16> %y
}

define <vscale x 8 x i16> @vnmsub_vv_nxv8i16(<vscale x 8 x i16> %va, <vscale x 8 x i16> %vb, <vscale x 8 x i16> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; CHECK-NEXT:    vnmsac.vv v8, v12, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 8 x i16> %vb, %vc
  %y = sub <vscale x 8 x i16> %va, %x
  ret <vscale x 8 x i16> %y
}

define <vscale x 8 x i16> @vnmsub_vx_nxv8i16(<vscale x 8 x i16> %va, <vscale x 8 x i16> %vb, i16 %c) {
; CHECK-LABEL: vnmsub_vx_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m2, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i16> undef, i16 %c, i32 0
  %splat = shufflevector <vscale x 8 x i16> %head, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %x = mul <vscale x 8 x i16> %vb, %splat
  %y = sub <vscale x 8 x i16> %va, %x
  ret <vscale x 8 x i16> %y
}

define <vscale x 16 x i16> @vnmsub_vv_nxv16i16(<vscale x 16 x i16> %va, <vscale x 16 x i16> %vb, <vscale x 16 x i16> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v16, v12
; CHECK-NEXT:    ret
  %x = mul <vscale x 16 x i16> %vc, %va
  %y = sub <vscale x 16 x i16> %vb, %x
  ret <vscale x 16 x i16> %y
}

define <vscale x 16 x i16> @vnmsub_vx_nxv16i16(<vscale x 16 x i16> %va, <vscale x 16 x i16> %vb, i16 %c) {
; CHECK-LABEL: vnmsub_vx_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m4, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i16> undef, i16 %c, i32 0
  %splat = shufflevector <vscale x 16 x i16> %head, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %x = mul <vscale x 16 x i16> %va, %splat
  %y = sub <vscale x 16 x i16> %vb, %x
  ret <vscale x 16 x i16> %y
}

define <vscale x 32 x i16> @vnmsub_vv_nxv32i16(<vscale x 32 x i16> %va, <vscale x 32 x i16> %vb, <vscale x 32 x i16> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8re16.v v24, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, mu
; CHECK-NEXT:    vnmsac.vv v8, v16, v24
; CHECK-NEXT:    ret
  %x = mul <vscale x 32 x i16> %vc, %vb
  %y = sub <vscale x 32 x i16> %va, %x
  ret <vscale x 32 x i16> %y
}

define <vscale x 32 x i16> @vnmsub_vx_nxv32i16(<vscale x 32 x i16> %va, <vscale x 32 x i16> %vb, i16 %c) {
; CHECK-LABEL: vnmsub_vx_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m8, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i16> undef, i16 %c, i32 0
  %splat = shufflevector <vscale x 32 x i16> %head, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
  %x = mul <vscale x 32 x i16> %vb, %splat
  %y = sub <vscale x 32 x i16> %va, %x
  ret <vscale x 32 x i16> %y
}

define <vscale x 1 x i32> @vnmsub_vv_nxv1i32(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb, <vscale x 1 x i32> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v9, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 1 x i32> %va, %vb
  %y = sub <vscale x 1 x i32> %vc, %x
  ret <vscale x 1 x i32> %y
}

define <vscale x 1 x i32> @vnmsub_vx_nxv1i32(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb, i32 %c) {
; CHECK-LABEL: vnmsub_vx_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 %c, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %x = mul <vscale x 1 x i32> %va, %splat
  %y = sub <vscale x 1 x i32> %vb, %x
  ret <vscale x 1 x i32> %y
}

define <vscale x 2 x i32> @vnmsub_vv_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb, <vscale x 2 x i32> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v10, v9
; CHECK-NEXT:    ret
  %x = mul <vscale x 2 x i32> %va, %vc
  %y = sub <vscale x 2 x i32> %vb, %x
  ret <vscale x 2 x i32> %y
}

define <vscale x 2 x i32> @vnmsub_vx_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb, i32 %c) {
; CHECK-LABEL: vnmsub_vx_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 %c, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %x = mul <vscale x 2 x i32> %vb, %splat
  %y = sub <vscale x 2 x i32> %va, %x
  ret <vscale x 2 x i32> %y
}

define <vscale x 4 x i32> @vnmsub_vv_nxv4i32(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb, <vscale x 4 x i32> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v10, v12
; CHECK-NEXT:    ret
  %x = mul <vscale x 4 x i32> %vb, %va
  %y = sub <vscale x 4 x i32> %vc, %x
  ret <vscale x 4 x i32> %y
}

define <vscale x 4 x i32> @vnmsub_vx_nxv4i32(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb, i32 %c) {
; CHECK-LABEL: vnmsub_vx_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 %c, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %x = mul <vscale x 4 x i32> %va, %splat
  %y = sub <vscale x 4 x i32> %vb, %x
  ret <vscale x 4 x i32> %y
}

define <vscale x 8 x i32> @vnmsub_vv_nxv8i32(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb, <vscale x 8 x i32> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vnmsac.vv v8, v16, v12
; CHECK-NEXT:    ret
  %x = mul <vscale x 8 x i32> %vb, %vc
  %y = sub <vscale x 8 x i32> %va, %x
  ret <vscale x 8 x i32> %y
}

define <vscale x 8 x i32> @vnmsub_vx_nxv8i32(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb, i32 %c) {
; CHECK-LABEL: vnmsub_vx_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, mu
; CHECK-NEXT:    vnmsac.vx v8, a0, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 %c, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %x = mul <vscale x 8 x i32> %vb, %splat
  %y = sub <vscale x 8 x i32> %va, %x
  ret <vscale x 8 x i32> %y
}

define <vscale x 16 x i32> @vnmsub_vv_nxv16i32(<vscale x 16 x i32> %va, <vscale x 16 x i32> %vb, <vscale x 16 x i32> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8re32.v v24, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v24, v16
; CHECK-NEXT:    ret
  %x = mul <vscale x 16 x i32> %vc, %va
  %y = sub <vscale x 16 x i32> %vb, %x
  ret <vscale x 16 x i32> %y
}

define <vscale x 16 x i32> @vnmsub_vx_nxv16i32(<vscale x 16 x i32> %va, <vscale x 16 x i32> %vb, i32 %c) {
; CHECK-LABEL: vnmsub_vx_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m8, ta, mu
; CHECK-NEXT:    vnmsub.vx v8, a0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i32> undef, i32 %c, i32 0
  %splat = shufflevector <vscale x 16 x i32> %head, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
  %x = mul <vscale x 16 x i32> %va, %splat
  %y = sub <vscale x 16 x i32> %vb, %x
  ret <vscale x 16 x i32> %y
}

define <vscale x 1 x i64> @vnmsub_vv_nxv1i64(<vscale x 1 x i64> %va, <vscale x 1 x i64> %vb, <vscale x 1 x i64> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v9, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 1 x i64> %va, %vb
  %y = sub <vscale x 1 x i64> %vc, %x
  ret <vscale x 1 x i64> %y
}

define <vscale x 1 x i64> @vnmsub_vx_nxv1i64(<vscale x 1 x i64> %va, <vscale x 1 x i64> %vb, i64 %c) {
; RV32-LABEL: vnmsub_vx_nxv1i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v10, (a0), zero
; RV32-NEXT:    vnmsub.vv v8, v10, v9
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vnmsub_vx_nxv1i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; RV64-NEXT:    vnmsub.vx v8, a0, v9
; RV64-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 %c, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %x = mul <vscale x 1 x i64> %va, %splat
  %y = sub <vscale x 1 x i64> %vb, %x
  ret <vscale x 1 x i64> %y
}

define <vscale x 2 x i64> @vnmsub_vv_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i64> %vb, <vscale x 2 x i64> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v12, v10
; CHECK-NEXT:    ret
  %x = mul <vscale x 2 x i64> %va, %vc
  %y = sub <vscale x 2 x i64> %vb, %x
  ret <vscale x 2 x i64> %y
}

define <vscale x 2 x i64> @vnmsub_vx_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i64> %vb, i64 %c) {
; RV32-LABEL: vnmsub_vx_nxv2i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v12, (a0), zero
; RV32-NEXT:    vnmsac.vv v8, v10, v12
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vnmsub_vx_nxv2i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a1, zero, e64, m2, ta, mu
; RV64-NEXT:    vnmsac.vx v8, a0, v10
; RV64-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 %c, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %x = mul <vscale x 2 x i64> %vb, %splat
  %y = sub <vscale x 2 x i64> %va, %x
  ret <vscale x 2 x i64> %y
}

define <vscale x 4 x i64> @vnmsub_vv_nxv4i64(<vscale x 4 x i64> %va, <vscale x 4 x i64> %vb, <vscale x 4 x i64> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vnmsub.vv v8, v12, v16
; CHECK-NEXT:    ret
  %x = mul <vscale x 4 x i64> %vb, %va
  %y = sub <vscale x 4 x i64> %vc, %x
  ret <vscale x 4 x i64> %y
}

define <vscale x 4 x i64> @vnmsub_vx_nxv4i64(<vscale x 4 x i64> %va, <vscale x 4 x i64> %vb, i64 %c) {
; RV32-LABEL: vnmsub_vx_nxv4i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v16, (a0), zero
; RV32-NEXT:    vnmsub.vv v8, v16, v12
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vnmsub_vx_nxv4i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a1, zero, e64, m4, ta, mu
; RV64-NEXT:    vnmsub.vx v8, a0, v12
; RV64-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 %c, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %x = mul <vscale x 4 x i64> %va, %splat
  %y = sub <vscale x 4 x i64> %vb, %x
  ret <vscale x 4 x i64> %y
}

define <vscale x 8 x i64> @vnmsub_vv_nxv8i64(<vscale x 8 x i64> %va, <vscale x 8 x i64> %vb, <vscale x 8 x i64> %vc) {
; CHECK-LABEL: vnmsub_vv_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8re64.v v24, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vnmsac.vv v8, v16, v24
; CHECK-NEXT:    ret
  %x = mul <vscale x 8 x i64> %vb, %vc
  %y = sub <vscale x 8 x i64> %va, %x
  ret <vscale x 8 x i64> %y
}

define <vscale x 8 x i64> @vnmsub_vx_nxv8i64(<vscale x 8 x i64> %va, <vscale x 8 x i64> %vb, i64 %c) {
; RV32-LABEL: vnmsub_vx_nxv8i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v24, (a0), zero
; RV32-NEXT:    vnmsac.vv v8, v16, v24
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vnmsub_vx_nxv8i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a1, zero, e64, m8, ta, mu
; RV64-NEXT:    vnmsac.vx v8, a0, v16
; RV64-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 %c, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %x = mul <vscale x 8 x i64> %vb, %splat
  %y = sub <vscale x 8 x i64> %va, %x
  ret <vscale x 8 x i64> %y
}
