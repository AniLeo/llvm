; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512f | FileCheck %s --check-prefix=CHECK --check-prefix=KNL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512vl,avx512dq,avx512bw | FileCheck %s --check-prefix=CHECK --check-prefix=SKX

define i8 @kshiftl_v8i1_1(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftl_v8i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    movb $-2, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandq %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v8i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    movb $-2, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandd %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> %a, <8 x i1> zeroinitializer, <8 x i32> <i32 8, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}

define i16 @kshiftl_v16i1_1(<16 x i32> %x, <16 x i32> %y) {
; KNL-LABEL: kshiftl_v16i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    movw $-2, %ax
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $ax killed $ax killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v16i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmd %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %zmm0
; SKX-NEXT:    movw $-2, %ax
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; SKX-NEXT:    vpmovd2m %zmm0, %k1
; SKX-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $ax killed $ax killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <16 x i32> %x, zeroinitializer
  %b = shufflevector <16 x i1> %a, <16 x i1> zeroinitializer, <16 x i32> <i32 16, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  %c = icmp eq <16 x i32> %y, zeroinitializer
  %d = and <16 x i1> %b, %c
  %e = bitcast <16 x i1> %d to i16
  ret i16 %e
}

define i32 @kshiftl_v32i1_1(<32 x i16> %x, <32 x i16> %y) {
; KNL-LABEL: kshiftl_v32i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm1, %ymm1
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm0, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k2
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k2} {z}
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm1 = zmm0[15],zmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    movw $-2, %ax
; KNL-NEXT:    kmovw %eax, %k2
; KNL-NEXT:    vpexpandd %zmm0, %zmm0 {%k2} {z}
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k2
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm3, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm2, %ymm1
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k0 {%k2}
; KNL-NEXT:    kmovw %k0, %ecx
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    shll $16, %eax
; KNL-NEXT:    orl %ecx, %eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v32i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmw %zmm0, %zmm0, %k0
; SKX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; SKX-NEXT:    vpmovm2w %k0, %zmm2
; SKX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [32,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
; SKX-NEXT:    vpermi2w %zmm0, %zmm2, %zmm3
; SKX-NEXT:    vpmovw2m %zmm3, %k1
; SKX-NEXT:    vptestnmw %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <32 x i16> %x, zeroinitializer
  %b = shufflevector <32 x i1> %a, <32 x i1> zeroinitializer, <32 x i32> <i32 32, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30>
  %c = icmp eq <32 x i16> %y, zeroinitializer
  %d = and <32 x i1> %b, %c
  %e = bitcast <32 x i1> %d to i32
  ret i32 %e
}

