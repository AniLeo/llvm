; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s

declare <1 x i1> @llvm.vp.and.v1i1(<1 x i1>, <1 x i1>, <1 x i1>, i32)

define <1 x i1> @and_v1i1(<1 x i1> %b, <1 x i1> %c, <1 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <1 x i1> @llvm.vp.and.v1i1(<1 x i1> %b, <1 x i1> %c, <1 x i1> %a, i32 %evl)
  ret <1 x i1> %v
}

declare <2 x i1> @llvm.vp.and.v2i1(<2 x i1>, <2 x i1>, <2 x i1>, i32)

define <2 x i1> @and_v2i1(<2 x i1> %b, <2 x i1> %c, <2 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <2 x i1> @llvm.vp.and.v2i1(<2 x i1> %b, <2 x i1> %c, <2 x i1> %a, i32 %evl)
  ret <2 x i1> %v
}

declare <4 x i1> @llvm.vp.and.v4i1(<4 x i1>, <4 x i1>, <4 x i1>, i32)

define <4 x i1> @and_v4i1(<4 x i1> %b, <4 x i1> %c, <4 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <4 x i1> @llvm.vp.and.v4i1(<4 x i1> %b, <4 x i1> %c, <4 x i1> %a, i32 %evl)
  ret <4 x i1> %v
}

declare <8 x i1> @llvm.vp.and.v8i1(<8 x i1>, <8 x i1>, <8 x i1>, i32)

define <8 x i1> @and_v8i1(<8 x i1> %b, <8 x i1> %c, <8 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <8 x i1> @llvm.vp.and.v8i1(<8 x i1> %b, <8 x i1> %c, <8 x i1> %a, i32 %evl)
  ret <8 x i1> %v
}

declare <16 x i1> @llvm.vp.and.v16i1(<16 x i1>, <16 x i1>, <16 x i1>, i32)

define <16 x i1> @and_v16i1(<16 x i1> %b, <16 x i1> %c, <16 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <16 x i1> @llvm.vp.and.v16i1(<16 x i1> %b, <16 x i1> %c, <16 x i1> %a, i32 %evl)
  ret <16 x i1> %v
}

declare <vscale x 1 x i1> @llvm.vp.and.nxv1i1(<vscale x 1 x i1>, <vscale x 1 x i1>, <vscale x 1 x i1>, i32)

define <vscale x 1 x i1> @and_nxv1i1(<vscale x 1 x i1> %b, <vscale x 1 x i1> %c, <vscale x 1 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_nxv1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 1 x i1> @llvm.vp.and.nxv1i1(<vscale x 1 x i1> %b, <vscale x 1 x i1> %c, <vscale x 1 x i1> %a, i32 %evl)
  ret <vscale x 1 x i1> %v
}

declare <vscale x 2 x i1> @llvm.vp.and.nxv2i1(<vscale x 2 x i1>, <vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define <vscale x 2 x i1> @and_nxv2i1(<vscale x 2 x i1> %b, <vscale x 2 x i1> %c, <vscale x 2 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x i1> @llvm.vp.and.nxv2i1(<vscale x 2 x i1> %b, <vscale x 2 x i1> %c, <vscale x 2 x i1> %a, i32 %evl)
  ret <vscale x 2 x i1> %v
}

declare <vscale x 4 x i1> @llvm.vp.and.nxv4i1(<vscale x 4 x i1>, <vscale x 4 x i1>, <vscale x 4 x i1>, i32)

define <vscale x 4 x i1> @and_nxv4i1(<vscale x 4 x i1> %b, <vscale x 4 x i1> %c, <vscale x 4 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_nxv4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 4 x i1> @llvm.vp.and.nxv4i1(<vscale x 4 x i1> %b, <vscale x 4 x i1> %c, <vscale x 4 x i1> %a, i32 %evl)
  ret <vscale x 4 x i1> %v
}

declare <vscale x 8 x i1> @llvm.vp.and.nxv8i1(<vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i1>, i32)

define <vscale x 8 x i1> @and_nxv8i1(<vscale x 8 x i1> %b, <vscale x 8 x i1> %c, <vscale x 8 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_nxv8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 8 x i1> @llvm.vp.and.nxv8i1(<vscale x 8 x i1> %b, <vscale x 8 x i1> %c, <vscale x 8 x i1> %a, i32 %evl)
  ret <vscale x 8 x i1> %v
}

declare <vscale x 16 x i1> @llvm.vp.and.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>, i32)

