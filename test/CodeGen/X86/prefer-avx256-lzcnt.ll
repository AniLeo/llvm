; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+avx512cd,+prefer-256-bit | FileCheck %s --check-prefix=CHECK --check-prefix=AVX256
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+avx512cd,-prefer-256-bit | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512 --check-prefix=AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512cd,+prefer-256-bit | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512cd,-prefer-256-bit | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512 --check-prefix=AVX512F

define <8 x i16> @testv8i16(<8 x i16> %in) {
; AVX256-LABEL: testv8i16:
; AVX256:       # %bb.0:
; AVX256-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX256-NEXT:    vplzcntd %ymm0, %ymm0
; AVX256-NEXT:    vpmovdw %ymm0, %xmm0
; AVX256-NEXT:    vpsubw {{.*}}(%rip), %xmm0, %xmm0
; AVX256-NEXT:    vzeroupper
; AVX256-NEXT:    retq
;
; AVX512VL-LABEL: testv8i16:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX512VL-NEXT:    vplzcntd %ymm0, %ymm0
; AVX512VL-NEXT:    vpmovdw %ymm0, %xmm0
; AVX512VL-NEXT:    vpsubw {{.*}}(%rip), %xmm0, %xmm0
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512F-LABEL: testv8i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX512F-NEXT:    vplzcntd %zmm0, %zmm0
; AVX512F-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512F-NEXT:    vpsubw {{.*}}(%rip), %xmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
  %out = call <8 x i16> @llvm.ctlz.v8i16(<8 x i16> %in, i1 false)
  ret <8 x i16> %out
}

define <16 x i8> @testv16i8(<16 x i8> %in) {
; AVX256-LABEL: testv16i8:
; AVX256:       # %bb.0:
; AVX256-NEXT:    vmovdqa {{.*#+}} xmm1 = [4,3,2,2,1,1,1,1,0,0,0,0,0,0,0,0]
; AVX256-NEXT:    vpshufb %xmm0, %xmm1, %xmm2
; AVX256-NEXT:    vpsrlw $4, %xmm0, %xmm0
; AVX256-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX256-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX256-NEXT:    vpcmpeqb %xmm3, %xmm0, %xmm3
; AVX256-NEXT:    vpand %xmm3, %xmm2, %xmm2
; AVX256-NEXT:    vpshufb %xmm0, %xmm1, %xmm0
; AVX256-NEXT:    vpaddb %xmm0, %xmm2, %xmm0
; AVX256-NEXT:    retq
;
; AVX512-LABEL: testv16i8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovzxbd {{.*#+}} zmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero,xmm0[8],zero,zero,zero,xmm0[9],zero,zero,zero,xmm0[10],zero,zero,zero,xmm0[11],zero,zero,zero,xmm0[12],zero,zero,zero,xmm0[13],zero,zero,zero,xmm0[14],zero,zero,zero,xmm0[15],zero,zero,zero
; AVX512-NEXT:    vplzcntd %zmm0, %zmm0
; AVX512-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512-NEXT:    vpsubb {{.*}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %out = call <16 x i8> @llvm.ctlz.v16i8(<16 x i8> %in, i1 false)
  ret <16 x i8> %out
}

define <16 x i16> @testv16i16(<16 x i16> %in) {
; AVX256-LABEL: testv16i16:
; AVX256:       # %bb.0:
; AVX256-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX256-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX256-NEXT:    vplzcntd %ymm1, %ymm1
; AVX256-NEXT:    vpmovdw %ymm1, %xmm1
; AVX256-NEXT:    vmovdqa {{.*#+}} xmm2 = [16,16,16,16,16,16,16,16]
; AVX256-NEXT:    vpsubw %xmm2, %xmm1, %xmm1
; AVX256-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX256-NEXT:    vplzcntd %ymm0, %ymm0
; AVX256-NEXT:    vpmovdw %ymm0, %xmm0
; AVX256-NEXT:    vpsubw %xmm2, %xmm0, %xmm0
; AVX256-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX256-NEXT:    retq
;
; AVX512-LABEL: testv16i16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512-NEXT:    vplzcntd %zmm0, %zmm0
; AVX512-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512-NEXT:    vpsubw {{.*}}(%rip), %ymm0, %ymm0
; AVX512-NEXT:    retq
  %out = call <16 x i16> @llvm.ctlz.v16i16(<16 x i16> %in, i1 false)
  ret <16 x i16> %out
}

define <32 x i8> @testv32i8(<32 x i8> %in) {
; AVX256-LABEL: testv32i8:
; AVX256:       # %bb.0:
; AVX256-NEXT:    vmovdqa {{.*#+}} ymm1 = [4,3,2,2,1,1,1,1,0,0,0,0,0,0,0,0,4,3,2,2,1,1,1,1,0,0,0,0,0,0,0,0]
; AVX256-NEXT:    vpshufb %ymm0, %ymm1, %ymm2
; AVX256-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX256-NEXT:    vpand {{.*}}(%rip), %ymm0, %ymm0
; AVX256-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX256-NEXT:    vpcmpeqb %ymm3, %ymm0, %ymm3
; AVX256-NEXT:    vpand %ymm3, %ymm2, %ymm2
; AVX256-NEXT:    vpshufb %ymm0, %ymm1, %ymm0
; AVX256-NEXT:    vpaddb %ymm0, %ymm2, %ymm0
; AVX256-NEXT:    retq
;
; AVX512-LABEL: testv32i8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpmovzxbd {{.*#+}} zmm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero,xmm1[8],zero,zero,zero,xmm1[9],zero,zero,zero,xmm1[10],zero,zero,zero,xmm1[11],zero,zero,zero,xmm1[12],zero,zero,zero,xmm1[13],zero,zero,zero,xmm1[14],zero,zero,zero,xmm1[15],zero,zero,zero
; AVX512-NEXT:    vplzcntd %zmm1, %zmm1
; AVX512-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm2 = [24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24]
; AVX512-NEXT:    vpsubb %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vpmovzxbd {{.*#+}} zmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero,xmm0[8],zero,zero,zero,xmm0[9],zero,zero,zero,xmm0[10],zero,zero,zero,xmm0[11],zero,zero,zero,xmm0[12],zero,zero,zero,xmm0[13],zero,zero,zero,xmm0[14],zero,zero,zero,xmm0[15],zero,zero,zero
; AVX512-NEXT:    vplzcntd %zmm0, %zmm0
; AVX512-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512-NEXT:    vpsubb %xmm2, %xmm0, %xmm0
; AVX512-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %out = call <32 x i8> @llvm.ctlz.v32i8(<32 x i8> %in, i1 false)
  ret <32 x i8> %out
}

declare <8 x i16> @llvm.ctlz.v8i16(<8 x i16>, i1)
declare <16 x i8> @llvm.ctlz.v16i8(<16 x i8>, i1)
declare <16 x i16> @llvm.ctlz.v16i16(<16 x i16>, i1)
declare <32 x i8> @llvm.ctlz.v32i8(<32 x i8>, i1)
