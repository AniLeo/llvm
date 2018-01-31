; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+avx,+f16c | FileCheck %s --check-prefix=X32
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx,+f16c | FileCheck %s --check-prefix=X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/f16c-builtins.c

define float @test_cvtsh_ss(i16 %a0) nounwind {
; X32-LABEL: test_cvtsh_ss:
; X32:       # %bb.0:
; X32-NEXT:    pushl %eax
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vmovd %eax, %xmm0
; X32-NEXT:    vcvtph2ps %xmm0, %xmm0
; X32-NEXT:    vmovss %xmm0, (%esp)
; X32-NEXT:    flds (%esp)
; X32-NEXT:    popl %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_cvtsh_ss:
; X64:       # %bb.0:
; X64-NEXT:    movzwl %di, %eax
; X64-NEXT:    vmovd %eax, %xmm0
; X64-NEXT:    vcvtph2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %ins0 = insertelement <8 x i16> undef, i16 %a0, i32 0
  %ins1 = insertelement <8 x i16> %ins0, i16 0, i32 1
  %ins2 = insertelement <8 x i16> %ins1, i16 0, i32 2
  %ins3 = insertelement <8 x i16> %ins2, i16 0, i32 3
  %ins4 = insertelement <8 x i16> %ins3, i16 0, i32 4
  %ins5 = insertelement <8 x i16> %ins4, i16 0, i32 5
  %ins6 = insertelement <8 x i16> %ins5, i16 0, i32 6
  %ins7 = insertelement <8 x i16> %ins6, i16 0, i32 7
  %cvt = call <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16> %ins7)
  %res = extractelement <4 x float> %cvt, i32 0
  ret float %res
}

define i16 @test_cvtss_sh(float %a0) nounwind {
; X32-LABEL: test_cvtss_sh:
; X32:       # %bb.0:
; X32-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; X32-NEXT:    vcvtps2ph $0, %xmm0, %xmm0
; X32-NEXT:    vmovd %xmm0, %eax
; X32-NEXT:    # kill: def $ax killed $ax killed $eax
; X32-NEXT:    retl
;
; X64-LABEL: test_cvtss_sh:
; X64:       # %bb.0:
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; X64-NEXT:    vcvtps2ph $0, %xmm0, %xmm0
; X64-NEXT:    vmovd %xmm0, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %ins0 = insertelement <4 x float> undef, float %a0, i32 0
  %ins1 = insertelement <4 x float> %ins0, float 0.000000e+00, i32 1
  %ins2 = insertelement <4 x float> %ins1, float 0.000000e+00, i32 2
  %ins3 = insertelement <4 x float> %ins2, float 0.000000e+00, i32 3
  %cvt = call <8 x i16> @llvm.x86.vcvtps2ph.128(<4 x float> %ins3, i32 0)
  %res = extractelement <8 x i16> %cvt, i32 0
  ret i16 %res
}

define <4 x float> @test_mm_cvtph_ps(<2 x i64> %a0) nounwind {
; X32-LABEL: test_mm_cvtph_ps:
; X32:       # %bb.0:
; X32-NEXT:    vcvtph2ps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_cvtph_ps:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2ps %xmm0, %xmm0
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16> %arg0)
  ret <4 x float> %res
}

define <8 x float> @test_mm256_cvtph_ps(<2 x i64> %a0) nounwind {
; X32-LABEL: test_mm256_cvtph_ps:
; X32:       # %bb.0:
; X32-NEXT:    vcvtph2ps %xmm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_cvtph_ps:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2ps %xmm0, %ymm0
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res = call <8 x float> @llvm.x86.vcvtph2ps.256(<8 x i16> %arg0)
  ret <8 x float> %res
}

define <2 x i64> @test_mm_cvtps_ph(<4 x float> %a0) nounwind {
; X32-LABEL: test_mm_cvtps_ph:
; X32:       # %bb.0:
; X32-NEXT:    vcvtps2ph $0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_cvtps_ph:
; X64:       # %bb.0:
; X64-NEXT:    vcvtps2ph $0, %xmm0, %xmm0
; X64-NEXT:    retq
  %cvt = call <8 x i16> @llvm.x86.vcvtps2ph.128(<4 x float> %a0, i32 0)
  %res = bitcast <8 x i16> %cvt to <2 x i64>
  ret <2 x i64> %res
}

define <2 x i64> @test_mm256_cvtps_ph(<8 x float> %a0) nounwind {
; X32-LABEL: test_mm256_cvtps_ph:
; X32:       # %bb.0:
; X32-NEXT:    vcvtps2ph $0, %ymm0, %xmm0
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_cvtps_ph:
; X64:       # %bb.0:
; X64-NEXT:    vcvtps2ph $0, %ymm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %cvt = call <8 x i16> @llvm.x86.vcvtps2ph.256(<8 x float> %a0, i32 0)
  %res = bitcast <8 x i16> %cvt to <2 x i64>
  ret <2 x i64> %res
}

declare <4 x float> @llvm.x86.vcvtph2ps.128(<8 x i16>) nounwind readonly
declare <8 x float> @llvm.x86.vcvtph2ps.256(<8 x i16>) nounwind readonly

declare <8 x i16> @llvm.x86.vcvtps2ph.128(<4 x float>, i32) nounwind readonly
declare <8 x i16> @llvm.x86.vcvtps2ph.256(<8 x float>, i32) nounwind readonly
