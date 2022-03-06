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

define i64 @test2elt(i16 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    clrldi r4, r3, 56
; CHECK-P8-NEXT:    rldicl r3, r3, 56, 56
; CHECK-P8-NEXT:    clrlwi r4, r4, 24
; CHECK-P8-NEXT:    clrlwi r3, r3, 24
; CHECK-P8-NEXT:    mtfprwz f0, r4
; CHECK-P8-NEXT:    mtfprwz f1, r3
; CHECK-P8-NEXT:    xscvuxdsp f0, f0
; CHECK-P8-NEXT:    xscvuxdsp f1, f1
; CHECK-P8-NEXT:    xscvdpspn v2, f0
; CHECK-P8-NEXT:    xscvdpspn v3, f1
; CHECK-P8-NEXT:    vmrghw v2, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrws v2, r3
; CHECK-P9-NEXT:    vextractub v3, v2, 15
; CHECK-P9-NEXT:    vextractub v2, v2, 14
; CHECK-P9-NEXT:    xscvuxdsp f0, v3
; CHECK-P9-NEXT:    xscvdpspn v3, f0
; CHECK-P9-NEXT:    xscvuxdsp f0, v2
; CHECK-P9-NEXT:    xscvdpspn v2, f0
; CHECK-P9-NEXT:    vmrghw v2, v2, v3
; CHECK-P9-NEXT:    mfvsrld r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrws v2, r3
; CHECK-BE-NEXT:    vextractub v3, v2, 2
; CHECK-BE-NEXT:    vextractub v2, v2, 0
; CHECK-BE-NEXT:    xscvuxdsp f0, v3
; CHECK-BE-NEXT:    xscvdpspn v3, f0
; CHECK-BE-NEXT:    xscvuxdsp f0, v2
; CHECK-BE-NEXT:    xscvdpspn v2, f0
; CHECK-BE-NEXT:    vmrgow v2, v2, v3
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i16 %a.coerce to <2 x i8>
  %1 = uitofp <2 x i8> %0 to <2 x float>
  %2 = bitcast <2 x float> %1 to i64
  ret i64 %2
}

define <4 x float> @test4elt(i32 %a.coerce) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r4, r2, .LCPI1_0@toc@ha
; CHECK-P8-NEXT:    mtvsrwz v2, r3
; CHECK-P8-NEXT:    addi r4, r4, .LCPI1_0@toc@l
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    vperm v2, v4, v2, v3
; CHECK-P8-NEXT:    xvcvuxwsp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrwz v2, r3
; CHECK-P9-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r3)
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxwsp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r3)
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    xvcvuxwsp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i32 %a.coerce to <4 x i8>
  %1 = uitofp <4 x i8> %0 to <4 x float>
  ret <4 x float> %1
}

define void @test8elt(<8 x float>* noalias nocapture sret(<8 x float>) %agg.result, i64 %a.coerce) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI2_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI2_1@toc@ha
; CHECK-P8-NEXT:    mtvsrd v2, r4
; CHECK-P8-NEXT:    addi r5, r5, .LCPI2_0@toc@l
; CHECK-P8-NEXT:    addi r4, r6, .LCPI2_1@toc@l
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    lvx v3, 0, r5
; CHECK-P8-NEXT:    lvx v5, 0, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    vperm v3, v4, v2, v3
; CHECK-P8-NEXT:    vperm v2, v4, v2, v5
; CHECK-P8-NEXT:    xvcvuxwsp v3, v3
; CHECK-P8-NEXT:    xvcvuxwsp v2, v2
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    stvx v2, r3, r4
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI2_0@toc@ha
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addi r4, r4, .LCPI2_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI2_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI2_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxwsp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    xvcvuxwsp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrd v2, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI2_0@toc@ha
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addi r4, r4, .LCPI2_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI2_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI2_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    xvcvuxwsp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    xvcvuxwsp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <8 x i8>
  %1 = uitofp <8 x i8> %0 to <8 x float>
  store <8 x float> %1, <8 x float>* %agg.result, align 32
  ret void
}

