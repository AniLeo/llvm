; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw -mattr=+avx512vl -mattr=+avx512dq| FileCheck %s --check-prefix=VL_BW_DQ

define <2 x i1> @shuf2i1_1_0(<2 x i1> %a) {
; AVX512F-LABEL: shuf2i1_1_0:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,3,0,1]
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf2i1_1_0:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpsllq $63, %xmm0, %xmm0
; AVX512VL-NEXT:    vptestmq %xmm0, %xmm0, %k1
; AVX512VL-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX512VL-NEXT:    vmovdqa64 %xmm0, %xmm1 {%k1} {z}
; AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,3,0,1]
; AVX512VL-NEXT:    vpsllq $63, %xmm1, %xmm1
; AVX512VL-NEXT:    vptestmq %xmm1, %xmm1, %k1
; AVX512VL-NEXT:    vmovdqa64 %xmm0, %xmm0 {%k1} {z}
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf2i1_1_0:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    vpsllq $63, %xmm0, %xmm0
; VL_BW_DQ-NEXT:    vptestmq %xmm0, %xmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %xmm0
; VL_BW_DQ-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; VL_BW_DQ-NEXT:    vpmovq2m %xmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %xmm0
; VL_BW_DQ-NEXT:    retq
  %b = shufflevector <2 x i1> %a, <2 x i1> undef, <2 x i32> <i32 1, i32 0>
  ret <2 x i1> %b
}

