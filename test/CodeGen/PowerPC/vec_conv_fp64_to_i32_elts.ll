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

define i64 @test2elt(<2 x double> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvdpuxws f1, v2
; CHECK-P8-NEXT:    xscvdpuxws f0, f0
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrwz v2, r3
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    mtvsrwz v3, r4
; CHECK-P8-NEXT:    vmrghw v2, v2, v3
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpuxws f0, v2
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    mtvsrwz v3, r3
; CHECK-P9-NEXT:    xscvdpuxws f0, f0
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrwz v2, r3
; CHECK-P9-NEXT:    vmrghw v2, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xscvdpuxws f0, v2
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpuxws f0, f0
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    vmrgow v2, v3, v2
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptoui <2 x double> %a to <2 x i32>
  %1 = bitcast <2 x i32> %0 to i64
  ret i64 %1
}

define <4 x i32> @test4elt(<4 x double>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxmrgld vs2, vs0, vs1
; CHECK-P8-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P8-NEXT:    xvcvdpuxws v2, vs2
; CHECK-P8-NEXT:    xvcvdpuxws v3, vs0
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 0(r3)
; CHECK-P9-NEXT:    lxv vs1, 16(r3)
; CHECK-P9-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xvcvdpuxws v2, vs2
; CHECK-P9-NEXT:    xvcvdpuxws v3, vs0
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 16(r3)
; CHECK-BE-NEXT:    lxv vs1, 0(r3)
; CHECK-BE-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xvcvdpuxws v2, vs2
; CHECK-BE-NEXT:    xvcvdpuxws v3, vs0
; CHECK-BE-NEXT:    vmrgew v2, v3, v2
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x double>, <4 x double>* %0, align 32
  %1 = fptoui <4 x double> %a to <4 x i32>
  ret <4 x i32> %1
}

define void @test8elt(<8 x i32>* noalias nocapture sret(<8 x i32>) %agg.result, <8 x double>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r5
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xxmrgld vs4, vs1, vs0
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xxmrgld vs1, vs2, vs3
; CHECK-P8-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-P8-NEXT:    xvcvdpuxws v2, vs4
; CHECK-P8-NEXT:    xvcvdpuxws v3, vs0
; CHECK-P8-NEXT:    xvcvdpuxws v4, vs1
; CHECK-P8-NEXT:    xvcvdpuxws v5, vs2
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    vmrgew v3, v5, v4
; CHECK-P8-NEXT:    stvx v2, r3, r5
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs2, 0(r4)
; CHECK-P9-NEXT:    lxv vs3, 16(r4)
; CHECK-P9-NEXT:    lxv vs0, 32(r4)
; CHECK-P9-NEXT:    lxv vs1, 48(r4)
; CHECK-P9-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-P9-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-P9-NEXT:    xvcvdpuxws v2, vs4
; CHECK-P9-NEXT:    xvcvdpuxws v3, vs2
; CHECK-P9-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xvcvdpuxws v4, vs0
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    xvcvdpuxws v3, vs2
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    vmrgew v3, v4, v3
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs2, 16(r4)
; CHECK-BE-NEXT:    lxv vs3, 0(r4)
; CHECK-BE-NEXT:    lxv vs0, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 32(r4)
; CHECK-BE-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-BE-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-BE-NEXT:    xvcvdpuxws v2, vs4
; CHECK-BE-NEXT:    xvcvdpuxws v3, vs2
; CHECK-BE-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xvcvdpuxws v4, vs0
; CHECK-BE-NEXT:    vmrgew v2, v3, v2
; CHECK-BE-NEXT:    xvcvdpuxws v3, vs2
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    vmrgew v3, v4, v3
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x double>, <8 x double>* %0, align 64
  %1 = fptoui <8 x double> %a to <8 x i32>
  store <8 x i32> %1, <8 x i32>* %agg.result, align 32
  ret void
}

