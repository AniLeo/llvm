; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-linux-gnu -mcpu=skx                       -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=SKX
; RUN: llc -mtriple=x86_64-linux-gnu -mcpu=skx -regbankselect-greedy -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=SKX

define <4 x i32> @test_load_v4i32_noalign(<4 x i32> * %p1) {
; SKX-LABEL: test_load_v4i32_noalign:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovups (%rdi), %xmm0
; SKX-NEXT:    retq
  %r = load <4 x i32>, <4 x i32>* %p1, align 1
  ret <4 x i32> %r
}

define <4 x i32> @test_load_v4i32_align(<4 x i32> * %p1) {
; SKX-LABEL: test_load_v4i32_align:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovaps (%rdi), %xmm0
; SKX-NEXT:    retq
  %r = load <4 x i32>, <4 x i32>* %p1, align 16
  ret <4 x i32> %r
}

define <8 x i32> @test_load_v8i32_noalign(<8 x i32> * %p1) {
; SKX-LABEL: test_load_v8i32_noalign:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovups (%rdi), %ymm0
; SKX-NEXT:    retq
  %r = load <8 x i32>, <8 x i32>* %p1, align 1
  ret <8 x i32> %r
}

define <8 x i32> @test_load_v8i32_align(<8 x i32> * %p1) {
; SKX-LABEL: test_load_v8i32_align:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovaps (%rdi), %ymm0
; SKX-NEXT:    retq
  %r = load <8 x i32>, <8 x i32>* %p1, align 32
  ret <8 x i32> %r
}

define <16 x i32> @test_load_v16i32_noalign(<16 x i32> * %p1) {
; SKX-LABEL: test_load_v16i32_noalign:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovups (%rdi), %zmm0
; SKX-NEXT:    retq
  %r = load <16 x i32>, <16 x i32>* %p1, align 1
  ret <16 x i32> %r
}

define <16 x i32> @test_load_v16i32_align(<16 x i32> * %p1) {
; SKX-LABEL: test_load_v16i32_align:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovups (%rdi), %zmm0
; SKX-NEXT:    retq
  %r = load <16 x i32>, <16 x i32>* %p1, align 32
  ret <16 x i32> %r
}

define void @test_store_v4i32_noalign(<4 x i32> %val, <4 x i32>* %p1) {
; SKX-LABEL: test_store_v4i32_noalign:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovups %xmm0, (%rdi)
; SKX-NEXT:    retq
  store <4 x i32> %val, <4 x i32>* %p1, align 1
  ret void
}

define void @test_store_v4i32_align(<4 x i32> %val, <4 x i32>* %p1) {
; SKX-LABEL: test_store_v4i32_align:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovaps %xmm0, (%rdi)
; SKX-NEXT:    retq
  store <4 x i32> %val, <4 x i32>* %p1, align 16
  ret void
}

define void @test_store_v8i32_noalign(<8 x i32> %val, <8 x i32>* %p1) {
; SKX-LABEL: test_store_v8i32_noalign:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovups %ymm0, (%rdi)
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  store <8 x i32> %val, <8 x i32>* %p1, align 1
  ret void
}

define void @test_store_v8i32_align(<8 x i32> %val, <8 x i32>* %p1) {
; SKX-LABEL: test_store_v8i32_align:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovaps %ymm0, (%rdi)
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  store <8 x i32> %val, <8 x i32>* %p1, align 32
  ret void
}

define void @test_store_v16i32_noalign(<16 x i32> %val, <16 x i32>* %p1) {
; SKX-LABEL: test_store_v16i32_noalign:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovups %zmm0, (%rdi)
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  store <16 x i32> %val, <16 x i32>* %p1, align 1
  ret void
}

define void @test_store_v16i32_align(<16 x i32> %val, <16 x i32>* %p1) {
; SKX-LABEL: test_store_v16i32_align:
; SKX:       # %bb.0:
; SKX-NEXT:    vmovaps %zmm0, (%rdi)
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
  store <16 x i32> %val, <16 x i32>* %p1, align 64
  ret void
}

