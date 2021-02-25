; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define void @splat_v16i8(<16 x i8>* %x, i8 %y) {
; CHECK-LABEL: splat_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 16, e8,m1,ta,mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    vse8.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x i8> undef, i8 %y, i32 0
  %b = shufflevector <16 x i8> %a, <16 x i8> undef, <16 x i32> zeroinitializer
  store <16 x i8> %b, <16 x i8>* %x
  ret void
}

define void @splat_v8i16(<8 x i16>* %x, i16 %y) {
; CHECK-LABEL: splat_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 8, e16,m1,ta,mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    vse16.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x i16> undef, i16 %y, i32 0
  %b = shufflevector <8 x i16> %a, <8 x i16> undef, <8 x i32> zeroinitializer
  store <8 x i16> %b, <8 x i16>* %x
  ret void
}

define void @splat_v4i32(<4 x i32>* %x, i32 %y) {
; CHECK-LABEL: splat_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 4, e32,m1,ta,mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x i32> undef, i32 %y, i32 0
  %b = shufflevector <4 x i32> %a, <4 x i32> undef, <4 x i32> zeroinitializer
  store <4 x i32> %b, <4 x i32>* %x
  ret void
}

; FIXME: Support i64 splats on riscv32
;define void @splat_v2i64(<2 x i64>* %x, i64 %y) {
;  %a = insertelement <2 x i64> undef, i64 %y, i32 0
;  %b = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> zeroinitializer
;  store <2 x i64> %b, <2 x i64>* %x
;  ret void
;}

define void @splat_v32i8(<32 x i8>* %x, i8 %y) {
; LMULMAX2-LABEL: splat_v32i8:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli a2, a2, e8,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.x v26, a1
; LMULMAX2-NEXT:    vse8.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_v32i8:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a2, 16, e8,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.x v25, a1
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse8.v v25, (a1)
; LMULMAX1-NEXT:    vse8.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <32 x i8> undef, i8 %y, i32 0
  %b = shufflevector <32 x i8> %a, <32 x i8> undef, <32 x i32> zeroinitializer
  store <32 x i8> %b, <32 x i8>* %x
  ret void
}

define void @splat_v16i16(<16 x i16>* %x, i16 %y) {
; LMULMAX2-LABEL: splat_v16i16:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a2, 16, e16,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.x v26, a1
; LMULMAX2-NEXT:    vse16.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_v16i16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a2, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.x v25, a1
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse16.v v25, (a1)
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <16 x i16> undef, i16 %y, i32 0
  %b = shufflevector <16 x i16> %a, <16 x i16> undef, <16 x i32> zeroinitializer
  store <16 x i16> %b, <16 x i16>* %x
  ret void
}

define void @splat_v8i32(<8 x i32>* %x, i32 %y) {
; LMULMAX2-LABEL: splat_v8i32:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a2, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.x v26, a1
; LMULMAX2-NEXT:    vse32.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_v8i32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a2, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.x v25, a1
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <8 x i32> undef, i32 %y, i32 0
  %b = shufflevector <8 x i32> %a, <8 x i32> undef, <8 x i32> zeroinitializer
  store <8 x i32> %b, <8 x i32>* %x
  ret void
}

; FIXME: Support i64 splats on riscv32
;define void @splat_v4i64(<4 x i64>* %x, i64 %y) {
;  %a = insertelement <4 x i64> undef, i64 %y, i32 0
;  %b = shufflevector <4 x i64> %a, <4 x i64> undef, <4 x i32> zeroinitializer
;  store <4 x i64> %b, <4 x i64>* %x
;  ret void
;}

define void @splat_zero_v16i8(<16 x i8>* %x) {
; CHECK-LABEL: splat_zero_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 16, e8,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse8.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x i8> undef, i8 0, i32 0
  %b = shufflevector <16 x i8> %a, <16 x i8> undef, <16 x i32> zeroinitializer
  store <16 x i8> %b, <16 x i8>* %x
  ret void
}

define void @splat_zero_v8i16(<8 x i16>* %x) {
; CHECK-LABEL: splat_zero_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse16.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x i16> undef, i16 0, i32 0
  %b = shufflevector <8 x i16> %a, <8 x i16> undef, <8 x i32> zeroinitializer
  store <8 x i16> %b, <8 x i16>* %x
  ret void
}

define void @splat_zero_v4i32(<4 x i32>* %x) {
; CHECK-LABEL: splat_zero_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x i32> undef, i32 0, i32 0
  %b = shufflevector <4 x i32> %a, <4 x i32> undef, <4 x i32> zeroinitializer
  store <4 x i32> %b, <4 x i32>* %x
  ret void
}

define void @splat_zero_v2i64(<2 x i64>* %x) {
; CHECK-LABEL: splat_zero_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x i64> undef, i64 0, i32 0
  %b = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> zeroinitializer
  store <2 x i64> %b, <2 x i64>* %x
  ret void
}

define void @splat_zero_v32i8(<32 x i8>* %x) {
; LMULMAX2-LABEL: splat_zero_v32i8:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a1, zero, 32
; LMULMAX2-NEXT:    vsetvli a1, a1, e8,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse8.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_zero_v32i8:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 16, e8,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse8.v v25, (a1)
; LMULMAX1-NEXT:    vse8.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <32 x i8> undef, i8 0, i32 0
  %b = shufflevector <32 x i8> %a, <32 x i8> undef, <32 x i32> zeroinitializer
  store <32 x i8> %b, <32 x i8>* %x
  ret void
}

define void @splat_zero_v16i16(<16 x i16>* %x) {
; LMULMAX2-LABEL: splat_zero_v16i16:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 16, e16,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse16.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_zero_v16i16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse16.v v25, (a1)
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <16 x i16> undef, i16 0, i32 0
  %b = shufflevector <16 x i16> %a, <16 x i16> undef, <16 x i32> zeroinitializer
  store <16 x i16> %b, <16 x i16>* %x
  ret void
}

