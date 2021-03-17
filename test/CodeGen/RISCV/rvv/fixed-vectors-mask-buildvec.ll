; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV32,RV32-LMULMAX1
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV64,RV64-LMULMAX1
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV32,RV32-LMULMAX2
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV64,RV64-LMULMAX2
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=4 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV32,RV32-LMULMAX4
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=4 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV64,RV64-LMULMAX4
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV32,RV32-LMULMAX8
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV64,RV64-LMULMAX8

define <3 x i1> @buildvec_mask_v1i1() {
; CHECK-LABEL: buildvec_mask_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 2
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    ret
  ret <3 x i1> <i1 0, i1 1, i1 0>
}

define <3 x i1> @buildvec_mask_optsize_v1i1() optsize {
; CHECK-LABEL: buildvec_mask_optsize_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 2
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    ret
  ret <3 x i1> <i1 0, i1 1, i1 0>
}

define <4 x i1> @buildvec_mask_v4i1() {
; CHECK-LABEL: buildvec_mask_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 6
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    ret
  ret <4 x i1> <i1 0, i1 1, i1 1, i1 0>
}

define <8 x i1> @buildvec_mask_v8i1() {
; CHECK-LABEL: buildvec_mask_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 182
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    ret
  ret <8 x i1> <i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1>
}

define <10 x i1> @buildvec_mask_v10i1() {
; CHECK-LABEL: buildvec_mask_v10i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 949
; CHECK-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    ret
  ret <10 x i1> <i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 1>
}

define <16 x i1> @buildvec_mask_v16i1() {
; CHECK-RV32-LABEL: buildvec_mask_v16i1:
; CHECK-RV32:       # %bb.0:
; CHECK-RV32-NEXT:    lui a0, 11
; CHECK-RV32-NEXT:    addi a0, a0, 1718
; CHECK-RV32-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; CHECK-RV32-NEXT:    vmv.s.x v0, a0
; CHECK-RV32-NEXT:    ret
;
; CHECK-RV64-LABEL: buildvec_mask_v16i1:
; CHECK-RV64:       # %bb.0:
; CHECK-RV64-NEXT:    lui a0, 11
; CHECK-RV64-NEXT:    addiw a0, a0, 1718
; CHECK-RV64-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; CHECK-RV64-NEXT:    vmv.s.x v0, a0
; CHECK-RV64-NEXT:    ret
  ret <16 x i1> <i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1>
}

define <16 x i1> @buildvec_mask_v16i1_undefs() {
; CHECK-LABEL: buildvec_mask_v16i1_undefs:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 1722
; CHECK-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    ret
  ret <16 x i1> <i1 undef, i1 1, i1 undef, i1 1, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef>
}

define <32 x i1> @buildvec_mask_v32i1() {
; RV32-LMULMAX1-LABEL: buildvec_mask_v32i1:
; RV32-LMULMAX1:       # %bb.0:
; RV32-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV32-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV32-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX1-NEXT:    lui a0, 11
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1718
; RV32-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX1-NEXT:    ret
;
; RV64-LMULMAX1-LABEL: buildvec_mask_v32i1:
; RV64-LMULMAX1:       # %bb.0:
; RV64-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV64-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV64-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX1-NEXT:    lui a0, 11
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1718
; RV64-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX1-NEXT:    ret
;
; RV32-LMULMAX2-LABEL: buildvec_mask_v32i1:
; RV32-LMULMAX2:       # %bb.0:
; RV32-LMULMAX2-NEXT:    lui a0, 748384
; RV32-LMULMAX2-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV32-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX2-NEXT:    ret
;
; RV64-LMULMAX2-LABEL: buildvec_mask_v32i1:
; RV64-LMULMAX2:       # %bb.0:
; RV64-LMULMAX2-NEXT:    lui a0, 748384
; RV64-LMULMAX2-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV64-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX2-NEXT:    ret
;
; RV32-LMULMAX4-LABEL: buildvec_mask_v32i1:
; RV32-LMULMAX4:       # %bb.0:
; RV32-LMULMAX4-NEXT:    lui a0, 748384
; RV32-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX4-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV32-LMULMAX4-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX4-NEXT:    ret
;
; RV64-LMULMAX4-LABEL: buildvec_mask_v32i1:
; RV64-LMULMAX4:       # %bb.0:
; RV64-LMULMAX4-NEXT:    lui a0, 748384
; RV64-LMULMAX4-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX4-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV64-LMULMAX4-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX4-NEXT:    ret
;
; RV32-LMULMAX8-LABEL: buildvec_mask_v32i1:
; RV32-LMULMAX8:       # %bb.0:
; RV32-LMULMAX8-NEXT:    lui a0, 748384
; RV32-LMULMAX8-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX8-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV32-LMULMAX8-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX8-NEXT:    ret
;
; RV64-LMULMAX8-LABEL: buildvec_mask_v32i1:
; RV64-LMULMAX8:       # %bb.0:
; RV64-LMULMAX8-NEXT:    lui a0, 748384
; RV64-LMULMAX8-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX8-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV64-LMULMAX8-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX8-NEXT:    ret
  ret <32 x i1> <i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1>
}

