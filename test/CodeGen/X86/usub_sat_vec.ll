; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+ssse3 | FileCheck %s --check-prefixes=SSE,SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+avx512vl,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX512,AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+avx512vl,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX,AVX512,AVX512BW

declare <1 x i8> @llvm.usub.sat.v1i8(<1 x i8>, <1 x i8>)
declare <2 x i8> @llvm.usub.sat.v2i8(<2 x i8>, <2 x i8>)
declare <4 x i8> @llvm.usub.sat.v4i8(<4 x i8>, <4 x i8>)
declare <8 x i8> @llvm.usub.sat.v8i8(<8 x i8>, <8 x i8>)
declare <12 x i8> @llvm.usub.sat.v12i8(<12 x i8>, <12 x i8>)
declare <16 x i8> @llvm.usub.sat.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.usub.sat.v32i8(<32 x i8>, <32 x i8>)
declare <64 x i8> @llvm.usub.sat.v64i8(<64 x i8>, <64 x i8>)

declare <1 x i16> @llvm.usub.sat.v1i16(<1 x i16>, <1 x i16>)
declare <2 x i16> @llvm.usub.sat.v2i16(<2 x i16>, <2 x i16>)
declare <4 x i16> @llvm.usub.sat.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16> @llvm.usub.sat.v8i16(<8 x i16>, <8 x i16>)
declare <12 x i16> @llvm.usub.sat.v12i16(<12 x i16>, <12 x i16>)
declare <16 x i16> @llvm.usub.sat.v16i16(<16 x i16>, <16 x i16>)
declare <32 x i16> @llvm.usub.sat.v32i16(<32 x i16>, <32 x i16>)

declare <16 x i1> @llvm.usub.sat.v16i1(<16 x i1>, <16 x i1>)
declare <16 x i4> @llvm.usub.sat.v16i4(<16 x i4>, <16 x i4>)

declare <2 x i32> @llvm.usub.sat.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32> @llvm.usub.sat.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.usub.sat.v8i32(<8 x i32>, <8 x i32>)
declare <16 x i32> @llvm.usub.sat.v16i32(<16 x i32>, <16 x i32>)
declare <2 x i64> @llvm.usub.sat.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.usub.sat.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64> @llvm.usub.sat.v8i64(<8 x i64>, <8 x i64>)

declare <4 x i24> @llvm.usub.sat.v4i24(<4 x i24>, <4 x i24>)
declare <2 x i128> @llvm.usub.sat.v2i128(<2 x i128>, <2 x i128>)

; Legal types, depending on architecture.

define <16 x i8> @v16i8(<16 x i8> %x, <16 x i8> %y) nounwind {
; SSE-LABEL: v16i8:
; SSE:       # %bb.0:
; SSE-NEXT:    psubusb %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v16i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsubusb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %z = call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> %x, <16 x i8> %y)
  ret <16 x i8> %z
}

define <32 x i8> @v32i8(<32 x i8> %x, <32 x i8> %y) nounwind {
; SSE-LABEL: v32i8:
; SSE:       # %bb.0:
; SSE-NEXT:    psubusb %xmm2, %xmm0
; SSE-NEXT:    psubusb %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: v32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpsubusb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsubusb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsubusb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: v32i8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsubusb %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %z = call <32 x i8> @llvm.usub.sat.v32i8(<32 x i8> %x, <32 x i8> %y)
  ret <32 x i8> %z
}

define <64 x i8> @v64i8(<64 x i8> %x, <64 x i8> %y) nounwind {
; SSE-LABEL: v64i8:
; SSE:       # %bb.0:
; SSE-NEXT:    psubusb %xmm4, %xmm0
; SSE-NEXT:    psubusb %xmm5, %xmm1
; SSE-NEXT:    psubusb %xmm6, %xmm2
; SSE-NEXT:    psubusb %xmm7, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: v64i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpsubusb %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpsubusb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX1-NEXT:    vpsubusb %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpsubusb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v64i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsubusb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsubusb %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vextracti64x4 $1, %zmm1, %ymm2
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm3
; AVX512F-NEXT:    vpsubusb %ymm2, %ymm3, %ymm2
; AVX512F-NEXT:    vpsubusb %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vinserti64x4 $1, %ymm2, %zmm0, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsubusb %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %z = call <64 x i8> @llvm.usub.sat.v64i8(<64 x i8> %x, <64 x i8> %y)
  ret <64 x i8> %z
}

define <8 x i16> @v8i16(<8 x i16> %x, <8 x i16> %y) nounwind {
; SSE-LABEL: v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    psubusw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsubusw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %z = call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> %x, <8 x i16> %y)
  ret <8 x i16> %z
}

define <16 x i16> @v16i16(<16 x i16> %x, <16 x i16> %y) nounwind {
; SSE-LABEL: v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    psubusw %xmm2, %xmm0
; SSE-NEXT:    psubusw %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpsubusw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsubusw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsubusw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: v16i16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsubusw %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %z = call <16 x i16> @llvm.usub.sat.v16i16(<16 x i16> %x, <16 x i16> %y)
  ret <16 x i16> %z
}

