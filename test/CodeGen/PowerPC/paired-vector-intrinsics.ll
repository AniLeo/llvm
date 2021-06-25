; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O3 \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O3 \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr -mattr=-mma \
; RUN:   < %s | FileCheck %s --check-prefix=CHECK-NOMMA
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O3 \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s | FileCheck %s --check-prefix=CHECK-BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O3 \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr -mattr=-mma \
; RUN:   < %s | FileCheck %s --check-prefix=CHECK-BE-NOMMA

; This test also checks that the paired vector intrinsics are available even
; when MMA is disabled.

; assemble_pair
declare <256 x i1> @llvm.ppc.vsx.assemble.pair(<16 x i8>, <16 x i8>)
define void @ass_pair(<256 x i1>* %ptr, <16 x i8> %vc) {
; CHECK-LABEL: ass_pair:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmr v3, v2
; CHECK-NEXT:    stxv v2, 16(r3)
; CHECK-NEXT:    stxv v3, 0(r3)
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: ass_pair:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    vmr v3, v2
; CHECK-NOMMA-NEXT:    stxv v2, 16(r3)
; CHECK-NOMMA-NEXT:    stxv v3, 0(r3)
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: ass_pair:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    vmr v3, v2
; CHECK-BE-NEXT:    stxv v2, 16(r3)
; CHECK-BE-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: ass_pair:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    vmr v3, v2
; CHECK-BE-NOMMA-NEXT:    stxv v2, 16(r3)
; CHECK-BE-NOMMA-NEXT:    stxv v2, 0(r3)
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = tail call <256 x i1> @llvm.ppc.vsx.assemble.pair(<16 x i8> %vc, <16 x i8> %vc)
  store <256 x i1> %0, <256 x i1>* %ptr, align 32
  ret void
}

; disassemble_pair
declare { <16 x i8>, <16 x i8> } @llvm.ppc.vsx.disassemble.pair(<256 x i1>)
define void @disass_pair(<256 x i1>* %ptr1, <16 x i8>* %ptr2, <16 x i8>* %ptr3) {
; CHECK-LABEL: disass_pair:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v3, 0(r3)
; CHECK-NEXT:    lxv v2, 16(r3)
; CHECK-NEXT:    stxv v3, 0(r4)
; CHECK-NEXT:    stxv v2, 0(r5)
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: disass_pair:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    lxv v3, 0(r3)
; CHECK-NOMMA-NEXT:    lxv v2, 16(r3)
; CHECK-NOMMA-NEXT:    stxv v3, 0(r4)
; CHECK-NOMMA-NEXT:    stxv v2, 0(r5)
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: disass_pair:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v3, 16(r3)
; CHECK-BE-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NEXT:    stxv v2, 0(r4)
; CHECK-BE-NEXT:    stxv v3, 0(r5)
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: disass_pair:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    lxv v3, 16(r3)
; CHECK-BE-NOMMA-NEXT:    lxv v2, 0(r3)
; CHECK-BE-NOMMA-NEXT:    stxv v2, 0(r4)
; CHECK-BE-NOMMA-NEXT:    stxv v3, 0(r5)
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = load <256 x i1>, <256 x i1>* %ptr1, align 32
  %1 = tail call { <16 x i8>, <16 x i8> } @llvm.ppc.vsx.disassemble.pair(<256 x i1> %0)
  %2 = extractvalue { <16 x i8>, <16 x i8> } %1, 0
  %3 = extractvalue { <16 x i8>, <16 x i8> } %1, 1
  store <16 x i8> %2, <16 x i8>* %ptr2, align 16
  store <16 x i8> %3, <16 x i8>* %ptr3, align 16
  ret void
}

define void @test_ldst_1(<256 x i1>* %vpp, <256 x i1>* %vp2) {
; CHECK-LABEL: test_ldst_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxvp vsp34, 0(r3)
; CHECK-NEXT:    stxvp vsp34, 0(r4)
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: test_ldst_1:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    lxvp vsp34, 0(r3)
; CHECK-NOMMA-NEXT:    stxvp vsp34, 0(r4)
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: test_ldst_1:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxvp vsp34, 0(r3)
; CHECK-BE-NEXT:    stxvp vsp34, 0(r4)
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: test_ldst_1:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    lxvp vsp34, 0(r3)
; CHECK-BE-NOMMA-NEXT:    stxvp vsp34, 0(r4)
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = bitcast <256 x i1>* %vpp to i8*
  %1 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %0)
  %2 = bitcast <256 x i1>* %vp2 to i8*
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %1, i8* %2)
  ret void
}

declare <256 x i1> @llvm.ppc.vsx.lxvp(i8*)
declare void @llvm.ppc.vsx.stxvp(<256 x i1>, i8*)

