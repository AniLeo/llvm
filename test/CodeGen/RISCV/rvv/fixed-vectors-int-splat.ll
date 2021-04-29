; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8,LMULMAX8-RV32
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2,LMULMAX2-RV32
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1,LMULMAX1-RV32
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8,LMULMAX8-RV64
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2,LMULMAX2-RV64
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1,LMULMAX1-RV64

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

define void @splat_v2i64(<2 x i64>* %x, i64 %y) {
; LMULMAX8-RV32-LABEL: splat_v2i64:
; LMULMAX8-RV32:       # %bb.0:
; LMULMAX8-RV32-NEXT:    addi sp, sp, -16
; LMULMAX8-RV32-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX8-RV32-NEXT:    sw a2, 12(sp)
; LMULMAX8-RV32-NEXT:    sw a1, 8(sp)
; LMULMAX8-RV32-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX8-RV32-NEXT:    addi a1, sp, 8
; LMULMAX8-RV32-NEXT:    vlse64.v v25, (a1), zero
; LMULMAX8-RV32-NEXT:    vse64.v v25, (a0)
; LMULMAX8-RV32-NEXT:    addi sp, sp, 16
; LMULMAX8-RV32-NEXT:    ret
;
; LMULMAX2-RV32-LABEL: splat_v2i64:
; LMULMAX2-RV32:       # %bb.0:
; LMULMAX2-RV32-NEXT:    addi sp, sp, -16
; LMULMAX2-RV32-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX2-RV32-NEXT:    sw a2, 12(sp)
; LMULMAX2-RV32-NEXT:    sw a1, 8(sp)
; LMULMAX2-RV32-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX2-RV32-NEXT:    addi a1, sp, 8
; LMULMAX2-RV32-NEXT:    vlse64.v v25, (a1), zero
; LMULMAX2-RV32-NEXT:    vse64.v v25, (a0)
; LMULMAX2-RV32-NEXT:    addi sp, sp, 16
; LMULMAX2-RV32-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_v2i64:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    addi sp, sp, -16
; LMULMAX1-RV32-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX1-RV32-NEXT:    sw a2, 12(sp)
; LMULMAX1-RV32-NEXT:    sw a1, 8(sp)
; LMULMAX1-RV32-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-RV32-NEXT:    addi a1, sp, 8
; LMULMAX1-RV32-NEXT:    vlse64.v v25, (a1), zero
; LMULMAX1-RV32-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV32-NEXT:    addi sp, sp, 16
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX8-RV64-LABEL: splat_v2i64:
; LMULMAX8-RV64:       # %bb.0:
; LMULMAX8-RV64-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX8-RV64-NEXT:    vmv.v.x v25, a1
; LMULMAX8-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX8-RV64-NEXT:    ret
;
; LMULMAX2-RV64-LABEL: splat_v2i64:
; LMULMAX2-RV64:       # %bb.0:
; LMULMAX2-RV64-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX2-RV64-NEXT:    vmv.v.x v25, a1
; LMULMAX2-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX2-RV64-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_v2i64:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX1-RV64-NEXT:    vmv.v.x v25, a1
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV64-NEXT:    ret
  %a = insertelement <2 x i64> undef, i64 %y, i32 0
  %b = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> zeroinitializer
  store <2 x i64> %b, <2 x i64>* %x
  ret void
}

