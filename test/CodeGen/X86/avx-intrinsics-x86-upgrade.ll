; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=X64

; We don't check any vinsertf128 variant with immediate 0 because that's just a blend.

define <4 x double> @test_x86_avx_vinsertf128_pd_256_1(<4 x double> %a0, <2 x double> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_pd_256_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.avx.vinsertf128.pd.256(<4 x double> %a0, <2 x double> %a1, i8 1)
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.vinsertf128.pd.256(<4 x double>, <2 x double>, i8) nounwind readnone

define <8 x float> @test_x86_avx_vinsertf128_ps_256_1(<8 x float> %a0, <4 x float> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_ps_256_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x float> @llvm.x86.avx.vinsertf128.ps.256(<8 x float> %a0, <4 x float> %a1, i8 1)
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.vinsertf128.ps.256(<8 x float>, <4 x float>, i8) nounwind readnone

define <8 x i32> @test_x86_avx_vinsertf128_si_256_1(<8 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_si_256_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x i32> @llvm.x86.avx.vinsertf128.si.256(<8 x i32> %a0, <4 x i32> %a1, i8 1)
  ret <8 x i32> %res
}

; Verify that high bits of the immediate are masked off. This should be the equivalent
; of a vinsertf128 $0 which should be optimized into a blend, so just check that it's
; not a vinsertf128 $1.
define <8 x i32> @test_x86_avx_vinsertf128_si_256_2(<8 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_si_256_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm1 killed $xmm1 def $ymm1
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x i32> @llvm.x86.avx.vinsertf128.si.256(<8 x i32> %a0, <4 x i32> %a1, i8 2)
  ret <8 x i32> %res
}
declare <8 x i32> @llvm.x86.avx.vinsertf128.si.256(<8 x i32>, <4 x i32>, i8) nounwind readnone

; We don't check any vextractf128 variant with immediate 0 because that's just a move.

define <2 x double> @test_x86_avx_vextractf128_pd_256_1(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_vextractf128_pd_256_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double> %a0, i8 1)
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double>, i8) nounwind readnone

define <4 x float> @test_x86_avx_vextractf128_ps_256_1(<8 x float> %a0) {
; CHECK-LABEL: test_x86_avx_vextractf128_ps_256_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float> %a0, i8 1)
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float>, i8) nounwind readnone

define <4 x i32> @test_x86_avx_vextractf128_si_256_1(<8 x i32> %a0) {
; CHECK-LABEL: test_x86_avx_vextractf128_si_256_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32> %a0, i8 1)
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32>, i8) nounwind readnone

; Verify that high bits of the immediate are masked off. This should be the equivalent
; of a vextractf128 $0 which should be optimized away, so just check that it's
; not a vextractf128 of any kind.
define <2 x double> @test_x86_avx_extractf128_pd_256_2(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_extractf128_pd_256_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double> %a0, i8 2)
  ret <2 x double> %res
}


define <4 x double> @test_x86_avx_vbroadcastf128_pd_256(i8* %a0) {
; X86-LABEL: test_x86_avx_vbroadcastf128_pd_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_avx_vbroadcastf128_pd_256:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.avx.vbroadcastf128.pd.256(i8* %a0) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.vbroadcastf128.pd.256(i8*) nounwind readonly


define <8 x float> @test_x86_avx_vbroadcastf128_ps_256(i8* %a0) {
; X86-LABEL: test_x86_avx_vbroadcastf128_ps_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_avx_vbroadcastf128_ps_256:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; X64-NEXT:    ret{{[l|q]}}
  %res = call <8 x float> @llvm.x86.avx.vbroadcastf128.ps.256(i8* %a0) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.vbroadcastf128.ps.256(i8*) nounwind readonly


define <4 x double> @test_x86_avx_blend_pd_256(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: test_x86_avx_blend_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3,4,5],ymm0[6,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double> %a0, <4 x double> %a1, i32 7) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double>, <4 x double>, i32) nounwind readnone


define <8 x float> @test_x86_avx_blend_ps_256(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: test_x86_avx_blend_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2],ymm0[3,4,5,6,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float> %a0, <8 x float> %a1, i32 7) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float>, <8 x float>, i32) nounwind readnone


