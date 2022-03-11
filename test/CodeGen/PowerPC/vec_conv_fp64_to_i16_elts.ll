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

define i32 @test2elt(<2 x double> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvdpsxws f1, v2
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    vmrghh v2, v2, v3
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpsxws f0, v2
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    li r3, 0
; CHECK-P9-NEXT:    vmrghh v2, v3, v2
; CHECK-P9-NEXT:    vextuwrx r3, r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xscvdpsxws f0, v2
; CHECK-BE-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r3)
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    li r3, 0
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    vextuwlx r3, r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptoui <2 x double> %a to <2 x i16>
  %1 = bitcast <2 x i16> %0 to i32
  ret i32 %1
}

define i64 @test4elt(<4 x double>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    xscvdpsxws f2, f0
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xscvdpsxws f3, f1
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    vmrghh v2, v4, v2
; CHECK-P8-NEXT:    vmrghh v3, v5, v3
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs1, 0(r3)
; CHECK-P9-NEXT:    lxv vs0, 16(r3)
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-BE-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f2, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v5, r3
; CHECK-BE-NEXT:    vperm v2, v4, v5, v2
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v3
; CHECK-BE-NEXT:    mffprd r3, f0
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x double>, <4 x double>* %0, align 32
  %1 = fptoui <4 x double> %a to <4 x i16>
  %2 = bitcast <4 x i16> %1 to i64
  ret i64 %2
}

define <8 x i16> @test8elt(<8 x double>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    lxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    lxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    xscvdpsxws f4, f0
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xscvdpsxws f5, f1
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xscvdpsxws f6, f2
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xscvdpsxws f7, f3
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mffprwz r3, f4
; CHECK-P8-NEXT:    mffprwz r4, f5
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mffprwz r3, f6
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r4, f7
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    vmrghh v2, v0, v2
; CHECK-P8-NEXT:    vmrghh v3, v1, v3
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    vmrghh v4, v0, v4
; CHECK-P8-NEXT:    vmrghh v5, v1, v5
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    xxmrglw vs1, v5, v4
; CHECK-P8-NEXT:    xxmrgld v2, vs1, vs0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs3, 0(r3)
; CHECK-P9-NEXT:    lxv vs2, 16(r3)
; CHECK-P9-NEXT:    lxv vs0, 48(r3)
; CHECK-P9-NEXT:    lxv vs1, 32(r3)
; CHECK-P9-NEXT:    xscvdpsxws f4, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    mffprwz r3, f4
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xxmrglw vs2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    xxmrgld v2, vs0, vs2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-BE-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f4, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    mffprwz r3, f4
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mtvsrwz v5, r3
; CHECK-BE-NEXT:    vperm v4, v4, v5, v2
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xxmrghw vs2, v4, v3
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v5, r3
; CHECK-BE-NEXT:    vperm v2, v4, v5, v2
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v3
; CHECK-BE-NEXT:    xxmrghd v2, vs0, vs2
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x double>, <8 x double>* %0, align 64
  %1 = fptoui <8 x double> %a to <8 x i16>
  ret <8 x i16> %1
}

