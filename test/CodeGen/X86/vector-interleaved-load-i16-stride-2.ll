; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck --check-prefixes=AVX2,AVX2-SLOW %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck --check-prefixes=AVX2,AVX2-FAST %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck --check-prefixes=AVX2,AVX2-FAST %s

; These patterns are produced by LoopVectorizer for interleaved loads.

define void @vf2(<4 x i16>* %in.vec, <2 x i16>* %out.vec0, <2 x i16>* %out.vec1) nounwind {
; AVX2-LABEL: vf2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm0[0,2,2,3,4,5,6,7]
; AVX2-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[1,3,2,3,4,5,6,7]
; AVX2-NEXT:    vmovd %xmm1, (%rsi)
; AVX2-NEXT:    vmovd %xmm0, (%rdx)
; AVX2-NEXT:    retq
  %wide.vec = load <4 x i16>, <4 x i16>* %in.vec, align 32

  %strided.vec0 = shufflevector <4 x i16> %wide.vec, <4 x i16> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec1 = shufflevector <4 x i16> %wide.vec, <4 x i16> poison, <2 x i32> <i32 1, i32 3>

  store <2 x i16> %strided.vec0, <2 x i16>* %out.vec0, align 32
  store <2 x i16> %strided.vec1, <2 x i16>* %out.vec1, align 32

  ret void
}