define void @test16elt(<16 x float>* noalias nocapture sret(<16 x float>) %agg.result, <16 x i8> %a) local_unnamed_addr #3 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r4, r2, .LCPI3_0@toc@ha
; CHECK-P8-NEXT:    addis r5, r2, .LCPI3_2@toc@ha
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    addi r4, r4, .LCPI3_0@toc@l
; CHECK-P8-NEXT:    addi r5, r5, .LCPI3_2@toc@l
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-P8-NEXT:    lvx v5, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI3_1@toc@ha
; CHECK-P8-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-P8-NEXT:    addi r5, r5, .LCPI3_1@toc@l
; CHECK-P8-NEXT:    lvx v0, 0, r4
; CHECK-P8-NEXT:    lvx v1, 0, r5
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    vperm v5, v4, v2, v5
; CHECK-P8-NEXT:    vperm v3, v4, v2, v3
; CHECK-P8-NEXT:    vperm v0, v4, v2, v0
; CHECK-P8-NEXT:    vperm v2, v4, v2, v1
; CHECK-P8-NEXT:    xvcvuxwsp v4, v5
; CHECK-P8-NEXT:    xvcvuxwsp v3, v3
; CHECK-P8-NEXT:    xvcvuxwsp v5, v0
; CHECK-P8-NEXT:    xvcvuxwsp v2, v2
; CHECK-P8-NEXT:    stvx v4, r3, r5
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    stvx v5, r3, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    stvx v2, r3, r4
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_0@toc@ha
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    xvcvuxwsp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_2@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_2@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    xvcvuxwsp vs1, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-P9-NEXT:    vperm v3, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    xvcvuxwsp vs2, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    xvcvuxwsp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_0@toc@ha
; CHECK-BE-NEXT:    xxlxor v4, v4, v4
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    xvcvuxwsp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_2@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_2@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    xvcvuxwsp vs1, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI3_3@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI3_3@toc@l
; CHECK-BE-NEXT:    vperm v3, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    xvcvuxwsp vs2, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v4, v2, v3
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    xvcvuxwsp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = uitofp <16 x i8> %a to <16 x float>
  store <16 x float> %0, <16 x float>* %agg.result, align 64
  ret void
}

define i64 @test2elt_signed(i16 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    clrldi r4, r3, 56
; CHECK-P8-NEXT:    rldicl r3, r3, 56, 56
; CHECK-P8-NEXT:    extsb r4, r4
; CHECK-P8-NEXT:    extsb r3, r3
; CHECK-P8-NEXT:    mtfprwa f0, r4
; CHECK-P8-NEXT:    mtfprwa f1, r3
; CHECK-P8-NEXT:    xscvsxdsp f0, f0
; CHECK-P8-NEXT:    xscvsxdsp f1, f1
; CHECK-P8-NEXT:    xscvdpspn v2, f0
; CHECK-P8-NEXT:    xscvdpspn v3, f1
; CHECK-P8-NEXT:    vmrghw v2, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrws v2, r3
; CHECK-P9-NEXT:    vextractub v3, v2, 15
; CHECK-P9-NEXT:    vextractub v2, v2, 14
; CHECK-P9-NEXT:    vextsh2d v3, v3
; CHECK-P9-NEXT:    vextsh2d v2, v2
; CHECK-P9-NEXT:    xscvsxdsp f0, v3
; CHECK-P9-NEXT:    xscvdpspn v3, f0
; CHECK-P9-NEXT:    xscvsxdsp f0, v2
; CHECK-P9-NEXT:    xscvdpspn v2, f0
; CHECK-P9-NEXT:    vmrghw v2, v2, v3
; CHECK-P9-NEXT:    mfvsrld r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrws v2, r3
; CHECK-BE-NEXT:    vextractub v3, v2, 2
; CHECK-BE-NEXT:    vextractub v2, v2, 0
; CHECK-BE-NEXT:    vextsh2d v3, v3
; CHECK-BE-NEXT:    vextsh2d v2, v2
; CHECK-BE-NEXT:    xscvsxdsp f0, v3
; CHECK-BE-NEXT:    xscvdpspn v3, f0
; CHECK-BE-NEXT:    xscvsxdsp f0, v2
; CHECK-BE-NEXT:    xscvdpspn v2, f0
; CHECK-BE-NEXT:    vmrgow v2, v2, v3
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i16 %a.coerce to <2 x i8>
  %1 = sitofp <2 x i8> %0 to <2 x float>
  %2 = bitcast <2 x float> %1 to i64
  ret i64 %2
}

