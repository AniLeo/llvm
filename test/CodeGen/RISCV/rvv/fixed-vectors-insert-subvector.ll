; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+experimental-v --riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv32 -mattr=+m,+experimental-v --riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v --riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v --riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define <vscale x 8 x i32> @insert_nxv8i32_v2i32_0(<vscale x 8 x i32> %vec, <2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v12, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e32, m4, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v12, 0
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> %vec, <2 x i32> %sv, i64 0)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v2i32_2(<vscale x 8 x i32> %vec, <2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_v2i32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v12, (a0)
; CHECK-NEXT:    vsetivli zero, 4, e32, m4, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v12, 2
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> %vec, <2 x i32> %sv, i64 2)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v2i32_6(<vscale x 8 x i32> %vec, <2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_v2i32_6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v12, (a0)
; CHECK-NEXT:    vsetivli zero, 8, e32, m4, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v12, 6
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> %vec, <2 x i32> %sv, i64 6)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v8i32_0(<vscale x 8 x i32> %vec, <8 x i32>* %svp) {
; LMULMAX2-LABEL: insert_nxv8i32_v8i32_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v12, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m4, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v8, v12, 0
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_nxv8i32_v8i32_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v12, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle32.v v16, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m4, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v12, 0
; LMULMAX1-NEXT:    vsetivli zero, 8, e32, m4, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v16, 4
; LMULMAX1-NEXT:    ret
  %sv = load <8 x i32>, <8 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v8i32.nxv8i32(<vscale x 8 x i32> %vec, <8 x i32> %sv, i64 0)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v8i32_8(<vscale x 8 x i32> %vec, <8 x i32>* %svp) {
; LMULMAX2-LABEL: insert_nxv8i32_v8i32_8:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v12, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 16, e32, m4, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v8, v12, 8
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_nxv8i32_v8i32_8:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v12, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle32.v v16, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 12, e32, m4, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v12, 8
; LMULMAX1-NEXT:    vsetivli zero, 16, e32, m4, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v16, 12
; LMULMAX1-NEXT:    ret
  %sv = load <8 x i32>, <8 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v8i32.nxv8i32(<vscale x 8 x i32> %vec, <8 x i32> %sv, i64 8)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_undef_v2i32_0(<2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_undef_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> undef, <2 x i32> %sv, i64 0)
  ret <vscale x 8 x i32> %v
}

define void @insert_v4i32_v2i32_0(<4 x i32>* %vp, <2 x i32>* %svp) {
; CHECK-LABEL: insert_v4i32_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v9, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e32, m1, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vse32.v v9, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <4 x i32>, <4 x i32>* %vp
  %v = call <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32> %vec, <2 x i32> %sv, i64 0)
  store <4 x i32> %v, <4 x i32>* %vp
  ret void
}

define void @insert_v4i32_v2i32_2(<4 x i32>* %vp, <2 x i32>* %svp) {
; CHECK-LABEL: insert_v4i32_v2i32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v9, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 2
; CHECK-NEXT:    vse32.v v9, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <4 x i32>, <4 x i32>* %vp
  %v = call <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32> %vec, <2 x i32> %sv, i64 2)
  store <4 x i32> %v, <4 x i32>* %vp
  ret void
}

define void @insert_v4i32_undef_v2i32_0(<4 x i32>* %vp, <2 x i32>* %svp) {
; CHECK-LABEL: insert_v4i32_undef_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 2, e32, m1, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vse32.v v9, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32> undef, <2 x i32> %sv, i64 0)
  store <4 x i32> %v, <4 x i32>* %vp
  ret void
}

define void @insert_v8i32_v2i32_0(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_v2i32_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX2-NEXT:    vle32.v v8, (a1)
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v10, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, m2, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v10, v8, 0
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vse32.v v10, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_v2i32_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vle32.v v8, (a1)
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v9, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v9, v8, 0
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vse32.v v9, (a0)
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <8 x i32>, <8 x i32>* %vp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> %vec, <2 x i32> %sv, i64 0)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

define void @insert_v8i32_v2i32_2(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_v2i32_2:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX2-NEXT:    vle32.v v8, (a1)
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v10, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 4, e32, m2, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v10, v8, 2
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vse32.v v10, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_v2i32_2:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vle32.v v8, (a1)
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v9, (a0)
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v9, v8, 2
; LMULMAX1-NEXT:    vse32.v v9, (a0)
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <8 x i32>, <8 x i32>* %vp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> %vec, <2 x i32> %sv, i64 2)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

