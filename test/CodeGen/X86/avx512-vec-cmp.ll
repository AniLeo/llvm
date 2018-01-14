; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512f | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512 --check-prefix=KNL
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512 --check-prefix=AVX512BW
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512f,+avx512bw,+avx512vl,+avx512dq | FileCheck %s --check-prefix=CHECK --check-prefix=SKX

define <16 x float> @test1(<16 x float> %x, <16 x float> %y) nounwind {
; CHECK-LABEL: test1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcmpleps %zmm1, %zmm0, %k1
; CHECK-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = fcmp ole <16 x float> %x, %y
  %max = select <16 x i1> %mask, <16 x float> %x, <16 x float> %y
  ret <16 x float> %max
}

define <8 x double> @test2(<8 x double> %x, <8 x double> %y) nounwind {
; CHECK-LABEL: test2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcmplepd %zmm1, %zmm0, %k1
; CHECK-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = fcmp ole <8 x double> %x, %y
  %max = select <8 x i1> %mask, <8 x double> %x, <8 x double> %y
  ret <8 x double> %max
}

define <16 x i32> @test3(<16 x i32> %x, <16 x i32> %x1, <16 x i32>* %yp) nounwind {
; CHECK-LABEL: test3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqd (%rdi), %zmm0, %k1
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i32>, <16 x i32>* %yp, align 4
  %mask = icmp eq <16 x i32> %x, %y
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %x1
  ret <16 x i32> %max
}

define <16 x i32> @test4_unsigned(<16 x i32> %x, <16 x i32> %y, <16 x i32> %x1) nounwind {
; CHECK-LABEL: test4_unsigned:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnltud %zmm1, %zmm0, %k1
; CHECK-NEXT:    vpblendmd %zmm2, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp uge <16 x i32> %x, %y
  %max = select <16 x i1> %mask, <16 x i32> %x1, <16 x i32> %y
  ret <16 x i32> %max
}

define <8 x i64> @test5(<8 x i64> %x, <8 x i64> %y) nounwind {
; CHECK-LABEL: test5:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqq %zmm1, %zmm0, %k1
; CHECK-NEXT:    vpblendmq %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp eq <8 x i64> %x, %y
  %max = select <8 x i1> %mask, <8 x i64> %x, <8 x i64> %y
  ret <8 x i64> %max
}

define <8 x i64> @test6_unsigned(<8 x i64> %x, <8 x i64> %y, <8 x i64> %x1) nounwind {
; CHECK-LABEL: test6_unsigned:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnleuq %zmm1, %zmm0, %k1
; CHECK-NEXT:    vpblendmq %zmm2, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp ugt <8 x i64> %x, %y
  %max = select <8 x i1> %mask, <8 x i64> %x1, <8 x i64> %y
  ret <8 x i64> %max
}

define <4 x float> @test7(<4 x float> %a, <4 x float> %b) {
; AVX512-LABEL: test7:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 def %zmm0
; AVX512-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX512-NEXT:    vcmpltps %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; SKX-LABEL: test7:
; SKX:       ## %bb.0:
; SKX-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; SKX-NEXT:    vcmpltps %xmm2, %xmm0, %k1
; SKX-NEXT:    vblendmps %xmm0, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq

  %mask = fcmp olt <4 x float> %a, zeroinitializer
  %c = select <4 x i1>%mask, <4 x float>%a, <4 x float>%b
  ret <4 x float>%c
}

define <2 x double> @test8(<2 x double> %a, <2 x double> %b) {
; AVX512-LABEL: test8:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 def %zmm0
; AVX512-NEXT:    vxorpd %xmm2, %xmm2, %xmm2
; AVX512-NEXT:    vcmpltpd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; SKX-LABEL: test8:
; SKX:       ## %bb.0:
; SKX-NEXT:    vxorpd %xmm2, %xmm2, %xmm2
; SKX-NEXT:    vcmpltpd %xmm2, %xmm0, %k1
; SKX-NEXT:    vblendmpd %xmm0, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
  %mask = fcmp olt <2 x double> %a, zeroinitializer
  %c = select <2 x i1>%mask, <2 x double>%a, <2 x double>%b
  ret <2 x double>%c
}

define <8 x i32> @test9(<8 x i32> %x, <8 x i32> %y) nounwind {
; AVX512-LABEL: test9:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 def %zmm0
; AVX512-NEXT:    vpcmpeqd %zmm1, %zmm0, %k1
; AVX512-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test9:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpcmpeqd %ymm1, %ymm0, %k1
; SKX-NEXT:    vpblendmd %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq
  %mask = icmp eq <8 x i32> %x, %y
  %max = select <8 x i1> %mask, <8 x i32> %x, <8 x i32> %y
  ret <8 x i32> %max
}