define void @test16elt(<16 x i32>* noalias nocapture sret(<16 x i32>) %agg.result, <16 x double>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    li r8, 64
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    li r9, 80
; CHECK-P8-NEXT:    lxvd2x vs7, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r8
; CHECK-P8-NEXT:    li r8, 96
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs5, r4, r8
; CHECK-P8-NEXT:    li r8, 112
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r9
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    lxvd2x vs6, r4, r8
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xxswapd vs4, vs4
; CHECK-P8-NEXT:    xxswapd vs5, vs5
; CHECK-P8-NEXT:    xxmrgld vs8, vs1, vs0
; CHECK-P8-NEXT:    xxswapd vs6, vs6
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs7
; CHECK-P8-NEXT:    xxmrgld vs7, vs4, vs3
; CHECK-P8-NEXT:    xxmrghd vs3, vs4, vs3
; CHECK-P8-NEXT:    xxmrgld vs4, vs6, vs5
; CHECK-P8-NEXT:    xvcvdpuxws v2, vs8
; CHECK-P8-NEXT:    xvcvdpuxws v3, vs0
; CHECK-P8-NEXT:    xxmrghd vs0, vs6, vs5
; CHECK-P8-NEXT:    xxmrgld vs5, vs2, vs1
; CHECK-P8-NEXT:    xxmrghd vs1, vs2, vs1
; CHECK-P8-NEXT:    xvcvdpuxws v4, vs7
; CHECK-P8-NEXT:    xvcvdpuxws v5, vs3
; CHECK-P8-NEXT:    xvcvdpuxws v0, vs4
; CHECK-P8-NEXT:    xvcvdpuxws v1, vs0
; CHECK-P8-NEXT:    xvcvdpuxws v6, vs5
; CHECK-P8-NEXT:    xvcvdpuxws v7, vs1
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    vmrgew v3, v5, v4
; CHECK-P8-NEXT:    vmrgew v4, v1, v0
; CHECK-P8-NEXT:    vmrgew v5, v7, v6
; CHECK-P8-NEXT:    stvx v2, r3, r7
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    stvx v4, r3, r6
; CHECK-P8-NEXT:    stvx v5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs6, 0(r4)
; CHECK-P9-NEXT:    lxv vs7, 16(r4)
; CHECK-P9-NEXT:    lxv vs4, 32(r4)
; CHECK-P9-NEXT:    lxv vs5, 48(r4)
; CHECK-P9-NEXT:    xxmrgld vs8, vs7, vs6
; CHECK-P9-NEXT:    xxmrghd vs6, vs7, vs6
; CHECK-P9-NEXT:    xxmrgld vs7, vs5, vs4
; CHECK-P9-NEXT:    xxmrghd vs4, vs5, vs4
; CHECK-P9-NEXT:    lxv vs2, 64(r4)
; CHECK-P9-NEXT:    lxv vs3, 80(r4)
; CHECK-P9-NEXT:    lxv vs0, 96(r4)
; CHECK-P9-NEXT:    lxv vs1, 112(r4)
; CHECK-P9-NEXT:    xvcvdpuxws v2, vs8
; CHECK-P9-NEXT:    xvcvdpuxws v3, vs6
; CHECK-P9-NEXT:    xvcvdpuxws v4, vs7
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    xvcvdpuxws v3, vs4
; CHECK-P9-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-P9-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    xvcvdpuxws v5, vs2
; CHECK-P9-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xvcvdpuxws v0, vs0
; CHECK-P9-NEXT:    vmrgew v3, v3, v4
; CHECK-P9-NEXT:    xvcvdpuxws v4, vs4
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    vmrgew v4, v5, v4
; CHECK-P9-NEXT:    stxv v4, 32(r3)
; CHECK-P9-NEXT:    xvcvdpuxws v5, vs2
; CHECK-P9-NEXT:    vmrgew v5, v0, v5
; CHECK-P9-NEXT:    stxv v5, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs6, 16(r4)
; CHECK-BE-NEXT:    lxv vs7, 0(r4)
; CHECK-BE-NEXT:    lxv vs4, 48(r4)
; CHECK-BE-NEXT:    lxv vs5, 32(r4)
; CHECK-BE-NEXT:    xxmrgld vs8, vs7, vs6
; CHECK-BE-NEXT:    xxmrghd vs6, vs7, vs6
; CHECK-BE-NEXT:    xxmrgld vs7, vs5, vs4
; CHECK-BE-NEXT:    xxmrghd vs4, vs5, vs4
; CHECK-BE-NEXT:    lxv vs2, 80(r4)
; CHECK-BE-NEXT:    lxv vs3, 64(r4)
; CHECK-BE-NEXT:    lxv vs0, 112(r4)
; CHECK-BE-NEXT:    lxv vs1, 96(r4)
; CHECK-BE-NEXT:    xvcvdpuxws v2, vs8
; CHECK-BE-NEXT:    xvcvdpuxws v3, vs6
; CHECK-BE-NEXT:    xvcvdpuxws v4, vs7
; CHECK-BE-NEXT:    vmrgew v2, v3, v2
; CHECK-BE-NEXT:    xvcvdpuxws v3, vs4
; CHECK-BE-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-BE-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    xvcvdpuxws v5, vs2
; CHECK-BE-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xvcvdpuxws v0, vs0
; CHECK-BE-NEXT:    vmrgew v3, v3, v4
; CHECK-BE-NEXT:    xvcvdpuxws v4, vs4
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    vmrgew v4, v5, v4
; CHECK-BE-NEXT:    stxv v4, 32(r3)
; CHECK-BE-NEXT:    xvcvdpuxws v5, vs2
; CHECK-BE-NEXT:    vmrgew v5, v0, v5
; CHECK-BE-NEXT:    stxv v5, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x double>, <16 x double>* %0, align 128
  %1 = fptoui <16 x double> %a to <16 x i32>
  store <16 x i32> %1, <16 x i32>* %agg.result, align 64
  ret void
}

