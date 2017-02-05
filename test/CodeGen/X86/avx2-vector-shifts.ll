; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mcpu=core-avx2 -mattr=+avx2 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=core-avx2 -mattr=+avx2 | FileCheck %s --check-prefix=X64

; AVX2 Logical Shift Left

define <16 x i16> @test_sllw_1(<16 x i16> %InVec) {
; X32-LABEL: test_sllw_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_sllw_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = shl <16 x i16> %InVec, <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <16 x i16> %shl
}

define <16 x i16> @test_sllw_2(<16 x i16> %InVec) {
; X32-LABEL: test_sllw_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpaddw %ymm0, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_sllw_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpaddw %ymm0, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = shl <16 x i16> %InVec, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <16 x i16> %shl
}

define <16 x i16> @test_sllw_3(<16 x i16> %InVec) {
; X32-LABEL: test_sllw_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsllw $15, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_sllw_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsllw $15, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = shl <16 x i16> %InVec, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  ret <16 x i16> %shl
}

define <8 x i32> @test_slld_1(<8 x i32> %InVec) {
; X32-LABEL: test_slld_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_slld_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = shl <8 x i32> %InVec, <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  ret <8 x i32> %shl
}

define <8 x i32> @test_slld_2(<8 x i32> %InVec) {
; X32-LABEL: test_slld_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpaddd %ymm0, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_slld_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpaddd %ymm0, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = shl <8 x i32> %InVec, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  ret <8 x i32> %shl
}

