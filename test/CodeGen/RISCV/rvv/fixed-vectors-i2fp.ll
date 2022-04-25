; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+v,+zfh,+experimental-zvfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+v,+zfh,+experimental-zvfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+v,+zfh,+experimental-zvfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+v,+zfh,+experimental-zvfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define void @si2fp_v2i32_v2f32(<2 x i32>* %x, <2 x float>* %y) {
; CHECK-LABEL: si2fp_v2i32_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    vse32.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %d = sitofp <2 x i32> %a to <2 x float>
  store <2 x float> %d, <2 x float>* %y
  ret void
}

define void @ui2fp_v2i32_v2f32(<2 x i32>* %x, <2 x float>* %y) {
; CHECK-LABEL: ui2fp_v2i32_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vfcvt.f.xu.v v8, v8
; CHECK-NEXT:    vse32.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %d = uitofp <2 x i32> %a to <2 x float>
  store <2 x float> %d, <2 x float>* %y
  ret void
}

define <2 x float> @si2fp_v2i1_v2f32(<2 x i1> %x) {
; CHECK-LABEL: si2fp_v2i1_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, -1, v0
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %z = sitofp <2 x i1> %x to <2 x float>
  ret <2 x float> %z
}

define <2 x float> @ui2fp_v2i1_v2f32(<2 x i1> %x) {
; CHECK-LABEL: ui2fp_v2i1_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vfcvt.f.xu.v v8, v8
; CHECK-NEXT:    ret
  %z = uitofp <2 x i1> %x to <2 x float>
  ret <2 x float> %z
}

define void @si2fp_v8i32_v8f32(<8 x i32>* %x, <8 x float>* %y) {
; LMULMAX8-LABEL: si2fp_v8i32_v8f32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX8-NEXT:    vle32.v v8, (a0)
; LMULMAX8-NEXT:    vfcvt.f.x.v v8, v8
; LMULMAX8-NEXT:    vse32.v v8, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: si2fp_v8i32_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    addi a2, a0, 16
; LMULMAX1-NEXT:    vle32.v v8, (a2)
; LMULMAX1-NEXT:    vle32.v v9, (a0)
; LMULMAX1-NEXT:    vfcvt.f.x.v v8, v8
; LMULMAX1-NEXT:    vfcvt.f.x.v v9, v9
; LMULMAX1-NEXT:    vse32.v v9, (a1)
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vse32.v v8, (a0)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %d = sitofp <8 x i32> %a to <8 x float>
  store <8 x float> %d, <8 x float>* %y
  ret void
}

define void @ui2fp_v8i32_v8f32(<8 x i32>* %x, <8 x float>* %y) {
; LMULMAX8-LABEL: ui2fp_v8i32_v8f32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX8-NEXT:    vle32.v v8, (a0)
; LMULMAX8-NEXT:    vfcvt.f.xu.v v8, v8
; LMULMAX8-NEXT:    vse32.v v8, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: ui2fp_v8i32_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    addi a2, a0, 16
; LMULMAX1-NEXT:    vle32.v v8, (a2)
; LMULMAX1-NEXT:    vle32.v v9, (a0)
; LMULMAX1-NEXT:    vfcvt.f.xu.v v8, v8
; LMULMAX1-NEXT:    vfcvt.f.xu.v v9, v9
; LMULMAX1-NEXT:    vse32.v v9, (a1)
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vse32.v v8, (a0)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %d = uitofp <8 x i32> %a to <8 x float>
  store <8 x float> %d, <8 x float>* %y
  ret void
}

define <8 x float> @si2fp_v8i1_v8f32(<8 x i1> %x) {
; LMULMAX8-LABEL: si2fp_v8i1_v8f32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX8-NEXT:    vmv.v.i v8, 0
; LMULMAX8-NEXT:    vmerge.vim v8, v8, -1, v0
; LMULMAX8-NEXT:    vfcvt.f.x.v v8, v8
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: si2fp_v8i1_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v9, 0
; LMULMAX1-NEXT:    vmerge.vim v8, v9, -1, v0
; LMULMAX1-NEXT:    vfcvt.f.x.v v8, v8
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v10, 0
; LMULMAX1-NEXT:    vmerge.vim v10, v10, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v10, v10, 4
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v10, 0
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v9, v9, -1, v0
; LMULMAX1-NEXT:    vfcvt.f.x.v v9, v9
; LMULMAX1-NEXT:    ret
  %z = sitofp <8 x i1> %x to <8 x float>
  ret <8 x float> %z
}

