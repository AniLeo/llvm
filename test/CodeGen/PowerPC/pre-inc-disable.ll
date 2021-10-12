; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -O3 -verify-machineinstrs -ppc-vsr-nums-as-vr \
; RUN:     -ppc-asm-full-reg-names -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     < %s | FileCheck %s

; RUN: llc -mcpu=pwr9 -O3 -verify-machineinstrs -ppc-vsr-nums-as-vr \
; RUN:     -ppc-asm-full-reg-names -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     < %s | FileCheck %s --check-prefix=P9BE

; Function Attrs: norecurse nounwind readonly
define signext i32 @test_pre_inc_disable_1(i8* nocapture readonly %pix1, i32 signext %i_stride_pix1, i8* nocapture readonly %pix2) {
; CHECK-LABEL: test_pre_inc_disable_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxsd v5, 0(r5)
; CHECK-NEXT:    addis r5, r2, .LCPI0_0@toc@ha
; CHECK-NEXT:    xxlxor v3, v3, v3
; CHECK-NEXT:    li r6, 0
; CHECK-NEXT:    addi r5, r5, .LCPI0_0@toc@l
; CHECK-NEXT:    lxv v2, 0(r5)
; CHECK-NEXT:    addis r5, r2, .LCPI0_1@toc@ha
; CHECK-NEXT:    addi r5, r5, .LCPI0_1@toc@l
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    li r5, 4
; CHECK-NEXT:    vperm v0, v3, v5, v2
; CHECK-NEXT:    mtctr r5
; CHECK-NEXT:    li r5, 0
; CHECK-NEXT:    vperm v1, v3, v5, v4
; CHECK-NEXT:    xvnegsp v5, v0
; CHECK-NEXT:    xvnegsp v0, v1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_1: # %for.cond1.preheader
; CHECK-NEXT:    #
; CHECK-NEXT:    lxsd v1, 0(r3)
; CHECK-NEXT:    add r7, r3, r4
; CHECK-NEXT:    vperm v6, v3, v1, v4
; CHECK-NEXT:    vperm v1, v3, v1, v2
; CHECK-NEXT:    xvnegsp v1, v1
; CHECK-NEXT:    xvnegsp v6, v6
; CHECK-NEXT:    vabsduw v1, v1, v5
; CHECK-NEXT:    vabsduw v6, v6, v0
; CHECK-NEXT:    vadduwm v1, v6, v1
; CHECK-NEXT:    xxswapd v6, v1
; CHECK-NEXT:    vadduwm v1, v1, v6
; CHECK-NEXT:    xxspltw v6, v1, 2
; CHECK-NEXT:    vadduwm v1, v1, v6
; CHECK-NEXT:    lxsdx v6, r3, r4
; CHECK-NEXT:    vextuwrx r3, r5, v1
; CHECK-NEXT:    vperm v7, v3, v6, v4
; CHECK-NEXT:    vperm v6, v3, v6, v2
; CHECK-NEXT:    add r6, r3, r6
; CHECK-NEXT:    add r3, r7, r4
; CHECK-NEXT:    xvnegsp v6, v6
; CHECK-NEXT:    xvnegsp v1, v7
; CHECK-NEXT:    vabsduw v6, v6, v5
; CHECK-NEXT:    vabsduw v1, v1, v0
; CHECK-NEXT:    vadduwm v1, v1, v6
; CHECK-NEXT:    xxswapd v6, v1
; CHECK-NEXT:    vadduwm v1, v1, v6
; CHECK-NEXT:    xxspltw v6, v1, 2
; CHECK-NEXT:    vadduwm v1, v1, v6
; CHECK-NEXT:    vextuwrx r8, r5, v1
; CHECK-NEXT:    add r6, r8, r6
; CHECK-NEXT:    bdnz .LBB0_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    extsw r3, r6
; CHECK-NEXT:    blr
;
; P9BE-LABEL: test_pre_inc_disable_1:
; P9BE:       # %bb.0: # %entry
; P9BE-NEXT:    lxsd v5, 0(r5)
; P9BE-NEXT:    addis r5, r2, .LCPI0_0@toc@ha
; P9BE-NEXT:    xxlxor v3, v3, v3
; P9BE-NEXT:    li r6, 0
; P9BE-NEXT:    addi r5, r5, .LCPI0_0@toc@l
; P9BE-NEXT:    lxv v2, 0(r5)
; P9BE-NEXT:    addis r5, r2, .LCPI0_1@toc@ha
; P9BE-NEXT:    addi r5, r5, .LCPI0_1@toc@l
; P9BE-NEXT:    lxv v4, 0(r5)
; P9BE-NEXT:    li r5, 4
; P9BE-NEXT:    vperm v0, v3, v5, v2
; P9BE-NEXT:    mtctr r5
; P9BE-NEXT:    li r5, 0
; P9BE-NEXT:    vperm v1, v3, v5, v4
; P9BE-NEXT:    xvnegsp v5, v0
; P9BE-NEXT:    xvnegsp v0, v1
; P9BE-NEXT:    .p2align 4
; P9BE-NEXT:  .LBB0_1: # %for.cond1.preheader
; P9BE-NEXT:    #
; P9BE-NEXT:    lxsd v1, 0(r3)
; P9BE-NEXT:    add r7, r3, r4
; P9BE-NEXT:    vperm v6, v3, v1, v4
; P9BE-NEXT:    vperm v1, v3, v1, v2
; P9BE-NEXT:    xvnegsp v1, v1
; P9BE-NEXT:    xvnegsp v6, v6
; P9BE-NEXT:    vabsduw v1, v1, v5
; P9BE-NEXT:    vabsduw v6, v6, v0
; P9BE-NEXT:    vadduwm v1, v6, v1
; P9BE-NEXT:    xxswapd v6, v1
; P9BE-NEXT:    vadduwm v1, v1, v6
; P9BE-NEXT:    xxspltw v6, v1, 1
; P9BE-NEXT:    vadduwm v1, v1, v6
; P9BE-NEXT:    lxsdx v6, r3, r4
; P9BE-NEXT:    vextuwlx r3, r5, v1
; P9BE-NEXT:    vperm v7, v3, v6, v4
; P9BE-NEXT:    vperm v6, v3, v6, v2
; P9BE-NEXT:    add r6, r3, r6
; P9BE-NEXT:    add r3, r7, r4
; P9BE-NEXT:    xvnegsp v6, v6
; P9BE-NEXT:    xvnegsp v1, v7
; P9BE-NEXT:    vabsduw v6, v6, v5
; P9BE-NEXT:    vabsduw v1, v1, v0
; P9BE-NEXT:    vadduwm v1, v1, v6
; P9BE-NEXT:    xxswapd v6, v1
; P9BE-NEXT:    vadduwm v1, v1, v6
; P9BE-NEXT:    xxspltw v6, v1, 1
; P9BE-NEXT:    vadduwm v1, v1, v6
; P9BE-NEXT:    vextuwlx r8, r5, v1
; P9BE-NEXT:    add r6, r8, r6
; P9BE-NEXT:    bdnz .LBB0_1
; P9BE-NEXT:  # %bb.2: # %for.cond.cleanup
; P9BE-NEXT:    extsw r3, r6
; P9BE-NEXT:    blr
entry:
  %idx.ext = sext i32 %i_stride_pix1 to i64
  %0 = bitcast i8* %pix2 to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %for.cond1.preheader, %entry
  %y.024 = phi i32 [ 0, %entry ], [ %inc9.1, %for.cond1.preheader ]
  %i_sum.023 = phi i32 [ 0, %entry ], [ %op.extra.1, %for.cond1.preheader ]
  %pix1.addr.022 = phi i8* [ %pix1, %entry ], [ %add.ptr.1, %for.cond1.preheader ]
  %3 = bitcast i8* %pix1.addr.022 to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %5, %2
  %7 = icmp slt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %rdx.shuf = shufflevector <8 x i32> %9, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add nsw <8 x i32> %9, %rdx.shuf
  %rdx.shuf32 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx33 = add nsw <8 x i32> %bin.rdx, %rdx.shuf32
  %rdx.shuf34 = shufflevector <8 x i32> %bin.rdx33, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx35 = add nsw <8 x i32> %bin.rdx33, %rdx.shuf34
  %10 = extractelement <8 x i32> %bin.rdx35, i32 0
  %op.extra = add nsw i32 %10, %i_sum.023
  %add.ptr = getelementptr inbounds i8, i8* %pix1.addr.022, i64 %idx.ext
  %11 = bitcast i8* %add.ptr to <8 x i8>*
  %12 = load <8 x i8>, <8 x i8>* %11, align 1
  %13 = zext <8 x i8> %12 to <8 x i32>
  %14 = sub nsw <8 x i32> %13, %2
  %15 = icmp slt <8 x i32> %14, zeroinitializer
  %16 = sub nsw <8 x i32> zeroinitializer, %14
  %17 = select <8 x i1> %15, <8 x i32> %16, <8 x i32> %14
  %rdx.shuf.1 = shufflevector <8 x i32> %17, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx.1 = add nsw <8 x i32> %17, %rdx.shuf.1
  %rdx.shuf32.1 = shufflevector <8 x i32> %bin.rdx.1, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx33.1 = add nsw <8 x i32> %bin.rdx.1, %rdx.shuf32.1
  %rdx.shuf34.1 = shufflevector <8 x i32> %bin.rdx33.1, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx35.1 = add nsw <8 x i32> %bin.rdx33.1, %rdx.shuf34.1
  %18 = extractelement <8 x i32> %bin.rdx35.1, i32 0
  %op.extra.1 = add nsw i32 %18, %op.extra
  %add.ptr.1 = getelementptr inbounds i8, i8* %add.ptr, i64 %idx.ext
  %inc9.1 = add nuw nsw i32 %y.024, 2
  %exitcond.1 = icmp eq i32 %inc9.1, 8
  br i1 %exitcond.1, label %for.cond.cleanup, label %for.cond1.preheader

for.cond.cleanup:                                 ; preds = %for.cond1.preheader
  ret i32 %op.extra.1
}

