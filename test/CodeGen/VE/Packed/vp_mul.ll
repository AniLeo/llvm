; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=ve -mattr=+vpu | FileCheck %s

declare <512 x i32> @llvm.vp.mul.v512i32(<512 x i32>, <512 x i32>, <512 x i1>, i32)

define fastcc <512 x i32> @test_vp_v512i32(<512 x i32> %i0, <512 x i32> %i1, <512 x i1> %m, i32 %n) {
; CHECK-LABEL: test_vp_v512i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    adds.w.sx %s1, 1, %s0
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    srl %s1, %s1, 1
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vshf %v2, %v1, %v1, 0
; CHECK-NEXT:    vshf %v3, %v0, %v0, 0
; CHECK-NEXT:    vmuls.w.sx %v2, %v3, %v2, %vm2
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    srl %s0, %s0, 1
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vmuls.w.sx %v0, %v0, %v1, %vm3
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vshf %v0, %v0, %v2, 13
; CHECK-NEXT:    b.l.t (, %s10)
  %r0 = call <512 x i32> @llvm.vp.mul.v512i32(<512 x i32> %i0, <512 x i32> %i1, <512 x i1> %m, i32 %n)
  ret <512 x i32> %r0
}
