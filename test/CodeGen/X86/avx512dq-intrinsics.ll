; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512dq | FileCheck %s

declare <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvt_pd2qq_512(<8 x double> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_pd2qq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtpd2qq {ru-sae}, %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvtpd2qq {rn-sae}, %zmm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double> %x0, <8 x i64> %x1, i8 %x2, i32 2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double> %x0, <8 x i64> %x1, i8 -1, i32 0)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x i64> @llvm.x86.avx512.mask.cvtpd2uqq.512(<8 x double>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvt_pd2uqq_512(<8 x double> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_pd2uqq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtpd2uqq {ru-sae}, %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvtpd2uqq {rn-sae}, %zmm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvtpd2uqq.512(<8 x double> %x0, <8 x i64> %x1, i8 %x2, i32 2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvtpd2uqq.512(<8 x double> %x0, <8 x i64> %x1, i8 -1, i32 0)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x i64> @llvm.x86.avx512.mask.cvtps2qq.512(<8 x float>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvt_ps2qq_512(<8 x float> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_ps2qq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtps2qq {ru-sae}, %ymm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvtps2qq {rn-sae}, %ymm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvtps2qq.512(<8 x float> %x0, <8 x i64> %x1, i8 %x2, i32 2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvtps2qq.512(<8 x float> %x0, <8 x i64> %x1, i8 -1, i32 0)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x i64> @llvm.x86.avx512.mask.cvtps2uqq.512(<8 x float>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvt_ps2uqq_512(<8 x float> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_ps2uqq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtps2uqq {ru-sae}, %ymm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvtps2uqq {rn-sae}, %ymm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvtps2uqq.512(<8 x float> %x0, <8 x i64> %x1, i8 %x2, i32 2)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvtps2uqq.512(<8 x float> %x0, <8 x i64> %x1, i8 -1, i32 0)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x double> @llvm.x86.avx512.mask.cvtqq2pd.512(<8 x i64>, <8 x double>, i8, i32)

define <8 x double>@test_int_x86_avx512_mask_cvt_qq2pd_512(<8 x i64> %x0, <8 x double> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_qq2pd_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtqq2pd %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvtqq2pd {rn-sae}, %zmm0, %zmm0
; CHECK-NEXT:    vaddpd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x double> @llvm.x86.avx512.mask.cvtqq2pd.512(<8 x i64> %x0, <8 x double> %x1, i8 %x2, i32 4)
  %res1 = call <8 x double> @llvm.x86.avx512.mask.cvtqq2pd.512(<8 x i64> %x0, <8 x double> %x1, i8 -1, i32 0)
  %res2 = fadd <8 x double> %res, %res1
  ret <8 x double> %res2
}

declare <8 x float> @llvm.x86.avx512.mask.cvtqq2ps.512(<8 x i64>, <8 x float>, i8, i32)

define <8 x float>@test_int_x86_avx512_mask_cvt_qq2ps_512(<8 x i64> %x0, <8 x float> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_qq2ps_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtqq2ps %zmm0, %ymm1 {%k1}
; CHECK-NEXT:    vcvtqq2ps {rn-sae}, %zmm0, %ymm0
; CHECK-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x float> @llvm.x86.avx512.mask.cvtqq2ps.512(<8 x i64> %x0, <8 x float> %x1, i8 %x2, i32 4)
  %res1 = call <8 x float> @llvm.x86.avx512.mask.cvtqq2ps.512(<8 x i64> %x0, <8 x float> %x1, i8 -1, i32 0)
  %res2 = fadd <8 x float> %res, %res1
  ret <8 x float> %res2
}

declare <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvtt_pd2qq_512(<8 x double> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvtt_pd2qq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvttpd2qq %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvttpd2qq {sae}, %zmm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double> %x0, <8 x i64> %x1, i8 %x2, i32 4)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double> %x0, <8 x i64> %x1, i8 -1, i32 8)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.512(<8 x double>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvtt_pd2uqq_512(<8 x double> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvtt_pd2uqq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvttpd2uqq %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvttpd2uqq {sae}, %zmm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.512(<8 x double> %x0, <8 x i64> %x1, i8 %x2, i32 4)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.512(<8 x double> %x0, <8 x i64> %x1, i8 -1, i32 8)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x i64> @llvm.x86.avx512.mask.cvttps2qq.512(<8 x float>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvtt_ps2qq_512(<8 x float> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvtt_ps2qq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvttps2qq %ymm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvttps2qq {sae}, %ymm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvttps2qq.512(<8 x float> %x0, <8 x i64> %x1, i8 %x2, i32 4)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvttps2qq.512(<8 x float> %x0, <8 x i64> %x1, i8 -1, i32 8)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x i64> @llvm.x86.avx512.mask.cvttps2uqq.512(<8 x float>, <8 x i64>, i8, i32)

define <8 x i64>@test_int_x86_avx512_mask_cvtt_ps2uqq_512(<8 x float> %x0, <8 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvtt_ps2uqq_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvttps2uqq %ymm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvttps2uqq {sae}, %ymm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.cvttps2uqq.512(<8 x float> %x0, <8 x i64> %x1, i8 %x2, i32 4)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.cvttps2uqq.512(<8 x float> %x0, <8 x i64> %x1, i8 -1, i32 8)
  %res2 = add <8 x i64> %res, %res1
  ret <8 x i64> %res2
}

declare <8 x double> @llvm.x86.avx512.mask.cvtuqq2pd.512(<8 x i64>, <8 x double>, i8, i32)

define <8 x double>@test_int_x86_avx512_mask_cvt_uqq2pd_512(<8 x i64> %x0, <8 x double> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_uqq2pd_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtuqq2pd %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vcvtuqq2pd {rn-sae}, %zmm0, %zmm0
; CHECK-NEXT:    vaddpd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x double> @llvm.x86.avx512.mask.cvtuqq2pd.512(<8 x i64> %x0, <8 x double> %x1, i8 %x2, i32 4)
  %res1 = call <8 x double> @llvm.x86.avx512.mask.cvtuqq2pd.512(<8 x i64> %x0, <8 x double> %x1, i8 -1, i32 0)
  %res2 = fadd <8 x double> %res, %res1
  ret <8 x double> %res2
}

declare <8 x float> @llvm.x86.avx512.mask.cvtuqq2ps.512(<8 x i64>, <8 x float>, i8, i32)

define <8 x float>@test_int_x86_avx512_mask_cvt_uqq2ps_512(<8 x i64> %x0, <8 x float> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_cvt_uqq2ps_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vcvtuqq2ps %zmm0, %ymm1 {%k1}
; CHECK-NEXT:    vcvtuqq2ps {rn-sae}, %zmm0, %ymm0
; CHECK-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x float> @llvm.x86.avx512.mask.cvtuqq2ps.512(<8 x i64> %x0, <8 x float> %x1, i8 %x2, i32 4)
  %res1 = call <8 x float> @llvm.x86.avx512.mask.cvtuqq2ps.512(<8 x i64> %x0, <8 x float> %x1, i8 -1, i32 0)
  %res2 = fadd <8 x float> %res, %res1
  ret <8 x float> %res2
}

declare <8 x double> @llvm.x86.avx512.mask.reduce.pd.512(<8 x double>, i32, <8 x double>, i8, i32)

define <8 x double>@test_int_x86_avx512_mask_reduce_pd_512(<8 x double> %x0, <8 x double> %x2, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_reduce_pd_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vreducepd $8, %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vreducepd $4, {sae}, %zmm0, %zmm0
; CHECK-NEXT:    vaddpd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x double> @llvm.x86.avx512.mask.reduce.pd.512(<8 x double> %x0, i32 8, <8 x double> %x2, i8 %x3, i32 4)
  %res1 = call <8 x double> @llvm.x86.avx512.mask.reduce.pd.512(<8 x double> %x0, i32 4, <8 x double> %x2, i8 -1, i32 8)
  %res2 = fadd <8 x double> %res, %res1
  ret <8 x double> %res2
}

declare <16 x float> @llvm.x86.avx512.mask.reduce.ps.512(<16 x float>, i32, <16 x float>, i16, i32)

define <16 x float>@test_int_x86_avx512_mask_reduce_ps_512(<16 x float> %x0, <16 x float> %x2, i16 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_reduce_ps_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vreduceps $44, {sae}, %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vreduceps $11, %zmm0, %zmm0
; CHECK-NEXT:    vaddps %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x float> @llvm.x86.avx512.mask.reduce.ps.512(<16 x float> %x0, i32 44, <16 x float> %x2, i16 %x3, i32 8)
  %res1 = call <16 x float> @llvm.x86.avx512.mask.reduce.ps.512(<16 x float> %x0, i32 11, <16 x float> %x2, i16 -1, i32 4)
  %res2 = fadd <16 x float> %res, %res1
  ret <16 x float> %res2
}

declare <8 x double> @llvm.x86.avx512.mask.range.pd.512(<8 x double>, <8 x double>, i32, <8 x double>, i8, i32)

define <8 x double>@test_int_x86_avx512_mask_range_pd_512(<8 x double> %x0, <8 x double> %x1, <8 x double> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_range_pd_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vrangepd $8, %zmm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vrangepd $4, {sae}, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vaddpd %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x double> @llvm.x86.avx512.mask.range.pd.512(<8 x double> %x0, <8 x double> %x1, i32 8, <8 x double> %x3, i8 %x4, i32 4)
  %res1 = call <8 x double> @llvm.x86.avx512.mask.range.pd.512(<8 x double> %x0, <8 x double> %x1, i32 4, <8 x double> %x3, i8 -1, i32 8)
  %res2 = fadd <8 x double> %res, %res1
  ret <8 x double> %res2
}

declare <16 x float> @llvm.x86.avx512.mask.range.ps.512(<16 x float>, <16 x float>, i32, <16 x float>, i16, i32)

define <16 x float>@test_int_x86_avx512_mask_range_ps_512(<16 x float> %x0, <16 x float> %x1, <16 x float> %x3, i16 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_range_ps_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vrangeps $88, %zmm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vrangeps $4, {sae}, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vaddps %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x float> @llvm.x86.avx512.mask.range.ps.512(<16 x float> %x0, <16 x float> %x1, i32 88, <16 x float> %x3, i16 %x4, i32 4)
  %res1 = call <16 x float> @llvm.x86.avx512.mask.range.ps.512(<16 x float> %x0, <16 x float> %x1, i32 4, <16 x float> %x3, i16 -1, i32 8)
  %res2 = fadd <16 x float> %res, %res1
  ret <16 x float> %res2
}

declare <4 x float> @llvm.x86.avx512.mask.reduce.ss(<4 x float>, <4 x float>,<4 x float>, i8, i32, i32)

define <4 x float>@test_int_x86_avx512_mask_reduce_ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_reduce_ss:
; CHECK:       ## BB#0:
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vreducess $4, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vreducess $4, {sae}, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddps %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x float> @llvm.x86.avx512.mask.reduce.ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 %x4, i32 4, i32 4)
  %res1 = call <4 x float> @llvm.x86.avx512.mask.reduce.ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 -1, i32 4, i32 8)
  %res2 = fadd <4 x float> %res, %res1
  ret <4 x float> %res2
}

declare <4 x float> @llvm.x86.avx512.mask.range.ss(<4 x float>, <4 x float>,<4 x float>, i8, i32, i32)

define <4 x float>@test_int_x86_avx512_mask_range_ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_range_ss:
; CHECK:       ## BB#0:
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vrangess $4, {sae}, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vrangess $4, {sae}, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddps %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x float> @llvm.x86.avx512.mask.range.ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 %x4, i32 4, i32 8)
  %res1 = call <4 x float> @llvm.x86.avx512.mask.range.ss(<4 x float> %x0, <4 x float> %x1, <4 x float> %x3, i8 -1, i32 4, i32 8)
  %res2 = fadd <4 x float> %res, %res1
  ret <4 x float> %res2
}

declare <2 x double> @llvm.x86.avx512.mask.reduce.sd(<2 x double>, <2 x double>,<2 x double>, i8, i32, i32)

define <2 x double>@test_int_x86_avx512_mask_reduce_sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_reduce_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vreducesd $4, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vreducesd $4, {sae}, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddpd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x double> @llvm.x86.avx512.mask.reduce.sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 %x4, i32 4, i32 4)
  %res1 = call <2 x double> @llvm.x86.avx512.mask.reduce.sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 -1, i32 4, i32 8)
  %res2 = fadd <2 x double> %res, %res1
  ret <2 x double> %res2
}

declare <2 x double> @llvm.x86.avx512.mask.range.sd(<2 x double>, <2 x double>,<2 x double>, i8, i32, i32)

define <2 x double>@test_int_x86_avx512_mask_range_sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_range_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vrangesd $4, %xmm1, %xmm0, %xmm2 {%k1}
; CHECK-NEXT:    vrangesd $4, {sae}, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddpd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x double> @llvm.x86.avx512.mask.range.sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 %x4, i32 4, i32 4)
  %res1 = call <2 x double> @llvm.x86.avx512.mask.range.sd(<2 x double> %x0, <2 x double> %x1, <2 x double> %x3, i8 -1, i32 4, i32 8)
  %res2 = fadd <2 x double> %res, %res1
  ret <2 x double> %res2
}


declare <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double>, i32, <2 x double>, i8)

