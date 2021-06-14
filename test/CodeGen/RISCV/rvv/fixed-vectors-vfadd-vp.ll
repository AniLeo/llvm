; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=ilp32d -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=lp64d -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s

declare <2 x half> @llvm.vp.fadd.v2f16(<2 x half>, <2 x half>, <2 x i1>, i32)

define <2 x half> @vfadd_vv_v2f16(<2 x half> %va, <2 x half> %b, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x half> @llvm.vp.fadd.v2f16(<2 x half> %va, <2 x half> %b, <2 x i1> %m, i32 %evl)
  ret <2 x half> %v
}

define <2 x half> @vfadd_vv_v2f16_unmasked(<2 x half> %va, <2 x half> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v2f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> undef, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer
  %v = call <2 x half> @llvm.vp.fadd.v2f16(<2 x half> %va, <2 x half> %b, <2 x i1> %m, i32 %evl)
  ret <2 x half> %v
}

define <2 x half> @vfadd_vf_v2f16(<2 x half> %va, half %b, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v25, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <2 x half> undef, half %b, i32 0
  %vb = shufflevector <2 x half> %elt.head, <2 x half> undef, <2 x i32> zeroinitializer
  %v = call <2 x half> @llvm.vp.fadd.v2f16(<2 x half> %va, <2 x half> %vb, <2 x i1> %m, i32 %evl)
  ret <2 x half> %v
}

define <2 x half> @vfadd_vf_v2f16_unmasked(<2 x half> %va, half %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v2f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <2 x half> undef, half %b, i32 0
  %vb = shufflevector <2 x half> %elt.head, <2 x half> undef, <2 x i32> zeroinitializer
  %head = insertelement <2 x i1> undef, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer
  %v = call <2 x half> @llvm.vp.fadd.v2f16(<2 x half> %va, <2 x half> %vb, <2 x i1> %m, i32 %evl)
  ret <2 x half> %v
}

declare <4 x half> @llvm.vp.fadd.v4f16(<4 x half>, <4 x half>, <4 x i1>, i32)

define <4 x half> @vfadd_vv_v4f16(<4 x half> %va, <4 x half> %b, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x half> @llvm.vp.fadd.v4f16(<4 x half> %va, <4 x half> %b, <4 x i1> %m, i32 %evl)
  ret <4 x half> %v
}

define <4 x half> @vfadd_vv_v4f16_unmasked(<4 x half> %va, <4 x half> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v4f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> undef, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer
  %v = call <4 x half> @llvm.vp.fadd.v4f16(<4 x half> %va, <4 x half> %b, <4 x i1> %m, i32 %evl)
  ret <4 x half> %v
}

define <4 x half> @vfadd_vf_v4f16(<4 x half> %va, half %b, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v25, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <4 x half> undef, half %b, i32 0
  %vb = shufflevector <4 x half> %elt.head, <4 x half> undef, <4 x i32> zeroinitializer
  %v = call <4 x half> @llvm.vp.fadd.v4f16(<4 x half> %va, <4 x half> %vb, <4 x i1> %m, i32 %evl)
  ret <4 x half> %v
}

define <4 x half> @vfadd_vf_v4f16_unmasked(<4 x half> %va, half %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v4f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <4 x half> undef, half %b, i32 0
  %vb = shufflevector <4 x half> %elt.head, <4 x half> undef, <4 x i32> zeroinitializer
  %head = insertelement <4 x i1> undef, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer
  %v = call <4 x half> @llvm.vp.fadd.v4f16(<4 x half> %va, <4 x half> %vb, <4 x i1> %m, i32 %evl)
  ret <4 x half> %v
}

declare <8 x half> @llvm.vp.fadd.v8f16(<8 x half>, <8 x half>, <8 x i1>, i32)

define <8 x half> @vfadd_vv_v8f16(<8 x half> %va, <8 x half> %b, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x half> @llvm.vp.fadd.v8f16(<8 x half> %va, <8 x half> %b, <8 x i1> %m, i32 %evl)
  ret <8 x half> %v
}

define <8 x half> @vfadd_vv_v8f16_unmasked(<8 x half> %va, <8 x half> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v8f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> undef, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer
  %v = call <8 x half> @llvm.vp.fadd.v8f16(<8 x half> %va, <8 x half> %b, <8 x i1> %m, i32 %evl)
  ret <8 x half> %v
}

