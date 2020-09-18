; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512cd,+fast-variable-shuffle | FileCheck %s --check-prefixes=ALL,AVX512CD,X64-AVX512CD
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512cd,+fast-variable-shuffle | FileCheck %s --check-prefixes=ALL,AVX512CD,X86-AVX512CD
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,avx512cd,+avx512bw,+fast-variable-shuffle | FileCheck %s --check-prefixes=ALL,AVX512VLCDBW,X64-AVX512VLCDBW
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512vl,avx512cd,+avx512bw,+fast-variable-shuffle | FileCheck %s --check-prefixes=ALL,AVX512VLCDBW,X86-AVX512VLCDBW

define <2 x i64> @test_mm_epi64(<8 x i16> %a, <8 x i16> %b) {
; X64-AVX512CD-LABEL: test_mm_epi64:
; X64-AVX512CD:       # %bb.0: # %entry
; X64-AVX512CD-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; X64-AVX512CD-NEXT:    vpmovsxwq %xmm0, %zmm0
; X64-AVX512CD-NEXT:    vptestmq %zmm0, %zmm0, %k0
; X64-AVX512CD-NEXT:    kmovw %k0, %eax
; X64-AVX512CD-NEXT:    movzbl %al, %eax
; X64-AVX512CD-NEXT:    vmovq %rax, %xmm0
; X64-AVX512CD-NEXT:    vpbroadcastq %xmm0, %xmm0
; X64-AVX512CD-NEXT:    vzeroupper
; X64-AVX512CD-NEXT:    retq
;
; X86-AVX512CD-LABEL: test_mm_epi64:
; X86-AVX512CD:       # %bb.0: # %entry
; X86-AVX512CD-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; X86-AVX512CD-NEXT:    vpmovsxwq %xmm0, %zmm0
; X86-AVX512CD-NEXT:    vptestmq %zmm0, %zmm0, %k0
; X86-AVX512CD-NEXT:    kmovw %k0, %eax
; X86-AVX512CD-NEXT:    movzbl %al, %eax
; X86-AVX512CD-NEXT:    vmovd %eax, %xmm0
; X86-AVX512CD-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,2,3],zero,zero,zero,zero,xmm0[0,1,2,3],zero,zero,zero,zero
; X86-AVX512CD-NEXT:    vzeroupper
; X86-AVX512CD-NEXT:    retl
;
; AVX512VLCDBW-LABEL: test_mm_epi64:
; AVX512VLCDBW:       # %bb.0: # %entry
; AVX512VLCDBW-NEXT:    vpcmpeqw %xmm1, %xmm0, %k0
; AVX512VLCDBW-NEXT:    vpbroadcastmb2q %k0, %xmm0
; AVX512VLCDBW-NEXT:    ret{{[l|q]}}
entry:
  %0 = icmp eq <8 x i16> %a, %b
  %1 = bitcast <8 x i1> %0 to i8
  %conv.i = zext i8 %1 to i64
  %vecinit.i.i = insertelement <2 x i64> undef, i64 %conv.i, i32 0
  %vecinit1.i.i = shufflevector <2 x i64> %vecinit.i.i, <2 x i64> undef, <2 x i32> zeroinitializer
  ret <2 x i64> %vecinit1.i.i
}

define <4 x i32> @test_mm_epi32(<16 x i8> %a, <16 x i8> %b) {
; AVX512CD-LABEL: test_mm_epi32:
; AVX512CD:       # %bb.0: # %entry
; AVX512CD-NEXT:    vpcmpeqb %xmm1, %xmm0, %xmm0
; AVX512CD-NEXT:    vpmovmskb %xmm0, %eax
; AVX512CD-NEXT:    vmovd %eax, %xmm0
; AVX512CD-NEXT:    vpbroadcastd %xmm0, %xmm0
; AVX512CD-NEXT:    ret{{[l|q]}}
;
; AVX512VLCDBW-LABEL: test_mm_epi32:
; AVX512VLCDBW:       # %bb.0: # %entry
; AVX512VLCDBW-NEXT:    vpcmpeqb %xmm1, %xmm0, %k0
; AVX512VLCDBW-NEXT:    vpbroadcastmw2d %k0, %xmm0
; AVX512VLCDBW-NEXT:    ret{{[l|q]}}
entry:
  %0 = icmp eq <16 x i8> %a, %b
  %1 = bitcast <16 x i1> %0 to i16
  %conv.i = zext i16 %1 to i32
  %vecinit.i.i = insertelement <4 x i32> undef, i32 %conv.i, i32 0
  %vecinit3.i.i = shufflevector <4 x i32> %vecinit.i.i, <4 x i32> undef, <4 x i32> zeroinitializer
  ret <4 x i32> %vecinit3.i.i
}

define <16 x i32> @test_mm512_epi32(<16 x i32> %a, <16 x i32> %b) {
; ALL-LABEL: test_mm512_epi32:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vpcmpeqd %zmm1, %zmm0, %k0
; ALL-NEXT:    vpbroadcastmw2d %k0, %zmm0
; ALL-NEXT:    ret{{[l|q]}}
entry:
  %0 = icmp eq <16 x i32> %a, %b
  %1 = bitcast <16 x i1> %0 to i16
  %conv.i = zext i16 %1 to i32
  %vecinit.i.i = insertelement <16 x i32> undef, i32 %conv.i, i32 0
  %vecinit15.i.i = shufflevector <16 x i32> %vecinit.i.i, <16 x i32> undef, <16 x i32> zeroinitializer
  ret <16 x i32> %vecinit15.i.i
}

