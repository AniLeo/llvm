; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @load_i32_stride2_vf2(<4 x i32>* %in.vec, <2 x i32>* %out.vec0, <2 x i32>* %out.vec1) nounwind {
; SSE-LABEL: load_i32_stride2_vf2:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[0,2,2,3]
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE-NEXT:    movq %xmm1, (%rsi)
; SSE-NEXT:    movq %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: load_i32_stride2_vf2:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,2,2,3]
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; AVX-NEXT:    vmovlps %xmm1, (%rsi)
; AVX-NEXT:    vmovlps %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: load_i32_stride2_vf2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovaps (%rdi), %xmm0
; AVX512-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,2,2,3]
; AVX512-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; AVX512-NEXT:    vmovlps %xmm1, (%rsi)
; AVX512-NEXT:    vmovlps %xmm0, (%rdx)
; AVX512-NEXT:    retq
  %wide.vec = load <4 x i32>, <4 x i32>* %in.vec, align 32

  %strided.vec0 = shufflevector <4 x i32> %wide.vec, <4 x i32> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec1 = shufflevector <4 x i32> %wide.vec, <4 x i32> poison, <2 x i32> <i32 1, i32 3>

  store <2 x i32> %strided.vec0, <2 x i32>* %out.vec0, align 32
  store <2 x i32> %strided.vec1, <2 x i32>* %out.vec1, align 32

  ret void
}

