; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86-SSE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X86-AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X64-AVX

define i32 @f(<4 x float> %A, i8* %B, <2 x double> %C, i32 %D, <2 x i64> %E, <4 x i32> %F, <8 x i16> %G, <16 x i8> %H, i64 %I, i32* %loadptr) nounwind {
; X86-SSE-LABEL: f:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pushl %ebp
; X86-SSE-NEXT:    movl %esp, %ebp
; X86-SSE-NEXT:    pushl %esi
; X86-SSE-NEXT:    andl $-16, %esp
; X86-SSE-NEXT:    subl $16, %esp
; X86-SSE-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; X86-SSE-NEXT:    movl 12(%ebp), %ecx
; X86-SSE-NEXT:    movdqa 56(%ebp), %xmm4
; X86-SSE-NEXT:    movdqa 40(%ebp), %xmm5
; X86-SSE-NEXT:    movdqa 24(%ebp), %xmm6
; X86-SSE-NEXT:    movl 8(%ebp), %esi
; X86-SSE-NEXT:    movl 80(%ebp), %edx
; X86-SSE-NEXT:    movl (%edx), %eax
; X86-SSE-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-SSE-NEXT:    movntps %xmm0, (%esi)
; X86-SSE-NEXT:    paddq {{\.?LCPI[0-9]+_[0-9]+}}, %xmm2
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    movntdq %xmm2, (%esi)
; X86-SSE-NEXT:    addpd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    movntpd %xmm1, (%esi)
; X86-SSE-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm6
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    movntdq %xmm6, (%esi)
; X86-SSE-NEXT:    paddw {{\.?LCPI[0-9]+_[0-9]+}}, %xmm5
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    movntdq %xmm5, (%esi)
; X86-SSE-NEXT:    paddb {{\.?LCPI[0-9]+_[0-9]+}}, %xmm4
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    movntdq %xmm4, (%esi)
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    movntil %ecx, (%esi)
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    movsd %xmm3, (%esi)
; X86-SSE-NEXT:    addl (%edx), %eax
; X86-SSE-NEXT:    leal -4(%ebp), %esp
; X86-SSE-NEXT:    popl %esi
; X86-SSE-NEXT:    popl %ebp
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: f:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    pushl %ebp
; X86-AVX-NEXT:    movl %esp, %ebp
; X86-AVX-NEXT:    pushl %esi
; X86-AVX-NEXT:    andl $-16, %esp
; X86-AVX-NEXT:    subl $16, %esp
; X86-AVX-NEXT:    vmovsd {{.*#+}} xmm3 = mem[0],zero
; X86-AVX-NEXT:    movl 12(%ebp), %ecx
; X86-AVX-NEXT:    vmovdqa 56(%ebp), %xmm4
; X86-AVX-NEXT:    vmovdqa 40(%ebp), %xmm5
; X86-AVX-NEXT:    vmovdqa 24(%ebp), %xmm6
; X86-AVX-NEXT:    movl 8(%ebp), %edx
; X86-AVX-NEXT:    movl 80(%ebp), %esi
; X86-AVX-NEXT:    movl (%esi), %eax
; X86-AVX-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-AVX-NEXT:    vmovntps %xmm0, (%edx)
; X86-AVX-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}, %xmm2, %xmm0
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    vmovntdq %xmm0, (%edx)
; X86-AVX-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1, %xmm0
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    vmovntpd %xmm0, (%edx)
; X86-AVX-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm6, %xmm0
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    vmovntdq %xmm0, (%edx)
; X86-AVX-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}, %xmm5, %xmm0
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    vmovntdq %xmm0, (%edx)
; X86-AVX-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}, %xmm4, %xmm0
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    vmovntdq %xmm0, (%edx)
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    movntil %ecx, (%edx)
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    vmovsd %xmm3, (%edx)
; X86-AVX-NEXT:    addl (%esi), %eax
; X86-AVX-NEXT:    leal -4(%ebp), %esp
; X86-AVX-NEXT:    popl %esi
; X86-AVX-NEXT:    popl %ebp
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: f:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl (%rcx), %eax
; X64-SSE-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-SSE-NEXT:    movntps %xmm0, (%rdi)
; X64-SSE-NEXT:    paddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm2
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    movntdq %xmm2, (%rdi)
; X64-SSE-NEXT:    addpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    movntpd %xmm1, (%rdi)
; X64-SSE-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm3
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    movntdq %xmm3, (%rdi)
; X64-SSE-NEXT:    paddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm4
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    movntdq %xmm4, (%rdi)
; X64-SSE-NEXT:    paddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm5
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    movntdq %xmm5, (%rdi)
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    movntil %esi, (%rdi)
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    movntiq %rdx, (%rdi)
; X64-SSE-NEXT:    addl (%rcx), %eax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: f:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl (%rcx), %eax
; X64-AVX-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vmovntps %xmm0, (%rdi)
; X64-AVX-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm2, %xmm0
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; X64-AVX-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm0
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    vmovntpd %xmm0, (%rdi)
; X64-AVX-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm3, %xmm0
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; X64-AVX-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm4, %xmm0
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; X64-AVX-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm5, %xmm0
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    movntil %esi, (%rdi)
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    movntiq %rdx, (%rdi)
; X64-AVX-NEXT:    addl (%rcx), %eax
; X64-AVX-NEXT:    retq
  %v0 = load i32, i32* %loadptr, align 1
  %cast = bitcast i8* %B to <4 x float>*
  %A2 = fadd <4 x float> %A, <float 1.0, float 2.0, float 3.0, float 4.0>
  store <4 x float> %A2, <4 x float>* %cast, align 16, !nontemporal !0
  %v1   = load i32, i32* %loadptr, align 1
  %cast1 = bitcast i8* %B to <2 x i64>*
  %E2 = add <2 x i64> %E, <i64 1, i64 2>
  store <2 x i64> %E2, <2 x i64>* %cast1, align 16, !nontemporal !0
  %v2   = load i32, i32* %loadptr, align 1
  %cast2 = bitcast i8* %B to <2 x double>*
  %C2 = fadd <2 x double> %C, <double 1.0, double 2.0>
  store <2 x double> %C2, <2 x double>* %cast2, align 16, !nontemporal !0
  %v3   = load i32, i32* %loadptr, align 1
  %cast3 = bitcast i8* %B to <4 x i32>*
  %F2 = add <4 x i32> %F, <i32 1, i32 2, i32 3, i32 4>
  store <4 x i32> %F2, <4 x i32>* %cast3, align 16, !nontemporal !0
  %v4   = load i32, i32* %loadptr, align 1
  %cast4 = bitcast i8* %B to <8 x i16>*
  %G2 = add <8 x i16> %G, <i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8>
  store <8 x i16> %G2, <8 x i16>* %cast4, align 16, !nontemporal !0
  %v5   = load i32, i32* %loadptr, align 1
  %cast5 = bitcast i8* %B to <16 x i8>*
  %H2 = add <16 x i8> %H, <i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8>
  store <16 x i8> %H2, <16 x i8>* %cast5, align 16, !nontemporal !0
  %v6   = load i32, i32* %loadptr, align 1
  %cast6 = bitcast i8* %B to i32*
  store i32 %D, i32* %cast6, align 1, !nontemporal !0
  %v7   = load i32, i32* %loadptr, align 1
  %cast7 = bitcast i8* %B to i64*
  store i64 %I, i64* %cast7, align 1, !nontemporal !0
  %v8   = load i32, i32* %loadptr, align 1
  %sum1 = add i32 %v0, %v1
  %sum2 = add i32 %sum1, %v2
  %sum3 = add i32 %sum2, %v3
  %sum4 = add i32 %sum3, %v4
  %sum5 = add i32 %sum4, %v5
  %sum6 = add i32 %sum5, %v6
  %sum7 = add i32 %sum6, %v7
  %sum8 = add i32 %sum7, %v8
  ret i32 %sum8
}

!0 = !{i32 1}