define <8 x float> @test10(<8 x float> %x, <8 x float> %y) nounwind {
; AVX512-LABEL: test10:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 def %zmm0
; AVX512-NEXT:    vcmpeqps %zmm1, %zmm0, %k1
; AVX512-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test10:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpeqps %ymm1, %ymm0, %k1
; SKX-NEXT:    vblendmps %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq

  %mask = fcmp oeq <8 x float> %x, %y
  %max = select <8 x i1> %mask, <8 x float> %x, <8 x float> %y
  ret <8 x float> %max
}

define <8 x i32> @test11_unsigned(<8 x i32> %x, <8 x i32> %y) nounwind {
; CHECK-LABEL: test11_unsigned:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpmaxud %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %mask = icmp ugt <8 x i32> %x, %y
  %max = select <8 x i1> %mask, <8 x i32> %x, <8 x i32> %y
  ret <8 x i32> %max
}

define i16 @test12(<16 x i64> %a, <16 x i64> %b) nounwind {
; KNL-LABEL: test12:
; KNL:       ## %bb.0:
; KNL-NEXT:    vpcmpeqq %zmm2, %zmm0, %k0
; KNL-NEXT:    vpcmpeqq %zmm3, %zmm1, %k1
; KNL-NEXT:    kunpckbw %k0, %k1, %k0
; KNL-NEXT:    kmovw %k0, %eax
; KNL-NEXT:    ## kill: def %ax killed %ax killed %eax
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test12:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpcmpeqq %zmm2, %zmm0, %k0
; AVX512BW-NEXT:    vpcmpeqq %zmm3, %zmm1, %k1
; AVX512BW-NEXT:    kunpckbw %k0, %k1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    ## kill: def %ax killed %ax killed %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test12:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpcmpeqq %zmm2, %zmm0, %k0
; SKX-NEXT:    vpcmpeqq %zmm3, %zmm1, %k1
; SKX-NEXT:    kunpckbw %k0, %k1, %k0
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    ## kill: def %ax killed %ax killed %eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %res = icmp eq <16 x i64> %a, %b
  %res1 = bitcast <16 x i1> %res to i16
  ret i16 %res1
}

define i32 @test12_v32i32(<32 x i32> %a, <32 x i32> %b) nounwind {
; KNL-LABEL: test12_v32i32:
; KNL:       ## %bb.0:
; KNL-NEXT:    pushq %rbp
; KNL-NEXT:    movq %rsp, %rbp
; KNL-NEXT:    andq $-32, %rsp
; KNL-NEXT:    subq $32, %rsp
; KNL-NEXT:    vpcmpeqd %zmm3, %zmm1, %k1
; KNL-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k0
; KNL-NEXT:    kmovw %k0, {{[0-9]+}}(%rsp)
; KNL-NEXT:    vpcmpeqd %zmm2, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0
; KNL-NEXT:    kmovw %k0, (%rsp)
; KNL-NEXT:    movl (%rsp), %eax
; KNL-NEXT:    movq %rbp, %rsp
; KNL-NEXT:    popq %rbp
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test12_v32i32:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpcmpeqd %zmm2, %zmm0, %k0
; AVX512BW-NEXT:    vpcmpeqd %zmm3, %zmm1, %k1
; AVX512BW-NEXT:    kunpckwd %k0, %k1, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test12_v32i32:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpcmpeqd %zmm2, %zmm0, %k0
; SKX-NEXT:    vpcmpeqd %zmm3, %zmm1, %k1
; SKX-NEXT:    kunpckwd %k0, %k1, %k0
; SKX-NEXT:    kmovd %k0, %eax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %res = icmp eq <32 x i32> %a, %b
  %res1 = bitcast <32 x i1> %res to i32
  ret i32 %res1
}

define i64 @test12_v64i16(<64 x i16> %a, <64 x i16> %b) nounwind {
; KNL-LABEL: test12_v64i16:
; KNL:       ## %bb.0:
; KNL-NEXT:    pushq %rbp
; KNL-NEXT:    movq %rsp, %rbp
; KNL-NEXT:    andq $-32, %rsp
; KNL-NEXT:    subq $64, %rsp
; KNL-NEXT:    vpcmpeqw %ymm5, %ymm1, %ymm1
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k0
; KNL-NEXT:    kmovw %k0, {{[0-9]+}}(%rsp)
; KNL-NEXT:    vpcmpeqw %ymm4, %ymm0, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0
; KNL-NEXT:    kmovw %k0, (%rsp)
; KNL-NEXT:    vpcmpeqw %ymm7, %ymm3, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0
; KNL-NEXT:    kmovw %k0, {{[0-9]+}}(%rsp)
; KNL-NEXT:    vpcmpeqw %ymm6, %ymm2, %ymm0
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vptestmd %zmm0, %zmm0, %k0
; KNL-NEXT:    kmovw %k0, {{[0-9]+}}(%rsp)
; KNL-NEXT:    movl (%rsp), %ecx
; KNL-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; KNL-NEXT:    shlq $32, %rax
; KNL-NEXT:    orq %rcx, %rax
; KNL-NEXT:    movq %rbp, %rsp
; KNL-NEXT:    popq %rbp
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test12_v64i16:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpcmpeqw %zmm2, %zmm0, %k0
; AVX512BW-NEXT:    vpcmpeqw %zmm3, %zmm1, %k1
; AVX512BW-NEXT:    kunpckdq %k0, %k1, %k0
; AVX512BW-NEXT:    kmovq %k0, %rax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test12_v64i16:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpcmpeqw %zmm2, %zmm0, %k0
; SKX-NEXT:    vpcmpeqw %zmm3, %zmm1, %k1
; SKX-NEXT:    kunpckdq %k0, %k1, %k0
; SKX-NEXT:    kmovq %k0, %rax
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %res = icmp eq <64 x i16> %a, %b
  %res1 = bitcast <64 x i1> %res to i64
  ret i64 %res1
}

