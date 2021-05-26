; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck --check-prefixes=AVX2,AVX2-SLOW %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-shuffle | FileCheck --check-prefixes=AVX2,AVX2-FAST %s

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @vf2(<2 x i16>* %in.vecptr0, <2 x i16>* %in.vecptr1, <2 x i16>* %in.vecptr2, <2 x i16>* %in.vecptr3, <8 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vmovdqa (%rdx), %xmm1
; AVX2-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; AVX2-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,8,9,2,3,10,11,4,5,12,13,6,7,14,15]
; AVX2-NEXT:    vmovdqa %xmm0, (%r8)
; AVX2-NEXT:    retq
  %in.vec0 = load <2 x i16>, <2 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <2 x i16>, <2 x i16>* %in.vecptr1, align 32
  %in.vec2 = load <2 x i16>, <2 x i16>* %in.vecptr2, align 32
  %in.vec3 = load <2 x i16>, <2 x i16>* %in.vecptr3, align 32

  %concat01 = shufflevector <2 x i16> %in.vec0, <2 x i16> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat23 = shufflevector <2 x i16> %in.vec2, <2 x i16> %in.vec3, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat0123 = shufflevector <4 x i16> %concat01, <4 x i16> %concat23, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i16> %concat0123, <8 x i16> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 1, i32 3, i32 5, i32 7>

  store <8 x i16> %interleaved.vec, <8 x i16>* %out.vec, align 32

  ret void
}

