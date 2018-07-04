; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+ssse3 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX2

; Verify that the following shifts are lowered into a sequence of two shifts plus
; a blend. On pre-avx2 targets, instead of scalarizing logical and arithmetic
; packed shift right by a constant build_vector the backend should always try to
; emit a simpler sequence of two shifts + blend when possible.

define <8 x i16> @test1(<8 x i16> %a) {
; SSE-LABEL: test1:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrlw $3, %xmm1
; SSE-NEXT:    psrlw $2, %xmm0
; SSE-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test1:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrlw $3, %xmm0, %xmm1
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test1:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlw $3, %xmm0, %xmm1
; AVX2-NEXT:    vpsrlw $2, %xmm0, %xmm0
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX2-NEXT:    retq
  %lshr = lshr <8 x i16> %a, <i16 3, i16 3, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>
  ret <8 x i16> %lshr
}

define <8 x i16> @test2(<8 x i16> %a) {
; SSE-LABEL: test2:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrlw $3, %xmm1
; SSE-NEXT:    psrlw $2, %xmm0
; SSE-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm1
; AVX1-NEXT:    vpsrlw $3, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlw $2, %xmm0, %xmm1
; AVX2-NEXT:    vpsrlw $3, %xmm0, %xmm0
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX2-NEXT:    retq
  %lshr = lshr <8 x i16> %a, <i16 3, i16 3, i16 3, i16 3, i16 2, i16 2, i16 2, i16 2>
  ret <8 x i16> %lshr
}

define <4 x i32> @test3(<4 x i32> %a) {
; SSE-LABEL: test3:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrld $3, %xmm1
; SSE-NEXT:    psrld $2, %xmm0
; SSE-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test3:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrld $3, %xmm0, %xmm1
; AVX1-NEXT:    vpsrld $2, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test3:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
  %lshr = lshr <4 x i32> %a, <i32 3, i32 2, i32 2, i32 2>
  ret <4 x i32> %lshr
}

define <4 x i32> @test4(<4 x i32> %a) {
; SSE-LABEL: test4:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrld $3, %xmm1
; SSE-NEXT:    psrld $2, %xmm0
; SSE-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test4:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrld $2, %xmm0, %xmm1
; AVX1-NEXT:    vpsrld $3, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
  %lshr = lshr <4 x i32> %a, <i32 3, i32 3, i32 2, i32 2>
  ret <4 x i32> %lshr
}

define <8 x i16> @test5(<8 x i16> %a) {
; SSE-LABEL: test5:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psraw $3, %xmm1
; SSE-NEXT:    psraw $2, %xmm0
; SSE-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test5:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsraw $3, %xmm0, %xmm1
; AVX1-NEXT:    vpsraw $2, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test5:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsraw $3, %xmm0, %xmm1
; AVX2-NEXT:    vpsraw $2, %xmm0, %xmm0
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX2-NEXT:    retq
  %lshr = ashr <8 x i16> %a, <i16 3, i16 3, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>
  ret <8 x i16> %lshr
}

define <8 x i16> @test6(<8 x i16> %a) {
; SSE-LABEL: test6:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psraw $3, %xmm1
; SSE-NEXT:    psraw $2, %xmm0
; SSE-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test6:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsraw $2, %xmm0, %xmm1
; AVX1-NEXT:    vpsraw $3, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test6:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsraw $2, %xmm0, %xmm1
; AVX2-NEXT:    vpsraw $3, %xmm0, %xmm0
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX2-NEXT:    retq
  %lshr = ashr <8 x i16> %a, <i16 3, i16 3, i16 3, i16 3, i16 2, i16 2, i16 2, i16 2>
  ret <8 x i16> %lshr
}

define <4 x i32> @test7(<4 x i32> %a) {
; SSE-LABEL: test7:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $3, %xmm1
; SSE-NEXT:    psrad $2, %xmm0
; SSE-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test7:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrad $3, %xmm0, %xmm1
; AVX1-NEXT:    vpsrad $2, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test7:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
  %lshr = ashr <4 x i32> %a, <i32 3, i32 2, i32 2, i32 2>
  ret <4 x i32> %lshr
}

define <4 x i32> @test8(<4 x i32> %a) {
; SSE-LABEL: test8:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $3, %xmm1
; SSE-NEXT:    psrad $2, %xmm0
; SSE-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrad $2, %xmm0, %xmm1
; AVX1-NEXT:    vpsrad $3, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
  %lshr = ashr <4 x i32> %a, <i32 3, i32 3, i32 2, i32 2>
  ret <4 x i32> %lshr
}

define <8 x i16> @test9(<8 x i16> %a) {
; SSE-LABEL: test9:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [65535,0,65535,65535,65535,0,0,0]
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    pand %xmm2, %xmm1
; SSE-NEXT:    psraw $2, %xmm0
; SSE-NEXT:    pandn %xmm0, %xmm2
; SSE-NEXT:    por %xmm2, %xmm1
; SSE-NEXT:    psraw $1, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: test9:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsraw $2, %xmm0, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2,3,4],xmm1[5,6,7]
; AVX1-NEXT:    vpsraw $1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test9:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxwd %xmm0, %ymm0
; AVX2-NEXT:    vpsravd {{.*}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %lshr = ashr <8 x i16> %a, <i16 1, i16 3, i16 1, i16 1, i16 1, i16 3, i16 3, i16 3>
  ret <8 x i16> %lshr
}

define <8 x i32> @test10(<8 x i32>* %a) {
; SSE-LABEL: test10:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa 16(%rdi), %xmm1
; SSE-NEXT:    psrad %xmm0, %xmm1
; SSE-NEXT:    psrad $1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: test10:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa (%rdi), %xmm0
; AVX1-NEXT:    vpsrad $1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test10:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vpsrad $1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %ld = load <8 x i32>, <8 x i32>* %a, align 32
  %ashr = ashr <8 x i32> %ld, <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  ret <8 x i32> %ashr
}
