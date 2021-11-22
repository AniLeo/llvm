; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1-RV32
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1-RV64

define void @splat_ones_v1i1(<1 x i1>* %x) {
; CHECK-LABEL: splat_ones_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, mu
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  store <1 x i1> <i1 1>, <1 x i1>* %x
  ret void
}

define void @splat_zeros_v2i1(<2 x i1>* %x) {
; CHECK-LABEL: splat_zeros_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vmclr.m v0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  store <2 x i1> zeroinitializer, <2 x i1>* %x
  ret void
}

define void @splat_v1i1(<1 x i1>* %x, i1 %y) {
; CHECK-LABEL: splat_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, mu
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <1 x i1> undef, i1 %y, i32 0
  %b = shufflevector <1 x i1> %a, <1 x i1> undef, <1 x i32> zeroinitializer
  store <1 x i1> %b, <1 x i1>* %x
  ret void
}

define void @splat_v1i1_icmp(<1 x i1>* %x, i32 signext %y, i32 signext %z) {
; CHECK-LABEL: splat_v1i1_icmp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xor a1, a1, a2
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, mu
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %c = icmp eq i32 %y, %z
  %a = insertelement <1 x i1> undef, i1 %c, i32 0
  %b = shufflevector <1 x i1> %a, <1 x i1> undef, <1 x i32> zeroinitializer
  store <1 x i1> %b, <1 x i1>* %x
  ret void
}

define void @splat_ones_v4i1(<4 x i1>* %x) {
; CHECK-LABEL: splat_ones_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  store <4 x i1> <i1 1, i1 1, i1 1, i1 1>, <4 x i1>* %x
  ret void
}

define void @splat_v4i1(<4 x i1>* %x, i1 %y) {
; CHECK-LABEL: splat_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x i1> undef, i1 %y, i32 0
  %b = shufflevector <4 x i1> %a, <4 x i1> undef, <4 x i32> zeroinitializer
  store <4 x i1> %b, <4 x i1>* %x
  ret void
}

define void @splat_zeros_v8i1(<8 x i1>* %x) {
; CHECK-LABEL: splat_zeros_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmclr.m v8
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  store <8 x i1> zeroinitializer, <8 x i1>* %x
  ret void
}

define void @splat_v8i1(<8 x i1>* %x, i1 %y) {
; CHECK-LABEL: splat_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v8, v8, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x i1> undef, i1 %y, i32 0
  %b = shufflevector <8 x i1> %a, <8 x i1> undef, <8 x i32> zeroinitializer
  store <8 x i1> %b, <8 x i1>* %x
  ret void
}

define void @splat_ones_v16i1(<16 x i1>* %x) {
; CHECK-LABEL: splat_ones_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vmset.m v8
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  store <16 x i1> <i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1>, <16 x i1>* %x
  ret void
}

define void @splat_v16i1(<16 x i1>* %x, i1 %y) {
; CHECK-LABEL: splat_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v8, v8, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x i1> undef, i1 %y, i32 0
  %b = shufflevector <16 x i1> %a, <16 x i1> undef, <16 x i32> zeroinitializer
  store <16 x i1> %b, <16 x i1>* %x
  ret void
}

define void @splat_zeros_v32i1(<32 x i1>* %x) {
; LMULMAX2-LABEL: splat_zeros_v32i1:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    li a1, 32
; LMULMAX2-NEXT:    vsetvli zero, a1, e8, m2, ta, mu
; LMULMAX2-NEXT:    vmclr.m v8
; LMULMAX2-NEXT:    vsm.v v8, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_zeros_v32i1:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV32-NEXT:    vmclr.m v8
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV32-NEXT:    addi a0, a0, 2
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_zeros_v32i1:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV64-NEXT:    vmclr.m v8
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV64-NEXT:    addi a0, a0, 2
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV64-NEXT:    ret
  store <32 x i1> zeroinitializer, <32 x i1>* %x
  ret void
}

