; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @store_i64_stride4_vf2(<2 x i64>* %in.vecptr0, <2 x i64>* %in.vecptr1, <2 x i64>* %in.vecptr2, <2 x i64>* %in.vecptr3, <8 x i64>* %out.vec) nounwind {
; SSE-LABEL: store_i64_stride4_vf2:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps (%rsi), %xmm1
; SSE-NEXT:    movaps (%rdx), %xmm2
; SSE-NEXT:    movaps (%rcx), %xmm3
; SSE-NEXT:    movaps %xmm0, %xmm4
; SSE-NEXT:    movlhps {{.*#+}} xmm4 = xmm4[0],xmm1[0]
; SSE-NEXT:    movaps %xmm2, %xmm5
; SSE-NEXT:    movlhps {{.*#+}} xmm5 = xmm5[0],xmm3[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm3[1]
; SSE-NEXT:    movaps %xmm2, 48(%r8)
; SSE-NEXT:    movaps %xmm0, 32(%r8)
; SSE-NEXT:    movaps %xmm5, 16(%r8)
; SSE-NEXT:    movaps %xmm4, (%r8)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride4_vf2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rdi), %xmm0
; AVX1-NEXT:    vmovaps (%rsi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, (%rcx), %ymm1, %ymm1
; AVX1-NEXT:    vinsertf128 $1, (%rdx), %ymm0, %ymm0
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX1-NEXT:    vmovaps %ymm0, 32(%r8)
; AVX1-NEXT:    vmovaps %ymm2, (%r8)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride4_vf2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vmovaps (%rdx), %xmm1
; AVX2-NEXT:    vinsertf128 $1, (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vinsertf128 $1, (%rcx), %ymm1, %ymm1
; AVX2-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vmovaps %ymm0, 32(%r8)
; AVX2-NEXT:    vmovaps %ymm2, (%r8)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride4_vf2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovaps (%rdi), %xmm0
; AVX512-NEXT:    vmovaps (%rdx), %xmm1
; AVX512-NEXT:    vinsertf128 $1, (%rcx), %ymm1, %ymm1
; AVX512-NEXT:    vinsertf128 $1, (%rsi), %ymm0, %ymm0
; AVX512-NEXT:    vinsertf64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovaps {{.*#+}} zmm1 = [0,2,4,6,1,3,5,7]
; AVX512-NEXT:    vpermpd %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    vmovups %zmm0, (%r8)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <2 x i64>, <2 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <2 x i64>, <2 x i64>* %in.vecptr1, align 32
  %in.vec2 = load <2 x i64>, <2 x i64>* %in.vecptr2, align 32
  %in.vec3 = load <2 x i64>, <2 x i64>* %in.vecptr3, align 32

  %concat01 = shufflevector <2 x i64> %in.vec0, <2 x i64> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat23 = shufflevector <2 x i64> %in.vec2, <2 x i64> %in.vec3, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat0123 = shufflevector <4 x i64> %concat01, <4 x i64> %concat23, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i64> %concat0123, <8 x i64> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 1, i32 3, i32 5, i32 7>

  store <8 x i64> %interleaved.vec, <8 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride4_vf4(<4 x i64>* %in.vecptr0, <4 x i64>* %in.vecptr1, <4 x i64>* %in.vecptr2, <4 x i64>* %in.vecptr3, <16 x i64>* %out.vec) nounwind {
; SSE-LABEL: store_i64_stride4_vf4:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps (%rsi), %xmm2
; SSE-NEXT:    movaps 16(%rsi), %xmm8
; SSE-NEXT:    movaps (%rdx), %xmm4
; SSE-NEXT:    movaps 16(%rdx), %xmm5
; SSE-NEXT:    movaps (%rcx), %xmm6
; SSE-NEXT:    movaps 16(%rcx), %xmm9
; SSE-NEXT:    movaps %xmm4, %xmm3
; SSE-NEXT:    movlhps {{.*#+}} xmm3 = xmm3[0],xmm6[0]
; SSE-NEXT:    movaps %xmm0, %xmm7
; SSE-NEXT:    movlhps {{.*#+}} xmm7 = xmm7[0],xmm2[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm4 = xmm4[1],xmm6[1]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm2[1]
; SSE-NEXT:    movaps %xmm5, %xmm2
; SSE-NEXT:    movlhps {{.*#+}} xmm2 = xmm2[0],xmm9[0]
; SSE-NEXT:    movaps %xmm1, %xmm6
; SSE-NEXT:    movlhps {{.*#+}} xmm6 = xmm6[0],xmm8[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm5 = xmm5[1],xmm9[1]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm8[1]
; SSE-NEXT:    movaps %xmm1, 96(%r8)
; SSE-NEXT:    movaps %xmm5, 112(%r8)
; SSE-NEXT:    movaps %xmm6, 64(%r8)
; SSE-NEXT:    movaps %xmm2, 80(%r8)
; SSE-NEXT:    movaps %xmm0, 32(%r8)
; SSE-NEXT:    movaps %xmm4, 48(%r8)
; SSE-NEXT:    movaps %xmm7, (%r8)
; SSE-NEXT:    movaps %xmm3, 16(%r8)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i64_stride4_vf4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %ymm0
; AVX-NEXT:    vmovaps (%rsi), %ymm1
; AVX-NEXT:    vmovaps (%rdx), %ymm2
; AVX-NEXT:    vmovaps (%rcx), %ymm3
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX-NEXT:    vmovaps %ymm0, 96(%r8)
; AVX-NEXT:    vmovaps %ymm3, 64(%r8)
; AVX-NEXT:    vmovaps %ymm4, 32(%r8)
; AVX-NEXT:    vmovaps %ymm2, (%r8)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride4_vf4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512-NEXT:    vmovdqa (%rsi), %ymm1
; AVX512-NEXT:    vmovdqa (%rdx), %ymm2
; AVX512-NEXT:    vmovdqa (%rcx), %ymm3
; AVX512-NEXT:    vperm2i128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX512-NEXT:    vperm2i128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX512-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX512-NEXT:    vperm2i128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX512-NEXT:    vpunpcklqdq {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX512-NEXT:    vpunpcklqdq {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX512-NEXT:    vpunpckhqdq {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX512-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX512-NEXT:    vinserti64x4 $1, %ymm4, %zmm2, %zmm1
; AVX512-NEXT:    vinserti64x4 $1, %ymm0, %zmm3, %zmm0
; AVX512-NEXT:    vmovdqu64 %zmm0, 64(%r8)
; AVX512-NEXT:    vmovdqu64 %zmm1, (%r8)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <4 x i64>, <4 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <4 x i64>, <4 x i64>* %in.vecptr1, align 32
  %in.vec2 = load <4 x i64>, <4 x i64>* %in.vecptr2, align 32
  %in.vec3 = load <4 x i64>, <4 x i64>* %in.vecptr3, align 32

  %concat01 = shufflevector <4 x i64> %in.vec0, <4 x i64> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %concat23 = shufflevector <4 x i64> %in.vec2, <4 x i64> %in.vec3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %concat0123 = shufflevector <8 x i64> %concat01, <8 x i64> %concat23, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i64> %concat0123, <16 x i64> poison, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>

  store <16 x i64> %interleaved.vec, <16 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride4_vf8(<8 x i64>* %in.vecptr0, <8 x i64>* %in.vecptr1, <8 x i64>* %in.vecptr2, <8 x i64>* %in.vecptr3, <32 x i64>* %out.vec) nounwind {
; SSE-LABEL: store_i64_stride4_vf8:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm8
; SSE-NEXT:    movaps 16(%rdi), %xmm13
; SSE-NEXT:    movaps 32(%rdi), %xmm9
; SSE-NEXT:    movaps 48(%rdi), %xmm0
; SSE-NEXT:    movaps (%rsi), %xmm6
; SSE-NEXT:    movaps 16(%rsi), %xmm12
; SSE-NEXT:    movaps 32(%rsi), %xmm1
; SSE-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movaps (%rdx), %xmm14
; SSE-NEXT:    movaps 16(%rdx), %xmm4
; SSE-NEXT:    movaps 32(%rdx), %xmm7
; SSE-NEXT:    movaps 48(%rdx), %xmm5
; SSE-NEXT:    movaps (%rcx), %xmm1
; SSE-NEXT:    movaps 16(%rcx), %xmm2
; SSE-NEXT:    movaps 32(%rcx), %xmm15
; SSE-NEXT:    movaps 48(%rcx), %xmm11
; SSE-NEXT:    movaps %xmm14, %xmm3
; SSE-NEXT:    movlhps {{.*#+}} xmm3 = xmm3[0],xmm1[0]
; SSE-NEXT:    movaps %xmm3, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    unpckhpd {{.*#+}} xmm14 = xmm14[1],xmm1[1]
; SSE-NEXT:    movaps %xmm8, %xmm3
; SSE-NEXT:    movaps %xmm8, %xmm10
; SSE-NEXT:    movlhps {{.*#+}} xmm10 = xmm10[0],xmm6[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1],xmm6[1]
; SSE-NEXT:    movaps %xmm4, %xmm8
; SSE-NEXT:    movlhps {{.*#+}} xmm8 = xmm8[0],xmm2[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm4 = xmm4[1],xmm2[1]
; SSE-NEXT:    movaps %xmm13, %xmm1
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm12[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm13 = xmm13[1],xmm12[1]
; SSE-NEXT:    movaps %xmm7, %xmm12
; SSE-NEXT:    movlhps {{.*#+}} xmm12 = xmm12[0],xmm15[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm7 = xmm7[1],xmm15[1]
; SSE-NEXT:    movaps %xmm9, %xmm15
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; SSE-NEXT:    movlhps {{.*#+}} xmm15 = xmm15[0],xmm2[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm9 = xmm9[1],xmm2[1]
; SSE-NEXT:    movaps %xmm5, %xmm2
; SSE-NEXT:    movlhps {{.*#+}} xmm2 = xmm2[0],xmm11[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm5 = xmm5[1],xmm11[1]
; SSE-NEXT:    movaps 48(%rsi), %xmm11
; SSE-NEXT:    movaps %xmm0, %xmm6
; SSE-NEXT:    movlhps {{.*#+}} xmm6 = xmm6[0],xmm11[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm11[1]
; SSE-NEXT:    movaps %xmm0, 224(%r8)
; SSE-NEXT:    movaps %xmm5, 240(%r8)
; SSE-NEXT:    movaps %xmm6, 192(%r8)
; SSE-NEXT:    movaps %xmm2, 208(%r8)
; SSE-NEXT:    movaps %xmm9, 160(%r8)
; SSE-NEXT:    movaps %xmm7, 176(%r8)
; SSE-NEXT:    movaps %xmm15, 128(%r8)
; SSE-NEXT:    movaps %xmm12, 144(%r8)
; SSE-NEXT:    movaps %xmm13, 96(%r8)
; SSE-NEXT:    movaps %xmm4, 112(%r8)
; SSE-NEXT:    movaps %xmm1, 64(%r8)
; SSE-NEXT:    movaps %xmm8, 80(%r8)
; SSE-NEXT:    movaps %xmm3, 32(%r8)
; SSE-NEXT:    movaps %xmm14, 48(%r8)
; SSE-NEXT:    movaps %xmm10, (%r8)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 16(%r8)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride4_vf8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps 32(%rdx), %ymm2
; AVX1-NEXT:    vmovaps (%rdx), %ymm3
; AVX1-NEXT:    vmovaps 32(%rcx), %ymm4
; AVX1-NEXT:    vmovaps (%rcx), %ymm5
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm3[0],ymm5[0],ymm3[2],ymm5[2]
; AVX1-NEXT:    vmovaps 16(%rsi), %xmm6
; AVX1-NEXT:    vmovaps 16(%rdi), %xmm7
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm7[0],xmm6[0]
; AVX1-NEXT:    vblendps {{.*#+}} ymm8 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm9 = ymm2[1],ymm4[1],ymm2[3],ymm4[3]
; AVX1-NEXT:    vmovaps 48(%rsi), %xmm0
; AVX1-NEXT:    vmovaps 48(%rdi), %xmm1
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm10 = xmm1[1],xmm0[1]
; AVX1-NEXT:    vblendps {{.*#+}} ymm9 = ymm10[0,1,2,3],ymm9[4,5,6,7]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm2[0],ymm4[0],ymm2[2],ymm4[2]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; AVX1-NEXT:    vblendps {{.*#+}} ymm10 = ymm0[0,1,2,3],ymm2[4,5,6,7]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm1 = ymm3[1],ymm5[1],ymm3[3],ymm5[3]
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm2 = xmm7[1],xmm6[1]
; AVX1-NEXT:    vblendps {{.*#+}} ymm11 = ymm2[0,1,2,3],ymm1[4,5,6,7]
; AVX1-NEXT:    vmovaps 32(%rsi), %xmm2
; AVX1-NEXT:    vmovaps 32(%rdi), %xmm3
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm12 = xmm3[1],xmm2[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm2 = xmm3[0],xmm2[0]
; AVX1-NEXT:    vmovaps (%rsi), %xmm3
; AVX1-NEXT:    vmovaps (%rdi), %xmm5
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm6 = xmm5[1],xmm3[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm3 = xmm5[0],xmm3[0]
; AVX1-NEXT:    vmovaps (%rcx), %xmm5
; AVX1-NEXT:    vmovaps 32(%rcx), %xmm7
; AVX1-NEXT:    vmovaps (%rdx), %xmm0
; AVX1-NEXT:    vmovaps 32(%rdx), %xmm1
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm4 = xmm1[1],xmm7[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm1[0],xmm7[0]
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm7 = xmm0[1],xmm5[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm5[0]
; AVX1-NEXT:    vmovaps %xmm0, 16(%r8)
; AVX1-NEXT:    vmovaps %xmm7, 48(%r8)
; AVX1-NEXT:    vmovaps %xmm1, 144(%r8)
; AVX1-NEXT:    vmovaps %xmm4, 176(%r8)
; AVX1-NEXT:    vmovaps %xmm3, (%r8)
; AVX1-NEXT:    vmovaps %xmm6, 32(%r8)
; AVX1-NEXT:    vmovaps %xmm2, 128(%r8)
; AVX1-NEXT:    vmovaps %xmm12, 160(%r8)
; AVX1-NEXT:    vmovaps %ymm11, 96(%r8)
; AVX1-NEXT:    vmovaps %ymm10, 192(%r8)
; AVX1-NEXT:    vmovaps %ymm9, 224(%r8)
; AVX1-NEXT:    vmovaps %ymm8, 64(%r8)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride4_vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm2
; AVX2-NEXT:    vmovaps (%rdi), %ymm3
; AVX2-NEXT:    vmovaps 32(%rsi), %ymm4
; AVX2-NEXT:    vmovaps (%rsi), %ymm5
; AVX2-NEXT:    vmovaps 32(%rdx), %ymm6
; AVX2-NEXT:    vmovaps (%rdx), %ymm7
; AVX2-NEXT:    vmovaps 32(%rcx), %ymm8
; AVX2-NEXT:    vmovaps (%rcx), %ymm9
; AVX2-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm7[0],ymm9[0],ymm7[2],ymm9[2]
; AVX2-NEXT:    vunpcklpd {{.*#+}} ymm1 = ymm3[0],ymm5[0],ymm3[2],ymm5[2]
; AVX2-NEXT:    vperm2f128 {{.*#+}} ymm11 = ymm1[2,3],ymm0[2,3]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm1 = ymm6[1],ymm8[1],ymm6[3],ymm8[3]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm10 = ymm2[1],ymm4[1],ymm2[3],ymm4[3]
; AVX2-NEXT:    vperm2f128 {{.*#+}} ymm10 = ymm10[2,3],ymm1[2,3]
; AVX2-NEXT:    vunpcklpd {{.*#+}} ymm6 = ymm6[0],ymm8[0],ymm6[2],ymm8[2]
; AVX2-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm2[0],ymm4[0],ymm2[2],ymm4[2]
; AVX2-NEXT:    vperm2f128 {{.*#+}} ymm8 = ymm2[2,3],ymm6[2,3]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm7[1],ymm9[1],ymm7[3],ymm9[3]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm3 = ymm3[1],ymm5[1],ymm3[3],ymm5[3]
; AVX2-NEXT:    vperm2f128 {{.*#+}} ymm9 = ymm3[2,3],ymm4[2,3]
; AVX2-NEXT:    vmovaps (%rsi), %xmm4
; AVX2-NEXT:    vmovaps 32(%rsi), %xmm5
; AVX2-NEXT:    vmovaps (%rdi), %xmm6
; AVX2-NEXT:    vmovaps 32(%rdi), %xmm7
; AVX2-NEXT:    vunpckhpd {{.*#+}} xmm12 = xmm7[1],xmm5[1]
; AVX2-NEXT:    vmovaps (%rcx), %xmm1
; AVX2-NEXT:    vmovaps 32(%rcx), %xmm2
; AVX2-NEXT:    vmovaps (%rdx), %xmm3
; AVX2-NEXT:    vmovaps 32(%rdx), %xmm0
; AVX2-NEXT:    vunpckhpd {{.*#+}} xmm13 = xmm0[1],xmm2[1]
; AVX2-NEXT:    vmovlhps {{.*#+}} xmm5 = xmm7[0],xmm5[0]
; AVX2-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX2-NEXT:    vunpckhpd {{.*#+}} xmm2 = xmm6[1],xmm4[1]
; AVX2-NEXT:    vunpckhpd {{.*#+}} xmm7 = xmm3[1],xmm1[1]
; AVX2-NEXT:    vmovlhps {{.*#+}} xmm4 = xmm6[0],xmm4[0]
; AVX2-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm3[0],xmm1[0]
; AVX2-NEXT:    vmovaps %xmm1, 16(%r8)
; AVX2-NEXT:    vmovaps %xmm4, (%r8)
; AVX2-NEXT:    vmovaps %xmm7, 48(%r8)
; AVX2-NEXT:    vmovaps %xmm2, 32(%r8)
; AVX2-NEXT:    vmovaps %xmm0, 144(%r8)
; AVX2-NEXT:    vmovaps %xmm5, 128(%r8)
; AVX2-NEXT:    vmovaps %xmm13, 176(%r8)
; AVX2-NEXT:    vmovaps %xmm12, 160(%r8)
; AVX2-NEXT:    vmovaps %ymm9, 96(%r8)
; AVX2-NEXT:    vmovaps %ymm8, 192(%r8)
; AVX2-NEXT:    vmovaps %ymm10, 224(%r8)
; AVX2-NEXT:    vmovaps %ymm11, 64(%r8)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride4_vf8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 (%rsi), %zmm1
; AVX512-NEXT:    vmovdqu64 (%rdx), %zmm2
; AVX512-NEXT:    vmovdqu64 (%rcx), %zmm3
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm4 = <u,u,0,8,u,u,1,9>
; AVX512-NEXT:    vpermi2q %zmm3, %zmm2, %zmm4
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm5 = <0,8,u,u,1,9,u,u>
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm5
; AVX512-NEXT:    movb $-52, %al
; AVX512-NEXT:    kmovd %eax, %k1
; AVX512-NEXT:    vmovdqa64 %zmm4, %zmm5 {%k1}
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm4 = <u,u,2,10,u,u,3,11>
; AVX512-NEXT:    vpermi2q %zmm3, %zmm2, %zmm4
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm6 = <2,10,u,u,3,11,u,u>
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm6
; AVX512-NEXT:    vmovdqa64 %zmm4, %zmm6 {%k1}
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm4 = <u,u,4,12,u,u,5,13>
; AVX512-NEXT:    vpermi2q %zmm3, %zmm2, %zmm4
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm7 = <4,12,u,u,5,13,u,u>
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm7
; AVX512-NEXT:    vmovdqa64 %zmm4, %zmm7 {%k1}
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm4 = <u,u,6,14,u,u,7,15>
; AVX512-NEXT:    vpermi2q %zmm3, %zmm2, %zmm4
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm2 = <6,14,u,u,7,15,u,u>
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512-NEXT:    vmovdqa64 %zmm4, %zmm2 {%k1}
; AVX512-NEXT:    vmovdqu64 %zmm2, 192(%r8)
; AVX512-NEXT:    vmovdqu64 %zmm7, 128(%r8)
; AVX512-NEXT:    vmovdqu64 %zmm6, 64(%r8)
; AVX512-NEXT:    vmovdqu64 %zmm5, (%r8)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <8 x i64>, <8 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <8 x i64>, <8 x i64>* %in.vecptr1, align 32
  %in.vec2 = load <8 x i64>, <8 x i64>* %in.vecptr2, align 32
  %in.vec3 = load <8 x i64>, <8 x i64>* %in.vecptr3, align 32

  %concat01 = shufflevector <8 x i64> %in.vec0, <8 x i64> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %concat23 = shufflevector <8 x i64> %in.vec2, <8 x i64> %in.vec3, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %concat0123 = shufflevector <16 x i64> %concat01, <16 x i64> %concat23, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x i64> %concat0123, <32 x i64> poison, <32 x i32> <i32 0, i32 8, i32 16, i32 24, i32 1, i32 9, i32 17, i32 25, i32 2, i32 10, i32 18, i32 26, i32 3, i32 11, i32 19, i32 27, i32 4, i32 12, i32 20, i32 28, i32 5, i32 13, i32 21, i32 29, i32 6, i32 14, i32 22, i32 30, i32 7, i32 15, i32 23, i32 31>

  store <32 x i64> %interleaved.vec, <32 x i64>* %out.vec, align 32

  ret void
}
