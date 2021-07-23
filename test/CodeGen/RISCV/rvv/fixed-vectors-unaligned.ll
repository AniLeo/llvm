; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefix=RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefix=RV64

define <4 x i32> @load_v4i32_align1(<4 x i32>* %ptr) {
; RV32-LABEL: load_v4i32_align1:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV32-NEXT:    vle8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: load_v4i32_align1:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV64-NEXT:    vle8.v v8, (a0)
; RV64-NEXT:    ret
  %z = load <4 x i32>, <4 x i32>* %ptr, align 1
  ret <4 x i32> %z
}

define <4 x i32> @load_v4i32_align2(<4 x i32>* %ptr) {
; RV32-LABEL: load_v4i32_align2:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV32-NEXT:    vle8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: load_v4i32_align2:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV64-NEXT:    vle8.v v8, (a0)
; RV64-NEXT:    ret
  %z = load <4 x i32>, <4 x i32>* %ptr, align 2
  ret <4 x i32> %z
}

define void @store_v4i32_align1(<4 x i32> %x, <4 x i32>* %ptr) {
; RV32-LABEL: store_v4i32_align1:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: store_v4i32_align1:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
  store <4 x i32> %x, <4 x i32>* %ptr, align 1
  ret void
}

define void @store_v4i32_align2(<4 x i32> %x, <4 x i32>* %ptr) {
; RV32-LABEL: store_v4i32_align2:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: store_v4i32_align2:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
  store <4 x i32> %x, <4 x i32>* %ptr, align 2
  ret void
}

declare <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*>, i32, <2 x i1>, <2 x i16>)

define <2 x i16> @mgather_v2i16_align1(<2 x i16*> %ptrs, <2 x i1> %m, <2 x i16> %passthru) {
; RV32-LABEL: mgather_v2i16_align1:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vmerge.vim v25, v25, 1, v0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV32-NEXT:    vslideup.vi v26, v25, 0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmsne.vi v25, v26, 0
; RV32-NEXT:    addi a0, sp, 14
; RV32-NEXT:    vse1.v v25, (a0)
; RV32-NEXT:    lbu a0, 14(sp)
; RV32-NEXT:    andi a1, a0, 1
; RV32-NEXT:    beqz a1, .LBB4_2
; RV32-NEXT:  # %bb.1: # %cond.load
; RV32-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    lb a2, 1(a1)
; RV32-NEXT:    lbu a1, 0(a1)
; RV32-NEXT:    slli a2, a2, 8
; RV32-NEXT:    or a1, a2, a1
; RV32-NEXT:    vsetivli zero, 2, e16, mf4, tu, mu
; RV32-NEXT:    vmv.s.x v9, a1
; RV32-NEXT:  .LBB4_2: # %else
; RV32-NEXT:    andi a0, a0, 2
; RV32-NEXT:    beqz a0, .LBB4_4
; RV32-NEXT:  # %bb.3: # %cond.load1
; RV32-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v8, 1
; RV32-NEXT:    vmv.x.s a0, v25
; RV32-NEXT:    lb a1, 1(a0)
; RV32-NEXT:    lbu a0, 0(a0)
; RV32-NEXT:    slli a1, a1, 8
; RV32-NEXT:    or a0, a1, a0
; RV32-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; RV32-NEXT:    vmv.s.x v25, a0
; RV32-NEXT:    vsetvli zero, zero, e16, mf4, tu, mu
; RV32-NEXT:    vslideup.vi v9, v25, 1
; RV32-NEXT:  .LBB4_4: # %else2
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: mgather_v2i16_align1:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    .cfi_def_cfa_offset 16
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vmerge.vim v25, v25, 1, v0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV64-NEXT:    vslideup.vi v26, v25, 0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmsne.vi v25, v26, 0
; RV64-NEXT:    addi a0, sp, 14
; RV64-NEXT:    vse1.v v25, (a0)
; RV64-NEXT:    lbu a0, 14(sp)
; RV64-NEXT:    andi a1, a0, 1
; RV64-NEXT:    beqz a1, .LBB4_2
; RV64-NEXT:  # %bb.1: # %cond.load
; RV64-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; RV64-NEXT:    vmv.x.s a1, v8
; RV64-NEXT:    lb a2, 1(a1)
; RV64-NEXT:    lbu a1, 0(a1)
; RV64-NEXT:    slli a2, a2, 8
; RV64-NEXT:    or a1, a2, a1
; RV64-NEXT:    vsetivli zero, 2, e16, mf4, tu, mu
; RV64-NEXT:    vmv.s.x v9, a1
; RV64-NEXT:  .LBB4_2: # %else
; RV64-NEXT:    andi a0, a0, 2
; RV64-NEXT:    beqz a0, .LBB4_4
; RV64-NEXT:  # %bb.3: # %cond.load1
; RV64-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v8, 1
; RV64-NEXT:    vmv.x.s a0, v25
; RV64-NEXT:    lb a1, 1(a0)
; RV64-NEXT:    lbu a0, 0(a0)
; RV64-NEXT:    slli a1, a1, 8
; RV64-NEXT:    or a0, a1, a0
; RV64-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; RV64-NEXT:    vmv.s.x v25, a0
; RV64-NEXT:    vsetvli zero, zero, e16, mf4, tu, mu
; RV64-NEXT:    vslideup.vi v9, v25, 1
; RV64-NEXT:  .LBB4_4: # %else2
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  %v = call <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*> %ptrs, i32 1, <2 x i1> %m, <2 x i16> %passthru)
  ret <2 x i16> %v
}

