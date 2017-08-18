; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

;
; udiv by 7
;

define <2 x i64> @test_div7_2i64(<2 x i64> %a) nounwind {
; SSE2-LABEL: test_div7_2i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movq %xmm0, %rcx
; SSE2-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; SSE2-NEXT:    movq %rcx, %rax
; SSE2-NEXT:    mulq %rsi
; SSE2-NEXT:    subq %rdx, %rcx
; SSE2-NEXT:    shrq %rcx
; SSE2-NEXT:    addq %rdx, %rcx
; SSE2-NEXT:    shrq $2, %rcx
; SSE2-NEXT:    movq %rcx, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; SSE2-NEXT:    movq %xmm0, %rcx
; SSE2-NEXT:    movq %rcx, %rax
; SSE2-NEXT:    mulq %rsi
; SSE2-NEXT:    subq %rdx, %rcx
; SSE2-NEXT:    shrq %rcx
; SSE2-NEXT:    addq %rdx, %rcx
; SSE2-NEXT:    shrq $2, %rcx
; SSE2-NEXT:    movq %rcx, %xmm0
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_div7_2i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    pextrq $1, %xmm0, %rcx
; SSE41-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; SSE41-NEXT:    movq %rcx, %rax
; SSE41-NEXT:    mulq %rsi
; SSE41-NEXT:    subq %rdx, %rcx
; SSE41-NEXT:    shrq %rcx
; SSE41-NEXT:    addq %rdx, %rcx
; SSE41-NEXT:    shrq $2, %rcx
; SSE41-NEXT:    movq %rcx, %xmm1
; SSE41-NEXT:    movq %xmm0, %rcx
; SSE41-NEXT:    movq %rcx, %rax
; SSE41-NEXT:    mulq %rsi
; SSE41-NEXT:    subq %rdx, %rcx
; SSE41-NEXT:    shrq %rcx
; SSE41-NEXT:    addq %rdx, %rcx
; SSE41-NEXT:    shrq $2, %rcx
; SSE41-NEXT:    movq %rcx, %xmm0
; SSE41-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_div7_2i64:
; AVX:       # BB#0:
; AVX-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    mulq %rsi
; AVX-NEXT:    subq %rdx, %rcx
; AVX-NEXT:    shrq %rcx
; AVX-NEXT:    addq %rdx, %rcx
; AVX-NEXT:    shrq $2, %rcx
; AVX-NEXT:    vmovq %rcx, %xmm1
; AVX-NEXT:    vmovq %xmm0, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    mulq %rsi
; AVX-NEXT:    subq %rdx, %rcx
; AVX-NEXT:    shrq %rcx
; AVX-NEXT:    addq %rdx, %rcx
; AVX-NEXT:    shrq $2, %rcx
; AVX-NEXT:    vmovq %rcx, %xmm0
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    retq
  %res = udiv <2 x i64> %a, <i64 7, i64 7>
  ret <2 x i64> %res
}

define <4 x i32> @test_div7_4i32(<4 x i32> %a) nounwind {
; SSE2-LABEL: test_div7_4i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pmuludq %xmm1, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,3,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE2-NEXT:    psubd %xmm2, %xmm0
; SSE2-NEXT:    psrld $1, %xmm0
; SSE2-NEXT:    paddd %xmm2, %xmm0
; SSE2-NEXT:    psrld $2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_div7_4i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pmuludq %xmm2, %xmm3
; SSE41-NEXT:    pmuludq %xmm0, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE41-NEXT:    psubd %xmm1, %xmm0
; SSE41-NEXT:    psrld $1, %xmm0
; SSE41-NEXT:    paddd %xmm1, %xmm0
; SSE41-NEXT:    psrld $2, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_div7_4i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmuludq %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrld $1, %xmm0, %xmm0
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrld $2, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_div7_4i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; AVX2-NEXT:    vpmuludq %xmm1, %xmm0, %xmm1
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsrld $1, %xmm0, %xmm0
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsrld $2, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %res = udiv <4 x i32> %a, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %res
}

define <8 x i16> @test_div7_8i16(<8 x i16> %a) nounwind {
; SSE-LABEL: test_div7_8i16:
; SSE:       # BB#0:
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [9363,9363,9363,9363,9363,9363,9363,9363]
; SSE-NEXT:    pmulhuw %xmm0, %xmm1
; SSE-NEXT:    psubw %xmm1, %xmm0
; SSE-NEXT:    psrlw $1, %xmm0
; SSE-NEXT:    paddw %xmm1, %xmm0
; SSE-NEXT:    psrlw $2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_div7_8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpmulhuw {{.*}}(%rip), %xmm0, %xmm1
; AVX-NEXT:    vpsubw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrlw $1, %xmm0, %xmm0
; AVX-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrlw $2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = udiv <8 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <8 x i16> %res
}

