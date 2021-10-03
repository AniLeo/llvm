; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @store_i8_stride3_vf2(<2 x i8>* %in.vecptr0, <2 x i8>* %in.vecptr1, <2 x i8>* %in.vecptr2, <6 x i8>* %out.vec) nounwind {
; SSE-LABEL: store_i8_stride3_vf2:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = mem[0,0,0,0,4,5,6,7]
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,0,255,255,0,255,255,255,255,255,255,255,255,255,255]
; SSE-NEXT:    pxor %xmm3, %xmm3
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1],xmm0[2],xmm3[2],xmm0[3],xmm3[3],xmm0[4],xmm3[4],xmm0[5],xmm3[5],xmm0[6],xmm3[6],xmm0[7],xmm3[7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,2,3,1,4,5,6,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,1,3]
; SSE-NEXT:    packuswb %xmm0, %xmm0
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pandn %xmm1, %xmm2
; SSE-NEXT:    por %xmm0, %xmm2
; SSE-NEXT:    movd %xmm2, (%rcx)
; SSE-NEXT:    pextrw $2, %xmm2, %eax
; SSE-NEXT:    movw %ax, 4(%rcx)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i8_stride3_vf2:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3]
; AVX-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,1,2,6,3,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $2, %xmm0, 4(%rcx)
; AVX-NEXT:    vmovd %xmm0, (%rcx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride3_vf2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3]
; AVX512-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,1,2,6,3,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $2, %xmm0, 4(%rcx)
; AVX512-NEXT:    vmovd %xmm0, (%rcx)
; AVX512-NEXT:    retq
  %in.vec0 = load <2 x i8>, <2 x i8>* %in.vecptr0, align 32
  %in.vec1 = load <2 x i8>, <2 x i8>* %in.vecptr1, align 32
  %in.vec2 = load <2 x i8>, <2 x i8>* %in.vecptr2, align 32

  %concat01 = shufflevector <2 x i8> %in.vec0, <2 x i8> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat2u = shufflevector <2 x i8> %in.vec2, <2 x i8> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %concat012 = shufflevector <4 x i8> %concat01, <4 x i8> %concat2u, <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
  %interleaved.vec = shufflevector <6 x i8> %concat012, <6 x i8> poison, <6 x i32> <i32 0, i32 2, i32 4, i32 1, i32 3, i32 5>

  store <6 x i8> %interleaved.vec, <6 x i8>* %out.vec, align 32

  ret void
}

define void @store_i8_stride3_vf4(<4 x i8>* %in.vecptr0, <4 x i8>* %in.vecptr1, <4 x i8>* %in.vecptr2, <12 x i8>* %out.vec) nounwind {
; SSE-LABEL: store_i8_stride3_vf4:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[3,1,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,3,1,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,6,5,4,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,3,2,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,2,2,1,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,5,5,6,4]
; SSE-NEXT:    packuswb %xmm1, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [255,255,0,255,255,0,255,255,0,255,255,0,255,255,255,255]
; SSE-NEXT:    pand %xmm1, %xmm0
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = mem[0,0,1,1,4,5,6,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,0,1,3]
; SSE-NEXT:    pandn %xmm2, %xmm1
; SSE-NEXT:    por %xmm0, %xmm1
; SSE-NEXT:    movq %xmm1, (%rcx)
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,2,3]
; SSE-NEXT:    movd %xmm0, 8(%rcx)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i8_stride3_vf4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; AVX-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,8,1,2,10,3,4,12,5,6,14,7,u,u,u,u]
; AVX-NEXT:    vpextrd $2, %xmm0, 8(%rcx)
; AVX-NEXT:    vmovq %xmm0, (%rcx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride3_vf4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; AVX512-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3],xmm0[4],mem[4],xmm0[5],mem[5],xmm0[6],mem[6],xmm0[7],mem[7]
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,8,1,2,10,3,4,12,5,6,14,7,u,u,u,u]
; AVX512-NEXT:    vpextrd $2, %xmm0, 8(%rcx)
; AVX512-NEXT:    vmovq %xmm0, (%rcx)
; AVX512-NEXT:    retq
  %in.vec0 = load <4 x i8>, <4 x i8>* %in.vecptr0, align 32
  %in.vec1 = load <4 x i8>, <4 x i8>* %in.vecptr1, align 32
  %in.vec2 = load <4 x i8>, <4 x i8>* %in.vecptr2, align 32

  %concat01 = shufflevector <4 x i8> %in.vec0, <4 x i8> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %concat2u = shufflevector <4 x i8> %in.vec2, <4 x i8> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
  %concat012 = shufflevector <8 x i8> %concat01, <8 x i8> %concat2u, <12 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
  %interleaved.vec = shufflevector <12 x i8> %concat012, <12 x i8> poison, <12 x i32> <i32 0, i32 4, i32 8, i32 1, i32 5, i32 9, i32 2, i32 6, i32 10, i32 3, i32 7, i32 11>

  store <12 x i8> %interleaved.vec, <12 x i8>* %out.vec, align 32

  ret void
}

