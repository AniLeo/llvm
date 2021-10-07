; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define void @fpext_v2f16_v2f32(<2 x half>* %x, <2 x float>* %y) {
; CHECK-LABEL: fpext_v2f16_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8
; CHECK-NEXT:    vse32.v v9, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x half>, <2 x half>* %x
  %d = fpext <2 x half> %a to <2 x float>
  store <2 x float> %d, <2 x float>* %y
  ret void
}

define void @fpext_v2f16_v2f64(<2 x half>* %x, <2 x double>* %y) {
; CHECK-LABEL: fpext_v2f16_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vfwcvt.f.f.v v8, v9
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x half>, <2 x half>* %x
  %d = fpext <2 x half> %a to <2 x double>
  store <2 x double> %d, <2 x double>* %y
  ret void
}

define void @fpext_v8f16_v8f32(<8 x half>* %x, <8 x float>* %y) {
; LMULMAX8-LABEL: fpext_v8f16_v8f32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX8-NEXT:    vle16.v v8, (a0)
; LMULMAX8-NEXT:    vfwcvt.f.f.v v10, v8
; LMULMAX8-NEXT:    vse32.v v10, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpext_v8f16_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vle16.v v8, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v9, v8, 4
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v10, v9
; LMULMAX1-NEXT:    vfwcvt.f.f.v v9, v8
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vse32.v v10, (a0)
; LMULMAX1-NEXT:    vse32.v v9, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x half>, <8 x half>* %x
  %d = fpext <8 x half> %a to <8 x float>
  store <8 x float> %d, <8 x float>* %y
  ret void
}

define void @fpext_v8f16_v8f64(<8 x half>* %x, <8 x double>* %y) {
; LMULMAX8-LABEL: fpext_v8f16_v8f64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX8-NEXT:    vle16.v v8, (a0)
; LMULMAX8-NEXT:    vfwcvt.f.f.v v10, v8
; LMULMAX8-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; LMULMAX8-NEXT:    vfwcvt.f.f.v v12, v10
; LMULMAX8-NEXT:    vse64.v v12, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpext_v8f16_v8f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vle16.v v8, (a0)
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v9, v8, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v10, v9
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v9, v10
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v10, v8, 4
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vslidedown.vi v11, v10, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v12, v11
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v11, v12
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v12, v10
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v10, v12
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v12, v8
; LMULMAX1-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v8, v12
; LMULMAX1-NEXT:    addi a0, a1, 32
; LMULMAX1-NEXT:    vse64.v v10, (a0)
; LMULMAX1-NEXT:    vse64.v v8, (a1)
; LMULMAX1-NEXT:    addi a0, a1, 48
; LMULMAX1-NEXT:    vse64.v v11, (a0)
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vse64.v v9, (a0)
; LMULMAX1-NEXT:    ret
  %a = load <8 x half>, <8 x half>* %x
  %d = fpext <8 x half> %a to <8 x double>
  store <8 x double> %d, <8 x double>* %y
  ret void
}

define void @fpround_v2f32_v2f16(<2 x float>* %x, <2 x half>* %y) {
; CHECK-LABEL: fpround_v2f32_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vfncvt.f.f.w v9, v8
; CHECK-NEXT:    vse16.v v9, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x float>, <2 x float>* %x
  %d = fptrunc <2 x float> %a to <2 x half>
  store <2 x half> %d, <2 x half>* %y
  ret void
}

define void @fpround_v2f64_v2f16(<2 x double>* %x, <2 x half>* %y) {
; CHECK-LABEL: fpround_v2f64_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vfncvt.rod.f.f.w v9, v8
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vfncvt.f.f.w v8, v9
; CHECK-NEXT:    vse16.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x double>, <2 x double>* %x
  %d = fptrunc <2 x double> %a to <2 x half>
  store <2 x half> %d, <2 x half>* %y
  ret void
}

define void @fpround_v8f32_v8f16(<8 x float>* %x, <8 x half>* %y) {
; LMULMAX8-LABEL: fpround_v8f32_v8f16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; LMULMAX8-NEXT:    vle32.v v8, (a0)
; LMULMAX8-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; LMULMAX8-NEXT:    vfncvt.f.f.w v10, v8
; LMULMAX8-NEXT:    vse16.v v10, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpround_v8f32_v8f16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; LMULMAX1-NEXT:    vle32.v v8, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle32.v v9, (a0)
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v10, v8
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v8, 0
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v10, 0
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v10, v9
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v8, v10, 4
; LMULMAX1-NEXT:    vse16.v v8, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x float>, <8 x float>* %x
  %d = fptrunc <8 x float> %a to <8 x half>
  store <8 x half> %d, <8 x half>* %y
  ret void
}

define void @fpround_v8f64_v8f16(<8 x double>* %x, <8 x half>* %y) {
; LMULMAX8-LABEL: fpround_v8f64_v8f16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli zero, 8, e64, m4, ta, mu
; LMULMAX8-NEXT:    vle64.v v8, (a0)
; LMULMAX8-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; LMULMAX8-NEXT:    vfncvt.rod.f.f.w v12, v8
; LMULMAX8-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; LMULMAX8-NEXT:    vfncvt.f.f.w v8, v12
; LMULMAX8-NEXT:    vse16.v v8, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpround_v8f64_v8f16:
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
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v12, v10
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v10, v12
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; LMULMAX1-NEXT:    vmv.v.i v12, 0
; LMULMAX1-NEXT:    vsetivli zero, 2, e16, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v12, v10, 0
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v10, v11
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v11, v10
; LMULMAX1-NEXT:    vsetivli zero, 4, e16, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v12, v11, 2
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v10, v9
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v9, v10
; LMULMAX1-NEXT:    vsetivli zero, 6, e16, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v12, v9, 4
; LMULMAX1-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v9, v8
; LMULMAX1-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v8, v9
; LMULMAX1-NEXT:    vsetivli zero, 8, e16, m1, tu, mu
; LMULMAX1-NEXT:    vslideup.vi v12, v8, 6
; LMULMAX1-NEXT:    vse16.v v12, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x double>, <8 x double>* %x
  %d = fptrunc <8 x double> %a to <8 x half>
  store <8 x half> %d, <8 x half>* %y
  ret void
}