define void @vf4(<8 x i16>* %in.vec, <4 x i16>* %out.vec0, <4 x i16>* %out.vec1) nounwind {
; AVX2-LABEL: vf4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vpshufb {{.*#+}} xmm1 = xmm0[0,1,4,5,8,9,12,13,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vmovq %xmm1, (%rsi)
; AVX2-NEXT:    vmovq %xmm0, (%rdx)
; AVX2-NEXT:    retq
  %wide.vec = load <8 x i16>, <8 x i16>* %in.vec, align 32

  %strided.vec0 = shufflevector <8 x i16> %wide.vec, <8 x i16> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %strided.vec1 = shufflevector <8 x i16> %wide.vec, <8 x i16> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>

  store <4 x i16> %strided.vec0, <4 x i16>* %out.vec0, align 32
  store <4 x i16> %strided.vec1, <4 x i16>* %out.vec1, align 32

  ret void
}

define void @vf8(<16 x i16>* %in.vec, <8 x i16>* %out.vec0, <8 x i16>* %out.vec1) nounwind {
; AVX2-LABEL: vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    vmovdqa (%rdi), %xmm1
; AVX2-NEXT:    vmovdqa 16(%rdi), %xmm2
; AVX2-NEXT:    vpblendw {{.*#+}} xmm3 = xmm2[0],xmm0[1],xmm2[2],xmm0[3],xmm2[4],xmm0[5],xmm2[6],xmm0[7]
; AVX2-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1],xmm1[2],xmm0[3],xmm1[4],xmm0[5],xmm1[6],xmm0[7]
; AVX2-NEXT:    vpackusdw %xmm3, %xmm0, %xmm0
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm3 = [2,3,6,7,10,11,14,15,14,15,10,11,12,13,14,15]
; AVX2-NEXT:    vpshufb %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX2-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX2-NEXT:    vmovdqa %xmm1, (%rdx)
; AVX2-NEXT:    retq
  %wide.vec = load <16 x i16>, <16 x i16>* %in.vec, align 32

  %strided.vec0 = shufflevector <16 x i16> %wide.vec, <16 x i16> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %strided.vec1 = shufflevector <16 x i16> %wide.vec, <16 x i16> poison, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>

  store <8 x i16> %strided.vec0, <8 x i16>* %out.vec0, align 32
  store <8 x i16> %strided.vec1, <8 x i16>* %out.vec1, align 32

  ret void
}

define void @vf16(<32 x i16>* %in.vec, <16 x i16>* %out.vec0, <16 x i16>* %out.vec1) nounwind {
; AVX2-SLOW-LABEL: vf16:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-SLOW-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} ymm2 = ymm1[0,2,2,3,4,5,6,7,8,10,10,11,12,13,14,15]
; AVX2-SLOW-NEXT:    vpshufhw {{.*#+}} ymm2 = ymm2[0,1,2,3,4,6,6,7,8,9,10,11,12,14,14,15]
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} ymm3 = ymm0[0,2,2,3,4,5,6,7,8,10,10,11,12,13,14,15]
; AVX2-SLOW-NEXT:    vpshufhw {{.*#+}} ymm3 = ymm3[0,1,2,3,4,6,6,7,8,9,10,11,12,14,14,15]
; AVX2-SLOW-NEXT:    vshufps {{.*#+}} ymm2 = ymm3[0,2],ymm2[0,2],ymm3[4,6],ymm2[4,6]
; AVX2-SLOW-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX2-SLOW-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[u,u,u,u,u,u,u,u,2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31]
; AVX2-SLOW-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31,u,u,u,u,u,u,u,u]
; AVX2-SLOW-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX2-SLOW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-SLOW-NEXT:    vmovaps %ymm2, (%rsi)
; AVX2-SLOW-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX2-SLOW-NEXT:    vzeroupper
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: vf16:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-FAST-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm2 = <0,1,4,5,u,u,u,u,8,9,12,13,u,u,u,u,16,17,20,21,u,u,u,u,24,25,28,29,u,u,u,u>
; AVX2-FAST-NEXT:    vpshufb %ymm2, %ymm1, %ymm3
; AVX2-FAST-NEXT:    vpshufb %ymm2, %ymm0, %ymm2
; AVX2-FAST-NEXT:    vshufps {{.*#+}} ymm2 = ymm2[0,2],ymm3[0,2],ymm2[4,6],ymm3[4,6]
; AVX2-FAST-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX2-FAST-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[u,u,u,u,u,u,u,u,2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31]
; AVX2-FAST-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31,u,u,u,u,u,u,u,u]
; AVX2-FAST-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX2-FAST-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-FAST-NEXT:    vmovaps %ymm2, (%rsi)
; AVX2-FAST-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX2-FAST-NEXT:    vzeroupper
; AVX2-FAST-NEXT:    retq
  %wide.vec = load <32 x i16>, <32 x i16>* %in.vec, align 32

  %strided.vec0 = shufflevector <32 x i16> %wide.vec, <32 x i16> poison, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %strided.vec1 = shufflevector <32 x i16> %wide.vec, <32 x i16> poison, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>

  store <16 x i16> %strided.vec0, <16 x i16>* %out.vec0, align 32
  store <16 x i16> %strided.vec1, <16 x i16>* %out.vec1, align 32

  ret void
}

define void @vf32(<64 x i16>* %in.vec, <32 x i16>* %out.vec0, <32 x i16>* %out.vec1) nounwind {
; AVX2-SLOW-LABEL: vf32:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-SLOW-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX2-SLOW-NEXT:    vmovdqa 64(%rdi), %ymm2
; AVX2-SLOW-NEXT:    vmovdqa 96(%rdi), %ymm3
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} ymm4 = ymm1[0,2,2,3,4,5,6,7,8,10,10,11,12,13,14,15]
; AVX2-SLOW-NEXT:    vpshufhw {{.*#+}} ymm4 = ymm4[0,1,2,3,4,6,6,7,8,9,10,11,12,14,14,15]
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} ymm5 = ymm0[0,2,2,3,4,5,6,7,8,10,10,11,12,13,14,15]
; AVX2-SLOW-NEXT:    vpshufhw {{.*#+}} ymm5 = ymm5[0,1,2,3,4,6,6,7,8,9,10,11,12,14,14,15]
; AVX2-SLOW-NEXT:    vshufps {{.*#+}} ymm4 = ymm5[0,2],ymm4[0,2],ymm5[4,6],ymm4[4,6]
; AVX2-SLOW-NEXT:    vpermpd {{.*#+}} ymm4 = ymm4[0,2,1,3]
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} ymm5 = ymm3[0,2,2,3,4,5,6,7,8,10,10,11,12,13,14,15]
; AVX2-SLOW-NEXT:    vpshufhw {{.*#+}} ymm5 = ymm5[0,1,2,3,4,6,6,7,8,9,10,11,12,14,14,15]
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} ymm6 = ymm2[0,2,2,3,4,5,6,7,8,10,10,11,12,13,14,15]
; AVX2-SLOW-NEXT:    vpshufhw {{.*#+}} ymm6 = ymm6[0,1,2,3,4,6,6,7,8,9,10,11,12,14,14,15]
; AVX2-SLOW-NEXT:    vshufps {{.*#+}} ymm5 = ymm6[0,2],ymm5[0,2],ymm6[4,6],ymm5[4,6]
; AVX2-SLOW-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[0,2,1,3]
; AVX2-SLOW-NEXT:    vmovdqa {{.*#+}} ymm6 = <u,u,u,u,u,u,u,u,2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31>
; AVX2-SLOW-NEXT:    vpshufb %ymm6, %ymm1, %ymm1
; AVX2-SLOW-NEXT:    vmovdqa {{.*#+}} ymm7 = <2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31,u,u,u,u,u,u,u,u>
; AVX2-SLOW-NEXT:    vpshufb %ymm7, %ymm0, %ymm0
; AVX2-SLOW-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX2-SLOW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-SLOW-NEXT:    vpshufb %ymm6, %ymm3, %ymm1
; AVX2-SLOW-NEXT:    vpshufb %ymm7, %ymm2, %ymm2
; AVX2-SLOW-NEXT:    vpblendd {{.*#+}} ymm1 = ymm2[0,1],ymm1[2,3],ymm2[4,5],ymm1[6,7]
; AVX2-SLOW-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,1,3]
; AVX2-SLOW-NEXT:    vmovaps %ymm5, 32(%rsi)
; AVX2-SLOW-NEXT:    vmovaps %ymm4, (%rsi)
; AVX2-SLOW-NEXT:    vmovdqa %ymm1, 32(%rdx)
; AVX2-SLOW-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX2-SLOW-NEXT:    vzeroupper
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: vf32:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-FAST-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX2-FAST-NEXT:    vmovdqa 64(%rdi), %ymm2
; AVX2-FAST-NEXT:    vmovdqa 96(%rdi), %ymm3
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm4 = <0,1,4,5,u,u,u,u,8,9,12,13,u,u,u,u,16,17,20,21,u,u,u,u,24,25,28,29,u,u,u,u>
; AVX2-FAST-NEXT:    vpshufb %ymm4, %ymm1, %ymm5
; AVX2-FAST-NEXT:    vpshufb %ymm4, %ymm0, %ymm6
; AVX2-FAST-NEXT:    vshufps {{.*#+}} ymm5 = ymm6[0,2],ymm5[0,2],ymm6[4,6],ymm5[4,6]
; AVX2-FAST-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[0,2,1,3]
; AVX2-FAST-NEXT:    vpshufb %ymm4, %ymm3, %ymm6
; AVX2-FAST-NEXT:    vpshufb %ymm4, %ymm2, %ymm4
; AVX2-FAST-NEXT:    vshufps {{.*#+}} ymm4 = ymm4[0,2],ymm6[0,2],ymm4[4,6],ymm6[4,6]
; AVX2-FAST-NEXT:    vpermpd {{.*#+}} ymm4 = ymm4[0,2,1,3]
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm6 = <u,u,u,u,u,u,u,u,2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31>
; AVX2-FAST-NEXT:    vpshufb %ymm6, %ymm1, %ymm1
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm7 = <2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u,18,19,22,23,26,27,30,31,u,u,u,u,u,u,u,u>
; AVX2-FAST-NEXT:    vpshufb %ymm7, %ymm0, %ymm0
; AVX2-FAST-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX2-FAST-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-FAST-NEXT:    vpshufb %ymm6, %ymm3, %ymm1
; AVX2-FAST-NEXT:    vpshufb %ymm7, %ymm2, %ymm2
; AVX2-FAST-NEXT:    vpblendd {{.*#+}} ymm1 = ymm2[0,1],ymm1[2,3],ymm2[4,5],ymm1[6,7]
; AVX2-FAST-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,1,3]
; AVX2-FAST-NEXT:    vmovaps %ymm4, 32(%rsi)
; AVX2-FAST-NEXT:    vmovaps %ymm5, (%rsi)
; AVX2-FAST-NEXT:    vmovdqa %ymm1, 32(%rdx)
; AVX2-FAST-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX2-FAST-NEXT:    vzeroupper
; AVX2-FAST-NEXT:    retq
  %wide.vec = load <64 x i16>, <64 x i16>* %in.vec, align 32

  %strided.vec0 = shufflevector <64 x i16> %wide.vec, <64 x i16> poison, <32 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30, i32 32, i32 34, i32 36, i32 38, i32 40, i32 42, i32 44, i32 46, i32 48, i32 50, i32 52, i32 54, i32 56, i32 58, i32 60, i32 62>
  %strided.vec1 = shufflevector <64 x i16> %wide.vec, <64 x i16> poison, <32 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31, i32 33, i32 35, i32 37, i32 39, i32 41, i32 43, i32 45, i32 47, i32 49, i32 51, i32 53, i32 55, i32 57, i32 59, i32 61, i32 63>

  store <32 x i16> %strided.vec0, <32 x i16>* %out.vec0, align 32
  store <32 x i16> %strided.vec1, <32 x i16>* %out.vec1, align 32

  ret void
}
