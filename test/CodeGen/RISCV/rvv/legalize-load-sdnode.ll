; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+experimental-v,+zfh,+f,+d -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v,+zfh,+f,+d -verify-machineinstrs < %s | FileCheck %s

; Check that we are able to legalize scalable-vector loads that require widening.

define <vscale x 3 x i8> @load_nxv3i8(<vscale x 3 x i8>* %ptr) {
; CHECK-LABEL: load_nxv3i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    srli a1, a1, 3
; CHECK-NEXT:    slli a2, a1, 1
; CHECK-NEXT:    add a1, a2, a1
; CHECK-NEXT:    vsetvli zero, a1, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 3 x i8>, <vscale x 3 x i8>* %ptr
  ret <vscale x 3 x i8> %v
}

define <vscale x 5 x half> @load_nxv5f16(<vscale x 5 x half>* %ptr) {
; CHECK-LABEL: load_nxv5f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    srli a1, a1, 3
; CHECK-NEXT:    slli a2, a1, 2
; CHECK-NEXT:    add a1, a2, a1
; CHECK-NEXT:    vsetvli zero, a1, e16, m2, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 5 x half>, <vscale x 5 x half>* %ptr
  ret <vscale x 5 x half> %v
}

define <vscale x 7 x half> @load_nxv7f16(<vscale x 7 x half>* %ptr, <vscale x 7 x half>* %out) {
; CHECK-LABEL: load_nxv7f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    srli a2, a2, 3
; CHECK-NEXT:    slli a3, a2, 3
; CHECK-NEXT:    sub a2, a3, a2
; CHECK-NEXT:    vsetvli zero, a2, e16, m2, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vse16.v v8, (a1)
; CHECK-NEXT:    ret
  %v = load <vscale x 7 x half>, <vscale x 7 x half>* %ptr
  store <vscale x 7 x half> %v, <vscale x 7 x half>* %out
  ret <vscale x 7 x half> %v
}