define <2 x double>@test_int_x86_avx512_mask_vextractf64x2_512(<8 x double> %x0, <2 x double> %x2, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vextractf64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vextractf64x2 $1, %zmm0, %xmm1 {%k1}
; CHECK-NEXT:    vextractf64x2 $1, %zmm0, %xmm2 {%k1} {z}
; CHECK-NEXT:    vextractf64x2 $1, %zmm0, %xmm0
; CHECK-NEXT:    vaddpd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vaddpd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double> %x0,i32 1, <2 x double> %x2, i8 %x3)
  %res2 = call <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double> %x0,i32 1, <2 x double> zeroinitializer, i8 %x3)
  %res1 = call <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double> %x0,i32 1, <2 x double> zeroinitializer, i8 -1)
  %res3 = fadd <2 x double> %res, %res1
  %res4 = fadd <2 x double> %res2, %res3
  ret <2 x double> %res4
}

declare <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float>, i32, <8 x float>, i8)

define <8 x float>@test_int_x86_avx512_mask_vextractf32x8(<16 x float> %x0, <8 x float> %x2, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vextractf32x8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vextractf32x8 $1, %zmm0, %ymm1 {%k1}
; CHECK-NEXT:    vextractf32x8 $1, %zmm0, %ymm2 {%k1} {z}
; CHECK-NEXT:    vextractf32x8 $1, %zmm0, %ymm0
; CHECK-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    vaddps %ymm0, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %res  = call <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float> %x0,i32 1, <8 x float> %x2, i8 %x3)
  %res2 = call <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float> %x0,i32 1, <8 x float> zeroinitializer, i8 %x3)
  %res1 = call <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float> %x0,i32 1, <8 x float> zeroinitializer, i8 -1)
  %res3 = fadd <8 x float> %res, %res1
  %res4 = fadd <8 x float> %res2, %res3
  ret <8 x float> %res4
}