define <16 x i32> @test13(<16 x float>%a, <16 x float>%b)
; CHECK-LABEL: test13:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcmpeqps %zmm1, %zmm0, %k1
; CHECK-NEXT:    vpbroadcastd {{.*}}(%rip), %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
{
  %cmpvector_i = fcmp oeq <16 x float> %a, %b
  %conv = zext <16 x i1> %cmpvector_i to <16 x i32>
  ret <16 x i32> %conv
}

define <16 x i32> @test14(<16 x i32>%a, <16 x i32>%b) {
; CHECK-LABEL: test14:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpsubd %zmm1, %zmm0, %zmm2
; CHECK-NEXT:    vpcmpgtd %zmm0, %zmm2, %k1
; CHECK-NEXT:    vpsubd %zmm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %sub_r = sub <16 x i32> %a, %b
  %cmp.i2.i = icmp sgt <16 x i32> %sub_r, %a
  %sext.i3.i = sext <16 x i1> %cmp.i2.i to <16 x i32>
  %mask = icmp eq <16 x i32> %sext.i3.i, zeroinitializer
  %res = select <16 x i1> %mask, <16 x i32> zeroinitializer, <16 x i32> %sub_r
  ret <16 x i32>%res
}

define <8 x i64> @test15(<8 x i64>%a, <8 x i64>%b) {
; CHECK-LABEL: test15:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpsubq %zmm1, %zmm0, %zmm2
; CHECK-NEXT:    vpcmpgtq %zmm0, %zmm2, %k1
; CHECK-NEXT:    vpsubq %zmm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %sub_r = sub <8 x i64> %a, %b
  %cmp.i2.i = icmp sgt <8 x i64> %sub_r, %a
  %sext.i3.i = sext <8 x i1> %cmp.i2.i to <8 x i64>
  %mask = icmp eq <8 x i64> %sext.i3.i, zeroinitializer
  %res = select <8 x i1> %mask, <8 x i64> zeroinitializer, <8 x i64> %sub_r
  ret <8 x i64>%res
}

define <16 x i32> @test16(<16 x i32> %x, <16 x i32> %y, <16 x i32> %x1) nounwind {
; CHECK-LABEL: test16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpled %zmm0, %zmm1, %k1
; CHECK-NEXT:    vpblendmd %zmm2, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp sge <16 x i32> %x, %y
  %max = select <16 x i1> %mask, <16 x i32> %x1, <16 x i32> %y
  ret <16 x i32> %max
}

define <16 x i32> @test17(<16 x i32> %x, <16 x i32> %x1, <16 x i32>* %y.ptr) nounwind {
; CHECK-LABEL: test17:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtd (%rdi), %zmm0, %k1
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i32>, <16 x i32>* %y.ptr, align 4
  %mask = icmp sgt <16 x i32> %x, %y
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %x1
  ret <16 x i32> %max
}

define <16 x i32> @test18(<16 x i32> %x, <16 x i32> %x1, <16 x i32>* %y.ptr) nounwind {
; CHECK-LABEL: test18:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpled (%rdi), %zmm0, %k1
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i32>, <16 x i32>* %y.ptr, align 4
  %mask = icmp sle <16 x i32> %x, %y
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %x1
  ret <16 x i32> %max
}

define <16 x i32> @test19(<16 x i32> %x, <16 x i32> %x1, <16 x i32>* %y.ptr) nounwind {
; CHECK-LABEL: test19:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpleud (%rdi), %zmm0, %k1
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i32>, <16 x i32>* %y.ptr, align 4
  %mask = icmp ule <16 x i32> %x, %y
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %x1
  ret <16 x i32> %max
}

define <16 x i32> @test20(<16 x i32> %x, <16 x i32> %y, <16 x i32> %x1, <16 x i32> %y1) nounwind {
; CHECK-LABEL: test20:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqd %zmm1, %zmm0, %k1
; CHECK-NEXT:    vpcmpeqd %zmm3, %zmm2, %k1 {%k1}
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp eq <16 x i32> %x1, %y1
  %mask0 = icmp eq <16 x i32> %x, %y
  %mask = select <16 x i1> %mask0, <16 x i1> %mask1, <16 x i1> zeroinitializer
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %y
  ret <16 x i32> %max
}

