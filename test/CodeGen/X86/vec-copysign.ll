; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX

; FIXME: These don't have to be scalarized.

define <4 x float> @v4f32(<4 x float> %a, <4 x float> %b) nounwind {
; SSE2-LABEL: v4f32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[3,1,2,3]
; SSE2-NEXT:    movaps {{.*#+}} xmm3 = [-0.000000e+00,-0.000000e+00,-0.000000e+00,-0.000000e+00]
; SSE2-NEXT:    andps %xmm3, %xmm2
; SSE2-NEXT:    movaps %xmm0, %xmm4
; SSE2-NEXT:    shufps {{.*#+}} xmm4 = xmm4[3,1,2,3]
; SSE2-NEXT:    movaps {{.*#+}} xmm5 
; SSE2-NEXT:    andps %xmm5, %xmm4
; SSE2-NEXT:    orps %xmm2, %xmm4
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1,2,3]
; SSE2-NEXT:    andps %xmm3, %xmm2
; SSE2-NEXT:    movaps %xmm0, %xmm6
; SSE2-NEXT:    shufps {{.*#+}} xmm6 = xmm6[1,1,2,3]
; SSE2-NEXT:    andps %xmm5, %xmm6
; SSE2-NEXT:    orps %xmm2, %xmm6
; SSE2-NEXT:    unpcklps {{.*#+}} xmm6 = xmm6[0],xmm4[0],xmm6[1],xmm4[1]
; SSE2-NEXT:    movaps %xmm1, %xmm4
; SSE2-NEXT:    andps %xmm3, %xmm4
; SSE2-NEXT:    movaps %xmm0, %xmm2
; SSE2-NEXT:    andps %xmm5, %xmm2
; SSE2-NEXT:    orps %xmm4, %xmm2
; SSE2-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; SSE2-NEXT:    andps %xmm3, %xmm1
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    andps %xmm5, %xmm0
; SSE2-NEXT:    orps %xmm1, %xmm0
; SSE2-NEXT:    unpcklps {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; SSE2-NEXT:    unpcklps {{.*#+}} xmm2 = xmm2[0],xmm6[0],xmm2[1],xmm6[1]
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; AVX-LABEL: v4f32:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm2 = [-0.000000e+00,-0.000000e+00,-0.000000e+00,-0.000000e+00]
; AVX-NEXT:    vandps %xmm2, %xmm1, %xmm3
; AVX-NEXT:    vmovaps {{.*#+}} xmm4
; AVX-NEXT:    vandps %xmm4, %xmm0, %xmm5
; AVX-NEXT:    vorps %xmm3, %xmm5, %xmm3
; AVX-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm1[1,1,3,3]
; AVX-NEXT:    vandps %xmm2, %xmm5, %xmm5
; AVX-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm0[1,1,3,3]
; AVX-NEXT:    vandps %xmm4, %xmm6, %xmm6
; AVX-NEXT:    vorps %xmm5, %xmm6, %xmm5
; AVX-NEXT:    vinsertps {{.*#+}} xmm3 = xmm3[0],xmm5[0],xmm3[2,3]
; AVX-NEXT:    vpermilpd {{.*#+}} xmm5 = xmm1[1,0]
; AVX-NEXT:    vandpd %xmm2, %xmm5, %xmm5
; AVX-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm0[1,0]
; AVX-NEXT:    vandpd %xmm4, %xmm6, %xmm6
; AVX-NEXT:    vorpd %xmm5, %xmm6, %xmm5
; AVX-NEXT:    vinsertps {{.*#+}} xmm3 = xmm3[0,1],xmm5[0],xmm3[3]
; AVX-NEXT:    vpermilps {{.*#+}} xmm1 = xmm1[3,1,2,3]
; AVX-NEXT:    vandps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; AVX-NEXT:    vandps %xmm4, %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm3[0,1,2],xmm0[0]
; AVX-NEXT:    retq
;
  %tmp = tail call <4 x float> @llvm.copysign.v4f32( <4 x float> %a, <4 x float> %b )
  ret <4 x float> %tmp
}

define <8 x float> @v8f32(<8 x float> %a, <8 x float> %b) nounwind {
; SSE2-LABEL: v8f32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movaps %xmm0, %xmm5
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-NEXT:    movaps {{.*#+}} xmm8 = [-0.000000e+00,-0.000000e+00,-0.000000e+00,-0.000000e+00]
; SSE2-NEXT:    andps %xmm8, %xmm0
; SSE2-NEXT:    movaps %xmm5, %xmm7
; SSE2-NEXT:    shufps {{.*#+}} xmm7 = xmm7[3,1,2,3]
; SSE2-NEXT:    movaps {{.*#+}} xmm6
; SSE2-NEXT:    andps %xmm6, %xmm7
; SSE2-NEXT:    orps %xmm0, %xmm7
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE2-NEXT:    andps %xmm8, %xmm0
; SSE2-NEXT:    movaps %xmm5, %xmm4
; SSE2-NEXT:    shufps {{.*#+}} xmm4 = xmm4[1,1,2,3]
; SSE2-NEXT:    andps %xmm6, %xmm4
; SSE2-NEXT:    orps %xmm0, %xmm4
; SSE2-NEXT:    unpcklps {{.*#+}} xmm4 = xmm4[0],xmm7[0],xmm4[1],xmm7[1]
; SSE2-NEXT:    movaps %xmm2, %xmm7
; SSE2-NEXT:    andps %xmm8, %xmm7
; SSE2-NEXT:    movaps %xmm5, %xmm0
; SSE2-NEXT:    andps %xmm6, %xmm0
; SSE2-NEXT:    orps %xmm7, %xmm0
; SSE2-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; SSE2-NEXT:    andps %xmm8, %xmm2
; SSE2-NEXT:    movhlps {{.*#+}} xmm5 = xmm5[1,1]
; SSE2-NEXT:    andps %xmm6, %xmm5
; SSE2-NEXT:    orps %xmm2, %xmm5
; SSE2-NEXT:    unpcklps {{.*#+}} xmm0 = xmm0[0],xmm5[0],xmm0[1],xmm5[1]
; SSE2-NEXT:    unpcklps {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1]
; SSE2-NEXT:    movaps %xmm3, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[3,1,2,3]
; SSE2-NEXT:    andps %xmm8, %xmm2
; SSE2-NEXT:    movaps %xmm1, %xmm4
; SSE2-NEXT:    shufps {{.*#+}} xmm4 = xmm4[3,1,2,3]
; SSE2-NEXT:    andps %xmm6, %xmm4
; SSE2-NEXT:    orps %xmm2, %xmm4
; SSE2-NEXT:    movaps %xmm3, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1,2,3]
; SSE2-NEXT:    andps %xmm8, %xmm2
; SSE2-NEXT:    movaps %xmm1, %xmm5
; SSE2-NEXT:    shufps {{.*#+}} xmm5 = xmm5[1,1,2,3]
; SSE2-NEXT:    andps %xmm6, %xmm5
; SSE2-NEXT:    orps %xmm2, %xmm5
; SSE2-NEXT:    unpcklps {{.*#+}} xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
; SSE2-NEXT:    movaps %xmm3, %xmm4
; SSE2-NEXT:    andps %xmm8, %xmm4
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    andps %xmm6, %xmm2
; SSE2-NEXT:    orps %xmm4, %xmm2
; SSE2-NEXT:    movhlps {{.*#+}} xmm3 = xmm3[1,1]
; SSE2-NEXT:    andps %xmm8, %xmm3
; SSE2-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; SSE2-NEXT:    andps %xmm6, %xmm1
; SSE2-NEXT:    orps %xmm3, %xmm1
; SSE2-NEXT:    unpcklps {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE2-NEXT:    unpcklps {{.*#+}} xmm2 = xmm2[0],xmm5[0],xmm2[1],xmm5[1]
; SSE2-NEXT:    movaps %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; AVX-LABEL: v8f32:
; AVX:       # BB#0:
; AVX-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX-NEXT:    vmovaps {{.*#+}} xmm2 = [-0.000000e+00,-0.000000e+00,-0.000000e+00,-0.000000e+00]
; AVX-NEXT:    vandps %xmm2, %xmm4, %xmm5
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm6
; AVX-NEXT:    vmovaps {{.*#+}} xmm3
; AVX-NEXT:    vandps %xmm3, %xmm6, %xmm7
; AVX-NEXT:    vorps %xmm5, %xmm7, %xmm8
; AVX-NEXT:    vmovshdup {{.*#+}} xmm7 = xmm4[1,1,3,3]
; AVX-NEXT:    vandps %xmm2, %xmm7, %xmm7
; AVX-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm6[1,1,3,3]
; AVX-NEXT:    vandps %xmm3, %xmm5, %xmm5
; AVX-NEXT:    vorps %xmm7, %xmm5, %xmm5
; AVX-NEXT:    vinsertps {{.*#+}} xmm8 = xmm8[0],xmm5[0],xmm8[2,3]
; AVX-NEXT:    vpermilpd {{.*#+}} xmm7 = xmm4[1,0]
; AVX-NEXT:    vandpd %xmm2, %xmm7, %xmm7
; AVX-NEXT:    vpermilpd {{.*#+}} xmm5 = xmm6[1,0]
; AVX-NEXT:    vandpd %xmm3, %xmm5, %xmm5
; AVX-NEXT:    vorpd %xmm7, %xmm5, %xmm5
; AVX-NEXT:    vinsertps {{.*#+}} xmm5 = xmm8[0,1],xmm5[0],xmm8[3]
; AVX-NEXT:    vpermilps {{.*#+}} xmm4 = xmm4[3,1,2,3]
; AVX-NEXT:    vandps %xmm2, %xmm4, %xmm4
; AVX-NEXT:    vpermilps {{.*#+}} xmm6 = xmm6[3,1,2,3]
; AVX-NEXT:    vandps %xmm3, %xmm6, %xmm6
; AVX-NEXT:    vorps %xmm4, %xmm6, %xmm4
; AVX-NEXT:    vinsertps {{.*#+}} xmm4 = xmm5[0,1,2],xmm4[0]
; AVX-NEXT:    vandps %xmm2, %xmm1, %xmm5
; AVX-NEXT:    vandps %xmm3, %xmm0, %xmm6
; AVX-NEXT:    vorps %xmm5, %xmm6, %xmm5
; AVX-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm1[1,1,3,3]
; AVX-NEXT:    vandps %xmm2, %xmm6, %xmm6
; AVX-NEXT:    vmovshdup {{.*#+}} xmm7 = xmm0[1,1,3,3]
; AVX-NEXT:    vandps %xmm3, %xmm7, %xmm7
; AVX-NEXT:    vorps %xmm6, %xmm7, %xmm6
; AVX-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0],xmm6[0],xmm5[2,3]
; AVX-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm1[1,0]
; AVX-NEXT:    vandpd %xmm2, %xmm6, %xmm6
; AVX-NEXT:    vpermilpd {{.*#+}} xmm7 = xmm0[1,0]
; AVX-NEXT:    vandpd %xmm3, %xmm7, %xmm7
; AVX-NEXT:    vorpd %xmm6, %xmm7, %xmm6
; AVX-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0,1],xmm6[0],xmm5[3]
; AVX-NEXT:    vpermilps {{.*#+}} xmm1 = xmm1[3,1,2,3]
; AVX-NEXT:    vandps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; AVX-NEXT:    vandps %xmm3, %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm5[0,1,2],xmm0[0]
; AVX-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX-NEXT:    retq
;
  %tmp = tail call <8 x float> @llvm.copysign.v8f32( <8 x float> %a, <8 x float> %b )
  ret <8 x float> %tmp
}

define <2 x double> @v2f64(<2 x double> %a, <2 x double> %b) nounwind {
; SSE2-LABEL: v2f64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movaps {{.*#+}} xmm3 = [-0.000000e+00,-0.000000e+00]
; SSE2-NEXT:    movaps %xmm1, %xmm4
; SSE2-NEXT:    andps %xmm3, %xmm4
; SSE2-NEXT:    movaps {{.*#+}} xmm5
; SSE2-NEXT:    movaps %xmm0, %xmm2
; SSE2-NEXT:    andps %xmm5, %xmm2
; SSE2-NEXT:    orps %xmm4, %xmm2
; SSE2-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; SSE2-NEXT:    andps %xmm3, %xmm1
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    andps %xmm5, %xmm0
; SSE2-NEXT:    orps %xmm1, %xmm0
; SSE2-NEXT:    unpcklpd {{.*#+}} xmm2 = xmm2[0],xmm0[0]
; SSE2-NEXT:    movapd %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; AVX-LABEL: v2f64:
; AVX:       # BB#0:
; AVX-NEXT:    vmovapd {{.*#+}} xmm2 = [-0.000000e+00,-0.000000e+00]
; AVX-NEXT:    vandpd %xmm2, %xmm1, %xmm3
; AVX-NEXT:    vmovapd {{.*#+}} xmm4
; AVX-NEXT:    vandpd %xmm4, %xmm0, %xmm5
; AVX-NEXT:    vorpd %xmm3, %xmm5, %xmm3
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm1[1,0]
; AVX-NEXT:    vandpd %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX-NEXT:    vandpd %xmm4, %xmm0, %xmm0
; AVX-NEXT:    vorpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm3[0],xmm0[0]
; AVX-NEXT:    retq
;
  %tmp = tail call <2 x double> @llvm.copysign.v2f64( <2 x double> %a, <2 x double> %b )
  ret <2 x double> %tmp
}

define <4 x double> @v4f64(<4 x double> %a, <4 x double> %b) nounwind {
; SSE2-LABEL: v4f64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movaps %xmm0, %xmm4
; SSE2-NEXT:    movaps {{.*#+}} xmm5 = [-0.000000e+00,-0.000000e+00]
; SSE2-NEXT:    movaps %xmm2, %xmm6
; SSE2-NEXT:    andps %xmm5, %xmm6
; SSE2-NEXT:    movaps {{.*#+}} xmm7
; SSE2-NEXT:    andps %xmm7, %xmm0
; SSE2-NEXT:    orps %xmm6, %xmm0
; SSE2-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; SSE2-NEXT:    andps %xmm5, %xmm2
; SSE2-NEXT:    movhlps {{.*#+}} xmm4 = xmm4[1,1]
; SSE2-NEXT:    andps %xmm7, %xmm4
; SSE2-NEXT:    orps %xmm2, %xmm4
; SSE2-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm4[0]
; SSE2-NEXT:    movaps %xmm3, %xmm4
; SSE2-NEXT:    andps %xmm5, %xmm4
; SSE2-NEXT:    movaps %xmm1, %xmm2
; SSE2-NEXT:    andps %xmm7, %xmm2
; SSE2-NEXT:    orps %xmm4, %xmm2
; SSE2-NEXT:    movhlps {{.*#+}} xmm3 = xmm3[1,1]
; SSE2-NEXT:    andps %xmm5, %xmm3
; SSE2-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; SSE2-NEXT:    andps %xmm7, %xmm1
; SSE2-NEXT:    orps %xmm3, %xmm1
; SSE2-NEXT:    unpcklpd {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; SSE2-NEXT:    movapd %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; AVX-LABEL: v4f64:
; AVX:       # BB#0:
; AVX-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX-NEXT:    vmovapd {{.*#+}} xmm3 = [-0.000000e+00,-0.000000e+00]
; AVX-NEXT:    vandpd %xmm3, %xmm2, %xmm4
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX-NEXT:    vmovapd {{.*#+}} xmm6
; AVX-NEXT:    vandpd %xmm6, %xmm5, %xmm7
; AVX-NEXT:    vorpd %xmm4, %xmm7, %xmm4
; AVX-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm2[1,0]
; AVX-NEXT:    vandpd %xmm3, %xmm2, %xmm2
; AVX-NEXT:    vpermilpd {{.*#+}} xmm5 = xmm5[1,0]
; AVX-NEXT:    vandpd %xmm6, %xmm5, %xmm5
; AVX-NEXT:    vorpd %xmm2, %xmm5, %xmm2
; AVX-NEXT:    vunpcklpd {{.*#+}} xmm2 = xmm4[0],xmm2[0]
; AVX-NEXT:    vandpd %xmm3, %xmm1, %xmm4
; AVX-NEXT:    vandpd %xmm6, %xmm0, %xmm5
; AVX-NEXT:    vorpd %xmm4, %xmm5, %xmm4
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm1[1,0]
; AVX-NEXT:    vandpd %xmm3, %xmm1, %xmm1
; AVX-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX-NEXT:    vandpd %xmm6, %xmm0, %xmm0
; AVX-NEXT:    vorpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm4[0],xmm0[0]
; AVX-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX-NEXT:    retq
;
  %tmp = tail call <4 x double> @llvm.copysign.v4f64( <4 x double> %a, <4 x double> %b )
  ret <4 x double> %tmp
}

declare <4 x float>     @llvm.copysign.v4f32(<4 x float>  %Mag, <4 x float>  %Sgn)
declare <8 x float>     @llvm.copysign.v8f32(<8 x float>  %Mag, <8 x float>  %Sgn)
declare <2 x double>    @llvm.copysign.v2f64(<2 x double> %Mag, <2 x double> %Sgn)
declare <4 x double>    @llvm.copysign.v4f64(<4 x double> %Mag, <4 x double> %Sgn)

