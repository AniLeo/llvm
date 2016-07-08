; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512f | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512F
;
; Combine tests involving AVX target shuffles

declare <4 x float> @llvm.x86.avx.vpermil.ps(<4 x float>, i8)
declare <8 x float> @llvm.x86.avx.vpermil.ps.256(<8 x float>, i8)
declare <2 x double> @llvm.x86.avx.vpermil.pd(<2 x double>, i8)
declare <4 x double> @llvm.x86.avx.vpermil.pd.256(<4 x double>, i8)

declare <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>, <4 x i32>)
declare <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>, <8 x i32>)
declare <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double>, <2 x i64>)
declare <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double>, <4 x i64>)

declare <8 x i32> @llvm.x86.avx.vperm2f128.si.256(<8 x i32>, <8 x i32>, i8)
declare <8 x float> @llvm.x86.avx.vperm2f128.ps.256(<8 x float>, <8 x float>, i8)
declare <4 x double> @llvm.x86.avx.vperm2f128.pd.256(<4 x double>, <4 x double>, i8)

define <4 x float> @combine_vpermilvar_4f32_identity(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_identity:
; ALL:       # BB#0:
; ALL-NEXT:    retq
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  %2 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %1, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  ret <4 x float> %2
}

define <4 x float> @combine_vpermilvar_4f32_movddup(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_movddup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; ALL-NEXT:    retq
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 0, i32 1, i32 0, i32 1>)
  ret <4 x float> %1
}
define <4 x float> @combine_vpermilvar_4f32_movddup_load(<4 x float> *%a0) {
; ALL-LABEL: combine_vpermilvar_4f32_movddup_load:
; ALL:       # BB#0:
; ALL-NEXT:    vmovddup {{.*#+}} xmm0 = mem[0,0]
; ALL-NEXT:    retq
  %1 = load <4 x float>, <4 x float> *%a0
  %2 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %1, <4 x i32> <i32 0, i32 1, i32 0, i32 1>)
  ret <4 x float> %2
}

define <4 x float> @combine_vpermilvar_4f32_movshdup(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_movshdup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovshdup {{.*#+}} xmm0 = xmm0[1,1,3,3]
; ALL-NEXT:    retq
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 undef, i32 1, i32 3, i32 3>)
  ret <4 x float> %1
}

define <4 x float> @combine_vpermilvar_4f32_movsldup(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_movsldup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovsldup {{.*#+}} xmm0 = xmm0[0,0,2,2]
; ALL-NEXT:    retq
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 0, i32 0, i32 2, i32 undef>)
  ret <4 x float> %1
}

define <4 x float> @combine_vpermilvar_4f32_unpckh(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_unpckh:
; ALL:       # BB#0:
; ALL-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,2,3,3]
; ALL-NEXT:    retq
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 2, i32 2, i32 3, i32 3>)
  ret <4 x float> %1
}

define <4 x float> @combine_vpermilvar_4f32_unpckl(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_unpckl:
; ALL:       # BB#0:
; ALL-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,1,1]
; ALL-NEXT:    retq
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 0, i32 0, i32 1, i32 1>)
  ret <4 x float> %1
}

define <8 x float> @combine_vpermilvar_8f32_identity(<8 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_8f32_identity:
; ALL:       # BB#0:
; ALL-NEXT:    retq
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 2, i32 3, i32 0, i32 undef>)
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %1, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 2, i32 3, i32 0, i32 1>)
  ret <8 x float> %2
}

