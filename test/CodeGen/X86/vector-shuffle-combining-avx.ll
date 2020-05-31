; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -disable-peephole -mtriple=i686-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,X86,AVX,X86-AVX,AVX1,X86-AVX1
; RUN: llc < %s -disable-peephole -mtriple=i686-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,X86,AVX,X86-AVX,AVX2,X86-AVX2
; RUN: llc < %s -disable-peephole -mtriple=i686-unknown -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,X86,AVX512,X86-AVX512
; RUN: llc < %s -disable-peephole -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,X64,AVX,X64-AVX,AVX1,X64-AVX1
; RUN: llc < %s -disable-peephole -mtriple=x86_64-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,X64,AVX,X64-AVX,AVX2,X64-AVX2
; RUN: llc < %s -disable-peephole -mtriple=x86_64-unknown -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,X64,AVX512,X64-AVX512
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
; CHECK-LABEL: combine_vpermilvar_4f32_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  %2 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %1, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  ret <4 x float> %2
}

define <4 x float> @combine_vpermilvar_4f32_movddup(<4 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f32_movddup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 0, i32 1, i32 0, i32 1>)
  ret <4 x float> %1
}
define <4 x float> @combine_vpermilvar_4f32_movddup_load(<4 x float> *%a0) {
; X86-LABEL: combine_vpermilvar_4f32_movddup_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovddup {{.*#+}} xmm0 = mem[0,0]
; X86-NEXT:    retl
;
; X64-LABEL: combine_vpermilvar_4f32_movddup_load:
; X64:       # %bb.0:
; X64-NEXT:    vmovddup {{.*#+}} xmm0 = mem[0,0]
; X64-NEXT:    retq
  %1 = load <4 x float>, <4 x float> *%a0
  %2 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %1, <4 x i32> <i32 0, i32 1, i32 0, i32 1>)
  ret <4 x float> %2
}

define <4 x float> @combine_vpermilvar_4f32_movshdup(<4 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f32_movshdup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm0 = xmm0[1,1,3,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 undef, i32 1, i32 3, i32 3>)
  ret <4 x float> %1
}

define <4 x float> @combine_vpermilvar_4f32_movsldup(<4 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f32_movsldup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovsldup {{.*#+}} xmm0 = xmm0[0,0,2,2]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 0, i32 0, i32 2, i32 undef>)
  ret <4 x float> %1
}

define <4 x float> @combine_vpermilvar_4f32_unpckh(<4 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f32_unpckh:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,2,3,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 2, i32 2, i32 3, i32 3>)
  ret <4 x float> %1
}

define <4 x float> @combine_vpermilvar_4f32_unpckl(<4 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f32_unpckl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,1,1]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 0, i32 0, i32 1, i32 1>)
  ret <4 x float> %1
}

define <8 x float> @combine_vpermilvar_8f32_identity(<8 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_8f32_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 2, i32 3, i32 0, i32 undef>)
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %1, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 2, i32 3, i32 0, i32 1>)
  ret <8 x float> %2
}

define <8 x float> @combine_vpermilvar_8f32_10326u4u(<8 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_8f32_10326u4u:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[1,0,3,2,6,u,4,u]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 0, i32 1, i32 2, i32 undef>)
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %1, <8 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 undef>)
  ret <8 x float> %2
}

define <8 x float> @combine_vpermilvar_vperm2f128_8f32(<8 x float> %a0) {
; AVX1-LABEL: combine_vpermilvar_vperm2f128_8f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: combine_vpermilvar_vperm2f128_8f32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-NEXT:    ret{{[l|q]}}
;
; AVX512-LABEL: combine_vpermilvar_vperm2f128_8f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX512-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  %2 = shufflevector <8 x float> %1, <8 x float> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  %3 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %2, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  ret <8 x float> %3
}

define <8 x float> @combine_vpermilvar_vperm2f128_zero_8f32(<8 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_vperm2f128_zero_8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[0,1]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  %2 = shufflevector <8 x float> %1, <8 x float> zeroinitializer, <8 x i32> <i32 8, i32 8, i32 8, i32 8, i32 0, i32 1, i32 2, i32 3>
  %3 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %2, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  ret <8 x float> %3
}

define <4 x double> @combine_vperm2f128_vpermilvar_as_vpblendpd(<4 x double> %a0) {
; CHECK-LABEL: combine_vperm2f128_vpermilvar_as_vpblendpd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; CHECK-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[1,0,3,2]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %a0, <4 x i64> <i64 2, i64 0, i64 2, i64 0>)
  %2 = shufflevector <4 x double> %1, <4 x double> zeroinitializer, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  %3 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %2, <4 x i64> <i64 2, i64 0, i64 2, i64 0>)
  ret <4 x double> %3
}

