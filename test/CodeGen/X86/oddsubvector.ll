; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f | FileCheck %s --check-prefix=AVX512
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefix=AVX512
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f,+fast-variable-perlane-shuffle | FileCheck %s --check-prefix=AVX512
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+xop | FileCheck %s --check-prefixes=AVX,XOP

define void @insert_v7i8_v2i16_2(ptr%a0, ptr%a1) nounwind {
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
; AVX-LABEL: insert_v7i8_v2i16_2:
; AVX:       # %bb.0:
; AVX-NEXT:    movl (%rsi), %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    movq (%rdi), %rcx
; AVX-NEXT:    vmovq %rcx, %xmm1
; AVX-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; AVX-NEXT:    shrq $48, %rcx
; AVX-NEXT:    movb %cl, 6(%rdi)
; AVX-NEXT:    shrl $16, %eax
; AVX-NEXT:    movw %ax, 4(%rdi)
; AVX-NEXT:    vmovd %xmm0, (%rdi)
; AVX-NEXT:    retq
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
  %1 = load <2 x i16>, ptr%a1
  %2 = bitcast <2 x i16> %1 to <4 x i8>
  %3 = shufflevector <4 x i8> %2, <4 x i8> undef, <7 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef>
  %4 = load <7 x i8>, ptr%a0
  %5 = shufflevector <7 x i8> %4, <7 x i8> %3, <7 x i32> <i32 0, i32 1, i32 7, i32 8, i32 9, i32 10, i32 6>
  store <7 x i8> %5, ptr %a0
  ret void
}

%struct.Mat4 = type { %struct.storage }
%struct.storage = type { [16 x float] }

