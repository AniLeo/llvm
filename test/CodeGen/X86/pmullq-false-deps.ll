; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=sapphirerapids -mattr=+false-deps-mullq -mtriple=x86_64-unknown-unknown < %s | FileCheck %s --check-prefixes=ENABLE
; RUN: llc -verify-machineinstrs -mcpu=sapphirerapids -mattr=-false-deps-mullq -mtriple=x86_64-unknown-unknown < %s | FileCheck %s --check-prefixes=DISABLE

define <2 x i64> @pmullq_128(<2 x i64> %a0, <2 x i64> %a1) {
; ENABLE-LABEL: pmullq_128:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    vmovaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vmovdqa {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; ENABLE-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq %xmm2, %xmm0, %xmm1
; ENABLE-NEXT:    vpaddq %xmm2, %xmm0, %xmm0
; ENABLE-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_128:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    vmovaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vmovdqa {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; DISABLE-NEXT:    vpmullq %xmm2, %xmm0, %xmm1
; DISABLE-NEXT:    vpaddq %xmm2, %xmm0, %xmm0
; DISABLE-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %2 = call <2 x i64> @llvm.x86.avx512.mask.pmull.q.128(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> undef, i8 -1)
  %3 = add <2 x i64> %a0, %a1
  %res = add <2 x i64> %2, %3
  ret <2 x i64> %res
}

define <2 x i64> @pmullq_mem_128(<2 x i64> %a0, <2 x i64>* %p1) {
; ENABLE-LABEL: pmullq_mem_128:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq (%rdi), %xmm0, %xmm1
; ENABLE-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_mem_128:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vpmullq (%rdi), %xmm0, %xmm1
; DISABLE-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %a1 = load <2 x i64>, <2 x i64>* %p1, align 64
  %2 = call <2 x i64> @llvm.x86.avx512.mask.pmull.q.128(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> undef, i8 -1)
  %res = add <2 x i64> %2, %a0
  ret <2 x i64> %res
}

define <2 x i64> @pmullq_broadcast_128(<2 x i64> %a0, i64* %p1) {
; ENABLE-LABEL: pmullq_broadcast_128:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq (%rdi){1to2}, %xmm0, %xmm1
; ENABLE-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_broadcast_128:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vpmullq (%rdi){1to2}, %xmm0, %xmm1
; DISABLE-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %v1 = load i64, i64* %p1, align 4
  %t0 = insertelement <2 x i64> undef, i64 %v1, i64 0
  %a1 = shufflevector <2 x i64> %t0, <2 x i64> undef, <2 x i32> zeroinitializer
  %2 = call <2 x i64> @llvm.x86.avx512.mask.pmull.q.128(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> undef, i8 -1)
  %res = add <2 x i64> %2, %a0
  ret <2 x i64> %res
}

define <2 x i64> @pmullq_maskz_128(<2 x i64> %a0, <2 x i64> %a1, i8* %pmask) {
; ENABLE-LABEL: pmullq_maskz_128:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    vpmullq %xmm1, %xmm0, %xmm2
; ENABLE-NEXT:    vmovdqa %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    kmovb (%rdi), %k1
; ENABLE-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; ENABLE-NEXT:    vpaddq {{[-0-9]+}}(%r{{[sb]}}p), %xmm0, %xmm0 {%k1} # 16-byte Folded Reload
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_maskz_128:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    vpmullq %xmm1, %xmm0, %xmm2
; DISABLE-NEXT:    vmovdqa %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    kmovb (%rdi), %k1
; DISABLE-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; DISABLE-NEXT:    vpaddq {{[-0-9]+}}(%r{{[sb]}}p), %xmm0, %xmm0 {%k1} # 16-byte Folded Reload
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %mask = load i8, i8* %pmask
  %2 = call <2 x i64> @llvm.x86.avx512.mask.pmull.q.128(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> zeroinitializer, i8 %mask)
  %3 = add <2 x i64> %a0, %a1
  %res = add <2 x i64> %2, %3
  ret <2 x i64> %res
}

declare <2 x i64> @llvm.x86.avx512.mask.pmull.q.128(<2 x i64> %a, <2 x i64> %b, <2 x i64> %passThru, i8 %mask)

define <4 x i64> @pmullq_256(<4 x i64> %a0, <4 x i64> %a1) {
; ENABLE-LABEL: pmullq_256:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    vmovups %ymm1, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vmovdqu {{[-0-9]+}}(%r{{[sb]}}p), %ymm2 # 32-byte Reload
; ENABLE-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq %ymm2, %ymm0, %ymm1
; ENABLE-NEXT:    vpaddq %ymm2, %ymm0, %ymm0
; ENABLE-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_256:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    vmovups %ymm1, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vmovdqu {{[-0-9]+}}(%r{{[sb]}}p), %ymm2 # 32-byte Reload
; DISABLE-NEXT:    vpmullq %ymm2, %ymm0, %ymm1
; DISABLE-NEXT:    vpaddq %ymm2, %ymm0, %ymm0
; DISABLE-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %2 = call <4 x i64> @llvm.x86.avx512.mask.pmull.q.256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> undef, i8 -1)
  %3 = add <4 x i64> %a0, %a1
  %res = add <4 x i64> %2, %3
  ret <4 x i64> %res
}

define <4 x i64> @pmullq_mem_256(<4 x i64> %a0, <4 x i64>* %p1) {
; ENABLE-LABEL: pmullq_mem_256:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq (%rdi), %ymm0, %ymm1
; ENABLE-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_mem_256:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vpmullq (%rdi), %ymm0, %ymm1
; DISABLE-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %a1 = load <4 x i64>, <4 x i64>* %p1, align 64
  %2 = call <4 x i64> @llvm.x86.avx512.mask.pmull.q.256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> undef, i8 -1)
  %res = add <4 x i64> %2, %a0
  ret <4 x i64> %res
}

