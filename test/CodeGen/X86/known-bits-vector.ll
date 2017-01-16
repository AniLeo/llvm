; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X64

define i32 @knownbits_mask_extract_sext(<8 x i16> %a0) nounwind {
; X32-LABEL: knownbits_mask_extract_sext:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpextrw $0, %xmm0, %eax
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_extract_sext:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpextrw $0, %xmm0, %eax
; X64-NEXT:    retq
  %1 = and <8 x i16> %a0, <i16 15, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  %2 = extractelement <8 x i16> %1, i32 0
  %3 = sext i16 %2 to i32
  ret i32 %3
}

define float @knownbits_mask_extract_uitofp(<2 x i64> %a0) nounwind {
; X32-LABEL: knownbits_mask_extract_uitofp:
; X32:       # BB#0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-8, %esp
; X32-NEXT:    subl $16, %esp
; X32-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X32-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3],xmm0[4,5,6,7]
; X32-NEXT:    vmovq %xmm0, {{[0-9]+}}(%esp)
; X32-NEXT:    fildll {{[0-9]+}}(%esp)
; X32-NEXT:    fstps {{[0-9]+}}(%esp)
; X32-NEXT:    flds {{[0-9]+}}(%esp)
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_extract_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3],xmm0[4,5,6,7]
; X64-NEXT:    vmovq %xmm0, %rax
; X64-NEXT:    vcvtsi2ssq %rax, %xmm2, %xmm0
; X64-NEXT:    retq
  %1 = and <2 x i64> %a0, <i64 65535, i64 -1>
  %2 = extractelement <2 x i64> %1, i32 0
  %3 = uitofp i64 %2 to float
  ret float %3
}

define <4 x float> @knownbits_insert_uitofp(<4 x i32> %a0, i16 %a1, i16 %a2) nounwind {
; X32-LABEL: knownbits_insert_uitofp:
; X32:       # BB#0:
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vpinsrd $0, %eax, %xmm0, %xmm0
; X32-NEXT:    vpinsrd $2, %ecx, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,2,2]
; X32-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_insert_uitofp:
; X64:       # BB#0:
; X64-NEXT:    movzwl %di, %eax
; X64-NEXT:    movzwl %si, %ecx
; X64-NEXT:    vpinsrd $0, %eax, %xmm0, %xmm0
; X64-NEXT:    vpinsrd $2, %ecx, %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,2,2]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = zext i16 %a1 to i32
  %2 = zext i16 %a2 to i32
  %3 = insertelement <4 x i32> %a0, i32 %1, i32 0
  %4 = insertelement <4 x i32>  %3, i32 %2, i32 2
  %5 = shufflevector <4 x i32> %4, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
  %6 = uitofp <4 x i32> %5 to <4 x float>
  ret <4 x float> %6
}

define <4 x i32> @knownbits_mask_shuffle_sext(<8 x i16> %a0) nounwind {
; X32-LABEL: knownbits_mask_shuffle_sext:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X32-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_shuffle_sext:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; X64-NEXT:    retq
  %1 = and <8 x i16> %a0, <i16 -1, i16 -1, i16 -1, i16 -1, i16 15, i16 15, i16 15, i16 15>
  %2 = shufflevector <8 x i16> %1, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %3 = sext <4 x i16> %2 to <4 x i32>
  ret <4 x i32> %3
}

