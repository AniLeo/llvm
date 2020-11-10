; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu -mattr=+avx512f,+avx512vl,+vpclmulqdq -show-mc-encoding | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+avx512vl,+vpclmulqdq -show-mc-encoding | FileCheck %s

define <2 x i64> @test_x86_pclmulqdq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_x86_pclmulqdq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpclmulqdq $1, %xmm1, %xmm0, %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x44,0xc1,0x01]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %res = call <2 x i64> @llvm.x86.pclmulqdq(<2 x i64> %a0, <2 x i64> %a1, i8 1)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.pclmulqdq(<2 x i64>, <2 x i64>, i8) nounwind readnone

define <4 x i64> @test_x86_pclmulqdq_256(<4 x i64> %a0, <4 x i64> %a1) {
; CHECK-LABEL: test_x86_pclmulqdq_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpclmulqdq $16, %ymm1, %ymm0, %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe3,0x7d,0x44,0xc1,0x10]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %res = call <4 x i64> @llvm.x86.pclmulqdq.256(<4 x i64> %a0, <4 x i64> %a1, i8 16)
  ret <4 x i64> %res
}
declare <4 x i64> @llvm.x86.pclmulqdq.256(<4 x i64>, <4 x i64>, i8) nounwind readnone