; Function Attrs: norecurse nounwind readonly
define signext i32 @test_pre_inc_disable_2(i8* nocapture readonly %pix1, i8* nocapture readonly %pix2) {
; CHECK-LABEL: test_pre_inc_disable_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxsd v2, 0(r3)
; CHECK-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-NEXT:    lxsd v1, 0(r4)
; CHECK-NEXT:    xxlxor v3, v3, v3
; CHECK-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-NEXT:    lxv v4, 0(r3)
; CHECK-NEXT:    addis r3, r2, .LCPI1_1@toc@ha
; CHECK-NEXT:    addi r3, r3, .LCPI1_1@toc@l
; CHECK-NEXT:    lxv v0, 0(r3)
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    vperm v5, v3, v2, v4
; CHECK-NEXT:    vperm v2, v3, v2, v0
; CHECK-NEXT:    vperm v0, v3, v1, v0
; CHECK-NEXT:    vperm v3, v3, v1, v4
; CHECK-NEXT:    vabsduw v2, v2, v0
; CHECK-NEXT:    vabsduw v3, v5, v3
; CHECK-NEXT:    vadduwm v2, v3, v2
; CHECK-NEXT:    xxswapd v3, v2
; CHECK-NEXT:    vadduwm v2, v2, v3
; CHECK-NEXT:    xxspltw v3, v2, 2
; CHECK-NEXT:    vadduwm v2, v2, v3
; CHECK-NEXT:    vextuwrx r3, r3, v2
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    blr
;
; P9BE-LABEL: test_pre_inc_disable_2:
; P9BE:       # %bb.0: # %entry
; P9BE-NEXT:    lxsd v2, 0(r3)
; P9BE-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; P9BE-NEXT:    lxsd v1, 0(r4)
; P9BE-NEXT:    xxlxor v3, v3, v3
; P9BE-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; P9BE-NEXT:    lxv v4, 0(r3)
; P9BE-NEXT:    addis r3, r2, .LCPI1_1@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI1_1@toc@l
; P9BE-NEXT:    lxv v0, 0(r3)
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    vperm v5, v3, v2, v4
; P9BE-NEXT:    vperm v2, v3, v2, v0
; P9BE-NEXT:    vperm v0, v3, v1, v0
; P9BE-NEXT:    vperm v3, v3, v1, v4
; P9BE-NEXT:    vabsduw v2, v2, v0
; P9BE-NEXT:    vabsduw v3, v5, v3
; P9BE-NEXT:    vadduwm v2, v3, v2
; P9BE-NEXT:    xxswapd v3, v2
; P9BE-NEXT:    vadduwm v2, v2, v3
; P9BE-NEXT:    xxspltw v3, v2, 1
; P9BE-NEXT:    vadduwm v2, v2, v3
; P9BE-NEXT:    vextuwlx r3, r3, v2
; P9BE-NEXT:    extsw r3, r3
; P9BE-NEXT:    blr
entry:
  %0 = bitcast i8* %pix1 to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  %3 = bitcast i8* %pix2 to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp slt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %rdx.shuf = shufflevector <8 x i32> %9, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add nsw <8 x i32> %9, %rdx.shuf
  %rdx.shuf12 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx13 = add nsw <8 x i32> %bin.rdx, %rdx.shuf12
  %rdx.shuf14 = shufflevector <8 x i32> %bin.rdx13, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx15 = add nsw <8 x i32> %bin.rdx13, %rdx.shuf14
  %10 = extractelement <8 x i32> %bin.rdx15, i32 0
  ret i32 %10
}


