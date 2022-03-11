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

define i64 @test2elt(<2 x i64> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvuxdsp f1, v2
; CHECK-P8-NEXT:    xscvuxdsp f0, f0
; CHECK-P8-NEXT:    xscvdpspn vs1, f1
; CHECK-P8-NEXT:    xscvdpspn vs0, f0
; CHECK-P8-NEXT:    xxmrghw vs0, vs1, vs0
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    xscvuxdsp f1, v2
; CHECK-P9-NEXT:    xscvuxdsp f0, f0
; CHECK-P9-NEXT:    xscvdpspn vs1, f1
; CHECK-P9-NEXT:    xscvdpspn vs0, f0
; CHECK-P9-NEXT:    xxmrghw vs0, vs1, vs0
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    xscvuxdsp f1, v2
; CHECK-BE-NEXT:    xscvuxdsp f0, f0
; CHECK-BE-NEXT:    xscvdpspn v2, f1
; CHECK-BE-NEXT:    xscvdpspn v3, f0
; CHECK-BE-NEXT:    vmrgow v2, v2, v3
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = uitofp <2 x i64> %a to <2 x float>
  %1 = bitcast <2 x float> %0 to i64
  ret i64 %1
}

define <4 x float> @test4elt(<4 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xvcvuxdsp vs1, v3
; CHECK-P8-NEXT:    xvcvuxdsp vs0, v2
; CHECK-P8-NEXT:    xxsldwi v3, vs1, vs1, 3
; CHECK-P8-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P8-NEXT:    vpkudum v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v3, 0(r3)
; CHECK-P9-NEXT:    lxv v2, 16(r3)
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v3
; CHECK-P9-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v2
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P9-NEXT:    vpkudum v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v3, 16(r3)
; CHECK-BE-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v3
; CHECK-BE-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v2
; CHECK-BE-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-BE-NEXT:    vpkudum v2, v2, v3
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x i64>, <4 x i64>* %0, align 32
  %1 = uitofp <4 x i64> %a to <4 x float>
  ret <4 x float> %1
}

define void @test8elt(<8 x float>* noalias nocapture sret(<8 x float>) %agg.result, <8 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r5
; CHECK-P8-NEXT:    xxswapd v5, vs3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xxswapd v4, vs2
; CHECK-P8-NEXT:    xvcvuxdsp vs3, v5
; CHECK-P8-NEXT:    xvcvuxdsp vs0, v2
; CHECK-P8-NEXT:    xvcvuxdsp vs1, v3
; CHECK-P8-NEXT:    xvcvuxdsp vs2, v4
; CHECK-P8-NEXT:    xxsldwi v5, vs3, vs3, 3
; CHECK-P8-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P8-NEXT:    xxsldwi v3, vs1, vs1, 3
; CHECK-P8-NEXT:    xxsldwi v4, vs2, vs2, 3
; CHECK-P8-NEXT:    vpkudum v2, v3, v2
; CHECK-P8-NEXT:    vpkudum v3, v4, v5
; CHECK-P8-NEXT:    stvx v2, r3, r5
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v5, 0(r4)
; CHECK-P9-NEXT:    lxv v4, 16(r4)
; CHECK-P9-NEXT:    lxv v3, 32(r4)
; CHECK-P9-NEXT:    lxv v2, 48(r4)
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v5
; CHECK-P9-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v4
; CHECK-P9-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v3
; CHECK-P9-NEXT:    vpkudum v3, v4, v5
; CHECK-P9-NEXT:    stxv v3, 0(r3)
; CHECK-P9-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v2
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P9-NEXT:    vpkudum v2, v2, v4
; CHECK-P9-NEXT:    stxv v2, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v5, 16(r4)
; CHECK-BE-NEXT:    lxv v4, 0(r4)
; CHECK-BE-NEXT:    lxv v3, 48(r4)
; CHECK-BE-NEXT:    lxv v2, 32(r4)
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v5
; CHECK-BE-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v4
; CHECK-BE-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v3
; CHECK-BE-NEXT:    vpkudum v3, v4, v5
; CHECK-BE-NEXT:    stxv v3, 0(r3)
; CHECK-BE-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v2
; CHECK-BE-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-BE-NEXT:    vpkudum v2, v2, v4
; CHECK-BE-NEXT:    stxv v2, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i64>, <8 x i64>* %0, align 64
  %1 = uitofp <8 x i64> %a to <8 x float>
  store <8 x float> %1, <8 x float>* %agg.result, align 32
  ret void
}