define <8 x i64> @test21(<8 x i64> %x, <8 x i64> %y, <8 x i64> %x1, <8 x i64> %y1) nounwind {
; CHECK-LABEL: test21:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpleq %zmm1, %zmm0, %k1
; CHECK-NEXT:    vpcmpleq %zmm2, %zmm3, %k1 {%k1}
; CHECK-NEXT:    vpblendmq %zmm0, %zmm2, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <8 x i64> %x1, %y1
  %mask0 = icmp sle <8 x i64> %x, %y
  %mask = select <8 x i1> %mask0, <8 x i1> %mask1, <8 x i1> zeroinitializer
  %max = select <8 x i1> %mask, <8 x i64> %x, <8 x i64> %x1
  ret <8 x i64> %max
}

define <8 x i64> @test22(<8 x i64> %x, <8 x i64>* %y.ptr, <8 x i64> %x1, <8 x i64> %y1) nounwind {
; CHECK-LABEL: test22:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtq %zmm2, %zmm1, %k1
; CHECK-NEXT:    vpcmpgtq (%rdi), %zmm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmq %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sgt <8 x i64> %x1, %y1
  %y = load <8 x i64>, <8 x i64>* %y.ptr, align 4
  %mask0 = icmp sgt <8 x i64> %x, %y
  %mask = select <8 x i1> %mask0, <8 x i1> %mask1, <8 x i1> zeroinitializer
  %max = select <8 x i1> %mask, <8 x i64> %x, <8 x i64> %x1
  ret <8 x i64> %max
}

define <16 x i32> @test23(<16 x i32> %x, <16 x i32>* %y.ptr, <16 x i32> %x1, <16 x i32> %y1) nounwind {
; CHECK-LABEL: test23:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpled %zmm1, %zmm2, %k1
; CHECK-NEXT:    vpcmpleud (%rdi), %zmm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <16 x i32> %x1, %y1
  %y = load <16 x i32>, <16 x i32>* %y.ptr, align 4
  %mask0 = icmp ule <16 x i32> %x, %y
  %mask = select <16 x i1> %mask0, <16 x i1> %mask1, <16 x i1> zeroinitializer
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %x1
  ret <16 x i32> %max
}

define <8 x i64> @test24(<8 x i64> %x, <8 x i64> %x1, i64* %yb.ptr) nounwind {
; CHECK-LABEL: test24:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqq (%rdi){1to8}, %zmm0, %k1
; CHECK-NEXT:    vpblendmq %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %yb = load i64, i64* %yb.ptr, align 4
  %y.0 = insertelement <8 x i64> undef, i64 %yb, i32 0
  %y = shufflevector <8 x i64> %y.0, <8 x i64> undef, <8 x i32> zeroinitializer
  %mask = icmp eq <8 x i64> %x, %y
  %max = select <8 x i1> %mask, <8 x i64> %x, <8 x i64> %x1
  ret <8 x i64> %max
}

define <16 x i32> @test25(<16 x i32> %x, i32* %yb.ptr, <16 x i32> %x1) nounwind {
; CHECK-LABEL: test25:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpled (%rdi){1to16}, %zmm0, %k1
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %yb = load i32, i32* %yb.ptr, align 4
  %y.0 = insertelement <16 x i32> undef, i32 %yb, i32 0
  %y = shufflevector <16 x i32> %y.0, <16 x i32> undef, <16 x i32> zeroinitializer
  %mask = icmp sle <16 x i32> %x, %y
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %x1
  ret <16 x i32> %max
}

define <16 x i32> @test26(<16 x i32> %x, i32* %yb.ptr, <16 x i32> %x1, <16 x i32> %y1) nounwind {
; CHECK-LABEL: test26:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpled %zmm1, %zmm2, %k1
; CHECK-NEXT:    vpcmpgtd (%rdi){1to16}, %zmm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <16 x i32> %x1, %y1
  %yb = load i32, i32* %yb.ptr, align 4
  %y.0 = insertelement <16 x i32> undef, i32 %yb, i32 0
  %y = shufflevector <16 x i32> %y.0, <16 x i32> undef, <16 x i32> zeroinitializer
  %mask0 = icmp sgt <16 x i32> %x, %y
  %mask = select <16 x i1> %mask0, <16 x i1> %mask1, <16 x i1> zeroinitializer
  %max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %x1
  ret <16 x i32> %max
}

