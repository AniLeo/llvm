; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1-RV32
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1-RV64

define void @load_store_v1i1(<1 x i1>* %x, <1 x i1>* %y) {
; CHECK-LABEL: load_store_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, mu
; CHECK-NEXT:    vlm.v v0, (a0)
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <1 x i1>, <1 x i1>* %x
  store <1 x i1> %a, <1 x i1>* %y
  ret void
}

define void @load_store_v2i1(<2 x i1>* %x, <2 x i1>* %y) {
; CHECK-LABEL: load_store_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vlm.v v0, (a0)
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x i1>, <2 x i1>* %x
  store <2 x i1> %a, <2 x i1>* %y
  ret void
}

define void @load_store_v4i1(<4 x i1>* %x, <4 x i1>* %y) {
; CHECK-LABEL: load_store_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vlm.v v0, (a0)
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf2, tu, mu
; CHECK-NEXT:    vslideup.vi v9, v8, 0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <4 x i1>, <4 x i1>* %x
  store <4 x i1> %a, <4 x i1>* %y
  ret void
}

define void @load_store_v8i1(<8 x i1>* %x, <8 x i1>* %y) {
; CHECK-LABEL: load_store_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vlm.v v8, (a0)
; CHECK-NEXT:    vsm.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <8 x i1>, <8 x i1>* %x
  store <8 x i1> %a, <8 x i1>* %y
  ret void
}

define void @load_store_v16i1(<16 x i1>* %x, <16 x i1>* %y) {
; CHECK-LABEL: load_store_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vlm.v v8, (a0)
; CHECK-NEXT:    vsm.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <16 x i1>, <16 x i1>* %x
  store <16 x i1> %a, <16 x i1>* %y
  ret void
}

define void @load_store_v32i1(<32 x i1>* %x, <32 x i1>* %y) {
; LMULMAX2-LABEL: load_store_v32i1:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    li a2, 32
; LMULMAX2-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; LMULMAX2-NEXT:    vlm.v v8, (a0)
; LMULMAX2-NEXT:    vsm.v v8, (a1)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-RV32-LABEL: load_store_v32i1:
; LMULMAX1-RV32:       # %bb.0:
; LMULMAX1-RV32-NEXT:    lw a0, 0(a0)
; LMULMAX1-RV32-NEXT:    sw a0, 0(a1)
; LMULMAX1-RV32-NEXT:    ret
;
; LMULMAX1-RV64-LABEL: load_store_v32i1:
; LMULMAX1-RV64:       # %bb.0:
; LMULMAX1-RV64-NEXT:    lw a0, 0(a0)
; LMULMAX1-RV64-NEXT:    sw a0, 0(a1)
; LMULMAX1-RV64-NEXT:    ret
  %a = load <32 x i1>, <32 x i1>* %x
  store <32 x i1> %a, <32 x i1>* %y
  ret void
}