define <4 x float> @test4elt_signed(i32 %a.coerce) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r4, r2, .LCPI5_0@toc@ha
; CHECK-P8-NEXT:    mtvsrwz v3, r3
; CHECK-P8-NEXT:    addi r4, r4, .LCPI5_0@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r4
; CHECK-P8-NEXT:    vperm v2, v3, v3, v2
; CHECK-P8-NEXT:    vspltisw v3, 12
; CHECK-P8-NEXT:    vadduwm v3, v3, v3
; CHECK-P8-NEXT:    vslw v2, v2, v3
; CHECK-P8-NEXT:    vsraw v2, v2, v3
; CHECK-P8-NEXT:    xvcvsxwsp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrwz v2, r3
; CHECK-P9-NEXT:    addis r3, r2, .LCPI5_0@toc@ha
; CHECK-P9-NEXT:    addi r3, r3, .LCPI5_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r3)
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    vextsb2w v2, v2
; CHECK-P9-NEXT:    xvcvsxwsp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    addis r3, r2, .LCPI5_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI5_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r3)
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    vextsb2w v2, v2
; CHECK-BE-NEXT:    xvcvsxwsp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i32 %a.coerce to <4 x i8>
  %1 = sitofp <4 x i8> %0 to <4 x float>
  ret <4 x float> %1
}

define void @test8elt_signed(<8 x float>* noalias nocapture sret(<8 x float>) %agg.result, i64 %a.coerce) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI6_0@toc@ha
; CHECK-P8-NEXT:    addis r6, r2, .LCPI6_1@toc@ha
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    vspltisw v5, 12
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    addi r5, r5, .LCPI6_0@toc@l
; CHECK-P8-NEXT:    lvx v2, 0, r5
; CHECK-P8-NEXT:    addi r5, r6, .LCPI6_1@toc@l
; CHECK-P8-NEXT:    lvx v4, 0, r5
; CHECK-P8-NEXT:    vperm v2, v3, v3, v2
; CHECK-P8-NEXT:    vperm v3, v3, v3, v4
; CHECK-P8-NEXT:    vadduwm v4, v5, v5
; CHECK-P8-NEXT:    vslw v2, v2, v4
; CHECK-P8-NEXT:    vslw v3, v3, v4
; CHECK-P8-NEXT:    vsraw v2, v2, v4
; CHECK-P8-NEXT:    vsraw v3, v3, v4
; CHECK-P8-NEXT:    xvcvsxwsp v2, v2
; CHECK-P8-NEXT:    xvcvsxwsp v3, v3
; CHECK-P8-NEXT:    stvx v2, 0, r3
; CHECK-P8-NEXT:    stvx v3, r3, r4
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrd v2, r4
; CHECK-P9-NEXT:    addis r4, r2, .LCPI6_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI6_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI6_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI6_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    vextsb2w v3, v3
; CHECK-P9-NEXT:    xvcvsxwsp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    vextsb2w v2, v2
; CHECK-P9-NEXT:    xvcvsxwsp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtvsrd v2, r4
; CHECK-BE-NEXT:    addis r4, r2, .LCPI6_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI6_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI6_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI6_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    vextsb2w v3, v3
; CHECK-BE-NEXT:    xvcvsxwsp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    vextsb2w v2, v2
; CHECK-BE-NEXT:    xvcvsxwsp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <8 x i8>
  %1 = sitofp <8 x i8> %0 to <8 x float>
  store <8 x float> %1, <8 x float>* %agg.result, align 32
  ret void
}