define void @splat_v32i8(<32 x i8>* %x, i8 %y) {
; LMULMAX8-LABEL: splat_v32i8:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    addi a2, zero, 32
; LMULMAX8-NEXT:    vsetvli a2, a2, e8,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.x v26, a1
; LMULMAX8-NEXT:    vse8.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX8-LABEL: splat_v16i16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a2, 16, e16,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.x v26, a1
; LMULMAX8-NEXT:    vse16.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX8-LABEL: splat_v8i32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a2, 8, e32,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.x v26, a1
; LMULMAX8-NEXT:    vse32.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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

define void @splat_v4i64(<4 x i64>* %x, i64 %y) {
; LMULMAX8-RV32-LABEL: splat_v4i64:
; LMULMAX8-RV32:       # %bb.0:
; LMULMAX8-RV32-NEXT:    addi sp, sp, -16
; LMULMAX8-RV32-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX8-RV32-NEXT:    sw a2, 12(sp)
; LMULMAX8-RV32-NEXT:    sw a1, 8(sp)
; LMULMAX8-RV32-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX8-RV32-NEXT:    addi a1, sp, 8
; LMULMAX8-RV32-NEXT:    vlse64.v v26, (a1), zero
; LMULMAX8-RV32-NEXT:    vse64.v v26, (a0)
; LMULMAX8-RV32-NEXT:    addi sp, sp, 16
; LMULMAX8-RV32-NEXT:    ret
;
; LMULMAX2-RV32-LABEL: splat_v4i64:
; LMULMAX2-RV32:       # %bb.0:
; LMULMAX2-RV32-NEXT:    addi sp, sp, -16
; LMULMAX2-RV32-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX2-RV32-NEXT:    sw a2, 12(sp)
; LMULMAX2-RV32-NEXT:    sw a1, 8(sp)
; LMULMAX2-RV32-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-RV32-NEXT:    addi a1, sp, 8
; LMULMAX2-RV32-NEXT:    vlse64.v v26, (a1), zero
; LMULMAX2-RV32-NEXT:    vse64.v v26, (a0)
; LMULMAX2-RV32-NEXT:    addi sp, sp, 16
; LMULMAX2-RV32-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_v4i64:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    addi a3, zero, 5
; LMULMAX1-RV32-NEXT:    vsetivli a4, 1, e8,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vmv.s.x v0, a3
; LMULMAX1-RV32-NEXT:    vsetivli a3, 4, e32,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vmv.v.x v25, a2
; LMULMAX1-RV32-NEXT:    vmerge.vxm v25, v25, a1, v0
; LMULMAX1-RV32-NEXT:    addi a1, a0, 16
; LMULMAX1-RV32-NEXT:    vse32.v v25, (a1)
; LMULMAX1-RV32-NEXT:    vse32.v v25, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX8-RV64-LABEL: splat_v4i64:
; LMULMAX8-RV64:       # %bb.0:
; LMULMAX8-RV64-NEXT:    vsetivli a2, 4, e64,m2,ta,mu
; LMULMAX8-RV64-NEXT:    vmv.v.x v26, a1
; LMULMAX8-RV64-NEXT:    vse64.v v26, (a0)
; LMULMAX8-RV64-NEXT:    ret
;
; LMULMAX2-RV64-LABEL: splat_v4i64:
; LMULMAX2-RV64:       # %bb.0:
; LMULMAX2-RV64-NEXT:    vsetivli a2, 4, e64,m2,ta,mu
; LMULMAX2-RV64-NEXT:    vmv.v.x v26, a1
; LMULMAX2-RV64-NEXT:    vse64.v v26, (a0)
; LMULMAX2-RV64-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_v4i64:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX1-RV64-NEXT:    vmv.v.x v25, a1
; LMULMAX1-RV64-NEXT:    addi a1, a0, 16
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a1)
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV64-NEXT:    ret
  %a = insertelement <4 x i64> undef, i64 %y, i32 0
  %b = shufflevector <4 x i64> %a, <4 x i64> undef, <4 x i32> zeroinitializer
  store <4 x i64> %b, <4 x i64>* %x
  ret void
}

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
; CHECK-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse64.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x i64> undef, i64 0, i32 0
  %b = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> zeroinitializer
  store <2 x i64> %b, <2 x i64>* %x
  ret void
}

define void @splat_zero_v32i8(<32 x i8>* %x) {
; LMULMAX8-LABEL: splat_zero_v32i8:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    addi a1, zero, 32
; LMULMAX8-NEXT:    vsetvli a1, a1, e8,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, 0
; LMULMAX8-NEXT:    vse8.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX1-NEXT:    vse8.v v25, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse8.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <32 x i8> undef, i8 0, i32 0
  %b = shufflevector <32 x i8> %a, <32 x i8> undef, <32 x i32> zeroinitializer
  store <32 x i8> %b, <32 x i8>* %x
  ret void
}

define void @splat_zero_v16i16(<16 x i16>* %x) {
; LMULMAX8-LABEL: splat_zero_v16i16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a1, 16, e16,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, 0
; LMULMAX8-NEXT:    vse16.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <16 x i16> undef, i16 0, i32 0
  %b = shufflevector <16 x i16> %a, <16 x i16> undef, <16 x i32> zeroinitializer
  store <16 x i16> %b, <16 x i16>* %x
  ret void
}

