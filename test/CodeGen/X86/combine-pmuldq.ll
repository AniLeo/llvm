; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=AVX --check-prefix=AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+avx512dq | FileCheck %s --check-prefix=AVX --check-prefix=AVX512DQVL

define <2 x i64> @combine_shuffle_sext_pmuldq(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: combine_shuffle_sext_pmuldq:
; SSE:       # %bb.0:
; SSE-NEXT:    pmuldq %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_shuffle_sext_pmuldq:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmuldq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shufflevector <4 x i32> %a0, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %3 = sext <2 x i32> %1 to <2 x i64>
  %4 = sext <2 x i32> %2 to <2 x i64>
  %5 = mul nuw <2 x i64> %3, %4
  ret <2 x i64> %5
}

define <2 x i64> @combine_shuffle_zext_pmuludq(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: combine_shuffle_zext_pmuludq:
; SSE:       # %bb.0:
; SSE-NEXT:    pmuludq %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_shuffle_zext_pmuludq:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shufflevector <4 x i32> %a0, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %3 = zext <2 x i32> %1 to <2 x i64>
  %4 = zext <2 x i32> %2 to <2 x i64>
  %5 = mul nuw <2 x i64> %3, %4
  ret <2 x i64> %5
}

define <2 x i64> @combine_shuffle_zero_pmuludq(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: combine_shuffle_zero_pmuludq:
; SSE:       # %bb.0:
; SSE-NEXT:    pmuludq %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_shuffle_zero_pmuludq:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shufflevector <4 x i32> %a0, <4 x i32> zeroinitializer, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> zeroinitializer, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %3 = bitcast <4 x i32> %1 to <2 x i64>
  %4 = bitcast <4 x i32> %2 to <2 x i64>
  %5 = mul <2 x i64> %3, %4
  ret <2 x i64> %5
}

define <4 x i64> @combine_shuffle_zero_pmuludq_256(<8 x i32> %a0, <8 x i32> %a1) {
; SSE-LABEL: combine_shuffle_zero_pmuludq_256:
; SSE:       # %bb.0:
; SSE-NEXT:    pmuludq %xmm2, %xmm0
; SSE-NEXT:    pmuludq %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX2-LABEL: combine_shuffle_zero_pmuludq_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmuludq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512VL-LABEL: combine_shuffle_zero_pmuludq_256:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpmuludq %ymm1, %ymm0, %ymm0
; AVX512VL-NEXT:    retq
;
; AVX512DQVL-LABEL: combine_shuffle_zero_pmuludq_256:
; AVX512DQVL:       # %bb.0:
; AVX512DQVL-NEXT:    vpmuludq %ymm1, %ymm0, %ymm0
; AVX512DQVL-NEXT:    retq
  %1 = shufflevector <8 x i32> %a0, <8 x i32> zeroinitializer, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 4, i32 13, i32 6, i32 15>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> zeroinitializer, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 4, i32 13, i32 6, i32 15>
  %3 = bitcast <8 x i32> %1 to <4 x i64>
  %4 = bitcast <8 x i32> %2 to <4 x i64>
  %5 = mul <4 x i64> %3, %4
  ret <4 x i64> %5
}

