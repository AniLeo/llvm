; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+SSE2 | FileCheck %s --check-prefixes=SSE2-SSSE3,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+SSSE3 | FileCheck %s --check-prefixes=SSE2-SSSE3,SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX12,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX12,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefixes=AVX512 --check-prefixes=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl,+avx512bw | FileCheck %s --check-prefixes=AVX512 --check-prefixes=AVX512BW

define i16 @v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE2-SSSE3-LABEL: v16i16:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packsswb %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pmovmskb %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpgtw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %eax
; AVX2-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v16i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtw %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <16 x i16> %a, %b
  %res = bitcast <16 x i1> %x to i16
  ret i16 %res
}

define i8 @v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE2-SSSE3-LABEL: v8i32:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    packsswb %xmm0, %xmm0
; SSE2-SSSE3-NEXT:    pmovmskb %xmm0, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtd %ymm1, %ymm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <8 x i32> %a, %b
  %res = bitcast <8 x i1> %x to i8
  ret i8 %res
}

define i8 @v8f32(<8 x float> %a, <8 x float> %b) {
; SSE2-SSSE3-LABEL: v8f32:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    cmpltps %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    cmpltps %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packssdw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    packsswb %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    pmovmskb %xmm2, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v8f32:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltps %ymm0, %ymm1, %ymm0
; AVX12-NEXT:    vmovmskps %ymm0, %eax
; AVX12-NEXT:    # kill: def $al killed $al killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v8f32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltps %ymm0, %ymm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8f32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltps %ymm0, %ymm1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = fcmp ogt <8 x float> %a, %b
  %res = bitcast <8 x i1> %x to i8
  ret i8 %res
}

define i32 @v32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE2-SSSE3-LABEL: v32i8:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pmovmskb %xmm0, %ecx
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pmovmskb %xmm1, %eax
; SSE2-SSSE3-NEXT:    shll $16, %eax
; SSE2-SSSE3-NEXT:    orl %ecx, %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vpmovmskb %xmm2, %ecx
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    shll $16, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpmovmskb %ymm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v32i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtb %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k0
; AVX512F-NEXT:    kmovw %k0, %ecx
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    shll $16, %eax
; AVX512F-NEXT:    orl %ecx, %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v32i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtb %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <32 x i8> %a, %b
  %res = bitcast <32 x i1> %x to i32
  ret i32 %res
}

define i4 @v4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-SSSE3-LABEL: v4i64:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,2147483648]
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    movdqa %xmm1, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm5
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm6, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm3 = xmm5[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSE2-SSSE3-NEXT:    pxor %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm2, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    packssdw %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    movmskps %xmm1, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskpd %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vmovmskpd %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v4i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtq %ymm1, %ymm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtq %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = icmp sgt <4 x i64> %a, %b
  %res = bitcast <4 x i1> %x to i4
  ret i4 %res
}

define i4 @v4f64(<4 x double> %a, <4 x double> %b) {
; SSE2-SSSE3-LABEL: v4f64:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    cmpltpd %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    cmpltpd %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packssdw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    movmskps %xmm2, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v4f64:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltpd %ymm0, %ymm1, %ymm0
; AVX12-NEXT:    vmovmskpd %ymm0, %eax
; AVX12-NEXT:    # kill: def $al killed $al killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v4f64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltpd %ymm0, %ymm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4f64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltpd %ymm0, %ymm1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x = fcmp ogt <4 x double> %a, %b
  %res = bitcast <4 x i1> %x to i4
  ret i4 %res
}