define void @splat_zero_v8i32(<8 x i32>* %x) {
; LMULMAX2-LABEL: splat_zero_v8i32:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse32.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_zero_v8i32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <8 x i32> undef, i32 0, i32 0
  %b = shufflevector <8 x i32> %a, <8 x i32> undef, <8 x i32> zeroinitializer
  store <8 x i32> %b, <8 x i32>* %x
  ret void
}

define void @splat_zero_v4i64(<4 x i64>* %x) {
; LMULMAX2-LABEL: splat_zero_v4i64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse32.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_zero_v4i64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <4 x i64> undef, i64 0, i32 0
  %b = shufflevector <4 x i64> %a, <4 x i64> undef, <4 x i32> zeroinitializer
  store <4 x i64> %b, <4 x i64>* %x
  ret void
}

define void @splat_allones_v16i8(<16 x i8>* %x) {
; CHECK-LABEL: splat_allones_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 16, e8,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, -1
; CHECK-NEXT:    vse8.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x i8> undef, i8 -1, i32 0
  %b = shufflevector <16 x i8> %a, <16 x i8> undef, <16 x i32> zeroinitializer
  store <16 x i8> %b, <16 x i8>* %x
  ret void
}

define void @splat_allones_v8i16(<8 x i16>* %x) {
; CHECK-LABEL: splat_allones_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, -1
; CHECK-NEXT:    vse16.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x i16> undef, i16 -1, i32 0
  %b = shufflevector <8 x i16> %a, <8 x i16> undef, <8 x i32> zeroinitializer
  store <8 x i16> %b, <8 x i16>* %x
  ret void
}

define void @splat_allones_v4i32(<4 x i32>* %x) {
; CHECK-LABEL: splat_allones_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, -1
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x i32> undef, i32 -1, i32 0
  %b = shufflevector <4 x i32> %a, <4 x i32> undef, <4 x i32> zeroinitializer
  store <4 x i32> %b, <4 x i32>* %x
  ret void
}

define void @splat_allones_v2i64(<2 x i64>* %x) {
; CHECK-LABEL: splat_allones_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, -1
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x i64> undef, i64 -1, i32 0
  %b = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> zeroinitializer
  store <2 x i64> %b, <2 x i64>* %x
  ret void
}

define void @splat_allones_v32i8(<32 x i8>* %x) {
; LMULMAX2-LABEL: splat_allones_v32i8:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a1, zero, 32
; LMULMAX2-NEXT:    vsetvli a1, a1, e8,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, -1
; LMULMAX2-NEXT:    vse8.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_allones_v32i8:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 16, e8,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, -1
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse8.v v25, (a1)
; LMULMAX1-NEXT:    vse8.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <32 x i8> undef, i8 -1, i32 0
  %b = shufflevector <32 x i8> %a, <32 x i8> undef, <32 x i32> zeroinitializer
  store <32 x i8> %b, <32 x i8>* %x
  ret void
}

define void @splat_allones_v16i16(<16 x i16>* %x) {
; LMULMAX2-LABEL: splat_allones_v16i16:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 16, e16,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, -1
; LMULMAX2-NEXT:    vse16.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_allones_v16i16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, -1
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse16.v v25, (a1)
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <16 x i16> undef, i16 -1, i32 0
  %b = shufflevector <16 x i16> %a, <16 x i16> undef, <16 x i32> zeroinitializer
  store <16 x i16> %b, <16 x i16>* %x
  ret void
}

define void @splat_allones_v8i32(<8 x i32>* %x) {
; LMULMAX2-LABEL: splat_allones_v8i32:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, -1
; LMULMAX2-NEXT:    vse32.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_allones_v8i32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, -1
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <8 x i32> undef, i32 -1, i32 0
  %b = shufflevector <8 x i32> %a, <8 x i32> undef, <8 x i32> zeroinitializer
  store <8 x i32> %b, <8 x i32>* %x
  ret void
}

define void @splat_allones_v4i64(<4 x i64>* %x) {
; LMULMAX2-LABEL: splat_allones_v4i64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, -1
; LMULMAX2-NEXT:    vse32.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_allones_v4i64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, -1
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <4 x i64> undef, i64 -1, i32 0
  %b = shufflevector <4 x i64> %a, <4 x i64> undef, <4 x i32> zeroinitializer
  store <4 x i64> %b, <4 x i64>* %x
  ret void
}

; This requires a bitcast on RV32 due to type legalization rewriting the
; build_vector to v8i32.
; FIXME: We should prevent this and use the implicit sign extension of vmv.v.x
; with SEW=64 on RV32.
define void @splat_allones_with_use_v4i64(<4 x i64>* %x) {
; LMULMAX2-LABEL: splat_allones_with_use_v4i64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-NEXT:    vle64.v v26, (a0)
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v28, -1
; LMULMAX2-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-NEXT:    vadd.vv v26, v26, v28
; LMULMAX2-NEXT:    vse64.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_allones_with_use_v4i64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-NEXT:    vle64.v v25, (a0)
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vle64.v v26, (a1)
; LMULMAX1-NEXT:    vsetivli a2, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v27, -1
; LMULMAX1-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX1-NEXT:    vadd.vv v26, v26, v27
; LMULMAX1-NEXT:    vadd.vv v25, v25, v27
; LMULMAX1-NEXT:    vse64.v v25, (a0)
; LMULMAX1-NEXT:    vse64.v v26, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %x
  %b = add <4 x i64> %a, <i64 -1, i64 -1, i64 -1, i64 -1>
  store <4 x i64> %b, <4 x i64>* %x
  ret void
}
