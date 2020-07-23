; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3           | FileCheck %s --check-prefixes=SSE,SSSE3,SSSE3-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3,fast-hops | FileCheck %s --check-prefixes=SSE,SSSE3,SSSE3-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx             | FileCheck %s --check-prefixes=AVX,AVX-SLOW,AVX1,AVX1-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,fast-hops   | FileCheck %s --check-prefixes=AVX,AVX-FAST,AVX1,AVX1-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2            | FileCheck %s --check-prefixes=AVX,AVX-SLOW,AVX2,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2,fast-hops  | FileCheck %s --check-prefixes=AVX,AVX-FAST,AVX2,AVX2-FAST

define <8 x i16> @hadd_reverse_v8i16(<8 x i16> %a0, <8 x i16> %a1) nounwind {
; SSE-LABEL: hadd_reverse_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [14,15,10,11,6,7,2,3,14,15,10,11,12,13,14,15]
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    pshufb %xmm2, %xmm3
; SSE-NEXT:    movdqa %xmm0, %xmm4
; SSE-NEXT:    pshufb %xmm2, %xmm4
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm4 = xmm4[0],xmm3[0]
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [12,13,8,9,4,5,0,1,8,9,12,13,12,13,14,15]
; SSE-NEXT:    pshufb %xmm2, %xmm1
; SSE-NEXT:    pshufb %xmm2, %xmm0
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-NEXT:    paddw %xmm4, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: hadd_reverse_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [14,15,10,11,6,7,2,3,14,15,10,11,12,13,14,15]
; AVX-NEXT:    vpshufb %xmm2, %xmm1, %xmm3
; AVX-NEXT:    vpshufb %xmm2, %xmm0, %xmm2
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; AVX-NEXT:    vmovdqa {{.*#+}} xmm3 = [12,13,8,9,4,5,0,1,8,9,12,13,12,13,14,15]
; AVX-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    vpaddw %xmm0, %xmm2, %xmm0
; AVX-NEXT:    retq
  %lhs = shufflevector <8 x i16> %a0, <8 x i16> %a1, <8 x i32> <i32 7, i32 5, i32 3, i32 1, i32 15, i32 13, i32 11, i32 9>
  %rhs = shufflevector <8 x i16> %a0, <8 x i16> %a1, <8 x i32> <i32 6, i32 4, i32 2, i32 0, i32 14, i32 12, i32 10, i32 8>
  %add = add <8 x i16> %lhs, %rhs
  ret <8 x i16> %add
}

define <8 x i16> @hadd_reverse2_v8i16(<8 x i16> %a0, <8 x i16> %a1) nounwind {
; SSE-LABEL: hadd_reverse2_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1]
; SSE-NEXT:    pshufb %xmm2, %xmm0
; SSE-NEXT:    pshufb %xmm2, %xmm1
; SSE-NEXT:    phaddw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: hadd_reverse2_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1]
; AVX-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %shuf0 = shufflevector <8 x i16> %a0, <8 x i16> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %shuf1 = shufflevector <8 x i16> %a1, <8 x i16> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %lhs = shufflevector <8 x i16> %shuf0, <8 x i16> %shuf1, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %rhs = shufflevector <8 x i16> %shuf0, <8 x i16> %shuf1, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %add = add <8 x i16> %lhs, %rhs
  ret <8 x i16> %add
}

