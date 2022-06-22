; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @store_i8_stride2_vf2(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: store_i8_stride2_vf2:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; SSE-NEXT:    movd %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i8_stride2_vf2:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX-NEXT:    vmovd %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride2_vf2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX512-NEXT:    vmovd %xmm0, (%rdx)
; AVX512-NEXT:    retq
  %in.vec0 = load <2 x i8>, ptr %in.vecptr0, align 32
  %in.vec1 = load <2 x i8>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <2 x i8> %in.vec0, <2 x i8> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %interleaved.vec = shufflevector <4 x i8> %concat01, <4 x i8> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>

  store <4 x i8> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @store_i8_stride2_vf4(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: store_i8_stride2_vf4:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; SSE-NEXT:    movq %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i8_stride2_vf4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX-NEXT:    vmovq %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride2_vf4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX512-NEXT:    vmovq %xmm0, (%rdx)
; AVX512-NEXT:    retq
  %in.vec0 = load <4 x i8>, ptr %in.vecptr0, align 32
  %in.vec1 = load <4 x i8>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <4 x i8> %in.vec0, <4 x i8> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i8> %concat01, <8 x i8> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>

  store <8 x i8> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @store_i8_stride2_vf8(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: store_i8_stride2_vf8:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE-NEXT:    movdqa %xmm1, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i8_stride2_vf8:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; AVX-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride2_vf8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; AVX512-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX512-NEXT:    retq
  %in.vec0 = load <8 x i8>, ptr %in.vecptr0, align 32
  %in.vec1 = load <8 x i8>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <8 x i8> %in.vec0, <8 x i8> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i8> %concat01, <16 x i8> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>

  store <16 x i8> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @store_i8_stride2_vf16(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: store_i8_stride2_vf16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa (%rsi), %xmm1
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
; SSE-NEXT:    punpckhbw {{.*#+}} xmm0 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
; SSE-NEXT:    movdqa %xmm0, 16(%rdx)
; SSE-NEXT:    movdqa %xmm2, (%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i8_stride2_vf16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa (%rdi), %xmm0
; AVX1-NEXT:    vmovdqa (%rsi), %xmm1
; AVX1-NEXT:    vpunpcklbw {{.*#+}} xmm2 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm0 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
; AVX1-NEXT:    vmovdqa %xmm0, 16(%rdx)
; AVX1-NEXT:    vmovdqa %xmm2, (%rdx)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i8_stride2_vf16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vinserti128 $1, (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15,16,24,17,25,18,26,19,27,20,28,21,29,22,30,23,31]
; AVX2-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride2_vf16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vinserti128 $1, (%rsi), %ymm0, %ymm0
; AVX512-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15,16,24,17,25,18,26,19,27,20,28,21,29,22,30,23,31]
; AVX512-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <16 x i8>, ptr %in.vecptr0, align 32
  %in.vec1 = load <16 x i8>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <16 x i8> %in.vec0, <16 x i8> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x i8> %concat01, <32 x i8> poison, <32 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23, i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>

  store <32 x i8> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @store_i8_stride2_vf32(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: store_i8_stride2_vf32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa 16(%rdi), %xmm1
; SSE-NEXT:    movdqa (%rsi), %xmm2
; SSE-NEXT:    movdqa 16(%rsi), %xmm3
; SSE-NEXT:    movdqa %xmm0, %xmm4
; SSE-NEXT:    punpckhbw {{.*#+}} xmm4 = xmm4[8],xmm2[8],xmm4[9],xmm2[9],xmm4[10],xmm2[10],xmm4[11],xmm2[11],xmm4[12],xmm2[12],xmm4[13],xmm2[13],xmm4[14],xmm2[14],xmm4[15],xmm2[15]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3],xmm0[4],xmm2[4],xmm0[5],xmm2[5],xmm0[6],xmm2[6],xmm0[7],xmm2[7]
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm3[8],xmm2[9],xmm3[9],xmm2[10],xmm3[10],xmm2[11],xmm3[11],xmm2[12],xmm3[12],xmm2[13],xmm3[13],xmm2[14],xmm3[14],xmm2[15],xmm3[15]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm3[0],xmm1[1],xmm3[1],xmm1[2],xmm3[2],xmm1[3],xmm3[3],xmm1[4],xmm3[4],xmm1[5],xmm3[5],xmm1[6],xmm3[6],xmm1[7],xmm3[7]
; SSE-NEXT:    movdqa %xmm1, 32(%rdx)
; SSE-NEXT:    movdqa %xmm2, 48(%rdx)
; SSE-NEXT:    movdqa %xmm0, (%rdx)
; SSE-NEXT:    movdqa %xmm4, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i8_stride2_vf32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rsi), %xmm0
; AVX-NEXT:    vmovdqa 16(%rsi), %xmm1
; AVX-NEXT:    vmovdqa (%rdi), %xmm2
; AVX-NEXT:    vmovdqa 16(%rdi), %xmm3
; AVX-NEXT:    vpunpckhbw {{.*#+}} xmm4 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
; AVX-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; AVX-NEXT:    vpunpckhbw {{.*#+}} xmm2 = xmm3[8],xmm1[8],xmm3[9],xmm1[9],xmm3[10],xmm1[10],xmm3[11],xmm1[11],xmm3[12],xmm1[12],xmm3[13],xmm1[13],xmm3[14],xmm1[14],xmm3[15],xmm1[15]
; AVX-NEXT:    vpunpcklbw {{.*#+}} xmm1 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
; AVX-NEXT:    vmovdqa %xmm1, 32(%rdx)
; AVX-NEXT:    vmovdqa %xmm2, 48(%rdx)
; AVX-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX-NEXT:    vmovdqa %xmm4, 16(%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride2_vf32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512-NEXT:    vinserti64x4 $1, (%rsi), %zmm0, %zmm0
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [0,4,1,5,2,6,3,7]
; AVX512-NEXT:    vpermq %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    vpshufb {{.*#+}} zmm0 = zmm0[0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15,16,24,17,25,18,26,19,27,20,28,21,29,22,30,23,31,32,40,33,41,34,42,35,43,36,44,37,45,38,46,39,47,48,56,49,57,50,58,51,59,52,60,53,61,54,62,55,63]
; AVX512-NEXT:    vmovdqu64 %zmm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <32 x i8>, ptr %in.vecptr0, align 32
  %in.vec1 = load <32 x i8>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <32 x i8> %in.vec0, <32 x i8> %in.vec1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %interleaved.vec = shufflevector <64 x i8> %concat01, <64 x i8> poison, <64 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>

  store <64 x i8> %interleaved.vec, ptr %out.vec, align 32

  ret void
}