define <64 x i1> @buildvec_mask_v64i1() {
; RV32-LMULMAX1-LABEL: buildvec_mask_v64i1:
; RV32-LMULMAX1:       # %bb.0:
; RV32-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV32-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV32-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX1-NEXT:    lui a0, 4
; RV32-LMULMAX1-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX1-NEXT:    vmv.s.x v9, a0
; RV32-LMULMAX1-NEXT:    lui a0, 11
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1718
; RV32-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX1-NEXT:    vmv1r.v v10, v8
; RV32-LMULMAX1-NEXT:    ret
;
; RV64-LMULMAX1-LABEL: buildvec_mask_v64i1:
; RV64-LMULMAX1:       # %bb.0:
; RV64-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV64-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV64-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX1-NEXT:    lui a0, 4
; RV64-LMULMAX1-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX1-NEXT:    vmv.s.x v9, a0
; RV64-LMULMAX1-NEXT:    lui a0, 11
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1718
; RV64-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX1-NEXT:    vmv1r.v v10, v8
; RV64-LMULMAX1-NEXT:    ret
;
; RV32-LMULMAX2-LABEL: buildvec_mask_v64i1:
; RV32-LMULMAX2:       # %bb.0:
; RV32-LMULMAX2-NEXT:    lui a0, 748384
; RV32-LMULMAX2-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV32-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX2-NEXT:    lui a0, 748388
; RV32-LMULMAX2-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX2-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX2-NEXT:    ret
;
; RV64-LMULMAX2-LABEL: buildvec_mask_v64i1:
; RV64-LMULMAX2:       # %bb.0:
; RV64-LMULMAX2-NEXT:    lui a0, 748384
; RV64-LMULMAX2-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV64-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX2-NEXT:    lui a0, 748388
; RV64-LMULMAX2-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX2-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX2-NEXT:    ret
;
; RV32-LMULMAX4-LABEL: buildvec_mask_v64i1:
; RV32-LMULMAX4:       # %bb.0:
; RV32-LMULMAX4-NEXT:    lui a0, 748388
; RV32-LMULMAX4-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX4-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; RV32-LMULMAX4-NEXT:    vmv.s.x v25, a0
; RV32-LMULMAX4-NEXT:    lui a0, 748384
; RV32-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX4-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX4-NEXT:    vsetivli a0, 2, e32,m1,tu,mu
; RV32-LMULMAX4-NEXT:    vslideup.vi v0, v25, 1
; RV32-LMULMAX4-NEXT:    ret
;
; RV64-LMULMAX4-LABEL: buildvec_mask_v64i1:
; RV64-LMULMAX4:       # %bb.0:
; RV64-LMULMAX4-NEXT:    lui a0, 1048429
; RV64-LMULMAX4-NEXT:    addiw a0, a0, 1735
; RV64-LMULMAX4-NEXT:    slli a0, a0, 13
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1023
; RV64-LMULMAX4-NEXT:    slli a0, a0, 13
; RV64-LMULMAX4-NEXT:    addi a0, a0, -1189
; RV64-LMULMAX4-NEXT:    slli a0, a0, 17
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX4-NEXT:    vsetivli a1, 1, e64,m1,ta,mu
; RV64-LMULMAX4-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX4-NEXT:    ret
;
; RV32-LMULMAX8-LABEL: buildvec_mask_v64i1:
; RV32-LMULMAX8:       # %bb.0:
; RV32-LMULMAX8-NEXT:    lui a0, 748388
; RV32-LMULMAX8-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX8-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; RV32-LMULMAX8-NEXT:    vmv.s.x v25, a0
; RV32-LMULMAX8-NEXT:    lui a0, 748384
; RV32-LMULMAX8-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX8-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX8-NEXT:    vsetivli a0, 2, e32,m1,tu,mu
; RV32-LMULMAX8-NEXT:    vslideup.vi v0, v25, 1
; RV32-LMULMAX8-NEXT:    ret
;
; RV64-LMULMAX8-LABEL: buildvec_mask_v64i1:
; RV64-LMULMAX8:       # %bb.0:
; RV64-LMULMAX8-NEXT:    lui a0, 1048429
; RV64-LMULMAX8-NEXT:    addiw a0, a0, 1735
; RV64-LMULMAX8-NEXT:    slli a0, a0, 13
; RV64-LMULMAX8-NEXT:    addi a0, a0, 1023
; RV64-LMULMAX8-NEXT:    slli a0, a0, 13
; RV64-LMULMAX8-NEXT:    addi a0, a0, -1189
; RV64-LMULMAX8-NEXT:    slli a0, a0, 17
; RV64-LMULMAX8-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX8-NEXT:    vsetivli a1, 1, e64,m1,ta,mu
; RV64-LMULMAX8-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX8-NEXT:    ret
  ret <64 x i1> <i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1>
}

