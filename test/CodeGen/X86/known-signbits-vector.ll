; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,X64,X64-AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,X64,X64-AVX2

define <2 x double> @signbits_sext_v2i64_sitofp_v2f64(i32 %a0, i32 %a1) nounwind {
; X86-LABEL: signbits_sext_v2i64_sitofp_v2f64:
; X86:       # %bb.0:
; X86-NEXT:    vcvtdq2pd {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: signbits_sext_v2i64_sitofp_v2f64:
; X64:       # %bb.0:
; X64-NEXT:    vmovd %edi, %xmm0
; X64-NEXT:    vpinsrd $1, %esi, %xmm0, %xmm0
; X64-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = sext i32 %a0 to i64
  %2 = sext i32 %a1 to i64
  %3 = insertelement <2 x i64> undef, i64 %1, i32 0
  %4 = insertelement <2 x i64> %3, i64 %2, i32 1
  %5 = sitofp <2 x i64> %4 to <2 x double>
  ret <2 x double> %5
}

define <4 x float> @signbits_sext_v4i64_sitofp_v4f32(i8 signext %a0, i16 signext %a1, i32 %a2, i32 %a3) nounwind {
; X86-LABEL: signbits_sext_v4i64_sitofp_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    movswl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movsbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    vmovd %ecx, %xmm0
; X86-NEXT:    vpinsrd $1, %eax, %xmm0, %xmm0
; X86-NEXT:    vpinsrd $2, {{[0-9]+}}(%esp), %xmm0, %xmm0
; X86-NEXT:    vpinsrd $3, {{[0-9]+}}(%esp), %xmm0, %xmm0
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: signbits_sext_v4i64_sitofp_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vmovd %edi, %xmm0
; X64-NEXT:    vpinsrd $1, %esi, %xmm0, %xmm0
; X64-NEXT:    vpinsrd $2, %edx, %xmm0, %xmm0
; X64-NEXT:    vpinsrd $3, %ecx, %xmm0, %xmm0
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = sext i8 %a0 to i64
  %2 = sext i16 %a1 to i64
  %3 = sext i32 %a2 to i64
  %4 = sext i32 %a3 to i64
  %5 = insertelement <4 x i64> undef, i64 %1, i32 0
  %6 = insertelement <4 x i64> %5, i64 %2, i32 1
  %7 = insertelement <4 x i64> %6, i64 %3, i32 2
  %8 = insertelement <4 x i64> %7, i64 %4, i32 3
  %9 = sitofp <4 x i64> %8 to <4 x float>
  ret <4 x float> %9
}

define <4 x double> @signbits_ashr_sitofp_0(<4 x i64> %a0) nounwind {
; X86-LABEL: signbits_ashr_sitofp_0:
; X86:       # %bb.0:
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-NEXT:    vpsrlq $36, %xmm1, %xmm2
; X86-NEXT:    vpsrlq $35, %xmm1, %xmm1
; X86-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm2[4,5,6,7]
; X86-NEXT:    vmovdqa {{.*#+}} xmm2 = [268435456,0,134217728,0]
; X86-NEXT:    vpxor %xmm2, %xmm1, %xmm1
; X86-NEXT:    vpsubq %xmm2, %xmm1, %xmm1
; X86-NEXT:    vpsrlq $34, %xmm0, %xmm2
; X86-NEXT:    vpsrlq $33, %xmm0, %xmm0
; X86-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; X86-NEXT:    vmovdqa {{.*#+}} xmm2 = [1073741824,0,536870912,0]
; X86-NEXT:    vpxor %xmm2, %xmm0, %xmm0
; X86-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; X86-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X86-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_ashr_sitofp_0:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX1-NEXT:    vpsrlq $36, %xmm1, %xmm2
; X64-AVX1-NEXT:    vpsrlq $35, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm2[4,5,6,7]
; X64-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [268435456,134217728]
; X64-AVX1-NEXT:    vpxor %xmm2, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpsubq %xmm2, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpsrlq $34, %xmm0, %xmm2
; X64-AVX1-NEXT:    vpsrlq $33, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; X64-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [1073741824,536870912]
; X64-AVX1-NEXT:    vpxor %xmm2, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; X64-AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX1-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_ashr_sitofp_0:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsrlvq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [1073741824,536870912,268435456,134217728]
; X64-AVX2-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vpsubq %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX2-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X64-AVX2-NEXT:    retq
  %1 = ashr <4 x i64> %a0, <i64 33, i64 34, i64 35, i64 36>
  %2 = sitofp <4 x i64> %1 to <4 x double>
  ret <4 x double> %2
}

; PR45794
define <4 x float> @signbits_ashr_sitofp_1(<4 x i64> %a0) nounwind {
; X86-LABEL: signbits_ashr_sitofp_1:
; X86:       # %bb.0:
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-NEXT:    vpsrad $16, %xmm1, %xmm1
; X86-NEXT:    vpsrad $16, %xmm0, %xmm0
; X86-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_ashr_sitofp_1:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX1-NEXT:    vpsrad $16, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpsrad $16, %xmm0, %xmm0
; X64-AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; X64-AVX1-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX1-NEXT:    vzeroupper
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_ashr_sitofp_1:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsrad $16, %ymm0, %ymm0
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; X64-AVX2-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = ashr <4 x i64> %a0, <i64 48, i64 48, i64 48, i64 48>
  %2 = sitofp <4 x i64> %1 to <4 x float>
  ret <4 x float> %2
}

define float @signbits_ashr_extract_sitofp_0(<2 x i64> %a0) nounwind {
; X86-LABEL: signbits_ashr_extract_sitofp_0:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: signbits_ashr_extract_sitofp_0:
; X64:       # %bb.0:
; X64-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = ashr <2 x i64> %a0, <i64 32, i64 32>
  %2 = extractelement <2 x i64> %1, i32 0
  %3 = sitofp i64 %2 to float
  ret float %3
}

define float @signbits_ashr_extract_sitofp_1(<2 x i64> %a0) nounwind {
; X86-LABEL: signbits_ashr_extract_sitofp_1:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: signbits_ashr_extract_sitofp_1:
; X64:       # %bb.0:
; X64-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = ashr <2 x i64> %a0, <i64 32, i64 63>
  %2 = extractelement <2 x i64> %1, i32 0
  %3 = sitofp i64 %2 to float
  ret float %3
}

define float @signbits_ashr_shl_extract_sitofp(<2 x i64> %a0) nounwind {
; X86-LABEL: signbits_ashr_shl_extract_sitofp:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vpsrad $29, %xmm0, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; X86-NEXT:    vpsllq $20, %xmm0, %xmm0
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: signbits_ashr_shl_extract_sitofp:
; X64:       # %bb.0:
; X64-NEXT:    vpsrad $29, %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; X64-NEXT:    vpsllq $20, %xmm0, %xmm0
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = ashr <2 x i64> %a0, <i64 61, i64 60>
  %2 = shl <2 x i64> %1, <i64 20, i64 16>
  %3 = extractelement <2 x i64> %2, i32 0
  %4 = sitofp i64 %3 to float
  ret float %4
}

define float @signbits_ashr_insert_ashr_extract_sitofp(i64 %a0, i64 %a1) nounwind {
; X86-LABEL: signbits_ashr_insert_ashr_extract_sitofp:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    sarl $30, %ecx
; X86-NEXT:    shll $2, %eax
; X86-NEXT:    vmovd %eax, %xmm0
; X86-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; X86-NEXT:    vpsrlq $3, %xmm0, %xmm0
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: signbits_ashr_insert_ashr_extract_sitofp:
; X64:       # %bb.0:
; X64-NEXT:    sarq $30, %rdi
; X64-NEXT:    vmovq %rdi, %xmm0
; X64-NEXT:    vpsrlq $3, %xmm0, %xmm0
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = ashr i64 %a0, 30
  %2 = insertelement <2 x i64> undef, i64 %1, i32 0
  %3 = insertelement <2 x i64> %2, i64 %a1, i32 1
  %4 = ashr <2 x i64> %3, <i64 3, i64 3>
  %5 = extractelement <2 x i64> %4, i32 0
  %6 = sitofp i64 %5 to float
  ret float %6
}

define <4 x double> @signbits_sext_shuffle_sitofp(<4 x i32> %a0, <4 x i64> %a1) nounwind {
; X86-LABEL: signbits_sext_shuffle_sitofp:
; X86:       # %bb.0:
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X86-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X86-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[1,0,3,2]
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X86-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_sext_shuffle_sitofp:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X64-AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X64-AVX1-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[1,0,3,2]
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX1-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_sext_shuffle_sitofp:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpmovzxdq {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; X64-AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[3,2,1,0]
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX2-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X64-AVX2-NEXT:    retq
  %1 = sext <4 x i32> %a0 to <4 x i64>
  %2 = shufflevector <4 x i64> %1, <4 x i64>%a1, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %3 = sitofp <4 x i64> %2 to <4 x double>
  ret <4 x double> %3
}

define <2 x double> @signbits_sext_shl_sitofp(<2 x i16> %a0) nounwind {
; X86-LABEL: signbits_sext_shl_sitofp:
; X86:       # %bb.0:
; X86-NEXT:    vpmovsxwq %xmm0, %xmm0
; X86-NEXT:    vpsllq $5, %xmm0, %xmm1
; X86-NEXT:    vpsllq $11, %xmm0, %xmm0
; X86-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_sext_shl_sitofp:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpmovsxwq %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsllq $5, %xmm0, %xmm1
; X64-AVX1-NEXT:    vpsllq $11, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-AVX1-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_sext_shl_sitofp:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpmovsxwq %xmm0, %xmm0
; X64-AVX2-NEXT:    vpsllvq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-AVX2-NEXT:    vcvtdq2pd %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = sext <2 x i16> %a0 to <2 x i64>
  %2 = shl <2 x i64> %1, <i64 11, i64 5>
  %3 = sitofp <2 x i64> %2 to <2 x double>
  ret <2 x double> %3
}

define <2 x double> @signbits_ashr_concat_ashr_extract_sitofp(<2 x i64> %a0, <4 x i64> %a1) nounwind {
; CHECK-LABEL: signbits_ashr_concat_ashr_extract_sitofp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; CHECK-NEXT:    vcvtdq2pd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = ashr <2 x i64> %a0, <i64 16, i64 16>
  %2 = shufflevector <2 x i64> %1, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %3 = shufflevector <4 x i64> %a1, <4 x i64> %2, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  %4 = ashr <4 x i64> %3, <i64 16, i64 16, i64 16, i64 16>
  %5 = shufflevector <4 x i64> %4, <4 x i64> undef, <2 x i32> <i32 2, i32 3>
  %6 = sitofp <2 x i64> %5 to <2 x double>
  ret <2 x double> %6
}

define float @signbits_ashr_sext_sextinreg_and_extract_sitofp(<2 x i64> %a0, <2 x i64> %a1, i32 %a2) nounwind {
; X86-LABEL: signbits_ashr_sext_sextinreg_and_extract_sitofp:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vpsrad $29, %xmm0, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; X86-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X86-NEXT:    vpand %xmm0, %xmm1, %xmm0
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: signbits_ashr_sext_sextinreg_and_extract_sitofp:
; X64:       # %bb.0:
; X64-NEXT:    vpsrad $29, %xmm0, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; X64-NEXT:    vmovd %edi, %xmm1
; X64-NEXT:    vpand %xmm1, %xmm0, %xmm0
; X64-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = ashr <2 x i64> %a0, <i64 61, i64 60>
  %2 = sext i32 %a2 to i64
  %3 = insertelement <2 x i64> %a1, i64 %2, i32 0
  %4 = shl <2 x i64> %3, <i64 20, i64 20>
  %5 = ashr <2 x i64> %4, <i64 20, i64 20>
  %6 = and <2 x i64> %1, %5
  %7 = extractelement <2 x i64> %6, i32 0
  %8 = sitofp i64 %7 to float
  ret float %8
}

define float @signbits_ashr_sextvecinreg_bitops_extract_sitofp(<2 x i64> %a0, <4 x i32> %a1) nounwind {
; X86-LABEL: signbits_ashr_sextvecinreg_bitops_extract_sitofp:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vpsrlq $60, %xmm0, %xmm2
; X86-NEXT:    vpsrlq $61, %xmm0, %xmm0
; X86-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; X86-NEXT:    vmovdqa {{.*#+}} xmm2 = [4,0,8,0]
; X86-NEXT:    vpxor %xmm2, %xmm0, %xmm0
; X86-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; X86-NEXT:    vpand %xmm1, %xmm0, %xmm2
; X86-NEXT:    vpor %xmm1, %xmm2, %xmm1
; X86-NEXT:    vpxor %xmm0, %xmm1, %xmm0
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_ashr_sextvecinreg_bitops_extract_sitofp:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpsrlq $60, %xmm0, %xmm2
; X64-AVX1-NEXT:    vpsrlq $61, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; X64-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [4,8]
; X64-AVX1-NEXT:    vpxor %xmm2, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm2
; X64-AVX1-NEXT:    vpor %xmm1, %xmm2, %xmm1
; X64-AVX1-NEXT:    vpxor %xmm0, %xmm1, %xmm0
; X64-AVX1-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_ashr_sextvecinreg_bitops_extract_sitofp:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsrlvq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [4,8]
; X64-AVX2-NEXT:    vpxor %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm2
; X64-AVX2-NEXT:    vpor %xmm1, %xmm2, %xmm1
; X64-AVX2-NEXT:    vpxor %xmm0, %xmm1, %xmm0
; X64-AVX2-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = ashr <2 x i64> %a0, <i64 61, i64 60>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <2 x i32> <i32 0, i32 1>
  %3 = sext <2 x i32> %2 to <2 x i64>
  %4 = and <2 x i64> %1, %3
  %5 = or <2 x i64> %4, %3
  %6 = xor <2 x i64> %5, %1
  %7 = extractelement <2 x i64> %6, i32 0
  %8 = sitofp i64 %7 to float
  ret float %8
}

define <4 x float> @signbits_ashr_sext_select_shuffle_sitofp(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> %a2, <4 x i32> %a3) nounwind {
; X86-LABEL: signbits_ashr_sext_select_shuffle_sitofp:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-16, %esp
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    vpmovsxdq 8(%ebp), %xmm3
; X86-NEXT:    vpmovsxdq 16(%ebp), %xmm4
; X86-NEXT:    vpsrad $31, %xmm2, %xmm5
; X86-NEXT:    vpsrad $1, %xmm2, %xmm6
; X86-NEXT:    vpshufd {{.*#+}} xmm6 = xmm6[1,1,3,3]
; X86-NEXT:    vpblendw {{.*#+}} xmm5 = xmm6[0,1],xmm5[2,3],xmm6[4,5],xmm5[6,7]
; X86-NEXT:    vextractf128 $1, %ymm2, %xmm2
; X86-NEXT:    vpsrad $31, %xmm2, %xmm6
; X86-NEXT:    vpsrad $1, %xmm2, %xmm2
; X86-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; X86-NEXT:    vpblendw {{.*#+}} xmm2 = xmm2[0,1],xmm6[2,3],xmm2[4,5],xmm6[6,7]
; X86-NEXT:    vpcmpeqq %xmm1, %xmm0, %xmm6
; X86-NEXT:    vblendvpd %xmm6, %xmm5, %xmm3, %xmm3
; X86-NEXT:    vextractf128 $1, %ymm1, %xmm1
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X86-NEXT:    vpcmpeqq %xmm1, %xmm0, %xmm0
; X86-NEXT:    vblendvpd %xmm0, %xmm2, %xmm4, %xmm0
; X86-NEXT:    vinsertf128 $1, %xmm0, %ymm3, %ymm0
; X86-NEXT:    vmovddup {{.*#+}} ymm0 = ymm0[0,0,2,2]
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X86-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_ashr_sext_select_shuffle_sitofp:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpsrad $31, %xmm2, %xmm4
; X64-AVX1-NEXT:    vpsrad $1, %xmm2, %xmm5
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm5 = xmm5[1,1,3,3]
; X64-AVX1-NEXT:    vpblendw {{.*#+}} xmm4 = xmm5[0,1],xmm4[2,3],xmm5[4,5],xmm4[6,7]
; X64-AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm2
; X64-AVX1-NEXT:    vpsrad $31, %xmm2, %xmm5
; X64-AVX1-NEXT:    vpsrad $1, %xmm2, %xmm2
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; X64-AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm2[0,1],xmm5[2,3],xmm2[4,5],xmm5[6,7]
; X64-AVX1-NEXT:    vpmovsxdq %xmm3, %xmm5
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,3,2,3]
; X64-AVX1-NEXT:    vpmovsxdq %xmm3, %xmm3
; X64-AVX1-NEXT:    vpcmpeqq %xmm1, %xmm0, %xmm6
; X64-AVX1-NEXT:    vblendvpd %xmm6, %xmm4, %xmm5, %xmm4
; X64-AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X64-AVX1-NEXT:    vpcmpeqq %xmm1, %xmm0, %xmm0
; X64-AVX1-NEXT:    vblendvpd %xmm0, %xmm2, %xmm3, %xmm0
; X64-AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm4, %ymm0
; X64-AVX1-NEXT:    vmovddup {{.*#+}} ymm0 = ymm0[0,0,2,2]
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX1-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX1-NEXT:    vzeroupper
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_ashr_sext_select_shuffle_sitofp:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsrad $31, %ymm2, %ymm4
; X64-AVX2-NEXT:    vpsrad $1, %ymm2, %ymm2
; X64-AVX2-NEXT:    vpshufd {{.*#+}} ymm2 = ymm2[1,1,3,3,5,5,7,7]
; X64-AVX2-NEXT:    vpblendd {{.*#+}} ymm2 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
; X64-AVX2-NEXT:    vpmovsxdq %xmm3, %ymm3
; X64-AVX2-NEXT:    vpcmpeqq %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vblendvpd %ymm0, %ymm2, %ymm3, %ymm0
; X64-AVX2-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,1,0,1,4,5,4,5]
; X64-AVX2-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; X64-AVX2-NEXT:    vcvtdq2ps %xmm0, %xmm0
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = ashr <4 x i64> %a2, <i64 33, i64 63, i64 33, i64 63>
  %2 = sext <4 x i32> %a3 to <4 x i64>
  %3 = icmp eq <4 x i64> %a0, %a1
  %4 = select <4 x i1> %3, <4 x i64> %1, <4 x i64> %2
  %5 = shufflevector <4 x i64> %4, <4 x i64> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
  %6 = sitofp <4 x i64> %5 to <4 x float>
  ret <4 x float> %6
}

define <4 x i32> @signbits_mask_ashr_smax(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: signbits_mask_ashr_smax:
; X86:       # %bb.0:
; X86-NEXT:    vpsrad $25, %xmm0, %xmm0
; X86-NEXT:    vpsrad $25, %xmm1, %xmm1
; X86-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X86-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_mask_ashr_smax:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpsrad $25, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsrad $25, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X64-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_mask_ashr_smax:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [25,26,27,0]
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpbroadcastd %xmm0, %xmm0
; X64-AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = ashr <4 x i32> %a0, <i32 25, i32 26, i32 27, i32 0>
  %2 = ashr <4 x i32> %a1, <i32 25, i32 26, i32 27, i32 0>
  %3 = call <4 x i32> @llvm.smax.v4i32(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> zeroinitializer
  %5 = ashr <4 x i32> %4, <i32 1, i32 2, i32 3, i32 4>
  %6 = and <4 x i32> %5, <i32 -32768, i32 -65536, i32 -32768, i32 -65536>
  ret <4 x i32> %6
}
declare <4 x i32> @llvm.smax.v4i32(<4 x i32>, <4 x i32>) nounwind readnone

define <4 x i32> @signbits_mask_ashr_smin(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: signbits_mask_ashr_smin:
; X86:       # %bb.0:
; X86-NEXT:    vpsrad $25, %xmm0, %xmm0
; X86-NEXT:    vpsrad $25, %xmm1, %xmm1
; X86-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X86-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_mask_ashr_smin:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpsrad $25, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsrad $25, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X64-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_mask_ashr_smin:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [25,26,27,0]
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpbroadcastd %xmm0, %xmm0
; X64-AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = ashr <4 x i32> %a0, <i32 25, i32 26, i32 27, i32 0>
  %2 = ashr <4 x i32> %a1, <i32 25, i32 26, i32 27, i32 0>
  %3 = call <4 x i32> @llvm.smin.v4i32(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> zeroinitializer
  %5 = ashr <4 x i32> %4, <i32 1, i32 2, i32 3, i32 4>
  %6 = and <4 x i32> %5, <i32 -32768, i32 -65536, i32 -32768, i32 -65536>
  ret <4 x i32> %6
}
declare <4 x i32> @llvm.smin.v4i32(<4 x i32>, <4 x i32>) nounwind readnone

define <4 x i32> @signbits_mask_ashr_umax(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: signbits_mask_ashr_umax:
; X86:       # %bb.0:
; X86-NEXT:    vpsrad $25, %xmm0, %xmm0
; X86-NEXT:    vpsrad $25, %xmm1, %xmm1
; X86-NEXT:    vpmaxud %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X86-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_mask_ashr_umax:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpsrad $25, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsrad $25, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpmaxud %xmm1, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X64-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_mask_ashr_umax:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [25,26,27,0]
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpmaxud %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpbroadcastd %xmm0, %xmm0
; X64-AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = ashr <4 x i32> %a0, <i32 25, i32 26, i32 27, i32 0>
  %2 = ashr <4 x i32> %a1, <i32 25, i32 26, i32 27, i32 0>
  %3 = call <4 x i32> @llvm.umax.v4i32(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> zeroinitializer
  %5 = ashr <4 x i32> %4, <i32 1, i32 2, i32 3, i32 4>
  %6 = and <4 x i32> %5, <i32 -32768, i32 -65536, i32 -32768, i32 -65536>
  ret <4 x i32> %6
}
declare <4 x i32> @llvm.umax.v4i32(<4 x i32>, <4 x i32>) nounwind readnone

define <4 x i32> @signbits_mask_ashr_umin(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: signbits_mask_ashr_umin:
; X86:       # %bb.0:
; X86-NEXT:    vpsrad $25, %xmm0, %xmm0
; X86-NEXT:    vpsrad $25, %xmm1, %xmm1
; X86-NEXT:    vpminud %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X86-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: signbits_mask_ashr_umin:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpsrad $25, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsrad $25, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpminud %xmm1, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X64-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: signbits_mask_ashr_umin:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [25,26,27,0]
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpsravd %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpminud %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpbroadcastd %xmm0, %xmm0
; X64-AVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = ashr <4 x i32> %a0, <i32 25, i32 26, i32 27, i32 0>
  %2 = ashr <4 x i32> %a1, <i32 25, i32 26, i32 27, i32 0>
  %3 = call <4 x i32> @llvm.umin.v4i32(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> zeroinitializer
  %5 = ashr <4 x i32> %4, <i32 1, i32 2, i32 3, i32 4>
  %6 = and <4 x i32> %5, <i32 -32768, i32 -65536, i32 -32768, i32 -65536>
  ret <4 x i32> %6
}
declare <4 x i32> @llvm.umin.v4i32(<4 x i32>, <4 x i32>) nounwind readnone

define i32 @signbits_cmpss(float %0, float %1) {
; X86-LABEL: signbits_cmpss:
; X86:       # %bb.0:
; X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    vcmpeqss {{[0-9]+}}(%esp), %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    retl
;
; X64-LABEL: signbits_cmpss:
; X64:       # %bb.0:
; X64-NEXT:    vcmpeqss %xmm1, %xmm0, %xmm0
; X64-NEXT:    vmovd %xmm0, %eax
; X64-NEXT:    retq
  %3 = fcmp oeq float %0, %1
  %4 = sext i1 %3 to i32
  ret i32 %4
}

; FIXME: X86 fails to remove the unnecessary neg(and(x,1))
define i64 @signbits_cmpsd(double %0, double %1) {
; X86-LABEL: signbits_cmpsd:
; X86:       # %bb.0:
; X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    vcmpeqsd {{[0-9]+}}(%esp), %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    andl $1, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    retl
;
; X64-LABEL: signbits_cmpsd:
; X64:       # %bb.0:
; X64-NEXT:    vcmpeqsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vmovq %xmm0, %rax
; X64-NEXT:    retq
  %3 = fcmp oeq double %0, %1
  %4 = sext i1 %3 to i64
  ret i64 %4
}

; Make sure we can preserve sign bit information into the second basic block
; so we can avoid having to shift bit 0 into bit 7 for each element due to
; v32i1->v32i8 promotion and the splitting of v32i8 into 2xv16i8. This requires
; ComputeNumSignBits handling for insert_subvector.
define void @cross_bb_signbits_insert_subvec(<32 x i8>* %ptr, <32 x i8> %x, <32 x i8> %z) {
; X86-LABEL: cross_bb_signbits_insert_subvec:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm2
; X86-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; X86-NEXT:    vpcmpeqb %xmm3, %xmm2, %xmm2
; X86-NEXT:    vpcmpeqb %xmm3, %xmm0, %xmm0
; X86-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; X86-NEXT:    vandnps %ymm1, %ymm0, %ymm1
; X86-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %ymm0, %ymm0
; X86-NEXT:    vorps %ymm1, %ymm0, %ymm0
; X86-NEXT:    vmovaps %ymm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-AVX1-LABEL: cross_bb_signbits_insert_subvec:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; X64-AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; X64-AVX1-NEXT:    vpcmpeqb %xmm3, %xmm2, %xmm2
; X64-AVX1-NEXT:    vpcmpeqb %xmm3, %xmm0, %xmm0
; X64-AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; X64-AVX1-NEXT:    vandnps %ymm1, %ymm0, %ymm1
; X64-AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX1-NEXT:    vorps %ymm1, %ymm0, %ymm0
; X64-AVX1-NEXT:    vmovaps %ymm0, (%rdi)
; X64-AVX1-NEXT:    vzeroupper
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: cross_bb_signbits_insert_subvec:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; X64-AVX2-NEXT:    vpcmpeqb %ymm2, %ymm0, %ymm0
; X64-AVX2-NEXT:    vpblendvb %ymm0, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm0
; X64-AVX2-NEXT:    vmovdqa %ymm0, (%rdi)
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %a = icmp eq <32 x i8> %x, zeroinitializer
  %b = icmp eq <32 x i8> %x, zeroinitializer
  %c = and <32 x i1> %a, %b
  br label %block

block:
  %d = select <32 x i1> %c, <32 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, <32 x i8> %z
  store <32 x i8> %d, <32 x i8>* %ptr, align 32
  br label %exit

exit:
  ret void
}

