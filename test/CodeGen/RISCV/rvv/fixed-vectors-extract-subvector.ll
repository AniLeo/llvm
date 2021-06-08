; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define void @extract_v2i8_v4i8_0(<4 x i8>* %x, <2 x i8>* %y) {
; CHECK-LABEL: extract_v2i8_v4i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v25, (a1)
; CHECK-NEXT:    ret
  %a = load <4 x i8>, <4 x i8>* %x
  %c = call <2 x i8> @llvm.experimental.vector.extract.v2i8.v4i8(<4 x i8> %a, i64 0)
  store <2 x i8> %c, <2 x i8>* %y
  ret void
}

define void @extract_v2i8_v4i8_2(<4 x i8>* %x, <2 x i8>* %y) {
; CHECK-LABEL: extract_v2i8_v4i8_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v25, 2
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v25, (a1)
; CHECK-NEXT:    ret
  %a = load <4 x i8>, <4 x i8>* %x
  %c = call <2 x i8> @llvm.experimental.vector.extract.v2i8.v4i8(<4 x i8> %a, i64 2)
  store <2 x i8> %c, <2 x i8>* %y
  ret void
}

define void @extract_v2i8_v8i8_0(<8 x i8>* %x, <2 x i8>* %y) {
; CHECK-LABEL: extract_v2i8_v8i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v25, (a1)
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %c = call <2 x i8> @llvm.experimental.vector.extract.v2i8.v8i8(<8 x i8> %a, i64 0)
  store <2 x i8> %c, <2 x i8>* %y
  ret void
}

define void @extract_v2i8_v8i8_6(<8 x i8>* %x, <2 x i8>* %y) {
; CHECK-LABEL: extract_v2i8_v8i8_6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v25, 6
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v25, (a1)
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %c = call <2 x i8> @llvm.experimental.vector.extract.v2i8.v8i8(<8 x i8> %a, i64 6)
  store <2 x i8> %c, <2 x i8>* %y
  ret void
}

define void @extract_v2i32_v8i32_0(<8 x i32>* %x, <2 x i32>* %y) {
; LMULMAX2-LABEL: extract_v2i32_v8i32_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v26, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX2-NEXT:    vse32.v v26, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v2i32_v8i32_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %c = call <2 x i32> @llvm.experimental.vector.extract.v2i32.v8i32(<8 x i32> %a, i64 0)
  store <2 x i32> %c, <2 x i32>* %y
  ret void
}

define void @extract_v2i32_v8i32_2(<8 x i32>* %x, <2 x i32>* %y) {
; LMULMAX2-LABEL: extract_v2i32_v8i32_2:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v26, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, m2, ta, mu
; LMULMAX2-NEXT:    vslidedown.vi v26, v26, 2
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX2-NEXT:    vse32.v v26, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v2i32_v8i32_2:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v25, v25, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %c = call <2 x i32> @llvm.experimental.vector.extract.v2i32.v8i32(<8 x i32> %a, i64 2)
  store <2 x i32> %c, <2 x i32>* %y
  ret void
}

define void @extract_v2i32_v8i32_6(<8 x i32>* %x, <2 x i32>* %y) {
; LMULMAX2-LABEL: extract_v2i32_v8i32_6:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vle32.v v26, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, m2, ta, mu
; LMULMAX2-NEXT:    vslidedown.vi v26, v26, 6
; LMULMAX2-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX2-NEXT:    vse32.v v26, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v2i32_v8i32_6:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v25, v25, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %c = call <2 x i32> @llvm.experimental.vector.extract.v2i32.v8i32(<8 x i32> %a, i64 6)
  store <2 x i32> %c, <2 x i32>* %y
  ret void
}

define void @extract_v2i32_nxv16i32_0(<vscale x 16 x i32> %x, <2 x i32>* %y) {
; CHECK-LABEL: extract_v2i32_nxv16i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i32> @llvm.experimental.vector.extract.v2i32.nxv16i32(<vscale x 16 x i32> %x, i64 0)
  store <2 x i32> %c, <2 x i32>* %y
  ret void
}

