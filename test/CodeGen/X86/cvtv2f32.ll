; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-linux-pc -mcpu=corei7 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-linux-pc -mcpu=corei7 | FileCheck %s --check-prefix=X64

; uitofp <2 x i32> codegen from buildvector or legalization is different but gives the same results
; across the full 0 - 0xFFFFFFFF u32 range.

define <2 x float> @uitofp_2i32_cvt_buildvector(i32 %x, i32 %y, <2 x float> %v) {
; X32-LABEL: uitofp_2i32_cvt_buildvector:
; X32:       # %bb.0:
; X32-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; X32-NEXT:    movdqa {{.*#+}} xmm2 = [1258291200,1258291200,1258291200,1258291200]
; X32-NEXT:    pblendw {{.*#+}} xmm2 = xmm1[0],xmm2[1],xmm1[2],xmm2[3],xmm1[4],xmm2[5],xmm1[6],xmm2[7]
; X32-NEXT:    psrld $16, %xmm1
; X32-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0],mem[1],xmm1[2],mem[3],xmm1[4],mem[5],xmm1[6],mem[7]
; X32-NEXT:    addps {{\.LCPI.*}}, %xmm1
; X32-NEXT:    addps %xmm2, %xmm1
; X32-NEXT:    mulps %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: uitofp_2i32_cvt_buildvector:
; X64:       # %bb.0:
; X64-NEXT:    movd %edi, %xmm1
; X64-NEXT:    pinsrd $1, %esi, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm2 = [1258291200,1258291200,1258291200,1258291200]
; X64-NEXT:    pblendw {{.*#+}} xmm2 = xmm1[0],xmm2[1],xmm1[2],xmm2[3],xmm1[4],xmm2[5],xmm1[6],xmm2[7]
; X64-NEXT:    psrld $16, %xmm1
; X64-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0],mem[1],xmm1[2],mem[3],xmm1[4],mem[5],xmm1[6],mem[7]
; X64-NEXT:    addps {{.*}}(%rip), %xmm1
; X64-NEXT:    addps %xmm2, %xmm1
; X64-NEXT:    mulps %xmm1, %xmm0
; X64-NEXT:    retq
  %t1 = uitofp i32 %x to float
  %t2 = insertelement <2 x float> undef, float %t1, i32 0
  %t3 = uitofp i32 %y to float
  %t4 = insertelement <2 x float> %t2, float %t3, i32 1
  %t5 = fmul <2 x float> %v, %t4
  ret <2 x float> %t5
}

define <2 x float> @uitofp_2i32_buildvector_cvt(i32 %x, i32 %y, <2 x float> %v) {
; X32-LABEL: uitofp_2i32_buildvector_cvt:
; X32:       # %bb.0:
; X32-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X32-NEXT:    unpcklpd {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; X32-NEXT:    movapd {{.*#+}} xmm1 = [4.503600e+15,4.503600e+15]
; X32-NEXT:    orpd %xmm1, %xmm2
; X32-NEXT:    subpd %xmm1, %xmm2
; X32-NEXT:    cvtpd2ps %xmm2, %xmm1
; X32-NEXT:    mulps %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: uitofp_2i32_buildvector_cvt:
; X64:       # %bb.0:
; X64-NEXT:    movd %esi, %xmm1
; X64-NEXT:    movd %edi, %xmm2
; X64-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [4.503600e+15,4.503600e+15]
; X64-NEXT:    por %xmm1, %xmm2
; X64-NEXT:    subpd %xmm1, %xmm2
; X64-NEXT:    cvtpd2ps %xmm2, %xmm1
; X64-NEXT:    mulps %xmm1, %xmm0
; X64-NEXT:    retq
  %t1 = insertelement <2 x i32> undef, i32 %x, i32 0
  %t2 = insertelement <2 x i32> %t1, i32 %y, i32 1
  %t3 = uitofp <2 x i32> %t2 to <2 x float>
  %t4 = fmul <2 x float> %v, %t3
  ret <2 x float> %t4
}

define <2 x float> @uitofp_2i32_legalized(<2 x i32> %in, <2 x float> %v) {
; X32-LABEL: uitofp_2i32_legalized:
; X32:       # %bb.0:
; X32-NEXT:    xorps %xmm2, %xmm2
; X32-NEXT:    blendps {{.*#+}} xmm2 = xmm0[0],xmm2[1],xmm0[2],xmm2[3]
; X32-NEXT:    movaps {{.*#+}} xmm0 = [4.503600e+15,4.503600e+15]
; X32-NEXT:    orps %xmm0, %xmm2
; X32-NEXT:    subpd %xmm0, %xmm2
; X32-NEXT:    cvtpd2ps %xmm2, %xmm0
; X32-NEXT:    mulps %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: uitofp_2i32_legalized:
; X64:       # %bb.0:
; X64-NEXT:    xorps %xmm2, %xmm2
; X64-NEXT:    blendps {{.*#+}} xmm2 = xmm0[0],xmm2[1],xmm0[2],xmm2[3]
; X64-NEXT:    movaps {{.*#+}} xmm0 = [4.503600e+15,4.503600e+15]
; X64-NEXT:    orps %xmm0, %xmm2
; X64-NEXT:    subpd %xmm0, %xmm2
; X64-NEXT:    cvtpd2ps %xmm2, %xmm0
; X64-NEXT:    mulps %xmm1, %xmm0
; X64-NEXT:    retq
  %t1 = uitofp <2 x i32> %in to <2 x float>
  %t2 = fmul <2 x float> %v, %t1
  ret <2 x float> %t2
}