define <8 x half> @vfadd_vf_v8f16(<8 x half> %va, half %b, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v25, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <8 x half> undef, half %b, i32 0
  %vb = shufflevector <8 x half> %elt.head, <8 x half> undef, <8 x i32> zeroinitializer
  %v = call <8 x half> @llvm.vp.fadd.v8f16(<8 x half> %va, <8 x half> %vb, <8 x i1> %m, i32 %evl)
  ret <8 x half> %v
}

define <8 x half> @vfadd_vf_v8f16_unmasked(<8 x half> %va, half %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v8f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <8 x half> undef, half %b, i32 0
  %vb = shufflevector <8 x half> %elt.head, <8 x half> undef, <8 x i32> zeroinitializer
  %head = insertelement <8 x i1> undef, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer
  %v = call <8 x half> @llvm.vp.fadd.v8f16(<8 x half> %va, <8 x half> %vb, <8 x i1> %m, i32 %evl)
  ret <8 x half> %v
}

declare <16 x half> @llvm.vp.fadd.v16f16(<16 x half>, <16 x half>, <16 x i1>, i32)

define <16 x half> @vfadd_vv_v16f16(<16 x half> %va, <16 x half> %b, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x half> @llvm.vp.fadd.v16f16(<16 x half> %va, <16 x half> %b, <16 x i1> %m, i32 %evl)
  ret <16 x half> %v
}

define <16 x half> @vfadd_vv_v16f16_unmasked(<16 x half> %va, <16 x half> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v16f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v10
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> undef, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer
  %v = call <16 x half> @llvm.vp.fadd.v16f16(<16 x half> %va, <16 x half> %b, <16 x i1> %m, i32 %evl)
  ret <16 x half> %v
}

define <16 x half> @vfadd_vf_v16f16(<16 x half> %va, half %b, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, mu
; CHECK-NEXT:    vfmv.v.f v26, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v26, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <16 x half> undef, half %b, i32 0
  %vb = shufflevector <16 x half> %elt.head, <16 x half> undef, <16 x i32> zeroinitializer
  %v = call <16 x half> @llvm.vp.fadd.v16f16(<16 x half> %va, <16 x half> %vb, <16 x i1> %m, i32 %evl)
  ret <16 x half> %v
}

define <16 x half> @vfadd_vf_v16f16_unmasked(<16 x half> %va, half %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v16f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <16 x half> undef, half %b, i32 0
  %vb = shufflevector <16 x half> %elt.head, <16 x half> undef, <16 x i32> zeroinitializer
  %head = insertelement <16 x i1> undef, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer
  %v = call <16 x half> @llvm.vp.fadd.v16f16(<16 x half> %va, <16 x half> %vb, <16 x i1> %m, i32 %evl)
  ret <16 x half> %v
}

declare <2 x float> @llvm.vp.fadd.v2f32(<2 x float>, <2 x float>, <2 x i1>, i32)

define <2 x float> @vfadd_vv_v2f32(<2 x float> %va, <2 x float> %b, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x float> @llvm.vp.fadd.v2f32(<2 x float> %va, <2 x float> %b, <2 x i1> %m, i32 %evl)
  ret <2 x float> %v
}

define <2 x float> @vfadd_vv_v2f32_unmasked(<2 x float> %va, <2 x float> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v2f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> undef, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer
  %v = call <2 x float> @llvm.vp.fadd.v2f32(<2 x float> %va, <2 x float> %b, <2 x i1> %m, i32 %evl)
  ret <2 x float> %v
}

define <2 x float> @vfadd_vf_v2f32(<2 x float> %va, float %b, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v25, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <2 x float> undef, float %b, i32 0
  %vb = shufflevector <2 x float> %elt.head, <2 x float> undef, <2 x i32> zeroinitializer
  %v = call <2 x float> @llvm.vp.fadd.v2f32(<2 x float> %va, <2 x float> %vb, <2 x i1> %m, i32 %evl)
  ret <2 x float> %v
}

define <2 x float> @vfadd_vf_v2f32_unmasked(<2 x float> %va, float %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v2f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <2 x float> undef, float %b, i32 0
  %vb = shufflevector <2 x float> %elt.head, <2 x float> undef, <2 x i32> zeroinitializer
  %head = insertelement <2 x i1> undef, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer
  %v = call <2 x float> @llvm.vp.fadd.v2f32(<2 x float> %va, <2 x float> %vb, <2 x i1> %m, i32 %evl)
  ret <2 x float> %v
}

