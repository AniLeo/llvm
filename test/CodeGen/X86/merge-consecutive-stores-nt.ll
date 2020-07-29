; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=X86,X86-SSE2
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefixes=X86,X86-SSE4A
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=X64,X64-SSE,X64-SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefixes=X64,X64-SSE,X64-SSE4A
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=X64,X64-SSE,X64-SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefixes=X64,X64-AVX,X64-AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=X64,X64-AVX,X64-AVX2

;
; PR42123
;

define void @merge_2_v4f32_align32(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-LABEL: merge_2_v4f32_align32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movaps (%ecx), %xmm0
; X86-NEXT:    movaps 16(%ecx), %xmm1
; X86-NEXT:    movntps %xmm0, (%eax)
; X86-NEXT:    movntps %xmm1, 16(%eax)
; X86-NEXT:    retl
;
; X64-SSE2-LABEL: merge_2_v4f32_align32:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    movaps (%rdi), %xmm0
; X64-SSE2-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE2-NEXT:    movntps %xmm0, (%rsi)
; X64-SSE2-NEXT:    movntps %xmm1, 16(%rsi)
; X64-SSE2-NEXT:    retq
;
; X64-SSE4A-LABEL: merge_2_v4f32_align32:
; X64-SSE4A:       # %bb.0:
; X64-SSE4A-NEXT:    movaps (%rdi), %xmm0
; X64-SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE4A-NEXT:    movntps %xmm0, (%rsi)
; X64-SSE4A-NEXT:    movntps %xmm1, 16(%rsi)
; X64-SSE4A-NEXT:    retq
;
; X64-SSE41-LABEL: merge_2_v4f32_align32:
; X64-SSE41:       # %bb.0:
; X64-SSE41-NEXT:    movntdqa (%rdi), %xmm0
; X64-SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; X64-SSE41-NEXT:    movntdq %xmm0, (%rsi)
; X64-SSE41-NEXT:    movntdq %xmm1, 16(%rsi)
; X64-SSE41-NEXT:    retq
;
; X64-AVX1-LABEL: merge_2_v4f32_align32:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm0
; X64-AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; X64-AVX1-NEXT:    vmovntdq %xmm1, (%rsi)
; X64-AVX1-NEXT:    vmovntdq %xmm0, 16(%rsi)
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: merge_2_v4f32_align32:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; X64-AVX2-NEXT:    vmovntdq %ymm0, (%rsi)
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 32, !nontemporal !0
  %4 = load <4 x float>, <4 x float>* %2, align 16, !nontemporal !0
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 32, !nontemporal !0
  store <4 x float> %4, <4 x float>* %6, align 16, !nontemporal !0
  ret void
}

; Don't merge nt and non-nt loads even if aligned.
define void @merge_2_v4f32_align32_mix_ntload(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-LABEL: merge_2_v4f32_align32_mix_ntload:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movaps (%ecx), %xmm0
; X86-NEXT:    movaps 16(%ecx), %xmm1
; X86-NEXT:    movaps %xmm0, (%eax)
; X86-NEXT:    movaps %xmm1, 16(%eax)
; X86-NEXT:    retl
;
; X64-SSE2-LABEL: merge_2_v4f32_align32_mix_ntload:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    movaps (%rdi), %xmm0
; X64-SSE2-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE2-NEXT:    movaps %xmm0, (%rsi)
; X64-SSE2-NEXT:    movaps %xmm1, 16(%rsi)
; X64-SSE2-NEXT:    retq
;
; X64-SSE4A-LABEL: merge_2_v4f32_align32_mix_ntload:
; X64-SSE4A:       # %bb.0:
; X64-SSE4A-NEXT:    movaps (%rdi), %xmm0
; X64-SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE4A-NEXT:    movaps %xmm0, (%rsi)
; X64-SSE4A-NEXT:    movaps %xmm1, 16(%rsi)
; X64-SSE4A-NEXT:    retq
;
; X64-SSE41-LABEL: merge_2_v4f32_align32_mix_ntload:
; X64-SSE41:       # %bb.0:
; X64-SSE41-NEXT:    movntdqa (%rdi), %xmm0
; X64-SSE41-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE41-NEXT:    movdqa %xmm0, (%rsi)
; X64-SSE41-NEXT:    movaps %xmm1, 16(%rsi)
; X64-SSE41-NEXT:    retq
;
; X64-AVX-LABEL: merge_2_v4f32_align32_mix_ntload:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; X64-AVX-NEXT:    vmovaps 16(%rdi), %xmm1
; X64-AVX-NEXT:    vmovdqa %xmm0, (%rsi)
; X64-AVX-NEXT:    vmovaps %xmm1, 16(%rsi)
; X64-AVX-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 32, !nontemporal !0
  %4 = load <4 x float>, <4 x float>* %2, align 16
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 32
  store <4 x float> %4, <4 x float>* %6, align 16
  ret void
}

