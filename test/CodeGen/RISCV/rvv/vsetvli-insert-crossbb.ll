; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+f,+d,+a,+c,+v \
; RUN:    -target-abi=lp64d -verify-machineinstrs -O2 < %s | FileCheck %s

; The following tests check whether inserting VSETVLI avoids inserting
; unneeded vsetvlis across basic blocks.

declare i64 @llvm.riscv.vsetvli(i64, i64, i64)

declare <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>, <vscale x 1 x double>, i64)
declare <vscale x 2 x float> @llvm.riscv.vfadd.nxv2f32.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, i64)

declare <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>, <vscale x 1 x double>, i64)

declare <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>, <vscale x 1 x double>, i64)

declare <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(<vscale x 1 x double>, double, i64)
declare <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32( <vscale x 2 x float>, float, i64)

declare void @llvm.riscv.vse.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>* nocapture, i64)
declare void @llvm.riscv.vse.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float>* nocapture, i64)

define <vscale x 1 x double> @test1(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    beqz a1, .LBB0_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2: # %if.else
; CHECK-NEXT:    vfsub.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  ret <vscale x 1 x double> %c.0
}

@scratch = global i8 0, align 16

define <vscale x 1 x double> @test2(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    beqz a1, .LBB1_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    vfadd.vv v9, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v9, v8
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_2: # %if.else
; CHECK-NEXT:    vfsub.vv v9, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v9, v8
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %0)
  ret <vscale x 1 x double> %3
}

define <vscale x 1 x double> @test3(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    beqz a1, .LBB2_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v9, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v9, v8
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB2_2: # %if.else
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfsub.vv v9, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v9, v8
; CHECK-NEXT:    ret
entry:
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %2)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %vl.0 = phi i64 [ %0, %if.then], [ %2, %if.else ]
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %3, %if.else ]
  %4 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %vl.0)
  ret <vscale x 1 x double> %4
}

define <vscale x 1 x double> @test4(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %l, <vscale x 1 x double> %r) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    beqz a1, .LBB3_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    lui a1, %hi(.LCPI3_0)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI3_0)
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vlse64.v v10, (a1), zero
; CHECK-NEXT:    lui a1, %hi(.LCPI3_1)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI3_1)
; CHECK-NEXT:    vlse64.v v11, (a1), zero
; CHECK-NEXT:    vfadd.vv v10, v10, v11
; CHECK-NEXT:    lui a1, %hi(scratch)
; CHECK-NEXT:    addi a1, a1, %lo(scratch)
; CHECK-NEXT:    vse64.v v10, (a1)
; CHECK-NEXT:    j .LBB3_3
; CHECK-NEXT:  .LBB3_2: # %if.else
; CHECK-NEXT:    lui a1, %hi(.LCPI3_2)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI3_2)
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vlse32.v v10, (a1), zero
; CHECK-NEXT:    lui a1, %hi(.LCPI3_3)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI3_3)
; CHECK-NEXT:    vlse32.v v11, (a1), zero
; CHECK-NEXT:    vfadd.vv v10, v10, v11
; CHECK-NEXT:    lui a1, %hi(scratch)
; CHECK-NEXT:    addi a1, a1, %lo(scratch)
; CHECK-NEXT:    vse32.v v10, (a1)
; CHECK-NEXT:  .LBB3_3: # %if.end
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %0 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(<vscale x 1 x double> undef, double 1.000000e+00, i64 %avl)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(<vscale x 1 x double> undef, double 2.000000e+00, i64 %avl)
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %0, <vscale x 1 x double> %1, i64 %avl)
  %3 = bitcast i8* @scratch to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64(<vscale x 1 x double> %2, <vscale x 1 x double>* %3, i64 %avl)
  br label %if.end

if.else:                                          ; preds = %entry
  %4 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(<vscale x 2 x float> undef, float 1.000000e+00, i64 %avl)
  %5 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(<vscale x 2 x float> undef, float 2.000000e+00, i64 %avl)
  %6 = tail call <vscale x 2 x float> @llvm.riscv.vfadd.nxv2f32.nxv2f32(<vscale x 2 x float> undef, <vscale x 2 x float> %4, <vscale x 2 x float> %5, i64 %avl)
  %7 = bitcast i8* @scratch to <vscale x 2 x float>*
  tail call void @llvm.riscv.vse.nxv2f32(<vscale x 2 x float> %6, <vscale x 2 x float>* %7, i64 %avl)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %8 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %l, <vscale x 1 x double> %r, i64 %avl)
  ret <vscale x 1 x double> %8
}

