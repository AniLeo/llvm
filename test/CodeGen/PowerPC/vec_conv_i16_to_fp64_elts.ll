; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P9
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-BE

define <2 x double> @test2elt(i32 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r4, r2, .LCPI0_0@toc@ha
; CHECK-P8-NEXT:    mtvsrd f0, r3
; CHECK-P8-NEXT:    addi r3, r4, .LCPI0_0@toc@l
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    lvx v3, 0, r3
; CHECK-P8-NEXT:    vperm v2, v4, v2, v3
; CHECK-P8-NEXT:    xvcvuxddp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrws v2, r3
; CHECK-P9-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-P9-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r3
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxddp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrws v2, r3
; CHECK-BE-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-BE-NEXT:    lxvx v3, 0, r3
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    vperm v2, v2, v4, v3
; CHECK-BE-NEXT:    xvcvuxddp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i32 %a.coerce to <2 x i16>
  %1 = uitofp <2 x i16> %0 to <2 x double>
  ret <2 x double> %1
}

define void @test4elt(<4 x double>* noalias nocapture sret %agg.result, i64 %a.coerce) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI1_0@toc@ha
; CHECK-P8-NEXT:    mtvsrd f0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI1_1@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI1_0@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI1_1@toc@l
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    xxswapd v3, vs0
; CHECK-P8-NEXT:    lvx v5, 0, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    vperm v2, v4, v3, v2
; CHECK-P8-NEXT:    vperm v3, v4, v3, v5
; CHECK-P8-NEXT:    xvcvuxddp vs0, v2
; CHECK-P8-NEXT:    xvcvuxddp vs1, v3
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrd f0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI1_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI1_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    xxswapd v2, vs0
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI1_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI1_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxddp vs0, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrd v2, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI1_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI1_0@toc@l
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI1_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI1_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v4, v3
; CHECK-BE-NEXT:    xvcvuxddp vs0, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <4 x i16>
  %1 = uitofp <4 x i16> %0 to <4 x double>
  store <4 x double> %1, <4 x double>* %agg.result, align 32
  ret void
}

define void @test8elt(<8 x double>* noalias nocapture sret %agg.result, <8 x i16> %a) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r4, r2, .LCPI2_0@toc@ha
; CHECK-P8-NEXT:    addis r5, r2, .LCPI2_2@toc@ha
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    addi r4, r4, .LCPI2_0@toc@l
; CHECK-P8-NEXT:    addi r5, r5, .LCPI2_2@toc@l
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI2_3@toc@ha
; CHECK-P8-NEXT:    lvx v5, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI2_1@toc@ha
; CHECK-P8-NEXT:    addi r4, r4, .LCPI2_3@toc@l
; CHECK-P8-NEXT:    addi r5, r5, .LCPI2_1@toc@l
; CHECK-P8-NEXT:    lvx v0, 0, r4
; CHECK-P8-NEXT:    lvx v1, 0, r5
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    vperm v3, v4, v2, v3
; CHECK-P8-NEXT:    vperm v5, v4, v2, v5
; CHECK-P8-NEXT:    vperm v0, v4, v2, v0
; CHECK-P8-NEXT:    vperm v2, v4, v2, v1
; CHECK-P8-NEXT:    xvcvuxddp vs0, v3
; CHECK-P8-NEXT:    xvcvuxddp vs1, v5
; CHECK-P8-NEXT:    xvcvuxddp vs2, v0
; CHECK-P8-NEXT:    xvcvuxddp vs3, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addis r4, r2, .LCPI2_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI2_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI2_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI2_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxddp vs0, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI2_2@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI2_2@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs1, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI2_3@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI2_3@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs2, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r4, r2, .LCPI2_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI2_0@toc@l
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI2_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI2_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v4, v3
; CHECK-BE-NEXT:    xvcvuxddp vs0, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI2_2@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI2_2@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs1, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI2_3@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI2_3@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs2, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = uitofp <8 x i16> %a to <8 x double>
  store <8 x double> %0, <8 x double>* %agg.result, align 64
  ret void
}