define <8 x i64> @test27(<8 x i64> %x, i64* %yb.ptr, <8 x i64> %x1, <8 x i64> %y1) nounwind {
; CHECK-LABEL: test27:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpleq %zmm1, %zmm2, %k1
; CHECK-NEXT:    vpcmpleq (%rdi){1to8}, %zmm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmq %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <8 x i64> %x1, %y1
  %yb = load i64, i64* %yb.ptr, align 4
  %y.0 = insertelement <8 x i64> undef, i64 %yb, i32 0
  %y = shufflevector <8 x i64> %y.0, <8 x i64> undef, <8 x i32> zeroinitializer
  %mask0 = icmp sle <8 x i64> %x, %y
  %mask = select <8 x i1> %mask0, <8 x i1> %mask1, <8 x i1> zeroinitializer
  %max = select <8 x i1> %mask, <8 x i64> %x, <8 x i64> %x1
  ret <8 x i64> %max
}

define <8 x i32>@test28(<8 x i64> %x, <8 x i64> %y, <8 x i64> %x1, <8 x i64> %y1) {
; AVX512-LABEL: test28:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vpcmpgtq %zmm1, %zmm0, %k0
; AVX512-NEXT:    vpcmpgtq %zmm3, %zmm2, %k1
; AVX512-NEXT:    kxnorw %k1, %k0, %k1
; AVX512-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test28:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpcmpgtq %zmm1, %zmm0, %k0
; SKX-NEXT:    vpcmpgtq %zmm3, %zmm2, %k1
; SKX-NEXT:    kxnorb %k1, %k0, %k0
; SKX-NEXT:    vpmovm2d %k0, %ymm0
; SKX-NEXT:    retq
  %x_gt_y = icmp sgt <8 x i64> %x, %y
  %x1_gt_y1 = icmp sgt <8 x i64> %x1, %y1
  %res = icmp eq <8 x i1>%x_gt_y, %x1_gt_y1
  %resse = sext <8 x i1>%res to <8 x i32>
  ret <8 x i32> %resse
}

define <16 x i8>@test29(<16 x i32> %x, <16 x i32> %y, <16 x i32> %x1, <16 x i32> %y1) {
; KNL-LABEL: test29:
; KNL:       ## %bb.0:
; KNL-NEXT:    vpcmpgtd %zmm1, %zmm0, %k0
; KNL-NEXT:    vpcmpgtd %zmm3, %zmm2, %k1
; KNL-NEXT:    kxorw %k1, %k0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vpmovdb %zmm0, %xmm0
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test29:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %zmm1, %zmm0, %k0
; AVX512BW-NEXT:    vpcmpgtd %zmm3, %zmm2, %k1
; AVX512BW-NEXT:    kxorw %k1, %k0, %k0
; AVX512BW-NEXT:    vpmovm2b %k0, %zmm0
; AVX512BW-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test29:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpcmpgtd %zmm1, %zmm0, %k0
; SKX-NEXT:    vpcmpgtd %zmm3, %zmm2, %k1
; SKX-NEXT:    kxorw %k1, %k0, %k0
; SKX-NEXT:    vpmovm2b %k0, %xmm0
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %x_gt_y = icmp sgt <16 x i32> %x, %y
  %x1_gt_y1 = icmp sgt <16 x i32> %x1, %y1
  %res = icmp ne <16 x i1>%x_gt_y, %x1_gt_y1
  %resse = sext <16 x i1>%res to <16 x i8>
  ret <16 x i8> %resse
}

define <4 x double> @test30(<4 x double> %x, <4 x double> %y) nounwind {
; AVX512-LABEL: test30:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 def %zmm0
; AVX512-NEXT:    vcmpeqpd %zmm1, %zmm0, %k1
; AVX512-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test30:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpeqpd %ymm1, %ymm0, %k1
; SKX-NEXT:    vblendmpd %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq

  %mask = fcmp oeq <4 x double> %x, %y
  %max = select <4 x i1> %mask, <4 x double> %x, <4 x double> %y
  ret <4 x double> %max
}

define <2 x double> @test31(<2 x double> %x, <2 x double> %x1, <2 x double>* %yp) nounwind {
; AVX512-LABEL: test31:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 def %zmm0
; AVX512-NEXT:    vmovupd (%rdi), %xmm2
; AVX512-NEXT:    vcmpltpd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; SKX-LABEL: test31:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltpd (%rdi), %xmm0, %k1
; SKX-NEXT:    vblendmpd %xmm0, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq

  %y = load <2 x double>, <2 x double>* %yp, align 4
  %mask = fcmp olt <2 x double> %x, %y
  %max = select <2 x i1> %mask, <2 x double> %x, <2 x double> %x1
  ret <2 x double> %max
}

define <4 x double> @test32(<4 x double> %x, <4 x double> %x1, <4 x double>* %yp) nounwind {
; AVX512-LABEL: test32:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 def %zmm0
; AVX512-NEXT:    vmovupd (%rdi), %ymm2
; AVX512-NEXT:    vcmpltpd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test32:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltpd (%rdi), %ymm0, %k1
; SKX-NEXT:    vblendmpd %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq

  %y = load <4 x double>, <4 x double>* %yp, align 4
  %mask = fcmp ogt <4 x double> %y, %x
  %max = select <4 x i1> %mask, <4 x double> %x, <4 x double> %x1
  ret <4 x double> %max
}