define <vscale x 1 x double> @test5(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi a2, a1, 1
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    bnez a2, .LBB4_3
; CHECK-NEXT:  # %bb.1: # %if.else
; CHECK-NEXT:    vfsub.vv v9, v8, v9
; CHECK-NEXT:    andi a0, a1, 2
; CHECK-NEXT:    beqz a0, .LBB4_4
; CHECK-NEXT:  .LBB4_2: # %if.then4
; CHECK-NEXT:    vfmul.vv v8, v9, v8
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB4_3: # %if.then
; CHECK-NEXT:    vfadd.vv v9, v8, v9
; CHECK-NEXT:    andi a0, a1, 2
; CHECK-NEXT:    bnez a0, .LBB4_2
; CHECK-NEXT:  .LBB4_4: # %if.else5
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %conv = zext i8 %cond to i32
  %and = and i32 %conv, 1
  %tobool = icmp eq i32 %and, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %and2 = and i32 %conv, 2
  %tobool3 = icmp eq i32 %and2, 0
  br i1 %tobool3, label %if.else5, label %if.then4

if.then4:                                         ; preds = %if.end
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %0)
  br label %if.end6

if.else5:                                         ; preds = %if.end
  %4 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %c.0, i64 %0)
  br label %if.end6

if.end6:                                          ; preds = %if.else5, %if.then4
  %c.1 = phi <vscale x 1 x double> [ %3, %if.then4 ], [ %4, %if.else5 ]
  ret <vscale x 1 x double> %c.1
}

; FIXME: The explicit vsetvli in if.then4 could be removed as it is redundant
; with the one in the entry, but we lack the ability to remove explicit
; vsetvli instructions.
define <vscale x 1 x double> @test6(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi a3, a1, 1
; CHECK-NEXT:    vsetvli a2, a0, e64, m1, ta, mu
; CHECK-NEXT:    bnez a3, .LBB5_3
; CHECK-NEXT:  # %bb.1: # %if.else
; CHECK-NEXT:    vfsub.vv v8, v8, v9
; CHECK-NEXT:    andi a1, a1, 2
; CHECK-NEXT:    beqz a1, .LBB5_4
; CHECK-NEXT:  .LBB5_2: # %if.then4
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    lui a0, %hi(.LCPI5_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_0)
; CHECK-NEXT:    vlse64.v v9, (a0), zero
; CHECK-NEXT:    lui a0, %hi(.LCPI5_1)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_1)
; CHECK-NEXT:    vlse64.v v10, (a0), zero
; CHECK-NEXT:    vfadd.vv v9, v9, v10
; CHECK-NEXT:    lui a0, %hi(scratch)
; CHECK-NEXT:    addi a0, a0, %lo(scratch)
; CHECK-NEXT:    vse64.v v9, (a0)
; CHECK-NEXT:    j .LBB5_5
; CHECK-NEXT:  .LBB5_3: # %if.then
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    andi a1, a1, 2
; CHECK-NEXT:    bnez a1, .LBB5_2
; CHECK-NEXT:  .LBB5_4: # %if.else5
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    lui a0, %hi(.LCPI5_2)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_2)
; CHECK-NEXT:    vlse32.v v9, (a0), zero
; CHECK-NEXT:    lui a0, %hi(.LCPI5_3)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_3)
; CHECK-NEXT:    vlse32.v v10, (a0), zero
; CHECK-NEXT:    vfadd.vv v9, v9, v10
; CHECK-NEXT:    lui a0, %hi(scratch)
; CHECK-NEXT:    addi a0, a0, %lo(scratch)
; CHECK-NEXT:    vse32.v v9, (a0)
; CHECK-NEXT:  .LBB5_5: # %if.end10
; CHECK-NEXT:    vsetvli zero, a2, e64, m1, ta, mu
; CHECK-NEXT:    vfmul.vv v8, v8, v8
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %conv = zext i8 %cond to i32
  %and = and i32 %conv, 1
  %tobool = icmp eq i32 %and, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %and2 = and i32 %conv, 2
  %tobool3 = icmp eq i32 %and2, 0
  br i1 %tobool3, label %if.else5, label %if.then4

