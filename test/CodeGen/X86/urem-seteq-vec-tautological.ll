; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+sse2 < %s | FileCheck %s --check-prefixes=CHECK-SSE,CHECK-SSE2
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+sse4.1 < %s | FileCheck %s --check-prefixes=CHECK-SSE,CHECK-SSE41
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx < %s | FileCheck %s --check-prefixes=CHECK-AVX,CHECK-AVX1
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 < %s | FileCheck %s --check-prefixes=CHECK-AVX,CHECK-AVX2
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+avx512vl < %s | FileCheck %s --check-prefixes=CHECK-AVX,CHECK-AVX512VL

define <4 x i1> @t0_all_tautological(<4 x i32> %X) nounwind {
; CHECK-SSE-LABEL: t0_all_tautological:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-SSE-NEXT:    pcmpeqd {{.*}}(%rip), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: t0_all_tautological:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX-NEXT:    vpcmpeqd {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
  %urem = urem <4 x i32> %X, <i32 1, i32 1, i32 2, i32 2>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i1> %cmp
}

define <4 x i1> @t1_all_odd_eq(<4 x i32> %X) nounwind {
; CHECK-SSE2-LABEL: t1_all_odd_eq:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm0
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; CHECK-SSE2-NEXT:    pxor {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    pcmpgtd {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    pandn {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: t1_all_odd_eq:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm0
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [1431655765,4294967295,4294967295,4294967295]
; CHECK-SSE41-NEXT:    pminud %xmm0, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: t1_all_odd_eq:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: t1_all_odd_eq:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-AVX2-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: t1_all_odd_eq:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i32> %X, <i32 3, i32 1, i32 1, i32 9>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 42, i32 0, i32 42>
  ret <4 x i1> %cmp
}

define <4 x i1> @t1_all_odd_ne(<4 x i32> %X) nounwind {
; CHECK-SSE2-LABEL: t1_all_odd_ne:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm0
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; CHECK-SSE2-NEXT:    pxor {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    pcmpgtd {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-SSE2-NEXT:    pcmpeqd %xmm1, %xmm1
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: t1_all_odd_ne:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm0
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [1431655765,4294967295,4294967295,4294967295]
; CHECK-SSE41-NEXT:    pminud %xmm0, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm0
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: t1_all_odd_ne:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: t1_all_odd_ne:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-AVX2-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: t1_all_odd_ne:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpternlogq $15, %xmm0, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i32> %X, <i32 3, i32 1, i32 1, i32 9>
  %cmp = icmp ne <4 x i32> %urem, <i32 0, i32 42, i32 0, i32 42>
  ret <4 x i1> %cmp
}

define <8 x i1> @t2_narrow(<8 x i16> %X) nounwind {
; CHECK-SSE2-LABEL: t2_narrow:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    pmullw {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    psubusw {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE2-NEXT:    pcmpeqw %xmm1, %xmm0
; CHECK-SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: t2_narrow:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pmullw {{.*}}(%rip), %xmm0
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [21845,65535,65535,65535,21845,65535,65535,65535]
; CHECK-SSE41-NEXT:    pminuw %xmm0, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqw %xmm1, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: t2_narrow:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpminuw {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: t2_narrow:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpminuw {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: t2_narrow:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpminuw {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <8 x i16> %X, <i16 3, i16 1, i16 1, i16 9, i16 3, i16 1, i16 1, i16 9>
  %cmp = icmp eq <8 x i16> %urem, <i16 0, i16 0, i16 42, i16 42, i16 0, i16 0, i16 42, i16 42>
  ret <8 x i1> %cmp
}

define <2 x i1> @t3_wide(<2 x i64> %X) nounwind {
; CHECK-SSE-LABEL: t3_wide:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    movdqa {{.*#+}} xmm1 = [12297829382473034411,12297829382473034411]
; CHECK-SSE-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE-NEXT:    movdqa %xmm0, %xmm3
; CHECK-SSE-NEXT:    psrlq $32, %xmm3
; CHECK-SSE-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE-NEXT:    pmuludq {{.*}}(%rip), %xmm0
; CHECK-SSE-NEXT:    paddq %xmm3, %xmm0
; CHECK-SSE-NEXT:    psllq $32, %xmm0
; CHECK-SSE-NEXT:    paddq %xmm2, %xmm0
; CHECK-SSE-NEXT:    pxor {{.*}}(%rip), %xmm0
; CHECK-SSE-NEXT:    movdqa {{.*#+}} xmm1 = [15372286730238776661,9223372034707292159]
; CHECK-SSE-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE-NEXT:    pcmpgtd %xmm1, %xmm2
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm2[0,0,2,2]
; CHECK-SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; CHECK-SSE-NEXT:    pand %xmm3, %xmm0
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[1,1,3,3]
; CHECK-SSE-NEXT:    por %xmm0, %xmm1
; CHECK-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-SSE-NEXT:    pxor %xmm1, %xmm0
; CHECK-SSE-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: t3_wide:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [12297829382473034411,12297829382473034411]
; CHECK-AVX1-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; CHECK-AVX1-NEXT:    vpsrlq $32, %xmm0, %xmm3
; CHECK-AVX1-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; CHECK-AVX1-NEXT:    vpmuludq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsllq $32, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; CHECK-AVX1-NEXT:    vpxor {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vmovq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: t3_wide:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vmovdqa {{.*#+}} xmm1 = [12297829382473034411,12297829382473034411]
; CHECK-AVX2-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; CHECK-AVX2-NEXT:    vpsrlq $32, %xmm0, %xmm3
; CHECK-AVX2-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; CHECK-AVX2-NEXT:    vpmuludq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsllq $32, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; CHECK-AVX2-NEXT:    vpxor {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpcmpgtq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vmovq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: t3_wide:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm1 = [12297829382473034411,12297829382473034411]
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; CHECK-AVX512VL-NEXT:    vpsrlq $32, %xmm0, %xmm3
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; CHECK-AVX512VL-NEXT:    vpmuludq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsllq $32, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; CHECK-AVX512VL-NEXT:    vpminuq {{.*}}(%rip), %xmm0, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqq %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vmovq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <2 x i64> %X, <i64 3, i64 1>
  %cmp = icmp eq <2 x i64> %urem, <i64 0, i64 42>
  ret <2 x i1> %cmp
}