define void @load_i32_stride2_vf4(<8 x i32>* %in.vec, <4 x i32>* %out.vec0, <4 x i32>* %out.vec1) nounwind {
; SSE-LABEL: load_i32_stride2_vf4:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,2],xmm1[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; SSE-NEXT:    movaps %xmm2, (%rsi)
; SSE-NEXT:    movaps %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: load_i32_stride2_vf4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vmovaps 16(%rdi), %xmm1
; AVX-NEXT:    vshufps {{.*#+}} xmm2 = xmm0[0,2],xmm1[0,2]
; AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; AVX-NEXT:    vmovaps %xmm2, (%rsi)
; AVX-NEXT:    vmovaps %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: load_i32_stride2_vf4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512-NEXT:    vmovaps (%rdi), %xmm1
; AVX512-NEXT:    vshufps {{.*#+}} xmm1 = xmm1[1,3],mem[1,3]
; AVX512-NEXT:    vpmovqd %ymm0, (%rsi)
; AVX512-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %wide.vec = load <8 x i32>, <8 x i32>* %in.vec, align 32

  %strided.vec0 = shufflevector <8 x i32> %wide.vec, <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %strided.vec1 = shufflevector <8 x i32> %wide.vec, <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>

  store <4 x i32> %strided.vec0, <4 x i32>* %out.vec0, align 32
  store <4 x i32> %strided.vec1, <4 x i32>* %out.vec1, align 32

  ret void
}

define void @load_i32_stride2_vf8(<16 x i32>* %in.vec, <8 x i32>* %out.vec0, <8 x i32>* %out.vec1) nounwind {
; SSE-LABEL: load_i32_stride2_vf8:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps 32(%rdi), %xmm2
; SSE-NEXT:    movaps 48(%rdi), %xmm3
; SSE-NEXT:    movaps %xmm2, %xmm4
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[0,2],xmm3[0,2]
; SSE-NEXT:    movaps %xmm0, %xmm5
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[0,2],xmm1[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,3],xmm3[1,3]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; SSE-NEXT:    movaps %xmm5, (%rsi)
; SSE-NEXT:    movaps %xmm4, 16(%rsi)
; SSE-NEXT:    movaps %xmm0, (%rdx)
; SSE-NEXT:    movaps %xmm2, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: load_i32_stride2_vf8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm0[2,3],mem[2,3]
; AVX1-NEXT:    vinsertf128 $1, 32(%rdi), %ymm0, %ymm0
; AVX1-NEXT:    vshufps {{.*#+}} ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
; AVX1-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
; AVX1-NEXT:    vmovaps %ymm2, (%rsi)
; AVX1-NEXT:    vmovaps %ymm0, (%rdx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: load_i32_stride2_vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm1
; AVX2-NEXT:    vshufps {{.*#+}} ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vmovaps %ymm2, (%rsi)
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: load_i32_stride2_vf8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovaps (%rdi), %ymm1
; AVX512-NEXT:    vshufps {{.*#+}} ymm1 = ymm1[1,3],mem[1,3],ymm1[5,7],mem[5,7]
; AVX512-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,2,1,3]
; AVX512-NEXT:    vpmovqd %zmm0, (%rsi)
; AVX512-NEXT:    vmovaps %ymm1, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %wide.vec = load <16 x i32>, <16 x i32>* %in.vec, align 32

  %strided.vec0 = shufflevector <16 x i32> %wide.vec, <16 x i32> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %strided.vec1 = shufflevector <16 x i32> %wide.vec, <16 x i32> poison, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>

  store <8 x i32> %strided.vec0, <8 x i32>* %out.vec0, align 32
  store <8 x i32> %strided.vec1, <8 x i32>* %out.vec1, align 32

  ret void
}

define void @load_i32_stride2_vf16(<32 x i32>* %in.vec, <16 x i32>* %out.vec0, <16 x i32>* %out.vec1) nounwind {
; SSE-LABEL: load_i32_stride2_vf16:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm6
; SSE-NEXT:    movaps 16(%rdi), %xmm8
; SSE-NEXT:    movaps 32(%rdi), %xmm4
; SSE-NEXT:    movaps 48(%rdi), %xmm9
; SSE-NEXT:    movaps 80(%rdi), %xmm10
; SSE-NEXT:    movaps 64(%rdi), %xmm5
; SSE-NEXT:    movaps 112(%rdi), %xmm11
; SSE-NEXT:    movaps 96(%rdi), %xmm7
; SSE-NEXT:    movaps %xmm7, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm11[0,2]
; SSE-NEXT:    movaps %xmm5, %xmm3
; SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[0,2],xmm10[0,2]
; SSE-NEXT:    movaps %xmm4, %xmm2
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,2],xmm9[0,2]
; SSE-NEXT:    movaps %xmm6, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm8[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm7 = xmm7[1,3],xmm11[1,3]
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[1,3],xmm10[1,3]
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[1,3],xmm9[1,3]
; SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[1,3],xmm8[1,3]
; SSE-NEXT:    movaps %xmm3, 32(%rsi)
; SSE-NEXT:    movaps %xmm0, (%rsi)
; SSE-NEXT:    movaps %xmm1, 48(%rsi)
; SSE-NEXT:    movaps %xmm2, 16(%rsi)
; SSE-NEXT:    movaps %xmm5, 32(%rdx)
; SSE-NEXT:    movaps %xmm6, (%rdx)
; SSE-NEXT:    movaps %xmm7, 48(%rdx)
; SSE-NEXT:    movaps %xmm4, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: load_i32_stride2_vf16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vmovaps 64(%rdi), %ymm1
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm2 = ymm0[2,3],mem[2,3]
; AVX1-NEXT:    vinsertf128 $1, 32(%rdi), %ymm0, %ymm0
; AVX1-NEXT:    vshufps {{.*#+}} ymm3 = ymm0[0,2],ymm2[0,2],ymm0[4,6],ymm2[4,6]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm1[2,3],mem[2,3]
; AVX1-NEXT:    vinsertf128 $1, 96(%rdi), %ymm1, %ymm1
; AVX1-NEXT:    vshufps {{.*#+}} ymm5 = ymm1[0,2],ymm4[0,2],ymm1[4,6],ymm4[4,6]
; AVX1-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],ymm2[1,3],ymm0[5,7],ymm2[5,7]
; AVX1-NEXT:    vshufps {{.*#+}} ymm1 = ymm1[1,3],ymm4[1,3],ymm1[5,7],ymm4[5,7]
; AVX1-NEXT:    vmovaps %ymm5, 32(%rsi)
; AVX1-NEXT:    vmovaps %ymm3, (%rsi)
; AVX1-NEXT:    vmovaps %ymm1, 32(%rdx)
; AVX1-NEXT:    vmovaps %ymm0, (%rdx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: load_i32_stride2_vf16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm1
; AVX2-NEXT:    vmovaps 64(%rdi), %ymm2
; AVX2-NEXT:    vmovaps 96(%rdi), %ymm3
; AVX2-NEXT:    vshufps {{.*#+}} ymm4 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm4[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm5 = ymm2[0,2],ymm3[0,2],ymm2[4,6],ymm3[4,6]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm1 = ymm2[1,3],ymm3[1,3],ymm2[5,7],ymm3[5,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,2,1,3]
; AVX2-NEXT:    vmovaps %ymm5, 32(%rsi)
; AVX2-NEXT:    vmovaps %ymm4, (%rsi)
; AVX2-NEXT:    vmovaps %ymm1, 32(%rdx)
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: load_i32_stride2_vf16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 64(%rdi), %zmm1
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30]
; AVX512-NEXT:    vpermi2d %zmm1, %zmm0, %zmm2
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31]
; AVX512-NEXT:    vpermi2d %zmm1, %zmm0, %zmm3
; AVX512-NEXT:    vmovdqu64 %zmm2, (%rsi)
; AVX512-NEXT:    vmovdqu64 %zmm3, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %wide.vec = load <32 x i32>, <32 x i32>* %in.vec, align 32

  %strided.vec0 = shufflevector <32 x i32> %wide.vec, <32 x i32> poison, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %strided.vec1 = shufflevector <32 x i32> %wide.vec, <32 x i32> poison, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>

  store <16 x i32> %strided.vec0, <16 x i32>* %out.vec0, align 32
  store <16 x i32> %strided.vec1, <16 x i32>* %out.vec1, align 32

  ret void
}

define void @load_i32_stride2_vf32(<64 x i32>* %in.vec, <32 x i32>* %out.vec0, <32 x i32>* %out.vec1) nounwind {
; SSE-LABEL: load_i32_stride2_vf32:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm9
; SSE-NEXT:    movaps 32(%rdi), %xmm14
; SSE-NEXT:    movaps 48(%rdi), %xmm8
; SSE-NEXT:    movaps 208(%rdi), %xmm10
; SSE-NEXT:    movaps 192(%rdi), %xmm2
; SSE-NEXT:    movaps 144(%rdi), %xmm11
; SSE-NEXT:    movaps 128(%rdi), %xmm3
; SSE-NEXT:    movaps 80(%rdi), %xmm12
; SSE-NEXT:    movaps 64(%rdi), %xmm6
; SSE-NEXT:    movaps 240(%rdi), %xmm13
; SSE-NEXT:    movaps 224(%rdi), %xmm4
; SSE-NEXT:    movaps 176(%rdi), %xmm15
; SSE-NEXT:    movaps 160(%rdi), %xmm5
; SSE-NEXT:    movaps 112(%rdi), %xmm1
; SSE-NEXT:    movaps 96(%rdi), %xmm7
; SSE-NEXT:    movaps %xmm7, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm7 = xmm7[1,3],xmm1[1,3]
; SSE-NEXT:    movaps %xmm5, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm15[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[1,3],xmm15[1,3]
; SSE-NEXT:    movaps %xmm4, %xmm15
; SSE-NEXT:    shufps {{.*#+}} xmm15 = xmm15[0,2],xmm13[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[1,3],xmm13[1,3]
; SSE-NEXT:    movaps %xmm2, %xmm13
; SSE-NEXT:    shufps {{.*#+}} xmm13 = xmm13[0,2],xmm10[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,3],xmm10[1,3]
; SSE-NEXT:    movaps %xmm3, %xmm10
; SSE-NEXT:    shufps {{.*#+}} xmm10 = xmm10[0,2],xmm11[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[1,3],xmm11[1,3]
; SSE-NEXT:    movaps %xmm6, %xmm11
; SSE-NEXT:    shufps {{.*#+}} xmm11 = xmm11[0,2],xmm12[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[1,3],xmm12[1,3]
; SSE-NEXT:    movaps %xmm14, %xmm12
; SSE-NEXT:    shufps {{.*#+}} xmm12 = xmm12[0,2],xmm8[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm14 = xmm14[1,3],xmm8[1,3]
; SSE-NEXT:    movaps %xmm14, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movaps 16(%rdi), %xmm8
; SSE-NEXT:    movaps %xmm9, %xmm14
; SSE-NEXT:    shufps {{.*#+}} xmm14 = xmm14[0,2],xmm8[0,2]
; SSE-NEXT:    shufps {{.*#+}} xmm9 = xmm9[1,3],xmm8[1,3]
; SSE-NEXT:    movaps %xmm13, 96(%rsi)
; SSE-NEXT:    movaps %xmm10, 64(%rsi)
; SSE-NEXT:    movaps %xmm11, 32(%rsi)
; SSE-NEXT:    movaps %xmm14, (%rsi)
; SSE-NEXT:    movaps %xmm15, 112(%rsi)
; SSE-NEXT:    movaps %xmm1, 80(%rsi)
; SSE-NEXT:    movaps %xmm0, 48(%rsi)
; SSE-NEXT:    movaps %xmm12, 16(%rsi)
; SSE-NEXT:    movaps %xmm9, (%rdx)
; SSE-NEXT:    movaps %xmm6, 32(%rdx)
; SSE-NEXT:    movaps %xmm3, 64(%rdx)
; SSE-NEXT:    movaps %xmm2, 96(%rdx)
; SSE-NEXT:    movaps %xmm4, 112(%rdx)
; SSE-NEXT:    movaps %xmm5, 80(%rdx)
; SSE-NEXT:    movaps %xmm7, 48(%rdx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: load_i32_stride2_vf32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vmovaps 64(%rdi), %ymm1
; AVX1-NEXT:    vmovaps 128(%rdi), %ymm2
; AVX1-NEXT:    vmovaps 192(%rdi), %ymm3
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm2[2,3],mem[2,3]
; AVX1-NEXT:    vinsertf128 $1, 160(%rdi), %ymm2, %ymm2
; AVX1-NEXT:    vshufps {{.*#+}} ymm5 = ymm2[0,2],ymm4[0,2],ymm2[4,6],ymm4[4,6]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm6 = ymm1[2,3],mem[2,3]
; AVX1-NEXT:    vinsertf128 $1, 96(%rdi), %ymm1, %ymm1
; AVX1-NEXT:    vshufps {{.*#+}} ymm7 = ymm1[0,2],ymm6[0,2],ymm1[4,6],ymm6[4,6]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm8 = ymm0[2,3],mem[2,3]
; AVX1-NEXT:    vinsertf128 $1, 32(%rdi), %ymm0, %ymm0
; AVX1-NEXT:    vshufps {{.*#+}} ymm9 = ymm0[0,2],ymm8[0,2],ymm0[4,6],ymm8[4,6]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm10 = ymm3[2,3],mem[2,3]
; AVX1-NEXT:    vinsertf128 $1, 224(%rdi), %ymm3, %ymm3
; AVX1-NEXT:    vshufps {{.*#+}} ymm11 = ymm3[0,2],ymm10[0,2],ymm3[4,6],ymm10[4,6]
; AVX1-NEXT:    vshufps {{.*#+}} ymm1 = ymm1[1,3],ymm6[1,3],ymm1[5,7],ymm6[5,7]
; AVX1-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],ymm8[1,3],ymm0[5,7],ymm8[5,7]
; AVX1-NEXT:    vshufps {{.*#+}} ymm3 = ymm3[1,3],ymm10[1,3],ymm3[5,7],ymm10[5,7]
; AVX1-NEXT:    vshufps {{.*#+}} ymm2 = ymm2[1,3],ymm4[1,3],ymm2[5,7],ymm4[5,7]
; AVX1-NEXT:    vmovaps %ymm11, 96(%rsi)
; AVX1-NEXT:    vmovaps %ymm9, (%rsi)
; AVX1-NEXT:    vmovaps %ymm7, 32(%rsi)
; AVX1-NEXT:    vmovaps %ymm5, 64(%rsi)
; AVX1-NEXT:    vmovaps %ymm2, 64(%rdx)
; AVX1-NEXT:    vmovaps %ymm3, 96(%rdx)
; AVX1-NEXT:    vmovaps %ymm0, (%rdx)
; AVX1-NEXT:    vmovaps %ymm1, 32(%rdx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: load_i32_stride2_vf32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm1
; AVX2-NEXT:    vmovaps 64(%rdi), %ymm2
; AVX2-NEXT:    vmovaps 96(%rdi), %ymm3
; AVX2-NEXT:    vmovaps 224(%rdi), %ymm4
; AVX2-NEXT:    vmovaps 192(%rdi), %ymm5
; AVX2-NEXT:    vmovaps 160(%rdi), %ymm6
; AVX2-NEXT:    vmovaps 128(%rdi), %ymm7
; AVX2-NEXT:    vshufps {{.*#+}} ymm8 = ymm7[0,2],ymm6[0,2],ymm7[4,6],ymm6[4,6]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm8 = ymm8[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm9 = ymm5[0,2],ymm4[0,2],ymm5[4,6],ymm4[4,6]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm9 = ymm9[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm10 = ymm2[0,2],ymm3[0,2],ymm2[4,6],ymm3[4,6]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm10 = ymm10[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm11 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm11 = ymm11[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm4 = ymm5[1,3],ymm4[1,3],ymm5[5,7],ymm4[5,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm4[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm5 = ymm7[1,3],ymm6[1,3],ymm7[5,7],ymm6[5,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm2 = ymm2[1,3],ymm3[1,3],ymm2[5,7],ymm3[5,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX2-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vmovaps %ymm9, 96(%rsi)
; AVX2-NEXT:    vmovaps %ymm11, (%rsi)
; AVX2-NEXT:    vmovaps %ymm10, 32(%rsi)
; AVX2-NEXT:    vmovaps %ymm8, 64(%rsi)
; AVX2-NEXT:    vmovaps %ymm5, 64(%rdx)
; AVX2-NEXT:    vmovaps %ymm4, 96(%rdx)
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vmovaps %ymm2, 32(%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: load_i32_stride2_vf32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 64(%rdi), %zmm1
; AVX512-NEXT:    vmovdqu64 128(%rdi), %zmm2
; AVX512-NEXT:    vmovdqu64 192(%rdi), %zmm3
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm4 = [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30]
; AVX512-NEXT:    vmovdqa64 %zmm0, %zmm5
; AVX512-NEXT:    vpermt2d %zmm1, %zmm4, %zmm5
; AVX512-NEXT:    vpermi2d %zmm3, %zmm2, %zmm4
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm6 = [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31]
; AVX512-NEXT:    vpermt2d %zmm1, %zmm6, %zmm0
; AVX512-NEXT:    vpermt2d %zmm3, %zmm6, %zmm2
; AVX512-NEXT:    vmovdqu64 %zmm4, 64(%rsi)
; AVX512-NEXT:    vmovdqu64 %zmm5, (%rsi)
; AVX512-NEXT:    vmovdqu64 %zmm2, 64(%rdx)
; AVX512-NEXT:    vmovdqu64 %zmm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %wide.vec = load <64 x i32>, <64 x i32>* %in.vec, align 32

  %strided.vec0 = shufflevector <64 x i32> %wide.vec, <64 x i32> poison, <32 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30, i32 32, i32 34, i32 36, i32 38, i32 40, i32 42, i32 44, i32 46, i32 48, i32 50, i32 52, i32 54, i32 56, i32 58, i32 60, i32 62>
  %strided.vec1 = shufflevector <64 x i32> %wide.vec, <64 x i32> poison, <32 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31, i32 33, i32 35, i32 37, i32 39, i32 41, i32 43, i32 45, i32 47, i32 49, i32 51, i32 53, i32 55, i32 57, i32 59, i32 61, i32 63>

  store <32 x i32> %strided.vec0, <32 x i32>* %out.vec0, align 32
  store <32 x i32> %strided.vec1, <32 x i32>* %out.vec1, align 32

  ret void
}