if.then4:                                         ; preds = %if.end
  %3 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %4 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(<vscale x 1 x double> undef, double 1.000000e+00, i64 %3)
  %5 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(<vscale x 1 x double> undef, double 2.000000e+00, i64 %3)
  %6 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %4, <vscale x 1 x double> %5, i64 %3)
  %7 = bitcast i8* @scratch to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64(<vscale x 1 x double> %6, <vscale x 1 x double>* %7, i64 %3)
  br label %if.end10

if.else5:                                         ; preds = %if.end
  %8 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 0)
  %9 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(<vscale x 2 x float> undef, float 1.000000e+00, i64 %8)
  %10 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32( <vscale x 2 x float> undef, float 2.000000e+00, i64 %8)
  %11 = tail call <vscale x 2 x float> @llvm.riscv.vfadd.nxv2f32.nxv2f32(<vscale x 2 x float> undef, <vscale x 2 x float> %9, <vscale x 2 x float> %10, i64 %8)
  %12 = bitcast i8* @scratch to <vscale x 2 x float>*
  tail call void @llvm.riscv.vse.nxv2f32(<vscale x 2 x float> %11, <vscale x 2 x float>* %12, i64 %8)
  br label %if.end10

if.end10:                                         ; preds = %if.else5, %if.then4
  %13 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %c.0, <vscale x 1 x double> %c.0, i64 %0)
  ret <vscale x 1 x double> %13
}

declare void @foo()

; Similar to test1, but contains a call to @foo to act as barrier to analyzing
; VL/VTYPE.
define <vscale x 1 x double> @test8(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -32
; CHECK-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 1
; CHECK-NEXT:    sub sp, sp, a2
; CHECK-NEXT:    vsetvli s0, a0, e64, m1, ta, mu
; CHECK-NEXT:    beqz a1, .LBB6_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    j .LBB6_3
; CHECK-NEXT:  .LBB6_2: # %if.else
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    add a0, a0, sp
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vs1r.v v9, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    call foo@plt
; CHECK-NEXT:    vsetvli zero, s0, e64, m1, ta, mu
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    add a0, a0, sp
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl1r.v v9, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    vfsub.vv v8, v9, v8
; CHECK-NEXT:  .LBB6_3: # %if.then
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 1
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 32
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  call void @foo()
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  ret <vscale x 1 x double> %c.0
}

; Similar to test2, but contains a call to @foo to act as barrier to analyzing
; VL/VTYPE.
define <vscale x 1 x double> @test9(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -32
; CHECK-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 1
; CHECK-NEXT:    sub sp, sp, a2
; CHECK-NEXT:    vsetvli s0, a0, e64, m1, ta, mu
; CHECK-NEXT:    beqz a1, .LBB7_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    vfadd.vv v9, v8, v9
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vs1r.v v9, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    add a0, a0, sp
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    call foo@plt
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl1r.v v9, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    add a0, a0, sp
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    j .LBB7_3
; CHECK-NEXT:  .LBB7_2: # %if.else
; CHECK-NEXT:    vfsub.vv v9, v8, v9
; CHECK-NEXT:  .LBB7_3: # %if.end
; CHECK-NEXT:    vsetvli zero, s0, e64, m1, ta, mu
; CHECK-NEXT:    vfmul.vv v8, v9, v8
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 1
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 32
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  call void @foo()
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> undef, <vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %0)
  ret <vscale x 1 x double> %3
}

define void @saxpy_vec(i64 %n, float %a, float* nocapture readonly %x, float* nocapture %y) {
; CHECK-LABEL: saxpy_vec:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, a0, e32, m8, ta, mu
; CHECK-NEXT:    beqz a3, .LBB8_2
; CHECK-NEXT:  .LBB8_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    vle32.v v16, (a2)
; CHECK-NEXT:    slli a4, a3, 2
; CHECK-NEXT:    add a1, a1, a4
; CHECK-NEXT:    vsetvli zero, zero, e32, m8, tu, mu
; CHECK-NEXT:    vfmacc.vf v16, fa0, v8
; CHECK-NEXT:    vse32.v v16, (a2)
; CHECK-NEXT:    sub a0, a0, a3
; CHECK-NEXT:    vsetvli a3, a0, e32, m8, ta, mu
; CHECK-NEXT:    add a2, a2, a4
; CHECK-NEXT:    bnez a3, .LBB8_1
; CHECK-NEXT:  .LBB8_2: # %for.end
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %n, i64 2, i64 3)
  %cmp.not13 = icmp eq i64 %0, 0
  br i1 %cmp.not13, label %for.end, label %for.body

