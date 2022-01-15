; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+experimental-v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefix=RV32
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+experimental-v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefix=RV64

define <vscale x 1 x half> @vfptrunc_nxv1f32_nxv1f16(<vscale x 1 x float> %va) {
;
; RV32-LABEL: vfptrunc_nxv1f32_nxv1f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v9, v8
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv1f32_nxv1f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v9, v8
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 1 x float> %va to <vscale x 1 x half>
  ret <vscale x 1 x half> %evec
}

define <vscale x 2 x half> @vfptrunc_nxv2f32_nxv2f16(<vscale x 2 x float> %va) {
;
; RV32-LABEL: vfptrunc_nxv2f32_nxv2f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v9, v8
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv2f32_nxv2f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v9, v8
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 2 x float> %va to <vscale x 2 x half>
  ret <vscale x 2 x half> %evec
}

define <vscale x 4 x half> @vfptrunc_nxv4f32_nxv4f16(<vscale x 4 x float> %va) {
;
; RV32-LABEL: vfptrunc_nxv4f32_nxv4f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v10, v8
; RV32-NEXT:    vmv.v.v v8, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv4f32_nxv4f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v10, v8
; RV64-NEXT:    vmv.v.v v8, v10
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 4 x float> %va to <vscale x 4 x half>
  ret <vscale x 4 x half> %evec
}

define <vscale x 8 x half> @vfptrunc_nxv8f32_nxv8f16(<vscale x 8 x float> %va) {
;
; RV32-LABEL: vfptrunc_nxv8f32_nxv8f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v12, v8
; RV32-NEXT:    vmv.v.v v8, v12
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv8f32_nxv8f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v12, v8
; RV64-NEXT:    vmv.v.v v8, v12
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 8 x float> %va to <vscale x 8 x half>
  ret <vscale x 8 x half> %evec
}

define <vscale x 16 x half> @vfptrunc_nxv16f32_nxv16f16(<vscale x 16 x float> %va) {
;
; RV32-LABEL: vfptrunc_nxv16f32_nxv16f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v16, v8
; RV32-NEXT:    vmv.v.v v8, v16
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv16f32_nxv16f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v16, v8
; RV64-NEXT:    vmv.v.v v8, v16
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 16 x float> %va to <vscale x 16 x half>
  ret <vscale x 16 x half> %evec
}

define <vscale x 1 x half> @vfptrunc_nxv1f64_nxv1f16(<vscale x 1 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv1f64_nxv1f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; RV32-NEXT:    vfncvt.rod.f.f.w v9, v8
; RV32-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv1f64_nxv1f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; RV64-NEXT:    vfncvt.rod.f.f.w v9, v8
; RV64-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v8, v9
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 1 x double> %va to <vscale x 1 x half>
  ret <vscale x 1 x half> %evec
}

define <vscale x 1 x float> @vfptrunc_nxv1f64_nxv1f32(<vscale x 1 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv1f64_nxv1f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v9, v8
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv1f64_nxv1f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v9, v8
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 1 x double> %va to <vscale x 1 x float>
  ret <vscale x 1 x float> %evec
}

define <vscale x 2 x half> @vfptrunc_nxv2f64_nxv2f16(<vscale x 2 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv2f64_nxv2f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; RV32-NEXT:    vfncvt.rod.f.f.w v10, v8
; RV32-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v8, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv2f64_nxv2f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; RV64-NEXT:    vfncvt.rod.f.f.w v10, v8
; RV64-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v8, v10
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 2 x double> %va to <vscale x 2 x half>
  ret <vscale x 2 x half> %evec
}

define <vscale x 2 x float> @vfptrunc_nxv2f64_nxv2f32(<vscale x 2 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv2f64_nxv2f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v10, v8
; RV32-NEXT:    vmv.v.v v8, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv2f64_nxv2f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v10, v8
; RV64-NEXT:    vmv.v.v v8, v10
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 2 x double> %va to <vscale x 2 x float>
  ret <vscale x 2 x float> %evec
}

define <vscale x 4 x half> @vfptrunc_nxv4f64_nxv4f16(<vscale x 4 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv4f64_nxv4f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; RV32-NEXT:    vfncvt.rod.f.f.w v12, v8
; RV32-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v8, v12
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv4f64_nxv4f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; RV64-NEXT:    vfncvt.rod.f.f.w v12, v8
; RV64-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v8, v12
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 4 x double> %va to <vscale x 4 x half>
  ret <vscale x 4 x half> %evec
}

define <vscale x 4 x float> @vfptrunc_nxv4f64_nxv4f32(<vscale x 4 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv4f64_nxv4f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v12, v8
; RV32-NEXT:    vmv.v.v v8, v12
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv4f64_nxv4f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v12, v8
; RV64-NEXT:    vmv.v.v v8, v12
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 4 x double> %va to <vscale x 4 x float>
  ret <vscale x 4 x float> %evec
}

define <vscale x 8 x half> @vfptrunc_nxv8f64_nxv8f16(<vscale x 8 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv8f64_nxv8f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; RV32-NEXT:    vfncvt.rod.f.f.w v16, v8
; RV32-NEXT:    vsetvli zero, zero, e16, m2, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v8, v16
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv8f64_nxv8f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; RV64-NEXT:    vfncvt.rod.f.f.w v16, v8
; RV64-NEXT:    vsetvli zero, zero, e16, m2, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v8, v16
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 8 x double> %va to <vscale x 8 x half>
  ret <vscale x 8 x half> %evec
}

define <vscale x 8 x float> @vfptrunc_nxv8f64_nxv8f32(<vscale x 8 x double> %va) {
;
; RV32-LABEL: vfptrunc_nxv8f64_nxv8f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; RV32-NEXT:    vfncvt.f.f.w v16, v8
; RV32-NEXT:    vmv.v.v v8, v16
; RV32-NEXT:    ret
;
; RV64-LABEL: vfptrunc_nxv8f64_nxv8f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; RV64-NEXT:    vfncvt.f.f.w v16, v8
; RV64-NEXT:    vmv.v.v v8, v16
; RV64-NEXT:    ret
  %evec = fptrunc <vscale x 8 x double> %va to <vscale x 8 x float>
  ret <vscale x 8 x float> %evec
}