define void @test16elt(<16 x float>* noalias nocapture sret(<16 x float>) %agg.result, <16 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    lxvd2x vs4, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    li r7, 80
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r7
; CHECK-P8-NEXT:    li r7, 96
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r7
; CHECK-P8-NEXT:    li r7, 112
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r7
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    xxswapd v4, vs2
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    xxswapd v5, vs3
; CHECK-P8-NEXT:    xvcvuxdsp vs3, v2
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xvcvuxdsp vs0, v3
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xvcvuxdsp vs1, v4
; CHECK-P8-NEXT:    xxswapd v4, vs2
; CHECK-P8-NEXT:    xvcvuxdsp vs2, v5
; CHECK-P8-NEXT:    xxswapd v5, vs4
; CHECK-P8-NEXT:    xvcvuxdsp vs4, v2
; CHECK-P8-NEXT:    xvcvuxdsp vs5, v3
; CHECK-P8-NEXT:    xvcvuxdsp vs6, v4
; CHECK-P8-NEXT:    xxsldwi v2, vs3, vs3, 3
; CHECK-P8-NEXT:    xvcvuxdsp vs7, v5
; CHECK-P8-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-P8-NEXT:    xxsldwi v4, vs1, vs1, 3
; CHECK-P8-NEXT:    xxsldwi v5, vs2, vs2, 3
; CHECK-P8-NEXT:    xxsldwi v0, vs4, vs4, 3
; CHECK-P8-NEXT:    vpkudum v2, v3, v2
; CHECK-P8-NEXT:    xxsldwi v1, vs5, vs5, 3
; CHECK-P8-NEXT:    xxsldwi v6, vs6, vs6, 3
; CHECK-P8-NEXT:    vpkudum v3, v5, v4
; CHECK-P8-NEXT:    xxsldwi v7, vs7, vs7, 3
; CHECK-P8-NEXT:    vpkudum v4, v1, v0
; CHECK-P8-NEXT:    vpkudum v5, v6, v7
; CHECK-P8-NEXT:    stvx v2, r3, r7
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    stvx v4, r3, r6
; CHECK-P8-NEXT:    stvx v5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v7, 0(r4)
; CHECK-P9-NEXT:    lxv v6, 16(r4)
; CHECK-P9-NEXT:    lxv v1, 32(r4)
; CHECK-P9-NEXT:    lxv v0, 48(r4)
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v7
; CHECK-P9-NEXT:    lxv v5, 64(r4)
; CHECK-P9-NEXT:    lxv v4, 80(r4)
; CHECK-P9-NEXT:    lxv v3, 96(r4)
; CHECK-P9-NEXT:    lxv v2, 112(r4)
; CHECK-P9-NEXT:    xxsldwi v7, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v6
; CHECK-P9-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v1
; CHECK-P9-NEXT:    vpkudum v1, v6, v7
; CHECK-P9-NEXT:    stxv v1, 0(r3)
; CHECK-P9-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v0
; CHECK-P9-NEXT:    xxsldwi v0, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v5
; CHECK-P9-NEXT:    vpkudum v0, v0, v6
; CHECK-P9-NEXT:    stxv v0, 16(r3)
; CHECK-P9-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v4
; CHECK-P9-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v3
; CHECK-P9-NEXT:    vpkudum v4, v4, v5
; CHECK-P9-NEXT:    stxv v4, 32(r3)
; CHECK-P9-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvuxdsp vs0, v2
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P9-NEXT:    vpkudum v2, v2, v3
; CHECK-P9-NEXT:    stxv v2, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v7, 16(r4)
; CHECK-BE-NEXT:    lxv v6, 0(r4)
; CHECK-BE-NEXT:    lxv v1, 48(r4)
; CHECK-BE-NEXT:    lxv v0, 32(r4)
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v7
; CHECK-BE-NEXT:    lxv v5, 80(r4)
; CHECK-BE-NEXT:    lxv v4, 64(r4)
; CHECK-BE-NEXT:    lxv v3, 112(r4)
; CHECK-BE-NEXT:    lxv v2, 96(r4)
; CHECK-BE-NEXT:    xxsldwi v7, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v6
; CHECK-BE-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v1
; CHECK-BE-NEXT:    vpkudum v1, v6, v7
; CHECK-BE-NEXT:    stxv v1, 0(r3)
; CHECK-BE-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v0
; CHECK-BE-NEXT:    xxsldwi v0, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v5
; CHECK-BE-NEXT:    vpkudum v0, v0, v6
; CHECK-BE-NEXT:    stxv v0, 16(r3)
; CHECK-BE-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v4
; CHECK-BE-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v3
; CHECK-BE-NEXT:    vpkudum v4, v4, v5
; CHECK-BE-NEXT:    stxv v4, 32(r3)
; CHECK-BE-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvuxdsp vs0, v2
; CHECK-BE-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-BE-NEXT:    vpkudum v2, v2, v3
; CHECK-BE-NEXT:    stxv v2, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i64>, <16 x i64>* %0, align 128
  %1 = uitofp <16 x i64> %a to <16 x float>
  store <16 x float> %1, <16 x float>* %agg.result, align 64
  ret void
}

