; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK

; Test that the prepareSREMEqFold optimization doesn't crash on scalable
; vector types.
define <vscale x 4 x i1> @srem_eq_fold_nxv4i8(<vscale x 4 x i8> %va) {
; CHECK-LABEL: srem_eq_fold_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 42
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.x v9, a0
; CHECK-NEXT:    addi a1, zero, -85
; CHECK-NEXT:    vmacc.vx v9, a1, v8
; CHECK-NEXT:    vsll.vi v8, v9, 7
; CHECK-NEXT:    vsrl.vi v9, v9, 1
; CHECK-NEXT:    vor.vv v8, v9, v8
; CHECK-NEXT:    vmsleu.vx v0, v8, a0
; CHECK-NEXT:    ret
  %head_six = insertelement <vscale x 4 x i8> undef, i8 6, i32 0
  %splat_six = shufflevector <vscale x 4 x i8> %head_six, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %rem = srem <vscale x 4 x i8> %va, %splat_six

  %cc = icmp eq <vscale x 4 x i8> %rem, zeroinitializer
  ret <vscale x 4 x i1> %cc
}

define <vscale x 1 x i32> @vmulh_vv_nxv1i32(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb) {
; CHECK-LABEL: vmulh_vv_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vmulh.vv v8, v9, v8
; CHECK-NEXT:    ret
  %vc = sext <vscale x 1 x i32> %vb to <vscale x 1 x i64>
  %vd = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %ve = mul <vscale x 1 x i64> %vc, %vd
  %head = insertelement <vscale x 1 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vf = lshr <vscale x 1 x i64> %ve, %splat
  %vg = trunc <vscale x 1 x i64> %vf to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %vg
}

define <vscale x 1 x i32> @vmulh_vx_nxv1i32(<vscale x 1 x i32> %va, i32 %x) {
; CHECK-LABEL: vmulh_vx_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vmulh.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 1 x i32> undef, i32 %x, i32 0
  %splat1 = shufflevector <vscale x 1 x i32> %head1, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vb = sext <vscale x 1 x i32> %splat1 to <vscale x 1 x i64>
  %vc = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = mul <vscale x 1 x i64> %vb, %vc
  %head2 = insertelement <vscale x 1 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 1 x i64> %head2, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %ve = lshr <vscale x 1 x i64> %vd, %splat2
  %vf = trunc <vscale x 1 x i64> %ve to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %vf
}

define <vscale x 1 x i32> @vmulh_vi_nxv1i32_0(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv1i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v8, v9, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 1 x i32> undef, i32 -7, i32 0
  %splat1 = shufflevector <vscale x 1 x i32> %head1, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vb = sext <vscale x 1 x i32> %splat1 to <vscale x 1 x i64>
  %vc = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = mul <vscale x 1 x i64> %vb, %vc
  %head2 = insertelement <vscale x 1 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 1 x i64> %head2, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %ve = lshr <vscale x 1 x i64> %vd, %splat2
  %vf = trunc <vscale x 1 x i64> %ve to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %vf
}

define <vscale x 1 x i32> @vmulh_vi_nxv1i32_1(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv1i32_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsext.vf2 v9, v8
; CHECK-NEXT:    vsll.vi v8, v9, 4
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v8, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 1 x i32> undef, i32 16, i32 0
  %splat1 = shufflevector <vscale x 1 x i32> %head1, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vb = sext <vscale x 1 x i32> %splat1 to <vscale x 1 x i64>
  %vc = sext <vscale x 1 x i32> %va to <vscale x 1 x i64>
  %vd = mul <vscale x 1 x i64> %vb, %vc
  %head2 = insertelement <vscale x 1 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 1 x i64> %head2, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %ve = lshr <vscale x 1 x i64> %vd, %splat2
  %vf = trunc <vscale x 1 x i64> %ve to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %vf
}

define <vscale x 2 x i32> @vmulh_vv_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb) {
; CHECK-LABEL: vmulh_vv_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vmulh.vv v8, v9, v8
; CHECK-NEXT:    ret
  %vc = sext <vscale x 2 x i32> %vb to <vscale x 2 x i64>
  %vd = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %ve = mul <vscale x 2 x i64> %vc, %vd
  %head = insertelement <vscale x 2 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vf = lshr <vscale x 2 x i64> %ve, %splat
  %vg = trunc <vscale x 2 x i64> %vf to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %vg
}

