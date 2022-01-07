; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+f,+d,+a,+c,+experimental-v \
; RUN:    -verify-machineinstrs -O2 < %s | FileCheck %s

declare i64 @llvm.riscv.vsetvli(i64, i64, i64)
declare i64 @llvm.riscv.vsetvlimax(i64, i64)
declare <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  i64)
declare <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>*,
  <vscale x 1 x i1>,
  i64, i64)

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
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a1), v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = call <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64>* %b,
    <vscale x 1 x i1> %c,
    i64 %0, i64 1)

  ret <vscale x 1 x i64> %1
}

define <vscale x 1 x i64> @test4(i64 %avl, <vscale x 1 x i64> %a, <vscale x 1 x i64>* %b, <vscale x 1 x i1> %c) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a1), v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = call <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64>* %b,
    <vscale x 1 x i1> %c,
    i64 %avl, i64 1)

  ret <vscale x 1 x i64> %1
}

; Make sure we don't insert a vsetvli for the vmand instruction.
define <vscale x 1 x i1> @test5(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, <vscale x 1 x i1> %2, i64 %avl) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vmseq.vv v8, v8, v9
; CHECK-NEXT:    vmand.mm v0, v8, v0
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %a = call <vscale x 1 x i1> @llvm.riscv.vmseq.nxv1i64.i64(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, i64 %vl)
  %b = call <vscale x 1 x i1> @llvm.riscv.vmand.nxv1i1.i64(<vscale x 1 x i1> %a, <vscale x 1 x i1> %2, i64 %vl)
  ret <vscale x 1 x i1> %b
}
declare <vscale x 1 x i1> @llvm.riscv.vmseq.nxv1i64.i64(<vscale x 1 x i64>, <vscale x 1 x i64>, i64)
declare <vscale x 1 x i1> @llvm.riscv.vmand.nxv1i1.i64(<vscale x 1 x i1>, <vscale x 1 x i1>, i64)

; Make sure we don't insert a vsetvli for the vmor instruction.
define void @test6(i32* nocapture readonly %A, i32* nocapture %B, i64 %n) {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a6, a2, e32, m1, ta, mu
; CHECK-NEXT:    beqz a6, .LBB5_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    li a4, 0
; CHECK-NEXT:  .LBB5_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    slli a5, a4, 2
; CHECK-NEXT:    add a3, a0, a5
; CHECK-NEXT:    vle32.v v8, (a3)
; CHECK-NEXT:    vmsle.vi v9, v8, -3
; CHECK-NEXT:    vmsgt.vi v10, v8, 2
; CHECK-NEXT:    vmor.mm v0, v9, v10
; CHECK-NEXT:    add a3, a1, a5
; CHECK-NEXT:    vse32.v v8, (a3), v0.t
; CHECK-NEXT:    add a4, a4, a6
; CHECK-NEXT:    vsetvli a6, a2, e32, m1, ta, mu
; CHECK-NEXT:    bnez a6, .LBB5_2
; CHECK-NEXT:  .LBB5_3: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %n, i64 2, i64 0)
  %cmp.not11 = icmp eq i64 %0, 0
  br i1 %cmp.not11, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %1 = phi i64 [ %8, %for.body ], [ %0, %entry ]
  %i.012 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %add.ptr = getelementptr inbounds i32, i32* %A, i64 %i.012
  %2 = bitcast i32* %add.ptr to <vscale x 2 x i32>*
  %3 = tail call <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32.i64(<vscale x 2 x i32>* %2, i64 %1)
  %4 = tail call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32.i32.i64(<vscale x 2 x i32> %3, i32 -2, i64 %1)
  %5 = tail call <vscale x 2 x i1> @llvm.riscv.vmsgt.nxv2i32.i32.i64(<vscale x 2 x i32> %3, i32 2, i64 %1)
  %6 = tail call <vscale x 2 x i1> @llvm.riscv.vmor.nxv2i1.i64(<vscale x 2 x i1> %4, <vscale x 2 x i1> %5, i64 %1)
  %add.ptr1 = getelementptr inbounds i32, i32* %B, i64 %i.012
  %7 = bitcast i32* %add.ptr1 to <vscale x 2 x i32>*
  tail call void @llvm.riscv.vse.mask.nxv2i32.i64(<vscale x 2 x i32> %3, <vscale x 2 x i32>* %7, <vscale x 2 x i1> %6, i64 %1)
  %add = add i64 %1, %i.012
  %8 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %n, i64 2, i64 0)
  %cmp.not = icmp eq i64 %8, 0
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define <vscale x 1 x i64> @test7(<vscale x 1 x i64> %a, i64 %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, tu, mu
; CHECK-NEXT:    vmv.s.x v8, a0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvlimax(i64 3, i64 0)
  %y = call <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(
    <vscale x 1 x i64> %a,
    i64 %b, i64 1)

  ret <vscale x 1 x i64> %y
}