declare <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float>, <8 x float>, i32, <16 x float>, i16)

define <16 x float>@test_int_x86_avx512_mask_insertf32x8_512(<16 x float> %x0, <8 x float> %x1, <16 x float> %x3, i16 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_insertf32x8_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm3 {%k1} {z}
; CHECK-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm0
; CHECK-NEXT:    vaddps %zmm3, %zmm2, %zmm1
; CHECK-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float> %x0, <8 x float> %x1, i32 1, <16 x float> %x3, i16 %x4)
  %res1 = call <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float> %x0, <8 x float> %x1, i32 1, <16 x float> zeroinitializer, i16 %x4)
  %res2 = call <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float> %x0, <8 x float> %x1, i32 1, <16 x float> %x3, i16 -1)
  %res3 = fadd <16 x float> %res, %res1
  %res4 = fadd <16 x float> %res2, %res3
  ret <16 x float> %res4
}

declare <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double>, <2 x double>, i32, <8 x double>, i8)

define <8 x double>@test_int_x86_avx512_mask_insertf64x2_512(<8 x double> %x0, <2 x double> %x1,<8 x double> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_insertf64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vinsertf64x2 $1, %xmm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinsertf64x2 $1, %xmm1, %zmm0, %zmm3 {%k1} {z}
; CHECK-NEXT:    vinsertf64x2 $1, %xmm1, %zmm0, %zmm0
; CHECK-NEXT:    vaddpd %zmm3, %zmm2, %zmm1
; CHECK-NEXT:    vaddpd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double> %x0, <2 x double> %x1, i32 1, <8 x double> %x3, i8 %x4)
  %res1 = call <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double> %x0, <2 x double> %x1, i32 1, <8 x double> zeroinitializer, i8 %x4)
  %res2 = call <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double> %x0, <2 x double> %x1, i32 1, <8 x double> %x3, i8 -1)
  %res3 = fadd <8 x double> %res, %res1
  %res4 = fadd <8 x double> %res3, %res2
  ret <8 x double> %res4
}