define <8 x float> @ui2fp_v8i1_v8f32(<8 x i1> %x) {
; LMULMAX8-LABEL: ui2fp_v8i1_v8f32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX8-NEXT:    vmv.v.i v8, 0
; LMULMAX8-NEXT:    vmerge.vim v8, v8, 1, v0
; LMULMAX8-NEXT:    vfcvt.f.xu.v v8, v8
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: ui2fp_v8i1_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v9, 0
; LMULMAX1-NEXT:    vmerge.vim v8, v9, 1, v0
; LMULMAX1-NEXT:    vfcvt.f.xu.v v8, v8
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v10, 0
; LMULMAX1-NEXT:    vmerge.vim v10, v10, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v10, v10, 4
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v10, 0
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v9, v9, 1, v0
; LMULMAX1-NEXT:    vfcvt.f.xu.v v9, v9
; LMULMAX1-NEXT:    ret
  %z = uitofp <8 x i1> %x to <8 x float>
  ret <8 x float> %z
}

define void @si2fp_v2i16_v2f64(<2 x i16>* %x, <2 x double>* %y) {
; CHECK-LABEL: si2fp_v2i16_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; CHECK-NEXT:    vsext.vf4 v9, v8
; CHECK-NEXT:    vfcvt.f.x.v v8, v9
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x i16>, <2 x i16>* %x
  %d = sitofp <2 x i16> %a to <2 x double>
  store <2 x double> %d, <2 x double>* %y
  ret void
}

define void @ui2fp_v2i16_v2f64(<2 x i16>* %x, <2 x double>* %y) {
; CHECK-LABEL: ui2fp_v2i16_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; CHECK-NEXT:    vzext.vf4 v9, v8
; CHECK-NEXT:    vfcvt.f.xu.v v8, v9
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x i16>, <2 x i16>* %x
  %d = uitofp <2 x i16> %a to <2 x double>
  store <2 x double> %d, <2 x double>* %y
  ret void
}

define void @si2fp_v8i16_v8f64(<8 x i16>* %x, <8 x double>* %y) {
; LMULMAX8-LABEL: si2fp_v8i16_v8f64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX8-NEXT:    vle16.v v8, (a0)
; LMULMAX8-NEXT:    vsetvli zero, zero, e64, m4, ta, mu
; LMULMAX8-NEXT:    vsext.vf4 v12, v8
; LMULMAX8-NEXT:    vfcvt.f.x.v v8, v12
; LMULMAX8-NEXT:    vse64.v v8, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: si2fp_v8i16_v8f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vle16.v v8, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v9, v8, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vsext.vf4 v10, v9
; LMULMAX1-NEXT:    vfcvt.f.x.v v9, v10
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v10, v8, 4
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v11, v10, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vsext.vf4 v12, v11
; LMULMAX1-NEXT:    vfcvt.f.x.v v11, v12
; LMULMAX1-NEXT:    vsext.vf4 v12, v10
; LMULMAX1-NEXT:    vfcvt.f.x.v v10, v12
; LMULMAX1-NEXT:    vsext.vf4 v12, v8
; LMULMAX1-NEXT:    vfcvt.f.x.v v8, v12
; LMULMAX1-NEXT:    addi a0, a1, 32
; LMULMAX1-NEXT:    vse64.v v10, (a0)
; LMULMAX1-NEXT:    vse64.v v8, (a1)
; LMULMAX1-NEXT:    addi a0, a1, 48
; LMULMAX1-NEXT:    vse64.v v11, (a0)
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vse64.v v9, (a0)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %x
  %d = sitofp <8 x i16> %a to <8 x double>
  store <8 x double> %d, <8 x double>* %y
  ret void
}

define void @ui2fp_v8i16_v8f64(<8 x i16>* %x, <8 x double>* %y) {
; LMULMAX8-LABEL: ui2fp_v8i16_v8f64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX8-NEXT:    vle16.v v8, (a0)
; LMULMAX8-NEXT:    vsetvli zero, zero, e64, m4, ta, mu
; LMULMAX8-NEXT:    vzext.vf4 v12, v8
; LMULMAX8-NEXT:    vfcvt.f.xu.v v8, v12
; LMULMAX8-NEXT:    vse64.v v8, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: ui2fp_v8i16_v8f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vle16.v v8, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v9, v8, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vzext.vf4 v10, v9
; LMULMAX1-NEXT:    vfcvt.f.xu.v v9, v10
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v10, v8, 4
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v11, v10, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vzext.vf4 v12, v11
; LMULMAX1-NEXT:    vfcvt.f.xu.v v11, v12
; LMULMAX1-NEXT:    vzext.vf4 v12, v10
; LMULMAX1-NEXT:    vfcvt.f.xu.v v10, v12
; LMULMAX1-NEXT:    vzext.vf4 v12, v8
; LMULMAX1-NEXT:    vfcvt.f.xu.v v8, v12
; LMULMAX1-NEXT:    addi a0, a1, 32
; LMULMAX1-NEXT:    vse64.v v10, (a0)
; LMULMAX1-NEXT:    vse64.v v8, (a1)
; LMULMAX1-NEXT:    addi a0, a1, 48
; LMULMAX1-NEXT:    vse64.v v11, (a0)
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vse64.v v9, (a0)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %x
  %d = uitofp <8 x i16> %a to <8 x double>
  store <8 x double> %d, <8 x double>* %y
  ret void
}

