; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 | FileCheck %s

declare <8 x double> @llvm.experimental.constrained.fadd.v8f64(<8 x double>, <8 x double>, metadata, metadata)
declare <16 x float> @llvm.experimental.constrained.fadd.v16f32(<16 x float>, <16 x float>, metadata, metadata)
declare <8 x double> @llvm.experimental.constrained.fsub.v8f64(<8 x double>, <8 x double>, metadata, metadata)
declare <16 x float> @llvm.experimental.constrained.fsub.v16f32(<16 x float>, <16 x float>, metadata, metadata)
declare <8 x double> @llvm.experimental.constrained.fmul.v8f64(<8 x double>, <8 x double>, metadata, metadata)
declare <16 x float> @llvm.experimental.constrained.fmul.v16f32(<16 x float>, <16 x float>, metadata, metadata)
declare <8 x double> @llvm.experimental.constrained.fdiv.v8f64(<8 x double>, <8 x double>, metadata, metadata)
declare <16 x float> @llvm.experimental.constrained.fdiv.v16f32(<16 x float>, <16 x float>, metadata, metadata)

define <8 x double> @f1(<8 x double> %a, <8 x double> %b) #0 {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractf32x4 $3, %zmm1, %xmm2
; CHECK-NEXT:    vextractf32x4 $3, %zmm0, %xmm3
; CHECK-NEXT:    vaddsd %xmm2, %xmm3, %xmm4
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm2[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm3[1,0]
; CHECK-NEXT:    vaddsd %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm2 = xmm4[0],xmm2[0]
; CHECK-NEXT:    vextractf32x4 $2, %zmm1, %xmm3
; CHECK-NEXT:    vextractf32x4 $2, %zmm0, %xmm4
; CHECK-NEXT:    vaddsd %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm4 = xmm4[1,0]
; CHECK-NEXT:    vaddsd %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm3 = xmm5[0],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm3
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm4
; CHECK-NEXT:    vaddsd %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm4 = xmm4[1,0]
; CHECK-NEXT:    vaddsd %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm3 = xmm5[0],xmm3[0]
; CHECK-NEXT:    vaddsd %xmm1, %xmm0, %xmm4
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm1[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; CHECK-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm4[0],xmm0[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; CHECK-NEXT:    vinsertf64x4 $1, %ymm2, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <8 x double> @llvm.experimental.constrained.fadd.v8f64(<8 x double> %a, <8 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <8 x double> %ret
}

define <16 x float> @f2(<16 x float> %a, <16 x float> %b) #0 {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractf32x4 $3, %zmm1, %xmm2
; CHECK-NEXT:    vextractf32x4 $3, %zmm0, %xmm3
; CHECK-NEXT:    vaddss %xmm2, %xmm3, %xmm4
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm2[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm3[1,1,3,3]
; CHECK-NEXT:    vaddss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm5 = xmm2[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm3[1,0]
; CHECK-NEXT:    vaddss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm5[0],xmm4[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm2 = xmm2[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm3 = xmm3[3,1,2,3]
; CHECK-NEXT:    vaddss %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vinsertps {{.*#+}} xmm2 = xmm4[0,1,2],xmm2[0]
; CHECK-NEXT:    vextractf32x4 $2, %zmm1, %xmm3
; CHECK-NEXT:    vextractf32x4 $2, %zmm0, %xmm4
; CHECK-NEXT:    vaddss %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm3[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm7 = xmm4[1,1,3,3]
; CHECK-NEXT:    vaddss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0],xmm6[0],xmm5[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm7 = xmm4[1,0]
; CHECK-NEXT:    vaddss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0,1],xmm6[0],xmm5[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm3 = xmm3[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm4 = xmm4[3,1,2,3]
; CHECK-NEXT:    vaddss %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vinsertps {{.*#+}} xmm3 = xmm5[0,1,2],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm3
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm4
; CHECK-NEXT:    vaddss %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm3[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm7 = xmm4[1,1,3,3]
; CHECK-NEXT:    vaddss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0],xmm6[0],xmm5[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm7 = xmm4[1,0]
; CHECK-NEXT:    vaddss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0,1],xmm6[0],xmm5[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm3 = xmm3[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm4 = xmm4[3,1,2,3]
; CHECK-NEXT:    vaddss %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vinsertps {{.*#+}} xmm3 = xmm5[0,1,2],xmm3[0]
; CHECK-NEXT:    vaddss %xmm1, %xmm0, %xmm4
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm1[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm0[1,1,3,3]
; CHECK-NEXT:    vaddss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm5 = xmm1[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm0[1,0]
; CHECK-NEXT:    vaddss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm5[0],xmm4[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm1 = xmm1[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; CHECK-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm4[0,1,2],xmm0[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; CHECK-NEXT:    vinsertf64x4 $1, %ymm2, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x float> @llvm.experimental.constrained.fadd.v16f32(<16 x float> %a, <16 x float> %b,
                                                                      metadata !"round.dynamic",
                                                                      metadata !"fpexcept.strict") #0
  ret <16 x float> %ret
}

define <8 x double> @f3(<8 x double> %a, <8 x double> %b) #0 {
; CHECK-LABEL: f3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractf32x4 $3, %zmm1, %xmm2
; CHECK-NEXT:    vextractf32x4 $3, %zmm0, %xmm3
; CHECK-NEXT:    vsubsd %xmm2, %xmm3, %xmm4
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm2[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm3[1,0]
; CHECK-NEXT:    vsubsd %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm2 = xmm4[0],xmm2[0]
; CHECK-NEXT:    vextractf32x4 $2, %zmm1, %xmm3
; CHECK-NEXT:    vextractf32x4 $2, %zmm0, %xmm4
; CHECK-NEXT:    vsubsd %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm4 = xmm4[1,0]
; CHECK-NEXT:    vsubsd %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm3 = xmm5[0],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm3
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm4
; CHECK-NEXT:    vsubsd %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm3 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm4 = xmm4[1,0]
; CHECK-NEXT:    vsubsd %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm3 = xmm5[0],xmm3[0]
; CHECK-NEXT:    vsubsd %xmm1, %xmm0, %xmm4
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm1[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; CHECK-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm4[0],xmm0[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; CHECK-NEXT:    vinsertf64x4 $1, %ymm2, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <8 x double> @llvm.experimental.constrained.fsub.v8f64(<8 x double> %a, <8 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <8 x double> %ret
}

define <16 x float> @f4(<16 x float> %a, <16 x float> %b) #0 {
; CHECK-LABEL: f4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractf32x4 $3, %zmm1, %xmm2
; CHECK-NEXT:    vextractf32x4 $3, %zmm0, %xmm3
; CHECK-NEXT:    vsubss %xmm2, %xmm3, %xmm4
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm2[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm3[1,1,3,3]
; CHECK-NEXT:    vsubss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm5 = xmm2[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm3[1,0]
; CHECK-NEXT:    vsubss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm5[0],xmm4[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm2 = xmm2[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm3 = xmm3[3,1,2,3]
; CHECK-NEXT:    vsubss %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vinsertps {{.*#+}} xmm2 = xmm4[0,1,2],xmm2[0]
; CHECK-NEXT:    vextractf32x4 $2, %zmm1, %xmm3
; CHECK-NEXT:    vextractf32x4 $2, %zmm0, %xmm4
; CHECK-NEXT:    vsubss %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm3[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm7 = xmm4[1,1,3,3]
; CHECK-NEXT:    vsubss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0],xmm6[0],xmm5[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm7 = xmm4[1,0]
; CHECK-NEXT:    vsubss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0,1],xmm6[0],xmm5[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm3 = xmm3[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm4 = xmm4[3,1,2,3]
; CHECK-NEXT:    vsubss %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vinsertps {{.*#+}} xmm3 = xmm5[0,1,2],xmm3[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm3
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm4
; CHECK-NEXT:    vsubss %xmm3, %xmm4, %xmm5
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm3[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm7 = xmm4[1,1,3,3]
; CHECK-NEXT:    vsubss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0],xmm6[0],xmm5[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm3[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm7 = xmm4[1,0]
; CHECK-NEXT:    vsubss %xmm6, %xmm7, %xmm6
; CHECK-NEXT:    vinsertps {{.*#+}} xmm5 = xmm5[0,1],xmm6[0],xmm5[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm3 = xmm3[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm4 = xmm4[3,1,2,3]
; CHECK-NEXT:    vsubss %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vinsertps {{.*#+}} xmm3 = xmm5[0,1,2],xmm3[0]
; CHECK-NEXT:    vsubss %xmm1, %xmm0, %xmm4
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm1[1,1,3,3]
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm6 = xmm0[1,1,3,3]
; CHECK-NEXT:    vsubss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[2,3]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm5 = xmm1[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm6 = xmm0[1,0]
; CHECK-NEXT:    vsubss %xmm5, %xmm6, %xmm5
; CHECK-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],xmm5[0],xmm4[3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm1 = xmm1[3,1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; CHECK-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm4[0,1,2],xmm0[0]
; CHECK-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; CHECK-NEXT:    vinsertf64x4 $1, %ymm2, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x float> @llvm.experimental.constrained.fsub.v16f32(<16 x float> %a, <16 x float> %b,
                                                                      metadata !"round.dynamic",
                                                                      metadata !"fpexcept.strict") #0
  ret <16 x float> %ret
}

define <8 x double> @f5(<8 x double> %a, <8 x double> %b) #0 {
; CHECK-LABEL: f5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulpd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <8 x double> @llvm.experimental.constrained.fmul.v8f64(<8 x double> %a, <8 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <8 x double> %ret
}

define <16 x float> @f6(<16 x float> %a, <16 x float> %b) #0 {
; CHECK-LABEL: f6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulps %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x float> @llvm.experimental.constrained.fmul.v16f32(<16 x float> %a, <16 x float> %b,
                                                                      metadata !"round.dynamic",
                                                                      metadata !"fpexcept.strict") #0
  ret <16 x float> %ret
}

define <8 x double> @f7(<8 x double> %a, <8 x double> %b) #0 {
; CHECK-LABEL: f7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vdivpd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <8 x double> @llvm.experimental.constrained.fdiv.v8f64(<8 x double> %a, <8 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <8 x double> %ret
}

define <16 x float> @f8(<16 x float> %a, <16 x float> %b) #0 {
; CHECK-LABEL: f8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vdivps %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x float> @llvm.experimental.constrained.fdiv.v16f32(<16 x float> %a, <16 x float> %b,
                                                                      metadata !"round.dynamic",
                                                                      metadata !"fpexcept.strict") #0
  ret <16 x float> %ret
}

attributes #0 = { strictfp }