define void @test16elt(<16 x i16>* noalias nocapture sret(<16 x i16>) %agg.result, <16 x double>* nocapture readonly) local_unnamed_addr #3 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 48
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r6
; CHECK-P8-NEXT:    li r6, 64
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs5, r4, r6
; CHECK-P8-NEXT:    li r7, 80
; CHECK-P8-NEXT:    li r6, 96
; CHECK-P8-NEXT:    xscvdpsxws f4, f0
; CHECK-P8-NEXT:    lxvd2x vs7, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs10, r4, r6
; CHECK-P8-NEXT:    li r6, 112
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xscvdpsxws f6, f1
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xscvdpsxws f8, f2
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xscvdpsxws f9, f3
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xscvdpsxws f11, f5
; CHECK-P8-NEXT:    xxswapd vs5, vs5
; CHECK-P8-NEXT:    xscvdpsxws f12, f7
; CHECK-P8-NEXT:    xxswapd vs7, vs7
; CHECK-P8-NEXT:    mffprwz r7, f4
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r6
; CHECK-P8-NEXT:    mffprwz r4, f6
; CHECK-P8-NEXT:    xscvdpsxws f13, f10
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r4, f8
; CHECK-P8-NEXT:    xscvdpsxws f6, f4
; CHECK-P8-NEXT:    mtvsrd v4, r4
; CHECK-P8-NEXT:    mffprwz r4, f9
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    mffprwz r4, f11
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    mtvsrd v0, r4
; CHECK-P8-NEXT:    mffprwz r4, f12
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    mffprwz r4, f13
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mtvsrd v6, r4
; CHECK-P8-NEXT:    mffprwz r4, f6
; CHECK-P8-NEXT:    xxswapd vs6, vs10
; CHECK-P8-NEXT:    xscvdpsxws f5, f5
; CHECK-P8-NEXT:    mtvsrd v7, r4
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    xxswapd vs0, vs4
; CHECK-P8-NEXT:    mtvsrd v2, r7
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    xscvdpsxws f7, f7
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    mffprwz r4, f2
; CHECK-P8-NEXT:    xscvdpsxws f4, f6
; CHECK-P8-NEXT:    vmrghh v2, v8, v2
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    vmrghh v3, v9, v3
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    mffprwz r4, f5
; CHECK-P8-NEXT:    vmrghh v4, v8, v4
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f7
; CHECK-P8-NEXT:    vmrghh v5, v9, v5
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    mffprwz r4, f4
; CHECK-P8-NEXT:    vmrghh v0, v8, v0
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    vmrghh v1, v9, v1
; CHECK-P8-NEXT:    xxmrglw vs1, v5, v4
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    vmrghh v6, v8, v6
; CHECK-P8-NEXT:    vmrghh v7, v9, v7
; CHECK-P8-NEXT:    xxmrgld v2, vs1, vs0
; CHECK-P8-NEXT:    xxmrglw vs2, v1, v0
; CHECK-P8-NEXT:    stvx v2, 0, r3
; CHECK-P8-NEXT:    xxmrglw vs3, v7, v6
; CHECK-P8-NEXT:    xxmrgld v3, vs3, vs2
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs2, 0(r4)
; CHECK-P9-NEXT:    lxv vs1, 16(r4)
; CHECK-P9-NEXT:    lxv vs0, 32(r4)
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xscvdpsxws f4, f1
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    xscvdpsxws f5, f0
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    mffprwz r5, f3
; CHECK-P9-NEXT:    lxv vs3, 64(r4)
; CHECK-P9-NEXT:    mtvsrd v2, r5
; CHECK-P9-NEXT:    mffprwz r5, f4
; CHECK-P9-NEXT:    lxv vs4, 48(r4)
; CHECK-P9-NEXT:    mtvsrd v3, r5
; CHECK-P9-NEXT:    mffprwz r5, f5
; CHECK-P9-NEXT:    xscvdpsxws f7, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    mtvsrd v4, r5
; CHECK-P9-NEXT:    mffprwz r5, f2
; CHECK-P9-NEXT:    lxv vs2, 80(r4)
; CHECK-P9-NEXT:    xscvdpsxws f5, f4
; CHECK-P9-NEXT:    xxswapd vs4, vs4
; CHECK-P9-NEXT:    mtvsrd v5, r5
; CHECK-P9-NEXT:    mffprwz r5, f1
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    lxv vs1, 96(r4)
; CHECK-P9-NEXT:    xscvdpsxws f4, f4
; CHECK-P9-NEXT:    vmrghh v2, v2, v5
; CHECK-P9-NEXT:    mtvsrd v5, r5
; CHECK-P9-NEXT:    mffprwz r5, f0
; CHECK-P9-NEXT:    lxv vs0, 112(r4)
; CHECK-P9-NEXT:    vmrghh v3, v3, v5
; CHECK-P9-NEXT:    mtvsrd v5, r5
; CHECK-P9-NEXT:    mffprwz r4, f5
; CHECK-P9-NEXT:    vmrghh v4, v4, v5
; CHECK-P9-NEXT:    xxmrglw vs6, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    mffprwz r4, f4
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    mffprwz r4, f7
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    mffprwz r4, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    xxmrglw vs4, v2, v4
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    vmrghh v2, v3, v2
; CHECK-P9-NEXT:    xxmrgld vs4, vs4, vs6
; CHECK-P9-NEXT:    mffprwz r4, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    stxv vs4, 0(r3)
; CHECK-P9-NEXT:    mffprwz r4, f2
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mtvsrd v4, r4
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r4, f3
; CHECK-P9-NEXT:    xxmrglw vs2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    mffprwz r4, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r4, f1
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    mffprwz r4, f0
; CHECK-P9-NEXT:    mtvsrd v4, r4
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    xxmrgld vs0, vs0, vs2
; CHECK-P9-NEXT:    stxv vs0, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs2, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 32(r4)
; CHECK-BE-NEXT:    lxv vs0, 16(r4)
; CHECK-BE-NEXT:    addis r5, r2, .LCPI3_0@toc@ha
; CHECK-BE-NEXT:    addi r5, r5, .LCPI3_0@toc@l
; CHECK-BE-NEXT:    lxv v2, 0(r5)
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xscvdpsxws f4, f1
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    xscvdpsxws f5, f0
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    mffprwz r5, f3
; CHECK-BE-NEXT:    lxv vs3, 112(r4)
; CHECK-BE-NEXT:    mtvsrwz v3, r5
; CHECK-BE-NEXT:    mffprwz r5, f4
; CHECK-BE-NEXT:    lxv vs4, 0(r4)
; CHECK-BE-NEXT:    mtvsrwz v4, r5
; CHECK-BE-NEXT:    mffprwz r5, f5
; CHECK-BE-NEXT:    xscvdpsxws f7, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    mtvsrwz v5, r5
; CHECK-BE-NEXT:    mffprwz r5, f2
; CHECK-BE-NEXT:    lxv vs2, 96(r4)
; CHECK-BE-NEXT:    xscvdpsxws f5, f4
; CHECK-BE-NEXT:    xxswapd vs4, vs4
; CHECK-BE-NEXT:    mtvsrwz v0, r5
; CHECK-BE-NEXT:    mffprwz r5, f1
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    lxv vs1, 80(r4)
; CHECK-BE-NEXT:    xscvdpsxws f4, f4
; CHECK-BE-NEXT:    vperm v3, v3, v0, v2
; CHECK-BE-NEXT:    mtvsrwz v0, r5
; CHECK-BE-NEXT:    mffprwz r5, f0
; CHECK-BE-NEXT:    lxv vs0, 64(r4)
; CHECK-BE-NEXT:    vperm v4, v4, v0, v2
; CHECK-BE-NEXT:    mtvsrwz v0, r5
; CHECK-BE-NEXT:    mffprwz r4, f5
; CHECK-BE-NEXT:    vperm v5, v5, v0, v2
; CHECK-BE-NEXT:    xxmrghw vs6, v4, v3
; CHECK-BE-NEXT:    mtvsrwz v3, r4
; CHECK-BE-NEXT:    mffprwz r4, f4
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    mffprwz r4, f7
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    mffprwz r4, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xxmrghw vs4, v3, v5
; CHECK-BE-NEXT:    mtvsrwz v3, r4
; CHECK-BE-NEXT:    vperm v3, v4, v3, v2
; CHECK-BE-NEXT:    xxmrghd vs4, vs4, vs6
; CHECK-BE-NEXT:    mffprwz r4, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    stxv vs4, 0(r3)
; CHECK-BE-NEXT:    mffprwz r4, f2
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mtvsrwz v5, r4
; CHECK-BE-NEXT:    vperm v4, v4, v5, v2
; CHECK-BE-NEXT:    mffprwz r4, f3
; CHECK-BE-NEXT:    xxmrghw vs2, v4, v3
; CHECK-BE-NEXT:    mtvsrwz v3, r4
; CHECK-BE-NEXT:    mffprwz r4, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r4, f1
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    mffprwz r4, f0
; CHECK-BE-NEXT:    mtvsrwz v5, r4
; CHECK-BE-NEXT:    vperm v2, v4, v5, v2
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v3
; CHECK-BE-NEXT:    xxmrghd vs0, vs0, vs2
; CHECK-BE-NEXT:    stxv vs0, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x double>, <16 x double>* %0, align 128
  %1 = fptoui <16 x double> %a to <16 x i16>
  store <16 x i16> %1, <16 x i16>* %agg.result, align 32
  ret void
}

