; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefix=AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefix=AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512vl | FileCheck %s --check-prefix=AVX512VLBW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vbmi2 | FileCheck %s --check-prefix=AVX512VBMI2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vbmi2,+avx512vl | FileCheck %s --check-prefix=AVX512VLVBMI2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+xop,+avx | FileCheck %s --check-prefixes=XOP,XOPAVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+xop,+avx2 | FileCheck %s --check-prefixes=XOP,XOPAVX2

; Just one 32-bit run to make sure we do reasonable things for i64 cases.
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86-SSE2

declare <2 x i32> @llvm.fshl.v2i32(<2 x i32>, <2 x i32>, <2 x i32>)

;
; Variable Shifts
;

define <2 x i32> @var_funnnel_v2i32(<2 x i32> %x, <2 x i32> %amt) nounwind {
; SSE2-LABEL: var_funnnel_v2i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE2-NEXT:    pslld $23, %xmm1
; SSE2-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE2-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: var_funnnel_v2i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE41-NEXT:    pslld $23, %xmm1
; SSE41-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE41-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; SSE41-NEXT:    pmuludq %xmm2, %xmm3
; SSE41-NEXT:    pmuludq %xmm1, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[0,0,2,2]
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; SSE41-NEXT:    por %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: var_funnnel_v2i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpslld $23, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vcvttps2dq %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[0,0,2,2]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: var_funnnel_v2i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [31,31,31,31]
; AVX2-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsllvd %xmm1, %xmm0, %xmm2
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [32,32,32,32]
; AVX2-NEXT:    vpsubd %xmm1, %xmm3, %xmm1
; AVX2-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpor %xmm0, %xmm2, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: var_funnnel_v2i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: var_funnnel_v2i32:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vprolvd %xmm1, %xmm0, %xmm0
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: var_funnnel_v2i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512BW-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512VLBW-LABEL: var_funnnel_v2i32:
; AVX512VLBW:       # %bb.0:
; AVX512VLBW-NEXT:    vprolvd %xmm1, %xmm0, %xmm0
; AVX512VLBW-NEXT:    retq
;
; AVX512VBMI2-LABEL: var_funnnel_v2i32:
; AVX512VBMI2:       # %bb.0:
; AVX512VBMI2-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512VBMI2-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512VBMI2-NEXT:    vzeroupper
; AVX512VBMI2-NEXT:    retq
;
; AVX512VLVBMI2-LABEL: var_funnnel_v2i32:
; AVX512VLVBMI2:       # %bb.0:
; AVX512VLVBMI2-NEXT:    vprolvd %xmm1, %xmm0, %xmm0
; AVX512VLVBMI2-NEXT:    retq
;
; XOP-LABEL: var_funnnel_v2i32:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd %xmm1, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; X86-SSE2-LABEL: var_funnnel_v2i32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE2-NEXT:    pslld $23, %xmm1
; X86-SSE2-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE2-NEXT:    cvttps2dq %xmm1, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm1, %xmm0
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X86-SSE2-NEXT:    por %xmm3, %xmm0
; X86-SSE2-NEXT:    retl
  %res = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> %x, <2 x i32> %x, <2 x i32> %amt)
  ret <2 x i32> %res
}

;
; Uniform Variable Shifts
;