define <vscale x 1 x i64> @test8(<vscale x 1 x i64> %a, i64 %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli a1, 6, e64, m1, tu, mu
; CHECK-NEXT:    vmv.s.x v8, a0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 3, i64 0)
  %y = call <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(<vscale x 1 x i64> %a, i64 %b, i64 2)
  ret <vscale x 1 x i64> %y
}

define <vscale x 1 x i64> @test9(<vscale x 1 x i64> %a, i64 %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 9, e64, m1, tu, mu
; CHECK-NEXT:    vadd.vv v8, v8, v8, v0.t
; CHECK-NEXT:    vmv.s.x v8, a0
; CHECK-NEXT:    ret
entry:
  %x = call <vscale x 1 x i64> @llvm.riscv.vadd.mask.nxv1i64.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64> %a,
    <vscale x 1 x i1> %mask,
    i64 9,
    i64 0)
  %y = call <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(<vscale x 1 x i64> %x, i64 %b, i64 2)
  ret <vscale x 1 x i64> %y
}

define <vscale x 1 x double> @test10(<vscale x 1 x double> %a, double %b) nounwind {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.d.x ft0, a0
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, tu, mu
; CHECK-NEXT:    vfmv.s.f v8, ft0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvlimax(i64 3, i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %a, double %b, i64 1)
  ret <vscale x 1 x double> %y
}

define <vscale x 1 x double> @test11(<vscale x 1 x double> %a, double %b) nounwind {
; CHECK-LABEL: test11:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.d.x ft0, a0
; CHECK-NEXT:    vsetivli a0, 6, e64, m1, tu, mu
; CHECK-NEXT:    vfmv.s.f v8, ft0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 3, i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %a, double %b, i64 2)
  ret <vscale x 1 x double> %y
}

define <vscale x 1 x double> @test12(<vscale x 1 x double> %a, double %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.d.x ft0, a0
; CHECK-NEXT:    vsetivli zero, 9, e64, m1, tu, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v8, v0.t
; CHECK-NEXT:    vfmv.s.f v8, ft0
; CHECK-NEXT:    ret
entry:
  %x = call <vscale x 1 x double> @llvm.riscv.vfadd.mask.nxv1f64.f64(
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %a,
    <vscale x 1 x i1> %mask,
    i64 9,
    i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %x, double %b, i64 2)
  ret <vscale x 1 x double> %y
}

define <vscale x 1 x double> @test13(<vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test13:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 -1)
  ret <vscale x 1 x double> %0
}

declare <vscale x 1 x i64> @llvm.riscv.vadd.mask.nxv1i64.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  <vscale x 1 x i1>,
  i64,
  i64);

declare <vscale x 1 x double> @llvm.riscv.vfadd.mask.nxv1f64.f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x i1>,
  i64,
  i64);

declare <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(
  <vscale x 1 x i64>,
  i64,
  i64);

declare <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64
  (<vscale x 1 x double>,
  double,
  i64)

declare i64 @llvm.riscv.vsetvli.i64(i64, i64 immarg, i64 immarg)
declare <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32.i64(<vscale x 2 x i32>* nocapture, i64)
declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32.i32.i64(<vscale x 2 x i32>, i32, i64)
declare <vscale x 2 x i1> @llvm.riscv.vmsgt.nxv2i32.i32.i64(<vscale x 2 x i32>, i32, i64)
declare <vscale x 2 x i1> @llvm.riscv.vmor.nxv2i1.i64(<vscale x 2 x i1>, <vscale x 2 x i1>, i64)
declare void @llvm.riscv.vse.mask.nxv2i32.i64(<vscale x 2 x i32>, <vscale x 2 x i32>* nocapture, <vscale x 2 x i1>, i64)
