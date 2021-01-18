; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

declare { <vscale x 2 x i32>, <vscale x 2 x i1> } @llvm.sadd.with.overflow.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32>)

define <vscale x 2 x i32> @saddo_nvx2i32(<vscale x 2 x i32> %x, <vscale x 2 x i32> %y) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vmslt.vx v25, v17, zero
; CHECK-NEXT:    vadd.vv v26, v16, v17
; CHECK-NEXT:    vmslt.vv v27, v26, v16
; CHECK-NEXT:    vsetvli a0, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vmxor.mm v0, v25, v27
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vmerge.vim v16, v26, 0, v0
; CHECK-NEXT:    ret
  %a = call { <vscale x 2 x i32>, <vscale x 2 x i1> } @llvm.sadd.with.overflow.nxv2i32(<vscale x 2 x i32> %x, <vscale x 2 x i32> %y)
  %b = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i1> } %a, 0
  %c = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i1> } %a, 1
  %d = select <vscale x 2 x i1> %c, <vscale x 2 x i32> zeroinitializer, <vscale x 2 x i32> %b
  ret <vscale x 2 x i32> %d
}