define void @insert_v8i32_v2i32_6(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_v2i32_6:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX2-NEXT:    vle32.v v8, (a1)
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v10, (a0)
; LMULMAX2-NEXT:    vsetvli zero, zero, e32, m2, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v10, v8, 6
; LMULMAX2-NEXT:    vse32.v v10, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_v2i32_6:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vle32.v v8, (a1)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v9, (a0)
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v9, v8, 2
; LMULMAX1-NEXT:    vse32.v v9, (a0)
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <8 x i32>, <8 x i32>* %vp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> %vec, <2 x i32> %sv, i64 6)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

define void @insert_v8i32_undef_v2i32_6(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_undef_v2i32_6:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX2-NEXT:    vle32.v v8, (a1)
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vslideup.vi v10, v8, 6
; LMULMAX2-NEXT:    vse32.v v10, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_undef_v2i32_6:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vle32.v v8, (a1)
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vslideup.vi v9, v8, 2
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse32.v v9, (a0)
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> undef, <2 x i32> %sv, i64 6)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

define void @insert_v4i16_v2i16_0(<4 x i16>* %vp, <2 x i16>* %svp) {
; CHECK-LABEL: insert_v4i16_v2i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v9, (a1)
; CHECK-NEXT:    vsetivli zero, 2, e16, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v9, 0
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <4 x i16>, <4 x i16>* %vp
  %sv = load <2 x i16>, <2 x i16>* %svp
  %c = call <4 x i16> @llvm.experimental.vector.insert.v2i16.v4i16(<4 x i16> %v, <2 x i16> %sv, i64 0)
  store <4 x i16> %c, <4 x i16>* %vp
  ret void
}

define void @insert_v4i16_v2i16_2(<4 x i16>* %vp, <2 x i16>* %svp) {
; CHECK-LABEL: insert_v4i16_v2i16_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v9, (a1)
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v9, 2
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <4 x i16>, <4 x i16>* %vp
  %sv = load <2 x i16>, <2 x i16>* %svp
  %c = call <4 x i16> @llvm.experimental.vector.insert.v2i16.v4i16(<4 x i16> %v, <2 x i16> %sv, i64 2)
  store <4 x i16> %c, <4 x i16>* %vp
  ret void
}

define void @insert_v32i1_v8i1_0(<32 x i1>* %vp, <8 x i1>* %svp) {
; LMULMAX2-LABEL: insert_v32i1_v8i1_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vlm.v v8, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vlm.v v9, (a1)
; LMULMAX2-NEXT:    vsetivli zero, 1, e8, mf4, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v8, v9, 0
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vsm.v v8, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v32i1_v8i1_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vlm.v v8, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vlm.v v9, (a1)
; LMULMAX1-NEXT:    vsetivli zero, 1, e8, mf8, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v9, 0
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vsm.v v8, (a0)
; LMULMAX1-NEXT:    ret
  %v = load <32 x i1>, <32 x i1>* %vp
  %sv = load <8 x i1>, <8 x i1>* %svp
  %c = call <32 x i1> @llvm.experimental.vector.insert.v8i1.v32i1(<32 x i1> %v, <8 x i1> %sv, i64 0)
  store <32 x i1> %c, <32 x i1>* %vp
  ret void
}

define void @insert_v32i1_v8i1_16(<32 x i1>* %vp, <8 x i1>* %svp) {
; LMULMAX2-LABEL: insert_v32i1_v8i1_16:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vlm.v v8, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vlm.v v9, (a1)
; LMULMAX2-NEXT:    vsetivli zero, 3, e8, mf4, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v8, v9, 2
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vsm.v v8, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v32i1_v8i1_16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi a0, a0, 2
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vlm.v v8, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vlm.v v9, (a1)
; LMULMAX1-NEXT:    vsetivli zero, 1, e8, mf8, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v9, 0
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vsm.v v8, (a0)
; LMULMAX1-NEXT:    ret
  %v = load <32 x i1>, <32 x i1>* %vp
  %sv = load <8 x i1>, <8 x i1>* %svp
  %c = call <32 x i1> @llvm.experimental.vector.insert.v8i1.v32i1(<32 x i1> %v, <8 x i1> %sv, i64 16)
  store <32 x i1> %c, <32 x i1>* %vp
  ret void
}

define void @insert_v8i1_v4i1_0(<8 x i1>* %vp, <4 x i1>* %svp) {
; CHECK-LABEL: insert_v8i1_v4i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vlm.v v0, (a0)
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vlm.v v8, (a1)
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vmerge.vim v9, v9, 1, v0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v10, 0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vmerge.vim v8, v10, 1, v0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <8 x i1>, <8 x i1>* %vp
  %sv = load <4 x i1>, <4 x i1>* %svp
  %c = call <8 x i1> @llvm.experimental.vector.insert.v4i1.v8i1(<8 x i1> %v, <4 x i1> %sv, i64 0)
  store <8 x i1> %c, <8 x i1>* %vp
  ret void
}