define <16 x i8> @test_div7_16i8(<16 x i8> %a) nounwind {
; SSE2-LABEL: test_div7_16i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0]
; SSE2-NEXT:    pmullw %xmm3, %xmm2
; SSE2-NEXT:    psrlw $8, %xmm2
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm4 = xmm4[0],xmm1[0],xmm4[1],xmm1[1],xmm4[2],xmm1[2],xmm4[3],xmm1[3],xmm4[4],xmm1[4],xmm4[5],xmm1[5],xmm4[6],xmm1[6],xmm4[7],xmm1[7]
; SSE2-NEXT:    pmullw %xmm3, %xmm4
; SSE2-NEXT:    psrlw $8, %xmm4
; SSE2-NEXT:    packuswb %xmm2, %xmm4
; SSE2-NEXT:    psubb %xmm4, %xmm0
; SSE2-NEXT:    psrlw $1, %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    paddb %xmm4, %xmm0
; SSE2-NEXT:    psrlw $2, %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_div7_16i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [37,37,37,37,37,37,37,37]
; SSE41-NEXT:    pmullw %xmm2, %xmm1
; SSE41-NEXT:    psrlw $8, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[2,3,0,1]
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
; SSE41-NEXT:    pmullw %xmm2, %xmm3
; SSE41-NEXT:    psrlw $8, %xmm3
; SSE41-NEXT:    packuswb %xmm3, %xmm1
; SSE41-NEXT:    psubb %xmm1, %xmm0
; SSE41-NEXT:    psrlw $1, %xmm0
; SSE41-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE41-NEXT:    paddb %xmm1, %xmm0
; SSE41-NEXT:    psrlw $2, %xmm0
; SSE41-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_div7_16i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [37,37,37,37,37,37,37,37]
; AVX1-NEXT:    vpmullw %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $8, %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[2,3,0,1]
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
; AVX1-NEXT:    vpmullw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsrlw $8, %xmm2, %xmm2
; AVX1-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm0
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm0
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_div7_16i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsrlw $1, %xmm0, %xmm0
; AVX2-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsrlw $2, %xmm0, %xmm0
; AVX2-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %res = udiv <16 x i8> %a, <i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7>
  ret <16 x i8> %res
}

;
; urem by 7
;

define <2 x i64> @test_rem7_2i64(<2 x i64> %a) nounwind {
; SSE2-LABEL: test_rem7_2i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movq %xmm0, %rcx
; SSE2-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; SSE2-NEXT:    movq %rcx, %rax
; SSE2-NEXT:    mulq %rsi
; SSE2-NEXT:    movq %rcx, %rax
; SSE2-NEXT:    subq %rdx, %rax
; SSE2-NEXT:    shrq %rax
; SSE2-NEXT:    addq %rdx, %rax
; SSE2-NEXT:    shrq $2, %rax
; SSE2-NEXT:    leaq (,%rax,8), %rdx
; SSE2-NEXT:    subq %rax, %rdx
; SSE2-NEXT:    subq %rdx, %rcx
; SSE2-NEXT:    movq %rcx, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; SSE2-NEXT:    movq %xmm0, %rcx
; SSE2-NEXT:    movq %rcx, %rax
; SSE2-NEXT:    mulq %rsi
; SSE2-NEXT:    movq %rcx, %rax
; SSE2-NEXT:    subq %rdx, %rax
; SSE2-NEXT:    shrq %rax
; SSE2-NEXT:    addq %rdx, %rax
; SSE2-NEXT:    shrq $2, %rax
; SSE2-NEXT:    leaq (,%rax,8), %rdx
; SSE2-NEXT:    subq %rax, %rdx
; SSE2-NEXT:    subq %rdx, %rcx
; SSE2-NEXT:    movq %rcx, %xmm0
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_rem7_2i64:
; SSE41:       # BB#0:
; SSE41-NEXT:    pextrq $1, %xmm0, %rcx
; SSE41-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; SSE41-NEXT:    movq %rcx, %rax
; SSE41-NEXT:    mulq %rsi
; SSE41-NEXT:    movq %rcx, %rax
; SSE41-NEXT:    subq %rdx, %rax
; SSE41-NEXT:    shrq %rax
; SSE41-NEXT:    addq %rdx, %rax
; SSE41-NEXT:    shrq $2, %rax
; SSE41-NEXT:    leaq (,%rax,8), %rdx
; SSE41-NEXT:    subq %rax, %rdx
; SSE41-NEXT:    subq %rdx, %rcx
; SSE41-NEXT:    movq %rcx, %xmm1
; SSE41-NEXT:    movq %xmm0, %rcx
; SSE41-NEXT:    movq %rcx, %rax
; SSE41-NEXT:    mulq %rsi
; SSE41-NEXT:    movq %rcx, %rax
; SSE41-NEXT:    subq %rdx, %rax
; SSE41-NEXT:    shrq %rax
; SSE41-NEXT:    addq %rdx, %rax
; SSE41-NEXT:    shrq $2, %rax
; SSE41-NEXT:    leaq (,%rax,8), %rdx
; SSE41-NEXT:    subq %rax, %rdx
; SSE41-NEXT:    subq %rdx, %rcx
; SSE41-NEXT:    movq %rcx, %xmm0
; SSE41-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_rem7_2i64:
; AVX:       # BB#0:
; AVX-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    mulq %rsi
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    subq %rdx, %rax
; AVX-NEXT:    shrq %rax
; AVX-NEXT:    addq %rdx, %rax
; AVX-NEXT:    shrq $2, %rax
; AVX-NEXT:    leaq (,%rax,8), %rdx
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    subq %rdx, %rcx
; AVX-NEXT:    vmovq %rcx, %xmm1
; AVX-NEXT:    vmovq %xmm0, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    mulq %rsi
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    subq %rdx, %rax
; AVX-NEXT:    shrq %rax
; AVX-NEXT:    addq %rdx, %rax
; AVX-NEXT:    shrq $2, %rax
; AVX-NEXT:    leaq (,%rax,8), %rdx
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    subq %rdx, %rcx
; AVX-NEXT:    vmovq %rcx, %xmm0
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    retq
  %res = urem <2 x i64> %a, <i64 7, i64 7>
  ret <2 x i64> %res
}