declare <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32>, <8 x i32>, i32, <16 x i32>, i16)

define <16 x i32>@test_int_x86_avx512_mask_inserti32x8_512(<16 x i32> %x0, <8 x i32> %x1, <16 x i32> %x3, i16 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_inserti32x8_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm3 {%k1} {z}
; CHECK-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm0
; CHECK-NEXT:    vpaddd %zmm3, %zmm2, %zmm1
; CHECK-NEXT:    vpaddd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32> %x0, <8 x i32> %x1, i32 1, <16 x i32> %x3, i16 %x4)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32> %x0, <8 x i32> %x1, i32 1, <16 x i32> zeroinitializer, i16 %x4)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32> %x0, <8 x i32> %x1, i32 1, <16 x i32> %x3, i16 -1)
  %res3 = add <16 x i32> %res, %res1
  %res4 = add <16 x i32> %res3, %res2
  ret <16 x i32> %res4
}

declare <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64>, <2 x i64>, i32, <8 x i64>, i8)

define <8 x i64>@test_int_x86_avx512_mask_inserti64x2_512(<8 x i64> %x0, <2 x i64> %x1, <8 x i64> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_inserti64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vinserti64x2 $1, %xmm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinserti64x2 $1, %xmm1, %zmm0, %zmm3 {%k1} {z}
; CHECK-NEXT:    vinserti64x2 $1, %xmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm3, %zmm2, %zmm1
; CHECK-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64> %x0, <2 x i64> %x1, i32 1, <8 x i64> %x3, i8 %x4)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64> %x0, <2 x i64> %x1, i32 1, <8 x i64> zeroinitializer, i8 %x4)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64> %x0, <2 x i64> %x1, i32 1, <8 x i64> %x3, i8 -1)
  %res3 = add <8 x i64> %res, %res1
  %res4 = add <8 x i64> %res2, %res3
  ret <8 x i64> %res4
}