declare <2 x i64> @llvm.masked.gather.v2i64.v2p0i64(<2 x i64*>, i32, <2 x i1>, <2 x i64>)

define <2 x i64> @mgather_v2i64_align4(<2 x i64*> %ptrs, <2 x i1> %m, <2 x i64> %passthru) {
; RV32-LABEL: mgather_v2i64_align4:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vmerge.vim v25, v25, 1, v0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV32-NEXT:    vslideup.vi v26, v25, 0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmsne.vi v25, v26, 0
; RV32-NEXT:    addi a0, sp, 14
; RV32-NEXT:    vse1.v v25, (a0)
; RV32-NEXT:    lbu a0, 14(sp)
; RV32-NEXT:    andi a1, a0, 1
; RV32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    beqz a1, .LBB5_2
; RV32-NEXT:  # %bb.1: # %cond.load
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    lw a2, 4(a1)
; RV32-NEXT:    lw a1, 0(a1)
; RV32-NEXT:    vslide1up.vx v26, v25, a2
; RV32-NEXT:    vslide1up.vx v27, v26, a1
; RV32-NEXT:    vsetivli zero, 1, e64, m1, tu, mu
; RV32-NEXT:    vslideup.vi v9, v27, 0
; RV32-NEXT:  .LBB5_2: # %else
; RV32-NEXT:    andi a0, a0, 2
; RV32-NEXT:    beqz a0, .LBB5_4
; RV32-NEXT:  # %bb.3: # %cond.load1
; RV32-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV32-NEXT:    vslidedown.vi v26, v8, 1
; RV32-NEXT:    vmv.x.s a0, v26
; RV32-NEXT:    lw a1, 4(a0)
; RV32-NEXT:    lw a0, 0(a0)
; RV32-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; RV32-NEXT:    vslide1up.vx v26, v25, a1
; RV32-NEXT:    vslide1up.vx v25, v26, a0
; RV32-NEXT:    vsetivli zero, 2, e64, m1, tu, mu
; RV32-NEXT:    vslideup.vi v9, v25, 1
; RV32-NEXT:  .LBB5_4: # %else2
; RV32-NEXT:    vmv1r.v v8, v9
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: mgather_v2i64_align4:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    .cfi_def_cfa_offset 16
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vmerge.vim v25, v25, 1, v0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV64-NEXT:    vslideup.vi v26, v25, 0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmsne.vi v25, v26, 0
; RV64-NEXT:    addi a0, sp, 14
; RV64-NEXT:    vse1.v v25, (a0)
; RV64-NEXT:    lbu a0, 14(sp)
; RV64-NEXT:    andi a1, a0, 1
; RV64-NEXT:    beqz a1, .LBB5_2
; RV64-NEXT:  # %bb.1: # %cond.load
; RV64-NEXT:    vsetivli zero, 0, e64, m1, ta, mu
; RV64-NEXT:    vmv.x.s a1, v8
; RV64-NEXT:    lwu a2, 4(a1)
; RV64-NEXT:    lwu a1, 0(a1)
; RV64-NEXT:    slli a2, a2, 32
; RV64-NEXT:    or a1, a2, a1
; RV64-NEXT:    vsetivli zero, 2, e64, m1, tu, mu
; RV64-NEXT:    vmv.s.x v9, a1
; RV64-NEXT:  .LBB5_2: # %else
; RV64-NEXT:    andi a0, a0, 2
; RV64-NEXT:    beqz a0, .LBB5_4
; RV64-NEXT:  # %bb.3: # %cond.load1
; RV64-NEXT:    vsetivli zero, 1, e64, m1, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v8, 1
; RV64-NEXT:    vmv.x.s a0, v25
; RV64-NEXT:    lwu a1, 4(a0)
; RV64-NEXT:    lwu a0, 0(a0)
; RV64-NEXT:    slli a1, a1, 32
; RV64-NEXT:    or a0, a1, a0
; RV64-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; RV64-NEXT:    vmv.s.x v25, a0
; RV64-NEXT:    vsetvli zero, zero, e64, m1, tu, mu
; RV64-NEXT:    vslideup.vi v9, v25, 1
; RV64-NEXT:  .LBB5_4: # %else2
; RV64-NEXT:    vmv1r.v v8, v9
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  %v = call <2 x i64> @llvm.masked.gather.v2i64.v2p0i64(<2 x i64*> %ptrs, i32 4, <2 x i1> %m, <2 x i64> %passthru)
  ret <2 x i64> %v
}

