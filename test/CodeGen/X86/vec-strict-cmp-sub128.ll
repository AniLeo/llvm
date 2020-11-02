; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 -O3 | FileCheck %s --check-prefix=SSE-32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 -O3 | FileCheck %s --check-prefix=SSE-64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx -O3 | FileCheck %s --check-prefix=AVX-32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx -O3 | FileCheck %s --check-prefix=AVX-64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 | FileCheck %s --check-prefix=AVX512-32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 | FileCheck %s --check-prefix=AVX512-64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f -mattr=+avx512f -O3 | FileCheck %s --check-prefix=AVX512F-32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -mattr=+avx512f -O3 | FileCheck %s --check-prefix=AVX512F-64

define <2 x i32> @test_v2f32_ogt_s(<2 x i32> %a, <2 x i32> %b, <2 x float> %f1, <2 x float> %f2) #0 {
; SSE-32-LABEL: test_v2f32_ogt_s:
; SSE-32:       # %bb.0:
; SSE-32-NEXT:    pushl %ebp
; SSE-32-NEXT:    movl %esp, %ebp
; SSE-32-NEXT:    andl $-16, %esp
; SSE-32-NEXT:    subl $16, %esp
; SSE-32-NEXT:    movaps 8(%ebp), %xmm3
; SSE-32-NEXT:    xorl %eax, %eax
; SSE-32-NEXT:    comiss %xmm3, %xmm2
; SSE-32-NEXT:    movl $-1, %ecx
; SSE-32-NEXT:    movl $0, %edx
; SSE-32-NEXT:    cmoval %ecx, %edx
; SSE-32-NEXT:    movd %edx, %xmm4
; SSE-32-NEXT:    shufps {{.*#+}} xmm3 = xmm3[1,1,1,1]
; SSE-32-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1,1,1]
; SSE-32-NEXT:    comiss %xmm3, %xmm2
; SSE-32-NEXT:    cmoval %ecx, %eax
; SSE-32-NEXT:    movd %eax, %xmm2
; SSE-32-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
; SSE-32-NEXT:    pand %xmm4, %xmm0
; SSE-32-NEXT:    pandn %xmm1, %xmm4
; SSE-32-NEXT:    por %xmm4, %xmm0
; SSE-32-NEXT:    movl %ebp, %esp
; SSE-32-NEXT:    popl %ebp
; SSE-32-NEXT:    retl
;
; SSE-64-LABEL: test_v2f32_ogt_s:
; SSE-64:       # %bb.0:
; SSE-64-NEXT:    xorl %eax, %eax
; SSE-64-NEXT:    comiss %xmm3, %xmm2
; SSE-64-NEXT:    movl $-1, %ecx
; SSE-64-NEXT:    movl $0, %edx
; SSE-64-NEXT:    cmoval %ecx, %edx
; SSE-64-NEXT:    movd %edx, %xmm4
; SSE-64-NEXT:    shufps {{.*#+}} xmm3 = xmm3[1,1,1,1]
; SSE-64-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1,1,1]
; SSE-64-NEXT:    comiss %xmm3, %xmm2
; SSE-64-NEXT:    cmoval %ecx, %eax
; SSE-64-NEXT:    movd %eax, %xmm2
; SSE-64-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
; SSE-64-NEXT:    pand %xmm4, %xmm0
; SSE-64-NEXT:    pandn %xmm1, %xmm4
; SSE-64-NEXT:    por %xmm4, %xmm0
; SSE-64-NEXT:    retq
;
; AVX-32-LABEL: test_v2f32_ogt_s:
; AVX-32:       # %bb.0:
; AVX-32-NEXT:    pushl %ebp
; AVX-32-NEXT:    movl %esp, %ebp
; AVX-32-NEXT:    andl $-16, %esp
; AVX-32-NEXT:    subl $16, %esp
; AVX-32-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm2[1,1,3,3]
; AVX-32-NEXT:    xorl %eax, %eax
; AVX-32-NEXT:    vcomiss 12(%ebp), %xmm3
; AVX-32-NEXT:    movl $-1, %ecx
; AVX-32-NEXT:    movl $0, %edx
; AVX-32-NEXT:    cmoval %ecx, %edx
; AVX-32-NEXT:    vcomiss 8(%ebp), %xmm2
; AVX-32-NEXT:    cmoval %ecx, %eax
; AVX-32-NEXT:    vmovd %eax, %xmm2
; AVX-32-NEXT:    vpinsrd $1, %edx, %xmm2, %xmm2
; AVX-32-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX-32-NEXT:    movl %ebp, %esp
; AVX-32-NEXT:    popl %ebp
; AVX-32-NEXT:    retl
;
; AVX-64-LABEL: test_v2f32_ogt_s:
; AVX-64:       # %bb.0:
; AVX-64-NEXT:    vmovshdup {{.*#+}} xmm4 = xmm3[1,1,3,3]
; AVX-64-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm2[1,1,3,3]
; AVX-64-NEXT:    xorl %eax, %eax
; AVX-64-NEXT:    vcomiss %xmm4, %xmm5
; AVX-64-NEXT:    movl $-1, %ecx
; AVX-64-NEXT:    movl $0, %edx
; AVX-64-NEXT:    cmoval %ecx, %edx
; AVX-64-NEXT:    vcomiss %xmm3, %xmm2
; AVX-64-NEXT:    cmoval %ecx, %eax
; AVX-64-NEXT:    vmovd %eax, %xmm2
; AVX-64-NEXT:    vpinsrd $1, %edx, %xmm2, %xmm2
; AVX-64-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX-64-NEXT:    retq
;
; AVX512-32-LABEL: test_v2f32_ogt_s:
; AVX512-32:       # %bb.0:
; AVX512-32-NEXT:    pushl %ebp
; AVX512-32-NEXT:    movl %esp, %ebp
; AVX512-32-NEXT:    andl $-16, %esp
; AVX512-32-NEXT:    subl $16, %esp
; AVX512-32-NEXT:    movw $-3, %ax
; AVX512-32-NEXT:    kmovw %eax, %k0
; AVX512-32-NEXT:    vcomiss 8(%ebp), %xmm2
; AVX512-32-NEXT:    seta %al
; AVX512-32-NEXT:    kmovw %eax, %k1
; AVX512-32-NEXT:    kandw %k0, %k1, %k0
; AVX512-32-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512-32-NEXT:    vcomiss 12(%ebp), %xmm2
; AVX512-32-NEXT:    seta %al
; AVX512-32-NEXT:    kmovw %eax, %k1
; AVX512-32-NEXT:    kshiftlw $15, %k1, %k1
; AVX512-32-NEXT:    kshiftrw $14, %k1, %k1
; AVX512-32-NEXT:    korw %k1, %k0, %k1
; AVX512-32-NEXT:    vpblendmd %xmm0, %xmm1, %xmm0 {%k1}
; AVX512-32-NEXT:    movl %ebp, %esp
; AVX512-32-NEXT:    popl %ebp
; AVX512-32-NEXT:    retl
;
; AVX512-64-LABEL: test_v2f32_ogt_s:
; AVX512-64:       # %bb.0:
; AVX512-64-NEXT:    movw $-3, %ax
; AVX512-64-NEXT:    kmovw %eax, %k0
; AVX512-64-NEXT:    vcomiss %xmm3, %xmm2
; AVX512-64-NEXT:    seta %al
; AVX512-64-NEXT:    kmovw %eax, %k1
; AVX512-64-NEXT:    kandw %k0, %k1, %k0
; AVX512-64-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX512-64-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512-64-NEXT:    vcomiss %xmm3, %xmm2
; AVX512-64-NEXT:    seta %al
; AVX512-64-NEXT:    kmovw %eax, %k1
; AVX512-64-NEXT:    kshiftlw $15, %k1, %k1
; AVX512-64-NEXT:    kshiftrw $14, %k1, %k1
; AVX512-64-NEXT:    korw %k1, %k0, %k1
; AVX512-64-NEXT:    vpblendmd %xmm0, %xmm1, %xmm0 {%k1}
; AVX512-64-NEXT:    retq
;
; AVX512F-32-LABEL: test_v2f32_ogt_s:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    pushl %ebp
; AVX512F-32-NEXT:    movl %esp, %ebp
; AVX512F-32-NEXT:    andl $-16, %esp
; AVX512F-32-NEXT:    subl $16, %esp
; AVX512F-32-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-32-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-32-NEXT:    movw $-3, %ax
; AVX512F-32-NEXT:    kmovw %eax, %k0
; AVX512F-32-NEXT:    vcomiss 8(%ebp), %xmm2
; AVX512F-32-NEXT:    seta %al
; AVX512F-32-NEXT:    kmovw %eax, %k1
; AVX512F-32-NEXT:    kandw %k0, %k1, %k0
; AVX512F-32-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512F-32-NEXT:    vcomiss 12(%ebp), %xmm2
; AVX512F-32-NEXT:    seta %al
; AVX512F-32-NEXT:    kmovw %eax, %k1
; AVX512F-32-NEXT:    kshiftlw $15, %k1, %k1
; AVX512F-32-NEXT:    kshiftrw $14, %k1, %k1
; AVX512F-32-NEXT:    korw %k1, %k0, %k1
; AVX512F-32-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512F-32-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-32-NEXT:    movl %ebp, %esp
; AVX512F-32-NEXT:    popl %ebp
; AVX512F-32-NEXT:    vzeroupper
; AVX512F-32-NEXT:    retl
;
; AVX512F-64-LABEL: test_v2f32_ogt_s:
; AVX512F-64:       # %bb.0:
; AVX512F-64-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-64-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-64-NEXT:    movw $-3, %ax
; AVX512F-64-NEXT:    kmovw %eax, %k0
; AVX512F-64-NEXT:    vcomiss %xmm3, %xmm2
; AVX512F-64-NEXT:    seta %al
; AVX512F-64-NEXT:    kmovw %eax, %k1
; AVX512F-64-NEXT:    kandw %k0, %k1, %k0
; AVX512F-64-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX512F-64-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512F-64-NEXT:    vcomiss %xmm3, %xmm2
; AVX512F-64-NEXT:    seta %al
; AVX512F-64-NEXT:    kmovw %eax, %k1
; AVX512F-64-NEXT:    kshiftlw $15, %k1, %k1
; AVX512F-64-NEXT:    kshiftrw $14, %k1, %k1
; AVX512F-64-NEXT:    korw %k1, %k0, %k1
; AVX512F-64-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512F-64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-64-NEXT:    vzeroupper
; AVX512F-64-NEXT:    retq
  %cond = call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(
                                               <2 x float> %f1, <2 x float> %f2, metadata !"ogt",
                                               metadata !"fpexcept.strict") #0
  %res = select <2 x i1> %cond, <2 x i32> %a, <2 x i32> %b
  ret <2 x i32> %res
}

define <2 x i32> @test_v2f32_oeq_q(<2 x i32> %a, <2 x i32> %b, <2 x float> %f1, <2 x float> %f2) #0 {
; SSE-32-LABEL: test_v2f32_oeq_q:
; SSE-32:       # %bb.0:
; SSE-32-NEXT:    pushl %ebp
; SSE-32-NEXT:    movl %esp, %ebp
; SSE-32-NEXT:    andl $-16, %esp
; SSE-32-NEXT:    subl $16, %esp
; SSE-32-NEXT:    movaps 8(%ebp), %xmm3
; SSE-32-NEXT:    xorl %eax, %eax
; SSE-32-NEXT:    ucomiss %xmm3, %xmm2
; SSE-32-NEXT:    movl $-1, %ecx
; SSE-32-NEXT:    movl $-1, %edx
; SSE-32-NEXT:    cmovnel %eax, %edx
; SSE-32-NEXT:    cmovpl %eax, %edx
; SSE-32-NEXT:    movd %edx, %xmm4
; SSE-32-NEXT:    shufps {{.*#+}} xmm3 = xmm3[1,1,1,1]
; SSE-32-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1,1,1]
; SSE-32-NEXT:    ucomiss %xmm3, %xmm2
; SSE-32-NEXT:    cmovnel %eax, %ecx
; SSE-32-NEXT:    cmovpl %eax, %ecx
; SSE-32-NEXT:    movd %ecx, %xmm2
; SSE-32-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
; SSE-32-NEXT:    pand %xmm4, %xmm0
; SSE-32-NEXT:    pandn %xmm1, %xmm4
; SSE-32-NEXT:    por %xmm4, %xmm0
; SSE-32-NEXT:    movl %ebp, %esp
; SSE-32-NEXT:    popl %ebp
; SSE-32-NEXT:    retl
;
; SSE-64-LABEL: test_v2f32_oeq_q:
; SSE-64:       # %bb.0:
; SSE-64-NEXT:    xorl %eax, %eax
; SSE-64-NEXT:    ucomiss %xmm3, %xmm2
; SSE-64-NEXT:    movl $-1, %ecx
; SSE-64-NEXT:    movl $-1, %edx
; SSE-64-NEXT:    cmovnel %eax, %edx
; SSE-64-NEXT:    cmovpl %eax, %edx
; SSE-64-NEXT:    movd %edx, %xmm4
; SSE-64-NEXT:    shufps {{.*#+}} xmm3 = xmm3[1,1,1,1]
; SSE-64-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1,1,1]
; SSE-64-NEXT:    ucomiss %xmm3, %xmm2
; SSE-64-NEXT:    cmovnel %eax, %ecx
; SSE-64-NEXT:    cmovpl %eax, %ecx
; SSE-64-NEXT:    movd %ecx, %xmm2
; SSE-64-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
; SSE-64-NEXT:    pand %xmm4, %xmm0
; SSE-64-NEXT:    pandn %xmm1, %xmm4
; SSE-64-NEXT:    por %xmm4, %xmm0
; SSE-64-NEXT:    retq
;
; AVX-32-LABEL: test_v2f32_oeq_q:
; AVX-32:       # %bb.0:
; AVX-32-NEXT:    pushl %ebp
; AVX-32-NEXT:    movl %esp, %ebp
; AVX-32-NEXT:    andl $-16, %esp
; AVX-32-NEXT:    subl $16, %esp
; AVX-32-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm2[1,1,3,3]
; AVX-32-NEXT:    xorl %eax, %eax
; AVX-32-NEXT:    vucomiss 12(%ebp), %xmm3
; AVX-32-NEXT:    movl $-1, %ecx
; AVX-32-NEXT:    movl $-1, %edx
; AVX-32-NEXT:    cmovnel %eax, %edx
; AVX-32-NEXT:    cmovpl %eax, %edx
; AVX-32-NEXT:    vucomiss 8(%ebp), %xmm2
; AVX-32-NEXT:    cmovnel %eax, %ecx
; AVX-32-NEXT:    cmovpl %eax, %ecx
; AVX-32-NEXT:    vmovd %ecx, %xmm2
; AVX-32-NEXT:    vpinsrd $1, %edx, %xmm2, %xmm2
; AVX-32-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX-32-NEXT:    movl %ebp, %esp
; AVX-32-NEXT:    popl %ebp
; AVX-32-NEXT:    retl
;
; AVX-64-LABEL: test_v2f32_oeq_q:
; AVX-64:       # %bb.0:
; AVX-64-NEXT:    vmovshdup {{.*#+}} xmm4 = xmm3[1,1,3,3]
; AVX-64-NEXT:    vmovshdup {{.*#+}} xmm5 = xmm2[1,1,3,3]
; AVX-64-NEXT:    xorl %eax, %eax
; AVX-64-NEXT:    vucomiss %xmm4, %xmm5
; AVX-64-NEXT:    movl $-1, %ecx
; AVX-64-NEXT:    movl $-1, %edx
; AVX-64-NEXT:    cmovnel %eax, %edx
; AVX-64-NEXT:    cmovpl %eax, %edx
; AVX-64-NEXT:    vucomiss %xmm3, %xmm2
; AVX-64-NEXT:    cmovnel %eax, %ecx
; AVX-64-NEXT:    cmovpl %eax, %ecx
; AVX-64-NEXT:    vmovd %ecx, %xmm2
; AVX-64-NEXT:    vpinsrd $1, %edx, %xmm2, %xmm2
; AVX-64-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX-64-NEXT:    retq
;
; AVX512-32-LABEL: test_v2f32_oeq_q:
; AVX512-32:       # %bb.0:
; AVX512-32-NEXT:    pushl %ebp
; AVX512-32-NEXT:    movl %esp, %ebp
; AVX512-32-NEXT:    andl $-16, %esp
; AVX512-32-NEXT:    subl $16, %esp
; AVX512-32-NEXT:    movw $-3, %ax
; AVX512-32-NEXT:    kmovw %eax, %k0
; AVX512-32-NEXT:    vucomiss 8(%ebp), %xmm2
; AVX512-32-NEXT:    setnp %al
; AVX512-32-NEXT:    sete %cl
; AVX512-32-NEXT:    testb %al, %cl
; AVX512-32-NEXT:    setne %al
; AVX512-32-NEXT:    kmovw %eax, %k1
; AVX512-32-NEXT:    kandw %k0, %k1, %k0
; AVX512-32-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512-32-NEXT:    vucomiss 12(%ebp), %xmm2
; AVX512-32-NEXT:    setnp %al
; AVX512-32-NEXT:    sete %cl
; AVX512-32-NEXT:    testb %al, %cl
; AVX512-32-NEXT:    setne %al
; AVX512-32-NEXT:    kmovw %eax, %k1
; AVX512-32-NEXT:    kshiftlw $15, %k1, %k1
; AVX512-32-NEXT:    kshiftrw $14, %k1, %k1
; AVX512-32-NEXT:    korw %k1, %k0, %k1
; AVX512-32-NEXT:    vpblendmd %xmm0, %xmm1, %xmm0 {%k1}
; AVX512-32-NEXT:    movl %ebp, %esp
; AVX512-32-NEXT:    popl %ebp
; AVX512-32-NEXT:    retl
;
; AVX512-64-LABEL: test_v2f32_oeq_q:
; AVX512-64:       # %bb.0:
; AVX512-64-NEXT:    vucomiss %xmm3, %xmm2
; AVX512-64-NEXT:    setnp %al
; AVX512-64-NEXT:    sete %cl
; AVX512-64-NEXT:    testb %al, %cl
; AVX512-64-NEXT:    setne %al
; AVX512-64-NEXT:    kmovw %eax, %k0
; AVX512-64-NEXT:    movw $-3, %ax
; AVX512-64-NEXT:    kmovw %eax, %k1
; AVX512-64-NEXT:    kandw %k1, %k0, %k0
; AVX512-64-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX512-64-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512-64-NEXT:    vucomiss %xmm3, %xmm2
; AVX512-64-NEXT:    setnp %al
; AVX512-64-NEXT:    sete %cl
; AVX512-64-NEXT:    testb %al, %cl
; AVX512-64-NEXT:    setne %al
; AVX512-64-NEXT:    kmovw %eax, %k1
; AVX512-64-NEXT:    kshiftlw $15, %k1, %k1
; AVX512-64-NEXT:    kshiftrw $14, %k1, %k1
; AVX512-64-NEXT:    korw %k1, %k0, %k1
; AVX512-64-NEXT:    vpblendmd %xmm0, %xmm1, %xmm0 {%k1}
; AVX512-64-NEXT:    retq
;
; AVX512F-32-LABEL: test_v2f32_oeq_q:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    pushl %ebp
; AVX512F-32-NEXT:    movl %esp, %ebp
; AVX512F-32-NEXT:    andl $-16, %esp
; AVX512F-32-NEXT:    subl $16, %esp
; AVX512F-32-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-32-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-32-NEXT:    movw $-3, %ax
; AVX512F-32-NEXT:    kmovw %eax, %k0
; AVX512F-32-NEXT:    vucomiss 8(%ebp), %xmm2
; AVX512F-32-NEXT:    setnp %al
; AVX512F-32-NEXT:    sete %cl
; AVX512F-32-NEXT:    testb %al, %cl
; AVX512F-32-NEXT:    setne %al
; AVX512F-32-NEXT:    kmovw %eax, %k1
; AVX512F-32-NEXT:    kandw %k0, %k1, %k0
; AVX512F-32-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512F-32-NEXT:    vucomiss 12(%ebp), %xmm2
; AVX512F-32-NEXT:    setnp %al
; AVX512F-32-NEXT:    sete %cl
; AVX512F-32-NEXT:    testb %al, %cl
; AVX512F-32-NEXT:    setne %al
; AVX512F-32-NEXT:    kmovw %eax, %k1
; AVX512F-32-NEXT:    kshiftlw $15, %k1, %k1
; AVX512F-32-NEXT:    kshiftrw $14, %k1, %k1
; AVX512F-32-NEXT:    korw %k1, %k0, %k1
; AVX512F-32-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512F-32-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-32-NEXT:    movl %ebp, %esp
; AVX512F-32-NEXT:    popl %ebp
; AVX512F-32-NEXT:    vzeroupper
; AVX512F-32-NEXT:    retl
;
; AVX512F-64-LABEL: test_v2f32_oeq_q:
; AVX512F-64:       # %bb.0:
; AVX512F-64-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-64-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-64-NEXT:    vucomiss %xmm3, %xmm2
; AVX512F-64-NEXT:    setnp %al
; AVX512F-64-NEXT:    sete %cl
; AVX512F-64-NEXT:    testb %al, %cl
; AVX512F-64-NEXT:    setne %al
; AVX512F-64-NEXT:    kmovw %eax, %k0
; AVX512F-64-NEXT:    movw $-3, %ax
; AVX512F-64-NEXT:    kmovw %eax, %k1
; AVX512F-64-NEXT:    kandw %k1, %k0, %k0
; AVX512F-64-NEXT:    vmovshdup {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX512F-64-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX512F-64-NEXT:    vucomiss %xmm3, %xmm2
; AVX512F-64-NEXT:    setnp %al
; AVX512F-64-NEXT:    sete %cl
; AVX512F-64-NEXT:    testb %al, %cl
; AVX512F-64-NEXT:    setne %al
; AVX512F-64-NEXT:    kmovw %eax, %k1
; AVX512F-64-NEXT:    kshiftlw $15, %k1, %k1
; AVX512F-64-NEXT:    kshiftrw $14, %k1, %k1
; AVX512F-64-NEXT:    korw %k1, %k0, %k1
; AVX512F-64-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512F-64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-64-NEXT:    vzeroupper
; AVX512F-64-NEXT:    retq
  %cond = call <2 x i1> @llvm.experimental.constrained.fcmp.v2f32(
                                               <2 x float> %f1, <2 x float> %f2, metadata !"oeq",
                                               metadata !"fpexcept.strict") #0
  %res = select <2 x i1> %cond, <2 x i32> %a, <2 x i32> %b
  ret <2 x i32> %res
}

attributes #0 = { strictfp nounwind }

declare <2 x i1> @llvm.experimental.constrained.fcmp.v2f32(<2 x float>, <2 x float>, metadata, metadata)
declare <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float>, <2 x float>, metadata, metadata)
