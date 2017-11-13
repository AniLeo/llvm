; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=skx | FileCheck %s --check-prefix=CHECK --check-prefix=SKX
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl | FileCheck %s --check-prefix=CHECK --check-prefix=KNL


define <4 x float> @test_rsqrt14_ss(<4 x float> %a0) {
; CHECK-LABEL: test_rsqrt14_ss:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrsqrt14ss %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
    %res = call <4 x float> @llvm.x86.avx512.rsqrt14.ss(<4 x float> %a0, <4 x float> %a0, <4 x float> zeroinitializer, i8 -1) ;
    ret <4 x float> %res
}

define <4 x float> @test_rsqrt14_ss_load(<4 x float> %a0, <4 x float>* %a1ptr) {
; CHECK-LABEL: test_rsqrt14_ss_load:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrsqrt14ss (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a1 = load <4 x float>, <4 x float>* %a1ptr
  %res = call <4 x float> @llvm.x86.avx512.rsqrt14.ss(<4 x float> %a0, <4 x float> %a1, <4 x float> zeroinitializer, i8 -1) ;
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.avx512.rsqrt14.ss(<4 x float>, <4 x float>, <4 x float>, i8) nounwind readnone

define <4 x float> @test_rcp14_ss(<4 x float> %a0) {
; CHECK-LABEL: test_rcp14_ss:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrcp14ss %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
    %res = call <4 x float> @llvm.x86.avx512.rcp14.ss(<4 x float> %a0, <4 x float> %a0, <4 x float> zeroinitializer, i8 -1) ;
    ret <4 x float> %res
}

define <4 x float> @test_rcp14_ss_load(<4 x float> %a0, <4 x float>* %a1ptr) {
; CHECK-LABEL: test_rcp14_ss_load:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrcp14ss (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a1 = load <4 x float>, <4 x float>* %a1ptr
  %res = call <4 x float> @llvm.x86.avx512.rcp14.ss(<4 x float> %a0, <4 x float> %a1, <4 x float> zeroinitializer, i8 -1) ;
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.avx512.rcp14.ss(<4 x float>, <4 x float>, <4 x float>, i8) nounwind readnone

define <2 x double> @test_rsqrt14_sd(<2 x double> %a0) {
; CHECK-LABEL: test_rsqrt14_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrsqrt14sd %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
    %res = call <2 x double> @llvm.x86.avx512.rsqrt14.sd(<2 x double> %a0, <2 x double> %a0, <2 x double> zeroinitializer, i8 -1) ;
    ret <2 x double> %res
}

define <2 x double> @test_rsqrt14_sd_load(<2 x double> %a0, <2 x double>* %a1ptr) {
; CHECK-LABEL: test_rsqrt14_sd_load:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrsqrt14sd (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a1 = load <2 x double>, <2 x double>* %a1ptr
  %res = call <2 x double> @llvm.x86.avx512.rsqrt14.sd(<2 x double> %a0, <2 x double> %a1, <2 x double> zeroinitializer, i8 -1) ;
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.avx512.rsqrt14.sd(<2 x double>, <2 x double>, <2 x double>, i8) nounwind readnone

define <2 x double> @test_rcp14_sd(<2 x double> %a0) {
; CHECK-LABEL: test_rcp14_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrcp14sd %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
    %res = call <2 x double> @llvm.x86.avx512.rcp14.sd(<2 x double> %a0, <2 x double> %a0, <2 x double> zeroinitializer, i8 -1) ;
    ret <2 x double> %res

}

define <2 x double> @test_rcp14_sd_load(<2 x double> %a0, <2 x double>* %a1ptr) {
; CHECK-LABEL: test_rcp14_sd_load:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vrcp14sd (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a1 = load <2 x double>, <2 x double>* %a1ptr
  %res = call <2 x double> @llvm.x86.avx512.rcp14.sd(<2 x double> %a0, <2 x double> %a1, <2 x double> zeroinitializer, i8 -1) ;
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.avx512.rcp14.sd(<2 x double>, <2 x double>, <2 x double>, i8) nounwind readnone

declare <4 x float> @llvm.x86.avx512.mask.scalef.ss(<4 x float>, <4 x float>,<4 x float>, i8, i32)
define <4 x float>@test_int_x86_avx512_mask_scalef_ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 %x4) {
; SKX-LABEL: test_int_x86_avx512_mask_scalef_ss:
; SKX:       ## BB#0:
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vscalefss %xmm1, %xmm0, %xmm2 {%k1}
; SKX-NEXT:    vscalefss {rn-sae}, %xmm1, %xmm0, %xmm0
; SKX-NEXT:    vaddps %xmm0, %xmm2, %xmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test_int_x86_avx512_mask_scalef_ss:
; KNL:       ## BB#0:
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vscalefss %xmm1, %xmm0, %xmm2 {%k1}
; KNL-NEXT:    vscalefss {rn-sae}, %xmm1, %xmm0, %xmm0
; KNL-NEXT:    vaddps %xmm0, %xmm2, %xmm0
; KNL-NEXT:    retq
    %res = call <4 x float> @llvm.x86.avx512.mask.scalef.ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 %x4, i32 4)
    %res1 = call <4 x float> @llvm.x86.avx512.mask.scalef.ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 -1, i32 8)
    %res2 = fadd <4 x float> %res, %res1
    ret <4 x float> %res2
}

define <4 x float>@test_int_x86_avx512_mask_scalef_ss_load(<4 x float> %x0, <4 x float>* %x1ptr) {
; CHECK-LABEL: test_int_x86_avx512_mask_scalef_ss_load:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vscalefss (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x1 = load <4 x float>, <4 x float>* %x1ptr
  %res = call <4 x float> @llvm.x86.avx512.mask.scalef.ss(<4 x float> %x0, <4 x float> %x1, <4 x float> undef, i8 -1, i32 4)
  ret <4 x float> %res
}

declare <2 x double> @llvm.x86.avx512.mask.scalef.sd(<2 x double>, <2 x double>,<2 x double>, i8, i32)
define <2 x double>@test_int_x86_avx512_mask_scalef_sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 %x4) {
; SKX-LABEL: test_int_x86_avx512_mask_scalef_sd:
; SKX:       ## BB#0:
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vscalefsd %xmm1, %xmm0, %xmm2 {%k1}
; SKX-NEXT:    vscalefsd {rn-sae}, %xmm1, %xmm0, %xmm0
; SKX-NEXT:    vaddpd %xmm0, %xmm2, %xmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test_int_x86_avx512_mask_scalef_sd:
; KNL:       ## BB#0:
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vscalefsd %xmm1, %xmm0, %xmm2 {%k1}
; KNL-NEXT:    vscalefsd {rn-sae}, %xmm1, %xmm0, %xmm0
; KNL-NEXT:    vaddpd %xmm0, %xmm2, %xmm0
; KNL-NEXT:    retq
    %res = call <2 x double> @llvm.x86.avx512.mask.scalef.sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 %x4, i32 4)
    %res1 = call <2 x double> @llvm.x86.avx512.mask.scalef.sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 -1, i32 8)
    %res2 = fadd <2 x double> %res, %res1
    ret <2 x double> %res2
}

define <2 x double>@test_int_x86_avx512_mask_scalef_sd_load(<2 x double> %x0, <2 x double>* %x1ptr) {
; CHECK-LABEL: test_int_x86_avx512_mask_scalef_sd_load:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vscalefsd (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x1 = load <2 x double>, <2 x double>* %x1ptr
  %res = call <2 x double> @llvm.x86.avx512.mask.scalef.sd(<2 x double> %x0, <2 x double> %x1, <2 x double> undef, i8 -1, i32 4)
  ret <2 x double> %res
}