define void @bitcast_32i8_store(i32* %p, <32 x i8> %a0) {
; SSE2-SSSE3-LABEL: bitcast_32i8_store:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pxor %xmm3, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm2, %xmm2
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    movdqa %xmm3, -{{[0-9]+}}(%rsp)
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE2-SSSE3-NEXT:    andl $1, %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rcx,%rax,2), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rax,%rcx,4), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rax,%rcx,8), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $4, %ecx
; SSE2-SSSE3-NEXT:    orl %eax, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE2-SSSE3-NEXT:    andl $1, %eax
; SSE2-SSSE3-NEXT:    shll $5, %eax
; SSE2-SSSE3-NEXT:    orl %ecx, %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $6, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $7, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $8, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $9, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $10, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $11, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $12, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $13, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $14, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    shll $15, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    orl %eax, %edx
; SSE2-SSSE3-NEXT:    movw %dx, 2(%rdi)
; SSE2-SSSE3-NEXT:    movdqa %xmm2, -{{[0-9]+}}(%rsp)
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE2-SSSE3-NEXT:    andl $1, %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rcx,%rax,2), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rax,%rcx,4), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rax,%rcx,8), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $4, %ecx
; SSE2-SSSE3-NEXT:    orl %eax, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE2-SSSE3-NEXT:    andl $1, %eax
; SSE2-SSSE3-NEXT:    shll $5, %eax
; SSE2-SSSE3-NEXT:    orl %ecx, %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $6, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $7, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $8, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $9, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $10, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $11, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $12, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $13, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $14, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    shll $15, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    orl %eax, %edx
; SSE2-SSSE3-NEXT:    movw %dx, (%rdi)
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: bitcast_32i8_store:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vpextrb $1, %xmm0, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rcx,%rax,2), %eax
; AVX1-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,4), %eax
; AVX1-NEXT:    vpextrb $3, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,8), %eax
; AVX1-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $4, %ecx
; AVX1-NEXT:    orl %eax, %ecx
; AVX1-NEXT:    vpextrb $5, %xmm0, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    shll $5, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $6, %ecx
; AVX1-NEXT:    vpextrb $7, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $7, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $8, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $9, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $9, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $10, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $11, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $11, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $12, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $13, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $13, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $14, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $15, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $15, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $0, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $16, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $1, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $17, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $2, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $18, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $3, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $19, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $4, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $20, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $5, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $21, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $6, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $22, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $7, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $23, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $8, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $24, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $9, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $25, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $10, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $26, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $11, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $27, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $12, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $28, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $13, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $29, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $14, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $30, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $15, %xmm1, %edx
; AVX1-NEXT:    shll $31, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    orl %eax, %edx
; AVX1-NEXT:    movl %edx, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: bitcast_32i8_store:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtb %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vpextrb $1, %xmm0, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rcx,%rax,2), %eax
; AVX2-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,4), %eax
; AVX2-NEXT:    vpextrb $3, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,8), %eax
; AVX2-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $4, %ecx
; AVX2-NEXT:    orl %eax, %ecx
; AVX2-NEXT:    vpextrb $5, %xmm0, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    shll $5, %eax
; AVX2-NEXT:    orl %ecx, %eax
; AVX2-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $6, %ecx
; AVX2-NEXT:    vpextrb $7, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $7, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $8, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $9, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $9, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $10, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $11, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $11, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $12, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $13, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $13, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $14, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $15, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $15, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $16, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $1, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $17, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $2, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $18, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $3, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $19, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $20, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $5, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $21, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $22, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $7, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $23, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $24, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $9, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $25, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $10, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $26, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $11, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $27, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $28, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $13, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $29, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $14, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $30, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $15, %xmm0, %edx
; AVX2-NEXT:    shll $31, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    orl %eax, %edx
; AVX2-NEXT:    movl %edx, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: bitcast_32i8_store:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vpcmpgtb %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k0
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    kmovw %k1, 2(%rdi)
; AVX512F-NEXT:    kmovw %k0, (%rdi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: bitcast_32i8_store:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovb2m %ymm0, %k0
; AVX512BW-NEXT:    kmovd %k0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a1 = icmp slt <32 x i8> %a0, zeroinitializer
  %a2 = bitcast <32 x i1> %a1 to i32
  store i32 %a2, i32* %p
  ret void
}