define <8 x double> @si2fp_v8i1_v8f64(<8 x i1> %x) {
; LMULMAX8-LABEL: si2fp_v8i1_v8f64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; LMULMAX8-NEXT:    vmv.v.i v8, 0
; LMULMAX8-NEXT:    vmerge.vim v8, v8, -1, v0
; LMULMAX8-NEXT:    vfcvt.f.x.v v8, v8
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: si2fp_v8i1_v8f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vmv1r.v v10, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v11, 0
; LMULMAX1-NEXT:    vmerge.vim v8, v11, -1, v0
; LMULMAX1-NEXT:    vfcvt.f.x.v v8, v8
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v12, 0
; LMULMAX1-NEXT:    vmerge.vim v9, v12, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v9, v9, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v9, 0
; LMULMAX1-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v9, v11, -1, v0
; LMULMAX1-NEXT:    vfcvt.f.x.v v9, v9
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v13, 0
; LMULMAX1-NEXT:    vmv1r.v v0, v10
; LMULMAX1-NEXT:    vmerge.vim v10, v13, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v10, v10, 4
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v10, 0
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v10, v11, -1, v0
; LMULMAX1-NEXT:    vfcvt.f.x.v v10, v10
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v12, v12, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v12, v12, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v12, 0
; LMULMAX1-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v11, v11, -1, v0
; LMULMAX1-NEXT:    vfcvt.f.x.v v11, v11
; LMULMAX1-NEXT:    ret
  %z = sitofp <8 x i1> %x to <8 x double>
  ret <8 x double> %z
}

define <8 x double> @ui2fp_v8i1_v8f64(<8 x i1> %x) {
; LMULMAX8-LABEL: ui2fp_v8i1_v8f64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; LMULMAX8-NEXT:    vmv.v.i v8, 0
; LMULMAX8-NEXT:    vmerge.vim v8, v8, 1, v0
; LMULMAX8-NEXT:    vfcvt.f.xu.v v8, v8
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: ui2fp_v8i1_v8f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vmv1r.v v10, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v11, 0
; LMULMAX1-NEXT:    vmerge.vim v8, v11, 1, v0
; LMULMAX1-NEXT:    vfcvt.f.xu.v v8, v8
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v12, 0
; LMULMAX1-NEXT:    vmerge.vim v9, v12, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v9, v9, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v9, 0
; LMULMAX1-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v9, v11, 1, v0
; LMULMAX1-NEXT:    vfcvt.f.xu.v v9, v9
; LMULMAX1-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v13, 0
; LMULMAX1-NEXT:    vmv1r.v v0, v10
; LMULMAX1-NEXT:    vmerge.vim v10, v13, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v10, v10, 4
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v10, 0
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v10, v11, 1, v0
; LMULMAX1-NEXT:    vfcvt.f.xu.v v10, v10
; LMULMAX1-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v12, v12, 1, v0
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf4, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v12, v12, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; LMULMAX1-NEXT:    vmsne.vi v0, v12, 0
; LMULMAX1-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; LMULMAX1-NEXT:    vmerge.vim v11, v11, 1, v0
; LMULMAX1-NEXT:    vfcvt.f.xu.v v11, v11
; LMULMAX1-NEXT:    ret
  %z = uitofp <8 x i1> %x to <8 x double>
  ret <8 x double> %z
}

define void @si2fp_v2i64_v2f16(<2 x i64>* %x, <2 x half>* %y) {
; CHECK-LABEL: si2fp_v2i64_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vfncvt.f.x.w v9, v8
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vfncvt.f.f.w v8, v9
; CHECK-NEXT:    vse16.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x i64>, <2 x i64>* %x
  %d = sitofp <2 x i64> %a to <2 x half>
  store <2 x half> %d, <2 x half>* %y
  ret void
}