for.body:                                         ; preds = %for.body, %entry
  %1 = phi i64 [ %7, %for.body ], [ %0, %entry ]
  %n.addr.016 = phi i64 [ %sub, %for.body ], [ %n, %entry ]
  %x.addr.015 = phi float* [ %add.ptr, %for.body ], [ %x, %entry ]
  %y.addr.014 = phi float* [ %add.ptr1, %for.body ], [ %y, %entry ]
  %2 = bitcast float* %x.addr.015 to <vscale x 16 x float>*
  %3 = tail call <vscale x 16 x float> @llvm.riscv.vle.nxv16f32.i64(<vscale x 16 x float> undef, <vscale x 16 x float>* %2, i64 %1)
  %add.ptr = getelementptr inbounds float, float* %x.addr.015, i64 %1
  %4 = bitcast float* %y.addr.014 to <vscale x 16 x float>*
  %5 = tail call <vscale x 16 x float> @llvm.riscv.vle.nxv16f32.i64(<vscale x 16 x float> undef, <vscale x 16 x float>* %4, i64 %1)
  %6 = tail call <vscale x 16 x float> @llvm.riscv.vfmacc.nxv16f32.f32.i64(<vscale x 16 x float> %5, float %a, <vscale x 16 x float> %3, i64 %1, i64 0)
  tail call void @llvm.riscv.vse.nxv16f32.i64(<vscale x 16 x float> %6, <vscale x 16 x float>* %4, i64 %1)
  %add.ptr1 = getelementptr inbounds float, float* %y.addr.014, i64 %1
  %sub = sub i64 %n.addr.016, %1
  %7 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %sub, i64 2, i64 3)
  %cmp.not = icmp eq i64 %7, 0
  br i1 %cmp.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  ret void
}

declare i64 @llvm.riscv.vsetvli.i64(i64, i64 immarg, i64 immarg)
declare <vscale x 16 x float> @llvm.riscv.vle.nxv16f32.i64(<vscale x 16 x float>, <vscale x 16 x float>* nocapture, i64)
declare <vscale x 16 x float> @llvm.riscv.vfmacc.nxv16f32.f32.i64(<vscale x 16 x float>, float, <vscale x 16 x float>, i64, i64)
declare void @llvm.riscv.vse.nxv16f32.i64(<vscale x 16 x float>, <vscale x 16 x float>* nocapture, i64)

; We need a vsetvli in the last block because the predecessors have different
; VTYPEs. The AVL is the same and the SEW/LMUL ratio implies the same VLMAX so
; we don't need to read AVL and can keep VL unchanged.
define <vscale x 2 x i32> @test_vsetvli_x0_x0(<vscale x 2 x i32>* %x, <vscale x 2 x i16>* %y, <vscale x 2 x i32> %z, i64 %vl, i1 %cond) nounwind {
; CHECK-LABEL: test_vsetvli_x0_x0:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a2, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v9, (a0)
; CHECK-NEXT:    andi a0, a3, 1
; CHECK-NEXT:    beqz a0, .LBB9_2
; CHECK-NEXT:  # %bb.1: # %if
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v10, (a1)
; CHECK-NEXT:    vwcvt.x.x.v v8, v10
; CHECK-NEXT:  .LBB9_2: # %if.end
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; CHECK-NEXT:    vadd.vv v8, v9, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32(<vscale x 2 x i32> undef, <vscale x 2 x i32>* %x, i64 %vl)
  br i1 %cond, label %if, label %if.end

if:
  %b = call <vscale x 2 x i16> @llvm.riscv.vle.nxv2i16(<vscale x 2 x i16> undef, <vscale x 2 x i16>* %y, i64 %vl)
  %c = call <vscale x 2 x i32> @llvm.riscv.vwadd.nxv2i32(<vscale x 2 x i32> undef, <vscale x 2 x i16> %b, i16 0, i64 %vl)
  br label %if.end

if.end:
  %d = phi <vscale x 2 x i32> [ %z, %entry ], [ %c, %if ]
  %e = call <vscale x 2 x i32> @llvm.riscv.vadd.nxv2i32(<vscale x 2 x i32> undef, <vscale x 2 x i32> %a, <vscale x 2 x i32> %d, i64 %vl)
  ret <vscale x 2 x i32> %e
}
declare <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32>*, i64)
declare <vscale x 2 x i16> @llvm.riscv.vle.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x i16>*, i64)
declare <vscale x 2 x i32> @llvm.riscv.vwadd.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i16>, i16, i64)
declare <vscale x 2 x i32> @llvm.riscv.vadd.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, i64)