define <8 x float> @test_x86_avx_dp_ps_256(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: test_x86_avx_dp_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vdpps $7, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x float> @llvm.x86.avx.dp.ps.256(<8 x float> %a0, <8 x float> %a1, i32 7) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.dp.ps.256(<8 x float>, <8 x float>, i32) nounwind readnone


define <2 x i64> @test_x86_sse2_psll_dq(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psll_dq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpslldq {{.*#+}} xmm0 = zero,xmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse2.psll.dq(<2 x i64> %a0, i32 8) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psll.dq(<2 x i64>, i32) nounwind readnone


define <2 x i64> @test_x86_sse2_psrl_dq(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psrl_dq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrldq {{.*#+}} xmm0 = xmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse2.psrl.dq(<2 x i64> %a0, i32 8) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psrl.dq(<2 x i64>, i32) nounwind readnone


define <2 x double> @test_x86_sse41_blendpd(<2 x double> %a0, <2 x double> %a1) {
; CHECK-LABEL: test_x86_sse41_blendpd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.sse41.blendpd(<2 x double> %a0, <2 x double> %a1, i8 2) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse41.blendpd(<2 x double>, <2 x double>, i8) nounwind readnone


define <4 x float> @test_x86_sse41_blendps(<4 x float> %a0, <4 x float> %a1) {
; CHECK-LABEL: test_x86_sse41_blendps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1,2],xmm0[3]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x float> @llvm.x86.sse41.blendps(<4 x float> %a0, <4 x float> %a1, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse41.blendps(<4 x float>, <4 x float>, i8) nounwind readnone


define <8 x i16> @test_x86_sse41_pblendw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_x86_sse41_pblendw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1,2],xmm0[3,4,5,6,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x i16> @llvm.x86.sse41.pblendw(<8 x i16> %a0, <8 x i16> %a1, i8 7) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pblendw(<8 x i16>, <8 x i16>, i8) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovsxbd(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxbd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x i32> @llvm.x86.sse41.pmovsxbd(<16 x i8> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovsxbd(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovsxbq(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxbq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse41.pmovsxbq(<16 x i8> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovsxbq(<16 x i8>) nounwind readnone


define <8 x i16> @test_x86_sse41_pmovsxbw(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxbw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbw %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x i16> @llvm.x86.sse41.pmovsxbw(<16 x i8> %a0) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pmovsxbw(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovsxdq(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxdq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxdq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse41.pmovsxdq(<4 x i32> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovsxdq(<4 x i32>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovsxwd(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxwd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxwd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x i32> @llvm.x86.sse41.pmovsxwd(<8 x i16> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovsxwd(<8 x i16>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovsxwq(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxwq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxwq %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse41.pmovsxwq(<8 x i16> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovsxwq(<8 x i16>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovzxbd(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxbd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x i32> @llvm.x86.sse41.pmovzxbd(<16 x i8> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovzxbd(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovzxbq(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxbq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxbq {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,zero,zero,zero,zero,xmm0[1],zero,zero,zero,zero,zero,zero,zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse41.pmovzxbq(<16 x i8> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovzxbq(<16 x i8>) nounwind readnone


define <8 x i16> @test_x86_sse41_pmovzxbw(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxbw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x i16> @llvm.x86.sse41.pmovzxbw(<16 x i8> %a0) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pmovzxbw(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovzxdq(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxdq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse41.pmovzxdq(<4 x i32> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovzxdq(<4 x i32>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovzxwd(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxwd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x i32> @llvm.x86.sse41.pmovzxwd(<8 x i16> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovzxwd(<8 x i16>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovzxwq(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxwq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxwq {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse41.pmovzxwq(<8 x i16> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovzxwq(<8 x i16>) nounwind readnone


define <2 x double> @test_x86_sse2_cvtdq2pd(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_sse2_cvtdq2pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtdq2pd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.sse2.cvtdq2pd(<4 x i32> %a0) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.cvtdq2pd(<4 x i32>) nounwind readnone


define <4 x double> @test_x86_avx_cvtdq2_pd_256(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_avx_cvtdq2_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtdq2pd %xmm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.avx.cvtdq2.pd.256(<4 x i32> %a0) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.cvtdq2.pd.256(<4 x i32>) nounwind readnone


define <2 x double> @test_x86_sse2_cvtps2pd(<4 x float> %a0) {
; CHECK-LABEL: test_x86_sse2_cvtps2pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtps2pd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.sse2.cvtps2pd(<4 x float> %a0) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.cvtps2pd(<4 x float>) nounwind readnone


define <4 x double> @test_x86_avx_cvt_ps2_pd_256(<4 x float> %a0) {
; CHECK-LABEL: test_x86_avx_cvt_ps2_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtps2pd %xmm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.avx.cvt.ps2.pd.256(<4 x float> %a0) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.cvt.ps2.pd.256(<4 x float>) nounwind readnone


define void @test_x86_sse2_storeu_dq(i8* %a0, <16 x i8> %a1) {
  ; add operation forces the execution domain.
; X86-LABEL: test_x86_sse2_storeu_dq:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; X86-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovdqu %xmm0, (%eax)
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_sse2_storeu_dq:
; X64:       # %bb.0:
; X64-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; X64-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; X64-NEXT:    vmovdqu %xmm0, (%rdi)
; X64-NEXT:    ret{{[l|q]}}
  %a2 = add <16 x i8> %a1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  call void @llvm.x86.sse2.storeu.dq(i8* %a0, <16 x i8> %a2)
  ret void
}
declare void @llvm.x86.sse2.storeu.dq(i8*, <16 x i8>) nounwind


define void @test_x86_sse2_storeu_pd(i8* %a0, <2 x double> %a1) {
  ; fadd operation forces the execution domain.
; X86-LABEL: test_x86_sse2_storeu_pd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X86-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; X86-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovupd %xmm0, (%eax)
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_sse2_storeu_pd:
; X64:       # %bb.0:
; X64-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X64-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; X64-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vmovupd %xmm0, (%rdi)
; X64-NEXT:    ret{{[l|q]}}
  %a2 = fadd <2 x double> %a1, <double 0x0, double 0x4200000000000000>
  call void @llvm.x86.sse2.storeu.pd(i8* %a0, <2 x double> %a2)
  ret void
}
declare void @llvm.x86.sse2.storeu.pd(i8*, <2 x double>) nounwind


define void @test_x86_sse_storeu_ps(i8* %a0, <4 x float> %a1) {
; X86-LABEL: test_x86_sse_storeu_ps:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovups %xmm0, (%eax)
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_sse_storeu_ps:
; X64:       # %bb.0:
; X64-NEXT:    vmovups %xmm0, (%rdi)
; X64-NEXT:    ret{{[l|q]}}
  call void @llvm.x86.sse.storeu.ps(i8* %a0, <4 x float> %a1)
  ret void
}
declare void @llvm.x86.sse.storeu.ps(i8*, <4 x float>) nounwind


define void @test_x86_avx_storeu_dq_256(i8* %a0, <32 x i8> %a1) {
  ; FIXME: unfortunately the execution domain fix pass changes this to vmovups and its hard to force with no 256-bit integer instructions
  ; add operation forces the execution domain.
; X86-LABEL: test_x86_avx_storeu_dq_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; X86-NEXT:    vpsubb %xmm2, %xmm1, %xmm1
; X86-NEXT:    vpsubb %xmm2, %xmm0, %xmm0
; X86-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X86-NEXT:    vmovups %ymm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_avx_storeu_dq_256:
; X64:       # %bb.0:
; X64-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; X64-NEXT:    vpsubb %xmm2, %xmm1, %xmm1
; X64-NEXT:    vpsubb %xmm2, %xmm0, %xmm0
; X64-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X64-NEXT:    vmovups %ymm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    ret{{[l|q]}}
  %a2 = add <32 x i8> %a1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  call void @llvm.x86.avx.storeu.dq.256(i8* %a0, <32 x i8> %a2)
  ret void
}
declare void @llvm.x86.avx.storeu.dq.256(i8*, <32 x i8>) nounwind


define void @test_x86_avx_storeu_pd_256(i8* %a0, <4 x double> %a1) {
  ; add operation forces the execution domain.
; X86-LABEL: test_x86_avx_storeu_pd_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X86-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X86-NEXT:    vmovupd %ymm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_avx_storeu_pd_256:
; X64:       # %bb.0:
; X64-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X64-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vmovupd %ymm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    ret{{[l|q]}}
  %a2 = fadd <4 x double> %a1, <double 0x0, double 0x0, double 0x0, double 0x0>
  call void @llvm.x86.avx.storeu.pd.256(i8* %a0, <4 x double> %a2)
  ret void
}
declare void @llvm.x86.avx.storeu.pd.256(i8*, <4 x double>) nounwind


define void @test_x86_avx_storeu_ps_256(i8* %a0, <8 x float> %a1) {
; X86-LABEL: test_x86_avx_storeu_ps_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovups %ymm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    ret{{[l|q]}}
;
; X64-LABEL: test_x86_avx_storeu_ps_256:
; X64:       # %bb.0:
; X64-NEXT:    vmovups %ymm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    ret{{[l|q]}}
  call void @llvm.x86.avx.storeu.ps.256(i8* %a0, <8 x float> %a1)
  ret void
}
declare void @llvm.x86.avx.storeu.ps.256(i8*, <8 x float>) nounwind


define <2 x double> @test_x86_avx_vpermil_pd(<2 x double> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.x86.avx.vpermil.pd(<2 x double> %a0, i8 1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.avx.vpermil.pd(<2 x double>, i8) nounwind readnone


define <4 x double> @test_x86_avx_vpermil_pd_256(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[1,1,3,2]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.avx.vpermil.pd.256(<4 x double> %a0, i8 7) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.vpermil.pd.256(<4 x double>, i8) nounwind readnone


define <4 x float> @test_x86_avx_vpermil_ps(<4 x float> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_ps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,0,0]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x float> @llvm.x86.avx.vpermil.ps(<4 x float> %a0, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.avx.vpermil.ps(<4 x float>, i8) nounwind readnone


define <8 x float> @test_x86_avx_vpermil_ps_256(<8 x float> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[3,1,0,0,7,5,4,4]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x float> @llvm.x86.avx.vpermil.ps.256(<8 x float> %a0, i8 7) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.vpermil.ps.256(<8 x float>, i8) nounwind readnone


define <4 x double> @test_x86_avx_vperm2f128_pd_256(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: test_x86_avx_vperm2f128_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm1[2,3],ymm0[0,1]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <4 x double> @llvm.x86.avx.vperm2f128.pd.256(<4 x double> %a0, <4 x double> %a1, i8 3) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.vperm2f128.pd.256(<4 x double>, <4 x double>, i8) nounwind readnone


define <8 x float> @test_x86_avx_vperm2f128_ps_256(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: test_x86_avx_vperm2f128_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm1[2,3],ymm0[0,1]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x float> @llvm.x86.avx.vperm2f128.ps.256(<8 x float> %a0, <8 x float> %a1, i8 3) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.vperm2f128.ps.256(<8 x float>, <8 x float>, i8) nounwind readnone


define <8 x i32> @test_x86_avx_vperm2f128_si_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: test_x86_avx_vperm2f128_si_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm1[2,3],ymm0[0,1]
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <8 x i32> @llvm.x86.avx.vperm2f128.si.256(<8 x i32> %a0, <8 x i32> %a1, i8 3) ; <<8 x i32>> [#uses=1]
  ret <8 x i32> %res
}
declare <8 x i32> @llvm.x86.avx.vperm2f128.si.256(<8 x i32>, <8 x i32>, i8) nounwind readnone