declare i8 @llvm.x86.avx512.mask.fpclass.pd.512(<8 x double>, i32, i8)

define i8 @test_int_x86_avx512_mask_fpclass_pd_512(<8 x double> %x0, i8 %x1) {
; CHECK-LABEL: test_int_x86_avx512_mask_fpclass_pd_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vfpclasspd $2, %zmm0, %k0 {%k1}
; CHECK-NEXT:    kmovb %k0, %ecx
; CHECK-NEXT:    vfpclasspd $4, %zmm0, %k0
; CHECK-NEXT:    kmovb %k0, %eax
; CHECK-NEXT:    addb %cl, %al
; CHECK-NEXT:    retq
    %res = call i8 @llvm.x86.avx512.mask.fpclass.pd.512(<8 x double> %x0, i32 2, i8 %x1)
    %res1 = call i8 @llvm.x86.avx512.mask.fpclass.pd.512(<8 x double> %x0, i32 4, i8 -1)
    %res2 = add i8 %res, %res1
    ret i8 %res2
}
declare i16 @llvm.x86.avx512.mask.fpclass.ps.512(<16 x float>, i32, i16)

define i16@test_int_x86_avx512_mask_fpclass_ps_512(<16 x float> %x0, i16 %x1) {
; CHECK-LABEL: test_int_x86_avx512_mask_fpclass_ps_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vfpclassps $4, %zmm0, %k0 {%k1}
; CHECK-NEXT:    kmovw %k0, %ecx
; CHECK-NEXT:    vfpclassps $4, %zmm0, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    ## kill: %AX<def> %AX<kill> %EAX<kill>
; CHECK-NEXT:    retq
    %res = call i16 @llvm.x86.avx512.mask.fpclass.ps.512(<16 x float> %x0, i32 4, i16 %x1)
    %res1 = call i16 @llvm.x86.avx512.mask.fpclass.ps.512(<16 x float> %x0, i32 4, i16 -1)
    %res2 = add i16 %res, %res1
    ret i16 %res2
}

