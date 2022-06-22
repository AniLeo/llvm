; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+avx,+f16c -show-mc-encoding -disable-peephole | FileCheck %s --check-prefixes=AVX,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+f16c -show-mc-encoding -disable-peephole | FileCheck %s --check-prefixes=AVX,X64
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+avx512vl -show-mc-encoding -disable-peephole | FileCheck %s --check-prefixes=AVX512VL,X86-AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl -show-mc-encoding -disable-peephole | FileCheck %s --check-prefixes=AVX512VL,X64-AVX512VL

define <4 x float> @test_x86_vcvtph2ps_128(<8 x i16> %a0) {
; AVX-LABEL: test_x86_vcvtph2ps_128:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0x13,0xc0]
; AVX-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
;
; AVX512VL-LABEL: test_x86_vcvtph2ps_128:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vcvtph2ps %xmm0, %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x13,0xc0]
; AVX512VL-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16>) nounwind readonly

define <4 x float> @test_x86_vcvtph2ps_128_m(ptr nocapture %a) {
; X86-LABEL: test_x86_vcvtph2ps_128_m:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vcvtph2ps (%eax), %xmm0 # encoding: [0xc4,0xe2,0x79,0x13,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_x86_vcvtph2ps_128_m:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2ps (%rdi), %xmm0 # encoding: [0xc4,0xe2,0x79,0x13,0x07]
; X64-NEXT:    retq # encoding: [0xc3]
;
; X86-AVX512VL-LABEL: test_x86_vcvtph2ps_128_m:
; X86-AVX512VL:       # %bb.0:
; X86-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX512VL-NEXT:    vcvtph2ps (%eax), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x13,0x00]
; X86-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: test_x86_vcvtph2ps_128_m:
; X64-AVX512VL:       # %bb.0:
; X64-AVX512VL-NEXT:    vcvtph2ps (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x13,0x07]
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
  %load = load <8 x i16>, ptr %a
  %res = call <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16> %load) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}

define <8 x float> @test_x86_vcvtph2ps_256(<8 x i16> %a0) {
; AVX-LABEL: test_x86_vcvtph2ps_256:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtph2ps %xmm0, %ymm0 # encoding: [0xc4,0xe2,0x7d,0x13,0xc0]
; AVX-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
;
; AVX512VL-LABEL: test_x86_vcvtph2ps_256:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vcvtph2ps %xmm0, %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x13,0xc0]
; AVX512VL-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %res = call <8 x float> @llvm.x86.vcvtph2ps.256(<8 x i16> %a0) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.vcvtph2ps.256(<8 x i16>) nounwind readonly

define <8 x float> @test_x86_vcvtph2ps_256_m(ptr nocapture %a) nounwind {
; X86-LABEL: test_x86_vcvtph2ps_256_m:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vcvtph2ps (%eax), %ymm0 # encoding: [0xc4,0xe2,0x7d,0x13,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_x86_vcvtph2ps_256_m:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2ps (%rdi), %ymm0 # encoding: [0xc4,0xe2,0x7d,0x13,0x07]
; X64-NEXT:    retq # encoding: [0xc3]
;
; X86-AVX512VL-LABEL: test_x86_vcvtph2ps_256_m:
; X86-AVX512VL:       # %bb.0:
; X86-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX512VL-NEXT:    vcvtph2ps (%eax), %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x13,0x00]
; X86-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: test_x86_vcvtph2ps_256_m:
; X64-AVX512VL:       # %bb.0:
; X64-AVX512VL-NEXT:    vcvtph2ps (%rdi), %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x13,0x07]
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
  %load = load <8 x i16>, ptr %a
  %res = tail call <8 x float> @llvm.x86.vcvtph2ps.256(<8 x i16> %load)
  ret <8 x float> %res
}

define <4 x float> @test_x86_vcvtph2ps_128_scalar(ptr %ptr) {
; X86-LABEL: test_x86_vcvtph2ps_128_scalar:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vcvtph2ps (%eax), %xmm0 # encoding: [0xc4,0xe2,0x79,0x13,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_x86_vcvtph2ps_128_scalar:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2ps (%rdi), %xmm0 # encoding: [0xc4,0xe2,0x79,0x13,0x07]
; X64-NEXT:    retq # encoding: [0xc3]
;
; X86-AVX512VL-LABEL: test_x86_vcvtph2ps_128_scalar:
; X86-AVX512VL:       # %bb.0:
; X86-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX512VL-NEXT:    vcvtph2ps (%eax), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x13,0x00]
; X86-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: test_x86_vcvtph2ps_128_scalar:
; X64-AVX512VL:       # %bb.0:
; X64-AVX512VL-NEXT:    vcvtph2ps (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x13,0x07]
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
  %load = load i64, ptr %ptr
  %ins1 = insertelement <2 x i64> undef, i64 %load, i32 0
  %ins2 = insertelement <2 x i64> %ins1, i64 0, i32 1
  %bc = bitcast <2 x i64> %ins2 to <8 x i16>
  %res = tail call <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16> %bc) #2
  ret <4 x float> %res
}

define <4 x float> @test_x86_vcvtph2ps_128_scalar2(ptr %ptr) {
; X86-LABEL: test_x86_vcvtph2ps_128_scalar2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vcvtph2ps (%eax), %xmm0 # encoding: [0xc4,0xe2,0x79,0x13,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_x86_vcvtph2ps_128_scalar2:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2ps (%rdi), %xmm0 # encoding: [0xc4,0xe2,0x79,0x13,0x07]
; X64-NEXT:    retq # encoding: [0xc3]
;
; X86-AVX512VL-LABEL: test_x86_vcvtph2ps_128_scalar2:
; X86-AVX512VL:       # %bb.0:
; X86-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX512VL-NEXT:    vcvtph2ps (%eax), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x13,0x00]
; X86-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: test_x86_vcvtph2ps_128_scalar2:
; X64-AVX512VL:       # %bb.0:
; X64-AVX512VL-NEXT:    vcvtph2ps (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x13,0x07]
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
  %load = load i64, ptr %ptr
  %ins = insertelement <2 x i64> undef, i64 %load, i32 0
  %bc = bitcast <2 x i64> %ins to <8 x i16>
  %res = tail call <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16> %bc)
  ret <4 x float> %res
}