define i32 @test2elt_signed(<2 x double> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvdpsxws f1, v2
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    vmrghh v2, v2, v3
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpsxws f0, v2
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    li r3, 0
; CHECK-P9-NEXT:    vmrghh v2, v3, v2
; CHECK-P9-NEXT:    vextuwrx r3, r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xscvdpsxws f0, v2
; CHECK-BE-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r3)
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    li r3, 0
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    vextuwlx r3, r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptosi <2 x double> %a to <2 x i16>
  %1 = bitcast <2 x i16> %0 to i32
  ret i32 %1
}

define i64 @test4elt_signed(<4 x double>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    xscvdpsxws f2, f0
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xscvdpsxws f3, f1
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    vmrghh v2, v4, v2
; CHECK-P8-NEXT:    vmrghh v3, v5, v3
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs1, 0(r3)
; CHECK-P9-NEXT:    lxv vs0, 16(r3)
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI5_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI5_0@toc@l
; CHECK-BE-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f2, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v5, r3
; CHECK-BE-NEXT:    vperm v2, v4, v5, v2
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v3
; CHECK-BE-NEXT:    mffprd r3, f0
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x double>, <4 x double>* %0, align 32
  %1 = fptosi <4 x double> %a to <4 x i16>
  %2 = bitcast <4 x i16> %1 to i64
  ret i64 %2
}

