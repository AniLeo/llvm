; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=avx | FileCheck %s

; We don't check any vinsertf128 variant with immediate 0 because that's just a blend.

define <4 x double> @test_x86_avx_vinsertf128_pd_256_1(<4 x double> %a0, <2 x double> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_pd_256_1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    retl
  %res = call <4 x double> @llvm.x86.avx.vinsertf128.pd.256(<4 x double> %a0, <2 x double> %a1, i8 1)
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.vinsertf128.pd.256(<4 x double>, <2 x double>, i8) nounwind readnone

define <8 x float> @test_x86_avx_vinsertf128_ps_256_1(<8 x float> %a0, <4 x float> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_ps_256_1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    retl
  %res = call <8 x float> @llvm.x86.avx.vinsertf128.ps.256(<8 x float> %a0, <4 x float> %a1, i8 1)
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.vinsertf128.ps.256(<8 x float>, <4 x float>, i8) nounwind readnone

define <8 x i32> @test_x86_avx_vinsertf128_si_256_1(<8 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_si_256_1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    retl
  %res = call <8 x i32> @llvm.x86.avx.vinsertf128.si.256(<8 x i32> %a0, <4 x i32> %a1, i8 1)
  ret <8 x i32> %res
}

; Verify that high bits of the immediate are masked off. This should be the equivalent
; of a vinsertf128 $0 which should be optimized into a blend, so just check that it's
; not a vinsertf128 $1.
define <8 x i32> @test_x86_avx_vinsertf128_si_256_2(<8 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_x86_avx_vinsertf128_si_256_2:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vblendpd {{.*#+}} ymm0 = ymm1[0,1],ymm0[2,3]
; CHECK-NEXT:    retl
  %res = call <8 x i32> @llvm.x86.avx.vinsertf128.si.256(<8 x i32> %a0, <4 x i32> %a1, i8 2)
  ret <8 x i32> %res
}
declare <8 x i32> @llvm.x86.avx.vinsertf128.si.256(<8 x i32>, <4 x i32>, i8) nounwind readnone

; We don't check any vextractf128 variant with immediate 0 because that's just a move.

define <2 x double> @test_x86_avx_vextractf128_pd_256_1(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_vextractf128_pd_256_1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double> %a0, i8 1)
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double>, i8) nounwind readnone

define <4 x float> @test_x86_avx_vextractf128_ps_256_1(<8 x float> %a0) {
; CHECK-LABEL: test_x86_avx_vextractf128_ps_256_1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  %res = call <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float> %a0, i8 1)
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float>, i8) nounwind readnone

define <4 x i32> @test_x86_avx_vextractf128_si_256_1(<8 x i32> %a0) {
; CHECK-LABEL: test_x86_avx_vextractf128_si_256_1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  %res = call <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32> %a0, i8 1)
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32>, i8) nounwind readnone

; Verify that high bits of the immediate are masked off. This should be the equivalent
; of a vextractf128 $0 which should be optimized away, so just check that it's
; not a vextractf128 of any kind.
define <2 x double> @test_x86_avx_extractf128_pd_256_2(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_extractf128_pd_256_2:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double> %a0, i8 2)
  ret <2 x double> %res
}


define <4 x double> @test_x86_avx_blend_pd_256(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: test_x86_avx_blend_pd_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vblendpd {{.*#+}} ymm0 = ymm1[0,1,2],ymm0[3]
; CHECK-NEXT:    retl
  %res = call <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double> %a0, <4 x double> %a1, i32 7) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double>, <4 x double>, i32) nounwind readnone


define <8 x float> @test_x86_avx_blend_ps_256(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: test_x86_avx_blend_ps_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2],ymm0[3,4,5,6,7]
; CHECK-NEXT:    retl
  %res = call <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float> %a0, <8 x float> %a1, i32 7) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float>, <8 x float>, i32) nounwind readnone