declare i8 @llvm.x86.avx512.mask.fpclass.sd(<2 x double>, i32, i8)

define i8 @test_int_x86_avx512_mask_fpclass_sd(<2 x double> %x0, i8 %x1) {
; CHECK-LABEL: test_int_x86_avx512_mask_fpclass_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vfpclasssd $2, %xmm0, %k0 {%k1}
; CHECK-NEXT:    kmovw %k0, %ecx
; CHECK-NEXT:    andl $1, %ecx
; CHECK-NEXT:    vfpclasssd $4, %xmm0, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    addb %cl, %al
; CHECK-NEXT:    ## kill: %AL<def> %AL<kill> %EAX<kill>
; CHECK-NEXT:    retq
  %res = call i8 @llvm.x86.avx512.mask.fpclass.sd(<2 x double> %x0, i32 2, i8 %x1)
  %res1 = call i8 @llvm.x86.avx512.mask.fpclass.sd(<2 x double> %x0, i32 4, i8 -1)
  %res2 = add i8 %res, %res1
  ret i8 %res2
}

declare i8 @llvm.x86.avx512.mask.fpclass.ss(<4 x float>, i32, i8)

define i8 @test_int_x86_avx512_mask_fpclass_ss(<4 x float> %x0, i8 %x1) {
; CHECK-LABEL: test_int_x86_avx512_mask_fpclass_ss:
; CHECK:       ## BB#0:
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vfpclassss $4, %xmm0, %k0 {%k1}
; CHECK-NEXT:    kmovw %k0, %ecx
; CHECK-NEXT:    andl $1, %ecx
; CHECK-NEXT:    vfpclassss $4, %xmm0, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    addb %cl, %al
; CHECK-NEXT:    ## kill: %AL<def> %AL<kill> %EAX<kill>
; CHECK-NEXT:    retq
  %res = call i8 @llvm.x86.avx512.mask.fpclass.ss(<4 x float> %x0, i32 4, i8 %x1)
  %res1 = call i8 @llvm.x86.avx512.mask.fpclass.ss(<4 x float> %x0, i32 4, i8 -1)
  %res2 = add i8 %res, %res1
  ret i8 %res2
}

declare <16 x float> @llvm.x86.avx512.mask.broadcastf32x2.512(<4 x float>, <16 x float>, i16)

define <16 x float>@test_int_x86_avx512_mask_broadcastf32x2_512(<4 x float> %x0, <16 x float> %x2, i16 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_broadcastf32x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vbroadcastf32x2 %xmm0, %zmm1 {%k1}
; CHECK-NEXT:    vbroadcastf32x2 %xmm0, %zmm2 {%k1} {z}
; CHECK-NEXT:    vbroadcastf32x2 %xmm0, %zmm0
; CHECK-NEXT:    vaddps %zmm2, %zmm1, %zmm1
; CHECK-NEXT:    vaddps %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x float> @llvm.x86.avx512.mask.broadcastf32x2.512(<4 x float>  %x0, <16 x float> %x2, i16 %x3)
  %res1 = call <16 x float> @llvm.x86.avx512.mask.broadcastf32x2.512(<4 x float> %x0, <16 x float> zeroinitializer, i16 %x3)
  %res2 = call <16 x float> @llvm.x86.avx512.mask.broadcastf32x2.512(<4 x float> %x0, <16 x float> %x2, i16 -1)
  %res3 = fadd <16 x float> %res, %res1
  %res4 = fadd <16 x float> %res3, %res2
  ret <16 x float> %res4
}

declare <16 x i32> @llvm.x86.avx512.mask.broadcasti32x2.512(<4 x i32>, <16 x i32>, i16)

