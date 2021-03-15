; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2            | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3           | FileCheck %s --check-prefix=SSSE3-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3,fast-hops | FileCheck %s --check-prefix=SSSE3-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx             | FileCheck %s --check-prefix=AVX1-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,fast-hops   | FileCheck %s --check-prefix=AVX1-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2            | FileCheck %s --check-prefix=AVX2

define float @pr26491(<4 x float> %a0) {
; SSE2-LABEL: pr26491:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[3,3]
; SSE2-NEXT:    addps %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE2-NEXT:    addss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: pr26491:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-SLOW-NEXT:    addps %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    movaps %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSSE3-SLOW-NEXT:    addss %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: pr26491:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSSE3-FAST-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-FAST-NEXT:    addss %xmm1, %xmm0
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: pr26491:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-SLOW-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX1-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX1-SLOW-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: pr26491:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-FAST-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: pr26491:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX2-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX2-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    retq
  %1 = shufflevector <4 x float> %a0, <4 x float> undef, <4 x i32> <i32 1, i32 1, i32 3, i32 3>
  %2 = fadd <4 x float> %1, %a0
  %3 = extractelement <4 x float> %2, i32 2
  %4 = extractelement <4 x float> %2, i32 0
  %5 = fadd float %3, %4
  ret float %5
}

; When simplifying away a splat (broadcast), the hop type must match the shuffle type.

define <4 x double> @PR41414(i64 %x, <4 x double> %y) {
; SSE2-LABEL: PR41414:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movq %rdi, %xmm2
; SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[1],mem[1]
; SSE2-NEXT:    subpd {{.*}}(%rip), %xmm2
; SSE2-NEXT:    movapd %xmm2, %xmm3
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1],xmm2[1]
; SSE2-NEXT:    addpd %xmm2, %xmm3
; SSE2-NEXT:    unpcklpd {{.*#+}} xmm3 = xmm3[0,0]
; SSE2-NEXT:    divpd %xmm3, %xmm1
; SSE2-NEXT:    divpd %xmm3, %xmm0
; SSE2-NEXT:    xorpd %xmm2, %xmm2
; SSE2-NEXT:    addpd %xmm2, %xmm0
; SSE2-NEXT:    addpd %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR41414:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    movq %rdi, %xmm2
; SSSE3-SLOW-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[1],mem[1]
; SSSE3-SLOW-NEXT:    subpd {{.*}}(%rip), %xmm2
; SSSE3-SLOW-NEXT:    movapd %xmm2, %xmm3
; SSSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1],xmm2[1]
; SSSE3-SLOW-NEXT:    addpd %xmm2, %xmm3
; SSSE3-SLOW-NEXT:    movddup {{.*#+}} xmm2 = xmm3[0,0]
; SSSE3-SLOW-NEXT:    divpd %xmm2, %xmm1
; SSSE3-SLOW-NEXT:    divpd %xmm2, %xmm0
; SSSE3-SLOW-NEXT:    xorpd %xmm2, %xmm2
; SSSE3-SLOW-NEXT:    addpd %xmm2, %xmm0
; SSSE3-SLOW-NEXT:    addpd %xmm2, %xmm1
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR41414:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    movq %rdi, %xmm2
; SSSE3-FAST-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[1],mem[1]
; SSSE3-FAST-NEXT:    subpd {{.*}}(%rip), %xmm2
; SSSE3-FAST-NEXT:    haddpd %xmm2, %xmm2
; SSSE3-FAST-NEXT:    divpd %xmm2, %xmm1
; SSSE3-FAST-NEXT:    divpd %xmm2, %xmm0
; SSSE3-FAST-NEXT:    xorpd %xmm2, %xmm2
; SSSE3-FAST-NEXT:    addpd %xmm2, %xmm0
; SSSE3-FAST-NEXT:    addpd %xmm2, %xmm1
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR41414:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vmovq %rdi, %xmm1
; AVX1-SLOW-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
; AVX1-SLOW-NEXT:    vsubpd {{.*}}(%rip), %xmm1, %xmm1
; AVX1-SLOW-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm1[1,0]
; AVX1-SLOW-NEXT:    vaddpd %xmm1, %xmm2, %xmm1
; AVX1-SLOW-NEXT:    vmovddup {{.*#+}} xmm1 = xmm1[0,0]
; AVX1-SLOW-NEXT:    vinsertf128 $1, %xmm1, %ymm1, %ymm1
; AVX1-SLOW-NEXT:    vdivpd %ymm1, %ymm0, %ymm0
; AVX1-SLOW-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX1-SLOW-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR41414:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vmovq %rdi, %xmm1
; AVX1-FAST-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
; AVX1-FAST-NEXT:    vsubpd {{.*}}(%rip), %xmm1, %xmm1
; AVX1-FAST-NEXT:    vhaddpd %xmm1, %xmm1, %xmm1
; AVX1-FAST-NEXT:    vinsertf128 $1, %xmm1, %ymm1, %ymm1
; AVX1-FAST-NEXT:    vdivpd %ymm1, %ymm0, %ymm0
; AVX1-FAST-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX1-FAST-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR41414:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm1
; AVX2-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
; AVX2-NEXT:    vsubpd {{.*}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm1[1,0]
; AVX2-NEXT:    vaddsd %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vbroadcastsd %xmm1, %ymm1
; AVX2-NEXT:    vdivpd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %conv = uitofp i64 %x to double
  %t0 = insertelement <4 x double> undef, double %conv, i32 0
  %t1 = shufflevector <4 x double> %t0, <4 x double> undef, <4 x i32> zeroinitializer
  %t2 = fdiv <4 x double> %y, %t1
  %t3 = fadd <4 x double> zeroinitializer, %t2
  ret <4 x double> %t3
}

define <4 x float> @PR48823(<4 x float> %0, <4 x float> %1) {
; SSE2-LABEL: PR48823:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1],xmm0[1,1]
; SSE2-NEXT:    subps %xmm2, %xmm0
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[2,2],xmm1[2,2]
; SSE2-NEXT:    subps %xmm1, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR48823:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    movshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSSE3-SLOW-NEXT:    subps %xmm2, %xmm0
; SSSE3-SLOW-NEXT:    movsldup {{.*#+}} xmm2 = xmm1[0,0,2,2]
; SSSE3-SLOW-NEXT:    subps %xmm1, %xmm2
; SSSE3-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR48823:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    hsubps %xmm1, %xmm0
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR48823:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; AVX1-SLOW-NEXT:    vsubps %xmm2, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovsldup {{.*#+}} xmm2 = xmm1[0,0,2,2]
; AVX1-SLOW-NEXT:    vsubps %xmm1, %xmm2, %xmm1
; AVX1-SLOW-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR48823:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vhsubps %xmm1, %xmm0, %xmm0
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR48823:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; AVX2-NEXT:    vsubps %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vmovsldup {{.*#+}} xmm2 = xmm1[0,0,2,2]
; AVX2-NEXT:    vsubps %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX2-NEXT:    retq
  %3 = shufflevector <4 x float> %0, <4 x float> poison, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %4 = fsub <4 x float> %0, %3
  %5 = shufflevector <4 x float> %1, <4 x float> poison, <4 x i32> <i32 undef, i32 undef, i32 undef, i32 2>
  %6 = fsub <4 x float> %5, %1
  %7 = shufflevector <4 x float> %4, <4 x float> %6, <4 x i32> <i32 0, i32 undef, i32 undef, i32 7>
  ret <4 x float> %7
}