define <8 x i64> @combine_zext_pmuludq_256(<8 x i32> %a) {
; SSE-LABEL: combine_zext_pmuludq_256:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[2,1,3,3]
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,1,3,3]
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [715827883,715827883]
; SSE-NEXT:    pmuludq %xmm4, %xmm0
; SSE-NEXT:    pmuludq %xmm4, %xmm1
; SSE-NEXT:    pmuludq %xmm4, %xmm2
; SSE-NEXT:    pmuludq %xmm4, %xmm3
; SSE-NEXT:    retq
;
; AVX2-LABEL: combine_zext_pmuludq_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpmovzxdq {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
; AVX2-NEXT:    vpmovzxdq {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; AVX2-NEXT:    vpbroadcastq {{.*#+}} ymm2 = [715827883,715827883,715827883,715827883]
; AVX2-NEXT:    vpmuludq %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpmuludq %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512VL-LABEL: combine_zext_pmuludq_256:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpmovzxdq {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
; AVX512VL-NEXT:    vpmuludq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; AVX512VL-NEXT:    retq
;
; AVX512DQVL-LABEL: combine_zext_pmuludq_256:
; AVX512DQVL:       # %bb.0:
; AVX512DQVL-NEXT:    vpmovzxdq {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
; AVX512DQVL-NEXT:    vpmuludq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; AVX512DQVL-NEXT:    retq
  %1 = zext <8 x i32> %a to <8 x i64>
  %2 = mul nuw nsw <8 x i64> %1, <i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883>
  ret <8 x i64> %2
}

define void @PR39398(i32 %a0) {
; SSE-LABEL: PR39398:
; SSE:       # %bb.0: # %bb
; SSE-NEXT:    .p2align 4, 0x90
; SSE-NEXT:  .LBB5_1: # %bb10
; SSE-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE-NEXT:    cmpl $232, %edi
; SSE-NEXT:    jne .LBB5_1
; SSE-NEXT:  # %bb.2: # %bb34
; SSE-NEXT:    retq
;
; AVX-LABEL: PR39398:
; AVX:       # %bb.0: # %bb
; AVX-NEXT:    .p2align 4, 0x90
; AVX-NEXT:  .LBB5_1: # %bb10
; AVX-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX-NEXT:    cmpl $232, %edi
; AVX-NEXT:    jne .LBB5_1
; AVX-NEXT:  # %bb.2: # %bb34
; AVX-NEXT:    retq
bb:
  %tmp9 = shufflevector <4 x i64> undef, <4 x i64> undef, <4 x i32> zeroinitializer
  br label %bb10

bb10:                                             ; preds = %bb10, %bb
  %tmp12 = phi <4 x i32> [ <i32 9, i32 8, i32 7, i32 6>, %bb ], [ zeroinitializer, %bb10 ]
  %tmp16 = add <4 x i32> %tmp12, <i32 -4, i32 -4, i32 -4, i32 -4>
  %tmp18 = zext <4 x i32> %tmp12 to <4 x i64>
  %tmp19 = zext <4 x i32> %tmp16 to <4 x i64>
  %tmp20 = xor <4 x i64> %tmp18, <i64 -1, i64 -1, i64 -1, i64 -1>
  %tmp21 = xor <4 x i64> %tmp19, <i64 -1, i64 -1, i64 -1, i64 -1>
  %tmp24 = mul <4 x i64> %tmp9, %tmp20
  %tmp25 = mul <4 x i64> %tmp9, %tmp21
  %tmp26 = select <4 x i1> undef, <4 x i64> zeroinitializer, <4 x i64> %tmp24
  %tmp27 = select <4 x i1> undef, <4 x i64> zeroinitializer, <4 x i64> %tmp25
  %tmp28 = add <4 x i64> zeroinitializer, %tmp26
  %tmp29 = add <4 x i64> zeroinitializer, %tmp27
  %tmp33 = icmp eq i32 %a0, 232
  br i1 %tmp33, label %bb34, label %bb10

bb34:                                             ; preds = %bb10
  %tmp35 = add <4 x i64> %tmp29, %tmp28
  ret void
}

define i32 @PR43159(<4 x i32>* %a0) {
; SSE-LABEL: PR43159:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [1645975491,344322273,2164392969,1916962805]
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE-NEXT:    pmuludq %xmm2, %xmm3
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrld $1, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm0[0,1,2,3],xmm2[4,5],xmm0[6,7]
; SSE-NEXT:    pmuludq %xmm1, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[1,1,3,3]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE-NEXT:    psubd %xmm3, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE-NEXT:    pmuludq {{.*}}(%rip), %xmm0
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm0[2,3],xmm2[4,5],xmm0[6,7]
; SSE-NEXT:    paddd %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm0
; SSE-NEXT:    psrld $7, %xmm0
; SSE-NEXT:    psrld $6, %xmm2
; SSE-NEXT:    movd %xmm2, %edi
; SSE-NEXT:    pextrd $1, %xmm0, %esi
; SSE-NEXT:    pextrd $2, %xmm2, %edx
; SSE-NEXT:    pextrd $3, %xmm0, %ecx
; SSE-NEXT:    jmp foo # TAILCALL
;
; AVX2-LABEL: PR43159:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm1 = [1645975491,344322273,2164392969,1916962805]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm3
; AVX2-NEXT:    vpshufd {{.*#+}} xmm4 = xmm3[1,1,3,3]
; AVX2-NEXT:    vpmuludq %xmm2, %xmm4, %xmm2
; AVX2-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX2-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; AVX2-NEXT:    vpmuludq %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm2[0],xmm0[1],xmm2[2],xmm0[3]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %edi
; AVX2-NEXT:    vpextrd $1, %xmm0, %esi
; AVX2-NEXT:    vpextrd $2, %xmm0, %edx
; AVX2-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX2-NEXT:    jmp foo # TAILCALL
;
; AVX512VL-LABEL: PR43159:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm1 = [1645975491,344322273,2164392969,1916962805]
; AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX512VL-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm3
; AVX512VL-NEXT:    vpshufd {{.*#+}} xmm4 = xmm3[1,1,3,3]
; AVX512VL-NEXT:    vpmuludq %xmm2, %xmm4, %xmm2
; AVX512VL-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX512VL-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; AVX512VL-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; AVX512VL-NEXT:    vpmuludq %xmm2, %xmm0, %xmm0
; AVX512VL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm2[0],xmm0[1],xmm2[2],xmm0[3]
; AVX512VL-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX512VL-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm0
; AVX512VL-NEXT:    vmovd %xmm0, %edi
; AVX512VL-NEXT:    vpextrd $1, %xmm0, %esi
; AVX512VL-NEXT:    vpextrd $2, %xmm0, %edx
; AVX512VL-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX512VL-NEXT:    jmp foo # TAILCALL
;
; AVX512DQVL-LABEL: PR43159:
; AVX512DQVL:       # %bb.0: # %entry
; AVX512DQVL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512DQVL-NEXT:    vmovdqa {{.*#+}} xmm1 = [1645975491,344322273,2164392969,1916962805]
; AVX512DQVL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX512DQVL-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm3
; AVX512DQVL-NEXT:    vpshufd {{.*#+}} xmm4 = xmm3[1,1,3,3]
; AVX512DQVL-NEXT:    vpmuludq %xmm2, %xmm4, %xmm2
; AVX512DQVL-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; AVX512DQVL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX512DQVL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX512DQVL-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; AVX512DQVL-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX512DQVL-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; AVX512DQVL-NEXT:    vpmuludq %xmm2, %xmm0, %xmm0
; AVX512DQVL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512DQVL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm2[0],xmm0[1],xmm2[2],xmm0[3]
; AVX512DQVL-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX512DQVL-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm0
; AVX512DQVL-NEXT:    vmovd %xmm0, %edi
; AVX512DQVL-NEXT:    vpextrd $1, %xmm0, %esi
; AVX512DQVL-NEXT:    vpextrd $2, %xmm0, %edx
; AVX512DQVL-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX512DQVL-NEXT:    jmp foo # TAILCALL
entry:
  %0 = load <4 x i32>, <4 x i32>* %a0, align 16
  %div = udiv <4 x i32> %0, <i32 167, i32 237, i32 254, i32 177>
  %ext0 = extractelement <4 x i32> %div, i32 0
  %ext1 = extractelement <4 x i32> %div, i32 1
  %ext2 = extractelement <4 x i32> %div, i32 2
  %ext3 = extractelement <4 x i32> %div, i32 3
  %call = tail call i32 @foo(i32 %ext0, i32 %ext1, i32 %ext2, i32 %ext3)
  ret i32 %call
}
declare dso_local i32 @foo(i32, i32, i32, i32)

define <8 x i32> @PR49658_zext(i32* %ptr, i32 %mul) {
; SSE-LABEL: PR49658_zext:
; SSE:       # %bb.0: # %start
; SSE-NEXT:    movl %esi, %eax
; SSE-NEXT:    movq %rax, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[0,1,0,1]
; SSE-NEXT:    pxor %xmm0, %xmm0
; SSE-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    .p2align 4, 0x90
; SSE-NEXT:  .LBB7_1: # %loop
; SSE-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm3 = mem[0],zero,mem[1],zero
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm4 = mem[0],zero,mem[1],zero
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm5 = mem[0],zero,mem[1],zero
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm6 = mem[0],zero,mem[1],zero
; SSE-NEXT:    pmuludq %xmm2, %xmm6
; SSE-NEXT:    pmuludq %xmm2, %xmm5
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[1,3],xmm6[1,3]
; SSE-NEXT:    paddd %xmm5, %xmm0
; SSE-NEXT:    pmuludq %xmm2, %xmm4
; SSE-NEXT:    pmuludq %xmm2, %xmm3
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[1,3],xmm3[1,3]
; SSE-NEXT:    paddd %xmm4, %xmm1
; SSE-NEXT:    subq $-128, %rax
; SSE-NEXT:    jne .LBB7_1
; SSE-NEXT:  # %bb.2: # %end
; SSE-NEXT:    retq
;
; AVX2-LABEL: PR49658_zext:
; AVX2:       # %bb.0: # %start
; AVX2-NEXT:    movl %esi, %eax
; AVX2-NEXT:    vmovq %rax, %xmm0
; AVX2-NEXT:    vpbroadcastq %xmm0, %ymm1
; AVX2-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB7_1: # %loop
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovzxdq {{.*#+}} ymm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
; AVX2-NEXT:    vpmovzxdq {{.*#+}} ymm3 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
; AVX2-NEXT:    vpmuludq %ymm3, %ymm1, %ymm3
; AVX2-NEXT:    vpmuludq %ymm2, %ymm1, %ymm2
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm4 = ymm3[2,3],ymm2[2,3]
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm3, %ymm2
; AVX2-NEXT:    vshufps {{.*#+}} ymm2 = ymm2[1,3],ymm4[1,3],ymm2[5,7],ymm4[5,7]
; AVX2-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    subq $-128, %rax
; AVX2-NEXT:    jne .LBB7_1
; AVX2-NEXT:  # %bb.2: # %end
; AVX2-NEXT:    retq
;
; AVX512VL-LABEL: PR49658_zext:
; AVX512VL:       # %bb.0: # %start
; AVX512VL-NEXT:    movl %esi, %eax
; AVX512VL-NEXT:    vpbroadcastq %rax, %zmm1
; AVX512VL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512VL-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; AVX512VL-NEXT:    .p2align 4, 0x90
; AVX512VL-NEXT:  .LBB7_1: # %loop
; AVX512VL-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512VL-NEXT:    vpmovzxdq {{.*#+}} zmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512VL-NEXT:    vpmuludq %zmm2, %zmm1, %zmm2
; AVX512VL-NEXT:    vpsrlq $32, %zmm2, %zmm2
; AVX512VL-NEXT:    vpmovqd %zmm2, %ymm2
; AVX512VL-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; AVX512VL-NEXT:    subq $-128, %rax
; AVX512VL-NEXT:    jne .LBB7_1
; AVX512VL-NEXT:  # %bb.2: # %end
; AVX512VL-NEXT:    retq
;
; AVX512DQVL-LABEL: PR49658_zext:
; AVX512DQVL:       # %bb.0: # %start
; AVX512DQVL-NEXT:    movl %esi, %eax
; AVX512DQVL-NEXT:    vpbroadcastq %rax, %zmm1
; AVX512DQVL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512DQVL-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; AVX512DQVL-NEXT:    .p2align 4, 0x90
; AVX512DQVL-NEXT:  .LBB7_1: # %loop
; AVX512DQVL-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512DQVL-NEXT:    vpmovzxdq {{.*#+}} zmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512DQVL-NEXT:    vpmuludq %zmm2, %zmm1, %zmm2
; AVX512DQVL-NEXT:    vpsrlq $32, %zmm2, %zmm2
; AVX512DQVL-NEXT:    vpmovqd %zmm2, %ymm2
; AVX512DQVL-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; AVX512DQVL-NEXT:    subq $-128, %rax
; AVX512DQVL-NEXT:    jne .LBB7_1
; AVX512DQVL-NEXT:  # %bb.2: # %end
; AVX512DQVL-NEXT:    retq
start:
  %t1 = zext i32 %mul to i64
  %t2 = insertelement <8 x i64> undef, i64 %t1, i32 0
  %mulvec = shufflevector <8 x i64> %t2, <8 x i64> undef, <8 x i32> zeroinitializer
  br label %loop
loop:
  %loopcnt = phi i64 [ 0, %start ], [ %nextcnt, %loop ]
  %sum = phi <8 x i32> [ zeroinitializer, %start ], [ %nextsum, %loop ]
  %ptroff = getelementptr inbounds i32, i32* %ptr, i64 %loopcnt
  %vptroff = bitcast i32* %ptroff to <8 x i32>*
  %v = load <8 x i32>, <8 x i32>* %vptroff, align 4
  %v64 = zext <8 x i32> %v to <8 x i64>
  %vmul = mul nuw <8 x i64> %mulvec, %v64
  %vmulhi = lshr <8 x i64> %vmul, <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
  %vtrunc = trunc <8 x i64> %vmulhi to <8 x i32>
  %nextsum = add <8 x i32> %vtrunc, %sum
  %nextcnt = add i64 %loopcnt, 32
  %isdone = icmp eq i64 %nextcnt, 524288
  br i1 %isdone, label %end, label %loop
end:
  ret <8 x i32> %nextsum
}

define <8 x i32> @PR49658_sext(i32* %ptr, i32 %mul) {
; SSE-LABEL: PR49658_sext:
; SSE:       # %bb.0: # %start
; SSE-NEXT:    movslq %esi, %rax
; SSE-NEXT:    movq %rax, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm9 = xmm0[0,1,0,1]
; SSE-NEXT:    pxor %xmm0, %xmm0
; SSE-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; SSE-NEXT:    movdqa %xmm9, %xmm8
; SSE-NEXT:    psrlq $32, %xmm8
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    .p2align 4, 0x90
; SSE-NEXT:  .LBB8_1: # %loop
; SSE-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE-NEXT:    pmovsxdq 2097176(%rdi,%rax), %xmm5
; SSE-NEXT:    pmovsxdq 2097168(%rdi,%rax), %xmm4
; SSE-NEXT:    pmovsxdq 2097152(%rdi,%rax), %xmm6
; SSE-NEXT:    pmovsxdq 2097160(%rdi,%rax), %xmm7
; SSE-NEXT:    movdqa %xmm8, %xmm3
; SSE-NEXT:    pmuludq %xmm7, %xmm3
; SSE-NEXT:    movdqa %xmm9, %xmm2
; SSE-NEXT:    pmuludq %xmm7, %xmm2
; SSE-NEXT:    psrlq $32, %xmm7
; SSE-NEXT:    pmuludq %xmm9, %xmm7
; SSE-NEXT:    paddq %xmm3, %xmm7
; SSE-NEXT:    psllq $32, %xmm7
; SSE-NEXT:    paddq %xmm2, %xmm7
; SSE-NEXT:    movdqa %xmm8, %xmm2
; SSE-NEXT:    pmuludq %xmm6, %xmm2
; SSE-NEXT:    movdqa %xmm9, %xmm3
; SSE-NEXT:    pmuludq %xmm6, %xmm3
; SSE-NEXT:    psrlq $32, %xmm6
; SSE-NEXT:    pmuludq %xmm9, %xmm6
; SSE-NEXT:    paddq %xmm2, %xmm6
; SSE-NEXT:    psllq $32, %xmm6
; SSE-NEXT:    paddq %xmm3, %xmm6
; SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[1,3],xmm7[1,3]
; SSE-NEXT:    paddd %xmm6, %xmm0
; SSE-NEXT:    movdqa %xmm4, %xmm2
; SSE-NEXT:    psrlq $32, %xmm2
; SSE-NEXT:    pmuludq %xmm9, %xmm2
; SSE-NEXT:    movdqa %xmm8, %xmm3
; SSE-NEXT:    pmuludq %xmm4, %xmm3
; SSE-NEXT:    paddq %xmm2, %xmm3
; SSE-NEXT:    psllq $32, %xmm3
; SSE-NEXT:    pmuludq %xmm9, %xmm4
; SSE-NEXT:    paddq %xmm3, %xmm4
; SSE-NEXT:    movdqa %xmm5, %xmm2
; SSE-NEXT:    psrlq $32, %xmm2
; SSE-NEXT:    pmuludq %xmm9, %xmm2
; SSE-NEXT:    movdqa %xmm8, %xmm3
; SSE-NEXT:    pmuludq %xmm5, %xmm3
; SSE-NEXT:    paddq %xmm2, %xmm3
; SSE-NEXT:    psllq $32, %xmm3
; SSE-NEXT:    pmuludq %xmm9, %xmm5
; SSE-NEXT:    paddq %xmm3, %xmm5
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[1,3],xmm5[1,3]
; SSE-NEXT:    paddd %xmm4, %xmm1
; SSE-NEXT:    subq $-128, %rax
; SSE-NEXT:    jne .LBB8_1
; SSE-NEXT:  # %bb.2: # %end
; SSE-NEXT:    retq
;
; AVX2-LABEL: PR49658_sext:
; AVX2:       # %bb.0: # %start
; AVX2-NEXT:    movslq %esi, %rax
; AVX2-NEXT:    vmovq %rax, %xmm0
; AVX2-NEXT:    vpbroadcastq %xmm0, %ymm1
; AVX2-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; AVX2-NEXT:    vpsrlq $32, %ymm1, %ymm2
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB8_1: # %loop
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovsxdq 2097168(%rdi,%rax), %ymm3
; AVX2-NEXT:    vpmovsxdq 2097152(%rdi,%rax), %ymm4
; AVX2-NEXT:    vpmuludq %ymm4, %ymm2, %ymm5
; AVX2-NEXT:    vpsrlq $32, %ymm4, %ymm6
; AVX2-NEXT:    vpmuludq %ymm6, %ymm1, %ymm6
; AVX2-NEXT:    vpaddq %ymm5, %ymm6, %ymm5
; AVX2-NEXT:    vpsllq $32, %ymm5, %ymm5
; AVX2-NEXT:    vpmuludq %ymm4, %ymm1, %ymm4
; AVX2-NEXT:    vpaddq %ymm5, %ymm4, %ymm4
; AVX2-NEXT:    vpmuludq %ymm3, %ymm2, %ymm5
; AVX2-NEXT:    vpsrlq $32, %ymm3, %ymm6
; AVX2-NEXT:    vpmuludq %ymm6, %ymm1, %ymm6
; AVX2-NEXT:    vpaddq %ymm5, %ymm6, %ymm5
; AVX2-NEXT:    vpsllq $32, %ymm5, %ymm5
; AVX2-NEXT:    vpmuludq %ymm3, %ymm1, %ymm3
; AVX2-NEXT:    vpaddq %ymm5, %ymm3, %ymm3
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm5 = ymm4[2,3],ymm3[2,3]
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm4, %ymm3
; AVX2-NEXT:    vshufps {{.*#+}} ymm3 = ymm3[1,3],ymm5[1,3],ymm3[5,7],ymm5[5,7]
; AVX2-NEXT:    vpaddd %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    subq $-128, %rax
; AVX2-NEXT:    jne .LBB8_1
; AVX2-NEXT:  # %bb.2: # %end
; AVX2-NEXT:    retq
;
; AVX512VL-LABEL: PR49658_sext:
; AVX512VL:       # %bb.0: # %start
; AVX512VL-NEXT:    movslq %esi, %rax
; AVX512VL-NEXT:    vpbroadcastq %rax, %zmm1
; AVX512VL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512VL-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; AVX512VL-NEXT:    vpsrlq $32, %zmm1, %zmm2
; AVX512VL-NEXT:    .p2align 4, 0x90
; AVX512VL-NEXT:  .LBB8_1: # %loop
; AVX512VL-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512VL-NEXT:    vpmovsxdq 2097152(%rdi,%rax), %zmm3
; AVX512VL-NEXT:    vpmuludq %zmm3, %zmm2, %zmm4
; AVX512VL-NEXT:    vpsrlq $32, %zmm3, %zmm5
; AVX512VL-NEXT:    vpmuludq %zmm5, %zmm1, %zmm5
; AVX512VL-NEXT:    vpaddq %zmm4, %zmm5, %zmm4
; AVX512VL-NEXT:    vpsllq $32, %zmm4, %zmm4
; AVX512VL-NEXT:    vpmuludq %zmm3, %zmm1, %zmm3
; AVX512VL-NEXT:    vpaddq %zmm4, %zmm3, %zmm3
; AVX512VL-NEXT:    vpsrlq $32, %zmm3, %zmm3
; AVX512VL-NEXT:    vpmovqd %zmm3, %ymm3
; AVX512VL-NEXT:    vpaddd %ymm0, %ymm3, %ymm0
; AVX512VL-NEXT:    subq $-128, %rax
; AVX512VL-NEXT:    jne .LBB8_1
; AVX512VL-NEXT:  # %bb.2: # %end
; AVX512VL-NEXT:    retq
;
; AVX512DQVL-LABEL: PR49658_sext:
; AVX512DQVL:       # %bb.0: # %start
; AVX512DQVL-NEXT:    movslq %esi, %rax
; AVX512DQVL-NEXT:    vpbroadcastq %rax, %zmm1
; AVX512DQVL-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512DQVL-NEXT:    movq $-2097152, %rax # imm = 0xFFE00000
; AVX512DQVL-NEXT:    .p2align 4, 0x90
; AVX512DQVL-NEXT:  .LBB8_1: # %loop
; AVX512DQVL-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512DQVL-NEXT:    vpmovsxdq 2097152(%rdi,%rax), %zmm2
; AVX512DQVL-NEXT:    vpmullq %zmm2, %zmm1, %zmm2
; AVX512DQVL-NEXT:    vpsrlq $32, %zmm2, %zmm2
; AVX512DQVL-NEXT:    vpmovqd %zmm2, %ymm2
; AVX512DQVL-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; AVX512DQVL-NEXT:    subq $-128, %rax
; AVX512DQVL-NEXT:    jne .LBB8_1
; AVX512DQVL-NEXT:  # %bb.2: # %end
; AVX512DQVL-NEXT:    retq
start:
	%t1 = sext i32 %mul to i64
	%t2 = insertelement <8 x i64> undef, i64 %t1, i32 0
	%mulvec = shufflevector <8 x i64> %t2, <8 x i64> undef, <8 x i32> zeroinitializer
	br label %loop
loop:
	%loopcnt = phi i64 [ 0, %start ], [ %nextcnt, %loop ]
	%sum = phi <8 x i32> [ zeroinitializer, %start ], [ %nextsum, %loop ]
	%ptroff = getelementptr inbounds i32, i32* %ptr, i64 %loopcnt
	%vptroff = bitcast i32* %ptroff to <8 x i32>*
	%v = load <8 x i32>, <8 x i32>* %vptroff, align 4
	%v64 = sext <8 x i32> %v to <8 x i64>
	%vmul = mul <8 x i64> %mulvec, %v64
	%vmulhi = ashr <8 x i64> %vmul, <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
	%vtrunc = trunc <8 x i64> %vmulhi to <8 x i32>
	%nextsum = add <8 x i32> %vtrunc, %sum
	%nextcnt = add i64 %loopcnt, 32
	%isdone = icmp eq i64 %nextcnt, 524288
	br i1 %isdone, label %end, label %loop
end:
	ret <8 x i32> %nextsum
}