declare void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16>, <4 x i16*>, i32, <4 x i1>)

define void @mscatter_v4i16_align1(<4 x i16> %val, <4 x i16*> %ptrs, <4 x i1> %m) {
; RV32-LABEL: mscatter_v4i16_align1:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vmerge.vim v25, v25, 1, v0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vsetivli zero, 4, e8, mf2, tu, mu
; RV32-NEXT:    vslideup.vi v26, v25, 0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmsne.vi v25, v26, 0
; RV32-NEXT:    addi a0, sp, 12
; RV32-NEXT:    vse1.v v25, (a0)
; RV32-NEXT:    lbu a0, 12(sp)
; RV32-NEXT:    andi a1, a0, 1
; RV32-NEXT:    bnez a1, .LBB6_5
; RV32-NEXT:  # %bb.1: # %else
; RV32-NEXT:    andi a1, a0, 2
; RV32-NEXT:    bnez a1, .LBB6_6
; RV32-NEXT:  .LBB6_2: # %else2
; RV32-NEXT:    andi a1, a0, 4
; RV32-NEXT:    bnez a1, .LBB6_7
; RV32-NEXT:  .LBB6_3: # %else4
; RV32-NEXT:    andi a0, a0, 8
; RV32-NEXT:    bnez a0, .LBB6_8
; RV32-NEXT:  .LBB6_4: # %else6
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
; RV32-NEXT:  .LBB6_5: # %cond.store
; RV32-NEXT:    vsetivli zero, 0, e16, mf2, ta, mu
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; RV32-NEXT:    vmv.x.s a2, v9
; RV32-NEXT:    sb a1, 0(a2)
; RV32-NEXT:    srli a1, a1, 8
; RV32-NEXT:    sb a1, 1(a2)
; RV32-NEXT:    andi a1, a0, 2
; RV32-NEXT:    beqz a1, .LBB6_2
; RV32-NEXT:  .LBB6_6: # %cond.store1
; RV32-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v8, 1
; RV32-NEXT:    vmv.x.s a1, v25
; RV32-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v9, 1
; RV32-NEXT:    vmv.x.s a2, v25
; RV32-NEXT:    sb a1, 0(a2)
; RV32-NEXT:    srli a1, a1, 8
; RV32-NEXT:    sb a1, 1(a2)
; RV32-NEXT:    andi a1, a0, 4
; RV32-NEXT:    beqz a1, .LBB6_3
; RV32-NEXT:  .LBB6_7: # %cond.store3
; RV32-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v8, 2
; RV32-NEXT:    vmv.x.s a1, v25
; RV32-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v9, 2
; RV32-NEXT:    vmv.x.s a2, v25
; RV32-NEXT:    sb a1, 0(a2)
; RV32-NEXT:    srli a1, a1, 8
; RV32-NEXT:    sb a1, 1(a2)
; RV32-NEXT:    andi a0, a0, 8
; RV32-NEXT:    beqz a0, .LBB6_4
; RV32-NEXT:  .LBB6_8: # %cond.store5
; RV32-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v8, 3
; RV32-NEXT:    vmv.x.s a0, v25
; RV32-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v9, 3
; RV32-NEXT:    vmv.x.s a1, v25
; RV32-NEXT:    sb a0, 0(a1)
; RV32-NEXT:    srli a0, a0, 8
; RV32-NEXT:    sb a0, 1(a1)
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: mscatter_v4i16_align1:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    .cfi_def_cfa_offset 16
; RV64-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vmerge.vim v25, v25, 1, v0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vsetivli zero, 4, e8, mf2, tu, mu
; RV64-NEXT:    vslideup.vi v26, v25, 0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmsne.vi v25, v26, 0
; RV64-NEXT:    addi a0, sp, 12
; RV64-NEXT:    vse1.v v25, (a0)
; RV64-NEXT:    lbu a0, 12(sp)
; RV64-NEXT:    andi a1, a0, 1
; RV64-NEXT:    bnez a1, .LBB6_5
; RV64-NEXT:  # %bb.1: # %else
; RV64-NEXT:    andi a1, a0, 2
; RV64-NEXT:    bnez a1, .LBB6_6
; RV64-NEXT:  .LBB6_2: # %else2
; RV64-NEXT:    andi a1, a0, 4
; RV64-NEXT:    bnez a1, .LBB6_7
; RV64-NEXT:  .LBB6_3: # %else4
; RV64-NEXT:    andi a0, a0, 8
; RV64-NEXT:    bnez a0, .LBB6_8
; RV64-NEXT:  .LBB6_4: # %else6
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
; RV64-NEXT:  .LBB6_5: # %cond.store
; RV64-NEXT:    vsetivli zero, 0, e16, mf2, ta, mu
; RV64-NEXT:    vmv.x.s a1, v8
; RV64-NEXT:    vsetvli zero, zero, e64, m2, ta, mu
; RV64-NEXT:    vmv.x.s a2, v10
; RV64-NEXT:    sb a1, 0(a2)
; RV64-NEXT:    srli a1, a1, 8
; RV64-NEXT:    sb a1, 1(a2)
; RV64-NEXT:    andi a1, a0, 2
; RV64-NEXT:    beqz a1, .LBB6_2
; RV64-NEXT:  .LBB6_6: # %cond.store1
; RV64-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v8, 1
; RV64-NEXT:    vmv.x.s a1, v25
; RV64-NEXT:    vsetvli zero, zero, e64, m2, ta, mu
; RV64-NEXT:    vslidedown.vi v26, v10, 1
; RV64-NEXT:    vmv.x.s a2, v26
; RV64-NEXT:    sb a1, 0(a2)
; RV64-NEXT:    srli a1, a1, 8
; RV64-NEXT:    sb a1, 1(a2)
; RV64-NEXT:    andi a1, a0, 4
; RV64-NEXT:    beqz a1, .LBB6_3
; RV64-NEXT:  .LBB6_7: # %cond.store3
; RV64-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v8, 2
; RV64-NEXT:    vmv.x.s a1, v25
; RV64-NEXT:    vsetvli zero, zero, e64, m2, ta, mu
; RV64-NEXT:    vslidedown.vi v26, v10, 2
; RV64-NEXT:    vmv.x.s a2, v26
; RV64-NEXT:    sb a1, 0(a2)
; RV64-NEXT:    srli a1, a1, 8
; RV64-NEXT:    sb a1, 1(a2)
; RV64-NEXT:    andi a0, a0, 8
; RV64-NEXT:    beqz a0, .LBB6_4
; RV64-NEXT:  .LBB6_8: # %cond.store5
; RV64-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v8, 3
; RV64-NEXT:    vmv.x.s a0, v25
; RV64-NEXT:    vsetvli zero, zero, e64, m2, ta, mu
; RV64-NEXT:    vslidedown.vi v26, v10, 3
; RV64-NEXT:    vmv.x.s a1, v26
; RV64-NEXT:    sb a0, 0(a1)
; RV64-NEXT:    srli a0, a0, 8
; RV64-NEXT:    sb a0, 1(a1)
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> %val, <4 x i16*> %ptrs, i32 1, <4 x i1> %m)
  ret void
}

