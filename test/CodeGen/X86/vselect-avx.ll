; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-apple-macosx -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; For this test we used to optimize the <i1 true, i1 false, i1 false, i1 true>
; mask into <i32 2147483648, i32 0, i32 0, i32 2147483648> because we thought
; we would lower that into a blend where only the high bit is relevant.
; However, since the whole mask is constant, this is simplified incorrectly
; by the generic code, because it was expecting -1 in place of 2147483648.
;
; The problem does not occur without AVX, because vselect of v4i32 is not legal
; nor custom.
;
; <rdar://problem/18675020>

define void @test(<4 x i16>* %a, <4 x i16>* %b) {
; AVX-LABEL: test:
; AVX:       ## %bb.0: ## %body
; AVX-NEXT:    movabsq $4167800517033787389, %rax ## imm = 0x39D7007D007CFFFD
; AVX-NEXT:    movq %rax, (%rdi)
; AVX-NEXT:    movabsq $-281474976645121, %rax ## imm = 0xFFFF00000000FFFF
; AVX-NEXT:    movq %rax, (%rsi)
; AVX-NEXT:    retq
body:
  %predphi = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i16> <i16 -3, i16 545, i16 4385, i16 14807>, <4 x i16> <i16 123, i16 124, i16 125, i16 127>
  %predphi42 = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i16> <i16 -1, i16 -1, i16 -1, i16 -1>, <4 x i16> zeroinitializer
  store <4 x i16> %predphi, <4 x i16>* %a, align 8
  store <4 x i16> %predphi42, <4 x i16>* %b, align 8
  ret void
}

; Improve code coverage.
;
; When shrinking the condition used into the select to match a blend, this
; test case exercises the path where the modified node is not the root
; of the condition.

