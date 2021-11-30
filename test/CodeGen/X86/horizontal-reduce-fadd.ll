; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2            | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3           | FileCheck %s --check-prefix=SSSE3-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3,fast-hops | FileCheck %s --check-prefix=SSSE3-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx             | FileCheck %s --check-prefix=AVX1-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,fast-hops   | FileCheck %s --check-prefix=AVX1-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2            | FileCheck %s --check-prefix=AVX2

; PR37890 - subvector reduction followed by shuffle reduction

define float @PR37890_v4f32(<4 x float> %a)  {
; SSE2-LABEL: PR37890_v4f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; SSE2-NEXT:    addss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v4f32:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-SLOW-NEXT:    addss %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v4f32:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v4f32:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX1-SLOW-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-SLOW-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v4f32:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v4f32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX2-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %hi0 = shufflevector <4 x float> %a, <4 x float> undef, <2 x i32> <i32 2, i32 3>
  %lo0 = shufflevector <4 x float> %a, <4 x float> undef, <2 x i32> <i32 0, i32 1>
  %sum0 = fadd fast <2 x float> %lo0, %hi0
  %hi1 = shufflevector <2 x float> %sum0, <2 x float> undef, <2 x i32> <i32 1, i32 undef>
  %sum1 = fadd fast <2 x float> %sum0, %hi1
  %e = extractelement <2 x float> %sum1, i32 0
  ret float %e
}

define double @PR37890_v4f64(<4 x double> %a)  {
; SSE2-LABEL: PR37890_v4f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addsd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v4f64:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    addpd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movapd %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-SLOW-NEXT:    addsd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v4f64:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    addpd %xmm1, %xmm0
; SSSE3-FAST-NEXT:    haddpd %xmm0, %xmm0
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v4f64:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-SLOW-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX1-SLOW-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v4f64:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-FAST-NEXT:    vhaddpd %xmm0, %xmm1, %xmm0
; AVX1-FAST-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v4f64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX2-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %hi0 = shufflevector <4 x double> %a, <4 x double> undef, <2 x i32> <i32 2, i32 3>
  %lo0 = shufflevector <4 x double> %a, <4 x double> undef, <2 x i32> <i32 0, i32 1>
  %sum0 = fadd fast <2 x double> %lo0, %hi0
  %hi1 = shufflevector <2 x double> %sum0, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %sum1 = fadd fast <2 x double> %sum0, %hi1
  %e = extractelement <2 x double> %sum1, i32 0
  ret double %e
}

define float @PR37890_v8f32(<8 x float> %a)  {
; SSE2-LABEL: PR37890_v8f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; SSE2-NEXT:    addss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v8f32:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-SLOW-NEXT:    addss %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v8f32:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    addps %xmm1, %xmm0
; SSSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v8f32:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-SLOW-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX1-SLOW-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-SLOW-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v8f32:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm1, %xmm0
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v8f32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX2-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %hi0 = shufflevector <8 x float> %a, <8 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %lo0 = shufflevector <8 x float> %a, <8 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %sum0 = fadd fast <4 x float> %lo0, %hi0
  %hi1 = shufflevector <4 x float> %sum0, <4 x float> undef, <2 x i32> <i32 2, i32 3>
  %lo1 = shufflevector <4 x float> %sum0, <4 x float> undef, <2 x i32> <i32 0, i32 1>
  %sum1 = fadd fast <2 x float> %lo1, %hi1
  %hi2 = shufflevector <2 x float> %sum1, <2 x float> undef, <2 x i32> <i32 1, i32 undef>
  %sum2 = fadd fast <2 x float> %sum1, %hi2
  %e = extractelement <2 x float> %sum2, i32 0
  ret float %e
}

define double @PR37890_v8f64(<8 x double> %a)  {
; SSE2-LABEL: PR37890_v8f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addpd %xmm3, %xmm1
; SSE2-NEXT:    addpd %xmm2, %xmm1
; SSE2-NEXT:    addpd %xmm1, %xmm0
; SSE2-NEXT:    movapd %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addsd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v8f64:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    addpd %xmm3, %xmm1
; SSSE3-SLOW-NEXT:    addpd %xmm2, %xmm1
; SSSE3-SLOW-NEXT:    addpd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movapd %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-SLOW-NEXT:    addsd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v8f64:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    addpd %xmm3, %xmm1
; SSSE3-FAST-NEXT:    addpd %xmm2, %xmm1
; SSSE3-FAST-NEXT:    addpd %xmm1, %xmm0
; SSSE3-FAST-NEXT:    haddpd %xmm0, %xmm0
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v8f64:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-SLOW-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX1-SLOW-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v8f64:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-FAST-NEXT:    vhaddpd %xmm0, %xmm1, %xmm0
; AVX1-FAST-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v8f64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX2-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %hi0 = shufflevector <8 x double> %a, <8 x double> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %lo0 = shufflevector <8 x double> %a, <8 x double> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %sum0 = fadd fast <4 x double> %lo0, %hi0
  %hi1 = shufflevector <4 x double> %sum0, <4 x double> undef, <2 x i32> <i32 2, i32 3>
  %lo1 = shufflevector <4 x double> %sum0, <4 x double> undef, <2 x i32> <i32 0, i32 1>
  %sum1 = fadd fast <2 x double> %lo1, %hi1
  %hi2 = shufflevector <2 x double> %sum1, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %sum2 = fadd fast <2 x double> %sum1, %hi2
  %e = extractelement <2 x double> %sum2, i32 0
  ret double %e
}

define float @PR37890_v16f32(<16 x float> %a)  {
; SSE2-LABEL: PR37890_v16f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    addps %xmm3, %xmm1
; SSE2-NEXT:    addps %xmm2, %xmm1
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    addps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; SSE2-NEXT:    addss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v16f32:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    addps %xmm3, %xmm1
; SSSE3-SLOW-NEXT:    addps %xmm2, %xmm1
; SSSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-SLOW-NEXT:    addss %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v16f32:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    addps %xmm3, %xmm1
; SSSE3-FAST-NEXT:    addps %xmm2, %xmm1
; SSSE3-FAST-NEXT:    addps %xmm1, %xmm0
; SSSE3-FAST-NEXT:    movaps %xmm0, %xmm1
; SSSE3-FAST-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-FAST-NEXT:    addps %xmm1, %xmm0
; SSSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v16f32:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-SLOW-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX1-SLOW-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-SLOW-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v16f32:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm1, %xmm0
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v16f32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX2-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %hi0 = shufflevector <16 x float> %a, <16 x float> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %lo0 = shufflevector <16 x float> %a, <16 x float> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %sum0 = fadd fast <8 x float> %lo0, %hi0
  %hi1 = shufflevector <8 x float> %sum0, <8 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %lo1 = shufflevector <8 x float> %sum0, <8 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %sum1 = fadd fast <4 x float> %lo1, %hi1
  %hi2 = shufflevector <4 x float> %sum1, <4 x float> undef, <2 x i32> <i32 2, i32 3>
  %lo2 = shufflevector <4 x float> %sum1, <4 x float> undef, <2 x i32> <i32 0, i32 1>
  %sum2 = fadd fast <2 x float> %lo2, %hi2
  %hi3 = shufflevector <2 x float> %sum2, <2 x float> undef, <2 x i32> <i32 1, i32 undef>
  %sum3 = fadd fast <2 x float> %sum2, %hi3
  %e = extractelement <2 x float> %sum3, i32 0
  ret float %e
}
