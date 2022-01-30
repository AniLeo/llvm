; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+avx512f  | FileCheck %s --check-prefixes=AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+avx512bw | FileCheck %s --check-prefixes=AVX512,AVX512BW

; trunc(concat(x,y)) -> pack

define <16 x i16> @trunc_concat_packssdw_256(<8 x i32> %a0, <8 x i32> %a1) nounwind {
; AVX1-LABEL: trunc_concat_packssdw_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrad $17, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrad $17, %xmm0, %xmm0
; AVX1-NEXT:    vpsrad $23, %xmm1, %xmm3
; AVX1-NEXT:    vpackssdw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vpsrad $23, %xmm1, %xmm1
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_concat_packssdw_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $17, %ymm0, %ymm0
; AVX2-NEXT:    vpsrad $23, %ymm1, %ymm1
; AVX2-NEXT:    vpackssdw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: trunc_concat_packssdw_256:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsrad $17, %ymm0, %ymm0
; AVX512-NEXT:    vpsrad $23, %ymm1, %ymm1
; AVX512-NEXT:    vperm2i128 {{.*#+}} ymm2 = ymm0[2,3],ymm1[2,3]
; AVX512-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512-NEXT:    vinserti64x4 $1, %ymm2, %zmm0, %zmm0
; AVX512-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512-NEXT:    retq
  %1 = ashr <8 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = ashr <8 x i32> %a1, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
  %3 = shufflevector <8 x i32> %1, <8 x i32> %2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  %4 = trunc <16 x i32> %3 to <16 x i16>
  ret <16 x i16> %4
}

define <16 x i16> @trunc_concat_packusdw_256(<8 x i32> %a0, <8 x i32> %a1) nounwind {
; AVX1-LABEL: trunc_concat_packusdw_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrld $17, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrld $17, %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpackusdw %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpackusdw %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_concat_packusdw_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrld $17, %ymm0, %ymm0
; AVX2-NEXT:    vpbroadcastd {{.*#+}} ymm2 = [15,15,15,15,15,15,15,15]
; AVX2-NEXT:    vpand %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    vpackusdw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: trunc_concat_packusdw_256:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsrld $17, %ymm0, %ymm0
; AVX512-NEXT:    vpandd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %ymm1, %ymm1
; AVX512-NEXT:    vperm2i128 {{.*#+}} ymm2 = ymm0[2,3],ymm1[2,3]
; AVX512-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512-NEXT:    vinserti64x4 $1, %ymm2, %zmm0, %zmm0
; AVX512-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512-NEXT:    retq
  %1 = lshr <8 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = and  <8 x i32> %a1, <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
  %3 = shufflevector <8 x i32> %1, <8 x i32> %2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  %4 = trunc <16 x i32> %3 to <16 x i16>
  ret <16 x i16> %4
}

define <32 x i8> @trunc_concat_packsswb_256(<16 x i16> %a0, <16 x i16> %a1) nounwind {
; AVX1-LABEL: trunc_concat_packsswb_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsraw $15, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsraw $15, %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpacksswb %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_concat_packsswb_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsraw $15, %ymm0, %ymm0
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_concat_packsswb_256:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsraw $15, %ymm0, %ymm0
; AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX512F-NEXT:    vperm2i128 {{.*#+}} ymm2 = ymm0[2,3],ymm1[2,3]
; AVX512F-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero,ymm2[8],zero,ymm2[9],zero,ymm2[10],zero,ymm2[11],zero,ymm2[12],zero,ymm2[13],zero,ymm2[14],zero,ymm2[15],zero
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: trunc_concat_packsswb_256:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsraw $15, %ymm0, %ymm0
; AVX512BW-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX512BW-NEXT:    vperm2i128 {{.*#+}} ymm2 = ymm0[2,3],ymm1[2,3]
; AVX512BW-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    retq
  %1 = ashr <16 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <16 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = shufflevector <16 x i16> %1, <16 x i16> %2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %4 = trunc <32 x i16> %3 to <32 x i8>
  ret <32 x i8> %4
}

define <32 x i8> @trunc_concat_packuswb_256(<16 x i16> %a0, <16 x i16> %a1) nounwind {
; AVX1-LABEL: trunc_concat_packuswb_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrlw $15, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrlw $15, %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpackuswb %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpackuswb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_concat_packuswb_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlw $15, %ymm0, %ymm0
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vpackuswb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_concat_packuswb_256:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsrlw $15, %ymm0, %ymm0
; AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX512F-NEXT:    vperm2i128 {{.*#+}} ymm2 = ymm0[2,3],ymm1[2,3]
; AVX512F-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero,ymm2[8],zero,ymm2[9],zero,ymm2[10],zero,ymm2[11],zero,ymm2[12],zero,ymm2[13],zero,ymm2[14],zero,ymm2[15],zero
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: trunc_concat_packuswb_256:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsrlw $15, %ymm0, %ymm0
; AVX512BW-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX512BW-NEXT:    vperm2i128 {{.*#+}} ymm2 = ymm0[2,3],ymm1[2,3]
; AVX512BW-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    retq
  %1 = lshr <16 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <16 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = shufflevector <16 x i16> %1, <16 x i16> %2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %4 = trunc <32 x i16> %3 to <32 x i8>
  ret <32 x i8> %4
}

; concat(trunc(x),trunc(y)) -> pack


define <16 x i16> @concat_trunc_packssdw_256(<8 x i32> %a0, <8 x i32> %a1) nounwind {
; AVX1-LABEL: concat_trunc_packssdw_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrad $17, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrad $17, %xmm0, %xmm0
; AVX1-NEXT:    vpsrad $23, %xmm1, %xmm3
; AVX1-NEXT:    vpackssdw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vpsrad $23, %xmm1, %xmm1
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: concat_trunc_packssdw_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $17, %ymm0, %ymm0
; AVX2-NEXT:    vpsrad $23, %ymm1, %ymm1
; AVX2-NEXT:    vpackssdw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: concat_trunc_packssdw_256:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsrad $17, %ymm0, %ymm0
; AVX512-NEXT:    vpsrad $23, %ymm1, %ymm1
; AVX512-NEXT:    vpmovdw %ymm0, %xmm0
; AVX512-NEXT:    vpmovdw %ymm1, %xmm1
; AVX512-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX512-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX512-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = ashr <8 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = ashr <8 x i32> %a1, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
  %3 = trunc <8 x i32> %1 to <8 x i16>
  %4 = trunc <8 x i32> %2 to <8 x i16>
  %5 = shufflevector <8 x i16> %3, <8 x i16> %4, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i16> %5
}

define <16 x i16> @concat_trunc_packusdw_256(<8 x i32> %a0, <8 x i32> %a1) nounwind {
; AVX1-LABEL: concat_trunc_packusdw_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpsrld $17, %xmm2, %xmm2
; AVX1-NEXT:    vpsrld $17, %xmm0, %xmm0
; AVX1-NEXT:    vpackusdw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vpackusdw %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: concat_trunc_packusdw_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrld $17, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX2-NEXT:    vpackusdw %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[0,1,4,5,8,9,12,13,u,u,u,u,u,u,u,u,16,17,20,21,24,25,28,29,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,2,3]
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: concat_trunc_packusdw_256:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsrld $17, %ymm0, %ymm0
; AVX512-NEXT:    vpmovdw %ymm0, %xmm0
; AVX512-NEXT:    vpmovdw %ymm1, %xmm1
; AVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX512-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX512-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX512-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %1 = lshr <8 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = and  <8 x i32> %a1, <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
  %3 = trunc <8 x i32> %1 to <8 x i16>
  %4 = trunc <8 x i32> %2 to <8 x i16>
  %5 = shufflevector <8 x i16> %3, <8 x i16> %4, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i16> %5
}

define <32 x i8> @concat_trunc_packsswb_256(<16 x i16> %a0, <16 x i16> %a1) nounwind {
; AVX1-LABEL: concat_trunc_packsswb_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpsraw $15, %xmm2, %xmm2
; AVX1-NEXT:    vpsraw $15, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: concat_trunc_packsswb_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsraw $15, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX2-NEXT:    vpacksswb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_trunc_packsswb_256:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsraw $15, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero,ymm1[8],zero,ymm1[9],zero,ymm1[10],zero,ymm1[11],zero,ymm1[12],zero,ymm1[13],zero,ymm1[14],zero,ymm1[15],zero
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX512F-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX512F-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX512F-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_trunc_packsswb_256:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsraw $15, %ymm0, %ymm0
; AVX512BW-NEXT:    vpmovwb %ymm0, %xmm0
; AVX512BW-NEXT:    vpmovwb %ymm1, %xmm1
; AVX512BW-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX512BW-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX512BW-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX512BW-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX512BW-NEXT:    retq
  %1 = ashr <16 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <16 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = trunc <16 x i16> %1 to <16 x i8>
  %4 = trunc <16 x i16> %2 to <16 x i8>
  %5 = shufflevector <16 x i8> %3, <16 x i8> %4, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <32 x i8> %5
}

define <32 x i8> @concat_trunc_packuswb_256(<16 x i16> %a0, <16 x i16> %a1) nounwind {
; AVX1-LABEL: concat_trunc_packuswb_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpsrlw $15, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $15, %xmm0, %xmm0
; AVX1-NEXT:    vpackuswb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: concat_trunc_packuswb_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlw $15, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX2-NEXT:    vpackuswb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vpackuswb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_trunc_packuswb_256:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpsrlw $15, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero,ymm1[8],zero,ymm1[9],zero,ymm1[10],zero,ymm1[11],zero,ymm1[12],zero,ymm1[13],zero,ymm1[14],zero,ymm1[15],zero
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX512F-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX512F-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX512F-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_trunc_packuswb_256:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsrlw $15, %ymm0, %ymm0
; AVX512BW-NEXT:    vpmovwb %ymm0, %xmm0
; AVX512BW-NEXT:    vpmovwb %ymm1, %xmm1
; AVX512BW-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX512BW-NEXT:    vpunpckhqdq {{.*#+}} xmm2 = xmm0[1],xmm1[1]
; AVX512BW-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX512BW-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX512BW-NEXT:    retq
  %1 = lshr <16 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <16 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = trunc <16 x i16> %1 to <16 x i8>
  %4 = trunc <16 x i16> %2 to <16 x i8>
  %5 = shufflevector <16 x i8> %3, <16 x i8> %4, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <32 x i8> %5
}
