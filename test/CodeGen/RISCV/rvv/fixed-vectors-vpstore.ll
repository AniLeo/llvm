; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+v -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+v -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s

declare void @llvm.vp.store.v2i8.p0v2i8(<2 x i8>, <2 x i8>*, <2 x i1>, i32)

define void @vpstore_v2i8(<2 x i8> %val, <2 x i8>* %ptr, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v2i8.p0v2i8(<2 x i8> %val, <2 x i8>* %ptr, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v4i8.p0v4i8(<4 x i8>, <4 x i8>*, <4 x i1>, i32)

define void @vpstore_v4i8(<4 x i8> %val, <4 x i8>* %ptr, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, mf4, ta, mu
; CHECK-NEXT:    vse8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v4i8.p0v4i8(<4 x i8> %val, <4 x i8>* %ptr, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v8i8.p0v8i8(<8 x i8>, <8 x i8>*, <8 x i1>, i32)

define void @vpstore_v8i8(<8 x i8> %val, <8 x i8>* %ptr, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, mf2, ta, mu
; CHECK-NEXT:    vse8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v8i8.p0v8i8(<8 x i8> %val, <8 x i8>* %ptr, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v2i16.p0v2i16(<2 x i16>, <2 x i16>*, <2 x i1>, i32)

define void @vpstore_v2i16(<2 x i16> %val, <2 x i16>* %ptr, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e16, mf4, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v2i16.p0v2i16(<2 x i16> %val, <2 x i16>* %ptr, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v4i16.p0v4i16(<4 x i16>, <4 x i16>*, <4 x i1>, i32)

define void @vpstore_v4i16(<4 x i16> %val, <4 x i16>* %ptr, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e16, mf2, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v4i16.p0v4i16(<4 x i16> %val, <4 x i16>* %ptr, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v8i16.p0v8i16(<8 x i16>, <8 x i16>*, <8 x i1>, i32)

define void @vpstore_v8i16(<8 x i16> %val, <8 x i16>* %ptr, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v8i16.p0v8i16(<8 x i16> %val, <8 x i16>* %ptr, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v2i32.p0v2i32(<2 x i32>, <2 x i32>*, <2 x i1>, i32)

define void @vpstore_v2i32(<2 x i32> %val, <2 x i32>* %ptr, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e32, mf2, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v2i32.p0v2i32(<2 x i32> %val, <2 x i32>* %ptr, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v4i32.p0v4i32(<4 x i32>, <4 x i32>*, <4 x i1>, i32)

define void @vpstore_v4i32(<4 x i32> %val, <4 x i32>* %ptr, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v4i32.p0v4i32(<4 x i32> %val, <4 x i32>* %ptr, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v8i32.p0v8i32(<8 x i32>, <8 x i32>*, <8 x i1>, i32)

define void @vpstore_v8i32(<8 x i32> %val, <8 x i32>* %ptr, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v8i32.p0v8i32(<8 x i32> %val, <8 x i32>* %ptr, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v2i64.p0v2i64(<2 x i64>, <2 x i64>*, <2 x i1>, i32)

define void @vpstore_v2i64(<2 x i64> %val, <2 x i64>* %ptr, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, mu
; CHECK-NEXT:    vse64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v2i64.p0v2i64(<2 x i64> %val, <2 x i64>* %ptr, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v4i64.p0v4i64(<4 x i64>, <4 x i64>*, <4 x i1>, i32)

define void @vpstore_v4i64(<4 x i64> %val, <4 x i64>* %ptr, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e64, m2, ta, mu
; CHECK-NEXT:    vse64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v4i64.p0v4i64(<4 x i64> %val, <4 x i64>* %ptr, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v8i64.p0v8i64(<8 x i64>, <8 x i64>*, <8 x i1>, i32)

define void @vpstore_v8i64(<8 x i64> %val, <8 x i64>* %ptr, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e64, m4, ta, mu
; CHECK-NEXT:    vse64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v8i64.p0v8i64(<8 x i64> %val, <8 x i64>* %ptr, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v2f16.p0v2f16(<2 x half>, <2 x half>*, <2 x i1>, i32)

define void @vpstore_v2f16(<2 x half> %val, <2 x half>* %ptr, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e16, mf4, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v2f16.p0v2f16(<2 x half> %val, <2 x half>* %ptr, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v4f16.p0v4f16(<4 x half>, <4 x half>*, <4 x i1>, i32)

define void @vpstore_v4f16(<4 x half> %val, <4 x half>* %ptr, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e16, mf2, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v4f16.p0v4f16(<4 x half> %val, <4 x half>* %ptr, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v8f16.p0v8f16(<8 x half>, <8 x half>*, <8 x i1>, i32)

define void @vpstore_v8f16(<8 x half> %val, <8 x half>* %ptr, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v8f16.p0v8f16(<8 x half> %val, <8 x half>* %ptr, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v2f32.p0v2f32(<2 x float>, <2 x float>*, <2 x i1>, i32)

define void @vpstore_v2f32(<2 x float> %val, <2 x float>* %ptr, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e32, mf2, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v2f32.p0v2f32(<2 x float> %val, <2 x float>* %ptr, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v4f32.p0v4f32(<4 x float>, <4 x float>*, <4 x i1>, i32)

define void @vpstore_v4f32(<4 x float> %val, <4 x float>* %ptr, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v4f32.p0v4f32(<4 x float> %val, <4 x float>* %ptr, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v6f32.p0v6f32(<6 x float>, <6 x float>*, <6 x i1>, i32)

define void @vpstore_v6f32(<6 x float> %val, <6 x float>* %ptr, <6 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v6f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v6f32.p0v6f32(<6 x float> %val, <6 x float>* %ptr, <6 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v8f32.p0v8f32(<8 x float>, <8 x float>*, <8 x i1>, i32)

define void @vpstore_v8f32(<8 x float> %val, <8 x float>* %ptr, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v8f32.p0v8f32(<8 x float> %val, <8 x float>* %ptr, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v2f64.p0v2f64(<2 x double>, <2 x double>*, <2 x i1>, i32)

define void @vpstore_v2f64(<2 x double> %val, <2 x double>* %ptr, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, mu
; CHECK-NEXT:    vse64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v2f64.p0v2f64(<2 x double> %val, <2 x double>* %ptr, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v4f64.p0v4f64(<4 x double>, <4 x double>*, <4 x i1>, i32)

define void @vpstore_v4f64(<4 x double> %val, <4 x double>* %ptr, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e64, m2, ta, mu
; CHECK-NEXT:    vse64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v4f64.p0v4f64(<4 x double> %val, <4 x double>* %ptr, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v8f64.p0v8f64(<8 x double>, <8 x double>*, <8 x i1>, i32)

define void @vpstore_v8f64(<8 x double> %val, <8 x double>* %ptr, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e64, m4, ta, mu
; CHECK-NEXT:    vse64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v8f64.p0v8f64(<8 x double> %val, <8 x double>* %ptr, <8 x i1> %m, i32 %evl)
  ret void
}

define void @vpstore_v2i8_allones_mask(<2 x i8> %val, <2 x i8>* %ptr, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v2i8_allones_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x i1> undef, i1 true, i32 0
  %b = shufflevector <2 x i1> %a, <2 x i1> poison, <2 x i32> zeroinitializer
  call void @llvm.vp.store.v2i8.p0v2i8(<2 x i8> %val, <2 x i8>* %ptr, <2 x i1> %b, i32 %evl)
  ret void
}

declare void @llvm.vp.store.v32f64.p0v32f64(<32 x double>, <32 x double>*, <32 x i1>, i32)

define void @vpstore_v32f64(<32 x double> %val, <32 x double>* %ptr, <32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpstore_v32f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 16
; CHECK-NEXT:    mv a3, a1
; CHECK-NEXT:    bltu a1, a2, .LBB23_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    li a3, 16
; CHECK-NEXT:  .LBB23_2:
; CHECK-NEXT:    li a2, 0
; CHECK-NEXT:    vsetvli zero, a3, e64, m8, ta, mu
; CHECK-NEXT:    addi a3, a1, -16
; CHECK-NEXT:    vse64.v v8, (a0), v0.t
; CHECK-NEXT:    bltu a1, a3, .LBB23_4
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    mv a2, a3
; CHECK-NEXT:  .LBB23_4:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vi v0, v0, 2
; CHECK-NEXT:    addi a0, a0, 128
; CHECK-NEXT:    vsetvli zero, a2, e64, m8, ta, mu
; CHECK-NEXT:    vse64.v v16, (a0), v0.t
; CHECK-NEXT:    ret
  call void @llvm.vp.store.v32f64.p0v32f64(<32 x double> %val, <32 x double>* %ptr, <32 x i1> %m, i32 %evl)
  ret void
}