; Don't merge nt and non-nt stores even if aligned.
define void @merge_2_v4f32_align32_mix_ntstore(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-LABEL: merge_2_v4f32_align32_mix_ntstore:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movaps (%ecx), %xmm0
; X86-NEXT:    movaps 16(%ecx), %xmm1
; X86-NEXT:    movntps %xmm0, (%eax)
; X86-NEXT:    movaps %xmm1, 16(%eax)
; X86-NEXT:    retl
;
; X64-SSE-LABEL: merge_2_v4f32_align32_mix_ntstore:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movaps (%rdi), %xmm0
; X64-SSE-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE-NEXT:    movntps %xmm0, (%rsi)
; X64-SSE-NEXT:    movaps %xmm1, 16(%rsi)
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: merge_2_v4f32_align32_mix_ntstore:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovaps (%rdi), %xmm0
; X64-AVX-NEXT:    vmovaps 16(%rdi), %xmm1
; X64-AVX-NEXT:    vmovntps %xmm0, (%rsi)
; X64-AVX-NEXT:    vmovaps %xmm1, 16(%rsi)
; X64-AVX-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 32
  %4 = load <4 x float>, <4 x float>* %2, align 16
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 32, !nontemporal !0
  store <4 x float> %4, <4 x float>* %6, align 16
  ret void
}

; AVX2 can't perform NT-load-ymm on 16-byte aligned memory.
; Must be kept seperate as VMOVNTDQA xmm.
define void @merge_2_v4f32_align16_ntload(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-LABEL: merge_2_v4f32_align16_ntload:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movaps (%ecx), %xmm0
; X86-NEXT:    movaps 16(%ecx), %xmm1
; X86-NEXT:    movaps %xmm0, (%eax)
; X86-NEXT:    movaps %xmm1, 16(%eax)
; X86-NEXT:    retl
;
; X64-SSE2-LABEL: merge_2_v4f32_align16_ntload:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    movaps (%rdi), %xmm0
; X64-SSE2-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE2-NEXT:    movaps %xmm0, (%rsi)
; X64-SSE2-NEXT:    movaps %xmm1, 16(%rsi)
; X64-SSE2-NEXT:    retq
;
; X64-SSE4A-LABEL: merge_2_v4f32_align16_ntload:
; X64-SSE4A:       # %bb.0:
; X64-SSE4A-NEXT:    movaps (%rdi), %xmm0
; X64-SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE4A-NEXT:    movaps %xmm0, (%rsi)
; X64-SSE4A-NEXT:    movaps %xmm1, 16(%rsi)
; X64-SSE4A-NEXT:    retq
;
; X64-SSE41-LABEL: merge_2_v4f32_align16_ntload:
; X64-SSE41:       # %bb.0:
; X64-SSE41-NEXT:    movntdqa (%rdi), %xmm0
; X64-SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; X64-SSE41-NEXT:    movdqa %xmm0, (%rsi)
; X64-SSE41-NEXT:    movdqa %xmm1, 16(%rsi)
; X64-SSE41-NEXT:    retq
;
; X64-AVX-LABEL: merge_2_v4f32_align16_ntload:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; X64-AVX-NEXT:    vmovntdqa 16(%rdi), %xmm1
; X64-AVX-NEXT:    vmovdqa %xmm0, (%rsi)
; X64-AVX-NEXT:    vmovdqa %xmm1, 16(%rsi)
; X64-AVX-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 16, !nontemporal !0
  %4 = load <4 x float>, <4 x float>* %2, align 16, !nontemporal !0
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 16
  store <4 x float> %4, <4 x float>* %6, align 16
  ret void
}