; Generated from C source:
;
;#include <stdint.h>
;#include <stdlib.h>
;int test_pre_inc_disable_1( uint8_t *pix1, int i_stride_pix1, uint8_t *pix2 ) {
;    int i_sum = 0;
;    for( int y = 0; y < 8; y++ ) {
;        for( int x = 0; x < 8; x++) {
;            i_sum += abs( pix1[x] - pix2[x] )
;        }
;        pix1 += i_stride_pix1;
;    }
;    return i_sum;
;}

;int test_pre_inc_disable_2( uint8_t *pix1, uint8_t *pix2 ) {
;  int i_sum = 0;
;  for( int x = 0; x < 8; x++ ) {
;    i_sum += abs( pix1[x] - pix2[x] );
;  }
;
;  return i_sum;
;}

define void @test32(i8* nocapture readonly %pix2, i32 signext %i_pix2) {
; CHECK-LABEL: test32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    add r5, r3, r4
; CHECK-NEXT:    lxsiwzx v2, r3, r4
; CHECK-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-NEXT:    xxlxor v3, v3, v3
; CHECK-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-NEXT:    lxv v4, 0(r3)
; CHECK-NEXT:    li r3, 4
; CHECK-NEXT:    lxsiwzx v5, r5, r3
; CHECK-NEXT:    vperm v2, v2, v3, v4
; CHECK-NEXT:    vperm v3, v5, v3, v4
; CHECK-NEXT:    vspltisw v4, 8
; CHECK-NEXT:    vnegw v3, v3
; CHECK-NEXT:    vadduwm v4, v4, v4
; CHECK-NEXT:    vslw v3, v3, v4
; CHECK-NEXT:    vsubuwm v2, v3, v2
; CHECK-NEXT:    xxswapd vs0, v2
; CHECK-NEXT:    stxv vs0, 0(r3)
; CHECK-NEXT:    blr
;
; P9BE-LABEL: test32:
; P9BE:       # %bb.0: # %entry
; P9BE-NEXT:    add r5, r3, r4
; P9BE-NEXT:    lxsiwzx v2, r3, r4
; P9BE-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; P9BE-NEXT:    xxlxor v3, v3, v3
; P9BE-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; P9BE-NEXT:    lxv v4, 0(r3)
; P9BE-NEXT:    li r3, 4
; P9BE-NEXT:    lxsiwzx v5, r5, r3
; P9BE-NEXT:    vperm v2, v3, v2, v4
; P9BE-NEXT:    vperm v3, v3, v5, v4
; P9BE-NEXT:    vspltisw v4, 8
; P9BE-NEXT:    vnegw v3, v3
; P9BE-NEXT:    vadduwm v4, v4, v4
; P9BE-NEXT:    vslw v3, v3, v4
; P9BE-NEXT:    vsubuwm v2, v3, v2
; P9BE-NEXT:    xxswapd vs0, v2
; P9BE-NEXT:    stxv vs0, 0(r3)
; P9BE-NEXT:    blr
entry:
  %idx.ext63 = sext i32 %i_pix2 to i64
  %add.ptr64 = getelementptr inbounds i8, i8* %pix2, i64 %idx.ext63
  %arrayidx5.1 = getelementptr inbounds i8, i8* %add.ptr64, i64 4
  %0 = bitcast i8* %add.ptr64 to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %reorder_shuffle117 = shufflevector <4 x i8> %1, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %2 = zext <4 x i8> %reorder_shuffle117 to <4 x i32>
  %3 = sub nsw <4 x i32> zeroinitializer, %2
  %4 = bitcast i8* %arrayidx5.1 to <4 x i8>*
  %5 = load <4 x i8>, <4 x i8>* %4, align 1
  %reorder_shuffle115 = shufflevector <4 x i8> %5, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %6 = zext <4 x i8> %reorder_shuffle115 to <4 x i32>
  %7 = sub nsw <4 x i32> zeroinitializer, %6
  %8 = shl nsw <4 x i32> %7, <i32 16, i32 16, i32 16, i32 16>
  %9 = add nsw <4 x i32> %8, %3
  %10 = sub nsw <4 x i32> %9, zeroinitializer
  %11 = shufflevector <4 x i32> undef, <4 x i32> %10, <4 x i32> <i32 2, i32 7, i32 0, i32 5>
  %12 = add nsw <4 x i32> zeroinitializer, %11
  %13 = shufflevector <4 x i32> %12, <4 x i32> undef, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  store <4 x i32> %13, <4 x i32>* undef, align 16
  ret void
}

