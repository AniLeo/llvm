; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown -mattr=+sse2,+sse4.1 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2,+sse4.1 | FileCheck %s --check-prefix=X64

define <4 x float> @test(float %a, float %b, float %c) nounwind {
; X86-LABEL: test:
; X86:       # %bb.0:
; X86-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,0],xmm1[0,1]
; X86-NEXT:    retl
;
; X64-LABEL: test:
; X64:       # %bb.0:
; X64-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0],xmm2[0],zero,zero
; X64-NEXT:    xorps %xmm2, %xmm2
; X64-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; X64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,0],xmm1[0,1]
; X64-NEXT:    retq
  %tmp = insertelement <4 x float> zeroinitializer, float %a, i32 1
  %tmp8 = insertelement <4 x float> %tmp, float %b, i32 2
  %tmp10 = insertelement <4 x float> %tmp8, float %c, i32 3
  ret <4 x float> %tmp10
}

