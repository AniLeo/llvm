; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu  -mattr=+sse4.2 < %s | FileCheck %s --check-prefixes=ALL,SSE,SSE42
; RUN: llc -mtriple=x86_64-unknown-linux-gnu  -mattr=+avx < %s | FileCheck %s --check-prefixes=ALL,AVX,AVX1
; RUN: llc -mtriple=x86_64-unknown-linux-gnu  -mattr=+avx2 < %s | FileCheck %s --check-prefixes=ALL,AVX,AVX2
; RUN: llc -mtriple=x86_64-unknown-linux-gnu  -mattr=+avx512f < %s | FileCheck %s --check-prefixes=ALL,AVX512

;
; vXf32
;

define <4 x float> @gather_v4f32_ptr_v4i32(<4 x float*> %ptr, <4 x i32> %trigger, <4 x float> %passthru) {
; SSE-LABEL: gather_v4f32_ptr_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm4, %xmm4
; SSE-NEXT:    pcmpeqd %xmm2, %xmm4
; SSE-NEXT:    movmskps %xmm4, %eax
; SSE-NEXT:    testb $1, %al
; SSE-NEXT:    jne .LBB0_1
; SSE-NEXT:  # %bb.2: # %else
; SSE-NEXT:    testb $2, %al
; SSE-NEXT:    jne .LBB0_3
; SSE-NEXT:  .LBB0_4: # %else2
; SSE-NEXT:    testb $4, %al
; SSE-NEXT:    jne .LBB0_5
; SSE-NEXT:  .LBB0_6: # %else5
; SSE-NEXT:    testb $8, %al
; SSE-NEXT:    jne .LBB0_7
; SSE-NEXT:  .LBB0_8: # %else8
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    retq
; SSE-NEXT:  .LBB0_1: # %cond.load
; SSE-NEXT:    movq %xmm0, %rcx
; SSE-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm2[0,1],xmm3[2,3,4,5,6,7]
; SSE-NEXT:    testb $2, %al
; SSE-NEXT:    je .LBB0_4
; SSE-NEXT:  .LBB0_3: # %cond.load1
; SSE-NEXT:    pextrq $1, %xmm0, %rcx
; SSE-NEXT:    insertps {{.*#+}} xmm3 = xmm3[0],mem[0],xmm3[2,3]
; SSE-NEXT:    testb $4, %al
; SSE-NEXT:    je .LBB0_6
; SSE-NEXT:  .LBB0_5: # %cond.load4
; SSE-NEXT:    movq %xmm1, %rcx
; SSE-NEXT:    insertps {{.*#+}} xmm3 = xmm3[0,1],mem[0],xmm3[3]
; SSE-NEXT:    testb $8, %al
; SSE-NEXT:    je .LBB0_8
; SSE-NEXT:  .LBB0_7: # %cond.load7
; SSE-NEXT:    pextrq $1, %xmm1, %rax
; SSE-NEXT:    insertps {{.*#+}} xmm3 = xmm3[0,1,2],mem[0]
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: gather_v4f32_ptr_v4i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vmovmskps %xmm1, %eax
; AVX1-NEXT:    testb $1, %al
; AVX1-NEXT:    je .LBB0_2
; AVX1-NEXT:  # %bb.1: # %cond.load
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX1-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; AVX1-NEXT:  .LBB0_2: # %else
; AVX1-NEXT:    testb $2, %al
; AVX1-NEXT:    je .LBB0_4
; AVX1-NEXT:  # %bb.3: # %cond.load1
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; AVX1-NEXT:  .LBB0_4: # %else2
; AVX1-NEXT:    testb $4, %al
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    jne .LBB0_5
; AVX1-NEXT:  # %bb.6: # %else5
; AVX1-NEXT:    testb $8, %al
; AVX1-NEXT:    jne .LBB0_7
; AVX1-NEXT:  .LBB0_8: # %else8
; AVX1-NEXT:    vmovaps %xmm2, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
; AVX1-NEXT:  .LBB0_5: # %cond.load4
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1],mem[0],xmm2[3]
; AVX1-NEXT:    testb $8, %al
; AVX1-NEXT:    je .LBB0_8
; AVX1-NEXT:  .LBB0_7: # %cond.load7
; AVX1-NEXT:    vpextrq $1, %xmm0, %rax
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1,2],mem[0]
; AVX1-NEXT:    vmovaps %xmm2, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: gather_v4f32_ptr_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpeqd %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vmovmskps %xmm1, %eax
; AVX2-NEXT:    testb $1, %al
; AVX2-NEXT:    je .LBB0_2
; AVX2-NEXT:  # %bb.1: # %cond.load
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX2-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; AVX2-NEXT:  .LBB0_2: # %else
; AVX2-NEXT:    testb $2, %al
; AVX2-NEXT:    je .LBB0_4
; AVX2-NEXT:  # %bb.3: # %cond.load1
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; AVX2-NEXT:  .LBB0_4: # %else2
; AVX2-NEXT:    testb $4, %al
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    jne .LBB0_5
; AVX2-NEXT:  # %bb.6: # %else5
; AVX2-NEXT:    testb $8, %al
; AVX2-NEXT:    jne .LBB0_7
; AVX2-NEXT:  .LBB0_8: # %else8
; AVX2-NEXT:    vmovaps %xmm2, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
; AVX2-NEXT:  .LBB0_5: # %cond.load4
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1],mem[0],xmm2[3]
; AVX2-NEXT:    testb $8, %al
; AVX2-NEXT:    je .LBB0_8
; AVX2-NEXT:  .LBB0_7: # %cond.load7
; AVX2-NEXT:    vpextrq $1, %xmm0, %rax
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1,2],mem[0]
; AVX2-NEXT:    vmovaps %xmm2, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: gather_v4f32_ptr_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $ymm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512-NEXT:    vptestnmd %zmm1, %zmm1, %k0
; AVX512-NEXT:    kshiftlw $12, %k0, %k0
; AVX512-NEXT:    kshiftrw $12, %k0, %k1
; AVX512-NEXT:    vgatherqps (,%zmm0), %ymm2 {%k1}
; AVX512-NEXT:    vmovaps %xmm2, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %mask = icmp eq <4 x i32> %trigger, zeroinitializer
  %res = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %ptr, i32 4, <4 x i1> %mask, <4 x float> %passthru)
  ret <4 x float> %res
}

define <4 x float> @gather_v4f32_v4i32_v4i32(float* %base, <4 x i32> %idx, <4 x i32> %trigger, <4 x float> %passthru) {
; SSE-LABEL: gather_v4f32_v4i32_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[0,1,0,1]
; SSE-NEXT:    pmovsxdq %xmm0, %xmm4
; SSE-NEXT:    psllq $2, %xmm4
; SSE-NEXT:    paddq %xmm3, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; SSE-NEXT:    pmovsxdq %xmm0, %xmm0
; SSE-NEXT:    pxor %xmm5, %xmm5
; SSE-NEXT:    pcmpeqd %xmm1, %xmm5
; SSE-NEXT:    movmskps %xmm5, %eax
; SSE-NEXT:    testb $1, %al
; SSE-NEXT:    je .LBB1_2
; SSE-NEXT:  # %bb.1: # %cond.load
; SSE-NEXT:    movq %xmm4, %rcx
; SSE-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm1[0,1],xmm2[2,3,4,5,6,7]
; SSE-NEXT:  .LBB1_2: # %else
; SSE-NEXT:    psllq $2, %xmm0
; SSE-NEXT:    testb $2, %al
; SSE-NEXT:    je .LBB1_4
; SSE-NEXT:  # %bb.3: # %cond.load1
; SSE-NEXT:    pextrq $1, %xmm4, %rcx
; SSE-NEXT:    insertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; SSE-NEXT:  .LBB1_4: # %else2
; SSE-NEXT:    paddq %xmm0, %xmm3
; SSE-NEXT:    testb $4, %al
; SSE-NEXT:    jne .LBB1_5
; SSE-NEXT:  # %bb.6: # %else5
; SSE-NEXT:    testb $8, %al
; SSE-NEXT:    jne .LBB1_7
; SSE-NEXT:  .LBB1_8: # %else8
; SSE-NEXT:    movaps %xmm2, %xmm0
; SSE-NEXT:    retq
; SSE-NEXT:  .LBB1_5: # %cond.load4
; SSE-NEXT:    movq %xmm3, %rcx
; SSE-NEXT:    insertps {{.*#+}} xmm2 = xmm2[0,1],mem[0],xmm2[3]
; SSE-NEXT:    testb $8, %al
; SSE-NEXT:    je .LBB1_8
; SSE-NEXT:  .LBB1_7: # %cond.load7
; SSE-NEXT:    pextrq $1, %xmm3, %rax
; SSE-NEXT:    insertps {{.*#+}} xmm2 = xmm2[0,1,2],mem[0]
; SSE-NEXT:    movaps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: gather_v4f32_v4i32_v4i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovq %rdi, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[0,1,0,1]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm4 = xmm0[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm4, %xmm4
; AVX1-NEXT:    vpsllq $2, %xmm4, %xmm4
; AVX1-NEXT:    vpaddq %xmm4, %xmm3, %xmm4
; AVX1-NEXT:    vpmovsxdq %xmm0, %xmm0
; AVX1-NEXT:    vpsllq $2, %xmm0, %xmm0
; AVX1-NEXT:    vpaddq %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vmovmskps %xmm1, %eax
; AVX1-NEXT:    testb $1, %al
; AVX1-NEXT:    je .LBB1_2
; AVX1-NEXT:  # %bb.1: # %cond.load
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX1-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; AVX1-NEXT:  .LBB1_2: # %else
; AVX1-NEXT:    testb $2, %al
; AVX1-NEXT:    je .LBB1_4
; AVX1-NEXT:  # %bb.3: # %cond.load1
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; AVX1-NEXT:  .LBB1_4: # %else2
; AVX1-NEXT:    testb $4, %al
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    jne .LBB1_5
; AVX1-NEXT:  # %bb.6: # %else5
; AVX1-NEXT:    testb $8, %al
; AVX1-NEXT:    jne .LBB1_7
; AVX1-NEXT:  .LBB1_8: # %else8
; AVX1-NEXT:    vmovaps %xmm2, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
; AVX1-NEXT:  .LBB1_5: # %cond.load4
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1],mem[0],xmm2[3]
; AVX1-NEXT:    testb $8, %al
; AVX1-NEXT:    je .LBB1_8
; AVX1-NEXT:  .LBB1_7: # %cond.load7
; AVX1-NEXT:    vpextrq $1, %xmm0, %rax
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1,2],mem[0]
; AVX1-NEXT:    vmovaps %xmm2, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: gather_v4f32_v4i32_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm3
; AVX2-NEXT:    vpbroadcastq %xmm3, %ymm3
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm0
; AVX2-NEXT:    vpsllq $2, %ymm0, %ymm0
; AVX2-NEXT:    vpaddq %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpeqd %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vmovmskps %xmm1, %eax
; AVX2-NEXT:    testb $1, %al
; AVX2-NEXT:    je .LBB1_2
; AVX2-NEXT:  # %bb.1: # %cond.load
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX2-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; AVX2-NEXT:  .LBB1_2: # %else
; AVX2-NEXT:    testb $2, %al
; AVX2-NEXT:    je .LBB1_4
; AVX2-NEXT:  # %bb.3: # %cond.load1
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; AVX2-NEXT:  .LBB1_4: # %else2
; AVX2-NEXT:    testb $4, %al
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    jne .LBB1_5
; AVX2-NEXT:  # %bb.6: # %else5
; AVX2-NEXT:    testb $8, %al
; AVX2-NEXT:    jne .LBB1_7
; AVX2-NEXT:  .LBB1_8: # %else8
; AVX2-NEXT:    vmovaps %xmm2, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
; AVX2-NEXT:  .LBB1_5: # %cond.load4
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1],mem[0],xmm2[3]
; AVX2-NEXT:    testb $8, %al
; AVX2-NEXT:    je .LBB1_8
; AVX2-NEXT:  .LBB1_7: # %cond.load7
; AVX2-NEXT:    vpextrq $1, %xmm0, %rax
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1,2],mem[0]
; AVX2-NEXT:    vmovaps %xmm2, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: gather_v4f32_v4i32_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $zmm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512-NEXT:    vptestnmd %zmm1, %zmm1, %k0
; AVX512-NEXT:    kshiftlw $12, %k0, %k0
; AVX512-NEXT:    kshiftrw $12, %k0, %k1
; AVX512-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm2 {%k1}
; AVX512-NEXT:    vmovaps %xmm2, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %vptr0 = insertelement <4 x float*> undef, float* %base, i32 0
  %vptr1 = shufflevector <4 x float*> %vptr0, <4 x float*> undef, <4 x i32> zeroinitializer
  %vptr2 = getelementptr float, <4 x float*> %vptr1, <4 x i32> %idx

  %mask = icmp eq <4 x i32> %trigger, zeroinitializer
  %res = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %vptr2, i32 4, <4 x i1> %mask, <4 x float> %passthru)
  ret <4 x float> %res
}

define <4 x float> @gather_v4f32_v4i64_v4i32(float* %base, <4 x i64> %idx, <4 x i32> %trigger, <4 x float> %passthru) {
; SSE-LABEL: gather_v4f32_v4i64_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[0,1,0,1]
; SSE-NEXT:    psllq $2, %xmm0
; SSE-NEXT:    paddq %xmm4, %xmm0
; SSE-NEXT:    pxor %xmm5, %xmm5
; SSE-NEXT:    pcmpeqd %xmm2, %xmm5
; SSE-NEXT:    movmskps %xmm5, %eax
; SSE-NEXT:    testb $1, %al
; SSE-NEXT:    je .LBB2_2
; SSE-NEXT:  # %bb.1: # %cond.load
; SSE-NEXT:    movq %xmm0, %rcx
; SSE-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm2[0,1],xmm3[2,3,4,5,6,7]
; SSE-NEXT:  .LBB2_2: # %else
; SSE-NEXT:    psllq $2, %xmm1
; SSE-NEXT:    testb $2, %al
; SSE-NEXT:    je .LBB2_4
; SSE-NEXT:  # %bb.3: # %cond.load1
; SSE-NEXT:    pextrq $1, %xmm0, %rcx
; SSE-NEXT:    insertps {{.*#+}} xmm3 = xmm3[0],mem[0],xmm3[2,3]
; SSE-NEXT:  .LBB2_4: # %else2
; SSE-NEXT:    paddq %xmm1, %xmm4
; SSE-NEXT:    testb $4, %al
; SSE-NEXT:    jne .LBB2_5
; SSE-NEXT:  # %bb.6: # %else5
; SSE-NEXT:    testb $8, %al
; SSE-NEXT:    jne .LBB2_7
; SSE-NEXT:  .LBB2_8: # %else8
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    retq
; SSE-NEXT:  .LBB2_5: # %cond.load4
; SSE-NEXT:    movq %xmm4, %rcx
; SSE-NEXT:    insertps {{.*#+}} xmm3 = xmm3[0,1],mem[0],xmm3[3]
; SSE-NEXT:    testb $8, %al
; SSE-NEXT:    je .LBB2_8
; SSE-NEXT:  .LBB2_7: # %cond.load7
; SSE-NEXT:    pextrq $1, %xmm4, %rax
; SSE-NEXT:    insertps {{.*#+}} xmm3 = xmm3[0,1,2],mem[0]
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: gather_v4f32_v4i64_v4i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpsllq $2, %xmm3, %xmm3
; AVX1-NEXT:    vmovq %rdi, %xmm4
; AVX1-NEXT:    vpshufd {{.*#+}} xmm4 = xmm4[0,1,0,1]
; AVX1-NEXT:    vpaddq %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsllq $2, %xmm0, %xmm0
; AVX1-NEXT:    vpaddq %xmm0, %xmm4, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vmovmskps %xmm1, %eax
; AVX1-NEXT:    testb $1, %al
; AVX1-NEXT:    je .LBB2_2
; AVX1-NEXT:  # %bb.1: # %cond.load
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX1-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; AVX1-NEXT:  .LBB2_2: # %else
; AVX1-NEXT:    testb $2, %al
; AVX1-NEXT:    je .LBB2_4
; AVX1-NEXT:  # %bb.3: # %cond.load1
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; AVX1-NEXT:  .LBB2_4: # %else2
; AVX1-NEXT:    testb $4, %al
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    jne .LBB2_5
; AVX1-NEXT:  # %bb.6: # %else5
; AVX1-NEXT:    testb $8, %al
; AVX1-NEXT:    jne .LBB2_7
; AVX1-NEXT:  .LBB2_8: # %else8
; AVX1-NEXT:    vmovaps %xmm2, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
; AVX1-NEXT:  .LBB2_5: # %cond.load4
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1],mem[0],xmm2[3]
; AVX1-NEXT:    testb $8, %al
; AVX1-NEXT:    je .LBB2_8
; AVX1-NEXT:  .LBB2_7: # %cond.load7
; AVX1-NEXT:    vpextrq $1, %xmm0, %rax
; AVX1-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1,2],mem[0]
; AVX1-NEXT:    vmovaps %xmm2, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: gather_v4f32_v4i64_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm3
; AVX2-NEXT:    vpbroadcastq %xmm3, %ymm3
; AVX2-NEXT:    vpsllq $2, %ymm0, %ymm0
; AVX2-NEXT:    vpaddq %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpeqd %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vmovmskps %xmm1, %eax
; AVX2-NEXT:    testb $1, %al
; AVX2-NEXT:    je .LBB2_2
; AVX2-NEXT:  # %bb.1: # %cond.load
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX2-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; AVX2-NEXT:  .LBB2_2: # %else
; AVX2-NEXT:    testb $2, %al
; AVX2-NEXT:    je .LBB2_4
; AVX2-NEXT:  # %bb.3: # %cond.load1
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; AVX2-NEXT:  .LBB2_4: # %else2
; AVX2-NEXT:    testb $4, %al
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    jne .LBB2_5
; AVX2-NEXT:  # %bb.6: # %else5
; AVX2-NEXT:    testb $8, %al
; AVX2-NEXT:    jne .LBB2_7
; AVX2-NEXT:  .LBB2_8: # %else8
; AVX2-NEXT:    vmovaps %xmm2, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
; AVX2-NEXT:  .LBB2_5: # %cond.load4
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1],mem[0],xmm2[3]
; AVX2-NEXT:    testb $8, %al
; AVX2-NEXT:    je .LBB2_8
; AVX2-NEXT:  .LBB2_7: # %cond.load7
; AVX2-NEXT:    vpextrq $1, %xmm0, %rax
; AVX2-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0,1,2],mem[0]
; AVX2-NEXT:    vmovaps %xmm2, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: gather_v4f32_v4i64_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $ymm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512-NEXT:    vptestnmd %zmm1, %zmm1, %k0
; AVX512-NEXT:    kshiftlw $12, %k0, %k0
; AVX512-NEXT:    kshiftrw $12, %k0, %k1
; AVX512-NEXT:    vgatherqps (%rdi,%zmm0,4), %ymm2 {%k1}
; AVX512-NEXT:    vmovaps %xmm2, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %vptr0 = insertelement <4 x float*> undef, float* %base, i32 0
  %vptr1 = shufflevector <4 x float*> %vptr0, <4 x float*> undef, <4 x i32> zeroinitializer
  %vptr2 = getelementptr float, <4 x float*> %vptr1, <4 x i64> %idx

  %mask = icmp eq <4 x i32> %trigger, zeroinitializer
  %res = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %vptr2, i32 4, <4 x i1> %mask, <4 x float> %passthru)
  ret <4 x float> %res
}

;
; vXi8
;

define <16 x i8> @gather_v16i8_v16i32_v16i8(i8* %base, <16 x i32> %idx, <16 x i8> %trigger, <16 x i8> %passthru) {
; SSE-LABEL: gather_v16i8_v16i32_v16i8:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %xmm6
; SSE-NEXT:    pshufd {{.*#+}} xmm8 = xmm6[0,1,0,1]
; SSE-NEXT:    pshufd {{.*#+}} xmm7 = xmm0[2,3,0,1]
; SSE-NEXT:    pmovsxdq %xmm0, %xmm0
; SSE-NEXT:    paddq %xmm8, %xmm0
; SSE-NEXT:    pxor %xmm6, %xmm6
; SSE-NEXT:    pcmpeqb %xmm4, %xmm6
; SSE-NEXT:    pmovmskb %xmm6, %eax
; SSE-NEXT:    testb $1, %al
; SSE-NEXT:    je .LBB3_2
; SSE-NEXT:  # %bb.1: # %cond.load
; SSE-NEXT:    movq %xmm0, %rcx
; SSE-NEXT:    pinsrb $0, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_2: # %else
; SSE-NEXT:    pmovsxdq %xmm7, %xmm4
; SSE-NEXT:    testb $2, %al
; SSE-NEXT:    je .LBB3_4
; SSE-NEXT:  # %bb.3: # %cond.load1
; SSE-NEXT:    pextrq $1, %xmm0, %rcx
; SSE-NEXT:    pinsrb $1, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_4: # %else2
; SSE-NEXT:    paddq %xmm8, %xmm4
; SSE-NEXT:    testb $4, %al
; SSE-NEXT:    je .LBB3_6
; SSE-NEXT:  # %bb.5: # %cond.load4
; SSE-NEXT:    movq %xmm4, %rcx
; SSE-NEXT:    pinsrb $2, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_6: # %else5
; SSE-NEXT:    pmovsxdq %xmm1, %xmm0
; SSE-NEXT:    testb $8, %al
; SSE-NEXT:    je .LBB3_8
; SSE-NEXT:  # %bb.7: # %cond.load7
; SSE-NEXT:    pextrq $1, %xmm4, %rcx
; SSE-NEXT:    pinsrb $3, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_8: # %else8
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[2,3,0,1]
; SSE-NEXT:    paddq %xmm8, %xmm0
; SSE-NEXT:    testb $16, %al
; SSE-NEXT:    je .LBB3_10
; SSE-NEXT:  # %bb.9: # %cond.load10
; SSE-NEXT:    movq %xmm0, %rcx
; SSE-NEXT:    pinsrb $4, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_10: # %else11
; SSE-NEXT:    pmovsxdq %xmm1, %xmm1
; SSE-NEXT:    testb $32, %al
; SSE-NEXT:    je .LBB3_12
; SSE-NEXT:  # %bb.11: # %cond.load13
; SSE-NEXT:    pextrq $1, %xmm0, %rcx
; SSE-NEXT:    pinsrb $5, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_12: # %else14
; SSE-NEXT:    paddq %xmm8, %xmm1
; SSE-NEXT:    testb $64, %al
; SSE-NEXT:    je .LBB3_14
; SSE-NEXT:  # %bb.13: # %cond.load16
; SSE-NEXT:    movq %xmm1, %rcx
; SSE-NEXT:    pinsrb $6, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_14: # %else17
; SSE-NEXT:    pmovsxdq %xmm2, %xmm0
; SSE-NEXT:    testb $-128, %al
; SSE-NEXT:    je .LBB3_16
; SSE-NEXT:  # %bb.15: # %cond.load19
; SSE-NEXT:    pextrq $1, %xmm1, %rcx
; SSE-NEXT:    pinsrb $7, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_16: # %else20
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[2,3,0,1]
; SSE-NEXT:    paddq %xmm8, %xmm0
; SSE-NEXT:    testl $256, %eax # imm = 0x100
; SSE-NEXT:    je .LBB3_18
; SSE-NEXT:  # %bb.17: # %cond.load22
; SSE-NEXT:    movq %xmm0, %rcx
; SSE-NEXT:    pinsrb $8, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_18: # %else23
; SSE-NEXT:    pmovsxdq %xmm1, %xmm1
; SSE-NEXT:    testl $512, %eax # imm = 0x200
; SSE-NEXT:    je .LBB3_20
; SSE-NEXT:  # %bb.19: # %cond.load25
; SSE-NEXT:    pextrq $1, %xmm0, %rcx
; SSE-NEXT:    pinsrb $9, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_20: # %else26
; SSE-NEXT:    paddq %xmm8, %xmm1
; SSE-NEXT:    testl $1024, %eax # imm = 0x400
; SSE-NEXT:    je .LBB3_22
; SSE-NEXT:  # %bb.21: # %cond.load28
; SSE-NEXT:    movq %xmm1, %rcx
; SSE-NEXT:    pinsrb $10, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_22: # %else29
; SSE-NEXT:    pmovsxdq %xmm3, %xmm0
; SSE-NEXT:    testl $2048, %eax # imm = 0x800
; SSE-NEXT:    je .LBB3_24
; SSE-NEXT:  # %bb.23: # %cond.load31
; SSE-NEXT:    pextrq $1, %xmm1, %rcx
; SSE-NEXT:    pinsrb $11, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_24: # %else32
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[2,3,0,1]
; SSE-NEXT:    paddq %xmm8, %xmm0
; SSE-NEXT:    testl $4096, %eax # imm = 0x1000
; SSE-NEXT:    je .LBB3_26
; SSE-NEXT:  # %bb.25: # %cond.load34
; SSE-NEXT:    movq %xmm0, %rcx
; SSE-NEXT:    pinsrb $12, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_26: # %else35
; SSE-NEXT:    pmovsxdq %xmm1, %xmm1
; SSE-NEXT:    testl $8192, %eax # imm = 0x2000
; SSE-NEXT:    je .LBB3_28
; SSE-NEXT:  # %bb.27: # %cond.load37
; SSE-NEXT:    pextrq $1, %xmm0, %rcx
; SSE-NEXT:    pinsrb $13, (%rcx), %xmm5
; SSE-NEXT:  .LBB3_28: # %else38
; SSE-NEXT:    paddq %xmm1, %xmm8
; SSE-NEXT:    testl $16384, %eax # imm = 0x4000
; SSE-NEXT:    jne .LBB3_29
; SSE-NEXT:  # %bb.30: # %else41
; SSE-NEXT:    testl $32768, %eax # imm = 0x8000
; SSE-NEXT:    jne .LBB3_31
; SSE-NEXT:  .LBB3_32: # %else44
; SSE-NEXT:    movdqa %xmm5, %xmm0
; SSE-NEXT:    retq
; SSE-NEXT:  .LBB3_29: # %cond.load40
; SSE-NEXT:    movq %xmm8, %rcx
; SSE-NEXT:    pinsrb $14, (%rcx), %xmm5
; SSE-NEXT:    testl $32768, %eax # imm = 0x8000
; SSE-NEXT:    je .LBB3_32
; SSE-NEXT:  .LBB3_31: # %cond.load43
; SSE-NEXT:    pextrq $1, %xmm8, %rax
; SSE-NEXT:    pinsrb $15, (%rax), %xmm5
; SSE-NEXT:    movdqa %xmm5, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: gather_v16i8_v16i32_v16i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovq %rdi, %xmm4
; AVX1-NEXT:    vpshufd {{.*#+}} xmm4 = xmm4[0,1,0,1]
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpshufd {{.*#+}} xmm6 = xmm0[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm6, %xmm6
; AVX1-NEXT:    vpaddq %xmm6, %xmm4, %xmm6
; AVX1-NEXT:    vpmovsxdq %xmm0, %xmm0
; AVX1-NEXT:    vpaddq %xmm0, %xmm4, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm6, %ymm0, %ymm0
; AVX1-NEXT:    vpxor %xmm6, %xmm6, %xmm6
; AVX1-NEXT:    vpcmpeqb %xmm6, %xmm2, %xmm2
; AVX1-NEXT:    vpmovmskb %xmm2, %eax
; AVX1-NEXT:    testb $1, %al
; AVX1-NEXT:    je .LBB3_2
; AVX1-NEXT:  # %bb.1: # %cond.load
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $0, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_2: # %else
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm5[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm5, %xmm6
; AVX1-NEXT:    testb $2, %al
; AVX1-NEXT:    je .LBB3_4
; AVX1-NEXT:  # %bb.3: # %cond.load1
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $1, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_4: # %else2
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm5
; AVX1-NEXT:    vpaddq %xmm6, %xmm4, %xmm2
; AVX1-NEXT:    testb $4, %al
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    je .LBB3_6
; AVX1-NEXT:  # %bb.5: # %cond.load4
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $2, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_6: # %else5
; AVX1-NEXT:    vpaddq %xmm5, %xmm4, %xmm5
; AVX1-NEXT:    testb $8, %al
; AVX1-NEXT:    je .LBB3_8
; AVX1-NEXT:  # %bb.7: # %cond.load7
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $3, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_8: # %else8
; AVX1-NEXT:    vinsertf128 $1, %xmm5, %ymm2, %ymm0
; AVX1-NEXT:    testb $16, %al
; AVX1-NEXT:    je .LBB3_10
; AVX1-NEXT:  # %bb.9: # %cond.load10
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $4, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_10: # %else11
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm1, %xmm6
; AVX1-NEXT:    testb $32, %al
; AVX1-NEXT:    je .LBB3_12
; AVX1-NEXT:  # %bb.11: # %cond.load13
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $5, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_12: # %else14
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm5
; AVX1-NEXT:    vpaddq %xmm6, %xmm4, %xmm2
; AVX1-NEXT:    testb $64, %al
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    je .LBB3_14
; AVX1-NEXT:  # %bb.13: # %cond.load16
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $6, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_14: # %else17
; AVX1-NEXT:    vpaddq %xmm5, %xmm4, %xmm5
; AVX1-NEXT:    testb $-128, %al
; AVX1-NEXT:    je .LBB3_16
; AVX1-NEXT:  # %bb.15: # %cond.load19
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $7, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_16: # %else20
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm5, %ymm2, %ymm0
; AVX1-NEXT:    testl $256, %eax # imm = 0x100
; AVX1-NEXT:    je .LBB3_18
; AVX1-NEXT:  # %bb.17: # %cond.load22
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $8, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_18: # %else23
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm1, %xmm1
; AVX1-NEXT:    testl $512, %eax # imm = 0x200
; AVX1-NEXT:    je .LBB3_20
; AVX1-NEXT:  # %bb.19: # %cond.load25
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $9, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_20: # %else26
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm2
; AVX1-NEXT:    vpaddq %xmm1, %xmm4, %xmm1
; AVX1-NEXT:    testl $1024, %eax # imm = 0x400
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    je .LBB3_22
; AVX1-NEXT:  # %bb.21: # %cond.load28
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $10, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_22: # %else29
; AVX1-NEXT:    vpaddq %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    testl $2048, %eax # imm = 0x800
; AVX1-NEXT:    je .LBB3_24
; AVX1-NEXT:  # %bb.23: # %cond.load31
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $11, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_24: # %else32
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm0
; AVX1-NEXT:    testl $4096, %eax # imm = 0x1000
; AVX1-NEXT:    je .LBB3_26
; AVX1-NEXT:  # %bb.25: # %cond.load34
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $12, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_26: # %else35
; AVX1-NEXT:    testl $8192, %eax # imm = 0x2000
; AVX1-NEXT:    je .LBB3_28
; AVX1-NEXT:  # %bb.27: # %cond.load37
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $13, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:  .LBB3_28: # %else38
; AVX1-NEXT:    testl $16384, %eax # imm = 0x4000
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    jne .LBB3_29
; AVX1-NEXT:  # %bb.30: # %else41
; AVX1-NEXT:    testl $32768, %eax # imm = 0x8000
; AVX1-NEXT:    jne .LBB3_31
; AVX1-NEXT:  .LBB3_32: # %else44
; AVX1-NEXT:    vmovdqa %xmm3, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
; AVX1-NEXT:  .LBB3_29: # %cond.load40
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    vpinsrb $14, (%rcx), %xmm3, %xmm3
; AVX1-NEXT:    testl $32768, %eax # imm = 0x8000
; AVX1-NEXT:    je .LBB3_32
; AVX1-NEXT:  .LBB3_31: # %cond.load43
; AVX1-NEXT:    vpextrq $1, %xmm0, %rax
; AVX1-NEXT:    vpinsrb $15, (%rax), %xmm3, %xmm3
; AVX1-NEXT:    vmovdqa %xmm3, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: gather_v16i8_v16i32_v16i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm4
; AVX2-NEXT:    vpbroadcastq %xmm4, %ymm4
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm5
; AVX2-NEXT:    vpaddq %ymm5, %ymm4, %ymm5
; AVX2-NEXT:    vpxor %xmm6, %xmm6, %xmm6
; AVX2-NEXT:    vpcmpeqb %xmm6, %xmm2, %xmm2
; AVX2-NEXT:    vpmovmskb %xmm2, %eax
; AVX2-NEXT:    testb $1, %al
; AVX2-NEXT:    je .LBB3_2
; AVX2-NEXT:  # %bb.1: # %cond.load
; AVX2-NEXT:    vmovq %xmm5, %rcx
; AVX2-NEXT:    vpinsrb $0, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_2: # %else
; AVX2-NEXT:    testb $2, %al
; AVX2-NEXT:    je .LBB3_4
; AVX2-NEXT:  # %bb.3: # %cond.load1
; AVX2-NEXT:    vpextrq $1, %xmm5, %rcx
; AVX2-NEXT:    vpinsrb $1, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_4: # %else2
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX2-NEXT:    testb $4, %al
; AVX2-NEXT:    vextracti128 $1, %ymm5, %xmm0
; AVX2-NEXT:    je .LBB3_6
; AVX2-NEXT:  # %bb.5: # %cond.load4
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $2, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_6: # %else5
; AVX2-NEXT:    vpmovsxdq %xmm2, %ymm2
; AVX2-NEXT:    testb $8, %al
; AVX2-NEXT:    je .LBB3_8
; AVX2-NEXT:  # %bb.7: # %cond.load7
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $3, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_8: # %else8
; AVX2-NEXT:    vpaddq %ymm2, %ymm4, %ymm0
; AVX2-NEXT:    testb $16, %al
; AVX2-NEXT:    je .LBB3_10
; AVX2-NEXT:  # %bb.9: # %cond.load10
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $4, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_10: # %else11
; AVX2-NEXT:    testb $32, %al
; AVX2-NEXT:    je .LBB3_12
; AVX2-NEXT:  # %bb.11: # %cond.load13
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $5, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_12: # %else14
; AVX2-NEXT:    testb $64, %al
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    je .LBB3_14
; AVX2-NEXT:  # %bb.13: # %cond.load16
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $6, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_14: # %else17
; AVX2-NEXT:    vpmovsxdq %xmm1, %ymm2
; AVX2-NEXT:    testb $-128, %al
; AVX2-NEXT:    je .LBB3_16
; AVX2-NEXT:  # %bb.15: # %cond.load19
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $7, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_16: # %else20
; AVX2-NEXT:    vpaddq %ymm2, %ymm4, %ymm0
; AVX2-NEXT:    testl $256, %eax # imm = 0x100
; AVX2-NEXT:    je .LBB3_18
; AVX2-NEXT:  # %bb.17: # %cond.load22
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $8, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_18: # %else23
; AVX2-NEXT:    testl $512, %eax # imm = 0x200
; AVX2-NEXT:    je .LBB3_20
; AVX2-NEXT:  # %bb.19: # %cond.load25
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $9, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_20: # %else26
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm1
; AVX2-NEXT:    testl $1024, %eax # imm = 0x400
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    je .LBB3_22
; AVX2-NEXT:  # %bb.21: # %cond.load28
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $10, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_22: # %else29
; AVX2-NEXT:    vpmovsxdq %xmm1, %ymm1
; AVX2-NEXT:    testl $2048, %eax # imm = 0x800
; AVX2-NEXT:    je .LBB3_24
; AVX2-NEXT:  # %bb.23: # %cond.load31
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $11, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_24: # %else32
; AVX2-NEXT:    vpaddq %ymm1, %ymm4, %ymm0
; AVX2-NEXT:    testl $4096, %eax # imm = 0x1000
; AVX2-NEXT:    je .LBB3_26
; AVX2-NEXT:  # %bb.25: # %cond.load34
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $12, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_26: # %else35
; AVX2-NEXT:    testl $8192, %eax # imm = 0x2000
; AVX2-NEXT:    je .LBB3_28
; AVX2-NEXT:  # %bb.27: # %cond.load37
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $13, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:  .LBB3_28: # %else38
; AVX2-NEXT:    testl $16384, %eax # imm = 0x4000
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    jne .LBB3_29
; AVX2-NEXT:  # %bb.30: # %else41
; AVX2-NEXT:    testl $32768, %eax # imm = 0x8000
; AVX2-NEXT:    jne .LBB3_31
; AVX2-NEXT:  .LBB3_32: # %else44
; AVX2-NEXT:    vmovdqa %xmm3, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
; AVX2-NEXT:  .LBB3_29: # %cond.load40
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    vpinsrb $14, (%rcx), %xmm3, %xmm3
; AVX2-NEXT:    testl $32768, %eax # imm = 0x8000
; AVX2-NEXT:    je .LBB3_32
; AVX2-NEXT:  .LBB3_31: # %cond.load43
; AVX2-NEXT:    vpextrq $1, %xmm0, %rax
; AVX2-NEXT:    vpinsrb $15, (%rax), %xmm3, %xmm3
; AVX2-NEXT:    vmovdqa %xmm3, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: gather_v16i8_v16i32_v16i8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpbroadcastq %rdi, %zmm3
; AVX512-NEXT:    vpmovsxdq %ymm0, %zmm4
; AVX512-NEXT:    vpaddq %zmm4, %zmm3, %zmm4
; AVX512-NEXT:    vpxor %xmm5, %xmm5, %xmm5
; AVX512-NEXT:    vpcmpeqb %xmm5, %xmm1, %xmm1
; AVX512-NEXT:    vpmovmskb %xmm1, %eax
; AVX512-NEXT:    testb $1, %al
; AVX512-NEXT:    jne .LBB3_1
; AVX512-NEXT:  # %bb.2: # %else
; AVX512-NEXT:    testb $2, %al
; AVX512-NEXT:    jne .LBB3_3
; AVX512-NEXT:  .LBB3_4: # %else2
; AVX512-NEXT:    testb $4, %al
; AVX512-NEXT:    jne .LBB3_5
; AVX512-NEXT:  .LBB3_6: # %else5
; AVX512-NEXT:    testb $8, %al
; AVX512-NEXT:    je .LBB3_8
; AVX512-NEXT:  .LBB3_7: # %cond.load7
; AVX512-NEXT:    vextracti128 $1, %ymm4, %xmm1
; AVX512-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $3, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_8: # %else8
; AVX512-NEXT:    testb $16, %al
; AVX512-NEXT:    vextracti32x4 $2, %zmm4, %xmm1
; AVX512-NEXT:    je .LBB3_10
; AVX512-NEXT:  # %bb.9: # %cond.load10
; AVX512-NEXT:    vmovq %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $4, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_10: # %else11
; AVX512-NEXT:    testb $32, %al
; AVX512-NEXT:    je .LBB3_12
; AVX512-NEXT:  # %bb.11: # %cond.load13
; AVX512-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $5, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_12: # %else14
; AVX512-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    testb $64, %al
; AVX512-NEXT:    vextracti32x4 $3, %zmm4, %xmm0
; AVX512-NEXT:    je .LBB3_14
; AVX512-NEXT:  # %bb.13: # %cond.load16
; AVX512-NEXT:    vmovq %xmm0, %rcx
; AVX512-NEXT:    vpinsrb $6, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_14: # %else17
; AVX512-NEXT:    vpmovsxdq %ymm1, %zmm1
; AVX512-NEXT:    testb $-128, %al
; AVX512-NEXT:    je .LBB3_16
; AVX512-NEXT:  # %bb.15: # %cond.load19
; AVX512-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX512-NEXT:    vpinsrb $7, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_16: # %else20
; AVX512-NEXT:    vpaddq %zmm1, %zmm3, %zmm0
; AVX512-NEXT:    testl $256, %eax # imm = 0x100
; AVX512-NEXT:    jne .LBB3_17
; AVX512-NEXT:  # %bb.18: # %else23
; AVX512-NEXT:    testl $512, %eax # imm = 0x200
; AVX512-NEXT:    jne .LBB3_19
; AVX512-NEXT:  .LBB3_20: # %else26
; AVX512-NEXT:    testl $1024, %eax # imm = 0x400
; AVX512-NEXT:    jne .LBB3_21
; AVX512-NEXT:  .LBB3_22: # %else29
; AVX512-NEXT:    testl $2048, %eax # imm = 0x800
; AVX512-NEXT:    je .LBB3_24
; AVX512-NEXT:  .LBB3_23: # %cond.load31
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $11, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_24: # %else32
; AVX512-NEXT:    testl $4096, %eax # imm = 0x1000
; AVX512-NEXT:    vextracti32x4 $2, %zmm0, %xmm1
; AVX512-NEXT:    je .LBB3_26
; AVX512-NEXT:  # %bb.25: # %cond.load34
; AVX512-NEXT:    vmovq %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $12, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_26: # %else35
; AVX512-NEXT:    testl $8192, %eax # imm = 0x2000
; AVX512-NEXT:    je .LBB3_28
; AVX512-NEXT:  # %bb.27: # %cond.load37
; AVX512-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $13, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:  .LBB3_28: # %else38
; AVX512-NEXT:    testl $16384, %eax # imm = 0x4000
; AVX512-NEXT:    vextracti32x4 $3, %zmm0, %xmm0
; AVX512-NEXT:    jne .LBB3_29
; AVX512-NEXT:  # %bb.30: # %else41
; AVX512-NEXT:    testl $32768, %eax # imm = 0x8000
; AVX512-NEXT:    jne .LBB3_31
; AVX512-NEXT:  .LBB3_32: # %else44
; AVX512-NEXT:    vmovdqa %xmm2, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
; AVX512-NEXT:  .LBB3_1: # %cond.load
; AVX512-NEXT:    vmovq %xmm4, %rcx
; AVX512-NEXT:    vpinsrb $0, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:    testb $2, %al
; AVX512-NEXT:    je .LBB3_4
; AVX512-NEXT:  .LBB3_3: # %cond.load1
; AVX512-NEXT:    vpextrq $1, %xmm4, %rcx
; AVX512-NEXT:    vpinsrb $1, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:    testb $4, %al
; AVX512-NEXT:    je .LBB3_6
; AVX512-NEXT:  .LBB3_5: # %cond.load4
; AVX512-NEXT:    vextracti128 $1, %ymm4, %xmm1
; AVX512-NEXT:    vmovq %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $2, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:    testb $8, %al
; AVX512-NEXT:    jne .LBB3_7
; AVX512-NEXT:    jmp .LBB3_8
; AVX512-NEXT:  .LBB3_17: # %cond.load22
; AVX512-NEXT:    vmovq %xmm0, %rcx
; AVX512-NEXT:    vpinsrb $8, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:    testl $512, %eax # imm = 0x200
; AVX512-NEXT:    je .LBB3_20
; AVX512-NEXT:  .LBB3_19: # %cond.load25
; AVX512-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX512-NEXT:    vpinsrb $9, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:    testl $1024, %eax # imm = 0x400
; AVX512-NEXT:    je .LBB3_22
; AVX512-NEXT:  .LBB3_21: # %cond.load28
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vmovq %xmm1, %rcx
; AVX512-NEXT:    vpinsrb $10, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:    testl $2048, %eax # imm = 0x800
; AVX512-NEXT:    jne .LBB3_23
; AVX512-NEXT:    jmp .LBB3_24
; AVX512-NEXT:  .LBB3_29: # %cond.load40
; AVX512-NEXT:    vmovq %xmm0, %rcx
; AVX512-NEXT:    vpinsrb $14, (%rcx), %xmm2, %xmm2
; AVX512-NEXT:    testl $32768, %eax # imm = 0x8000
; AVX512-NEXT:    je .LBB3_32
; AVX512-NEXT:  .LBB3_31: # %cond.load43
; AVX512-NEXT:    vpextrq $1, %xmm0, %rax
; AVX512-NEXT:    vpinsrb $15, (%rax), %xmm2, %xmm2
; AVX512-NEXT:    vmovdqa %xmm2, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %vptr0 = insertelement <16 x i8*> undef, i8* %base, i32 0
  %vptr1 = shufflevector <16 x i8*> %vptr0, <16 x i8*> undef, <16 x i32> zeroinitializer
  %vptr2 = getelementptr i8, <16 x i8*> %vptr1, <16 x i32> %idx

  %mask = icmp eq <16 x i8> %trigger, zeroinitializer
  %res = call <16 x i8> @llvm.masked.gather.v16i8.v16p0i8(<16 x i8*> %vptr2, i32 4, <16 x i1> %mask, <16 x i8> %passthru)
  ret <16 x i8> %res
}

declare <2 x double> @llvm.masked.gather.v2f64.v2p0f64(<2 x double*>, i32, <2 x i1>, <2 x double>)
declare <4 x double> @llvm.masked.gather.v4f64.v4p0f64(<4 x double*>, i32, <4 x i1>, <4 x double>)

declare <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*>, i32, <4 x i1>, <4 x float>)
declare <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*>, i32, <8 x i1>, <8 x float>)

declare <16 x i8> @llvm.masked.gather.v16i8.v16p0i8(<16 x i8*>, i32, <16 x i1>, <16 x i8>)