declare <4 x float> @llvm.vp.fadd.v4f32(<4 x float>, <4 x float>, <4 x i1>, i32)

define <4 x float> @vfadd_vv_v4f32(<4 x float> %va, <4 x float> %b, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x float> @llvm.vp.fadd.v4f32(<4 x float> %va, <4 x float> %b, <4 x i1> %m, i32 %evl)
  ret <4 x float> %v
}

define <4 x float> @vfadd_vv_v4f32_unmasked(<4 x float> %va, <4 x float> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v4f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> undef, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer
  %v = call <4 x float> @llvm.vp.fadd.v4f32(<4 x float> %va, <4 x float> %b, <4 x i1> %m, i32 %evl)
  ret <4 x float> %v
}

define <4 x float> @vfadd_vf_v4f32(<4 x float> %va, float %b, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v25, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <4 x float> undef, float %b, i32 0
  %vb = shufflevector <4 x float> %elt.head, <4 x float> undef, <4 x i32> zeroinitializer
  %v = call <4 x float> @llvm.vp.fadd.v4f32(<4 x float> %va, <4 x float> %vb, <4 x i1> %m, i32 %evl)
  ret <4 x float> %v
}

define <4 x float> @vfadd_vf_v4f32_unmasked(<4 x float> %va, float %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v4f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <4 x float> undef, float %b, i32 0
  %vb = shufflevector <4 x float> %elt.head, <4 x float> undef, <4 x i32> zeroinitializer
  %head = insertelement <4 x i1> undef, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer
  %v = call <4 x float> @llvm.vp.fadd.v4f32(<4 x float> %va, <4 x float> %vb, <4 x i1> %m, i32 %evl)
  ret <4 x float> %v
}

declare <8 x float> @llvm.vp.fadd.v8f32(<8 x float>, <8 x float>, <8 x i1>, i32)

define <8 x float> @vfadd_vv_v8f32(<8 x float> %va, <8 x float> %b, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x float> @llvm.vp.fadd.v8f32(<8 x float> %va, <8 x float> %b, <8 x i1> %m, i32 %evl)
  ret <8 x float> %v
}

define <8 x float> @vfadd_vv_v8f32_unmasked(<8 x float> %va, <8 x float> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v8f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v10
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> undef, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer
  %v = call <8 x float> @llvm.vp.fadd.v8f32(<8 x float> %va, <8 x float> %b, <8 x i1> %m, i32 %evl)
  ret <8 x float> %v
}

define <8 x float> @vfadd_vf_v8f32(<8 x float> %va, float %b, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; CHECK-NEXT:    vfmv.v.f v26, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v26, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <8 x float> undef, float %b, i32 0
  %vb = shufflevector <8 x float> %elt.head, <8 x float> undef, <8 x i32> zeroinitializer
  %v = call <8 x float> @llvm.vp.fadd.v8f32(<8 x float> %va, <8 x float> %vb, <8 x i1> %m, i32 %evl)
  ret <8 x float> %v
}

define <8 x float> @vfadd_vf_v8f32_unmasked(<8 x float> %va, float %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v8f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <8 x float> undef, float %b, i32 0
  %vb = shufflevector <8 x float> %elt.head, <8 x float> undef, <8 x i32> zeroinitializer
  %head = insertelement <8 x i1> undef, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer
  %v = call <8 x float> @llvm.vp.fadd.v8f32(<8 x float> %va, <8 x float> %vb, <8 x i1> %m, i32 %evl)
  ret <8 x float> %v
}

declare <16 x float> @llvm.vp.fadd.v16f32(<16 x float>, <16 x float>, <16 x i1>, i32)

define <16 x float> @vfadd_vv_v16f32(<16 x float> %va, <16 x float> %b, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v12, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x float> @llvm.vp.fadd.v16f32(<16 x float> %va, <16 x float> %b, <16 x i1> %m, i32 %evl)
  ret <16 x float> %v
}

define <16 x float> @vfadd_vv_v16f32_unmasked(<16 x float> %va, <16 x float> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v16f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v12
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> undef, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer
  %v = call <16 x float> @llvm.vp.fadd.v16f32(<16 x float> %va, <16 x float> %b, <16 x i1> %m, i32 %evl)
  ret <16 x float> %v
}

