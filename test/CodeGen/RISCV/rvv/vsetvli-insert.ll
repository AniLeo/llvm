; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+f,+d,+a,+c,+experimental-v \
; RUN:    -verify-machineinstrs -O2 < %s | FileCheck %s

declare i64 @llvm.riscv.vsetvli(i64, i64, i64)
declare <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  i64)
declare <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>*,
  <vscale x 1 x i1>,
  i64)

define <vscale x 1 x double> @test1(i64 %avl, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 %0)
  ret <vscale x 1 x double> %1
}

define <vscale x 1 x double> @test2(i64 %avl, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 %avl)
  ret <vscale x 1 x double> %1
}

define <vscale x 1 x i64> @test3(i64 %avl, <vscale x 1 x i64> %a, <vscale x 1 x i64>* %b, <vscale x 1 x i1> %c) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, tu, mu
; CHECK-NEXT:    vle64.v v8, (a1), v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = call <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64>* %b,
    <vscale x 1 x i1> %c,
    i64 %0)

  ret <vscale x 1 x i64> %1
}

define <vscale x 1 x i64> @test4(i64 %avl, <vscale x 1 x i64> %a, <vscale x 1 x i64>* %b, <vscale x 1 x i1> %c) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, tu, mu
; CHECK-NEXT:    vle64.v v8, (a1), v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = call <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64>* %b,
    <vscale x 1 x i1> %c,
    i64 %avl)

  ret <vscale x 1 x i64> %1
}
