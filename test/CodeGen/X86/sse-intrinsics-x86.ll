; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; NOTE: Assertions have been autogenerated by update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=-avx,+sse -show-mc-encoding | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+avx2 -show-mc-encoding | FileCheck %s --check-prefix=VCHECK --check-prefix=AVX2
; RUN: llc < %s -mtriple=i386-apple-darwin -mcpu=skx -show-mc-encoding | FileCheck %s --check-prefix=VCHECK --check-prefix=SKX

define <4 x float> @test_x86_sse_cmp_ps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_cmp_ps:
; SSE:       ## BB#0:
; SSE-NEXT:    cmpordps %xmm1, %xmm0 ## encoding: [0x0f,0xc2,0xc1,0x07]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_cmp_ps:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vcmpordps %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xf8,0xc2,0xc1,0x07]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %a0, <4 x float> %a1, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.cmp.ps(<4 x float>, <4 x float>, i8) nounwind readnone


define <4 x float> @test_x86_sse_cmp_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_cmp_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    cmpordss %xmm1, %xmm0 ## encoding: [0xf3,0x0f,0xc2,0xc1,0x07]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_cmp_ss:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vcmpordss %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0xc2,0xc1,0x07]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.cmp.ss(<4 x float> %a0, <4 x float> %a1, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.cmp.ss(<4 x float>, <4 x float>, i8) nounwind readnone


