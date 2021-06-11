; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

; A combine forming X86ISD::VSHLI was missing a test and not using
; TargetConstant for the RHS operand.
; https://bugs.chromium.org/p/chromium/issues/detail?id=1005750

define <8 x i8> @vshli_target_constant(<8 x i16> %arg, <8 x i32> %arg1) {
; CHECK-LABEL: vshli_target_constant:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    movdqa {{.*#+}} xmm0 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; CHECK-NEXT:    pmuludq %xmm0, %xmm1
; CHECK-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[1,3,2,3]
; CHECK-NEXT:    pmuludq %xmm0, %xmm3
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,3,2,3]
; CHECK-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm1[0],xmm4[1],xmm1[1]
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[1,1,3,3]
; CHECK-NEXT:    pmuludq %xmm0, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-NEXT:    pmuludq %xmm0, %xmm1
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,3,2,3]
; CHECK-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; CHECK-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    pslld $15, %xmm2
; CHECK-NEXT:    psrad $16, %xmm2
; CHECK-NEXT:    pslld $15, %xmm4
; CHECK-NEXT:    psrad $16, %xmm4
; CHECK-NEXT:    packssdw %xmm2, %xmm4
; CHECK-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm4
; CHECK-NEXT:    pxor %xmm0, %xmm0
; CHECK-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; CHECK-NEXT:    pmullw %xmm4, %xmm1
; CHECK-NEXT:    movdqa %xmm1, %xmm0
; CHECK-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3]
; CHECK-NEXT:    punpckhwd {{.*#+}} xmm1 = xmm1[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    movdqa {{.*#+}} xmm2 = [128,128,128,128]
; CHECK-NEXT:    paddd %xmm2, %xmm1
; CHECK-NEXT:    paddd %xmm2, %xmm0
; CHECK-NEXT:    psrld $8, %xmm0
; CHECK-NEXT:    psrld $8, %xmm1
; CHECK-NEXT:    movdqa {{.*#+}} xmm2 = [255,0,0,0,255,0,0,0,255,0,0,0,255,0,0,0]
; CHECK-NEXT:    pand %xmm2, %xmm1
; CHECK-NEXT:    pand %xmm2, %xmm0
; CHECK-NEXT:    packuswb %xmm1, %xmm0
; CHECK-NEXT:    packuswb %xmm0, %xmm0
; CHECK-NEXT:    retq
bb:
  %tmp = udiv <8 x i32> %arg1, <i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3>
  %tmp2 = and <8 x i32> %tmp, <i32 255, i32 255, i32 255, i32 255, i32 255, i32 255, i32 255, i32 255>
  %tmp3 = load <8 x i8>, <8 x i8>* undef, align 1
  %tmp4 = zext <8 x i8> %tmp3 to <8 x i32>
  %tmp5 = mul nuw nsw <8 x i32> %tmp2, %tmp4
  %tmp6 = add nuw nsw <8 x i32> %tmp5, <i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128>
  %tmp7 = lshr <8 x i32> %tmp6, <i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>
  %tmp8 = trunc <8 x i32> %tmp7 to <8 x i8>
  ret <8 x i8> %tmp8
}