define void @ui2fp_v2i64_v2f16(<2 x i64>* %x, <2 x half>* %y) {
; CHECK-LABEL: ui2fp_v2i64_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vfncvt.f.xu.w v9, v8
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vfncvt.f.f.w v8, v9
; CHECK-NEXT:    vse16.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x i64>, <2 x i64>* %x
  %d = uitofp <2 x i64> %a to <2 x half>
  store <2 x half> %d, <2 x half>* %y
  ret void
}

define <2 x half> @si2fp_v2i1_v2f16(<2 x i1> %x) {
; CHECK-LABEL: si2fp_v2i1_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, -1, v0
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %z = sitofp <2 x i1> %x to <2 x half>
  ret <2 x half> %z
}

define <2 x half> @ui2fp_v2i1_v2f16(<2 x i1> %x) {
; CHECK-LABEL: ui2fp_v2i1_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vfcvt.f.xu.v v8, v8
; CHECK-NEXT:    ret
  %z = uitofp <2 x i1> %x to <2 x half>
  ret <2 x half> %z
}

define void @si2fp_v8i64_v8f16(<8 x i64>* %x, <8 x half>* %y) {
; LMULMAX8-LABEL: si2fp_v8i64_v8f16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; LMULMAX8-NEXT:    vle64.v v8, (a0)
; LMULMAX8-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; LMULMAX8-NEXT:    vfncvt.f.x.w v12, v8
; LMULMAX8-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; LMULMAX8-NEXT:    vfncvt.f.f.w v8, v12
; LMULMAX8-NEXT:    vse16.v v8, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: si2fp_v8i64_v8f16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi a2, a0, 48
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vle64.v v8, (a2)
; LMULMAX1-NEXT:    addi a2, a0, 32
; LMULMAX1-NEXT:    vle64.v v9, (a2)
; LMULMAX1-NEXT:    vle64.v v10, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle64.v v11, (a0)
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.x.w v12, v10
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v10, v12
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.x.w v12, v11
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v11, v12
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslideup.vi v10, v11, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.x.w v11, v9
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v9, v11
; LMULMAX1-NEXT:    vsetivli zero, 6, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslideup.vi v10, v9, 4
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.x.w v9, v8
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v8, v9
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslideup.vi v10, v8, 6
; LMULMAX1-NEXT:    vse16.v v10, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %x
  %d = sitofp <8 x i64> %a to <8 x half>
  store <8 x half> %d, <8 x half>* %y
  ret void
}

define void @ui2fp_v8i64_v8f16(<8 x i64>* %x, <8 x half>* %y) {
; LMULMAX8-LABEL: ui2fp_v8i64_v8f16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; LMULMAX8-NEXT:    vle64.v v8, (a0)
; LMULMAX8-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; LMULMAX8-NEXT:    vfncvt.f.xu.w v12, v8
; LMULMAX8-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; LMULMAX8-NEXT:    vfncvt.f.f.w v8, v12
; LMULMAX8-NEXT:    vse16.v v8, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: ui2fp_v8i64_v8f16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi a2, a0, 48
; LMULMAX1-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; LMULMAX1-NEXT:    vle64.v v8, (a2)
; LMULMAX1-NEXT:    addi a2, a0, 32
; LMULMAX1-NEXT:    vle64.v v9, (a2)
; LMULMAX1-NEXT:    vle64.v v10, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle64.v v11, (a0)
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.xu.w v12, v10
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v10, v12
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.xu.w v12, v11
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v11, v12
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslideup.vi v10, v11, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.xu.w v11, v9
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v9, v11
; LMULMAX1-NEXT:    vsetivli zero, 6, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslideup.vi v10, v9, 4
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.xu.w v9, v8
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v8, v9
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslideup.vi v10, v8, 6
; LMULMAX1-NEXT:    vse16.v v10, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x i64>, <8 x i64>* %x
  %d = uitofp <8 x i64> %a to <8 x half>
  store <8 x half> %d, <8 x half>* %y
  ret void
}

define <8 x half> @si2fp_v8i1_v8f16(<8 x i1> %x) {
; CHECK-LABEL: si2fp_v8i1_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, -1, v0
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %z = sitofp <8 x i1> %x to <8 x half>
  ret <8 x half> %z
}

define <8 x half> @ui2fp_v8i1_v8f16(<8 x i1> %x) {
; CHECK-LABEL: ui2fp_v8i1_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vfcvt.f.xu.v v8, v8
; CHECK-NEXT:    ret
  %z = uitofp <8 x i1> %x to <8 x half>
  ret <8 x half> %z
}
