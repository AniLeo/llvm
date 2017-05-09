; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

; Lower common integer comparisons such as 'isPositive' efficiently:
; https://llvm.org/bugs/show_bug.cgi?id=26701

define <16 x i8> @test_pcmpgtb(<16 x i8> %x) {
; SSE-LABEL: test_pcmpgtb:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    pcmpgtb %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_pcmpgtb:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpgtb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %sign = ashr <16 x i8> %x, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %not = xor <16 x i8> %sign, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  ret <16 x i8> %not
}

define <8 x i16> @test_pcmpgtw(<8 x i16> %x) {
; SSE-LABEL: test_pcmpgtw:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    pcmpgtw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_pcmpgtw:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %sign = ashr <8 x i16> %x, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %not = xor <8 x i16> %sign, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  ret <8 x i16> %not
}

define <4 x i32> @test_pcmpgtd(<4 x i32> %x) {
; SSE-LABEL: test_pcmpgtd:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_pcmpgtd:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %sign = ashr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %not = xor <4 x i32> %sign, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %not
}

define <2 x i64> @test_pcmpgtq(<2 x i64> %x) {
; SSE2-LABEL: test_pcmpgtq:
; SSE2:       # BB#0:
; SSE2-NEXT:    psrad $31, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE42-LABEL: test_pcmpgtq:
; SSE42:       # BB#0:
; SSE42-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: test_pcmpgtq:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %sign = ashr <2 x i64> %x, <i64 63, i64 63>
  %not = xor <2 x i64> %sign, <i64 -1, i64 -1>
  ret <2 x i64> %not
}

define <1 x i128> @test_strange_type(<1 x i128> %x) {
; SSE2-LABEL: test_strange_type:
; SSE2:       # BB#0:
; SSE2-NEXT:    sarq $63, %rsi
; SSE2-NEXT:    movq %rsi, %xmm0
; SSE2-NEXT:    notq %rsi
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; SSE2-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE2-NEXT:    pxor %xmm0, %xmm1
; SSE2-NEXT:    movq %xmm1, %rax
; SSE2-NEXT:    movq %rsi, %rdx
; SSE2-NEXT:    retq
;
; SSE42-LABEL: test_strange_type:
; SSE42:       # BB#0:
; SSE42-NEXT:    sarq $63, %rsi
; SSE42-NEXT:    movq %rsi, %xmm0
; SSE42-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; SSE42-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE42-NEXT:    pxor %xmm0, %xmm1
; SSE42-NEXT:    movq %xmm1, %rax
; SSE42-NEXT:    pextrq $1, %xmm1, %rdx
; SSE42-NEXT:    retq
;
; AVX1-LABEL: test_strange_type:
; AVX1:       # BB#0:
; AVX1-NEXT:    sarq $63, %rsi
; AVX1-NEXT:    vmovq %rsi, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmovq %xmm0, %rax
; AVX1-NEXT:    vpextrq $1, %xmm0, %rdx
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_strange_type:
; AVX2:       # BB#0:
; AVX2-NEXT:    sarq $63, %rsi
; AVX2-NEXT:    vmovq %rsi, %xmm0
; AVX2-NEXT:    vpbroadcastq %xmm0, %xmm0
; AVX2-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovq %xmm0, %rax
; AVX2-NEXT:    vpextrq $1, %xmm0, %rdx
; AVX2-NEXT:    retq
  %sign = ashr <1 x i128> %x, <i128 127>
  %not = xor <1 x i128> %sign, <i128 -1>
  ret <1 x i128> %not
}

define <32 x i8> @test_pcmpgtb_256(<32 x i8> %x) {
; SSE-LABEL: test_pcmpgtb_256:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE-NEXT:    pcmpgtb %xmm2, %xmm0
; SSE-NEXT:    pcmpgtb %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_pcmpgtb_256:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm1, %ymm1
; AVX1-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_pcmpgtb_256:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %sign = ashr <32 x i8> %x, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %not = xor <32 x i8> %sign, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  ret <32 x i8> %not
}

define <16 x i16> @test_pcmpgtw_256(<16 x i16> %x) {
; SSE-LABEL: test_pcmpgtw_256:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE-NEXT:    pcmpgtw %xmm2, %xmm0
; SSE-NEXT:    pcmpgtw %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_pcmpgtw_256:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpsraw $15, %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsraw $15, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm1, %ymm1
; AVX1-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_pcmpgtw_256:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %sign = ashr <16 x i16> %x, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %not = xor <16 x i16> %sign, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  ret <16 x i16> %not
}

define <8 x i32> @test_pcmpgtd_256(<8 x i32> %x) {
; SSE-LABEL: test_pcmpgtd_256:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE-NEXT:    pcmpgtd %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_pcmpgtd_256:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm1, %ymm1
; AVX1-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_pcmpgtd_256:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %sign = ashr <8 x i32> %x, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  %not = xor <8 x i32> %sign, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  ret <8 x i32> %not
}