define i64 @kshiftl_v64i1_1(<64 x i8> %x, <64 x i8> %y) {
; KNL-LABEL: kshiftl_v64i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm0, %ymm0
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm5
; KNL-NEXT:    vptestmd %zmm5, %zmm5, %k3
; KNL-NEXT:    vextracti128 $1, %ymm0, %xmm0
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k2
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm1, %ymm0
; KNL-NEXT:    vextracti128 $1, %ymm0, %xmm1
; KNL-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k4
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k4} {z}
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm1 = zmm0[15],zmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k2} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm0 = zmm1[15],zmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k2
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k3} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm1 = zmm0[15],zmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k3
; KNL-NEXT:    movw $-2, %ax
; KNL-NEXT:    kmovw %eax, %k4
; KNL-NEXT:    vpexpandd %zmm0, %zmm0 {%k4} {z}
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k4
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm3, %ymm0
; KNL-NEXT:    vextracti128 $1, %ymm0, %xmm1
; KNL-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm2, %ymm2
; KNL-NEXT:    vextracti128 $1, %ymm2, %xmm3
; KNL-NEXT:    vpmovsxbd %xmm3, %zmm3
; KNL-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL-NEXT:    vptestmd %zmm2, %zmm2, %k0 {%k4}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    vptestmd %zmm3, %zmm3, %k0 {%k3}
; KNL-NEXT:    kmovw %k0, %ecx
; KNL-NEXT:    shll $16, %ecx
; KNL-NEXT:    orl %eax, %ecx
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k2}
; KNL-NEXT:    kmovw %k0, %edx
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    shll $16, %eax
; KNL-NEXT:    orl %edx, %eax
; KNL-NEXT:    shlq $32, %rax
; KNL-NEXT:    orq %rcx, %rax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v64i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmb %zmm0, %zmm0, %k0
; SKX-NEXT:    movl $1, %eax
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    knotd %k1, %k1
; SKX-NEXT:    vpmovm2b %k0, %zmm0
; SKX-NEXT:    vpermq {{.*#+}} ymm2 = ymm0[2,3,0,1]
; SKX-NEXT:    vpalignr {{.*#+}} ymm2 {%k1} {z} = ymm2[15],ymm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],ymm2[31],ymm0[16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
; SKX-NEXT:    vextracti64x4 $1, %zmm0, %ymm3
; SKX-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm3[0,1]
; SKX-NEXT:    vpalignr {{.*#+}} ymm0 = ymm0[15],ymm3[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],ymm0[31],ymm3[16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
; SKX-NEXT:    vinserti64x4 $1, %ymm0, %zmm2, %zmm0
; SKX-NEXT:    vpmovb2m %zmm0, %k1
; SKX-NEXT:    vptestnmb %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovq %k0, %rax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <64 x i8> %x, zeroinitializer
  %b = shufflevector <64 x i1> %a, <64 x i1> zeroinitializer, <64 x i32> <i32 64, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62>
  %c = icmp eq <64 x i8> %y, zeroinitializer
  %d = and <64 x i1> %b, %c
  %e = bitcast <64 x i1> %d to i64
  ret i64 %e
}

define i8 @kshiftl_v8i1_7(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftl_v8i1_7:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    movb $-128, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandq %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v8i1_7:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    movb $-128, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandd %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> zeroinitializer, <8 x i1> %a, <8 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}

define i16 @kshiftl_v16i1_15(<16 x i32> %x, <16 x i32> %y) {
; KNL-LABEL: kshiftl_v16i1_15:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    movw $-32768, %ax # imm = 0x8000
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $ax killed $ax killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v16i1_15:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmd %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %zmm0
; SKX-NEXT:    movw $-32768, %ax # imm = 0x8000
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; SKX-NEXT:    vpmovd2m %zmm0, %k1
; SKX-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $ax killed $ax killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <16 x i32> %x, zeroinitializer
  %b = shufflevector <16 x i1> zeroinitializer, <16 x i1> %a, <16 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>
  %c = icmp eq <16 x i32> %y, zeroinitializer
  %d = and <16 x i1> %b, %c
  %e = bitcast <16 x i1> %d to i16
  ret i16 %e
}

define i32 @kshiftl_v32i1_31(<32 x i16> %x, <32 x i16> %y) {
; KNL-LABEL: kshiftl_v32i1_31:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; KNL-NEXT:    vpcmpeqw %ymm1, %ymm0, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    movw $-32768, %ax # imm = 0x8000
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpcmpeqw %ymm1, %ymm3, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    shll $16, %eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v32i1_31:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmw %zmm0, %zmm0, %k0
; SKX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; SKX-NEXT:    vpmovm2w %k0, %zmm2
; SKX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32]
; SKX-NEXT:    vpermi2w %zmm2, %zmm0, %zmm3
; SKX-NEXT:    vpmovw2m %zmm3, %k1
; SKX-NEXT:    vptestnmw %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <32 x i16> %x, zeroinitializer
  %b = shufflevector <32 x i1> zeroinitializer, <32 x i1> %a, <32 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32>
  %c = icmp eq <32 x i16> %y, zeroinitializer
  %d = and <32 x i1> %b, %c
  %e = bitcast <32 x i1> %d to i32
  ret i32 %e
}

define i64 @kshiftl_v64i1_63(<64 x i8> %x, <64 x i8> %y) {
; KNL-LABEL: kshiftl_v64i1_63:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; KNL-NEXT:    vpcmpeqb %ymm1, %ymm0, %ymm0
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    movw $-32768, %ax # imm = 0x8000
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpcmpeqb %ymm1, %ymm3, %ymm0
; KNL-NEXT:    vextracti128 $1, %ymm0, %xmm0
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    movzwl %ax, %eax
; KNL-NEXT:    shlq $48, %rax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v64i1_63:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmb %zmm0, %zmm0, %k0
; SKX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; SKX-NEXT:    vpmovm2b %k0, %zmm2
; SKX-NEXT:    vpslldq {{.*#+}} xmm2 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm2[0]
; SKX-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm2
; SKX-NEXT:    movl $-2147483648, %eax # imm = 0x80000000
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vmovdqu8 %ymm2, %ymm2 {%k1} {z}
; SKX-NEXT:    vinserti64x4 $1, %ymm2, %zmm0, %zmm0
; SKX-NEXT:    vpmovb2m %zmm0, %k1
; SKX-NEXT:    vptestnmb %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovq %k0, %rax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <64 x i8> %x, zeroinitializer
  %b = shufflevector <64 x i1> zeroinitializer, <64 x i1> %a, <64 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64>
  %c = icmp eq <64 x i8> %y, zeroinitializer
  %d = and <64 x i1> %b, %c
  %e = bitcast <64 x i1> %d to i64
  ret i64 %e
}

define i8 @kshiftr_v8i1_1(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftr_v8i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; KNL-NEXT:    vpternlogq $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [1,2,3,4,5,6,7,15]
; KNL-NEXT:    vpermi2q %zmm0, %zmm2, %zmm3
; KNL-NEXT:    vptestmq %zmm3, %zmm3, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v8i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    valignd {{.*#+}} ymm0 = ymm0[1,2,3,4,5,6,7,0]
; SKX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; SKX-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1,2,3,4,5,6],ymm2[7]
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> %a, <8 x i1> zeroinitializer, <8 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}

define i16 @kshiftr_v16i1_1(<16 x i32> %x, <16 x i32> %y) {
; KNL-LABEL: kshiftr_v16i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; KNL-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,31]
; KNL-NEXT:    vpermi2d %zmm0, %zmm2, %zmm3
; KNL-NEXT:    vptestmd %zmm3, %zmm3, %k1
; KNL-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $ax killed $ax killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v16i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmd %zmm0, %zmm0, %k0
; SKX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; SKX-NEXT:    vpmovm2d %k0, %zmm2
; SKX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,31]
; SKX-NEXT:    vpermi2d %zmm0, %zmm2, %zmm3
; SKX-NEXT:    vpmovd2m %zmm3, %k1
; SKX-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $ax killed $ax killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <16 x i32> %x, zeroinitializer
  %b = shufflevector <16 x i1> %a, <16 x i1> zeroinitializer, <16 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>
  %c = icmp eq <16 x i32> %y, zeroinitializer
  %d = and <16 x i1> %b, %c
  %e = bitcast <16 x i1> %d to i16
  ret i16 %e
}

define i32 @kshiftr_v32i1_1(<32 x i16> %x, <32 x i16> %y) {
; KNL-LABEL: kshiftr_v32i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm1, %ymm1
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm0, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k2
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k2} {z}
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm0 = zmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0]
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm0 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,31]
; KNL-NEXT:    vpxor %xmm5, %xmm5, %xmm5
; KNL-NEXT:    vpermi2d %zmm5, %zmm1, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k2
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm3, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm2, %ymm1
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %ecx
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k2}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    shll $16, %eax
; KNL-NEXT:    orl %ecx, %eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v32i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmw %zmm0, %zmm0, %k0
; SKX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; SKX-NEXT:    vpmovm2w %k0, %zmm2
; SKX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,63]
; SKX-NEXT:    vpermi2w %zmm0, %zmm2, %zmm3
; SKX-NEXT:    vpmovw2m %zmm3, %k1
; SKX-NEXT:    vptestnmw %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <32 x i16> %x, zeroinitializer
  %b = shufflevector <32 x i1> %a, <32 x i1> zeroinitializer, <32 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32>
  %c = icmp eq <32 x i16> %y, zeroinitializer
  %d = and <32 x i1> %b, %c
  %e = bitcast <32 x i1> %d to i32
  ret i32 %e
}

