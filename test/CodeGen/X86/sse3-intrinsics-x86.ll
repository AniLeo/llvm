; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=-avx,+sse3 -show-mc-encoding | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+avx2 -show-mc-encoding | FileCheck %s --check-prefix=CHECK --check-prefix=VCHECK --check-prefix=AVX2
; RUN: llc < %s -mtriple=i386-apple-darwin -mcpu=skx -show-mc-encoding | FileCheck %s --check-prefix=CHECK --check-prefix=VCHECK --check-prefix=SKX

define <2 x double> @test_x86_sse3_addsub_pd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse3_addsub_pd:
; SSE:       ## %bb.0:
; SSE-NEXT:    addsubpd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0xd0,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse3_addsub_pd:
; VCHECK:       ## %bb.0:
; VCHECK-NEXT:    vaddsubpd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xf9,0xd0,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double> %a0, <2 x double> %a1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double>, <2 x double>) nounwind readnone


define <4 x float> @test_x86_sse3_addsub_ps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse3_addsub_ps:
; SSE:       ## %bb.0:
; SSE-NEXT:    addsubps %xmm1, %xmm0 ## encoding: [0xf2,0x0f,0xd0,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse3_addsub_ps:
; VCHECK:       ## %bb.0:
; VCHECK-NEXT:    vaddsubps %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0xd0,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float>, <4 x float>) nounwind readnone


define <2 x double> @test_x86_sse3_hadd_pd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse3_hadd_pd:
; SSE:       ## %bb.0:
; SSE-NEXT:    haddpd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x7c,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse3_hadd_pd:
; VCHECK:       ## %bb.0:
; VCHECK-NEXT:    vhaddpd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xf9,0x7c,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double> %a0, <2 x double> %a1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double>, <2 x double>) nounwind readnone


define <4 x float> @test_x86_sse3_hadd_ps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse3_hadd_ps:
; SSE:       ## %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0 ## encoding: [0xf2,0x0f,0x7c,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse3_hadd_ps:
; VCHECK:       ## %bb.0:
; VCHECK-NEXT:    vhaddps %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x7c,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float>, <4 x float>) nounwind readnone


define <2 x double> @test_x86_sse3_hsub_pd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse3_hsub_pd:
; SSE:       ## %bb.0:
; SSE-NEXT:    hsubpd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x7d,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse3_hsub_pd:
; VCHECK:       ## %bb.0:
; VCHECK-NEXT:    vhsubpd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xf9,0x7d,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double> %a0, <2 x double> %a1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double>, <2 x double>) nounwind readnone


define <4 x float> @test_x86_sse3_hsub_ps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse3_hsub_ps:
; SSE:       ## %bb.0:
; SSE-NEXT:    hsubps %xmm1, %xmm0 ## encoding: [0xf2,0x0f,0x7d,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse3_hsub_ps:
; VCHECK:       ## %bb.0:
; VCHECK-NEXT:    vhsubps %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x7d,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float>, <4 x float>) nounwind readnone


define <16 x i8> @test_x86_sse3_ldu_dq(i8* %a0) {
; SSE-LABEL: test_x86_sse3_ldu_dq:
; SSE:       ## %bb.0:
; SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; SSE-NEXT:    lddqu (%eax), %xmm0 ## encoding: [0xf2,0x0f,0xf0,0x00]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse3_ldu_dq:
; VCHECK:       ## %bb.0:
; VCHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; VCHECK-NEXT:    vlddqu (%eax), %xmm0 ## encoding: [0xc5,0xfb,0xf0,0x00]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.sse3.ldu.dq(i8* %a0) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse3.ldu.dq(i8*) nounwind readonly

; Make sure instructions with no AVX equivalents, but are associated with SSEX feature flags still work

define void @monitor(i8* %P, i32 %E, i32 %H) nounwind {
; CHECK-LABEL: monitor:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edx ## encoding: [0x8b,0x54,0x24,0x0c]
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x08]
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; CHECK-NEXT:    leal (%eax), %eax ## encoding: [0x8d,0x00]
; CHECK-NEXT:    monitor ## encoding: [0x0f,0x01,0xc8]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  tail call void @llvm.x86.sse3.monitor(i8* %P, i32 %E, i32 %H)
  ret void
}
declare void @llvm.x86.sse3.monitor(i8*, i32, i32) nounwind

define void @mwait(i32 %E, i32 %H) nounwind {
; CHECK-LABEL: mwait:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x04]
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x08]
; CHECK-NEXT:    mwait ## encoding: [0x0f,0x01,0xc9]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  tail call void @llvm.x86.sse3.mwait(i32 %E, i32 %H)
  ret void
}
declare void @llvm.x86.sse3.mwait(i32, i32) nounwind