define <16 x i16> @hadd_reverse_v16i16(<16 x i16> %a0, <16 x i16> %a1) nounwind {
; SSE-LABEL: hadd_reverse_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm4
; SSE-NEXT:    movdqa {{.*#+}} xmm0 = [14,15,10,11,6,7,2,3,14,15,10,11,12,13,14,15]
; SSE-NEXT:    movdqa %xmm2, %xmm5
; SSE-NEXT:    pshufb %xmm0, %xmm5
; SSE-NEXT:    movdqa %xmm4, %xmm6
; SSE-NEXT:    pshufb %xmm0, %xmm6
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm6 = xmm6[0],xmm5[0]
; SSE-NEXT:    movdqa %xmm3, %xmm5
; SSE-NEXT:    pshufb %xmm0, %xmm5
; SSE-NEXT:    movdqa %xmm1, %xmm7
; SSE-NEXT:    pshufb %xmm0, %xmm7
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm7 = xmm7[0],xmm5[0]
; SSE-NEXT:    movdqa {{.*#+}} xmm0 = [12,13,8,9,4,5,0,1,8,9,12,13,12,13,14,15]
; SSE-NEXT:    pshufb %xmm0, %xmm2
; SSE-NEXT:    pshufb %xmm0, %xmm4
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm4 = xmm4[0],xmm2[0]
; SSE-NEXT:    paddw %xmm6, %xmm4
; SSE-NEXT:    pshufb %xmm0, %xmm3
; SSE-NEXT:    pshufb %xmm0, %xmm1
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; SSE-NEXT:    paddw %xmm7, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    movdqa %xmm4, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: hadd_reverse_v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [14,15,10,11,6,7,2,3,14,15,10,11,12,13,14,15]
; AVX1-NEXT:    vpshufb %xmm3, %xmm2, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpshufb %xmm3, %xmm5, %xmm6
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm4 = xmm6[0],xmm4[0]
; AVX1-NEXT:    vpshufb %xmm3, %xmm1, %xmm6
; AVX1-NEXT:    vpshufb %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm3 = xmm3[0],xmm6[0]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm6 = [12,13,8,9,4,5,0,1,8,9,12,13,12,13,14,15]
; AVX1-NEXT:    vpshufb %xmm6, %xmm2, %xmm2
; AVX1-NEXT:    vpshufb %xmm6, %xmm5, %xmm5
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm5[0],xmm2[0]
; AVX1-NEXT:    vpaddw %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpshufb %xmm6, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm6, %xmm0, %xmm0
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vpaddw %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: hadd_reverse_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpshuflw {{.*#+}} ymm2 = ymm1[3,1,2,3,4,5,6,7,11,9,10,11,12,13,14,15]
; AVX2-NEXT:    vpshufhw {{.*#+}} ymm2 = ymm2[0,1,2,3,7,5,6,7,8,9,10,11,15,13,14,15]
; AVX2-NEXT:    vpshuflw {{.*#+}} ymm3 = ymm0[3,1,2,3,4,5,6,7,11,9,10,11,12,13,14,15]
; AVX2-NEXT:    vpshufhw {{.*#+}} ymm3 = ymm3[0,1,2,3,7,5,6,7,8,9,10,11,15,13,14,15]
; AVX2-NEXT:    vshufps {{.*#+}} ymm2 = ymm3[2,0],ymm2[2,0],ymm3[6,4],ymm2[6,4]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[2,3,0,1]
; AVX2-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[u,u,u,u,u,u,u,u,12,13,8,9,4,5,0,1,u,u,u,u,u,u,u,u,28,29,24,25,20,21,16,17]
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[12,13,8,9,4,5,0,1,u,u,u,u,u,u,u,u,28,29,24,25,20,21,16,17,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-NEXT:    vpaddw %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    retq
  %lhs = shufflevector <16 x i16> %a0, <16 x i16> %a1, <16 x i32> <i32 15, i32 13, i32 11, i32 9, i32 31, i32 29, i32 27, i32 25, i32 7, i32 5, i32 3, i32 1, i32 23, i32 21, i32 19, i32 17>
  %rhs = shufflevector <16 x i16> %a0, <16 x i16> %a1, <16 x i32> <i32 14, i32 12, i32 10, i32 8, i32 30, i32 28, i32 26, i32 24, i32 6, i32 4, i32 2, i32 0, i32 22, i32 20, i32 18, i32 16>
  %add = add <16 x i16> %lhs, %rhs
  ret <16 x i16> %add
}

define <16 x i16> @hadd_reverse2_v16i16(<16 x i16> %a0, <16 x i16> %a1) nounwind {
; SSE-LABEL: hadd_reverse2_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm4
; SSE-NEXT:    movdqa {{.*#+}} xmm0 = [14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1]
; SSE-NEXT:    pshufb %xmm0, %xmm4
; SSE-NEXT:    pshufb %xmm0, %xmm1
; SSE-NEXT:    pshufb %xmm0, %xmm2
; SSE-NEXT:    phaddw %xmm2, %xmm4
; SSE-NEXT:    pshufb %xmm0, %xmm3
; SSE-NEXT:    phaddw %xmm3, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    movdqa %xmm4, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: hadd_reverse2_v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1]
; AVX1-NEXT:    vpshufb %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX1-NEXT:    vpshufb %xmm3, %xmm4, %xmm4
; AVX1-NEXT:    vphaddw %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: hadd_reverse2_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1,30,31,28,29,26,27,24,25,22,23,20,21,18,19,16,17]
; AVX2-NEXT:    vpshufb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-NEXT:    vpshufb %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[2,3,0,1]
; AVX2-NEXT:    vphaddw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shuf0 = shufflevector <16 x i16> %a0, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %shuf1 = shufflevector <16 x i16> %a1, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %lhs = shufflevector <16 x i16> %shuf0, <16 x i16> %shuf1, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 16, i32 18, i32 20, i32 22, i32 8, i32 10, i32 12, i32 14, i32 24, i32 26, i32 28, i32 30>
  %rhs = shufflevector <16 x i16> %shuf0, <16 x i16> %shuf1, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 17, i32 19, i32 21, i32 23, i32 9, i32 11, i32 13, i32 15, i32 25, i32 27, i32 29, i32 31>
  %add = add <16 x i16> %lhs, %rhs
  ret <16 x i16> %add
}

define <8 x double> @hadd_reverse_v8f64(<8 x double> %a0, <8 x double> %a1) nounwind {
; SSE-LABEL: hadd_reverse_v8f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movapd %xmm1, %xmm8
; SSE-NEXT:    movapd %xmm0, %xmm9
; SSE-NEXT:    haddpd %xmm7, %xmm3
; SSE-NEXT:    haddpd %xmm6, %xmm2
; SSE-NEXT:    haddpd %xmm5, %xmm8
; SSE-NEXT:    haddpd %xmm4, %xmm9
; SSE-NEXT:    movapd %xmm3, %xmm0
; SSE-NEXT:    movapd %xmm2, %xmm1
; SSE-NEXT:    movapd %xmm8, %xmm2
; SSE-NEXT:    movapd %xmm9, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: hadd_reverse_v8f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm2 = ymm2[2,3,0,1]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX1-NEXT:    vhaddpd %ymm2, %ymm0, %ymm2
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm3[2,3,0,1]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3,0,1]
; AVX1-NEXT:    vhaddpd %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    vmovapd %ymm2, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: hadd_reverse_v8f64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm2[0,3,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm0[0,3,2,1]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm5[1],ymm4[1],ymm5[3],ymm4[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm3[0,3,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm6 = ymm1[0,3,2,1]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm5 = ymm6[1],ymm5[1],ymm6[3],ymm5[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[2,1,0,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,1,0,3]
; AVX2-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm2[0],ymm0[2],ymm2[2]
; AVX2-NEXT:    vaddpd %ymm0, %ymm4, %ymm2
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm3[2,1,0,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[2,1,0,3]
; AVX2-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm1[0],ymm0[0],ymm1[2],ymm0[2]
; AVX2-NEXT:    vaddpd %ymm0, %ymm5, %ymm0
; AVX2-NEXT:    vmovapd %ymm2, %ymm1
; AVX2-NEXT:    retq
  %lhs = shufflevector <8 x double> %a0, <8 x double> %a1, <8 x i32> <i32 7, i32 15, i32 5, i32 13, i32 3, i32 11, i32 1, i32 9>
  %rhs = shufflevector <8 x double> %a0, <8 x double> %a1, <8 x i32> <i32 6, i32 14, i32 4, i32 12, i32 2, i32 10, i32 0, i32 8>
  %fadd = fadd <8 x double> %lhs, %rhs
  ret <8 x double> %fadd
}

define <8 x double> @hadd_reverse2_v8f64(<8 x double> %a0, <8 x double> %a1) nounwind {
; SSE-LABEL: hadd_reverse2_v8f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movapd %xmm1, %xmm8
; SSE-NEXT:    movapd %xmm0, %xmm9
; SSE-NEXT:    shufpd {{.*#+}} xmm9 = xmm9[1],xmm0[0]
; SSE-NEXT:    shufpd {{.*#+}} xmm8 = xmm8[1],xmm1[0]
; SSE-NEXT:    shufpd {{.*#+}} xmm2 = xmm2[1,0]
; SSE-NEXT:    shufpd {{.*#+}} xmm3 = xmm3[1,0]
; SSE-NEXT:    shufpd {{.*#+}} xmm4 = xmm4[1,0]
; SSE-NEXT:    haddpd %xmm4, %xmm9
; SSE-NEXT:    shufpd {{.*#+}} xmm5 = xmm5[1,0]
; SSE-NEXT:    haddpd %xmm5, %xmm8
; SSE-NEXT:    shufpd {{.*#+}} xmm6 = xmm6[1,0]
; SSE-NEXT:    haddpd %xmm6, %xmm2
; SSE-NEXT:    shufpd {{.*#+}} xmm7 = xmm7[1,0]
; SSE-NEXT:    haddpd %xmm7, %xmm3
; SSE-NEXT:    movapd %xmm3, %xmm0
; SSE-NEXT:    movapd %xmm2, %xmm1
; SSE-NEXT:    movapd %xmm8, %xmm2
; SSE-NEXT:    movapd %xmm9, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: hadd_reverse2_v8f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[1,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm1 = ymm1[1,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm1[2,3,0,1]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm1 = ymm2[1,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3,0,1]
; AVX1-NEXT:    vhaddpd %ymm1, %ymm0, %ymm1
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm3[1,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX1-NEXT:    vhaddpd %ymm0, %ymm4, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: hadd_reverse2_v8f64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[3,2,1,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm1[3,2,1,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm2[3,2,1,0]
; AVX2-NEXT:    vhaddpd %ymm1, %ymm0, %ymm1
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm3[3,2,1,0]
; AVX2-NEXT:    vhaddpd %ymm0, %ymm4, %ymm0
; AVX2-NEXT:    retq
  %shuf0 = shufflevector <8 x double> %a0, <8 x double> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %shuf1 = shufflevector <8 x double> %a1, <8 x double> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %lhs = shufflevector <8 x double> %shuf0, <8 x double> %shuf1, <8 x i32> <i32 0, i32 8, i32 2, i32 10, i32 4, i32 12, i32 6, i32 14>
  %rhs = shufflevector <8 x double> %shuf0, <8 x double> %shuf1, <8 x i32> <i32 1, i32 9, i32 3, i32 11, i32 5, i32 13, i32 7, i32 15>
  %fadd = fadd <8 x double> %lhs, %rhs
  ret <8 x double> %fadd
}

define <16 x float> @hadd_reverse_v16f32(<16 x float> %a0, <16 x float> %a1) nounwind {
; SSE-LABEL: hadd_reverse_v16f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm5, %xmm8
; SSE-NEXT:    movaps %xmm1, %xmm5
; SSE-NEXT:    movaps %xmm8, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[3,1],xmm4[3,1]
; SSE-NEXT:    movaps %xmm5, %xmm9
; SSE-NEXT:    shufps {{.*#+}} xmm9 = xmm9[3,1],xmm0[3,1]
; SSE-NEXT:    movaps %xmm7, %xmm10
; SSE-NEXT:    shufps {{.*#+}} xmm10 = xmm10[3,1],xmm6[3,1]
; SSE-NEXT:    movaps %xmm3, %xmm11
; SSE-NEXT:    shufps {{.*#+}} xmm11 = xmm11[3,1],xmm2[3,1]
; SSE-NEXT:    shufps {{.*#+}} xmm8 = xmm8[2,0],xmm4[2,0]
; SSE-NEXT:    addps %xmm1, %xmm8
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[2,0],xmm0[2,0]
; SSE-NEXT:    addps %xmm9, %xmm5
; SSE-NEXT:    shufps {{.*#+}} xmm7 = xmm7[2,0],xmm6[2,0]
; SSE-NEXT:    addps %xmm10, %xmm7
; SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[2,0],xmm2[2,0]
; SSE-NEXT:    addps %xmm11, %xmm3
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    movaps %xmm7, %xmm1
; SSE-NEXT:    movaps %xmm5, %xmm2
; SSE-NEXT:    movaps %xmm8, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: hadd_reverse_v16f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[2,3],ymm2[2,3]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vshufps {{.*#+}} ymm2 = ymm4[3,1],ymm0[3,1],ymm4[7,5],ymm0[7,5]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[2,3],ymm3[2,3]
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm3
; AVX1-NEXT:    vshufps {{.*#+}} ymm6 = ymm5[3,1],ymm3[3,1],ymm5[7,5],ymm3[7,5]
; AVX1-NEXT:    vshufps {{.*#+}} ymm0 = ymm4[2,0],ymm0[2,0],ymm4[6,4],ymm0[6,4]
; AVX1-NEXT:    vaddps %ymm0, %ymm2, %ymm1
; AVX1-NEXT:    vshufps {{.*#+}} ymm0 = ymm5[2,0],ymm3[2,0],ymm5[6,4],ymm3[6,4]
; AVX1-NEXT:    vaddps %ymm0, %ymm6, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: hadd_reverse_v16f32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vshufps {{.*#+}} ymm4 = ymm0[3,1],ymm2[3,1],ymm0[7,5],ymm2[7,5]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm4[2,0,3,1]
; AVX2-NEXT:    vshufps {{.*#+}} ymm5 = ymm1[3,1],ymm3[3,1],ymm1[7,5],ymm3[7,5]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[2,0,3,1]
; AVX2-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[2,0],ymm2[2,0],ymm0[6,4],ymm2[6,4]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,0,3,1]
; AVX2-NEXT:    vaddps %ymm0, %ymm4, %ymm2
; AVX2-NEXT:    vshufps {{.*#+}} ymm0 = ymm1[2,0],ymm3[2,0],ymm1[6,4],ymm3[6,4]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,0,3,1]
; AVX2-NEXT:    vaddps %ymm0, %ymm5, %ymm0
; AVX2-NEXT:    vmovaps %ymm2, %ymm1
; AVX2-NEXT:    retq
  %lhs = shufflevector <16 x float> %a0, <16 x float> %a1, <16 x i32> <i32 15, i32 13, i32 11, i32 9, i32 31, i32 29, i32 27, i32 25, i32 7, i32 5, i32 3, i32 1, i32 23, i32 21, i32 19, i32 17>
  %rhs = shufflevector <16 x float> %a0, <16 x float> %a1, <16 x i32> <i32 14, i32 12, i32 10, i32 8, i32 30, i32 28, i32 26, i32 24, i32 6, i32 4, i32 2, i32 0, i32 22, i32 20, i32 18, i32 16>
  %fadd = fadd <16 x float> %lhs, %rhs
  ret <16 x float> %fadd
}

define <16 x float> @hadd_reverse2_v16f32(<16 x float> %a0, <16 x float> %a1) nounwind {
; SSE-LABEL: hadd_reverse2_v16f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm8
; SSE-NEXT:    movaps %xmm0, %xmm9
; SSE-NEXT:    shufps {{.*#+}} xmm9 = xmm9[3,2],xmm0[1,0]
; SSE-NEXT:    shufps {{.*#+}} xmm8 = xmm8[3,2],xmm1[1,0]
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[3,2,1,0]
; SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[3,2,1,0]
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[3,2,1,0]
; SSE-NEXT:    haddps %xmm4, %xmm9
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[3,2,1,0]
; SSE-NEXT:    haddps %xmm5, %xmm8
; SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[3,2,1,0]
; SSE-NEXT:    haddps %xmm6, %xmm2
; SSE-NEXT:    shufps {{.*#+}} xmm7 = xmm7[3,2,1,0]
; SSE-NEXT:    haddps %xmm7, %xmm3
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    movaps %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm8, %xmm2
; SSE-NEXT:    movaps %xmm9, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: hadd_reverse2_v16f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[3,2,1,0,7,6,5,4]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX1-NEXT:    vpermilps {{.*#+}} ymm1 = ymm1[3,2,1,0,7,6,5,4]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm1[2,3,0,1]
; AVX1-NEXT:    vpermilps {{.*#+}} ymm1 = ymm2[3,2,1,0,7,6,5,4]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3,0,1]
; AVX1-NEXT:    vhaddps %ymm1, %ymm0, %ymm1
; AVX1-NEXT:    vpermilps {{.*#+}} ymm0 = ymm3[3,2,1,0,7,6,5,4]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX1-NEXT:    vhaddps %ymm0, %ymm4, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: hadd_reverse2_v16f32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[3,2,1,0,7,6,5,4]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm1 = ymm1[3,2,1,0,7,6,5,4]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm1[2,3,0,1]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm1 = ymm2[3,2,1,0,7,6,5,4]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[2,3,0,1]
; AVX2-NEXT:    vhaddps %ymm1, %ymm0, %ymm1
; AVX2-NEXT:    vpermilps {{.*#+}} ymm0 = ymm3[3,2,1,0,7,6,5,4]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-NEXT:    vhaddps %ymm0, %ymm4, %ymm0
; AVX2-NEXT:    retq
  %shuf0 = shufflevector <16 x float> %a0, <16 x float> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %shuf1 = shufflevector <16 x float> %a1, <16 x float> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %lhs = shufflevector <16 x float> %shuf0, <16 x float> %shuf1, <16 x i32> <i32 0, i32 2, i32 16, i32 18, i32 4, i32 6, i32 20, i32 22, i32 8, i32 10, i32 24, i32 26, i32 12, i32 14, i32 28, i32 30>
  %rhs = shufflevector <16 x float> %shuf0, <16 x float> %shuf1, <16 x i32> <i32 1, i32 3, i32 17, i32 19, i32 5, i32 7, i32 21, i32 23, i32 9, i32 11, i32 25, i32 27, i32 13, i32 15, i32 29, i32 31>
  %fadd = fadd <16 x float> %lhs, %rhs
  ret <16 x float> %fadd
}
