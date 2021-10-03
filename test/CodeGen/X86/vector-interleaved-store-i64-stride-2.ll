; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @store_i64_stride2_vf2(<2 x i64>* %in.vecptr0, <2 x i64>* %in.vecptr1, <4 x i64>* %out.vec) nounwind {
; SSE-LABEL: store_i64_stride2_vf2:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps (%rsi), %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    movlhps {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE-NEXT:    movaps %xmm0, 16(%rdx)
; SSE-NEXT:    movaps %xmm2, (%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride2_vf2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX1-NEXT:    vbroadcastf128 {{.*#+}} ymm1 = mem[0,1,0,1]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm0 = ymm1[0],ymm0[0],ymm1[3],ymm0[3]
; AVX1-NEXT:    vmovapd %ymm0, (%rdx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride2_vf2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vinsertf128 $1, (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride2_vf2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovaps (%rdi), %xmm0
; AVX512-NEXT:    vinsertf128 $1, (%rsi), %ymm0, %ymm0
; AVX512-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512-NEXT:    vmovaps %ymm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <2 x i64>, <2 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <2 x i64>, <2 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <2 x i64> %in.vec0, <2 x i64> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %interleaved.vec = shufflevector <4 x i64> %concat01, <4 x i64> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>

  store <4 x i64> %interleaved.vec, <4 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride2_vf4(<4 x i64>* %in.vecptr0, <4 x i64>* %in.vecptr1, <8 x i64>* %out.vec) nounwind {
; SSE-LABEL: store_i64_stride2_vf4:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps (%rsi), %xmm2
; SSE-NEXT:    movaps 16(%rsi), %xmm3
; SSE-NEXT:    movaps %xmm0, %xmm4
; SSE-NEXT:    unpckhpd {{.*#+}} xmm4 = xmm4[1],xmm2[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; SSE-NEXT:    movaps %xmm1, %xmm2
; SSE-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm3[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; SSE-NEXT:    movaps %xmm1, 32(%rdx)
; SSE-NEXT:    movaps %xmm2, 48(%rdx)
; SSE-NEXT:    movaps %xmm0, (%rdx)
; SSE-NEXT:    movaps %xmm4, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride2_vf4:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rsi), %xmm0
; AVX1-NEXT:    vmovaps (%rdi), %xmm1
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm2 = xmm1[1],xmm0[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = mem[2,3,2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm2 = mem[2,3,2,3]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm1 = ymm2[0],ymm1[0],ymm2[3],ymm1[3]
; AVX1-NEXT:    vmovapd %ymm1, 32(%rdx)
; AVX1-NEXT:    vmovapd %ymm0, (%rdx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride2_vf4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps (%rsi), %ymm1
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm1[0,0,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm3 = ymm0[0,1,1,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm2 = ymm3[0,1],ymm2[2,3],ymm3[4,5],ymm2[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,2,2,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,1,3,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX2-NEXT:    vmovaps %ymm0, 32(%rdx)
; AVX2-NEXT:    vmovaps %ymm2, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride2_vf4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovaps (%rdi), %ymm0
; AVX512-NEXT:    vinsertf64x4 $1, (%rsi), %zmm0, %zmm0
; AVX512-NEXT:    vmovaps {{.*#+}} zmm1 = [0,4,1,5,2,6,3,7]
; AVX512-NEXT:    vpermpd %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <4 x i64>, <4 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <4 x i64>, <4 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <4 x i64> %in.vec0, <4 x i64> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i64> %concat01, <8 x i64> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>

  store <8 x i64> %interleaved.vec, <8 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride2_vf8(<8 x i64>* %in.vecptr0, <8 x i64>* %in.vecptr1, <16 x i64>* %out.vec) nounwind {
; SSE-LABEL: store_i64_stride2_vf8:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps 32(%rdi), %xmm2
; SSE-NEXT:    movaps 48(%rdi), %xmm3
; SSE-NEXT:    movaps (%rsi), %xmm4
; SSE-NEXT:    movaps 16(%rsi), %xmm5
; SSE-NEXT:    movaps 32(%rsi), %xmm6
; SSE-NEXT:    movaps 48(%rsi), %xmm8
; SSE-NEXT:    movaps %xmm0, %xmm7
; SSE-NEXT:    unpckhpd {{.*#+}} xmm7 = xmm7[1],xmm4[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm4[0]
; SSE-NEXT:    movaps %xmm1, %xmm4
; SSE-NEXT:    unpckhpd {{.*#+}} xmm4 = xmm4[1],xmm5[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm5[0]
; SSE-NEXT:    movaps %xmm2, %xmm5
; SSE-NEXT:    unpckhpd {{.*#+}} xmm5 = xmm5[1],xmm6[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm2 = xmm2[0],xmm6[0]
; SSE-NEXT:    movaps %xmm3, %xmm6
; SSE-NEXT:    unpckhpd {{.*#+}} xmm6 = xmm6[1],xmm8[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm3 = xmm3[0],xmm8[0]
; SSE-NEXT:    movaps %xmm3, 96(%rdx)
; SSE-NEXT:    movaps %xmm6, 112(%rdx)
; SSE-NEXT:    movaps %xmm2, 64(%rdx)
; SSE-NEXT:    movaps %xmm5, 80(%rdx)
; SSE-NEXT:    movaps %xmm1, 32(%rdx)
; SSE-NEXT:    movaps %xmm4, 48(%rdx)
; SSE-NEXT:    movaps %xmm0, (%rdx)
; SSE-NEXT:    movaps %xmm7, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride2_vf8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rsi), %xmm0
; AVX1-NEXT:    vmovaps 32(%rsi), %xmm1
; AVX1-NEXT:    vmovaps (%rdi), %xmm2
; AVX1-NEXT:    vmovaps 32(%rdi), %xmm3
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm4 = xmm2[1],xmm0[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm2[0],xmm0[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm2 = xmm3[1],xmm1[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm3[0],xmm1[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm2 = mem[2,3,2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm3 = mem[2,3,2,3]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm2 = ymm3[0],ymm2[0],ymm3[3],ymm2[3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm3 = mem[2,3,2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = mem[2,3,2,3]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm3 = ymm4[0],ymm3[0],ymm4[3],ymm3[3]
; AVX1-NEXT:    vmovapd %ymm3, 32(%rdx)
; AVX1-NEXT:    vmovapd %ymm2, 96(%rdx)
; AVX1-NEXT:    vmovaps %ymm1, 64(%rdx)
; AVX1-NEXT:    vmovapd %ymm0, (%rdx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride2_vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm1
; AVX2-NEXT:    vmovaps (%rsi), %ymm2
; AVX2-NEXT:    vmovaps 32(%rsi), %ymm3
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm2[0,2,2,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm0[2,1,3,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm4 = ymm5[0,1],ymm4[2,3],ymm5[4,5],ymm4[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[0,0,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,1,1,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm2[2,3],ymm0[4,5],ymm2[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm3[0,2,2,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm1[2,1,3,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm2 = ymm5[0,1],ymm2[2,3],ymm5[4,5],ymm2[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm3 = ymm3[0,0,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,1,1,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1],ymm3[2,3],ymm1[4,5],ymm3[6,7]
; AVX2-NEXT:    vmovaps %ymm1, 64(%rdx)
; AVX2-NEXT:    vmovaps %ymm2, 96(%rdx)
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vmovaps %ymm4, 32(%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride2_vf8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 (%rsi), %zmm1
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [0,8,1,9,2,10,3,11]
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [4,12,5,13,6,14,7,15]
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm3
; AVX512-NEXT:    vmovdqu64 %zmm3, 64(%rdx)
; AVX512-NEXT:    vmovdqu64 %zmm2, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <8 x i64>, <8 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <8 x i64>, <8 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <8 x i64> %in.vec0, <8 x i64> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i64> %concat01, <16 x i64> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>

  store <16 x i64> %interleaved.vec, <16 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride2_vf16(<16 x i64>* %in.vecptr0, <16 x i64>* %in.vecptr1, <32 x i64>* %out.vec) nounwind {
; SSE-LABEL: store_i64_stride2_vf16:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps 112(%rdi), %xmm4
; SSE-NEXT:    movaps 96(%rdi), %xmm6
; SSE-NEXT:    movaps 80(%rdi), %xmm8
; SSE-NEXT:    movaps 64(%rdi), %xmm9
; SSE-NEXT:    movaps (%rdi), %xmm11
; SSE-NEXT:    movaps 16(%rdi), %xmm14
; SSE-NEXT:    movaps 32(%rdi), %xmm15
; SSE-NEXT:    movaps 48(%rdi), %xmm5
; SSE-NEXT:    movaps 96(%rsi), %xmm0
; SSE-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movaps 80(%rsi), %xmm12
; SSE-NEXT:    movaps 64(%rsi), %xmm13
; SSE-NEXT:    movaps (%rsi), %xmm2
; SSE-NEXT:    movaps 16(%rsi), %xmm1
; SSE-NEXT:    movaps 32(%rsi), %xmm0
; SSE-NEXT:    movaps 48(%rsi), %xmm3
; SSE-NEXT:    movaps %xmm11, %xmm7
; SSE-NEXT:    unpckhpd {{.*#+}} xmm7 = xmm7[1],xmm2[1]
; SSE-NEXT:    movaps %xmm7, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movlhps {{.*#+}} xmm11 = xmm11[0],xmm2[0]
; SSE-NEXT:    movaps %xmm14, %xmm10
; SSE-NEXT:    unpckhpd {{.*#+}} xmm10 = xmm10[1],xmm1[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm14 = xmm14[0],xmm1[0]
; SSE-NEXT:    movaps %xmm15, %xmm2
; SSE-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm0[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm15 = xmm15[0],xmm0[0]
; SSE-NEXT:    movaps %xmm5, %xmm0
; SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm3[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm5 = xmm5[0],xmm3[0]
; SSE-NEXT:    movaps %xmm9, %xmm1
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm13[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm9 = xmm9[0],xmm13[0]
; SSE-NEXT:    movaps %xmm8, %xmm13
; SSE-NEXT:    unpckhpd {{.*#+}} xmm13 = xmm13[1],xmm12[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm8 = xmm8[0],xmm12[0]
; SSE-NEXT:    movaps %xmm6, %xmm3
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm7 # 16-byte Reload
; SSE-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1],xmm7[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm6 = xmm6[0],xmm7[0]
; SSE-NEXT:    movaps 112(%rsi), %xmm12
; SSE-NEXT:    movaps %xmm4, %xmm7
; SSE-NEXT:    unpckhpd {{.*#+}} xmm7 = xmm7[1],xmm12[1]
; SSE-NEXT:    movlhps {{.*#+}} xmm4 = xmm4[0],xmm12[0]
; SSE-NEXT:    movaps %xmm4, 224(%rdx)
; SSE-NEXT:    movaps %xmm7, 240(%rdx)
; SSE-NEXT:    movaps %xmm6, 192(%rdx)
; SSE-NEXT:    movaps %xmm3, 208(%rdx)
; SSE-NEXT:    movaps %xmm8, 160(%rdx)
; SSE-NEXT:    movaps %xmm13, 176(%rdx)
; SSE-NEXT:    movaps %xmm9, 128(%rdx)
; SSE-NEXT:    movaps %xmm1, 144(%rdx)
; SSE-NEXT:    movaps %xmm5, 96(%rdx)
; SSE-NEXT:    movaps %xmm0, 112(%rdx)
; SSE-NEXT:    movaps %xmm15, 64(%rdx)
; SSE-NEXT:    movaps %xmm2, 80(%rdx)
; SSE-NEXT:    movaps %xmm14, 32(%rdx)
; SSE-NEXT:    movaps %xmm10, 48(%rdx)
; SSE-NEXT:    movaps %xmm11, (%rdx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride2_vf16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rsi), %xmm0
; AVX1-NEXT:    vmovaps 32(%rsi), %xmm8
; AVX1-NEXT:    vmovaps 64(%rsi), %xmm2
; AVX1-NEXT:    vmovaps 96(%rsi), %xmm3
; AVX1-NEXT:    vmovaps (%rdi), %xmm4
; AVX1-NEXT:    vmovaps 32(%rdi), %xmm5
; AVX1-NEXT:    vmovaps 64(%rdi), %xmm6
; AVX1-NEXT:    vmovaps 96(%rdi), %xmm7
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm1 = xmm7[1],xmm3[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm3 = xmm7[0],xmm3[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm3, %ymm1
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm3 = xmm6[1],xmm2[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm2 = xmm6[0],xmm2[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm3 = xmm4[1],xmm0[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm4[0],xmm0[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm3 = xmm5[1],xmm8[1]
; AVX1-NEXT:    vmovlhps {{.*#+}} xmm4 = xmm5[0],xmm8[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm3
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = mem[2,3,2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm5 = mem[2,3,2,3]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm4 = ymm5[0],ymm4[0],ymm5[3],ymm4[3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm5 = mem[2,3,2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm6 = mem[2,3,2,3]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm5 = ymm6[0],ymm5[0],ymm6[3],ymm5[3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm6 = mem[2,3,2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm7 = mem[2,3,2,3]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm6 = ymm7[0],ymm6[0],ymm7[3],ymm6[3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm7 = mem[2,3,2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm8 = mem[2,3,2,3]
; AVX1-NEXT:    vshufpd {{.*#+}} ymm7 = ymm8[0],ymm7[0],ymm8[3],ymm7[3]
; AVX1-NEXT:    vmovapd %ymm7, 224(%rdx)
; AVX1-NEXT:    vmovapd %ymm6, 96(%rdx)
; AVX1-NEXT:    vmovapd %ymm5, 32(%rdx)
; AVX1-NEXT:    vmovapd %ymm4, 160(%rdx)
; AVX1-NEXT:    vmovaps %ymm3, 64(%rdx)
; AVX1-NEXT:    vmovapd %ymm0, (%rdx)
; AVX1-NEXT:    vmovaps %ymm2, 128(%rdx)
; AVX1-NEXT:    vmovaps %ymm1, 192(%rdx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride2_vf16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm1
; AVX2-NEXT:    vmovaps 64(%rdi), %ymm2
; AVX2-NEXT:    vmovaps 96(%rdi), %ymm3
; AVX2-NEXT:    vmovaps (%rsi), %ymm4
; AVX2-NEXT:    vmovaps 32(%rsi), %ymm5
; AVX2-NEXT:    vmovaps 64(%rsi), %ymm6
; AVX2-NEXT:    vmovaps 96(%rsi), %ymm7
; AVX2-NEXT:    vpermpd {{.*#+}} ymm8 = ymm4[0,2,2,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm9 = ymm0[2,1,3,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm8 = ymm9[0,1],ymm8[2,3],ymm9[4,5],ymm8[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm4[0,0,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,1,1,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm4[2,3],ymm0[4,5],ymm4[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm5[0,2,2,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm9 = ymm1[2,1,3,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm4 = ymm9[0,1],ymm4[2,3],ymm9[4,5],ymm4[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[0,0,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,1,1,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1],ymm5[2,3],ymm1[4,5],ymm5[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm6[0,2,2,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm9 = ymm2[2,1,3,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm5 = ymm9[0,1],ymm5[2,3],ymm9[4,5],ymm5[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm6 = ymm6[0,0,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[0,1,1,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm2 = ymm2[0,1],ymm6[2,3],ymm2[4,5],ymm6[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm6 = ymm7[0,2,2,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm9 = ymm3[2,1,3,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm6 = ymm9[0,1],ymm6[2,3],ymm9[4,5],ymm6[6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm7 = ymm7[0,0,2,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm3 = ymm3[0,1,1,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm3 = ymm3[0,1],ymm7[2,3],ymm3[4,5],ymm7[6,7]
; AVX2-NEXT:    vmovaps %ymm3, 192(%rdx)
; AVX2-NEXT:    vmovaps %ymm6, 224(%rdx)
; AVX2-NEXT:    vmovaps %ymm2, 128(%rdx)
; AVX2-NEXT:    vmovaps %ymm5, 160(%rdx)
; AVX2-NEXT:    vmovaps %ymm1, 64(%rdx)
; AVX2-NEXT:    vmovaps %ymm4, 96(%rdx)
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vmovaps %ymm8, 32(%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride2_vf16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 64(%rdi), %zmm1
; AVX512-NEXT:    vmovdqu64 (%rsi), %zmm2
; AVX512-NEXT:    vmovdqu64 64(%rsi), %zmm3
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm4 = [4,12,5,13,6,14,7,15]
; AVX512-NEXT:    vmovdqa64 %zmm0, %zmm5
; AVX512-NEXT:    vpermt2q %zmm2, %zmm4, %zmm5
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm6 = [0,8,1,9,2,10,3,11]
; AVX512-NEXT:    vpermt2q %zmm2, %zmm6, %zmm0
; AVX512-NEXT:    vpermi2q %zmm3, %zmm1, %zmm4
; AVX512-NEXT:    vpermt2q %zmm3, %zmm6, %zmm1
; AVX512-NEXT:    vmovdqu64 %zmm1, 128(%rdx)
; AVX512-NEXT:    vmovdqu64 %zmm4, 192(%rdx)
; AVX512-NEXT:    vmovdqu64 %zmm0, (%rdx)
; AVX512-NEXT:    vmovdqu64 %zmm5, 64(%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <16 x i64>, <16 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <16 x i64>, <16 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <16 x i64> %in.vec0, <16 x i64> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x i64> %concat01, <32 x i64> poison, <32 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23, i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>

  store <32 x i64> %interleaved.vec, <32 x i64>* %out.vec, align 32

  ret void
}