define void @bitcast_16i16_store(i16* %p, <16 x i16> %a0) {
; SSE2-SSSE3-LABEL: bitcast_16i16_store:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pxor %xmm2, %xmm2
; SSE2-SSSE3-NEXT:    pxor %xmm3, %xmm3
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packsswb %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    movdqa %xmm2, -{{[0-9]+}}(%rsp)
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE2-SSSE3-NEXT:    andl $1, %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rcx,%rax,2), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rax,%rcx,4), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    leal (%rax,%rcx,8), %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $4, %ecx
; SSE2-SSSE3-NEXT:    orl %eax, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE2-SSSE3-NEXT:    andl $1, %eax
; SSE2-SSSE3-NEXT:    shll $5, %eax
; SSE2-SSSE3-NEXT:    orl %ecx, %eax
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $6, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $7, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $8, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $9, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $10, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $11, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $12, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    andl $1, %edx
; SSE2-SSSE3-NEXT:    shll $13, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE2-SSSE3-NEXT:    andl $1, %ecx
; SSE2-SSSE3-NEXT:    shll $14, %ecx
; SSE2-SSSE3-NEXT:    orl %edx, %ecx
; SSE2-SSSE3-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE2-SSSE3-NEXT:    shll $15, %edx
; SSE2-SSSE3-NEXT:    orl %ecx, %edx
; SSE2-SSSE3-NEXT:    orl %eax, %edx
; SSE2-SSSE3-NEXT:    movw %dx, (%rdi)
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: bitcast_16i16_store:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtw %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtw %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vpextrb $2, %xmm0, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rcx,%rax,2), %eax
; AVX1-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,4), %eax
; AVX1-NEXT:    vpextrb $6, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    leal (%rax,%rcx,8), %eax
; AVX1-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $4, %ecx
; AVX1-NEXT:    orl %eax, %ecx
; AVX1-NEXT:    vpextrb $10, %xmm0, %eax
; AVX1-NEXT:    andl $1, %eax
; AVX1-NEXT:    shll $5, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $6, %ecx
; AVX1-NEXT:    vpextrb $14, %xmm0, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $7, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $0, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $8, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $2, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $9, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $4, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $10, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $6, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $11, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $8, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $12, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $10, %xmm1, %edx
; AVX1-NEXT:    andl $1, %edx
; AVX1-NEXT:    shll $13, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    vpextrb $12, %xmm1, %ecx
; AVX1-NEXT:    andl $1, %ecx
; AVX1-NEXT:    shll $14, %ecx
; AVX1-NEXT:    orl %edx, %ecx
; AVX1-NEXT:    vpextrb $14, %xmm1, %edx
; AVX1-NEXT:    shll $15, %edx
; AVX1-NEXT:    orl %ecx, %edx
; AVX1-NEXT:    orl %eax, %edx
; AVX1-NEXT:    movw %dx, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: bitcast_16i16_store:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtw %ymm0, %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm0
; AVX2-NEXT:    vpextrb $2, %xmm1, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    vpextrb $0, %xmm1, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rcx,%rax,2), %eax
; AVX2-NEXT:    vpextrb $4, %xmm1, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,4), %eax
; AVX2-NEXT:    vpextrb $6, %xmm1, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    leal (%rax,%rcx,8), %eax
; AVX2-NEXT:    vpextrb $8, %xmm1, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $4, %ecx
; AVX2-NEXT:    orl %eax, %ecx
; AVX2-NEXT:    vpextrb $10, %xmm1, %eax
; AVX2-NEXT:    andl $1, %eax
; AVX2-NEXT:    shll $5, %eax
; AVX2-NEXT:    orl %ecx, %eax
; AVX2-NEXT:    vpextrb $12, %xmm1, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $6, %ecx
; AVX2-NEXT:    vpextrb $14, %xmm1, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $7, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $0, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $8, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $2, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $9, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $10, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $6, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $11, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $8, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $12, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $10, %xmm0, %edx
; AVX2-NEXT:    andl $1, %edx
; AVX2-NEXT:    shll $13, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    vpextrb $12, %xmm0, %ecx
; AVX2-NEXT:    andl $1, %ecx
; AVX2-NEXT:    shll $14, %ecx
; AVX2-NEXT:    orl %edx, %ecx
; AVX2-NEXT:    vpextrb $14, %xmm0, %edx
; AVX2-NEXT:    shll $15, %edx
; AVX2-NEXT:    orl %ecx, %edx
; AVX2-NEXT:    orl %eax, %edx
; AVX2-NEXT:    movw %dx, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: bitcast_16i16_store:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vpcmpgtw %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, (%rdi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: bitcast_16i16_store:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovw2m %ymm0, %k0
; AVX512BW-NEXT:    kmovw %k0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a1 = icmp slt <16 x i16> %a0, zeroinitializer
  %a2 = bitcast <16 x i1> %a1 to i16
  store i16 %a2, i16* %p
  ret void
}