define <4 x i64> @pmullq_broadcast_256(<4 x i64> %a0, i64* %p1) {
; ENABLE-LABEL: pmullq_broadcast_256:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq (%rdi){1to4}, %ymm0, %ymm1
; ENABLE-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_broadcast_256:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vpmullq (%rdi){1to4}, %ymm0, %ymm1
; DISABLE-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %v1 = load i64, i64* %p1, align 4
  %t0 = insertelement <4 x i64> undef, i64 %v1, i64 0
  %a1 = shufflevector <4 x i64> %t0, <4 x i64> undef, <4 x i32> zeroinitializer
  %2 = call <4 x i64> @llvm.x86.avx512.mask.pmull.q.256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> undef, i8 -1)
  %res = add <4 x i64> %2, %a0
  ret <4 x i64> %res
}

define <4 x i64> @pmullq_maskz_256(<4 x i64> %a0, <4 x i64> %a1, i8* %pmask) {
; ENABLE-LABEL: pmullq_maskz_256:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    vpmullq %ymm1, %ymm0, %ymm2
; ENABLE-NEXT:    vmovdqu %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    kmovb (%rdi), %k1
; ENABLE-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; ENABLE-NEXT:    vpaddq {{[-0-9]+}}(%r{{[sb]}}p), %ymm0, %ymm0 {%k1} # 32-byte Folded Reload
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_maskz_256:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    vpmullq %ymm1, %ymm0, %ymm2
; DISABLE-NEXT:    vmovdqu %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    kmovb (%rdi), %k1
; DISABLE-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; DISABLE-NEXT:    vpaddq {{[-0-9]+}}(%r{{[sb]}}p), %ymm0, %ymm0 {%k1} # 32-byte Folded Reload
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %mask = load i8, i8* %pmask
  %2 = call <4 x i64> @llvm.x86.avx512.mask.pmull.q.256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> zeroinitializer, i8 %mask)
  %3 = add <4 x i64> %a0, %a1
  %res = add <4 x i64> %2, %3
  ret <4 x i64> %res
}

declare <4 x i64> @llvm.x86.avx512.mask.pmull.q.256(<4 x i64> %a, <4 x i64> %b, <4 x i64> %passThru, i8 %mask)

define <8 x i64> @pmullq_512(<8 x i64> %a0, <8 x i64> %a1) {
; ENABLE-LABEL: pmullq_512:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    vmovups %zmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 64-byte Spill
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vmovdqu64 {{[-0-9]+}}(%r{{[sb]}}p), %zmm2 # 64-byte Reload
; ENABLE-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq %zmm2, %zmm0, %zmm1
; ENABLE-NEXT:    vpaddq %zmm2, %zmm0, %zmm0
; ENABLE-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_512:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    vmovups %zmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 64-byte Spill
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vmovdqu64 {{[-0-9]+}}(%r{{[sb]}}p), %zmm2 # 64-byte Reload
; DISABLE-NEXT:    vpmullq %zmm2, %zmm0, %zmm1
; DISABLE-NEXT:    vpaddq %zmm2, %zmm0, %zmm0
; DISABLE-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %2 = call <8 x i64> @llvm.x86.avx512.mask.pmull.q.512(<8 x i64> %a0, <8 x i64> %a1, <8 x i64> undef, i8 -1)
  %3 = add <8 x i64> %a0, %a1
  %res = add <8 x i64> %2, %3
  ret <8 x i64> %res
}

