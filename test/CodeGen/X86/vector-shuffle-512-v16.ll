; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=x86-64 -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefix=ALL --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mcpu=x86-64 -mattr=+avx512bw,+avx512dq | FileCheck %s --check-prefix=ALL --check-prefix=AVX512 --check-prefix=AVX512BW

target triple = "x86_64-unknown-unknown"

define <16 x float> @shuffle_v16f32_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00:
; ALL:       # %bb.0:
; ALL-NEXT:    vbroadcastss %xmm0, %zmm0
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32><i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf32x4 $2, %zmm0, %xmm0
; ALL-NEXT:    vbroadcastss %xmm0, %zmm0
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32><i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08_bc(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16f32_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08_08_bc:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf32x4 $2, %zmm0, %xmm0
; ALL-NEXT:    vbroadcastss %xmm0, %zmm0
; ALL-NEXT:    retq
  %tmp0 = bitcast <16 x i32> %a to <16 x float>
  %tmp1 = bitcast <16 x i32> %b to <16 x float>
  %shuffle = shufflevector <16 x float> %tmp0, <16 x float> %tmp1, <16 x i32><i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_00_10_01_11_04_14_05_15_08_18_09_19_0c_1c_0d_1d(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_00_10_01_11_04_14_05_15_08_18_09_19_0c_1c_0d_1d:
; ALL:       # %bb.0:
; ALL-NEXT:    vunpcklps {{.*#+}} zmm0 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[12],zmm1[12],zmm0[13],zmm1[13]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32><i32 0, i32 16, i32 1, i32 17, i32 4, i32 20, i32 5, i32 21, i32 8, i32 24, i32 9, i32 25, i32 12, i32 28, i32 13, i32 29>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_00_zz_01_zz_04_zz_05_zz_08_zz_09_zz_0c_zz_0d_zz(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_00_zz_01_zz_04_zz_05_zz_08_zz_09_zz_0c_zz_0d_zz:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vunpcklps {{.*#+}} zmm0 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[12],zmm1[12],zmm0[13],zmm1[13]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> zeroinitializer, <16 x i32><i32 0, i32 16, i32 1, i32 16, i32 4, i32 16, i32 5, i32 16, i32 8, i32 16, i32 9, i32 16, i32 12, i32 16, i32 13, i32 16>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_vunpcklps_swap(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_vunpcklps_swap:
; ALL:       # %bb.0:
; ALL-NEXT:    vunpcklps {{.*#+}} zmm0 = zmm1[0],zmm0[0],zmm1[1],zmm0[1],zmm1[4],zmm0[4],zmm1[5],zmm0[5],zmm1[8],zmm0[8],zmm1[9],zmm0[9],zmm1[12],zmm0[12],zmm1[13],zmm0[13]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 16, i32 0, i32 17, i32 1, i32 20, i32 4, i32 21, i32 5, i32 24, i32 8, i32 25, i32 9, i32 28, i32 12, i32 29, i32 13>
  ret <16 x float> %shuffle
}

; PR34382
define <16 x float> @shuffle_v16f32_01_01_03_00_06_04_05_07_08_08_09_09_15_14_14_12(<16 x float> %a0) {
; ALL-LABEL: shuffle_v16f32_01_01_03_00_06_04_05_07_08_08_09_09_15_14_14_12:
; ALL:       # %bb.0:
; ALL-NEXT:    vpermilps {{.*#+}} zmm0 = zmm0[1,1,3,0,6,4,5,7,8,8,9,9,15,14,14,12]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a0, <16 x float> undef, <16 x i32> <i32 1, i32 1, i32 3, i32 0, i32 6, i32 4, i32 5, i32 7, i32 8, i32 8, i32 9, i32 9, i32 15, i32 14, i32 14, i32 12>
  ret <16 x float> %shuffle
}

define <16 x i32> @shuffle_v16i32_00_10_01_11_04_14_05_15_08_18_09_19_0c_1c_0d_1d(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_00_10_01_11_04_14_05_15_08_18_09_19_0c_1c_0d_1d:
; ALL:       # %bb.0:
; ALL-NEXT:    vunpcklps {{.*#+}} zmm0 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[12],zmm1[12],zmm0[13],zmm1[13]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 0, i32 16, i32 1, i32 17, i32 4, i32 20, i32 5, i32 21, i32 8, i32 24, i32 9, i32 25, i32 12, i32 28, i32 13, i32 29>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_zz_10_zz_11_zz_14_zz_15_zz_18_zz_19_zz_1c_zz_1d(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_zz_10_zz_11_zz_14_zz_15_zz_18_zz_19_zz_1c_zz_1d:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; ALL-NEXT:    vunpcklps {{.*#+}} zmm0 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[12],zmm1[12],zmm0[13],zmm1[13]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> zeroinitializer, <16 x i32> %b, <16 x i32><i32 15, i32 16, i32 13, i32 17, i32 11, i32 20, i32 9, i32 21, i32 7, i32 24, i32 5, i32 25, i32 3, i32 28, i32 1, i32 29>
  ret <16 x i32> %shuffle
}

define <16 x float> @shuffle_v16f32_02_12_03_13_06_16_07_17_0a_1a_0b_1b_0e_1e_0f_1f(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_02_12_03_13_06_16_07_17_0a_1a_0b_1b_0e_1e_0f_1f:
; ALL:       # %bb.0:
; ALL-NEXT:    vunpckhps {{.*#+}} zmm0 = zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[14],zmm1[14],zmm0[15],zmm1[15]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32><i32 2, i32 18, i32 3, i32 19, i32 6, i32 22, i32 7, i32 23, i32 10, i32 26, i32 11, i32 27, i32 14, i32 30, i32 15, i32 31>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_zz_12_zz_13_zz_16_zz_17_zz_1a_zz_1b_zz_1e_zz_1f(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_zz_12_zz_13_zz_16_zz_17_zz_1a_zz_1b_zz_1e_zz_1f:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; ALL-NEXT:    vunpckhps {{.*#+}} zmm0 = zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[14],zmm1[14],zmm0[15],zmm1[15]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> zeroinitializer, <16 x float> %b, <16 x i32><i32 0, i32 18, i32 0, i32 19, i32 4, i32 22, i32 4, i32 23, i32 6, i32 26, i32 6, i32 27, i32 8, i32 30, i32 8, i32 31>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_00_00_02_02_04_04_06_06_08_08_10_10_12_12_14_14(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_00_00_02_02_04_04_06_06_08_08_10_10_12_12_14_14:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovsldup {{.*#+}} zmm0 = zmm0[0,0,2,2,4,4,6,6,8,8,10,10,12,12,14,14]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32><i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6, i32 8, i32 8, i32 10, i32 10, i32 12, i32 12, i32 14, i32 14>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_01_01_03_03_05_05_07_07_09_09_11_11_13_13_15_15(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_01_01_03_03_05_05_07_07_09_09_11_11_13_13_15_15:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovshdup {{.*#+}} zmm0 = zmm0[1,1,3,3,5,5,7,7,9,9,11,11,13,13,15,15]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32><i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7, i32 9, i32 9, i32 11, i32 11, i32 13, i32 13, i32 15, i32 15>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_00_01_00_01_06_07_06_07_08_09_10_11_12_13_12_13(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_00_01_00_01_06_07_06_07_08_09_10_11_12_13_12_13:
; ALL:       # %bb.0:
; ALL-NEXT:    vpermilpd {{.*#+}} zmm0 = zmm0[0,0,3,3,4,5,6,6]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 0, i32 1, i32 0, i32 1, i32 6, i32 7, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 12, i32 13>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_00_00_02_00_04_04_06_04_08_08_10_08_12_12_14_12(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_00_00_02_00_04_04_06_04_08_08_10_08_12_12_14_12:
; ALL:       # %bb.0:
; ALL-NEXT:    vpermilps {{.*#+}} zmm0 = zmm0[0,0,2,0,4,4,6,4,8,8,10,8,12,12,14,12]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 0, i32 0, i32 2, i32 0, i32 4, i32 4, i32 6, i32 4, i32 8, i32 8, i32 10, i32 8, i32 12, i32 12, i32 14, i32 12>
  ret <16 x float> %shuffle
}

define <16 x float> @shuffle_v16f32_03_uu_uu_uu_uu_04_uu_uu_uu_uu_11_uu_uu_uu_uu_12(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_03_uu_uu_uu_uu_04_uu_uu_uu_uu_11_uu_uu_uu_uu_12:
; ALL:       # %bb.0:
; ALL-NEXT:    vpermilps {{.*#+}} zmm0 = zmm0[3,0,3,0,7,4,7,4,11,8,11,8,15,12,15,12]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 4, i32 undef, i32 undef, i32 undef, i32 undef, i32 11, i32 undef, i32 undef, i32 undef, i32 undef, i32 12>
  ret <16 x float> %shuffle
}

define <16 x i32> @shuffle_v16i32_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00:
; ALL:       # %bb.0:
; ALL-NEXT:    vbroadcastss %xmm0, %zmm0
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    vbroadcastss %xmm0, %zmm0
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_02_12_03_13_06_16_07_17_0a_1a_0b_1b_0e_1e_0f_1f(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_02_12_03_13_06_16_07_17_0a_1a_0b_1b_0e_1e_0f_1f:
; ALL:       # %bb.0:
; ALL-NEXT:    vunpckhps {{.*#+}} zmm0 = zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[14],zmm1[14],zmm0[15],zmm1[15]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 2, i32 18, i32 3, i32 19, i32 6, i32 22, i32 7, i32 23, i32 10, i32 26, i32 11, i32 27, i32 14, i32 30, i32 15, i32 31>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_02_zz_03_zz_06_zz_07_zz_0a_zz_0b_zz_0e_zz_0f_zz(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_02_zz_03_zz_06_zz_07_zz_0a_zz_0b_zz_0e_zz_0f_zz:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vunpckhps {{.*#+}} zmm0 = zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[14],zmm1[14],zmm0[15],zmm1[15]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> zeroinitializer, <16 x i32><i32 2, i32 30, i32 3, i32 28, i32 6, i32 26, i32 7, i32 24, i32 10, i32 22, i32 11, i32 20, i32 14, i32 18, i32 15, i32 16>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_01_02_03_16_05_06_07_20_09_10_11_24_13_14_15_28(<16 x i32> %a, <16 x i32> %b) {
; AVX512F-LABEL: shuffle_v16i32_01_02_03_16_05_06_07_20_09_10_11_24_13_14_15_28:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [1,2,3,16,5,6,7,20,9,10,11,24,13,14,15,28]
; AVX512F-NEXT:    vpermt2d %zmm1, %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v16i32_01_02_03_16_05_06_07_20_09_10_11_24_13_14_15_28:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpalignr {{.*#+}} zmm0 = zmm0[4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0,1,2,3],zmm0[20,21,22,23,24,25,26,27,28,29,30,31],zmm1[16,17,18,19],zmm0[36,37,38,39,40,41,42,43,44,45,46,47],zmm1[32,33,34,35],zmm0[52,53,54,55,56,57,58,59,60,61,62,63],zmm1[48,49,50,51]
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 1, i32 2, i32 3, i32 16, i32 5, i32 6, i32 7, i32 20, i32 9, i32 10, i32 11, i32 24, i32 13, i32 14, i32 15, i32 28>
  ret <16 x i32> %shuffle
}

define <16 x float> @shuffle_v16f32_02_05_u_u_07_u_0a_01_00_05_u_04_07_u_0a_01(<16 x float> %a)  {
; ALL-LABEL: shuffle_v16f32_02_05_u_u_07_u_0a_01_00_05_u_04_07_u_0a_01:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps {{.*#+}} zmm1 = <2,5,u,u,7,u,10,1,0,5,u,4,7,u,10,1>
; ALL-NEXT:    vpermps %zmm0, %zmm1, %zmm0
; ALL-NEXT:    retq
  %c = shufflevector <16 x float> %a, <16 x float> undef, <16 x i32> <i32 2, i32 5, i32 undef, i32 undef, i32 7, i32 undef, i32 10, i32 1,  i32 0, i32 5, i32 undef, i32 4, i32 7, i32 undef, i32 10, i32 1>
  ret <16 x float> %c
}

define <16 x i32> @shuffle_v16i32_02_05_u_u_07_u_0a_01_00_05_u_04_07_u_0a_01(<16 x i32> %a)  {
; ALL-LABEL: shuffle_v16i32_02_05_u_u_07_u_0a_01_00_05_u_04_07_u_0a_01:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps {{.*#+}} zmm1 = <2,5,u,u,7,u,10,1,0,5,u,4,7,u,10,1>
; ALL-NEXT:    vpermps %zmm0, %zmm1, %zmm0
; ALL-NEXT:    retq
  %c = shufflevector <16 x i32> %a, <16 x i32> undef, <16 x i32> <i32 2, i32 5, i32 undef, i32 undef, i32 7, i32 undef, i32 10, i32 1,  i32 0, i32 5, i32 undef, i32 4, i32 7, i32 undef, i32 10, i32 1>
  ret <16 x i32> %c
}

define <16 x i32> @shuffle_v16i32_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18(<16 x i32> %a, <16 x i32> %b)  {
; ALL-LABEL: shuffle_v16i32_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [15,31,14,22,13,29,4,28,11,27,10,26,9,25,8,24]
; ALL-NEXT:    vpermt2d %zmm1, %zmm2, %zmm0
; ALL-NEXT:    retq
  %c = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 15, i32 31, i32 14, i32 22, i32 13, i32 29, i32 4, i32 28, i32 11, i32 27, i32 10, i32 26, i32 9, i32 25, i32 8, i32 24>
  ret <16 x i32> %c
}

define <16 x float> @shuffle_v16f32_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18(<16 x float> %a, <16 x float> %b)  {
; ALL-LABEL: shuffle_v16f32_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps {{.*#+}} zmm2 = [15,31,14,22,13,29,4,28,11,27,10,26,9,25,8,24]
; ALL-NEXT:    vpermt2ps %zmm1, %zmm2, %zmm0
; ALL-NEXT:    retq
  %c = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 15, i32 31, i32 14, i32 22, i32 13, i32 29, i32 4, i32 28, i32 11, i32 27, i32 10, i32 26, i32 9, i32 25, i32 8, i32 24>
  ret <16 x float> %c
}

define <16 x float> @shuffle_v16f32_load_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18(<16 x float> %a, <16 x float>* %b)  {
; ALL-LABEL: shuffle_v16f32_load_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps {{.*#+}} zmm1 = [15,31,14,22,13,29,4,28,11,27,10,26,9,25,8,24]
; ALL-NEXT:    vpermt2ps (%rdi), %zmm1, %zmm0
; ALL-NEXT:    retq
  %c = load <16 x float>, <16 x float>* %b
  %d = shufflevector <16 x float> %a, <16 x float> %c, <16 x i32> <i32 15, i32 31, i32 14, i32 22, i32 13, i32 29, i32 4, i32 28, i32 11, i32 27, i32 10, i32 26, i32 9, i32 25, i32 8, i32 24>
  ret <16 x float> %d
}

define <16 x i32> @shuffle_v16i32_load_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18(<16 x i32> %a, <16 x i32>* %b)  {
; ALL-LABEL: shuffle_v16i32_load_0f_1f_0e_16_0d_1d_04_1e_0b_1b_0a_1a_09_19_08_18:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,31,14,22,13,29,4,28,11,27,10,26,9,25,8,24]
; ALL-NEXT:    vpermt2d (%rdi), %zmm1, %zmm0
; ALL-NEXT:    retq
  %c = load <16 x i32>, <16 x i32>* %b
  %d = shufflevector <16 x i32> %a, <16 x i32> %c, <16 x i32> <i32 15, i32 31, i32 14, i32 22, i32 13, i32 29, i32 4, i32 28, i32 11, i32 27, i32 10, i32 26, i32 9, i32 25, i32 8, i32 24>
  ret <16 x i32> %d
}

define <16 x i32> @shuffle_v16i32_0_1_2_19_u_u_u_u_u_u_u_u_u_u_u_u(<16 x i32> %a, <16 x i32> %b)  {
; ALL-LABEL: shuffle_v16i32_0_1_2_19_u_u_u_u_u_u_u_u_u_u_u_u:
; ALL:       # %bb.0:
; ALL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1,2],xmm1[3]
; ALL-NEXT:    retq
  %c = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 19, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  ret <16 x i32> %c
}

;FIXME: can do better with vpcompress
define <8 x i32> @test_v16i32_1_3_5_7_9_11_13_15(<16 x i32> %v) {
; ALL-LABEL: test_v16i32_1_3_5_7_9_11_13_15:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; ALL-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
; ALL-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; ALL-NEXT:    retq
  %res = shufflevector <16 x i32> %v, <16 x i32> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  ret <8 x i32> %res
}

;FIXME: can do better with vpcompress
define <4 x i32> @test_v16i32_0_1_2_12 (<16 x i32> %v) {
; ALL-LABEL: test_v16i32_0_1_2_12:
; ALL:       # %bb.0:
; ALL-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; ALL-NEXT:    vextracti128 $1, %ymm1, %xmm1
; ALL-NEXT:    vpbroadcastd %xmm1, %xmm1
; ALL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1,2],xmm1[3]
; ALL-NEXT:    vzeroupper
; ALL-NEXT:    retq
  %res = shufflevector <16 x i32> %v, <16 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 12>
  ret <4 x i32> %res
}

define <8 x float> @shuffle_v16f32_extract_256(float* %RET, float* %a) {
; ALL-LABEL: shuffle_v16f32_extract_256:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovups 32(%rsi), %ymm0
; ALL-NEXT:    retq
  %ptr_a = bitcast float* %a to <16 x float>*
  %v_a = load <16 x float>, <16 x float>* %ptr_a, align 4
  %v2 = shufflevector <16 x float> %v_a, <16 x float> undef, <8 x i32>  <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <8 x float> %v2
}

;FIXME: can do better with vcompressp
define <8 x float> @test_v16f32_0_1_2_3_4_6_7_10 (<16 x float> %v) {
; ALL-LABEL: test_v16f32_0_1_2_3_4_6_7_10:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; ALL-NEXT:    vmovsldup {{.*#+}} xmm1 = xmm1[0,0,2,2]
; ALL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm1
; ALL-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,1,2,3,4,6,7,u]
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3,4,5,6],ymm1[7]
; ALL-NEXT:    retq
  %res = shufflevector <16 x float> %v, <16 x float> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 6, i32 7, i32 10>
  ret <8 x float> %res
}

;FIXME: can do better with vcompressp
define <4 x float> @test_v16f32_0_1_3_6 (<16 x float> %v) {
; ALL-LABEL: test_v16f32_0_1_3_6:
; ALL:       # %bb.0:
; ALL-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,1,3,3]
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; ALL-NEXT:    vinsertps {{.*#+}} xmm0 = xmm1[0,1,2],xmm0[0]
; ALL-NEXT:    vzeroupper
; ALL-NEXT:    retq
  %res = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 3, i32 6>
  ret <4 x float> %res
}

define <16 x i32> @shuffle_v16i16_1_0_0_0_5_4_4_4_9_8_8_8_13_12_12_12(<16 x i32> %a, <16 x i32> %b)  {
; ALL-LABEL: shuffle_v16i16_1_0_0_0_5_4_4_4_9_8_8_8_13_12_12_12:
; ALL:       # %bb.0:
; ALL-NEXT:    vpermilps {{.*#+}} zmm0 = zmm0[1,0,0,0,5,4,4,4,9,8,8,8,13,12,12,12]
; ALL-NEXT:    retq
  %c = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 1, i32 0, i32 0, i32 0, i32 5, i32 4, i32 4, i32 4, i32 9, i32 8, i32 8, i32 8, i32 13, i32 12, i32 12, i32 12>
  ret <16 x i32> %c
}

define <16 x i32> @shuffle_v16i16_3_3_0_0_7_7_4_4_11_11_8_8_15_15_12_12(<16 x i32> %a, <16 x i32> %b)  {
; ALL-LABEL: shuffle_v16i16_3_3_0_0_7_7_4_4_11_11_8_8_15_15_12_12:
; ALL:       # %bb.0:
; ALL-NEXT:    vpermilps {{.*#+}} zmm0 = zmm0[2,3,0,1,6,7,4,5,10,11,8,9,14,15,12,13]
; ALL-NEXT:    retq
  %c = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 2, i32 3, i32 0, i32 1, i32 6, i32 7, i32 4, i32 5, i32 10, i32 11, i32 8, i32 9, i32 14, i32 15, i32 12, i32 13>
  ret <16 x i32> %c
}

define <16 x float> @shuffle_v16f32_00_01_10_10_04_05_14_14_08_09_18_18_0c_0d_1c_1c(<16 x float> %a, <16 x float> %b) {
; ALL-LABEL: shuffle_v16f32_00_01_10_10_04_05_14_14_08_09_18_18_0c_0d_1c_1c:
; ALL:       # %bb.0:
; ALL-NEXT:    vshufps {{.*#+}} zmm0 = zmm0[0,1],zmm1[0,0],zmm0[4,5],zmm1[4,4],zmm0[8,9],zmm1[8,8],zmm0[12,13],zmm1[12,12]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 0, i32 1, i32 16, i32 16, i32 4, i32 5, i32 20, i32 20, i32 8, i32 9, i32 24, i32 24, i32 12, i32 13, i32 28, i32 28>
  ret <16 x float> %shuffle
}

define <16 x i32> @insert_mem_and_zero_v16i32(i32* %ptr) {
; ALL-LABEL: insert_mem_and_zero_v16i32:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; ALL-NEXT:    retq
  %a = load i32, i32* %ptr
  %v = insertelement <16 x i32> undef, i32 %a, i32 0
  %shuffle = shufflevector <16 x i32> %v, <16 x i32> zeroinitializer, <16 x i32> <i32 0, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <16 x i32> %shuffle
}


define <16 x i32> @shuffle_v16i32_0zzzzzzzzzzzzzzz(<16 x i32> %a) {
; ALL-LABEL: shuffle_v16i32_0zzzzzzzzzzzzzzz:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vmovss {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> zeroinitializer, <16 x i32> <i32 0, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  ret <16 x i32> %shuffle
}

define <16 x float> @shuffle_v16f32_0zzzzzzzzzzzzzzz(<16 x float> %a) {
; ALL-LABEL: shuffle_v16f32_0zzzzzzzzzzzzzzz:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vmovss {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> zeroinitializer, <16 x i32> <i32 0, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  ret <16 x float> %shuffle
}

define <16 x i32> @shuffle_v16i32_16_zz_17_zz_18_zz_19_zz_20_zz_21_zz_22_zz_23_zz(<16 x i32> %a) {
; ALL-LABEL: shuffle_v16i32_16_zz_17_zz_18_zz_19_zz_20_zz_21_zz_22_zz_23_zz:
; ALL:       # %bb.0:
; ALL-NEXT:    vpmovzxdq {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> zeroinitializer, <16 x i32> %a, <16 x i32> <i32 16, i32 0, i32 17, i32 0, i32 18, i32 0, i32 19, i32 0, i32 20, i32 0, i32 21, i32 0, i32 22, i32 0, i32 23, i32 0>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_01_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_01_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16:
; ALL:       # %bb.0:
; ALL-NEXT:    valignd {{.*#+}} zmm0 = zmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_01_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00(<16 x i32> %a) {
; ALL-LABEL: shuffle_v16i32_01_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00:
; ALL:       # %bb.0:
; ALL-NEXT:    valignd {{.*#+}} zmm0 = zmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> undef, <16 x i32><i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_00_03_16_19_04_07_20_23_08_11_24_27_12_15_28_31(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_00_03_16_19_04_07_20_23_08_11_24_27_12_15_28_31:
; ALL:       # %bb.0:
; ALL-NEXT:    vshufps {{.*#+}} zmm0 = zmm0[0,3],zmm1[0,3],zmm0[4,7],zmm1[4,7],zmm0[8,11],zmm1[8,11],zmm0[12,15],zmm1[12,15]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 0, i32 3, i32 16, i32 19, i32 4, i32 7, i32 20, i32 23, i32 8, i32 11, i32 24, i32 27, i32 12, i32 15, i32 28, i32 31>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v16i32_16_16_02_03_20_20_06_07_24_24_10_11_28_28_uu_uu(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v16i32_16_16_02_03_20_20_06_07_24_24_10_11_28_28_uu_uu:
; ALL:       # %bb.0:
; ALL-NEXT:    vshufps {{.*#+}} zmm0 = zmm1[0,0],zmm0[2,3],zmm1[4,4],zmm0[6,7],zmm1[8,8],zmm0[10,11],zmm1[12,12],zmm0[14,15]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 16, i32 16, i32 02, i32 03, i32 20, i32 20, i32 06, i32 07, i32 24, i32 24, i32 10, i32 11, i32 28, i32 28, i32 undef, i32 undef>
  ret <16 x i32> %shuffle
}

define <16 x i32> @shuffle_v8i32_17_16_01_00_21_20_05_04_25_24_09_08_29_28_13_12(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: shuffle_v8i32_17_16_01_00_21_20_05_04_25_24_09_08_29_28_13_12:
; ALL:       # %bb.0:
; ALL-NEXT:    vshufps {{.*#+}} zmm0 = zmm1[1,0],zmm0[1,0],zmm1[5,4],zmm0[5,4],zmm1[9,8],zmm0[9,8],zmm1[13,12],zmm0[13,12]
; ALL-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 17, i32 16, i32 01, i32 00, i32 21, i32 20, i32 05, i32 04, i32 25, i32 24, i32 09, i32 08, i32 29, i32 28, i32 13, i32 12>
  ret <16 x i32> %shuffle
}

define <16 x float> @shuffle_v8f32_v16f32_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04(<8 x float> %a) {
; ALL-LABEL: shuffle_v8f32_v16f32_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04_04:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    vbroadcastss %xmm0, %zmm0
; ALL-NEXT:    retq
  %shuffle = shufflevector <8 x float> %a, <8 x float> undef, <16 x i32> <i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4>
  ret <16 x float> %shuffle
}

define <16 x i32> @mask_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00_01(<16 x i32> %a, <16 x i32> %passthru, i16 %mask) {
; AVX512F-LABEL: mask_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00_01:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    valignd {{.*#+}} zmm1 {%k1} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1]
; AVX512F-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mask_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00_01:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    valignd {{.*#+}} zmm1 {%k1} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1]
; AVX512BW-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> undef, <16 x i32><i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x i32> %shuffle, <16 x i32> %passthru
  ret <16 x i32> %res
}

define <16 x i32> @mask_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17(<16 x i32> %a, <16 x i32> %b, <16 x i32> %passthru, i16 %mask) {
; AVX512F-LABEL: mask_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    valignd {{.*#+}} zmm2 {%k1} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0,1]
; AVX512F-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mask_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    valignd {{.*#+}} zmm2 {%k1} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0,1]
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x i32> %shuffle, <16 x i32> %passthru
  ret <16 x i32> %res
}

define <16 x i32> @maskz_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00_01(<16 x i32> %a, i16 %mask) {
; AVX512F-LABEL: maskz_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00_01:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    valignd {{.*#+}} zmm0 {%k1} {z} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1]
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: maskz_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_00_01:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    valignd {{.*#+}} zmm0 {%k1} {z} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1]
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> undef, <16 x i32><i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x i32> %shuffle, <16 x i32> zeroinitializer
  ret <16 x i32> %res
}

define <16 x i32> @maskz_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17(<16 x i32> %a, <16 x i32> %b, i16 %mask) {
; AVX512F-LABEL: maskz_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    valignd {{.*#+}} zmm0 {%k1} {z} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0,1]
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: maskz_shuffle_v16i32_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    valignd {{.*#+}} zmm0 {%k1} {z} = zmm0[2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0,1]
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32><i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x i32> %shuffle, <16 x i32> zeroinitializer
  ret <16 x i32> %res
}

define <16 x float> @test_vshuff32x4_512(<16 x float> %x, <16 x float> %x1) nounwind {
; ALL-LABEL: test_vshuff32x4_512:
; ALL:       # %bb.0:
; ALL-NEXT:    vshuff64x2 {{.*#+}} zmm0 = zmm0[0,1,2,3],zmm1[2,3,0,1]
; ALL-NEXT:    retq
  %res = shufflevector <16 x float> %x, <16 x float> %x1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23, i32 16, i32 17, i32 18, i32 19>
  ret <16 x float> %res
}

define <16 x i32> @test_vshufi32x4_512(<16 x i32> %x, <16 x i32> %x1) nounwind {
; ALL-LABEL: test_vshufi32x4_512:
; ALL:       # %bb.0:
; ALL-NEXT:    vshufi64x2 {{.*#+}} zmm0 = zmm0[0,1,2,3],zmm1[2,3,0,1]
; ALL-NEXT:    retq
  %res = shufflevector <16 x i32> %x, <16 x i32> %x1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23, i32 16, i32 17, i32 18, i32 19>
  ret <16 x i32> %res
}

define <16 x float> @test_vshuff32x4_512_mask(<16 x float> %x, <16 x float> %x1, <16 x float> %y, <16 x i1> %mask) nounwind {
; AVX512F-LABEL: test_vshuff32x4_512_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmovsxbd %xmm3, %zmm3
; AVX512F-NEXT:    vpslld $31, %zmm3, %zmm3
; AVX512F-NEXT:    vptestmd %zmm3, %zmm3, %k1
; AVX512F-NEXT:    vshuff32x4 {{.*#+}} zmm2 {%k1} = zmm0[0,1,2,3,4,5,6,7],zmm1[4,5,6,7,0,1,2,3]
; AVX512F-NEXT:    vmovaps %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_vshuff32x4_512_mask:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsllw $7, %xmm3, %xmm3
; AVX512BW-NEXT:    vpmovb2m %zmm3, %k1
; AVX512BW-NEXT:    vshuff32x4 {{.*#+}} zmm2 {%k1} = zmm0[0,1,2,3,4,5,6,7],zmm1[4,5,6,7,0,1,2,3]
; AVX512BW-NEXT:    vmovaps %zmm2, %zmm0
; AVX512BW-NEXT:    retq
  %x2 = shufflevector <16 x float> %x, <16 x float> %x1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23, i32 16, i32 17, i32 18, i32 19>
  %res = select <16 x i1> %mask, <16 x float> %x2, <16 x float> %y
  ret <16 x float> %res
}

define <16 x i32> @test_vshufi32x4_512_mask(<16 x i32> %x, <16 x i32> %x1, <16 x i32> %y, <16 x i1> %mask) nounwind {
; AVX512F-LABEL: test_vshufi32x4_512_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmovsxbd %xmm3, %zmm3
; AVX512F-NEXT:    vpslld $31, %zmm3, %zmm3
; AVX512F-NEXT:    vptestmd %zmm3, %zmm3, %k1
; AVX512F-NEXT:    vshufi32x4 {{.*#+}} zmm2 {%k1} = zmm0[0,1,2,3,4,5,6,7],zmm1[4,5,6,7,0,1,2,3]
; AVX512F-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_vshufi32x4_512_mask:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsllw $7, %xmm3, %xmm3
; AVX512BW-NEXT:    vpmovb2m %zmm3, %k1
; AVX512BW-NEXT:    vshufi32x4 {{.*#+}} zmm2 {%k1} = zmm0[0,1,2,3,4,5,6,7],zmm1[4,5,6,7,0,1,2,3]
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
  %x2 = shufflevector <16 x i32> %x, <16 x i32> %x1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23, i32 16, i32 17, i32 18, i32 19>
  %res = select <16 x i1> %mask, <16 x i32> %x2, <16 x i32> %y
  ret <16 x i32> %res
}

define <16 x float> @mask_shuffle_v16f32_00_01_02_03_04_05_06_07_16_17_18_19_20_21_22_23(<16 x float> %a, <16 x float> %b, <16 x float> %passthru, i16 %mask) {
; AVX512F-LABEL: mask_shuffle_v16f32_00_01_02_03_04_05_06_07_16_17_18_19_20_21_22_23:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; AVX512F-NEXT:    vmovaps %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mask_shuffle_v16f32_00_01_02_03_04_05_06_07_16_17_18_19_20_21_22_23:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovaps %zmm2, %zmm0
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x float> %shuffle, <16 x float> %passthru
  ret <16 x float> %res
}

define <16 x float> @mask_shuffle_v16f32_00_01_02_03_16_17_18_19_08_09_10_11_12_13_14_15(<16 x float> %a, <16 x float> %b, <16 x float> %passthru, i16 %mask) {
; AVX512F-LABEL: mask_shuffle_v16f32_00_01_02_03_16_17_18_19_08_09_10_11_12_13_14_15:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vinsertf32x4 $1, %xmm1, %zmm0, %zmm2 {%k1}
; AVX512F-NEXT:    vmovaps %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mask_shuffle_v16f32_00_01_02_03_16_17_18_19_08_09_10_11_12_13_14_15:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vinsertf32x4 $1, %xmm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovaps %zmm2, %zmm0
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x float> %a, <16 x float> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x float> %shuffle, <16 x float> %passthru
  ret <16 x float> %res
}

define <16 x i32> @mask_shuffle_v16i32_00_01_02_03_04_05_06_07_16_17_18_19_20_21_22_23(<16 x i32> %a, <16 x i32> %b, <16 x i32> %passthru, i16 %mask) {
; AVX512F-LABEL: mask_shuffle_v16i32_00_01_02_03_04_05_06_07_16_17_18_19_20_21_22_23:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; AVX512F-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mask_shuffle_v16i32_00_01_02_03_04_05_06_07_16_17_18_19_20_21_22_23:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x i32> %shuffle, <16 x i32> %passthru
  ret <16 x i32> %res
}

define <16 x i32> @mask_shuffle_v16i32_00_01_02_03_16_17_18_19_08_09_10_11_12_13_14_15(<16 x i32> %a, <16 x i32> %b, <16 x i32> %passthru, i16 %mask) {
; AVX512F-LABEL: mask_shuffle_v16i32_00_01_02_03_16_17_18_19_08_09_10_11_12_13_14_15:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vinserti32x4 $1, %xmm1, %zmm0, %zmm2 {%k1}
; AVX512F-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mask_shuffle_v16i32_00_01_02_03_16_17_18_19_08_09_10_11_12_13_14_15:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vinserti32x4 $1, %xmm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
  %shuffle = shufflevector <16 x i32> %a, <16 x i32> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %mask.cast = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask.cast, <16 x i32> %shuffle, <16 x i32> %passthru
  ret <16 x i32> %res
}

define <16 x i32> @mask_shuffle_v4i32_v16i32_00_01_02_03_00_01_02_03_00_01_02_03_00_01_02_03(<4 x i32> %a) {
; ALL-LABEL: mask_shuffle_v4i32_v16i32_00_01_02_03_00_01_02_03_00_01_02_03_00_01_02_03:
; ALL:       # %bb.0:
; ALL-NEXT:    # kill: def %xmm0 killed %xmm0 def %ymm0
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; ALL-NEXT:    vinsertf64x4 $1, %ymm0, %zmm0, %zmm0
; ALL-NEXT:    retq
  %res = shufflevector <4 x i32> %a, <4 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
  ret <16 x i32> %res
}

define <16 x float> @mask_shuffle_v4f32_v16f32_00_01_02_03_00_01_02_03_00_01_02_03_00_01_02_03(<4 x float> %a) {
; ALL-LABEL: mask_shuffle_v4f32_v16f32_00_01_02_03_00_01_02_03_00_01_02_03_00_01_02_03:
; ALL:       # %bb.0:
; ALL-NEXT:    # kill: def %xmm0 killed %xmm0 def %ymm0
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; ALL-NEXT:    vinsertf64x4 $1, %ymm0, %zmm0, %zmm0
; ALL-NEXT:    retq
  %res = shufflevector <4 x float> %a, <4 x float> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
  ret <16 x float> %res
}
