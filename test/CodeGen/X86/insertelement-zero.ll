; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse3 | FileCheck %s --check-prefixes=SSE,SSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+ssse3 | FileCheck %s --check-prefixes=SSE,SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-FAST
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-FAST

define <2 x double> @insert_v2f64_z1(<2 x double> %a) {
; SSE2-LABEL: insert_v2f64_z1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorpd %xmm1, %xmm1
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v2f64_z1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorpd %xmm1, %xmm1
; SSE3-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v2f64_z1:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorpd %xmm1, %xmm1
; SSSE3-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v2f64_z1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm1, %xmm1
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v2f64_z1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %1 = insertelement <2 x double> %a, double 0.0, i32 0
  ret <2 x double> %1
}

define <4 x double> @insert_v4f64_0zz3(<4 x double> %a) {
; SSE2-LABEL: insert_v4f64_0zz3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; SSE2-NEXT:    xorpd %xmm2, %xmm2
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm2[0],xmm1[1]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v4f64_0zz3:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; SSE3-NEXT:    xorpd %xmm2, %xmm2
; SSE3-NEXT:    movsd {{.*#+}} xmm1 = xmm2[0],xmm1[1]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v4f64_0zz3:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; SSSE3-NEXT:    xorpd %xmm2, %xmm2
; SSSE3-NEXT:    movsd {{.*#+}} xmm1 = xmm2[0],xmm1[1]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v4f64_0zz3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; SSE41-NEXT:    xorps %xmm2, %xmm2
; SSE41-NEXT:    blendps {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v4f64_0zz3:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3,4,5],ymm0[6,7]
; AVX-NEXT:    retq
  %1 = insertelement <4 x double> %a, double 0.0, i32 1
  %2 = insertelement <4 x double> %1, double 0.0, i32 2
  ret <4 x double> %2
}

define <2 x i64> @insert_v2i64_z1(<2 x i64> %a) {
; SSE2-LABEL: insert_v2i64_z1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorpd %xmm1, %xmm1
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v2i64_z1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorpd %xmm1, %xmm1
; SSE3-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v2i64_z1:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorpd %xmm1, %xmm1
; SSSE3-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v2i64_z1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm1, %xmm1
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v2i64_z1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %1 = insertelement <2 x i64> %a, i64 0, i32 0
  ret <2 x i64> %1
}

define <4 x i64> @insert_v4i64_01z3(<4 x i64> %a) {
; SSE2-LABEL: insert_v4i64_01z3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorpd %xmm2, %xmm2
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm2[0],xmm1[1]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v4i64_01z3:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorpd %xmm2, %xmm2
; SSE3-NEXT:    movsd {{.*#+}} xmm1 = xmm2[0],xmm1[1]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v4i64_01z3:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorpd %xmm2, %xmm2
; SSSE3-NEXT:    movsd {{.*#+}} xmm1 = xmm2[0],xmm1[1]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v4i64_01z3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm2, %xmm2
; SSE41-NEXT:    blendps {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v4i64_01z3:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm1[4,5],ymm0[6,7]
; AVX-NEXT:    retq
  %1 = insertelement <4 x i64> %a, i64 0, i32 2
  ret <4 x i64> %1
}

define <4 x float> @insert_v4f32_01z3(<4 x float> %a) {
; SSE2-LABEL: insert_v4f32_01z3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorps %xmm1, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v4f32_01z3:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorps %xmm1, %xmm1
; SSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v4f32_01z3:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorps %xmm1, %xmm1
; SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v4f32_01z3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm1, %xmm1
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2],xmm0[3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v4f32_01z3:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2],xmm0[3]
; AVX-NEXT:    retq
  %1 = insertelement <4 x float> %a, float 0.0, i32 2
  ret <4 x float> %1
}

define <8 x float> @insert_v8f32_z12345z7(<8 x float> %a) {
; SSE2-LABEL: insert_v8f32_z12345z7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorps %xmm2, %xmm2
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v8f32_z12345z7:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorps %xmm2, %xmm2
; SSE3-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v8f32_z12345z7:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorps %xmm2, %xmm2
; SSSE3-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v8f32_z12345z7:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm2, %xmm2
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE41-NEXT:    blendps {{.*#+}} xmm1 = xmm1[0,1],xmm2[2],xmm1[3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v8f32_z12345z7:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5],ymm1[6],ymm0[7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x float> %a, float 0.0, i32 0
  %2 = insertelement <8 x float> %1, float 0.0, i32 6
  ret <8 x float> %2
}

define <4 x i32> @insert_v4i32_01z3(<4 x i32> %a) {
; SSE2-LABEL: insert_v4i32_01z3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorps %xmm1, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v4i32_01z3:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorps %xmm1, %xmm1
; SSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v4i32_01z3:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorps %xmm1, %xmm1
; SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; SSSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,2]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v4i32_01z3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm1, %xmm1
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2],xmm0[3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v4i32_01z3:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2],xmm0[3]
; AVX-NEXT:    retq
  %1 = insertelement <4 x i32> %a, i32 0, i32 2
  ret <4 x i32> %1
}

define <8 x i32> @insert_v8i32_z12345z7(<8 x i32> %a) {
; SSE2-LABEL: insert_v8i32_z12345z7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorps %xmm2, %xmm2
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE2-NEXT:    xorps %xmm2, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v8i32_z12345z7:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorps %xmm2, %xmm2
; SSE3-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE3-NEXT:    xorps %xmm2, %xmm2
; SSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v8i32_z12345z7:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorps %xmm2, %xmm2
; SSSE3-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSSE3-NEXT:    xorps %xmm2, %xmm2
; SSSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[3,0]
; SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0,2]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v8i32_z12345z7:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm2, %xmm2
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE41-NEXT:    blendps {{.*#+}} xmm1 = xmm1[0,1],xmm2[2],xmm1[3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v8i32_z12345z7:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5],ymm1[6],ymm0[7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i32> %a, i32 0, i32 0
  %2 = insertelement <8 x i32> %1, i32 0, i32 6
  ret <8 x i32> %2
}

define <8 x i16> @insert_v8i16_z12345z7(<8 x i16> %a) {
; SSE2-LABEL: insert_v8i16_z12345z7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    pinsrw $0, %eax, %xmm0
; SSE2-NEXT:    pinsrw $6, %eax, %xmm0
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v8i16_z12345z7:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorl %eax, %eax
; SSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v8i16_z12345z7:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorl %eax, %eax
; SSSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v8i16_z12345z7:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pxor %xmm1, %xmm1
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3,4,5],xmm1[6],xmm0[7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v8i16_z12345z7:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3,4,5],xmm1[6],xmm0[7]
; AVX-NEXT:    retq
  %1 = insertelement <8 x i16> %a, i16 0, i32 0
  %2 = insertelement <8 x i16> %1, i16 0, i32 6
  ret <8 x i16> %2
}

define <16 x i16> @insert_v16i16_z12345z789ABCDEz(<16 x i16> %a) {
; SSE2-LABEL: insert_v16i16_z12345z789ABCDEz:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    pinsrw $0, %eax, %xmm0
; SSE2-NEXT:    pinsrw $6, %eax, %xmm0
; SSE2-NEXT:    pinsrw $7, %eax, %xmm1
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v16i16_z12345z789ABCDEz:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorl %eax, %eax
; SSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSE3-NEXT:    pinsrw $7, %eax, %xmm1
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v16i16_z12345z789ABCDEz:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorl %eax, %eax
; SSSE3-NEXT:    pinsrw $0, %eax, %xmm0
; SSSE3-NEXT:    pinsrw $6, %eax, %xmm0
; SSSE3-NEXT:    pinsrw $7, %eax, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v16i16_z12345z789ABCDEz:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pxor %xmm2, %xmm2
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3,4,5],xmm2[6],xmm0[7]
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3,4,5,6],xmm2[7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v16i16_z12345z789ABCDEz:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
  %1 = insertelement <16 x i16> %a, i16 0, i32 0
  %2 = insertelement <16 x i16> %1, i16 0, i32 6
  %3 = insertelement <16 x i16> %2, i16 0, i32 15
  ret <16 x i16> %3
}

define <16 x i8> @insert_v16i8_z123456789ABCDEz(<16 x i8> %a) {
; SSE2-LABEL: insert_v16i8_z123456789ABCDEz:
; SSE2:       # %bb.0:
; SSE2-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v16i8_z123456789ABCDEz:
; SSE3:       # %bb.0:
; SSE3-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v16i8_z123456789ABCDEz:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v16i8_z123456789ABCDEz:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorl %eax, %eax
; SSE41-NEXT:    pinsrb $0, %eax, %xmm0
; SSE41-NEXT:    pinsrb $15, %eax, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: insert_v16i8_z123456789ABCDEz:
; AVX1:       # %bb.0:
; AVX1-NEXT:    xorl %eax, %eax
; AVX1-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm0
; AVX1-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-SLOW-LABEL: insert_v16i8_z123456789ABCDEz:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    xorl %eax, %eax
; AVX2-SLOW-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm0
; AVX2-SLOW-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: insert_v16i8_z123456789ABCDEz:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-FAST-NEXT:    retq
  %1 = insertelement <16 x i8> %a, i8 0, i32 0
  %2 = insertelement <16 x i8> %1, i8 0, i32 15
  ret <16 x i8> %2
}

define <32 x i8> @insert_v32i8_z123456789ABCDEzGHIJKLMNOPQRSTzz(<32 x i8> %a) {
; SSE2-LABEL: insert_v32i8_z123456789ABCDEzGHIJKLMNOPQRSTzz:
; SSE2:       # %bb.0:
; SSE2-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE2-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE2-NEXT:    retq
;
; SSE3-LABEL: insert_v32i8_z123456789ABCDEzGHIJKLMNOPQRSTzz:
; SSE3:       # %bb.0:
; SSE3-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE3-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: insert_v32i8_z123456789ABCDEzGHIJKLMNOPQRSTzz:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSSE3-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: insert_v32i8_z123456789ABCDEzGHIJKLMNOPQRSTzz:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorl %eax, %eax
; SSE41-NEXT:    pinsrb $0, %eax, %xmm0
; SSE41-NEXT:    pinsrb $15, %eax, %xmm0
; SSE41-NEXT:    pxor %xmm2, %xmm2
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3,4,5,6],xmm2[7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: insert_v32i8_z123456789ABCDEzGHIJKLMNOPQRSTzz:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
  %1 = insertelement <32 x i8> %a, i8 0, i32 0
  %2 = insertelement <32 x i8> %1, i8 0, i32 15
  %3 = insertelement <32 x i8> %2, i8 0, i32 30
  %4 = insertelement <32 x i8> %3, i8 0, i32 31
  ret <32 x i8> %4
}

define <4 x i32> @PR41512(i32 %x, i32 %y) {
; SSE-LABEL: PR41512:
; SSE:       # %bb.0:
; SSE-NEXT:    movd %edi, %xmm0
; SSE-NEXT:    movd %esi, %xmm1
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-NEXT:    retq
;
; AVX-LABEL: PR41512:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %edi, %xmm0
; AVX-NEXT:    vmovd %esi, %xmm1
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    retq
  %ins1 = insertelement <4 x i32> <i32 undef, i32 0, i32 undef, i32 undef>, i32 %x, i32 0
  %ins2 = insertelement <4 x i32> <i32 undef, i32 0, i32 undef, i32 undef>, i32 %y, i32 0
  %r = shufflevector <4 x i32> %ins1, <4 x i32> %ins2, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x i32> %r
}

define <4 x i64> @PR41512_v4i64(i64 %x, i64 %y) {
; SSE-LABEL: PR41512_v4i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %xmm0
; SSE-NEXT:    movq %rsi, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: PR41512_v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovq %rdi, %xmm0
; AVX1-NEXT:    vmovq %rsi, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: PR41512_v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm0
; AVX2-NEXT:    vmovq %rsi, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %ins1 = insertelement <4 x i64> <i64 undef, i64 0, i64 undef, i64 undef>, i64 %x, i32 0
  %ins2 = insertelement <4 x i64> <i64 undef, i64 0, i64 undef, i64 undef>, i64 %y, i32 0
  %r = shufflevector <4 x i64> %ins1, <4 x i64> %ins2, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x i64> %r
}

define <8 x float> @PR41512_v8f32(float %x, float %y) {
; SSE2-LABEL: PR41512_v8f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorps %xmm2, %xmm2
; SSE2-NEXT:    xorps %xmm3, %xmm3
; SSE2-NEXT:    movss {{.*#+}} xmm3 = xmm0[0],xmm3[1,2,3]
; SSE2-NEXT:    movss {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; SSE2-NEXT:    movaps %xmm3, %xmm0
; SSE2-NEXT:    movaps %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSE3-LABEL: PR41512_v8f32:
; SSE3:       # %bb.0:
; SSE3-NEXT:    xorps %xmm2, %xmm2
; SSE3-NEXT:    xorps %xmm3, %xmm3
; SSE3-NEXT:    movss {{.*#+}} xmm3 = xmm0[0],xmm3[1,2,3]
; SSE3-NEXT:    movss {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; SSE3-NEXT:    movaps %xmm3, %xmm0
; SSE3-NEXT:    movaps %xmm2, %xmm1
; SSE3-NEXT:    retq
;
; SSSE3-LABEL: PR41512_v8f32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    xorps %xmm2, %xmm2
; SSSE3-NEXT:    xorps %xmm3, %xmm3
; SSSE3-NEXT:    movss {{.*#+}} xmm3 = xmm0[0],xmm3[1,2,3]
; SSSE3-NEXT:    movss {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; SSSE3-NEXT:    movaps %xmm3, %xmm0
; SSSE3-NEXT:    movaps %xmm2, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: PR41512_v8f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    xorps %xmm2, %xmm2
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; SSE41-NEXT:    blendps {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: PR41512_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; AVX-NEXT:    vblendps {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3]
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %ins1 = insertelement <8 x float> zeroinitializer, float %x, i32 0
  %ins2 = insertelement <8 x float> zeroinitializer, float %y, i32 0
  %r = shufflevector <8 x float> %ins1, <8 x float> %ins2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11>
  ret <8 x float> %r
}

define <4 x i32> @PR41512_loads(ptr %p1, ptr %p2) {
; SSE-LABEL: PR41512_loads:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-NEXT:    retq
;
; AVX-LABEL: PR41512_loads:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    retq
  %x = load i32, ptr %p1
  %y = load i32, ptr %p2
  %ins1 = insertelement <4 x i32> <i32 undef, i32 0, i32 undef, i32 undef>, i32 %x, i32 0
  %ins2 = insertelement <4 x i32> <i32 undef, i32 0, i32 undef, i32 undef>, i32 %y, i32 0
  %r = shufflevector <4 x i32> %ins1, <4 x i32> %ins2, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x i32> %r
}