define <2 x i1> @shuf2i1_1_2(<2 x i1> %a) {
; AVX512F-LABEL: shuf2i1_1_2:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    movl $1, %eax
; AVX512F-NEXT:    vmovq %rax, %xmm1
; AVX512F-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5,6,7]
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf2i1_1_2:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpsllq $63, %xmm0, %xmm0
; AVX512VL-NEXT:    vptestmq %xmm0, %xmm0, %k1
; AVX512VL-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX512VL-NEXT:    vmovdqa64 %xmm0, %xmm1 {%k1} {z}
; AVX512VL-NEXT:    movb $1, %al
; AVX512VL-NEXT:    kmovw %eax, %k1
; AVX512VL-NEXT:    vmovdqa64 %xmm0, %xmm2 {%k1} {z}
; AVX512VL-NEXT:    vpalignr {{.*#+}} xmm1 = xmm1[8,9,10,11,12,13,14,15],xmm2[0,1,2,3,4,5,6,7]
; AVX512VL-NEXT:    vpsllq $63, %xmm1, %xmm1
; AVX512VL-NEXT:    vptestmq %xmm1, %xmm1, %k1
; AVX512VL-NEXT:    vmovdqa64 %xmm0, %xmm0 {%k1} {z}
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf2i1_1_2:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    vpsllq $63, %xmm0, %xmm0
; VL_BW_DQ-NEXT:    vptestmq %xmm0, %xmm0, %k0
; VL_BW_DQ-NEXT:    movb $1, %al
; VL_BW_DQ-NEXT:    kmovd %eax, %k1
; VL_BW_DQ-NEXT:    vpmovm2q %k1, %xmm0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %xmm1
; VL_BW_DQ-NEXT:    vpalignr {{.*#+}} xmm0 = xmm1[8,9,10,11,12,13,14,15],xmm0[0,1,2,3,4,5,6,7]
; VL_BW_DQ-NEXT:    vpmovq2m %xmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %xmm0
; VL_BW_DQ-NEXT:    retq
  %b = shufflevector <2 x i1> %a, <2 x i1> <i1 1, i1 0>, <2 x i32> <i32 1, i32 2>
  ret <2 x i1> %b
}


define <4 x i1> @shuf4i1_3_2_10(<4 x i1> %a) {
; AVX512F-LABEL: shuf4i1_3_2_10:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,2,1,0]
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf4i1_3_2_10:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX512VL-NEXT:    vptestmd %xmm0, %xmm0, %k1
; AVX512VL-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX512VL-NEXT:    vmovdqa32 %xmm0, %xmm1 {%k1} {z}
; AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[3,2,1,0]
; AVX512VL-NEXT:    vpslld $31, %xmm1, %xmm1
; AVX512VL-NEXT:    vptestmd %xmm1, %xmm1, %k1
; AVX512VL-NEXT:    vmovdqa32 %xmm0, %xmm0 {%k1} {z}
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf4i1_3_2_10:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    vpslld $31, %xmm0, %xmm0
; VL_BW_DQ-NEXT:    vptestmd %xmm0, %xmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2d %k0, %xmm0
; VL_BW_DQ-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[3,2,1,0]
; VL_BW_DQ-NEXT:    vpmovd2m %xmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2d %k0, %xmm0
; VL_BW_DQ-NEXT:    retq
  %b = shufflevector <4 x i1> %a, <4 x i1> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret <4 x i1> %b
}

define <8 x i1> @shuf8i1_3_6_1_0_3_7_7_0(<8 x i64> %a, <8 x i64> %b, <8 x i64> %a1, <8 x i64> %b1) {
; AVX512F-LABEL: shuf8i1_3_6_1_0_3_7_7_0:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpcmpeqq %zmm2, %zmm0, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [3,6,1,0,3,7,7,0]
; AVX512F-NEXT:    vpermq %zmm0, %zmm1, %zmm0
; AVX512F-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vpmovqw %zmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1_3_6_1_0_3_7_7_0:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpcmpeqq %zmm2, %zmm0, %k1
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [3,6,1,0,3,7,7,0]
; AVX512VL-NEXT:    vpermq %zmm0, %zmm1, %zmm0
; AVX512VL-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; AVX512VL-NEXT:    vpcmpeqd %ymm0, %ymm0, %ymm0
; AVX512VL-NEXT:    vmovdqa32 %ymm0, %ymm0 {%k1} {z}
; AVX512VL-NEXT:    vpmovdw %ymm0, %xmm0
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1_3_6_1_0_3_7_7_0:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    vpcmpeqq %zmm2, %zmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [3,6,1,0,3,7,7,0]
; VL_BW_DQ-NEXT:    vpermq %zmm0, %zmm1, %zmm0
; VL_BW_DQ-NEXT:    vpmovq2m %zmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2w %k0, %xmm0
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %a2 = icmp eq <8 x i64> %a, %a1
  %b2 = icmp eq <8 x i64> %b, %b1
  %c = shufflevector <8 x i1> %a2, <8 x i1> %b2, <8 x i32> <i32 3, i32 6, i32 1, i32 0, i32 3, i32 7, i32 7, i32 0>
  ret <8 x i1> %c
}

define <16 x i1> @shuf16i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0(<16 x i32> %a, <16 x i32> %b, <16 x i32> %a1, <16 x i32> %b1) {
; AVX512F-LABEL: shuf16i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpcmpeqd %zmm2, %zmm0, %k1
; AVX512F-NEXT:    vpcmpeqd %zmm3, %zmm1, %k2
; AVX512F-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k2} {z}
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vmovdqa32 {{.*#+}} zmm2 = [3,6,22,12,3,7,7,0,3,6,1,13,3,21,7,0]
; AVX512F-NEXT:    vpermi2d %zmm0, %zmm1, %zmm2
; AVX512F-NEXT:    vpslld $31, %zmm2, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf16i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpcmpeqd %zmm2, %zmm0, %k1
; AVX512VL-NEXT:    vpcmpeqd %zmm3, %zmm1, %k2
; AVX512VL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k2} {z}
; AVX512VL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512VL-NEXT:    vmovdqa32 {{.*#+}} zmm2 = [3,6,22,12,3,7,7,0,3,6,1,13,3,21,7,0]
; AVX512VL-NEXT:    vpermi2d %zmm0, %zmm1, %zmm2
; AVX512VL-NEXT:    vpslld $31, %zmm2, %zmm0
; AVX512VL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512VL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf16i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    vpcmpeqd %zmm2, %zmm0, %k0
; VL_BW_DQ-NEXT:    vpcmpeqd %zmm3, %zmm1, %k1
; VL_BW_DQ-NEXT:    vpmovm2d %k1, %zmm0
; VL_BW_DQ-NEXT:    vpmovm2d %k0, %zmm1
; VL_BW_DQ-NEXT:    vmovdqa32 {{.*#+}} zmm2 = [3,6,22,12,3,7,7,0,3,6,1,13,3,21,7,0]
; VL_BW_DQ-NEXT:    vpermi2d %zmm0, %zmm1, %zmm2
; VL_BW_DQ-NEXT:    vpmovd2m %zmm2, %k0
; VL_BW_DQ-NEXT:    vpmovm2b %k0, %xmm0
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %a2 = icmp eq <16 x i32> %a, %a1
  %b2 = icmp eq <16 x i32> %b, %b1
  %c = shufflevector <16 x i1> %a2, <16 x i1> %b2, <16 x i32> <i32 3, i32 6, i32 22, i32 12, i32 3, i32 7, i32 7, i32 0, i32 3, i32 6, i32 1, i32 13, i32 3, i32 21, i32 7, i32 0>
  ret <16 x i1> %c
}

define <32 x i1> @shuf32i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0(<32 x i1> %a) {
; AVX512F-LABEL: shuf32i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm1 = ymm0[3,6,u,12,3,7,7,0,3,6,1,13,3,u,7,0,u,u,22,u,u,u,u,u,u,u,u,u,u,21,u,u]
; AVX512F-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,u,6,u,u,u,u,u,u,u,u,u,u,5,u,u,19,22,u,28,19,23,23,16,19,22,17,29,19,u,23,16]
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [255,255,0,255,255,255,255,255,255,255,255,255,255,0,255,255,0,0,255,0,0,0,0,0,0,0,0,0,0,255,0,0]
; AVX512F-NEXT:    vpblendvb %ymm2, %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf32i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpshufb {{.*#+}} ymm1 = ymm0[3,6,u,12,3,7,7,0,3,6,1,13,3,u,7,0,u,u,22,u,u,u,u,u,u,u,u,u,u,21,u,u]
; AVX512VL-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX512VL-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,u,6,u,u,u,u,u,u,u,u,u,u,5,u,u,19,22,u,28,19,23,23,16,19,22,17,29,19,u,23,16]
; AVX512VL-NEXT:    vmovdqa {{.*#+}} ymm2 = [255,255,0,255,255,255,255,255,255,255,255,255,255,0,255,255,0,0,255,0,0,0,0,0,0,0,0,0,0,255,0,0]
; AVX512VL-NEXT:    vpblendvb %ymm2, %ymm1, %ymm0, %ymm0
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf32i1_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0_3_6_22_12_3_7_7_0_3_6_1_13_3_21_7_0:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    vpsllw $7, %ymm0, %ymm0
; VL_BW_DQ-NEXT:    vpmovb2m %ymm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2w %k0, %zmm0
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [3,6,22,12,3,7,7,0,3,6,1,13,3,21,7,0,3,6,22,12,3,7,7,0,3,6,1,13,3,21,7,0]
; VL_BW_DQ-NEXT:    vpermw %zmm0, %zmm1, %zmm0
; VL_BW_DQ-NEXT:    vpmovw2m %zmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2b %k0, %ymm0
; VL_BW_DQ-NEXT:    retq
  %b = shufflevector <32 x i1> %a, <32 x i1> undef, <32 x i32> <i32 3, i32 6, i32 22, i32 12, i32 3, i32 7, i32 7, i32 0, i32 3, i32 6, i32 1, i32 13, i32 3, i32 21, i32 7, i32 0, i32 3, i32 6, i32 22, i32 12, i32 3, i32 7, i32 7, i32 0, i32 3, i32 6, i32 1, i32 13, i32 3, i32 21, i32 7, i32 0>
  ret <32 x i1> %b
}

define <8 x i1> @shuf8i1_u_2_u_u_2_u_2_u(i8 %a) {
; AVX512F-LABEL: shuf8i1_u_2_u_u_2_u_2_u:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512F-NEXT:    vpbroadcastq %xmm0, %zmm0
; AVX512F-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vpmovqw %zmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1_u_2_u_u_2_u_2_u:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    kmovw %edi, %k1
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512VL-NEXT:    vpbroadcastq %xmm0, %zmm0
; AVX512VL-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; AVX512VL-NEXT:    vpcmpeqd %ymm0, %ymm0, %ymm0
; AVX512VL-NEXT:    vmovdqa32 %ymm0, %ymm0 {%k1} {z}
; AVX512VL-NEXT:    vpmovdw %ymm0, %xmm0
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1_u_2_u_u_2_u_2_u:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovd %edi, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vextracti128 $1, %ymm0, %xmm0
; VL_BW_DQ-NEXT:    vpbroadcastq %xmm0, %zmm0
; VL_BW_DQ-NEXT:    vpmovq2m %zmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2w %k0, %xmm0
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i8 %a to <8 x i1>
  %c = shufflevector < 8 x i1> %b, <8 x i1>undef, <8 x i32> <i32 undef, i32 2, i32 undef, i32 undef, i32 2, i32 undef, i32 2, i32 undef>
  ret <8 x i1> %c
}

define i8 @shuf8i1_10_2_9_u_3_u_2_u(i8 %a) {
; AVX512F-LABEL: shuf8i1_10_2_9_u_3_u_2_u:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vmovdqa64 {{.*#+}} zmm2 = <8,2,10,u,3,u,2,u>
; AVX512F-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512F-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1_10_2_9_u_3_u_2_u:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    kmovw %edi, %k1
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512VL-NEXT:    vmovdqa64 {{.*#+}} zmm2 = <8,2,10,u,3,u,2,u>
; AVX512VL-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512VL-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1_10_2_9_u_3_u_2_u:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovd %edi, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm2 = <8,2,10,u,3,u,2,u>
; VL_BW_DQ-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; VL_BW_DQ-NEXT:    vpmovq2m %zmm2, %k0
; VL_BW_DQ-NEXT:    kmovd %k0, %eax
; VL_BW_DQ-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i8 %a to <8 x i1>
  %c = shufflevector < 8 x i1> %b, <8 x i1> zeroinitializer, <8 x i32> <i32 10, i32 2, i32 9, i32 undef, i32 3, i32 undef, i32 2, i32 undef>
  %d = bitcast <8 x i1> %c to i8
  ret i8 %d
}

define i8 @shuf8i1_0_1_4_5_u_u_u_u(i8 %a) {
; AVX512F-LABEL: shuf8i1_0_1_4_5_u_u_u_u:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vshufi64x2 {{.*#+}} zmm0 = zmm0[0,1,4,5,0,1,0,1]
; AVX512F-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1_0_1_4_5_u_u_u_u:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    kmovw %edi, %k1
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vshufi64x2 {{.*#+}} zmm0 = zmm0[0,1,4,5,0,1,0,1]
; AVX512VL-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1_0_1_4_5_u_u_u_u:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovd %edi, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vshufi64x2 {{.*#+}} zmm0 = zmm0[0,1,4,5,0,1,0,1]
; VL_BW_DQ-NEXT:    vpmovq2m %zmm0, %k0
; VL_BW_DQ-NEXT:    kmovd %k0, %eax
; VL_BW_DQ-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i8 %a to <8 x i1>
  %c = shufflevector < 8 x i1> %b, <8 x i1> undef, <8 x i32> <i32 0, i32 1, i32 4, i32 5, i32 undef, i32 undef, i32 undef, i32 undef>
  %d = bitcast <8 x i1> %c to i8
  ret i8 %d
}

define i8 @shuf8i1_9_6_1_0_3_7_7_0(i8 %a) {
; AVX512F-LABEL: shuf8i1_9_6_1_0_3_7_7_0:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [8,6,1,0,3,7,7,0]
; AVX512F-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512F-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1_9_6_1_0_3_7_7_0:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    kmovw %edi, %k1
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512VL-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [8,6,1,0,3,7,7,0]
; AVX512VL-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512VL-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1_9_6_1_0_3_7_7_0:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovd %edi, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [8,6,1,0,3,7,7,0]
; VL_BW_DQ-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; VL_BW_DQ-NEXT:    vpmovq2m %zmm2, %k0
; VL_BW_DQ-NEXT:    kmovd %k0, %eax
; VL_BW_DQ-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i8 %a to <8 x i1>
  %c = shufflevector <8 x i1> %b, <8 x i1> zeroinitializer, <8 x i32> <i32 9, i32 6, i32 1, i32 0, i32 3, i32 7, i32 7, i32 0>
  %d = bitcast <8 x i1>%c to i8
  ret i8 %d
}

define i8 @shuf8i1_9_6_1_10_3_7_7_0(i8 %a) {
; AVX512F-LABEL: shuf8i1_9_6_1_10_3_7_7_0:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [9,1,2,10,4,5,6,7]
; AVX512F-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512F-NEXT:    vpermt2q %zmm0, %zmm1, %zmm2
; AVX512F-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1_9_6_1_10_3_7_7_0:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    kmovw %edi, %k1
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [9,1,2,10,4,5,6,7]
; AVX512VL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512VL-NEXT:    vpermt2q %zmm0, %zmm1, %zmm2
; AVX512VL-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1_9_6_1_10_3_7_7_0:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovd %edi, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [9,1,2,10,4,5,6,7]
; VL_BW_DQ-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; VL_BW_DQ-NEXT:    vpermt2q %zmm0, %zmm1, %zmm2
; VL_BW_DQ-NEXT:    vpmovq2m %zmm2, %k0
; VL_BW_DQ-NEXT:    kmovd %k0, %eax
; VL_BW_DQ-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i8 %a to <8 x i1>
  %c = shufflevector <8 x i1> zeroinitializer, <8 x i1> %b, <8 x i32> <i32 9, i32 6, i32 1, i32 10, i32 3, i32 7, i32 7, i32 0>
  %d = bitcast <8 x i1>%c to i8
  ret i8 %d
}

define i8 @shuf8i1__9_6_1_10_3_7_7_1(i8 %a) {
; AVX512F-LABEL: shuf8i1__9_6_1_10_3_7_7_1:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    movb $51, %al
; AVX512F-NEXT:    kmovw %eax, %k2
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k2} {z}
; AVX512F-NEXT:    vpternlogq $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [9,6,1,0,3,7,7,1]
; AVX512F-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512F-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1__9_6_1_10_3_7_7_1:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    kmovw %edi, %k1
; AVX512VL-NEXT:    movb $51, %al
; AVX512VL-NEXT:    kmovw %eax, %k2
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k2} {z}
; AVX512VL-NEXT:    vpternlogq $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512VL-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [9,6,1,0,3,7,7,1]
; AVX512VL-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512VL-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1__9_6_1_10_3_7_7_1:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovd %edi, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [9,6,1,0,3,7,7,1]
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [18446744073709551615,18446744073709551615,0,0,18446744073709551615,18446744073709551615,0,0]
; VL_BW_DQ-NEXT:    vpermt2q %zmm0, %zmm1, %zmm2
; VL_BW_DQ-NEXT:    vpmovq2m %zmm2, %k0
; VL_BW_DQ-NEXT:    kmovd %k0, %eax
; VL_BW_DQ-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i8 %a to <8 x i1>
  %c = shufflevector <8 x i1> <i1 1, i1 1, i1 0, i1 0, i1 1, i1 1, i1 0, i1 0>, <8 x i1> %b, <8 x i32> <i32 9, i32 6, i32 1, i32 0, i32 3, i32 7, i32 7, i32 1>
  %c1 = bitcast <8 x i1>%c to i8
  ret i8 %c1
}

define i8 @shuf8i1_9_6_1_10_3_7_7_0_all_ones(<8 x i1> %a) {
; AVX512F-LABEL: shuf8i1_9_6_1_10_3_7_7_0_all_ones:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpmovsxwq %xmm0, %zmm0
; AVX512F-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [9,1,2,3,4,5,6,7]
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2
; AVX512F-NEXT:    vpermt2q %zmm0, %zmm1, %zmm2
; AVX512F-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf8i1_9_6_1_10_3_7_7_0_all_ones:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpmovsxwq %xmm0, %zmm0
; AVX512VL-NEXT:    vpsllq $63, %zmm0, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; AVX512VL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [9,1,2,3,4,5,6,7]
; AVX512VL-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2
; AVX512VL-NEXT:    vpermt2q %zmm0, %zmm1, %zmm2
; AVX512VL-NEXT:    vpsllq $63, %zmm2, %zmm0
; AVX512VL-NEXT:    vptestmq %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf8i1_9_6_1_10_3_7_7_0_all_ones:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    vpsllw $15, %xmm0, %xmm0
; VL_BW_DQ-NEXT:    vpmovw2m %xmm0, %k0
; VL_BW_DQ-NEXT:    vpmovm2q %k0, %zmm0
; VL_BW_DQ-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [9,1,2,3,4,5,6,7]
; VL_BW_DQ-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2
; VL_BW_DQ-NEXT:    vpermt2q %zmm0, %zmm1, %zmm2
; VL_BW_DQ-NEXT:    vpmovq2m %zmm2, %k0
; VL_BW_DQ-NEXT:    kmovd %k0, %eax
; VL_BW_DQ-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %c = shufflevector <8 x i1> <i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1>, <8 x i1> %a, <8 x i32> <i32 9, i32 6, i32 1, i32 0, i32 3, i32 7, i32 7, i32 0>
  %c1 = bitcast <8 x i1>%c to i8
  ret i8 %c1
}


define i16 @shuf16i1_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0(i16 %a) {
; AVX512F-LABEL: shuf16i1_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vpbroadcastd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf16i1_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    kmovw %edi, %k1
; AVX512VL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vpbroadcastd %xmm0, %zmm0
; AVX512VL-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512VL-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf16i1_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovd %edi, %k0
; VL_BW_DQ-NEXT:    vpmovm2d %k0, %zmm0
; VL_BW_DQ-NEXT:    vpbroadcastd %xmm0, %zmm0
; VL_BW_DQ-NEXT:    vpmovd2m %zmm0, %k0
; VL_BW_DQ-NEXT:    kmovd %k0, %eax
; VL_BW_DQ-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i16 %a to <16 x i1>
  %c = shufflevector < 16 x i1> %b, <16 x i1> undef, <16 x i32> zeroinitializer
  %d = bitcast <16 x i1> %c to i16
  ret i16 %d
}

define i64 @shuf64i1_zero(i64 %a) {
; AVX512F-LABEL: shuf64i1_zero:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    pushq %rbp
; AVX512F-NEXT:    .cfi_def_cfa_offset 16
; AVX512F-NEXT:    .cfi_offset %rbp, -16
; AVX512F-NEXT:    movq %rsp, %rbp
; AVX512F-NEXT:    .cfi_def_cfa_register %rbp
; AVX512F-NEXT:    andq $-32, %rsp
; AVX512F-NEXT:    subq $96, %rsp
; AVX512F-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; AVX512F-NEXT:    kmovw {{[0-9]+}}(%rsp), %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vpbroadcastb %xmm0, %ymm0
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512F-NEXT:    vpmovsxbd %xmm1, %zmm1
; AVX512F-NEXT:    vpslld $31, %zmm1, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k0
; AVX512F-NEXT:    kmovw %k0, {{[0-9]+}}(%rsp)
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, (%rsp)
; AVX512F-NEXT:    movl (%rsp), %ecx
; AVX512F-NEXT:    movq %rcx, %rax
; AVX512F-NEXT:    shlq $32, %rax
; AVX512F-NEXT:    orq %rcx, %rax
; AVX512F-NEXT:    movq %rbp, %rsp
; AVX512F-NEXT:    popq %rbp
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuf64i1_zero:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    pushq %rbp
; AVX512VL-NEXT:    .cfi_def_cfa_offset 16
; AVX512VL-NEXT:    .cfi_offset %rbp, -16
; AVX512VL-NEXT:    movq %rsp, %rbp
; AVX512VL-NEXT:    .cfi_def_cfa_register %rbp
; AVX512VL-NEXT:    andq $-32, %rsp
; AVX512VL-NEXT:    subq $96, %rsp
; AVX512VL-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; AVX512VL-NEXT:    kmovw {{[0-9]+}}(%rsp), %k1
; AVX512VL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512VL-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512VL-NEXT:    vpbroadcastb %xmm0, %ymm0
; AVX512VL-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512VL-NEXT:    vpmovsxbd %xmm1, %zmm1
; AVX512VL-NEXT:    vpslld $31, %zmm1, %zmm1
; AVX512VL-NEXT:    vptestmd %zmm1, %zmm1, %k0
; AVX512VL-NEXT:    kmovw %k0, {{[0-9]+}}(%rsp)
; AVX512VL-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512VL-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512VL-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512VL-NEXT:    kmovw %k0, (%rsp)
; AVX512VL-NEXT:    movl (%rsp), %ecx
; AVX512VL-NEXT:    movq %rcx, %rax
; AVX512VL-NEXT:    shlq $32, %rax
; AVX512VL-NEXT:    orq %rcx, %rax
; AVX512VL-NEXT:    movq %rbp, %rsp
; AVX512VL-NEXT:    popq %rbp
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; VL_BW_DQ-LABEL: shuf64i1_zero:
; VL_BW_DQ:       # BB#0:
; VL_BW_DQ-NEXT:    kmovq %rdi, %k0
; VL_BW_DQ-NEXT:    vpmovm2b %k0, %zmm0
; VL_BW_DQ-NEXT:    vpbroadcastb %xmm0, %zmm0
; VL_BW_DQ-NEXT:    vpmovb2m %zmm0, %k0
; VL_BW_DQ-NEXT:    kmovq %k0, %rax
; VL_BW_DQ-NEXT:    vzeroupper
; VL_BW_DQ-NEXT:    retq
  %b = bitcast i64 %a to <64 x i1>
  %c = shufflevector < 64 x i1> %b, <64 x i1> undef, <64 x i32> zeroinitializer
  %d = bitcast <64 x i1> %c to i64
  ret i64 %d
}
