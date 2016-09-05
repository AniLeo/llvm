; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-none-linux -fast-isel -fast-isel-abort=1 -mattr=+sse2 < %s | FileCheck %s --check-prefix=ALL32 --check-prefix=SSE32
; RUN: llc -mtriple=i686-none-linux -fast-isel -fast-isel-abort=1 -mattr=+sse2 < %s | FileCheck %s --check-prefix=ALL64 --check-prefix=SSE64
; RUN: llc -mtriple=x86_64-none-linux -fast-isel -fast-isel-abort=1 -mattr=+avx < %s | FileCheck %s --check-prefix=ALL32 --check-prefix=AVX32 --check-prefix=AVXONLY32
; RUN: llc -mtriple=i686-none-linux -fast-isel -fast-isel-abort=1 -mattr=+avx < %s | FileCheck %s --check-prefix=ALL64 --check-prefix=AVX64 --check-prefix=AVXONLY64
; RUN: llc -mtriple=x86_64-none-linux -fast-isel -fast-isel-abort=1 -mattr=+avx512f < %s | FileCheck %s --check-prefix=ALL32 --check-prefix=AVX32 --check-prefix=AVX51232 --check-prefix=KNL32
; RUN: llc -mtriple=i686-none-linux -fast-isel -fast-isel-abort=1 -mattr=+avx512f < %s | FileCheck %s --check-prefix=ALL64 --check-prefix=AVX64 --check-prefix=AVX51264 --check-prefix=KNL64
; RUN: llc -mtriple=x86_64-none-linux -fast-isel -fast-isel-abort=1 -mattr=+avx512vl,+avx512dq,+avx512bw < %s | FileCheck %s --check-prefix=ALL32 --check-prefix=AVX32 --check-prefix=AVX51232 --check-prefix=SKX32
; RUN: llc -mtriple=i686-none-linux -fast-isel -fast-isel-abort=1 -mattr=+avx512f,+avx512dq,+avx512bw < %s | FileCheck %s --check-prefix=ALL64 --check-prefix=AVX64 --check-prefix=AVX51264 --check-prefix=SKX64

define i32 @test_store_32(i32* nocapture %addr, i32 %value) {
; ALL32-LABEL: test_store_32:
; ALL32:       # BB#0: # %entry
; ALL32-NEXT:    movl %esi, (%rdi)
; ALL32-NEXT:    movl %esi, %eax
; ALL32-NEXT:    retq
;
; ALL64-LABEL: test_store_32:
; ALL64:       # BB#0: # %entry
; ALL64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; ALL64-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; ALL64-NEXT:    movl %eax, (%ecx)
; ALL64-NEXT:    retl
entry:
  store i32 %value, i32* %addr, align 1
  ret i32 %value
}

define i16 @test_store_16(i16* nocapture %addr, i16 %value) {
; ALL32-LABEL: test_store_16:
; ALL32:       # BB#0: # %entry
; ALL32-NEXT:    movw %si, (%rdi)
; ALL32-NEXT:    movl %esi, %eax
; ALL32-NEXT:    retq
;
; ALL64-LABEL: test_store_16:
; ALL64:       # BB#0: # %entry
; ALL64-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; ALL64-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; ALL64-NEXT:    movw %ax, (%ecx)
; ALL64-NEXT:    retl
entry:
  store i16 %value, i16* %addr, align 1
  ret i16 %value
}