define void @splat_zero_v8i32(<8 x i32>* %x) {
; LMULMAX8-LABEL: splat_zero_v8i32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, 0
; LMULMAX8-NEXT:    vse32.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <8 x i32> undef, i32 0, i32 0
  %b = shufflevector <8 x i32> %a, <8 x i32> undef, <8 x i32> zeroinitializer
  store <8 x i32> %b, <8 x i32>* %x
  ret void
}

define void @splat_zero_v4i64(<4 x i64>* %x) {
; LMULMAX8-LABEL: splat_zero_v4i64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, 0
; LMULMAX8-NEXT:    vse64.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
; LMULMAX2-LABEL: splat_zero_v4i64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse64.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_zero_v4i64:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vmv.v.i v25, 0
; LMULMAX1-RV32-NEXT:    vse32.v v25, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a0, 16
; LMULMAX1-RV32-NEXT:    vse32.v v25, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_zero_v4i64:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-RV64-NEXT:    vmv.v.i v25, 0
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a0, 16
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV64-NEXT:    ret
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
; CHECK-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, -1
; CHECK-NEXT:    vse64.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x i64> undef, i64 -1, i32 0
  %b = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> zeroinitializer
  store <2 x i64> %b, <2 x i64>* %x
  ret void
}

define void @splat_allones_v32i8(<32 x i8>* %x) {
; LMULMAX8-LABEL: splat_allones_v32i8:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    addi a1, zero, 32
; LMULMAX8-NEXT:    vsetvli a1, a1, e8,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, -1
; LMULMAX8-NEXT:    vse8.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX1-NEXT:    vse8.v v25, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse8.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <32 x i8> undef, i8 -1, i32 0
  %b = shufflevector <32 x i8> %a, <32 x i8> undef, <32 x i32> zeroinitializer
  store <32 x i8> %b, <32 x i8>* %x
  ret void
}

define void @splat_allones_v16i16(<16 x i16>* %x) {
; LMULMAX8-LABEL: splat_allones_v16i16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a1, 16, e16,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, -1
; LMULMAX8-NEXT:    vse16.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <16 x i16> undef, i16 -1, i32 0
  %b = shufflevector <16 x i16> %a, <16 x i16> undef, <16 x i32> zeroinitializer
  store <16 x i16> %b, <16 x i16>* %x
  ret void
}

define void @splat_allones_v8i32(<8 x i32>* %x) {
; LMULMAX8-LABEL: splat_allones_v8i32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, -1
; LMULMAX8-NEXT:    vse32.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
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
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <8 x i32> undef, i32 -1, i32 0
  %b = shufflevector <8 x i32> %a, <8 x i32> undef, <8 x i32> zeroinitializer
  store <8 x i32> %b, <8 x i32>* %x
  ret void
}

define void @splat_allones_v4i64(<4 x i64>* %x) {
; LMULMAX8-LABEL: splat_allones_v4i64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX8-NEXT:    vmv.v.i v26, -1
; LMULMAX8-NEXT:    vse64.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
; LMULMAX2-LABEL: splat_allones_v4i64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, -1
; LMULMAX2-NEXT:    vse64.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_allones_v4i64:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vmv.v.i v25, -1
; LMULMAX1-RV32-NEXT:    vse32.v v25, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a0, 16
; LMULMAX1-RV32-NEXT:    vse32.v v25, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_allones_v4i64:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-RV64-NEXT:    vmv.v.i v25, -1
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a0, 16
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV64-NEXT:    ret
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
; LMULMAX8-LABEL: splat_allones_with_use_v4i64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX8-NEXT:    vle64.v v26, (a0)
; LMULMAX8-NEXT:    vadd.vi v26, v26, -1
; LMULMAX8-NEXT:    vse64.v v26, (a0)
; LMULMAX8-NEXT:    ret
;
; LMULMAX2-LABEL: splat_allones_with_use_v4i64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-NEXT:    vle64.v v26, (a0)
; LMULMAX2-NEXT:    vadd.vi v26, v26, -1
; LMULMAX2-NEXT:    vse64.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_allones_with_use_v4i64:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vle64.v v25, (a0)
; LMULMAX1-RV32-NEXT:    addi a1, a0, 16
; LMULMAX1-RV32-NEXT:    vle64.v v26, (a1)
; LMULMAX1-RV32-NEXT:    vsetivli a2, 4, e32,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vmv.v.i v27, -1
; LMULMAX1-RV32-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vadd.vv v26, v26, v27
; LMULMAX1-RV32-NEXT:    vadd.vv v25, v25, v27
; LMULMAX1-RV32-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV32-NEXT:    vse64.v v26, (a1)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_allones_with_use_v4i64:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-RV64-NEXT:    addi a1, a0, 16
; LMULMAX1-RV64-NEXT:    vle64.v v25, (a1)
; LMULMAX1-RV64-NEXT:    vle64.v v26, (a0)
; LMULMAX1-RV64-NEXT:    vadd.vi v25, v25, -1
; LMULMAX1-RV64-NEXT:    vadd.vi v26, v26, -1
; LMULMAX1-RV64-NEXT:    vse64.v v26, (a0)
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a1)
; LMULMAX1-RV64-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %x
  %b = add <4 x i64> %a, <i64 -1, i64 -1, i64 -1, i64 -1>
  store <4 x i64> %b, <4 x i64>* %x
  ret void
}