define i64 @test2elt_signed(<2 x i64> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvsxdsp f1, v2
; CHECK-P8-NEXT:    xscvsxdsp f0, f0
; CHECK-P8-NEXT:    xscvdpspn vs1, f1
; CHECK-P8-NEXT:    xscvdpspn vs0, f0
; CHECK-P8-NEXT:    xxmrghw vs0, vs1, vs0
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    xscvsxdsp f1, v2
; CHECK-P9-NEXT:    xscvsxdsp f0, f0
; CHECK-P9-NEXT:    xscvdpspn vs1, f1
; CHECK-P9-NEXT:    xscvdpspn vs0, f0
; CHECK-P9-NEXT:    xxmrghw vs0, vs1, vs0
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    xscvsxdsp f1, v2
; CHECK-BE-NEXT:    xscvsxdsp f0, f0
; CHECK-BE-NEXT:    xscvdpspn v2, f1
; CHECK-BE-NEXT:    xscvdpspn v3, f0
; CHECK-BE-NEXT:    vmrgow v2, v2, v3
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = sitofp <2 x i64> %a to <2 x float>
  %1 = bitcast <2 x float> %0 to i64
  ret i64 %1
}

define <4 x float> @test4elt_signed(<4 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xvcvsxdsp vs1, v3
; CHECK-P8-NEXT:    xvcvsxdsp vs0, v2
; CHECK-P8-NEXT:    xxsldwi v3, vs1, vs1, 3
; CHECK-P8-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P8-NEXT:    vpkudum v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v3, 0(r3)
; CHECK-P9-NEXT:    lxv v2, 16(r3)
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v3
; CHECK-P9-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v2
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P9-NEXT:    vpkudum v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v3, 16(r3)
; CHECK-BE-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v3
; CHECK-BE-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v2
; CHECK-BE-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-BE-NEXT:    vpkudum v2, v2, v3
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x i64>, <4 x i64>* %0, align 32
  %1 = sitofp <4 x i64> %a to <4 x float>
  ret <4 x float> %1
}