define void @test16(i16* nocapture readonly %sums, i32 signext %delta, i32 signext %thresh) {
; CHECK-LABEL: test16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r4, r4, 1
; CHECK-NEXT:    li r7, 16
; CHECK-NEXT:    add r6, r3, r4
; CHECK-NEXT:    lxsihzx v4, r3, r4
; CHECK-NEXT:    addis r3, r2, .LCPI3_0@toc@ha
; CHECK-NEXT:    lxsihzx v2, r6, r7
; CHECK-NEXT:    li r6, 0
; CHECK-NEXT:    addi r3, r3, .LCPI3_0@toc@l
; CHECK-NEXT:    mtvsrd v3, r6
; CHECK-NEXT:    vmrghh v4, v3, v4
; CHECK-NEXT:    vmrghh v2, v3, v2
; CHECK-NEXT:    vsplth v3, v3, 3
; CHECK-NEXT:    vmrglw v3, v4, v3
; CHECK-NEXT:    lxv v4, 0(r3)
; CHECK-NEXT:    addis r3, r2, .LCPI3_1@toc@ha
; CHECK-NEXT:    addi r3, r3, .LCPI3_1@toc@l
; CHECK-NEXT:    vperm v2, v2, v3, v4
; CHECK-NEXT:    lxv v3, 0(r3)
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    vsubuwm v2, v3, v2
; CHECK-NEXT:    vnegw v3, v2
; CHECK-NEXT:    xxspltw v3, v3, 2
; CHECK-NEXT:    vsubuwm v2, v3, v2
; CHECK-NEXT:    vextuwrx r3, r3, v2
; CHECK-NEXT:    cmpw r3, r5
; CHECK-NEXT:    bgelr+ cr0
; CHECK-NEXT:  # %bb.1: # %if.then
;
; P9BE-LABEL: test16:
; P9BE:       # %bb.0: # %entry
; P9BE-NEXT:    sldi r4, r4, 1
; P9BE-NEXT:    li r7, 16
; P9BE-NEXT:    add r6, r3, r4
; P9BE-NEXT:    lxsihzx v5, r3, r4
; P9BE-NEXT:    addis r3, r2, .LCPI3_1@toc@ha
; P9BE-NEXT:    lxsihzx v2, r6, r7
; P9BE-NEXT:    addis r6, r2, .LCPI3_0@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI3_1@toc@l
; P9BE-NEXT:    addi r6, r6, .LCPI3_0@toc@l
; P9BE-NEXT:    lxv v3, 0(r6)
; P9BE-NEXT:    li r6, 0
; P9BE-NEXT:    mtvsrwz v4, r6
; P9BE-NEXT:    vperm v2, v4, v2, v3
; P9BE-NEXT:    vperm v3, v4, v5, v3
; P9BE-NEXT:    vsplth v4, v4, 3
; P9BE-NEXT:    vmrghw v3, v4, v3
; P9BE-NEXT:    lxv v4, 0(r3)
; P9BE-NEXT:    addis r3, r2, .LCPI3_2@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI3_2@toc@l
; P9BE-NEXT:    vperm v2, v3, v2, v4
; P9BE-NEXT:    lxv v3, 0(r3)
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    vsubuwm v2, v3, v2
; P9BE-NEXT:    vnegw v3, v2
; P9BE-NEXT:    xxspltw v3, v3, 1
; P9BE-NEXT:    vsubuwm v2, v3, v2
; P9BE-NEXT:    vextuwlx r3, r3, v2
; P9BE-NEXT:    cmpw r3, r5
; P9BE-NEXT:    bgelr+ cr0
; P9BE-NEXT:  # %bb.1: # %if.then
entry:
  %idxprom = sext i32 %delta to i64
  %add14 = add nsw i32 %delta, 8
  %idxprom15 = sext i32 %add14 to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %arrayidx8 = getelementptr inbounds i16, i16* %sums, i64 %idxprom
  %0 = load i16, i16* %arrayidx8, align 2
  %arrayidx16 = getelementptr inbounds i16, i16* %sums, i64 %idxprom15
  %1 = load i16, i16* %arrayidx16, align 2
  %2 = insertelement <4 x i16> undef, i16 %0, i32 2
  %3 = insertelement <4 x i16> %2, i16 %1, i32 3
  %4 = zext <4 x i16> %3 to <4 x i32>
  %5 = sub nsw <4 x i32> <i32 1, i32 2, i32 3, i32 4>, %4
  %6 = sub nsw <4 x i32> zeroinitializer, %5
  %7 = select <4 x i1> undef, <4 x i32> %6, <4 x i32> %5
  %bin.rdx = add <4 x i32> %7, zeroinitializer
  %rdx.shuf54 = shufflevector <4 x i32> %bin.rdx, <4 x i32> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %bin.rdx55 = add <4 x i32> %bin.rdx, %rdx.shuf54
  %8 = extractelement <4 x i32> %bin.rdx55, i32 0
  %op.extra = add nuw i32 %8, 0
  %cmp25 = icmp slt i32 %op.extra, %thresh
  br i1 %cmp25, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  unreachable

if.end:                                           ; preds = %for.body
  ret void
}