define void @splat_v32i1(<32 x i1>* %x, i1 %y) {
; LMULMAX2-LABEL: splat_v32i1:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    andi a1, a1, 1
; LMULMAX2-NEXT:    li a2, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vmv.v.x v8, a1
; LMULMAX2-NEXT:    vmsne.vi v10, v8, 0
; LMULMAX2-NEXT:    vsm.v v10, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_v32i1:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    andi a1, a1, 1
; LMULMAX1-RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV32-NEXT:    vmv.v.x v8, a1
; LMULMAX1-RV32-NEXT:    vmsne.vi v8, v8, 0
; LMULMAX1-RV32-NEXT:    addi a1, a0, 2
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_v32i1:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    andi a1, a1, 1
; LMULMAX1-RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV64-NEXT:    vmv.v.x v8, a1
; LMULMAX1-RV64-NEXT:    vmsne.vi v8, v8, 0
; LMULMAX1-RV64-NEXT:    addi a1, a0, 2
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV64-NEXT:    ret
  %a = insertelement <32 x i1> undef, i1 %y, i32 0
  %b = shufflevector <32 x i1> %a, <32 x i1> undef, <32 x i32> zeroinitializer
  store <32 x i1> %b, <32 x i1>* %x
  ret void
}

define void @splat_ones_v64i1(<64 x i1>* %x) {
; LMULMAX2-LABEL: splat_ones_v64i1:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a1, a0, 4
; LMULMAX2-NEXT:    li a2, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vmset.m v8
; LMULMAX2-NEXT:    vsm.v v8, (a1)
; LMULMAX2-NEXT:    vsm.v v8, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_ones_v64i1:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV32-NEXT:    vmset.m v8
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV32-NEXT:    addi a1, a0, 6
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV32-NEXT:    addi a1, a0, 4
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV32-NEXT:    addi a0, a0, 2
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_ones_v64i1:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV64-NEXT:    vmset.m v8
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV64-NEXT:    addi a1, a0, 6
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV64-NEXT:    addi a1, a0, 4
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV64-NEXT:    addi a0, a0, 2
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV64-NEXT:    ret
  store <64 x i1> <i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1>, <64 x i1>* %x
  ret void
}

define void @splat_v64i1(<64 x i1>* %x, i1 %y) {
; LMULMAX2-LABEL: splat_v64i1:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    andi a1, a1, 1
; LMULMAX2-NEXT:    li a2, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vmv.v.x v8, a1
; LMULMAX2-NEXT:    vmsne.vi v10, v8, 0
; LMULMAX2-NEXT:    addi a1, a0, 4
; LMULMAX2-NEXT:    vsm.v v10, (a1)
; LMULMAX2-NEXT:    vsm.v v10, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: splat_v64i1:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    andi a1, a1, 1
; LMULMAX1-RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV32-NEXT:    vmv.v.x v8, a1
; LMULMAX1-RV32-NEXT:    vmsne.vi v8, v8, 0
; LMULMAX1-RV32-NEXT:    addi a1, a0, 6
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV32-NEXT:    addi a1, a0, 4
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV32-NEXT:    addi a1, a0, 2
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV32-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: splat_v64i1:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    andi a1, a1, 1
; LMULMAX1-RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-RV64-NEXT:    vmv.v.x v8, a1
; LMULMAX1-RV64-NEXT:    vmsne.vi v8, v8, 0
; LMULMAX1-RV64-NEXT:    addi a1, a0, 6
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV64-NEXT:    addi a1, a0, 4
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV64-NEXT:    addi a1, a0, 2
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a1)
; LMULMAX1-RV64-NEXT:    vsm.v v8, (a0)
; LMULMAX1-RV64-NEXT:    ret
  %a = insertelement <64 x i1> undef, i1 %y, i32 0
  %b = shufflevector <64 x i1> %a, <64 x i1> undef, <64 x i32> zeroinitializer
  store <64 x i1> %b, <64 x i1>* %x
  ret void
}