; AVX can't perform NT-store-ymm on 16-byte aligned memory.
; Must be kept seperate as VMOVNTPS xmm.
define void @merge_2_v4f32_align16_ntstore(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-LABEL: merge_2_v4f32_align16_ntstore:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movaps (%ecx), %xmm0
; X86-NEXT:    movaps 16(%ecx), %xmm1
; X86-NEXT:    movntps %xmm0, (%eax)
; X86-NEXT:    movntps %xmm1, 16(%eax)
; X86-NEXT:    retl
;
; X64-SSE-LABEL: merge_2_v4f32_align16_ntstore:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movaps (%rdi), %xmm0
; X64-SSE-NEXT:    movaps 16(%rdi), %xmm1
; X64-SSE-NEXT:    movntps %xmm0, (%rsi)
; X64-SSE-NEXT:    movntps %xmm1, 16(%rsi)
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: merge_2_v4f32_align16_ntstore:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovaps (%rdi), %xmm0
; X64-AVX-NEXT:    vmovaps 16(%rdi), %xmm1
; X64-AVX-NEXT:    vmovntps %xmm0, (%rsi)
; X64-AVX-NEXT:    vmovntps %xmm1, 16(%rsi)
; X64-AVX-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 16
  %4 = load <4 x float>, <4 x float>* %2, align 16
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 16, !nontemporal !0
  store <4 x float> %4, <4 x float>* %6, align 16, !nontemporal !0
  ret void
}

; Nothing can perform NT-load-vector on 1-byte aligned memory.
; Just perform regular loads.
define void @merge_2_v4f32_align1_ntload(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-LABEL: merge_2_v4f32_align1_ntload:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movups (%ecx), %xmm0
; X86-NEXT:    movups 16(%ecx), %xmm1
; X86-NEXT:    movups %xmm0, (%eax)
; X86-NEXT:    movups %xmm1, 16(%eax)
; X86-NEXT:    retl
;
; X64-SSE-LABEL: merge_2_v4f32_align1_ntload:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movups (%rdi), %xmm0
; X64-SSE-NEXT:    movups 16(%rdi), %xmm1
; X64-SSE-NEXT:    movups %xmm0, (%rsi)
; X64-SSE-NEXT:    movups %xmm1, 16(%rsi)
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: merge_2_v4f32_align1_ntload:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovups (%rdi), %ymm0
; X64-AVX-NEXT:    vmovups %ymm0, (%rsi)
; X64-AVX-NEXT:    vzeroupper
; X64-AVX-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 1, !nontemporal !0
  %4 = load <4 x float>, <4 x float>* %2, align 1, !nontemporal !0
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 1
  store <4 x float> %4, <4 x float>* %6, align 1
  ret void
}