; We can use X0, X0 vsetvli in if2 and if2.end. The merge point as if.end will
; see two different vtypes with the same SEW/LMUL ratio. At if2.end we will only
; know the SEW/LMUL ratio for the if.end predecessor and the full vtype for
; the if2 predecessor. This makes sure we can merge a SEW/LMUL predecessor with
; a predecessor we know the vtype for.
define <vscale x 2 x i32> @test_vsetvli_x0_x0_2(<vscale x 2 x i32>* %x, <vscale x 2 x i16>* %y, <vscale x 2 x i16>* %z, i64 %vl, i1 %cond, i1 %cond2, <vscale x 2 x i32> %w) nounwind {
; CHECK-LABEL: test_vsetvli_x0_x0_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a3, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v9, (a0)
; CHECK-NEXT:    andi a0, a4, 1
; CHECK-NEXT:    beqz a0, .LBB10_2
; CHECK-NEXT:  # %bb.1: # %if
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v10, (a1)
; CHECK-NEXT:    vwadd.wv v9, v9, v10
; CHECK-NEXT:  .LBB10_2: # %if.end
; CHECK-NEXT:    andi a0, a5, 1
; CHECK-NEXT:    beqz a0, .LBB10_4
; CHECK-NEXT:  # %bb.3: # %if2
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v10, (a2)
; CHECK-NEXT:    vwadd.wv v9, v9, v10
; CHECK-NEXT:  .LBB10_4: # %if2.end
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; CHECK-NEXT:    vadd.vv v8, v9, v8
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32(<vscale x 2 x i32> undef, <vscale x 2 x i32>* %x, i64 %vl)
  br i1 %cond, label %if, label %if.end

if:
  %b = call <vscale x 2 x i16> @llvm.riscv.vle.nxv2i16(<vscale x 2 x i16> undef, <vscale x 2 x i16>* %y, i64 %vl)
  %c = call <vscale x 2 x i32> @llvm.riscv.vwadd.w.nxv2i32.nxv2i16(<vscale x 2 x i32> undef, <vscale x 2 x i32> %a, <vscale x 2 x i16> %b, i64 %vl)
  br label %if.end

if.end:
  %d = phi <vscale x 2 x i32> [ %a, %entry ], [ %c, %if ]
  br i1 %cond2, label %if2, label %if2.end

if2:
  %e = call <vscale x 2 x i16> @llvm.riscv.vle.nxv2i16(<vscale x 2 x i16> undef, <vscale x 2 x i16>* %z, i64 %vl)
  %f = call <vscale x 2 x i32> @llvm.riscv.vwadd.w.nxv2i32.nxv2i16(<vscale x 2 x i32> undef, <vscale x 2 x i32> %d, <vscale x 2 x i16> %e, i64 %vl)
  br label %if2.end

if2.end:
  %g = phi <vscale x 2 x i32> [ %d, %if.end ], [ %f, %if2 ]
  %h = call <vscale x 2 x i32> @llvm.riscv.vadd.nxv2i32(<vscale x 2 x i32> undef, <vscale x 2 x i32> %g, <vscale x 2 x i32> %w, i64 %vl)
  ret <vscale x 2 x i32> %h
}
declare <vscale x 2 x i32> @llvm.riscv.vwadd.w.nxv2i32.nxv2i16(<vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i16>, i64)

