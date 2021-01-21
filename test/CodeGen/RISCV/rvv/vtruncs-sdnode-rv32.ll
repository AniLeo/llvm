; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x i8> @vtrunc_nxv1i16_nxv1i8(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vtrunc_nxv1i16_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,mf8,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 1 x i16> %va to <vscale x 1 x i8>
  ret <vscale x 1 x i8> %tvec
}

define <vscale x 2 x i8> @vtrunc_nxv2i16_nxv2i8(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vtrunc_nxv2i16_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 2 x i16> %va to <vscale x 2 x i8>
  ret <vscale x 2 x i8> %tvec
}

define <vscale x 4 x i8> @vtrunc_nxv4i16_nxv4i8(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vtrunc_nxv4i16_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 4 x i16> %va to <vscale x 4 x i8>
  ret <vscale x 4 x i8> %tvec
}

define <vscale x 8 x i8> @vtrunc_nxv8i16_nxv8i8(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vtrunc_nxv8i16_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 8 x i16> %va to <vscale x 8 x i8>
  ret <vscale x 8 x i8> %tvec
}

define <vscale x 16 x i8> @vtrunc_nxv16i16_nxv16i8(<vscale x 16 x i16> %va) {
; CHECK-LABEL: vtrunc_nxv16i16_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v8, 0
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 16 x i16> %va to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %tvec
}

define <vscale x 1 x i8> @vtrunc_nxv1i32_nxv1i8(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv1i32_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,mf8,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v25, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 1 x i32> %va to <vscale x 1 x i8>
  ret <vscale x 1 x i8> %tvec
}

define <vscale x 1 x i16> @vtrunc_nxv1i32_nxv1i16(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv1i32_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 1 x i32> %va to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %tvec
}

define <vscale x 2 x i8> @vtrunc_nxv2i32_nxv2i8(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv2i32_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v25, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 2 x i32> %va to <vscale x 2 x i8>
  ret <vscale x 2 x i8> %tvec
}

define <vscale x 2 x i16> @vtrunc_nxv2i32_nxv2i16(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv2i32_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 2 x i32> %va to <vscale x 2 x i16>
  ret <vscale x 2 x i16> %tvec
}

define <vscale x 4 x i8> @vtrunc_nxv4i32_nxv4i8(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv4i32_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v25, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 4 x i32> %va to <vscale x 4 x i8>
  ret <vscale x 4 x i8> %tvec
}

define <vscale x 4 x i16> @vtrunc_nxv4i32_nxv4i16(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv4i32_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 4 x i32> %va to <vscale x 4 x i16>
  ret <vscale x 4 x i16> %tvec
}

define <vscale x 8 x i8> @vtrunc_nxv8i32_nxv8i8(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv8i32_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v26, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 8 x i32> %va to <vscale x 8 x i8>
  ret <vscale x 8 x i8> %tvec
}

define <vscale x 8 x i16> @vtrunc_nxv8i32_nxv8i16(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv8i32_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v8, 0
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 8 x i32> %va to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %tvec
}

define <vscale x 16 x i8> @vtrunc_nxv16i32_nxv16i8(<vscale x 16 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv16i32_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vnsrl.wi v28, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v28, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 16 x i32> %va to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %tvec
}

define <vscale x 16 x i16> @vtrunc_nxv16i32_nxv16i16(<vscale x 16 x i32> %va) {
; CHECK-LABEL: vtrunc_nxv16i32_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vnsrl.wi v28, v8, 0
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 16 x i32> %va to <vscale x 16 x i16>
  ret <vscale x 16 x i16> %tvec
}

define <vscale x 1 x i8> @vtrunc_nxv1i64_nxv1i8(<vscale x 1 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv1i64_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v25, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,mf8,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v26, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 1 x i64> %va to <vscale x 1 x i8>
  ret <vscale x 1 x i8> %tvec
}

define <vscale x 1 x i16> @vtrunc_nxv1i64_nxv1i16(<vscale x 1 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv1i64_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v25, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 1 x i64> %va to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %tvec
}

define <vscale x 1 x i32> @vtrunc_nxv1i64_nxv1i32(<vscale x 1 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv1i64_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 1 x i64> %va to <vscale x 1 x i32>
  ret <vscale x 1 x i32> %tvec
}

define <vscale x 2 x i8> @vtrunc_nxv2i64_nxv2i8(<vscale x 2 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv2i64_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v25, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v26, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 2 x i64> %va to <vscale x 2 x i8>
  ret <vscale x 2 x i8> %tvec
}

define <vscale x 2 x i16> @vtrunc_nxv2i64_nxv2i16(<vscale x 2 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv2i64_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v25, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 2 x i64> %va to <vscale x 2 x i16>
  ret <vscale x 2 x i16> %tvec
}

define <vscale x 2 x i32> @vtrunc_nxv2i64_nxv2i32(<vscale x 2 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv2i64_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v8, 0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 2 x i64> %va to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %tvec
}

define <vscale x 4 x i8> @vtrunc_nxv4i64_nxv4i8(<vscale x 4 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv4i64_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v25, v26, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v25, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 4 x i64> %va to <vscale x 4 x i8>
  ret <vscale x 4 x i8> %tvec
}

define <vscale x 4 x i16> @vtrunc_nxv4i64_nxv4i16(<vscale x 4 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv4i64_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v26, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 4 x i64> %va to <vscale x 4 x i16>
  ret <vscale x 4 x i16> %tvec
}

define <vscale x 4 x i32> @vtrunc_nxv4i64_nxv4i32(<vscale x 4 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv4i64_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v8, 0
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 4 x i64> %va to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %tvec
}

define <vscale x 8 x i8> @vtrunc_nxv8i64_nxv8i8(<vscale x 8 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv8i64_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vnsrl.wi v28, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v26, v28, 0
; CHECK-NEXT:    vsetvli a0, zero, e8,m1,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v26, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 8 x i64> %va to <vscale x 8 x i8>
  ret <vscale x 8 x i8> %tvec
}

define <vscale x 8 x i16> @vtrunc_nxv8i64_nxv8i16(<vscale x 8 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv8i64_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vnsrl.wi v28, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vnsrl.wi v8, v28, 0
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 8 x i64> %va to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %tvec
}

define <vscale x 8 x i32> @vtrunc_nxv8i64_nxv8i32(<vscale x 8 x i64> %va) {
; CHECK-LABEL: vtrunc_nxv8i64_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vnsrl.wi v28, v8, 0
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
  %tvec = trunc <vscale x 8 x i64> %va to <vscale x 8 x i32>
  ret <vscale x 8 x i32> %tvec
}