define <4 x i32> @test_rem7_4i32(<4 x i32> %a) nounwind {
; SSE2-LABEL: test_rem7_4i32:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pmuludq %xmm1, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,3,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psubd %xmm2, %xmm1
; SSE2-NEXT:    psrld $1, %xmm1
; SSE2-NEXT:    paddd %xmm2, %xmm1
; SSE2-NEXT:    psrld $2, %xmm1
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [7,7,7,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; SSE2-NEXT:    psubd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_rem7_4i32:
; SSE41:       # BB#0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE41-NEXT:    pmuludq %xmm2, %xmm3
; SSE41-NEXT:    pmuludq %xmm0, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    psubd %xmm1, %xmm2
; SSE41-NEXT:    psrld $1, %xmm2
; SSE41-NEXT:    paddd %xmm1, %xmm2
; SSE41-NEXT:    psrld $2, %xmm2
; SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm2
; SSE41-NEXT:    psubd %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_rem7_4i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmuludq %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vpsrld $1, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpsrld $2, %xmm1, %xmm1
; AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_rem7_4i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [613566757,613566757,613566757,613566757]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; AVX2-NEXT:    vpmuludq %xmm1, %xmm0, %xmm1
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm2
; AVX2-NEXT:    vpsrld $1, %xmm2, %xmm2
; AVX2-NEXT:    vpaddd %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpsrld $2, %xmm1, %xmm1
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [7,7,7,7]
; AVX2-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %res = urem <4 x i32> %a, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %res
}

define <8 x i16> @test_rem7_8i16(<8 x i16> %a) nounwind {
; SSE-LABEL: test_rem7_8i16:
; SSE:       # BB#0:
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [9363,9363,9363,9363,9363,9363,9363,9363]
; SSE-NEXT:    pmulhuw %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psubw %xmm1, %xmm2
; SSE-NEXT:    psrlw $1, %xmm2
; SSE-NEXT:    paddw %xmm1, %xmm2
; SSE-NEXT:    psrlw $2, %xmm2
; SSE-NEXT:    pmullw {{.*}}(%rip), %xmm2
; SSE-NEXT:    psubw %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_rem7_8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpmulhuw {{.*}}(%rip), %xmm0, %xmm1
; AVX-NEXT:    vpsubw %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vpsrlw $1, %xmm2, %xmm2
; AVX-NEXT:    vpaddw %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vpsrlw $2, %xmm1, %xmm1
; AVX-NEXT:    vpmullw {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vpsubw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = urem <8 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <8 x i16> %res
}

define <16 x i8> @test_rem7_16i8(<16 x i8> %a) nounwind {
; SSE2-LABEL: test_rem7_16i8:
; SSE2:       # BB#0:
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0]
; SSE2-NEXT:    pmullw %xmm3, %xmm2
; SSE2-NEXT:    psrlw $8, %xmm2
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm4 = xmm4[0],xmm1[0],xmm4[1],xmm1[1],xmm4[2],xmm1[2],xmm4[3],xmm1[3],xmm4[4],xmm1[4],xmm4[5],xmm1[5],xmm4[6],xmm1[6],xmm4[7],xmm1[7]
; SSE2-NEXT:    pmullw %xmm3, %xmm4
; SSE2-NEXT:    psrlw $8, %xmm4
; SSE2-NEXT:    packuswb %xmm2, %xmm4
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psubb %xmm4, %xmm1
; SSE2-NEXT:    psrlw $1, %xmm1
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm1
; SSE2-NEXT:    paddb %xmm4, %xmm1
; SSE2-NEXT:    psrlw $2, %xmm1
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm1
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE2-NEXT:    psraw $8, %xmm2
; SSE2-NEXT:    movdqa {{.*#+}} xmm3 = [7,7,7,7,7,7,7,7]
; SSE2-NEXT:    pmullw %xmm3, %xmm2
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm4, %xmm2
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm1
; SSE2-NEXT:    pmullw %xmm3, %xmm1
; SSE2-NEXT:    pand %xmm4, %xmm1
; SSE2-NEXT:    packuswb %xmm2, %xmm1
; SSE2-NEXT:    psubb %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_rem7_16i8:
; SSE41:       # BB#0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [37,37,37,37,37,37,37,37]
; SSE41-NEXT:    pmullw %xmm2, %xmm1
; SSE41-NEXT:    psrlw $8, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[2,3,0,1]
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
; SSE41-NEXT:    pmullw %xmm2, %xmm3
; SSE41-NEXT:    psrlw $8, %xmm3
; SSE41-NEXT:    packuswb %xmm3, %xmm1
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    psubb %xmm1, %xmm2
; SSE41-NEXT:    psrlw $1, %xmm2
; SSE41-NEXT:    pand {{.*}}(%rip), %xmm2
; SSE41-NEXT:    paddb %xmm1, %xmm2
; SSE41-NEXT:    psrlw $2, %xmm2
; SSE41-NEXT:    pand {{.*}}(%rip), %xmm2
; SSE41-NEXT:    pmovsxbw %xmm2, %xmm1
; SSE41-NEXT:    movdqa {{.*#+}} xmm3 = [7,7,7,7,7,7,7,7]
; SSE41-NEXT:    pmullw %xmm3, %xmm1
; SSE41-NEXT:    movdqa {{.*#+}} xmm4 = [255,255,255,255,255,255,255,255]
; SSE41-NEXT:    pand %xmm4, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; SSE41-NEXT:    pmovsxbw %xmm2, %xmm2
; SSE41-NEXT:    pmullw %xmm3, %xmm2
; SSE41-NEXT:    pand %xmm4, %xmm2
; SSE41-NEXT:    packuswb %xmm2, %xmm1
; SSE41-NEXT:    psubb %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_rem7_16i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [37,37,37,37,37,37,37,37]
; AVX1-NEXT:    vpmullw %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $8, %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[2,3,0,1]
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
; AVX1-NEXT:    vpmullw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsrlw $8, %xmm2, %xmm2
; AVX1-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsubb %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vpsrlw $1, %xmm2, %xmm2
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vpaddb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpsrlw $2, %xmm1, %xmm1
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpmovsxbw %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [7,7,7,7,7,7,7,7]
; AVX1-NEXT:    vpmullw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [255,255,255,255,255,255,255,255]
; AVX1-NEXT:    vpand %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,3,0,1]
; AVX1-NEXT:    vpmovsxbw %xmm1, %xmm1
; AVX1-NEXT:    vpmullw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm4, %xmm1, %xmm1
; AVX1-NEXT:    vpackuswb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_rem7_16i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsubb %xmm1, %xmm0, %xmm2
; AVX2-NEXT:    vpsrlw $1, %xmm2, %xmm2
; AVX2-NEXT:    vpand {{.*}}(%rip), %xmm2, %xmm2
; AVX2-NEXT:    vpaddb %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpsrlw $2, %xmm1, %xmm1
; AVX2-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpmovsxbw %xmm1, %ymm1
; AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm3 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX2-NEXT:    vpshufb %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX2-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %res = urem <16 x i8> %a, <i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7>
  ret <16 x i8> %res
}