define void @test2(double** %call1559, i64 %indvars.iv4198, <4 x i1> %tmp1895) {
; AVX1-LABEL: test2:
; AVX1:       ## %bb.0: ## %bb
; AVX1-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX1-NEXT:    vpmovsxdq %xmm0, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; AVX1-NEXT:    vpmovsxdq %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    movq (%rdi,%rsi,8), %rax
; AVX1-NEXT:    vmovapd {{.*#+}} ymm1 = [5.0E-1,5.0E-1,5.0E-1,5.0E-1]
; AVX1-NEXT:    vblendvpd %ymm0, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; AVX1-NEXT:    vmovupd %ymm0, (%rax)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test2:
; AVX2:       ## %bb.0: ## %bb
; AVX2-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm0
; AVX2-NEXT:    movq (%rdi,%rsi,8), %rax
; AVX2-NEXT:    vbroadcastsd {{.*#+}} ymm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX2-NEXT:    vbroadcastsd {{.*#+}} ymm2 = [5.0E-1,5.0E-1,5.0E-1,5.0E-1]
; AVX2-NEXT:    vblendvpd %ymm0, %ymm1, %ymm2, %ymm0
; AVX2-NEXT:    vmovupd %ymm0, (%rax)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
bb:
  %arrayidx1928 = getelementptr inbounds double*, double** %call1559, i64 %indvars.iv4198
  %tmp1888 = load double*, double** %arrayidx1928, align 8
  %predphi.v.v = select <4 x i1> %tmp1895, <4 x double> <double -5.000000e-01, double -5.000000e-01, double -5.000000e-01, double -5.000000e-01>, <4 x double> <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
  %tmp1900 = bitcast double* %tmp1888 to <4 x double>*
  store <4 x double> %predphi.v.v, <4 x double>* %tmp1900, align 8
  ret void
}

; For this test, we used to optimized the conditional mask for the blend, i.e.,
; we shrunk some of its bits.
; However, this same mask was used in another select (%predphi31) that turned out
; to be optimized into a and. In that case, the conditional mask was wrong.
;
; Make sure that the and is fed by the original mask.
;
; <rdar://problem/18819506>

define void @test3(<4 x i32> %induction30, <4 x i16>* %tmp16, <4 x i16>* %tmp17,  <4 x i16> %tmp3, <4 x i16> %tmp12) {
; AVX1-LABEL: test3:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vpminud {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm3
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpackssdw %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    vpblendvb %xmm0, %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpblendvb %xmm0, %xmm2, %xmm3, %xmm0
; AVX1-NEXT:    vmovq %xmm0, (%rdi)
; AVX1-NEXT:    vmovq %xmm1, (%rsi)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test3:
; AVX2:       ## %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [2863311531,2863311531,2863311531,2863311531]
; AVX2-NEXT:    vpmulld %xmm3, %xmm0, %xmm0
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [715827882,715827882,715827882,715827882]
; AVX2-NEXT:    vpaddd %xmm3, %xmm0, %xmm0
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [1431655764,1431655764,1431655764,1431655764]
; AVX2-NEXT:    vpminud %xmm3, %xmm0, %xmm3
; AVX2-NEXT:    vpcmpeqd %xmm3, %xmm0, %xmm0
; AVX2-NEXT:    vpackssdw %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    vpblendvb %xmm0, %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpblendvb %xmm0, %xmm2, %xmm3, %xmm0
; AVX2-NEXT:    vmovq %xmm0, (%rdi)
; AVX2-NEXT:    vmovq %xmm1, (%rsi)
; AVX2-NEXT:    retq
  %tmp6 = srem <4 x i32> %induction30, <i32 3, i32 3, i32 3, i32 3>
  %tmp7 = icmp eq <4 x i32> %tmp6, zeroinitializer
  %predphi = select <4 x i1> %tmp7, <4 x i16> %tmp3, <4 x i16> %tmp12
  %predphi31 = select <4 x i1> %tmp7, <4 x i16> <i16 -1, i16 -1, i16 -1, i16 -1>, <4 x i16> zeroinitializer

  store <4 x i16> %predphi31, <4 x i16>* %tmp16, align 8
  store <4 x i16> %predphi, <4 x i16>* %tmp17, align 8
 ret void
}

; We shouldn't try to lower this directly using VSELECT because we don't have
; vpblendvb in AVX1, only in AVX2. Instead, it should be expanded.

define <32 x i8> @PR22706(<32 x i1> %x) {
; AVX1-LABEL: PR22706:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpsllw $7, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm3, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX1-NEXT:    vpaddb %xmm4, %xmm1, %xmm1
; AVX1-NEXT:    vpsllw $7, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpcmpgtb %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vpaddb %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: PR22706:
; AVX2:       ## %bb.0:
; AVX2-NEXT:    vpsllw $7, %ymm0, %ymm0
; AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtb %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %tmp = select <32 x i1> %x, <32 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, <32 x i8> <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <32 x i8> %tmp
}

; Split a 256-bit select into two 128-bit selects when the operands are concatenated.

define void @blendv_split(<8 x i32>* %p, <8 x i32> %cond, <8 x i32> %a, <8 x i32> %x, <8 x i32> %y, <8 x i32> %z, <8 x i32> %w) {
; AVX1-LABEL: blendv_split:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm2 = xmm2[0],zero,xmm2[1],zero
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX1-NEXT:    vpslld %xmm2, %xmm4, %xmm5
; AVX1-NEXT:    vpslld %xmm2, %xmm1, %xmm2
; AVX1-NEXT:    vpslld %xmm3, %xmm4, %xmm4
; AVX1-NEXT:    vpslld %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vblendvps %xmm0, %xmm5, %xmm4, %xmm0
; AVX1-NEXT:    vmovups %xmm0, 16(%rdi)
; AVX1-NEXT:    vmovups %xmm1, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: blendv_split:
; AVX2:       ## %bb.0:
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm2 = xmm2[0],zero,xmm2[1],zero
; AVX2-NEXT:    vpmovzxdq {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero
; AVX2-NEXT:    vpslld %xmm2, %ymm1, %ymm2
; AVX2-NEXT:    vpslld %xmm3, %ymm1, %ymm1
; AVX2-NEXT:    vblendvps %ymm0, %ymm2, %ymm1, %ymm0
; AVX2-NEXT:    vmovups %ymm0, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %signbits = ashr <8 x i32> %cond, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  %bool = trunc <8 x i32> %signbits to <8 x i1>
  %shamt1 = shufflevector <8 x i32> %x, <8 x i32> undef, <8 x i32> zeroinitializer
  %shamt2 = shufflevector <8 x i32> %y, <8 x i32> undef, <8 x i32> zeroinitializer
  %sh1 = shl <8 x i32> %a, %shamt1
  %sh2 = shl <8 x i32> %a, %shamt2
  %sel = select <8 x i1> %bool, <8 x i32> %sh1, <8 x i32> %sh2
  store <8 x i32> %sel, <8 x i32>* %p, align 4
  ret void
}