; We should only need 1 vsetvli for this code.
define void @vlmax(i64 %N, double* %c, double* %a, double* %b) {
; CHECK-LABEL: vlmax:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a6, zero, e64, m1, ta, mu
; CHECK-NEXT:    blez a0, .LBB11_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    li a5, 0
; CHECK-NEXT:    li t1, 0
; CHECK-NEXT:    slli a7, a6, 3
; CHECK-NEXT:  .LBB11_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add t0, a2, a5
; CHECK-NEXT:    vsetvli zero, a6, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (t0)
; CHECK-NEXT:    add a4, a3, a5
; CHECK-NEXT:    vle64.v v9, (a4)
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    add a4, a1, a5
; CHECK-NEXT:    vse64.v v8, (a4)
; CHECK-NEXT:    add t1, t1, a6
; CHECK-NEXT:    add a5, a5, a7
; CHECK-NEXT:    blt t1, a0, .LBB11_2
; CHECK-NEXT:  .LBB11_3: # %for.end
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvlimax.i64(i64 3, i64 0)
  %cmp13 = icmp sgt i64 %N, 0
  br i1 %cmp13, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.014 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds double, double* %a, i64 %i.014
  %1 = bitcast double* %arrayidx to <vscale x 1 x double>*
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vle.nxv1f64.i64(<vscale x 1 x double> undef, <vscale x 1 x double>* %1, i64 %0)
  %arrayidx1 = getelementptr inbounds double, double* %b, i64 %i.014
  %3 = bitcast double* %arrayidx1 to <vscale x 1 x double>*
  %4 = tail call <vscale x 1 x double> @llvm.riscv.vle.nxv1f64.i64(<vscale x 1 x double> undef, <vscale x 1 x double>* %3, i64 %0)
  %5 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64.i64(<vscale x 1 x double> undef, <vscale x 1 x double> %2, <vscale x 1 x double> %4, i64 %0)
  %arrayidx2 = getelementptr inbounds double, double* %c, i64 %i.014
  %6 = bitcast double* %arrayidx2 to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64.i64(<vscale x 1 x double> %5, <vscale x 1 x double>* %6, i64 %0)
  %add = add nuw nsw i64 %i.014, %0
  %cmp = icmp slt i64 %add, %N
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; A single vector store in the loop with VL controlled by VLMAX
define void @vector_init_vlmax(i64 %N, double* %c) {
; CHECK-LABEL: vector_init_vlmax:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a2, zero, e64, m1, ta, mu
; CHECK-NEXT:    blez a0, .LBB12_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    li a3, 0
; CHECK-NEXT:    slli a4, a2, 3
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:  .LBB12_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vsetvli zero, a2, e64, m1, ta, mu
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    add a3, a3, a2
; CHECK-NEXT:    add a1, a1, a4
; CHECK-NEXT:    blt a3, a0, .LBB12_2
; CHECK-NEXT:  .LBB12_3: # %for.end
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvlimax.i64(i64 3, i64 0)
  %cmp13 = icmp sgt i64 %N, 0
  br i1 %cmp13, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.014 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx2 = getelementptr inbounds double, double* %c, i64 %i.014
  %addr = bitcast double* %arrayidx2 to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64.i64(<vscale x 1 x double> zeroinitializer, <vscale x 1 x double>* %addr, i64 %0)
  %add = add nuw nsw i64 %i.014, %0
  %cmp = icmp slt i64 %add, %N
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Same as above, but VL comes from user provided AVL value
define void @vector_init_vsetvli_N(i64 %N, double* %c) {
; CHECK-LABEL: vector_init_vsetvli_N:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a2, a0, e64, m1, ta, mu
; CHECK-NEXT:    blez a0, .LBB13_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    li a3, 0
; CHECK-NEXT:    slli a4, a2, 3
; CHECK-NEXT:    vsetvli a5, zero, e64, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:  .LBB13_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vsetvli zero, a2, e64, m1, ta, mu
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    add a3, a3, a2
; CHECK-NEXT:    add a1, a1, a4
; CHECK-NEXT:    blt a3, a0, .LBB13_2
; CHECK-NEXT:  .LBB13_3: # %for.end
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %N, i64 3, i64 0)
  %cmp13 = icmp sgt i64 %N, 0
  br i1 %cmp13, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.014 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx2 = getelementptr inbounds double, double* %c, i64 %i.014
  %addr = bitcast double* %arrayidx2 to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64.i64(<vscale x 1 x double> zeroinitializer, <vscale x 1 x double>* %addr, i64 %0)
  %add = add nuw nsw i64 %i.014, %0
  %cmp = icmp slt i64 %add, %N
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Same as above, but VL is a hard coded constant (in the preheader)
define void @vector_init_vsetvli_fv(i64 %N, double* %c) {
; CHECK-LABEL: vector_init_vsetvli_fv:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li a2, 0
; CHECK-NEXT:    vsetivli a3, 4, e64, m1, ta, mu
; CHECK-NEXT:    slli a4, a3, 3
; CHECK-NEXT:    vsetvli a5, zero, e64, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:  .LBB14_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vsetvli zero, a3, e64, m1, ta, mu
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    add a2, a2, a3
; CHECK-NEXT:    add a1, a1, a4
; CHECK-NEXT:    blt a2, a0, .LBB14_1
; CHECK-NEXT:  # %bb.2: # %for.end
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 4, i64 3, i64 0)
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.014 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx2 = getelementptr inbounds double, double* %c, i64 %i.014
  %addr = bitcast double* %arrayidx2 to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64.i64(<vscale x 1 x double> zeroinitializer, <vscale x 1 x double>* %addr, i64 %0)
  %add = add nuw nsw i64 %i.014, %0
  %cmp = icmp slt i64 %add, %N
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}

; Same as above, but result of vsetvli in preheader isn't used, and
; constant is repeated in loop
define void @vector_init_vsetvli_fv2(i64 %N, double* %c) {
; CHECK-LABEL: vector_init_vsetvli_fv2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li a2, 0
; CHECK-NEXT:    vsetivli zero, 4, e64, m1, ta, mu
; CHECK-NEXT:    vsetvli a3, zero, e64, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:  .LBB15_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vsetivli zero, 4, e64, m1, ta, mu
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    addi a2, a2, 4
; CHECK-NEXT:    addi a1, a1, 32
; CHECK-NEXT:    blt a2, a0, .LBB15_1
; CHECK-NEXT:  # %bb.2: # %for.end
; CHECK-NEXT:    ret
entry:
  tail call i64 @llvm.riscv.vsetvli(i64 4, i64 3, i64 0)
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.014 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx2 = getelementptr inbounds double, double* %c, i64 %i.014
  %addr = bitcast double* %arrayidx2 to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64.i64(<vscale x 1 x double> zeroinitializer, <vscale x 1 x double>* %addr, i64 4)
  %add = add nuw nsw i64 %i.014, 4
  %cmp = icmp slt i64 %add, %N
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}

; Same as above, but AVL is only specified on the store intrinsic
; This case will require some form of hoisting or PRE
define void @vector_init_vsetvli_fv3(i64 %N, double* %c) {
; CHECK-LABEL: vector_init_vsetvli_fv3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li a2, 0
; CHECK-NEXT:    vsetvli a3, zero, e64, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:  .LBB16_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vsetivli zero, 4, e64, m1, ta, mu
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    addi a2, a2, 4
; CHECK-NEXT:    addi a1, a1, 32
; CHECK-NEXT:    blt a2, a0, .LBB16_1
; CHECK-NEXT:  # %bb.2: # %for.end
; CHECK-NEXT:    ret
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.014 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx2 = getelementptr inbounds double, double* %c, i64 %i.014
  %addr = bitcast double* %arrayidx2 to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64.i64(<vscale x 1 x double> zeroinitializer, <vscale x 1 x double>* %addr, i64 4)
  %add = add nuw nsw i64 %i.014, 4
  %cmp = icmp slt i64 %add, %N
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}

declare i64 @llvm.riscv.vsetvlimax.i64(i64, i64)
declare <vscale x 1 x double> @llvm.riscv.vle.nxv1f64.i64(<vscale x 1 x double>, <vscale x 1 x double>* nocapture, i64)
declare <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64.i64(<vscale x 1 x double>, <vscale x 1 x double>, <vscale x 1 x double>, i64)
declare void @llvm.riscv.vse.nxv1f64.i64(<vscale x 1 x double>, <vscale x 1 x double>* nocapture, i64)