declare void @llvm.masked.scatter.v2i32.v2p0i32(<2 x i32>, <2 x i32*>, i32, <2 x i1>)

define void @mscatter_v2i32_align2(<2 x i32> %val, <2 x i32*> %ptrs, <2 x i1> %m) {
; RV32-LABEL: mscatter_v2i32_align2:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vmerge.vim v25, v25, 1, v0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV32-NEXT:    vslideup.vi v26, v25, 0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmsne.vi v25, v26, 0
; RV32-NEXT:    addi a0, sp, 14
; RV32-NEXT:    vse1.v v25, (a0)
; RV32-NEXT:    lbu a0, 14(sp)
; RV32-NEXT:    andi a1, a0, 1
; RV32-NEXT:    bnez a1, .LBB7_3
; RV32-NEXT:  # %bb.1: # %else
; RV32-NEXT:    andi a0, a0, 2
; RV32-NEXT:    bnez a0, .LBB7_4
; RV32-NEXT:  .LBB7_2: # %else2
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
; RV32-NEXT:  .LBB7_3: # %cond.store
; RV32-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    vmv.x.s a2, v9
; RV32-NEXT:    sh a1, 0(a2)
; RV32-NEXT:    srli a1, a1, 16
; RV32-NEXT:    sh a1, 2(a2)
; RV32-NEXT:    andi a0, a0, 2
; RV32-NEXT:    beqz a0, .LBB7_2
; RV32-NEXT:  .LBB7_4: # %cond.store1
; RV32-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v8, 1
; RV32-NEXT:    vmv.x.s a0, v25
; RV32-NEXT:    vslidedown.vi v25, v9, 1
; RV32-NEXT:    vmv.x.s a1, v25
; RV32-NEXT:    sh a0, 0(a1)
; RV32-NEXT:    srli a0, a0, 16
; RV32-NEXT:    sh a0, 2(a1)
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: mscatter_v2i32_align2:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    .cfi_def_cfa_offset 16
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vmerge.vim v25, v25, 1, v0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV64-NEXT:    vslideup.vi v26, v25, 0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmsne.vi v25, v26, 0
; RV64-NEXT:    addi a0, sp, 14
; RV64-NEXT:    vse1.v v25, (a0)
; RV64-NEXT:    lbu a0, 14(sp)
; RV64-NEXT:    andi a1, a0, 1
; RV64-NEXT:    bnez a1, .LBB7_3
; RV64-NEXT:  # %bb.1: # %else
; RV64-NEXT:    andi a0, a0, 2
; RV64-NEXT:    bnez a0, .LBB7_4
; RV64-NEXT:  .LBB7_2: # %else2
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
; RV64-NEXT:  .LBB7_3: # %cond.store
; RV64-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; RV64-NEXT:    vmv.x.s a1, v8
; RV64-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; RV64-NEXT:    vmv.x.s a2, v9
; RV64-NEXT:    sh a1, 0(a2)
; RV64-NEXT:    srli a1, a1, 16
; RV64-NEXT:    sh a1, 2(a2)
; RV64-NEXT:    andi a0, a0, 2
; RV64-NEXT:    beqz a0, .LBB7_2
; RV64-NEXT:  .LBB7_4: # %cond.store1
; RV64-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v8, 1
; RV64-NEXT:    vmv.x.s a0, v25
; RV64-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v9, 1
; RV64-NEXT:    vmv.x.s a1, v25
; RV64-NEXT:    sh a0, 0(a1)
; RV64-NEXT:    srli a0, a0, 16
; RV64-NEXT:    sh a0, 2(a1)
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  call void @llvm.masked.scatter.v2i32.v2p0i32(<2 x i32> %val, <2 x i32*> %ptrs, i32 2, <2 x i1> %m)
  ret void
}