define void @test8elt_signed(<8 x float>* noalias nocapture sret(<8 x float>) %agg.result, <8 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r5
; CHECK-P8-NEXT:    xxswapd v5, vs3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xxswapd v4, vs2
; CHECK-P8-NEXT:    xvcvsxdsp vs3, v5
; CHECK-P8-NEXT:    xvcvsxdsp vs0, v2
; CHECK-P8-NEXT:    xvcvsxdsp vs1, v3
; CHECK-P8-NEXT:    xvcvsxdsp vs2, v4
; CHECK-P8-NEXT:    xxsldwi v5, vs3, vs3, 3
; CHECK-P8-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P8-NEXT:    xxsldwi v3, vs1, vs1, 3
; CHECK-P8-NEXT:    xxsldwi v4, vs2, vs2, 3
; CHECK-P8-NEXT:    vpkudum v2, v3, v2
; CHECK-P8-NEXT:    vpkudum v3, v4, v5
; CHECK-P8-NEXT:    stvx v2, r3, r5
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v5, 0(r4)
; CHECK-P9-NEXT:    lxv v4, 16(r4)
; CHECK-P9-NEXT:    lxv v3, 32(r4)
; CHECK-P9-NEXT:    lxv v2, 48(r4)
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v5
; CHECK-P9-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v4
; CHECK-P9-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v3
; CHECK-P9-NEXT:    vpkudum v3, v4, v5
; CHECK-P9-NEXT:    stxv v3, 0(r3)
; CHECK-P9-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v2
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P9-NEXT:    vpkudum v2, v2, v4
; CHECK-P9-NEXT:    stxv v2, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v5, 16(r4)
; CHECK-BE-NEXT:    lxv v4, 0(r4)
; CHECK-BE-NEXT:    lxv v3, 48(r4)
; CHECK-BE-NEXT:    lxv v2, 32(r4)
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v5
; CHECK-BE-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v4
; CHECK-BE-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v3
; CHECK-BE-NEXT:    vpkudum v3, v4, v5
; CHECK-BE-NEXT:    stxv v3, 0(r3)
; CHECK-BE-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v2
; CHECK-BE-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-BE-NEXT:    vpkudum v2, v2, v4
; CHECK-BE-NEXT:    stxv v2, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i64>, <8 x i64>* %0, align 64
  %1 = sitofp <8 x i64> %a to <8 x float>
  store <8 x float> %1, <8 x float>* %agg.result, align 32
  ret void
}