define i32 @test_x86_sse_comieq_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_comieq_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    comiss %xmm1, %xmm0 ## encoding: [0x0f,0x2f,0xc1]
; SSE-NEXT:    setnp %al ## encoding: [0x0f,0x9b,0xc0]
; SSE-NEXT:    sete %cl ## encoding: [0x0f,0x94,0xc1]
; SSE-NEXT:    andb %al, %cl ## encoding: [0x20,0xc1]
; SSE-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_comieq_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vcomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2f,0xc1]
; AVX2-NEXT:    setnp %al ## encoding: [0x0f,0x9b,0xc0]
; AVX2-NEXT:    sete %cl ## encoding: [0x0f,0x94,0xc1]
; AVX2-NEXT:    andb %al, %cl ## encoding: [0x20,0xc1]
; AVX2-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_comieq_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    vcomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2f,0xc1]
; SKX-NEXT:    setnp %al ## encoding: [0x0f,0x9b,0xc0]
; SKX-NEXT:    sete %cl ## encoding: [0x0f,0x94,0xc1]
; SKX-NEXT:    andb %al, %cl ## encoding: [0x20,0xc1]
; SKX-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.comieq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comieq.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comige_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_comige_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    comiss %xmm1, %xmm0 ## encoding: [0x0f,0x2f,0xc1]
; SSE-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_comige_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vcomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2f,0xc1]
; AVX2-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_comige_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vcomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2f,0xc1]
; SKX-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.comige.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comige.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comigt_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_comigt_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    comiss %xmm1, %xmm0 ## encoding: [0x0f,0x2f,0xc1]
; SSE-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_comigt_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vcomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2f,0xc1]
; AVX2-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_comigt_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vcomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2f,0xc1]
; SKX-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.comigt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comigt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comile_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_comile_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    comiss %xmm0, %xmm1 ## encoding: [0x0f,0x2f,0xc8]
; SSE-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_comile_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vcomiss %xmm0, %xmm1 ## encoding: [0xc5,0xf8,0x2f,0xc8]
; AVX2-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_comile_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vcomiss %xmm0, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2f,0xc8]
; SKX-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.comile.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comile.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comilt_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_comilt_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    comiss %xmm0, %xmm1 ## encoding: [0x0f,0x2f,0xc8]
; SSE-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_comilt_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vcomiss %xmm0, %xmm1 ## encoding: [0xc5,0xf8,0x2f,0xc8]
; AVX2-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_comilt_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vcomiss %xmm0, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2f,0xc8]
; SKX-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.comilt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comilt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comineq_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_comineq_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    comiss %xmm1, %xmm0 ## encoding: [0x0f,0x2f,0xc1]
; SSE-NEXT:    setp %al ## encoding: [0x0f,0x9a,0xc0]
; SSE-NEXT:    setne %cl ## encoding: [0x0f,0x95,0xc1]
; SSE-NEXT:    orb %al, %cl ## encoding: [0x08,0xc1]
; SSE-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_comineq_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vcomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2f,0xc1]
; AVX2-NEXT:    setp %al ## encoding: [0x0f,0x9a,0xc0]
; AVX2-NEXT:    setne %cl ## encoding: [0x0f,0x95,0xc1]
; AVX2-NEXT:    orb %al, %cl ## encoding: [0x08,0xc1]
; AVX2-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_comineq_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    vcomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2f,0xc1]
; SKX-NEXT:    setp %al ## encoding: [0x0f,0x9a,0xc0]
; SKX-NEXT:    setne %cl ## encoding: [0x0f,0x95,0xc1]
; SKX-NEXT:    orb %al, %cl ## encoding: [0x08,0xc1]
; SKX-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.comineq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comineq.ss(<4 x float>, <4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_cvtsi2ss(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_cvtsi2ss:
; SSE:       ## BB#0:
; SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; SSE-NEXT:    cvtsi2ssl %eax, %xmm0 ## encoding: [0xf3,0x0f,0x2a,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_cvtsi2ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; AVX2-NEXT:    vcvtsi2ssl %eax, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x2a,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_cvtsi2ss:
; SKX:       ## BB#0:
; SKX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; SKX-NEXT:    vcvtsi2ssl %eax, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x2a,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.cvtsi2ss(<4 x float> %a0, i32 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.cvtsi2ss(<4 x float>, i32) nounwind readnone


define i32 @test_x86_sse_cvtss2si(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_cvtss2si:
; SSE:       ## BB#0:
; SSE-NEXT:    cvtss2si %xmm0, %eax ## encoding: [0xf3,0x0f,0x2d,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_cvtss2si:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vcvtss2si %xmm0, %eax ## encoding: [0xc5,0xfa,0x2d,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_cvtss2si:
; SKX:       ## BB#0:
; SKX-NEXT:    vcvtss2si %xmm0, %eax ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x2d,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.cvtss2si(<4 x float> %a0) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.cvtss2si(<4 x float>) nounwind readnone


define i32 @test_x86_sse_cvttss2si(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_cvttss2si:
; SSE:       ## BB#0:
; SSE-NEXT:    cvttss2si %xmm0, %eax ## encoding: [0xf3,0x0f,0x2c,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_cvttss2si:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vcvttss2si %xmm0, %eax ## encoding: [0xc5,0xfa,0x2c,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_cvttss2si:
; SKX:       ## BB#0:
; SKX-NEXT:    vcvttss2si %xmm0, %eax ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x2c,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.cvttss2si(<4 x float> %a0) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.cvttss2si(<4 x float>) nounwind readnone


define void @test_x86_sse_ldmxcsr(i8* %a0) {
; SSE-LABEL: test_x86_sse_ldmxcsr:
; SSE:       ## BB#0:
; SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; SSE-NEXT:    ldmxcsr (%eax) ## encoding: [0x0f,0xae,0x10]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_ldmxcsr:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; VCHECK-NEXT:    vldmxcsr (%eax) ## encoding: [0xc5,0xf8,0xae,0x10]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  call void @llvm.x86.sse.ldmxcsr(i8* %a0)
  ret void
}
declare void @llvm.x86.sse.ldmxcsr(i8*) nounwind



define <4 x float> @test_x86_sse_max_ps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_max_ps:
; SSE:       ## BB#0:
; SSE-NEXT:    maxps %xmm1, %xmm0 ## encoding: [0x0f,0x5f,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_max_ps:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vmaxps %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xf8,0x5f,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_max_ps:
; SKX:       ## BB#0:
; SKX-NEXT:    vmaxps %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x5f,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.max.ps(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.max.ps(<4 x float>, <4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_max_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_max_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    maxss %xmm1, %xmm0 ## encoding: [0xf3,0x0f,0x5f,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_max_ss:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vmaxss %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x5f,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.max.ss(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.max.ss(<4 x float>, <4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_min_ps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_min_ps:
; SSE:       ## BB#0:
; SSE-NEXT:    minps %xmm1, %xmm0 ## encoding: [0x0f,0x5d,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_min_ps:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vminps %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xf8,0x5d,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_min_ps:
; SKX:       ## BB#0:
; SKX-NEXT:    vminps %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x5d,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.min.ps(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.min.ps(<4 x float>, <4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_min_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_min_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    minss %xmm1, %xmm0 ## encoding: [0xf3,0x0f,0x5d,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_min_ss:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vminss %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x5d,0xc1]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.min.ss(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.min.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_movmsk_ps(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_movmsk_ps:
; SSE:       ## BB#0:
; SSE-NEXT:    movmskps %xmm0, %eax ## encoding: [0x0f,0x50,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_movmsk_ps:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vmovmskps %xmm0, %eax ## encoding: [0xc5,0xf8,0x50,0xc0]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.movmsk.ps(<4 x float> %a0) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.movmsk.ps(<4 x float>) nounwind readnone



define <4 x float> @test_x86_sse_rcp_ps(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_rcp_ps:
; SSE:       ## BB#0:
; SSE-NEXT:    rcpps %xmm0, %xmm0 ## encoding: [0x0f,0x53,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_rcp_ps:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vrcpps %xmm0, %xmm0 ## encoding: [0xc5,0xf8,0x53,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_rcp_ps:
; SKX:       ## BB#0:
; SKX-NEXT:    vrcp14ps %xmm0, %xmm0 ## encoding: [0x62,0xf2,0x7d,0x08,0x4c,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rcp.ps(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_rcp_ss(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_rcp_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    rcpss %xmm0, %xmm0 ## encoding: [0xf3,0x0f,0x53,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_rcp_ss:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vrcpss %xmm0, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x53,0xc0]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.rcp.ss(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rcp.ss(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_rsqrt_ps(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_rsqrt_ps:
; SSE:       ## BB#0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm0 ## encoding: [0x0f,0x52,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_rsqrt_ps:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vrsqrtps %xmm0, %xmm0 ## encoding: [0xc5,0xf8,0x52,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_rsqrt_ps:
; SKX:       ## BB#0:
; SKX-NEXT:    vrsqrt14ps %xmm0, %xmm0 ## encoding: [0x62,0xf2,0x7d,0x08,0x4e,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_rsqrt_ss(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_rsqrt_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm0 ## encoding: [0xf3,0x0f,0x52,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_rsqrt_ss:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x52,0xc0]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_sqrt_ps(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_sqrt_ps:
; SSE:       ## BB#0:
; SSE-NEXT:    sqrtps %xmm0, %xmm0 ## encoding: [0x0f,0x51,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_sqrt_ps:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vsqrtps %xmm0, %xmm0 ## encoding: [0xc5,0xf8,0x51,0xc0]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.sqrt.ps(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.sqrt.ps(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_sqrt_ss(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse_sqrt_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    sqrtss %xmm0, %xmm0 ## encoding: [0xf3,0x0f,0x51,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_sqrt_ss:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x51,0xc0]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float>) nounwind readnone


define void @test_x86_sse_stmxcsr(i8* %a0) {
; SSE-LABEL: test_x86_sse_stmxcsr:
; SSE:       ## BB#0:
; SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; SSE-NEXT:    stmxcsr (%eax) ## encoding: [0x0f,0xae,0x18]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: test_x86_sse_stmxcsr:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; VCHECK-NEXT:    vstmxcsr (%eax) ## encoding: [0xc5,0xf8,0xae,0x18]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  call void @llvm.x86.sse.stmxcsr(i8* %a0)
  ret void
}
declare void @llvm.x86.sse.stmxcsr(i8*) nounwind


define i32 @test_x86_sse_ucomieq_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_ucomieq_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    ucomiss %xmm1, %xmm0 ## encoding: [0x0f,0x2e,0xc1]
; SSE-NEXT:    setnp %al ## encoding: [0x0f,0x9b,0xc0]
; SSE-NEXT:    sete %cl ## encoding: [0x0f,0x94,0xc1]
; SSE-NEXT:    andb %al, %cl ## encoding: [0x20,0xc1]
; SSE-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_ucomieq_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vucomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2e,0xc1]
; AVX2-NEXT:    setnp %al ## encoding: [0x0f,0x9b,0xc0]
; AVX2-NEXT:    sete %cl ## encoding: [0x0f,0x94,0xc1]
; AVX2-NEXT:    andb %al, %cl ## encoding: [0x20,0xc1]
; AVX2-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_ucomieq_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    vucomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2e,0xc1]
; SKX-NEXT:    setnp %al ## encoding: [0x0f,0x9b,0xc0]
; SKX-NEXT:    sete %cl ## encoding: [0x0f,0x94,0xc1]
; SKX-NEXT:    andb %al, %cl ## encoding: [0x20,0xc1]
; SKX-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.ucomieq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomieq.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomige_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_ucomige_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    ucomiss %xmm1, %xmm0 ## encoding: [0x0f,0x2e,0xc1]
; SSE-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_ucomige_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vucomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2e,0xc1]
; AVX2-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_ucomige_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vucomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2e,0xc1]
; SKX-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.ucomige.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomige.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomigt_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_ucomigt_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    ucomiss %xmm1, %xmm0 ## encoding: [0x0f,0x2e,0xc1]
; SSE-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_ucomigt_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vucomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2e,0xc1]
; AVX2-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_ucomigt_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vucomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2e,0xc1]
; SKX-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.ucomigt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomigt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomile_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_ucomile_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    ucomiss %xmm0, %xmm1 ## encoding: [0x0f,0x2e,0xc8]
; SSE-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_ucomile_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vucomiss %xmm0, %xmm1 ## encoding: [0xc5,0xf8,0x2e,0xc8]
; AVX2-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_ucomile_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vucomiss %xmm0, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2e,0xc8]
; SKX-NEXT:    setae %al ## encoding: [0x0f,0x93,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.ucomile.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomile.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomilt_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_ucomilt_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    ucomiss %xmm0, %xmm1 ## encoding: [0x0f,0x2e,0xc8]
; SSE-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_ucomilt_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX2-NEXT:    vucomiss %xmm0, %xmm1 ## encoding: [0xc5,0xf8,0x2e,0xc8]
; AVX2-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_ucomilt_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SKX-NEXT:    vucomiss %xmm0, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2e,0xc8]
; SKX-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.ucomilt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomilt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomineq_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse_ucomineq_ss:
; SSE:       ## BB#0:
; SSE-NEXT:    ucomiss %xmm1, %xmm0 ## encoding: [0x0f,0x2e,0xc1]
; SSE-NEXT:    setp %al ## encoding: [0x0f,0x9a,0xc0]
; SSE-NEXT:    setne %cl ## encoding: [0x0f,0x95,0xc1]
; SSE-NEXT:    orb %al, %cl ## encoding: [0x08,0xc1]
; SSE-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse_ucomineq_ss:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vucomiss %xmm1, %xmm0 ## encoding: [0xc5,0xf8,0x2e,0xc1]
; AVX2-NEXT:    setp %al ## encoding: [0x0f,0x9a,0xc0]
; AVX2-NEXT:    setne %cl ## encoding: [0x0f,0x95,0xc1]
; AVX2-NEXT:    orb %al, %cl ## encoding: [0x08,0xc1]
; AVX2-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse_ucomineq_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    vucomiss %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x2e,0xc1]
; SKX-NEXT:    setp %al ## encoding: [0x0f,0x9a,0xc0]
; SKX-NEXT:    setne %cl ## encoding: [0x0f,0x95,0xc1]
; SKX-NEXT:    orb %al, %cl ## encoding: [0x08,0xc1]
; SKX-NEXT:    movzbl %cl, %eax ## encoding: [0x0f,0xb6,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse.ucomineq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomineq.ss(<4 x float>, <4 x float>) nounwind readnone


define void @sfence() nounwind {
; SSE-LABEL: sfence:
; SSE:       ## BB#0:
; SSE-NEXT:    sfence ## encoding: [0x0f,0xae,0xf8]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; VCHECK-LABEL: sfence:
; VCHECK:       ## BB#0:
; VCHECK-NEXT:    sfence ## encoding: [0x0f,0xae,0xf8]
; VCHECK-NEXT:    retl ## encoding: [0xc3]
  tail call void @llvm.x86.sse.sfence()
  ret void
}
declare void @llvm.x86.sse.sfence() nounwind
