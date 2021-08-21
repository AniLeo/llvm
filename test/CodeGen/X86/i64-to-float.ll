; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86-SSE
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx | FileCheck %s --check-prefix=X86-AVX
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefix=X86-AVX512F
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefix=X86-AVX512DQ
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=X64-AVX
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefix=X64-AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefix=X64-AVX512DQ

;PR29078

define <2 x double> @mask_sitofp_2i64_2f64(<2 x i64> %a) nounwind {
; X86-SSE-LABEL: mask_sitofp_2i64_2f64:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-SSE-NEXT:    cvtdq2pd %xmm0, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: mask_sitofp_2i64_2f64:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X86-AVX-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X86-AVX-NEXT:    retl
;
; X86-AVX512F-LABEL: mask_sitofp_2i64_2f64:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X86-AVX512F-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X86-AVX512F-NEXT:    retl
;
; X86-AVX512DQ-LABEL: mask_sitofp_2i64_2f64:
; X86-AVX512DQ:       # %bb.0:
; X86-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512DQ-NEXT:    vcvtqq2pd %xmm0, %xmm0
; X86-AVX512DQ-NEXT:    retl
;
; X64-SSE-LABEL: mask_sitofp_2i64_2f64:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-SSE-NEXT:    cvtdq2pd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: mask_sitofp_2i64_2f64:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X64-AVX-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX-NEXT:    retq
;
; X64-AVX512F-LABEL: mask_sitofp_2i64_2f64:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X64-AVX512F-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX512F-NEXT:    retq
;
; X64-AVX512DQ-LABEL: mask_sitofp_2i64_2f64:
; X64-AVX512DQ:       # %bb.0:
; X64-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512DQ-NEXT:    vcvtqq2pd %xmm0, %xmm0
; X64-AVX512DQ-NEXT:    retq
  %and = and <2 x i64> %a, <i64 255, i64 65535>
  %cvt = sitofp <2 x i64> %and to <2 x double>
  ret <2 x double> %cvt
}

define <2 x double> @mask_uitofp_2i64_2f64(<2 x i64> %a) nounwind {
; X86-SSE-LABEL: mask_uitofp_2i64_2f64:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-SSE-NEXT:    cvtdq2pd %xmm0, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: mask_uitofp_2i64_2f64:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X86-AVX-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X86-AVX-NEXT:    retl
;
; X86-AVX512F-LABEL: mask_uitofp_2i64_2f64:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X86-AVX512F-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X86-AVX512F-NEXT:    retl
;
; X86-AVX512DQ-LABEL: mask_uitofp_2i64_2f64:
; X86-AVX512DQ:       # %bb.0:
; X86-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512DQ-NEXT:    vcvtqq2pd %xmm0, %xmm0
; X86-AVX512DQ-NEXT:    retl
;
; X64-SSE-LABEL: mask_uitofp_2i64_2f64:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-SSE-NEXT:    cvtdq2pd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: mask_uitofp_2i64_2f64:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X64-AVX-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX-NEXT:    retq
;
; X64-AVX512F-LABEL: mask_uitofp_2i64_2f64:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8,9],zero,zero,xmm0[u,u,u,u,u,u,u,u]
; X64-AVX512F-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX512F-NEXT:    retq
;
; X64-AVX512DQ-LABEL: mask_uitofp_2i64_2f64:
; X64-AVX512DQ:       # %bb.0:
; X64-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512DQ-NEXT:    vcvtqq2pd %xmm0, %xmm0
; X64-AVX512DQ-NEXT:    retq
  %and = and <2 x i64> %a, <i64 255, i64 65535>
  %cvt = uitofp <2 x i64> %and to <2 x double>
  ret <2 x double> %cvt
}

define <4 x float> @mask_sitofp_4i64_4f32(<4 x i64> %a) nounwind {
; X86-SSE-LABEL: mask_sitofp_4i64_4f32:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X86-SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-SSE-NEXT:    cvtdq2ps %xmm0, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: mask_sitofp_4i64_4f32:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X86-AVX-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-AVX-NEXT:    vzeroupper
; X86-AVX-NEXT:    retl
;
; X86-AVX512F-LABEL: mask_sitofp_4i64_4f32:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vpmovqd %ymm0, %xmm0
; X86-AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512F-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-AVX512F-NEXT:    vzeroupper
; X86-AVX512F-NEXT:    retl
;
; X86-AVX512DQ-LABEL: mask_sitofp_4i64_4f32:
; X86-AVX512DQ:       # %bb.0:
; X86-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X86-AVX512DQ-NEXT:    vcvtqq2ps %ymm0, %xmm0
; X86-AVX512DQ-NEXT:    vzeroupper
; X86-AVX512DQ-NEXT:    retl
;
; X64-SSE-LABEL: mask_sitofp_4i64_4f32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-SSE-NEXT:    cvtdq2ps %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: mask_sitofp_4i64_4f32:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX-NEXT:    vzeroupper
; X64-AVX-NEXT:    retq
;
; X64-AVX512F-LABEL: mask_sitofp_4i64_4f32:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vpmovqd %ymm0, %xmm0
; X64-AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512F-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX512F-NEXT:    vzeroupper
; X64-AVX512F-NEXT:    retq
;
; X64-AVX512DQ-LABEL: mask_sitofp_4i64_4f32:
; X64-AVX512DQ:       # %bb.0:
; X64-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX512DQ-NEXT:    vcvtqq2ps %ymm0, %xmm0
; X64-AVX512DQ-NEXT:    vzeroupper
; X64-AVX512DQ-NEXT:    retq
  %and = and <4 x i64> %a, <i64 127, i64 255, i64 4095, i64 65535>
  %cvt = sitofp <4 x i64> %and to <4 x float>
  ret <4 x float> %cvt
}

