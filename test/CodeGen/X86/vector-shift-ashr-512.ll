; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512dq | FileCheck %s --check-prefix=ALL --check-prefix=AVX512 --check-prefix=AVX512DQ
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=ALL --check-prefix=AVX512 --check-prefix=AVX512BW

;
; Variable Shifts
;

define <8 x i64> @var_shift_v8i64(<8 x i64> %a, <8 x i64> %b) nounwind {
; ALL-LABEL: var_shift_v8i64:
; ALL:       # %bb.0:
; ALL-NEXT:    vpsravq %zmm1, %zmm0, %zmm0
; ALL-NEXT:    retq
  %shift = ashr <8 x i64> %a, %b
  ret <8 x i64> %shift
}

define <16 x i32> @var_shift_v16i32(<16 x i32> %a, <16 x i32> %b) nounwind {
; ALL-LABEL: var_shift_v16i32:
; ALL:       # %bb.0:
; ALL-NEXT:    vpsravd %zmm1, %zmm0, %zmm0
; ALL-NEXT:    retq
  %shift = ashr <16 x i32> %a, %b
  ret <16 x i32> %shift
}

define <32 x i16> @var_shift_v32i16(<32 x i16> %a, <32 x i16> %b) nounwind {
; AVX512DQ-LABEL: var_shift_v32i16:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpmovzxwd {{.*#+}} zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero,ymm2[8],zero,ymm2[9],zero,ymm2[10],zero,ymm2[11],zero,ymm2[12],zero,ymm2[13],zero,ymm2[14],zero,ymm2[15],zero
; AVX512DQ-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512DQ-NEXT:    vpsravd %zmm2, %zmm0, %zmm0
; AVX512DQ-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512DQ-NEXT:    vpmovzxwd {{.*#+}} zmm2 = ymm3[0],zero,ymm3[1],zero,ymm3[2],zero,ymm3[3],zero,ymm3[4],zero,ymm3[5],zero,ymm3[6],zero,ymm3[7],zero,ymm3[8],zero,ymm3[9],zero,ymm3[10],zero,ymm3[11],zero,ymm3[12],zero,ymm3[13],zero,ymm3[14],zero,ymm3[15],zero
; AVX512DQ-NEXT:    vpmovsxwd %ymm1, %zmm1
; AVX512DQ-NEXT:    vpsravd %zmm2, %zmm1, %zmm1
; AVX512DQ-NEXT:    vpmovdw %zmm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: var_shift_v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsravw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %shift = ashr <32 x i16> %a, %b
  ret <32 x i16> %shift
}

define <64 x i8> @var_shift_v64i8(<64 x i8> %a, <64 x i8> %b) nounwind {
; AVX512DQ-LABEL: var_shift_v64i8:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpsllw $5, %ymm2, %ymm2
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm0[8],ymm2[8],ymm0[9],ymm2[9],ymm0[10],ymm2[10],ymm0[11],ymm2[11],ymm0[12],ymm2[12],ymm0[13],ymm2[13],ymm0[14],ymm2[14],ymm0[15],ymm2[15],ymm0[24],ymm2[24],ymm0[25],ymm2[25],ymm0[26],ymm2[26],ymm0[27],ymm2[27],ymm0[28],ymm2[28],ymm0[29],ymm2[29],ymm0[30],ymm2[30],ymm0[31],ymm2[31]
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm5 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512DQ-NEXT:    vpsraw $4, %ymm5, %ymm6
; AVX512DQ-NEXT:    vpblendvb %ymm4, %ymm6, %ymm5, %ymm5
; AVX512DQ-NEXT:    vpsraw $2, %ymm5, %ymm6
; AVX512DQ-NEXT:    vpaddw %ymm4, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm4, %ymm6, %ymm5, %ymm5
; AVX512DQ-NEXT:    vpsraw $1, %ymm5, %ymm6
; AVX512DQ-NEXT:    vpaddw %ymm4, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm4, %ymm6, %ymm5, %ymm4
; AVX512DQ-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm2 = ymm0[0],ymm2[0],ymm0[1],ymm2[1],ymm0[2],ymm2[2],ymm0[3],ymm2[3],ymm0[4],ymm2[4],ymm0[5],ymm2[5],ymm0[6],ymm2[6],ymm0[7],ymm2[7],ymm0[16],ymm2[16],ymm0[17],ymm2[17],ymm0[18],ymm2[18],ymm0[19],ymm2[19],ymm0[20],ymm2[20],ymm0[21],ymm2[21],ymm0[22],ymm2[22],ymm0[23],ymm2[23]
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512DQ-NEXT:    vpsraw $4, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw $2, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw $1, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsrlw $8, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpackuswb %ymm4, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsllw $5, %ymm3, %ymm2
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm3 = ymm0[8],ymm2[8],ymm0[9],ymm2[9],ymm0[10],ymm2[10],ymm0[11],ymm2[11],ymm0[12],ymm2[12],ymm0[13],ymm2[13],ymm0[14],ymm2[14],ymm0[15],ymm2[15],ymm0[24],ymm2[24],ymm0[25],ymm2[25],ymm0[26],ymm2[26],ymm0[27],ymm2[27],ymm0[28],ymm2[28],ymm0[29],ymm2[29],ymm0[30],ymm2[30],ymm0[31],ymm2[31]
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
; AVX512DQ-NEXT:    vpsraw $4, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm3, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsraw $2, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm3, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpblendvb %ymm3, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsraw $1, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm3, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpblendvb %ymm3, %ymm5, %ymm4, %ymm3
; AVX512DQ-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm2 = ymm0[0],ymm2[0],ymm0[1],ymm2[1],ymm0[2],ymm2[2],ymm0[3],ymm2[3],ymm0[4],ymm2[4],ymm0[5],ymm2[5],ymm0[6],ymm2[6],ymm0[7],ymm2[7],ymm0[16],ymm2[16],ymm0[17],ymm2[17],ymm0[18],ymm2[18],ymm0[19],ymm2[19],ymm0[20],ymm2[20],ymm0[21],ymm2[21],ymm0[22],ymm2[22],ymm0[23],ymm2[23]
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
; AVX512DQ-NEXT:    vpsraw $4, %ymm1, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm4, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsraw $2, %ymm1, %ymm4
; AVX512DQ-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm4, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsraw $1, %ymm1, %ymm4
; AVX512DQ-NEXT:    vpaddw %ymm2, %ymm2, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm4, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpackuswb %ymm3, %ymm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: var_shift_v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm2 = zmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; AVX512BW-NEXT:    vpsraw $4, %zmm2, %zmm3
; AVX512BW-NEXT:    vpsllw $5, %zmm1, %zmm1
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm4 = zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[12],zmm1[12],zmm0[13],zmm1[13],zmm0[14],zmm1[14],zmm0[15],zmm1[15],zmm0[24],zmm1[24],zmm0[25],zmm1[25],zmm0[26],zmm1[26],zmm0[27],zmm1[27],zmm0[28],zmm1[28],zmm0[29],zmm1[29],zmm0[30],zmm1[30],zmm0[31],zmm1[31],zmm0[40],zmm1[40],zmm0[41],zmm1[41],zmm0[42],zmm1[42],zmm0[43],zmm1[43],zmm0[44],zmm1[44],zmm0[45],zmm1[45],zmm0[46],zmm1[46],zmm0[47],zmm1[47],zmm0[56],zmm1[56],zmm0[57],zmm1[57],zmm0[58],zmm1[58],zmm0[59],zmm1[59],zmm0[60],zmm1[60],zmm0[61],zmm1[61],zmm0[62],zmm1[62],zmm0[63],zmm1[63]
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm2 {%k1}
; AVX512BW-NEXT:    vpsraw $2, %zmm2, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm4, %zmm4, %zmm4
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm2 {%k1}
; AVX512BW-NEXT:    vpsraw $1, %zmm2, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm4, %zmm4, %zmm4
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm2 {%k1}
; AVX512BW-NEXT:    vpsrlw $8, %zmm2, %zmm2
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm0 = zmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; AVX512BW-NEXT:    vpsraw $4, %zmm0, %zmm3
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm1 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[16],zmm1[16],zmm0[17],zmm1[17],zmm0[18],zmm1[18],zmm0[19],zmm1[19],zmm0[20],zmm1[20],zmm0[21],zmm1[21],zmm0[22],zmm1[22],zmm0[23],zmm1[23],zmm0[32],zmm1[32],zmm0[33],zmm1[33],zmm0[34],zmm1[34],zmm0[35],zmm1[35],zmm0[36],zmm1[36],zmm0[37],zmm1[37],zmm0[38],zmm1[38],zmm0[39],zmm1[39],zmm0[48],zmm1[48],zmm0[49],zmm1[49],zmm0[50],zmm1[50],zmm0[51],zmm1[51],zmm0[52],zmm1[52],zmm0[53],zmm1[53],zmm0[54],zmm1[54],zmm0[55],zmm1[55]
; AVX512BW-NEXT:    vpmovb2m %zmm1, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsraw $2, %zmm0, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm1, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovb2m %zmm1, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsraw $1, %zmm0, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm1, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovb2m %zmm1, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsrlw $8, %zmm0, %zmm0
; AVX512BW-NEXT:    vpackuswb %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %shift = ashr <64 x i8> %a, %b
  ret <64 x i8> %shift
}

;
; Uniform Variable Shifts
;

define <8 x i64> @splatvar_shift_v8i64(<8 x i64> %a, <8 x i64> %b) nounwind {
; ALL-LABEL: splatvar_shift_v8i64:
; ALL:       # %bb.0:
; ALL-NEXT:    vpsraq %xmm1, %zmm0, %zmm0
; ALL-NEXT:    retq
  %splat = shufflevector <8 x i64> %b, <8 x i64> undef, <8 x i32> zeroinitializer
  %shift = ashr <8 x i64> %a, %splat
  ret <8 x i64> %shift
}

define <16 x i32> @splatvar_shift_v16i32(<16 x i32> %a, <16 x i32> %b) nounwind {
; ALL-LABEL: splatvar_shift_v16i32:
; ALL:       # %bb.0:
; ALL-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; ALL-NEXT:    vpsrad %xmm1, %zmm0, %zmm0
; ALL-NEXT:    retq
  %splat = shufflevector <16 x i32> %b, <16 x i32> undef, <16 x i32> zeroinitializer
  %shift = ashr <16 x i32> %a, %splat
  ret <16 x i32> %shift
}

define <32 x i16> @splatvar_shift_v32i16(<32 x i16> %a, <32 x i16> %b) nounwind {
; AVX512DQ-LABEL: splatvar_shift_v32i16:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpmovzxwq {{.*#+}} xmm2 = xmm2[0],zero,zero,zero,xmm2[1],zero,zero,zero
; AVX512DQ-NEXT:    vpsraw %xmm2, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw %xmm2, %ymm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: splatvar_shift_v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovzxwq {{.*#+}} xmm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero
; AVX512BW-NEXT:    vpsraw %xmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %splat = shufflevector <32 x i16> %b, <32 x i16> undef, <32 x i32> zeroinitializer
  %shift = ashr <32 x i16> %a, %splat
  ret <32 x i16> %shift
}

define <64 x i8> @splatvar_shift_v64i8(<64 x i8> %a, <64 x i8> %b) nounwind {
; AVX512DQ-LABEL: splatvar_shift_v64i8:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpbroadcastb %xmm2, %ymm2
; AVX512DQ-NEXT:    vpsllw $5, %ymm2, %ymm2
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm3 = ymm0[8],ymm2[8],ymm0[9],ymm2[9],ymm0[10],ymm2[10],ymm0[11],ymm2[11],ymm0[12],ymm2[12],ymm0[13],ymm2[13],ymm0[14],ymm2[14],ymm0[15],ymm2[15],ymm0[24],ymm2[24],ymm0[25],ymm2[25],ymm0[26],ymm2[26],ymm0[27],ymm2[27],ymm0[28],ymm2[28],ymm0[29],ymm2[29],ymm0[30],ymm2[30],ymm0[31],ymm2[31]
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512DQ-NEXT:    vpsraw $4, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm3, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsraw $2, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm3, %ymm3, %ymm6
; AVX512DQ-NEXT:    vpblendvb %ymm6, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsraw $1, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm6, %ymm6, %ymm7
; AVX512DQ-NEXT:    vpblendvb %ymm7, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm2 = ymm0[0],ymm2[0],ymm0[1],ymm2[1],ymm0[2],ymm2[2],ymm0[3],ymm2[3],ymm0[4],ymm2[4],ymm0[5],ymm2[5],ymm0[6],ymm2[6],ymm0[7],ymm2[7],ymm0[16],ymm2[16],ymm0[17],ymm2[17],ymm0[18],ymm2[18],ymm0[19],ymm2[19],ymm0[20],ymm2[20],ymm0[21],ymm2[21],ymm0[22],ymm2[22],ymm0[23],ymm2[23]
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512DQ-NEXT:    vpsraw $4, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw $2, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm2, %ymm2, %ymm8
; AVX512DQ-NEXT:    vpblendvb %ymm8, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw $1, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm8, %ymm8, %ymm9
; AVX512DQ-NEXT:    vpblendvb %ymm9, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsrlw $8, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpackuswb %ymm4, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
; AVX512DQ-NEXT:    vpsraw $4, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm3, %ymm5, %ymm4, %ymm3
; AVX512DQ-NEXT:    vpsraw $2, %ymm3, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm6, %ymm4, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpsraw $1, %ymm3, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm7, %ymm4, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
; AVX512DQ-NEXT:    vpsraw $4, %ymm1, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm4, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsraw $2, %ymm1, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm8, %ymm2, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsraw $1, %ymm1, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm9, %ymm2, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpackuswb %ymm3, %ymm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: splatvar_shift_v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpbroadcastb %xmm1, %zmm1
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm2 = zmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; AVX512BW-NEXT:    vpsraw $4, %zmm2, %zmm3
; AVX512BW-NEXT:    vpsllw $5, %zmm1, %zmm1
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm4 = zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[12],zmm1[12],zmm0[13],zmm1[13],zmm0[14],zmm1[14],zmm0[15],zmm1[15],zmm0[24],zmm1[24],zmm0[25],zmm1[25],zmm0[26],zmm1[26],zmm0[27],zmm1[27],zmm0[28],zmm1[28],zmm0[29],zmm1[29],zmm0[30],zmm1[30],zmm0[31],zmm1[31],zmm0[40],zmm1[40],zmm0[41],zmm1[41],zmm0[42],zmm1[42],zmm0[43],zmm1[43],zmm0[44],zmm1[44],zmm0[45],zmm1[45],zmm0[46],zmm1[46],zmm0[47],zmm1[47],zmm0[56],zmm1[56],zmm0[57],zmm1[57],zmm0[58],zmm1[58],zmm0[59],zmm1[59],zmm0[60],zmm1[60],zmm0[61],zmm1[61],zmm0[62],zmm1[62],zmm0[63],zmm1[63]
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm2 {%k1}
; AVX512BW-NEXT:    vpsraw $2, %zmm2, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm4, %zmm4, %zmm4
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm2 {%k1}
; AVX512BW-NEXT:    vpsraw $1, %zmm2, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm4, %zmm4, %zmm4
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm2 {%k1}
; AVX512BW-NEXT:    vpsrlw $8, %zmm2, %zmm2
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm0 = zmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; AVX512BW-NEXT:    vpsraw $4, %zmm0, %zmm3
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm1 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[16],zmm1[16],zmm0[17],zmm1[17],zmm0[18],zmm1[18],zmm0[19],zmm1[19],zmm0[20],zmm1[20],zmm0[21],zmm1[21],zmm0[22],zmm1[22],zmm0[23],zmm1[23],zmm0[32],zmm1[32],zmm0[33],zmm1[33],zmm0[34],zmm1[34],zmm0[35],zmm1[35],zmm0[36],zmm1[36],zmm0[37],zmm1[37],zmm0[38],zmm1[38],zmm0[39],zmm1[39],zmm0[48],zmm1[48],zmm0[49],zmm1[49],zmm0[50],zmm1[50],zmm0[51],zmm1[51],zmm0[52],zmm1[52],zmm0[53],zmm1[53],zmm0[54],zmm1[54],zmm0[55],zmm1[55]
; AVX512BW-NEXT:    vpmovb2m %zmm1, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsraw $2, %zmm0, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm1, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovb2m %zmm1, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsraw $1, %zmm0, %zmm3
; AVX512BW-NEXT:    vpaddw %zmm1, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovb2m %zmm1, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm3, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsrlw $8, %zmm0, %zmm0
; AVX512BW-NEXT:    vpackuswb %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %splat = shufflevector <64 x i8> %b, <64 x i8> undef, <64 x i32> zeroinitializer
  %shift = ashr <64 x i8> %a, %splat
  ret <64 x i8> %shift
}

;
; Constant Shifts
;

define <8 x i64> @constant_shift_v8i64(<8 x i64> %a) nounwind {
; ALL-LABEL: constant_shift_v8i64:
; ALL:       # %bb.0:
; ALL-NEXT:    vpsravq {{.*}}(%rip), %zmm0, %zmm0
; ALL-NEXT:    retq
  %shift = ashr <8 x i64> %a, <i64 1, i64 7, i64 31, i64 62, i64 1, i64 7, i64 31, i64 62>
  ret <8 x i64> %shift
}

define <16 x i32> @constant_shift_v16i32(<16 x i32> %a) nounwind {
; ALL-LABEL: constant_shift_v16i32:
; ALL:       # %bb.0:
; ALL-NEXT:    vpsravd {{.*}}(%rip), %zmm0, %zmm0
; ALL-NEXT:    retq
  %shift = ashr <16 x i32> %a, <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 8, i32 7, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 8, i32 7>
  ret <16 x i32> %shift
}

define <32 x i16> @constant_shift_v32i16(<32 x i16> %a) nounwind {
; AVX512DQ-LABEL: constant_shift_v32i16:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512DQ-NEXT:    vmovdqa32 {{.*#+}} zmm2 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; AVX512DQ-NEXT:    vpsravd %zmm2, %zmm0, %zmm0
; AVX512DQ-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512DQ-NEXT:    vpmovsxwd %ymm1, %zmm1
; AVX512DQ-NEXT:    vpsravd %zmm2, %zmm1, %zmm1
; AVX512DQ-NEXT:    vpmovdw %zmm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: constant_shift_v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsravw {{.*}}(%rip), %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %shift = ashr <32 x i16> %a, <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8, i16 9, i16 10, i16 11, i16 12, i16 13, i16 14, i16 15, i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8, i16 9, i16 10, i16 11, i16 12, i16 13, i16 14, i16 15>
  ret <32 x i16> %shift
}

define <64 x i8> @constant_shift_v64i8(<64 x i8> %a) nounwind {
; AVX512DQ-LABEL: constant_shift_v64i8:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vmovdqa {{.*#+}} ymm2 = [8192,24640,41088,57536,49376,32928,16480,32,8192,24640,41088,57536,49376,32928,16480,32]
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm3 = ymm0[8],ymm2[8],ymm0[9],ymm2[9],ymm0[10],ymm2[10],ymm0[11],ymm2[11],ymm0[12],ymm2[12],ymm0[13],ymm2[13],ymm0[14],ymm2[14],ymm0[15],ymm2[15],ymm0[24],ymm2[24],ymm0[25],ymm2[25],ymm0[26],ymm2[26],ymm0[27],ymm2[27],ymm0[28],ymm2[28],ymm0[29],ymm2[29],ymm0[30],ymm2[30],ymm0[31],ymm2[31]
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512DQ-NEXT:    vpsraw $4, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm3, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsraw $2, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm3, %ymm3, %ymm6
; AVX512DQ-NEXT:    vpblendvb %ymm6, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsraw $1, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm6, %ymm6, %ymm7
; AVX512DQ-NEXT:    vpblendvb %ymm7, %ymm5, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm2 = ymm0[0],ymm2[0],ymm0[1],ymm2[1],ymm0[2],ymm2[2],ymm0[3],ymm2[3],ymm0[4],ymm2[4],ymm0[5],ymm2[5],ymm0[6],ymm2[6],ymm0[7],ymm2[7],ymm0[16],ymm2[16],ymm0[17],ymm2[17],ymm0[18],ymm2[18],ymm0[19],ymm2[19],ymm0[20],ymm2[20],ymm0[21],ymm2[21],ymm0[22],ymm2[22],ymm0[23],ymm2[23]
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512DQ-NEXT:    vpsraw $4, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw $2, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm2, %ymm2, %ymm8
; AVX512DQ-NEXT:    vpblendvb %ymm8, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw $1, %ymm0, %ymm5
; AVX512DQ-NEXT:    vpaddw %ymm8, %ymm8, %ymm9
; AVX512DQ-NEXT:    vpblendvb %ymm9, %ymm5, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsrlw $8, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpackuswb %ymm4, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
; AVX512DQ-NEXT:    vpsraw $4, %ymm4, %ymm5
; AVX512DQ-NEXT:    vpblendvb %ymm3, %ymm5, %ymm4, %ymm3
; AVX512DQ-NEXT:    vpsraw $2, %ymm3, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm6, %ymm4, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpsraw $1, %ymm3, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm7, %ymm4, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512DQ-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
; AVX512DQ-NEXT:    vpsraw $4, %ymm1, %ymm4
; AVX512DQ-NEXT:    vpblendvb %ymm2, %ymm4, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsraw $2, %ymm1, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm8, %ymm2, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsraw $1, %ymm1, %ymm2
; AVX512DQ-NEXT:    vpblendvb %ymm9, %ymm2, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpackuswb %ymm3, %ymm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: constant_shift_v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm1 = zmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; AVX512BW-NEXT:    vpsraw $4, %zmm1, %zmm2
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [8192,24640,41088,57536,49376,32928,16480,32,8192,24640,41088,57536,49376,32928,16480,32,8192,24640,41088,57536,49376,32928,16480,32,8192,24640,41088,57536,49376,32928,16480,32]
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm4 = zmm0[8],zmm3[8],zmm0[9],zmm3[9],zmm0[10],zmm3[10],zmm0[11],zmm3[11],zmm0[12],zmm3[12],zmm0[13],zmm3[13],zmm0[14],zmm3[14],zmm0[15],zmm3[15],zmm0[24],zmm3[24],zmm0[25],zmm3[25],zmm0[26],zmm3[26],zmm0[27],zmm3[27],zmm0[28],zmm3[28],zmm0[29],zmm3[29],zmm0[30],zmm3[30],zmm0[31],zmm3[31],zmm0[40],zmm3[40],zmm0[41],zmm3[41],zmm0[42],zmm3[42],zmm0[43],zmm3[43],zmm0[44],zmm3[44],zmm0[45],zmm3[45],zmm0[46],zmm3[46],zmm0[47],zmm3[47],zmm0[56],zmm3[56],zmm0[57],zmm3[57],zmm0[58],zmm3[58],zmm0[59],zmm3[59],zmm0[60],zmm3[60],zmm0[61],zmm3[61],zmm0[62],zmm3[62],zmm0[63],zmm3[63]
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm2, %zmm1 {%k1}
; AVX512BW-NEXT:    vpsraw $2, %zmm1, %zmm2
; AVX512BW-NEXT:    vpaddw %zmm4, %zmm4, %zmm4
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm2, %zmm1 {%k1}
; AVX512BW-NEXT:    vpsraw $1, %zmm1, %zmm2
; AVX512BW-NEXT:    vpaddw %zmm4, %zmm4, %zmm4
; AVX512BW-NEXT:    vpmovb2m %zmm4, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm2, %zmm1 {%k1}
; AVX512BW-NEXT:    vpsrlw $8, %zmm1, %zmm1
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm0 = zmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; AVX512BW-NEXT:    vpsraw $4, %zmm0, %zmm2
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm3 = zmm0[0],zmm3[0],zmm0[1],zmm3[1],zmm0[2],zmm3[2],zmm0[3],zmm3[3],zmm0[4],zmm3[4],zmm0[5],zmm3[5],zmm0[6],zmm3[6],zmm0[7],zmm3[7],zmm0[16],zmm3[16],zmm0[17],zmm3[17],zmm0[18],zmm3[18],zmm0[19],zmm3[19],zmm0[20],zmm3[20],zmm0[21],zmm3[21],zmm0[22],zmm3[22],zmm0[23],zmm3[23],zmm0[32],zmm3[32],zmm0[33],zmm3[33],zmm0[34],zmm3[34],zmm0[35],zmm3[35],zmm0[36],zmm3[36],zmm0[37],zmm3[37],zmm0[38],zmm3[38],zmm0[39],zmm3[39],zmm0[48],zmm3[48],zmm0[49],zmm3[49],zmm0[50],zmm3[50],zmm0[51],zmm3[51],zmm0[52],zmm3[52],zmm0[53],zmm3[53],zmm0[54],zmm3[54],zmm0[55],zmm3[55]
; AVX512BW-NEXT:    vpmovb2m %zmm3, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm2, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsraw $2, %zmm0, %zmm2
; AVX512BW-NEXT:    vpaddw %zmm3, %zmm3, %zmm3
; AVX512BW-NEXT:    vpmovb2m %zmm3, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm2, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsraw $1, %zmm0, %zmm2
; AVX512BW-NEXT:    vpaddw %zmm3, %zmm3, %zmm3
; AVX512BW-NEXT:    vpmovb2m %zmm3, %k1
; AVX512BW-NEXT:    vmovdqu8 %zmm2, %zmm0 {%k1}
; AVX512BW-NEXT:    vpsrlw $8, %zmm0, %zmm0
; AVX512BW-NEXT:    vpackuswb %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %shift = ashr <64 x i8> %a, <i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>
  ret <64 x i8> %shift
}

;
; Uniform Constant Shifts
;

define <8 x i64> @splatconstant_shift_v8i64(<8 x i64> %a) nounwind {
; ALL-LABEL: splatconstant_shift_v8i64:
; ALL:       # %bb.0:
; ALL-NEXT:    vpsraq $7, %zmm0, %zmm0
; ALL-NEXT:    retq
  %shift = ashr <8 x i64> %a, <i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7>
  ret <8 x i64> %shift
}

define <16 x i32> @splatconstant_shift_v16i32(<16 x i32> %a) nounwind {
; ALL-LABEL: splatconstant_shift_v16i32:
; ALL:       # %bb.0:
; ALL-NEXT:    vpsrad $5, %zmm0, %zmm0
; ALL-NEXT:    retq
  %shift = ashr <16 x i32> %a, <i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5>
  ret <16 x i32> %shift
}

define <32 x i16> @splatconstant_shift_v32i16(<32 x i16> %a) nounwind {
; AVX512DQ-LABEL: splatconstant_shift_v32i16:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpsraw $3, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsraw $3, %ymm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: splatconstant_shift_v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsraw $3, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %shift = ashr <32 x i16> %a, <i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3>
  ret <32 x i16> %shift
}

define <64 x i8> @splatconstant_shift_v64i8(<64 x i8> %a) nounwind {
; AVX512DQ-LABEL: splatconstant_shift_v64i8:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpsrlw $3, %ymm0, %ymm0
; AVX512DQ-NEXT:    vmovdqa {{.*#+}} ymm2 = [31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31]
; AVX512DQ-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX512DQ-NEXT:    vmovdqa {{.*#+}} ymm3 = [16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]
; AVX512DQ-NEXT:    vpxor %ymm3, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsubb %ymm3, %ymm0, %ymm0
; AVX512DQ-NEXT:    vpsrlw $3, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpand %ymm2, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpxor %ymm3, %ymm1, %ymm1
; AVX512DQ-NEXT:    vpsubb %ymm3, %ymm1, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: splatconstant_shift_v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsrlw $3, %zmm0, %zmm0
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm0, %zmm0
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]
; AVX512BW-NEXT:    vpxorq %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpsubb %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %shift = ashr <64 x i8> %a, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  ret <64 x i8> %shift
}

define <64 x i8> @ashr_const7_v64i8(<64 x i8> %a) {
; AVX512DQ-LABEL: ashr_const7_v64i8:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512DQ-NEXT:    vpcmpgtb %ymm0, %ymm2, %ymm0
; AVX512DQ-NEXT:    vpcmpgtb %ymm1, %ymm2, %ymm1
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: ashr_const7_v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovb2m %zmm0, %k0
; AVX512BW-NEXT:    vpmovm2b %k0, %zmm0
; AVX512BW-NEXT:    retq
  %res = ashr <64 x i8> %a, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  ret <64 x i8> %res
}