define void @test_ldst_2(<256 x i1>* %vpp, i64 %offset, <256 x i1>* %vp2)  {
; CHECK-LABEL: test_ldst_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxvpx vsp34, r3, r4
; CHECK-NEXT:    stxvpx vsp34, r5, r4
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: test_ldst_2:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    lxvpx vsp34, r3, r4
; CHECK-NOMMA-NEXT:    stxvpx vsp34, r5, r4
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: test_ldst_2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxvpx vsp34, r3, r4
; CHECK-BE-NEXT:    stxvpx vsp34, r5, r4
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: test_ldst_2:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    lxvpx vsp34, r3, r4
; CHECK-BE-NOMMA-NEXT:    stxvpx vsp34, r5, r4
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = bitcast <256 x i1>* %vpp to i8*
  %1 = getelementptr i8, i8* %0, i64 %offset
  %2 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %1)
  %3 = bitcast <256 x i1>* %vp2 to i8*
  %4 = getelementptr i8, i8* %3, i64 %offset
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %2, i8* %4)
  ret void
}

define void @test_ldst_3(<256 x i1>* %vpp, <256 x i1>* %vp2)  {
; CHECK-LABEL: test_ldst_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r5, 18
; CHECK-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: test_ldst_3:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    li r5, 18
; CHECK-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: test_ldst_3:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    li r5, 18
; CHECK-BE-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: test_ldst_3:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    li r5, 18
; CHECK-BE-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = bitcast <256 x i1>* %vpp to i8*
  %1 = getelementptr i8, i8* %0, i64 18
  %2 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %1)
  %3 = bitcast <256 x i1>* %vp2 to i8*
  %4 = getelementptr i8, i8* %3, i64 18
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %2, i8* %4)
  ret void
}

define void @test_ldst_4(<256 x i1>* %vpp, <256 x i1>* %vp2)  {
; CHECK-LABEL: test_ldst_4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r5, 1
; CHECK-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: test_ldst_4:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    li r5, 1
; CHECK-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: test_ldst_4:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    li r5, 1
; CHECK-BE-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: test_ldst_4:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    li r5, 1
; CHECK-BE-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = bitcast <256 x i1>* %vpp to i8*
  %1 = getelementptr i8, i8* %0, i64 1
  %2 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %1)
  %3 = bitcast <256 x i1>* %vp2 to i8*
  %4 = getelementptr i8, i8* %3, i64 1
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %2, i8* %4)
  ret void
}

define void @test_ldst_5(<256 x i1>* %vpp, <256 x i1>* %vp2)  {
; CHECK-LABEL: test_ldst_5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r5, 42
; CHECK-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: test_ldst_5:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    li r5, 42
; CHECK-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: test_ldst_5:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    li r5, 42
; CHECK-BE-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: test_ldst_5:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    li r5, 42
; CHECK-BE-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = bitcast <256 x i1>* %vpp to i8*
  %1 = getelementptr i8, i8* %0, i64 42
  %2 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %1)
  %3 = bitcast <256 x i1>* %vp2 to i8*
  %4 = getelementptr i8, i8* %3, i64 42
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %2, i8* %4)
  ret void
}

define void @test_ldst_6(<256 x i1>* %vpp, <256 x i1>* %vp2)  {
; CHECK-LABEL: test_ldst_6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxvp vsp34, 4096(r3)
; CHECK-NEXT:    stxvp vsp34, 4096(r4)
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: test_ldst_6:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    lxvp vsp34, 4096(r3)
; CHECK-NOMMA-NEXT:    stxvp vsp34, 4096(r4)
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: test_ldst_6:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxvp vsp34, 4096(r3)
; CHECK-BE-NEXT:    stxvp vsp34, 4096(r4)
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: test_ldst_6:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    lxvp vsp34, 4096(r3)
; CHECK-BE-NOMMA-NEXT:    stxvp vsp34, 4096(r4)
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = getelementptr <256 x i1>, <256 x i1>* %vpp, i64 128
  %1 = bitcast <256 x i1>* %0 to i8*
  %2 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %1)
  %3 = getelementptr <256 x i1>, <256 x i1>* %vp2, i64 128
  %4 = bitcast <256 x i1>* %3 to i8*
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %2, i8* %4)
  ret void
}

define void @test_ldst_7(<256 x i1>* %vpp, <256 x i1>* %vp2)  {
; FIXME: A prefixed load (plxvp) is expected here as the offset in this
; test case is a constant that fits within 34-bits.
; CHECK-LABEL: test_ldst_7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pli r5, 32799
; CHECK-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NEXT:    blr
;
; CHECK-NOMMA-LABEL: test_ldst_7:
; CHECK-NOMMA:       # %bb.0: # %entry
; CHECK-NOMMA-NEXT:    pli r5, 32799
; CHECK-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-NOMMA-NEXT:    blr
;
; CHECK-BE-LABEL: test_ldst_7:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    pli r5, 32799
; CHECK-BE-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-BE-NOMMA-LABEL: test_ldst_7:
; CHECK-BE-NOMMA:       # %bb.0: # %entry
; CHECK-BE-NOMMA-NEXT:    pli r5, 32799
; CHECK-BE-NOMMA-NEXT:    lxvpx vsp34, r3, r5
; CHECK-BE-NOMMA-NEXT:    stxvpx vsp34, r4, r5
; CHECK-BE-NOMMA-NEXT:    blr
entry:
  %0 = bitcast <256 x i1>* %vpp to i8*
  %1 = getelementptr i8, i8* %0, i64 32799
  %2 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %1)
  %3 = bitcast <256 x i1>* %vp2 to i8*
  %4 = getelementptr i8, i8* %3, i64 32799
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %2, i8* %4)
  ret void
}
