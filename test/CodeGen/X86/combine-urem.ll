; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX2

; fold (urem x, 1) -> 0
define i32 @combine_urem_by_one(i32 %x) {
; CHECK-LABEL: combine_urem_by_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %1 = urem i32 %x, 1
  ret i32 %1
}

define <4 x i32> @combine_vec_urem_by_one(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_by_one:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_by_one:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = urem <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %1
}

; fold (urem x, -1) -> select((icmp eq x, -1), 0, x)
define i32 @combine_urem_by_negone(i32 %x) {
; CHECK-LABEL: combine_urem_by_negone:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpl $-1, %edi
; CHECK-NEXT:    cmovnel %edi, %eax
; CHECK-NEXT:    retq
  %1 = urem i32 %x, -1
  ret i32 %1
}

define <4 x i32> @combine_vec_urem_by_negone(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_by_negone:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    pcmpeqd %xmm0, %xmm1
; SSE-NEXT:    pandn %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_by_negone:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpandn %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = urem <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %1
}

; Use PSLLI intrinsic to postpone the undef creation until after urem-by-constant expansion

define <4 x i32> @combine_vec_urem_undef_by_negone(<4 x i32> %in) {
; SSE-LABEL: combine_vec_urem_undef_by_negone:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE-NEXT:    pandn %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_undef_by_negone:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vpandn %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = call <4 x i32> @llvm.x86.sse2.pslli.d(<4 x i32> undef, i32 0)
  %y = urem <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %y
}

; fold (urem x, INT_MIN) -> (and x, ~INT_MIN)
define i32 @combine_urem_by_minsigned(i32 %x) {
; CHECK-LABEL: combine_urem_by_minsigned:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-NEXT:    retq
  %1 = urem i32 %x, -2147483648
  ret i32 %1
}

