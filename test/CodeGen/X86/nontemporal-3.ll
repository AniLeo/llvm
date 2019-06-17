; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefixes=SSE,SSE4A
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512dq,+avx512vl | FileCheck %s --check-prefixes=AVX512,AVX512DQ
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512,AVX512BW

; Test codegen for under aligned nontemporal vector stores

; XMM versions.

define void @test_zero_v2f64_align1(<2 x double>* %dst) nounwind {
; SSE-LABEL: test_zero_v2f64_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v2f64_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v2f64_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %xmm0, (%rdi)
; AVX512-NEXT:    retq
  store <2 x double> zeroinitializer, <2 x double>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v4f32_align1(<4 x float>* %dst) nounwind {
; SSE-LABEL: test_zero_v4f32_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4f32_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v4f32_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %xmm0, (%rdi)
; AVX512-NEXT:    retq
  store <4 x float> zeroinitializer, <4 x float>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v2i64_align1(<2 x i64>* %dst) nounwind {
; SSE-LABEL: test_zero_v2i64_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v2i64_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v2i64_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %xmm0, (%rdi)
; AVX512-NEXT:    retq
  store <2 x i64> zeroinitializer, <2 x i64>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v4i32_align1(<4 x i32>* %dst) nounwind {
; SSE-LABEL: test_zero_v4i32_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4i32_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v4i32_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %xmm0, (%rdi)
; AVX512-NEXT:    retq
  store <4 x i32> zeroinitializer, <4 x i32>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v8i16_align1(<8 x i16>* %dst) nounwind {
; SSE-LABEL: test_zero_v8i16_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i16_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8i16_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %xmm0, (%rdi)
; AVX512-NEXT:    retq
  store <8 x i16> zeroinitializer, <8 x i16>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v16i8_align1(<16 x i8>* %dst) nounwind {
; SSE-LABEL: test_zero_v16i8_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i8_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16i8_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %xmm0, (%rdi)
; AVX512-NEXT:    retq
  store <16 x i8> zeroinitializer, <16 x i8>* %dst, align 1, !nontemporal !1
  ret void
}

; YMM versions.

define void @test_zero_v4f64_align1(<4 x double>* %dst) nounwind {
; SSE-LABEL: test_zero_v4f64_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4f64_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v4f64_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <4 x double> zeroinitializer, <4 x double>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v8f32_align1(<8 x float>* %dst) nounwind {
; SSE-LABEL: test_zero_v8f32_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8f32_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8f32_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x float> zeroinitializer, <8 x float>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v4i64_align1(<4 x i64>* %dst) nounwind {
; SSE-LABEL: test_zero_v4i64_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4i64_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v4i64_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <4 x i64> zeroinitializer, <4 x i64>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v8i32_align1(<8 x i32>* %dst) nounwind {
; SSE-LABEL: test_zero_v8i32_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i32_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8i32_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x i32> zeroinitializer, <8 x i32>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v16i16_align1(<16 x i16>* %dst) nounwind {
; SSE-LABEL: test_zero_v16i16_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i16_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16i16_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x i16> zeroinitializer, <16 x i16>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v32i8_align1(<32 x i8>* %dst) nounwind {
; SSE-LABEL: test_zero_v32i8_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v32i8_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v32i8_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <32 x i8> zeroinitializer, <32 x i8>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v4f64_align16(<4 x double>* %dst) nounwind {
; SSE-LABEL: test_zero_v4f64_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4f64_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v4f64_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <4 x double> zeroinitializer, <4 x double>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v8f32_align16(<8 x float>* %dst) nounwind {
; SSE-LABEL: test_zero_v8f32_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8f32_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8f32_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x float> zeroinitializer, <8 x float>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v4i64_align16(<4 x i64>* %dst) nounwind {
; SSE-LABEL: test_zero_v4i64_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4i64_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v4i64_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <4 x i64> zeroinitializer, <4 x i64>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v8i32_align16(<8 x i32>* %dst) nounwind {
; SSE-LABEL: test_zero_v8i32_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i32_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8i32_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x i32> zeroinitializer, <8 x i32>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v16i16_align16(<16 x i16>* %dst) nounwind {
; SSE-LABEL: test_zero_v16i16_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i16_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16i16_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x i16> zeroinitializer, <16 x i16>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v32i8_align16(<32 x i8>* %dst) nounwind {
; SSE-LABEL: test_zero_v32i8_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v32i8_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v32i8_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <32 x i8> zeroinitializer, <32 x i8>* %dst, align 16, !nontemporal !1
  ret void
}

; ZMM versions.

define void @test_zero_v8f64_align1(<8 x double>* %dst) nounwind {
; SSE-LABEL: test_zero_v8f64_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 48(%rdi)
; SSE-NEXT:    movups %xmm0, 32(%rdi)
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8f64_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8f64_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x double> zeroinitializer, <8 x double>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v16f32_align1(<16 x float>* %dst) nounwind {
; SSE-LABEL: test_zero_v16f32_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 48(%rdi)
; SSE-NEXT:    movups %xmm0, 32(%rdi)
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16f32_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16f32_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x float> zeroinitializer, <16 x float>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v8i64_align1(<8 x i64>* %dst) nounwind {
; SSE-LABEL: test_zero_v8i64_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 48(%rdi)
; SSE-NEXT:    movups %xmm0, 32(%rdi)
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i64_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8i64_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x i64> zeroinitializer, <8 x i64>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v16i32_align1(<16 x i32>* %dst) nounwind {
; SSE-LABEL: test_zero_v16i32_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 48(%rdi)
; SSE-NEXT:    movups %xmm0, 32(%rdi)
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i32_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16i32_align1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x i32> zeroinitializer, <16 x i32>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v32i16_align1(<32 x i16>* %dst) nounwind {
; SSE-LABEL: test_zero_v32i16_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 48(%rdi)
; SSE-NEXT:    movups %xmm0, 32(%rdi)
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v32i16_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512DQ-LABEL: test_zero_v32i16_align1:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512DQ-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX512DQ-NEXT:    vmovups %ymm0, (%rdi)
; AVX512DQ-NEXT:    vzeroupper
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: test_zero_v32i16_align1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512BW-NEXT:    vmovups %zmm0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  store <32 x i16> zeroinitializer, <32 x i16>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v64i8_align1(<64 x i8>* %dst) nounwind {
; SSE-LABEL: test_zero_v64i8_align1:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movups %xmm0, 48(%rdi)
; SSE-NEXT:    movups %xmm0, 32(%rdi)
; SSE-NEXT:    movups %xmm0, 16(%rdi)
; SSE-NEXT:    movups %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v64i8_align1:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512DQ-LABEL: test_zero_v64i8_align1:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512DQ-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX512DQ-NEXT:    vmovups %ymm0, (%rdi)
; AVX512DQ-NEXT:    vzeroupper
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: test_zero_v64i8_align1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512BW-NEXT:    vmovups %zmm0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  store <64 x i8> zeroinitializer, <64 x i8>* %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_v8f64_align16(<8 x double>* %dst) nounwind {
; SSE-LABEL: test_zero_v8f64_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8f64_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8f64_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x double> zeroinitializer, <8 x double>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v16f32_align16(<16 x float>* %dst) nounwind {
; SSE-LABEL: test_zero_v16f32_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16f32_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16f32_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x float> zeroinitializer, <16 x float>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v8i64_align16(<8 x i64>* %dst) nounwind {
; SSE-LABEL: test_zero_v8i64_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i64_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8i64_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x i64> zeroinitializer, <8 x i64>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v16i32_align16(<16 x i32>* %dst) nounwind {
; SSE-LABEL: test_zero_v16i32_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i32_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16i32_align16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x i32> zeroinitializer, <16 x i32>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v32i16_align16(<32 x i16>* %dst) nounwind {
; SSE-LABEL: test_zero_v32i16_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v32i16_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512DQ-LABEL: test_zero_v32i16_align16:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512DQ-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX512DQ-NEXT:    vmovups %ymm0, (%rdi)
; AVX512DQ-NEXT:    vzeroupper
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: test_zero_v32i16_align16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512BW-NEXT:    vmovups %zmm0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  store <32 x i16> zeroinitializer, <32 x i16>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v64i8_align16(<64 x i8>* %dst) nounwind {
; SSE-LABEL: test_zero_v64i8_align16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v64i8_align16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX-NEXT:    vmovups %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512DQ-LABEL: test_zero_v64i8_align16:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512DQ-NEXT:    vmovups %ymm0, 32(%rdi)
; AVX512DQ-NEXT:    vmovups %ymm0, (%rdi)
; AVX512DQ-NEXT:    vzeroupper
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: test_zero_v64i8_align16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512BW-NEXT:    vmovups %zmm0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  store <64 x i8> zeroinitializer, <64 x i8>* %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v8f64_align32(<8 x double>* %dst) nounwind {
; SSE-LABEL: test_zero_v8f64_align32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8f64_align32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8f64_align32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x double> zeroinitializer, <8 x double>* %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v16f32_align32(<16 x float>* %dst) nounwind {
; SSE-LABEL: test_zero_v16f32_align32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16f32_align32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16f32_align32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x float> zeroinitializer, <16 x float>* %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v8i64_align32(<8 x i64>* %dst) nounwind {
; SSE-LABEL: test_zero_v8i64_align32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i64_align32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v8i64_align32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <8 x i64> zeroinitializer, <8 x i64>* %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v16i32_align32(<16 x i32>* %dst) nounwind {
; SSE-LABEL: test_zero_v16i32_align32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i32_align32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_zero_v16i32_align32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovups %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  store <16 x i32> zeroinitializer, <16 x i32>* %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v32i16_align32(<32 x i16>* %dst) nounwind {
; SSE-LABEL: test_zero_v32i16_align32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v32i16_align32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512DQ-LABEL: test_zero_v32i16_align32:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512DQ-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX512DQ-NEXT:    vmovntps %ymm0, (%rdi)
; AVX512DQ-NEXT:    vzeroupper
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: test_zero_v32i16_align32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512BW-NEXT:    vmovups %zmm0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  store <32 x i16> zeroinitializer, <32 x i16>* %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v64i8_align32(<64 x i8>* %dst) nounwind {
; SSE-LABEL: test_zero_v64i8_align32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 48(%rdi)
; SSE-NEXT:    movntps %xmm0, 32(%rdi)
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v64i8_align32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512DQ-LABEL: test_zero_v64i8_align32:
; AVX512DQ:       # %bb.0:
; AVX512DQ-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512DQ-NEXT:    vmovntps %ymm0, 32(%rdi)
; AVX512DQ-NEXT:    vmovntps %ymm0, (%rdi)
; AVX512DQ-NEXT:    vzeroupper
; AVX512DQ-NEXT:    retq
;
; AVX512BW-LABEL: test_zero_v64i8_align32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512BW-NEXT:    vmovups %zmm0, (%rdi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  store <64 x i8> zeroinitializer, <64 x i8>* %dst, align 32, !nontemporal !1
  ret void
}

!1 = !{i32 1}