define <16 x i32>@test_int_x86_avx512_mask_broadcasti32x2_512(<4 x i32> %x0, <16 x i32> %x2, i16 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_broadcasti32x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vbroadcasti32x2 %xmm0, %zmm1 {%k1}
; CHECK-NEXT:    vbroadcasti32x2 %xmm0, %zmm2 {%k1} {z}
; CHECK-NEXT:    vbroadcasti32x2 %xmm0, %zmm0
; CHECK-NEXT:    vpaddd %zmm2, %zmm1, %zmm1
; CHECK-NEXT:    vpaddd %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x i32> @llvm.x86.avx512.mask.broadcasti32x2.512(<4 x i32>  %x0, <16 x i32> %x2, i16 %x3)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.broadcasti32x2.512(<4 x i32> %x0, <16 x i32> zeroinitializer, i16 %x3)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.broadcasti32x2.512(<4 x i32> %x0, <16 x i32> %x2, i16 -1)
  %res3 = add <16 x i32> %res, %res1
  %res4 = add <16 x i32> %res3, %res2
  ret <16 x i32> %res4
}

declare i16 @llvm.x86.avx512.cvtd2mask.512(<16 x i32>)

define i16@test_int_x86_avx512_cvtd2mask_512(<16 x i32> %x0) {
; CHECK-LABEL: test_int_x86_avx512_cvtd2mask_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovd2m %zmm0, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    retq
  %res = call i16 @llvm.x86.avx512.cvtd2mask.512(<16 x i32> %x0)
  ret i16 %res
}

declare i8 @llvm.x86.avx512.cvtq2mask.512(<8 x i64>)

define i8@test_int_x86_avx512_cvtq2mask_512(<8 x i64> %x0) {
; CHECK-LABEL: test_int_x86_avx512_cvtq2mask_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovq2m %zmm0, %k0
; CHECK-NEXT:    kmovb %k0, %eax
; CHECK-NEXT:    retq
  %res = call i8 @llvm.x86.avx512.cvtq2mask.512(<8 x i64> %x0)
  ret i8 %res
}

declare <16 x i32> @llvm.x86.avx512.cvtmask2d.512(i16)

define <16 x i32>@test_int_x86_avx512_cvtmask2d_512(i16 %x0) {
; CHECK-LABEL: test_int_x86_avx512_cvtmask2d_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k0
; CHECK-NEXT:    vpmovm2d %k0, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x i32> @llvm.x86.avx512.cvtmask2d.512(i16 %x0)
  ret <16 x i32> %res
}

declare <8 x i64> @llvm.x86.avx512.cvtmask2q.512(i8)

define <8 x i64>@test_int_x86_avx512_cvtmask2q_512(i8 %x0) {
; CHECK-LABEL: test_int_x86_avx512_cvtmask2q_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovb %edi, %k0
; CHECK-NEXT:    vpmovm2q %k0, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.cvtmask2q.512(i8 %x0)
  ret <8 x i64> %res
}

declare <16 x float> @llvm.x86.avx512.mask.broadcastf32x8.512(<8 x float>, <16 x float>, i16)