define <8 x i64> @test_mm512_epi64(<8 x i32> %a, <8 x i32> %b) {
; AVX512CD-LABEL: test_mm512_epi64:
; AVX512CD:       # %bb.0: # %entry
; AVX512CD-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512CD-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512CD-NEXT:    vpcmpeqd %zmm1, %zmm0, %k0
; AVX512CD-NEXT:    vpbroadcastmb2q %k0, %zmm0
; AVX512CD-NEXT:    ret{{[l|q]}}
;
; AVX512VLCDBW-LABEL: test_mm512_epi64:
; AVX512VLCDBW:       # %bb.0: # %entry
; AVX512VLCDBW-NEXT:    vpcmpeqd %ymm1, %ymm0, %k0
; AVX512VLCDBW-NEXT:    vpbroadcastmb2q %k0, %zmm0
; AVX512VLCDBW-NEXT:    ret{{[l|q]}}
entry:
  %0 = icmp eq <8 x i32> %a, %b
  %1 = bitcast <8 x i1> %0 to i8
  %conv.i = zext i8 %1 to i64
  %vecinit.i.i = insertelement <8 x i64> undef, i64 %conv.i, i32 0
  %vecinit7.i.i = shufflevector <8 x i64> %vecinit.i.i, <8 x i64> undef, <8 x i32> zeroinitializer
  ret <8 x i64> %vecinit7.i.i
}

define <4 x i64> @test_mm256_epi64(<8 x i32> %a, <8 x i32> %b) {
; X64-AVX512CD-LABEL: test_mm256_epi64:
; X64-AVX512CD:       # %bb.0: # %entry
; X64-AVX512CD-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; X64-AVX512CD-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; X64-AVX512CD-NEXT:    vpcmpeqd %zmm1, %zmm0, %k0
; X64-AVX512CD-NEXT:    kmovw %k0, %eax
; X64-AVX512CD-NEXT:    movzbl %al, %eax
; X64-AVX512CD-NEXT:    vmovq %rax, %xmm0
; X64-AVX512CD-NEXT:    vpbroadcastq %xmm0, %ymm0
; X64-AVX512CD-NEXT:    retq
;
; X86-AVX512CD-LABEL: test_mm256_epi64:
; X86-AVX512CD:       # %bb.0: # %entry
; X86-AVX512CD-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; X86-AVX512CD-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; X86-AVX512CD-NEXT:    vpcmpeqd %zmm1, %zmm0, %k0
; X86-AVX512CD-NEXT:    kmovw %k0, %eax
; X86-AVX512CD-NEXT:    movzbl %al, %eax
; X86-AVX512CD-NEXT:    vmovd %eax, %xmm0
; X86-AVX512CD-NEXT:    vpbroadcastq %xmm0, %ymm0
; X86-AVX512CD-NEXT:    retl
;
; AVX512VLCDBW-LABEL: test_mm256_epi64:
; AVX512VLCDBW:       # %bb.0: # %entry
; AVX512VLCDBW-NEXT:    vpcmpeqd %ymm1, %ymm0, %k0
; AVX512VLCDBW-NEXT:    vpbroadcastmb2q %k0, %ymm0
; AVX512VLCDBW-NEXT:    ret{{[l|q]}}
entry:
  %0 = icmp eq <8 x i32> %a, %b
  %1 = bitcast <8 x i1> %0 to i8
  %conv.i = zext i8 %1 to i64
  %vecinit.i.i = insertelement <4 x i64> undef, i64 %conv.i, i32 0
  %vecinit3.i.i = shufflevector <4 x i64> %vecinit.i.i, <4 x i64> undef, <4 x i32> zeroinitializer
  ret <4 x i64> %vecinit3.i.i
}

define <8 x i32> @test_mm256_epi32(<16 x i16> %a, <16 x i16> %b) {
; AVX512CD-LABEL: test_mm256_epi32:
; AVX512CD:       # %bb.0: # %entry
; AVX512CD-NEXT:    vpcmpeqw %ymm1, %ymm0, %ymm0
; AVX512CD-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512CD-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512CD-NEXT:    kmovw %k0, %eax
; AVX512CD-NEXT:    vmovd %eax, %xmm0
; AVX512CD-NEXT:    vpbroadcastd %xmm0, %ymm0
; AVX512CD-NEXT:    ret{{[l|q]}}
;
; AVX512VLCDBW-LABEL: test_mm256_epi32:
; AVX512VLCDBW:       # %bb.0: # %entry
; AVX512VLCDBW-NEXT:    vpcmpeqw %ymm1, %ymm0, %k0
; AVX512VLCDBW-NEXT:    vpbroadcastmw2d %k0, %ymm0
; AVX512VLCDBW-NEXT:    ret{{[l|q]}}
entry:
  %0 = icmp eq <16 x i16> %a, %b
  %1 = bitcast <16 x i1> %0 to i16
  %conv.i = zext i16 %1 to i32
  %vecinit.i.i = insertelement <8 x i32> undef, i32 %conv.i, i32 0
  %vecinit7.i.i = shufflevector <8 x i32> %vecinit.i.i, <8 x i32> undef, <8 x i32> zeroinitializer
  ret <8 x i32> %vecinit7.i.i
}