define <8 x double> @test33(<8 x double> %x, <8 x double> %x1, <8 x double>* %yp) nounwind {
; CHECK-LABEL: test33:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcmpltpd (%rdi), %zmm0, %k1
; CHECK-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <8 x double>, <8 x double>* %yp, align 4
  %mask = fcmp olt <8 x double> %x, %y
  %max = select <8 x i1> %mask, <8 x double> %x, <8 x double> %x1
  ret <8 x double> %max
}

define <4 x float> @test34(<4 x float> %x, <4 x float> %x1, <4 x float>* %yp) nounwind {
; AVX512-LABEL: test34:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 def %zmm0
; AVX512-NEXT:    vmovups (%rdi), %xmm2
; AVX512-NEXT:    vcmpltps %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; SKX-LABEL: test34:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltps (%rdi), %xmm0, %k1
; SKX-NEXT:    vblendmps %xmm0, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
  %y = load <4 x float>, <4 x float>* %yp, align 4
  %mask = fcmp olt <4 x float> %x, %y
  %max = select <4 x i1> %mask, <4 x float> %x, <4 x float> %x1
  ret <4 x float> %max
}

define <8 x float> @test35(<8 x float> %x, <8 x float> %x1, <8 x float>* %yp) nounwind {
; AVX512-LABEL: test35:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 def %zmm0
; AVX512-NEXT:    vmovups (%rdi), %ymm2
; AVX512-NEXT:    vcmpltps %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test35:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltps (%rdi), %ymm0, %k1
; SKX-NEXT:    vblendmps %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq

  %y = load <8 x float>, <8 x float>* %yp, align 4
  %mask = fcmp ogt <8 x float> %y, %x
  %max = select <8 x i1> %mask, <8 x float> %x, <8 x float> %x1
  ret <8 x float> %max
}

define <16 x float> @test36(<16 x float> %x, <16 x float> %x1, <16 x float>* %yp) nounwind {
; CHECK-LABEL: test36:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcmpltps (%rdi), %zmm0, %k1
; CHECK-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x float>, <16 x float>* %yp, align 4
  %mask = fcmp olt <16 x float> %x, %y
  %max = select <16 x i1> %mask, <16 x float> %x, <16 x float> %x1
  ret <16 x float> %max
}

define <8 x double> @test37(<8 x double> %x, <8 x double> %x1, double* %ptr) nounwind {
; CHECK-LABEL: test37:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcmpltpd (%rdi){1to8}, %zmm0, %k1
; CHECK-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq

  %a = load double, double* %ptr
  %v = insertelement <8 x double> undef, double %a, i32 0
  %shuffle = shufflevector <8 x double> %v, <8 x double> undef, <8 x i32> zeroinitializer

  %mask = fcmp ogt <8 x double> %shuffle, %x
  %max = select <8 x i1> %mask, <8 x double> %x, <8 x double> %x1
  ret <8 x double> %max
}

define <4 x double> @test38(<4 x double> %x, <4 x double> %x1, double* %ptr) nounwind {
; AVX512-LABEL: test38:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 def %zmm0
; AVX512-NEXT:    vbroadcastsd (%rdi), %ymm2
; AVX512-NEXT:    vcmpltpd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test38:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltpd (%rdi){1to4}, %ymm0, %k1
; SKX-NEXT:    vblendmpd %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq

  %a = load double, double* %ptr
  %v = insertelement <4 x double> undef, double %a, i32 0
  %shuffle = shufflevector <4 x double> %v, <4 x double> undef, <4 x i32> zeroinitializer

  %mask = fcmp ogt <4 x double> %shuffle, %x
  %max = select <4 x i1> %mask, <4 x double> %x, <4 x double> %x1
  ret <4 x double> %max
}