define <vscale x 2 x i32> @vmulh_vx_nxv2i32(<vscale x 2 x i32> %va, i32 %x) {
; CHECK-LABEL: vmulh_vx_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vmulh.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 2 x i32> undef, i32 %x, i32 0
  %splat1 = shufflevector <vscale x 2 x i32> %head1, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vb = sext <vscale x 2 x i32> %splat1 to <vscale x 2 x i64>
  %vc = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = mul <vscale x 2 x i64> %vb, %vc
  %head2 = insertelement <vscale x 2 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 2 x i64> %head2, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %ve = lshr <vscale x 2 x i64> %vd, %splat2
  %vf = trunc <vscale x 2 x i64> %ve to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %vf
}

define <vscale x 2 x i32> @vmulh_vi_nxv2i32_0(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsext.vf2 v10, v8
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v8, v10, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v10, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v10, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 2 x i32> undef, i32 -7, i32 0
  %splat1 = shufflevector <vscale x 2 x i32> %head1, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vb = sext <vscale x 2 x i32> %splat1 to <vscale x 2 x i64>
  %vc = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = mul <vscale x 2 x i64> %vb, %vc
  %head2 = insertelement <vscale x 2 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 2 x i64> %head2, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %ve = lshr <vscale x 2 x i64> %vd, %splat2
  %vf = trunc <vscale x 2 x i64> %ve to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %vf
}

define <vscale x 2 x i32> @vmulh_vi_nxv2i32_1(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv2i32_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsext.vf2 v10, v8
; CHECK-NEXT:    vsll.vi v8, v10, 4
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v10, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v10, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 2 x i32> undef, i32 16, i32 0
  %splat1 = shufflevector <vscale x 2 x i32> %head1, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vb = sext <vscale x 2 x i32> %splat1 to <vscale x 2 x i64>
  %vc = sext <vscale x 2 x i32> %va to <vscale x 2 x i64>
  %vd = mul <vscale x 2 x i64> %vb, %vc
  %head2 = insertelement <vscale x 2 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 2 x i64> %head2, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %ve = lshr <vscale x 2 x i64> %vd, %splat2
  %vf = trunc <vscale x 2 x i64> %ve to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %vf
}

define <vscale x 4 x i32> @vmulh_vv_nxv4i32(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb) {
; CHECK-LABEL: vmulh_vv_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmulh.vv v8, v10, v8
; CHECK-NEXT:    ret
  %vc = sext <vscale x 4 x i32> %vb to <vscale x 4 x i64>
  %vd = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %ve = mul <vscale x 4 x i64> %vc, %vd
  %head = insertelement <vscale x 4 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vf = lshr <vscale x 4 x i64> %ve, %splat
  %vg = trunc <vscale x 4 x i64> %vf to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %vg
}

define <vscale x 4 x i32> @vmulh_vx_nxv4i32(<vscale x 4 x i32> %va, i32 %x) {
; CHECK-LABEL: vmulh_vx_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmulh.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 4 x i32> undef, i32 %x, i32 0
  %splat1 = shufflevector <vscale x 4 x i32> %head1, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vb = sext <vscale x 4 x i32> %splat1 to <vscale x 4 x i64>
  %vc = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = mul <vscale x 4 x i64> %vb, %vc
  %head2 = insertelement <vscale x 4 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 4 x i64> %head2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %ve = lshr <vscale x 4 x i64> %vd, %splat2
  %vf = trunc <vscale x 4 x i64> %ve to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %vf
}

define <vscale x 4 x i32> @vmulh_vi_nxv4i32_0(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv4i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsext.vf2 v12, v8
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v8, v12, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v12, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v12, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 4 x i32> undef, i32 -7, i32 0
  %splat1 = shufflevector <vscale x 4 x i32> %head1, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vb = sext <vscale x 4 x i32> %splat1 to <vscale x 4 x i64>
  %vc = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = mul <vscale x 4 x i64> %vb, %vc
  %head2 = insertelement <vscale x 4 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 4 x i64> %head2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %ve = lshr <vscale x 4 x i64> %vd, %splat2
  %vf = trunc <vscale x 4 x i64> %ve to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %vf
}

