; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-FAST
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f | FileCheck %s --check-prefixes=AVX512,AVX512-SLOW
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512-FAST
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+xop | FileCheck %s --check-prefixes=AVX,XOP

define void @insert_v7i8_v2i16_2(<7 x i8> *%a0, <2 x i16> *%a1) nounwind {
; SSE-LABEL: insert_v7i8_v2i16_2:
; SSE:       # %bb.0:
; SSE-NEXT:    movl (%rsi), %eax
; SSE-NEXT:    movd %eax, %xmm0
; SSE-NEXT:    movq (%rdi), %rcx
; SSE-NEXT:    movq %rcx, %xmm1
; SSE-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; SSE-NEXT:    shrq $48, %rcx
; SSE-NEXT:    movb %cl, 6(%rdi)
; SSE-NEXT:    shrl $16, %eax
; SSE-NEXT:    movw %ax, 4(%rdi)
; SSE-NEXT:    movd %xmm1, (%rdi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: insert_v7i8_v2i16_2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    movl (%rsi), %eax
; AVX1-NEXT:    vmovd %eax, %xmm0
; AVX1-NEXT:    movq (%rdi), %rcx
; AVX1-NEXT:    vmovq %rcx, %xmm1
; AVX1-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; AVX1-NEXT:    shrq $48, %rcx
; AVX1-NEXT:    movb %cl, 6(%rdi)
; AVX1-NEXT:    shrl $16, %eax
; AVX1-NEXT:    movw %ax, 4(%rdi)
; AVX1-NEXT:    vmovd %xmm0, (%rdi)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v7i8_v2i16_2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movl (%rsi), %eax
; AVX2-NEXT:    vmovd %eax, %xmm0
; AVX2-NEXT:    movq (%rdi), %rcx
; AVX2-NEXT:    vmovq %rcx, %xmm1
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; AVX2-NEXT:    shrq $48, %rcx
; AVX2-NEXT:    movb %cl, 6(%rdi)
; AVX2-NEXT:    shrl $16, %eax
; AVX2-NEXT:    movw %ax, 4(%rdi)
; AVX2-NEXT:    vmovd %xmm0, (%rdi)
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v7i8_v2i16_2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    movl (%rsi), %eax
; AVX512-NEXT:    vmovd %eax, %xmm0
; AVX512-NEXT:    movq (%rdi), %rcx
; AVX512-NEXT:    vmovq %rcx, %xmm1
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; AVX512-NEXT:    shrq $48, %rcx
; AVX512-NEXT:    movb %cl, 6(%rdi)
; AVX512-NEXT:    shrl $16, %eax
; AVX512-NEXT:    movw %ax, 4(%rdi)
; AVX512-NEXT:    vmovd %xmm0, (%rdi)
; AVX512-NEXT:    retq
;
; XOP-LABEL: insert_v7i8_v2i16_2:
; XOP:       # %bb.0:
; XOP-NEXT:    movl (%rsi), %eax
; XOP-NEXT:    vmovd %eax, %xmm0
; XOP-NEXT:    movq (%rdi), %rcx
; XOP-NEXT:    vmovq %rcx, %xmm1
; XOP-NEXT:    insertq {{.*#+}} xmm1 = xmm1[0,1],xmm0[0,1,2,3],xmm1[6,7,u,u,u,u,u,u,u,u]
; XOP-NEXT:    shrq $48, %rcx
; XOP-NEXT:    movb %cl, 6(%rdi)
; XOP-NEXT:    shrl $16, %eax
; XOP-NEXT:    movw %ax, 4(%rdi)
; XOP-NEXT:    vmovd %xmm1, (%rdi)
; XOP-NEXT:    retq
  %1 = load <2 x i16>, <2 x i16> *%a1
  %2 = bitcast <2 x i16> %1 to <4 x i8>
  %3 = shufflevector <4 x i8> %2, <4 x i8> undef, <7 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef>
  %4 = load <7 x i8>, <7 x i8> *%a0
  %5 = shufflevector <7 x i8> %4, <7 x i8> %3, <7 x i32> <i32 0, i32 1, i32 7, i32 8, i32 9, i32 10, i32 6>
  store <7 x i8> %5, <7 x i8>* %a0
  ret void
}

%struct.Mat4 = type { %struct.storage }
%struct.storage = type { [16 x float] }

define void @PR40815(%struct.Mat4* nocapture readonly dereferenceable(64), %struct.Mat4* nocapture dereferenceable(64)) {
; SSE-LABEL: PR40815:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps 32(%rdi), %xmm2
; SSE-NEXT:    movaps 48(%rdi), %xmm3
; SSE-NEXT:    movaps %xmm3, (%rsi)
; SSE-NEXT:    movaps %xmm2, 16(%rsi)
; SSE-NEXT:    movaps %xmm1, 32(%rsi)
; SSE-NEXT:    movaps %xmm0, 48(%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: PR40815:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vmovaps 16(%rdi), %xmm1
; AVX-NEXT:    vmovaps 32(%rdi), %xmm2
; AVX-NEXT:    vmovaps 48(%rdi), %xmm3
; AVX-NEXT:    vmovaps %xmm2, 16(%rsi)
; AVX-NEXT:    vmovaps %xmm3, (%rsi)
; AVX-NEXT:    vmovaps %xmm0, 48(%rsi)
; AVX-NEXT:    vmovaps %xmm1, 32(%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: PR40815:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovaps 16(%rdi), %xmm0
; AVX512-NEXT:    vmovaps 48(%rdi), %xmm1
; AVX512-NEXT:    vinsertf128 $1, (%rdi), %ymm0, %ymm0
; AVX512-NEXT:    vinsertf128 $1, 32(%rdi), %ymm1, %ymm1
; AVX512-NEXT:    vinsertf64x4 $1, %ymm0, %zmm1, %zmm0
; AVX512-NEXT:    vmovups %zmm0, (%rsi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %3 = bitcast %struct.Mat4* %0 to <16 x float>*
  %4 = load <16 x float>, <16 x float>* %3, align 64
  %5 = shufflevector <16 x float> %4, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %6 = getelementptr inbounds %struct.Mat4, %struct.Mat4* %1, i64 0, i32 0, i32 0, i64 4
  %7 = bitcast <16 x float> %4 to <4 x i128>
  %8 = extractelement <4 x i128> %7, i32 1
  %9 = getelementptr inbounds %struct.Mat4, %struct.Mat4* %1, i64 0, i32 0, i32 0, i64 8
  %10 = bitcast <16 x float> %4 to <4 x i128>
  %11 = extractelement <4 x i128> %10, i32 2
  %12 = getelementptr inbounds %struct.Mat4, %struct.Mat4* %1, i64 0, i32 0, i32 0, i64 12
  %13 = bitcast float* %12 to <4 x float>*
  %14 = bitcast <16 x float> %4 to <4 x i128>
  %15 = extractelement <4 x i128> %14, i32 3
  %16 = bitcast %struct.Mat4* %1 to i128*
  store i128 %15, i128* %16, align 16
  %17 = bitcast float* %6 to i128*
  store i128 %11, i128* %17, align 16
  %18 = bitcast float* %9 to i128*
  store i128 %8, i128* %18, align 16
  store <4 x float> %5, <4 x float>* %13, align 16
  ret void
}

define <16 x i32> @PR42819(<8 x i32>* %a0) {
; SSE-LABEL: PR42819:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqu (%rdi), %xmm3
; SSE-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,xmm3[0,1,2,3,4,5,6,7,8,9,10,11]
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    xorps %xmm2, %xmm2
; SSE-NEXT:    retq
;
; AVX-LABEL: PR42819:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = mem[0,0,1,2]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1,2,3,4],ymm0[5,6,7]
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: PR42819:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu (%rdi), %xmm0
; AVX512-NEXT:    movw $-8192, %ax # imm = 0xE000
; AVX512-NEXT:    kmovw %eax, %k1
; AVX512-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; AVX512-NEXT:    retq
  %1 = load <8 x i32>, <8 x i32>* %a0, align 4
  %2 = shufflevector <8 x i32> %1, <8 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %3 = shufflevector <16 x i32> zeroinitializer, <16 x i32> %2, <16 x i32> <i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18>
  ret <16 x i32> %3
}

@b = dso_local local_unnamed_addr global i32 0, align 4
@c = dso_local local_unnamed_addr global [49 x i32] zeroinitializer, align 16
@d = dso_local local_unnamed_addr global [49 x i32] zeroinitializer, align 16

define void @PR42833() {
; SSE2-LABEL: PR42833:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm1
; SSE2-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    addl .Lb${{.*}}(%rip), %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    movaps {{.*#+}} xmm3 = <u,1,1,1>
; SSE2-NEXT:    movss {{.*#+}} xmm3 = xmm2[0],xmm3[1,2,3]
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    paddd %xmm3, %xmm4
; SSE2-NEXT:    pslld $23, %xmm3
; SSE2-NEXT:    paddd {{.*}}(%rip), %xmm3
; SSE2-NEXT:    cvttps2dq %xmm3, %xmm3
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    pmuludq %xmm3, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm6 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm3, %xmm6
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm6[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm5 = xmm5[0],xmm3[0],xmm5[1],xmm3[1]
; SSE2-NEXT:    movss {{.*#+}} xmm5 = xmm4[0],xmm5[1,2,3]
; SSE2-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm3
; SSE2-NEXT:    psubd %xmm1, %xmm3
; SSE2-NEXT:    paddd %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm1, .Lc$local+{{.*}}(%rip)
; SSE2-NEXT:    movaps %xmm5, .Lc$local+{{.*}}(%rip)
; SSE2-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm1
; SSE2-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm4
; SSE2-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm5
; SSE2-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm6
; SSE2-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm7
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm2[0],xmm0[1,2,3]
; SSE2-NEXT:    psubd %xmm0, %xmm7
; SSE2-NEXT:    psubd %xmm4, %xmm6
; SSE2-NEXT:    psubd %xmm1, %xmm5
; SSE2-NEXT:    movdqa %xmm5, .Ld$local+{{.*}}(%rip)
; SSE2-NEXT:    movdqa %xmm6, .Ld$local+{{.*}}(%rip)
; SSE2-NEXT:    movdqa %xmm3, .Ld$local+{{.*}}(%rip)
; SSE2-NEXT:    movdqa %xmm7, .Ld$local+{{.*}}(%rip)
; SSE2-NEXT:    paddd %xmm4, %xmm4
; SSE2-NEXT:    paddd %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm1, .Lc$local+{{.*}}(%rip)
; SSE2-NEXT:    movdqa %xmm4, .Lc$local+{{.*}}(%rip)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: PR42833:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm1
; SSE42-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm0
; SSE42-NEXT:    movd %xmm0, %eax
; SSE42-NEXT:    addl .Lb${{.*}}(%rip), %eax
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = <u,1,1,1>
; SSE42-NEXT:    pinsrd $0, %eax, %xmm2
; SSE42-NEXT:    movdqa %xmm0, %xmm3
; SSE42-NEXT:    paddd %xmm2, %xmm3
; SSE42-NEXT:    pslld $23, %xmm2
; SSE42-NEXT:    paddd {{.*}}(%rip), %xmm2
; SSE42-NEXT:    cvttps2dq %xmm2, %xmm2
; SSE42-NEXT:    pmulld %xmm0, %xmm2
; SSE42-NEXT:    pblendw {{.*#+}} xmm2 = xmm3[0,1],xmm2[2,3,4,5,6,7]
; SSE42-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm3
; SSE42-NEXT:    psubd %xmm1, %xmm3
; SSE42-NEXT:    paddd %xmm1, %xmm1
; SSE42-NEXT:    movdqa %xmm1, .Lc$local+{{.*}}(%rip)
; SSE42-NEXT:    movdqa %xmm2, .Lc$local+{{.*}}(%rip)
; SSE42-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm1
; SSE42-NEXT:    movdqa .Lc$local+{{.*}}(%rip), %xmm2
; SSE42-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm4
; SSE42-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm5
; SSE42-NEXT:    movdqa .Ld$local+{{.*}}(%rip), %xmm6
; SSE42-NEXT:    pinsrd $0, %eax, %xmm0
; SSE42-NEXT:    psubd %xmm0, %xmm6
; SSE42-NEXT:    psubd %xmm2, %xmm5
; SSE42-NEXT:    psubd %xmm1, %xmm4
; SSE42-NEXT:    movdqa %xmm4, .Ld$local+{{.*}}(%rip)
; SSE42-NEXT:    movdqa %xmm5, .Ld$local+{{.*}}(%rip)
; SSE42-NEXT:    movdqa %xmm3, .Ld$local+{{.*}}(%rip)
; SSE42-NEXT:    movdqa %xmm6, .Ld$local+{{.*}}(%rip)
; SSE42-NEXT:    paddd %xmm2, %xmm2
; SSE42-NEXT:    paddd %xmm1, %xmm1
; SSE42-NEXT:    movdqa %xmm1, .Lc$local+{{.*}}(%rip)
; SSE42-NEXT:    movdqa %xmm2, .Lc$local+{{.*}}(%rip)
; SSE42-NEXT:    retq
;
; AVX1-LABEL: PR42833:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    addl .Lb${{.*}}(%rip), %eax
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = <u,1,1,1>
; AVX1-NEXT:    vpinsrd $0, %eax, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm3
; AVX1-NEXT:    vpslld $23, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vcvttps2dq %xmm1, %xmm1
; AVX1-NEXT:    vpmulld %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpslld $1, %xmm3, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm1
; AVX1-NEXT:    vblendps {{.*#+}} ymm1 = ymm2[0],ymm1[1,2,3,4,5,6,7]
; AVX1-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm2
; AVX1-NEXT:    vpsubd .Lc$local+{{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmovups %ymm1, .Lc$local+{{.*}}(%rip)
; AVX1-NEXT:    vpinsrd $0, %eax, %xmm0, %xmm0
; AVX1-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm1
; AVX1-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm1
; AVX1-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm3
; AVX1-NEXT:    vpsubd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm4
; AVX1-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm5
; AVX1-NEXT:    vpsubd %xmm5, %xmm4, %xmm4
; AVX1-NEXT:    vmovdqa %xmm2, .Ld$local+{{.*}}(%rip)
; AVX1-NEXT:    vmovdqa %xmm4, .Ld$local+{{.*}}(%rip)
; AVX1-NEXT:    vmovdqa %xmm1, .Ld$local+{{.*}}(%rip)
; AVX1-NEXT:    vmovdqa %xmm0, .Ld$local+{{.*}}(%rip)
; AVX1-NEXT:    vpaddd %xmm3, %xmm3, %xmm0
; AVX1-NEXT:    vpaddd %xmm5, %xmm5, %xmm1
; AVX1-NEXT:    vmovdqa %xmm1, .Lc$local+{{.*}}(%rip)
; AVX1-NEXT:    vmovdqa %xmm0, .Lc$local+{{.*}}(%rip)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: PR42833:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movl .Lb${{.*}}(%rip), %eax
; AVX2-NEXT:    vmovdqu .Lc$local+{{.*}}(%rip), %ymm0
; AVX2-NEXT:    addl .Lc$local+{{.*}}(%rip), %eax
; AVX2-NEXT:    vmovd %eax, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm2 = ymm1[0],mem[1,2,3,4,5,6,7]
; AVX2-NEXT:    vpaddd %ymm2, %ymm0, %ymm3
; AVX2-NEXT:    vpsllvd %ymm2, %ymm0, %ymm2
; AVX2-NEXT:    vpblendd {{.*#+}} ymm2 = ymm3[0],ymm2[1,2,3,4,5,6,7]
; AVX2-NEXT:    vmovdqu %ymm2, .Lc$local+{{.*}}(%rip)
; AVX2-NEXT:    vmovdqu .Lc$local+{{.*}}(%rip), %ymm2
; AVX2-NEXT:    vmovdqu .Ld$local+{{.*}}(%rip), %ymm3
; AVX2-NEXT:    vmovdqu .Ld$local+{{.*}}(%rip), %ymm4
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5,6,7]
; AVX2-NEXT:    vpsubd %ymm0, %ymm4, %ymm0
; AVX2-NEXT:    vpsubd %ymm2, %ymm3, %ymm1
; AVX2-NEXT:    vmovdqu %ymm1, .Ld$local+{{.*}}(%rip)
; AVX2-NEXT:    vmovdqu %ymm0, .Ld$local+{{.*}}(%rip)
; AVX2-NEXT:    vpaddd %ymm2, %ymm2, %ymm0
; AVX2-NEXT:    vmovdqu %ymm0, .Lc$local+{{.*}}(%rip)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: PR42833:
; AVX512:       # %bb.0:
; AVX512-NEXT:    movl .Lb${{.*}}(%rip), %eax
; AVX512-NEXT:    vmovdqu .Lc$local+{{.*}}(%rip), %ymm0
; AVX512-NEXT:    vmovdqu64 .Lc$local+{{.*}}(%rip), %zmm1
; AVX512-NEXT:    addl .Lc$local+{{.*}}(%rip), %eax
; AVX512-NEXT:    vmovd %eax, %xmm2
; AVX512-NEXT:    vpblendd {{.*#+}} ymm2 = ymm2[0],mem[1,2,3,4,5,6,7]
; AVX512-NEXT:    vpaddd %ymm2, %ymm0, %ymm3
; AVX512-NEXT:    vpsllvd %ymm2, %ymm0, %ymm0
; AVX512-NEXT:    vpblendd {{.*#+}} ymm0 = ymm3[0],ymm0[1,2,3,4,5,6,7]
; AVX512-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm2
; AVX512-NEXT:    vmovdqu %ymm0, .Lc$local+{{.*}}(%rip)
; AVX512-NEXT:    vmovdqu .Lc$local+{{.*}}(%rip), %ymm0
; AVX512-NEXT:    vmovdqu64 .Ld$local+{{.*}}(%rip), %zmm3
; AVX512-NEXT:    vpinsrd $0, %eax, %xmm2, %xmm2
; AVX512-NEXT:    vinserti32x4 $0, %xmm2, %zmm1, %zmm1
; AVX512-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm1
; AVX512-NEXT:    vpsubd %zmm1, %zmm3, %zmm1
; AVX512-NEXT:    vmovdqu64 %zmm1, .Ld$local+{{.*}}(%rip)
; AVX512-NEXT:    vpaddd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vmovdqu %ymm0, .Lc$local+{{.*}}(%rip)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; XOP-LABEL: PR42833:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm0
; XOP-NEXT:    vmovd %xmm0, %eax
; XOP-NEXT:    addl .Lb${{.*}}(%rip), %eax
; XOP-NEXT:    vmovdqa {{.*#+}} xmm1 = <u,1,1,1>
; XOP-NEXT:    vpinsrd $0, %eax, %xmm1, %xmm1
; XOP-NEXT:    vpaddd %xmm1, %xmm0, %xmm2
; XOP-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm3
; XOP-NEXT:    vpshld %xmm1, %xmm0, %xmm1
; XOP-NEXT:    vpslld $1, %xmm3, %xmm3
; XOP-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm1
; XOP-NEXT:    vblendps {{.*#+}} ymm1 = ymm2[0],ymm1[1,2,3,4,5,6,7]
; XOP-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm2
; XOP-NEXT:    vpsubd .Lc$local+{{.*}}(%rip), %xmm2, %xmm2
; XOP-NEXT:    vmovups %ymm1, .Lc$local+{{.*}}(%rip)
; XOP-NEXT:    vpinsrd $0, %eax, %xmm0, %xmm0
; XOP-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm1
; XOP-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; XOP-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm1
; XOP-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm3
; XOP-NEXT:    vpsubd %xmm3, %xmm1, %xmm1
; XOP-NEXT:    vmovdqa .Ld$local+{{.*}}(%rip), %xmm4
; XOP-NEXT:    vmovdqa .Lc$local+{{.*}}(%rip), %xmm5
; XOP-NEXT:    vpsubd %xmm5, %xmm4, %xmm4
; XOP-NEXT:    vmovdqa %xmm2, .Ld$local+{{.*}}(%rip)
; XOP-NEXT:    vmovdqa %xmm4, .Ld$local+{{.*}}(%rip)
; XOP-NEXT:    vmovdqa %xmm1, .Ld$local+{{.*}}(%rip)
; XOP-NEXT:    vmovdqa %xmm0, .Ld$local+{{.*}}(%rip)
; XOP-NEXT:    vpaddd %xmm3, %xmm3, %xmm0
; XOP-NEXT:    vpaddd %xmm5, %xmm5, %xmm1
; XOP-NEXT:    vmovdqa %xmm1, .Lc$local+{{.*}}(%rip)
; XOP-NEXT:    vmovdqa %xmm0, .Lc$local+{{.*}}(%rip)
; XOP-NEXT:    vzeroupper
; XOP-NEXT:    retq
  %1 = load i32, i32* @b, align 4
  %2 = load <8 x i32>, <8 x i32>* bitcast (i32* getelementptr inbounds ([49 x i32], [49 x i32]* @c, i64 0, i64 32) to <8 x i32>*), align 16
  %3 = shufflevector <8 x i32> %2, <8 x i32> undef, <16 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %4 = extractelement <8 x i32> %2, i32 0
  %5 = add i32 %1, %4
  %6 = insertelement <8 x i32> <i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, i32 %5, i32 0
  %7 = add <8 x i32> %2, %6
  %8 = shl <8 x i32> %2, %6
  %9 = shufflevector <8 x i32> %7, <8 x i32> %8, <8 x i32> <i32 0, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <8 x i32> %9, <8 x i32>* bitcast (i32* getelementptr inbounds ([49 x i32], [49 x i32]* @c, i64 0, i64 32) to <8 x i32>*), align 16
  %10 = load <8 x i32>, <8 x i32>* bitcast (i32* getelementptr inbounds ([49 x i32], [49 x i32]* @c, i64 0, i64 40) to <8 x i32>*), align 16
  %11 = shufflevector <8 x i32> %10, <8 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %12 = load <16 x i32>, <16 x i32>* bitcast (i32* getelementptr inbounds ([49 x i32], [49 x i32]* @d, i64 0, i64 32) to <16 x i32>*), align 16
  %13 = insertelement <16 x i32> %3, i32 %5, i32 0
  %14 = shufflevector <16 x i32> %13, <16 x i32> %11, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %15 = sub <16 x i32> %12, %14
  store <16 x i32> %15, <16 x i32>* bitcast (i32* getelementptr inbounds ([49 x i32], [49 x i32]* @d, i64 0, i64 32) to <16 x i32>*), align 16
  %16 = shl <8 x i32> %10, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  store <8 x i32> %16, <8 x i32>* bitcast (i32* getelementptr inbounds ([49 x i32], [49 x i32]* @c, i64 0, i64 40) to <8 x i32>*), align 16
  ret void
}