define i64 @test2elt_signed(<2 x double> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvdpsxws f1, v2
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrwz v2, r3
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    mtvsrwz v3, r4
; CHECK-P8-NEXT:    vmrghw v2, v2, v3
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpsxws f0, v2
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    mtvsrwz v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrwz v2, r3
; CHECK-P9-NEXT:    vmrghw v2, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xscvdpsxws f0, v2
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    xxswapd vs0, v2
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    vmrgow v2, v3, v2
; CHECK-BE-NEXT:    mfvsrd r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptosi <2 x double> %a to <2 x i32>
  %1 = bitcast <2 x i32> %0 to i64
  ret i64 %1
}

define <4 x i32> @test4elt_signed(<4 x double>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxmrgld vs2, vs0, vs1
; CHECK-P8-NEXT:    xxmrghd vs0, vs0, vs1
; CHECK-P8-NEXT:    xvcvdpsxws v2, vs2
; CHECK-P8-NEXT:    xvcvdpsxws v3, vs0
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 0(r3)
; CHECK-P9-NEXT:    lxv vs1, 16(r3)
; CHECK-P9-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xvcvdpsxws v2, vs2
; CHECK-P9-NEXT:    xvcvdpsxws v3, vs0
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 16(r3)
; CHECK-BE-NEXT:    lxv vs1, 0(r3)
; CHECK-BE-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xvcvdpsxws v2, vs2
; CHECK-BE-NEXT:    xvcvdpsxws v3, vs0
; CHECK-BE-NEXT:    vmrgew v2, v3, v2
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x double>, <4 x double>* %0, align 32
  %1 = fptosi <4 x double> %a to <4 x i32>
  ret <4 x i32> %1
}