define void @store_i8_stride3_vf8(<8 x i8>* %in.vecptr0, <8 x i8>* %in.vecptr1, <8 x i8>* %in.vecptr2, <24 x i8>* %out.vec) nounwind {
; SSE-LABEL: store_i8_stride3_vf8:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm2 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    pxor %xmm3, %xmm3
; SSE-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm3[0],xmm1[1],xmm3[1],xmm1[2],xmm3[2],xmm1[3],xmm3[3],xmm1[4],xmm3[4],xmm1[5],xmm3[5],xmm1[6],xmm3[6],xmm1[7],xmm3[7]
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[1,1,2,2]
; SSE-NEXT:    movdqa {{.*#+}} xmm5 = [65535,65535,0,65535,65535,0,65535,65535]
; SSE-NEXT:    pand %xmm5, %xmm4
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3],xmm2[4],xmm3[4],xmm2[5],xmm3[5],xmm2[6],xmm3[6],xmm2[7],xmm3[7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm2[3,3,3,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm3 = xmm3[0,1,2,3,4,4,4,4]
; SSE-NEXT:    pandn %xmm3, %xmm5
; SSE-NEXT:    por %xmm4, %xmm5
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3]
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[0,1,2,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm3[0,1,2,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm3 = xmm3[0,1,2,3,7,5,4,5]
; SSE-NEXT:    packuswb %xmm5, %xmm3
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [255,255,0,255,255,0,255,255,0,255,255,0,255,255,0,255]
; SSE-NEXT:    pand %xmm4, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm0[0,1,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm5 = xmm5[0,0,0,0,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm5 = xmm5[0,1,2,3,5,5,6,6]
; SSE-NEXT:    pandn %xmm5, %xmm4
; SSE-NEXT:    por %xmm3, %xmm4
; SSE-NEXT:    punpckhwd {{.*#+}} xmm2 = xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[2,1,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[2,1,1,0,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm1 = xmm1[0,1,2,3,4,7,6,7]
; SSE-NEXT:    packuswb %xmm1, %xmm1
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,0,255,255,0,255,255,0,255,255,255,255,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm1
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[2,1,3,3,4,5,6,7]
; SSE-NEXT:    pandn %xmm0, %xmm2
; SSE-NEXT:    por %xmm1, %xmm2
; SSE-NEXT:    movq %xmm2, 16(%rcx)
; SSE-NEXT:    movdqa %xmm4, (%rcx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i8_stride3_vf8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX1-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX1-NEXT:    vpshufb {{.*#+}} xmm2 = xmm0[0,8],zero,xmm0[1,9],zero,xmm0[2,10],zero,xmm0[3,11],zero,xmm0[4,12],zero,xmm0[5]
; AVX1-NEXT:    vpshufb {{.*#+}} xmm3 = zero,zero,xmm1[0],zero,zero,xmm1[1],zero,zero,xmm1[2],zero,zero,xmm1[3],zero,zero,xmm1[4],zero
; AVX1-NEXT:    vpor %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[13],zero,xmm0[6,14],zero,xmm0[7,15],zero,xmm0[u,u,u,u,u,u,u,u]
; AVX1-NEXT:    vpshufb {{.*#+}} xmm1 = zero,xmm1[5],zero,zero,xmm1[6],zero,zero,xmm1[7,u,u,u,u,u,u,u,u]
; AVX1-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmovq %xmm0, 16(%rcx)
; AVX1-NEXT:    vmovdqa %xmm2, (%rcx)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i8_stride3_vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufb {{.*#+}} ymm1 = ymm0[0,8],zero,ymm0[1,9],zero,ymm0[2,10],zero,ymm0[3,11],zero,ymm0[4,12],zero,ymm0[5],zero,ymm0[21],zero,zero,ymm0[22],zero,zero,ymm0[23],zero,zero,zero,zero,zero,zero,zero,zero
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = zero,zero,ymm0[0],zero,zero,ymm0[1],zero,zero,ymm0[2],zero,zero,ymm0[3],zero,zero,ymm0[4],zero,ymm0[29],zero,ymm0[22,30],zero,ymm0[23,31],zero,ymm0[u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vpor %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovq %xmm1, 16(%rcx)
; AVX2-NEXT:    vmovdqa %xmm0, (%rcx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride3_vf8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX512-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512-NEXT:    vpshufb {{.*#+}} ymm1 = ymm0[0,8],zero,ymm0[1,9],zero,ymm0[2,10],zero,ymm0[3,11],zero,ymm0[4,12],zero,ymm0[5],zero,ymm0[21],zero,zero,ymm0[22],zero,zero,ymm0[23,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX512-NEXT:    vpshufb {{.*#+}} ymm0 = zero,zero,ymm0[0],zero,zero,ymm0[1],zero,zero,ymm0[2],zero,zero,ymm0[3],zero,zero,ymm0[4],zero,ymm0[29],zero,ymm0[22,30],zero,ymm0[23,31],zero,zero,zero,zero,zero,zero,zero,zero,zero
; AVX512-NEXT:    vpor %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vmovq %xmm1, 16(%rcx)
; AVX512-NEXT:    vmovdqa %xmm0, (%rcx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <8 x i8>, <8 x i8>* %in.vecptr0, align 32
  %in.vec1 = load <8 x i8>, <8 x i8>* %in.vecptr1, align 32
  %in.vec2 = load <8 x i8>, <8 x i8>* %in.vecptr2, align 32

  %concat01 = shufflevector <8 x i8> %in.vec0, <8 x i8> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %concat2u = shufflevector <8 x i8> %in.vec2, <8 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %concat012 = shufflevector <16 x i8> %concat01, <16 x i8> %concat2u, <24 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %interleaved.vec = shufflevector <24 x i8> %concat012, <24 x i8> poison, <24 x i32> <i32 0, i32 8, i32 16, i32 1, i32 9, i32 17, i32 2, i32 10, i32 18, i32 3, i32 11, i32 19, i32 4, i32 12, i32 20, i32 5, i32 13, i32 21, i32 6, i32 14, i32 22, i32 7, i32 15, i32 23>

  store <24 x i8> %interleaved.vec, <24 x i8>* %out.vec, align 32

  ret void
}

define void @store_i8_stride3_vf16(<16 x i8>* %in.vecptr0, <16 x i8>* %in.vecptr1, <16 x i8>* %in.vecptr2, <48 x i8>* %out.vec) nounwind {
; SSE-LABEL: store_i8_stride3_vf16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm5
; SSE-NEXT:    movdqa (%rsi), %xmm1
; SSE-NEXT:    movdqa (%rdx), %xmm8
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm8[2,1,3,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm2 = xmm0[0,1,2,3,4,4,4,4]
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [255,0,255,255,0,255,255,0,255,255,0,255,255,0,255,255]
; SSE-NEXT:    movdqa %xmm4, %xmm3
; SSE-NEXT:    pandn %xmm2, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,1,2,3]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm2[1,2,2,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm6 = xmm2[0,1,2,3,4,5,5,6]
; SSE-NEXT:    pand %xmm4, %xmm6
; SSE-NEXT:    por %xmm3, %xmm6
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,0,255,255,0,255,255,0,255,255,0,255,255,0,255]
; SSE-NEXT:    pand %xmm2, %xmm6
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm5[3,3,3,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm7 = xmm3[0,1,2,3,4,4,6,5]
; SSE-NEXT:    movdqa %xmm2, %xmm3
; SSE-NEXT:    pandn %xmm7, %xmm3
; SSE-NEXT:    por %xmm6, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,1,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm6 = xmm6[0,0,2,1,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm6 = xmm6[0,1,2,3,5,5,6,6]
; SSE-NEXT:    pand %xmm4, %xmm6
; SSE-NEXT:    movdqa %xmm1, %xmm7
; SSE-NEXT:    punpcklbw {{.*#+}} xmm7 = xmm7[0],xmm1[0],xmm7[1],xmm1[1],xmm7[2],xmm1[2],xmm7[3],xmm1[3],xmm7[4],xmm1[4],xmm7[5],xmm1[5],xmm7[6],xmm1[6],xmm7[7],xmm1[7]
; SSE-NEXT:    pshufd {{.*#+}} xmm7 = xmm7[0,1,2,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm7 = xmm7[0,1,1,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm7 = xmm7[0,1,2,3,4,7,4,7]
; SSE-NEXT:    movdqa %xmm4, %xmm0
; SSE-NEXT:    pandn %xmm7, %xmm0
; SSE-NEXT:    por %xmm6, %xmm0
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm8[0,1,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm6 = xmm6[0,0,0,0,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm6 = xmm6[0,1,2,3,5,5,6,6]
; SSE-NEXT:    movdqa %xmm2, %xmm7
; SSE-NEXT:    pandn %xmm6, %xmm7
; SSE-NEXT:    por %xmm0, %xmm7
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm5[2,3,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,1,2,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,7,7,7,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm8[2,3,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm5 = xmm5[1,1,2,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm5 = xmm5[0,1,2,3,6,5,7,7]
; SSE-NEXT:    pand %xmm4, %xmm5
; SSE-NEXT:    pandn %xmm0, %xmm4
; SSE-NEXT:    por %xmm5, %xmm4
; SSE-NEXT:    pand %xmm2, %xmm4
; SSE-NEXT:    punpckhbw {{.*#+}} xmm1 = xmm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,1,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,3,0,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,5,6,6,7]
; SSE-NEXT:    pandn %xmm0, %xmm2
; SSE-NEXT:    por %xmm4, %xmm2
; SSE-NEXT:    movdqa %xmm2, 32(%rcx)
; SSE-NEXT:    movdqa %xmm7, (%rcx)
; SSE-NEXT:    movdqa %xmm3, 16(%rcx)
; SSE-NEXT:    retq
;
; AVX-LABEL: store_i8_stride3_vf16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vmovdqa (%rsi), %xmm1
; AVX-NEXT:    vmovdqa (%rdx), %xmm2
; AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15,0,1,2,3,4,5]
; AVX-NEXT:    vpalignr {{.*#+}} xmm3 = xmm1[11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10]
; AVX-NEXT:    vpalignr {{.*#+}} xmm4 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm2[0,1,2,3,4]
; AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm3[5,6,7,8,9,10,11,12,13,14,15],xmm0[0,1,2,3,4]
; AVX-NEXT:    vpalignr {{.*#+}} xmm2 = xmm2[5,6,7,8,9,10,11,12,13,14,15],xmm3[0,1,2,3,4]
; AVX-NEXT:    vpalignr {{.*#+}} xmm1 = xmm4[5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4]
; AVX-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5]
; AVX-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm2[0,1,2,3,4]
; AVX-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX-NEXT:    vpalignr {{.*#+}} xmm2 = xmm2[5,6,7,8,9,10,11,12,13,14,15],xmm4[0,1,2,3,4]
; AVX-NEXT:    vpshufb %xmm3, %xmm2, %xmm2
; AVX-NEXT:    vmovdqa %xmm0, 16(%rcx)
; AVX-NEXT:    vmovdqa %xmm1, (%rcx)
; AVX-NEXT:    vmovdqa %xmm2, 32(%rcx)
; AVX-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride3_vf16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa (%rsi), %xmm1
; AVX512-NEXT:    vmovdqa (%rdx), %xmm2
; AVX512-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15,0,1,2,3,4,5]
; AVX512-NEXT:    vpalignr {{.*#+}} xmm3 = xmm1[11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10]
; AVX512-NEXT:    vpalignr {{.*#+}} xmm4 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm2[0,1,2,3,4]
; AVX512-NEXT:    vpalignr {{.*#+}} xmm0 = xmm3[5,6,7,8,9,10,11,12,13,14,15],xmm0[0,1,2,3,4]
; AVX512-NEXT:    vpalignr {{.*#+}} xmm2 = xmm2[5,6,7,8,9,10,11,12,13,14,15],xmm3[0,1,2,3,4]
; AVX512-NEXT:    vpalignr {{.*#+}} xmm1 = xmm4[5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5]
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm2[0,1,2,3,4]
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpalignr {{.*#+}} xmm2 = xmm2[5,6,7,8,9,10,11,12,13,14,15],xmm4[0,1,2,3,4]
; AVX512-NEXT:    vpshufb %xmm3, %xmm2, %xmm2
; AVX512-NEXT:    vmovdqa %xmm0, 16(%rcx)
; AVX512-NEXT:    vmovdqa %xmm1, (%rcx)
; AVX512-NEXT:    vmovdqa %xmm2, 32(%rcx)
; AVX512-NEXT:    retq
  %in.vec0 = load <16 x i8>, <16 x i8>* %in.vecptr0, align 32
  %in.vec1 = load <16 x i8>, <16 x i8>* %in.vecptr1, align 32
  %in.vec2 = load <16 x i8>, <16 x i8>* %in.vecptr2, align 32

  %concat01 = shufflevector <16 x i8> %in.vec0, <16 x i8> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %concat2u = shufflevector <16 x i8> %in.vec2, <16 x i8> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %concat012 = shufflevector <32 x i8> %concat01, <32 x i8> %concat2u, <48 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %interleaved.vec = shufflevector <48 x i8> %concat012, <48 x i8> poison, <48 x i32> <i32 0, i32 16, i32 32, i32 1, i32 17, i32 33, i32 2, i32 18, i32 34, i32 3, i32 19, i32 35, i32 4, i32 20, i32 36, i32 5, i32 21, i32 37, i32 6, i32 22, i32 38, i32 7, i32 23, i32 39, i32 8, i32 24, i32 40, i32 9, i32 25, i32 41, i32 10, i32 26, i32 42, i32 11, i32 27, i32 43, i32 12, i32 28, i32 44, i32 13, i32 29, i32 45, i32 14, i32 30, i32 46, i32 15, i32 31, i32 47>

  store <48 x i8> %interleaved.vec, <48 x i8>* %out.vec, align 32

  ret void
}

define void @store_i8_stride3_vf32(<32 x i8>* %in.vecptr0, <32 x i8>* %in.vecptr1, <32 x i8>* %in.vecptr2, <96 x i8>* %out.vec) nounwind {
; SSE-LABEL: store_i8_stride3_vf32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm8
; SSE-NEXT:    movdqa 16(%rdi), %xmm11
; SSE-NEXT:    movdqa (%rsi), %xmm12
; SSE-NEXT:    movdqa 16(%rsi), %xmm13
; SSE-NEXT:    movdqa (%rdx), %xmm9
; SSE-NEXT:    movdqa 16(%rdx), %xmm10
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm10[2,1,3,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm2 = xmm0[0,1,2,3,4,4,4,4]
; SSE-NEXT:    movdqa {{.*#+}} xmm6 = [255,0,255,255,0,255,255,0,255,255,0,255,255,0,255,255]
; SSE-NEXT:    movdqa %xmm6, %xmm0
; SSE-NEXT:    pandn %xmm2, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm13[2,1,2,3]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm2[1,2,2,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm4 = xmm2[0,1,2,3,4,5,5,6]
; SSE-NEXT:    pand %xmm6, %xmm4
; SSE-NEXT:    por %xmm0, %xmm4
; SSE-NEXT:    movdqa {{.*#+}} xmm7 = [255,255,0,255,255,0,255,255,0,255,255,0,255,255,0,255]
; SSE-NEXT:    pand %xmm7, %xmm4
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm11[3,3,3,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm5 = xmm2[0,1,2,3,4,4,6,5]
; SSE-NEXT:    movdqa %xmm7, %xmm14
; SSE-NEXT:    pandn %xmm5, %xmm14
; SSE-NEXT:    por %xmm4, %xmm14
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm9[2,1,3,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm4 = xmm4[0,1,2,3,4,4,4,4]
; SSE-NEXT:    movdqa %xmm6, %xmm5
; SSE-NEXT:    pandn %xmm4, %xmm5
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm12[2,1,2,3]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm4 = xmm4[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm4[1,2,2,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm4 = xmm4[0,1,2,3,4,5,5,6]
; SSE-NEXT:    pand %xmm6, %xmm4
; SSE-NEXT:    por %xmm5, %xmm4
; SSE-NEXT:    pand %xmm7, %xmm4
; SSE-NEXT:    pshuflw {{.*#+}} xmm5 = xmm8[3,3,3,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm5 = xmm5[0,1,2,3,4,4,6,5]
; SSE-NEXT:    movdqa %xmm7, %xmm1
; SSE-NEXT:    pandn %xmm5, %xmm1
; SSE-NEXT:    por %xmm4, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm11[0,1,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm4[0,0,2,1,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm4 = xmm4[0,1,2,3,5,5,6,6]
; SSE-NEXT:    pand %xmm6, %xmm4
; SSE-NEXT:    movdqa %xmm13, %xmm5
; SSE-NEXT:    punpcklbw {{.*#+}} xmm5 = xmm5[0],xmm13[0],xmm5[1],xmm13[1],xmm5[2],xmm13[2],xmm5[3],xmm13[3],xmm5[4],xmm13[4],xmm5[5],xmm13[5],xmm5[6],xmm13[6],xmm5[7],xmm13[7]
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[0,1,2,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm5 = xmm5[0,1,1,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm5 = xmm5[0,1,2,3,4,7,4,7]
; SSE-NEXT:    movdqa %xmm6, %xmm0
; SSE-NEXT:    pandn %xmm5, %xmm0
; SSE-NEXT:    por %xmm4, %xmm0
; SSE-NEXT:    pand %xmm7, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm10[0,1,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm4[0,0,0,0,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm5 = xmm4[0,1,2,3,5,5,6,6]
; SSE-NEXT:    movdqa %xmm7, %xmm4
; SSE-NEXT:    pandn %xmm5, %xmm4
; SSE-NEXT:    por %xmm0, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm8[0,1,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,0,2,1,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,5,5,6,6]
; SSE-NEXT:    pand %xmm6, %xmm0
; SSE-NEXT:    movdqa %xmm12, %xmm5
; SSE-NEXT:    punpcklbw {{.*#+}} xmm5 = xmm5[0],xmm12[0],xmm5[1],xmm12[1],xmm5[2],xmm12[2],xmm5[3],xmm12[3],xmm5[4],xmm12[4],xmm5[5],xmm12[5],xmm5[6],xmm12[6],xmm5[7],xmm12[7]
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[0,1,2,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm5 = xmm5[0,1,1,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm5 = xmm5[0,1,2,3,4,7,4,7]
; SSE-NEXT:    movdqa %xmm6, %xmm3
; SSE-NEXT:    pandn %xmm5, %xmm3
; SSE-NEXT:    por %xmm0, %xmm3
; SSE-NEXT:    pand %xmm7, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm9[0,1,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,0,0,0,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,5,5,6,6]
; SSE-NEXT:    movdqa %xmm7, %xmm5
; SSE-NEXT:    pandn %xmm0, %xmm5
; SSE-NEXT:    por %xmm3, %xmm5
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm11[2,3,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,1,2,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,7,7,7,7]
; SSE-NEXT:    movdqa %xmm6, %xmm3
; SSE-NEXT:    pandn %xmm0, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm10[2,3,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,1,2,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,6,5,7,7]
; SSE-NEXT:    pand %xmm6, %xmm0
; SSE-NEXT:    por %xmm3, %xmm0
; SSE-NEXT:    pand %xmm7, %xmm0
; SSE-NEXT:    punpckhbw {{.*#+}} xmm13 = xmm13[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm13[2,1,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm3[0,3,0,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm3 = xmm3[0,1,2,3,5,6,6,7]
; SSE-NEXT:    movdqa %xmm7, %xmm2
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm0, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm8[2,3,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,1,2,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,7,7,7,7]
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm9[2,3,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm3[1,1,2,2,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm3 = xmm3[0,1,2,3,6,5,7,7]
; SSE-NEXT:    pand %xmm6, %xmm3
; SSE-NEXT:    pandn %xmm0, %xmm6
; SSE-NEXT:    por %xmm3, %xmm6
; SSE-NEXT:    pand %xmm7, %xmm6
; SSE-NEXT:    punpckhbw {{.*#+}} xmm12 = xmm12[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm12[2,1,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,3,0,3,4,5,6,7]
; SSE-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,5,6,6,7]
; SSE-NEXT:    pandn %xmm0, %xmm7
; SSE-NEXT:    por %xmm6, %xmm7
; SSE-NEXT:    movdqa %xmm7, 32(%rcx)
; SSE-NEXT:    movdqa %xmm2, 80(%rcx)
; SSE-NEXT:    movdqa %xmm5, (%rcx)
; SSE-NEXT:    movdqa %xmm4, 48(%rcx)
; SSE-NEXT:    movdqa %xmm1, 16(%rcx)
; SSE-NEXT:    movdqa %xmm14, 64(%rcx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i8_stride3_vf32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa (%rdi), %xmm0
; AVX1-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vpalignr {{.*#+}} xmm9 = xmm1[6,7,8,9,10,11,12,13,14,15,0,1,2,3,4,5]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15,0,1,2,3,4,5]
; AVX1-NEXT:    vmovdqa (%rsi), %xmm8
; AVX1-NEXT:    vmovdqa 16(%rsi), %xmm3
; AVX1-NEXT:    vpalignr {{.*#+}} xmm4 = xmm3[11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm5 = xmm8[11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10]
; AVX1-NEXT:    vmovdqa (%rdx), %xmm6
; AVX1-NEXT:    vmovdqa 16(%rdx), %xmm7
; AVX1-NEXT:    vpalignr {{.*#+}} xmm2 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm6[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm1 = xmm9[5,6,7,8,9,10,11,12,13,14,15],xmm7[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm10 = xmm5[5,6,7,8,9,10,11,12,13,14,15],xmm0[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm0 = xmm4[5,6,7,8,9,10,11,12,13,14,15],xmm9[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm5 = xmm6[5,6,7,8,9,10,11,12,13,14,15],xmm5[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm4 = xmm7[5,6,7,8,9,10,11,12,13,14,15],xmm4[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm3 = xmm1[5,6,7,8,9,10,11,12,13,14,15],xmm3[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm6 = xmm2[5,6,7,8,9,10,11,12,13,14,15],xmm8[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm4[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm7 = xmm10[5,6,7,8,9,10,11,12,13,14,15],xmm5[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm1 = xmm4[5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4]
; AVX1-NEXT:    vpalignr {{.*#+}} xmm2 = xmm5[5,6,7,8,9,10,11,12,13,14,15],xmm2[0,1,2,3,4]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5]
; AVX1-NEXT:    vpshufb %xmm4, %xmm7, %xmm5
; AVX1-NEXT:    vpshufb %xmm4, %xmm6, %xmm6
; AVX1-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpshufb %xmm4, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vmovdqa %xmm0, 64(%rcx)
; AVX1-NEXT:    vmovdqa %xmm1, 80(%rcx)
; AVX1-NEXT:    vmovdqa %xmm2, 32(%rcx)
; AVX1-NEXT:    vmovdqa %xmm3, 48(%rcx)
; AVX1-NEXT:    vmovdqa %xmm6, (%rcx)
; AVX1-NEXT:    vmovdqa %xmm5, 16(%rcx)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i8_stride3_vf32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovdqa (%rsi), %ymm1
; AVX2-NEXT:    vmovdqa (%rdx), %ymm2
; AVX2-NEXT:    vpalignr {{.*#+}} ymm0 = ymm0[6,7,8,9,10,11,12,13,14,15,0,1,2,3,4,5,22,23,24,25,26,27,28,29,30,31,16,17,18,19,20,21]
; AVX2-NEXT:    vpalignr {{.*#+}} ymm3 = ymm1[11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10,27,28,29,30,31,16,17,18,19,20,21,22,23,24,25,26]
; AVX2-NEXT:    vpalignr {{.*#+}} ymm4 = ymm0[5,6,7,8,9,10,11,12,13,14,15],ymm2[0,1,2,3,4],ymm0[21,22,23,24,25,26,27,28,29,30,31],ymm2[16,17,18,19,20]
; AVX2-NEXT:    vpalignr {{.*#+}} ymm0 = ymm3[5,6,7,8,9,10,11,12,13,14,15],ymm0[0,1,2,3,4],ymm3[21,22,23,24,25,26,27,28,29,30,31],ymm0[16,17,18,19,20]
; AVX2-NEXT:    vpalignr {{.*#+}} ymm2 = ymm2[5,6,7,8,9,10,11,12,13,14,15],ymm3[0,1,2,3,4],ymm2[21,22,23,24,25,26,27,28,29,30,31],ymm3[16,17,18,19,20]
; AVX2-NEXT:    vpalignr {{.*#+}} ymm1 = ymm4[5,6,7,8,9,10,11,12,13,14,15],ymm1[0,1,2,3,4],ymm4[21,22,23,24,25,26,27,28,29,30,31],ymm1[16,17,18,19,20]
; AVX2-NEXT:    vpalignr {{.*#+}} ymm0 = ymm0[5,6,7,8,9,10,11,12,13,14,15],ymm2[0,1,2,3,4],ymm0[21,22,23,24,25,26,27,28,29,30,31],ymm2[16,17,18,19,20]
; AVX2-NEXT:    vpalignr {{.*#+}} ymm2 = ymm2[5,6,7,8,9,10,11,12,13,14,15],ymm4[0,1,2,3,4],ymm2[21,22,23,24,25,26,27,28,29,30,31],ymm4[16,17,18,19,20]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm3
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm4 = [0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5,0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5]
; AVX2-NEXT:    vpshufb %ymm4, %ymm3, %ymm3
; AVX2-NEXT:    vpblendd {{.*#+}} ymm1 = ymm2[0,1,2,3],ymm1[4,5,6,7]
; AVX2-NEXT:    vpshufb %ymm4, %ymm1, %ymm1
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX2-NEXT:    vpshufb %ymm4, %ymm0, %ymm0
; AVX2-NEXT:    vmovdqa %ymm0, 64(%rcx)
; AVX2-NEXT:    vmovdqa %ymm1, 32(%rcx)
; AVX2-NEXT:    vmovdqa %ymm3, (%rcx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i8_stride3_vf32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512-NEXT:    vmovdqa (%rsi), %ymm1
; AVX512-NEXT:    vmovdqa (%rdx), %ymm2
; AVX512-NEXT:    vpalignr {{.*#+}} ymm0 = ymm0[6,7,8,9,10,11,12,13,14,15,0,1,2,3,4,5,22,23,24,25,26,27,28,29,30,31,16,17,18,19,20,21]
; AVX512-NEXT:    vpalignr {{.*#+}} ymm3 = ymm1[11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10,27,28,29,30,31,16,17,18,19,20,21,22,23,24,25,26]
; AVX512-NEXT:    vpalignr {{.*#+}} ymm4 = ymm0[5,6,7,8,9,10,11,12,13,14,15],ymm2[0,1,2,3,4],ymm0[21,22,23,24,25,26,27,28,29,30,31],ymm2[16,17,18,19,20]
; AVX512-NEXT:    vpalignr {{.*#+}} ymm0 = ymm3[5,6,7,8,9,10,11,12,13,14,15],ymm0[0,1,2,3,4],ymm3[21,22,23,24,25,26,27,28,29,30,31],ymm0[16,17,18,19,20]
; AVX512-NEXT:    vpalignr {{.*#+}} ymm2 = ymm2[5,6,7,8,9,10,11,12,13,14,15],ymm3[0,1,2,3,4],ymm2[21,22,23,24,25,26,27,28,29,30,31],ymm3[16,17,18,19,20]
; AVX512-NEXT:    vpalignr {{.*#+}} ymm1 = ymm4[5,6,7,8,9,10,11,12,13,14,15],ymm1[0,1,2,3,4],ymm4[21,22,23,24,25,26,27,28,29,30,31],ymm1[16,17,18,19,20]
; AVX512-NEXT:    vpalignr {{.*#+}} ymm0 = ymm0[5,6,7,8,9,10,11,12,13,14,15],ymm2[0,1,2,3,4],ymm0[21,22,23,24,25,26,27,28,29,30,31],ymm2[16,17,18,19,20]
; AVX512-NEXT:    vpalignr {{.*#+}} ymm2 = ymm2[5,6,7,8,9,10,11,12,13,14,15],ymm4[0,1,2,3,4],ymm2[21,22,23,24,25,26,27,28,29,30,31],ymm4[16,17,18,19,20]
; AVX512-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm3
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm4 = [0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5,0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5]
; AVX512-NEXT:    vpshufb %ymm4, %ymm3, %ymm3
; AVX512-NEXT:    vpblendd {{.*#+}} ymm1 = ymm2[0,1,2,3],ymm1[4,5,6,7]
; AVX512-NEXT:    vpshufb %ymm4, %ymm1, %ymm1
; AVX512-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX512-NEXT:    vpshufb %ymm4, %ymm0, %ymm0
; AVX512-NEXT:    vinserti64x4 $1, %ymm1, %zmm3, %zmm1
; AVX512-NEXT:    vmovdqa %ymm0, 64(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm1, (%rcx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <32 x i8>, <32 x i8>* %in.vecptr0, align 32
  %in.vec1 = load <32 x i8>, <32 x i8>* %in.vecptr1, align 32
  %in.vec2 = load <32 x i8>, <32 x i8>* %in.vecptr2, align 32

  %concat01 = shufflevector <32 x i8> %in.vec0, <32 x i8> %in.vec1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %concat2u = shufflevector <32 x i8> %in.vec2, <32 x i8> poison, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %concat012 = shufflevector <64 x i8> %concat01, <64 x i8> %concat2u, <96 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>
  %interleaved.vec = shufflevector <96 x i8> %concat012, <96 x i8> poison, <96 x i32> <i32 0, i32 32, i32 64, i32 1, i32 33, i32 65, i32 2, i32 34, i32 66, i32 3, i32 35, i32 67, i32 4, i32 36, i32 68, i32 5, i32 37, i32 69, i32 6, i32 38, i32 70, i32 7, i32 39, i32 71, i32 8, i32 40, i32 72, i32 9, i32 41, i32 73, i32 10, i32 42, i32 74, i32 11, i32 43, i32 75, i32 12, i32 44, i32 76, i32 13, i32 45, i32 77, i32 14, i32 46, i32 78, i32 15, i32 47, i32 79, i32 16, i32 48, i32 80, i32 17, i32 49, i32 81, i32 18, i32 50, i32 82, i32 19, i32 51, i32 83, i32 20, i32 52, i32 84, i32 21, i32 53, i32 85, i32 22, i32 54, i32 86, i32 23, i32 55, i32 87, i32 24, i32 56, i32 88, i32 25, i32 57, i32 89, i32 26, i32 58, i32 90, i32 27, i32 59, i32 91, i32 28, i32 60, i32 92, i32 29, i32 61, i32 93, i32 30, i32 62, i32 94, i32 31, i32 63, i32 95>

  store <96 x i8> %interleaved.vec, <96 x i8>* %out.vec, align 32

  ret void
}
