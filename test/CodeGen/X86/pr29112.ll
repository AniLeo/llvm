; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512f | FileCheck %s

declare <4 x float> @foo(<4 x float>, <4 x float>, <4 x float>, <4 x float>, <4 x float>, <4 x float>, <4 x float>, <4 x float>, <4 x float>, <4 x float>)

; Due to a bug in X86RegisterInfo::getLargestLegalSuperClass this test case was trying to use XMM16 and spill it without VLX support for the necessary store instruction. We briefly implemented the spill using VEXTRACTF32X4, but the bug in getLargestLegalSuperClass has now been fixed so we no longer use XMM16.

define <4 x float> @bar(<4 x float>* %a1p, <4 x float>* %a2p, <4 x float> %a3, <4 x float> %a4, <16 x float>%c1, <16 x float>%c2) {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $88, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 96
; CHECK-NEXT:    vmovaps %xmm1, {{[0-9]+}}(%rsp) # 16-byte Spill
; CHECK-NEXT:    vextractf128 $1, %ymm3, %xmm1
; CHECK-NEXT:    vextractf128 $1, %ymm2, %xmm8
; CHECK-NEXT:    vinsertps {{.*#+}} xmm9 = xmm8[0],xmm1[0],xmm8[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm9[0,1],xmm2[1],xmm9[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm15 = xmm0[0,1,2],xmm3[1]
; CHECK-NEXT:    vblendps {{.*#+}} xmm4 = xmm8[0],xmm1[1],xmm8[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm2[1],xmm4[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm6 = xmm4[0,1,2],xmm3[1]
; CHECK-NEXT:    vmovaps %xmm6, {{[0-9]+}}(%rsp) # 16-byte Spill
; CHECK-NEXT:    vextractf32x4 $2, %zmm3, %xmm4
; CHECK-NEXT:    vblendps {{.*#+}} xmm4 = xmm0[0,1,2],xmm4[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm5 = xmm2[3,1,2,3]
; CHECK-NEXT:    vunpcklps {{.*#+}} xmm5 = xmm5[0],xmm1[0],xmm5[1],xmm1[1]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0,1],xmm2[1],xmm5[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0,1,2],xmm3[1]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm7 = xmm8[1,1,3,3]
; CHECK-NEXT:    vunpcklps {{.*#+}} xmm7 = xmm7[0],xmm1[0],xmm7[1],xmm1[1]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm10 = xmm7[0,1],xmm2[1],xmm7[3]
; CHECK-NEXT:    vblendps {{.*#+}} xmm7 = xmm10[0,1,2],xmm3[3]
; CHECK-NEXT:    vblendps {{.*#+}} xmm11 = xmm0[0,1,2],xmm3[3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm12 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm13 = xmm1[1,0]
; CHECK-NEXT:    vextractf32x4 $3, %zmm3, %xmm0
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm8[0],xmm0[0],xmm8[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],xmm2[1],xmm1[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm14 = xmm1[0,1,2],xmm3[1]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm10 = xmm10[0,1,2],xmm3[1]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm8[0],xmm0[0],xmm8[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],xmm2[1],xmm0[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm13[0]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm8[0],xmm13[0],xmm8[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],xmm2[1],xmm1[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm3 = xmm1[0,1,2],xmm3[1]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm2 = xmm9[0,1],xmm2[3],xmm9[3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1,2],xmm12[0]
; CHECK-NEXT:    vaddps %xmm3, %xmm2, %xmm2
; CHECK-NEXT:    vmovaps %xmm15, %xmm1
; CHECK-NEXT:    vmovaps %xmm15, {{[0-9]+}}(%rsp) # 16-byte Spill
; CHECK-NEXT:    vaddps %xmm0, %xmm15, %xmm9
; CHECK-NEXT:    vaddps %xmm14, %xmm10, %xmm0
; CHECK-NEXT:    vaddps %xmm15, %xmm15, %xmm8
; CHECK-NEXT:    vaddps %xmm11, %xmm3, %xmm3
; CHECK-NEXT:    vaddps %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    vaddps %xmm0, %xmm15, %xmm0
; CHECK-NEXT:    vmovaps %xmm8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    vmovaps %xmm9, (%rsp)
; CHECK-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm3 # 16-byte Reload
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm1 # 16-byte Reload
; CHECK-NEXT:    vaddps {{[0-9]+}}(%rsp), %xmm1, %xmm1 # 16-byte Folded Reload
; CHECK-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    addq $88, %rsp
; CHECK-NEXT:    retq
  %a1 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>

  %a2 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 21, i32 1, i32 17>
  %a5 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 27>
  %a6 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 3, i32 20, i32 1, i32 17>
  %a7 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 21, i32 1, i32 17>
  %a8 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 5, i32 20, i32 1, i32 19>
  %a9 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>
  %a10 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>
  %ax2 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 19>
  %ax5 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>
  %ax6 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 22, i32 1, i32 18>
  %ax7 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 1, i32 20, i32 1, i32 17>
  %ax8 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 19>
  %ax9 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>
  %ax10 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>
  %ay2 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>
  %ay5 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 28, i32 1, i32 17>
  %ay6 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 5, i32 20, i32 1, i32 17>
  %ay7 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 30, i32 1, i32 22>
  %ay8 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 1, i32 17>
  %ay9 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 22, i32 1, i32 17>
  %ay10 = shufflevector <16 x float>%c1, <16 x float>%c2, <4 x i32> <i32 4, i32 20, i32 3, i32 18>

  %r1 = fadd <4 x float> %ay10, %ay9
  %r2 = fadd <4 x float> %ay8, %ay7
  %r3 = fadd <4 x float> %ay6, %ay5
  %r4 = fadd <4 x float> %ay2, %ax10
  %r5 = fadd <4 x float> %ay9, %ax8
  %r6 = fadd <4 x float> %r5, %r3
  %r7 = fadd <4 x float> %a9, %r6
  %a11 = call <4 x float> @foo(<4 x float> %r7, <4 x float> %a10, <4 x float> %r1, <4 x float> %a4, <4 x float> %a5, <4 x float> %a6, <4 x float> %a7, <4 x float> %a8, <4 x float> %r2, <4 x float> %r4)
  %a12 = fadd <4 x float> %a2, %a1
  %a13 = fadd <4 x float> %a12, %a11

  ret <4 x float> %a13
}