define <32 x i16> @v32i16(<32 x i16> %x, <32 x i16> %y) nounwind {
; SSE-LABEL: v32i16:
; SSE:       # %bb.0:
; SSE-NEXT:    psubusw %xmm4, %xmm0
; SSE-NEXT:    psubusw %xmm5, %xmm1
; SSE-NEXT:    psubusw %xmm6, %xmm2
; SSE-NEXT:    psubusw %xmm7, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: v32i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpsubusw %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpsubusw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX1-NEXT:    vpsubusw %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpsubusw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v32i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsubusw %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsubusw %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vextracti64x4 $1, %zmm1, %ymm2
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm3
; AVX512F-NEXT:    vpsubusw %ymm2, %ymm3, %ymm2
; AVX512F-NEXT:    vpsubusw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vinserti64x4 $1, %ymm2, %zmm0, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpsubusw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %z = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %x, <32 x i16> %y)
  ret <32 x i16> %z
}

; Too narrow vectors, legalized by widening.

define void @v8i8(<8 x i8>* %px, <8 x i8>* %py, <8 x i8>* %pz) nounwind {
; SSE-LABEL: v8i8:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    psubusb %xmm1, %xmm0
; SSE-NEXT:    movq %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: v8i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsubusb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovq %xmm0, (%rdx)
; AVX-NEXT:    retq
  %x = load <8 x i8>, <8 x i8>* %px
  %y = load <8 x i8>, <8 x i8>* %py
  %z = call <8 x i8> @llvm.usub.sat.v8i8(<8 x i8> %x, <8 x i8> %y)
  store <8 x i8> %z, <8 x i8>* %pz
  ret void
}

define void @v4i8(<4 x i8>* %px, <4 x i8>* %py, <4 x i8>* %pz) nounwind {
; SSE-LABEL: v4i8:
; SSE:       # %bb.0:
; SSE-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    psubusb %xmm1, %xmm0
; SSE-NEXT:    movd %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: v4i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vpsubusb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, (%rdx)
; AVX-NEXT:    retq
  %x = load <4 x i8>, <4 x i8>* %px
  %y = load <4 x i8>, <4 x i8>* %py
  %z = call <4 x i8> @llvm.usub.sat.v4i8(<4 x i8> %x, <4 x i8> %y)
  store <4 x i8> %z, <4 x i8>* %pz
  ret void
}

define void @v2i8(<2 x i8>* %px, <2 x i8>* %py, <2 x i8>* %pz) nounwind {
; SSE2-LABEL: v2i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movzwl (%rdi), %eax
; SSE2-NEXT:    movd %eax, %xmm0
; SSE2-NEXT:    movzwl (%rsi), %eax
; SSE2-NEXT:    movd %eax, %xmm1
; SSE2-NEXT:    psubusb %xmm1, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rdx)
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: v2i8:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movzwl (%rdi), %eax
; SSSE3-NEXT:    movd %eax, %xmm0
; SSSE3-NEXT:    movzwl (%rsi), %eax
; SSSE3-NEXT:    movd %eax, %xmm1
; SSSE3-NEXT:    psubusb %xmm1, %xmm0
; SSSE3-NEXT:    movd %xmm0, %eax
; SSSE3-NEXT:    movw %ax, (%rdx)
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: v2i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movzwl (%rdi), %eax
; SSE41-NEXT:    movd %eax, %xmm0
; SSE41-NEXT:    movzwl (%rsi), %eax
; SSE41-NEXT:    movd %eax, %xmm1
; SSE41-NEXT:    psubusb %xmm1, %xmm0
; SSE41-NEXT:    pextrw $0, %xmm0, (%rdx)
; SSE41-NEXT:    retq
;
; AVX-LABEL: v2i8:
; AVX:       # %bb.0:
; AVX-NEXT:    movzwl (%rdi), %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    movzwl (%rsi), %eax
; AVX-NEXT:    vmovd %eax, %xmm1
; AVX-NEXT:    vpsubusb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpextrw $0, %xmm0, (%rdx)
; AVX-NEXT:    retq
  %x = load <2 x i8>, <2 x i8>* %px
  %y = load <2 x i8>, <2 x i8>* %py
  %z = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %x, <2 x i8> %y)
  store <2 x i8> %z, <2 x i8>* %pz
  ret void
}

define void @v4i16(<4 x i16>* %px, <4 x i16>* %py, <4 x i16>* %pz) nounwind {
; SSE-LABEL: v4i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    psubusw %xmm1, %xmm0
; SSE-NEXT:    movq %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: v4i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsubusw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovq %xmm0, (%rdx)
; AVX-NEXT:    retq
  %x = load <4 x i16>, <4 x i16>* %px
  %y = load <4 x i16>, <4 x i16>* %py
  %z = call <4 x i16> @llvm.usub.sat.v4i16(<4 x i16> %x, <4 x i16> %y)
  store <4 x i16> %z, <4 x i16>* %pz
  ret void
}