define void @test16elt(<16 x double>* noalias nocapture sret %agg.result, <16 x i16>* nocapture readonly) local_unnamed_addr #3 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r6, r2, .LCPI3_2@toc@ha
; CHECK-P8-NEXT:    addis r5, r2, .LCPI3_0@toc@ha
; CHECK-P8-NEXT:    lvx v4, 0, r4
; CHECK-P8-NEXT:    xxlxor v3, v3, v3
; CHECK-P8-NEXT:    addi r6, r6, .LCPI3_2@toc@l
; CHECK-P8-NEXT:    addi r5, r5, .LCPI3_0@toc@l
; CHECK-P8-NEXT:    lvx v5, 0, r6
; CHECK-P8-NEXT:    li r6, 16
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI3_1@toc@ha
; CHECK-P8-NEXT:    lvx v0, r4, r6
; CHECK-P8-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI3_1@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-P8-NEXT:    lvx v1, 0, r5
; CHECK-P8-NEXT:    li r5, 96
; CHECK-P8-NEXT:    lvx v8, 0, r4
; CHECK-P8-NEXT:    vperm v6, v3, v4, v2
; CHECK-P8-NEXT:    li r4, 112
; CHECK-P8-NEXT:    vperm v7, v3, v4, v5
; CHECK-P8-NEXT:    vperm v2, v3, v0, v2
; CHECK-P8-NEXT:    vperm v9, v3, v0, v1
; CHECK-P8-NEXT:    vperm v5, v3, v0, v5
; CHECK-P8-NEXT:    vperm v0, v3, v0, v8
; CHECK-P8-NEXT:    vperm v1, v3, v4, v1
; CHECK-P8-NEXT:    vperm v3, v3, v4, v8
; CHECK-P8-NEXT:    xvcvuxddp vs1, v2
; CHECK-P8-NEXT:    xvcvuxddp vs4, v9
; CHECK-P8-NEXT:    xvcvuxddp vs2, v5
; CHECK-P8-NEXT:    xvcvuxddp vs3, v0
; CHECK-P8-NEXT:    xvcvuxddp vs0, v7
; CHECK-P8-NEXT:    xvcvuxddp vs5, v3
; CHECK-P8-NEXT:    xvcvuxddp vs6, v6
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xvcvuxddp vs7, v1
; CHECK-P8-NEXT:    xxswapd vs4, vs4
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs5, vs5
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r5
; CHECK-P8-NEXT:    li r4, 80
; CHECK-P8-NEXT:    li r5, 64
; CHECK-P8-NEXT:    xxswapd vs2, vs7
; CHECK-P8-NEXT:    xxswapd vs3, vs6
; CHECK-P8-NEXT:    stxvd2x vs4, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r5
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    stxvd2x vs5, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 16(r4)
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_0@toc@l
; CHECK-P9-NEXT:    lxvx v4, 0, r4
; CHECK-P9-NEXT:    xxlxor v5, v5, v5
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_1@toc@l
; CHECK-P9-NEXT:    vperm v0, v5, v3, v4
; CHECK-P9-NEXT:    xvcvuxddp vs0, v0
; CHECK-P9-NEXT:    lxvx v0, 0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_2@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_2@toc@l
; CHECK-P9-NEXT:    vperm v1, v5, v3, v0
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs1, v1
; CHECK-P9-NEXT:    lxvx v1, 0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-P9-NEXT:    vperm v6, v5, v3, v1
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs2, v6
; CHECK-P9-NEXT:    lxvx v6, 0, r4
; CHECK-P9-NEXT:    vperm v3, v5, v3, v6
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs3, v3
; CHECK-P9-NEXT:    vperm v3, v5, v2, v4
; CHECK-P9-NEXT:    xvcvuxddp vs4, v3
; CHECK-P9-NEXT:    vperm v3, v5, v2, v0
; CHECK-P9-NEXT:    xvcvuxddp vs5, v3
; CHECK-P9-NEXT:    vperm v3, v5, v2, v1
; CHECK-P9-NEXT:    vperm v2, v5, v2, v6
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs6, v3
; CHECK-P9-NEXT:    xvcvuxddp vs7, v2
; CHECK-P9-NEXT:    stxv vs4, 64(r3)
; CHECK-P9-NEXT:    stxv vs5, 80(r3)
; CHECK-P9-NEXT:    stxv vs7, 112(r3)
; CHECK-P9-NEXT:    stxv vs6, 96(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 16(r4)
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_0@toc@l
; CHECK-BE-NEXT:    lxvx v4, 0, r4
; CHECK-BE-NEXT:    xxlxor v5, v5, v5
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_1@toc@l
; CHECK-BE-NEXT:    vperm v0, v3, v5, v4
; CHECK-BE-NEXT:    xvcvuxddp vs0, v0
; CHECK-BE-NEXT:    lxvx v0, 0, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_2@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_2@toc@l
; CHECK-BE-NEXT:    vperm v1, v5, v3, v0
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs1, v1
; CHECK-BE-NEXT:    lxvx v1, 0, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-BE-NEXT:    vperm v6, v5, v3, v1
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs2, v6
; CHECK-BE-NEXT:    lxvx v6, 0, r4
; CHECK-BE-NEXT:    vperm v3, v5, v3, v6
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs3, v3
; CHECK-BE-NEXT:    vperm v3, v2, v5, v4
; CHECK-BE-NEXT:    xvcvuxddp vs4, v3
; CHECK-BE-NEXT:    vperm v3, v5, v2, v0
; CHECK-BE-NEXT:    xvcvuxddp vs5, v3
; CHECK-BE-NEXT:    vperm v3, v5, v2, v1
; CHECK-BE-NEXT:    vperm v2, v5, v2, v6
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs6, v3
; CHECK-BE-NEXT:    xvcvuxddp vs7, v2
; CHECK-BE-NEXT:    stxv vs4, 64(r3)
; CHECK-BE-NEXT:    stxv vs5, 80(r3)
; CHECK-BE-NEXT:    stxv vs7, 112(r3)
; CHECK-BE-NEXT:    stxv vs6, 96(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i16>, <16 x i16>* %0, align 32
  %1 = uitofp <16 x i16> %a to <16 x double>
  store <16 x double> %1, <16 x double>* %agg.result, align 128
  ret void
}

define <2 x double> @test2elt_signed(i32 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r4, r2, .LCPI4_0@toc@ha
; CHECK-P8-NEXT:    mtvsrd f0, r3
; CHECK-P8-NEXT:    addi r3, r4, .LCPI4_0@toc@l
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    lvx v3, 0, r3
; CHECK-P8-NEXT:    addis r3, r2, .LCPI4_1@toc@ha
; CHECK-P8-NEXT:    addi r3, r3, .LCPI4_1@toc@l
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    vperm v2, v2, v2, v3
; CHECK-P8-NEXT:    xxswapd v3, vs0
; CHECK-P8-NEXT:    vsld v2, v2, v3
; CHECK-P8-NEXT:    vsrad v2, v2, v3
; CHECK-P8-NEXT:    xvcvsxddp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrws v2, r3
; CHECK-P9-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-P9-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r3
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrws v2, r3
; CHECK-BE-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-BE-NEXT:    lxvx v3, 0, r3
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i32 %a.coerce to <2 x i16>
  %1 = sitofp <2 x i16> %0 to <2 x double>
  ret <2 x double> %1
}

define void @test4elt_signed(<4 x double>* noalias nocapture sret %agg.result, i64 %a.coerce) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI5_0@toc@ha
; CHECK-P8-NEXT:    mtvsrd f0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI5_2@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI5_0@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI5_2@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    xxswapd v3, vs0
; CHECK-P8-NEXT:    lvx v4, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI5_1@toc@ha
; CHECK-P8-NEXT:    addi r4, r4, .LCPI5_1@toc@l
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    vperm v2, v3, v3, v2
; CHECK-P8-NEXT:    vperm v3, v3, v3, v4
; CHECK-P8-NEXT:    xxswapd v4, vs0
; CHECK-P8-NEXT:    vsld v2, v2, v4
; CHECK-P8-NEXT:    vsld v3, v3, v4
; CHECK-P8-NEXT:    vsrad v2, v2, v4
; CHECK-P8-NEXT:    vsrad v3, v3, v4
; CHECK-P8-NEXT:    xvcvsxddp vs0, v2
; CHECK-P8-NEXT:    xvcvsxddp vs1, v3
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrd f0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI5_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI5_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    xxswapd v2, vs0
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    addis r4, r2, .LCPI5_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI5_1@toc@l
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs0, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrd v2, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI5_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI5_0@toc@l
; CHECK-BE-NEXT:    lxvx v4, 0, r4
; CHECK-BE-NEXT:    xxlxor v3, v3, v3
; CHECK-BE-NEXT:    vperm v3, v3, v2, v4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI5_1@toc@ha
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    addi r4, r4, .LCPI5_1@toc@l
; CHECK-BE-NEXT:    xvcvsxddp vs0, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 16(r3)
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <4 x i16>
  %1 = sitofp <4 x i16> %0 to <4 x double>
  store <4 x double> %1, <4 x double>* %agg.result, align 32
  ret void
}

