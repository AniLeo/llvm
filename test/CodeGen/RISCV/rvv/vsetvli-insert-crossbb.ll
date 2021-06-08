; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+f,+d,+a,+c,+experimental-v \
; RUN:    -verify-machineinstrs -O2 < %s | FileCheck %s

; The following tests check whether inserting VSETVLI avoids inserting
; unneeded vsetvlis across basic blocks.

declare i64 @llvm.riscv.vsetvli(i64, i64, i64)

declare <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>, i64)
declare <vscale x 2 x float> @llvm.riscv.vfadd.nxv2f32.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float>, i64)

declare <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>, i64)

declare <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>, i64)

declare <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(double, i64)
declare <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(float, i64)

declare void @llvm.riscv.vse.nxv1f64(<vscale x 1 x double>, <vscale x 1 x double>* nocapture, i64)
declare void @llvm.riscv.vse.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float>* nocapture, i64)

define <vscale x 1 x double> @test1(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
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
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  ret <vscale x 1 x double> %c.0
}

@scratch = global i8 0, align 16

define <vscale x 1 x double> @test2(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    beqz a1, .LBB1_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    vfadd.vv v25, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v25, v8
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_2: # %if.else
; CHECK-NEXT:    vfsub.vv v25, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v25, v8
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %0)
  ret <vscale x 1 x double> %3
}

define <vscale x 1 x double> @test3(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    beqz a1, .LBB2_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfadd.vv v25, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v25, v8
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB2_2: # %if.else
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfsub.vv v25, v8, v9
; CHECK-NEXT:    vfmul.vv v8, v25, v8
; CHECK-NEXT:    ret
entry:
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %2)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %vl.0 = phi i64 [ %0, %if.then], [ %2, %if.else ]
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %3, %if.else ]
  %4 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %vl.0)
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
; CHECK-NEXT:    vlse64.v v25, (a1), zero
; CHECK-NEXT:    lui a1, %hi(.LCPI3_1)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI3_1)
; CHECK-NEXT:    vlse64.v v26, (a1), zero
; CHECK-NEXT:    vfadd.vv v25, v25, v26
; CHECK-NEXT:    lui a1, %hi(scratch)
; CHECK-NEXT:    addi a1, a1, %lo(scratch)
; CHECK-NEXT:    vse64.v v25, (a1)
; CHECK-NEXT:    j .LBB3_3
; CHECK-NEXT:  .LBB3_2: # %if.else
; CHECK-NEXT:    lui a1, %hi(.LCPI3_2)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI3_2)
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vlse32.v v25, (a1), zero
; CHECK-NEXT:    lui a1, %hi(.LCPI3_3)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI3_3)
; CHECK-NEXT:    vlse32.v v26, (a1), zero
; CHECK-NEXT:    vfadd.vv v25, v25, v26
; CHECK-NEXT:    lui a1, %hi(scratch)
; CHECK-NEXT:    addi a1, a1, %lo(scratch)
; CHECK-NEXT:    vse32.v v25, (a1)
; CHECK-NEXT:  .LBB3_3: # %if.end
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %0 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(double 1.000000e+00, i64 %avl)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(double 2.000000e+00, i64 %avl)
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %0, <vscale x 1 x double> %1, i64 %avl)
  %3 = bitcast i8* @scratch to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64(<vscale x 1 x double> %2, <vscale x 1 x double>* %3, i64 %avl)
  br label %if.end

if.else:                                          ; preds = %entry
  %4 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(float 1.000000e+00, i64 %avl)
  %5 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(float 2.000000e+00, i64 %avl)
  %6 = tail call <vscale x 2 x float> @llvm.riscv.vfadd.nxv2f32.nxv2f32(<vscale x 2 x float> %4, <vscale x 2 x float> %5, i64 %avl)
  %7 = bitcast i8* @scratch to <vscale x 2 x float>*
  tail call void @llvm.riscv.vse.nxv2f32(<vscale x 2 x float> %6, <vscale x 2 x float>* %7, i64 %avl)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %8 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> %l, <vscale x 1 x double> %r, i64 %avl)
  ret <vscale x 1 x double> %8
}