define <128 x i1> @buildvec_mask_v128i1() {
; RV32-LMULMAX1-LABEL: buildvec_mask_v128i1:
; RV32-LMULMAX1:       # %bb.0:
; RV32-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV32-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV32-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX1-NEXT:    lui a0, 11
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1718
; RV32-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX1-NEXT:    lui a0, 8
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1718
; RV32-LMULMAX1-NEXT:    vmv.s.x v12, a0
; RV32-LMULMAX1-NEXT:    lui a0, 4
; RV32-LMULMAX1-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX1-NEXT:    vmv.s.x v9, a0
; RV32-LMULMAX1-NEXT:    lui a0, 14
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1722
; RV32-LMULMAX1-NEXT:    vmv.s.x v14, a0
; RV32-LMULMAX1-NEXT:    vmv1r.v v10, v8
; RV32-LMULMAX1-NEXT:    vmv1r.v v11, v0
; RV32-LMULMAX1-NEXT:    vmv1r.v v13, v9
; RV32-LMULMAX1-NEXT:    ret
;
; RV64-LMULMAX1-LABEL: buildvec_mask_v128i1:
; RV64-LMULMAX1:       # %bb.0:
; RV64-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV64-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV64-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX1-NEXT:    lui a0, 11
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1718
; RV64-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX1-NEXT:    lui a0, 8
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1718
; RV64-LMULMAX1-NEXT:    vmv.s.x v12, a0
; RV64-LMULMAX1-NEXT:    lui a0, 4
; RV64-LMULMAX1-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX1-NEXT:    vmv.s.x v9, a0
; RV64-LMULMAX1-NEXT:    lui a0, 14
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1722
; RV64-LMULMAX1-NEXT:    vmv.s.x v14, a0
; RV64-LMULMAX1-NEXT:    vmv1r.v v10, v8
; RV64-LMULMAX1-NEXT:    vmv1r.v v11, v0
; RV64-LMULMAX1-NEXT:    vmv1r.v v13, v9
; RV64-LMULMAX1-NEXT:    ret
;
; RV32-LMULMAX2-LABEL: buildvec_mask_v128i1:
; RV32-LMULMAX2:       # %bb.0:
; RV32-LMULMAX2-NEXT:    lui a0, 748384
; RV32-LMULMAX2-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV32-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX2-NEXT:    lui a0, 748388
; RV32-LMULMAX2-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX2-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX2-NEXT:    lui a0, 551776
; RV32-LMULMAX2-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX2-NEXT:    vmv.s.x v9, a0
; RV32-LMULMAX2-NEXT:    lui a0, 945060
; RV32-LMULMAX2-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX2-NEXT:    vmv.s.x v10, a0
; RV32-LMULMAX2-NEXT:    ret
;
; RV64-LMULMAX2-LABEL: buildvec_mask_v128i1:
; RV64-LMULMAX2:       # %bb.0:
; RV64-LMULMAX2-NEXT:    lui a0, 748384
; RV64-LMULMAX2-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV64-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX2-NEXT:    lui a0, 748388
; RV64-LMULMAX2-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX2-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX2-NEXT:    lui a0, 551776
; RV64-LMULMAX2-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX2-NEXT:    vmv.s.x v9, a0
; RV64-LMULMAX2-NEXT:    lui a0, 945060
; RV64-LMULMAX2-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX2-NEXT:    vmv.s.x v10, a0
; RV64-LMULMAX2-NEXT:    ret
;
; RV32-LMULMAX4-LABEL: buildvec_mask_v128i1:
; RV32-LMULMAX4:       # %bb.0:
; RV32-LMULMAX4-NEXT:    lui a0, 748388
; RV32-LMULMAX4-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX4-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; RV32-LMULMAX4-NEXT:    vmv.s.x v25, a0
; RV32-LMULMAX4-NEXT:    lui a0, 748384
; RV32-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX4-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX4-NEXT:    vsetivli a0, 2, e32,m1,tu,mu
; RV32-LMULMAX4-NEXT:    vslideup.vi v0, v25, 1
; RV32-LMULMAX4-NEXT:    lui a0, 945060
; RV32-LMULMAX4-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX4-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; RV32-LMULMAX4-NEXT:    vmv.s.x v25, a0
; RV32-LMULMAX4-NEXT:    lui a0, 551776
; RV32-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX4-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX4-NEXT:    vsetivli a0, 2, e32,m1,tu,mu
; RV32-LMULMAX4-NEXT:    vslideup.vi v8, v25, 1
; RV32-LMULMAX4-NEXT:    ret
;
; RV64-LMULMAX4-LABEL: buildvec_mask_v128i1:
; RV64-LMULMAX4:       # %bb.0:
; RV64-LMULMAX4-NEXT:    lui a0, 841543
; RV64-LMULMAX4-NEXT:    addiw a0, a0, 511
; RV64-LMULMAX4-NEXT:    slli a0, a0, 14
; RV64-LMULMAX4-NEXT:    addi a0, a0, 859
; RV64-LMULMAX4-NEXT:    slli a0, a0, 17
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX4-NEXT:    vsetivli a1, 1, e64,m1,ta,mu
; RV64-LMULMAX4-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX4-NEXT:    lui a0, 1048429
; RV64-LMULMAX4-NEXT:    addiw a0, a0, 1735
; RV64-LMULMAX4-NEXT:    slli a0, a0, 13
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1023
; RV64-LMULMAX4-NEXT:    slli a0, a0, 13
; RV64-LMULMAX4-NEXT:    addi a0, a0, -1189
; RV64-LMULMAX4-NEXT:    slli a0, a0, 17
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX4-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX4-NEXT:    ret
;
; RV32-LMULMAX8-LABEL: buildvec_mask_v128i1:
; RV32-LMULMAX8:       # %bb.0:
; RV32-LMULMAX8-NEXT:    lui a0, 748388
; RV32-LMULMAX8-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX8-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; RV32-LMULMAX8-NEXT:    vmv.s.x v25, a0
; RV32-LMULMAX8-NEXT:    lui a0, 748384
; RV32-LMULMAX8-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX8-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX8-NEXT:    vsetivli a0, 2, e32,m1,tu,mu
; RV32-LMULMAX8-NEXT:    vslideup.vi v0, v25, 1
; RV32-LMULMAX8-NEXT:    lui a0, 551776
; RV32-LMULMAX8-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX8-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; RV32-LMULMAX8-NEXT:    vmv.s.x v25, a0
; RV32-LMULMAX8-NEXT:    vsetivli a0, 3, e32,m1,tu,mu
; RV32-LMULMAX8-NEXT:    vslideup.vi v0, v25, 2
; RV32-LMULMAX8-NEXT:    lui a0, 945060
; RV32-LMULMAX8-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX8-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; RV32-LMULMAX8-NEXT:    vmv.s.x v25, a0
; RV32-LMULMAX8-NEXT:    vsetivli a0, 4, e32,m1,tu,mu
; RV32-LMULMAX8-NEXT:    vslideup.vi v0, v25, 3
; RV32-LMULMAX8-NEXT:    ret
;
; RV64-LMULMAX8-LABEL: buildvec_mask_v128i1:
; RV64-LMULMAX8:       # %bb.0:
; RV64-LMULMAX8-NEXT:    lui a0, 841543
; RV64-LMULMAX8-NEXT:    addiw a0, a0, 511
; RV64-LMULMAX8-NEXT:    slli a0, a0, 14
; RV64-LMULMAX8-NEXT:    addi a0, a0, 859
; RV64-LMULMAX8-NEXT:    slli a0, a0, 17
; RV64-LMULMAX8-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX8-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; RV64-LMULMAX8-NEXT:    vmv.s.x v25, a0
; RV64-LMULMAX8-NEXT:    lui a0, 1048429
; RV64-LMULMAX8-NEXT:    addiw a0, a0, 1735
; RV64-LMULMAX8-NEXT:    slli a0, a0, 13
; RV64-LMULMAX8-NEXT:    addi a0, a0, 1023
; RV64-LMULMAX8-NEXT:    slli a0, a0, 13
; RV64-LMULMAX8-NEXT:    addi a0, a0, -1189
; RV64-LMULMAX8-NEXT:    slli a0, a0, 17
; RV64-LMULMAX8-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX8-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX8-NEXT:    vsetivli a0, 2, e64,m1,tu,mu
; RV64-LMULMAX8-NEXT:    vslideup.vi v0, v25, 1
; RV64-LMULMAX8-NEXT:    ret
  ret <128 x i1> <i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 0, i1 1, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 1, i1 1, i1 1>
}