define void @v2i16(<2 x i16>* %px, <2 x i16>* %py, <2 x i16>* %pz) nounwind {
; SSE-LABEL: v2i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    psubusw %xmm1, %xmm0
; SSE-NEXT:    movd %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: v2i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vpsubusw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, (%rdx)
; AVX-NEXT:    retq
  %x = load <2 x i16>, <2 x i16>* %px
  %y = load <2 x i16>, <2 x i16>* %py
  %z = call <2 x i16> @llvm.usub.sat.v2i16(<2 x i16> %x, <2 x i16> %y)
  store <2 x i16> %z, <2 x i16>* %pz
  ret void
}

define <12 x i8> @v12i8(<12 x i8> %x, <12 x i8> %y) nounwind {
; SSE-LABEL: v12i8:
; SSE:       # %bb.0:
; SSE-NEXT:    psubusb %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v12i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsubusb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %z = call <12 x i8> @llvm.usub.sat.v12i8(<12 x i8> %x, <12 x i8> %y)
  ret <12 x i8> %z
}

define void @v12i16(<12 x i16>* %px, <12 x i16>* %py, <12 x i16>* %pz) nounwind {
; SSE-LABEL: v12i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa 16(%rdi), %xmm1
; SSE-NEXT:    psubusw 16(%rsi), %xmm1
; SSE-NEXT:    psubusw (%rsi), %xmm0
; SSE-NEXT:    movdqa %xmm0, (%rdx)
; SSE-NEXT:    movq %xmm1, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: v12i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa (%rdi), %xmm0
; AVX1-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vpsubusw 16(%rsi), %xmm1, %xmm1
; AVX1-NEXT:    vpsubusw (%rsi), %xmm0, %xmm0
; AVX1-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX1-NEXT:    vmovq %xmm1, 16(%rdx)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v12i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vpsubusw (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovq %xmm1, 16(%rdx)
; AVX2-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: v12i16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512-NEXT:    vpsubusw (%rsi), %ymm0, %ymm0
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vmovq %xmm1, 16(%rdx)
; AVX512-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %x = load <12 x i16>, <12 x i16>* %px
  %y = load <12 x i16>, <12 x i16>* %py
  %z = call <12 x i16> @llvm.usub.sat.v12i16(<12 x i16> %x, <12 x i16> %y)
  store <12 x i16> %z, <12 x i16>* %pz
  ret void
}

; Scalarization

define void @v1i8(<1 x i8>* %px, <1 x i8>* %py, <1 x i8>* %pz) nounwind {
; SSE-LABEL: v1i8:
; SSE:       # %bb.0:
; SSE-NEXT:    movb (%rdi), %al
; SSE-NEXT:    xorl %ecx, %ecx
; SSE-NEXT:    subb (%rsi), %al
; SSE-NEXT:    movzbl %al, %eax
; SSE-NEXT:    cmovbl %ecx, %eax
; SSE-NEXT:    movb %al, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: v1i8:
; AVX:       # %bb.0:
; AVX-NEXT:    movb (%rdi), %al
; AVX-NEXT:    xorl %ecx, %ecx
; AVX-NEXT:    subb (%rsi), %al
; AVX-NEXT:    movzbl %al, %eax
; AVX-NEXT:    cmovbl %ecx, %eax
; AVX-NEXT:    movb %al, (%rdx)
; AVX-NEXT:    retq
  %x = load <1 x i8>, <1 x i8>* %px
  %y = load <1 x i8>, <1 x i8>* %py
  %z = call <1 x i8> @llvm.usub.sat.v1i8(<1 x i8> %x, <1 x i8> %y)
  store <1 x i8> %z, <1 x i8>* %pz
  ret void
}

define void @v1i16(<1 x i16>* %px, <1 x i16>* %py, <1 x i16>* %pz) nounwind {
; SSE-LABEL: v1i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movzwl (%rdi), %eax
; SSE-NEXT:    xorl %ecx, %ecx
; SSE-NEXT:    subw (%rsi), %ax
; SSE-NEXT:    cmovbl %ecx, %eax
; SSE-NEXT:    movw %ax, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: v1i16:
; AVX:       # %bb.0:
; AVX-NEXT:    movzwl (%rdi), %eax
; AVX-NEXT:    xorl %ecx, %ecx
; AVX-NEXT:    subw (%rsi), %ax
; AVX-NEXT:    cmovbl %ecx, %eax
; AVX-NEXT:    movw %ax, (%rdx)
; AVX-NEXT:    retq
  %x = load <1 x i16>, <1 x i16>* %px
  %y = load <1 x i16>, <1 x i16>* %py
  %z = call <1 x i16> @llvm.usub.sat.v1i16(<1 x i16> %x, <1 x i16> %y)
  store <1 x i16> %z, <1 x i16>* %pz
  ret void
}

; Promotion

define <16 x i4> @v16i4(<16 x i4> %x, <16 x i4> %y) nounwind {
; SSE-LABEL: v16i4:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; SSE-NEXT:    pand %xmm2, %xmm1
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    psubusb %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v16i4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vpsubusb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %z = call <16 x i4> @llvm.usub.sat.v16i4(<16 x i4> %x, <16 x i4> %y)
  ret <16 x i4> %z
}

define <16 x i1> @v16i1(<16 x i1> %x, <16 x i1> %y) nounwind {
; SSE-LABEL: v16i1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    andps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: v16i1:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16i1:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v16i1:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX512F-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16i1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpternlogq $96, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm0
; AVX512BW-NEXT:    retq
  %z = call <16 x i1> @llvm.usub.sat.v16i1(<16 x i1> %x, <16 x i1> %y)
  ret <16 x i1> %z
}

; Expanded

define <2 x i32> @v2i32(<2 x i32> %x, <2 x i32> %y) nounwind {
; SSE2-LABEL: v2i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm2
; SSE2-NEXT:    psubd %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: v2i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; SSSE3-NEXT:    movdqa %xmm1, %xmm3
; SSSE3-NEXT:    pxor %xmm2, %xmm3
; SSSE3-NEXT:    pxor %xmm0, %xmm2
; SSSE3-NEXT:    pcmpgtd %xmm3, %xmm2
; SSSE3-NEXT:    psubd %xmm1, %xmm0
; SSSE3-NEXT:    pand %xmm2, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: v2i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmaxud %xmm1, %xmm0
; SSE41-NEXT:    psubd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: v2i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmaxud %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %z = call <2 x i32> @llvm.usub.sat.v2i32(<2 x i32> %x, <2 x i32> %y)
  ret <2 x i32> %z
}

define <4 x i32> @v4i32(<4 x i32> %x, <4 x i32> %y) nounwind {
; SSE2-LABEL: v4i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; SSE2-NEXT:    movdqa %xmm1, %xmm3
; SSE2-NEXT:    pxor %xmm2, %xmm3
; SSE2-NEXT:    pxor %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtd %xmm3, %xmm2
; SSE2-NEXT:    psubd %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: v4i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; SSSE3-NEXT:    movdqa %xmm1, %xmm3
; SSSE3-NEXT:    pxor %xmm2, %xmm3
; SSSE3-NEXT:    pxor %xmm0, %xmm2
; SSSE3-NEXT:    pcmpgtd %xmm3, %xmm2
; SSSE3-NEXT:    psubd %xmm1, %xmm0
; SSSE3-NEXT:    pand %xmm2, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: v4i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmaxud %xmm1, %xmm0
; SSE41-NEXT:    psubd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: v4i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmaxud %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %z = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %x, <4 x i32> %y)
  ret <4 x i32> %z
}