define <4 x i64> @test_pcmpgtq_256(<4 x i64> %x) {
; SSE2-LABEL: test_pcmpgtq_256:
; SSE2:       # BB#0:
; SSE2-NEXT:    psrad $31, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    psrad $31, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    pxor %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSE42-LABEL: test_pcmpgtq_256:
; SSE42:       # BB#0:
; SSE42-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm0
; SSE42-NEXT:    pcmpgtq %xmm2, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: test_pcmpgtq_256:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtq %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm1, %ymm1
; AVX1-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_pcmpgtq_256:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %sign = ashr <4 x i64> %x, <i64 63, i64 63, i64 63, i64 63>
  %not = xor <4 x i64> %sign, <i64 -1, i64 -1, i64 -1, i64 -1>
  ret <4 x i64> %not
}

define <16 x i8> @cmpeq_zext_v16i8(<16 x i8> %a, <16 x i8> %b) {
; SSE-LABEL: cmpeq_zext_v16i8:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqb %xmm1, %xmm0
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmpeq_zext_v16i8:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %cmp = icmp eq <16 x i8> %a, %b
  %zext = zext <16 x i1> %cmp to <16 x i8>
  ret <16 x i8> %zext
}

define <16 x i16> @cmpeq_zext_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: cmpeq_zext_v16i16:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqw %xmm2, %xmm0
; SSE-NEXT:    psrlw $15, %xmm0
; SSE-NEXT:    pcmpeqw %xmm3, %xmm1
; SSE-NEXT:    psrlw $15, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: cmpeq_zext_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpeqw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: cmpeq_zext_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpeqw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw $15, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cmp = icmp eq <16 x i16> %a, %b
  %zext = zext <16 x i1> %cmp to <16 x i16>
  ret <16 x i16> %zext
}

define <4 x i32> @cmpeq_zext_v4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: cmpeq_zext_v4i32:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    psrld $31, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmpeq_zext_v4i32:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrld $31, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cmp = icmp eq <4 x i32> %a, %b
  %zext = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %zext
}

define <4 x i64> @cmpeq_zext_v4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-LABEL: cmpeq_zext_v4i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    pcmpeqd %xmm2, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,0,3,2]
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [1,1]
; SSE2-NEXT:    pand %xmm4, %xmm2
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pcmpeqd %xmm3, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,0,3,2]
; SSE2-NEXT:    pand %xmm4, %xmm2
; SSE2-NEXT:    pand %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSE42-LABEL: cmpeq_zext_v4i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    pcmpeqq %xmm2, %xmm0
; SSE42-NEXT:    psrlq $63, %xmm0
; SSE42-NEXT:    pcmpeqq %xmm3, %xmm1
; SSE42-NEXT:    psrlq $63, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: cmpeq_zext_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpeqq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpeqq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: cmpeq_zext_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpeqq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlq $63, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cmp = icmp eq <4 x i64> %a, %b
  %zext = zext <4 x i1> %cmp to <4 x i64>
  ret <4 x i64> %zext
}

define <32 x i8> @cmpgt_zext_v32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE-LABEL: cmpgt_zext_v32i8:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpgtb %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pcmpgtb %xmm3, %xmm1
; SSE-NEXT:    pand %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: cmpgt_zext_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpgtb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: cmpgt_zext_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpgtb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpand {{.*}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cmp = icmp sgt <32 x i8> %a, %b
  %zext = zext <32 x i1> %cmp to <32 x i8>
  ret <32 x i8> %zext
}

define <8 x i16> @cmpgt_zext_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: cmpgt_zext_v8i16:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpgtw %xmm1, %xmm0
; SSE-NEXT:    psrlw $15, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmpgt_zext_v8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrlw $15, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cmp = icmp sgt <8 x i16> %a, %b
  %zext = zext <8 x i1> %cmp to <8 x i16>
  ret <8 x i16> %zext
}

define <8 x i32> @cmpgt_zext_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: cmpgt_zext_v8i32:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE-NEXT:    psrld $31, %xmm0
; SSE-NEXT:    pcmpgtd %xmm3, %xmm1
; SSE-NEXT:    psrld $31, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: cmpgt_zext_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: cmpgt_zext_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpgtd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrld $31, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cmp = icmp sgt <8 x i32> %a, %b
  %zext = zext <8 x i1> %cmp to <8 x i32>
  ret <8 x i32> %zext
}

define <2 x i64> @cmpgt_zext_v2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: cmpgt_zext_v2i64:
; SSE2:       # BB#0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,0,2147483648,0]
; SSE2-NEXT:    pxor %xmm2, %xmm1
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm2[0,0,2,2]
; SSE2-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE2-NEXT:    pand %xmm3, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[1,1,3,3]
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    retq
;
; SSE42-LABEL: cmpgt_zext_v2i64:
; SSE42:       # BB#0:
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm0
; SSE42-NEXT:    psrlq $63, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: cmpgt_zext_v2i64:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrlq $63, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cmp = icmp sgt <2 x i64> %a, %b
  %zext = zext <2 x i1> %cmp to <2 x i64>
  ret <2 x i64> %zext
}
