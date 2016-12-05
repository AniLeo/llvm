; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; fold (urem undef, x) -> 0
define <4 x i32> @combine_vec_urem_undef0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_undef0:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_undef0:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = urem <4 x i32> undef, %x
  ret <4 x i32> %1
}

; fold (urem x, undef) -> undef
define <4 x i32> @combine_vec_urem_undef1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_undef1:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_undef1:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = urem <4 x i32> %x, undef
  ret <4 x i32> %1
}

; fold (urem x, pow2) -> (and x, (pow2-1))
define <4 x i32> @combine_vec_urem_by_pow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_by_pow2a:
; SSE:       # BB#0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_by_pow2a:
; AVX:       # BB#0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = urem <4 x i32> %x, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_urem_by_pow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_by_pow2b:
; SSE:       # BB#0:
; SSE-NEXT:    pextrd $3, %xmm0, %eax
; SSE-NEXT:    andl $15, %eax
; SSE-NEXT:    movd %eax, %xmm1
; SSE-NEXT:    pextrd $2, %xmm0, %eax
; SSE-NEXT:    andl $7, %eax
; SSE-NEXT:    movd %eax, %xmm2
; SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE-NEXT:    pextrd $1, %xmm0, %eax
; SSE-NEXT:    andl $3, %eax
; SSE-NEXT:    movd %eax, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,0,2,3]
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_by_pow2b:
; AVX:       # BB#0:
; AVX-NEXT:    vpextrd $3, %xmm0, %eax
; AVX-NEXT:    andl $15, %eax
; AVX-NEXT:    vmovd %eax, %xmm1
; AVX-NEXT:    vpextrd $2, %xmm0, %eax
; AVX-NEXT:    andl $7, %eax
; AVX-NEXT:    vmovd %eax, %xmm2
; AVX-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    andl $3, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,0,2,3]
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    retq
  %1 = urem <4 x i32> %x, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %1
}

; fold (urem x, (shl pow2, y)) -> (and x, (add (shl pow2, y), -1))
define <4 x i32> @combine_vec_urem_by_shl_pow2a(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_urem_by_shl_pow2a:
; SSE:       # BB#0:
; SSE-NEXT:    pslld $23, %xmm1
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm1
; SSE-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE-NEXT:    pslld $2, %xmm1
; SSE-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE-NEXT:    paddd %xmm1, %xmm2
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_by_shl_pow2a:
; AVX:       # BB#0:
; AVX-NEXT:    vpbroadcastd {{.*}}(%rip), %xmm2
; AVX-NEXT:    vpsllvd %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> <i32 4, i32 4, i32 4, i32 4>, %y
  %2 = urem <4 x i32> %x, %1
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_urem_by_shl_pow2b(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_urem_by_shl_pow2b:
; SSE:       # BB#0:
; SSE-NEXT:    pslld $23, %xmm1
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm1
; SSE-NEXT:    cvttps2dq %xmm1, %xmm2
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm2
; SSE-NEXT:    pextrd $1, %xmm0, %eax
; SSE-NEXT:    pextrd $1, %xmm2, %ecx
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %ecx
; SSE-NEXT:    movl %edx, %ecx
; SSE-NEXT:    movd %xmm0, %eax
; SSE-NEXT:    movd %xmm2, %esi
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %esi
; SSE-NEXT:    movd %edx, %xmm1
; SSE-NEXT:    pinsrd $1, %ecx, %xmm1
; SSE-NEXT:    pextrd $2, %xmm0, %eax
; SSE-NEXT:    pextrd $2, %xmm2, %ecx
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %ecx
; SSE-NEXT:    pinsrd $2, %edx, %xmm1
; SSE-NEXT:    pextrd $3, %xmm0, %eax
; SSE-NEXT:    pextrd $3, %xmm2, %ecx
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %ecx
; SSE-NEXT:    pinsrd $3, %edx, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_by_shl_pow2b:
; AVX:       # BB#0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [1,4,8,16]
; AVX-NEXT:    vpsllvd %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vpextrd $1, %xmm1, %ecx
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %ecx
; AVX-NEXT:    movl %edx, %ecx
; AVX-NEXT:    vmovd %xmm1, %esi
; AVX-NEXT:    vmovd %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %esi
; AVX-NEXT:    vmovd %edx, %xmm2
; AVX-NEXT:    vpinsrd $1, %ecx, %xmm2, %xmm2
; AVX-NEXT:    vpextrd $2, %xmm1, %ecx
; AVX-NEXT:    vpextrd $2, %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %ecx
; AVX-NEXT:    vpinsrd $2, %edx, %xmm2, %xmm2
; AVX-NEXT:    vpextrd $3, %xmm1, %ecx
; AVX-NEXT:    vpextrd $3, %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %ecx
; AVX-NEXT:    vpinsrd $3, %edx, %xmm2, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> <i32 1, i32 4, i32 8, i32 16>, %y
  %2 = urem <4 x i32> %x, %1
  ret <4 x i32> %2
}