define <2 x i32> @splatvar_funnnel_v2i32(<2 x i32> %x, <2 x i32> %amt) nounwind {
; SSE2-LABEL: splatvar_funnnel_v2i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE2-NEXT:    pslld $23, %xmm1
; SSE2-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE2-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: splatvar_funnnel_v2i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE41-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE41-NEXT:    pslld $23, %xmm1
; SSE41-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE41-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; SSE41-NEXT:    pmuludq %xmm2, %xmm3
; SSE41-NEXT:    pmuludq %xmm1, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[0,0,2,2]
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; SSE41-NEXT:    por %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: splatvar_funnnel_v2i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; AVX1-NEXT:    vpslld $23, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vcvttps2dq %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[0,0,2,2]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatvar_funnnel_v2i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [31,31,31,31]
; AVX2-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero
; AVX2-NEXT:    vpslld %xmm2, %xmm0, %xmm2
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [32,32,32,32]
; AVX2-NEXT:    vpsubd %xmm1, %xmm3, %xmm1
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; AVX2-NEXT:    vpsrld %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpor %xmm0, %xmm2, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: splatvar_funnnel_v2i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vpbroadcastd %xmm1, %xmm1
; AVX512F-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: splatvar_funnnel_v2i32:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpbroadcastd %xmm1, %xmm1
; AVX512VL-NEXT:    vprolvd %xmm1, %xmm0, %xmm0
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: splatvar_funnnel_v2i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512BW-NEXT:    vpbroadcastd %xmm1, %xmm1
; AVX512BW-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512VLBW-LABEL: splatvar_funnnel_v2i32:
; AVX512VLBW:       # %bb.0:
; AVX512VLBW-NEXT:    vpbroadcastd %xmm1, %xmm1
; AVX512VLBW-NEXT:    vprolvd %xmm1, %xmm0, %xmm0
; AVX512VLBW-NEXT:    retq
;
; AVX512VBMI2-LABEL: splatvar_funnnel_v2i32:
; AVX512VBMI2:       # %bb.0:
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512VBMI2-NEXT:    vpbroadcastd %xmm1, %xmm1
; AVX512VBMI2-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512VBMI2-NEXT:    vzeroupper
; AVX512VBMI2-NEXT:    retq
;
; AVX512VLVBMI2-LABEL: splatvar_funnnel_v2i32:
; AVX512VLVBMI2:       # %bb.0:
; AVX512VLVBMI2-NEXT:    vpbroadcastd %xmm1, %xmm1
; AVX512VLVBMI2-NEXT:    vprolvd %xmm1, %xmm0, %xmm0
; AVX512VLVBMI2-NEXT:    retq
;
; XOPAVX1-LABEL: splatvar_funnnel_v2i32:
; XOPAVX1:       # %bb.0:
; XOPAVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,0,1,1]
; XOPAVX1-NEXT:    vprotd %xmm1, %xmm0, %xmm0
; XOPAVX1-NEXT:    retq
;
; XOPAVX2-LABEL: splatvar_funnnel_v2i32:
; XOPAVX2:       # %bb.0:
; XOPAVX2-NEXT:    vpbroadcastd %xmm1, %xmm1
; XOPAVX2-NEXT:    vprotd %xmm1, %xmm0, %xmm0
; XOPAVX2-NEXT:    retq
;
; X86-SSE2-LABEL: splatvar_funnnel_v2i32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; X86-SSE2-NEXT:    pslld $23, %xmm1
; X86-SSE2-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE2-NEXT:    cvttps2dq %xmm1, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm1, %xmm0
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X86-SSE2-NEXT:    por %xmm3, %xmm0
; X86-SSE2-NEXT:    retl
  %splat = shufflevector <2 x i32> %amt, <2 x i32> undef, <2 x i32> zeroinitializer
  %res = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> %x, <2 x i32> %x, <2 x i32> %splat)
  ret <2 x i32> %res
}

;
; Constant Shifts
;