define <128 x i1> @buildvec_mask_optsize_v128i1() optsize {
; RV32-LMULMAX1-LABEL: buildvec_mask_optsize_v128i1:
; RV32-LMULMAX1:       # %bb.0:
; RV32-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV32-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV32-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX1-NEXT:    lui a0, 11
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1718
; RV32-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX1-NEXT:    lui a0, 8
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1718
; RV32-LMULMAX1-NEXT:    vmv.s.x v12, a0
; RV32-LMULMAX1-NEXT:    lui a0, 4
; RV32-LMULMAX1-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX1-NEXT:    vmv.s.x v9, a0
; RV32-LMULMAX1-NEXT:    lui a0, 14
; RV32-LMULMAX1-NEXT:    addi a0, a0, 1722
; RV32-LMULMAX1-NEXT:    vmv.s.x v14, a0
; RV32-LMULMAX1-NEXT:    vmv1r.v v10, v8
; RV32-LMULMAX1-NEXT:    vmv1r.v v11, v0
; RV32-LMULMAX1-NEXT:    vmv1r.v v13, v9
; RV32-LMULMAX1-NEXT:    ret
;
; RV64-LMULMAX1-LABEL: buildvec_mask_optsize_v128i1:
; RV64-LMULMAX1:       # %bb.0:
; RV64-LMULMAX1-NEXT:    addi a0, zero, 1776
; RV64-LMULMAX1-NEXT:    vsetivli a1, 1, e16,m1,ta,mu
; RV64-LMULMAX1-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX1-NEXT:    lui a0, 11
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1718
; RV64-LMULMAX1-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX1-NEXT:    lui a0, 8
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1718
; RV64-LMULMAX1-NEXT:    vmv.s.x v12, a0
; RV64-LMULMAX1-NEXT:    lui a0, 4
; RV64-LMULMAX1-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX1-NEXT:    vmv.s.x v9, a0
; RV64-LMULMAX1-NEXT:    lui a0, 14
; RV64-LMULMAX1-NEXT:    addiw a0, a0, 1722
; RV64-LMULMAX1-NEXT:    vmv.s.x v14, a0
; RV64-LMULMAX1-NEXT:    vmv1r.v v10, v8
; RV64-LMULMAX1-NEXT:    vmv1r.v v11, v0
; RV64-LMULMAX1-NEXT:    vmv1r.v v13, v9
; RV64-LMULMAX1-NEXT:    ret
;
; RV32-LMULMAX2-LABEL: buildvec_mask_optsize_v128i1:
; RV32-LMULMAX2:       # %bb.0:
; RV32-LMULMAX2-NEXT:    lui a0, 748384
; RV32-LMULMAX2-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV32-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV32-LMULMAX2-NEXT:    lui a0, 748388
; RV32-LMULMAX2-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX2-NEXT:    vmv.s.x v8, a0
; RV32-LMULMAX2-NEXT:    lui a0, 551776
; RV32-LMULMAX2-NEXT:    addi a0, a0, 1776
; RV32-LMULMAX2-NEXT:    vmv.s.x v9, a0
; RV32-LMULMAX2-NEXT:    lui a0, 945060
; RV32-LMULMAX2-NEXT:    addi a0, a0, -1793
; RV32-LMULMAX2-NEXT:    vmv.s.x v10, a0
; RV32-LMULMAX2-NEXT:    ret
;
; RV64-LMULMAX2-LABEL: buildvec_mask_optsize_v128i1:
; RV64-LMULMAX2:       # %bb.0:
; RV64-LMULMAX2-NEXT:    lui a0, 748384
; RV64-LMULMAX2-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX2-NEXT:    vsetivli a1, 1, e32,m1,ta,mu
; RV64-LMULMAX2-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX2-NEXT:    lui a0, 748388
; RV64-LMULMAX2-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX2-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX2-NEXT:    lui a0, 551776
; RV64-LMULMAX2-NEXT:    addiw a0, a0, 1776
; RV64-LMULMAX2-NEXT:    vmv.s.x v9, a0
; RV64-LMULMAX2-NEXT:    lui a0, 945060
; RV64-LMULMAX2-NEXT:    addiw a0, a0, -1793
; RV64-LMULMAX2-NEXT:    vmv.s.x v10, a0
; RV64-LMULMAX2-NEXT:    ret
;
; RV32-LMULMAX4-LABEL: buildvec_mask_optsize_v128i1:
; RV32-LMULMAX4:       # %bb.0:
; RV32-LMULMAX4-NEXT:    lui a0, %hi(.LCPI10_0)
; RV32-LMULMAX4-NEXT:    addi a0, a0, %lo(.LCPI10_0)
; RV32-LMULMAX4-NEXT:    addi a1, zero, 64
; RV32-LMULMAX4-NEXT:    vsetvli a1, a1, e8,m4,ta,mu
; RV32-LMULMAX4-NEXT:    vle1.v v0, (a0)
; RV32-LMULMAX4-NEXT:    lui a0, %hi(.LCPI10_1)
; RV32-LMULMAX4-NEXT:    addi a0, a0, %lo(.LCPI10_1)
; RV32-LMULMAX4-NEXT:    vle1.v v8, (a0)
; RV32-LMULMAX4-NEXT:    ret
;
; RV64-LMULMAX4-LABEL: buildvec_mask_optsize_v128i1:
; RV64-LMULMAX4:       # %bb.0:
; RV64-LMULMAX4-NEXT:    lui a0, 841543
; RV64-LMULMAX4-NEXT:    addiw a0, a0, 511
; RV64-LMULMAX4-NEXT:    slli a0, a0, 14
; RV64-LMULMAX4-NEXT:    addi a0, a0, 859
; RV64-LMULMAX4-NEXT:    slli a0, a0, 17
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX4-NEXT:    vsetivli a1, 1, e64,m1,ta,mu
; RV64-LMULMAX4-NEXT:    vmv.s.x v8, a0
; RV64-LMULMAX4-NEXT:    lui a0, 1048429
; RV64-LMULMAX4-NEXT:    addiw a0, a0, 1735
; RV64-LMULMAX4-NEXT:    slli a0, a0, 13
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1023
; RV64-LMULMAX4-NEXT:    slli a0, a0, 13
; RV64-LMULMAX4-NEXT:    addi a0, a0, -1189
; RV64-LMULMAX4-NEXT:    slli a0, a0, 17
; RV64-LMULMAX4-NEXT:    addi a0, a0, 1776
; RV64-LMULMAX4-NEXT:    vmv.s.x v0, a0
; RV64-LMULMAX4-NEXT:    ret
;
; RV32-LMULMAX8-LABEL: buildvec_mask_optsize_v128i1:
; RV32-LMULMAX8:       # %bb.0:
; RV32-LMULMAX8-NEXT:    lui a0, %hi(.LCPI10_0)
; RV32-LMULMAX8-NEXT:    addi a0, a0, %lo(.LCPI10_0)
; RV32-LMULMAX8-NEXT:    addi a1, zero, 128
; RV32-LMULMAX8-NEXT:    vsetvli a1, a1, e8,m8,ta,mu
; RV32-LMULMAX8-NEXT:    vle1.v v0, (a0)
; RV32-LMULMAX8-NEXT:    ret
;
; RV64-LMULMAX8-LABEL: buildvec_mask_optsize_v128i1:
; RV64-LMULMAX8:       # %bb.0:
; RV64-LMULMAX8-NEXT:    lui a0, %hi(.LCPI10_0)
; RV64-LMULMAX8-NEXT:    addi a0, a0, %lo(.LCPI10_0)
; RV64-LMULMAX8-NEXT:    addi a1, zero, 128
; RV64-LMULMAX8-NEXT:    vsetvli a1, a1, e8,m8,ta,mu
; RV64-LMULMAX8-NEXT:    vle1.v v0, (a0)
; RV64-LMULMAX8-NEXT:    ret
  ret <128 x i1> <i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 0, i1 0, i1 0, i1 1, i1 0, i1 1, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 1, i1 1, i1 1>
}