define void @extract_v2i32_nxv16i32_8(<vscale x 16 x i32> %x, <2 x i32>* %y) {
; CHECK-LABEL: extract_v2i32_nxv16i32_8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, m8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 6
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i32> @llvm.experimental.vector.extract.v2i32.nxv16i32(<vscale x 16 x i32> %x, i64 6)
  store <2 x i32> %c, <2 x i32>* %y
  ret void
}

define void @extract_v2i8_nxv2i8_0(<vscale x 2 x i8> %x, <2 x i8>* %y) {
; CHECK-LABEL: extract_v2i8_nxv2i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v8, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i8> @llvm.experimental.vector.extract.v2i8.nxv2i8(<vscale x 2 x i8> %x, i64 0)
  store <2 x i8> %c, <2 x i8>* %y
  ret void
}

define void @extract_v2i8_nxv2i8_2(<vscale x 2 x i8> %x, <2 x i8>* %y) {
; CHECK-LABEL: extract_v2i8_nxv2i8_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v8, 2
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vse8.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i8> @llvm.experimental.vector.extract.v2i8.nxv2i8(<vscale x 2 x i8> %x, i64 2)
  store <2 x i8> %c, <2 x i8>* %y
  ret void
}

define void @extract_v8i32_nxv16i32_8(<vscale x 16 x i32> %x, <8 x i32>* %y) {
; LMULMAX2-LABEL: extract_v8i32_nxv16i32_8:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m8, ta, mu
; LMULMAX2-NEXT:    vslidedown.vi v8, v8, 8
; LMULMAX2-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX2-NEXT:    vse32.v v8, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v8i32_nxv16i32_8:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m8, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v16, v8, 8
; LMULMAX1-NEXT:    vslidedown.vi v8, v8, 12
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vse32.v v8, (a1)
; LMULMAX1-NEXT:    vse32.v v16, (a0)
; LMULMAX1-NEXT:    ret
  %c = call <8 x i32> @llvm.experimental.vector.extract.v8i32.nxv16i32(<vscale x 16 x i32> %x, i64 8)
  store <8 x i32> %c, <8 x i32>* %y
  ret void
}