define <vscale x 16 x i1> @and_nxv16i1(<vscale x 16 x i1> %b, <vscale x 16 x i1> %c, <vscale x 16 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_nxv16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m2, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 16 x i1> @llvm.vp.and.nxv16i1(<vscale x 16 x i1> %b, <vscale x 16 x i1> %c, <vscale x 16 x i1> %a, i32 %evl)
  ret <vscale x 16 x i1> %v
}

declare <vscale x 32 x i1> @llvm.vp.and.nxv32i1(<vscale x 32 x i1>, <vscale x 32 x i1>, <vscale x 32 x i1>, i32)

define <vscale x 32 x i1> @and_nxv32i1(<vscale x 32 x i1> %b, <vscale x 32 x i1> %c, <vscale x 32 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_nxv32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m4, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 32 x i1> @llvm.vp.and.nxv32i1(<vscale x 32 x i1> %b, <vscale x 32 x i1> %c, <vscale x 32 x i1> %a, i32 %evl)
  ret <vscale x 32 x i1> %v
}

declare <vscale x 64 x i1> @llvm.vp.and.nxv64i1(<vscale x 64 x i1>, <vscale x 64 x i1>, <vscale x 64 x i1>, i32)

define <vscale x 64 x i1> @and_nxv64i1(<vscale x 64 x i1> %b, <vscale x 64 x i1> %c, <vscale x 64 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: and_nxv64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m8, ta, mu
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 64 x i1> @llvm.vp.and.nxv64i1(<vscale x 64 x i1> %b, <vscale x 64 x i1> %c, <vscale x 64 x i1> %a, i32 %evl)
  ret <vscale x 64 x i1> %v
}

declare <1 x i1> @llvm.vp.or.v1i1(<1 x i1>, <1 x i1>, <1 x i1>, i32)

define <1 x i1> @or_v1i1(<1 x i1> %b, <1 x i1> %c, <1 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <1 x i1> @llvm.vp.or.v1i1(<1 x i1> %b, <1 x i1> %c, <1 x i1> %a, i32 %evl)
  ret <1 x i1> %v
}

declare <2 x i1> @llvm.vp.or.v2i1(<2 x i1>, <2 x i1>, <2 x i1>, i32)

define <2 x i1> @or_v2i1(<2 x i1> %b, <2 x i1> %c, <2 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <2 x i1> @llvm.vp.or.v2i1(<2 x i1> %b, <2 x i1> %c, <2 x i1> %a, i32 %evl)
  ret <2 x i1> %v
}

declare <4 x i1> @llvm.vp.or.v4i1(<4 x i1>, <4 x i1>, <4 x i1>, i32)

define <4 x i1> @or_v4i1(<4 x i1> %b, <4 x i1> %c, <4 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <4 x i1> @llvm.vp.or.v4i1(<4 x i1> %b, <4 x i1> %c, <4 x i1> %a, i32 %evl)
  ret <4 x i1> %v
}

declare <8 x i1> @llvm.vp.or.v8i1(<8 x i1>, <8 x i1>, <8 x i1>, i32)

define <8 x i1> @or_v8i1(<8 x i1> %b, <8 x i1> %c, <8 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <8 x i1> @llvm.vp.or.v8i1(<8 x i1> %b, <8 x i1> %c, <8 x i1> %a, i32 %evl)
  ret <8 x i1> %v
}

declare <16 x i1> @llvm.vp.or.v16i1(<16 x i1>, <16 x i1>, <16 x i1>, i32)

define <16 x i1> @or_v16i1(<16 x i1> %b, <16 x i1> %c, <16 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <16 x i1> @llvm.vp.or.v16i1(<16 x i1> %b, <16 x i1> %c, <16 x i1> %a, i32 %evl)
  ret <16 x i1> %v
}

declare <vscale x 1 x i1> @llvm.vp.or.nxv1i1(<vscale x 1 x i1>, <vscale x 1 x i1>, <vscale x 1 x i1>, i32)

define <vscale x 1 x i1> @or_nxv1i1(<vscale x 1 x i1> %b, <vscale x 1 x i1> %c, <vscale x 1 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_nxv1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 1 x i1> @llvm.vp.or.nxv1i1(<vscale x 1 x i1> %b, <vscale x 1 x i1> %c, <vscale x 1 x i1> %a, i32 %evl)
  ret <vscale x 1 x i1> %v
}

