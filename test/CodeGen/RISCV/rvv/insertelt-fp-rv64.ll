; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x half> @insertelt_nxv1f16_0(<vscale x 1 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv1f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x half> %v, half %elt, i32 0
  ret <vscale x 1 x half> %r
}

define <vscale x 1 x half> @insertelt_nxv1f16_imm(<vscale x 1 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv1f16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vslidedown.vi v25, v8, 3
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v25, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x half> %v, half %elt, i32 3
  ret <vscale x 1 x half> %r
}

define <vscale x 1 x half> @insertelt_nxv1f16_idx(<vscale x 1 x half> %v, half %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv1f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a1, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vslidedown.vx v25, v8, a0
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a1, zero, e16,mf4,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v25, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x half> %v, half %elt, i32 %idx
  ret <vscale x 1 x half> %r
}

define <vscale x 2 x half> @insertelt_nxv2f16_0(<vscale x 2 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv2f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x half> %v, half %elt, i32 0
  ret <vscale x 2 x half> %r
}

define <vscale x 2 x half> @insertelt_nxv2f16_imm(<vscale x 2 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv2f16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vslidedown.vi v25, v8, 3
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v25, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x half> %v, half %elt, i32 3
  ret <vscale x 2 x half> %r
}

define <vscale x 2 x half> @insertelt_nxv2f16_idx(<vscale x 2 x half> %v, half %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv2f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a1, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vslidedown.vx v25, v8, a0
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a1, zero, e16,mf2,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v25, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x half> %v, half %elt, i32 %idx
  ret <vscale x 2 x half> %r
}

define <vscale x 4 x half> @insertelt_nxv4f16_0(<vscale x 4 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv4f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x half> %v, half %elt, i32 0
  ret <vscale x 4 x half> %r
}

define <vscale x 4 x half> @insertelt_nxv4f16_imm(<vscale x 4 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv4f16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vslidedown.vi v25, v8, 3
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v25, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x half> %v, half %elt, i32 3
  ret <vscale x 4 x half> %r
}

define <vscale x 4 x half> @insertelt_nxv4f16_idx(<vscale x 4 x half> %v, half %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv4f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a1, zero, e16,m1,ta,mu
; CHECK-NEXT:    vslidedown.vx v25, v8, a0
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a1, zero, e16,m1,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v25, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x half> %v, half %elt, i32 %idx
  ret <vscale x 4 x half> %r
}

define <vscale x 8 x half> @insertelt_nxv8f16_0(<vscale x 8 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv8f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x half> %v, half %elt, i32 0
  ret <vscale x 8 x half> %r
}

define <vscale x 8 x half> @insertelt_nxv8f16_imm(<vscale x 8 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv8f16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vslidedown.vi v26, v8, 3
; CHECK-NEXT:    vfmv.s.f v26, fa0
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v26, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x half> %v, half %elt, i32 3
  ret <vscale x 8 x half> %r
}

define <vscale x 8 x half> @insertelt_nxv8f16_idx(<vscale x 8 x half> %v, half %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv8f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a1, zero, e16,m2,ta,mu
; CHECK-NEXT:    vslidedown.vx v26, v8, a0
; CHECK-NEXT:    vfmv.s.f v26, fa0
; CHECK-NEXT:    vsetvli a1, zero, e16,m2,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v26, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x half> %v, half %elt, i32 %idx
  ret <vscale x 8 x half> %r
}

define <vscale x 16 x half> @insertelt_nxv16f16_0(<vscale x 16 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv16f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 16 x half> %v, half %elt, i32 0
  ret <vscale x 16 x half> %r
}

define <vscale x 16 x half> @insertelt_nxv16f16_imm(<vscale x 16 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv16f16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vslidedown.vi v28, v8, 3
; CHECK-NEXT:    vfmv.s.f v28, fa0
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v28, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 16 x half> %v, half %elt, i32 3
  ret <vscale x 16 x half> %r
}

define <vscale x 16 x half> @insertelt_nxv16f16_idx(<vscale x 16 x half> %v, half %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv16f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a1, zero, e16,m4,ta,mu
; CHECK-NEXT:    vslidedown.vx v28, v8, a0
; CHECK-NEXT:    vfmv.s.f v28, fa0
; CHECK-NEXT:    vsetvli a1, zero, e16,m4,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v28, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 16 x half> %v, half %elt, i32 %idx
  ret <vscale x 16 x half> %r
}

define <vscale x 32 x half> @insertelt_nxv32f16_0(<vscale x 32 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv32f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 32 x half> %v, half %elt, i32 0
  ret <vscale x 32 x half> %r
}

