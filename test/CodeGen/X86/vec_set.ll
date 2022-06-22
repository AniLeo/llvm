; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown -mattr=+sse2,-sse4.1 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2,-sse4.1 | FileCheck %s --check-prefix=X64

define void @test(ptr %b, i16 %a0, i16 %a1, i16 %a2, i16 %a3, i16 %a4, i16 %a5, i16 %a6, i16 %a7) nounwind {
; X86-LABEL: test:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X86-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X86-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X86-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3]
; X86-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; X86-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X86-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X86-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    movd {{.*#+}} xmm3 = mem[0],zero,zero,zero
; X86-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1],xmm3[2],xmm0[2],xmm3[3],xmm0[3]
; X86-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1]
; X86-NEXT:    punpcklqdq {{.*#+}} xmm3 = xmm3[0],xmm2[0]
; X86-NEXT:    movdqa %xmm3, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test:
; X64:       # %bb.0:
; X64-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X64-NEXT:    movd %r9d, %xmm0
; X64-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X64-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; X64-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X64-NEXT:    movd %r8d, %xmm1
; X64-NEXT:    movd %ecx, %xmm2
; X64-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; X64-NEXT:    movd %edx, %xmm1
; X64-NEXT:    movd %esi, %xmm3
; X64-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3]
; X64-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X64-NEXT:    punpcklqdq {{.*#+}} xmm3 = xmm3[0],xmm0[0]
; X64-NEXT:    movdqa %xmm3, (%rdi)
; X64-NEXT:    retq
  %tmp = insertelement <8 x i16> zeroinitializer, i16 %a0, i32 0
  %tmp2 = insertelement <8 x i16> %tmp, i16 %a1, i32 1
  %tmp4 = insertelement <8 x i16> %tmp2, i16 %a2, i32 2
  %tmp6 = insertelement <8 x i16> %tmp4, i16 %a3, i32 3
  %tmp8 = insertelement <8 x i16> %tmp6, i16 %a4, i32 4
  %tmp10 = insertelement <8 x i16> %tmp8, i16 %a5, i32 5
  %tmp12 = insertelement <8 x i16> %tmp10, i16 %a6, i32 6
  %tmp14 = insertelement <8 x i16> %tmp12, i16 %a7, i32 7
  store <8 x i16> %tmp14, ptr %b
  ret void
}