declare <2 x i32> @llvm.masked.load.v2i32(<2 x i32>*, i32, <2 x i1>, <2 x i32>)

define void @masked_load_v2i32_align1(<2 x i32>* %a, <2 x i32> %m, <2 x i32>* %res_ptr) nounwind {
; RV32-LABEL: masked_load_v2i32_align1:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    vmseq.vi v0, v8, 0
; RV32-NEXT:    vsetvli zero, zero, e8, mf8, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vmerge.vim v25, v25, 1, v0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV32-NEXT:    vslideup.vi v26, v25, 0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmsne.vi v25, v26, 0
; RV32-NEXT:    addi a2, sp, 14
; RV32-NEXT:    vse1.v v25, (a2)
; RV32-NEXT:    lbu a2, 14(sp)
; RV32-NEXT:    andi a3, a2, 1
; RV32-NEXT:    beqz a3, .LBB8_2
; RV32-NEXT:  # %bb.1: # %cond.load
; RV32-NEXT:    lbu a6, 1(a0)
; RV32-NEXT:    lbu a7, 0(a0)
; RV32-NEXT:    lbu a5, 3(a0)
; RV32-NEXT:    lbu a3, 2(a0)
; RV32-NEXT:    slli a4, a6, 8
; RV32-NEXT:    or a4, a4, a7
; RV32-NEXT:    slli a5, a5, 8
; RV32-NEXT:    or a3, a5, a3
; RV32-NEXT:    slli a3, a3, 16
; RV32-NEXT:    or a3, a3, a4
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    vmv.v.x v25, a3
; RV32-NEXT:    andi a2, a2, 2
; RV32-NEXT:    bnez a2, .LBB8_3
; RV32-NEXT:    j .LBB8_4
; RV32-NEXT:  .LBB8_2:
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    andi a2, a2, 2
; RV32-NEXT:    beqz a2, .LBB8_4
; RV32-NEXT:  .LBB8_3: # %cond.load1
; RV32-NEXT:    lbu a2, 5(a0)
; RV32-NEXT:    lbu a3, 4(a0)
; RV32-NEXT:    lbu a4, 7(a0)
; RV32-NEXT:    lbu a0, 6(a0)
; RV32-NEXT:    slli a2, a2, 8
; RV32-NEXT:    or a2, a2, a3
; RV32-NEXT:    slli a3, a4, 8
; RV32-NEXT:    or a0, a3, a0
; RV32-NEXT:    slli a0, a0, 16
; RV32-NEXT:    or a0, a0, a2
; RV32-NEXT:    vmv.s.x v26, a0
; RV32-NEXT:    vsetvli zero, zero, e32, mf2, tu, mu
; RV32-NEXT:    vslideup.vi v25, v26, 1
; RV32-NEXT:  .LBB8_4: # %else2
; RV32-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; RV32-NEXT:    vse32.v v25, (a1)
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_load_v2i32_align1:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vmseq.vi v0, v8, 0
; RV64-NEXT:    vsetvli zero, zero, e8, mf8, ta, mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vmerge.vim v25, v25, 1, v0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV64-NEXT:    vslideup.vi v26, v25, 0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmsne.vi v25, v26, 0
; RV64-NEXT:    addi a2, sp, 14
; RV64-NEXT:    vse1.v v25, (a2)
; RV64-NEXT:    lbu a2, 14(sp)
; RV64-NEXT:    andi a3, a2, 1
; RV64-NEXT:    beqz a3, .LBB8_2
; RV64-NEXT:  # %bb.1: # %cond.load
; RV64-NEXT:    lbu a6, 1(a0)
; RV64-NEXT:    lbu a7, 0(a0)
; RV64-NEXT:    lb a5, 3(a0)
; RV64-NEXT:    lbu a3, 2(a0)
; RV64-NEXT:    slli a4, a6, 8
; RV64-NEXT:    or a4, a4, a7
; RV64-NEXT:    slli a5, a5, 8
; RV64-NEXT:    or a3, a5, a3
; RV64-NEXT:    slli a3, a3, 16
; RV64-NEXT:    or a3, a3, a4
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vmv.v.x v25, a3
; RV64-NEXT:    andi a2, a2, 2
; RV64-NEXT:    bnez a2, .LBB8_3
; RV64-NEXT:    j .LBB8_4
; RV64-NEXT:  .LBB8_2:
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    andi a2, a2, 2
; RV64-NEXT:    beqz a2, .LBB8_4
; RV64-NEXT:  .LBB8_3: # %cond.load1
; RV64-NEXT:    lbu a2, 5(a0)
; RV64-NEXT:    lbu a3, 4(a0)
; RV64-NEXT:    lb a4, 7(a0)
; RV64-NEXT:    lbu a0, 6(a0)
; RV64-NEXT:    slli a2, a2, 8
; RV64-NEXT:    or a2, a2, a3
; RV64-NEXT:    slli a3, a4, 8
; RV64-NEXT:    or a0, a3, a0
; RV64-NEXT:    slli a0, a0, 16
; RV64-NEXT:    or a0, a0, a2
; RV64-NEXT:    vmv.s.x v26, a0
; RV64-NEXT:    vsetvli zero, zero, e32, mf2, tu, mu
; RV64-NEXT:    vslideup.vi v25, v26, 1
; RV64-NEXT:  .LBB8_4: # %else2
; RV64-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; RV64-NEXT:    vse32.v v25, (a1)
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  %mask = icmp eq <2 x i32> %m, zeroinitializer
  %load = call <2 x i32> @llvm.masked.load.v2i32(<2 x i32>* %a, i32 1, <2 x i1> %mask, <2 x i32> undef)
  store <2 x i32> %load, <2 x i32>* %res_ptr
  ret void
}