define <vscale x 32 x half> @insertelt_nxv32f16_imm(<vscale x 32 x half> %v, half %elt) {
; CHECK-LABEL: insertelt_nxv32f16_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vslidedown.vi v16, v8, 3
; CHECK-NEXT:    vfmv.s.f v16, fa0
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v16, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 32 x half> %v, half %elt, i32 3
  ret <vscale x 32 x half> %r
}

define <vscale x 32 x half> @insertelt_nxv32f16_idx(<vscale x 32 x half> %v, half %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv32f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a1, zero, e16,m8,ta,mu
; CHECK-NEXT:    vslidedown.vx v16, v8, a0
; CHECK-NEXT:    vfmv.s.f v16, fa0
; CHECK-NEXT:    vsetvli a1, zero, e16,m8,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v16, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 32 x half> %v, half %elt, i32 %idx
  ret <vscale x 32 x half> %r
}

define <vscale x 1 x float> @insertelt_nxv1f32_0(<vscale x 1 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv1f32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x float> %v, float %elt, i32 0
  ret <vscale x 1 x float> %r
}

define <vscale x 1 x float> @insertelt_nxv1f32_imm(<vscale x 1 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv1f32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vslidedown.vi v25, v8, 3
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v25, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x float> %v, float %elt, i32 3
  ret <vscale x 1 x float> %r
}

define <vscale x 1 x float> @insertelt_nxv1f32_idx(<vscale x 1 x float> %v, float %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv1f32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vslidedown.vx v25, v8, a0
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a1, zero, e32,mf2,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v25, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x float> %v, float %elt, i32 %idx
  ret <vscale x 1 x float> %r
}

define <vscale x 2 x float> @insertelt_nxv2f32_0(<vscale x 2 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv2f32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x float> %v, float %elt, i32 0
  ret <vscale x 2 x float> %r
}

define <vscale x 2 x float> @insertelt_nxv2f32_imm(<vscale x 2 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv2f32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vslidedown.vi v25, v8, 3
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v25, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x float> %v, float %elt, i32 3
  ret <vscale x 2 x float> %r
}

define <vscale x 2 x float> @insertelt_nxv2f32_idx(<vscale x 2 x float> %v, float %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv2f32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m1,ta,mu
; CHECK-NEXT:    vslidedown.vx v25, v8, a0
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a1, zero, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v25, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x float> %v, float %elt, i32 %idx
  ret <vscale x 2 x float> %r
}

define <vscale x 4 x float> @insertelt_nxv4f32_0(<vscale x 4 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv4f32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x float> %v, float %elt, i32 0
  ret <vscale x 4 x float> %r
}

define <vscale x 4 x float> @insertelt_nxv4f32_imm(<vscale x 4 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv4f32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vslidedown.vi v26, v8, 3
; CHECK-NEXT:    vfmv.s.f v26, fa0
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v26, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x float> %v, float %elt, i32 3
  ret <vscale x 4 x float> %r
}

define <vscale x 4 x float> @insertelt_nxv4f32_idx(<vscale x 4 x float> %v, float %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv4f32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m2,ta,mu
; CHECK-NEXT:    vslidedown.vx v26, v8, a0
; CHECK-NEXT:    vfmv.s.f v26, fa0
; CHECK-NEXT:    vsetvli a1, zero, e32,m2,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v26, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x float> %v, float %elt, i32 %idx
  ret <vscale x 4 x float> %r
}

define <vscale x 8 x float> @insertelt_nxv8f32_0(<vscale x 8 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv8f32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x float> %v, float %elt, i32 0
  ret <vscale x 8 x float> %r
}

define <vscale x 8 x float> @insertelt_nxv8f32_imm(<vscale x 8 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv8f32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vslidedown.vi v28, v8, 3
; CHECK-NEXT:    vfmv.s.f v28, fa0
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v28, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x float> %v, float %elt, i32 3
  ret <vscale x 8 x float> %r
}

define <vscale x 8 x float> @insertelt_nxv8f32_idx(<vscale x 8 x float> %v, float %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv8f32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m4,ta,mu
; CHECK-NEXT:    vslidedown.vx v28, v8, a0
; CHECK-NEXT:    vfmv.s.f v28, fa0
; CHECK-NEXT:    vsetvli a1, zero, e32,m4,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v28, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x float> %v, float %elt, i32 %idx
  ret <vscale x 8 x float> %r
}

define <vscale x 16 x float> @insertelt_nxv16f32_0(<vscale x 16 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv16f32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 16 x float> %v, float %elt, i32 0
  ret <vscale x 16 x float> %r
}

define <vscale x 16 x float> @insertelt_nxv16f32_imm(<vscale x 16 x float> %v, float %elt) {
; CHECK-LABEL: insertelt_nxv16f32_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vslidedown.vi v16, v8, 3
; CHECK-NEXT:    vfmv.s.f v16, fa0
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v16, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 16 x float> %v, float %elt, i32 3
  ret <vscale x 16 x float> %r
}