define <8 x i32> @v8i32(<8 x i32> %x, <8 x i32> %y) nounwind {
; SSE2-LABEL: v8i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,2147483648,2147483648,2147483648]
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    psubd %xmm2, %xmm0
; SSE2-NEXT:    pxor %xmm4, %xmm2
; SSE2-NEXT:    pxor %xmm4, %xmm5
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm5
; SSE2-NEXT:    pand %xmm5, %xmm0
; SSE2-NEXT:    movdqa %xmm3, %xmm2
; SSE2-NEXT:    pxor %xmm4, %xmm2
; SSE2-NEXT:    pxor %xmm1, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm4
; SSE2-NEXT:    psubd %xmm3, %xmm1
; SSE2-NEXT:    pand %xmm4, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: v8i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqa {{.*#+}} xmm4 = [2147483648,2147483648,2147483648,2147483648]
; SSSE3-NEXT:    movdqa %xmm0, %xmm5
; SSSE3-NEXT:    psubd %xmm2, %xmm0
; SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSSE3-NEXT:    pxor %xmm4, %xmm5
; SSSE3-NEXT:    pcmpgtd %xmm2, %xmm5
; SSSE3-NEXT:    pand %xmm5, %xmm0
; SSSE3-NEXT:    movdqa %xmm3, %xmm2
; SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSSE3-NEXT:    pxor %xmm1, %xmm4
; SSSE3-NEXT:    pcmpgtd %xmm2, %xmm4
; SSSE3-NEXT:    psubd %xmm3, %xmm1
; SSSE3-NEXT:    pand %xmm4, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: v8i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmaxud %xmm2, %xmm0
; SSE41-NEXT:    psubd %xmm2, %xmm0
; SSE41-NEXT:    pmaxud %xmm3, %xmm1
; SSE41-NEXT:    psubd %xmm3, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpmaxud %xmm2, %xmm3, %xmm3
; AVX1-NEXT:    vpsubd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpmaxud %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmaxud %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsubd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: v8i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmaxud %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpsubd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %z = call <8 x i32> @llvm.usub.sat.v8i32(<8 x i32> %x, <8 x i32> %y)
  ret <8 x i32> %z
}

define <16 x i32> @v16i32(<16 x i32> %x, <16 x i32> %y) nounwind {
; SSE2-LABEL: v16i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm8 = [2147483648,2147483648,2147483648,2147483648]
; SSE2-NEXT:    movdqa %xmm0, %xmm9
; SSE2-NEXT:    psubd %xmm4, %xmm0
; SSE2-NEXT:    pxor %xmm8, %xmm4
; SSE2-NEXT:    pxor %xmm8, %xmm9
; SSE2-NEXT:    pcmpgtd %xmm4, %xmm9
; SSE2-NEXT:    pand %xmm9, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    psubd %xmm5, %xmm1
; SSE2-NEXT:    pxor %xmm8, %xmm5
; SSE2-NEXT:    pxor %xmm8, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm4
; SSE2-NEXT:    pand %xmm4, %xmm1
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    psubd %xmm6, %xmm2
; SSE2-NEXT:    pxor %xmm8, %xmm6
; SSE2-NEXT:    pxor %xmm8, %xmm4
; SSE2-NEXT:    pcmpgtd %xmm6, %xmm4
; SSE2-NEXT:    pand %xmm4, %xmm2
; SSE2-NEXT:    movdqa %xmm7, %xmm4
; SSE2-NEXT:    pxor %xmm8, %xmm4
; SSE2-NEXT:    pxor %xmm3, %xmm8
; SSE2-NEXT:    pcmpgtd %xmm4, %xmm8
; SSE2-NEXT:    psubd %xmm7, %xmm3
; SSE2-NEXT:    pand %xmm8, %xmm3
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: v16i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqa {{.*#+}} xmm8 = [2147483648,2147483648,2147483648,2147483648]
; SSSE3-NEXT:    movdqa %xmm0, %xmm9
; SSSE3-NEXT:    psubd %xmm4, %xmm0
; SSSE3-NEXT:    pxor %xmm8, %xmm4
; SSSE3-NEXT:    pxor %xmm8, %xmm9
; SSSE3-NEXT:    pcmpgtd %xmm4, %xmm9
; SSSE3-NEXT:    pand %xmm9, %xmm0
; SSSE3-NEXT:    movdqa %xmm1, %xmm4
; SSSE3-NEXT:    psubd %xmm5, %xmm1
; SSSE3-NEXT:    pxor %xmm8, %xmm5
; SSSE3-NEXT:    pxor %xmm8, %xmm4
; SSSE3-NEXT:    pcmpgtd %xmm5, %xmm4
; SSSE3-NEXT:    pand %xmm4, %xmm1
; SSSE3-NEXT:    movdqa %xmm2, %xmm4
; SSSE3-NEXT:    psubd %xmm6, %xmm2
; SSSE3-NEXT:    pxor %xmm8, %xmm6
; SSSE3-NEXT:    pxor %xmm8, %xmm4
; SSSE3-NEXT:    pcmpgtd %xmm6, %xmm4
; SSSE3-NEXT:    pand %xmm4, %xmm2
; SSSE3-NEXT:    movdqa %xmm7, %xmm4
; SSSE3-NEXT:    pxor %xmm8, %xmm4
; SSSE3-NEXT:    pxor %xmm3, %xmm8
; SSSE3-NEXT:    pcmpgtd %xmm4, %xmm8
; SSSE3-NEXT:    psubd %xmm7, %xmm3
; SSSE3-NEXT:    pand %xmm8, %xmm3
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: v16i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmaxud %xmm4, %xmm0
; SSE41-NEXT:    psubd %xmm4, %xmm0
; SSE41-NEXT:    pmaxud %xmm5, %xmm1
; SSE41-NEXT:    psubd %xmm5, %xmm1
; SSE41-NEXT:    pmaxud %xmm6, %xmm2
; SSE41-NEXT:    psubd %xmm6, %xmm2
; SSE41-NEXT:    pmaxud %xmm7, %xmm3
; SSE41-NEXT:    psubd %xmm7, %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: v16i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpmaxud %xmm4, %xmm5, %xmm5
; AVX1-NEXT:    vpsubd %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpmaxud %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX1-NEXT:    vpmaxud %xmm2, %xmm4, %xmm4
; AVX1-NEXT:    vpsubd %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpmaxud %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpsubd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmaxud %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsubd %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpmaxud %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpsubd %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: v16i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmaxud %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpsubd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    retq
  %z = call <16 x i32> @llvm.usub.sat.v16i32(<16 x i32> %x, <16 x i32> %y)
  ret <16 x i32> %z
}

define <2 x i64> @v2i64(<2 x i64> %x, <2 x i64> %y) nounwind {
; SSE-LABEL: v2i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [9223372039002259456,9223372039002259456]
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    pxor %xmm2, %xmm3
; SSE-NEXT:    pxor %xmm0, %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm4
; SSE-NEXT:    pcmpgtd %xmm3, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[0,0,2,2]
; SSE-NEXT:    pcmpeqd %xmm3, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE-NEXT:    pand %xmm5, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,3,3]
; SSE-NEXT:    por %xmm2, %xmm3
; SSE-NEXT:    psubq %xmm1, %xmm0
; SSE-NEXT:    pand %xmm3, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: v2i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [9223372036854775808,9223372036854775808]
; AVX1-NEXT:    vpxor %xmm2, %xmm1, %xmm3
; AVX1-NEXT:    vpxor %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsubq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v2i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [9223372036854775808,9223372036854775808]
; AVX2-NEXT:    vpxor %xmm2, %xmm1, %xmm3
; AVX2-NEXT:    vpxor %xmm2, %xmm0, %xmm2
; AVX2-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpsubq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpand %xmm0, %xmm2, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v2i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vpmaxuq %zmm1, %zmm0, %zmm0
; AVX512F-NEXT:    vpsubq %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v2i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmaxuq %xmm1, %xmm0, %xmm0
; AVX512BW-NEXT:    vpsubq %xmm1, %xmm0, %xmm0
; AVX512BW-NEXT:    retq
  %z = call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> %x, <2 x i64> %y)
  ret <2 x i64> %z
}

define <4 x i64> @v4i64(<4 x i64> %x, <4 x i64> %y) nounwind {
; SSE-LABEL: v4i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [9223372039002259456,9223372039002259456]
; SSE-NEXT:    movdqa %xmm0, %xmm5
; SSE-NEXT:    psubq %xmm2, %xmm0
; SSE-NEXT:    pxor %xmm4, %xmm2
; SSE-NEXT:    pxor %xmm4, %xmm5
; SSE-NEXT:    movdqa %xmm5, %xmm6
; SSE-NEXT:    pcmpgtd %xmm2, %xmm6
; SSE-NEXT:    pshufd {{.*#+}} xmm7 = xmm6[0,0,2,2]
; SSE-NEXT:    pcmpeqd %xmm2, %xmm5
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm5[1,1,3,3]
; SSE-NEXT:    pand %xmm7, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm6[1,1,3,3]
; SSE-NEXT:    por %xmm2, %xmm5
; SSE-NEXT:    pand %xmm5, %xmm0
; SSE-NEXT:    movdqa %xmm3, %xmm2
; SSE-NEXT:    pxor %xmm4, %xmm2
; SSE-NEXT:    pxor %xmm1, %xmm4
; SSE-NEXT:    movdqa %xmm4, %xmm5
; SSE-NEXT:    pcmpgtd %xmm2, %xmm5
; SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,0,2,2]
; SSE-NEXT:    pcmpeqd %xmm2, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm4[1,1,3,3]
; SSE-NEXT:    pand %xmm6, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm5[1,1,3,3]
; SSE-NEXT:    por %xmm2, %xmm4
; SSE-NEXT:    psubq %xmm3, %xmm1
; SSE-NEXT:    pand %xmm4, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [9223372036854775808,9223372036854775808]
; AVX1-NEXT:    vpxor %xmm3, %xmm2, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpxor %xmm3, %xmm5, %xmm6
; AVX1-NEXT:    vpcmpgtq %xmm4, %xmm6, %xmm4
; AVX1-NEXT:    vpsubq %xmm2, %xmm5, %xmm2
; AVX1-NEXT:    vpand %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm1, %xmm4
; AVX1-NEXT:    vpxor %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpsubq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastq {{.*#+}} ymm2 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
; AVX2-NEXT:    vpxor %ymm2, %ymm1, %ymm3
; AVX2-NEXT:    vpxor %ymm2, %ymm0, %ymm2
; AVX2-NEXT:    vpcmpgtq %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vpsubq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v4i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vpmaxuq %zmm1, %zmm0, %zmm0
; AVX512F-NEXT:    vpsubq %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmaxuq %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vpsubq %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    retq
  %z = call <4 x i64> @llvm.usub.sat.v4i64(<4 x i64> %x, <4 x i64> %y)
  ret <4 x i64> %z
}

define <8 x i64> @v8i64(<8 x i64> %x, <8 x i64> %y) nounwind {
; SSE-LABEL: v8i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm8 = [9223372039002259456,9223372039002259456]
; SSE-NEXT:    movdqa %xmm0, %xmm9
; SSE-NEXT:    psubq %xmm4, %xmm0
; SSE-NEXT:    pxor %xmm8, %xmm4
; SSE-NEXT:    pxor %xmm8, %xmm9
; SSE-NEXT:    movdqa %xmm9, %xmm10
; SSE-NEXT:    pcmpgtd %xmm4, %xmm10
; SSE-NEXT:    pshufd {{.*#+}} xmm11 = xmm10[0,0,2,2]
; SSE-NEXT:    pcmpeqd %xmm4, %xmm9
; SSE-NEXT:    pshufd {{.*#+}} xmm9 = xmm9[1,1,3,3]
; SSE-NEXT:    pand %xmm11, %xmm9
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm10[1,1,3,3]
; SSE-NEXT:    por %xmm9, %xmm4
; SSE-NEXT:    pand %xmm4, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm9
; SSE-NEXT:    psubq %xmm5, %xmm1
; SSE-NEXT:    pxor %xmm8, %xmm5
; SSE-NEXT:    pxor %xmm8, %xmm9
; SSE-NEXT:    movdqa %xmm9, %xmm4
; SSE-NEXT:    pcmpgtd %xmm5, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm10 = xmm4[0,0,2,2]
; SSE-NEXT:    pcmpeqd %xmm5, %xmm9
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm9[1,1,3,3]
; SSE-NEXT:    pand %xmm10, %xmm5
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE-NEXT:    por %xmm5, %xmm4
; SSE-NEXT:    pand %xmm4, %xmm1
; SSE-NEXT:    movdqa %xmm2, %xmm4
; SSE-NEXT:    psubq %xmm6, %xmm2
; SSE-NEXT:    pxor %xmm8, %xmm6
; SSE-NEXT:    pxor %xmm8, %xmm4
; SSE-NEXT:    movdqa %xmm4, %xmm5
; SSE-NEXT:    pcmpgtd %xmm6, %xmm5
; SSE-NEXT:    pshufd {{.*#+}} xmm9 = xmm5[0,0,2,2]
; SSE-NEXT:    pcmpeqd %xmm6, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE-NEXT:    pand %xmm9, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[1,1,3,3]
; SSE-NEXT:    por %xmm4, %xmm5
; SSE-NEXT:    pand %xmm5, %xmm2
; SSE-NEXT:    movdqa %xmm7, %xmm4
; SSE-NEXT:    pxor %xmm8, %xmm4
; SSE-NEXT:    pxor %xmm3, %xmm8
; SSE-NEXT:    movdqa %xmm8, %xmm5
; SSE-NEXT:    pcmpgtd %xmm4, %xmm5
; SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm5[0,0,2,2]
; SSE-NEXT:    pcmpeqd %xmm4, %xmm8
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm8[1,1,3,3]
; SSE-NEXT:    pand %xmm6, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[1,1,3,3]
; SSE-NEXT:    por %xmm4, %xmm5
; SSE-NEXT:    psubq %xmm7, %xmm3
; SSE-NEXT:    pand %xmm5, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: v8i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm4
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm5 = [9223372036854775808,9223372036854775808]
; AVX1-NEXT:    vpxor %xmm5, %xmm4, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm7
; AVX1-NEXT:    vpxor %xmm5, %xmm7, %xmm6
; AVX1-NEXT:    vpcmpgtq %xmm8, %xmm6, %xmm6
; AVX1-NEXT:    vpsubq %xmm4, %xmm7, %xmm4
; AVX1-NEXT:    vpand %xmm4, %xmm6, %xmm4
; AVX1-NEXT:    vpxor %xmm5, %xmm2, %xmm6
; AVX1-NEXT:    vpxor %xmm5, %xmm0, %xmm7
; AVX1-NEXT:    vpcmpgtq %xmm6, %xmm7, %xmm6
; AVX1-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm0, %xmm6, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm2
; AVX1-NEXT:    vpxor %xmm5, %xmm2, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm6
; AVX1-NEXT:    vpxor %xmm5, %xmm6, %xmm7
; AVX1-NEXT:    vpcmpgtq %xmm4, %xmm7, %xmm4
; AVX1-NEXT:    vpsubq %xmm2, %xmm6, %xmm2
; AVX1-NEXT:    vpand %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpxor %xmm5, %xmm3, %xmm4
; AVX1-NEXT:    vpxor %xmm5, %xmm1, %xmm5
; AVX1-NEXT:    vpcmpgtq %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpsubq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm4, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastq {{.*#+}} ymm4 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
; AVX2-NEXT:    vpxor %ymm4, %ymm2, %ymm5
; AVX2-NEXT:    vpxor %ymm4, %ymm0, %ymm6
; AVX2-NEXT:    vpcmpgtq %ymm5, %ymm6, %ymm5
; AVX2-NEXT:    vpsubq %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm0, %ymm5, %ymm0
; AVX2-NEXT:    vpxor %ymm4, %ymm3, %ymm2
; AVX2-NEXT:    vpxor %ymm4, %ymm1, %ymm4
; AVX2-NEXT:    vpcmpgtq %ymm2, %ymm4, %ymm2
; AVX2-NEXT:    vpsubq %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpand %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: v8i64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmaxuq %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vpsubq %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    retq
  %z = call <8 x i64> @llvm.usub.sat.v8i64(<8 x i64> %x, <8 x i64> %y)
  ret <8 x i64> %z
}

define <2 x i128> @v2i128(<2 x i128> %x, <2 x i128> %y) nounwind {
; SSE-LABEL: v2i128:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %rax
; SSE-NEXT:    xorl %edi, %edi
; SSE-NEXT:    subq %r9, %rsi
; SSE-NEXT:    sbbq {{[0-9]+}}(%rsp), %rdx
; SSE-NEXT:    cmovbq %rdi, %rsi
; SSE-NEXT:    cmovbq %rdi, %rdx
; SSE-NEXT:    subq {{[0-9]+}}(%rsp), %rcx
; SSE-NEXT:    sbbq {{[0-9]+}}(%rsp), %r8
; SSE-NEXT:    cmovbq %rdi, %r8
; SSE-NEXT:    cmovbq %rdi, %rcx
; SSE-NEXT:    movq %r8, 24(%rax)
; SSE-NEXT:    movq %rcx, 16(%rax)
; SSE-NEXT:    movq %rdx, 8(%rax)
; SSE-NEXT:    movq %rsi, (%rax)
; SSE-NEXT:    retq
;
; AVX-LABEL: v2i128:
; AVX:       # %bb.0:
; AVX-NEXT:    movq %rdi, %rax
; AVX-NEXT:    xorl %edi, %edi
; AVX-NEXT:    subq %r9, %rsi
; AVX-NEXT:    sbbq {{[0-9]+}}(%rsp), %rdx
; AVX-NEXT:    cmovbq %rdi, %rsi
; AVX-NEXT:    cmovbq %rdi, %rdx
; AVX-NEXT:    subq {{[0-9]+}}(%rsp), %rcx
; AVX-NEXT:    sbbq {{[0-9]+}}(%rsp), %r8
; AVX-NEXT:    cmovbq %rdi, %r8
; AVX-NEXT:    cmovbq %rdi, %rcx
; AVX-NEXT:    movq %r8, 24(%rax)
; AVX-NEXT:    movq %rcx, 16(%rax)
; AVX-NEXT:    movq %rdx, 8(%rax)
; AVX-NEXT:    movq %rsi, (%rax)
; AVX-NEXT:    retq
  %z = call <2 x i128> @llvm.usub.sat.v2i128(<2 x i128> %x, <2 x i128> %y)
  ret <2 x i128> %z
}

define void @PR48223(<32 x i16>* %p0) {
; SSE-LABEL: PR48223:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    movdqa 16(%rdi), %xmm1
; SSE-NEXT:    movdqa 32(%rdi), %xmm2
; SSE-NEXT:    movdqa 48(%rdi), %xmm3
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [64,64,64,64,64,64,64,64]
; SSE-NEXT:    psubusw %xmm4, %xmm1
; SSE-NEXT:    psubusw %xmm4, %xmm0
; SSE-NEXT:    psubusw %xmm4, %xmm3
; SSE-NEXT:    psubusw %xmm4, %xmm2
; SSE-NEXT:    movdqa %xmm2, 32(%rdi)
; SSE-NEXT:    movdqa %xmm3, 48(%rdi)
; SSE-NEXT:    movdqa %xmm0, (%rdi)
; SSE-NEXT:    movdqa %xmm1, 16(%rdi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: PR48223:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa (%rdi), %xmm0
; AVX1-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX1-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [64,64,64,64,64,64,64,64]
; AVX1-NEXT:    vpsubusw %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpsubusw %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpsubusw %xmm4, %xmm1, %xmm1
; AVX1-NEXT:    vpsubusw %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vmovdqa %xmm0, (%rdi)
; AVX1-NEXT:    vmovdqa %xmm1, 16(%rdi)
; AVX1-NEXT:    vmovdqa %xmm2, 32(%rdi)
; AVX1-NEXT:    vmovdqa %xmm3, 48(%rdi)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: PR48223:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
; AVX2-NEXT:    vpsubusw %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    vpsubusw %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vmovdqa %ymm0, (%rdi)
; AVX2-NEXT:    vmovdqa %ymm1, 32(%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: PR48223:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
; AVX512F-NEXT:    vpsubusw %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vpsubusw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vmovdqa %ymm0, (%rdi)
; AVX512F-NEXT:    vmovdqa %ymm1, 32(%rdi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: PR48223:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa64 (%rdi), %zmm0
; AVX512BW-NEXT:    vpsubusw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; AVX512BW-NEXT:    vmovdqa64 %zmm0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %1 = load <32 x i16>, <32 x i16>* %p0, align 64
  %2 = icmp ugt <32 x i16> %1, <i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63, i16 63>
  %3 = add <32 x i16> %1, <i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64, i16 -64>
  %4 = select <32 x i1> %2, <32 x i16> %3, <32 x i16> zeroinitializer
  store <32 x i16> %4, <32 x i16>* %p0, align 64
  ret void
}