define i64 @kshiftr_v64i1_1(<64 x i8> %x, <64 x i8> %y) {
; KNL-LABEL: kshiftr_v64i1_1:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm0, %ymm0
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm5
; KNL-NEXT:    vptestmd %zmm5, %zmm5, %k2
; KNL-NEXT:    vextracti128 $1, %ymm0, %xmm0
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k3
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm1, %ymm0
; KNL-NEXT:    vextracti128 $1, %ymm0, %xmm1
; KNL-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k4
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k4} {z}
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm5 = zmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm1[0]
; KNL-NEXT:    vptestmd %zmm5, %zmm5, %k1
; KNL-NEXT:    vpternlogd $255, %zmm5, %zmm5, %zmm5 {%k3} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm0 = zmm5[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm0[0]
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k3
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k2} {z}
; KNL-NEXT:    valignd {{.*#+}} zmm0 = zmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zmm5[0]
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k4
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm0 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,31]
; KNL-NEXT:    vpxor %xmm5, %xmm5, %xmm5
; KNL-NEXT:    vpermi2d %zmm5, %zmm1, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k2
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm3, %ymm0
; KNL-NEXT:    vextracti128 $1, %ymm0, %xmm1
; KNL-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vpcmpeqb %ymm4, %ymm2, %ymm2
; KNL-NEXT:    vextracti128 $1, %ymm2, %xmm3
; KNL-NEXT:    vpmovsxbd %xmm3, %zmm3
; KNL-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL-NEXT:    vptestmd %zmm2, %zmm2, %k0 {%k4}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    vptestmd %zmm3, %zmm3, %k0 {%k3}
; KNL-NEXT:    kmovw %k0, %ecx
; KNL-NEXT:    shll $16, %ecx
; KNL-NEXT:    orl %eax, %ecx
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %edx
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k0 {%k2}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    shll $16, %eax
; KNL-NEXT:    orl %edx, %eax
; KNL-NEXT:    shlq $32, %rax
; KNL-NEXT:    orq %rcx, %rax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v64i1_1:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmb %zmm0, %zmm0, %k0
; SKX-NEXT:    movl $-2147483648, %eax # imm = 0x80000000
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    knotd %k1, %k1
; SKX-NEXT:    vpmovm2b %k0, %zmm0
; SKX-NEXT:    vextracti64x4 $1, %zmm0, %ymm2
; SKX-NEXT:    vpermq {{.*#+}} ymm3 = ymm2[2,3,0,1]
; SKX-NEXT:    vpalignr {{.*#+}} ymm3 {%k1} {z} = ymm2[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],ymm3[0],ymm2[17,18,19,20,21,22,23,24,25,26,27,28,29,30,31],ymm3[16]
; SKX-NEXT:    vperm2i128 {{.*#+}} ymm2 = ymm0[2,3],ymm2[0,1]
; SKX-NEXT:    vpalignr {{.*#+}} ymm0 = ymm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],ymm2[0],ymm0[17,18,19,20,21,22,23,24,25,26,27,28,29,30,31],ymm2[16]
; SKX-NEXT:    vinserti64x4 $1, %ymm3, %zmm0, %zmm0
; SKX-NEXT:    vpmovb2m %zmm0, %k1
; SKX-NEXT:    vptestnmb %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovq %k0, %rax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <64 x i8> %x, zeroinitializer
  %b = shufflevector <64 x i1> %a, <64 x i1> zeroinitializer, <64 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64>
  %c = icmp eq <64 x i8> %y, zeroinitializer
  %d = and <64 x i1> %b, %c
  %e = bitcast <64 x i1> %d to i64
  ret i64 %e
}

define i8 @kshiftr_v8i1_7(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftr_v8i1_7:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    movb $-2, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandq %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v8i1_7:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    movb $-2, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandd %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> %a, <8 x i1> zeroinitializer, <8 x i32> <i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}

define i16 @kshiftr_v16i1_15(<16 x i32> %x, <16 x i32> %y) {
; KNL-LABEL: kshiftr_v16i1_15:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmd %zmm0, %zmm0, %k1
; KNL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; KNL-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [31,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; KNL-NEXT:    vpermi2d %zmm2, %zmm0, %zmm3
; KNL-NEXT:    vptestmd %zmm3, %zmm3, %k1
; KNL-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $ax killed $ax killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v16i1_15:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmd %zmm0, %zmm0, %k0
; SKX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; SKX-NEXT:    vpmovm2d %k0, %zmm2
; SKX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [31,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; SKX-NEXT:    vpermi2d %zmm2, %zmm0, %zmm3
; SKX-NEXT:    vpmovd2m %zmm3, %k1
; SKX-NEXT:    vptestnmd %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $ax killed $ax killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <16 x i32> %x, zeroinitializer
  %b = shufflevector <16 x i1> zeroinitializer, <16 x i1> %a, <16 x i32> <i32 31, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  %c = icmp eq <16 x i32> %y, zeroinitializer
  %d = and <16 x i1> %b, %c
  %e = bitcast <16 x i1> %d to i16
  ret i16 %e
}

define i32 @kshiftr_v32i1_31(<32 x i16> %x, <32 x i16> %y) {
; KNL-LABEL: kshiftr_v32i1_31:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; KNL-NEXT:    vpcmpeqw %ymm0, %ymm1, %ymm1
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [31,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; KNL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; KNL-NEXT:    vpermt2d %zmm1, %zmm3, %zmm4
; KNL-NEXT:    vptestmd %zmm4, %zmm4, %k1
; KNL-NEXT:    vpcmpeqw %ymm0, %ymm2, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v32i1_31:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmw %zmm0, %zmm0, %k0
; SKX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; SKX-NEXT:    vpmovm2w %k0, %zmm2
; SKX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [63,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
; SKX-NEXT:    vpermi2w %zmm2, %zmm0, %zmm3
; SKX-NEXT:    vpmovw2m %zmm3, %k1
; SKX-NEXT:    vptestnmw %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <32 x i16> %x, zeroinitializer
  %b = shufflevector <32 x i1> zeroinitializer, <32 x i1> %a, <32 x i32> <i32 63, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30>
  %c = icmp eq <32 x i16> %y, zeroinitializer
  %d = and <32 x i1> %b, %c
  %e = bitcast <32 x i1> %d to i32
  ret i32 %e
}

define i64 @kshiftr_v64i1_63(<64 x i8> %x, <64 x i8> %y) {
; KNL-LABEL: kshiftr_v64i1_63:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; KNL-NEXT:    vpcmpeqb %ymm0, %ymm1, %ymm1
; KNL-NEXT:    vextracti128 $1, %ymm1, %xmm1
; KNL-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [31,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; KNL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; KNL-NEXT:    vpermt2d %zmm1, %zmm3, %zmm4
; KNL-NEXT:    vptestmd %zmm4, %zmm4, %k1
; KNL-NEXT:    vpcmpeqb %ymm0, %ymm2, %ymm0
; KNL-NEXT:    vpmovsxbd %xmm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    movzwl %ax, %eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v64i1_63:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmb %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2b %k0, %zmm0
; SKX-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; SKX-NEXT:    vextracti128 $1, %ymm0, %xmm0
; SKX-NEXT:    vpsrldq {{.*#+}} xmm0 = xmm0[15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; SKX-NEXT:    movl $1, %eax
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vmovdqu8 %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    vpmovb2m %zmm0, %k1
; SKX-NEXT:    vptestnmb %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovq %k0, %rax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <64 x i8> %x, zeroinitializer
  %b = shufflevector <64 x i1> zeroinitializer, <64 x i1> %a, <64 x i32> <i32 127, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62>
  %c = icmp eq <64 x i8> %y, zeroinitializer
  %d = and <64 x i1> %b, %c
  %e = bitcast <64 x i1> %d to i64
  ret i64 %e
}

define i8 @kshiftl_v8i1_zu123u56(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftl_v8i1_zu123u56:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; KNL-NEXT:    vpternlogq $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm3 = <8,u,1,2,3,u,5,6>
; KNL-NEXT:    vpermi2q %zmm0, %zmm2, %zmm3
; KNL-NEXT:    vpsllq $63, %zmm3, %zmm0
; KNL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v8i1_zu123u56:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    valignd {{.*#+}} ymm0 = ymm0[7,0,1,2,3,4,5,6]
; SKX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; SKX-NEXT:    vpblendd {{.*#+}} ymm0 = ymm2[0,1],ymm0[2,3,4,5,6,7]
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> %a, <8 x i1> zeroinitializer, <8 x i32> <i32 8, i32 undef, i32 1, i32 2, i32 3, i32 undef, i32 5, i32 6>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}

define i8 @kshiftl_v8i1_u0123456(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftl_v8i1_u0123456:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    valignq {{.*#+}} zmm0 = zmm0[7,0,1,2,3,4,5,6]
; KNL-NEXT:    vpsllq $63, %zmm0, %zmm0
; KNL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftl_v8i1_u0123456:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    valignd {{.*#+}} ymm0 = ymm0[7,0,1,2,3,4,5,6]
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> %a, <8 x i1> undef, <8 x i32> <i32 undef, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}

define i8 @kshiftr_v8i1_1u3u567z(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftr_v8i1_1u3u567z:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; KNL-NEXT:    vpternlogq $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; KNL-NEXT:    vmovdqa64 {{.*#+}} zmm3 = <1,u,3,u,5,6,7,15>
; KNL-NEXT:    vpermi2q %zmm0, %zmm2, %zmm3
; KNL-NEXT:    vpsllq $63, %zmm3, %zmm0
; KNL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v8i1_1u3u567z:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    vpsrldq {{.*#+}} ymm0 = ymm0[4,5,6,7,8,9,10,11,12,13,14,15],zero,zero,zero,zero,ymm0[20,21,22,23,24,25,26,27,28,29,30,31],zero,zero,zero,zero
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> %a, <8 x i1> zeroinitializer, <8 x i32> <i32 1, i32 undef, i32 3, i32 undef, i32 5, i32 6, i32 7, i32 8>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}

define i8 @kshiftr_v8i1_234567uu(<8 x i64> %x, <8 x i64> %y) {
; KNL-LABEL: kshiftr_v8i1_234567uu:
; KNL:       # %bb.0:
; KNL-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vpternlogq $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vshufi64x2 {{.*#+}} zmm0 = zmm0[2,3,4,5,6,7,0,1]
; KNL-NEXT:    vpsllq $63, %zmm0, %zmm0
; KNL-NEXT:    vptestmq %zmm0, %zmm0, %k1
; KNL-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    # kill: def $al killed $al killed $eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; SKX-LABEL: kshiftr_v8i1_234567uu:
; SKX:       # %bb.0:
; SKX-NEXT:    vptestnmq %zmm0, %zmm0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[1,2,3,3]
; SKX-NEXT:    vpmovd2m %ymm0, %k1
; SKX-NEXT:    vptestnmq %zmm1, %zmm1, %k0 {%k1}
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    # kill: def $al killed $al killed $eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = shufflevector <8 x i1> %a, <8 x i1> undef, <8 x i32> <i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 10>
  %c = icmp eq <8 x i64> %y, zeroinitializer
  %d = and <8 x i1> %b, %c
  %e = bitcast <8 x i1> %d to i8
  ret i8 %e
}
