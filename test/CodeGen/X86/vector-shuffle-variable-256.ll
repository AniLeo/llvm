; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2

;
; Unary shuffle indices from registers
;

define <4 x double> @var_shuffle_v4f64_v4f64_xxxx_i64(<4 x double> %x, i64 %i0, i64 %i1, i64 %i2, i64 %i3) nounwind {
; ALL-LABEL: var_shuffle_v4f64_v4f64_xxxx_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    pushq %rbp
; ALL-NEXT:    movq %rsp, %rbp
; ALL-NEXT:    andq $-32, %rsp
; ALL-NEXT:    subq $64, %rsp
; ALL-NEXT:    andl $3, %esi
; ALL-NEXT:    andl $3, %edi
; ALL-NEXT:    andl $3, %ecx
; ALL-NEXT:    andl $3, %edx
; ALL-NEXT:    vmovaps %ymm0, (%rsp)
; ALL-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; ALL-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    movq %rbp, %rsp
; ALL-NEXT:    popq %rbp
; ALL-NEXT:    retq
  %x0 = extractelement <4 x double> %x, i64 %i0
  %x1 = extractelement <4 x double> %x, i64 %i1
  %x2 = extractelement <4 x double> %x, i64 %i2
  %x3 = extractelement <4 x double> %x, i64 %i3
  %r0 = insertelement <4 x double> undef, double %x0, i32 0
  %r1 = insertelement <4 x double>   %r0, double %x1, i32 1
  %r2 = insertelement <4 x double>   %r1, double %x2, i32 2
  %r3 = insertelement <4 x double>   %r2, double %x3, i32 3
  ret <4 x double> %r3
}