; Nothing can perform NT-store-vector on 1-byte aligned memory.
; Must be scalarized to use MOVTNI/MOVNTSD.
define void @merge_2_v4f32_align1_ntstore(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-SSE2-LABEL: merge_2_v4f32_align1_ntstore:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE2-NEXT:    movdqu (%ecx), %xmm0
; X86-SSE2-NEXT:    movdqu 16(%ecx), %xmm1
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, (%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[3,3,3,3]
; X86-SSE2-NEXT:    movd %xmm2, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 12(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[2,3,2,3]
; X86-SSE2-NEXT:    movd %xmm2, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 8(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 4(%eax)
; X86-SSE2-NEXT:    movd %xmm1, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 16(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[3,3,3,3]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 28(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,2,3]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 24(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,1,1]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 20(%eax)
; X86-SSE2-NEXT:    retl
;
; X86-SSE4A-LABEL: merge_2_v4f32_align1_ntstore:
; X86-SSE4A:       # %bb.0:
; X86-SSE4A-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE4A-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE4A-NEXT:    movups (%ecx), %xmm0
; X86-SSE4A-NEXT:    movups 16(%ecx), %xmm1
; X86-SSE4A-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; X86-SSE4A-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; X86-SSE4A-NEXT:    movntsd %xmm2, 8(%eax)
; X86-SSE4A-NEXT:    movntsd %xmm0, (%eax)
; X86-SSE4A-NEXT:    movntsd %xmm3, 24(%eax)
; X86-SSE4A-NEXT:    movntsd %xmm1, 16(%eax)
; X86-SSE4A-NEXT:    retl
;
; X64-SSE2-LABEL: merge_2_v4f32_align1_ntstore:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    movdqu (%rdi), %xmm0
; X64-SSE2-NEXT:    movdqu 16(%rdi), %xmm1
; X64-SSE2-NEXT:    movq %xmm0, %rax
; X64-SSE2-NEXT:    movntiq %rax, (%rsi)
; X64-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; X64-SSE2-NEXT:    movq %xmm0, %rax
; X64-SSE2-NEXT:    movntiq %rax, 8(%rsi)
; X64-SSE2-NEXT:    movq %xmm1, %rax
; X64-SSE2-NEXT:    movntiq %rax, 16(%rsi)
; X64-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,2,3]
; X64-SSE2-NEXT:    movq %xmm0, %rax
; X64-SSE2-NEXT:    movntiq %rax, 24(%rsi)
; X64-SSE2-NEXT:    retq
;
; X64-SSE4A-LABEL: merge_2_v4f32_align1_ntstore:
; X64-SSE4A:       # %bb.0:
; X64-SSE4A-NEXT:    movups (%rdi), %xmm0
; X64-SSE4A-NEXT:    movups 16(%rdi), %xmm1
; X64-SSE4A-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; X64-SSE4A-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; X64-SSE4A-NEXT:    movntsd %xmm2, 8(%rsi)
; X64-SSE4A-NEXT:    movntsd %xmm0, (%rsi)
; X64-SSE4A-NEXT:    movntsd %xmm3, 24(%rsi)
; X64-SSE4A-NEXT:    movntsd %xmm1, 16(%rsi)
; X64-SSE4A-NEXT:    retq
;
; X64-SSE41-LABEL: merge_2_v4f32_align1_ntstore:
; X64-SSE41:       # %bb.0:
; X64-SSE41-NEXT:    movdqu (%rdi), %xmm0
; X64-SSE41-NEXT:    movdqu 16(%rdi), %xmm1
; X64-SSE41-NEXT:    pextrq $1, %xmm0, %rax
; X64-SSE41-NEXT:    movntiq %rax, 8(%rsi)
; X64-SSE41-NEXT:    movq %xmm0, %rax
; X64-SSE41-NEXT:    movntiq %rax, (%rsi)
; X64-SSE41-NEXT:    pextrq $1, %xmm1, %rax
; X64-SSE41-NEXT:    movntiq %rax, 24(%rsi)
; X64-SSE41-NEXT:    movq %xmm1, %rax
; X64-SSE41-NEXT:    movntiq %rax, 16(%rsi)
; X64-SSE41-NEXT:    retq
;
; X64-AVX-LABEL: merge_2_v4f32_align1_ntstore:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqu (%rdi), %xmm0
; X64-AVX-NEXT:    vmovdqu 16(%rdi), %xmm1
; X64-AVX-NEXT:    vpextrq $1, %xmm0, %rax
; X64-AVX-NEXT:    movntiq %rax, 8(%rsi)
; X64-AVX-NEXT:    vmovq %xmm0, %rax
; X64-AVX-NEXT:    movntiq %rax, (%rsi)
; X64-AVX-NEXT:    vpextrq $1, %xmm1, %rax
; X64-AVX-NEXT:    movntiq %rax, 24(%rsi)
; X64-AVX-NEXT:    vmovq %xmm1, %rax
; X64-AVX-NEXT:    movntiq %rax, 16(%rsi)
; X64-AVX-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 1
  %4 = load <4 x float>, <4 x float>* %2, align 1
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 1, !nontemporal !0
  store <4 x float> %4, <4 x float>* %6, align 1, !nontemporal !0
  ret void
}

; Nothing can perform NT-load-vector on 1-byte aligned memory.
; Just perform regular loads and scalarize NT-stores.
define void @merge_2_v4f32_align1(<4 x float>* %a0, <4 x float>* %a1) nounwind {
; X86-SSE2-LABEL: merge_2_v4f32_align1:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE2-NEXT:    movdqu (%ecx), %xmm0
; X86-SSE2-NEXT:    movdqu 16(%ecx), %xmm1
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, (%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[3,3,3,3]
; X86-SSE2-NEXT:    movd %xmm2, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 12(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[2,3,2,3]
; X86-SSE2-NEXT:    movd %xmm2, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 8(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 4(%eax)
; X86-SSE2-NEXT:    movd %xmm1, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 16(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[3,3,3,3]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 28(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,2,3]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 24(%eax)
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,1,1]
; X86-SSE2-NEXT:    movd %xmm0, %ecx
; X86-SSE2-NEXT:    movntil %ecx, 20(%eax)
; X86-SSE2-NEXT:    retl
;
; X86-SSE4A-LABEL: merge_2_v4f32_align1:
; X86-SSE4A:       # %bb.0:
; X86-SSE4A-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE4A-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE4A-NEXT:    movups (%ecx), %xmm0
; X86-SSE4A-NEXT:    movups 16(%ecx), %xmm1
; X86-SSE4A-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; X86-SSE4A-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; X86-SSE4A-NEXT:    movntsd %xmm2, 8(%eax)
; X86-SSE4A-NEXT:    movntsd %xmm0, (%eax)
; X86-SSE4A-NEXT:    movntsd %xmm3, 24(%eax)
; X86-SSE4A-NEXT:    movntsd %xmm1, 16(%eax)
; X86-SSE4A-NEXT:    retl
;
; X64-SSE2-LABEL: merge_2_v4f32_align1:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    movdqu (%rdi), %xmm0
; X64-SSE2-NEXT:    movdqu 16(%rdi), %xmm1
; X64-SSE2-NEXT:    movq %xmm0, %rax
; X64-SSE2-NEXT:    movntiq %rax, (%rsi)
; X64-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; X64-SSE2-NEXT:    movq %xmm0, %rax
; X64-SSE2-NEXT:    movntiq %rax, 8(%rsi)
; X64-SSE2-NEXT:    movq %xmm1, %rax
; X64-SSE2-NEXT:    movntiq %rax, 16(%rsi)
; X64-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,2,3]
; X64-SSE2-NEXT:    movq %xmm0, %rax
; X64-SSE2-NEXT:    movntiq %rax, 24(%rsi)
; X64-SSE2-NEXT:    retq
;
; X64-SSE4A-LABEL: merge_2_v4f32_align1:
; X64-SSE4A:       # %bb.0:
; X64-SSE4A-NEXT:    movups (%rdi), %xmm0
; X64-SSE4A-NEXT:    movups 16(%rdi), %xmm1
; X64-SSE4A-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; X64-SSE4A-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; X64-SSE4A-NEXT:    movntsd %xmm2, 8(%rsi)
; X64-SSE4A-NEXT:    movntsd %xmm0, (%rsi)
; X64-SSE4A-NEXT:    movntsd %xmm3, 24(%rsi)
; X64-SSE4A-NEXT:    movntsd %xmm1, 16(%rsi)
; X64-SSE4A-NEXT:    retq
;
; X64-SSE41-LABEL: merge_2_v4f32_align1:
; X64-SSE41:       # %bb.0:
; X64-SSE41-NEXT:    movdqu (%rdi), %xmm0
; X64-SSE41-NEXT:    movdqu 16(%rdi), %xmm1
; X64-SSE41-NEXT:    pextrq $1, %xmm0, %rax
; X64-SSE41-NEXT:    movntiq %rax, 8(%rsi)
; X64-SSE41-NEXT:    movq %xmm0, %rax
; X64-SSE41-NEXT:    movntiq %rax, (%rsi)
; X64-SSE41-NEXT:    pextrq $1, %xmm1, %rax
; X64-SSE41-NEXT:    movntiq %rax, 24(%rsi)
; X64-SSE41-NEXT:    movq %xmm1, %rax
; X64-SSE41-NEXT:    movntiq %rax, 16(%rsi)
; X64-SSE41-NEXT:    retq
;
; X64-AVX-LABEL: merge_2_v4f32_align1:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqu (%rdi), %xmm0
; X64-AVX-NEXT:    vmovdqu 16(%rdi), %xmm1
; X64-AVX-NEXT:    vpextrq $1, %xmm0, %rax
; X64-AVX-NEXT:    movntiq %rax, 8(%rsi)
; X64-AVX-NEXT:    vmovq %xmm0, %rax
; X64-AVX-NEXT:    movntiq %rax, (%rsi)
; X64-AVX-NEXT:    vpextrq $1, %xmm1, %rax
; X64-AVX-NEXT:    movntiq %rax, 24(%rsi)
; X64-AVX-NEXT:    vmovq %xmm1, %rax
; X64-AVX-NEXT:    movntiq %rax, 16(%rsi)
; X64-AVX-NEXT:    retq
  %1 = getelementptr inbounds <4 x float>, <4 x float>* %a0, i64 1, i64 0
  %2 = bitcast float* %1 to <4 x float>*
  %3 = load <4 x float>, <4 x float>* %a0, align 1, !nontemporal !0
  %4 = load <4 x float>, <4 x float>* %2, align 1, !nontemporal !0
  %5 = getelementptr inbounds <4 x float>, <4 x float>* %a1, i64 1, i64 0
  %6 = bitcast float* %5 to <4 x float>*
  store <4 x float> %3, <4 x float>* %a1, align 1, !nontemporal !0
  store <4 x float> %4, <4 x float>* %6, align 1, !nontemporal !0
  ret void
}

!0 = !{i32 1}
