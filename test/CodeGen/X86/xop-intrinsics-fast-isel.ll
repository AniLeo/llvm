; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i686-unknown-unknown -mattr=+avx,+fma4,+xop | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma4,+xop | FileCheck %s --check-prefixes=CHECK,X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/xop-builtins.c

define <2 x i64> @test_mm_maccs_epi16(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maccs_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacssww %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %arg2 = bitcast <2 x i64> %a2 to <8 x i16>
  %res = call <8 x i16> @llvm.x86.xop.vpmacssww(<8 x i16> %arg0, <8 x i16> %arg1, <8 x i16> %arg2)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.x86.xop.vpmacssww(<8 x i16>, <8 x i16>, <8 x i16>) nounwind readnone

define <2 x i64> @test_mm_macc_epi16(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_macc_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacsww %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %arg2 = bitcast <2 x i64> %a2 to <8 x i16>
  %res = call <8 x i16> @llvm.x86.xop.vpmacsww(<8 x i16> %arg0, <8 x i16> %arg1, <8 x i16> %arg2)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.x86.xop.vpmacsww(<8 x i16>, <8 x i16>, <8 x i16>) nounwind readnone

define <2 x i64> @test_mm_maccsd_epi16(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maccsd_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacsswd %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %arg2 = bitcast <2 x i64> %a2 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpmacsswd(<8 x i16> %arg0, <8 x i16> %arg1, <4 x i32> %arg2)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpmacsswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_maccd_epi16(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maccd_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacswd %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %arg2 = bitcast <2 x i64> %a2 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpmacswd(<8 x i16> %arg0, <8 x i16> %arg1, <4 x i32> %arg2)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpmacswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_maccs_epi32(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maccs_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacssdd %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %arg2 = bitcast <2 x i64> %a2 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpmacssdd(<4 x i32> %arg0, <4 x i32> %arg1, <4 x i32> %arg2)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpmacssdd(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_macc_epi32(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_macc_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacsdd %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %arg2 = bitcast <2 x i64> %a2 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpmacsdd(<4 x i32> %arg0, <4 x i32> %arg1, <4 x i32> %arg2)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpmacsdd(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_maccslo_epi32(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maccslo_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacssdql %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %res = call <2 x i64> @llvm.x86.xop.vpmacssdql(<4 x i32> %arg0, <4 x i32> %arg1, <2 x i64> %a2)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpmacssdql(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <2 x i64> @test_mm_macclo_epi32(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_macclo_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacsdql %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %res = call <2 x i64> @llvm.x86.xop.vpmacsdql(<4 x i32> %arg0, <4 x i32> %arg1, <2 x i64> %a2)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpmacsdql(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <2 x i64> @test_mm_maccshi_epi32(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maccshi_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacssdqh %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %res = call <2 x i64> @llvm.x86.xop.vpmacssdqh(<4 x i32> %arg0, <4 x i32> %arg1, <2 x i64> %a2)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpmacssdqh(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <2 x i64> @test_mm_macchi_epi32(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_macchi_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmacsdqh %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %res = call <2 x i64> @llvm.x86.xop.vpmacsdqh(<4 x i32> %arg0, <4 x i32> %arg1, <2 x i64> %a2)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpmacsdqh(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <2 x i64> @test_mm_maddsd_epi16(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maddsd_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmadcsswd %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %arg2 = bitcast <2 x i64> %a2 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpmadcsswd(<8 x i16> %arg0, <8 x i16> %arg1, <4 x i32> %arg2)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpmadcsswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_maddd_epi16(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) nounwind {
; CHECK-LABEL: test_mm_maddd_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmadcswd %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %arg2 = bitcast <2 x i64> %a2 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpmadcswd(<8 x i16> %arg0, <8 x i16> %arg1, <4 x i32> %arg2)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpmadcswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_haddw_epi8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddw_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddbw %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <8 x i16> @llvm.x86.xop.vphaddbw(<16 x i8> %arg0)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.x86.xop.vphaddbw(<16 x i8>) nounwind readnone

define <2 x i64> @test_mm_haddd_epi8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddd_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddbd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <4 x i32> @llvm.x86.xop.vphaddbd(<16 x i8> %arg0)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vphaddbd(<16 x i8>) nounwind readnone

define <2 x i64> @test_mm_haddq_epi8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddq_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddbq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <2 x i64> @llvm.x86.xop.vphaddbq(<16 x i8> %arg0)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vphaddbq(<16 x i8>) nounwind readnone

define <2 x i64> @test_mm_haddd_epi16(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddd_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddwd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <4 x i32> @llvm.x86.xop.vphaddwd(<8 x i16> %arg0)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vphaddwd(<8 x i16>) nounwind readnone

define <2 x i64> @test_mm_haddq_epi16(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddq_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddwq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <2 x i64> @llvm.x86.xop.vphaddwq(<8 x i16> %arg0)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vphaddwq(<8 x i16>) nounwind readnone

define <2 x i64> @test_mm_haddq_epi32(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddq_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphadddq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %res = call <2 x i64> @llvm.x86.xop.vphadddq(<4 x i32> %arg0)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vphadddq(<4 x i32>) nounwind readnone

define <2 x i64> @test_mm_haddw_epu8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddw_epu8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddubw %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <8 x i16> @llvm.x86.xop.vphaddubw(<16 x i8> %arg0)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.x86.xop.vphaddubw(<16 x i8>) nounwind readnone

define <2 x i64> @test_mm_haddd_epu8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddd_epu8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddubd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <4 x i32> @llvm.x86.xop.vphaddubd(<16 x i8> %arg0)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vphaddubd(<16 x i8>) nounwind readnone

define <2 x i64> @test_mm_haddq_epu8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddq_epu8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddubq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <2 x i64> @llvm.x86.xop.vphaddubq(<16 x i8> %arg0)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vphaddubq(<16 x i8>) nounwind readnone

define <2 x i64> @test_mm_haddd_epu16(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddd_epu16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphadduwd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <4 x i32> @llvm.x86.xop.vphadduwd(<8 x i16> %arg0)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vphadduwd(<8 x i16>) nounwind readnone


define <2 x i64> @test_mm_haddq_epu16(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddq_epu16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphadduwq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <2 x i64> @llvm.x86.xop.vphadduwq(<8 x i16> %arg0)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vphadduwq(<8 x i16>) nounwind readnone

define <2 x i64> @test_mm_haddq_epu32(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_haddq_epu32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphaddudq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %res = call <2 x i64> @llvm.x86.xop.vphaddudq(<4 x i32> %arg0)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vphaddudq(<4 x i32>) nounwind readnone

define <2 x i64> @test_mm_hsubw_epi8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_hsubw_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphsubbw %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <8 x i16> @llvm.x86.xop.vphsubbw(<16 x i8> %arg0)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.x86.xop.vphsubbw(<16 x i8>) nounwind readnone

define <2 x i64> @test_mm_hsubd_epi16(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_hsubd_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphsubwd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <4 x i32> @llvm.x86.xop.vphsubwd(<8 x i16> %arg0)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vphsubwd(<8 x i16>) nounwind readnone

define <2 x i64> @test_mm_hsubq_epi32(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_hsubq_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vphsubdq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %res = call <2 x i64> @llvm.x86.xop.vphsubdq(<4 x i32> %arg0)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vphsubdq(<4 x i32>) nounwind readnone

define <2 x i64> @test_mm_cmov_si128(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) {
; CHECK-LABEL: test_mm_cmov_si128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; CHECK-NEXT:    vpxor %xmm3, %xmm2, %xmm3
; CHECK-NEXT:    vpand %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpand %xmm3, %xmm1, %xmm1
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.xop.vpcmov(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcmov(<2 x i64>, <2 x i64>, <2 x i64>) nounwind readnone

define <4 x i64> @test_mm256_cmov_si256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> %a2) {
; CHECK-LABEL: test_mm256_cmov_si256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vxorps %xmm3, %xmm3, %xmm3
; CHECK-NEXT:    vcmptrueps %ymm3, %ymm3, %ymm3
; CHECK-NEXT:    vxorps %ymm3, %ymm2, %ymm3
; CHECK-NEXT:    vandps %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vandps %ymm3, %ymm1, %ymm1
; CHECK-NEXT:    vorps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x i64> @llvm.x86.xop.vpcmov.256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> %a2)
  ret <4 x i64> %res
}
declare <4 x i64> @llvm.x86.xop.vpcmov.256(<4 x i64>, <4 x i64>, <4 x i64>) nounwind readnone

define <2 x i64> @test_mm_perm_epi8(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) {
; CHECK-LABEL: test_mm_perm_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpperm %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call <16 x i8> @llvm.x86.xop.vpperm(<16 x i8> %arg0, <16 x i8> %arg1, <16 x i8> %arg2)
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <16 x i8> @llvm.x86.xop.vpperm(<16 x i8>, <16 x i8>, <16 x i8>) nounwind readnone

define <2 x i64> @test_mm_rot_epi8(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_rot_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call <16 x i8> @llvm.fshl.v16i8(<16 x i8> %arg0, <16 x i8> %arg0, <16 x i8> %arg1)
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <16 x i8> @llvm.fshl.v16i8(<16 x i8>, <16 x i8>, <16 x i8>) nounwind readnone

define <2 x i64> @test_mm_rot_epi16(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_rot_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %res = call <8 x i16> @llvm.fshl.v8i16(<8 x i16> %arg0, <8 x i16> %arg0, <8 x i16> %arg1)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.fshl.v8i16(<8 x i16>, <8 x i16>, <8 x i16>) nounwind readnone

define <2 x i64> @test_mm_rot_epi32(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_rot_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %res = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %arg0, <4 x i32> %arg0, <4 x i32> %arg1)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_rot_epi64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_rot_epi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.fshl.v2i64(<2 x i64> %a0, <2 x i64> %a0, <2 x i64> %a1)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.fshl.v2i64(<2 x i64>, <2 x i64>, <2 x i64>) nounwind readnone

define <2 x i64> @test_mm_roti_epi8(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_roti_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotb $1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res = call <16 x i8> @llvm.fshl.v16i8(<16 x i8> %arg0, <16 x i8> %arg0, <16 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>)
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_roti_epi16(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_roti_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotw $2, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <8 x i16> @llvm.fshl.v8i16(<8 x i16> %arg0, <8 x i16> %arg0, <8 x i16> <i16 50, i16 50, i16 50, i16 50, i16 50, i16 50, i16 50, i16 50>)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_roti_epi32(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_roti_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotd $2, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %res = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %arg0, <4 x i32> %arg0, <4 x i32> <i32 -30, i32 -30, i32 -30, i32 -30>)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_roti_epi64(<2 x i64> %a0) {
; CHECK-LABEL: test_mm_roti_epi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vprotq $36, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.fshl.v2i64(<2 x i64> %a0, <2 x i64> %a0, <2 x i64> <i64 100, i64 100>)
  ret <2 x i64> %res
}

define <2 x i64> @test_mm_shl_epi8(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_shl_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshlb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call <16 x i8> @llvm.x86.xop.vpshlb(<16 x i8> %arg0, <16 x i8> %arg1)
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <16 x i8> @llvm.x86.xop.vpshlb(<16 x i8>, <16 x i8>) nounwind readnone

define <2 x i64> @test_mm_shl_epi16(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_shl_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshlw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %res = call <8 x i16> @llvm.x86.xop.vpshlw(<8 x i16> %arg0, <8 x i16> %arg1)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.x86.xop.vpshlw(<8 x i16>, <8 x i16>) nounwind readnone

define <2 x i64> @test_mm_shl_epi32(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_shl_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshld %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpshld(<4 x i32> %arg0, <4 x i32> %arg1)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpshld(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_shl_epi64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_shl_epi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshlq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.xop.vpshlq(<2 x i64> %a0, <2 x i64> %a1)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpshlq(<2 x i64>, <2 x i64>) nounwind readnone

define <2 x i64> @test_mm_sha_epi8(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_sha_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshab %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call <16 x i8> @llvm.x86.xop.vpshab(<16 x i8> %arg0, <16 x i8> %arg1)
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <16 x i8> @llvm.x86.xop.vpshab(<16 x i8>, <16 x i8>) nounwind readnone

define <2 x i64> @test_mm_sha_epi16(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_sha_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshaw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %res = call <8 x i16> @llvm.x86.xop.vpshaw(<8 x i16> %arg0, <8 x i16> %arg1)
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <8 x i16> @llvm.x86.xop.vpshaw(<8 x i16>, <8 x i16>) nounwind readnone

define <2 x i64> @test_mm_sha_epi32(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_sha_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshad %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %res = call <4 x i32> @llvm.x86.xop.vpshad(<4 x i32> %arg0, <4 x i32> %arg1)
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <4 x i32> @llvm.x86.xop.vpshad(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_mm_sha_epi64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_sha_epi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshaq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.xop.vpshaq(<2 x i64> %a0, <2 x i64> %a1)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpshaq(<2 x i64>, <2 x i64>) nounwind readnone

define <2 x i64> @test_mm_com_epu8(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epu8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltub %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %cmp = icmp ult <16 x i8> %arg0, %arg1
  %res = sext <16 x i1> %cmp to <16 x i8>
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_com_epu16(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epu16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltuw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %cmp = icmp ult <8 x i16> %arg0, %arg1
  %res = sext <8 x i1> %cmp to <8 x i16>
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_com_epu32(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epu32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltud %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %cmp = icmp ult <4 x i32> %arg0, %arg1
  %res = sext <4 x i1> %cmp to <4 x i32>
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_com_epu64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epu64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltuq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %cmp = icmp ult <2 x i64> %a0, %a1
  %res = sext <2 x i1> %cmp to <2 x i64>
  ret <2 x i64> %res
}

define <2 x i64> @test_mm_com_epi8(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %cmp = icmp slt <16 x i8> %arg0, %arg1
  %res = sext <16 x i1> %cmp to <16 x i8>
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_com_epi16(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %cmp = icmp slt <8 x i16> %arg0, %arg1
  %res = sext <8 x i1> %cmp to <8 x i16>
  %bc = bitcast <8 x i16> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_com_epi32(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <4 x i32>
  %arg1 = bitcast <2 x i64> %a1 to <4 x i32>
  %cmp = icmp slt <4 x i32> %arg0, %arg1
  %res = sext <4 x i1> %cmp to <4 x i32>
  %bc = bitcast <4 x i32> %res to <2 x i64>
  ret <2 x i64> %bc
}

define <2 x i64> @test_mm_com_epi64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_mm_com_epi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcomltq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %cmp = icmp slt <2 x i64> %a0, %a1
  %res = sext <2 x i1> %cmp to <2 x i64>
  ret <2 x i64> %res
}

define <2 x double> @test_mm_permute2_pd(<2 x double> %a0, <2 x double> %a1, <2 x i64> %a2) {
; CHECK-LABEL: test_mm_permute2_pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermil2pd $0, %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double> %a0, <2 x double> %a1, <2 x i64> %a2, i8 0)
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double>, <2 x double>, <2 x i64>, i8) nounwind readnone

define <4 x double> @test_mm256_permute2_pd(<4 x double> %a0, <4 x double> %a1, <4 x i64> %a2) {
; CHECK-LABEL: test_mm256_permute2_pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermil2pd $0, %ymm2, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double> %a0, <4 x double> %a1, <4 x i64> %a2, i8 0)
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double>, <4 x double>, <4 x i64>, i8) nounwind readnone

define <4 x float> @test_mm_permute2_ps(<4 x float> %a0, <4 x float> %a1, <2 x i64> %a2) {
; CHECK-LABEL: test_mm_permute2_ps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermil2ps $0, %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg2 = bitcast <2 x i64> %a2 to <4 x i32>
  %res = call <4 x float> @llvm.x86.xop.vpermil2ps(<4 x float> %a0, <4 x float> %a1, <4 x i32> %arg2, i8 0)
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.xop.vpermil2ps(<4 x float>, <4 x float>, <4 x i32>, i8) nounwind readnone

define <8 x float> @test_mm256_permute2_ps(<8 x float> %a0, <8 x float> %a1, <4 x i64> %a2) {
; CHECK-LABEL: test_mm256_permute2_ps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermil2ps $0, %ymm2, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %arg2 = bitcast <4 x i64> %a2 to <8 x i32>
  %res = call <8 x float> @llvm.x86.xop.vpermil2ps.256(<8 x float> %a0, <8 x float> %a1, <8 x i32> %arg2, i8 0)
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.xop.vpermil2ps.256(<8 x float>, <8 x float>, <8 x i32>, i8) nounwind readnone

define <4 x float> @test_mm_frcz_ss(<4 x float> %a0) {
; CHECK-LABEL: test_mm_frcz_ss:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfrczss %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x float> @llvm.x86.xop.vfrcz.ss(<4 x float> %a0)
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.xop.vfrcz.ss(<4 x float>) nounwind readnone

define <2 x double> @test_mm_frcz_sd(<2 x double> %a0) {
; CHECK-LABEL: test_mm_frcz_sd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfrczsd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.xop.vfrcz.sd(<2 x double> %a0)
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.xop.vfrcz.sd(<2 x double>) nounwind readnone

define <4 x float> @test_mm_frcz_ps(<4 x float> %a0) {
; CHECK-LABEL: test_mm_frcz_ps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfrczps %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x float> @llvm.x86.xop.vfrcz.ps(<4 x float> %a0)
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.xop.vfrcz.ps(<4 x float>) nounwind readnone

define <2 x double> @test_mm_frcz_pd(<2 x double> %a0) {
; CHECK-LABEL: test_mm_frcz_pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfrczpd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.xop.vfrcz.pd(<2 x double> %a0)
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.xop.vfrcz.pd(<2 x double>) nounwind readnone

define <8 x float> @test_mm256_frcz_ps(<8 x float> %a0) {
; CHECK-LABEL: test_mm256_frcz_ps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfrczps %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x float> @llvm.x86.xop.vfrcz.ps.256(<8 x float> %a0)
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.xop.vfrcz.ps.256(<8 x float>) nounwind readnone

define <4 x double> @test_mm256_frcz_pd(<4 x double> %a0) {
; CHECK-LABEL: test_mm256_frcz_pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfrczpd %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.xop.vfrcz.pd.256(<4 x double> %a0)
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.xop.vfrcz.pd.256(<4 x double>) nounwind readnone
