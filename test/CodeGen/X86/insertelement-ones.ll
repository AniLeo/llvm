; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse3 | FileCheck %s --check-prefix=SSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+ssse3 | FileCheck %s --check-prefix=SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,avx512bw | FileCheck %s --check-prefixes=AVX,AVX512
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX,AVX512

define <2 x i64> @insert_v2i64_x1(<2 x i64> %a) {
; SSE2-LABEL: insert_v2i64_x1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v2i64_x1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v2i64_x1:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v2i64_x1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: insert_v2i64_x1:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v2i64_x1:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v2i64_x1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX512-NEXT:    retq
  %1 = insertelement <2 x i64> %a, i64 -1, i32 0
  ret <2 x i64> %1
}

define <4 x i64> @insert_v4i64_01x3(<4 x i64> %a) {
; SSE2-LABEL: insert_v4i64_01x3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movlps {{.*#+}} xmm1 = mem[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v4i64_01x3:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movlps {{.*#+}} xmm1 = mem[0,1],xmm1[2,3]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v4i64_01x3:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movlps {{.*#+}} xmm1 = mem[0,1],xmm1[2,3]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v4i64_01x3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm2[0,1,2,3],xmm1[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: insert_v4i64_01x3:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm1[4,5],ymm0[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v4i64_01x3:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm1[4,5],ymm0[6,7]
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v4i64_01x3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX512-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm1[4,5],ymm0[6,7]
; AVX512-NEXT:    retq
  %1 = insertelement <4 x i64> %a, i64 -1, i32 2
  ret <4 x i64> %1
}

define <4 x i32> @insert_v4i32_01x3(<4 x i32> %a) {
; SSE2-LABEL: insert_v4i32_01x3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movl $-1, %eax
; SSE2-NEXT:    movd %eax, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v4i32_01x3:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movl $-1, %eax
; SSE3-NEXT:    movd %eax, %xmm1
; SSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v4i32_01x3:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movl $-1, %eax
; SSSE3-NEXT:    movd %eax, %xmm1
; SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v4i32_01x3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5],xmm0[6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: insert_v4i32_01x3:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5],xmm0[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v4i32_01x3:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm1[2],xmm0[3]
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v4i32_01x3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm1[2],xmm0[3]
; AVX512-NEXT:    retq
  %1 = insertelement <4 x i32> %a, i32 -1, i32 2
  ret <4 x i32> %1
}

define <8 x i32> @insert_v8i32_x12345x7(<8 x i32> %a) {
; SSE2-LABEL: insert_v8i32_x12345x7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE2-NEXT:    movl $-1, %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v8i32_x12345x7:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; SSE3-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE3-NEXT:    movl $-1, %eax
; SSE3-NEXT:    movd %eax, %xmm2
; SSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v8i32_x12345x7:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; SSSE3-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSSE3-NEXT:    movl $-1, %eax
; SSSE3-NEXT:    movd %eax, %xmm2
; SSSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v8i32_x12345x7:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm2[0,1],xmm0[2,3,4,5,6,7]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm2[4,5],xmm1[6,7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: insert_v8i32_x12345x7:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5],ymm1[6],ymm0[7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v8i32_x12345x7:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5],ymm1[6],ymm0[7]
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v8i32_x12345x7:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX512-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5],ymm1[6],ymm0[7]
; AVX512-NEXT:    retq
  %1 = insertelement <8 x i32> %a, i32 -1, i32 0
  %2 = insertelement <8 x i32> %1, i32 -1, i32 6
  ret <8 x i32> %2
}

define <8 x i16> @insert_v8i16_x12345x7(<8 x i16> %a) {
; SSE2-LABEL: insert_v8i16_x12345x7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movl $65535, %eax # imm = 0xFFFF
; SSE2-NEXT:    pinsrw $0, %eax, %xmm0
; SSE2-NEXT:    pinsrw $6, %eax, %xmm0
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v8i16_x12345x7:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movl $65535, %eax # imm = 0xFFFF
; SSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v8i16_x12345x7:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movl $65535, %eax # imm = 0xFFFF
; SSSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v8i16_x12345x7:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3,4,5],xmm1[6],xmm0[7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v8i16_x12345x7:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3,4,5],xmm1[6],xmm0[7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i16> %a, i16 -1, i32 0
  %2 = insertelement <8 x i16> %1, i16 -1, i32 6
  ret <8 x i16> %2
}

define <16 x i16> @insert_v16i16_x12345x789ABCDEx(<16 x i16> %a) {
; SSE2-LABEL: insert_v16i16_x12345x789ABCDEx:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movl $65535, %eax # imm = 0xFFFF
; SSE2-NEXT:    pinsrw $0, %eax, %xmm0
; SSE2-NEXT:    pinsrw $6, %eax, %xmm0
; SSE2-NEXT:    pinsrw $7, %eax, %xmm1
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v16i16_x12345x789ABCDEx:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movl $65535, %eax # imm = 0xFFFF
; SSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSE3-NEXT:    pinsrw $7, %eax, %xmm1
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v16i16_x12345x789ABCDEx:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movl $65535, %eax # imm = 0xFFFF
; SSSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSSE3-NEXT:    pinsrw $7, %eax, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v16i16_x12345x789ABCDEx:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3,4,5],xmm2[6],xmm0[7]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3,4,5,6],xmm2[7]
; SSE41-NEXT:    retq
;
; AVX1-LABEL: insert_v16i16_x12345x789ABCDEx:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v16i16_x12345x789ABCDEx:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0],xmm0[1,2,3,4,5],xmm1[6],xmm0[7]
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm2, %ymm2
; AVX2-NEXT:    vpblendw {{.*#+}} ymm0 = ymm0[0,1,2,3,4,5,6],ymm2[7],ymm0[8,9,10,11,12,13,14],ymm2[15]
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v16i16_x12345x789ABCDEx:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX512-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0],xmm0[1,2,3,4,5],xmm1[6],xmm0[7]
; AVX512-NEXT:    vpcmpeqd %ymm2, %ymm2, %ymm2
; AVX512-NEXT:    vpblendw {{.*#+}} ymm0 = ymm0[0,1,2,3,4,5,6],ymm2[7],ymm0[8,9,10,11,12,13,14],ymm2[15]
; AVX512-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX512-NEXT:    retq
  %1 = insertelement <16 x i16> %a, i16 -1, i32 0
  %2 = insertelement <16 x i16> %1, i16 -1, i32 6
  %3 = insertelement <16 x i16> %2, i16 -1, i32 15
  ret <16 x i16> %3
}

define <16 x i8> @insert_v16i8_x123456789ABCDEx(<16 x i8> %a) {
; SSE2-LABEL: insert_v16i8_x123456789ABCDEx:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    movl $255, %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    pandn %xmm2, %xmm1
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE2-NEXT:    pslldq {{.*#+}} xmm2 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm2[0]
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v16i8_x123456789ABCDEx:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movdqa {{.*#+}} xmm1 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE3-NEXT:    pand %xmm1, %xmm0
; SSE3-NEXT:    movl $255, %eax
; SSE3-NEXT:    movd %eax, %xmm2
; SSE3-NEXT:    pandn %xmm2, %xmm1
; SSE3-NEXT:    por %xmm1, %xmm0
; SSE3-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE3-NEXT:    pslldq {{.*#+}} xmm2 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm2[0]
; SSE3-NEXT:    por %xmm2, %xmm0
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v16i8_x123456789ABCDEx:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movl $255, %eax
; SSSE3-NEXT:    movd %eax, %xmm1
; SSSE3-NEXT:    movdqa %xmm1, %xmm2
; SSSE3-NEXT:    palignr {{.*#+}} xmm2 = xmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],xmm2[0]
; SSSE3-NEXT:    pshufb {{.*#+}} xmm2 = xmm2[15,0,1,2,3,4,5,6,7,8,9,10,11,12,13],zero
; SSSE3-NEXT:    pslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0]
; SSSE3-NEXT:    por %xmm2, %xmm1
; SSSE3-NEXT:    movdqa %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v16i8_x123456789ABCDEx:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movl $255, %eax
; SSE41-NEXT:    pinsrb $0, %eax, %xmm0
; SSE41-NEXT:    pinsrb $15, %eax, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v16i8_x123456789ABCDEx:
; AVX:       # %bb.0:
; AVX-NEXT:    movl $255, %eax
; AVX-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = insertelement <16 x i8> %a, i8 -1, i32 0
  %2 = insertelement <16 x i8> %1, i8 -1, i32 15
  ret <16 x i8> %2
}

define <32 x i8> @insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx(<32 x i8> %a) {
; SSE2-LABEL: insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    movl $255, %eax
; SSE2-NEXT:    movd %eax, %xmm3
; SSE2-NEXT:    pandn %xmm3, %xmm2
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0]
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    pslldq {{.*#+}} xmm4 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm4[0]
; SSE2-NEXT:    por %xmm4, %xmm0
; SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE2-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1]
; SSE2-NEXT:    por %xmm3, %xmm1
; SSE2-NEXT:    pand %xmm2, %xmm1
; SSE2-NEXT:    por %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movdqa {{.*#+}} xmm2 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE3-NEXT:    pand %xmm2, %xmm0
; SSE3-NEXT:    movl $255, %eax
; SSE3-NEXT:    movd %eax, %xmm3
; SSE3-NEXT:    pandn %xmm3, %xmm2
; SSE3-NEXT:    por %xmm2, %xmm0
; SSE3-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0]
; SSE3-NEXT:    pand %xmm2, %xmm0
; SSE3-NEXT:    movdqa %xmm3, %xmm4
; SSE3-NEXT:    pslldq {{.*#+}} xmm4 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm4[0]
; SSE3-NEXT:    por %xmm4, %xmm0
; SSE3-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE3-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1]
; SSE3-NEXT:    por %xmm3, %xmm1
; SSE3-NEXT:    pand %xmm2, %xmm1
; SSE3-NEXT:    por %xmm4, %xmm1
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movl $255, %eax
; SSSE3-NEXT:    movd %eax, %xmm3
; SSSE3-NEXT:    movdqa %xmm3, %xmm2
; SSSE3-NEXT:    palignr {{.*#+}} xmm2 = xmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],xmm2[0]
; SSSE3-NEXT:    pshufb {{.*#+}} xmm2 = xmm2[15,0,1,2,3,4,5,6,7,8,9,10,11,12,13],zero
; SSSE3-NEXT:    movdqa %xmm3, %xmm0
; SSSE3-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0]
; SSSE3-NEXT:    por %xmm0, %xmm2
; SSSE3-NEXT:    pshufb {{.*#+}} xmm1 = xmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13],zero,xmm1[u]
; SSSE3-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1]
; SSSE3-NEXT:    por %xmm3, %xmm1
; SSSE3-NEXT:    pshufb {{.*#+}} xmm1 = xmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],zero
; SSSE3-NEXT:    por %xmm0, %xmm1
; SSSE3-NEXT:    movdqa %xmm2, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movl $255, %eax
; SSE41-NEXT:    pinsrb $0, %eax, %xmm0
; SSE41-NEXT:    pinsrb $15, %eax, %xmm0
; SSE41-NEXT:    pinsrb $14, %eax, %xmm1
; SSE41-NEXT:    pinsrb $15, %eax, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx:
; AVX1:       # %bb.0:
; AVX1-NEXT:    movl $255, %eax
; AVX1-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm1
; AVX1-NEXT:    vpinsrb $15, %eax, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpinsrb $14, %eax, %xmm0, %xmm0
; AVX1-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movl $255, %eax
; AVX2-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm1
; AVX2-NEXT:    vpinsrb $15, %eax, %xmm1, %xmm1
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpinsrb $14, %eax, %xmm0, %xmm0
; AVX2-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v32i8_x123456789ABCDEzGHIJKLMNOPQRSTxx:
; AVX512:       # %bb.0:
; AVX512-NEXT:    movl $255, %eax
; AVX512-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm1
; AVX512-NEXT:    vpinsrb $15, %eax, %xmm1, %xmm1
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512-NEXT:    vpinsrb $14, %eax, %xmm0, %xmm0
; AVX512-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; AVX512-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %1 = insertelement <32 x i8> %a, i8 -1, i32 0
  %2 = insertelement <32 x i8> %1, i8 -1, i32 15
  %3 = insertelement <32 x i8> %2, i8 -1, i32 30
  %4 = insertelement <32 x i8> %3, i8 -1, i32 31
  ret <32 x i8> %4
}