define <8 x i16> @test8elt_signed(<8 x double>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    lxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    lxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    xscvdpsxws f4, f0
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xscvdpsxws f5, f1
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xscvdpsxws f6, f2
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xscvdpsxws f7, f3
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mffprwz r3, f4
; CHECK-P8-NEXT:    mffprwz r4, f5
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mffprwz r3, f6
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r4, f7
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    vmrghh v2, v0, v2
; CHECK-P8-NEXT:    vmrghh v3, v1, v3
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    vmrghh v4, v0, v4
; CHECK-P8-NEXT:    vmrghh v5, v1, v5
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    xxmrglw vs1, v5, v4
; CHECK-P8-NEXT:    xxmrgld v2, vs1, vs0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs3, 0(r3)
; CHECK-P9-NEXT:    lxv vs2, 16(r3)
; CHECK-P9-NEXT:    lxv vs0, 48(r3)
; CHECK-P9-NEXT:    lxv vs1, 32(r3)
; CHECK-P9-NEXT:    xscvdpsxws f4, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    mffprwz r3, f4
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xxmrglw vs2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    xxmrgld v2, vs0, vs2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI6_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI6_0@toc@l
; CHECK-BE-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f4, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    mffprwz r3, f4
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mtvsrwz v5, r3
; CHECK-BE-NEXT:    vperm v4, v4, v5, v2
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xxmrghw vs2, v4, v3
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v5, r3
; CHECK-BE-NEXT:    vperm v2, v4, v5, v2
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v3
; CHECK-BE-NEXT:    xxmrghd v2, vs0, vs2
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x double>, <8 x double>* %0, align 64
  %1 = fptosi <8 x double> %a to <8 x i16>
  ret <8 x i16> %1
}