define <4 x i32> @test_store_4xi32(<4 x i32>* nocapture %addr, <4 x i32> %value, <4 x i32> %value2) {
; SSE32-LABEL: test_store_4xi32:
; SSE32:       # BB#0:
; SSE32-NEXT:    paddd %xmm1, %xmm0
; SSE32-NEXT:    movdqu %xmm0, (%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_4xi32:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    paddd %xmm1, %xmm0
; SSE64-NEXT:    movdqu %xmm0, (%eax)
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_4xi32:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVXONLY32-NEXT:    vmovdqu %xmm0, (%rdi)
; AVXONLY32-NEXT:    retq
;
; AVX64-LABEL: test_store_4xi32:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX64-NEXT:    vmovdqu %xmm0, (%eax)
; AVX64-NEXT:    retl
;
; KNL32-LABEL: test_store_4xi32:
; KNL32:       # BB#0:
; KNL32-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; KNL32-NEXT:    vmovdqu %xmm0, (%rdi)
; KNL32-NEXT:    retq
;
; SKX32-LABEL: test_store_4xi32:
; SKX32:       # BB#0:
; SKX32-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; SKX32-NEXT:    vmovdqu64 %xmm0, (%rdi)
; SKX32-NEXT:    retq
  %foo = add <4 x i32> %value, %value2 ; to force integer type on store
  store <4 x i32> %foo, <4 x i32>* %addr, align 1
  ret <4 x i32> %foo
}

define <4 x i32> @test_store_4xi32_aligned(<4 x i32>* nocapture %addr, <4 x i32> %value, <4 x i32> %value2) {
; SSE32-LABEL: test_store_4xi32_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    paddd %xmm1, %xmm0
; SSE32-NEXT:    movdqa %xmm0, (%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_4xi32_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    paddd %xmm1, %xmm0
; SSE64-NEXT:    movdqa %xmm0, (%eax)
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_4xi32_aligned:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVXONLY32-NEXT:    vmovdqa %xmm0, (%rdi)
; AVXONLY32-NEXT:    retq
;
; AVX64-LABEL: test_store_4xi32_aligned:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX64-NEXT:    vmovdqa %xmm0, (%eax)
; AVX64-NEXT:    retl
;
; KNL32-LABEL: test_store_4xi32_aligned:
; KNL32:       # BB#0:
; KNL32-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; KNL32-NEXT:    vmovdqa %xmm0, (%rdi)
; KNL32-NEXT:    retq
;
; SKX32-LABEL: test_store_4xi32_aligned:
; SKX32:       # BB#0:
; SKX32-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; SKX32-NEXT:    vmovdqa64 %xmm0, (%rdi)
; SKX32-NEXT:    retq
  %foo = add <4 x i32> %value, %value2 ; to force integer type on store
  store <4 x i32> %foo, <4 x i32>* %addr, align 16
  ret <4 x i32> %foo
}

define <4 x float> @test_store_4xf32(<4 x float>* nocapture %addr, <4 x float> %value) {
; SSE32-LABEL: test_store_4xf32:
; SSE32:       # BB#0:
; SSE32-NEXT:    movups %xmm0, (%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_4xf32:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movups %xmm0, (%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_4xf32:
; AVX32:       # BB#0:
; AVX32-NEXT:    vmovups %xmm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_4xf32:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vmovups %xmm0, (%eax)
; AVX64-NEXT:    retl
  store <4 x float> %value, <4 x float>* %addr, align 1
  ret <4 x float> %value
}

define <4 x float> @test_store_4xf32_aligned(<4 x float>* nocapture %addr, <4 x float> %value) {
; SSE32-LABEL: test_store_4xf32_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    movaps %xmm0, (%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_4xf32_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movaps %xmm0, (%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_4xf32_aligned:
; AVX32:       # BB#0:
; AVX32-NEXT:    vmovaps %xmm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_4xf32_aligned:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vmovaps %xmm0, (%eax)
; AVX64-NEXT:    retl
  store <4 x float> %value, <4 x float>* %addr, align 16
  ret <4 x float> %value
}

define <2 x double> @test_store_2xf64(<2 x double>* nocapture %addr, <2 x double> %value, <2 x double> %value2) {
; SSE32-LABEL: test_store_2xf64:
; SSE32:       # BB#0:
; SSE32-NEXT:    addpd %xmm1, %xmm0
; SSE32-NEXT:    movupd %xmm0, (%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_2xf64:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    addpd %xmm1, %xmm0
; SSE64-NEXT:    movupd %xmm0, (%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_2xf64:
; AVX32:       # BB#0:
; AVX32-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX32-NEXT:    vmovupd %xmm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_2xf64:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX64-NEXT:    vmovupd %xmm0, (%eax)
; AVX64-NEXT:    retl
  %foo = fadd <2 x double> %value, %value2 ; to force dobule type on store
  store <2 x double> %foo, <2 x double>* %addr, align 1
  ret <2 x double> %foo
}

define <2 x double> @test_store_2xf64_aligned(<2 x double>* nocapture %addr, <2 x double> %value, <2 x double> %value2) {
; SSE32-LABEL: test_store_2xf64_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    addpd %xmm1, %xmm0
; SSE32-NEXT:    movapd %xmm0, (%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_2xf64_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    addpd %xmm1, %xmm0
; SSE64-NEXT:    movapd %xmm0, (%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_2xf64_aligned:
; AVX32:       # BB#0:
; AVX32-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX32-NEXT:    vmovapd %xmm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_2xf64_aligned:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX64-NEXT:    vmovapd %xmm0, (%eax)
; AVX64-NEXT:    retl
  %foo = fadd <2 x double> %value, %value2 ; to force dobule type on store
  store <2 x double> %foo, <2 x double>* %addr, align 16
  ret <2 x double> %foo
}

define <8 x i32> @test_store_8xi32(<8 x i32>* nocapture %addr, <8 x i32> %value) {
; SSE32-LABEL: test_store_8xi32:
; SSE32:       # BB#0:
; SSE32-NEXT:    movups %xmm0, (%rdi)
; SSE32-NEXT:    movups %xmm1, 16(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_8xi32:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movups %xmm0, (%eax)
; SSE64-NEXT:    movups %xmm1, 16(%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_8xi32:
; AVX32:       # BB#0:
; AVX32-NEXT:    vmovups %ymm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_8xi32:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vmovups %ymm0, (%eax)
; AVX64-NEXT:    retl
  store <8 x i32> %value, <8 x i32>* %addr, align 1
  ret <8 x i32> %value
}

define <8 x i32> @test_store_8xi32_aligned(<8 x i32>* nocapture %addr, <8 x i32> %value) {
; SSE32-LABEL: test_store_8xi32_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    movaps %xmm0, (%rdi)
; SSE32-NEXT:    movaps %xmm1, 16(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_8xi32_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movaps %xmm0, (%eax)
; SSE64-NEXT:    movaps %xmm1, 16(%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_8xi32_aligned:
; AVX32:       # BB#0:
; AVX32-NEXT:    vmovaps %ymm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_8xi32_aligned:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vmovaps %ymm0, (%eax)
; AVX64-NEXT:    retl
  store <8 x i32> %value, <8 x i32>* %addr, align 32
  ret <8 x i32> %value
}

define <8 x float> @test_store_8xf32(<8 x float>* nocapture %addr, <8 x float> %value) {
; SSE32-LABEL: test_store_8xf32:
; SSE32:       # BB#0:
; SSE32-NEXT:    movups %xmm0, (%rdi)
; SSE32-NEXT:    movups %xmm1, 16(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_8xf32:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movups %xmm0, (%eax)
; SSE64-NEXT:    movups %xmm1, 16(%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_8xf32:
; AVX32:       # BB#0:
; AVX32-NEXT:    vmovups %ymm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_8xf32:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vmovups %ymm0, (%eax)
; AVX64-NEXT:    retl
  store <8 x float> %value, <8 x float>* %addr, align 1
  ret <8 x float> %value
}

define <8 x float> @test_store_8xf32_aligned(<8 x float>* nocapture %addr, <8 x float> %value) {
; SSE32-LABEL: test_store_8xf32_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    movaps %xmm0, (%rdi)
; SSE32-NEXT:    movaps %xmm1, 16(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_8xf32_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movaps %xmm0, (%eax)
; SSE64-NEXT:    movaps %xmm1, 16(%eax)
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_8xf32_aligned:
; AVX32:       # BB#0:
; AVX32-NEXT:    vmovaps %ymm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_8xf32_aligned:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vmovaps %ymm0, (%eax)
; AVX64-NEXT:    retl
  store <8 x float> %value, <8 x float>* %addr, align 32
  ret <8 x float> %value
}

define <4 x double> @test_store_4xf64(<4 x double>* nocapture %addr, <4 x double> %value, <4 x double> %value2) {
; SSE32-LABEL: test_store_4xf64:
; SSE32:       # BB#0:
; SSE32-NEXT:    addpd %xmm3, %xmm1
; SSE32-NEXT:    addpd %xmm2, %xmm0
; SSE32-NEXT:    movupd %xmm0, (%rdi)
; SSE32-NEXT:    movupd %xmm1, 16(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_4xf64:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp0:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm1
; SSE64-NEXT:    addpd %xmm2, %xmm0
; SSE64-NEXT:    movupd %xmm0, (%eax)
; SSE64-NEXT:    movupd %xmm1, 16(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_4xf64:
; AVX32:       # BB#0:
; AVX32-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX32-NEXT:    vmovupd %ymm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_4xf64:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX64-NEXT:    vmovupd %ymm0, (%eax)
; AVX64-NEXT:    retl
  %foo = fadd <4 x double> %value, %value2 ; to force dobule type on store
  store <4 x double> %foo, <4 x double>* %addr, align 1
  ret <4 x double> %foo
}

define <4 x double> @test_store_4xf64_aligned(<4 x double>* nocapture %addr, <4 x double> %value, <4 x double> %value2) {
; SSE32-LABEL: test_store_4xf64_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    addpd %xmm3, %xmm1
; SSE32-NEXT:    addpd %xmm2, %xmm0
; SSE32-NEXT:    movapd %xmm0, (%rdi)
; SSE32-NEXT:    movapd %xmm1, 16(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_4xf64_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp1:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm1
; SSE64-NEXT:    addpd %xmm2, %xmm0
; SSE64-NEXT:    movapd %xmm0, (%eax)
; SSE64-NEXT:    movapd %xmm1, 16(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVX32-LABEL: test_store_4xf64_aligned:
; AVX32:       # BB#0:
; AVX32-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX32-NEXT:    vmovapd %ymm0, (%rdi)
; AVX32-NEXT:    retq
;
; AVX64-LABEL: test_store_4xf64_aligned:
; AVX64:       # BB#0:
; AVX64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX64-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX64-NEXT:    vmovapd %ymm0, (%eax)
; AVX64-NEXT:    retl
  %foo = fadd <4 x double> %value, %value2 ; to force dobule type on store
  store <4 x double> %foo, <4 x double>* %addr, align 32
  ret <4 x double> %foo
}

define <16 x i32> @test_store_16xi32(<16 x i32>* nocapture %addr, <16 x i32> %value) {
; SSE32-LABEL: test_store_16xi32:
; SSE32:       # BB#0:
; SSE32-NEXT:    movups %xmm0, (%rdi)
; SSE32-NEXT:    movups %xmm1, 16(%rdi)
; SSE32-NEXT:    movups %xmm2, 32(%rdi)
; SSE32-NEXT:    movups %xmm3, 48(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_16xi32:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp2:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movaps {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movups %xmm0, (%eax)
; SSE64-NEXT:    movups %xmm1, 16(%eax)
; SSE64-NEXT:    movups %xmm2, 32(%eax)
; SSE64-NEXT:    movups %xmm3, 48(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_16xi32:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vmovups %ymm0, (%rdi)
; AVXONLY32-NEXT:    vmovups %ymm1, 32(%rdi)
; AVXONLY32-NEXT:    retq
;
; AVXONLY64-LABEL: test_store_16xi32:
; AVXONLY64:       # BB#0:
; AVXONLY64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVXONLY64-NEXT:    vmovups %ymm0, (%eax)
; AVXONLY64-NEXT:    vmovups %ymm1, 32(%eax)
; AVXONLY64-NEXT:    retl
;
; AVX51232-LABEL: test_store_16xi32:
; AVX51232:       # BB#0:
; AVX51232-NEXT:    vmovups %zmm0, (%rdi)
; AVX51232-NEXT:    retq
;
; AVX51264-LABEL: test_store_16xi32:
; AVX51264:       # BB#0:
; AVX51264-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX51264-NEXT:    vmovups %zmm0, (%eax)
; AVX51264-NEXT:    retl
  store <16 x i32> %value, <16 x i32>* %addr, align 1
  ret <16 x i32> %value
}

define <16 x i32> @test_store_16xi32_aligned(<16 x i32>* nocapture %addr, <16 x i32> %value) {
; SSE32-LABEL: test_store_16xi32_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    movaps %xmm0, (%rdi)
; SSE32-NEXT:    movaps %xmm1, 16(%rdi)
; SSE32-NEXT:    movaps %xmm2, 32(%rdi)
; SSE32-NEXT:    movaps %xmm3, 48(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_16xi32_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp3:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movaps {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movaps %xmm0, (%eax)
; SSE64-NEXT:    movaps %xmm1, 16(%eax)
; SSE64-NEXT:    movaps %xmm2, 32(%eax)
; SSE64-NEXT:    movaps %xmm3, 48(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_16xi32_aligned:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vmovaps %ymm0, (%rdi)
; AVXONLY32-NEXT:    vmovaps %ymm1, 32(%rdi)
; AVXONLY32-NEXT:    retq
;
; AVXONLY64-LABEL: test_store_16xi32_aligned:
; AVXONLY64:       # BB#0:
; AVXONLY64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVXONLY64-NEXT:    vmovaps %ymm0, (%eax)
; AVXONLY64-NEXT:    vmovaps %ymm1, 32(%eax)
; AVXONLY64-NEXT:    retl
;
; AVX51232-LABEL: test_store_16xi32_aligned:
; AVX51232:       # BB#0:
; AVX51232-NEXT:    vmovaps %zmm0, (%rdi)
; AVX51232-NEXT:    retq
;
; AVX51264-LABEL: test_store_16xi32_aligned:
; AVX51264:       # BB#0:
; AVX51264-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX51264-NEXT:    vmovaps %zmm0, (%eax)
; AVX51264-NEXT:    retl
  store <16 x i32> %value, <16 x i32>* %addr, align 64
  ret <16 x i32> %value
}

define <16 x float> @test_store_16xf32(<16 x float>* nocapture %addr, <16 x float> %value) {
; SSE32-LABEL: test_store_16xf32:
; SSE32:       # BB#0:
; SSE32-NEXT:    movups %xmm0, (%rdi)
; SSE32-NEXT:    movups %xmm1, 16(%rdi)
; SSE32-NEXT:    movups %xmm2, 32(%rdi)
; SSE32-NEXT:    movups %xmm3, 48(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_16xf32:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp4:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movaps {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movups %xmm0, (%eax)
; SSE64-NEXT:    movups %xmm1, 16(%eax)
; SSE64-NEXT:    movups %xmm2, 32(%eax)
; SSE64-NEXT:    movups %xmm3, 48(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_16xf32:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vmovups %ymm0, (%rdi)
; AVXONLY32-NEXT:    vmovups %ymm1, 32(%rdi)
; AVXONLY32-NEXT:    retq
;
; AVXONLY64-LABEL: test_store_16xf32:
; AVXONLY64:       # BB#0:
; AVXONLY64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVXONLY64-NEXT:    vmovups %ymm0, (%eax)
; AVXONLY64-NEXT:    vmovups %ymm1, 32(%eax)
; AVXONLY64-NEXT:    retl
;
; AVX51232-LABEL: test_store_16xf32:
; AVX51232:       # BB#0:
; AVX51232-NEXT:    vmovups %zmm0, (%rdi)
; AVX51232-NEXT:    retq
;
; AVX51264-LABEL: test_store_16xf32:
; AVX51264:       # BB#0:
; AVX51264-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX51264-NEXT:    vmovups %zmm0, (%eax)
; AVX51264-NEXT:    retl
  store <16 x float> %value, <16 x float>* %addr, align 1
  ret <16 x float> %value
}

define <16 x float> @test_store_16xf32_aligned(<16 x float>* nocapture %addr, <16 x float> %value) {
; SSE32-LABEL: test_store_16xf32_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    movaps %xmm0, (%rdi)
; SSE32-NEXT:    movaps %xmm1, 16(%rdi)
; SSE32-NEXT:    movaps %xmm2, 32(%rdi)
; SSE32-NEXT:    movaps %xmm3, 48(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_16xf32_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp5:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movaps {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    movaps %xmm0, (%eax)
; SSE64-NEXT:    movaps %xmm1, 16(%eax)
; SSE64-NEXT:    movaps %xmm2, 32(%eax)
; SSE64-NEXT:    movaps %xmm3, 48(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_16xf32_aligned:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vmovaps %ymm0, (%rdi)
; AVXONLY32-NEXT:    vmovaps %ymm1, 32(%rdi)
; AVXONLY32-NEXT:    retq
;
; AVXONLY64-LABEL: test_store_16xf32_aligned:
; AVXONLY64:       # BB#0:
; AVXONLY64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVXONLY64-NEXT:    vmovaps %ymm0, (%eax)
; AVXONLY64-NEXT:    vmovaps %ymm1, 32(%eax)
; AVXONLY64-NEXT:    retl
;
; AVX51232-LABEL: test_store_16xf32_aligned:
; AVX51232:       # BB#0:
; AVX51232-NEXT:    vmovaps %zmm0, (%rdi)
; AVX51232-NEXT:    retq
;
; AVX51264-LABEL: test_store_16xf32_aligned:
; AVX51264:       # BB#0:
; AVX51264-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX51264-NEXT:    vmovaps %zmm0, (%eax)
; AVX51264-NEXT:    retl
  store <16 x float> %value, <16 x float>* %addr, align 64
  ret <16 x float> %value
}

define <8 x double> @test_store_8xf64(<8 x double>* nocapture %addr, <8 x double> %value, <8 x double> %value2) {
; SSE32-LABEL: test_store_8xf64:
; SSE32:       # BB#0:
; SSE32-NEXT:    addpd %xmm7, %xmm3
; SSE32-NEXT:    addpd %xmm6, %xmm2
; SSE32-NEXT:    addpd %xmm5, %xmm1
; SSE32-NEXT:    addpd %xmm4, %xmm0
; SSE32-NEXT:    movupd %xmm0, (%rdi)
; SSE32-NEXT:    movupd %xmm1, 16(%rdi)
; SSE32-NEXT:    movupd %xmm2, 32(%rdi)
; SSE32-NEXT:    movupd %xmm3, 48(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_8xf64:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp6:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movapd {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm2
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm1
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm0
; SSE64-NEXT:    movupd %xmm0, (%eax)
; SSE64-NEXT:    movupd %xmm1, 16(%eax)
; SSE64-NEXT:    movupd %xmm2, 32(%eax)
; SSE64-NEXT:    movupd %xmm3, 48(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_8xf64:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vaddpd %ymm3, %ymm1, %ymm1
; AVXONLY32-NEXT:    vaddpd %ymm2, %ymm0, %ymm0
; AVXONLY32-NEXT:    vmovupd %ymm0, (%rdi)
; AVXONLY32-NEXT:    vmovupd %ymm1, 32(%rdi)
; AVXONLY32-NEXT:    retq
;
; AVXONLY64-LABEL: test_store_8xf64:
; AVXONLY64:       # BB#0:
; AVXONLY64-NEXT:    pushl %ebp
; AVXONLY64-NEXT:  .Ltmp0:
; AVXONLY64-NEXT:    .cfi_def_cfa_offset 8
; AVXONLY64-NEXT:  .Ltmp1:
; AVXONLY64-NEXT:    .cfi_offset %ebp, -8
; AVXONLY64-NEXT:    movl %esp, %ebp
; AVXONLY64-NEXT:  .Ltmp2:
; AVXONLY64-NEXT:    .cfi_def_cfa_register %ebp
; AVXONLY64-NEXT:    andl $-32, %esp
; AVXONLY64-NEXT:    subl $32, %esp
; AVXONLY64-NEXT:    movl 8(%ebp), %eax
; AVXONLY64-NEXT:    vaddpd 40(%ebp), %ymm1, %ymm1
; AVXONLY64-NEXT:    vaddpd %ymm2, %ymm0, %ymm0
; AVXONLY64-NEXT:    vmovupd %ymm0, (%eax)
; AVXONLY64-NEXT:    vmovupd %ymm1, 32(%eax)
; AVXONLY64-NEXT:    movl %ebp, %esp
; AVXONLY64-NEXT:    popl %ebp
; AVXONLY64-NEXT:    retl
;
; AVX51232-LABEL: test_store_8xf64:
; AVX51232:       # BB#0:
; AVX51232-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX51232-NEXT:    vmovupd %zmm0, (%rdi)
; AVX51232-NEXT:    retq
;
; AVX51264-LABEL: test_store_8xf64:
; AVX51264:       # BB#0:
; AVX51264-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX51264-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX51264-NEXT:    vmovupd %zmm0, (%eax)
; AVX51264-NEXT:    retl
  %foo = fadd <8 x double> %value, %value2 ; to force dobule type on store
  store <8 x double> %foo, <8 x double>* %addr, align 1
  ret <8 x double> %foo
}

define <8 x double> @test_store_8xf64_aligned(<8 x double>* nocapture %addr, <8 x double> %value, <8 x double> %value2) {
; SSE32-LABEL: test_store_8xf64_aligned:
; SSE32:       # BB#0:
; SSE32-NEXT:    addpd %xmm7, %xmm3
; SSE32-NEXT:    addpd %xmm6, %xmm2
; SSE32-NEXT:    addpd %xmm5, %xmm1
; SSE32-NEXT:    addpd %xmm4, %xmm0
; SSE32-NEXT:    movapd %xmm0, (%rdi)
; SSE32-NEXT:    movapd %xmm1, 16(%rdi)
; SSE32-NEXT:    movapd %xmm2, 32(%rdi)
; SSE32-NEXT:    movapd %xmm3, 48(%rdi)
; SSE32-NEXT:    retq
;
; SSE64-LABEL: test_store_8xf64_aligned:
; SSE64:       # BB#0:
; SSE64-NEXT:    subl $12, %esp
; SSE64-NEXT:  .Ltmp7:
; SSE64-NEXT:    .cfi_def_cfa_offset 16
; SSE64-NEXT:    movapd {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm3
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm2
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm1
; SSE64-NEXT:    addpd {{[0-9]+}}(%esp), %xmm0
; SSE64-NEXT:    movapd %xmm0, (%eax)
; SSE64-NEXT:    movapd %xmm1, 16(%eax)
; SSE64-NEXT:    movapd %xmm2, 32(%eax)
; SSE64-NEXT:    movapd %xmm3, 48(%eax)
; SSE64-NEXT:    addl $12, %esp
; SSE64-NEXT:    retl
;
; AVXONLY32-LABEL: test_store_8xf64_aligned:
; AVXONLY32:       # BB#0:
; AVXONLY32-NEXT:    vaddpd %ymm3, %ymm1, %ymm1
; AVXONLY32-NEXT:    vaddpd %ymm2, %ymm0, %ymm0
; AVXONLY32-NEXT:    vmovapd %ymm0, (%rdi)
; AVXONLY32-NEXT:    vmovapd %ymm1, 32(%rdi)
; AVXONLY32-NEXT:    retq
;
; AVXONLY64-LABEL: test_store_8xf64_aligned:
; AVXONLY64:       # BB#0:
; AVXONLY64-NEXT:    pushl %ebp
; AVXONLY64-NEXT:  .Ltmp3:
; AVXONLY64-NEXT:    .cfi_def_cfa_offset 8
; AVXONLY64-NEXT:  .Ltmp4:
; AVXONLY64-NEXT:    .cfi_offset %ebp, -8
; AVXONLY64-NEXT:    movl %esp, %ebp
; AVXONLY64-NEXT:  .Ltmp5:
; AVXONLY64-NEXT:    .cfi_def_cfa_register %ebp
; AVXONLY64-NEXT:    andl $-32, %esp
; AVXONLY64-NEXT:    subl $32, %esp
; AVXONLY64-NEXT:    movl 8(%ebp), %eax
; AVXONLY64-NEXT:    vaddpd 40(%ebp), %ymm1, %ymm1
; AVXONLY64-NEXT:    vaddpd %ymm2, %ymm0, %ymm0
; AVXONLY64-NEXT:    vmovapd %ymm0, (%eax)
; AVXONLY64-NEXT:    vmovapd %ymm1, 32(%eax)
; AVXONLY64-NEXT:    movl %ebp, %esp
; AVXONLY64-NEXT:    popl %ebp
; AVXONLY64-NEXT:    retl
;
; AVX51232-LABEL: test_store_8xf64_aligned:
; AVX51232:       # BB#0:
; AVX51232-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX51232-NEXT:    vmovapd %zmm0, (%rdi)
; AVX51232-NEXT:    retq
;
; AVX51264-LABEL: test_store_8xf64_aligned:
; AVX51264:       # BB#0:
; AVX51264-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX51264-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; AVX51264-NEXT:    vmovapd %zmm0, (%eax)
; AVX51264-NEXT:    retl
  %foo = fadd <8 x double> %value, %value2 ; to force dobule type on store
  store <8 x double> %foo, <8 x double>* %addr, align 64
  ret <8 x double> %foo
}