define void @insert_v8i1_v4i1_4(<8 x i1>* %vp, <4 x i1>* %svp) {
; CHECK-LABEL: insert_v8i1_v4i1_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vlm.v v0, (a0)
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vlm.v v8, (a1)
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vmerge.vim v9, v9, 1, v0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v10, 0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vmerge.vim v8, v10, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 4
; CHECK-NEXT:    vsetvli zero, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <8 x i1>, <8 x i1>* %vp
  %sv = load <4 x i1>, <4 x i1>* %svp
  %c = call <8 x i1> @llvm.experimental.vector.insert.v4i1.v8i1(<8 x i1> %v, <4 x i1> %sv, i64 4)
  store <8 x i1> %c, <8 x i1>* %vp
  ret void
}

define <vscale x 2 x i16> @insert_nxv2i16_v2i16_0(<vscale x 2 x i16> %v, <2 x i16>* %svp) {
; CHECK-LABEL: insert_nxv2i16_v2i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e16, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v9, 0
; CHECK-NEXT:    ret
  %sv = load <2 x i16>, <2 x i16>* %svp
  %c = call <vscale x 2 x i16> @llvm.experimental.vector.insert.v2i16.nxv2i16(<vscale x 2 x i16> %v, <2 x i16> %sv, i64 0)
  ret <vscale x 2 x i16> %c
}

define <vscale x 2 x i16> @insert_nxv2i16_v2i16_2(<vscale x 2 x i16> %v, <2 x i16>* %svp) {
; CHECK-LABEL: insert_nxv2i16_v2i16_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    vsetivli zero, 6, e16, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v9, 4
; CHECK-NEXT:    ret
  %sv = load <2 x i16>, <2 x i16>* %svp
  %c = call <vscale x 2 x i16> @llvm.experimental.vector.insert.v2i16.nxv2i16(<vscale x 2 x i16> %v, <2 x i16> %sv, i64 4)
  ret <vscale x 2 x i16> %c
}

define <vscale x 2 x i1> @insert_nxv2i1_v4i1_0(<vscale x 2 x i1> %v, <4 x i1>* %svp) {
; CHECK-LABEL: insert_nxv2i1_v4i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vlm.v v8, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vmerge.vim v9, v9, 1, v0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v10, 0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vmerge.vim v8, v10, 1, v0
; CHECK-NEXT:    vsetvli zero, zero, e8, mf4, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetvli a0, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vmsne.vi v0, v9, 0
; CHECK-NEXT:    ret
  %sv = load <4 x i1>, <4 x i1>* %svp
  %c = call <vscale x 2 x i1> @llvm.experimental.vector.insert.v4i1.nxv2i1(<vscale x 2 x i1> %v, <4 x i1> %sv, i64 0)
  ret <vscale x 2 x i1> %c
}

define <vscale x 8 x i1> @insert_nxv8i1_v4i1_0(<vscale x 8 x i1> %v, <8 x i1>* %svp) {
; CHECK-LABEL: insert_nxv8i1_v4i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vlm.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, tu, mu
; CHECK-NEXT:    vslideup.vi v0, v8, 0
; CHECK-NEXT:    ret
  %sv = load <8 x i1>, <8 x i1>* %svp
  %c = call <vscale x 8 x i1> @llvm.experimental.vector.insert.v8i1.nxv8i1(<vscale x 8 x i1> %v, <8 x i1> %sv, i64 0)
  ret <vscale x 8 x i1> %c
}

define <vscale x 8 x i1> @insert_nxv8i1_v8i1_16(<vscale x 8 x i1> %v, <8 x i1>* %svp) {
; CHECK-LABEL: insert_nxv8i1_v8i1_16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vlm.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 3, e8, mf8, tu, mu
; CHECK-NEXT:    vslideup.vi v0, v8, 2
; CHECK-NEXT:    ret
  %sv = load <8 x i1>, <8 x i1>* %svp
  %c = call <vscale x 8 x i1> @llvm.experimental.vector.insert.v8i1.nxv8i1(<vscale x 8 x i1> %v, <8 x i1> %sv, i64 16)
  ret <vscale x 8 x i1> %c
}

declare <vscale x 16 x i64> @llvm.experimental.vector.insert.v2i64.nxv16i64(<vscale x 16 x i64>, <2 x i64>, i64)