declare void @llvm.masked.store.v2i32.p0v2i32(<2 x i32>, <2 x i32>*, i32, <2 x i1>)

define void @masked_store_v2i32_align2(<2 x i32> %val, <2 x i32>* %a, <2 x i32> %m) nounwind {
; RV32-LABEL: masked_store_v2i32_align2:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    vmseq.vi v0, v9, 0
; RV32-NEXT:    vsetvli zero, zero, e8, mf8, ta, mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vmerge.vim v25, v25, 1, v0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV32-NEXT:    vslideup.vi v26, v25, 0
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV32-NEXT:    vmsne.vi v25, v26, 0
; RV32-NEXT:    addi a1, sp, 14
; RV32-NEXT:    vse1.v v25, (a1)
; RV32-NEXT:    lbu a1, 14(sp)
; RV32-NEXT:    andi a2, a1, 1
; RV32-NEXT:    bnez a2, .LBB9_3
; RV32-NEXT:  # %bb.1: # %else
; RV32-NEXT:    andi a1, a1, 2
; RV32-NEXT:    bnez a1, .LBB9_4
; RV32-NEXT:  .LBB9_2: # %else2
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
; RV32-NEXT:  .LBB9_3: # %cond.store
; RV32-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; RV32-NEXT:    vmv.x.s a2, v8
; RV32-NEXT:    sh a2, 0(a0)
; RV32-NEXT:    srli a2, a2, 16
; RV32-NEXT:    sh a2, 2(a0)
; RV32-NEXT:    andi a1, a1, 2
; RV32-NEXT:    beqz a1, .LBB9_2
; RV32-NEXT:  .LBB9_4: # %cond.store1
; RV32-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV32-NEXT:    vslidedown.vi v25, v8, 1
; RV32-NEXT:    vmv.x.s a1, v25
; RV32-NEXT:    sh a1, 4(a0)
; RV32-NEXT:    srli a1, a1, 16
; RV32-NEXT:    sh a1, 6(a0)
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_store_v2i32_align2:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vmseq.vi v0, v9, 0
; RV64-NEXT:    vsetvli zero, zero, e8, mf8, ta, mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vmerge.vim v25, v25, 1, v0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; RV64-NEXT:    vslideup.vi v26, v25, 0
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; RV64-NEXT:    vmsne.vi v25, v26, 0
; RV64-NEXT:    addi a1, sp, 14
; RV64-NEXT:    vse1.v v25, (a1)
; RV64-NEXT:    lbu a1, 14(sp)
; RV64-NEXT:    andi a2, a1, 1
; RV64-NEXT:    bnez a2, .LBB9_3
; RV64-NEXT:  # %bb.1: # %else
; RV64-NEXT:    andi a1, a1, 2
; RV64-NEXT:    bnez a1, .LBB9_4
; RV64-NEXT:  .LBB9_2: # %else2
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
; RV64-NEXT:  .LBB9_3: # %cond.store
; RV64-NEXT:    vsetivli zero, 0, e32, mf2, ta, mu
; RV64-NEXT:    vmv.x.s a2, v8
; RV64-NEXT:    sh a2, 0(a0)
; RV64-NEXT:    srli a2, a2, 16
; RV64-NEXT:    sh a2, 2(a0)
; RV64-NEXT:    andi a1, a1, 2
; RV64-NEXT:    beqz a1, .LBB9_2
; RV64-NEXT:  .LBB9_4: # %cond.store1
; RV64-NEXT:    vsetivli zero, 1, e32, mf2, ta, mu
; RV64-NEXT:    vslidedown.vi v25, v8, 1
; RV64-NEXT:    vmv.x.s a1, v25
; RV64-NEXT:    sh a1, 4(a0)
; RV64-NEXT:    srli a1, a1, 16
; RV64-NEXT:    sh a1, 6(a0)
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  %mask = icmp eq <2 x i32> %m, zeroinitializer
  call void @llvm.masked.store.v2i32.p0v2i32(<2 x i32> %val, <2 x i32>* %a, i32 2, <2 x i1> %mask)
  ret void
}