define <vscale x 16 x float> @insertelt_nxv16f32_idx(<vscale x 16 x float> %v, float %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv16f32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m8,ta,mu
; CHECK-NEXT:    vslidedown.vx v16, v8, a0
; CHECK-NEXT:    vfmv.s.f v16, fa0
; CHECK-NEXT:    vsetvli a1, zero, e32,m8,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v16, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 16 x float> %v, float %elt, i32 %idx
  ret <vscale x 16 x float> %r
}

define <vscale x 1 x double> @insertelt_nxv1f64_0(<vscale x 1 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv1f64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x double> %v, double %elt, i32 0
  ret <vscale x 1 x double> %r
}

define <vscale x 1 x double> @insertelt_nxv1f64_imm(<vscale x 1 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv1f64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vslidedown.vi v25, v8, 3
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v25, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x double> %v, double %elt, i32 3
  ret <vscale x 1 x double> %r
}

define <vscale x 1 x double> @insertelt_nxv1f64_idx(<vscale x 1 x double> %v, double %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv1f64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m1,ta,mu
; CHECK-NEXT:    vslidedown.vx v25, v8, a0
; CHECK-NEXT:    vfmv.s.f v25, fa0
; CHECK-NEXT:    vsetvli a1, zero, e64,m1,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v25, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 1 x double> %v, double %elt, i32 %idx
  ret <vscale x 1 x double> %r
}

define <vscale x 2 x double> @insertelt_nxv2f64_0(<vscale x 2 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv2f64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x double> %v, double %elt, i32 0
  ret <vscale x 2 x double> %r
}

define <vscale x 2 x double> @insertelt_nxv2f64_imm(<vscale x 2 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv2f64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vslidedown.vi v26, v8, 3
; CHECK-NEXT:    vfmv.s.f v26, fa0
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v26, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x double> %v, double %elt, i32 3
  ret <vscale x 2 x double> %r
}

define <vscale x 2 x double> @insertelt_nxv2f64_idx(<vscale x 2 x double> %v, double %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv2f64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m2,ta,mu
; CHECK-NEXT:    vslidedown.vx v26, v8, a0
; CHECK-NEXT:    vfmv.s.f v26, fa0
; CHECK-NEXT:    vsetvli a1, zero, e64,m2,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v26, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 2 x double> %v, double %elt, i32 %idx
  ret <vscale x 2 x double> %r
}

define <vscale x 4 x double> @insertelt_nxv4f64_0(<vscale x 4 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv4f64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x double> %v, double %elt, i32 0
  ret <vscale x 4 x double> %r
}

define <vscale x 4 x double> @insertelt_nxv4f64_imm(<vscale x 4 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv4f64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vslidedown.vi v28, v8, 3
; CHECK-NEXT:    vfmv.s.f v28, fa0
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v28, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x double> %v, double %elt, i32 3
  ret <vscale x 4 x double> %r
}

define <vscale x 4 x double> @insertelt_nxv4f64_idx(<vscale x 4 x double> %v, double %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv4f64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m4,ta,mu
; CHECK-NEXT:    vslidedown.vx v28, v8, a0
; CHECK-NEXT:    vfmv.s.f v28, fa0
; CHECK-NEXT:    vsetvli a1, zero, e64,m4,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v28, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 4 x double> %v, double %elt, i32 %idx
  ret <vscale x 4 x double> %r
}

define <vscale x 8 x double> @insertelt_nxv8f64_0(<vscale x 8 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv8f64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x double> %v, double %elt, i32 0
  ret <vscale x 8 x double> %r
}

define <vscale x 8 x double> @insertelt_nxv8f64_imm(<vscale x 8 x double> %v, double %elt) {
; CHECK-LABEL: insertelt_nxv8f64_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vslidedown.vi v16, v8, 3
; CHECK-NEXT:    vfmv.s.f v16, fa0
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v16, 3
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x double> %v, double %elt, i32 3
  ret <vscale x 8 x double> %r
}

define <vscale x 8 x double> @insertelt_nxv8f64_idx(<vscale x 8 x double> %v, double %elt, i32 signext %idx) {
; CHECK-LABEL: insertelt_nxv8f64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m8,ta,mu
; CHECK-NEXT:    vslidedown.vx v16, v8, a0
; CHECK-NEXT:    vfmv.s.f v16, fa0
; CHECK-NEXT:    vsetvli a1, zero, e64,m8,tu,mu
; CHECK-NEXT:    vslideup.vx v8, v16, a0
; CHECK-NEXT:    ret
  %r = insertelement <vscale x 8 x double> %v, double %elt, i32 %idx
  ret <vscale x 8 x double> %r
}