; This test used to crash at LMUL=8 when inserting a v16i64 subvector into
; nxv8i64 at index 0: the v16i64 type was used to get the LMUL, the size of
; which exceeded maximum-expected size of 512. The scalable container type of
; nxv8i64 should have been used instead.
define void @vadd_vx_v16i64(<16 x i64>* %a, i64 %b, <16 x i64>* %c) {
; LMULMAX8-RV32-LABEL: vadd_vx_v16i64:
; LMULMAX8-RV32:       # %bb.0:
; LMULMAX8-RV32-NEXT:    addi sp, sp, -16
; LMULMAX8-RV32-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX8-RV32-NEXT:    vsetivli a4, 16, e64,m8,ta,mu
; LMULMAX8-RV32-NEXT:    vle64.v v8, (a0)
; LMULMAX8-RV32-NEXT:    sw a2, 12(sp)
; LMULMAX8-RV32-NEXT:    sw a1, 8(sp)
; LMULMAX8-RV32-NEXT:    addi a0, sp, 8
; LMULMAX8-RV32-NEXT:    vlse64.v v16, (a0), zero
; LMULMAX8-RV32-NEXT:    vadd.vv v8, v8, v16
; LMULMAX8-RV32-NEXT:    vse64.v v8, (a3)
; LMULMAX8-RV32-NEXT:    addi sp, sp, 16
; LMULMAX8-RV32-NEXT:    ret
;
; LMULMAX2-RV32-LABEL: vadd_vx_v16i64:
; LMULMAX2-RV32:       # %bb.0:
; LMULMAX2-RV32-NEXT:    addi a4, a0, 64
; LMULMAX2-RV32-NEXT:    vsetivli a5, 4, e64,m2,ta,mu
; LMULMAX2-RV32-NEXT:    vle64.v v26, (a4)
; LMULMAX2-RV32-NEXT:    addi a4, a0, 96
; LMULMAX2-RV32-NEXT:    vle64.v v28, (a4)
; LMULMAX2-RV32-NEXT:    vle64.v v30, (a0)
; LMULMAX2-RV32-NEXT:    addi a0, a0, 32
; LMULMAX2-RV32-NEXT:    vle64.v v8, (a0)
; LMULMAX2-RV32-NEXT:    addi a0, zero, 85
; LMULMAX2-RV32-NEXT:    vsetivli a4, 1, e8,m1,ta,mu
; LMULMAX2-RV32-NEXT:    vmv.s.x v0, a0
; LMULMAX2-RV32-NEXT:    vsetivli a0, 8, e32,m2,ta,mu
; LMULMAX2-RV32-NEXT:    vmv.v.x v10, a2
; LMULMAX2-RV32-NEXT:    vmerge.vxm v10, v10, a1, v0
; LMULMAX2-RV32-NEXT:    vsetivli a0, 4, e64,m2,ta,mu
; LMULMAX2-RV32-NEXT:    vadd.vv v8, v8, v10
; LMULMAX2-RV32-NEXT:    vadd.vv v30, v30, v10
; LMULMAX2-RV32-NEXT:    vadd.vv v28, v28, v10
; LMULMAX2-RV32-NEXT:    vadd.vv v26, v26, v10
; LMULMAX2-RV32-NEXT:    addi a0, a3, 64
; LMULMAX2-RV32-NEXT:    vse64.v v26, (a0)
; LMULMAX2-RV32-NEXT:    addi a0, a3, 96
; LMULMAX2-RV32-NEXT:    vse64.v v28, (a0)
; LMULMAX2-RV32-NEXT:    vse64.v v30, (a3)
; LMULMAX2-RV32-NEXT:    addi a0, a3, 32
; LMULMAX2-RV32-NEXT:    vse64.v v8, (a0)
; LMULMAX2-RV32-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: vadd_vx_v16i64:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    addi a4, a0, 96
; LMULMAX1-RV32-NEXT:    vsetivli a5, 2, e64,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vle64.v v25, (a4)
; LMULMAX1-RV32-NEXT:    addi a4, a0, 112
; LMULMAX1-RV32-NEXT:    vle64.v v26, (a4)
; LMULMAX1-RV32-NEXT:    addi a4, a0, 64
; LMULMAX1-RV32-NEXT:    vle64.v v27, (a4)
; LMULMAX1-RV32-NEXT:    addi a4, a0, 80
; LMULMAX1-RV32-NEXT:    vle64.v v28, (a4)
; LMULMAX1-RV32-NEXT:    addi a4, a0, 32
; LMULMAX1-RV32-NEXT:    vle64.v v29, (a4)
; LMULMAX1-RV32-NEXT:    addi a4, a0, 48
; LMULMAX1-RV32-NEXT:    vle64.v v30, (a4)
; LMULMAX1-RV32-NEXT:    vle64.v v31, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a0, 16
; LMULMAX1-RV32-NEXT:    vle64.v v8, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, zero, 5
; LMULMAX1-RV32-NEXT:    vsetivli a4, 1, e8,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vmv.s.x v0, a0
; LMULMAX1-RV32-NEXT:    vsetivli a0, 4, e32,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vmv.v.x v9, a2
; LMULMAX1-RV32-NEXT:    vmerge.vxm v9, v9, a1, v0
; LMULMAX1-RV32-NEXT:    vsetivli a0, 2, e64,m1,ta,mu
; LMULMAX1-RV32-NEXT:    vadd.vv v8, v8, v9
; LMULMAX1-RV32-NEXT:    vadd.vv v31, v31, v9
; LMULMAX1-RV32-NEXT:    vadd.vv v30, v30, v9
; LMULMAX1-RV32-NEXT:    vadd.vv v29, v29, v9
; LMULMAX1-RV32-NEXT:    vadd.vv v28, v28, v9
; LMULMAX1-RV32-NEXT:    vadd.vv v27, v27, v9
; LMULMAX1-RV32-NEXT:    vadd.vv v26, v26, v9
; LMULMAX1-RV32-NEXT:    vadd.vv v25, v25, v9
; LMULMAX1-RV32-NEXT:    addi a0, a3, 96
; LMULMAX1-RV32-NEXT:    vse64.v v25, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a3, 112
; LMULMAX1-RV32-NEXT:    vse64.v v26, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a3, 64
; LMULMAX1-RV32-NEXT:    vse64.v v27, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a3, 80
; LMULMAX1-RV32-NEXT:    vse64.v v28, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a3, 32
; LMULMAX1-RV32-NEXT:    vse64.v v29, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a3, 48
; LMULMAX1-RV32-NEXT:    vse64.v v30, (a0)
; LMULMAX1-RV32-NEXT:    vse64.v v31, (a3)
; LMULMAX1-RV32-NEXT:    addi a0, a3, 16
; LMULMAX1-RV32-NEXT:    vse64.v v8, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX8-RV64-LABEL: vadd_vx_v16i64:
; LMULMAX8-RV64:       # %bb.0:
; LMULMAX8-RV64-NEXT:    vsetivli a3, 16, e64,m8,ta,mu
; LMULMAX8-RV64-NEXT:    vle64.v v8, (a0)
; LMULMAX8-RV64-NEXT:    vadd.vx v8, v8, a1
; LMULMAX8-RV64-NEXT:    vse64.v v8, (a2)
; LMULMAX8-RV64-NEXT:    ret
;
; LMULMAX2-RV64-LABEL: vadd_vx_v16i64:
; LMULMAX2-RV64:       # %bb.0:
; LMULMAX2-RV64-NEXT:    vsetivli a3, 4, e64,m2,ta,mu
; LMULMAX2-RV64-NEXT:    addi a3, a0, 96
; LMULMAX2-RV64-NEXT:    vle64.v v26, (a3)
; LMULMAX2-RV64-NEXT:    addi a3, a0, 32
; LMULMAX2-RV64-NEXT:    vle64.v v28, (a3)
; LMULMAX2-RV64-NEXT:    addi a3, a0, 64
; LMULMAX2-RV64-NEXT:    vle64.v v30, (a3)
; LMULMAX2-RV64-NEXT:    vle64.v v8, (a0)
; LMULMAX2-RV64-NEXT:    vadd.vx v28, v28, a1
; LMULMAX2-RV64-NEXT:    vadd.vx v26, v26, a1
; LMULMAX2-RV64-NEXT:    vadd.vx v30, v30, a1
; LMULMAX2-RV64-NEXT:    vadd.vx v8, v8, a1
; LMULMAX2-RV64-NEXT:    vse64.v v8, (a2)
; LMULMAX2-RV64-NEXT:    addi a0, a2, 64
; LMULMAX2-RV64-NEXT:    vse64.v v30, (a0)
; LMULMAX2-RV64-NEXT:    addi a0, a2, 96
; LMULMAX2-RV64-NEXT:    vse64.v v26, (a0)
; LMULMAX2-RV64-NEXT:    addi a0, a2, 32
; LMULMAX2-RV64-NEXT:    vse64.v v28, (a0)
; LMULMAX2-RV64-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: vadd_vx_v16i64:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli a3, 2, e64,m1,ta,mu
; LMULMAX1-RV64-NEXT:    vle64.v v25, (a0)
; LMULMAX1-RV64-NEXT:    addi a3, a0, 96
; LMULMAX1-RV64-NEXT:    vle64.v v26, (a3)
; LMULMAX1-RV64-NEXT:    addi a3, a0, 112
; LMULMAX1-RV64-NEXT:    vle64.v v27, (a3)
; LMULMAX1-RV64-NEXT:    addi a3, a0, 64
; LMULMAX1-RV64-NEXT:    vle64.v v28, (a3)
; LMULMAX1-RV64-NEXT:    addi a3, a0, 48
; LMULMAX1-RV64-NEXT:    vle64.v v29, (a3)
; LMULMAX1-RV64-NEXT:    addi a3, a0, 16
; LMULMAX1-RV64-NEXT:    vle64.v v30, (a3)
; LMULMAX1-RV64-NEXT:    addi a3, a0, 80
; LMULMAX1-RV64-NEXT:    addi a0, a0, 32
; LMULMAX1-RV64-NEXT:    vle64.v v31, (a0)
; LMULMAX1-RV64-NEXT:    vle64.v v8, (a3)
; LMULMAX1-RV64-NEXT:    vadd.vx v30, v30, a1
; LMULMAX1-RV64-NEXT:    vadd.vx v29, v29, a1
; LMULMAX1-RV64-NEXT:    vadd.vx v31, v31, a1
; LMULMAX1-RV64-NEXT:    vadd.vx v8, v8, a1
; LMULMAX1-RV64-NEXT:    vadd.vx v28, v28, a1
; LMULMAX1-RV64-NEXT:    vadd.vx v27, v27, a1
; LMULMAX1-RV64-NEXT:    vadd.vx v26, v26, a1
; LMULMAX1-RV64-NEXT:    vadd.vx v25, v25, a1
; LMULMAX1-RV64-NEXT:    vse64.v v25, (a2)
; LMULMAX1-RV64-NEXT:    addi a0, a2, 96
; LMULMAX1-RV64-NEXT:    vse64.v v26, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a2, 112
; LMULMAX1-RV64-NEXT:    vse64.v v27, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a2, 64
; LMULMAX1-RV64-NEXT:    vse64.v v28, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a2, 80
; LMULMAX1-RV64-NEXT:    vse64.v v8, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a2, 32
; LMULMAX1-RV64-NEXT:    vse64.v v31, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a2, 48
; LMULMAX1-RV64-NEXT:    vse64.v v29, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a2, 16
; LMULMAX1-RV64-NEXT:    vse64.v v30, (a0)
; LMULMAX1-RV64-NEXT:    ret
  %va = load <16 x i64>, <16 x i64>* %a
  %head = insertelement <16 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <16 x i64> %head, <16 x i64> undef, <16 x i32> zeroinitializer
  %vc = add <16 x i64> %va, %splat
  store <16 x i64> %vc, <16 x i64>* %c
  ret void
}