define <2 x i32> @constant_funnnel_v2i32(<2 x i32> %x) nounwind {
; SSE2-LABEL: constant_funnnel_v2i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [16,32,1,1]
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: constant_funnnel_v2i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [16,32,1,1]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pmuludq %xmm2, %xmm3
; SSE41-NEXT:    pmuludq %xmm1, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[0,0,2,2]
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; SSE41-NEXT:    por %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: constant_funnnel_v2i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [16,32,1,1]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[0,0,2,2]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: constant_funnnel_v2i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm1
; AVX2-NEXT:    vpsllvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: constant_funnnel_v2i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vmovdqa {{.*#+}} xmm1 = <4,5,u,u>
; AVX512F-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: constant_funnnel_v2i32:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vprolvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: constant_funnnel_v2i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512BW-NEXT:    vmovdqa {{.*#+}} xmm1 = <4,5,u,u>
; AVX512BW-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512VLBW-LABEL: constant_funnnel_v2i32:
; AVX512VLBW:       # %bb.0:
; AVX512VLBW-NEXT:    vprolvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512VLBW-NEXT:    retq
;
; AVX512VBMI2-LABEL: constant_funnnel_v2i32:
; AVX512VBMI2:       # %bb.0:
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512VBMI2-NEXT:    vmovdqa {{.*#+}} xmm1 = <4,5,u,u>
; AVX512VBMI2-NEXT:    vprolvd %zmm1, %zmm0, %zmm0
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512VBMI2-NEXT:    vzeroupper
; AVX512VBMI2-NEXT:    retq
;
; AVX512VLVBMI2-LABEL: constant_funnnel_v2i32:
; AVX512VLVBMI2:       # %bb.0:
; AVX512VLVBMI2-NEXT:    vprolvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512VLVBMI2-NEXT:    retq
;
; XOP-LABEL: constant_funnnel_v2i32:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOP-NEXT:    retq
;
; X86-SSE2-LABEL: constant_funnnel_v2i32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [16,32,1,1]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm1, %xmm0
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X86-SSE2-NEXT:    por %xmm3, %xmm0
; X86-SSE2-NEXT:    retl
  %res = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> %x, <2 x i32> %x, <2 x i32> <i32 4, i32 5>)
  ret <2 x i32> %res
}

;
; Uniform Constant Shifts
;

define <2 x i32> @splatconstant_funnnel_v2i32(<2 x i32> %x) nounwind {
; SSE2-LABEL: splatconstant_funnnel_v2i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrld $28, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pslld $4, %xmm2
; SSE2-NEXT:    por %xmm1, %xmm2
; SSE2-NEXT:    movsd %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: splatconstant_funnnel_v2i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa %xmm0, %xmm1
; SSE41-NEXT:    psrld $28, %xmm1
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    pslld $4, %xmm2
; SSE41-NEXT:    por %xmm1, %xmm2
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm2[0,1,2,3],xmm0[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: splatconstant_funnnel_v2i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrld $28, %xmm0, %xmm1
; AVX1-NEXT:    vpslld $4, %xmm0, %xmm2
; AVX1-NEXT:    vpor %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatconstant_funnnel_v2i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm1
; AVX2-NEXT:    vpsllvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: splatconstant_funnnel_v2i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vprold $4, %zmm0, %zmm0
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: splatconstant_funnnel_v2i32:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vprold $4, %xmm0, %xmm0
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: splatconstant_funnnel_v2i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512BW-NEXT:    vprold $4, %zmm0, %zmm0
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512VLBW-LABEL: splatconstant_funnnel_v2i32:
; AVX512VLBW:       # %bb.0:
; AVX512VLBW-NEXT:    vprold $4, %xmm0, %xmm0
; AVX512VLBW-NEXT:    retq
;
; AVX512VBMI2-LABEL: splatconstant_funnnel_v2i32:
; AVX512VBMI2:       # %bb.0:
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512VBMI2-NEXT:    vprold $4, %zmm0, %zmm0
; AVX512VBMI2-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512VBMI2-NEXT:    vzeroupper
; AVX512VBMI2-NEXT:    retq
;
; AVX512VLVBMI2-LABEL: splatconstant_funnnel_v2i32:
; AVX512VLVBMI2:       # %bb.0:
; AVX512VLVBMI2-NEXT:    vprold $4, %xmm0, %xmm0
; AVX512VLVBMI2-NEXT:    retq
;
; XOP-LABEL: splatconstant_funnnel_v2i32:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd $4, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; X86-SSE2-LABEL: splatconstant_funnnel_v2i32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movdqa %xmm0, %xmm1
; X86-SSE2-NEXT:    psrld $28, %xmm1
; X86-SSE2-NEXT:    movdqa %xmm0, %xmm2
; X86-SSE2-NEXT:    pslld $4, %xmm2
; X86-SSE2-NEXT:    por %xmm1, %xmm2
; X86-SSE2-NEXT:    movsd %xmm2, %xmm0
; X86-SSE2-NEXT:    retl
  %res = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> %x, <2 x i32> %x, <2 x i32> <i32 4, i32 4>)
  ret <2 x i32> %res
}