define void @bitcast_8i32_store(i8* %p, <8 x i32> %a0) {
; SSE2-SSSE3-LABEL: bitcast_8i32_store:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pxor %xmm2, %xmm2
; SSE2-SSSE3-NEXT:    pxor %xmm3, %xmm3
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packssdw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    packsswb %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    pmovmskb %xmm2, %eax
; SSE2-SSSE3-NEXT:    movb %al, (%rdi)
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: bitcast_8i32_store:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vmovmskps %ymm0, %eax
; AVX12-NEXT:    movb %al, (%rdi)
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: bitcast_8i32_store:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vpcmpgtd %ymm0, %ymm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, (%rdi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: bitcast_8i32_store:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512BW-NEXT:    vpcmpgtd %ymm0, %ymm1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a1 = icmp slt <8 x i32> %a0, zeroinitializer
  %a2 = bitcast <8 x i1> %a1 to i8
  store i8 %a2, i8* %p
  ret void
}

define void @bitcast_4i64_store(i4* %p, <4 x i64> %a0) {
; SSE2-SSSE3-LABEL: bitcast_4i64_store:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,2147483648]
; SSE2-SSSE3-NEXT:    pxor %xmm2, %xmm1
; SSE2-SSSE3-NEXT:    movdqa %xmm2, %xmm3
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm3[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm2, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm2, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[0,0,2,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-SSSE3-NEXT:    pand %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm1
; SSE2-SSSE3-NEXT:    movdqa %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm3[0,2]
; SSE2-SSSE3-NEXT:    movd %xmm1, %eax
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,2],xmm3[0,2]
; SSE2-SSSE3-NEXT:    movd %xmm1, %ecx
; SSE2-SSSE3-NEXT:    andb $1, %cl
; SSE2-SSSE3-NEXT:    addb %cl, %cl
; SSE2-SSSE3-NEXT:    andb $1, %al
; SSE2-SSSE3-NEXT:    movd %xmm3, %edx
; SSE2-SSSE3-NEXT:    andb $1, %dl
; SSE2-SSSE3-NEXT:    shlb $2, %dl
; SSE2-SSSE3-NEXT:    orb %cl, %dl
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-SSSE3-NEXT:    movd %xmm0, %ecx
; SSE2-SSSE3-NEXT:    shlb $3, %cl
; SSE2-SSSE3-NEXT:    orb %dl, %cl
; SSE2-SSSE3-NEXT:    orb %al, %cl
; SSE2-SSSE3-NEXT:    andb $15, %cl
; SSE2-SSSE3-NEXT:    movb %cl, (%rdi)
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: bitcast_4i64_store:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtq %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    andb $1, %al
; AVX1-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX1-NEXT:    andb $1, %cl
; AVX1-NEXT:    addb %cl, %cl
; AVX1-NEXT:    vpextrd $2, %xmm0, %edx
; AVX1-NEXT:    andb $1, %dl
; AVX1-NEXT:    shlb $2, %dl
; AVX1-NEXT:    orb %cl, %dl
; AVX1-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX1-NEXT:    shlb $3, %cl
; AVX1-NEXT:    orb %dl, %cl
; AVX1-NEXT:    orb %al, %cl
; AVX1-NEXT:    andb $15, %cl
; AVX1-NEXT:    movb %cl, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: bitcast_4i64_store:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    andb $1, %al
; AVX2-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX2-NEXT:    andb $1, %cl
; AVX2-NEXT:    addb %cl, %cl
; AVX2-NEXT:    vpextrd $2, %xmm0, %edx
; AVX2-NEXT:    andb $1, %dl
; AVX2-NEXT:    shlb $2, %dl
; AVX2-NEXT:    orb %cl, %dl
; AVX2-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX2-NEXT:    shlb $3, %cl
; AVX2-NEXT:    orb %dl, %cl
; AVX2-NEXT:    orb %al, %cl
; AVX2-NEXT:    andb $15, %cl
; AVX2-NEXT:    movb %cl, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: bitcast_4i64_store:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vpcmpgtq %ymm0, %ymm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    movb %al, (%rdi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: bitcast_4i64_store:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512BW-NEXT:    vpcmpgtq %ymm0, %ymm1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    movb %al, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a1 = icmp slt <4 x i64> %a0, zeroinitializer
  %a2 = bitcast <4 x i1> %a1 to i4
  store i4 %a2, i4* %p
  ret void
}
