; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=8 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX8
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define void @fpext_v2f16_v2f32(<2 x half>* %x, <2 x float>* %y) {
; CHECK-LABEL: fpext_v2f16_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 2, e16,mf4,ta,mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vfwcvt.f.f.v v26, v25
; CHECK-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; CHECK-NEXT:    vse32.v v26, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x half>, <2 x half>* %x
  %d = fpext <2 x half> %a to <2 x float>
  store <2 x float> %d, <2 x float>* %y
  ret void
}

define void @fpext_v2f16_v2f64(<2 x half>* %x, <2 x double>* %y) {
; CHECK-LABEL: fpext_v2f16_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 2, e16,mf4,ta,mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vfwcvt.f.f.v v26, v25
; CHECK-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; CHECK-NEXT:    vfwcvt.f.f.v v25, v26
; CHECK-NEXT:    vsetivli a0, 2, e64,m1,ta,mu
; CHECK-NEXT:    vse64.v v25, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x half>, <2 x half>* %x
  %d = fpext <2 x half> %a to <2 x double>
  store <2 x double> %d, <2 x double>* %y
  ret void
}

define void @fpext_v8f16_v8f32(<8 x half>* %x, <8 x float>* %y) {
; LMULMAX8-LABEL: fpext_v8f16_v8f32:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a2, 8, e16,m1,ta,mu
; LMULMAX8-NEXT:    vle16.v v25, (a0)
; LMULMAX8-NEXT:    vfwcvt.f.f.v v26, v25
; LMULMAX8-NEXT:    vsetivli a0, 8, e32,m2,ta,mu
; LMULMAX8-NEXT:    vse32.v v26, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpext_v8f16_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a2, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vle16.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 4, e16,m1,ta,mu
; LMULMAX1-NEXT:    vslidedown.vi v26, v25, 4
; LMULMAX1-NEXT:    vsetivli a0, 4, e16,mf2,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v27, v26
; LMULMAX1-NEXT:    vfwcvt.f.f.v v26, v25
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vsetivli a2, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vse32.v v27, (a0)
; LMULMAX1-NEXT:    vse32.v v26, (a1)
; LMULMAX1-NEXT:    ret
  %a = load <8 x half>, <8 x half>* %x
  %d = fpext <8 x half> %a to <8 x float>
  store <8 x float> %d, <8 x float>* %y
  ret void
}

define void @fpext_v8f16_v8f64(<8 x half>* %x, <8 x double>* %y) {
; LMULMAX8-LABEL: fpext_v8f16_v8f64:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a2, 8, e16,m1,ta,mu
; LMULMAX8-NEXT:    vle16.v v25, (a0)
; LMULMAX8-NEXT:    vfwcvt.f.f.v v26, v25
; LMULMAX8-NEXT:    vsetivli a0, 8, e32,m2,ta,mu
; LMULMAX8-NEXT:    vfwcvt.f.f.v v28, v26
; LMULMAX8-NEXT:    vsetivli a0, 8, e64,m4,ta,mu
; LMULMAX8-NEXT:    vse64.v v28, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpext_v8f16_v8f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a2, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vle16.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf2,ta,mu
; LMULMAX1-NEXT:    vslidedown.vi v26, v25, 2
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v27, v26
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v26, v27
; LMULMAX1-NEXT:    vsetivli a0, 4, e16,m1,ta,mu
; LMULMAX1-NEXT:    vslidedown.vi v27, v25, 4
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf2,ta,mu
; LMULMAX1-NEXT:    vslidedown.vi v28, v27, 2
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v29, v28
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v28, v29
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v29, v27
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v27, v29
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v29, v25
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfwcvt.f.f.v v25, v29
; LMULMAX1-NEXT:    addi a0, a1, 32
; LMULMAX1-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX1-NEXT:    vse64.v v27, (a0)
; LMULMAX1-NEXT:    vse64.v v25, (a1)
; LMULMAX1-NEXT:    addi a0, a1, 48
; LMULMAX1-NEXT:    vse64.v v28, (a0)
; LMULMAX1-NEXT:    addi a0, a1, 16
; LMULMAX1-NEXT:    vse64.v v26, (a0)
; LMULMAX1-NEXT:    ret
  %a = load <8 x half>, <8 x half>* %x
  %d = fpext <8 x half> %a to <8 x double>
  store <8 x double> %d, <8 x double>* %y
  ret void
}

define void @fpround_v2f32_v2f16(<2 x float>* %x, <2 x half>* %y) {
; CHECK-LABEL: fpround_v2f32_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 2, e32,mf2,ta,mu
; CHECK-NEXT:    vle32.v v25, (a0)
; CHECK-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; CHECK-NEXT:    vfncvt.f.f.w v26, v25
; CHECK-NEXT:    vse16.v v26, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x float>, <2 x float>* %x
  %d = fptrunc <2 x float> %a to <2 x half>
  store <2 x half> %d, <2 x half>* %y
  ret void
}

define void @fpround_v2f64_v2f16(<2 x double>* %x, <2 x half>* %y) {
; CHECK-LABEL: fpround_v2f64_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; CHECK-NEXT:    vle64.v v25, (a0)
; CHECK-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; CHECK-NEXT:    vfncvt.rod.f.f.w v26, v25
; CHECK-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; CHECK-NEXT:    vfncvt.f.f.w v25, v26
; CHECK-NEXT:    vse16.v v25, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x double>, <2 x double>* %x
  %d = fptrunc <2 x double> %a to <2 x half>
  store <2 x half> %d, <2 x half>* %y
  ret void
}