define <8 x i64> @pmullq_mem_512(<8 x i64> %a0, <8 x i64>* %p1) {
; ENABLE-LABEL: pmullq_mem_512:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq (%rdi), %zmm0, %zmm1
; ENABLE-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_mem_512:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vpmullq (%rdi), %zmm0, %zmm1
; DISABLE-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %a1 = load <8 x i64>, <8 x i64>* %p1, align 64
  %2 = call <8 x i64> @llvm.x86.avx512.mask.pmull.q.512(<8 x i64> %a0, <8 x i64> %a1, <8 x i64> undef, i8 -1)
  %res = add <8 x i64> %2, %a0
  ret <8 x i64> %res
}

define <8 x i64> @pmullq_broadcast_512(<8 x i64> %a0, i64* %p1) {
; ENABLE-LABEL: pmullq_broadcast_512:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; ENABLE-NEXT:    vpmullq (%rdi){1to8}, %zmm0, %zmm1
; ENABLE-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_broadcast_512:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    vpmullq (%rdi){1to8}, %zmm0, %zmm1
; DISABLE-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %v1 = load i64, i64* %p1, align 4
  %t0 = insertelement <8 x i64> undef, i64 %v1, i64 0
  %a1 = shufflevector <8 x i64> %t0, <8 x i64> undef, <8 x i32> zeroinitializer
  %2 = call <8 x i64> @llvm.x86.avx512.mask.pmull.q.512(<8 x i64> %a0, <8 x i64> %a1, <8 x i64> undef, i8 -1)
  %res = add <8 x i64> %2, %a0
  ret <8 x i64> %res
}

define <8 x i64> @pmullq_maskz_512(<8 x i64> %a0, <8 x i64> %a1, i8* %pmask) {
; ENABLE-LABEL: pmullq_maskz_512:
; ENABLE:       # %bb.0:
; ENABLE-NEXT:    vpmullq %zmm1, %zmm0, %zmm2
; ENABLE-NEXT:    vmovdqu64 %zmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 64-byte Spill
; ENABLE-NEXT:    #APP
; ENABLE-NEXT:    nop
; ENABLE-NEXT:    #NO_APP
; ENABLE-NEXT:    kmovb (%rdi), %k1
; ENABLE-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; ENABLE-NEXT:    vpaddq {{[-0-9]+}}(%r{{[sb]}}p), %zmm0, %zmm0 {%k1} # 64-byte Folded Reload
; ENABLE-NEXT:    retq
;
; DISABLE-LABEL: pmullq_maskz_512:
; DISABLE:       # %bb.0:
; DISABLE-NEXT:    vpmullq %zmm1, %zmm0, %zmm2
; DISABLE-NEXT:    vmovdqu64 %zmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 64-byte Spill
; DISABLE-NEXT:    #APP
; DISABLE-NEXT:    nop
; DISABLE-NEXT:    #NO_APP
; DISABLE-NEXT:    kmovb (%rdi), %k1
; DISABLE-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; DISABLE-NEXT:    vpaddq {{[-0-9]+}}(%r{{[sb]}}p), %zmm0, %zmm0 {%k1} # 64-byte Folded Reload
; DISABLE-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{xmm16},~{xmm17},~{xmm18},~{xmm19},~{xmm20},~{xmm21},~{xmm22},~{xmm23},~{xmm24},~{xmm25},~{xmm26},~{xmm27},~{xmm28},~{xmm29},~{xmm30},~{xmm31},~{flags}"()
  %mask = load i8, i8* %pmask
  %2 = call <8 x i64> @llvm.x86.avx512.mask.pmull.q.512(<8 x i64> %a0, <8 x i64> %a1, <8 x i64> zeroinitializer, i8 %mask)
  %3 = add <8 x i64> %a0, %a1
  %res = add <8 x i64> %2, %3
  ret <8 x i64> %res
}

declare <8 x i64> @llvm.x86.avx512.mask.pmull.q.512(<8 x i64> %a, <8 x i64> %b, <8 x i64> %passThru, i8 %mask)
