; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck --check-prefixes=AVX2 %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck --check-prefixes=AVX2 %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck --check-prefixes=AVX2 %s

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @store_i64_stride2_vf2(<2 x i64>* %in.vecptr0, <2 x i64>* %in.vecptr1, <4 x i64>* %out.vec) nounwind {
; AVX2-LABEL: store_i64_stride2_vf2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vinsertf128 $1, (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %in.vec0 = load <2 x i64>, <2 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <2 x i64>, <2 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <2 x i64> %in.vec0, <2 x i64> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %interleaved.vec = shufflevector <4 x i64> %concat01, <4 x i64> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>

  store <4 x i64> %interleaved.vec, <4 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride2_vf4(<4 x i64>* %in.vecptr0, <4 x i64>* %in.vecptr1, <8 x i64>* %out.vec) nounwind {
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
  %in.vec0 = load <4 x i64>, <4 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <4 x i64>, <4 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <4 x i64> %in.vec0, <4 x i64> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i64> %concat01, <8 x i64> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>

  store <8 x i64> %interleaved.vec, <8 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride2_vf8(<8 x i64>* %in.vecptr0, <8 x i64>* %in.vecptr1, <16 x i64>* %out.vec) nounwind {
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
  %in.vec0 = load <8 x i64>, <8 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <8 x i64>, <8 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <8 x i64> %in.vec0, <8 x i64> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i64> %concat01, <16 x i64> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>

  store <16 x i64> %interleaved.vec, <16 x i64>* %out.vec, align 32

  ret void
}

define void @store_i64_stride2_vf16(<16 x i64>* %in.vecptr0, <16 x i64>* %in.vecptr1, <32 x i64>* %out.vec) nounwind {
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
  %in.vec0 = load <16 x i64>, <16 x i64>* %in.vecptr0, align 32
  %in.vec1 = load <16 x i64>, <16 x i64>* %in.vecptr1, align 32

  %concat01 = shufflevector <16 x i64> %in.vec0, <16 x i64> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x i64> %concat01, <32 x i64> poison, <32 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23, i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>

  store <32 x i64> %interleaved.vec, <32 x i64>* %out.vec, align 32

  ret void
}