define void @test16elt_signed(<16 x i16>* noalias nocapture sret(<16 x i16>) %agg.result, <16 x double>* nocapture readonly) local_unnamed_addr #3 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 48
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r6
; CHECK-P8-NEXT:    li r6, 64
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs5, r4, r6
; CHECK-P8-NEXT:    li r7, 80
; CHECK-P8-NEXT:    li r6, 96
; CHECK-P8-NEXT:    xscvdpsxws f4, f0
; CHECK-P8-NEXT:    lxvd2x vs7, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs10, r4, r6
; CHECK-P8-NEXT:    li r6, 112
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xscvdpsxws f6, f1
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xscvdpsxws f8, f2
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xscvdpsxws f9, f3
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xscvdpsxws f11, f5
; CHECK-P8-NEXT:    xxswapd vs5, vs5
; CHECK-P8-NEXT:    xscvdpsxws f12, f7
; CHECK-P8-NEXT:    xxswapd vs7, vs7
; CHECK-P8-NEXT:    mffprwz r7, f4
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r6
; CHECK-P8-NEXT:    mffprwz r4, f6
; CHECK-P8-NEXT:    xscvdpsxws f13, f10
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r4, f8
; CHECK-P8-NEXT:    xscvdpsxws f6, f4
; CHECK-P8-NEXT:    mtvsrd v4, r4
; CHECK-P8-NEXT:    mffprwz r4, f9
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    mffprwz r4, f11
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    mtvsrd v0, r4
; CHECK-P8-NEXT:    mffprwz r4, f12
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    mffprwz r4, f13
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mtvsrd v6, r4
; CHECK-P8-NEXT:    mffprwz r4, f6
; CHECK-P8-NEXT:    xxswapd vs6, vs10
; CHECK-P8-NEXT:    xscvdpsxws f5, f5
; CHECK-P8-NEXT:    mtvsrd v7, r4
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    xxswapd vs0, vs4
; CHECK-P8-NEXT:    mtvsrd v2, r7
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    xscvdpsxws f7, f7
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    mffprwz r4, f2
; CHECK-P8-NEXT:    xscvdpsxws f4, f6
; CHECK-P8-NEXT:    vmrghh v2, v8, v2
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    vmrghh v3, v9, v3
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    mffprwz r4, f5
; CHECK-P8-NEXT:    vmrghh v4, v8, v4
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f7
; CHECK-P8-NEXT:    vmrghh v5, v9, v5
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    mffprwz r4, f4
; CHECK-P8-NEXT:    vmrghh v0, v8, v0
; CHECK-P8-NEXT:    mtvsrd v8, r4
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    vmrghh v1, v9, v1
; CHECK-P8-NEXT:    xxmrglw vs1, v5, v4
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    vmrghh v6, v8, v6
; CHECK-P8-NEXT:    vmrghh v7, v9, v7
; CHECK-P8-NEXT:    xxmrgld v2, vs1, vs0
; CHECK-P8-NEXT:    xxmrglw vs2, v1, v0
; CHECK-P8-NEXT:    stvx v2, 0, r3
; CHECK-P8-NEXT:    xxmrglw vs3, v7, v6
; CHECK-P8-NEXT:    xxmrgld v3, vs3, vs2
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs2, 0(r4)
; CHECK-P9-NEXT:    lxv vs1, 16(r4)
; CHECK-P9-NEXT:    lxv vs0, 32(r4)
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xscvdpsxws f4, f1
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    xscvdpsxws f5, f0
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    mffprwz r5, f3
; CHECK-P9-NEXT:    lxv vs3, 64(r4)
; CHECK-P9-NEXT:    mtvsrd v2, r5
; CHECK-P9-NEXT:    mffprwz r5, f4
; CHECK-P9-NEXT:    lxv vs4, 48(r4)
; CHECK-P9-NEXT:    mtvsrd v3, r5
; CHECK-P9-NEXT:    mffprwz r5, f5
; CHECK-P9-NEXT:    xscvdpsxws f7, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    mtvsrd v4, r5
; CHECK-P9-NEXT:    mffprwz r5, f2
; CHECK-P9-NEXT:    lxv vs2, 80(r4)
; CHECK-P9-NEXT:    xscvdpsxws f5, f4
; CHECK-P9-NEXT:    xxswapd vs4, vs4
; CHECK-P9-NEXT:    mtvsrd v5, r5
; CHECK-P9-NEXT:    mffprwz r5, f1
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    lxv vs1, 96(r4)
; CHECK-P9-NEXT:    xscvdpsxws f4, f4
; CHECK-P9-NEXT:    vmrghh v2, v2, v5
; CHECK-P9-NEXT:    mtvsrd v5, r5
; CHECK-P9-NEXT:    mffprwz r5, f0
; CHECK-P9-NEXT:    lxv vs0, 112(r4)
; CHECK-P9-NEXT:    vmrghh v3, v3, v5
; CHECK-P9-NEXT:    mtvsrd v5, r5
; CHECK-P9-NEXT:    mffprwz r4, f5
; CHECK-P9-NEXT:    vmrghh v4, v4, v5
; CHECK-P9-NEXT:    xxmrglw vs6, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    mffprwz r4, f4
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    mffprwz r4, f7
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    mffprwz r4, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    xxmrglw vs4, v2, v4
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    vmrghh v2, v3, v2
; CHECK-P9-NEXT:    xxmrgld vs4, vs4, vs6
; CHECK-P9-NEXT:    mffprwz r4, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    stxv vs4, 0(r3)
; CHECK-P9-NEXT:    mffprwz r4, f2
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mtvsrd v4, r4
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r4, f3
; CHECK-P9-NEXT:    xxmrglw vs2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    mffprwz r4, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r4, f1
; CHECK-P9-NEXT:    mtvsrd v3, r4
; CHECK-P9-NEXT:    mffprwz r4, f0
; CHECK-P9-NEXT:    mtvsrd v4, r4
; CHECK-P9-NEXT:    vmrghh v3, v3, v4
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    xxmrgld vs0, vs0, vs2
; CHECK-P9-NEXT:    stxv vs0, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs2, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 32(r4)
; CHECK-BE-NEXT:    lxv vs0, 16(r4)
; CHECK-BE-NEXT:    addis r5, r2, .LCPI7_0@toc@ha
; CHECK-BE-NEXT:    addi r5, r5, .LCPI7_0@toc@l
; CHECK-BE-NEXT:    lxv v2, 0(r5)
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xscvdpsxws f4, f1
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    xscvdpsxws f5, f0
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    mffprwz r5, f3
; CHECK-BE-NEXT:    lxv vs3, 112(r4)
; CHECK-BE-NEXT:    mtvsrwz v3, r5
; CHECK-BE-NEXT:    mffprwz r5, f4
; CHECK-BE-NEXT:    lxv vs4, 0(r4)
; CHECK-BE-NEXT:    mtvsrwz v4, r5
; CHECK-BE-NEXT:    mffprwz r5, f5
; CHECK-BE-NEXT:    xscvdpsxws f7, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    mtvsrwz v5, r5
; CHECK-BE-NEXT:    mffprwz r5, f2
; CHECK-BE-NEXT:    lxv vs2, 96(r4)
; CHECK-BE-NEXT:    xscvdpsxws f5, f4
; CHECK-BE-NEXT:    xxswapd vs4, vs4
; CHECK-BE-NEXT:    mtvsrwz v0, r5
; CHECK-BE-NEXT:    mffprwz r5, f1
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    lxv vs1, 80(r4)
; CHECK-BE-NEXT:    xscvdpsxws f4, f4
; CHECK-BE-NEXT:    vperm v3, v3, v0, v2
; CHECK-BE-NEXT:    mtvsrwz v0, r5
; CHECK-BE-NEXT:    mffprwz r5, f0
; CHECK-BE-NEXT:    lxv vs0, 64(r4)
; CHECK-BE-NEXT:    vperm v4, v4, v0, v2
; CHECK-BE-NEXT:    mtvsrwz v0, r5
; CHECK-BE-NEXT:    mffprwz r4, f5
; CHECK-BE-NEXT:    vperm v5, v5, v0, v2
; CHECK-BE-NEXT:    xxmrghw vs6, v4, v3
; CHECK-BE-NEXT:    mtvsrwz v3, r4
; CHECK-BE-NEXT:    mffprwz r4, f4
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    mffprwz r4, f7
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    mffprwz r4, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xxmrghw vs4, v3, v5
; CHECK-BE-NEXT:    mtvsrwz v3, r4
; CHECK-BE-NEXT:    vperm v3, v4, v3, v2
; CHECK-BE-NEXT:    xxmrghd vs4, vs4, vs6
; CHECK-BE-NEXT:    mffprwz r4, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    stxv vs4, 0(r3)
; CHECK-BE-NEXT:    mffprwz r4, f2
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mtvsrwz v5, r4
; CHECK-BE-NEXT:    vperm v4, v4, v5, v2
; CHECK-BE-NEXT:    mffprwz r4, f3
; CHECK-BE-NEXT:    xxmrghw vs2, v4, v3
; CHECK-BE-NEXT:    mtvsrwz v3, r4
; CHECK-BE-NEXT:    mffprwz r4, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    vperm v3, v3, v4, v2
; CHECK-BE-NEXT:    mffprwz r4, f1
; CHECK-BE-NEXT:    mtvsrwz v4, r4
; CHECK-BE-NEXT:    mffprwz r4, f0
; CHECK-BE-NEXT:    mtvsrwz v5, r4
; CHECK-BE-NEXT:    vperm v2, v4, v5, v2
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v3
; CHECK-BE-NEXT:    xxmrghd vs0, vs0, vs2
; CHECK-BE-NEXT:    stxv vs0, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x double>, <16 x double>* %0, align 128
  %1 = fptosi <16 x double> %a to <16 x i16>
  store <16 x i16> %1, <16 x i16>* %agg.result, align 32
  ret void
}