declare <vscale x 2 x i1> @llvm.vp.or.nxv2i1(<vscale x 2 x i1>, <vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define <vscale x 2 x i1> @or_nxv2i1(<vscale x 2 x i1> %b, <vscale x 2 x i1> %c, <vscale x 2 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x i1> @llvm.vp.or.nxv2i1(<vscale x 2 x i1> %b, <vscale x 2 x i1> %c, <vscale x 2 x i1> %a, i32 %evl)
  ret <vscale x 2 x i1> %v
}

declare <vscale x 4 x i1> @llvm.vp.or.nxv4i1(<vscale x 4 x i1>, <vscale x 4 x i1>, <vscale x 4 x i1>, i32)

define <vscale x 4 x i1> @or_nxv4i1(<vscale x 4 x i1> %b, <vscale x 4 x i1> %c, <vscale x 4 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_nxv4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 4 x i1> @llvm.vp.or.nxv4i1(<vscale x 4 x i1> %b, <vscale x 4 x i1> %c, <vscale x 4 x i1> %a, i32 %evl)
  ret <vscale x 4 x i1> %v
}

declare <vscale x 8 x i1> @llvm.vp.or.nxv8i1(<vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i1>, i32)

define <vscale x 8 x i1> @or_nxv8i1(<vscale x 8 x i1> %b, <vscale x 8 x i1> %c, <vscale x 8 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_nxv8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 8 x i1> @llvm.vp.or.nxv8i1(<vscale x 8 x i1> %b, <vscale x 8 x i1> %c, <vscale x 8 x i1> %a, i32 %evl)
  ret <vscale x 8 x i1> %v
}

declare <vscale x 16 x i1> @llvm.vp.or.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>, i32)

define <vscale x 16 x i1> @or_nxv16i1(<vscale x 16 x i1> %b, <vscale x 16 x i1> %c, <vscale x 16 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_nxv16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m2, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 16 x i1> @llvm.vp.or.nxv16i1(<vscale x 16 x i1> %b, <vscale x 16 x i1> %c, <vscale x 16 x i1> %a, i32 %evl)
  ret <vscale x 16 x i1> %v
}

declare <vscale x 32 x i1> @llvm.vp.or.nxv32i1(<vscale x 32 x i1>, <vscale x 32 x i1>, <vscale x 32 x i1>, i32)

define <vscale x 32 x i1> @or_nxv32i1(<vscale x 32 x i1> %b, <vscale x 32 x i1> %c, <vscale x 32 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_nxv32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m4, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 32 x i1> @llvm.vp.or.nxv32i1(<vscale x 32 x i1> %b, <vscale x 32 x i1> %c, <vscale x 32 x i1> %a, i32 %evl)
  ret <vscale x 32 x i1> %v
}

declare <vscale x 64 x i1> @llvm.vp.or.nxv64i1(<vscale x 64 x i1>, <vscale x 64 x i1>, <vscale x 64 x i1>, i32)

define <vscale x 64 x i1> @or_nxv64i1(<vscale x 64 x i1> %b, <vscale x 64 x i1> %c, <vscale x 64 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: or_nxv64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m8, ta, mu
; CHECK-NEXT:    vmor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 64 x i1> @llvm.vp.or.nxv64i1(<vscale x 64 x i1> %b, <vscale x 64 x i1> %c, <vscale x 64 x i1> %a, i32 %evl)
  ret <vscale x 64 x i1> %v
}

declare <1 x i1> @llvm.vp.xor.v1i1(<1 x i1>, <1 x i1>, <1 x i1>, i32)

define <1 x i1> @xor_v1i1(<1 x i1> %b, <1 x i1> %c, <1 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <1 x i1> @llvm.vp.xor.v1i1(<1 x i1> %b, <1 x i1> %c, <1 x i1> %a, i32 %evl)
  ret <1 x i1> %v
}

declare <2 x i1> @llvm.vp.xor.v2i1(<2 x i1>, <2 x i1>, <2 x i1>, i32)

define <2 x i1> @xor_v2i1(<2 x i1> %b, <2 x i1> %c, <2 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <2 x i1> @llvm.vp.xor.v2i1(<2 x i1> %b, <2 x i1> %c, <2 x i1> %a, i32 %evl)
  ret <2 x i1> %v
}

declare <4 x i1> @llvm.vp.xor.v4i1(<4 x i1>, <4 x i1>, <4 x i1>, i32)

define <4 x i1> @xor_v4i1(<4 x i1> %b, <4 x i1> %c, <4 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <4 x i1> @llvm.vp.xor.v4i1(<4 x i1> %b, <4 x i1> %c, <4 x i1> %a, i32 %evl)
  ret <4 x i1> %v
}

declare <8 x i1> @llvm.vp.xor.v8i1(<8 x i1>, <8 x i1>, <8 x i1>, i32)

define <8 x i1> @xor_v8i1(<8 x i1> %b, <8 x i1> %c, <8 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <8 x i1> @llvm.vp.xor.v8i1(<8 x i1> %b, <8 x i1> %c, <8 x i1> %a, i32 %evl)
  ret <8 x i1> %v
}