define <vscale x 1 x double> @test5(i64 %avl, i8 zeroext %cond, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi a2, a1, 1
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    bnez a2, .LBB4_3
; CHECK-NEXT:  # %bb.1: # %if.else
; CHECK-NEXT:    vfsub.vv v25, v8, v9
; CHECK-NEXT:    andi a0, a1, 2
; CHECK-NEXT:    beqz a0, .LBB4_4
; CHECK-NEXT:  .LBB4_2: # %if.then4
; CHECK-NEXT:    vfmul.vv v8, v25, v8
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB4_3: # %if.then
; CHECK-NEXT:    vfadd.vv v25, v8, v9
; CHECK-NEXT:    andi a0, a1, 2
; CHECK-NEXT:    bnez a0, .LBB4_2
; CHECK-NEXT:  .LBB4_4: # %if.else5
; CHECK-NEXT:    vfmul.vv v8, v8, v25
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %conv = zext i8 %cond to i32
  %and = and i32 %conv, 1
  %tobool = icmp eq i32 %and, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %and2 = and i32 %conv, 2
  %tobool3 = icmp eq i32 %and2, 0
  br i1 %tobool3, label %if.else5, label %if.then4

if.then4:                                         ; preds = %if.end
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %0)
  br label %if.end6

if.else5:                                         ; preds = %if.end
  %4 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %c.0, i64 %0)
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
; CHECK-NEXT:    vfsub.vv v25, v8, v9
; CHECK-NEXT:    andi a1, a1, 2
; CHECK-NEXT:    beqz a1, .LBB5_4
; CHECK-NEXT:  .LBB5_2: # %if.then4
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, mu
; CHECK-NEXT:    lui a0, %hi(.LCPI5_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_0)
; CHECK-NEXT:    vlse64.v v26, (a0), zero
; CHECK-NEXT:    lui a0, %hi(.LCPI5_1)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_1)
; CHECK-NEXT:    vlse64.v v27, (a0), zero
; CHECK-NEXT:    vfadd.vv v26, v26, v27
; CHECK-NEXT:    lui a0, %hi(scratch)
; CHECK-NEXT:    addi a0, a0, %lo(scratch)
; CHECK-NEXT:    vse64.v v26, (a0)
; CHECK-NEXT:    j .LBB5_5
; CHECK-NEXT:  .LBB5_3: # %if.then
; CHECK-NEXT:    vfadd.vv v25, v8, v9
; CHECK-NEXT:    andi a1, a1, 2
; CHECK-NEXT:    bnez a1, .LBB5_2
; CHECK-NEXT:  .LBB5_4: # %if.else5
; CHECK-NEXT:    vsetvli a0, a0, e32, m1, ta, mu
; CHECK-NEXT:    lui a0, %hi(.LCPI5_2)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_2)
; CHECK-NEXT:    vlse32.v v26, (a0), zero
; CHECK-NEXT:    lui a0, %hi(.LCPI5_3)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_3)
; CHECK-NEXT:    vlse32.v v27, (a0), zero
; CHECK-NEXT:    vfadd.vv v26, v26, v27
; CHECK-NEXT:    lui a0, %hi(scratch)
; CHECK-NEXT:    addi a0, a0, %lo(scratch)
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:  .LBB5_5: # %if.end10
; CHECK-NEXT:    vsetvli zero, a2, e64, m1, ta, mu
; CHECK-NEXT:    vfmul.vv v8, v25, v25
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %conv = zext i8 %cond to i32
  %and = and i32 %conv, 1
  %tobool = icmp eq i32 %and, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %and2 = and i32 %conv, 2
  %tobool3 = icmp eq i32 %and2, 0
  br i1 %tobool3, label %if.else5, label %if.then4

if.then4:                                         ; preds = %if.end
  %3 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %4 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(double 1.000000e+00, i64 %3)
  %5 = tail call <vscale x 1 x double> @llvm.riscv.vfmv.v.f.nxv1f64.f64(double 2.000000e+00, i64 %3)
  %6 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %4, <vscale x 1 x double> %5, i64 %3)
  %7 = bitcast i8* @scratch to <vscale x 1 x double>*
  tail call void @llvm.riscv.vse.nxv1f64(<vscale x 1 x double> %6, <vscale x 1 x double>* %7, i64 %3)
  br label %if.end10