define void @vf4(<4 x i16>* %in.vecptr0, <4 x i16>* %in.vecptr1, <4 x i16>* %in.vecptr2, <4 x i16>* %in.vecptr3, <16 x i16>* %out.vec) nounwind {
; AVX2-SLOW-LABEL: vf4:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-SLOW-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-SLOW-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-SLOW-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-SLOW-NEXT:    vmovq {{.*#+}} xmm2 = mem[0],zero
; AVX2-SLOW-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX2-SLOW-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-SLOW-NEXT:    vpshufb {{.*#+}} ymm1 = ymm0[0,1,8,9,u,u,u,u,2,3,10,11,u,u,u,u,u,u,u,u,20,21,28,29,u,u,u,u,22,23,30,31]
; AVX2-SLOW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-SLOW-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,u,u,u,0,1,8,9,u,u,u,u,2,3,10,11,20,21,28,29,u,u,u,u,22,23,30,31,u,u,u,u]
; AVX2-SLOW-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0],ymm0[1],ymm1[2],ymm0[3,4],ymm1[5],ymm0[6],ymm1[7]
; AVX2-SLOW-NEXT:    vmovdqa %ymm0, (%r8)
; AVX2-SLOW-NEXT:    vzeroupper
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: vf4:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-FAST-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-FAST-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-FAST-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-FAST-NEXT:    vmovq {{.*#+}} xmm2 = mem[0],zero
; AVX2-FAST-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX2-FAST-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm1 = [0,2,4,6,1,3,5,7]
; AVX2-FAST-NEXT:    vpermd %ymm0, %ymm1, %ymm0
; AVX2-FAST-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,2,3,6,7,10,11,14,15,16,17,20,21,24,25,28,29,18,19,22,23,26,27,30,31]
; AVX2-FAST-NEXT:    vmovdqa %ymm0, (%r8)
; AVX2-FAST-NEXT:    vzeroupper
; AVX2-FAST-NEXT:    retq
  %in.vec0 = load <4 x i16>, <4 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <4 x i16>, <4 x i16>* %in.vecptr1, align 32
  %in.vec2 = load <4 x i16>, <4 x i16>* %in.vecptr2, align 32
  %in.vec3 = load <4 x i16>, <4 x i16>* %in.vecptr3, align 32

  %concat01 = shufflevector <4 x i16> %in.vec0, <4 x i16> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %concat23 = shufflevector <4 x i16> %in.vec2, <4 x i16> %in.vec3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %concat0123 = shufflevector <8 x i16> %concat01, <8 x i16> %concat23, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i16> %concat0123, <16 x i16> poison, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>

  store <16 x i16> %interleaved.vec, <16 x i16>* %out.vec, align 32

  ret void
}

define void @vf8(<8 x i16>* %in.vecptr0, <8 x i16>* %in.vecptr1, <8 x i16>* %in.vecptr2, <8 x i16>* %in.vecptr3, <32 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vmovdqa (%rdx), %xmm1
; AVX2-NEXT:    vinserti128 $1, (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vinserti128 $1, (%rcx), %ymm1, %ymm1
; AVX2-NEXT:    vpermq {{.*#+}} ymm2 = ymm1[0,2,0,2]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = <u,u,u,u,0,1,8,9,u,u,u,u,2,3,10,11,u,u,u,u,4,5,12,13,u,u,u,u,6,7,14,15>
; AVX2-NEXT:    vpshufb %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vpermq {{.*#+}} ymm4 = ymm0[0,2,0,2]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm5 = <0,1,8,9,u,u,u,u,2,3,10,11,u,u,u,u,4,5,12,13,u,u,u,u,6,7,14,15,u,u,u,u>
; AVX2-NEXT:    vpshufb %ymm5, %ymm4, %ymm4
; AVX2-NEXT:    vpblendd {{.*#+}} ymm2 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[1,3,1,3]
; AVX2-NEXT:    vpshufb %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[1,3,1,3]
; AVX2-NEXT:    vpshufb %ymm5, %ymm0, %ymm0
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm1[1],ymm0[2],ymm1[3],ymm0[4],ymm1[5],ymm0[6],ymm1[7]
; AVX2-NEXT:    vmovdqa %ymm0, 32(%r8)
; AVX2-NEXT:    vmovdqa %ymm2, (%r8)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %in.vec0 = load <8 x i16>, <8 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <8 x i16>, <8 x i16>* %in.vecptr1, align 32
  %in.vec2 = load <8 x i16>, <8 x i16>* %in.vecptr2, align 32
  %in.vec3 = load <8 x i16>, <8 x i16>* %in.vecptr3, align 32

  %concat01 = shufflevector <8 x i16> %in.vec0, <8 x i16> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %concat23 = shufflevector <8 x i16> %in.vec2, <8 x i16> %in.vec3, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %concat0123 = shufflevector <16 x i16> %concat01, <16 x i16> %concat23, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x i16> %concat0123, <32 x i16> poison, <32 x i32> <i32 0, i32 8, i32 16, i32 24, i32 1, i32 9, i32 17, i32 25, i32 2, i32 10, i32 18, i32 26, i32 3, i32 11, i32 19, i32 27, i32 4, i32 12, i32 20, i32 28, i32 5, i32 13, i32 21, i32 29, i32 6, i32 14, i32 22, i32 30, i32 7, i32 15, i32 23, i32 31>

  store <32 x i16> %interleaved.vec, <32 x i16>* %out.vec, align 32

  ret void
}

define void @vf16(<16 x i16>* %in.vecptr0, <16 x i16>* %in.vecptr1, <16 x i16>* %in.vecptr2, <16 x i16>* %in.vecptr3, <64 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rcx), %xmm5
; AVX2-NEXT:    vmovdqa 16(%rcx), %xmm8
; AVX2-NEXT:    vmovdqa (%rdx), %xmm6
; AVX2-NEXT:    vmovdqa 16(%rdx), %xmm9
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm9[0],xmm8[0],xmm9[1],xmm8[1],xmm9[2],xmm8[2],xmm9[3],xmm8[3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm2[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm3, %ymm2
; AVX2-NEXT:    vmovdqa (%rsi), %xmm7
; AVX2-NEXT:    vmovdqa 16(%rsi), %xmm3
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vmovdqa 16(%rdi), %xmm4
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm1 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm10 = xmm1[0],zero,xmm1[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm10, %ymm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm11 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm1 = xmm6[4],xmm5[4],xmm6[5],xmm5[5],xmm6[6],xmm5[6],xmm6[7],xmm5[7]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm10 = xmm1[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm10, %ymm1
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm2 = xmm0[4],xmm7[4],xmm0[5],xmm7[5],xmm0[6],xmm7[6],xmm0[7],xmm7[7]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm10 = xmm2[0],zero,xmm2[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm10, %ymm2
; AVX2-NEXT:    vpblendd {{.*#+}} ymm1 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm6[0],xmm5[0],xmm6[1],xmm5[1],xmm6[2],xmm5[2],xmm6[3],xmm5[3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm5 = xmm2[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm5, %ymm2
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm7[0],xmm0[1],xmm7[1],xmm0[2],xmm7[2],xmm0[3],xmm7[3]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm5 = xmm0[0],zero,xmm0[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm5, %ymm0
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm2[1],ymm0[2],ymm2[3],ymm0[4],ymm2[5],ymm0[6],ymm2[7]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm2 = xmm9[4],xmm8[4],xmm9[5],xmm8[5],xmm9[6],xmm8[6],xmm9[7],xmm8[7]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm5 = xmm2[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm5, %ymm2
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm4, %ymm3
; AVX2-NEXT:    vpblendd {{.*#+}} ymm2 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
; AVX2-NEXT:    vmovdqa %ymm2, 96(%r8)
; AVX2-NEXT:    vmovdqa %ymm0, (%r8)
; AVX2-NEXT:    vmovdqa %ymm1, 32(%r8)
; AVX2-NEXT:    vmovdqa %ymm11, 64(%r8)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %in.vec0 = load <16 x i16>, <16 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <16 x i16>, <16 x i16>* %in.vecptr1, align 32
  %in.vec2 = load <16 x i16>, <16 x i16>* %in.vecptr2, align 32
  %in.vec3 = load <16 x i16>, <16 x i16>* %in.vecptr3, align 32

  %concat01 = shufflevector <16 x i16> %in.vec0, <16 x i16> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %concat23 = shufflevector <16 x i16> %in.vec2, <16 x i16> %in.vec3, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %concat0123 = shufflevector <32 x i16> %concat01, <32 x i16> %concat23, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %interleaved.vec = shufflevector <64 x i16> %concat0123, <64 x i16> poison, <64 x i32> <i32 0, i32 16, i32 32, i32 48, i32 1, i32 17, i32 33, i32 49, i32 2, i32 18, i32 34, i32 50, i32 3, i32 19, i32 35, i32 51, i32 4, i32 20, i32 36, i32 52, i32 5, i32 21, i32 37, i32 53, i32 6, i32 22, i32 38, i32 54, i32 7, i32 23, i32 39, i32 55, i32 8, i32 24, i32 40, i32 56, i32 9, i32 25, i32 41, i32 57, i32 10, i32 26, i32 42, i32 58, i32 11, i32 27, i32 43, i32 59, i32 12, i32 28, i32 44, i32 60, i32 13, i32 29, i32 45, i32 61, i32 14, i32 30, i32 46, i32 62, i32 15, i32 31, i32 47, i32 63>

  store <64 x i16> %interleaved.vec, <64 x i16>* %out.vec, align 32

  ret void
}

define void @vf32(<32 x i16>* %in.vecptr0, <32 x i16>* %in.vecptr1, <32 x i16>* %in.vecptr2, <32 x i16>* %in.vecptr3, <128 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rcx), %xmm15
; AVX2-NEXT:    vmovdqa 16(%rcx), %xmm12
; AVX2-NEXT:    vmovdqa 32(%rcx), %xmm11
; AVX2-NEXT:    vmovdqa 48(%rcx), %xmm2
; AVX2-NEXT:    vmovdqa (%rdx), %xmm6
; AVX2-NEXT:    vmovdqa 16(%rdx), %xmm13
; AVX2-NEXT:    vmovdqa 32(%rdx), %xmm1
; AVX2-NEXT:    vmovdqa 48(%rdx), %xmm7
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm3 = xmm13[0],xmm12[0],xmm13[1],xmm12[1],xmm13[2],xmm12[2],xmm13[3],xmm12[3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm5 = xmm3[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm5, %ymm8
; AVX2-NEXT:    vmovdqa 16(%rsi), %xmm14
; AVX2-NEXT:    vmovdqa 32(%rsi), %xmm3
; AVX2-NEXT:    vmovdqa 16(%rdi), %xmm5
; AVX2-NEXT:    vmovdqa 32(%rdi), %xmm4
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm5[0],xmm14[0],xmm5[1],xmm14[1],xmm5[2],xmm14[2],xmm5[3],xmm14[3]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm9 = xmm0[0],zero,xmm0[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm9, %ymm0
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm8[1],ymm0[2],ymm8[3],ymm0[4],ymm8[5],ymm0[6],ymm8[7]
; AVX2-NEXT:    vmovdqu %ymm0, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm1[4],xmm11[4],xmm1[5],xmm11[5],xmm1[6],xmm11[6],xmm1[7],xmm11[7]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm8 = xmm0[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm8, %ymm8
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm10 = xmm0[0],zero,xmm0[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm10, %ymm0
; AVX2-NEXT:    vmovdqa 48(%rsi), %xmm10
; AVX2-NEXT:    vpblendd {{.*#+}} ymm9 = ymm0[0],ymm8[1],ymm0[2],ymm8[3],ymm0[4],ymm8[5],ymm0[6],ymm8[7]
; AVX2-NEXT:    vmovdqa 48(%rdi), %xmm0
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm1 = xmm1[0],xmm11[0],xmm1[1],xmm11[1],xmm1[2],xmm11[2],xmm1[3],xmm11[3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm8 = xmm1[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm8, %ymm1
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm3 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm4, %ymm3
; AVX2-NEXT:    vpblendd {{.*#+}} ymm8 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm1 = xmm7[4],xmm2[4],xmm7[5],xmm2[5],xmm7[6],xmm2[6],xmm7[7],xmm2[7]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm1[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm3, %ymm1
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm0[4],xmm10[4],xmm0[5],xmm10[5],xmm0[6],xmm10[6],xmm0[7],xmm10[7]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm4 = xmm3[0],zero,xmm3[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm4, %ymm3
; AVX2-NEXT:    vmovdqa (%rsi), %xmm4
; AVX2-NEXT:    vpblendd {{.*#+}} ymm11 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
; AVX2-NEXT:    vmovdqa (%rdi), %xmm1
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm7[0],xmm2[0],xmm7[1],xmm2[1],xmm7[2],xmm2[2],xmm7[3],xmm2[3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm2[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm3, %ymm2
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm10[0],xmm0[1],xmm10[1],xmm0[2],xmm10[2],xmm0[3],xmm10[3]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm3 = xmm0[0],zero,xmm0[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm3, %ymm0
; AVX2-NEXT:    vpblendd {{.*#+}} ymm2 = ymm0[0],ymm2[1],ymm0[2],ymm2[3],ymm0[4],ymm2[5],ymm0[6],ymm2[7]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm6[4],xmm15[4],xmm6[5],xmm15[5],xmm6[6],xmm15[6],xmm6[7],xmm15[7]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm3, %ymm0
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm1[4],xmm4[4],xmm1[5],xmm4[5],xmm1[6],xmm4[6],xmm1[7],xmm4[7]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm7 = xmm3[0],zero,xmm3[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm7, %ymm3
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm3 = xmm6[0],xmm15[0],xmm6[1],xmm15[1],xmm6[2],xmm15[2],xmm6[3],xmm15[3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm6 = xmm3[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm6, %ymm3
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm1 = xmm1[0],xmm4[0],xmm1[1],xmm4[1],xmm1[2],xmm4[2],xmm1[3],xmm4[3]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm4 = xmm1[0],zero,xmm1[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm4, %ymm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0],ymm3[1],ymm1[2],ymm3[3],ymm1[4],ymm3[5],ymm1[6],ymm3[7]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm13[4],xmm12[4],xmm13[5],xmm12[5],xmm13[6],xmm12[6],xmm13[7],xmm12[7]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm4 = xmm3[0,0,1,1]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm4, %ymm3
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm5[4],xmm14[4],xmm5[5],xmm14[5],xmm5[6],xmm14[6],xmm5[7],xmm14[7]
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm5 = xmm4[0],zero,xmm4[1],zero
; AVX2-NEXT:    vpshufd {{.*#+}} xmm4 = xmm4[2,2,3,3]
; AVX2-NEXT:    vinserti128 $1, %xmm4, %ymm5, %ymm4
; AVX2-NEXT:    vpblendd {{.*#+}} ymm3 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
; AVX2-NEXT:    vmovdqa %ymm3, 96(%r8)
; AVX2-NEXT:    vmovdqa %ymm1, (%r8)
; AVX2-NEXT:    vmovdqa %ymm0, 32(%r8)
; AVX2-NEXT:    vmovdqa %ymm2, 192(%r8)
; AVX2-NEXT:    vmovdqa %ymm11, 224(%r8)
; AVX2-NEXT:    vmovdqa %ymm8, 128(%r8)
; AVX2-NEXT:    vmovdqa %ymm9, 160(%r8)
; AVX2-NEXT:    vmovups {{[-0-9]+}}(%r{{[sb]}}p), %ymm0 # 32-byte Reload
; AVX2-NEXT:    vmovaps %ymm0, 64(%r8)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %in.vec0 = load <32 x i16>, <32 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <32 x i16>, <32 x i16>* %in.vecptr1, align 32
  %in.vec2 = load <32 x i16>, <32 x i16>* %in.vecptr2, align 32
  %in.vec3 = load <32 x i16>, <32 x i16>* %in.vecptr3, align 32

  %concat01 = shufflevector <32 x i16> %in.vec0, <32 x i16> %in.vec1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %concat23 = shufflevector <32 x i16> %in.vec2, <32 x i16> %in.vec3, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %concat0123 = shufflevector <64 x i16> %concat01, <64 x i16> %concat23, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
  %interleaved.vec = shufflevector <128 x i16> %concat0123, <128 x i16> poison, <128 x i32> <i32 0, i32 32, i32 64, i32 96, i32 1, i32 33, i32 65, i32 97, i32 2, i32 34, i32 66, i32 98, i32 3, i32 35, i32 67, i32 99, i32 4, i32 36, i32 68, i32 100, i32 5, i32 37, i32 69, i32 101, i32 6, i32 38, i32 70, i32 102, i32 7, i32 39, i32 71, i32 103, i32 8, i32 40, i32 72, i32 104, i32 9, i32 41, i32 73, i32 105, i32 10, i32 42, i32 74, i32 106, i32 11, i32 43, i32 75, i32 107, i32 12, i32 44, i32 76, i32 108, i32 13, i32 45, i32 77, i32 109, i32 14, i32 46, i32 78, i32 110, i32 15, i32 47, i32 79, i32 111, i32 16, i32 48, i32 80, i32 112, i32 17, i32 49, i32 81, i32 113, i32 18, i32 50, i32 82, i32 114, i32 19, i32 51, i32 83, i32 115, i32 20, i32 52, i32 84, i32 116, i32 21, i32 53, i32 85, i32 117, i32 22, i32 54, i32 86, i32 118, i32 23, i32 55, i32 87, i32 119, i32 24, i32 56, i32 88, i32 120, i32 25, i32 57, i32 89, i32 121, i32 26, i32 58, i32 90, i32 122, i32 27, i32 59, i32 91, i32 123, i32 28, i32 60, i32 92, i32 124, i32 29, i32 61, i32 93, i32 125, i32 30, i32 62, i32 94, i32 126, i32 31, i32 63, i32 95, i32 127>

  store <128 x i16> %interleaved.vec, <128 x i16>* %out.vec, align 32

  ret void
}