declare <16 x i1> @llvm.vp.xor.v16i1(<16 x i1>, <16 x i1>, <16 x i1>, i32)

define <16 x i1> @xor_v16i1(<16 x i1> %b, <16 x i1> %c, <16 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <16 x i1> @llvm.vp.xor.v16i1(<16 x i1> %b, <16 x i1> %c, <16 x i1> %a, i32 %evl)
  ret <16 x i1> %v
}

declare <vscale x 1 x i1> @llvm.vp.xor.nxv1i1(<vscale x 1 x i1>, <vscale x 1 x i1>, <vscale x 1 x i1>, i32)

define <vscale x 1 x i1> @xor_nxv1i1(<vscale x 1 x i1> %b, <vscale x 1 x i1> %c, <vscale x 1 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_nxv1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 1 x i1> @llvm.vp.xor.nxv1i1(<vscale x 1 x i1> %b, <vscale x 1 x i1> %c, <vscale x 1 x i1> %a, i32 %evl)
  ret <vscale x 1 x i1> %v
}

declare <vscale x 2 x i1> @llvm.vp.xor.nxv2i1(<vscale x 2 x i1>, <vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define <vscale x 2 x i1> @xor_nxv2i1(<vscale x 2 x i1> %b, <vscale x 2 x i1> %c, <vscale x 2 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x i1> @llvm.vp.xor.nxv2i1(<vscale x 2 x i1> %b, <vscale x 2 x i1> %c, <vscale x 2 x i1> %a, i32 %evl)
  ret <vscale x 2 x i1> %v
}

declare <vscale x 4 x i1> @llvm.vp.xor.nxv4i1(<vscale x 4 x i1>, <vscale x 4 x i1>, <vscale x 4 x i1>, i32)

define <vscale x 4 x i1> @xor_nxv4i1(<vscale x 4 x i1> %b, <vscale x 4 x i1> %c, <vscale x 4 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_nxv4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 4 x i1> @llvm.vp.xor.nxv4i1(<vscale x 4 x i1> %b, <vscale x 4 x i1> %c, <vscale x 4 x i1> %a, i32 %evl)
  ret <vscale x 4 x i1> %v
}

declare <vscale x 8 x i1> @llvm.vp.xor.nxv8i1(<vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i1>, i32)

define <vscale x 8 x i1> @xor_nxv8i1(<vscale x 8 x i1> %b, <vscale x 8 x i1> %c, <vscale x 8 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_nxv8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 8 x i1> @llvm.vp.xor.nxv8i1(<vscale x 8 x i1> %b, <vscale x 8 x i1> %c, <vscale x 8 x i1> %a, i32 %evl)
  ret <vscale x 8 x i1> %v
}

declare <vscale x 16 x i1> @llvm.vp.xor.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>, i32)

define <vscale x 16 x i1> @xor_nxv16i1(<vscale x 16 x i1> %b, <vscale x 16 x i1> %c, <vscale x 16 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_nxv16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m2, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 16 x i1> @llvm.vp.xor.nxv16i1(<vscale x 16 x i1> %b, <vscale x 16 x i1> %c, <vscale x 16 x i1> %a, i32 %evl)
  ret <vscale x 16 x i1> %v
}

declare <vscale x 32 x i1> @llvm.vp.xor.nxv32i1(<vscale x 32 x i1>, <vscale x 32 x i1>, <vscale x 32 x i1>, i32)

define <vscale x 32 x i1> @xor_nxv32i1(<vscale x 32 x i1> %b, <vscale x 32 x i1> %c, <vscale x 32 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_nxv32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m4, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 32 x i1> @llvm.vp.xor.nxv32i1(<vscale x 32 x i1> %b, <vscale x 32 x i1> %c, <vscale x 32 x i1> %a, i32 %evl)
  ret <vscale x 32 x i1> %v
}

declare <vscale x 64 x i1> @llvm.vp.xor.nxv64i1(<vscale x 64 x i1>, <vscale x 64 x i1>, <vscale x 64 x i1>, i32)

define <vscale x 64 x i1> @xor_nxv64i1(<vscale x 64 x i1> %b, <vscale x 64 x i1> %c, <vscale x 64 x i1> %a, i32 zeroext %evl) {
; CHECK-LABEL: xor_nxv64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m8, ta, mu
; CHECK-NEXT:    vmxor.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 64 x i1> @llvm.vp.xor.nxv64i1(<vscale x 64 x i1> %b, <vscale x 64 x i1> %c, <vscale x 64 x i1> %a, i32 %evl)
  ret <vscale x 64 x i1> %v
}