define void @test16elt_signed(<16 x float>* noalias nocapture sret(<16 x float>) %agg.result, <16 x i8> %a) local_unnamed_addr #3 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r4, r2, .LCPI7_0@toc@ha
; CHECK-P8-NEXT:    addis r5, r2, .LCPI7_2@toc@ha
; CHECK-P8-NEXT:    vspltisw v1, 12
; CHECK-P8-NEXT:    addi r4, r4, .LCPI7_0@toc@l
; CHECK-P8-NEXT:    addi r5, r5, .LCPI7_2@toc@l
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    addis r4, r2, .LCPI7_3@toc@ha
; CHECK-P8-NEXT:    lvx v4, 0, r5
; CHECK-P8-NEXT:    addis r5, r2, .LCPI7_1@toc@ha
; CHECK-P8-NEXT:    addi r4, r4, .LCPI7_3@toc@l
; CHECK-P8-NEXT:    addi r5, r5, .LCPI7_1@toc@l
; CHECK-P8-NEXT:    lvx v5, 0, r4
; CHECK-P8-NEXT:    lvx v0, 0, r5
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    vperm v3, v2, v2, v3
; CHECK-P8-NEXT:    vperm v4, v2, v2, v4
; CHECK-P8-NEXT:    vperm v5, v2, v2, v5
; CHECK-P8-NEXT:    vperm v2, v2, v2, v0
; CHECK-P8-NEXT:    vadduwm v0, v1, v1
; CHECK-P8-NEXT:    vslw v3, v3, v0
; CHECK-P8-NEXT:    vslw v4, v4, v0
; CHECK-P8-NEXT:    vslw v5, v5, v0
; CHECK-P8-NEXT:    vslw v2, v2, v0
; CHECK-P8-NEXT:    vsraw v3, v3, v0
; CHECK-P8-NEXT:    vsraw v4, v4, v0
; CHECK-P8-NEXT:    vsraw v5, v5, v0
; CHECK-P8-NEXT:    vsraw v2, v2, v0
; CHECK-P8-NEXT:    xvcvsxwsp v3, v3
; CHECK-P8-NEXT:    xvcvsxwsp v4, v4
; CHECK-P8-NEXT:    xvcvsxwsp v5, v5
; CHECK-P8-NEXT:    xvcvsxwsp v2, v2
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    stvx v4, r3, r5
; CHECK-P8-NEXT:    stvx v5, r3, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    stvx v2, r3, r4
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addis r4, r2, .LCPI7_0@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI7_0@toc@l
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI7_1@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI7_1@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    vextsb2w v3, v3
; CHECK-P9-NEXT:    xvcvsxwsp vs0, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI7_2@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI7_2@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    vextsb2w v3, v3
; CHECK-P9-NEXT:    xvcvsxwsp vs1, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    addis r4, r2, .LCPI7_3@toc@ha
; CHECK-P9-NEXT:    addi r4, r4, .LCPI7_3@toc@l
; CHECK-P9-NEXT:    vperm v3, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    vextsb2w v3, v3
; CHECK-P9-NEXT:    xvcvsxwsp vs2, v3
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    vperm v2, v2, v2, v3
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    vextsb2w v2, v2
; CHECK-P9-NEXT:    xvcvsxwsp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r4, r2, .LCPI7_0@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI7_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI7_1@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI7_1@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    vextsb2w v3, v3
; CHECK-BE-NEXT:    xvcvsxwsp vs0, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI7_2@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI7_2@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    vextsb2w v3, v3
; CHECK-BE-NEXT:    xvcvsxwsp vs1, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    addis r4, r2, .LCPI7_3@toc@ha
; CHECK-BE-NEXT:    addi r4, r4, .LCPI7_3@toc@l
; CHECK-BE-NEXT:    vperm v3, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    vextsb2w v3, v3
; CHECK-BE-NEXT:    xvcvsxwsp vs2, v3
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    vperm v2, v2, v2, v3
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    vextsb2w v2, v2
; CHECK-BE-NEXT:    xvcvsxwsp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = sitofp <16 x i8> %a to <16 x float>
  store <16 x float> %0, <16 x float>* %agg.result, align 64
  ret void
}