define <8 x float> @combine_vpermilvar_8f32_movddup(<8 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_8f32_movddup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovddup {{.*#+}} ymm0 = ymm0[0,0,2,2]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 5, i32 4, i32 5>)
  ret <8 x float> %1
}
define <8 x float> @combine_vpermilvar_8f32_movddup_load(<8 x float> *%a0) {
; X86-LABEL: combine_vpermilvar_8f32_movddup_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovddup {{.*#+}} ymm0 = mem[0,0,2,2]
; X86-NEXT:    retl
;
; X64-LABEL: combine_vpermilvar_8f32_movddup_load:
; X64:       # %bb.0:
; X64-NEXT:    vmovddup {{.*#+}} ymm0 = mem[0,0,2,2]
; X64-NEXT:    retq
  %1 = load <8 x float>, <8 x float> *%a0
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %1, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 5, i32 4, i32 5>)
  ret <8 x float> %2
}

define <8 x float> @combine_vpermilvar_8f32_movshdup(<8 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_8f32_movshdup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovshdup {{.*#+}} ymm0 = ymm0[1,1,3,3,5,5,7,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 undef, i32 5, i32 7, i32 7>)
  ret <8 x float> %1
}
define <8 x float> @demandedelts_vpermilvar_8f32_movshdup(<8 x float> %a0, i32 %a1) {
; CHECK-LABEL: demandedelts_vpermilvar_8f32_movshdup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovshdup {{.*#+}} ymm0 = ymm0[1,1,3,3,5,5,7,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = insertelement <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 undef, i32 5, i32 7, i32 7>, i32 %a1, i32 7
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> %1)
  %3 = shufflevector <8 x float> %2, <8 x float> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 6>
  ret <8 x float> %3
}

define <8 x float> @combine_vpermilvar_8f32_movsldup(<8 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_8f32_movsldup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovsldup {{.*#+}} ymm0 = ymm0[0,0,2,2,4,4,6,6]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>)
  ret <8 x float> %1
}
define <8 x float> @demandedelts_vpermilvar_8f32_movsldup(<8 x float> %a0, i32 %a1) {
; CHECK-LABEL: demandedelts_vpermilvar_8f32_movsldup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovsldup {{.*#+}} ymm0 = ymm0[0,0,2,2,4,4,6,6]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = insertelement <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>, i32 %a1, i32 0
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> %1)
  %3 = shufflevector <8 x float> %2, <8 x float> undef, <8 x i32> <i32 1, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %3
}

define <2 x double> @combine_vpermilvar_2f64_identity(<2 x double> %a0) {
; CHECK-LABEL: combine_vpermilvar_2f64_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %a0, <2 x i64> <i64 2, i64 0>)
  %2 = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double>  %1, <2 x i64> <i64 2, i64 0>)
  ret <2 x double> %2
}

define <2 x double> @combine_vpermilvar_2f64_movddup(<2 x double> %a0) {
; CHECK-LABEL: combine_vpermilvar_2f64_movddup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %a0, <2 x i64> <i64 0, i64 0>)
  ret <2 x double> %1
}

define <4 x double> @combine_vpermilvar_4f64_identity(<4 x double> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f64_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %a0, <4 x i64> <i64 2, i64 0, i64 2, i64 0>)
  %2 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double>  %1, <4 x i64> <i64 2, i64 0, i64 2, i64 0>)
  ret <4 x double> %2
}

define <4 x double> @combine_vpermilvar_4f64_movddup(<4 x double> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f64_movddup:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovddup {{.*#+}} ymm0 = ymm0[0,0,2,2]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %a0, <4 x i64> <i64 0, i64 0, i64 4, i64 4>)
  ret <4 x double> %1
}

define <4 x float> @combine_vpermilvar_4f32_4stage(<4 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f32_4stage:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,0,3,1]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  %2 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %1, <4 x i32> <i32 2, i32 3, i32 0, i32 1>)
  %3 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %2, <4 x i32> <i32 0, i32 2, i32 1, i32 3>)
  %4 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>  %3, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  ret <4 x float> %4
}

define <8 x float> @combine_vpermilvar_8f32_4stage(<8 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_8f32_4stage:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[2,0,3,1,6,4,7,5]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %1, <8 x i32> <i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1>)
  %3 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %2, <8 x i32> <i32 0, i32 2, i32 1, i32 3, i32 0, i32 2, i32 1, i32 3>)
  %4 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>  %3, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 3, i32 2, i32 1, i32 0>)
  ret <8 x float> %4
}

define <4 x float> @combine_vpermilvar_4f32_as_insertps(<4 x float> %a0) {
; CHECK-LABEL: combine_vpermilvar_4f32_as_insertps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[1],zero,xmm0[2],zero
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  %2 = shufflevector <4 x float> %1, <4 x float> zeroinitializer, <4 x i32> <i32 2, i32 4, i32 1, i32 4>
  ret <4 x float> %2
}

define <2 x double> @constant_fold_vpermilvar_pd() {
; CHECK-LABEL: constant_fold_vpermilvar_pd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [2.0E+0,1.0E+0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> <double 1.0, double 2.0>, <2 x i64> <i64 2, i64 0>)
  ret <2 x double> %1
}

define <4 x double> @constant_fold_vpermilvar_pd_256() {
; CHECK-LABEL: constant_fold_vpermilvar_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = [2.0E+0,1.0E+0,3.0E+0,4.0E+0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> <double 1.0, double 2.0, double 3.0, double 4.0>, <4 x i64> <i64 2, i64 0, i64 0, i64 2>)
  ret <4 x double> %1
}

define <4 x float> @constant_fold_vpermilvar_ps() {
; CHECK-LABEL: constant_fold_vpermilvar_ps:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [4.0E+0,1.0E+0,3.0E+0,2.0E+0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> <float 1.0, float 2.0, float 3.0, float 4.0>, <4 x i32> <i32 3, i32 0, i32 2, i32 1>)
  ret <4 x float> %1
}

define <8 x float> @constant_fold_vpermilvar_ps_256() {
; CHECK-LABEL: constant_fold_vpermilvar_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = [1.0E+0,1.0E+0,3.0E+0,2.0E+0,5.0E+0,6.0E+0,6.0E+0,6.0E+0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>, <8 x i32> <i32 4, i32 0, i32 2, i32 1, i32 0, i32 1, i32 1, i32 1>)
  ret <8 x float> %1
}

define void @PR39483() {
; X86-AVX1-LABEL: PR39483:
; X86-AVX1:       # %bb.0: # %entry
; X86-AVX1-NEXT:    vmovups 32, %ymm0
; X86-AVX1-NEXT:    vmovups 64, %xmm1
; X86-AVX1-NEXT:    vshufps {{.*#+}} xmm1 = xmm1[0,1],mem[0,3]
; X86-AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm1
; X86-AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],mem[2],ymm0[3,4],mem[5],ymm0[6,7]
; X86-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; X86-AVX1-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; X86-AVX1-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,1,0,3]
; X86-AVX1-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm2[1,0]
; X86-AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; X86-AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3,4],ymm1[5,6,7]
; X86-AVX1-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X86-AVX1-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; X86-AVX1-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X86-AVX1-NEXT:    vmovups %ymm0, (%eax)
;
; X86-AVX2-LABEL: PR39483:
; X86-AVX2:       # %bb.0: # %entry
; X86-AVX2-NEXT:    vmovups 32, %ymm0
; X86-AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],mem[2],ymm0[3,4],mem[5],ymm0[6,7]
; X86-AVX2-NEXT:    vmovaps {{.*#+}} ymm1 = <2,5,0,3,6,u,u,u>
; X86-AVX2-NEXT:    vpermps %ymm0, %ymm1, %ymm0
; X86-AVX2-NEXT:    vpermilps {{.*#+}} ymm1 = mem[0,1,0,3,4,5,4,7]
; X86-AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,1,0,3]
; X86-AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3,4],ymm1[5,6,7]
; X86-AVX2-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X86-AVX2-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; X86-AVX2-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X86-AVX2-NEXT:    vmovups %ymm0, (%eax)
;
; X86-AVX512-LABEL: PR39483:
; X86-AVX512:       # %bb.0: # %entry
; X86-AVX512-NEXT:    vmovups 0, %zmm0
; X86-AVX512-NEXT:    vmovups 64, %ymm1
; X86-AVX512-NEXT:    vmovaps {{.*#+}} ymm2 = [2,5,8,11,14,17,20,23]
; X86-AVX512-NEXT:    vpermi2ps %zmm1, %zmm0, %zmm2
; X86-AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X86-AVX512-NEXT:    vmulps %ymm0, %ymm2, %ymm1
; X86-AVX512-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; X86-AVX512-NEXT:    vmovups %ymm0, (%eax)
;
; X64-AVX1-LABEL: PR39483:
; X64-AVX1:       # %bb.0: # %entry
; X64-AVX1-NEXT:    vmovups 32, %ymm0
; X64-AVX1-NEXT:    vmovups 64, %xmm1
; X64-AVX1-NEXT:    vshufps {{.*#+}} xmm1 = xmm1[0,1],mem[0,3]
; X64-AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm1
; X64-AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],mem[2],ymm0[3,4],mem[5],ymm0[6,7]
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; X64-AVX1-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; X64-AVX1-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,1,0,3]
; X64-AVX1-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm2[1,0]
; X64-AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; X64-AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3,4],ymm1[5,6,7]
; X64-AVX1-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-AVX1-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; X64-AVX1-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X64-AVX1-NEXT:    vmovups %ymm0, (%rax)
;
; X64-AVX2-LABEL: PR39483:
; X64-AVX2:       # %bb.0: # %entry
; X64-AVX2-NEXT:    vmovups 32, %ymm0
; X64-AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],mem[2],ymm0[3,4],mem[5],ymm0[6,7]
; X64-AVX2-NEXT:    vmovaps {{.*#+}} ymm1 = <2,5,0,3,6,u,u,u>
; X64-AVX2-NEXT:    vpermps %ymm0, %ymm1, %ymm0
; X64-AVX2-NEXT:    vpermilps {{.*#+}} ymm1 = mem[0,1,0,3,4,5,4,7]
; X64-AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,1,0,3]
; X64-AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3,4],ymm1[5,6,7]
; X64-AVX2-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-AVX2-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vmovups %ymm0, (%rax)
;
; X64-AVX512-LABEL: PR39483:
; X64-AVX512:       # %bb.0: # %entry
; X64-AVX512-NEXT:    vmovups 0, %zmm0
; X64-AVX512-NEXT:    vmovups 64, %ymm1
; X64-AVX512-NEXT:    vmovaps {{.*#+}} ymm2 = [2,5,8,11,14,17,20,23]
; X64-AVX512-NEXT:    vpermi2ps %zmm1, %zmm0, %zmm2
; X64-AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X64-AVX512-NEXT:    vmulps %ymm0, %ymm2, %ymm1
; X64-AVX512-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; X64-AVX512-NEXT:    vmovups %ymm0, (%rax)
entry:
  %wide.vec = load <24 x float>, <24 x float>* null, align 4
  %strided.vec18 = shufflevector <24 x float> %wide.vec, <24 x float> undef, <8 x i32> <i32 2, i32 5, i32 8, i32 11, i32 14, i32 17, i32 20, i32 23>
  %0 = fmul <8 x float> %strided.vec18, zeroinitializer
  %1 = fadd <8 x float> zeroinitializer, %0
  store <8 x float> %1, <8 x float>* undef, align 16
  unreachable
}

define <4 x i64> @concat_self_v4i64(<2 x i64> %x) {
; AVX1-LABEL: concat_self_v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[0,0,3,3]
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: concat_self_v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,0,1,1]
; AVX2-NEXT:    ret{{[l|q]}}
;
; AVX512-LABEL: concat_self_v4i64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX512-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,0,1,1]
; AVX512-NEXT:    ret{{[l|q]}}
  %cat = shufflevector <2 x i64> %x, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %s = shufflevector <4 x i64> %cat, <4 x i64> undef, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x i64> %s
}

define <8 x i32> @concat_self_v8i32(<4 x i32> %x) {
; AVX1-LABEL: concat_self_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[3,2,1,0]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm0[0,2,1,3]
; AVX1-NEXT:    vpaddd %xmm0, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: concat_self_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm0, %ymm1
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [3,2,1,0,0,2,1,3]
; AVX2-NEXT:    vpermd %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    ret{{[l|q]}}
;
; AVX512-LABEL: concat_self_v8i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX512-NEXT:    vinserti128 $1, %xmm0, %ymm0, %ymm1
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm2 = [3,2,1,0,0,2,1,3]
; AVX512-NEXT:    vpermd %ymm0, %ymm2, %ymm0
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    ret{{[l|q]}}
  %cat = shufflevector <4 x i32> %x, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
  %s = shufflevector <8 x i32> %cat, <8 x i32> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 0, i32 2, i32 1, i32 3>
  %a = add <8 x i32> %s, %cat
  ret <8 x i32> %a
}
