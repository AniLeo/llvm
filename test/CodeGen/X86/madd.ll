; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX512

define i32 @_Z10test_shortPsS_i(i16* nocapture readonly, i16* nocapture readonly, i32) local_unnamed_addr #0 {
; SSE2-LABEL: _Z10test_shortPsS_i:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movl %edx, %eax
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB0_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movdqu (%rdi), %xmm2
; SSE2-NEXT:    movdqu (%rsi), %xmm3
; SSE2-NEXT:    pmaddwd %xmm2, %xmm3
; SSE2-NEXT:    paddd %xmm3, %xmm1
; SSE2-NEXT:    addq $16, %rsi
; SSE2-NEXT:    addq $16, %rdi
; SSE2-NEXT:    addq $-8, %rax
; SSE2-NEXT:    jne .LBB0_1
; SSE2-NEXT:  # BB#2: # %middle.block
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: _Z10test_shortPsS_i:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    vpxor %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB0_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vmovdqu (%rsi), %xmm2
; AVX2-NEXT:    vpmaddwd (%rdi), %xmm2, %xmm2
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm2, %ymm2
; AVX2-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    addq $16, %rsi
; AVX2-NEXT:    addq $16, %rdi
; AVX2-NEXT:    addq $-8, %rax
; AVX2-NEXT:    jne .LBB0_1
; AVX2-NEXT:  # BB#2: # %middle.block
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: _Z10test_shortPsS_i:
; AVX512:       # BB#0: # %entry
; AVX512-NEXT:    movl %edx, %eax
; AVX512-NEXT:    vpxor %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512-NEXT:    .p2align 4, 0x90
; AVX512-NEXT:  .LBB0_1: # %vector.body
; AVX512-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512-NEXT:    vmovdqu (%rsi), %xmm2
; AVX512-NEXT:    vpmaddwd (%rdi), %xmm2, %xmm2
; AVX512-NEXT:    vinserti128 $1, %xmm1, %ymm2, %ymm2
; AVX512-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; AVX512-NEXT:    addq $16, %rsi
; AVX512-NEXT:    addq $16, %rdi
; AVX512-NEXT:    addq $-8, %rax
; AVX512-NEXT:    jne .LBB0_1
; AVX512-NEXT:  # BB#2: # %middle.block
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vmovd %xmm0, %eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <8 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i16, i16* %0, i64 %index
  %5 = bitcast i16* %4 to <8 x i16>*
  %wide.load = load <8 x i16>, <8 x i16>* %5, align 2
  %6 = sext <8 x i16> %wide.load to <8 x i32>
  %7 = getelementptr inbounds i16, i16* %1, i64 %index
  %8 = bitcast i16* %7 to <8 x i16>*
  %wide.load14 = load <8 x i16>, <8 x i16>* %8, align 2
  %9 = sext <8 x i16> %wide.load14 to <8 x i32>
  %10 = mul nsw <8 x i32> %9, %6
  %11 = add nsw <8 x i32> %10, %vec.phi
  %index.next = add i64 %index, 8
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf = shufflevector <8 x i32> %11, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %11, %rdx.shuf
  %rdx.shuf15 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx16 = add <8 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <8 x i32> %bin.rdx16, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <8 x i32> %bin.rdx16, %rdx.shuf17
  %13 = extractelement <8 x i32> %bin.rdx18, i32 0
  ret i32 %13
}