if.else5:                                         ; preds = %if.end
  %8 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 0)
  %9 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(float 1.000000e+00, i64 %8)
  %10 = tail call <vscale x 2 x float> @llvm.riscv.vfmv.v.f.nxv2f32.f32(float 2.000000e+00, i64 %8)
  %11 = tail call <vscale x 2 x float> @llvm.riscv.vfadd.nxv2f32.nxv2f32(<vscale x 2 x float> %9, <vscale x 2 x float> %10, i64 %8)
  %12 = bitcast i8* @scratch to <vscale x 2 x float>*
  tail call void @llvm.riscv.vse.nxv2f32(<vscale x 2 x float> %11, <vscale x 2 x float>* %12, i64 %8)
  br label %if.end10

if.end10:                                         ; preds = %if.else5, %if.then4
  %13 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> %c.0, <vscale x 1 x double> %c.0, i64 %0)
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
; CHECK-NEXT:    vl1r.v v25, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl1r.v v26, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    vfsub.vv v8, v26, v25
; CHECK-NEXT:  .LBB6_3: # %if.then
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 1
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 32
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.else:                                          ; preds = %entry
  call void @foo()
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
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
; CHECK-NEXT:    vfadd.vv v25, v8, v9
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vs1r.v v25, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    add a0, a0, sp
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    call foo@plt
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl1r.v v25, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    add a0, a0, sp
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    j .LBB7_3
; CHECK-NEXT:  .LBB7_2: # %if.else
; CHECK-NEXT:    vfsub.vv v25, v8, v9
; CHECK-NEXT:  .LBB7_3: # %if.end
; CHECK-NEXT:    vsetvli zero, s0, e64, m1, ta, mu
; CHECK-NEXT:    vfmul.vv v8, v25, v8
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 1
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 32
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %tobool = icmp eq i8 %cond, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  call void @foo()
  br label %if.end

if.else:                                          ; preds = %entry
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfsub.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i64 %0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %c.0 = phi <vscale x 1 x double> [ %1, %if.then ], [ %2, %if.else ]
  %3 = tail call <vscale x 1 x double> @llvm.riscv.vfmul.nxv1f64.nxv1f64(<vscale x 1 x double> %c.0, <vscale x 1 x double> %a, i64 %0)
  ret <vscale x 1 x double> %3
}

define void @saxpy_vec(i64 %n, float %a, float* nocapture readonly %x, float* nocapture %y) {
; CHECK-LABEL: saxpy_vec:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a4, a0, e32, m8, ta, mu
; CHECK-NEXT:    beqz a4, .LBB8_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    fmv.w.x ft0, a1
; CHECK-NEXT:  .LBB8_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v8, (a2)
; CHECK-NEXT:    vle32.v v16, (a3)
; CHECK-NEXT:    slli a1, a4, 2
; CHECK-NEXT:    add a2, a2, a1
; CHECK-NEXT:    vsetvli zero, a4, e32, m8, tu, mu
; CHECK-NEXT:    vfmacc.vf v16, ft0, v8
; CHECK-NEXT:    vsetvli zero, zero, e32, m8, ta, mu
; CHECK-NEXT:    vse32.v v16, (a3)
; CHECK-NEXT:    sub a0, a0, a4
; CHECK-NEXT:    vsetvli a4, a0, e32, m8, ta, mu
; CHECK-NEXT:    add a3, a3, a1
; CHECK-NEXT:    bnez a4, .LBB8_2
; CHECK-NEXT:  .LBB8_3: # %for.end
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
  %3 = tail call <vscale x 16 x float> @llvm.riscv.vle.nxv16f32.i64(<vscale x 16 x float>* %2, i64 %1)
  %add.ptr = getelementptr inbounds float, float* %x.addr.015, i64 %1
  %4 = bitcast float* %y.addr.014 to <vscale x 16 x float>*
  %5 = tail call <vscale x 16 x float> @llvm.riscv.vle.nxv16f32.i64(<vscale x 16 x float>* %4, i64 %1)
  %6 = tail call <vscale x 16 x float> @llvm.riscv.vfmacc.nxv16f32.f32.i64(<vscale x 16 x float> %5, float %a, <vscale x 16 x float> %3, i64 %1)
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
declare <vscale x 16 x float> @llvm.riscv.vle.nxv16f32.i64(<vscale x 16 x float>* nocapture, i64)
declare <vscale x 16 x float> @llvm.riscv.vfmacc.nxv16f32.f32.i64(<vscale x 16 x float>, float, <vscale x 16 x float>, i64)
declare void @llvm.riscv.vse.nxv16f32.i64(<vscale x 16 x float>, <vscale x 16 x float>* nocapture, i64)