define <2 x double> @test39(<2 x double> %x, <2 x double> %x1, double* %ptr) nounwind {
; AVX512-LABEL: test39:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 def %zmm0
; AVX512-NEXT:    vmovddup {{.*#+}} xmm2 = mem[0,0]
; AVX512-NEXT:    vcmpltpd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; SKX-LABEL: test39:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltpd (%rdi){1to2}, %xmm0, %k1
; SKX-NEXT:    vblendmpd %xmm0, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq

  %a = load double, double* %ptr
  %v = insertelement <2 x double> undef, double %a, i32 0
  %shuffle = shufflevector <2 x double> %v, <2 x double> undef, <2 x i32> <i32 0, i32 0>

  %mask = fcmp ogt <2 x double> %shuffle, %x
  %max = select <2 x i1> %mask, <2 x double> %x, <2 x double> %x1
  ret <2 x double> %max
}


define <16  x float> @test40(<16  x float> %x, <16  x float> %x1, float* %ptr) nounwind {
; CHECK-LABEL: test40:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcmpltps (%rdi){1to16}, %zmm0, %k1
; CHECK-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; CHECK-NEXT:    retq

  %a = load float, float* %ptr
  %v = insertelement <16  x float> undef, float %a, i32 0
  %shuffle = shufflevector <16  x float> %v, <16  x float> undef, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>

  %mask = fcmp ogt <16  x float> %shuffle, %x
  %max = select <16 x i1> %mask, <16  x float> %x, <16  x float> %x1
  ret <16  x float> %max
}

define <8  x float> @test41(<8  x float> %x, <8  x float> %x1, float* %ptr) nounwind {
; AVX512-LABEL: test41:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 def %zmm0
; AVX512-NEXT:    vbroadcastss (%rdi), %ymm2
; AVX512-NEXT:    vcmpltps %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test41:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltps (%rdi){1to8}, %ymm0, %k1
; SKX-NEXT:    vblendmps %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq

  %a = load float, float* %ptr
  %v = insertelement <8  x float> undef, float %a, i32 0
  %shuffle = shufflevector <8  x float> %v, <8  x float> undef, <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>

  %mask = fcmp ogt <8  x float> %shuffle, %x
  %max = select <8 x i1> %mask, <8  x float> %x, <8  x float> %x1
  ret <8  x float> %max
}

define <4  x float> @test42(<4  x float> %x, <4  x float> %x1, float* %ptr) nounwind {
; AVX512-LABEL: test42:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 def %zmm0
; AVX512-NEXT:    vbroadcastss (%rdi), %xmm2
; AVX512-NEXT:    vcmpltps %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; SKX-LABEL: test42:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpltps (%rdi){1to4}, %xmm0, %k1
; SKX-NEXT:    vblendmps %xmm0, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq

  %a = load float, float* %ptr
  %v = insertelement <4  x float> undef, float %a, i32 0
  %shuffle = shufflevector <4  x float> %v, <4  x float> undef, <4 x i32> <i32 0, i32 0, i32 0, i32 0>

  %mask = fcmp ogt <4  x float> %shuffle, %x
  %max = select <4 x i1> %mask, <4  x float> %x, <4  x float> %x1
  ret <4  x float> %max
}

define <8 x double> @test43(<8 x double> %x, <8 x double> %x1, double* %ptr,<8 x i1> %mask_in) nounwind {
; KNL-LABEL: test43:
; KNL:       ## %bb.0:
; KNL-NEXT:    vpmovsxwq %xmm2, %zmm2
; KNL-NEXT:    vpsllq $63, %zmm2, %zmm2
; KNL-NEXT:    vptestmq %zmm2, %zmm2, %k1
; KNL-NEXT:    vcmpltpd (%rdi){1to8}, %zmm0, %k1 {%k1}
; KNL-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test43:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpsllw $15, %xmm2, %xmm2
; AVX512BW-NEXT:    vpmovw2m %zmm2, %k1
; AVX512BW-NEXT:    vcmpltpd (%rdi){1to8}, %zmm0, %k1 {%k1}
; AVX512BW-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test43:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpsllw $15, %xmm2, %xmm2
; SKX-NEXT:    vpmovw2m %xmm2, %k1
; SKX-NEXT:    vcmpltpd (%rdi){1to8}, %zmm0, %k1 {%k1}
; SKX-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; SKX-NEXT:    retq

  %a = load double, double* %ptr
  %v = insertelement <8 x double> undef, double %a, i32 0
  %shuffle = shufflevector <8 x double> %v, <8 x double> undef, <8 x i32> zeroinitializer

  %mask_cmp = fcmp ogt <8 x double> %shuffle, %x
  %mask = and <8 x i1> %mask_cmp, %mask_in
  %max = select <8 x i1> %mask, <8 x double> %x, <8 x double> %x1
  ret <8 x double> %max
}

define <4 x i32> @test44(<4 x i16> %x, <4 x i16> %y) #0 {
; CHECK-LABEL: test44:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3],xmm1[4],xmm2[5],xmm1[6],xmm2[7]
; CHECK-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2],xmm2[3],xmm0[4],xmm2[5],xmm0[6],xmm2[7]
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %mask = icmp eq <4 x i16> %x, %y
  %1 = sext <4 x i1> %mask to <4 x i32>
  ret <4 x i32> %1
}

define <2 x i64> @test45(<2 x i16> %x, <2 x i16> %y) #0 {
; AVX512-LABEL: test45:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3],xmm1[4],xmm2[5,6,7]
; AVX512-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3],xmm0[4],xmm2[5,6,7]
; AVX512-NEXT:    vpcmpeqq %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vpsrlq $63, %xmm0, %xmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test45:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; SKX-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3],xmm1[4],xmm2[5,6,7]
; SKX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3],xmm0[4],xmm2[5,6,7]
; SKX-NEXT:    vpcmpeqq %xmm1, %xmm0, %k1
; SKX-NEXT:    vmovdqa64 {{.*}}(%rip), %xmm0 {%k1} {z}
; SKX-NEXT:    retq
  %mask = icmp eq <2 x i16> %x, %y
  %1 = zext <2 x i1> %mask to <2 x i64>
  ret <2 x i64> %1
}