define void @test16elt_signed(<16 x float>* noalias nocapture sret(<16 x float>) %agg.result, <16 x i64>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    lxvd2x vs4, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    li r7, 80
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r7
; CHECK-P8-NEXT:    li r7, 96
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r7
; CHECK-P8-NEXT:    li r7, 112
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r7
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    xxswapd v4, vs2
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    xxswapd v5, vs3
; CHECK-P8-NEXT:    xvcvsxdsp vs3, v2
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xvcvsxdsp vs0, v3
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xvcvsxdsp vs1, v4
; CHECK-P8-NEXT:    xxswapd v4, vs2
; CHECK-P8-NEXT:    xvcvsxdsp vs2, v5
; CHECK-P8-NEXT:    xxswapd v5, vs4
; CHECK-P8-NEXT:    xvcvsxdsp vs4, v2
; CHECK-P8-NEXT:    xvcvsxdsp vs5, v3
; CHECK-P8-NEXT:    xvcvsxdsp vs6, v4
; CHECK-P8-NEXT:    xxsldwi v2, vs3, vs3, 3
; CHECK-P8-NEXT:    xvcvsxdsp vs7, v5
; CHECK-P8-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-P8-NEXT:    xxsldwi v4, vs1, vs1, 3
; CHECK-P8-NEXT:    xxsldwi v5, vs2, vs2, 3
; CHECK-P8-NEXT:    xxsldwi v0, vs4, vs4, 3
; CHECK-P8-NEXT:    vpkudum v2, v3, v2
; CHECK-P8-NEXT:    xxsldwi v1, vs5, vs5, 3
; CHECK-P8-NEXT:    xxsldwi v6, vs6, vs6, 3
; CHECK-P8-NEXT:    vpkudum v3, v5, v4
; CHECK-P8-NEXT:    xxsldwi v7, vs7, vs7, 3
; CHECK-P8-NEXT:    vpkudum v4, v1, v0
; CHECK-P8-NEXT:    vpkudum v5, v6, v7
; CHECK-P8-NEXT:    stvx v2, r3, r7
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    stvx v4, r3, r6
; CHECK-P8-NEXT:    stvx v5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v7, 0(r4)
; CHECK-P9-NEXT:    lxv v6, 16(r4)
; CHECK-P9-NEXT:    lxv v1, 32(r4)
; CHECK-P9-NEXT:    lxv v0, 48(r4)
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v7
; CHECK-P9-NEXT:    lxv v5, 64(r4)
; CHECK-P9-NEXT:    lxv v4, 80(r4)
; CHECK-P9-NEXT:    lxv v3, 96(r4)
; CHECK-P9-NEXT:    lxv v2, 112(r4)
; CHECK-P9-NEXT:    xxsldwi v7, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v6
; CHECK-P9-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v1
; CHECK-P9-NEXT:    vpkudum v1, v6, v7
; CHECK-P9-NEXT:    stxv v1, 0(r3)
; CHECK-P9-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v0
; CHECK-P9-NEXT:    xxsldwi v0, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v5
; CHECK-P9-NEXT:    vpkudum v0, v0, v6
; CHECK-P9-NEXT:    stxv v0, 16(r3)
; CHECK-P9-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v4
; CHECK-P9-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v3
; CHECK-P9-NEXT:    vpkudum v4, v4, v5
; CHECK-P9-NEXT:    stxv v4, 32(r3)
; CHECK-P9-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-P9-NEXT:    xvcvsxdsp vs0, v2
; CHECK-P9-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-P9-NEXT:    vpkudum v2, v2, v3
; CHECK-P9-NEXT:    stxv v2, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v7, 16(r4)
; CHECK-BE-NEXT:    lxv v6, 0(r4)
; CHECK-BE-NEXT:    lxv v1, 48(r4)
; CHECK-BE-NEXT:    lxv v0, 32(r4)
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v7
; CHECK-BE-NEXT:    lxv v5, 80(r4)
; CHECK-BE-NEXT:    lxv v4, 64(r4)
; CHECK-BE-NEXT:    lxv v3, 112(r4)
; CHECK-BE-NEXT:    lxv v2, 96(r4)
; CHECK-BE-NEXT:    xxsldwi v7, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v6
; CHECK-BE-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v1
; CHECK-BE-NEXT:    vpkudum v1, v6, v7
; CHECK-BE-NEXT:    stxv v1, 0(r3)
; CHECK-BE-NEXT:    xxsldwi v6, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v0
; CHECK-BE-NEXT:    xxsldwi v0, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v5
; CHECK-BE-NEXT:    vpkudum v0, v0, v6
; CHECK-BE-NEXT:    stxv v0, 16(r3)
; CHECK-BE-NEXT:    xxsldwi v5, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v4
; CHECK-BE-NEXT:    xxsldwi v4, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v3
; CHECK-BE-NEXT:    vpkudum v4, v4, v5
; CHECK-BE-NEXT:    stxv v4, 32(r3)
; CHECK-BE-NEXT:    xxsldwi v3, vs0, vs0, 3
; CHECK-BE-NEXT:    xvcvsxdsp vs0, v2
; CHECK-BE-NEXT:    xxsldwi v2, vs0, vs0, 3
; CHECK-BE-NEXT:    vpkudum v2, v2, v3
; CHECK-BE-NEXT:    stxv v2, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i64>, <16 x i64>* %0, align 128
  %1 = sitofp <16 x i64> %a to <16 x float>
  store <16 x float> %1, <16 x float>* %agg.result, align 64
  ret void
}