define <8 x float> @combine_vpermilvar_8f32_movddup(<8 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_8f32_movddup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovddup {{.*#+}} ymm0 = ymm0[0,0,2,2]
; ALL-NEXT:    retq
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 5, i32 4, i32 5>)
  ret <8 x float> %1
}
define <8 x float> @combine_vpermilvar_8f32_movddup_load(<8 x float> *%a0) {
; ALL-LABEL: combine_vpermilvar_8f32_movddup_load:
; ALL:       # BB#0:
; ALL-NEXT:    vmovddup {{.*#+}} ymm0 = mem[0,0,2,2]
; ALL-NEXT:    retq
  %1 = load <8 x float>, <8 x float> *%a0
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %1, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 5, i32 4, i32 5>)
  ret <8 x float> %2
}

define <8 x float> @combine_vpermilvar_8f32_movshdup(<8 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_8f32_movshdup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovshdup {{.*#+}} ymm0 = ymm0[1,1,3,3,5,5,7,7]
; ALL-NEXT:    retq
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 undef, i32 5, i32 7, i32 7>)
  ret <8 x float> %1
}

define <8 x float> @combine_vpermilvar_8f32_movsldup(<8 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_8f32_movsldup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovsldup {{.*#+}} ymm0 = ymm0[0,0,2,2,4,4,6,6]
; ALL-NEXT:    retq
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>)
  ret <8 x float> %1
}

define <2 x double> @combine_vpermilvar_2f64_identity(<2 x double> %a0) {
; ALL-LABEL: combine_vpermilvar_2f64_identity:
; ALL:       # BB#0:
; ALL-NEXT:    retq
  %1 = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %a0, <2 x i64> <i64 2, i64 0>)
  %2 = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double>  %1, <2 x i64> <i64 2, i64 0>)
  ret <2 x double> %2
}

define <2 x double> @combine_vpermilvar_2f64_movddup(<2 x double> %a0) {
; ALL-LABEL: combine_vpermilvar_2f64_movddup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; ALL-NEXT:    retq
  %1 = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %a0, <2 x i64> <i64 0, i64 0>)
  ret <2 x double> %1
}

define <4 x double> @combine_vpermilvar_4f64_identity(<4 x double> %a0) {
; ALL-LABEL: combine_vpermilvar_4f64_identity:
; ALL:       # BB#0:
; ALL-NEXT:    retq
  %1 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %a0, <4 x i64> <i64 2, i64 0, i64 2, i64 0>)
  %2 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double>  %1, <4 x i64> <i64 2, i64 0, i64 2, i64 0>)
  ret <4 x double> %2
}

define <4 x double> @combine_vpermilvar_4f64_movddup(<4 x double> %a0) {
; ALL-LABEL: combine_vpermilvar_4f64_movddup:
; ALL:       # BB#0:
; ALL-NEXT:    vmovddup {{.*#+}} ymm0 = ymm0[0,0,2,2]
; ALL-NEXT:    retq
  %1 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %a0, <4 x i64> <i64 0, i64 0, i64 4, i64 4>)
  ret <4 x double> %1
}

define <4 x float> @combine_vpermilvar_4f32_4stage(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_4stage:
; ALL:       # BB#0:
; ALL-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,0,3,1]
; ALL-NEXT:    retq
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  %2 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %1, <4 x i32> <i32 2, i32 3, i32 0, i32 1>)
  %3 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %2, <4 x i32> <i32 0, i32 2, i32 1, i32 3>)
  %4 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %3, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  ret <4 x float> %4
}

define <8 x float> @combine_vpermilvar_8f32_4stage(<8 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_8f32_4stage:
; ALL:       # BB#0:
; ALL-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[2,0,3,1,6,4,7,5]
; ALL-NEXT:    retq
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %1, <8 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>)
  %3 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %2, <8 x i32> <i32 0, i32 2, i32 1, i32 3, i32 0, i32 2, i32 1, i32 3>)
  %4 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %3, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  ret <8 x float> %4
}

define <4 x float> @combine_vpermilvar_4f32_as_insertps(<4 x float> %a0) {
; ALL-LABEL: combine_vpermilvar_4f32_as_insertps:
; ALL:       # BB#0:
; ALL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,6,7],zero,zero,zero,zero,xmm0[8,9,10,11],zero,zero,zero,zero
; ALL-NEXT:    retq
  %1 = call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  %2 = shufflevector <4 x float> %1, <4 x float> zeroinitializer, <4 x i32> <i32 2, i32 4, i32 1, i32 4>
  ret <4 x float> %2
}