define void @test8(i8* nocapture readonly %sums, i32 signext %delta, i32 signext %thresh) {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    add r6, r3, r4
; CHECK-NEXT:    lxsibzx v2, r3, r4
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    mtvsrd v3, r3
; CHECK-NEXT:    li r3, 8
; CHECK-NEXT:    lxsibzx v5, r6, r3
; CHECK-NEXT:    vspltb v4, v3, 7
; CHECK-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-NEXT:    vmrghb v2, v3, v2
; CHECK-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-NEXT:    vmrglh v2, v2, v4
; CHECK-NEXT:    vmrghb v3, v3, v5
; CHECK-NEXT:    vmrglw v2, v2, v4
; CHECK-NEXT:    vmrglh v3, v3, v4
; CHECK-NEXT:    vmrglw v3, v4, v3
; CHECK-NEXT:    lxv v4, 0(r3)
; CHECK-NEXT:    addis r3, r2, .LCPI4_1@toc@ha
; CHECK-NEXT:    addi r3, r3, .LCPI4_1@toc@l
; CHECK-NEXT:    vperm v2, v3, v2, v4
; CHECK-NEXT:    lxv v3, 0(r3)
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    vsubuwm v2, v3, v2
; CHECK-NEXT:    vnegw v3, v2
; CHECK-NEXT:    xxspltw v3, v3, 2
; CHECK-NEXT:    vsubuwm v2, v3, v2
; CHECK-NEXT:    vextuwrx r3, r3, v2
; CHECK-NEXT:    cmpw r3, r5
; CHECK-NEXT:    bgelr+ cr0
; CHECK-NEXT:  # %bb.1: # %if.then
;
; P9BE-LABEL: test8:
; P9BE:       # %bb.0: # %entry
; P9BE-NEXT:    add r6, r3, r4
; P9BE-NEXT:    li r7, 8
; P9BE-NEXT:    lxsibzx v5, r3, r4
; P9BE-NEXT:    addis r3, r2, .LCPI4_1@toc@ha
; P9BE-NEXT:    lxsibzx v2, r6, r7
; P9BE-NEXT:    addis r6, r2, .LCPI4_0@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI4_1@toc@l
; P9BE-NEXT:    addi r6, r6, .LCPI4_0@toc@l
; P9BE-NEXT:    lxv v3, 0(r6)
; P9BE-NEXT:    li r6, 0
; P9BE-NEXT:    mtvsrwz v4, r6
; P9BE-NEXT:    vperm v2, v4, v2, v3
; P9BE-NEXT:    vperm v3, v4, v5, v3
; P9BE-NEXT:    vspltb v4, v4, 7
; P9BE-NEXT:    vmrghh v3, v3, v4
; P9BE-NEXT:    xxspltw v4, v4, 0
; P9BE-NEXT:    vmrghw v2, v3, v2
; P9BE-NEXT:    lxv v3, 0(r3)
; P9BE-NEXT:    addis r3, r2, .LCPI4_2@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI4_2@toc@l
; P9BE-NEXT:    vperm v2, v4, v2, v3
; P9BE-NEXT:    lxv v3, 0(r3)
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    vsubuwm v2, v3, v2
; P9BE-NEXT:    vnegw v3, v2
; P9BE-NEXT:    xxspltw v3, v3, 1
; P9BE-NEXT:    vsubuwm v2, v3, v2
; P9BE-NEXT:    vextuwlx r3, r3, v2
; P9BE-NEXT:    cmpw r3, r5
; P9BE-NEXT:    bgelr+ cr0
; P9BE-NEXT:  # %bb.1: # %if.then
entry:
  %idxprom = sext i32 %delta to i64
  %add14 = add nsw i32 %delta, 8
  %idxprom15 = sext i32 %add14 to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %arrayidx8 = getelementptr inbounds i8, i8* %sums, i64 %idxprom
  %0 = load i8, i8* %arrayidx8, align 2
  %arrayidx16 = getelementptr inbounds i8, i8* %sums, i64 %idxprom15
  %1 = load i8, i8* %arrayidx16, align 2
  %2 = insertelement <4 x i8> undef, i8 %0, i32 2
  %3 = insertelement <4 x i8> %2, i8 %1, i32 3
  %4 = zext <4 x i8> %3 to <4 x i32>
  %5 = sub nsw <4 x i32> <i32 1, i32 2, i32 3, i32 4>, %4
  %6 = sub nsw <4 x i32> zeroinitializer, %5
  %7 = select <4 x i1> undef, <4 x i32> %6, <4 x i32> %5
  %bin.rdx = add <4 x i32> %7, zeroinitializer
  %rdx.shuf54 = shufflevector <4 x i32> %bin.rdx, <4 x i32> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %bin.rdx55 = add <4 x i32> %bin.rdx, %rdx.shuf54
  %8 = extractelement <4 x i32> %bin.rdx55, i32 0
  %op.extra = add nuw i32 %8, 0
  %cmp25 = icmp slt i32 %op.extra, %thresh
  br i1 %cmp25, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  unreachable

if.end:                                           ; preds = %for.body
  ret void
}