define <16 x float> @vfadd_vf_v16f32(<16 x float> %va, float %b, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, mu
; CHECK-NEXT:    vfmv.v.f v28, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v28, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <16 x float> undef, float %b, i32 0
  %vb = shufflevector <16 x float> %elt.head, <16 x float> undef, <16 x i32> zeroinitializer
  %v = call <16 x float> @llvm.vp.fadd.v16f32(<16 x float> %va, <16 x float> %vb, <16 x i1> %m, i32 %evl)
  ret <16 x float> %v
}

define <16 x float> @vfadd_vf_v16f32_unmasked(<16 x float> %va, float %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v16f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <16 x float> undef, float %b, i32 0
  %vb = shufflevector <16 x float> %elt.head, <16 x float> undef, <16 x i32> zeroinitializer
  %head = insertelement <16 x i1> undef, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer
  %v = call <16 x float> @llvm.vp.fadd.v16f32(<16 x float> %va, <16 x float> %vb, <16 x i1> %m, i32 %evl)
  ret <16 x float> %v
}

declare <2 x double> @llvm.vp.fadd.v2f64(<2 x double>, <2 x double>, <2 x i1>, i32)

define <2 x double> @vfadd_vv_v2f64(<2 x double> %va, <2 x double> %b, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x double> @llvm.vp.fadd.v2f64(<2 x double> %va, <2 x double> %b, <2 x i1> %m, i32 %evl)
  ret <2 x double> %v
}

define <2 x double> @vfadd_vv_v2f64_unmasked(<2 x double> %va, <2 x double> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v2f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> undef, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer
  %v = call <2 x double> @llvm.vp.fadd.v2f64(<2 x double> %va, <2 x double> %b, <2 x i1> %m, i32 %evl)
  ret <2 x double> %v
}

define <2 x double> @vfadd_vf_v2f64(<2 x double> %va, double %b, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v25, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <2 x double> undef, double %b, i32 0
  %vb = shufflevector <2 x double> %elt.head, <2 x double> undef, <2 x i32> zeroinitializer
  %v = call <2 x double> @llvm.vp.fadd.v2f64(<2 x double> %va, <2 x double> %vb, <2 x i1> %m, i32 %evl)
  ret <2 x double> %v
}

define <2 x double> @vfadd_vf_v2f64_unmasked(<2 x double> %va, double %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v2f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <2 x double> undef, double %b, i32 0
  %vb = shufflevector <2 x double> %elt.head, <2 x double> undef, <2 x i32> zeroinitializer
  %head = insertelement <2 x i1> undef, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer
  %v = call <2 x double> @llvm.vp.fadd.v2f64(<2 x double> %va, <2 x double> %vb, <2 x i1> %m, i32 %evl)
  ret <2 x double> %v
}

declare <4 x double> @llvm.vp.fadd.v4f64(<4 x double>, <4 x double>, <4 x i1>, i32)

define <4 x double> @vfadd_vv_v4f64(<4 x double> %va, <4 x double> %b, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x double> @llvm.vp.fadd.v4f64(<4 x double> %va, <4 x double> %b, <4 x i1> %m, i32 %evl)
  ret <4 x double> %v
}

define <4 x double> @vfadd_vv_v4f64_unmasked(<4 x double> %va, <4 x double> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v4f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v10
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> undef, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer
  %v = call <4 x double> @llvm.vp.fadd.v4f64(<4 x double> %va, <4 x double> %b, <4 x i1> %m, i32 %evl)
  ret <4 x double> %v
}

define <4 x double> @vfadd_vf_v4f64(<4 x double> %va, double %b, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e64, m2, ta, mu
; CHECK-NEXT:    vfmv.v.f v26, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v26, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <4 x double> undef, double %b, i32 0
  %vb = shufflevector <4 x double> %elt.head, <4 x double> undef, <4 x i32> zeroinitializer
  %v = call <4 x double> @llvm.vp.fadd.v4f64(<4 x double> %va, <4 x double> %vb, <4 x i1> %m, i32 %evl)
  ret <4 x double> %v
}