define <4 x float> @mask_uitofp_4i64_4f32(<4 x i64> %a) nounwind {
; X86-SSE-LABEL: mask_uitofp_4i64_4f32:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X86-SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-SSE-NEXT:    cvtdq2ps %xmm0, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: mask_uitofp_4i64_4f32:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X86-AVX-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-AVX-NEXT:    vzeroupper
; X86-AVX-NEXT:    retl
;
; X86-AVX512F-LABEL: mask_uitofp_4i64_4f32:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vpmovqd %ymm0, %xmm0
; X86-AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512F-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-AVX512F-NEXT:    vzeroupper
; X86-AVX512F-NEXT:    retl
;
; X86-AVX512DQ-LABEL: mask_uitofp_4i64_4f32:
; X86-AVX512DQ:       # %bb.0:
; X86-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X86-AVX512DQ-NEXT:    vcvtqq2ps %ymm0, %xmm0
; X86-AVX512DQ-NEXT:    vzeroupper
; X86-AVX512DQ-NEXT:    retl
;
; X64-SSE-LABEL: mask_uitofp_4i64_4f32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-SSE-NEXT:    cvtdq2ps %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: mask_uitofp_4i64_4f32:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX-NEXT:    vzeroupper
; X64-AVX-NEXT:    retq
;
; X64-AVX512F-LABEL: mask_uitofp_4i64_4f32:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vpmovqd %ymm0, %xmm0
; X64-AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512F-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX512F-NEXT:    vzeroupper
; X64-AVX512F-NEXT:    retq
;
; X64-AVX512DQ-LABEL: mask_uitofp_4i64_4f32:
; X64-AVX512DQ:       # %bb.0:
; X64-AVX512DQ-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX512DQ-NEXT:    vcvtqq2ps %ymm0, %xmm0
; X64-AVX512DQ-NEXT:    vzeroupper
; X64-AVX512DQ-NEXT:    retq
  %and = and <4 x i64> %a, <i64 127, i64 255, i64 4095, i64 65535>
  %cvt = uitofp <4 x i64> %and to <4 x float>
  ret <4 x float> %cvt
}

