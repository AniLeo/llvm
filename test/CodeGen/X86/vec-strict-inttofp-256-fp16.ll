; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=avx512fp16,avx512vl -O3 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512fp16,avx512vl -O3 | FileCheck %s --check-prefixes=CHECK,X64

declare <16 x half> @llvm.experimental.constrained.sitofp.v16f16.v16i1(<16 x i1>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.uitofp.v16f16.v16i1(<16 x i1>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.sitofp.v16f16.v16i8(<16 x i8>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.uitofp.v16f16.v16i8(<16 x i8>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.sitofp.v16f16.v16i16(<16 x i16>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.uitofp.v16f16.v16i16(<16 x i16>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i32(<8 x i32>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i32(<8 x i32>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.sitofp.v4f16.v4i64(<4 x i64>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.uitofp.v4f16.v4i64(<4 x i64>, metadata, metadata)

define <16 x half> @sitofp_v16i1_v16f16(<16 x i1> %x) #0 {
; CHECK-LABEL: sitofp_v16i1_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; CHECK-NEXT:    vpsllw $15, %ymm0, %ymm0
; CHECK-NEXT:    vpsraw $15, %ymm0, %ymm0
; CHECK-NEXT:    vcvtw2ph %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <16 x half> @llvm.experimental.constrained.sitofp.v16f16.v16i1(<16 x i1> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <16 x half> %result
}

define <16 x half> @uitofp_v16i1_v16f16(<16 x i1> %x) #0 {
; X86-LABEL: uitofp_v16i1_v16f16:
; X86:       # %bb.0:
; X86-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; X86-NEXT:    vcvtuw2ph %ymm0, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: uitofp_v16i1_v16f16:
; X64:       # %bb.0:
; X64-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; X64-NEXT:    vcvtuw2ph %ymm0, %ymm0
; X64-NEXT:    retq
 %result = call <16 x half> @llvm.experimental.constrained.uitofp.v16f16.v16i1(<16 x i1> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <16 x half> %result
}

define <16 x half> @sitofp_v16i8_v16f16(<16 x i8> %x) #0 {
; CHECK-LABEL: sitofp_v16i8_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbw %xmm0, %ymm0
; CHECK-NEXT:    vcvtw2ph %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <16 x half> @llvm.experimental.constrained.sitofp.v16f16.v16i8(<16 x i8> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <16 x half> %result
}

define <16 x half> @uitofp_v16i8_v16f16(<16 x i8> %x) #0 {
; CHECK-LABEL: uitofp_v16i8_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; CHECK-NEXT:    vcvtuw2ph %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <16 x half> @llvm.experimental.constrained.uitofp.v16f16.v16i8(<16 x i8> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <16 x half> %result
}

define <16 x half> @sitofp_v16i16_v16f16(<16 x i16> %x) #0 {
; CHECK-LABEL: sitofp_v16i16_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtw2ph %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <16 x half> @llvm.experimental.constrained.sitofp.v16f16.v16i16(<16 x i16> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <16 x half> %result
}

define <16 x half> @uitofp_v16i16_v16f16(<16 x i16> %x) #0 {
; CHECK-LABEL: uitofp_v16i16_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtuw2ph %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <16 x half> @llvm.experimental.constrained.uitofp.v16f16.v16i16(<16 x i16> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <16 x half> %result
}

define <8 x half> @sitofp_v8i32_v8f16(<8 x i32> %x) #0 {
; CHECK-LABEL: sitofp_v8i32_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtdq2ph %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i32(<8 x i32> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

define <8 x half> @uitofp_v8i32_v8f16(<8 x i32> %x) #0 {
; CHECK-LABEL: uitofp_v8i32_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtudq2ph %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i32(<8 x i32> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

define <4 x half> @sitofp_v4i64_v4f16(<4 x i64> %x) #0 {
; CHECK-LABEL: sitofp_v4i64_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtqq2ph %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <4 x half> @llvm.experimental.constrained.sitofp.v4f16.v4i64(<4 x i64> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <4 x half> %result
}

define <4 x half> @uitofp_v4i64_v4f16(<4 x i64> %x) #0 {
; CHECK-LABEL: uitofp_v4i64_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtuqq2ph %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <4 x half> @llvm.experimental.constrained.uitofp.v4f16.v4i64(<4 x i64> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <4 x half> %result
}

attributes #0 = { strictfp }
