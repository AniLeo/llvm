; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+experimental-v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+experimental-v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x half> @vfneg_vv_nxv1f16(<vscale x 1 x half> %va) {
; CHECK-LABEL: vfneg_vv_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 1 x half> %va
  ret <vscale x 1 x half> %vb
}

define <vscale x 2 x half> @vfneg_vv_nxv2f16(<vscale x 2 x half> %va) {
; CHECK-LABEL: vfneg_vv_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 2 x half> %va
  ret <vscale x 2 x half> %vb
}

define <vscale x 4 x half> @vfneg_vv_nxv4f16(<vscale x 4 x half> %va) {
; CHECK-LABEL: vfneg_vv_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 4 x half> %va
  ret <vscale x 4 x half> %vb
}

define <vscale x 8 x half> @vfneg_vv_nxv8f16(<vscale x 8 x half> %va) {
; CHECK-LABEL: vfneg_vv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 8 x half> %va
  ret <vscale x 8 x half> %vb
}

define <vscale x 16 x half> @vfneg_vv_nxv16f16(<vscale x 16 x half> %va) {
; CHECK-LABEL: vfneg_vv_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 16 x half> %va
  ret <vscale x 16 x half> %vb
}

define <vscale x 32 x half> @vfneg_vv_nxv32f16(<vscale x 32 x half> %va) {
; CHECK-LABEL: vfneg_vv_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 32 x half> %va
  ret <vscale x 32 x half> %vb
}

define <vscale x 1 x float> @vfneg_vv_nxv1f32(<vscale x 1 x float> %va) {
; CHECK-LABEL: vfneg_vv_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 1 x float> %va
  ret <vscale x 1 x float> %vb
}

define <vscale x 2 x float> @vfneg_vv_nxv2f32(<vscale x 2 x float> %va) {
; CHECK-LABEL: vfneg_vv_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 2 x float> %va
  ret <vscale x 2 x float> %vb
}

define <vscale x 4 x float> @vfneg_vv_nxv4f32(<vscale x 4 x float> %va) {
; CHECK-LABEL: vfneg_vv_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 4 x float> %va
  ret <vscale x 4 x float> %vb
}

define <vscale x 8 x float> @vfneg_vv_nxv8f32(<vscale x 8 x float> %va) {
; CHECK-LABEL: vfneg_vv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 8 x float> %va
  ret <vscale x 8 x float> %vb
}

define <vscale x 16 x float> @vfneg_vv_nxv16f32(<vscale x 16 x float> %va) {
; CHECK-LABEL: vfneg_vv_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 16 x float> %va
  ret <vscale x 16 x float> %vb
}

define <vscale x 1 x double> @vfneg_vv_nxv1f64(<vscale x 1 x double> %va) {
; CHECK-LABEL: vfneg_vv_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 1 x double> %va
  ret <vscale x 1 x double> %vb
}

define <vscale x 2 x double> @vfneg_vv_nxv2f64(<vscale x 2 x double> %va) {
; CHECK-LABEL: vfneg_vv_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 2 x double> %va
  ret <vscale x 2 x double> %vb
}

define <vscale x 4 x double> @vfneg_vv_nxv4f64(<vscale x 4 x double> %va) {
; CHECK-LABEL: vfneg_vv_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 4 x double> %va
  ret <vscale x 4 x double> %vb
}

define <vscale x 8 x double> @vfneg_vv_nxv8f64(<vscale x 8 x double> %va) {
; CHECK-LABEL: vfneg_vv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnjn.vv v8, v8, v8
; CHECK-NEXT:    ret
  %vb = fneg <vscale x 8 x double> %va
  ret <vscale x 8 x double> %vb
}