define void @test8elt_signed(<8 x double>* noalias nocapture sret %agg.result, <8 x i16> %a) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI6_2@toc@ha
; CHECK-P8-NEXT:    addis r4, r2, .LCPI6_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI6_3@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI6_2@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI6_0@toc@l
; CHECK-P8-NEXT:    addi r6, r6, .LCPI6_3@toc@l
; CHECK-P8-NEXT:    lvx v4, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI6_4@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    lvx v5, 0, r6
; CHECK-P8-NEXT:    addis r4, r2, .LCPI6_1@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI6_4@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI6_1@toc@l
; CHECK-P8-NEXT:    lvx v0, 0, r5
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    vperm v3, v2, v2, v3
; CHECK-P8-NEXT:    vperm v4, v2, v2, v4
; CHECK-P8-NEXT:    vperm v5, v2, v2, v5
; CHECK-P8-NEXT:    vperm v2, v2, v2, v0
; CHECK-P8-NEXT:    xxswapd v0, vs0
; CHECK-P8-NEXT:    vsld v3, v3, v0
; CHECK-P8-NEXT:    vsld v4, v4, v0
; CHECK-P8-NEXT:    vsld v5, v5, v0
; CHECK-P8-NEXT:    vsld v2, v2, v0
; CHECK-P8-NEXT:    vsrad v3, v3, v0
; CHECK-P8-NEXT:    vsrad v2, v2, v0
; CHECK-P8-NEXT:    vsrad v4, v4, v0
; CHECK-P8-NEXT:    vsrad v5, v5, v0
; CHECK-P8-NEXT:    xvcvsxddp vs2, v2
; CHECK-P8-NEXT:    xvcvsxddp vs0, v3
; CHECK-P8-NEXT:    xvcvsxddp vs1, v5
; CHECK-P8-NEXT:    xvcvsxddp vs3, v4
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addis r4, r2, .LCPI6_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI6_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI6_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI6_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs0, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI6_2@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI6_2@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs1, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI6_3@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI6_3@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs2, v3
; CHECK-P9-NEXT:    lxvx v3, 0, r4
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r4, r2, .LCPI6_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI6_0@toc@l
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    addis r4, r2, .LCPI6_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI6_1@toc@l
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    xvcvsxddp vs0, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI6_2@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI6_2@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 16(r3)
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    xvcvsxddp vs1, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI6_3@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI6_3@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs1, 32(r3)
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    xvcvsxddp vs2, v3
; CHECK-BE-NEXT:    lxvx v3, 0, r4
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs2, 48(r3)
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = sitofp <8 x i16> %a to <8 x double>
  store <8 x double> %0, <8 x double>* %agg.result, align 64
  ret void
}