define <4 x i32> @combine_vec_urem_by_minsigned(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_by_minsigned:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_urem_by_minsigned:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_urem_by_minsigned:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastss {{.*#+}} xmm1 = [2147483647,2147483647,2147483647,2147483647]
; AVX2-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = urem <4 x i32> %x, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  ret <4 x i32> %1
}

; fold (urem 0, x) -> 0
define i32 @combine_urem_zero(i32 %x) {
; CHECK-LABEL: combine_urem_zero:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %1 = urem i32 0, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_urem_zero(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_zero:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = urem <4 x i32> zeroinitializer, %x
  ret <4 x i32> %1
}

; fold (urem x, x) -> 0
define i32 @combine_urem_dupe(i32 %x) {
; CHECK-LABEL: combine_urem_dupe:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %1 = urem i32 %x, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_urem_dupe(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_dupe:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_dupe:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = urem <4 x i32> %x, %x
  ret <4 x i32> %1
}

; fold (urem x, pow2) -> (and x, (pow2-1))
define <4 x i32> @combine_vec_urem_by_pow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_by_pow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_urem_by_pow2a:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_urem_by_pow2a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastss {{.*#+}} xmm1 = [3,3,3,3]
; AVX2-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = urem <4 x i32> %x, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_urem_by_pow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_urem_by_pow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_urem_by_pow2b:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = urem <4 x i32> %x, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_urem_by_pow2c(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_urem_by_pow2c:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $23, %xmm1
; SSE-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE-NEXT:    paddd %xmm1, %xmm2
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_urem_by_pow2c:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpslld $23, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vcvttps2dq %xmm1, %xmm1
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_urem_by_pow2c:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1,1,1,1]
; AVX2-NEXT:    vpsllvd %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = shl <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %2 = urem <4 x i32> %x, %1
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_urem_by_pow2d(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_urem_by_pow2d:
; SSE:       # %bb.0:
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm1[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa {{.*#+}} xmm3 = [2147483648,2147483648,2147483648,2147483648]
; SSE-NEXT:    movdqa %xmm3, %xmm4
; SSE-NEXT:    psrld %xmm2, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm5 = xmm2[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm3, %xmm6
; SSE-NEXT:    psrld %xmm5, %xmm6
; SSE-NEXT:    pblendw {{.*#+}} xmm6 = xmm4[0,1,2,3],xmm6[4,5,6,7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,1,1,1,4,5,6,7]
; SSE-NEXT:    movdqa %xmm3, %xmm4
; SSE-NEXT:    psrld %xmm1, %xmm4
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm2[0,1,1,1,4,5,6,7]
; SSE-NEXT:    psrld %xmm1, %xmm3
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm4[0,1,2,3],xmm3[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1],xmm6[2,3],xmm3[4,5],xmm6[6,7]
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    paddd %xmm3, %xmm1
; SSE-NEXT:    pand %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_urem_by_pow2d:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrldq {{.*#+}} xmm2 = xmm1[12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [2147483648,2147483648,2147483648,2147483648]
; AVX1-NEXT:    vpsrld %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsrlq $32, %xmm1, %xmm4
; AVX1-NEXT:    vpsrld %xmm4, %xmm3, %xmm4
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm4[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; AVX1-NEXT:    vpunpckhdq {{.*#+}} xmm4 = xmm1[2],xmm4[2],xmm1[3],xmm4[3]
; AVX1-NEXT:    vpsrld %xmm4, %xmm3, %xmm4
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vpsrld %xmm1, %xmm3, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm4[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_urem_by_pow2d:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; AVX2-NEXT:    vpsrlvd %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = lshr <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>, %y
  %2 = urem <4 x i32> %x, %1
  ret <4 x i32> %2
}

; fold (urem x, (shl pow2, y)) -> (and x, (add (shl pow2, y), -1))
define <4 x i32> @combine_vec_urem_by_shl_pow2a(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_urem_by_shl_pow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $23, %xmm1
; SSE-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE-NEXT:    pslld $2, %xmm1
; SSE-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE-NEXT:    paddd %xmm1, %xmm2
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_urem_by_shl_pow2a:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpslld $23, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vcvttps2dq %xmm1, %xmm1
; AVX1-NEXT:    vpslld $2, %xmm1, %xmm1
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_urem_by_shl_pow2a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [4,4,4,4]
; AVX2-NEXT:    vpsllvd %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = shl <4 x i32> <i32 4, i32 4, i32 4, i32 4>, %y
  %2 = urem <4 x i32> %x, %1
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_urem_by_shl_pow2b(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_urem_by_shl_pow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $23, %xmm1
; SSE-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    cvttps2dq %xmm1, %xmm1
; SSE-NEXT:    pmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    pcmpeqd %xmm2, %xmm2
; SSE-NEXT:    paddd %xmm1, %xmm2
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_urem_by_shl_pow2b:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpslld $23, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vcvttps2dq %xmm1, %xmm1
; AVX1-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_urem_by_shl_pow2b:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [1,4,8,16]
; AVX2-NEXT:    vpsllvd %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = shl <4 x i32> <i32 1, i32 4, i32 8, i32 16>, %y
  %2 = urem <4 x i32> %x, %1
  ret <4 x i32> %2
}

; FIXME: PR55271 - urem(undef, 3) != undef
; Use PSLLI intrinsic to postpone the undef creation until after urem-by-constant expansion
define <4 x i32> @combine_vec_urem_undef_by_3(<4 x i32> %in) {
; CHECK-LABEL: combine_vec_urem_undef_by_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %x = call <4 x i32> @llvm.x86.sse2.pslli.d(<4 x i32> undef, i32 0)
  %y = urem <4 x i32> %x, <i32 3, i32 3, i32 3, i32 3>
  ret <4 x i32> %y
}
declare <4 x i32> @llvm.x86.sse2.pslli.d(<4 x i32>, i32)

define i1 @bool_urem(i1 %x, i1 %y) {
; CHECK-LABEL: bool_urem:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %r = urem i1 %x, %y
  ret i1 %r
}

define <4 x i1> @boolvec_urem(<4 x i1> %x, <4 x i1> %y) {
; SSE-LABEL: boolvec_urem:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: boolvec_urem:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %r = urem <4 x i1> %x, %y
  ret <4 x i1> %r
}