define void @extract_v8i1_v64i1_0(<64 x i1>* %x, <8 x i1>* %y) {
; LMULMAX2-LABEL: extract_v8i1_v64i1_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vle1.v v25, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vse1.v v25, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v8i1_v64i1_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vle1.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vse1.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <64 x i1>, <64 x i1>* %x
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.v64i1(<64 x i1> %a, i64 0)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

define void @extract_v8i1_v64i1_8(<64 x i1>* %x, <8 x i1>* %y) {
; LMULMAX2-LABEL: extract_v8i1_v64i1_8:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vle1.v v25, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 1, e8, mf4, ta, mu
; LMULMAX2-NEXT:    vslidedown.vi v25, v25, 1
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vse1.v v25, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v8i1_v64i1_8:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vle1.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 1, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v25, v25, 1
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vse1.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <64 x i1>, <64 x i1>* %x
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.v64i1(<64 x i1> %a, i64 8)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

define void @extract_v8i1_v64i1_48(<64 x i1>* %x, <8 x i1>* %y) {
; LMULMAX2-LABEL: extract_v8i1_v64i1_48:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a0, a0, 4
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vle1.v v25, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 1, e8, mf4, ta, mu
; LMULMAX2-NEXT:    vslidedown.vi v25, v25, 2
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vse1.v v25, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v8i1_v64i1_48:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi a0, a0, 6
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vle1.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vse1.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <64 x i1>, <64 x i1>* %x
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.v64i1(<64 x i1> %a, i64 48)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

define void @extract_v8i1_nxv2i1_0(<vscale x 2 x i1> %x, <8 x i1>* %y) {
; CHECK-LABEL: extract_v8i1_nxv2i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vse1.v v0, (a0)
; CHECK-NEXT:    ret
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv2i1(<vscale x 2 x i1> %x, i64 0)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

define void @extract_v8i1_nxv2i1_2(<vscale x 2 x i1> %x, <8 x i1>* %y) {
; CHECK-LABEL: extract_v8i1_nxv2i1_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v25, 2
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v25, v25, 0
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv2i1(<vscale x 2 x i1> %x, i64 2)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

define void @extract_v8i1_nxv64i1_0(<vscale x 64 x i1> %x, <8 x i1>* %y) {
; CHECK-LABEL: extract_v8i1_nxv64i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vse1.v v0, (a0)
; CHECK-NEXT:    ret
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv64i1(<vscale x 64 x i1> %x, i64 0)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

define void @extract_v8i1_nxv64i1_8(<vscale x 64 x i1> %x, <8 x i1>* %y) {
; CHECK-LABEL: extract_v8i1_nxv64i1_8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v0, 1
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv64i1(<vscale x 64 x i1> %x, i64 8)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

define void @extract_v8i1_nxv64i1_48(<vscale x 64 x i1> %x, <8 x i1>* %y) {
; CHECK-LABEL: extract_v8i1_nxv64i1_48:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v0, 6
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv64i1(<vscale x 64 x i1> %x, i64 48)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}


define void @extract_v2i1_v64i1_0(<64 x i1>* %x, <2 x i1>* %y) {
; LMULMAX2-LABEL: extract_v2i1_v64i1_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vle1.v v0, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX2-NEXT:    vmv.v.i v25, 0
; LMULMAX2-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v26, v25, 0
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vmsne.vi v25, v26, 0
; LMULMAX2-NEXT:    vse1.v v25, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v2i1_v64i1_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vle1.v v0, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v26, 0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v26, v25, 0
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v25, v26, 0
; LMULMAX1-NEXT:    vse1.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <64 x i1>, <64 x i1>* %x
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.v64i1(<64 x i1> %a, i64 0)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_v64i1_2(<64 x i1>* %x, <2 x i1>* %y) {
; LMULMAX2-LABEL: extract_v2i1_v64i1_2:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vle1.v v0, (a0)
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vmerge.vim v26, v26, 1, v0
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vslidedown.vi v26, v26, 2
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX2-NEXT:    vmsne.vi v0, v26, 0
; LMULMAX2-NEXT:    vmv.v.i v25, 0
; LMULMAX2-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v26, v25, 0
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vmsne.vi v25, v26, 0
; LMULMAX2-NEXT:    vse1.v v25, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v2i1_v64i1_2:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vle1.v v0, (a0)
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v25, v25, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v25, 0
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v26, 0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v26, v25, 0
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v25, v26, 0
; LMULMAX1-NEXT:    vse1.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <64 x i1>, <64 x i1>* %x
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.v64i1(<64 x i1> %a, i64 2)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_v64i1_42(<64 x i1>* %x, <2 x i1>* %y) {
; LMULMAX2-LABEL: extract_v2i1_v64i1_42:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    addi a0, a0, 4
; LMULMAX2-NEXT:    addi a2, zero, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vle1.v v0, (a0)
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vmerge.vim v26, v26, 1, v0
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vslidedown.vi v26, v26, 10
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX2-NEXT:    vmsne.vi v0, v26, 0
; LMULMAX2-NEXT:    vmv.v.i v25, 0
; LMULMAX2-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; LMULMAX2-NEXT:    vslideup.vi v26, v25, 0
; LMULMAX2-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX2-NEXT:    vmsne.vi v25, v26, 0
; LMULMAX2-NEXT:    vse1.v v25, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: extract_v2i1_v64i1_42:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi a0, a0, 4
; LMULMAX1-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; LMULMAX1-NEXT:    vle1.v v0, (a0)
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v25, v25, 10
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v25, 0
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    vmerge.vim v25, v25, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v26, 0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v26, v25, 0
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v25, v26, 0
; LMULMAX1-NEXT:    vse1.v v25, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <64 x i1>, <64 x i1>* %x
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.v64i1(<64 x i1> %a, i64 42)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_nxv2i1_0(<vscale x 2 x i1> %x, <2 x i1>* %y) {
; CHECK-LABEL: extract_v2i1_nxv2i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v25, v26, 0
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv2i1(<vscale x 2 x i1> %x, i64 0)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_nxv2i1_2(<vscale x 2 x i1> %x, <2 x i1>* %y) {
; CHECK-LABEL: extract_v2i1_nxv2i1_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v25, 2
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vmsne.vi v0, v25, 0
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v25, v26, 0
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv2i1(<vscale x 2 x i1> %x, i64 2)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_nxv64i1_0(<vscale x 64 x i1> %x, <2 x i1>* %y) {
; CHECK-LABEL: extract_v2i1_nxv64i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v25, v26, 0
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv64i1(<vscale x 64 x i1> %x, i64 0)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_nxv64i1_2(<vscale x 64 x i1> %x, <2 x i1>* %y) {
; CHECK-LABEL: extract_v2i1_nxv64i1_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 2, e8, m8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v25, v26, 0
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv64i1(<vscale x 64 x i1> %x, i64 2)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_nxv64i1_42(<vscale x 64 x i1> %x, <2 x i1>* %y) {
; CHECK-LABEL: extract_v2i1_nxv64i1_42:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    addi a1, zero, 42
; CHECK-NEXT:    vsetivli zero, 2, e8, m8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v25, v26, 0
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv64i1(<vscale x 64 x i1> %x, i64 42)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v2i1_nxv32i1_26(<vscale x 32 x i1> %x, <2 x i1>* %y) {
; CHECK-LABEL: extract_v2i1_nxv32i1_26:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, mu
; CHECK-NEXT:    vmv.v.i v28, 0
; CHECK-NEXT:    vmerge.vim v28, v28, 1, v0
; CHECK-NEXT:    vsetivli zero, 2, e8, m4, ta, mu
; CHECK-NEXT:    vslidedown.vi v28, v28, 26
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vmsne.vi v0, v28, 0
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v25, v26, 0
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv32i1(<vscale x 32 x i1> %x, i64 26)
  store <2 x i1> %c, <2 x i1>* %y
  ret void
}

define void @extract_v8i1_nxv32i1_16(<vscale x 32 x i1> %x, <8 x i1>* %y) {
; CHECK-LABEL: extract_v8i1_nxv32i1_16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vi v25, v0, 2
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vse1.v v25, (a0)
; CHECK-NEXT:    ret
  %c = call <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv32i1(<vscale x 32 x i1> %x, i64 16)
  store <8 x i1> %c, <8 x i1>* %y
  ret void
}

declare <2 x i1> @llvm.experimental.vector.extract.v2i1.v64i1(<64 x i1> %vec, i64 %idx)
declare <8 x i1> @llvm.experimental.vector.extract.v8i1.v64i1(<64 x i1> %vec, i64 %idx)

declare <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv2i1(<vscale x 2 x i1> %vec, i64 %idx)
declare <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv2i1(<vscale x 2 x i1> %vec, i64 %idx)

declare <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv32i1(<vscale x 32 x i1> %vec, i64 %idx)
declare <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv32i1(<vscale x 32 x i1> %vec, i64 %idx)

declare <2 x i1> @llvm.experimental.vector.extract.v2i1.nxv64i1(<vscale x 64 x i1> %vec, i64 %idx)
declare <8 x i1> @llvm.experimental.vector.extract.v8i1.nxv64i1(<vscale x 64 x i1> %vec, i64 %idx)

declare <2 x i8> @llvm.experimental.vector.extract.v2i8.v4i8(<4 x i8> %vec, i64 %idx)
declare <2 x i8> @llvm.experimental.vector.extract.v2i8.v8i8(<8 x i8> %vec, i64 %idx)
declare <2 x i32> @llvm.experimental.vector.extract.v2i32.v8i32(<8 x i32> %vec, i64 %idx)

declare <2 x i8> @llvm.experimental.vector.extract.v2i8.nxv2i8(<vscale x 2 x i8> %vec, i64 %idx)

declare <2 x i32> @llvm.experimental.vector.extract.v2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 %idx)
declare <8 x i32> @llvm.experimental.vector.extract.v8i32.nxv16i32(<vscale x 16 x i32> %vec, i64 %idx)