define <16 x float>@test_int_x86_avx512_mask_broadcastf32x8_512(<8 x float> %x0, <16 x float> %x2, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512_mask_broadcastf32x8_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %YMM0<def> %YMM0<kill> %ZMM0<def>
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vshuff32x4 {{.*#+}} zmm2 {%k1} {z} = zmm0[0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7]
; CHECK-NEXT:    vshuff32x4 {{.*#+}} zmm1 {%k1} = zmm0[0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7]
; CHECK-NEXT:    vshuff32x4 {{.*#+}} zmm0 = zmm0[0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7]
; CHECK-NEXT:    vaddps %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vaddps %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    retq

  %res1 = call <16 x float> @llvm.x86.avx512.mask.broadcastf32x8.512(<8 x float> %x0, <16 x float> %x2, i16 -1)
  %res2 = call <16 x float> @llvm.x86.avx512.mask.broadcastf32x8.512(<8 x float> %x0, <16 x float> %x2, i16 %mask)
  %res3 = call <16 x float> @llvm.x86.avx512.mask.broadcastf32x8.512(<8 x float> %x0, <16 x float> zeroinitializer, i16 %mask)
  %res4 = fadd <16 x float> %res1, %res2
  %res5 = fadd <16 x float> %res3, %res4
  ret <16 x float> %res5
}

declare <8 x double> @llvm.x86.avx512.mask.broadcastf64x2.512(<2 x double>, <8 x double>, i8)

define <8 x double>@test_int_x86_avx512_mask_broadcastf64x2_512(<2 x double> %x0, <8 x double> %x2, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512_mask_broadcastf64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %ZMM0<def>
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vshuff64x2 {{.*#+}} zmm2 {%k1} {z} = zmm0[0,1,0,1,0,1,0,1]
; CHECK-NEXT:    vshuff64x2 {{.*#+}} zmm1 {%k1} = zmm0[0,1,0,1,0,1,0,1]
; CHECK-NEXT:    vshuff64x2 {{.*#+}} zmm0 = zmm0[0,1,0,1,0,1,0,1]
; CHECK-NEXT:    vaddpd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vaddpd %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    retq

  %res1 = call <8 x double> @llvm.x86.avx512.mask.broadcastf64x2.512(<2 x double> %x0, <8 x double> %x2, i8 -1)
  %res2 = call <8 x double> @llvm.x86.avx512.mask.broadcastf64x2.512(<2 x double> %x0, <8 x double> %x2, i8 %mask)
  %res3 = call <8 x double> @llvm.x86.avx512.mask.broadcastf64x2.512(<2 x double> %x0, <8 x double> zeroinitializer, i8 %mask)
  %res4 = fadd <8 x double> %res1, %res2
  %res5 = fadd <8 x double> %res3, %res4
  ret <8 x double> %res5
}

declare <16 x i32> @llvm.x86.avx512.mask.broadcasti32x8.512(<8 x i32>, <16 x i32>, i16)

define <16 x i32>@test_int_x86_avx512_mask_broadcasti32x8_512(<8 x i32> %x0, <16 x i32> %x2, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512_mask_broadcasti32x8_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %YMM0<def> %YMM0<kill> %ZMM0<def>
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vshufi32x4 {{.*#+}} zmm2 {%k1} {z} = zmm0[0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7]
; CHECK-NEXT:    vshufi32x4 {{.*#+}} zmm1 {%k1} = zmm0[0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7]
; CHECK-NEXT:    vshufi32x4 {{.*#+}} zmm0 = zmm0[0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7]
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpaddd %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    retq

  %res1 = call <16 x i32> @llvm.x86.avx512.mask.broadcasti32x8.512(<8 x i32> %x0, <16 x i32> %x2, i16 -1)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.broadcasti32x8.512(<8 x i32> %x0, <16 x i32> %x2, i16 %mask)
  %res3 = call <16 x i32> @llvm.x86.avx512.mask.broadcasti32x8.512(<8 x i32> %x0, <16 x i32> zeroinitializer, i16 %mask)
  %res4 = add <16 x i32> %res1, %res2
  %res5 = add <16 x i32> %res3, %res4
  ret <16 x i32> %res5
}

declare <8 x i64> @llvm.x86.avx512.mask.broadcasti64x2.512(<2 x i64>, <8 x i64>, i8)

define <8 x i64>@test_int_x86_avx512_mask_broadcasti64x2_512(<2 x i64> %x0, <8 x i64> %x2, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512_mask_broadcasti64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    ## kill: %XMM0<def> %XMM0<kill> %ZMM0<def>
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vshufi64x2 {{.*#+}} zmm2 {%k1} {z} = zmm0[0,1,0,1,0,1,0,1]
; CHECK-NEXT:    vshufi64x2 {{.*#+}} zmm1 {%k1} = zmm0[0,1,0,1,0,1,0,1]
; CHECK-NEXT:    vshufi64x2 {{.*#+}} zmm0 = zmm0[0,1,0,1,0,1,0,1]
; CHECK-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    retq

  %res1 = call <8 x i64> @llvm.x86.avx512.mask.broadcasti64x2.512(<2 x i64> %x0, <8 x i64> %x2, i8 -1)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.broadcasti64x2.512(<2 x i64> %x0, <8 x i64> %x2, i8 %mask)
  %res3 = call <8 x i64> @llvm.x86.avx512.mask.broadcasti64x2.512(<2 x i64> %x0, <8 x i64> zeroinitializer, i8 %mask)
  %res4 = add <8 x i64> %res1, %res2
  %res5 = add <8 x i64> %res3, %res4
  ret <8 x i64> %res5
}
