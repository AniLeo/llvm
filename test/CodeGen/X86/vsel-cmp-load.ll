; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx                       | FileCheck %s --check-prefixes=ALL,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2                      | FileCheck %s --check-prefixes=ALL,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512bw,avx512vl,avx512f | FileCheck %s --check-prefixes=ALL,AVX512

; PR37427 - https://bugs.llvm.org/show_bug.cgi?id=37427

define <8 x i32> @eq_zero(<8 x i8>* %p, <8 x i32> %x, <8 x i32> %y) {
; AVX1-LABEL: eq_zero:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: eq_zero:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovzxbd {{.*#+}} ymm2 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero,mem[4],zero,zero,zero,mem[5],zero,zero,zero,mem[6],zero,zero,zero,mem[7],zero,zero,zero
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpeqd %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: eq_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovzxbw {{.*#+}} xmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512-NEXT:    vptestnmw %xmm2, %xmm2, %k1
; AVX512-NEXT:    vpblendmd %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <8 x i8>, <8 x i8>* %p
  %cmp = icmp eq <8 x i8> %load, zeroinitializer
  %sel = select <8 x i1> %cmp, <8 x i32> %x, <8 x i32> %y
  ret <8 x i32> %sel
}

define <4 x i64> @ne_zero(<4 x i16>* %p, <4 x i64> %x, <4 x i64> %y) {
; AVX1-LABEL: ne_zero:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovzxwd {{.*#+}} xmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ne_zero:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovzxwq {{.*#+}} ymm2 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpeqq %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: ne_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovzxwd {{.*#+}} xmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
; AVX512-NEXT:    vptestmd %xmm2, %xmm2, %k1
; AVX512-NEXT:    vpblendmq %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <4 x i16>, <4 x i16>* %p
  %cmp = icmp ne <4 x i16> %load, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i64> %x, <4 x i64> %y
  ret <4 x i64> %sel
}

define <16 x i16> @sgt_zero(<16 x i8>* %p, <16 x i16> %x, <16 x i16> %y) {
; AVX1-LABEL: sgt_zero:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa (%rdi), %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpgtb %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmovsxbw %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxbw %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vandnps %ymm1, %ymm2, %ymm1
; AVX1-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: sgt_zero:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxbw (%rdi), %ymm2
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpgtw %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: sgt_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512-NEXT:    vpcmpltb (%rdi), %xmm2, %k1
; AVX512-NEXT:    vpblendmw %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <16 x i8>, <16 x i8>* %p
  %cmp = icmp sgt <16 x i8> %load, zeroinitializer
  %sel = select <16 x i1> %cmp, <16 x i16> %x, <16 x i16> %y
  ret <16 x i16> %sel
}

define <8 x i32> @slt_zero(<8 x i8>* %p, <8 x i32> %x, <8 x i32> %y) {
; AVX1-LABEL: slt_zero:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovsxbw (%rdi), %xmm2
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: slt_zero:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxbd (%rdi), %ymm2
; AVX2-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: slt_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxbw (%rdi), %xmm2
; AVX512-NEXT:    vpmovw2m %xmm2, %k1
; AVX512-NEXT:    vpblendmd %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <8 x i8>, <8 x i8>* %p
  %cmp = icmp slt <8 x i8> %load, zeroinitializer
  %sel = select <8 x i1> %cmp, <8 x i32> %x, <8 x i32> %y
  ret <8 x i32> %sel
}

define <4 x double> @eq_zero_fp_select(<4 x i8>* %p, <4 x double> %x, <4 x double> %y) {
; AVX1-LABEL: eq_zero_fp_select:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovzxbd {{.*#+}} xmm2 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: eq_zero_fp_select:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovzxbq {{.*#+}} ymm2 = mem[0],zero,zero,zero,zero,zero,zero,zero,mem[1],zero,zero,zero,zero,zero,zero,zero,mem[2],zero,zero,zero,zero,zero,zero,zero,mem[3],zero,zero,zero,zero,zero,zero,zero
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpeqq %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: eq_zero_fp_select:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovzxbd {{.*#+}} xmm2 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; AVX512-NEXT:    vptestnmd %xmm2, %xmm2, %k1
; AVX512-NEXT:    vblendmpd %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <4 x i8>, <4 x i8>* %p
  %cmp = icmp eq <4 x i8> %load, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x double> %x, <4 x double> %y
  ret <4 x double> %sel
}

define <8 x float> @ne_zero_fp_select(<8 x i8>* %p, <8 x float> %x, <8 x float> %y) {
; AVX1-LABEL: ne_zero_fp_select:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpxor %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ne_zero_fp_select:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovzxbd {{.*#+}} ymm2 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero,mem[4],zero,zero,zero,mem[5],zero,zero,zero,mem[6],zero,zero,zero,mem[7],zero,zero,zero
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpeqd %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvps %ymm2, %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: ne_zero_fp_select:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovzxbw {{.*#+}} xmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512-NEXT:    vptestmw %xmm2, %xmm2, %k1
; AVX512-NEXT:    vblendmps %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <8 x i8>, <8 x i8>* %p
  %cmp = icmp ne <8 x i8> %load, zeroinitializer
  %sel = select <8 x i1> %cmp, <8 x float> %x, <8 x float> %y
  ret <8 x float> %sel
}

define <4 x double> @sgt_zero_fp_select(<4 x i8>* %p, <4 x double> %x, <4 x double> %y) {
; AVX1-LABEL: sgt_zero_fp_select:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovsxbd (%rdi), %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: sgt_zero_fp_select:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxbq (%rdi), %ymm2
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpgtq %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: sgt_zero_fp_select:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxbd (%rdi), %xmm2
; AVX512-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512-NEXT:    vpcmpgtd %xmm3, %xmm2, %k1
; AVX512-NEXT:    vblendmpd %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <4 x i8>, <4 x i8>* %p
  %cmp = icmp sgt <4 x i8> %load, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x double> %x, <4 x double> %y
  ret <4 x double> %sel
}

define <8 x float> @slt_zero_fp_select(<8 x i16>* %p, <8 x float> %x, <8 x float> %y) {
; AVX1-LABEL: slt_zero_fp_select:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovsxwd 8(%rdi), %xmm2
; AVX1-NEXT:    vpmovsxwd (%rdi), %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: slt_zero_fp_select:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxwd (%rdi), %ymm2
; AVX2-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: slt_zero_fp_select:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512-NEXT:    vpcmpgtw (%rdi), %xmm2, %k1
; AVX512-NEXT:    vblendmps %ymm0, %ymm1, %ymm0 {%k1}
; AVX512-NEXT:    retq
  %load = load <8 x i16>, <8 x i16>* %p
  %cmp = icmp slt <8 x i16> %load, zeroinitializer
  %sel = select <8 x i1> %cmp, <8 x float> %x, <8 x float> %y
  ret <8 x float> %sel
}