define void @fpround_v8f32_v8f16(<8 x float>* %x, <8 x half>* %y) {
; LMULMAX8-LABEL: fpround_v8f32_v8f16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a2, 8, e32,m2,ta,mu
; LMULMAX8-NEXT:    vle32.v v26, (a0)
; LMULMAX8-NEXT:    vsetivli a0, 8, e16,m1,ta,mu
; LMULMAX8-NEXT:    vfncvt.f.f.w v25, v26
; LMULMAX8-NEXT:    vse16.v v25, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpround_v8f32_v8f16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi sp, sp, -16
; LMULMAX1-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX1-NEXT:    vsetivli a2, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    addi a2, a0, 16
; LMULMAX1-NEXT:    vle32.v v25, (a2)
; LMULMAX1-NEXT:    vle32.v v26, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 4, e16,mf2,ta,mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v27, v25
; LMULMAX1-NEXT:    addi a0, sp, 8
; LMULMAX1-NEXT:    vse16.v v27, (a0)
; LMULMAX1-NEXT:    vfncvt.f.f.w v25, v26
; LMULMAX1-NEXT:    vse16.v v25, (sp)
; LMULMAX1-NEXT:    vsetivli a0, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vle16.v v25, (sp)
; LMULMAX1-NEXT:    vse16.v v25, (a1)
; LMULMAX1-NEXT:    addi sp, sp, 16
; LMULMAX1-NEXT:    ret
  %a = load <8 x float>, <8 x float>* %x
  %d = fptrunc <8 x float> %a to <8 x half>
  store <8 x half> %d, <8 x half>* %y
  ret void
}

define void @fpround_v8f64_v8f16(<8 x double>* %x, <8 x half>* %y) {
; LMULMAX8-LABEL: fpround_v8f64_v8f16:
; LMULMAX8:       # %bb.0:
; LMULMAX8-NEXT:    vsetivli a2, 8, e64,m4,ta,mu
; LMULMAX8-NEXT:    vle64.v v28, (a0)
; LMULMAX8-NEXT:    vsetivli a0, 8, e32,m2,ta,mu
; LMULMAX8-NEXT:    vfncvt.rod.f.f.w v26, v28
; LMULMAX8-NEXT:    vsetivli a0, 8, e16,m1,ta,mu
; LMULMAX8-NEXT:    vfncvt.f.f.w v25, v26
; LMULMAX8-NEXT:    vse16.v v25, (a1)
; LMULMAX8-NEXT:    ret
;
; LMULMAX1-LABEL: fpround_v8f64_v8f16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi sp, sp, -32
; LMULMAX1-NEXT:    .cfi_def_cfa_offset 32
; LMULMAX1-NEXT:    vsetivli a2, 2, e64,m1,ta,mu
; LMULMAX1-NEXT:    vle64.v v25, (a0)
; LMULMAX1-NEXT:    addi a2, a0, 32
; LMULMAX1-NEXT:    vle64.v v26, (a2)
; LMULMAX1-NEXT:    addi a2, a0, 48
; LMULMAX1-NEXT:    vle64.v v27, (a2)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle64.v v28, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v29, v27
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v27, v29
; LMULMAX1-NEXT:    addi a0, sp, 12
; LMULMAX1-NEXT:    vse16.v v27, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v27, v28
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v28, v27
; LMULMAX1-NEXT:    addi a0, sp, 4
; LMULMAX1-NEXT:    vse16.v v28, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v27, v26
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v26, v27
; LMULMAX1-NEXT:    addi a0, sp, 8
; LMULMAX1-NEXT:    vse16.v v26, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 4, e16,mf2,ta,mu
; LMULMAX1-NEXT:    addi a0, sp, 8
; LMULMAX1-NEXT:    vle16.v v26, (a0)
; LMULMAX1-NEXT:    addi a0, sp, 24
; LMULMAX1-NEXT:    vse16.v v26, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 2, e32,mf2,ta,mu
; LMULMAX1-NEXT:    vfncvt.rod.f.f.w v26, v25
; LMULMAX1-NEXT:    vsetivli a0, 2, e16,mf4,ta,mu
; LMULMAX1-NEXT:    vfncvt.f.f.w v25, v26
; LMULMAX1-NEXT:    vse16.v v25, (sp)
; LMULMAX1-NEXT:    vsetivli a0, 4, e16,mf2,ta,mu
; LMULMAX1-NEXT:    vle16.v v25, (sp)
; LMULMAX1-NEXT:    addi a0, sp, 16
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    addi a0, sp, 16
; LMULMAX1-NEXT:    vle16.v v25, (a0)
; LMULMAX1-NEXT:    vse16.v v25, (a1)
; LMULMAX1-NEXT:    addi sp, sp, 32
; LMULMAX1-NEXT:    ret
  %a = load <8 x double>, <8 x double>* %x
  %d = fptrunc <8 x double> %a to <8 x half>
  store <8 x half> %d, <8 x half>* %y
  ret void
}