define void @test8elt_signed(<8 x i32>* noalias nocapture sret(<8 x i32>) %agg.result, <8 x double>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r5
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xxmrgld vs4, vs1, vs0
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xxmrgld vs1, vs2, vs3
; CHECK-P8-NEXT:    xxmrghd vs2, vs2, vs3
; CHECK-P8-NEXT:    xvcvdpsxws v2, vs4
; CHECK-P8-NEXT:    xvcvdpsxws v3, vs0
; CHECK-P8-NEXT:    xvcvdpsxws v4, vs1
; CHECK-P8-NEXT:    xvcvdpsxws v5, vs2
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    vmrgew v3, v5, v4
; CHECK-P8-NEXT:    stvx v2, r3, r5
; CHECK-P8-NEXT:    stvx v3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs2, 0(r4)
; CHECK-P9-NEXT:    lxv vs3, 16(r4)
; CHECK-P9-NEXT:    lxv vs0, 32(r4)
; CHECK-P9-NEXT:    lxv vs1, 48(r4)
; CHECK-P9-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-P9-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-P9-NEXT:    xvcvdpsxws v2, vs4
; CHECK-P9-NEXT:    xvcvdpsxws v3, vs2
; CHECK-P9-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xvcvdpsxws v4, vs0
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    xvcvdpsxws v3, vs2
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    vmrgew v3, v4, v3
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs2, 16(r4)
; CHECK-BE-NEXT:    lxv vs3, 0(r4)
; CHECK-BE-NEXT:    lxv vs0, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 32(r4)
; CHECK-BE-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-BE-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-BE-NEXT:    xvcvdpsxws v2, vs4
; CHECK-BE-NEXT:    xvcvdpsxws v3, vs2
; CHECK-BE-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xvcvdpsxws v4, vs0
; CHECK-BE-NEXT:    vmrgew v2, v3, v2
; CHECK-BE-NEXT:    xvcvdpsxws v3, vs2
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    vmrgew v3, v4, v3
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x double>, <8 x double>* %0, align 64
  %1 = fptosi <8 x double> %a to <8 x i32>
  store <8 x i32> %1, <8 x i32>* %agg.result, align 32
  ret void
}