define <2 x i64> @test46(<2 x float> %x, <2 x float> %y) #0 {
; AVX512-LABEL: test46:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vcmpeqps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vpmovsxdq %xmm0, %xmm0
; AVX512-NEXT:    vpsrlq $63, %xmm0, %xmm0
; AVX512-NEXT:    retq
;
; SKX-LABEL: test46:
; SKX:       ## %bb.0:
; SKX-NEXT:    vcmpeqps %xmm1, %xmm0, %k1
; SKX-NEXT:    vmovdqa64 {{.*}}(%rip), %xmm0 {%k1} {z}
; SKX-NEXT:    retq
  %mask = fcmp oeq <2 x float> %x, %y
  %1 = zext <2 x i1> %mask to <2 x i64>
  ret <2 x i64> %1
}

define <16 x i8> @test47(<16 x i32> %a, <16 x i8> %b, <16 x i8> %c) {
; KNL-LABEL: test47:
; KNL:       ## %bb.0:
; KNL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; KNL-NEXT:    vpcmpeqd %zmm3, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vpmovdb %zmm0, %xmm0
; KNL-NEXT:    vpblendvb %xmm0, %xmm1, %xmm2, %xmm0
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test47:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    ## kill: def %xmm2 killed %xmm2 def %zmm2
; AVX512BW-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512BW-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512BW-NEXT:    vpcmpeqd %zmm3, %zmm0, %k1
; AVX512BW-NEXT:    vpblendmb %zmm1, %zmm2, %zmm0 {%k1}
; AVX512BW-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test47:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; SKX-NEXT:    vpcmpeqd %zmm3, %zmm0, %k1
; SKX-NEXT:    vpblendmb %xmm1, %xmm2, %xmm0 {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %cmp = icmp eq <16 x i32> %a, zeroinitializer
  %res = select <16 x i1> %cmp, <16 x i8> %b, <16 x i8> %c
  ret <16 x i8> %res
}

define <16 x i16> @test48(<16 x i32> %a, <16 x i16> %b, <16 x i16> %c) {
; KNL-LABEL: test48:
; KNL:       ## %bb.0:
; KNL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; KNL-NEXT:    vpcmpeqd %zmm3, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-NEXT:    vpblendvb %ymm0, %ymm1, %ymm2, %ymm0
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test48:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    ## kill: def %ymm2 killed %ymm2 def %zmm2
; AVX512BW-NEXT:    ## kill: def %ymm1 killed %ymm1 def %zmm1
; AVX512BW-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512BW-NEXT:    vpcmpeqd %zmm3, %zmm0, %k1
; AVX512BW-NEXT:    vpblendmw %zmm1, %zmm2, %zmm0 {%k1}
; AVX512BW-NEXT:    ## kill: def %ymm0 killed %ymm0 killed %zmm0
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test48:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; SKX-NEXT:    vpcmpeqd %zmm3, %zmm0, %k1
; SKX-NEXT:    vpblendmw %ymm1, %ymm2, %ymm0 {%k1}
; SKX-NEXT:    retq
  %cmp = icmp eq <16 x i32> %a, zeroinitializer
  %res = select <16 x i1> %cmp, <16 x i16> %b, <16 x i16> %c
  ret <16 x i16> %res
}

define <8 x i16> @test49(<8 x i64> %a, <8 x i16> %b, <8 x i16> %c) {
; KNL-LABEL: test49:
; KNL:       ## %bb.0:
; KNL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; KNL-NEXT:    vpcmpeqq %zmm3, %zmm0, %k1
; KNL-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-NEXT:    vpblendvb %xmm0, %xmm1, %xmm2, %xmm0
; KNL-NEXT:    vzeroupper
; KNL-NEXT:    retq
;
; AVX512BW-LABEL: test49:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    ## kill: def %xmm2 killed %xmm2 def %zmm2
; AVX512BW-NEXT:    ## kill: def %xmm1 killed %xmm1 def %zmm1
; AVX512BW-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512BW-NEXT:    vpcmpeqq %zmm3, %zmm0, %k1
; AVX512BW-NEXT:    vpblendmw %zmm1, %zmm2, %zmm0 {%k1}
; AVX512BW-NEXT:    ## kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; SKX-LABEL: test49:
; SKX:       ## %bb.0:
; SKX-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; SKX-NEXT:    vpcmpeqq %zmm3, %zmm0, %k1
; SKX-NEXT:    vpblendmw %xmm1, %xmm2, %xmm0 {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  %cmp = icmp eq <8 x i64> %a, zeroinitializer
  %res = select <8 x i1> %cmp, <8 x i16> %b, <8 x i16> %c
  ret <8 x i16> %res
}