define <4 x i32> @knownbits_mask_shuffle_shuffle_sext(<8 x i16> %a0) nounwind {
; X32-LABEL: knownbits_mask_shuffle_shuffle_sext:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X32-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_shuffle_shuffle_sext:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; X64-NEXT:    retq
  %1 = and <8 x i16> %a0, <i16 -1, i16 -1, i16 -1, i16 -1, i16 15, i16 15, i16 15, i16 15>
  %2 = shufflevector <8 x i16> %1, <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %3 = shufflevector <8 x i16> %2, <8 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = sext <4 x i16> %3 to <4 x i32>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_mask_shuffle_shuffle_undef_sext(<8 x i16> %a0) nounwind {
; X32-LABEL: knownbits_mask_shuffle_shuffle_undef_sext:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X32-NEXT:    vpmovsxwd %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_shuffle_shuffle_undef_sext:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-NEXT:    vpmovsxwd %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <8 x i16> %a0, <i16 -1, i16 -1, i16 -1, i16 -1, i16 15, i16 15, i16 15, i16 15>
  %2 = shufflevector <8 x i16> %1, <8 x i16> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %3 = shufflevector <8 x i16> %2, <8 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = sext <4 x i16> %3 to <4 x i32>
  ret <4 x i32> %4
}

define <4 x float> @knownbits_mask_shuffle_uitofp(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_shuffle_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X32-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_shuffle_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -1, i32 -1, i32 255, i32 4085>
  %2 = shufflevector <4 x i32> %1, <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 3, i32 3>
  %3 = uitofp <4 x i32> %2 to <4 x float>
  ret <4 x float> %3
}

define <4 x float> @knownbits_mask_or_shuffle_uitofp(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_or_shuffle_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpor {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X32-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_or_shuffle_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpor {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -1, i32 -1, i32 255, i32 4085>
  %2 = or <4 x i32> %1, <i32 65535, i32 65535, i32 65535, i32 65535>
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 3, i32 3>
  %4 = uitofp <4 x i32> %3 to <4 x float>
  ret <4 x float> %4
}

define <4 x float> @knownbits_mask_xor_shuffle_uitofp(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_xor_shuffle_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpxor {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X32-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_xor_shuffle_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpxor {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -1, i32 -1, i32 255, i32 4085>
  %2 = xor <4 x i32> %1, <i32 65535, i32 65535, i32 65535, i32 65535>
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 3, i32 3>
  %4 = uitofp <4 x i32> %3 to <4 x float>
  ret <4 x float> %4
}

define <4 x i32> @knownbits_mask_shl_shuffle_lshr(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_shl_shuffle_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_shl_shuffle_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -65536, i32 -7, i32 -7, i32 -65536>
  %2 = shl <4 x i32> %1, <i32 17, i32 17, i32 17, i32 17>
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = lshr <4 x i32> %3, <i32 15, i32 15, i32 15, i32 15>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_mask_ashr_shuffle_lshr(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_ashr_shuffle_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_ashr_shuffle_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 131071, i32 -1, i32 -1, i32 131071>
  %2 = ashr <4 x i32> %1, <i32 15, i32 15, i32 15, i32 15>
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = lshr <4 x i32> %3, <i32 30, i32 30, i32 30, i32 30>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_mask_mul_shuffle_shl(<4 x i32> %a0, <4 x i32> %a1) nounwind {
; X32-LABEL: knownbits_mask_mul_shuffle_shl:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_mul_shuffle_shl:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -65536, i32 -7, i32 -7, i32 -65536>
  %2 = mul <4 x i32> %a1, %1
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = shl <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_mask_trunc_shuffle_shl(<4 x i64> %a0) nounwind {
; X32-LABEL: knownbits_mask_trunc_shuffle_shl:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_trunc_shuffle_shl:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i64> %a0, <i64 -65536, i64 -7, i64 7, i64 -65536>
  %2 = trunc <4 x i64> %1 to <4 x i32>
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = shl <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_mask_add_shuffle_lshr(<4 x i32> %a0, <4 x i32> %a1) nounwind {
; X32-LABEL: knownbits_mask_add_shuffle_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_add_shuffle_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 32767, i32 -1, i32 -1, i32 32767>
  %2 = and <4 x i32> %a1, <i32 32767, i32 -1, i32 -1, i32 32767>
  %3 = add <4 x i32> %1, %2
  %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %5 = lshr <4 x i32> %4, <i32 17, i32 17, i32 17, i32 17>
  ret <4 x i32> %5
}

define <4 x i32> @knownbits_mask_sub_shuffle_lshr(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_sub_shuffle_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_sub_shuffle_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 15, i32 -1, i32 -1, i32 15>
  %2 = sub <4 x i32> <i32 255, i32 255, i32 255, i32 255>, %1
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = lshr <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_mask_udiv_shuffle_lshr(<4 x i32> %a0, <4 x i32> %a1) nounwind {
; X32-LABEL: knownbits_mask_udiv_shuffle_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_udiv_shuffle_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 32767, i32 -1, i32 -1, i32 32767>
  %2 = udiv <4 x i32> %1, %a1
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = lshr <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_urem_lshr(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_urem_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_urem_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = urem <4 x i32> %a0, <i32 16, i32 16, i32 16, i32 16>
  %2 = lshr <4 x i32> %1, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %2
}

define <4 x i32> @knownbits_mask_urem_shuffle_lshr(<4 x i32> %a0, <4 x i32> %a1) nounwind {
; X32-LABEL: knownbits_mask_urem_shuffle_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_urem_shuffle_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 32767, i32 -1, i32 -1, i32 32767>
  %2 = and <4 x i32> %a1, <i32 32767, i32 -1, i32 -1, i32 32767>
  %3 = urem <4 x i32> %1, %2
  %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %5 = lshr <4 x i32> %4, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %5
}

define <4 x i32> @knownbits_mask_srem_shuffle_lshr(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_srem_shuffle_lshr:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_srem_shuffle_lshr:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -32768, i32 -1, i32 -1, i32 -32768>
  %2 = srem <4 x i32> %1, <i32 16, i32 16, i32 16, i32 16>
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = lshr <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %4
}

define <4 x i32> @knownbits_mask_bswap_shuffle_shl(<4 x i32> %a0) nounwind {
; X32-LABEL: knownbits_mask_bswap_shuffle_shl:
; X32:       # BB#0:
; X32-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_bswap_shuffle_shl:
; X64:       # BB#0:
; X64-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 32767, i32 -1, i32 -1, i32 32767>
  %2 = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %1)
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = shl <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  ret <4 x i32> %4
}
declare <4 x i32> @llvm.bswap.v4i32(<4 x i32>)

define <8 x float> @knownbits_mask_concat_uitofp(<4 x i32> %a0, <4 x i32> %a1) nounwind {
; X32-LABEL: knownbits_mask_concat_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm1, %xmm1
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,0,2]
; X32-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,3,1,3]
; X32-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32-NEXT:    vcvtdq2ps %ymm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_concat_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,0,2]
; X64-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,3,1,3]
; X64-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X64-NEXT:    vcvtdq2ps %ymm0, %ymm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 131071, i32 -1, i32 131071, i32 -1>
  %2 = and <4 x i32> %a1, <i32 -1, i32 131071, i32 -1, i32 131071>
  %3 = shufflevector <4 x i32> %1, <4 x i32> %2, <8 x i32> <i32 0, i32 2, i32 0, i32 2, i32 5, i32 7, i32 5, i32 7>
  %4 = uitofp <8 x i32> %3 to <8 x float>
  ret <8 x float> %4
}

define <4 x float> @knownbits_lshr_bitcast_shuffle_uitofp(<2 x i64> %a0, <4 x i32> %a1) nounwind {
; X32-LABEL: knownbits_lshr_bitcast_shuffle_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpsrlq $1, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; X32-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_lshr_bitcast_shuffle_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpsrlq $1, %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = lshr <2 x i64> %a0, <i64 1, i64 1>
  %2 = bitcast <2 x i64> %1 to <4 x i32>
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 1, i32 1, i32 3, i32 3>
  %4 = uitofp <4 x i32> %3 to <4 x float>
  ret <4 x float> %4
}

define <4 x float> @knownbits_smax_smin_shuffle_uitofp(<4 x i32> %a0) {
; X32-LABEL: knownbits_smax_smin_shuffle_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpminsd {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpmaxsd {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,3,3]
; X32-NEXT:    vpblendw {{.*#+}} xmm1 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X32-NEXT:    vpsrld $16, %xmm0, %xmm0
; X32-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X32-NEXT:    vaddps {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_smax_smin_shuffle_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpminsd {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpmaxsd {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,3,3]
; X64-NEXT:    vpblendw {{.*#+}} xmm1 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X64-NEXT:    vpsrld $16, %xmm0, %xmm0
; X64-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X64-NEXT:    vaddps {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; X64-NEXT:    retq
  %1 = call <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32> %a0, <4 x i32> <i32 0, i32 -65535, i32 -65535, i32 0>)
  %2 = call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %1, <4 x i32> <i32 65535, i32 -1, i32 -1, i32 131071>)
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = uitofp <4 x i32> %3 to <4 x float>
  ret <4 x float> %4
}
declare <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32>, <4 x i32>) nounwind readnone
declare <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32>, <4 x i32>) nounwind readnone

define <4 x float> @knownbits_umax_umin_shuffle_uitofp(<4 x i32> %a0) {
; X32-LABEL: knownbits_umax_umin_shuffle_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpmaxud {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpminud {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,3,3]
; X32-NEXT:    vpblendw {{.*#+}} xmm1 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X32-NEXT:    vpsrld $16, %xmm0, %xmm0
; X32-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X32-NEXT:    vaddps {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_umax_umin_shuffle_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpmaxud {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,3,3]
; X64-NEXT:    vpblendw {{.*#+}} xmm1 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X64-NEXT:    vpsrld $16, %xmm0, %xmm0
; X64-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X64-NEXT:    vaddps {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; X64-NEXT:    retq
  %1 = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %a0, <4 x i32> <i32 255, i32 -1, i32 -1, i32 1023>)
  %2 = call <4 x i32> @llvm.x86.sse41.pminud(<4 x i32> %1, <4 x i32> <i32 65535, i32 -1, i32 -1, i32 262143>)
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = uitofp <4 x i32> %3 to <4 x float>
  ret <4 x float> %4
}
declare <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32>, <4 x i32>) nounwind readnone
declare <4 x i32> @llvm.x86.sse41.pminud(<4 x i32>, <4 x i32>) nounwind readnone

define <4 x float> @knownbits_mask_umax_shuffle_uitofp(<4 x i32> %a0) {
; X32-LABEL: knownbits_mask_umax_shuffle_uitofp:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpmaxud {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,3,3]
; X32-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_umax_shuffle_uitofp:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpmaxud {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,3,3]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 65535, i32 -1, i32 -1, i32 262143>
  %2 = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %1, <4 x i32> <i32 255, i32 -1, i32 -1, i32 1023>)
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  %4 = uitofp <4 x i32> %3 to <4 x float>
  ret <4 x float> %4
}

define <4 x i32> @knownbits_mask_bitreverse_ashr(<4 x i32> %a0) {
; X32-LABEL: knownbits_mask_bitreverse_ashr:
; X32:       # BB#0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12]
; X32-NEXT:    vmovdqa {{.*#+}} xmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; X32-NEXT:    vpand %xmm1, %xmm0, %xmm2
; X32-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,128,64,192,32,160,96,224,16,144,80,208,48,176,112,240]
; X32-NEXT:    vpshufb %xmm2, %xmm3, %xmm2
; X32-NEXT:    vpsrlw $4, %xmm0, %xmm0
; X32-NEXT:    vpand %xmm1, %xmm0, %xmm0
; X32-NEXT:    vmovdqa {{.*#+}} xmm1 = [0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]
; X32-NEXT:    vpshufb %xmm0, %xmm1, %xmm0
; X32-NEXT:    vpor %xmm0, %xmm2, %xmm0
; X32-NEXT:    vpsrad $31, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_bitreverse_ashr:
; X64:       # BB#0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12]
; X64-NEXT:    vmovdqa {{.*#+}} xmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; X64-NEXT:    vpand %xmm1, %xmm0, %xmm2
; X64-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,128,64,192,32,160,96,224,16,144,80,208,48,176,112,240]
; X64-NEXT:    vpshufb %xmm2, %xmm3, %xmm2
; X64-NEXT:    vpsrlw $4, %xmm0, %xmm0
; X64-NEXT:    vpand %xmm1, %xmm0, %xmm0
; X64-NEXT:    vmovdqa {{.*#+}} xmm1 = [0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]
; X64-NEXT:    vpshufb %xmm0, %xmm1, %xmm0
; X64-NEXT:    vpor %xmm0, %xmm2, %xmm0
; X64-NEXT:    vpsrad $31, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -2, i32 -2, i32 -2, i32 -2>
  %2 = call <4 x i32> @llvm.bitreverse.v4i32(<4 x i32> %1)
  %3 = ashr <4 x i32> %2, <i32 31, i32 31, i32 31, i32 31>
  ret <4 x i32> %3
}
declare <4 x i32> @llvm.bitreverse.v4i32(<4 x i32>) nounwind readnone
