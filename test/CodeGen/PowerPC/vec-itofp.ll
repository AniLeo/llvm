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

define void @test8(<8 x double>* nocapture %Sink, <8 x i16>* nocapture readonly %SrcPtr) {
; CHECK-P8-LABEL: test8:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI0_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI0_2@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI0_1@toc@ha
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    addi r5, r5, .LCPI0_0@toc@l
; CHECK-P8-NEXT:    addi r6, r6, .LCPI0_2@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI0_1@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI0_3@toc@ha
; CHECK-P8-NEXT:    lvx v5, 0, r6
; CHECK-P8-NEXT:    lvx v1, 0, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    addi r5, r5, .LCPI0_3@toc@l
; CHECK-P8-NEXT:    lvx v0, 0, r5
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    vperm v2, v4, v3, v2
; CHECK-P8-NEXT:    vperm v5, v4, v3, v5
; CHECK-P8-NEXT:    vperm v0, v4, v3, v0
; CHECK-P8-NEXT:    vperm v3, v4, v3, v1
; CHECK-P8-NEXT:    xvcvuxddp vs0, v2
; CHECK-P8-NEXT:    xvcvuxddp vs1, v5
; CHECK-P8-NEXT:    xvcvuxddp vs2, v0
; CHECK-P8-NEXT:    xvcvuxddp vs3, v3
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
; CHECK-P9-LABEL: test8:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI0_0@toc@ha
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addi r4, r4, .LCPI0_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI0_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI0_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxddp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI0_2@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI0_2@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs1, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI0_3@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI0_3@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs2, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI0_0@toc@ha
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addi r4, r4, .LCPI0_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI0_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI0_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    xvcvuxddp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI0_2@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI0_2@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs1, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI0_3@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI0_3@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs2, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <8 x i16>, <8 x i16>* %SrcPtr, align 16
  %1 = uitofp <8 x i16> %0 to <8 x double>
  store <8 x double> %1, <8 x double>* %Sink, align 16
  ret void
}

define void @test4(<4 x double>* nocapture %Sink, <4 x i16>* nocapture readonly %SrcPtr) {
; CHECK-P8-LABEL: test4:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI1_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI1_1@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    addi r5, r5, .LCPI1_0@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    addi r5, r6, .LCPI1_1@toc@l
; CHECK-P8-NEXT:    lvx v5, 0, r5
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
; CHECK-P9-LABEL: test4:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI1_0@toc@ha
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addi r4, r4, .LCPI1_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI1_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI1_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxddp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    xvcvuxddp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI1_0@toc@ha
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addi r4, r4, .LCPI1_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI1_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI1_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    xvcvuxddp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    xvcvuxddp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <4 x i16>, <4 x i16>* %SrcPtr, align 16
  %1 = uitofp <4 x i16> %0 to <4 x double>
  store <4 x double> %1, <4 x double>* %Sink, align 16
  ret void
}

define void @test2(<2 x double>* nocapture %Sink, <2 x i16>* nocapture readonly %SrcPtr) {
; CHECK-P8-LABEL: test2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI2_0@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    addi r5, r5, .LCPI2_0@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    vperm v2, v4, v3, v2
; CHECK-P8-NEXT:    xvcvuxddp vs0, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI2_0@toc@ha
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addi r4, r4, .LCPI2_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxddp vs0, v2
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI2_0@toc@ha
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addi r4, r4, .LCPI2_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    xvcvuxddp vs0, v2
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <2 x i16>, <2 x i16>* %SrcPtr, align 16
  %1 = uitofp <2 x i16> %0 to <2 x double>
  store <2 x double> %1, <2 x double>* %Sink, align 16
  ret void
}