define void @test16elt_signed(<16 x double>* noalias nocapture sret %agg.result, <16 x i16>* nocapture readonly) local_unnamed_addr #3 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI7_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI7_2@toc@ha
; CHECK-P8-NEXT:    lvx v4, 0, r4
; CHECK-P8-NEXT:    addi r5, r5, .LCPI7_0@toc@l
; CHECK-P8-NEXT:    addi r6, r6, .LCPI7_2@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI7_3@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r6
; CHECK-P8-NEXT:    addis r6, r2, .LCPI7_4@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI7_3@toc@l
; CHECK-P8-NEXT:    addi r6, r6, .LCPI7_4@toc@l
; CHECK-P8-NEXT:    lvx v5, 0, r5
; CHECK-P8-NEXT:    lvx v0, 0, r6
; CHECK-P8-NEXT:    li r6, 16
; CHECK-P8-NEXT:    addis r5, r2, .LCPI7_1@toc@ha
; CHECK-P8-NEXT:    lvx v7, r4, r6
; CHECK-P8-NEXT:    addi r5, r5, .LCPI7_1@toc@l
; CHECK-P8-NEXT:    vperm v1, v4, v4, v2
; CHECK-P8-NEXT:    li r4, 112
; CHECK-P8-NEXT:    vperm v6, v4, v4, v3
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r5
; CHECK-P8-NEXT:    li r5, 96
; CHECK-P8-NEXT:    vperm v8, v4, v4, v5
; CHECK-P8-NEXT:    vperm v4, v4, v4, v0
; CHECK-P8-NEXT:    vperm v5, v7, v7, v5
; CHECK-P8-NEXT:    xxswapd v9, vs0
; CHECK-P8-NEXT:    vperm v0, v7, v7, v0
; CHECK-P8-NEXT:    vperm v2, v7, v7, v2
; CHECK-P8-NEXT:    vperm v3, v7, v7, v3
; CHECK-P8-NEXT:    vsld v1, v1, v9
; CHECK-P8-NEXT:    vsld v6, v6, v9
; CHECK-P8-NEXT:    vsld v5, v5, v9
; CHECK-P8-NEXT:    vsld v0, v0, v9
; CHECK-P8-NEXT:    vsld v2, v2, v9
; CHECK-P8-NEXT:    vsld v3, v3, v9
; CHECK-P8-NEXT:    vsrad v5, v5, v9
; CHECK-P8-NEXT:    vsrad v0, v0, v9
; CHECK-P8-NEXT:    vsld v7, v8, v9
; CHECK-P8-NEXT:    vsld v4, v4, v9
; CHECK-P8-NEXT:    vsrad v2, v2, v9
; CHECK-P8-NEXT:    vsrad v3, v3, v9
; CHECK-P8-NEXT:    xvcvsxddp vs2, v5
; CHECK-P8-NEXT:    xvcvsxddp vs3, v0
; CHECK-P8-NEXT:    vsrad v1, v1, v9
; CHECK-P8-NEXT:    vsrad v6, v6, v9
; CHECK-P8-NEXT:    vsrad v7, v7, v9
; CHECK-P8-NEXT:    vsrad v4, v4, v9
; CHECK-P8-NEXT:    xvcvsxddp vs1, v2
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xvcvsxddp vs4, v3
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xvcvsxddp vs0, v7
; CHECK-P8-NEXT:    xvcvsxddp vs5, v4
; CHECK-P8-NEXT:    xvcvsxddp vs6, v1
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    li r4, 80
; CHECK-P8-NEXT:    xvcvsxddp vs7, v6
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r5
; CHECK-P8-NEXT:    li r5, 64
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xxswapd vs4, vs4
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs5, vs5
; CHECK-P8-NEXT:    xxswapd vs3, vs6
; CHECK-P8-NEXT:    stxvd2x vs4, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    xxswapd vs2, vs7
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r5
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    stxvd2x vs5, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addis r5, r2, .LCPI7_0@toc@ha
; CHECK-P9-NEXT:    addi r5, r5, .LCPI7_0@toc@l
; CHECK-P9-NEXT:    lxv v2, 0(r4)
; CHECK-P9-NEXT:    lxvx v3, 0, r5
; CHECK-P9-NEXT:    addis r5, r2, .LCPI7_1@toc@ha
; CHECK-P9-NEXT:    addi r5, r5, .LCPI7_1@toc@l
; CHECK-P9-NEXT:    lxvx v5, 0, r5
; CHECK-P9-NEXT:    addis r5, r2, .LCPI7_2@toc@ha
; CHECK-P9-NEXT:    vperm v4, v2, v2, v3
; CHECK-P9-NEXT:    addi r5, r5, .LCPI7_2@toc@l
; CHECK-P9-NEXT:    vextsh2d v4, v4
; CHECK-P9-NEXT:    lxvx v0, 0, r5
; CHECK-P9-NEXT:    addis r5, r2, .LCPI7_3@toc@ha
; CHECK-P9-NEXT:    xvcvsxddp vs0, v4
; CHECK-P9-NEXT:    vperm v4, v2, v2, v5
; CHECK-P9-NEXT:    addi r5, r5, .LCPI7_3@toc@l
; CHECK-P9-NEXT:    lxvx v1, 0, r5
; CHECK-P9-NEXT:    vextsh2d v4, v4
; CHECK-P9-NEXT:    xvcvsxddp vs1, v4
; CHECK-P9-NEXT:    vperm v4, v2, v2, v0
; CHECK-P9-NEXT:    vperm v2, v2, v2, v1
; CHECK-P9-NEXT:    vextsh2d v4, v4
; CHECK-P9-NEXT:    xvcvsxddp vs2, v4
; CHECK-P9-NEXT:    lxv v4, 16(r4)
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs3, v2
; CHECK-P9-NEXT:    vperm v2, v4, v4, v3
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    xvcvsxddp vs4, v2
; CHECK-P9-NEXT:    vperm v2, v4, v4, v5
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs5, v2
; CHECK-P9-NEXT:    vperm v2, v4, v4, v0
; CHECK-P9-NEXT:    stxv vs4, 64(r3)
; CHECK-P9-NEXT:    stxv vs5, 80(r3)
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs6, v2
; CHECK-P9-NEXT:    vperm v2, v4, v4, v1
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    stxv vs6, 96(r3)
; CHECK-P9-NEXT:    xvcvsxddp vs7, v2
; CHECK-P9-NEXT:    stxv vs7, 112(r3)
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r5, r2, .LCPI7_0@toc@ha
; CHECK-BE-NEXT:    addi r5, r5, .LCPI7_0@toc@l
; CHECK-BE-NEXT:    lxvx v2, 0, r5
; CHECK-BE-NEXT:    lxv v5, 0(r4)
; CHECK-BE-NEXT:    lxv v6, 16(r4)
; CHECK-BE-NEXT:    addis r5, r2, .LCPI7_1@toc@ha
; CHECK-BE-NEXT:    addi r5, r5, .LCPI7_1@toc@l
; CHECK-BE-NEXT:    addis r4, r2, .LCPI7_3@toc@ha
; CHECK-BE-NEXT:    xxlxor v0, v0, v0
; CHECK-BE-NEXT:    vperm v1, v0, v5, v2
; CHECK-BE-NEXT:    lxvx v3, 0, r5
; CHECK-BE-NEXT:    vperm v2, v0, v6, v2
; CHECK-BE-NEXT:    addis r5, r2, .LCPI7_2@toc@ha
; CHECK-BE-NEXT:    addi r5, r5, .LCPI7_2@toc@l
; CHECK-BE-NEXT:    addi r4, r4, .LCPI7_3@toc@l
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    lxvx v4, 0, r5
; CHECK-BE-NEXT:    vextsh2d v1, v1
; CHECK-BE-NEXT:    xvcvsxddp vs3, v2
; CHECK-BE-NEXT:    vperm v2, v0, v6, v3
; CHECK-BE-NEXT:    xvcvsxddp vs0, v1
; CHECK-BE-NEXT:    vperm v1, v0, v5, v3
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs4, v2
; CHECK-BE-NEXT:    vperm v2, v0, v6, v4
; CHECK-BE-NEXT:    vextsh2d v1, v1
; CHECK-BE-NEXT:    xvcvsxddp vs1, v1
; CHECK-BE-NEXT:    vperm v1, v0, v5, v4
; CHECK-BE-NEXT:    stxv vs3, 80(r3)
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs5, v2
; CHECK-BE-NEXT:    lxvx v2, 0, r4
; CHECK-BE-NEXT:    vperm v3, v5, v5, v2
; CHECK-BE-NEXT:    vperm v2, v6, v6, v2
; CHECK-BE-NEXT:    vextsh2d v1, v1
; CHECK-BE-NEXT:    stxv vs4, 96(r3)
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs2, v1
; CHECK-BE-NEXT:    stxv vs2, 48(r3)
; CHECK-BE-NEXT:    stxv vs5, 112(r3)
; CHECK-BE-NEXT:    xvcvsxddp vs6, v3
; CHECK-BE-NEXT:    xvcvsxddp vs7, v2
; CHECK-BE-NEXT:    stxv vs7, 64(r3)
; CHECK-BE-NEXT:    stxv vs1, 32(r3)
; CHECK-BE-NEXT:    stxv vs0, 16(r3)
; CHECK-BE-NEXT:    stxv vs6, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i16>, <16 x i16>* %0, align 32
  %1 = sitofp <16 x i16> %a to <16 x double>
  store <16 x double> %1, <16 x double>* %agg.result, align 128
  ret void
}
