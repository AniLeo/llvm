; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple riscv32 -mattr=+experimental-v %s -o - \
; RUN:     -verify-machineinstrs | FileCheck %s
; RUN: llc -mtriple riscv64 -mattr=+experimental-v %s -o - \
; RUN:     -verify-machineinstrs | FileCheck %s

define void @vadd_vint8m1(<vscale x 8 x i8> *%pc, <vscale x 8 x i8> *%pa, <vscale x 8 x i8> *%pb) nounwind {
; CHECK-LABEL: vadd_vint8m1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl1r.v v25, (a1)
; CHECK-NEXT:    vl1r.v v26, (a2)
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vs1r.v v25, (a0)
; CHECK-NEXT:    ret
  %va = load <vscale x 8 x i8>, <vscale x 8 x i8>* %pa
  %vb = load <vscale x 8 x i8>, <vscale x 8 x i8>* %pb
  %vc = add <vscale x 8 x i8> %va, %vb
  store <vscale x 8 x i8> %vc, <vscale x 8 x i8> *%pc
  ret void
}

define void @vadd_vint8m2(<vscale x 16 x i8> *%pc, <vscale x 16 x i8> *%pa, <vscale x 16 x i8> *%pb) nounwind {
; CHECK-LABEL: vadd_vint8m2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2r.v v26, (a1)
; CHECK-NEXT:    vl2r.v v28, (a2)
; CHECK-NEXT:    vsetvli a1, zero, e8, m2, ta, mu
; CHECK-NEXT:    vadd.vv v26, v26, v28
; CHECK-NEXT:    vs2r.v v26, (a0)
; CHECK-NEXT:    ret
  %va = load <vscale x 16 x i8>, <vscale x 16 x i8>* %pa
  %vb = load <vscale x 16 x i8>, <vscale x 16 x i8>* %pb
  %vc = add <vscale x 16 x i8> %va, %vb
  store <vscale x 16 x i8> %vc, <vscale x 16 x i8> *%pc
  ret void
}

define void @vadd_vint8m4(<vscale x 32 x i8> *%pc, <vscale x 32 x i8> *%pa, <vscale x 32 x i8> *%pb) nounwind {
; CHECK-LABEL: vadd_vint8m4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl4r.v v28, (a1)
; CHECK-NEXT:    vl4r.v v8, (a2)
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, mu
; CHECK-NEXT:    vadd.vv v28, v28, v8
; CHECK-NEXT:    vs4r.v v28, (a0)
; CHECK-NEXT:    ret
  %va = load <vscale x 32 x i8>, <vscale x 32 x i8>* %pa
  %vb = load <vscale x 32 x i8>, <vscale x 32 x i8>* %pb
  %vc = add <vscale x 32 x i8> %va, %vb
  store <vscale x 32 x i8> %vc, <vscale x 32 x i8> *%pc
  ret void
}

define void @vadd_vint8m8(<vscale x 64 x i8> *%pc, <vscale x 64 x i8> *%pa, <vscale x 64 x i8> *%pb) nounwind {
; CHECK-LABEL: vadd_vint8m8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8r.v v8, (a1)
; CHECK-NEXT:    vl8r.v v16, (a2)
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, mu
; CHECK-NEXT:    vadd.vv v8, v8, v16
; CHECK-NEXT:    vs8r.v v8, (a0)
; CHECK-NEXT:    ret
  %va = load <vscale x 64 x i8>, <vscale x 64 x i8>* %pa
  %vb = load <vscale x 64 x i8>, <vscale x 64 x i8>* %pb
  %vc = add <vscale x 64 x i8> %va, %vb
  store <vscale x 64 x i8> %vc, <vscale x 64 x i8> *%pc
  ret void
}

define void @vadd_vint8mf2(<vscale x 4 x i8> *%pc, <vscale x 4 x i8> *%pa, <vscale x 4 x i8> *%pb) nounwind {
; CHECK-LABEL: vadd_vint8mf2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a3, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v25, (a1)
; CHECK-NEXT:    vle8.v v26, (a2)
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vse8.v v25, (a0)
; CHECK-NEXT:    ret
  %va = load <vscale x 4 x i8>, <vscale x 4 x i8>* %pa
  %vb = load <vscale x 4 x i8>, <vscale x 4 x i8>* %pb
  %vc = add <vscale x 4 x i8> %va, %vb
  store <vscale x 4 x i8> %vc, <vscale x 4 x i8> *%pc
  ret void
}

define void @vadd_vint8mf4(<vscale x 2 x i8> *%pc, <vscale x 2 x i8> *%pa, <vscale x 2 x i8> *%pb) nounwind {
; CHECK-LABEL: vadd_vint8mf4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a3, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v25, (a1)
; CHECK-NEXT:    vle8.v v26, (a2)
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vse8.v v25, (a0)
; CHECK-NEXT:    ret
  %va = load <vscale x 2 x i8>, <vscale x 2 x i8>* %pa
  %vb = load <vscale x 2 x i8>, <vscale x 2 x i8>* %pb
  %vc = add <vscale x 2 x i8> %va, %vb
  store <vscale x 2 x i8> %vc, <vscale x 2 x i8> *%pc
  ret void
}

define void @vadd_vint8mf8(<vscale x 1 x i8> *%pc, <vscale x 1 x i8> *%pa, <vscale x 1 x i8> *%pb) nounwind {
; CHECK-LABEL: vadd_vint8mf8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a3, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vle8.v v25, (a1)
; CHECK-NEXT:    vle8.v v26, (a2)
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vse8.v v25, (a0)
; CHECK-NEXT:    ret
  %va = load <vscale x 1 x i8>, <vscale x 1 x i8>* %pa
  %vb = load <vscale x 1 x i8>, <vscale x 1 x i8>* %pb
  %vc = add <vscale x 1 x i8> %va, %vb
  store <vscale x 1 x i8> %vc, <vscale x 1 x i8> *%pc
  ret void
}