define <8 x float> @test_x86_avx_dp_ps_256(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: test_x86_avx_dp_ps_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vdpps $7, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retl
  %res = call <8 x float> @llvm.x86.avx.dp.ps.256(<8 x float> %a0, <8 x float> %a1, i32 7) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.dp.ps.256(<8 x float>, <8 x float>, i32) nounwind readnone


define <2 x i64> @test_x86_sse2_psll_dq(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psll_dq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpslldq {{.*#+}} xmm0 = zero,xmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse2.psll.dq(<2 x i64> %a0, i32 8) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psll.dq(<2 x i64>, i32) nounwind readnone


define <2 x i64> @test_x86_sse2_psrl_dq(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psrl_dq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpsrldq {{.*#+}} xmm0 = xmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zero
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse2.psrl.dq(<2 x i64> %a0, i32 8) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psrl.dq(<2 x i64>, i32) nounwind readnone


define <2 x double> @test_x86_sse41_blendpd(<2 x double> %a0, <2 x double> %a1) {
; CHECK-LABEL: test_x86_sse41_blendpd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vblendpd {{.*#+}} xmm0 = xmm0[0],xmm1[1]
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse41.blendpd(<2 x double> %a0, <2 x double> %a1, i8 2) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse41.blendpd(<2 x double>, <2 x double>, i8) nounwind readnone


define <4 x float> @test_x86_sse41_blendps(<4 x float> %a0, <4 x float> %a1) {
; CHECK-LABEL: test_x86_sse41_blendps:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1,2],xmm0[3]
; CHECK-NEXT:    retl
  %res = call <4 x float> @llvm.x86.sse41.blendps(<4 x float> %a0, <4 x float> %a1, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse41.blendps(<4 x float>, <4 x float>, i8) nounwind readnone


define <8 x i16> @test_x86_sse41_pblendw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_x86_sse41_pblendw:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0,1,2],xmm0[3,4,5,6,7]
; CHECK-NEXT:    retl
  %res = call <8 x i16> @llvm.x86.sse41.pblendw(<8 x i16> %a0, <8 x i16> %a1, i8 7) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pblendw(<8 x i16>, <8 x i16>, i8) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovsxbd(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxbd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovsxbd %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <4 x i32> @llvm.x86.sse41.pmovsxbd(<16 x i8> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovsxbd(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovsxbq(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxbq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovsxbq %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse41.pmovsxbq(<16 x i8> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovsxbq(<16 x i8>) nounwind readnone


define <8 x i16> @test_x86_sse41_pmovsxbw(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxbw:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovsxbw %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <8 x i16> @llvm.x86.sse41.pmovsxbw(<16 x i8> %a0) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pmovsxbw(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovsxdq(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxdq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovsxdq %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse41.pmovsxdq(<4 x i32> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovsxdq(<4 x i32>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovsxwd(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxwd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovsxwd %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <4 x i32> @llvm.x86.sse41.pmovsxwd(<8 x i16> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovsxwd(<8 x i16>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovsxwq(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovsxwq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovsxwq %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse41.pmovsxwq(<8 x i16> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovsxwq(<8 x i16>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovzxbd(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxbd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-NEXT:    retl
  %res = call <4 x i32> @llvm.x86.sse41.pmovzxbd(<16 x i8> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovzxbd(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovzxbq(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxbq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovzxbq {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,zero,zero,zero,zero,xmm0[1],zero,zero,zero,zero,zero,zero,zero
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse41.pmovzxbq(<16 x i8> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovzxbq(<16 x i8>) nounwind readnone


define <8 x i16> @test_x86_sse41_pmovzxbw(<16 x i8> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxbw:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    retl
  %res = call <8 x i16> @llvm.x86.sse41.pmovzxbw(<16 x i8> %a0) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pmovzxbw(<16 x i8>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovzxdq(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxdq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse41.pmovzxdq(<4 x i32> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovzxdq(<4 x i32>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmovzxwd(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxwd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; CHECK-NEXT:    retl
  %res = call <4 x i32> @llvm.x86.sse41.pmovzxwd(<8 x i16> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmovzxwd(<8 x i16>) nounwind readnone


define <2 x i64> @test_x86_sse41_pmovzxwq(<8 x i16> %a0) {
; CHECK-LABEL: test_x86_sse41_pmovzxwq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovzxwq {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse41.pmovzxwq(<8 x i16> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse41.pmovzxwq(<8 x i16>) nounwind readnone


define <2 x double> @test_x86_sse2_cvtdq2pd(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_sse2_cvtdq2pd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvtdq2pd %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.cvtdq2pd(<4 x i32> %a0) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.cvtdq2pd(<4 x i32>) nounwind readnone


define <4 x double> @test_x86_avx_cvtdq2_pd_256(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_avx_cvtdq2_pd_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvtdq2pd %xmm0, %ymm0
; CHECK-NEXT:    retl
  %res = call <4 x double> @llvm.x86.avx.cvtdq2.pd.256(<4 x i32> %a0) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.cvtdq2.pd.256(<4 x i32>) nounwind readnone


define <2 x double> @test_x86_sse2_cvtps2pd(<4 x float> %a0) {
; CHECK-LABEL: test_x86_sse2_cvtps2pd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvtps2pd %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.cvtps2pd(<4 x float> %a0) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.cvtps2pd(<4 x float>) nounwind readnone


define <4 x double> @test_x86_avx_cvt_ps2_pd_256(<4 x float> %a0) {
; CHECK-LABEL: test_x86_avx_cvt_ps2_pd_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvtps2pd %xmm0, %ymm0
; CHECK-NEXT:    retl
  %res = call <4 x double> @llvm.x86.avx.cvt.ps2.pd.256(<4 x float> %a0) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.cvt.ps2.pd.256(<4 x float>) nounwind readnone


define <4 x i32> @test_x86_avx_cvtt_pd2dq_256(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_cvtt_pd2dq_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvttpd2dqy %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  %res = call <4 x i32> @llvm.x86.avx.cvtt.pd2dq.256(<4 x double> %a0) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.avx.cvtt.pd2dq.256(<4 x double>) nounwind readnone


define <8 x i32> @test_x86_avx_cvtt_ps2dq_256(<8 x float> %a0) {
; CHECK-LABEL: test_x86_avx_cvtt_ps2dq_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvttps2dq %ymm0, %ymm0
; CHECK-NEXT:    retl
  %res = call <8 x i32> @llvm.x86.avx.cvtt.ps2dq.256(<8 x float> %a0) ; <<8 x i32>> [#uses=1]
  ret <8 x i32> %res
}
declare <8 x i32> @llvm.x86.avx.cvtt.ps2dq.256(<8 x float>) nounwind readnone


define void @test_x86_sse2_storeu_dq(i8* %a0, <16 x i8> %a1) {
  ; add operation forces the execution domain.
; CHECK-LABEL: test_x86_sse2_storeu_dq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    vpaddb LCPI34_0, %xmm0, %xmm0
; CHECK-NEXT:    vmovdqu %xmm0, (%eax)
; CHECK-NEXT:    retl
  %a2 = add <16 x i8> %a1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  call void @llvm.x86.sse2.storeu.dq(i8* %a0, <16 x i8> %a2)
  ret void
}
declare void @llvm.x86.sse2.storeu.dq(i8*, <16 x i8>) nounwind


define void @test_x86_sse2_storeu_pd(i8* %a0, <2 x double> %a1) {
  ; fadd operation forces the execution domain.
; CHECK-LABEL: test_x86_sse2_storeu_pd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    vpslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7]
; CHECK-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmovupd %xmm0, (%eax)
; CHECK-NEXT:    retl
  %a2 = fadd <2 x double> %a1, <double 0x0, double 0x4200000000000000>
  call void @llvm.x86.sse2.storeu.pd(i8* %a0, <2 x double> %a2)
  ret void
}
declare void @llvm.x86.sse2.storeu.pd(i8*, <2 x double>) nounwind


define void @test_x86_sse_storeu_ps(i8* %a0, <4 x float> %a1) {
; CHECK-LABEL: test_x86_sse_storeu_ps:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    vmovups %xmm0, (%eax)
; CHECK-NEXT:    retl
  call void @llvm.x86.sse.storeu.ps(i8* %a0, <4 x float> %a1)
  ret void
}
declare void @llvm.x86.sse.storeu.ps(i8*, <4 x float>) nounwind


define void @test_x86_avx_storeu_dq_256(i8* %a0, <32 x i8> %a1) {
  ; FIXME: unfortunately the execution domain fix pass changes this to vmovups and its hard to force with no 256-bit integer instructions
  ; add operation forces the execution domain.
; CHECK-LABEL: test_x86_avx_storeu_dq_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; CHECK-NEXT:    vpaddb %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpaddb %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    vmovups %ymm0, (%eax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  %a2 = add <32 x i8> %a1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  call void @llvm.x86.avx.storeu.dq.256(i8* %a0, <32 x i8> %a2)
  ret void
}
declare void @llvm.x86.avx.storeu.dq.256(i8*, <32 x i8>) nounwind


define void @test_x86_avx_storeu_pd_256(i8* %a0, <4 x double> %a1) {
  ; add operation forces the execution domain.
; CHECK-LABEL: test_x86_avx_storeu_pd_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    vxorpd %ymm1, %ymm1, %ymm1
; CHECK-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vmovupd %ymm0, (%eax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  %a2 = fadd <4 x double> %a1, <double 0x0, double 0x0, double 0x0, double 0x0>
  call void @llvm.x86.avx.storeu.pd.256(i8* %a0, <4 x double> %a2)
  ret void
}
declare void @llvm.x86.avx.storeu.pd.256(i8*, <4 x double>) nounwind


define void @test_x86_avx_storeu_ps_256(i8* %a0, <8 x float> %a1) {
; CHECK-LABEL: test_x86_avx_storeu_ps_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    vmovups %ymm0, (%eax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
  call void @llvm.x86.avx.storeu.ps.256(i8* %a0, <8 x float> %a1)
  ret void
}
declare void @llvm.x86.avx.storeu.ps.256(i8*, <8 x float>) nounwind


define <2 x double> @test_x86_avx_vpermil_pd(<2 x double> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_pd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.avx.vpermil.pd(<2 x double> %a0, i8 1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.avx.vpermil.pd(<2 x double>, i8) nounwind readnone


define <4 x double> @test_x86_avx_vpermil_pd_256(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_pd_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[1,1,3,2]
; CHECK-NEXT:    retl
  %res = call <4 x double> @llvm.x86.avx.vpermil.pd.256(<4 x double> %a0, i8 7) ; <<4 x double>> [#uses=1]
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.avx.vpermil.pd.256(<4 x double>, i8) nounwind readnone


define <4 x float> @test_x86_avx_vpermil_ps(<4 x float> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_ps:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,0,0]
; CHECK-NEXT:    retl
  %res = call <4 x float> @llvm.x86.avx.vpermil.ps(<4 x float> %a0, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.avx.vpermil.ps(<4 x float>, i8) nounwind readnone


define <8 x float> @test_x86_avx_vpermil_ps_256(<8 x float> %a0) {
; CHECK-LABEL: test_x86_avx_vpermil_ps_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[3,1,0,0,7,5,4,4]
; CHECK-NEXT:    retl
  %res = call <8 x float> @llvm.x86.avx.vpermil.ps.256(<8 x float> %a0, i8 7) ; <<8 x float>> [#uses=1]
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.avx.vpermil.ps.256(<8 x float>, i8) nounwind readnone