define void @stest8(<8 x double>* nocapture %Sink, <8 x i16>* nocapture readonly %SrcPtr) {
; CHECK-P8-LABEL: stest8:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI3_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI3_2@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI3_1@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI3_0@toc@l
; CHECK-P8-NEXT:    addi r6, r6, .LCPI3_2@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI3_1@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI3_3@toc@ha
; CHECK-P8-NEXT:    lvx v4, 0, r6
; CHECK-P8-NEXT:    addis r6, r2, .LCPI3_4@toc@ha
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    addi r5, r5, .LCPI3_3@toc@l
; CHECK-P8-NEXT:    lvx v5, 0, r5
; CHECK-P8-NEXT:    addi r5, r6, .LCPI3_4@toc@l
; CHECK-P8-NEXT:    lvx v0, 0, r5
; CHECK-P8-NEXT:    vperm v2, v3, v3, v2
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    vperm v4, v3, v3, v4
; CHECK-P8-NEXT:    vperm v5, v3, v3, v5
; CHECK-P8-NEXT:    vperm v3, v3, v3, v0
; CHECK-P8-NEXT:    xxswapd v0, vs0
; CHECK-P8-NEXT:    vsld v2, v2, v0
; CHECK-P8-NEXT:    vsld v4, v4, v0
; CHECK-P8-NEXT:    vsld v5, v5, v0
; CHECK-P8-NEXT:    vsld v3, v3, v0
; CHECK-P8-NEXT:    vsrad v2, v2, v0
; CHECK-P8-NEXT:    vsrad v3, v3, v0
; CHECK-P8-NEXT:    vsrad v4, v4, v0
; CHECK-P8-NEXT:    vsrad v5, v5, v0
; CHECK-P8-NEXT:    xvcvsxddp vs2, v3
; CHECK-P8-NEXT:    xvcvsxddp vs0, v2
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
; CHECK-P9-LABEL: stest8:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_2@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_2@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs1, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs2, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: stest8:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    xvcvsxddp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_2@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_2@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    xvcvsxddp vs1, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    xvcvsxddp vs2, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <8 x i16>, <8 x i16>* %SrcPtr, align 16
  %1 = sitofp <8 x i16> %0 to <8 x double>
  store <8 x double> %1, <8 x double>* %Sink, align 16
  ret void
}

define void @stest4(<4 x double>* nocapture %Sink, <4 x i16>* nocapture readonly %SrcPtr) {
; CHECK-P8-LABEL: stest4:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI4_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI4_2@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI4_1@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI4_0@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI4_1@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    addi r5, r6, .LCPI4_2@toc@l
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lvx v4, 0, r5
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
; CHECK-P9-LABEL: stest4:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI4_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI4_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI4_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI4_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    xvcvsxddp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: stest4:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI4_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI4_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI4_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI4_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    xvcvsxddp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <4 x i16>, <4 x i16>* %SrcPtr, align 16
  %1 = sitofp <4 x i16> %0 to <4 x double>
  store <4 x double> %1, <4 x double>* %Sink, align 16
  ret void
}

define void @stest2(<2 x double>* nocapture %Sink, <2 x i16>* nocapture readonly %SrcPtr) {
; CHECK-P8-LABEL: stest2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI5_0@toc@ha
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI5_1@toc@ha
; CHECK-P8-NEXT:    addi r5, r5, .LCPI5_0@toc@l
; CHECK-P8-NEXT:    addi r4, r4, .LCPI5_1@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    vperm v2, v3, v3, v2
; CHECK-P8-NEXT:    xxswapd v3, vs0
; CHECK-P8-NEXT:    vsld v2, v2, v3
; CHECK-P8-NEXT:    vsrad v2, v2, v3
; CHECK-P8-NEXT:    xvcvsxddp vs0, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: stest2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI5_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI5_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xvcvsxddp vs0, v2
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: stest2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI5_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI5_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xvcvsxddp vs0, v2
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <2 x i16>, <2 x i16>* %SrcPtr, align 16
  %1 = sitofp <2 x i16> %0 to <2 x double>
  store <2 x double> %1, <2 x double>* %Sink, align 16
  ret void
}