define void @test16elt_signed(<16 x i32>* noalias nocapture sret(<16 x i32>) %agg.result, <16 x double>* nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 32
; CHECK-P8-NEXT:    li r6, 48
; CHECK-P8-NEXT:    li r8, 64
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    li r9, 80
; CHECK-P8-NEXT:    lxvd2x vs7, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r8
; CHECK-P8-NEXT:    li r8, 96
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs5, r4, r8
; CHECK-P8-NEXT:    li r8, 112
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r9
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs1
; CHECK-P8-NEXT:    lxvd2x vs6, r4, r8
; CHECK-P8-NEXT:    xxswapd vs2, vs2
; CHECK-P8-NEXT:    xxswapd vs3, vs3
; CHECK-P8-NEXT:    xxswapd vs4, vs4
; CHECK-P8-NEXT:    xxswapd vs5, vs5
; CHECK-P8-NEXT:    xxmrgld vs8, vs1, vs0
; CHECK-P8-NEXT:    xxswapd vs6, vs6
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xxswapd vs1, vs7
; CHECK-P8-NEXT:    xxmrgld vs7, vs4, vs3
; CHECK-P8-NEXT:    xxmrghd vs3, vs4, vs3
; CHECK-P8-NEXT:    xxmrgld vs4, vs6, vs5
; CHECK-P8-NEXT:    xvcvdpsxws v2, vs8
; CHECK-P8-NEXT:    xvcvdpsxws v3, vs0
; CHECK-P8-NEXT:    xxmrghd vs0, vs6, vs5
; CHECK-P8-NEXT:    xxmrgld vs5, vs2, vs1
; CHECK-P8-NEXT:    xxmrghd vs1, vs2, vs1
; CHECK-P8-NEXT:    xvcvdpsxws v4, vs7
; CHECK-P8-NEXT:    xvcvdpsxws v5, vs3
; CHECK-P8-NEXT:    xvcvdpsxws v0, vs4
; CHECK-P8-NEXT:    xvcvdpsxws v1, vs0
; CHECK-P8-NEXT:    xvcvdpsxws v6, vs5
; CHECK-P8-NEXT:    xvcvdpsxws v7, vs1
; CHECK-P8-NEXT:    vmrgew v2, v3, v2
; CHECK-P8-NEXT:    vmrgew v3, v5, v4
; CHECK-P8-NEXT:    vmrgew v4, v1, v0
; CHECK-P8-NEXT:    vmrgew v5, v7, v6
; CHECK-P8-NEXT:    stvx v2, r3, r7
; CHECK-P8-NEXT:    stvx v3, r3, r5
; CHECK-P8-NEXT:    stvx v4, r3, r6
; CHECK-P8-NEXT:    stvx v5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs6, 0(r4)
; CHECK-P9-NEXT:    lxv vs7, 16(r4)
; CHECK-P9-NEXT:    lxv vs4, 32(r4)
; CHECK-P9-NEXT:    lxv vs5, 48(r4)
; CHECK-P9-NEXT:    xxmrgld vs8, vs7, vs6
; CHECK-P9-NEXT:    xxmrghd vs6, vs7, vs6
; CHECK-P9-NEXT:    xxmrgld vs7, vs5, vs4
; CHECK-P9-NEXT:    xxmrghd vs4, vs5, vs4
; CHECK-P9-NEXT:    lxv vs2, 64(r4)
; CHECK-P9-NEXT:    lxv vs3, 80(r4)
; CHECK-P9-NEXT:    lxv vs0, 96(r4)
; CHECK-P9-NEXT:    lxv vs1, 112(r4)
; CHECK-P9-NEXT:    xvcvdpsxws v2, vs8
; CHECK-P9-NEXT:    xvcvdpsxws v3, vs6
; CHECK-P9-NEXT:    xvcvdpsxws v4, vs7
; CHECK-P9-NEXT:    vmrgew v2, v3, v2
; CHECK-P9-NEXT:    xvcvdpsxws v3, vs4
; CHECK-P9-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-P9-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-P9-NEXT:    stxv v2, 0(r3)
; CHECK-P9-NEXT:    xvcvdpsxws v5, vs2
; CHECK-P9-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    xvcvdpsxws v0, vs0
; CHECK-P9-NEXT:    vmrgew v3, v3, v4
; CHECK-P9-NEXT:    xvcvdpsxws v4, vs4
; CHECK-P9-NEXT:    stxv v3, 16(r3)
; CHECK-P9-NEXT:    vmrgew v4, v5, v4
; CHECK-P9-NEXT:    stxv v4, 32(r3)
; CHECK-P9-NEXT:    xvcvdpsxws v5, vs2
; CHECK-P9-NEXT:    vmrgew v5, v0, v5
; CHECK-P9-NEXT:    stxv v5, 48(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs6, 16(r4)
; CHECK-BE-NEXT:    lxv vs7, 0(r4)
; CHECK-BE-NEXT:    lxv vs4, 48(r4)
; CHECK-BE-NEXT:    lxv vs5, 32(r4)
; CHECK-BE-NEXT:    xxmrgld vs8, vs7, vs6
; CHECK-BE-NEXT:    xxmrghd vs6, vs7, vs6
; CHECK-BE-NEXT:    xxmrgld vs7, vs5, vs4
; CHECK-BE-NEXT:    xxmrghd vs4, vs5, vs4
; CHECK-BE-NEXT:    lxv vs2, 80(r4)
; CHECK-BE-NEXT:    lxv vs3, 64(r4)
; CHECK-BE-NEXT:    lxv vs0, 112(r4)
; CHECK-BE-NEXT:    lxv vs1, 96(r4)
; CHECK-BE-NEXT:    xvcvdpsxws v2, vs8
; CHECK-BE-NEXT:    xvcvdpsxws v3, vs6
; CHECK-BE-NEXT:    xvcvdpsxws v4, vs7
; CHECK-BE-NEXT:    vmrgew v2, v3, v2
; CHECK-BE-NEXT:    xvcvdpsxws v3, vs4
; CHECK-BE-NEXT:    xxmrgld vs4, vs3, vs2
; CHECK-BE-NEXT:    xxmrghd vs2, vs3, vs2
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    xvcvdpsxws v5, vs2
; CHECK-BE-NEXT:    xxmrgld vs2, vs1, vs0
; CHECK-BE-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-BE-NEXT:    xvcvdpsxws v0, vs0
; CHECK-BE-NEXT:    vmrgew v3, v3, v4
; CHECK-BE-NEXT:    xvcvdpsxws v4, vs4
; CHECK-BE-NEXT:    stxv v3, 16(r3)
; CHECK-BE-NEXT:    vmrgew v4, v5, v4
; CHECK-BE-NEXT:    stxv v4, 32(r3)
; CHECK-BE-NEXT:    xvcvdpsxws v5, vs2
; CHECK-BE-NEXT:    vmrgew v5, v0, v5
; CHECK-BE-NEXT:    stxv v5, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x double>, <16 x double>* %0, align 128
  %1 = fptosi <16 x double> %a to <16 x i32>
  store <16 x i32> %1, <16 x i32>* %agg.result, align 64
  ret void
}