define <4 x double> @var_shuffle_v4f64_v4f64_uxx0_i64(<4 x double> %x, i64 %i0, i64 %i1, i64 %i2, i64 %i3) nounwind {
; ALL-LABEL: var_shuffle_v4f64_v4f64_uxx0_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    pushq %rbp
; ALL-NEXT:    movq %rsp, %rbp
; ALL-NEXT:    andq $-32, %rsp
; ALL-NEXT:    subq $64, %rsp
; ALL-NEXT:    andl $3, %edx
; ALL-NEXT:    andl $3, %esi
; ALL-NEXT:    vmovaps %ymm0, (%rsp)
; ALL-NEXT:    vmovddup {{.*#+}} xmm0 = mem[0,0]
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; ALL-NEXT:    movq %rbp, %rsp
; ALL-NEXT:    popq %rbp
; ALL-NEXT:    retq
  %x0 = extractelement <4 x double> %x, i64 %i0
  %x1 = extractelement <4 x double> %x, i64 %i1
  %x2 = extractelement <4 x double> %x, i64 %i2
  %x3 = extractelement <4 x double> %x, i64 %i3
  %r0 = insertelement <4 x double> undef, double undef, i32 0
  %r1 = insertelement <4 x double>   %r0, double   %x1, i32 1
  %r2 = insertelement <4 x double>   %r1, double   %x2, i32 2
  %r3 = insertelement <4 x double>   %r2, double   0.0, i32 3
  ret <4 x double> %r3
}

define <4 x double> @var_shuffle_v4f64_v2f64_xxxx_i64(<2 x double> %x, i64 %i0, i64 %i1, i64 %i2, i64 %i3) nounwind {
; ALL-LABEL: var_shuffle_v4f64_v2f64_xxxx_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    andl $1, %esi
; ALL-NEXT:    andl $1, %edi
; ALL-NEXT:    andl $1, %ecx
; ALL-NEXT:    andl $1, %edx
; ALL-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; ALL-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; ALL-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    retq
  %x0 = extractelement <2 x double> %x, i64 %i0
  %x1 = extractelement <2 x double> %x, i64 %i1
  %x2 = extractelement <2 x double> %x, i64 %i2
  %x3 = extractelement <2 x double> %x, i64 %i3
  %r0 = insertelement <4 x double> undef, double %x0, i32 0
  %r1 = insertelement <4 x double>   %r0, double %x1, i32 1
  %r2 = insertelement <4 x double>   %r1, double %x2, i32 2
  %r3 = insertelement <4 x double>   %r2, double %x3, i32 3
  ret <4 x double> %r3
}

define <4 x i64> @var_shuffle_v4i64_v4i64_xxxx_i64(<4 x i64> %x, i64 %i0, i64 %i1, i64 %i2, i64 %i3) nounwind {
; ALL-LABEL: var_shuffle_v4i64_v4i64_xxxx_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    pushq %rbp
; ALL-NEXT:    movq %rsp, %rbp
; ALL-NEXT:    andq $-32, %rsp
; ALL-NEXT:    subq $64, %rsp
; ALL-NEXT:    andl $3, %edi
; ALL-NEXT:    andl $3, %esi
; ALL-NEXT:    andl $3, %edx
; ALL-NEXT:    andl $3, %ecx
; ALL-NEXT:    vmovaps %ymm0, (%rsp)
; ALL-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    movq %rbp, %rsp
; ALL-NEXT:    popq %rbp
; ALL-NEXT:    retq
  %x0 = extractelement <4 x i64> %x, i64 %i0
  %x1 = extractelement <4 x i64> %x, i64 %i1
  %x2 = extractelement <4 x i64> %x, i64 %i2
  %x3 = extractelement <4 x i64> %x, i64 %i3
  %r0 = insertelement <4 x i64> undef, i64 %x0, i32 0
  %r1 = insertelement <4 x i64>   %r0, i64 %x1, i32 1
  %r2 = insertelement <4 x i64>   %r1, i64 %x2, i32 2
  %r3 = insertelement <4 x i64>   %r2, i64 %x3, i32 3
  ret <4 x i64> %r3
}

define <4 x i64> @var_shuffle_v4i64_v4i64_xx00_i64(<4 x i64> %x, i64 %i0, i64 %i1, i64 %i2, i64 %i3) nounwind {
; ALL-LABEL: var_shuffle_v4i64_v4i64_xx00_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    pushq %rbp
; ALL-NEXT:    movq %rsp, %rbp
; ALL-NEXT:    andq $-32, %rsp
; ALL-NEXT:    subq $64, %rsp
; ALL-NEXT:    andl $3, %edi
; ALL-NEXT:    andl $3, %esi
; ALL-NEXT:    vmovaps %ymm0, (%rsp)
; ALL-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; ALL-NEXT:    movq %rbp, %rsp
; ALL-NEXT:    popq %rbp
; ALL-NEXT:    retq
  %x0 = extractelement <4 x i64> %x, i64 %i0
  %x1 = extractelement <4 x i64> %x, i64 %i1
  %x2 = extractelement <4 x i64> %x, i64 %i2
  %x3 = extractelement <4 x i64> %x, i64 %i3
  %r0 = insertelement <4 x i64> undef, i64 %x0, i32 0
  %r1 = insertelement <4 x i64>   %r0, i64 %x1, i32 1
  %r2 = insertelement <4 x i64>   %r1, i64   0, i32 2
  %r3 = insertelement <4 x i64>   %r2, i64   0, i32 3
  ret <4 x i64> %r3
}

define <4 x i64> @var_shuffle_v4i64_v2i64_xxxx_i64(<2 x i64> %x, i64 %i0, i64 %i1, i64 %i2, i64 %i3) nounwind {
; ALL-LABEL: var_shuffle_v4i64_v2i64_xxxx_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    andl $1, %edi
; ALL-NEXT:    andl $1, %esi
; ALL-NEXT:    andl $1, %edx
; ALL-NEXT:    andl $1, %ecx
; ALL-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; ALL-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    retq
  %x0 = extractelement <2 x i64> %x, i64 %i0
  %x1 = extractelement <2 x i64> %x, i64 %i1
  %x2 = extractelement <2 x i64> %x, i64 %i2
  %x3 = extractelement <2 x i64> %x, i64 %i3
  %r0 = insertelement <4 x i64> undef, i64 %x0, i32 0
  %r1 = insertelement <4 x i64>   %r0, i64 %x1, i32 1
  %r2 = insertelement <4 x i64>   %r1, i64 %x2, i32 2
  %r3 = insertelement <4 x i64>   %r2, i64 %x3, i32 3
  ret <4 x i64> %r3
}

define <8 x float> @var_shuffle_v8f32_v8f32_xxxxxxxx_i32(<8 x float> %x, i32 %i0, i32 %i1, i32 %i2, i32 %i3, i32 %i4, i32 %i5, i32 %i6, i32 %i7) nounwind {
; ALL-LABEL: var_shuffle_v8f32_v8f32_xxxxxxxx_i32:
; ALL:       # %bb.0:
; ALL-NEXT:    pushq %rbp
; ALL-NEXT:    movq %rsp, %rbp
; ALL-NEXT:    andq $-32, %rsp
; ALL-NEXT:    subq $64, %rsp
; ALL-NEXT:    # kill: def $r9d killed $r9d def $r9
; ALL-NEXT:    # kill: def $r8d killed $r8d def $r8
; ALL-NEXT:    # kill: def $ecx killed $ecx def $rcx
; ALL-NEXT:    # kill: def $edx killed $edx def $rdx
; ALL-NEXT:    # kill: def $esi killed $esi def $rsi
; ALL-NEXT:    # kill: def $edi killed $edi def $rdi
; ALL-NEXT:    andl $7, %edi
; ALL-NEXT:    andl $7, %esi
; ALL-NEXT:    andl $7, %edx
; ALL-NEXT:    andl $7, %ecx
; ALL-NEXT:    andl $7, %r8d
; ALL-NEXT:    vmovaps %ymm0, (%rsp)
; ALL-NEXT:    andl $7, %r9d
; ALL-NEXT:    movl 16(%rbp), %r10d
; ALL-NEXT:    andl $7, %r10d
; ALL-NEXT:    movl 24(%rbp), %eax
; ALL-NEXT:    andl $7, %eax
; ALL-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; ALL-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; ALL-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; ALL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    movq %rbp, %rsp
; ALL-NEXT:    popq %rbp
; ALL-NEXT:    retq
  %x0 = extractelement <8 x float> %x, i32 %i0
  %x1 = extractelement <8 x float> %x, i32 %i1
  %x2 = extractelement <8 x float> %x, i32 %i2
  %x3 = extractelement <8 x float> %x, i32 %i3
  %x4 = extractelement <8 x float> %x, i32 %i4
  %x5 = extractelement <8 x float> %x, i32 %i5
  %x6 = extractelement <8 x float> %x, i32 %i6
  %x7 = extractelement <8 x float> %x, i32 %i7
  %r0 = insertelement <8 x float> undef, float %x0, i32 0
  %r1 = insertelement <8 x float>   %r0, float %x1, i32 1
  %r2 = insertelement <8 x float>   %r1, float %x2, i32 2
  %r3 = insertelement <8 x float>   %r2, float %x3, i32 3
  %r4 = insertelement <8 x float>   %r3, float %x4, i32 4
  %r5 = insertelement <8 x float>   %r4, float %x5, i32 5
  %r6 = insertelement <8 x float>   %r5, float %x6, i32 6
  %r7 = insertelement <8 x float>   %r6, float %x7, i32 7
  ret <8 x float> %r7
}

define <8 x float> @var_shuffle_v8f32_v4f32_xxxxxxxx_i32(<4 x float> %x, i32 %i0, i32 %i1, i32 %i2, i32 %i3, i32 %i4, i32 %i5, i32 %i6, i32 %i7) nounwind {
; ALL-LABEL: var_shuffle_v8f32_v4f32_xxxxxxxx_i32:
; ALL:       # %bb.0:
; ALL-NEXT:    # kill: def $r9d killed $r9d def $r9
; ALL-NEXT:    # kill: def $r8d killed $r8d def $r8
; ALL-NEXT:    # kill: def $ecx killed $ecx def $rcx
; ALL-NEXT:    # kill: def $edx killed $edx def $rdx
; ALL-NEXT:    # kill: def $esi killed $esi def $rsi
; ALL-NEXT:    # kill: def $edi killed $edi def $rdi
; ALL-NEXT:    andl $3, %edi
; ALL-NEXT:    andl $3, %esi
; ALL-NEXT:    andl $3, %edx
; ALL-NEXT:    andl $3, %ecx
; ALL-NEXT:    andl $3, %r8d
; ALL-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; ALL-NEXT:    andl $3, %r9d
; ALL-NEXT:    movl {{[0-9]+}}(%rsp), %r10d
; ALL-NEXT:    andl $3, %r10d
; ALL-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; ALL-NEXT:    andl $3, %eax
; ALL-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; ALL-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; ALL-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; ALL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; ALL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    retq
  %x0 = extractelement <4 x float> %x, i32 %i0
  %x1 = extractelement <4 x float> %x, i32 %i1
  %x2 = extractelement <4 x float> %x, i32 %i2
  %x3 = extractelement <4 x float> %x, i32 %i3
  %x4 = extractelement <4 x float> %x, i32 %i4
  %x5 = extractelement <4 x float> %x, i32 %i5
  %x6 = extractelement <4 x float> %x, i32 %i6
  %x7 = extractelement <4 x float> %x, i32 %i7
  %r0 = insertelement <8 x float> undef, float %x0, i32 0
  %r1 = insertelement <8 x float>   %r0, float %x1, i32 1
  %r2 = insertelement <8 x float>   %r1, float %x2, i32 2
  %r3 = insertelement <8 x float>   %r2, float %x3, i32 3
  %r4 = insertelement <8 x float>   %r3, float %x4, i32 4
  %r5 = insertelement <8 x float>   %r4, float %x5, i32 5
  %r6 = insertelement <8 x float>   %r5, float %x6, i32 6
  %r7 = insertelement <8 x float>   %r6, float %x7, i32 7
  ret <8 x float> %r7
}

define <16 x i16> @var_shuffle_v16i16_v16i16_xxxxxxxxxxxxxxxx_i16(<16 x i16> %x, i32 %i0, i32 %i1, i32 %i2, i32 %i3, i32 %i4, i32 %i5, i32 %i6, i32 %i7, i32 %i8, i32 %i9, i32 %i10, i32 %i11, i32 %i12, i32 %i13, i32 %i14, i32 %i15) nounwind {
; AVX1-LABEL: var_shuffle_v16i16_v16i16_xxxxxxxxxxxxxxxx_i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    pushq %rbp
; AVX1-NEXT:    movq %rsp, %rbp
; AVX1-NEXT:    andq $-32, %rsp
; AVX1-NEXT:    subq $64, %rsp
; AVX1-NEXT:    # kill: def $r9d killed $r9d def $r9
; AVX1-NEXT:    # kill: def $r8d killed $r8d def $r8
; AVX1-NEXT:    # kill: def $ecx killed $ecx def $rcx
; AVX1-NEXT:    # kill: def $edx killed $edx def $rdx
; AVX1-NEXT:    # kill: def $esi killed $esi def $rsi
; AVX1-NEXT:    # kill: def $edi killed $edi def $rdi
; AVX1-NEXT:    andl $15, %edi
; AVX1-NEXT:    vmovaps %ymm0, (%rsp)
; AVX1-NEXT:    movzwl (%rsp,%rdi,2), %eax
; AVX1-NEXT:    vmovd %eax, %xmm0
; AVX1-NEXT:    andl $15, %esi
; AVX1-NEXT:    vpinsrw $1, (%rsp,%rsi,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $15, %edx
; AVX1-NEXT:    vpinsrw $2, (%rsp,%rdx,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $15, %ecx
; AVX1-NEXT:    vpinsrw $3, (%rsp,%rcx,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $15, %r8d
; AVX1-NEXT:    vpinsrw $4, (%rsp,%r8,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $15, %r9d
; AVX1-NEXT:    vpinsrw $5, (%rsp,%r9,2), %xmm0, %xmm0
; AVX1-NEXT:    movl 16(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $6, (%rsp,%rax,2), %xmm0, %xmm0
; AVX1-NEXT:    movl 24(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $7, (%rsp,%rax,2), %xmm0, %xmm0
; AVX1-NEXT:    movl 32(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    movzwl (%rsp,%rax,2), %eax
; AVX1-NEXT:    vmovd %eax, %xmm1
; AVX1-NEXT:    movl 40(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $1, (%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl 48(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $2, (%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl 56(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $3, (%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl 64(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $4, (%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl 72(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $5, (%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl 80(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $6, (%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl 88(%rbp), %eax
; AVX1-NEXT:    andl $15, %eax
; AVX1-NEXT:    vpinsrw $7, (%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    movq %rbp, %rsp
; AVX1-NEXT:    popq %rbp
; AVX1-NEXT:    retq
;
; AVX2-LABEL: var_shuffle_v16i16_v16i16_xxxxxxxxxxxxxxxx_i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    pushq %rbp
; AVX2-NEXT:    movq %rsp, %rbp
; AVX2-NEXT:    andq $-32, %rsp
; AVX2-NEXT:    subq $64, %rsp
; AVX2-NEXT:    # kill: def $r9d killed $r9d def $r9
; AVX2-NEXT:    # kill: def $r8d killed $r8d def $r8
; AVX2-NEXT:    # kill: def $ecx killed $ecx def $rcx
; AVX2-NEXT:    # kill: def $edx killed $edx def $rdx
; AVX2-NEXT:    # kill: def $esi killed $esi def $rsi
; AVX2-NEXT:    # kill: def $edi killed $edi def $rdi
; AVX2-NEXT:    andl $15, %edi
; AVX2-NEXT:    vmovaps %ymm0, (%rsp)
; AVX2-NEXT:    movzwl (%rsp,%rdi,2), %eax
; AVX2-NEXT:    vmovd %eax, %xmm0
; AVX2-NEXT:    andl $15, %esi
; AVX2-NEXT:    vpinsrw $1, (%rsp,%rsi,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $15, %edx
; AVX2-NEXT:    vpinsrw $2, (%rsp,%rdx,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $15, %ecx
; AVX2-NEXT:    vpinsrw $3, (%rsp,%rcx,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $15, %r8d
; AVX2-NEXT:    vpinsrw $4, (%rsp,%r8,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $15, %r9d
; AVX2-NEXT:    vpinsrw $5, (%rsp,%r9,2), %xmm0, %xmm0
; AVX2-NEXT:    movl 16(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $6, (%rsp,%rax,2), %xmm0, %xmm0
; AVX2-NEXT:    movl 24(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $7, (%rsp,%rax,2), %xmm0, %xmm0
; AVX2-NEXT:    movl 32(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    movzwl (%rsp,%rax,2), %eax
; AVX2-NEXT:    vmovd %eax, %xmm1
; AVX2-NEXT:    movl 40(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $1, (%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl 48(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $2, (%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl 56(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $3, (%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl 64(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $4, (%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl 72(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $5, (%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl 80(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $6, (%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl 88(%rbp), %eax
; AVX2-NEXT:    andl $15, %eax
; AVX2-NEXT:    vpinsrw $7, (%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    movq %rbp, %rsp
; AVX2-NEXT:    popq %rbp
; AVX2-NEXT:    retq
  %x0  = extractelement <16 x i16> %x, i32 %i0
  %x1  = extractelement <16 x i16> %x, i32 %i1
  %x2  = extractelement <16 x i16> %x, i32 %i2
  %x3  = extractelement <16 x i16> %x, i32 %i3
  %x4  = extractelement <16 x i16> %x, i32 %i4
  %x5  = extractelement <16 x i16> %x, i32 %i5
  %x6  = extractelement <16 x i16> %x, i32 %i6
  %x7  = extractelement <16 x i16> %x, i32 %i7
  %x8  = extractelement <16 x i16> %x, i32 %i8
  %x9  = extractelement <16 x i16> %x, i32 %i9
  %x10 = extractelement <16 x i16> %x, i32 %i10
  %x11 = extractelement <16 x i16> %x, i32 %i11
  %x12 = extractelement <16 x i16> %x, i32 %i12
  %x13 = extractelement <16 x i16> %x, i32 %i13
  %x14 = extractelement <16 x i16> %x, i32 %i14
  %x15 = extractelement <16 x i16> %x, i32 %i15
  %r0  = insertelement <16 x i16> undef, i16 %x0 , i32 0
  %r1  = insertelement <16 x i16>  %r0 , i16 %x1 , i32 1
  %r2  = insertelement <16 x i16>  %r1 , i16 %x2 , i32 2
  %r3  = insertelement <16 x i16>  %r2 , i16 %x3 , i32 3
  %r4  = insertelement <16 x i16>  %r3 , i16 %x4 , i32 4
  %r5  = insertelement <16 x i16>  %r4 , i16 %x5 , i32 5
  %r6  = insertelement <16 x i16>  %r5 , i16 %x6 , i32 6
  %r7  = insertelement <16 x i16>  %r6 , i16 %x7 , i32 7
  %r8  = insertelement <16 x i16>  %r7 , i16 %x8 , i32 8
  %r9  = insertelement <16 x i16>  %r8 , i16 %x9 , i32 9
  %r10 = insertelement <16 x i16>  %r9 , i16 %x10, i32 10
  %r11 = insertelement <16 x i16>  %r10, i16 %x11, i32 11
  %r12 = insertelement <16 x i16>  %r11, i16 %x12, i32 12
  %r13 = insertelement <16 x i16>  %r12, i16 %x13, i32 13
  %r14 = insertelement <16 x i16>  %r13, i16 %x14, i32 14
  %r15 = insertelement <16 x i16>  %r14, i16 %x15, i32 15
  ret <16 x i16> %r15
}

define <16 x i16> @var_shuffle_v16i16_v8i16_xxxxxxxxxxxxxxxx_i16(<8 x i16> %x, i32 %i0, i32 %i1, i32 %i2, i32 %i3, i32 %i4, i32 %i5, i32 %i6, i32 %i7, i32 %i8, i32 %i9, i32 %i10, i32 %i11, i32 %i12, i32 %i13, i32 %i14, i32 %i15) nounwind {
; AVX1-LABEL: var_shuffle_v16i16_v8i16_xxxxxxxxxxxxxxxx_i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    # kill: def $r9d killed $r9d def $r9
; AVX1-NEXT:    # kill: def $r8d killed $r8d def $r8
; AVX1-NEXT:    # kill: def $ecx killed $ecx def $rcx
; AVX1-NEXT:    # kill: def $edx killed $edx def $rdx
; AVX1-NEXT:    # kill: def $esi killed $esi def $rsi
; AVX1-NEXT:    # kill: def $edi killed $edi def $rdi
; AVX1-NEXT:    andl $7, %edi
; AVX1-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX1-NEXT:    movzwl -24(%rsp,%rdi,2), %eax
; AVX1-NEXT:    vmovd %eax, %xmm0
; AVX1-NEXT:    andl $7, %esi
; AVX1-NEXT:    vpinsrw $1, -24(%rsp,%rsi,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $7, %edx
; AVX1-NEXT:    vpinsrw $2, -24(%rsp,%rdx,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $7, %ecx
; AVX1-NEXT:    vpinsrw $3, -24(%rsp,%rcx,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $7, %r8d
; AVX1-NEXT:    vpinsrw $4, -24(%rsp,%r8,2), %xmm0, %xmm0
; AVX1-NEXT:    andl $7, %r9d
; AVX1-NEXT:    vpinsrw $5, -24(%rsp,%r9,2), %xmm0, %xmm0
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $6, -24(%rsp,%rax,2), %xmm0, %xmm0
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $7, -24(%rsp,%rax,2), %xmm0, %xmm0
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    movzwl -24(%rsp,%rax,2), %eax
; AVX1-NEXT:    vmovd %eax, %xmm1
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $1, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $2, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $3, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $4, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $5, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $6, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX1-NEXT:    andl $7, %eax
; AVX1-NEXT:    vpinsrw $7, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: var_shuffle_v16i16_v8i16_xxxxxxxxxxxxxxxx_i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    # kill: def $r9d killed $r9d def $r9
; AVX2-NEXT:    # kill: def $r8d killed $r8d def $r8
; AVX2-NEXT:    # kill: def $ecx killed $ecx def $rcx
; AVX2-NEXT:    # kill: def $edx killed $edx def $rdx
; AVX2-NEXT:    # kill: def $esi killed $esi def $rsi
; AVX2-NEXT:    # kill: def $edi killed $edi def $rdi
; AVX2-NEXT:    andl $7, %edi
; AVX2-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX2-NEXT:    movzwl -24(%rsp,%rdi,2), %eax
; AVX2-NEXT:    vmovd %eax, %xmm0
; AVX2-NEXT:    andl $7, %esi
; AVX2-NEXT:    vpinsrw $1, -24(%rsp,%rsi,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $7, %edx
; AVX2-NEXT:    vpinsrw $2, -24(%rsp,%rdx,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $7, %ecx
; AVX2-NEXT:    vpinsrw $3, -24(%rsp,%rcx,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $7, %r8d
; AVX2-NEXT:    vpinsrw $4, -24(%rsp,%r8,2), %xmm0, %xmm0
; AVX2-NEXT:    andl $7, %r9d
; AVX2-NEXT:    vpinsrw $5, -24(%rsp,%r9,2), %xmm0, %xmm0
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $6, -24(%rsp,%rax,2), %xmm0, %xmm0
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $7, -24(%rsp,%rax,2), %xmm0, %xmm0
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    movzwl -24(%rsp,%rax,2), %eax
; AVX2-NEXT:    vmovd %eax, %xmm1
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $1, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $2, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $3, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $4, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $5, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $6, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; AVX2-NEXT:    andl $7, %eax
; AVX2-NEXT:    vpinsrw $7, -24(%rsp,%rax,2), %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %x0  = extractelement <8 x i16> %x, i32 %i0
  %x1  = extractelement <8 x i16> %x, i32 %i1
  %x2  = extractelement <8 x i16> %x, i32 %i2
  %x3  = extractelement <8 x i16> %x, i32 %i3
  %x4  = extractelement <8 x i16> %x, i32 %i4
  %x5  = extractelement <8 x i16> %x, i32 %i5
  %x6  = extractelement <8 x i16> %x, i32 %i6
  %x7  = extractelement <8 x i16> %x, i32 %i7
  %x8  = extractelement <8 x i16> %x, i32 %i8
  %x9  = extractelement <8 x i16> %x, i32 %i9
  %x10 = extractelement <8 x i16> %x, i32 %i10
  %x11 = extractelement <8 x i16> %x, i32 %i11
  %x12 = extractelement <8 x i16> %x, i32 %i12
  %x13 = extractelement <8 x i16> %x, i32 %i13
  %x14 = extractelement <8 x i16> %x, i32 %i14
  %x15 = extractelement <8 x i16> %x, i32 %i15
  %r0  = insertelement <16 x i16> undef, i16 %x0 , i32 0
  %r1  = insertelement <16 x i16>  %r0 , i16 %x1 , i32 1
  %r2  = insertelement <16 x i16>  %r1 , i16 %x2 , i32 2
  %r3  = insertelement <16 x i16>  %r2 , i16 %x3 , i32 3
  %r4  = insertelement <16 x i16>  %r3 , i16 %x4 , i32 4
  %r5  = insertelement <16 x i16>  %r4 , i16 %x5 , i32 5
  %r6  = insertelement <16 x i16>  %r5 , i16 %x6 , i32 6
  %r7  = insertelement <16 x i16>  %r6 , i16 %x7 , i32 7
  %r8  = insertelement <16 x i16>  %r7 , i16 %x8 , i32 8
  %r9  = insertelement <16 x i16>  %r8 , i16 %x9 , i32 9
  %r10 = insertelement <16 x i16>  %r9 , i16 %x10, i32 10
  %r11 = insertelement <16 x i16>  %r10, i16 %x11, i32 11
  %r12 = insertelement <16 x i16>  %r11, i16 %x12, i32 12
  %r13 = insertelement <16 x i16>  %r12, i16 %x13, i32 13
  %r14 = insertelement <16 x i16>  %r13, i16 %x14, i32 14
  %r15 = insertelement <16 x i16>  %r14, i16 %x15, i32 15
  ret <16 x i16> %r15
}

;
; Unary shuffle indices from memory
;

define <4 x i64> @mem_shuffle_v4i64_v4i64_xxxx_i64(<4 x i64> %x, i64* %i) nounwind {
; ALL-LABEL: mem_shuffle_v4i64_v4i64_xxxx_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    pushq %rbp
; ALL-NEXT:    movq %rsp, %rbp
; ALL-NEXT:    andq $-32, %rsp
; ALL-NEXT:    subq $64, %rsp
; ALL-NEXT:    movq (%rdi), %rax
; ALL-NEXT:    movq 8(%rdi), %rcx
; ALL-NEXT:    andl $3, %eax
; ALL-NEXT:    andl $3, %ecx
; ALL-NEXT:    movq 16(%rdi), %rdx
; ALL-NEXT:    andl $3, %edx
; ALL-NEXT:    movq 24(%rdi), %rsi
; ALL-NEXT:    andl $3, %esi
; ALL-NEXT:    vmovaps %ymm0, (%rsp)
; ALL-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    movq %rbp, %rsp
; ALL-NEXT:    popq %rbp
; ALL-NEXT:    retq
  %p0  = getelementptr inbounds i64, i64* %i, i32 0
  %p1  = getelementptr inbounds i64, i64* %i, i32 1
  %p2  = getelementptr inbounds i64, i64* %i, i32 2
  %p3  = getelementptr inbounds i64, i64* %i, i32 3
  %i0  = load i64, i64* %p0, align 4
  %i1  = load i64, i64* %p1, align 4
  %i2  = load i64, i64* %p2, align 4
  %i3  = load i64, i64* %p3, align 4
  %x0 = extractelement <4 x i64> %x, i64 %i0
  %x1 = extractelement <4 x i64> %x, i64 %i1
  %x2 = extractelement <4 x i64> %x, i64 %i2
  %x3 = extractelement <4 x i64> %x, i64 %i3
  %r0 = insertelement <4 x i64> undef, i64 %x0, i32 0
  %r1 = insertelement <4 x i64>   %r0, i64 %x1, i32 1
  %r2 = insertelement <4 x i64>   %r1, i64 %x2, i32 2
  %r3 = insertelement <4 x i64>   %r2, i64 %x3, i32 3
  ret <4 x i64> %r3
}

define <4 x i64> @mem_shuffle_v4i64_v2i64_xxxx_i64(<2 x i64> %x, i64* %i) nounwind {
; ALL-LABEL: mem_shuffle_v4i64_v2i64_xxxx_i64:
; ALL:       # %bb.0:
; ALL-NEXT:    movq (%rdi), %rax
; ALL-NEXT:    movq 8(%rdi), %rcx
; ALL-NEXT:    andl $1, %eax
; ALL-NEXT:    andl $1, %ecx
; ALL-NEXT:    movq 16(%rdi), %rdx
; ALL-NEXT:    andl $1, %edx
; ALL-NEXT:    movq 24(%rdi), %rsi
; ALL-NEXT:    andl $1, %esi
; ALL-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; ALL-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; ALL-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; ALL-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; ALL-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; ALL-NEXT:    retq
  %p0  = getelementptr inbounds i64, i64* %i, i32 0
  %p1  = getelementptr inbounds i64, i64* %i, i32 1
  %p2  = getelementptr inbounds i64, i64* %i, i32 2
  %p3  = getelementptr inbounds i64, i64* %i, i32 3
  %i0  = load i64, i64* %p0, align 4
  %i1  = load i64, i64* %p1, align 4
  %i2  = load i64, i64* %p2, align 4
  %i3  = load i64, i64* %p3, align 4
  %x0 = extractelement <2 x i64> %x, i64 %i0
  %x1 = extractelement <2 x i64> %x, i64 %i1
  %x2 = extractelement <2 x i64> %x, i64 %i2
  %x3 = extractelement <2 x i64> %x, i64 %i3
  %r0 = insertelement <4 x i64> undef, i64 %x0, i32 0
  %r1 = insertelement <4 x i64>   %r0, i64 %x1, i32 1
  %r2 = insertelement <4 x i64>   %r1, i64 %x2, i32 2
  %r3 = insertelement <4 x i64>   %r2, i64 %x3, i32 3
  ret <4 x i64> %r3
}
