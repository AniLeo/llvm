; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=ilp32d -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=lp64d -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s

declare half @llvm.vp.reduce.fadd.v2f16(half, <2 x half>, <2 x i1>, i32)

define half @vpreduce_fadd_v2f16(half %s, <2 x half> %v, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_fadd_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, tu, mu
; CHECK-NEXT:    vfredsum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call reassoc half @llvm.vp.reduce.fadd.v2f16(half %s, <2 x half> %v, <2 x i1> %m, i32 %evl)
  ret half %r
}

define half @vpreduce_ord_fadd_v2f16(half %s, <2 x half> %v, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_ord_fadd_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, tu, mu
; CHECK-NEXT:    vfredosum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call half @llvm.vp.reduce.fadd.v2f16(half %s, <2 x half> %v, <2 x i1> %m, i32 %evl)
  ret half %r
}

declare half @llvm.vp.reduce.fadd.v4f16(half, <4 x half>, <4 x i1>, i32)

define half @vpreduce_fadd_v4f16(half %s, <4 x half> %v, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_fadd_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, tu, mu
; CHECK-NEXT:    vfredsum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call reassoc half @llvm.vp.reduce.fadd.v4f16(half %s, <4 x half> %v, <4 x i1> %m, i32 %evl)
  ret half %r
}

define half @vpreduce_ord_fadd_v4f16(half %s, <4 x half> %v, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_ord_fadd_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, tu, mu
; CHECK-NEXT:    vfredosum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call half @llvm.vp.reduce.fadd.v4f16(half %s, <4 x half> %v, <4 x i1> %m, i32 %evl)
  ret half %r
}

declare float @llvm.vp.reduce.fadd.v2f32(float, <2 x float>, <2 x i1>, i32)

define float @vpreduce_fadd_v2f32(float %s, <2 x float> %v, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_fadd_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, tu, mu
; CHECK-NEXT:    vfredsum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call reassoc float @llvm.vp.reduce.fadd.v2f32(float %s, <2 x float> %v, <2 x i1> %m, i32 %evl)
  ret float %r
}

define float @vpreduce_ord_fadd_v2f32(float %s, <2 x float> %v, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_ord_fadd_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, tu, mu
; CHECK-NEXT:    vfredosum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call float @llvm.vp.reduce.fadd.v2f32(float %s, <2 x float> %v, <2 x i1> %m, i32 %evl)
  ret float %r
}

declare float @llvm.vp.reduce.fadd.v4f32(float, <4 x float>, <4 x i1>, i32)

define float @vpreduce_fadd_v4f32(float %s, <4 x float> %v, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_fadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, tu, mu
; CHECK-NEXT:    vfredsum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call reassoc float @llvm.vp.reduce.fadd.v4f32(float %s, <4 x float> %v, <4 x i1> %m, i32 %evl)
  ret float %r
}

define float @vpreduce_ord_fadd_v4f32(float %s, <4 x float> %v, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_ord_fadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, tu, mu
; CHECK-NEXT:    vfredosum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call float @llvm.vp.reduce.fadd.v4f32(float %s, <4 x float> %v, <4 x i1> %m, i32 %evl)
  ret float %r
}

declare double @llvm.vp.reduce.fadd.v2f64(double, <2 x double>, <2 x i1>, i32)

define double @vpreduce_fadd_v2f64(double %s, <2 x double> %v, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_fadd_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, tu, mu
; CHECK-NEXT:    vfredsum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call reassoc double @llvm.vp.reduce.fadd.v2f64(double %s, <2 x double> %v, <2 x i1> %m, i32 %evl)
  ret double %r
}

define double @vpreduce_ord_fadd_v2f64(double %s, <2 x double> %v, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_ord_fadd_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, tu, mu
; CHECK-NEXT:    vfredosum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call double @llvm.vp.reduce.fadd.v2f64(double %s, <2 x double> %v, <2 x i1> %m, i32 %evl)
  ret double %r
}

declare double @llvm.vp.reduce.fadd.v4f64(double, <4 x double>, <4 x i1>, i32)

define double @vpreduce_fadd_v4f64(double %s, <4 x double> %v, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_fadd_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, tu, mu
; CHECK-NEXT:    vfredsum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call reassoc double @llvm.vp.reduce.fadd.v4f64(double %s, <4 x double> %v, <4 x i1> %m, i32 %evl)
  ret double %r
}

define double @vpreduce_ord_fadd_v4f64(double %s, <4 x double> %v, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_ord_fadd_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, tu, mu
; CHECK-NEXT:    vfredosum.vs v25, v8, v25, v0.t
; CHECK-NEXT:    vfmv.f.s fa0, v25
; CHECK-NEXT:    ret
  %r = call double @llvm.vp.reduce.fadd.v4f64(double %s, <4 x double> %v, <4 x i1> %m, i32 %evl)
  ret double %r
}