define <vscale x 4 x i32> @vmulh_vi_nxv4i32_1(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv4i32_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vsext.vf2 v12, v8
; CHECK-NEXT:    vsll.vi v8, v12, 4
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v12, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v12, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 4 x i32> undef, i32 16, i32 0
  %splat1 = shufflevector <vscale x 4 x i32> %head1, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vb = sext <vscale x 4 x i32> %splat1 to <vscale x 4 x i64>
  %vc = sext <vscale x 4 x i32> %va to <vscale x 4 x i64>
  %vd = mul <vscale x 4 x i64> %vb, %vc
  %head2 = insertelement <vscale x 4 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 4 x i64> %head2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %ve = lshr <vscale x 4 x i64> %vd, %splat2
  %vf = trunc <vscale x 4 x i64> %ve to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %vf
}

define <vscale x 8 x i32> @vmulh_vv_nxv8i32(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb) {
; CHECK-LABEL: vmulh_vv_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vmulh.vv v8, v12, v8
; CHECK-NEXT:    ret
  %vc = sext <vscale x 8 x i32> %vb to <vscale x 8 x i64>
  %vd = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %ve = mul <vscale x 8 x i64> %vc, %vd
  %head = insertelement <vscale x 8 x i64> undef, i64 32, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vf = lshr <vscale x 8 x i64> %ve, %splat
  %vg = trunc <vscale x 8 x i64> %vf to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %vg
}

define <vscale x 8 x i32> @vmulh_vx_nxv8i32(<vscale x 8 x i32> %va, i32 %x) {
; CHECK-LABEL: vmulh_vx_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, mu
; CHECK-NEXT:    vmulh.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 8 x i32> undef, i32 %x, i32 0
  %splat1 = shufflevector <vscale x 8 x i32> %head1, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vb = sext <vscale x 8 x i32> %splat1 to <vscale x 8 x i64>
  %vc = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = mul <vscale x 8 x i64> %vb, %vc
  %head2 = insertelement <vscale x 8 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 8 x i64> %head2, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %ve = lshr <vscale x 8 x i64> %vd, %splat2
  %vf = trunc <vscale x 8 x i64> %ve to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %vf
}

define <vscale x 8 x i32> @vmulh_vi_nxv8i32_0(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv8i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v8, v16, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v16, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m4, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v16, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 8 x i32> undef, i32 -7, i32 0
  %splat1 = shufflevector <vscale x 8 x i32> %head1, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vb = sext <vscale x 8 x i32> %splat1 to <vscale x 8 x i64>
  %vc = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = mul <vscale x 8 x i64> %vb, %vc
  %head2 = insertelement <vscale x 8 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 8 x i64> %head2, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %ve = lshr <vscale x 8 x i64> %vd, %splat2
  %vf = trunc <vscale x 8 x i64> %ve to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %vf
}

define <vscale x 8 x i32> @vmulh_vi_nxv8i32_1(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vmulh_vi_nxv8i32_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    vsll.vi v8, v16, 4
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsrl.vx v16, v8, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m4, ta, mu
; CHECK-NEXT:    vnsrl.wi v8, v16, 0
; CHECK-NEXT:    ret
  %head1 = insertelement <vscale x 8 x i32> undef, i32 16, i32 0
  %splat1 = shufflevector <vscale x 8 x i32> %head1, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vb = sext <vscale x 8 x i32> %splat1 to <vscale x 8 x i64>
  %vc = sext <vscale x 8 x i32> %va to <vscale x 8 x i64>
  %vd = mul <vscale x 8 x i64> %vb, %vc
  %head2 = insertelement <vscale x 8 x i64> undef, i64 32, i32 0
  %splat2 = shufflevector <vscale x 8 x i64> %head2, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %ve = lshr <vscale x 8 x i64> %vd, %splat2
  %vf = trunc <vscale x 8 x i64> %ve to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %vf
}