define void @insert_v2i64_nxv16i64(<2 x i64>* %psv0, <2 x i64>* %psv1, <vscale x 16 x i64>* %out) {
; CHECK-LABEL: insert_v2i64_nxv16i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vle64.v v16, (a1)
; CHECK-NEXT:    vsetivli zero, 6, e64, m8, tu, mu
; CHECK-NEXT:    vslideup.vi v8, v16, 4
; CHECK-NEXT:    vs8r.v v8, (a2)
; CHECK-NEXT:    ret
  %sv0 = load <2 x i64>, <2 x i64>* %psv0
  %sv1 = load <2 x i64>, <2 x i64>* %psv1
  %v0 = call <vscale x 16 x i64> @llvm.experimental.vector.insert.v2i64.nxv16i64(<vscale x 16 x i64> undef, <2 x i64> %sv0, i64 0)
  %v = call <vscale x 16 x i64> @llvm.experimental.vector.insert.v2i64.nxv16i64(<vscale x 16 x i64> %v0, <2 x i64> %sv1, i64 4)
  store <vscale x 16 x i64> %v, <vscale x 16 x i64>* %out
  ret void
}

define void @insert_v2i64_nxv16i64_lo0(<2 x i64>* %psv, <vscale x 16 x i64>* %out) {
; CHECK-LABEL: insert_v2i64_nxv16i64_lo0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vs8r.v v8, (a1)
; CHECK-NEXT:    ret
  %sv = load <2 x i64>, <2 x i64>* %psv
  %v = call <vscale x 16 x i64> @llvm.experimental.vector.insert.v2i64.nxv16i64(<vscale x 16 x i64> undef, <2 x i64> %sv, i64 0)
  store <vscale x 16 x i64> %v, <vscale x 16 x i64>* %out
  ret void
}

define void @insert_v2i64_nxv16i64_lo2(<2 x i64>* %psv, <vscale x 16 x i64>* %out) {
; CHECK-LABEL: insert_v2i64_nxv16i64_lo2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 4, e64, m8, ta, mu
; CHECK-NEXT:    vslideup.vi v16, v8, 2
; CHECK-NEXT:    vs8r.v v16, (a1)
; CHECK-NEXT:    ret
  %sv = load <2 x i64>, <2 x i64>* %psv
  %v = call <vscale x 16 x i64> @llvm.experimental.vector.insert.v2i64.nxv16i64(<vscale x 16 x i64> undef, <2 x i64> %sv, i64 2)
  store <vscale x 16 x i64> %v, <vscale x 16 x i64>* %out
  ret void
}

; Check we don't mistakenly optimize this: we don't know whether this is
; inserted into the low or high split vector.
define void @insert_v2i64_nxv16i64_hi(<2 x i64>* %psv, <vscale x 16 x i64>* %out) {
; CHECK-LABEL: insert_v2i64_nxv16i64_hi:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 4
; CHECK-NEXT:    sub sp, sp, a2
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    addi a0, sp, 80
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 3
; CHECK-NEXT:    addi a2, sp, 16
; CHECK-NEXT:    add a2, a2, a0
; CHECK-NEXT:    vl8re64.v v8, (a2)
; CHECK-NEXT:    addi a2, sp, 16
; CHECK-NEXT:    vl8re64.v v16, (a2)
; CHECK-NEXT:    add a0, a1, a0
; CHECK-NEXT:    vs8r.v v8, (a0)
; CHECK-NEXT:    vs8r.v v16, (a1)
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 4
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
  %sv = load <2 x i64>, <2 x i64>* %psv
  %v = call <vscale x 16 x i64> @llvm.experimental.vector.insert.v2i64.nxv16i64(<vscale x 16 x i64> undef, <2 x i64> %sv, i64 8)
  store <vscale x 16 x i64> %v, <vscale x 16 x i64>* %out
  ret void
}

declare <8 x i1> @llvm.experimental.vector.insert.v4i1.v8i1(<8 x i1>, <4 x i1>, i64)
declare <32 x i1> @llvm.experimental.vector.insert.v8i1.v32i1(<32 x i1>, <8 x i1>, i64)

declare <4 x i16> @llvm.experimental.vector.insert.v2i16.v4i16(<4 x i16>, <2 x i16>, i64)

declare <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32>, <2 x i32>, i64)
declare <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32>, <2 x i32>, i64)

declare <vscale x 2 x i1> @llvm.experimental.vector.insert.v4i1.nxv2i1(<vscale x 2 x i1>, <4 x i1>, i64)
declare <vscale x 8 x i1> @llvm.experimental.vector.insert.v8i1.nxv8i1(<vscale x 8 x i1>, <8 x i1>, i64)

declare <vscale x 2 x i16> @llvm.experimental.vector.insert.v2i16.nxv2i16(<vscale x 2 x i16>, <2 x i16>, i64)

declare <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32>, <2 x i32>, i64)
declare <vscale x 8 x i32> @llvm.experimental.vector.insert.v4i32.nxv8i32(<vscale x 8 x i32>, <4 x i32>, i64)
declare <vscale x 8 x i32> @llvm.experimental.vector.insert.v8i32.nxv8i32(<vscale x 8 x i32>, <8 x i32>, i64)