define <4 x double> @vfadd_vf_v4f64_unmasked(<4 x double> %va, double %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v4f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <4 x double> undef, double %b, i32 0
  %vb = shufflevector <4 x double> %elt.head, <4 x double> undef, <4 x i32> zeroinitializer
  %head = insertelement <4 x i1> undef, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer
  %v = call <4 x double> @llvm.vp.fadd.v4f64(<4 x double> %va, <4 x double> %vb, <4 x i1> %m, i32 %evl)
  ret <4 x double> %v
}

declare <8 x double> @llvm.vp.fadd.v8f64(<8 x double>, <8 x double>, <8 x i1>, i32)

define <8 x double> @vfadd_vv_v8f64(<8 x double> %va, <8 x double> %b, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v12, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x double> @llvm.vp.fadd.v8f64(<8 x double> %va, <8 x double> %b, <8 x i1> %m, i32 %evl)
  ret <8 x double> %v
}

define <8 x double> @vfadd_vv_v8f64_unmasked(<8 x double> %va, <8 x double> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v8f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v12
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> undef, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer
  %v = call <8 x double> @llvm.vp.fadd.v8f64(<8 x double> %va, <8 x double> %b, <8 x i1> %m, i32 %evl)
  ret <8 x double> %v
}

define <8 x double> @vfadd_vf_v8f64(<8 x double> %va, double %b, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; CHECK-NEXT:    vfmv.v.f v28, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v28, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <8 x double> undef, double %b, i32 0
  %vb = shufflevector <8 x double> %elt.head, <8 x double> undef, <8 x i32> zeroinitializer
  %v = call <8 x double> @llvm.vp.fadd.v8f64(<8 x double> %va, <8 x double> %vb, <8 x i1> %m, i32 %evl)
  ret <8 x double> %v
}

define <8 x double> @vfadd_vf_v8f64_unmasked(<8 x double> %va, double %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v8f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <8 x double> undef, double %b, i32 0
  %vb = shufflevector <8 x double> %elt.head, <8 x double> undef, <8 x i32> zeroinitializer
  %head = insertelement <8 x i1> undef, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer
  %v = call <8 x double> @llvm.vp.fadd.v8f64(<8 x double> %va, <8 x double> %vb, <8 x i1> %m, i32 %evl)
  ret <8 x double> %v
}

declare <16 x double> @llvm.vp.fadd.v16f64(<16 x double>, <16 x double>, <16 x i1>, i32)

define <16 x double> @vfadd_vv_v16f64(<16 x double> %va, <16 x double> %b, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v16f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v16, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x double> @llvm.vp.fadd.v16f64(<16 x double> %va, <16 x double> %b, <16 x i1> %m, i32 %evl)
  ret <16 x double> %v
}

define <16 x double> @vfadd_vv_v16f64_unmasked(<16 x double> %va, <16 x double> %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vv_v16f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> undef, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer
  %v = call <16 x double> @llvm.vp.fadd.v16f64(<16 x double> %va, <16 x double> %b, <16 x i1> %m, i32 %evl)
  ret <16 x double> %v
}

define <16 x double> @vfadd_vf_v16f64(<16 x double> %va, double %b, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v16f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e64, m8, ta, mu
; CHECK-NEXT:    vfmv.v.f v16, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v16, v0.t
; CHECK-NEXT:    ret
  %elt.head = insertelement <16 x double> undef, double %b, i32 0
  %vb = shufflevector <16 x double> %elt.head, <16 x double> undef, <16 x i32> zeroinitializer
  %v = call <16 x double> @llvm.vp.fadd.v16f64(<16 x double> %va, <16 x double> %vb, <16 x i1> %m, i32 %evl)
  ret <16 x double> %v
}

define <16 x double> @vfadd_vf_v16f64_unmasked(<16 x double> %va, double %b, i32 zeroext %evl) {
; CHECK-LABEL: vfadd_vf_v16f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, mu
; CHECK-NEXT:    vfadd.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %elt.head = insertelement <16 x double> undef, double %b, i32 0
  %vb = shufflevector <16 x double> %elt.head, <16 x double> undef, <16 x i32> zeroinitializer
  %head = insertelement <16 x i1> undef, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer
  %v = call <16 x double> @llvm.vp.fadd.v16f64(<16 x double> %va, <16 x double> %vb, <16 x i1> %m, i32 %evl)
  ret <16 x double> %v
}
