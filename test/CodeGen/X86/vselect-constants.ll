; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=sse2 | FileCheck %s --check-prefix=ALL --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx  | FileCheck %s --check-prefix=ALL --check-prefix=AVX

; First, check the generic pattern for any 2 vector constants. Then, check special cases where
; the constants are all off-by-one. Finally, check the extra special cases where the constants
; include 0 or -1.
; Each minimal select test is repeated with a more typical pattern that includes a compare to
; generate the condition value.

; TODO: If we don't have blendv, this can definitely be improved. There's also a selection of 
; chips where it makes sense to transform the general case blendv to 2 bit-ops. That should be
; a uarch-specfic transform. At some point (Ryzen?), the implementation should catch up to the 
; architecture, so blendv is as fast as a single bit-op.

define <4 x i32> @sel_C1_or_C2_vec(<4 x i1> %cond) {
; SSE-LABEL: sel_C1_or_C2_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $31, %xmm0
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    pandn {{.*}}(%rip), %xmm1
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    por %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sel_C1_or_C2_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX-NEXT:    vmovaps {{.*#+}} xmm1 = [42,0,4294967294,4294967295]
; AVX-NEXT:    vblendvps %xmm0, {{.*}}(%rip), %xmm1, %xmm0
; AVX-NEXT:    retq
  %add = select <4 x i1> %cond, <4 x i32> <i32 3000, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_C1_or_C2_vec(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: cmp_sel_C1_or_C2_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    pandn {{.*}}(%rip), %xmm1
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    por %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmp_sel_C1_or_C2_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovaps {{.*#+}} xmm1 = [42,0,4294967294,4294967295]
; AVX-NEXT:    vblendvps %xmm0, {{.*}}(%rip), %xmm1, %xmm0
; AVX-NEXT:    retq
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 3000, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_Cplus1_or_C_vec(<4 x i1> %cond) {
; SSE-LABEL: sel_Cplus1_or_C_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sel_Cplus1_or_C_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpaddd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_Cplus1_or_C_vec(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: cmp_sel_Cplus1_or_C_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [42,0,4294967294,4294967295]
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmp_sel_Cplus1_or_C_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [42,0,4294967294,4294967295]
; AVX-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_Cminus1_or_C_vec(<4 x i1> %cond) {
; SSE-LABEL: sel_Cminus1_or_C_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $31, %xmm0
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sel_Cminus1_or_C_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX-NEXT:    vpaddd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 44, i32 2, i32 0, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_Cminus1_or_C_vec(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: cmp_sel_Cminus1_or_C_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmp_sel_Cminus1_or_C_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpaddd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 44, i32 2, i32 0, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_minus1_or_0_vec(<4 x i1> %cond) {
; SSE-LABEL: sel_minus1_or_0_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $31, %xmm0
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sel_minus1_or_0_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX-NEXT:    retq
  %add = select <4 x i1> %cond, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_minus1_or_0_vec(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: cmp_sel_minus1_or_0_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmp_sel_minus1_or_0_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @sel_0_or_minus1_vec(<4 x i1> %cond) {
; SSE-LABEL: sel_0_or_minus1_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sel_0_or_minus1_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_0_or_minus1_vec(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: cmp_sel_0_or_minus1_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    pxor %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmp_sel_0_or_minus1_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_1_or_0_vec(<4 x i1> %cond) {
; SSE-LABEL: sel_1_or_0_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sel_1_or_0_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %add = select <4 x i1> %cond, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_1_or_0_vec(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: cmp_sel_1_or_0_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    psrld $31, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmp_sel_1_or_0_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrld $31, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @sel_0_or_1_vec(<4 x i1> %cond) {
; SSE-LABEL: sel_0_or_1_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    andnps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sel_0_or_1_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vandnps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_0_or_1_vec(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: cmp_sel_0_or_1_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    pandn {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: cmp_sel_0_or_1_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpandn {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

; https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=21167
define <2 x i37> @ossfuzz21167(<2 x i37> %x, <2 x i37> %y) {
; SSE-LABEL: ossfuzz21167:
; SSE:       # %bb.0: # %BB
; SSE-NEXT:    psllq $27, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    psrad $27, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE-NEXT:    psrlq $27, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE-NEXT:    movdqa {{.*#+}} xmm0 = [2147483648,2147483648]
; SSE-NEXT:    pxor %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    pcmpgtd %xmm0, %xmm2
; SSE-NEXT:    pcmpeqd %xmm0, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE-NEXT:    pand %xmm2, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[1,1,3,3]
; SSE-NEXT:    por %xmm1, %xmm0
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: ossfuzz21167:
; AVX:       # %bb.0: # %BB
; AVX-NEXT:    vpsllq $27, %xmm1, %xmm0
; AVX-NEXT:    vpsrad $27, %xmm0, %xmm1
; AVX-NEXT:    vpsrlq $27, %xmm0, %xmm0
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsrlq $63, %xmm0, %xmm0
; AVX-NEXT:    retq
BB:
  %c0 = icmp sgt <2 x i37> %y, zeroinitializer
  %xor_x = xor <2 x i37> undef, undef
  %smax96 = select <2 x i1> %c0, <2 x i37> %xor_x, <2 x i37> zeroinitializer
  ret <2 x i37> %smax96
}