define <8 x i32> @test_vpslld_var(i32 %shift) {
; X32-LABEL: test_vpslld_var:
; X32:       ## BB#0:
; X32-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    vmovdqa {{.*#+}} ymm1 = [192,193,194,195,196,197,198,199]
; X32-NEXT:    vpslld %xmm0, %ymm1, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_vpslld_var:
; X64:       ## BB#0:
; X64-NEXT:    vmovd %edi, %xmm0
; X64-NEXT:    vmovdqa {{.*#+}} ymm1 = [192,193,194,195,196,197,198,199]
; X64-NEXT:    vpslld %xmm0, %ymm1, %ymm0
; X64-NEXT:    retq
  %amt = insertelement <8 x i32> undef, i32 %shift, i32 0
  %tmp = shl <8 x i32> <i32 192, i32 193, i32 194, i32 195, i32 196, i32 197, i32 198, i32 199>, %amt
  ret <8 x i32> %tmp
}

define <8 x i32> @test_slld_3(<8 x i32> %InVec) {
; X32-LABEL: test_slld_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpslld $31, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_slld_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpslld $31, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = shl <8 x i32> %InVec, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  ret <8 x i32> %shl
}

define <4 x i64> @test_sllq_1(<4 x i64> %InVec) {
; X32-LABEL: test_sllq_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_sllq_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = shl <4 x i64> %InVec, <i64 0, i64 0, i64 0, i64 0>
  ret <4 x i64> %shl
}

define <4 x i64> @test_sllq_2(<4 x i64> %InVec) {
; X32-LABEL: test_sllq_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpaddq %ymm0, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_sllq_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpaddq %ymm0, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = shl <4 x i64> %InVec, <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i64> %shl
}

define <4 x i64> @test_sllq_3(<4 x i64> %InVec) {
; X32-LABEL: test_sllq_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsllq $63, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_sllq_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsllq $63, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = shl <4 x i64> %InVec, <i64 63, i64 63, i64 63, i64 63>
  ret <4 x i64> %shl
}

; AVX2 Arithmetic Shift

define <16 x i16> @test_sraw_1(<16 x i16> %InVec) {
; X32-LABEL: test_sraw_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_sraw_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = ashr <16 x i16> %InVec, <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <16 x i16> %shl
}

define <16 x i16> @test_sraw_2(<16 x i16> %InVec) {
; X32-LABEL: test_sraw_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsraw $1, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_sraw_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsraw $1, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = ashr <16 x i16> %InVec, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <16 x i16> %shl
}

define <16 x i16> @test_sraw_3(<16 x i16> %InVec) {
; X32-LABEL: test_sraw_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsraw $15, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_sraw_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsraw $15, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = ashr <16 x i16> %InVec, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  ret <16 x i16> %shl
}

define <8 x i32> @test_srad_1(<8 x i32> %InVec) {
; X32-LABEL: test_srad_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_srad_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = ashr <8 x i32> %InVec, <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  ret <8 x i32> %shl
}

define <8 x i32> @test_srad_2(<8 x i32> %InVec) {
; X32-LABEL: test_srad_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrad $1, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srad_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrad $1, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = ashr <8 x i32> %InVec, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  ret <8 x i32> %shl
}

define <8 x i32> @test_srad_3(<8 x i32> %InVec) {
; X32-LABEL: test_srad_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrad $31, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srad_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrad $31, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = ashr <8 x i32> %InVec, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  ret <8 x i32> %shl
}

; SSE Logical Shift Right

define <16 x i16> @test_srlw_1(<16 x i16> %InVec) {
; X32-LABEL: test_srlw_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_srlw_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = lshr <16 x i16> %InVec, <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>
  ret <16 x i16> %shl
}

define <16 x i16> @test_srlw_2(<16 x i16> %InVec) {
; X32-LABEL: test_srlw_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrlw $1, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srlw_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrlw $1, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = lshr <16 x i16> %InVec, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <16 x i16> %shl
}

define <16 x i16> @test_srlw_3(<16 x i16> %InVec) {
; X32-LABEL: test_srlw_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrlw $15, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srlw_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrlw $15, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = lshr <16 x i16> %InVec, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  ret <16 x i16> %shl
}

define <8 x i32> @test_srld_1(<8 x i32> %InVec) {
; X32-LABEL: test_srld_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_srld_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = lshr <8 x i32> %InVec, <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  ret <8 x i32> %shl
}

define <8 x i32> @test_srld_2(<8 x i32> %InVec) {
; X32-LABEL: test_srld_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrld $1, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srld_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrld $1, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = lshr <8 x i32> %InVec, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  ret <8 x i32> %shl
}

define <8 x i32> @test_srld_3(<8 x i32> %InVec) {
; X32-LABEL: test_srld_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrld $31, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srld_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrld $31, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = lshr <8 x i32> %InVec, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  ret <8 x i32> %shl
}

define <4 x i64> @test_srlq_1(<4 x i64> %InVec) {
; X32-LABEL: test_srlq_1:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    retl
;
; X64-LABEL: test_srlq_1:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    retq
entry:
  %shl = lshr <4 x i64> %InVec, <i64 0, i64 0, i64 0, i64 0>
  ret <4 x i64> %shl
}

define <4 x i64> @test_srlq_2(<4 x i64> %InVec) {
; X32-LABEL: test_srlq_2:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrlq $1, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srlq_2:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrlq $1, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = lshr <4 x i64> %InVec, <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i64> %shl
}

define <4 x i64> @test_srlq_3(<4 x i64> %InVec) {
; X32-LABEL: test_srlq_3:
; X32:       ## BB#0: ## %entry
; X32-NEXT:    vpsrlq $63, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_srlq_3:
; X64:       ## BB#0: ## %entry
; X64-NEXT:    vpsrlq $63, %ymm0, %ymm0
; X64-NEXT:    retq
entry:
  %shl = lshr <4 x i64> %InVec, <i64 63, i64 63, i64 63, i64 63>
  ret <4 x i64> %shl
}

define <4 x i32> @srl_trunc_and_v4i64(<4 x i32> %x, <4 x i64> %y) nounwind {
; X32-LABEL: srl_trunc_and_v4i64:
; X32:       ## BB#0:
; X32-NEXT:    vpshufd {{.*#+}} ymm1 = ymm1[0,2,2,3,4,6,6,7]
; X32-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,2,3]
; X32-NEXT:    vpbroadcastd LCPI25_0, %xmm2
; X32-NEXT:    vpand %xmm2, %xmm1, %xmm1
; X32-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: srl_trunc_and_v4i64:
; X64:       ## BB#0:
; X64-NEXT:    vpshufd {{.*#+}} ymm1 = ymm1[0,2,2,3,4,6,6,7]
; X64-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,2,3]
; X64-NEXT:    vpbroadcastd {{.*}}(%rip), %xmm2
; X64-NEXT:    vpand %xmm2, %xmm1, %xmm1
; X64-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %and = and <4 x i64> %y, <i64 8, i64 8, i64 8, i64 8>
  %trunc = trunc <4 x i64> %and to <4 x i32>
  %sra = lshr <4 x i32> %x, %trunc
  ret <4 x i32> %sra
}

;
; Vectorized byte shifts
;

define <8 x i16> @shl_8i16(<8 x i16> %r, <8 x i16> %a) nounwind {
; X32-LABEL: shl_8i16:
; X32:       ## BB#0:
; X32-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; X32-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X32-NEXT:    vpsllvd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X32-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X32-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: shl_8i16:
; X64:       ## BB#0:
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    vpsllvd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X64-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X64-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %shl = shl <8 x i16> %r, %a
  ret <8 x i16> %shl
}

define <16 x i16> @shl_16i16(<16 x i16> %r, <16 x i16> %a) nounwind {
; X32-LABEL: shl_16i16:
; X32:       ## BB#0:
; X32-NEXT:    vpxor %ymm2, %ymm2, %ymm2
; X32-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm1[4],ymm2[4],ymm1[5],ymm2[5],ymm1[6],ymm2[6],ymm1[7],ymm2[7],ymm1[12],ymm2[12],ymm1[13],ymm2[13],ymm1[14],ymm2[14],ymm1[15],ymm2[15]
; X32-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm2[4],ymm0[4],ymm2[5],ymm0[5],ymm2[6],ymm0[6],ymm2[7],ymm0[7],ymm2[12],ymm0[12],ymm2[13],ymm0[13],ymm2[14],ymm0[14],ymm2[15],ymm0[15]
; X32-NEXT:    vpsllvd %ymm3, %ymm4, %ymm3
; X32-NEXT:    vpsrld $16, %ymm3, %ymm3
; X32-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm1[0],ymm2[0],ymm1[1],ymm2[1],ymm1[2],ymm2[2],ymm1[3],ymm2[3],ymm1[8],ymm2[8],ymm1[9],ymm2[9],ymm1[10],ymm2[10],ymm1[11],ymm2[11]
; X32-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm2[0],ymm0[0],ymm2[1],ymm0[1],ymm2[2],ymm0[2],ymm2[3],ymm0[3],ymm2[8],ymm0[8],ymm2[9],ymm0[9],ymm2[10],ymm0[10],ymm2[11],ymm0[11]
; X32-NEXT:    vpsllvd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpsrld $16, %ymm0, %ymm0
; X32-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: shl_16i16:
; X64:       ## BB#0:
; X64-NEXT:    vpxor %ymm2, %ymm2, %ymm2
; X64-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm1[4],ymm2[4],ymm1[5],ymm2[5],ymm1[6],ymm2[6],ymm1[7],ymm2[7],ymm1[12],ymm2[12],ymm1[13],ymm2[13],ymm1[14],ymm2[14],ymm1[15],ymm2[15]
; X64-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm2[4],ymm0[4],ymm2[5],ymm0[5],ymm2[6],ymm0[6],ymm2[7],ymm0[7],ymm2[12],ymm0[12],ymm2[13],ymm0[13],ymm2[14],ymm0[14],ymm2[15],ymm0[15]
; X64-NEXT:    vpsllvd %ymm3, %ymm4, %ymm3
; X64-NEXT:    vpsrld $16, %ymm3, %ymm3
; X64-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm1[0],ymm2[0],ymm1[1],ymm2[1],ymm1[2],ymm2[2],ymm1[3],ymm2[3],ymm1[8],ymm2[8],ymm1[9],ymm2[9],ymm1[10],ymm2[10],ymm1[11],ymm2[11]
; X64-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm2[0],ymm0[0],ymm2[1],ymm0[1],ymm2[2],ymm0[2],ymm2[3],ymm0[3],ymm2[8],ymm0[8],ymm2[9],ymm0[9],ymm2[10],ymm0[10],ymm2[11],ymm0[11]
; X64-NEXT:    vpsllvd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpsrld $16, %ymm0, %ymm0
; X64-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; X64-NEXT:    retq
  %shl = shl <16 x i16> %r, %a
  ret <16 x i16> %shl
}

define <32 x i8> @shl_32i8(<32 x i8> %r, <32 x i8> %a) nounwind {
; X32-LABEL: shl_32i8:
; X32:       ## BB#0:
; X32-NEXT:    vpsllw $5, %ymm1, %ymm1
; X32-NEXT:    vpsllw $4, %ymm0, %ymm2
; X32-NEXT:    vpand LCPI28_0, %ymm2, %ymm2
; X32-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X32-NEXT:    vpsllw $2, %ymm0, %ymm2
; X32-NEXT:    vpand LCPI28_1, %ymm2, %ymm2
; X32-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X32-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X32-NEXT:    vpaddb %ymm0, %ymm0, %ymm2
; X32-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X32-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: shl_32i8:
; X64:       ## BB#0:
; X64-NEXT:    vpsllw $5, %ymm1, %ymm1
; X64-NEXT:    vpsllw $4, %ymm0, %ymm2
; X64-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; X64-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X64-NEXT:    vpsllw $2, %ymm0, %ymm2
; X64-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; X64-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X64-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X64-NEXT:    vpaddb %ymm0, %ymm0, %ymm2
; X64-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X64-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X64-NEXT:    retq
  %shl = shl <32 x i8> %r, %a
  ret <32 x i8> %shl
}

define <8 x i16> @ashr_8i16(<8 x i16> %r, <8 x i16> %a) nounwind {
; X32-LABEL: ashr_8i16:
; X32:       ## BB#0:
; X32-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; X32-NEXT:    vpmovsxwd %xmm0, %ymm0
; X32-NEXT:    vpsravd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X32-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X32-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: ashr_8i16:
; X64:       ## BB#0:
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; X64-NEXT:    vpmovsxwd %xmm0, %ymm0
; X64-NEXT:    vpsravd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X64-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X64-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ashr = ashr <8 x i16> %r, %a
  ret <8 x i16> %ashr
}

define <16 x i16> @ashr_16i16(<16 x i16> %r, <16 x i16> %a) nounwind {
; X32-LABEL: ashr_16i16:
; X32:       ## BB#0:
; X32-NEXT:    vpxor %ymm2, %ymm2, %ymm2
; X32-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm1[4],ymm2[4],ymm1[5],ymm2[5],ymm1[6],ymm2[6],ymm1[7],ymm2[7],ymm1[12],ymm2[12],ymm1[13],ymm2[13],ymm1[14],ymm2[14],ymm1[15],ymm2[15]
; X32-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm2[4],ymm0[4],ymm2[5],ymm0[5],ymm2[6],ymm0[6],ymm2[7],ymm0[7],ymm2[12],ymm0[12],ymm2[13],ymm0[13],ymm2[14],ymm0[14],ymm2[15],ymm0[15]
; X32-NEXT:    vpsravd %ymm3, %ymm4, %ymm3
; X32-NEXT:    vpsrld $16, %ymm3, %ymm3
; X32-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm1[0],ymm2[0],ymm1[1],ymm2[1],ymm1[2],ymm2[2],ymm1[3],ymm2[3],ymm1[8],ymm2[8],ymm1[9],ymm2[9],ymm1[10],ymm2[10],ymm1[11],ymm2[11]
; X32-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm2[0],ymm0[0],ymm2[1],ymm0[1],ymm2[2],ymm0[2],ymm2[3],ymm0[3],ymm2[8],ymm0[8],ymm2[9],ymm0[9],ymm2[10],ymm0[10],ymm2[11],ymm0[11]
; X32-NEXT:    vpsravd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpsrld $16, %ymm0, %ymm0
; X32-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: ashr_16i16:
; X64:       ## BB#0:
; X64-NEXT:    vpxor %ymm2, %ymm2, %ymm2
; X64-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm1[4],ymm2[4],ymm1[5],ymm2[5],ymm1[6],ymm2[6],ymm1[7],ymm2[7],ymm1[12],ymm2[12],ymm1[13],ymm2[13],ymm1[14],ymm2[14],ymm1[15],ymm2[15]
; X64-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm2[4],ymm0[4],ymm2[5],ymm0[5],ymm2[6],ymm0[6],ymm2[7],ymm0[7],ymm2[12],ymm0[12],ymm2[13],ymm0[13],ymm2[14],ymm0[14],ymm2[15],ymm0[15]
; X64-NEXT:    vpsravd %ymm3, %ymm4, %ymm3
; X64-NEXT:    vpsrld $16, %ymm3, %ymm3
; X64-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm1[0],ymm2[0],ymm1[1],ymm2[1],ymm1[2],ymm2[2],ymm1[3],ymm2[3],ymm1[8],ymm2[8],ymm1[9],ymm2[9],ymm1[10],ymm2[10],ymm1[11],ymm2[11]
; X64-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm2[0],ymm0[0],ymm2[1],ymm0[1],ymm2[2],ymm0[2],ymm2[3],ymm0[3],ymm2[8],ymm0[8],ymm2[9],ymm0[9],ymm2[10],ymm0[10],ymm2[11],ymm0[11]
; X64-NEXT:    vpsravd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpsrld $16, %ymm0, %ymm0
; X64-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; X64-NEXT:    retq
  %ashr = ashr <16 x i16> %r, %a
  ret <16 x i16> %ashr
}

define <32 x i8> @ashr_32i8(<32 x i8> %r, <32 x i8> %a) nounwind {
; X32-LABEL: ashr_32i8:
; X32:       ## BB#0:
; X32-NEXT:    vpsllw $5, %ymm1, %ymm1
; X32-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
; X32-NEXT:    vpunpckhbw {{.*#+}} ymm3 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; X32-NEXT:    vpsraw $4, %ymm3, %ymm4
; X32-NEXT:    vpblendvb %ymm2, %ymm4, %ymm3, %ymm3
; X32-NEXT:    vpsraw $2, %ymm3, %ymm4
; X32-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; X32-NEXT:    vpblendvb %ymm2, %ymm4, %ymm3, %ymm3
; X32-NEXT:    vpsraw $1, %ymm3, %ymm4
; X32-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; X32-NEXT:    vpblendvb %ymm2, %ymm4, %ymm3, %ymm2
; X32-NEXT:    vpsrlw $8, %ymm2, %ymm2
; X32-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
; X32-NEXT:    vpunpcklbw {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; X32-NEXT:    vpsraw $4, %ymm0, %ymm3
; X32-NEXT:    vpblendvb %ymm1, %ymm3, %ymm0, %ymm0
; X32-NEXT:    vpsraw $2, %ymm0, %ymm3
; X32-NEXT:    vpaddw %ymm1, %ymm1, %ymm1
; X32-NEXT:    vpblendvb %ymm1, %ymm3, %ymm0, %ymm0
; X32-NEXT:    vpsraw $1, %ymm0, %ymm3
; X32-NEXT:    vpaddw %ymm1, %ymm1, %ymm1
; X32-NEXT:    vpblendvb %ymm1, %ymm3, %ymm0, %ymm0
; X32-NEXT:    vpsrlw $8, %ymm0, %ymm0
; X32-NEXT:    vpackuswb %ymm2, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: ashr_32i8:
; X64:       ## BB#0:
; X64-NEXT:    vpsllw $5, %ymm1, %ymm1
; X64-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
; X64-NEXT:    vpunpckhbw {{.*#+}} ymm3 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; X64-NEXT:    vpsraw $4, %ymm3, %ymm4
; X64-NEXT:    vpblendvb %ymm2, %ymm4, %ymm3, %ymm3
; X64-NEXT:    vpsraw $2, %ymm3, %ymm4
; X64-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; X64-NEXT:    vpblendvb %ymm2, %ymm4, %ymm3, %ymm3
; X64-NEXT:    vpsraw $1, %ymm3, %ymm4
; X64-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; X64-NEXT:    vpblendvb %ymm2, %ymm4, %ymm3, %ymm2
; X64-NEXT:    vpsrlw $8, %ymm2, %ymm2
; X64-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
; X64-NEXT:    vpunpcklbw {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; X64-NEXT:    vpsraw $4, %ymm0, %ymm3
; X64-NEXT:    vpblendvb %ymm1, %ymm3, %ymm0, %ymm0
; X64-NEXT:    vpsraw $2, %ymm0, %ymm3
; X64-NEXT:    vpaddw %ymm1, %ymm1, %ymm1
; X64-NEXT:    vpblendvb %ymm1, %ymm3, %ymm0, %ymm0
; X64-NEXT:    vpsraw $1, %ymm0, %ymm3
; X64-NEXT:    vpaddw %ymm1, %ymm1, %ymm1
; X64-NEXT:    vpblendvb %ymm1, %ymm3, %ymm0, %ymm0
; X64-NEXT:    vpsrlw $8, %ymm0, %ymm0
; X64-NEXT:    vpackuswb %ymm2, %ymm0, %ymm0
; X64-NEXT:    retq
  %ashr = ashr <32 x i8> %r, %a
  ret <32 x i8> %ashr
}

define <8 x i16> @lshr_8i16(<8 x i16> %r, <8 x i16> %a) nounwind {
; X32-LABEL: lshr_8i16:
; X32:       ## BB#0:
; X32-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; X32-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X32-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X32-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X32-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: lshr_8i16:
; X64:       ## BB#0:
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X64-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X64-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %lshr = lshr <8 x i16> %r, %a
  ret <8 x i16> %lshr
}

define <16 x i16> @lshr_16i16(<16 x i16> %r, <16 x i16> %a) nounwind {
; X32-LABEL: lshr_16i16:
; X32:       ## BB#0:
; X32-NEXT:    vpxor %ymm2, %ymm2, %ymm2
; X32-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm1[4],ymm2[4],ymm1[5],ymm2[5],ymm1[6],ymm2[6],ymm1[7],ymm2[7],ymm1[12],ymm2[12],ymm1[13],ymm2[13],ymm1[14],ymm2[14],ymm1[15],ymm2[15]
; X32-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm2[4],ymm0[4],ymm2[5],ymm0[5],ymm2[6],ymm0[6],ymm2[7],ymm0[7],ymm2[12],ymm0[12],ymm2[13],ymm0[13],ymm2[14],ymm0[14],ymm2[15],ymm0[15]
; X32-NEXT:    vpsrlvd %ymm3, %ymm4, %ymm3
; X32-NEXT:    vpsrld $16, %ymm3, %ymm3
; X32-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm1[0],ymm2[0],ymm1[1],ymm2[1],ymm1[2],ymm2[2],ymm1[3],ymm2[3],ymm1[8],ymm2[8],ymm1[9],ymm2[9],ymm1[10],ymm2[10],ymm1[11],ymm2[11]
; X32-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm2[0],ymm0[0],ymm2[1],ymm0[1],ymm2[2],ymm0[2],ymm2[3],ymm0[3],ymm2[8],ymm0[8],ymm2[9],ymm0[9],ymm2[10],ymm0[10],ymm2[11],ymm0[11]
; X32-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpsrld $16, %ymm0, %ymm0
; X32-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: lshr_16i16:
; X64:       ## BB#0:
; X64-NEXT:    vpxor %ymm2, %ymm2, %ymm2
; X64-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm1[4],ymm2[4],ymm1[5],ymm2[5],ymm1[6],ymm2[6],ymm1[7],ymm2[7],ymm1[12],ymm2[12],ymm1[13],ymm2[13],ymm1[14],ymm2[14],ymm1[15],ymm2[15]
; X64-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm2[4],ymm0[4],ymm2[5],ymm0[5],ymm2[6],ymm0[6],ymm2[7],ymm0[7],ymm2[12],ymm0[12],ymm2[13],ymm0[13],ymm2[14],ymm0[14],ymm2[15],ymm0[15]
; X64-NEXT:    vpsrlvd %ymm3, %ymm4, %ymm3
; X64-NEXT:    vpsrld $16, %ymm3, %ymm3
; X64-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm1[0],ymm2[0],ymm1[1],ymm2[1],ymm1[2],ymm2[2],ymm1[3],ymm2[3],ymm1[8],ymm2[8],ymm1[9],ymm2[9],ymm1[10],ymm2[10],ymm1[11],ymm2[11]
; X64-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm2[0],ymm0[0],ymm2[1],ymm0[1],ymm2[2],ymm0[2],ymm2[3],ymm0[3],ymm2[8],ymm0[8],ymm2[9],ymm0[9],ymm2[10],ymm0[10],ymm2[11],ymm0[11]
; X64-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpsrld $16, %ymm0, %ymm0
; X64-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; X64-NEXT:    retq
  %lshr = lshr <16 x i16> %r, %a
  ret <16 x i16> %lshr
}

define <32 x i8> @lshr_32i8(<32 x i8> %r, <32 x i8> %a) nounwind {
; X32-LABEL: lshr_32i8:
; X32:       ## BB#0:
; X32-NEXT:    vpsllw $5, %ymm1, %ymm1
; X32-NEXT:    vpsrlw $4, %ymm0, %ymm2
; X32-NEXT:    vpand LCPI34_0, %ymm2, %ymm2
; X32-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X32-NEXT:    vpsrlw $2, %ymm0, %ymm2
; X32-NEXT:    vpand LCPI34_1, %ymm2, %ymm2
; X32-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X32-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X32-NEXT:    vpsrlw $1, %ymm0, %ymm2
; X32-NEXT:    vpand LCPI34_2, %ymm2, %ymm2
; X32-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X32-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: lshr_32i8:
; X64:       ## BB#0:
; X64-NEXT:    vpsllw $5, %ymm1, %ymm1
; X64-NEXT:    vpsrlw $4, %ymm0, %ymm2
; X64-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; X64-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X64-NEXT:    vpsrlw $2, %ymm0, %ymm2
; X64-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; X64-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X64-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X64-NEXT:    vpsrlw $1, %ymm0, %ymm2
; X64-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; X64-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; X64-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; X64-NEXT:    retq
  %lshr = lshr <32 x i8> %r, %a
  ret <32 x i8> %lshr
}