define <2 x double> @clamp_sitofp_2i64_2f64(<2 x i64> %a) nounwind {
; X86-SSE-LABEL: clamp_sitofp_2i64_2f64:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movdqa {{.*#+}} xmm1 = [2147483648,0,2147483648,0]
; X86-SSE-NEXT:    movdqa %xmm0, %xmm2
; X86-SSE-NEXT:    pxor %xmm1, %xmm2
; X86-SSE-NEXT:    movdqa {{.*#+}} xmm3 = [2147483393,4294967295,2147483393,4294967295]
; X86-SSE-NEXT:    movdqa %xmm2, %xmm4
; X86-SSE-NEXT:    pcmpgtd %xmm3, %xmm4
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; X86-SSE-NEXT:    pcmpeqd %xmm3, %xmm2
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm2[1,1,3,3]
; X86-SSE-NEXT:    pand %xmm5, %xmm3
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm4[1,1,3,3]
; X86-SSE-NEXT:    por %xmm3, %xmm2
; X86-SSE-NEXT:    pand %xmm2, %xmm0
; X86-SSE-NEXT:    pandn {{\.?LCPI[0-9]+_[0-9]+}}, %xmm2
; X86-SSE-NEXT:    por %xmm0, %xmm2
; X86-SSE-NEXT:    pxor %xmm2, %xmm1
; X86-SSE-NEXT:    movdqa {{.*#+}} xmm0 = [2147483903,0,2147483903,0]
; X86-SSE-NEXT:    movdqa %xmm0, %xmm3
; X86-SSE-NEXT:    pcmpgtd %xmm1, %xmm3
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm3[0,0,2,2]
; X86-SSE-NEXT:    pcmpeqd %xmm0, %xmm1
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,3,3]
; X86-SSE-NEXT:    pand %xmm4, %xmm0
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,1,3,3]
; X86-SSE-NEXT:    por %xmm0, %xmm1
; X86-SSE-NEXT:    pand %xmm1, %xmm2
; X86-SSE-NEXT:    pandn {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE-NEXT:    por %xmm2, %xmm1
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,2,2,3]
; X86-SSE-NEXT:    cvtdq2pd %xmm0, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: clamp_sitofp_2i64_2f64:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    vmovddup {{.*#+}} xmm1 = [18446744073709551361,18446744073709551361]
; X86-AVX-NEXT:    # xmm1 = mem[0,0]
; X86-AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm2
; X86-AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; X86-AVX-NEXT:    vmovddup {{.*#+}} xmm1 = [255,255]
; X86-AVX-NEXT:    # xmm1 = mem[0,0]
; X86-AVX-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm2
; X86-AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; X86-AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-AVX-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X86-AVX-NEXT:    retl
;
; X86-AVX512F-LABEL: clamp_sitofp_2i64_2f64:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vpmaxsq {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512F-NEXT:    vpminsq {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-AVX512F-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X86-AVX512F-NEXT:    retl
;
; X86-AVX512DQ-LABEL: clamp_sitofp_2i64_2f64:
; X86-AVX512DQ:       # %bb.0:
; X86-AVX512DQ-NEXT:    vpmaxsq {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512DQ-NEXT:    vpminsq {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX512DQ-NEXT:    vcvtqq2pd %xmm0, %xmm0
; X86-AVX512DQ-NEXT:    retl
;
; X64-SSE-LABEL: clamp_sitofp_2i64_2f64:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movdqa {{.*#+}} xmm1 = [2147483648,2147483648]
; X64-SSE-NEXT:    movdqa %xmm0, %xmm2
; X64-SSE-NEXT:    pxor %xmm1, %xmm2
; X64-SSE-NEXT:    movdqa {{.*#+}} xmm3 = [18446744071562067713,18446744071562067713]
; X64-SSE-NEXT:    movdqa %xmm2, %xmm4
; X64-SSE-NEXT:    pcmpgtd %xmm3, %xmm4
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; X64-SSE-NEXT:    pcmpeqd %xmm3, %xmm2
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; X64-SSE-NEXT:    pand %xmm5, %xmm2
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; X64-SSE-NEXT:    por %xmm2, %xmm3
; X64-SSE-NEXT:    pand %xmm3, %xmm0
; X64-SSE-NEXT:    pandn {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm3
; X64-SSE-NEXT:    por %xmm0, %xmm3
; X64-SSE-NEXT:    pxor %xmm3, %xmm1
; X64-SSE-NEXT:    movdqa {{.*#+}} xmm0 = [2147483903,2147483903]
; X64-SSE-NEXT:    movdqa %xmm0, %xmm2
; X64-SSE-NEXT:    pcmpgtd %xmm1, %xmm2
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm2[0,0,2,2]
; X64-SSE-NEXT:    pcmpeqd %xmm0, %xmm1
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,3,3]
; X64-SSE-NEXT:    pand %xmm4, %xmm0
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[1,1,3,3]
; X64-SSE-NEXT:    por %xmm0, %xmm1
; X64-SSE-NEXT:    pand %xmm1, %xmm3
; X64-SSE-NEXT:    pandn {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; X64-SSE-NEXT:    por %xmm3, %xmm1
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,2,2,3]
; X64-SSE-NEXT:    cvtdq2pd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: clamp_sitofp_2i64_2f64:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551361,18446744073709551361]
; X64-AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [255,255]
; X64-AVX-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm2
; X64-AVX-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; X64-AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-AVX-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX-NEXT:    retq
;
; X64-AVX512F-LABEL: clamp_sitofp_2i64_2f64:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vpmaxsq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512F-NEXT:    vpminsq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-AVX512F-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX512F-NEXT:    retq
;
; X64-AVX512DQ-LABEL: clamp_sitofp_2i64_2f64:
; X64-AVX512DQ:       # %bb.0:
; X64-AVX512DQ-NEXT:    vpmaxsq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512DQ-NEXT:    vpminsq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX512DQ-NEXT:    vcvtqq2pd %xmm0, %xmm0
; X64-AVX512DQ-NEXT:    retq
  %clo = icmp slt <2 x i64> %a, <i64 -255, i64 -255>
  %lo = select <2 x i1> %clo, <2 x i64> <i64 -255, i64 -255>, <2 x i64> %a
  %chi = icmp sgt <2 x i64> %lo, <i64 255, i64 255>
  %hi = select <2 x i1> %chi, <2 x i64> <i64 255, i64 255>, <2 x i64> %lo
  %cvt = sitofp <2 x i64> %hi to <2 x double>
  ret <2 x double> %cvt
}