define void @PR40815(ptr nocapture readonly dereferenceable(64), ptr nocapture dereferenceable(64)) {
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
; AVX512-NEXT:    vmovaps 48(%rdi), %xmm0
; AVX512-NEXT:    vmovups 16(%rdi), %ymm1
; AVX512-NEXT:    vinsertf128 $1, (%rdi), %ymm1, %ymm1
; AVX512-NEXT:    vinsertf128 $1, 32(%rdi), %ymm0, %ymm0
; AVX512-NEXT:    vinsertf64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovups %zmm0, (%rsi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %3 = load <16 x float>, ptr %0, align 64
  %4 = shufflevector <16 x float> %3, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %5 = getelementptr inbounds %struct.Mat4, ptr %1, i64 0, i32 0, i32 0, i64 4
  %6 = bitcast <16 x float> %3 to <4 x i128>
  %7 = extractelement <4 x i128> %6, i32 1
  %8 = getelementptr inbounds %struct.Mat4, ptr %1, i64 0, i32 0, i32 0, i64 8
  %9 = bitcast <16 x float> %3 to <4 x i128>
  %10 = extractelement <4 x i128> %9, i32 2
  %11 = getelementptr inbounds %struct.Mat4, ptr %1, i64 0, i32 0, i32 0, i64 12
  %12 = bitcast <16 x float> %3 to <4 x i128>
  %13 = extractelement <4 x i128> %12, i32 3
  store i128 %13, ptr %1, align 16
  store i128 %10, ptr %5, align 16
  store i128 %7, ptr %8, align 16
  store <4 x float> %4, ptr %11, align 16
  ret void
}

define <16 x i32> @PR42819(ptr %a0) {
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
; AVX512-NEXT:    vmovdqu (%rdi), %ymm0
; AVX512-NEXT:    movw $-8192, %ax # imm = 0xE000
; AVX512-NEXT:    kmovw %eax, %k1
; AVX512-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; AVX512-NEXT:    retq
  %1 = load <8 x i32>, ptr %a0, align 4
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
; SSE2-NEXT:    movl b(%rip), %eax
; SSE2-NEXT:    movdqa c+144(%rip), %xmm0
; SSE2-NEXT:    movdqa c+128(%rip), %xmm1
; SSE2-NEXT:    addl c+128(%rip), %eax
; SSE2-NEXT:    movd %eax, %xmm2
; SSE2-NEXT:    movd %eax, %xmm3
; SSE2-NEXT:    paddd %xmm1, %xmm3
; SSE2-NEXT:    movdqa d+144(%rip), %xmm4
; SSE2-NEXT:    psubd %xmm0, %xmm4
; SSE2-NEXT:    paddd %xmm0, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm5
; SSE2-NEXT:    paddd %xmm1, %xmm5
; SSE2-NEXT:    movss {{.*#+}} xmm5 = xmm3[0],xmm5[1,2,3]
; SSE2-NEXT:    movdqa %xmm0, c+144(%rip)
; SSE2-NEXT:    movaps %xmm5, c+128(%rip)
; SSE2-NEXT:    movdqa c+160(%rip), %xmm0
; SSE2-NEXT:    movdqa c+176(%rip), %xmm3
; SSE2-NEXT:    movdqa d+160(%rip), %xmm5
; SSE2-NEXT:    movdqa d+176(%rip), %xmm6
; SSE2-NEXT:    movdqa d+128(%rip), %xmm7
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm2[0],xmm1[1,2,3]
; SSE2-NEXT:    psubd %xmm1, %xmm7
; SSE2-NEXT:    psubd %xmm3, %xmm6
; SSE2-NEXT:    psubd %xmm0, %xmm5
; SSE2-NEXT:    movdqa %xmm5, d+160(%rip)
; SSE2-NEXT:    movdqa %xmm6, d+176(%rip)
; SSE2-NEXT:    movdqa %xmm4, d+144(%rip)
; SSE2-NEXT:    movdqa %xmm7, d+128(%rip)
; SSE2-NEXT:    paddd %xmm3, %xmm3
; SSE2-NEXT:    paddd %xmm0, %xmm0
; SSE2-NEXT:    movdqa %xmm0, c+160(%rip)
; SSE2-NEXT:    movdqa %xmm3, c+176(%rip)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: PR42833:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movl b(%rip), %eax
; SSE42-NEXT:    movdqa c+144(%rip), %xmm0
; SSE42-NEXT:    movdqa c+128(%rip), %xmm1
; SSE42-NEXT:    addl c+128(%rip), %eax
; SSE42-NEXT:    movd %eax, %xmm2
; SSE42-NEXT:    paddd %xmm1, %xmm2
; SSE42-NEXT:    movdqa d+144(%rip), %xmm3
; SSE42-NEXT:    psubd %xmm0, %xmm3
; SSE42-NEXT:    paddd %xmm0, %xmm0
; SSE42-NEXT:    movdqa %xmm1, %xmm4
; SSE42-NEXT:    paddd %xmm1, %xmm4
; SSE42-NEXT:    pblendw {{.*#+}} xmm4 = xmm2[0,1],xmm4[2,3,4,5,6,7]
; SSE42-NEXT:    movdqa %xmm0, c+144(%rip)
; SSE42-NEXT:    movdqa %xmm4, c+128(%rip)
; SSE42-NEXT:    movdqa c+160(%rip), %xmm0
; SSE42-NEXT:    movdqa c+176(%rip), %xmm2
; SSE42-NEXT:    movdqa d+160(%rip), %xmm4
; SSE42-NEXT:    movdqa d+176(%rip), %xmm5
; SSE42-NEXT:    movdqa d+128(%rip), %xmm6
; SSE42-NEXT:    pinsrd $0, %eax, %xmm1
; SSE42-NEXT:    psubd %xmm1, %xmm6
; SSE42-NEXT:    psubd %xmm2, %xmm5
; SSE42-NEXT:    psubd %xmm0, %xmm4
; SSE42-NEXT:    movdqa %xmm4, d+160(%rip)
; SSE42-NEXT:    movdqa %xmm5, d+176(%rip)
; SSE42-NEXT:    movdqa %xmm3, d+144(%rip)
; SSE42-NEXT:    movdqa %xmm6, d+128(%rip)
; SSE42-NEXT:    paddd %xmm2, %xmm2
; SSE42-NEXT:    paddd %xmm0, %xmm0
; SSE42-NEXT:    movdqa %xmm0, c+160(%rip)
; SSE42-NEXT:    movdqa %xmm2, c+176(%rip)
; SSE42-NEXT:    retq
;
; AVX1-LABEL: PR42833:
; AVX1:       # %bb.0:
; AVX1-NEXT:    movl b(%rip), %eax
; AVX1-NEXT:    addl c+128(%rip), %eax
; AVX1-NEXT:    vmovd %eax, %xmm0
; AVX1-NEXT:    vmovdqa c+128(%rip), %xmm1
; AVX1-NEXT:    vpaddd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vpaddd %xmm1, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa c+144(%rip), %xmm3
; AVX1-NEXT:    vpaddd %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0],ymm2[1,2,3,4,5,6,7]
; AVX1-NEXT:    vmovdqa d+144(%rip), %xmm2
; AVX1-NEXT:    vpsubd c+144(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmovups %ymm0, c+128(%rip)
; AVX1-NEXT:    vpinsrd $0, %eax, %xmm1, %xmm0
; AVX1-NEXT:    vmovdqa d+128(%rip), %xmm1
; AVX1-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vmovdqa d+176(%rip), %xmm1
; AVX1-NEXT:    vmovdqa c+176(%rip), %xmm3
; AVX1-NEXT:    vpsubd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa d+160(%rip), %xmm4
; AVX1-NEXT:    vmovdqa c+160(%rip), %xmm5
; AVX1-NEXT:    vpsubd %xmm5, %xmm4, %xmm4
; AVX1-NEXT:    vmovdqa %xmm2, d+144(%rip)
; AVX1-NEXT:    vmovdqa %xmm4, d+160(%rip)
; AVX1-NEXT:    vmovdqa %xmm1, d+176(%rip)
; AVX1-NEXT:    vmovdqa %xmm0, d+128(%rip)
; AVX1-NEXT:    vpaddd %xmm3, %xmm3, %xmm0
; AVX1-NEXT:    vpaddd %xmm5, %xmm5, %xmm1
; AVX1-NEXT:    vmovdqa %xmm1, c+160(%rip)
; AVX1-NEXT:    vmovdqa %xmm0, c+176(%rip)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: PR42833:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movl b(%rip), %eax
; AVX2-NEXT:    vmovdqu c+128(%rip), %ymm0
; AVX2-NEXT:    addl c+128(%rip), %eax
; AVX2-NEXT:    vmovd %eax, %xmm1
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vpaddd %ymm0, %ymm0, %ymm3
; AVX2-NEXT:    vpblendd {{.*#+}} ymm2 = ymm2[0],ymm3[1,2,3,4,5,6,7]
; AVX2-NEXT:    vmovdqu %ymm2, c+128(%rip)
; AVX2-NEXT:    vmovdqu c+160(%rip), %ymm2
; AVX2-NEXT:    vmovdqu d+160(%rip), %ymm3
; AVX2-NEXT:    vmovdqu d+128(%rip), %ymm4
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5,6,7]
; AVX2-NEXT:    vpsubd %ymm0, %ymm4, %ymm0
; AVX2-NEXT:    vpsubd %ymm2, %ymm3, %ymm1
; AVX2-NEXT:    vmovdqu %ymm1, d+160(%rip)
; AVX2-NEXT:    vmovdqu %ymm0, d+128(%rip)
; AVX2-NEXT:    vpaddd %ymm2, %ymm2, %ymm0
; AVX2-NEXT:    vmovdqu %ymm0, c+160(%rip)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: PR42833:
; AVX512:       # %bb.0:
; AVX512-NEXT:    movl b(%rip), %eax
; AVX512-NEXT:    vmovdqu c+128(%rip), %ymm0
; AVX512-NEXT:    vmovdqu64 c+128(%rip), %zmm1
; AVX512-NEXT:    addl c+128(%rip), %eax
; AVX512-NEXT:    vmovd %eax, %xmm2
; AVX512-NEXT:    vpaddd %ymm2, %ymm0, %ymm2
; AVX512-NEXT:    vpaddd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vpblendd {{.*#+}} ymm0 = ymm2[0],ymm0[1,2,3,4,5,6,7]
; AVX512-NEXT:    vmovdqa c+128(%rip), %xmm2
; AVX512-NEXT:    vmovdqu %ymm0, c+128(%rip)
; AVX512-NEXT:    vmovdqu c+160(%rip), %ymm0
; AVX512-NEXT:    vmovdqu64 d+128(%rip), %zmm3
; AVX512-NEXT:    vpinsrd $0, %eax, %xmm2, %xmm2
; AVX512-NEXT:    vinserti32x4 $0, %xmm2, %zmm1, %zmm1
; AVX512-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm1
; AVX512-NEXT:    vpsubd %zmm1, %zmm3, %zmm1
; AVX512-NEXT:    vmovdqu64 %zmm1, d+128(%rip)
; AVX512-NEXT:    vpaddd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vmovdqu %ymm0, c+160(%rip)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
;
; XOP-LABEL: PR42833:
; XOP:       # %bb.0:
; XOP-NEXT:    movl b(%rip), %eax
; XOP-NEXT:    addl c+128(%rip), %eax
; XOP-NEXT:    vmovd %eax, %xmm0
; XOP-NEXT:    vmovdqa c+128(%rip), %xmm1
; XOP-NEXT:    vpaddd %xmm0, %xmm1, %xmm0
; XOP-NEXT:    vpaddd %xmm1, %xmm1, %xmm2
; XOP-NEXT:    vmovdqa c+144(%rip), %xmm3
; XOP-NEXT:    vpaddd %xmm3, %xmm3, %xmm3
; XOP-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; XOP-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0],ymm2[1,2,3,4,5,6,7]
; XOP-NEXT:    vmovdqa d+144(%rip), %xmm2
; XOP-NEXT:    vpsubd c+144(%rip), %xmm2, %xmm2
; XOP-NEXT:    vmovups %ymm0, c+128(%rip)
; XOP-NEXT:    vpinsrd $0, %eax, %xmm1, %xmm0
; XOP-NEXT:    vmovdqa d+128(%rip), %xmm1
; XOP-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; XOP-NEXT:    vmovdqa d+176(%rip), %xmm1
; XOP-NEXT:    vmovdqa c+176(%rip), %xmm3
; XOP-NEXT:    vpsubd %xmm3, %xmm1, %xmm1
; XOP-NEXT:    vmovdqa d+160(%rip), %xmm4
; XOP-NEXT:    vmovdqa c+160(%rip), %xmm5
; XOP-NEXT:    vpsubd %xmm5, %xmm4, %xmm4
; XOP-NEXT:    vmovdqa %xmm2, d+144(%rip)
; XOP-NEXT:    vmovdqa %xmm4, d+160(%rip)
; XOP-NEXT:    vmovdqa %xmm1, d+176(%rip)
; XOP-NEXT:    vmovdqa %xmm0, d+128(%rip)
; XOP-NEXT:    vpaddd %xmm3, %xmm3, %xmm0
; XOP-NEXT:    vpaddd %xmm5, %xmm5, %xmm1
; XOP-NEXT:    vmovdqa %xmm1, c+160(%rip)
; XOP-NEXT:    vmovdqa %xmm0, c+176(%rip)
; XOP-NEXT:    vzeroupper
; XOP-NEXT:    retq
  %1 = load i32, ptr @b, align 4
  %2 = load <8 x i32>, ptr getelementptr inbounds ([49 x i32], ptr @c, i64 0, i64 32), align 16
  %3 = shufflevector <8 x i32> %2, <8 x i32> undef, <16 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %4 = extractelement <8 x i32> %2, i32 0
  %5 = add i32 %1, %4
  %6 = insertelement <8 x i32> <i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, i32 %5, i32 0
  %7 = add <8 x i32> %2, %6
  %8 = shl <8 x i32> %2, %6
  %9 = shufflevector <8 x i32> %7, <8 x i32> %8, <8 x i32> <i32 0, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <8 x i32> %9, ptr getelementptr inbounds ([49 x i32], ptr @c, i64 0, i64 32), align 16
  %10 = load <8 x i32>, ptr getelementptr inbounds ([49 x i32], ptr @c, i64 0, i64 40), align 16
  %11 = shufflevector <8 x i32> %10, <8 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %12 = load <16 x i32>, ptr getelementptr inbounds ([49 x i32], ptr @d, i64 0, i64 32), align 16
  %13 = insertelement <16 x i32> %3, i32 %5, i32 0
  %14 = shufflevector <16 x i32> %13, <16 x i32> %11, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %15 = sub <16 x i32> %12, %14
  store <16 x i32> %15, ptr getelementptr inbounds ([49 x i32], ptr @d, i64 0, i64 32), align 16
  %16 = shl <8 x i32> %10, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  store <8 x i32> %16, ptr getelementptr inbounds ([49 x i32], ptr @c, i64 0, i64 40), align 16
  ret void
}
