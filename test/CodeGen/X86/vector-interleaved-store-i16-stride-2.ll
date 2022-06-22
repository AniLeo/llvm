; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @vf2(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: vf2:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3]
; SSE-NEXT:    movq %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: vf2:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3]
; AVX-NEXT:    vmovq %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: vf2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3]
; AVX512-NEXT:    vmovq %xmm0, (%rdx)
; AVX512-NEXT:    retq
  %in.vec0 = load <2 x i16>, ptr %in.vecptr0, align 32
  %in.vec1 = load <2 x i16>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <2 x i16> %in.vec0, <2 x i16> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %interleaved.vec = shufflevector <4 x i16> %concat01, <4 x i16> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>

  store <4 x i16> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @vf4(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: vf4:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; SSE-NEXT:    movdqa %xmm1, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: vf4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; AVX-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: vf4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; AVX512-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX512-NEXT:    retq
  %in.vec0 = load <4 x i16>, ptr %in.vecptr0, align 32
  %in.vec1 = load <4 x i16>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <4 x i16> %in.vec0, <4 x i16> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i16> %concat01, <8 x i16> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>

  store <8 x i16> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @vf8(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: vf8:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa (%rsi), %xmm1
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; SSE-NEXT:    punpckhwd {{.*#+}} xmm0 = xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE-NEXT:    movdqa %xmm0, 16(%rdx)
; SSE-NEXT:    movdqa %xmm2, (%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: vf8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa (%rdi), %xmm0
; AVX1-NEXT:    vmovdqa (%rsi), %xmm1
; AVX1-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; AVX1-NEXT:    vmovdqa %xmm0, 16(%rdx)
; AVX1-NEXT:    vmovdqa %xmm2, (%rdx)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vinserti128 $1, (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,8,9,2,3,10,11,4,5,12,13,6,7,14,15,16,17,24,25,18,19,26,27,20,21,28,29,22,23,30,31]
; AVX2-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: vf8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vinserti128 $1, (%rsi), %ymm0, %ymm0
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm1 = [0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15]
; AVX512-NEXT:    vpermw %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <8 x i16>, ptr %in.vecptr0, align 32
  %in.vec1 = load <8 x i16>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <8 x i16> %in.vec0, <8 x i16> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i16> %concat01, <16 x i16> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>

  store <16 x i16> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @vf16(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: vf16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa 16(%rdi), %xmm1
; SSE-NEXT:    movdqa (%rsi), %xmm2
; SSE-NEXT:    movdqa 16(%rsi), %xmm3
; SSE-NEXT:    movdqa %xmm0, %xmm4
; SSE-NEXT:    punpckhwd {{.*#+}} xmm4 = xmm4[4],xmm2[4],xmm4[5],xmm2[5],xmm4[6],xmm2[6],xmm4[7],xmm2[7]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    punpckhwd {{.*#+}} xmm2 = xmm2[4],xmm3[4],xmm2[5],xmm3[5],xmm2[6],xmm3[6],xmm2[7],xmm3[7]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm3[0],xmm1[1],xmm3[1],xmm1[2],xmm3[2],xmm1[3],xmm3[3]
; SSE-NEXT:    movdqa %xmm1, 32(%rdx)
; SSE-NEXT:    movdqa %xmm2, 48(%rdx)
; SSE-NEXT:    movdqa %xmm0, (%rdx)
; SSE-NEXT:    movdqa %xmm4, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: vf16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rsi), %xmm0
; AVX-NEXT:    vmovdqa 16(%rsi), %xmm1
; AVX-NEXT:    vmovdqa (%rdi), %xmm2
; AVX-NEXT:    vmovdqa 16(%rdi), %xmm3
; AVX-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3]
; AVX-NEXT:    vpunpckhwd {{.*#+}} xmm2 = xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm1 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3]
; AVX-NEXT:    vmovdqa %xmm1, 32(%rdx)
; AVX-NEXT:    vmovdqa %xmm2, 48(%rdx)
; AVX-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX-NEXT:    vmovdqa %xmm4, 16(%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: vf16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512-NEXT:    vinserti64x4 $1, (%rsi), %zmm0, %zmm0
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [0,16,1,17,2,18,3,19,4,20,5,21,6,22,7,23,8,24,9,25,10,26,11,27,12,28,13,29,14,30,15,31]
; AVX512-NEXT:    vpermw %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    vmovdqu64 %zmm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <16 x i16>, ptr %in.vecptr0, align 32
  %in.vec1 = load <16 x i16>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <16 x i16> %in.vec0, <16 x i16> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x i16> %concat01, <32 x i16> poison, <32 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23, i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>

  store <32 x i16> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @vf32(ptr %in.vecptr0, ptr %in.vecptr1, ptr %out.vec) nounwind {
; SSE-LABEL: vf32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa 16(%rdi), %xmm1
; SSE-NEXT:    movdqa 32(%rdi), %xmm2
; SSE-NEXT:    movdqa 48(%rdi), %xmm3
; SSE-NEXT:    movdqa (%rsi), %xmm4
; SSE-NEXT:    movdqa 16(%rsi), %xmm5
; SSE-NEXT:    movdqa 32(%rsi), %xmm6
; SSE-NEXT:    movdqa 48(%rsi), %xmm8
; SSE-NEXT:    movdqa %xmm0, %xmm7
; SSE-NEXT:    punpckhwd {{.*#+}} xmm7 = xmm7[4],xmm4[4],xmm7[5],xmm4[5],xmm7[6],xmm4[6],xmm7[7],xmm4[7]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1],xmm0[2],xmm4[2],xmm0[3],xmm4[3]
; SSE-NEXT:    movdqa %xmm1, %xmm4
; SSE-NEXT:    punpckhwd {{.*#+}} xmm4 = xmm4[4],xmm5[4],xmm4[5],xmm5[5],xmm4[6],xmm5[6],xmm4[7],xmm5[7]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm5[0],xmm1[1],xmm5[1],xmm1[2],xmm5[2],xmm1[3],xmm5[3]
; SSE-NEXT:    movdqa %xmm2, %xmm5
; SSE-NEXT:    punpckhwd {{.*#+}} xmm5 = xmm5[4],xmm6[4],xmm5[5],xmm6[5],xmm5[6],xmm6[6],xmm5[7],xmm6[7]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm6[0],xmm2[1],xmm6[1],xmm2[2],xmm6[2],xmm2[3],xmm6[3]
; SSE-NEXT:    movdqa %xmm3, %xmm6
; SSE-NEXT:    punpckhwd {{.*#+}} xmm6 = xmm6[4],xmm8[4],xmm6[5],xmm8[5],xmm6[6],xmm8[6],xmm6[7],xmm8[7]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm8[0],xmm3[1],xmm8[1],xmm3[2],xmm8[2],xmm3[3],xmm8[3]
; SSE-NEXT:    movdqa %xmm3, 96(%rdx)
; SSE-NEXT:    movdqa %xmm6, 112(%rdx)
; SSE-NEXT:    movdqa %xmm2, 64(%rdx)
; SSE-NEXT:    movdqa %xmm5, 80(%rdx)
; SSE-NEXT:    movdqa %xmm1, 32(%rdx)
; SSE-NEXT:    movdqa %xmm4, 48(%rdx)
; SSE-NEXT:    movdqa %xmm0, (%rdx)
; SSE-NEXT:    movdqa %xmm7, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: vf32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rsi), %xmm0
; AVX-NEXT:    vmovdqa 16(%rsi), %xmm1
; AVX-NEXT:    vmovdqa 32(%rsi), %xmm2
; AVX-NEXT:    vmovdqa 48(%rsi), %xmm3
; AVX-NEXT:    vmovdqa (%rdi), %xmm4
; AVX-NEXT:    vmovdqa 16(%rdi), %xmm5
; AVX-NEXT:    vmovdqa 32(%rdi), %xmm6
; AVX-NEXT:    vmovdqa 48(%rdi), %xmm7
; AVX-NEXT:    vpunpckhwd {{.*#+}} xmm8 = xmm6[4],xmm2[4],xmm6[5],xmm2[5],xmm6[6],xmm2[6],xmm6[7],xmm2[7]
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm6[0],xmm2[0],xmm6[1],xmm2[1],xmm6[2],xmm2[2],xmm6[3],xmm2[3]
; AVX-NEXT:    vpunpckhwd {{.*#+}} xmm6 = xmm7[4],xmm3[4],xmm7[5],xmm3[5],xmm7[6],xmm3[6],xmm7[7],xmm3[7]
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm3 = xmm7[0],xmm3[0],xmm7[1],xmm3[1],xmm7[2],xmm3[2],xmm7[3],xmm3[3]
; AVX-NEXT:    vpunpckhwd {{.*#+}} xmm7 = xmm5[4],xmm1[4],xmm5[5],xmm1[5],xmm5[6],xmm1[6],xmm5[7],xmm1[7]
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm1 = xmm5[0],xmm1[0],xmm5[1],xmm1[1],xmm5[2],xmm1[2],xmm5[3],xmm1[3]
; AVX-NEXT:    vpunpckhwd {{.*#+}} xmm5 = xmm4[4],xmm0[4],xmm4[5],xmm0[5],xmm4[6],xmm0[6],xmm4[7],xmm0[7]
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm4[0],xmm0[0],xmm4[1],xmm0[1],xmm4[2],xmm0[2],xmm4[3],xmm0[3]
; AVX-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX-NEXT:    vmovdqa %xmm5, 16(%rdx)
; AVX-NEXT:    vmovdqa %xmm1, 32(%rdx)
; AVX-NEXT:    vmovdqa %xmm7, 48(%rdx)
; AVX-NEXT:    vmovdqa %xmm3, 96(%rdx)
; AVX-NEXT:    vmovdqa %xmm6, 112(%rdx)
; AVX-NEXT:    vmovdqa %xmm2, 64(%rdx)
; AVX-NEXT:    vmovdqa %xmm8, 80(%rdx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: vf32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 (%rsi), %zmm1
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [0,32,1,33,2,34,3,35,4,36,5,37,6,38,7,39,8,40,9,41,10,42,11,43,12,44,13,45,14,46,15,47]
; AVX512-NEXT:    vpermi2w %zmm1, %zmm0, %zmm2
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [16,48,17,49,18,50,19,51,20,52,21,53,22,54,23,55,24,56,25,57,26,58,27,59,28,60,29,61,30,62,31,63]
; AVX512-NEXT:    vpermi2w %zmm1, %zmm0, %zmm3
; AVX512-NEXT:    vmovdqu64 %zmm3, 64(%rdx)
; AVX512-NEXT:    vmovdqu64 %zmm2, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <32 x i16>, ptr %in.vecptr0, align 32
  %in.vec1 = load <32 x i16>, ptr %in.vecptr1, align 32

  %concat01 = shufflevector <32 x i16> %in.vec0, <32 x i16> %in.vec1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %interleaved.vec = shufflevector <64 x i16> %concat01, <64 x i16> poison, <64 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>

  store <64 x i16> %interleaved.vec, ptr %out.vec, align 32

  ret void
}