define i32 @test_unsigned_short(i16* nocapture readonly, i16* nocapture readonly, i32) local_unnamed_addr #0 {
; SSE2-LABEL: test_unsigned_short:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movl %edx, %eax
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB1_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movdqu (%rdi), %xmm2
; SSE2-NEXT:    movdqu (%rsi), %xmm3
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    pmulhuw %xmm2, %xmm4
; SSE2-NEXT:    pmullw %xmm2, %xmm3
; SSE2-NEXT:    movdqa %xmm3, %xmm2
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm4[0],xmm2[1],xmm4[1],xmm2[2],xmm4[2],xmm2[3],xmm4[3]
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm3 = xmm3[4],xmm4[4],xmm3[5],xmm4[5],xmm3[6],xmm4[6],xmm3[7],xmm4[7]
; SSE2-NEXT:    paddd %xmm3, %xmm1
; SSE2-NEXT:    paddd %xmm2, %xmm0
; SSE2-NEXT:    addq $16, %rsi
; SSE2-NEXT:    addq $16, %rdi
; SSE2-NEXT:    addq $-8, %rax
; SSE2-NEXT:    jne .LBB1_1
; SSE2-NEXT:  # BB#2: # %middle.block
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: test_unsigned_short:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    vpxor %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB1_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovzxwd {{.*#+}} ymm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX2-NEXT:    vpmovzxwd {{.*#+}} ymm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX2-NEXT:    vpmulld %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    addq $16, %rsi
; AVX2-NEXT:    addq $16, %rdi
; AVX2-NEXT:    addq $-8, %rax
; AVX2-NEXT:    jne .LBB1_1
; AVX2-NEXT:  # BB#2: # %middle.block
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_unsigned_short:
; AVX512:       # BB#0: # %entry
; AVX512-NEXT:    movl %edx, %eax
; AVX512-NEXT:    vpxor %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    .p2align 4, 0x90
; AVX512-NEXT:  .LBB1_1: # %vector.body
; AVX512-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512-NEXT:    vpmovzxwd {{.*#+}} ymm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512-NEXT:    vpmovzxwd {{.*#+}} ymm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; AVX512-NEXT:    vpmulld %ymm1, %ymm2, %ymm1
; AVX512-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    addq $16, %rsi
; AVX512-NEXT:    addq $16, %rdi
; AVX512-NEXT:    addq $-8, %rax
; AVX512-NEXT:    jne .LBB1_1
; AVX512-NEXT:  # BB#2: # %middle.block
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX512-NEXT:    vmovd %xmm0, %eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <8 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i16, i16* %0, i64 %index
  %5 = bitcast i16* %4 to <8 x i16>*
  %wide.load = load <8 x i16>, <8 x i16>* %5, align 2
  %6 = zext <8 x i16> %wide.load to <8 x i32>
  %7 = getelementptr inbounds i16, i16* %1, i64 %index
  %8 = bitcast i16* %7 to <8 x i16>*
  %wide.load14 = load <8 x i16>, <8 x i16>* %8, align 2
  %9 = zext <8 x i16> %wide.load14 to <8 x i32>
  %10 = mul nsw <8 x i32> %9, %6
  %11 = add nsw <8 x i32> %10, %vec.phi
  %index.next = add i64 %index, 8
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf = shufflevector <8 x i32> %11, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %11, %rdx.shuf
  %rdx.shuf15 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx16 = add <8 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <8 x i32> %bin.rdx16, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <8 x i32> %bin.rdx16, %rdx.shuf17
  %13 = extractelement <8 x i32> %bin.rdx18, i32 0
  ret i32 %13
}

define i32 @_Z9test_charPcS_i(i8* nocapture readonly, i8* nocapture readonly, i32) local_unnamed_addr #0 {
; SSE2-LABEL: _Z9test_charPcS_i:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movl %edx, %eax
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pxor %xmm3, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm2
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB2_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movq {{.*#+}} xmm4 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm4 = xmm4[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm4
; SSE2-NEXT:    movq {{.*#+}} xmm5 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm5 = xmm5[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm5
; SSE2-NEXT:    pmullw %xmm4, %xmm5
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[1],xmm5[1],xmm4[2],xmm5[2],xmm4[3],xmm5[3]
; SSE2-NEXT:    psrad $16, %xmm4
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm5 = xmm5[4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psrad $16, %xmm5
; SSE2-NEXT:    movq {{.*#+}} xmm6 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm6 = xmm6[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm6
; SSE2-NEXT:    movq {{.*#+}} xmm7 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm7 = xmm7[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psraw $8, %xmm7
; SSE2-NEXT:    pmullw %xmm6, %xmm7
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm6 = xmm6[0],xmm7[0],xmm6[1],xmm7[1],xmm6[2],xmm7[2],xmm6[3],xmm7[3]
; SSE2-NEXT:    psrad $16, %xmm6
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm7 = xmm7[4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psrad $16, %xmm7
; SSE2-NEXT:    paddd %xmm7, %xmm2
; SSE2-NEXT:    paddd %xmm6, %xmm3
; SSE2-NEXT:    paddd %xmm5, %xmm1
; SSE2-NEXT:    paddd %xmm4, %xmm0
; SSE2-NEXT:    addq $16, %rsi
; SSE2-NEXT:    addq $16, %rdi
; SSE2-NEXT:    addq $-16, %rax
; SSE2-NEXT:    jne .LBB2_1
; SSE2-NEXT:  # BB#2: # %middle.block
; SSE2-NEXT:    paddd %xmm3, %xmm0
; SSE2-NEXT:    paddd %xmm2, %xmm1
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: _Z9test_charPcS_i:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    vpxor %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vpxor %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB2_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovsxbw (%rdi), %ymm2
; AVX2-NEXT:    vpmovsxbw (%rsi), %ymm3
; AVX2-NEXT:    vpmaddwd %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpaddd %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    addq $16, %rsi
; AVX2-NEXT:    addq $16, %rdi
; AVX2-NEXT:    addq $-16, %rax
; AVX2-NEXT:    jne .LBB2_1
; AVX2-NEXT:  # BB#2: # %middle.block
; AVX2-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: _Z9test_charPcS_i:
; AVX512:       # BB#0: # %entry
; AVX512-NEXT:    movl %edx, %eax
; AVX512-NEXT:    vpxord %zmm0, %zmm0, %zmm0
; AVX512-NEXT:    vpxor %ymm1, %ymm1, %ymm1
; AVX512-NEXT:    .p2align 4, 0x90
; AVX512-NEXT:  .LBB2_1: # %vector.body
; AVX512-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX512-NEXT:    vpmovsxbw (%rdi), %ymm2
; AVX512-NEXT:    vpmovsxbw (%rsi), %ymm3
; AVX512-NEXT:    vpmaddwd %ymm2, %ymm3, %ymm2
; AVX512-NEXT:    vinserti64x4 $1, %ymm1, %zmm2, %zmm2
; AVX512-NEXT:    vpaddd %zmm0, %zmm2, %zmm0
; AVX512-NEXT:    addq $16, %rsi
; AVX512-NEXT:    addq $16, %rdi
; AVX512-NEXT:    addq $-16, %rax
; AVX512-NEXT:    jne .LBB2_1
; AVX512-NEXT:  # BB#2: # %middle.block
; AVX512-NEXT:    vshufi64x2 {{.*#+}} zmm1 = zmm0[4,5,6,7,0,1,0,1]
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vshufi64x2 {{.*#+}} zmm1 = zmm0[2,3,0,1,0,1,0,1]
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpshufd {{.*#+}} zmm1 = zmm0[2,3,2,3,6,7,6,7,10,11,10,11,14,15,14,15]
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpshufd {{.*#+}} zmm1 = zmm0[1,1,2,3,5,5,6,7,9,9,10,11,13,13,14,15]
; AVX512-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovd %xmm0, %eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  %3 = zext i32 %2 to i64
  br label %vector.body

vector.body:
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ]
  %vec.phi = phi <16 x i32> [ %11, %vector.body ], [ zeroinitializer, %entry ]
  %4 = getelementptr inbounds i8, i8* %0, i64 %index
  %5 = bitcast i8* %4 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %5, align 1
  %6 = sext <16 x i8> %wide.load to <16 x i32>
  %7 = getelementptr inbounds i8, i8* %1, i64 %index
  %8 = bitcast i8* %7 to <16 x i8>*
  %wide.load14 = load <16 x i8>, <16 x i8>* %8, align 1
  %9 = sext <16 x i8> %wide.load14 to <16 x i32>
  %10 = mul nsw <16 x i32> %9, %6
  %11 = add nsw <16 x i32> %10, %vec.phi
  %index.next = add i64 %index, 16
  %12 = icmp eq i64 %index.next, %3
  br i1 %12, label %middle.block, label %vector.body

middle.block:
  %rdx.shuf = shufflevector <16 x i32> %11, <16 x i32> undef, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <16 x i32> %11, %rdx.shuf
  %rdx.shuf15 = shufflevector <16 x i32> %bin.rdx, <16 x i32> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx16 = add <16 x i32> %bin.rdx, %rdx.shuf15
  %rdx.shuf17 = shufflevector <16 x i32> %bin.rdx16, <16 x i32> undef, <16 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx18 = add <16 x i32> %bin.rdx16, %rdx.shuf17
  %rdx.shuf19 = shufflevector <16 x i32> %bin.rdx18, <16 x i32> undef, <16 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx20 = add <16 x i32> %bin.rdx18, %rdx.shuf19
  %13 = extractelement <16 x i32> %bin.rdx20, i32 0
  ret i32 %13
}
