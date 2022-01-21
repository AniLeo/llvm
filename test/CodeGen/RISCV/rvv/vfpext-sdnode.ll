; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefix=RV32
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefix=RV64

define <vscale x 1 x float> @vfpext_nxv1f16_nxv1f32(<vscale x 1 x half> %va) {
;
; RV32-LABEL: vfpext_nxv1f16_nxv1f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v9, v8
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv1f16_nxv1f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v9, v8
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    ret
  %evec = fpext <vscale x 1 x half> %va to <vscale x 1 x float>
  ret <vscale x 1 x float> %evec
}

define <vscale x 1 x double> @vfpext_nxv1f16_nxv1f64(<vscale x 1 x half> %va) {
;
; RV32-LABEL: vfpext_nxv1f16_nxv1f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v9, v8
; RV32-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv1f16_nxv1f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v9, v8
; RV64-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v8, v9
; RV64-NEXT:    ret
  %evec = fpext <vscale x 1 x half> %va to <vscale x 1 x double>
  ret <vscale x 1 x double> %evec
}

define <vscale x 2 x float> @vfpext_nxv2f16_nxv2f32(<vscale x 2 x half> %va) {
;
; RV32-LABEL: vfpext_nxv2f16_nxv2f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v9, v8
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv2f16_nxv2f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v9, v8
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    ret
  %evec = fpext <vscale x 2 x half> %va to <vscale x 2 x float>
  ret <vscale x 2 x float> %evec
}

define <vscale x 2 x double> @vfpext_nxv2f16_nxv2f64(<vscale x 2 x half> %va) {
;
; RV32-LABEL: vfpext_nxv2f16_nxv2f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v10, v8
; RV32-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v8, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv2f16_nxv2f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v10, v8
; RV64-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v8, v10
; RV64-NEXT:    ret
  %evec = fpext <vscale x 2 x half> %va to <vscale x 2 x double>
  ret <vscale x 2 x double> %evec
}

define <vscale x 4 x float> @vfpext_nxv4f16_nxv4f32(<vscale x 4 x half> %va) {
;
; RV32-LABEL: vfpext_nxv4f16_nxv4f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v10, v8
; RV32-NEXT:    vmv2r.v v8, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv4f16_nxv4f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v10, v8
; RV64-NEXT:    vmv2r.v v8, v10
; RV64-NEXT:    ret
  %evec = fpext <vscale x 4 x half> %va to <vscale x 4 x float>
  ret <vscale x 4 x float> %evec
}

define <vscale x 4 x double> @vfpext_nxv4f16_nxv4f64(<vscale x 4 x half> %va) {
;
; RV32-LABEL: vfpext_nxv4f16_nxv4f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v12, v8
; RV32-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v8, v12
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv4f16_nxv4f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v12, v8
; RV64-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v8, v12
; RV64-NEXT:    ret
  %evec = fpext <vscale x 4 x half> %va to <vscale x 4 x double>
  ret <vscale x 4 x double> %evec
}

define <vscale x 8 x float> @vfpext_nxv8f16_nxv8f32(<vscale x 8 x half> %va) {
;
; RV32-LABEL: vfpext_nxv8f16_nxv8f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v12, v8
; RV32-NEXT:    vmv4r.v v8, v12
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv8f16_nxv8f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v12, v8
; RV64-NEXT:    vmv4r.v v8, v12
; RV64-NEXT:    ret
  %evec = fpext <vscale x 8 x half> %va to <vscale x 8 x float>
  ret <vscale x 8 x float> %evec
}

define <vscale x 8 x double> @vfpext_nxv8f16_nxv8f64(<vscale x 8 x half> %va) {
;
; RV32-LABEL: vfpext_nxv8f16_nxv8f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v16, v8
; RV32-NEXT:    vsetvli zero, zero, e32, m4, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v8, v16
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv8f16_nxv8f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v16, v8
; RV64-NEXT:    vsetvli zero, zero, e32, m4, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v8, v16
; RV64-NEXT:    ret
  %evec = fpext <vscale x 8 x half> %va to <vscale x 8 x double>
  ret <vscale x 8 x double> %evec
}

define <vscale x 16 x float> @vfpext_nxv16f16_nxv16f32(<vscale x 16 x half> %va) {
;
; RV32-LABEL: vfpext_nxv16f16_nxv16f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v16, v8
; RV32-NEXT:    vmv8r.v v8, v16
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv16f16_nxv16f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v16, v8
; RV64-NEXT:    vmv8r.v v8, v16
; RV64-NEXT:    ret
  %evec = fpext <vscale x 16 x half> %va to <vscale x 16 x float>
  ret <vscale x 16 x float> %evec
}

define <vscale x 1 x double> @vfpext_nxv1f32_nxv1f64(<vscale x 1 x float> %va) {
;
; RV32-LABEL: vfpext_nxv1f32_nxv1f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v9, v8
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv1f32_nxv1f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v9, v8
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    ret
  %evec = fpext <vscale x 1 x float> %va to <vscale x 1 x double>
  ret <vscale x 1 x double> %evec
}

define <vscale x 2 x double> @vfpext_nxv2f32_nxv2f64(<vscale x 2 x float> %va) {
;
; RV32-LABEL: vfpext_nxv2f32_nxv2f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v10, v8
; RV32-NEXT:    vmv2r.v v8, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv2f32_nxv2f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v10, v8
; RV64-NEXT:    vmv2r.v v8, v10
; RV64-NEXT:    ret
  %evec = fpext <vscale x 2 x float> %va to <vscale x 2 x double>
  ret <vscale x 2 x double> %evec
}

define <vscale x 4 x double> @vfpext_nxv4f32_nxv4f64(<vscale x 4 x float> %va) {
;
; RV32-LABEL: vfpext_nxv4f32_nxv4f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v12, v8
; RV32-NEXT:    vmv4r.v v8, v12
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv4f32_nxv4f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v12, v8
; RV64-NEXT:    vmv4r.v v8, v12
; RV64-NEXT:    ret
  %evec = fpext <vscale x 4 x float> %va to <vscale x 4 x double>
  ret <vscale x 4 x double> %evec
}

define <vscale x 8 x double> @vfpext_nxv8f32_nxv8f64(<vscale x 8 x float> %va) {
;
; RV32-LABEL: vfpext_nxv8f32_nxv8f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; RV32-NEXT:    vfwcvt.f.f.v v16, v8
; RV32-NEXT:    vmv8r.v v8, v16
; RV32-NEXT:    ret
;
; RV64-LABEL: vfpext_nxv8f32_nxv8f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; RV64-NEXT:    vfwcvt.f.f.v v16, v8
; RV64-NEXT:    vmv8r.v v8, v16
; RV64-NEXT:    ret
  %evec = fpext <vscale x 8 x float> %va to <vscale x 8 x double>
  ret <vscale x 8 x double> %evec
}
